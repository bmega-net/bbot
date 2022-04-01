unit uHealerFrame;

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
  Vcl.ComCtrls,
  uBBotItemSelector;

type
  THealerFrame = class(TFrame)
    chkHealerItemHigh: TCheckBox;
    chkHealerItemHighPercent: TCheckBox;
    chkHealerItemLow: TCheckBox;
    chkHealerItemLowPercent: TCheckBox;
    chkHealerSpellHigh: TCheckBox;
    chkHealerSpellHighPercent: TCheckBox;
    chkHealerSpellLow: TCheckBox;
    chkHealerSpellLowPercent: TCheckBox;
    chkHealerSpellMid: TCheckBox;
    chkHealerSpellmidPercent: TCheckBox;
    edtHealerSpellHighSpell: TEdit;
    edtHealerSpellLowSpell: TEdit;
    edtHealerSpellMidSpell: TEdit;
    Label101: TLabel;
    Label102: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label30: TLabel;
    Label6: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    numHealerItemHighHP: TMemo;
    numHealerItemLowHP: TMemo;
    numHealerItemsEx: TMemo;
    numHealerSpellHighHP: TMemo;
    numHealerSpellHighMana: TMemo;
    numHealerSpellLowHP: TMemo;
    numHealerSpellLowMana: TMemo;
    numHealerSpellMidHP: TMemo;
    numHealerSpellMidMana: TMemo;
    numHealerSpellsEx: TMemo;
    numHealerVariation: TMemo;
    rbHpi: TRadioButton;
    rbHps: TRadioButton;
    cmbHealerItemLow: TComboBox;
    cmbHealerItemHigh: TComboBox;
    chkHealerItemMid: TCheckBox;
    chkHealerItemMidPercent: TCheckBox;
    numHealerItemMidHP: TMemo;
    cmbHealerItemMid: TComboBox;
    procedure ApplySettings(Sender: TObject);
  private
    FMain: TForm;

    LowItemHealerCombo: TBBotItemSelectorApply;
    MidItemHealerCombo: TBBotItemSelectorApply;
    HighItemHealerCombo: TBBotItemSelectorApply;

    procedure SetHealerConfig;
    procedure SetHealerItem;
    procedure SetHealerSpell;
    procedure ValidateForm;
    procedure AfterSubmit;

    procedure Init;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetHealer;
  end;

implementation

{$R *.dfm}

uses
  BBotEngine,
  uBBotHealer,
  uMain,
  uTibiaDeclarations;

procedure THealerFrame.AfterSubmit;
begin
  chkHealerSpellLowPercent.Enabled := not BBot.Healers.SpellLow.Enabled;
  numHealerSpellLowHP.Enabled := not BBot.Healers.SpellLow.Enabled;
  numHealerSpellLowMana.Enabled := not BBot.Healers.SpellLow.Enabled;
  edtHealerSpellLowSpell.Enabled := not BBot.Healers.SpellLow.Enabled;

  chkHealerSpellmidPercent.Enabled := not BBot.Healers.SpellMid.Enabled;
  numHealerSpellMidHP.Enabled := not BBot.Healers.SpellMid.Enabled;
  numHealerSpellMidMana.Enabled := not BBot.Healers.SpellMid.Enabled;
  edtHealerSpellMidSpell.Enabled := not BBot.Healers.SpellMid.Enabled;

  chkHealerSpellHighPercent.Enabled := not BBot.Healers.SpellHigh.Enabled;
  numHealerSpellHighHP.Enabled := not BBot.Healers.SpellHigh.Enabled;
  numHealerSpellHighMana.Enabled := not BBot.Healers.SpellHigh.Enabled;
  edtHealerSpellHighSpell.Enabled := not BBot.Healers.SpellHigh.Enabled;

  chkHealerItemLowPercent.Enabled := not BBot.Healers.ItemLow.Enabled;
  numHealerItemLowHP.Enabled := not BBot.Healers.ItemLow.Enabled;
  cmbHealerItemLow.Enabled := not BBot.Healers.ItemLow.Enabled;

  chkHealerItemMidPercent.Enabled := not BBot.Healers.ItemMid.Enabled;
  numHealerItemMidHP.Enabled := not BBot.Healers.ItemMid.Enabled;
  cmbHealerItemMid.Enabled := not BBot.Healers.ItemMid.Enabled;

  chkHealerItemHighPercent.Enabled := not BBot.Healers.ItemHigh.Enabled;
  numHealerItemHighHP.Enabled := not BBot.Healers.ItemHigh.Enabled;
  cmbHealerItemHigh.Enabled := not BBot.Healers.ItemHigh.Enabled;
end;

procedure THealerFrame.ApplySettings(Sender: TObject);
begin
  SetHealer;
end;

constructor THealerFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure THealerFrame.SetHealerSpell;
  procedure ApplySpellHealer(const AEnable: TCheckBox; const APercent: TCheckBox; const ASpell: TEdit;
    const AMana: TMemo; const AHealth: TMemo; const AHealer: TBBotHealerSpell);
  begin
    if AEnable.Checked and (ASpell.Text = '') then
      AEnable.Checked := False;
    AHealer.Percent := APercent.Checked;
    AHealer.HealHealth := BStrTo32(AHealth.Text, 0);
    AHealer.Spell := ASpell.Text;
    AHealer.Mana := BStrTo32(AMana.Text, 0);
    AHealer.Enabled := AEnable.Checked;
  end;

begin
  ApplySpellHealer( //
    chkHealerSpellLow, //
    chkHealerSpellLowPercent, //
    edtHealerSpellLowSpell, //
    numHealerSpellLowMana, //
    numHealerSpellLowHP, //
    BBot.Healers.SpellLow);
  ApplySpellHealer( //
    chkHealerSpellMid, //
    chkHealerSpellmidPercent, //
    edtHealerSpellMidSpell, //
    numHealerSpellMidMana, //
    numHealerSpellMidHP, //
    BBot.Healers.SpellMid);
  ApplySpellHealer( //
    chkHealerSpellHigh, //
    chkHealerSpellHighPercent, //
    edtHealerSpellHighSpell, //
    numHealerSpellHighMana, //
    numHealerSpellHighHP, //
    BBot.Healers.SpellHigh);
end;

procedure THealerFrame.SetHealerItem;
  procedure ApplyItemHealer(const AEnable: TCheckBox; const APercent: TCheckBox; const AUse: TBBotItemSelectorApply;
    const AHealth: TMemo; const AHealer: TBBotHealerItem);
  begin
    AHealer.Percent := APercent.Checked;
    AHealer.HealHealth := BStrTo32(AHealth.Text, 0);
    AHealer.Item := AUse.ID;
    TFMain(FMain).ValidateItemCheckbox(AUse.ID, AEnable);
    AHealer.Enabled := AEnable.Checked;
  end;

begin
  ApplyItemHealer( //
    chkHealerItemLow, //
    chkHealerItemLowPercent, //
    LowItemHealerCombo, //
    numHealerItemLowHP, //
    BBot.Healers.ItemLow //
    );
  ApplyItemHealer( //
    chkHealerItemMid, //
    chkHealerItemMidPercent, //
    MidItemHealerCombo, //
    numHealerItemMidHP, //
    BBot.Healers.ItemMid //
    );
  ApplyItemHealer( //
    chkHealerItemHigh, //
    chkHealerItemHighPercent, //
    HighItemHealerCombo, //
    numHealerItemHighHP, //
    BBot.Healers.ItemHigh //
    );
end;

procedure THealerFrame.Init;
  function InitHealerCombo(const ACombo: TComboBox; const AIndex: BInt32): TBBotItemSelectorApply;
  begin
    Result := TFMain(FMain). //
      BBotItemSelector //
      .Apply(ACombo, 'Healer') //
      .add([ //
      ItemID_SmallHealthPotion, //
      ItemID_HealthPotion, //
      ItemID_StrongHealthPotion, //
      ItemID_GreatHealthPotion, //
      ItemID_GreatSpiritPotion, //
      ItemID_UltimateSpiritPotion, //
      ItemID_UltimateHealthPotion, //
      ItemID_SupremeHealthPotion, //
      ItemID_IntenseHealingRune, //
      ItemID_UltimateHealingRune //
      ]) //
      .addCustomItemSupport //
      .selectByIndex(AIndex); //
  end;

begin
  LowItemHealerCombo := InitHealerCombo(cmbHealerItemLow, 1);
  MidItemHealerCombo := InitHealerCombo(cmbHealerItemMid, 2);
  HighItemHealerCombo := InitHealerCombo(cmbHealerItemHigh, 3);
end;

procedure THealerFrame.SetHealer;
begin
  ValidateForm;
  TFMain(FMain).MutexScopped(
    procedure
    begin
      SetHealerItem;
      SetHealerSpell;
      SetHealerConfig;
    end);
  AfterSubmit;
end;

procedure THealerFrame.SetHealerConfig;
begin
  if rbHpi.Checked then // Priority: Item
    BBot.Healers.HealerPriority := hutItem
  else // Priority: Spell
    BBot.Healers.HealerPriority := hutSpell;
  BBot.Healers.DelayBetweenItems := BStrTo32(numHealerItemsEx.Text, 300);
  BBot.Healers.DelayBetweenSpells := BStrTo32(numHealerSpellsEx.Text, 300);
  BBot.Healers.Variation := BStrTo32(numHealerVariation.Text, 15);
end;

procedure THealerFrame.ValidateForm;
begin
  TFMain(FMain).CheckInt(numHealerSpellLowHP, chkHealerSpellLow, chkHealerSpellLowPercent.Checked);
  TFMain(FMain).CheckInt(numHealerSpellLowMana, chkHealerSpellLow, False);

  TFMain(FMain).CheckInt(numHealerSpellMidHP, chkHealerSpellMid, chkHealerSpellmidPercent.Checked);
  TFMain(FMain).CheckInt(numHealerSpellMidMana, chkHealerSpellMid, False);

  TFMain(FMain).CheckInt(numHealerSpellHighHP, chkHealerSpellHigh, chkHealerSpellHighPercent.Checked);
  TFMain(FMain).CheckInt(numHealerSpellHighMana, chkHealerSpellHigh, False);

  TFMain(FMain).CheckInt(numHealerItemLowHP, chkHealerItemLow, chkHealerItemLowPercent.Checked);
  TFMain(FMain).CheckInt(numHealerItemMidHP, chkHealerItemMid, chkHealerItemMidPercent.Checked);
  TFMain(FMain).CheckInt(numHealerItemHighHP, chkHealerItemHigh, chkHealerItemHighPercent.Checked);

  TFMain(FMain).CheckInt(numHealerItemsEx, 'Please insert a valid value in Healer Items delay', False);
  TFMain(FMain).CheckInt(numHealerSpellsEx, 'Please insert a valid value in Healer Spells delay', False);
end;

end.
