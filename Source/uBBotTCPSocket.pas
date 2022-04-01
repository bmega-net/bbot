unit uBBotTCPSocket;

interface

uses
  uBTypes,
  uBVector,
  Classes,
  syncobjs,
  blcksock,
  uBotPacket;

const
  BBOT_TCP_PACKET_ALLOC_SIZE = 1024;

type
  TBBotTCPSocket = class(TThread)
  public type
    TBBotTCPSocketState = (bwnssDisconnected, bwnssConnecting, bwnssConnected);
  private
    Sock: TTCPBlockSocket;
    Mutex: TMutex;
    Data: BVector<TBBotPacket>;
    FPort: BInt32;
    FIP: BStr;
    FTimeout: BUInt32;
    FState: TBBotTCPSocketState;
    function GetSockError: BInt32;
  protected
    procedure Execute; override;
    procedure StateDisconnected;
    procedure StateConnecting;
    procedure StateConnected;
    procedure CloseSocket;
  public
    constructor Create;
    destructor Destroy; override;

    property Error: BInt32 read GetSockError;
    property State: TBBotTCPSocketState read FState;
    property IP: BStr read FIP write FIP;
    property Port: BInt32 read FPort write FPort;
    property Timeout: BUInt32 read FTimeout write FTimeout;

    procedure Connect; overload;
    procedure Disconnect;

    procedure Send(const APacket: TBBotPacket);
    function Recv: TBBotPacket;
  end;

implementation

{ TBBotTCPSocket }

uses
  uEngine,
  uTibiaDeclarations;

procedure TBBotTCPSocket.CloseSocket;
begin
  if Sock.Socket <> -1 then
    Sock.CloseSocket;
  Sock.Free;
  Sock := TTCPBlockSocket.Create;
  Data.Clear;
end;

procedure TBBotTCPSocket.Connect;
begin
  if (FIP <> '') and (FPort <> 0) then
    if Mutex.WaitFor(1000) = wrSignaled then begin
      FState := bwnssConnecting;
      Data.Clear;
      Mutex.Release;
    end;
end;

constructor TBBotTCPSocket.Create;
begin
  Mutex := TMutex.Create;
  Sock := TTCPBlockSocket.Create;
  FState := bwnssDisconnected;
  FIP := '';
  FPort := 0;
  FTimeout := 10000;
  Data := BVector<TBBotPacket>.Create(
    procedure(It: BVector<TBBotPacket>.It)
    begin
      It^.Free;
    end);
  inherited Create(False);
end;

destructor TBBotTCPSocket.Destroy;
begin
  Terminate;
  Mutex.Acquire;
  Data.Free;
  Mutex.Free;
  Sock.Free;
  inherited;
end;

procedure TBBotTCPSocket.Disconnect;
begin
  if Mutex.WaitFor(1000) = wrSignaled then begin
    FState := bwnssDisconnected;
    Data.Clear;
    Mutex.Release;
  end;
end;

procedure TBBotTCPSocket.Execute;
begin
  inherited;
  while (EngineLoad <> elDestroying) and (not Terminated) do begin
    if Mutex.WaitFor(100) = wrSignaled then begin
      case FState of
      bwnssDisconnected: StateDisconnected;
      bwnssConnecting: StateConnecting;
      bwnssConnected: StateConnected;
      end;
      Mutex.Release;
    end;
    if FState = bwnssDisconnected then
      Sleep(200)
    else
      Sleep(20);
  end;
end;

procedure TBBotTCPSocket.StateConnected;
var
  Header: array [0 .. 1] of BUInt16;
  L, C: BUInt16;
  Buffer: BPtr;
  Packet: TBBotPacket;
  Waiting: BUInt32;
begin
  if Sock.LastError = 0 then begin
    Waiting := Sock.WaitingData;
    if (Waiting > 4) and (Sock.RecvBuffer(@Header, 4) = 4) then begin
      L := Header[0];
      C := Header[1];
      if (L < BBOT_TCP_PACKET_ALLOC_SIZE) and (Sock.WaitingData >= L) then begin
        GetMem(Buffer, L);
        if Sock.RecvBuffer(Buffer, L) = L then begin
          if Fletcher16(Buffer, L) = C then begin
            Packet := TBBotPacket.CreateReader(Buffer, L);
            Data.Add(Packet);
          end
          else
            FreeMem(Buffer);
        end
        else
          FreeMem(Buffer);
      end;
    end;
  end
  else
    FState := bwnssDisconnected;
end;

procedure TBBotTCPSocket.StateConnecting;
begin
  CloseSocket;
  Sock.SetTimeout(FTimeout);
  Sock.Connect(FIP, BFormat('%d', [FPort]));
  if (Sock.LastError = 0) and (Sock.Socket <> -1) then begin
    FState := bwnssConnected;
  end
  else
    FState := bwnssDisconnected;
end;

procedure TBBotTCPSocket.StateDisconnected;
begin
  CloseSocket;
end;

function TBBotTCPSocket.GetSockError: BInt32;
begin
  Result := Sock.LastError;
end;

function TBBotTCPSocket.Recv: TBBotPacket;
begin
  Result := nil;
  if Mutex.WaitFor(50) = wrSignaled then begin
    if not Data.Empty then
      Result := Data.Extract(0);
    Mutex.Release;
  end;
end;

procedure TBBotTCPSocket.Send(const APacket: TBBotPacket);
var
  Buffer: array of BInt8;
begin
  if Mutex.WaitFor(1000) = wrSignaled then begin
    if FState = bwnssConnected then begin
      SetLength(Buffer, APacket.Size + 4);
      BPUInt16(@Buffer[0])^ := APacket.Size;
      BPUInt16(@Buffer[2])^ := Fletcher16(BPInt8(APacket.Buffer), APacket.Size);
      Move(BPInt8(APacket.Buffer)^, BPtr(@Buffer[4])^, APacket.Size);
      Sock.SendBuffer(@Buffer[0], Length(Buffer));
    end;
    Mutex.Release;
  end;
end;

end.
