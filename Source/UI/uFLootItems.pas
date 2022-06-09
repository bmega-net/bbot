unit uFLootItems;

interface

uses
  uBTypes,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  StdCtrls,
  StrUtils,
  ExtCtrls;

type
  TSearchSaveItem = record
    Title: BStr;
    ID: BInt32;
  end;

  TSearchSaveItems = array of TSearchSaveItem;

  TFLootItems = class(TForm)
    Button1: TButton;
    chkDrop: TCheckBox;
    cmbSetBP: TComboBox;
    Label3: TLabel;
    lstItems: TListView;
    lstLoot: TListView;
    MovLoot: TButton;
    MovNLoot: TButton;
    txtSearch: TEdit;
    chkDeposit: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    numMinCap: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chkDropClick(Sender: TObject);
    procedure cmbSetBPDropDown(Sender: TObject);
    procedure cmbSetBPSelect(Sender: TObject);
    procedure lstItemsAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure lstItemsAdvancedCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
      State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure lstLootAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure lstLootAdvancedCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
      State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure MovLootClick(Sender: TObject);
    procedure MovNLootClick(Sender: TObject);
    procedure txtSearchEnter(Sender: TObject);
    procedure txtSearchExit(Sender: TObject);
    procedure txtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkDepositClick(Sender: TObject);
    procedure numMinCapKeyPress(Sender: TObject; var Key: Char);
    procedure numMinCapChange(Sender: TObject);
  public
    { Public declarations }
    SaveItems: TSearchSaveItems;
    SearchI: BInt32;
    SearchLower: BStr;
    function Save: BStr;
    procedure Load(S: BStr);
    procedure GenerateItemsList;
  end;

var
  FLootItems: TFLootItems;
  IsUpdating: Boolean;

procedure MakeUpdate(Updating: Boolean);

implementation

uses
  uItem,
  uContainer,
  uTibiaDeclarations,

  uBBotLooter;

{$R *.dfm}

procedure doSearch(SearchFor: BStr; var SaveItemsOn: TSearchSaveItems; ListItems: TListItems);
  procedure AddItem(A: BStr; B: BInt32);
  begin
    with ListItems.Add do begin
      Caption := A;
      SubItems.Add(IntToStr(B));
    end;
  end;

var
  I: BInt32;
begin
  MakeUpdate(True);
  if SearchFor = '' then begin
    for I := 0 to High(SaveItemsOn) do
      AddItem(SaveItemsOn[I].Title, SaveItemsOn[I].ID);
    SetLength(SaveItemsOn, 0);
  end else begin
    SearchFor := LowerCase(SearchFor);
    if High(SaveItemsOn) <> -1 then
      for I := High(SaveItemsOn) downto 0 do
        if AnsiPos(SearchFor, LowerCase(SaveItemsOn[I].Title + IntToStr(SaveItemsOn[I].ID))) > 0 then begin
          AddItem(SaveItemsOn[I].Title, SaveItemsOn[I].ID);
          if High(SaveItemsOn) > I then begin
            SaveItemsOn[I].Title := SaveItemsOn[High(SaveItemsOn)].Title;
            SaveItemsOn[I].ID := SaveItemsOn[High(SaveItemsOn)].ID;
          end;
          SetLength(SaveItemsOn, High(SaveItemsOn));
        end;
    for I := ListItems.Count - 1 downto 0 do
      if not(Pos(SearchFor, LowerCase(ListItems.Item[I].Caption + ListItems.Item[I].SubItems[0])) > 0) then begin
        SetLength(SaveItemsOn, High(SaveItemsOn) + 2);
        SaveItemsOn[High(SaveItemsOn)].Title := ListItems.Item[I].Caption;
        SaveItemsOn[High(SaveItemsOn)].ID := StrToInt(ListItems.Item[I].SubItems[0]);
        ListItems.Item[I].Delete;
      end;
  end;
  MakeUpdate(False);
end;

procedure MakeUpdate(Updating: Boolean);
begin
  if Updating then begin
    FLootItems.lstLoot.Items.BeginUpdate;
    FLootItems.lstItems.Items.BeginUpdate;
  end else begin
    FLootItems.lstLoot.Items.EndUpdate;
    FLootItems.lstItems.Items.EndUpdate;
  end;
  IsUpdating := Updating;
end;

procedure TFLootItems.FormCreate(Sender: TObject);
begin
  numMinCap.Text := '30';
  SetLength(SaveItems, 0);
  GenerateItemsList;
end;

procedure TFLootItems.Button1Click(Sender: TObject);
begin
  FLootItems.Hide;
end;

procedure TFLootItems.chkDropClick(Sender: TObject);
var
  I: BInt32;
begin
  for I := lstLoot.Items.Count - 1 downto 0 do begin
    if lstLoot.Items[I].Selected then begin
      lstLoot.Items[I].SubItems[1] := Ifthen(chkDrop.Checked, 'Yes', 'No');
      TibiaItems[StrToInt(lstLoot.Items[I].SubItems[4])].Loot.Dropable := chkDrop.Checked;
    end;
  end;
end;

procedure TFLootItems.cmbSetBPDropDown(Sender: TObject);
var
  B: BInt32;
  I: BInt32;
  BS: BStr;
begin
  cmbSetBP.Clear;
  BS := 'Ground';
  B := Length(BS);

  for I := 0 to 15 do
    if ContainerAt(I, 0).Open then begin
      cmbSetBP.AddItem(IntToStr(ContainerAt(I, 0).Container + 1) + '. ' + ContainerAt(I, 0).ContainerName,
        TObject(ContainerAt(I, 0).Container + 1));
      if Length(ContainerAt(I, 0).ContainerName) > B then begin
        B := Length(ContainerAt(I, 0).ContainerName);
        BS := ContainerAt(I, 0).ContainerName;
      end;
    end;

  cmbSetBP.AddItem('Ground', TObject(BBotLooterToGround));

  B := cmbSetBP.Canvas.TextWidth(BS);
  Inc(B, GetSystemMetrics(SM_CXVSCROLL));
  SendMessage(cmbSetBP.Handle, CB_SETDROPPEDWIDTH, B, 0);

end;

procedure TFLootItems.cmbSetBPSelect(Sender: TObject);
var
  I, bp: BInt32;
begin
  bp := BInt32(cmbSetBP.Items.Objects[cmbSetBP.ItemIndex]);
  if (bp >= 1) AND (bp <= BBotLooterToGround) then begin
    for I := lstLoot.Items.Count - 1 downto 0 do begin
      if lstLoot.Items[I].Selected then begin
        lstLoot.Items[I].SubItems[0] := IntToStr(bp);
        TibiaItems[StrToInt(lstLoot.Items[I].SubItems[4])].Loot.Target := bp;
      end;
    end;
  end;
end;

procedure TFLootItems.Load(S: BStr);
var
  I, ID, bp, Drop, Deposit, LootMinCap: BInt32;
  L, R: BStrArray;
begin

  doSearch(txtSearch.Text, SaveItems, lstItems.Items);
  lstLoot.SelectAll;
  MovNLootClick(MovNLoot);

  MakeUpdate(True);

  if BStrSplit(L, #13#10, S) > 0 then
    for I := 0 to High(L) do
      if BStrSplit(R, ':', L[I]) >= 4 then begin
        ID := StrToIntDef(R[0], -1);
        bp := StrToIntDef(R[1], -1);
        Drop := StrToIntDef(R[2], -1);
        Deposit := StrToIntDef(R[3], -1);
        if High(R) = 3 then
          LootMinCap := 0
        else
          LootMinCap := StrToIntDef(R[4], -1);
        if (ID = -1) or (bp = -1) or (Drop = -1) or (Deposit = -1) or (LootMinCap = -1) then
          Continue;
        with lstLoot.Items.Add do begin
          Caption := TibiaItems[ID].Name;
          SubItems.Add(IntToStr(bp));
          SubItems.Add(Ifthen((Drop = 1), 'Yes', 'No'));
          SubItems.Add(Ifthen((Deposit = 1), 'Yes', 'No'));
          SubItems.Add(IntToStr(LootMinCap));
          SubItems.Add(IntToStr(ID));
        end;
        TibiaItems[ID].Loot.Target := bp;
        TibiaItems[ID].Loot.Dropable := (Drop = 1);
        TibiaItems[ID].Loot.Depositable := (Deposit = 1);
        TibiaItems[ID].Loot.MinCap := LootMinCap;
      end;
  MakeUpdate(False);

end;

procedure TFLootItems.lstItemsAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if Odd(Item.Index) then
    lstItems.Canvas.Brush.Color := $DBDBDB
  else
    lstItems.Canvas.Brush.Color := clWhite;

  if SearchLower <> '' then
    if AnsiPos(SearchLower, AnsiLowerCase(Item.Caption + ' ' + Item.SubItems[0])) > 0 then
      lstItems.Canvas.Font.Style := [fsBold]
    else
      lstItems.Canvas.Font.Style := [];
end;

procedure TFLootItems.lstItemsAdvancedCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: BInt32;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin

  if Odd(Item.Index) then
    lstItems.Canvas.Brush.Color := $DBDBDB
  else
    lstItems.Canvas.Brush.Color := clWhite;

  if SearchLower <> '' then
    if AnsiPos(SearchLower, AnsiLowerCase(Item.Caption + ' ' + Item.SubItems[0])) > 0 then
      lstItems.Canvas.Font.Style := [fsBold]
    else
      lstItems.Canvas.Font.Style := [];

end;

procedure TFLootItems.lstLootAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin

  if Odd(Item.Index) then
    lstLoot.Canvas.Brush.Color := $DBDBDB
  else
    lstLoot.Canvas.Brush.Color := clWhite;

end;

procedure TFLootItems.lstLootAdvancedCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: BInt32;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin

  if Odd(Item.Index) then
    lstLoot.Canvas.Brush.Color := $DBDBDB
  else
    lstLoot.Canvas.Brush.Color := clWhite;

end;

procedure TFLootItems.MovLootClick(Sender: TObject);
var
  I: BInt32;
begin
  MakeUpdate(True);
  for I := lstItems.Items.Count - 1 downto 0 do begin
    if lstItems.Items[I].Selected then begin
      with lstLoot.Items.Add do begin
        Caption := lstItems.Items[I].Caption;
        SubItems.Add('1');
        SubItems.Add('No');
        SubItems.Add('Yes');
        SubItems.Add('0');
        SubItems.Add(lstItems.Items[I].SubItems[0]);
      end;
      TibiaItems[StrToInt(lstItems.Items[I].SubItems[0])].Loot.Target := 1;
      TibiaItems[StrToInt(lstItems.Items[I].SubItems[0])].Loot.Dropable := False;
      TibiaItems[StrToInt(lstItems.Items[I].SubItems[0])].Loot.Depositable := True;
      TibiaItems[StrToInt(lstItems.Items[I].SubItems[0])].Loot.MinCap := 0;
    end;
  end;
  MakeUpdate(False);
end;

procedure TFLootItems.MovNLootClick(Sender: TObject);
var
  I: BInt32;
begin
  MakeUpdate(True);
  for I := lstLoot.Items.Count - 1 downto 0 do begin
    if lstLoot.Items[I].Selected then begin
      TibiaItems[StrToInt(lstLoot.Items[I].SubItems[4])].Loot.Target := 0;
      TibiaItems[StrToInt(lstLoot.Items[I].SubItems[4])].Loot.Dropable := False;
      lstLoot.Items.Delete(I);
    end;
  end;
  MakeUpdate(False);
end;

procedure TFLootItems.numMinCapChange(Sender: TObject);
var
  I: BInt32;
begin
  for I := lstLoot.Items.Count - 1 downto 0 do begin
    if lstLoot.Items[I].Selected then begin
      TibiaItems[StrToInt(lstLoot.Items[I].SubItems[4])].Loot.MinCap := BStrTo32(numMinCap.Text, 0);
      lstLoot.Items[I].SubItems[3] := BFormat('%d', [BStrTo32(numMinCap.Text, 0)]);
    end;
  end;
end;

procedure TFLootItems.numMinCapKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, [#8, '0' .. '9']) then
    Exit;
  Key := #0;
end;

function TFLootItems.Save: BStr;
var
  I, ID, bp, Drop, Deposit, LootMinCap: BInt32;
begin
  Result := '';
  for I := lstLoot.Items.Count - 1 downto 0 do begin
    ID := StrToInt(lstLoot.Items[I].SubItems[4]);
    bp := StrToInt(lstLoot.Items[I].SubItems[0]);
    Drop := StrToInt(Ifthen(AnsiSameText(lstLoot.Items[I].SubItems[1], 'No'), '0', '1'));
    Deposit := StrToInt(Ifthen(AnsiSameText(lstLoot.Items[I].SubItems[2], 'No'), '0', '1'));
    LootMinCap := StrToInt(lstLoot.Items[I].SubItems[3]);
    Result := Result + Ifthen(Result <> '', #13#10, '') + Format('%d:%d:%d:%d:%d', [ID, bp, Drop, Deposit, LootMinCap]);
  end;
end;

procedure TFLootItems.GenerateItemsList;
var
  I: BInt32;
begin
  lstItems.Items.BeginUpdate;
  for I := TibiaMinItems to TibiaLastItem do begin
    if (idfPickupable in TibiaItems[I].DatFlags) then begin
      with lstItems.Items.Add do begin
        Caption := TibiaItems[I].Name;
        SubItems.Add(IntToStr(I));
      end;
    end;
  end;
  lstItems.Items.EndUpdate;
end;

procedure TFLootItems.txtSearchEnter(Sender: TObject);
begin
  if txtSearch.Font.Color = $969696 then begin
    txtSearch.Text := '';
    txtSearch.Font.Color := $000000;
  end;
end;

procedure TFLootItems.txtSearchExit(Sender: TObject);
begin
  if (txtSearch.Font.Color = $000000) and (txtSearch.Text = '') then begin
    txtSearch.Text := 'Search...';
    txtSearch.Font.Color := $969696;
  end;
end;

procedure TFLootItems.txtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if not IsUpdating then
      doSearch(txtSearch.Text, SaveItems, lstItems.Items);
end;

procedure TFLootItems.chkDepositClick(Sender: TObject);
var
  I: BInt32;
begin
  for I := lstLoot.Items.Count - 1 downto 0 do begin
    if lstLoot.Items[I].Selected then begin
      lstLoot.Items[I].SubItems[2] := Ifthen(chkDeposit.Checked, 'Yes', 'No');
      TibiaItems[StrToInt(lstLoot.Items[I].SubItems[4])].Loot.Depositable := chkDeposit.Checked;
    end;
  end;
end;

end.
