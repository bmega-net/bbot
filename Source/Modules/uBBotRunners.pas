unit uBBotRunners;


interface

uses
  uBTypes,
  uBVector,
  uBBotAction;

type
  TBBotRunnerPauser = class(TBBotActions)
  private
    FActionLevel: TBBotActionPauseLevel;
  public
    constructor Create(AActionName: BStr; AActionDelay: BUInt32; AActionLevel: TBBotActionPauseLevel);

    procedure Run; override;
    property ActionLevel: TBBotActionPauseLevel read FActionLevel;
  end;

implementation

{ TBBotRunnerPauser }

uses
  BBotEngine;

constructor TBBotRunnerPauser.Create(AActionName: BStr; AActionDelay: BUInt32; AActionLevel: TBBotActionPauseLevel);
begin
  FActionLevel := AActionLevel;
  inherited Create(AActionName, AActionDelay);
end;

procedure TBBotRunnerPauser.Run;
var
  I: BInt32;
begin
  for I := 0 to Actions.Count - 1 do
    if BBot.Menu.PauseLevel > ActionLevel then
      Actions[I]^.RunAction
    else
      Exit;
end;

end.

