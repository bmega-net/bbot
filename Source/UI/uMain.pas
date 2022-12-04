unit uMain;

interface

uses
  uBTypes,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  uSettings,
  ImgList,
  ExtCtrls,
  CheckLst,
  Menus,
  StrUtils,
  CommCtrl,
  Buttons,
  Clipbrd,
  Grids,
  ShellAPI,
  Declaracoes,
  uBBotProtector,
  uTibiaDeclarations,
  uTibia,
  SyncObjs,
  VirtualTrees,
  uDownloader,
  SynCompletionProposal,
  SynEdit,

  Types,
  uBBotWarbot,
  uBBotHealer,

  uBBotCaveBot,

  uBBotAction,
  DateUtils,
  uAdvancedAttackFrame,

  uCavebotFrame,
  uDebugFrame,
  uReconnectManagerFrame,
  uUserErrorFrame,

  uMacrosFrame,
  uLooterFrame,
  uWarNetFrame,

  uBVector,
  uDebugWalkerFrame,
  uBBotGUIMessages,
  uKillerFrame,
  uSpecialSQMsFrame,
  uFriendHealerFrame,
  uBBotItemSelector,
  uAttackSequencesFrame,
  uManaToolsFrame,
  uHealerFrame,
  uVariablesFrame, System.ImageList;

const
  WM_TRAYCLICK = WM_USER + 1;
  WM_BBOTMESSAGE = WM_USER + 2;

type
  TOnOkConfig = procedure(FileName: BStr) of object;

  TBBotMenuNodeData = record
    Text: BStr;
    Hint: BStr;
    Panel: TPanel;
    Image: BInt32;
    Link: BBool;
  end;

var
  FMainBBotMenu: array of TBBotMenuNodeData;

type
  TFMain = class(TForm)
    HideBBot1: TMenuItem;
    HideTibia1: TMenuItem;
    imgMenu: TImageList;
    imgHealer: TImageList;
    imgManaDrinker: TImageList;
    imgTools: TImageList;
    N5: TMenuItem;
    PopTray: TPopupMenu;
    ShowBBot1: TMenuItem;
    ShowTibia1: TMenuItem;
    gbBasic: TPanel;
    chkTray: TCheckBox;
    chkXRay: TCheckBox;
    chkAutoOpenBP: TCheckBox;
    chkEat: TCheckBox;
    chkEatFoodGround: TCheckBox;
    chkAntiIDLE: TCheckBox;
    chkFishing: TCheckBox;
    chkFishingWorm: TCheckBox;
    numFisherCap: TMemo;
    chkAmmoCounter: TCheckBox;
    chkAutoDropVials: TCheckBox;
    chkGroup: TCheckBox;
    chkOtMoney: TCheckBox;
    chkReconnect: TCheckBox;
    chkFrameRate: TCheckBox;
    chkSS: TCheckBox;
    cmbLightHack: TComboBox;
    Label3: TLabel;
    gbSettingFile: TPanel;
    lstConfigs: TListBox;
    edtConfig: TEdit;
    btnConfig: TButton;
    btnConfigCancel: TButton;
    Label9: TLabel;
    gbAlliesAndEnemies: TPanel;
    gbProtector: TPanel;
    Label58: TLabel;
    memoAllies: TMemo;
    memoEnemies: TMemo;
    Label82: TLabel;
    gbWarbot: TPanel;
    chkMWallFrontEnemies: TCheckBox;
    chkDash: TCheckBox;
    Label57: TLabel;
    chkLockTarget: TCheckBox;
    chkWBCActive: TCheckBox;
    edtLeaders: TEdit;
    chkAim: TCheckBox;
    Label64: TLabel;
    Label65: TLabel;
    Label62: TLabel;
    Label61: TLabel;
    cmbAim1: TComboBox;
    cmbAim2: TComboBox;
    cmbAim3: TComboBox;
    cmbCombo: TComboBox;
    gbHUD: TPanel;
    chkCLevels: TCheckBox;
    chkAdvanced: TCheckBox;
    chkHUDspells: TCheckBox;
    chkHUDmwalls: TCheckBox;
    chkExp: TCheckBox;
    chkGotInfo: TCheckBox;
    chkAutoStatistics: TCheckBox;
    Button4: TButton;
    gbMacros: TPanel;
    gbTradeHelper: TPanel;
    Label2: TLabel;
    Label74: TLabel;
    edtTHwatch: TEdit;
    chkTHwatch: TCheckBox;
    Label73: TLabel;
    Label1: TLabel;
    edtTHmsg: TEdit;
    chkTHmsg: TCheckBox;
    chkTHmsgyell: TCheckBox;
    gbCavebot: TPanel;
    gbSpecialSQMs: TPanel;
    gbKiller: TPanel;
    gbLooter: TPanel;
    gbTrainer: TPanel;
    Label42: TLabel;
    lstTrainers: TCheckListBox;
    chkHPTrain: TCheckBox;
    Label45: TLabel;
    Label43: TLabel;
    Label46: TLabel;
    Label44: TLabel;
    chkSlimeTrain: TCheckBox;
    cmdTre: TButton;
    gbReUserCures: TPanel;
    Label39: TLabel;
    chkRUhaste: TCheckBox;
    chkRUms: TCheckBox;
    chkRUrecovery: TCheckBox;
    chkRUsharpshooter: TCheckBox;
    chkRUbloodrage: TCheckBox;
    chkRUcharge: TCheckBox;
    chkRUlight1: TCheckBox;
    chkRUlight3: TCheckBox;
    chkRUlight2: TCheckBox;
    chkRUprotector: TCheckBox;
    chkRUswiftfoot: TCheckBox;
    chkRUintenserecovery: TCheckBox;
    chkRUinvis: TCheckBox;
    chkRUshaste: TCheckBox;
    Label40: TLabel;
    chkRUamulet: TCheckBox;
    chkRUring: TCheckBox;
    chkRUleft: TCheckBox;
    Label12: TLabel;
    chkCurePoison: TCheckBox;
    chkCureBleeding: TCheckBox;
    chkCureBurning: TCheckBox;
    chkCureParalyze: TCheckBox;
    edtCureParalyzeSpell: TEdit;
    numCureParalyzeMana: TMemo;
    chkCureEletrification: TCheckBox;
    chkCureCurse: TCheckBox;
    chkRUright: TCheckBox;
    chkRUsoft: TCheckBox;
    chkRUammo: TCheckBox;
    gbManaTools: TPanel;
    gbEnchanter: TPanel;
    Label7: TLabel;
    cmbEnchanterHand: TComboBox;
    rbEnchanterUseBlank: TRadioButton;
    rbEnchanterUseSpear: TRadioButton;
    numEnchanterMana: TMemo;
    Label14: TLabel;
    txtEnchanterSpell: TEdit;
    Label15: TLabel;
    Label34: TLabel;
    numEnchanterSoul: TMemo;
    chkEnchanter: TCheckBox;
    gbFriendHealer: TPanel;
    gbHealer: TPanel;
    lblSettingsTitle: TLabel;
    chkWBCattack: TCheckBox;
    gbMacroEditor: TPanel;
    numMacroEditorDelay: TMemo;
    edtMacroEditorCode: TEdit;
    edtMacroEditorName: TEdit;
    lblMacroEditorCopy: TLabel;
    Label117: TLabel;
    Label119: TLabel;
    btnMacroBack: TButton;
    gbWarNet: TPanel;
    chkMarkAlliesAndenemies: TCheckBox;
    chkAllyParty: TCheckBox;
    chkEnemyNoAlly: TCheckBox;
    chkAutoAttackEnemies: TCheckBox;
    chkPushParalyed: TCheckBox;
    chkComboSay: TCheckBox;
    chkWCBparalyzed: TCheckBox;
    edtComboSay: TEdit;
    Label47: TLabel;
    chkServerSaveLogout: TCheckBox;
    numSSLogoutHH: TMemo;
    numSSLogoutMM: TMemo;
    gbAtkSequences: TPanel;
    chkLootHUD: TCheckBox;
    chkLevelSpy: TCheckBox;
    Label54: TLabel;
    gbDebug: TPanel;
    tmrEngine: TTimer;
    mmLooter: TMemo;
    Label24: TLabel;
    btnMacroDone: TButton;
    lstProtectors: TListBox;
    chkProtectorsActive: TCheckBox;
    edtProtectorName: TEdit;
    cmbProtectorKind: TComboBox;
    chkProtectorLogout: TCheckBox;
    chkProtectorScreenshot: TCheckBox;
    chkProtectorSound: TCheckBox;
    chkProtectorGoLabel: TCheckBox;
    edtProtectorGoLabel: TEdit;
    chkProtectorMacro: TCheckBox;
    cmbProtectorMacro: TComboBox;
    chkProtectorPrivateMessage: TCheckBox;
    edtProtectorPrivateMessageTo: TEdit;
    edtProtectorPrivateMessageText: TEdit;
    chkProtectorCloseTibia: TCheckBox;
    chkProtectorShutdown: TCheckBox;
    Label11: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label53: TLabel;
    Label78: TLabel;
    btnProtector: TButton;
    numProtector: TMemo;
    Label118: TLabel;
    Label120: TLabel;
    chkMapClick: TCheckBox;
    Label121: TLabel;
    btnPasteEdit: TButton;
    gbVariables: TPanel;
    Label140: TLabel;
    cmbProtectorSoundfile: TComboBox;
    gbPackets: TPanel;
    lstSC: TListBox;
    lstSS: TListBox;
    lstSB: TListBox;
    TrainerHPMax: TMemo;
    TrainerHPMin: TMemo;
    sMacroCP: TSynCompletionProposal;
    sMacro: TSynEdit;
    chkTHmsgsay: TCheckBox;
    chkPlayerGroups: TCheckBox;
    Label55: TLabel;
    Label60: TLabel;
    cmbProtectorPause: TComboBox;
    Label86: TLabel;
    chkAutoMinimizeBP: TCheckBox;
    rdMacroOnce: TRadioButton;
    Label95: TLabel;
    rdMacroManual: TRadioButton;
    rdMacroAuto: TRadioButton;
    chkAutoMinimizeBPsInventory: TCheckBox;
    chkAutoMinimizeBPsMinimizedGetPremium: TCheckBox;
    Label111: TLabel;
    gbReview: TPanel;
    Label114: TLabel;
    Label115: TLabel;
    cmbRateStars: TComboBox;
    memoRateReview: TMemo;
    Label116: TLabel;
    Label122: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label132: TLabel;
    btnRateSend: TButton;
    tmrDelete: TTimer;
    gbProfilers: TPanel;
    lvProfilers: TListView;
    gbBotManager: TPanel;
    gbAdvancedAttack: TPanel;
    gbUserError: TPanel;
    vstMenu: TVirtualStringTree;
    gbDebugWalker: TPanel;
    Label4: TLabel;
    chkSuperFollow: TCheckBox;
    procedure btnBlockedSQMsDoneClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnKillerNewCancelClick(Sender: TObject);
    procedure btnDoReconnectClick(Sender: TObject);
    procedure btnResetStatistics(Sender: TObject);
    procedure chkTrayClick(Sender: TObject);
    procedure cmbAim1Click(Sender: TObject);
    procedure cmdTreClick(Sender: TObject);
    procedure btnMacroGetPosClick(Sender: TObject);
    procedure edtComboSpellClick(Sender: TObject);
    procedure HideBBot1Click(Sender: TObject);
    procedure HideTibia1Click(Sender: TObject);
    procedure lstCommMeasureItem(Control: TWinControl; Index: Integer;
      var Height: BInt32);
    procedure lstConfigsClick(Sender: TObject);
    procedure lstConfigsDblClick(Sender: TObject);
    procedure lstTrainersClickCheck(Sender: TObject);
    procedure lstTrainersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ShowBBot1Click(Sender: TObject);
    procedure ShowTibia1Click(Sender: TObject);
    procedure lblEnemiesAndAlliesClick(Sender: TObject);
    procedure btnAlliesAndEnemiesOKClick(Sender: TObject);
    procedure OnKeyPressNumOnly(Sender: TObject; var Key: Char);
    procedure Label100Click(Sender: TObject);
    procedure Label101Click(Sender: TObject);
    procedure vstMenuBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstMenuDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; const Text: String;
      const CellRect: TRect; var DefaultDraw: Boolean);
    procedure vstMenuChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstMenuCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);
    procedure vstMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstMenuMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure Label112Click(Sender: TObject);
    procedure lblMacroEditorCopyClick(Sender: TObject);
    procedure btnMacroBackClick(Sender: TObject);
    procedure edtMacroEditorNameChange(Sender: TObject);
    procedure Label136Click(Sender: TObject);
    procedure onAtkSeqDropDown(Sender: TObject);
    procedure onAtkSeqCloseUp(Sender: TObject);
    procedure tmrEngineTimer(Sender: TObject);
    procedure tmrOnDll(Sender: TObject);
    procedure MacroCloseUp(Sender: TObject);
    procedure Label53Click(Sender: TObject);
    procedure btnProtectorClick(Sender: TObject);
    procedure lstProtectorsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstProtectorsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ProtectorTextFields(Sender: TObject);
    procedure cmbProtectorKindCloseUp(Sender: TObject);
    procedure Label121Click(Sender: TObject);
    procedure sMacroChange(Sender: TObject);
    procedure btnPasteEditClick(Sender: TObject);
    procedure btnMacroDoneClick(Sender: TObject);
    procedure cmbProtectorSoundfileDropDown(Sender: TObject);

    procedure BasicToolsSettings(Sender: TObject);
    procedure AutomationToolsSettings(Sender: TObject);
    procedure HealingToolsSettings(Sender: TObject);
    procedure WarToolsSettings(Sender: TObject);
    procedure AdvancedToolsSettings(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstProtectorsDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MacroExecuteMethod(Sender: TObject);
    procedure memoRateReviewChange(Sender: TObject);
    procedure btnRateSendClick(Sender: TObject);
    procedure tmrDeleteTimer(Sender: TObject);
    procedure lvProfilersCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure AdvancedAttackManageAtkSequencesClick(Sender: TObject);
    procedure LinkEnter(Sender: TObject);
    procedure LinkLeave(Sender: TObject);
    procedure MacroList(Sender: TObject);
    function ValidateItemCheckbox(const ID: BInt32;
      const CheckBox: TCheckBox): BBool;
    procedure sMacroCPShow(Sender: TObject);
    procedure sMacroCPPaintItem(Sender: TObject; Index: Integer;
      TargetCanvas: TCanvas; ItemRect: TRect; var CustomDraw: Boolean);
    procedure Label4Click(Sender: TObject);
    procedure lstSBDblClick(Sender: TObject);
  private
    BChecked: Boolean;
    CallbackOnOk: TOnOkConfig;
    lstAddHeight: BInt32;
    gbCurrent, gbLast: TPanel;
    LstFeatureID: BInt32;
    SaveLoadExt: BStr;
    TrayData: TNotifyIconData;
    FTrayIconEnabled: BBool;
    procedure AskConfigFile(Sender: TObject; Title, Ext: BStr;
      OnOk: TOnOkConfig);
    function CheckFileSave(FileName: BStr): Boolean;
    procedure OnLoadConfigOk(FileName: BStr);
    procedure OnPopupClose(Sender: TObject);
    procedure OnSaveConfigOk(FileName: BStr);

    procedure OTSafe(Sender: TObject);

    procedure OnRateResult(State: TLoadURLState; Data: BStr);
    procedure SetTrayIconEnabled(const Value: BBool);
    procedure AddProfilerData(const AParent: BStr; const AAction: TBBotAction);

    procedure MigrateAttackAdvAtk;
    procedure LoadMigrations;
    procedure InitializeFrames;
    procedure InitializeItemSelector;
  protected
    FMutex: TMutex;
  public
    ProfilersNextShow: BUInt32;
    LootableFilterNext: BUInt32;

    InviteIdx: BInt32;
    InviteClr: BUInt32;
    AutoPopup: BUInt32;

    IgnoreOTWarning: BBool;
    LinksNode: PVirtualNode;

    SettingsManager: TBBotSettingsManager;
    BBotItemSelector: TBBotItemSelector;

    AdvancedAttackFrame: TAdvancedAttackFrame;
    CavebotFrame: TCavebotFrame;
    DebugFrame: TDebugFrame;
    ReconnectManagerFrame: TReconnectManagerFrame;
    UserErrorFrame: TUserErrorFrame;
    MacrosFrame: TMacrosFrame;
    LooterFrame: TLooterFrame;
    WarNetFrame: TWarNetFrame;
    DebugWalkerFrame: TDebugWalkerFrame;
    KillerFrame: TKillerFrame;
    SpecialSQMsFrame: TSpecialSQMsFrame;
    FriendHealerFrame: TFriendHealerFrame;
    AttackSequencesFrame: TAttackSequencesFrame;
    ManaToolsFrame: TManaToolsFrame;
    HealerFrame: THealerFrame;
    VariablesFrame: TVariablesFrame;

    property TrayIconEnabled: BBool read FTrayIconEnabled
      write SetTrayIconEnabled;

    procedure OnTrayClick(var Msg: TMessage); message WM_TRAYCLICK;

    procedure CMDialogKey(var Msg: TCMDialogKey); message CM_DIALOGKEY;

    procedure ShowGroupBox(GB: TPanel);
    procedure ShowGroupBoxLast;

    procedure OnBBotMessage(var AMsg: TMessage); message WM_BBOTMESSAGE;
    procedure AddBBotMessage(AMessage: TBBotGUIMessage);

    procedure SetClipboard(Text: BStr);
    function GetClipboard: BStr;
    procedure CreateMenu;

    procedure ResizeToBox(GB: TPanel);

    procedure MacroEditorGenerateCode;
    procedure MacroEditorCreate;
    procedure MacroEditorLoad(SCode: BStr);

    procedure CheckInt(AMemo: TMemo; ACheck: TCheckBox;
      APercent: BBool); overload;
    procedure CheckInt(AMemo: TMemo; AMessage: BStr; APercent: BBool); overload;

    function MutexAcquire: BBool;
    procedure MutexRelease;
    function MutexScopped(const AProc: BProc): BBool;

    procedure AddDebug(const AText: BStr);
  end;

procedure ListFilesToList(FileMask: BStr; List: TStrings);
function ListFiles(FileMask: BStr): BStrArray;

var
  FMain: TFMain;
  HideOnLeave: TWinControl;

resourcestring
  StrManageAttackSequen = 'Manage Attack Sequences';

implementation

uses
  BBotEngine,
  uBattlelist,
  uItem,
  uSelf,
  Math,
  uFLootItems,

  uBase16and64,
  uRegex,
  uBBotAddresses,
  uBProfiler,
  uEngine,
  uTibiaProcess,
  mmSystem,
  uTibiaState,

  uBBotClientTools,

  RegularExpressions,
  System.UITypes;

{$R *.dfm}

procedure TFMain.InitializeFrames;
begin
  AdvancedAttackFrame := TAdvancedAttackFrame(InsertFrame(gbAdvancedAttack,
    TAdvancedAttackFrame));
  CavebotFrame := TCavebotFrame(InsertFrame(gbCavebot, TCavebotFrame));
  DebugFrame := TDebugFrame(InsertFrame(gbDebug, TDebugFrame));
  ReconnectManagerFrame := TReconnectManagerFrame(InsertFrame(gbBotManager,
    TReconnectManagerFrame));
  UserErrorFrame := TUserErrorFrame(InsertFrame(gbUserError, TUserErrorFrame));
  MacrosFrame := TMacrosFrame(InsertFrame(gbMacros, TMacrosFrame));
  LooterFrame := TLooterFrame(InsertFrame(gbLooter, TLooterFrame));
  WarNetFrame := TWarNetFrame(InsertFrame(gbWarNet, TWarNetFrame));
  DebugWalkerFrame := TDebugWalkerFrame(InsertFrame(gbDebugWalker,
    TDebugWalkerFrame));
  KillerFrame := TKillerFrame(InsertFrame(gbKiller, TKillerFrame));
  SpecialSQMsFrame := TSpecialSQMsFrame(InsertFrame(gbSpecialSQMs,
    TSpecialSQMsFrame));
  FriendHealerFrame := TFriendHealerFrame(InsertFrame(gbFriendHealer,
    TFriendHealerFrame));
  AttackSequencesFrame := TAttackSequencesFrame(InsertFrame(gbAtkSequences,
    TAttackSequencesFrame));
  ManaToolsFrame := TManaToolsFrame(InsertFrame(gbManaTools, TManaToolsFrame));
  HealerFrame := THealerFrame(InsertFrame(gbHealer, THealerFrame));
  VariablesFrame := TVariablesFrame(InsertFrame(gbVariables, TVariablesFrame));
end;

procedure TFMain.InitializeItemSelector;
begin
  BBotItemSelector := TBBotItemSelector.GetInstance;
end;

function TFMain.MutexAcquire: BBool;
begin
  Result := FMutex.WaitFor(1000) = wrSignaled;
end;

procedure TFMain.MutexRelease;
begin
  FMutex.Release;
end;

function TFMain.MutexScopped(const AProc: BProc): BBool;
begin
  if MutexAcquire then
  begin
    AProc();
    MutexRelease;
    Exit(True);
  end
  else
  begin
    Exit(False);
  end;
end;

procedure TFMain.AddBBotMessage(AMessage: TBBotGUIMessage);
begin
  PostMessage(Handle, WM_BBOTMESSAGE, NativeUInt(AMessage), 0);
end;

procedure TFMain.AddDebug(const AText: BStr);
begin
  DebugFrame.Add(AText);
end;

procedure TFMain.AddProfilerData(const AParent: BStr;
  const AAction: TBBotAction);
var
  Name: BStr;
  Profiler: BProfiler;
  Item: TListItem;
begin
  Name := BIf(AParent <> '', AParent + '.', '') + AAction.ActionName;
  Profiler := AAction.ActionProfiler;
  Item := lvProfilers.Items.Add;

  Item.Caption := Name;
  Item.SubItems.Add(BFormat('%d', [Profiler.Calls]));
  Item.SubItems.Add(BFormat('%.4f', [Profiler.Total]));
  Item.SubItems.Add(BFormat('%.4f', [Profiler.Avg]));
  Item.SubItems.Add(BFormat('%.4f', [Profiler.Max]));
  if AAction is TBBotActions then
    (AAction as TBBotActions).Actions.ForEach
      (procedure(It: BVector<TBBotAction>.It)begin AddProfilerData(Name,
      It^); end);
end;

procedure TFMain.ResizeToBox(GB: TPanel);
begin
  GB.Top := 3;
  GB.Left := vstMenu.ClientWidth + 3 + GetSystemMetrics(SM_CXVSCROLL);
  Self.ClientHeight := Max(GB.ClientHeight, gbCavebot.ClientHeight) + 6
    + GB.Top;
  vstMenu.ClientHeight := Self.ClientHeight;
  Self.ClientWidth := GB.Left + GB.ClientWidth + 10;
end;

procedure ListFilesToList(FileMask: BStr; List: TStrings);
var
  SR: TSearchRec;
  IsFound: Boolean;
  FileName: BStr;
  ExtLen, I: BInt32;
begin
  I := Length(FileMask);
  ExtLen := I;
  while (I > 0) and (not((FileMask[I] = '/') or (FileMask[I] = '\'))) do
  begin
    if FileMask[I] = '.' then
      ExtLen := I;
    Dec(I);
  end;
  ExtLen := Length(FileMask) - ExtLen + 1;
  IsFound := FindFirst(FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do
  begin
    FileName := SR.Name;
    List.Add(BStrLeft(FileName, Length(FileName) - ExtLen));
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);
end;

function ListFiles(FileMask: BStr): BStrArray;
var
  SR: TSearchRec;
begin
  SetLength(Result, 0);
  if FindFirst(FileMask, faAnyFile - faDirectory, SR) = 0 then
    repeat
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := SR.Name;
    until FindNext(SR) <> 0;
  FindClose(SR);
end;

procedure TFMain.AskConfigFile(Sender: TObject; Title, Ext: BStr;
  OnOk: TOnOkConfig);
begin
  SaveLoadExt := Ext;
  lblSettingsTitle.Caption := Title;
  CallbackOnOk := OnOk;
  lstConfigs.Items.Clear;
  edtConfig.Text := '';
  ListFilesToList(BotPath + 'Configs/*.bbot', lstConfigs.Items);
  ShowGroupBox(gbSettingFile);
end;

procedure TFMain.BasicToolsSettings(Sender: TObject);
  procedure SetBasicFeatures;
  begin
    Tibia.XRay(chkXRay.Checked);
    BBot.Stats.LevelSpy := chkLevelSpy.Checked;
    BBot.EatFood.Enabled := chkEat.Checked;
    BBot.EatFoodGround.Enabled := chkEatFoodGround.Checked;
    BBot.AutoStack.Enabled := chkGroup.Checked;
    BBot.AntiAfk.Enabled := chkAntiIDLE.Checked;
    BBot.Fishing.Capacity := BStrTo32(numFisherCap.Text, 0);
    BBot.Fishing.Worms := chkFishingWorm.Checked;
    BBot.Fishing.Enabled := chkFishing.Checked;
    BBot.OTMoney.Enabled := chkOtMoney.Checked;
    BBot.Backpacks.Enabled := chkAutoOpenBP.Checked;
    BBot.Backpacks.Minimizer := chkAutoMinimizeBP.Checked;
    BBot.Backpacks.InventoryMinimized := chkAutoMinimizeBPsInventory.Checked;
    BBot.Backpacks.GetPremiumMinimized :=
      chkAutoMinimizeBPsMinimizedGetPremium.Checked;
    BBot.Reconnect.Enabled := chkReconnect.Checked;
    BBot.ServerSave.Hour := BStrTo32(numSSLogoutHH.Text, 0);
    BBot.ServerSave.Minute := BStrTo32(numSSLogoutMM.Text, 0);
    BBot.ServerSave.Enabled := chkServerSaveLogout.Checked;
    BBot.Framerate.Enabled := chkFrameRate.Checked;
    BBot.Lighthack.Power := BInt32(ComboSelectedObj(cmbLightHack));
    BBot.DropVials.Enabled := chkAutoDropVials.Checked;
    BBot.AmmoCounter.Enabled := chkAmmoCounter.Checked;
    BBot.Walker.MapClick := chkMapClick.Checked;
  end;
  procedure SetHUDInformations;
  begin
    BBot.WarBot.CreatureLevels := chkCLevels.Checked;
    BBot.WarBot.PlayerGroups := chkPlayerGroups.Checked;
    BBot.Stats.MagicWallsHUD := chkHUDmwalls.Checked;
    BBot.Stats.SpellsHUD := chkHUDspells.Checked;
    BBot.Stats.ScreenShootOnAdvancements := chkSS.Checked;
    BBot.Stats.SkillsGotInformations := chkAdvanced.Checked;
    BBot.Stats.ExpGotInformations := chkGotInfo.Checked;
    BBot.Stats.ExpInformations := chkExp.Checked;
    BBot.Stats.AutoShowStatistics := chkAutoStatistics.Checked;
    BBot.Stats.LootHUD := chkLootHUD.Checked;
  end;
  procedure SetProtectors;
  var
    I: BInt32;
  begin
    BBot.Protectors.ClearProtectors;
    if chkProtectorsActive.Checked then
      for I := 0 to lstProtectors.Count - 1 do
        BBot.Protectors.AddProtector(lstProtectors.Items.Strings[I]);
  end;
  procedure SetTrader;
  begin
    BBot.TradeWatcher.Words := edtTHwatch.Text;
    BBot.TradeWatcher.Enabled := chkTHwatch.Checked;
    BBot.Trader.Text := edtTHmsg.Text;
    BBot.Trader.Say := chkTHmsgsay.Checked and (edtTHmsg.Text <> '');
    BBot.Trader.Yell := chkTHmsgyell.Checked and (edtTHmsg.Text <> '');
    BBot.Trader.TradeChannel := chkTHmsg.Checked and (edtTHmsg.Text <> '');
  end;

begin
  CheckInt(numFisherCap, chkFishing, False);
  CheckInt(numSSLogoutHH, chkServerSaveLogout, False);
  CheckInt(numSSLogoutMM, chkServerSaveLogout, False);
  if Length(edtTHwatch.Text) < 2 then
    chkTHwatch.Checked := False;
  if Length(edtTHmsg.Text) < 2 then
  begin
    chkTHmsg.Checked := False;
    chkTHmsgyell.Checked := False;
  end;
  edtTHmsg.Enabled := not(chkTHmsg.Checked or chkTHmsgyell.Checked or
    chkTHmsgsay.Checked);
  edtTHwatch.Enabled := not chkTHwatch.Checked;
  if (Sender = chkLevelSpy) and (chkLevelSpy.Checked) and
    (AdrSelected >= TibiaVer1021) then
  begin
    ShowMessage('Level spy is disabled for this version.');
    chkLevelSpy.Checked := False;
  end;
  if (Sender = chkAutoMinimizeBPsInventory) and
    (chkAutoMinimizeBPsInventory.Checked) and (AdrSelected >= TibiaVer1000) then
    ShowMessage('Warning!' + BStrLine +
      'Please minimize your inventory otherwise' + BStrLine +
      'the BBot may active a wrong PVP mode making' + BStrLine +
      'you be a red skull and losing items.');
  OTSafe(Sender);
  if MutexAcquire then
  begin
    SetBasicFeatures;
    SetHUDInformations;
    SetProtectors;
    SetTrader;
    MutexRelease;
  end;
  numSSLogoutHH.Enabled := not BBot.ServerSave.Enabled;
  numSSLogoutMM.Enabled := not BBot.ServerSave.Enabled;
  numFisherCap.Enabled := not BBot.Fishing.Enabled;
  chkFishingWorm.Enabled := not BBot.Fishing.Enabled;
  btnProtector.Enabled := not chkProtectorsActive.Checked;
  lstProtectors.Enabled := not chkProtectorsActive.Checked;
end;

procedure TFMain.btnConfigClick(Sender: TObject);
begin
  OnPopupClose(Sender);
end;

procedure TFMain.btnRateSendClick(Sender: TObject);
var
  S: BStr;
  procedure AddPostData(N, V: BStr);
  begin
    S := S + N + '=' + UrlEncode(V, True) + '&';
  end;

begin
  if cmbRateStars.ItemIndex > 0 then
  begin
    if MessageDlg
      (BFormat('Please review your message:\nStars: %d\nMessage:\n%s',
      [cmbRateStars.ItemIndex, memoRateReview.Text]), mtConfirmation,
      mbOKCancel, 0, mbCancel) = mrOk then
    begin
      S := '';
      AddPostData('id', BFormat('%d', [0]));
      AddPostData('stars', BFormat('%d', [cmbRateStars.ItemIndex]));
      AddPostData('review', memoRateReview.Text);
      AddPostData('email', '');
      btnRateSend.Enabled := False;
      btnRateSend.Caption := 'Review sent';
      DownloadURL(BBotApiUrl('review'), S, OnRateResult, nil);
    end;
  end
  else
    ShowMessage('Please select a stars to rate the BBot.');
end;

procedure TFMain.btnResetStatistics(Sender: TObject);
begin
  if MutexAcquire then
  begin
    BBot.Stats.ResetStatistics;
    MutexRelease;
  end;
end;

function TFMain.CheckFileSave(FileName: BStr): Boolean;
begin
  Result := False;
  if not FileExists(FileName) then
    Result := True
  else if MessageDlg('The file already exists. Do you want to overwrite it?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Result := True;
  end;
end;

procedure TFMain.CheckInt(AMemo: TMemo; AMessage: BStr; APercent: BBool);
begin
  if ((not APercent) and (BStrTo32(AMemo.Text, MaxInt) = MaxInt)) or
    ((APercent) and (not BInRange(BStrTo32(AMemo.Text, MaxInt), 1, 100))) then
    ShowMessage(AMessage);
end;

procedure TFMain.CheckInt(AMemo: TMemo; ACheck: TCheckBox; APercent: BBool);
begin
  if ((not APercent) and (BStrTo32(AMemo.Text, MaxInt) = MaxInt)) or
    ((APercent) and (not BInRange(BStrTo32(AMemo.Text, MaxInt), 1, 100))) then
    ACheck.Checked := False;
end;

procedure TFMain.AutomationToolsSettings(Sender: TObject);
  procedure SetEnchanter;
  begin
    BBot.Enchanter.Use := BIf(rbEnchanterUseBlank.Checked, ItemID_BlankRune,
      ItemID_Spear);
    BBot.Enchanter.Spell := txtEnchanterSpell.Text;
    BBot.Enchanter.Mana := BStrTo32(numEnchanterMana.Text, 0);
    BBot.Enchanter.Soul := BStrTo32(numEnchanterSoul.Text, 0);
    case cmbEnchanterHand.ItemIndex of
      0:
        BBot.Enchanter.Hand := SlotLeft;
      1:
        BBot.Enchanter.Hand := SlotRight;
    else
      BBot.Enchanter.Hand := SlotLastClicked;
    end;
    BBot.Enchanter.Enabled := chkEnchanter.Checked;
  end;
  procedure SetTrainers;
  begin
    BBot.Trainer.Slime := chkSlimeTrain.Checked;
    BBot.Trainer.HP := chkHPTrain.Checked;
    BBot.Trainer.HPMin := BStrTo32(TrainerHPMin.Text, 30);
    BBot.Trainer.HPMax := BStrTo32(TrainerHPMax.Text, 90);
  end;

begin
  CheckInt(TrainerHPMin, chkHPTrain, True);
  CheckInt(TrainerHPMax, chkHPTrain, True);
  CheckInt(numEnchanterMana, chkEnchanter, False);
  CheckInt(numEnchanterSoul, chkEnchanter, False);
  if Length(txtEnchanterSpell.Text) <= 2 then
    chkEnchanter.Checked := False;

  if (Sender = chkHPTrain) and (chkHPTrain.Checked) then
    chkSlimeTrain.Checked := False;
  if (Sender = chkSlimeTrain) and (chkSlimeTrain.Checked) then
    chkHPTrain.Checked := False;
  if MutexAcquire then
  begin
    SetEnchanter;
    SetTrainers;
    KillerFrame.SetAttacker;
    AttackSequencesFrame.SetAttackSequences;
    CavebotFrame.SetCavebot;
    LooterFrame.SetLooter;
    MutexRelease;
  end;
  rbEnchanterUseBlank.Enabled := not chkEnchanter.Checked;
  rbEnchanterUseSpear.Enabled := not chkEnchanter.Checked;
  txtEnchanterSpell.Enabled := not chkEnchanter.Checked;
  numEnchanterMana.Enabled := not chkEnchanter.Checked;
  numEnchanterSoul.Enabled := not chkEnchanter.Checked;
  cmbEnchanterHand.Enabled := not chkEnchanter.Checked;
  TrainerHPMax.Enabled := not BBot.Trainer.HP;
  TrainerHPMin.Enabled := not BBot.Trainer.HP;
end;

function TFMain.ValidateItemCheckbox(const ID: BInt32;
  const CheckBox: TCheckBox): BBool;
  function ValidateItem(const ID: BInt32): BBool;
  begin
    Result := BInRange(ID, TibiaMinItems, TibiaLastItem);
  end;

var
  OriginalOnClick: TNotifyEvent;
begin
  if CheckBox.Checked then
  begin
    Result := ValidateItem(ID);
    if not Result then
    begin
      OriginalOnClick := CheckBox.OnClick;
      CheckBox.OnClick := nil;
      CheckBox.Checked := False;
      CheckBox.OnClick := OriginalOnClick;
      ShowMessage('Warning! Detected error with item usage for "' +
        CheckBox.Caption +
        '". The selected item is not availabled for the selected Tibia version.');
    end;
  end
  else
    Result := False;
end;

procedure TFMain.HealingToolsSettings(Sender: TObject);
  procedure SetReUserAndCures;
  begin
    BBot.ReUser.Ring.Enabled := chkRUring.Checked;
    BBot.ReUser.Ammunition.Enabled := chkRUammo.Checked;
    BBot.ReUser.LeftHand.Enabled := chkRUleft.Checked;
    BBot.ReUser.RightHand.Enabled := chkRUright.Checked;
    BBot.ReUser.Amulet.Enabled := chkRUamulet.Checked;
    BBot.ReUser.SoftBoots.Enabled := chkRUsoft.Checked;
    BBot.ReUser.Haste.Enabled := chkRUhaste.Checked;
    BBot.ReUser.StrongHaste.Enabled := chkRUshaste.Checked;
    BBot.ReUser.MagicShield.Enabled := chkRUms.Checked;
    BBot.ReUser.Invisible.Enabled := chkRUinvis.Checked;
    BBot.ReUser.Light.Enabled := chkRUlight1.Checked;
    BBot.ReUser.GreatLight.Enabled := chkRUlight2.Checked;
    BBot.ReUser.UltimateLight.Enabled := chkRUlight3.Checked;
    BBot.ReUser.Charge.Enabled := chkRUcharge.Checked;
    BBot.ReUser.Protector.Enabled := chkRUprotector.Checked;
    BBot.ReUser.Sharpshooter.Enabled := chkRUsharpshooter.Checked;
    BBot.ReUser.SwiftFoot.Enabled := chkRUswiftfoot.Checked;
    BBot.ReUser.BloodRage.Enabled := chkRUbloodrage.Checked;
    BBot.ReUser.Recovery.Enabled := chkRUrecovery.Checked;
    BBot.ReUser.IntenseRecovery.Enabled := chkRUintenserecovery.Checked;
    BBot.ReUser.CurePoison.Enabled := chkCurePoison.Checked;
    BBot.ReUser.CureBleeding.Enabled := chkCureBleeding.Checked;
    BBot.ReUser.CureCurse.Enabled := chkCureCurse.Checked;
    BBot.ReUser.CureEletrification.Enabled := chkCureEletrification.Checked;
    BBot.ReUser.CureBurning.Enabled := chkCureBurning.Checked;
    BBot.ReUser.AntiParalysis.Mana := BStrTo32(numCureParalyzeMana.Text, 0);
    BBot.ReUser.AntiParalysis.Spell := edtCureParalyzeSpell.Text;
    BBot.ReUser.AntiParalysis.Enabled := chkCureParalyze.Checked;
  end;

begin
  CheckInt(numCureParalyzeMana, chkCureParalyze, False);

  if MutexAcquire then
  begin
    HealerFrame.SetHealer;
    FriendHealerFrame.SetFriendHealer;
    TManaToolsFrame(ManaToolsFrame).SetManaDrinker;
    TManaToolsFrame(ManaToolsFrame).SetManaTrainer;
    SetReUserAndCures;
    MutexRelease;
  end;
end;

procedure TFMain.chkTrayClick(Sender: TObject);
begin
  TrayIconEnabled := chkTray.Enabled;
end;

procedure TFMain.cmdTreClick(Sender: TObject);
var
  I: BInt32;
begin
  if MutexAcquire then
  begin
    lstTrainers.Clear;
    BBot.Creatures.Traverse(
      procedure(Creature: TBBotCreature)
      begin
        if Creature.IsAlive and (not Creature.IsSelf) and Creature.IsOnScreen
        then
          lstTrainers.AddItem(Creature.Name, TObject(Creature.ID));
      end);
    for I := 0 to lstTrainers.Items.Count - 1 do
      if BBot.Trainer.IsTrainer(BInt32(lstTrainers.Items.Objects[I])) then
        lstTrainers.Checked[I] := True;
    MutexRelease;
  end;
end;

procedure TFMain.btnMacroGetPosClick(Sender: TObject);
begin
  MessageDlg('Your position is:' + #13#10 + BStr(Me.Position), mtInformation,
    [mbOK], 0);
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SettingsManager.SaveToFile('Configs\LastSession.bbot');
  EngineLoad := elDestroying;
end;

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (EngineLoad = elDestroying) or
    (MessageDlg('Are you sure?'#13'This action will close the bot',
    mtInformation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TFMain.FormCreate(Sender: TObject);

  procedure BSetupControls;
  begin
    IterateComponentControls(Self,
      procedure(C: TComponent)
      var
        MM: TMemo;
        onChange: TNotifyEvent;
      begin
        if C is TMemo then
        begin
          MM := C as TMemo;
          if InRange(MM.MaxLength, 1, 10) then
          begin
            onChange := MM.onChange;
            MM.onChange := nil;
            MM.Text := IntToStr(StrToInt(MM.Lines[0]));
            MM.onChange := onChange;
          end;
        end;
        if C.Tag = 1 then
          C.Tag := CRC32(BStr(C.Name));
      end);
  end;

  procedure AddLighthack;
  begin
    cmbLightHack.AddItem('[Lighthack] Disabled', TObject(0));
    cmbLightHack.AddItem('[Lighthack] Light', TObject(6));
    cmbLightHack.AddItem('[Lighthack] Great Light', TObject(8));
    cmbLightHack.AddItem('[Lighthack] Ultimate Light', TObject(11));
    cmbLightHack.AddItem('[Lighthack] Torch', TObject(7));
    cmbLightHack.AddItem('[Lighthack] Magic Lightwand', TObject(8));
    cmbLightHack.AddItem('[Lighthack] Full', TObject(16));
    cmbLightHack.ItemIndex := 0;
  end;

  procedure AddProtector;
  var
    I: TBBotProtectorKind;
  begin
    for I := bpkFirst to bpkLast do
      cmbProtectorKind.Items.AddObject(BBot.Protectors.KindToStr(I),
        TObject(I));
    cmbProtectorKind.ItemIndex := 0;
  end;

begin
  FMutex := TMutex.Create(nil, False, 'bmu' + IntToStr(TibiaProcess.PID));

  CreateMenu;
  InitializeItemSelector;
  InitializeFrames;

{$IFNDEF Release}
  setThisThreadName('BBot.Engine.Interface');
{$ENDIF}
  IgnoreOTWarning := False;

  ProfilersNextShow := 0;

  InviteIdx := 0;
  InviteClr := 0;
  AutoPopup := 0;

  gbCurrent := nil;
  gbLast := nil;
  LstFeatureID := 0;

  BChecked := False;
  AddLighthack;
  AddProtector;

  BSetupControls;

  if not DirectoryExists('Configs') then
    CreateDir('Configs');

  Caption := 'BBot';

  ShowGroupBox(gbBasic);

  MacroEditorCreate;

  SettingsManager := TBBotSettingsManager.Create(Self);

  Show;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  FMutex.Free;
  SettingsManager.Free;
  BBotItemSelector.Free;
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if (Key = Ord('D')) and (ssShift in Shift) and (ssCtrl in Shift) then
    ShowGroupBox(gbDebug);
end;

procedure TFMain.HideBBot1Click(Sender: TObject);
begin
  Visible := False;
end;

procedure TFMain.HideTibia1Click(Sender: TObject);
begin
  ShowWindow(TibiaProcess.hWnd, SW_HIDE);
end;

procedure TFMain.lstCommMeasureItem(Control: TWinControl; Index: Integer;
var Height: BInt32);
begin
  Height := lstAddHeight;
end;

procedure TFMain.lstConfigsClick(Sender: TObject);
begin
  if lstConfigs.ItemIndex <> -1 then
    edtConfig.Text := lstConfigs.Items.Strings[lstConfigs.ItemIndex];
end;

procedure TFMain.lstConfigsDblClick(Sender: TObject);
begin
  if lstConfigs.ItemIndex <> -1 then
  begin
    edtConfig.Text := lstConfigs.Items.Strings[lstConfigs.ItemIndex];
    btnConfigClick(btnConfig);
  end;
end;

procedure TFMain.lstTrainersClickCheck(Sender: TObject);
var
  ID: BInt32;
  Checked: Boolean;
begin
  if lstTrainers.ItemIndex <> -1 then
  begin
    ID := BInt32(lstTrainers.Items.Objects[lstTrainers.ItemIndex]);
    Checked := lstTrainers.Checked[lstTrainers.ItemIndex];
    if MutexAcquire then
    begin
      if Checked then
        BBot.Trainer.Add(ID)
      else
        BBot.Trainer.Remove(ID);
      MutexRelease;
    end;
  end;
end;

procedure TFMain.lstTrainersDrawItem(Control: TWinControl; Index: Integer;
Rect: TRect; State: TOwnerDrawState);
var
  CreatureID: BUInt32;
  Text: BStr;
  HP: BInt32;
  HPCor: TColor;
  Creature: TBBotCreature;
begin
  if not InRange(Index, 0, lstTrainers.Count - 1) then
    Exit;
  Text := lstTrainers.Items[Index];
  CreatureID := BUInt32(lstTrainers.Items.Objects[Index]);
  HP := 100;
  Creature := BBot.Creatures.Find(CreatureID);
  if Creature <> nil then
    HP := Creature.Health;
  HPCor := HPColor(HP);
  Text := Text + ' (' + IntToStr(HP) + '%)';

  if odSelected in State then
  begin
    lstTrainers.Canvas.Brush.Color := clHighlight;
    lstTrainers.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    lstTrainers.Canvas.Brush.Color := lstTrainers.Color;
    lstTrainers.Canvas.Font.Color := lstTrainers.Font.Color;
  end;
  lstTrainers.Canvas.FillRect(Rect);
  InflateRect(Rect, -2, -2);
  lstTrainers.Canvas.Font.Color := HPCor;
  lstTrainers.Canvas.TextOut(((Rect.Right - Rect.Left) div 2) -
    (lstTrainers.Canvas.TextWidth(Text) div 2), Rect.Top + 1, Text);

  Rect.Top := Rect.Top + lstTrainers.Canvas.TextHeight('|');
  InflateRect(Rect, -25, -1);
  InflateRect(Rect, -1, -1);

  lstTrainers.Canvas.Brush.Color := clBlack;
  lstTrainers.Canvas.FillRect(Rect);
  InflateRect(Rect, -1, -1);
  Dec(Rect.Right, Round(((Rect.Right - Rect.Left) / 100) * (100 - HP)));
  lstTrainers.Canvas.Brush.Color := HPCor;
  lstTrainers.Canvas.FillRect(Rect);
end;

procedure TFMain.lvProfilersCompare(Sender: TObject; Item1, Item2: TListItem;
Data: Integer; var Compare: Integer);
var
  A, B: BFloat;
begin
  A := BStrToFloat(Item1.SubItems[1]);
  B := BStrToFloat(Item2.SubItems[1]);
  Compare := BCeil(B) - BCeil(A);
end;

procedure TFMain.OnLoadConfigOk(FileName: BStr);
begin
  IgnoreOTWarning := True;
  if MutexAcquire then
  begin
    SettingsManager.LoadFromFile(FileName);
    LoadMigrations();
    BasicToolsSettings(Self);
    HealingToolsSettings(Self);
    AutomationToolsSettings(Self);
    WarToolsSettings(Self);
    AdvancedToolsSettings(Self);
    SetTrayIconEnabled(chkTray.Checked);
    AdvancedAttackFrame.AdvancedAttackSettings;
    VariablesFrame.ApplyVariables;
    MutexRelease;
  end;
  IgnoreOTWarning := False;
  FLootItems.Load(mmLooter.Lines.Text);
end;

procedure TFMain.OnPopupClose(Sender: TObject);
begin
  if (Sender as TButton).Caption <> 'Cancel' then
    if edtConfig.Text <> '' then
      CallbackOnOk(BotPath + 'Configs/' + edtConfig.Text + '.' + SaveLoadExt);
  ShowGroupBox(gbLast);
end;

procedure TFMain.OnRateResult(State: TLoadURLState; Data: BStr);
begin
  ShowMessage('Your review was sent sucefully, thank you and have fun!');
end;

procedure TFMain.OnSaveConfigOk(FileName: BStr);
begin
  if CheckFileSave(FileName) then
  begin
    mmLooter.Lines.Text := FLootItems.Save;
    SettingsManager.SaveToFile(FileName);
  end;
end;

procedure TFMain.OnTrayClick(var Msg: TMessage);
var
  P: TPoint;
begin
  case Msg.LParam of
    WM_LBUTTONDOWN:
      ShowTibia1Click(nil);
    WM_MBUTTONDOWN:
      ;
    WM_RBUTTONDOWN:
      begin
        SetForegroundWindow(Handle);
        GetCursorPos(P);
        PopTray.Popup(P.X, P.Y);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;
  end;
end;

procedure TFMain.ShowBBot1Click(Sender: TObject);
begin
  Visible := True;
end;

procedure TFMain.ShowGroupBox(GB: TPanel);
begin
  if GB = gbCurrent then
    Exit;
  gbLast := gbCurrent;

  AutoPopup := 0;

  ResizeToBox(GB);

  if Assigned(gbCurrent) and (gbCurrent <> GB) then
  begin
    gbCurrent.Left := Self.Width + 20;
    gbCurrent.Visible := False;
  end;
  gbCurrent := GB;

  GB.Visible := True;
end;

procedure TFMain.ShowGroupBoxLast;
begin
  ShowGroupBox(gbLast);
end;

procedure TFMain.ShowTibia1Click(Sender: TObject);
begin
  ShowWindow(TibiaProcess.hWnd, SW_SHOWMAXIMIZED);
end;

procedure TFMain.LinkEnter(Sender: TObject);
begin
  OnLinkLabelEnter(Sender);
end;

procedure TFMain.LinkLeave(Sender: TObject);
begin
  OnLinkLabelLeave(Sender);
end;

procedure TFMain.AdvancedAttackManageAtkSequencesClick(Sender: TObject);
begin
  ShowGroupBox(gbAtkSequences);
end;

procedure TFMain.MigrateAttackAdvAtk;
begin
  KillerFrame.MigrateAdvAttacks;
end;

procedure TFMain.LoadMigrations;
begin
  MigrateAttackAdvAtk;
end;

procedure TFMain.SetClipboard(Text: BStr);
var
  S: string;
begin
  S := Text;
  Clipboard.Clear;
  Clipboard.SetTextBuf(@S[1]);
end;

procedure TFMain.SetTrayIconEnabled(const Value: BBool);
begin
  if FTrayIconEnabled <> Value then
  begin
    FTrayIconEnabled := Value;
    TrayData.cbSize := SizeOf(TrayData);
    TrayData.Wnd := Handle;
    TrayData.uID := 0;
    TrayData.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    TrayData.uCallbackMessage := WM_TRAYCLICK;
    TrayData.hIcon := Application.Icon.Handle;
    StrPCopy(TrayData.szTip, Me.Name);
    Shell_NotifyIcon(BIf(Value, NIM_ADD, NIM_DELETE), @TrayData);
  end;
end;

procedure TFMain.btnKillerNewCancelClick(Sender: TObject);
begin
  ShowGroupBox(gbKiller);
end;

procedure TFMain.OTSafe(Sender: TObject);
var
  SaveOnClick: TNotifyEvent;
  Chk: TCheckBox;
begin
  if IgnoreOTWarning then
    Exit;
  if (Sender is TCheckBox) then
  begin
    Chk := Sender as TCheckBox;
    if (Pos('[OT]', Chk.Caption) > 0) and Chk.Checked then
      if MessageDlg('Warning!' + #13#10 +
        'This feature is a [OTserver] only feature!' + #13#10 + #13#10 +
        'Continue?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      begin
        SaveOnClick := Chk.OnClick;
        Chk.OnClick := nil;
        Chk.Checked := False;
        Chk.OnClick := SaveOnClick;
        Exit;
      end;
  end;
end;

procedure TFMain.btnDoReconnectClick(Sender: TObject);
begin
  Engine.Reconnect := True;
end;

procedure TFMain.WarToolsSettings(Sender: TObject);
  procedure SetWarbot;
  begin
    BBot.WarBot.Dash := chkDash.Checked;

    BBot.WarBot.LockTarget := chkLockTarget.Checked;
    BBot.SuperFollow.AutoTrack := chkSuperFollow.Checked;

    BBot.WarBot.ComboLeaders := edtLeaders.Text;
    BBot.WarBot.ComboSetAttack := chkWBCattack.Checked;
    BBot.WarBot.ComboSay := chkComboSay.Checked;
    BBot.WarBot.ComboSayText := edtComboSay.Text;
    BBot.WarBot.ComboParalyzedEnemies := chkWCBparalyzed.Checked;
    BBot.WarBot.ComboAttackCode := cmbCombo.Text;
    BBot.WarBot.Combo := chkWBCActive.Checked;

    BBot.WarBot.PushParalyzedEnemies := chkPushParalyed.Checked;
    BBot.WarBot.MarkAlliesAndEnemies := chkMarkAlliesAndenemies.Checked;
    BBot.WarBot.AutoAttackEnemies := chkAutoAttackEnemies.Checked;
    BBot.WarBot.MWallOnFrontOfEnemies := chkMWallFrontEnemies.Checked;

    BBot.WarBot.MarkPartyMembersAsAlly := chkAllyParty.Checked;
    BBot.WarBot.MarkPlayersAsEnemy := chkEnemyNoAlly.Checked;

    BBot.WarBot.AimBotRunesCode[1] := cmbAim1.Text;
    BBot.WarBot.AimBotRunesCode[2] := cmbAim2.Text;
    BBot.WarBot.AimBotRunesCode[3] := cmbAim3.Text;
    BBot.WarBot.AimbotIndex := 1;
    BBot.WarBot.Aimbot := chkAim.Checked;

    BBot.WarBot.LoadAlliesAndEnemies(memoAllies.Lines, memoEnemies.Lines);
  end;

begin
  if chkDash.Checked and (AdrSelected = TibiaVerLast) then
  begin
    if MessageDlg('Confirmation,' + BStrLine +
      'The Dash feature is highly detectable.' + BStrLine +
      'Are you sure you want to enable this option and run the risk ' + BStrLine
      + 'of losing your account in the game?', mtConfirmation, mbYesNo, 0) = mrNo
    then
      chkDash.Checked := False;
  end;
  if MutexAcquire then
  begin
    SetWarbot;
    MutexRelease;
  end;
end;

procedure TFMain.cmbAim1Click(Sender: TObject);
begin
  chkAim.Checked := False;
end;

procedure TFMain.MacroList(Sender: TObject);
var
  I: BInt32;
  List: TStrings;
begin
  List := (Sender as TComboBox).Items;
  List.Clear;
  List.Add('Manage macros');
  List.Add('Create new macro');
  for I := 0 to MacrosFrame.lstMacros.Items.Count - 1 do
    List.Add(BStrBetween(MacrosFrame.lstMacros.Items.Strings[I], '{', '}'));
end;

procedure TFMain.edtComboSpellClick(Sender: TObject);
begin
  chkWBCActive.Checked := False;
end;

procedure TFMain.btnBlockedSQMsDoneClick(Sender: TObject);
begin
  ShowGroupBox(gbKiller);
end;

procedure TFMain.lblEnemiesAndAlliesClick(Sender: TObject);
begin
  ShowGroupBox(gbAlliesAndEnemies);
end;

procedure TFMain.btnAlliesAndEnemiesOKClick(Sender: TObject);
begin
  ShowGroupBox(gbWarbot);
end;

procedure TFMain.OnKeyPressNumOnly(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, [#8, '0' .. '9']) then
    Exit;
  Key := #0;
end;

procedure TFMain.Label100Click(Sender: TObject);
begin
  DoOpenURL('http://wiki.bmega.net/');
end;

procedure TFMain.Label101Click(Sender: TObject);
begin
  DoOpenURL('http://forums.bmega.net/');
end;

procedure TFMain.CreateMenu;
  function AddMenuItem(Parent: PVirtualNode; Text: BStr; Hint: BStr;
  Panel: TPanel; Image: BInt32 = -1; Link: BBool = False): PVirtualNode;
  var
    I: BInt32;
  begin
    SetLength(FMainBBotMenu, Length(FMainBBotMenu) + 1);
    I := High(FMainBBotMenu);
    Result := vstMenu.AddChild(Parent);
    BPInt32(vstMenu.GetNodeData(Result))^ := I;
    FMainBBotMenu[I].Text := Text;
    FMainBBotMenu[I].Hint := Hint;
    FMainBBotMenu[I].Panel := Panel;
    FMainBBotMenu[I].Image := Image;
    FMainBBotMenu[I].Link := Link;
  end;

var
  Node: PVirtualNode;
begin
  vstMenu.NodeDataSize := SizeOf(BInt32);
  vstMenu.BeginUpdate;

  Node := nil;
  Node := AddMenuItem(Node, '-', 'Basic Tools', nil, -1);
  AddMenuItem(Node, 'Basic Functions', 'Lots of tools', gbBasic, 13);
  AddMenuItem(Node, 'HUD && Informations', 'Statistics center', gbHUD, 21);
  AddMenuItem(Node, 'Protector', 'BBot shield', gbProtector, 8);
  AddMenuItem(Node, 'Trade Helper', 'Easy money', gbTradeHelper, 17);
  vstMenu.Expanded[Node] := True;

  Node := nil;
  Node := AddMenuItem(Node, '-', 'Healing Tools', nil, -1);
  AddMenuItem(Node, 'Friend Healer', 'Save your friends', gbFriendHealer, 16);
  AddMenuItem(Node, 'Healer', 'Do not get killed', gbHealer, 6);
  AddMenuItem(Node, 'Mana Tools', 'High mana always', gbManaTools, 7);
  AddMenuItem(Node, 'Re-User && Cures', 'No forget', gbReUserCures, 11);

  Node := nil;
  Node := AddMenuItem(Node, '-', 'Automation Tools', nil, -1);
  AddMenuItem(Node, 'Enchanter', 'The cheap runes', gbEnchanter, 4);
  AddMenuItem(Node, 'Trainer', 'Fast skills', gbTrainer, 9);
  AddMenuItem(Node, 'Killer', 'Destroy the creatures', gbKiller, 2);
  AddMenuItem(Node, 'Cavebot', 'Get over your opponents', gbCavebot, 10);
  AddMenuItem(Node, 'Looter', 'Be quick', gbLooter, 5);
  AddMenuItem(Node, 'Reconnect Manager', 'To manage multiple characters',
    gbBotManager, 24);

  Node := nil;
  Node := AddMenuItem(Node, '-', 'War Tools', nil, -1);
  AddMenuItem(Node, 'Basic War', 'Kill them', gbWarbot, 12);
  AddMenuItem(Node, 'War.NET', 'Co-Op with your friends', gbWarNet, 18);
  AddMenuItem(Node, 'Allies && Enemies', 'They are different',
    gbAlliesAndEnemies, 22);

  Node := nil;
  Node := AddMenuItem(Node, '-', 'Advanced Tools', nil, -1);
  AddMenuItem(Node, 'Macros', 'No limits', gbMacros, 14);
  AddMenuItem(Node, 'Macro Editor', 'Create macros', gbMacroEditor, 15);
  AddMenuItem(Node, 'Variables', 'Customize the globals', gbVariables, 23);
  AddMenuItem(Node, 'Special SQMs', 'Help me get smarter', gbSpecialSQMs, 3);

  Node := nil;
  Node := AddMenuItem(Node, '-', 'Settings', nil, -1);
  AddMenuItem(Node, '-', 'Load', nil, 1);
  AddMenuItem(Node, '-', 'Save', nil, 2);

  Node := nil;
  Node := AddMenuItem(Node, '-', 'Links', nil, -1);

  AddMenuItem(Node, '-', 'BBot Telegram Group', nil, 109, True);

  AddMenuItem(Node, '-', 'Advanced Attack', gbAdvancedAttack, -1, True);

  AddMenuItem(Node, '-', 'Client Tools', nil, 104, True);
  AddMenuItem(Node, '-', 'Website', nil, 100, True);
  AddMenuItem(Node, '-', 'Documentation', nil, 101, True);
  AddMenuItem(Node, '-', 'Forums', nil, 103, True);
  AddMenuItem(Node, '-', 'Debug', gbDebug, -1, True);
  LinksNode := Node;
  vstMenu.Expanded[LinksNode] := True;

  vstMenu.EndUpdate;
end;

procedure TFMain.vstMenuBeforeCellPaint(Sender: TBaseVirtualTree;
TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
const
  mnuGradientA = $FEE6CB;
  mnuGradientB = $F3D7B7;
  mnusGradientA = $FEEBD6;
  mnusGradientB = $FEF1E3;
var
  Data: BPInt32;
  sRgn: HRGN;
  R: TRect;
  H: BInt32;
begin
  H := CellRect.Bottom - CellRect.Top;
  Data := vstMenu.GetNodeData(Node);
  TargetCanvas.Brush.Style := bsSolid;
  TargetCanvas.Brush.Color := vstMenu.Color;
  TargetCanvas.FillRect(CellRect);
  if Node.Parent <> vstMenu.RootNode then
  begin
    if vsSelected in Node.States then
    begin
      sRgn := CreateRoundRectRgn(CellRect.Left + 2, CellRect.Top,
        CellRect.Right - 2, CellRect.Bottom, 6, 6);
      SelectClipRgn(TargetCanvas.Handle, sRgn);
      R := CellRect;
      Dec(R.Bottom, H div 2);
      FillGradient(TargetCanvas.Handle, R, 256, mnuGradientA, mnuGradientB,
        gdVertical);
      Inc(R.Bottom, H div 2);
      Inc(R.Top, H div 2);
      FillGradient(TargetCanvas.Handle, R, 256, mnuGradientB, mnuGradientA,
        gdVertical);
      SelectClipRgn(TargetCanvas.Handle, 0);
      TargetCanvas.Pen.Color := mnuGradientB;
      TargetCanvas.Brush.Style := bsClear;
      TargetCanvas.RoundRect(CellRect.Left + 2, CellRect.Top,
        CellRect.Right - 2, CellRect.Bottom, 6, 6);
    end;
    if FMainBBotMenu[Data^].Text <> '-' then
      imgMenu.Draw(TargetCanvas, CellRect.Left + 5,
        CellRect.Top + Round(((CellRect.Bottom - CellRect.Top) / 2) -
        (imgMenu.Height / 2)), FMainBBotMenu[Data^].Image);
  end
  else
  begin
    if Node.ChildCount <> 0 then
    begin
      sRgn := CreateRoundRectRgn(CellRect.Left + 2, CellRect.Top,
        CellRect.Right - 2, CellRect.Bottom, 2, 2);
      SelectClipRgn(TargetCanvas.Handle, sRgn);
      R := CellRect;
      Dec(R.Bottom, H div 2);
      FillGradient(TargetCanvas.Handle, R, 256, mnusGradientA, mnusGradientB,
        gdVertical);
      Inc(R.Bottom, H div 2);
      Inc(R.Top, H div 2);
      FillGradient(TargetCanvas.Handle, R, 256, mnusGradientB, mnusGradientA,
        gdVertical);
      SelectClipRgn(TargetCanvas.Handle, 0);
    end;
  end;
end;

procedure TFMain.vstMenuDrawText(Sender: TBaseVirtualTree;
TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
const Text: String; const CellRect: TRect; var DefaultDraw: Boolean);
var
  Data: BPInt32;
  R: TRect;
  H: BInt32;
begin
  DefaultDraw := False;
  R := CellRect;
  Inc(R.Top, 2);
  Dec(R.Bottom, 2);
  H := R.Bottom - R.Top;
  Data := vstMenu.GetNodeData(Node);
  TargetCanvas.Font.Style := [fsBold];
  TargetCanvas.Font.Color := clBlack;
  if Node = vstMenu.HotNode then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsUnderline];
  if FMainBBotMenu[Data^].Text <> '-' then
  begin
    Dec(R.Bottom, H div 2);
    DrawText(TargetCanvas.Handle, BPChar(@FMainBBotMenu[Data^].Text[1]),
      Length(FMainBBotMenu[Data^].Text), R, DT_LEFT or
      DT_EXTERNALLEADING or DT_TOP);
    Inc(R.Bottom, H div 2);
    Inc(R.Top, H div 2);
    TargetCanvas.Font.Style := [];
    DrawText(TargetCanvas.Handle, BPChar(@FMainBBotMenu[Data^].Hint[1]),
      Length(FMainBBotMenu[Data^].Hint), R, DT_LEFT or
      DT_EXTERNALLEADING or DT_TOP);
  end
  else
  begin
    if FMainBBotMenu[Data^].Link then
      TargetCanvas.Font.Color := clBlue;
    DrawText(TargetCanvas.Handle, BPChar(@FMainBBotMenu[Data^].Hint[1]),
      Length(FMainBBotMenu[Data^].Hint), R, DT_LEFT or
      DT_EXTERNALLEADING or DT_TOP);
  end;
end;

procedure TFMain.vstMenuChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: BPInt32;
begin
  if Assigned(Node) then
  begin
    Data := vstMenu.GetNodeData(Node);
    if Assigned(FMainBBotMenu[Data^].Panel) then
      ShowGroupBox(FMainBBotMenu[Data^].Panel)
    else if FMainBBotMenu[Data^].Text = '-' then
    begin
      case FMainBBotMenu[Data^].Image of
        001:
          AskConfigFile(Sender, 'Load Settings', 'bbot', OnLoadConfigOk);
        002:
          AskConfigFile(Sender, 'Save Settings', 'bbot', OnSaveConfigOk);
      end;
    end;
  end;
end;

procedure TFMain.FormPaint(Sender: TObject);
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.Brush.Color := vstMenu.Color;
  Canvas.FillRect(R);
  Inc(R.Left, vstMenu.ClientWidth);
  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := TColor(BInt32(vstMenu.Color) - $2A2A2A);
  Canvas.Polyline([Point(R.Left, R.Top), Point(R.Left + 2, R.Bottom)]);
end;

procedure TFMain.vstMenuCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
var Allowed: Boolean);
begin
  Allowed := (Node <> LinksNode);
end;

procedure TFMain.vstMenuMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: BInt32);
var
  Data: BPInt32;
  Node: PVirtualNode;
begin
  if Button <> mbLeft then
    Exit;
  Node := vstMenu.HotNode;
  if Assigned(Node) then
  begin
    Data := vstMenu.GetNodeData(Node);
    if FMainBBotMenu[Data^].Text = '-' then
    begin
      case FMainBBotMenu[Data^].Image of
        100:
          DoOpenURL('https://bbot.bmega.net/');
        101:
          DoOpenURL('https://wiki.bmega.net/');
        103:
          DoOpenURL('https://forums.bmega.net/');
        104:
          BBotClientToolsPopup(X, Y, Self);
        109:
          DoOpenURL('https://bbot.bmega.net/telegram.html');
      end;
    end;
  end;
end;

function TFMain.GetClipboard: BStr;
begin
  Result := BStr(Clipboard.AsText);
end;

procedure TFMain.vstMenuMeasureItem(Sender: TBaseVirtualTree;
TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: BInt32);
var
  Data: BPInt32;
begin
  if (Node <> nil) and (Node <> vstMenu.RootNode) then
  begin
    Data := vstMenu.GetNodeData(Node);
    if Data <> nil then
    begin
      if FMainBBotMenu[Data^].Text <> '-' then
        NodeHeight := vstMenu.DefaultNodeHeight * 2
      else
        NodeHeight := vstMenu.DefaultNodeHeight
    end;
    Exit;
  end;
  Exclude(Node.States, vsHeightMeasured);
end;

procedure TFMain.Label112Click(Sender: TObject);
begin
  DoOpenURL('http://bbot.bmega.net/account.html');
end;

procedure TFMain.lblMacroEditorCopyClick(Sender: TObject);
begin
  SetClipboard(edtMacroEditorCode.Text);
end;

procedure TFMain.btnMacroBackClick(Sender: TObject);
begin
  ShowGroupBox(gbLast);
end;

procedure TFMain.MacroEditorGenerateCode;
var
  Code: BStr;
  I: BInt32;
  D: BInt32;
begin
  D := 0;
  if rdMacroAuto.Checked then
  begin
    D := BStrTo32(numMacroEditorDelay.Text, -1);
    if (D = 0) or (D = 1) then
    begin
      ShowMessage('The delay cannot be 0 or 1 for auto-macros.');
      Exit;
    end;
  end
  else if rdMacroOnce.Checked then
    D := 1
  else if rdMacroManual.Checked then
    D := 0;
  Code := '';
  for I := 0 to sMacro.Lines.Count - 1 do
    Code := Code + ' ' + Trim(sMacro.Lines.Strings[I]);
  edtMacroEditorCode.Text := Format('%d {%s}%s',
    [D, edtMacroEditorName.Text, Code]);
end;

procedure TFMain.edtMacroEditorNameChange(Sender: TObject);
begin
  MacroEditorGenerateCode;
end;

procedure TFMain.OnBBotMessage(var AMsg: TMessage);
var
  Msg: TBBotGUIMessage;
begin
  Msg := TBBotGUIMessage(AMsg.wParam);
  if Msg is TBBotGUIMessageAddCavebotPoint then
    CavebotFrame.WaypointAddPoint(TBBotGUIMessageAddCavebotPoint(Msg).Position)
  else if Msg is TBBotGUIMessageDebug then
  begin
    AddDebug(TBBotGUIMessageDebug(Msg).Text);
  end
  else if Msg is TBBotGUIMessageAddEnemy then
  begin
    memoEnemies.Lines.Add(TBBotGUIMessageAddEnemy(Msg).Enemy);
    WarToolsSettings(Self);
  end
  else if Msg is TBBotGUIMessageDll then
  begin
    tmrEngine.OnTimer := tmrOnDll;
  end
  else if Msg is TBBotGUIMessageAddAlly then
  begin
    memoAllies.Lines.Add(TBBotGUIMessageAddAlly(Msg).Ally);
    WarToolsSettings(Self);
  end
  else if Msg is TBBotGUIMessageOnPacketServer then
    TBBotGUIMessageOnPacketClient(Msg).AddToList(lstSS)
  else if Msg is TBBotGUIMessageOnPacketClient then
    TBBotGUIMessageOnPacketServer(Msg).AddToList(lstSC)
  else if Msg is TBBotGUIMessageOnPacketBot then
    TBBotGUIMessageOnPacketBot(Msg).AddToList(lstSB)
  else if Msg is TBBotGUIMessageSpecialSQMsAdd then
  begin
    SpecialSQMsFrame.AddSpecialSQM(TBBotGUIMessageSpecialSQMsAdd(Msg).Kind,
      TBBotGUIMessageSpecialSQMsAdd(Msg).Range, Me.Position);
    AdvancedToolsSettings(nil);
  end
  else if Msg is TBBotGUIMessageSpecialSQMsRemove then
  begin
    SpecialSQMsFrame.RemoveSpecialSQM(TBBotGUIMessageSpecialSQMsRemove(Msg)
      .Position);
    AdvancedToolsSettings(nil);
  end
  else if Msg is TBBotGUIMessageUserError then
  begin
    UserErrorFrame.Open(TBBotGUIMessageUserError(Msg).UserError);
  end
  else if Msg is TBBotGUIMessagePathFinderFinished then
  begin
    DebugWalkerFrame.Open(TBBotGUIMessagePathFinderFinished(Msg));
  end;
  Msg.Free;
  AMsg.Msg := 0;
end;

{$REGION 'Attack Sequence Editor'}

procedure TFMain.Label136Click(Sender: TObject);
begin
  ShowGroupBox(gbAtkSequences);
end;

procedure TFMain.Label4Click(Sender: TObject);
begin
  SetClipboard(BStr(Me.Position));
end;

procedure TFMain.onAtkSeqDropDown(Sender: TObject);
begin
  AttackSequencesFrame.AddAttackSequences((Sender as TComboBox).Items);
end;

procedure TFMain.onAtkSeqCloseUp(Sender: TObject);
begin
  if (Sender as TComboBox).ItemIndex = 0 then
    ShowGroupBox(gbAtkSequences);
end;

{$ENDREGION}

function ValidShareStr(S: BStr): BBool;
const
  ValidSS = [#13, #10, '!', '#', '$', '%', '&', '(', ')', '*', '+', ',', '-',
    '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<',
    '=', '>', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
    'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[',
    '\', ']', '^', '_', '?', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y',
    'z', '{', '|', '}', '~', ' '];
var
  I: BInt32;
begin
  Result := False;
  if Length(S) < 5 then
    Exit;
  for I := 1 to Length(S) do
    if not(S[I] in ValidSS) then
      Exit;
  Result := True;
end;

function InviteColorFromIndex(I: BInt32): TColor;
var
  R, G, B: BInt8;
begin
  R := ((I * 30) mod 255);
  B := ((I * 30 * 8) mod 255);
  G := ((I * 30 * 12) mod 255);
  Result := (B shl 16) or (G shl 8) or R;
end;

procedure TFMain.tmrDeleteTimer(Sender: TObject);
begin
  tmrDelete.Enabled := False;
  AddBBotMessage(TBBotGUIMessageDll.Create);
end;

procedure TFMain.tmrEngineTimer(Sender: TObject);
  procedure _tmrCheckDll;
  begin
    if Engine.ReportWrongDLL then
      tmrDelete.Enabled := True;
  end;
  procedure _tmrEngine;
  begin
    if Engine.SetFMainTitle and (BBot.Uptime > 4000) then
    begin
      Caption := 'BBot ' + BotVer + ' - ' + IfThen(Me.Connected, Me.Name,
        'Not Connected');
      Application.Title := Caption;
      Engine.SetFMainTitle := False;
    end;
    if Engine.ToggleFMain then
    begin
      Visible := not Visible;
      Engine.ToggleFMain := False;
    end;
    if Engine.LoadSettings <> '' then
    begin
      OnLoadConfigOk(BotPath + 'Configs/' + Engine.LoadSettings + '.bbot');
      Engine.LoadSettings := '';
    end;
    if (Engine.UpdateNext + 1000) < timeGetTime then
      TBBot.PanicMode;
  end;
  procedure _tmrPopup;
  const
    _PopupEvery = 20 * 60 * 1000;
  begin
    Inc(AutoPopup);
    if AutoPopup > (_PopupEvery div tmrEngine.Interval) then
    begin
      AutoPopup := 0;
      if BRandom(0, 100) < 2 then
        ShowGroupBox(gbReview);
    end;
  end;
  procedure _tmrProfilers;
  begin
    if ProfilersNextShow < Tick then
    begin
      ProfilersNextShow := Tick + 3000;
      lvProfilers.Items.BeginUpdate;
      lvProfilers.Items.Clear;
      AddProfilerData('', BBot.Runner);
      lvProfilers.Items.EndUpdate;
    end;
  end;

begin
  if EngineLoad = elDestroying then
    Close
  else if EngineLoad = elRunning then
  begin
    _tmrEngine;
    _tmrCheckDll;
    _tmrPopup;
    if gbCurrent = gbVariables then
      VariablesFrame.timerVariables;
    if gbCurrent = gbCavebot then
      CavebotFrame.timerCavebot;
    if gbCurrent = gbWarNet then
      WarNetFrame.timerWarNet;
    if gbCurrent = gbProfilers then
      _tmrProfilers;
    if gbCurrent = gbBotManager then
      ReconnectManagerFrame.TimerReconnectManager;
    if gbCurrent = gbMacros then
      MacrosFrame.timerMacros;
  end;
end;

procedure TFMain.tmrOnDll(Sender: TObject);
begin
  tmrEngine.Enabled := False;
  tmrDelete.Enabled := False;
  tmrEngine.OnTimer := nil;
  tmrDelete.OnTimer := nil;
  ShowMessage
    ('Unable to load BBot, please download again, close all your Tibia and reinstall. Error: Invalid integration version.');
  Halt;
end;

procedure TFMain.memoRateReviewChange(Sender: TObject);
var
  R: BStrArray;
begin
  AutoPopup := 0;
  if BSimpleRegex('([^\w\s!?:])', memoRateReview.Text, R) then
  begin
    btnRateSend.Enabled := False;
    btnRateSend.Caption := 'Not allowed: ' + R[High(R)];
  end
  else
  begin
    btnRateSend.Enabled := True;
    btnRateSend.Caption := 'Send review';
  end;
end;

procedure TFMain.MacroCloseUp(Sender: TObject);
var
  cmb: TComboBox;
begin
  cmb := (Sender as TComboBox);
  if cmb.ItemIndex = 0 then
    ShowGroupBox(gbMacros);
  if cmb.ItemIndex = 1 then
    ShowGroupBox(gbMacroEditor);
end;

procedure TFMain.AdvancedToolsSettings(Sender: TObject);
begin
  if MutexAcquire then
  begin
    MacrosFrame.SetMacros;
    SpecialSQMsFrame.setSpecialSQMs;
    MutexRelease;
  end;
end;

procedure TFMain.Label53Click(Sender: TObject);
begin
  ShowGroupBox(gbAlliesAndEnemies);
end;

procedure TFMain.btnProtectorClick(Sender: TObject);
var
  I: BInt32;
begin
  if edtProtectorName.Text = '' then
  begin
    ShowMessage('Invalid protector name !');
    Exit;
  end;
  for I := 0 to lstProtectors.Items.Count - 1 do
    if BStrStartSensitive(lstProtectors.Items[I], edtProtectorName.Text + '@')
    then
      lstProtectors.Items.Delete(I);
  lstProtectors.AddItem
    (Format('%s@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%d@%s@%s@%s@%s@%s@%d',
    [edtProtectorName.Text, BInt32(ComboSelectedObj(cmbProtectorKind)),
    Ord(bplAll) + cmbProtectorPause.ItemIndex, 0, 0, 0, 0, 0, 0,
    IfThen(chkProtectorCloseTibia.Checked, 1, 0),
    IfThen(chkProtectorLogout.Checked, 1, 0),
    IfThen(chkProtectorShutdown.Checked, 1, 0),
    IfThen(chkProtectorScreenshot.Checked, 1, 0),
    IfThen(chkProtectorGoLabel.Checked, 1, 0), IfThen(chkProtectorSound.Checked,
    1, 0), IfThen(chkProtectorMacro.Checked, 1, 0),
    IfThen(chkProtectorPrivateMessage.Checked, 1, 0),
    edtProtectorPrivateMessageTo.Text, edtProtectorPrivateMessageText.Text,
    cmbProtectorMacro.Text, cmbProtectorSoundfile.Text,
    edtProtectorGoLabel.Text, BStrTo32(numProtector.Text, 0)]), nil);
end;

procedure TFMain.lstProtectorsDblClick(Sender: TObject);
var
  R: BStrArray;
begin
  if lstProtectors.ItemIndex = -1 then
    Exit;
  if BStrSplit(R, '@', lstProtectors.Items.Strings[lstProtectors.ItemIndex]) = 23
  then
  begin
    edtProtectorName.Text := R[0];
    cmbProtectorKind.ItemIndex := cmbProtectorKind.Items.IndexOfObject
      (TObject(BStrTo32(R[1])));
    if BInRange(BStrTo32(R[2], Ord(bplNone)), Ord(bplAll), Ord(bplNone)) then
      cmbProtectorPause.ItemIndex := BStrTo32(R[2], Ord(bplNone)) - Ord(bplAll)
    else
      cmbProtectorPause.ItemIndex := cmbProtectorPause.Items.Count - 1;
    chkProtectorCloseTibia.Checked := R[9] = '1';
    chkProtectorLogout.Checked := R[10] = '1';
    chkProtectorShutdown.Checked := R[11] = '1';
    chkProtectorScreenshot.Checked := R[12] = '1';
    chkProtectorGoLabel.Checked := R[13] = '1';
    chkProtectorSound.Checked := R[14] = '1';
    chkProtectorMacro.Checked := R[15] = '1';
    chkProtectorPrivateMessage.Checked := R[16] = '1';
    edtProtectorPrivateMessageTo.Text := R[17];
    edtProtectorPrivateMessageText.Text := R[18];
    cmbProtectorMacro.Text := R[19];
    cmbProtectorSoundfile.Text := R[20];
    edtProtectorGoLabel.Text := R[21];
    numProtector.Text := R[22];
  end;
end;

procedure TFMain.lstProtectorsDrawItem(Control: TWinControl; Index: BInt32;
Rect: TRect; State: TOwnerDrawState);
var
  A: BStr;
  B: BStr;
begin
  BStrSplit(lstProtectors.Items[Index], '@', A, B);
  B := BStrLeft(B, '@');
  if MutexAcquire then
  begin
    B := BBot.Protectors.KindToStr(TBBotProtectorKind(BStrTo32(B, 1)));
    MutexRelease;
  end;
  BListDrawItem(lstProtectors.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TFMain.lstProtectorsKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
var
  Selected: BInt32;
begin
  if ssShift in Shift then
    if Key = VK_DELETE then
    begin
      Selected := lstProtectors.ItemIndex;
      if Selected <> -1 then
        lstProtectors.Items.Delete(Selected);
    end;
end;

procedure TFMain.lstSBDblClick(Sender: TObject);
var
  S: BStr;
  I: BInt32;
  Lst: TListBox;
begin
  S := '';
  Lst := Sender as TListBox;
  for I := 0 to Lst.Items.Count - 1 do
    S := S + Lst.Items.Strings[I] + BStrLine;
  SetClipboard(S);
end;

procedure TFMain.ProtectorTextFields(Sender: TObject);
begin
  cmbProtectorSoundfile.Enabled := chkProtectorSound.Checked;
  edtProtectorGoLabel.Enabled := chkProtectorGoLabel.Checked;
  cmbProtectorMacro.Enabled := chkProtectorMacro.Checked;
  edtProtectorPrivateMessageTo.Enabled := chkProtectorPrivateMessage.Checked;
  edtProtectorPrivateMessageText.Enabled := chkProtectorPrivateMessage.Checked;
end;

procedure TFMain.cmbProtectorKindCloseUp(Sender: TObject);
var
  K: TBBotProtectorKind;
begin
  K := TBBotProtectorKind(ComboSelectedObj(cmbProtectorKind));
  numProtector.Enabled := (K in BBotProtectorLowerParam) or
    (K in BBotProtectorGreaterParam);
end;

procedure TFMain.Label121Click(Sender: TObject);
begin
  BBot.Macros.DebugExecute(edtMacroEditorCode.Text);
end;

procedure TFMain.MacroEditorCreate;
const
  sMacroSample = '1000 {Macro Sample}' + //
    'LowMana%:=50 ' + //
    'Yell:=:True ' + //
    'CurMana%:=Self.Mana% ' + //
    'CurMana:=Self.Mana ' + //
    'CurManaMax:=Self.ManaMax ' + //
    'HUD.Setup(:HCenter, :VTop, 200, 222, 255) ' + //
    'HUD.Display(Hello World!) ' + //
    'HUD.Display(..:: Macro Sample ::..) ' + //
    'HUD.Display(Current Mana: !CurMana!/!CurManaMax! (!CurMana%!)) ' + //
    'Self.Mana%>=!LowMana%! [OnLowMana] ' + //
    'HUD.Display(My mana is fine\, higher or equal than !LowMana%!%!) ' + //
    'Exit ' + //
    '{OnLowMana}  ' + //
    'HUD.Display(My mana is bad\, smaller than !LowMana%!%!) ' + //
    '!Yell!==:True ' + //
    'Label(DoYell) ' + //
    'Exit ' + //
    '{DoYell}  ' + //
    'HUD.Display(OUCHHHHH!!!!)';
begin
  BBot.Macros.Registry.TraverseFunctions(
    procedure(Name, Insert: BStr)
    begin
      sMacroCP.AddItem(Name, Insert);
    end);
  MacroEditorLoad(sMacroSample);
end;

procedure TFMain.sMacroChange(Sender: TObject);
begin
  MacroEditorGenerateCode;
end;

procedure TFMain.sMacroCPPaintItem(Sender: TObject; Index: Integer;
TargetCanvas: TCanvas; ItemRect: TRect; var CustomDraw: Boolean);
const
  ReturnMark: BStr = ' -> ';
var
  R: BStrArray;
  Left: BInt32;
begin
  CustomDraw := True;
  if BStrSplit(R, '||', sMacroCP.ItemList[Index]) = 3 then
  begin
    if BStrPos(ReturnMark, R[2]) > 0 then
    begin
      R[1] := R[1] + ' -> ' + BStrRight(R[2], ReturnMark);
      R[2] := BStrLeft(R[2], ReturnMark);
    end;
    TargetCanvas.Font.Size := 8;

    // Split into 2 lines
    ItemRect.Height := ItemRect.Height div 2;

    // Draw Function Name
    TargetCanvas.Font.Style := [fsBold];
    TargetCanvas.TextOut(ItemRect.Left + 2, ItemRect.Top, R[0]);

    // Draw Function Parameters
    Left := ItemRect.Left;
    Inc(ItemRect.Left, TargetCanvas.TextWidth(R[0]) + 4);
    TargetCanvas.Font.Style := [];
    TargetCanvas.TextOut(ItemRect.Left + 2, ItemRect.Top, R[1]);

    // Draw Function Description
    ItemRect.Left := Left;
    ItemRect.Top := ItemRect.Top + ItemRect.Height;

    TargetCanvas.Font.Style := [];
    TargetCanvas.TextOut(ItemRect.Left + 2, ItemRect.Top, R[2]);
  end;
end;

procedure TFMain.sMacroCPShow(Sender: TObject);
  procedure ClearVariables(AItems: TStrings);
  var
    I: BInt32;
  begin
    for I := AItems.Count - 1 downto 0 do
      if BStrStartSensitive(AItems[I], '!') then
        AItems.Delete(I);
  end;
  procedure AddVariables();
  var
    Variables: BVector<BStr>;
  begin
    Variables := nil;
    try
      Variables := BBot.Macros.VarsList();
      Variables.ForEach(
        procedure(AIt: BVector<BStr>.It)
        var
          Name, Insert: BStr;
        begin
          Name := '!' + BStrReplace(AIt^, '=', '||') + '||variable';
          Insert := '!' + BStrLeft(AIt^, '=');
          sMacroCP.AddItem(Name, Insert);
        end);
    finally
      if Variables <> nil then
        Variables.Free;
    end;
  end;

begin
  sMacroCP.ItemList.BeginUpdate;
  try
    sMacroCP.InsertList.BeginUpdate;
    try
      ClearVariables(sMacroCP.ItemList);
      ClearVariables(sMacroCP.InsertList);
      AddVariables;
    finally
      sMacroCP.InsertList.EndUpdate;
    end;
  finally
    sMacroCP.ItemList.EndUpdate;
  end;
end;

procedure TFMain.btnPasteEditClick(Sender: TObject);
begin
  MacroEditorLoad(Clipboard.AsText);
end;

procedure TFMain.MacroEditorLoad(SCode: BStr);
var
  Name: BStr;
  Delay: BInt32;
  Code: BStr;
begin
  BBot.Macros.FormatMacro(SCode, Name, Delay, Code);
  edtMacroEditorName.Text := Name;
  case Delay of
    0:
      rdMacroManual.Checked := True;
    1:
      rdMacroOnce.Checked := True;
  else
    rdMacroAuto.Checked := True;
  end;
  numMacroEditorDelay.Text := IntToStr(Delay);
  sMacro.Text := Code;
  MacroEditorGenerateCode;
end;

procedure TFMain.MacroExecuteMethod(Sender: TObject);
begin
  if rdMacroOnce.Checked then
    numMacroEditorDelay.Text := '1'
  else if rdMacroManual.Checked then
    numMacroEditorDelay.Text := '0'
  else if rdMacroAuto.Checked then
    numMacroEditorDelay.Text := '1000';
  MacroEditorGenerateCode;
end;

procedure TFMain.btnMacroDoneClick(Sender: TObject);
begin
  MacrosFrame.SaveMacro(edtMacroEditorCode.Text);
  ShowGroupBox(gbLast);
  AdvancedToolsSettings(Sender);
end;

procedure TFMain.cmbProtectorSoundfileDropDown(Sender: TObject);
var
  SR: TSearchRec;
  IsFound: Boolean;
begin
  cmbProtectorSoundfile.Items.Clear;
  IsFound := FindFirst(BotPath + 'Data/*.wav', faAnyFile - faDirectory, SR) = 0;
  while IsFound do
  begin
    cmbProtectorSoundfile.Items.Add(BStrLeft(SR.Name, '.wav'));
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);
end;

procedure TFMain.CMDialogKey(var Msg: TCMDialogKey);
begin
  if Msg.CharCode = VK_TAB then
    if gbCurrent = gbWarNet then
      WarNetFrame.OnTabPressed;
  inherited;
end;

end.
