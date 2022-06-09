unit uBBotAmmoCounter;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotAmmoCounter = class(TBBotAction)
  private
    FEnabled: BBool;
  protected
    LastSlotItem: array [TTibiaSlot] of TBufferItem;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uItem,
  uHUD,
  SysUtils;

{ TBBotAmmoCounter }

constructor TBBotAmmoCounter.Create;
var
  I: TTibiaSlot;
begin
  inherited Create('Ammo Counter', 1000);
  FEnabled := False;
  for I := SlotFirst to SlotLast do begin
    LastSlotItem[I].ID := 0;
    LastSlotItem[I].Count := 0;
  end;
end;

procedure TBBotAmmoCounter.Run;
var
  Slot: TTibiaSlot;
  Item: TTibiaItem;
  HUD: TBBotHUD;
begin
  if Enabled then begin
    HUDRemoveGroup(bhgAmmoCounter);
    HUD := TBBotHUD.Create(bhgAmmoCounter);
    HUD.AlignTo(bhaRight, bhaBottom);
    HUD.Color := $A7F3F7;
    HUD.Expire := 2000;
    for Slot := SlotHead to SlotAmmo do begin
      Item := Me.Inventory.GetSlot(Slot);
      if Item.IsStackable then
        HUD.Print(Item.Name + ': ' + IntToStr(Item.Count));
    end;
    HUD.Free;
  end;
  for Slot := SlotHead to SlotAmmo do begin
    Item := Me.Inventory.GetSlot(Slot);
    if Item.IsStackable and (LastSlotItem[Slot].ID = Item.ID) and (LastSlotItem[Slot].Count > Item.Count) then
      BBot.SupliesStats.AddWaste(Item.Name, LastSlotItem[Slot].Count - Item.Count);
    LastSlotItem[Slot].ID := Item.ID;
    LastSlotItem[Slot].Count := Item.Count;
  end;
end;

end.
