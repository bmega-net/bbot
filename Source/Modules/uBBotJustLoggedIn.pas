unit uBBotJustLoggedIn;

interface

uses
  uBTypes,
  uBBotAction;

const
  BBotJustLoggedInClickID = 1001;

type
  TBBotJustLoggedIn = class(TBBotAction)
  private
    LoginLock: BLock;
    function GetJustLoggedIn: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    property JustLoggedIn: BBool read GetJustLoggedIn;
    procedure Cancel;

    procedure OnCharacter;
    procedure OnMenu(ClickID, Data: BUInt32);
  end;

implementation

{ TBBotJustLoggedIn }

uses
  uHUD,
  BBotEngine;

procedure TBBotJustLoggedIn.Cancel;
begin
  LoginLock.UnLock;
  HUDRemoveGroup(bhgJustLoggedIn);
end;

constructor TBBotJustLoggedIn.Create;
begin
  LoginLock := BLock.Create(10 * 1000, 10);
  inherited Create('AutomationLoginLock', 1000);
end;

destructor TBBotJustLoggedIn.Destroy;
begin
  LoginLock.Free;
  inherited;
end;

function TBBotJustLoggedIn.GetJustLoggedIn: BBool;
begin
  Result := LoginLock.Locked;
end;

procedure TBBotJustLoggedIn.OnCharacter;
var
  HUD: TBBotHUD;
begin
  LoginLock.Lock;
  HUDRemoveGroup(bhgJustLoggedIn);
  if Me.Connected then begin
    HUD := TBBotHUD.Create(bhgJustLoggedIn);
    HUD.AlignTo(bhaCenter, bhaTop);
    HUD.Expire := LoginLock.Remaining;
    HUD.PrintGray('The Automation Tools are paused for # because you just logged in.');
    HUD.OnClick := BBotJustLoggedInClickID;
    HUD.PrintGray('[ click here to skip ]');
    HUD.Free;
  end;
end;

procedure TBBotJustLoggedIn.OnInit;
begin
  inherited;
  BBot.Events.OnCharacter.Add(OnCharacter);
  BBot.Events.OnMenu.Add(OnMenu);
end;

procedure TBBotJustLoggedIn.OnMenu(ClickID, Data: BUInt32);
begin
  if (ClickID = BBotJustLoggedInClickID) then
    Cancel;
end;

procedure TBBotJustLoggedIn.Run;
begin
  inherited;

end;

end.
