unit uBBotOpenCorpses;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uBattlelist,
  uContainer,
  uTibiaDeclarations,
  uBBotWalkerTask,
  uMacroVariable;

const
  BBotOpenCorpseNotOwner = 'You are not the owner.';
  BBotOpenCorpseNothingStart = 'Loot of ';
  BBotOpenCorpseNothingEnd = ': nothing';

type
  TBBotOpenCorpses = class(TBBotAction)
  private
    FJustDeath: BLock;
    FEnabled: BBool;
    FDebug: BBool;
    FIgnoreCreatures: BVector<BStr>;
    FNormalTimeout: BMacroSystemVariable;
    FNoCorpseTimeout: BMacroSystemVariable;
    FDelayBeforeOpen: BMacroSystemVariable;
    FRunTick: BMacroSystemVariable;
    FWaitLockNewCorpse: BMacroSystemVariable;
    FWaitLockRun: BMacroSystemVariable;
    FPaused: BBool;
    function GetEnabled: BBool;
    procedure SetEnabled(const Value: BBool);
  protected
    Tasks: BVector<TBBotWalkerTask>;
    procedure CleanTasks;
    function SelectBestCorpse: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    property Paused: BBool read FPaused write FPaused;
    property Enabled: BBool read GetEnabled write SetEnabled;
    property Debug: BBool read FDebug write FDebug;

    property NormalTimeout: BMacroSystemVariable read FNormalTimeout;
    property NoCorpseTimeout: BMacroSystemVariable read FNoCorpseTimeout;
    property DelayBeforeOpen: BMacroSystemVariable read FDelayBeforeOpen;
    property RunTick: BMacroSystemVariable read FRunTick;
    property WaitLockNewCorpse: BMacroSystemVariable read FWaitLockNewCorpse;
    property WaitLockRun: BMacroSystemVariable read FWaitLockRun;
    property JustDeath: BLock read FJustDeath;

    property IgnoreCreatures: BVector<BStr> read FIgnoreCreatures;

    procedure NewCorpseTask(Position: BPos);
    function HasCorpseOnPosition(APosition: BPos): BBool;

    procedure OnInit; override;
    procedure Run; override;

    function OpenNextCorpse: BBool;

    function IsIgnored(const AName: BStr): BBool;

    procedure OnCreatureDie(Creature: TBBotCreature);
    procedure OnSystemMessage(AMessageData: TTibiaMessage);
    procedure OnContainerOpen(CT: TTibiaContainer);
  end;

implementation

uses
  BBotEngine,

  uBBotOpenCorpsesTask;

{ TBBotOpenCorpses }

procedure TBBotOpenCorpses.CleanTasks;
begin
  Tasks.Delete(
    function(It: BVector<TBBotWalkerTask>.It): BBool
    begin
      Result := It^.Done;
    end);
end;

procedure TBBotOpenCorpses.NewCorpseTask(Position: BPos);
begin
  if Enabled then begin
    if not HasCorpseOnPosition(Position) then begin
      Tasks.Add(TBBotOpenCorpsesTask.Create(Self, Position));
    end;
  end;
end;

constructor TBBotOpenCorpses.Create;
begin
  inherited Create('Open Corpses', 200);
  FEnabled := False;
  FPaused := False;
  FDebug := False;
  FJustDeath := BLock.Create(600, 0.5);
  FIgnoreCreatures := BVector<BStr>.Create;
  Tasks := BVector<TBBotWalkerTask>.Create(
    procedure(It: BVector<TBBotWalkerTask>.It)
    begin
      It^.Free;
    end);
end;

destructor TBBotOpenCorpses.Destroy;
begin
  FIgnoreCreatures.Free;
  FJustDeath.Free;
  Tasks.Free;
  inherited;
end;

function TBBotOpenCorpses.GetEnabled: BBool;
begin
  Result := FEnabled and (not FPaused);
end;

function TBBotOpenCorpses.HasCorpseOnPosition(APosition: BPos): BBool;
begin
  Result := Tasks.Has('Open Corpses - HasCorpseOnPosition ' + BStr(APosition),
    function(It: BVector<TBBotWalkerTask>.It): BBool
    begin
      Result := TBBotOpenCorpsesTask(It^).Position = APosition;
    end);
end;

function TBBotOpenCorpses.IsIgnored(const AName: BStr): BBool;
begin
  Result := IgnoreCreatures.Has('Open Corpses - IsIgnored ' + AName,
    function(AIt: BVector<BStr>.It): BBool
    begin
      Result := BStrEqual(AIt^, AName);
    end);
end;

procedure TBBotOpenCorpses.OnContainerOpen(CT: TTibiaContainer);
var
  Task: TBBotOpenCorpsesTask;
begin
  if CT.Open and (BBot.Walker.Task is TBBotOpenCorpsesTask) then begin
    Task := TBBotOpenCorpsesTask(BBot.Walker.Task);
    if Task.UsedContainer then begin
      if Debug then
        AddDebug('removing corpse, container opened ' + BStr(Task.Position));
      Task.Success := True;
    end;
  end;
end;

procedure TBBotOpenCorpses.OnCreatureDie(Creature: TBBotCreature);
begin
  if (Creature.ID = Me.LastAttackedID) or (not Creature.IsKillSteal) or (Me.DistanceTo(Creature) < 3) then
    if BBot.Cavebot.IsOpenningCorpse then begin
      if not IsIgnored(Creature.Name) then begin
        NewCorpseTask(Creature.Position)
      end else if Debug then begin
        AddDebug('ignoring creature by name ' + Creature.Name);
      end;
      if BBot.ConfirmAttack.RecentlyAttacked(Creature) then
        JustDeath.Lock;
    end;
end;

procedure TBBotOpenCorpses.OnInit;
begin
  inherited;
  BBot.Events.OnContainerOpen.Add(OnContainerOpen);
  BBot.Events.OnCreatureDie.Add(OnCreatureDie);
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);

  FNormalTimeout := ModVariable('NormalTimeout', 3 * 60 * 1000);
  FNoCorpseTimeout := ModVariable('NoCorpseTimeout', 2000);
  FDelayBeforeOpen := ModVariable('DelayBeforeOpen', 1050);
  FRunTick := ModVariable('RunTick', 1000);
  FWaitLockNewCorpse := ModVariable('WaitLock.NewCorpse', 3000);
  FWaitLockRun := ModVariable('WaitLock.Run', 1500);
  ModVariableLock('TargetDead.Lock', JustDeath);
end;

procedure TBBotOpenCorpses.OnSystemMessage(AMessageData: TTibiaMessage);
var
  Task: TBBotOpenCorpsesTask;
begin
  Task := nil;
  if BBot.Walker.Task is TBBotOpenCorpsesTask then begin
    Task := TBBotOpenCorpsesTask(BBot.Walker.Task);
    if (AMessageData.Text = BBotOpenCorpseNotOwner) and Task.UsedContainer then begin
      if Debug then
        AddDebug('removing corpse, not owner ' + BStr(Task.Position));
      Task.Success := True;
    end;
  end;
  if (((Tasks.Count = 1) xor (Task <> nil)) and BStrStartSensitive(AMessageData.Text, BBotOpenCorpseNothingStart) and
    BStrEndSensitive(AMessageData.Text, BBotOpenCorpseNothingEnd)) then begin
    if Debug then
      AddDebug('removing corpse, nothing message');
    if Task <> nil then
      Task.Success := True;
    Tasks.Clear;
  end;
end;

function TBBotOpenCorpses.OpenNextCorpse: BBool;
  function CreatureRecentlyDied: BBool;
  begin
    Exit(JustDeath.Locked);
  end;
  function RunningOpenCorpseTask: BBool;
  begin
    Exit((BBot.Walker.Task <> nil) and (BBot.Walker.Task is TBBotOpenCorpsesTask));
  end;
  function SelectNewTask: BBool;
  begin
    Exit((BBot.Walker.Task = nil) and SelectBestCorpse);
  end;

begin
  Result := Enabled and (RunningOpenCorpseTask or SelectNewTask or CreatureRecentlyDied);
end;

procedure TBBotOpenCorpses.Run;
begin
end;

function TBBotOpenCorpses.SelectBestCorpse: BBool;
var
  BestIt: BVector<TBBotWalkerTask>.It;
  Best: TBBotOpenCorpsesTask;
begin
  if BBot.Walker.Task = nil then begin
    Best := nil;
    BestIt := nil;
    Tasks.ForEach(
      procedure(It: BVector<TBBotWalkerTask>.It)
      var
        Task: TBBotOpenCorpsesTask;
      begin
        Task := TBBotOpenCorpsesTask(It^);
        if Task.Runnable and ((Best = nil) or (Task.Heuristic < Best.Heuristic)) then begin
          BestIt := It;
          Best := Task;
        end;
      end);
    if Best <> nil then begin
      BBot.Walker.Task := Best;
      Tasks.Remove(BestIt);
      Exit(True);
    end;
  end;
  Exit(False);
end;

procedure TBBotOpenCorpses.SetEnabled(const Value: BBool);

begin
  FEnabled := Value;
  if Value then
    FPaused := False;
end;

end.
