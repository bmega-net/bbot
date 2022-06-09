unit uInventory;

interface

uses
  uBTypes,
  uItem,
  uTibiaDeclarations,
  uTibiaProcess;

type
  TTibiaInventory = class
  private
    FHead: TTibiaItem;
    FNecklace: TTibiaItem;
    FBackpack: TTibiaItem;
    FArmor: TTibiaItem;
    FRight: TTibiaItem;
    FLeft: TTibiaItem;
    FLegs: TTibiaItem;
    FFeet: TTibiaItem;
    FRing: TTibiaItem;
    FAmmo: TTibiaItem;
    FLastClicked: TTibiaItem;
  protected
    procedure LoadItem(Item: TTibiaItem; Slot: TTibiaSlot); virtual; abstract;
    procedure LoadBuffer; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    function GetSlot(Slot: TTibiaSlot): TTibiaItem;
    property Head: TTibiaItem read FHead write FHead;
    property Necklace: TTibiaItem read FNecklace write FNecklace;
    property Backpack: TTibiaItem read FBackpack write FBackpack;
    property Armor: TTibiaItem read FArmor write FArmor;
    property Right: TTibiaItem read FRight write FRight;
    property Left: TTibiaItem read FLeft write FLeft;
    property Legs: TTibiaItem read FLegs write FLegs;
    property Feet: TTibiaItem read FFeet write FFeet;
    property Ring: TTibiaItem read FRing write FRing;
    property Ammo: TTibiaItem read FAmmo write FAmmo;
    property LastClicked: TTibiaItem read FLastClicked write FLastClicked;

    procedure Reload;
  end;

function CreateInventory: TTibiaInventory;

implementation

uses
  BBotEngine,
  uBBotAddresses,
  uTibiaState;

type
  TTibiaInventory850 = class(TTibiaInventory)
  private
    Data: array [0 .. 9] of TTibiaItemBuffer850;
  protected
    procedure LoadItem(Item: TTibiaItem; Slot: TTibiaSlot); override;
    procedure LoadBuffer; override;
  end;

  TTibiaInventory942 = class(TTibiaInventory)
  private
    Data: array [0 .. 9] of TTibiaItemBuffer942;
  protected
    procedure LoadItem(Item: TTibiaItem; Slot: TTibiaSlot); override;
    procedure LoadBuffer; override;
  end;

  TTibiaInventory990 = class(TTibiaInventory)
  private
    Data: array [0 .. 9] of TTibiaItemBuffer990;
  protected
    procedure LoadItem(Item: TTibiaItem; Slot: TTibiaSlot); override;
    procedure LoadBuffer; override;
  end;

  TTibiaInventory1021 = class(TTibiaInventory)
  private
    Data: array [0 .. 9] of TTibiaItemBuffer1021;
  protected
    procedure LoadItem(Item: TTibiaItem; Slot: TTibiaSlot); override;
    procedure LoadBuffer; override;
  end;

  TTibiaInventory1050 = class(TTibiaInventory)
  private
    Data: array [0 .. 9] of TTibiaItemBuffer1050;
  protected
    procedure LoadItem(Item: TTibiaItem; Slot: TTibiaSlot); override;
    procedure LoadBuffer; override;
  end;

function CreateInventory: TTibiaInventory;
begin
  if AdrSelected >= TibiaVer1050 then
    Result := TTibiaInventory1050.Create
  else if AdrSelected >= TibiaVer1021 then
    Result := TTibiaInventory1021.Create
  else if AdrSelected >= TibiaVer990 then
    Result := TTibiaInventory990.Create
  else if AdrSelected >= TibiaVer942 then
    Result := TTibiaInventory942.Create
  else
    Result := TTibiaInventory850.Create;
end;

{ TTibiaInventory }

constructor TTibiaInventory.Create;
begin
  FHead := TTibiaItem.Create;
  FNecklace := TTibiaItem.Create;
  FBackpack := TTibiaItem.Create;
  FArmor := TTibiaItem.Create;
  FRight := TTibiaItem.Create;
  FLeft := TTibiaItem.Create;
  FLegs := TTibiaItem.Create;
  FFeet := TTibiaItem.Create;
  FRing := TTibiaItem.Create;
  FAmmo := TTibiaItem.Create;
  FLastClicked := TTibiaItem.Create;
end;

destructor TTibiaInventory.Destroy;
begin
  FHead.Free;
  FNecklace.Free;
  FBackpack.Free;
  FArmor.Free;
  FRight.Free;
  FLeft.Free;
  FLegs.Free;
  FFeet.Free;
  FRing.Free;
  FAmmo.Free;
  FLastClicked.Free;
  inherited;
end;

function TTibiaInventory.GetSlot(Slot: TTibiaSlot): TTibiaItem;
begin
  case Slot of
  SlotHead: Result := Head;
  SlotAmulet: Result := Necklace;
  SlotBackpack: Result := Backpack;
  SlotArmor: Result := Armor;
  SlotRight: Result := Right;
  SlotLeft: Result := Left;
  SlotLegs: Result := Legs;
  SlotBoots: Result := Feet;
  SlotRing: Result := Ring;
  SlotAmmo: Result := Ammo;
  SlotLastClicked: Result := LastClicked;
else Result := nil;
  end;
end;

procedure TTibiaInventory.Reload;
begin
  LoadBuffer;
  LoadItem(Head, SlotHead);
  LoadItem(Necklace, SlotAmulet);
  LoadItem(Backpack, SlotBackpack);
  LoadItem(Armor, SlotArmor);
  LoadItem(Right, SlotRight);
  LoadItem(Left, SlotLeft);
  LoadItem(Legs, SlotLegs);
  LoadItem(Feet, SlotBoots);
  LoadItem(Ring, SlotRing);
  LoadItem(Ammo, SlotAmmo);
  LastClicked.SetItem(
    { ID } Tibia.LastClickedID,
    { Count } 0,
    { Stack } 0,
    { Index } -1,
    { Pos } BPosXYZ($FFFF, 0, 0));
end;

{ TTibiaInventory850 }

procedure TTibiaInventory850.LoadBuffer;
begin
  TibiaProcess.Read(TibiaAddresses.AdrInventory, SizeOf(Data), @Data)
end;

procedure TTibiaInventory850.LoadItem(Item: TTibiaItem; Slot: TTibiaSlot);
var
  Index: BInt32;
begin
  Index := Ord(Slot) - 1;
  Item.SetItem(
    { ID } Data[Index].ID,
    { Count } Data[Index].Count,
    { Stack } 0,
    { Index } -1,
    { Pos } BPosXYZ($FFFF, Ord(Slot), 0));
end;

{ TTibiaInventory942 }

procedure TTibiaInventory942.LoadBuffer;
begin
  TibiaProcess.Read(TibiaAddresses.AdrInventory, SizeOf(Data), @Data)
end;

procedure TTibiaInventory942.LoadItem(Item: TTibiaItem; Slot: TTibiaSlot);
var
  Index: BInt32;
begin
  Index := Ord(SlotAmmo) - Ord(Slot);
  Item.SetItem(
    { ID } Data[Index].ID,
    { Count } Data[Index].Count,
    { Stack } 0,
    { Index } -1,
    { Pos } BPosXYZ($FFFF, Ord(Slot), 0));
end;

{ TTibiaInventory990 }

procedure TTibiaInventory990.LoadBuffer;
begin
  TibiaProcess.Read(TibiaAddresses.AdrInventory, SizeOf(Data), @Data)
end;

procedure TTibiaInventory990.LoadItem(Item: TTibiaItem; Slot: TTibiaSlot);
var
  Index: BInt32;
begin
  Index := Ord(SlotAmmo) - Ord(Slot);
  Item.SetItem(
    { ID } Data[Index].ID,
    { Count } Data[Index].Count,
    { Stack } 0,
    { Index } -1,
    { Pos } BPosXYZ($FFFF, Ord(Slot), 0));
end;

{ TTibiaInventory1021 }

procedure TTibiaInventory1021.LoadBuffer;
begin
  TibiaProcess.Read(TibiaAddresses.AdrInventory, SizeOf(Data), @Data)
end;

procedure TTibiaInventory1021.LoadItem(Item: TTibiaItem; Slot: TTibiaSlot);
var
  Index: BInt32;
begin
  Index := Ord(SlotAmmo) - Ord(Slot);
  Item.SetItem(
    { ID } Data[Index].ID,
    { Count } Data[Index].Count,
    { Stack } 0,
    { Index } -1,
    { Pos } BPosXYZ($FFFF, Ord(Slot), 0));
end;

{ TTibiaInventory1050 }

procedure TTibiaInventory1050.LoadBuffer;
begin
  TibiaProcess.Read(TibiaAddresses.AdrInventory, SizeOf(Data), @Data)
end;

procedure TTibiaInventory1050.LoadItem(Item: TTibiaItem; Slot: TTibiaSlot);
var
  Index: BInt32;
begin
  Index := Ord(SlotAmmo) - Ord(Slot);
  Item.SetItem(
    { ID } Data[Index].ID,
    { Count } Data[Index].Count,
    { Stack } 0,
    { Index } -1,
    { Pos } BPosXYZ($FFFF, Ord(Slot), 0));
end;

end.
