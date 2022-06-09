unit uTibiaState;

interface

uses
  uBTypes;

type
{$I VERSIONS.inc}
  TTibiaKeyState = (bksDown, bksPressed, bksCallOff, bksCallOffShift, bksCallOffCtrl);
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

  TTibiaContainerState = array [0 .. ContainerStateCount] of TTibiaContainerStateContainer;

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

var
  TibiaState: PTibiaState;
procedure InitTibiaState;

implementation

uses
  SysUtils,
  uTibiaProcess,
  uBotPacket,
  uBBotAddresses;

procedure InitTibiaState;
var
  I: BInt32;
begin
  TibiaState := CreateSharedMemory('bsm' + IntToStr(TibiaProcess.PID), SizeOf(TTibiaState));
  TibiaState^.Version := AdrSelected;
  TibiaState^.hWnd := TibiaProcess.hWnd;
  TibiaState^.PID := TibiaProcess.PID;
  TibiaState^.Addresses.PrintTextFunc := TibiaProcess.GetAddress(TibiaAddresses.acPrintText);
  TibiaState^.Addresses.PrintNameCall := TibiaProcess.GetAddress(TibiaAddresses.acPrintName);
  TibiaState^.Addresses.PrintFPSCall := TibiaProcess.GetAddress(TibiaAddresses.acPrintFPS);
  TibiaState^.Addresses.PrintFPSNop := TibiaProcess.GetAddress(TibiaAddresses.acNopFPS);
  TibiaState^.Addresses.PrintFPSEnabled := TibiaProcess.GetAddress(TibiaAddresses.acShowFPS);
  TibiaState^.Addresses.PrintMapCall := TibiaProcess.GetAddress(TibiaAddresses.acPrintMap);
  TibiaState^.Addresses.SendPacketFunc := TibiaProcess.GetAddress(TibiaAddresses.acSendFunction);
  TibiaState^.Addresses.SendPacketBuffer := TibiaProcess.GetAddress(TibiaAddresses.acSendBuffer) + 8;
  TibiaState^.Addresses.SendPacketSize := TibiaProcess.GetAddress(TibiaAddresses.acSendBufferSize);
  TibiaState^.Addresses.GetPacketFunc := TibiaProcess.GetAddress(TibiaAddresses.acGetNextPacket);
  TibiaState^.Addresses.GetPacketBuffer := TibiaProcess.GetAddress(TibiaAddresses.acRecvStream);
  TibiaState^.Addresses.GetPacketPos := TibiaProcess.GetAddress(TibiaAddresses.acRecvStream) + 8;
  TibiaState^.Addresses.GetPacketSize := TibiaProcess.GetAddress(TibiaAddresses.acRecvStream) + 4;
  TibiaState^.Addresses.AdrLastClickID := TibiaProcess.GetAddress(TibiaAddresses.AdrLastSeeID);
  TibiaState^.Addresses.ContainerPtr := TibiaProcess.GetAddress(TibiaAddresses.AdrContainer);
  if TibiaAddresses.AdrAcc <> 0 then begin
    TibiaState^.Addresses.AccountPtr := TibiaProcess.GetAddress(TibiaAddresses.AdrAcc);
    TibiaState^.Addresses.PasswordPtr := TibiaProcess.GetAddress(TibiaAddresses.AdrPass);
  end else begin
    TibiaState^.Addresses.AccountPtr := 0;
    TibiaState^.Addresses.PasswordPtr := 0;
  end;
  for I := 0 to 255 do
    TibiaState^.Keys[I] := [];
  TibiaState^.HUDClick.ID := 0;
  TibiaState^.HUDClick.Data := 0;
  TibiaState^.ScreenBounds.PixelScale := 0;
  TibiaState^.ScreenBounds.Left := 0;
  TibiaState^.ScreenBounds.Right := 0;
  TibiaState^.ScreenBounds.Top := 0;
  TibiaState^.ScreenBounds.Bottom := 0;
  for I := 0 to High(TibiaState^.Container) do
    TibiaState^.Container[I].Open := False;
  TibiaState^.Ping := 0;
  TibiaState^.HasError := False;
end;

end.
