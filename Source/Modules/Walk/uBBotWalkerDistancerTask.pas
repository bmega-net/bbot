unit uBBotWalkerDistancerTask;

interface

uses
  uBTypes,
  uBBotWalkerTask,
  uBBotWalkerPathFinder;

type
  TBBotCreatureDistancerTask = class(TBBotWalkerTask)
  private
    FCreatureID: BUInt32;
    FDistance: BUInt32;
  protected
    LastCreaturePosition: BPos;
    function GetDone: BBool; override;
    function GetHasNext: BBool; override;
  public
    constructor Create(ACreatureID, ADistance: BUInt32; APathFinder: TBBotPathFinder);

    property CreatureID: BUInt32 read FCreatureID;
    property Distance: BUInt32 read FDistance;
  end;

implementation

uses
  uBattlelist,
  BBotEngine;

{ TBBotCreatureDistancerTask }

constructor TBBotCreatureDistancerTask.Create(ACreatureID, ADistance: BUInt32; APathFinder: TBBotPathFinder);
var
  C: TBBotCreature;
begin
  inherited Create(APathFinder);
  FCreatureID := ACreatureID;
  FDistance := ADistance;
  C := BBot.Creatures.Find(ACreatureID);
  if C <> nil then
    LastCreaturePosition := C.Position
  else
    LastCreaturePosition.zero;
end;

function TBBotCreatureDistancerTask.GetDone: BBool;
var
  C: TBBotCreature;
begin
  C := BBot.Creatures.Find(FCreatureID);
  if (C <> nil) and (C.IsAlive) and (C.IsOnScreen) and (BUInt32(Me.DistanceTo(C)) <> FDistance) then
    Result := inherited
  else
    Exit(True);
end;

function TBBotCreatureDistancerTask.GetHasNext: BBool;
var
  C: TBBotCreature;
begin
  C := BBot.Creatures.Find(FCreatureID);
  if (C <> nil) and (C.Position <> LastCreaturePosition) then
    Exit(False);
  Result := inherited;
  FContinuous := False;
end;

end.
