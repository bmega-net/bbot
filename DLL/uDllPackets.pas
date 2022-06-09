unit uDllPackets;

interface

uses uBTypes, Windows, SysUtils, StrUtils, Math, Classes, uBotPacket;

type

  TBBotPacketQueue = class
  private
    TibiaPackets: TList;
    PacketTibia: TBBotPacket;
    PacketBot: TBBotPacket;
  public
    constructor Create;
    destructor Destroy; override;

    procedure OnPacketIn(Data: BPtr; Size: BInt32);
    procedure OnPacketOut(Data: BPtr; Size: BInt32);
    procedure OnPacketBot(Data: BPtr; Size: BInt32);

    procedure AddPacketData(Data: BPtr; Size, IO: BInt32);
    procedure SendBBotPackets;
    procedure SendPackets;
    procedure SendBBotPacket(Buffer: BPtr; Size: BInt32);

    procedure Execute;
  end;

var
  PacketQueue: TBBotPacketQueue;

implementation

uses uDLL, uDllHookNET;

const
  _PacketBufferTibiaSize = 4194304;
  _PacketBufferBotSize = 16384;

  _PacketBufferIDLE = 1;
  _PacketBufferBusy = 2;
  _PacketBufferRead = 3;

  _PacketEOP = 0;
  _PacketOut = 1;
  _PacketIn = 2;
  _PacketBot = 3;

type
  _PPacketData = ^_TPacketData;

  _TPacketData = record
    IO: BInt32;
    Data: BPtr;
    Size: cardinal;
    Expire: cardinal;
  end;

  { TBBotPacketList }

procedure TBBotPacketQueue.AddPacketData(Data: BPtr; Size, IO: BInt32);
var
  PData: _PPacketData;
begin
  if TibiaPackets.Count > 100 then
    Exit;
  New(PData);
  PData.IO := IO;
  PData.Size := Size;
  PData.Expire := GetTickCount + 1000;
  GetMem(PData.Data, Size + 1);
  CopyMemory(PData.Data, Data, Size);
  TibiaPackets.Add(PData);
end;

constructor TBBotPacketQueue.Create;
begin
  TibiaPackets := TList.Create;
  PacketTibia := TBBotPacket.CreateSharedMemory
    ('bin' + BStr(IntToStr(BInt32(GetCurrentProcessId))),
    _PacketBufferTibiaSize);
  PacketBot := TBBotPacket.CreateSharedMemory
    ('bou' + BStr(IntToStr(BInt32(GetCurrentProcessId))), _PacketBufferBotSize);
  PacketTibia.Position := 0;
  PacketTibia.WriteBInt32(_PacketBufferIDLE);
  PacketBot.Position := 0;
  PacketBot.WriteBInt32(_PacketBufferIDLE);
end;

destructor TBBotPacketQueue.Destroy;
  procedure _FreePacketList(List: TList);
  var
    I: BInt32;
  begin
    if List.Count > 0 then
      for I := List.Count - 1 downto 0 do
      begin
        FreeMem(_PPacketData(List.Items[I])^.Data,
          _PPacketData(List.Items[I])^.Size);
        Dispose(_PPacketData(List.Items[I]));
      end;
    List.Clear;
    List.Free;
  end;

begin
  _FreePacketList(TibiaPackets);
  PacketTibia.Free;
  PacketBot.Free;

  inherited;
end;

procedure TBBotPacketQueue.Execute;
begin
  SendBBotPackets;
  SendPackets;
end;

procedure TBBotPacketQueue.OnPacketBot(Data: BPtr; Size: BInt32);
begin
  AddPacketData(Data, Size, _PacketBot);
end;

procedure TBBotPacketQueue.OnPacketIn(Data: BPtr; Size: BInt32);
begin
  AddPacketData(Data, Size, _PacketIn);
end;

procedure TBBotPacketQueue.OnPacketOut(Data: BPtr; Size: BInt32);
begin
  AddPacketData(Data, Size, _PacketOut);
end;

procedure TBBotPacketQueue.SendBBotPacket(Buffer: BPtr; Size: BInt32);
begin
  SendPacket(Buffer, Size);
  OnPacketBot(Buffer, Size);
end;

procedure TBBotPacketQueue.SendBBotPackets;
var
  Size: BInt32;
  Buffer: BPtr;
begin
  PacketBot.Position := 0;
  if PacketBot.GetBInt32 = _PacketBufferRead then
  begin
    try
      Size := PacketBot.GetBInt32;
      Buffer := BPtr(cardinal(PacketBot.Buffer) + PacketBot.Position);
      SendBBotPacket(Buffer, Size);
      PacketBot.Position := 0;
      PacketBot.WriteBInt32(_PacketBufferIDLE);
    except
      BGetError;
    end;
  end;
end;

procedure TBBotPacketQueue.SendPackets;
var
  Packet: _PPacketData;
  I: BInt32;
begin
  if TibiaPackets.Count > 0 then
  begin
    PacketTibia.Position := 0;
    if PacketTibia.GetBInt32 = _PacketBufferIDLE then
    begin
      PacketTibia.Position := 0;
      PacketTibia.WriteBInt32(_PacketBufferBusy);
      try
        for I := 0 to TibiaPackets.Count - 1 do
        begin
          Packet := TibiaPackets[I];
          if (PacketTibia.Position + Packet.Size) <
            (_PacketBufferTibiaSize - 256) then
            if Packet.Expire > GetTickCount then
            begin
              PacketTibia.WriteBInt32(Packet^.IO);
              PacketTibia.WriteBInt32(Packet^.Size);
              PacketTibia.WriteBuffer(Packet^.Data, Packet^.Size);
            end;
          FreeMem(Packet^.Data, Packet^.Size);
          Dispose(Packet);
        end;
        TibiaPackets.Clear;
        PacketTibia.WriteBInt32(_PacketEOP);
        PacketTibia.Position := 0;
        PacketTibia.WriteBInt32(_PacketBufferRead);
      except
        BGetError;
      end;
    end;
  end;
end;

end.
