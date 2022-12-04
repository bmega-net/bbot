unit uBBotWalker2;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uTibiaDeclarations,
  uBBotWalkerTask,
  uBBotWalkerPathFinder,
  Generics.Collections,
  Generics.Defaults;

const
  BBotWalkerAutoBlockTime = 1400;
  BBotWalkerCostCacheDuration = 500;

type
  TBBotWalker2 = class(TBBotAction)
  private type
    TWalkWaitLock = record
      Name: BStr;
      Expire: BUInt32;
    end;

    TWalkCostCache = record
      Score: BFloat;
      Expire: BUInt32;
    end;
  private
    StepCount: BInt32;
    LastKey: BInt32;
    NextPos: BPos;
    TimeFirstStep: BUInt32;
    TimeNextStep: BUInt32;
    FMapClick: BBool;
    FTask: TBBotWalkerTask;
    FApproachCache: BVector<BPair<BPos, BInt32>>;
    FApproachCacheOrigin: BPos;
    FWaitLockDebug: BBool;
    function GetTimeStepping: BUInt32;
    procedure SetTask(const Value: TBBotWalkerTask);
    function GetStepDelay: BUInt32;
    procedure SetMapClick(const Value: BBool);
    function GetTimeToNextStep: BUInt32;
    procedure SetTimeNextStep;
    function GetWaiting: BBool;
  protected
    WalkableCostCache: TDictionary<BPos, TWalkCostCache>;
    WaitLockers: BVector<TWalkWaitLock>;
    function SpecialKeyDown: BBool;
    procedure SendKeyDown;
    procedure SendKeyUp;
    procedure CancelLastStep;
    procedure DoStep;
    procedure DoContinuousStep;
    procedure CheckStucked;
    procedure RunTask;
    procedure NextMapClick;
    procedure NextStep;
    procedure ClearWaitLock;
    procedure DebugWaitLockers;
  public
    constructor Create;
    destructor Destroy; override;

    procedure OnInit; override;
    procedure Run; override;

    procedure Step(ADirection: TTibiaDirection); overload;
    procedure Step(ADX, ADY: BInt32); overload;
    procedure RandomStep();
    property StepDelay: BUInt32 read GetStepDelay;
    property TimeStepping: BUInt32 read GetTimeStepping;
    property TimeToNextStep: BUInt32 read GetTimeToNextStep;

    property Task: TBBotWalkerTask read FTask write SetTask;
    property MapClick: BBool read FMapClick write SetMapClick;

    procedure WalkPathFinder(APathFinder: TBBotPathFinder);

    function ApproachToCost(APosition: BPos; AMaxDistance: BUInt32 = 0): BInt32;

    procedure Stop;
    procedure OnWalk(FromPos: BPos);

    function WalkableCost(const APos: BPos): BFloat; overload;
    function WalkableCost(const AX, AY, AZ: BInt32): BFloat; overload;

    procedure WaitLock(const AName: BStr; const ADelay: BUInt32);
    property Waiting: BBool read GetWaiting;
    property WaitLockDebug: BBool read FWaitLockDebug write FWaitLockDebug;
  end;

implementation

{ TBBotWalker2 }

uses
  BBotEngine,
  uDistance,
  uTibiaProcess,
  Windows,
  uBBotWalkerPathFinderPosition,
  Messages,
  uHUD,
  uBBotProtector,
  SysUtils,
  Declaracoes,
  uTiles,
  uBBotOpenCorpsesTask,
  uBBotWalkerDistancerTask;

function TBBotWalker2.ApproachToCost(APosition: BPos;
  AMaxDistance: BUInt32): BInt32;
var
  PathFinder: TBBotPathFinderPosition;
  Cached: BVector < BPair < BPos, BInt32 >>.It;
begin
  if APosition.Z <> Me.Position.Z then
    Exit(PathCost_NotPossible);
  if FApproachCacheOrigin <> Me.Position then
  begin
    FApproachCacheOrigin := Me.Position;
    FApproachCache.Clear;
  end;
  Cached := FApproachCache.Find('Walker ApproachToCost Cache query [' +
    BStr(APosition) + ']',
    function(It: BVector < BPair < BPos, BInt32 >>.It): BBool
    begin
      Result := APosition = It^.First;
    end);
  if (Cached <> nil) and (BRandom(0, 100) < 90) then
    Exit(Cached^.Second);
  PathFinder := TBBotPathFinderPosition.Create('ApproachToCost <' +
    BStr(APosition) + '>');
  PathFinder.Position := APosition;
  PathFinder.Distance := 1;
  if AMaxDistance <> 0 then
    PathFinder.MaxDistance := AMaxDistance;
  PathFinder.Execute;
  Result := PathFinder.Cost;
  PathFinder.Free;
  if Cached = nil then
    Cached := FApproachCache.Add;
  Cached^.First := APosition;
  Cached^.Second := Result;
end;

procedure TBBotWalker2.DoContinuousStep();
var
  DX, DY, Key, I: BInt32;
begin
  SetTimeNextStep;
  DX := NextPos.X - Me.Position.X;
  DY := NextPos.Y - Me.Position.Y;
  if (not SpecialKeyDown) and ((DX = 0) or (DY = 0)) then
  begin
    if DY = -1 then
      Key := VK_UP
    else if DY = +1 then
      Key := VK_DOWN
    else if DX = -1 then
      Key := VK_LEFT
    else if DX = +1 then
      Key := VK_RIGHT
    else
      Exit;
    if LastKey <> Key then
      CancelLastStep;
    LastKey := Key;
    if FTask.Continuous then
      for I := 0 to BRandom(2) do
        SendKeyDown;
    SendKeyDown;
  end
  else
  begin
    CancelLastStep;
    Tibia.SetMove(NextPos);
  end;
end;

procedure TBBotWalker2.CancelLastStep;
begin
  if LastKey <> 0 then
  begin
    SendKeyUp;
    LastKey := 0;
  end;
end;

procedure TBBotWalker2.CheckStucked;
begin
  if (BBot.StandTime > 30 * 1000) and (TimeStepping > 0) then
  begin
    BBot.Protectors.OnProtector(bpkStucked, BBot.StandTime div 1000);
    Me.Stop;
  end;
end;

procedure TBBotWalker2.ClearWaitLock;
begin
  WaitLockers.Delete(
    function(AIt: BVector<TWalkWaitLock>.It): BBool
    begin
      Exit(AIt.Expire < Tick);
    end);
end;

constructor TBBotWalker2.Create;
begin
  inherited Create('Walker2', 0);
  FTask := nil;
  LastKey := 0;
  NextPos.zero;
  StepCount := 0;
  TimeFirstStep := 0;
  TimeNextStep := Tick;
  FApproachCache := BVector < BPair < BPos, BInt32 >>.Create();
  FApproachCacheOrigin.change(0, 0, 0);
  WalkableCostCache := TDictionary<BPos, TWalkCostCache>.Create(BPosComparator);
  WaitLockers := BVector<TWalkWaitLock>.Create;
end;

function TBBotWalker2.GetStepDelay: BUInt32;
begin
  Result := BMax(20, BMin(Me.StepDelay, 200));
end;

function TBBotWalker2.GetTimeStepping: BUInt32;
begin
  if (FTask <> nil) and (TimeFirstStep <> 0) then
    Result := Tick - TimeFirstStep
  else
    Result := 0;
end;

function TBBotWalker2.GetTimeToNextStep: BUInt32;
begin
  if TimeNextStep > Tick then
    Exit(TimeNextStep - Tick)
  else
    Exit(0);
end;

function TBBotWalker2.GetWaiting: BBool;
begin
  Result := not WaitLockers.Empty;
end;

procedure TBBotWalker2.NextMapClick;
begin
  if (Me.GoingTo <> FTask.Last) and (Me.Position <> FTask.Last) and
    (FTask.Last.X <> 0) and (FTask.Last.Z = Me.Position.Z) then
    Tibia.SetMove(FTask.Last);
end;

procedure TBBotWalker2.NextStep;
begin
  if (TimeNextStep < Tick) and (FTask <> nil) and (not FTask.Done) then
    if FTask.HasNext then
      DoStep
    else
    begin
      CancelLastStep;
      FTask.RePath;
    end;
end;

procedure TBBotWalker2.OnInit;
begin
  inherited;
  BBot.Events.OnStop.Add(Stop);
  BBot.Events.OnWalk.Add(OnWalk);
end;

procedure TBBotWalker2.OnWalk(FromPos: BPos);
begin
  TimeFirstStep := 0;
end;

procedure TBBotWalker2.RandomStep;
begin
  Step(TTibiaDirection(BRandom(Ord(tdNorth), Ord(tdNorthWest))));
end;

procedure TBBotWalker2.Run;
var
  TaskType: BStr;
begin
  ClearWaitLock;
  DebugWaitLockers;
  BExecuteInSafeScope('Walker:CheckStucked', CheckStucked);
  if TimeNextStep < Tick then
  begin
    if FTask <> nil then
    begin
      if FTask is TBBotOpenCorpsesTask then
        TaskType := 'OpenCorpses'
      else if FTask is TBBotCreatureDistancerTask then
        TaskType := 'CreatureDistancer'
      else
        TaskType := 'WalkTask';
      BExecuteInSafeScope('Walker:Task:' + TaskType, RunTask);
    end
    else
    begin
      BExecuteInSafeScope('Walker:CancelLastStep', CancelLastStep);
    end;
  end;
end;

procedure TBBotWalker2.RunTask;
begin
  BExecuteInSafeScope('Walker:Task:Run', FTask.Run);
  if FTask.Done then
  begin
    BExecuteInSafeScope('Walker:Task:Stop', Stop);
  end
  else
  begin
    if FTask.WaitLockers and Waiting then
      Exit;
    if MapClick or FTask.UseMapClick then
    begin
      BExecuteInSafeScope('Walker:Task:NextMapClick', NextMapClick);
    end
    else
    begin
      BExecuteInSafeScope('Walker:Task:NextStep', NextStep);
    end;
  end;
end;

procedure TBBotWalker2.SendKeyDown;
begin
  SendMessageA(TibiaProcess.hWnd, WM_KEYDOWN, LastKey, NativeInt($40000001));
end;

procedure TBBotWalker2.SendKeyUp;
begin
  SendMessageA(TibiaProcess.hWnd, WM_KEYUP, LastKey, NativeInt($C0000001));
end;

procedure TBBotWalker2.SetMapClick(const Value: BBool);
var
  HUD: TBBotHUD;
begin
  if FMapClick <> Value then
  begin
    FMapClick := Value;
    if Value then
    begin
      HUD := TBBotHUD.Create(bhgPause);
      HUD.AlignTo(bhaCenter, bhaTop);
      HUD.Expire := 60000;
      HUD.Print('[Map Click]', $9898FF);
      HUD.Color := $A8A8A8;
      HUD.Print('By using the MapClick walkmode you increase the');
      HUD.Print('chance of being detected by the CipSoft bot detection tool.');
      HUD.Line;
      HUD.Print('Also the MapClick may cause bugs on looter and killer');
      HUD.Line;
      HUD.Print('MapClick do not support walking over fields or players,');
      HUD.Print('this will NEVER be supported.');
      HUD.Line;
      HUD.Print('MapClick feature must be only used when the normal');
      HUD.Print('walkmode do not work well.');
      HUD.Line;
      HUD.Print('This message will be hidden in: # s');
      HUD.Free;
    end;
  end;
end;

procedure TBBotWalker2.SetTask(const Value: TBBotWalkerTask);
begin
  if FTask <> nil then
    FTask.Free;
  FTask := Value;
  NextPos.zero;
end;

procedure TBBotWalker2.SetTimeNextStep;
begin
  TimeNextStep := Tick + StepDelay;
  Inc(StepCount);
  if Me.IsAttacking and ((StepCount mod 2) = 0) then
    Inc(TimeNextStep, StepDelay * 2);
end;

function TBBotWalker2.SpecialKeyDown: BBool;
begin
  Result := Tibia.IsKeyDown(VK_SHIFT, False) or
    Tibia.IsKeyDown(VK_CONTROL, False) or Tibia.IsKeyDown(VK_MENU, False);
end;

procedure TBBotWalker2.DebugWaitLockers;
var
  HUD: TBBotHUD;
begin
  if not WaitLockDebug then
    Exit;
  HUDRemoveGroup(bhgDebugWaitLockers);
  HUD := TBBotHUD.Create(bhgDebugWaitLockers);
  HUD.AlignTo(bhaLeft, bhaBottom);
  HUD.Color := $FFFFFF;
  WaitLockers.ForEach(
    procedure(AIt: BVector<TWalkWaitLock>.It)
    begin
      HUD.Text := BFormat('%s #', [AIt^.Name, AIt^.Expire]);
      HUD.Expire := AIt^.Expire - Tick;
      HUD.Print;
    end);
  HUD.Free;
end;

destructor TBBotWalker2.Destroy;
begin
  SetTask(nil);
  FApproachCache.Free;
  WalkableCostCache.Free;
  WaitLockers.Free;
  inherited;
end;

procedure TBBotWalker2.DoStep;
begin
  if NextPos <> FTask.Next then
  begin
    TimeFirstStep := Tick;
    NextPos := FTask.Next;
  end;
  if WalkableCost(NextPos.X, NextPos.Y, NextPos.Z) >= TileCost_NotWalkable then
    Task.RePath
  else if TimeStepping > BBotWalkerAutoBlockTime then
  begin
    BBot.SpecialSQMs.AutoBlock(NextPos);
    Task.RePath;
  end
  else
    DoContinuousStep;
end;

procedure TBBotWalker2.Step(ADirection: TTibiaDirection);
begin
  BBot.PacketSender.WalkStep(ADirection);
end;

procedure TBBotWalker2.Step(ADX, ADY: BInt32);
begin
  case ADY of
    - 1:
      begin
        case ADX of
          - 1:
            Step(tdNorthWest);
          0:
            Step(tdNorth);
          +1:
            Step(tdNorthEast);
        end;
      end;
    0:
      begin
        case ADX of
          - 1:
            Step(tdWest);
          0:
            ;
          +1:
            Step(tdEast);
        end;
      end;
    +1:
      begin
        case ADX of
          - 1:
            Step(tdSouthWest);
          0:
            Step(tdSouth);
          +1:
            Step(tdSouthEast);
        end;
      end;
  end;
end;

procedure TBBotWalker2.Stop;
begin
  TimeFirstStep := 0;
  CancelLastStep;
  SetTask(nil);
end;

function TBBotWalker2.WalkableCost(const APos: BPos): BFloat;
var
  M: TTibiaTiles;
  Cache: TWalkCostCache;
begin
  if APos.Z = Me.Position.Z then
  begin
    if WalkableCostCache.TryGetValue(APos, Cache) and (Cache.Expire > Tick) then
    begin
      Exit(Cache.Score) // The cached value is good! =]
    end
    else if Tiles(M, APos) then
    begin
      Cache.Score := M.Cost;
      Cache.Expire := Tick + BBotWalkerCostCacheDuration;
      WalkableCostCache.AddOrSetValue(APos, Cache);
      Exit(Cache.Score); // New value set to the cache
    end;
  end;
  Exit(TileCost_NotWalkable);
end;

procedure TBBotWalker2.WaitLock(const AName: BStr; const ADelay: BUInt32);
var
  Add: BVector<TWalkWaitLock>.It;
begin
  Add := WaitLockers.Find('Walker - WaitLock ' + AName,
    function(AIt: BVector<TWalkWaitLock>.It): BBool
    begin
      Exit(BStrEqual(AIt.Name, AName));
    end);
  if Add = nil then
    Add := WaitLockers.Add;
  Add^.Name := AName;
  Add^.Expire := Tick + ADelay;
end;

function TBBotWalker2.WalkableCost(const AX, AY, AZ: BInt32): BFloat;
begin
  Exit(WalkableCost(BPosXYZ(AX, AY, AZ)));
end;

procedure TBBotWalker2.WalkPathFinder(APathFinder: TBBotPathFinder);
begin
  Task := TBBotWalkerTask.Create(APathFinder);
end;

end.
