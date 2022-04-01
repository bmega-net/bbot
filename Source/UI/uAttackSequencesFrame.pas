unit uAttackSequencesFrame;

interface

uses
  uBTypes,
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
  uBBotItemSelector;

type
  TAttackSequencesFrame = class(TFrame)
    Label94: TLabel;
    lstAttackSequences: TListBox;
    btnAtkSeqDone: TButton;
    Label93: TLabel;
    edtAtkSeq: TEdit;
    btnAtkSeqSave: TButton;
    lstEditAtkSeq: TListBox;
    Label63: TLabel;
    Label123: TLabel;
    numAtkSeqMana: TMemo;
    numAtkSeqHPMin: TMemo;
    Label133: TLabel;
    chkAtkSeqVariableCheck: TCheckBox;
    edtAtkSeqVariable: TEdit;
    numAtkSeqHPMax: TMemo;
    Label135: TLabel;
    numAtkSeqWait: TMemo;
    Label71: TLabel;
    cmbAtkSeqMacro: TComboBox;
    edtAtkSeqSpell: TEdit;
    Label126: TLabel;
    Label127: TLabel;
    Label129: TLabel;
    Label128: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label51: TLabel;
    cmbAtkSeqRune: TComboBox;
    SelectWaitAction: TRadioButton;
    SelectMacroAction: TRadioButton;
    SelectItemAction: TRadioButton;
    SelectSpellAction: TRadioButton;
    SaveAction: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FastAddAtkSeq(AKind, AParamInt, AParamStr: BStr);
    procedure lstEditAtkSeqKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAtkSeqSaveClick(Sender: TObject);
    procedure btnAtkSeqDoneClick(Sender: TObject);
    procedure lstAttackSequencesDblClick(Sender: TObject);
    procedure lstAttackSequencesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstAttackSequencesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkAtkSeqVariableCheckClick(Sender: TObject);
    procedure lstEditAtkSeqDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cmbAtkSeqMacroDropDown(Sender: TObject);
    procedure cmbAtkSeqMacroCloseUp(Sender: TObject);
    procedure lstEditAtkSeqDblClick(Sender: TObject);
    procedure ActionSelectionClick(Sender: TObject);
    procedure SaveActionClick(Sender: TObject);
  protected
    FMain: TForm;
    RuneComboSelector: TBBotItemSelectorApply;
    procedure Init;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetAttackSequences;
    procedure AddAttackSequences(const AList: TStrings);
  end;

implementation

{$R *.dfm}

uses
  uMain,
  BBotEngine,
  uTibiaDeclarations,
  Declaracoes,
  uItem;

procedure TAttackSequencesFrame.AddAttackSequences(const AList: TStrings);
var
  I: BInt32;
begin
  AList.Clear;
  AList.AddObject(StrManageAttackSequen, nil);
  for I := 0 to lstAttackSequences.Count - 1 do
    AList.AddObject(BStrBetween(lstAttackSequences.Items.Strings[I], '{', '}'), nil);
end;

procedure TAttackSequencesFrame.btnAtkSeqDoneClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBoxLast;
end;

procedure TAttackSequencesFrame.btnAtkSeqSaveClick(Sender: TObject);
var
  S: BStr;
  I: BInt32;
begin
  for I := lstAttackSequences.Count - 1 downto 0 do
    if BStrEqual(BStrBetween(lstAttackSequences.Items.Strings[I], '{', '}'), edtAtkSeq.Text) then
      lstAttackSequences.Items.Delete(I);
  S := Format('{%s}', [edtAtkSeq.Text]);
  for I := 0 to lstEditAtkSeq.Items.Count - 1 do
    S := S + lstEditAtkSeq.Items.Strings[I] + ';';
  lstAttackSequences.AddItem(S, nil);
  SetAttackSequences;
end;

procedure TAttackSequencesFrame.chkAtkSeqVariableCheckClick(Sender: TObject);
begin
  edtAtkSeqVariable.Enabled := chkAtkSeqVariableCheck.Checked;
  if not chkAtkSeqVariableCheck.Checked then
    edtAtkSeqVariable.Text := '';
end;

procedure TAttackSequencesFrame.cmbAtkSeqMacroCloseUp(Sender: TObject);
begin
  TFMain(FMain).MacroCloseUp(Sender);
end;

procedure TAttackSequencesFrame.cmbAtkSeqMacroDropDown(Sender: TObject);
begin
  TFMain(FMain).MacroList(Sender);
end;

constructor TAttackSequencesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TAttackSequencesFrame.FastAddAtkSeq(AKind, AParamInt, AParamStr: BStr);
begin
  lstEditAtkSeq.AddItem(BFormat('%s %d %d %d %d Check %s ECheck:%s', [AKind, BStrTo32(numAtkSeqMana.Text),
    BStrTo32(numAtkSeqHPMin.Text), BStrTo32(numAtkSeqHPMax.Text), BStrTo32(AParamInt), edtAtkSeqVariable.Text,
    AParamStr]), nil);
end;

procedure TAttackSequencesFrame.Init;
begin
  RuneComboSelector := TFMain(FMain).BBotItemSelector //
    .Apply(cmbAtkSeqRune, 'AttackSequences') //
    .add([ //
    ItemID_StalagmiteRune, //
    ItemID_ThunderstormRune, //
    ItemID_StoneShowerRune, //
    ItemID_AvalancheRune, //
    ItemID_IcicleRune, //
    ItemID_SuddenDeathRune, //
    ItemID_ExplosionRune, //
    ItemID_HeavyMagicMissileRune, //
    ItemID_LightMagicMissileRune, //
    ItemID_EnergyWallRune, //
    ItemID_EnergyBombRune, //
    ItemID_GreatFireballRune, //
    ItemID_FireballRune, //
    ItemID_SoulfireRune, //
    ItemID_FireWallRune, //
    ItemID_FireBombRune, //
    ItemID_FireFieldRune, //
    ItemID_PoisonWallRune, //
    ItemID_PoisonBombRune, //
    ItemID_PoisonFieldRune, //
    ItemID_HolyMissileRune, //
    ItemID_ParalyzeRune //
    ]) //
    .addCustomItemSupport //
    .selectFirst;
end;

procedure TAttackSequencesFrame.lstAttackSequencesDblClick(Sender: TObject);
var
  S: BStr;
  I: BInt32;
  R: BStrArray;
begin
  if lstAttackSequences.ItemIndex <> -1 then begin
    S := lstAttackSequences.Items.Strings[lstAttackSequences.ItemIndex];
    edtAtkSeq.Text := BStrBetween(S, '{', '}');
    Delete(S, 1, Length(edtAtkSeq.Text) + 2);
    BStrSplit(R, ';', S);
    lstEditAtkSeq.Items.Clear;
    for I := 0 to High(R) do
      if Trim(R[I]) <> '' then
        lstEditAtkSeq.AddItem(Trim(R[I]), nil);
  end;
end;

procedure TAttackSequencesFrame.lstAttackSequencesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  A: BStr;
begin
  A := BStrBetween(lstAttackSequences.Items[Index], '{', '}');
  BListDrawItem(lstAttackSequences.Canvas, Index, odSelected in State, Rect, A);
end;

procedure TAttackSequencesFrame.lstAttackSequencesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
end;

procedure TAttackSequencesFrame.lstEditAtkSeqDblClick(Sender: TObject);
var
  R: BStrArray;
  S: BStr;
  C: BStr;
begin
  S := lstEditAtkSeq.Items[lstEditAtkSeq.ItemIndex];
  C := BStrRight(S, 'ECheck:');
  edtAtkSeqVariable.Text := BStrBetween(S, 'Check ', ' ECheck:');
  chkAtkSeqVariableCheck.Checked := edtAtkSeqVariable.Text <> '';
  if BStrSplit(R, ' ', S) > 3 then begin
    numAtkSeqMana.Text := R[1];
    numAtkSeqHPMin.Text := R[2];
    numAtkSeqHPMax.Text := R[3];
    if R[0] = '!' then begin
      numAtkSeqWait.Text := R[4];
      SelectWaitAction.Checked := True;
    end else if R[0] = '@' then begin
      RuneComboSelector.selectById(BStrTo32(R[4], 0));
      SelectItemAction.Checked := True;
    end else if R[0] = '$' then begin
      edtAtkSeqSpell.Text := C;
      SelectSpellAction.Checked := True;
    end else if R[0] = '#' then begin
      cmbAtkSeqMacro.ItemIndex := cmbAtkSeqMacro.Items.IndexOf(C);
      SelectMacroAction.Checked := True;
    end;
  end;
end;

procedure TAttackSequencesFrame.lstEditAtkSeqDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  A, B, C: BStr;
  ID: BUInt32;
  R: BStrArray;
  IcoRect: TRect;
begin
  ID := 0;
  B := lstEditAtkSeq.Items.Strings[Index];
  BStrSplit(R, ' ', B);
  C := BStrRight(B, 'ECheck:');
  if Length(R[0]) = 1 then
    case R[0][1] of
    '!': begin
        A := 'Wait';
        B := R[4] + ' ms';
      end;
    '@': begin
        ID := BStrTo32(R[4], 0);

        if (ID > 0) and (ID <= TibiaMaxItems) then
          A := TibiaItems[ID].Name
        else
          A := 'Item ' + BToStr(ID);

        B := R[4];
      end;
    '$': begin
        A := 'Spell';
        B := C;
      end;
    '#': begin
        A := 'Macro';
        B := C;
      end;
    end;

  IcoRect := TRect.Create(Rect);
  IcoRect.Right := IcoRect.Left + lstEditAtkSeq.ItemHeight - 2;

  if ID <> 0 then
    Rect.Left := IcoRect.Right;

  BListDrawItem(lstEditAtkSeq.Canvas, Index, odSelected in State, Rect, A, B);

  if ID <> 0 then begin
    lstEditAtkSeq.Canvas.FillRect(IcoRect);
    lstEditAtkSeq.Canvas.StretchDraw(IcoRect, TFMain(FMain).BBotItemSelector.Sprite[ID].Graphic);
  end;
end;

procedure TAttackSequencesFrame.lstEditAtkSeqKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
end;

procedure TAttackSequencesFrame.ActionSelectionClick(Sender: TObject);
begin
  numAtkSeqWait.Enabled := SelectWaitAction.Checked;
  cmbAtkSeqMacro.Enabled := SelectMacroAction.Checked;
  cmbAtkSeqRune.Enabled := SelectItemAction.Checked;
  edtAtkSeqSpell.Enabled := SelectSpellAction.Checked;
end;

procedure TAttackSequencesFrame.SaveActionClick(Sender: TObject);
begin
  if SelectMacroAction.Checked then
    FastAddAtkSeq('#', '0', cmbAtkSeqMacro.Text)
  else if SelectItemAction.Checked then
    FastAddAtkSeq('@', BToStr(RuneComboSelector.ID), '')
  else if SelectSpellAction.Checked then
    FastAddAtkSeq('$', '0', edtAtkSeqSpell.Text)
  else if SelectWaitAction.Checked then
    FastAddAtkSeq('!', numAtkSeqWait.Text, '');
end;

procedure TAttackSequencesFrame.SetAttackSequences;
begin
  TFMain(FMain).MutexScopped(
    procedure
    var
      I: BInt32;
    begin
      BBot.AdvAttack.ClearSequences;
      for I := 0 to lstAttackSequences.Count - 1 do
        BBot.AdvAttack.AddSequence(lstAttackSequences.Items[I]);
    end);
end;

end.
