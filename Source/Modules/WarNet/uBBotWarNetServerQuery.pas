unit uBBotWarNetServerQuery;

interface

uses
  Classes,
  uBVector,
  uBTypes,
  uDownloader,
  uBBotTCPSocket,
  SyncObjs;

type
  TBBotWarNetServer = class
  public type
    TWarRoom = record
      Name: BStr;
      Players: BInt32;
    end;

    TWarRoomList = BVector<TWarRoom>;
    TWarRoomIt = TWarRoomList.It;
  private
    FPing: BInt32;
    FPort: BInt32;
    FOfficial: BBool;
    FIP: BStr;
    FRooms: TWarRoomList;
    FName: BStr;
    FFinished: BBool;
    FValid: BBool;
  protected
    Sock: TBBotTCPSocket;
    RefreshStart: BUInt32;
    procedure SendQuery;
    procedure ReceiveData;
  public
    constructor Create(const AIP: BStr; const APort: BInt32; const AOfficial: BBool);
    destructor Destroy; override;

    property Name: BStr read FName;

    property IP: BStr read FIP;
    property Port: BInt32 read FPort;
    property Official: BBool read FOfficial;

    property Ping: BInt32 read FPing;
    property Rooms: TWarRoomList read FRooms;
    property Finished: BBool read FFinished;
    property Valid: BBool read FValid;

    procedure Process;

    procedure Refresh;
  end;

  TBBotWarNetServersQuery = class(TThread)
  public type
    TServerList = BVector<TBBotWarNetServer>;
    TServerIt = TServerList.It;
  private
    FServers: TServerList;
    RefreshRequested, MasterRequested: BBool;
    FMutex: TMutex;
    HasTasks: BBool;
    procedure Reload;
    procedure ReloadMaster;
    procedure ReloadServers;
    procedure OnMasterLoaded(State: TLoadURLState; Data: BStr);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property Servers: TServerList read FServers;
    property Mutex: TMutex read FMutex;

    procedure onReloadCompleted; virtual; abstract;

    procedure Refresh;
  end;

implementation

{ TBBotWarNetServersQuery }

uses
  uEngine,
  Jsons,

  uBotPacket,
  uBBotWarNetProtocol,
  Declaracoes;

constructor TBBotWarNetServersQuery.Create;
begin
  FMutex := TMutex.Create;
  FServers := TServerList.Create(
    procedure(AIt: TServerIt)
    begin
      AIt^.Free;
    end);
  RefreshRequested := False;
  MasterRequested := False;

  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TBBotWarNetServersQuery.Destroy;
begin
  Terminate;
  Mutex.Free;
  Servers.Free;
  inherited;
end;

procedure TBBotWarNetServersQuery.Execute;
var
  ShouldReload: BBool;
begin
  while (EngineLoad <> elDestroying) and (not Terminated) do begin
    try
      ShouldReload := False;
      Mutex.WaitFor(50);
      try
        if RefreshRequested then begin
          ShouldReload := True;
          RefreshRequested := False;
        end;
      finally Mutex.Release;
      end;

      if HasTasks then begin
        HasTasks := False;
        Servers.ForEach(
          procedure(AIt: TServerIt)
          begin
            if not AIt^.Finished then begin
              AIt^.Process;
              HasTasks := True;
            end;
          end);
        if not HasTasks then
          onReloadCompleted;
      end;

      if ShouldReload then begin
        Reload;
        HasTasks := True;
      end;
    finally
      if HasTasks then
        Sleep(5)
      else
        Sleep(200);
    end;
  end;
end;

procedure TBBotWarNetServersQuery.Refresh;
begin
  Mutex.WaitFor(500);
  try RefreshRequested := True;
  finally Mutex.Release;
  end;
end;

procedure TBBotWarNetServersQuery.Reload;
begin
  if not MasterRequested then begin
    MasterRequested := True;
    ReloadMaster;
  end else begin
    ReloadServers;
  end;
end;

procedure TBBotWarNetServersQuery.ReloadMaster;
begin
  DownloadURL(BBotApiUrl('war'), '', OnMasterLoaded, nil);
end;

procedure TBBotWarNetServersQuery.OnMasterLoaded(State: TLoadURLState; Data: BStr);
var
  Json: TJson;
  Serverss: TJsonArray;
  Serverr: TJsonObject;
  IP: BStr;
  Port: BInt32;
  Official: BBool;
  I: BInt32;
begin
  Json := TJson.Create;
  try
    Json.Parse(Data);
    Serverss := Json.JsonArray;
    for I := 0 to Serverss.Count - 1 do begin
      Serverr := Serverss.Items[I].AsObject;
      IP := Serverr.Values['ip'].AsString;
      Port := Serverr.Values['port'].AsInteger;
      Official := Serverr.Values['official'].AsBoolean;
      if not Servers.Has('WarNet Servers Master loaded uniqueness check',
        function(AServer: TServerIt): BBool
        begin
          Exit((AServer^.IP = IP) and (AServer^.Port = Port));
        end) then
        Servers.Add(TBBotWarNetServer.Create(IP, Port, Official));
    end;
    ReloadServers;
  finally Json.Free;
  end;
end;

procedure TBBotWarNetServersQuery.ReloadServers;
begin
  Servers.ForEach(
    procedure(AIt: TServerIt)
    begin
      AIt^.Refresh;
    end);
end;

{ TBBotWarNetServer }

procedure TBBotWarNetServer.ReceiveData;
var
  Data: TBBotPacket;
  Count: BInt32;
  Room: TWarRoomIt;
  Cmd: BInt8;
begin
  Data := Sock.Recv;
  if Data <> nil then begin
    Cmd := Data.GetBInt8;
    if Cmd = CMD_SERVER_HELLO then begin
      SendQuery;
    end else if Cmd = CMD_SERVER_ROOMS then begin
      FPing := Tick - RefreshStart;
      FName := Data.GetBStr16;
      Count := Data.GetBInt16;
      while Count > 0 do begin
        Room := Rooms.Add;
        Room^.Name := Data.GetBStr16;
        Room^.Players := Data.GetBInt16;
        Dec(Count);
      end;
      FValid := True;
      Sock.Disconnect;
    end;
    Data.Free;
  end;
end;

constructor TBBotWarNetServer.Create(const AIP: BStr; const APort: BInt32; const AOfficial: BBool);
begin
  FName := '?';
  FIP := AIP;
  FPort := APort;
  FOfficial := AOfficial;
  FValid := False;
  FPing := 0;
  FRooms := TWarRoomList.Create;
  Sock := TBBotTCPSocket.Create;
  Sock.Timeout := 2000;
  Sock.IP := AIP;
  Sock.Port := APort;
end;

destructor TBBotWarNetServer.Destroy;
begin
  Sock.Destroy;
  FRooms.Free;
  inherited;
end;

procedure TBBotWarNetServer.Process;
var
  State: TBBotTCPSocket.TBBotTCPSocketState;
begin
  State := Sock.State;
  if State = bwnssConnecting then
    Exit
  else if State = bwnssConnected then
    ReceiveData
  else
    FFinished := True;
end;

procedure TBBotWarNetServer.Refresh;
begin
  FFinished := False;
  FPing := 0;
  Rooms.Clear;
  Sock.Connect;
end;

procedure TBBotWarNetServer.SendQuery;
var
  Packet: TBBotPacket;
begin
  RefreshStart := Tick;
  Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
  Packet.WriteBInt8(CMD_CLIENT_ROOMS);
  Sock.Send(Packet);
  Packet.Free;
end;

end.
