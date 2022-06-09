unit uBBotOTMoney;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotOTMoney = class(TBBotAction)
  private
    FEnabled: BBool;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses

  uContainer,
  uTibiaDeclarations;

{ TBBotOTMoney }

constructor TBBotOTMoney.Create;
begin
  inherited Create('OT Money', 200);
  FEnabled := False;
end;

procedure TBBotOTMoney.Run;
var
  CT: TTibiaContainer;
begin
  if Enabled then begin
    CT := ContainerFirst;
    while CT <> nil do begin
      if CT.Count = 100 then
        if BIntIn(CT.ID, [ItemID_GoldCoin, ItemID_PlatinumCoin]) then begin
          CT.Use;
          Exit;
        end;
      CT := CT.Next;
    end;
  end;
end;

end.
