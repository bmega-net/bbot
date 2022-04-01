unit uBBotSummonDetector;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uBattlelist,
  uTibiaDeclarations,

  uBBotSpells,
  SysUtils;

const
  BBotAttackerSummonMessages: array [0 .. 1] of BStr = ('You may not attack this person.',
    'Adjust your combat settings to attack this player.');

type
  TBBotSummonDetector = class(TBBotAction)
  private type
    TRecentlySummoned = record
      Name: BStr;
      Summoner: BStr;
      Time: BUInt32;
      Confirmed: BBool;
    end;

    TRecentlyAppeared = record
      ID: BUInt32;
      Time: BUInt32;
      Confirmed: BBool;
    end;
  private
    RecentlySummoned: BVector<TRecentlySummoned>;
    RecentlyAppeared: BVector<TRecentlyAppeared>;
    Summons: BVector<BUInt32>;
  protected
    procedure _Calculate;
    procedure Calculate;
  public
    constructor Create;
    destructor Destroy; override;

    procedure OnInit; override;
    procedure Run; override;

    function isSummon(const AID: BUInt32): BBool; overload;
    function isSummon(const ACreature: TBBotCreature): BBool; overload;

    procedure Reset;

    procedure OnSystemMessage(AMessageData: TTibiaMessage);
    procedure OnMessage(AMsg: TTibiaMessage);
    procedure OnCreature(ACreature: TBBotCreature);
  end;

implementation

uses
  BBotEngine;

const
  MaxHistoryTTL = 5 * 1000;
  MatchDuration = 300;

  { TBBotSummonDetector }

procedure TBBotSummonDetector.Calculate;
begin
  ActionNext.UnLock;
end;

constructor TBBotSummonDetector.Create;
begin
  inherited Create('SummonDetector', 1000);
  RecentlySummoned := BVector<TRecentlySummoned>.Create;
  RecentlyAppeared := BVector<TRecentlyAppeared>.Create;
  Summons := BVector<BUInt32>.Create;
end;

destructor TBBotSummonDetector.Destroy;
begin
  RecentlySummoned.Free;
  RecentlyAppeared.Free;
  Summons.Free;
  inherited;
end;

function TBBotSummonDetector.isSummon(const AID: BUInt32): BBool;
begin
  Exit(Summons.Has('Summon Detector - isSummon query',
    function(AIt: BVector<BUInt32>.It): BBool
    begin
      Exit(AIt^ = AID);
    end));
end;

function TBBotSummonDetector.isSummon(const ACreature: TBBotCreature): BBool;
begin
  Exit(isSummon(ACreature.ID));
end;

procedure TBBotSummonDetector.Reset;
begin
  RecentlySummoned.Clear;
  RecentlyAppeared.Clear;
  Summons.Clear;
end;

procedure TBBotSummonDetector.Run;
begin
  _Calculate;
  RecentlySummoned.Delete(
    function(AIt: BVector<TRecentlySummoned>.It): BBool
    begin
      Exit(AIt^.Time < (Tick - MaxHistoryTTL));
    end);
  RecentlyAppeared.Delete(
    function(AIt: BVector<TRecentlyAppeared>.It): BBool
    begin
      Exit(AIt^.Time < (Tick - MaxHistoryTTL));
    end);
end;

procedure TBBotSummonDetector._Calculate;
begin
  RecentlySummoned.ForEach(
    procedure(ASummoned: BVector<TRecentlySummoned>.It)
    begin
      if ASummoned^.Confirmed then
        Exit;
      RecentlyAppeared.Find('Summon Detector - calculator',
        function(AAppeared: BVector<TRecentlyAppeared>.It): BBool
        var
          EStart, EEnd: BUInt32;
        begin
          if AAppeared^.Confirmed then
            Exit(False);
          EStart := BMin(ASummoned^.Time, AAppeared^.Time);
          EEnd := BMax(ASummoned^.Time, AAppeared^.Time);
          if (EEnd - EStart) < MatchDuration then begin
            AddDebug(BBot.Creatures.Find(AAppeared^.ID), 'Possible summon');
            AAppeared^.Confirmed := True;
            ASummoned^.Confirmed := True;
            Summons.Add(AAppeared^.ID);
            Exit(True);
          end;
          Exit(False);
        end);
    end);
end;

procedure TBBotSummonDetector.OnCreature(ACreature: TBBotCreature);
var
  Added: BVector<TRecentlyAppeared>.It;
begin
  Added := RecentlyAppeared.Add;
  Added^.ID := ACreature.ID;
  Added^.Time := Tick;
  Added^.Confirmed := False;
  Calculate;
end;

procedure TBBotSummonDetector.OnInit;
begin
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);
  BBot.Events.OnSay.Add(OnMessage);
  BBot.Events.OnMessage.Add(OnMessage);
  BBot.Events.OnCreature.Add(OnCreature);
end;

procedure TBBotSummonDetector.OnMessage(AMsg: TTibiaMessage);
var
  Spell: TTibiaSpell;
  SummonName: BStr;
  Added: BVector<TRecentlySummoned>.It;
begin
  Spell := BBot.Spells.Spell(AMsg.Text);
  if Spell <> nil then
    if Spell.Kind = tskSummon then begin
      SummonName := BStrRight(AMsg.Text, Spell.Spell);
      SummonName := BTrim(BStrReplaceSensitive(SummonName, '"', ''));
      Added := RecentlySummoned.Add;
      Added^.Summoner := AMsg.Author;
      Added^.Name := SummonName;
      Added^.Time := Tick;
      Added^.Confirmed := False;
      Calculate;
    end;
end;

procedure TBBotSummonDetector.OnSystemMessage(AMessageData: TTibiaMessage);
var
  I: BInt32;
begin
  for I := 0 to High(BBotAttackerSummonMessages) do
    if AMessageData.Text = BBotAttackerSummonMessages[I] then begin
      if BBot.Attacker.Debug then
        AddDebug('Summon detected, attacking next');
      // BBot.IgnoreAttack.Add(ID, SummonIgnoreTime.ValueU32, 'summon detection');
      BBot.Attacker.AttackBest;
    end;
end;

end.
