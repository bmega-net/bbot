unit uBBotWaverShooter;

interface

uses
  uBTypes,
  uBVector,
  uTibiaDeclarations,
  uBattlelist;

type
  TBBotWaverShooter = class
  private
    FDirection: TTibiaDirection;
    FExpansion: BVector<BUInt32>;
    FCreaturesOnTarget: BVector<TBBotCreature>;
    function GetAllowed: BBool;
    function collectWavedCreaturesOnDirection()
      : BVector<TBBotCreature>; overload;
    function collectWavedCreaturesOnDirection(ADirection: TTibiaDirection)
      : BVector<TBBotCreature>; overload;
    function wasCreatureWaved(ACreature: TBBotCreature): BBool;
    function wasWaved(APosition: BPos): BBool;
    function collectWavedCreature(ACreatures: BVector<TBBotCreature>)
      : BVector<TBBotCreature>;
    function isSafeWave: BBool;
  protected
    IncludedCreatures, ExcludedCreatures: BVector<TBBotCreature>;
    UnsafePositions: BVector<BPos>;
    XSpeed, YSpeed: BInt32;
  public
    constructor Create;
    destructor Destroy; override;

    property Expansion: BVector<BUInt32> read FExpansion;

    procedure OptimalWave(AIncludedCreatures, AExcludedCreatures
      : BVector<TBBotCreature>; AUnsafePositions: BVector<BPos>);

    property CreaturesOnTarget: BVector<TBBotCreature> read FCreaturesOnTarget
      write FCreaturesOnTarget;
    property Direction: TTibiaDirection read FDirection;
    property Allowed: BBool read GetAllowed;
  end;

procedure TestWaverShooter;

implementation

{ TBBotWaverShooter }

uses
  BBotEngine,
  uHUD,
  Declaracoes;

constructor TBBotWaverShooter.Create;
begin
  FExpansion := BVector<BUInt32>.Create;
  FCreaturesOnTarget := nil;
  XSpeed := 0;
  YSpeed := 0;
  IncludedCreatures := nil;
  ExcludedCreatures := nil;
end;

destructor TBBotWaverShooter.Destroy;
begin
  if FCreaturesOnTarget <> nil then
    FCreaturesOnTarget.Free;
  FExpansion.Free;
  inherited;
end;

function TBBotWaverShooter.GetAllowed: BBool;
begin
  Result := (FCreaturesOnTarget <> nil) and (not FCreaturesOnTarget.Empty);
end;

function TBBotWaverShooter.isSafeWave: BBool;
begin
  Exit(not UnsafePositions.Has('AdvancedAttack:WaveShooter:IsSafeWave',
    function(AIt: BVector<BPos>.It): BBool
    begin
      Exit(wasWaved(AIt^));
    end));
end;

function TBBotWaverShooter.collectWavedCreaturesOnDirection()
  : BVector<TBBotCreature>;
var
  ValidTargets, InvalidTargets: BVector<TBBotCreature>;
begin
  if isSafeWave then
  begin
    ValidTargets := collectWavedCreature(IncludedCreatures);
    InvalidTargets := collectWavedCreature(ExcludedCreatures);
    if InvalidTargets.Count = 0 then
    begin
      InvalidTargets.Free;
      Exit(ValidTargets);
    end
    else
    begin
      ValidTargets.Free;
      InvalidTargets.Free;
      Exit(nil);
    end;
  end
  else
  begin
    Exit(nil);
  end;
end;

function TBBotWaverShooter.collectWavedCreaturesOnDirection
  (ADirection: TTibiaDirection): BVector<TBBotCreature>;
begin
  XSpeed := 0;
  YSpeed := 0;
  case ADirection of
    tdNorth:
      YSpeed := -1;
    tdEast:
      XSpeed := +1;
    tdSouth:
      YSpeed := +1;
    tdWest:
      XSpeed := -1;
  end;
  if (XSpeed <> 0) or (YSpeed <> 0) then
    Exit(collectWavedCreaturesOnDirection())
  else
    Exit(nil);
end;

function TBBotWaverShooter.collectWavedCreature
  (ACreatures: BVector<TBBotCreature>): BVector<TBBotCreature>;
var
  Res: BVector<TBBotCreature>;
begin
  Res := BVector<TBBotCreature>.Create;
  ACreatures.ForEach(
    procedure(AIt: BVector<TBBotCreature>.It)
    begin
      if wasCreatureWaved(AIt^) then
        Res.Add(AIt^);
    end);
  Exit(Res);
end;

procedure TBBotWaverShooter.OptimalWave(AIncludedCreatures, AExcludedCreatures
  : BVector<TBBotCreature>; AUnsafePositions: BVector<BPos>);
var
  D: TTibiaDirection;
  WavedOnDirection: BVector<TBBotCreature>;
begin
  IncludedCreatures := AIncludedCreatures;
  ExcludedCreatures := AExcludedCreatures;
  UnsafePositions := AUnsafePositions;
  if FCreaturesOnTarget <> nil then
  begin
    FCreaturesOnTarget.Free;
    FCreaturesOnTarget := nil;
  end;
  FDirection := tdCenter;
  for D := tdNorth to tdCenter do
  begin
    WavedOnDirection := collectWavedCreaturesOnDirection(D);
    if WavedOnDirection <> nil then
    begin
      if (FCreaturesOnTarget = nil) or
        (WavedOnDirection.Count > FCreaturesOnTarget.Count) then
      begin
        if FCreaturesOnTarget <> nil then
          FCreaturesOnTarget.Free;
        FCreaturesOnTarget := WavedOnDirection;
        FDirection := D;
      end
      else
      begin
        WavedOnDirection.Free;
      end;
    end;
  end;
  IncludedCreatures := nil;
  ExcludedCreatures := nil;
  UnsafePositions := nil;
end;

function TBBotWaverShooter.wasCreatureWaved(ACreature: TBBotCreature): BBool;
begin
  if (not ACreature.IsSelf) and (ACreature.IsAlive) then
  begin
    Exit(wasWaved(ACreature.Position));
  end;
  Exit(False);
end;

function TBBotWaverShooter.wasWaved(APosition: BPos): BBool;
var
  DeltaX, DeltaY, extensionDistance, spreadDistance: BInt32;
begin
  DeltaX := APosition.X - Me.Position.X;
  DeltaY := APosition.Y - Me.Position.Y;
  extensionDistance := BMax(DeltaX * XSpeed, DeltaY * YSpeed);
  spreadDistance := BMax(BAbs(DeltaX * YSpeed), BAbs(DeltaY * XSpeed));
  if BInRange(BAbs(extensionDistance), 1, FExpansion.Count) then
    if BUInt32(spreadDistance) <= (FExpansion.Item[extensionDistance - 1]^ - 1)
    then
      Exit(True);
  Exit(False);
end;

procedure TestWaverShooter;
var
  WS: TBBotWaverShooter;
  HUD: TBBotHUD;
  D: TTibiaDirection;
  S: BVector<TBBotCreature>;
  IncludedCreatures, ExcludedCreatures: BVector<TBBotCreature>;
  UnsafePositions: BVector<BPos>;
begin
  HUDRemoveGroup(bhgAny);
  HUD := TBBotHUD.Create(bhgAny);
  HUD.Expire := 1000;
  HUD.Color := $FFFF80;
  HUD.AlignTo(bhaLeft, bhaTop);
  WS := TBBotWaverShooter.Create;

  IncludedCreatures := BVector<TBBotCreature>.Create();
  ExcludedCreatures := BVector<TBBotCreature>.Create();
  UnsafePositions := BBot.AdvAttack.GenerateUnsafePositions;
  BBot.Creatures.Traverse(
    procedure(C: TBBotCreature)
    begin
      if C.IsAlive and (not C.IsSelf) then
        IncludedCreatures.Add(C);
    end);

  WS.Expansion.Add(BBot.Macros.Registry.Variables['Expansion1'].Value);
  WS.Expansion.Add(BBot.Macros.Registry.Variables['Expansion2'].Value);
  WS.Expansion.Add(BBot.Macros.Registry.Variables['Expansion3'].Value);
  WS.Expansion.Add(BBot.Macros.Registry.Variables['Expansion4'].Value);
  WS.IncludedCreatures := IncludedCreatures;
  WS.ExcludedCreatures := ExcludedCreatures;
  WS.UnsafePositions := UnsafePositions;
  for D := tdNorth to tdCenter do
  begin
    S := WS.collectWavedCreaturesOnDirection(D);
    if S <> nil then
    begin
      if S.Count > 0 then
        HUD.Print(BFormat('Wave %s to hit %d creatures',
          [DirToStr(D), S.Count]));
      S.Free;
    end;
  end;
  UnsafePositions.Free;
  IncludedCreatures.Free;
  ExcludedCreatures.Free;
  WS.Free;
  HUD.Free;
end;

end.
