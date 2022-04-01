unit uKillerFrame;

interface

uses
  uBTypes,
  BBotEngine,
  uBVector,
  Declaracoes,
  Jsons,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TKillerFrame = class(TFrame)
    chkKillerAttackAll: TCheckBox;
    chkKillerAllowAttackPlayers: TCheckBox;
    chkAvoidKS: TCheckBox;
    Label18: TLabel;
    Label41: TLabel;
    Label50: TLabel;
    Label48: TLabel;
    lstKillerTargets: TListBox;
    cmbKillerNewMacroStop: TComboBox;
    chkKillerNewMacroStop: TCheckBox;
    cmbKillerNewMacroStart: TComboBox;
    chkKillerNewMacroStart: TCheckBox;
    cmbKillerNewMacroAuto: TComboBox;
    chkKillerNewMacroAuto: TCheckBox;
    chkKillerNewDiagonal: TCheckBox;
    KillerNewTargetKeepDistance: TCheckBox;
    numKillerNewDist: TMemo;
    Label84: TLabel;
    cmbKillerNewPriority: TComboBox;
    Label83: TLabel;
    Label79: TLabel;
    cmbKillerNewName: TComboBox;
    Label35: TLabel;
    btnKillerNewAdd: TButton;
    GoAdvancedAttack: TLabel;
    AvoidAOERamps: TCheckBox;
    AttackNotReachable: TCheckBox;
    procedure KillerNewTargetKeepDistanceClick(Sender: TObject);
    procedure numKillerNewDistChange(Sender: TObject);
    procedure cmbKillerNewNameDropDown(Sender: TObject);
    procedure cmbKillerNewPriorityDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstKillerTargetsDblClick(Sender: TObject);
    procedure lstKillerTargetsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstKillerTargetsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnKillerNewAddClick(Sender: TObject);
    procedure MacroSetup(Sender: TObject);
    procedure ApplySettings(Sender: TObject);
    procedure MacroCloseUp(Sender: TObject);
    procedure MacroList(Sender: TObject);
    procedure GoAdvancedAttackMouseLeave(Sender: TObject);
    procedure GoAdvancedAttackMouseEnter(Sender: TObject);
    procedure GoAdvancedAttackClick(Sender: TObject);
  protected
    FMain: TForm;
    procedure Init;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetAttacker;
    procedure MigrateAdvAttacks;
    property KillerTargets: TListBox read lstKillerTargets;
  end;

implementation

{$R *.dfm}

uses
  uAdvancedAttackFrame,
  uMain;

procedure TKillerFrame.ApplySettings(Sender: TObject);
begin
  SetAttacker;
end;

procedure TKillerFrame.btnKillerNewAddClick(Sender: TObject);
var
  I: Integer;
begin
  for I := lstKillerTargets.Count - 1 downto 0 do
    if AnsiSameText(BStrLeft(lstKillerTargets.Items[I], ':'), cmbKillerNewName.Text) then
      lstKillerTargets.Items.Delete(I);
  lstKillerTargets.Items.Add(Format('%s:%d:%s:%s:%s:%s:%s', [cmbKillerNewName.Text,
    BInt32(ComboSelectedObj(cmbKillerNewPriority)), numKillerNewDist.Text, BIF(chkKillerNewDiagonal.Checked, '1', '0'),
    BIF(chkKillerNewMacroAuto.Checked, cmbKillerNewMacroAuto.Text, ''), BIF(chkKillerNewMacroStart.Checked,
    cmbKillerNewMacroStart.Text, ''), BIF(chkKillerNewMacroStop.Checked, cmbKillerNewMacroStop.Text, '')]));
  TFMain(FMain).AutomationToolsSettings(Sender);
end;

procedure TKillerFrame.cmbKillerNewNameDropDown(Sender: TObject);
begin
  cmbKillerNewName.Items.Clear;
  cmbKillerNewName.Items.Add('Default Player');
  cmbKillerNewName.Items.Add('Default Creature');
  BBot.Creatures.KnownCreatureNames.ForEach(
    procedure(AIt: BVector<BStr>.It)
    begin
      cmbKillerNewName.Items.Add(AIt^);
    end);
end;

procedure TKillerFrame.cmbKillerNewPriorityDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
State: TOwnerDrawState);
var
  A, B: BStr;
begin
  BStrSplit(cmbKillerNewPriority.Items[Index], ' ', A, B);
  BListDrawItem(cmbKillerNewPriority.Canvas, Index, odSelected in State, Rect, A, B);
end;

constructor TKillerFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TKillerFrame.Init;
begin
  cmbKillerNewPriority.AddItem('- Ignore', TObject(6));
  cmbKillerNewPriority.AddItem('- Avoid', TObject(7));
  cmbKillerNewPriority.AddItem('+0 No Priority', TObject(0));
  cmbKillerNewPriority.AddItem('+1 Low', TObject(1));
  cmbKillerNewPriority.AddItem('+2 Medium', TObject(2));
  cmbKillerNewPriority.AddItem('+3 High', TObject(3));
  cmbKillerNewPriority.AddItem('+4 Very High', TObject(4));
  cmbKillerNewPriority.AddItem('+5 Ultra High', TObject(5));
  cmbKillerNewPriority.ItemIndex := 2;
end;

procedure TKillerFrame.KillerNewTargetKeepDistanceClick(Sender: TObject);
begin
  numKillerNewDist.Enabled := KillerNewTargetKeepDistance.Checked;
  if KillerNewTargetKeepDistance.Checked then
    numKillerNewDist.Text := '1'
  else
    numKillerNewDist.Text := '0';
end;

procedure TKillerFrame.lstKillerTargetsDblClick(Sender: TObject);
var
  R: BStrArray;
  I: BInt32;
begin
  if lstKillerTargets.ItemIndex = -1 then
    Exit;
  if BStrSplit(R, ':', lstKillerTargets.Items[lstKillerTargets.ItemIndex]) < 6 then
    Exit;
  cmbKillerNewName.Text := R[0];
  I := BStrTo32(R[1], 0);
  if I < 6 then
    cmbKillerNewPriority.ItemIndex := I + 2
  else
    cmbKillerNewPriority.ItemIndex := I - 6;
  KillerNewTargetKeepDistance.Checked := R[2] <> '0';
  numKillerNewDist.Text := R[2];
  numKillerNewDist.Enabled := KillerNewTargetKeepDistance.Checked;
  chkKillerNewDiagonal.Checked := R[3] = '1';
  chkKillerNewMacroAuto.Checked := R[4] <> '';
  cmbKillerNewMacroAuto.Text := R[4];
  chkKillerNewMacroStart.Checked := R[5] <> '';
  cmbKillerNewMacroStart.Text := R[5];
  chkKillerNewMacroStop.Checked := R[6] <> '';
  cmbKillerNewMacroStop.Text := R[6];
  numKillerNewDistChange(Sender);
end;

procedure TKillerFrame.lstKillerTargetsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
State: TOwnerDrawState);
var
  A: BStr;
  B: BStr;
  P: BInt32;
begin
  A := '?';
  B := lstKillerTargets.Items[Index];
  P := AnsiPos(':', lstKillerTargets.Items[Index]);
  if P > 0 then begin
    B := Copy(lstKillerTargets.Items[Index], 1, P - 1);
    A := Copy(lstKillerTargets.Items[Index], P + 1, 1);
    if (A = '6') or (A = '7') then
      A := '-'
    else
      A := '+' + A;
  end;
  BListDrawItem(lstKillerTargets.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TKillerFrame.lstKillerTargetsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Selected: BInt32;
begin
  if ssShift in Shift then begin
    Selected := lstKillerTargets.ItemIndex;
    if Selected <> -1 then
      if Key = VK_DELETE then
        lstKillerTargets.Items.Delete(Selected);
  end;
end;

procedure TKillerFrame.MacroCloseUp(Sender: TObject);
begin
  TFMain(FMain).MacroCloseUp(Sender);
end;

procedure TKillerFrame.MacroList(Sender: TObject);
begin
  TFMain(FMain).MacroList(Sender);
end;

procedure TKillerFrame.MacroSetup(Sender: TObject);
begin
  cmbKillerNewMacroAuto.Enabled := chkKillerNewMacroAuto.Checked;
  cmbKillerNewMacroStart.Enabled := chkKillerNewMacroStart.Checked;
  cmbKillerNewMacroStop.Enabled := chkKillerNewMacroStop.Checked;
end;

procedure TKillerFrame.MigrateAdvAttacks;
const
  OldAttackDelimiter: BStr = ':Atk@';
var
  I: BInt32;
  S, Code, Name, Atk: BStr;
  Data: TJson;
  Creatures: TJsonArray;
begin
  for I := 0 to lstKillerTargets.Items.Count - 1 do begin
    S := lstKillerTargets.Items.Strings[I];
    if BStrPos(OldAttackDelimiter, S) > 0 then begin
      Atk := BTrim(BStrRight(S, OldAttackDelimiter));
      Name := BTrim(BStrLeft(S, ':'));

      if Atk <> '' then begin
        Data := TJson.Create;
        Data.Put('name', Name);
        Data.Put('action', Atk);
        Creatures := Data.Put('creatures', empty).AsArray;
        if Name = 'Default Creature' then
          Creatures.Put('%Monsters')
        else if Name = 'Default Player' then
          Creatures.Put('%Players')
        else
          Creatures.Put(Name);
        Data.Put('type', 'Single');
        Code := Name + StrAdvancedAttackDataDelimiter + Data.Stringify;
        Data.Free;
      end else begin
        Code := '';
      end;

      TFMain(FMain).AddDebug(':: ATTACK MIGRATION BEGIN ::');
      TFMain(FMain).AddDebug(BFormat('Migrating %s', [OldAttackDelimiter]));
      TFMain(FMain).AddDebug(BFormat('Creature: %s', [Name]));
      TFMain(FMain).AddDebug(BFormat('Attack: %s', [Atk]));
      TFMain(FMain).AddDebug(BFormat('From: %s', [S]));
      TFMain(FMain).AddDebug(BFormat('To: %s', [BStrLeft(S, OldAttackDelimiter)]));
      TFMain(FMain).AddDebug(BFormat('Created new AdvAttack: %s', [Code]));
      TFMain(FMain).AddDebug(':: ATTACK MIGRATION END ::');

      if Code <> '' then
        TFMain(FMain).AdvancedAttackFrame.AdvancedAttackList.AddItem(Code, nil);

      S := BStrLeft(S, OldAttackDelimiter);
      lstKillerTargets.Items.Strings[I] := S;
    end;
  end;
end;

procedure TKillerFrame.numKillerNewDistChange(Sender: TObject);
begin
  if BTrim(numKillerNewDist.Text) = '0' then
    KillerNewTargetKeepDistance.Checked := False;
end;

procedure TKillerFrame.SetAttacker;
var
  I: BInt32;
begin
  if TFMain(FMain).MutexAcquire then begin
    BBot.Attacker.Enabled := chkKillerAttackAll.Checked;
    BBot.Attacker.NeverAttackPlayers := not chkKillerAllowAttackPlayers.Checked;
    BBot.Attacker.AvoidKS := chkAvoidKS.Checked;
    BBot.Attacker.AttackNotReachable := AttackNotReachable.Checked;
    BBot.AdvAttack.AvoidChangeFloorAOE := AvoidAOERamps.Checked;
    BBot.AdvAttack.ClearCreatureSettings;
    if lstKillerTargets.Items.Count > 0 then
      for I := 0 to lstKillerTargets.Items.Count - 1 do
        BBot.AdvAttack.AddCreatureSetting(lstKillerTargets.Items[I]);
    TFMain(FMain).MutexRelease;
  end;
end;

procedure TKillerFrame.GoAdvancedAttackClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbAdvancedAttack);
end;

procedure TKillerFrame.GoAdvancedAttackMouseEnter(Sender: TObject);
begin
  TFMain(FMain).LinkEnter(Sender);
end;

procedure TKillerFrame.GoAdvancedAttackMouseLeave(Sender: TObject);
begin
  TFMain(FMain).LinkLeave(Sender);
end;

end.
