unit uDllDash;

interface

uses uBTypes, uDllTibiaState, Windows;

function Dash_KeyDown(Key: BInt32): BBool;
function Dash_KeyUp(Key: BInt32): BBool;
function Dash_Char(Key: BInt32): BBool;
procedure Dash_Run();

implementation

uses uDllPackets;

const
  Dash_Keys: set of BInt8 = [VK_UP, VK_RIGHT, VK_DOWN, VK_LEFT, VK_DELETE];
var
  DashPacket: BInt8 = 0;
  LastDashPacket: BInt8 = 0;

procedure Dash_Run();
begin
  if (DashPacket <> 0) and TibiaState^.Dash then
  begin
    LastDashPacket := DashPacket;
    PacketQueue.SendBBotPacket(@DashPacket, 1);
  end;
end;

function Dash_KeyDown(Key: BInt32): BBool;
begin
  case Key of
    VK_UP:
      DashPacket := $65;
    VK_RIGHT:
      DashPacket := $66;
    VK_DOWN:
      DashPacket := $67;
    VK_LEFT:
      DashPacket := $68;
    VK_DELETE:
      DashPacket := LastDashPacket;
  else
    Exit(False);
  end;
  Dash_Run();
  Exit(True);
end;

function Dash_KeyUp(Key: BInt32): BBool;
begin
  if (Key < 255) and (BInt8(Key) in Dash_Keys) then
  begin
    DashPacket := 0;
    Exit(True);
  end
  else
    Exit(False);
end;

function Dash_Char(Key: BInt32): BBool;
begin
  if (Key < 255) and (BInt8(Key) in Dash_Keys) then
    Exit(True)
  else
    Exit(False);
end;

end.
