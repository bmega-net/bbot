unit uBBotSuperFollow;

interface

uses uBTypes, uBBotAction, uBattlelist;

type
  TBBotSuperFollow = class(TBBotAction)
  private
    FCreatureID: BUInt32;
    FAutoTrack: BBool;
  public
    constructor Create;

    procedure Run; override;

    property AutoTrack: BBool read FAutoTrack write FAutoTrack;

    procedure OnInit; override;
    procedure OnStop;
    procedure OnFollow(ACreature: TBBotCreature);
    procedure OnCreatureWalk(ACreature: TBBotCreature; APrevPos: BPos);

    procedure SuperFollow(const ACreatureID: BInt32);
  end;

implementation

{ TBBotSuperFollow }

uses BBotEngine;

constructor TBBotSuperFollow.Create;
begin
  inherited Create('SuperFollow', 20);
end;

procedure TBBotSuperFollow.OnCreatureWalk(ACreature: TBBotCreature;
  APrevPos: BPos);
begin
  if (FCreatureID <> 0) and (ACreature <> nil) then
    if ACreature.ID = FCreatureID then
      if APrevPos.Z = 7 then
        BBot.Cavebot.GoFloorDown(APrevPos);
end;

procedure TBBotSuperFollow.OnFollow(ACreature: TBBotCreature);
begin
  if AutoTrack and (ACreature <> nil) then
    FCreatureID := ACreature.ID;
end;

procedure TBBotSuperFollow.OnInit;
begin
  inherited;
  BBot.Events.OnStop.Add(OnStop);
  BBot.Events.OnCreatureFollow.Add(OnFollow);
  BBot.Events.OnCreatureWalk.Add(OnCreatureWalk);
end;

procedure TBBotSuperFollow.OnStop;
begin
  FCreatureID := 0;
end;

procedure TBBotSuperFollow.Run;
var
  Creature: TBBotCreature;
begin
  inherited;
  if FCreatureID <> 0 then
  begin
    Creature := BBot.Creatures.Find(FCreatureID);
    if Creature = nil then
      Creature := BBot.Creatures.RawFind(
        function(AIt: TBBotCreature): BBool
        begin
          Exit((AIt.ID = FCreatureID) and (AIt.IsVisible) and (AIt.IsAlive));
        end);
    if Creature <> nil then
      Creature.SuperFollow;
  end;
end;

procedure TBBotSuperFollow.SuperFollow(const ACreatureID: BInt32);
begin
  FCreatureID := ACreatureID;
end;

end.
