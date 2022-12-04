unit uBBotAction;

interface

uses
  uBTypes,
  uBVector,
  uBProfiler,
  uBattlelist,
  uHUD,
  uMacroEngine,
  uMacroVariable;

type
  TBBotActionPauseLevel = (bplAll = 5, bplAutomation, bplNone);

  TBBotRunningState = (brsIdle, brsRunning, brsSuccess, brsFailed);

  TBBotRunnable = class
  public
    procedure Run; virtual; abstract;

    function SysVariable(const AName: BStr; const ADefaultValue: BInt32)
      : BMacroSystemVariable; overload;
    function SysValue(const AName: BStr; const ADefaultValue: BInt32)
      : BInt32; overload;
    function SysValueU32(const AName: BStr; const ADefaultValue: BUInt32)
      : BUInt32; overload;
    function SysVariableLock(const AName: BStr; const ALock: BLock)
      : BMacroSystemVariable;
  end;

  TBBotAction = class(TBBotRunnable)
  private
    FActionName: BStr;
    FActionProfiler: BProfiler;
    FActionNext: BLock;
  protected
    function ModVariableName(const AName: BStr): BStr;
  public
    constructor Create(AActionName: BStr; AActionDelay: BInt32);
    destructor Destroy; override;

    property ActionName: BStr read FActionName;
    property ActionProfiler: BProfiler read FActionProfiler;
    property ActionNext: BLock read FActionNext;
    procedure RunAction;
    procedure OnInit; virtual;

    procedure AddDebug(const AText: BStr); overload;
    procedure AddDebug(const ACreature: TBBotCreature;
      const ACreatureText: BStr); overload;
    procedure AddDebug(const ACreature: TBBotCreature;
      const AText, ACreatureText: BStr); overload;
    procedure AddDebug(const APosition: BPos;
      const AText, APosText: BStr); overload;
    procedure AddDebug(const APosition: BPos; const APosText: BStr); overload;
    function DebugGroup: TBBotHUDGroup; virtual;

    function ModVariable(const AName: BStr; const ADefaultValue: BInt32)
      : BMacroSystemVariable; overload;
    function ModValue(const AName: BStr; const ADefaultValue: BInt32)
      : BInt32; overload;
    function ModValueU32(const AName: BStr; const ADefaultValue: BUInt32)
      : BUInt32; overload;
    function ModVariableLock(const AName: BStr; const ALock: BLock)
      : BMacroSystemVariable;
  end;

  TBBotActions = class(TBBotAction)
  private
    FActions: BVector<TBBotAction>;
  public
    constructor Create(AActionName: BStr; AActionDelay: BInt32);
    destructor Destroy; override;

    property Actions: BVector<TBBotAction> read FActions;
    procedure AddAction(AAction: TBBotAction);
    procedure AddActions(AActions: array of TBBotAction);

    procedure Run; override;
    procedure OnInit; override;
  end;

  TBBotActionState = class(TBBotAction)
  private
    FState: TBBotRunningState;
    function GetIsRunning: BBool;
    function GetIsFailed: BBool;
    function GetIsSucceed: BBool;
    function GetIsIdle: BBool;
  public
    constructor Create(AActionName: BStr; AActionDelay: BInt32);
    destructor Destroy; override;

    property State: TBBotRunningState read FState;
    property isRunning: BBool read GetIsRunning;
    property isFailed: BBool read GetIsFailed;
    property isSucceed: BBool read GetIsSucceed;
    property isIdle: BBool read GetIsIdle;

    procedure doReset;
    procedure doStart;
    procedure doSuccess;
    procedure doFail;

    procedure onStart; virtual;
    procedure onFail; virtual;
    procedure onSuccess; virtual;
  end;

implementation

uses
  BBotEngine,
  uMain,
  SysUtils,
  uBBotGUIMessages;

{ TBBotAction }

procedure TBBotAction.AddDebug(const AText: BStr);
var
  HUD: TBBotHUD;
  MsgDebug: TBBotGUIMessageDebug;
begin
  HUD := TBBotHUD.Create(DebugGroup);
  HUD.AlignTo(bhaLeft, bhaTop);
  HUD.Color := $FFFFFF;
  HUD.Expire := 3000;
  HUD.Print(ActionName + ' -> ' + AText);
  MsgDebug := TBBotGUIMessageDebug.Create;
  MsgDebug.Text := HUD.Text;
  FMain.AddBBotMessage(MsgDebug);
  HUD.Free;
end;

procedure TBBotAction.AddDebug(const ACreature: TBBotCreature;
  const AText, ACreatureText: BStr);
begin
  AddDebug(ACreature, ACreatureText);
  AddDebug(AText);
end;

procedure TBBotAction.AddDebug(const APosition: BPos;
  const AText, APosText: BStr);
var
  HUD: TBBotHUD;
begin
  HUDRemovePositionGroup(APosition.X, APosition.Y, APosition.Z, DebugGroup);
  HUD := TBBotHUD.Create(DebugGroup);
  HUD.SetPosition(APosition);
  HUD.Color := $FFFFFF;
  HUD.Expire := 3000;
  HUD.Print(APosText);
  HUD.Free;
  if AText <> '' then
    AddDebug(AText);
end;

procedure TBBotAction.AddDebug(const APosition: BPos; const APosText: BStr);
begin
  AddDebug(APosition, '', APosText);
end;

procedure TBBotAction.AddDebug(const ACreature: TBBotCreature;
  const ACreatureText: BStr);
var
  HUD: TBBotHUD;
begin
  if ACreature = nil then
    Exit;
  HUDRemoveCreatureGroup(ACreature.ID, DebugGroup);
  HUD := TBBotHUD.Create(DebugGroup);
  HUD.Creature := ACreature.ID;
  HUD.Color := $FFFFFF;
  HUD.Expire := 3000;
  HUD.RelativeY := 12;
  HUD.Print(ACreatureText);
  HUD.Free;
end;

constructor TBBotAction.Create(AActionName: BStr; AActionDelay: BInt32);
begin
  FActionName := AActionName;
  FActionProfiler := BProfiler.Create;
  FActionNext := BLock.Create(AActionDelay, 20);
end;

function TBBotAction.DebugGroup: TBBotHUDGroup;
begin
  Result := bhgDebug;
end;

destructor TBBotAction.Destroy;
begin
  FActionNext.Free;
  FActionProfiler.Free;
  inherited;
end;

function TBBotAction.ModValue(const AName: BStr;
  const ADefaultValue: BInt32): BInt32;
begin
  Exit(ModVariable(AName, ADefaultValue).Value);
end;

function TBBotAction.ModValueU32(const AName: BStr;
  const ADefaultValue: BUInt32): BUInt32;
begin
  Exit(ModVariable(AName, ADefaultValue).ValueU32);
end;

function TBBotAction.ModVariable(const AName: BStr; const ADefaultValue: BInt32)
  : BMacroSystemVariable;
begin
  Exit(SysVariable(ModVariableName(AName), ADefaultValue));
end;

function TBBotAction.ModVariableLock(const AName: BStr; const ALock: BLock)
  : BMacroSystemVariable;
begin
  Exit(SysVariableLock(ModVariableName(AName), ALock));
end;

function TBBotAction.ModVariableName(const AName: BStr): BStr;
begin
  Exit(BStrReplace(ActionName, ' ', '') + '.' + AName);
end;

procedure TBBotAction.OnInit;
begin

end;

procedure TBBotAction.RunAction;
begin
  if ActionNext.Locked then
    Exit;
  ActionNext.Lock;
  try
    ActionProfiler.Start;
    Run;
    ActionProfiler.Stop;
  except
    on E: Exception do
      raise BException.Create('BBot->Action->' + ActionName + BStrLine +
        E.Message);
  end;
end;

{ TBBotActions }

procedure TBBotActions.AddAction(AAction: TBBotAction);
begin
  Actions.Add(AAction);
end;

procedure TBBotActions.AddActions(AActions: array of TBBotAction);
var
  I: BInt32;
begin
  for I := 0 to High(AActions) do
    AddAction(AActions[I]);
end;

constructor TBBotActions.Create(AActionName: BStr; AActionDelay: BInt32);
begin
  FActions := BVector<TBBotAction>.Create(
    procedure(It: BVector<TBBotAction>.It)
    begin
      It^.Free;
    end);
  inherited Create(AActionName, AActionDelay);
end;

destructor TBBotActions.Destroy;
begin
  FActions.Free;
  inherited;
end;

procedure TBBotActions.OnInit;
begin
  Actions.ForEach(
    procedure(It: BVector<TBBotAction>.It)
    begin
      It^.OnInit;
    end);
end;

procedure TBBotActions.Run;
begin
  Actions.ForEach(
    procedure(It: BVector<TBBotAction>.It)
    begin
      It^.RunAction;
    end);
end;

{ TBBotStatedAction }

constructor TBBotActionState.Create(AActionName: BStr; AActionDelay: BInt32);
begin
  inherited Create(AActionName, AActionDelay);
  FState := brsIdle;
end;

destructor TBBotActionState.Destroy;
begin

  inherited;
end;

procedure TBBotActionState.doFail;
begin
  FState := brsFailed;
  onFail;
end;

function TBBotActionState.GetIsFailed: BBool;
begin
  Result := FState = brsFailed;
end;

function TBBotActionState.GetIsIdle: BBool;
begin
  Result := FState = brsIdle;
end;

function TBBotActionState.GetIsRunning: BBool;
begin
  Result := FState = brsRunning;
end;

function TBBotActionState.GetIsSucceed: BBool;
begin
  Result := FState = brsSuccess;
end;

procedure TBBotActionState.onFail;
begin

end;

procedure TBBotActionState.onStart;
begin

end;

procedure TBBotActionState.onSuccess;
begin

end;

procedure TBBotActionState.doReset;
begin
  FState := brsIdle;
end;

procedure TBBotActionState.doStart;
begin
  FState := brsRunning;
  onStart;
end;

procedure TBBotActionState.doSuccess;
begin
  FState := brsSuccess;
  onSuccess;
end;

{ TBBotRunnable }

function TBBotRunnable.SysValue(const AName: BStr;
const ADefaultValue: BInt32): BInt32;

begin
  Exit(SysVariable(AName, ADefaultValue).Value);
end;

function TBBotRunnable.SysValueU32(const AName: BStr;
const ADefaultValue: BUInt32): BUInt32;

begin
  Exit(SysVariable(AName, ADefaultValue).ValueU32);
end;

function TBBotRunnable.SysVariable(const AName: BStr;
const ADefaultValue: BInt32): BMacroSystemVariable;

begin
  Exit(BMacroSystemVariable(BBot.Macros.Registry.CreateSystemVariable('BBot.' +
    AName, ADefaultValue)));
end;

function TBBotRunnable.SysVariableLock(const AName: BStr; const ALock: BLock)
  : BMacroSystemVariable;

begin
  Result := SysVariable(AName, ALock.Delay);
  Result.Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      ALock.Delay := BUInt32(AValue);
    end);
end;

end.
