unit uBTypes;

interface

uses
  System.SysUtils, StrUtils;

{$IFNDEF Release}
{ .$DEFINE TestBLib }
{$ELSE}
{$DEFINE BTYPES_INLINE}
{$ENDIF}
type
  BException = class(Exception);

  {
    Datatypes
  }
  BPtr = Pointer;

  BBool = Boolean;
  BChar = AnsiChar;
  BInt8 = Byte;

  BInt16 = SmallInt;
  BUInt16 = Word;

  BInt32 = Integer;
  BUInt32 = Cardinal;

  BInt64 = Int64;
  BUInt64 = UInt64;

  BDbl = Double;
  BFloat = Single;
  BExtended = Extended;

  BStr = AnsiString;
  BStr32 = array [0 .. 31] of BChar;
  BStr64 = array [0 .. 63] of BChar;
  BStr255 = array [0 .. 255] of BChar;
  BStrArray = array of BStr;
  BBInt8Buffer = array of BInt8;

  {
    Pointer-To-Datatypes
  }
  BPPtr = ^BPtr;

  BPBool = ^BBool;
  BPChar = PAnsiChar;
  BPInt8 = ^BInt8;

  BPInt16 = ^BInt16;
  BPUInt16 = ^BUInt16;

  BPInt32 = ^BInt32;
  BPUInt32 = ^BUInt32;

  BPInt64 = ^BInt64;
  BPUInt64 = ^BUInt64;

  BPDbl = ^BDbl;
  BPFloat = ^BFloat;

  BPStr = ^BStr;

  {
    Template Methods
  }
  BPair<A, B> = record
    First: A;
    Second: B;
    procedure reset(const AFirst: A; const ASecond: B);
  end;

  BProc = reference to procedure;
  BFunc<R> = reference to function(): R;
  BUnaryProc<T> = reference to procedure(A: T);
  BUnaryFunc<T, R> = reference to function(A: T): R;
  BBinaryProc<T> = reference to procedure(A, B: T);
  BBinaryProc<T1, T2> = reference to procedure(A: T1; B: T2);
  BBinaryFunc<T, R> = reference to function(A, B: T): R;
  BBinaryFunc<T1, T2, R> = reference to function(A: T1; B: T2): R;
  BCompareFunc<T> = reference to function(A, B: T): BInt32;
  {
    Utils
  }

function BAbs(const AValue: BInt16): BInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BAbs(const AValue: BInt32): BInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BAbs(const AValue: BInt64): BInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BAbs(const AValue: BDbl): BDbl; overload; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BCeil(const AValue: BDbl): BInt32; overload;
function BCeil(const AValue: BFloat): BInt32; overload;

function BFloor(const AValue: BDbl): BInt32; overload;
function BFloor(const AValue: BFloat): BInt32; overload;

function BToPercent(const AValue, AMaxValue: BInt32): BFloat; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BToPercent(const AValue, AMaxValue: BUInt32): BFloat; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BToPercent(const AValue, AMaxValue: BInt64): BFloat; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BToPercent(const AValue, AMaxValue: BUInt64): BFloat; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BInt8): BInt8; overload; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BMin(const A, B: BInt16): BInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BUInt16): BUInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BInt32): BInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BUInt32): BUInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BInt64): BInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BUInt64): BUInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMin(const A, B: BDbl): BDbl; overload; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BMax(const A, B: BInt8): BInt8; overload; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BMax(const A, B: BInt16): BInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMax(const A, B: BUInt16): BUInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMax(const A, B: BInt32): BInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMax(const A, B: BUInt32): BUInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMax(const A, B: BInt64): BInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMax(const A, B: BUInt64): BUInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMax(const A, B: BDbl): BDbl; overload; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BMinMax(const AValue, AMin, AMax: BInt8): BInt8; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BInt16): BInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BUInt16): BUInt16; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BInt32): BInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BUInt32): BUInt32; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BInt64): BInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BUInt64): BUInt64; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BMinMax(const AValue, AMin, AMax: BDbl): BDbl; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BInt8): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BInt16): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BUInt16): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BInt32): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BUInt32): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BInt64): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BUInt64): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BInRange(const AValue, AMin, AMax: BDbl): BBool; overload;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BIntIn(const AValue: BInt8; const AValues: array of BInt8): BBool; overload;
function BIntIn(const AValue: BInt16; const AValues: array of BInt16): BBool; overload;
function BIntIn(const AValue: BUInt16; const AValues: array of BUInt16): BBool; overload;
function BIntIn(const AValue: BInt32; const AValues: array of BInt32): BBool; overload;
function BIntIn(const AValue: BUInt32; const AValues: array of BUInt32): BBool; overload;
function BIntIn(const AValue: BInt64; const AValues: array of BInt64): BBool; overload;
function BIntIn(const AValue: BUInt64; const AValues: array of BUInt64): BBool; overload;
function BIntIn(const AValue: BDbl; const AValues: array of BDbl): BBool; overload;

function BFormat(const APattern: BStr; const AArgs: array of const): BStr;

function BStrIsNumber(const AValue: BStr): BBool; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BStrTo8(const AValue: BStr): BInt8; overload;
function BStrTo8(const AValue: BStr; ADefault: BInt8): BInt8; overload;
function BStrTo16(const AValue: BStr): BInt16; overload;
function BStrTo16(const AValue: BStr; ADefault: BInt16): BInt16; overload;
function BStrTo32(const AValue: BStr): BInt32; overload;
function BStrTo32(const AValue: BStr; ADefault: BInt32): BInt32; overload;
function BStrToU16(const AValue: BStr): BUInt16; overload;
function BStrToU16(const AValue: BStr; ADefault: BUInt16): BUInt16; overload;
function BStrToU32(const AValue: BStr): BUInt32; overload;
function BStrToU32(const AValue: BStr; ADefault: BUInt32): BUInt32; overload;
function BStrTo64(const AValue: BStr): BInt64; overload;
function BStrTo64(const AValue: BStr; ADefault: BInt64): BInt64; overload;
function BStrToFloat(const AValue: BStr): BFloat; overload;
function BStrToFloat(const AValue: BStr; ADefault: BFloat): BFloat; overload;
function BToStr(const AValue: BBool): BStr; overload;
function BToStr(const AValue: BStr): BStr; overload;
function BToStr(const AValue: BInt8): BStr; overload;
function BToStr(const AValue: BInt16): BStr; overload;
function BToStr(const AValue: BInt32): BStr; overload;
function BToStr(const AValue: BInt64): BStr; overload;
function BToStr(const AValue: BFloat): BStr; overload;

function BIf(const ACondition: BBool; const ATrue, AFalse: BChar): BChar;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BStr): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BInt8): BInt8;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BInt16): BInt16;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BUInt16): BUInt16;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BInt32): BInt32;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BUInt32): BUInt32;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BInt64): BInt64;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BUInt64): BUInt64;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BIf(const ACondition: BBool; const ATrue, AFalse: BDbl): BDbl;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;

function BStrSplit(var ARes: BStrArray; const ADelimiter, ASubject: BStr): BInt32; overload;
function BStrSplit(const AText, ADelimiter: BStr; out ALeft, ARight: BStr): BBool; overload;
function BStrJoin(const ARes: BStrArray; const ADelimiter: BStr): BStr;
function BStrEqual(const ALeft, ARight: BStr): BBool;
function BStrEqualSensitive(const ALeft, ARight: BStr): BBool;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BTrim(const AText: BStr): BStr; {$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BStrLen(const AText: BStr): BInt32;
function BStrPos(const ASub, AText: BStr): BInt32; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF} overload;
function BStrPos(const ASub, AText: BStr; const AOffset: BInt32): BInt32;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BStrCopy(const AText: BStr; const AFrom, ACount: BInt32): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BStrLeft(const AText: BStr; const ACount: BInt32): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BStrLeft(const AText, ADelimiter: BStr): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BStrRight(const AText: BStr; const ACount: BInt32): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BStrRight(const AText, ADelimiter: BStr): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BStrBetween(const AText, AFrom, ATo: BStr): BStr;
function BStrStart(const AText, AWith: BStr): BBool;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BStrStartSensitive(const AText, AWith: BStr): BBool;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BStrEnd(const AText, AWith: BStr): BBool; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BStrEndSensitive(const AText, AWith: BStr): BBool;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
function BStrLower(const AText: BStr): BStr;
function BStrUpper(const AText: BStr): BStr;
function BStrReplace(const AText, AFrom, ATo: BStr): BStr;
function BStrReplaceSensitive(const AText, AFrom, ATo: BStr): BStr;
function BStrFromBuffer8(const ABuffer: BPInt8; const ASize: BInt32): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF}
procedure BCopy(const AFrom, ATo: BPtr; ALen: BInt32);

function BRandom(const AMin, AMax: BInt32): BInt32;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BRandom(const AMin, AMax: BUInt32): BUInt32;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;
function BRandom(const AMax: BInt32): BInt32; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF} overload;
function BRandom(const AMax: BUInt32): BUInt32; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF} overload;
function BStrRandom(const ALen: BUInt32; ACharacters: BStr): BStr;
{$IFDEF BTYPES_INLINE}inline; {$ENDIF} overload;

procedure BFilePut(const AFile, AData: BStr); {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
procedure BFileAppend(const AFile, AData: BStr); {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BFileGet(const AFile: BStr): BStr; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BFileExists(const AFile: BStr): BBool; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
procedure BFileDelete(const AFile: BStr);

function BDateToStr(ADate: TDateTime): BStr; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BStrToDate(ADate: BStr): TDateTime; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BThread(const AMethod, AParam: BPtr): BUInt32; overload;
function BThread(const AMethod: BProc): BUInt32; overload;

procedure BConsoleCreate;

procedure BConsoleFree;

function Tick: BUInt32;
procedure SetTick;

{$IFDEF Debug}
procedure OutputDebugMessage(AText: BStr);
procedure BOutputDebugMessage(AText: BStr);
{$ENDIF}

const
  BStrLine: BStr = #13#10;
  BStrAbcUpper: BStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BStrAbcLower: BStr = 'abcdefghijklmnopqrstuvwxyz';
  BStrDigits: BStr = '0123456789';
  BStrAlpha: BStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  BStrAlphaNumeric: BStr = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  BStrHexadecimal: array [0 .. 15] of BChar = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D',
    'E', 'F');

type
  {
    Compound Types
  }
  BPos = record
    Z: BInt32;
    Y: BInt32;
    X: BInt32;
    class operator Equal(const ALeft, ARight: BPos): BBool;
    class operator NotEqual(const ALeft, ARight: BPos): BBool;
    class operator LessThan(const ALeft, ARight: BPos): BBool;
    class operator LessThanOrEqual(const ALeft, ARight: BPos): BBool;
    class operator GreaterThan(const ALeft, ARight: BPos): BBool;
    class operator GreaterThanOrEqual(const ALeft, ARight: BPos): BBool;
    class operator Explicit(const AValue: BPos): BStr;
    class operator Explicit(const AValue: BStr): BPos;
    procedure change(const AX, AY, AZ: BInt32);
    procedure zero();
    function isZero(): BBool;
  end;

  BPPos = ^BPos;

function BPosXYZ(const AX, AY, AZ: BInt32): BPos; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
function BPos0(): BPos; {$IFDEF BTYPES_INLINE}inline;
{$ENDIF}
type
  BLock = class
  private
    FVariation: BUInt32;
    FDelay: BUInt32;
    FNext: BUInt32;
    function GetLocked: BBool;
    function GetRemaining: BUInt32;
    function GetUnLocked: BBool;
  public
    constructor Create(const ADelay, AVariation: BUInt32); overload;
    constructor Create(const ADelay: BUInt32; AVariationRatio: BFloat); overload;

    property Delay: BUInt32 read FDelay write FDelay;
    property Variation: BUInt32 read FVariation write FVariation;
    property Next: BUInt32 read FNext;
    property Remaining: BUInt32 read GetRemaining;

    property Locked: BBool read GetLocked;
    property UnLocked: BBool read GetUnLocked;

    procedure Lock(const ACustomDelay: BUInt32); overload;
    procedure Lock(const ALocker: BLock); overload;
    procedure Lock; overload;
    procedure UnLock;
  end;

  BOptional<T> = record
  private
    FValue: T;
    FHasValue: BBool;
  public
    property HasValue: BBool read FHasValue;
    property Value: T read FValue;

    function ifPresent(const fn: BUnaryProc<T>): BOptional<T>;
    function orElse(const fn: BProc): BOptional<T>;
    function getOrDefault(const ADefault: T): T;
    function getOrGenerate(const AGenerator: BFunc<T>): T;

    class function from(const AValue: T): BOptional<T>; static;
    class function none(): BOptional<T>; static;
    class operator Implicit(const AValue: T): BOptional<T>;
  end;


implementation

uses
  Windows,
  Math{$IFDEF TEST},
  TestFramework{$ENDIF},
  DateUtils;

var
  FCurrentTick: BUInt32;

{$WARN IMPLICIT_STRING_CAST OFF}

function BAbs(const AValue: BInt16): BInt16;
begin
  Result := Abs(AValue);
end;

function BAbs(const AValue: BInt32): BInt32;
begin
  Result := Abs(AValue);
end;

function BAbs(const AValue: BInt64): BInt64;
begin
  Result := Abs(AValue);
end;

function BAbs(const AValue: BDbl): BDbl;
begin
  Result := Abs(AValue);
end;

function BCeil(const AValue: BDbl): BInt32;
begin
  Result := Ceil(AValue);
end;

function BCeil(const AValue: BFloat): BInt32;
begin
  Result := Ceil(AValue);
end;

function BFloor(const AValue: BDbl): BInt32;
begin
  Result := Floor(AValue);
end;

function BFloor(const AValue: BFloat): BInt32;
begin
  Result := Floor(AValue);
end;

function BToPercent(const AValue, AMaxValue: BInt32): BFloat;
begin
  if (AValue > 0) and (AMaxValue > 0) then
    Result := (AValue / AMaxValue) * 100
  else
    Result := 0;
end;

function BToPercent(const AValue, AMaxValue: BUInt32): BFloat;
begin
  if (AValue > 0) and (AMaxValue > 0) then
    Result := (AValue / AMaxValue) * 100
  else
    Result := 0;
end;

function BToPercent(const AValue, AMaxValue: BInt64): BFloat;
begin
  if (AValue > 0) and (AMaxValue > 0) then
    Result := (AValue / AMaxValue) * 100
  else
    Result := 0;
end;

function BToPercent(const AValue, AMaxValue: BUInt64): BFloat;
begin
  if (AValue > 0) and (AMaxValue > 0) then
    Result := (AValue / AMaxValue) * 100
  else
    Result := 0;
end;

function BMin(const A, B: BInt8): BInt8;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BInt16): BInt16;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BUInt16): BUInt16;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BInt32): BInt32;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BUInt32): BUInt32;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BInt64): BInt64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BUInt64): BUInt64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMin(const A, B: BDbl): BDbl;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BInt8): BInt8;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BInt16): BInt16;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BUInt16): BUInt16;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BInt32): BInt32;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BUInt32): BUInt32;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BInt64): BInt64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BUInt64): BUInt64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMax(const A, B: BDbl): BDbl;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function BMinMax(const AValue, AMin, AMax: BInt8): BInt8;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BInt16): BInt16;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BUInt16): BUInt16;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BInt32): BInt32;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BUInt32): BUInt32;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BInt64): BInt64;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BUInt64): BUInt64;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BMinMax(const AValue, AMin, AMax: BDbl): BDbl;
begin
  if AValue < AMin then
    Result := AMin
  else if AValue > AMax then
    Result := AMax
  else
    Result := AValue;
end;

function BInRange(const AValue, AMin, AMax: BInt8): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BInt16): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BUInt16): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BInt32): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BUInt32): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BInt64): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BUInt64): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BInRange(const AValue, AMin, AMax: BDbl): BBool;
begin
  Result := (AValue >= AMin) and (AValue <= AMax)
end;

function BIntIn(const AValue: BInt8; const AValues: array of BInt8): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BInt16; const AValues: array of BInt16): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BUInt16; const AValues: array of BUInt16): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BInt32; const AValues: array of BInt32): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BUInt32; const AValues: array of BUInt32): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BInt64; const AValues: array of BInt64): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BUInt64; const AValues: array of BUInt64): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BIntIn(const AValue: BDbl; const AValues: array of BDbl): BBool;
var
  I: BInt32;
begin
  for I := Low(AValues) to High(AValues) do
    if AValues[I] = AValue then
      Exit(True);
  Result := False;
end;

function BFormat(const APattern: BStr; const AArgs: array of const): BStr;
begin
  Result := BStr(Format(StringReplace(String(APattern), '\n', BStrLine, [rfReplaceAll]), AArgs));
end;

function BStrIsNumber(const AValue: BStr): BBool;
var
  I: BInt32;
begin
  if Length(AValue) = 0 then
    Exit(False);
  for I := 1 to Length(AValue) do
    if (not(AValue[I] in ['0' .. '9'])) then // TEST SET VARIABLES WITH NEGATIVES?!
      Exit(False);
  Result := True;
end;

function BStrTo8(const AValue: BStr): BInt8;
begin
  Result := BInt8(StrToInt(Trim(AValue)));
end;

function BStrTo8(const AValue: BStr; ADefault: BInt8): BInt8;
begin
  Result := BInt8(StrToIntDef(Trim(AValue), ADefault));
end;

function BStrTo16(const AValue: BStr): BInt16;
begin
  Result := BInt16(StrToInt(Trim(AValue)));
end;

function BStrTo16(const AValue: BStr; ADefault: BInt16): BInt16;
begin
  Result := BInt16(StrToIntDef(Trim(AValue), ADefault));
end;

function BStrTo32(const AValue: BStr): BInt32;
begin
  Result := StrToInt(Trim(AValue));
end;

function BStrTo32(const AValue: BStr; ADefault: BInt32): BInt32;
begin
  Result := StrToIntDef(Trim(AValue), ADefault);
end;

function BStrToU16(const AValue: BStr): BUInt16;
begin
  Result := StrToInt(Trim(AValue));
end;

function BStrToU16(const AValue: BStr; ADefault: BUInt16): BUInt16;
begin
  Result := StrToIntDef(Trim(AValue), ADefault);
end;

function BStrToU32(const AValue: BStr): BUInt32;
begin
  Result := StrToInt(Trim(AValue));
end;

function BStrToU32(const AValue: BStr; ADefault: BUInt32): BUInt32;
begin
  Result := StrToIntDef(Trim(AValue), ADefault);
end;

function BStrTo64(const AValue: BStr): BInt64;
begin
  Result := StrToInt64(Trim(AValue));
end;

function BStrTo64(const AValue: BStr; ADefault: BInt64): BInt64;
begin
  Result := StrToInt64Def(Trim(AValue), ADefault);
end;

function BStrToFloat(const AValue: BStr): BFloat;
begin
  Result := StrToFloat(Trim(AValue));
end;

function BStrToFloat(const AValue: BStr; ADefault: BFloat): BFloat; overload;
begin
  Result := StrToFloatDef(Trim(AValue), ADefault);
end;

function BToStr(const AValue: BBool): BStr; overload;
begin
  Exit(BIf(AValue, 'True', 'False'));
end;

function BToStr(const AValue: BStr): BStr; overload;
begin
  Exit(AValue);
end;

function BToStr(const AValue: BInt8): BStr; overload;
begin
  Exit(BFormat('%d', [AValue]));
end;

function BToStr(const AValue: BInt16): BStr; overload;
begin
  Exit(BFormat('%d', [AValue]));
end;

function BToStr(const AValue: BInt32): BStr; overload;
begin
  Exit(BFormat('%d', [AValue]));
end;

function BToStr(const AValue: BInt64): BStr; overload;
begin
  Exit(BFormat('%d', [AValue]));
end;

function BToStr(const AValue: BFloat): BStr; overload;
begin
  Exit(BFormat('%f', [AValue]));
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BChar): BChar;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BStr): BStr;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BInt8): BInt8;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BInt16): BInt16;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BUInt16): BUInt16;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BInt32): BInt32;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BUInt32): BUInt32;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BInt64): BInt64;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BUInt64): BUInt64;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BIf(const ACondition: BBool; const ATrue, AFalse: BDbl): BDbl;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

function BStrSplit(var ARes: BStrArray; const ADelimiter, ASubject: BStr): BInt32;
var
  S2: BStr;
begin
  Result := 0;
  S2 := ASubject + ADelimiter;
  repeat
    SetLength(ARes, Result + 1);
    ARes[Result] := BStrCopy(S2, 0, BStrPos(ADelimiter, S2) - 1);
    Delete(S2, 1, BStrLen(ARes[Result] + ADelimiter));
    ARes[Result] := BTrim(ARes[Result]);
    Inc(Result);
  until S2 = '';
end;

function BStrSplit(const AText, ADelimiter: BStr; out ALeft, ARight: BStr): BBool;
var
  P: BInt32;
begin
  P := BStrPos(ADelimiter, AText);
  if P > 0 then begin
    ALeft := BStrCopy(AText, 1, P - 1);
    ARight := BStrCopy(AText, P + BStrLen(ADelimiter), BStrLen(AText) - BStrLen(ADelimiter) - P + 1);
    ALeft := BTrim(ALeft);
    ARight := BTrim(ARight);
    Result := True;
  end
  else
    Result := False;
end;

function BStrJoin(const ARes: BStrArray; const ADelimiter: BStr): BStr;
var
  I: BInt32;
begin
  Result := '';
  for I := Low(ARes) to High(ARes) do begin
    if Result <> '' then
      Result := Result + ADelimiter;
    Result := Result + ARes[I];
  end;
end;

function BStrEqual(const ALeft, ARight: BStr): BBool;
begin
  Result := AnsiSameText(BStr(ALeft), BStr(ARight));
end;

function BStrEqualSensitive(const ALeft, ARight: BStr): BBool;
begin
  Result := ALeft = ARight;
end;

function BTrim(const AText: BStr): BStr;
begin
  Result := BStr(Trim(String(AText)));
end;

function BStrLen(const AText: BStr): BInt32;
begin
  Result := Length(AText);
end;

function BStrPos(const ASub, AText: BStr): BInt32;
begin
  Result := Pos(ASub, AText);
end;

function BStrPos(const ASub, AText: BStr; const AOffset: BInt32): BInt32;
begin
  Result := PosEx(ASub, AText, AOffset);
end;

function BStrCopy(const AText: BStr; const AFrom, ACount: BInt32): BStr;
begin
  Result := Copy(AText, AFrom, ACount);
end;

function BStrLeft(const AText: BStr; const ACount: BInt32): BStr;
begin
  Result := BStrCopy(AText, 1, ACount);
end;

function BStrLeft(const AText, ADelimiter: BStr): BStr;
begin
  Result := BStrCopy(AText, 1, BStrPos(ADelimiter, AText) - 1);
end;

function BStrRight(const AText: BStr; const ACount: BInt32): BStr;
begin
  Result := BStrCopy(AText, BStrLen(AText) + 1 - ACount, ACount);
end;

function BStrRight(const AText, ADelimiter: BStr): BStr;
var
  P: BInt32;
begin
  P := BStrPos(ADelimiter, AText);
  Result := BStrCopy(AText, P + BStrLen(ADelimiter), BStrLen(AText) + 1 - BStrLen(ADelimiter) - P);
end;

function BStrBetween(const AText, AFrom, ATo: BStr): BStr;
var
  PFrom, PTo: BInt32;
begin
  PFrom := BStrPos(AFrom, AText) + BStrLen(AFrom);
  PTo := BStrPos(ATo, AText, PFrom);
  if (PFrom > 0) and (PTo > 0) then begin
    Result := BStrCopy(AText, PFrom, PTo - PFrom);
  end
  else
    Result := '';
end;

function BStrStart(const AText, AWith: BStr): BBool;
begin
  Result := BStrEqual(BStrLeft(AText, Length(AWith)), AWith);
end;

function BStrStartSensitive(const AText, AWith: BStr): BBool;
begin
  Result := BStrEqualSensitive(BStrLeft(AText, Length(AWith)), AWith);
end;

function BStrEnd(const AText, AWith: BStr): BBool;
begin
  Result := BStrEqual(BStrRight(AText, Length(AWith)), AWith);
end;

function BStrEndSensitive(const AText, AWith: BStr): BBool;
begin
  Result := BStrEqualSensitive(BStrRight(AText, Length(AWith)), AWith);
end;

function BStrLower(const AText: BStr): BStr;
begin
  Result := BStr(LowerCase(AText));
end;

function BStrUpper(const AText: BStr): BStr;
begin
  Result := BStr(UpperCase(AText));
end;

function BStrReplace(const AText, AFrom, ATo: BStr): BStr;
begin
  Result := BStr(StringReplace(AText, AFrom, ATo, [rfReplaceAll, rfIgnoreCase]));
end;

function BStrReplaceSensitive(const AText, AFrom, ATo: BStr): BStr;
begin
  Result := BStr(StringReplace(AText, AFrom, ATo, [rfReplaceAll]));
end;

function BStrFromBuffer8(const ABuffer: BPInt8; const ASize: BInt32): BStr;
var
  I: BInt32;
  B: BPInt8;
begin
  SetLength(Result, ASize * 3);
  B := ABuffer;
  for I := 1 to ASize do begin
    Result[(I * 3) - 2] := BStrHexadecimal[B^ div 16];
    Result[(I * 3) - 1] := BStrHexadecimal[B^ mod 16];
    Result[(I * 3)] := ' ';
    Inc(B);
  end;
end;

procedure BCopy(const AFrom, ATo: BPtr; ALen: BInt32);
begin
  CopyMemory(ATo, AFrom, ALen);
end;

function BRandom(const AMin, AMax: BInt32): BInt32;
begin
  if AMin > AMax then begin
    Result := BRandom(AMax, AMin);
    Exit;
  end;
  Result := AMin + ((Random(MaxInt)) mod (AMax - AMin + 1));
  if Result = AMin then
    Randomize;
end;

function BRandom(const AMin, AMax: BUInt32): BUInt32;
begin
  Result := BUInt32(BRandom(BInt32(AMin), BInt32(AMax)));
end;

function BRandom(const AMax: BInt32): BInt32;
begin
  Result := BRandom(0, AMax);
end;

function BRandom(const AMax: BUInt32): BUInt32;
begin
  Result := BRandom(0, AMax);
end;

function BStrRandom(const ALen: BUInt32; ACharacters: BStr): BStr;
var
  I: BInt32;
begin
  Result := '';
  for I := 1 to ALen do
    Result := Result + ACharacters[BRandom(1, BStrLen(ACharacters))];
end;

procedure BFilePut(const AFile, AData: BStr);
var
  F: TextFile;
begin
  AssignFile(F, String(AFile));
  Rewrite(F);
  Write(F, AData);
  CloseFile(F);
end;

procedure BFileAppend(const AFile, AData: BStr);
var
  F: TextFile;
begin
  AssignFile(F, String(AFile));
  if BFileExists(AFile) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, AData);
  CloseFile(F);
end;

function BFileGet(const AFile: BStr): BStr;
var
  F: TextFile;
  L: BStr;
begin
  Result := '';
  if BFileExists(AFile) then begin
    AssignFile(F, String(AFile));
    reset(F);
    while not EOF(F) do begin
      ReadLn(F, L);
      if Result <> '' then
        Result := Result + BStrLine;
      Result := Result + L;
    end;
    CloseFile(F);
  end;
end;

function BFileExists(const AFile: BStr): BBool;
begin
  Result := FileExists(String(AFile));
end;

procedure BFileDelete(const AFile: BStr);
begin
  DeleteFileA(@AFile[1]);
end;

function BThread(const AMethod, AParam: BPtr): BUInt32;
begin
  CreateThread(nil, 0, AMethod, AParam, 0, Result);
end;

type
  BProcHolder = record
    Method: BProc;
  end;

  BPProcHolder = ^BProcHolder;

procedure BThreadRunBProc(const AMethod: BPProcHolder); stdcall;
begin
  AMethod.Method();
  Dispose(AMethod);
end;

function BThread(const AMethod: BProc): BUInt32;
var
  Holder: BPProcHolder;
begin
  New(Holder);
  Holder^.Method := AMethod;
  Exit(BThread(@BThreadRunBProc, Holder));
end;

procedure BConsoleCreate;
begin
  AllocConsole;
end;

procedure BConsoleFree;
begin
  FreeConsole;
end;

function Tick: BUInt32;
begin
{$IFNDEF DEBUG}
  SetTick;
{$ENDIF}
  Result := FCurrentTick;
end;

procedure SetTick;
begin
  FCurrentTick := GetTickCount;
end;

function BDateToStr(ADate: TDateTime): BStr;
begin
  Result := BStr(FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz', ADate));
end;

function BStrToDate(ADate: BStr): TDateTime;
var
  DY, DM, DD, TH, TM, TS, MS: BUInt16;
  SD, ST: BStr;
  R: BStrArray;
begin
  BStrSplit(BTrim(ADate), ' ', SD, ST);
  BStrSplit(R, '-', SD);
  DY := BStrTo16(R[0]);
  DM := BStrTo16(R[1]);
  DD := BStrTo16(R[2]);
  BStrSplit(R, ':', ST);
  TH := BStrTo16(R[0]);
  TM := BStrTo16(R[1]);
  TS := BStrTo16(R[2]);
  MS := BStrTo16(R[3]);
  Result := EncodeDateTime(DY, DM, DD, TH, TM, TS, MS);
end;

{$IFDEF Debug}

procedure OutputDebugMessage(AText: BStr);
begin
  if AText <> '' then
    OutputDebugStringA(@AText[1]);
end;

procedure BOutputDebugMessage(AText: BStr);
begin
  OutputDebugMessage(AText);
end;

{$ENDIF}
{ BPos }

procedure BPos.change(const AX, AY, AZ: BInt32);
begin
  X := AX;
  Y := AY;
  Z := AZ;
end;

function BPos.isZero: BBool;
begin
  Exit((X = 0) and (Y = 0) and (Z = 0));
end;


class operator BPos.Equal(const ALeft, ARight: BPos): BBool;
begin
  Result := (ALeft.X = ARight.X) and (ALeft.Y = ARight.Y) and (ALeft.Z = ARight.Z);
end;

class operator BPos.NotEqual(const ALeft, ARight: BPos): BBool;
begin
  Result := not(ALeft = ARight);
end;

procedure BPos.zero;
begin
  change(0, 0, 0);
end;

class operator BPos.Explicit(const AValue: BPos): BStr;
begin
  Result := BFormat('%d %d %d', [AValue.X, AValue.Y, AValue.Z]);
end;

class operator BPos.Explicit(const AValue: BStr): BPos;
var
  R: BStrArray;
begin
  if BStrSplit(R, ' ', AValue) = 3 then begin
    try
      Result.X := BStrTo32(R[0]);
      Result.Y := BStrTo32(R[1]);
      Result.Z := BStrTo32(R[2]);
    except raise Exception.Create('Invalid BPos(BStr) format numbers');
    end;
  end
  else
    raise Exception.Create('Invalid BPos(BStr) format size');
end;

class operator BPos.GreaterThan(const ALeft, ARight: BPos): BBool;
begin
  Result := ARight < ALeft;
end;

class operator BPos.GreaterThanOrEqual(const ALeft, ARight: BPos): BBool;
begin
  Result := not(ALeft < ARight);
end;

class operator BPos.LessThan(const ALeft, ARight: BPos): BBool;
begin
  Result := (ALeft.Z < ARight.Z) or (ALeft.Y < ARight.Y) or (ALeft.X < ARight.X);
end;

class operator BPos.LessThanOrEqual(const ALeft, ARight: BPos): BBool;
begin
  Result := not(ARight < ALeft);
end;

function BPosXYZ(const AX, AY, AZ: BInt32): BPos;
begin
  Result.X := AX;
  Result.Y := AY;
  Result.Z := AZ;
end;

function BPos0(): BPos;
begin
  Result.zero;
end;

{ BPair<A, B> }

procedure BPair<A, B>.reset(const AFirst: A; const ASecond: B);
begin
  First := AFirst;
  Second := ASecond;
end;

{ BLock }

function BLock.GetLocked: BBool;
begin
  Result := Remaining <> 0;
end;

function BLock.GetRemaining: BUInt32;
begin
  if FNext > Tick then
    Result := FNext - Tick
  else
    Result := 0;
end;

function BLock.GetUnLocked: BBool;
begin
  Result := not Locked;
end;

constructor BLock.Create(const ADelay, AVariation: BUInt32);
begin
  FNext := 0;
  FDelay := ADelay;
  FVariation := AVariation;
end;

constructor BLock.Create(const ADelay: BUInt32; AVariationRatio: BFloat);
begin
  FNext := 0;
  FDelay := ADelay;
  FVariation := BFloor(ADelay * AVariationRatio);
end;

procedure BLock.Lock;
begin
  Lock(FDelay);
end;

procedure BLock.Lock(const ALocker: BLock);
begin
  FNext := ALocker.FNext;
end;

procedure BLock.Lock(const ACustomDelay: BUInt32);
begin
  FNext := Tick + ACustomDelay + BUInt32(BRandom(0, ACustomDelay * FVariation) div 100);
end;

procedure BLock.UnLock;
begin
  FNext := 0;
end;

{$IFDEF TEST}
type
  BTypesTestCase = class(TTestCase)
  published
    procedure TestBAbs;
    procedure TestBCeil;
    procedure TestBFloor;
    procedure TestBToPercent;
    procedure TestBMin;
    procedure TestBMax;
    procedure TestBMinMax;
    procedure TestBInRange;
    procedure TestBIntIn;
    procedure TestBFormat;
    procedure TestBStrIsNumber;
    procedure TestStrTo;
  end;

procedure BTypesTestCase.TestBAbs;
begin
  CheckEquals(1, BAbs(BInt16(1)));
  CheckEquals(1, BAbs(BInt16(-1)));
  CheckEquals(0, BAbs(BInt16(0)));

  CheckEquals(1, BAbs(BInt32(1)));
  CheckEquals(1, BAbs(BInt32(-1)));
  CheckEquals(0, BAbs(BInt32(0)));

  CheckEquals(1, BAbs(BInt64(1)));
  CheckEquals(1, BAbs(BInt64(-1)));
  CheckEquals(0, BAbs(BInt64(0)));

  CheckEquals(1.0, BAbs(1.0));
  CheckEquals(1.0, BAbs(-1.0));
  CheckEquals(0.0, BAbs(0.0));
end;

procedure BTypesTestCase.TestBCeil;
begin
  CheckEquals(5.0, BCeil(5.0));
  CheckEquals(6.0, BCeil(5.2));
  CheckEquals(6.0, BCeil(5.8));
end;

procedure BTypesTestCase.TestBFloor;
begin
  CheckEquals(5.0, BFloor(5.0));
  CheckEquals(5.0, BFloor(5.2));
  CheckEquals(5.0, BFloor(5.8));
end;

procedure BTypesTestCase.TestBToPercent;
begin
  CheckEquals(100, BToPercent(100, 100));
  CheckEquals(50, BToPercent(50, 100));
  CheckEquals(75, BToPercent(75, 100));
end;

procedure BTypesTestCase.TestBMin;
begin
  CheckEquals(100, BMin(100, 200));
  CheckEquals(200, BMin(300, 200));
end;

procedure BTypesTestCase.TestBMax;
begin
  CheckEquals(200, BMax(100, 200));
  CheckEquals(300, BMax(300, 200));
end;

procedure BTypesTestCase.TestBMinMax;
begin
  CheckEquals(50, BMinMax(50, 40, 60));
  CheckEquals(40, BMinMax(40, 40, 60));
  CheckEquals(60, BMinMax(60, 40, 60));
  CheckEquals(40, BMinMax(20, 40, 60));
  CheckEquals(60, BMinMax(80, 40, 60));
end;

procedure BTypesTestCase.TestBInRange;
begin
  CheckTrue(BInRange(5, 3, 8));
  CheckTrue(BInRange(3, 3, 8));
  CheckTrue(BInRange(8, 3, 8));
  CheckFalse(BInRange(10, 3, 8));
  CheckFalse(BInRange(2, 3, 8));
end;

procedure BTypesTestCase.TestBIntIn;
begin
  CheckTrue(BIntIn(5, [5, 8, 10, 13]));
  CheckFalse(BIntIn(3, [5, 8, 10, 13]));
end;

procedure BTypesTestCase.TestBFormat;
begin
  CheckEqualsString('Hello 5 World' + BStrLine + 'Abc * 2,00', BFormat('Hello %d %s\nAbc * %f', [5, 'World', 2.0]));
end;

procedure BTypesTestCase.TestBStrIsNumber;
begin
  CheckTrue(BStrIsNumber('1'));
  CheckTrue(BStrIsNumber('0'));
  CheckTrue(BStrIsNumber('100'));
  CheckTrue(BStrIsNumber('000'));
  CheckFalse(BStrIsNumber(''));
  CheckFalse(BStrIsNumber('-1'));
  CheckFalse(BStrIsNumber('A'));
  CheckFalse(BStrIsNumber('0b'));
  CheckFalse(BStrIsNumber('c0'));
end;

procedure BTypesTestCase.TestStrTo;
begin
  CheckEquals(1, BStrTo8('1'));
  CheckEquals(2, BStrTo16('2'));
  CheckEquals(3, BStrTo32('3'));
  CheckEquals(4, BStrTo64('4'));
  CheckEquals(-5, BStrTo16('-5'));
  CheckEquals(-6, BStrTo32('-6'));
  CheckEquals(-7, BStrTo64('-7'));
  CheckEquals(-80, BStrTo16('-80'));
  CheckEquals(900, BStrTo32('900'));
  CheckEquals(5.0, BStrToFloat('5,0'));
  CheckEquals(-5.0, BStrToFloat('-5,0'));
end;
{$ENDIF}
{$WARN IMPLICIT_STRING_CAST ON}

{ BOptional<T> }

class function BOptional<T>.from(const AValue: T): BOptional<T>;
begin
  Result.FValue := AValue;
  Result.FHasValue := True;
end;

class function BOptional<T>.none: BOptional<T>;
begin
  Result.FHasValue := False;
end;

function BOptional<T>.ifPresent(const fn: BUnaryProc<T>): BOptional<T>;
begin
  if HasValue then
    fn(Value);
  Exit(Self);
end;

function BOptional<T>.getOrDefault(const ADefault: T): T;
begin
  if HasValue then
    Exit(Value);
  Exit(ADefault);
end;

function BOptional<T>.getOrGenerate(const AGenerator: BFunc<T>): T;
begin
  if HasValue then
    Exit(Value);
  Exit(AGenerator());
end;

class operator BOptional<T>.Implicit(const AValue: T): BOptional<T>;
begin
  Exit(BOptional<T>.from(AValue));
end;

function BOptional<T>.orElse(const fn: BProc): BOptional<T>;
begin
  if not HasValue then
    fn();
  Exit(Self);
end;

initialization

Randomize;
{$IFDEF TEST}
TestFramework.RegisterTest('BTypes', BTypesTestCase.Suite);
{$ENDIF}

end.
