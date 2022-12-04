unit uPackets;

interface

uses
  uBTypes,
  Windows,
  SysUtils,
  Classes,
  uBotPacket,
  uEngine;

type
  TBBotPacketQueue = class
  public
    PacketTibia: TBBotPacket;
    PacketBot: TBBotPacket;

    constructor Create;
    destructor Destroy; override;

    procedure PreparePacket;
    procedure SendPacket;

    procedure ReadPackets;

    procedure Execute;
  end;

var
  PacketQueue: TBBotPacketQueue;

implementation

uses

  BBotEngine,

  Math,
  Messages,
  uTibiaProcess;

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

  { TBBotPacketList }

constructor TBBotPacketQueue.Create;
begin
  PacketTibia := TBBotPacket.CreateSharedMemory
    ('bin' + IntToStr(BInt32(TibiaProcess.PID)), _PacketBufferTibiaSize);
  PacketBot := TBBotPacket.CreateSharedMemory
    ('bou' + IntToStr(BInt32(TibiaProcess.PID)), _PacketBufferBotSize);
  PacketTibia.Position := 0;
  PacketTibia.WriteBInt32(_PacketBufferIDLE);
  PacketBot.Position := 0;
  PacketBot.WriteBInt32(_PacketBufferIDLE);
end;

destructor TBBotPacketQueue.Destroy;
begin
  PacketBot.Free;
  PacketTibia.Free;
  inherited;
end;

procedure TBBotPacketQueue.Execute;
begin
  ReadPackets;
end;

procedure TBBotPacketQueue.PreparePacket;
begin
  PacketBot.Size := 0;
  PacketBot.Position := 0;
  PacketBot.WriteBInt32(_PacketBufferBusy);
  PacketBot.WriteBInt32(0);
end;

procedure TBBotPacketQueue.ReadPackets;
var
  From: BInt32;
  Size: BUInt32;
  Buffer: Pointer;
begin
  PacketTibia.Position := 0;
  if PacketTibia.GetBInt32 = _PacketBufferRead then
  begin
    while not PacketTibia.EOP do
    begin
      From := PacketTibia.GetBInt32;
      if From = _PacketEOP then
      begin
        PacketTibia.Position := 0;
        PacketTibia.WriteBInt32(_PacketBufferIDLE);
        Exit;
      end;
      Size := BUInt32(PacketTibia.GetBInt32);
      Buffer := Pointer(BUInt32(PacketTibia.Buffer) + PacketTibia.Position);
      if From = _PacketIn then
        BBot.Events.RunServerPacket(Buffer, Size)
      else if From = _PacketOut then
        BBot.Events.RunClientPacket(Buffer, Size)
      else if From = _PacketBot then
        BBot.Events.RunBotPacket(Buffer, Size);
      PacketTibia.Position := PacketTibia.Position + Size;
    end;
    PacketTibia.Position := 0;
    PacketTibia.WriteBInt32(_PacketBufferIDLE);
  end;
end;

procedure TBBotPacketQueue.SendPacket;
begin
  PacketBot.Position := 4;
  PacketBot.WriteBInt32(PacketBot.Size - 8);
  PacketBot.Position := 0;
  PacketBot.WriteBInt32(_PacketBufferRead);
  PostMessage(TibiaProcess.hWnd, WM_NULL, 0, 0);
  repeat
    Sleep(5);
    PacketBot.Position := 0;
  until (PacketBot.GetBInt32 = _PacketBufferIDLE) or
    (EngineLoad = elDestroying);
end;

end.

