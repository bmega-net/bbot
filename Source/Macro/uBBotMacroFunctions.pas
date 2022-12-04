unit uBBotMacroFunctions;

interface

uses
  uMacroRegistry;

procedure MacroRegisterFunctions(const Registry: BMacroRegistryCore);
procedure MacroRegisterConstants(const Registry: BMacroRegistryCore);

implementation

uses
  uTiles,
  uBTypes,
  uMacroEngine,
  SysUtils,
  Math,
  StrUtils,
  uHUD,
  BBotEngine,
  uItem,
  uDownloader,
  Declaracoes,
  uContainer,
  Windows,

  uEngine,
  uTibiaDeclarations,
  uBattlelist,

  uBBotAddresses,
  uTibiaProcess,
  uTibiaState,
  uBBotAction,
  uBBotSpells,
  uBBotTradeWindow,
  uBVector,
  uEventCounter,
  uUserError,
  uIMacro,
  uMacroCore, uBBotMacros;

const
  YesNoDesc = ' -> :True | :False';
  ValidSlots =
    'Helmet, Head, Amulet, Backpack, Armor, RightHand, Right, LeftHand, Left, Legs, Boots, Ring, Ammunition, Ammo';

var
  MacroHUDColor: BInt32;
  MacroHUDHAlign: TBBotHUDAlign;
  MacroHUDVAlign: TBBotHUDVAlign;

procedure MacroDeprecated(M: BMacro; Text: BStr);
var
  HUD: TBBotHUD;
begin
  HUD := TBBotHUD.Create(bhgAny);
  HUD.AlignTo(bhaCenter, bhaTop);
  HUD.Expire := 1000;
  HUD.Print('[ Deprecated macro function ]', $FFCC00);
  HUD.PrintGray('On: ' + BMacroCore(M).CurrentOp);
  HUD.PrintGray('Tip: ' + Text);
  HUD.Free;
end;

function MacroErrorBuild(const AMessage: BStr): BUserError;
begin
  Result := BUserError.Create(BBot.MacroExec, AMessage);
  Result.Actions := [uraEditMacro, uraEditCavebot];
  Result.DisableMacros := True;
  Result.DisableCavebot := True;
end;

procedure MacroError(const AMessage: BStr);
begin
  MacroErrorBuild(AMessage).Execute;
end;

function TryParseSlot(const AName: BStr; var ASlot: TTibiaSlot): BBool;
begin
  ASlot := StrToSlot(AName);
  if BInRange(Ord(ASlot), Ord(SlotFirst), Ord(SlotLast)) then
  begin
    Exit(True);
  end
  else
  begin
    MacroError('Invalid slot in Self.Inventory.ID: "' + AName +
      '" valid slots: ' + ValidSlots);
    Exit(False);
  end;
end;

procedure MacroEquip(M: BMacro; ToSlot: TTibiaSlot);
var
  ID: BInt32;
  Item: TTibiaContainer;
begin
  ID := M.ParamInt(0);
  Item := ContainerFind(ID);
  if Item <> nil then
    Item.ToBody(ToSlot)
  else if AdrSelected > TibiaVer1076 then
    BBot.PacketSender.FastEquip(ID);
end;

procedure MacroUnEquip(M: BMacro; FromSlot: TTibiaSlot);
var
  Item: TTibiaItem;
  ToContainer: TTibiaContainer;
begin
  Item := Me.Inventory.GetSlot(FromSlot);
  ToContainer := ContainerAt(M.ParamInt(0), 0);
  if (Item.ID <> 0) and (ToContainer.Open) then
    ToContainer.PullHere(Item);
end;

procedure MacroDropEquip(M: BMacro; FromSlot: TTibiaSlot);
var
  Pos: BPos;
  Item: TTibiaItem;
begin
  Pos.X := M.ParamInt(0);
  Pos.Y := M.ParamInt(1);
  Pos.Z := M.ParamInt(2);
  Item := Me.Inventory.GetSlot(FromSlot);
  if Item.ID <> 0 then
    Item.ToGround(Pos);
end;

procedure MacroPickupEquip(M: BMacro; FromSlot: TTibiaSlot);
var
  Map: TTibiaTiles;
  ID, X, Y, Z, Range: BInt32;
begin
  ID := M.ParamInt(0);
  X := M.ParamInt(1);
  Y := M.ParamInt(2);
  Z := M.ParamInt(3);
  Range := M.ParamInt(4);
  if Me.Inventory.GetSlot(FromSlot).ID <> BUInt32(ID) then
    if TilesSearch(Map, BPosXYZ(X, Y, Z), Range, True,
      function: BBool
      begin
        Result := Map.ID = BUInt32(ID);
      end) then
    begin
      Map.ToBody(FromSlot);
      Exit;
    end;
end;

function ParamHUDVerticalAlign(M: BMacro; Param: BInt32): TBBotHUDVAlign;
begin
  if M.ParamInt(Param) = M.Constant('VTop') then
    Exit(bhaTop)
  else if M.ParamInt(Param) = M.Constant('VMiddle') then
    Exit(bhaMiddle)
  else if M.ParamInt(Param) = M.Constant('VBottom') then
    Exit(bhaBottom)
  else if M.Debugging then
    M.AddDebug('Invalid parameter for HUD Vertical Alignment: ' +
      M.ParamStr(Param));
  Exit(bhaTop);
end;

function ParamHUDHorizontalAlign(M: BMacro; Param: BInt32): TBBotHUDAlign;
begin
  if M.ParamInt(Param) = M.Constant('HLeft') then
    Exit(bhaLeft)
  else if M.ParamInt(Param) = M.Constant('HCenter') then
    Exit(bhaCenter)
  else if M.ParamInt(Param) = M.Constant('HRight') then
    Exit(bhaRight)
  else if M.Debugging then
    M.AddDebug('Invalid parameter for HUD Horizontal Alignment: ' +
      M.ParamStr(Param));
  Exit(bhaCenter);
end;

function DirectionToConstName(const ADir: TTibiaDirection): BStr;
begin
  Exit(BStrReplace(DirToStr(ADir), '-', ''));
end;

function DirectionToConst(const ADir: TTibiaDirection): BInt32;
begin
  Exit(BBot.Macros.Registry.Constants[DirectionToConstName(ADir)]);
end;

{$REGION 'When Functions'}

function WhenSafe(const F: BUnaryFunc<BMacro, BInt32>)
  : BUnaryFunc<BMacro, BInt32>;
begin
  Exit(
    function(M: BMacro): BInt32
    begin
      if (M is BMacroCore) and (not M.Debugging) and
        ((M as BMacroCore).Delay <> 1) then
      begin
        MacroError
          ('`When` functions can only be executed inside `once` macros (no auto macros/no manual macros)');
        Exit(BMacroFalse);
      end;
      Exit(F(M));
    end);
end;

function WhenMessage(const Registry: BMacroRegistryCore; const AWhenEvent: BStr)
  : BUnaryFunc<BMacro, BInt32>;
begin
  Exit(
    function(M: BMacro): BInt32
    var
      Pattern: BStr;
    begin
      Result := BMacroTrue;
      Pattern := M.ParamStr(1);
      if M.Debugging then
        M.AddDebugFmt('[When] Watching for %s from %s', [AWhenEvent, M.Name]);
      M.WatchWhen(AWhenEvent, M.ParamStr(0),
        function(): BBool
        var
          Subject: BStr;
        begin
          Subject := M.VariableStr('Message.Text');
          Result := Registry.MatchRegex(M, Pattern, Subject) = BMacroTrue;
          if M.Debugging then
            M.AddDebugFmt('[When] Casting %s to %s (exec %s)',
              [AWhenEvent, M.Name, M.ParamStr(0)]);
        end);
    end);
end;

procedure MacroRegisterWhenFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddFunc('When.Cast', 'WhenName', 'Cast a when event',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      if M.Debugging then
        M.AddDebugFmt('[When] Cast %s from %s', [M.ParamStr(0), M.Name]);
      M.CastWhen(M.ParamStr(0));
    end);
  Registry.AddFunc('When.UnWatch', '',
    'Unwatches for all the When event', WhenSafe(
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      if M.Debugging then
        M.AddDebug('[When] Unwatching');
      M.UnwatchWhen;
    end));
  Registry.AddFunc('When.AnyMessage', 'WhenLabel, MessagePattern',
    'Add a When listener for all kinds of messages (avoid: bad performance)',
    WhenSafe(WhenMessage(Registry, BWhenMsgAny)));
  Registry.AddFunc('When.Say', 'WhenLabel, MessagePattern',
    'Add a When listener for Say messages, when the current character says something',
    WhenSafe(WhenMessage(Registry, BWhenMsgSay)));
  Registry.AddFunc('When.Yell', 'WhenLabel, MessagePattern',
    'Add a When listener for Yell messages, when the current character says something',
    WhenSafe(WhenMessage(Registry, BWhenMsgYell)));
  Registry.AddFunc('When.SystemMessage', 'WhenLabel, MessagePattern',
    'Add a When listener for System kind of messages',
    WhenSafe(WhenMessage(Registry, BWhenMsgSystem)));
  Registry.AddFunc('When.PlayerMessage', 'WhenLabel, MessagePattern',
    'Add a When listener for Player kind of messages',
    WhenSafe(WhenMessage(Registry, BWhenMsgPlayer)));
  Registry.AddFunc('When.PrivateMessage', 'WhenLabel, MessagePattern',
    'Add a When listener for Private kind of messages',
    WhenSafe(WhenMessage(Registry, BWhenMsgPrivate)));
  Registry.AddFunc('When.NPCMessage', 'WhenLabel, MessagePattern',
    'Add a When listener for NPC kind of messages',
    WhenSafe(WhenMessage(Registry, BWhenMsgNPC)));
end;
{$ENDREGION}
{$REGION 'Self State'}

procedure MacroRegisterSelfStateFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Player State');
  Registry.AddFunc('Self.Health', '', 'Absolute player health',
    function(M: BMacro): BInt32
    begin
      Result := Me.HP;
    end);
  Registry.AddFunc('Self.Health%', '', 'Percent player health',
    function(M: BMacro): BInt32
    begin
      Result := BFloor(BToPercent(Me.HP, Me.HPMax));
    end);
  Registry.AddFunc('Self.HealthMax', '', 'Absolute max player health',
    function(M: BMacro): BInt32
    begin
      Result := Me.HPMax;
    end);
  Registry.AddFunc('Self.Mana', '', 'Absolute player mana',
    function(M: BMacro): BInt32
    begin
      Result := Me.Mana;
    end);
  Registry.AddFunc('Self.Mana%', '', 'Percent player mana',
    function(M: BMacro): BInt32
    begin
      Result := BFloor(BToPercent(Me.Mana, Me.ManaMax));
    end);
  Registry.AddFunc('Self.ManaMax', '', 'Absolute max player mana',
    function(M: BMacro): BInt32
    begin
      Result := Me.ManaMax;
    end);
  Registry.AddFunc('Self.StaminaMins', '', 'The player stamina minutes',
    function(M: BMacro): BInt32
    begin
      Result := Me.Stamina;
    end);
  Registry.AddFunc('Self.Stamina%', '', 'The percent of the player stamina',
    function(M: BMacro): BInt32
    begin
      Result := BFloor(BToPercent(Me.Stamina, 42 * 60));
    end);
  Registry.AddFunc('Self.Soul', '', 'The soul of the player',
    function(M: BMacro): BInt32
    begin
      Result := Me.Soul;
    end);
  Registry.AddFunc('Self.Experience', '', 'The experience of the player',
    function(M: BMacro): BInt32
    begin
      Result := Me.Experience;
    end);
  Registry.AddFunc('Self.ExpToNextLevel', '',
    'The experience left to the next level',
    function(M: BMacro): BInt32
    begin
      Result := Tibia.CalcExp(Me.Level + 1) - Me.Experience;
    end);
  Registry.AddFunc('Self.Level', '', 'The current player level',
    function(M: BMacro): BInt32
    begin
      Result := Me.Level;
    end);
  Registry.AddFunc('Self.Level%', '', 'The current percent of the player level',
    function(M: BMacro): BInt32
    begin
      Result := Me.LevelPercent;
    end);
  Registry.AddFunc('Self.Attacking', '', 'Is the player attacking' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(Me.IsAttacking);
    end);
  Registry.AddFunc('Self.MagicLevel', '', 'The player magic level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillMagic];
    end);
  Registry.AddFunc('Self.MagicLevel%', '', 'The player magic level percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillMagic];
    end);
  Registry.AddFunc('Self.CriticalHitChance', '',
    'The player critical hit chance',
    function(M: BMacro): BInt32
    begin
      Result := Me.SpecialSkill[SpecialSkillCriticalHitChance];
    end);
  Registry.AddFunc('Self.CriticalHitAmount', '',
    'The player critical hit amount',
    function(M: BMacro): BInt32
    begin
      Result := Me.SpecialSkill[SpecialSkillCriticalHitAmount];
    end);
  Registry.AddFunc('Self.HpLeechChance', '',
    'The player hitpoints leech chance',
    function(M: BMacro): BInt32
    begin
      Result := Me.SpecialSkill[SpecialSkillHpLeechChance];
    end);
  Registry.AddFunc('Self.HpLeechAmount', '',
    'The player hitpoints leech amount',
    function(M: BMacro): BInt32
    begin
      Result := Me.SpecialSkill[SpecialSkillHpLeechAmount];
    end);
  Registry.AddFunc('Self.ManaLeechChance', '', 'The player mana leech chance',
    function(M: BMacro): BInt32
    begin
      Result := Me.SpecialSkill[SpecialSkillManaLeechChance];
    end);
  Registry.AddFunc('Self.ManaLeechAmount', '', 'The player mana leech amount',
    function(M: BMacro): BInt32
    begin
      Result := Me.SpecialSkill[SpecialSkillManaLeechAmount];
    end);
  Registry.AddFunc('Self.Capacity', '', 'The player capacity',
    function(M: BMacro): BInt32
    begin
      Result := Me.Capacity div 100;
    end);
  Registry.AddFunc('Self.X', '', 'The player global position X',
    function(M: BMacro): BInt32
    begin
      Result := Me.Position.X;
    end);
  Registry.AddFunc('Self.Y', '', 'The player global position Y',
    function(M: BMacro): BInt32
    begin
      Result := Me.Position.Y;
    end);
  Registry.AddFunc('Self.Z', '', 'The player global position Z',
    function(M: BMacro): BInt32
    begin
      Result := Me.Position.Z;
    end);
  Registry.AddFunc('Self.Mount', '', 'The player mount id',
    function(M: BMacro): BInt32
    begin
      Result := 0;
      if AdrSelected >= TibiaVer870 then
        Result := Me.Outfit.Mount;
    end);
  Registry.AddFunc('Self.Balance', '',
    'The player current balance gathered from NPC Trade window',
    function(M: BMacro): BInt32
    begin
      Result := BBot.TradeWindow.BankBalance;
    end);
  Registry.AddFunc('Self.Direction', '',
    'The player direction -> :North | :East | :South | :West | :NorthEast | :SouthEast | :SouthWest | :NorthWest',
    function(M: BMacro): BInt32
    begin
      Result := DirectionToConst(Me.Direction);
    end);
end;
{$ENDREGION}
{$REGION 'Self.Status'}

procedure MacroRegisterSelfStatusFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Player Status');
  Registry.AddFunc('Status.Poison', '', 'The player poison status' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsPoisoned in Me.Status);
    end);
  Registry.AddFunc('Status.Fire', '', 'The player burning status' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsBurning in Me.Status);
    end);
  Registry.AddFunc('Status.Energy', '', 'The player electrified status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsElectrified in Me.Status);
    end);
  Registry.AddFunc('Status.Drunk', '', 'The player good drunk status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsDrunk in Me.Status);
    end);
  Registry.AddFunc('Status.ManaShield', '', 'The player mana shield status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsProtectedByMagicShield in Me.Status);
    end);
  Registry.AddFunc('Status.Paralysis', '', 'The player paralysis status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsParalysed in Me.Status);
    end);
  Registry.AddFunc('Status.Haste', '', 'The player haste status' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsHasted in Me.Status);
    end);
  Registry.AddFunc('Status.Battle', '', 'The player in battle status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsInBattle in Me.Status);
    end);
  Registry.AddFunc('Status.Underwater', '', 'The player under water status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsDrowning in Me.Status);
    end);
  Registry.AddFunc('Status.Freezing', '', 'The player freezing status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsFreezing in Me.Status);
    end);
  Registry.AddFunc('Status.Dazzled', '', 'The player dazzled status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsDazzled in Me.Status);
    end);
  Registry.AddFunc('Status.Cursed', '', 'The player cursed status' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsCursed in Me.Status);
    end);
  Registry.AddFunc('Status.Buff', '',
    'The player strengthened or buffered status' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsStrengthened in Me.Status);
    end);
  Registry.AddFunc('Status.PZBlock', '',
    'The player PZ block (cannot logout, enter pz) status' + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsCannotLogoutOrEnterProtectionZone in Me.Status);
    end);
  Registry.AddFunc('Status.InPZ', '', 'The player inside protection zone status'
    + YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsWithinProtectionZone in Me.Status);
    end);
  Registry.AddFunc('Status.NoLight', '', 'The player no light status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(not(tsLight in Me.Status));
    end);
  Registry.AddFunc('Status.Bleeding', '', 'The player bleeding status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsBleeding in Me.Status);
    end);
  Registry.AddFunc('Status.Invisible', '', 'The player invisible status' +
    YesNoDesc,
    function(M: BMacro): BInt32
    begin
      Result := MacroBool(tsInvisible in Me.Status);
    end);
end;
{$ENDREGION}
{$REGION 'Self.Inventory'}

procedure MacroRegisterSelfInventoryFunctions(const Registry
  : BMacroRegistryCore);
begin
  Registry.AddWikiSection('Player Inventory');
  Registry.AddFunc('Self.Inventory.Helmet', '',
    'The player Helmet slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Head.ID;
    end);
  Registry.AddFunc('Self.Inventory.Amulet', '',
    'The player Amulet slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Necklace.ID;
    end);
  Registry.AddFunc('Self.Inventory.Backpack', '',
    'The player Backpack slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Backpack.ID;
    end);
  Registry.AddFunc('Self.Inventory.Armor', '', 'The player Armor slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Armor.ID;
    end);
  Registry.AddFunc('Self.Inventory.RightHand', '',
    'The player Right Hand (->) slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Right.ID;
    end);
  Registry.AddFunc('Self.Inventory.LeftHand', '',
    'The player Left Hand (<-) slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Left.ID;
    end);
  Registry.AddFunc('Self.Inventory.Legs', '', 'The player Legs slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Legs.ID;
    end);
  Registry.AddFunc('Self.Inventory.Boots', '', 'The player Boots slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Feet.ID;
    end);
  Registry.AddFunc('Self.Inventory.Ring', '', 'The player Ring slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Ring.ID;
    end);
  Registry.AddFunc('Self.Inventory.Ammunition', '',
    'The player Ammunition slot item id',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Ammo.ID;
    end);
  Registry.AddFunc('Self.Inventory.Helmet.Count', '',
    'The player Helmet slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Head.Count;
    end);
  Registry.AddFunc('Self.Inventory.Amulet.Count', '',
    'The player Amulet slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Necklace.Count;
    end);
  Registry.AddFunc('Self.Inventory.Backpack.Count', '',
    'The player Backpack slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Backpack.Count;
    end);
  Registry.AddFunc('Self.Inventory.Armor.Count', '',
    'The player Armor slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Armor.Count;
    end);
  Registry.AddFunc('Self.Inventory.RightHand.Count', '',
    'The player Right Hand (->) slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Right.Count;
    end);
  Registry.AddFunc('Self.Inventory.LeftHand.Count', '',
    'The player Left Hand (<-) slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Left.Count;
    end);
  Registry.AddFunc('Self.Inventory.Legs.Count', '',
    'The player Legs slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Legs.Count;
    end);
  Registry.AddFunc('Self.Inventory.Boots.Count', '',
    'The player Boots slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Feet.Count;
    end);
  Registry.AddFunc('Self.Inventory.Ring.Count', '',
    'The player Ring slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Ring.Count;
    end);
  Registry.AddFunc('Self.Inventory.Ammunition.Count', '',
    'The player Ammunition slot item count',
    function(M: BMacro): BInt32
    begin
      Result := Me.Inventory.Ammo.Count;
    end);
  Registry.AddFunc('Self.Inventory.ID', 'Slot',
    'Get the ID of a inventory slot. Slots: ' + ValidSlots,
    function(M: BMacro): BInt32
    var
      Slot: TTibiaSlot;
    begin
      if TryParseSlot(M.ParamStr(0), Slot) then
        Exit(Me.Inventory.GetSlot(Slot).ID)
      else
        Exit(BMacroFalse);
    end);
  Registry.AddFunc('Self.Inventory.Count', 'Slot',
    'Get the count of a inventory slot. Slots: ' + ValidSlots,
    function(M: BMacro): BInt32
    var
      Slot: TTibiaSlot;
    begin
      if TryParseSlot(M.ParamStr(0), Slot) then
        Exit(Me.Inventory.GetSlot(Slot).Count)
      else
        Exit(BMacroFalse);
    end);
  Registry.AddFunc('Self.Inventory.UseOn', 'Slot, UseID',
    'Use a item into a slot (e.g: enchant item). Slots: ' + ValidSlots,
    function(M: BMacro): BInt32
    var
      Slot: TTibiaSlot;
    begin
      if TryParseSlot(M.ParamStr(0), Slot) then
      begin
        Me.Inventory.GetSlot(Slot).UseOn(M.ParamInt(1));
        Exit(BMacroTrue);
      end
      else
        Exit(BMacroFalse);
    end);
end;
{$ENDREGION}
{$REGION 'Self.Skills'}

procedure MacroRegisterSelfSkillsFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Player Skills');
  Registry.AddFunc('Self.Skill.Fist', '', 'The current First skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillFist];
    end);
  Registry.AddFunc('Self.Skill.Club', '', 'The current Club skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillClub];
    end);
  Registry.AddFunc('Self.Skill.Axe', '', 'The current Axe skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillAxe];
    end);
  Registry.AddFunc('Self.Skill.Sword', '', 'The current Sword skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillSword];
    end);
  Registry.AddFunc('Self.Skill.Distance', '',
    'The current Distance skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillDistance];
    end);
  Registry.AddFunc('Self.Skill.Shielding', '',
    'The current Shielding skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillShielding];
    end);
  Registry.AddFunc('Self.Skill.Fishing', '', 'The current Fishing skill level',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillLevel[SkillFishing];
    end);
  Registry.AddFunc('Self.Skill.Fist%', '', 'The current First skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillFist];
    end);
  Registry.AddFunc('Self.Skill.Club%', '', 'The current Club skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillClub];
    end);
  Registry.AddFunc('Self.Skill.Axe%', '', 'The current Axe skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillAxe];
    end);
  Registry.AddFunc('Self.Skill.Sword%', '', 'The current Sword skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillSword];
    end);
  Registry.AddFunc('Self.Skill.Distance%', '',
    'The current Distance skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillDistance];
    end);
  Registry.AddFunc('Self.Skill.Shielding%', '',
    'The current Shielding skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillShielding];
    end);
  Registry.AddFunc('Self.Skill.Fishing%', '',
    'The current Fishing skill percent',
    function(M: BMacro): BInt32
    begin
      Result := Me.SkillPercent[SkillFishing];
    end);
end;
{$ENDREGION}
{$REGION 'Self.Actions'}

procedure MacroRegisterSelfActionsFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Player Actions');
  Registry.AddFunc('Self.Say', 'Text', 'Say a text in the default channel',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Say(M.ParamStr(0));
    end);
  Registry.AddFunc('Self.Whisper', 'Text',
    'Whisper a text in the default channel',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Whisper(M.ParamStr(0));
    end);
  Registry.AddFunc('Self.Yell', 'Text', 'Yell a text in the game',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Yell(M.ParamStr(0));
    end);
  Registry.AddFunc('Self.PrivateMessage', 'ToPlayer, Text',
    'Send a private message to a player',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.PrivateMessage(M.ParamStr(1), M.ParamStr(0));
    end);
  Registry.AddFunc('Self.Stop', '', 'Stop current action',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Stop;
    end);
  Registry.AddFunc('Self.PositionIn', 'X1, Y1, Z1, X2, Y2, Z2',
    'Check if the player is in a position box' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      X, Y, Z: BBool;
    begin
      X := InRange(Me.Position.X, M.ParamInt(0), M.ParamInt(3));
      Y := InRange(Me.Position.Y, M.ParamInt(1), M.ParamInt(4));
      Z := InRange(Me.Position.Z, M.ParamInt(2), M.ParamInt(5));
      Result := MacroBool(X and Y and Z);
    end);
  Registry.AddFunc('Self.MoveTo', 'X, Y, Z', 'Walk to a position',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Tibia.SetMove(BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2)));
    end);
  Registry.AddFunc('Self.MoveN|Self.StepNorth', '', 'Step one sqm to the north',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdNorth);
    end);
  Registry.AddFunc('Self.MoveS|Self.StepSouth', '', 'Step one sqm to the south',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdSouth);
    end);
  Registry.AddFunc('Self.MoveE|Self.StepEast', '', 'Step one sqm to the east',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdEast);
    end);
  Registry.AddFunc('Self.MoveW|Self.StepWest', '', 'Step one sqm to the west',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdWest);
    end);
  Registry.AddFunc('Self.MoveNE|Self.StepNorthEast', '',
    'Step one sqm to the north east',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdNorthEast);
    end);
  Registry.AddFunc('Self.MoveNW|Self.StepNorthWest', '',
    'Step one sqm to the north west',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdNorthWest);
    end);
  Registry.AddFunc('Self.MoveSE|Self.StepSouthEast', '',
    'Step one sqm to the south east',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdSouthEast);
    end);
  Registry.AddFunc('Self.MoveSW|Self.StepSouthWest', '',
    'Step one sqm to the south west',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Walker.Step(tdSouthWest);
    end);
  Registry.AddFunc('Self.Logout', '',
    'Logout the player as soon as possible (stop cavebot and wait for logout unblock)',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Logout;
    end);
  Registry.AddFunc('Self.TurnN|Self.TurnNorth', '',
    'Turn the player to the north',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Turn(tdNorth);
    end);
  Registry.AddFunc('Self.TurnS|Self.TurnSouth', '',
    'Turn the player to the south',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Turn(tdSouth);
    end);
  Registry.AddFunc('Self.TurnE|Self.TurnEast', '',
    'Turn the player to the east',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Turn(tdEast);
    end);
  Registry.AddFunc('Self.TurnW|Self.TurnWest', '',
    'Turn the player to the west',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.Turn(tdWest);
    end);
  Registry.AddFunc('Self.ReOpenBackpacks', '',
    'Closes and open the player backpacks',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Backpacks.ResetBackpacks;
    end);
  Registry.AddFunc('Self.ToggleMinimizeBackpack', 'Index',
    'Toggle a backpack minimize state',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Backpacks.ToggleMinimize(M.ParamInt(0));
    end);
  Registry.AddFunc('Self.SayInChannel', 'ChannelID, Words',
    'Send a message to a channel ID',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.SayInChannel(M.ParamStr(1), M.ParamInt(0));
    end);
  Registry.AddFunc('Self.ToggleMount', '', 'Toggle the player mount',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.ToggleMount;
    end);
  Registry.AddFunc('Self.Backpacks.UseOn', 'UseID, UseOn',
    'Use a item on a item inside your backpack',
    function(M: BMacro): BInt32
    var
      Item: TTibiaContainer;
    begin
      Result := BMacroFalse;
      Item := ContainerFind(M.ParamInt(1));
      if Item <> nil then
      begin
        Item.UseOn(M.ParamInt(0));
        Exit(BMacroTrue);
      end;
    end);
  Registry.AddFunc('Self.OpenBackpacks', '',
    'Return the number of open backpacks',
    function(M: BMacro): BInt32
    begin
      Result := Tibia.TotalOpenContainers;
    end);
end;
{$ENDREGION}
{$REGION 'Self.Equip, Self.UnEquip, Self.PickUp and Self.Drop'}

procedure MacroRegisterSelfEquipFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Player Inventory Equip');
  Registry.AddFunc('Self.Equip.Helmet', 'ID', 'Equip a item on the Helmet slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotHead);
    end);
  Registry.AddFunc('Self.Equip.Amulet', 'ID', 'Equip a item on the Amulet slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotAmulet);
    end);
  Registry.AddFunc('Self.Equip.Backpack', 'ID',
    'Equip a item on the Backpack slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotBackpack);
    end);
  Registry.AddFunc('Self.Equip.Armor', 'ID', 'Equip a item on the Armor slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotArmor);
    end);
  Registry.AddFunc('Self.Equip.RightHand', 'ID',
    'Equip a item on the Right Hand (->) slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotRight);
    end);
  Registry.AddFunc('Self.Equip.LeftHand', 'ID',
    'Equip a item on the Left Hand (<-) slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotLeft);
    end);
  Registry.AddFunc('Self.Equip.Legs', 'ID', 'Equip a item on the Legs slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotLegs);
    end);
  Registry.AddFunc('Self.Equip.Boots', 'ID', 'Equip a item on the Boots slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotBoots);
    end);
  Registry.AddFunc('Self.Equip.Ring', 'ID', 'Equip a item on the Ring slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotRing);
    end);
  Registry.AddFunc('Self.Equip.Ammo', 'ID',
    'Equip a item on the Ammunition slot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroEquip(M, SlotAmmo);
    end);
  Registry.AddFunc('Self.Equip', 'Slot, ID', 'Equip a item into slot. Slots: ' +
    ValidSlots,
    function(M: BMacro): BInt32
    var
      Slot: TTibiaSlot;
      Item: TTibiaContainer;
    begin
      if TryParseSlot(M.ParamStr(0), Slot) then
      begin
        Item := ContainerFind(M.ParamInt(1));
        if Item <> nil then
          Item.ToBody(Slot);
        Exit(BMacroTrue);
      end
      else
        Exit(BMacroFalse);
    end);
  Registry.AddWikiSection('Player Inventory UnEquip');
  Registry.AddFunc('Self.UnEquip.Helmet', 'ToContainer',
    'Unequip the Helmet slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotHead);
    end);
  Registry.AddFunc('Self.UnEquip.Amulet', 'ToContainer',
    'Unequip the Amulet slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotAmulet);
    end);
  Registry.AddFunc('Self.UnEquip.Backpack', 'ToContainer',
    'Unequip the Backpack and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotBackpack);
    end);
  Registry.AddFunc('Self.UnEquip.Armor', 'ToContainer',
    'Unequip the Armor slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotArmor);
    end);
  Registry.AddFunc('Self.UnEquip.RightHand', 'ToContainer',
    'Unequip the Right Hand (->) slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotRight);
    end);
  Registry.AddFunc('Self.UnEquip.LeftHand', 'ToContainer',
    'Unequip the Left Hand (<-) slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotLeft);
    end);
  Registry.AddFunc('Self.UnEquip.Legs', 'ToContainer',
    'Unequip the Legs slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotLegs);
    end);
  Registry.AddFunc('Self.UnEquip.Boots', 'ToContainer',
    'Unequip the Boots slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotBoots);
    end);
  Registry.AddFunc('Self.UnEquip.Ring', 'ToContainer',
    'Unequip the Ring slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotRing);
    end);
  Registry.AddFunc('Self.UnEquip.Ammo', 'ToContainer',
    'Unequip the Ammunition slot and put the item on the given container index',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroUnEquip(M, SlotAmmo);
    end);
  Registry.AddFunc('Self.UnEquip', 'Slot, ToContainer',
    'Unequip a item a container index. Slots: ' + ValidSlots,
    function(M: BMacro): BInt32
    var
      Slot: TTibiaSlot;
      ToContainer: TTibiaContainer;
    begin
      if TryParseSlot(M.ParamStr(0), Slot) then
      begin
        ToContainer := ContainerAt(M.ParamInt(1));
        if ToContainer.Open then
          ToContainer.PullHere(Me.Inventory.GetSlot(Slot));
        Exit(BMacroTrue);
      end
      else
        Exit(BMacroFalse);
    end);
  Registry.AddWikiSection('Player Drop Equip');
  Registry.AddFunc('Self.Drop.Helmet', 'X, Y, Z',
    'Drop a item on the Helmet to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotHead);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Amulet', 'X, Y, Z',
    'Drop a item on the Amulet to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotAmulet);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Backpack', 'X, Y, Z',
    'Drop a item on the Backpack to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotBackpack);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Armor', 'X, Y, Z',
    'Drop a item on the Armor to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotArmor);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.RightHand', 'X, Y, Z',
    'Drop a item on the RightHand (->) to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotRight);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.LeftHand', 'X, Y, Z',
    'Drop a item on the LeftHand (<-) to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotLeft);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Legs', 'X, Y, Z',
    'Drop a item on the Legs to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotLegs);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Boots', 'X, Y, Z',
    'Drop a item on the Boots to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotBoots);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Ring', 'X, Y, Z',
    'Drop a item on the Ring to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotRing);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.Drop.Ammo', 'X, Y, Z',
    'Drop a item on the Ammo to the ground',
    function(M: BMacro): BInt32
    begin
      MacroDropEquip(M, SlotAmmo);
      Result := BMacroTrue;
    end);
  Registry.AddWikiSection('Player Pickup Equip');
  Registry.AddFunc('Self.PickUp.Helmet', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Helmet slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotHead);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Amulet', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Amulet slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotAmulet);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Backpack', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Backpack slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotBackpack);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Armor', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Armor slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotArmor);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.RightHand', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the RightHand slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotRight);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.LeftHand', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the LeftHand slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotLeft);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Legs', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Legs slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotLegs);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Boots', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Boots slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotBoots);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Ring', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Ring slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotRing);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Self.PickUp.Ammo', 'ID, X, Y, Z, Range',
    'Pickup a item from the ground to the Ammo slot',
    function(M: BMacro): BInt32
    begin
      MacroPickupEquip(M, SlotAmmo);
      Result := BMacroTrue;
    end);
end;
{$ENDREGION}
{$REGION 'Self.Party'}

procedure MacroRegisterSelfPartyFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Party');
  Registry.AddFunc('Party.Status', 'ID',
    'Return the party status for given creature id -> :None | :Invited | :Inviting | :Member | :Leader | :OtherParty',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      C := BBot.Creatures.Find(M.ParamInt(0));
      if C <> nil then
        case C.Party.Player of
          PartyNone:
            Exit(M.Constant('None'));
          PartyInviting:
            Exit(M.Constant('Inviting'));
          PartyInvited:
            Exit(M.Constant('Invited'));
          PartyMember:
            Exit(M.Constant('Member'));
          PartyLeader:
            Exit(M.Constant('Leader'));
          PartyOther:
            Exit(M.Constant('OtherParty'));
        end;
      Result := M.Constant('None');
    end);
  Registry.AddFunc('Party.IsShared', '', 'Return if the party is sharing exp',
    function(M: BMacro): BInt32
    begin
      if BBot.Creatures.Player <> nil then
        if BBot.Creatures.Player.Party.Shared then
          Exit(BMacroTrue);
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.CanShared', '', 'Return if the party can share exp',
    function(M: BMacro): BInt32
    begin
      if BBot.Creatures.Player <> nil then
        if not BBot.Creatures.Player.Party.SharedDisabled then
          Exit(BMacroTrue);
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.Invite', 'ID', 'Invite given ID party',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      C := BBot.Creatures.Find(M.ParamInt(0));
      if C <> nil then
      begin
        Me.InviteToParty(C);
        Exit(BMacroTrue);
      end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.Inviting', 'ID',
    'Return if given creature ID is inviting you to party',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      C := BBot.Creatures.Find(M.ParamInt(0));
      if C <> nil then
        if C.Party.Player = PartyInviting then
        begin
          Exit(BMacroTrue);
        end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.Revoke', 'ID', 'Revoke party invitation for given ID',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      C := BBot.Creatures.Find(M.ParamInt(0));
      if C <> nil then
      begin
        Me.RevokeInviteToParty(C);
        Exit(BMacroTrue);
      end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.Join', 'Leader',
    'Join party of given leader creature id',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      C := BBot.Creatures.Find(M.ParamInt(0));
      if C <> nil then
      begin
        Me.JoinParty(C);
        Exit(BMacroTrue);
      end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.PassLeader', 'Leader',
    'Pass the leadership to a new given leader id',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      C := BBot.Creatures.Find(M.ParamInt(0));
      if C <> nil then
      begin
        Me.PassLeader(C);
        Exit(BMacroTrue);
      end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.Leave', '', 'Leave the current party',
    function(M: BMacro): BInt32
    begin
      if BBot.Creatures.Player <> nil then
        if BBot.Creatures.Player.Party.Player <> PartyNone then
        begin
          Me.LeaveParty;
          Exit(BMacroTrue);
        end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Party.ToggleShared', '',
    'Enable or disable party shared exp',
    function(M: BMacro): BInt32
    begin
      if BBot.Creatures.Player <> nil then
      begin
        Me.SharedPartyExp(not BBot.Creatures.Player.Party.Shared);
        Exit(BMacroTrue);
      end;
      Exit(BMacroFalse);
    end);
end;
{$ENDREGION}
{$REGION 'NPC'}

procedure MacroRegisterNPCFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('NPC Trading');
  Registry.AddFunc('NPC.Buy', 'ID, Count, IgnoreCap',
    'Buy a item on the Trade, requires the Trade open before using the macro (by saying Hi,Trade)',
    function(M: BMacro): BInt32
    var
      ID, BuyCount: BInt32;
    begin
      ID := M.ParamInt(0);
      BuyCount := M.ParamInt(1);
      BBot.TradeWindow.IgnoreCap := M.ParamInt(2) = 1;
      BBot.TradeWindow.BuyInBackpacks := False;
      if BBot.TradeWindow.Buy(ID, BuyCount) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);
    end);
  Registry.AddFunc('NPC.BuyInBP', 'ID, Count, IgnoreCap',
    'Buy a item in a backpack from the Trade, requires the Trade open before using the macro (by saying Hi,Trade)',
    function(M: BMacro): BInt32
    var
      ID, BuyCount: BInt32;
    begin
      ID := M.ParamInt(0);
      BuyCount := M.ParamInt(1);
      BBot.TradeWindow.IgnoreCap := M.ParamInt(2) = 1;
      BBot.TradeWindow.BuyInBackpacks := True;
      if BBot.TradeWindow.Buy(ID, BuyCount) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);
    end);
  Registry.AddFunc('NPC.SellAll', 'ID',
    'Sell item to the Trade, requires the Trade open before using the macro (by saying Hi,Trade)',
    function(M: BMacro): BInt32
    var
      ID: BInt32;
    begin
      ID := M.ParamInt(0);
      if BBot.TradeWindow.SellAll(ID) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);

    end);
  Registry.AddFunc('NPC.Sell', 'ID, Count',
    'Sell item to the Trade, requires the Trade open before using the macro (by saying Hi,Trade)',
    function(M: BMacro): BInt32
    var
      ID, SellCount: BInt32;
    begin
      ID := M.ParamInt(0);
      SellCount := M.ParamInt(1);
      if SellCount = -1 then
      begin
        if BBot.TradeWindow.SellAll(ID) then
          Exit(BMacroTrue)
        else
          Exit(BMacroFalse);
      end
      else
      begin
        if BBot.TradeWindow.Sell(ID, SellCount) then
          Exit(BMacroTrue)
        else
          Exit(BMacroFalse);
      end;
    end);
  Registry.AddFunc('NPC.Say', 'Text', 'Say a text in the special NPC channel',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Me.NPCSay(M.ParamStr(0));
      Sleep(300 + BRandom(300));
    end);
  Registry.AddFunc('NPC.Trade.Money', '',
    'The player current money gathered from NPC Trade window',
    function(M: BMacro): BInt32
    begin
      Result := BBot.TradeWindow.Money;
    end);
end;
{$ENDREGION}
{$REGION 'Map'}

procedure MacroRegisterMapFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Working with Maps');
  Registry.AddFunc('Map.UseOn', 'ID, OnID, X, Y, Z, Range',
    'Use a item on the Map (shovel)' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if TilesSearch(Map, BPosXYZ(M.ParamInt(2), M.ParamInt(3), M.ParamInt(4)),
        M.ParamInt(5), True,
        function: BBool
        begin
          Result := Map.ID = BUInt32(M.ParamInt(1));
        end) then
      begin
        if Me.Position = Map.Position then
          BBot.Walker.RandomStep;
        if (Map.ID <> BUInt32(M.ParamInt(1))) and Map.Cleanup then
          Exit(BMacroTrue);
        Map.UseOn(M.ParamInt(0));
        Result := BMacroTrue;
        Exit;
      end;
    end);
  Registry.AddFunc('Map.Use', 'ID, X, Y, Z, Range',
    'Use a item from the Map (Ports)' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if TilesSearch(Map, BPosXYZ(M.ParamInt(1), M.ParamInt(2), M.ParamInt(3)),
        M.ParamInt(4), True,
        function: BBool
        begin
          Result := Map.ID = BUInt32(M.ParamInt(0));
        end) then
      begin
        if Me.Position = Map.Position then
          BBot.Walker.RandomStep;
        if (Map.ID <> BUInt32(M.ParamInt(0))) and Map.Cleanup then
          Exit(BMacroTrue);
        Map.Use;
        Result := BMacroTrue;
        Exit;
      end;
    end);
  Registry.AddFunc('Map.HasID', 'ID, X, Y, Z',
    'Check if a map position has a item' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
      X, Y: BInt32;
    begin
      Result := BMacroFalse;
      X := M.ParamInt(1);
      Y := M.ParamInt(2);
      if Tiles(Map, X, Y) then
        if Map.Has(M.ParamInt(0)) then
          Exit(BMacroTrue);
    end);
  Registry.AddFunc('Map.Thrown', 'ID, Count, X, Y, Z',
    'Thrown a item on the map from your backpacks' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      Result := BMacroFalse;
      CT := ContainerFind(M.ParamInt(0));
      if CT <> nil then
      begin
        CT.ToGround(BPosXYZ(M.ParamInt(2), M.ParamInt(3), M.ParamInt(4)),
          Min(M.ParamInt(1), CT.Count));
        Result := BMacroTrue;
      end;
    end);
  Registry.AddFunc('Map.PickUp', 'ID, Count, ContainerTo, X, Y, Z',
    'Pick a item from the map' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
      Count: BInt32;
    begin
      Result := BMacroFalse;
      if Tiles(Map, M.ParamInt(3), M.ParamInt(4)) then
        if Map.ID = BUInt32(M.ParamInt(0)) then
        begin
          Count := M.ParamInt(1);
          if Count <> -1 then
            ContainerAt(M.ParamInt(2), 0).PullHere(Map, Count)
          else
            ContainerAt(M.ParamInt(2), 0).PullHere(Map);
          Result := BMacroTrue;
        end;
    end);
  Registry.AddFunc('Map.PickUpEx', 'ID, Count, ContainerTo, X, Y, Z, Range',
    'Pick a item from the map in a range' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
      Count: BInt32;
      ID: BInt32;
    begin
      Result := BMacroFalse;
      ID := M.ParamInt(0);
      if ContainerAt(M.ParamInt(2), 0).Open then
        if TilesSearch(Map, BPosXYZ(M.ParamInt(3), M.ParamInt(4), M.ParamInt(5)
          ), M.ParamInt(6), True,
          function: BBool
          begin
            Result := Map.ID = BUInt32(ID);
          end) then
        begin
          Count := M.ParamInt(1);
          if Count <> -1 then
            ContainerAt(M.ParamInt(2), 0).PullHere(Map, Count)
          else
            ContainerAt(M.ParamInt(2), 0).PullHere(Map);
          Exit(BMacroTrue);
        end;
    end);
  Registry.AddFunc('Map.ItemsOnTile', 'X, Y, Z',
    'Return the number of items on given SQM',
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if Tiles(Map, BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2))) then
        Exit(Map.ItemsOnTile);
    end);
  Registry.AddFunc('Map.Item.ID', 'X, Y, Z, Index',
    'Return item ID on given SQM and Index',
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if Tiles(Map, BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2))) then
      begin
        Map.ItemFromStack(M.ParamInt(3));
        Exit(Map.ID);
      end;
    end);
  Registry.AddFunc('Map.Item.Count', 'X, Y, Z, Index',
    'Return item Count on given SQM and Index',
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if Tiles(Map, BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2))) then
      begin
        Map.ItemFromStack(M.ParamInt(3));
        Exit(Map.Count);
      end;
    end);
  Registry.AddFunc('Map.ItemOnTop.ID', 'X, Y, Z',
    'Return item ID on given SQM top index',
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if Tiles(Map, BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2))) then
      begin
        Map.ItemOnTop;
        Exit(Map.ID);
      end;
    end);
  Registry.AddFunc('Map.ItemOnTop.Count', 'X, Y, Z',
    'Return item Count on given SQM top index',
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if Tiles(Map, BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2))) then
      begin
        Map.ItemOnTop;
        Exit(Map.Count);
      end;
    end);
  Registry.AddFunc('Map.CreatureOnTop.ID', 'X, Y, Z',
    'Return creature ID on given SQM top index',
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
    begin
      Result := BMacroFalse;
      if Tiles(Map, BPosXYZ(M.ParamInt(0), M.ParamInt(1), M.ParamInt(2))) then
      begin
        Map.CreatureOnTop;
        if Map.ID = ItemID_Creature then
          Exit(Map.Count)
        else
          Exit(BMacroFalse);
      end;
    end);
  Registry.AddFunc('Map.Find', 'ID, X, Y, Z, Range, OnlyTopItem?',
    'Find a item by ID in a range, outputs to !Found.X, !Found.Y and !Found.Z, also returns '
    + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
      ID: BInt32;
    begin
      Result := BMacroFalse;
      ID := M.ParamInt(0);
      if TilesSearch(Map, BPosXYZ(M.ParamInt(1), M.ParamInt(2), M.ParamInt(3)),
        M.ParamInt(4), M.ParamInt(5) = 1,
        function: BBool
        begin
          Result := Map.ID = BUInt32(ID);
        end) then
      begin
        M.SetVariable('Found.X', Map.Position.X);
        M.SetVariable('Found.Y', Map.Position.Y);
        M.SetVariable('Found.Z', Map.Position.Z);
        M.SetVariable('Found.Stack', Map.Stack);
        Exit(BMacroTrue);
      end;
    end);
  Registry.AddFunc('Map.UseOn.Equip', 'UseID, X, Y, Z, OnSlot',
    'Use a item from the map on an equipament' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      Map: TTibiaTiles;
      Slot: TTibiaSlot;
    begin
      Result := BMacroFalse;
      if Tiles(Map, M.ParamInt(1), M.ParamInt(2)) then
        if Map.ID = BUInt32(M.ParamInt(0)) then
        begin
          Slot := StrToSlot(M.ParamStr(4));
          Map.UseWithOn(Slot);
          Result := BMacroTrue;
        end;
    end);
end;
{$ENDREGION}
{$REGION 'Creature'}

procedure MacroRegisterCreatueFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Working with Creatures');
  Registry.AddFunc('Creature.ByName', 'Name',
    'Gather a ID from the first creature with the name given found',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(M.ParamStr(0));
      if C <> nil then
        Result := BInt32(C.ID);
    end);
  Registry.AddFunc('Creature.Attacking|Creature.Target', '',
    'Gather the ID from the creature being attacked',
    function(M: BMacro): BInt32
    begin
      Result := BInt32(Me.TargetID);
    end);
  Registry.AddFunc('Creature.Self', '', 'Gather the ID from the player',
    function(M: BMacro): BInt32
    begin
      Result := BInt32(Me.ID);
    end);
  Registry.AddFunc('Creature.Health', 'ID',
    'Returns the health percent of the creature with the given ID',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.Health;
    end);
  Registry.AddFunc('Creature.IsAlive', 'ID', 'Returns creature is alive',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := MacroBool(C.IsAlive);
    end);
  Registry.AddFunc('Creature.Speed', 'ID',
    'Returns the absolute speed value of the creature with the given ID',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.Speed;
    end);
  Registry.AddFunc('Creature.DistanceToSelf', 'ID',
    'Calculate the distance from the creature with the given ID to the player',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := Me.DistanceTo(C);
    end);
  Registry.AddFunc('Creature.NameIn', 'ID, Name,Na..',
    'Verify if the creature from the given ID name is in the list' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
      I: BInt32;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        for I := 1 to M.ParamCount - 1 do
          if BStrEqual(M.ParamStr(I), C.Name) then
            Exit(BMacroTrue);
    end);
  Registry.AddFunc('Creature.NameTo', 'ID, StrVarCreatureName',
    'Set StrVarCreatureName variable to Creature name of given ID',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        M.SetVariable(M.ParamStr(1), C.Name);
    end);
  Registry.AddFunc('Creature.ShootOn', 'ID, Ammo',
    'Shoot a item on the creature (potions, runes and other items)',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
      begin
        C.ShootOn(M.ParamInt(1));
        Result := BMacroTrue;
      end;
    end);
  Registry.AddFunc('Creature.X', 'ID', 'Global position X from the creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.Position.X;
    end);
  Registry.AddFunc('Creature.Y', 'ID', 'Global position Y from the creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.Position.Y;
    end);
  Registry.AddFunc('Creature.Z', 'ID', 'Global position Z from the creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.Position.Z;
    end);
  Registry.AddFunc('Creature.IsPlayer', 'ID', 'Check if a creature is a player'
    + YesNoDesc,
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsPlayer then
          Result := BMacroTrue;
    end);
  Registry.AddFunc('Creature.IsNPC', 'ID',
    'Check if a creature is NPC or a Monster' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsNPC then
          Result := BMacroTrue;
    end);
  Registry.AddFunc('Creature.GroupCount', 'ID',
    'Returns the number of the group that the player is in (guild or party)',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.GroupOnline;
    end);
  Registry.AddFunc('Creature.SquareVisible', 'ID',
    'Check if a creature has a square',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.SquareVisible then
          Result := BMacroTrue;
    end);
  Registry.AddFunc('Creature.SquareRed', 'ID',
    'Return the RED color of the creature square',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.SquareRed;
    end);
  Registry.AddFunc('Creature.SquareGreen', 'ID',
    'Return the GREEN color of the creature square',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.SquareGreen;
    end);
  Registry.AddFunc('Creature.SquareBlue', 'ID',
    'Return the BLUE color of the creature square',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        Result := C.SquareRed;
    end);
  Registry.AddFunc('Creature.Attack', 'ID', 'Attack a creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsAlive then
          if C.IsOnScreen then
            if C.IsReachable then
            begin
              Result := BMacroTrue;
              C.Attack;
            end;
    end);
  Registry.AddFunc('Creature.Follow', 'ID', 'Follow a creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsAlive then
          if C.IsOnScreen then
            if C.IsReachable then
            begin
              Result := BMacroTrue;
              C.Follow;
            end;
    end);
  Registry.AddFunc('Creature.SuperFollow', 'ID',
    'Follow a creature even through other floors',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsAlive then
          if C.IsOnScreen then
            if C.IsReachable then
            begin
              Result := BMacroTrue;
              C.SuperFollow;
            end;
    end);
  Registry.AddFunc('Creature.KeepDistance', 'ID, Distance',
    'Keep a certain distance from a creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsAlive then
          if C.IsOnScreen then
            if C.IsReachable then
            begin
              Result := BMacroTrue;
              C.KeepDistance(M.ParamInt(1));
            end;
    end);
  Registry.AddFunc('Creature.KeepDiagonal', 'ID',
    'Keeps on the diagonal of a creature',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
    begin
      Result := BMacroFalse;
      C := BBot.Creatures.Find(BUInt32(M.ParamInt(0)));
      if C <> nil then
        if C.IsAlive then
          if C.IsOnScreen then
            if C.IsReachable then
            begin
              Result := BMacroTrue;
              C.KeepDiagonal;
            end;
    end);
  Registry.AddFunc('Creature.Iterator', 'VariableName',
    'Initialize a creature iterator variable',
    function(M: BMacro): BInt32
    var
      C: TBBotCreature;
      ID: BInt32;
    begin
      C := BBot.Creatures.Find(
        function(Iter: TBBotCreature): BBool
        begin
          Exit(True);
        end);
      if C <> nil then
        ID := C.ID
      else
        ID := 0;
      M.SetVariable(M.ParamStr(0), ID);
      Exit(MacroBool(ID <> 0));
    end);
  Registry.AddFunc('Creature.Next', 'CreatureIterator, NextLabel',
    'Iterates to NextLabel if CreatureIterator has new valid creature state',
    function(M: BMacro): BInt32
    var
      VarName: BStr;
      C: TBBotCreature;
      CurrentID, NextID: BInt32;
      FoundCurrent: BBool;
    begin
      VarName := M.ParamStr(0);
      CurrentID := M.Variable(VarName);
      C := BBot.Creatures.Find(
        function(Iter: TBBotCreature): BBool
        begin
          if FoundCurrent then
            Exit(True);
          FoundCurrent := Iter.ID = BUInt32(CurrentID);
          Exit(False);
        end);
      if C <> nil then
        NextID := C.ID
      else
        NextID := 0;
      M.SetVariable(VarName, NextID);
      if NextID <> 0 then
        M.GoLabel(M.ParamStr(1));
      Exit(MacroBool(NextID <> 0));
    end);
end;
{$ENDREGION}
{$REGION 'Creatures Statistics'}

procedure MacroRegisterCreatureStatsFunctions(const Registry
  : BMacroRegistryCore);
begin
  Registry.AddWikiSection('Creature Statistics');
  Registry.AddFunc('Creatures.Beside', '',
    'Count the number of creatures in a 1 sqm range',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
    begin
      Count := 0;
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsAlive and (not Creature.IsSelf) and
            (Creature.DistanceTo(Me.Position) <= 1) then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.OnScreen', '',
    'Count the number of creatures in the screen',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
    begin
      Count := 0;
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsAlive and Creature.IsOnScreen then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.OnScreenParty', '',
    'Count the number of creatures in the screen in party',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
    begin
      Count := 0;
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsAlive and Creature.IsOnScreen and
            (Creature.Party.Player <> PartyNone) and
            (Creature.Party.Player <> PartyInvited) then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.ByRange', 'Range',
    'Count the number of creatures in a sqm range',
    function(M: BMacro): BInt32
    var
      Count, Range: BInt32;
    begin
      Count := 0;
      Range := M.ParamInt(0);
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsAlive and (Me.DistanceTo(Creature) <= Range) then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.ByRangeParty', 'Range',
    'Count the number of creatures in a sqm range in party',
    function(M: BMacro): BInt32
    var
      Count, Range: BInt32;
    begin
      Count := 0;
      Range := M.ParamInt(0);
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsAlive and (Me.DistanceTo(Creature) <= Range) and
            (Creature.Party.Player <> PartyNone) and
            (Creature.Party.Player <> PartyInvited) then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.Killed', 'Name',
    'Count the number of creatures killed with a certain name',
    function(M: BMacro): BInt32
    begin
      Result := BBot.KillStats.Kills(M.ParamStr(0));
    end);
  Registry.AddFunc('Creatures.PlayersOnScreen', '',
    'Count the number of players on the screen',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
    begin
      Count := 0;
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsPlayer and Creature.IsAlive and Creature.IsOnScreen then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.TaskKilled', 'Name',
    'Counts the number of task kills from a certain creature (BOT count, not absolute count)',
    function(M: BMacro): BInt32
    begin
      Result := BBot.KillStats.TaskKills(M.ParamStr(0));
    end);
  Registry.AddFunc('Creatures.PlayersOnRange', 'Range',
    'Counts the number of players in a sqm range',
    function(M: BMacro): BInt32
    var
      Count, Range: BInt32;
    begin
      Count := 0;
      Range := M.ParamInt(0);
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsPlayer and Creature.IsAlive and
            (Creature.DistanceTo(Me.Position) <= Range) then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.ByName', 'Name',
    'Counts the number of creatures with a certain name',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Name: BStr;
    begin
      Count := 0;
      Name := M.ParamStr(0);
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if BStrEqual(Name, Creature.Name) and Creature.IsAlive and Creature.IsOnScreen
          then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.NPCOnScreen', '',
    'Counts the number of NPC or Monsters in the screen',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
    begin
      Count := 0;
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsNPC and Creature.IsAlive and Creature.IsOnScreen then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.ByRangeName', 'Range, Name',
    'Counts the number of creatures with a certain name within a range',
    function(M: BMacro): BInt32
    var
      Count, Range: BInt32;
      Name: BStr;
    begin
      Count := 0;
      Range := M.ParamInt(0);
      Name := M.ParamStr(1);
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if BStrEqual(Name, Creature.Name) and Creature.IsAlive and
            (Me.DistanceTo(Creature) <= Range) then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Creatures.ByNameBeside', 'Name',
    'Counts the number of creatures with a certain name with a 1 sqm distance',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Name: BStr;
    begin
      Count := 0;
      Name := M.ParamStr(0);
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if BStrEqual(Name, Creature.Name) and Creature.IsAlive and
            (Me.DistanceTo(Creature) <= 1) then
            Inc(Count);
        end);
      Result := Count;
    end);
end;
{$ENDREGION}
{$REGION 'Misc'}

procedure MacroRegisterMiscFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Misc Functions');
  Registry.AddFunc('Misc.ShootCount', 'InLastSeconds',
    'Return the number of magic shoot effects in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      BBot.Stats.ShootStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.AttackersCount', 'InLastSeconds',
    'Return the number of creatures that attacked the player in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      BBot.Stats.AttackedStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            Inc(Count);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.HPLose', 'InLastSeconds',
    'Return the number of HP loose in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      BBot.Stats.HPStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            if It^.Value < 0 then
              Inc(Count, -It^.Value);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.HPGain', 'InLastSeconds',
    'Return the number of HP gained in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      BBot.Stats.HPStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            if It^.Value > 0 then
              Inc(Count, It^.Value);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.HPDelta', 'InLastSeconds',
    'Return the number of HP delta in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      BBot.Stats.HPStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            Inc(Count, It^.Value);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.ManaDelta', 'InLastSeconds',
    'Return the number of MANA delta in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      BBot.Stats.ManaStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            Inc(Count, It^.Value);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.HPHitsBigger', 'InLastSeconds, BiggerThan',
    'Counts the number of hits that was bigger than a given value in a certain number of seconds',
    function(M: BMacro): BInt32
    var
      Hit: BInt32;
      Count: BInt32;
      Since: BUInt32;
    begin
      Count := 0;
      Since := Tick - (BUInt32(M.ParamInt(0)) * 1000);
      Hit := -M.ParamInt(1);
      BBot.Stats.HPStats.Traverse(
        procedure(It: BVector<TEventCounterData>.It)
        begin
          if It^.Time > Since then
            if It^.Value < Hit then
              Inc(Count, 1);
        end);
      Result := Count;
    end);
  Registry.AddFunc('Misc.StandTime', '',
    'Returns in seconds the time that the player dont walk',
    function(M: BMacro): BInt32
    begin
      Result := BBot.StandTime div 1000;
    end);
  Registry.AddFunc('Misc.ItemCount', 'ItemName',
    'Return the number of items from the hotkey message: You are using the...',
    function(M: BMacro): BInt32
    begin
      Result := BBot.SupliesStats.Suplies(M.ParamStr(0));
    end);
  Registry.AddFunc('Misc.Alert', 'Message',
    'Start a sound alarm with a message',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.SimpleAlarm('[Macro] ' + M.ParamStr(0), True);
    end);
  Registry.AddFunc('Misc.LoadUrl', 'Url', 'Load a URL',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      DownloadURL(M.ParamStr(0), '', nil, nil);
    end);
  Registry.AddFunc('Misc.LogFile', 'File, Text', 'Log a message in a text file',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BFileAppend(M.ParamStr(0), M.ParamStr(1));
    end);
  Registry.AddFunc('Misc.ItemCountEx', 'ItemID',
    'Count the number of items with a ID on the open backpacks',
    function(M: BMacro): BInt32
    begin
      Result := CountItem(M.ParamInt(0));
    end);
  Registry.AddFunc('HUD.Display', 'Text',
    'Displays a HUD message on game screen',
    function(M: BMacro): BInt32
    var
      HUD: TBBotHUD;
    begin
      Result := BMacroTrue;
      HUD := TBBotHUD.Create(bhgAny);
      HUD.AlignTo(MacroHUDHAlign, MacroHUDVAlign);
      HUD.Expire := 4000;
      HUD.Print(M.ParamStr(0), MacroHUDColor);
      HUD.Free;
    end);
  Registry.AddFunc('HUD.Setup', 'HAlign, VAlign, R, B, G',
    'Set how the HUD message from the macro is shown in the game screen. HAligns = :HLeft | :HCenter | :HRight; VAligns = :VTop | :VMiddle | :VBottom',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      MacroHUDHAlign := ParamHUDHorizontalAlign(M, 0);
      MacroHUDVAlign := ParamHUDVerticalAlign(M, 1);
      MacroHUDColor := RGB(EnsureRange(M.ParamInt(2), 0, 255), // r
        EnsureRange(M.ParamInt(3), 0, 255), // g
        EnsureRange(M.ParamInt(4), 0, 255) // b
        );
    end);
  Registry.AddFunc('HUD.Print', 'HAlign, VAlign, R, B, G, Expire, Text',
    'Show a HUD in the game screen with specific settings. HAligns = :HLeft | :HCenter | :HRight; VAligns = :VTop | :VMiddle | :VBottom',
    function(M: BMacro): BInt32
    var
      HUD: TBBotHUD;
      H: TBBotHUDAlign;
      V: TBBotHUDVAlign;
    begin
      Result := BMacroTrue;
      HUD := TBBotHUD.Create(bhgAny);
      H := ParamHUDHorizontalAlign(M, 0);
      V := ParamHUDVerticalAlign(M, 1);
      HUD.AlignTo(H, V);
      HUD.Color := RGB(EnsureRange(M.ParamInt(2), 0, 255), // r
        EnsureRange(M.ParamInt(3), 0, 255), // g
        EnsureRange(M.ParamInt(4), 0, 255) // b
        );
      HUD.Expire := M.ParamInt(5);
      HUD.Print(M.ParamStr(6));
      HUD.Free;
    end);
  Registry.AddFunc('Cavebot.Start', '', 'Starts the Cavebot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Cavebot.Enabled := True;
    end);
  Registry.AddFunc('Cavebot.Stop', '', 'Stops the Cavebot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Cavebot.Enabled := False;
    end);
  Registry.AddFunc('Cavebot.Reset', '', 'Resets the Cavebot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Cavebot.FindNearestPoint;
    end);
  Registry.AddFunc('CaveBot.GoLabel', 'Label',
    'Makes the Cavebot go to a waypoint label',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Cavebot.GoLabel(M.ParamStr(0));
    end);
  Registry.AddFunc('CaveBot.GoStart', '',
    'Makes the Cavebot go to the first waypoint item',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Cavebot.GoStart;
    end);
  Registry.AddFunc('CaveBot.NoKill', 'enabled', 'Start or stop a NoKill state',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Cavebot.NoKill := M.ParamInt(0) = BMacroTrue;
    end);
  Registry.AddFunc('Killer.Start', '', 'Start the Killer',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Attacker.Enabled := True;
    end);
  Registry.AddFunc('Killer.Stop', '', 'Stop the Killer',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Attacker.Enabled := False;
    end);
  Registry.AddFunc('OpenCorpses.Pause', '', 'Pause the Open Corpses feature',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.OpenCorpses.Paused := True;
    end);
  Registry.AddFunc('OpenCorpses.UnPause', '',
    'Unpause the Open Corpses feature',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.OpenCorpses.Paused := False;
    end);
  Registry.AddFunc('Bot.Pause|BBot.TogglePause', '', 'Toggle the BBot pause',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      if BBot.Menu.PauseLevel = bplAll then
        BBot.Menu.PauseLevel := bplNone
      else
        BBot.Menu.PauseLevel := bplAll;
    end);
  Registry.AddFunc('Bot.LoadSettings', 'Name',
    'Load a settings configuration file',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Engine.LoadSettings := M.ParamStr(0);
    end);
  Registry.AddFunc('BBot.ToggleVisible', '',
    'Toggles the BBot main window visible',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Engine.ToggleFMain := True;
    end);
  Registry.AddFunc('BBot.ToggleStats', '',
    'Shows the BBot statistics on the game screen (HUD and Informations)',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Stats.ShowHUD;
    end);
  Registry.AddFunc('BBot.LevelSpyReset', '', 'Reset the Level Spy',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.LevelSpy.Reset;
    end);
  Registry.AddFunc('BBot.LevelSpyUp', '', 'Makes the Level Spy go up one floor',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.LevelSpy.IncFloor;
    end);
  Registry.AddFunc('BBot.LevelSpyDown', '',
    'Makes the Level Spy go down one floor',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.LevelSpy.DecFloor;
    end);
  Registry.AddFunc('Macro.Wait', 'Delay',
    'Pause the macro and the entire bot for a delay in miliseconds',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Sleep(M.ParamInt(0));
    end);
  Registry.AddFunc('Hotkey.Use', 'ID',
    'Use a Tibia item with a hotkey (e.g Gold Coin)',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.PacketSender.UseItem(BPosXYZ($FFFF, 0, 0), M.ParamInt(0), 0, 0);
    end);
  Registry.AddFunc('Misc.SystemTime.Hour', '', 'Returns the system HOUR',
    function(M: BMacro): BInt32
    begin
      Result := StrToIntDef(FormatDateTime('h', Time), 0);
    end);
  Registry.AddFunc('Misc.SystemTime.Minute', '', 'Returns the system MINUTE',
    function(M: BMacro): BInt32
    begin
      Result := StrToIntDef(FormatDateTime('n', Time), 0);
    end);
  Registry.AddFunc('Misc.SystemTime.Second', '', 'Returns the system SECOND',
    function(M: BMacro): BInt32
    begin
      Result := StrToIntDef(FormatDateTime('s', Time), 0);
    end);
  Registry.AddFunc('Misc.SystemTime.Tick', '', 'Returns the system TICK',
    function(M: BMacro): BInt32
    begin
      Result := Tick;
    end);
  Registry.AddFunc('Tibia.KeyDown|Tibia.IsKeyDown', 'VirtualKeyCode',
    'Check if a Key is down in tibia',
    function(M: BMacro): BInt32
    begin
      Result := BIf(Tibia.IsKeyDown(M.ParamInt(0), False), BMacroTrue,
        BMacroFalse);
    end);
  Registry.AddFunc('Trainers.Stop', '', 'Stop the Trainers',
    function(M: BMacro): BInt32
    begin
      BBot.Trainer.Paused := True;
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Trainers.Start', '', 'Start the Trainers',
    function(M: BMacro): BInt32
    begin
      BBot.Trainer.Paused := False;
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Misc.Random', 'Min, Max',
    'Generate a random number in a range',
    function(M: BMacro): BInt32
    begin
      Result := BRandom(M.ParamInt(0), M.ParamInt(1))
    end);
  Registry.AddFunc('Trainers.ClearTrainers', '',
    'Clear the Trainers training creatures',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Trainer.Clear;
    end);
  Registry.AddFunc('Protectors.Disable|Protectors.Pause', 'Name',
    'Disable a protector by its name',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Protectors.EnableProtector(M.ParamStr(0), False);
    end);
  Registry.AddFunc('Protectors.Enable|Protectors.UnPause', 'Name',
    'Enable a protector by its name',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Protectors.EnableProtector(M.ParamStr(0), True);
    end);
  Registry.AddFunc('Protectors.DisableAll|Protectors.PauseAll', '',
    'Disable all the Protectors',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Protectors.EnableAllProtectors(False);
    end);
  Registry.AddFunc('Protectors.EnableAll|Protectors.UnPauseAll', '',
    'Enable all the Protectors',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Protectors.EnableAllProtectors(True);
    end);
  Registry.AddFunc('ReUser.Pause', 'Name',
    'Pause a ReUser by its name. Current ReUser names: ' +
    'Magic Shield, Anti Paralysis, Invisible, Cure Poison, Cure Bleeding, ' +
    'Cure Curse, Cure Eletrification, Cure Burning, Intense Recovery, Recovery, '
    + 'Protector, Strong Haste, Swift Foot, Charge, Haste, Blood Rage, ' +
    'Sharpshooter, Ultimate Light, Great Light, Light, Soft Boots, Ring, ' +
    'Left Hand, Right Hand, Amulet, Ammunition',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.ReUser.Pause(M.ParamStr(0), True);
    end);
  Registry.AddFunc('ReUser.UnPause', 'Name', 'Unpause a ReUser by its name',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.ReUser.Pause(M.ParamStr(0), False);
    end);
  Registry.AddFunc('ReUser.PauseAll', '', 'Pause all the ReUsers',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.ReUser.Pause(True);
    end);
  Registry.AddFunc('ReUser.UnPauseAll', '', 'Unpause all the ReUsers',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.ReUser.Pause(False);
    end);
  Registry.AddFunc('Tibia.SendKey', 'VirtualKeyCode', 'Send a key to the Tibia',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      TibiaProcess.SendKey(M.ParamInt(0));
    end);
  Registry.AddFunc('Tibia.SendText', 'Text', 'Send a text to the Tibia',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      TibiaProcess.SendText(M.ParamStr(0));
    end);
  Registry.AddFunc('Tibia.Screenshot', '', 'Takes a Tibia Screenshot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Tibia.ScreenShot;
    end);
  Registry.AddFunc('Tibia.StealthScreenshot', '',
    'Clean up the HUD and take a Tibia Screenshot',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      Tibia.StealthScreenShot;
    end);
  Registry.AddFunc('Tibia.Close', '', 'Close the Tibia process',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      TibiaProcess.Terminate;
    end);
  Registry.AddFunc('Tibia.Ping', '',
    'Retrieve aproximate Tibia connection ping',
    function(M: BMacro): BInt32
    begin
      Result := TibiaState^.Ping;
    end);
  Registry.AddFunc('Tibia.WindowWidth', '', 'Retrieve the Tibia window width',
    function(M: BMacro): BInt32
    begin
      Result := TibiaProcess.ClientRect.Width;
    end);
  Registry.AddFunc('Tibia.WindowHeight', '', 'Retrieve the Tibia window height',
    function(M: BMacro): BInt32
    begin
      Result := TibiaProcess.ClientRect.Height;
    end);
  Registry.AddFunc('ReconnectManager.LoadProfile', 'ProfileName',
    'Load a Reconnect Manager profile',
    function(M: BMacro): BInt32
    begin
      Engine.LoadReconnectManagerProfile := M.ParamStr(0);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('ReconnectManager.TerminateTask', '',
    'Terminate the current Reconnect Manager task and start the process to go to the next task',
    function(M: BMacro): BInt32
    begin
      BBot.ReconnectManager.TerminateTask;
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Macro.Run', 'MacroName', 'Execute a macro by name',
    function(M: BMacro): BInt32
    var
      MacroName: BStr;
    begin
      MacroName := M.ParamStr(0);
      BBot.Schedule(0,
        procedure()
        begin
          BBot.Macros.Execute(MacroName);
        end);
      Result := BMacroTrue;
    end);
  Registry.AddFunc('Debug.Click', 'X, Y', 'Debug a mouse click',
    function(M: BMacro): BInt32
    var
      P: TPoint;
    begin
      P := TPoint.Create(M.ParamInt(0), M.ParamInt(1));
      TibiaProcess.SendMouseClick(P);
      TibiaProcess.OpenHDC;
      TibiaProcess.PrintPixel(P.X, P.Y, 0, $FFFFFF);
      TibiaProcess.CloseDC;
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Debug.ClickEx', 'X, Y', 'Debug a mouse click',
    function(M: BMacro): BInt32
    var
      P: TPoint;
    begin
      P := TPoint.Create(M.ParamInt(0), M.ParamInt(1));
      TibiaProcess.SendMouseClickEx(P.X, P.Y);
      TibiaProcess.OpenHDC;
      TibiaProcess.PrintPixel(P.X, P.Y, 0, $FFFFFF);
      TibiaProcess.CloseDC;
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Debug.Log', 'Message', 'Log a message to Macro Debugger',
    function(M: BMacro): BInt32
    begin
      if M.Debugging then
        M.AddDebug('[Debug.Log] ' + M.ParamStr(0));
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Misc.Click', 'X, Y', 'Send a mouse click',
    function(M: BMacro): BInt32
    var
      P: TPoint;
    begin
      P := TPoint.Create(M.ParamInt(0), M.ParamInt(1));
      TibiaProcess.SendMouseClick(P);
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Misc.ClickEx', 'X, Y', 'Send a mouse click',
    function(M: BMacro): BInt32
    var
      P: TPoint;
    begin
      P := TPoint.Create(M.ParamInt(0), M.ParamInt(1));
      TibiaProcess.SendMouseClickEx(P.X, P.Y);
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Misc.SendPacket', 'Buffer',
    'Send a packet to the server, make sure you know what the hell youre doing',
    function(M: BMacro): BInt32
    begin
      Exit(MacroBool(BBot.PacketSender.SendHexPacket(M.ParamStr(0))));
    end);
  Registry.AddFunc('Dash.Start', '', 'Starts the Dash',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Warbot.Dash := True;
    end);
  Registry.AddFunc('Dash.Stop', '', 'Stops the Dash',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      BBot.Warbot.Dash := False;
    end);
end;
{$ENDREGION}
{$REGION 'Containers'}

procedure MacroRegisterContainersFunctions(const Registry: BMacroRegistryCore);
begin
  Registry.AddWikiSection('Container Functions');
  Registry.AddFunc('Containers.TotalOpen', '', 'Number of Open Containers',
    function(M: BMacro): BInt32
    begin
      Exit(Tibia.TotalOpenContainers);
    end);
  Registry.AddFunc('Container.Name', 'ContainerIndex, NameVar',
    'Sets NameVar to ContainerIndex container name',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      if CT.Open then
      begin
        M.SetVariable(M.ParamStr(1), CT.ContainerName);
        Exit(BMacroTrue);
      end;
      Exit(BMacroFalse);
    end);
  Registry.AddFunc('Container.IsOpen', 'ContainerIndex',
    'Return if the container is open ' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      Exit(MacroBool(CT.Open));
    end);
  Registry.AddFunc('Container.Capacity', 'ContainerIndex',
    'Return the capacity of a container',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      Exit(CT.Capacity);
    end);
  Registry.AddFunc('Container.Items', 'ContainerIndex',
    'Return the amount of items in a container',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      Exit(CT.Items);
    end);
  Registry.AddFunc('Container.Icon', 'ContainerIndex',
    'Return the IconID of a container',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      Exit(CT.Icon);
    end);
  Registry.AddFunc('Container.IsCorpse', 'ContainerIndex',
    'Return if the container is a corpse ' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      Exit(MacroBool(CT.IsCorpse));
    end);
  Registry.AddFunc('Container.IsDepot', 'ContainerIndex',
    'Return if the container is a depot ' + YesNoDesc,
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0));
      Exit(MacroBool(CT.IsDepotContainer));
    end);
  Registry.AddFunc('Container.Item.ID', 'ContainerIndex, SlotIndex',
    'Return item id at a container/slot',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0), M.ParamInt(1));
      Exit(CT.ID);
    end);
  Registry.AddFunc('Container.Item.Count', 'ContainerIndex, SlotIndex',
    'Return item id at a container/slot',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0), M.ParamInt(1));
      Exit(CT.Count);
    end);
  Registry.AddFunc('Container.Find', 'ItemID',
    'Find a item in the containers, output to !Found.Succeed, !Found.Container and !Found.Slot '
    + YesNoDesc,
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerFind(M.ParamInt(0));
      if CT <> nil then
      begin
        M.SetVariable('Found.Container', CT.Container);
        M.SetVariable('Found.Slot', CT.Slot);
        Exit(BMacroTrue);
      end
      else
      begin
        M.SetVariable('Found.Succeed', BMacroFalse);
        Exit(BMacroFalse);
      end;
    end);
  Registry.AddFunc('Container.Item.Use', 'ContainerIndex, SlotIndex',
    'Use the item at a container/slot',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0), M.ParamInt(1));
      CT.Use;
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Container.Item.UseOn', 'ContainerIndex, SlotIndex, UseOnId',
    'Use an item in this container/slot',
    function(M: BMacro): BInt32
    var
      CT: TTibiaContainer;
    begin
      CT := ContainerAt(M.ParamInt(0), M.ParamInt(1));
      CT.UseOn(M.ParamInt(2));
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Container.Item.Move',
    'FromContainer, FromSlot, ToContainer, Count',
    'Move a item from a container to another',
    function(M: BMacro): BInt32
    var
      Item, Destination: TTibiaContainer;
    begin
      Item := ContainerAt(M.ParamInt(0), M.ParamInt(1));
      Destination := ContainerAt(M.ParamInt(2));
      if Destination.Open then
        Destination.PullHere(Item, M.ParamInt(3));
      Exit(BMacroTrue);
    end);
  Registry.AddFunc('Container.Item.MoveToPos',
    'FromContainer, FromSlot, X, Y, Z, Count',
    'Move a item from a container to a position',
    function(M: BMacro): BInt32
    var
      Item: TTibiaContainer;
    begin
      Item := ContainerAt(M.ParamInt(0), M.ParamInt(1));
      Item.ToGround(BPosXYZ(M.ParamInt(2), M.ParamInt(3), M.ParamInt(4)),
        M.ParamInt(5));
      Exit(BMacroTrue);
    end);
end;
{$ENDREGION}

procedure MacroRegisterFunctions(const Registry: BMacroRegistryCore);
begin
  MacroHUDColor := RGB(150, 150, 150);
  MacroHUDVAlign := bhaTop;
  MacroHUDHAlign := bhaCenter;
  MacroRegisterWhenFunctions(Registry);
  MacroRegisterSelfStateFunctions(Registry);
  MacroRegisterSelfStatusFunctions(Registry);
  MacroRegisterSelfInventoryFunctions(Registry);
  MacroRegisterSelfSkillsFunctions(Registry);
  MacroRegisterSelfActionsFunctions(Registry);
  MacroRegisterSelfEquipFunctions(Registry);
  MacroRegisterSelfPartyFunctions(Registry);
  MacroRegisterNPCFunctions(Registry);
  MacroRegisterMapFunctions(Registry);
  MacroRegisterCreatueFunctions(Registry);
  MacroRegisterCreatureStatsFunctions(Registry);
  MacroRegisterMiscFunctions(Registry);
  MacroRegisterContainersFunctions(Registry);
end;

type
  TVKConst = record
    Name: BStr;
    VK: BInt32;
  end;

const
  VirtualKeyConstants: array [0 .. 171] of TVKConst = ((Name: 'K_LBUTTON';
    VK: VK_LBUTTON), (Name: 'K_RBUTTON'; VK: VK_RBUTTON), (Name: 'K_CANCEL';
    VK: VK_CANCEL), (Name: 'K_MBUTTON'; VK: VK_MBUTTON), (Name: 'K_XBUTTON1';
    VK: VK_XBUTTON1), (Name: 'K_XBUTTON2'; VK: VK_XBUTTON2), (Name: 'K_BACK';
    VK: VK_BACK), (Name: 'K_TAB'; VK: VK_TAB), (Name: 'K_CLEAR'; VK: VK_CLEAR),
    (Name: 'K_RETURN'; VK: VK_RETURN), (Name: 'K_SHIFT'; VK: VK_SHIFT),
    (Name: 'K_CONTROL'; VK: VK_CONTROL), (Name: 'K_MENU'; VK: VK_MENU),
    (Name: 'K_PAUSE'; VK: VK_PAUSE), (Name: 'K_CAPITAL'; VK: VK_CAPITAL),
    (Name: 'K_KANA'; VK: VK_KANA), (Name: 'K_HANGUL'; VK: VK_HANGUL),
    (Name: 'K_JUNJA'; VK: VK_JUNJA), (Name: 'K_FINAL'; VK: VK_FINAL),
    (Name: 'K_HANJA'; VK: VK_HANJA), (Name: 'K_KANJI'; VK: VK_KANJI),
    (Name: 'K_CONVERT'; VK: VK_CONVERT), (Name: 'K_NONCONVERT';
    VK: VK_NONCONVERT), (Name: 'K_ACCEPT'; VK: VK_ACCEPT),
    (Name: 'K_MODECHANGE'; VK: VK_MODECHANGE), (Name: 'K_ESCAPE';
    VK: VK_ESCAPE), (Name: 'K_SPACE'; VK: VK_SPACE), (Name: 'K_PRIOR';
    VK: VK_PRIOR), (Name: 'K_NEXT'; VK: VK_NEXT), (Name: 'K_END'; VK: VK_END),
    (Name: 'K_HOME'; VK: VK_HOME), (Name: 'K_LEFT'; VK: VK_LEFT), (Name: 'K_UP';
    VK: VK_UP), (Name: 'K_RIGHT'; VK: VK_RIGHT), (Name: 'K_DOWN'; VK: VK_DOWN),
    (Name: 'K_SELECT'; VK: VK_SELECT), (Name: 'K_PRINT'; VK: VK_PRINT),
    (Name: 'K_EXECUTE'; VK: VK_EXECUTE), (Name: 'K_SNAPSHOT'; VK: VK_SNAPSHOT),
    (Name: 'K_INSERT'; VK: VK_INSERT), (Name: 'K_DELETE'; VK: VK_DELETE),
    (Name: 'K_HELP'; VK: VK_HELP), (Name: 'K_LWIN'; VK: VK_LWIN),
    (Name: 'K_RWIN'; VK: VK_RWIN), (Name: 'K_APPS'; VK: VK_APPS),
    (Name: 'K_SLEEP'; VK: VK_SLEEP), (Name: 'K_NUMPAD0'; VK: VK_NUMPAD0),
    (Name: 'K_NUMPAD1'; VK: VK_NUMPAD1), (Name: 'K_NUMPAD2'; VK: VK_NUMPAD2),
    (Name: 'K_NUMPAD3'; VK: VK_NUMPAD3), (Name: 'K_NUMPAD4'; VK: VK_NUMPAD4),
    (Name: 'K_NUMPAD5'; VK: VK_NUMPAD5), (Name: 'K_NUMPAD6'; VK: VK_NUMPAD6),
    (Name: 'K_NUMPAD7'; VK: VK_NUMPAD7), (Name: 'K_NUMPAD8'; VK: VK_NUMPAD8),
    (Name: 'K_NUMPAD9'; VK: VK_NUMPAD9), (Name: 'K_MULTIPLY'; VK: VK_MULTIPLY),
    (Name: 'K_ADD'; VK: VK_ADD), (Name: 'K_SEPARATOR'; VK: VK_SEPARATOR),
    (Name: 'K_SUBTRACT'; VK: VK_SUBTRACT), (Name: 'K_DECIMAL'; VK: VK_DECIMAL),
    (Name: 'K_DIVIDE'; VK: VK_DIVIDE), (Name: 'K_F1'; VK: VK_F1), (Name: 'K_F2';
    VK: VK_F2), (Name: 'K_F3'; VK: VK_F3), (Name: 'K_F4'; VK: VK_F4),
    (Name: 'K_F5'; VK: VK_F5), (Name: 'K_F6'; VK: VK_F6), (Name: 'K_F7';
    VK: VK_F7), (Name: 'K_F8'; VK: VK_F8), (Name: 'K_F9'; VK: VK_F9),
    (Name: 'K_F10'; VK: VK_F10), (Name: 'K_F11'; VK: VK_F11), (Name: 'K_F12';
    VK: VK_F12), (Name: 'K_F13'; VK: VK_F13), (Name: 'K_F14'; VK: VK_F14),
    (Name: 'K_F15'; VK: VK_F15), (Name: 'K_F16'; VK: VK_F16), (Name: 'K_F17';
    VK: VK_F17), (Name: 'K_F18'; VK: VK_F18), (Name: 'K_F19'; VK: VK_F19),
    (Name: 'K_F20'; VK: VK_F20), (Name: 'K_F21'; VK: VK_F21), (Name: 'K_F22';
    VK: VK_F22), (Name: 'K_F23'; VK: VK_F23), (Name: 'K_F24'; VK: VK_F24),
    (Name: 'K_NUMLOCK'; VK: VK_NUMLOCK), (Name: 'K_SCROLL'; VK: VK_SCROLL),
    (Name: 'K_LSHIFT'; VK: VK_LSHIFT), (Name: 'K_RSHIFT'; VK: VK_RSHIFT),
    (Name: 'K_LCONTROL'; VK: VK_LCONTROL), (Name: 'K_RCONTROL';
    VK: VK_RCONTROL), (Name: 'K_LMENU'; VK: VK_LMENU), (Name: 'K_RMENU';
    VK: VK_RMENU), (Name: 'K_BROWSER_BACK'; VK: VK_BROWSER_BACK),
    (Name: 'K_BROWSER_FORWARD'; VK: VK_BROWSER_FORWARD),
    (Name: 'K_BROWSER_REFRESH'; VK: VK_BROWSER_REFRESH),
    (Name: 'K_BROWSER_STOP'; VK: VK_BROWSER_STOP), (Name: 'K_BROWSER_SEARCH';
    VK: VK_BROWSER_SEARCH), (Name: 'K_BROWSER_FAVORITES';
    VK: VK_BROWSER_FAVORITES), (Name: 'K_BROWSER_HOME'; VK: VK_BROWSER_HOME),
    (Name: 'K_VOLUME_MUTE'; VK: VK_VOLUME_MUTE), (Name: 'K_VOLUME_DOWN';
    VK: VK_VOLUME_DOWN), (Name: 'K_VOLUME_UP'; VK: VK_VOLUME_UP),
    (Name: 'K_MEDIA_NEXT_TRACK'; VK: VK_MEDIA_NEXT_TRACK),
    (Name: 'K_MEDIA_PREV_TRACK'; VK: VK_MEDIA_PREV_TRACK),
    (Name: 'K_MEDIA_STOP'; VK: VK_MEDIA_STOP), (Name: 'K_MEDIA_PLAY_PAUSE';
    VK: VK_MEDIA_PLAY_PAUSE), (Name: 'K_LAUNCH_MAIL'; VK: VK_LAUNCH_MAIL),
    (Name: 'K_LAUNCH_MEDIA_SELECT'; VK: VK_LAUNCH_MEDIA_SELECT),
    (Name: 'K_LAUNCH_APP1'; VK: VK_LAUNCH_APP1), (Name: 'K_LAUNCH_APP2';
    VK: VK_LAUNCH_APP2), (Name: 'K_OEM_1'; VK: VK_OEM_1), (Name: 'K_OEM_PLUS';
    VK: VK_OEM_PLUS), (Name: 'K_OEM_COMMA'; VK: VK_OEM_COMMA),
    (Name: 'K_OEM_MINUS'; VK: VK_OEM_MINUS), (Name: 'K_OEM_PERIOD';
    VK: VK_OEM_PERIOD), (Name: 'K_OEM_2'; VK: VK_OEM_2), (Name: 'K_OEM_3';
    VK: VK_OEM_3), (Name: 'K_OEM_4'; VK: VK_OEM_4), (Name: 'K_OEM_5';
    VK: VK_OEM_5), (Name: 'K_OEM_6'; VK: VK_OEM_6), (Name: 'K_OEM_7';
    VK: VK_OEM_7), (Name: 'K_OEM_8'; VK: VK_OEM_8), (Name: 'K_OEM_102';
    VK: VK_OEM_102), (Name: 'K_PACKET'; VK: VK_PACKET), (Name: 'K_PROCESSKEY';
    VK: VK_PROCESSKEY), (Name: 'K_ATTN'; VK: VK_ATTN), (Name: 'K_CRSEL';
    VK: VK_CRSEL), (Name: 'K_EXSEL'; VK: VK_EXSEL), (Name: 'K_EREOF';
    VK: VK_EREOF), (Name: 'K_PLAY'; VK: VK_PLAY), (Name: 'K_ZOOM'; VK: VK_ZOOM),
    (Name: 'K_NONAME'; VK: VK_NONAME), (Name: 'K_PA1'; VK: VK_PA1),
    (Name: 'K_OEM_CLEAR'; VK: VK_OEM_CLEAR), (Name: 'K_NUM_0'; VK: $30),
    (Name: 'K_NUM_1'; VK: $31), (Name: 'K_NUM_2'; VK: $32), (Name: 'K_NUM_3';
    VK: $33), (Name: 'K_NUM_4'; VK: $34), (Name: 'K_NUM_5'; VK: $35),
    (Name: 'K_NUM_6'; VK: $36), (Name: 'K_NUM_7'; VK: $37), (Name: 'K_NUM_8';
    VK: $38), (Name: 'K_NUM_9'; VK: $39), (Name: 'K_A'; VK: $41), (Name: 'K_B';
    VK: $42), (Name: 'K_C'; VK: $43), (Name: 'K_D'; VK: $44), (Name: 'K_E';
    VK: $45), (Name: 'K_F'; VK: $46), (Name: 'K_G'; VK: $47), (Name: 'K_H';
    VK: $48), (Name: 'K_I'; VK: $49), (Name: 'K_J'; VK: $4A), (Name: 'K_K';
    VK: $4B), (Name: 'K_L'; VK: $4C), (Name: 'K_M'; VK: $4D), (Name: 'K_N';
    VK: $4E), (Name: 'K_O'; VK: $4F), (Name: 'K_P'; VK: $50), (Name: 'K_Q';
    VK: $51), (Name: 'K_R'; VK: $52), (Name: 'K_S'; VK: $53), (Name: 'K_T';
    VK: $54), (Name: 'K_U'; VK: $55), (Name: 'K_V'; VK: $56), (Name: 'K_W';
    VK: $57), (Name: 'K_X'; VK: $58), (Name: 'K_Y'; VK: $59), (Name: 'K_Z';
    VK: $5A));

procedure MacroRegisterConstantVK(const Registry: BMacroRegistry;
const VK: TVKConst);
begin
  Registry.AddConst(VK.Name, 'Virtual Key code', VK.VK);
end;

procedure MacroRegisterConstantsVKs(const Registry: BMacroRegistry);
var
  I: BInt32;
begin
  for I := 0 to High(VirtualKeyConstants) do
    MacroRegisterConstantVK(Registry, VirtualKeyConstants[I]);
end;

procedure MacroRegisterConstantsHUD(const Registry: BMacroRegistry);
begin
  // Horizontal
  Registry.AddConst('HLeft', 'Horizontal Left alignment', 1);
  Registry.AddConst('HCenter', 'Horizontal Center alignment', 2);
  Registry.AddConst('HRight', 'Horizontal Right alignment', 3);

  // Vertical
  Registry.AddConst('VTop', 'Vertical Top alignment', 1);
  Registry.AddConst('VMiddle', 'Vertical Top alignment', 2);
  Registry.AddConst('VBottom', 'Vertical Top alignment', 3);
end;

procedure MacroRegisterConstantsDirections(const Registry: BMacroRegistry);
var
  Dir: TTibiaDirection;
begin
  for Dir := tdNorth to tdNorthWest do
    Registry.AddConst(DirectionToConstName(Dir),
      'Direction ' + DirectionToConstName(Dir), Ord(Dir));
end;

procedure MacroRegisterConstantsSelf(const Registry: BMacroRegistry);
begin
  Registry.AddConst('SelfID', 'Dynamic Self.ID',
    function: BInt32
    begin
      Exit(Me.ID);
    end);
  Registry.AddConst('TargetID', 'Dynamic Creatures.AttackingID',
    function: BInt32
    begin
      Exit(Me.TargetID);
    end);
  Registry.AddConst('X', 'Dynamic Self.X',
    function: BInt32
    begin
      Exit(Me.Position.X);
    end);
  Registry.AddConst('Y', 'Dynamic Self.Y',
    function: BInt32
    begin
      Exit(Me.Position.Y);
    end);
  Registry.AddConst('Z', 'Dynamic Self.Z',
    function: BInt32
    begin
      Exit(Me.Position.Z);
    end);
end;

procedure MacroRegisterConstantsParty(const Registry: BMacroRegistry);
begin
  Registry.AddConst('None', 'Party None', 1000);
  Registry.AddConst('Invited', 'Party Invited', 1001);
  Registry.AddConst('Inviting', 'Party Inviting', 1002);
  Registry.AddConst('Member', 'Party Member', 1003);
  Registry.AddConst('Leader', 'Party Leader', 1004);
  Registry.AddConst('OtherParty', 'Party Other?', 1005);
end;

procedure MacroRegisterConstants(const Registry: BMacroRegistryCore);
begin
  MacroRegisterConstantsSelf(Registry);
  MacroRegisterConstantsHUD(Registry);
  MacroRegisterConstantsDirections(Registry);
  MacroRegisterConstantsVKs(Registry);
  MacroRegisterConstantsParty(Registry);
end;

end.
