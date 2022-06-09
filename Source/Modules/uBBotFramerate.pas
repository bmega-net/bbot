unit uBBotFramerate;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotFramerate = class(TBBotAction)
  private
    FEnabled: BBool;
    FramerateLimit: BDbl;
    function GetValidFramerate: BBool;
    procedure SetEnabled(const Value: BBool);
  public
    constructor Create;
    property Enabled: BBool read FEnabled write SetEnabled;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnTibiaFocus(IsFocused: BBool);
    procedure OnTibiaActive;
    procedure OnTibiaDeActive;
  end;

implementation

uses
  BBotEngine,
  uTibiaDeclarations;

{ TBBotFramerate }

constructor TBBotFramerate.Create;
begin
  inherited Create('Framerate', 10000);
  FEnabled := False;
  FramerateLimit := -1;
end;

function TBBotFramerate.GetValidFramerate: BBool;
var
  NewFramerate: BDbl;
begin
  NewFramerate := Tibia.MaxFPS(0);
  if BInRange(NewFramerate, TibiaFPSMinTime, TibiaFPSMaxTime) then
    FramerateLimit := NewFramerate;
  Result := BInRange(FramerateLimit, TibiaFPSMinTime, TibiaFPSMaxTime);
end;

procedure TBBotFramerate.OnInit;
begin
  inherited;
  BBot.Events.OnTibiaFocus.Add(OnTibiaFocus);
end;

procedure TBBotFramerate.OnTibiaActive;
begin
  if Enabled then
    if GetValidFramerate then
      Tibia.MaxFPS(FramerateLimit);
end;

procedure TBBotFramerate.OnTibiaDeActive;
begin
  if Enabled then
    if GetValidFramerate then
      Tibia.MaxFPS(TibiaFPSDisabled);
end;

procedure TBBotFramerate.OnTibiaFocus(IsFocused: BBool);
begin
  if IsFocused then
    OnTibiaActive
  else
    OnTibiaDeActive;
end;

procedure TBBotFramerate.Run;
begin
  GetValidFramerate;
end;

procedure TBBotFramerate.SetEnabled(const Value: BBool);
begin
  FEnabled := Value;
  if GetValidFramerate then
    if Value then
      Tibia.MaxFPS(TibiaFPSDisabled)
    else
      Tibia.MaxFPS(FramerateLimit);
end;

end.
