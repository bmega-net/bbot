unit uTibiaParser;

interface

uses
  uBTypes,
  uBotPacket,
  uTibiaDeclarations,
  Declaracoes,
  mmSystem,
  uItemLoader,
  uEngine;

type
  TTibiaPacketBase = class
  private
    function GetPos5(Buffer: TBBotPacket): BPos;
    function GetItem(Buffer: TBBotPacket): TBufferItem;
  public
    procedure Parse(Buffer: TBBotPacket); virtual; abstract;
    function CommandID: BInt8; virtual; abstract;
  end;

  TTibiaPacketSkip = class(TTibiaPacketBase)
  public
    procedure Parse(Buffer: TBBotPacket); override;
    function CommandID: BInt8; override;
  end;

  TTibiaPacketMissileEffect = class(TTibiaPacketBase)
  public
    procedure Parse(Buffer: TBBotPacket); override;
    function CommandID: BInt8; override;
  end;

  TTibiaPacketAddTileItem = class(TTibiaPacketBase)
  public
    procedure Parse(Buffer: TBBotPacket); override;
    function CommandID: BInt8; override;
  end;

  TTibiaPacketUpdateTileItem = class(TTibiaPacketBase)
  public
    procedure Parse(Buffer: TBBotPacket); override;
    function CommandID: BInt8; override;
  end;

  TTibiaPacketRemoveTileItem = class(TTibiaPacketBase)
  public
    procedure Parse(Buffer: TBBotPacket); override;
    function CommandID: BInt8; override;
  end;

  TTibiaPackerParser = class
  private
    EOP: BInt32;
    Buffer: TBBotPacket;
    FuncName: BStr;

    procedure ParseCreature(ID: BUInt32);
    procedure ParseSystemMessage;
    procedure ParseMessageReceived;
    procedure ParseMessage(Author: BStr; Level: BInt32);
    procedure ParseTileAdd;
    procedure ParseTileUpdate;
    procedure ParseTileRemove;
    procedure ParseCreatureMove;
    procedure ParseContainer;
    procedure ParseContainerClosed;
    procedure ParseContainerAdd;
    procedure ParseContainerUpdate;
    procedure ParseContainerRemove;
    procedure ParseInventorySet;
    procedure ParseInventoryRemove;
    procedure ParseTradeItemRequest;
    procedure ParseTradeClosed;
    procedure ParseWorldLight;
    procedure ParseMagicEffect;
    procedure ParseAnimatedText;
    procedure ParseShoot;
    procedure ParseCreatureSquare;
    procedure ParseCreatureHP;
    procedure ParseCreatureLight;
    procedure ParseCreatureOutfit;
    procedure ParseCreatureSkull;
    procedure ParseStatsUpdate;
    procedure ParseSkillsUpdate;
    procedure ParseStatusFlagsUpdate;
    procedure ParseChannelDialogReceived;
    procedure ParseChannelOpened;
    procedure ParsePrivateOpened;
    procedure ParsePrivateClosed;
    procedure ParseVip;
    procedure ParseVipLogin;
    procedure ParseVipLogout;
    procedure ParseLogin;
    procedure ParseViolations;
    procedure ParseFYIBox;
    procedure ParseQueue;
    procedure ParsePinged;
    procedure ParseDead;
    procedure ParseShop;
    procedure ParseShopMyItems;
    procedure ParseShopClosed;
    procedure ParseCreatureSpeed;
    procedure ParseCreatureParty;
    procedure ParseTextWindow;
    procedure ParseHouseWindow;
    procedure ParseCancelTarget;
    procedure ParseCancelWalk;
    procedure ParseRuleViolationsRemove;
    procedure ParseRuleViolationsCancel;
    procedure ParseRuleViolationsLock;
    procedure ParsePrivateChannelCreated;
    procedure ParseOutfitWindow;
    procedure ParseTutorial;
    procedure ParseAddMark;
    procedure ParseSpellCooldown;
    procedure ParseGroupCooldown;
    procedure ParseMapDescription;
    procedure ParseMapDescriptionNorth;
    procedure ParseMapDescriptionSouth;
    procedure ParseMapDescriptionWest;
    procedure ParseMapDescriptionEast;
    procedure ParseMapDescriptionUp;
    procedure ParseMapDescriptionDown;
    procedure ParseMapUpdateTile;
    procedure ParsePremiumShop;
    procedure ParseSnapBack;
    procedure ParseTrappers;
    procedure ParsePremiumTrigger;
    procedure ParseTransactionHistory;
    procedure ParseMarketEnter;
    procedure ParseMarketLeave;
    procedure ParsePlayerInventory;
    procedure ParsePVPSituations;
    procedure ParseWalkDelay;
    procedure ParseLoggedIn;
    procedure ParseSetTatics;
    procedure ParseUseItemDelay;
    procedure ParseMarketShopError;
    procedure ParseQuestLine;
    procedure ParseSwitchHotkeyPreset;
    procedure ParseUnjustifiedPoints;
    procedure ParseEditGuildMessage;
    procedure ParseCreditBalance;
    procedure ParseBlessings;
    procedure ParseTransactionSucceed;
    procedure ParseUpdatingShopBalance;
    procedure ParseChannelEvent;
    procedure ParseMarketShopInfo;
    function ParseFloorDescription(X, Y, Z, Width, Height, Offset: BInt32;
      var m_skipTiles: BInt32): boolean;
    procedure ParseMapInfo(X, Y, Z, Width, Height: BInt32);
    function SetTileDescription(Pos: BPos): boolean;

    procedure Client_Logout(PacketID: BInt32);
    procedure Client_Ping(PacketID: BInt32);
    procedure Client_PingBack(PacketID: BInt32);
    procedure Client_AutoMove(PacketID: BInt32);
    procedure Client_North(PacketID: BInt32);
    procedure Client_East(PacketID: BInt32);
    procedure Client_South(PacketID: BInt32);
    procedure Client_West(PacketID: BInt32);
    procedure Client_StopAutoMove(PacketID: BInt32);
    procedure Client_NorthEast(PacketID: BInt32);
    procedure Client_SouthEast(PacketID: BInt32);
    procedure Client_SouthWest(PacketID: BInt32);
    procedure Client_NorthWest(PacketID: BInt32);
    procedure Client_TurnNorth(PacketID: BInt32);
    procedure Client_TurnEast(PacketID: BInt32);
    procedure Client_TurnSouth(PacketID: BInt32);
    procedure Client_TurnWest(PacketID: BInt32);
    procedure Client_Throw(PacketID: BInt32);
    procedure Client_ShopLook(PacketID: BInt32);
    procedure Client_ShopBuy(PacketID: BInt32);
    procedure Client_ShopSold(PacketID: BInt32);
    procedure Client_ShopClose(PacketID: BInt32);
    procedure Client_TradeRequest(PacketID: BInt32);
    procedure Client_TradeLook(PacketID: BInt32);
    procedure Client_TradeAccept(PacketID: BInt32);
    procedure Client_TradeCancel(PacketID: BInt32);
    procedure Client_UseItem(PacketID: BInt32);
    procedure Client_UseItemEx(PacketID: BInt32);
    procedure Client_ShootOnBattle(PacketID: BInt32);
    procedure Client_RotateItem(PacketID: BInt32);
    procedure Client_ContainerClose(PacketID: BInt32);
    procedure Client_ContainerParent(PacketID: BInt32);
    procedure Client_WindowText(PacketID: BInt32);
    procedure Client_WindowHouseText(PacketID: BInt32);
    procedure Client_LookAt(PacketID: BInt32);
    procedure Client_Say(PacketID: BInt32);
    procedure Client_ChannelList(PacketID: BInt32);
    procedure Client_ChannelOpen(PacketID: BInt32);
    procedure Client_ChannelClose(PacketID: BInt32);
    procedure Client_ChannelPrivate(PacketID: BInt32);
    procedure Client_RuleViolation(PacketID: BInt32);
    procedure Client_RuleViolationCancel(PacketID: BInt32);
    procedure Client_NPCClose(PacketID: BInt32);
    procedure Client_AttackMode(PacketID: BInt32);
    procedure Client_Attack(PacketID: BInt32);
    procedure Client_Follow(PacketID: BInt32);
    procedure Client_PartyInvite(PacketID: BInt32);
    procedure Client_PartyJoin(PacketID: BInt32);
    procedure Client_PartyRevoke(PacketID: BInt32);
    procedure Client_PartyPassLeader(PacketID: BInt32);
    procedure Client_PartyLeave(PacketID: BInt32);
    procedure Client_PartyShared(PacketID: BInt32);
    procedure Client_ChannelPrivateCreate(PacketID: BInt32);
    procedure Client_ChannelPrivateInvite(PacketID: BInt32);
    procedure Client_ChannelPrivateExclude(PacketID: BInt32);
    procedure Client_CancelMove(PacketID: BInt32);
    procedure Client_RequestUpdateTile(PacketID: BInt32);
    procedure Client_RequestUpdateContainers(PacketID: BInt32);
    procedure Client_OutfitRequest(PacketID: BInt32);
    procedure Client_OutfitSet(PacketID: BInt32);
    procedure Client_VipAdd(PacketID: BInt32);
    procedure Client_VipRemove(PacketID: BInt32);
    procedure Client_BugReport(PacketID: BInt32);
    procedure Client_ViolationWindow(PacketID: BInt32);
    procedure Client_DebugAsset(PacketID: BInt32);
    procedure Client_Quests(PacketID: BInt32);
    procedure Client_QuestsView(PacketID: BInt32);
    procedure Client_UnknownID(PacketID: BInt32);
    procedure Client_MountDismount(PacketID: BInt32);
    procedure Client_Equip(PacketID: BInt32);
    procedure Client_PurseMarketOpen(PacketID: BInt32);
    procedure Client_PurseMarketBuy(PacketID: BInt32);
    procedure Client_RuleViolationReport(PacketID: BInt32);
    procedure Client_JoinAgression(PacketID: BInt32);
    procedure Client_TransferCoin(PacketID: BInt32);
    procedure Client_PurseMarketTransactionHistory(PacketID: BInt32);
    procedure Client_PurseMarketOpenTransactionHistory(PacketID: BInt32);
    procedure Client_PurseMarketCancel(PacketID: BInt32);
    procedure Client_PurseMarketBrowse(PacketID: BInt32);
    procedure Client_AnswerModal(PacketID: BInt32);
    procedure Client_PurseMarketAccept(PacketID: BInt32);
    procedure Client_PurseMarketLeave(PacketID: BInt32);
    procedure Client_PurseMarketOpenCategory(PacketID: BInt32);
    procedure Client_PurseMarketCreate(PacketID: BInt32);
    procedure Client_EditGuildMessage(PacketID: BInt32);
    procedure Client_VipEdit(PacketID: BInt32);
    procedure Client_BrowseField(PacketID: BInt32);
    procedure Client_EnterWorld(PacketID: BInt32);
    procedure Client_PerformanceMetrics(PacketID: BInt32);
    procedure Client_LookAtCreature(PacketID: BInt32);
    procedure Client_Login(PacketID: BInt32);
    procedure Client_SeekContainerPage(PacketID: BInt32);
    procedure Client_StoreEvent(PacketID: BInt32);
    procedure Client_WrapToggle(PacketID: BInt32);
    procedure Client_RequestResourceBalance(PacketID: BInt32);
    procedure Client_PreyAction(PacketID: BInt32);
    procedure Client_Embuiment(PacketID: BInt32);
    procedure Client_ClearEmbuiment(PacketID: BInt32);

  public
    constructor Create;
    destructor Destroy; override;

    procedure VerifyPosition(Pos: BPos);
    procedure VerifyItem(ID, Count: BInt32);
    procedure VerifyCreature(Creature: BUInt32);
    procedure VerifyContainer(Container, Slot: BInt32);

    procedure ReportUnexpectedBehavior(Log: BStr; PacketID: BInt32);

    function GetOutfit: TTibiaOutfit;
    function GetPos: BPos;
    function GetItem: TBufferItem;
    procedure ReadObjectInstance; overload;
    procedure ReadObjectInstance(const AItemID: BInt32); overload;

    procedure SetBuffer(ABuffer: Pointer; ASize: BInt32);

    function ParseClient: boolean;
    procedure ParseServer;

    function BufferToStr: BStr;
  end;

  TParserFunction = record
    ID: BInt32;
    Parser: BInt32;
    Name: BStr;
  end;

implementation

uses
  uTibia,
  BBotEngine,
  uBBotProtector,

  Math,
  SysUtils,
  StrUtils,
  uItem,

  uBBotAddresses,
  uTibiaState;

{ TTibiaPackerParser }

{$HINTS OFF}

procedure TTibiaPackerParser.ParseCreature(ID: BUInt32);
var
  Outfit: TTibiaOutfit;
  CID: BUInt32;
  PartyShield: byte;
  Skull: byte;
  Speed: BInt32;
  LightColor: byte;
  LightSize: byte;
  Dir: byte;
  HP: byte;
begin
  if ID = $62 then
    CID := BUInt32(Buffer.GetBInt32) // ID
  else
  begin // ID = $61
    Buffer.GetBInt32; // Remove
    CID := BUInt32(Buffer.GetBInt32); // ID
    Buffer.GetBStr16; // Name
  end;
  HP := BInt8(Buffer.GetBInt8);
  Dir := BInt8(Buffer.GetBInt8);
  Outfit := GetOutfit;
  LightSize := BInt8(Buffer.GetBInt8);
  LightColor := BInt8(Buffer.GetBInt8);
  Speed := Buffer.GetBInt16;
  Skull := BInt8(Buffer.GetBInt8);
  PartyShield := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseSystemMessage;
begin
  ParseMessage('', -1);
end;

procedure TTibiaPackerParser.ParseTileAdd;
var
  Parent: byte;
  Tile: BPos;
  Item: TBufferItem;
begin
  Tile := GetPos;
  Parent := BInt8(Buffer.GetBInt8);
  Item := GetItem;
  if IntIn(Item.ID, ItemsFurnitures) then
    BBot.Protectors.OnProtector(bpkFurnitureonScreen, 0);
  if BIntIn(Item.ID, MagicWallField) then
    BBot.AddMwall(Tile, 20)
  else if BIntIn(Item.ID, WildGrowthField) then
    BBot.AddMwall(Tile, 45);
  case Item.ID of
    $62, $61:
      ParseCreature(Item.ID);
  end;
end;

procedure TTibiaPackerParser.ParseTileUpdate;
var
  Dir: byte;
  CreatureID: BUInt32;
  Item: TBufferItem;
  Stackpos: byte;
  Tile: BPos;
begin
  Tile := GetPos;
  Stackpos := BInt8(Buffer.GetBInt8);
  Item := GetItem;
  if BIntIn(Item.ID, MagicWallField) then
    BBot.AddMwall(Tile, 20)
  else if BIntIn(Item.ID, WildGrowthField) then
    BBot.AddMwall(Tile, 45);
  case Item.ID of
    $62, $61:
      ParseCreature(Item.ID);
    $63:
      begin
        CreatureID := BUInt32(Buffer.GetBInt32);
        Dir := BInt8(Buffer.GetBInt8);
      end;
  end;
end;

procedure TTibiaPackerParser.ParseTileRemove;
var
  Stackpos: byte;
  Tile: BPos;
begin
  Tile := GetPos;
  Stackpos := BInt8(Buffer.GetBInt8);
  BBot.RemoveMwall(Tile);
end;

procedure TTibiaPackerParser.ParseCreatureMove;
var
  ToPos: BPos;
  Stackpos: byte;
  FromPos: BPos;
begin
  FromPos := GetPos;
  Stackpos := BInt8(Buffer.GetBInt8);
  ToPos := GetPos;
end;

procedure TTibiaPackerParser.ParseContainer;
var
  I: BInt32;
  Items: byte;
  HasParent: byte;
  Capacity: byte;
  Name: BStr;
  Icon: BInt32;
  ContainerID: byte;
begin
  ContainerID := BInt8(Buffer.GetBInt8);
  Icon := Buffer.GetBUInt16;
  Name := Buffer.GetBStr16;
  Capacity := BInt8(Buffer.GetBInt8);
  HasParent := BInt8(Buffer.GetBInt8);
  Items := BInt8(Buffer.GetBInt8);
  for I := 1 to Items do
    GetItem;
end;

procedure TTibiaPackerParser.ParseContainerClosed;
var
  ContainerID: byte;
begin
  ContainerID := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseContainerAdd;
var
  Item: TBufferItem;
  ContainerID: byte;
  Slot: BInt32;
begin
  ContainerID := BInt8(Buffer.GetBInt8);
  if AdrSelected >= TibiaVer900 then
    Slot := Buffer.GetBInt16;
  Item := GetItem;
end;

procedure TTibiaPackerParser.ParseContainerUpdate;
var
  Item: TBufferItem;
  Slot: byte;
  ContainerID: byte;
begin
  ContainerID := BInt8(Buffer.GetBInt8);
  if AdrSelected >= TibiaVer900 then
    Slot := Buffer.GetBInt16
  else
    Slot := Buffer.GetBInt8;
  Item := GetItem;
end;

procedure TTibiaPackerParser.ParseContainerRemove;
var
  Slot, ContainerID: BInt32;
begin
  if AdrSelected < TibiaVer900 then
  begin
    ContainerID := Buffer.GetBInt8;
    Slot := Buffer.GetBInt8;
  end
  else
  begin
    ContainerID := Buffer.GetBInt8;
    Slot := Buffer.GetBInt16;
  end;
end;

procedure TTibiaPackerParser.ParseInventorySet;
var
  Item: TBufferItem;
  Slot: byte;
begin
  Slot := BInt8(Buffer.GetBInt8);
  Item := GetItem;
end;

procedure TTibiaPackerParser.ParseInventoryRemove;
var
  Slot: byte;
begin
  Slot := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseTradeItemRequest;
var
  I: BInt32;
  Items: byte;
  PlayerName: BStr;
begin
  PlayerName := Buffer.GetBStr16;
  Items := BInt8(Buffer.GetBInt8);
  for I := 1 to Items do
    GetItem;
end;

procedure TTibiaPackerParser.ParseTransactionHistory;
var
  CurrentPage: BInt32;
  HasNextPage: BBool;
  Count: BInt32;
  Timestamp: BInt32;
  CreditValue: BInt32;
  TransactionType: BInt8;
  Name: BStr;
begin
  CurrentPage := Buffer.GetBInt16;
  HasNextPage := Buffer.GetBInt8 = 1;
  Count := Buffer.GetBInt8;
  while Count > 0 do
  begin
    Timestamp := Buffer.GetBInt32;
    TransactionType := Buffer.GetBInt8;
    CreditValue := Buffer.GetBInt32;
    Name := Buffer.GetBStr16;
    Dec(Count);
  end;
end;

procedure TTibiaPackerParser.ParseTransactionSucceed;
begin
  Buffer.GetBInt8; // ID
  Buffer.GetBStr16; // Name
  Buffer.GetBInt32; // Credit
  Buffer.GetBInt32; // Credit
end;

procedure TTibiaPackerParser.ParseTrappers;
var
  Count: BInt8;
  CreatureID: BInt32;
begin
  Count := Buffer.GetBInt8;
  while Count > 0 do
  begin
    CreatureID := Buffer.GetBInt8;
    Dec(Count);
  end;
end;

procedure TTibiaPackerParser.ParseTradeClosed;
begin

end;

procedure TTibiaPackerParser.ParseWalkDelay;
begin
  Buffer.GetBInt16; // Delay
end;

procedure TTibiaPackerParser.ParseWorldLight;
var
  Color: byte;
  Size: byte;
begin
  Size := BInt8(Buffer.GetBInt8);
  Color := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseMagicEffect;
var
  Effect: byte;
  Tile: BPos;
begin
  Tile := GetPos;
  Effect := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseAnimatedText;
var
  Text: BStr;
  Color: byte;
  Tile: BPos;
begin
  Tile := GetPos;
  Color := BInt8(Buffer.GetBInt8);
  Text := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseBlessings;
begin
  Buffer.GetBInt8; // Blesses
end;

procedure TTibiaPackerParser.ParseShoot;
var
  MissileEffectData: TTibiaMissileEffect;
  Effect: byte;
  ToPos: BPos;
  FromPos: BPos;
begin
  MissileEffectData.FromPosition := GetPos;
  MissileEffectData.ToPosition := GetPos;
  MissileEffectData.Effect := Buffer.GetBInt8;
  BBot.Events.RunMissileEffect(MissileEffectData);
end;

procedure TTibiaPackerParser.ParseCreatureSquare;
var
  Color: byte;
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  Color := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseCreditBalance;
begin
  Buffer.GetBInt32; // Balance
  Buffer.GetBInt32; // Balance
end;

procedure TTibiaPackerParser.ParseEditGuildMessage;
begin
  Buffer.GetBStr16; // Current MOTD
end;

procedure TTibiaPackerParser.ParseCreatureHP;
var
  HP: byte;
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  HP := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseCreatureLight;
var
  Size: byte;
  Color: byte;
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  Size := BInt8(Buffer.GetBInt8);
  Color := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseCreatureOutfit;
var
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  GetOutfit;
end;

procedure TTibiaPackerParser.ParseCreatureSkull;
var
  Skull: byte;
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  Skull := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseStatsUpdate;
var
  StaminaInMinutes: BInt32;
  OfflineTrainingInMinutes: BInt32;
  Soul: byte;
  MagicLevelPercent: byte;
  MagicLevel, MagicLevelBase: byte;
  ManaMax: BInt32;
  Mana: BInt32;
  LevelPercent: byte;
  Level: BInt32;
  Experience: Int64;
  Capacity, CapacityMax: BInt32;
  HPMax: BInt32;
  HP: BInt32;
  Feed: BInt32;
  Strength: BInt32;
  ExpBonus: BFloat;
  BaseXPGain: BInt32;
  VoucherAdded: BInt32;
  GrindingAdded: BInt32;
  StoreBoostAdded: BInt32;
  HuntingBoostFactor: BInt32;
  RemainingXpBoostSecs: BInt32;
  CanBuyXpBoost: BBool;
begin
  HP := Buffer.GetBInt16;
  HPMax := Buffer.GetBInt16;

  if AdrSelected >= TibiaVer900 then
    CapacityMax := Buffer.GetBInt32;
  Capacity := Buffer.GetBInt32;

  if AdrSelected >= TibiaVer870 then
    Experience := Buffer.GetBInt32
  else
    Experience := Buffer.GetBInt64;

  Level := Buffer.GetBInt16;
  LevelPercent := BInt8(Buffer.GetBInt8);

  if AdrSelected >= TibiaVerN1000 then
  begin
    BaseXPGain := Buffer.GetBInt16;
    VoucherAdded := Buffer.GetBInt16;
    GrindingAdded := Buffer.GetBInt16;
    StoreBoostAdded := Buffer.GetBInt16;
    HuntingBoostFactor := Buffer.GetBInt16;
  end
  else if AdrSelected >= TibiaVer900 then
    ExpBonus := Buffer.GetBFloat;

  Mana := Buffer.GetBInt16;
  ManaMax := Buffer.GetBInt16;

  MagicLevel := Buffer.GetBInt8;
  if AdrSelected >= TibiaVer900 then
    MagicLevelBase := Buffer.GetBInt8;
  MagicLevelPercent := Buffer.GetBInt8;

  Soul := BInt8(Buffer.GetBInt8);
  StaminaInMinutes := Buffer.GetBInt16;
  if AdrSelected >= TibiaVer900 then
  begin
    Strength := Buffer.GetBInt16;
    Feed := Buffer.GetBInt16;
  end;

  if AdrSelected >= TibiaVer900 then
    OfflineTrainingInMinutes := Buffer.GetBInt16;

  if AdrSelected >= TibiaVerN1000 then
  begin
    RemainingXpBoostSecs := Buffer.GetBInt16;
    CanBuyXpBoost := Buffer.GetBInt8 = 1;
  end;
end;

procedure TTibiaPackerParser.ParseSkillsUpdate;
var
  Skill: TTibiaSkill;
  Level, Percent, BaseSkill: BInt32;
  SpecialSkill: TTibiaSpecialSkill;
begin
  for Skill := SkillFist to SkillFishing do
  begin
    Level := Buffer.GetBInt16;
    if AdrSelected >= TibiaVer900 then
      BaseSkill := Buffer.GetBInt16;
    Percent := Buffer.GetBInt8;
  end;
  if AdrSelected > TibiaVer1094 then
    for SpecialSkill := SpecialSkillFirst to SpecialSkillLast do
    begin
      Me.SetSpecialSkill(SpecialSkill, Buffer.GetBInt16);
      Buffer.GetBInt16; // 0?
    end;
  // Special Skills:
  // critical hit chance; critical hit amount;
  // hit points leech chance; hit points leech amount;
  /// mana points leech chance, mana points leech amount;
  // for each:
  // - percentage
  // - 0
end;

procedure TTibiaPackerParser.ParseSnapBack;
var
  Dir: BInt8;
begin
  Dir := Buffer.GetBInt8;
end;

procedure TTibiaPackerParser.ParseStatusFlagsUpdate;
var
  Flags: BInt32;
begin
  Flags := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.ParseSwitchHotkeyPreset;
const
  PROFESSION_KNIGHT = 1;
  PROFESSION_PALADIN = 2;
  PROFESSION_SORCERER = 3;
  PROFESSION_DRUID = 4;
begin
  case Buffer.GetBInt32 of
    PROFESSION_KNIGHT:
      ;
    PROFESSION_PALADIN:
      ;
    PROFESSION_SORCERER:
      ;
    PROFESSION_DRUID:
      ;
  end;
end;

procedure TTibiaPackerParser.ParseMessageReceived;
var
  Author: BStr;
  Level: BInt32;
begin
  Buffer.GetBInt32; // 4 Blank Bytes
  Author := Buffer.GetBStr16;
  Level := Buffer.GetBInt16;
  ParseMessage(Author, Level);
end;

procedure TTibiaPackerParser.ParseChannelDialogReceived;
var
  I: BInt32;
  Channels: byte;
  ID: BInt32;
  Name: BStr;
begin
  Channels := BInt8(Buffer.GetBInt8);
  if Engine.Debug.Channels then
    Tibia.AddDebug(BFormat('Received %d channels', [Channels]));
  for I := 1 to Channels do
  begin
    ID := Buffer.GetBInt16; // Channel ID
    Name := Buffer.GetBStr16; // Channel Name
    if Engine.Debug.Channels then
      Tibia.AddDebug(BFormat('Channel [%d] %s', [ID, Name]));
  end;
end;

procedure TTibiaPackerParser.ParseChannelEvent;
var
  ChannelID, Event: BInt32;
  Name: BStr;
begin
  ChannelID := Buffer.GetBInt16; // Channel ID
  Name := Buffer.GetBStr16; // Name
  Event := Buffer.GetBInt8; // Event
  case Event of
    0:
      ; // Player Joined
    1:
      ; // Player Left
    2:
      ; // Player Invited
    3:
      ; // Player Excluded
    4:
      ; // Player Pending
  end;
end;

procedure TTibiaPackerParser.ParseChannelOpened;
var
  ChannelName: BStr;
  ChannelID: BInt32;
  ChannelPlayers: BInt32;
  ChannelInvitedPlayers: BInt32;
  I: BInt32;
begin
  ChannelID := Buffer.GetBInt16;
  ChannelName := Buffer.GetBStr16;
  ChannelPlayers := Buffer.GetBInt16;
  for I := 1 to ChannelPlayers do
    Buffer.GetBStr16;
  ChannelInvitedPlayers := Buffer.GetBInt16;
  for I := 1 to ChannelInvitedPlayers do
    Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParsePrivateOpened;
var
  Receiver: BStr;
begin
  Receiver := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParsePVPSituations;
begin
  Buffer.GetBInt8; // Amount of Open PVP Situations
end;

procedure TTibiaPackerParser.ParsePrivateClosed;
var
  ChannelID: BInt32;
begin
  ChannelID := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.ParseVip;
var
  Name, Description: BStr;
  GUID, Icon: BInt32;
  Online, Notify: BBool;
begin
  GUID := Buffer.GetBInt32;
  Name := Buffer.GetBStr16;
  if AdrSelected >= TibiaVer900 then
  begin
    Description := Buffer.GetBStr16;
    Icon := Buffer.GetBInt32;
    Notify := Buffer.GetBInt8 = 1;
  end;
  Online := Buffer.GetBInt8 = 1;
end;

procedure TTibiaPackerParser.ParseVipLogin;
var
  GUID: BInt32;
begin
  GUID := Buffer.GetBInt32;
end;

procedure TTibiaPackerParser.ParseVipLogout;
var
  GUID: BInt32;
begin
  GUID := Buffer.GetBInt32;
end;

procedure TTibiaPackerParser.ParseLoggedIn;
var
  PlayerID: BInt32;
  BeatDuration: BInt32;
  CreatureSpeedA, CreatureSpeedB, CreatureSpeedC: BFloat;
  CanReportBugs: BBool;
  CanChangePVP: BBool;
  CanExpertPVP: BBool;
  IP: BStr;
  Port: BInt32;
begin
  PlayerID := Buffer.GetBInt32;
  BeatDuration := Buffer.GetBInt16;
  CreatureSpeedA := Buffer.GetBFloat;
  CreatureSpeedB := Buffer.GetBFloat;
  CreatureSpeedC := Buffer.GetBFloat;
  CanReportBugs := Buffer.GetBInt8 = 1;
  CanChangePVP := Buffer.GetBInt8 = 1;
  CanExpertPVP := Buffer.GetBInt8 = 1;
  IP := Buffer.GetBStr16;
  Port := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.ParseLogin;
var
  CanReportBugs: byte;
  PlayerID: BInt32;
begin
  PlayerID := Buffer.GetBInt32;
  Buffer.GetBInt8; // Always $32 ???
  Buffer.GetBInt8; // Always $00 ???
  CanReportBugs := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseViolations;
var
  I: BInt32;
begin
  for I := 1 to 32 do
    Buffer.GetBInt8;
end;

procedure TTibiaPackerParser.ParseFYIBox;
var
  Text: BStr;
begin
  Text := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseQuestLine;
var
  QuestID: BInt32;
  Count: BInt32;
begin
  QuestID := Buffer.GetBInt16; // Quest ID
  Count := Buffer.GetBInt8;
  while Count > 0 do
  begin
    Buffer.GetBStr16; // Mission Name
    Buffer.GetBStr16; // Mission Description
    Dec(Count);
  end;
end;

procedure TTibiaPackerParser.ParseQueue;
var
  Time: byte;
  Text: BStr;
begin
  Text := Buffer.GetBStr16;
  Time := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParsePinged;
begin

end;

procedure TTibiaPackerParser.ParsePlayerInventory;
var
  Count: BInt8;
  ID, Data, Amount: BInt32;
begin
  Count := Buffer.GetBInt16;
  while Count > 0 do
  begin
    ID := Buffer.GetBUInt16;
    Data := Buffer.GetBInt8;
    Amount := Buffer.GetBInt16;
    Dec(Count);
  end;
end;

procedure TTibiaPackerParser.ParseDead;
var
  Reason: BInt32;
  DamageGiven: BInt32;
begin
  if AdrSelected >= TibiaVer900 then
  begin
    Reason := Buffer.GetBInt8;
    case Reason of
      0:
        begin
          DamageGiven := Buffer.GetBInt8;
          // DEATH_UNFAIR = DamageGiven < 100
          // DEAD_REGULAR = DamageGiven > 100
        end;
      1:
        ; // DEATH_BLESSED
      2:
        ; // DEATH_NOPENALTY
    end;
  end;
end;

procedure TTibiaPackerParser.ParseShop;
var
  Items: BInt32;
  NPCName: BStr;
  ID: BUInt32;
  ItemAmount: BUInt32;
  Name: BStr;
  Weight: BInt32;
  BuyPrice: BInt32;
  SellPrice: BInt32;
begin
  BBot.TradeWindow.IsOpen := True;
  if AdrSelected >= TibiaVer872 then
    BBot.TradeWindow.Name := Buffer.GetBStr16;
  if AdrSelected >= TibiaVer940 then
    Items := Buffer.GetBInt16
  else
    Items := BInt8(Buffer.GetBInt8);
  while Items > 0 do
  begin
    ID := Buffer.GetBUInt16;
    ItemAmount := BInt8(Buffer.GetBInt8);
    Name := Buffer.GetBStr16;
    Weight := Buffer.GetBInt32;
    BuyPrice := Buffer.GetBInt32;
    SellPrice := Buffer.GetBInt32;
    BBot.TradeWindow.AddItem(Name, ID, ItemAmount, Weight, SellPrice, BuyPrice);
    Dec(Items);
  end;
end;

procedure TTibiaPackerParser.ParseShopMyItems;
var
  Items: BInt32;
  ID, Count, ItemAmount: BInt32;
begin
  if AdrSelected < TibiaVer900 then
    BBot.TradeWindow.Money := Buffer.GetBInt32
  else
  begin
    BBot.TradeWindow.Money := Buffer.GetBInt64;
  end;
  Items := BInt8(Buffer.GetBInt8);
  if (AdrSelected >= TibiaVer872) and (AdrSelected < TibiaVer900) then
    Inc(Items, 10);
  while Items > 0 do
  begin
    ID := Buffer.GetBUInt16;
    if (AdrSelected >= TibiaVer872) and (AdrSelected < TibiaVer900) then
    begin
      ItemAmount := BInt8(Buffer.GetBInt8);
      Count := Buffer.GetBInt16;
    end
    else
    begin
      ItemAmount := 0;
      Count := BInt8(Buffer.GetBInt8);
    end;
    BBot.TradeWindow.AddHaveCount(ID, ItemAmount, Count);
    Dec(Items);
  end;
end;

procedure TTibiaPackerParser.ParseShopClosed;
begin
  BBot.TradeWindow.IsOpen := False;
end;

procedure TTibiaPackerParser.ParseCreatureSpeed;
var
  Speed, BaseSpeed: BInt32;
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  if AdrSelected >= TibiaVer900 then
    BaseSpeed := Buffer.GetBInt16;
  Speed := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.ParseCreatureParty;
var
  Party: byte;
  CreatureID: BUInt32;
begin
  CreatureID := BUInt32(Buffer.GetBInt32);
  Party := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseTextWindow;
var
  Date: BStr;
  Author: BStr;
  Text: BStr;
  Size: BInt32;
  Icon: BInt32;
  WindowID: BInt32;
begin
  WindowID := Buffer.GetBInt32;
  if AdrSelected >= TibiaVer900 then
    Icon := GetItem.ID
  else
    Icon := Buffer.GetBUInt16;
  Size := Buffer.GetBInt16;
  Text := Buffer.GetBStr16;
  Author := Buffer.GetBStr16;
  Date := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseHouseWindow;
var
  Nature: BInt8;
  Text: BStr;
  WindowID: BInt32;
begin
  Nature := Buffer.GetBInt8; // 00 always
  WindowID := Buffer.GetBInt32;
  Text := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseCancelTarget;
var
  TargetCreatureID: BInt32;
begin
  TargetCreatureID := Buffer.GetBInt32;
end;

procedure TTibiaPackerParser.ParseCancelWalk;
var
  Direction: byte;
begin
  Direction := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.ParseRuleViolationsRemove;
var
  Name: BStr;
begin
  Name := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseRuleViolationsCancel;
var
  Name: BStr;
begin
  Name := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseRuleViolationsLock;
begin

end;

procedure TTibiaPackerParser.ParsePremiumShop;
var
  CreditInfo: BBool;
  Credit1, Credit2: BInt32;
  Items: BInt32;
  I, J: BInt32;
  Category, ParentCategory, Description, Icons: BStr;
begin
  CreditInfo := Buffer.GetBInt8 = 1;
  if CreditInfo then
  begin
    Credit1 := Buffer.GetBInt32;
    Credit2 := Buffer.GetBInt32;
    // Tibia.AddDebug(BFormat('Shop credit: %d/%d', [Credit1, Credit2]));
  end;
  Items := Buffer.GetBInt16;
  while Items > 0 do
  begin
    Category := Buffer.GetBStr16;
    Description := Buffer.GetBStr16;
    Icons := '';
    J := Buffer.GetBInt8;
    while J > 0 do
    begin
      Icons := Icons + Buffer.GetBStr16 + ';';
      Dec(J);
    end;
    ParentCategory := Buffer.GetBStr16;
    // Tibia.AddDebug('Shop category: ' + BIf(ParentCategory <> '', ParentCategory + '::', '') + Category + ' -> ' + Description);
    Dec(Items);
  end;
end;

procedure TTibiaPackerParser.ParsePremiumTrigger;
var
  Notify: BBool;
  MessageId: BInt32;
  MessageCount: BInt32;
begin
  MessageCount := Buffer.GetBInt8;
  while MessageCount > 0 do
  begin
    Buffer.GetBInt8; // MessageID
    Dec(MessageCount);
  end;
  Notify := Buffer.GetBInt8 = 1;
end;

procedure TTibiaPackerParser.ParsePrivateChannelCreated;
var
  Name: BStr;
  ChannelID: BInt32;
  Members: BInt32;
begin
  ChannelID := Buffer.GetBInt16;
  Name := Buffer.GetBStr16;
  Members := Buffer.GetBInt16;
  while Members > 0 do
  begin
    Buffer.GetBStr16; // Member name
    Dec(Members);
  end;
  Members := Buffer.GetBInt16;
  while Members > 0 do
  begin
    Buffer.GetBStr16; // Invited name
    Dec(Members);
  end;
end;

procedure TTibiaPackerParser.ParseOutfitWindow;
var
  I: BInt32;
  Count: byte;
begin
  GetOutfit;
  Count := BInt8(Buffer.GetBInt8);
  for I := 1 to Count do
  begin
    Buffer.GetBInt16; // Looktype
    Buffer.GetBStr16; // Name
    Buffer.GetBInt8; // Addons
  end;
  if AdrSelected >= TibiaVer870 then
  begin
    Count := BInt8(Buffer.GetBInt8);
    for I := 1 to Count do
    begin
      Buffer.GetBInt16; // Mount ID
      Buffer.GetBStr16; // Mount Name
    end;
  end;
end;

procedure TTibiaPackerParser.ParseTutorial;
begin
  Buffer.GetBInt8;
end;

procedure TTibiaPackerParser.ParseUnjustifiedPoints;
var
  ProgressDay, KillsRemainingDay: BInt8;
  ProgressWeek, KillsRemainingWeek: BInt8;
  ProgressMonth, KillsRemainingMonth: BInt8;
  SkullDuration: BInt8;
begin
  ProgressDay := Buffer.GetBInt8;
  KillsRemainingDay := Buffer.GetBInt8;
  ProgressWeek := Buffer.GetBInt8;
  KillsRemainingWeek := Buffer.GetBInt8;
  ProgressMonth := Buffer.GetBInt8;
  KillsRemainingMonth := Buffer.GetBInt8;
  SkullDuration := Buffer.GetBInt8;
end;

procedure TTibiaPackerParser.ParseUpdatingShopBalance;
begin
  Buffer.GetBInt8; // IsUpdating == 1
end;

procedure TTibiaPackerParser.ParseUseItemDelay;
begin
  Buffer.GetBInt32; // Cooldown (MS)
end;

procedure TTibiaPackerParser.ParseAddMark;
var
  Description: BStr;
  MarkType: byte;
  Position: BPos;
begin
  Position := GetPos;
  MarkType := BInt8(Buffer.GetBInt8);
  Description := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.ParseMapDescription;
var
  Pos: BPos;
begin
  if Tibia.MapOldPos.Z = 8 then
    Exit;
  Pos := GetPos;
  Pos := Tibia.MapNewPos;
  ParseMapInfo(Pos.X - 8, Pos.Y - 6, Pos.Z, 18, 14);
end;

procedure TTibiaPackerParser.ParseMapDescriptionNorth;
begin
  ParseMapInfo(Tibia.MapOldPos.X - 8, Tibia.MapNewPos.Y - 6,
    Tibia.MapNewPos.Z, 18, 1);
end;

procedure TTibiaPackerParser.ParseMapDescriptionSouth;
begin
  ParseMapInfo(Tibia.MapOldPos.X - 8, Tibia.MapNewPos.Y + 7,
    Tibia.MapNewPos.Z, 18, 1);
end;

procedure TTibiaPackerParser.ParseMapDescriptionWest;
begin
  ParseMapInfo(Tibia.MapNewPos.X - 8, Tibia.MapNewPos.Y - 6,
    Tibia.MapNewPos.Z, 1, 14);
end;

procedure TTibiaPackerParser.ParseMapDescriptionEast;
begin
  ParseMapInfo(Tibia.MapNewPos.X + 9, Tibia.MapNewPos.Y - 6,
    Tibia.MapNewPos.Z, 1, 14);
end;

procedure TTibiaPackerParser.ParseMapDescriptionUp;
var
  Skip: BInt32;
begin
  if Tibia.MapNewPos.Z = 7 then
  begin
    Skip := -1;
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.X - 6, 5, 18,
      14, 3, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.X - 6, 4, 18,
      14, 4, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.X - 6, 3, 18,
      14, 5, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.X - 6, 2, 18,
      14, 6, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.X - 6, 1, 18,
      14, 7, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.X - 6, 0, 18,
      14, 8, Skip);
    if Skip >= 0 then
    begin
      Buffer.GetBInt8;
      Buffer.GetBInt8;
    end;
  end
  else if Tibia.MapNewPos.Z > 7 then
  begin
    Skip := -1;
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.Y - 6,
      Tibia.MapOldPos.Z - 3, 18, 14, 3, Skip);
    if Skip >= 0 then
    begin
      Buffer.GetBInt8;
      Buffer.GetBInt8;
    end;
  end;
end;

procedure TTibiaPackerParser.ParseMapDescriptionDown;
var
  Skip: BInt32;
begin
  if Tibia.MapNewPos.Z = 8 then
  begin
    Skip := -1;
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.Y - 6,
      Tibia.MapNewPos.Z, 18, 14, -1, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.Y - 6,
      Tibia.MapNewPos.Z + 1, 18, 14, -2, Skip);
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.Y - 6,
      Tibia.MapNewPos.Z + 2, 18, 14, -3, Skip);
    if Skip >= 0 then
    begin
      Buffer.GetBInt8;
      Buffer.GetBInt8;
    end;
  end
  else if (Tibia.MapNewPos.Z > Tibia.MapOldPos.Z) and (Tibia.MapNewPos.Z > 8)
    and (Tibia.MapNewPos.Z < 14) then
  begin
    Skip := -1;
    ParseFloorDescription(Tibia.MapOldPos.X - 8, Tibia.MapOldPos.Y - 6,
      Tibia.MapNewPos.Z + 2, 18, 14, -3, Skip);
    if Skip >= 0 then
    begin
      Buffer.GetBInt8;
      Buffer.GetBInt8;
    end;
  end;
end;

procedure TTibiaPackerParser.ParseMapUpdateTile;
var
  Position: BPos;
begin
  Position := GetPos;
end;

procedure TTibiaPackerParser.ParseMarketEnter;
var
  ActiveOffers, Count: BInt32;
  BankBalance: Int64;
  ItemID, ItemCount: BInt32;
begin
  BankBalance := Buffer.GetBInt64;
  ActiveOffers := Buffer.GetBInt8;
  Count := Buffer.GetBInt16;
  while Count > 0 do
  begin
    ItemID := Buffer.GetBUInt16;
    ItemCount := Buffer.GetBInt16;
    Dec(Count);
  end;
end;

procedure TTibiaPackerParser.ParseMarketLeave;
begin

end;

procedure TTibiaPackerParser.ParseMarketShopError;
begin
  Buffer.GetBInt8; // Error ID
  Buffer.GetBStr16; // Error Description
end;

procedure TTibiaPackerParser.ParseMarketShopInfo;
begin
  Buffer.GetBInt32; // Player ID
  Buffer.GetBInt8; // Service ID
end;

procedure TTibiaPackerParser.Client_Login(PacketID: BInt32);
begin
  Buffer.GetBInt16; // OS
  Buffer.GetBInt16; // Version
  while not Buffer.EOP do
    Buffer.GetBInt8
end;

procedure TTibiaPackerParser.Client_Logout(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_Ping(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_PingBack(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_PreyAction(PacketID: BInt32);
var
  PreyID: BInt8;
  Action: BInt8;
  Monster: BInt8;
begin
  PreyID := Buffer.GetBInt8;
  Action := Buffer.GetBInt8;
  if Action = 2 then
    Monster := Buffer.GetBInt8;
end;

procedure TTibiaPackerParser.Client_AutoMove(PacketID: BInt32);
var
  StepsCount: BInt32;
  Step: BInt32;
  I: BInt32;
begin
  StepsCount := BInt8(Buffer.GetBInt8);
  for I := 1 to StepsCount do
  begin
    Step := BInt8(Buffer.GetBInt8);
    if not InRange(Step, 1, 8) then
      ReportUnexpectedBehavior('AutoMove ?? Step: ' + IntToStr(Step), PacketID);
  end;
end;

procedure TTibiaPackerParser.Client_North(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_East(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_EditGuildMessage(PacketID: BInt32);
begin
  Buffer.GetBStr16; // New message
end;

procedure TTibiaPackerParser.Client_Embuiment(PacketID: BInt32);
begin
  Buffer.GetBInt8; // Slot
  Buffer.GetBInt32; // Item
  Buffer.GetBInt8; // Use Charm bool
end;

procedure TTibiaPackerParser.Client_EnterWorld(PacketID: BInt32);
begin
  Buffer.GetBInt16; // Objects min
  Buffer.GetBInt16; // Objects max
  Buffer.GetBInt16; // Objects avg
  Buffer.GetBInt16; // FPS min
  Buffer.GetBInt16; // FPS max
  Buffer.GetBInt16; // FPS avg
end;

procedure TTibiaPackerParser.Client_Equip(PacketID: BInt32);
var
  ID, Count: BInt32;
begin
  ID := Buffer.GetBUInt16;
  Count := Buffer.GetBInt8;
  VerifyItem(ID, 0);
end;

procedure TTibiaPackerParser.Client_South(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_West(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_StopAutoMove(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_StoreEvent(PacketID: BInt32);
begin
  Buffer.GetBInt8; // Event Type
  Buffer.GetBInt32; // Offer ID
end;

procedure TTibiaPackerParser.Client_NorthEast(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_SouthEast(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_SouthWest(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_NorthWest(PacketID: BInt32);
begin
  Tibia.PingStart;
end;

procedure TTibiaPackerParser.Client_TurnNorth(PacketID: BInt32);
begin
end;

procedure TTibiaPackerParser.Client_TurnEast(PacketID: BInt32);
begin
end;

procedure TTibiaPackerParser.Client_TurnSouth(PacketID: BInt32);
begin
end;

procedure TTibiaPackerParser.Client_TurnWest(PacketID: BInt32);
begin
end;

procedure TTibiaPackerParser.Client_Throw(PacketID: BInt32);
var
  pFrom, pTo: BPos;
  iID, iCount, iStack: BInt32;
begin
  pFrom := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  pTo := GetPos;
  iCount := BInt8(Buffer.GetBInt8);

  VerifyPosition(pFrom);
  VerifyItem(iID, iCount);
  VerifyPosition(pTo);
end;

procedure TTibiaPackerParser.Client_ShopLook(PacketID: BInt32);
var
  iID, iCount: BInt32;
begin
  iID := Buffer.GetBUInt16;
  iCount := BInt8(Buffer.GetBInt8);
  VerifyItem(iID, iCount);
end;

procedure TTibiaPackerParser.Client_ShopBuy(PacketID: BInt32);
var
  iID, iCount, iAmount: BInt32;
  bIgnoreCap, bInBackpacks: boolean;
begin
  iID := Buffer.GetBUInt16;
  iCount := BInt8(Buffer.GetBInt8);
  iAmount := BInt8(Buffer.GetBInt8);
  bIgnoreCap := (BInt8(Buffer.GetBInt8) = 1);
  bInBackpacks := (BInt8(Buffer.GetBInt8) = 1);
  VerifyItem(iID, iCount);
  VerifyItem(iID, iAmount);
end;

procedure TTibiaPackerParser.Client_ShopSold(PacketID: BInt32);
var
  iID, iCount, iAmount: BInt32;
  KeepEquipped: BBool;
begin
  iID := Buffer.GetBUInt16;
  iCount := BInt8(Buffer.GetBInt8);
  iAmount := BInt8(Buffer.GetBInt8);
  KeepEquipped := Buffer.GetBInt8 = 1;
  VerifyItem(iID, iCount);
  VerifyItem(iID, iAmount);
end;

procedure TTibiaPackerParser.Client_ShopClose(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_TradeRequest(PacketID: BInt32);
var
  pPos: BPos;
  iID, iStack, iPlayer: BInt32;
begin
  pPos := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  iPlayer := Buffer.GetBInt32;
  VerifyPosition(pPos);
  VerifyItem(iID, 1);
  VerifyCreature(iPlayer);
end;

procedure TTibiaPackerParser.Client_TransferCoin(PacketID: BInt32);
var
  ToCharacter: BStr;
  Amount: BInt32;
begin
  ToCharacter := Buffer.GetBStr16;
  Amount := Buffer.GetBInt32;
end;

procedure TTibiaPackerParser.Client_TradeLook(PacketID: BInt32);
var
  iCounter, iIndex: BInt32;
begin
  iCounter := BInt8(Buffer.GetBInt8);
  iIndex := BInt8(Buffer.GetBInt8);
  if iCounter = iIndex + 1 then
    Exit;
  if iIndex = iCounter - 1 then
    Exit;
end;

procedure TTibiaPackerParser.Client_TradeAccept(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_TradeCancel(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_UseItem(PacketID: BInt32);
var
  pPos: BPos;
  iID, iStack, iIndex: BInt32;
  bHotkey: boolean;
begin
  pPos := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  iIndex := BInt8(Buffer.GetBInt8);
  bHotkey := (pPos.X = $FFFF) and (pPos.Y = 0) and (pPos.Z = 0);
  if pPos.Y <> BInt32(SlotPurseMarket) then
  begin
    VerifyPosition(pPos);
    VerifyItem(iID, 1);
  end;
end;

procedure TTibiaPackerParser.Client_UseItemEx(PacketID: BInt32);
var
  pFrom, pTo: BPos;
  iID, iStack, iToID, iToStack: BInt32;
  bHotkey: boolean;
  UseOnItemData: TTibiaUseOnItem;
begin
  pFrom := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  pTo := GetPos;
  iToID := Buffer.GetBUInt16;
  iToStack := BInt8(Buffer.GetBInt8);
  bHotkey := (pFrom.X = $FFFF) and (pFrom.Y = 0) and (pFrom.Z = 0);
  VerifyPosition(pFrom);
  VerifyItem(iID, 1);
  VerifyPosition(pTo);
  VerifyItem(iID, 1);
  UseOnItemData.FromPosition := pFrom;
  UseOnItemData.FromID := iID;
  UseOnItemData.FromStack := iStack;
  UseOnItemData.ToPosition := pTo;
  UseOnItemData.ToID := iToID;
  UseOnItemData.ToStack := iToStack;
  BBot.Events.RunUseOnItem(UseOnItemData);
end;

procedure TTibiaPackerParser.Client_ShootOnBattle(PacketID: BInt32);
var
  pPos: BPos;
  iID, iStack, iTarget: BInt32;
  bHotkey: boolean;
  UseOnCreatureData: TTibiaUseOnCreature;
begin
  pPos := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  iTarget := Buffer.GetBInt32;
  bHotkey := (pPos.X = $FFFF) and (pPos.Y = 0) and (pPos.Z = 0);
  VerifyPosition(pPos);
  VerifyItem(iID, 1);
  VerifyCreature(iTarget);

  UseOnCreatureData.FromPosition := pPos;
  UseOnCreatureData.ItemID := iID;
  UseOnCreatureData.Stack := iStack;
  UseOnCreatureData.Creature := iTarget;
  BBot.Events.RunUseOnCreature(UseOnCreatureData);
end;

procedure TTibiaPackerParser.Client_RotateItem(PacketID: BInt32);
var
  pPos: BPos;
  iID, iStack: BInt32;
begin
  pPos := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  VerifyPosition(pPos);
  VerifyItem(iID, 1);
end;

procedure TTibiaPackerParser.Client_ContainerClose(PacketID: BInt32);
var
  iCID: BInt32;
begin
  iCID := BInt8(Buffer.GetBInt8);
  VerifyContainer(iCID, 1);
end;

procedure TTibiaPackerParser.Client_ContainerParent(PacketID: BInt32);
var
  iCID: BInt32;
begin
  iCID := BInt8(Buffer.GetBInt8);
  VerifyContainer(iCID, 1);
end;

procedure TTibiaPackerParser.Client_WindowText(PacketID: BInt32);
var
  iWindowID: BInt32;
  sNewText: BStr;
begin
  iWindowID := Buffer.GetBInt32;
  sNewText := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.Client_WrapToggle(PacketID: BInt32);
begin
  GetPos; // Position
  Buffer.GetBUInt16; // Item ID
  Buffer.GetBInt8; // Stack
end;

procedure TTibiaPackerParser.Client_WindowHouseText(PacketID: BInt32);
var
  iWindowID, iDoorID: BInt32;
  sNewText: BStr;
begin
  iDoorID := BInt8(Buffer.GetBInt8);
  iWindowID := Buffer.GetBInt32;
  sNewText := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.Client_LookAt(PacketID: BInt32);
var
  pPos: BPos;
  iID, iStack: BInt32;
begin
  pPos := GetPos;
  iID := Buffer.GetBUInt16;
  iStack := BInt8(Buffer.GetBInt8);
  VerifyPosition(pPos);
  VerifyItem(iID, 1);
end;

procedure TTibiaPackerParser.Client_LookAtCreature(PacketID: BInt32);
begin
  Buffer.GetBInt32; // Creature ID
end;

procedure TTibiaPackerParser.Client_Say(PacketID: BInt32);
var
  SayData: TTibiaMessage;
begin
  SayData.Mode := Tibia.MessageModeFrom(Buffer.GetBInt8);

  case SayData.Mode of
    MESSAGE_PRIVATE_TO, MESSAGE_GAMEMASTER_PRIVATE_TO:
      begin
        SayData.Receiver := Buffer.GetBStr16;
      end;
    MESSAGE_CHANNEL_MANAGEMENT, MESSAGE_CHANNEL, MESSAGE_CHANNEL_HIGHLIGHT:
      begin
        SayData.Channel := Buffer.GetBInt16;
      end;
  end;
  SayData.Text := Buffer.GetBStr16;
  if Length(SayData.Text) > 255 then
    ReportUnexpectedBehavior('Big Text', PacketID);
  BBot.Events.RunSay(SayData);
end;

procedure TTibiaPackerParser.Client_SeekContainerPage(PacketID: BInt32);
begin
  Buffer.GetBInt8; // ContainerID
  Buffer.GetBInt16; // Index
end;

procedure TTibiaPackerParser.Client_ChannelList(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_ChannelOpen(PacketID: BInt32);
var
  iChannel: BInt32;
begin
  iChannel := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.Client_ChannelClose(PacketID: BInt32);
var
  iChannel: BInt32;
begin
  iChannel := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.Client_ChannelPrivate(PacketID: BInt32);
var
  sReceiver: BStr;
begin
  sReceiver := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.Client_RuleViolation(PacketID: BInt32);
var
  sReceiver: BStr;
begin
  sReceiver := Buffer.GetBStr16;
  // ReportUnexpectedBehavior(Format('RuleViolation %s', [sReceiver]), PacketID);
end;

procedure TTibiaPackerParser.Client_RuleViolationReport(PacketID: BInt32);
const
  REPORT_NATURE_NAME = 0;
  REPORT_NATURE_BOT = 2;
var
  Nature, Reason, Statement: BInt8;
  CharName, Comment, Translation: BStr;
begin
  Nature := Buffer.GetBInt8;
  if Nature = REPORT_NATURE_NAME then
  begin
    Reason := Buffer.GetBInt8;
    CharName := Buffer.GetBStr16;
    Comment := Buffer.GetBStr16;
    Translation := Buffer.GetBStr16;
    Statement := Buffer.GetBInt16;
    // BBotEngine_SendError
    // (BFormat('RuleViolationReport \n Nature: NAME \n Reason: %d \n Statement: %d \n Comment: %s \n Translation: %s',
    // [Reason, Statement, Comment, Translation]));
  end
  else if Nature = REPORT_NATURE_BOT then
  begin
    Reason := Buffer.GetBInt8;
    CharName := Buffer.GetBStr16;
    Comment := Buffer.GetBStr16;
    // BBotEngine_SendError(BFormat('RuleViolationReport \n Nature: BOT \n Reason: %d \n Comment: %s', [Reason, Comment]));
  end;
end;

procedure TTibiaPackerParser.Client_RuleViolationCancel(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_NPCClose(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_AttackMode(PacketID: BInt32);
var
  iFight, iChase, iSecure: BInt32;
begin
  iFight := BInt8(Buffer.GetBInt8);
  iChase := BInt8(Buffer.GetBInt8);
  iSecure := BInt8(Buffer.GetBInt8);
  if (not InRange(iFight, 1, 3)) or (not InRange(iChase, 0, 1)) or
    (not InRange(iSecure, 0, 1)) then
    ReportUnexpectedBehavior(BFormat('Fight Mode %d %d %d',
      [iFight, iChase, iSecure]), PacketID);
end;

procedure TTibiaPackerParser.Client_AnswerModal(PacketID: BInt32);
begin
  Buffer.GetBInt32; // ID
  Buffer.GetBInt8; // Button
  Buffer.GetBInt8; // Choice
end;

procedure TTibiaPackerParser.Client_Attack(PacketID: BInt32);
var
  iTarget: BUInt32;
  AttackCount: BUInt32;
begin
  iTarget := BUInt32(Buffer.GetBInt32);
  if iTarget <> 0 then
    VerifyCreature(iTarget);
  if AdrSelected >= TibiaVer860 then
    AttackCount := BUInt32(Buffer.GetBInt32);
end;

procedure TTibiaPackerParser.Client_Follow(PacketID: BInt32);
var
  iTarget: BUInt32;
begin
  iTarget := BUInt32(Buffer.GetBInt32);
  BBot.Events.RunCreatureFollow(iTarget);
  if AdrSelected >= TibiaVer860 then
    Buffer.GetBInt32; // Creature ID again
  if iTarget <> 0 then
    VerifyCreature(iTarget);
end;

procedure TTibiaPackerParser.Client_JoinAgression(PacketID: BInt32);
begin
  Buffer.GetBInt32; // Creature ID
end;

procedure TTibiaPackerParser.Client_PartyInvite(PacketID: BInt32);
var
  iTarget: BInt32;
begin
  iTarget := Buffer.GetBInt32;
  VerifyCreature(iTarget);
end;

procedure TTibiaPackerParser.Client_PartyJoin(PacketID: BInt32);
var
  iTarget: BInt32;
begin
  iTarget := Buffer.GetBInt32;
  VerifyCreature(iTarget);
end;

procedure TTibiaPackerParser.Client_PartyRevoke(PacketID: BInt32);
var
  iTarget: BInt32;
begin
  iTarget := Buffer.GetBInt32;
  VerifyCreature(iTarget);
end;

procedure TTibiaPackerParser.Client_PartyPassLeader(PacketID: BInt32);
var
  iTarget: BInt32;
begin
  iTarget := Buffer.GetBInt32;
  VerifyCreature(iTarget);
end;

procedure TTibiaPackerParser.Client_PartyLeave(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_PartyShared(PacketID: BInt32);
var
  iShared: BInt32;
begin
  iShared := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.Client_PerformanceMetrics(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_ChannelPrivateCreate(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_ChannelPrivateInvite(PacketID: BInt32);
var
  sName: BStr;
  iChannelID: BInt32;
begin
  sName := Buffer.GetBStr16;
  if AdrSelected > TibiaVer1080 then
    iChannelID := Buffer.GetBInt16;
end;

procedure TTibiaPackerParser.Client_ClearEmbuiment(PacketID: BInt32);
begin
  Buffer.GetBInt8; // Slot
end;

procedure TTibiaPackerParser.Client_ChannelPrivateExclude(PacketID: BInt32);
var
  sName: BStr;
begin
  sName := Buffer.GetBStr16;
  if AdrSelected >= TibiaVer900 then
    Buffer.GetBInt16; // Channel ID
end;

procedure TTibiaPackerParser.Client_CancelMove(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_RequestUpdateTile(PacketID: BInt32);
var
  pPos: BPos;
begin
  pPos := GetPos;
end;

procedure TTibiaPackerParser.Client_RequestResourceBalance(PacketID: BInt32);
begin
  Buffer.GetBInt8; // Resource Type
end;

procedure TTibiaPackerParser.Client_RequestUpdateContainers(PacketID: BInt32);
var
  iCID: BInt32;
begin
  iCID := BInt8(Buffer.GetBInt8);
end;

procedure TTibiaPackerParser.Client_PurseMarketAccept(PacketID: BInt32);
begin
  Buffer.GetBInt32; // Time stamp
  Buffer.GetBInt16; // Offer ID
  Buffer.GetBInt16; // Amount
end;

procedure TTibiaPackerParser.Client_PurseMarketBrowse(PacketID: BInt32);
begin
  Buffer.GetBInt16; // TypeID
end;

procedure TTibiaPackerParser.Client_PurseMarketBuy(PacketID: BInt32);
const
  SERVICETYPE_OTHER = 0;
  SERVICETYPE_CHARACTER_NAME_CHANGE = 1;
var
  OfferID, ServiceType: BInt32;
  NewName: BStr;
begin
  OfferID := Buffer.GetBInt32;
  ServiceType := Buffer.GetBInt8;
  if ServiceType = SERVICETYPE_CHARACTER_NAME_CHANGE then
    NewName := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.Client_PurseMarketOpen(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_PurseMarketOpenCategory(PacketID: BInt32);
begin
  Buffer.GetBStr16; // Category Name
end;

procedure TTibiaPackerParser.Client_PurseMarketOpenTransactionHistory
  (PacketID: BInt32);
begin
  Buffer.GetBInt8; // Entries per page
end;

procedure TTibiaPackerParser.Client_PurseMarketTransactionHistory
  (PacketID: BInt32);
begin
  Buffer.GetBInt16; // Current Page
  Buffer.GetBInt32; // Entries per page
end;

procedure TTibiaPackerParser.Client_OutfitRequest(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_OutfitSet(PacketID: BInt32);
begin
  GetOutfit;
end;

procedure TTibiaPackerParser.Client_VipAdd(PacketID: BInt32);
var
  sName: BStr;
begin
  sName := Buffer.GetBStr16;
end;

procedure TTibiaPackerParser.Client_VipEdit(PacketID: BInt32);
begin
  Buffer.GetBInt32; // Friend ID
  Buffer.GetBStr16; // Description
  Buffer.GetBInt32; // Icon
  Buffer.GetBInt8; // Notify == 1
end;

procedure TTibiaPackerParser.Client_VipRemove(PacketID: BInt32);
var
  iVipID: BInt32;
begin
  iVipID := Buffer.GetBInt32;
end;

procedure TTibiaPackerParser.Client_BrowseField(PacketID: BInt32);
begin
  GetPos;
end;

procedure TTibiaPackerParser.Client_BugReport(PacketID: BInt32);
const
  BUG_CATEGORY_MAP = 0;
  BUG_CATEGORY_TYPO = 1;
  BUG_CATEGORY_TECHNICAL = 2;
var
  Mssage, Speaker, Text: BStr;
  BugCategory: BInt8;
begin
  if AdrSelected >= TibiaVer900 then
  begin
    BugCategory := Buffer.GetBInt8;
    Mssage := Buffer.GetBStr16;
    if BugCategory = BUG_CATEGORY_MAP then
    begin
      Mssage := BFormat('Position: %s\n%s', [BStr(GetPos), Mssage]);
    end
    else if BugCategory = BUG_CATEGORY_TYPO then
    begin
      Speaker := Buffer.GetBStr16;
      Text := Buffer.GetBStr16;
      Mssage := BFormat('Typo: %s - %s\n%s', [Speaker, Text, Mssage]);
    end;
  end
  else
  begin
    Mssage := Buffer.GetBStr16;
  end;
  ReportUnexpectedBehavior(Format('BugReport\n%s', [Mssage]), PacketID);
end;

procedure TTibiaPackerParser.Client_ViolationWindow(PacketID: BInt32);
var
  bIPBan: boolean;
  iChannelID, iActionID, iReasonID: BInt32;
  sName, sStatement, sComment: BStr;
begin
  sName := Buffer.GetBStr16;
  iReasonID := BInt8(Buffer.GetBInt8);
  iActionID := BInt8(Buffer.GetBInt8);
  sComment := Buffer.GetBStr16;
  sStatement := Buffer.GetBStr16;
  iChannelID := Buffer.GetBInt16;
  bIPBan := (BInt8(Buffer.GetBInt8) = 1);
  ReportUnexpectedBehavior(Format('Violation %s %s %d/%d/%d',
    [sName, sComment, iReasonID, iActionID, iChannelID, IfThen(bIPBan, 'IP Ban',
    '-')]), PacketID);
end;

procedure TTibiaPackerParser.Client_DebugAsset(PacketID: BInt32);
var
  sComment, sDescription, sDate, sLine: BStr;
begin
  sLine := Buffer.GetBStr16;
  sDate := Buffer.GetBStr16;
  sDescription := Buffer.GetBStr16;
  sComment := Buffer.GetBStr16;
  ReportUnexpectedBehavior(Format('DebugAsset %s %s %s %s',
    [sDate, sLine, sDescription, sComment]), PacketID);
end;

procedure TTibiaPackerParser.Client_Quests(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_QuestsView(PacketID: BInt32);
var
  iViewID: BInt32;
begin
  iViewID := Buffer.GetBInt16;
end;

function TTibiaPackerParser.ParseClient: boolean;
  procedure callClientParser(const AName: BStr; const AProc: BUnaryProc<BInt32>;
    const APacketID: BInt32);
  begin
    FuncName := AName;
    AProc(APacketID);
  end;

var
  PacketID: BInt32;
begin
  FuncName := '?';
  PacketID := BInt8(Buffer.GetBInt8);
  try
    case PacketID of
      $01:
        callClientParser('Client_Login', Client_Login, PacketID);
      $0F:
        callClientParser('Client_EnterWorld', Client_EnterWorld, PacketID);
      $0A:
        callClientParser('Client_Login', Client_Login, PacketID);
      $14:
        callClientParser('Client_Logout', Client_Logout, PacketID);
      $1D:
        callClientParser('Client_Ping', Client_Ping, PacketID);
      $1E:
        callClientParser('Client_PingBack', Client_PingBack, PacketID);
      $1F:
        callClientParser('Client_PerformanceMetrics', Client_PerformanceMetrics,
          PacketID);
      $64:
        callClientParser('Client_AutoMove', Client_AutoMove, PacketID);
      $65:
        callClientParser('Client_North', Client_North, PacketID);
      $66:
        callClientParser('Client_East', Client_East, PacketID);
      $67:
        callClientParser('Client_South', Client_South, PacketID);
      $68:
        callClientParser('Client_West', Client_West, PacketID);
      $69:
        callClientParser('Client_StopAutoMove', Client_StopAutoMove, PacketID);
      $6A:
        callClientParser('Client_NorthEast', Client_NorthEast, PacketID);
      $6B:
        callClientParser('Client_SouthEast', Client_SouthEast, PacketID);
      $6C:
        callClientParser('Client_SouthWest', Client_SouthWest, PacketID);
      $6D:
        callClientParser('Client_NorthWest', Client_NorthWest, PacketID);
      $6F:
        callClientParser('Client_TurnNorth', Client_TurnNorth, PacketID);
      $70:
        callClientParser('Client_TurnEast', Client_TurnEast, PacketID);
      $71:
        callClientParser('Client_TurnSouth', Client_TurnSouth, PacketID);
      $72:
        callClientParser('Client_TurnWest', Client_TurnWest, PacketID);
      $77:
        callClientParser('Client_Equip', Client_Equip, PacketID);
      $78:
        callClientParser('Client_Throw', Client_Throw, PacketID);
      $79:
        callClientParser('Client_ShopLook', Client_ShopLook, PacketID);
      $7A:
        callClientParser('Client_ShopBuy', Client_ShopBuy, PacketID);
      $7B:
        callClientParser('Client_ShopSold', Client_ShopSold, PacketID);
      $7C:
        callClientParser('Client_ShopClose', Client_ShopClose, PacketID);
      $7D:
        callClientParser('Client_TradeRequest', Client_TradeRequest, PacketID);
      $7E:
        callClientParser('Client_TradeLook', Client_TradeLook, PacketID);
      $7F:
        callClientParser('Client_TradeAccept', Client_TradeAccept, PacketID);
      $80:
        callClientParser('Client_TradeCancel', Client_TradeCancel, PacketID);
      $82:
        callClientParser('Client_UseItem', Client_UseItem, PacketID);
      $83:
        callClientParser('Client_UseItemEx', Client_UseItemEx, PacketID);
      $84:
        callClientParser('Client_ShootOnBattle', Client_ShootOnBattle,
          PacketID);
      $85:
        callClientParser('Client_RotateItem', Client_RotateItem, PacketID);
      $87:
        callClientParser('Client_ContainerClose', Client_ContainerClose,
          PacketID);
      $88:
        callClientParser('Client_ContainerParent', Client_ContainerParent,
          PacketID);
      $89:
        callClientParser('Client_WindowText', Client_WindowText, PacketID);
      $8A:
        callClientParser('Client_WindowHouseText', Client_WindowHouseText,
          PacketID);
      $8B:
        callClientParser('Client_WrapToggle', Client_WrapToggle, PacketID);
      $8C:
        callClientParser('Client_LookAt', Client_LookAt, PacketID);
      $8D:
        callClientParser('Client_LookAtCreature', Client_LookAtCreature,
          PacketID);
      $8E:
        callClientParser('Client_JoinAgression', Client_JoinAgression,
          PacketID);
      $96:
        callClientParser('Client_Say', Client_Say, PacketID);
      $97:
        callClientParser('Client_ChannelList', Client_ChannelList, PacketID);
      $98:
        callClientParser('Client_ChannelOpen', Client_ChannelOpen, PacketID);
      $99:
        callClientParser('Client_ChannelClose', Client_ChannelClose, PacketID);
      $9A:
        callClientParser('Client_ChannelPrivate', Client_ChannelPrivate,
          PacketID);
      $9B:
        callClientParser('Client_RuleViolation', Client_RuleViolation,
          PacketID);
      $9C:
        callClientParser('Client_EditGuildMessage', Client_EditGuildMessage,
          PacketID);
      $9D:
        callClientParser('Client_RuleViolationCancel',
          Client_RuleViolationCancel, PacketID);
      $9E:
        callClientParser('Client_NPCClose', Client_NPCClose, PacketID);
      $A0:
        callClientParser('Client_AttackMode', Client_AttackMode, PacketID);
      $A1:
        callClientParser('Client_Attack', Client_Attack, PacketID);
      $A2:
        callClientParser('Client_Follow', Client_Follow, PacketID);
      $A3:
        callClientParser('Client_PartyInvite', Client_PartyInvite, PacketID);
      $A4:
        callClientParser('Client_PartyJoin', Client_PartyJoin, PacketID);
      $A5:
        callClientParser('Client_PartyRevoke', Client_PartyRevoke, PacketID);
      $A6:
        callClientParser('Client_PartyPassLeader', Client_PartyPassLeader,
          PacketID);
      $A7:
        callClientParser('Client_PartyLeave', Client_PartyLeave, PacketID);
      $A8:
        callClientParser('Client_PartyShared', Client_PartyShared, PacketID);
      $AA:
        callClientParser('Client_ChannelPrivateCreate',
          Client_ChannelPrivateCreate, PacketID);
      $AB:
        callClientParser('Client_ChannelPrivateInvite',
          Client_ChannelPrivateInvite, PacketID);
      $AC:
        callClientParser('Client_ChannelPrivateExclude',
          Client_ChannelPrivateExclude, PacketID);
      $BE:
        callClientParser('Client_CancelMove', Client_CancelMove, PacketID);
      $C9:
        callClientParser('Client_RequestUpdateTile', Client_RequestUpdateTile,
          PacketID);
      $CA:
        callClientParser('Client_RequestUpdateContainers',
          Client_RequestUpdateContainers, PacketID);
      $CB:
        callClientParser('Client_BrowseField', Client_BrowseField, PacketID);
      $CC:
        callClientParser('Client_SeekContainerPage', Client_SeekContainerPage,
          PacketID);
      $D2:
        callClientParser('Client_OutfitRequest', Client_OutfitRequest,
          PacketID);
      $D3:
        callClientParser('Client_OutfitSet', Client_OutfitSet, PacketID);
      $D4:
        callClientParser('Client_MountDismount', Client_MountDismount,
          PacketID);
      $D5:
        callClientParser('Client_Embuiment', Client_Embuiment, PacketID);
      $D6:
        callClientParser('Client_ClearEmbuiment', Client_ClearEmbuiment,
          PacketID);
      $DC:
        callClientParser('Client_VipAdd', Client_VipAdd, PacketID);
      $DE:
        callClientParser('Client_VipEdit', Client_VipEdit, PacketID);
      $DD:
        callClientParser('Client_VipRemove', Client_VipRemove, PacketID);
      $E6:
        callClientParser('Client_BugReport', Client_BugReport, PacketID);
      $E7:
        callClientParser('Client_ViolationWindow', Client_ViolationWindow,
          PacketID);
      $E8:
        callClientParser('Client_DebugAsset', Client_DebugAsset, PacketID);
      $E9:
        callClientParser('Client_StoreEvent', Client_StoreEvent, PacketID);
      $EB:
        callClientParser('Client_PreyAction', Client_PreyAction, PacketID);
      $EF:
        callClientParser('Client_TransferCoin', Client_TransferCoin, PacketID);
      $ED:
        callClientParser('Client_RequestResourceBalance',
          Client_RequestResourceBalance, PacketID);
      $F0:
        callClientParser('Client_Quests', Client_Quests, PacketID);
      $F1:
        callClientParser('Client_QuestsView', Client_QuestsView, PacketID);
      $F2:
        callClientParser('Client_RuleViolationReport',
          Client_RuleViolationReport, PacketID);
      $F4:
        callClientParser('Client_PurseMarketLeave', Client_PurseMarketLeave,
          PacketID);
      $F5:
        callClientParser('Client_PurseMarketBrowse', Client_PurseMarketBrowse,
          PacketID);
      $F6:
        callClientParser('Client_PurseMarketCreate', Client_PurseMarketCreate,
          PacketID);
      $F7:
        callClientParser('Client_PurseMarketCancel', Client_PurseMarketCancel,
          PacketID);
      $F8:
        callClientParser('Client_PurseMarketAccept', Client_PurseMarketAccept,
          PacketID);
      $F9:
        callClientParser('Client_AnswerModal', Client_AnswerModal, PacketID);
      $FA:
        callClientParser('Client_PurseMarketOpen', Client_PurseMarketOpen,
          PacketID);
      $FB:
        callClientParser('Client_PurseMarketOpenCategory',
          Client_PurseMarketOpenCategory, PacketID);
      $FC:
        callClientParser('Client_PurseMarketBuy', Client_PurseMarketBuy,
          PacketID);
      $FD:
        callClientParser('Client_PurseMarketOpenTransactionHistory',
          Client_PurseMarketOpenTransactionHistory, PacketID);
      $FE:
        callClientParser('Client_PurseMarketTransactionHistory',
          Client_PurseMarketTransactionHistory, PacketID);
    else
      begin
        Client_UnknownID(PacketID);
        Exit(False);
      end;
    end;
  except
    on E: Exception do
      raise BException.Create
        (String(BFormat('Failed to parse Client 0x%x: %s\n%s',
        [PacketID, E.Message, BufferToStr])));
  end;
  // if not Buffer.EOP then
  // ReportUnexpectedBehavior('Unfinished packet', PacketID);
  Exit(True);
end;

function TTibiaPackerParser.ParseFloorDescription(X, Y, Z, Width, Height,
  Offset: BInt32; var m_skipTiles: BInt32): boolean;
var
  Pos: BPos;
  tileOpt: BInt32;
  nY: BInt32;
  nX: BInt32;
  skipTiles: BInt32;
begin
  BBot.StandTime := Tick;
  Result := False;
  for nX := 0 to (Width - 1) do
    for nY := 0 to (Height - 1) do
    begin
      if m_skipTiles = 0 then
      begin
        tileOpt := Buffer.GetBInt16;
        Buffer.Position := Buffer.Position - 2;
        if tileOpt >= $FF00 then
        begin
          skipTiles := Buffer.GetBInt16;
          m_skipTiles := (skipTiles and $FF);
        end
        else
        begin
          Pos := BPosXYZ(X + nX + Offset, Y + nY + Offset, Z);
          if not SetTileDescription(Pos) then
            Exit;
          skipTiles := Buffer.GetBInt16;
          m_skipTiles := (skipTiles and $FF);
        end;
      end
      else
        m_skipTiles := Max(m_skipTiles - 1, 0);
    end;
  Result := True;
end;

procedure TTibiaPackerParser.ParseMapInfo(X, Y, Z, Width, Height: BInt32);
var
  zStart, zEnd, zStep, zI, m_skipTiles: BInt32;
begin
  Tibia.PingEnd;
  if Z > 7 then
  begin
    zStart := Z - 2;
    zEnd := Min(15, Z + 2);
    zStep := 1;
  end
  else
  begin
    zStart := 7;
    zEnd := 0;
    zStep := -1;
  end;
  zI := zStart;
  while zI <> (zEnd + zStep) do
  begin
    if not ParseFloorDescription(X, Y, zI, Width, Height, Z - zI, m_skipTiles)
    then
      Break;
    zI := (zI + zStep);
  end;
end;

procedure TTibiaPackerParser.ParseServer;
var
  PacketID: BInt32;
begin
  PacketID := BInt8(Buffer.GetBInt8);
  try
    case PacketID of
      $0A:
        ParseLogin;
      $0B:
        ParseViolations;
      $15:
        ParseFYIBox;
      $16:
        ParseQueue;
      $17:
        ParseLoggedIn;
      $1E:
        ParsePinged;
      $28:
        ParseDead;
      $5B:
        ParseSnapBack;
      $64:
        ParseMapDescription;
      $65:
        ParseMapDescriptionNorth;
      $66:
        ParseMapDescriptionEast;
      $67:
        ParseMapDescriptionSouth;
      $68:
        ParseMapDescriptionWest;
      $69:
        ParseMapUpdateTile;
      $6A:
        ParseTileAdd;
      $6B:
        ParseTileUpdate;
      $6C:
        ParseTileRemove;
      $6D:
        ParseCreatureMove;
      $6E:
        ParseContainer;
      $6F:
        ParseContainerClosed;
      $70:
        ParseContainerAdd;
      $71:
        ParseContainerUpdate;
      $72:
        ParseContainerRemove;
      $78:
        ParseInventorySet;
      $79:
        ParseInventoryRemove;
      $7A:
        ParseShop;
      $7B:
        ParseShopMyItems;
      $7C:
        ParseShopClosed;
      $7D:
        ParseTradeItemRequest;
      $7E:
        ParseTradeItemRequest;
      $7F:
        ParseTradeClosed;
      $82:
        ParseWorldLight;
      $83:
        ParseMagicEffect;
      $84:
        ParseAnimatedText;
      $85:
        ParseShoot;
      $86:
        ParseCreatureSquare;
      $87:
        ParseTrappers;
      $8C:
        ParseCreatureHP;
      $8D:
        ParseCreatureLight;
      $8E:
        ParseCreatureOutfit;
      $8F:
        ParseCreatureSpeed;
      $90:
        ParseCreatureSkull;
      $91:
        ParseCreatureParty;
      $96:
        ParseTextWindow;
      $97:
        ParseHouseWindow;
      $9C:
        ParseBlessings;
      $9D:
        ParseSwitchHotkeyPreset;
      $9E:
        ParsePremiumTrigger;
      $A0:
        ParseStatsUpdate;
      $A1:
        ParseSkillsUpdate;
      $A2:
        ParseStatusFlagsUpdate;
      $A3:
        ParseCancelTarget;
      $A4:
        ParseSpellCooldown;
      $A5:
        ParseGroupCooldown;
      $A6:
        ParseUseItemDelay;
      $A7:
        ParseSetTatics;
      $AA:
        ParseMessageReceived;
      $AB:
        ParseChannelDialogReceived;
      $AC:
        ParseChannelOpened;
      $AD:
        ParsePrivateOpened;
      $AE:
        ParseEditGuildMessage;
      $AF:
        ParseRuleViolationsRemove;
      $B0:
        ParseRuleViolationsCancel;
      $B1:
        ParseRuleViolationsLock;
      $B2:
        ParsePrivateChannelCreated;
      $B3:
        ParsePrivateClosed;
      $B4:
        ParseSystemMessage;
      $B5:
        ParseCancelWalk;
      $B6:
        ParseWalkDelay;
      $B7:
        ParseUnjustifiedPoints;
      $B8:
        ParsePVPSituations;
      $BE:
        ParseMapDescriptionUp;
      $BF:
        ParseMapDescriptionDown;
      $C8:
        ParseOutfitWindow;
      $D2:
        ParseVip;
      $D3:
        ParseVipLogin;
      $D4:
        ParseVipLogout;
      $DC:
        ParseTutorial;
      $DD:
        ParseAddMark;
      $DF:
        ParseCreditBalance;
      $E0:
        ParseMarketShopError;
      $E1:
        ParseMarketShopInfo;
      $F1:
        ParseQuestLine;
      $F2:
        ParseUpdatingShopBalance;
      $F3:
        ParseChannelEvent;
      $F5:
        ParsePlayerInventory;
      $F6:
        ParseMarketEnter;
      $F7:
        ParseMarketLeave;
      $FB:
        ParsePremiumShop;
      $FD:
        ParseTransactionHistory;
      $FE:
        ParseTransactionSucceed;
    end;
  except
    on E: Exception do
      raise BException.Create
        (String(BFormat('Failed to parse Server 0x%x: %s\n%s',
        [PacketID, E.Message, BufferToStr])));
  end;
end;

procedure TTibiaPackerParser.ParseSetTatics;
begin
  Buffer.GetBInt8; // Fight Mode
  Buffer.GetBInt8; // Chase Mode
  Buffer.GetBInt8; // Secure Mode
  Buffer.GetBInt8; // PVP Mode
end;

function TTibiaPackerParser.SetTileDescription(Pos: BPos): boolean;
  procedure ParseCreature(ID: BInt32);
  var
    Outfit: TTibiaOutfit;
    CID: BUInt32;
    PartyShield: byte;
    Skull: byte;
    Speed: BInt32;
    LightColor: byte;
    LightSize: byte;
    Dir: byte;
    HP: byte;
  begin
    if ID = $62 then
      CID := BUInt32(Buffer.GetBInt32) // ID
    else
    begin // ID = $61
      Buffer.GetBInt32; // Remove
      CID := BUInt32(Buffer.GetBInt32); // ID
      Buffer.GetBStr16; // Name
    end;
    HP := BInt8(Buffer.GetBInt8);
    Dir := BInt8(Buffer.GetBInt8);
    Outfit := GetOutfit;
    LightSize := BInt8(Buffer.GetBInt8);
    LightColor := BInt8(Buffer.GetBInt8);
    Speed := Buffer.GetBInt16;
    Skull := BInt8(Buffer.GetBInt8);
    PartyShield := BInt8(Buffer.GetBInt8);
  end;
  procedure ParseThing;
  var
    ID: BInt32;
  begin
    ID := Buffer.GetBUInt16;
    if (ID = $62) or (ID = $61) then
    begin
      ParseCreature(ID);
      Exit;
    end;
    if (ID = $63) then // Turn
    begin
      Buffer.GetBInt32; // Creature ID
      Buffer.GetBInt8; // Direction
      Exit;
    end;
    Buffer.Position := Buffer.Position - 2;
    GetItem;
  end;

var
  inspectID: BInt32;
  n: BInt32;
begin
  n := 0;
  while True do
  begin
    inspectID := Buffer.GetBUInt16;
    Buffer.Position := Buffer.Position - 2;
    if inspectID >= $FF00 then
    begin
      Result := True;
      Exit;
    end
    else
    begin
      if n > 10 then
      begin
        Result := False;
        Exit;
      end;
      ParseThing;
    end;
    Inc(n);
  end;
end;

procedure TTibiaPackerParser.Client_UnknownID(PacketID: BInt32);
begin
  ReportUnexpectedBehavior('PacketID unknown', PacketID);
end;

procedure TTibiaPackerParser.VerifyPosition(Pos: BPos);
begin
  // if (Abs(Me.Position.X - Pos.X) < 16) and (Abs(Me.Position.Y - Pos.Y) < 11) then
  // Exit;
  // if Pos.X = $FFFF then begin
  // if (Pos.Y = 0) and (Pos.Z = 0) then // Hotkey
  // Exit;
  // if (InRange(Pos.Y, BInt32(SlotFirst), BInt32(SlotLast)) or (Pos.Y = BInt32(SlotPurseMarket))) and (Pos.Z = 0) then
  // // Slot
  // Exit;
  // if InRange(Pos.Y, 63, 63 + 17) and (InRange(Pos.Z, 0, 35) or (Pos.Z = 255)) then // Container
  // Exit;
  // end;
  // ReportUnexpectedBehavior(Format('Invalid Position, %s -> %s', [BStr(Me.Position), BStr(Pos)]), PacketID);
end;

procedure TTibiaPackerParser.VerifyItem(ID, Count: BInt32);
begin
  // if (not InRange(ID, TibiaMinItems, TibiaLastItem)) or (not InRange(Count, 0, 100)) then
  // ReportUnexpectedBehavior(Format('Strange Item %d %d', [ID, Count]), PacketID);
end;

procedure TTibiaPackerParser.VerifyCreature(Creature: BUInt32);
begin
  // if BBot.Creatures.Find(Creature) = nil then
  // ReportUnexpectedBehavior('Cannot find Creature', PacketID);
end;

procedure TTibiaPackerParser.VerifyContainer(Container, Slot: BInt32);
begin
  // if (not InRange(Container, 0, 16)) or (not InRange(Slot, 0, 25)) then
  // ReportUnexpectedBehavior(Format('Invalid C/S %d/%d', [Container, Slot]), PacketID);
end;

procedure TTibiaPackerParser.ReadObjectInstance(const AItemID: BInt32);
begin
  // Skipped, too hard!
end;

procedure TTibiaPackerParser.ReadObjectInstance;
begin
  ReadObjectInstance(Buffer.GetBUInt16);
end;

procedure TTibiaPackerParser.ReportUnexpectedBehavior(Log: BStr;
  PacketID: BInt32);
begin
  BBotEngine_SendError(BFormat('Parsing %s %s -> %s [%d..%d]\n%s',
    [BStr(IntToHex(PacketID, 2)), FuncName, Log, Buffer.Position, EOP,
    BufferToStr]));
end;

procedure TTibiaPackerParser.ParseGroupCooldown;
begin
  Buffer.GetBInt8; // GroupID
  Buffer.GetBInt32; // Cooldown (MS)
end;

procedure TTibiaPackerParser.ParseSpellCooldown;
begin
  Buffer.GetBInt8; // SpellID
  Buffer.GetBInt32; // Cooldown (MS)
end;

procedure TTibiaPackerParser.Client_PurseMarketCancel(PacketID: BInt32);
begin
  Buffer.GetBInt32; // Timestamp
  Buffer.GetBInt16; // Offer Counter
end;

procedure TTibiaPackerParser.Client_PurseMarketCreate(PacketID: BInt32);
begin
  Buffer.GetBInt8; // Kind
  Buffer.GetBUInt16; // ID
  Buffer.GetBInt16; // Amount
  Buffer.GetBInt32; // Price
  Buffer.GetBInt8; // IsAnonymous == 1
end;

procedure TTibiaPackerParser.Client_PurseMarketLeave(PacketID: BInt32);
begin

end;

procedure TTibiaPackerParser.Client_MountDismount(PacketID: BInt32);
begin
  Buffer.GetBInt8; // 1 if mount, 0 if unmount
end;

procedure TTibiaPackerParser.ParseMessage(Author: BStr; Level: BInt32);
var
  MsgData: TTibiaMessage;
begin
  MsgData.Mode := Tibia.MessageModeFrom(Buffer.GetBInt8);
  MsgData.Level := Level;
  MsgData.Author := Author;
  MsgData.Position.zero;
  case MsgData.Mode of
    MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL, MESSAGE_SPELL, MESSAGE_BARK_LOW,
      MESSAGE_BARK_LOUD, MESSAGE_NPC_FROM_START_BLOCK:
      begin
        MsgData.Position := GetPos;
        MsgData.Text := Buffer.GetBStr16();
      end;
    MESSAGE_PRIVATE_FROM, MESSAGE_GAMEMASTER_PRIVATE_FROM:
      begin
        MsgData.Channel := 0; // Author;
        MsgData.Text := Buffer.GetBStr16();
      end;
    MESSAGE_CHANNEL, MESSAGE_NPC_FROM, MESSAGE_GAMEMASTER_CHANNEL,
      MESSAGE_CHANNEL_MANAGEMENT, MESSAGE_CHANNEL_HIGHLIGHT:
      begin
        MsgData.Channel := Buffer.GetBInt16;
        MsgData.Text := Buffer.GetBStr16();
      end;
    MESSAGE_GAMEMASTER_BROADCAST, MESSAGE_LOGIN, MESSAGE_ADMIN, MESSAGE_GAME,
      MESSAGE_FAILURE, MESSAGE_LOOK, MESSAGE_STATUS, MESSAGE_LOOT,
      MESSAGE_TRADE_NPC, MESSAGE_GUILD, MESSAGE_PARTY_MANAGEMENT, MESSAGE_PARTY,
      MESSAGE_HOTKEY_USE, MESSAGE_MARKET, MESSAGE_REPORT, MESSAGE_MANA:
      begin
        MsgData.Text := Buffer.GetBStr16();
      end;
    MESSAGE_DAMAGE_DEALED, MESSAGE_DAMAGE_RECEIVED, MESSAGE_DAMAGE_OTHERS:
      begin
        if AdrSelected >= TibiaVer1036 then
        begin
          MsgData.Position := GetPos;
          MsgData.HPDelta1 := Buffer.GetBInt32();
          MsgData.HPColor1 := Buffer.GetBInt8();
          MsgData.HPDelta2 := Buffer.GetBInt32();
          MsgData.HPColor2 := Buffer.GetBInt8();
        end
        else
        begin
          MsgData.Position := GetPos;
          MsgData.HPDelta1 := Buffer.GetBInt16();
          MsgData.HPColor1 := Buffer.GetBInt8();
          MsgData.HPDelta2 := Buffer.GetBInt16();
          MsgData.HPColor2 := Buffer.GetBInt8();
        end;
        MsgData.Text := Buffer.GetBStr16();
      end;
    MESSAGE_HEAL, MESSAGE_EXP, MESSAGE_HEAL_OTHERS, MESSAGE_EXP_OTHERS:
      begin
        if AdrSelected >= TibiaVer1036 then
        begin
          MsgData.Position := GetPos;
          MsgData.HPDelta1 := Buffer.GetBInt32();
          MsgData.HPColor1 := Buffer.GetBInt8();
        end
        else
        begin
          MsgData.Position := GetPos;
          MsgData.HPDelta1 := Buffer.GetBInt16();
          MsgData.HPColor1 := Buffer.GetBInt8();
        end;
        MsgData.Text := Buffer.GetBStr16();
      end;
  end;
  MsgData.System := False;
  if Author = Me.Name then
    BBot.Events.RunSay(MsgData);
  if Level = -1 then
  begin
    MsgData.System := True;
    BBot.Events.RunSystemMessage(MsgData)
  end
  else
    BBot.Events.RunMessage(MsgData);
end;

constructor TTibiaPackerParser.Create;
begin
  Buffer := TBBotPacket.Create;
end;

destructor TTibiaPackerParser.Destroy;
begin
  Buffer.Free;
  inherited;
end;

function TTibiaPackerParser.GetOutfit: TTibiaOutfit;
begin
  Result.Outfit := Buffer.GetBInt16;
  if Result.Outfit <> 0 then
  begin
    Result.HeadColor := BInt8(Buffer.GetBInt8);
    Result.BodyColor := BInt8(Buffer.GetBInt8);
    Result.LegsColor := BInt8(Buffer.GetBInt8);
    Result.FeetColor := BInt8(Buffer.GetBInt8);
    Result.Addons := BInt8(Buffer.GetBInt8);
    Result.Mount := 0;
    if AdrSelected >= TibiaVer870 then
      Result.Mount := Buffer.GetBInt16;
  end
  else
    Buffer.GetBInt32;
end;

function TTibiaPackerParser.GetPos: BPos;
begin
  Result.X := BUInt16(Buffer.GetBInt16);
  Result.Y := BUInt16(Buffer.GetBInt16);
  Result.Z := Buffer.GetBInt8;
end;

function TTibiaPackerParser.GetItem: TBufferItem;
begin
  Result.ID := Buffer.GetBUInt16;
  if AdrSelected >= TibiaVer900 then
    Buffer.GetBInt8; // MARK_UNMARKED
  Result.Count := 0;
  if (Result.ID >= TibiaMinItems) and (Result.ID <= TibiaLastItem) then
  begin
    if idfHasExtra in TibiaItems[Result.ID].DatFlags then
      Result.Count := BInt8(Buffer.GetBInt8);
    if idfAnimating in TibiaItems[Result.ID].DatFlags then
      Buffer.GetBInt8; // Animation Phrase
  end;
end;

function TTibiaPackerParser.BufferToStr: BStr;
begin
  Result := Buffer.BufferBStr;
end;

procedure TTibiaPackerParser.SetBuffer(ABuffer: Pointer; ASize: BInt32);
begin
  Buffer.SetReader(ABuffer, ASize);
end;

{ TTibiaPacketBase }

function TTibiaPacketBase.GetItem(Buffer: TBBotPacket): TBufferItem;
begin
  Result.ID := Buffer.GetBUInt16;
  if BInRange(Result.ID, TibiaMinItems, TibiaLastItem) and
    (idfHasExtra in TibiaItems[Result.ID].DatFlags) then
    Result.Count := BInt8(Buffer.GetBInt8)
  else
    Result.Count := 0;
end;

function TTibiaPacketBase.GetPos5(Buffer: TBBotPacket): BPos;
begin
  Result.X := Buffer.GetBUInt16;
  Result.Y := Buffer.GetBUInt16;
  Result.Z := Buffer.GetBInt8;
end;

{ TTibiaPacketSkip }

function TTibiaPacketSkip.CommandID: BInt8;
begin
  Result := 0;
end;

procedure TTibiaPacketSkip.Parse(Buffer: TBBotPacket);
begin

end;

{ TTibiaPacketMissileEffect }

function TTibiaPacketMissileEffect.CommandID: BInt8;
begin
  Result := $85;
end;

procedure TTibiaPacketMissileEffect.Parse(Buffer: TBBotPacket);
var
  PosFrom, PosTo: BPos;
  Effect: BInt8;
begin
  PosFrom := GetPos5(Buffer);
  PosTo := GetPos5(Buffer);
  Effect := Buffer.GetBInt8;
  // OnMissileEffect(PosFrom, PosTo, Effect)
  {
    if Assigned(Tibia.OnDistanceShoot) and Tibia.CallEvents then
    Tibia.OnDistanceShoot(Effect, PosFrom, PosTo);
  }
end;

{ TTibiaPacketAddTileItem }

function TTibiaPacketAddTileItem.CommandID: BInt8;
begin
  Result := $6A;
end;

procedure TTibiaPacketAddTileItem.Parse(Buffer: TBBotPacket);
var
  Parent: byte;
  Tile: BPos;
  Item: TBufferItem;
begin
  Tile := GetPos5(Buffer);
  Parent := BInt8(Buffer.GetBInt8);
  Item := GetItem(Buffer);
  // OnTileItemAdd(Pos, Stack, ID, Count)
  {
    if IntIn(Item.ID, ItemsFurnitures) then
    BBot.Protectors.OnProtector(bpkFurnitureonScreen, 0);

    if BIntIn(Item.ID, MagicWallField) then
    BBot.AddMwall(Tile, 20)
    else if BIntIn(Item.ID, WildGrowthField) then
    BBot.AddMwall(Tile, 45);

    case Item.ID of
    $62, $61:
    ParseCreature(Item.ID);
    end;
  }
end;

{ TTibiaPacketUpdateTileItem }

function TTibiaPacketUpdateTileItem.CommandID: BInt8;
begin
  Result := $6B;
end;

procedure TTibiaPacketUpdateTileItem.Parse(Buffer: TBBotPacket);
var
  Parent: byte;
  Tile: BPos;
  Item: TBufferItem;
begin
  Tile := GetPos5(Buffer);
  Parent := BInt8(Buffer.GetBInt8);
  Item := GetItem(Buffer);
  // OnTileItemUpdate(Pos, Stack, ID, Count)
  {
    if IntIn(Item.ID, ItemsFurnitures) then
    BBot.Protectors.OnProtector(bpkFurnitureonScreen, 0);

    if BIntIn(Item.ID, MagicWallField) then
    BBot.AddMwall(Tile, 20)
    else if BIntIn(Item.ID, WildGrowthField) then
    BBot.AddMwall(Tile, 45);


    case Item.ID of
    $62, $61:
    ParseCreature(Item.ID);
    end;
  }
end;

{ TTibiaPacketRemoveTileItem }

function TTibiaPacketRemoveTileItem.CommandID: BInt8;
begin
  Result := $6C;
end;

procedure TTibiaPacketRemoveTileItem.Parse(Buffer: TBBotPacket);
var
  Stackpos: byte;
  Tile: BPos;
begin
  Tile := GetPos5(Buffer);
  Stackpos := BInt8(Buffer.GetBInt8);
  // OnTileItemRemove(Pos, Stack)
  {
    HUDRemovePositionGroup(Tile.X, Tile.Y, Tile.Z, bhgAny);
  }
end;

{$HINTS ON}

end.
