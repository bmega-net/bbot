unit uBBotWalkerTask;

interface

uses
  uBTypes,
  uBVector,
  uBBotWalkerPathFinder,
  uBBotAction;

type
  TBBotWalkerTask = class(TBBotRunnable)
  private
    FUseMapClick: BBool;
  protected
    FPath: BVector<BPos>;
    FPathFinder: TBBotPathFinder;
    FLast: BPos;
    FNext: BPos;
    FContinuous: BBool;
    function GetHasNext: BBool; virtual;
    function GetDone: BBool; virtual;
    function GetWaitLockers: BBool; virtual;
  public
    constructor Create(APathFinder: TBBotPathFinder);
    destructor Destroy; override;

    property Done: BBool read GetDone;
    property Next: BPos read FNext;
    property Last: BPos read FLast;
    property Continuous: BBool read FContinuous;
    property HasNext: BBool read GetHasNext;

    property WaitLockers: BBool read GetWaitLockers;

    property Path: BVector<BPos> read FPath;
    property PathFinder: TBBotPathFinder read FPathFinder;
    property UseMapClick: BBool read FUseMapClick write FUseMapClick;

    procedure Run; override;

    function RePath: BBool; virtual;
  end;

implementation

uses
  BBotEngine,
  uDistance;

{ TBBotWalkerPath }

constructor TBBotWalkerTask.Create(APathFinder: TBBotPathFinder);
begin
  FPath := BVector<BPos>.Create();
  FPathFinder := APathFinder;
  FUseMapClick := False;
  FNext.change(0, 0, 0);
  FLast.change(0, 0, 0);
  APathFinder.GeneratePath(FPath);
end;

destructor TBBotWalkerTask.Destroy;
begin
  FPath.Free;
  FPathFinder.Free;
  inherited;
end;

function TBBotWalkerTask.GetDone: BBool;
begin
  Result := not HasNext;
end;

function TBBotWalkerTask.GetHasNext: BBool;
var
  I, NDX, NDY, NNDX, NNDY: BInt32;
begin
  if FPath.Count > 0 then
  begin
    for I := FPath.Count - 1 downto 1 do
      if FPath.Item[I]^ = Me.Position then
      begin
        FLast := FPath.Item[0]^;
        FNext := FPath.Item[I - 1]^;
        if (I > 1) then
        begin
          NDX := FNext.X - Me.Position.X;
          NDY := FNext.Y - Me.Position.Y;
          NNDX := FPath.Item[I - 2]^.X - FNext.X;
          NNDY := FPath.Item[I - 2]^.Y - FNext.Y;
          FContinuous := (NDX = NNDX) and (NDY = NNDY);
        end
        else
          FContinuous := False;
        Exit(True);
      end;
  end;
  FNext.change(0, 0, 0);
  FLast.change(0, 0, 0);
  FContinuous := False;
  Exit(False);
end;

function TBBotWalkerTask.GetWaitLockers: BBool;
begin
  Result := True;
end;

function TBBotWalkerTask.RePath: BBool;
begin
  Path.Clear;
  PathFinder.Execute;
  if PathFinder.Cost <> PathCost_NotPossible then
  begin
    PathFinder.GeneratePath(Path);
    Exit(True);
  end
  else
    Exit(False);
end;

procedure TBBotWalkerTask.Run;
begin
  inherited;
end;

end.
