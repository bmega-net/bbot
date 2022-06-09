unit uBBotReconnect;

interface

uses
  uBTypes,
  uBBotAction,
  uBBotReconnectManager;

type
  TBBotReconnect = class(TBBotAction)
  private
    FEnabled: BBool;
    procedure SetEnabled(const Value: BBool);
  protected
    LastCharacterName: BStr;
    function TryGetCharacter: TBBotReconnectCharacter;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write SetEnabled;

    procedure Run; override;
    procedure OnInit; override;

    procedure Login;
    procedure OnConnected;
  end;

implementation

uses
  BBotEngine,

  uEngine,

  uUserError;

{ TBBotReconnect }

constructor TBBotReconnect.Create;
begin
  inherited Create('Reconnect', 4000);
  FEnabled := False;
end;

procedure TBBotReconnect.Login;
var
  Char: TBBotReconnectCharacter;
begin
  if not Me.Connected then begin
    if not BBot.ServerSave.IsServerSave then begin
      BBot.ReconnectManager.LoadAccounts;
      Char := TryGetCharacter;
      if Char <> nil then
        Tibia.Login(Char.Account.Name, Char.Account.Password, Char.Index + 1);
    end;
  end;
end;

procedure TBBotReconnect.OnConnected;
begin
  if Enabled and (not Me.Connected) and (not BBot.ReconnectManager.Enabled) then
    Engine.Reconnect := True;
end;

procedure TBBotReconnect.OnInit;
begin
  inherited;
  BBot.Events.OnConnected.Add(OnConnected);
end;

procedure TBBotReconnect.Run;
begin
  if Me.Connected then begin
    LastCharacterName := Me.Name;
    if Enabled then
      TryGetCharacter;
  end;
end;

procedure TBBotReconnect.SetEnabled(const Value: BBool);

begin
  FEnabled := Value;
  BBot.ReconnectManager.LoadAccounts;
end;

function TBBotReconnect.TryGetCharacter: TBBotReconnectCharacter;

var

  Err: BUserError;

begin
  Result := BBot.ReconnectManager.CharacterByName(LastCharacterName);
  if (Result = nil) or (Result.Account = nil) then begin
    Err := BUserError.Create(Self, BFormat('Missing "%s" account and password in Reconnect Manager.',
      [LastCharacterName]));
    Err.Actions := [uraEditReconnectManager];
    Err.DisableReconnectManager := True;
    Err.Execute;
  end;
end;

end.
