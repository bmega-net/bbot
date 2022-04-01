unit uBBotWarBot;


interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uTibiaDeclarations,
  Declaracoes,
  Classes,
  windows,
  SysUtils,
  math,

  uBattlelist,
  uHUD,
  uBBotAttackSequence,
  syncobjs,
  uBBotSpells,

  uBBotGUIMessages;

type
  TBBotWarBot = class(TBBotAction)
  private
    FAimbot: BBool;
    FCombo: BBool;
    FLockTarget: BBool;
    FLockTargetID: BUInt32;
    FComboLeaders: BStr;
    FAimbotIndex: BInt32;
    FPushParalyzedEnemies: boolean;
    FNETCombo: boolean;
    FMagicWallID: BInt32;
    FMarkAlliesAndEnemies: boolean;
    FCreatureLevels: boolean;
    FAllies: BStrArray;
    FEnemies: BStrArray;
    FAutoAttackEnemies: BBool;
    FMWallOnFrontOfEnemies: BBool;
    FMarkPlayersAsEnemy: BBool;
    FMarkPartyMembersAsAlly: BBool;
    FComboSetAttack: BBool;
    FComboParalyzedEnemies: BBool;
    FComboSay: BBool;
    FComboSayText: BStr;
    FAlliesEnemiesVersion: BInt32;
    FPlayerGroups: BBool;
    FNETComboAtkCode: BStr;
    FComboAttackCode: BStr;
    FAimbotRunesCode: array [0 .. 2] of BStr;
    function GetAimbotRunes(Index: BInt32): TBBotAttackSequence;
    procedure SetComboLeaders(const Value: BStr);
    procedure SetAimbotIndex(const Value: BInt32);
    procedure SetAimbot(const Value: BBool);
    procedure SetMarkAlliesAndEnemies(const Value: BBool);
    procedure SetCreatureLevels(const Value: BBool);
    procedure SetPlayerGroups(const Value: BBool);
    function GetDash: BBool;
    procedure SetDash(const Value: BBool);
    function GetComboAttack: TBBotAttackSequence;
    function GetNETComboAtk: TBBotAttackSequence;
    function GetAimbotRunesCode(Index: BInt32): BStr;
    procedure SetAimBotRunesCode(Index: BInt32; const Value: BStr);
  protected
    CreatureBigTickBlock: array [0 .. 1300] of cardinal;
    DashWarning: BBool;
    procedure CreatureBigTickReset;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure Status(S: BStr);

    procedure OnCreatureHUD(HUD: TBBotHUD; Creature: TBBotCreature);
    procedure OnHotkey;
    procedure OnTarget(OldCreature: TBBotCreature);
    procedure OnMissileEffect(AMissileEffect: TTibiaMissileEffect);
    procedure OnMessage(AMessageData: TTibiaMessage);
    procedure OnCreatureSpeed(Creature: TBBotCreature; OldSpeed: BInt32);
    procedure OnSpell(ASpell: TTibiaSpell);
    procedure OnUseOnCreature(AUseOnCreatureData: TTibiaUseOnCreature);
    procedure OnUseOnItem(AUseOnItemData: TTibiaUseOnItem);
    procedure OnCreatureTick(Creature: TBBotCreature);

    function IsLeader(Name: BStr): BBool;
    procedure DoCombo(BL: TBBotCreature);

    procedure MagicWall(X, Y, Z: BInt32; Sx, Sy: BInt32); overload;
    procedure MagicWall(Pos: BPos; Sx, Sy: BInt32); overload;
    procedure MagicWallInFrontOfTarget;

    property Dash: BBool read GetDash write SetDash;

    property Combo: BBool read FCombo write FCombo;
    property ComboSetAttack: BBool read FComboSetAttack write FComboSetAttack;
    property ComboSay: BBool read FComboSay write FComboSay;
    property ComboSayText: BStr read FComboSayText write FComboSayText;
    property ComboParalyzedEnemies: BBool read FComboParalyzedEnemies write FComboParalyzedEnemies;
    property ComboLeaders: BStr read FComboLeaders write SetComboLeaders;
    property ComboAttack: TBBotAttackSequence read GetComboAttack;
    property ComboAttackCode: BStr read FComboAttackCode write FComboAttackCode;

    property LockTarget: BBool read FLockTarget write FLockTarget;
    property LockTargetID: BUInt32 read FLockTargetID write FLockTargetID;

    property PushParalyzedEnemies: BBool read FPushParalyzedEnemies write FPushParalyzedEnemies;
    property MarkAlliesAndEnemies: BBool read FMarkAlliesAndEnemies write SetMarkAlliesAndEnemies;
    property AutoAttackEnemies: BBool read FAutoAttackEnemies write FAutoAttackEnemies;
    property MWallOnFrontOfEnemies: BBool read FMWallOnFrontOfEnemies write FMWallOnFrontOfEnemies;

    property MarkPartyMembersAsAlly: BBool read FMarkPartyMembersAsAlly write FMarkPartyMembersAsAlly;
    property MarkPlayersAsEnemy: BBool read FMarkPlayersAsEnemy write FMarkPlayersAsEnemy;

    property CreatureLevels: BBool read FCreatureLevels write SetCreatureLevels;
    property PlayerGroups: BBool read FPlayerGroups write SetPlayerGroups;

    property Aimbot: BBool read FAimbot write SetAimbot;
    property AimbotIndex: BInt32 read FAimbotIndex write SetAimbotIndex;
    property AimBotRunes[Index: BInt32]: TBBotAttackSequence read GetAimbotRunes;
    property AimBotRunesCode[Index: BInt32]: BStr read GetAimbotRunesCode write SetAimBotRunesCode;

    property NETCombo: BBool read FNETCombo write FNETCombo;
    property NETComboAtk: TBBotAttackSequence read GetNETComboAtk;
    property NETComboAtkCode: BStr read FNETComboAtkCode write FNETComboAtkCode;

    property Allies: BStrArray read FAllies;
    property Enemies: BStrArray read FEnemies;
    function IsEnemy(Name: BStr): BBool;
    function IsAlly(Name: BStr): BBool;
    property AlliesEnemiesVersion: BInt32 read FAlliesEnemiesVersion write FAlliesEnemiesVersion;
    procedure LoadAlliesAndEnemies(AAllies: TStrings; AEnemies: TStrings);

    property MagicWallID: BInt32 read FMagicWallID write FMagicWallID;
  end;

implementation

uses
  BBotEngine,
  uSelf,
  uTibia,
  uItem,
  uMain,
  uTiles,
  uTibiaState;

{ TBBotWarBot }

constructor TBBotWarBot.Create;
var
  I: BInt32;
begin
  inherited Create('Warbot', 100);
  for I := 1 to High(CreatureBigTickBlock) do
    CreatureBigTickBlock[I] := 0;
  FCombo := False;
  FComboSetAttack := True;
  FComboLeaders := '';
  FComboSay := True;
  FComboSayText := 'exiva';

  DashWarning := False;

  FLockTarget := False;
  FLockTargetID := 0;

  FPushParalyzedEnemies := False;
  FMarkAlliesAndEnemies := False;
  FCreatureLevels := False;
  FPlayerGroups := False;
  FAutoAttackEnemies := False;
  FMWallOnFrontOfEnemies := False;

  FMarkPartyMembersAsAlly := False;
  FMarkPlayersAsEnemy := False;

  MagicWallID := ItemID_MagicWall;
  FNETCombo := False;

  FAimbot := False;
  FAimbotIndex := 1; // Must be variable direct to not call Status..

  FAimbotRunesCode[0] := '';
  FAimbotRunesCode[1] := '';
  FAimbotRunesCode[2] := '';
  FNETComboAtkCode := '';
  FComboAttackCode := '';

  AlliesEnemiesVersion := GetUID;
end;

destructor TBBotWarBot.Destroy;
begin
  inherited;
end;

procedure TBBotWarBot.Run;
var
  BL: TBBotCreature;
begin
  if LockTarget and (not Me.IsAttacking) and (LockTargetID <> 0) then begin
    BL := BBot.Creatures.Find(LockTargetID);
    if (BL <> nil) and BL.IsOnScreen then
      BL.Attack;
  end;
end;

function TBBotWarBot.GetAimbotRunes(Index: BInt32): TBBotAttackSequence;
begin
  Result := BBot.AdvAttack.GetAttackSequence(FAimbotRunesCode[AimbotIndex - 1]);
end;

function TBBotWarBot.GetAimbotRunesCode(Index: BInt32): BStr;
begin
  Result := FAimbotRunesCode[Index - 1];
end;

function TBBotWarBot.GetComboAttack: TBBotAttackSequence;
begin
  Result := BBot.AdvAttack.GetAttackSequence(ComboAttackCode);
end;

function TBBotWarBot.GetDash: BBool;
begin
  Result := TibiaState^.Dash;
end;

function TBBotWarBot.GetNETComboAtk: TBBotAttackSequence;
begin
  Result := BBot.AdvAttack.GetAttackSequence(FNETComboAtkCode);
end;

procedure TBBotWarBot.OnCreatureSpeed(Creature: TBBotCreature; OldSpeed: BInt32);
var
  Map: TTibiaTiles;
begin
  if (Creature.Health < OldSpeed) and (Abs(Creature.Health - OldSpeed) > 60) then begin
    if Creature.IsEnemy then begin
      if ComboParalyzedEnemies then
        DoCombo(Creature);
      if PushParalyzedEnemies then
        if Me.DistanceTo(Creature) = 1 then
          if Tiles(Map, Creature.Position) then begin
            Map.CreatureOnTop;
            if (Map.ID = ItemID_Creature) and (BUInt32(Map.Count) = Creature.ID) then
              Map.ToGround(BPosXYZ(Map.Position.X + BRandom(-1, 1), Map.Position.Y + BRandom(-1, 1), Map.Position.Z));
          end;
    end;
  end;
end;

procedure TBBotWarBot.OnHotkey;
begin
  if MWallOnFrontOfEnemies and Tibia.IsKeyDown(VK_END, False) and Me.IsAttacking then
    MagicWallInFrontOfTarget;
  if Aimbot then begin
    if Tibia.IsKeyDown(VK_NEXT, True) then
      AimbotIndex := AimbotIndex + 1;
    if Me.IsAttacking then
      if Tibia.IsKeyDown(VK_PRIOR, False) then
        if AimBotRunes[AimbotIndex] <> nil then
          AimBotRunes[AimbotIndex].Execute;
  end;
end;

procedure TBBotWarBot.OnInit;
begin
  inherited;
  BBot.Events.OnCreatureSpeed.Add(OnCreatureSpeed);
  BBot.Events.OnCreatureTick.Add(OnCreatureTick);
  BBot.Events.OnTarget.Add(OnTarget);
  BBot.Events.OnHotkey.Add(OnHotkey);
  BBot.Events.OnSpell.Add(OnSpell);
  BBot.Events.OnUseOnCreature.Add(OnUseOnCreature);
  BBot.Events.OnUseOnItem.Add(OnUseOnItem);
  BBot.Events.OnMissileEffect.Add(OnMissileEffect);
  BBot.Events.OnMessage.Add(OnMessage);
end;

procedure TBBotWarBot.OnMissileEffect(AMissileEffect: TTibiaMissileEffect);
var
  BL: TBBotCreature;
begin
  if not Combo then
    Exit;
  BL := BBot.Creatures.Find(AMissileEffect.FromPosition);
  if BL <> nil then
    if not BL.IsSelf then
      if IsLeader(BL.Name) then begin
        BL := BBot.Creatures.Find(AMissileEffect.ToPosition);
        if BL <> nil then
          DoCombo(BL);
      end;
end;

procedure TBBotWarBot.OnTarget(OldCreature: TBBotCreature);
begin
  if Me.TargetID <> 0 then
    LockTargetID := Me.TargetID;
end;

procedure TBBotWarBot.OnUseOnCreature(AUseOnCreatureData: TTibiaUseOnCreature);
begin
  {
    TODOWARNET
    if NETCombo then
    if InRange(AUseOnCreatureData.ItemID, TibiaMinItems, TibiaLastItem) then
    if idfCausesHostileExhaust in TibiaItems[AUseOnCreatureData.ItemID].BotFlags
    then
    WarNet.SendCombo;
  }
end;

procedure TBBotWarBot.OnUseOnItem(AUseOnItemData: TTibiaUseOnItem);
begin
  {
    TODOWARNET
    if NETCombo then
    if AUseOnItemData.FromID = MagicWallID then
    WarNet.SendComboEx(AUseOnItemData.ToPosition.X,
    AUseOnItemData.ToPosition.Y, AUseOnItemData.ToPosition.Z);
  }
end;

procedure TBBotWarBot.SetAimbotIndex(const Value: BInt32);
begin
  FAimbotIndex := Value;
  if FAimbotIndex > 3 then
    FAimbotIndex := 1;
  if Aimbot then
    Status('[Aimbot] Selected attack: ' + IntToStr(FAimbotIndex));
end;

procedure TBBotWarBot.SetAimBotRunesCode(Index: BInt32; const Value: BStr);
begin
  FAimbotRunesCode[Index - 1] := Value;
end;

procedure TBBotWarBot.SetComboLeaders(const Value: BStr);
begin
  FComboLeaders := '#' + LowerCase(Value) + '#';
  FComboLeaders := StringReplace(FComboLeaders, ', ', '#', [rfReplaceAll]);
  FComboLeaders := StringReplace(FComboLeaders, ' ,', '#', [rfReplaceAll]);
  FComboLeaders := StringReplace(FComboLeaders, ',', '#', [rfReplaceAll]);
end;

procedure TBBotWarBot.Status(S: BStr);
var
  HUD: TBBotHUD;
begin
  HUDRemoveGroup(bhgAimbot);
  HUD := TBBotHUD.Create(bhgAimbot);
  HUD.AlignTo(bhaCenter, bhaBottom);
  HUD.Expire := 2000;
  HUD.Print(S, $FF99FF);
  HUD.Free;
end;

procedure TBBotWarBot.OnSpell(ASpell: TTibiaSpell);
begin
  {
    TODOWARNET
    if NETCombo and (ASpell.Kind = tskAttack) then
    WarNet.SendCombo;
  }
end;

procedure TBBotWarBot.MagicWall(X, Y, Z: BInt32; Sx, Sy: BInt32);
begin
  MagicWall(BPosXYZ(X, Y, Z), Sx, Sy);
end;

procedure TBBotWarBot.SetMarkAlliesAndEnemies(const Value: BBool);
begin
  FMarkAlliesAndEnemies := Value;
  if not Value then
    HUDRemoveGroup(bhgCreatureHUD);
  CreatureBigTickReset;
end;

procedure TBBotWarBot.SetPlayerGroups(const Value: BBool);
begin
  FPlayerGroups := Value;
  if not Value then
    HUDRemoveGroup(bhgCreatureHUD);
  CreatureBigTickReset;
end;

procedure TBBotWarBot.OnCreatureTick(Creature: TBBotCreature);
var
  HUD: TBBotHUD;
  MsgAlly: TBBotGUIMessageAddAlly;
  MsgEnemy: TBBotGUIMessageAddEnemy;
begin
  if AutoAttackEnemies then
    if not Me.IsAttacking then
      if Creature.IsEnemy then
        Creature.Attack;
  if (CreatureBigTickBlock[Creature.Index] < Tick) then begin
    CreatureBigTickBlock[Creature.Index] := Tick + 1000;
    if Creature.IsPlayer and (Creature.ID <> Me.ID) then begin
      if MarkPartyMembersAsAlly then
        if (Creature.Party.Player = PartyMember) or (Creature.Party.Player = PartyLeader) then
          if not Creature.IsAlly then begin
            MsgAlly := TBBotGUIMessageAddAlly.Create;
            MsgAlly.Ally := Creature.Name;
            FMain.AddBBotMessage(MsgAlly);
          end;
      if MarkPlayersAsEnemy then
        if not Creature.IsAlly then
          if not Creature.IsEnemy then begin
            MsgEnemy := TBBotGUIMessageAddEnemy.Create;
            MsgEnemy.Enemy := Creature.Name;
            FMain.AddBBotMessage(MsgEnemy);
          end;
    end;
    if (CreatureLevels) or (MarkAlliesAndEnemies) or (PlayerGroups) then begin
      HUD := TBBotHUD.Create(bhgCreatureHUD);
      OnCreatureHUD(HUD, Creature);
      HUD.Free;
    end;
  end;
end;

procedure TBBotWarBot.SetCreatureLevels(const Value: BBool);
begin
  FCreatureLevels := Value;
  if not Value then
    HUDRemoveGroup(bhgCreatureHUD);
  CreatureBigTickReset;
end;

procedure TBBotWarBot.OnCreatureHUD(HUD: TBBotHUD; Creature: TBBotCreature);
begin
  HUDRemoveCreatureGroup(Creature.ID, bhgCreatureHUD);
  HUD.Creature := Creature.ID;
  HUD.Expire := 5000;
  HUD.RelativeX := 0;
  if MarkAlliesAndEnemies then begin
    if Creature.IsAlly then begin
      HUD.Print('A', $FFD47F);
      HUD.RelativeX := HUD.RelativeX - 8;
    end;
    if Creature.IsEnemy then begin
      HUD.Print('E', $9090FF);
      HUD.RelativeX := HUD.RelativeX - 8;
    end;
  end;
  if CreatureLevels then begin
    HUD.Print('~' + IntToStr(Creature.Level), $00FFFF);
    HUD.RelativeX := HUD.RelativeX - (8 * (Length(HUD.Text)));
  end;
  if PlayerGroups and Creature.IsPlayer then
    HUD.Print('*' + IntToStr(Creature.GroupOnline), $FFFF00);
end;

procedure TBBotWarBot.MagicWall(Pos: BPos; Sx, Sy: BInt32);
var
  Map: TTibiaTiles;
  I, SS, X, Y: BInt32;
begin
  if not Me.CanSee(Pos) then
    Exit;
  UpdateMap;
  SS := 0;
  for I := 0 to 8 do begin
    X := Pos.X + (Sx * SS);
    Y := Pos.Y + (Sy * SS);
    if Tiles(Map, X, Y) then
      if Map.Shootable then begin
        Map.UseOn(MagicWallID);
        Exit;
      end;
    if (I mod 2) = 0 then
      Inc(SS);
    SS := SS * -1;
  end;
end;

procedure TBBotWarBot.MagicWallInFrontOfTarget;
var
  P: BPos;
begin
  if Me.IsAttacking then begin
    P := BBot.Creatures.Target.Position;
    case BBot.Creatures.Target.Direction of
    tdNorth: MagicWall(P.X, P.Y - 1, P.Z, 1, 0);
    tdSouth: MagicWall(P.X, P.Y + 1, P.Z, 1, 0);
    tdEast: MagicWall(P.X + 1, P.Y, P.Z, 0, 1);
    tdWest: MagicWall(P.X - 1, P.Y, P.Z, 0, 1);
  else;
    end;
  end;
end;

procedure TBBotWarBot.SetDash(const Value: BBool);
var
  HUD: TBBotHUD;
begin
  if Dash <> Value then begin
    TibiaState^.Dash := Value;
    if Value and (not DashWarning) then begin
      DashWarning := True;
      HUD := TBBotHUD.Create(bhgAny);
      HUD.AlignTo(bhaCenter, bhaTop);
      HUD.Color := $0099FF;
      HUD.Expire := 10000;
      HUD.Print('Warning!');
      HUD.Print('The Dash Feature uses a Tibia bug to walk faster,');
      HUD.Print('by using it you can be banished!');
      HUD.Print('< this message will vanish in # >');
      HUD.Free;
    end;
  end;
end;

procedure TBBotWarBot.CreatureBigTickReset;
var
  I: BInt32;
begin
  for I := 1 to High(CreatureBigTickBlock) do
    CreatureBigTickBlock[I] := 0;
end;

procedure TBBotWarBot.SetAimbot(const Value: BBool);
begin
  FAimbot := Value;
  Tibia.UnBlockKeyCallback(VK_NEXT, False, False);
  Tibia.UnBlockKeyCallback(VK_PRIOR, False, False);
  if Value then begin
    Tibia.BlockKeyCallback(VK_NEXT, False, False);
    Tibia.BlockKeyCallback(VK_PRIOR, False, False);
  end;
end;

procedure TBBotWarBot.OnMessage(AMessageData: TTibiaMessage);
var
  BL: TBBotCreature;
  Name: BStr;
  S: TTibiaSpell;
begin
  if Combo and ComboSay then
    if IsLeader(AMessageData.Author) then begin
      if BStrStart(LowerCase(AMessageData.Text), ComboSayText) then begin
        Name := AMessageData.Text;
        Delete(Name, 1, Max(Pos('"', Name), Length(ComboSayText) + 1));
        Name := Trim(Name);
        BL := BBot.Creatures.Find(Name);
        if BL <> nil then
          DoCombo(BL);
      end;
      S := BBot.Spells.Spell(AMessageData.Text);
      if S <> nil then
        if S.Kind = tskAttack then
          if Me.IsAttacking then
            DoCombo(BBot.Creatures.Target);
    end;
end;

function TBBotWarBot.IsLeader(Name: BStr): BBool;
begin
  Result := AnsiPos('#' + LowerCase(Name) + '#', ComboLeaders) > 0;
end;

procedure TBBotWarBot.DoCombo(BL: TBBotCreature);
begin
  if BL.IsOnScreen then begin
    if ComboAttack <> nil then
      ComboAttack.Execute;
    if ComboSetAttack and (not BL.IsTarget) then
      BL.Attack;
  end;
end;

procedure TBBotWarBot.LoadAlliesAndEnemies(AAllies, AEnemies: TStrings);
var
  I: BInt32;
begin
  AlliesEnemiesVersion := GetUID;
  SetLength(FAllies, AAllies.Count);
  for I := 0 to AAllies.Count - 1 do
    FAllies[I] := AAllies.Strings[I];
  SetLength(FEnemies, AEnemies.Count);
  for I := 0 to AEnemies.Count - 1 do
    FEnemies[I] := AEnemies.Strings[I];
end;

function TBBotWarBot.IsAlly(Name: BStr): BBool;
var
  I: BInt32;
begin
  if BStrEqual(Me.Name, Name) then
    Exit(True);
  for I := 0 to High(FAllies) do
    if BStrEqual(Name, FAllies[I]) then
      Exit(True);
  Result := False;
end;

function TBBotWarBot.IsEnemy(Name: BStr): BBool;
var
  I: BInt32;
begin
  for I := 0 to High(FEnemies) do
    if BStrEqual(Name, FEnemies[I]) then
      Exit(True);
  Result := False;
end;

end.

