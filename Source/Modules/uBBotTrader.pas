unit uBBotTrader;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotTrader = class(TBBotAction)
  private
    FTradeChannel: BBool;
    FYell: BBool;
    FSay: BBool;
    FText: BStr;
    NextTrade: BLock;
    NextYell: BLock;
    NextSay: BLock;
  public
    constructor Create;
    destructor Destroy; override;
    property TradeChannel: BBool read FTradeChannel write FTradeChannel;
    property Yell: BBool read FYell write FYell;
    property Say: BBool read FSay write FSay;
    property Text: BStr read FText write FText;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine;

{ TBBotTrader }

constructor TBBotTrader.Create;
begin
  inherited Create('Trader', 1000);
  FTradeChannel := False;
  FYell := False;
  FSay := False;
  FText := '';
  NextTrade := BLock.Create(3 * 60 * 1000, 20);
  NextYell := BLock.Create(2 * 60 * 1000, 20);
  NextSay := BLock.Create(1 * 60 * 1000, 20);
end;

destructor TBBotTrader.Destroy;
begin
  NextTrade.Free;
  NextYell.Free;
  NextSay.Free;
  inherited;
end;

procedure TBBotTrader.Run;
begin
  if not BBot.Exhaust.Defensive then
  begin
    if TradeChannel then
      if not NextTrade.Locked then
      begin
        NextTrade.Lock;
        Me.TradeSay(Text);
        Exit;
      end;
    if Yell then
      if not NextYell.Locked then
      begin
        NextYell.Lock;
        Me.Yell(Text);
        Exit;
      end;
    if Say then
      if not NextSay.Locked then
      begin
        NextSay.Lock;
        Me.Say(Text);
      end;
  end;
end;

end.

