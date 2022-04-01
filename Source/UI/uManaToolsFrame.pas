unit uManaToolsFrame;

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
  Vcl.ExtCtrls,
  uBBotItemSelector;

type
  TManaToolsFrame = class(TFrame)
    Label10: TLabel;
    Label4: TLabel;
    ManaDrinkerLow: TCheckBox;
    ManaDrinkerLowPercent: TCheckBox;
    ManaDrinkerLowFrom: TMemo;
    ManaDrinkerLowTo: TMemo;
    Label5: TLabel;
    Label8: TLabel;
    ManaDrinkerVariation: TMemo;
    Label100: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label38: TLabel;
    ManaTrainerSpell: TEdit;
    ManaTrainerEnable: TCheckBox;
    ManaTrainerPercent: TCheckBox;
    ManaTrainerFrom: TMemo;
    ManaTrainerTo: TMemo;
    Label37: TLabel;
    Label36: TLabel;
    ManaTrainerVariation: TMemo;
    Label110: TLabel;
    Label103: TLabel;
    Label1: TLabel;
    ManaDrinkerLowUse: TComboBox;
    Label2: TLabel;
    ManaDrinkerMid: TCheckBox;
    ManaDrinkerMidPercent: TCheckBox;
    ManaDrinkerMidFrom: TMemo;
    ManaDrinkerMidTo: TMemo;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ManaDrinkerMidUse: TComboBox;
    Bevel1: TBevel;
    Label9: TLabel;
    ManaDrinkerHigh: TCheckBox;
    ManaDrinkerHighPercent: TCheckBox;
    ManaDrinkerHighFrom: TMemo;
    ManaDrinkerHighTo: TMemo;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ManaDrinkerHighUse: TComboBox;
    Bevel2: TBevel;
    ManaDrinkerLowCavebot: TCheckBox;
    ManaDrinkerMidCavebot: TCheckBox;
    ManaDrinkerHighCavebot: TCheckBox;
    procedure ApplySettings(Sender: TObject);
  protected
    FMain: TForm;
    ManaDrinkerLowUseApply: TBBotItemSelectorApply;
    ManaDrinkerMidUseApply: TBBotItemSelectorApply;
    ManaDrinkerHighUseApply: TBBotItemSelectorApply;
    function InitializeManaDrinkerCombo(const ACombo: TComboBox; const AIndex: BInt32): TBBotItemSelectorApply;
    procedure Init;
    procedure ValidateForm;
    procedure AfterSubmit;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetManaDrinker;
    procedure SetManaTrainer;
  end;

implementation

{$R *.dfm}

uses
  BBotEngine,
  uMain,
  uTibiaDeclarations;

procedure TManaToolsFrame.ApplySettings(Sender: TObject);
begin
  ValidateForm;
  SetManaDrinker;
  SetManaTrainer;
end;

constructor TManaToolsFrame.Create(AOwner: TComponent);
begin
  inherited;
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TManaToolsFrame.SetManaDrinker;
begin
  TFMain(FMain).MutexScopped(
    procedure
    begin
      BBot.ManaDrinker.Variation := BStrTo32(ManaDrinkerVariation.Text, 15);

      BBot.ManaDrinker.Low.ManaFrom := BStrTo32(ManaDrinkerLowFrom.Text, 0);
      BBot.ManaDrinker.Low.ManaTo := BStrTo32(ManaDrinkerLowTo.Text, 0);
      BBot.ManaDrinker.Low.ManaPercent := ManaDrinkerLowPercent.Checked;
      BBot.ManaDrinker.Low.ManaUse := ManaDrinkerLowUseApply.ID;
      BBot.ManaDrinker.Low.PauseCavebot := ManaDrinkerLowCavebot.Checked;
      BBot.ManaDrinker.Low.Enabled := ManaDrinkerLow.Checked;

      BBot.ManaDrinker.Mid.ManaFrom := BStrTo32(ManaDrinkerMidFrom.Text, 0);
      BBot.ManaDrinker.Mid.ManaTo := BStrTo32(ManaDrinkerMidTo.Text, 0);
      BBot.ManaDrinker.Mid.ManaPercent := ManaDrinkerMidPercent.Checked;
      BBot.ManaDrinker.Mid.ManaUse := ManaDrinkerMidUseApply.ID;
      BBot.ManaDrinker.Mid.PauseCavebot := ManaDrinkerMidCavebot.Checked;
      BBot.ManaDrinker.Mid.Enabled := ManaDrinkerMid.Checked;

      BBot.ManaDrinker.Heavy.ManaFrom := BStrTo32(ManaDrinkerHighFrom.Text, 0);
      BBot.ManaDrinker.Heavy.ManaTo := BStrTo32(ManaDrinkerHighTo.Text, 0);
      BBot.ManaDrinker.Heavy.ManaPercent := ManaDrinkerHighPercent.Checked;
      BBot.ManaDrinker.Heavy.ManaUse := ManaDrinkerHighUseApply.ID;
      BBot.ManaDrinker.Heavy.PauseCavebot := ManaDrinkerHighCavebot.Checked;
      BBot.ManaDrinker.Heavy.Enabled := ManaDrinkerHigh.Checked;
    end);
  AfterSubmit;
end;

procedure TManaToolsFrame.SetManaTrainer;
begin
  TFMain(FMain).MutexScopped(
    procedure
    begin
      BBot.ManaTrainer.Variation := BStrTo32(ManaTrainerVariation.Text, 15);
      BBot.ManaTrainer.ManaFrom := BStrTo32(ManaTrainerFrom.Text, 0);
      BBot.ManaTrainer.ManaTo := BStrTo32(ManaTrainerTo.Text, 0);
      BBot.ManaTrainer.Percent := ManaTrainerPercent.Checked;
      BBot.ManaTrainer.Spell := ManaTrainerSpell.Text;
      BBot.ManaTrainer.Enabled := ManaTrainerEnable.Checked;
    end);
  AfterSubmit;
end;

procedure TManaToolsFrame.ValidateForm;
begin
  TFMain(FMain).CheckInt(ManaDrinkerLowFrom, ManaDrinkerLow, ManaDrinkerLowPercent.Checked);
  TFMain(FMain).CheckInt(ManaDrinkerLowTo, ManaDrinkerLow, ManaDrinkerLowPercent.Checked);
  TFMain(FMain).ValidateItemCheckbox(ManaDrinkerLowUseApply.ID, ManaDrinkerLow);

  TFMain(FMain).CheckInt(ManaDrinkerMidFrom, ManaDrinkerMid, ManaDrinkerMidPercent.Checked);
  TFMain(FMain).CheckInt(ManaDrinkerMidTo, ManaDrinkerMid, ManaDrinkerMidPercent.Checked);
  TFMain(FMain).ValidateItemCheckbox(ManaDrinkerMidUseApply.ID, ManaDrinkerMid);

  TFMain(FMain).CheckInt(ManaDrinkerHighFrom, ManaDrinkerHigh, ManaDrinkerHighPercent.Checked);
  TFMain(FMain).CheckInt(ManaDrinkerHighTo, ManaDrinkerHigh, ManaDrinkerHighPercent.Checked);
  TFMain(FMain).ValidateItemCheckbox(ManaDrinkerHighUseApply.ID, ManaDrinkerHigh);

  TFMain(FMain).CheckInt(ManaDrinkerVariation,
    'Please insert a value between 1 and 100 in Mana Drinker Variation', True);

  TFMain(FMain).CheckInt(ManaTrainerFrom, ManaTrainerEnable, ManaTrainerPercent.Checked);
  TFMain(FMain).CheckInt(ManaTrainerTo, ManaTrainerEnable, ManaTrainerPercent.Checked);
  TFMain(FMain).CheckInt(ManaTrainerVariation,
    'Please insert a value between 1 and 100 in Mana Trainer Variation', True);

  if ManaTrainerEnable.Checked and (ManaTrainerSpell.Text = '') then
    ManaTrainerEnable.Checked := False;
end;

procedure TManaToolsFrame.AfterSubmit;
begin
  ManaDrinkerLowFrom.Enabled := not ManaDrinkerLow.Checked;
  ManaDrinkerLowUse.Enabled := not ManaDrinkerLow.Checked;
  ManaDrinkerLowTo.Enabled := not ManaDrinkerLow.Checked;
  ManaDrinkerLowPercent.Enabled := not ManaDrinkerLow.Checked;
  ManaDrinkerLowCavebot.Enabled := not ManaDrinkerLow.Checked;

  ManaDrinkerMidFrom.Enabled := not ManaDrinkerMid.Checked;
  ManaDrinkerMidUse.Enabled := not ManaDrinkerMid.Checked;
  ManaDrinkerMidTo.Enabled := not ManaDrinkerMid.Checked;
  ManaDrinkerMidPercent.Enabled := not ManaDrinkerMid.Checked;
  ManaDrinkerMidCavebot.Enabled := not ManaDrinkerMid.Checked;

  ManaDrinkerHighFrom.Enabled := not ManaDrinkerHigh.Checked;
  ManaDrinkerHighUse.Enabled := not ManaDrinkerHigh.Checked;
  ManaDrinkerHighTo.Enabled := not ManaDrinkerHigh.Checked;
  ManaDrinkerHighPercent.Enabled := not ManaDrinkerHigh.Checked;
  ManaDrinkerHighCavebot.Enabled := not ManaDrinkerHigh.Checked;

  ManaTrainerFrom.Enabled := not ManaTrainerEnable.Checked;
  ManaTrainerSpell.Enabled := not ManaTrainerEnable.Checked;
  ManaTrainerTo.Enabled := not ManaTrainerEnable.Checked;
  ManaTrainerPercent.Enabled := not ManaTrainerEnable.Checked;
end;

procedure TManaToolsFrame.Init;
begin
  ManaDrinkerLowUseApply := InitializeManaDrinkerCombo(ManaDrinkerLowUse, 0);
  ManaDrinkerMidUseApply := InitializeManaDrinkerCombo(ManaDrinkerMidUse, 1);
  ManaDrinkerHighUseApply := InitializeManaDrinkerCombo(ManaDrinkerHighUse, 2);
end;

function TManaToolsFrame.InitializeManaDrinkerCombo(const ACombo: TComboBox; const AIndex: BInt32)
  : TBBotItemSelectorApply;
begin
  Result := TFMain(FMain).BBotItemSelector.Apply(ACombo, 'ManaDrinker')
    .add([ItemID_ManaPotion, ItemID_StrongManaPotion, ItemID_GreatManaPotion, ItemID_UltimateManaPotion,
    ItemID_GreatSpiritPotion, ItemID_UltimateSpiritPotion]).selectByIndex(AIndex).addCustomItemSupport;
end;

end.
