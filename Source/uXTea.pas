unit uXTea;

interface

uses
  uBTypes;

type
  TTeaMsgBlock = array [0 .. 1] of LongWord;
  TTeaKeyBlock = array [0 .. 3] of LongWord;

procedure XTeaCrypt(var V: TTeaMsgBlock; const K: TTeaKeyBlock);
procedure XTeaDecrypt(var V: TTeaMsgBlock; const K: TTeaKeyBlock);
function XTeaDecryptStr(const Msg, Pwd: BStr): BStr;
function XTeaCryptStr(const Msg, Pwd: BStr): BStr;

implementation

const
  DELTA = $61C88647;
  SUMDecrypt = $C6EF3720;
  N = 32;

function XTeaCryptStr(const Msg, Pwd: BStr): BStr;
var
  V: TTeaMsgBlock;
  K: TTeaKeyBlock;
  I, L, N: BInt32;
begin
  L := Length(Pwd);
  if L > SizeOf(K) then
    L := SizeOf(K);
  K[0] := 0;
  K[1] := 0;
  K[2] := 0;
  K[3] := 0;
  Move(Pwd[1], K[0], L);

  I := 1;
  L := Length(Msg);
  if L > 0 then
    SetLength(Result, ((L - 1) div SizeOf(V) + 1) * SizeOf(V))
  else
    SetLength(Result, 0);
  while I <= L do
  begin
    V[0] := 0;
    V[1] := 0;
    N := L - I + 1;
    if N > SizeOf(V) then
      N := SizeOf(V);
    Move(Msg[I], V[0], N);
    XTeaCrypt(V, K);
    Move(V[0], Result[I], SizeOf(V));
    Inc(I, SizeOf(V))
  end;
end;

function XTeaDecryptStr(const Msg, Pwd: BStr): BStr;
var
  V: TTeaMsgBlock;
  K: TTeaKeyBlock;
  I, L, N: BInt32;
begin
  L := Length(Pwd);
  if L > SizeOf(K) then
    L := SizeOf(K);
  K[0] := 0;
  K[1] := 0;
  K[2] := 0;
  K[3] := 0;
  Move(Pwd[1], K[0], L);

  I := 1;
  L := Length(Msg);
  if L > 0 then
    SetLength(Result, ((L - 1) div SizeOf(V) + 1) * SizeOf(V))
  else
    SetLength(Result, 0);
  while I <= L do
  begin
    V[0] := 0;
    V[1] := 0;
    N := L - I + 1;
    if N > SizeOf(V) then
      N := SizeOf(V);
    Move(Msg[I], V[0], N);
    XTeaDecrypt(V, K);
    Move(V[0], Result[I], SizeOf(V));
    Inc(I, SizeOf(V))
  end;
end;

procedure XTeaCrypt(var V: TTeaMsgBlock; const K: TTeaKeyBlock);
var
  I: LongWord;
  S: Int64;
begin
  S := 0;
  for I := 0 to N - 1 do
  begin
    Inc(V[0], ((V[1] shl 4 xor V[1] shr 5) + V[1]) xor (S + K[S and 3]));
    Dec(S, DELTA);
    Inc(V[1], ((V[0] shl 4 xor V[0] shr 5) + V[0]) xor (S + K[S shr 11 and 3]));
  end;
end;

procedure XTeaDecrypt(var V: TTeaMsgBlock; const K: TTeaKeyBlock);
var
  I: LongWord;
  S: Int64;
begin
  S := SUMDecrypt;
  for I := 0 to N - 1 do
  begin
    Dec(V[1], ((V[0] shl 4 xor V[0] shr 5) + V[0]) xor (S + K[S shr 11 and 3]));
    Inc(S, DELTA);
    Dec(V[0], ((V[1] shl 4 xor V[1] shr 5) + V[1]) xor (S + K[S and 3]));
  end;
end;

end.

