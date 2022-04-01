unit uBBotAttackSequence;

interface

uses
  uBTypes,
  uBVector,

  uBattlelist;

type
  TBBotAttackSequence = class
  private type
    TAttackEntryKind = (aekWait, aekItem, aekMacro, aekSpell);

    TAttackEntry = record
      Kind: TAttackEntryKind;
      ParamStr: BStr;
      ParamInt: BInt32;
      Mana: BInt32;
      HPMin: BInt32;
      HPMax: BInt32;
      VariableCheck: BStr;
    end;
  private
    Seq: BVector<TAttackEntry>;
    FNext: BLock;
    FIndex: BVectorIndex;
    FCode: BStr;
    FName: BStr;
  protected
    function Get: BVector<TAttackEntry>.It;
    procedure Next;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(ACode: BStr);
    property Code: BStr read FCode;
    property Name: BStr read FName;

    function CanExecute: BBool;

    function Execute: BBool; overload;
    function Execute(ATarget: TBBotCreature): BBool; overload;
    function Execute(ATarget: BPos): BBool; overload;
    function InstantlyExecute: BBool;
  end;

implementation

uses
  BBotEngine,

  Math,
  StrUtils,
  SysUtils,
  uTiles,
  uUserError;

{ TTibiaAttack }

function TBBotAttackSequence.CanExecute: BBool;
var
  It: BVector<TAttackEntry>.It;
begin
  Result := (not Seq.Empty) and (not FNext.Locked) and (not BBot.Exhaust.Offensive);
  if Result then begin
    It := Get;
    Result := (Me.Mana >= It^.Mana) and ((It^.VariableCheck = '') or (BBot.Cavebot.FullCheck(It^.VariableCheck)));
  end;
end;

constructor TBBotAttackSequence.Create;
begin
  Seq := BVector<TAttackEntry>.Create;
  FIndex := 0;
  FNext := BLock.Create(800, 20);
end;

destructor TBBotAttackSequence.Destroy;
begin
  FNext.Free;
  Seq.Free;
  inherited;
end;

function TBBotAttackSequence.Execute(ATarget: TBBotCreature): BBool;
var
  It: BVector<TAttackEntry>.It;
begin
  if (ATarget <> nil) and (CanExecute) then begin
    It := Get;
    if BInRange(ATarget.Health, It^.HPMin, It^.HPMax) then begin
      case It^.Kind of
      aekWait: FNext.Lock(It^.ParamInt);
      aekItem: begin
          if not BBot.Exhaust.Item then
            ATarget.ShootOn(It^.ParamInt);
        end;
      aekMacro: begin
          BBot.Macros.Execute(It^.ParamStr);
          FNext.Lock;
        end;
      aekSpell: Me.Say(It^.ParamStr);
      end;
      Next;
      Exit(true);
    end;
  end;
  Exit(False);
end;

function TBBotAttackSequence.Execute(ATarget: BPos): BBool;
var
  It: BVector<TAttackEntry>.It;
  Map: TTibiaTiles;
  Creature: TBBotCreature;
begin
  if Me.CanSee(ATarget) and (CanExecute) then begin
    It := Get;
    case It^.Kind of
    aekWait: FNext.Lock(It^.ParamInt);
    aekItem: begin
        if not BBot.Exhaust.Item then begin
          Creature := BBot.Creatures.Find(ATarget);
          if (Creature <> nil) and (Creature.IsAlive) then
            Creature.ShootOn(It^.ParamInt)
          else if Tiles(Map, ATarget) then
            Map.UseOn(It^.ParamInt);
        end;
      end;
    aekMacro: begin
        BBot.Macros.Execute(It^.ParamStr);
        FNext.Lock;
      end;
    aekSpell: Me.Say(It^.ParamStr);
    end;
    Next;
    Exit(true);
  end;
  Exit(False);
end;

function TBBotAttackSequence.Get: BVector<TAttackEntry>.It;
begin
  Exit(Seq[FIndex]);
end;

function TBBotAttackSequence.Execute: BBool;
begin
  Result := Execute(BBot.Creatures.Target);
end;

function TBBotAttackSequence.InstantlyExecute: BBool;
begin
  FNext.UnLock;
  Result := Execute;
end;

procedure TBBotAttackSequence.Load(ACode: BStr);
var
  R, S: BStrArray;
  I: BInt32;
  Add: BVector<TAttackEntry>.It;
  Err: BUserError;
begin
  FCode := ACode;
  FIndex := 0;
  Seq.Clear;
  FName := BStrBetween(ACode, '{', '}');
  if FName <> '' then begin
    Delete(ACode, 1, Length(FName) + 2);
    if BStrSplit(R, ';', ';' + ACode + ';') > 0 then begin
      for I := 0 to High(R) do begin
        if BStrSplit(S, ' ', Trim(R[I])) >= 4 then begin
          Add := Seq.Add;
          Add^.Mana := StrToIntDef(S[1], 0);
          Add^.HPMin := StrToIntDef(S[2], 0);
          Add^.HPMax := StrToIntDef(S[3], 0);
          Add^.ParamInt := StrToIntDef(S[4], 0);
          Add^.VariableCheck := BStrBetween(R[I], 'Check ', ' ECheck');
          Add^.ParamStr := BStrRight(R[I], BIf(BStrPos('ECheck', R[I]) > 0, 'ECheck:', ':'));
          if S[0] = '!' then
            Add^.Kind := aekWait;
          if S[0] = '@' then
            Add^.Kind := aekItem;
          if S[0] = '#' then
            Add^.Kind := aekMacro;
          if S[0] = '$' then
            if Length(Add^.ParamStr) > 2 then
              Add^.Kind := aekSpell
            else begin
              Err := BUserError.Create(BBot.AdvAttack, BFormat('Empty spell on attack sequence "%s"', [Name]));
              Err.Actions := [uraEditAdvancedAttack];
              Err.Execute;
            end;
        end;
      end;
    end;
  end;
end;

procedure TBBotAttackSequence.Next;

begin
  FIndex := (FIndex + 1) mod Seq.Count;
end;

end.
