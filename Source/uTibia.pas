unit uTibia;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,

  Windows,
  Math,
  SysUtils,
  uBattlelist,
  uContainer,
  Messages,
  StrUtils,
  uSelf,
  uTibiaDeclarations,
  Graphics,
  TlHelp32,
  uTibiaParser,
  uBBotGUIMessages;

type
  TTibiaPacketFrom = (tpFromServer, tpFromClient, tpFromBot);

  TTibiaAction = procedure of object;
  TTibiaAction_Counter = procedure(Cooldown: BInt32) of object;
  TTibiaAction_Simple = procedure(Old, New: BInt32) of object;
  TTibiaAction_Simple64 = procedure(Old, New: Int64) of object;
  TTibiaAction_Inventory = procedure(Slot: TTibiaSlot; Old, New: TBufferItem) of object;
  TTibiaAction_Skill = procedure(Skill: TTibiaSkill; Old, New: BInt32) of object;
  TTibiaAction_Bool = procedure(Value: boolean) of object;
  TTibiaAction_Creature = procedure(Creature: TBBotCreature) of object;
  TTibiaAction_CreatureSimple = procedure(Creature: TBBotCreature; Old, New: BInt32) of object;
  TTibiaAction_CreaturePosition = procedure(Creature: TBBotCreature; FromPos, ToPos: BPos) of object;
  TTibiaAction_Container = procedure(Container: TTibiaContainer) of object;
  TTibiaAction_Menu = procedure(Callback: BUInt32; Data: BUInt32) of object;
  TTibiaAction_Hotkey = procedure(Callback: BInt32; var Release: BBool) of object;
  TTibiaAction_ShootEffect = procedure(Ammo: BInt32; FromPos, ToPos: BPos) of object;
  TTibiaAction_Shoot = procedure(Ammo, Target, Stackpos: BInt32; Pos: BPos) of object;
  TTibiaAction_MessageSent = procedure(SpeakMode: TTibiaMessageMode; Destination, Text: BStr) of object;
  TTibiaAction_MessageRecv = procedure(SpeakMode: TTibiaMessageMode; Author: BStr; Level, ChannelID: BInt32;
    Text: BStr) of object;
  TTibiaAction_Position = procedure(FromPos, ToPos: BPos) of object;
  TTibiaAction_Equip = procedure(Slot: TTibiaSlot; ID: BInt32; Count: BInt32 = -1) of object;
  TTibiaAction_Say = procedure(Text: BStr) of object;
  TTibiaAction_Int = procedure(Value: BInt32) of object;
  TTibiaAction_GiveCondition = procedure(Condition: BInt32; Spell: BStr; Mana: BInt32; GiveStatus: boolean) of object;

  TTibia = class(TBBotAction)
  private
    LastScreenshot: BUInt32;
    FPingStart: BUInt32;
    FPingCount: BUInt32;
    FPingTotal: BUInt32;
    function GetTotalOpenContainers: BInt32;
    function GetNewContainerIndex: BInt32;
    function GetPingAvg: BUInt32;
  public
    MapOldPos, MapNewPos: BPos;

    Parser: TTibiaPackerParser;

    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure Login(strAcc, strPass: BStr; CharIndex: BInt32);
    procedure ScreenShot;
    procedure StealthScreenshot;
    function CalcExp(Level: BInt32): Int64;
    function SleepWhileDisconnected(Delay: BUInt32): BBool;

    function IsKeyDown(Key: byte; First: BBool): BBool;
    procedure BlockKeyCallback(Key: byte; WithShift: boolean; WithCtrl: boolean);
    procedure UnBlockKeyCallback(Key: byte; WithShift: boolean; WithCtrl: boolean);

    procedure SetMove(ToPos: BPos);
    procedure UnsetMove;

    procedure Shoot(Ammo, Target: BInt32);
    procedure XRay(Enabled: boolean);
    function XRayEnabled: boolean;

    function MessageModeFrom(ModeID: BInt32): TTibiaMessageMode;

    function MaxFPS(NewLimit: double): double;
    function LastClickedID: BInt32;
    procedure StopClientAttack;

    function AccountAndPassword: TTibiaAcc;

    property TotalOpenContainers: BInt32 read GetTotalOpenContainers;
    property NewContainerIndex: BInt32 read GetNewContainerIndex;

    procedure PingStart;
    procedure PingEnd;
    property PingAvg: BUInt32 read GetPingAvg;

    procedure OnClientPacket(ABuffer: BPtr; ASize: BInt32);
    procedure OnServerPacket(ABuffer: BPtr; ASize: BInt32);
    procedure OnBotPacket(ABuffer: BPtr; ASize: BInt32);
  end;

procedure SaveLog(S: BStr);

implementation

uses
  BBotEngine,

  jpeg,
  uHUD,
  uBBotSpells,
  uBBotAddresses,

  uMain,
  uTibiaProcess,

  uTibiaState;

procedure SaveLog(S: BStr);
begin
  BFileAppend('./Data/BBot.log', S);
end;

function TTibia.CalcExp(Level: BInt32): Int64;
{
  F1 = ((17 + (level - 6) * level) / 3 * level - 4) * 50
  F2 = ((50 * (level) * (level) * (level) - 150 * (level) * (level) + 400 * (level)) / 3)
}
begin
  Result := Round(50.0 * ((Level / 3.0) * (Level * (Level - 6.0) + 17.0) - 4.0));
end;

function TTibia.LastClickedID: BInt32;
begin
  TibiaProcess.Read(TibiaAddresses.AdrLastSeeID, 4, @Result);
end;

procedure TTibia.SetMove(ToPos: BPos);
begin
{$IFNDEF Release}
  if Me.Position.Z <> ToPos.Z then
    raise Exception.Create('Error SetMove Z!=Z');
{$ENDIF}
  TibiaProcess.Write(TibiaAddresses.AdrGoToX, 4, @ToPos.X);
  TibiaProcess.Write(TibiaAddresses.AdrGoToY, 4, @ToPos.Y);
  TibiaProcess.Write(TibiaAddresses.AdrGoToZ, 4, @ToPos.Z);
  Me.Walking := True;
end;

procedure TTibia.Shoot(Ammo, Target: BInt32);
var
  Creature: TBBotCreature;
begin
  Creature := BBot.Creatures.Find(Target);
  if (Creature <> nil) and (Creature.IsOnScreen) then
    BBot.PacketSender.UseOnCreature(BPosXYZ($FFFF, 0, 0), 0, Ammo, Target);
end;

procedure TTibia.XRay(Enabled: boolean);
const
  XRayOff1: array [0 .. 5] of BInt8 = ($0F, $85, $D5, $01, $00, $00);
  XRayOff2: array [0 .. 1] of BInt8 = ($75, $34);
  XRayOn1: array [0 .. 5] of BInt8 = ($90, $90, $90, $90, $90, $90);
  XRayOn2: array [0 .. 1] of BInt8 = ($90, $90);
var
  Buffer, Buffer2: BInt32;
begin
  if Enabled then begin
    Buffer := $9090;
    Buffer2 := Buffer;
  end else begin
    Buffer := TibiaAddresses.NameSpy1Default;
    Buffer2 := TibiaAddresses.NameSpy2Default;
  end;
  if AdrSelected < TibiaVer1056 then begin
    TibiaProcess.Write(TibiaAddresses.AdrNameSpy1, 2, @Buffer);
    TibiaProcess.Write(TibiaAddresses.AdrNameSpy2, 2, @Buffer2);
  end else begin
    if Enabled then begin
      TibiaProcess.Write(TibiaAddresses.AdrNameSpy1, SizeOf(XRayOn1), @XRayOn1);
      TibiaProcess.Write(TibiaAddresses.AdrNameSpy2, SizeOf(XRayOn2), @XRayOn2);
    end else begin
      TibiaProcess.Write(TibiaAddresses.AdrNameSpy1, SizeOf(XRayOff1), @XRayOff1);
      TibiaProcess.Write(TibiaAddresses.AdrNameSpy2, SizeOf(XRayOff2), @XRayOff2);
    end;
  end;
end;

procedure TTibia.StealthScreenshot;
begin
  HUDRemoveAll;
  HUDExecute;
  Sleep(300);
  Tibia.ScreenShot;
end;

procedure TTibia.StopClientAttack;
var
  Value: BInt32;
begin
  Value := 0;
  TibiaProcess.Write(TibiaAddresses.AdrAttackSquare, 4, @Value);
end;

procedure TTibia.ScreenShot;
var
  Src, Dst: HDC;
  R: TRect;
  Width, Height: BInt32;
  B: HBITMAP;
  Old: HGDIOBJ;
  bmp: TBitmap;
  j: TJPEGImage;
  n: BStr;
begin
  if not(LastScreenshot < (Tick - 2000)) then
    Exit;
  LastScreenshot := Tick;
  bmp := TBitmap.Create;
  try
    Src := GetDC(TibiaProcess.hWnd);
    GetWindowRect(TibiaProcess.hWnd, R);
    Width := R.Right - R.Left;
    Height := R.Bottom - R.Top;
    Dst := CreateCompatibleDC(Src);
    B := CreateCompatibleBitmap(Src, Width, Height);
    Old := SelectObject(Dst, B);
    BitBlt(Dst, 0, 0, Width, Height, Src, 0, 0, SRCCOPY);
    SelectObject(Dst, Old);
    DeleteDC(Dst);
    ReleaseDC(TibiaProcess.hWnd, Src);

    bmp.Width := Width;
    bmp.Height := Height;
    bmp.Handle := B;

    if not DirectoryExists('Screenshots') then
      CreateDir('Screenshots');

    n := BotPath + 'Screenshots/' + Me.Name + ' ' + FormatDateTime('dd.mm.yyyy hh.mm.ss', Now());
    j := TJPEGImage.Create;
    try
      try
        j.Assign(bmp);
        j.SaveToFile(n + '.jpeg');
      except bmp.SaveToFile(n + '.bmp');
      end;
    finally j.Free;
    end;

    DeleteObject(B);
  finally bmp.Free;
  end;
end;

procedure TTibia.PingEnd;
begin
  if FPingStart <> 0 then begin
    Inc(FPingCount);
    Inc(FPingTotal, BMin(Tick - FPingStart, 1000));
    if FPingCount > 100 then begin
      FPingTotal := FPingTotal div FPingCount;
      FPingCount := 1;
    end;
  end;
  FPingStart := 0;
end;

procedure TTibia.PingStart;
begin
  FPingStart := Tick;
end;

procedure TTibia.Run;
begin
  if TibiaState^.HasError then
    raise BException.Create('CRITICAL ERROR DLL: ' + TibiaState^.Error);
end;

procedure TTibia.Login(strAcc, strPass: BStr; CharIndex: BInt32);
const
  LoginOriginXPre920 = 76 + 5;
  LoginOriginYPre920 = -224 + 3;
  LoginOriginXPost920 = 41 + 5;
  LoginOriginYPost920 = -180 + 3;
  LoginOriginXPost1038 = 41 + 5; // Get Premium
  LoginOriginYPost1038 = -210 + 3;
  LoginWidth = 80 - 10;
  LoginHeight = 15 - 6;
var
  i, X, Y: BInt32;
  R: TRect;
begin
  if strAcc = '' then
    Exit;
  TibiaProcess.SendKey(VK_RETURN);
  for i := 0 to 5 do begin
    TibiaProcess.SendKey(VK_ESCAPE);
    if SleepWhileDisconnected(300) then
      Exit;
  end;
  R := TibiaProcess.ClientRect;
  if AdrSelected >= TibiaVer1038 then begin
    X := R.Left + LoginOriginXPost1038;
    Y := (R.Top + R.Bottom) + LoginOriginYPost1038;
  end else if AdrSelected >= TibiaVer920 then begin
    X := R.Left + LoginOriginXPost920;
    Y := (R.Top + R.Bottom) + LoginOriginYPost920;
  end else begin
    X := R.Left + LoginOriginXPre920;
    Y := (R.Top + R.Bottom) + LoginOriginYPre920;
  end;
  Inc(X, BRandom(0, LoginWidth));
  Inc(Y, BRandom(0, LoginHeight));
  TibiaProcess.SendMouseClickEx(X, Y);
  Sleep(500 + BRandom(0, 1000));
  Me.Reload;
  if not Me.Connected then
    TibiaProcess.SendText(strAcc);
  Sleep(200 + BRandom(0, 200));
  TibiaProcess.SendKey(VK_TAB);
  Sleep(200 + BRandom(0, 500));
  Me.Reload;
  if not Me.Connected then
    TibiaProcess.SendText(strPass);
  Sleep(200 + BRandom(0, 300));
  TibiaProcess.SendKey(VK_RETURN);
  SleepWhileDisconnected(BRandom(4000, 6000));
  if CharIndex <> 0 then begin
    for i := 1 to 50 + BRandom(0, 10) do begin
      TibiaProcess.SendKey(VK_UP);
      Sleep(BRandom(10, 30));
    end;
    i := CharIndex;
    while i > 1 do begin
      TibiaProcess.SendKey(VK_DOWN);
      Sleep(200 + BRandom(0, 200));
      Dec(i);
    end;
  end;
  TibiaProcess.SendKey(VK_RETURN);
  if SleepWhileDisconnected(30000) then
    Exit;
end;

function TTibia.AccountAndPassword: TTibiaAcc;
begin
  Result.Account := BStr(BPChar(@TibiaState^.Account));
  Result.Password := BStr(BPChar(@TibiaState^.Password));
end;

function TTibia.XRayEnabled: boolean;
var
  Buffer: BUInt16;
begin
  TibiaProcess.Read(TibiaAddresses.AdrNameSpy1, 2, @Buffer);
  Result := Buffer = $9090;
end;

function TTibia.GetTotalOpenContainers: BInt32;
var
  i: BInt32;
begin
  Result := 0;
  for i := 0 to 15 do
    if ContainerAt(i, 0).Open then
      Inc(Result);
end;

function TTibia.MaxFPS(NewLimit: double): double;
const
  FPSLimit = $58;
var
  FPSOffset: BInt32;
begin
  TibiaProcess.Read(TibiaAddresses.AdrFrameRatePointer, 4, @FPSOffset);
  TibiaProcess.ReadEx(FPSOffset + FPSLimit, SizeOf(double), @Result);
  if NewLimit <> 0 then
    TibiaProcess.WriteEx(FPSOffset + FPSLimit, SizeOf(double), @NewLimit);
end;

function TTibia.MessageModeFrom(ModeID: BInt32): TTibiaMessageMode;
const
{$REGION 'MessageModes850'}
  MessageModes850: array [0 .. 26] of TTibiaMessageMode = (MESSAGE_NONE, MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL,
    MESSAGE_NPC_TO, MESSAGE_NPC_FROM_START_BLOCK, MESSAGE_PRIVATE_TO, MESSAGE_CHANNEL, MESSAGE_CHANNEL_MANAGEMENT,
    MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_BROADCAST,
    MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_PRIVATE_FROM, MESSAGE_CHANNEL, MESSAGE_NONE, MESSAGE_CHANNEL_MANAGEMENT,
    MESSAGE_NONE, MESSAGE_BARK_LOW, MESSAGE_BARK_LOUD, MESSAGE_GAME, MESSAGE_GAME, MESSAGE_GAME, MESSAGE_LOOK,
    MESSAGE_GAME, MESSAGE_GAME);
{$ENDREGION}
{$REGION 'MessageModes872'}
  MessageModes872: array [0 .. 38] of TTibiaMessageMode = (MESSAGE_NONE, MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL,
    MESSAGE_PRIVATE_FROM, MESSAGE_PRIVATE_TO, MESSAGE_CHANNEL_MANAGEMENT, MESSAGE_CHANNEL, MESSAGE_CHANNEL_HIGHLIGHT,
    MESSAGE_SPELL, MESSAGE_NPC_FROM, MESSAGE_NPC_TO, MESSAGE_GAMEMASTER_BROADCAST, MESSAGE_GAMEMASTER_CHANNEL,
    MESSAGE_GAMEMASTER_PRIVATE_FROM, MESSAGE_GAMEMASTER_PRIVATE_TO, MESSAGE_LOGIN, MESSAGE_ADMIN, MESSAGE_GAME,
    MESSAGE_FAILURE, MESSAGE_LOOK, MESSAGE_DAMAGE_DEALED, MESSAGE_DAMAGE_RECEIVED, MESSAGE_HEAL, MESSAGE_EXP,
    MESSAGE_DAMAGE_OTHERS, MESSAGE_HEAL_OTHERS, MESSAGE_EXP_OTHERS, MESSAGE_STATUS, MESSAGE_LOOT, MESSAGE_TRADE_NPC,
    MESSAGE_GUILD, MESSAGE_PARTY_MANAGEMENT, MESSAGE_PARTY, MESSAGE_BARK_LOW, MESSAGE_BARK_LOUD, MESSAGE_REPORT,
    MESSAGE_HOTKEY_USE, MESSAGE_TUTORIAL_HINT);
{$ENDREGION}
{$REGION 'MessageModes1036'}
  MessageModes1036: array [0 .. 41] of TTibiaMessageMode = (MESSAGE_NONE, MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL,
    MESSAGE_PRIVATE_FROM, MESSAGE_PRIVATE_TO, MESSAGE_CHANNEL_MANAGEMENT, MESSAGE_CHANNEL, MESSAGE_CHANNEL_HIGHLIGHT,
    MESSAGE_SPELL, MESSAGE_NPC_FROM_START_BLOCK, MESSAGE_NPC_FROM, MESSAGE_NPC_TO, MESSAGE_GAMEMASTER_BROADCAST,
    MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_PRIVATE_FROM, MESSAGE_GAMEMASTER_PRIVATE_TO, MESSAGE_LOGIN,
    MESSAGE_ADMIN, MESSAGE_GAME, MESSAGE_FAILURE, MESSAGE_LOOK, MESSAGE_DAMAGE_DEALED, MESSAGE_DAMAGE_RECEIVED,
    MESSAGE_HEAL, MESSAGE_EXP, MESSAGE_DAMAGE_OTHERS, MESSAGE_HEAL_OTHERS, MESSAGE_EXP_OTHERS, MESSAGE_STATUS,
    MESSAGE_LOOT, MESSAGE_TRADE_NPC, MESSAGE_GUILD, MESSAGE_PARTY_MANAGEMENT, MESSAGE_PARTY, MESSAGE_BARK_LOW,
    MESSAGE_BARK_LOUD, MESSAGE_REPORT, MESSAGE_HOTKEY_USE, MESSAGE_TUTORIAL_HINT, MESSAGE_THANKYOU, MESSAGE_MARKET);
{$ENDREGION}
{$REGION 'MessageModes1055'}
  MessageModes1055: array [0 .. 43] of TTibiaMessageMode = (MESSAGE_NONE, MESSAGE_SAY, MESSAGE_WHISPER, MESSAGE_YELL,
    MESSAGE_PRIVATE_FROM, MESSAGE_PRIVATE_TO, MESSAGE_CHANNEL_MANAGEMENT, MESSAGE_CHANNEL, MESSAGE_CHANNEL_HIGHLIGHT,
    MESSAGE_SPELL, MESSAGE_NPC_FROM_START_BLOCK, MESSAGE_NPC_FROM, MESSAGE_NPC_TO, MESSAGE_GAMEMASTER_BROADCAST,
    MESSAGE_GAMEMASTER_CHANNEL, MESSAGE_GAMEMASTER_PRIVATE_FROM, MESSAGE_GAMEMASTER_PRIVATE_TO, MESSAGE_LOGIN,
    MESSAGE_ADMIN, MESSAGE_GAME, MESSAGE_GAME_HIGHLIGHT, MESSAGE_FAILURE, MESSAGE_LOOK, MESSAGE_DAMAGE_DEALED,
    MESSAGE_DAMAGE_RECEIVED, MESSAGE_HEAL, MESSAGE_EXP, MESSAGE_DAMAGE_OTHERS, MESSAGE_HEAL_OTHERS, MESSAGE_EXP_OTHERS,
    MESSAGE_STATUS, MESSAGE_LOOT, MESSAGE_TRADE_NPC, MESSAGE_GUILD, MESSAGE_PARTY_MANAGEMENT, MESSAGE_PARTY,
    MESSAGE_BARK_LOW, MESSAGE_BARK_LOUD, MESSAGE_REPORT, MESSAGE_HOTKEY_USE, MESSAGE_TUTORIAL_HINT, MESSAGE_THANKYOU,
    MESSAGE_MARKET, MESSAGE_MANA);
{$ENDREGION}
  function FromModes(Modes: array of TTibiaMessageMode): TTibiaMessageMode;
  begin
    if BInRange(ModeID, 0, High(Modes)) then
      Result := Modes[ModeID]
    else
      Result := MESSAGE_NONE;
  end;
begin
  if AdrSelected >= TibiaVer1055 then begin
    Exit(FromModes(MessageModes1055))
  end else if AdrSelected >= TibiaVer1036 then begin
    Exit(FromModes(MessageModes1036))
  end else if AdrSelected >= TibiaVer872 then begin
    Exit(FromModes(MessageModes872))
  end else begin
    Exit(FromModes(MessageModes850))
  end;
end;

procedure TTibia.OnBotPacket(ABuffer: BPtr; ASize: BInt32);
var
  MsgPacket: TBBotGUIMessageOnPacketBot;
begin
  if Assigned(Me) and Me.Connected then begin
    Parser.SetBuffer(ABuffer, ASize);
    if Assigned(FMain) then begin
      MsgPacket := TBBotGUIMessageOnPacketBot.Create;
      MsgPacket.Time := Now;
      MsgPacket.Size := ASize;
      MsgPacket.Data := Parser.BufferToStr;
      FMain.AddBBotMessage(MsgPacket);
    end;
  end;
end;

procedure TTibia.OnClientPacket(ABuffer: BPtr; ASize: BInt32);
var
  MsgPacket: TBBotGUIMessageOnPacketClient;
begin
  if Assigned(Me) and Me.Connected then begin
    Parser.SetBuffer(ABuffer, ASize);
    if Assigned(FMain) then begin
      MsgPacket := TBBotGUIMessageOnPacketClient.Create;
      MsgPacket.Time := Now;
      MsgPacket.Size := ASize;
      MsgPacket.Data := Parser.BufferToStr;
      FMain.AddBBotMessage(MsgPacket);
    end;
    Parser.ParseClient;
  end;
end;

procedure TTibia.OnInit;
begin
  inherited;
  BBot.Events.OnClientPacket.Add(OnClientPacket);
  BBot.Events.OnServerPacket.Add(OnServerPacket);
  BBot.Events.OnBotPacket.Add(OnBotPacket);
end;

procedure TTibia.OnServerPacket(ABuffer: BPtr; ASize: BInt32);
var
  MsgPacket: TBBotGUIMessageOnPacketServer;
begin
  if Assigned(Me) and Me.Connected then begin
    Parser.SetBuffer(ABuffer, ASize);
    if Assigned(FMain) then begin
      MsgPacket := TBBotGUIMessageOnPacketServer.Create;
      MsgPacket.Time := Now;
      MsgPacket.Size := ASize;
      MsgPacket.Data := Parser.BufferToStr;
      FMain.AddBBotMessage(MsgPacket);
    end;
    Parser.ParseServer;
  end;
end;

procedure TTibia.UnsetMove;
var
  Zero: BInt32;
begin
  Zero := 0;
  TibiaProcess.Write(TibiaAddresses.AdrGoToX, 4, @Zero);
end;

constructor TTibia.Create;
begin
  Parser := TTibiaPackerParser.Create;
  inherited Create('Tibia Core', 500);
end;

function TTibia.IsKeyDown(Key: byte; First: BBool): BBool;
var
  KS: TTibiaKeyStates;
begin
  KS := TibiaState^.Keys[Key];
  if First then begin
    Result := bksDown in KS;
    if Result then
      TibiaState^.Keys[Key] := TibiaState^.Keys[Key] - [bksDown];
  end
  else
    Result := bksPressed in KS;
end;

procedure TTibia.BlockKeyCallback(Key: byte; WithShift: boolean; WithCtrl: boolean);
var
  OffFlag: TTibiaKeyState;
begin
  OffFlag := bksCallOff;
  if WithShift then
    OffFlag := bksCallOffShift;
  if WithCtrl then
    OffFlag := bksCallOffCtrl;
  if not(OffFlag in TibiaState^.Keys[Key]) then
    TibiaState^.Keys[Key] := TibiaState^.Keys[Key] + [OffFlag];
end;

procedure TTibia.UnBlockKeyCallback(Key: byte; WithShift: boolean; WithCtrl: boolean);
var
  OffFlag: TTibiaKeyState;
begin
  OffFlag := bksCallOff;
  if WithShift then
    OffFlag := bksCallOffShift;
  if WithCtrl then
    OffFlag := bksCallOffCtrl;
  if (OffFlag in TibiaState^.Keys[Key]) then
    TibiaState^.Keys[Key] := TibiaState^.Keys[Key] - [OffFlag];
end;

destructor TTibia.Destroy;
var
  i: BInt32;
begin
  if Assigned(TibiaProcess) then
    XRay(False);

  for i := 0 to 255 do
    TibiaState^.Keys[i] := [];

  Parser.Free;

  inherited;
end;

function TTibia.GetNewContainerIndex: BInt32;
var
  i: BInt32;
begin
  Result := 15;
  for i := 0 to 15 do
    if ContainerAt(i, 0) <> nil then
      if not ContainerAt(i, 0).Open then begin
        Result := i;
        Exit;
      end;
end;

function TTibia.GetPingAvg: BUInt32;
begin
  if FPingCount > 0 then
    Result := FPingTotal div FPingCount
  else
    Result := 0;
end;

function TTibia.SleepWhileDisconnected(Delay: BUInt32): BBool;
var
  n: BInt32;
begin
  BBotMutex.Release;
  try
    Result := False;
    n := BInt32(Delay) + BRandom(0, BFloor(Delay * 0.3));
    while n > 0 do begin
      Sleep(500);
      Dec(n, 500);
      Me.Reload;
      Result := Me.Connected or (not IsWindow(TibiaProcess.hWnd));
      if Result then
        Break;
    end;
  finally BBotMutex.Acquire;
  end;
end;

end.
