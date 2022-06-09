unit uItemLoader;

interface

uses
  uBTypes,
  uItem,
  uTibiaDeclarations;

procedure LoadItems;

var
  ItemsFirePoison: array of BUInt32 = nil;
  ItemsFurnitures: array of BUInt32 = nil;

implementation

uses

  SysUtils,
  uBBotSpells,

  Dialogs,
  Windows,
  uBBotAddresses,

  uTibiaProcess,
  Classes,
  Graphics,
  Math,
  jpeg,
  uTiles,
  uTibiaState;

procedure AddItemBotFlag(const AID: BUInt32; AFlag: TTibiaItemBotFlags); inline;
begin
  if BInRange(AID, 0, TibiaMaxItems) then
  begin
    TibiaItems[AID].BotFlags := TibiaItems[AID].BotFlags + AFlag;
    TibiaLastItem := BMax(TibiaLastItem, AID);
  end
  else
    raise BException.Create(BFormat('Item ID out of range AIBF(%d)', [AID]));
end;

procedure AddItemsRings(const AIDs: array of BUInt32);
var
  I: BUInt32;
begin
  I := Low(AIDs);
  while I < BUInt32(High(AIDs)) do
  begin
    if BInRange(AIDs[I], BUInt32(0), TibiaMaxItems) then
    begin
      AddItemBotFlag(AIDs[I], [idfRing]);
      TibiaItems[AIDs[I]].RingID := AIDs[I + 1];
      Inc(I, 2);
    end
    else
      raise BException.Create(BFormat('Item ID out of range in AIR(%d)',
        [AIDs[I]]));
  end;
end;

procedure ReadItemIDs(Text: BStr; Action: BUnaryProc<BUInt32>);
var
  Items: BStrArray;
  I, ID: BUInt32;
begin
  if BStrSplit(Items, ' ', Text) > 0 then
    for I := 0 to High(Items) do
    begin
      ID := BStrToU32(Items[I], 0);
      if ID <> 0 then
        Action(ID);
    end;
end;

procedure ReadItemRampUp(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfChangeLevelUP, idfChangeLevel]);
    end);
end;

procedure ReadItemRampDown(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfChangeLevelDown, idfChangeLevel]);
    end);
end;

procedure ReadItemShovel(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfChangeLevelShovel, idfChangeLevelDown,
        idfChangeLevel]);
    end);
end;

procedure ReadItemSewer(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfChangeLevelHole, idfChangeLevelDown,
        idfChangeLevel]);
    end);
end;

procedure ReadItemTeleport(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfTeleport, idfChangeLevel]);
    end);
end;

procedure ReadItemRope(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfChangeLevelRope, idfChangeLevelUP,
        idfChangeLevel]);
    end);
end;

procedure ReadItemLadder(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfChangeLevelLadder, idfChangeLevelUP,
        idfChangeLevel]);
    end);
end;

procedure ReadItemHostile(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfCausesHostileExhaust]);
    end);
end;

procedure ReadItemDefensive(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfCausesDefensiveExhaust]);
    end);
end;

procedure ReadItemPotion(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfCausesPotionExhaust, idfCausesDefensiveExhaust]);
    end);
end;

procedure ReadItemFood(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfFood]);
    end);
end;

procedure ReadItemDepot(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      AddItemBotFlag(ID, [idfDepot]);
    end);
end;

procedure ReadItemNaturalFields(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      SetLength(ItemsFirePoison, Length(ItemsFirePoison) + 1);
      ItemsFirePoison[High(ItemsFirePoison)] := ID;
    end);
end;

procedure ReadItemFurnitures(Line: BUInt32; Text: BStr);
begin
  ReadItemIDs(Text,
    procedure(ID: BUInt32)
    begin
      SetLength(ItemsFurnitures, Length(ItemsFurnitures) + 1);
      ItemsFurnitures[High(ItemsFurnitures)] := ID;
    end);
end;

procedure ReadItemRings(Line: BUInt32; Text: BStr);
var
  Items: BStrArray;
  IDs: array of BUInt32;
  I: BUInt32;
begin
  if BStrSplit(Items, ' ', Text) > 0 then
  begin
    if (Length(Items) mod 2) <> 0 then
      raise BException.Create('Ring lines must have pairs of values');
    SetLength(IDs, Length(Items));
    for I := 0 to High(Items) do
    begin
      IDs[I] := BStrToU32(Items[I], 0);
      if IDs[I] = 0 then
        raise BException.Create('Unable to read Ring');
    end;
    AddItemsRings(IDs);
  end;
end;

procedure ReadItemProperties(Line: BUInt32; Text: BStr);
var
  ID: BUInt32;
  Item: BStrArray;
begin
  if BStrSplit(Item, ',', Text) = 6 then
  begin
    try
      ID := BStrToU32(Item[0]);
      BUInt32(TibiaItems[ID].DatFlags) := BStrToU32(Item[1]);
      if idfNotWalkable in TibiaItems[ID].DatFlags then
        TibiaItems[ID].Walkable := iwNotWalkable;
      TibiaItems[ID].Weight := BStrTo32(Item[2]);
      TibiaItems[ID].BuyPrice := BStrTo32(Item[3]);
      TibiaItems[ID].SellValue := BStrTo32(Item[4]);
      TibiaItems[ID].Name := BTrim(Item[5]);
      TibiaLastItem := BMax(TibiaLastItem, ID);
    except
      raise BException.CreateFmt('Error reading ItemProperties on line %d: %s',
        [Line, Text]);
    end;
  end
end;

function GetTibiaReaderForVersion(Text: BStr): BBinaryProc<BUInt32, BStr>;
var
  Version: TTibiaVersion;
begin
  Result := nil;
  for Version := TibiaVerFirst to TibiaVerLast do
    if BStrEnd(Text, BotVerSupported[Version]) then
      if Version <= AdrSelected then
        Result := ReadItemProperties;
end;

procedure LoadItemsFromFile(const AFile: BStr);
var
  FileHandle: TextFile;
  LineText: BStr;
  LineNum: BUInt32;
  LineSection: BStr;
  Reader: BBinaryProc<BUInt32, BStr>;
begin
  AssignFile(FileHandle, AFile);
  try
    Reset(FileHandle);
    LineNum := 0;
    Reader := nil;
    while not EOF(FileHandle) do
    begin
      Inc(LineNum);
      ReadLn(FileHandle, LineText);
      LineText := BTrim(LineText);
      if (LineText <> '') and (LineText[1] <> '#') then
      begin
        if LineText[1] = '@' then
        begin
          LineSection := LineText;
          if BStrStartSensitive(LineSection, '@Teleport') then
            Reader := ReadItemTeleport
          else if BStrStartSensitive(LineSection, '@Shovel') then
            Reader := ReadItemShovel
          else if BStrStartSensitive(LineSection, '@Rope') then
            Reader := ReadItemRope
          else if BStrStartSensitive(LineSection, '@Sewer') then
            Reader := ReadItemSewer
          else if BStrStartSensitive(LineSection, '@Ladder') then
            Reader := ReadItemLadder
          else if BStrStartSensitive(LineSection, '@RampUp') then
            Reader := ReadItemRampUp
          else if BStrStartSensitive(LineSection, '@RampDown') then
            Reader := ReadItemRampDown
          else if BStrStartSensitive(LineSection, '@Depot') then
            Reader := ReadItemDepot
          else if BStrStartSensitive(LineSection, '@HostileExhaust') then
            Reader := ReadItemHostile
          else if BStrStartSensitive(LineSection, '@DefensiveExhaust') then
            Reader := ReadItemDefensive
          else if BStrStartSensitive(LineSection, '@PotionExhaust') then
            Reader := ReadItemPotion
          else if BStrStartSensitive(LineSection, '@Food') then
            Reader := ReadItemFood
          else if BStrStartSensitive(LineSection, '@Rings') then
            Reader := ReadItemRings
          else if BStrStartSensitive(LineSection, '@NaturalFields') then
            Reader := ReadItemNaturalFields
          else if BStrStartSensitive(LineSection, '@Furnitures') then
            Reader := ReadItemFurnitures
          else if BStrStartSensitive(LineSection, '@TibiaVersion') then
            Reader := GetTibiaReaderForVersion(LineText)
          else
            raise BException.Create('Unknown Properties section: ' +
              LineSection);
        end
        else if Assigned(Reader) then
          try
            Reader(LineNum, LineText);
          except
            on E: Exception do
              raise BException.CreateFmt
                ('Error on loading properties %s at line %d (%s): %s',
                [LineSection, LineNum, LineText, E.Message]);
          end;
      end;
    end;
    CloseFile(FileHandle);
  except
    on E: Exception do
      raise BException.Create('Error loading BBot.Items:' + BStrLine +
        E.Message);
  end;
end;

procedure LoadItemsFile;
const
  ItemsFile = './Data/BBot.Items.txt';
  CustomItemsFile = './Data/BBot.CustomItems.txt';
begin
  if SizeOf(TTibiaItemDatFlags) <> 4 then
    raise BException.Create('CRITICAL, TibiaDatFlags <> BUInt32');
  if not BFileExists(ItemsFile) then
    raise BException.Create('BBot Items file not found!');
  LoadItemsFromFile(ItemsFile);
  if BFileExists(CustomItemsFile) then
    LoadItemsFromFile(CustomItemsFile);
end;

procedure LoadItems;
var
  I: BUInt32;
begin
  ZeroMemory(@TibiaItems, SizeOf(TibiaItems));
  TibiaLastItem := 0;
  LoadItemsFile;
  for I := 0 to TibiaMaxItems do
  begin
    if idfPickupable in TibiaItems[I].DatFlags then
      if TibiaItems[I].Name = '' then
        TibiaItems[I].Name := BFormat('zzzzz~id:%d', [I]);
  end;
  TibiaItems[ItemID_Creature].Name := 'Creature';
  TibiaItems[ItemID_Creature].Weight := 0;
   TibiaItems[ItemID_Creature].BuyPrice := 0;
  TibiaItems[ItemID_Creature].SellValue := 0;
  TibiaItems[ItemID_Creature].DatFlags := [];
  TibiaItems[ItemID_Creature].BotFlags := [];
  TibiaItems[ItemID_Unknown] := TibiaItems[ItemID_Creature];
  TibiaItems[ItemID_Unknown].Name := '???';

  if TibiaLastItem < 1000 then
    raise Exception.Create
      ('Database (BBot.Items.txt) error, please reinstall.');

  SetItemsWalkable([ItemID_Creature], iwNotWalkable);
  SetItemsWalkable(ItemsFirePoison, iwNotWalkable);
  SetItemsWalkable(ItemsFurnitures, iwNotWalkable);
end;

end.
