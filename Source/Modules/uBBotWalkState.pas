unit uBBotWalkState;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotWalkStatePriority = (wspOpenCorpses, wspKillMonsters);

  TBBotWalkState = class(TBBotActions)
  private
    FPriority: TBBotWalkStatePriority;
  public
    constructor Create;
    destructor Destroy; override;

    property Priority: TBBotWalkStatePriority read FPriority write FPriority;

    procedure Run; override;
  end;

implementation

{ TBBotWalkState }

uses
  BBotEngine,
  uBBotOpenCorpses,
  uBBotAttacker;

constructor TBBotWalkState.Create;
begin
  FPriority := wspOpenCorpses;
  inherited Create('AttackerCorpseStrategy', 1);
end;

destructor TBBotWalkState.Destroy;
begin
  inherited;
end;

procedure TBBotWalkState.Run;
begin
  if Priority = wspOpenCorpses then begin
    if not BBot.OpenCorpses.OpenNextCorpse then
      if not BBot.Looter.IsLooting then
        if not BBot.Attacker.AttackRun then
          if not Me.IsAttacking then
            BBot.Cavebot.RunPoint;
  end else begin
    if not BBot.Attacker.AttackRun then
      if not BBot.OpenCorpses.OpenNextCorpse then
        if not Me.IsAttacking then
          BBot.Cavebot.RunPoint;
  end;
end;

end.
