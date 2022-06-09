unit uBBotWalker;

interface

uses uBTypes, uBBotAction, uTibiaDeclarations, Classes, uBProfiler, Declaracoes,
  uBBotWalkTask, uBVector, uHUD;

type

  TBBotWalkerAction = class(TBBotRunnable)
  protected
    function GetHeuristic: BUInt32; virtual; abstract;
    function GetExpired: BBool; virtual; abstract;
    function GetRunnable: BBool; virtual; abstract;
  public
    property Heuristic: BUInt32 read GetHeuristic;
    property Expired: BBool read GetExpired;
    property Runnable: BBool read GetRunnable;

    function DistanceScore(ADistance: BUInt32): BUInt32; overload;
    function DistanceScore(ADistance: BDbl): BUInt32; overload;
  end;

  TBBotWalker = class(TBBotAction)
  private type
    TBBotWalkerCost = record
      pFrom: BPos;
      pTo: BPos;
      Cost: BInt32;
      Expire: BUInt32;
    end;
  private
    FNextStep: BLock;
    FMapClick: BBool;
    FShowSpecial: BBool;
    NextUnstuck: BLock;
    CostsCache: BVector<TBBotWalkerCost>;
    FHistory: BVector<BPos>;
    FDebug: BBool;
    procedure SetMapClick(const Value: BBool);
    function DeltaToDir(DX, DY: BInt32): TTibiaDirection;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure Step(DX, DY: BInt32); overload;
    procedure Step(Dir: TTibiaDirection); overload;
    procedure Step; overload;
    procedure UnStuck;

    function ApproachToCost(APosition: BPos;
      AMaxRadiusDistance: BUInt32 = 0): BInt32;

    property MapClick: BBool read FMapClick write SetMapClick;
    property NextStep: BLock read FNextStep;

    property History: BVector<BPos> read FHistory;

    procedure OnWalk(FromPos: BPos);

    function DebugGroup: TBBotHUDGroup; override;
    property Debug: BBool read FDebug write FDebug;
  end;

implementation

uses uSelf, BBotEngine, uBattlelist, uBBotProtector, uTibia, uAStar, uItem,
  uBBotAttacker, uBTree, uDistance, Windows, uBBotOpenCorpses;

{ TBBotWalker }

function TBBotWalker.ApproachToCost(APosition: BPos;
  AMaxRadiusDistance: BUInt32): BInt32;
var
  T: TBBotWalkPosition;
  A: BVector<TBBotWalkerCost>.It;
begin
  CostsCache.Delete(
    function(It: BVector<TBBotWalkerCost>.It): BBool
    begin
      Result := (It^.Expire < Tick) or (Me.Position <> It^.pFrom);
    end);
  A := CostsCache.Find(
    function(It: BVector<TBBotWalkerCost>.It): BBool
    begin
      Result := APosition = It^.pTo;
    end);
  if A <> nil then
    Exit(A^.Cost);
  T := TBBotWalkPosition.Create;
  T.Target := APosition;
  T.Distance := 1;
  T.MaxRadiusDistance := AMaxRadiusDistance;
  T.RePath;
  Result := T.Cost;
  T.Free;
  A := CostsCache.Add;
  A^.pFrom := Me.Position;
  A^.pTo := APosition;
  A^.Expire := Tick + 3000;
  A^.Cost := Result;
end;

constructor TBBotWalker.Create;
begin
  inherited Create('Walker', 0);
  FMapClick := False;
  CostsCache := BVector<TBBotWalkerCost>.Create;
  FNextStep := BLock.Create(10, 20);
  NextUnstuck := BLock.Create(6000, 20);
  FShowSpecial := False;
  FHistory := BVector<BPos>.Create;
  FDebug := False;
end;

function TBBotWalker.DebugGroup: TBBotHUDGroup;
begin
  Result := bhgDebugWalker;
end;

function TBBotWalker.DeltaToDir(DX, DY: BInt32): TTibiaDirection;
begin
  Result := tdCenter;
  case DY of
    - 1:
      begin
        case DX of
          - 1:
            Exit(tdNorthWest);
          0:
            Exit(tdNorth);
          +1:
            Exit(tdNorthEast);
        end;
      end;
    0:
      begin
        case DX of
          - 1:
            Exit(tdWest);
          0:
            Exit(tdCenter);
          +1:
            Exit(tdEast);
        end;
      end;
    +1:
      begin
        case DX of
          - 1:
            Exit(tdSouthWest);
          0:
            Exit(tdSouth);
          +1:
            Exit(tdSouthEast);
        end;
      end;
  end;
end;

destructor TBBotWalker.Destroy;
begin
  FNextStep.Free;
  NextUnstuck.Free;
  CostsCache.Free;
  FHistory.Free;
  inherited;
end;

procedure TBBotWalker.UnStuck;
begin
  if Me.IsAttacking then
    Exit;
  if BBot.Cavebot.Enabled then
  begin
    if NextUnstuck.Locked then
      Exit;
    NextUnstuck.Lock;
    Me.Stop;
  end;
end;

procedure TBBotWalker.SetMapClick(const Value: BBool);
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

procedure TBBotWalker.OnInit;
begin
  inherited;
  BBot.Events.OnWalk.Add(OnWalk);
end;

procedure TBBotWalker.OnWalk(FromPos: BPos);
begin
  History.Add(FromPos);
  if History.Count > 14 then
    History.Delete(0);
end;

procedure TBBotWalker.Run;
begin
  if BBot.StandTime > 30 * 1000 then
  begin
    BBot.Protectors.OnProtector(bpkStucked, BBot.StandTime div 1000);
    UnStuck;
  end;
  if BBot.Looter.IsLooting or Me.IsAttacking then
    BBot.StandTime := Tick;
end;

procedure TBBotWalker.Step(DX, DY: BInt32);
var
  Dir: TTibiaDirection;
begin
  Dir := DeltaToDir(DX, DY);
  if Dir <> tdCenter then
    Step(Dir);
end;

procedure TBBotWalker.Step(Dir: TTibiaDirection);
var
  Delay: BUInt32;
begin
  if NextStep.Locked then
    Exit;
  BBot.SpecialSQMs.RegisterWalkAttemp(Dir);
  BBot.PacketSender.WalkStep(Dir);
  Delay := Me.StepDelay;
  Delay := Delay - BMinMax(BRandom(50), 0, Delay);
  NextStep.Lock(BMinMax(Delay, 0, 200));
end;

procedure TBBotWalker.Step;
begin
  Step(BRandom(-1, +1), BRandom(-1, +1));
end;

{ TBBotWalkerAction }

function TBBotWalkerAction.DistanceScore(ADistance: BUInt32): BUInt32;
begin
  Result := BUInt32(ADistance * 10);
end;

function TBBotWalkerAction.DistanceScore(ADistance: BDbl): BUInt32;
begin
  Result := BUInt32(BFloor(ADistance * 10));
end;

end.
