unit uBBotExhaust;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  uBBotSpells;

const
  BBotExhaustOffensive = 800;
  BBotExhaustOffensiveVar = 'BBot.Exhaust.Offensive';
  BBotExhaustDefensive = 600;
  BBotExhaustDefensiveVar = 'BBot.Exhaust.Defensive';
  BBotExhaustPotion = 200;
  BBotExhaustPotionVar = 'BBot.Exhaust.Potion';

type
  TBBotExhaust = class(TBBotAction)
  private
    LOffensive: BLock;
    LDefensive: BLock;
    LItem: BLock;
    LTileCleanup: BLock;
    function GetDefensive: BBool;
    function GetOffensive: BBool;
    function GetItem: BBool;
    procedure OnUseItem(ID: BInt32);
    function GetTileCleanup: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    property Offensive: BBool read GetOffensive;
    property Defensive: BBool read GetDefensive;
    property Item: BBool read GetItem;
    property TileCleanup: BBool read GetTileCleanup;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnUseOnCreature(AUseOnCreatureData: TTibiaUseOnCreature);
    procedure OnUseOnItem(AUseOnItemData: TTibiaUseOnItem);
    procedure OnSpell(ASpell: TTibiaSpell);
    procedure OnWalk(FromPos: BPos);

    procedure ExhaustOffensive;
    procedure ExhaustDefensive;
    procedure ExhaustItem;
    procedure ExhaustTileCleanup;
  end;

implementation

{ TBBotExhaust }

uses
  BBotEngine,
  uItem;

constructor TBBotExhaust.Create;
begin
  LOffensive := BLock.Create(BBotExhaustOffensive, 10);
  LDefensive := BLock.Create(BBotExhaustDefensive, 10);
  LItem := BLock.Create(BBotExhaustPotion, 10);
  LTileCleanup := BLock.Create(500, 150);
  inherited Create('Exhaust', 1000);
end;

destructor TBBotExhaust.Destroy;
begin
  LOffensive.Free;
  LDefensive.Free;
  LItem.Free;
  LTileCleanup.Free;
  inherited;
end;

procedure TBBotExhaust.ExhaustDefensive;
begin
  LDefensive.Lock;
end;

procedure TBBotExhaust.ExhaustItem;
begin
  LItem.Lock;
end;

procedure TBBotExhaust.ExhaustOffensive;
begin
  LOffensive.Lock;
end;

procedure TBBotExhaust.ExhaustTileCleanup;
begin
  LTileCleanup.Lock;
end;

function TBBotExhaust.GetDefensive: BBool;
begin
  Result := LDefensive.Locked;
end;

function TBBotExhaust.GetItem: BBool;
begin
  Result := LItem.Locked;
end;

function TBBotExhaust.GetTileCleanup: BBool;
begin
  Result := LTileCleanup.Locked;
end;

function TBBotExhaust.GetOffensive: BBool;
begin
  Result := LOffensive.Locked;
end;

procedure TBBotExhaust.OnInit;
begin
  BBot.Events.OnWalk.Add(OnWalk);
  BBot.Events.OnSpell.Add(OnSpell);
  BBot.Events.OnUseOnCreature.Add(OnUseOnCreature);
  BBot.Events.OnUseOnItem.Add(OnUseOnItem);

  BBot.Macros.Registry.CreateSystemVariable(BBotExhaustOffensiveVar,
    BBotExhaustOffensive).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      LOffensive.Delay := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable(BBotExhaustDefensiveVar,
    BBotExhaustDefensive).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      LDefensive.Delay := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable(BBotExhaustPotionVar,
    BBotExhaustPotion).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      LItem.Delay := AValue;
    end);
end;

procedure TBBotExhaust.OnSpell(ASpell: TTibiaSpell);
begin
  if ASpell.Kind = tskAttack then
    LOffensive.Lock
  else if (ASpell.Kind = tskHealing) or (ASpell.Kind = tskSupport) then
    LDefensive.Lock;
end;

procedure TBBotExhaust.OnUseItem(ID: BInt32);
var
  Item: TTibiaItem;
begin
  Item := TTibiaItem.Create;
  Item.SetItem(ID, 0, 0, 0, BPosXYZ(0, 0, 0));
  if Item.CausesDefensiveExhaust then
    LDefensive.Lock;
  if Item.CausesHostileExhaust then
    LOffensive.Lock;
  if Item.CausesPotionExhaust then
    LItem.Lock;
  Item.Free;
end;

procedure TBBotExhaust.OnUseOnCreature(AUseOnCreatureData: TTibiaUseOnCreature);
begin
  OnUseItem(AUseOnCreatureData.ItemID);
end;

procedure TBBotExhaust.OnUseOnItem(AUseOnItemData: TTibiaUseOnItem);
begin
  OnUseItem(AUseOnItemData.FromID);
end;

procedure TBBotExhaust.OnWalk(FromPos: BPos);
begin
  if FromPos.Z <> Me.Position.Z then
    LOffensive.Lock;
end;

procedure TBBotExhaust.Run;
begin
end;

end.

