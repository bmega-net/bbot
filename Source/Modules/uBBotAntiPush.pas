unit uBBotAntiPush;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotAntiPush = class(TBBotAction)
  private
    FEnabled: BBool;
    LastPushedID: BUInt32;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uContainer,
  uTiles,
  Declaracoes,
  Math;

{ TBBotAntiPush }

constructor TBBotAntiPush.Create;
begin
  inherited Create('Anti Push', 100);
  FEnabled := False;
end;

procedure TBBotAntiPush.Run;
const
  TrashItems: array [0 .. 4] of BUInt32 = (3031, 3492, 283, 284, 285);
var
  CT: TTibiaContainer;
  Map: TTibiaTiles;
begin
  if Enabled then
  begin
    if Tiles(Map, Me.Position) then
      if Map.ItemsOnTile > 7 then
        Exit;
    CT := ContainerFirst;
    while CT <> nil do
    begin
      if IntIn(CT.ID, TrashItems) and (CT.ID <> LastPushedID) then
      begin
        CT.ToGround(Me.Position, Min(CT.Count, 2));
        LastPushedID := CT.ID;
        Exit;
      end;
      CT := CT.Next;
    end;
  end;
end;

end.

