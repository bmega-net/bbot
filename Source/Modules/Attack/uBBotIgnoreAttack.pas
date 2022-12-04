unit uBBotIgnoreAttack;

interface

uses
  uBTypes,
  uBBotAction,
  uBVector;

type
  TBBotIgnoreAttack = class(TBBotAction)
  private type
    TBBotIgnoreAttackData = record
      ID: BUInt32;
      Expire: BUInt32;
    end;
  private
    Data: BVector<TBBotIgnoreAttackData>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddAttacking(Expire: BUInt32; Reason: BStr);
    procedure Add(ID, Expire: BUInt32; Reason: BStr);
    function IsIgnored(ID: BUInt32): BBool;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine;

{ TBBotIgnoreAttack }

procedure TBBotIgnoreAttack.Add(ID, Expire: BUInt32; Reason: BStr);
var
  It: BVector<TBBotIgnoreAttackData>.It;
begin
  if BBot.Attacker.Debug then
    AddDebug(BFormat('ignoring creature %d for %d ms reason: %s',
      [ID, Expire, Reason]));
  It := Data.Add;
  It^.ID := ID;
  It^.Expire := Tick + Expire;
end;

constructor TBBotIgnoreAttack.Create;
begin
  inherited Create('Ignore Attack', 1000);
  Data := BVector<TBBotIgnoreAttackData>.Create;
end;

destructor TBBotIgnoreAttack.Destroy;
begin
  Data.Free;
  inherited;
end;

procedure TBBotIgnoreAttack.AddAttacking(Expire: BUInt32; Reason: BStr);
begin
  Add(Me.TargetID, Expire, Reason);
end;

function TBBotIgnoreAttack.IsIgnored(ID: BUInt32): BBool;
begin
  Result := Data.Has('Attacker - IsIgnored',
    function(It: BVector<TBBotIgnoreAttackData>.It): BBool
    begin
      Result := It^.ID = ID;
    end);
end;

procedure TBBotIgnoreAttack.Run;
begin
  Data.Delete(
    function(It: BVector<TBBotIgnoreAttackData>.It): BBool
    begin
      Result := It^.Expire < Tick;
    end);
end;

end.

