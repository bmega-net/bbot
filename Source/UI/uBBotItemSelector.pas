unit uBBotItemSelector;

interface

uses
  uBTypes,
  Generics.Collections,
  Controls,
  Graphics,
  StdCtrls,
  SysUtils,
  System.Types,
  Declaracoes,
  Windows,
  uBVector;

type
  TBBotItemSelector = class;

  TBBotItemSelectorApply = class
  private
    Combo: TCombobox;
    ItemSelector: TBBotItemSelector;
    FOnSelect: BBinaryProc<BUInt32, BStr>;
    FName: BStr;
    function GetID: BUInt32;
    function GetIsCustom: BBool;
    function GetText: BStr;
  protected
    procedure OnDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure OnChange(Sender: TObject);
    function Parse(const ACode: BStr): BPair<BUInt32, BStr>; overload;
    function Parse: BPair<BUInt32, BStr>; overload;
    procedure AskCustomItem;
    procedure SaveCustomItem(const AID: BUInt32);
    function CustomItemsFile: BStr;
    function hasItemID(const AID: BUInt32): BBool;
    function findItemIndex(const AID: BUInt32): BInt32;
  public
    constructor Create(const AItemSelector: TBBotItemSelector; const AName: BStr; const ACombo: TCombobox);
    destructor Destroy; override;

    function add(const AIDs: array of BUInt32): TBBotItemSelectorApply; overload;
    function add(const ATitle: BStr): TBBotItemSelectorApply; overload;
    function addCustomItemSelector(): TBBotItemSelectorApply;
    function addCustomItemSupport(): TBBotItemSelectorApply;
    function onSelect(const AOnSelect: BBinaryProc<BUInt32, BStr>): TBBotItemSelectorApply;
    function selectByIndex(const AIndex: BInt32): TBBotItemSelectorApply;
    function selectById(const AID: BInt32): TBBotItemSelectorApply;
    function selectFirst(): TBBotItemSelectorApply;
    function loadCustomItems(): TBBotItemSelectorApply;

    function loadValue(const AValue: BStr): TBBotItemSelectorApply;

    property Name: BStr read FName;
    property IsCustom: BBool read GetIsCustom;
    property ID: BUInt32 read GetID;
    property Text: BStr read GetText;

    property OnSelectHandler: BBinaryProc<BUInt32, BStr> read FOnSelect;
  end;

  TBBotItemSelector = class
  private
    Sprites: TObjectDictionary<BUInt32, TPicture>;
    Appliers: TObjectDictionary<BStr, TBBotItemSelectorApply>;
    function GetSprite(AID: BUInt32): TPicture;
  protected
    procedure LoadSprite(const AID: BUInt32; const APicture: TPicture);
    procedure LoadSprites;
  public
    constructor Create;
    destructor Destroy; override;

    property Sprite[AID: BUInt32]: TPicture read GetSprite;

    function Apply(const ACombo: TCombobox; const AName: BStr): TBBotItemSelectorApply; overload;
    function Apply(const ACombo: TCombobox): TBBotItemSelectorApply; overload;

    function HasApply(const ACombo: TCombobox): BBool;
    function FormatID(const AID: BInt32): BStr;
    function HasPrefix(const AValue: BStr): BBool;

    class function GetInstance: TBBotItemSelector;
  end;

implementation

uses
  uMain,

  uItem;

const
  SpritesDirectory = './Data/Sprites/';
  SpritesExt = '.png';
  SpritesFilePattern = SpritesDirectory + '*' + SpritesExt;
  ItemPrefix = '@Item';
  CustomPrefix = '@Custom';
  CustomID = BUInt32(MaxInt);
  CustomItem = 'select custom item';
  CustomItemsFilePattern = './Data/BBot.CustomItems.%s.txt';

var
  GlobalItemSelectorInstance: TBBotItemSelector = nil;

  { TBBotItemSelector }

function TBBotItemSelector.Apply(const ACombo: TCombobox; const AName: BStr): TBBotItemSelectorApply;
begin
  if not Appliers.TryGetValue(ACombo.Name, Result) then begin
    Result := TBBotItemSelectorApply.Create(Self, AName, ACombo);
    Appliers.add(ACombo.Name, Result);
  end;
end;

function TBBotItemSelector.Apply(const ACombo: TCombobox): TBBotItemSelectorApply;
begin
  Appliers.TryGetValue(ACombo.Name, Result);
end;

constructor TBBotItemSelector.Create;
begin
  Appliers := TObjectDictionary<BStr, TBBotItemSelectorApply>.Create([doOwnsValues]);
  Sprites := TObjectDictionary<BUInt32, TPicture>.Create([doOwnsValues]);
  LoadSprites;
end;

destructor TBBotItemSelector.Destroy;
begin
  Appliers.Free;
  Sprites.Free;
  if GlobalItemSelectorInstance = Self then
    GlobalItemSelectorInstance := nil;
  inherited;
end;

function TBBotItemSelector.FormatID(const AID: BInt32): BStr;
begin
  Result := ItemPrefix + ' ' + BToStr(AID);
end;

class function TBBotItemSelector.GetInstance: TBBotItemSelector;
begin
  if GlobalItemSelectorInstance = nil then
    GlobalItemSelectorInstance := TBBotItemSelector.Create;
  Exit(GlobalItemSelectorInstance);
end;

function TBBotItemSelector.GetSprite(AID: BUInt32): TPicture;
begin
  if not Sprites.TryGetValue(AID, Result) then
    Sprites.TryGetValue(0, Result);
end;

function TBBotItemSelector.HasApply(const ACombo: TCombobox): BBool;
begin
  Result := Appliers.ContainsKey(ACombo.Name);
end;

function TBBotItemSelector.HasPrefix(const AValue: BStr): BBool;
begin
  Result := BStrStart(AValue, ItemPrefix);
end;

procedure TBBotItemSelector.LoadSprite(const AID: BUInt32; const APicture: TPicture);
begin
  APicture.LoadFromFile(BFormat('%s%d%s', [SpritesDirectory, AID, SpritesExt]));
end;

procedure TBBotItemSelector.LoadSprites;
var
  Files: BStrArray;
  I: BInt32;
  ID: BUInt32;
  Pic: TPicture;
begin
  Files := ListFiles(SpritesFilePattern);
  for I := 0 to High(Files) do begin
    ID := BStrTo32(BStrLeft(Files[I], SpritesExt), MaxInt);
    if ID <> BUInt32(MaxInt) then begin
      Pic := TPicture.Create;
      LoadSprite(BUInt32(ID), Pic);
      Sprites.add(BUInt32(ID), Pic);
    end;
  end;
end;

{ TBBotItemSelectorApply }

function TBBotItemSelectorApply.add(const AIDs: array of BUInt32): TBBotItemSelectorApply;
var
  I: BInt32;
begin
  for I := 0 to High(AIDs) do
    Combo.AddItem(BFormat(ItemPrefix + ' %d', [AIDs[I]]), nil);
  Exit(Self);
end;

function TBBotItemSelectorApply.add(const ATitle: BStr): TBBotItemSelectorApply;
begin
  Combo.AddItem(BFormat(CustomPrefix + ' %s', [ATitle]), nil);
  Exit(Self);
end;

function TBBotItemSelectorApply.addCustomItemSelector: TBBotItemSelectorApply;
begin
  Exit(add(CustomItem));
end;

function TBBotItemSelectorApply.addCustomItemSupport: TBBotItemSelectorApply;
begin
  addCustomItemSelector;
  loadCustomItems;
  Exit(Self);
end;

procedure TBBotItemSelectorApply.AskCustomItem;
var
  Values: BStrArray;
  ID: BUInt32;
begin
  if GambitBox('Custom item', 'Please type a custom item ID', 'ID', False, Values) then begin
    ID := BStrTo32(Values[0], 0);
    if ID <> 0 then begin
      if not hasItemID(ID) then begin
        add(ID);
        SaveCustomItem(ID);
      end;
      selectById(ID);
    end;
  end;
end;

constructor TBBotItemSelectorApply.Create(const AItemSelector: TBBotItemSelector; const AName: BStr;
  const ACombo: TCombobox);
begin
  FOnSelect := nil;
  ItemSelector := AItemSelector;
  Combo := ACombo;
  FName := AName;

  ACombo.Style := csOwnerDrawVariable;
  ACombo.OnChange := OnChange;
  ACombo.OnDrawItem := OnDrawItem;
end;

function TBBotItemSelectorApply.CustomItemsFile: BStr;
begin
  Exit(BFormat(CustomItemsFilePattern, [Name]));
end;

destructor TBBotItemSelectorApply.Destroy;
begin
  Combo.OnChange := nil;
  Combo.OnDrawItem := nil;
  inherited;
end;

function TBBotItemSelectorApply.findItemIndex(const AID: BUInt32): BInt32;
var
  I: BInt32;
  P: BPair<BUInt32, BStr>;
begin
  for I := 0 to Combo.Items.Count - 1 do begin
    P := Parse(Combo.Items[I]);
    if (P.First <> CustomID) and (P.First = AID) then
      Exit(I);
  end;
  Exit(-1);
end;

function TBBotItemSelectorApply.GetID: BUInt32;
begin
  Exit(Parse.First);
end;

function TBBotItemSelectorApply.GetIsCustom: BBool;
begin
  Exit(GetID = CustomID);
end;

function TBBotItemSelectorApply.GetText: BStr;
begin
  Exit(Parse.Second);
end;

function TBBotItemSelectorApply.hasItemID(const AID: BUInt32): BBool;
begin
  Exit(findItemIndex(AID) <> -1);
end;

procedure TBBotItemSelectorApply.OnChange(Sender: TObject);
var
  Item: BPair<BUInt32, BStr>;
begin
  Item := Parse;
  if IsCustom and (Item.Second = CustomItem) then
    AskCustomItem;
  if Assigned(FOnSelect) then
    FOnSelect(Item.First, Item.Second);
end;

procedure TBBotItemSelectorApply.OnDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Item: BPair<BUInt32, BStr>;
  Pic: TPicture;
  IconRect: TRect;
begin

  Combo.Canvas.Brush.Color := clWhite;
  Combo.Canvas.FillRect(Rect);
  Combo.Canvas.Pen.Style := psClear;

  IconRect := TRect.Create(Rect.TopLeft);
  IconRect.Left := IconRect.Left + 1;
  IconRect.Right := IconRect.Left + Combo.ItemHeight;
  IconRect.Bottom := IconRect.Top + Combo.ItemHeight;

  Rect.Left := IconRect.Right;
  Item := Parse(Combo.Items[Index]);

  BListDrawItem(Combo.Canvas, Index, odSelected in State, Rect, Item.Second,
    BIf(Item.First <> CustomID, BToStr(Item.First), ''));
  Combo.Canvas.FillRect(IconRect);

  Pic := ItemSelector.Sprite[Item.First];
  Combo.Canvas.StretchDraw(IconRect, Pic.Graphic);
end;

function TBBotItemSelectorApply.Parse(const ACode: BStr): BPair<BUInt32, BStr>;
begin
  Result.First := 0;
  Result.Second := '';
  if BStrStartSensitive(ACode, ItemPrefix) then begin
    Result.First := BStrTo32(BStrRight(ACode, ItemPrefix), MaxInt);
    if Result.First <= TibiaMaxItems then
      Result.Second := TibiaItems[Result.First].Name
  end else if BStrStartSensitive(ACode, CustomPrefix) then begin
    Result.First := CustomID;
    Result.Second := BStrRight(ACode, CustomPrefix + ' ');
  end;
end;

function TBBotItemSelectorApply.Parse: BPair<BUInt32, BStr>;
begin
  Exit(Parse(Combo.Text));
end;

function TBBotItemSelectorApply.loadCustomItems: TBBotItemSelectorApply;
var
  Buffer: BStr;
  L: BStrArray;
  I: BInt32;
  ID: BUInt32;
begin
  Buffer := BFileGet(CustomItemsFile);
  if BStrSplit(L, BStrLine, Buffer) > 0 then
    for I := 0 to High(L) do begin
      ID := BStrTo32(L[I], 0);
      if ID <> 0 then
        if not hasItemID(ID) then
          add([ID]);
    end;
  Exit(Self);
end;

function TBBotItemSelectorApply.loadValue(const AValue: BStr): TBBotItemSelectorApply;
begin
  selectById(Parse(AValue).First);
  Exit(Self);
end;

procedure TBBotItemSelectorApply.SaveCustomItem(const AID: BUInt32);
begin
  BFileAppend(CustomItemsFile, BToStr(AID));
end;

function TBBotItemSelectorApply.onSelect(const AOnSelect: BBinaryProc<BUInt32, BStr>): TBBotItemSelectorApply;
begin
  FOnSelect := AOnSelect;
  Exit(Self);
end;

function TBBotItemSelectorApply.selectByIndex(const AIndex: BInt32): TBBotItemSelectorApply;
begin
  Combo.ItemIndex := AIndex;
  Exit(Self);
end;

function TBBotItemSelectorApply.selectFirst: TBBotItemSelectorApply;
begin
  Exit(selectByIndex(0));
end;

function TBBotItemSelectorApply.selectById(const AID: BInt32): TBBotItemSelectorApply;
var
  Index: BInt32;
begin
  Index := findItemIndex(AID);
  if Index <> -1 then
    selectByIndex(Index);
  Exit(Self);
end;

end.
