unit uBBotConfirmAttack;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uBattlelist,

  uMacroVariable;

const
  BBotConfirmAttackTimeout = 8000;
  BBotConfirmAttackVerifyReachableTimeout = 8000;
  BBotAttackerHistoryTimeout = 5 * 1000;

type
  TBBotConfirmAttack = class(TBBotAction)
  private type
    THistoryData = record
      Creature: BUInt32;
      Expires: BUInt32;
    end;
  private
    FConfirmed: BBool;
    FConfirmTimeout: BLock;
    FVerifyReachable: BLock;
    FID: BUInt32;
    FHistoryTimeout: BMacroSystemVariable;
    AttackHistory: BVector<THistoryData>;
    procedure SetConfirmed(const Value: BBool);
  public
    constructor Create;
    destructor Destroy; override;

    procedure OnInit; override;
    procedure Run; override;

    procedure StartFor(ID: BUInt32);
    property Confirmed: BBool read FConfirmed write SetConfirmed;
    property ID: BUInt32 read FID;
    function AttackedByBot: BBool;
    function RecentlyAttacked(const AID: BUInt32): BBool; overload;
    function RecentlyAttacked(const ACreature: TBBotCreature): BBool; overload;

    property ConfirmTimeout: BLock read FConfirmTimeout;
    property VerifyReachable: BLock read FVerifyReachable;
    property HistoryTimeout: BMacroSystemVariable read FHistoryTimeout;

    procedure OnTarget(Creature: TBBotCreature);
    procedure OnCreatureHP(Creature: TBBotCreature; OldHP: BInt32);

    procedure AddHistory(Creature: TBBotCreature);
  end;

implementation

{ TBBotConfirmAttack }

uses
  BBotEngine;

procedure TBBotConfirmAttack.AddHistory(Creature: TBBotCreature);
begin
  if Creature <> nil then begin
    AttackHistory.AddOrUpdate('ConfirmAttack add ' + Creature.Name,
      function(AIt: BVector<THistoryData>.It): BBool
      begin
        Exit(AIt^.Creature = Creature.ID);
      end,
      procedure(Entry: BVector<THistoryData>.It)
      begin
        Entry^.Creature := Creature.ID;
        Entry^.Expires := Tick + HistoryTimeout.ValueU32;
      end);
  end;
end;

function TBBotConfirmAttack.AttackedByBot: BBool;
begin
  Result := (Me.TargetID <> 0) and (Me.TargetID = ID);
end;

constructor TBBotConfirmAttack.Create;
begin
  FConfirmTimeout := BLock.Create(BBotConfirmAttackTimeout, 0.4);
  FVerifyReachable := BLock.Create(BBotConfirmAttackVerifyReachableTimeout, 0.4);
  FConfirmed := True;
  FID := 0;
  AttackHistory := BVector<THistoryData>.Create;
  inherited Create('ConfirmAttack', 500);
end;

destructor TBBotConfirmAttack.Destroy;
begin
  FConfirmTimeout.Free;
  FVerifyReachable.Free;
  AttackHistory.Free;
  inherited;
end;

procedure TBBotConfirmAttack.OnCreatureHP(Creature: TBBotCreature; OldHP: BInt32);
begin
  if Creature.IsTarget and (ID = Creature.ID) and (not Confirmed) then
    Confirmed := True;
end;

procedure TBBotConfirmAttack.OnInit;
begin
  BBot.Events.OnCreatureHP.Add(OnCreatureHP);
  BBot.Events.OnTarget.Add(OnTarget);

  SysVariableLock('Attacker.ConfirmTime', ConfirmTimeout);
  SysVariableLock('Attacker.VerifyReachable', VerifyReachable);
  FHistoryTimeout := SysVariable('Attacker.HistoryTimeout', BBotAttackerHistoryTimeout);
end;

procedure TBBotConfirmAttack.OnTarget(Creature: TBBotCreature);
begin
  if Creature <> nil then
    AddHistory(Creature);
end;

function TBBotConfirmAttack.RecentlyAttacked(const AID: BUInt32): BBool;
begin
  Result := AttackHistory.Has('Confirm Attack - recently attacked query',
    function(AIt: BVector<THistoryData>.It): BBool
    begin
      Exit(AIt^.Creature = AID);
    end);
end;

function TBBotConfirmAttack.RecentlyAttacked(const ACreature: TBBotCreature): BBool;
begin
  Exit(RecentlyAttacked(ACreature.ID));
end;

procedure TBBotConfirmAttack.Run;
begin
  if Me.IsAttacking and (ID = Me.TargetID) then begin
    if (not Confirmed) and (not ConfirmTimeout.Locked) then begin
      if BBot.Attacker.Debug then
        AddDebug('confirmation timeout');
      BBot.Attacker.AttackNext;
    end else if Confirmed then begin
      if not VerifyReachable.Locked then begin
        if (not BBot.Creatures.Target.IsReachable) and (not BBot.Attacker.AttackNotReachable) then begin
          if BBot.Attacker.Debug then
            AddDebug('not reachable');
          BBot.Attacker.AttackNext;
        end
        else
          VerifyReachable.Lock;
      end;
      AddHistory(BBot.Creatures.Target);
    end;
  end;
  AttackHistory.Delete(
    function(AIt: BVector<THistoryData>.It): BBool
    begin
      Exit(AIt^.Expires < Tick);
    end);
end;

procedure TBBotConfirmAttack.SetConfirmed(const Value: BBool);
begin
  FConfirmed := Value;
  if Value then begin
    VerifyReachable.Lock;
    if BBot.Attacker.Debug then
      AddDebug('confirmed');
  end else begin
    ConfirmTimeout.Lock;
    if BBot.Attacker.Debug then
      AddDebug('confirmation started');
  end;
end;

procedure TBBotConfirmAttack.StartFor(ID: BUInt32);
begin
  FID := ID;
  Confirmed := False;
end;

end.
