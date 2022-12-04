unit uDllTibiaState;

interface

uses uBTypes, uDllContainerState, uDllAccountState, SyncObjs;

type
{$I ..\Source\VERSIONS.inc}
  TTibiaKeyState = (bksDown, bksPressed, bksCallOff, bksCallOffShift,
    bksCallOffCtrl);
  TTibiaKeyStates = set of TTibiaKeyState;

const
  ContainerStateCount = 20;
  ContainerStateItems = 60;

type
  TTibiaContainerStateItem = record
    ID: BInt32;
    Count: BInt32;
    Amount: BInt32;
  end;

  TTibiaContainerStateContainer = record
    Open: BBool;
    Icon: BInt32;
    Name: BStr32;
    Capacity: BInt32;
    Count: BInt32;
    Items: array [0 .. ContainerStateItems] of TTibiaContainerStateItem;
  end;

  TTibiaContainerState = array [0 .. ContainerStateCount]
    of TTibiaContainerStateContainer;

  TTibiaStateScreen = record
    PixelScale: BDbl;
    Left: BInt32;
    Right: BInt32;
    Top: BInt32;
    Bottom: BInt32;
  end;

  TTibiaAddresses = record
    PrintTextFunc: BInt32;
    PrintNameCall: BInt32;
    PrintFPSCall: BInt32;
    PrintFPSNop: BInt32;
    PrintFPSEnabled: BInt32;
    PrintMapCall: BInt32;
    SendPacketFunc: BInt32;
    SendPacketBuffer: BInt32;
    SendPacketSize: BInt32;
    GetPacketFunc: BInt32;
    GetPacketBuffer: BInt32;
    GetPacketPos: BInt32;
    GetPacketSize: BInt32;
    AdrLastClickID: BInt32;
    ContainerPtr: BInt32;
    AccountPtr: BInt32;
    PasswordPtr: BInt32;
  end;

  TTibiaStateHUDClick = record
    ID: BInt32;
    Data: BInt32;
  end;

  PTibiaState = ^TTibiaState;

  TTibiaState = record
    Version: TTibiaVersion;
    Dll: BUInt32;
    hWnd: BInt32;
    PID: BInt32;
    Addresses: TTibiaAddresses;
    Keys: array [BInt8] of TTibiaKeyStates;
    HUDClick: TTibiaStateHUDClick;
    ScreenBounds: TTibiaStateScreen;
    Container: TTibiaContainerState;
    Ping: BInt32;
    Dash: BBool;
    Account: BStr32;
    Password: BStr32;
    Error: BStr255;
    HasError: BBool;
  end;

  TTibiaTemporaryState = record
    CriticalSection: TCriticalSection;
    Account: BStr32;
    Password: BStr32;
    Container: TTibiaContainerState;
  end;

  // std::string implementation D Item15 Effective STL
type
  PSTLString15 = ^TSTLString15;

  TSTLString15 = record
    StrData: array [0 .. 15] of BChar;
    StrLength: BInt32;
    StrCapacity: BInt32;
  end;

procedure STLString15ReadTo(AData: PSTLString15; ATo: BPChar;
  AToCapacity: BInt32);
procedure STLCharArrayCopy(AFrom, ATo: BPChar; AToCapacity: BInt32);

var
  TibiaState: PTibiaState;
  TibiaTemporaryState: TTibiaTemporaryState;
  BBotMutex: TMutex;

procedure UpdateTibiaState;
procedure InitTibiaState;
procedure DeInitTibiaState;
procedure BDllError(const AMessage: BStr);

implementation

uses Windows, SysUtils, uBotPacket, uDllPackets, uDLL;

var
  TibiaStateLoaderThread: BUInt32;

procedure UpdateTibiaState;
begin
  PacketQueue.Execute;
  TibiaTemporaryState.CriticalSection.Enter;
  try
    LoadStateContainer;
    LoadStateAccount;
  finally
    TibiaTemporaryState.CriticalSection.Release;
  end;
end;

procedure TibiaStateLoader;
var
  I: BInt32;
begin
  while True do
  begin
    BBotMutex.Acquire;
    try
      TibiaTemporaryState.CriticalSection.Enter;
      try
        TibiaState^.Account := TibiaTemporaryState.Account;
        TibiaState^.Password := TibiaTemporaryState.Password;
        for I := 0 to High(TibiaTemporaryState.Container) do
          if TibiaTemporaryState.Container[I].Open then
            TibiaState^.Container[I] := TibiaTemporaryState.Container[I]
          else
            TibiaState^.Container[I].Open := False;
      finally
        TibiaTemporaryState.CriticalSection.Release;
      end;
    finally
      BBotMutex.Release;
    end;
    Sleep(60);
  end;
end;

procedure InitTibiaState;
begin
  FillMemory(@TibiaTemporaryState, SizeOf(TTibiaTemporaryState), 0);
  TibiaTemporaryState.CriticalSection := TCriticalSection.Create;

  BBotMutex := TMutex.Create(nil, False, 'bmu' + IntToStr(GetCurrentProcessId));
  TibiaState := CreateSharedMemory(BFormat('bsm%d', [GetCurrentProcessId]),
    SizeOf(TTibiaState));
  TibiaState^.Dll := uDLL.BDllU32;
  InitStateContainer;
  InitStateAccount;
  TibiaStateLoaderThread := BThread(@TibiaStateLoader, nil);
end;

procedure DeInitTibiaState;
begin
  TerminateThread(TibiaStateLoaderThread, 0)
end;

procedure BDllError(const AMessage: BStr);
begin
  if (Length(AMessage) > 0) and (not TibiaState^.HasError) then
  begin
    STLCharArrayCopy(BPChar(@AMessage[1]), BPChar(@TibiaState^.Error[0]), 255);
    TibiaState^.Error[Length(AMessage)] := #0;
    TibiaState^.HasError := True;
  end;
end;

procedure STLCharArrayCopy(AFrom, ATo: BPChar; AToCapacity: BInt32);
var
  I: BInt32;
begin
  for I := 1 to AToCapacity do
  begin
    ATo^ := AFrom^;
    if ATo^ = #0 then
      Break;
    Inc(ATo);
    Inc(AFrom);
  end;
end;

procedure STLString15ReadTo(AData: PSTLString15; ATo: BPChar;
  AToCapacity: BInt32);
var
  AFrom: BPChar;
begin
  if AData.StrCapacity > 15 then
    AFrom := BPChar(BPInt32(@AData.StrData[0])^)
  else
    AFrom := BPChar(@AData.StrData[0]);
  STLCharArrayCopy(AFrom, ATo, AToCapacity);
end;

end.
