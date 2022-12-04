unit uBBotFriendHealer;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction;

type
  TBBotFriendHealer = class(TBBotAction)
  private type
    TFriendHealData = record
      Name: BStr;
      HP: BInt32;
      MyHP: BInt32;
      MyMana: BInt32;
      Use: BInt32;
      UseSpell: BStr;
    end;
  private
    Data: BVector<TFriendHealData>;
    FEnabled: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    property Enabled: BBool read FEnabled write FEnabled;

    procedure AddFriend(Code: BStr);
    procedure ClearFriends;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uBattlelist,
  uTibiaDeclarations;

{ TBBotFriendHealer }

procedure TBBotFriendHealer.AddFriend(Code: BStr);
var
  Ret: BStrArray;
  Add: BVector<TFriendHealData>.It;
begin
  BStrSplit(Ret, ';', Code);
  if High(Ret) <> 6 then
    Exit;
  Add := Data.Add;
  Add^.Name := Ret[0];
  Add^.HP := BStrTo32(Ret[1], 0);
  Add^.MyHP := BStrTo32(Ret[2], 0);
  Add^.MyMana := BStrTo32(Ret[3], 0);
  Add^.Use := BStrTo32(Ret[5], 0);
  Add^.UseSpell := Ret[6];
end;

procedure TBBotFriendHealer.ClearFriends;
begin
  Data.Clear;
end;

constructor TBBotFriendHealer.Create;
begin
  inherited Create('Friend Healer', 500);
  FEnabled := False;
  Data := BVector<TFriendHealData>.Create;
end;

destructor TBBotFriendHealer.Destroy;
begin
  Data.Free;
  inherited;
end;

procedure TBBotFriendHealer.Run;
begin
  if Enabled and (not Data.Empty) then
  begin
    BBot.Creatures.Has(
      function(Creature: TBBotCreature): BBool
      begin
        Result := Data.Has('Friend Healer 2 - ' + Creature.Name,
          function(It: BVector<TFriendHealData>.It): BBool
          begin
            if Me.HP >= It^.MyHP then
              if Me.Mana >= It^.MyMana then
                if BInRange(Creature.Health, 1, It^.HP) then
                  if (BStrEqual(Creature.Name, It^.Name)) or
                    (((Creature.Party.Player = PartyMember) or
                    (Creature.Party.Player = PartyLeader)) and
                    (It^.Name = 'Party')) or ((Creature.IsAlly) and
                    (It^.Name = 'Allies')) then
                  begin
                    if (It^.Use <> 1) and (not BBot.Exhaust.Item) then
                    begin
                      Creature.ShootOn(It^.Use);
                      Exit(True);
                    end
                    else if (It^.Use = 1) and (not BBot.Exhaust.Defensive) then
                    begin
                      Me.Say(BStrReplace(It^.UseSpell, '%Name', Creature.Name));
                      Exit(True);
                    end;
                  end;
            Result := False;
          end);
      end);
  end;
end;

end.

