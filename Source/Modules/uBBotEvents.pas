unit uBBotEvents;

interface

uses
  uBTypes,
  uBBotAction,
  uBVector,
  uTibiaDeclarations,
  uBattlelist,
  uContainer,
  SysUtils,
  uBBotSpells;

const
  BBotEventCreatureTick = 700;
  BBotEventCreatureAttack = 700;

type
  TBBotEvent_Notify = BVector<BProc>;
  TBBotEvent_BInt32 = BVector<BUnaryProc<BInt32>>;
  TBBotEvent_BInt64 = BVector<BUnaryProc<BInt64>>;
  TBBotEvent_BBool = BVector<BUnaryProc<BBool>>;
  TBBotEvent_BPos = BVector<BUnaryProc<BPos>>;
  TBBotEvent_Inventory = BVector<BBinaryProc<TTibiaSlot, TBufferItem>>;
  TBBotEvent_Skill = BVector<BBinaryProc<TTibiaSkill, BInt32>>;
  TBBotEvent_Creature = BVector<BUnaryProc<TBBotCreature>>;
  TBBotEvent_CreatureWalk = BVector<BBinaryProc<TBBotCreature, BPos>>;
  TBBotEvent_CreatureBInt32 = BVector<BBinaryProc<TBBotCreature, BInt32>>;
  TBBotEvent_Message = BVector<BUnaryProc<TTibiaMessage>>;
  TBBotEvent_Spell = BVector<BUnaryProc<TTibiaSpell>>;
  TBBotEvent_Container = BVector<BUnaryProc<TTibiaContainer>>;
  TBBotEvent_Menu = BVector<BBinaryProc<BUInt32, BUInt32>>;
  TBBotEvent_UseOnCreature = BVector<BUnaryProc<TTibiaUseOnCreature>>;
  TBBotEvent_UseOnItem = BVector<BUnaryProc<TTibiaUseOnItem>>;
  TBBotEvent_MissileEffect = BVector<BUnaryProc<TTibiaMissileEffect>>;
  TBBotEvent_Packet = BVector<BBinaryProc<BPtr, BInt32>>;

  EBBotEvent = class(BException)
  public
    constructor Create(AName: BStr; E: Exception);
  end;

  TBBotEvents = class(TBBotAction)
  private type
    PCreatureInfo = ^TCreatureInfo;

    TCreatureInfo = record
      ID: BUInt32;
      Attack: BUInt32;
      BlackSquare: BUInt32;
      HP: BInt32;
      Pos: BPos;
      LightIntensity: BInt32;
      Speed: BInt32;
      Tick: BUInt32;
      OnScreen: BBool;
    end;

    TContainerInfo = record
      Open: BBool;
      CRC: BInt32;
    end;

    TSelfInfo = record
      ID: BUInt32;
      Status: TTibiaSelfStatus;
      Level, Mana, HP, Target: BInt32;
      Position: BPos;
      Experience: BInt64;
      Invisible, Connected: BBool;
      Inventory: array [SlotFirst .. SlotLast] of TBufferItem;
      Skill: TTibiaSelfSkill;
    end;
  private
    FOnCreature: TBBotEvent_Creature;
    FOnCreatureHP: TBBotEvent_CreatureBInt32;
    FOnCreatureDie: TBBotEvent_Creature;
    FOnCreatureTick: TBBotEvent_Creature;
    FOnCreatureLight: TBBotEvent_Creature;
    FOnCreatureSpeed: TBBotEvent_CreatureBInt32;
    FOnCreatureWalk: TBBotEvent_CreatureWalk;
    FOnCreatureAttack: TBBotEvent_Creature;
    FOnContainerOpen: TBBotEvent_Container;
    FOnContainerChange: TBBotEvent_Container;
    FDebugNormal: BBool;
    FOnHP: TBBotEvent_BInt32;
    FOnInventory: TBBotEvent_Inventory;
    FOnMana: TBBotEvent_BInt32;
    FOnCharacter: TBBotEvent_Notify;
    FOnConnected: TBBotEvent_Notify;
    FOnLevel: TBBotEvent_BInt32;
    FOnSkill: TBBotEvent_Skill;
    FOnWalk: TBBotEvent_BPos;
    FOnStatus: TBBotEvent_Notify;
    FOnTarget: TBBotEvent_Creature;
    FOnExp: TBBotEvent_BInt64;
    FOnTibiaFocus: TBBotEvent_BBool;
    FOnHotkey: TBBotEvent_Notify;
    FOnMenu: TBBotEvent_Menu;
    FDebugAll: BBool;
    FOnStop: TBBotEvent_Notify;
    FOnMessage: TBBotEvent_Message;
    FOnSay: TBBotEvent_Message;
    FOnSystemMessage: TBBotEvent_Message;
    FOnUseOnCreature: TBBotEvent_UseOnCreature;
    FOnUseOnItem: TBBotEvent_UseOnItem;
    FOnMissileEffect: TBBotEvent_MissileEffect;
    FOnBotPacket: TBBotEvent_Packet;
    FOnClientPacket: TBBotEvent_Packet;
    FOnServerPacket: TBBotEvent_Packet;
    FOnSpell: TBBotEvent_Spell;
    FOnCreatureFollow: TBBotEvent_Creature;
  protected
    CreatureInfo: array [0 .. 1300] of TCreatureInfo;
    ContainerInfo: array [0 .. 15] of TContainerInfo;
    SelfInfo: TSelfInfo;
    TargetInfo: BUInt32;
    FocusInfo: BBool;
    CharacterChangeEvent: BBool;
    function Enabled: BBool;
    procedure ReloadBuffers;
    procedure ReloadCreatures;
    procedure ReloadContainers;
    procedure ReloadSelf;
    procedure ReloadSelfID;
    procedure ReloadSelfConnected;
    procedure ReloadSelfStatus;
    procedure ReloadSelfHP;
    procedure ReloadSelfMana;
    procedure ReloadSelfLevel;
    procedure ReloadSelfExp;
    procedure ReloadSelfPostion;
    procedure ReloadSelfInventory;
    procedure ReloadSelfSkill;
    procedure ReloadSelfTarget;
    procedure ReloadSelfTibiaFocus;
    procedure ResetCreatureState(Creature: TBBotCreature);
    procedure ReloadCreatureHP(Creature: TBBotCreature);
    procedure ReloadCreatureTick(Creature: TBBotCreature);
    procedure ReloadCreatureLight(Creature: TBBotCreature);
    procedure ReloadCreatureSpeed(Creature: TBBotCreature);
    procedure ReloadCreatureWalk(Creature: TBBotCreature);
    procedure ReloadCreatureAttack(Creature: TBBotCreature);
    procedure RunCreatureAttack(Creature: TBBotCreature);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run; override;
    procedure RunHotkeys;
    procedure RunMenu;
    procedure RunStop;
    procedure RunSay(ASayData: TTibiaMessage);
    procedure RunMessage(AMessageData: TTibiaMessage);
    procedure RunSystemMessage(AMessageData: TTibiaMessage);
    procedure RunUseOnCreature(AUseOnCreatureData: TTibiaUseOnCreature);
    procedure RunUseOnItem(AUseOnItemData: TTibiaUseOnItem);
    procedure RunMissileEffect(AMissileEffectData: TTibiaMissileEffect);
    procedure RunClientPacket(ABuffer: BPtr; ASize: BInt32);
    procedure RunServerPacket(ABuffer: BPtr; ASize: BInt32);
    procedure RunBotPacket(ABuffer: BPtr; ASize: BInt32);
    procedure RunCreatureFollow(ACreatureID: BInt32);

    property DebugNormal: BBool read FDebugNormal write FDebugNormal;
    property DebugAll: BBool read FDebugAll write FDebugAll;

    property OnCreature: TBBotEvent_Creature read FOnCreature;
    property OnCreatureHP: TBBotEvent_CreatureBInt32 read FOnCreatureHP;
    property OnCreatureDie: TBBotEvent_Creature read FOnCreatureDie;
    property OnCreatureTick: TBBotEvent_Creature read FOnCreatureTick;
    property OnCreatureLight: TBBotEvent_Creature read FOnCreatureLight;
    property OnCreatureSpeed: TBBotEvent_CreatureBInt32 read FOnCreatureSpeed;
    property OnCreatureAttack: TBBotEvent_Creature read FOnCreatureAttack;
    property OnCreatureFollow: TBBotEvent_Creature read FOnCreatureFollow;
    property OnCreatureWalk: TBBotEvent_CreatureWalk read FOnCreatureWalk;

    property OnContainerOpen: TBBotEvent_Container read FOnContainerOpen;
    property OnContainerChange: TBBotEvent_Container read FOnContainerChange;

    property OnConnected: TBBotEvent_Notify read FOnConnected;
    property OnCharacter: TBBotEvent_Notify read FOnCharacter;
    property OnStatus: TBBotEvent_Notify read FOnStatus;
    property OnLevel: TBBotEvent_BInt32 read FOnLevel;
    property OnMana: TBBotEvent_BInt32 read FOnMana;
    property OnExp: TBBotEvent_BInt64 read FOnExp;
    property OnHP: TBBotEvent_BInt32 read FOnHP;
    property OnWalk: TBBotEvent_BPos read FOnWalk;
    property OnTarget: TBBotEvent_Creature read FOnTarget;
    property OnInventory: TBBotEvent_Inventory read FOnInventory;
    property OnSkill: TBBotEvent_Skill read FOnSkill;
    property OnTibiaFocus: TBBotEvent_BBool read FOnTibiaFocus;
    property OnSay: TBBotEvent_Message read FOnSay;
    property OnSpell: TBBotEvent_Spell read FOnSpell;
    property OnMessage: TBBotEvent_Message read FOnMessage;
    property OnSystemMessage: TBBotEvent_Message read FOnSystemMessage;
    property OnUseOnCreature: TBBotEvent_UseOnCreature read FOnUseOnCreature;
    property OnUseOnItem: TBBotEvent_UseOnItem read FOnUseOnItem;
    property OnMissileEffect: TBBotEvent_MissileEffect read FOnMissileEffect;
    property OnHotkey: TBBotEvent_Notify read FOnHotkey;
    property OnStop: TBBotEvent_Notify read FOnStop;
    property OnMenu: TBBotEvent_Menu read FOnMenu;

    property OnServerPacket: TBBotEvent_Packet read FOnServerPacket;
    property OnClientPacket: TBBotEvent_Packet read FOnClientPacket;
    property OnBotPacket: TBBotEvent_Packet read FOnBotPacket;
  end;

implementation

{ TBBotEvents }

uses
  BBotEngine,
  Windows,
  uTibiaProcess,
  uHUD,
  uTiles,
  uTibiaState,
  uRegex;

constructor TBBotEvents.Create;
begin
  inherited Create('Events', 0);
  CharacterChangeEvent := True;
  FDebugNormal := False;
  FDebugAll := False;
  FOnCreature := TBBotEvent_Creature.Create;
  FOnCreatureHP := TBBotEvent_CreatureBInt32.Create;
  FOnCreatureDie := TBBotEvent_Creature.Create;
  FOnCreatureTick := TBBotEvent_Creature.Create;
  FOnCreatureLight := TBBotEvent_Creature.Create;
  FOnCreatureSpeed := TBBotEvent_CreatureBInt32.Create;
  FOnCreatureWalk := TBBotEvent_CreatureWalk.Create;
  FOnCreatureAttack := TBBotEvent_Creature.Create;
  FOnCreatureFollow := TBBotEvent_Creature.Create;
  FOnContainerOpen := TBBotEvent_Container.Create;
  FOnContainerChange := TBBotEvent_Container.Create;
  FOnHP := TBBotEvent_BInt32.Create;
  FOnInventory := TBBotEvent_Inventory.Create;
  FOnMana := TBBotEvent_BInt32.Create;
  FOnCharacter := TBBotEvent_Notify.Create;
  FOnConnected := TBBotEvent_Notify.Create;
  FOnLevel := TBBotEvent_BInt32.Create;
  FOnSkill := TBBotEvent_Skill.Create;
  FOnWalk := TBBotEvent_BPos.Create;
  FOnStatus := TBBotEvent_Notify.Create;
  FOnTarget := TBBotEvent_Creature.Create;
  FOnExp := TBBotEvent_BInt64.Create;
  FOnTibiaFocus := TBBotEvent_BBool.Create;
  FOnStop := TBBotEvent_Notify.Create;
  FOnHotkey := TBBotEvent_Notify.Create;
  FOnMenu := TBBotEvent_Menu.Create;
  FOnSay := TBBotEvent_Message.Create;
  FOnSpell := TBBotEvent_Spell.Create;
  FOnMessage := TBBotEvent_Message.Create;
  FOnSystemMessage := TBBotEvent_Message.Create;
  FOnUseOnCreature := TBBotEvent_UseOnCreature.Create;
  FOnUseOnItem := TBBotEvent_UseOnItem.Create;
  FOnMissileEffect := TBBotEvent_MissileEffect.Create;
  FOnBotPacket := TBBotEvent_Packet.Create;
  FOnClientPacket := TBBotEvent_Packet.Create;
  FOnServerPacket := TBBotEvent_Packet.Create;
end;

destructor TBBotEvents.Destroy;
begin
  FOnCreature.Free;
  FOnCreatureHP.Free;
  FOnCreatureDie.Free;
  FOnCreatureTick.Free;
  FOnCreatureLight.Free;
  FOnCreatureSpeed.Free;
  FOnCreatureWalk.Free;
  FOnCreatureAttack.Free;
  FOnCreatureFollow.Free;
  FOnContainerOpen.Free;
  FOnContainerChange.Free;
  FOnHP.Free;
  FOnInventory.Free;
  FOnMana.Free;
  FOnCharacter.Free;
  FOnConnected.Free;
  FOnLevel.Free;
  FOnSkill.Free;
  FOnWalk.Free;
  FOnStatus.Free;
  FOnTarget.Free;
  FOnExp.Free;
  FOnTibiaFocus.Free;
  FOnStop.Free;
  FOnHotkey.Free;
  FOnMenu.Free;
  FOnSay.Free;
  FOnSpell.Free;
  FOnMessage.Free;
  FOnSystemMessage.Free;
  FOnUseOnCreature.Free;
  FOnUseOnItem.Free;
  FOnMissileEffect.Free;
  FOnBotPacket.Free;
  FOnClientPacket.Free;
  FOnServerPacket.Free;
  inherited;
end;

function TBBotEvents.Enabled: BBool;
begin
  Result := (not CharacterChangeEvent) and (BBot.Menu.PauseLevel > bplAll);
end;

procedure TBBotEvents.ReloadBuffers;
begin
  UpdateMap;
  HUDUpdateRect;
  Me.Reload;
  BBot.Creatures.Reload;
end;

procedure TBBotEvents.ReloadContainers;
var
  I: BInt32;
  CRC: BInt32;
  CT: TTibiaContainer;
begin
  for I := 0 to 15 do begin
    CT := ContainerAt(I, 0);
    CRC := CT.Checksum;
    if Enabled then begin
      if (CT.Open <> ContainerInfo[CT.Container].Open) then begin
        if DebugNormal then
          AddDebug(BFormat('OnContainerOpen(%d)', [CT.Container]));
        try FOnContainerOpen.ForEach(
            procedure(It: TBBotEvent_Container.It)
            begin
              It^(CT);
            end);
        except
          on E: Exception do
            raise EBBotEvent.Create('OnContainerOpen', E)
          else
            raise;
        end;
      end;
      if (CRC <> ContainerInfo[CT.Container].CRC) then begin
        if DebugNormal then
          AddDebug(BFormat('OnContainerChange(%d)', [CT.Container]));
        try FOnContainerChange.ForEach(
            procedure(It: TBBotEvent_Container.It)
            begin
              It^(CT);
            end);
        except
          on E: Exception do
            raise EBBotEvent.Create('OnContainerChange', E)
          else
            raise;
        end;
      end;
    end;
    ContainerInfo[CT.Container].Open := CT.Open;
    ContainerInfo[CT.Container].CRC := CRC;
  end;
end;

procedure TBBotEvents.ReloadCreatureAttack(Creature: TBBotCreature);
begin
  if (Creature.BlackSquareTime <> 0) and (CreatureInfo[Creature.Index].BlackSquare <> Creature.BlackSquareTime) then
  begin
    CreatureInfo[Creature.Index].BlackSquare := Creature.BlackSquareTime;
    RunCreatureAttack(Creature);
  end;
end;

procedure TBBotEvents.ReloadCreatureHP(Creature: TBBotCreature);
begin
  if CreatureInfo[Creature.Index].HP <> Creature.Health then begin
    if Enabled then begin
      if Creature.Health = 0 then begin
        if DebugNormal then
          AddDebug(BFormat('OnCreatureDie(%s %d)', [Creature.Name, Creature.ID]));
        try FOnCreatureDie.ForEach(
            procedure(It: TBBotEvent_Creature.It)
            begin
              It^(Creature);
            end);
        except
          on E: Exception do
            raise EBBotEvent.Create('OnCreatureDie', E)
          else
            raise;
        end;
      end else begin
        if DebugNormal then
          AddDebug(BFormat('OnCreatureHP(%s %d, %d -> %d)', [Creature.Name, Creature.ID,
            CreatureInfo[Creature.Index].HP, Creature.Health]));
        try FOnCreatureHP.ForEach(
            procedure(It: TBBotEvent_CreatureBInt32.It)
            begin
              It^(Creature, CreatureInfo[Creature.Index].HP);
            end);
        except
          on E: Exception do
            raise EBBotEvent.Create('OnCreatureHP', E)
          else
            raise;
        end;
      end;
    end;
    CreatureInfo[Creature.Index].HP := Creature.Health;
  end;
end;

procedure TBBotEvents.ReloadCreatureLight(Creature: TBBotCreature);
begin
  if CreatureInfo[Creature.Index].LightIntensity <> Creature.LightIntensity then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnCreatureLight(%s %d)', [Creature.Name, Creature.ID]));
      try FOnCreatureLight.ForEach(
          procedure(It: TBBotEvent_Creature.It)
          begin
            It^(Creature);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnCreatureLight', E)
        else
          raise;
      end;
    end;
    CreatureInfo[Creature.Index].LightIntensity := Creature.LightIntensity;
  end;
end;

procedure TBBotEvents.ReloadCreatureTick(Creature: TBBotCreature);
begin
  if (Tick - CreatureInfo[Creature.Index].Tick) > BBotEventCreatureTick then begin
    if Enabled then begin
      if DebugNormal and DebugAll then
        AddDebug(BFormat('OnCreatureTick(%s %d)', [Creature.Name, Creature.ID]));
      try FOnCreatureTick.ForEach(
          procedure(It: TBBotEvent_Creature.It)
          begin
            It^(Creature);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnCreatureTick', E)
        else
          raise;
      end;
    end;
    CreatureInfo[Creature.Index].Tick := Tick;
  end;
end;

procedure TBBotEvents.ReloadCreatureWalk(Creature: TBBotCreature);
begin
  if CreatureInfo[Creature.Index].Pos <> Creature.Position then begin
    if Enabled then begin
      if DebugNormal and DebugAll then
        AddDebug(BFormat('OnCreatureWalk(%s %d, %s -> %s)', [Creature.Name, Creature.ID,
          BStr(CreatureInfo[Creature.Index].Pos), BStr(Creature.Position)]));
      try FOnCreatureWalk.ForEach(
          procedure(It: TBBotEvent_CreatureWalk.It)
          begin
            It^(Creature, CreatureInfo[Creature.Index].Pos);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnCreatureWalk', E)
        else
          raise;
      end;
    end;
    CreatureInfo[Creature.Index].Pos := Creature.Position;
  end;
end;

procedure TBBotEvents.RunHotkeys;
begin
  try FOnHotkey.ForEach(
      procedure(It: TBBotEvent_Notify.It)
      begin
        It^();
      end);
  except
    on E: Exception do
      raise EBBotEvent.Create('OnHotkey', E)
    else
      raise;
  end;
  if Tibia.IsKeyDown(VK_ESCAPE, True) then
    RunStop;
end;

procedure TBBotEvents.RunMenu;
begin
  if TibiaState^.HUDClick.ID <> 0 then begin
    if DebugNormal then
      AddDebug(BFormat('OnMenuClick(%d %d)', [TibiaState^.HUDClick.ID, TibiaState^.HUDClick.Data]));
    try FOnMenu.ForEach(
        procedure(It: TBBotEvent_Menu.It)
        begin
          It^(TibiaState^.HUDClick.ID, TibiaState^.HUDClick.Data);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnMenu', E)
      else
        raise;
    end;
    TibiaState^.HUDClick.ID := 0;
  end;
end;

procedure TBBotEvents.RunMessage(AMessageData: TTibiaMessage);
begin
  if Enabled then
    try FOnMessage.ForEach(
        procedure(It: TBBotEvent_Message.It)
        begin
          It^(AMessageData);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnMessage', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.RunMissileEffect(AMissileEffectData: TTibiaMissileEffect);
begin
  if Enabled then
    try FOnMissileEffect.ForEach(
        procedure(It: TBBotEvent_MissileEffect.It)
        begin
          It^(AMissileEffectData);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnMissileEffect', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.RunSay(ASayData: TTibiaMessage);
var
  Spell: TTibiaSpell;
begin
  if Enabled then begin
    try FOnSay.ForEach(
        procedure(It: TBBotEvent_Message.It)
        begin
          It^(ASayData);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnSay', E)
      else
        raise;
    end;
    Spell := BBot.Spells.Spell(ASayData.Text);
    if Spell <> nil then
      try FOnSpell.ForEach(
          procedure(It: TBBotEvent_Spell.It)
          begin
            It^(Spell);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnSpell', E)
        else
          raise;
      end;
  end;
end;

procedure TBBotEvents.RunServerPacket(ABuffer: BPtr; ASize: BInt32);
begin
  if Enabled then
    try FOnServerPacket.ForEach(
        procedure(It: TBBotEvent_Packet.It)
        begin
          It^(ABuffer, ASize);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnSPack', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.RunStop;
begin
  if Enabled then
    try FOnStop.ForEach(
        procedure(It: TBBotEvent_Notify.It)
        begin
          It^();
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnStop', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.RunSystemMessage(AMessageData: TTibiaMessage);
var
  R: BStrArray;
begin
  if Enabled then
    try FOnSystemMessage.ForEach(
        procedure(It: TBBotEvent_Message.It)
        begin
          It^(AMessageData);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnSystemMessage', E)
      else
        raise;
    end;
  try
    {
      You lose HP (hitpoints|hitpoint) due to an attack (by|by an|by a) NAME.
      NAME (loses|lose) HP (hitpoints|hitpoint) due to your attack.
    }
    if BSimpleRegex('You lose \d+ hitpoint(?:s)? due to an attack (?:by an|by a|by) ([\w\s]+)\.', AMessageData.Text, R)
      and (Length(R) = 2) then begin
      BBot.Creatures.Traverse(
        procedure(Creature: TBBotCreature)
        begin
          if Creature.IsAlive and BStrEqual(Creature.Name, R[1]) then
            RunCreatureAttack(Creature);
        end);
    end;
  except
    on E: Exception do
      raise EBBotEvent.Create('OnCreatureAttackMessage', E)
    else
      raise;
  end;
end;

procedure TBBotEvents.RunUseOnCreature(AUseOnCreatureData: TTibiaUseOnCreature);
begin
  if Enabled then
    try FOnUseOnCreature.ForEach(
        procedure(It: TBBotEvent_UseOnCreature.It)
        begin
          It^(AUseOnCreatureData);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnUseOnCreature', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.RunUseOnItem(AUseOnItemData: TTibiaUseOnItem);
begin
  if Enabled then
    try FOnUseOnItem.ForEach(
        procedure(It: TBBotEvent_UseOnItem.It)
        begin
          It^(AUseOnItemData);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnUseOnItem', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.ReloadSelf;
begin
  ReloadSelfID;
  ReloadSelfConnected;
  ReloadSelfStatus;
  ReloadSelfHP;
  ReloadSelfMana;
  ReloadSelfLevel;
  ReloadSelfExp;
  ReloadSelfPostion;
  ReloadSelfInventory;
  ReloadSelfSkill;
  ReloadSelfTarget;
  ReloadSelfTibiaFocus;
end;

procedure TBBotEvents.ReloadSelfConnected;
begin
  if Me.Connected <> SelfInfo.Connected then begin
    if DebugNormal then
      AddDebug(BFormat('OnConnected(%d)', [BInt32(Me.Connected)]));
    try FOnConnected.ForEach(
        procedure(It: TBBotEvent_Notify.It)
        begin
          It^();
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnConnected', E)
      else
        raise;
    end;
    SelfInfo.Connected := Me.Connected;
  end;
end;

procedure TBBotEvents.ReloadSelfExp;
begin
  if Me.Experience <> SelfInfo.Experience then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnExp(%d -> %d)', [SelfInfo.Experience, Me.Experience]));
      try FOnExp.ForEach(
          procedure(It: TBBotEvent_BInt64.It)
          begin
            It^(SelfInfo.Experience);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnExp', E)
        else
          raise;
      end;
    end;
    SelfInfo.Experience := Me.Experience;
  end;
end;

procedure TBBotEvents.ReloadSelfHP;
begin
  if Me.HP <> SelfInfo.HP then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnHP(%d -> %d)', [SelfInfo.HP, Me.HP]));
      try FOnHP.ForEach(
          procedure(It: TBBotEvent_BInt32.It)
          begin
            It^(SelfInfo.HP);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnHP', E)
        else
          raise;
      end;
    end;
    SelfInfo.HP := Me.HP;
  end;
end;

procedure TBBotEvents.ReloadSelfID;
begin
  CharacterChangeEvent := False;
  if Me.ID <> SelfInfo.ID then begin
    if DebugNormal then
      AddDebug(BFormat('OnCharacter(%s)', [Me.Name]));
    CharacterChangeEvent := True;
    SelfInfo.ID := Me.ID;
    try FOnCharacter.ForEach(
        procedure(It: TBBotEvent_Notify.It)
        begin
          It^();
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnCharacter', E)
      else
        raise;
    end;
  end;
end;

procedure TBBotEvents.ReloadSelfInventory;
var
  I: TTibiaSlot;
begin
  for I := SlotFirst to SlotLast do begin
    if (Me.Inventory.GetSlot(I).ID <> SelfInfo.Inventory[I].ID) or
      (Me.Inventory.GetSlot(I).Count <> SelfInfo.Inventory[I].Count) then begin
      if Enabled then begin
        if DebugNormal then
          AddDebug(BFormat('OnInventory(%s)', [SlotToStr(I)]));
        try FOnInventory.ForEach(
            procedure(It: TBBotEvent_Inventory.It)
            begin
              It^(I, SelfInfo.Inventory[I]);
            end);
        except
          on E: Exception do
            raise EBBotEvent.Create('OnInventory', E)
          else
            raise;
        end;
      end;
      SelfInfo.Inventory[I].ID := Me.Inventory.GetSlot(I).ID;
      SelfInfo.Inventory[I].Count := Me.Inventory.GetSlot(I).Count;
    end;
  end;
end;

procedure TBBotEvents.ReloadSelfLevel;
begin
  if Me.Level <> SelfInfo.Level then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnLevel(%d -> %d)', [SelfInfo.Level, Me.Level]));
      try FOnLevel.ForEach(
          procedure(It: TBBotEvent_BInt32.It)
          begin
            It^(SelfInfo.Level);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnLevel', E)
        else
          raise;
      end;
    end;
    SelfInfo.Level := Me.Level;
  end;
end;

procedure TBBotEvents.ReloadSelfMana;
begin
  if Me.Mana <> SelfInfo.Mana then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnMana(%d -> %d)', [SelfInfo.Mana, Me.Mana]));
      try FOnMana.ForEach(
          procedure(It: TBBotEvent_BInt32.It)
          begin
            It^(SelfInfo.Mana);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnMana', E)
        else
          raise;
      end;
    end;
    SelfInfo.Mana := Me.Mana;
  end;
end;

procedure TBBotEvents.ReloadSelfPostion;
begin
  if Me.Position <> SelfInfo.Position then begin
    if Enabled then begin
      if DebugNormal and DebugAll then
        AddDebug(BFormat('OnWalk(%s -> %s)', [BStr(SelfInfo.Position), BStr(Me.Position)]));
      try FOnWalk.ForEach(
          procedure(It: TBBotEvent_BPos.It)
          begin
            It^(SelfInfo.Position);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnWalk', E)
        else
          raise;
      end;
    end;
    SelfInfo.Position := Me.Position;
  end;
end;

procedure TBBotEvents.ReloadSelfSkill;
var
  I: TTibiaSkill;
  Level: BInt32;
begin
  for I := SkillFirst to SkillLast do begin
    Level := (Me.SkillLevel[I] * 100) + Me.SkillPercent[I];
    if (Level <> SelfInfo.Skill[I]) then begin
      if Enabled then begin
        if DebugNormal then
          AddDebug(BFormat('OnSkill(%s, %d)', [SkillToStr(I), Level]));
        try FOnSkill.ForEach(
            procedure(It: TBBotEvent_Skill.It)
            begin
              It^(I, SelfInfo.Skill[I]);
            end);
        except
          on E: Exception do
            raise EBBotEvent.Create('OnSkill', E)
          else
            raise;
        end;
      end;
      SelfInfo.Skill[I] := Level;
    end;
  end;
end;

procedure TBBotEvents.ReloadSelfStatus;
begin
  if Me.Status <> SelfInfo.Status then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug('OnStatus(...)');
      try FOnStatus.ForEach(
          procedure(It: TBBotEvent_Notify.It)
          begin
            It^();
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnStatus', E)
        else
          raise;
      end;
    end;
    SelfInfo.Status := Me.Status;
  end;
end;

procedure TBBotEvents.ReloadSelfTarget;
begin
  if TargetInfo <> Me.TargetID then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnTarget(%d -> %d)', [TargetInfo, Me.TargetID]));
      try FOnTarget.ForEach(
          procedure(It: TBBotEvent_Creature.It)
          begin
            It^(BBot.Creatures.Target);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnTarget', E)
        else
          raise;
      end;
    end;
    TargetInfo := Me.TargetID;
  end;
end;

procedure TBBotEvents.ReloadSelfTibiaFocus;
var
  IsFocused: BBool;
begin
  IsFocused := GetForegroundWindow = TibiaProcess.hWnd;
  if IsFocused <> FocusInfo then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnTibiaFocus(%d)', [BInt32(IsFocused)]));
      try FOnTibiaFocus.ForEach(
          procedure(It: TBBotEvent_BBool.It)
          begin
            It^(IsFocused);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnTibiaFocus', E)
        else
          raise;
      end;
    end;
    FocusInfo := IsFocused;
  end;
end;

procedure TBBotEvents.ResetCreatureState(Creature: TBBotCreature);
var
  CreatureState: PCreatureInfo;
begin
  CreatureState := @CreatureInfo[Creature.Index];
  CreatureState.ID := Creature.ID;
  CreatureState.Attack := 0;
  CreatureState.BlackSquare := Creature.BlackSquareTime;
  CreatureState.HP := Creature.Health;
  CreatureState.Pos := Creature.Position;
  CreatureState.LightIntensity := Creature.LightIntensity;
  CreatureState.Speed := Creature.Speed;
  CreatureState.Tick := Tick;
end;

procedure TBBotEvents.ReloadCreatures;
begin
  BBot.Creatures.RawTraverse(
    procedure(Creature: TBBotCreature)
    var
      CreatureState: PCreatureInfo;
      OnScreen: BBool;
    begin
      CreatureState := @CreatureInfo[Creature.Index];
      if Creature.ID <> CreatureState.ID then begin
        if DebugNormal then
          AddDebug(BFormat('OnCreatureEnter(%s %d)', [Creature.Name, Creature.ID]));
        ResetCreatureState(Creature);
        if Enabled then
          try FOnCreature.ForEach(
              procedure(It: TBBotEvent_Creature.It)
              begin
                It^(Creature);
              end);
          except
            on E: Exception do
              raise EBBotEvent.Create('OnCreature', E)
            else
              raise;
          end;
      end else begin
        OnScreen := TibiaInScreen(Me.Position.X, Me.Position.Y, Me.Position.Z, Creature.Position.X, Creature.Position.Y,
          Me.Position.Z, // We don't care if creature is on other floor
        False);
        if OnScreen <> CreatureState.OnScreen then begin
          if DebugNormal then
            if OnScreen then begin
              AddDebug(BFormat('OnCreatureReEnter(%s %d)', [Creature.Name, Creature.ID]));
            end else begin
              AddDebug(BFormat('OnCreatureLeave(%s %d)', [Creature.Name, Creature.ID]));
            end;
          ResetCreatureState(Creature);
          CreatureState.OnScreen := OnScreen;
        end;
        if OnScreen then begin
          ReloadCreatureTick(Creature);
          ReloadCreatureHP(Creature);
          ReloadCreatureLight(Creature);
          ReloadCreatureSpeed(Creature);
          ReloadCreatureWalk(Creature);
          ReloadCreatureAttack(Creature);
        end;
      end;
    end);
end;

procedure TBBotEvents.ReloadCreatureSpeed(Creature: TBBotCreature);
begin
  if CreatureInfo[Creature.Index].Speed <> Creature.Speed then begin
    if Enabled then begin
      if DebugNormal then
        AddDebug(BFormat('OnCreatureSpeed(%s %d, %d -> %d)', [Creature.Name, Creature.ID,
          CreatureInfo[Creature.Index].Speed, Creature.Speed]));
      try FOnCreatureSpeed.ForEach(
          procedure(It: TBBotEvent_CreatureBInt32.It)
          begin
            It^(Creature, CreatureInfo[Creature.Index].Speed);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnCreatureSpeed', E)
        else
          raise;
      end;
    end;
    CreatureInfo[Creature.Index].Speed := Creature.Speed;
  end;
end;

procedure TBBotEvents.Run;
begin
  inherited;
  ReloadBuffers;
  ReloadSelf;
  ReloadCreatures;
  ReloadContainers;
end;

procedure TBBotEvents.RunBotPacket(ABuffer: BPtr; ASize: BInt32);
begin
  if Enabled then
    try FOnBotPacket.ForEach(
        procedure(It: TBBotEvent_Packet.It)
        begin
          It^(ABuffer, ASize);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnBPack', E)
      else
        raise;
    end;
end;

procedure TBBotEvents.RunClientPacket(ABuffer: BPtr; ASize: BInt32);
begin
  if Enabled then
    try FOnClientPacket.ForEach(
        procedure(It: TBBotEvent_Packet.It)
        begin
          It^(ABuffer, ASize);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnCPack', E)
      else
        raise;
    end;

end;

procedure TBBotEvents.RunCreatureAttack(Creature: TBBotCreature);
begin
  if (Tick - CreatureInfo[Creature.Index].Attack) > BBotEventCreatureAttack then begin
    if Enabled then
      try FOnCreatureAttack.ForEach(
          procedure(It: TBBotEvent_Creature.It)
          begin
            It^(Creature);
          end);
      except
        on E: Exception do
          raise EBBotEvent.Create('OnCreatureAttack', E)
        else
          raise;
      end;
    if DebugNormal then
      AddDebug(BFormat('OnCreatureAttack(%s %d)', [Creature.Name, Creature.ID]));
    CreatureInfo[Creature.Index].Attack := Tick;
  end;
end;

procedure TBBotEvents.RunCreatureFollow(ACreatureID: BInt32);
var
  Creature: TBBotCreature;
begin
  Creature := BBot.Creatures.Find(ACreatureID);
  if Enabled then
    try FOnCreatureFollow.ForEach(
        procedure(It: TBBotEvent_Creature.It)
        begin
          It^(Creature);
        end);
    except
      on E: Exception do
        raise EBBotEvent.Create('OnCreatureFollow', E)
      else
        raise;
    end;
  if DebugNormal then
    if Creature <> nil then
      AddDebug(BFormat('OnCreatureFollow(%s %d)', [Creature.Name, Creature.ID]))
    else
      AddDebug('OnCreatureUnFollow()');
end;

{ EBBotEvent }

constructor EBBotEvent.Create(AName: BStr; E: Exception);
begin
  inherited Create('BBot->Event->' + AName + BStrLine + E.Message);
end;

end.
