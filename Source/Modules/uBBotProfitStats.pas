unit uBBotProfitStats;

interface

uses
  uBTypes,
  uBBotAction,

  uBVector,
  uHUD,
  uBBotStats;

type
  TBBotProfitStats = class(TBBotStatsAction)
  public
    constructor Create(AStats: TBBotStats);
    destructor Destroy; override;
    procedure Reset; override;
    procedure ShowHUD; override;
  end;

implementation

uses
  BBotEngine;

{ TBBotProfitStats }

constructor TBBotProfitStats.Create(AStats: TBBotStats);
begin
  inherited Create('Profit', AStats, bhaLeft, bhaTop);
end;

destructor TBBotProfitStats.Destroy;
begin
  inherited;
end;

procedure TBBotProfitStats.Reset;
begin
end;

procedure TBBotProfitStats.ShowHUD;
var
  HUD: TBBotHUD;
  Waste, Profit, Delta: BInt32;
  PerHourFactor: BDbl;
begin
  HUD := CreateHUD(bhgProfitStats, 'Profit Summary', $0099FF);
  PerHourFactor := Stats.PerHourFactor;
  Waste := BBot.SupliesStats.Waste;
  Profit := BBot.LooterStats.Profit;
  Delta := Profit - Waste;
  HUD.PrintGray(BFormat('Profit: %d gold (%dg/hour)',
    [Profit, BFloor(Profit * PerHourFactor)]));
  HUD.PrintGray(BFormat('Waste: %d gold (%dg/hour)',
    [Waste, BFloor(Waste * PerHourFactor)]));
  HUD.PrintGray(BFormat('%s: %d (%dg/hour)', [BIf(Delta < 0, 'Loss', 'Gain'),
    Delta, BFloor(Delta * PerHourFactor)]));
  if Integer(BBot.TradeWindow.BankBalance) >= 0 then
    HUD.Print(BFormat('Balance: %d gold', [BBot.TradeWindow.BankBalance]
      ), $96F1F0);
  HUD.Line;
  HUD.Free;
end;

end.
