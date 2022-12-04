unit uLooterFrame;

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
  uFLootItems,
  uBTypes,

  Vcl.ExtCtrls;

type
  TLooterFrame = class(TFrame)
    IgnoreCorpsesGroup: TPanel;
    OpenCorpsesIgnoreCreatures: TListBox;
    Label1: TLabel;
    OpenCorpsesIgnoreAdd: TEdit;
    OpenCorpsesIgnoreAddButton: TButton;
    SkinnerGroup: TPanel;
    SkinnerCombo: TComboBox;
    SkinnerAdd: TButton;
    SkinnerList: TListBox;
    Label6: TLabel;
    GoBackSkinner: TButton;
    LooterGroup: TPanel;
    Label4: TLabel;
    chkLOpen: TCheckBox;
    SkinCorpses: TCheckBox;
    GoIgnoreCorpses: TLabel;
    GoSkinner: TLabel;
    Label2: TLabel;
    cmbLooterPrio: TComboBox;
    chkLLooter: TCheckBox;
    chkLEat: TCheckBox;
    chkRustyRemover: TCheckBox;
    btnOpenLootlist: TButton;
    edtLooterRare: TMemo;
    chkLooterRare: TCheckBox;
    GoBackIgnoreCorpses: TButton;
    procedure ApplySettings(Sender: TObject);
    procedure btnOpenLootlistClick(Sender: TObject);
    procedure OpenCorpsesIgnoreCreaturesDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OpenCorpsesIgnoreCreaturesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OpenCorpsesIgnoreAddButtonClick(Sender: TObject);
    procedure SkinnerListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SkinnerListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SkinnerAddClick(Sender: TObject);
    procedure SkinnerComboDropDown(Sender: TObject);
    procedure SkinnerComboDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure GoIgnoreCorpsesClick(Sender: TObject);
    procedure GoBackSkinnerClick(Sender: TObject);
    procedure GoBackIgnoreCorpsesClick(Sender: TObject);
    procedure GoSkinnerClick(Sender: TObject);
  protected
    FMain: TForm;
    procedure Init;
    procedure ShowGroup(const AGroup: TPanel);
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetLooter;
  end;

implementation

{$R *.dfm}

uses
  BBotEngine,
  uBBotWalkState,
  Declaracoes;

const
  AddSkinnableCreature = 'Add skinnable creature@';

procedure TLooterFrame.ApplySettings(Sender: TObject);
begin
  SetLooter;
end;

procedure TLooterFrame.btnOpenLootlistClick(Sender: TObject);
begin
  FLootItems.Show;
end;

constructor TLooterFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TLooterFrame.GoBackIgnoreCorpsesClick(Sender: TObject);
begin
  ShowGroup(LooterGroup);
end;

procedure TLooterFrame.GoBackSkinnerClick(Sender: TObject);
begin
  ShowGroup(LooterGroup);
end;

procedure TLooterFrame.GoIgnoreCorpsesClick(Sender: TObject);
begin
  ShowGroup(IgnoreCorpsesGroup);
end;

procedure TLooterFrame.GoSkinnerClick(Sender: TObject);
begin
  ShowGroup(SkinnerGroup);
end;

procedure TLooterFrame.Init;
begin
  SkinnerCombo.Text := AddSkinnableCreature;
  Self.Width := LooterGroup.BoundsRect.Right;
  Self.Height := LooterGroup.BoundsRect.Bottom;
end;

procedure TLooterFrame.SkinnerAddClick(Sender: TObject);
begin
  if SkinnerCombo.Text <> AddSkinnableCreature then
  begin
    SkinnerList.AddItem(SkinnerCombo.Text, nil);
    SetLooter;
  end;
end;

procedure TLooterFrame.SkinnerComboDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
begin
  BStrSplit(SkinnerCombo.Items.Strings[Index], '@', A, B);
  BListDrawItem(SkinnerCombo.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TLooterFrame.SkinnerComboDropDown(Sender: TObject);
var
  Skinnables: BStrArray;
  I: BInt32;
begin
  SkinnerCombo.Items.BeginUpdate;
  SkinnerCombo.Items.Clear;
  Skinnables := BBot.Skinner.AvailableSkinnables;
  for I := 0 to High(Skinnables) do
    SkinnerCombo.Items.Add(Skinnables[I]);
  SkinnerCombo.Items.EndUpdate;
end;

procedure TLooterFrame.SkinnerListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
begin
  BStrSplit(SkinnerList.Items.Strings[Index], '@', A, B);
  BListDrawItem(SkinnerList.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TLooterFrame.SkinnerListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
  SetLooter;
end;

procedure TLooterFrame.OpenCorpsesIgnoreAddButtonClick(Sender: TObject);
begin
  OpenCorpsesIgnoreCreatures.AddItem(OpenCorpsesIgnoreAdd.Text, nil);
  SetLooter;
end;

procedure TLooterFrame.OpenCorpsesIgnoreCreaturesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  BListDrawItem(OpenCorpsesIgnoreCreatures.Canvas, Index, odSelected in State,
    Rect, OpenCorpsesIgnoreCreatures.Items.Strings[Index]);
end;

procedure TLooterFrame.OpenCorpsesIgnoreCreaturesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
  SetLooter;
end;

procedure TLooterFrame.SetLooter;
var
  I: BInt32;
begin
  BBot.Looter.Enabled := chkLLooter.Checked;
  BBot.Looter.RustRemover := chkRustyRemover.Checked;
  BBot.Looter.EatFromCorpse := chkLEat.Checked;

  BBot.RareLootAlarm.Words := edtLooterRare.Text;
  BBot.RareLootAlarm.Enabled := chkLooterRare.Checked;

  BBot.OpenCorpses.Enabled := chkLOpen.Checked;
  BBot.WalkState.Priority := TBBotWalkStatePriority(cmbLooterPrio.ItemIndex);

  edtLooterRare.Enabled := not BBot.RareLootAlarm.Enabled;

  BBot.OpenCorpses.IgnoreCreatures.Clear;
  for I := 0 to OpenCorpsesIgnoreCreatures.Items.Count - 1 do
    BBot.OpenCorpses.IgnoreCreatures.Add(OpenCorpsesIgnoreCreatures.Items[I]);

  BBot.Skinner.Enabled := SkinCorpses.Checked;
  BBot.Skinner.SetSkinables(ListToBStrArray(SkinnerList.Items));
end;

procedure TLooterFrame.ShowGroup(const AGroup: TPanel);
begin
  LooterGroup.Visible := False;
  SkinnerGroup.Visible := False;
  IgnoreCorpsesGroup.Visible := False;
  AGroup.Left := LooterGroup.Left;
  AGroup.Top := LooterGroup.Top;
  AGroup.Visible := True;
end;

end.
