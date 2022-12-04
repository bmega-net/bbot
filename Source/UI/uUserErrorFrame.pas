unit uUserErrorFrame;

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
  ExtCtrls,
  uBTypes,
  uUserError;

type
  TUserErrorFrame = class(TFrame)
    Error: TMemo;
    Label1: TLabel;
    RecommendedActionsLabel: TLabel;
    editCavebot: TLabel;
    editAdvancedAttack: TLabel;
    editReconnectManager: TLabel;
    editMacros: TLabel;
    editEnchanter: TLabel;
    pauseBot: TLabel;
    procedure LinkLeave(Sender: TObject);
    procedure LinkEnter(Sender: TObject);
    procedure editCavebotClick(Sender: TObject);
    procedure editAdvancedAttackClick(Sender: TObject);
    procedure editReconnectManagerClick(Sender: TObject);
    procedure editMacrosClick(Sender: TObject);
    procedure editEnchanterClick(Sender: TObject);
    procedure pauseBotClick(Sender: TObject);
  protected
    FMain: TForm;
    procedure Init;
    procedure ManageDisables(AUserError: BUserError);
    procedure ShowRecommendedActions(AUserError: BUserError);
    procedure ShowUserError;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Open(AUserError: BUserError);
  end;

implementation

{$R *.dfm}

uses
  uMain,
  Declaracoes,
  BBotEngine,
  uBBotMenu,
  uBBotAction,
  uBVector;

{ TUserErrorFrame }

constructor TUserErrorFrame.Create(AOwner: TComponent);
begin
  inherited;
  FMain := TForm(TWinControl(AOwner).Parent);
  Init;
end;

procedure TUserErrorFrame.editAdvancedAttackClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbAdvancedAttack);
end;

procedure TUserErrorFrame.editCavebotClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbCavebot);
end;

procedure TUserErrorFrame.editEnchanterClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbEnchanter);
end;

procedure TUserErrorFrame.editMacrosClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbMacros);
end;

procedure TUserErrorFrame.editReconnectManagerClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbBotManager);
end;

procedure TUserErrorFrame.Init;
begin

end;

procedure TUserErrorFrame.LinkEnter(Sender: TObject);
begin
  OnLinkLabelEnter(Sender);
end;

procedure TUserErrorFrame.LinkLeave(Sender: TObject);
begin
  OnLinkLabelLeave(Sender);
end;

procedure TUserErrorFrame.ManageDisables(AUserError: BUserError);
begin
  if AUserError.DisableCavebot then
    TFMain(FMain).CavebotFrame.chkCBa.Checked := False;
  if AUserError.DisableMacros then
    TFMain(FMain).MacrosFrame.chkMacroAutos.Checked := False;
  if AUserError.DisableEnchanter then
    TFMain(FMain).chkEnchanter.Checked := False;
  if AUserError.DisableReconnectManager then
  begin
    TFMain(FMain).chkReconnect.Checked := False;
    TFMain(FMain).ReconnectManagerFrame.BotManagerEnabled.Checked := False;
  end;
end;

procedure TUserErrorFrame.Open(AUserError: BUserError);
begin
  Error.Text := AUserError.Formatted;
  ManageDisables(AUserError);
  ShowRecommendedActions(AUserError);
  ShowUserError;
end;

procedure TUserErrorFrame.pauseBotClick(Sender: TObject);
begin
  if TFMain(FMain).MutexAcquire then
  begin
    BBot.Menu.PauseLevel := bplAll;
    TFMain(FMain).MutexRelease;
  end;
end;

procedure TUserErrorFrame.ShowRecommendedActions(AUserError: BUserError);
var
  Actions: BVector<TLabel>;
  Top, Incrm: BInt32;
begin
  editCavebot.Visible := False;
  editAdvancedAttack.Visible := False;
  editReconnectManager.Visible := False;
  editMacros.Visible := False;
  editEnchanter.Visible := False;
  pauseBot.Visible := False;

  Actions := BVector<TLabel>.Create(nil);
  if uraEditCavebot in AUserError.Actions then
    Actions.Add(editCavebot);
  if uraEditAdvancedAttack in AUserError.Actions then
    Actions.Add(editAdvancedAttack);
  if uraEditReconnectManager in AUserError.Actions then
    Actions.Add(editReconnectManager);
  if uraEditMacro in AUserError.Actions then
    Actions.Add(editMacros);
  if uraEditEnchanter in AUserError.Actions then
    Actions.Add(editEnchanter);
  Actions.Add(pauseBot);

  Top := RecommendedActionsLabel.Top;
  Incrm := RecommendedActionsLabel.Height + 4;
  Inc(Top, Incrm);
  Actions.ForEach(
    procedure(AIt: BVector<TLabel>.It)
    begin
      AIt^.Top := Top;
      AIt^.Visible := True;
      Inc(Top, Incrm);
    end);
  Actions.Free;
end;

procedure TUserErrorFrame.ShowUserError;
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbUserError);
end;

end.
