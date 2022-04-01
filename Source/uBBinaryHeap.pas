unit uBBinaryHeap;

interface

uses
  uBTypes,
  uBVector;

type
  BBaseHeap<T> = class
  protected
    FComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
    FTToString: BUnaryFunc<BVector<T>.It, BStr>;
    FItems: BVector<T>;
    function Compare(ALeft, ARight: BVectorIndex): BBool; virtual; abstract;
  public
    constructor Create(AComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
      ADeleter: BUnaryProc<BVector<T>.It>; ATToString: BUnaryFunc<BVector<T>.It, BStr>);
    destructor Destroy; override;

    function Parent(AIndex: BVectorIndex): BVectorIndex;
    function Left(AIndex: BVectorIndex): BVectorIndex;
    function Right(AIndex: BVectorIndex): BVectorIndex;
    procedure Heapify(AIndex: BVectorIndex);
    procedure IncreaseKey(AIndex: BVectorIndex; AValue: T);

    function Size: BVectorIndex;
    function Pop: T;
    procedure Push(AValue: T);

    function TreeToStr(AIndex: BInt32; AIndent: BStr; AIndentSize: BInt32): BStr; overload;
    function TreeToStr(AIndent: BStr): BStr; overload;

    property Comparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32> read FComparer;
    property Items: BVector<T> read FItems;
  end;

  BMaxHeap<T> = class(BBaseHeap<T>)
  protected
    function Compare(ALeft, ARight: BVectorIndex): BBool; override;
  public
    constructor Create(AComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
      ADeleter: BUnaryProc<BVector<T>.It>; ATToString: BUnaryFunc<BVector<T>.It, BStr>);
  end;

  BMinHeap<T> = class(BBaseHeap<T>)
  protected
    function Compare(ALeft, ARight: BVectorIndex): BBool; override;
  public
    constructor Create(AComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
      ADeleter: BUnaryProc<BVector<T>.It>; ATToString: BUnaryFunc<BVector<T>.It, BStr>);
  end;

implementation

uses
  SysUtils{$IFDEF TEST},
  TestFramework{$ENDIF};

{ BBaseHeap<T> }

constructor BBaseHeap<T>.Create(AComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
  ADeleter: BUnaryProc<BVector<T>.It>; ATToString: BUnaryFunc<BVector<T>.It, BStr>);
begin
  FItems := BVector<T>.Create(ADeleter);
  FComparer := AComparer;
  FTToString := ATToString;
end;

destructor BBaseHeap<T>.Destroy;
begin
  FItems.Free;
  inherited;
end;

function BBaseHeap<T>.TreeToStr(AIndex: BInt32; AIndent: BStr; AIndentSize: BInt32): BStr;
var
  I: BInt32;
begin
  if AIndex <= Size then begin
    Result := '';
    for I := 0 to AIndentSize do
      Result := Result + AIndent;
    Result := BStrLine + Result + FTToString(FItems.Item[AIndex - 1]);
    Result := Result + TreeToStr(Left(AIndex), AIndent, AIndentSize + 1);
    Result := Result + TreeToStr(Right(AIndex), AIndent, AIndentSize + 1);
  end
  else
    Result := '';
end;

function BBaseHeap<T>.TreeToStr(AIndent: BStr): BStr;
begin
  Result := TreeToStr(1, AIndent, 0);
end;

procedure BBaseHeap<T>.Heapify(AIndex: BVectorIndex);
var
  L, R, S, B: BVectorIndex;
begin
  L := Left(AIndex);
  R := Right(AIndex);
  S := Size;
  if (L <= S) and Compare(L, AIndex) then
    B := L
  else
    B := AIndex;
  if (R <= S) and Compare(R, B) then
    B := R;
  if B <> AIndex then begin
    FItems.Swap(B - 1, AIndex - 1);
    Heapify(B);
  end;
end;

procedure BBaseHeap<T>.IncreaseKey(AIndex: BVectorIndex; AValue: T);
var
  Index: BUInt32;
begin
  FItems.Item[AIndex - 1]^ := AValue;
  Index := AIndex;
  while (Index > 1) and (not Compare(Parent(Index), Index)) do begin
    FItems.Swap(Index - 1, Parent(Index) - 1);
    Index := Parent(Index);
  end;
end;

function BBaseHeap<T>.Left(AIndex: BVectorIndex): BVectorIndex;
begin
  Exit(AIndex * 2);
end;

function BBaseHeap<T>.Right(AIndex: BVectorIndex): BVectorIndex;
begin
  Exit((AIndex * 2) + 1);
end;

function BBaseHeap<T>.Parent(AIndex: BVectorIndex): BVectorIndex;
begin
  Exit(BFloor(AIndex / 2));
end;

function BBaseHeap<T>.Pop: T;
begin
  if Size > 0 then begin
    Result := FItems.Item[0]^;
    FItems.Item[0]^ := FItems.Item[FItems.Count - 1]^;
    FItems.Remove(FItems.Count - 1);
    Heapify(1);
  end
  else
    raise Exception.Create('Pop from empty heap');
end;

procedure BBaseHeap<T>.Push(AValue: T);
begin
  FItems.Add(AValue);
  IncreaseKey(FItems.Count, AValue);
end;

function BBaseHeap<T>.Size: BVectorIndex;
begin
  Result := FItems.Count;
end;

{ BMaxHeap<T> }

constructor BMaxHeap<T>.Create(AComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
  ADeleter: BUnaryProc<BVector<T>.It>; ATToString: BUnaryFunc<BVector<T>.It, BStr>);
begin
  inherited Create(AComparer, ADeleter, ATToString);
end;

function BMaxHeap<T>.Compare(ALeft, ARight: BVectorIndex): BBool;
begin
  Result := Comparer(FItems.Item[ALeft - 1], FItems.Item[ARight - 1]) > 0;
end;

{ BMinHeap<T> }

constructor BMinHeap<T>.Create(AComparer: BBinaryFunc<BVector<T>.It, BVector<T>.It, BInt32>;
  ADeleter: BUnaryProc<BVector<T>.It>; ATToString: BUnaryFunc<BVector<T>.It, BStr>);
begin
  inherited Create(AComparer, ADeleter, ATToString);
end;

function BMinHeap<T>.Compare(ALeft, ARight: BVectorIndex): BBool;
begin
  Result := Comparer(FItems.Item[ALeft - 1], FItems.Item[ARight - 1]) < 0;
end;

{$IFDEF TEST}
type
  BMinHeapTestCase = class(TTestCase)
  private
    MinHeap: BMinHeap<BInt32>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure DoPop;
  published
    procedure TestEmpty;
    procedure TestPush;
    procedure TestPop;
    procedure TestPopEmpty;
    procedure TestAll;
  end;

  { BMinHeapTestCase }
procedure BMinHeapTestCase.SetUp;
var
  Comparer: BBinaryFunc<BVector<BInt32>.It, BVector<BInt32>.It, BInt32>;
  TToString: BUnaryFunc<BVector<BInt32>.It, BStr>;
begin
  Comparer := function(ALeft, ARight: BVector<BInt32>.It): BInt32
    begin
      Result := ALeft^ - ARight^;
    end;
  TToString := function(AItem: BVector<BInt32>.It): BStr
    begin
      Result := BFormat('%d', [AItem^]);
    end;
  MinHeap := BMinHeap<BInt32>.Create(Comparer, nil, TToString);
end;

procedure BMinHeapTestCase.TearDown;
begin
  MinHeap.Free;
end;

procedure BMinHeapTestCase.DoPop;
begin
  MinHeap.Pop;
end;

procedure BMinHeapTestCase.TestEmpty;
begin
  CheckEquals(0, MinHeap.Size);
end;

procedure BMinHeapTestCase.TestPush;
begin
  CheckEquals(0, MinHeap.Size);
  MinHeap.Push(1);
  CheckEquals(1, MinHeap.Size);
end;

procedure BMinHeapTestCase.TestPop;
begin
  CheckEquals(0, MinHeap.Size);
  MinHeap.Push(5);
  CheckEquals(1, MinHeap.Size);
  CheckEquals(5, MinHeap.Pop);
end;

procedure BMinHeapTestCase.TestPopEmpty;
begin
  CheckEquals(0, MinHeap.Size);
  CheckException(DoPop, Exception);
end;

procedure BMinHeapTestCase.TestAll;
begin
  self.Status('TREE: ' + MinHeap.TreeToStr('   '));
  CheckEquals(0, MinHeap.Size);
  MinHeap.Push(10);
  MinHeap.Push(12);
  MinHeap.Push(19);
  MinHeap.Push(7);
  MinHeap.Push(3);
  MinHeap.Push(13);
  MinHeap.Push(15);
  CheckEquals(7, MinHeap.Size);
  CheckEquals(3, MinHeap.Pop);
  CheckEquals(7, MinHeap.Pop);
  CheckEquals(10, MinHeap.Pop);
  MinHeap.Push(5);
  MinHeap.Push(20);
  CheckEquals(5, MinHeap.Pop);
end;

initialization

TestFramework.RegisterTest('BMinHeap', BMinHeapTestCase.Suite);
{$ENDIF}

end.
