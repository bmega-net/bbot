unit uDebugFrame;

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
  uBTypes,
  BBotEngine;

type
  TDebugFrame = class(TFrame)
    chkDbgAttacker: TCheckBox;
    chkDbgCavebot: TCheckBox;
    chkDbgEvents: TCheckBox;
    chkDbgEventsAll: TCheckBox;
    chkDbgOpenCorpses: TCheckBox;
    chkDbgWalkersState: TCheckBox;
    DebugTradeWindow: TCheckBox;
    LabelGoProfilers: TLabel;
    lstDbgEvents: TListBox;
    DebugPositionStatistics: TCheckBox;
    DebugPositionStatisticsHUD: TCheckBox;
    DebugChannels: TCheckBox;
    LabelGoWalkerDebugger: TLabel;
    DebugWaitLockers: TCheckBox;
    CopyMessages: TLabel;
    LabelGoPacketView: TLabel;
    procedure lstDbgEventsClick(Sender: TObject);
    procedure DebuggerOptions(Sender: TObject);
    procedure LabelGoProfilersClick(Sender: TObject);
    procedure LabelGoWalkerDebuggerClick(Sender: TObject);
    procedure CopyMessagesClick(Sender: TObject);
    procedure LabelGoPacketViewClick(Sender: TObject);
  private
  protected
    FMain: TForm;
    procedure init;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(const AText: BStr);
  end;

implementation

uses
  uMain,
  uEngine;

{$R *.dfm}

procedure TDebugFrame.Add(const AText: BStr);
begin
  lstDbgEvents.Items.Insert(0, AText);
  while lstDbgEvents.Items.Count > 300 do
    lstDbgEvents.Items.Delete(lstDbgEvents.Items.Count - 1);
end;

procedure TDebugFrame.CopyMessagesClick(Sender: TObject);
var
  S: BStr;
  I: BInt32;
begin
  S := '';
  for I := 0 to lstDbgEvents.Items.Count - 1 do
    S := S + lstDbgEvents.Items.Strings[I] + BStrLine;
  TFMain(FMain).SetClipboard(S);
end;

constructor TDebugFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  init;
end;

procedure TDebugFrame.DebuggerOptions(Sender: TObject);
begin
  Engine.Debug.Channels := DebugChannels.Checked;
  BBot.Cavebot.Debug := chkDbgCavebot.Checked;
  BBot.Attacker.Debug := chkDbgAttacker.Checked;
  BBot.OpenCorpses.Debug := chkDbgOpenCorpses.Checked;
  BBot.Events.DebugNormal := chkDbgEvents.Checked;
  BBot.Events.DebugAll := chkDbgEventsAll.Checked;
  BBot.TradeWindow.Debug := DebugTradeWindow.Checked;
  BBot.PositionStatistics.Debug := DebugPositionStatistics.Checked;
  BBot.PositionStatistics.ShowHUD := DebugPositionStatisticsHUD.Checked;
  BBot.Walker.WaitLockDebug := DebugWaitLockers.Checked;
end;

procedure TDebugFrame.init;
begin

end;

procedure TDebugFrame.LabelGoPacketViewClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbPackets);
end;

procedure TDebugFrame.LabelGoProfilersClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbProfilers);
end;

procedure TDebugFrame.LabelGoWalkerDebuggerClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbDebugWalker);
end;

procedure TDebugFrame.lstDbgEventsClick(Sender: TObject);
begin
  CopyMessagesClick(Sender);
end;

end.
