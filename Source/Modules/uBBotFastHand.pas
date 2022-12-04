unit uBBotFastHand;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotFastHand = class(TBBotAction)
  private
    FEnabled: BBool;
    LastSelfPosition: BPos;
    LastDepotPosition: BPos;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTiles;

{ TBBotFastHand }

constructor TBBotFastHand.Create;
begin
  inherited Create('Fast Hand', 100);
  FEnabled := False;
end;

procedure TBBotFastHand.Run;
var
  Map: TTibiaTiles;
  X, Y: BInt32;
begin
  if Enabled then
  begin
    if Me.Position = LastSelfPosition then
    begin
      for X := -1 to +1 do
        for Y := -1 to +1 do
          if Tiles(Map, Me.Position.X + X, Me.Position.Y + Y) then
            if Map.IsPickupable then
              Map.ToGround(LastDepotPosition);
    end
    else
    begin
      for X := -1 to +1 do
        for Y := -1 to +1 do
          if Tiles(Map, Me.Position.X + X, Me.Position.Y + Y) then
            if Map.IsDepot then
            begin
              LastSelfPosition := Me.Position;
              LastDepotPosition := Map.Position;
            end;
    end;
  end;
end;

end.

