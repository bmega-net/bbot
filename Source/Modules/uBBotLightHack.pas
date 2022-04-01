unit uBBotLightHack;

interface

uses
  uBTypes,
  uBBotAction,
  uBattlelist;

type
  TBBotLightHack = class(TBBotAction)
  private
    FPower: BInt32;
    PowerChanged: BBool;
    procedure SetLightPower;
    procedure SetPower(const Value: BInt32);
  public
    constructor Create;
    property Power: BInt32 read FPower write SetPower;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnCreatureLight(Creature: TBBotCreature);
  end;

implementation

uses
  BBotEngine;

{ TBBotLightHack }

constructor TBBotLightHack.Create;
begin
  inherited Create('Light Hack', 300);
  FPower := 0;
end;

procedure TBBotLightHack.OnCreatureLight(Creature: TBBotCreature);
begin
  if Creature.IsSelf then
    Run;
end;

procedure TBBotLightHack.OnInit;
begin
  inherited;
  BBot.Events.OnCreatureLight.Add(OnCreatureLight);
end;

procedure TBBotLightHack.Run;
begin
  if (Power > 0) or (PowerChanged) then begin
    SetLightPower;
    PowerChanged := False;
  end;
end;

procedure TBBotLightHack.SetLightPower;
begin
  if Me.Light.Intensity <> Power then
    Me.HackLight(Power);
end;

procedure TBBotLightHack.SetPower(const Value: BInt32);

begin
  FPower := Value;
  PowerChanged := True;
end;

end.
