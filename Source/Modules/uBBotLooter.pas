unit uBBotLooter;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaState,
  uContainer;

const
  BBotLooterToGround = 17;
  BBotLooterContainerOpenedWaitLock = 2000;
  BBotLooterActionWaitLock = 2000;
  BBotLooterMaxTries = 8;

type
  TBBotLooter = class(TBBotAction)
  private type
    PLootSlotData = ^TLootSlotData;

    TLootSlotData = record
      ID: BUInt32;
      Next: BLock;
      Tries: BInt32;
      Known: BLock;
    end;
  private
    FEnabled: BBool;
    FEatFromCorpse: BBool;
    FRustRemover: BBool;
    EatFromCorpseNext: BLock;
    LootSlot: array [0 .. ContainerStateCount, 0 .. ContainerStateItems] of TLootSlotData;
    OpenContainerLock: array [0 .. ContainerStateCount] of BLock;
    ErrorDisable: BLock;
    procedure LooterError(S: BStr);
    function GetError: BBool;
    function GetIsLooting: BBool;
    function DoWork: BBool;
    function TryAction(const Item: TTibiaContainer; const Loot: PLootSlotData): BBool;
  protected
    FIsLooting: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    property Enabled: BBool read FEnabled write FEnabled;
    property EatFromCorpse: BBool read FEatFromCorpse write FEatFromCorpse;
    property RustRemover: BBool read FRustRemover write FRustRemover;
    property IsLooting: BBool read GetIsLooting;

    procedure OnContainerOpen(CT: TTibiaContainer);

    property Error: BBool read GetError;

    procedure OnInit; override;
    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTibiaDeclarations,
  uHUD;

{ TBBotLooter }

constructor TBBotLooter.Create;
var
  I, J: BInt32;
begin
  inherited Create('Looter', 100);
  FEnabled := False;
  FIsLooting := False;
  EatFromCorpseNext := BLock.Create(12000, 20);
  ErrorDisable := BLock.Create(30000, 20);
  for I := 0 to High(LootSlot) do begin
    OpenContainerLock[I] := BLock.Create(300, 200);
    for J := 0 to High(LootSlot[I]) do begin
      LootSlot[I][J].Next := BLock.Create(60, 20);
      LootSlot[I][J].Known := BLock.Create(1500, 20);
    end;
  end;
end;

destructor TBBotLooter.Destroy;
var
  I, J: BInt32;
begin
  EatFromCorpseNext.Free;
  ErrorDisable.Free;
  for I := 0 to ContainerStateCount do begin
    OpenContainerLock[I].Free;
    for J := 0 to ContainerStateItems do begin
      LootSlot[I, J].Next.Free;
      LootSlot[I, J].Known.Free;
    end;
  end;
  inherited;
end;

function TBBotLooter.TryAction(const Item: TTibiaContainer; const Loot: PLootSlotData): BBool;
var
  ContainerTo: TTibiaContainer;
begin
  Result := False;
  if (Loot.ID <> Item.ID) or (not Loot.Known.Locked) then begin
    Loot.Tries := 0;
  end;
  if Loot.Tries < BBotLooterMaxTries then begin
    Inc(Loot.Tries);
    if (Item.LootToContainer = BBotLooterToGround) and (Item.IsCorpse) then begin
      Item.ToGround(Me.Position);
      Exit(True);
    end;
    if RustRemover and BIntIn(Item.ID, RustRemoverItems) then begin
      Item.UseOn(ItemID_RustRemover);
      Exit(True);
    end;
    if EatFromCorpse and (not EatFromCorpseNext.Locked) then begin
      if Item.IsFood and Item.IsCorpse then begin
        Item.Use;
        EatFromCorpseNext.Lock;
        Exit(True);
      end;
    end;
    if (Item.LootToContainer <> 0) and (Item.LootToContainer <> BBotLooterToGround) and
      (Item.LootToContainer <> (Item.Container + 1)) then begin
      if Me.Capacity >= Item.LootMinCap * 100 then begin
        if Me.CanTakeItem(Item) then begin
          ContainerTo := ContainerAt(Item.LootToContainer - 1, 0);
          if ContainerTo.Open and (not ContainerTo.IsCorpse) then begin
            if ContainerTo.PullHere(Item) <> bcpsError then begin
              if not Loot.Known.Locked then begin
                if Item.LootToContainer - 1 < Item.Container then begin
                  Item.IncLooted;
                  Loot.Known.Lock;
                end;
              end;
              Exit(True);
            end else begin
              LooterError('Can''t find backpack slots to new items, looter disabled for 1 minute');
              Exit(True);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TBBotLooter.DoWork: BBool;
var
  Item, ItemToOpen: TTibiaContainer;
  Loot: PLootSlotData;
begin
  Result := False;
  if Enabled and (not Error) and (not(BBot.Depositer.Working or BBot.Withdraw.isWorking)) and
    (not BBot.Backpacks.isWorking) then begin
    ItemToOpen := nil;
    Item := ContainerLast;
    while Item <> nil do begin
      Loot := @LootSlot[Item.Container, Item.Slot];
      if Loot.Next.Locked then begin
        BBot.Walker.WaitLock(BFormat('Looter task wait (%d:%d)', [Item.Container, Item.Slot]),
          BBotLooterActionWaitLock);
        Exit(True);
      end else if OpenContainerLock[Item.Container].Locked then begin
        BBot.Walker.WaitLock(BFormat('Looter task open container (%d)', [Item.Container, Item.Slot]),
          BBotLooterActionWaitLock);
        Exit(True);
      end else begin
        if TryAction(Item, Loot) then begin
          BBot.Walker.WaitLock(BFormat('Looter task action (%d:%d)', [Item.Container, Item.Slot]),
            BBotLooterActionWaitLock);
          Loot.Next.Lock;
          Exit(True);
        end else if Item.IsContainer and Item.IsCorpse then begin
          ItemToOpen := Item;
        end;
      end;
      Item := Item.Prev;
    end;
    if ItemToOpen <> nil then begin
      ItemToOpen.Use;
      OpenContainerLock[ItemToOpen.Container].Lock;
      Exit(True);
    end;
  end;
end;

function TBBotLooter.GetError: BBool;
begin
  Result := ErrorDisable.Locked;
end;

function TBBotLooter.GetIsLooting: BBool;
begin
  Result := Enabled and (not Error) and FIsLooting;
end;

procedure TBBotLooter.LooterError(S: BStr);
var
  HUD: TBBotHUD;
begin
  ErrorDisable.Lock;
  HUD := TBBotHUD.Create(bhgAny);
  HUD.AlignTo(bhaCenter, bhaTop);
  HUD.Expire := 30 * 1000;
  HUD.Print('[Looter Error]', $FFFFFF);
  HUD.Print(S);
  HUD.Free;
end;

procedure TBBotLooter.OnContainerOpen(CT: TTibiaContainer);
begin
  if Enabled then begin
    FIsLooting := True;
    if CT.Open then
      BBot.Walker.WaitLock('Looter container opened', BBotLooterContainerOpenedWaitLock);
  end;
end;

procedure TBBotLooter.OnInit;
begin
  inherited;
  BBot.Events.OnContainerOpen.Add(OnContainerOpen);
end;

procedure TBBotLooter.Run;
begin
  FIsLooting := DoWork;
end;

end.
