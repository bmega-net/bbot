unit uSpecialSQMsFrame;

interface

uses
  uBTypes,
  BBotEngine,
  Declaracoes,
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
  TSpecialSQMsFrame = class(TFrame)
    lstSpecialSQMs: TListBox;
    Label160: TLabel;
    Label91: TLabel;
    SpecialSQMsShow: TCheckBox;
    Label49: TLabel;
    Label161: TLabel;
    SpecialSQMsKind: TComboBox;
    SpecialSQMsRange: TComboBox;
    Label162: TLabel;
    SpecialSQMsAdd: TButton;
    SpecialSQMsEditorHUD: TCheckBox;
    procedure lstSpecialSQMsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure SpecialSQMsAddClick(Sender: TObject);
    procedure lstSpecialSQMsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ApplySettings(Sender: TObject);
  private
  public
    procedure AddSpecialSQM(const AType, ARange: BInt32; const APos: BPos);
    procedure RemoveSpecialSQM(const APosition: BPos);
    procedure SetSpecialSQMs;
  end;

implementation

{$R *.dfm}
{ TSpecialSQMsFrame }

procedure TSpecialSQMsFrame.AddSpecialSQM(const AType, ARange: BInt32; const APos: BPos);
begin
  lstSpecialSQMs.AddItem(BFormat('%d:%d@%s', [AType, ARange, BStr(APos)]), nil);
  SetSpecialSQMs;
end;

procedure TSpecialSQMsFrame.ApplySettings(Sender: TObject);
begin
  SetSpecialSQMs;
end;

procedure TSpecialSQMsFrame.lstSpecialSQMsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  A, B, T: BStr;
begin
  T := lstSpecialSQMs.Items[Index];
  case T[1] of
  '0': A := 'Avoid';
  '1': A := 'Like';
  '2': A := 'Attacking Avoid';
  '3': A := 'Attacking Like';
  '4': A := 'Block';
  '5': A := 'Area Spells Avoid';
  end;
  A := BFormat('%s %dx%1:d', [A, BStrTo32(T[3], 0) * 2 + 1]);
  B := BStrRight(T, '@');
  BListDrawItem(lstSpecialSQMs.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TSpecialSQMsFrame.lstSpecialSQMsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssShift in Shift then
    if Key = VK_DELETE then
      if lstSpecialSQMs.ItemIndex <> -1 then
        lstSpecialSQMs.Items.Delete(lstSpecialSQMs.ItemIndex);
  SetSpecialSQMs;
end;

procedure TSpecialSQMsFrame.RemoveSpecialSQM(const APosition: BPos);
var
  RemoveSuffix: BStr;
  I: BInt32;
begin
  RemoveSuffix := '@' + BStr(APosition);
  for I := lstSpecialSQMs.Items.Count - 1 downto 0 do
    if BStrEndSensitive(lstSpecialSQMs.Items[I], RemoveSuffix) then begin
      lstSpecialSQMs.Items.Delete(I);
      Exit;
    end;
end;

procedure TSpecialSQMsFrame.SetSpecialSQMs;
var
  I: BInt32;
begin
  BBot.SpecialSQMs.ShowOnGameScreen := SpecialSQMsShow.Checked;
  BBot.SpecialSQMs.ShowEditorOnGameScreen := SpecialSQMsEditorHUD.Checked;
  BBot.SpecialSQMs.Clear;
  for I := 0 to lstSpecialSQMs.Items.Count - 1 do
    BBot.SpecialSQMs.Add(lstSpecialSQMs.Items.Strings[I]);
end;

procedure TSpecialSQMsFrame.SpecialSQMsAddClick(Sender: TObject);
begin
  AddSpecialSQM(SpecialSQMsKind.ItemIndex, SpecialSQMsRange.ItemIndex, Me.Position);
end;

end.
