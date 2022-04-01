unit uBBotCreatures870;

interface

uses
  uBTypes,
  uTibiaDeclarations,
  uBBotCreatures,
  Windows,
  uBattlelist;

type
  TBBotCreatures870 = class(TBBotCreatures)
  private
    Buffer: BPtr;
  protected
    procedure Update; override;
    function GetPlayerID: BUInt32; override;
    function GetTargetID: BUInt32; override;
    function GetCreatureBufferSize: BUInt32; override;
    function GetCreatureBufferCount: BUInt32; override;
  public
    procedure Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32); override;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  BBotEngine,
  uTibiaProcess,
  uBBotAddresses{$IFDEF TEST},
  TestFramework{$ENDIF};

const
  TibiaCreatureListSize = 1300;

type
  TBBotCreature870Buffer = record
    ID: BUInt32;
    Name: BStr32;
    X: BInt32;
    Y: BInt32;
    Z: BInt32;
    ScreenX: BInt32;
    ScreenY: BInt32;
    _U1: array [0 .. 4] of BInt32;
    Walking: BInt32;
    Direction: BInt32;
    _U2: array [0 .. 2] of BInt32;
    Outfit: TTibiaOutfit870;
    Light: BInt32;
    LightColor: BInt32;
    _U3: BInt32;
    BlackSquare: BUInt32;
    HP: BInt32;
    Speed: BInt32;
    IsVisible: BInt32;
    Skull: BInt32;
    Party: BInt32;
    _U4: BInt8;
    War: BInt32;
    IsBlock: BInt32;

  end;

  PBBotCreature870Buffer = ^TBBotCreature870Buffer;

  TBBotCreatureList870Buffer = array [0 .. TibiaCreatureListSize - 1] of TBBotCreature870Buffer;
  PBBotCreatureList870Buffer = ^TBBotCreatureList870Buffer;

  { TBBotCreature870 }
  TBBotCreature870 = class(TBBotCreature)
  private
    Buffer: PBBotCreature870Buffer;
    Creatures: TBBotCreatures;
  protected
    function GetID: BUInt32; override;
    function GetName: BStr; override;
    function GetPosition: BPos; override;
    function GetScreen: TPoint; override;
    function GetDirection: TTibiaDirection; override;
    function GetHealth: BInt32; override;
    function GetSpeed: BInt32; override;
    function GetSkull: TTibiaSkull; override;
    function GetParty: TTibiaParty; override;
    function GetWar: TTibiaWar; override;
    function GetCreatureKind: TTibiaCreatureKind; override;
    function GetNPCKind: TTibiaNPCKind; override;
    function GetBlackSquareTime: BUInt32; override;
    function GetGroupOnline: BInt32; override;
    function GetSquareVisible: BBool; override;
    function GetSquareRed: BInt32; override;
    function GetSquareGreen: BInt32; override;
    function GetSquareBlue: BInt32; override;
    function GetIsSelf: BBool; override;
    function GetIsPlayer: BBool; override;
    function GetIsNPC: BBool; override;
    function GetIsTarget: BBool; override;
    function GetIsVisible: BBool; override;
    function GetWalking: BBool; override;
    function GetOutfit: TTibiaOutfit; override;
    function GetLightIntensity: BInt32; override;
    function GetLightColor: BInt32; override;
    function GetOffsetLightColor: BInt32; override;
    function GetOffsetLightIntensity: BInt32; override;
    function GetOffsetOutfit: BInt32; override;
    function GetOffsetWalking: BInt32; override;

    procedure SetLightColor(const Value: BInt32); override;
    procedure SetLightIntensity(const Value: BInt32); override;
    procedure SetOutfit(const Value: TTibiaOutfit); override;
    procedure SetWalking(const Value: BBool); override;
  public
    constructor Create(AIndex: BInt32; ABuffer: PBBotCreature870Buffer; ACreatures: TBBotCreatures);
  end;

function TBBotCreature870.GetID: BUInt32;
begin
  Result := Buffer^.ID;
end;

function TBBotCreature870.GetName: BStr;
begin
  Result := BStr(BPChar(@Buffer^.Name[0]));
end;

function TBBotCreature870.GetPosition: BPos;
begin
  Result.X := Buffer^.X;
  Result.Y := Buffer^.Y;
  Result.Z := Buffer^.Z;
end;

function TBBotCreature870.GetScreen: TPoint;
begin
  Result.X := Buffer^.ScreenX;
  Result.Y := Buffer^.ScreenY;
end;

function TBBotCreature870.GetDirection: TTibiaDirection;
begin
  if BInRange(Buffer^.Direction, Ord(tdNorth), Ord(tdNorthWest)) then
    Result := TTibiaDirection(Buffer^.Direction)
  else
    raise BException.Create('Unable to load creature direction in 870');
end;

function TBBotCreature870.GetHealth: BInt32;
begin
  Result := Buffer^.HP;
end;

function TBBotCreature870.GetSpeed: BInt32;
begin
  Result := Buffer^.Speed;
end;

function TBBotCreature870.GetSkull: TTibiaSkull;
begin
  if BInRange(Buffer^.Skull, Ord(SkullFirst), Ord(SkullLast)) then
    Result := TTibiaSkull(Buffer^.Skull)
  else
    raise BException.Create('Unable to load creature skull in 870');
end;

function TBBotCreature870.GetParty: TTibiaParty;
begin
  Result.Load(Buffer^.Party);
end;

function TBBotCreature870.GetWar: TTibiaWar;
begin

  if BInRange(Buffer^.War, Ord(WarNone), Ord(WarUnInvolved)) then
    Result := TTibiaWar(Buffer^.War)
  else
    raise BException.Create('Unable to load creature war in 870');
end;

procedure TBBotCreature870.SetLightColor(const Value: BInt32);
begin
  Creatures.Write(Index, GetOffsetLightColor, @Value, 4);
end;

procedure TBBotCreature870.SetLightIntensity(const Value: BInt32);
begin
  Creatures.Write(Index, GetOffsetLightIntensity, @Value, 4);
end;

procedure TBBotCreature870.SetOutfit(const Value: TTibiaOutfit);
var
  NewOutfit: TTibiaOutfit870;
begin
  NewOutfit.Outfit := Value.Outfit;
  NewOutfit.HeadColor := Value.HeadColor;
  NewOutfit.BodyColor := Value.BodyColor;
  NewOutfit.LegsColor := Value.LegsColor;
  NewOutfit.FeetColor := Value.FeetColor;
  NewOutfit.Addons := Value.Addons;
  NewOutfit.Mount := Value.Mount;
  Creatures.Write(Index, GetOffsetOutfit, @NewOutfit, SizeOf(NewOutfit));
end;

procedure TBBotCreature870.SetWalking(const Value: BBool);
var
  IntValue: BInt32;
begin
  IntValue := BIf(Value, 1, 0);
  Creatures.Write(Index, GetOffsetWalking, @IntValue, 4);
end;

function TBBotCreature870.GetCreatureKind: TTibiaCreatureKind;
begin
  Result := CreaturePlayer;
end;

function TBBotCreature870.GetNPCKind: TTibiaNPCKind;
begin
  Result := NPCNone;
end;

constructor TBBotCreature870.Create(AIndex: BInt32; ABuffer: PBBotCreature870Buffer; ACreatures: TBBotCreatures);
begin
  inherited Create(AIndex);
  Buffer := ABuffer;
  Creatures := ACreatures;
end;

function TBBotCreature870.GetBlackSquareTime: BUInt32;
begin
  Result := Buffer^.BlackSquare;
end;

function TBBotCreature870.GetGroupOnline: BInt32;
begin
  Result := 0;
end;

function TBBotCreature870.GetSquareVisible: BBool;
begin
  Result := False;
end;

function TBBotCreature870.GetSquareRed: BInt32;
begin
  Result := 0;
end;

function TBBotCreature870.GetSquareGreen: BInt32;
begin
  Result := 0;
end;

function TBBotCreature870.GetSquareBlue: BInt32;
begin
  Result := 0;
end;

function TBBotCreature870.GetIsSelf: BBool;
begin
  Result := GetID() = Creatures.PlayerID;
end;

function TBBotCreature870.GetIsPlayer: BBool;
begin
  Result := IsPlayerID(GetID());
end;

function TBBotCreature870.GetIsNPC: BBool;
begin
  Result := not GetIsPlayer();
end;

function TBBotCreature870.GetIsTarget: BBool;
begin
  Result := GetID() = Creatures.TargetID;
end;

function TBBotCreature870.GetIsVisible: BBool;
begin
  Result := Buffer^.IsVisible = 1;
end;

function TBBotCreature870.GetWalking: BBool;
begin
  Result := Buffer^.Walking = 1;
end;

function TBBotCreature870.GetOutfit: TTibiaOutfit;
begin
  Result.Outfit := Buffer^.Outfit.Outfit;
  Result.HeadColor := Buffer^.Outfit.HeadColor;
  Result.BodyColor := Buffer^.Outfit.BodyColor;
  Result.LegsColor := Buffer^.Outfit.LegsColor;
  Result.FeetColor := Buffer^.Outfit.FeetColor;
  Result.Addons := Buffer^.Outfit.Addons;
  Result.Mount := Buffer^.Outfit.Mount;
end;

function TBBotCreature870.GetLightIntensity: BInt32;
begin
  Result := Buffer^.Light;
end;

function TBBotCreature870.GetLightColor: BInt32;
begin
  Result := Buffer^.LightColor;
end;

function TBBotCreature870.GetOffsetLightColor: BInt32;
begin
  Result := BInt32(@Buffer^.LightColor) - BInt32(@Buffer^.ID);
end;

function TBBotCreature870.GetOffsetLightIntensity: BInt32;
begin
  Result := BInt32(@Buffer^.Light) - BInt32(@Buffer^.ID);
end;

function TBBotCreature870.GetOffsetOutfit: BInt32;
begin
  Result := BInt32(@Buffer^.Outfit) - BInt32(@Buffer^.ID);
end;

function TBBotCreature870.GetOffsetWalking: BInt32;
begin
  Result := BInt32(@Buffer^.Walking) - BInt32(@Buffer^.ID);
end;

{ TTibiaCreatures870 }

procedure TBBotCreatures870.Update;
begin
  TibiaProcess.Read(TibiaAddresses.AdrBattle, GetBufferSize, Buffer);
end;

function TBBotCreatures870.GetPlayerID: BUInt32;
begin
  Result := Me.ID;
end;

function TBBotCreatures870.GetTargetID: BUInt32;
begin
  Result := Me.TargetID;
end;

function TBBotCreatures870.GetCreatureBufferSize: BUInt32;
begin
  Result := SizeOf(TBBotCreature870Buffer);
end;

function TBBotCreatures870.GetCreatureBufferCount: BUInt32;
begin
  Result := TibiaCreatureListSize;
end;

procedure TBBotCreatures870.Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32);
var
  Offset: BUInt32;
begin
  Offset := GetCreatureOffset(ACreature) + AOffset;
  Move(AValue^, BPtr(BUInt32(Buffer) + Offset)^, ASize);
  TibiaProcess.Write(BUInt32(TibiaAddresses.AdrBattle) + Offset, ASize, AValue);
end;

constructor TBBotCreatures870.Create;
var
  I: BUInt32;
  Add: TCreatureIter;
  BufferList: PBBotCreatureList870Buffer;
begin
  inherited Create;
  New(BufferList);
  Buffer := BufferList;
  for I := 0 to GetCreatureBufferCount - 1 do begin
    Add := CreatureList.Add;
    Add^.First := False;
    Add^.Second := TBBotCreature870.Create(I, @BufferList[I], Self);
  end;
end;

destructor TBBotCreatures870.Destroy;
begin
  Dispose(PBBotCreatureList870Buffer(Buffer));
  inherited;
end;

{$IFDEF TEST}

const
  MockSelfID = 1;
  MockTargetID = 2;

type
  TBBotCreatures870Mock = class(TBBotCreatures)
  private
    Buffer: BPtr;
  protected
    procedure Update; override;
    function GetPlayerID: BUInt32; override;
    function GetTargetID: BUInt32; override;
    function GetCreatureBufferSize: BUInt32; override;
    function GetCreatureBufferCount: BUInt32; override;
    procedure Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  BCreatures870TestCase = class(TTestCase)
  private
    Creatures: TBBotCreatures;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreatureCount;
    procedure TestTarget;
    procedure TestSelf;
    procedure TestTargetDistance;
    procedure TestSelfLight;
    procedure TestSelfOutfit;
    procedure TestSelfWalking;
  end;

  { TTibiaCreatures870Mock }

procedure TBBotCreatures870Mock.Update;
begin

end;

function TBBotCreatures870Mock.GetPlayerID: BUInt32;
begin
  Result := MockSelfID;
end;

function TBBotCreatures870Mock.GetTargetID: BUInt32;
begin
  Result := MockTargetID;
end;

function TBBotCreatures870Mock.GetCreatureBufferSize: BUInt32;
begin
  Result := SizeOf(TBBotCreature870Buffer);
end;

function TBBotCreatures870Mock.GetCreatureBufferCount: BUInt32;
begin
  Result := TibiaCreatureListSize;
end;

procedure TBBotCreatures870Mock.Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32);
begin
  Move(AValue^, BPtr(BUInt32(Buffer) + GetCreatureOffset(ACreature) + AOffset)^, ASize);
end;

constructor TBBotCreatures870Mock.Create;
var
  Creature, Player, Target: PBBotCreature870Buffer;
  I: BUInt32;
  Add: TCreatureIter;
  BufferList: PBBotCreatureList870Buffer;
begin
  inherited Create;
  New(BufferList);
  Buffer := BufferList;
  for I := 0 to GetCreatureBufferCount - 1 do begin
    Add := CreatureList.Add;
    Add^.First := False;
    Add^.Second := TBBotCreature870.Create(I, @BufferList[I], Self);
  end;
  Player := @BufferList[2];
  Creature := @BufferList[BRandom(GetCreatureBufferCount)];
  Target := @BufferList[0];
  Player^.ID := MockSelfID;
  Player^.Name := 'Hello Player';
  Player^.X := 320;
  Player^.Y := 420;
  Player^.Z := 7;
  Player^.Direction := Ord(tdNorth);
  Player^.HP := 100;
  Player^.Speed := 200;
  Player^.IsVisible := 1;
  Player^.Skull := Ord(SkullWhite);
  Player^.Party := Ord(PartyIDLeaderShared);
  Creature^ := Player^;
  Creature^.ID := BRandom(10000);
  Inc(Creature^.X, 2);
  Inc(Creature^.Y, 2);
  Creature^.HP := 50;
  Creature.Skull := 0;
  Creature.Party := 0;
  Creature.IsVisible := 0;
  Target^ := Player^;
  Target^.ID := MockTargetID;
  Inc(Target^.X, 3);
  Inc(Target^.Y, 1);
end;

destructor TBBotCreatures870Mock.Destroy;
begin
  Dispose(PBBotCreatureList870Buffer(Buffer));
  inherited;
end;

{ BCreatures870TestCase }

procedure BCreatures870TestCase.SetUp;
begin
  Creatures := TBBotCreatures870Mock.Create;
  Creatures.Reload;
end;

procedure BCreatures870TestCase.TearDown;
begin
  Creatures.Free;
end;

procedure BCreatures870TestCase.TestCreatureCount;
var
  Count: BUInt32;
begin
  Count := 0;
  Creatures.Traverse(
    procedure(It: TBBotCreature)
    begin
      Inc(Count);
    end);
  CheckEquals(2, Count);
end;

procedure BCreatures870TestCase.TestTarget;
begin
  Check(Creatures.Target <> nil);
end;

procedure BCreatures870TestCase.TestSelf;
begin
  Check(Creatures.Player <> nil);
end;

procedure BCreatures870TestCase.TestTargetDistance;
begin
  Check(Creatures.Player <> nil);
  Check(Creatures.Target <> nil);
  CheckEquals(3, Creatures.Target.DistanceTo(Creatures.Player.Position));
end;

procedure BCreatures870TestCase.TestSelfLight;
begin
  Check(Creatures.Player <> nil);

  Creatures.Player.LightIntensity := 0;
  Creatures.Player.LightColor := 115;
  CheckEquals(0, Creatures.Player.LightIntensity);
  CheckEquals(115, Creatures.Player.LightColor);

  Creatures.Player.LightIntensity := 5;
  Creatures.Player.LightColor := 215;
  CheckEquals(5, Creatures.Player.LightIntensity);
  CheckEquals(215, Creatures.Player.LightColor);
end;

procedure BCreatures870TestCase.TestSelfOutfit;
var
  Outfit: TTibiaOutfit;
begin
  Check(Creatures.Player <> nil);

  Outfit.Outfit := 30;
  Outfit.HeadColor := 35;
  Outfit.BodyColor := 40;
  Outfit.LegsColor := 45;
  Outfit.FeetColor := 50;
  Outfit.Addons := 55;
  Outfit.Mount := 60;

  Creatures.Player.Outfit := Outfit;
  CheckEquals(30, Creatures.Player.Outfit.Outfit);
  CheckEquals(35, Creatures.Player.Outfit.HeadColor);
  CheckEquals(40, Creatures.Player.Outfit.BodyColor);
  CheckEquals(45, Creatures.Player.Outfit.LegsColor);
  CheckEquals(50, Creatures.Player.Outfit.FeetColor);
  CheckEquals(55, Creatures.Player.Outfit.Addons);
  CheckEquals(60, Creatures.Player.Outfit.Mount);
end;

procedure BCreatures870TestCase.TestSelfWalking;
begin
  Check(Creatures.Player <> nil);
  Creatures.Player.Walking := False;
  CheckFalse(Creatures.Player.Walking);

  Creatures.Player.Walking := True;
  CheckTrue(Creatures.Player.Walking);
end;

initialization

TestFramework.RegisterTest('BCreatures870', BCreatures870TestCase.Suite);
{$ENDIF}

end.
