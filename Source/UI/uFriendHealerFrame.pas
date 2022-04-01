unit uFriendHealerFrame;

interface

uses
  uBTypes,
  BBotEngine,
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
  TFriendHealerFrame = class(TFrame)
    btnFHadd: TButton;
    chkFHactive: TCheckBox;
    cmbFHFriend: TComboBox;
    cmbFHUse: TComboBox;
    edtFHcast: TEdit;
    Label171: TLabel;
    Label172: TLabel;
    Label173: TLabel;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    Label178: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    lstFH: TListBox;
    numFHhp: TMemo;
    numFHmhp: TMemo;
    numFHmmana: TMemo;
    Label8: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnFHaddClick(Sender: TObject);
    procedure cmbFHFriendDropDown(Sender: TObject);
    procedure lstFHDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstFHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ApplySettings(Sender: TObject);
  protected
    FMain: TForm;
    UseComboSelector: TBBotItemSelectorApply;
    procedure Init;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFriendHealer;
  end;

implementation

{$R *.dfm}

uses
  Declaracoes,
  uMain,
  uTibiaDeclarations,
  uBVector;

procedure TFriendHealerFrame.btnFHaddClick(Sender: TObject);
var
  UseID: BInt32;
  Spell: BStr;
begin
  if (Length(cmbFHFriend.Text) >= 2) and ((BStrTo32(numFHhp.Text, MaxInt) <> MaxInt) or
    (BStrTo32(numFHmhp.Text, MaxInt) <> MaxInt) or (BStrTo32(numFHmmana.Text, MaxInt) <> MaxInt)) then begin
    if UseComboSelector.IsCustom then begin
      UseID := 1;
      Spell := edtFHcast.Text;
    end else begin
      UseID := UseComboSelector.ID;
      Spell := '';
    end;
    lstFH.Items.Add(Format('%s;%d;%d;%d;%s;%d;%s', [ //
      cmbFHFriend.Text, //
      BStrTo32(numFHhp.Text), //
      BStrTo32(numFHmhp.Text), //
      BStrTo32(numFHmmana.Text), //
      UseComboSelector.Text, //
      UseID, //
      Spell]));
  end;
end;

procedure TFriendHealerFrame.ApplySettings(Sender: TObject);
begin
  SetFriendHealer;
end;

procedure TFriendHealerFrame.cmbFHFriendDropDown(Sender: TObject);
begin
  cmbFHFriend.Items.Clear;
  cmbFHFriend.Items.Add('Party');
  cmbFHFriend.Items.Add('Allies');
  BBot.Creatures.KnownCreatureNames.ForEach(
    procedure(AName: BVector<BStr>.It)
    begin
      if cmbFHFriend.Items.IndexOf(AName^) = -1 then
        cmbFHFriend.Items.Add(AName^);
    end);
end;

constructor TFriendHealerFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TFriendHealerFrame.Init;
const
  CastSpell = 'cast spell';
begin
  UseComboSelector := TFMain(FMain).BBotItemSelector //
    .Apply(cmbFHUse, 'FriendHealer') //
    .Add(CastSpell) //
    .Add([ //
    ItemID_SmallHealthPotion, //
    ItemID_HealthPotion, //
    ItemID_StrongHealthPotion, //
    ItemID_GreatHealthPotion, //
    ItemID_ManaPotion, //
    ItemID_StrongManaPotion, //
    ItemID_GreatManaPotion, //
    ItemID_UltimateManaPotion, //
    ItemID_GreatSpiritPotion, //
    ItemID_UltimateSpiritPotion, //
    ItemID_UltimateHealthPotion, //
    ItemID_SupremeHealthPotion, //
    ItemID_IntenseHealingRune, //
    ItemID_UltimateHealingRune //
    ]) //
    .addCustomItemSupport //
    .selectFirst //
    .onSelect(
    procedure(AId: BUInt32; ATitle: BStr)
    begin
      edtFHcast.Enabled := ATitle = CastSpell;
    end);
end;

function StrUChars(const Subject: BStr): BStr;
var
  I: BInt32;
begin
  Result := Subject[1];
  for I := 2 to Length(Subject) do begin
    if Subject[I - 1] = ' ' then begin
      Result := Result + Subject[I];
    end;
  end;
  Exit(BStrUpper(Result));
end;

procedure TFriendHealerFrame.lstFHDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  HPCor: TColor;
  HPBarPos: BInt32;
  HP: BInt32;
  Ret: BStrArray;
begin
  if odSelected in State then begin
    lstFH.Canvas.Brush.Color := clHighlight;
    lstFH.Canvas.Font.Color := clHighlightText;
  end else begin
    lstFH.Canvas.Brush.Color := lstFH.Color;
    lstFH.Canvas.Font.Color := lstFH.Font.Color;
  end;
  if ((Control as TListBox).Count < 1) or (Index < 0) then
    Exit;
  BStrSplit(Ret, ';', lstFH.Items.Strings[Index]);
  with lstFH.Canvas do begin
    FillRect(Rect);
    if BStrIsNumber(Ret[1]) then begin
      HP := StrToInt(Ret[1]);

      HPCor := HPColor(HP);

      Font.Color := HPCor;

      // Display Player Name:
      TextOut(((Rect.Right - Rect.Left) div 2) - (TextWidth(Ret[0]) div 2), Rect.Top + 1, Ret[0]);

      // Display HP% / Use
      Font.Style := [fsBold];
      TextOut(Rect.Left, Rect.Top + 1, '  ' + Ret[1] + '%');
      TextOut(Rect.Right - TextWidth(StrUChars(Ret[4])) - 5, Rect.Top + 1, StrUChars(Ret[4]));

      // Display HP Bar
      // Background
      Brush.Color := clBlack;
      Rect.Top := Rect.Top + 1 + TextHeight('A');
      Rect.Left := 1 + 25;
      Rect.Right := Rect.Right - 25;
      Rect.Bottom := Rect.Bottom - 1;
      FillRect(Rect);
      // HP Bar
      HPBarPos := 100 - HP;
      HPBarPos := (Rect.Right - Rect.Left) * (HPBarPos div 100);
      Rect.Right := Rect.Right - HPBarPos;
      Brush.Color := HPCor;
      InflateRect(Rect, -1, -1);
      FillRect(Rect);
    end;
  end;
end;

procedure TFriendHealerFrame.lstFHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
end;

procedure TFriendHealerFrame.SetFriendHealer;
var
  I: BInt32;
begin
  if TFMain(FMain).MutexAcquire then begin
    BBot.FriendHealer.ClearFriends;
    if chkFHactive.Checked then
      for I := 0 to lstFH.Count - 1 do
        BBot.FriendHealer.AddFriend(lstFH.Items.Strings[I]);
    BBot.FriendHealer.Enabled := chkFHactive.Checked;
    TFMain(FMain).MutexRelease;
    lstFH.Enabled := not BBot.FriendHealer.Enabled;
    btnFHadd.Enabled := not BBot.FriendHealer.Enabled;
  end;
end;

end.
