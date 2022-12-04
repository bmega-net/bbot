unit uBase16and64;

interface

uses
  uBTypes,
  SysUtils;

function B16Encode(S: BStr): BStr;
function B16Decode(S: BStr): BStr;
function B64EncodeEx(const S: BStr): BStr;
function B64DecodeEx(const S: BStr): BStr;
function Base64Encode(const Value: BStr): BStr;
function Base64Decode(const Value: BStr): BStr;

implementation

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
  Codes16 = '0123456789ABCDEF';

function B16Encode(S: BStr): BStr;
var
  I: BInt32;
begin
  Result := '';
  for I := 1 to Length(S) do
    Result := Result + BStr(IntToHex(Byte(S[I]), 2));
end;

function B16Decode(S: BStr): BStr;
var
  I, N: BInt32;
  C, CN: BPChar;
  function B16ToChar: BInt32;
  var
    R: BInt32;
  begin
    Result := 0;
    R := AnsiPos(UpCase(C^), Codes16) - 1;
    if R > 0 then
      Result := R * 16;
    R := AnsiPos(UpCase(CN^), Codes16) - 1;
    if R > 0 then
      Inc(Result, R);
  end;

begin
  Result := '';
  if (Length(S) > 1) and ((Length(S) mod 2) = 0) then
  begin
    C := @S[1];
    CN := @S[2];
    N := Length(S) div 2;
    for I := 1 to N do
    begin
      Result := Result + BChar(B16ToChar);
      Inc(C, 2);
      Inc(CN, 2);
    end;
  end;
end;

function B64EncodeEx(const S: BStr): BStr;
var
  I: BInt32;
  a: BInt32;
  x: BInt32;
  b: BInt32;
begin
  Result := '';
  a := 0;
  b := 0;
  for I := 1 to Length(S) do
  begin
    x := Ord(S[I]);
    b := b * 256 + x;
    a := a + 8;
    while a >= 6 do
    begin
      a := a - 6;
      x := b div (1 shl a);
      b := b mod (1 shl a);
      Result := Result + Codes64[x + 1];
    end;
  end;
  if a > 0 then
  begin
    x := b shl (6 - a);
    Result := Result + Codes64[x + 1];
  end;
end;

function B64DecodeEx(const S: BStr): BStr;
var
  I: BInt32;
  a: BInt32;
  x: BInt32;
  b: BInt32;
begin
  Result := '';
  a := 0;
  b := 0;
  for I := 1 to Length(S) do
  begin
    x := AnsiPos(S[I], Codes64) - 1;
    if x >= 0 then
    begin
      b := b * 64 + x;
      a := a + 6;
      if a >= 8 then
      begin
        a := a - 8;
        x := b shr a;
        b := b mod (1 shl a);
        x := x mod 256;
        Result := Result + chr(x);
      end;
    end
    else
      Exit;
  end;
end;

const
  B64: array [0 .. 63] of Byte = (65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
    76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100,
    101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
    116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56,
    57, 43, 47);

function B64Encode(pInput: pointer; pOutput: pointer; Size: longint): longint;
var
  I, iptr, optr: BInt32;
  Input, Output: PByteArray;
begin
  Input := PByteArray(pInput);
  Output := PByteArray(pOutput);
  iptr := 0;
  optr := 0;
  for I := 1 to (Size div 3) do
  begin
    Output^[optr + 0] := B64[Input^[iptr] shr 2];
    Output^[optr + 1] := B64[((Input^[iptr] and 3) shl 4) +
      (Input^[iptr + 1] shr 4)];
    Output^[optr + 2] := B64[((Input^[iptr + 1] and 15) shl 2) +
      (Input^[iptr + 2] shr 6)];
    Output^[optr + 3] := B64[Input^[iptr + 2] and 63];
    Inc(optr, 4);
    Inc(iptr, 3);
  end;
  case (Size mod 3) of
    1:
      begin
        Output^[optr + 0] := B64[Input^[iptr] shr 2];
        Output^[optr + 1] := B64[(Input^[iptr] and 3) shl 4];
        Output^[optr + 2] := Byte('=');
        Output^[optr + 3] := Byte('=');
      end;
    2:
      begin
        Output^[optr + 0] := B64[Input^[iptr] shr 2];
        Output^[optr + 1] :=
          B64[((Input^[iptr] and 3) shl 4) + (Input^[iptr + 1] shr 4)];
        Output^[optr + 2] := B64[(Input^[iptr + 1] and 15) shl 2];
        Output^[optr + 3] := Byte('=');
      end;
  end;
  Result := ((Size + 2) div 3) * 4;
end;

function Base64Encode(const Value: BStr): BStr;
begin
  SetLength(Result, ((Length(Value) + 2) div 3) * 4);
  B64Encode(@Value[1], @Result[1], Length(Value));
end;

function B64Decode(pInput: pointer; pOutput: pointer; Size: longint): longint;
var
  I, j, iptr, optr: BInt32;
  Temp: array [0 .. 3] of Byte;
  Input, Output: PByteArray;
begin
  Input := PByteArray(pInput);
  Output := PByteArray(pOutput);
  iptr := 0;
  optr := 0;
  Result := 0;
  for I := 1 to (Size div 4) do
  begin
    for j := 0 to 3 do
    begin
      case Input^[iptr] of
        65 .. 90:
          Temp[j] := Input^[iptr] - Ord('A');
        97 .. 122:
          Temp[j] := Input^[iptr] - Ord('a') + 26;
        48 .. 57:
          Temp[j] := Input^[iptr] - Ord('0') + 52;
        43:
          Temp[j] := 62;
        47:
          Temp[j] := 63;
        61:
          Temp[j] := $FF;
      end;
      Inc(iptr);
    end;
    Output^[optr] := (Temp[0] shl 2) or (Temp[1] shr 4);
    Result := optr + 1;
    if (Temp[2] <> $FF) and (Temp[3] = $FF) then
    begin
      Output^[optr + 1] := (Temp[1] shl 4) or (Temp[2] shr 2);
      Result := optr + 2;
      Inc(optr)
    end
    else if (Temp[2] <> $FF) then
    begin
      Output^[optr + 1] := (Temp[1] shl 4) or (Temp[2] shr 2);
      Output^[optr + 2] := (Temp[2] shl 6) or Temp[3];
      Result := optr + 3;
      Inc(optr, 2);
    end;
    Inc(optr);
  end;
end;

function Base64Decode(const Value: BStr): BStr;
begin
  SetLength(Result, (Length(Value) div 4) * 3);
  SetLength(Result, B64Decode(@Value[1], @Result[1], Length(Value)));
end;

end.

