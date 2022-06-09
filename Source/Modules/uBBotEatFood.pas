unit uBBotEatFood;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotEatFood = class(TBBotAction)
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
  uContainer,
  Math,

  uBBotProtector;

{ TBBotEatFood }

constructor TBBotEatFood.Create;
begin
  inherited Create('Eat Food', 30000);
  FEnabled := False;
end;

procedure TBBotEatFood.Run;
var
  CT: TTibiaContainer;
  I, J: BInt32;
begin
  if Enabled then begin
    CT := ContainerFirst;
    while CT <> nil do begin
      if CT.IsFood then begin
        J := Min(BRandom(4), CT.Count);
        for I := 1 to J do
          CT.Use;
        Exit;
      end;
      CT := CT.Next;
    end;
    if not(BBot.Depositer.Working or BBot.Withdraw.isWorking) then
      BBot.Protectors.OnProtector(bpkNoFood, 0);
  end;
end;

end.
