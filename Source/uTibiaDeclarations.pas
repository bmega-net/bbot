unit uTibiaDeclarations;


interface

uses
  Classes,
  uBTypes,
  Windows,
  uTibiaState;

const
  BotVer: BStr = '88.2';
  BotVerInt: cardinal = 123456789;
  BotVerSupported: array [TibiaVerFirst .. TibiaVerLast] of BStr = ('8.50', '8.52', '8.53', '8.54', '8.55', '8.56',
    '8.57', '8.60', '8.61', '8.62', '8.70', '8.71', '8.72', '8.73', '8.74', '9.00', '9.10', '9.20', '9.31', '9.40',
    '9.41', '9.42', '9.43', '9.44', '9.45', '9.46', '9.50', '9.51', '9.52', '9.53', '9.54', '9.60', '9.61', '9.62',
    '9.63', '9.70', '9.71', '9.80', '9.81', '9.82', '9.83', '9.84', '9.8  5', '9.86', '9.90', '9.91', '9.92', '9.93',
    '9.94', '10.00', '10.01', '10.02', '10.10', '10.11', '10.12', '10.13', '10.20', '10.21', 'P10.21', '10.22', '10.30',
    '10.31', '10.32', '10.33', '10.34', '10.35', '10.36', '10.37', '10.38', '10.39', '10.40', '10.41', 'P10.41',
    '10.50', 'P10.50', '10.51', 'P10.51', '10.52', 'P10.52', '10.53', 'P10.53', '10.54', '10.55', '10.56', '10.57',
    '10.58', '10.59', '10.60', '10.61', '10.62', '10.63', '10.64', '10.70', '10.71', '10.72', '10.73', '10.74', '10.75',
    '10.76', '10.77', '10.78', '10.79', 'T10.81', '10.80', '10.81', '10.82', '10.90', '10.91', '10.92', '10.93',
    '10.94', '10.95', '10.96', '10.97', '10.98', '10.99', 'N10.00', '2N10.00', '3N10.00', '4N10.00', '5N10.00',
    '6N10.00', '7N10.00' { @@NEW_VERSION_SUPPORTED } );
  BotProcessAccess = PROCESS_TERMINATE or PROCESS_CREATE_THREAD or PROCESS_VM_OPERATION or PROCESS_VM_READ or
    PROCESS_VM_WRITE or PROCESS_DUP_HANDLE or PROCESS_CREATE_PROCESS or PROCESS_SET_QUOTA or PROCESS_SET_INFORMATION or
    PROCESS_QUERY_INFORMATION;

type
  TTibiaHudHAlign = (dwAuto = -1, dwLeft = 0, dwCenter, dwRight);
  TTibiaHudVAlign = (dwvTop, dwvCenter, dwvBottom);

  TTibiaMessageMode = (MESSAGE_NONE = 1, MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL, MESSAGE_PRIVATE_FROM,
    MESSAGE_PRIVATE_TO, MESSAGE_CHANNEL_MANAGEMENT, MESSAGE_CHANNEL, MESSAGE_CHANNEL_HIGHLIGHT, MESSAGE_SPELL,
    MESSAGE_NPC_FROM_START_BLOCK, MESSAGE_NPC_FROM, MESSAGE_NPC_TO, MESSAGE_GAMEMASTER_BROADCAST,
    MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_PRIVATE_FROM, MESSAGE_GAMEMASTER_PRIVATE_TO, MESSAGE_LOGIN,
    MESSAGE_ADMIN, MESSAGE_GAME, MESSAGE_FAILURE, MESSAGE_LOOK, MESSAGE_DAMAGE_DEALED, MESSAGE_DAMAGE_RECEIVED,
    MESSAGE_HEAL, MESSAGE_EXP, MESSAGE_DAMAGE_OTHERS, MESSAGE_HEAL_OTHERS, MESSAGE_EXP_OTHERS, MESSAGE_STATUS,
    MESSAGE_LOOT, MESSAGE_TRADE_NPC, MESSAGE_GUILD, MESSAGE_PARTY_MANAGEMENT, MESSAGE_PARTY, MESSAGE_BARK_LOW,
    MESSAGE_BARK_LOUD, MESSAGE_REPORT, MESSAGE_HOTKEY_USE, MESSAGE_TUTORIAL_HINT, MESSAGE_THANKYOU, MESSAGE_MARKET,
    MESSAGE_GAME_HIGHLIGHT, MESSAGE_MANA);

  TTibiaMessage = record
    Mode: TTibiaMessageMode;
    System: BBool;
    Channel: BInt32;
    Author, Receiver: BStr;
    Level: BInt32;
    Position: BPos;
    HPDelta1: BInt32;
    HPColor1: BInt32;
    HPDelta2: BInt32;
    HPColor2: BInt32;
    Text: BStr;
  end;

  TTibiaUseOnCreature = record
    FromPosition: BPos;
    ItemID: BInt32;
    Stack: BInt8;
    Creature: BUInt32;
  end;

  TTibiaUseOnItem = record
    FromPosition: BPos;
    FromID: BInt32;
    FromStack: BInt8;
    ToPosition: BPos;
    ToID: BInt32;
    ToStack: BInt8;
  end;

  TTibiaMissileEffect = record
    FromPosition: BPos;
    ToPosition: BPos;
    Effect: BInt32;
  end;

  TTibiaSkill = (SkillFirst = 1, SkillFist = SkillFirst, SkillClub, SkillSword, SkillAxe, SkillDistance, SkillShielding,
    SkillFishing, SkillMagic, SkillLast = SkillMagic);

  TTibiaSelfSkill = array [SkillFirst .. SkillLast] of BInt32;

  TTibiaSpecialSkill = (SpecialSkillFirst = 1,
    SpecialSkillCriticalHitChance,
    SpecialSkillCriticalHitAmount,
    SpecialSkillHpLeechChance,
    SpecialSkillHpLeechAmount,
    SpecialSkillManaLeechChance,
    SpecialSkillManaLeechAmount,
    SpecialSkillLast = SpecialSkillManaLeechAmount);

  TTibiaSelfSpecialSkill = array [SpecialSkillFirst .. SpecialSkillLast] of BInt32;

  TTibiaStatus = (tsPoisoned = 0, tsBurning, tsElectrified, tsDrunk, tsProtectedByMagicShield, tsParalysed, tsHasted,
    tsInBattle, tsDrowning, tsFreezing, tsDazzled, tsCursed, tsStrengthened, tsCannotLogoutOrEnterProtectionZone,
    tsWithinProtectionZone, tsBleeding, tsDeath, tsInvisible, tsLight, tsMounted);

  TTibiaSelfStatus = set of TTibiaStatus;

  TTibiaSlot = (SlotFirst = 1, SlotHead = SlotFirst, SlotAmulet, SlotBackpack, SlotArmor, SlotRight, SlotLeft, SlotLegs,
    SlotBoots, SlotRing, SlotAmmo, SlotPurseMarket, SlotPurseInbox, SlotLastClicked, SlotLast = SlotAmmo);

const
  ItemID_Unknown = 90;
  ItemID_Creature = 99;
  ItemID_FishingRod = 3483;
  ItemID_Rope = 3003;
  ItemID_ElvenhairRope = 646;
  ItemID_BlueWhackingDrillerofFate = 9598;
  ItemID_PinkSqueezingGearofGirlpower = 9596;
  ItemID_RedSneakyStabberofEliteness = 9594;
  ItemID_MagicWall = 3180;
  ItemID_WildGrowth = 3156;
  ItemID_Shovel = 3457;
  ItemID_LightShovel = 5710;
  ItemID_WaterElementalCorpse = 9582;
  ItemID_Worm = 3492;
  ItemID_SmallHealthPotion = 7876;
  ItemID_HealthPotion = 266;
  ItemID_StrongHealthPotion = 236;
  ItemID_GreatHealthPotion = 239;
  ItemID_UltimateHealthPotion = 7643;
  ItemID_GreatSpiritPotion = 7642;
  ItemID_SupremeHealthPotion = 23375;
  ItemID_UltimateSpiritPotion = 23374;
  ItemID_UltimateManaPotion = 23373;
  ItemID_IntenseHealingRune = 3152;
  ItemID_UltimateHealingRune = 3160;
  ItemID_ManaPotion = 268;
  ItemID_StrongManaPotion = 237;
  ItemID_GreatManaPotion = 238;
  ItemID_Locker = 3502;
  ItemID_SoftBootsEmpty = 6530;
  ItemID_SoftBoots = 6529;
  ItemID_ObsidianKnife = 5908;
  ItemID_BlessedWoodenStake = 5942;
  ItemID_RustRemover = 9016;
  ItemID_NonStackableTile1 = 10145;
  ItemID_NonStackableTile2 = 10146;
  ItemID_Water1From = 4597;
  ItemID_Water1To = 4602;
  ItemID_Water2From = 4609;
  ItemID_Water2To = 4614;
  ItemID_GoldCoin = 3031;
  ItemID_PlatinumCoin = 3035;
  ItemID_CrystalCoin = 3043;
  ItemID_PotionFlaskSmall = 285;
  ItemID_PotionFlaskMedium = 283;
  ItemID_PotionFlaskLarge = 284;
  ItemID_BlankRune = 3147;
  ItemID_Spear = 3277;
  ItemID_StalagmiteRune = 3179;
  ItemID_ThunderstormRune = 3202;
  ItemID_StoneShowerRune = 3175;
  ItemID_AvalancheRune = 3161;
  ItemID_IcicleRune = 3158;
  ItemID_SuddenDeathRune = 3155;
  ItemID_ExplosionRune = 3200;
  ItemID_HeavyMagicMissileRune = 3198;
  ItemID_LightMagicMissileRune = 3174;
  ItemID_EnergyWallRune = 3166;
  ItemID_EnergyBombRune = 3149;
  ItemID_GreatFireballRune = 3191;
  ItemID_FireballRune = 3189;
  ItemID_SoulfireRune = 3195;
  ItemID_FireWallRune = 3190;
  ItemID_FireBombRune = 3192;
  ItemID_FireFieldRune = 3188;
  ItemID_PoisonWallRune = 3176;
  ItemID_PoisonBombRune = 3173;
  ItemID_PoisonFieldRune = 3172;
  ItemID_HolyMissileRune = 3182;
  ItemID_ParalyzeRune = 3165;

  RustRemoverItems: array [0 .. 14] of BInt32 = (8894, // Armors
    8895, 8896, 8897, // Legs
    8898, 8899, 8900, // Shields
    8901, 8902, 8903, // Boots
    8904, 8905, 8906, // Helmets
    8907, 8908);
  MagicWallField: array [0 .. 2] of BInt32 = (2128, 2129, 10181);
  WildGrowthField: array [0 .. 1] of BInt32 = (2130, 10182);

type
  TTibiaOutfit850 = record
    Outfit: BInt32;
    HeadColor: BInt32;
    BodyColor: BInt32;
    LegsColor: BInt32;
    FeetColor: BInt32;
    Addons: BInt32;
  end;

  TTibiaOutfit870 = record
    Outfit: BInt32;
    HeadColor: BInt32;
    BodyColor: BInt32;
    LegsColor: BInt32;
    FeetColor: BInt32;
    Addons: BInt32;
    Mount: BInt32;
  end;

  TTibiaOutfit = TTibiaOutfit870;

  TTibiaLight = record
    Intensity: BInt32;
    Color: BInt32;
  end;

  TTibiaAcc = record
    Password: BStr;
    Account: BStr;
  end;

  TTibiaSkull = (SkullFirst = 0, SkullNone = SkullFirst, SkullYellow = 1, SkullGreen = 2, SkullWhite = 3, SkullRed = 4,
    SkullBlack = 5, SkullOrange = 6, SkullLast = SkullOrange);

  TTibiaCreatureKind = (CreaturePlayer = 0, CreatureMonster = 1, CreatureNPC = 2);
  TTibiaNPCKind = (NPCNone = 0, NPCTalk = 1, NPCTrade = 2, NPCQuest = 3);

  TTibiaPartyIDs = (PartyIDFirst = 0, PartyIDNone = PartyIDFirst, // 0
    PartyIDInviting, // 1
    PartyIDInvited, // 2
    PartyIDMember, // 3
    PartyIDLeader, // 4
    PartyIDMemberShared, // 5
    PartyIDLeaderShared, // 6
    PartyIDMemberCantShare, // 7
    PartyIDLeaderCantShare, // 8
    PartyIDMemberNoShared, // 9
    PartyIDLeaderNoShared, // 10
    PartyIDOtherParty, // 11
    PartyIDLast = PartyIDOtherParty);

  TTibiaPartyPlayerClass = (PartyNone, PartyInvited, PartyMember, PartyLeader, PartyInviting, PartyOther);

  TTibiaParty = record
    Player: TTibiaPartyPlayerClass;
    Shared: boolean;
    SharedDisabled: boolean;
    ID: TTibiaPartyIDs;
    procedure Load(AID: BInt32);
  end;

  TTibiaWar = (WarNone = 0, WarEnemy, WarFriend, WarUnInvolved);

  TTibiaDirection = (tdNorth = 0, tdEast = 1, tdSouth = 2, tdWest = 3, tdNorthEast = 4, tdSouthEast = 5,
    tdSouthWest = 6, tdNorthWest = 7, tdCenter = 8);

  TTibiaItemDatFlag = (idfPickupable, // 1
    idfStackable, // 2
    idfHasExtra, // 4
    idfContainer, // 8
    idfNotMoveable, // 16
    idfNotWalkable, // 32
    idfBlockMissile, // 64
    idfGround, // 128
    idfAnimating, // 256
    idfDat512, idfDat1024, // 1024
    idfPad1, idfPad2, idfPad3, idfPad4, idfPad5, idfDatLast);

  TTibiaItemBotFlag = (idfRing, idfDepot, idfFood, idfCausesHostileExhaust, idfCausesDefensiveExhaust,
    idfCausesPotionExhaust, idfChangeLevelRope, idfChangeLevelShovel, idfChangeLevelLadder, idfChangeLevelUP,
    idfChangeLevelDown, idfChangeLevelHole, idfChangeLevel, idfTeleport, idfBotLast);
  TTibiaItemWalkable = (iwWalkable, iwAvoid, iwNotWalkable);

  TTibiaItemDatFlags = set of TTibiaItemDatFlag;
  TTibiaItemBotFlags = set of TTibiaItemBotFlag;
  PTibiaItemData = ^TTibiaItemData;

  TBBotLootData = record
    Target: BInt32;
    Looted: BInt32;
    MinCap: BInt32;
    Dropable: BBool;
    Depositable: BBool;
  end;

  TTibiaItemData = record
    Name: BStr;
    Weight: BInt32;
    SellValue: BInt32;
    BuyPrice: BInt32;
    RingID: BInt32;

    Loot: TBBotLootData;

    Walkable: TTibiaItemWalkable;
    DatFlags: TTibiaItemDatFlags;
    BotFlags: TTibiaItemBotFlags;
  end;

  TBufferItem = record
    ID: BUInt32;
    Count: BInt32;
  end;

  TTibiaItemBuffer850 = record
    ID: BUInt32;
    Count: BInt32;
    Amount: BInt32;
  end;

  TTibiaItemBuffer942 = record
    Amount: BInt32;
    Count: BInt32;
    ID: BUInt32;
  end;

  TTibiaColorRGBA = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
  end;

  TTibiaItemBuffer990 = record
    Amount: BInt32;
    Count: BInt32;
    ID: BUInt32;
    Color: TTibiaColorRGBA;
  end;

  TTibiaColorRGBA1021 = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
    Data1: BInt32;
    Data2: BInt32;
  end;

  TTibiaItemBuffer1021 = record
    Amount: BInt32;
    Count: BInt32;
    ID: BUInt32;
    Color: TTibiaColorRGBA1021;
  end;

  TTibiaColorRGBA1050 = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
    Data1: BInt32;
  end;

  TTibiaItemBuffer1050 = record
    Amount: BInt32;
    Count: BInt32;
    ID: BUInt32;
    Color: TTibiaColorRGBA1050;
  end;

const
  TibiaGMOutfits: array [1 .. 3] of BInt32 = (75, 266, 302);
  TibiaFPSMinTime: BDbl = 1000 / 65536;
  TibiaFPSMaxTime: BDbl = 1000 / 10;
  TibiaFPSDisabled: BDbl = 1000 / 4;

function IsPlayerID(ID: BUInt32): BBool;

function PosAddDir(const APos: BPos; const ADir: TTibiaDirection): BPos;

type
  TBBotLogin = record
    Version: BStr;
  end;

var
  BBotLogin: TBBotLogin;

function TibiaInScreen(CenterX, CenterY, CenterZ, X, Y, Z: BInt32; ExtendedRange: BBool): BBool; overload;
function TibiaInScreen(ACenter, APosition: BPos; ExtendedRange: BBool): BBool; overload;
function BBotLoginURL: BStr;
function SlotToStr(const ASlot: TTibiaSlot): BStr;
function StrToSlot(const ASlot: BStr): TTibiaSlot;
function SkillToStr(const ASkill: TTibiaSkill): BStr;
function Fletcher16(AData: BPInt8; ASize: BInt32): BUInt16;

implementation

uses
  Declaracoes,
  Math,

  SysUtils,
  uBBotSpells,

  uBBotAddresses,

  TlHelp32,
  Dialogs,

  ucLogin;

function BBotLoginURL: BStr;
begin
  Result := BBotApiUrl('login');
end;

function Fletcher16(AData: BPInt8; ASize: BInt32): BUInt16;
var
  sum1, sum2: BUInt16;
  I: BInt32;
  C: BPInt8;
begin
  sum1 := 0;
  sum2 := 0;
  C := AData;
  for I := 0 to ASize - 1 do begin
    sum1 := (sum1 + C^) mod 255;
    sum2 := (sum1 + sum2) mod 255;
    Inc(C);
  end;
  Result := (sum2 shl 8) or sum1;
end;

function IsPlayerID(ID: BUInt32): BBool;
begin
  Result := ID < $40000000;
end;

function SkillToStr(const ASkill: TTibiaSkill): BStr;
begin
  case ASkill of
  SkillFist: Exit('Fist');
  SkillClub: Exit('Club');
  SkillSword: Exit('Sword');
  SkillAxe: Exit('Axe');
  SkillDistance: Exit('Distance');
  SkillShielding: Exit('Shielding');
  SkillFishing: Exit('Fishing');
  SkillMagic: Exit('Magic');
else Exit('???');
  end;
end;

function BBotLoginRad: BStr;
begin
  Result := '';
  while Length(Result) < 32 do
    Result := Result + BStrRandom(8, BStrAlphaNumeric);
end;

function TibiaInScreen(CenterX, CenterY, CenterZ, X, Y, Z: BInt32; ExtendedRange: BBool): BBool;
var
  DX, DY: BInt32;
begin
  DX := BAbs(CenterX - X);
  DY := BAbs(CenterY - Y);
  if ExtendedRange then
    Result := (CenterZ = Z) and (DX < 9) and (DY < 7)
  else
    Result := (CenterZ = Z) and (DX < 8) and (DY < 6);
end;

function TibiaInScreen(ACenter, APosition: BPos; ExtendedRange: BBool): BBool;
begin
  Result := TibiaInScreen(ACenter.X, ACenter.Y, ACenter.Z, APosition.X, APosition.Y, APosition.Z, ExtendedRange);
end;

function BBotLoginAdd(Key, Value: BStr): BStr;
begin
  Result := '&' + Key + '=' + UrlEncode(Value, True);
end;

function SlotToStr(const ASlot: TTibiaSlot): BStr;
begin
  case ASlot of
  SlotHead: Exit('Head');
  SlotAmulet: Exit('Amulet');
  SlotBackpack: Exit('Backpack');
  SlotArmor: Exit('Armor');
  SlotRight: Exit('Right');
  SlotLeft: Exit('Left');
  SlotLegs: Exit('Legs');
  SlotBoots: Exit('Boots');
  SlotRing: Exit('Ring');
  SlotAmmo: Exit('Ammo');
  SlotLastClicked: Exit('LastClicked');
else Exit('??');
  end;
end;

function StrToSlot(const ASlot: BStr): TTibiaSlot;
begin
  if BStrEqual(ASlot, 'Helmet') or BStrEqual(ASlot, 'Head') then
    Exit(SlotHead)
  else if BStrEqual(ASlot, 'Amulet') then
    Exit(SlotAmulet)
  else if BStrEqual(ASlot, 'Backpack') then
    Exit(SlotBackpack)
  else if BStrEqual(ASlot, 'Armor') then
    Exit(SlotArmor)
  else if BStrEqual(ASlot, 'RightHand') or BStrEqual(ASlot, 'Right') then
    Exit(SlotRight)
  else if BStrEqual(ASlot, 'LeftHand') or BStrEqual(ASlot, 'Left') then
    Exit(SlotLeft)
  else if BStrEqual(ASlot, 'Legs') then
    Exit(SlotLegs)
  else if BStrEqual(ASlot, 'Boots') then
    Exit(SlotBoots)
  else if BStrEqual(ASlot, 'Ring') then
    Exit(SlotRing)
  else if BStrEqual(ASlot, 'Ammunition') or BStrEqual(ASlot, 'Ammo') then
    Exit(SlotAmmo)
  else
    Exit(SlotLastClicked);
end;

function PosAddDir(const APos: BPos; const ADir: TTibiaDirection): BPos;
begin
  Result := APos;
  case ADir of
  tdNorth: Result.Y := Result.Y - 1;
  tdEast: Result.X := Result.X + 1;
  tdSouth: Result.Y := Result.Y + 1;
  tdWest: Result.X := Result.X - 1;
  tdNorthEast: begin
      Result.Y := Result.Y - 1;
      Result.X := Result.X + 1
    end;
  tdSouthEast: begin
      Result.Y := Result.Y + 1;
      Result.X := Result.X + 1
    end;
  tdSouthWest: begin
      Result.Y := Result.Y + 1;
      Result.X := Result.X - 1;
    end;
  tdNorthWest: begin
      Result.Y := Result.Y - 1;
      Result.X := Result.X - 1;
    end;
  tdCenter:;
  end;

end;

{ TTibiaParty }

procedure TTibiaParty.Load(AID: Integer);
begin
  ID := PartyIDNone;
  Player := PartyNone;
  Shared := False;
  SharedDisabled := False;
  if BInRange(AID, Ord(PartyIDFirst), Ord(PartyIDLast)) then begin
    ID := TTibiaPartyIDs(AID);
    case ID of
    PartyIDInviting: begin
        Player := PartyInviting;
      end;
    PartyIDInvited: begin
        Player := PartyInvited;
      end;
    PartyIDMember: begin
        Player := PartyMember;
      end;
    PartyIDLeader: begin
        Player := PartyLeader;
      end;
    PartyIDMemberShared: begin
        Player := PartyMember;
        Shared := True;
        SharedDisabled := False;
      end;
    PartyIDLeaderShared: begin
        Player := PartyLeader;
        Shared := True;
        SharedDisabled := False;
      end;
    PartyIDMemberCantShare: begin
        Player := PartyMember;
        SharedDisabled := True;
      end;
    PartyIDLeaderCantShare: begin
        Player := PartyLeader;
        SharedDisabled := True;
      end;
    PartyIDMemberNoShared: begin
        Player := PartyMember;
      end;
    PartyIDLeaderNoShared: begin
        Player := PartyLeader;
      end;
    PartyIDOtherParty: begin
        Player := PartyOther;
      end;
    end;
  end;
end;

end.

