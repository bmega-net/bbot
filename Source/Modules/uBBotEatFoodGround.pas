unit uBBotEatFoodGround;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotEatFoodGround = class(TBBotAction)
  private
    FEnabled: BBool;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTiles;

{ TBBotEatFoodGround }

constructor TBBotEatFoodGround.Create;
begin
  inherited Create('Eat Food Ground', 12000);
  FEnabled := False;
end;

procedure TBBotEatFoodGround.Run;
var
  Map: TTibiaTiles;
begin
  if Enabled then
    if TilesSearch(Map, Me.Position, 1, True,
      function: BBool
      begin
        Result := Map.IsFood;
      end) then
      Map.Use;
end;

end.

