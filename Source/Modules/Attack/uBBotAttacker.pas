unit uBBotAttacker;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  StrUtils,
  SysUtils,

  Math,
  uBattlelist,
  Classes,

  uBVector,
  uBBotAttackerTask;

const
  BBotAttackerFailMaxAttemps = 3;
  BBotAttackerFailMaxAttempsVar = 'BBot.Attacker.FailMaxAttemps';
  BBotAttackerFailIgnoreTime = 30 * 1000;
  BBotAttackerFailIgnoreTimeVar = 'BBot.Attacker.FailIgnoreTime';
  BBotAttackerUnReachableIgnoreTime = 750;
  BBotAttackerUnReachableIgnoreTimeVar = 'BBot.Attacker.UnReachableIgnoreTime';

type
  TBBotAttacker = class(TBBotAction)
  private
    FEnabled: BBool;
    FNeverAttackPlayers: BBool;
    FAvoidKS: BBool;
    FFailIgnoreTime: BUInt32;
    FFailMaxAttemps: BInt32;
    FDebug: BBool;
    FUnReachableIgnoreTime: BUInt32;
    FAttackNotReachable: BBool;
    function GetAttackAllowed: BBool;
    procedure SetEnabled(const Value: BBool);
  protected
    Tasks: BVector<TBBotAttackerTask>;
    procedure CleanTasks;
    function SelectTask(AFilter: BUInt32): BVector<TBBotAttackerTask>.It;
    function SelectBestTarget: BVector<TBBotAttackerTask>.It;
    function SelectNextTarget: BVector<TBBotAttackerTask>.It;
    function ExecuteTask(const ATask: BVector<TBBotAttackerTask>.It): BBool; overload;
    function ExecuteTask(const ASelector: BFunc<BVector<TBBotAttackerTask>.It>): BBool; overload;
  public
    constructor Create;
    destructor Destroy; override;

    procedure OnInit; override;
    procedure Run; override;

    procedure NewTask(ACreature: TBBotCreature);

    function AttackRun: BBool;
    function AttackBest: BBool;
    function AttackNext: BBool;

    procedure OnCreatureTick(Creature: TBBotCreature);
    procedure OnCreatureAttack(Creature: TBBotCreature);
    procedure OnCreatureHP(Creature: TBBotCreature; OldHP: BInt32);

    property Enabled: BBool read FEnabled write SetEnabled;
    property Debug: BBool read FDebug write FDebug;

    property NeverAttackPlayers: BBool read FNeverAttackPlayers write FNeverAttackPlayers;
    property AvoidKS: BBool read FAvoidKS write FAvoidKS;

    property FailIgnoreTime: BUInt32 read FFailIgnoreTime;
    property FailMaxAttemps: BInt32 read FFailMaxAttemps;
    property UnReachableIgnoreTime: BUInt32 read FUnReachableIgnoreTime;
    property AttackNotReachable: BBool read FAttackNotReachable write FAttackNotReachable;

    property AttackAllowed: BBool read GetAttackAllowed;
  end;

implementation

uses
  BBotEngine,
  uSelf,

  Windows,
  uBBotAdvAttack;

{ TBBotAttacker }

function TBBotAttacker.AttackBest: BBool;
begin
  Result := ExecuteTask(SelectBestTarget);
end;

function TBBotAttacker.AttackNext: BBool;
begin
  Result := ExecuteTask(SelectNextTarget);
  if (not Result) and (Me.IsAttacking) then
    Me.Stop;
end;

function TBBotAttacker.AttackRun: BBool;
var
  Task: BVector<TBBotAttackerTask>.It;
  Creature: TBBotCreature;
begin
  if Me.IsAttacking then begin
    Task := SelectBestTarget;
    if Task <> nil then begin
      Creature := Task.GetCreature;
      if (Creature <> nil) and Creature.IsTarget then
        Exit(True);
      Exit(ExecuteTask(Task));
    end;
  end;
  Exit(AttackBest);
end;

procedure TBBotAttacker.CleanTasks;
begin
  Tasks.Delete(
    function(It: BVector<TBBotAttackerTask>.It): BBool
    begin
      if It^.Tries >= FailMaxAttemps then
        BBot.IgnoreAttack.Add(It^.ID, FailIgnoreTime, 'max attack attemps');
      Result := (NeverAttackPlayers and It^.IsPlayer) or (not It^.Alive) or BBot.IgnoreAttack.IsIgnored(It^.ID);
    end);
end;

constructor TBBotAttacker.Create;
begin
  inherited Create('Attacker', 1000);
  FEnabled := False;
  NeverAttackPlayers := True;
  AvoidKS := True;
  FFailIgnoreTime := BBotAttackerFailIgnoreTime;
  FFailMaxAttemps := BBotAttackerFailMaxAttemps;
  FUnReachableIgnoreTime := BBotAttackerUnReachableIgnoreTime;
  FAttackNotReachable := False;
  FDebug := False;
  Tasks := BVector<TBBotAttackerTask>.Create(
    procedure(It: BVector<TBBotAttackerTask>.It)
    begin
      It^.Free;
    end);
end;

destructor TBBotAttacker.Destroy;
begin
  Tasks.Free;
  inherited;
end;

function TBBotAttacker.ExecuteTask(const ATask: BVector<TBBotAttackerTask>.It): BBool;
var
  Creature: TBBotCreature;
begin
  Result := False;
  if AttackAllowed then begin
    if ATask <> nil then begin
      Creature := ATask^.GetCreature;
      if Creature <> nil then begin
        Creature.Attack;
        Result := True;
      end;
    end;
  end;
end;

function TBBotAttacker.ExecuteTask(const ASelector: BFunc<BVector<TBBotAttackerTask>.It>): BBool;
begin
  Exit(ExecuteTask(ASelector()));
end;

function TBBotAttacker.GetAttackAllowed: BBool;
begin
  Result := (not BBot.JustLoggedIn.JustLoggedIn) and (not(tsWithinProtectionZone in Me.Status)) and
    (not BBot.Cavebot.IsNoKill);
end;

procedure TBBotAttacker.NewTask(ACreature: TBBotCreature);
var
  Task: TBBotAttackerTask;
  Priority: BInt32;
begin
  if AttackAllowed then begin
    if not ACreature.IsAlive then
      Exit;
    if not Me.CanSee(ACreature.Position) then
      Exit;
    if not(NeverAttackPlayers and ACreature.IsPlayer) then begin
      if not BBot.IgnoreAttack.IsIgnored(ACreature.ID) then
        if BBot.AdvAttack.AttackablePriority(ACreature) then begin
          if not Tasks.Has('Killer adding task uniqueness [' + ACreature.Name + '=' + BToStr(ACreature.ID) + ']',
            function(It: BVector<TBBotAttackerTask>.It): BBool
            begin
              Result := It^.ID = ACreature.ID;
            end) then begin
            if ACreature.IsReachable or AttackNotReachable then begin
              Priority := BBot.AdvAttack.KillerPriority(ACreature);
              Task := TBBotAttackerTask.Create(ACreature.ID, Priority);
              Tasks.Add(Task);
            end
            else
              BBot.IgnoreAttack.Add(ACreature.ID, UnReachableIgnoreTime, 'unreachable');
          end;
        end;
    end;
  end;
end;

procedure TBBotAttacker.OnCreatureAttack(Creature: TBBotCreature);
begin
  if Enabled then
    NewTask(Creature);
end;

procedure TBBotAttacker.OnCreatureHP(Creature: TBBotCreature; OldHP: BInt32);
begin
  if not Creature.IsTarget then
    Creature.IsKillSteal := True;
end;

procedure TBBotAttacker.OnCreatureTick(Creature: TBBotCreature);
begin
  if Enabled then
    if Creature.IsNPC then
      if BBot.AdvAttack.KillerKnown(Creature) then
        if not(AvoidKS and Creature.IsKillSteal) then
          NewTask(Creature);
end;

procedure TBBotAttacker.OnInit;
begin
  BBot.Events.OnCreatureHP.Add(OnCreatureHP);
  BBot.Events.OnCreatureAttack.Add(OnCreatureAttack);
  BBot.Events.OnCreatureTick.Add(OnCreatureTick);

  BBot.Macros.Registry.CreateSystemVariable(BBotAttackerFailIgnoreTimeVar, BBotAttackerFailIgnoreTime).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FFailIgnoreTime := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable(BBotAttackerFailMaxAttempsVar, BBotAttackerFailMaxAttemps).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FFailMaxAttemps := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable(BBotAttackerUnReachableIgnoreTimeVar,
    BBotAttackerUnReachableIgnoreTime).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FUnReachableIgnoreTime := AValue;
    end);
end;

procedure TBBotAttacker.Run;
begin
end;

function TBBotAttacker.SelectBestTarget: BVector<TBBotAttackerTask>.It;
begin
  Result := SelectTask(0);
end;

function TBBotAttacker.SelectNextTarget: BVector<TBBotAttackerTask>.It;
begin
  Result := SelectTask(Me.TargetID);
end;

function TBBotAttacker.SelectTask(AFilter: BUInt32): BVector<TBBotAttackerTask>.It;
var
  Best: BVector<TBBotAttackerTask>.It;
  Score: BUInt32;
begin
  CleanTasks;
  Score := 0;
  Tasks.ForEach(
    procedure(It: BVector<TBBotAttackerTask>.It)
    var
      ItScore: BUInt32;
      ItCreature: TBBotCreature;
    begin
      ItScore := It^.Heuristic;
      if ((Best = nil) or (ItScore < Score)) and (It^.ID <> AFilter) then begin
        if not BBot.SummonDetector.isSummon(It^.ID) then begin
          Best := It;
          Score := ItScore;
        end;
      end;
      if Debug then begin
        ItCreature := It^.GetCreature;
        if (ItCreature <> nil) then
          AddDebug(ItCreature, BToStr(ItScore));
      end;
    end);
  if Best <> nil then begin
    Result := Best;
    if (Result <> nil) and Debug and (Result^.GetCreature <> nil) then
      AddDebug(Result^.GetCreature, '[' + BToStr(Result^.Heuristic) + ']');
  end
  else
    Result := nil;
end;

procedure TBBotAttacker.SetEnabled(const Value: BBool);

begin
  FEnabled := Value;
  Tasks.Clear;
  BBot.SummonDetector.Reset;
end;

end.
