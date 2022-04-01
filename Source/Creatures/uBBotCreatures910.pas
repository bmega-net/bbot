unit uBBotCreatures910;

interface

uses
  uBTypes,
  uTibiaDeclarations,
  uBBotCreatures,
  Windows,
  uBattlelist;

type
  TBBotCreatures910 = class(TBBotCreatures)
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
  TBBotCreature910Buffer = record
    ID: BUInt32;
    Name: BStr32;
    X: BInt32;
    Y: BInt32;
    Z: BInt32;
    ScreenX: BInt32;
    ScreenY: BInt32;
    _U1: array [0 .. 4] of BInt32;
    Walking: BInt32;
    LastStepDirection: BInt32;
    Direction: BInt32;
    _U2: array [0 .. 1] of BInt32;
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
    IsBlock: BInt32;
    War: BInt32;
    _U5: BInt32;
  end;

  PBBotCreature910Buffer = ^TBBotCreature910Buffer;

  TBBotCreatureList910Buffer = array [0 .. TibiaCreatureListSize - 1] of TBBotCreature910Buffer;
  PBBotCreatureList910Buffer = ^TBBotCreatureList910Buffer;

  { TBBotCreature910 }
  TBBotCreature910 = class(TBBotCreature)
  private
    Buffer: PBBotCreature910Buffer;
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
    constructor Create(AIndex: BInt32; ABuffer: PBBotCreature910Buffer; ACreatures: TBBotCreatures);
  end;

function TBBotCreature910.GetID: BUInt32;
begin
  Result := Buffer^.ID;
end;

function TBBotCreature910.GetName: BStr;
begin
  Result := BStr(BPChar(@Buffer^.Name[0]));
end;

function TBBotCreature910.GetPosition: BPos;
begin
  Result.X := Buffer^.X;
  Result.Y := Buffer^.Y;
  Result.Z := Buffer^.Z;
end;

function TBBotCreature910.GetScreen: TPoint;
begin
  Result.X := Buffer^.ScreenX;
  Result.Y := Buffer^.ScreenY;
end;

function TBBotCreature910.GetDirection: TTibiaDirection;
begin
  if BInRange(Buffer^.Direction, Ord(tdNorth), Ord(tdNorthWest)) then
    Result := TTibiaDirection(Buffer^.Direction)
  else
    raise BException.Create('Unable to load creature direction in 910');
end;

function TBBotCreature910.GetHealth: BInt32;
begin
  Result := Buffer^.HP;
end;

function TBBotCreature910.GetSpeed: BInt32;
begin
  Result := Buffer^.Speed;
end;

function TBBotCreature910.GetSkull: TTibiaSkull;
begin
  if BInRange(Buffer^.Skull, Ord(SkullFirst), Ord(SkullLast)) then
    Result := TTibiaSkull(Buffer^.Skull)
  else
    raise BException.Create('Unable to load creature skull in 910');
end;

function TBBotCreature910.GetParty: TTibiaParty;
begin
  Result.Load(Buffer^.Party);
end;

function TBBotCreature910.GetWar: TTibiaWar;
begin

  if BInRange(Buffer^.War, Ord(WarNone), Ord(WarUnInvolved)) then
    Result := TTibiaWar(Buffer^.War)
  else
    raise BException.Create('Unable to load creature war in 910');
end;

procedure TBBotCreature910.SetLightColor(const Value: BInt32);
begin
  Creatures.Write(Index, GetOffsetLightColor, @Value, 4);
end;

procedure TBBotCreature910.SetLightIntensity(const Value: BInt32);
begin
  Creatures.Write(Index, GetOffsetLightIntensity, @Value, 4);
end;

procedure TBBotCreature910.SetOutfit(const Value: TTibiaOutfit);
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

procedure TBBotCreature910.SetWalking(const Value: BBool);
var
  IntValue: BInt32;
begin
  IntValue := BIf(Value, 1, 0);
  Creatures.Write(Index, GetOffsetWalking, @IntValue, 4);
end;

function TBBotCreature910.GetCreatureKind: TTibiaCreatureKind;
begin
  Result := CreaturePlayer;
end;

function TBBotCreature910.GetNPCKind: TTibiaNPCKind;
begin
  Result := NPCNone;
end;

constructor TBBotCreature910.Create(AIndex: BInt32; ABuffer: PBBotCreature910Buffer; ACreatures: TBBotCreatures);
begin
  inherited Create(AIndex);
  Buffer := ABuffer;
  Creatures := ACreatures;
end;

function TBBotCreature910.GetBlackSquareTime: BUInt32;
begin
  Result := Buffer^.BlackSquare;
end;

function TBBotCreature910.GetGroupOnline: BInt32;
begin
  Result := 0;
end;

function TBBotCreature910.GetSquareVisible: BBool;
begin
  Result := False;
end;

function TBBotCreature910.GetSquareRed: BInt32;
begin
  Result := 0;
end;

function TBBotCreature910.GetSquareGreen: BInt32;
begin
  Result := 0;
end;

function TBBotCreature910.GetSquareBlue: BInt32;
begin
  Result := 0;
end;

function TBBotCreature910.GetIsSelf: BBool;
begin
  Result := GetID() = Creatures.PlayerID;
end;

function TBBotCreature910.GetIsPlayer: BBool;
begin
  Result := IsPlayerID(GetID());
end;

function TBBotCreature910.GetIsNPC: BBool;
begin
  Result := not GetIsPlayer();
end;

function TBBotCreature910.GetIsTarget: BBool;
begin
  Result := GetID() = Creatures.TargetID;
end;

function TBBotCreature910.GetIsVisible: BBool;
begin
  Result := Buffer^.IsVisible = 1;
end;

function TBBotCreature910.GetWalking: BBool;
begin
  Result := Buffer^.Walking = 1;
end;

function TBBotCreature910.GetOutfit: TTibiaOutfit;
begin
  Result.Outfit := Buffer^.Outfit.Outfit;
  Result.HeadColor := Buffer^.Outfit.HeadColor;
  Result.BodyColor := Buffer^.Outfit.BodyColor;
  Result.LegsColor := Buffer^.Outfit.LegsColor;
  Result.FeetColor := Buffer^.Outfit.FeetColor;
  Result.Addons := Buffer^.Outfit.Addons;
  Result.Mount := Buffer^.Outfit.Mount;
end;

function TBBotCreature910.GetLightIntensity: BInt32;
begin
  Result := Buffer^.Light;
end;

function TBBotCreature910.GetLightColor: BInt32;
begin
  Result := Buffer^.LightColor;
end;

function TBBotCreature910.GetOffsetLightColor: BInt32;
begin
  Result := BInt32(@Buffer^.LightColor) - BInt32(@Buffer^.ID);
end;

function TBBotCreature910.GetOffsetLightIntensity: BInt32;
begin
  Result := BInt32(@Buffer^.Light) - BInt32(@Buffer^.ID);
end;

function TBBotCreature910.GetOffsetOutfit: BInt32;
begin
  Result := BInt32(@Buffer^.Outfit) - BInt32(@Buffer^.ID);
end;

function TBBotCreature910.GetOffsetWalking: BInt32;
begin
  Result := BInt32(@Buffer^.Walking) - BInt32(@Buffer^.ID);
end;

{ TTibiaCreatures910 }

procedure TBBotCreatures910.Update;
begin
  TibiaProcess.Read(TibiaAddresses.AdrBattle, GetBufferSize, Buffer);
end;

function TBBotCreatures910.GetPlayerID: BUInt32;
begin
  Result := Me.ID;
end;

function TBBotCreatures910.GetTargetID: BUInt32;
begin
  Result := Me.TargetID;
end;

function TBBotCreatures910.GetCreatureBufferSize: BUInt32;
begin
  Result := SizeOf(TBBotCreature910Buffer);
end;

function TBBotCreatures910.GetCreatureBufferCount: BUInt32;
begin
  Result := TibiaCreatureListSize;
end;

procedure TBBotCreatures910.Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32);
var
  Offset: BUInt32;
begin
  Offset := GetCreatureOffset(ACreature) + AOffset;
  Move(AValue^, BPtr(BUInt32(Buffer) + Offset)^, ASize);
  TibiaProcess.Write(BUInt32(TibiaAddresses.AdrBattle) + Offset, ASize, AValue);
end;

constructor TBBotCreatures910.Create;
var
  I: BUInt32;
  Add: TCreatureIter;
  BufferList: PBBotCreatureList910Buffer;
begin
  inherited Create;
  New(BufferList);
  Buffer := BufferList;
  for I := 0 to GetCreatureBufferCount - 1 do begin
    Add := CreatureList.Add;
    Add^.First := False;
    Add^.Second := TBBotCreature910.Create(I, @BufferList[I], Self);
  end;
end;

destructor TBBotCreatures910.Destroy;
begin
  Dispose(PBBotCreatureList910Buffer(Buffer));
  inherited;
end;

{$IFDEF TEST}

const
  MockSelfID = 1;
  MockTargetID = 2;

type
  TBBotCreatures910Mock = class(TBBotCreatures)
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

  BCreatures910TestCase = class(TTestCase)
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

  { TTibiaCreatures910Mock }

procedure TBBotCreatures910Mock.Update;
begin

end;

function TBBotCreatures910Mock.GetPlayerID: BUInt32;
begin
  Result := MockSelfID;
end;

function TBBotCreatures910Mock.GetTargetID: BUInt32;
begin
  Result := MockTargetID;
end;

function TBBotCreatures910Mock.GetCreatureBufferSize: BUInt32;
begin
  Result := SizeOf(TBBotCreature910Buffer);
end;

function TBBotCreatures910Mock.GetCreatureBufferCount: BUInt32;
begin
  Result := TibiaCreatureListSize;
end;

procedure TBBotCreatures910Mock.Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32);
begin
  Move(AValue^, BPtr(BUInt32(Buffer) + GetCreatureOffset(ACreature) + AOffset)^, ASize);
end;

constructor TBBotCreatures910Mock.Create;
var
  Creature, Player, Target: PBBotCreature910Buffer;
  I: BUInt32;
  Add: TCreatureIter;
  BufferList: PBBotCreatureList910Buffer;
begin
  inherited Create;
  New(BufferList);
  Buffer := BufferList;
  for I := 0 to GetCreatureBufferCount - 1 do begin
    Add := CreatureList.Add;
    Add^.First := False;
    Add^.Second := TBBotCreature910.Create(I, @BufferList[I], Self);
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

destructor TBBotCreatures910Mock.Destroy;
begin
  Dispose(PBBotCreatureList910Buffer(Buffer));
  inherited;
end;

{ BCreatures910TestCase }

procedure BCreatures910TestCase.SetUp;
begin
  Creatures := TBBotCreatures910Mock.Create;
  Creatures.Reload;
end;

procedure BCreatures910TestCase.TearDown;
begin
  Creatures.Free;
end;

procedure BCreatures910TestCase.TestCreatureCount;
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

procedure BCreatures910TestCase.TestTarget;
begin
  Check(Creatures.Target <> nil);
end;

procedure BCreatures910TestCase.TestSelf;
begin
  Check(Creatures.Player <> nil);
end;

procedure BCreatures910TestCase.TestTargetDistance;
begin
  Check(Creatures.Player <> nil);
  Check(Creatures.Target <> nil);
  CheckEquals(3, Creatures.Target.DistanceTo(Creatures.Player.Position));
end;

procedure BCreatures910TestCase.TestSelfLight;
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

procedure BCreatures910TestCase.TestSelfOutfit;
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

procedure BCreatures910TestCase.TestSelfWalking;
begin
  Check(Creatures.Player <> nil);
  Creatures.Player.Walking := False;
  CheckFalse(Creatures.Player.Walking);

  Creatures.Player.Walking := True;
  CheckTrue(Creatures.Player.Walking);
end;

initialization

TestFramework.RegisterTest('BCreatures910', BCreatures910TestCase.Suite);
{$ENDIF}

end.
