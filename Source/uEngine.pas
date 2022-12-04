unit uEngine;

interface

uses
  uBTypes,
  uDownloader;

{$IFDEF Release}
{$DEFINE BotExceptions}
{$ENDIF}

type
  TEngineDebug = record
    Path: BBool;
    Channels: BBool;
  end;

  TEngineState = record
    LoadSettings: BStr;
    LoadReconnectManagerProfile: BStr;
    SetFMainTitle: BBool;
    ToggleFMain: BBool;
    Reconnect: BBool;
    ReconnectSleep: BUInt32;
    UpdateNext: BUInt32;
    Debug: TEngineDebug;
    ReportWrongDLL: BBool;
  end;

  TEngineLoadState = (elInit, elLoading, elRunning, elDestroying);

var
  EngineLoad: TEngineLoadState = elInit;
  Engine: TEngineState;

procedure BBotEngine_Load();
procedure BBotEngine_SendError(const AErrorMsg: BStr);
function BBotEngine_FormatError(const AErrorMsg: BStr): BStr;

implementation

uses
  BBotEngine,
  Windows,
  Declaracoes,
  uTibia,
  SysUtils,
  uPackets,
  Math,
  uTibiaProcess,
  mmSystem,
  Forms,
  Classes,
  uMain,
  uFLootItems,
  uTibiaState,
  uTibiaDeclarations,
  uHUD,
  uBBotAction;

function GetErrorLoadState: BStr;
begin
  case EngineLoad of
    elInit:
      Exit('elInit');
    elLoading:
      Exit('elLoading');
    elRunning:
      Exit('elRunning');
    elDestroying:
      Exit('elDestroying');
  end;
  Exit('??? ' + BToStr(Ord(EngineLoad)));
end;

function GetErrorVersionState: BStr;
begin
  Exit(BFormat('Version: %s Tibia: %s Date: %s', [ //
    BotVer, //
    BBotLogin.Version, //
    FormatDateTime('yyyy-mm-dd hh.nn.ss', Now) //
    ]));
end;

function GetErrorPauseState: BStr;
begin
  try
    if Assigned(BBot) then
      if Assigned(BBot.Menu) then
        case BBot.Menu.PauseLevel of
          bplAll:
            Exit('Pause: Bot');
          bplAutomation:
            Exit('Pause: Automations');
          bplNone:
            Exit('Paused: None');
        end;
  except
  end;
  Exit('Pause: ???');
end;

function BBotEngine_FormatError(const AErrorMsg: BStr): BStr;
begin
  Result := '';
  if AErrorMsg <> '' then
  begin
    Result := BFormat
      ('####### ERROR REPORT ####### \n%s \n%s \n%s, \n%s\n\n\n', [ //
      GetErrorVersionState, //
      GetErrorPauseState, //
      GetErrorLoadState, //
      AErrorMsg]);
  end;
end;

procedure BBotEngine_SendError(const AErrorMsg: BStr);
begin
  BFilePut('ErrorPanicMode.' + BToStr(Tick()) + '.txt', AErrorMsg)
end;

procedure BBotEngine_Exec();
begin
  BBotMutex.Acquire;
  BBot.ReconnectManager.RunAction;
  if Engine.Reconnect then
  begin
    Me.Reload;
    if Me.Connected then
    begin
      Engine.Reconnect := False;
      Engine.ReconnectSleep := 0;
    end
    else
    begin
      BBot.Reconnect.Login;
      Engine.ReconnectSleep := BRandom(1, 6) * 30 * 1000;
      Tibia.SleepWhileDisconnected(Engine.ReconnectSleep);
    end;
  end;
  PacketQueue.Execute;
  BBot.Execute;
  if Tick > Engine.UpdateNext then
  begin
    TibiaState^.Ping := Tibia.PingAvg;
    Engine.UpdateNext := Tick + 1000;
  end;
  if not IsWindow(TibiaProcess.hWnd) then
    EngineLoad := elDestroying;
  BBotMutex.Release;
  Sleep(30);
end;

procedure BBotEngine_MainLoop(Data: Pointer);
{$IFDEF BotExceptions}
var
  E: TObject;
  HUD: TBBotHUD;
{$ENDIF}
begin
{$IFNDEF Release}setThisThreadName('BBot.Engine'); {$ENDIF}
  Randomize();
{$IFDEF BotExceptions} try {$ENDIF}
    EngineLoad := elRunning;
    while EngineLoad <> elDestroying do
    begin
{$IFDEF DEBUG}
      SetTick;
{$ENDIF}
      BBotEngine_Exec;
    end;
{$IFDEF BotExceptions}
  except
    if EngineLoad = elRunning then
    begin
      E := AcquireExceptionObject;
      if E <> nil then
      begin
        try
          BBotEngine_SendError(BBotEngine_FormatError((E as Exception)
            .Message));
        except
        end;
        try
          HUDRemoveAll();
          BBot.StartSound('', True);
          HUD := TBBotHUD.Create(bhgAlert);
          HUD.Expire := 60000;
          HUD.AlignTo(bhaLeft, bhaTop);
          HUD.Print('[Critical Error]', $0000C0);
          HUD.Print('BBot is now in Panic Mode', $0000C0);
          HUD.Print('The error was ' + (E as Exception).Message, $0000C0);
          HUD.Print('BBot must be restarted!', $0000C0);
          HUD.Free;
        finally
          HUDExecute;
        end;
        while EngineLoad = elRunning do
        begin
          TBBot.PanicMode;
          Sleep(400);
        end;
      end;
    end;
  end;
{$ENDIF}
  BBotMutex.Acquire;
  _SafeFree(BBot);
end;

procedure BBotEngine_Load();
var
  TID: BUInt32;
begin
  EngineLoad := elLoading;
{$IFDEF DEBUG}
  SetTick;
{$ENDIF}
  Engine.ReportWrongDLL := False;

  BBot := TBBot.Create;
  BBot.Load;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFLootItems, FLootItems);

  Engine.LoadSettings := '';
  Engine.LoadReconnectManagerProfile := '';
  Engine.ToggleFMain := False;
  Engine.SetFMainTitle := True;
  Engine.Reconnect := False;
  Engine.ReconnectSleep := 0;
  Engine.UpdateNext := Tick + 1000;
  Engine.Debug.Path := False;
  Engine.Debug.Channels := False;

  CreateThread(nil, 0, @BBotEngine_MainLoop, nil, 0, TID);
end;

end.
