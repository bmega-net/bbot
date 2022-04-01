unit uCavebotFrame;

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
  Vcl.ImgList,
  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  uBTypes,
  BBotEngine,
  uTibiaDeclarations,
  Vcl.ExtCtrls,
  System.UITypes, System.ImageList;

type
  TCavebotFrame = class(TFrame)
    CavebotWithdrawRounding: TComboBox;
    chkCBa: TCheckBox;
    chkCBLearn: TCheckBox;
    cmbCBrope: TComboBoxEx;
    cmbCBshovel: TComboBoxEx;
    cmbWalkFields: TComboBox;
    cmbWalkFurnitures: TComboBox;
    cmbWalkPlayers: TComboBox;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label157: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label208: TLabel;
    Label59: TLabel;
    Label66: TLabel;
    Label72: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    SpecialSQMsLink: TLabel;
    lblCavebotX: TLabel;
    lblCavebotY: TLabel;
    lblCavebotZ: TLabel;
    lstCBWPT: TListBox;
    popCB: TPopupMenu;
    Add: TMenuItem;
    AddFixedPoint1: TMenuItem;
    AddTeleport1: TMenuItem;
    NoKillOnPoint1: TMenuItem;
    NoKillOffPoint1: TMenuItem;
    AddDelay1: TMenuItem;
    AddDropLoot1: TMenuItem;
    AddMapTool1: TMenuItem;
    AddDepositer1: TMenuItem;
    SupliesWithdraw1: TMenuItem;
    ResetTasks1: TMenuItem;
    ReOpenBackpacks1: TMenuItem;
    FullCheck1: TMenuItem;
    FullCheckLabel1: TMenuItem;
    OpenCorpses1: TMenuItem;
    OpenCorpseOff1: TMenuItem;
    Message1: TMenuItem;
    AddSay1: TMenuItem;
    AddNPCSay1: TMenuItem;
    AddHiDepositAllYes1: TMenuItem;
    AddHiTrade1: TMenuItem;
    HiBalance1: TMenuItem;
    rade1: TMenuItem;
    Withdraw1: TMenuItem;
    BuySuplies1: TMenuItem;
    Sell1: TMenuItem;
    CodesLabels1: TMenuItem;
    AddLabel1: TMenuItem;
    GoRandomLabel1: TMenuItem;
    AddGoLabel1: TMenuItem;
    AddMacro1: TMenuItem;
    N1: TMenuItem;
    Edit1: TMenuItem;
    N3: TMenuItem;
    StartHere1: TMenuItem;
    InsertHere1: TMenuItem;
    N2: TMenuItem;
    Clear1: TMenuItem;
    CopyCodes3: TMenuItem;
    PasteCodes4: TMenuItem;
    imgTools: TImageList;
    Label1: TLabel;
    DepotCity: TComboBox;
    SmartMapClick: TCheckBox;
    procedure StartHere1Click(Sender: TObject);
    procedure InsertHere1Click(Sender: TObject);
    procedure Add2Click(Sender: TObject);
    procedure Adddelay1Click(Sender: TObject);
    procedure AddDropLoot1Click(Sender: TObject);
    procedure AddGoLabel1Click(Sender: TObject);
    procedure GoRandomLabel1Click(Sender: TObject);
    procedure AddHiDepositClick(Sender: TObject);
    procedure AddHiTrade1Click(Sender: TObject);
    procedure HiBalance1Click(Sender: TObject);
    procedure AddLabel1Click(Sender: TObject);
    procedure AddNPCSay1Click(Sender: TObject);
    procedure Addsay1Click(Sender: TObject);
    procedure AddTeleport1Click(Sender: TObject);
    procedure AddDepositer1Click(Sender: TObject);
    procedure AddFixedPoint1Click(Sender: TObject);
    procedure AddMapTool1Click(Sender: TObject);
    procedure FullCheck1Click(Sender: TObject);
    procedure InsertMacro1Click(Sender: TObject);
    procedure ReOpenBackpacks1Click(Sender: TObject);
    procedure NoKillOffPoint1Click(Sender: TObject);
    procedure NoKillOnPoint1Click(Sender: TObject);
    procedure ResetTasks1Click(Sender: TObject);
    procedure FullCheckLabel1Click(Sender: TObject);
    procedure Buy1Click(Sender: TObject);
    procedure Withdraw1Click(Sender: TObject);
    procedure Sell1Click(Sender: TObject);
    procedure SupliesWithdraw1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure CopyCodes3Click(Sender: TObject);
    procedure UnselectClick(Sender: TObject);
    procedure PasteCodes4Click(Sender: TObject);
    procedure lstCBWPTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1Click(Sender: TObject);
    procedure lstCBWPTDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OpenCorpseOff1Click(Sender: TObject);
    procedure OpenCorpses1Click(Sender: TObject);
    procedure SpecialSQMsLinkClick(Sender: TObject);
    procedure SpecialSQMsLinkMouseEnter(Sender: TObject);
    procedure SpecialSQMsLinkMouseLeave(Sender: TObject);
    procedure ApplySettings(Sender: TObject);
  protected
    FMain: TForm;
    procedure init;
    function MutexAcquire: BBool;
    procedure MutexRelease;
  public
    WikiGuideShownMapTool: BBool;
    WikiGuideShownFullCheck: BBool;
    WikiGuideShownSuplies: BBool;

    CavebotInsertIndex: BInt32;
    constructor Create(AOwner: TComponent); override;

    procedure WaypointAddPoint(Pos: BPos);
    procedure FastAddCB(AText: BStr); overload;
    procedure FastAddCB(AText, AParam: BStr); overload;
    procedure FastAddCB(AText: BStr; APosition: BPos); overload;
    procedure FastAddCB(AText, AParam: BStr; APosition: BPos); overload;
    procedure FastAddCBNPCHi;
    procedure SetCavebot;
    procedure TimerCavebot;
  end;

implementation

uses
  uTiles,
  uItemLoader,
  uMain,
  Declaracoes,
  uBBotDepotTools,
  uBVector;

{$R *.dfm}

procedure TCavebotFrame.SetCavebot;
  procedure SetWalkables;
    function WalkableFromCombo(cmb: TComboBox): TTibiaItemWalkable;
    begin
      Result := iwNotWalkable;
      case cmb.ItemIndex of
      0: Result := iwWalkable;
      1: Result := iwAvoid;
      2: Result := iwNotWalkable;
      end;
    end;

  begin
    SetItemsWalkable([ItemID_Creature], WalkableFromCombo(cmbWalkPlayers));
    SetItemsWalkable(ItemsFirePoison, WalkableFromCombo(cmbWalkFields));
    SetItemsWalkable(ItemsFurnitures, WalkableFromCombo(cmbWalkFurnitures));
  end;

begin
  if MutexAcquire then begin
    if chkCBa.Checked then begin
      if lstCBWPT.Count <= 1 then
        chkCBa.Checked := False;
      chkCBLearn.Checked := False;
    end;

    BBot.Cavebot.WithdrawRounding := CavebotWithdrawRounding.ItemIndex;
    case cmbCBrope.ItemIndex of
    0: BBot.Cavebot.Rope := ItemID_Rope;
    1: BBot.Cavebot.Rope := ItemID_ElvenhairRope;
    2: BBot.Cavebot.Rope := ItemID_BlueWhackingDrillerofFate;
    3: BBot.Cavebot.Rope := ItemID_PinkSqueezingGearofGirlpower;
    4: BBot.Cavebot.Rope := ItemID_RedSneakyStabberofEliteness;
    end;
    case cmbCBshovel.ItemIndex of
    0: BBot.Cavebot.Shovel := ItemID_Shovel;
    1: BBot.Cavebot.Shovel := ItemID_LightShovel;
    2: BBot.Cavebot.Shovel := ItemID_BlueWhackingDrillerofFate;
    3: BBot.Cavebot.Shovel := ItemID_PinkSqueezingGearofGirlpower;
    4: BBot.Cavebot.Shovel := ItemID_RedSneakyStabberofEliteness;
    end;
    if BBot.Cavebot.Enabled <> chkCBa.Checked then begin
      BBot.StandTime := Tick;
      if chkCBa.Checked then begin
        chkCBLearn.Checked := False;
        BBot.Cavebot.LoadWaypoint(lstCBWPT.Items);
        BBot.Cavebot.Enabled := (BBot.Cavebot.LoadErrorIndex = -1);
      end
      else
        BBot.Cavebot.Enabled := False;
    end;
    BBot.Cavebot.Learn := chkCBLearn.Checked;
    BBot.Cavebot.SmartMapClick := SmartMapClick.Checked;
    SetWalkables();

    if chkCBa.Checked and (BBot.Cavebot.LoadErrorIndex <> -1) then begin
      ShowMessage('Failed to load cavebot: ' + lstCBWPT.Items.Strings[BBot.Cavebot.LoadErrorIndex]);
      chkCBa.Checked := False;
    end;
    chkCBLearn.Enabled := not BBot.Cavebot.Enabled;
    cmbCBrope.Enabled := not BBot.Cavebot.Enabled;
    cmbCBshovel.Enabled := not BBot.Cavebot.Enabled;
    if BBot.Cavebot.Enabled then begin
      lstCBWPT.OnKeyDown := nil;
      lstCBWPT.PopupMenu := nil;
    end else begin
      lstCBWPT.OnKeyDown := lstCBWPTKeyDown;
      lstCBWPT.PopupMenu := popCB;
    end;
    lstCBWPT.Invalidate;

    BBot.DepotList.SelectedDepot := DepotCity.Text;
    MutexRelease;
  end;
end;

procedure TCavebotFrame.SpecialSQMsLinkClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbSpecialSQMs);
end;

procedure TCavebotFrame.SpecialSQMsLinkMouseEnter(Sender: TObject);
begin
  TFMain(FMain).LinkEnter(Sender);
end;

procedure TCavebotFrame.SpecialSQMsLinkMouseLeave(Sender: TObject);
begin
  TFMain(FMain).LinkLeave(Sender);
end;

procedure TCavebotFrame.StartHere1Click(Sender: TObject);
begin
  if lstCBWPT.ItemIndex <> -1 then begin
    if TFMain(FMain).MutexAcquire then begin
      BBot.Cavebot.StartItemIndex := lstCBWPT.ItemIndex;
      TFMain(FMain).MutexRelease;
    end;
    lstCBWPT.Invalidate;
  end;
end;

procedure TCavebotFrame.InsertHere1Click(Sender: TObject);
begin
  if lstCBWPT.ItemIndex <> -1 then begin
    CavebotInsertIndex := BIf(lstCBWPT.ItemIndex = CavebotInsertIndex, -1, lstCBWPT.ItemIndex);
    lstCBWPT.Invalidate;
  end;
end;

procedure TCavebotFrame.Add2Click(Sender: TObject);
begin
  FastAddCB('Point');
end;

procedure TCavebotFrame.Adddelay1Click(Sender: TObject);
var
  TempNum: BStr;
begin
  TempNum := InputBox('Add delay', 'Please type the delay:', '10');
  if not BStrIsNumber(TempNum) then
    ShowMessage('This is not a valid delay number!')
  else
    FastAddCB('Delay', TempNum);
end;

procedure TCavebotFrame.AddDropLoot1Click(Sender: TObject);
begin
  FastAddCB('DropLoot');
end;

procedure TCavebotFrame.AddGoLabel1Click(Sender: TObject);
begin
  FastAddCB('GoLabel', InputBox('Add go label', 'Please type the label name:', 'MyLabel'));
end;

procedure TCavebotFrame.GoRandomLabel1Click(Sender: TObject);
begin
  FastAddCB('GoRandomLabel', InputBox('Add go random label', 'Please type the label names separated by comma:',
    'MyLabel1, MyLabel2, MyLabel3...'));
end;

procedure TCavebotFrame.AddHiDepositClick(Sender: TObject);
begin
  FastAddCBNPCHi();
  FastAddCB('NPCSay', 'deposit all');
  FastAddCB('NPCSay', 'yes');
end;

procedure TCavebotFrame.AddHiTrade1Click(Sender: TObject);
begin
  FastAddCBNPCHi();
  FastAddCB('NPCSay', 'trade');
end;

procedure TCavebotFrame.HiBalance1Click(Sender: TObject);
begin
  FastAddCBNPCHi();
  FastAddCB('NPCSay', 'balance');
end;

procedure TCavebotFrame.init;
begin
  cmbCBrope.ItemIndex := 0;
  cmbCBshovel.ItemIndex := 0;
  WikiGuideShownMapTool := False;
  WikiGuideShownFullCheck := False;
  WikiGuideShownSuplies := False;
  CavebotInsertIndex := -1;

  DepotCity.AddItem('Old Locker', nil);
  BBot.DepotList.Depots.ForEach(
    procedure(AIt: BVector<TBBotDepotListEntry>.It)
    begin
      DepotCity.AddItem(AIt^.Name, nil);
    end);
  DepotCity.ItemIndex := 0;
end;

procedure TCavebotFrame.AddLabel1Click(Sender: TObject);
begin
  FastAddCB('Label', InputBox('Add Label', 'Please type the label name:', 'MyLabel'));
end;

procedure TCavebotFrame.AddNPCSay1Click(Sender: TObject);
var
  Text: BStr;
begin
  Text := InputBox('Add NPC say', 'Please type what the bot will say in npc channel:', 'Hello!');
  if Text <> '' then
    FastAddCB('NPCSay', Text);
end;

procedure TCavebotFrame.Addsay1Click(Sender: TObject);
var
  Text: BStr;
begin
  Text := InputBox('Add Say', 'Please type what the bot will say:', 'Hello!');
  if Text <> '' then
    FastAddCB('Say', Text);
end;

procedure TCavebotFrame.AddTeleport1Click(Sender: TObject);
begin
  FastAddCB('Teleport');
end;

procedure TCavebotFrame.AddDepositer1Click(Sender: TObject);
begin
  FastAddCB('Depositer');
end;

procedure TCavebotFrame.AddFixedPoint1Click(Sender: TObject);
begin
  FastAddCB('Fixed');
end;

procedure TCavebotFrame.AddMapTool1Click(Sender: TObject);
var
  Ret: BStrArray;
  Text: BStr;
  TargetID, UseID, TargetX, TargetY, TargetZ: BInt32;
  Pattern: BStr;
begin
  if not WikiGuideShownMapTool then begin
    DoOpenURL('http://wiki.bmega.net/doku.php?id=add_types#map_tool');
    WikiGuideShownMapTool := True;
  end;
  Text := 'Your Position:'#10;
  Text := Text + 'X: ' + IntToStr(Me.Position.X) + #10;
  Text := Text + 'Y: ' + IntToStr(Me.Position.Y) + #10;
  Text := Text + 'Z: ' + IntToStr(Me.Position.Z) + #10;
  Text := Text + 'Read the Wiki for a tutorial!';
  if GambitBox('Cavebot Map Tool', Text, 'TargetID, UseID, TargetX, TargetY, TargetZ', False, Ret) then begin
    TargetID := BStrTo32(Ret[0], -1);
    UseID := BStrTo32(Ret[1], -1);
    TargetX := BStrTo32(Ret[2], -1);
    TargetY := BStrTo32(Ret[3], -1);
    TargetZ := BStrTo32(Ret[4], -1);
    if (TargetID = -1) or (UseID = -1) or (TargetX = -1) or (TargetY = -1) or (TargetZ = -1) then
      Exit;
    Pattern := 'Target: %d Use: %d Pos: %d %d %d';
    FastAddCB('MapTool', BFormat(Pattern, [TargetID, UseID, TargetX, TargetY, TargetZ]));
  end;
end;

procedure TCavebotFrame.WaypointAddPoint(Pos: BPos);
begin
  FastAddCB('Point', Pos);
end;

procedure TCavebotFrame.FullCheck1Click(Sender: TObject);
var
  Ret: BStrArray;
  Text: BStr;
begin
  if not WikiGuideShownFullCheck then begin
    DoOpenURL('http://wiki.bmega.net/doku.php?id=add_types#full_check');
    WikiGuideShownFullCheck := True;
  end;
  Text := 'Read the Wiki for a tutorial!';
  if GambitBox('Cavebot Full Check', 'FullCheck Code', 'Code', False, Ret) then
    FastAddCB('FullCheck', Ret[0]);
end;

procedure TCavebotFrame.InsertMacro1Click(Sender: TObject);
var
  F: TForm;
  C: TComboBox;
  B: TButton;
  L: TLabel;
  I: BInt32;
begin
  F := TForm.Create(nil);
  L := TLabel.Create(nil);
  C := TComboBox.Create(nil);
  B := TButton.Create(nil);

  F.Caption := 'Cavebot Macro';

  L.Parent := F;
  L.Caption := 'Select a macro:';
  L.AutoSize := True;
  L.Left := 4;
  L.Top := 4;

  C.Parent := F;
  C.Top := L.Top + L.Height + 4;
  C.Left := L.Left;
  C.Width := L.Width * 2;
  C.Height := 25;
  for I := 0 to TFMain(FMain).MacrosFrame.lstMacros.Items.Count - 1 do
    C.Items.Add(BStrBetween(TFMain(FMain).MacrosFrame.lstMacros.Items.Strings[I], '{', '}'));

  B.Parent := F;
  B.Caption := 'Ok';
  B.ModalResult := mrOk;
  B.Left := C.Width + 4 + C.Left;
  B.Top := C.Top;
  B.Height := C.Height;

  F.Width := B.Width + B.Left + 12 + GetSystemMetrics(SM_CYBORDER);
  F.Height := C.Height + C.Top + GetSystemMetrics(SM_CYCAPTION) + 12;
  F.Position := poMainFormCenter;
  F.BorderStyle := bsDialog;

  if F.ShowModal = mrOk then
    if C.Text <> '' then
      FastAddCB('Macro', C.Text);

  B.Free;
  C.Free;
  L.Free;
  F.Free;
end;

procedure TCavebotFrame.ReOpenBackpacks1Click(Sender: TObject);
begin
  FastAddCB('ResetBackpacks');
end;

procedure TCavebotFrame.NoKillOffPoint1Click(Sender: TObject);
begin
  FastAddCB('NoKill', 'Off');
end;

procedure TCavebotFrame.NoKillOnPoint1Click(Sender: TObject);
begin
  FastAddCB('NoKill', 'On');
end;

procedure TCavebotFrame.ResetTasks1Click(Sender: TObject);
begin
  FastAddCB('ResetTasks');
end;

procedure TCavebotFrame.OpenCorpseOff1Click(Sender: TObject);
begin
  FastAddCB('OpenCorpse', 'Off');
end;

procedure TCavebotFrame.OpenCorpses1Click(Sender: TObject);
begin
  FastAddCB('OpenCorpse', 'On');
end;

procedure TCavebotFrame.FullCheckLabel1Click(Sender: TObject);
var
  Ret: BStrArray;
  Text: BStr;
begin
  if not WikiGuideShownFullCheck then begin
    DoOpenURL('http://wiki.bmega.net/doku.php?id=add_types#full_check_label');
    WikiGuideShownFullCheck := True;
  end;
  Text := 'Read the Wiki for a tutorial!';
  if GambitBox('Cavebot Full Check', 'FullCheck Code', 'Code, Label On Full, Else', False, Ret) then
    FastAddCB('FullCheck', BFormat('Full %s Else %s Code %s', [Ret[1], Ret[2], Ret[0]]));
end;

procedure TCavebotFrame.Buy1Click(Sender: TObject);
var
  Ret: BStrArray;
begin
  if GambitBox('Cavebot Buy', 'Setup for a BUY ITEM on a NPC TRADE.', 'ID, Total', False, Ret) then begin
    FastAddCBNPCHi();
    FastAddCB('NPCSay', 'trade');
    FastAddCB('Buy', Ret[0] + ' ' + Ret[1]);
  end;
end;

procedure TCavebotFrame.Withdraw1Click(Sender: TObject);
var
  Ret: BStrArray;
begin
  if GambitBox('Cavebot Bank Withdraw', 'Setup for a WITHDRAW.', 'ID, UnitPrice, Total', False, Ret) then begin
    FastAddCBNPCHi();
    FastAddCB('NPCSay', 'withdraw');
    FastAddCB('Withdraw', Ret[0] + ' ' + Ret[1] + ' ' + Ret[2]);
    FastAddCB('NPCSay', 'yes');
  end;
end;

procedure TCavebotFrame.ApplySettings(Sender: TObject);
begin
  SetCavebot;
end;

procedure TCavebotFrame.Sell1Click(Sender: TObject);
var
  Ret: BStrArray;
begin
  if GambitBox('Cavebot Sell', 'Setup for a item sell.', 'ID', False, Ret) then begin
    FastAddCBNPCHi();
    FastAddCB('NPCSay', 'trade');
    FastAddCB('Sell', Ret[0]);
  end;
end;

procedure TCavebotFrame.SupliesWithdraw1Click(Sender: TObject);
var
  Ret: BStrArray;
  Text: BStr;
begin
  if not WikiGuideShownSuplies then begin
    DoOpenURL('http://wiki.bmega.net/doku.php?id=add_types&#suplies_withdraw');
    WikiGuideShownSuplies := True;
  end;
  Text := 'Read the Wiki for a tutorial!';
  if GambitBox('Cavebot Suplies Withdraw', 'SupliesWithdraw Code', 'Item List', False, Ret) then
    FastAddCB('SupliesWithdraw', Ret[0]);
end;

procedure TCavebotFrame.TimerCavebot;
begin
  if BBot.Cavebot.Enabled then
    lstCBWPT.ItemIndex := BBot.Cavebot.Current.Index;
  lblCavebotX.Caption := IntToStr(Me.Position.X);
  lblCavebotY.Caption := IntToStr(Me.Position.Y);
  lblCavebotZ.Caption := IntToStr(Me.Position.Z);
  if BBot.Cavebot.Enabled <> chkCBa.Checked then
    chkCBa.Checked := BBot.Cavebot.Enabled;

end;

procedure TCavebotFrame.Clear1Click(Sender: TObject);
var
  MRet: BInt32;
begin
  MRet := MessageDlg('Are you sure to clear the waypoint list?', mtConfirmation, [mbYes, mbNo], 0);
  if MRet = mrYes then
    lstCBWPT.Clear;
end;

procedure TCavebotFrame.CopyCodes3Click(Sender: TObject);
var
  I: BInt32;
  S: BStr;
begin
  S := '';
  for I := 0 to lstCBWPT.Items.Count - 1 do
    S := S + lstCBWPT.Items[I] + #13#10;
  TFMain(FMain).SetClipboard(S);
end;

constructor TCavebotFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  init;
end;

procedure TCavebotFrame.FastAddCB(AText: BStr);
begin
  FastAddCB(AText, '');
end;

procedure TCavebotFrame.FastAddCB(AText, AParam: BStr);
begin
  FastAddCB(AText, AParam, Me.Position);
end;

procedure TCavebotFrame.FastAddCB(AText: BStr; APosition: BPos);
begin
  FastAddCB(AText, '', APosition);
end;

procedure TCavebotFrame.FastAddCB(AText, AParam: BStr; APosition: BPos);
var
  S: BStr;
begin
  S := BFormat('%s (%s%s)', [AText, BStr(APosition), BIf(AParam = '', '', ':' + AParam)]);
  if AText <> 'Point' then
    if TFMain(FMain).MutexAcquire then begin
      BBot.Cavebot.LearnIgnoreNextFrom := True;
      TFMain(FMain).MutexRelease;
    end;
  if (CavebotInsertIndex <> -1) and (CavebotInsertIndex < lstCBWPT.Items.Count) then begin
    lstCBWPT.Items.Insert(CavebotInsertIndex + 1, S);
    Inc(CavebotInsertIndex);
  end else begin
    lstCBWPT.Items.Add(S);
    CavebotInsertIndex := -1;
  end;
end;

procedure TCavebotFrame.FastAddCBNPCHi;
var
  S: BStr;
begin
  if lstCBWPT.Items.Count > 0 then begin
    if (CavebotInsertIndex <> -1) and (CavebotInsertIndex < lstCBWPT.Items.Count) then
      S := lstCBWPT.Items.Strings[CavebotInsertIndex]
    else
      S := lstCBWPT.Items.Strings[lstCBWPT.Items.Count - 1];
  end
  else
    S := '';
  // If last point was: Say (X Y Z:hi), skip new 'hi'
  if BStrStart(S, 'Say ') and BStrEnd(S, ':hi)') then
    Exit;
  // If last point was: NPCSay|Buy|Sell|Withdraw (X Y Z:??), skip new 'hi'
  if BStrStart(S, 'NPCSay ') or BStrStart(S, 'Buy ') or BStrStart(S, 'Sell ') or BStrStart(S, 'Withdraw ') then
    Exit;
  FastAddCB('Say', 'hi');
end;

procedure TCavebotFrame.lstCBWPTDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
begin
  BStrSplit(lstCBWPT.Items[Index], ' ', A, B);
  if Index = BBot.Cavebot.StartItemIndex then
    A := '[Start]' + A;
  if Index = CavebotInsertIndex then
    A := '[Insert]' + A;
  BListDrawItem(lstCBWPT.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TCavebotFrame.UnselectClick(Sender: TObject);
begin
  if lstCBWPT.ItemIndex <> -1 then
    lstCBWPT.ItemIndex := -1;
end;

procedure TCavebotFrame.PasteCodes4Click(Sender: TObject);
var
  I: BInt32;
  Res: BStrArray;
begin
  BStrSplit(Res, #13#10, TFMain(FMain).GetClipboard);
  for I := 0 to High(Res) do
    if BTrim(Res[I]) <> '' then
      lstCBWPT.AddItem(BTrim(Res[I]), nil);
end;

procedure TCavebotFrame.lstCBWPTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
end;

function TCavebotFrame.MutexAcquire: BBool;
begin
  Exit(TFMain(FMain).MutexAcquire);
end;

procedure TCavebotFrame.MutexRelease;
begin
  TFMain(FMain).MutexRelease;
end;

procedure TCavebotFrame.Edit1Click(Sender: TObject);
var
  S: string;
begin
  if lstCBWPT.ItemIndex <> -1 then begin
    S := lstCBWPT.Items[lstCBWPT.ItemIndex];
    if InputQuery('Waypoint Edit', 'Editing a waypoint item', S) then
      lstCBWPT.Items[lstCBWPT.ItemIndex] := S;
  end;
end;

end.
