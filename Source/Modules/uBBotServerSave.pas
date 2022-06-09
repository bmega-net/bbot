unit uBBotServerSave;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotServerSave = class(TBBotAction)
  private
    FEnabled: BBool;
    FMinute: BInt32;
    FHour: BInt32;
    function GetIsServerSave: BBool;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;
    property Hour: BInt32 read FHour write FHour;
    property Minute: BInt32 read FMinute write FMinute;
    property IsServerSave: BBool read GetIsServerSave;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  DateUtils,
  SysUtils;

{ TBBotServerSave }

constructor TBBotServerSave.Create;
begin
  inherited Create('Server Save', 2000);
  FEnabled := False;
  FHour := 0;
  FMinute := 0;
end;

function TBBotServerSave.GetIsServerSave: BBool;
begin
  if not Enabled then
    Exit(False);
  if Me.Connected then
    Result := (HourOf(Now) = Hour) and BInRange(MinuteOf(Now), Minute, Minute + 3)
  else
    Result := (HourOf(Now) = Hour) and BInRange(MinuteOf(Now), Minute, Minute + 12);
end;

procedure TBBotServerSave.Run;
begin
  if Enabled then
    if IsServerSave and Me.Connected then
      Me.Logout;
end;

end.
