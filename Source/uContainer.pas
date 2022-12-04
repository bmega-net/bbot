unit uContainer;


interface

uses
  uBTypes,
  uItem,
  SysUtils;

const
  BBotContainerPositionX = $FFFF;
  BBotContainerPositionYAdd = 64;

type
  TBBotContainerPushState = (bcpsError, bcpsTryAgain, bcpsSuccess);

  TTibiaContainer = class(TTibiaItem)
  private
    function GetNext: TTibiaContainer;
    function GetPrev: TTibiaContainer;
  protected
    FContainer, FSlot: BInt32;
    FIcon, FCapacity, FItems: BInt32;
    FContainerName: BStr;
    FOpen: BBool;
    function GetIsCorpse: BBool;
    function GetIsDepotContainer: BBool;
    function GetChecksum: BInt32;
    function GetMoveSlot(const AItem: TTibiaItem): BInt32;
  public
    destructor Destroy; override;

    property Next: TTibiaContainer read GetNext;
    property Prev: TTibiaContainer read GetPrev;

    property Container: BInt32 read FContainer;
    property Slot: BInt32 read FSlot;
    property ContainerName: BStr read FContainerName;
    property Open: BBool read FOpen;
    property Capacity: BInt32 read FCapacity;
    property Items: BInt32 read FItems;
    property Icon: BInt32 read FIcon;
    property IsCorpse: BBool read GetIsCorpse;
    property IsDepotContainer: BBool read GetIsDepotContainer;
    property Checksum: BInt32 read GetChecksum;

    procedure Close;
    procedure Load;

    function PullHere(const AItem: TTibiaItem): TBBotContainerPushState; overload;
    function PullHere(const AItem: TTibiaItem; const ACount: BInt32): TBBotContainerPushState; overload;

    constructor Create(AContainer, ASlot: BInt32);
  end;

function ContainerAt(AContainer: BInt32): TTibiaContainer; overload;
function ContainerAt(AContainer, ASlot: BInt32): TTibiaContainer; overload;
function ContainerFirst: TTibiaContainer;
function ContainerLast: TTibiaContainer;
function ContainerFind(ID: BUInt32): TTibiaContainer;

function CountItem(ID: BUInt32): BInt32;
procedure BotCreateContainers;
procedure BotDestroyContainers;

implementation

uses
  Declaracoes,
  BBotEngine,
  Math,

  uTibiaDeclarations,
  uTibiaProcess,
  uTibiaState;

type
  TContainersData = record
    Containers: BInt32;
    Slots: BInt32;
    List: array of array of TTibiaContainer;
  end;

var
  Data: TContainersData;

const
  BBotContainerMoveTryAgain = -1;
  BBotContainerMoveError = -2;

procedure BotCreateContainers;
var
  A, B: BInt32;
begin
  Data.Containers := ContainerStateCount;
  Data.Slots := ContainerStateItems;
  SetLength(Data.List, Data.Containers);
  for A := 0 to Data.Containers - 1 do begin
    SetLength(Data.List[A], Data.Slots);
    for B := 0 to Data.Slots - 1 do
      Data.List[A, B] := TTibiaContainer.Create(A, B);
  end;
end;

procedure BotDestroyContainers;
var
  A, B: BInt32;
begin
  for A := 0 to Data.Containers - 1 do
    for B := 0 to Data.Slots - 1 do
      Data.List[A, B].Free;
end;

function ContainerAt(AContainer, ASlot: BInt32): TTibiaContainer;
begin
  Result := Data.List[AContainer, ASlot];
  Result.Load;
end;

function ContainerAt(AContainer: BInt32): TTibiaContainer; overload;
begin
  Result := ContainerAt(AContainer, 0);
end;

function ContainerFirst: TTibiaContainer;
begin
  Result := ContainerAt(0, 0);
  if Result <> nil then
    if not Result.Valid then
      Result := Result.Next;
end;

function ContainerLast: TTibiaContainer;
begin
  Result := ContainerAt(Data.Containers - 1, Data.Slots - 1);
  if Result <> nil then
    if not Result.Valid then
      Result := Result.Prev;
end;

function ContainerFind(ID: BUInt32): TTibiaContainer;
begin
  Result := ContainerFirst;
  while Result <> nil do begin
    if Result.ID = ID then
      Exit;
    Result := Result.Next;
  end;
  Result := nil;
end;

function CountItem(ID: BUInt32): BInt32;
var
  CT: TTibiaContainer;
  Slot: TTibiaSlot;
begin
  Result := 0;
  CT := ContainerFirst;
  while CT <> nil do begin
    if CT.ID = ID then
      Inc(Result, Max(CT.Count, 1));
    CT := CT.Next;
  end;
  for Slot := SlotFirst to SlotLast do
    if Me.Inventory.GetSlot(Slot).ID = ID then
      Inc(Result, Max(Me.Inventory.GetSlot(Slot).Count, 1));
end;

{ TTibiaContainer }

procedure TTibiaContainer.Close;
begin
  if Open then
    BBot.PacketSender.CloseContainer(Container);
end;

constructor TTibiaContainer.Create(AContainer, ASlot: BInt32);
begin
  inherited Create;
  FContainer := AContainer;
  FSlot := ASlot;
end;

destructor TTibiaContainer.Destroy;
begin

  inherited;
end;

function TTibiaContainer.GetChecksum: BInt32;
begin
  Result := CRC32(@TibiaState^.Container[FContainer], SizeOf(TibiaState^.Container[FContainer]));
end;

function TTibiaContainer.GetIsCorpse: boolean;
const
  Names: array [0 .. 5] of BStr = ('dead', 'slain', 'ashes', 'dust', 'split', 'remain');
var
  S: BStr;
  I: BInt32;
begin
  Result := False;
  S := LowerCase(ContainerName);
  for I := 0 to High(Names) do
    if AnsiPos(Names[I], S) > 0 then begin
      Result := True;
      Exit;
    end;
end;

function TTibiaContainer.GetIsDepotContainer: BBool;
const
  Names: array [0 .. 1] of BStr = ('locker', 'depot');
var
  S: BStr;
  I: BInt32;
begin
  Result := False;
  S := LowerCase(ContainerName);
  for I := 0 to High(Names) do
    if AnsiPos(Names[I], S) > 0 then begin
      Result := True;
      Exit;
    end;
end;

function TTibiaContainer.GetMoveSlot(const AItem: TTibiaItem): BInt32;
var
  CT: TTibiaContainer;
begin
  if not Open then
    Exit(BBotContainerMoveError);
  if Items = 0 then // Empty, random 4 first slots
    Exit(BRandom(0, BMin(3, Capacity - 1)));
  if AItem.IsStackable then // Stack items
  begin
    if (ID = AItem.ID) and (Count < 100) and (Position <> AItem.Position) then
      // Shortcut: current CT item
      Exit(Slot);
    CT := ContainerFirst;
    while (CT <> nil) and (CT.Container = Container) do begin
      if (CT.ID = AItem.ID) and (CT.Position <> AItem.Position) and (CT.Count < 100) then
        Exit(CT.Slot);
      CT := CT.Next;
    end;
  end;
  if Items = Capacity then // Full, open next
  begin
    CT := ContainerLast;
    while CT <> nil do begin
      if CT.IsContainer and (CT.Container = Container) then begin
        CT.Use;
        Exit(BBotContainerMoveTryAgain);
      end;
      CT := CT.Prev;
    end;
  end;
  if (not AItem.IsStackable) and (not IsContainer) and (Position <> AItem.Position) then
    Exit(Slot);
  CT := ContainerFirst; // First non-container item
  while CT <> nil do begin
    if (not CT.IsContainer) and (CT.Container = Container) and (CT.Position <> AItem.Position) then
      Exit(CT.Slot);
    CT := CT.Next;
  end;
  if Items < Capacity - 1 then // Random last empty slots
    Exit(BRandom(Items, Capacity - 1));
  Exit(BBotContainerMoveError);
end;

function TTibiaContainer.GetNext: TTibiaContainer;
var
  A, B, nSlots: BInt32;
begin
  Result := nil;
  if FSlot < (Data.Slots - 1) then begin
    A := FContainer;
    Data.List[A, 0].Load;
    nSlots := Data.List[A, 0].Items - 1;
    for B := FSlot + 1 to nSlots do begin
      Data.List[A, B].Load;
      if Data.List[A, B].Valid then begin
        Result := Data.List[A, B];
        Exit;
      end;
    end;
  end;
  if FContainer < (Data.Containers - 1) then begin
    for A := FContainer + 1 to (Data.Containers - 1) do begin
      Data.List[A, 0].Load;
      if Data.List[A, 0].Open then begin
        nSlots := Data.List[A, 0].Items - 1;
        for B := 0 to nSlots do begin
          Data.List[A, B].Load;
          if Data.List[A, B].Valid then begin
            Result := Data.List[A, B];
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TTibiaContainer.GetPrev: TTibiaContainer;
var
  A, B, nSlots: BInt32;
begin
  Result := nil;
  if FSlot > 0 then begin
    A := FContainer;
    for B := BMin(FSlot, FItems) - 1 downto 0 do begin
      Data.List[A, B].Load;
      if Data.List[A, B].Valid then begin
        Result := Data.List[A, B];
        Exit;
      end;
    end;
  end;
  if FContainer > 0 then begin
    for A := FContainer - 1 downto 0 do begin
      Data.List[A, 0].Load;
      if Data.List[A, 0].Open then begin
        nSlots := Data.List[A, 0].Items - 1;
        for B := nSlots downto 0 do begin
          Data.List[A, B].Load;
          if Data.List[A, B].Valid then begin
            Result := Data.List[A, B];
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TTibiaContainer.Load;
begin
  FIcon := TibiaState^.Container[FContainer].Icon;
  FCapacity := TibiaState^.Container[FContainer].Capacity;
  FItems := TibiaState^.Container[FContainer].Count;
  FContainerName := BStr(BPChar(@TibiaState^.Container[FContainer].Name[0]));
  FOpen := TibiaState^.Container[FContainer].Open;
  UnsetItem;
  if Open and (Items > 0) and (FSlot < Items) then
    SetItem(
      { ID } TibiaState^.Container[FContainer].Items[FSlot].ID,
      { Count } TibiaState^.Container[FContainer].Items[FSlot].Count,
      { Stack } FSlot,
      { Index } FContainer,
      { Pos } BPosXYZ($FFFF, FContainer + 64, FSlot))
  else
    UnsetItem;
end;

function TTibiaContainer.PullHere(const AItem: TTibiaItem): TBBotContainerPushState;
begin
  Exit(PullHere(AItem, AItem.Count));
end;

function TTibiaContainer.PullHere(const AItem: TTibiaItem; const ACount: BInt32): TBBotContainerPushState;
var
  ToPos: BPos;
begin
  if AItem.ID = ItemID_Creature then
    raise BException.Create('Trying to move creature into container');
  ToPos.X := BBotContainerPositionX;
  ToPos.Y := BBotContainerPositionYAdd + Container;
  ToPos.Z := GetMoveSlot(AItem);
  if ToPos.Z = BBotContainerMoveError then
    Exit(bcpsError)
  else if ToPos.Z = BBotContainerMoveTryAgain then
    Exit(bcpsTryAgain)
  else begin
    BBot.PacketSender.MoveItem(AItem.Position, AItem.ID, AItem.Stack, BMinMax(ACount, 0, AItem.Count), ToPos);
    Exit(bcpsSuccess);
  end;
end;

end.

