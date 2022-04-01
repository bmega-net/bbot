unit uReconnectManagerFrame;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Types,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uBTypes,
  Declaracoes,
  BBotEngine,
  uBBotReconnectManager,
  uBVector,
  DateUtils;

type
  TReconnectManagerFrame = class(TFrame)
    gbBotManagerAccountManagement: TPanel;
    Label182: TLabel;
    Label179: TLabel;
    BotManagerViewAcc: TLabel;
    BotManagerViewPass: TLabel;
    Label180: TLabel;
    Label181: TLabel;
    BotManagerDeleteAccount: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label188: TLabel;
    Label189: TLabel;
    Label190: TLabel;
    Label191: TLabel;
    BotManagerAcc: TEdit;
    BotManagerPass: TEdit;
    BotManagerChars: TListBox;
    BotManagerSaveAcc: TButton;
    gbBotManagerScheduleManagement: TPanel;
    Label192: TLabel;
    Duration: TLabel;
    Label193: TLabel;
    Label194: TLabel;
    Label195: TLabel;
    BotManagerScheduleDeleteItem: TLabel;
    BotManagerScheduleOffline: TRadioButton;
    BotManagerScheduleOnline: TRadioButton;
    BotManagerScheduleEnabled: TCheckBox;
    BotManagerScheduleHour: TMemo;
    BotManagerScheduleMinute: TMemo;
    BotManagerScheduleVariation: TMemo;
    BotManagerScheduleSave: TButton;
    gbBotManagerSchedulerList: TPanel;
    Label183: TLabel;
    BotManagerManageAcc: TLabel;
    Label201: TLabel;
    Label202: TLabel;
    Label203: TLabel;
    Label204: TLabel;
    Label205: TLabel;
    Label206: TLabel;
    Label207: TLabel;
    BotManagerStatusCurrent: TLabel;
    BotManagerStatusTime: TLabel;
    BotManagerEnabled: TCheckBox;
    BotManagerLoad: TButton;
    BotManagerSchedule: TListBox;
    BotManagerProfile: TComboBox;
    BotManagerAccPopup: TPopupMenu;
    ScheduleCharacterSettings: TPanel;
    Label196: TLabel;
    Label197: TLabel;
    BotManagerScheduleCharacter: TComboBox;
    Label199: TLabel;
    Label200: TLabel;
    BotManagerScheduleBlockCharMinutes: TMemo;
    BotManagerScheduleBlockCharHours: TMemo;
    Label198: TLabel;
    BotManagerScheduleScript: TComboBox;
    BotManagerRunTask: TLabel;
    LoadProfileMonitor: TTimer;
    procedure BotManagerCharsDblClick(Sender: TObject);
    procedure BotManagerCharsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure BotManagerCharsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BotManagerDeleteAccountClick(Sender: TObject);
    procedure BotManagerEnabledClick(Sender: TObject);
    procedure BotManagerScheduleDeleteItemClick(Sender: TObject);
    procedure BotManagerManageClick(Sender: TObject);
    procedure BotManagerProfileDropDown(Sender: TObject);
    procedure BotManagerProfileChange(Sender: TObject);
    procedure BotManagerRunTaskClick(Sender: TObject);
    procedure BotManagerSaveAccClick(Sender: TObject);
    procedure BotManagerScheduleDblClick(Sender: TObject);
    procedure BotManagerScheduleDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure BotManagerScheduleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BotManagerScheduleSaveClick(Sender: TObject);
    procedure BotManagerScheduleScriptDropDown(Sender: TObject);
    procedure SchedulerKindChange(Sender: TObject);
    procedure BotManagerScheduleCharacterDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure BotManagerScheduleCharacterDropDown(Sender: TObject);
    procedure BotManagerStatusCurrentClick(Sender: TObject);
    procedure BotManagerStatusTimeClick(Sender: TObject);
    procedure ViewAccPass(Sender: TObject);
    procedure BotManagerLoadClick(Sender: TObject);
    procedure BotManagerManageAccClick(Sender: TObject);
    procedure BotManagerAccPopupPopup(Sender: TObject);
    procedure LinkEnter(Sender: TObject);
    procedure LinkLeave(Sender: TObject);
    procedure LoadProfileMonitorTimer(Sender: TObject);
    procedure OnKeyPressNumOnly(Sender: TObject; var Key: Char);
  private
    BotManagerEditingID: BUInt32;
    BotManagerShowAcc: BUInt32;
    BotManagerShowPass: BUInt32;
    BotManagerShowStatus: BUInt32;
    function MutexAcquire: BBool;
    procedure MutexRelease;
  protected
    FMain: TForm;
    procedure Init;
    procedure BotManagerShowAdditionalBox(Box: TPanel);
    procedure LoadReconnectManager;
  public
    constructor Create(AOwner: TComponent); override;

    procedure TimerReconnectManager;
  end;

implementation

{$R *.dfm}

uses
  uMain,
  uEngine,

  uTibiaDeclarations,
  System.UITypes;

procedure TReconnectManagerFrame.BotManagerAccPopupPopup(Sender: TObject);
var
  Menu: TMenuItem;
begin
  while BotManagerAccPopup.Items.Count > 0 do
    BotManagerAccPopup.Items[0].Free;
  BBot.ReconnectManager.LoadAccounts();
  BBot.ReconnectManager.Accounts.ForEach(
    procedure(It: BVector<TBBotReconnectAccount>.It)
    begin
      Menu := TMenuItem.Create(BotManagerAccPopup);
      Menu.Caption := It^.Name;
      Menu.Tag := It^.ID;
      Menu.OnClick := BotManagerManageClick;
      BotManagerAccPopup.Items.Add(Menu);
    end);
  Menu := TMenuItem.Create(BotManagerAccPopup);
  Menu.Caption := 'New account';
  Menu.Tag := -1;
  Menu.OnClick := BotManagerManageClick;
  BotManagerAccPopup.Items.Add(Menu);
end;

procedure TReconnectManagerFrame.BotManagerCharsDblClick(Sender: TObject);
var
  Index: BInt32;
  A, B: BStr;
begin
  Index := BotManagerChars.ItemIndex;
  if Index <> -1 then
    if Index = BotManagerChars.Items.Count - 1 then
      BotManagerChars.Items.Insert(Index,
        BFormat('%d:%s', [Tick, InputBox('New character name', 'Bot Manager character', '')]))
    else begin
      BStrSplit(BotManagerChars.Items[Index], ':', A, B);
      BotManagerChars.Items[Index] := A + ':' + InputBox('Change character name', 'Bot Manager character', B);
    end;
end;

procedure TReconnectManagerFrame.BotManagerCharsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
State: TOwnerDrawState);
var
  V: BStrArray;
  A, B: BStr;
  ID: BUInt32;
  Char: TBBotReconnectCharacter;
begin
  if (Index <> -1) and (BStrSplit(V, ':', BotManagerChars.Items[Index]) = 2) then begin
    B := V[1];
    if Index = BotManagerChars.Items.Count - 1 then
      A := V[0]
    else begin
      A := BFormat('%d', [Index + 1]);
      ID := BUInt32(BStrTo32(V[0], 0));
      Char := BBot.ReconnectManager.CharacterByID(ID);
      if (Char <> nil) and (Char.getBlocked) then
        Char.getBlockDate
    end;
  end else begin
    B := '';
    A := '';
  end;
  BListDrawItem(BotManagerChars.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TReconnectManagerFrame.BotManagerCharsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
end;

procedure TReconnectManagerFrame.BotManagerDeleteAccountClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete this account?', TMsgDlgType.mtConfirmation, mbYesNoCancel, 0) = mrYes
  then begin
    if MutexAcquire then begin
      BBot.ReconnectManager.LoadProfile;
      BBot.ReconnectManager.UpdateAccounts(
        procedure()
        begin
          BBot.ReconnectManager.Accounts.Delete(
            function(It: BVector<TBBotReconnectAccount>.It): BBool
            begin
              Result := It^.ID = BotManagerEditingID;
            end);
        end);
      MutexRelease;
    end;
    BotManagerShowAdditionalBox(nil);
  end;
end;

procedure TReconnectManagerFrame.BotManagerEnabledClick(Sender: TObject);
begin
  if MutexAcquire then begin
    BBot.ReconnectManager.Enabled := BotManagerEnabled.Checked;
    MutexRelease;
  end;
end;

procedure TReconnectManagerFrame.BotManagerLoadClick(Sender: TObject);
begin
  if Length(BotManagerProfile.Text) >= 3 then begin
    BBot.ReconnectManager.LoadProfile(BotManagerProfile.Text);
    LoadReconnectManager;
  end
  else
    ShowMessage('Please type a profile name with at least 3 characters.');
end;

procedure TReconnectManagerFrame.BotManagerManageAccClick(Sender: TObject);
var
  P: TPoint;
begin
  P := BotManagerManageAcc.ClientToScreen(Point(0, BotManagerManageAcc.Height));
  BotManagerManageAcc.PopupMenu.Popup(P.X, P.Y);
end;

procedure TReconnectManagerFrame.BotManagerManageClick(Sender: TObject);
var
  Menu: TMenuItem;
  Acc: BVector<TBBotReconnectAccount>.It;
begin
  Menu := TMenuItem(Sender);
  BotManagerEditingID := 0;
  BotManagerAcc.Text := '';
  BotManagerPass.Text := '';
  BotManagerChars.Items.Clear;
  BotManagerDeleteAccount.Enabled := False;
  if Menu.Tag <> -1 then begin
    BotManagerEditingID := Menu.Tag;
    Acc := BBot.ReconnectManager.Accounts.Find('Reconnect Manager - updating account',
      function(It: BVector<TBBotReconnectAccount>.It): BBool
      begin
        Result := It^.ID = BotManagerEditingID;
      end);
    if Acc <> nil then begin
      BotManagerDeleteAccount.Enabled := True;
      BotManagerAcc.Text := Acc^.Name;
      BotManagerPass.Text := Acc^.Password;
      Acc^.Characters.ForEach(
        procedure(It: BVector<TBBotReconnectCharacter>.It)
        begin
          BotManagerChars.Items.Insert(It^.Index, BFormat('%d:%s', [It^.ID, It^.Name]));
        end);
    end;
  end;
  BotManagerChars.AddItem('New:Double-Click to add and edit entries', nil);
  BotManagerShowAdditionalBox(gbBotManagerAccountManagement);
end;

procedure TReconnectManagerFrame.BotManagerProfileChange(Sender: TObject);
begin
  BBot.ReconnectManager.Name := BotManagerProfile.Text;
end;

procedure TReconnectManagerFrame.BotManagerProfileDropDown(Sender: TObject);
begin
  BotManagerProfile.Items.Clear;
  ListFilesToList(BotPath + 'Data/*.reconnect.bbot', BotManagerProfile.Items);
end;

procedure TReconnectManagerFrame.BotManagerRunTaskClick(Sender: TObject);
begin
  if MutexAcquire then begin
    BBot.ReconnectManager.Current := BBot.ReconnectManager.ScheduleByID(BotManagerEditingID);
    MutexRelease;
  end;
  LoadReconnectManager;
end;

procedure TReconnectManagerFrame.LinkEnter(Sender: TObject);
begin
  TFMain(FMain).LinkEnter(Sender);
end;

procedure TReconnectManagerFrame.LinkLeave(Sender: TObject);
begin
  TFMain(FMain).LinkLeave(Sender);
end;

procedure TReconnectManagerFrame.BotManagerSaveAccClick(Sender: TObject);
begin
  BotManagerDeleteAccount.Enabled := True;
  if MutexAcquire then begin
    BBot.ReconnectManager.LoadProfile;
    BBot.ReconnectManager.UpdateAccounts(
      procedure()
      var
        Acc: BVector<TBBotReconnectAccount>.It;
        Char: BVector<TBBotReconnectCharacter>.It;
        I: BInt32;
        A, B: BStr;
      begin
        Acc := nil;
        if BotManagerEditingID <> 0 then begin
          Acc := BBot.ReconnectManager.Accounts.Find('Reconnect Manager - updating account 2',
            function(It: BVector<TBBotReconnectAccount>.It): BBool
            begin
              Result := It^.ID = BotManagerEditingID;
            end);
        end;
        if Acc = nil then
          Acc := BBot.ReconnectManager.Accounts.Add(TBBotReconnectAccount.Create(BBot.ReconnectManager));
        BotManagerEditingID := Acc^.ID;
        Acc^.Name := BotManagerAcc.Text;
        Acc^.Password := BotManagerPass.Text;
        Acc^.Characters.Clear;
        for I := 0 to BotManagerChars.Items.Count - 2 do
          if BStrSplit(BotManagerChars.Items[I], ':', A, B) then begin
            Char := Acc^.Characters.Add(TBBotReconnectCharacter.Create(BBot.ReconnectManager, Acc^));
            Char^.ID := BStrTo32(A);
            Char^.Name := B;
            Char^.Index := I;
          end;
      end);
    MutexRelease;
  end;
  BotManagerShowAdditionalBox(nil);
end;

procedure TReconnectManagerFrame.OnKeyPressNumOnly(Sender: TObject; var Key: Char);
begin
  TFMain(FMain).OnKeyPressNumOnly(Sender, Key);
end;

procedure TReconnectManagerFrame.BotManagerScheduleCharacterDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
State: TOwnerDrawState);
var
  A, B: BStr;
  V: BStrArray;
begin
  if BStrSplit(V, '/', BotManagerScheduleCharacter.Items[Index]) = 4 then begin
    A := V[1];
    B := V[3];
  end else begin
    A := 'Error';
    B := '??';
  end;
  BListDrawItem(BotManagerScheduleCharacter.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TReconnectManagerFrame.BotManagerScheduleCharacterDropDown(Sender: TObject);
begin
  BotManagerScheduleCharacter.Items.Clear;
  BBot.ReconnectManager.Accounts.ForEach(
    procedure(Acc: BVector<TBBotReconnectAccount>.It)
    begin
      Acc^.Characters.ForEach(
        procedure(Char: BVector<TBBotReconnectCharacter>.It)
        begin
          BotManagerScheduleCharacter.Items.Add(BFormat('%d/%s/%d/%s', [Char^.ID, Char^.Name, Acc^.ID, Acc^.Name]));
        end);
    end);
end;

procedure TReconnectManagerFrame.BotManagerScheduleDblClick(Sender: TObject);
var
  A, B: BStr;
  Schd: TBBotReconnectScheduleItem;
  SchdOn: TBBotReconnectScheduleOnlineItem;
begin
  if Length(BotManagerProfile.Text) < 3 then begin
    ShowMessage('Please type a profile name with at least 3 characters');
    Exit;
  end;
  BotManagerScheduleEnabled.Checked := True;
  BotManagerScheduleOffline.Checked := True;
  BotManagerScheduleOffline.Enabled := True;
  BotManagerRunTask.Enabled := False;
  BotManagerScheduleOnline.Enabled := True;
  BotManagerScheduleHour.Text := '02';
  BotManagerScheduleMinute.Text := '30';
  BotManagerScheduleVariation.Text := '30';
  BotManagerScheduleCharacter.ItemIndex := -1;
  BotManagerScheduleBlockCharHours.Text := '12';
  BotManagerScheduleBlockCharMinutes.Text := '00';
  BotManagerScheduleScript.ItemIndex := -1;
  BotManagerScheduleDeleteItem.Enabled := False;
  BotManagerEditingID := 0;
  if (BotManagerSchedule.ItemIndex <> -1) and (BotManagerSchedule.ItemIndex <> BotManagerSchedule.Count - 1) then begin
    if BStrSplit(BotManagerSchedule.Items.Strings[BotManagerSchedule.ItemIndex], '/', A, B) then begin
      BotManagerEditingID := BStrTo32(A);
      BotManagerRunTask.Enabled := True;
      Schd := BBot.ReconnectManager.ScheduleByID(BotManagerEditingID);
      BotManagerScheduleDeleteItem.Enabled := True;
      BotManagerScheduleEnabled.Checked := Schd.Enabled;
      BotManagerScheduleHour.Text := BFormat('%d', [Schd.Duration div (60 * 60)]);
      BotManagerScheduleMinute.Text := BFormat('%d', [(Schd.Duration mod (60 * 60)) div 60]);
      BotManagerScheduleVariation.Text := BFormat('%d', [Schd.Variation]);
      if Schd is TBBotReconnectScheduleOnlineItem then begin
        SchdOn := TBBotReconnectScheduleOnlineItem(Schd);
        BotManagerScheduleOnline.Checked := True;
        BotManagerScheduleBlockCharHours.Text := BFormat('%d', [SchdOn.BlockCharacter div (60 * 60)]);
        BotManagerScheduleBlockCharMinutes.Text := BFormat('%d', [(SchdOn.BlockCharacter mod (60 * 60)) div 60]);
        BotManagerScheduleCharacter.Items.Clear;
        BotManagerScheduleCharacter.AddItem(BFormat('%d/%s/%d/%s', [SchdOn.Character.ID, SchdOn.Character.Name,
          SchdOn.Account.ID, SchdOn.Account.Name]), nil);
        BotManagerScheduleCharacter.ItemIndex := 0;
        BotManagerScheduleScript.Items.Clear;
        BotManagerScheduleScript.AddItem(SchdOn.Script, nil);
        BotManagerScheduleScript.ItemIndex := 0;
      end
      else
        BotManagerScheduleOffline.Checked := True;
      BotManagerScheduleOffline.Enabled := False;
      BotManagerScheduleOnline.Enabled := False;
    end;
  end;
  BotManagerShowAdditionalBox(gbBotManagerScheduleManagement);
end;

procedure TReconnectManagerFrame.BotManagerScheduleDeleteItemClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete this schedule item?', TMsgDlgType.mtConfirmation, mbYesNoCancel, 0) = mrYes
  then begin
    if MutexAcquire then begin
      BBot.ReconnectManager.LoadProfile;
      BBot.ReconnectManager.UpdateSchedule(
        procedure()
        begin
          BBot.ReconnectManager.Schedule.Delete(
            function(It: BVector<TBBotReconnectScheduleItem>.It): BBool
            begin
              Result := It^.ID = BotManagerEditingID;
            end);
        end);
      MutexRelease;
    end;
    LoadReconnectManager;
    BotManagerShowAdditionalBox(nil);
  end;
end;

procedure TReconnectManagerFrame.BotManagerScheduleDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
State: TOwnerDrawState);
var
  V: BStrArray;
  A, B, CurrID: BStr;
begin
  if EngineLoad = elRunning then begin
    CurrID := BFormat('%d', [BBot.ReconnectManager.CurrentID]);
    if (Index <> -1) and (BStrSplit(V, '/', BotManagerSchedule.Items[Index]) = 3) then begin
      A := V[1];
      B := V[2];
      if (V[0] = CurrID) and (CurrID <> '0') then
        A := '[Current] ' + A;
    end else begin
      A := '';
      B := '';
    end;
    BListDrawItem(BotManagerSchedule.Canvas, Index, odSelected in State, Rect, A, B);
  end;
end;

procedure TReconnectManagerFrame.BotManagerScheduleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Selected: BInt32;
  List: TListBox;
begin
  List := TListBox(Sender);
  if ssShift in Shift then begin
    Selected := List.ItemIndex;
    if (Selected <> -1) and (Selected <> List.Items.Count - 1) then begin
      case Key of
      VK_UP: begin
          if Selected > 0 then begin
            if MutexAcquire then begin
              BBot.ReconnectManager.LoadProfile;
              BBot.ReconnectManager.UpdateSchedule(
                procedure()
                begin
                  BBot.ReconnectManager.Schedule.Swap(Selected - 1, Selected);
                end);
              MutexRelease;
            end;
            LoadReconnectManager;
            BotManagerSchedule.ItemIndex := Selected;
          end;
        end;
      VK_DOWN: begin
          if Selected < (List.Items.Count - 2) then begin
            if MutexAcquire then begin
              BBot.ReconnectManager.LoadProfile;
              BBot.ReconnectManager.UpdateSchedule(
                procedure()
                begin
                  BBot.ReconnectManager.Schedule.Swap(Selected + 1, Selected);
                end);
              MutexRelease;
            end;
            LoadReconnectManager;
            BotManagerSchedule.ItemIndex := Selected;
          end;
        end;
      end;
    end;
  end;
end;

procedure TReconnectManagerFrame.BotManagerScheduleSaveClick(Sender: TObject);
begin
  if BotManagerScheduleOnline.Checked then begin
    if BotManagerScheduleCharacter.ItemIndex = -1 then begin
      ShowMessage('Please select a character!');
      Exit;
    end;
    if BotManagerScheduleScript.ItemIndex = -1 then begin
      ShowMessage('Please select a script!');
      Exit;
    end;
  end;
  if MutexAcquire then begin
    BBot.ReconnectManager.LoadProfile;
    BBot.ReconnectManager.UpdateSchedule(
      procedure()
      var
        Sched: TBBotReconnectScheduleItem;
        Online: TBBotReconnectScheduleOnlineItem;
        V: BStrArray;
      begin
        Sched := nil;
        Online := nil;
        if BotManagerEditingID <> 0 then
          Sched := BBot.ReconnectManager.ScheduleByID(BotManagerEditingID);
        if BotManagerScheduleOffline.Checked then begin
          if Sched = nil then begin
            Sched := TBBotReconnectScheduleOfflineItem.Create(BBot.ReconnectManager);
            BBot.ReconnectManager.Schedule.Add(Sched);
          end;
        end else begin
          if Sched = nil then begin
            Sched := TBBotReconnectScheduleOnlineItem.Create(BBot.ReconnectManager);
            BBot.ReconnectManager.Schedule.Add(Sched);
          end;
          Online := TBBotReconnectScheduleOnlineItem(Sched);
        end;
        Sched.Enabled := BotManagerScheduleEnabled.Checked;
        Sched.Duration := (BStrTo32(BTrim(BotManagerScheduleHour.Text)) * 60 * 60) +
          (BStrTo32(BTrim(BotManagerScheduleMinute.Text)) * 60);
        Sched.Variation := BStrTo32(BTrim(BotManagerScheduleVariation.Text));
        if BotManagerScheduleOnline.Checked then begin
          Online.BlockCharacter := (BStrTo32(BTrim(BotManagerScheduleBlockCharHours.Text)) * 60 * 60) +
            (BStrTo32(BTrim(BotManagerScheduleBlockCharMinutes.Text)) * 60);
          Online.Script := BotManagerScheduleScript.Text;
          BStrSplit(V, '/', BotManagerScheduleCharacter.Text);
          Online.Account := BBot.ReconnectManager.AccountByID(BStrTo32(V[2]));
          Online.Character := Online.Account.CharacterByID(BStrTo32(V[0]));
        end;
      end);
    MutexRelease;
  end;
  LoadReconnectManager;
  BotManagerShowAdditionalBox(nil);
end;

procedure TReconnectManagerFrame.BotManagerScheduleScriptDropDown(Sender: TObject);
begin
  BotManagerScheduleScript.Clear;
  ListFilesToList(BotPath + 'Configs/*.bbot', BotManagerScheduleScript.Items);
end;

procedure TReconnectManagerFrame.BotManagerShowAdditionalBox(Box: TPanel);
var
  BoxHeight: BInt32;
begin
  gbBotManagerAccountManagement.Visible := False;
  gbBotManagerScheduleManagement.Visible := False;
  if Box <> nil then begin
    Box.SetBounds(gbBotManagerSchedulerList.Left, gbBotManagerSchedulerList.Top + gbBotManagerSchedulerList.Height,
      Box.Width, Box.Height);
    Box.Visible := True;
    BoxHeight := Box.Height;
  end
  else
    BoxHeight := 0;
  SetBounds(0, 0, gbBotManagerSchedulerList.Width, gbBotManagerSchedulerList.Height + BoxHeight);
  Parent.SetBounds(Parent.Left, Parent.Top, Width, Height);
  TFMain(FMain).ResizeToBox(TFMain(FMain).gbBotManager);
end;

procedure TReconnectManagerFrame.BotManagerStatusCurrentClick(Sender: TObject);
var
  Curr: TBBotReconnectScheduleItem;
  Start: BStr;
  I: BInt32;
begin
  Curr := BBot.ReconnectManager.Current;
  if Curr <> nil then begin
    Start := BFormat('%d/', [Curr.ID]);
    for I := 0 to BotManagerSchedule.Items.Count - 1 do
      if BStrStart(BotManagerSchedule.Items.Strings[I], Start) then begin
        BotManagerSchedule.ItemIndex := I;
        BotManagerScheduleDblClick(Sender);
      end;
  end;
end;

procedure TReconnectManagerFrame.BotManagerStatusTimeClick(Sender: TObject);
var
  Curr: TBBotReconnectScheduleItem;
  Res: BStr;
  D: BUInt32;
begin
  Curr := BBot.ReconnectManager.Current;
  if Curr <> nil then begin
    Res := InputBox('Change finish duration', 'Change the finish duration of a task:', Curr.DurationStr);
    if Res <> Curr.DurationStr then begin
      D := BotManagerStrToDur(Res);
      if MutexAcquire then begin
        BBot.ReconnectManager.UpdateSchedule(
          procedure()
          begin
            Curr := BBot.ReconnectManager.Current;
            if Curr <> nil then
              Curr.FinishTime := IncSecond(Now, D);
          end);
        MutexRelease;
      end;
    end;
  end;
  LoadReconnectManager;
end;

constructor TReconnectManagerFrame.Create(AOwner: TComponent);
begin
  inherited;
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TReconnectManagerFrame.Init;
begin
  BotManagerShowStatus := 0;
  SetBounds(0, 0, gbBotManagerSchedulerList.Width, gbBotManagerSchedulerList.Height);
end;

procedure TReconnectManagerFrame.LoadProfileMonitorTimer(Sender: TObject);
begin
  if Engine.LoadReconnectManagerProfile <> '' then begin
    BotManagerProfile.Text := Engine.LoadReconnectManagerProfile;
    Engine.LoadReconnectManagerProfile := '';
    BBot.ReconnectManager.LoadProfile(BotManagerProfile.Text);
    LoadReconnectManager;
  end;
end;

procedure TReconnectManagerFrame.LoadReconnectManager;
var
  Curr: TBBotReconnectScheduleItem;
begin
  BotManagerSchedule.Items.BeginUpdate;
  BotManagerSchedule.Items.Clear;
  BBot.ReconnectManager.Schedule.ForEach(
    procedure(It: BVector<TBBotReconnectScheduleItem>.It)
    begin
      BotManagerSchedule.AddItem(BFormat('%d/%s/%s', [It^.ID, It^.FormatListLeft, It^.FormatListRight]), nil);
    end);
  BotManagerSchedule.AddItem('0/New/Double-Click to schedule', nil);
  BotManagerSchedule.Items.EndUpdate;
  Curr := BBot.ReconnectManager.Current;
  if Curr <> nil then begin
    BotManagerStatusCurrent.Caption := Curr.FormatListLeft;
    BotManagerStatusTime.Caption := Curr.DurationStr;
  end else begin
    BotManagerStatusCurrent.Caption := 'none';
    BotManagerStatusTime.Caption := 'done';
  end;
end;

function TReconnectManagerFrame.MutexAcquire: BBool;
begin
  Exit(TFMain(FMain).MutexAcquire());
end;

procedure TReconnectManagerFrame.MutexRelease;
begin
  TFMain(FMain).MutexRelease;
end;

procedure TReconnectManagerFrame.SchedulerKindChange(Sender: TObject);
begin
  ScheduleCharacterSettings.Visible := BotManagerScheduleOnline.Checked;
end;

procedure TReconnectManagerFrame.TimerReconnectManager;
begin
  if BInRange(BotManagerShowAcc, 1, Tick) then begin
    BotManagerAcc.PasswordChar := '*';
    BotManagerShowAcc := 0;
  end;
  if BInRange(BotManagerShowPass, 1, Tick) then begin
    BotManagerPass.PasswordChar := '*';
    BotManagerShowPass := 0;
  end;
  if BotManagerShowStatus < Tick then begin
    BotManagerShowStatus := Tick + 5000;
    LoadReconnectManager;
  end;
end;

procedure TReconnectManagerFrame.ViewAccPass(Sender: TObject);
begin
  if Sender = BotManagerViewAcc then begin
    if BotManagerShowAcc = 0 then begin
      BotManagerShowAcc := Tick() + 5000;
      BotManagerAcc.PasswordChar := #0;
    end else begin
      BotManagerShowAcc := 0;
      BotManagerAcc.PasswordChar := '*';
    end;
  end else if Sender = BotManagerViewPass then begin
    if BotManagerShowPass = 0 then begin
      BotManagerShowPass := Tick() + 5000;
      BotManagerPass.PasswordChar := #0;
    end else begin
      BotManagerShowPass := 0;
      BotManagerPass.PasswordChar := '*';
    end;
  end;
end;

end.
