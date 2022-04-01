unit uBBotTradeWindow;


interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uTibiaDeclarations;

const
  BBotTradeWindowDelayBetweenCommandsVar = 'DelayBetweenCommands';
  BBotTradeWindowDelayBetweenCommandsDelay = 600;

type
  TBBotTradeWindowItem = record
    ID: BUInt32;
    Name: BStr;
    Amount: BInt32;
    Weight: BInt32;
    SellPrice: BInt32;
    BuyPrice: BInt32;
    HaveCount: BInt32;
  end;

  TBBotTradeWindowItems = BVector<TBBotTradeWindowItem>;

  TBBotTradeWindow = class(TBBotAction)
  private
    Items: TBBotTradeWindowItems;
    FIsOpen: BBool;
    FMoney: BUInt64;
    FName: BStr;
    FBankBalance: BUInt32;
    FDebug: BBool;
    FIgnoreCap: BBool;
    FBuyInBackpacks: BBool;
    procedure SetOpen(const Value: BBool);
    function GetItem(const AID, AAmount: BUInt32; CanAdd: BBool): TBBotTradeWindowItems.It;
    procedure Clear;
  protected
    WaitingBalance: BBool;
    DelayBetweenBuySellCommands: BUInt32;
    procedure SleepBetweenCommand;
    procedure SetBankBalance(const ABalance: BStr);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    property IsOpen: BBool read FIsOpen write SetOpen;
    property Money: BUInt64 read FMoney write FMoney;
    property BankBalance: BUInt32 read FBankBalance write FBankBalance;
    property Name: BStr read FName write FName;

    property IgnoreCap: BBool read FIgnoreCap write FIgnoreCap;
    property BuyInBackpacks: BBool read FBuyInBackpacks write FBuyInBackpacks;

    function Buy(const ID, BuyCount: BUInt32): BBool;
    function Sell(const ID, SellCount: BUInt32): BBool;
    function SellAll(const ID: BUInt32): BBool;

    procedure AddItem(const AName: BStr; const AID, AAmount, AWeight, ASellPrice, ABuyPrice: BInt32);
    procedure AddHaveCount(const AID, AAmount, AHaveCount: BInt32);

    function ItemInfo(const AID, AAmount: BUInt32): TBBotTradeWindowItems.It; overload;
    function ItemInfo(const AID: BUInt32): TBBotTradeWindowItems.It; overload;

    property Debug: BBool read FDebug write FDebug;

    procedure OnSay(ASayData: TTibiaMessage);
    procedure OnMessage(AMessageData: TTibiaMessage);
    procedure OnSystemMessage(AMessageData: TTibiaMessage);
  end;

implementation

{ TBBotTradeWindow }

uses
  BBotEngine,
  uRegex,
  SysUtils,
  uItem;

const
  ShopBankMessagePattern: BStr = 'Your account balance is now ([\d.,]+) gold.';
  AnyAmountMessagePattern: BStr = '(\b[\d.,]+\b)';
  NotValidAmount = BUInt32(999999999);

procedure TBBotTradeWindow.AddHaveCount(const AID, AAmount, AHaveCount: BInt32);
var
  Add: TBBotTradeWindowItems.It;
begin
  Add := GetItem(AID, AAmount, True);
  Add^.HaveCount := AHaveCount;
  if Debug then
    AddDebug(BFormat('HaveCount: %d for ID: %d with amount: %d', [AHaveCount, AID, AAmount]));
end;

procedure TBBotTradeWindow.AddItem(const AName: BStr; const AID, AAmount, AWeight, ASellPrice, ABuyPrice: BInt32);
var
  Add: TBBotTradeWindowItems.It;
begin
  Add := GetItem(AID, AAmount, True);
  Add^.Name := AName;
  Add^.Weight := AWeight;
  Add^.SellPrice := ASellPrice;
  Add^.BuyPrice := ABuyPrice;
  if Debug then
    AddDebug(BFormat('New item: %d with name %s and weight %d sell price %d buy price %d and amount %d',
      [AID, AName, AWeight, ASellPrice, ABuyPrice, AAmount]));
end;

function TBBotTradeWindow.Buy(const ID, BuyCount: BUInt32): BBool;
var
  Count: BInt32;
  Cost: BUInt64;
  Itemm: TBBotTradeWindowItems.It;
  NewBuyCount: BInt32;
begin
  Result := False;
  if not IsOpen then begin
    AddDebug(BFormat('Buying %d with Trade Window closed', [ID]));
    Exit;
  end;
  Itemm := ItemInfo(ID);
  if Itemm = nil then begin
    AddDebug(BFormat('Buying item %d not found', [ID]));
    Exit;
  end;
  if Itemm^.BuyPrice < 1 then begin
    AddDebug(BFormat('Buying item %d is not buyable in current NPC', [ID]));
    Exit;
  end;
  Cost := BuyCount * Cardinal(Itemm^.BuyPrice);
  if Money < Cost then begin
    AddDebug(BFormat('Buying with no enought money for id %d (wanted buy: %d, current money: %d, cost: %d)',
      [ID, BuyCount, Money, Cost]));
    NewBuyCount := BFloor(BBot.TradeWindow.Money / Itemm^.BuyPrice);
    AddDebug(BFormat('Buying trying again %d with new Buy Count: %d (old: %d)', [ID, BuyCount, NewBuyCount]));
    Buy(ID, NewBuyCount);
    Exit;
  end;
  Count := BuyCount;
  while Count > 0 do begin
    if Debug then
      AddDebug(BFormat('Buying %d of id %d (%d/%d)', [BMin(100, Count), ID, BuyCount - Cardinal(Count), BuyCount]));
    BBot.PacketSender.NPCBuy(ID, BMin(100, Count), Itemm^.Amount, IgnoreCap, BuyInBackpacks);
    Dec(Count, 100);
    SleepBetweenCommand;
  end;
  Exit(True);
end;

function TBBotTradeWindow.Sell(const ID, SellCount: BUInt32): BBool;
var
  Count: BInt32;
  Itemm: TBBotTradeWindowItems.It;
begin
  Result := False;
  if not IsOpen then begin
    AddDebug(BFormat('Selling %d with Trade Window closed', [ID]));
    Exit;
  end;
  Itemm := ItemInfo(ID);
  if Itemm = nil then begin
    AddDebug(BFormat('Selling item %d not found', [ID]));
    Exit;
  end;
  if Itemm^.SellPrice < 0 then begin
    AddDebug(BFormat('Selling item %d is not sellable in current NPC', [ID]));
    Exit;
  end;
  if SellCount < 1 then begin
    Exit(True);
  end;
  if not BInRange(SellCount, 1, Itemm^.HaveCount) then begin
    AddDebug(BFormat('Selling invalid SellCount for id %d (SellCount: %d available: %d)',
      [ID, SellCount, Itemm^.HaveCount]));
    Exit;
  end;
  Count := SellCount;
  while Count > 0 do begin
    if Debug then
      AddDebug(BFormat('Selling %d of id %d (%d/%d)', [BMin(100, Count), ID, SellCount - Cardinal(Count), SellCount]));
    BBot.PacketSender.NPCSell(ID, BMin(100, Count), Itemm^.Amount);
    Dec(Count, 100);
    SleepBetweenCommand;
  end;
  Exit(True);
end;

function TBBotTradeWindow.SellAll(const ID: BUInt32): BBool;
var
  EquippedItem: TTibiaItem;
  Itemm: TBBotTradeWindowItems.It;
  Slot: TTibiaSlot;
  Count: BInt32;
begin
  Itemm := ItemInfo(ID);
  if Itemm = nil then begin
    AddDebug(BFormat('Selling item %d not found', [ID]));
    Exit(False);
  end;
  Count := Itemm^.HaveCount;
  if Debug then
    AddDebug(BFormat('Selling all items %d Sell Count: %d', [ID, Count]));
  for Slot := SlotFirst to SlotLast do begin
    EquippedItem := Me.Inventory.GetSlot(Slot);
    if EquippedItem.ID = ID then begin
      Dec(Count, BMax(EquippedItem.Count, 1));
      if Debug then
        AddDebug(BFormat('Selling item %d found in inventory, new Sell Count: %d', [ID, Count]));
    end;
  end;
  Exit(Sell(ID, Count));
end;

procedure TBBotTradeWindow.Clear;
begin
  FIsOpen := False;
  FName := '';
  FMoney := 0;
  Items.Clear;
end;

constructor TBBotTradeWindow.Create;
begin
  inherited Create('TradeWindow', 10000);
  Items := TBBotTradeWindowItems.Create;
  FIsOpen := False;
  FName := '';
  FMoney := 0;
  FBankBalance := 0;
  WaitingBalance := False;
  FDebug := False;
end;

destructor TBBotTradeWindow.Destroy;
begin
  Items.Free;
  inherited;
end;

function TBBotTradeWindow.GetItem(const AID, AAmount: BUInt32; CanAdd: BBool): TBBotTradeWindowItems.It;
begin
  Result := Items.Find('Trade Window - Get Item',
    function(It: TBBotTradeWindowItems.It): BBool
    begin
      Result := (It^.ID = AID) and ((Cardinal(It^.Amount) = AAmount) or (AAmount = NotValidAmount))
    end);
  if (Result = nil) and CanAdd and (AAMount <> NotValidAmount) then begin
    Result := Items.Add;
    Result^.ID := AID;
    Result^.Amount := AAmount;
    Result^.HaveCount := 0;
    Result^.Name := '';
    Result^.Weight := 0;
    Result^.SellPrice := 0;
    Result^.BuyPrice := 0;
  end;
end;

function TBBotTradeWindow.ItemInfo(
  const AID: BUInt32): TBBotTradeWindowItems.It;
begin
  Result := GetItem(AID, NotValidAmount, False);
end;

function TBBotTradeWindow.ItemInfo(const AID, AAmount: BUInt32): TBBotTradeWindowItems.It;
begin
  Result := GetItem(AID, AAmount, False);
end;

procedure TBBotTradeWindow.OnInit;
begin
  inherited;
  BBot.Events.OnSay.Add(OnSay);
  BBot.Events.OnMessage.Add(OnMessage);
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);

  DelayBetweenBuySellCommands := BBotTradeWindowDelayBetweenCommandsDelay;
  ModVariable(BBotTradeWindowDelayBetweenCommandsVar, BBotTradeWindowDelayBetweenCommandsDelay).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      DelayBetweenBuySellCommands := AValue;
    end);
end;

procedure TBBotTradeWindow.OnMessage(AMessageData: TTibiaMessage);
var
  R: BStrArray;
begin
  if (AMessageData.Mode = MESSAGE_NPC_FROM_START_BLOCK) or (AMessageData.Mode = MESSAGE_NPC_FROM) then begin
    if WaitingBalance then begin
      if BSimpleRegex(AnyAmountMessagePattern, AMessageData.Text, R) and (High(R) >= 0) then begin
        WaitingBalance := False;
        SetBankBalance(R[High(R)]);
      end;
    end;
  end;
end;

procedure TBBotTradeWindow.OnSystemMessage(AMessageData: TTibiaMessage);
var
  R: BStrArray;
begin
  if AMessageData.Mode = MESSAGE_LOOK then begin
    if BSimpleRegex(ShopBankMessagePattern, AMessageData.Text, R) and (High(R) >= 0) then begin
      SetBankBalance(R[High(R)]);
    end;
  end;
end;

procedure TBBotTradeWindow.OnSay(ASayData: TTibiaMessage);
begin
  WaitingBalance := BStrPos('balance', BStrLower(ASayData.Text)) = 1;
  if WaitingBalance and Debug then
    AddDebug('Waiting for Balance');
end;

procedure TBBotTradeWindow.Run;
begin
  inherited;

end;

procedure TBBotTradeWindow.SetBankBalance(const ABalance: BStr);
var
  Balance: BStr;
begin
  Balance := BStrReplace(ABalance, ',', '');
  Balance := BStrReplace(Balance, '.', '');
  FBankBalance := BStrTo32(Balance, 0);
  if Debug then
    AddDebug(BFormat('Bank balance: %d', [FBankBalance]));
end;

procedure TBBotTradeWindow.SetOpen(const Value: BBool);
begin
  if Debug then
    AddDebug('Window ' + BIf(Value, 'Opened', 'Closed'));
  FIsOpen := Value;
  if not Value then
    Clear;
end;

procedure TBBotTradeWindow.SleepBetweenCommand;

var

  Delay: BUInt32;

begin
  Delay := BUInt32((BInt32(DelayBetweenBuySellCommands) * BRandom(100, 140)) div 100);
  Sleep(Delay);
end;

end.

