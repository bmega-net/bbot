unit uBBotHealer;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotHealers = class;

  TBBotHealerBase = class
  private
    FEnabled: BBool;
    FHealHealth: BInt32;
    FPercent: BBool;
    FHealers: TBBotHealers;
    FNextHeal: BInt32;
    function GetMyHealth: BInt32;
    procedure SetNextHeal;
    procedure SetEnabled(const Value: BBool); virtual;
    function GetMaxMyHealth: BInt32;
  protected
    function Heal: BBool; virtual; abstract;
  public
    constructor Create(AHealers: TBBotHealers);

    function Execute: boolean;

    property Enabled: BBool read FEnabled write SetEnabled;
    property HealHealth: BInt32 read FHealHealth write FHealHealth;
    property MyHealth: BInt32 read GetMyHealth;
    property MaxMyHealth: BInt32 read GetMaxMyHealth;
    property NextHeal: BInt32 read FNextHeal;
    property Percent: BBool read FPercent write FPercent;
  end;

  TBBotHealerSpell = class(TBBotHealerBase)
  private
    FSpell: BStr;
    FMana: BInt32;
  protected
    function Heal: BBool; override;
  public
    constructor Create(AHealers: TBBotHealers);

    property Mana: BInt32 read FMana write FMana;
    property Spell: BStr read FSpell write FSpell;
  end;

  TBBotHealerItem = class(TBBotHealerBase)
  private
    FItem: BInt32;
    procedure SetEnabled(const Value: BBool); override;
  protected
    function Heal: BBool; override;
  public
    constructor Create(AHealers: TBBotHealers);

    property Item: BInt32 read FItem write FItem;
  end;

  TBBotHealerType = (hutSpell, hutItem);

  TBBotHealers = class(TBBotAction)
  private
    FHealerPriority: TBBotHealerType;
    FCanUseItem: BUInt32;
    FCanUseSpell: BUInt32;
    FDelayBetweenItems: BUInt32;
    FDelayBetweenSpells: BUInt32;
    FVariation: BInt32;
    FItemHigh: TBBotHealerItem;
    FSpellLow: TBBotHealerSpell;
    FItemLow: TBBotHealerItem;
    FSpellHigh: TBBotHealerSpell;
    FSpellMid: TBBotHealerSpell;
    FItemMid: TBBotHealerItem;
    function GetCanUseSpell: BBool;
    function GetCanUseItem: BBool;
    procedure EnforceVariables(AName: BStr; AValue: BInt32);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure UpdateVariables;

    property HealerPriority: TBBotHealerType read FHealerPriority write FHealerPriority;
    property ItemHigh: TBBotHealerItem read FItemHigh;
    property ItemMid: TBBotHealerItem read FItemMid;
    property ItemLow: TBBotHealerItem read FItemLow;
    property SpellHigh: TBBotHealerSpell read FSpellHigh;
    property SpellMid: TBBotHealerSpell read FSpellMid;
    property SpellLow: TBBotHealerSpell read FSpellLow;
    property Variation: BInt32 read FVariation write FVariation;

    property CanUseSpell: BBool read GetCanUseSpell;
    property CanUseItem: BBool read GetCanUseItem;
    procedure BlockUseItem;
    procedure BlockUseSpell;

    property DelayBetweenItems: BUInt32 read FDelayBetweenItems write FDelayBetweenItems;
    property DelayBetweenSpells: BUInt32 read FDelayBetweenSpells write FDelayBetweenSpells;

    procedure OnHP(OldHP: BInt32);
  end;

implementation

uses
  BBotEngine;

{ TBBotHealer }

constructor TBBotHealerBase.Create;
begin
  FEnabled := False;
  Percent := False;
  FHealers := AHealers;
  FNextHeal := 0;
  FHealHealth := 0;
end;

function TBBotHealerBase.Execute: boolean;
var
  Health: BInt32;
begin
  Result := False;
  if Enabled then begin
    Health := MyHealth;
    if not BInRange(Health, 1, MaxMyHealth) then
      SetNextHeal
    else if (Health <= NextHeal) and Heal then begin
      SetNextHeal;
      Result := True;
    end;
  end;
end;

function TBBotHealerBase.GetMaxMyHealth: BInt32;
begin
  if Percent then
    Result := 100 - 1
  else
    Result := Me.HPMax - 1;
end;

function TBBotHealerBase.GetMyHealth: BInt32;
begin
  if Percent then
    Result := BFloor(BToPercent(Me.HP, Me.HPMax))
  else
    Result := Me.HP;
end;

procedure TBBotHealerBase.SetEnabled(const Value: BBool);
begin
  SetNextHeal;
  FEnabled := Value;
end;

procedure TBBotHealerBase.SetNextHeal;
var
  MaxHeal: BInt32;
  F: BFloat;
begin
  MaxHeal := MaxMyHealth;
  F := 1 + (FHealers.Variation / 100);
  FNextHeal := BMin(BRandom(FHealHealth, BFloor(FHealHealth * F)), MaxHeal);
end;

{ TBBotHealers }

constructor TBBotHealers.Create;
begin
  inherited Create('Healers', 0);
  HealerPriority := hutSpell;
  FSpellHigh := TBBotHealerSpell.Create(Self);
  FSpellMid := TBBotHealerSpell.Create(Self);
  FSpellLow := TBBotHealerSpell.Create(Self);
  FItemHigh := TBBotHealerItem.Create(Self);
  FItemMid := TBBotHealerItem.Create(Self);
  FItemLow := TBBotHealerItem.Create(Self);
  DelayBetweenItems := 800;
  DelayBetweenSpells := 800;
  FVariation := 15;
end;

destructor TBBotHealers.Destroy;
begin
  SpellHigh.Free;
  SpellMid.Free;
  SpellLow.Free;
  ItemHigh.Free;
  ItemMid.Free;
  ItemLow.Free;
  inherited;
end;

procedure TBBotHealers.EnforceVariables(AName: BStr; AValue: BInt32);
begin
  BBot.Macros.Registry.Variables['BBot.Healers.ItemLow.ItemID'].Value := ItemLow.Item;
  BBot.Macros.Registry.Variables['BBot.Healers.ItemMid.ItemID'].Value := ItemMid.Item;
  BBot.Macros.Registry.Variables['BBot.Healers.ItemHeavy.ItemID'].Value := ItemHigh.Item;
end;

procedure TBBotHealers.Run;
var
  Healed: BBool;
begin
  if Me.HP > 0 then begin
    if HealerPriority = hutSpell then begin
      Healed := SpellHigh.Execute or ItemHigh.Execute or SpellMid.Execute or ItemMid.Execute or SpellLow.Execute or
        ItemLow.Execute;
    end else begin
      Healed := ItemHigh.Execute or SpellHigh.Execute or ItemMid.Execute or SpellMid.Execute or ItemLow.Execute or
        SpellLow.Execute;
    end;
    if Healed then
      ActionNext.Lock(100);
  end;
end;

procedure TBBotHealers.UpdateVariables;
begin
  EnforceVariables('', 0);
end;

function TBBotHealers.GetCanUseItem: BBool;
begin
  Result := (Tick > FCanUseItem);
end;

function TBBotHealers.GetCanUseSpell: BBool;
begin
  Result := (Tick > FCanUseSpell);
end;

procedure TBBotHealers.OnHP(OldHP: BInt32);
begin
  Run;
end;

procedure TBBotHealers.OnInit;
begin
  inherited;
  BBot.Events.OnHP.Add(OnHP);

  BBot.Macros.Registry.CreateSystemVariable('BBot.Healers.ItemLow.ItemID', 0).Watch(EnforceVariables);
  BBot.Macros.Registry.CreateSystemVariable('BBot.Healers.ItemMid.ItemID', 0).Watch(EnforceVariables);
  BBot.Macros.Registry.CreateSystemVariable('BBot.Healers.ItemHeavy.ItemID', 0).Watch(EnforceVariables);
end;

procedure TBBotHealers.BlockUseItem;
begin
  FCanUseItem := Tick + DelayBetweenItems;
  BBot.Exhaust.ExhaustDefensive;
  BBot.Exhaust.ExhaustItem;
end;

procedure TBBotHealers.BlockUseSpell;
begin
  FCanUseSpell := Tick + DelayBetweenSpells;
  BBot.Exhaust.ExhaustDefensive;
end;

{ TBBotHealerItem }

constructor TBBotHealerItem.Create(AHealers: TBBotHealers);
begin
  inherited Create(AHealers);
  FItem := ItemID_ManaPotion;
end;

function TBBotHealerItem.Heal: BBool;
begin
  if FHealers.CanUseItem then begin
    Me.UseOnMe(Item);
    FHealers.BlockUseItem;
    Result := True;
  end
  else
    Result := False;
end;

procedure TBBotHealerItem.SetEnabled(const Value: BBool);
begin
  inherited SetEnabled(Value);
  FHealers.UpdateVariables;
end;

{ TBBotHealerSpell }

constructor TBBotHealerSpell.Create(AHealers: TBBotHealers);
begin
  inherited Create(AHealers);
  FSpell := 'exura';
  FMana := 20;
end;

function TBBotHealerSpell.Heal: BBool;
begin
  if FHealers.CanUseSpell and (Me.Mana >= Mana) then begin
    Me.Say(Spell);
    FHealers.BlockUseSpell;
    Result := True;
  end
  else
    Result := False;
end;

end.
