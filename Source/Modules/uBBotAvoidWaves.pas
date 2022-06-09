unit uBBotAvoidWaves;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotAvoidWaves = class(TBBotAction)
  private
    FEnableForID: BUInt32;
  public
    constructor Create;

    property EnableForID: BUInt32 read FEnableForID write FEnableForID;

    procedure Stop;
    procedure Run; override;
    procedure OnInit; override;
  end;

implementation

uses
  BBotEngine,
  uDistance,
  uBattlelist;

{ TBBotAvoidWaves }

constructor TBBotAvoidWaves.Create;
begin
  inherited Create('Avoid Waves', 300);
  FEnableForID := 0;
end;

procedure TBBotAvoidWaves.OnInit;
begin
  inherited;
  BBot.Events.OnStop.Add(Stop);
end;

procedure TBBotAvoidWaves.Run;
var
  DX, DY: BInt32;
  MinusScore, PlusScore: BFloat;
  Creature: TBBotCreature;
begin
  if EnableForID <> 0 then begin
    if not BBot.Walker.Waiting then begin
      Creature := BBot.Creatures.Target;
      if (Creature <> nil) and (Creature.ID = EnableForID) and (Creature.IsAlive) then begin
        DX := BAbs(Creature.Position.Y - Me.Position.Y);
        DY := BAbs(Creature.Position.X - Me.Position.X);
        if (DX = 0) or (DY = 0) then begin
          DX := BMin(DX, 1);
          DY := BMin(DY, 1);
          MinusScore := BBot.Walker.WalkableCost((DX * -1) + Me.Position.X, (DY * -1) + Me.Position.Y, Me.Position.Z);
          PlusScore := BBot.Walker.WalkableCost(DX + Me.Position.X, DY + Me.Position.Y, Me.Position.Z);
          if BMin(MinusScore, PlusScore) < TileCost_ExtremeAvoid then
            if MinusScore < PlusScore then
              BBot.Walker.Step(DX * -1, DY * -1)
            else
              BBot.Walker.Step(DX, DY);
        end;
      end
      else
        EnableForID := 0;
    end;
  end;
end;

procedure TBBotAvoidWaves.Stop;
begin
  EnableForID := 0;
end;

end.
