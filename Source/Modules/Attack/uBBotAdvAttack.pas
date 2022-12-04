unit uBBotAdvAttack;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uBBotAttackSequence,
  uBattlelist,
  uBBotTargetAreaShooter,
  uBBotWaverShooter,
  Jsons,
  uBCache;

const
  BBotWalkerHistoryCount = 20;
  BBotAdvAttackDefaultPlayer: BStr = 'Default Player';
  BBotAdvAttackDefaultCreature: BStr = 'Default Creature';
  BBotAdvAttackIgnore = 6;
  BBotAdvAttackAvoid = 7;
  BBotAdvAttackAvoidTimeDefault = 10000;
  BBotAdvAttackAvoidTimeVar = 'BBot.Attacker.AvoidTime';

type
  TBBotAdvAttack = class;

  TBBotAdvancedAttackBase = class
  private
    FCreatures: BVector<BStr>;
    FName: BStr;
    FAttackSequence: BStr;
    FKind: BStr;
    procedure ParseCreatures;
  protected
    Json: TJson;
    AdvAttack: TBBotAdvAttack;
    IncludedCreatures, ExcludedCreatures: BVector<TBBotCreature>;
    function IncludesCreature(ACreature: TBBotCreature): BBool;
    procedure GenerateCreatureLists;
    function GetAttackSequence: TBBotAttackSequence;
  public
    constructor Create(AAdvAttack: TBBotAdvAttack; AJson: TJson);
    destructor Destroy; override;

    property Name: BStr read FName;
    property Kind: BStr read FKind;
    property Creatures: BVector<BStr> read FCreatures;
    property AttackSequence: BStr read FAttackSequence;

    function Execute: BBool; virtual; abstract;
  end;

  TBBotAdvancedAttackSingle = class(TBBotAdvancedAttackBase)
  public
    constructor Create(AAdvAttack: TBBotAdvAttack; AJson: TJson);

    function Execute: BBool; override;
  end;

  TBBotAdvancedAttackMultiple = class(TBBotAdvancedAttackBase)
  private
    FMinCreatures: BUInt32;
  public
    constructor Create(AAdvAttack: TBBotAdvAttack; AJson: TJson);

    property MinCreatures: BUInt32 read FMinCreatures;
  end;

  TBBotAdvancedAttackWaver = class(TBBotAdvancedAttackMultiple)
  private
    FShooter: TBBotWaverShooter;
  public
    constructor Create(AAdvAttack: TBBotAdvAttack; AJson: TJson);
    destructor Destroy; override;

    property Shooter: TBBotWaverShooter read FShooter;

    function Execute: BBool; override;
  end;

  TBBotAdvancedAttackSelfArea = class(TBBotAdvancedAttackMultiple)
  private
    FRadius: BUInt32;
    function InSafeArea: BBool;
    function InAreaRange(APos: BPos): BBool;
    function CanShoot: BBool;
  public
    constructor Create(AAdvAttack: TBBotAdvAttack; AJson: TJson);

    property Radius: BUInt32 read FRadius;

    function Execute: BBool; override;
  end;

  TBBotAdvancedAttackBestArea = class(TBBotAdvancedAttackMultiple)
  private
    FShooter: TBBotTargetAreaShooter;
  public
    constructor Create(AAdvAttack: TBBotAdvAttack; AJson: TJson);
    destructor Destroy; override;

    property Shooter: TBBotTargetAreaShooter read FShooter;

    function Execute: BBool; override;
  end;

  TBBotAdvAttack = class(TBBotAction)
  private type
    TBBotAdvAttackCreatureData = record
      Name: BStr;
      Priority: BInt32;
      AvoidWaves: BBool;
      Distance: BInt32;
      Macro: BStr;
      MacroOnAttack: BStr;
      MacroOnStop: BStr;
    end;
  private
    ChangeFloors: BCache<BPos, BBool>;
    FHistory: BVector<BPos>;
    FHistoryIndex: BInt32;
    LastHistory: BPos;
    CreatureSettings: BVector<TBBotAdvAttackCreatureData>;
    AdvancedAttacks: BVector<TBBotAdvancedAttackBase>;
    Sequences: BVector<TBBotAttackSequence>;
    FAvoidTime: BUInt32;
    FStopMacro: BStr;
    FAvoidChangeFloorAOE: BBool;
    FKeepDiagonal: BBool;
    FKeepDistance: BUInt32;
    FAutoMacro: BStr;
    function GetCreatureSettings(ACreature: TBBotCreature)
      : BVector<TBBotAdvAttackCreatureData>.It;
    procedure ClearCurrentCreatureSetting;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAttackSequence(const ACode: BStr): TBBotAttackSequence;
    function GetAttackSequenceByName(const AName: BStr): TBBotAttackSequence;
    function AddSequence(const ACode: BStr): BVector<TBBotAttackSequence>.It;
    procedure ClearSequences;

    procedure AddCreatureSetting(const ACreatureSetting: BStr);
    procedure ClearCreatureSettings;

    procedure AddAdvancedAttack(const AJson: TJson);
    procedure ClearAdvancedAttacks;

    procedure OnTarget(OldCreature: TBBotCreature);

    procedure OnInit; override;
    procedure Run; override;

    function KillerKnown(Creature: TBBotCreature): BBool;
    function KillerPriority(Creature: TBBotCreature): BInt32;
    function AttackablePriority(Creature: TBBotCreature): BBool;

    procedure AddChangeFloorUnsafePositions(const APositions: BVector<BPos>);
    function GenerateUnsafePositions: BVector<BPos>;

    property AvoidTime: BUInt32 read FAvoidTime write FAvoidTime;

    property AutoMacro: BStr read FAutoMacro;
    property StopMacro: BStr read FStopMacro;
    property KeepDistance: BUInt32 read FKeepDistance;
    property KeepDiagonal: BBool read FKeepDiagonal;
    property AvoidChangeFloorAOE: BBool read FAvoidChangeFloorAOE
      write FAvoidChangeFloorAOE;

    property History: BVector<BPos> read FHistory;
    procedure OnWalk(FromPos: BPos);
  end;

implementation

{ TBBotAdvAttack }

uses
  BBotEngine,
  uDistance,

  uUserError,
  Declaracoes,
  uTiles;

function TBBotAdvAttack.AddSequence(const ACode: BStr)
  : BVector<TBBotAttackSequence>.It;
begin
  Result := Sequences.Add;
  Result^ := TBBotAttackSequence.Create;
  Result^.Load(ACode);
end;

procedure TBBotAdvAttack.AddChangeFloorUnsafePositions(const APositions
  : BVector<BPos>);
var
  X, Y: BInt32;
  Pos: BPos;
begin
  for X := -8 to +8 do
    for Y := -6 to +6 do
    begin
      Pos := BPosXYZ(Me.Position.X + X, Me.Position.Y + Y, Me.Position.Z);
      if ChangeFloors.Get(Pos) then
        APositions.Add(Pos);
    end;
end;

procedure TBBotAdvAttack.AddAdvancedAttack(const AJson: TJson);
var
  Kind: BStr;
  AdvAtk: TBBotAdvancedAttackBase;
begin
  Kind := AJson.Get('type').AsString;
  if BStrEqual(Kind, 'Single') then
    AdvAtk := TBBotAdvancedAttackSingle.Create(Self, AJson)
  else if BStrEqual(Kind, 'AreaSpell') then
    AdvAtk := TBBotAdvancedAttackSelfArea.Create(Self, AJson)
  else if BStrEqual(Kind, 'AreaShooter') then
    AdvAtk := TBBotAdvancedAttackBestArea.Create(Self, AJson)
  else if BStrEqual(Kind, 'Waver') then
    AdvAtk := TBBotAdvancedAttackWaver.Create(Self, AJson)
  else
    Exit;
  AdvancedAttacks.Add(AdvAtk);
end;

procedure TBBotAdvAttack.AddCreatureSetting(const ACreatureSetting: BStr);
var
  R: BStrArray;
  P: BVector<TBBotAdvAttackCreatureData>.It;
begin
  if BStrSplit(R, ':', ACreatureSetting) < 6 then
    Exit;
  P := CreatureSettings.Add;
  P^.Name := R[0];
  P^.Priority := BStrTo32(R[1], 1);
  P^.Distance := BStrTo32(R[2], 1);
  P^.AvoidWaves := R[3] = '1';
  P^.Macro := R[4];
  P^.MacroOnAttack := R[5];
  P^.MacroOnStop := R[6];
  if BStrPos(':Atk@', ACreatureSetting) > 0 then
    raise BException.Create
      ('Warning, Atk@ present while adding creature settings');
end;

function TBBotAdvAttack.AttackablePriority(Creature: TBBotCreature): BBool;
var
  It: BVector<TBBotAdvAttackCreatureData>.It;
begin
  Result := True;
  It := GetCreatureSettings(Creature);
  if It <> nil then
  begin
    if It^.Priority = BBotAdvAttackIgnore then
      Exit(False)
    else if (It^.Priority = BBotAdvAttackAvoid) and (BBot.StandTime < AvoidTime)
    then
      Exit(False);
  end;
end;

procedure TBBotAdvAttack.ClearSequences;
begin
  Sequences.Clear;
end;

procedure TBBotAdvAttack.ClearCurrentCreatureSetting;
begin
  FAutoMacro := '';
  FStopMacro := '';
  FKeepDiagonal := False;
  FKeepDistance := 0;
end;

procedure TBBotAdvAttack.ClearAdvancedAttacks;
begin
  AdvancedAttacks.Clear;
end;

procedure TBBotAdvAttack.ClearCreatureSettings;
begin
  CreatureSettings.Clear;
end;

function CreateChangeFloorCache: BCache<BPos, BBool>;
begin
  Exit(BCache<BPos, BBool>.Create(
    function(AKey: BPos): BBool
    var
      Map: TTibiaTiles;
    begin
      Exit(TilesSearch(Map, AKey, 1, False,
        function: BBool
        begin
          Exit(Map.ChangeLevel);
        end));
    end, BPosComparator));
end;

constructor TBBotAdvAttack.Create;
var
  I: BInt32;
begin
  inherited Create('AdvAttack', 1);
  CreatureSettings := BVector<TBBotAdvAttackCreatureData>.Create;
  AdvancedAttacks := BVector<TBBotAdvancedAttackBase>.Create(
    procedure(AIt: BVector<TBBotAdvancedAttackBase>.It)
    begin
      AIt^.Free;
    end);
  Sequences := BVector<TBBotAttackSequence>.Create(
    procedure(It: BVector<TBBotAttackSequence>.It)
    begin
      It^.Free;
    end);
  ChangeFloors := CreateChangeFloorCache;
  AvoidTime := BBotAdvAttackAvoidTimeDefault;
  ClearCurrentCreatureSetting;
  FHistory := BVector<BPos>.Create();
  for I := 0 to BBotWalkerHistoryCount do
    FHistory.Add;
  FHistoryIndex := 0;
  LastHistory.zero;
end;

destructor TBBotAdvAttack.Destroy;
begin
  ChangeFloors.Free;
  CreatureSettings.Free;
  AdvancedAttacks.Free;
  Sequences.Free;
  FHistory.Free;
  inherited;
end;

function TBBotAdvAttack.GetAttackSequence(const ACode: BStr)
  : TBBotAttackSequence;
var
  AtkSeq: BVector<TBBotAttackSequence>.It;
begin
  Result := nil;
  if ACode <> '' then
  begin
    AtkSeq := Sequences.Find('Attack Sequences cache for ' + ACode,
      function(Its: BVector<TBBotAttackSequence>.It): BBool
      begin
        Result := BStrEqual(Its^.Name, ACode) or BStrEqual(Its^.Code, ACode);
      end);
    if AtkSeq = nil then
      AtkSeq := AddSequence(ACode);
    if AtkSeq <> nil then
      Result := AtkSeq^;
  end;
end;

function TBBotAdvAttack.GetAttackSequenceByName(const AName: BStr)
  : TBBotAttackSequence;
var
  AtkSeq: BVector<TBBotAttackSequence>.It;
begin
  Result := nil;
  AtkSeq := Sequences.Find('Attack Sequences - get by name ' + AName,
    function(Its: BVector<TBBotAttackSequence>.It): BBool
    begin
      Result := BStrEqual(Its^.Name, AName);
    end);
  if AtkSeq <> nil then
    Result := AtkSeq^;
end;

function TBBotAdvAttack.GetCreatureSettings(ACreature: TBBotCreature)
  : BVector<TBBotAdvAttackCreatureData>.It;
  procedure InternalFindCreatureSetting(AName: BStr);
  begin
    Result := CreatureSettings.Find('Attack Settings - get by name ' + AName,
      function(It: BVector<TBBotAdvAttackCreatureData>.It): BBool
      begin
        Result := BStrEqual(It^.Name, AName);
      end);
  end;

begin
  InternalFindCreatureSetting(ACreature.Name);
  if Result = nil then
    if ACreature.IsPlayer then
      InternalFindCreatureSetting(BBotAdvAttackDefaultPlayer)
    else
      InternalFindCreatureSetting(BBotAdvAttackDefaultCreature);
end;

function TBBotAdvAttack.KillerKnown(Creature: TBBotCreature): BBool;
begin
  Result := CreatureSettings.Has('Killer known ' + Creature.Name,
    function(It: BVector<TBBotAdvAttackCreatureData>.It): BBool
    begin
      Result := BStrEqual(It^.Name, Creature.Name) and
        (It^.Priority <> BBotAdvAttackIgnore) and
        ((It^.Priority <> BBotAdvAttackAvoid) or (BBot.StandTime > AvoidTime));
    end);
end;

function TBBotAdvAttack.KillerPriority(Creature: TBBotCreature): BInt32;
var
  It: BVector<TBBotAdvAttackCreatureData>.It;
begin
  It := GetCreatureSettings(Creature);
  Result := 1;
  if It <> nil then
    Exit(It^.Priority);
end;

procedure TBBotAdvAttack.OnInit;
begin
  BBot.Events.OnTarget.Add(OnTarget);
  BBot.Events.OnWalk.Add(OnWalk);

  BBot.Macros.Registry.CreateSystemVariable(BBotAdvAttackAvoidTimeVar,
    BBotAdvAttackAvoidTimeDefault).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      AvoidTime := BUInt32(AValue);
    end);
end;

procedure TBBotAdvAttack.OnTarget(OldCreature: TBBotCreature);
var
  AdvIt: BVector<TBBotAdvAttackCreatureData>.It;
begin
  BBot.Macros.Execute(StopMacro);
  ClearCurrentCreatureSetting;
  if Me.IsAttacking then
  begin
    AdvIt := GetCreatureSettings(BBot.Creatures.Target);
    if AdvIt <> nil then
    begin
      BBot.Macros.Execute(AdvIt^.MacroOnAttack);
      FStopMacro := AdvIt^.MacroOnStop;
      FAutoMacro := AdvIt^.Macro;
      FKeepDiagonal := AdvIt^.AvoidWaves;
      FKeepDistance := AdvIt^.Distance;
    end;
  end;
end;

procedure TBBotAdvAttack.OnWalk(FromPos: BPos);
begin
  if (not Me.IsAttacking) and ((Me.Position.Z <> LastHistory.Z) or
    (SQMDistance(Me.Position.X, Me.Position.Y, LastHistory.X, LastHistory.Y)
    < 3)) then
  begin
    Inc(FHistoryIndex);
    FHistoryIndex := FHistoryIndex mod BBotWalkerHistoryCount;
    FHistory.Item[FHistoryIndex]^ := FromPos;
  end;
end;

procedure TBBotAdvAttack.Run;
begin
  BExecuteInSafeScope('AdvancedAttack:AutoMacro',
    procedure
    begin
      if AutoMacro <> '' then
        BBot.Macros.Execute(AutoMacro);
    end);
  AdvancedAttacks.Has('AdvancedAttack:Has',
    function(AIt: BVector<TBBotAdvancedAttackBase>.It): BBool
    var
      Res: BBool;
    begin
      BExecuteInSafeScope('AdvancedAttack:' + AIt^.Kind + ':' + AIt^.Name,
        procedure
        begin
          Res := AIt^.Execute;
        end);
      Exit(Res);
    end);
  if Me.IsAttacking then
  begin
    if KeepDistance <> 0 then
    begin
      BExecuteInSafeScope('AdvancedAttack:KeepDistance',
        procedure
        begin
          BBot.Creatures.Target.KeepDistance(KeepDistance);
        end);
    end;
    if KeepDiagonal then
    begin
      BExecuteInSafeScope('AdvancedAttack:KeepDiagonal',
        procedure
        begin
          BBot.Creatures.Target.KeepDiagonal;
        end);
    end;
  end;
  // {$IFNDEF RELEASE}
  // TestWaverShooter;
  // TestTargetAreaShooter;
  // {$ENDIF}
end;

function TBBotAdvAttack.GenerateUnsafePositions: BVector<BPos>;
begin
  Result := BVector<BPos>.Create;
  if AvoidChangeFloorAOE then
    AddChangeFloorUnsafePositions(Result);
  BBot.SpecialSQMs.AddSpellsAvoidSQMs(Result);
end;

{ TBBotAdvancedAttackBase }

constructor TBBotAdvancedAttackBase.Create(AAdvAttack: TBBotAdvAttack;

AJson: TJson);
begin
  AdvAttack := AAdvAttack;
  Json := AJson;
  FCreatures := BVector<BStr>.Create();
  ParseCreatures;
  FName := Json.Get('name').AsString;
  FAttackSequence := Json.Get('action').AsString;
  FKind := AJson.Get('type').AsString;
  IncludedCreatures := BVector<TBBotCreature>.Create();
  ExcludedCreatures := BVector<TBBotCreature>.Create();
end;

destructor TBBotAdvancedAttackBase.Destroy;

begin
  FCreatures.Free;
  IncludedCreatures.Free;
  ExcludedCreatures.Free;
  inherited;
end;

procedure TBBotAdvancedAttackBase.GenerateCreatureLists;

begin
  IncludedCreatures.Clear;
  ExcludedCreatures.Clear;
  BBot.Creatures.Traverse(
    procedure(C: TBBotCreature)
    begin
      if (not C.IsSelf) and (C.IsAlive) then
        if IncludesCreature(C) then
          IncludedCreatures.Add(C)
        else
          ExcludedCreatures.Add(C);
    end);
end;

function TBBotAdvancedAttackBase.GetAttackSequence: TBBotAttackSequence;
var
  Err: BUserError;
begin
  Result := AdvAttack.GetAttackSequenceByName(AttackSequence);
  if Result = nil then
  begin
    Err := BUserError.Create(AdvAttack,
      BFormat('Missing attack sequence "%s" required by "%s" advanced attack.',
      [AttackSequence, Name]));
    Err.DisableCavebot := True;
    Err.Actions := [uraEditAdvancedAttack];
    Err.Execute;
  end;
end;

function TBBotAdvancedAttackBase.IncludesCreature
  (ACreature: TBBotCreature): BBool;

begin
  if ACreature.IsPlayer and BBot.Attacker.NeverAttackPlayers then
    Exit(False);
  Exit(Creatures.Has('AdvancedAttack:IncludesCreature ' + ACreature.Name,
    function(AIt: BVector<BStr>.It): BBool
    begin
      Result := BStrEqual(AIt^, '%Any') or BStrEqual(AIt^, ACreature.Name) or
        (BStrEqual(AIt^, '%Players') and (ACreature.IsPlayer)) or
        (BStrEqual(AIt^, '%Monsters') and (ACreature.IsNPC));
    end));
end;

procedure TBBotAdvancedAttackBase.ParseCreatures;

var

  JsonCreatures: TJsonArray;

  I: BInt32;

begin
  JsonCreatures := Json.Get('creatures').AsArray;
  for I := 0 to JsonCreatures.Count - 1 do
    Creatures.Add(JsonCreatures.Items[I].AsString);
end;

{ TBBotAdvancedAttackSingle }

constructor TBBotAdvancedAttackSingle.Create(AAdvAttack: TBBotAdvAttack;

AJson: TJson);
begin
  inherited Create(AAdvAttack, AJson);
end;

function TBBotAdvancedAttackSingle.Execute: BBool;
var
  Seq: TBBotAttackSequence;
begin
  if Me.IsAttacking and IncludesCreature(BBot.Creatures.Target) then
  begin
    Seq := GetAttackSequence;
    if (Seq <> nil) and (Seq.CanExecute) then
      Exit(Seq.Execute);
  end;
  Exit(False);
end;

{ TBBotAdvancedAttackWaver }

constructor TBBotAdvancedAttackWaver.Create(AAdvAttack: TBBotAdvAttack;

AJson: TJson);
var
  Expansion: BStr;
  I: BInt32;
begin
  inherited Create(AAdvAttack, AJson);
  FShooter := TBBotWaverShooter.Create;
  Expansion := Json.Get('expansion').AsString;
  while BStrEnd(Expansion, '0') do
    Expansion := BStrLeft(Expansion, Length(Expansion) - 1);
  for I := 1 to Length(Expansion) do
    FShooter.Expansion.Add(BStrTo32(Expansion[I]));
end;

destructor TBBotAdvancedAttackWaver.Destroy;

begin
  FShooter.Free;
  inherited;
end;

function TBBotAdvancedAttackWaver.Execute: BBool;
var
  Seq: TBBotAttackSequence;
  UnsafePositions: BVector<BPos>;
begin
  GenerateCreatureLists;
  UnsafePositions := AdvAttack.GenerateUnsafePositions;
  Shooter.OptimalWave(IncludedCreatures, ExcludedCreatures, UnsafePositions);
  UnsafePositions.Free;
  if Shooter.Allowed and (BUInt32(Shooter.CreaturesOnTarget.Count) >=
    MinCreatures) then
  begin
    Seq := GetAttackSequence;
    if (Seq <> nil) and (Seq.CanExecute) then
      if Me.Direction <> Shooter.Direction then
        Me.Turn(Shooter.Direction);
    Exit(Seq.Execute(Me.Position));
  end;
  Exit(False);
end;

{ TBBotAdvancedAttackMultiple }

constructor TBBotAdvancedAttackMultiple.Create(AAdvAttack: TBBotAdvAttack;

AJson: TJson);
begin
  inherited Create(AAdvAttack, AJson);
  FMinCreatures := BUInt32(Json.Get('minCreatures').AsInteger);
end;

{ TBBotAdvancedAttackSelfArea }

function TBBotAdvancedAttackSelfArea.CanShoot: BBool;
var
  ValidTargets, InvalidTargets: BUInt32;
begin
  if not InSafeArea then
    Exit(False);
  ValidTargets := 0;
  InvalidTargets := 0;
  BBot.Creatures.Traverse(
    procedure(C: TBBotCreature)
    begin
      if (not C.IsSelf) and InAreaRange(C.Position) and (C.IsAlive) then
      begin
        if IncludesCreature(C) then
          Inc(ValidTargets)
        else
          Inc(InvalidTargets);
      end;
    end);
  Result := (InvalidTargets = 0) and (ValidTargets >= MinCreatures);
end;

function TBBotAdvancedAttackSelfArea.InAreaRange(APos: BPos): BBool;
begin
  Exit(BUInt32(Me.DistanceTo(APos)) <= Radius);
end;

function TBBotAdvancedAttackSelfArea.InSafeArea: BBool;
var
  UnsafePositions: BVector<BPos>;
begin
  UnsafePositions := AdvAttack.GenerateUnsafePositions;
  Result := not UnsafePositions.Has('AdvancedAttack:SelfArea:IsInSafeArea',
    function(AIt: BVector<BPos>.It): BBool
    begin
      Exit(InAreaRange(AIt^));
    end);
  UnsafePositions.Free;
end;

constructor TBBotAdvancedAttackSelfArea.Create(AAdvAttack: TBBotAdvAttack;

AJson: TJson);
begin
  inherited Create(AAdvAttack, AJson);
  FRadius := BUInt32(Json.Get('radius').AsInteger);
end;

function TBBotAdvancedAttackSelfArea.Execute: BBool;
var
  Seq: TBBotAttackSequence;
begin
  if CanShoot then
  begin
    Seq := GetAttackSequence;
    if (Seq <> nil) and (Seq.CanExecute) then
      Exit(Seq.Execute(Me.Position));
  end;
  Exit(False);
end;

{ TBBotAdvancedAttackBestArea }

constructor TBBotAdvancedAttackBestArea.Create(AAdvAttack: TBBotAdvAttack;

AJson: TJson);
begin
  inherited Create(AAdvAttack, AJson);
  FShooter := TBBotTargetAreaShooter.Create;
  FShooter.Range := BUInt32(Json.Get('radius').AsInteger);
  FShooter.LimitScreen := BUInt32(Json.Get('limitScreen').AsInteger);
end;

destructor TBBotAdvancedAttackBestArea.Destroy;

begin
  FShooter.Free;
  inherited;
end;

function TBBotAdvancedAttackBestArea.Execute: BBool;
var
  Seq: TBBotAttackSequence;
  UnsafePositions: BVector<BPos>;
begin
  GenerateCreatureLists;
  UnsafePositions := AdvAttack.GenerateUnsafePositions;
  Shooter.OptimalShoot(IncludedCreatures, ExcludedCreatures, UnsafePositions);
  UnsafePositions.Free;
  if Shooter.Allowed and (Shooter.CreaturesOnTarget >= MinCreatures) then
  begin
    if BBot.Walker.WalkableCost(Shooter.Target) < TileCost_NotWalkable then
    begin
      Seq := GetAttackSequence;
      if (Seq <> nil) and (Seq.CanExecute) then
        Exit(Seq.Execute(Shooter.Target));
    end;
  end;
  Exit(False);
end;

end.

