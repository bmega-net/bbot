unit uTiles;

interface

uses
  uBTypes,
  Windows,
  uItem,
  Declaracoes,
  uSelf,
  Math,
  uTibiaDeclarations,
  uBBotSpecialSQMs,
  uItemLoader;

const
  TibiaTilesWidth = 8;
  TibiaTilesHeight = 6;

type
  TTibiaTiles = class(TTibiaItem)
  private
    function GetPosition: BPos;
    function GetCost: BFloat;
    function GetTileCost: BFloat;
    function MapBufferZ: BInt32;
    function MapBufferX: BInt32;
    function MapBufferY: BInt32;
  protected
    MapDX, MapDY: BInt32;
    procedure SetMyPos;
    function GetItemsOnTile: BInt32; virtual; abstract;
    procedure ReadItem(AIndex: BInt32); virtual; abstract;
  public
    constructor Create(AMapDX, AMapDY: BInt32);

    procedure CreatureOnTop;
    procedure ItemOnTop;

    property Position: BPos read GetPosition;
    property Cost: BFloat read GetCost;
    property TileCost: BFloat read GetTileCost;
    property ItemsOnTile: BInt32 read GetItemsOnTile;

    function Cleanup(): BBool; overload;
    function Cleanup(AMovePlayers: BBool): BBool; overload;
    function Walkable: BBool;
    function Shootable: BBool;
    function Has(AID: BUInt32): BBool;

    procedure ItemFromStack(AStack: BInt32);
  end;

procedure UpdateMap;
procedure SetItemsWalkable(const IDs: array of BUInt32;
  Walkable: TTibiaItemWalkable);
function Tiles(var Map: TTibiaTiles; X, Y: BInt32): BBool; overload;
function Tiles(var Map: TTibiaTiles; Pos: BPos): BBool; overload;
function TilesSearch(var AMap: TTibiaTiles; AOrigin: BPos; ARange: BUInt32;
  ATopItemOnly: BBool; APred: BFunc<BBool>): BBool;
procedure BotCreateMap;
procedure BotDestroyMap;

implementation

uses
  BBotEngine,

  uBBotAddresses,
  uHUD,
  SysUtils,
  DateUtils,

  uDistance,
  uBTree,
  uTibiaProcess,
  uTibiaState;

type
  TTibiaTilesClass = class of TTibiaTiles;

  TTibiaTiles850 = class(TTibiaTiles)
  protected
    function GetItemsOnTile: BInt32; override;
    procedure ReadItem(AIndex: BInt32); override;
  end;

  TTibiaTiles942 = class(TTibiaTiles)
  protected
    function GetItemsOnTile: BInt32; override;
    procedure ReadItem(AIndex: BInt32); override;
  end;

  TTibiaTiles990 = class(TTibiaTiles)
  protected
    function GetItemsOnTile: BInt32; override;
    procedure ReadItem(AIndex: BInt32); override;
  end;

  TTibiaTiles1021 = class(TTibiaTiles)
  protected
    function GetItemsOnTile: BInt32; override;
    procedure ReadItem(AIndex: BInt32); override;
  end;

  TTibiaTiles1050 = class(TTibiaTiles)
  protected
    function GetItemsOnTile: BInt32; override;
    procedure ReadItem(AIndex: BInt32); override;
  end;

var
  MyPosX: BInt32;
  MyPosY: BInt32;
  MyPosZ: BInt32;
  MyPosM: TTibiaTiles;
  TilesList: array [-8 .. 8, -6 .. 6] of TTibiaTiles;

type
  TBuffer850 = record
    Count: BInt32;
    Objects: array [0 .. 9] of TTibiaItemBuffer850;
    Orders: array [0 .. 9] of BInt32;
    Effects: BInt32;
  end;

var
  Buffer850: array [0 .. 7, 0 .. 13, 0 .. 17] of TBuffer850;

type
  TBuffer942 = record
    Count: BInt32;
    Orders: array [0 .. 9] of BInt32;
    Objects: array [0 .. 9] of TTibiaItemBuffer942;
    Effects: BInt32;
  end;

var
  Buffer942: array [0 .. 7, 0 .. 13, 0 .. 17] of TBuffer942;

type
  TBuffer990 = record
    Count: BInt32;
    Orders: array [0 .. 9] of BInt32;
    Objects: array [0 .. 9] of TTibiaItemBuffer990;
    Effects: BInt32;
  end;

var
  Buffer990: array [0 .. 7, 0 .. 13, 0 .. 17] of TBuffer990;

type
  TBuffer1021 = record
    Count: BInt32;
    Orders: array [0 .. 9] of BInt32;
    Objects: array [0 .. 9] of TTibiaItemBuffer1021;
    Effects: BInt32;
  end;

var
  Buffer1021: array [0 .. 7, 0 .. 13, 0 .. 17] of TBuffer1021;

type
  TBuffer1050 = record
    Count: BInt32;
    Orders: array [0 .. 9] of BInt32;
    Objects: array [0 .. 9] of TTibiaItemBuffer1050;
    Effects: BInt32;
  end;

var
  Buffer1050: array [0 .. 7, 0 .. 13, 0 .. 17] of TBuffer1050;

procedure BotCreateMap;
var
  I, J: BInt32;
  ClMap: TTibiaTilesClass;
begin
  if AdrSelected >= TibiaVer1050 then
    ClMap := TTibiaTiles1050
  else if AdrSelected >= TibiaVer1021 then
    ClMap := TTibiaTiles1021
  else if AdrSelected >= TibiaVer990 then
    ClMap := TTibiaTiles990
  else if AdrSelected >= TibiaVer942 then
    ClMap := TTibiaTiles942
  else
    ClMap := TTibiaTiles850;
  for I := -8 to 8 do
    for J := -6 to 6 do
      TilesList[I, J] := ClMap.Create(I, J);
  MyPosM := ClMap.Create(0, 0);
end;

procedure BotDestroyMap;
var
  I, J: BInt32;
begin
  for I := -8 to 8 do
    for J := -6 to 6 do
      TilesList[I, J].Free;
  MyPosM.Free;
end;

function Tiles(var Map: TTibiaTiles; X, Y: BInt32): BBool;
var
  DX, DY: BInt32;
begin
  Result := False;
  DX := X - Me.Position.X;
  DY := Y - Me.Position.Y;
  if Abs(DX) < 9 then
    if Abs(DY) < 7 then
    begin
      Map := TilesList[DX, DY];
      if Assigned(Map) then
        Map.ItemOnTop;
      Result := Map <> nil;
    end;
end;

function Tiles(var Map: TTibiaTiles; Pos: BPos): BBool;
begin
  Result := Tiles(Map, Pos.X, Pos.Y);
end;

function TilesSearch(var AMap: TTibiaTiles; AOrigin: BPos; ARange: BUInt32;
  ATopItemOnly: BBool; APred: BFunc<BBool>): BBool;
var
  X, Y, S, D: BInt32;
begin
  for D := 0 to ARange do
    for X := -D to +D do
      for Y := -D to +D do
        if (BAbs(X) = D) or (BAbs(Y) = D) then
          if Tiles(AMap, AOrigin.X + X, AOrigin.Y + Y) then
            if ATopItemOnly and APred then
              Exit(True)
            else if not ATopItemOnly then
              for S := 0 to AMap.ItemsOnTile - 1 do
              begin
                AMap.ItemFromStack(S);
                if APred then
                  Exit(True);
              end;
  Result := False;
end;

procedure SetItemsWalkable(const IDs: array of BUInt32;
  Walkable: TTibiaItemWalkable);
var
  I: BUInt32;
begin
  for I := Low(IDs) to High(IDs) do
    TibiaItems[IDs[I]].Walkable := Walkable;
end;

procedure ChangeLevelItemsHUD;
var
  Map: TTibiaTiles;
  HUD: TBBotHUD;
begin
  HUD := TBBotHUD.Create(bhgDebug);
  HUDRemoveGroup(bhgDebug);
  HUD.Color := BRandom($505050, $FFFFFF);
  TilesSearch(Map, Me.Position, 10, False,
    function: BBool
    begin
      Result := False;
      if Map.ChangeLevel then
      begin
        if Map.ChangeLevelLadder then
          HUD.Text := 'L'
        else if Map.ChangeLevelHole then
          HUD.Text := 'H'
        else if Map.ChangeLevelShovel then
          HUD.Text := 'S'
        else if Map.ChangeLevelRope then
          HUD.Text := 'R'
        else if Map.ChangeLevelDown then
          HUD.Text := 'D'
        else if Map.ChangeLevelUp then
          HUD.Text := 'U'
        else
          HUD.Text := '?';
        HUD.SetPosition(Map.Position);
        HUD.Print;
      end;
    end);
  HUD.Free;
end;

procedure UpdateMap;
var
  MapOffset: BInt32;
begin
  TibiaProcess.Read(TibiaAddresses.AdrMapPointer, 4, @MapOffset);
  if AdrSelected >= TibiaVer1050 then
    TibiaProcess.ReadEx(MapOffset, SizeOf(Buffer1050), @Buffer1050)
  else if AdrSelected >= TibiaVer1021 then
    TibiaProcess.ReadEx(MapOffset, SizeOf(Buffer1021), @Buffer1021)
  else if AdrSelected >= TibiaVer990 then
    TibiaProcess.ReadEx(MapOffset, SizeOf(Buffer990), @Buffer990)
  else if AdrSelected >= TibiaVer942 then
    TibiaProcess.ReadEx(MapOffset, SizeOf(Buffer942), @Buffer942)
  else
    TibiaProcess.ReadEx(MapOffset, SizeOf(Buffer850), @Buffer850);
  MyPosM.SetMyPos;
end;

{ TTibiaTiles }

function TTibiaTiles.Cleanup: BBool;
begin
  Exit(Cleanup(True));
end;

constructor TTibiaTiles.Create(AMapDX, AMapDY: BInt32);
begin
  MapDX := AMapDX;
  MapDY := AMapDY;
end;

procedure TTibiaTiles.CreatureOnTop;
var
  S: BInt32;
begin
  for S := 0 to ItemsOnTile - 1 do
  begin
    ReadItem(S);
    if ID = ItemID_Creature then
      Exit;
  end;
end;

function TTibiaTiles.GetTileCost: BFloat;
var
  HasPlayer: BBool;
  HasNonStackable: BBool;
  HasGround: BBool;
  S: BInt32;
  K: TBBotSpecialSQMKind;
begin
  Result := TileCost_Normal;
  if ItemsOnTile = 0 then
    Exit(TileCost_NotWalkable);
  if Me.Position = Position then
    Exit(TileCost_Normal);
  K := BBot.SpecialSQMs.Kind(Position.X, Position.Y, Position.Z);
  if (K = sskAvoid) or (K = sskAvoidAttacking) then
    Result := TileCost_Avoid
  else if (K = sskLike) or (K = sskLikeAttacking) then
    Result := TileCost_Like
  else if K = sskNone then
    Result := TileCost_Normal
  else if (K = sskAutoBlock) or (K = sskBlock) then
    Exit(TileCost_NotWalkable);
  HasGround := False;
  HasNonStackable := False;
  HasPlayer := False;
  for S := 0 to ItemsOnTile - 1 do
  begin
    ReadItem(S);

    if IsWalkable = iwAvoid then
      Result := Max(Result, TileCost_Avoid);
    if ChangeLevel then
      Result := Max(Result, TileCost_ExtremeAvoid);

    if ((ID = ItemID_Creature) and (not IsPlayerID(BUInt32(Count)))) or
      (IsWalkable = iwNotWalkable) then
      Exit(TileCost_NotWalkable);

    HasPlayer := HasPlayer or
      ((ID = ItemID_Creature) and (IsPlayerID(BUInt32(Count))));
    HasNonStackable := HasNonStackable or (ID = ItemID_NonStackableTile1) or
      (ID = ItemID_NonStackableTile2);
    HasGround := HasGround or IsGround;
  end;
  if (not HasGround) or (HasNonStackable and HasPlayer) then
    Result := TileCost_NotWalkable;
end;

function TTibiaTiles.GetPosition: BPos;
begin
  Result.X := Me.Position.X + MapDX;
  Result.Y := Me.Position.Y + MapDY;
  Result.Z := Me.Position.Z;
end;

function TTibiaTiles.Has(AID: BUInt32): BBool;
var
  S, SS: BInt32;
begin
  Result := False;
  SS := Stack;
  for S := 0 to ItemsOnTile - 1 do
  begin
    ReadItem(S);
    if ID = AID then
    begin
      Result := True;
      Break;
    end;
  end;
  ReadItem(SS);
end;

procedure TTibiaTiles.ItemFromStack(AStack: BInt32);
begin
  ReadItem(AStack);
end;

procedure TTibiaTiles.ItemOnTop;
var
  S: BInt32;
begin
  for S := 0 to ItemsOnTile - 1 do
  begin
    ReadItem(S);
    if (IsContainer or IsMoveable or IsPickupable or IntIn(ID, ItemsFirePoison))
      and (ID <> ItemID_Creature) then
      Exit;
  end;
end;

function TTibiaTiles.MapBufferX: BInt32;
begin
  Result := (MapDX + MyPosX) mod 18;
  if Result < 0 then
    Result := 18 + Result;
  if not InRange(Result, 0, 17) then
    raise Exception.CreateFmt('Tiles.BufferX invalid %d', [Result]);
end;

function TTibiaTiles.MapBufferY: BInt32;
begin
  Result := (MapDY + MyPosY) mod 14;
  if Result < 0 then
    Result := 14 + Result;
  if not InRange(Result, 0, 13) then
    raise Exception.CreateFmt('Tiles.BuffeY invalid %d', [Result]);
end;

function TTibiaTiles.MapBufferZ: BInt32;
begin
  Result := MyPosZ;
end;

procedure TTibiaTiles.SetMyPos;
var
  X, Y, Z, S: BInt32;
begin
  for Z := 0 to 7 do
  begin
    MyPosZ := Z;
    for Y := 0 to 13 do
    begin
      MyPosY := Y;
      for X := 0 to 17 do
      begin
        MyPosX := X;
        for S := 0 to ItemsOnTile - 1 do
        begin
          ItemFromStack(S);
          if ID = ItemID_Creature then
            if BUInt32(Count) = Me.ID then
              Exit;
        end;
      end;
    end;
  end;
end;

function TTibiaTiles.Shootable: BBool;
var
  S, SS: BInt32;
begin
  Result := True;
  SS := Stack;
  for S := 0 to ItemsOnTile - 1 do
  begin
    ReadItem(S);
    if IsBlockingMissiles then
    begin
      Result := False;
      Break;
    end;
  end;
  ReadItem(SS);
end;

function TTibiaTiles.Walkable: BBool;
begin
  Result := Cost <> 0;
end;

function TTibiaTiles.GetCost: BFloat;
var
  A, B: BInt32;
  M: TTibiaTiles;
  MC: BFloat;
begin
  Result := TileCost;
  if Result <= TileCost_Avoid then
  begin
    Result := Power(Result, 2);
    for A := -1 to +1 do
      for B := -1 to +1 do
        if (A <> 0) or (B <> 0) then
          if Tiles(M, Position.X + A, Position.Y + B) then
          begin
            MC := M.TileCost;
            if MC > TileCost_Avoid then
              MC := TileCost_Avoid;
            Result := Result * MC;
          end;
  end;
end;

function TTibiaTiles.Cleanup(AMovePlayers: BBool): BBool;
var
  P: BPos;
  S: BInt32;
  M: TTibiaTiles;
  Origin: BPos;
begin
  S := Stack;
  ItemOnTop;
  if IsMoveable and (AMovePlayers or (ID <> ItemID_Creature)) then
  begin
    if ID = ItemID_Creature then
      Origin := Position
    else
      Origin := Me.Position;
    P := BPosXYZ(Origin.X + BRandom(-1, 1), Origin.Y + BRandom(-1, 1),
      Origin.Z);
    if (P <> Position) and ((ID <> ItemID_Creature) or (P <> Me.Position)) then
      if not BBot.Exhaust.TileCleanup then
      begin
        BBot.Exhaust.ExhaustTileCleanup;
        if Tiles(M, P) and (M.GetTileCost = TileCost_Normal) then
          ToGround(P);
      end;
    Result := True;
  end
  else
    Result := False;
  ItemFromStack(S);
end;

{ TTibiaTiles850 }

function TTibiaTiles850.GetItemsOnTile: BInt32;
begin
  Result := BMinMax(Buffer850[MapBufferZ, MapBufferY, MapBufferX].Count, 0, 10);
end;

procedure TTibiaTiles850.ReadItem(AIndex: BInt32);
var
  BX, BY, BZ: BInt32;
begin
  BX := MapBufferX;
  BY := MapBufferY;
  BZ := MapBufferZ;
  SetItem(
  { ID } Buffer850[BZ, BY, BX].Objects[AIndex].ID,
  { Count } Buffer850[BZ, BY, BX].Objects[AIndex].Count,
  { Stack } AIndex,
  { Index } -1,
  { Position } Position);
end;

{ TTibiaTiles942 }

function TTibiaTiles942.GetItemsOnTile: BInt32;
begin
  Result := BMinMax(Buffer942[MapBufferZ, MapBufferY, MapBufferX].Count, 0, 10);
end;

procedure TTibiaTiles942.ReadItem(AIndex: BInt32);
var
  BX: BInt32;
  BY: BInt32;
  BZ: BInt32;
begin
  BX := MapBufferX;
  BY := MapBufferY;
  BZ := MapBufferZ;
  SetItem(
  { ID } Buffer942[BZ, BY, BX].Objects[AIndex].ID,
  { Count } Buffer942[BZ, BY, BX].Objects[AIndex].Count,
  { Stack } AIndex,
  { Index } -1,
  { Position } Position);
end;

{ TTibiaTiles990 }

function TTibiaTiles990.GetItemsOnTile: BInt32;
begin
  Result := BMinMax(Buffer990[MapBufferZ, MapBufferY, MapBufferX].Count, 0, 10);
end;

procedure TTibiaTiles990.ReadItem(AIndex: BInt32);
var
  BX: BInt32;
  BY: BInt32;
  BZ: BInt32;
begin
  BX := MapBufferX;
  BY := MapBufferY;
  BZ := MapBufferZ;
  SetItem(
  { ID } Buffer990[BZ, BY, BX].Objects[AIndex].ID,
  { Count } Buffer990[BZ, BY, BX].Objects[AIndex].Count,
  { Stack } AIndex,
  { Index } -1,
  { Position } Position);
end;

{ TTibiaTiles1021 }

function TTibiaTiles1021.GetItemsOnTile: BInt32;
begin
  Result := BMinMax(Buffer1021[MapBufferZ, MapBufferY, MapBufferX]
    .Count, 0, 10);
end;

procedure TTibiaTiles1021.ReadItem(AIndex: BInt32);
var
  BX: BInt32;
  BY: BInt32;
  BZ: BInt32;
begin
  BX := MapBufferX;
  BY := MapBufferY;
  BZ := MapBufferZ;
  SetItem(
  { ID } Buffer1021[BZ, BY, BX].Objects[AIndex].ID,
  { Count } Buffer1021[BZ, BY, BX].Objects[AIndex].Count,
  { Stack } AIndex,
  { Index } -1,
  { Position } Position);
end;

{ TTibiaTiles1050 }

function TTibiaTiles1050.GetItemsOnTile: BInt32;
begin
  Result := BMinMax(Buffer1050[MapBufferZ, MapBufferY, MapBufferX]
    .Count, 0, 10);
end;

procedure TTibiaTiles1050.ReadItem(AIndex: BInt32);
var
  BX: BInt32;
  BY: BInt32;
  BZ: BInt32;
begin
  BX := MapBufferX;
  BY := MapBufferY;
  BZ := MapBufferZ;
  SetItem(
  { ID } Buffer1050[BZ, BY, BX].Objects[AIndex].ID,
  { Count } Buffer1050[BZ, BY, BX].Objects[AIndex].Count,
  { Stack } AIndex,
  { Index } -1,
  { Position } Position);
end;

end.

