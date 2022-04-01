unit uBBotWalkerPathFinderPosition;

interface

uses
  uBTypes,
  uBBotWalkerPathFinder;

type
  TBBotPathFinderPosition = class(TBBotPathFinder)
  private
    FPosition: BPos;
  public
    function GetDestination: BPos; override;
    function GetOrigin: BPos; override;
    property Position: BPos read FPosition write FPosition;
  end;

implementation

uses
  BBotEngine;

{ TBBotPathFinderPosition }

function TBBotPathFinderPosition.GetDestination: BPos;
begin
  Result := FPosition;
end;

function TBBotPathFinderPosition.GetOrigin: BPos;
begin
  Result := Me.Position;
end;

end.
