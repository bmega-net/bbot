unit uItem;

interface

uses
  uBTypes,

  uTibiaDeclarations;

const
  TibiaMinItems = 99;
  TibiaMaxItems = BUInt32(100000);

var
  TibiaLastItem: BUInt32;

type
  TTibiaItem = class
  private type
    TvItemData = record
      ID: BUInt32;
      Count: BInt32;
      Position: BPos;
      Stack: BInt32;
      Index: BInt32;
    end;
  private
    vItem: TvItemData;
    FIsPickupable: BBool;
    FLootDrop: boolean;
    FCausesPotionExhaust: boolean;
    FCausesHostileExhaust: boolean;
    FChangeLevelShovel: BBool;
    FChangeLevelLadder: BBool;
    FIsFood: BBool;
    FIsContainer: BBool;
    FChangeLevelDown: BBool;
    FCausesDefensiveExhaust: boolean;
    FIsStackable: BBool;
    FIsBlockingMissiles: BBool;
    FHasExtra: boolean;
    FChangeLevelUp: BBool;
    FLootToContainer: BInt32;
    FRingID: BInt32;
    FWeight: BInt32;
    FName: BPChar;
    Item: PTibiaItemData;
    FIsMoveable: boolean;
    FChangeLevelRope: BBool;
    FIsDepot: BBool;
    FIsCreature: BBool;
    FIsWalkable: TTibiaItemWalkable;
    FChangeLevel: BBool;
    FChangeLevelHole: BBool;
    FIsTeleport: BBool;
    FLootDeposit: BBool;
    FIsGround: BBool;
    FLootMinCap: BInt32;
    procedure SetLC(Value: BInt32);
    function GetValidated: boolean;
    function GetLC: BInt32;
    function GetTotalWeight: BInt32;
  public
    function AsBuffer: TBufferItem;

    procedure SetItem(ID: BUInt32; Count, Stack, Index: BInt32; Position: BPos);
    procedure UnsetItem;

    procedure ToBody(ToSlot: TTibiaSlot; ToCount: BInt32 = -1);
    procedure ToGround(ToPos: BPos; ToCount: BInt32 = -1);

    procedure Use;
    procedure UseOn(UseID: BInt32);
    procedure UseAsContainer;

    procedure UseWithOn(ASlot: TTibiaSlot);

    property ID: BUInt32 read vItem.ID;
    property Count: BInt32 read vItem.Count;
    property Stack: BInt32 read vItem.Stack;
    property Position: BPos read vItem.Position;
    property Name: BPChar read FName;
    property Weight: BInt32 read FWeight;
    property TotalWeight: BInt32 read GetTotalWeight;

    property HasExtra: boolean read FHasExtra;

    property IsDepot: BBool read FIsDepot;
    property IsContainer: BBool read FIsContainer;
    property IsFood: BBool read FIsFood;
    property IsPickupable: BBool read FIsPickupable;
    property IsMoveable: boolean read FIsMoveable;
    property IsStackable: BBool read FIsStackable;
    property IsBlockingMissiles: BBool read FIsBlockingMissiles;
    property IsCreature: BBool read FIsCreature;
    property IsWalkable: TTibiaItemWalkable read FIsWalkable;
    property IsTeleport: BBool read FIsTeleport;
    property IsGround: BBool read FIsGround;
    property ChangeLevelDown: BBool read FChangeLevelDown;
    property ChangeLevelUp: BBool read FChangeLevelUp;
    property ChangeLevelRope: BBool read FChangeLevelRope;
    property ChangeLevelShovel: BBool read FChangeLevelShovel;
    property ChangeLevelLadder: BBool read FChangeLevelLadder;
    property ChangeLevelHole: BBool read FChangeLevelHole;
    property ChangeLevel: BBool read FChangeLevel;

    property CausesDefensiveExhaust: boolean read FCausesDefensiveExhaust;
    property CausesHostileExhaust: boolean read FCausesHostileExhaust;
    property CausesPotionExhaust: boolean read FCausesPotionExhaust;

    property RingID: BInt32 read FRingID;

    property LootToContainer: BInt32 read FLootToContainer;
    property LootMinCap: BInt32 read FLootMinCap;
    property LootDeposit: BBool read FLootDeposit;
    property LootDrop: BBool read FLootDrop;
    property LootedCount: BInt32 read GetLC write SetLC;
    procedure IncLooted;

    property Validated: boolean read GetValidated;
    property Valid: boolean read GetValidated;

  end;

var
  TibiaItems: array [0 .. TibiaMaxItems] of TTibiaItemData;

implementation

uses
  BBotEngine,
  SysUtils,
  StrUtils,
  Math,
  uContainer;

function TTibiaItem.AsBuffer: TBufferItem;
begin
  Result.ID := vItem.ID;
  Result.Count := vItem.Count;
end;

function TTibiaItem.GetLC: BInt32;
begin
  Result := Item.Loot.Looted;
end;

function TTibiaItem.GetTotalWeight: BInt32;
begin
  Result := Weight * BMax(Count, 1);
end;

function TTibiaItem.GetValidated: boolean;
begin
  Result := BInRange(vItem.ID, TibiaMinItems, TibiaLastItem);
end;

procedure TTibiaItem.SetLC(Value: BInt32);
begin
  Item.Loot.Looted := Value;
end;

procedure TTibiaItem.ToBody(ToSlot: TTibiaSlot; ToCount: BInt32 = -1);
begin
  if vItem.ID = ItemID_Creature then
    raise BException.Create('Trying to move creature into body');
  if vItem.ID = 0 then
    Exit;
  if not InRange(ToCount, 0, 100) then
    ToCount := vItem.Count;
  ToCount := BMinMax(ToCount, 0, vItem.Count);
  BBot.PacketSender.MoveItem(vItem.Position, vItem.ID, vItem.Stack, ToCount, BPosXYZ($FFFF, Ord(ToSlot), 0));
end;

procedure TTibiaItem.ToGround(ToPos: BPos; ToCount: BInt32 = -1);
begin
  if not InRange(ToCount, 0, 100) then
    ToCount := vItem.Count;
  ToCount := BMinMax(ToCount, 0, vItem.Count);
  if vItem.ID <> 0 then
    BBot.PacketSender.MoveItem(vItem.Position, vItem.ID, vItem.Stack, ToCount, ToPos);
end;

procedure TTibiaItem.Use;
begin
  if vItem.ID <> 0 then
    BBot.PacketSender.UseItem(vItem.Position, vItem.ID, vItem.Stack, BIf(vItem.Index = -1, Tibia.NewContainerIndex,
      vItem.Index));
end;

procedure TTibiaItem.UseAsContainer;
begin
  if vItem.ID = 0 then
    Exit;
  if IsContainer then
    BBot.PacketSender.UseItem(vItem.Position, vItem.ID, vItem.Stack, Tibia.NewContainerIndex);
end;

procedure TTibiaItem.SetItem(ID: BUInt32; Count, Stack, Index: BInt32; Position: BPos);
var
  BotFlags: TTibiaItemBotFlags;
  DatFlags: TTibiaItemDatFlags;
begin
  vItem.ID := ID;
  vItem.Count := Count;
  vItem.Stack := Stack;
  vItem.Position := Position;
  vItem.Index := Index;
  if BInRange(ID, TibiaMinItems, TibiaLastItem) then begin
    Item := @TibiaItems[vItem.ID];
    FLootToContainer := Item.Loot.Target;
    FLootMinCap := Item.Loot.MinCap;
    FLootDeposit := Item.Loot.Depositable;
    FLootDrop := Item.Loot.Dropable;

    BotFlags := Item.BotFlags;
    DatFlags := Item.DatFlags;

    FIsPickupable := (idfPickupable in DatFlags);
    FIsContainer := (idfContainer in DatFlags);

    FIsStackable := (idfStackable in DatFlags);
    FIsMoveable := not(idfNotMoveable in DatFlags);
    FIsBlockingMissiles := (idfBlockMissile in DatFlags);
    FHasExtra := (idfHasExtra in DatFlags);

    FIsCreature := vItem.ID = ItemID_Creature;

    FIsDepot := (idfDepot in BotFlags);
    FIsFood := (idfFood in BotFlags);

    FIsGround := (idfGround in DatFlags);

    FChangeLevelRope := (idfChangeLevelRope in BotFlags);
    FChangeLevelShovel := (idfChangeLevelShovel in BotFlags);
    FChangeLevelLadder := (idfChangeLevelLadder in BotFlags);
    FChangeLevelDown := (idfChangeLevelDown in BotFlags);
    FChangeLevelUp := (idfChangeLevelUp in BotFlags);
    FChangeLevelHole := (idfChangeLevelHole in BotFlags);
    FIsTeleport := (idfTeleport in BotFlags);
    FChangeLevel := (idfChangeLevel in BotFlags);

    FCausesDefensiveExhaust := (idfCausesDefensiveExhaust in BotFlags);
    FCausesPotionExhaust := (idfCausesPotionExhaust in BotFlags);
    FCausesHostileExhaust := (idfCausesHostileExhaust in BotFlags);

    FIsWalkable := Item.Walkable;

    FRingID := Item.RingID;
    FWeight := Item.Weight;
    if Length(Item.Name) > 0 then
      FName := BPChar(@Item.Name[1]);
  end;
end;

procedure TTibiaItem.IncLooted;
begin
  LootedCount := LootedCount + Max(Count, 1);
end;

procedure TTibiaItem.UnsetItem;
begin
  SetItem(0, 0, 0, 0, BPosXYZ(0, 0, 0));
end;

procedure TTibiaItem.UseOn(UseID: BInt32);
var
  _UseItem: TTibiaItem;
  _ItemFrom: BPos;
begin
  if not Validated then
    Exit;
  _ItemFrom := BPosXYZ($FFFF, 0, 0);
  _UseItem := ContainerFind(UseID);
  if Assigned(_UseItem) then
    _ItemFrom := _UseItem.vItem.Position;
  BBot.PacketSender.UseOnObject(_ItemFrom, UseID, _ItemFrom.Z, vItem.Position, vItem.ID, vItem.Stack);
end;

procedure TTibiaItem.UseWithOn(ASlot: TTibiaSlot);
var
  ToSlot: BPos;
  ToSlotId: BInt32;
begin
  if not Validated then
    Exit;
  ToSlot := BPosXYZ($FFFF, Ord(ASlot), 0);
  ToSlotId := Me.Inventory.GetSlot(ASlot).ID;
  BBot.PacketSender.UseOnObject(vItem.Position, vItem.ID, vItem.Stack, ToSlot, ToSlotId, ToSlot.Y); //confirm ToStack
end;

end.
