unit uItemDatExporter;

interface

uses
  uBTypes,
  Classes,
  jpeg,
  uTibiaProcess,
  uTibiaDeclarations;

{$IFNDEF Release}
{ .$DEFINE ExportDat }
{ .$DEFINE ExportSprites }
{$ENDIF}

const
  AdrDatPtr: BInt32 = $400000 + $70A130;
  // 1000N9: Pointer Scan -> First Item Name, max distance: 16; max jumps: 2
  SprTransparent = $FFFFFF;
  ItemMapColorFloor = 210;
  ItemsProperties = '../Tools/Properties.txt';
  ItemsSprite = 'C:/TibiaSprites/%s.jpeg';

type
  TTibiaDatLoaderFlags = set of ( //
    diWalkSpeed, // 0 -> 1
    diTopOrder1, // 1 -> 2
    diTopOrder2, // 2 -> 4
    diTopOrder3, // 3 -> 8
    diIsContainer, // 4 -> 16
    diIsStackable, // 5 -> 32
    diIsCorpse, // 6 -> 64
    diIsUsable, // 7 -> 128
    diIsWritable, // 8 -> 256
    diIsReadable, // 9 -> 512
    diIsFluidContainer, // 10 -> 1024
    diIsSplash, // 11 -> 2048
    diBlocking, // 12 -> 4096
    diIsImmovable, // 13 -> 8192
    diBlocksMissiles, // 14 -> 16384
    diBlocksPath, // 15 -> 32768
    diBlockMWall, // 16 -> 65536
    diIsPickupable, // 17 -> 131072
    diIsHangable, // 18 -> 262144
    diCanHangableHor, // 19 -> 524288
    diCanHangableVer, // 20 -> 1048576
    diIsRotatable, // 21 -> 2097152
    diIsLightSource, // 22 -> 4194304
    diIsShifted, // 23 -> 8388608
    diFloorchange, // 24 -> 16777216
    diIDK, // 25 -> 33554432
    diPlayerIncHeight, // 26 -> 67108864
    diIsCorpse2, // 27 -> 134217728
    diNOTUSED, // 28 -> 268435456
    diHasAutoMapColor, // 29 -> 536870912
    diHasHelpLens, // 30 -> 1073741824
    diIsGround // 31 -> 2147483648
    );

  TTibiaDatLoader = class
  private
    FItem: BUInt32;
    FBotFlags: TTibiaItemDatFlags;
    FSprite: TJPEGImage;
    FName: BStr;
    FTibiaFlags: TTibiaDatLoaderFlags;
    FWalkSpeed: BInt32;
    FLightIntensity: BInt32;
    FLightColor: BInt32;
    FMapColor: BInt32;
    function GetSprFile: BStr;
    function GetDatAddress: BUInt32;
    procedure SelfTest;
  protected
    Process: TBBotTibiaProcess;
    SpriteFile: TFileStream;
    Sprites: array of BUInt32;
    DatAddress: BUInt32;
  public
    constructor Create(ATibiahWnd: BUInt32; ADatAddress: BUInt32);
    destructor Destroy; override;

    function Load(AItem: BUInt32): BBool;
    procedure LoadSprite;

    property Item: BUInt32 read FItem;
    property BotFlags: TTibiaItemDatFlags read FBotFlags;
    property TibiaFlags: TTibiaDatLoaderFlags read FTibiaFlags;
    property WalkSpeed: BInt32 read FWalkSpeed;
    property LightIntensity: BInt32 read FLightIntensity;
    property LightColor: BInt32 read FLightColor;
    property MapColor: BInt32 read FMapColor;
    property Name: BStr read FName;
    property Sprite: TJPEGImage read FSprite;

    procedure ExportSprite(AFile: BStr);
  end;

procedure ExportTibiaDat;

implementation

uses
  SysUtils,
  Graphics,
  Windows,
  uItemLoader,
  uBBotAddresses,
  uTibiaState,
  Dialogs,
  uItem;

type
  TDatItemVocations = set of (diRooker, diKnight, diPaladin,
    diSorcerer, diDruid);

  TDatItem = record
    Name: BStr32;
    SpritePtr: BInt32;
    _Offset36: BInt32;
    Flags: TTibiaDatLoaderFlags;
    _Offset44: BInt32;
    _Offset48: BInt32;
    _Offset52: BInt32;
    _Offset56: BInt32;
    _Offset60: BInt32;
    _Offset64: BInt32;
    _Offset68: BInt32;
    WalkSpeed: BInt32;
    _Offset76: BInt32;
    LightRadius: BInt32;
    LightColor: BInt32;
    _Offset88: BInt32;
    _Offset92: BInt32;
    _Offset96: BInt32;
    MapColor: BInt32;
    _Offset104: BInt32;
    ShopKind: BInt32;
    ShopCategory: BInt32;
    ShopBuyId: BInt32;
    ShopSellId: BInt32;
    ShopVocation: BInt32;
    ShopLevel: BInt32;
  end;

procedure ExportTibiaDat;
var
  Loader: TTibiaDatLoader;
  ID, hWnd: BUInt32;
  Properties: TextFile;
{$IFDEF ExportSprites}
  ItemSpriteName: BStr;
  Flags, Flag: BUInt32;
{$ENDIF}
begin
  ShowMessageFmt('Buffer structure size: %d', [SizeOf(TDatItem)]);
  hWnd := FindWindowA('tibiaclient', nil);
  if hWnd = 0 then
    hWnd := FindWindowA('tibiaclientpreview', nil);
  if hWnd = 0 then
    raise Exception.Create('[Exporter] Tibia Client not found');

  AssignFile(Properties, ItemsProperties);
  Rewrite(Properties);

  AdrSelected := TibiaVerLast;
  LoadItems;

  Loader := TTibiaDatLoader.Create(hWnd, AdrDatPtr);
  try
    ID := 100;
    while Loader.Load(ID) do
    begin
      if Loader.BotFlags <> TibiaItems[ID].DatFlags then
        WriteLn(Properties, BFormat('%d,%d,%s', [ID, BPInt16(@Loader.BotFlags)^,
          Loader.Name]));
{$IFDEF ExportSprites}
      ItemSpriteName := BFormat('%.5d', [ID]);
      Flags := BPUInt32(@Loader.TibiaFlags)^;
      for Flag := 0 to 31 do
        if (Flags and (1 shl Flag)) <> 0 then
          ItemSpriteName := ItemSpriteName + BFormat('_%d', [Flag]);
      ItemSpriteName := BFormat(ItemsSprite, [ItemSpriteName]);
      if not BFileExists(ItemSpriteName) then
      begin
        OutputDebugMessage('Exporting Item Sprite: ' + ItemSpriteName);
        Loader.LoadSprite;
        Loader.ExportSprite(ItemSpriteName);
      end;
{$ENDIF}
      Inc(ID);
    end;
    ShowMessageFmt('Found %d items.', [ID]);
  finally
    Loader.Free;
  end;
  CloseFile(Properties);
  Halt;
end;

{ TTibiaDatLoader }

constructor TTibiaDatLoader.Create(ATibiahWnd, ADatAddress: BUInt32);
begin
  Process := TBBotTibiaProcess.Create;
  Process.hWnd := ATibiahWnd;
  Process.RenewHandle;
  SpriteFile := TFileStream.Create(GetSprFile, fmOpenRead or fmShareDenyNone);
  DatAddress := GetDatAddress;
  SelfTest;
end;

destructor TTibiaDatLoader.Destroy;
begin
  if FSprite <> nil then
    FSprite.Free;
  SpriteFile.Free;
  Process.Free;
  inherited;
end;

procedure TTibiaDatLoader.ExportSprite(AFile: BStr);
begin
  if Sprite <> nil then
    Sprite.SaveToFile(AFile);
end;

function TTibiaDatLoader.GetDatAddress: BUInt32;
begin
  Process.Read(AdrDatPtr, 4, @Result);
  Process.ReadEx(Result + 8, 4, @Result);
end;

function TTibiaDatLoader.GetSprFile: BStr;
begin
  Result := ExtractFilePath(Process.FileName) + '/Tibia.spr';
end;

function TTibiaDatLoader.Load(AItem: BUInt32): BBool;
var
  Item: TDatItem;
begin
  FItem := AItem;
  FName := '';
  FBotFlags := [];
  FTibiaFlags := [];
  SetLength(Sprites, 0);
  Result := Process.ReadEx(DatAddress + ((AItem - 100) * SizeOf(TDatItem)),
    SizeOf(TDatItem), @Item) = SizeOf(TDatItem);
  if Result then
  begin
    FName := Item.Name;
    FTibiaFlags := Item.Flags;
    FWalkSpeed := Item.WalkSpeed;
    FLightIntensity := Item.LightRadius;
    FLightColor := Item.LightColor;
    if diHasAutoMapColor in Item.Flags then
      FMapColor := Item.MapColor
    else
      FMapColor := -1;

    // SetLength(Sprites, Item.Width * Item.Height * Item.Layers * Item.PatternX * Item.PatternY * Item.PatternDepth);
    // if Length(Sprites) > 0 then
    // Process.ReadEx(Item.Sprite, Length(Sprites) * 4, @Sprites[0]);

    if diIsStackable in Item.Flags then
      FBotFlags := FBotFlags + [idfStackable];
    if diIsContainer in Item.Flags then
      FBotFlags := FBotFlags + [idfContainer];
    if diIsImmovable in Item.Flags then
      FBotFlags := FBotFlags + [idfNotMoveable];
    if diBlocking in Item.Flags then
      FBotFlags := FBotFlags + [idfNotWalkable];
    if diBlocksMissiles in Item.Flags then
      FBotFlags := FBotFlags + [idfBlockMissile];
    if diIsPickupable in Item.Flags then
      FBotFlags := FBotFlags + [idfPickupable];
    if (diWalkSpeed in Item.Flags) and (Item.WalkSpeed > 0) then
      FBotFlags := FBotFlags + [idfGround];
    if (diIsStackable in Item.Flags) or (diIsFluidContainer in Item.Flags) or
      (diIsSplash in Item.Flags) then
      FBotFlags := FBotFlags + [idfHasExtra];
  end;
end;

procedure TTibiaDatLoader.LoadSprite;
var
  SprOffsetBegin, SprOffsetEnd: BUInt32;
  Bmp: Graphics.TBitmap;
  Size, ColoredPixels, TransparentPixels: BUInt16;
  SpriteID, CurrentPixel, I, ImageX, ImageY: BInt32;
  Red, Green, Blue: BInt8;
begin
  Bmp := Graphics.TBitmap.Create;
  Bmp.Height := BCeil(SQRT(Length(Sprites))) * 32;
  Bmp.Width := Bmp.Height;
  ImageX := Bmp.Width - 32;
  ImageY := Bmp.Height - 32;
  Bmp.Canvas.Brush.Color := SprTransparent;
  Bmp.Canvas.FillRect(Bmp.Canvas.ClipRect);
  for SpriteID := 0 to High(Sprites) do
  begin
    SpriteFile.Seek(4 + (Sprites[SpriteID] * 4), soFromBeginning);
    SpriteFile.Read(SprOffsetBegin, 4);
    SpriteFile.Seek(SprOffsetBegin + 3, soFromBeginning);
    SpriteFile.Read(Size, 2);
    SprOffsetEnd := Size + SpriteFile.Position;
    CurrentPixel := 0;
    while SpriteFile.Position < SprOffsetEnd do
    begin
      SpriteFile.Read(TransparentPixels, 2);
      SpriteFile.Read(ColoredPixels, 2);
      Inc(CurrentPixel, TransparentPixels);
      for I := 1 to ColoredPixels do
      begin
        SpriteFile.Read(Red, 1);
        SpriteFile.Read(Green, 1);
        SpriteFile.Read(Blue, 1);
        Bmp.Canvas.Pixels[ImageX + (CurrentPixel mod 32),
          ImageY + (CurrentPixel div 32)] := RGB(Red, Green, Blue);
        Inc(CurrentPixel, 1);
      end;
    end;
    if ImageX = 0 then
    begin
      Dec(ImageY, 32);
      ImageX := Bmp.Width - 32;
    end
    else
      Dec(ImageX, 32);
  end;
  if FSprite <> nil then
    FSprite.Free;
  FSprite := TJPEGImage.Create;
  FSprite.Assign(Bmp);
  Bmp.Free;
end;

procedure TTibiaDatLoader.SelfTest;
begin
  if (not Load(100)) or (TibiaFlags <> [diWalkSpeed, diBlocking, diIsImmovable,
    diBlocksMissiles, diIsLightSource, diIsGround]) then
    raise Exception.Create('Item 100 flags failed');

  if (not Load(ItemID_GoldCoin)) or
    (TibiaFlags <> [diIsStackable, diIsPickupable]) then
    raise Exception.Create('Gold Coin flags failed');

  if (not Load(ItemID_PlatinumCoin)) or
    (TibiaFlags <> [diIsStackable, diIsPickupable]) then
    raise Exception.Create('Platinum Coin flags failed');

  if (not Load(ItemID_CrystalCoin)) or
    (TibiaFlags <> [diIsStackable, diIsPickupable]) then
    raise Exception.Create('Crystal Coin flags failed');

  if (not Load(2870)) or (TibiaFlags <> [diIsContainer, diIsPickupable]) then
    raise Exception.Create('Gray Backpack flags failed');

  if (not Load(ItemID_ManaPotion)) or
    (TibiaFlags <> [diIsStackable, diIsUsable, diIsPickupable]) then
    raise Exception.Create('Mana Potion flags failed');

  if (not Load(2925)) or (TibiaFlags <> [diIsPickupable, diIsLightSource]) or
    (LightIntensity <> 5) or (LightColor <> 206) then
    raise Exception.Create('Torch flags failed');

  if (not Load(799)) or (TibiaFlags <> [diWalkSpeed, diIsImmovable,
    diHasAutoMapColor, diIsGround]) or (WalkSpeed <> 160) then
    raise Exception.Create('Ice floor 799 properties failed');

  if (not Load(800)) or (TibiaFlags <> [diWalkSpeed, diIsImmovable,
    diHasAutoMapColor, diIsGround]) or (WalkSpeed <> 100) then
    raise Exception.Create('Ice floor 800 properties failed');
end;

{$IFDEF ExportDat}

initialization

ExportTibiaDat;
{$ENDIF}

end.
