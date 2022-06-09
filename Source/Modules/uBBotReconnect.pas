unit uBBotReconnect;

interface

uses uBTypes, uBBotAction;

type
  TBBotReconnect = class(TBBotAction)
  private
    FEnabled: BBool;
    FCharacter: BInt32;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;
    property Character: BInt32 read FCharacter write FCharacter;

    procedure Run; override;
    procedure OnInit; override;

    procedure Login;
    procedure OnConnected;
  end;

implementation

uses BBotEngine, uTibiaDeclarations, uEngine;

{ TBBotReconnect }

constructor TBBotReconnect.Create;
begin
  inherited Create('Reconnect', 700);
  FEnabled := False;
  FCharacter := -1;
end;

procedure TBBotReconnect.Login;
var
  Acc: TTibiaAcc;
begin
  if not Me.Connected then
    if not BBot.ServerSave.IsServerSave then
    begin
      Acc := Tibia.AccountAndPassword;
      Tibia.Login(Acc.Account, Acc.Password, Character);
    end;
end;

procedure TBBotReconnect.OnConnected;
begin
  if Enabled and (not Me.Connected) then
    Engine.Reconnect := True;
end;

procedure TBBotReconnect.OnInit;
begin
  inherited;
  BBot.Events.OnConnected.Add(OnConnected);
end;

procedure TBBotReconnect.Run;
begin

end;

end.
