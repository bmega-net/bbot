unit uBBotDepotTools;


interface

uses
  uBTypes,
  uBBotAction,
  uBVector;

type
  TBBotDepotWalker = class(TBBotActionState)
  private
    FPosition: BPos;
    FLastDepot: BPos;
    function GetIsOnDepot: BBool;
  protected
    procedure FindDepot;
    procedure WalkToDepot;
  public
    constructor Create;
    destructor Destroy; override;

    procedure OnInit; override;
    procedure onStart; override;
    procedure Run; override;

    property IsOnDepot: BBool read GetIsOnDepot;
    property Position: BPos read FPosition;
    property LastDepot: BPos read FLastDepot;
  end;

  TBBotDepotOpener = class(TBBotActionState)
  private
    FDepotContainer: BInt32;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure onStart; override;

    property DepotContainer: BInt32 read FDepotContainer;
  end;

  TBBotDepotListEntry = record
    ID: BInt32;
    Name: BStr;
  end;

  TBBotDepotList = class(TBBotAction)
  private
    DepotList: BVector<TBBotDepotListEntry>;
    FSelectedDepot: BStr;
    FSelectedDepotId: BInt32;
    procedure SetSelectedDepot(const Value: BStr);
  protected
    function idForName(const AName: BStr): BInt32;
    function OpenLocker(AOpenSecondBP: BBool): BBool;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load;

    procedure Run; override;
    procedure OnInit; override;

    property Depots: BVector<TBBotDepotListEntry> read DepotList;
    property SelectedDepot: BStr read FSelectedDepot write SetSelectedDepot;
    property SelectedDepotId: BInt32 read FSelectedDepotId;

    function IsDepositerLockerOpen: BBool;
    function IsWithdrawerLockerOpen: BBool;
  end;

implementation

{ TBBotDepotWalker }

uses
  uTiles,
  BBotEngine,
  uDistance,
  Windows,
  uContainer,
  uBBotWalkerPathFinderPosition,
  SysUtils,
  uTibiaDeclarations;

constructor TBBotDepotWalker.Create;
begin
  inherited Create('DP.Walker', 600);
  FPosition := BPosXYZ(0, 0, 0);
  FLastDepot := FPosition;
end;

destructor TBBotDepotWalker.Destroy;
begin
  inherited;
end;

procedure TBBotDepotWalker.FindDepot;
var
  H, BestH: BInt32;
  Map: TTibiaTiles;
begin
  if Me.DistanceTo(LastDepot) > 1 then begin
    FPosition := BPosXYZ(0, 0, 0);
    BestH := 0;
    TilesSearch(Map, Me.Position, 6, False,
      function: BBool
      begin
        if Map.IsDepot then begin
          H := BBot.Walker.ApproachToCost(Map.Position);
          if H <> PathCost_NotPossible then begin
            if Map.Position = LastDepot then
              H := H * 3;
            if (H <= BestH) or (FPosition.X = 0) then begin
              BestH := H;
              FPosition := Map.Position;
            end;
          end;
        end;
        Result := False;
      end);
    FLastDepot := FPosition;
  end
  else
    FPosition := LastDepot;
end;

function TBBotDepotWalker.GetIsOnDepot: BBool;
begin
  Result := Me.DistanceTo(Position) <= 1;
end;

procedure TBBotDepotWalker.OnInit;
begin
  inherited;
  BBot.Events.OnStop.Add(doReset);
end;

procedure TBBotDepotWalker.onStart;
begin
  FPosition := BPosXYZ(0, 0, 0);
end;

procedure TBBotDepotWalker.Run;
begin
  if isRunning then
    if FPosition.X = 0 then
      FindDepot
    else begin
      if IsOnDepot then
        doSuccess
      else
        WalkToDepot;
    end;
end;

procedure TBBotDepotWalker.WalkToDepot;
var
  Path: TBBotPathFinderPosition;
begin
  if BBot.Walker.Task = nil then begin
    Path := TBBotPathFinderPosition.Create('DepotTools WalkToDepot <' + BStr(Position) + '>');
    Path.Position := Position;
    Path.Distance := 1;
    Path.Execute;
    if Path.Cost <> PathCost_NotPossible then
      BBot.Walker.WalkPathFinder(Path)
    else begin
      Path.Free;
      doStart;
    end;
  end;
end;

{ TBBotDepotOpener }

constructor TBBotDepotOpener.Create;
begin
  inherited Create('DP.Opener', 800);
  FDepotContainer := -1;
end;

destructor TBBotDepotOpener.Destroy;
begin

  inherited;
end;

procedure TBBotDepotOpener.onStart;
begin
  inherited;
  FDepotContainer := -1;
end;

procedure TBBotDepotOpener.Run;
var
  Container: TTibiaContainer;
  Map: TTibiaTiles;
begin
  if isRunning then begin
    Container := ContainerFirst;
    while Container <> nil do begin
      if Container.IsDepotContainer then begin
        FDepotContainer := Container.Container;
        doSuccess;
        Exit;
      end;
      Container := Container.Next;
    end;
    if TilesSearch(Map, Me.Position, 1, False,
      function: BBool
      begin
        Result := Map.IsDepot;
      end) then begin
      if not Map.Cleanup then
        Map.UseAsContainer;
    end
    else
      doFail;
  end;
end;

{ TBBotDepotList }

constructor TBBotDepotList.Create;

begin
  inherited Create('DepotList', 10000);
  DepotList := BVector<TBBotDepotListEntry>.Create;
  FSelectedDepot := '';
  FSelectedDepotId := ItemID_Locker;
end;

destructor TBBotDepotList.Destroy;

begin
  DepotList.Free;
  inherited;
end;

function TBBotDepotList.idForName(const AName: BStr): BInt32;
var
  ID: BUInt32;
begin
  ID := ItemID_Locker;
  DepotList.ForEach(
    procedure(AIt: BVector<TBBotDepotListEntry>.It)
    begin
      if BStrEqual(AName, AIt^.Name) then
        ID := AIt^.ID;
    end);
  Exit(ID);
end;

function TBBotDepotList.IsDepositerLockerOpen: BBool;
begin
  Result := OpenLocker(False);
end;

function TBBotDepotList.IsWithdrawerLockerOpen: BBool;
begin
  Result := OpenLocker(True);
end;

function TBBotDepotList.OpenLocker(AOpenSecondBP: BBool): BBool;
var
  CT: TTibiaContainer;
  IsLocker, IsSelectedLocker, IsInsideSelectedLocker, FirstBP: BBool;
begin
  FirstBP := True;
  CT := ContainerFirst;
  while CT <> nil do begin
    IsLocker := CT.ID = ItemID_Locker;
    IsSelectedLocker := CT.ID = BUInt32(SelectedDepotId);
    IsInsideSelectedLocker := CT.Icon = SelectedDepotId;
    if IsLocker or IsSelectedLocker or (IsInsideSelectedLocker and CT.IsContainer) then begin
      if IsInsideSelectedLocker and FirstBP and AOpenSecondBP then begin
        FirstBP := False;
        CT := CT.Next;
        Continue;
      end;
      CT.Use;
      Exit(False);
    end;
    CT := CT.Next;
  end;
  Exit(True);
end;

procedure TBBotDepotList.Load;

const
  DepotsFile = './Data/BBot.Depots.txt';
var
  FileHandle: TextFile;
  Line: BStr;
  sID, Name: BStr;
  Entry: BVector<TBBotDepotListEntry>.It;
begin
  AssignFile(FileHandle, DepotsFile);
  try
    Reset(FileHandle);
    while not EOF(FileHandle) do begin
      Readln(FileHandle, Line);
      Line := BTrim(Line);
      if Length(Line) > 0 then
        if BStrSplit(Line, '->', sID, Name) then begin
          Entry := DepotList.Add;
          Entry^.ID := BStrTo32(BTrim(sID));
          Entry^.Name := BTrim(Name);
        end;
    end;
    CloseFile(FileHandle);
  except
    on E: Exception do
      raise BException.Create('Error loading BBot.Depots:' + BStrLine + E.Message);
  end;
end;

procedure TBBotDepotList.OnInit;

begin
  inherited;
  Load;
end;

procedure TBBotDepotList.Run;

begin
  inherited;

end;

procedure TBBotDepotList.SetSelectedDepot(const Value: BStr);

begin
  FSelectedDepot := Value;
  FSelectedDepotId := idForName(Value);
end;

end.

