unit uBBotSkillsStats;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  uBVector,
  uHUD,
  uBBotStats;

type
  TBBotSkillsStats = class(TBBotStatsAction)
  protected
    Data: array [TTibiaSkill] of BInt32;
    function SkillLevel(ASkill: TTibiaSkill): BInt32;
  public
    constructor Create(AStats: TBBotStats);
    destructor Destroy; override;
    procedure Reset; override;
    procedure ShowHUD; override;
  end;

implementation

uses
  BBotEngine,
  Declaracoes;

{ TBBotSkillsStats }

constructor TBBotSkillsStats.Create(AStats: TBBotStats);
var
  Skill: TTibiaSkill;
begin
  inherited Create('Skills', AStats, bhaRight, bhaTop);
  for Skill := SkillFirst to SkillLast do
    Data[Skill] := 0;
end;

destructor TBBotSkillsStats.Destroy;
begin
  inherited;
end;

procedure TBBotSkillsStats.Reset;
var
  Skill: TTibiaSkill;
begin
  for Skill := SkillFirst to SkillLast do
    Data[Skill] := SkillLevel(Skill);
end;

procedure TBBotSkillsStats.ShowHUD;
var
  HUD: TBBotHUD;
  Skill: TTibiaSkill;
  Added: BInt32;
  PerHourFactor: BDbl;
begin
  HUD := CreateHUD(bhgSkillsStats, 'Skills Statistics', $00FFFF);
  HUD.Print('Training for: ' + SecToTime(Stats.StatsTime));
  PerHourFactor := Stats.PerHourFactor;
  for Skill := SkillFirst to SkillLast do begin
    Added := SkillLevel(Skill) - Data[Skill];
    HUD.PrintGray(BFormat('%s +%d%% (+%f%%/h)', [SkillToStr(Skill), Added, Added * PerHourFactor]));
  end;
  HUD.Line;
  HUD.Free;
end;

function TBBotSkillsStats.SkillLevel(ASkill: TTibiaSkill): BInt32;
begin
  Result := Me.SkillLevel[ASkill] * 100;
  Inc(Result, Me.SkillPercent[ASkill]);
end;

end.
