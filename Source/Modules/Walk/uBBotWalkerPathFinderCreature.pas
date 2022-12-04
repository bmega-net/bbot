unit uBBotWalkerPathFinderCreature;

interface

uses
  uBTypes,
  uBBotWalkerPathFinder,
  uAStar,
  uBVector;

type
  TBBotPathFinderCreature = class(TBBotPathFinder)
  private
    FCreature: BUInt32;
    function KillerPriorityOnPos(P: BPos): BInt32;
  public
    constructor Create(const ADescription: BStr);

    function GetTileCost(P: BPos): BFloat; override;
    function GetHeuristic(Node: TAStarNode): BFloat; override;

    function GetOrigin: BPos; override;
    function GetDestination: BPos; override;

    property Creature: BUInt32 read FCreature write FCreature;
  end;

implementation

{ TBBotPathFinderCreature }

uses
  BBotEngine,
  uDistance,
  uBattlelist,
  Math,

  uBBotSpecialSQMs;

constructor TBBotPathFinderCreature.Create(const ADescription: BStr);
begin
  inherited Create(ADescription);
  MaxDistance := 15;
  FCreature := 0;
end;

function TBBotPathFinderCreature.GetDestination: BPos;
var
  C: TBBotCreature;
begin
  C := BBot.Creatures.Find(FCreature);
  if (C <> nil) and (C.IsAlive) and (C.IsOnScreen) then
    Exit(C.Position)
  else
    Exit(BPosXYZ(0, 0, 0));
end;

function TBBotPathFinderCreature.GetHeuristic(Node: TAStarNode): BFloat;
var
  NearestAttackingLike: BPos;
  NearestAttackingLikeH: BUInt32;
begin
  if not BBot.SpecialSQMs.InsideAttackingLike then
  begin
    NearestAttackingLike.zero;
    NearestAttackingLikeH := 0;
    BBot.SpecialSQMs.AttackingLikeCenters.ForEach(
      procedure(AIt: BVector<BPos>.It)
      var
        H: BUInt32;
        It: BPos;
      begin
        It := AIt^;
        if SQMDistance(Node.Position.X, Node.Position.Y, It.X, It.Y) < 15 then
        begin
          H := 1 + DiagonalDistance(Node.Position.X, Node.Position.Y, It.X,
            It.Y, StepCost_Diagonal, StepCost_Straight);
          if (NearestAttackingLike.X = 0) or (H < NearestAttackingLikeH) then
          begin
            NearestAttackingLike := It;
            NearestAttackingLikeH := H;
          end;
        end;
      end);
    if NearestAttackingLike.X <> 0 then
      Exit(NearestAttackingLikeH);
  end;
  Result := inherited GetHeuristic(Node);
end;

function TBBotPathFinderCreature.GetTileCost(P: BPos): BFloat;
const
  HistoryRange = 3;
  HistoryMultiplier = 0.9;
  LikeInsideAttacking = 4.0;
  UnLikedInsideAttacking = 10.0;
var
  Mult: BFloat;
  Kind: TBBotSpecialSQMKind;
begin
  Result := inherited;
  Result := Result + KillerPriorityOnPos(P);
  if BBot.SpecialSQMs.InsideAttackingLike then
  begin
    Kind := BBot.SpecialSQMs.Kind(P.X, P.Y, P.Z);
    if Kind <> sskLikeAttacking then
      if Kind = sskLike then
        Result := Result * LikeInsideAttacking
      else
        Result := Result * UnLikedInsideAttacking;
  end
  else
  begin
    Mult := 1;
    BBot.AdvAttack.History.ForEach(
      procedure(It: BVector<BPos>.It)
      begin
        if SQMDistance(It^.X, It^.Y, P.X, P.Y) <= HistoryRange then
          Mult := Mult * HistoryMultiplier;
      end);
    Result := Result * Mult;
  end;
end;

function TBBotPathFinderCreature.KillerPriorityOnPos(P: BPos): BInt32;
var
  C: TBBotCreature;
begin
  Result := 0;
  C := BBot.Creatures.Find(P);
  if (C <> nil) and (not C.IsSelf) and (C.IsAlive) then
    Result := BBot.AdvAttack.KillerPriority(C);
end;

function TBBotPathFinderCreature.GetOrigin: BPos;
begin
  Result := Me.Position;
end;

end.
