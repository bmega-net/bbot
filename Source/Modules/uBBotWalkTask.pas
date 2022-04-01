unit uBBotWalkTask;

interface

uses uBTypes, uBVector, uTibiaDeclarations, uAStar, uBattlelist;

type
  TBBotAStarPosition = class(TAStar)
  private
    FDistance: BUInt32;
    FTarget: BPos;
    FMaxRadiusDistance: BUInt32;
  public
    property Target: BPos read FTarget write FTarget;
    property Distance: BUInt32 read FDistance write FDistance;
    property MaxRadiusDistance: BUInt32 read FMaxRadiusDistance
      write FMaxRadiusDistance;

    function GetHeuristic(Node: TAStarNode): BUInt32; override;
    function GetTarget(Node: TAStarNode): BBool; override;
    procedure GetNeightbors(Node: TAStarNode); override;
    function GetTileCost(P: BPos): BInt32; override;
    procedure OnDebug(Node: TAStarNode); override;
  end;

  TBBotAStarKeepDistance = class(TBBotAStarPosition)
  public
    function GetHeuristic(Node: TAStarNode): BUInt32; override;
  end;

  TBBotWalkBase = class
  private
    FPath: BVector<BPos>;
    FFailed: BBool;
    FSucess: BBool;
    FMaxRadiusDistance: BUInt32;
    function GetDone: BBool;
    procedure SetFailed(const Value: BBool);
    procedure SetSucess(const Value: BBool);
    function GetCost: BInt32;
    function GetRunning: BBool;
  protected
    AStar: TBBotAStarPosition;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Walk; virtual;
    procedure RePath; virtual; abstract;
    procedure Reset;
    procedure Stop; virtual; abstract;

    property Done: BBool read GetDone;
    property Running: BBool read GetRunning;
    property Sucess: BBool read FSucess write SetSucess;
    property Failed: BBool read FFailed write SetFailed;

    property Path: BVector<BPos> read FPath;
    property MaxRadiusDistance: BUInt32 read FMaxRadiusDistance
      write FMaxRadiusDistance;
    property Cost: BInt32 read GetCost;
  end;

  TBBotWalkPosition = class(TBBotWalkBase)
  private
    FDistance: BUInt32;
    FTarget: BPos;
  public
    constructor Create;
    destructor Destroy; override;

    property Target: BPos read FTarget write FTarget;
    property Distance: BUInt32 read FDistance write FDistance;

    procedure Walk; override;
    procedure RePath; override;
    procedure Stop; override;
  end;

  TBBotWalkCreature = class(TBBotWalkBase)
  private
    FCreatureID: BInt32;
    FDistance: BUInt32;
    function GetCreature: TBBotCreature;
  public
    constructor Create;
    destructor Destroy; override;

    property CreatureID: BInt32 read FCreatureID write FCreatureID;
    property Creature: TBBotCreature read GetCreature;
    property Distance: BUInt32 read FDistance write FDistance;

    procedure Walk; override;

    procedure RePath; override;
    procedure Stop; override;
  end;

procedure BotCreateWalkCache;
procedure BotDestroyWalkCache;
function WalkableCost(X, Y, Z: BInt32): BInt32;

implementation

uses BBotEngine, uDistance, uHUD, uEngine, uBTree, uTiles;

type
  PWalkCacheRec = ^TWalkCacheRec;

  TWalkCacheRec = record
    X, Y, Z, C: BInt32;
  end;

var
  WalkCache: BBinaryTree<PWalkCacheRec>;

function _ComparePosition(A, B: PWalkCacheRec): BBinaryTreeCompareResult;
begin
  if (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) then
    Result := btdEqual
  else if (A.Z > B.Z) or (A.Y > B.Y) or (A.X > B.X) then
    Result := btdBigger
  else
    Result := btdSmaller;
end;

procedure _FreePosition(A: PWalkCacheRec);
begin
  Dispose(A);
end;

procedure BotCreateWalkCache;
begin
  WalkCache := BBinaryTree<PWalkCacheRec>.Create(_FreePosition,
    _ComparePosition);
end;

procedure BotDestroyWalkCache;
begin
  WalkCache.Free;
end;

procedure WalkAddCache(X, Y, Z, C: BInt32);
var
  D: PWalkCacheRec;
begin
  New(D);
  D.X := X;
  D.Y := Y;
  D.Z := Z;
  D.C := C;
  WalkCache.Add(D);
end;

function WalkCacheValue(X, Y, Z: BInt32): BInt32;
var
  D: TWalkCacheRec;
  N: BBinaryTreeNode<PWalkCacheRec>;
begin
  D.X := X;
  D.Y := Y;
  D.Z := Z;
  N := WalkCache.Search(@D);
  if N <> nil then
    Result := N.Data.C
  else
    Result := Cost_NotWalkable;
end;

function WalkableCost(X, Y, Z: BInt32): BInt32;
var
  M: TTibiaTiles;
begin
  if Z <> Me.Position.Z then
    Exit(Cost_NotWalkable);
  if Tiles(M, X, Y) then
  begin
    Result := M.Cost;
    WalkAddCache(X, Y, Z, Result);
    Exit;
  end;
  Result := WalkCacheValue(X, Y, Z);
end;

procedure _AddNodeToList(P: BPos; Param: Pointer);
begin
  BVector<BPos>(Param).Add(P);
end;

{ TBBotWalkBase }

constructor TBBotWalkBase.Create;
begin
  FPath := BVector<BPos>.Create;
  Reset;
  FMaxRadiusDistance := 0;
end;

destructor TBBotWalkBase.Destroy;
begin
  FPath.Free;
  inherited;
end;

function TBBotWalkBase.GetCost: BInt32;
begin
  Result := AStar.Cost;
end;

function TBBotWalkBase.GetDone: BBool;
begin
  Result := FSucess or FFailed;
end;

function TBBotWalkBase.GetRunning: BBool;
begin
  Result := not GetDone;
end;

procedure TBBotWalkBase.Reset;
begin
  Path.Clear;
  FFailed := False;
  FSucess := False;
end;

procedure TBBotWalkBase.SetFailed(const Value: BBool);
begin
  Reset;
  FFailed := Value;
end;

procedure TBBotWalkBase.SetSucess(const Value: BBool);
begin
  Reset;
  FSucess := Value;
end;

procedure TBBotWalkBase.Walk;
var
  I, DX, DY: BInt32;
  P: BPos;
begin
  if Running then
  begin
    if (Path.Count > 0) and (Path[0]^.Z = Me.Position.Z) then
      if BBot.Walker.MapClick then
      begin
        Tibia.SetMove(Path[0]^);
        Exit;
      end
      else
        for I := Path.Count - 1 downto 1 do
          if Me.Position = Path[I]^ then
          begin
            P := Path[I - 1]^;
            if WalkableCost(P.X, P.Y, P.Z) <> Cost_NotWalkable then
            begin
              DX := P.X - Me.Position.X;
              DY := P.Y - Me.Position.Y;
              BBot.Walker.Step(DX, DY);
              Exit;
            end;
          end;
    RePath;
  end;
end;

{ TBBotAStarPosition }

function TBBotAStarPosition.GetHeuristic(Node: TAStarNode): BUInt32;
var
  H: BUInt32;
  X, Y: BInt32;
  F: BBool;
begin
  Result := 0;
  F := True;
  for X := -Distance to +Distance do
    for Y := -Distance to +Distance do
      if (BUInt32(BAbs(X)) = Distance) or (BUInt32(BAbs(Y)) = Distance) then
      begin
        H := BUInt32(DiagonalDistance(Node.Position.X, Node.Position.Y,
          Target.X + X, Target.Y + Y, Cost_Diagonal * Cost_Normal,
          Cost_Straight * Cost_Normal));
        if F or (H < Result) then
        begin
          Result := H;
          F := False;
        end;
      end;
end;

procedure TBBotAStarPosition.GetNeightbors(Node: TAStarNode);
var
  X, Y: BInt32;
  P: BPos;
begin
  for X := -1 to +1 do
    for Y := -1 to +1 do
      if (X <> 0) or (Y <> 0) then
      begin
        P.X := Node.Position.X + X;
        P.Y := Node.Position.Y + Y;
        P.Z := Node.Position.Z;
        if (FMaxRadiusDistance = 0) or
          (BUInt32(SQMDistance(Origin.X, Origin.Y, P.X, P.Y)) <
          FMaxRadiusDistance) then
          AddNode(P, Node);
      end;
end;

function TBBotAStarPosition.GetTarget(Node: TAStarNode): BBool;
begin
  Result := BUInt32(SQMDistance(Node.Position.X, Node.Position.Y, Target.X,
    Target.Y)) = Distance;
end;

function TBBotAStarPosition.GetTileCost(P: BPos): BInt32;
begin
  Result := WalkableCost(P.X, P.Y, P.Z);
  if (Result >= Cost_ExtremeAvoid) and ((Distance <> 0) or (Target <> P)) then
    Result := Cost_NotWalkable;
end;

procedure TBBotAStarPosition.OnDebug(Node: TAStarNode);
var
  HUD: TBBotHUD;
begin
  if Engine.Debug.Path then
  begin
    if Node = nil then
    begin
      HUDRemoveGroup(bhgDebugAStar);
      Exit;
    end;
    HUDRemovePositionGroup(Node.Position.X, Node.Position.Y, Node.Position.Z,
      bhgDebugAStar);
    HUD := TBBotHUD.Create(bhgDebugAStar);
    HUD.SetPosition(Node.Position);
    HUD.Expire := 60000;
    if Node.Position = Origin then
      HUD.Color := $00FF00
    else if Node.Target then
      HUD.Color := $0000FF
    else if Node.Path then
      HUD.Color := $33FFFF
    else if Node.Done then
      HUD.Color := $FFFF33
    else
      HUD.Color := $FFFFFF;
    if Engine.Debug.PathDir then
    begin
      if Assigned(Node.Parent) then
      begin
        case Node.Parent.Position.X - Node.Position.X of
          - 1:
            begin
              case Node.Parent.Position.Y - Node.Position.Y of
                - 1:
                  HUD.Text := 'SE';
                0:
                  HUD.Text := 'E';
                +1:
                  HUD.Text := 'NE';
              end;
            end;
          0:
            begin
              case Node.Parent.Position.Y - Node.Position.Y of
                - 1:
                  HUD.Text := 'S';
                0:
                  HUD.Text := 'C';
                +1:
                  HUD.Text := 'N';
              end;
            end;
          +1:
            begin
              case Node.Parent.Position.Y - Node.Position.Y of
                - 1:
                  HUD.Text := 'SW';
                0:
                  HUD.Text := 'W';
                +1:
                  HUD.Text := 'NW';
              end;
            end;
        end;
        HUD.Print;
        HUD.RelativeY := HUD.RelativeY + 12;
      end;
    end;
    if Engine.Debug.PathCost then
    begin
      HUD.Print(BFormat('C: %d', [Node.Cost]));
      HUD.RelativeY := HUD.RelativeY + 12;
    end;
    if Engine.Debug.PathHeuristic then
    begin
      HUD.Print(BFormat('H: %d', [Node.Heuristic]));
      HUD.RelativeY := HUD.RelativeY + 12;
    end;
    if Engine.Debug.PathTile then
    begin
      HUD.Print(BFormat('TC: %d', [Node.TileCost]));
      HUD.RelativeY := HUD.RelativeY + 12;
    end;
    if Engine.Debug.PathStep then
    begin
      HUD.Print(BFormat('SC: %d', [Node.StepCost]));
      HUD.RelativeY := HUD.RelativeY + 12;
    end;
    HUD.Free;
  end;
end;

{ TBBotWalkPosition }

constructor TBBotWalkPosition.Create;
begin
  inherited Create;
  AStar := TBBotAStarPosition.Create;
  Target := BPosXYZ(0, 0, 0);
  Sucess := True;
end;

destructor TBBotWalkPosition.Destroy;
begin
  AStar.Free;
  inherited;
end;

procedure TBBotWalkPosition.RePath;
begin
  Reset;
  if (Target.X <> 0) and (Me.Position.Z = Target.Z) then
  begin
    AStar.Origin := Me.Position;
    AStar.Distance := Distance;
    AStar.Target := Target;
    AStar.MaxRadiusDistance := MaxRadiusDistance;
    AStar.Execute;
    if AStar.Cost = Cost_NotPossible then
      Failed := True
    else
      AStar.ForEachPath(_AddNodeToList, Path);
  end
  else
    Failed := True;
end;

procedure TBBotWalkPosition.Stop;
begin
  Target := BPosXYZ(0, 0, 0);
  Sucess := True;
end;

procedure TBBotWalkPosition.Walk;
begin
  if (Path.Count > 0) and (Path[0]^ = Me.Position) then
    Sucess := True
  else
    inherited Walk;
end;

{ TBBotWalkCreature }

constructor TBBotWalkCreature.Create;
begin
  inherited Create;
  AStar := TBBotAStarKeepDistance.Create;
  FCreatureID := 0;
  Sucess := True;
end;

destructor TBBotWalkCreature.Destroy;
begin
  AStar.Free;
  inherited;
end;

function TBBotWalkCreature.GetCreature: TBBotCreature;
begin
  if CreatureID = 0 then
    Exit(nil);
  Result := BBot.Creatures.Find(CreatureID);
  if (Result <> nil) and ((Result.IsDeath) or (not Result.IsVisible)) then
    Result := nil;
end;

procedure TBBotWalkCreature.RePath;
var
  C: TBBotCreature;
begin
  C := Creature;
  if (C <> nil) and (C.IsAlive) and (C.IsOnScreen) then
  begin
    Reset;
    AStar.Origin := Me.Position;
    AStar.Distance := Distance;
    AStar.Target := C.Position;
    AStar.MaxRadiusDistance := MaxRadiusDistance;
    AStar.Execute;
    if AStar.Cost <> Cost_NotPossible then
      AStar.ForEachPath(_AddNodeToList, Path)
    else
      Reset;
  end
  else
    Failed := True;
end;

procedure TBBotWalkCreature.Stop;
begin
  FCreatureID := 0;
  Sucess := True;
end;

procedure TBBotWalkCreature.Walk;
var
  C: TBBotCreature;
begin
  C := Creature;
  if (C <> nil) and (C.IsAlive) and (C.IsOnScreen) then
  begin
    if BUInt32(SQMDistance(Me.Position.X, Me.Position.Y, C.Position.X,
      C.Position.Y)) <> Distance then
      inherited Walk;
  end
  else
    Failed := True;
end;

{ TBBotAStarKeepDistance }

function TBBotAStarKeepDistance.GetHeuristic(Node: TAStarNode): BUInt32;
var
  H: BUInt32;
  X, Y: BInt32;
  F: BBool;
begin
  Result := 0;
  F := True;
  for X := -Distance to +Distance do
    for Y := -Distance to +Distance do
      if (BUInt32(BAbs(X)) = Distance) or (BUInt32(BAbs(Y)) = Distance) then
      begin
        H := BUInt32(DiagonalDistance(Node.Position.X, Node.Position.Y,
          Target.X + X, Target.Y + Y, Cost_Diagonal * Cost_Normal,
          Cost_Straight * Cost_Normal));
        if not BBot.Walker.History.Has(
          function(It: BVector<BPos>.It): BBool
          begin
            Result := (It^.Z = Node.Position.Z) and
              (SQMDistance(It^.X, It^.Y, Node.Position.X, Node.Position.Y) < 3);
          end) then
          Inc(H, Cost_Normal);
        if F or (H < Result) then
        begin
          Result := H;
          F := False;
        end;
      end;
end;

end.
