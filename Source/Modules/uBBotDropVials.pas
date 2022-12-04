unit uBBotDropVials;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotDropVials = class(TBBotAction)
  private
    FEnabled: BBool;
    NextDropMinCount: BInt32;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uContainer,
  Declaracoes;

{ TBBotDropVials }

constructor TBBotDropVials.Create;
begin
  inherited Create('Drop Vials', 700);
  FEnabled := False;
  NextDropMinCount := 1;
end;

procedure TBBotDropVials.Run;
const
  Vials: array [1 .. 3] of BInt32 = (283, 284, 285);
var
  CT: TTibiaContainer;
  PrevIsVial: BBool;
begin
  if Enabled then
  begin
    PrevIsVial := False;
    CT := ContainerLast;
    while CT <> nil do
    begin
      if IntIn(CT.ID, Vials) then
      begin
        if PrevIsVial then
        begin
          CT.ToGround(Me.Position);
          Exit;
        end;
        PrevIsVial := True;
        if CT.Count > NextDropMinCount then
        begin
          CT.ToGround(Me.Position);
          NextDropMinCount := BRandom(1, 50);
          Exit;
        end;
      end
      else
        PrevIsVial := False;
      CT := CT.Prev;
    end;
  end;
end;

end.

