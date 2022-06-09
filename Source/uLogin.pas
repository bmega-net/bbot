unit uLogin;

{$DEFINE BypassLogin}

interface

uses
  uBTypes,
  Forms,
  StdCtrls,
  Graphics,
  Controls,
  ExtCtrls,
  Windows,
  SysUtils,
  StrUtils,
  Dialogs,
  SyncObjs;

var
  Sockad: BBool;

type
  BLoginRet = (frNone = 0, frSuccess, frError, frErrorConnecting, frErrorSendingHeaders, frErrorReceivingHeaders,
    frErrorReadingDataChuncked, frErrorReadingData, frInvalidPasswordSymbols, frNotAdmin);

function DoLogin: BLoginRet;

implementation

uses
  Declaracoes,
  uTibiaDeclarations,

  uTibiaProcess,
  uBBotAddresses,
  BBotEngine,
  uItemLoader,
  uDownloader,

  uBase16and64,

  uEngine,

  uTibiaState,
  uRegex,
  Math,
  ucLogin,
  uUpdate,
  uBBotClientTools,
  uSelf,
  uBBotCreatures,
  uBVector;

type
  FLogin = class
  private
    { Login }
    lClientTools: TLabel;
    { Char Selection }
    lChar: TLabel;
    lsChars: TListbox;
    ClientTools: TBBotClientTools;
    { Global }
    Timer: TTimer;
    Form: TForm;
    CurrentControlTop: Integer;
    FLMutex: TMutex;
    FLogged: BLoginRet;
    FLoadedDB: BBool;
    procedure ClearCharList;
    procedure LoadNextControl(Control: TControl; MarginWidth, Height: Integer);
    procedure LoadCharacterList;
    procedure AddCharForProcess(AutoDetected: BBool; Version: TTibiaVersion; hWnd: BUInt32);
    procedure AddAutoDetectVersionForProcess(IsPreview: BBool; IsTest: BBool; hWnd: BUInt32);
    function ListContainsProcessID(APID: BUInt32): BBool;
    procedure fOnPaint(Sender: TObject);
    procedure fOnLogin(Sender: TObject);
    procedure fOnTimer(Sender: TObject);
    procedure fClientToolsEnter(Sender: TObject);
    procedure fClientToolsLeave(Sender: TObject);
    procedure fClientToolsClick(Sender: TObject);
    procedure fLSDraw(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure fLSClick(Sender: TObject);
    procedure beginListUpdate;
    procedure addList(AText: String; AObject: TObject);
    procedure endListUpdate;
    procedure fGoBBot;
    function CheckIsAdmin: BBool;
    function GetLogged: BLoginRet;
  public
    constructor Create;
    destructor Destroy; override;

    property Logged: BLoginRet read GetLogged;
    property LoadedDB: BBool read FLoadedDB write FLoadedDB;

    property LMutex: TMutex read FLMutex;
  end;

  FLoginClientData = class
  private
    FVersion: TTibiaVersion;
    FhWnd: BUInt32;
    FProcessID: BUInt32;
  public
    constructor Create(AhWnd, AProcessID: BUInt32; AVersion: TTibiaVersion);
    property hWnd: BUInt32 read FhWnd write FhWnd;
    property Version: TTibiaVersion read FVersion write FVersion;
    property ProcessID: BUInt32 read FProcessID write FProcessID;
  end;

function DoLogin: BLoginRet;
var
  F: FLogin;
begin
  F := FLogin.Create;
  Result := F.Logged;
  F.Free;
end;

{ FLogin }

procedure FLogin.AddAutoDetectVersionForProcess(IsPreview: BBool; IsTest: BBool; hWnd: BUInt32);
var
  Ver: BStr;
  Version: TTibiaVersion;
begin
  TibiaProcess.hWnd := hWnd;
  TibiaProcess.RenewHandle;
  if TibiaProcess.Handle <> 0 then begin
    Ver := TibiaProcess.FileVersion;
    if IsPreview then begin
      Ver := 'P' + Ver;
    end else if IsTest then begin
      Ver := 'T' + Ver;
    end;
    for Version := TibiaVerFirst to TibiaVerLast do begin
      if BStrStart(Ver, BotVerSupported[Version]) then begin
        AddCharForProcess(True, Version, hWnd);
        Exit;
      end;
    end;
  end;
  addList(Ver + '::unsupported', nil);
end;

procedure FLogin.AddCharForProcess(AutoDetected: BBool; Version: TTibiaVersion; hWnd: BUInt32);
var
  CreatureList: TBBotCreatures;
  VersionLabel: BStr;
begin
  TibiaProcess.hWnd := hWnd;
  AdrSelected := Version;
  if not ListContainsProcessID(TibiaProcess.PID) then begin
    VersionLabel := BotVerSupported[AdrSelected];
    if not AutoDetected then begin
      VersionLabel := '[ClientTools]' + VersionLabel;
    end;
    TibiaProcess.RenewHandle;
    if TibiaProcess.Handle <> 0 then begin
      LoadAddresses;
      Me := TTibiaSelf.Create;
      Me.Reload;
      if Me.Connected then begin
        CreatureList := TBBotCreatures.Get(AdrSelected);
        CreatureList.Reload;
        if CreatureList.Player <> nil then begin
          addList(VersionLabel + '::' + CreatureList.Player.Name, FLoginClientData.Create(TibiaProcess.hWnd,
            TibiaProcess.PID, AdrSelected));
        end else begin
          addList(VersionLabel + '::Unable to read name', FLoginClientData.Create(TibiaProcess.hWnd, TibiaProcess.PID,
            AdrSelected));
        end;
        CreatureList.Free;
      end else begin
        addList(VersionLabel + '::Not Connected', FLoginClientData.Create(TibiaProcess.hWnd, TibiaProcess.PID,
          AdrSelected));
      end;
      Me.Free;
    end else begin
      addList(VersionLabel + ' hWnd/PID ' + BFormat('%d/%d', [TibiaProcess.hWnd, TibiaProcess.PID]) +
        '::no rights', nil);
    end;
  end;
end;

procedure FLogin.addList(AText: String; AObject: TObject);
begin
  try
    if lsChars <> nil then begin
      lsChars.AddItem(AText, AObject)
    end else begin
      raise Exception.Create('Error accessing lsc in al');
    end;
  except
    on E: Exception do begin
      raise Exception.Create('Error adding flc => ' + AText + BStrLine + E.Message);
    end;
  end;
end;

procedure FLogin.beginListUpdate;
begin
  try
    if lsChars <> nil then
      lsChars.Items.BeginUpdate
    else
      raise Exception.Create('Error acessing lsc in blu');
  except
    on E: Exception do
      raise Exception.Create('Error locking flc' + BStrLine + E.Message);
  end;
end;

function FLogin.CheckIsAdmin: BBool;
var
  Handle: THandle;
  Size: BUInt32;
  TokenElev: TTokenElevation;
begin
  Result := True;
  if OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, Handle) then begin
    if GetTokenInformation(Handle, TokenElevation, @TokenElev, SizeOf(TokenElev), Size) then begin
      Result := TokenElev.TokenIsElevated = 1;
    end;
    CloseHandle(Handle);
  end;
end;

procedure FLogin.ClearCharList;
var
  I: BInt32;
begin
  if lsChars <> nil then begin
    for I := 0 to lsChars.Count - 1 do begin
      if lsChars.Items.Objects[I] <> nil then begin
        lsChars.Items.Objects[I].Free;
      end;
    end;
    lsChars.Items.Clear;
{$IFNDEF Release}
    addList('Developer Version::', nil);
{$ENDIF}
  end;
end;

constructor FLogin.Create;
var
  LoginData: BStr;
  LoginAcc, LoginPass: BStr;
begin
  FLMutex := TMutex.Create;

  LoadedDB := False;

  LoginData := BFileGet('./Data/Login');
  LoginAcc := '';
  LoginPass := '';
  if BStrStartSensitive(LoginData, 'Login') then begin
    LoginData := BStrCopy(LoginData, 7, Length(LoginData) - 7);
    LoginData := B16Decode(LoginData);
    LoginData := B64DecodeEx(LoginData);
    LoginData := B16Decode(LoginData);
    BStrSplit(LoginData, '<MegaNo0body>', LoginAcc, LoginPass)
  end;

  ClientTools := TBBotClientTools.Create;

  CurrentControlTop := 0;
  Form := TForm.Create(nil);
  Timer := TTimer.Create(Form);
  Timer.Interval := 1000;
  Timer.OnTimer := fOnTimer;

  Form.Icon := Application.Icon;
  Form.FormStyle := fsNormal;
  Form.BorderStyle := bsSingle;
  Form.BorderIcons := [biSystemMenu];
  Form.Caption := 'BBot ' + BotVer;
  Form.OnPaint := fOnPaint;
  Form.Position := poScreenCenter;
  Form.ClientHeight := 260;
  Form.ClientWidth := 350;

  LoadNextControl(nil, 0, 0);

  lClientTools := TLabel.Create(Form);
  lClientTools.Parent := Form;
  lClientTools.Font.Style := [fsBold];
  lClientTools.Font.Color := clBlue;
  lClientTools.Caption := 'Open Client Tools';
  lClientTools.OnClick := fClientToolsClick;
  lClientTools.OnMouseEnter := fClientToolsEnter;
  lClientTools.OnMouseLeave := fClientToolsLeave;
  LoadNextControl(lClientTools, 6, 18);

  LoadNextControl(nil, 0, 0);

  FOnLogin(Self);
end;

function FLogin.ListContainsProcessID(APID: BUInt32): BBool;
var
  I: BInt32;
begin
  if lsChars <> nil then begin
    for I := 0 to lsChars.Items.Count - 1 do begin
      if lsChars.Items.Objects[I] <> nil then begin
        if FLoginClientData(lsChars.Items.Objects[I]).ProcessID = APID then begin
          Exit(True);
        end;
      end;
    end;
  end;
  Exit(False);
end;

procedure FLogin.LoadCharacterList;
var
  Wnd, DWnd: hWnd;
  ProcessID: BUInt32;
  ClassName: array [0 .. 32] of BChar;
  IsPreview: BBool;
  IsTest: BBool;
  IsNormal: BBool;
  Selected: BInt32;
begin
  beginListUpdate;
  try
    Selected := lsChars.ItemIndex;
    ClearCharList;
    DWnd := GetDesktopWindow;
    Wnd := FindWindowEx(DWnd, Wnd, nil, nil);
    while Wnd <> 0 do begin
      if GetClassNameA(Wnd, @ClassName[0], 32) = 0 then begin
        raise Exception.Create('Error on lcl->className');
      end;
      IsNormal := SameText(BPChar(@ClassName[0]), 'tibiaclient');
      IsPreview := SameText(BPChar(@ClassName[0]), 'tibiaclientpreview');
      IsTest := SameText(BPChar(@ClassName[0]), 'tibiaclienttest');
      if IsNormal or IsPreview or IsTest then begin
        AddAutoDetectVersionForProcess(IsPreview, IsTest, Wnd);
      end else begin
        GetWindowThreadProcessId(Wnd, ProcessID);
        ClientToolsLaunchedCustomEntries.ForEach(
          procedure(Iter: BVector<TBBotClientToolsLaunchedEntries>.It)
          begin
            if ProcessID = Iter^.PID then
              AddCharForProcess(False, Iter^.Version, Wnd);
          end);
      end;
      Wnd := FindWindowEx(DWnd, Wnd, nil, nil);
    end;
    if (Selected >= 0) and (Selected < lsChars.Count) then
      lsChars.ItemIndex := Selected;
  finally endListUpdate;
  end;
end;

procedure FLogin.LoadNextControl(Control: TControl; MarginWidth, Height: Integer);
begin
  if Control <> nil then begin
    Control.SetBounds(MarginWidth, CurrentControlTop, Form.ClientWidth - (MarginWidth * 2), Height);
    Inc(CurrentControlTop, Height + 6);
  end else begin
    Form.ClientHeight := CurrentControlTop;
    CurrentControlTop := 6;
  end;
end;

destructor FLogin.Destroy;
begin
  ClearCharList;
  ClientTools.Free;
  FLMutex.Free;
  Form.Free;
  inherited;
end;

procedure FLogin.endListUpdate;
begin
  try
    if lsChars <> nil then begin
      lsChars.Items.EndUpdate
    end else begin
      raise Exception.Create('Error accessing lsc in elu');
    end;
  except
    on E: Exception do begin
      raise Exception.Create('Error unlocking flc' + BStrLine + E.Message);
    end;
  end;
end;

procedure FLogin.fGoBBot;
begin
  BBotEngine_Load;
  Form.Hide;
end;

function LoadBBotObjects(F: FLogin): Integer; stdcall;
begin
{$IFNDEF Release}setThisThreadName('BBot.Engine.LoadObjects'); {$ENDIF}
  Result := 0;
  try
    LoadAddresses;
    LoadItems;
    if EngineLoad <> elDestroying then begin
      F.LMutex.Acquire;
      F.LoadedDB := True;
      F.LMutex.Release;
    end;
  except
    on E: Exception do begin
      ShowMessage(E.Message);
      ExitProcess(1);
    end
    else
    begin
      ShowMessageFmt('Error loading BBot items %d', [GetLastError]);
      ExitProcess(1);
    end;
  end;
end;

procedure FLogin.fLSClick(Sender: TObject);
var
  TID: Cardinal;
  CData: FLoginClientData;
begin
  try
    beginListUpdate;
    try
      if lsChars.ItemIndex <> -1 then begin
        CData := FLoginClientData(lsChars.Items.Objects[lsChars.ItemIndex]);
        if CData = nil then begin
          ShowMessage('Unsupported version !');
        end else begin
          AdrSelected := CData.Version;
          BBotLogin.Version := BotVerSupported[AdrSelected];
          TibiaProcess.hWnd := CData.hWnd;
          TibiaProcess.RenewHandle;
          lsChars.Enabled := False;
          ClearCharList;
          addList('Loading,::please wait...', nil);
          CreateThread(nil, 0, @LoadBBotObjects, Self, 0, TID);
          while True do begin
            Application.ProcessMessages;
            LMutex.Acquire;
            if FLoadedDB then begin
              LMutex.Release;
              fGoBBot;
              Exit;
            end;
            LMutex.Release;
          end;
        end;
      end;
    finally endListUpdate;
    end;
  except
    on E: Exception do
      ShowMessage('Exception in fLCS(...)' + BStrLine + E.Message + ' ' + BToStr(GetLastError));
  end;
end;

procedure FLogin.fLSDraw(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
begin
  try
    BStrSplit(lsChars.Items[Index], '::', A, B);
    BListDrawItem(lsChars.Canvas, Index, odSelected in State, Rect, A, B);
  finally
  end;
end;

procedure FLogin.fClientToolsClick(Sender: TObject);
begin
  BBotClientToolsPopup(lClientTools.Left, lClientTools.Top + lClientTools.Height, Form);
end;

procedure FLogin.fClientToolsEnter(Sender: TObject);
begin
  OnLinkLabelEnter(Sender);
end;

procedure FLogin.fClientToolsLeave(Sender: TObject);
begin
  OnLinkLabelLeave(Sender);
end;

procedure FLogin.fOnLogin(Sender: TObject);
var
  tlsChars: TListbox;
begin
  lClientTools.Free;

  LoadNextControl(nil, 0, 0);

  lClientTools := TLabel.Create(Form);
  lClientTools.Parent := Form;
  lClientTools.Font.Style := [fsBold];
  lClientTools.Font.Color := clBlue;
  lClientTools.Caption := 'Open Client Tools';
  lClientTools.OnClick := fClientToolsClick;
  lClientTools.OnMouseEnter := fClientToolsEnter;
  lClientTools.OnMouseLeave := fClientToolsLeave;
  LoadNextControl(lClientTools, 6, 18);

  lChar := TLabel.Create(Form);
  lChar.Parent := Form;
  lChar.Font.Style := [fsBold];
  lChar.Caption := 'Character';
  LoadNextControl(lChar, 5, 18);

  tlsChars := TListbox.Create(Form);
  tlsChars.Parent := Form;
  tlsChars.ItemHeight := 18;
  tlsChars.Font.Style := [fsBold];
  tlsChars.Style := lbOwnerDrawVariable;
  tlsChars.OnDrawItem := fLSDraw;
  tlsChars.OnDblClick := fLSClick;
  lsChars := tlsChars;

  LoadNextControl(lsChars, 5, 18 * 10);

  LoadNextControl(nil, 0, 0);
end;

procedure FLogin.fOnPaint(Sender: TObject);
begin
end;

procedure FLogin.fOnTimer(Sender: TObject);
begin
  if Assigned(lsChars) then begin
    if lsChars.Enabled then begin
      LoadCharacterList;
    end;
  end;
end;

function FLogin.GetLogged: BLoginRet;
begin
  if CheckIsAdmin then begin
    Form.ShowModal
  end else begin
    FLogged := frNotAdmin;
  end;
  Result := FLogged;
end;

{ FLoginClientData }

constructor FLoginClientData.Create(AhWnd, AProcessID: BUInt32; AVersion: TTibiaVersion);
begin
  FhWnd := AhWnd;
  FVersion := AVersion;
  FProcessID := AProcessID;
end;

end.

