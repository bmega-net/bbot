unit uBBotLooterStats;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  uBVector,
  uHUD,
  uBBotStats;

type
  TBBotLooterStats = class(TBBotStatsAction)
  private
    FProfit: BInt32;
  public
    constructor Create(AStats: TBBotStats);
    destructor Destroy; override;
    procedure Reset; override;
    procedure ShowHUD; override;
    property Profit: BInt32 read FProfit;
  end;

implementation

uses
  uItem;

{ TBBotLooterStats }

constructor TBBotLooterStats.Create(AStats: TBBotStats);
begin
  inherited Create('Looter', AStats, bhaLeft, bhaTop);
  FProfit := 0;
end;

destructor TBBotLooterStats.Destroy;
begin
  inherited;
end;

procedure TBBotLooterStats.Reset;
var
  ID: BInt32;
begin
  FProfit := 0;
  for ID := TibiaMinItems to TibiaMaxItems do
    TibiaItems[ID].Loot.Looted := 0;
end;

procedure TBBotLooterStats.ShowHUD;
var
  HUD: TBBotHUD;
  ID, TotalItems, TotalValue, Looted, Value: BInt32;
  PerHourFactor: BDbl;
begin
  HUD := CreateHUD(bhgLooterStats, 'Looter Statistics', $00FF00);

  TotalItems := 0;
  TotalValue := 0;
  PerHourFactor := Stats.PerHourFactor;

  for ID := TibiaMinItems to TibiaLastItem do
    if TibiaItems[ID].Loot.Looted > 0 then begin
      Looted := TibiaItems[ID].Loot.Looted;
      Value := Looted * TibiaItems[ID].SellValue;
      Inc(TotalItems, Looted);
      Inc(TotalValue, Value);
      HUD.PrintGray(BFormat('%dx %s: %dg (%dg/hour)', [Looted, TibiaItems[ID].Name, Value,
        BFloor(Value * PerHourFactor)]));
    end;
  if TotalItems = 0 then
    HUD.PrintGray('None');

  FProfit := TotalValue;

  HUD.Line;
  HUD.Free;
end;

end.
