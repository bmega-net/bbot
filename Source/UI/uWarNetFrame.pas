unit uWarNetFrame;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uBTypes,
  uBVector,
  uBBotWarNetServerQuery;

type
  TBBotWarNetServersQueryCallback = class;

  TWarNetFrame = class(TFrame)
    WarNetStatus: TLabel;
    Disconnect: TLabel;
    RoomsPanel: TPanel;
    WarNetRooms: TListBox;
    Label56: TLabel;
    Label80: TLabel;
    Label52: TLabel;
    ActionsPanel: TPanel;
    WarNetActions: TListBox;
    Label13: TLabel;
    Label77: TLabel;
    Label168: TLabel;
    WarNetItemCombos: TCheckBox;
    CreateActionPanel: TPanel;
    Label165: TLabel;
    Label167: TLabel;
    WarNetComboCombo: TComboBox;
    WarNetAddCombo: TButton;
    WarNetAddSignal: TButton;
    WarNetSignalDuration: TMemo;
    Label164: TLabel;
    WarNetSignalName: TEdit;
    WarNetSignalChangeColor: TLabel;
    Label163: TLabel;
    Label137: TLabel;
    WarNetTriggerKey: TEdit;
    WarNetTriggerSay: TEdit;
    WarNetTriggerShoot: TMemo;
    WarNetTriggerSelectedShoot: TRadioButton;
    WarNetTriggerSelectedSay: TRadioButton;
    WarNetTriggerSelectedKey: TRadioButton;
    Label81: TLabel;
    GoCreateRoom: TLabel;
    GoCreateAction: TLabel;
    CreateRoomPanel: TPanel;
    WarNetServers: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CreateRoomName: TEdit;
    Label5: TLabel;
    CreateRoomPassword: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    CreateRoomLeaderPassword: TEdit;
    RoomCreate: TButton;
    Label8: TLabel;
    GoViewRooms: TLabel;
    GoViewActions: TLabel;
    procedure WarNetActionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure WarNetActionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WarNetAddComboClick(Sender: TObject);
    procedure GoCreateRoomClick(Sender: TObject);
    procedure DisconnectClick(Sender: TObject);
    procedure WarNetItemCombosClick(Sender: TObject);
    procedure WarNetSignalChangeColorClick(Sender: TObject);
    procedure WarNetTriggerKeyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WarNetAddSignalClick(Sender: TObject);
    procedure LinkMouseEnter(Sender: TObject);
    procedure LinkMouseLeave(Sender: TObject);
    procedure GoViewRoomsClick(Sender: TObject);
    procedure GoViewActionsClick(Sender: TObject);
    procedure GoCreateActionClick(Sender: TObject);
    procedure ServerRoomDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure RoomCreateClick(Sender: TObject);
    procedure WarNetComboComboDropDown(Sender: TObject);
    procedure WarNetComboComboCloseUp(Sender: TObject);
    procedure OnKeyPressNumOnly(Sender: TObject; var Key: Char);
    procedure WarNetRoomsDblClick(Sender: TObject);
  private
    FMain: TForm;
    NextReloadServers: BUInt32;
    function GetWarNetTrigger: BStr;
    procedure BuildWarNetActions;
    procedure init;
    function MutexAcquire: BBool;
    procedure MutexRelease;
    procedure GoToPanel(const APanel: TPanel);
  protected
    ServerQuery: TBBotWarNetServersQueryCallback;
    shouldReadDataFromServer: BBool;
    procedure onReloadCompleted;
    procedure readDataFromServerQuery;
  public
    constructor Create(AOwner: TComponent); override;
    procedure TimerWarNet;
    procedure OnTabPressed;
    procedure Reload;
  end;

  TBBotWarNetServersQueryCallback = class(TBBotWarNetServersQuery)
  private
    WarNetFrame: TWarNetFrame;
  public
    constructor Create(const AWarNetFrame: TWarNetFrame);
    procedure onReloadCompleted; override;
  end;

implementation

{$R *.dfm}

uses
  Declaracoes,
  BBotEngine,
  uEngine,
  uBBotWarNet,
  uBBotTCPSocket,
  uMain,
  SyncObjs;

const
  RELOAD_SERVERS_EVERY = 5 * 1000;

procedure TWarNetFrame.BuildWarNetActions;
begin
  if MutexAcquire then begin
    BBot.WarNet.LoadActions(WarNetActions.Items);
    MutexRelease;
  end;
end;

constructor TWarNetFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  init;
end;

procedure TWarNetFrame.GoCreateRoomClick(Sender: TObject);
begin
  GoToPanel(CreateRoomPanel);
end;

procedure TWarNetFrame.GoToPanel(const APanel: TPanel);
begin
  ActionsPanel.Visible := False;
  RoomsPanel.Visible := False;
  CreateRoomPanel.Visible := False;
  CreateActionPanel.Visible := False;
  APanel.Left := 3;
  APanel.Top := 22;
  APanel.Visible := True;
end;

procedure TWarNetFrame.GoViewActionsClick(Sender: TObject);
begin
  GoToPanel(ActionsPanel);
end;

procedure TWarNetFrame.GoViewRoomsClick(Sender: TObject);
begin
  GoToPanel(RoomsPanel);
end;

procedure TWarNetFrame.GoCreateActionClick(Sender: TObject);
begin
  GoToPanel(CreateActionPanel);
end;

procedure TWarNetFrame.LinkMouseEnter(Sender: TObject);
begin
  OnLinkLabelEnter(Sender);
end;

procedure TWarNetFrame.LinkMouseLeave(Sender: TObject);
begin
  OnLinkLabelLeave(Sender);
end;

function TWarNetFrame.GetWarNetTrigger: BStr;
begin
  if WarNetTriggerSelectedKey.Checked then
    Result := BFormat('Key@@%s', [WarNetTriggerKey.Text])
  else if WarNetTriggerSelectedSay.Checked then
    Result := BFormat('Say@@%s', [WarNetTriggerSay.Text])
  else if WarNetTriggerSelectedShoot.Checked then
    Result := BFormat('Shoot@@%d', [BStrTo32(WarNetTriggerShoot.Text)])
  else
    raise Exception.Create('Invalid Trigger method!');
end;

procedure TWarNetFrame.init;
begin
  SetBounds(0, 0, RoomsPanel.Width, RoomsPanel.Height + RoomsPanel.Top);
  GoToPanel(RoomsPanel);
  NextReloadServers := 0;
  ServerQuery := TBBotWarNetServersQueryCallback.Create(self);
  shouldReadDataFromServer := False;
end;

function TWarNetFrame.MutexAcquire: BBool;
begin
  Result := TFMain(FMain).MutexAcquire;
end;

procedure TWarNetFrame.MutexRelease;
begin
  TFMain(FMain).MutexRelease;
end;

procedure TWarNetFrame.OnKeyPressNumOnly(Sender: TObject; var Key: Char);
begin
  TFMain(FMain).OnKeyPressNumOnly(Sender, Key);
end;

procedure TWarNetFrame.onReloadCompleted;
begin
  shouldReadDataFromServer := True;
end;

procedure TWarNetFrame.OnTabPressed;
begin
  if (Screen.ActiveControl = WarNetTriggerKey) then begin
    WarNetTriggerKey.Text := 'TAB';
  end;
end;

procedure TWarNetFrame.readDataFromServerQuery;
begin
  if shouldReadDataFromServer then
    if ServerQuery.Mutex.WaitFor(50) = wrSignaled then begin
      shouldReadDataFromServer := False;
      WarNetServers.Items.BeginUpdate;
      WarNetRooms.Items.BeginUpdate;
      WarNetServers.Clear;
      WarNetRooms.Clear;
      ServerQuery.Servers.ForEach(
        procedure(AServer: TBBotWarNetServersQuery.TServerIt)
        var
          Description: BStr;
          Players: BInt32;
        begin
          if not AServer^.Valid then
            Exit;
          Players := 0;
          AServer^.Rooms.ForEach(
            procedure(ARoom: TBBotWarNetServer.TWarRoomIt)
            var
              RoomDescription: BStr;
            begin
              Players := Players + ARoom^.Players;
              RoomDescription := BFormat('with %d players hosted on %s (ping: %d)', [ARoom^.Players, AServer^.Name,
                AServer^.Ping]);
              WarNetRooms.AddItem(BFormat('%s:%d @Description<%s>Description@ @Name<%s>Name@',
                [AServer^.IP, AServer^.Port, RoomDescription, ARoom^.Name]), nil);
            end);
          Description := BFormat('%s with %d inside %d rooms (ping: %d)',
            [BIf(AServer^.Official, 'Official', 'Private'), Players, AServer^.Rooms.Count, AServer^.Ping]);
          WarNetServers.AddItem(BFormat('%s:%d @Description<%s>Description@ @Name<%s>Name@',
            [AServer^.IP, AServer^.Port, Description, AServer^.Name]), nil);
        end);
      WarNetRooms.Items.EndUpdate;
      WarNetServers.Items.EndUpdate;
      ServerQuery.Mutex.Release;
    end;
end;

procedure TWarNetFrame.Reload;
begin
  ServerQuery.Refresh;
end;

procedure TWarNetFrame.RoomCreateClick(Sender: TObject);
var
  IP: BStr;
  Port: BInt32;
begin
  if not Me.Connected then
    ShowMessage('Please login on Tibia!')
  else if BBot.WarNet.State <> bwnssDisconnected then
    ShowMessage('Please disconnect from your current session!')
  else if WarNetServers.ItemIndex = -1 then
    ShowMessage('Please select a server!')
  else if Length(CreateRoomName.Text) < 3 then
    ShowMessage('Please type a room name')
  else if Length(CreateRoomPassword.Text) < 3 then
    ShowMessage('Please type a room normal password')
  else if Length(CreateRoomLeaderPassword.Text) < 3 then
    ShowMessage('Please type a room leader password')
  else if EngineLoad = elRunning then begin
    IP := BStrLeft(WarNetServers.Items.Strings[WarNetServers.ItemIndex], ' @Description<');
    Port := BStrTo32(BTrim(BStrRight(IP, ':')));
    IP := BTrim(BStrLeft(IP, ':'));
    BBot.WarNet.IP := IP;
    BBot.WarNet.Port := Port;
    BBot.WarNet.Room := CreateRoomName.Text;
    BBot.WarNet.Password := CreateRoomPassword.Text;
    BBot.WarNet.LeaderPassword := CreateRoomLeaderPassword.Text;
    if MutexAcquire then begin
      BBot.WarNet.Connected := True;
      MutexRelease;
    end;
  end
end;

procedure TWarNetFrame.TimerWarNet;
var
  CS, RS: BStr;
begin
  readDataFromServerQuery;
  if (NextReloadServers < Tick) and ((RoomsPanel.Visible) or (CreateRoomPanel.Visible)) then begin
    NextReloadServers := Tick + RELOAD_SERVERS_EVERY;
    Reload;
  end;
  case BBot.WarNet.State of
  bwnssDisconnected: begin
      CS := 'Disconnected';
      case BBot.WarNet.RoomStatus of
      bwnrsWrongPassword: RS := 'Wrong Password';
      bwnrsUnavailable: RS := 'Room name unavailabled';
      bwnrsInvalidName: RS := 'Room name is invalid';
      bwnrsRoomNotFound: RS := 'Room not found';
    else RS := '';
      end;
    end;
  bwnssConnecting: begin
      CS := 'Connecting';
      RS := '';
    end;
  bwnssConnected: begin
      CS := 'Connected';
      case BBot.WarNet.RoomStatus of
      bwnrsNone: RS := 'Trying to join room';
      bwnrsAuthenticated: RS := BBot.WarNet.Room + ' connected' + BIf(BBot.WarNet.ImLeader, ' (L)', '');
    else RS := '';
      end;
    end;
  end;
  if BBot.WarNet.SockError <> 0 then
    CS := BFormat('%s (Error %d)', [CS, BBot.WarNet.SockError]);
  WarNetStatus.Caption := CS + BIf(RS <> '', ': ' + RS, '');
  Disconnect.Visible := BBot.WarNet.State = bwnssConnected;
end;

procedure TWarNetFrame.WarNetActionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  R: BStrArray;
  A, B: BStr;
begin
  A := '?';
  B := '?';
  if BStrSplit(R, '@@', WarNetActions.Items[Index]) > 3 then begin
    A := R[0] + ' (' + R[1] + ') ' + R[2];
    B := R[3];
  end;
  BListDrawItem(WarNetActions.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TWarNetFrame.WarNetActionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Selected: BInt32;
begin
  if ssShift in Shift then begin
    Selected := WarNetActions.ItemIndex;
    if Selected <> -1 then
      if Key = VK_DELETE then begin
        WarNetActions.Items.Delete(Selected);
        BuildWarNetActions;
      end;
  end;
end;

procedure TWarNetFrame.WarNetAddComboClick(Sender: TObject);
begin
  if (Length(WarNetComboCombo.Text) < 3) or (WarNetComboCombo.Text = StrManageAttackSequen) then
    ShowMessage('Please select a valid combo')
  else begin
    WarNetActions.AddItem(BFormat('%s@@Combo@@%s', [GetWarNetTrigger, WarNetComboCombo.Text]), nil);
    BuildWarNetActions;
    GoToPanel(ActionsPanel);
  end;
end;

procedure TWarNetFrame.WarNetAddSignalClick(Sender: TObject);
begin
  if Length(WarNetSignalName.Text) < 3 then
    ShowMessage('Please insert a valid signal name')
  else if BStrTo32(WarNetSignalDuration.Text, 0) = 0 then
    ShowMessage('Please insert a valid signal duration. Zero is not allowed.')
  else begin
    WarNetActions.AddItem(BFormat('%s@@Signal@@%s@@%d@@%d', [GetWarNetTrigger, WarNetSignalName.Text,
      BStrTo32(WarNetSignalDuration.Text, 1000), BInt32(WarNetSignalName.Font.Color)]), nil);
    BuildWarNetActions;
    GoToPanel(ActionsPanel);
  end;
end;

procedure TWarNetFrame.WarNetComboComboCloseUp(Sender: TObject);
begin
  TFMain(FMain).MacroCloseUp(Sender);
end;

procedure TWarNetFrame.WarNetComboComboDropDown(Sender: TObject);
begin
  TFMain(FMain).MacroList(Sender);
end;

procedure TWarNetFrame.DisconnectClick(Sender: TObject);
begin
  if MutexAcquire then begin
    BBot.WarNet.Connected := False;
    MutexRelease;
  end;
end;

procedure TWarNetFrame.WarNetItemCombosClick(Sender: TObject);
begin
  if MutexAcquire then begin
    BBot.WarNet.ComboShootItems := WarNetItemCombos.Checked;
    MutexRelease;
  end;
end;

procedure TWarNetFrame.WarNetRoomsDblClick(Sender: TObject);
var
  Data, IPPort: BStr;
  IP, RoomName: BStr;
  Port: BInt32;
begin
  if WarNetRooms.ItemIndex <> -1 then begin
    Data := WarNetRooms.Items.Strings[WarNetRooms.ItemIndex];
    RoomName := BStrBetween(Data, '@Name<', '>Name@');
    IPPort := BStrLeft(Data, ' @Description<');
    IP := BTrim(BStrLeft(IPPort, ':'));
    Port := BStrTo32(BTrim(BStrRight(IPPort, ':')));
    BBot.WarNet.IP := IP;
    BBot.WarNet.Port := Port;
    BBot.WarNet.Room := RoomName;
    BBot.WarNet.Password := InputBox('War Room', 'Please type the password for the room ' + RoomName, '');
    if Length(BBot.WarNet.Password) >= 3 then begin
      BBot.WarNet.LeaderPassword := '';
      if MutexAcquire then begin
        BBot.WarNet.Connected := True;
        MutexRelease;
      end;
    end
    else
      ShowMessage('Please type the room password!');
  end;
end;

procedure TWarNetFrame.ServerRoomDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Lst: TListBox;
  Data, A, B: BStr;
begin
  Lst := TListBox(Control);
  Data := Lst.Items.Strings[Index];
  A := BStrBetween(Data, '@Name<', '>Name@');
  B := BStrBetween(Data, '@Description<', '>Description@');
  BListDrawItem(Lst.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TWarNetFrame.WarNetSignalChangeColorClick(Sender: TObject);
var
  ClrDg: TColorDialog;
begin
  ClrDg := TColorDialog.Create(nil);
  ClrDg.Color := WarNetSignalName.Font.Color;
  if ClrDg.Execute then
    WarNetSignalName.Font.Color := ClrDg.Color;
  ClrDg.Free;
end;

procedure TWarNetFrame.WarNetTriggerKeyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  WarNetTriggerKey.Text := KeyToStr(Shift, Key);
  Key := $0;
end;

{ TBBotWarNetServersQueryCallback }

constructor TBBotWarNetServersQueryCallback.Create(const AWarNetFrame: TWarNetFrame);
begin
  WarNetFrame := AWarNetFrame;
  inherited Create();
end;

procedure TBBotWarNetServersQueryCallback.onReloadCompleted;
begin
  inherited;
  WarNetFrame.onReloadCompleted;
end;

end.
