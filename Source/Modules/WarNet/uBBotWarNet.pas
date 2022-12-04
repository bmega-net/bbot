unit uBBotWarNet;

interface

uses
  uBTypes,
  uBBotWarBot,
  uBotPacket,
  Classes,
  uBVector,
  uBBotAction,
  Math,
  uTibiaDeclarations,
  uBBotSpells,
  uBBotTCPSocket;

type
  TBBotWarNetRoomStatus = (bwnrsNone, bwnrsWrongPassword, bwnrsUnavailable,
    bwnrsInvalidName, bwnrsRoomNotFound, bwnrsAuthenticated);

  TBBotWarNetSignal = class
  private
    FColor: BInt32;
    FPosition: BPos;
    FName: BStr;
    SpawnTime: BUInt32;
    FDuration: BUInt32;
  public
    constructor Create;

    property Position: BPos read FPosition write FPosition;
    property Color: BInt32 read FColor write FColor;
    property Name: BStr read FName write FName;
    property Duration: BUInt32 read FDuration write FDuration;

    function Alive: BBool;
    procedure Spawn;

    procedure HUD;
  end;

  TBBotWarNetPlayer = class
  private
    FName: BStr;
    FID: BUInt32;
    FHP: BInt32;
    FHPMax: BInt32;
    FPosition: BPos;
    FMana: BInt32;
    FManaMax: BInt32;
    FLeader: BBool;
    FLastUpdated: BUInt32;
    FSignals: BVector<TBBotWarNetSignal>;
  public
    constructor Create;
    destructor Destroy; override;

    property Signals: BVector<TBBotWarNetSignal> read FSignals;

    property ID: BUInt32 read FID write FID;
    property Name: BStr read FName write FName;
    property HP: BInt32 read FHP write FHP;
    property HPMax: BInt32 read FHPMax write FHPMax;
    property Mana: BInt32 read FMana write FMana;
    property ManaMax: BInt32 read FManaMax write FManaMax;
    property Position: BPos read FPosition write FPosition;
    property Leader: BBool read FLeader write FLeader;
    property LastUpdated: BUInt32 read FLastUpdated;

    procedure Updated;
    function Expired: BBool;
    procedure HUD;
  end;

  TBBotWarNet = class;

  TBBotWarNetAction = class(TBBotRunnable)
  private
    FWarNet: TBBotWarNet;
  public
    constructor Create(AWarNet: TBBotWarNet);

    property WarNet: TBBotWarNet read FWarNet;
  end;

  TBBotWarNetActionSignal = class(TBBotWarNetAction)
  private
    FName: BStr;
    FColor: BInt32;
    FDuration: BUInt32;
  public
    constructor Create(AWarNet: TBBotWarNet);

    property Color: BInt32 read FColor write FColor;
    property Name: BStr read FName write FName;
    property Duration: BUInt32 read FDuration write FDuration;

    procedure Run; override;
  end;

  TBBotWarNetActionCombo = class(TBBotWarNetAction)
  private
    FName: BStr;
  public
    constructor Create(AWarNet: TBBotWarNet);

    property Name: BStr read FName write FName;

    procedure Run; override;
  end;

  TBBotWarNetActionTrigger = class
  private
    FAction: TBBotWarNetAction;
  public
    constructor Create(AAction: TBBotWarNetAction);
    destructor Destroy; override;

    property Action: TBBotWarNetAction read FAction;
  end;

  TBBotWarNetActionTriggerKey = class(TBBotWarNetActionTrigger)
  private
    FKey: BInt16;
    FShift: TShiftState;
  public
    constructor Create(AAction: TBBotWarNetAction; AKey: BInt16;
      AShift: TShiftState);

    property Key: BInt16 read FKey;
    property Shift: TShiftState read FShift;

    procedure OnHotkey;
  end;

  TBBotWarNetActionTriggerSay = class(TBBotWarNetActionTrigger)
  private
    FKeyword: BStr;
  public
    constructor Create(AAction: TBBotWarNetAction; AKeyword: BStr);

    property Keyword: BStr read FKeyword;

    procedure OnSay(AText: BStr);
  end;

  TBBotWarNetActionTriggerShoot = class(TBBotWarNetActionTrigger)
  private
    FItem: BInt32;
  public
    constructor Create(AAction: TBBotWarNetAction; AItem: BInt32);

    property Item: BInt32 read FItem;

    procedure OnShoot(AItem: BInt32);
  end;

  TBBotWarNet = class(TBBotAction)
  private
    FPassword: BStr;
    FRoom: BStr;
    FRoomStatus: TBBotWarNetRoomStatus;
    FLeaderPassword: BStr;
    FImLeader: BBool;
    FComboShootItems: BBool;
    FConnected: BBool;
    FPort: BInt32;
    FIP: BStr;
    function GetState: TBBotTCPSocket.TBBotTCPSocketState;
    function GetSockError: BInt32;
  protected
    Sock: TBBotTCPSocket;
    NextStatus: BLock;
    NextHello: BLock;
    ComboIgnoreNextPos: BBool;
    Players: BVector<TBBotWarNetPlayer>;
    SayActions: BVector<TBBotWarNetActionTriggerSay>;
    ShootActions: BVector<TBBotWarNetActionTriggerShoot>;
    KeyActions: BVector<TBBotWarNetActionTriggerKey>;
    procedure Send(APacket: TBBotPacket);
    procedure Read;
    procedure HUD;
    procedure ReadServerRemove(Packet: TBBotPacket);
    procedure ReadServerAdd(Packet: TBBotPacket);
    procedure ReadServerStatus(Packet: TBBotPacket);
    procedure ReadServerComboTarget(Packet: TBBotPacket);
    procedure ReadServerComboPos(Packet: TBBotPacket);
    procedure ReadServerSignal(Packet: TBBotPacket);
  public
    constructor Create(AWarBot: TBBotWarBot);
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    property IP: BStr read FIP write FIP;
    property Port: BInt32 read FPort write FPort;
    property Connected: BBool read FConnected write FConnected;

    property Room: BStr read FRoom write FRoom;
    property Password: BStr read FPassword write FPassword;
    property LeaderPassword: BStr read FLeaderPassword write FLeaderPassword;
    property RoomStatus: TBBotWarNetRoomStatus read FRoomStatus;

    property ImLeader: BBool read FImLeader;
    property ComboShootItems: BBool read FComboShootItems
      write FComboShootItems;

    property State: TBBotTCPSocket.TBBotTCPSocketState read GetState;
    property SockError: BInt32 read GetSockError;

    procedure Signal(ASignalName: BStr; ASignalColor, ASignalDuration: BInt32);
    procedure ComboTarget(ACombo: BStr);
    procedure ComboPos(AItem: BInt32; APosition: BPos);
    procedure Status();
    procedure Hello();
    procedure RoomCreate();
    procedure RoomJoin();

    procedure LoadActions(const AActions: TStrings);

    procedure OnHotkey;
    procedure OnUseOnItem(It: TTibiaUseOnItem);
    procedure OnUseOnCreature(It: TTibiaUseOnCreature);
    procedure OnSay(It: TTibiaMessage);
  end;

implementation

uses
  BBotEngine,

  Declaracoes,
  Windows,
  uHUD,
  uDistance,

  uBBotAttackSequence,
  uItem,
  uContainer,
  uTiles,
  uBBotEvents,
  SysUtils,
  uBattlelist,
  uBBotWarNetProtocol;

const
  STATUS_HUD_EXPIRE = 4000;
  STATUS_PLAYER_EXPIRE = 6000;

  { TBBotWarNet }

constructor TBBotWarNet.Create(AWarBot: TBBotWarBot);
begin
  inherited Create('WarNet', 300);
  Sock := TBBotTCPSocket.Create;
  FIP := '';
  FPort := 0;
  FConnected := False;
  Players := BVector<TBBotWarNetPlayer>.Create(
    procedure(It: BVector<TBBotWarNetPlayer>.It)
    begin
      It^.Free;
    end);
  SayActions := BVector<TBBotWarNetActionTriggerSay>.Create(
    procedure(It: BVector<TBBotWarNetActionTriggerSay>.It)
    begin
      It^.Free;
    end);
  ShootActions := BVector<TBBotWarNetActionTriggerShoot>.Create(
    procedure(It: BVector<TBBotWarNetActionTriggerShoot>.It)
    begin
      It^.Free;
    end);
  KeyActions := BVector<TBBotWarNetActionTriggerKey>.Create(
    procedure(It: BVector<TBBotWarNetActionTriggerKey>.It)
    begin
      It^.Free;
    end);
  NextStatus := BLock.Create(600, 0);
  NextHello := BLock.Create(1600, 0);
  ComboIgnoreNextPos := False;
  FRoomStatus := bwnrsNone;
  FRoom := '';
  FPassword := '';
  FLeaderPassword := '';
  FImLeader := False;
  FComboShootItems := False;
end;

destructor TBBotWarNet.Destroy;
begin
  Sock.Free;
  NextStatus.Free;
  NextHello.Free;
  Players.Free;
  SayActions.Free;
  ShootActions.Free;
  KeyActions.Free;
  inherited;
end;

function TBBotWarNet.GetSockError: BInt32;
begin
  Result := Sock.Error;
end;

function TBBotWarNet.GetState: TBBotTCPSocket.TBBotTCPSocketState;
begin
  Result := Sock.State;
end;

procedure TBBotWarNet.Hello;
var
  Packet: TBBotPacket;
begin
  if (FRoomStatus <> bwnrsAuthenticated) and (not NextHello.Locked) then
  begin
    NextHello.Lock;
    Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
    Packet.WriteBInt8(CMD_CLIENT_HELLO);
    Send(Packet);
    Packet.Free;
  end;
end;

procedure TBBotWarNet.HUD;
begin
  HUDRemoveGroup(bhgBBotNET);
  Players.Delete(
    function(It: BVector<TBBotWarNetPlayer>.It): BBool
    begin
      Result := It^.Expired;
      if not Result then
        It^.HUD;
    end);
end;

procedure TBBotWarNet.LoadActions(const AActions: TStrings);
var
  Action: TBBotWarNetAction;
  Signal: TBBotWarNetActionSignal;
  Combo: TBBotWarNetActionCombo;
  R: BStrArray;
  I: BInt32;
  K: BPair<BInt16, TShiftState>;
begin
  KeyActions.Clear;
  SayActions.Clear;
  ShootActions.Clear;
  for I := 0 to AActions.Count - 1 do
    if BStrSplit(R, '@@', AActions[I]) > 3 then
    begin
      if R[2] = 'Signal' then
      begin
        Signal := TBBotWarNetActionSignal.Create(Self);
        Action := Signal;
        Signal.Name := R[3];
        Signal.Duration := BStrTo32(R[4], 1000);
        Signal.Color := BStrTo32(R[5], $FFFFFF);
      end
      else if R[2] = 'Combo' then
      begin
        Combo := TBBotWarNetActionCombo.Create(Self);
        Action := Combo;
        Combo.Name := R[3];
      end
      else
        raise Exception.Create('Invalid WarNet action: ' + AActions[I]);
      if R[0] = 'Key' then
      begin
        K := StrToKey(R[1]);
        KeyActions.Add(TBBotWarNetActionTriggerKey.Create(Action, K.First,
          K.Second));
      end
      else if R[0] = 'Say' then
      begin
        SayActions.Add(TBBotWarNetActionTriggerSay.Create(Action, R[1]));
      end
      else if R[0] = 'Shoot' then
      begin
        ShootActions.Add(TBBotWarNetActionTriggerShoot.Create(Action,
          BStrTo32(R[1])));
      end
      else
        raise Exception.Create('Invalid WarNet trigger: ' + AActions[I]);
    end;
end;

procedure TBBotWarNet.OnHotkey;
begin
  KeyActions.ForEach(
    procedure(IIt: BVector<TBBotWarNetActionTriggerKey>.It)
    begin
      IIt^.OnHotkey;
    end);
end;

procedure TBBotWarNet.OnInit;
begin
  inherited;
  BBot.Events.OnHotkey.Add(OnHotkey);
  BBot.Events.OnUseOnItem.Add(OnUseOnItem);
  BBot.Events.OnUseOnCreature.Add(OnUseOnCreature);
  BBot.Events.OnSay.Add(OnSay);
end;

procedure TBBotWarNet.OnSay(It: TTibiaMessage);
begin
  SayActions.ForEach(
    procedure(IIt: BVector<TBBotWarNetActionTriggerSay>.It)
    begin
      IIt^.OnSay(It.Text);
    end);
end;

procedure TBBotWarNet.OnUseOnCreature(It: TTibiaUseOnCreature);
begin
  ShootActions.ForEach(
    procedure(IIt: BVector<TBBotWarNetActionTriggerShoot>.It)
    begin
      IIt^.OnShoot(It.ItemID);
    end);
end;

procedure TBBotWarNet.OnUseOnItem(It: TTibiaUseOnItem);
begin
  if ComboShootItems then
    ComboPos(It.FromID, It.ToPosition);
  ShootActions.ForEach(
    procedure(IIt: BVector<TBBotWarNetActionTriggerShoot>.It)
    begin
      IIt^.OnShoot(It.FromID);
    end);
end;

procedure TBBotWarNet.Read;
var
  Packet: TBBotPacket;
  CMD: BInt8;
begin
  Packet := Sock.Recv;
  while Packet <> nil do
  begin
    CMD := Packet.GetBInt8;
    case CMD of
      CMD_SERVER_HELLO:
        begin
          FRoomStatus := bwnrsNone;
          NextHello.Lock;
          if LeaderPassword = '' then
            RoomJoin
          else
            RoomCreate;
        end;
      CMD_SERVER_ROOM_CREATED:
        begin
          FRoomStatus := bwnrsAuthenticated;
          FImLeader := True;
          NextStatus.Delay := BUInt32(Packet.GetBInt32());
        end;
      CMD_SERVER_ROOM_JOINED:
        begin
          FRoomStatus := bwnrsAuthenticated;
          FImLeader := Packet.GetBInt8() = 1;
          NextStatus.Delay := BUInt32(Packet.GetBInt32());
        end;
      CMD_SERVER_ROOM_UNAVAILABLE:
        begin
          FRoomStatus := bwnrsUnavailable;
          Sock.Disconnect;
        end;
      CMD_SERVER_ROOM_INVALID_NAME:
        begin
          FRoomStatus := bwnrsInvalidName;
          Sock.Disconnect;
        end;
      CMD_SERVER_ROOM_NOT_FOUND:
        begin
          FRoomStatus := bwnrsRoomNotFound;
          Sock.Disconnect;
        end;
      CMD_SERVER_ROOM_WRONG_PASSWORD:
        begin
          FRoomStatus := bwnrsWrongPassword;
          Sock.Disconnect;
        end;
    end;
    if FRoomStatus = bwnrsAuthenticated then
    begin
      case CMD of
        CMD_SERVER_REMOVE:
          ReadServerRemove(Packet);
        CMD_SERVER_ADD:
          ReadServerAdd(Packet);
        CMD_SERVER_STATUS:
          ReadServerStatus(Packet);
        CMD_SERVER_COMBO_TARGET:
          ReadServerComboTarget(Packet);
        CMD_SERVER_COMBO_POS:
          ReadServerComboPos(Packet);
        CMD_SERVER_SIGNAL:
          ReadServerSignal(Packet);
        CMD_SERVER_STATUS_RECEIVED:
          ;
      end;
    end;
    Packet.Free;
    Packet := Sock.Recv;
  end;
end;

procedure TBBotWarNet.ReadServerAdd(Packet: TBBotPacket);
var
  HUD: TBBotHUD;
begin
  HUD := TBBotHUD.Create(bhgBBotNETStatus);
  HUD.AlignTo(bhaCenter, bhaBottom);
  HUD.Expire := STATUS_HUD_EXPIRE;
  HUD.Color := RGB(250, 200, 200);
  HUD.Text := BFormat('%s: entered the room', [Packet.GetBStr16()]);
  if Packet.GetBInt8() = 1 then
    HUD.Text := HUD.Text + ' [LEADER]';
  HUD.Print;
  HUD.Free;
end;

procedure TBBotWarNet.ReadServerComboPos(Packet: TBBotPacket);
var
  ItemID: BInt32;
  Vertical: BBool;
  TargetCenter, Target: BPos;
  Map: TTibiaTiles;
begin
  ItemID := Packet.GetBInt32();
  TargetCenter.X := Packet.GetBInt32();
  TargetCenter.Y := Packet.GetBInt32();
  TargetCenter.Z := Packet.GetBInt8();
  Vertical := Packet.GetBInt8() = 1;
  if Me.CanSee(TargetCenter) then
    if ContainerFind(ItemID) <> nil then
    begin
      Target := TargetCenter;
      repeat
        if Vertical then
          Target.X := TargetCenter.X + BRandom(-2, 2)
        else
          Target.Y := TargetCenter.Y + BRandom(-2, 2);
      until Me.CanSee(Target);
      if Tiles(Map, Target.X, Target.Y) then
        if Map.Shootable and Map.Walkable then
        begin
          ComboIgnoreNextPos := True;
          Map.UseOn(ItemID);
        end;
    end;
end;

procedure TBBotWarNet.ReadServerComboTarget(Packet: TBBotPacket);
var
  Combo: BStr;
  TargetID: BUInt32;
  TargetCreature: TBBotCreature;
  Atk: TBBotAttackSequence;
  HUD: TBBotHUD;
begin
  Combo := Packet.GetBStr16();
  TargetID := BUInt32(Packet.GetBInt32());
  if Me.TargetID <> TargetID then
  begin
    TargetCreature := BBot.Creatures.Find(TargetID);
    if (TargetCreature <> nil) and TargetCreature.IsOnScreen then
      TargetCreature.Attack;
  end;
  if BBot.Creatures.Target <> nil then
  begin
    Atk := BBot.AdvAttack.GetAttackSequenceByName(Combo);
    if Atk <> nil then
      Atk.InstantlyExecute
    else
    begin
      HUD := TBBotHUD.Create(bhgBBotNETStatus);
      HUD.AlignTo(bhaCenter, bhaBottom);
      HUD.Expire := 3000;
      HUD.Color := $FFC000;
      HUD.Text := BFormat('Combo not found: %s on %s',
        [Combo, BBot.Creatures.Target.Name]);
      HUD.Print;
      HUD.Free;
    end;
  end;
end;

procedure TBBotWarNet.ReadServerRemove(Packet: TBBotPacket);
var
  HUD: TBBotHUD;
begin
  HUD := TBBotHUD.Create(bhgBBotNETStatus);
  HUD.AlignTo(bhaCenter, bhaBottom);
  HUD.Expire := STATUS_HUD_EXPIRE;
  HUD.Color := RGB(250, 200, 200);
  HUD.Text := BFormat('%s: left the room', [Packet.GetBStr16()]);
  HUD.Print;
  HUD.Free;
end;

procedure TBBotWarNet.ReadServerSignal(Packet: TBBotPacket);
var
  Player: BVector<TBBotWarNetPlayer>.It;
  Signal: BVector<TBBotWarNetSignal>.It;
  Name: BStr;
  ID: BUInt32;
  Color, Duration: BInt32;
  Position: BPos;
begin
  ID := BUInt32(Packet.GetBInt32);
  Name := Packet.GetBStr16;
  Color := Packet.GetBInt32;
  Duration := Packet.GetBInt32;
  Position.X := Packet.GetBInt32;
  Position.Y := Packet.GetBInt32;
  Position.Z := Packet.GetBInt8;
  Player := Players.Find('Warnet - Read Server Signal',
    function(It: BVector<TBBotWarNetPlayer>.It): BBool
    begin
      Result := It^.ID = ID;
    end);
  if Player <> nil then
  begin
    Signal := Player^.Signals.Find('Warnet - Update player ' + Player.Name,
      function(It: BVector<TBBotWarNetSignal>.It): BBool
      begin
        Result := It^.Name = Name;
      end);
    if Signal = nil then
      Signal := Player^.Signals.Add(TBBotWarNetSignal.Create());
    Signal^.Name := Name;
    Signal^.Color := Color;
    Signal^.Duration := Duration;
    Signal^.Position := Position;
    Signal^.Spawn;
  end;
end;

procedure TBBotWarNet.ReadServerStatus(Packet: TBBotPacket);
var
  Player: BVector<TBBotWarNetPlayer>.It;
  ID: BUInt32;
  Position: BPos;
begin
  ID := BUInt32(Packet.GetBInt32);
  Player := Players.Find('Warnet - read server status - find by id',
    function(It: BVector<TBBotWarNetPlayer>.It): BBool
    begin
      Result := It^.ID = ID;
    end);
  if Player = nil then
    Player := Players.Add(TBBotWarNetPlayer.Create);
  Player^.ID := ID;
  Player^.Name := Packet.GetBStr16;
  Player^.HP := Packet.GetBInt32;
  Player^.HPMax := Packet.GetBInt32;
  Player^.Mana := Packet.GetBInt32;
  Player^.ManaMax := Packet.GetBInt32;
  Position.X := Packet.GetBInt32();
  Position.Y := Packet.GetBInt32();
  Position.Z := Packet.GetBInt8();
  Player^.Position := Position;
  Player^.Leader := Packet.GetBInt8() = 1;
  Player^.Updated;
end;

procedure TBBotWarNet.RoomCreate();
var
  Packet: TBBotPacket;
begin
  Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
  Packet.WriteBInt8(CMD_CLIENT_ROOM_CREATE);
  Packet.WriteBStr16(Room);
  Packet.WriteBStr16(Me.Name);
  Packet.WriteBStr16(Password);
  Packet.WriteBStr16(LeaderPassword);
  Send(Packet);
  Packet.Free;
  FLeaderPassword := ''; // Make the following CMD_HELLO try to join
end;

procedure TBBotWarNet.RoomJoin;
var
  Packet: TBBotPacket;
begin
  Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
  Packet.WriteBInt8(CMD_CLIENT_ROOM_JOIN);
  Packet.WriteBStr16(Room);
  Packet.WriteBStr16(Me.Name);
  Packet.WriteBStr16(Password);
  Send(Packet);
  Packet.Free;
end;

procedure TBBotWarNet.Run;
begin
  if Connected and (Sock.State = bwnssConnected) then
  begin
    Read;
    Status;
    HUD;
    Hello;
  end
  else if Connected and (Sock.State = bwnssDisconnected) and
    (FRoomStatus = bwnrsAuthenticated) then
  begin
    FRoomStatus := bwnrsNone;
  end
  else if Connected and (Sock.State = bwnssDisconnected) then
  begin
    FRoomStatus := bwnrsNone;
    Sock.IP := IP;
    Sock.Port := Port;
    Sock.Connect;
  end
  else if (not Connected) and (not(Sock.State = bwnssDisconnected)) then
  begin
    Sock.Disconnect;
  end;
end;

procedure TBBotWarNet.Send(APacket: TBBotPacket);
begin
  Sock.Send(APacket);
end;

procedure TBBotWarNet.ComboPos(AItem: BInt32; APosition: BPos);
var
  Packet: TBBotPacket;
begin
  if ImLeader and (RoomStatus = bwnrsAuthenticated) and
    (Sock.State = bwnssConnected) then
  begin
    if ComboIgnoreNextPos then
    begin
      ComboIgnoreNextPos := False;
      Exit;
    end;
    Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
    Packet.WriteBInt8(CMD_CLIENT_COMBO_POS);
    Packet.WriteBInt32(AItem);
    Packet.WriteBInt32(APosition.X);
    Packet.WriteBInt32(APosition.Y);
    Packet.WriteBInt8(APosition.Z);
    Packet.WriteBInt8(BIf(BAbs(APosition.X - Me.Position.X) <=
      BAbs(APosition.Y - Me.Position.Y), 1, 0));
    Send(Packet);
    Packet.Free;
  end;
end;

procedure TBBotWarNet.ComboTarget(ACombo: BStr);
var
  Packet: TBBotPacket;
  Atk: TBBotAttackSequence;
begin
  if ImLeader and (RoomStatus = bwnrsAuthenticated) and
    (Sock.State = bwnssConnected) then
    if Me.IsAttacking then
    begin
      Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
      Packet.WriteBInt8(CMD_CLIENT_COMBO_TARGET);
      Packet.WriteBStr16(ACombo);
      Packet.WriteBInt32(Me.TargetID);
      Send(Packet);
      Packet.Free;
      Atk := BBot.AdvAttack.GetAttackSequenceByName(ACombo);
      if Atk <> nil then
        Atk.InstantlyExecute
    end;
end;

procedure TBBotWarNet.Signal(ASignalName: BStr;
ASignalColor, ASignalDuration: BInt32);
var
  Packet: TBBotPacket;
begin
  if (RoomStatus = bwnrsAuthenticated) and (Sock.State = bwnssConnected) then
  begin
    Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
    Packet.WriteBInt8(CMD_CLIENT_SIGNAL);
    Packet.WriteBInt32(Me.ID);
    Packet.WriteBStr16(ASignalName);
    Packet.WriteBInt32(ASignalColor);
    Packet.WriteBInt32(ASignalDuration);
    Packet.WriteBInt32(Me.Position.X);
    Packet.WriteBInt32(Me.Position.Y);
    Packet.WriteBInt8(Me.Position.Z);
    Send(Packet);
    Packet.Free;
  end;
end;

procedure TBBotWarNet.Status;
var
  Packet: TBBotPacket;
begin
  if (RoomStatus = bwnrsAuthenticated) and (Sock.State = bwnssConnected) then
    if not NextStatus.Locked then
    begin
      Packet := TBBotPacket.CreateWritter(BBOT_TCP_PACKET_ALLOC_SIZE);
      Packet.WriteBInt8(CMD_CLIENT_STATUS);
      Packet.WriteBInt32(Me.ID);
      Packet.WriteBStr16(Me.Name);
      Packet.WriteBInt32(Me.HP);
      Packet.WriteBInt32(Me.HPMax);
      Packet.WriteBInt32(Me.Mana);
      Packet.WriteBInt32(Me.ManaMax);
      Packet.WriteBInt32(Me.Position.X);
      Packet.WriteBInt32(Me.Position.Y);
      Packet.WriteBInt8(Me.Position.Z);
      Send(Packet);
      Packet.Free;
      NextStatus.Lock;
    end;
end;

{ TBBotWarNetPlayer }

constructor TBBotWarNetPlayer.Create;
begin
  FSignals := BVector<TBBotWarNetSignal>.Create(
    procedure(It: BVector<TBBotWarNetSignal>.It)
    begin
      It^.Free;
    end);
end;

destructor TBBotWarNetPlayer.Destroy;
begin
  FSignals.Free;
  inherited;
end;

function TBBotWarNetPlayer.Expired: BBool;
begin
  Result := LastUpdated < Tick - STATUS_PLAYER_EXPIRE;
end;

procedure TBBotWarNetPlayer.HUD;
var
  OnScreen, HasSignalAlive: BBool;
  HUD: TBBotHUD;
  RadAngle, HalfScreenW, HalfScreenH, ManaFact, HPFact: BExtended;
  DX, DY, DZ, DD, NameWidth: BInt32;
  SDist: BStr;
begin
  OnScreen := Me.CanSee(Position);
  HasSignalAlive := False;

  DX := Position.X - Me.Position.X;
  DY := Position.Y - Me.Position.Y;
  DZ := Position.Z - Me.Position.Z;
  DD := NormalDistance(DX, DY, 0, 0);
  RadAngle := ArcTan2(DY, DX);

  ManaFact := Mana / ManaMax;
  HPFact := HP / HPMax;

  FSignals.ForEach(
    procedure(It: BVector<TBBotWarNetSignal>.It)
    begin
      if It^.Alive then
      begin
        It^.HUD;
        HasSignalAlive := True;
      end;
    end);
  if OnScreen or Leader or HasSignalAlive or (HPFact < 0.8) or (ManaFact < 0.4)
  then
  begin
    HUD := TBBotHUD.Create(bhgBBotNET);
    HUD.Color := HPColor(BFloor(HPFact * 100));
    HUD.Expire := STATUS_HUD_EXPIRE;
    if OnScreen then
    begin
      HUD.Creature := ID;
      HUD.Align := bhaLeft;
      if Leader then
      begin
        HUD.Text := 'Leader';
        HUD.RelativeY := -HUDLineHeight;
        HUD.Print;
      end;
      HUD.RelativeY := HUDLineHeight;
      HUD.Align := bhaLeft;
    end
    else
    begin
      HUD.Align := bhaCenter;

      NameWidth := (Length(Name) + 6) * HUDCharWidth;
      HalfScreenW := (ScreenRect.W - NameWidth) / 2;
      HalfScreenH := (ScreenRect.H - (HUDLineHeight * 3)) / 2;
      HUD.ScreenX := ScreenRect.X + (NameWidth div 2) +
        BFloor(HalfScreenW + (HalfScreenW * Cos(RadAngle)));
      HUD.ScreenY := ScreenRect.Y +
        BFloor(HalfScreenH + (HalfScreenH * Sin(RadAngle)));

      if DZ = 0 then
        SDist := BFormat('(%d)', [DD])
      else
        SDist := BFormat('(%s%d %d)', [BIf(Sign(DZ) = NegativeValue, '+', '-'),
          BAbs(DZ), DD]);

      HUD.Text := BFormat('%s%s %s', [BIf(Leader, 'L ', ''), Name, SDist]);
      HUD.Print;
    end;
    HUD.Text := BFormat('%d/%d %d%%', [HP, HPMax, BFloor(HPFact * 100)]);
    HUD.Print;
    if OnScreen then
      HUD.RelativeY := HUD.RelativeY + HUDLineHeight;
    HUD.Color := RGB(40 - BFloor(ManaFact * 40), 40 + BFloor(ManaFact * 60),
      100 + BFloor(ManaFact * 155));
    HUD.Text := BFormat('%d/%d %d%%', [Mana, ManaMax, BFloor(ManaFact * 100)]);
    HUD.Print;
    HUD.Free;
  end;
end;

procedure TBBotWarNetPlayer.Updated;
begin
  FLastUpdated := Tick;
end;

{ TBBotWarNetSignal }

constructor TBBotWarNetSignal.Create;
begin
  FName := '';
  FPosition := BPosXYZ(0, 0, 0);
  FColor := 0;
  FDuration := 0;
  SpawnTime := 0;
end;

function TBBotWarNetSignal.Alive: BBool;
begin
  Result := SpawnTime + Duration > Tick;
end;

procedure TBBotWarNetSignal.HUD;
var
  HUD: TBBotHUD;
  RadAngle, HalfScreenW, HalfScreenH: BExtended;
  DX, DY, DZ, NameWidth: BInt32;
begin
  DX := Position.X - Me.Position.X;
  DY := Position.Y - Me.Position.Y;
  DZ := Position.Z - Me.Position.Z;
  RadAngle := ArcTan2(DY, DX);

  HUD := TBBotHUD.Create(bhgBBotNET);
  HUD.Color := Color;
  HUD.Align := bhaCenter;
  HUD.Text := Name;
  HUD.Expire := BUInt32(BMax(0, (SpawnTime + Duration) - Tick));
  if Me.CanSee(Position) then
    HUD.SetPosition(Position)
  else
  begin
    NameWidth := (Length(Name) + 6) * HUDCharWidth;
    HalfScreenW := (ScreenRect.W - NameWidth) / 2;
    HalfScreenH := (ScreenRect.H - (HUDLineHeight * 3)) / 2;
    HUD.ScreenX := ScreenRect.X + (NameWidth div 2) +
      BFloor(HalfScreenW + (HalfScreenW * Cos(RadAngle)));
    HUD.ScreenY := ScreenRect.Y +
      BFloor(HalfScreenH + (HalfScreenH * Sin(RadAngle)));
    HUD.RelativeY := -2 * HUDLineHeight;
    if DZ <> 0 then
      HUD.Text := BFormat('(%s%d) %s', [BIf(Sign(DZ) = NegativeValue, '+', '-'),
        BAbs(DZ), HUD.Text]);
  end;
  HUD.Print;
  HUD.Free;
end;

procedure TBBotWarNetSignal.Spawn;
begin
  SpawnTime := Tick;
end;

{ TBBotWarNetActionTriggerKey }

constructor TBBotWarNetActionTriggerKey.Create(AAction: TBBotWarNetAction;
AKey: BInt16; AShift: TShiftState);
begin
  inherited Create(AAction);
  FKey := AKey;
  FShift := AShift;
end;

procedure TBBotWarNetActionTriggerKey.OnHotkey;
begin
  if Tibia.IsKeyDown(FKey, True) then
  begin
    if (ssShift in FShift) and (not Tibia.IsKeyDown(VK_SHIFT, False)) then
      Exit;
    if (ssCtrl in FShift) and (not Tibia.IsKeyDown(VK_CONTROL, False)) then
      Exit;
    if (ssAlt in FShift) and (not Tibia.IsKeyDown(VK_MENU, False)) then
      Exit;
    Action.Run;
  end;
end;

{ TBBotWarNetActionTrigger }

constructor TBBotWarNetActionTrigger.Create(AAction: TBBotWarNetAction);
begin
  FAction := AAction;
end;

destructor TBBotWarNetActionTrigger.Destroy;
begin
  FAction.Free;
  inherited;
end;

{ TBBotWarNetActionTriggerSay }

constructor TBBotWarNetActionTriggerSay.Create(AAction: TBBotWarNetAction;
AKeyword: BStr);
begin
  inherited Create(AAction);
  FKeyword := AKeyword;
end;

procedure TBBotWarNetActionTriggerSay.OnSay(AText: BStr);
begin
  if BStrEqual(AText, FKeyword) then
    Action.Run;
end;

{ TBBotWarNetActionTriggerShoot }

constructor TBBotWarNetActionTriggerShoot.Create(AAction: TBBotWarNetAction;
AItem: BInt32);
begin
  inherited Create(AAction);
  FItem := AItem;
end;

procedure TBBotWarNetActionTriggerShoot.OnShoot(AItem: BInt32);
begin
  if AItem = FItem then
    Action.Run;
end;

{ TBBotWarNetAction }

constructor TBBotWarNetAction.Create(AWarNet: TBBotWarNet);
begin
  FWarNet := AWarNet;
end;

{ TBBotWarNetActionSignal }

constructor TBBotWarNetActionSignal.Create(AWarNet: TBBotWarNet);
begin
  inherited Create(AWarNet);
end;

procedure TBBotWarNetActionSignal.Run;
begin
  WarNet.Signal(FName, FColor, FDuration);
end;

{ TBBotWarNetActionCombo }

constructor TBBotWarNetActionCombo.Create(AWarNet: TBBotWarNet);
begin
  inherited Create(AWarNet);
end;

procedure TBBotWarNetActionCombo.Run;
begin
  inherited;
  WarNet.ComboTarget(FName);
end;

end.

