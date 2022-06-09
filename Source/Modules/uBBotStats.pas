unit uBBotStats;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uTibiaDeclarations,
  Declaracoes,
  Math,
  uHUD,
  uBattlelist,
  uBBotSpells,
  uEventCounter;

const
  BBotStatsRefreshDelay = 1600;

type
  TBBotStats = class;

  TBBotStatsAction = class(TBBotAction)
  private
    FAlignHorizontal: TBBotHUDAlign;
    FEnabledHUD: BBool;
    FAlignVertical: TBBotHUDVAlign;
  protected
    Stats: TBBotStats;
    function CreateHUD(AHUDGroup: TBBotHUDGroup; AName: BStr; AColor: BInt32): TBBotHUD;
  public
    constructor Create(AName: BStr; AStats: TBBotStats; AAlignHorizontal: TBBotHUDAlign;
      AAlignVertical: TBBotHUDVAlign);

    property EnabledHUD: BBool read FEnabledHUD write FEnabledHUD;
    property AlignHorizontal: TBBotHUDAlign read FAlignHorizontal write FAlignHorizontal;
    property AlignVertical: TBBotHUDVAlign read FAlignVertical write FAlignVertical;

    procedure ShowHUD; virtual; abstract;
    procedure Reset; virtual; abstract;
    procedure Run; override;
  end;

  TBBotStats = class(TBBotAction)
  private
    StatsStart: BUInt32;
    FExpGotInformations: boolean;
    FExpInformations: boolean;
    FAutoShowStatistics: boolean;
    FSkillsGotInformations: BBool;
    FScreenShootOnAdvancements: BBool;
    FMagicWallsHUD: BBool;
    FSpellsHUD: BBool;
    FLootHUD: BBool;
    FLevelSpy: BBool;
    FAttackedStats: TEventCounter;
    FHPStats: TEventCounter;
    FManaStats: TEventCounter;
    FShootStats: TEventCounter;
    function GetStatsTime: BUInt32;
    procedure SetLevelSpy(const Value: BBool);
    procedure UpdateSuplies(const Text: BStr);
    function GetPerHourFactor: BDbl;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnSkill(Skill: TTibiaSkill; OldSkill: BInt32);
    procedure OnLevel(OldLevel: BInt32);
    procedure OnExp(OldExp: Int64);
    procedure OnHotkey;
    procedure OnCharacter;
    procedure OnSpell(ASpell: TTibiaSpell);
    procedure OnSystemMessage(AMessageData: TTibiaMessage);
    procedure OnMagicWall(Position: BPos; Duration: BUInt32);
    procedure OnPossiblyRemovedMagicWall(APosition: BPos);
    procedure OnCreatureDie(Creature: TBBotCreature);

    procedure ResetStatistics;

    procedure ShowHUD;

    property MagicWallsHUD: BBool read FMagicWallsHUD write FMagicWallsHUD;
    property SpellsHUD: BBool read FSpellsHUD write FSpellsHUD;

    property HPStats: TEventCounter read FHPStats;
    property ManaStats: TEventCounter read FManaStats;
    property ShootStats: TEventCounter read FShootStats;
    property AttackedStats: TEventCounter read FAttackedStats;

    property ScreenShootOnAdvancements: BBool read FScreenShootOnAdvancements write FScreenShootOnAdvancements;
    property SkillsGotInformations: BBool read FSkillsGotInformations write FSkillsGotInformations;
    property ExpGotInformations: boolean read FExpGotInformations write FExpGotInformations;
    property ExpInformations: boolean read FExpInformations write FExpInformations;
    property AutoShowStatistics: boolean read FAutoShowStatistics write FAutoShowStatistics;
    property StatsTime: cardinal read GetStatsTime;
    property PerHourFactor: BDbl read GetPerHourFactor;
    property LootHUD: BBool read FLootHUD write FLootHUD;
    property LevelSpy: BBool read FLevelSpy write SetLevelSpy;
  end;

type
  TSpellHUD = record
    Name: BStr;
    R, G, B: BInt32;
    Time: BInt32;
    HUDClass: TBBotHUDGroup;
  end;

const
  SpellHUD: array [0 .. 15] of TSpellHUD = ((Name: 'Magic Shield'; R: 120; G: 120; B: 255; Time: 200;
    HUDClass: bhgManaShield;), (Name: 'Invisible'; R: 255; G: 255; B: 255; Time: 200; HUDClass: bhgInvisible;
    ), (Name: 'Haste'; R: 255; G: 255; B: 204; Time: 33; HUDClass: bhgHaste;), (Name: 'Strong Haste'; R: 255; G: 255;
    B: 204; Time: 22; HUDClass: bhgHaste;), (Name: 'Blood Rage'; R: 150; G: 255; B: 255; Time: 10; HUDClass: bhgSuper;
    ), (Name: 'Charge'; R: 150; G: 255; B: 255; Time: 5; HUDClass: bhgSuper;
    ), (Name: 'Heal Party'; R: 51; G: 153; B: 255; Time: 120; HUDClass: bhgPartyBuff;
    ), (Name: 'Train Party'; R: 51; G: 153; B: 255; Time: 120; HUDClass: bhgPartyBuff;
    ), (Name: 'Protect Party'; R: 51; G: 153; B: 255; Time: 120; HUDClass: bhgPartyBuff;
    ), (Name: 'Enchant Party'; R: 51; G: 153; B: 255; Time: 120; HUDClass: bhgPartyBuff;
    ), (Name: 'Creature Illusion'; R: 152; G: 100; B: 152; Time: 180; HUDClass: bhgIllusion;
    ), (Name: 'Protector'; R: 150; G: 255; B: 255; Time: 10; HUDClass: bhgSuper;
    ), (Name: 'Sharpshooter'; R: 150; G: 255; B: 255; Time: 10; HUDClass: bhgSuper;
    ), (Name: 'Swift Foot'; R: 150; G: 255; B: 255; Time: 10; HUDClass: bhgSuper;
    ), (Name: 'Recovery'; R: 187; G: 253; B: 206; Time: 60; HUDClass: bhgRecovery;
    ), (Name: 'Intense Recovery'; R: 187; G: 253; B: 206; Time: 60; HUDClass: bhgRecovery;));

implementation

uses
  uTibia,
  BBotEngine,
  SysUtils,
  uItem,
  Windows,
  uTiles;

{ TBBotStats }

constructor TBBotStats.Create;
begin
  inherited Create('Stats', BBotStatsRefreshDelay);
  FormatSettings.ThousandSeparator := '.';
  ExpInformations := False;
  ExpGotInformations := False;
  SkillsGotInformations := False;
  ScreenShootOnAdvancements := False;
  MagicWallsHUD := True;
  SpellsHUD := True;
  LootHUD := False;
  FLevelSpy := False;
  FAttackedStats := TEventCounter.Create;
  FAttackedStats.Unique := True;
  FHPStats := TEventCounter.Create;
  FManaStats := TEventCounter.Create;
  FShootStats := TEventCounter.Create;
end;

procedure TBBotStats.Run;
begin
  if AutoShowStatistics then
    ShowHUD
  else if ExpInformations then
    BBot.ExpStats.ShowHUD;
end;

destructor TBBotStats.Destroy;
begin
  FAttackedStats.Free;
  FHPStats.Free;
  FManaStats.Free;
  FShootStats.Free;
  inherited;
end;

function TBBotStats.GetPerHourFactor: BDbl;
begin
  Result := 3600 / StatsTime;
end;

function TBBotStats.GetStatsTime: BUInt32;
begin
  Result := Max(((Tick - StatsStart) + 1) div 1000, 1);
end;

procedure TBBotStats.OnCharacter;
begin
  ResetStatistics;
end;

procedure TBBotStats.OnCreatureDie(Creature: TBBotCreature);
begin
  if Creature.ID = Me.LastAttackedID then
    BBot.KillStats.Add(Creature.Name);
end;

procedure TBBotStats.OnExp(OldExp: Int64);
var
  HUD: TBBotHUD;
begin
  if OldExp < Me.Experience then
    if ExpGotInformations then begin
      HUD := TBBotHUD.Create(bhgAny);
      HUD.AlignTo(bhaCenter, bhaBottom);
      HUD.Expire := 2000;
      HUD.PrintGray(BFormat('+%sx the exp gained to level',
        [I2FS(Ceil((Tibia.CalcExp(Me.Level + 1) - Me.Experience) / (Me.Experience - OldExp)))]));
      HUD.Free;
    end;
end;

procedure TBBotStats.OnHotkey;
begin
  if Tibia.IsKeyDown(VK_SHIFT, False) then begin
    if Tibia.IsKeyDown(VK_HOME, True) then
      ShowHUD;
    if LevelSpy and Tibia.IsKeyDown(VK_NEXT, True) then
      BBot.LevelSpy.DecFloor;
    if LevelSpy and Tibia.IsKeyDown(VK_PRIOR, True) then
      BBot.LevelSpy.IncFloor;
  end;
end;

procedure TBBotStats.OnInit;
begin
  inherited;
  BBot.Events.OnCreatureDie.Add(OnCreatureDie);
  BBot.Events.OnLevel.Add(OnLevel);
  BBot.Events.OnExp.Add(OnExp);
  BBot.Events.OnSkill.Add(OnSkill);
  BBot.Events.OnCharacter.Add(OnCharacter);
  BBot.Events.OnHotkey.Add(OnHotkey);
  BBot.Events.OnSpell.Add(OnSpell);
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);
  BBot.Events.OnCreatureAttack.Add(
    procedure(Creature: TBBotCreature)
    begin
      AttackedStats.Add(Creature.ID);
    end);
  BBot.Events.OnHP.Add(
    procedure(OldHP: BInt32)
    begin
      HPStats.Add(Me.HP - OldHP);
    end);
  BBot.Events.OnMana.Add(
    procedure(OldMana: BInt32)
    begin
      ManaStats.Add(Me.Mana - OldMana);
    end);
  BBot.Events.OnMissileEffect.Add(
    procedure(AMissileEffect: TTibiaMissileEffect)
    begin
      if AMissileEffect.ToPosition = Me.Position then
        ShootStats.Add(AMissileEffect.Effect);
    end);
end;

procedure TBBotStats.OnLevel(OldLevel: BInt32);
begin
  if ScreenShootOnAdvancements then
    Tibia.ScreenShot;
end;

procedure TBBotStats.OnMagicWall(Position: BPos; Duration: BUInt32);
var
  HUD: TBBotHUD;
begin
  if not MagicWallsHUD then
    Exit;
  HUD := TBBotHUD.Create(bhgMWall);
  HUD.SetPosition(Position);
  HUD.Expire := Duration;
  HUD.Print('#', $FFFFC8);
  HUD.Free;
end;

procedure TBBotStats.OnPossiblyRemovedMagicWall(APosition: BPos);
var
  Map: TTibiaTiles;
begin
  if not TilesSearch(Map, APosition, 0, False,
    function: BBool
    begin
      Result := BIntIn(Map.ID, MagicWallField) or BIntIn(Map.ID, WildGrowthField);
    end) then
    HUDRemovePositionGroup(APosition.X, APosition.Y, APosition.Z, bhgMWall);
end;

procedure TBBotStats.OnSkill(Skill: TTibiaSkill; OldSkill: BInt32);
var
  HUD: TBBotHUD;
begin
  if ScreenShootOnAdvancements and (Me.SkillPercent[Skill] = 0) then
    Tibia.ScreenShot;
  if SkillsGotInformations then
    if ((OldSkill mod 100) < Me.SkillPercent[Skill]) and (Me.SkillPercent[Skill] <> 0) then begin
      HUD := TBBotHUD.Create(bhgAny);
      HUD.AlignTo(bhaCenter, bhaBottom);
      HUD.Expire := 3000;
      HUD.PrintGray(BFormat('%s %d%%', [SkillToStr(Skill), Me.SkillPercent[Skill]]));
      HUD.Free;
    end;
end;

procedure TBBotStats.OnSpell(ASpell: TTibiaSpell);
var
  HUD: TBBotHUD;
  I: BInt32;
begin
  if ASpell.Name = 'Cancel Invisibility' then
    HUDRemoveGroup(bhgIllusion);
  if SpellsHUD then
    for I := 0 to High(SpellHUD) do
      if ASpell.Name = SpellHUD[I].Name then begin
        HUDRemoveGroup(SpellHUD[I].HUDClass);
        HUD := TBBotHUD.Create(SpellHUD[I].HUDClass);
        HUD.AlignTo(bhaRight, bhaBottom);
        HUD.RelativeY := -32;
        HUD.Color := RGB(SpellHUD[I].R, SpellHUD[I].G, SpellHUD[I].B);
        HUD.Expire := SpellHUD[I].Time * 1000;
        HUD.Print(SpellHUD[I].Name + ': #');
        HUD.Free;
        Exit;
      end;
end;

procedure TBBotStats.OnSystemMessage(AMessageData: TTibiaMessage);
var
  HUD: TBBotHUD;
begin
  UpdateSuplies(AMessageData.Text);
  if LootHUD and BStrStart(AMessageData.Text, 'Loot of') then begin
    HUD := TBBotHUD.Create(bhgAny);
    HUD.Expire := 7000;
    HUD.AlignTo(bhaLeft, bhaBottom);
    HUD.Print(AMessageData.Text, $00CC00);
    HUD.Free;
  end;
end;

procedure TBBotStats.ResetStatistics;
begin
  StatsStart := Tick;
  BBot.ExpStats.Reset;
  BBot.SkillsStats.Reset;
  BBot.LooterStats.Reset;
  BBot.ProfitStats.Reset;
  BBot.SupliesStats.Reset;
  BBot.KillStats.Reset;
end;

procedure TBBotStats.SetLevelSpy(const Value: BBool);
begin
  if Value <> FLevelSpy then begin
    if Value then begin
      Tibia.BlockKeyCallback(VK_NEXT, True, False);
      Tibia.BlockKeyCallback(VK_PRIOR, True, False);
    end else begin
      Tibia.UnBlockKeyCallback(VK_NEXT, True, False);
      Tibia.UnBlockKeyCallback(VK_PRIOR, True, False);
    end;
  end;
  FLevelSpy := Value;
end;

procedure TBBotStats.ShowHUD;
begin
  BBot.ExpStats.ShowHUD;
  BBot.SkillsStats.ShowHUD;
  BBot.SupliesStats.ShowHUD;
  BBot.LooterStats.ShowHUD;
  BBot.ProfitStats.ShowHUD;
  BBot.KillStats.ShowHUD;
end;

procedure TBBotStats.UpdateSuplies(const Text: BStr);
// Using (one of <num>|the last) <item name>[s]...
var
  ItemName: BStr;
  ItemCount: BInt32;
  T1, T2: BStr;
begin
  if BStrLeft(Text, 5) = 'Using' then begin
    ItemCount := 0;
    T1 := BStrRight(Text, Length(Text) - 6); // 'Using ' = 6
    if BStrLeft(T1, 3) = 'one' then begin
      T1 := BStrRight(T1, Length(T1) - 7); // 'one of ' = 7
      T2 := BStrLeft(T1, AnsiPos(' ', T1) - 1); // Get the number of items
      if BStrIsNumber(T2) then
        ItemCount := StrToInt(T2) - 1;
      T1 := BStrLeft(T1, AnsiPos('...', T1) - 1); // Remove the ...
      T1 := BStrRight(T1, Length(T1) - Length(T2) - 1);
      // Remove the ItemCount + space
    end else begin // Last
      T1 := BStrRight(Text, Length(Text) - 15); // 'Using the last ' = 15
      T1 := BStrLeft(T1, AnsiPos('...', T1) - 1); // Remove the ...
    end;
    ItemName := T1;
    BBot.SupliesStats.Update(ItemName, ItemCount);
  end;
end;

{ TBBotStatsAction }

constructor TBBotStatsAction.Create(AName: BStr; AStats: TBBotStats; AAlignHorizontal: TBBotHUDAlign;
AAlignVertical: TBBotHUDVAlign);
begin
  inherited Create('Stats.' + AName, BBotStatsRefreshDelay);
  Stats := AStats;
  FAlignHorizontal := AAlignHorizontal;
  FAlignVertical := AAlignVertical;
  FEnabledHUD := False;
end;

function TBBotStatsAction.CreateHUD(AHUDGroup: TBBotHUDGroup; AName: BStr; AColor: BInt32): TBBotHUD;
begin
  HUDRemoveGroup(AHUDGroup);
  Result := TBBotHUD.Create(AHUDGroup);
  Result.AlignTo(FAlignHorizontal, FAlignVertical);
  Result.Expire := 5000;
  Result.Print(AName, AColor);
  Result.Color := HUDGrayColor;
  if FAlignHorizontal = bhaLeft then
    Result.RelativeX := +4
  else if FAlignHorizontal = bhaRight then
    Result.RelativeX := -4;
end;

procedure TBBotStatsAction.Run;
begin
end;

end.
