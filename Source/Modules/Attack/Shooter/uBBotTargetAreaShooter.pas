unit uBBotTargetAreaShooter;

interface

uses
  uBTypes,
  uBVector,
  uKMeans,
  uBattlelist;

type
  TBBotTargetAreaShooter = class
  private type
    BPosScored = record
      Pos: BPos;
      Score: BUInt32;
    end;
  private
    FTarget: BPos;
    FCreaturesOnTarget: BUInt32;
    FScoreOnTarget: BUInt32;
    FRange: BUInt32;
    FLimitScreen: BInt32;
    function GetAllowed: BBool;
  protected
    ExcludedPositions: BVector<BPos>;
    IncludedPositions: BVector<BPosScored>;
    Centroids: BVector<BPos>;
    procedure GenerateCentroids;
    procedure ProcessCentroids(ACentroids: BVector<TKMeansItem>);
    procedure ProcessCentroid(ACentroid: BVector<TKMeansItem>.It);
  public
    constructor Create;
    destructor Destroy; override;

    procedure OptimalShoot(AIncludedCreatures, AExcludedCreatures: BVector<TBBotCreature>;
      AUnsafePositions: BVector<BPos>);

    property Range: BUInt32 read FRange write FRange;
    property LimitScreen: BInt32 read FLimitScreen write FLimitScreen;

    property Target: BPos read FTarget;
    property CreaturesOnTarget: BUInt32 read FCreaturesOnTarget;
    property ScoreOnTarget: BUInt32 read FScoreOnTarget;

    property Allowed: BBool read GetAllowed;
  end;

procedure TestTargetAreaShooter;

implementation

{ TBBotTargetAreaShooter }

uses
  BBotEngine,
  uHUD,
  uDistance,
  Winapi.Windows,
  uTiles;

constructor TBBotTargetAreaShooter.Create;
begin
  FCreaturesOnTarget := 0;
  FRange := 3;
  FLimitScreen := 0;
  FTarget.zero;
  IncludedPositions := BVector<BPosScored>.Create;
  ExcludedPositions := BVector<BPos>.Create;
  Centroids := BVector<BPos>.Create;
end;

destructor TBBotTargetAreaShooter.Destroy;
begin
  Centroids.Free;
  IncludedPositions.Free;
  ExcludedPositions.Free;
  inherited;
end;

procedure TBBotTargetAreaShooter.GenerateCentroids;
const
  ChanceAddSelfPosition = 50;
  ChanceSpreadLabels = 30;
  MaxSpreadLabels = 3;
  MaxSpreadExplore = 3;
var
  kMeans: TKMeans;
  CurrentCentroids: BInt32;
  Experiments: BInt32;
begin
  if IncludedPositions.Count > 0 then begin
    kMeans := TKMeans.Create;

    if BRandom(0, 100) < ChanceAddSelfPosition then begin
      kMeans.AddLabel(Me.Position);
    end;

    IncludedPositions.ForEach(
      procedure(It: BVector<BPosScored>.It)
      var
        P: BPos;
        RandomFromP: BInt32;
      begin
        P := It^.Pos;
        kMeans.AddLabel(P);
        if BRandom(0, 100) < ChanceSpreadLabels then begin
          RandomFromP := BRandom(1, MaxSpreadLabels);
          kMeans.AddLabel(BPosXYZ(P.X + BRandom(-RandomFromP, RandomFromP), P.Y + BRandom(-RandomFromP,
            RandomFromP), P.Z));
        end;
      end);

    CurrentCentroids := 2;
    Experiments := BRandom(3, 6);
    while Experiments > 0 do begin
      kMeans.K := CurrentCentroids;
      kMeans.Run;
      ProcessCentroids(kMeans.Centroids);
      Inc(CurrentCentroids, BRandom(1, MaxSpreadExplore));
      Dec(Experiments);
    end;
    kMeans.Free;
  end;
end;

function TBBotTargetAreaShooter.GetAllowed: BBool;
begin
  Result := FCreaturesOnTarget <> 0;
end;

procedure TBBotTargetAreaShooter.OptimalShoot(AIncludedCreatures, AExcludedCreatures: BVector<TBBotCreature>;
AUnsafePositions: BVector<BPos>);
begin
  Centroids.Clear;
  IncludedPositions.Clear;
  ExcludedPositions.Clear;
  AIncludedCreatures.ForEach(
    procedure(AIt: BVector<TBBotCreature>.It)
    var
      Add: BVector<BPosScored>.It;
    begin
      Add := IncludedPositions.Add;
      Add^.Pos := AIt^.Position;
      Add^.Score := BMax((100 - AIt^.Health) div 5, 1);
    end);
  AExcludedCreatures.ForEach(
    procedure(AIt: BVector<TBBotCreature>.It)
    begin
      ExcludedPositions.Add(AIt^.Position);
    end);
  AUnsafePositions.ForEach(
    procedure(AIt: BVector<BPos>.It)
    begin
      ExcludedPositions.Add(AIt^);
    end);
  FTarget.zero;
  FCreaturesOnTarget := 0;
  FScoreOnTarget := 0;
  GenerateCentroids;
end;

procedure TBBotTargetAreaShooter.ProcessCentroid(ACentroid: BVector<TKMeansItem>.It);
var
  HitCount, HitScore: BUInt32;
  AllowedScreenRect: TRect;
  IsInsideAllowedArea: BBinaryFunc<BInt32, BInt32, BBool>;
  Allowed, NorthInside, WestInside, EastInside, SouthInside: BBool;
begin
  Centroids.Add(ACentroid^.Position);
  if ACentroid^.Labels > 0 then begin
    HitCount := 0;
    HitScore := 0;

    if LimitScreen > 0 then begin

      AllowedScreenRect := TRect.Create( //
        Me.Position.X - TibiaTilesWidth + LimitScreen, //
        Me.Position.Y - TibiaTilesHeight + LimitScreen, //
        Me.Position.X + TibiaTilesWidth - LimitScreen, //
        Me.Position.Y + TibiaTilesHeight - LimitScreen);

      IsInsideAllowedArea := function(A, B: BInt32): BBool
        begin
          Exit(AllowedScreenRect.Contains(TPoint.Create(ACentroid^.Position.X + A, ACentroid^.Position.Y + B)));
        end;

      // Test against out of screen
      NorthInside := IsInsideAllowedArea(0, -Range);
      WestInside := IsInsideAllowedArea(-Range, 0);
      EastInside := IsInsideAllowedArea(+Range, 0);
      SouthInside := IsInsideAllowedArea(0, +Range);
      Allowed := NorthInside and WestInside and EastInside and SouthInside;
      if BBot.Attacker.Debug then
        BBot.AdvAttack.AddDebug(ACentroid^.Position, BIf(Allowed, 'Allowed', 'Disallowed'));
      if not Allowed then
        Exit;
    end;

    if ExcludedPositions.Has('Area Shooter - exclusion check',
      function(pIt: BVector<BPos>.It): BBool
      var
        DistToCentroid: BUInt32;
      begin
        DistToCentroid := NormalDistance(pIt^.X, pIt^.Y, ACentroid^.Position.X, ACentroid^.Position.Y);
        Exit(DistToCentroid <= Range);
      end) then
      Exit;
    IncludedPositions.ForEach(
      procedure(pIt: BVector<BPosScored>.It)
      var
        DistToCentroid: BUInt32;
      begin
        DistToCentroid := NormalDistance(pIt^.Pos.X, pIt^.Pos.Y, ACentroid^.Position.X, ACentroid^.Position.Y);
        if DistToCentroid <= Range then begin
          Inc(HitCount);
          Inc(HitScore, pIt^.Score);
        end;
      end);
    if (HitCount >= FCreaturesOnTarget) and (HitScore >= FScoreOnTarget) then begin
      FTarget := ACentroid^.Position;
      FCreaturesOnTarget := HitCount;
      FScoreOnTarget := HitScore;
    end;
  end;
end;

procedure TBBotTargetAreaShooter.ProcessCentroids(ACentroids: BVector<TKMeansItem>);
begin
  ACentroids.ForEach(
    procedure(It: BVector<TKMeansItem>.It)
    begin
      if not Centroids.Has('Area shooter - Processing centroids',
        function(cIt: BVector<BPos>.It): BBool
        begin
          Result := cIt^ = It^.Position;
        end) then
        ProcessCentroid(It);
    end);
end;

procedure TestTargetAreaShooter;
var
  IncludedCreatures, ExcludedCreatures: BVector<TBBotCreature>;
  UnsafePositions: BVector<BPos>;
  TAS: TBBotTargetAreaShooter;
  HUD: TBBotHUD;
begin
  IncludedCreatures := BVector<TBBotCreature>.Create();
  ExcludedCreatures := BVector<TBBotCreature>.Create();
  UnsafePositions := BBot.AdvAttack.GenerateUnsafePositions;
  HUDRemoveGroup(bhgAny);
  HUD := TBBotHUD.Create(bhgAny);
  HUD.Expire := 1000;
  HUD.Color := $FFFF80;
  TAS := TBBotTargetAreaShooter.Create;
  TAS.Range := 3;
  BBot.Creatures.Traverse(
    procedure(C: TBBotCreature)
    begin
      if C.IsAlive and (not C.IsSelf) then
        IncludedCreatures.Add(C);
    end);

  TAS.OptimalShoot(IncludedCreatures, ExcludedCreatures, UnsafePositions);
  if TAS.CreaturesOnTarget > 2 then begin
    HUD.SetPosition(TAS.Target);
    HUD.Print(BFormat('GFB %d', [TAS.CreaturesOnTarget]));
  end else begin
    HUD.SetPosition(Me.Position);
    HUD.Print('NO-GFB');
  end;
  TAS.Free;
  HUD.Free;
  UnsafePositions.Free;
  IncludedCreatures.Free;
  ExcludedCreatures.Free;
end;

end.
