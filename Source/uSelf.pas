unit uSelf;

interface

uses
  uBTypes,
  Windows,
  Math,
  Declaracoes,
  uBattlelist,
  uItem,
  uTibiaDeclarations,
  uInventory;

type
  TTibiaSelf = class
  private
    ConnectData: Byte;
    GoData: BPos;
    FHPMax: BInt32;
    FHP: BInt32;
    FLevelPercent: BInt32;
    FSoul: BInt32;
    FManaMax: BInt32;
    FMana: BInt32;
    FCapacity: BInt32;
    FLevel: BInt32;
    FStamina: BInt32;
    FID: BUInt32;
    FTargetID: BUInt32;
    FExp: Int64;
    FLoggingOut: BBool;
    FInventory: TTibiaInventory;
    FSkillPercent: TTibiaSelfSkill;
    FSkillLevel: TTibiaSelfSkill;
    FStatus: TTibiaSelfStatus;
    FLastAttackedID: BUInt32;
    FSpecialSkill: TTibiaSelfSpecialSkill;
    function GetConnected: boolean;
    procedure SetWalking(const Value: boolean);
    function GetIsAttacking: BBool;
    function GetStepDelay: BUInt32;
    function GetPosition: BPos;
    function GetLight: TTibiaLight;
    function GetName: BStr;
    function GetWalking: BBool;
    function GetSpeed: BInt32;
    function GetDirection: TTibiaDirection;
    function GetOutfit: TTibiaOutfit;
  public
    constructor Create;
    destructor Destroy; override;

    property Capacity: BInt32 read FCapacity;
    property Experience: Int64 read FExp;
    property HP: BInt32 read FHP;
    property HPMax: BInt32 read FHPMax;
    property ID: BUInt32 read FID;
    property TargetID: BUInt32 read FTargetID;
    property Level: BInt32 read FLevel;
    property LevelPercent: BInt32 read FLevelPercent;
    property Mana: BInt32 read FMana;
    property ManaMax: BInt32 read FManaMax;
    property Soul: BInt32 read FSoul;
    property Stamina: BInt32 read FStamina;
    property Position: BPos read GetPosition;
    property GoingTo: BPos read GoData;
    property Light: TTibiaLight read GetLight;
    property Name: BStr read GetName;
    property Walking: BBool read GetWalking write SetWalking;
    property Speed: BInt32 read GetSpeed;
    property Connected: boolean read GetConnected;
    property Direction: TTibiaDirection read GetDirection;
    property StepDelay: BUInt32 read GetStepDelay;
    property LoggingOut: BBool read FLoggingOut write FLoggingOut;
    property IsAttacking: BBool read GetIsAttacking;
    property LastAttackedID: BUInt32 read FLastAttackedID;
    property Inventory: TTibiaInventory read FInventory;
    property Outfit: TTibiaOutfit read GetOutfit;
    property Status: TTibiaSelfStatus read FStatus;
    property SkillLevel: TTibiaSelfSkill read FSkillLevel;
    property SkillPercent: TTibiaSelfSkill read FSkillPercent;

    property SpecialSkill: TTibiaSelfSpecialSkill read FSpecialSkill;
    procedure SetSpecialSkill(const ASpecialSkill: TTibiaSpecialSkill; const AValue: BInt32);

    function CanSee(Pos: BPos): BBool;
    function CanTakeItem(const AItem: TTibiaItem): BBool;
    function Exiva(ExivaTo: BPos): BStr;
    function GetDirectionTo(ToPosition: BPos): TTibiaDirection;
    function GetDistance(ToPosition: BPos): BInt32;
    function DistanceTo(ToPosition: BPos): BInt32; overload;
    function DistanceTo(ToCreature: TBBotCreature): BInt32; overload;

    procedure Turn(TurnDir: TTibiaDirection);
    procedure Step(StepDir: TTibiaDirection);
    procedure ToggleMount;
    procedure Say(const Msg: String);
    procedure SayInChannel(const Msg: String; Channel: BInt32);
    procedure Whisper(const Msg: String);
    procedure Yell(const Msg: String);
    procedure TradeSay(const Msg: BStr);
    procedure NPCSay(const Msg: String);
    procedure PrivateMessage(const Msg, Dest: BStr);
    procedure UseOnMe(UseID: BInt32);
    procedure Logout;
    procedure Reload;
    procedure Stop;
    procedure HackLight(ARadius: BInt32);
    procedure InviteToParty(const ACreature: TBBotCreature);
    procedure JoinParty(const ALeader: TBBotCreature);
    procedure PassLeader(const ALeader: TBBotCreature);
    procedure RevokeInviteToParty(const ACreature: TBBotCreature);
    procedure LeaveParty;
    procedure SharedPartyExp(const AShared: BBool);
  end;

implementation

uses
  uTibia,
  BBotEngine,
  uHUD,
  uBBotSpells,

  uBBotAddresses,

  uTibiaProcess,
  uTibiaState;

constructor TTibiaSelf.Create;
begin
  inherited;
  FInventory := CreateInventory;
  FLoggingOut := False;
end;

{ TTibiaSelf }

function TTibiaSelf.CanSee(Pos: BPos): BBool;
begin
  Result := TibiaInScreen(Position.X, Position.Y, Position.Z, Pos.X, Pos.Y, Pos.Z, False);
end;

function TTibiaSelf.CanTakeItem(const AItem: TTibiaItem): BBool;
begin
  Result := Capacity >= AItem.TotalWeight;
end;

function TTibiaSelf.Exiva(ExivaTo: BPos): BStr;
var
  Dist: BInt32;
  s, s2: BStr;
begin
  Dist := Self.GetDistance(ExivaTo);
  if ExivaTo.Z < Position.Z then
    s := 'Higher level'
  else if ExivaTo.Z > Position.Z then
    s := 'Lower level'
  else if ExivaTo.Z = Position.Z then
    s := 'Same level';

  if Dist < 5 then
    s := s + ' standing next to you '
  else if Dist < 100 then
    s := s + ' to the '
  else if Dist < 275 then
    s := s + ' far to the '
  else if Dist > 274 then
    s := s + ' very far to the ';
  s2 := DirToStr(Self.GetDirectionTo(ExivaTo));
  Result := s + s2;
end;

function TTibiaSelf.GetDirection: TTibiaDirection;
begin
  if BBot.Creatures.Player <> nil then
    Result := BBot.Creatures.Player.Direction
  else
    Result := tdNorth;
end;

function TTibiaSelf.GetDirectionTo(ToPosition: BPos): TTibiaDirection;
var
  Tnr: double;
  Dist: BPos;
begin
  Dist.X := Position.X - ToPosition.X;
  Dist.Y := Position.Y - ToPosition.Y;
  Dist.Z := Position.Z - ToPosition.Z;

  if Dist.X <> 0 then
    Tnr := Dist.Y / Dist.X
  else
    Tnr := 10;

  Tnr := Tnr * 4;

  if Abs(Tnr) < 0.4142 then
    if Dist.X > 0 then
      Exit(tdWest)
    else
      Exit(tdEast);

  if Abs(Tnr) < 2.4142 then
    if Tnr > 0 then begin
      if Dist.Y > 0 then
        Exit(tdNorthWest)
      else
        Exit(tdSouthEast);
    end else begin
      if Dist.X > 0 then
        Exit(tdSouthWest)
      else
        Exit(tdNorthEast);
    end;

  if Dist.Y > 0 then
    Exit(tdNorth)
  else
    Exit(tdSouth);
end;

function TTibiaSelf.GetDistance(ToPosition: BPos): BInt32;
begin
  Result := DistanceBetween(Me.Position, ToPosition);
end;

function TTibiaSelf.GetIsAttacking: BBool;
begin
  Result := BBot.Creatures.Target <> nil;
end;

function TTibiaSelf.GetLight: TTibiaLight;
begin
  if BBot.Creatures.Player <> nil then begin
    Result.Intensity := BBot.Creatures.Player.LightIntensity;
    Result.Color := BBot.Creatures.Player.LightColor;
  end else begin
    Result.Intensity := 0;
    Result.Color := 0;
  end;
end;

function TTibiaSelf.GetName: BStr;
begin
  if BBot.Creatures.Player <> nil then
    Result := BBot.Creatures.Player.Name
  else
    Result := 'Unknown';
end;

function TTibiaSelf.GetOutfit: TTibiaOutfit;
begin
  if BBot.Creatures.Player <> nil then
    Result := BBot.Creatures.Player.Outfit
  else begin
    Result.Outfit := 0;
    Result.HeadColor := 0;
    Result.BodyColor := 0;
    Result.LegsColor := 0;
    Result.FeetColor := 0;
    Result.Addons := 0;
    Result.Mount := 0;
  end;
end;

function TTibiaSelf.GetPosition: BPos;
begin
  if BBot.Creatures.Player <> nil then
    Result := BBot.Creatures.Player.Position
  else
    Result := BPosXYZ(0, 0, 0);
end;

function TTibiaSelf.GetSpeed: BInt32;
begin
  if BBot.Creatures.Player <> nil then
    Result := BBot.Creatures.Player.Speed
  else
    Result := 0;
end;

function TTibiaSelf.GetStepDelay: BUInt32;
begin
  if AdrSelected < TibiaVer980 then
    Result := EnsureRange(Round((60 * 1000) / Max(Speed, 1)), 20, 200)
  else
    Result := EnsureRange(Round((60 * 1000) / Max(Speed * 2, 1)), 20, 200);
end;

function TTibiaSelf.GetWalking: BBool;
begin
  if BBot.Creatures.Player <> nil then
    Result := BBot.Creatures.Player.Walking
  else
    Result := False;
end;

procedure TTibiaSelf.HackLight(ARadius: BInt32);
var
  Creature: TBBotCreature;
begin
  Creature := BBot.Creatures.Player;
  if Creature <> nil then begin
    Creature.LightColor := 215;
    Creature.LightIntensity := ARadius;
  end;
end;

procedure TTibiaSelf.InviteToParty(const ACreature: TBBotCreature);
begin
  BBot.PacketSender.InviteToParty(ACreature.ID);
end;

procedure TTibiaSelf.JoinParty(const ALeader: TBBotCreature);
begin
  BBot.PacketSender.JoinParty(ALeader.ID);
end;

procedure TTibiaSelf.NPCSay(const Msg: String);
var
  HUD: TBBotHUD;
begin
  HUD := TBBotHUD.Create(bhgAny);
  HUD.AlignTo(bhaCenter, bhaMiddle);
  HUD.Color := $00FFFF;
  HUD.Expire := 5000;
  HUD.Print(Me.Name + ' says:');
  HUD.Print(Msg);
  HUD.Free;
  BBot.PacketSender.NPCChannelMessage(Msg);
end;

procedure TTibiaSelf.PassLeader(const ALeader: TBBotCreature);
begin
  BBot.PacketSender.PartyPassLeader(ALeader.ID);
end;

procedure TTibiaSelf.PrivateMessage(const Msg, Dest: BStr);
begin
  BBot.PacketSender.PrivateMesage(Msg, Dest);
end;

procedure TTibiaSelf.Reload;
var
  Exp4: BInt32;
  XorVal: BInt32;
begin
  TibiaProcess.Read(TibiaAddresses.AdrCapacity, 4, @FCapacity);
  TibiaProcess.Read(TibiaAddresses.AdrSkills, SizeOf(SkillLevel) - 4, @SkillLevel);
  TibiaProcess.Read(TibiaAddresses.AdrSkillsPercent, SizeOf(SkillPercent) - 4, @SkillPercent);
  TibiaProcess.Read(TibiaAddresses.AdrStamina, 4, @FStamina);
  TibiaProcess.Read(TibiaAddresses.AdrSoul, 4, @FSoul);
  TibiaProcess.Read(TibiaAddresses.AdrMana, 4, @FMana);
  TibiaProcess.Read(TibiaAddresses.AdrManaMax, 4, @FManaMax);
  TibiaProcess.Read(TibiaAddresses.AdrHP, 4, @FHP);
  TibiaProcess.Read(TibiaAddresses.AdrHPMax, 4, @FHPMax);
  TibiaProcess.Read(TibiaAddresses.AdrLevel, 4, @FLevel);
  TibiaProcess.Read(TibiaAddresses.AdrLevelPercent, 4, @FLevelPercent);
  TibiaProcess.Read(TibiaAddresses.AdrID, 4, @FID);
  TibiaProcess.Read(TibiaAddresses.AdrMagic, 4, @SkillLevel[SkillMagic]);
  TibiaProcess.Read(TibiaAddresses.AdrMagicPercent, 4, @SkillPercent[SkillMagic]);

  if AdrSelected >= TibiaVer870 then
    TibiaProcess.Read(TibiaAddresses.AdrExperience, 8, @FExp)
  else begin
    TibiaProcess.Read(TibiaAddresses.AdrExperience, 4, @Exp4);
    FExp := Int64(Exp4);
  end;

  TibiaProcess.Read(TibiaAddresses.AdrAttackSquare, 4, @FTargetID);
  if FTargetID <> 0 then
    FLastAttackedID := FTargetID;
  TibiaProcess.Read(TibiaAddresses.AdrFlags, SizeOf(Status), @Status);
  TibiaProcess.Read(TibiaAddresses.AdrGoToX, 4, @GoData.X);
  TibiaProcess.Read(TibiaAddresses.AdrGoToY, 4, @GoData.Y);
  TibiaProcess.Read(TibiaAddresses.AdrGoToZ, 4, @GoData.Z);
  TibiaProcess.Read(TibiaAddresses.AdrSelfConnection, 1, @ConnectData);

  if AdrSelected >= TibiaVer943 then begin
    TibiaProcess.Read(TibiaAddresses.AdrXor, 4, @XorVal);
    FHP := FHP xor XorVal;
    FHPMax := FHPMax xor XorVal;
    FManaMax := FManaMax xor XorVal;
    FMana := FMana xor XorVal;
    FCapacity := FCapacity xor XorVal;
  end;

  if FHP = 0 then
    FStatus := FStatus + [tsDeath];

  if BBot <> nil then begin
    Inventory.Reload;
    if Light.Intensity <> 0 then
      FStatus := FStatus + [tsLight];
    if Outfit.Outfit = 0 then
      FStatus := FStatus + [tsInvisible];
    if Outfit.Mount <> 0 then
      FStatus := FStatus + [tsMounted];
  end;
end;

procedure TTibiaSelf.RevokeInviteToParty(const ACreature: TBBotCreature);
begin
  BBot.PacketSender.RevokeInviteToParty(ACreature.ID);
end;

procedure TTibiaSelf.Say(const Msg: String);
begin
  BBot.PacketSender.SayMessage(Msg);
end;

procedure TTibiaSelf.SayInChannel(const Msg: String; Channel: BInt32);
begin
  BBot.PacketSender.ChannelMessage(Msg, Channel);
end;

procedure TTibiaSelf.SetSpecialSkill(const ASpecialSkill: TTibiaSpecialSkill; const AValue: BInt32);
begin
  FSpecialSkill[ASpecialSkill] := AValue;
end;

procedure TTibiaSelf.SetWalking(const Value: boolean);
begin
  if Value and (BBot.Creatures.Player <> nil) then
    BBot.Creatures.Player.Walking := Value;
end;

procedure TTibiaSelf.SharedPartyExp(const AShared: BBool);
begin
  BBot.PacketSender.PartyShareExp(AShared);
end;

procedure TTibiaSelf.Step(StepDir: TTibiaDirection);
begin
  BBot.PacketSender.WalkStep(StepDir);
end;

procedure TTibiaSelf.Stop;
begin
  BBot.PacketSender.StopAction;
end;

procedure TTibiaSelf.Turn(TurnDir: TTibiaDirection);
begin
  if (TurnDir <> tdNorth) and (TurnDir <> tdSouth) and (TurnDir <> tdWest) and (TurnDir <> tdEast) then
    Exit;
  if TurnDir = Direction then
    Exit;
  BBot.PacketSender.TurnSelf(TurnDir);
end;

procedure TTibiaSelf.Whisper(const Msg: String);
begin
  BBot.PacketSender.WhisperMessage(Msg);
end;

procedure TTibiaSelf.Yell(const Msg: String);
begin
  BBot.PacketSender.YellMessage(Msg);
end;

procedure TTibiaSelf.ToggleMount;
begin
  BBot.PacketSender.ToggleMount(tsMounted in Status);
end;

procedure TTibiaSelf.TradeSay(const Msg: BStr);
begin
  BBot.PacketSender.TradeChannelMessage(Msg);
end;

procedure TTibiaSelf.UseOnMe(UseID: BInt32);
begin
  Tibia.Shoot(UseID, Me.ID);
end;

destructor TTibiaSelf.Destroy;
begin
  FInventory.Free;
  inherited;
end;

function TTibiaSelf.DistanceTo(ToCreature: TBBotCreature): BInt32;
begin
  Result := DistanceTo(ToCreature.Position);
end;

function TTibiaSelf.DistanceTo(ToPosition: BPos): BInt32;
begin
  Result := GetDistance(ToPosition);
end;

function TTibiaSelf.GetConnected: boolean;
begin
  if AdrSelected < TibiaVer980 then
    Result := ConnectData = 8
  else if AdrSelected < TibiaVer1011 then
    Result := ConnectData = $A
  else
    Result := ConnectData = $B;
end;

procedure TTibiaSelf.LeaveParty;
begin
  BBot.PacketSender.LeaveParty;
end;

procedure TTibiaSelf.Logout;
begin
  LoggingOut := True;
end;

end.
