unit uUserError;

interface

uses
  uBTypes,
  uBBotAction;

type
  BUserErrorAction = (uraEditCavebot, uraEditAdvancedAttack, uraEditReconnectManager, uraEditMacro, uraEditEnchanter);
  BUserErrorActions = set of BUserErrorAction;

  BUserError = class
  private
    FMessage: BStr;
    FActions: BUserErrorActions;
    FTime: TDateTime;
    FModule: TBBotAction;
    FDisableCavebot: BBool;
    FDisableEnchanter: BBool;
    FDisableMacros: BBool;
    FDisableReconnectManager: BBool;
    function GetModuleName: BStr;
    function GetFormatted: BStr;
  public
    constructor Create(const AModule: TBBotAction; const AMessage: BStr);

    property Module: TBBotAction read FModule;
    property ModuleName: BStr read GetModuleName;
    property Time: TDateTime read FTime;
    property Message: BStr read FMessage;
    property Actions: BUserErrorActions read FActions write FActions;

    property DisableCavebot: BBool read FDisableCavebot write FDisableCavebot;
    property DisableMacros: BBool read FDisableMacros write FDisableMacros;
    property DisableEnchanter: BBool read FDisableEnchanter write FDisableEnchanter;
    property DisableReconnectManager: BBool read FDisableReconnectManager write FDisableReconnectManager;

    property Formatted: BStr read GetFormatted;

    procedure Execute();
  end;

implementation

uses
  System.SysUtils,
  BBotEngine,
  uMain,
  uBBotGUIMessages;

{ BUserError }

constructor BUserError.Create(const AModule: TBBotAction; const AMessage: BStr);
begin
  FDisableCavebot := False;
  FDisableEnchanter := False;
  FDisableMacros := False;
  FDisableReconnectManager := False;

  FModule := AModule;
  FMessage := AMessage;
  FTime := Now();
end;

procedure BUserError.Execute;
begin
  BBot.SimpleAlarm('[' + ModuleName + '] Error, please check BBot main window.', True);
  if DisableCavebot then
    BBot.Cavebot.Enabled := False;
  if DisableEnchanter then
    BBot.Enchanter.Enabled := False;
  if DisableMacros then
    BBot.Macros.AutoExecute := False;
  if DisableReconnectManager then begin
    BBot.Reconnect.Enabled := False;
    BBot.ReconnectManager.Enabled := False;
  end;
  FMain.AddBBotMessage(TBBotGUIMessageUserError.Create(Self));
end;

function BUserError.GetFormatted: BStr;
begin
  Result := BFormat('%s Error\nMessage:\n%s\n\nTime: %s\n', [ModuleName, Message, BDateToStr(Time)]);
  if DisableCavebot then
    Result := Result + BStrLine + 'Cavebot is paused';
  if DisableMacros then
    Result := Result + BStrLine + 'Macros is paused';
  if DisableEnchanter then
    Result := Result + BStrLine + 'Enchanter is paused';
end;

function BUserError.GetModuleName: BStr;
begin
  Result := FModule.ActionName;
end;

end.
