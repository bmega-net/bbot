unit uBVector;

interface

uses
  uBTypes;

{ .$DEFINE TestBVector }

type
  BVectorIndex = BInt32;

  BVector<T> = class;

  BVectorIterator<T> = record
  private
    Vector: BVector<T>;
    Index: BInt32;
    FFilter: BUnaryFunc<BInt32, BBool>;
  public
    function HasNext: BBool;
    function Next: T;
    function Clone: BVectorIterator<T>;
    function Filter(const APred: BUnaryFunc<BInt32, BBool>): BVectorIterator<T>;
  end;

  BVector<T> = class
  public type
    It = ^T;
  public const
    Invalid: BVectorIndex = 2147483647;
  private
    Data: array of T;
    FCount: BVectorIndex;
    FCapacity: BVectorIndex;
    FDeleter: BUnaryProc<It>;
    procedure SetCount(const Value: BVectorIndex);
    procedure SetCapacity(const Value: BVectorIndex);
    function GetItem(AIndex: BVectorIndex): It;
    function GetEmpty: BBool;
  protected
    procedure CheckIndex(AIndex: BVectorIndex; AFrom: BVectorIndex); inline;
    procedure DoSort(const AStart, AEnd: BVectorIndex;
      AComparer: BCompareFunc<It>);
    procedure InternalRemove(AIndex: BVectorIndex);
  public
    constructor Create(ADeleter: BUnaryProc<It>); overload;
    constructor Create; overload;
    destructor Destroy; override;

    property Count: BVectorIndex read FCount;
    property Empty: BBool read GetEmpty;
    property Capacity: BVectorIndex read FCapacity;
    property Item[AIndex: BVectorIndex]: It read GetItem; default;

    procedure Clear; overload;
    procedure Sort(AComparer: BCompareFunc<It>);

    function Add(AItem: T): It; overload;
    function Add: It; overload;
    procedure AddOrUpdate(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
      AUpdater: BUnaryProc<It>); overload;
    procedure AddOrUpdate(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
      AOffset: BVectorIndex; AUpdater: BUnaryProc<It>); overload;

    function Extract(AIndex: BVectorIndex): T;
    procedure Remove(AItem: It); overload;
    procedure Remove(AIndex: BVectorIndex); overload;
    procedure Delete(APred: BUnaryFunc<It, BBool>); overload;
    procedure Delete(AIndex: BVectorIndex); overload;
    procedure Delete(AIt: It); overload;

    procedure Swap(A, B: BVectorIndex);

    procedure ForEach(AIter: BUnaryProc<It>);

    function Search(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>)
      : BVectorIndex; overload;
    function Search(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
      AOffset: BVectorIndex): BVectorIndex; overload;

    function Find(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>): It; overload;
    function Find(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
      AOffset: BVectorIndex): It; overload;

    function Has(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>)
      : BBool; overload;
    function Has(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
      AOffset: BVectorIndex): BBool; overload;

    function Iter: BVectorIterator<T>;
  end;

implementation

uses
  SysUtils;

{ BVector<T> }

function BVector<T>.Add(AItem: T): It;
begin
  SetCount(FCount + 1);
  Data[FCount - 1] := AItem;
  Result := @Data[FCount - 1];
end;

function BVector<T>.Add: It;
begin
  SetCount(FCount + 1);
  Result := @Data[FCount - 1];
end;

procedure BVector<T>.AddOrUpdate(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
  AOffset: BVectorIndex; AUpdater: BUnaryProc<It>);
var
  Entry: It;
begin
  Entry := Find(AQuery, ASearcher, AOffset);
  if Entry = nil then
    Entry := Add;
  AUpdater(Entry);
end;

procedure BVector<T>.AddOrUpdate(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
  AUpdater: BUnaryProc<It>);
begin
  AddOrUpdate(AQuery, ASearcher, 0, AUpdater);
end;

procedure BVector<T>.CheckIndex(AIndex: BVectorIndex; AFrom: BVectorIndex);
begin
  if not BInRange(AIndex, 0, FCount - 1) then
    raise Exception.CreateFmt('BVector index out of bounds %d:%d/%d',
      [AFrom, AIndex, FCount]);
end;

constructor BVector<T>.Create;
begin
  FDeleter := nil;
  Clear;
end;

procedure BVector<T>.Clear;
var
  I: BVectorIndex;
begin
  for I := FCount - 1 downto 0 do
    Delete(I);
  SetCapacity(16);
end;

constructor BVector<T>.Create(ADeleter: BUnaryProc<It>);
begin
  FDeleter := ADeleter;
  Clear;
end;

procedure BVector<T>.Delete(AIndex: BVectorIndex);
begin
  CheckIndex(AIndex, 0);
  if Assigned(FDeleter) then
    FDeleter(@Data[AIndex]);
  InternalRemove(AIndex);
end;

procedure BVector<T>.Delete(AIt: It);
var
  I: BVectorIndex;
begin
  if FCount > 0 then
    for I := FCount - 1 downto 0 do
      if It(@Data[I]) = AIt then
        Delete(I);
end;

destructor BVector<T>.Destroy;
begin
  Clear;
  Data := nil;
  inherited;
end;

procedure BVector<T>.DoSort(const AStart, AEnd: BVectorIndex;
  AComparer: BCompareFunc<It>);
var
  Pivot, I: BVectorIndex;
  Save: T;
begin
  if AStart < AEnd then
  begin
    Pivot := AStart;
    I := AEnd;
    Save := Data[Pivot];
    while Pivot < I do
    begin
      if AComparer(@Save, @Data[I]) > 0 then
      begin
        Data[Pivot] := Data[I];
        Pivot := I;
        I := AStart + 1;
        while Pivot > I do
        begin
          if AComparer(@Save, @Data[I]) < 0 then
          begin
            Data[Pivot] := Data[I];
            Pivot := I;
            I := AEnd;
            Break;
          end
          else
            Inc(I);
        end;
      end
      else
        Dec(I);
    end;
    Data[Pivot] := Save;
    DoSort(AStart, Pivot - 1, AComparer);
    DoSort(Pivot + 1, AEnd, AComparer);
  end;
end;

function BVector<T>.Extract(AIndex: BVectorIndex): T;
begin
  CheckIndex(AIndex, 1);
  Result := Data[AIndex];
  InternalRemove(AIndex);
end;

procedure BVector<T>.Remove(AItem: It);
var
  I: BVectorIndex;
begin
  if FCount > 0 then
    for I := FCount - 1 downto 0 do
      if It(@Data[I]) = AItem then
        Remove(I);
end;

procedure BVector<T>.ForEach(AIter: BUnaryProc<It>);
var
  I: BVectorIndex;
begin
  if FCount > 0 then
    for I := 0 to FCount - 1 do
      try
        AIter(@Data[I]);
      except
        on E: Exception do
          raise BException.Create(String(BFormat('BVector ForEach %d/%d\n%s',
            [I, FCount, E.Message])));
      end;
end;

function BVector<T>.GetEmpty: BBool;
begin
  Result := FCount = 0;
end;

function BVector<T>.GetItem(AIndex: BVectorIndex): It;
begin
  CheckIndex(AIndex, 2);
  Result := @Data[AIndex];
end;

procedure BVector<T>.Delete(APred: BUnaryFunc<It, BBool>);
var
  I: BVectorIndex;
begin
  I := 0;
  while I < FCount do
  begin
    if APred(@Data[I]) then
      Delete(I)
    else
      Inc(I);
  end;
end;

function BVector<T>.Search(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>)
  : BVectorIndex;
begin
  Result := Search(AQuery, ASearcher, 0);
end;

function BVector<T>.Search(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
  AOffset: BVectorIndex): BVectorIndex;
var
  I: BVectorIndex;
begin
  if FCount > 0 then
    for I := AOffset to FCount - 1 do
      try
        if ASearcher(@Data[I]) then
          Exit(I);
      except
        on E: Exception do
          raise BException.Create(String(BFormat('BVector Search %s %d/%d\n%s',
            [AQuery, I, FCount, E.Message])));
      end;
  Result := Invalid;
end;

function BVector<T>.Has(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>): BBool;
begin
  Result := Search(AQuery, ASearcher) <> Invalid;
end;

function BVector<T>.Has(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
  AOffset: BVectorIndex): BBool;
begin
  Result := Search(AQuery, ASearcher, AOffset) <> Invalid;
end;

procedure BVector<T>.InternalRemove(AIndex: BVectorIndex);
var
  I: BVectorIndex;
begin
  CheckIndex(AIndex, 3);
  if FCount > 0 then
    for I := AIndex to FCount - 2 do
      Data[I] := Data[I + 1];
  SetCount(FCount - 1);
end;

procedure BVector<T>.Remove(AIndex: BVectorIndex);
begin
  InternalRemove(AIndex);
end;

function BVector<T>.Find(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>): It;
begin
  Result := Find(AQuery, ASearcher, 0);
end;

function BVector<T>.Find(AQuery: BStr; ASearcher: BUnaryFunc<It, BBool>;
  AOffset: BVectorIndex): It;
var
  I: BVectorIndex;
begin
  I := Search(AQuery, ASearcher, AOffset);
  if I <> Invalid then
    Result := @Data[I]
  else
    Result := nil;
end;

procedure BVector<T>.SetCapacity(const Value: BVectorIndex);
begin
  if FCapacity <> Value then
  begin
    FCapacity := Value;
    SetLength(Data, FCapacity);
  end;
end;

procedure BVector<T>.SetCount(const Value: BVectorIndex);
begin
  if FCount <> Value then
  begin
    if FCount = FCapacity then
      SetCapacity(FCapacity * 4);
    if (FCount < (FCapacity div 4)) and (FCount > 32) then
      SetCapacity(FCapacity div 4);
    FCount := Value;
  end;
end;

procedure BVector<T>.Sort(AComparer: BCompareFunc<It>);
begin
  if FCount > 0 then
    try
      DoSort(0, FCount - 1, AComparer);
    except
      on E: Exception do
        raise BException.Create(String(BFormat('BVector Sort\n%s',
          [E.Message])));
    end;
end;

procedure BVector<T>.Swap(A, B: BVectorIndex);
var
  Tmp: T;
begin
  Tmp := Data[A];
  Data[A] := Data[B];
  Data[B] := Tmp;
end;

function BVector<T>.Iter: BVectorIterator<T>;
begin
  Result.Vector := Self;
  Result.Index := -1;
  Result.FFilter := nil;
end;

{ BVectorIterator<T> }

function BVectorIterator<T>.Clone: BVectorIterator<T>;

begin
  Result.Vector := Self.Vector;
  Result.Index := Self.Index;
  Result.FFilter := Self.FFilter;
end;

function BVectorIterator<T>.Filter(const APred: BUnaryFunc<BInt32, BBool>)
  : BVectorIterator<T>;

begin
  Result := Clone;
  Result.FFilter := APred;
end;

function BVectorIterator<T>.HasNext: BBool;

begin
  while Index < (Vector.Count - 1) do
  begin
    Inc(Index);
    if Assigned(FFilter) then
      if not FFilter(Index) then
        Continue;
    Exit(True);
  end;
  Exit(False);
end;

function BVectorIterator<T>.Next: T;

begin
  Exit(Vector.Item[Index]^);
end;

{$IFDEF TestBVector}
{$APPTYPE CONSOLE}

procedure TestBInt32;
var
  L: BVector<BInt32>;
  I: BVectorIndex;
begin
  L := BVector<BInt32>.Create;
  for I := 0 to 3 do
    L.Add(BRandom(0, 100));
  L.Clear;
  L.Add(5);
  L.Add(9);
  L.Add(3);
  L.Add(4);
  L.Add(8);
  L.ForEach(
    procedure(It: BVector<BInt32>.It)
    begin
      WriteLn(It^);
    end);
  WriteLn('Sorting');
  L.Sort(
    function(A, B: BVector<BInt32>.It): BInt32
    begin
      Result := A^ - B^;
    end);
  L.ForEach(
    procedure(It: BVector<BInt32>.It)
    begin
      WriteLn(It^);
    end);
  ReadLn;
  L.Free;
end;

type
  Rec2D = record
    X, Y: BInt32;
  end;

  PRec2D = ^Rec2D;

procedure TestRec2D;
var
  L: BVector<Rec2D>;
  I: BVectorIndex;
  P: PRec2D;
begin
  L := BVector<Rec2D>.Create;
  for I := 0 to 99 do
  begin
    P := PRec2D(L.Add);
    P^.X := BRandom(0, 10);
    P^.Y := BRandom(0, 10);
  end;
  for I := 0 to 10 do
    L.Delete(BRandom(0, L.Count - 1));
  L.Delete(
    function(V: BVector<Rec2D>.It): BBool
    begin
      Result := PRec2D(V)^.X > 5;
    end);
  L.Search(
    function(V: BVector<Rec2D>.It): BBool
    begin
      Result := PRec2D(V)^.X = BRandom(0, 10);
    end);
  L.Free;
end;

procedure TestPRec2D;
var
  L: BVector<PRec2D>;
  I: BVector<PRec2D>.Index;
  P: PRec2D;
begin
  L := BVector<PRec2D>.Create(
    procedure(It: BVector<PRec2D>.It)
    begin
      Dispose(It^);
    end);
  for I := 0 to 99 do
  begin
    New(P);
    L.Add(P);
    P^.X := BRandom(0, 10);
    P^.Y := BRandom(0, 10);
  end;
  for I := 0 to 10 do
    L.Delete(I);
  L.Delete(
    function(V: BVector<PRec2D>.It): BBool
    begin
      Result := PRec2D(V^)^.X > 5;
    end);
  L.Search(
    function(V: BVector<PRec2D>.It): BBool
    begin
      Result := PRec2D(V)^.X = BRandom(0, 10);
    end);
  L.Free;
end;

procedure Test;
begin
  TestBInt32;
  TestRec2D;
  TestPRec2D;
end;

initialization

Test;
Halt;
{$ENDIF}

end.

