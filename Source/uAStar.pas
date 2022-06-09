unit uAStar;

interface

uses
  uBTypes,
  uBVector,
  Classes,
  uBBinaryHeap;

type
  TAStar = class;

  TAStarNode = class
  private
    FTileCost: BFloat;
    FCost: BFloat;
    FHeuristic: BFloat;
    FStepCost: BFloat;
    FParent: TAStarNode;
    FAStar: TAStar;
    FTarget: BBool;
    FDistancetoOrigin: BUInt32;
    FDone: BBool;
    FPath: BBool;
    FPosition: BPos;
    procedure SetParent(const Value: TAStarNode);
  public
    constructor Create(ATileCost: BFloat; APosition: BPos; AParent: TAStarNode; AAStar: TAStar);

    property AStar: TAStar read FAStar;
    property Position: BPos read FPosition;
    property TileCost: BFloat read FTileCost;
    property Heuristic: BFloat read FHeuristic;
    property StepCost: BFloat read FStepCost;
    property Cost: BFloat read FCost;
    property Done: BBool read FDone write FDone;
    property Path: BBool read FPath write FPath;
    property Target: BBool read FTarget;
    property Parent: TAStarNode read FParent write SetParent;
    property DistanceToOrigin: BUInt32 read FDistancetoOrigin;

    procedure AddNeightbors;
  end;

  TAStar = class
  private
    FCost: BInt32;
    LDone: BVector<TAStarNode>;
    LOpen: BMinHeap<TAStarNode>;
    LastNode: TAStarNode;
    function CalcCost: BInt32;
    procedure Check(ANode: TAStarNode);
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Execute;
    property Cost: BInt32 read FCost;
    procedure GeneratePath(const Path: BVector<BPos>);

    procedure AddNode(Position: BPos; Parent: TAStarNode);

    procedure OnStart; virtual;
    procedure OnFinish; virtual;

    function GetHeuristic(Node: TAStarNode): BFloat; virtual; abstract;
    function GetStepCost(FX, FY, TX, TY: BInt32): BFloat;
    function GetTileCost(P: BPos): BFloat; virtual; abstract;

    function GetTarget(Node: TAStarNode): BBool; virtual; abstract;
    function GetOrigin: BPos; virtual; abstract;

    procedure GetNeightbors(Node: TAStarNode); virtual; abstract;
    procedure OnDebug(Node: TAStarNode); virtual; abstract;
  end;

implementation

uses
  uDistance;

{ TAStarNode }

procedure TAStarNode.AddNeightbors;
begin
  FAStar.GetNeightbors(Self);
end;

constructor TAStarNode.Create(ATileCost: BFloat; APosition: BPos; AParent: TAStarNode; AAStar: TAStar);
begin
  FAStar := AAStar;
  FPosition := APosition;
  FTileCost := ATileCost;
  FStepCost := 0;
  FDone := False;
  FPath := False;
  FDistancetoOrigin := DiagonalDistance(AAStar.GetOrigin.X, AAStar.GetOrigin.Y, FPosition.X, FPosition.Y,
    StepCost_Diagonal, StepCost_Straight);
  FHeuristic := FAStar.GetHeuristic(Self);
  SetParent(AParent);
  FTarget := FAStar.GetTarget(Self);
end;

procedure TAStarNode.SetParent(const Value: TAStarNode);
begin
  FParent := Value;
  if FParent <> nil then begin
    FStepCost := FAStar.GetStepCost(FParent.Position.X, FParent.Position.Y, Position.X, Position.Y);
    FCost := FParent.Cost;
  end else begin
    FStepCost := 0;
    FCost := 0;
  end;
  FCost := FCost + (FHeuristic * FTileCost * FStepCost);
end;

{ TAStar }

procedure TAStar.AddNode(Position: BPos; Parent: TAStarNode);
var
  F: BVectorIndex;
  N: TAStarNode;
  S: BFloat;
begin
  if LDone.Has('A* AddNode 1',
    function(It: BVector<TAStarNode>.It): BBool
    begin
      Result := It^.Position = Position;
    end) then
    Exit;
  F := LOpen.Items.Search('A* AddNode 2',
    function(It: BVector<TAStarNode>.It): BBool
    begin
      Result := It^.Position = Position;
    end);
  if F <> BVector<TAStarNode>.Invalid then begin
    N := LOpen.Items.Item[F]^;
    S := GetStepCost(Parent.Position.X, Parent.Position.Y, Position.X, Position.Y);
    if S < N.StepCost then begin
      N.Parent := Parent;
      LOpen.IncreaseKey(F + 1, LOpen.Items.Item[F]^);
    end;
    OnDebug(N);
    Exit;
  end;
  S := GetTileCost(Position);
  if S < TileCost_NotWalkable then begin
    N := TAStarNode.Create(S, Position, Parent, Self);
    OnDebug(N);
    LOpen.Push(N);
  end;
end;

function TAStar.CalcCost: BInt32;
var
  N: TAStarNode;
begin
  Result := 0;
  N := LastNode;
  while N <> nil do begin
    Inc(Result);
    N.Path := True;
    OnDebug(N);
    N := N.Parent;
  end;
end;

procedure TAStar.Check(ANode: TAStarNode);
var
  Node: TAStarNode;
begin
  Node := ANode;
  while Node <> nil do begin
    OnDebug(Node);
    if Node.Target then begin
      LastNode := Node;
      FCost := CalcCost;
      Exit;
    end;
    Node.AddNeightbors;
    if LOpen.Size = 0 then
      Exit;
    Node := LOpen.Pop;
    LDone.Add(Node);
    Node.Done := True;
  end;
end;

procedure TAStar.Clear;
begin
  LOpen.Items.Clear;
  LDone.Clear;
  LastNode := nil;
  FCost := PathCost_NotPossible;
end;

constructor TAStar.Create;
var
  Delete: BUnaryProc<BVector<TAStarNode>.It>;
  Comparer: BBinaryFunc<BVector<TAStarNode>.It, BVector<TAStarNode>.It, BInt32>;
begin
  Delete := procedure(It: BVector<TAStarNode>.It)
    begin
      It^.Free;
    end;
  Comparer := function(ALeft: BVector<TAStarNode>.It; ARight: BVector<TAStarNode>.It): BInt32
    begin
      Result := BCeil(ALeft^.Cost - ARight^.Cost);
    end;
  LOpen := BMinHeap<TAStarNode>.Create(Comparer, Delete, nil);
  LDone := BVector<TAStarNode>.Create(Delete);
  FCost := PathCost_NotPossible;
  LastNode := nil;
end;

destructor TAStar.Destroy;
begin
  LOpen.Free;
  LDone.Free;
  inherited;
end;

procedure TAStar.Execute;
var
  N: TAStarNode;
begin
  Clear;
  OnDebug(nil);
  OnStart;
  N := TAStarNode.Create(TileCost_Like, GetOrigin, nil, Self);
  LDone.Add(N);
  Check(N);
  OnFinish;
end;

function TAStar.GetStepCost(FX, FY, TX, TY: BInt32): BFloat;
begin
  if (FX = TX) or (FY = TY) then
    Result := StepCost_Straight
  else
    Result := StepCost_Diagonal * 2;
end;

procedure TAStar.OnFinish;
begin

end;

procedure TAStar.OnStart;
begin

end;

procedure TAStar.GeneratePath(const Path: BVector<BPos>);
var
  N: TAStarNode;
begin
  N := LastNode;
  while N <> nil do begin
    Path.Add(N.Position);
    N := N.Parent;
  end;
end;

end.
