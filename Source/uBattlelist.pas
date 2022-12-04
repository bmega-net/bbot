unit uBattlelist;

interface

uses
  uBTypes,
  Declaracoes,
  Windows,
  Math,
  SysUtils,
  Classes,
  uTibiaDeclarations,
  uBBotWalkerPathFinderCreature;

type
  TBBotCreature = class
  private type
    TAllyEnemyData = record
      ID: BUInt32;
      Version: BInt32;
      Enemy: BBool;
      Ally: BBool;
    end;
  private
    _AllyEnemy: TAllyEnemyData;
    _KillSteal: BLock;
    FIndex: BInt32;
    procedure SetAllyEnemy;
    function GetIsKillSteal: BBool;
    procedure SetIsKillSteal(const Value: BBool);
    function GetLevel: BInt32;
  protected
    function GetID: BUInt32; virtual; abstract;
    function GetName: BStr; virtual; abstract;
    function GetPosition: BPos; virtual; abstract;
    function GetScreen: TPoint; virtual; abstract;
    function GetDirection: TTibiaDirection; virtual; abstract;
    function GetHealth: BInt32; virtual; abstract;
    function GetSpeed: BInt32; virtual; abstract;
    function GetSkull: TTibiaSkull; virtual; abstract;
    function GetParty: TTibiaParty; virtual; abstract;
    function GetWar: TTibiaWar; virtual; abstract;
    function GetCreatureKind: TTibiaCreatureKind; virtual; abstract;
    function GetNPCKind: TTibiaNPCKind; virtual; abstract;
    function GetBlackSquareTime: BUInt32; virtual; abstract;
    function GetGroupOnline: BInt32; virtual; abstract;
    function GetSquareVisible: BBool; virtual; abstract;
    function GetSquareRed: BInt32; virtual; abstract;
    function GetSquareGreen: BInt32; virtual; abstract;
    function GetSquareBlue: BInt32; virtual; abstract;
    function GetIsSelf: BBool; virtual; abstract;
    function GetIsPlayer: BBool; virtual; abstract;
    function GetIsNPC: BBool; virtual; abstract;
    function GetIsTarget: BBool; virtual; abstract;
    function GetIsVisible: BBool; virtual; abstract;
    function GetWalking: BBool; virtual; abstract;
    function GetOutfit: TTibiaOutfit; virtual; abstract;
    function GetLightIntensity: BInt32; virtual; abstract;
    function GetLightColor: BInt32; virtual; abstract;

    function GetOffsetLightColor: BInt32; virtual; abstract;
    function GetOffsetLightIntensity: BInt32; virtual; abstract;
    function GetOffsetOutfit: BInt32; virtual; abstract;
    function GetOffsetWalking: BInt32; virtual; abstract;

    procedure SetLightColor(const Value: BInt32); virtual; abstract;
    procedure SetLightIntensity(const Value: BInt32); virtual; abstract;
    procedure SetOutfit(const Value: TTibiaOutfit); virtual; abstract;
    procedure SetWalking(const Value: BBool); virtual; abstract;
  public
    constructor Create(AIndex: BInt32);
    destructor Destroy; override;

    property Index: BInt32 read FIndex;

    procedure ShootOn(ShootObject: BInt32);
    procedure Follow;
    procedure SuperFollow;
    procedure KeepDistance(ADistance: BInt32);
    procedure KeepDiagonal;
    procedure Attack;

    function IsDeath: BBool;
    function IsAlive: BBool;
    function IsReachable: BBool;
    function IsOnScreen: BBool;
    function IsEnemy: BBool;
    function IsAlly: BBool;
    function DistanceTo(ToPos: BPos): BInt32;

    property ID: BUInt32 read GetID;
    property Name: BStr read GetName;
    property Position: BPos read GetPosition;
    property Screen: TPoint read GetScreen;
    property Direction: TTibiaDirection read GetDirection;
    property Health: BInt32 read GetHealth;
    property Speed: BInt32 read GetSpeed;
    property Skull: TTibiaSkull read GetSkull;
    property Party: TTibiaParty read GetParty;
    property War: TTibiaWar read GetWar;
    property CreatureKind: TTibiaCreatureKind read GetCreatureKind;
    property NPCKind: TTibiaNPCKind read GetNPCKind;
    property BlackSquareTime: BUInt32 read GetBlackSquareTime;

    property GroupOnline: BInt32 read GetGroupOnline;
    property SquareVisible: BBool read GetSquareVisible;
    property SquareRed: BInt32 read GetSquareRed;
    property SquareGreen: BInt32 read GetSquareGreen;
    property SquareBlue: BInt32 read GetSquareBlue;

    property IsSelf: BBool read GetIsSelf;
    property IsPlayer: BBool read GetIsPlayer;
    property IsNPC: BBool read GetIsNPC;
    property IsTarget: BBool read GetIsTarget;
    property IsVisible: BBool read GetIsVisible;

    property Walking: BBool read GetWalking write SetWalking;
    property Outfit: TTibiaOutfit read GetOutfit write SetOutfit;
    property LightIntensity: BInt32 read GetLightIntensity
      write SetLightIntensity;
    property LightColor: BInt32 read GetLightColor write SetLightColor;

    property Level: BInt32 read GetLevel;

    property IsKillSteal: BBool read GetIsKillSteal write SetIsKillSteal;
  end;

implementation

uses
  BBotEngine,
  uSelf,

  uTibia,
  uBBotAddresses,
  uTibiaState,
  uDistance,
  uBBotWalkerDistancerTask;

{ TBBotCreature }

procedure TBBotCreature.Attack;
begin
  BBot.PacketSender.Attack(ID);
  BBot.ConfirmAttack.StartFor(ID);
  BBot.Walker.Stop;
end;

constructor TBBotCreature.Create(AIndex: BInt32);
begin
  _KillSteal := BLock.Create(5000, 20);
  FIndex := AIndex;
  _AllyEnemy.Version := 0;
  _AllyEnemy.ID := 0;
  _AllyEnemy.Enemy := False;
  _AllyEnemy.Ally := False;
end;

function TBBotCreature.DistanceTo(ToPos: BPos): BInt32;
begin
  Result := DistanceBetween(ToPos, Position);
end;

procedure TBBotCreature.Follow;
begin
  KeepDistance(1);
end;

function TBBotCreature.GetIsKillSteal: BBool;
begin
  if _KillSteal.Locked then
    Exit(True);
  if Health = 100 then
    Exit(False)
  else
    Result := BBot.Creatures.Has(
      function(Creature: TBBotCreature): BBool
      begin
        if Creature.IsPlayer and (not Creature.IsSelf) and Creature.IsAlive and
          (Creature.DistanceTo(Position) < 2) then
          Exit(True);
        Result := False;
      end);
end;

function TBBotCreature.GetLevel: BInt32;
begin
  if AdrSelected < TibiaVer980 then
    // BaseSpeed: 220 + (2 * (Me.Level - 1))
    Result := Max((Speed - 218) div 2, 1)
  else
    // BaseSpeed: 109 + Level
    Result := Max(Speed - 109, 1);
end;

procedure TBBotCreature.ShootOn(ShootObject: BInt32);
begin
  Tibia.Shoot(ShootObject, ID);
end;

procedure TBBotCreature.SuperFollow;
begin
  BBot.SuperFollow.SuperFollow(ID);
  if Me.Position.Z = Position.Z then
  begin
    Follow
  end
  else
  begin
    if Me.DistanceTo(BPosXYZ(Position.X, Position.Y, Me.Position.Z)) < 5 then
      if Me.Position.Z > Position.Z then
        BBot.Cavebot.GoFloorUp(Position)
      else
        BBot.Cavebot.GoFloorDown(Position)
  end;
end;

function TBBotCreature.IsReachable: BBool;
begin
  Result := IsVisible and (Position.Z = Me.Position.Z) and
    ((Me.DistanceTo(Self) <= 1) or BInRange(BBot.Walker.ApproachToCost(Position,
    10), 0, 10));
end;

procedure TBBotCreature.KeepDiagonal;
begin
  BBot.AvoidWaves.EnableForID := ID;
end;

procedure TBBotCreature.KeepDistance(ADistance: BInt32);
var
  Path: TBBotPathFinderCreature;
  CurrentDistance: BInt32;
begin
  CurrentDistance := Me.DistanceTo(Self);
  if CurrentDistance <> ADistance then
    if BBot.Walker.Task = nil then
    begin
      Path := TBBotPathFinderCreature.Create('KeepDistance from <' + Name +
        '> distance: ' + BToStr(ADistance));
      Path.Creature := ID;
      if CurrentDistance < ADistance then
        Path.Distance := BMax(ADistance, 5)
      else
        Path.Distance := ADistance;
      Path.Execute;
      if Path.Cost <> PathCost_NotPossible then
      begin
        BBot.Walker.Task := TBBotCreatureDistancerTask.Create(ID,
          ADistance, Path);
      end
      else
        Path.Free;
    end;
end;

function TBBotCreature.IsOnScreen: BBool;
begin
  Result := Me.CanSee(GetPosition);
end;

function TBBotCreature.IsDeath: BBool;
begin
  Result := GetHealth = 0;
end;

destructor TBBotCreature.Destroy;
begin
  _KillSteal.Free;
  inherited;
end;

function TBBotCreature.IsAlive: BBool;
begin
  Result := (GetHealth > 0) and (IsVisible);
end;

function TBBotCreature.IsAlly: BBool;
begin
  SetAllyEnemy;
  Result := _AllyEnemy.Ally;
end;

function TBBotCreature.IsEnemy: BBool;
begin
  SetAllyEnemy;
  Result := _AllyEnemy.Enemy;
end;

procedure TBBotCreature.SetAllyEnemy;
begin
  if (_AllyEnemy.Version <> BBot.WarBot.AlliesEnemiesVersion) or
    (_AllyEnemy.ID <> ID) then
  begin
    _AllyEnemy.Version := BBot.WarBot.AlliesEnemiesVersion;
    _AllyEnemy.ID := ID;
    _AllyEnemy.Ally := BBot.WarBot.IsAlly(Name) or IsSelf;
    _AllyEnemy.Enemy := BBot.WarBot.IsEnemy(Name);
  end;
end;

procedure TBBotCreature.SetIsKillSteal(const Value: BBool);
begin
  _KillSteal.Lock;
end;

end.

