unit uBBotLogout;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotLogout = class(TBBotAction)
  private
    NextLogout: BLock;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTibiaDeclarations;

{ TBBotLogout }

constructor TBBotLogout.Create;
begin
  inherited Create('Logout', 50);
  NextLogout := BLock.Create(1200, 40);
end;

destructor TBBotLogout.Destroy;
begin
  NextLogout.Free;
  inherited;
end;

procedure TBBotLogout.Run;
begin
  if Me.LoggingOut and Me.Connected then
    if not(tsInBattle in Me.Status) then
      if not(tsCannotLogoutOrEnterProtectionZone in Me.Status) then
        if not NextLogout.Locked then begin
          BBot.PacketSender.TryLogout;
          NextLogout.Lock();
        end;
end;

end.
