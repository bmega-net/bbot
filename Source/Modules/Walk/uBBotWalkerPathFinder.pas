unit uBBotWalkerPathFinder;

interface

uses
  uBTypes,
  uAStar,
  uTibiaDeclarations,
  uBVector;

type
  TBBotPathFinderNodeKind = (bpfnkOrigin, bpfnkTarget, bpfnkPath, bpfnkDone,
    bpfnkOther);

  TBBotPathFinderDebugEvent = record
    Pos: BPos;
    Time: BUInt32;
    Kind: TBBotPathFinderNodeKind;
    Dir: TTibiaDirection;
    TotalCost: BFloat;
    Heuristic: BFloat;
    TileCost: BFloat;
    StepCost: BFloat;
  end;

  TBBotPathFinderDebugTile = record
    Pos: BPos;
    Score: BFloat;
  end;

  TBBotPathFinder = class(TAStar)
  private
    FDescription: BStr;
    FDistance: BUInt32;
    FMaxDistance: BUInt32;
    FEvents: BVector<TBBotPathFinderDebugEvent>;
  public
    constructor Create(const ADescription: BStr);
    destructor Destroy; override;

    property Distance: BUInt32 read FDistance write FDistance;
    property MaxDistance: BUInt32 read FMaxDistance write FMaxDistance;

    procedure OnStart; override;
    procedure OnFinish; override;

    function GetHeuristic(Node: TAStarNode): BFloat; override;
    function GetTileCost(P: BPos): BFloat; override;

    function GetDestination: BPos; virtual; abstract;
    function GetTarget(Node: TAStarNode): BBool; override;

    procedure GetNeightbors(Node: TAStarNode); override;
    procedure OnDebug(Node: TAStarNode); override;

    property Events: BVector<TBBotPathFinderDebugEvent> read FEvents;
  end;

implementation

uses
  uDistance,

  uEngine,
  BBotEngine,
  uMain,
  uBBotGUIMessages;

{ TBBotPathFinder }

constructor TBBotPathFinder.Create(const ADescription: BStr);
begin
  inherited Create;
  FDescription := ADescription;
  FMaxDistance := 100;
  FEvents := BVector<TBBotPathFinderDebugEvent>.Create();
end;

destructor TBBotPathFinder.Destroy;
begin
  FEvents.Free;
  inherited;
end;

function TBBotPathFinder.GetHeuristic(Node: TAStarNode): BFloat;
var
  H: BFloat;
  X, Y: BInt32;
  F: BBool;
begin
  Result := 0;
  F := True;
  for X := -Distance to +Distance do
    for Y := -Distance to +Distance do
      if (BUInt32(BAbs(X)) = Distance) or (BUInt32(BAbs(Y)) = Distance) then
      begin
        H := 1 + DiagonalDistance(Node.Position.X, Node.Position.Y,
          GetDestination.X + X, GetDestination.Y + Y, StepCost_Diagonal,
          StepCost_Straight);
        if F or (H < Result) then
        begin
          Result := H;
          F := False;
        end;
      end;
end;

procedure TBBotPathFinder.GetNeightbors(Node: TAStarNode);
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
        if SQMDistance(P.X, P.Y, GetOrigin.X, GetOrigin.Y) < MaxDistance then
          AddNode(P, Node);
      end;
end;

function TBBotPathFinder.GetTarget(Node: TAStarNode): BBool;
begin
  Result := BUInt32(SQMDistance(Node.Position.X, Node.Position.Y,
    GetDestination.X, GetDestination.Y)) = Distance;
end;

function TBBotPathFinder.GetTileCost(P: BPos): BFloat;
begin
  Result := BBot.Walker.WalkableCost(P);
  if Result >= TileCost_ExtremeAvoid then
    if P = GetDestination then
      Result := TileCost_Normal
    else
      Result := TileCost_NotWalkable;
end;

procedure TBBotPathFinder.OnDebug(Node: TAStarNode);
var
  Event: BVector<TBBotPathFinderDebugEvent>.It;
begin
  if Node = nil then
    Exit;
  Event := FEvents.Add;
  Event^.Time := Tick;
  Event^.Pos := Node.Position;
  Event^.TotalCost := Node.Cost;
  Event^.Heuristic := Node.Heuristic;
  Event^.TileCost := Node.TileCost;
  Event^.StepCost := Node.StepCost;
  // Set kind
  if Node.Position = GetOrigin then
    Event^.Kind := bpfnkOrigin
  else if Node.Target then
    Event^.Kind := bpfnkTarget
  else if Node.Path then
    Event^.Kind := bpfnkPath
  else if Node.Done then
    Event^.Kind := bpfnkDone
  else
    Event^.Kind := bpfnkOther;
  // Set direction
  if Assigned(Node.Parent) then
  begin
    case Node.Parent.Position.X - Node.Position.X of
      - 1:
        begin
          case Node.Parent.Position.Y - Node.Position.Y of
            - 1:
              Event^.Dir := tdSouthEast;
            0:
              Event^.Dir := tdEast;
            +1:
              Event^.Dir := tdNorthEast;
          end;
        end;
      0:
        begin
          case Node.Parent.Position.Y - Node.Position.Y of
            - 1:
              Event^.Dir := tdSouth;
            0:
              Event^.Dir := tdCenter;
            +1:
              Event^.Dir := tdNorth;
          end;
        end;
      +1:
        begin
          case Node.Parent.Position.Y - Node.Position.Y of
            - 1:
              Event^.Dir := tdSouthWest;
            0:
              Event^.Dir := tdWest;
            +1:
              Event^.Dir := tdNorthWest;
          end;
        end;
    end;
  end;
end;

procedure CalculateMinMaxValues(const Events
  : BVector<TBBotPathFinderDebugEvent>; out MinX, MinY, MaxX, MaxY: BInt32);
var
  I: BInt32;
  Item: BVector<TBBotPathFinderDebugEvent>.It;
begin
  Item := Events.Item[0];
  MinX := Item^.Pos.X;
  MaxX := MinX;
  MinY := Item^.Pos.Y;
  MaxY := MinY;
  for I := 1 to Events.Count - 1 do
  begin
    Item := Events.Item[I];
    MinX := BMin(MinX, Item^.Pos.X);
    MinY := BMin(MinY, Item^.Pos.Y);
    MaxX := BMax(MaxX, Item^.Pos.X);
    MaxY := BMax(MaxY, Item^.Pos.Y);
  end;
end;

procedure TBBotPathFinder.OnFinish;
var
  TileScoreMap: BVector<TBBotPathFinderDebugTile>;
  X, Y, MinX, MinY, MaxX, MaxY: BInt32;
  TileScore: BVector<TBBotPathFinderDebugTile>.It;
begin
  inherited;
  if Engine.Debug.Path and (Events.Count > 0) then
  begin
    CalculateMinMaxValues(Events, MinX, MinY, MaxX, MaxY);
    TileScoreMap := BVector<TBBotPathFinderDebugTile>.Create;
    for X := MinX - 1 to MaxX + 1 do
    begin
      for Y := MinY - 1 to MaxY + 1 do
      begin
        TileScore := TileScoreMap.Add;
        TileScore^.Pos := BPosXYZ(X, Y, Me.Position.Z);
        TileScore^.Score := GetTileCost(TileScore^.Pos);
      end;
    end;
    FMain.AddBBotMessage(TBBotGUIMessagePathFinderFinished.Create(FDescription,
      Events, TileScoreMap));
    TileScoreMap.Free;
  end;
end;

procedure TBBotPathFinder.OnStart;
begin
  inherited;
  FEvents.Clear;
end;

end.
