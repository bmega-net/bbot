unit uBBotOpenCorpsesTask;

interface

uses
  uBTypes,
  uBBotOpenCorpses,
  uBBotWalkerTask;

type
  TBBotOpenCorpsesTask = class(TBBotWalkerTask)
  private
    FPosition: BPos;
    FDeathTime: BUInt32;
    FTries: BInt32;
    FOpenCorpses: TBBotOpenCorpses;
    FUsedContainer: BBool;
    FSuccess: BBool;
    function GetTimeSinceDeath: BUInt32;
    function GetDistToSelf: BUInt32;
  protected
    NextRun: BLock;
    function HasContainerOnTile: BBool;
    function GetHeuristic: BUInt32;
    function GetDone: BBool; override;
    function GetRunnable: BBool;
    function GetHasNext: BBool; override;
    function GetWaitLockers: BBool; override;
  public
    constructor Create(AOpenCorpses: TBBotOpenCorpses; APosition: BPos);
    destructor Destroy; override;

    procedure Run; override;

    property Heuristic: BUInt32 read GetHeuristic;
    property Runnable: BBool read GetRunnable;

    property Position: BPos read FPosition;
    property DistToSelf: BUInt32 read GetDistToSelf;
    property TimeSinceDeath: BUInt32 read GetTimeSinceDeath;
    property DeathTime: BUInt32 read FDeathTime;
    property Tries: BInt32 read FTries write FTries;
    property OpenCorpses: TBBotOpenCorpses read FOpenCorpses;
    property UsedContainer: BBool read FUsedContainer;
    property Success: BBool read FSuccess write FSuccess;

    function RePath: BBool; override;

  end;

implementation

uses
  BBotEngine,
  uTiles,
  uTibiaDeclarations,
  uBBotWalkerPathFinderPosition,
  uDistance;

{ TBBotOpenCorpsesTask }

constructor TBBotOpenCorpsesTask.Create(AOpenCorpses: TBBotOpenCorpses; APosition: BPos);
begin
  inherited Create(TBBotPathFinderPosition.Create('OpenCorpse on <' + BStr(APosition) + '>'));
  FOpenCorpses := AOpenCorpses;
  FUsedContainer := False;
  FPosition := APosition;
  FDeathTime := Tick;
  FTries := 0;
  NextRun := BLock.Create(OpenCorpses.RunTick.ValueU32, 0.4);
  FSuccess := False;
  TBBotPathFinderPosition(PathFinder).Position := APosition;
  PathFinder.MaxDistance := 15;
  PathFinder.Distance := 1;
  RePath;
end;

destructor TBBotOpenCorpsesTask.Destroy;
begin
  NextRun.Free;
  inherited;
end;

function TBBotOpenCorpsesTask.GetDistToSelf: BUInt32;
begin
  Result := Me.DistanceTo(Position);
end;

function TBBotOpenCorpsesTask.GetDone: BBool;
  function Expired: BBool;
  begin
    Exit(TimeSinceDeath > OpenCorpses.NormalTimeout.ValueU32);
  end;
  function TooMuchTries: BBool;
  begin
    Exit(Tries > 8);
  end;
  function NoContainerOnPosition: BBool;
  begin
    Exit((TimeSinceDeath > OpenCorpses.NoCorpseTimeout.ValueU32) and (not HasContainerOnTile));
  end;

begin
  Result := Success or Expired or TooMuchTries or NoContainerOnPosition;
end;

function TBBotOpenCorpsesTask.GetRunnable: BBool;
begin
  if (tsWithinProtectionZone in Me.Status) or BBot.Backpacks.IsWorking or BBot.Depositer.Working or BBot.Withdraw.IsWorking
  then begin
    Exit(False);
  end else begin
    if HasContainerOnTile then begin
      BBot.Walker.WaitLock('OpenCorpses at ' + BStr(Position), OpenCorpses.WaitLockNewCorpse.ValueU32);
      if OpenCorpses.Debug then
        OpenCorpses.AddDebug(Position, 'corpse added in ' + BStr(Position), 'new corpse');
      Exit(True);
    end else begin
      Exit(False);
    end;
  end;
end;

function TBBotOpenCorpsesTask.GetHasNext: BBool;
begin
  if Me.GetDistance(Position) <= 1 then
    Exit(False)
  else
    Exit(inherited);
end;

function TBBotOpenCorpsesTask.GetHeuristic: BUInt32;
begin
  Result := Me.DistanceTo(Position) * 10;
end;

function TBBotOpenCorpsesTask.GetTimeSinceDeath: BUInt32;
begin
  Result := Tick - FDeathTime;
end;

function TBBotOpenCorpsesTask.GetWaitLockers: BBool;
begin
  Result := BBot.Looter.IsLooting;
end;

function TBBotOpenCorpsesTask.HasContainerOnTile: BBool;
var
  Map: TTibiaTiles;
begin
  if Me.CanSee(Position) then begin
    if Tiles(Map, Position) then
      Exit(Map.IsContainer);
  end;
  Exit(False);
end;

function TBBotOpenCorpsesTask.RePath: BBool;
begin
  if Me.GetDistance(Position) <= 1 then
    Exit(True)
  else
    Exit(inherited);
end;

procedure TBBotOpenCorpsesTask.Run;
var
  Map: TTibiaTiles;
begin
  BBot.Walker.WaitLock('OpenCorpses run task at ' + BStr(Position), OpenCorpses.WaitLockRun.ValueU32);
  if TimeSinceDeath < OpenCorpses.DelayBeforeOpen.ValueU32 then
    Exit;
  if not NextRun.Locked then begin
    if (Me.GetDistance(Position) > 1) and (not HasNext) then begin
      if PathFinder.Cost = PathCost_NotPossible then
        RePath;
    end else begin
      FUsedContainer := True;
      if Tiles(Map, Position) and (Map.IsContainer) then
        Map.UseAsContainer;
    end;
    Inc(FTries);
    NextRun.Lock;
  end;
end;

end.
