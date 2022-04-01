unit uAdvancedAttackFrame;

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
  Vcl.CheckLst,
  uBTypes,
  Declaracoes,
  AdvancedAttackWaveFormatDesigner,
  uEngine;

type
  TAdvancedAttackFrame = class(TFrame)
    Label208: TLabel;
    AdvancedAttackList: TListBox;
    Label209: TLabel;
    Label219: TLabel;
    AdvancedAttackCreatures: TCheckListBox;
    Label210: TLabel;
    AdvancedAttackTriggerKind: TRadioGroup;
    AdvancedAttackWaverPanel: TPanel;
    Label217: TLabel;
    AdvancedAttackLabelAreaTitle2: TLabel;
    Label218: TLabel;
    AdvancedAttackWaveMinCreatures: TMemo;
    AdvancedAttackSelfShooterPanel: TPanel;
    Label215: TLabel;
    Label216: TLabel;
    AdvancedAttackLabelAreaTitle: TLabel;
    AdvancedAttackSelfAreaRadius: TMemo;
    AdvancedAttackSelfAreaMinCreatures: TMemo;
    WaveFormatDesignerPlaceholder: TPanel;
    Label188: TLabel;
    Label189: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RefreshTargetCreatures: TTimer;
    Label7: TLabel;
    Label8: TLabel;
    AdvancedAttackNameActionPanel: TPanel;
    LastStepLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    AdvancedAttackAction: TComboBox;
    AdvancedAttackName: TEdit;
    Step3placeholder: TLabel;
    AdvancedAttackSavePanel: TPanel;
    AdvancedAttackSave: TButton;
    AdvancedAttackTargetShooterPanel: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    AdvancedAttackTargetAreaRadius: TMemo;
    AdvancedAttackTargetAreaMinCreatures: TMemo;
    Label12: TLabel;
    AdvancedAttackTargetAreaLimitScreen: TComboBox;
    procedure AdvancedAttackCreaturesClick(Sender: TObject);
    procedure AdvancedAttackCreaturesDblClick(Sender: TObject);
    procedure AdvancedAttackCreaturesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure AdvancedAttackTriggerKindClick(Sender: TObject);
    procedure AdvancedAttackListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure AdvancedAttackSaveClick(Sender: TObject);
    procedure AdvancedAttackActionDropDown(Sender: TObject);
    procedure AdvancedAttackActionCloseUp(Sender: TObject);
    procedure AdvancedAttackListDblClick(Sender: TObject);
    procedure AdvancedAttackListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefreshTargetCreaturesTimer(Sender: TObject);
    procedure AdvancedAttackTargetAreaLimitScreenDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
  private
    WaveFormatDesigner: TAdvancedAttackWaveFormatDesignerFrame;
    FMain: TForm;
    function ContainsCheckedCreature: BBool;
  protected
    procedure Init;
  public
    constructor Create(AOwner: TComponent); override;

    procedure AdvancedAttackSettings;
  end;

resourcestring
  StrAdvancedAttackDataDelimiter = '@Data=';

implementation

{$R *.dfm}

uses
  uMain,
  Jsons,
  BBotEngine,
  uBVector;

procedure TAdvancedAttackFrame.AdvancedAttackActionCloseUp(Sender: TObject);
begin
  TFMain(FMain).onAtkSeqCloseUp(Sender);
end;

procedure TAdvancedAttackFrame.AdvancedAttackActionDropDown(Sender: TObject);
begin
  TFMain(FMain).onAtkSeqDropDown(Sender);
end;

procedure TAdvancedAttackFrame.AdvancedAttackCreaturesClick(Sender: TObject);
begin
  AdvancedAttackCreatures.Checked[AdvancedAttackCreatures.Items.Count - 1] := False;
end;

procedure TAdvancedAttackFrame.AdvancedAttackCreaturesDblClick(Sender: TObject);
var
  Name: BStr;
begin
  if AdvancedAttackCreatures.ItemIndex = AdvancedAttackCreatures.Items.Count - 1 then begin
    Name := InputBox('New creature name', 'Add creature', '');
    if Name <> '' then begin
      AdvancedAttackCreatures.Items.Insert(AdvancedAttackCreatures.Items.Count - 1, Name);
    end;
  end;
end;

procedure TAdvancedAttackFrame.AdvancedAttackCreaturesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  A, B: BStr;
begin
  A := '';
  B := AdvancedAttackCreatures.Items[Index];
  if BStrStartSensitive(B, '%') then begin
    A := BStrCopy(B, 2, Length(B) - 1);
    B := '';
  end;
  BListDrawItem(AdvancedAttackCreatures.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TAdvancedAttackFrame.AdvancedAttackListDblClick(Sender: TObject);
var
  Data: TJson;
  Creatures: TJsonArray;
  Kind, Creature: BStr;
  I, J: BInt32;
begin
  if AdvancedAttackList.ItemIndex = -1 then
    Exit;
  AdvancedAttackCreatures.CheckAll(cbUnchecked);
  Data := TJson.Create;
  Data.Parse(BStrRight(AdvancedAttackList.Items[AdvancedAttackList.ItemIndex], StrAdvancedAttackDataDelimiter));
  AdvancedAttackName.Text := Data.Get('name').AsString;
  AdvancedAttackAction.Text := Data.Get('action').AsString;
  Creatures := Data.Get('creatures').AsArray;
  for I := 0 to Creatures.Count - 1 do begin

    // ponderacao dos bixos

    Creature := Creatures.Items[I].AsString;
    J := AdvancedAttackCreatures.Items.IndexOf(Creature);
    if J = -1 then begin
      AdvancedAttackCreatures.Items.Insert(AdvancedAttackCreatures.Items.Count - 1, Creature);
      J := AdvancedAttackCreatures.Items.Count - 2;
    end;
    AdvancedAttackCreatures.Checked[J] := True;
  end;
  Kind := Data.Get('type').AsString;
  if BStrEqual(Kind, 'Single') then begin
    AdvancedAttackTriggerKind.ItemIndex := 0;
  end else if BStrEqual(Kind, 'AreaSpell') then begin
    AdvancedAttackTriggerKind.ItemIndex := 1;
    AdvancedAttackSelfAreaMinCreatures.Text := BToStr(Data.Get('minCreatures').AsInteger);
    AdvancedAttackSelfAreaRadius.Text := BToStr(Data.Get('radius').AsInteger);
  end else if BStrEqual(Kind, 'AreaShooter') then begin
    AdvancedAttackTriggerKind.ItemIndex := 2;
    AdvancedAttackTargetAreaMinCreatures.Text := BToStr(Data.Get('minCreatures').AsInteger);
    AdvancedAttackTargetAreaRadius.Text := BToStr(Data.Get('radius').AsInteger);
    AdvancedAttackTargetAreaLimitScreen.ItemIndex := Data.Get('limitScreen').AsInteger;
  end else if BStrEqual(Kind, 'Waver') then begin
    AdvancedAttackTriggerKind.ItemIndex := 3;
    AdvancedAttackWaveMinCreatures.Text := BToStr(Data.Get('minCreatures').AsInteger);
    WaveFormatDesigner.ExpansionFromText(Data.Get('expansion').AsString);
  end;
  Data.Free;
end;

procedure TAdvancedAttackFrame.AdvancedAttackListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Name: BStr;
begin
  Name := BStrLeft(AdvancedAttackList.Items[Index], StrAdvancedAttackDataDelimiter);
  BListDrawItem(AdvancedAttackList.Canvas, Index, odSelected in State, Rect, Name);
end;

procedure TAdvancedAttackFrame.AdvancedAttackListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
  AdvancedAttackSettings;
end;

procedure TAdvancedAttackFrame.AdvancedAttackSaveClick(Sender: TObject);
var
  Data: TJson;
  Creatures: TJsonArray;
  Code: BStr;
  I: BInt32;
begin
  if Length(AdvancedAttackName.Text) < 3 then begin
    ShowMessage('Please set a name!');
    Exit;
  end;
  if (Length(AdvancedAttackAction.Text) = 0) or (AdvancedAttackAction.Text = StrManageAttackSequen) then begin
    ShowMessage('Please select a action!');
    Exit;
  end;
  if not ContainsCheckedCreature() then begin
    ShowMessage('Please select at least one creature!');
    Exit;
  end;
  Data := TJson.Create;
  Data.Put('name', AdvancedAttackName.Text);
  Data.Put('action', AdvancedAttackAction.Text);
  Creatures := Data.Put('creatures', empty).AsArray;
  for I := 0 to AdvancedAttackCreatures.Items.Count - 1 do
    if AdvancedAttackCreatures.Checked[I] then
      Creatures.Put(BTrim(AdvancedAttackCreatures.Items[I]));
  case AdvancedAttackTriggerKind.ItemIndex of
  0: begin // Single target
      Data.Put('type', 'Single');
    end;
  1: begin // Area Spell
      Data.Put('type', 'AreaSpell');
      Data.Put('minCreatures', BStrTo32(AdvancedAttackSelfAreaMinCreatures.Text));
      Data.Put('radius', BStrTo32(AdvancedAttackSelfAreaRadius.Text));
    end;
  2: begin // Area Shooter
      Data.Put('type', 'AreaShooter');
      Data.Put('minCreatures', BStrTo32(AdvancedAttackTargetAreaMinCreatures.Text));
      Data.Put('radius', BStrTo32(AdvancedAttackTargetAreaRadius.Text));
      Data.Put('limitScreen', AdvancedAttackTargetAreaLimitScreen.ItemIndex);
    end;
  3: begin // Waver
      Data.Put('type', 'Waver');
      Data.Put('minCreatures', BStrTo32(AdvancedAttackWaveMinCreatures.Text));
      Data.Put('expansion', WaveFormatDesigner.ExpansionToText);
    end;
  end;
  Code := AdvancedAttackName.Text + StrAdvancedAttackDataDelimiter + Data.Stringify;
  Data.Free;
  for I := 0 to AdvancedAttackList.Items.Count - 1 do
    if BStrEqual(BStrLeft(AdvancedAttackList.Items[I], '@Data='), AdvancedAttackName.Text) then begin
      AdvancedAttackList.Items[I] := Code;
      AdvancedAttackSettings;
      Exit;
    end;
  AdvancedAttackList.AddItem(Code, nil);
  AdvancedAttackSettings;
end;

procedure TAdvancedAttackFrame.AdvancedAttackSettings;
var
  I: BInt32;
  Json: TJson;
begin
  if TFMain(FMain).MutexAcquire then begin
    Json := TJson.Create;
    try
      BBot.AdvAttack.ClearAdvancedAttacks;
      for I := 0 to AdvancedAttackList.Count - 1 do begin
        Json.Parse(BStrRight(AdvancedAttackList.Items[I], StrAdvancedAttackDataDelimiter));
        BBot.AdvAttack.AddAdvancedAttack(Json);
      end;
    finally Json.Free;
    end;
    TFMain(FMain).MutexRelease;
  end;
end;

procedure TAdvancedAttackFrame.AdvancedAttackTargetAreaLimitScreenDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
begin
  BStrSplit(AdvancedAttackTargetAreaLimitScreen.Items[Index], ' ', A, B);
  BListDrawItem(AdvancedAttackTargetAreaLimitScreen.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TAdvancedAttackFrame.AdvancedAttackTriggerKindClick(Sender: TObject);
var
  ActionSetupPanel: TPanel;
begin
  ActionSetupPanel := nil;
  AdvancedAttackSelfShooterPanel.Visible := False;
  AdvancedAttackTargetShooterPanel.Visible := False;
  AdvancedAttackWaverPanel.Visible := False;
  case AdvancedAttackTriggerKind.ItemIndex of
  0: begin // Single target
      ActionSetupPanel := nil;
    end;
  1: begin // Area Spell
      ActionSetupPanel := AdvancedAttackSelfShooterPanel;
    end;
  2: begin // Area Shooter
      ActionSetupPanel := AdvancedAttackTargetShooterPanel;
    end;
  3: begin // Waver
      ActionSetupPanel := AdvancedAttackWaverPanel;
    end;
  end;
  if ActionSetupPanel <> nil then begin
    ActionSetupPanel.Left := Step3placeholder.Left;
    ActionSetupPanel.Top := Step3placeholder.Top;
    AdvancedAttackSavePanel.Left := ActionSetupPanel.BoundsRect.Left;
    AdvancedAttackSavePanel.Top := ActionSetupPanel.BoundsRect.Bottom + 1;
    ActionSetupPanel.Visible := True;
  end else begin
    AdvancedAttackSavePanel.Left := Step3placeholder.Left;
    AdvancedAttackSavePanel.Top := Step3placeholder.Top;
  end;
end;

function TAdvancedAttackFrame.ContainsCheckedCreature: BBool;
var
  I: BInt32;
begin
  for I := 0 to AdvancedAttackCreatures.Items.Count - 1 do
    if AdvancedAttackCreatures.Checked[I] then
      Exit(True);
  Exit(False);
end;

constructor TAdvancedAttackFrame.Create(AOwner: TComponent);
begin
  inherited;
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TAdvancedAttackFrame.Init;
begin
  WaveFormatDesigner := TAdvancedAttackWaveFormatDesignerFrame(InsertFrame(WaveFormatDesignerPlaceholder,
    TAdvancedAttackWaveFormatDesignerFrame));
  AdvancedAttackTriggerKindClick(AdvancedAttackTriggerKind);
end;

procedure TAdvancedAttackFrame.RefreshTargetCreaturesTimer(Sender: TObject);
begin
  if EngineLoad = elRunning then
    BBot.Creatures.KnownCreatureNames.ForEach(
      procedure(AIt: BVector<BStr>.It)
      begin
        if AdvancedAttackCreatures.Items.IndexOf(AIt^) = -1 then
          AdvancedAttackCreatures.Items.Insert(AdvancedAttackCreatures.Items.Count - 1, AIt^);
      end);
end;

end.
