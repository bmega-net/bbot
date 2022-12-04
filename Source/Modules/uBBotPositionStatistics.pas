unit uBBotPositionStatistics;

interface

uses
  uBTypes,
  uBBotAction,
  Generics.Collections,
  Generics.Defaults,
  uHUD,

  uBattlelist;

type
  TBBotPositionStatistics = class(TBBotAction)
  private
    StepCount: TDictionary<BPos, BInt32>;
    AttackCount: TDictionary<BPos, BInt32>;
    FShowHUD: BBool;
    FDebug: BBool;
  protected
    function AttackRegionPos(APos: BPos): BPos;
    procedure HUDStepOnPos(APos: BPos);
    procedure HUDAttackOnPos(APos: BPos);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnWalk(AFrom: BPos);
    procedure OnTarget(ACreature: TBBotCreature);

    property Debug: BBool read FDebug write FDebug;
    property ShowHUD: BBool read FShowHUD write FShowHUD;

    function SteppedCount(const APos: BPos): BInt32;
    function AttackedCount(const APos: BPos): BInt32;
  end;

implementation

{ TBBotPositionStatistics }

uses
  Declaracoes,
  BBotEngine;

function CreatePositionDict: TDictionary<BPos, BInt32>;
begin
  Exit(TDictionary<BPos, BInt32>.Create(BPosComparator));
end;

function TBBotPositionStatistics.AttackedCount(const APos: BPos): BInt32;
begin
  if not AttackCount.TryGetValue(AttackRegionPos(APos), Result) then
    Exit(0);
end;

function TBBotPositionStatistics.AttackRegionPos(APos: BPos): BPos;
const
  RegionSize = 6;
begin
  Result := APos;
  Result.X := Result.X - (Result.X mod RegionSize) + (RegionSize div 2);
  Result.Y := Result.Y - (Result.Y mod RegionSize) + (RegionSize div 2);
end;

constructor TBBotPositionStatistics.Create;
begin
  inherited Create('PositionStastistics', 4000);
  FDebug := False;
  FShowHUD := False;

  StepCount := CreatePositionDict;
  AttackCount := CreatePositionDict;
end;

destructor TBBotPositionStatistics.Destroy;
begin
  StepCount.Free;
  AttackCount.Free;
  inherited;
end;

procedure TBBotPositionStatistics.OnInit;
begin
  inherited;
  BBot.Events.OnWalk.Add(OnWalk);
  BBot.Events.OnTarget.Add(OnTarget);
end;

procedure TBBotPositionStatistics.OnTarget(ACreature: TBBotCreature);
var
  RegionPos: BPos;
  CurrentCount: BInt32;
begin
  if ACreature <> nil then
  begin
    RegionPos := AttackRegionPos(ACreature.Position);
    if not AttackCount.TryGetValue(RegionPos, CurrentCount) then
      CurrentCount := 0;
    Inc(CurrentCount);
    AttackCount.AddOrSetValue(RegionPos, CurrentCount);

    if Debug then
    begin
      AddDebug(BFormat('Attacks for %s = %d', [BStr(RegionPos), CurrentCount]));
      HUDAttackOnPos(RegionPos);
    end;
  end;
end;

procedure TBBotPositionStatistics.OnWalk(AFrom: BPos);
var
  CurrentCount: BInt32;
  StepPos: BPos;
begin
  StepPos := Me.Position;
  if not StepCount.TryGetValue(StepPos, CurrentCount) then
    CurrentCount := 0;
  Inc(CurrentCount);
  StepCount.AddOrSetValue(StepPos, CurrentCount);

  if Debug then
  begin
    AddDebug(BFormat('Steps for %s = %d', [BStr(StepPos), CurrentCount]));
    HUDStepOnPos(StepPos);
  end;
end;

procedure TBBotPositionStatistics.Run;
var
  Pos: BPos;
begin
  if ShowHUD then
  begin
    HUDRemoveGroup(bhgDebugPositionStepStatistics);
    HUDRemoveGroup(bhgDebugPositionAttackStatistics);
    for Pos in StepCount.Keys do
      HUDStepOnPos(Pos);
    for Pos in AttackCount.Keys do
      HUDAttackOnPos(Pos);
  end;
end;

procedure TBBotPositionStatistics.HUDAttackOnPos(APos: BPos);
var
  HUD: TBBotHUD;
begin
  if Me.CanSee(APos) then
  begin
    HUDRemovePositionGroup(APos.X, APos.Y, APos.Z,
      bhgDebugPositionAttackStatistics);
    HUD := TBBotHUD.Create(bhgDebugPositionAttackStatistics);
    HUD.Color := $7070FF;
    HUD.Expire := 5000;
    HUD.RelativeY := HUDCharHeight;
    HUD.SetPosition(APos);
    HUD.Text := BToStr(AttackCount.Items[APos]);
    HUD.Print;
    HUD.Free;
  end;
end;

procedure TBBotPositionStatistics.HUDStepOnPos(APos: BPos);
var
  HUD: TBBotHUD;
begin
  if Me.CanSee(APos) then
  begin
    HUDRemovePositionGroup(APos.X, APos.Y, APos.Z,
      bhgDebugPositionStepStatistics);
    HUD := TBBotHUD.Create(bhgDebugPositionStepStatistics);
    HUD.Color := $70FF70;
    HUD.Expire := 5000;
    HUD.SetPosition(APos);
    HUD.Text := BToStr(StepCount.Items[APos]);
    HUD.Print;
    HUD.Free;
  end;
end;

function TBBotPositionStatistics.SteppedCount(const APos: BPos): BInt32;
begin
  if not StepCount.TryGetValue(APos, Result) then
    Exit(0);
end;

end.
