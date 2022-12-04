unit uBBotManaTrainer;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotManaTrainer = class(TBBotAction)
  private
    FEnabled: BBool;
    FPercent: BBool;
    FManaFrom: BInt32;
    FManaTo: BInt32;
    FSpell: BStr;
    FWorking: BBool;
    FNextManaFrom: BInt32;
    FNextManaTo: BInt32;
    FVariation: BInt32;
    procedure SetManaNext;
    procedure SetEnabled(const Value: BBool);
    function GetMyMana: BInt32;
    function GetWorking: BBool;
    function GetMaxMyMana: BInt32;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write SetEnabled;
    property Percent: BBool read FPercent write FPercent;
    property MyMana: BInt32 read GetMyMana;
    property MaxMyMana: BInt32 read GetMaxMyMana;
    property ManaFrom: BInt32 read FManaFrom write FManaFrom;
    property ManaTo: BInt32 read FManaTo write FManaTo;
    property NextManaFrom: BInt32 read FNextManaFrom;
    property NextManaTo: BInt32 read FNextManaTo;
    property Spell: BStr read FSpell write FSpell;
    property Variation: BInt32 read FVariation write FVariation;
    property Working: BBool read GetWorking;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine;

{ TBBotManaTrainer }

constructor TBBotManaTrainer.Create;
begin
  inherited Create('Mana Trainer', 600);
  FEnabled := False;
  FWorking := False;
  FVariation := 15;
  FNextManaFrom := 0;
  FNextManaTo := 0;
  FManaTo := 0;
  FManaFrom := 0;
end;

function TBBotManaTrainer.GetMaxMyMana: BInt32;
begin
  if Percent then
    Result := 100
  else
    Result := Me.ManaMax;
end;

function TBBotManaTrainer.GetMyMana: BInt32;
begin
  if Percent then
    Result := BFloor(BToPercent(Me.Mana, Me.ManaMax))
  else
    Result := Me.Mana;
end;

function TBBotManaTrainer.GetWorking: BBool;
var
  Mana: BInt32;
begin
  Mana := MyMana;
  if not BInRange(Mana, 1, MaxMyMana) then
    SetManaNext;
  if (FWorking) and (Mana <= NextManaTo) then
  begin
    FWorking := False;
    SetManaNext;
  end;
  if (not FWorking) and (Mana >= NextManaFrom) then
  begin
    FWorking := True;
    SetManaNext;
  end;
  Result := FWorking;
end;

procedure TBBotManaTrainer.Run;
begin
  if Enabled and (not BBot.Exhaust.Defensive) and Working then
  begin
    Me.Say(Spell);
    Exit;
  end;
end;

procedure TBBotManaTrainer.SetEnabled(const Value: BBool);
begin
  SetManaNext;
  FEnabled := Value;
end;

procedure TBBotManaTrainer.SetManaNext;
var
  MaxHeal: BInt32;
  F: BFloat;
begin
  MaxHeal := MaxMyMana;
  F := 1 + (Variation / 100);
  FNextManaFrom := BMin(BRandom(FManaFrom, BFloor(FManaFrom * F)), MaxHeal);
  FNextManaTo := BMin(BRandom(FManaTo, BFloor(FManaTo * F)), MaxHeal);
end;

end.

