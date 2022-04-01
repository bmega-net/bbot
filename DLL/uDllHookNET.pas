unit uDllHookNET;

interface

uses uBTypes;

procedure InitNETHook;

var SendPacket: procedure(Packet: BPtr; Size: BInt32);

implementation

uses Windows, uDllPackets, uDllCodecave, uDllTibiaState;

{$REGION 'SendPacketHooks'}

var
  SendPacketFunc: BPtr;
  SendPacketNext: BPtr;
  SendPacketSize: BPInt32;
  SendPacketBuffer: BPtr;
  SendPacketIgnore: BBool;

procedure SendPacket850(Packet: BPtr; Size: BInt32);
var
  ID: BInt32;
begin
  SendPacketIgnore := True;
  SendPacketSize^ := Size + 8;
  CopyMemory(SendPacketBuffer, Packet, Size);
  ID := BPInt8(Packet)^;
  asm
    PUSH EDX
    MOV EDX, ID
    CALL SendPacketFunc
  end;
end;

procedure SendPacket1050(Packet: BPtr; Size: BInt32);
var
  ID: BInt32;
begin
  SendPacketIgnore := True;
  SendPacketSize^ := Size + 8;
  CopyMemory(SendPacketBuffer, Packet, Size);
  ID := BPInt8(Packet)^;
  asm
    PUSH ECX
    MOV ECX, ID
    CALL SendPacketFunc
    POP ECX
  end;
end;

procedure MySendPacket; cdecl;
begin
  if not SendPacketIgnore then
    PacketQueue.OnPacketOut(SendPacketBuffer, SendPacketSize^ - 8)
  else
    SendPacketIgnore := False;
end;

procedure CodeCaveSendPacket; assembler;
asm
  { Codecave Replaced Code }
  PUSH EBP
  MOV EBP, ESP
  PUSH $FFFFFFFF

  { Call My Function }
  PUSHAD
  PUSHFD
  CALL MySendPacket
  POPFD
  POPAD

  { Call the original function }
  CALL SendPacketNext
end;
{$ENDREGION}
{$REGION 'GetNextPacketHook'}
var
  GetNextPacketReturn: BPtr;
  GetNextPacketReturnMy: BPtr;
  GetNextPacketNext: BPtr;
  GetNextPacketBuffer: BPInt32;
  GetNextPacketPos: BPInt32;
  GetNextPacketSize: BPInt32;

procedure MyGetNextPacket;
var
  PacketID: Integer;
begin
  asm
    MOV PacketID, EAX
  end;
  if PacketID <> -1 then
    PacketQueue.OnPacketIn(Ptr(GetNextPacketBuffer^ + GetNextPacketPos^ - 1),
      GetNextPacketSize^ - GetNextPacketPos^ + 1);
end;

procedure CodeCaveGetNextPacketRet; assembler;
asm
  PUSHAD
  PUSHFD
  CALL MyGetNextPacket
  POPFD
  POPAD
  JMP DWORD PTR DS:[GetNextPacketReturn]
end;

procedure CodeCaveGetNextPacket; assembler;
asm
  { Replace the return address }
  POP GetNextPacketReturn
  PUSH GetNextPacketReturnMy

  { Codecave Replaced Code }
  PUSH EBP
  MOV EBP, ESP
  PUSH $FFFFFFFF

  { Call the original function }
  CALL GetNextPacketNext
end;
{$ENDREGION}

procedure InitNETHook;
begin
  PacketQueue := TBBotPacketQueue.Create;

  if TibiaState^.Version >= TibiaVer1050 then
    SendPacket := @SendPacket1050
  else
    SendPacket := @SendPacket850;

  GetNextPacketBuffer := BPtr(TibiaState^.Addresses.GetPacketBuffer);
  GetNextPacketPos := BPtr(TibiaState^.Addresses.GetPacketPos);
  GetNextPacketSize := BPtr(TibiaState^.Addresses.GetPacketSize);
  GetNextPacketNext := BPtr(TibiaState^.Addresses.GetPacketFunc + 5);
  GetNextPacketReturnMy := @CodeCaveGetNextPacketRet;
  InjectCodeCave(BPtr(TibiaState^.Addresses.GetPacketFunc), 5,
    @CodeCaveGetNextPacket, nil, ICC_JMP);

  SendPacketIgnore := False;
  SendPacketFunc := BPtr(TibiaState^.Addresses.SendPacketFunc);
  SendPacketBuffer := BPtr(TibiaState^.Addresses.SendPacketBuffer);
  SendPacketSize := BPInt32(TibiaState^.Addresses.SendPacketSize);
  SendPacketNext := BPtr(TibiaState^.Addresses.SendPacketFunc + 5);
  InjectCodeCave(BPtr(TibiaState^.Addresses.SendPacketFunc), 5,
    @CodeCaveSendPacket, nil, ICC_JMP);
end;

end.
