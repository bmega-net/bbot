unit uBBotManaDrinker;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotManaDrinker = class;

  TBBotManaDrink = class
  private
    FManaUse: BInt32;
    FEnabled: BBool;
    FNextManaFrom: BInt32;
    FManaFrom: BInt32;
    FManaDrinker: TBBotManaDrinker;
    FManaPercent: BBool;
    FNextManaTo: BInt32;
    FManaTo: BInt32;
    FWorking: BBool;
    FPauseCavebot: BBool;
    function GetMyMana: BInt32;
    function GetWorking: BBool;
    procedure SetEnabled(const Value: BBool);
    procedure SetManaMax;
    function GetMaxMyMana: BInt32;
  public
    constructor Create(AManaDrinker: TBBotManaDrinker);

    property ManaDrinker: TBBotManaDrinker read FManaDrinker;
    property Enabled: BBool read FEnabled write SetEnabled;
    property PauseCavebot: BBool read FPauseCavebot write FPauseCavebot;
    property ManaPercent: BBool read FManaPercent write FManaPercent;
    property MyMana: BInt32 read GetMyMana;
    property MaxMyMana: BInt32 read GetMaxMyMana;
    property ManaFrom: BInt32 read FManaFrom write FManaFrom;
    property ManaTo: BInt32 read FManaTo write FManaTo;
    property ManaUse: BInt32 read FManaUse write FManaUse;
    property NextManaFrom: BInt32 read FNextManaFrom;
    property NextManaTo: BInt32 read FNextManaTo;
    property Working: BBool read GetWorking;

    function Execute: BBool;
  end;

  TBBotManaDrinker = class(TBBotAction)
  private
    FVariation: BInt32;
    FLow: TBBotManaDrink;
    FMid: TBBotManaDrink;
    FHeavy: TBBotManaDrink;
    FPauseCavebot: BBool;
    procedure EnforceVariables(AName: BStr; AValue: BInt32);
  public
    constructor Create;
    destructor Destroy; override;

    property Variation: BInt32 read FVariation write FVariation;
    property Heavy: TBBotManaDrink read FHeavy;
    property Mid: TBBotManaDrink read FMid;
    property Low: TBBotManaDrink read FLow;

    property PauseCavebot: BBool read FPauseCavebot;

    procedure Run; override;
    procedure OnInit; override;

    procedure UpdateVariable;
  end;

implementation

uses
  BBotEngine;

{ TBBotManaDrinker }

constructor TBBotManaDrinker.Create;
begin
  inherited Create('Mana Drinker', 10);
  FVariation := 15;
  FLow := TBBotManaDrink.Create(Self);
  FMid := TBBotManaDrink.Create(Self);
  FHeavy := TBBotManaDrink.Create(Self);
  FPauseCavebot := False;
end;

destructor TBBotManaDrinker.Destroy;
begin
  FLow.Free;
  FMid.Free;
  FHeavy.Free;
  inherited;
end;

procedure TBBotManaDrinker.EnforceVariables(AName: BStr; AValue: BInt32);
begin
  BBot.Macros.Registry.Variables['BBot.ManaDrinker.Low.ItemID'].Value :=
    Low.ManaUse;
  BBot.Macros.Registry.Variables['BBot.ManaDrinker.Mid.ItemID'].Value :=
    Mid.ManaUse;
  BBot.Macros.Registry.Variables['BBot.ManaDrinker.Heavy.ItemID'].Value :=
    Heavy.ManaUse;
end;

procedure TBBotManaDrinker.OnInit;
begin
  inherited;
  BBot.Macros.Registry.CreateSystemVariable('BBot.ManaDrinker.Low.ItemID', 0)
    .Watch(EnforceVariables);
  BBot.Macros.Registry.CreateSystemVariable('BBot.ManaDrinker.Mid.ItemID', 0)
    .Watch(EnforceVariables);
  BBot.Macros.Registry.CreateSystemVariable('BBot.ManaDrinker.Heavy.ItemID', 0)
    .Watch(EnforceVariables);
end;

procedure TBBotManaDrinker.Run;
begin
  FPauseCavebot := False;
  if not FHeavy.Execute then
    if not FMid.Execute then
      FLow.Execute;
end;

procedure TBBotManaDrinker.UpdateVariable;
begin
  EnforceVariables('', 0);
end;

{ TBBotManaDrink }

constructor TBBotManaDrink.Create(AManaDrinker: TBBotManaDrinker);
begin
  FManaUse := 0;
  FEnabled := False;
  FPauseCavebot := False;
  FNextManaFrom := 0;
  FManaFrom := 0;
  FManaDrinker := AManaDrinker;
  FManaPercent := False;
  FNextManaTo := 0;
  FManaTo := 0;
end;

function TBBotManaDrink.Execute: BBool;
begin
  if Enabled then
  begin
    if Working then
    begin
      if not BBot.Exhaust.Item then
        Me.UseOnMe(ManaUse);
      if PauseCavebot then
        ManaDrinker.FPauseCavebot := True;
      Exit(True);
    end;
  end;
  Exit(False);
end;

function TBBotManaDrink.GetMaxMyMana: BInt32;
begin
  if ManaPercent then
    Result := 100 - 1
  else
    Result := Me.ManaMax - 1;
end;

function TBBotManaDrink.GetMyMana: BInt32;
begin
  if ManaPercent then
    Result := BFloor(BToPercent(Me.Mana, Me.ManaMax))
  else
    Result := Me.Mana;
end;

function TBBotManaDrink.GetWorking: BBool;
var
  Mana: BInt32;
begin
  Mana := MyMana;
  if not BInRange(Mana, 1, MaxMyMana) then
    SetManaMax;
  if (FWorking) and (Mana >= NextManaTo) then
  begin
    FWorking := False;
    SetManaMax;
  end;
  if (not FWorking) and (Mana <= NextManaFrom) then
  begin
    FWorking := True;
    SetManaMax;
  end;
  Result := FWorking;
end;

procedure TBBotManaDrink.SetEnabled(const Value: BBool);
begin
  SetManaMax;
  FEnabled := Value;
  FManaDrinker.UpdateVariable;
end;

procedure TBBotManaDrink.SetManaMax;
var
  MaxHeal: BInt32;
  F: BFloat;
begin
  MaxHeal := MaxMyMana;
  F := 1 + (ManaDrinker.Variation / 100);
  FNextManaFrom := BMin(BRandom(FManaFrom, BFloor(FManaFrom * F)), MaxHeal);
  FNextManaTo := BMin(BRandom(FManaTo, BFloor(FManaTo * F)), MaxHeal);
end;

end.

