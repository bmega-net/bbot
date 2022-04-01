unit uBBotBagLootKicker;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotLootBagKicker = class(TBBotAction)
  private
    FEnabled: BBool;
    KickFrom: BPos;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnWalk(FromPos: BPos);
  end;

implementation

uses
  BBotEngine,
  uTiles;

{ TBBotLootBagKicker }

constructor TBBotLootBagKicker.Create;
begin
  inherited Create('Loot Bag Kicker', 100);
  FEnabled := False;
end;

procedure TBBotLootBagKicker.OnInit;
begin
  inherited;
  BBot.Events.OnWalk.Add(OnWalk);
end;

procedure TBBotLootBagKicker.OnWalk(FromPos: BPos);
begin
  KickFrom := FromPos;
end;

procedure TBBotLootBagKicker.Run;
var
  Map: TTibiaTiles;
begin
  if Enabled then begin
    if Me.DistanceTo(KickFrom) <> 0 then begin
      if Me.DistanceTo(KickFrom) = 1 then
        if Tiles(Map, KickFrom.X, KickFrom.Y) then
          if Map.IsContainer then
            Map.ToGround(Me.Position, -1);
      KickFrom := Me.Position;
    end;
  end;
end;

end.
