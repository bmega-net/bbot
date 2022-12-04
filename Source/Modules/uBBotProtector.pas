unit uBBotProtector;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  Classes,
  uBattlelist,
  uTibiaDeclarations;

const
  BBotProtectorClickID = 1002;

type
  TBBotProtectorKind = (bpkFirst = 1, bpkMoved = bpkFirst, bpkMessaged,
    bpkPrivateMessage, bpkDisconnected, bpkNoFood, bpkGameMaster,
    bpkFurnitureonScreen, bpkCreatureonScreen, bpkPlayeronScreen,
    bpkPlayeronScreenwithSkull, bpkAttacked, bpkAttackedbyPlayer,
    bpkElementalDamage, bpkStucked,
    // (Param:N>)
    bpkDamagedBy, // (Param:N>)
    bpkHighLevelonScreen, // (Param:N>)
    bpkEnemyPlayerOnScreen, bpkLowHealth, // (Param:N<)
    bpkLowMana, // (Param:N<)
    bpkLowHealthPotions, // (Param:N<)
    bpkLowManaPotions, // (Param:N<)
    bpkLowSoul, // (Param:N<)
    bpkLowStamina, // (Param:N<)
    bpkLowCapacity, // (Param:N<)
    bpkLevelGreater, // (Param:N>)
    bpkLowSmallHealthPotion, // (Param:N<)
    bpkLowStrongHealthPotion, // (Param:N<)
    bpkLowNormalHealthPotion, // (Param:N<)
    bpkLowGreatHealthPotion, // (Param:N<)
    bpkLowUltimateHealthPotion, // (Param:N<)
    bpkLowGreatSpiritPotion, // (Param:N<)
    bpkLowNormalManaPotion, // (Param:N<)
    bpkLowStrongManaPotion, // (Param:N<)
    bpkLowGreatManaPotion, // (Param:N<)
    bpkLast = bpkLowGreatManaPotion);

const
  BBotProtectorGreaterParam: set of TBBotProtectorKind = [bpkStucked,
    bpkDamagedBy, bpkHighLevelonScreen, bpkLevelGreater];
  BBotProtectorLowerParam: set of TBBotProtectorKind = [bpkLowHealth,
    bpkLowMana, bpkLowHealthPotions, bpkLowManaPotions, bpkLowSoul,
    bpkLowStamina, bpkLowCapacity, bpkLowSmallHealthPotion,
    bpkLowStrongHealthPotion, bpkLowNormalHealthPotion, bpkLowGreatHealthPotion,
    bpkLowUltimateHealthPotion, bpkLowGreatSpiritPotion, bpkLowNormalManaPotion,
    bpkLowStrongManaPotion, bpkLowGreatManaPotion];

type
  TBBotProtector = class
  private
    FKind: TBBotProtectorKind;
    FMacro: BBool;
    FScreenshoot: BBool;
    FGoLabel: BBool;
    FLogout: BBool;
    FShutdown: BBool;
    FSound: BBool;
    FprivateMessage: BBool;
    FCloseTibia: BBool;
    FSoundName: String;
    FPrivateMessageTo: String;
    FMacroName: String;
    FName: BStr;
    FPrivateMessageText: String;
    FLabelName: String;
    FParamN: BInt32;
    FNext: BLock;
    FEnabled: BBool;
    FPauseLevel: TBBotActionPauseLevel;
  public
    constructor Create; overload;
    constructor Create(Data: BStr); overload;
    destructor Destroy; override;

    procedure Load(Data: BStr);

    property Name: BStr read FName write FName;
    property Enabled: BBool read FEnabled write FEnabled;

    property Kind: TBBotProtectorKind read FKind write FKind;
    property PauseLevel: TBBotActionPauseLevel read FPauseLevel;

    property CloseTibia: BBool read FCloseTibia write FCloseTibia;
    property Logout: BBool read FLogout write FLogout;
    property Shutdown: BBool read FShutdown write FShutdown;
    property Screenshoot: BBool read FScreenshoot write FScreenshoot;
    property GoLabel: BBool read FGoLabel write FGoLabel;
    property Sound: BBool read FSound write FSound;
    property Macro: BBool read FMacro write FMacro;
    property PrivateMessage: BBool read FprivateMessage write FprivateMessage;

    property MacroName: String read FMacroName write FMacroName;
    property SoundName: String read FSoundName write FSoundName;
    property LabelName: String read FLabelName write FLabelName;
    property PrivateMessageTo: String read FPrivateMessageTo
      write FPrivateMessageTo;
    property PrivateMessageText: String read FPrivateMessageText
      write FPrivateMessageText;

    property ParamN: BInt32 read FParamN write FParamN;

    property Next: BLock read FNext;

    procedure Execute;
    procedure ShowHUD;
  end;

  TBBotProtectors = class(TBBotAction)
  private
    List: BVector<TBBotProtector>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnProtector(Kind: TBBotProtectorKind; ParamN: BInt32);
    procedure OnCreatureAttack(Creature: TBBotCreature);
    procedure OnCreatureTick(Creature: TBBotCreature);
    procedure OnHP(OldHP: BInt32);
    procedure OnLevel(OldLevel: BInt32);
    procedure OnMana(OldMana: BInt32);
    procedure OnStatus;
    procedure OnConnected;
    procedure OnWalk(OldPos: BPos);
    procedure OnMessage(AMessageData: TTibiaMessage);
    procedure OnSystemMessage(AMessageData: TTibiaMessage);

    procedure ClearProtectors;
    procedure AddProtector(Data: BStr);

    procedure EnableProtector(AName: BStr; AEnabled: BBool);
    procedure EnableAllProtectors(AEnabled: BBool);

    function KindToStr(Kind: TBBotProtectorKind): String;
  end;

implementation

uses
  uTibia,
  Declaracoes,
  BBotEngine,
  uSelf,
  Windows,
  uHUD,
  Graphics,
  uBBotMenu,
  Math,
  SysUtils,
  uTibiaProcess;

{ TBBotProtector }

constructor TBBotProtector.Create;
begin
  FEnabled := True;
  FKind := bpkFirst;
  FMacro := False;
  FScreenshoot := False;
  FGoLabel := False;
  FLogout := False;
  FShutdown := False;
  FSound := False;
  FprivateMessage := False;
  FCloseTibia := False;
  FSoundName := '';
  FPrivateMessageTo := '';
  FMacroName := '';
  FName := '';
  FPrivateMessageText := '';
  FLabelName := '';
  FParamN := 0;
  FNext := BLock.Create(60000, 20);
end;

constructor TBBotProtector.Create(Data: BStr);
begin
  Create;
  Load(Data);
end;

destructor TBBotProtector.Destroy;
begin
  FNext.Free;
  inherited;
end;

procedure TBBotProtector.Execute;
begin
  Next.Lock;
  ShowHUD;
  FlashWindow(TibiaProcess.hWnd, True);
  if PauseLevel <> bplNone then
    BBot.Menu.PauseLevel := PauseLevel;
  if Logout then
    Me.Logout;
  if Screenshoot then
    Tibia.ScreenShot;
  if GoLabel then
    BBot.CaveBot.GoLabel(LabelName);
  if Sound then
    BBot.StartSound(SoundName, True);
  if Macro then
    BBot.Macros.Execute(MacroName);
  if PrivateMessage then
    Me.PrivateMessage(PrivateMessageText, PrivateMessageTo);
  if CloseTibia then
    TibiaProcess.Terminate;
  if Shutdown then
    ShutdownPC;
end;

procedure TBBotProtector.Load(Data: BStr);
var
  Ret: BStrArray;
  P: BInt32;
begin
  if BStrSplit(Ret, '@', Data) = 23 then
  begin
    Name := Ret[0];
    Kind := TBBotProtectorKind(EnsureRange(StrToIntDef(Ret[1], 0),
      Ord(bpkFirst), Ord(bpkLast)));
    P := BStrTo32(Ret[2], 0);
    if BInRange(P, Ord(bplAll), Ord(bplNone)) then
      FPauseLevel := TBBotActionPauseLevel(P)
    else
      FPauseLevel := bplNone;
    // Ret[3..8] unused
    CloseTibia := Ret[9] = '1';
    Logout := Ret[10] = '1';
    Shutdown := Ret[11] = '1';
    Screenshoot := Ret[12] = '1';
    GoLabel := Ret[13] = '1';
    Sound := Ret[14] = '1';
    Macro := Ret[15] = '1';
    PrivateMessage := Ret[16] = '1';
    PrivateMessageTo := Ret[17];
    PrivateMessageText := Ret[18];
    if PrivateMessage and ((Length(PrivateMessageTo) < 3) or
      (Length(PrivateMessageText) < 3)) then
      raise Exception.Create
        ('Protector with invalid Private Message properties ' + Name);
    MacroName := Ret[19];
    SoundName := Ret[20];
    LabelName := Ret[21];
    ParamN := StrToIntDef(Ret[22], 0);
  end;
end;

procedure TBBotProtector.ShowHUD;
var
  HUD: TBBotHUD;
begin
  HUDRemoveGroup(bhgAlert);
  HUD := TBBotHUD.Create(bhgAlert);
  HUD.AlignTo(bhaCenter, bhaTop);
  HUD.Color := clRed;
  HUD.Print('[Protector] ' + BBot.Protectors.KindToStr(Kind) + ' ' + Name);
  HUD.Print(
    'You can stop the Protector Sound by pressing Shift+Pause/Break or Shift+Insert (on your keyboard) or');
  HUD.OnClick := BBotProtectorClickID;
  HUD.Print('[ click here ]');
  HUD.Free;
  HUDExecute;
end;

{ TBBotProtectors }

procedure TBBotProtectors.AddProtector(Data: BStr);
begin
  List.Add(TBBotProtector.Create(Data));
end;

procedure TBBotProtectors.ClearProtectors;
begin
  List.Clear;
end;

constructor TBBotProtectors.Create;
begin
  inherited Create('Protectors', 3000);
  List := BVector<TBBotProtector>.Create(
    procedure(It: BVector<TBBotProtector>.It)
    begin
      It^.Free;
    end);
end;

destructor TBBotProtectors.Destroy;
begin
  ClearProtectors;
  List.Free;
  inherited;
end;

procedure TBBotProtectors.EnableAllProtectors(AEnabled: BBool);
var
  I: BInt32;
begin
  for I := 0 to List.Count - 1 do
    List[I].Enabled := AEnabled;
end;

procedure TBBotProtectors.EnableProtector(AName: BStr; AEnabled: BBool);
var
  I: BInt32;
begin
  for I := 0 to List.Count - 1 do
    if AnsiSameText(List[I].Name, AName) then
      List[I].Enabled := AEnabled;
end;

function TBBotProtectors.KindToStr(Kind: TBBotProtectorKind): String;
begin
  case Kind of
    bpkMoved:
      Result := 'Moved';
    bpkMessaged:
      Result := 'Messaged';
    bpkPrivateMessage:
      Result := 'Private Message';
    bpkDisconnected:
      Result := 'Disconnected';
    bpkNoFood:
      Result := 'No Food';
    bpkGameMaster:
      Result := 'GameMaster';
    bpkFurnitureonScreen:
      Result := 'Furniture on Screen';
    bpkCreatureonScreen:
      Result := 'Creature on Screen';
    bpkPlayeronScreen:
      Result := 'Player on Screen';
    bpkPlayeronScreenwithSkull:
      Result := 'Player on Screen Skull';
    bpkAttacked:
      Result := 'Attacked';
    bpkAttackedbyPlayer:
      Result := 'Attacked by Player';
    bpkElementalDamage:
      Result := 'Elemental Damage';
    bpkStucked:
      Result := 'Stucked';
    bpkDamagedBy:
      Result := 'Damaged By';
    bpkHighLevelonScreen:
      Result := 'HighLevel on Screen';
    bpkEnemyPlayerOnScreen:
      Result := 'Enemy On Screen';
    bpkLowHealth:
      Result := 'Low Health';
    bpkLowMana:
      Result := 'Low Mana';
    bpkLowHealthPotions:
      Result := 'Low Health Potions';
    bpkLowManaPotions:
      Result := 'Low Mana Potions';
    bpkLowSoul:
      Result := 'Low Soul';
    bpkLowStamina:
      Result := 'Low Stamina Min';
    bpkLowCapacity:
      Result := 'Low Capacity';
    bpkLevelGreater:
      Result := 'Level Greater';
    bpkLowSmallHealthPotion:
      Result := 'Low Small Health Potion';
    bpkLowStrongHealthPotion:
      Result := 'Low Strong Health Potion';
    bpkLowNormalHealthPotion:
      Result := 'Low Normal Health Potion';
    bpkLowGreatHealthPotion:
      Result := 'Low Great Health Potion';
    bpkLowUltimateHealthPotion:
      Result := 'Low Ultimate Health Potion';
    bpkLowGreatSpiritPotion:
      Result := 'Low Great Spirit Potion';
    bpkLowNormalManaPotion:
      Result := 'Low Normal Mana Potion';
    bpkLowStrongManaPotion:
      Result := 'Low Strong Mana Potion';
    bpkLowGreatManaPotion:
      Result := 'Low Great Mana Potion';
  end;
end;

procedure TBBotProtectors.OnConnected;
begin
  if not Me.Connected then
    OnProtector(bpkDisconnected, 0);
end;

procedure TBBotProtectors.OnCreatureAttack(Creature: TBBotCreature);
begin
  OnProtector(bpkAttacked, 0);
  if Creature.IsPlayer then
    OnProtector(bpkAttackedbyPlayer, 0);
end;

procedure TBBotProtectors.OnCreatureTick(Creature: TBBotCreature);
begin
  if IntIn(Creature.Outfit.Outfit, TibiaGMOutfits) or
    (Pos('GM', Creature.Name) > 0) or (Pos('CM', Creature.Name) > 0) or
    (Pos('GOD', Creature.Name) > 0) then
    OnProtector(bpkGameMaster, 0);
  if Creature.IsSelf then
  begin
    OnProtector(bpkLowStamina, Me.Stamina);
    OnProtector(bpkLowCapacity, Me.Capacity div 100);
    OnProtector(bpkLowSoul, Me.Soul);
  end
  else if not Creature.IsAlly then
  begin
    OnProtector(bpkCreatureonScreen, 0);
    if Creature.IsPlayer then
    begin
      OnProtector(bpkHighLevelonScreen, Creature.Level);
      OnProtector(bpkPlayeronScreen, 0);
      if Creature.IsEnemy then
        OnProtector(bpkEnemyPlayerOnScreen, 0);
    end;
    if Creature.Skull <> SkullNone then
      if Creature.Skull <> SkullGreen then
        OnProtector(bpkPlayeronScreenwithSkull, 0);
  end;
end;

procedure TBBotProtectors.OnHP(OldHP: BInt32);
begin
  OnProtector(bpkLowHealth, Me.HP);
  if OldHP > Me.HP then
    OnProtector(bpkDamagedBy, (OldHP - Me.HP));
end;

procedure TBBotProtectors.OnInit;
begin
  inherited;
  BBot.Events.OnCreatureAttack.Add(OnCreatureAttack);
  BBot.Events.OnHP.Add(OnHP);
  BBot.Events.OnLevel.Add(OnLevel);
  BBot.Events.OnMana.Add(OnMana);
  BBot.Events.OnStatus.Add(OnStatus);
  BBot.Events.OnConnected.Add(OnConnected);
  BBot.Events.OnWalk.Add(OnWalk);
  BBot.Events.OnCreatureTick.Add(OnCreatureTick);
  BBot.Events.OnMessage.Add(OnMessage);
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);
end;

procedure TBBotProtectors.OnLevel(OldLevel: BInt32);
begin
  OnProtector(bpkLevelGreater, Me.Level - 1);
end;

procedure TBBotProtectors.OnMana(OldMana: BInt32);
begin
  OnProtector(bpkLowMana, Me.Mana);
end;

procedure TBBotProtectors.OnMessage(AMessageData: TTibiaMessage);
begin
  if (AMessageData.Mode in [MESSAGE_GAMEMASTER_BROADCAST,
    MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_PRIVATE_FROM,
    MESSAGE_GAMEMASTER_PRIVATE_TO, MESSAGE_ADMIN]) or
    (Pos('GM', AMessageData.Author) = 1) or (Pos('CM', AMessageData.Author) = 1)
    or (Pos('GOD', AMessageData.Author) = 1) then
    if not BStrStartSensitive(AMessageData.Text, 'Server is saving game in')
    then
      OnProtector(bpkGameMaster, 0);
  if (AMessageData.Level = 1) and (Me.Level > 15) and
    (AMessageData.Mode in [MESSAGE_SAY, MESSAGE_WHISPER]) then
    OnProtector(bpkGameMaster, 0);
  if (AMessageData.Mode in [MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL,
    MESSAGE_PRIVATE_FROM, MESSAGE_PRIVATE_TO]) then
    if not BBot.WarBot.IsAlly(AMessageData.Author) then
      if BBot.Spells.Spell(AMessageData.Text) = nil then
      begin
        OnProtector(bpkMessaged, 0);
        if AMessageData.Mode in [MESSAGE_PRIVATE_FROM, MESSAGE_PRIVATE_TO] then
          OnProtector(bpkPrivateMessage, 0);
      end;
end;

procedure TBBotProtectors.OnProtector(Kind: TBBotProtectorKind; ParamN: BInt32);
var
  I: BInt32;
  P: TBBotProtector;
begin
  for I := 0 to List.Count - 1 do
  begin
    P := List[I]^;
    if P.Kind = Kind then
    begin
      if not P.Enabled then
        Continue;
      if (Kind in BBotProtectorGreaterParam) and (ParamN < P.ParamN) then
        Continue;
      if (Kind in BBotProtectorLowerParam) and (ParamN > P.ParamN) then
        Continue;
      if not P.Next.Locked then
        P.Execute;
    end;
  end;
end;

procedure TBBotProtectors.OnStatus;
begin
  if (tsBurning in Me.Status) or (tsPoisoned in Me.Status) or
    (tsElectrified in Me.Status) then
    OnProtector(bpkElementalDamage, 0);
end;

procedure TBBotProtectors.OnSystemMessage(AMessageData: TTibiaMessage);
begin
  OnMessage(AMessageData);
end;

procedure TBBotProtectors.OnWalk(OldPos: BPos);
begin
  OnProtector(bpkMoved, 0);
end;

procedure TBBotProtectors.Run;
var
  SSHP, HP, SHP, GHP, UHP, GSP, MP, SMP, GMP: BInt32;
begin
  SSHP := BBot.SupliesStats.Suplies('Small Health Potion');
  HP := BBot.SupliesStats.Suplies('Health Potion');
  SHP := BBot.SupliesStats.Suplies('Strong Health Potion');
  GHP := BBot.SupliesStats.Suplies('Great Health Potion');
  UHP := BBot.SupliesStats.Suplies('Ultimate Health Potion');
  GSP := BBot.SupliesStats.Suplies('Great Spirit Potion');
  MP := BBot.SupliesStats.Suplies('Mana Potion');
  SMP := BBot.SupliesStats.Suplies('Strong Mana Potion');
  GMP := BBot.SupliesStats.Suplies('Great Mana Potion');
  if SSHP <> -1 then
  begin
    OnProtector(bpkLowSmallHealthPotion, SSHP);
    OnProtector(bpkLowHealthPotions, SSHP);
  end;
  if HP <> -1 then
  begin
    OnProtector(bpkLowNormalHealthPotion, HP);
    OnProtector(bpkLowHealthPotions, HP);
  end;
  if SHP <> -1 then
  begin
    OnProtector(bpkLowStrongHealthPotion, SHP);
    OnProtector(bpkLowHealthPotions, SHP);
  end;
  if GHP <> -1 then
  begin
    OnProtector(bpkLowGreatHealthPotion, GHP);
    OnProtector(bpkLowHealthPotions, GHP);
  end;
  if UHP <> -1 then
  begin
    OnProtector(bpkLowUltimateHealthPotion, UHP);
    OnProtector(bpkLowHealthPotions, UHP);
  end;
  if GSP <> -1 then
  begin
    OnProtector(bpkLowGreatSpiritPotion, GSP);
    OnProtector(bpkLowHealthPotions, GSP);
    OnProtector(bpkLowManaPotions, GSP);
  end;
  if MP <> -1 then
  begin
    OnProtector(bpkLowNormalManaPotion, MP);
    OnProtector(bpkLowManaPotions, MP);
  end;
  if SMP <> -1 then
  begin
    OnProtector(bpkLowStrongManaPotion, SMP);
    OnProtector(bpkLowManaPotions, SMP);
  end;
  if GMP <> -1 then
  begin
    OnProtector(bpkLowGreatManaPotion, GMP);
    OnProtector(bpkLowManaPotions, GMP);
  end;
end;

end.

