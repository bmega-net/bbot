unit uBBotFishing;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotFishing = class(TBBotAction)
  private
    FEnabled: BBool;
    FCapacity: BInt32;
    FWorms: BBool;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;
    property Capacity: BInt32 read FCapacity write FCapacity;
    property Worms: BBool read FWorms write FWorms;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTiles,
  uTibiaDeclarations,
  uContainer;

{ TBBotFishing }

constructor TBBotFishing.Create;
begin
  inherited Create('Fishing', 900);
  FEnabled := False;
  FCapacity := 10;
  FWorms := False;
end;

procedure TBBotFishing.Run;
var
  Map: TTibiaTiles;
  Tries: BInt32;
begin
  if Enabled then
    if (Capacity * 100) < Me.Capacity then
      if (Worms and (CountItem(ItemID_Worm) > 0)) or (not Worms) then
        for Tries := 0 to 5 do
          if Tiles(Map, Me.Position.X + BRandom(-7, +7), Me.Position.Y + BRandom(-5, 5)) then
            if Map.ItemsOnTile = 1 then
              if BInRange(Map.ID, ItemID_Water1From, ItemID_Water1To) or
                BInRange(Map.ID, ItemID_Water2From, ItemID_Water2To) then begin
                Map.UseOn(ItemID_FishingRod);
                Exit;
              end;

end;

end.
