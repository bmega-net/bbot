unit uBBotKillStats;

interface

uses
  uBTypes,
  uBBotAction,

  uBVector,
  uHUD,
  uBBotStats;

type
  TBBotKillStats = class(TBBotStatsAction)
  private type
    TKillStatsData = record
      Creature: BStr;
      Count: BInt32;
      Task: BInt32;
    end;
  protected
    Data: BVector<TKillStatsData>;
  public
    constructor Create(AStats: TBBotStats);
    destructor Destroy; override;
    procedure Reset; override;
    procedure ShowHUD; override;

    procedure Add(AMonster: BStr);
    procedure ResetTask;

    function TaskKills(AMonster: BStr): BInt32;
    function Kills(AMonster: BStr): BInt32;
  end;

implementation

{ TBBotKillStats }

procedure TBBotKillStats.Add(AMonster: BStr);
var
  Monster: BVector<TKillStatsData>.It;
begin
  Monster := Data.Find('KillStats add for [' + AMonster + ']',
    function(Iter: BVector<TKillStatsData>.It): BBool
    begin
      Result := BStrEqual(Iter^.Creature, AMonster);
    end);
  if Monster = nil then
  begin
    Monster := Data.Add;
    Monster^.Creature := AMonster;
    Monster^.Count := 0;
    Monster^.Task := 0;
  end;
  Inc(Monster^.Count);
  Inc(Monster^.Task);
end;

constructor TBBotKillStats.Create(AStats: TBBotStats);
begin
  inherited Create('Kills', AStats, bhaLeft, bhaTop);
  Data := BVector<TKillStatsData>.Create;
  Stats := AStats;
end;

destructor TBBotKillStats.Destroy;
begin
  Data.Free;
  inherited;
end;

function TBBotKillStats.Kills(AMonster: BStr): BInt32;
var
  Monster: BVector<TKillStatsData>.It;
begin
  Monster := Data.Find('KillStats query for [' + AMonster + ']',
    function(Iter: BVector<TKillStatsData>.It): BBool
    begin
      Result := BStrEqual(Iter^.Creature, AMonster);
    end);
  Result := -1;
  if Monster <> nil then
    Exit(Monster^.Count);
end;

procedure TBBotKillStats.Reset;
begin
  Data.Clear;
end;

procedure TBBotKillStats.ResetTask;
begin
  Data.ForEach(
    procedure(Iter: BVector<TKillStatsData>.It)
    begin
      Iter^.Task := 0;
    end);
end;

procedure TBBotKillStats.ShowHUD;
var
  HUD: TBBotHUD;
  PerHourFactor: BDbl;
  TotalKills, TotalTask: BInt32;
begin
  HUD := CreateHUD(bhgKillStats, 'Kill Statistics', $0000FF);
  if Data.Count > 0 then
  begin
    PerHourFactor := Stats.PerHourFactor;
    TotalKills := 0;
    TotalTask := 0;
    Data.ForEach(
      procedure(Iter: BVector<TKillStatsData>.It)
      begin
        if Iter^.Task = Iter^.Count then
          HUD.PrintGray(BFormat('%s: %d (%f/h)', [Iter^.Creature, Iter^.Count,
            Iter^.Count * PerHourFactor]))
        else
          HUD.PrintGray(BFormat('%s: %d %d (%f/h %f/h)', [Iter^.Creature,
            Iter^.Count, Iter^.Task, Iter^.Count * PerHourFactor,
            Iter^.Task * PerHourFactor]));
        Inc(TotalKills, Iter^.Count);
        Inc(TotalTask, Iter^.Task);
      end);
    if TotalKills = TotalTask then
      HUD.PrintGray(BFormat('Total: %d', [TotalKills]))
    else
      HUD.PrintGray(BFormat('Total: %d/%d', [TotalKills, TotalTask]));
  end
  else
    HUD.PrintGray('None');
  HUD.Line;
  HUD.Free;
end;

function TBBotKillStats.TaskKills(AMonster: BStr): BInt32;
var
  Monster: BVector<TKillStatsData>.It;
begin
  Monster := Data.Find('KillStats query TaskKills for [' + AMonster + ']',
    function(Iter: BVector<TKillStatsData>.It): BBool
    begin
      Result := BStrEqual(Iter^.Creature, AMonster);
    end);
  Result := 0;
  if Monster <> nil then
    Exit(Monster^.Task);
end;

end.

