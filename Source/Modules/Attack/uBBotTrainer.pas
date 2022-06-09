unit uBBotTrainer;

interface

uses
  uBTypes,
  uBBotAction,
  uBVector,
  uBattlelist;

type
  TBBotTrainer = class(TBBotAction)
  private
    Trainers: BVector<BUInt32>;
    FHPMin: BInt32;
    FSlime: BBool;
    FHP: BBool;
    FHPMax: BInt32;
    FPaused: BBool;
    procedure SetHP(const Value: BBool);
    procedure SetSlime(const Value: BBool);
  public
    constructor Create;
    destructor Destroy; override;

    property Slime: BBool read FSlime write SetSlime;
    property HP: BBool read FHP write SetHP;
    property HPMin: BInt32 read FHPMin write FHPMin;
    property HPMax: BInt32 read FHPMax write FHPMax;

    property Paused: BBool read FPaused write FPaused;

    procedure Run; override;
    procedure OnInit; override;

    procedure Clear;
    procedure Remove(ID: BUInt32);
    procedure Add(ID: BUInt32);

    function IsTrainer(ID: BUInt32): BBool;
    function IsAttackable(Creature: TBBotCreature): BBool;
    procedure OnCreatureAttack(Creature: TBBotCreature);
    procedure OnCreatureTick(Creature: TBBotCreature);
    procedure OnCreatureHP(Creature: TBBotCreature; OldHP: BInt32);
  end;

implementation

uses
  BBotEngine,
  uHUD;

{ TBBotTrainer }

procedure TBBotTrainer.Add(ID: BUInt32);
var
  HUD: TBBotHUD;
begin
  HUD := TBBotHUD.Create(bhgTrainer);
  HUD.Creature := ID;
  HUD.RelativeX := -12;
  HUD.Print('T', $00FF00);
  HUD.Free;
  Remove(ID);
  Trainers.Add(ID);
end;

function TBBotTrainer.IsAttackable(Creature: TBBotCreature): BBool;
begin
  Result := False;
  if (not Paused) and (HP or Slime) then begin
    if HP then begin
      if Creature.Health < HPMax then
        Exit(False);
      if not IsTrainer(Creature.ID) then
        Exit(False);
      Result := True;
    end;
    if Slime then begin
      if IsTrainer(Creature.ID) then
        Exit(False);
      if not Trainers.Has('Trainer - checking for master ' + Creature.Name,
        function(It: BVector<BUInt32>.It): BBool
        var
          CIt: TBBotCreature;
        begin
          Result := False;
          CIt := BBot.Creatures.Find(It^);
          if CIt <> nil then
            if BStrEqual(Creature.Name, CIt.Name) then
              Exit(True);
        end) then
        Exit(False);
      Result := True;
    end;
  end;
end;

function TBBotTrainer.IsTrainer(ID: BUInt32): BBool;
begin
  Result := Trainers.Has('Trainer - IsTrainer',
    function(It: BVector<BUInt32>.It): BBool
    begin
      Result := It^ = ID;
    end);
end;

procedure TBBotTrainer.Clear;
begin
  Trainers.Clear;
end;

constructor TBBotTrainer.Create;
begin
  inherited Create('Trainer', 1000);
  Trainers := BVector<BUInt32>.Create;
  FHP := False;
  FSlime := False;
  FPaused := False;
end;

destructor TBBotTrainer.Destroy;
begin
  Trainers.Free;
  inherited;
end;

procedure TBBotTrainer.OnCreatureAttack(Creature: TBBotCreature);
begin
  if IsAttackable(Creature) then
    BBot.Attacker.NewTask(Creature);
end;

procedure TBBotTrainer.OnCreatureHP(Creature: TBBotCreature; OldHP: BInt32);
begin
  if HP then
    if Creature.IsTarget then
      if Creature.Health <= HPMin then
        if BBot.ConfirmAttack.AttackedByBot then begin
          BBot.IgnoreAttack.AddAttacking(1000, 'min HP reached');
          BBot.Attacker.AttackNext;
        end;
end;

procedure TBBotTrainer.OnCreatureTick(Creature: TBBotCreature);
begin
  if IsAttackable(Creature) then
    if not(BBot.Attacker.AvoidKS and Creature.IsKillSteal) then
      BBot.Attacker.NewTask(Creature);
end;

procedure TBBotTrainer.OnInit;
begin
  inherited;
  BBot.Events.OnCreatureAttack.Add(OnCreatureAttack);
  BBot.Events.OnCreatureTick.Add(OnCreatureTick);
  BBot.Events.OnCreatureHP.Add(OnCreatureHP);
end;

procedure TBBotTrainer.Remove(ID: BUInt32);
begin
  HUDRemoveCreatureGroup(ID, bhgTrainer);
  Trainers.Delete(
    function(It: BVector<BUInt32>.It): BBool
    begin
      Result := It^ = ID;
    end);
end;

procedure TBBotTrainer.Run;
begin
end;

procedure TBBotTrainer.SetHP(const Value: BBool);
begin
  FHP := Value;
  FPaused := False;
end;

procedure TBBotTrainer.SetSlime(const Value: BBool);
begin
  FSlime := Value;
  FPaused := False;
end;

end.
