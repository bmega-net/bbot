unit uBBotSupliesStats;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  uBVector,
  uHUD,
  uBBotStats,
  uItem;

type
  TBBotSupliesStats = class(TBBotStatsAction)
  private type
    TSupliesStatsData = record
      Item: PTibiaItemData;
      Name: BStr;
      Count: BInt32;
      WastedExternalAdded: BBool;
      Wasted: BInt32;
    end;
  protected
    FWaste: BInt32;
    Data: BVector<TSupliesStatsData>;
    function GetSupply(AItem: BStr; AInitialCount: BInt32)
      : BVector<TSupliesStatsData>.It;
  public
    constructor Create(AStats: TBBotStats);
    destructor Destroy; override;

    procedure Reset; override;
    procedure ShowHUD; override;
    function Suplies(AItem: BStr): BInt32;
    procedure Update(AItem: BStr; ACount: BInt32);
    procedure AddWaste(AItem: BStr; AWaste: BInt32);

    property Waste: BInt32 read FWaste;
  end;

implementation

uses
  SysUtils;

function BStrStripInflaction(const AValue: BStr): BStr;
var
  S: BStr;
  C, E: BPChar;
begin
  if AValue = '' then
    Exit(AValue)
  else
  begin
    if BStrPos(' (', AValue) > 0 then
      S := BStrLeft(AValue, ' (')
    else
      S := AValue;
    Result := '';
    C := @S[1];
    E := @S[Length(S)];
    while C <= E do
    begin
      if not CharInSet(C^, ['s', 'i', 'e', 'y']) then
        Result := Result + C^;
      Inc(C);
    end;
  end;
end;

{ TBBotSupliesStats }

procedure TBBotSupliesStats.AddWaste(AItem: BStr; AWaste: BInt32);
var
  Supply: BVector<TSupliesStatsData>.It;
begin
  Supply := GetSupply(AItem, 0);
  Supply^.WastedExternalAdded := True;
  if Supply^.Count <> 0 then
    Dec(Supply^.Count, BMin(Supply^.Count, AWaste));
  Inc(Supply^.Wasted, AWaste);
end;

constructor TBBotSupliesStats.Create(AStats: TBBotStats);
begin
  inherited Create('Suplies', AStats, bhaLeft, bhaTop);
  FWaste := 0;
  Data := BVector<TSupliesStatsData>.Create;
end;

destructor TBBotSupliesStats.Destroy;
begin
  Data.Free;
  inherited;
end;

function TBBotSupliesStats.GetSupply(AItem: BStr; AInitialCount: BInt32)
  : BVector<TSupliesStatsData>.It;
var
  Supply: BVector<TSupliesStatsData>.It;
  ID: BUInt32;
  StrippedName: BStr;
begin
  StrippedName := BStrStripInflaction(AItem);
  Supply := Data.Find('SupliesStats get [' + AItem + ']',
    function(Iter: BVector<TSupliesStatsData>.It): BBool
    begin
      Result := BStrEqual(Iter^.Name, StrippedName);
    end);
  if Supply = nil then
  begin
    Supply := Data.Add;
    Supply^.Item := @TibiaItems[ItemID_Unknown];
    for ID := TibiaMinItems to TibiaLastItem do
      if BStrEqual(BStrStripInflaction(TibiaItems[ID].Name), StrippedName) then
      begin
        Supply^.Item := @TibiaItems[ID];
        Break;
      end;
    Supply^.Name := StrippedName;
    Supply^.Wasted := 0;
    Supply^.Count := AInitialCount;
    Supply^.WastedExternalAdded := False;
  end;
  Result := Supply;
end;

procedure TBBotSupliesStats.Reset;
begin
  FWaste := 0;
  Data.Clear;
end;

procedure TBBotSupliesStats.ShowHUD;
var
  HUD: TBBotHUD;
  PerHourFactor: BDbl;
  TotalWaste, Value: BInt32;
  S: BStr;
begin
  HUD := CreateHUD(bhgSupliesStats, 'Suplies Statistics', $FFFF00);
  TotalWaste := 0;
  if Data.Count > 0 then
  begin
    PerHourFactor := Stats.PerHourFactor;
    Data.ForEach(
      procedure(Iter: BVector<TSupliesStatsData>.It)
      begin
        S := BFormat('%dx %s', [Iter^.Count, Iter^.Item.Name]);
        if Iter^.Wasted <> 0 then
        begin
          S := BFormat('%s: -%d', [S, Iter^.Wasted]);
          if Iter^.Item.BuyPrice <> 0 then
          begin
            Value := Iter^.Wasted * Iter^.Item.BuyPrice;
            Inc(TotalWaste, Value);
            S := BFormat('%s (-%dg -%dg/hour)',
              [S, Value, BFloor(Value * PerHourFactor)]);
          end;
        end;
        HUD.PrintGray(S);
      end);
  end
  else
    HUD.PrintGray('None');
  FWaste := TotalWaste;
  HUD.Line;
  HUD.Free;
end;

function TBBotSupliesStats.Suplies(AItem: BStr): BInt32;
var
  Supply: BVector<TSupliesStatsData>.It;
begin
  Supply := Data.Find('SupliesStats query [' + AItem + ']',
    function(Iter: BVector<TSupliesStatsData>.It): BBool
    begin
      Result := BStrEqual(BStrStripInflaction(Iter^.Item.Name),
        BStrStripInflaction(AItem));
    end);
  Result := -1;
  if Supply <> nil then
    Exit(Supply^.Count);
end;

procedure TBBotSupliesStats.Update(AItem: BStr; ACount: BInt32);
var
  Supply: BVector<TSupliesStatsData>.It;
begin
  Supply := GetSupply(AItem, ACount);
  if (Supply^.Count > ACount) and (not Supply^.WastedExternalAdded) then
    Inc(Supply^.Wasted, Supply^.Count - ACount);
  Supply^.WastedExternalAdded := False;
  Supply^.Count := ACount;
end;

initialization

if BStrStripInflaction('mana potions') <> 'mana poton' then
  raise Exception.Create('Error Message');
if BStrStripInflaction('strong mana potions') <> 'trong mana poton' then
  raise Exception.Create('Error Message');
if BStrStripInflaction('gold coins') <> 'gold con' then
  raise Exception.Create('Error Message');

end.

