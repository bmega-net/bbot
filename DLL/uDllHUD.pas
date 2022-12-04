unit uDllHUD;

interface

uses uBTypes, Windows, SysUtils, StrUtils, Math, Classes, uBotPacket, uBVector;

const
  HUDLineHeight = 14;
  HUDCharWidth = 8;
  HUDCharHeight = 8;

type
  TBBotHUDPacket = (bhpClear = 200, bhpRemoveGroup, bhpRemovePositionGroup,
    bhpRemoveCreatureGroup, bhpAddScreen, bhpAddPosition,
    bhpAddCreature, bhpDone);

  TBBotHUDKind = (bhkScreen = 0, bhkPosition, bhkCreature, bhkDisabled);
  TBBotHUDAlign = (bhaLeft = 0, bhaCenter = 1, bhaRight = 2, bhaInvalid);

  TBBotHUD = class
  private
    FID: BUInt32;
    FExpire: BUInt32;
    FRed: BInt32;
    FZ: BInt32;
    FOnClick: BUInt32;
    FGroup: BInt32;
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
    FXYZUpdated: BUInt32;
    FOnClickData: BUInt32;
    function GetExpired: BBool;
    function GetText: BStr;
    function GetXYZUpdated: BUInt32;
    procedure SetXYZUpdated(const Value: BUInt32);
  public
    Rect: TRect;
    constructor Create(AID: BInt32);

    property ID: BUInt32 read FID;

    property Kind: TBBotHUDKind read FKind write FKind;
    property Text: BStr read GetText write FText;
    property Align: TBBotHUDAlign read FAlign write FAlign;

    property Red: BInt32 read FRed write FRed;
    property Blue: BInt32 read FBlue write FBlue;
    property Green: BInt32 read FGreen write FGreen;

    property Group: BInt32 read FGroup write FGroup;
    property Expire: BUInt32 read FExpire write FExpire;
    property Expired: BBool read GetExpired;
    property OnClick: BUInt32 read FOnClick write FOnClick;
    property OnClickData: BUInt32 read FOnClickData write FOnClickData;

    property RelativeX: BInt32 read FRelativeX write FRelativeX;
    property RelativeY: BInt32 read FRelativeY write FRelativeY;

    property Creature: BInt32 read FX write FX;

    property X: BInt32 read FX write FX;
    property Y: BInt32 read FY write FY;
    property Z: BInt32 read FZ write FZ;
    property XYZUpdated: BUInt32 read GetXYZUpdated write SetXYZUpdated;

    property ScreenX: BInt32 read FScreenX write FScreenX;
    property ScreenY: BInt32 read FScreenY write FScreenY;

    function OnMouseClick(Pos: PPoint): BBool;
    procedure Draw(Surface, Font: BInt32; BaseX, BaseY: BInt32);
    procedure DoExpire;

    function Validate: BBool;
  end;

  TBBotHUDManager = class
  private
    Data: BVector<TBBotHUD>;
    HUDPacket_NextRead: BUInt32;
    HUDPacket: TBBotPacket;
    HUDID: BUInt32;
    function CreateHUD: TBBotHUD;
  public
    constructor Create;
    destructor Destroy; override;

    procedure FastHUD(Text: BStr; Group, X, Y, R, G, B: BInt32;
      Expire: BUInt32);

    procedure Cleanup;
    procedure RemoveGroup(Group: BInt32);
    procedure RemovePositionGroup(X, Y, Z, Group: BInt32);
    procedure RemoveCreatureGroup(ID, Group: BInt32);
    procedure RemoveAll;
    procedure UpdatePosition(X, Y, Z, SX, SY: BInt32);
    function OnMouseClick(X, Y: BInt32): BBool;
    procedure OnPrintFPS(Surface, Font: BInt32);
    procedure OnPrintCreature(Creature: BInt32; Surface, Font: BInt32;
      BaseX, BaseY: BInt32);

    procedure ReadHUDPackets;
  end;

var
  HUDManager: TBBotHUDManager;

implementation

uses uDllHookHUD, uDLL, uDllTibiaState;

const
  _HUDBufferSize = 1048576;
  _HUDBufferIDLE = 1;
  _HUDBufferRead = 2;

  { TBBotHUD }

constructor TBBotHUD.Create(AID: BInt32);
begin
  FID := AID;
end;

procedure TBBotHUD.DoExpire;
begin
  Expire := GetTickCount - 1;
end;

procedure TBBotHUD.Draw(Surface, Font: BInt32; BaseX, BaseY: BInt32);
var
  W: BInt32;
begin
  W := Length(Text) * HUDCharWidth;
  Rect.Left := BaseX + RelativeX;
  Rect.Top := BaseY + RelativeY;

  PrintText(Surface, Rect.Left, Rect.Top, Font, Red, Green, Blue, BInt32(Align),
    BPChar(Text));

  if Align = bhaCenter then
    Rect.Left := Rect.Left - (W div 2);
  if Align = bhaRight then
    Rect.Left := Rect.Left - W;
  Rect.Right := Rect.Left + W;
  Rect.Bottom := Rect.Top + HUDLineHeight;
  InflateRect(Rect, 2, 2);
end;

function TBBotHUD.GetExpired: BBool;
begin
  Result := False;
  if Expire = 0 then
    Exit;
  Result := Expire < GetTickCount;
end;

function TBBotHUD.GetText: BStr;
begin
  if AnsiPos('#', string(FText)) > 0 then
    Result := BStr(StringReplace(string(FText), '#',
      FloatToStrF((Expire - GetTickCount) / 1000, ffFixed, 15, 1), []))
  else
    Result := FText;
end;

function TBBotHUD.GetXYZUpdated: BUInt32;
begin
  Result := GetTickCount - FXYZUpdated;
end;

function TBBotHUD.OnMouseClick(Pos: PPoint): BBool;
begin
  Result := PtInRect(Rect, Pos^);
  if Result then
  begin
    TibiaState^.HUDClick.ID := OnClick;
    TibiaState^.HUDClick.Data := OnClickData;
  end;
end;

procedure TBBotHUD.SetXYZUpdated(const Value: BUInt32);
begin
  FXYZUpdated := Value;
end;

function TBBotHUD.Validate: BBool;
begin
  Result := False;
  if Length(Text) > 200 then
    Exit;
  if Align = bhaInvalid then
    Exit;
  if (Red < 0) or (Red > 255) then
    Exit;
  if (Green < 0) or (Green > 255) then
    Exit;
  if (Blue < 0) or (Blue > 255) then
    Exit;
  if Text[Length(Text)] <> #0 then
    Exit;
  Result := True;
end;

{ TBBotHUDManager }

procedure TBBotHUDManager.Cleanup;
begin
  Data.Delete(
    function(It: BVector<TBBotHUD>.It): BBool
    begin
      Result := It^.Expired;
    end);
end;

destructor TBBotHUDManager.Destroy;
begin
  HUDPacket.Free;
  Data.Free;
  inherited;
end;

function TBBotHUDManager.OnMouseClick(X, Y: BInt32): BBool;
var
  Pos: TPoint;
  Res: BBool;
begin
  Pos.X := X;
  Pos.Y := Y;
  Res := False;
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      if It^.OnClick <> 0 then
        Res := Res or It^.OnMouseClick(@Pos);
    end);
  Result := Res;
end;

procedure TBBotHUDManager.OnPrintCreature(Creature, Surface, Font: BInt32;
BaseX, BaseY: BInt32);
begin
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      if It^.Kind = bhkCreature then
        if It^.Creature = Creature then
          It^.Draw(Surface, Font, BaseX, BaseY);
    end);
end;

procedure TBBotHUDManager.OnPrintFPS(Surface, Font: BInt32);
begin
  Cleanup;
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    var
      Y: BInt32;
    begin
      case It^.Kind of
        bhkScreen:
          begin
            Y := 0;
            Data.Has('SameYPixel',
              function(Itj: BVector<TBBotHUD>.It): BBool
              begin
                Result := Itj = It;
                if not Result then
                  if Itj^.Kind = bhkScreen then
                    if Itj^.ScreenX = It^.ScreenX then
                      if Itj^.ScreenY = It^.ScreenY then
                        Inc(Y, HUDLineHeight);
              end);
            It^.Draw(Surface, Font, It^.ScreenX, It^.ScreenY + Y);
          end;
        bhkPosition:
          begin
            if It^.XYZUpdated < 500 then
              It^.Draw(Surface, Font, TibiaState^.ScreenBounds.Left +
                Round(It^.ScreenX * TibiaState^.ScreenBounds.PixelScale),
                TibiaState^.ScreenBounds.Top + Round(It^.ScreenY *
                TibiaState^.ScreenBounds.PixelScale));
          end;
      end;
    end);
  ReadHUDPackets;
end;

procedure TBBotHUDManager.RemovePositionGroup(X, Y, Z, Group: BInt32);
begin
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      if (It^.Group = Group) and (It^.Kind = bhkPosition) and (It^.X = X) and
        (It^.Y = Y) and (It^.Z = Z) then
        It^.DoExpire;
    end);
end;

procedure TBBotHUDManager.RemoveGroup(Group: BInt32);
begin
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      if It^.Group = Group then
        It^.DoExpire;
    end);
end;

procedure TBBotHUDManager.UpdatePosition(X, Y, Z, SX, SY: BInt32);
begin
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      if (It^.Kind = bhkPosition) and (It^.X = X) and (It^.Y = Y) and (It^.Z = Z)
      then
      begin
        It^.ScreenX := SX;
        It^.ScreenY := SY;
        It^.XYZUpdated := GetTickCount;
      end;
    end);
end;

procedure TBBotHUDManager.RemoveAll;
begin
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      It^.DoExpire;
    end);
end;

constructor TBBotHUDManager.Create;
begin
  HUDID := 0;
  Data := BVector<TBBotHUD>.Create(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      It^.Free;
    end);
  HUDPacket := TBBotPacket.CreateSharedMemory
    ('bhu' + BStr(IntToStr(BInt32(GetCurrentProcessId))), _HUDBufferSize);
  HUDPacket_NextRead := GetTickCount + 200;
  inherited Create;
end;

function TBBotHUDManager.CreateHUD: TBBotHUD;
begin
  Inc(HUDID);
  Result := TBBotHUD.Create(HUDID);
end;

procedure TBBotHUDManager.ReadHUDPackets;
var
  CMD: Byte;
  X, Y, Z, A: BInt32;
  HUD: TBBotHUD;
  MustSort: BBool;
begin
  if HUDPacket_NextRead > GetTickCount then
    Exit;
  HUDPacket_NextRead := GetTickCount + 100;
  HUDPacket.Position := 0;
  if HUDPacket.GetBInt32 = _HUDBufferRead then
  begin
    try
      MustSort := False;
      while not HUDPacket.EOP do
      begin
        CMD := HUDPacket.GetBInt8;
        if (CMD < Ord(bhpClear)) or (CMD > Ord(bhpDone)) then
          Break;
        case TBBotHUDPacket(CMD) of
          bhpClear:
            begin
              RemoveAll;
            end;
          bhpRemoveGroup:
            begin
              RemoveGroup(HUDPacket.GetBInt32);
            end;
          bhpRemovePositionGroup:
            begin
              X := HUDPacket.GetBInt32;
              Y := HUDPacket.GetBInt32;
              Z := HUDPacket.GetBInt32;
              A := HUDPacket.GetBInt32;
              RemovePositionGroup(X, Y, Z, A);
            end;
          bhpRemoveCreatureGroup:
            begin
              X := HUDPacket.GetBInt32;
              Y := HUDPacket.GetBInt32;
              RemoveCreatureGroup(X, Y);
            end;
          bhpAddScreen:
            begin
              HUD := CreateHUD;
              HUD.Kind := bhkScreen;
              HUD.ScreenX := HUDPacket.GetBInt32;
              HUD.ScreenY := HUDPacket.GetBInt32;
              HUD.Text := HUDPacket.GetBStr32 + #0;
              A := HUDPacket.GetBInt32;
              if ((A < Ord(bhaLeft)) or (A > Ord(bhaRight))) then
                A := Ord(bhaInvalid);
              HUD.Align := TBBotHUDAlign(A);
              HUD.Red := HUDPacket.GetBInt32;
              HUD.Blue := HUDPacket.GetBInt32;
              HUD.Green := HUDPacket.GetBInt32;
              HUD.Group := HUDPacket.GetBInt32;
              HUD.Expire := BUInt32(HUDPacket.GetBInt32);
              HUD.OnClick := BUInt32(HUDPacket.GetBInt32);
              HUD.OnClickData := BUInt32(HUDPacket.GetBInt32);
              HUD.RelativeX := HUDPacket.GetBInt32;
              HUD.RelativeY := HUDPacket.GetBInt32;
              if HUD.Validate then
              begin
                Data.Add(HUD);
                MustSort := True;
              end
              else
              begin
                HUD.Free;
              end;
            end;
          bhpAddPosition:
            begin
              HUD := CreateHUD;
              HUD.Kind := bhkPosition;
              HUD.X := HUDPacket.GetBInt32;
              HUD.Y := HUDPacket.GetBInt32;
              HUD.Z := HUDPacket.GetBInt32;
              HUD.Text := HUDPacket.GetBStr32 + #0;
              A := HUDPacket.GetBInt32;
              if ((A < Ord(bhaLeft)) or (A > Ord(bhaRight))) then
                A := Ord(bhaInvalid);
              HUD.Align := TBBotHUDAlign(A);
              HUD.Red := HUDPacket.GetBInt32;
              HUD.Blue := HUDPacket.GetBInt32;
              HUD.Green := HUDPacket.GetBInt32;
              HUD.Group := HUDPacket.GetBInt32;
              HUD.Expire := BUInt32(HUDPacket.GetBInt32);
              HUD.OnClick := BUInt32(HUDPacket.GetBInt32);
              HUD.OnClickData := BUInt32(HUDPacket.GetBInt32);
              HUD.RelativeX := HUDPacket.GetBInt32;
              HUD.RelativeY := HUDPacket.GetBInt32;
              if HUD.Validate then
              begin
                Data.Add(HUD);
                MustSort := True;
              end
              else
              begin
                HUD.Free;
              end;
            end;
          bhpAddCreature:
            begin
              HUD := CreateHUD;
              HUD.Kind := bhkCreature;
              HUD.Creature := HUDPacket.GetBInt32;
              HUD.Text := HUDPacket.GetBStr32 + #0;
              A := HUDPacket.GetBInt32;
              if ((A < Ord(bhaLeft)) or (A > Ord(bhaRight))) then
                A := Ord(bhaInvalid);
              HUD.Align := TBBotHUDAlign(A);
              HUD.Red := HUDPacket.GetBInt32;
              HUD.Blue := HUDPacket.GetBInt32;
              HUD.Green := HUDPacket.GetBInt32;
              HUD.Group := HUDPacket.GetBInt32;
              HUD.Expire := BUInt32(HUDPacket.GetBInt32);
              HUD.OnClick := BUInt32(HUDPacket.GetBInt32);
              HUD.OnClickData := BUInt32(HUDPacket.GetBInt32);
              HUD.RelativeX := HUDPacket.GetBInt32;
              HUD.RelativeY := HUDPacket.GetBInt32;
              if HUD.Validate then
              begin
                Data.Add(HUD);
                MustSort := True;
              end
              else
              begin
                HUD.Free;
              end;
            end;
          bhpDone:
            Break;
        end;
      end;
      HUDPacket.Position := 0;
      HUDPacket.WriteBInt32(_HUDBufferIDLE);
      if MustSort then
      begin
        Data.Sort(
          function(A, B: BVector<TBBotHUD>.It): BInt32
          begin
            if A^.Group = B^.Group then
              Result := A^.ID - B^.ID
            else
              Result := A^.Group - B^.Group;
          end);
      end;
    except
      BGetError;
    end;
  end;
end;

procedure TBBotHUDManager.FastHUD(Text: BStr; Group, X, Y, R, G, B: BInt32;
Expire: BUInt32);
var
  AHUD: TBBotHUD;
begin
  AHUD := CreateHUD;
  AHUD.Group := Group;
  AHUD.Kind := bhkScreen;
  AHUD.ScreenX := X;
  AHUD.ScreenY := Y;
  AHUD.Blue := B;
  AHUD.Green := G;
  AHUD.Red := R;
  AHUD.Expire := GetTickCount + Expire;
  AHUD.Text := Text;
  Data.Add(AHUD);
end;

procedure TBBotHUDManager.RemoveCreatureGroup(ID, Group: BInt32);
begin
  Data.ForEach(
    procedure(It: BVector<TBBotHUD>.It)
    begin
      if (It^.Kind = bhkCreature) and (It^.Creature = ID) and (It^.Group = Group)
      then
        It^.DoExpire;
    end);
end;

end.
