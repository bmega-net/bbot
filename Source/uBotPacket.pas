unit uBotPacket;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  uBTypes,
  SysUtils,
  Windows;

type
  TBBotPacketBInt8Array = array of BInt8;
  PBBotPacketBInt8Array = ^TBBotPacketBInt8Array;

  { TBBotPacket }
  TBBotPacket = class(TObject)
  private
    FSize: BUInt32;
    FPosition: BUInt32;
    function GetEOP: BBool;
    function GetBufferString: BStr;
  protected
    _Buffer: PBBotPacketBInt8Array;
    _Size: BUInt32;
    _FreeBuffer: BBool;
  public
    class function CreateReader(AFrom: BPtr; ASize: BUInt32): TBBotPacket;
    class function CreateWritter(ASize: BUInt32): TBBotPacket;
    class function CreateWritterEx(APointer: BPtr; ASize: BUInt32): TBBotPacket;
    class function CreateSharedMemory(Name: BStr; ASize: BUInt32): TBBotPacket;
    destructor Destroy; override;

    procedure SetReader(APointer: Pointer; ASize: BUInt32);

    property Buffer: PBBotPacketBInt8Array read _Buffer;
    property Size: BUInt32 read FSize write FSize;
    property Position: BUInt32 read FPosition write FPosition;
    property EOP: BBool read GetEOP;
    property BufferBStr: BStr read GetBufferString;

    procedure ReadBuffer(ABuffer: Pointer; ASize: BUInt32); inline;
    procedure WriteBuffer(ABuffer: Pointer; ASize: BUInt32); inline;

    function GetBInt8: BInt8;
    function GetBInt16: BInt16;
    function GetBUInt16: BUInt16;
    function GetBInt32: BInt32;
    function GetBUInt32: BUInt32;
    function GetBInt64: BInt64;
    function GetBStr16: BStr;
    function GetBStr32: BStr;
    function GetBFloat: BFloat;

    procedure WriteBInt8(Value: BInt8);
    procedure WriteBInt16(Value: BInt16);
    procedure WriteBInt32(Value: BInt32);
    procedure WriteBInt64(Value: Int64);
    procedure WriteBStr16(Value: BStr);
    procedure WriteBStr32(Value: BStr);
  end;

function CreateSharedMemory(AName: BStr; ASize: BUInt32): BPtr;

implementation

uses
  DateUtils,
  Math;

function CreateSharedMemory(AName: BStr; ASize: BUInt32): BPtr;
var
  Handle: BUInt32;
  SName: BStr;
begin
  SName := AName + #0;
  Handle := CreateFileMappingA($FFFFFFFF, nil, PAGE_READWRITE, 0, ASize,
    @SName[1]);
  if Handle = 0 then
    raise Exception.Create(String(BFormat('CSM Error 1 %d %s',
      [ASize, SName])));
  Result := MapViewOfFile(Handle, FILE_MAP_ALL_ACCESS, 0, 0, ASize);
  if Result = nil then
    raise Exception.Create(String(BFormat('CSM Error 2 %d %s',
      [ASize, SName])));
end;

{ TBBotPacket }

class function TBBotPacket.CreateReader(AFrom: BPtr; ASize: BUInt32)
  : TBBotPacket;
begin
  Result := TBBotPacket.Create;
  GetMem(Result._Buffer, ASize);
  Result._Size := ASize;
  Result.Size := ASize;
  Result.Position := 0;
  Result._FreeBuffer := True;
  Move(AFrom^, Result._Buffer^, ASize);
end;

class function TBBotPacket.CreateSharedMemory(Name: BStr; ASize: BUInt32)
  : TBBotPacket;
begin
  Result := TBBotPacket.Create;
  BPtr(Result._Buffer) := uBotPacket.CreateSharedMemory(Name, ASize);
  Result._Size := ASize;
  Result.Size := ASize;
  Result.Position := 0;
  Result._FreeBuffer := False;
end;

class function TBBotPacket.CreateWritter(ASize: BUInt32): TBBotPacket;
begin
  Result := TBBotPacket.Create;
  GetMem(Result._Buffer, ASize);
  Result._Size := ASize;
  Result.Size := 0;
  Result.Position := 0;
  Result._FreeBuffer := True;
end;

class function TBBotPacket.CreateWritterEx(APointer: Pointer; ASize: BUInt32)
  : TBBotPacket;
begin
  Result := TBBotPacket.Create;
  Result._Buffer := APointer;
  Result._Size := ASize;
  Result.Size := 0;
  Result.Position := 0;
  Result._FreeBuffer := False;
end;

destructor TBBotPacket.Destroy;
begin
  if _FreeBuffer then
    FreeMem(_Buffer);
  inherited;
end;

function TBBotPacket.GetBufferString: BStr;
const
  sHexChars: array [0 .. 15] of BChar = ('0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  I: BInt32;
  C: BPInt8;
begin
  Result := '';
  C := BPInt8(_Buffer);
  for I := 1 to Size do
  begin
    Result := Result + sHexChars[C^ div 16] + sHexChars[C^ mod 16] + ' ';
    Inc(C);
  end;
end;

function TBBotPacket.GetBUInt16: BUInt16;
begin
  ReadBuffer(@Result, 2);
end;

function TBBotPacket.GetBInt8: BInt8;
begin
  ReadBuffer(@Result, 1);
end;

function TBBotPacket.GetEOP: BBool;
begin
  Result := Position > _Size;
end;

function TBBotPacket.GetBInt64: BInt64;
begin
  ReadBuffer(@Result, 8);
end;

function TBBotPacket.GetBInt32: BInt32;
begin
  ReadBuffer(@Result, 4);
end;

function TBBotPacket.GetBUInt32: BUInt32;
begin
  ReadBuffer(@Result, 4);
end;

function TBBotPacket.GetBStr32: BStr;
var
  L: BInt32;
begin
  L := GetBInt32;
  if L > 0 then
  begin
    SetLength(Result, L);
    ReadBuffer(@Result[1], L);
  end;
end;

function TBBotPacket.GetBFloat: BFloat;
var
  A: BInt8;
  B: BInt32;
begin
  A := GetBInt8;
  B := GetBInt32;
  Result := (B - 2147483647) / Power(10, A);
end;

function TBBotPacket.GetBInt16: BInt16;
begin
  ReadBuffer(@Result, 2);
end;

function TBBotPacket.GetBStr16: BStr;
var
  L: BInt16;
begin
  L := GetBInt16;
  if L > 0 then
  begin
    SetLength(Result, L);
    ReadBuffer(@Result[1], L);
  end;
end;

procedure TBBotPacket.ReadBuffer(ABuffer: BPtr; ASize: BUInt32);
begin
  if (Position + ASize) > _Size then
  begin
    Position := Size + 1;
    Exit;
  end;
  Move(Pointer(BUInt32(_Buffer) + Position)^, ABuffer^, ASize);
  Position := Position + ASize;
end;

procedure TBBotPacket.SetReader(APointer: BPtr; ASize: BUInt32);
begin
  _Buffer := APointer;
  _Size := ASize;
  Size := ASize;
  Position := 0;
  _FreeBuffer := False;
end;

procedure TBBotPacket.WriteBuffer(ABuffer: BPtr; ASize: BUInt32);
begin
  if (Position + ASize) > _Size then
  begin
    Position := Size + 1;
    Exit;
  end;
  Move(ABuffer^, Pointer(BUInt32(_Buffer) + Position)^, ASize);
  Position := Position + ASize;
  Size := Size + ASize;
end;

procedure TBBotPacket.WriteBInt8(Value: BInt8);
begin
  WriteBuffer(@Value, 1);
end;

procedure TBBotPacket.WriteBInt64(Value: BInt64);
begin
  WriteBuffer(@Value, 8);
end;

procedure TBBotPacket.WriteBInt32(Value: BInt32);
begin
  WriteBuffer(@Value, 4);
end;

procedure TBBotPacket.WriteBStr32(Value: BStr);
begin
  WriteBInt32(Length(Value));
  if Length(Value) > 0 then
    WriteBuffer(@Value[1], Length(Value));
end;

procedure TBBotPacket.WriteBInt16(Value: BInt16);
begin
  WriteBuffer(@Value, 2);
end;

procedure TBBotPacket.WriteBStr16(Value: BStr);
begin
  WriteBInt16(Length(Value));
  if Length(Value) > 0 then
    WriteBuffer(@Value[1], Length(Value));
end;

end.

