unit uBBotAutoRope;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotAutoRope = class(TBBotAction)
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

{ TBBotAutoRope }

constructor TBBotAutoRope.Create;
begin
  inherited Create('Auto Rope', 100);
  FEnabled := False;
end;

procedure TBBotAutoRope.Run;
var
  Map: TTibiaTiles;
  X, Y: BInt32;
begin
  if Enabled then begin
    for X := -1 to 1 do
      for Y := -1 to 1 do
        if Tiles(Map, X + Me.Position.X, Y + Me.Position.Y) then
          if Map.ChangeLevelDown then begin
            Map.UseOn(BBot.CaveBot.Rope);
            Exit;
          end;
  end;
end;

end.
