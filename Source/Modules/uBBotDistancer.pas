unit uBBotDistancer;

interface

uses uBTypes, uBBotAction, uBBotWalkTask;

type
  TBBotDistancer = class(TBBotAction)
  private
    FWalker: TBBotWalkCreature;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Stop;
    procedure Run; override;
    procedure OnInit; override;

    property Walker: TBBotWalkCreature read FWalker;
  end;

implementation

{ TBBotDistancer }

uses BBotEngine;

constructor TBBotDistancer.Create;
begin
  FWalker := TBBotWalkCreature.Create;
  inherited Create('Distancer', 1000);
end;

destructor TBBotDistancer.Destroy;
begin
  FWalker.Free;
  inherited;
end;

procedure TBBotDistancer.OnInit;
begin
  inherited;
  BBot.Events.OnStop.Add(Stop);
end;

procedure TBBotDistancer.Run;
begin
end;

procedure TBBotDistancer.Stop;
begin
  Walker.Stop;
end;

end.
