unit uVip;

interface

uses
  uBTypes;

procedure UpdateVip;

type
  TTibiaVip = class
  private
    Index: BInt32;
    FIcon, FID: BInt32;
    FName: BStr;
    FOnline: boolean;
    procedure Load;
  public
    function FindName(sName: BStr): boolean;
    function Next: boolean;
    function Prev: boolean;
    property Icon: BInt32 read FIcon;
    property ID: BInt32 read FID;
    property Name: BStr read FName;
    property Online: boolean read FOnline;
    constructor Create;
  end;

implementation

uses

  SysUtils,
  uBBotAddresses,
  uTibiaProcess;

type
  TTibiaVipBufferItem = record
    ID: BInt32;
    Name: array [1 .. 26] of BChar;
    Online: BInt32;
    Online2: BInt32;
    Icon: BInt32;
  end;

  TTibiaVipBuffer = record
    VipItems: array [1 .. 200] of TTibiaVipBufferItem;
    VipOnline: BInt32;
    VipTotal: BInt32;
  end;

var
  Buffer: TTibiaVipBuffer;

procedure UpdateVip;
begin
  TibiaProcess.Read(TibiaAddresses.AdrVip, SizeOf(Buffer), @Buffer);
end;

{ TTibiaVip }

constructor TTibiaVip.Create;
begin
  UpdateVip;
  FName := '';
  FOnline := False;
  FIcon := 0;
  FID := 0;
  Index := 0;
  Next;
end;

function TTibiaVip.FindName(sName: BStr): boolean;
begin
  Result := False;
  repeat
  until not Self.Prev;
  repeat
    if AnsiSameText(Name, sName) then
      Exit(True);
  until not Self.Next;
end;

procedure TTibiaVip.Load;
begin
  FName := BPChar(@Buffer.VipItems[Index].Name);
  FOnline := Buffer.VipItems[Index].Online <> 0;
  FID := Buffer.VipItems[Index].ID;
  FIcon := Buffer.VipItems[Index].Icon;
end;

function TTibiaVip.Next: boolean;
begin
  Result := True;
  if Index < Buffer.VipTotal + 1 then
  begin
    Inc(Index);
    if Index > 200 then
      Index := 200;
    Load;
  end
  else
    Result := False;
end;

function TTibiaVip.Prev: boolean;
begin
  Result := True;
  if Index > 1 then
  begin
    Dec(Index);
    Load;
  end
  else
    Result := False;
end;

end.

