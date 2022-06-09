unit uSettings;

interface

uses
  uBTypes,
  Declaracoes,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  Spin,
  SysUtils,
  ExtCtrls,
  ComCtrls,
  uBVector,
  Generics.Collections;

type
  TSettingsManager = class
  private type
    TSettingsRegister = record
      ComponentPath: BStr;
      Name: BStr;
      TagID: BInt32;
      DefaultValue: BStr;
      Component: TComponent;
      Migrator: BUnaryFunc<BStr, BStr>;
    end;
  private
    Settings: BVector<TSettingsRegister>;
    ComponentMapByPath: TObjectDictionary<BStr, TComponent>;
    Form: TForm;
    procedure ResetForm;
    function FindSettings(const AKey: BStr): BVector<TSettingsRegister>.It;
    function ReadKeyAndValue(const ALines: BStrArray; var ALine: BInt32; out AKey, AValue: BStr): BBool;
    function ValueOfObj(const Obj: TComponent): BStr;
    procedure ValueToObj(const Obj: TComponent; const Value: BStr);
    function GenerateMultilineID(const AValue: BStr): BStr;
    function calculateComponentPath(const AComponent: TComponent): BStr;
    function ToBuffer(const ASetting: TSettingsRegister): BStr;
    procedure MapComponents;
  protected
    procedure Configure(const AName, AComponentPath: BStr; const ATagID: BInt32); overload;
    procedure Configure(const AName, AComponentPath: BStr); overload;
    procedure Configure(const AName, AComponentPath: BStr; const ATagID: BInt32;
      const AMigrator: BUnaryFunc<BStr, BStr>); overload;
    procedure Configure(const AName, AComponentPath: BStr; const AMigrator: BUnaryFunc<BStr, BStr>); overload;
    procedure Configure; overload; virtual; abstract;
  public
    constructor Create(const AForm: TForm);
    destructor Destroy; override;

    function SaveToString: BStr; overload;
    procedure SaveToFile(const AFileName: BStr);

    procedure LoadFromString(const AData: BStr);
    procedure LoadFromFile(const AFileName: BStr);
  end;

  TBBotSettingsManager = class(TSettingsManager)
  protected
    function MigrateManaDrinkerUse(AValue: BStr): BStr;
    function MigrateHealerUse(AValue: BStr): BStr;
  protected
    procedure Configure; override;
  end;

implementation

uses

  Math,
  uBBotItemSelector,
  uTibiaDeclarations;

{ TBBotSettingsManager }

function TBBotSettingsManager.MigrateHealerUse(AValue: BStr): BStr;
var
  ID: BInt32;
begin
  if TBBotItemSelector.GetInstance.HasPrefix(AValue) then
    Exit(AValue);
  ID := BStrTo32(AValue, 0);
  case ID of
  0: ID := ItemID_SmallHealthPotion;
  1: ID := ItemID_HealthPotion;
  2: ID := ItemID_StrongHealthPotion;
  3: ID := ItemID_GreatHealthPotion;
  4: ID := ItemID_GreatSpiritPotion;
  5: ID := ItemID_UltimateSpiritPotion;
  6: ID := ItemID_UltimateHealthPotion;
  7: ID := ItemID_SupremeHealthPotion;
  8: ID := ItemID_IntenseHealingRune;
  9: ID := ItemID_UltimateHealingRune;
  end;
  Exit(TBBotItemSelector.GetInstance.FormatID(ID));
end;

function TBBotSettingsManager.MigrateManaDrinkerUse(AValue: BStr): BStr;
var
  ID: BInt32;
begin
  if TBBotItemSelector.GetInstance.HasPrefix(AValue) then
    Exit(AValue);
  ID := BStrTo32(AValue, 0);
  case ID of
  0: ID := ItemID_ManaPotion;
  1: ID := ItemID_StrongManaPotion;
  2: ID := ItemID_GreatManaPotion;
  3: ID := ItemID_UltimateManaPotion;
  4: ID := ItemID_GreatSpiritPotion;
  5: ID := ItemID_UltimateSpiritPotion;
else ID := ItemID_ManaPotion;
  end;
  Exit(TBBotItemSelector.GetInstance.FormatID(ID));
end;

procedure TBBotSettingsManager.Configure;

begin
  Configure('AdvancedAttack', 'AdvancedAttackFrame.AdvancedAttackList', -95160893);
  Configure('AttackSequences', 'AttackSequencesFrame.lstAttackSequences', -1122281310);

  Configure('BasicFeatures.AntiAfkKick', 'gbBasic.chkAntiIDLE', 619348825);
  Configure('BasicFeatures.AutoDropVials', 'gbBasic.chkAutoDropVials', 1338316384);
  Configure('BasicFeatures.AutoEat', 'gbBasic.chkEat', -1764060782);
  Configure('BasicFeatures.AutoEatFromGround', 'gbBasic.chkEatFoodGround', 1957225461);
  Configure('BasicFeatures.AutoMinimizeBPs.Enable', 'gbBasic.chkAutoMinimizeBP', -355221358);
  Configure('BasicFeatures.AutoMinimizeBPs.GetPremiumIsMinimized', 'gbBasic.chkAutoMinimizeBPsMinimizedGetPremium',
    -1147830791);
  Configure('BasicFeatures.AutoMinimizeBPs.InventoryIsMinimized', 'gbBasic.chkAutoMinimizeBPsInventory', -1703923302);
  Configure('BasicFeatures.AutoOpenBackpacks', 'gbBasic.chkAutoOpenBP', -1871498906);
  Configure('BasicFeatures.AutoScreenshot', 'gbBasic.chkSS', 125237353);
  Configure('BasicFeatures.AutoStackItems', 'gbBasic.chkGroup', -298989921);
  Configure('BasicFeatures.Fishing.Enable', 'gbBasic.chkFishing', 2005154173);
  Configure('BasicFeatures.Fishing.MinCapacity', 'gbBasic.numFisherCap', -2113390);
  Configure('BasicFeatures.Fishing.NeedWorms', 'gbBasic.chkFishingWorm', 406495769);
  Configure('BasicFeatures.FramerateLimiter', 'gbBasic.chkFrameRate', 1237464721);
  Configure('BasicFeatures.LevelSpy', 'gbBasic.chkLevelSpy', -406232583);
  Configure('BasicFeatures.LightHack', 'gbBasic.cmbLightHack', -1015213525);
  Configure('BasicFeatures.MapClick', 'gbBasic.chkMapClick', -60937135);
  Configure('BasicFeatures.OTMoney', 'gbBasic.chkOtMoney', -1037655656);
  Configure('BasicFeatures.ServerSave.Hour', 'gbBasic.numSSLogoutHH', -2002709616);
  Configure('BasicFeatures.ServerSave.Logout.Enable', 'gbBasic.chkServerSaveLogout', 1082169595);
  Configure('BasicFeatures.ServerSave.Minute', 'gbBasic.numSSLogoutMM', -2051271846);
  Configure('BasicFeatures.Tray', 'gbBasic.chkTray', -163698010);
  Configure('BasicFeatures.LightHack', 'gbBasic.cmbLightHack');
  Configure('BasicFeatures.OTMoney', 'gbBasic.chkOtMoney');
  Configure('BasicFeatures.LevelSpy', 'gbBasic.chkLevelSpy');
  Configure('BasicFeatures.MapClick', 'gbBasic.chkMapClick');

  Configure('Cavebot.DepotCity', 'CavebotFrame.DepotCity', -1363106455);
  Configure('Cavebot.Enable', 'CavebotFrame.chkCBa', 1092845226);
  Configure('Cavebot.Learn', 'CavebotFrame.chkCBLearn', 141861092);
  Configure('Cavebot.RopeItem', 'CavebotFrame.cmbCBrope', 160181767);
  Configure('Cavebot.ShovelItem', 'CavebotFrame.cmbCBshovel', -1602259648);
  Configure('Cavebot.WalkFields', 'CavebotFrame.cmbWalkFields', -606988625);
  Configure('Cavebot.WalkFurnitures', 'CavebotFrame.cmbWalkFurnitures', -803897836);
  Configure('Cavebot.WalkPlayers', 'CavebotFrame.cmbWalkPlayers', 1373843125);
  Configure('Cavebot.Waypoint', 'CavebotFrame.lstCBWPT', 1534554678);
  Configure('Cavebot.WithdrawRounding', 'CavebotFrame.CavebotWithdrawRounding', -1472190810);
  Configure('Cavebot.SmartMapClick', 'CavebotFrame.SmartMapClick');

  Configure('Enchanter.BlankRunes', 'gbEnchanter.rbEnchanterUseBlank', -1537719137);
  Configure('Enchanter.Enable', 'gbEnchanter.chkEnchanter', 429099071);
  Configure('Enchanter.Hand', 'gbEnchanter.cmbEnchanterHand', 1118609584);
  Configure('Enchanter.Mana', 'gbEnchanter.numEnchanterMana', -785579670);
  Configure('Enchanter.Soul', 'gbEnchanter.numEnchanterSoul', -1124942869);
  Configure('Enchanter.Spears', 'gbEnchanter.rbEnchanterUseSpear', 132976217);
  Configure('Enchanter.Spell', 'gbEnchanter.txtEnchanterSpell', 2031848668);

  Configure('FriendHealer.Enable', 'FriendHealerFrame.chkFHactive', -1208351215);
  Configure('FriendHealer.Items', 'FriendHealerFrame.lstFH', -1466665837);

  Configure('HUD.Advancements', 'gbHUD.chkAdvanced', -169181558);
  Configure('HUD.AmmoCounter', 'gbBasic.chkAmmoCounter', -112753578);
  Configure('HUD.AutoShowStatistics', 'gbHUD.chkAutoStatistics', 669916350);
  Configure('HUD.CreatureLevels', 'gbHUD.chkCLevels', 206409546);
  Configure('HUD.ExpGainInformations', 'gbHUD.chkGotInfo', 1850331424);
  Configure('HUD.ExpInformations', 'gbHUD.chkExp', 179829907);
  Configure('HUD.LootHUD', 'gbHUD.chkLootHUD', 489202967);
  Configure('HUD.MagicWalls', 'gbHUD.chkHUDmwalls', 1772076417);
  Configure('HUD.PlayerGroupCount', 'gbHUD.chkPlayerGroups', -1533907597);
  Configure('HUD.Spells', 'gbHUD.chkHUDspells', 1828820269);
  Configure('HUD.XRay', 'gbBasic.chkXRay', -2069507074);

  Configure('Healer.Variation', 'HealerFrame.numHealerVariation', 2023393580);
  Configure('Healer.SpellPriority', 'HealerFrame.rbHps', -1970861777);
  Configure('Healer.ItemPriority', 'HealerFrame.rbHpi', 2011557973);
  Configure('Healer.Item.Exhaust', 'HealerFrame.numHealerItemsEx', -1097237890);
  Configure('Healer.Spell.Exhaust', 'HealerFrame.numHealerSpellsEx', -1879209382);

  Configure('Helaer.Item.High.Enable', 'HealerFrame.chkHealerItemHigh', -261822026);
  Configure('Healer.Item.High.HP', 'HealerFrame.numHealerItemHighHP', 1972732859);
  Configure('Healer.Item.High.Item', 'HealerFrame.cmbHealerItemHigh', -61922353, MigrateHealerUse);
  Configure('Healer.Item.High.Percent', 'HealerFrame.chkHealerItemHighPercent', -1419931359);

  Configure('Helaer.Item.Mid.Enable', 'HealerFrame.chkHealerItemMid');
  Configure('Healer.Item.Mid.HP', 'HealerFrame.numHealerItemMidHP');
  Configure('Healer.Item.Mid.Item', 'HealerFrame.cmbHealerItemMid');
  Configure('Healer.Item.Mid.Percent', 'HealerFrame.chkHealerItemMidPercent');

  Configure('Healer.Item.Low.Enable', 'HealerFrame.chkHealerItemLow', 664726982);
  Configure('Healer.Item.Low.HP', 'HealerFrame.numHealerItemLowHP', -1257914102);
  Configure('Healer.Item.Low.Item', 'HealerFrame.cmbHealerItemLow', -1169183731, MigrateHealerUse);
  Configure('Healer.Item.Low.Percent', 'HealerFrame.chkHealerItemLowPercent', 1705233088);

  Configure('Healer.Spell.Low.Enable', 'HealerFrame.chkHealerSpellLow', -2143817111);
  Configure('Healer.Spell.Low.HP', 'HealerFrame.numHealerSpellLowHP', -112139308);
  Configure('Healer.Spell.Low.Mana', 'HealerFrame.numHealerSpellLowMana', 267068155);
  Configure('Healer.Spell.Low.Percent', 'HealerFrame.chkHealerSpellLowPercent', -1958017710);
  Configure('Healer.Spell.Low.Spell', 'HealerFrame.edtHealerSpellLowSpell', -1399506541);

  Configure('Healer.Spell.Mid.Enable', 'HealerFrame.chkHealerSpellMid', 1393655302);
  Configure('Healer.Spell.Mid.HP', 'HealerFrame.numHealerSpellMidHP', -12875631);
  Configure('Healer.Spell.Mid.Mana', 'HealerFrame.numHealerSpellMidMana', 1485121280);
  Configure('Healer.Spell.Mid.Percent', 'HealerFrame.chkHealerSpellmidPercent', -1426447618);
  Configure('Healer.Spell.Mid.Spell', 'HealerFrame.edtHealerSpellMidSpell', -2035450878);

  Configure('Healer.Spell.High.Enable', 'HealerFrame.chkHealerSpellHigh', -1230307632);
  Configure('Healer.Spell.High.HP', 'HealerFrame.numHealerSpellHighHP', 347220298);
  Configure('Healer.Spell.High.Mana', 'HealerFrame.numHealerSpellHighMana', -1684520157);
  Configure('Healer.Spell.High.Percent', 'HealerFrame.chkHealerSpellHighPercent', -1246590074);
  Configure('Healer.Spell.High.Spell', 'HealerFrame.edtHealerSpellHighSpell', 1362722921);

  Configure('Killer.Enable', 'KillerFrame.chkKillerAttackAll', 1398085848);
  Configure('Killer.AllowAttackPlayers', 'KillerFrame.chkKillerAllowAttackPlayers', 1979633655);
  Configure('Killer.AvoidKillSteal', 'KillerFrame.chkAvoidKS', -1668276902);
  Configure('Killer.Targets', 'KillerFrame.lstKillerTargets', 20504739);
  Configure('Killer.AvoidRampAOE', 'KillerFrame.AvoidAOERamps');
  Configure('Killer.AttackNotReachable', 'KillerFrame.AttackNotReachable');

  Configure('Looter.Looter.Eat', 'LooterGroup.chkLEat', 1007082110);
  Configure('Looter.Looter.Enable', 'LooterGroup.chkLLooter', 646299023);
  Configure('Looter.Looter.Items', 'FMain.mmLooter', 1414208239);
  Configure('Looter.Looter.RusyRemover', 'LooterGroup.chkRustyRemover', 1099918957);

  Configure('Looter.OpenCorpses.Enable', 'LooterGroup.chkLOpen', 1007361165);
  Configure('Looter.OpenCorpses.IgnoreCreatures', 'IgnoreCorpsesGroup.OpenCorpsesIgnoreCreatures', -1672199181);
  Configure('Looter.OpenCorpses.Priority', 'LooterGroup.cmbLooterPrio', 900540678);

  Configure('Looter.RareItems.Enable', 'LooterGroup.chkLooterRare', 734631861);
  Configure('Looter.RareItems.Words', 'LooterGroup.edtLooterRare', -1289210396);

  Configure('Looter.Skinner.Enable', 'LooterGroup.SkinCorpses', 514288097);
  Configure('Looter.Skinner.List', 'SkinnerGroup.SkinnerList', 954618640);

  Configure('Macros.AutoEnable', 'MacrosFrame.chkMacroAutos', 1394395405);
  Configure('Macros.Items', 'MacrosFrame.lstMacros', -1028332407);

  Configure('ManaTools.ManaDrinker.Variation', 'ManaToolsFrame.ManaDrinkerVariation', 1005948850);

  Configure('ManaTools.ManaDrinker.High.Enable', 'ManaToolsFrame.ManaDrinkerHigh', -476018121);
  Configure('ManaTools.ManaDrinker.High.PauseCavebot', 'ManaToolsFrame.ManaDrinkerHighCavebot');
  Configure('ManaTools.ManaDrinker.High.FromMana', 'ManaToolsFrame.ManaDrinkerHighFrom', 775323703);
  Configure('ManaTools.ManaDrinker.High.Percent', 'ManaToolsFrame.ManaDrinkerHighPercent', 1432730617);
  Configure('ManaTools.ManaDrinker.High.ToMana', 'ManaToolsFrame.ManaDrinkerHighTo', -1632580301);
  Configure('ManaTools.ManaDrinker.High.UseItem', 'ManaToolsFrame.ManaDrinkerHighUse', 1696822118,
    MigrateManaDrinkerUse);

  Configure('ManaTools.ManaDrinker.Mid.Enable', 'ManaToolsFrame.ManaDrinkerMid');
  Configure('ManaTools.ManaDrinker.Mid.PauseCavebot', 'ManaToolsFrame.ManaDrinkerMidCavebot');
  Configure('ManaTools.ManaDrinker.Mid.FromMana', 'ManaToolsFrame.ManaDrinkerMidFrom');
  Configure('ManaTools.ManaDrinker.Mid.Percent', 'ManaToolsFrame.ManaDrinkerMidPercent');
  Configure('ManaTools.ManaDrinker.Mid.ToMana', 'ManaToolsFrame.ManaDrinkerMidTo');
  Configure('ManaTools.ManaDrinker.Mid.UseItem', 'ManaToolsFrame.ManaDrinkerMidUse');

  Configure('ManaTools.ManaDrinker.Low.Enable', 'ManaToolsFrame.ManaDrinkerLow', -1889191202);
  Configure('ManaTools.ManaDrinker.Low.PauseCavebot', 'ManaToolsFrame.ManaDrinkerLowCavebot');
  Configure('ManaTools.ManaDrinker.Low.FromMana', 'ManaToolsFrame.ManaDrinkerLowFrom', -1298759955);
  Configure('ManaTools.ManaDrinker.Low.Percent', 'ManaToolsFrame.ManaDrinkerLowPercent', -1986894760);
  Configure('ManaTools.ManaDrinker.Low.ToMana', 'ManaToolsFrame.ManaDrinkerLowTo', -630367521);
  Configure('ManaTools.ManaDrinker.Low.UseItem', 'ManaToolsFrame.ManaDrinkerLowUse', -858062686, MigrateManaDrinkerUse);

  Configure('ManaTools.ManaTrainer.Enable', 'ManaToolsFrame.ManaTrainerEnable', -382233413);
  Configure('ManaTools.ManaTrainer.FromMana', 'ManaToolsFrame.ManaTrainerFrom', -429092993);
  Configure('ManaTools.ManaTrainer.Percent', 'ManaToolsFrame.ManaTrainerPercent', 667599724);
  Configure('ManaTools.ManaTrainer.Spell', 'ManaToolsFrame.ManaTrainerSpell', -1830991425);
  Configure('ManaTools.ManaTrainer.ToMana', 'ManaToolsFrame.ManaTrainerTo', -931853780);
  Configure('ManaTools.ManaTrainer.Variation', 'ManaToolsFrame.ManaTrainerVariation', 190570066);

  Configure('Protector.Enable', 'gbProtector.chkProtectorsActive', -208522445);
  Configure('Protector.Items', 'gbProtector.lstProtectors', 179513780);

  Configure('ReUser.Ammo', 'gbReUserCures.chkRUammo', -1875945983);
  Configure('ReUser.Amulet', 'gbReUserCures.chkRUamulet', 1125826113);
  Configure('ReUser.BloodRage', 'gbReUserCures.chkRUbloodrage', 1814337);
  Configure('ReUser.Charge', 'gbReUserCures.chkRUcharge', 1467456760);
  Configure('ReUSer.CureParalyzeSpell', 'gbReUserCures.edtCureParalyzeSpell', -1521597971);
  Configure('ReUser.CureBleeding', 'gbReUserCures.chkCureBleeding', -594381189);
  Configure('ReUser.CureBurning', 'gbReUserCures.chkCureBurning', 1529255609);
  Configure('ReUser.CureCurse', 'gbReUserCures.chkCureCurse', -1850689484);
  Configure('ReUser.CureEletrification', 'gbReUserCures.chkCureEletrification', -428543296);
  Configure('ReUser.CureParalyze', 'gbReUserCures.chkCureParalyze', 1908050152);
  Configure('ReUser.CurePatalyzeMana', 'gbReUserCures.numCureParalyzeMana', 1769121443);
  Configure('ReUser.CurePoison', 'gbReUserCures.chkCurePoison', 1506463568);
  Configure('ReUser.GreatLight', 'gbReUserCures.chkRUlight2', 997980962);
  Configure('ReUser.Haste', 'gbReUserCures.chkRUhaste', -1308159426);
  Configure('ReUser.StrongHaste', 'gbReUserCures.chkRUshaste', 881636806);
  Configure('ReUser.IntenseRecovery', 'gbReUserCures.chkRUintenserecovery', -230132051);
  Configure('ReUser.Invisible', 'gbReUserCures.chkRUinvis', -629723010);
  Configure('ReUser.LeftHand', 'gbReUserCures.chkRUleft', 96980803);
  Configure('ReUser.Light', 'gbReUserCures.chkRUlight1', -1569543528);
  Configure('ReUser.MagicShield', 'gbReUserCures.chkRUms', -1573420275);
  Configure('ReUser.Protector', 'gbReUserCures.chkRUprotector', 103769065);
  Configure('ReUser.Recovery', 'gbReUserCures.chkRUrecovery', -36199434);
  Configure('ReUser.RightHand', 'gbReUserCures.chkRUright', -905198607);
  Configure('ReUser.Ring', 'gbReUserCures.chkRUring', -260252323);
  Configure('ReUser.SharpShooter', 'gbReUserCures.chkRUsharpshooter', 1706903759);
  Configure('ReUser.SoftBoots', 'gbReUserCures.chkRUsoft', 2755932);
  Configure('ReUser.SwiftFoot', 'gbReUserCures.chkRUswiftfoot', -910008250);
  Configure('ReUser.UltimateLight', 'gbReUserCures.chkRUlight3', 1283247028);

  Configure('SimpleReconnect.Enable', 'gbBasic.chkReconnect', -1311713460);
  Configure('SpecialSQMs.HUDEnable', 'SpecialSQMsFrame.SpecialSQMsShow', 1991730000);
  Configure('SpecialSQMs.EditorHUDEnable', 'SpecialSQMsFrame.SpecialSQMsEditorHUD');
  Configure('SpecialSQMs.Items', 'SpecialSQMsFrame.lstSpecialSQMs', 1619415883);

  Configure('TradeHelper.Trader.AdsChannel', 'gbTradeHelper.chkTHmsg', -2131311321);
  Configure('TradeHelper.Trader.Say', 'gbTradeHelper.chkTHmsgsay', -589733456);
  Configure('TradeHelper.Trader.Text', 'gbTradeHelper.edtTHmsg', 1941509786);
  Configure('TradeHelper.Trader.Yell', 'gbTradeHelper.chkTHmsgyell', -793188046);
  Configure('TradeHelper.Watch.Enable', 'gbTradeHelper.chkTHwatch', -229451588);
  Configure('TradeHelper.Watch.Words', 'gbTradeHelper.edtTHwatch', -1125943192);

  Configure('Trainer.HPTraining', 'gbTrainer.chkHPTrain', 1879388017);
  Configure('Trainer.HPTrainingMaxHP', 'gbTrainer.TrainerHPMax', -198766944);
  Configure('Trainer.HPTrainingMinHP', 'gbTrainer.TrainerHPMin', -936758791);
  Configure('Trainer.SlimeTraining', 'gbTrainer.chkSlimeTrain', 547341831);

  Configure('Variables', 'VariablesFrame.VariablesEditor', 1399504867);

  Configure('War.AddNonPartyToEnemies', 'gbAlliesAndEnemies.chkEnemyNoAlly', 496199039);
  Configure('War.AddPartyToAllies', 'gbAlliesAndEnemies.chkAllyParty', 1010596051);
  Configure('War.AimBot.1', 'gbWarbot.cmbAim1', 149271798);
  Configure('War.AimBot.2', 'gbWarbot.cmbAim2', -1846745780);
  Configure('War.AimBot.3', 'gbWarbot.cmbAim3', -420751910);
  Configure('War.AimBot.Enable', 'gbWarbot.chkAim', 1029774214);
  Configure('War.Allies', 'gbAlliesAndEnemies.memoAllies', 2068547256);
  Configure('War.AlliesEnemiesHUD', 'gbAlliesAndEnemies.chkMarkAlliesAndenemies', -1455603792);
  Configure('War.AutoAttackEnemies', 'gbAlliesAndEnemies.chkAutoAttackEnemies', 606065714);
  Configure('War.AutoPushParalyzedEnemies', 'gbAlliesAndEnemies.chkPushParalyed', -1360263803);
  Configure('War.Combo.Enable', 'gbWarbot.chkWBCActive', 1774512222);
  Configure('War.Combo.Leaders', 'gbWarbot.edtLeaders', 1338379650);
  Configure('War.Combo.MagicWords', 'gbWarbot.chkComboSay', 12881581);
  Configure('War.Combo.ParalyzedEnemies', 'gbWarbot.chkWCBparalyzed', -1920983814);
  Configure('War.Combo.Sequence', 'gbWarbot.cmbCombo', 1206307967);
  Configure('War.Combo.SetTarget', 'gbWarbot.chkWBCattack', 1656110161);
  Configure('War.Enemies', 'gbAlliesAndEnemies.memoEnemies', 582642739);
  Configure('War.LockTarget', 'gbWarbot.chkLockTarget', -837148561);
  Configure('War.SuperFollow', 'gbWarbot.chkSuperFollow');
  Configure('War.MagicWallInFrontOfEnemies', 'gbWarbot.chkMWallFrontEnemies', -2064360622);
  Configure('War.NET.Actions', 'ActionsPanel.WarNetActions', -2008776221);
  Configure('War.NET.Combos', 'ActionsPanel.WarNetItemCombos', -94913303);
  Configure('War.Dash', 'gbWarbot.chkDash');
end;

{ TSettingsManager }

procedure TSettingsManager.Configure(const AName, AComponentPath: BStr; const ATagID: BInt32);
begin
  Configure(AName, AComponentPath, ATagID, nil);
end;

procedure TSettingsManager.Configure(const AName, AComponentPath: BStr);
begin
  Configure(AName, AComponentPath, MaxInt, nil);
end;

procedure TSettingsManager.Configure(const AName, AComponentPath: BStr; const ATagID: BInt32;
  const AMigrator: BUnaryFunc<BStr, BStr>);
var
  Setting: BVector<TSettingsRegister>.It;
begin
  Setting := Settings.Add;
  Setting^.Name := AName;
  Setting^.ComponentPath := AComponentPath;
  Setting^.TagID := ATagID;
  Setting^.Component := ComponentMapByPath.Items[AComponentPath];
  Setting^.DefaultValue := ValueOfObj(Setting^.Component);
  Setting^.Migrator := AMigrator;
end;

procedure TSettingsManager.Configure(const AName, AComponentPath: BStr; const AMigrator: BUnaryFunc<BStr, BStr>);
begin
  Configure(AName, AComponentPath, MaxInt, AMigrator);
end;

constructor TSettingsManager.Create(const AForm: TForm);

begin
  Form := AForm;
  Settings := BVector<TSettingsRegister>.Create;
  ComponentMapByPath := TObjectDictionary<BStr, TComponent>.Create([]);
  MapComponents;
  Configure;
end;

destructor TSettingsManager.Destroy;

begin
  ComponentMapByPath.Free;
  Settings.Free;
  inherited;
end;

function TSettingsManager.FindSettings(const AKey: BStr): BVector<TSettingsRegister>.It;
var
  TagID: BInt32;
begin
  TagID := BStrTo32(AKey, -1);
  Exit(Settings.Find('SettingsManager looking for ' + AKey,
    function(AIt: BVector<TSettingsRegister>.It): BBool
    begin
      Result := ((TagID <> -1) and (AIt^.TagID = TagID)) or (AIt^.Name = AKey);
    end));
end;

procedure TSettingsManager.LoadFromFile(const AFileName: BStr);

begin
  LoadFromString(BFileGet(AFileName));
end;

procedure TSettingsManager.LoadFromString(const AData: BStr);
var
  Lines: BStrArray;
  I: BInt32;
  Key, Value: BStr;
  Setting: BVector<TSettingsRegister>.It;
  PostponedApply: BVector<BPair<TComponent, BStr>>;
begin

  if (BStrSplit(Lines, BStrLine, AData) > 0) and (Lines[0] = 'BBOT') then begin
    ResetForm;
    PostponedApply := BVector < BPair < TComponent, BStr >>.Create;
    I := 1;
    while I <= High(Lines) do begin
      if ReadKeyAndValue(Lines, I, Key, Value) then begin
        Setting := FindSettings(Key);
        if Setting <> nil then begin
          if Setting^.Migrator <> nil then
            Value := Setting^.Migrator(Value);
          if Setting^.Component is TCheckbox then
            PostponedApply.Add^.reset(Setting^.Component, Value)
          else
            ValueToObj(Setting^.Component, Value);
        end;
      end;
      Inc(I);
    end;
    PostponedApply.ForEach(
      procedure(AIt: BVector < BPair < TComponent, BStr >>.It)
      begin
        ValueToObj(AIt^.First, AIt^.Second);
      end);
    PostponedApply.Free;
  end;
end;

procedure TSettingsManager.MapComponents;

begin
  IterateComponentControls(Form,
    procedure(Component: TComponent)
    var
      Path: BStr;
    begin
      if (Component is TWinControl) and (Component.Tag <> 0) then begin
        Path := calculateComponentPath(Component);
        ComponentMapByPath.Add(Path, Component);
      end;
    end);
end;

function TSettingsManager.ReadKeyAndValue(const ALines: BStrArray; var ALine: BInt32; out AKey, AValue: BStr): BBool;

var

  MultilineMark: BStr;

begin
  if BStrSplit(ALines[ALine], '=', AKey, AValue) then begin
    if BStrStartSensitive(AValue, '@M:') then begin
      MultilineMark := AValue;
      AValue := '';
      Inc(ALine);
      while (ALine < High(ALines)) and (ALines[ALine] <> MultilineMark) do begin
        AValue := AValue + ALines[ALine] + BStrLine;
        Inc(ALine);
      end;
    end;
    Exit(True);
  end;
  Exit(False);
end;

procedure TSettingsManager.ResetForm;

begin
  Settings.ForEach(
    procedure(AIt: BVector<TSettingsRegister>.It)
    begin
      ValueToObj(AIt^.Component, AIt^.DefaultValue);
    end);
end;

procedure TSettingsManager.SaveToFile(const AFileName: BStr);

begin
  BFilePut(AFileName, SaveToString);
end;

function TSettingsManager.SaveToString: BStr;

var

  Buffer: BStr;

begin
  Buffer := 'BBOT' + BStrLine;
  Settings.ForEach(
    procedure(AIt: BVector<TSettingsRegister>.It)
    begin
      Buffer := Buffer + ToBuffer(AIt^);
    end);
  Exit(Buffer);
end;

function TSettingsManager.ToBuffer(const ASetting: TSettingsRegister): BStr;

var

  Value: BStr;

  Delim: BStr;

begin
  Value := ValueOfObj(ASetting.Component);
  if ASetting.DefaultValue = Value then
    Exit('');
  if BStrPos(BStrLine, Value) > 0 then begin
    Delim := BFormat('@M:%s', [GenerateMultilineID(Value)]);
    Value := Delim + BStrLine + Value;
    if not BStrEndSensitive(Value, BStrLine) then
      Value := Value + BStrLine;
    Value := Value + Delim;
  end;
  Exit(ASetting.Name + '=' + Value + BStrLine);
end;

function TSettingsManager.calculateComponentPath(const AComponent: TComponent): BStr;

var
  Parent: TComponent;
begin
  Parent := AComponent.GetParentComponent;
  Result := '';
  while Parent <> nil do begin
    Result := Result + Parent.Name + '.';
    if Parent.HasParent and (AComponent.GetParentComponent <> Parent) then
      Parent := AComponent.GetParentComponent
    else
      Break;
  end;
  Result := Result + AComponent.Name;
end;

function TSettingsManager.ValueOfObj(const Obj: TComponent): BStr;
var
  I: BInt32;
begin
  Result := '??';
  if (Obj is TEdit) then
    Result := (Obj as TEdit).Text
  else if (Obj is TSpinEdit) then
    Result := (Obj as TSpinEdit).Text
  else if (Obj is TCheckbox) then
    Result := BoolToStr((Obj as TCheckbox).Checked)
  else if (Obj is TRadioButton) then
    Result := BoolToStr((Obj as TRadioButton).Checked)
  else if (Obj is TComboBoxEx) then
    Result := IntToStr((Obj as TComboBoxEx).ItemIndex)
  else if (Obj is TComboBox) then begin
    if TBBotItemSelector.GetInstance.HasApply(Obj as TComboBox) then
      Result := (Obj as TComboBox).Text
    else
      Result := IntToStr((Obj as TComboBox).ItemIndex)
  end else if (Obj is TTrackBar) then
    Result := IntToStr((Obj as TTrackBar).Position)
  else if (Obj is TMemo) then
    Result := (Obj as TMemo).Lines.Text
  else if (Obj is TListBox) then begin
    Result := '';
    for I := 0 to (Obj as TListBox).Items.Count - 1 do
      Result := Result + (Obj as TListBox).Items[I] + #13#10;
  end else begin
    raise Exception.Create('Unable to gather component value ' + Obj.Name);
  end;
end;

procedure TSettingsManager.ValueToObj(const Obj: TComponent; const Value: BStr);
var
  Res: BStrArray;
  I: BInt32;
  oldOnClick: TNotifyEvent;
begin
  oldOnClick := nil;
  if Obj is TCheckbox then begin
    oldOnClick := (Obj as TCheckbox).OnClick;
    (Obj as TCheckbox).OnClick := nil;
  end;
  if (Obj is TEdit) then
    (Obj as TEdit).Text := Value
  else if (Obj is TSpinEdit) then
    (Obj as TSpinEdit).Text := Value
  else if (Obj is TCheckbox) then
    (Obj as TCheckbox).Checked := StrToBool(Value)
  else if (Obj is TRadioButton) then
    (Obj as TRadioButton).Checked := StrToBool(Value)
  else if (Obj is TComboBoxEx) then begin
    (Obj as TComboBoxEx).ItemIndex := StrToInt(Value);
    if Assigned((Obj as TComboBoxEx).OnSelect) then
      (Obj as TComboBoxEx).OnSelect(Obj);
  end else if (Obj is TComboBox) then begin
    if TBBotItemSelector.GetInstance.HasApply(Obj as TComboBox) then
      TBBotItemSelector.GetInstance.Apply((Obj as TComboBox)).loadValue(Value)
    else
      (Obj as TComboBox).ItemIndex := StrToInt(Value);
    if Assigned((Obj as TComboBox).OnSelect) then
      (Obj as TComboBox).OnSelect(Obj);
  end else if (Obj is TTrackBar) then
    (Obj as TTrackBar).Position := StrToInt(Value)
  else if (Obj is TMemo) then
    (Obj as TMemo).Lines.Text := Value
  else if (Obj is TListBox) then begin
    (Obj as TListBox).Items.Clear;
    BStrSplit(Res, #13#10, Value);
    for I := 0 to High(Res) do
      if Trim(Res[I]) <> '' then
        (Obj as TListBox).Items.Add(Trim(Res[I]));
  end;
  if Obj is TCheckbox then
    (Obj as TCheckbox).OnClick := oldOnClick;
end;

function TSettingsManager.GenerateMultilineID(const AValue: BStr): BStr;
var
  I: BInt32;
begin
  Result := '';
  for I := 0 to 2 do
    Result := Result + IntToStr(BUInt32(CRC32(AValue + Result)));
end;

end.
