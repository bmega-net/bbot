unit uBBotAttackerTask;

interface

uses
  uBTypes,
  uBattlelist;

type
  TBBotAttackerTask = class
  private
    FID: BUInt32;
    FTries: BInt32;
    FPriority: BInt32;
    function GetAlive: BBool;
    function GetDistance: BUInt32;
    function GetHeuristic: BUInt32;
    function GetHealthHeuristic: BUInt32;
    function GetPriorityHeuristic: BUInt32;
    function GetIsPlayer: BBool;
    function GetAlreadyAttackingHeuristic: BUInt32;
  protected
    Next: BLock;
  public
    constructor Create(AID: BUInt32; APriority: BInt32);
    destructor Destroy; override;

    function GetCreature: TBBotCreature;

    property ID: BUInt32 read FID;
    property Priority: BInt32 read FPriority;
    property Tries: BInt32 read FTries;

    property Alive: BBool read GetAlive;
    property Heuristic: BUInt32 read GetHeuristic;

    property Distance: BUInt32 read GetDistance;
    property PriorityHeuristic: BUInt32 read GetPriorityHeuristic;
    property HealthHeuristic: BUInt32 read GetHealthHeuristic;
    property AlreadyAttackingHeuristic: BUInt32
      read GetAlreadyAttackingHeuristic;

    property IsPlayer: BBool read GetIsPlayer;

    procedure Execute;
    procedure Attack;
  end;

implementation

uses
  BBotEngine,
  uDistance,
  uBBotAdvAttack,
  uTibiaDeclarations;

{ TBBotAttackerTask }

procedure TBBotAttackerTask.Attack;
var
  Creature: TBBotCreature;
begin
  Creature := GetCreature;
  if Creature <> nil then
    Creature.Attack;
end;

constructor TBBotAttackerTask.Create(AID: BUInt32; APriority: BInt32);
begin
  FID := AID;
  FPriority := APriority;
  FTries := 0;
  Next := BLock.Create(1500, 50);
end;

destructor TBBotAttackerTask.Destroy;
begin
  Next.Free;
  inherited;
end;

procedure TBBotAttackerTask.Execute;
begin
  if not Next.Locked then
  begin
    Next.Lock;
    Inc(FTries);
    Attack;
  end;
end;

function TBBotAttackerTask.GetAlive: BBool;
var
  Creature: TBBotCreature;
begin
  Creature := GetCreature;
  Result := (Creature <> nil) and (Creature.IsAlive) and (Creature.IsOnScreen)
    and (Creature.IsReachable or BBot.Attacker.AttackNotReachable);
end;

function TBBotAttackerTask.GetAlreadyAttackingHeuristic: BUInt32;
var
  Creature: TBBotCreature;
begin
  Creature := GetCreature;
  if (Creature <> nil) and Creature.IsTarget then
    Exit(0);
  Exit(3);
end;

function TBBotAttackerTask.GetCreature: TBBotCreature;
begin
  Result := BBot.Creatures.Find(ID);
end;

function TBBotAttackerTask.GetDistance: BUInt32;
var
  Creature: TBBotCreature;
begin
  Creature := GetCreature;
  if Creature <> nil then
    Result := SQMDistance(Creature.Position.X, Creature.Position.Y,
      Me.Position.X, Me.Position.Y)
  else
    Result := 0;
end;

function TBBotAttackerTask.GetHealthHeuristic: BUInt32;
var
  Creature: TBBotCreature;
  HP: BInt32;
begin
  HP := 100;
  Creature := GetCreature;
  if Creature <> nil then
    HP := Creature.Health;
  Exit(HP div 20);
end;

function TBBotAttackerTask.GetHeuristic: BUInt32;
begin
  Result := HealthHeuristic + Distance + PriorityHeuristic +
    AlreadyAttackingHeuristic;
end;

function TBBotAttackerTask.GetIsPlayer: BBool;
begin
  Result := IsPlayerID(ID);
end;

function TBBotAttackerTask.GetPriorityHeuristic: BUInt32;
begin
  if (FPriority <> BBotAdvAttackIgnore) and (FPriority <> BBotAdvAttackAvoid)
  then
  begin
    Result := FPriority;
  end
  else
    Result := 0;
  Result := (5 - Result) * 4;
end;

end.
