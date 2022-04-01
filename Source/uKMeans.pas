unit uKMeans;

interface

uses
  uBTypes,
  uBVector;

type
  PKMeansItem = ^TKMeansItem;

  TKMeansItem = record
    Position: BPos;
    Centroid: PKMeansItem;
    Next: PKMeansItem;
    case Integer of
    0: (Distance: BUInt32);
    1: (Labels: BUInt32);
  end;

  TKMeans = class
  private
    FK: BUInt32;
    FLabels: BVector<TKMeansItem>;
    FMaxIterations: BUInt32;
    FCentroids: BVector<TKMeansItem>;
    FFinished: BBool;
    FIterations: BUInt32;
  protected
    procedure cleanup;
    procedure updateLabels;
    procedure updateCentroids;
    procedure generateCentroids;
    function DistanceBetween(A, B: TKMeansItem): BUInt32; inline;
  public
    constructor Create;
    destructor Destroy; override;

    property MaxIterations: BUInt32 read FMaxIterations write FMaxIterations;
    property K: BUInt32 read FK write FK;

    property Centroids: BVector<TKMeansItem> read FCentroids;
    property Labels: BVector<TKMeansItem> read FLabels;

    property Finished: BBool read FFinished;
    property Iterations: BUInt32 read FIterations;

    procedure AddLabel(APosition: BPos);
    procedure ClearLabels;

    procedure Run;
    procedure Start;
    function Step: BBool;
  end;

implementation

{ TKMeans }

uses
  uDistance;

procedure TKMeans.AddLabel(APosition: BPos);
var
  L: BVector<TKMeansItem>.It;
begin
  L := FLabels.Add;
  L^.Position := APosition;
  L^.Distance := 0;
  L^.Centroid := nil;
  L^.Next := nil;
end;

procedure TKMeans.cleanup;
begin
  FCentroids.ForEach(
    procedure(It: BVector<TKMeansItem>.It)
    begin
      It^.Next := nil;
      It^.Labels := 0;
    end);
end;

procedure TKMeans.ClearLabels;
begin
  FLabels.Clear;
end;

constructor TKMeans.Create;
begin
  FCentroids := BVector<TKMeansItem>.Create();
  FLabels := BVector<TKMeansItem>.Create();
  FK := 0;
  FMaxIterations := 100;
end;

destructor TKMeans.Destroy;
begin
  FCentroids.Free;
  FLabels.Free;
  inherited;
end;

function TKMeans.DistanceBetween(A, B: TKMeansItem): BUInt32;
begin
  Result := NormalDistance(A.Position.X, A.Position.Y, B.Position.X, B.Position.Y);
end;

procedure TKMeans.generateCentroids;
var
  I: BUInt32;
  C: BVector<TKMeansItem>.It;
begin
  FCentroids.Clear;
  for I := 0 to FK - 1 do begin
    C := FCentroids.Add;
    C^.Position := FLabels.Item[BRandom(FLabels.Count - 1)].Position;
    C^.Labels := 0;
    C^.Centroid := nil;
    C^.Next := nil;
  end;
end;

procedure TKMeans.Run;
begin
  Start;
  while Step do
    Continue;
end;

procedure TKMeans.Start;
begin
  generateCentroids();
  FIterations := 0;
end;

function TKMeans.Step: BBool;
begin
  FFinished := Iterations > MaxIterations;
  if not FFinished then begin
    FFinished := True;
    cleanup;
    updateLabels;
    updateCentroids;
    Inc(FIterations);
  end;
  Result := not FFinished;
end;

procedure TKMeans.updateCentroids;
begin
  FCentroids.ForEach(
    procedure(It: BVector<TKMeansItem>.It)
    var
      Old: BPos;
      L: PKMeansItem;
      N: BInt32;
    begin
      if It^.Next <> nil then begin
        N := 0;
        L := It^.Next;
        Old := It^.Position;
        It^.Position.zero;
        while L <> nil do begin
          Inc(It^.Position.X, L^.Position.X);
          Inc(It^.Position.Y, L^.Position.Y);
          Inc(It^.Position.Z, L^.Position.Z);
          Inc(N);
          L := L^.Next;
        end;
        It^.Position.X := It^.Position.X div N;
        It^.Position.Y := It^.Position.Y div N;
        It^.Position.Z := It^.Position.Z div N;
        if Old <> It^.Position then
          FFinished := False;
      end else begin
        It^.Position := FLabels[BRandom(FLabels.Count - 1)]^.Position;
        It^.Next := nil;
        FFinished := False;
      end;
    end);
end;

procedure TKMeans.updateLabels;
begin
  FLabels.ForEach(
    procedure(L: BVector<TKMeansItem>.It)
    begin
      L^.Centroid := PKMeansItem(FCentroids[0]);
      L^.Distance := DistanceBetween(L^, L^.Centroid^);
      L^.Next := nil;
      FCentroids.ForEach(
        procedure(C: BVector<TKMeansItem>.It)
        var
          D: BUInt32;
        begin
          D := DistanceBetween(C^, L^);
          if D < L^.Distance then begin
            L^.Centroid := PKMeansItem(C);
            L^.Distance := D;
          end;
        end);
      Inc(L^.Centroid.Labels);
      L^.Next := L^.Centroid.Next;
      L^.Centroid.Next := PKMeansItem(L);
    end);
end;

const
  TestMaxWidth = 15;
  TestMaxHeight = 15;

procedure TestPrint(K: TKMeans);
var
  GroupMap: array [0 .. TestMaxWidth] of array [0 .. TestMaxHeight] of BChar;
  I, J: BInt32;
begin
  for I := 0 to High(GroupMap) do
    for J := 0 to High(GroupMap[I]) do
      GroupMap[I][J] := ' ';
  K.Labels.ForEach(
    procedure(It: BVector<TKMeansItem>.It)
    begin
      GroupMap[It^.Position.Y][It^.Position.X] := 'L';
    end);
  K.Centroids.ForEach(
    procedure(It: BVector<TKMeansItem>.It)
    begin
      if GroupMap[It^.Position.Y][It^.Position.X] = 'L' then
        GroupMap[It^.Position.Y][It^.Position.X] := 'C'
      else
        GroupMap[It^.Position.Y][It^.Position.X] := 'c';
    end);
  Write('+');
  for J := 0 to Length(GroupMap[0]) * 3 do
    Write('_');
  WriteLn('+');
  for I := 0 to High(GroupMap) do begin
    Write('|');
    for J := 0 to High(GroupMap[I]) do begin
      Write(GroupMap[I][J]);
      Write(GroupMap[I][J]);
      Write(GroupMap[I][J]);
    end;
    WriteLn('|');
  end;
  Write('+');
  for J := 0 to Length(GroupMap[0]) * 3 do
    Write('_');
  WriteLn('+');
  WriteLn('Iterations: ', K.Iterations);
end;

procedure Test;
var
  K: TKMeans;
  I: BInt32;
begin
  BConsoleCreate;
  try
    K := TKMeans.Create;
    for I := 0 to BRandom(4, 10) do
      K.AddLabel(BPosXYZ(BRandom(TestMaxWidth - 1), BRandom(TestMaxHeight - 1), 0));
    K.K := BRandom(2, 5);
    K.Start;
    TestPrint(K);
    ReadLn;
    while K.Step do begin
      TestPrint(K);
      ReadLn;
    end;
    WriteLn('Finished');
    ReadLn;
    K.Run;
    K.Free;
  finally
    BConsoleFree;
    Halt(12345);
  end;
end;

end.
