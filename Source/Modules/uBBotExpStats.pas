unit uBBotExpStats;

interface

uses
  uBTypes,
  uBBotAction,

  uBVector,
  uHUD,
  uBBotStats;

type
  TBBotExpStats = class(TBBotStatsAction)
  protected
    ExpValue: BInt64;
    ExpPercent: BInt32;
  public
    constructor Create(AStats: TBBotStats);
    destructor Destroy; override;
    procedure Reset; override;
    procedure ShowHUD; override;
    function ExpPerHour: BInt32;
  end;

implementation

uses
  BBotEngine,
  Declaracoes;
{ TBBotExpStats }

constructor TBBotExpStats.Create(AStats: TBBotStats);
begin
  inherited Create('Exp', AStats, bhaRight, bhaTop);
  ExpValue := 0;
  ExpPercent := 0;
end;

destructor TBBotExpStats.Destroy;
begin
  inherited;
end;

function TBBotExpStats.ExpPerHour: BInt32;
begin
  Result := BCeil((Me.Experience - ExpValue) * Stats.PerHourFactor);
end;

procedure TBBotExpStats.Reset;
begin
  ExpValue := Me.Experience;
  ExpPercent := (Me.Level * 100) + Me.LevelPercent;;
end;

procedure TBBotExpStats.ShowHUD;
const
  MaxTimeToGo: BInt32 = 864001;
var
  HUD: TBBotHUD;
  ToNextLevel: Int64;
  ToNextLevel_Perc: BInt32;
  Gained: Int64;
  Gained_Perc: BInt32;
  Hour: Int64;
  Hour_Perc: BDbl;
  TimeToGo: BUInt32;
  PerHourFactor: BDbl;
begin
  HUD := CreateHUD(bhgExpStats, 'EXP Statistics', $00FFFF);
  if (ExpValue > Me.Experience) or (ExpValue = 0) then begin
    Reset;
    HUD.PrintGray('None');
  end else begin
    ToNextLevel := Tibia.CalcExp(Me.Level + 1) - Me.Experience;
    ToNextLevel_Perc := 100 - Me.LevelPercent;
    Gained := Me.Experience - ExpValue;
    Gained_Perc := ((Me.Level * 100) + Me.LevelPercent) - ExpPercent;
    if Gained < 0 then begin
      Hour := 0;
      Hour_Perc := 0;
      TimeToGo := MaxTimeToGo;
    end else begin
      PerHourFactor := Stats.PerHourFactor;
      Hour := BCeil(Gained * PerHourFactor);
      Hour_Perc := Gained_Perc * PerHourFactor;
      if Hour <> 0 then
        TimeToGo := BCeil(ToNextLevel / (Gained / Stats.StatsTime))
      else
        TimeToGo := MaxTimeToGo;
    end;
    HUD.PrintGray(BFormat('To Next Level: %d = %d%%', [ToNextLevel, ToNextLevel_Perc]));
    HUD.PrintGray(BFormat('Gained: %d (%d%%)', [Gained, Gained_Perc]));
    HUD.PrintGray(BFormat('Hour: %d (%f%%)', [Hour, Hour_Perc]));
    HUD.PrintGray(BFormat('Time to Next Level: %s', [SecToTime(TimeToGo)]));
    HUD.PrintGray(BFormat('Hunting Time: %s', [SecToTime(Stats.StatsTime)]));
  end;
  HUD.Line;
  HUD.Free;
end;

end.
