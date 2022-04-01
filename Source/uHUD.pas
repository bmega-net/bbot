unit uHUD;

interface

uses
  uBTypes,
  Declaracoes,
  Graphics,
  uBotPacket,

  Windows;

const
  HUDLineHeight = 14;
  HUDCharWidth = 8;
  HUDCharHeight = 8;

  HUDGrayColor: BInt32 = $C8C8C8;
  HUDStartX: BInt32 = 12;
  HUDStartY: BInt32 = 12;
  HUDInventorySize = 200;
  _HUDBufferSize = 1048576;
  _HUDBufferIDLE = 1;
  _HUDBufferRead = 2;

type
  TInfoRect = record
    X: BInt32;
    Y: BInt32;
    W: BInt32;
    H: BInt32;
    OW: Extended;
    OH: Extended;
  end;

  TBBotHUDPacket = (bhpClear = 200, bhpRemoveGroup, bhpRemovePositionGroup, bhpRemoveCreatureGroup, bhpAddScreen,
    bhpAddPosition, bhpAddCreature, bhpDone);

  TBBotHUDGroup = (bhgAny, bhgBBotNET, bhgBBotNETStatus, bhgAlert, bhgPause, bhgLooter, bhgBBotMenu, bhgReUser,
    bhgSpecialSQMs, bhgAimbot, bhgCreatureHUD, bhgManaShield, bhgInvisible, bhgHaste, bhgSuper, bhgPartyBuff,
    bhgIllusion, bhgRecovery, bhgAmmoCounter, bhgTrainer, bhgJustLoggedIn, bhgBBotCenter, bhgKillStats, bhgExpStats,
    bhgSkillsStats, bhgSupliesStats, bhgLooterStats, bhgProfitStats, bhgTestEngine, bhgReconnectManager, bhgMWall,
    bhgSpecialSQMsEditor, bhgDebugPositionStepStatistics, bhgDebugPositionAttackStatistics, bhgDebug, bhgDebugWalker,
    bhgDebugCavebot, bhgDebugBattlelist, bhgDebugOpenCorpses, bhgDebugMap, bhgDebugAStar, bhgDebugWaitLockers, bhgLast);

  TBBotHUDKind = (bhkScreen = 0, bhkPosition, bhkCreature, bhkUnset);
  TBBotHUDAlign = (bhaLeft = 0, bhaCenter = 1, bhaRight = 2);
  TBBotHUDVAlign = (bhaTop = 0, bhaMiddle = 1, bhaBottom = 2);

  TBBotHUD = class
  private
    FExpire: BUInt32;
    FRed: BInt32;
    FZ: BInt32;
    FOnClick: BUInt32;
    FGroup: TBBotHUDGroup;
    FBlue: BInt32;
    FX: BInt32;
    FGreen: BInt32;
    FY: BInt32;
    FRelativeY: BInt32;
    FRelativeX: BInt32;
    FText: BStr;
    FKind: TBBotHUDKind;
    FAlign: TBBotHUDAlign;
    FScreenY: BInt32;
    FScreenX: BInt32;
    FOnClickData: BUInt32;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetExpire(const Value: cardinal);
    procedure SetCreature(const Value: BUInt32);
    procedure SetX(const Value: BInt32);
    procedure SetY(const Value: BInt32);
    procedure SetZ(const Value: BInt32);
    procedure SetScreenX(const Value: BInt32);
    procedure SetScreenY(const Value: BInt32);
    procedure ToBuffer;
    function GetCreature: BUInt32;
  public
    constructor Create(AGroup: TBBotHUDGroup);
    procedure AlignTo(H: TBBotHUDAlign; V: TBBotHUDVAlign);
    procedure SetPosition(P: BPos);

    property Group: TBBotHUDGroup read FGroup;
    property Kind: TBBotHUDKind read FKind;

    property Text: BStr read FText write FText;
    property Align: TBBotHUDAlign read FAlign write FAlign;

    property Color: TColor read GetColor write SetColor;

    property Expire: cardinal read FExpire write SetExpire;
    property OnClick: cardinal read FOnClick write FOnClick;
    property OnClickData: BUInt32 read FOnClickData write FOnClickData;

    property RelativeX: BInt32 read FRelativeX write FRelativeX;
    property RelativeY: BInt32 read FRelativeY write FRelativeY;

    property Creature: BUInt32 read GetCreature write SetCreature;

    property X: BInt32 read FX write SetX;
    property Y: BInt32 read FY write SetY;
    property Z: BInt32 read FZ write SetZ;

    property ScreenX: BInt32 read FScreenX write SetScreenX;
    property ScreenY: BInt32 read FScreenY write SetScreenY;

    procedure Print(); overload;
    procedure Print(AText: BStr); overload;
    procedure Print(AText: BStr; AColor: BInt32); overload;
    procedure PrintGray(AText: BStr); overload;
    procedure Line();
  end;

procedure HUDUpdateRect;
procedure HUDRemoveGroup(Group: TBBotHUDGroup);
procedure HUDRemovePositionGroup(X, Y, Z: BInt32; Group: TBBotHUDGroup);
procedure HUDRemoveCreatureGroup(Creature: BUInt32; Group: TBBotHUDGroup);
procedure HUDRemoveAll;

procedure HUDPrepareSize(Size: BUInt32);
procedure HUDExecute;
procedure InitHUD;
procedure DeInitHUD;

var
  ScreenRect: TInfoRect;
  TibiaWindowRect: TRect;
  HUDPacket: TBBotPacket;
  HUDPacketConn: TBBotPacket;

implementation

uses

  SysUtils,

  uTibiaProcess,
  BBotEngine,
  uBBotAddresses,
  uTibiaState;

procedure ColorToIntRGB(Color: TColor; var R, G, B: BInt32);
begin
  R := BInt32(Byte(Color));
  G := BInt32(Byte(Color shr 8));
  B := BInt32(Byte(Color shr 16));
end;

procedure HUDUpdateRect;
var
  RectPtr: BInt32;
begin
  TibiaProcess.Read(TibiaAddresses.AdrScreenRectAndLevelSpyPtr, 4, @RectPtr);
  TibiaProcess.ReadEx(RectPtr + ($4 + $18), 4, @RectPtr);
  TibiaProcess.ReadEx(RectPtr + $14, 16, @ScreenRect);
  TibiaWindowRect := TibiaProcess.ClientRect;
  if not Me.Connected then begin
    ScreenRect.X := 0;
    ScreenRect.Y := 0;
    ScreenRect.W := TibiaWindowRect.Right - TibiaWindowRect.Left - 60;
    ScreenRect.H := TibiaWindowRect.Bottom - TibiaWindowRect.Top - 60;
  end;
  TibiaState^.ScreenBounds.Left := ScreenRect.X;
  TibiaState^.ScreenBounds.Top := ScreenRect.Y;
  TibiaState^.ScreenBounds.Right := ScreenRect.X + ScreenRect.W;
  TibiaState^.ScreenBounds.Bottom := ScreenRect.Y + ScreenRect.H;
  TibiaState^.ScreenBounds.PixelScale :=
    (((TibiaState^.ScreenBounds.Right - TibiaState^.ScreenBounds.Left) / 15)) / 32.0;
end;

procedure HUDRemoveGroup(Group: TBBotHUDGroup);
begin
  HUDPrepareSize(5);
  HUDPacket.WriteBInt8(BInt8(bhpRemoveGroup));
  HUDPacket.WriteBInt32(Ord(Group));
end;

procedure HUDRemovePositionGroup(X, Y, Z: BInt32; Group: TBBotHUDGroup);
begin
  HUDPrepareSize(17);
  HUDPacket.WriteBInt8(BInt8(bhpRemovePositionGroup));
  HUDPacket.WriteBInt32(X);
  HUDPacket.WriteBInt32(Y);
  HUDPacket.WriteBInt32(Z);
  HUDPacket.WriteBInt32(Ord(Group));
end;

procedure HUDRemoveCreatureGroup(Creature: BUInt32; Group: TBBotHUDGroup);
begin
  HUDPrepareSize(5);
  HUDPacket.WriteBInt8(BInt8(bhpRemoveCreatureGroup));
  HUDPacket.WriteBInt32(BInt32(Creature));
  HUDPacket.WriteBInt32(Ord(Group));
end;

procedure HUDRemoveAll;
begin
  HUDPrepareSize(1);
  HUDPacket.WriteBInt8(BInt8(bhpClear));
end;

procedure InitHUD;
begin
  HUDPacketConn := TBBotPacket.CreateSharedMemory('bhu' + IntToStr(TibiaProcess.PID), _HUDBufferSize);
  HUDPacketConn.Position := 0;
  HUDPacketConn.Size := 0;
  HUDPacketConn.WriteBInt32(_HUDBufferIDLE);

  HUDPacket := TBBotPacket.CreateWritter(_HUDBufferSize);
  HUDPacket.Position := 0;
  HUDPacket.Size := 0;
  HUDRemoveAll;
end;

procedure DeInitHUD;
begin
  _SafeFree(HUDPacket);
  _SafeFree(HUDPacketConn);
end;

procedure HUDExecute;
begin
  if HUDPacket.Size > 0 then begin
    HUDPacketConn.Position := 0;
    while HUDPacketConn.GetBInt32 = _HUDBufferIDLE do begin
      HUDPacket.WriteBInt32(Ord(bhpDone));
      HUDPacket.Position := 0;

      HUDPacketConn.Position := 0;
      HUDPacketConn.Size := 0;
      HUDPacketConn.WriteBInt32(_HUDBufferIDLE);
      HUDPacketConn.WriteBuffer(HUDPacket.Buffer, HUDPacket.Size);
      HUDPacketConn.Position := 0;
      HUDPacketConn.WriteBInt32(_HUDBufferRead);

      HUDPacket.Position := 0;
      HUDPacket.Size := 0;
    end;
  end;
end;

procedure HUDPrepareSize(Size: BUInt32);
begin
  if (HUDPacket.Position + Size + 100) > _HUDBufferSize then begin
    HUDPacket.Position := 0;
    HUDPacket.Size := 0;
  end;
end;

{ TBBotHUD }

procedure TBBotHUD.AlignTo(H: TBBotHUDAlign; V: TBBotHUDVAlign);
begin
  Align := H;
  case H of
  bhaLeft: ScreenX := HUDStartX;
  bhaCenter: ScreenX := ScreenRect.X + (ScreenRect.W div 2);
  bhaRight: ScreenX := (TibiaWindowRect.Right - TibiaWindowRect.Left) - HUDInventorySize - HUDStartX;
  end;
  case V of
  bhaTop: ScreenY := ScreenRect.Y + HUDStartY;
  bhaMiddle: ScreenY := ScreenRect.Y + (ScreenRect.H div 2) - (12 * 4);
  bhaBottom: ScreenY := ScreenRect.Y - (HUDStartY * 2) + ScreenRect.H - (12 * 2);
  end;
  if (V = bhaTop) and (H = bhaLeft) then
    ScreenY := ScreenY + HUDStartY;
end;

constructor TBBotHUD.Create(AGroup: TBBotHUDGroup);
begin
  FKind := bhkUnset;
  Align := bhaLeft;
  RelativeX := 0;
  RelativeY := 0;
  OnClick := 0;
  FGreen := 0;
  FRed := 0;
  FBlue := 0;
  FExpire := 0;
  FGroup := AGroup;
end;

function TBBotHUD.GetColor: TColor;
begin
  Result := (FRed * 256 * 256) + (FGreen * 256) + (FBlue);
end;

function TBBotHUD.GetCreature: BUInt32;
begin
  Result := BUInt32(FX);
end;

procedure TBBotHUD.Print(AText: BStr; AColor: BInt32);
var
  C: TColor;
begin
  C := Color;
  Color := AColor;
  Print(AText);
  Color := C;
end;

procedure TBBotHUD.Print;
begin
  Print(Text);
end;

procedure TBBotHUD.PrintGray(AText: BStr);
begin
  Print(AText, HUDGrayColor);
end;

procedure TBBotHUD.Line;
var
  OC: BInt32;
begin
  OC := OnClick;
  OnClick := 0;
  Print(' ');
  OnClick := OC;
end;

procedure TBBotHUD.Print(AText: BStr);
begin
  Text := AText;
  ToBuffer;
end;

procedure TBBotHUD.SetColor(const Value: TColor);
begin
  ColorToIntRGB(Value, FRed, FGreen, FBlue);
end;

procedure TBBotHUD.SetCreature(const Value: BUInt32);
begin
  FX := BInt32(Value);
  FKind := bhkCreature;
  Align := bhaRight;
end;

procedure TBBotHUD.SetExpire(const Value: cardinal);
begin
  FExpire := 0;
  if Value <> 0 then
    FExpire := Tick + Value;
end;

procedure TBBotHUD.SetPosition(P: BPos);
begin
  X := P.X;
  Y := P.Y;
  Z := P.Z;
end;

procedure TBBotHUD.SetScreenX(const Value: BInt32);
begin
  FScreenX := Value;
  FKind := bhkScreen;
end;

procedure TBBotHUD.SetScreenY(const Value: BInt32);
begin
  FScreenY := Value;
  FKind := bhkScreen;
end;

procedure TBBotHUD.SetX(const Value: BInt32);
begin
  FX := Value;
  FKind := bhkPosition;
  Align := bhaLeft;
end;

procedure TBBotHUD.SetY(const Value: BInt32);
begin
  FY := Value;
  FKind := bhkPosition;
  Align := bhaLeft;
end;

procedure TBBotHUD.SetZ(const Value: BInt32);
begin
  FZ := Value;
  FKind := bhkPosition;
  Align := bhaLeft;
end;

procedure TBBotHUD.ToBuffer;
begin
  if FKind = bhkUnset then
    raise Exception.Create('HUD unset kind');
  HUDPrepareSize(Length(Text) + 60);
  case Kind of
  bhkPosition: begin
      HUDPacket.WriteBInt8(BInt8(Ord(bhpAddPosition)));
      HUDPacket.WriteBInt32(X);
      HUDPacket.WriteBInt32(Y);
      HUDPacket.WriteBInt32(Z);
    end;
  bhkScreen: begin
      HUDPacket.WriteBInt8(BInt8(Ord(bhpAddScreen)));
      HUDPacket.WriteBInt32(ScreenX);
      HUDPacket.WriteBInt32(ScreenY);
    end;
  bhkCreature: begin
      HUDPacket.WriteBInt8(BInt8(Ord(bhpAddCreature)));
      HUDPacket.WriteBInt32(BInt32(Creature));
    end;
  end;
  HUDPacket.WriteBStr32(Text);
  HUDPacket.WriteBInt32(Ord(Align));
  HUDPacket.WriteBInt32(FRed);
  HUDPacket.WriteBInt32(FBlue);
  HUDPacket.WriteBInt32(FGreen);
  HUDPacket.WriteBInt32(Ord(Group));
  HUDPacket.WriteBInt32(BInt32(Expire));
  HUDPacket.WriteBInt32(BInt32(OnClick));
  HUDPacket.WriteBInt32(BInt32(OnClickData));
  HUDPacket.WriteBInt32(RelativeX);
  HUDPacket.WriteBInt32(RelativeY);
end;

end.
