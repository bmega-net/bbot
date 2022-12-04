unit BBotEngine;

interface

uses
  uBTypes,
  uBVector,
  Declaracoes,
  Windows,
  Math,
  SysUtils,
  Classes,
  uBattlelist,
  uContainer,
  uBBotCaveBot,
  Inject,
  uTibia,
  uHUD,

  uBBotProtector,

  Menus,
  uBBotAttacker,
  uSelf,
  SyncObjs,

  uBBotMenu,
  uMacroEngine,
  uBBotAction,
  uBBotAmmoCounter,
  uBBotAntiAfk,
  uBBotAntiPush,
  uBBotAutoRope,
  uBBotAutoStack,
  uBBotBackpacks,
  uBBotBagLootKicker,
  uBBotDropVials,
  uBBotEatFood,
  uBBotEatFoodGround,
  uBBotFastHand,
  uBBotFishing,
  uBBotFramerate,
  uBBotLightHack,
  uBBotLogout,
  uBBotOTMoney,
  uBBotReconnect,
  uBBotServerSave,
  uBBotTrader,
  uBBotTradeWatcher,
  uBBotFriendHealer,
  uBBotHealer,
  uBBotManaDrinker,
  uBBotManaTrainer,
  uBBotReUser,
  uBBotOpenCorpses,
  uBBotRareLootAlarm,
  uBBotSkinner,
  uBBotLooter,
  uBBotDepositer,
  uBBotMacros,
  uBBotWarBot,
  uBBotEnchanter,
  uBBotStats,
  uBBotAvoidWaves,
  uBBotSpecialSQMs,
  uBBotTrainer,
  uBBotIgnoreAttack,
  uBBotAdvAttack,
  uBBotJustLoggedIn,
  uBBotConfirmAttack,
  uBBotExhaust,
  uBBotRunners,
  uBBotWalkState,
  uBBotSpells,
  uBBotExpStats,
  uBBotKillStats,
  uBBotLooterStats,
  uBBotSkillsStats,
  uBBotSupliesStats,
  uBBotProfitStats,
  uBBotPacketSender,
  uBBotEvents,
  uBBotDepotTools,
  uBBotDepositerWithdraw,
  uBBotLevelSpy,
  uBBotTestEngine,
  uBBotTradeWindow,
  uBBotWarNet,
  uBBotCreatures,
  uBBotWalker2,
  uBBotReconnectManager,

  uBBotPositionStatistics,

  uBBotSummonDetector, uBBotSuperFollow;

var
  BotPath: BStr = '';

type
  TBBot = class
  private
    FStandTime: BUInt32;
    vCheckShootPath: boolean;
    vHUDMagicWalls: BBool;
    vHUDSpells: BBool;
    FRunnerWalkers: TBBotRunnerPauser;
    FRunnerBasic: TBBotRunnerPauser;
    FRunnerHealers: TBBotRunnerPauser;
    FRunner: TBBotActions;
    FRunnerCommon: TBBotRunnerPauser;
    FWalkState: TBBotWalkState;
    FStartTime: BUInt32;
    FWithdraw: TBBotWithdraw;
    FLevelSpy: TBBotLevelSpy;
    FTestEngine: TBBotTestEngine;
    FTradeWindow: TBBotTradeWindow;
    FWarNet: TBBotWarNet;
    FCreatures: TBBotCreatures;
    FReconnectManager: TBBotReconnectManager;
    FDepotList: TBBotDepotList;
    FPositionStatistics: TBBotPositionStatistics;
    FSuperFollow: TBBotSuperFollow;
    function GetStandTime: BUInt32;
    function GetUptime: BUInt32;
  protected
    ScheduledCommands: BVector<BPair<BUInt32, BProc>>;
    FAmmoCounter: TBBotAmmoCounter;
    FAntiPush: TBBotAntiPush;
    FDropVials: TBBotDropVials;
    FAutoRope: TBBotAutoRope;
    FAutoStack: TBBotAutoStack;
    FBackpacks: TBBotBackpacks;
    FEatFood: TBBotEatFood;
    FEatFoodGround: TBBotEatFoodGround;
    FFastHand: TBBotFastHand;
    FFishing: TBBotFishing;
    FFramerate: TBBotFramerate;
    FLightHack: TBBotLightHack;
    FLogout: TBBotLogout;
    FTrader: TBBotTrader;
    FServerSave: TBBotServerSave;
    FLootBagKicker: TBBotLootBagKicker;
    FOTMoney: TBBotOTMoney;
    FReconnect: TBBotReconnect;
    FTradeWatcher: TBBotTradeWatcher;
    FAntiAFK: TBBotAntiAFK;
    FFriendHealer: TBBotFriendHealer;
    FHealers: TBBotHealers;
    FManaDrinker: TBBotManaDrinker;
    FManaTrainer: TBBotManaTrainer;
    FAttacker: TBBotAttacker;
    FReUser: TBBotReUser;
    FOpenCorpses: TBBotOpenCorpses;
    FRareLootAlarm: TBBotRareLootAlarm;
    FSkinner: TBBotSkinner;
    FLooter: TBBotLooter;
    FDepositer: TBBotDepositer;
    FMacroExec: TBBotMacros;
    FMacros: BMacroEngine;
    FWarBot: TBBotWarBot;
    FEnchanter: TBBotEnchanter;
    FStats: TBBotStats;
    FWalker: TBBotWalker2;
    FCavebot: TBBotCavebot;
    FProtectors: TBBotProtectors;
    FMenu: TBBotMenu;
    FAvoidWaves: TBBotAvoidWaves;
    FSpecialSQMs: TBBotSpecialSQMs;
    FTrainer: TBBotTrainer;
    FIgnoreAttack: TBBotIgnoreAttack;
    FAdvAttack: TBBotAdvAttack;
    FJustLoggedIn: TBBotJustLoggedIn;
    FConfirmAttack: TBBotConfirmAttack;
    FExhaust: TBBotExhaust;
    FSpells: TBBotSpells;
    FExpStats: TBBotExpStats;
    FKillStats: TBBotKillStats;
    FLooterStats: TBBotLooterStats;
    FSkillsStats: TBBotSkillsStats;
    FSupliesStats: TBBotSupliesStats;
    FProfitStats: TBBotProfitStats;
    FPacketSender: TBBotPacketSender;
    FEvents: TBBotEvents;
    FSummonDetector: TBBotSummonDetector;
  public
    _nextAction: BLock;
    _bAnAd: BLock;
    constructor Create;
    destructor Destroy; override;

    class procedure PanicMode;

    procedure Inject;
    procedure CreateActions;

    procedure DisplayWelcomeMessage;

    procedure Load;
    procedure Execute;
    procedure OnInitSelf;

    procedure RunScheduler;

    property StandTime: cardinal read GetStandTime write FStandTime;

    procedure StopSound;
    procedure StartSound(SoundFile: BStr; ALoop: BBool);
    procedure SimpleAlarm(AText: BStr; ALoop: BBool);

    function OpenNextBP(Index: BInt32): boolean;
    procedure AddMwall(Position: BPos; Destroy: BUInt32);
    procedure RemoveMwall(Position: BPos);

    property Runner: TBBotActions read FRunner;
    property RunnerCommon: TBBotRunnerPauser read FRunnerCommon;
    property RunnerHealers: TBBotRunnerPauser read FRunnerHealers;
    property RunnerBasic: TBBotRunnerPauser read FRunnerBasic;
    property RunnerWalkers: TBBotRunnerPauser read FRunnerWalkers;

    property Creatures: TBBotCreatures read FCreatures;

    property AmmoCounter: TBBotAmmoCounter read FAmmoCounter;
    property AntiPush: TBBotAntiPush read FAntiPush;
    property DropVials: TBBotDropVials read FDropVials;
    property AutoRope: TBBotAutoRope read FAutoRope;
    property AutoStack: TBBotAutoStack read FAutoStack;
    property Backpacks: TBBotBackpacks read FBackpacks;
    property EatFood: TBBotEatFood read FEatFood;
    property EatFoodGround: TBBotEatFoodGround read FEatFoodGround;
    property FastHand: TBBotFastHand read FFastHand;
    property Fishing: TBBotFishing read FFishing;
    property Framerate: TBBotFramerate read FFramerate;
    property LightHack: TBBotLightHack read FLightHack;
    property Logout: TBBotLogout read FLogout;
    property Trader: TBBotTrader read FTrader;
    property ServerSave: TBBotServerSave read FServerSave;
    property LootBagKicker: TBBotLootBagKicker read FLootBagKicker;
    property OTMoney: TBBotOTMoney read FOTMoney;
    property Reconnect: TBBotReconnect read FReconnect;
    property TradeWatcher: TBBotTradeWatcher read FTradeWatcher;
    property AntiAFK: TBBotAntiAFK read FAntiAFK;
    property FriendHealer: TBBotFriendHealer read FFriendHealer;
    property Healers: TBBotHealers read FHealers;
    property ManaDrinker: TBBotManaDrinker read FManaDrinker;
    property ManaTrainer: TBBotManaTrainer read FManaTrainer;
    property Attacker: TBBotAttacker read FAttacker;
    property ReUser: TBBotReUser read FReUser;
    property OpenCorpses: TBBotOpenCorpses read FOpenCorpses;
    property RareLootAlarm: TBBotRareLootAlarm read FRareLootAlarm;
    property Skinner: TBBotSkinner read FSkinner;
    property Looter: TBBotLooter read FLooter;
    property Depositer: TBBotDepositer read FDepositer;
    property MacroExec: TBBotMacros read FMacroExec;
    property Macros: BMacroEngine read FMacros;
    property WarBot: TBBotWarBot read FWarBot;
    property Enchanter: TBBotEnchanter read FEnchanter;
    property Stats: TBBotStats read FStats;
    property Walker: TBBotWalker2 read FWalker;
    property Cavebot: TBBotCavebot read FCavebot;
    property Protectors: TBBotProtectors read FProtectors;
    property Menu: TBBotMenu read FMenu;
    property AvoidWaves: TBBotAvoidWaves read FAvoidWaves;
    property SpecialSQMs: TBBotSpecialSQMs read FSpecialSQMs;
    property Trainer: TBBotTrainer read FTrainer;
    property IgnoreAttack: TBBotIgnoreAttack read FIgnoreAttack;
    property AdvAttack: TBBotAdvAttack read FAdvAttack;
    property JustLoggedIn: TBBotJustLoggedIn read FJustLoggedIn;
    property ConfirmAttack: TBBotConfirmAttack read FConfirmAttack;
    property Exhaust: TBBotExhaust read FExhaust;
    property WalkState: TBBotWalkState read FWalkState;
    property Spells: TBBotSpells read FSpells;
    property ExpStats: TBBotExpStats read FExpStats;
    property KillStats: TBBotKillStats read FKillStats;
    property LooterStats: TBBotLooterStats read FLooterStats;
    property SkillsStats: TBBotSkillsStats read FSkillsStats;
    property SupliesStats: TBBotSupliesStats read FSupliesStats;
    property ProfitStats: TBBotProfitStats read FProfitStats;
    property PacketSender: TBBotPacketSender read FPacketSender;
    property Events: TBBotEvents read FEvents;
    property Withdraw: TBBotWithdraw read FWithdraw;
    property LevelSpy: TBBotLevelSpy read FLevelSpy;
    property TradeWindow: TBBotTradeWindow read FTradeWindow;
    property TestEngine: TBBotTestEngine read FTestEngine;
    property WarNet: TBBotWarNet read FWarNet;
    property ReconnectManager: TBBotReconnectManager read FReconnectManager;
    property DepotList: TBBotDepotList read FDepotList;
    property PositionStatistics: TBBotPositionStatistics
      read FPositionStatistics;
    property SummonDetector: TBBotSummonDetector read FSummonDetector;
    property SuperFollow: TBBotSuperFollow read FSuperFollow;

    property Uptime: BUInt32 read GetUptime;

    procedure Schedule(ADelay: BUInt32; ACommand: BProc);
  end;

const
  Creature_AttackDelay = 700;
  Creature_TickDelay = 700;

var
  BBotMutex: TMutex;
  BBot: TBBot;
  Tibia: TTibia;
  Me: TTibiaSelf;

implementation

uses
  uTiles,

  uItem,
  StrUtils,
  Graphics,

  uPackets,
  Forms,
  uEngine,

  uTibiaProcess,

  uTibiaState,
  uBBotAddresses;

{ TBBot }

procedure TBBot.CreateActions;
begin
  FRunnerCommon := TBBotRunnerPauser.Create('Runner Common', 0, bplAll);
  FRunnerHealers := TBBotRunnerPauser.Create('Runner Healers', 0, bplAll);
  FRunnerBasic := TBBotRunnerPauser.Create('Runner Basic', 0, bplAutomation);
  FRunnerWalkers := TBBotRunnerPauser.Create('Runner Walkers', 0,
    bplAutomation);
  FRunner := TBBotActions.Create('Runner Main', 0);
  FTestEngine := TBBotTestEngine.Create;
  FCreatures := TBBotCreatures.Get(AdrSelected);
  FRunner.AddActions([FRunnerCommon, FRunnerHealers, FRunnerBasic,
    FRunnerWalkers, FTestEngine, FCreatures]);

  FEvents := TBBotEvents.Create;
  FTradeWindow := TBBotTradeWindow.Create;
  FPacketSender := TBBotPacketSender.Create;
  FJustLoggedIn := TBBotJustLoggedIn.Create;
  FExhaust := TBBotExhaust.Create;
  FSpells := TBBotSpells.Create;
  FSpecialSQMs := TBBotSpecialSQMs.Create;
  FMenu := TBBotMenu.Create;
  FStats := TBBotStats.Create;
  FExpStats := TBBotExpStats.Create(FStats);
  FSkillsStats := TBBotSkillsStats.Create(FStats);
  FSupliesStats := TBBotSupliesStats.Create(FStats);
  FLooterStats := TBBotLooterStats.Create(FStats);
  FKillStats := TBBotKillStats.Create(FStats);
  FProfitStats := TBBotProfitStats.Create(FStats);
  FAmmoCounter := TBBotAmmoCounter.Create;
  FFramerate := TBBotFramerate.Create;
  FLogout := TBBotLogout.Create;
  FLightHack := TBBotLightHack.Create;
  FServerSave := TBBotServerSave.Create;
  FReconnect := TBBotReconnect.Create;
  FTradeWatcher := TBBotTradeWatcher.Create;
  FRareLootAlarm := TBBotRareLootAlarm.Create;
  FLevelSpy := TBBotLevelSpy.Create;
  FDepotList := TBBotDepotList.Create;
  FPositionStatistics := TBBotPositionStatistics.Create;
  FRunnerCommon.AddActions([Tibia, FEvents, FPacketSender, FJustLoggedIn,
    FExhaust, FSpells, FSpecialSQMs, FTradeWindow, FMenu, FStats, FAmmoCounter,
    FFramerate, FLogout, FLightHack, FServerSave, FReconnect, FTradeWatcher,
    FRareLootAlarm, FExpStats, FSkillsStats, FSupliesStats, FLooterStats,
    FKillStats, FProfitStats, FLevelSpy, FDepotList, FPositionStatistics]);

  FHealers := TBBotHealers.Create;
  FManaDrinker := TBBotManaDrinker.Create;
  FReUser := TBBotReUser.Create;
  FFriendHealer := TBBotFriendHealer.Create;
  FRunnerHealers.AddActions([FHealers, FManaDrinker, FReUser, FFriendHealer]);

  FBackpacks := TBBotBackpacks.Create;
  FEnchanter := TBBotEnchanter.Create;
  FAntiPush := TBBotAntiPush.Create;
  FDropVials := TBBotDropVials.Create;
  FAutoRope := TBBotAutoRope.Create;
  FAutoStack := TBBotAutoStack.Create;
  FEatFood := TBBotEatFood.Create;
  FEatFoodGround := TBBotEatFoodGround.Create;
  FFastHand := TBBotFastHand.Create;
  FFishing := TBBotFishing.Create;
  FTrader := TBBotTrader.Create;
  FLootBagKicker := TBBotLootBagKicker.Create;
  FOTMoney := TBBotOTMoney.Create;
  FAntiAFK := TBBotAntiAFK.Create;
  FManaTrainer := TBBotManaTrainer.Create;
  FMacroExec := TBBotMacros.Create;
  FProtectors := TBBotProtectors.Create;
  FRunnerBasic.AddActions([FBackpacks, FEnchanter, FAntiPush, FDropVials,
    FAutoRope, FAutoStack, FEatFood, FEatFoodGround, FFastHand, FFishing,
    FTrader, FLootBagKicker, FOTMoney, FAntiAFK, FManaTrainer, FMacroExec,
    FProtectors]);

  FLooter := TBBotLooter.Create;
  FAttacker := TBBotAttacker.Create;
  FSuperFollow := TBBotSuperFollow.Create;
  FSummonDetector := TBBotSummonDetector.Create;
  FOpenCorpses := TBBotOpenCorpses.Create;
  FSkinner := TBBotSkinner.Create;
  FWithdraw := TBBotWithdraw.Create;
  FDepositer := TBBotDepositer.Create;
  FWarBot := TBBotWarBot.Create;
  FWarNet := TBBotWarNet.Create(FWarBot);
  FTrainer := TBBotTrainer.Create;
  FIgnoreAttack := TBBotIgnoreAttack.Create;
  FAdvAttack := TBBotAdvAttack.Create;
  FConfirmAttack := TBBotConfirmAttack.Create;
  FAvoidWaves := TBBotAvoidWaves.Create;
  FWalker := TBBotWalker2.Create;
  FCavebot := TBBotCavebot.Create;
  FWalkState := TBBotWalkState.Create;
  FReconnectManager := TBBotReconnectManager.Create;
  FRunnerWalkers.AddActions([FLooter, FAttacker, FOpenCorpses, FSkinner,
    FSuperFollow, FWithdraw, FDepositer, FWarBot, FWarNet, FTrainer,
    FIgnoreAttack, FAdvAttack, FConfirmAttack, FSummonDetector, FAvoidWaves,
    FWalker, FCavebot, FWalkState, FReconnectManager]);

  FRunner.OnInit;
  OnInitSelf;
end;

procedure TBBot.AddMwall(Position: BPos; Destroy: BUInt32);
begin
  Stats.OnMagicWall(Position, (Destroy * 1000) - Tibia.PingAvg);
end;

function TBBot.GetStandTime: BUInt32;
begin
  Result := Tick - FStandTime;
end;

function TBBot.GetUptime: BUInt32;
begin
  Result := Tick - FStartTime;
end;

procedure TBBot.Inject;
begin
  BBotMutex := TMutex.Create(nil, False, 'bmu' + IntToStr(TibiaProcess.PID));
  PacketQueue := TBBotPacketQueue.Create;
  InitHUD;
  InitTibiaState;
  InjectDLL(TibiaProcess.PID, BPChar(BotPath + 'BDll.dll'));
end;

procedure TBBot.Load;
begin
  Tibia.BlockKeyCallback(VK_HOME, True, False);
  Tibia.BlockKeyCallback(VK_END, True, False);
  Tibia.BlockKeyCallback(VK_PAUSE, True, False);
  Tibia.BlockKeyCallback(VK_INSERT, True, False);
  CreateActions;
  DisplayWelcomeMessage;
  Engine.ReportWrongDLL := TibiaState^.Dll <> BDllU32;
end;

procedure TBBot.OnInitSelf;
begin
  Events.OnCharacter.Add(
    procedure()
    begin
      Engine.SetFMainTitle := True;
      Me.LoggingOut := False;
    end);
  Events.OnWalk.Add(
    procedure(Pos: BPos)
    begin
      StandTime := Tick;
    end);
  Events.OnTarget.Add(
    procedure(OldCreature: TBBotCreature)
    begin
      StandTime := Tick;
    end);
  Events.OnCreatureHP.Add(
    procedure(Creature: TBBotCreature; OldHealth: BInt32)
    begin
      if Creature.IsTarget and (OldHealth > Creature.Health) then
        StandTime := Tick;
    end);
  Events.OnMenu.Add(
    procedure(ClickID, Data: BUInt32)
    begin
      StopSound;
    end);
end;

class procedure TBBot.PanicMode;
begin
  try
    Me.Reload;
    BBot.Healers.Run;
    BBot.ManaDrinker.Run;
  finally
  end;
end;

procedure TBBot.RemoveMwall(Position: BPos);
begin
  Schedule(600,
    procedure()
    begin
      Stats.OnPossiblyRemovedMagicWall(Position);
    end);
end;

procedure TBBot.RunScheduler;
begin
  ScheduledCommands.Delete(
    function(It: BVector < BPair < BUInt32, BProc >>.It): BBool
    begin
      Result := Tick > It^.First;
      if Result then
      begin
        try
          It^.Second();
        except
          on E: Exception do
            raise BException.Create('BBot->ScheduledCommands' + BStrLine +
              E.Message);
        end;
      end;
    end);
end;

function TBBot.OpenNextBP(Index: BInt32): boolean;
var
  CT: TTibiaContainer;
begin
  Result := False;
  CT := ContainerLast;
  while CT <> nil do
  begin
    if CT.Container = Index then
      if CT.IsContainer then
      begin
        CT.Use;
        Result := True;
        Exit;
      end;
    CT := CT.Prev;
  end;

end;

constructor TBBot.Create;
begin
  FStandTime := 0;

  Tibia := TTibia.Create;
  Inject;
  BotCreateContainers;
  BotCreateMap;
  Me := TTibiaSelf.Create;
  FMacros := BMacroEngine.Create;

  vCheckShootPath := True;
  vHUDMagicWalls := True;
  vHUDSpells := True;

  FStartTime := Tick;

  _nextAction := BLock.Create(200, 20);
  _bAnAd := BLock.Create(2100, 20);

  ScheduledCommands := BVector < BPair < BUInt32, BProc >>.Create;
end;

destructor TBBot.Destroy;
begin
  Tibia.UnBlockKeyCallback(VK_HOME, True, False);
  Tibia.UnBlockKeyCallback(VK_END, True, False);
  Tibia.UnBlockKeyCallback(VK_PAUSE, True, False);
  Tibia.UnBlockKeyCallback(VK_INSERT, True, False);

  HUDExecute;
  HUDRemoveAll;
  HUDExecute;

  _SafeFree(FRunner);

  _SafeFree(FMacros);

  _SafeFree(PacketQueue);

  _SafeFree(Me);
  _SafeFree(HUDPacket);

  BotDestroyContainers;
  BotDestroyMap;

  _nextAction.Free;
  _bAnAd.Free;

  DeInitHUD;
  _SafeFree(PacketQueue);
  _SafeFree(BBotMutex);
  _SafeFree(ScheduledCommands);

  inherited;
end;

procedure TBBot.DisplayWelcomeMessage;
const
  Duration = 4000;
var
  HUD: TBBotHUD;
begin
  HUDRemoveAll;
  HUD := TBBotHUD.Create(bhgAny);
  HUD.AlignTo(bhaLeft, bhaTop);
  HUD.Expire := Duration * 3;

  HUD.RelativeX := 0;
  HUD.Print('Official Website:', clSilver);
  HUD.RelativeX := +5;
  HUD.Print('http://www.BMega.net', clWhite);
  HUD.Line;

  HUD.Expire := Duration;

  HUD.RelativeX := 0;
  HUD.Print('Hotkeys', clSilver);

  HUD.RelativeX := +5;
  HUD.Print('Press [Shift]+[Control] to show the BBot Center menu', clWhite);
  HUD.Print('Press [Shift]+[End] to Show/Hide BBot', clWhite);
  HUD.Print('Press [Shift]+[Insert/Pause] to pause the BBot', clWhite);
  HUD.Print('Press [Shift]+[Home] to display statistics', clWhite);
  HUD.Line;

  HUD.Free;
end;

procedure TBBot.Execute;
begin
  Events.RunHotkeys;
  Events.RunMenu;

  if Me.Connected then
  begin
    Runner.RunAction;
    RunScheduler;
  end
  else
  begin
    Me.LoggingOut := False;
    Me.Reload;
  end;

  HUDExecute;
end;

procedure TBBot.StopSound;
begin
  HUDRemoveGroup(bhgAlert);
  StopWav;
end;

procedure TBBot.StartSound(SoundFile: BStr; ALoop: BBool);
begin
  StopWav;
  if (SoundFile = '') or (not FileExists(BotPath + 'Data/' + SoundFile + '.wav'))
  then
{$IFDEF Release}
    PlayWav(BotPath + 'Data/Alert.wav', ALoop)
{$ELSE}
    PlayWav(BotPath + 'Data/Test.wav', ALoop)
{$ENDIF}
  else
    PlayWav(BotPath + 'Data/' + SoundFile + '.wav', ALoop);
end;

procedure TBBot.Schedule(ADelay: BUInt32; ACommand: BProc);
var
  It: BVector < BPair < BUInt32, BProc >>.It;
begin
  It := ScheduledCommands.Add;
  It^.First := Tick + ADelay;
  It^.Second := ACommand;
end;

procedure TBBot.SimpleAlarm(AText: BStr; ALoop: BBool);
var
  HUD: TBBotHUD;
begin
  HUDRemoveGroup(bhgAlert);
  BBot.StartSound('', ALoop);
  HUD := TBBotHUD.Create(bhgAlert);
  HUD.AlignTo(bhaLeft, bhaTop);
  HUD.Print(AText, $8080F0);
  HUD.OnClick := BBotProtectorClickID;
  HUD.Print('[ click here to disable alarm ]', $8080F0);
  HUD.Free;
end;

end.
