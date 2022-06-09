unit uBBotPacketSender;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotPacketSender = class(TBBotAction)
  private
    procedure SendMsg(const Msg: String; MsgType: BInt32);
    function CheckItem(const AID, AFunc: BInt32): BBool;
  public
    constructor Create;
    procedure Run; override;

    procedure Attack(Target: BInt32);
    procedure CloseContainer(Container: BInt32);
    procedure NPCBuy(ID, BuyCount, Amount: BUInt32; IgnoreCap, BuyWithBPs: boolean);
    procedure NPCSell(ID, SellCount, Amount: BUInt32);
    procedure WalkStep(Direction: TTibiaDirection);
    procedure ToggleMount(AIsMounted: BBool);
    procedure StopAction();
    procedure TryLogout();
    procedure MoveItem(FromPos: BPos; Item, FromStack, Count: BInt32; ToPos: BPos);
    procedure TurnSelf(Direction: TTibiaDirection);
    procedure UseOnCreature(FromPos: BPos; FromStack, Item, Target: BInt32);
    procedure UseOnObject(FromPos: BPos; FromID, FromStack: BInt32; ToPos: BPos; ToID, ToStack: BInt32);
    procedure UseItem(Position: BPos; Item, Stack, Index: BInt32);
    procedure PrivateMesage(const Msg, Dest: String);
    procedure ChannelMessage(const Msg: BStr; Channel: BInt32);
    procedure TradeChannelMessage(AMsg: BStr);
    procedure NPCChannelMessage(AMsg: BStr);
    procedure SayMessage(AMsg: BStr);
    procedure WhisperMessage(AMsg: BStr);
    procedure YellMessage(AMsg: BStr);
    procedure InviteToParty(Target: BInt32);
    procedure RevokeInviteToParty(Target: BInt32);
    procedure JoinParty(Leader: BInt32);
    procedure PartyPassLeader(NewLeader: BInt32);
    procedure LeaveParty;
    procedure PartyShareExp(Shared: BBool);
    procedure FastEquip(const AItem: BInt32);
    function SendHexPacket(const AHexMessage: BStr): BBool;
  end;

implementation

uses
  uTibiaProcess,
  uBBotAddresses,
  uPackets,
  uTibiaState,
  BBotEngine,
  Windows,
  SysUtils,
  Messages,
  uItem;

constructor TBBotPacketSender.Create;
begin
  inherited Create('PacketSender', 10000);
end;

procedure TBBotPacketSender.FastEquip(const AItem: BInt32);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($77);
  PacketQueue.PacketBot.WriteBInt16(AItem);
  PacketQueue.PacketBot.WriteBInt8(0); // Type, isCloth == 0 (only isCloth)
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.InviteToParty(Target: BInt32);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($A3);
  PacketQueue.PacketBot.WriteBInt32(Target);
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.JoinParty(Leader: BInt32);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($A4);
  PacketQueue.PacketBot.WriteBInt32(Leader);
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.LeaveParty;
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($A7);
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.RevokeInviteToParty(Target: BInt32);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($A5);
  PacketQueue.PacketBot.WriteBInt32(Target);
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.Run;
begin
end;

procedure TBBotPacketSender.Attack(Target: BInt32);
var
  AtkID: BUInt32;
begin
  TibiaProcess.Write(TibiaAddresses.AdrAttackSquare, 4, @Target);

  PacketQueue.PreparePacket;

  PacketQueue.PacketBot.WriteBInt8($A1);
  PacketQueue.PacketBot.WriteBInt32(Target);

  if AdrSelected >= TibiaVer860 then begin
    TibiaProcess.Read(TibiaAddresses.AdrAttackID, 4, @AtkID);
    if (AdrSelected < TibiaVer872) or (AdrSelected >= TibiaVer900) then
      Inc(AtkID, 1)
    else
      Inc(AtkID, 2);
    TibiaProcess.Write(TibiaAddresses.AdrAttackID, 4, @AtkID);

    PacketQueue.PacketBot.WriteBInt32(AtkID);
  end;

  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.NPCBuy(ID, BuyCount, Amount: BUInt32; IgnoreCap, BuyWithBPs: boolean);
begin
  if CheckItem(ID, 1) then begin
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($7A);
    PacketQueue.PacketBot.WriteBInt16(BInt16(ID));
    PacketQueue.PacketBot.WriteBInt8(BInt8(Amount));
    PacketQueue.PacketBot.WriteBInt8(BInt8(BuyCount));
    PacketQueue.PacketBot.WriteBInt8(BIf(IgnoreCap, 1, 0));
    PacketQueue.PacketBot.WriteBInt8(BIf(BuyWithBPs, 1, 0));
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.CloseContainer(Container: BInt32);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($87);
  PacketQueue.PacketBot.WriteBInt8(BInt8(Container));
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.UseOnCreature(FromPos: BPos; FromStack, Item, Target: BInt32);
var
  UseOnCreatureData: TTibiaUseOnCreature;
begin
  if CheckItem(Item, 2) then begin
    UseOnCreatureData.FromPosition := FromPos;
    UseOnCreatureData.ItemID := Item;
    UseOnCreatureData.Stack := FromStack;
    UseOnCreatureData.Creature := Target;
    BBot.Events.RunUseOnCreature(UseOnCreatureData);
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($84);
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromPos.X));
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromPos.Y));
    PacketQueue.PacketBot.WriteBInt8(BInt8(FromPos.Z));
    PacketQueue.PacketBot.WriteBInt16(BInt16(Item));
    PacketQueue.PacketBot.WriteBInt8(BInt8(FromStack));
    PacketQueue.PacketBot.WriteBInt32(Target);
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.WalkStep(Direction: TTibiaDirection);
var
  ModKey: BBool;
  Pos: BPos;
  Key, KeyRepeat, StepDelay: BUInt16;
begin
  Key := 0;
  case Direction of
  tdNorth: begin
      Key := VK_UP;
      Pos.change(Me.Position.X, Me.Position.Y - 1, Me.Position.Z);
    end;
  tdEast: begin
      Key := VK_RIGHT;
      Pos.change(Me.Position.X + 1, Me.Position.Y, Me.Position.Z);
    end;
  tdWest: begin
      Key := VK_LEFT;
      Pos.change(Me.Position.X - 1, Me.Position.Y, Me.Position.Z);
    end;
  tdSouth: begin
      Key := VK_DOWN;
      Pos.change(Me.Position.X, Me.Position.Y + 1, Me.Position.Z);
    end;
  tdNorthEast: begin
      PacketQueue.PreparePacket;
      PacketQueue.PacketBot.WriteBInt8($6A);
      PacketQueue.SendPacket;
      Exit;
    end;
  tdNorthWest: begin
      PacketQueue.PreparePacket;
      PacketQueue.PacketBot.WriteBInt8($6D);
      PacketQueue.SendPacket;
      Exit;
    end;
  tdSouthEast: begin
      PacketQueue.PreparePacket;
      PacketQueue.PacketBot.WriteBInt8($6B);
      PacketQueue.SendPacket;
      Exit;
    end;
  tdSouthWest: begin
      PacketQueue.PreparePacket;
      PacketQueue.PacketBot.WriteBInt8($6C);
      PacketQueue.SendPacket;
      Exit;
    end;
  tdCenter: raise Exception.Create('Trying to execute WalkStep to Center');
  end;
  ModKey := Tibia.IsKeyDown(VK_SHIFT, False) or Tibia.IsKeyDown(VK_CONTROL, False) or Tibia.IsKeyDown(VK_MENU, False);
  if (Key = 0) or ModKey then
    Tibia.SetMove(Pos)
  else begin
    StepDelay := Me.StepDelay;
    if StepDelay > 0 then
      KeyRepeat := BMin(BRandom(1, 1 + (1000 div StepDelay)), 4)
    else
      KeyRepeat := BRandom(1, 3);
    while KeyRepeat > 0 do begin
      TibiaProcess.SendKeyDown(Key);
      Dec(KeyRepeat);
    end;
    TibiaProcess.SendKeyUp(Key);
  end;
end;

function TBBotPacketSender.SendHexPacket(const AHexMessage: BStr): BBool;
var
  R: BStrArray;
  B: array of byte;
  I: BInt32;
begin
  if BStrSplit(R, ' ', AHexMessage) > 0 then begin
    SetLength(B, Length(R));
    for I := 0 to High(R) do begin
      try
        B[I] := BStrTo8('$' + R[I]);
      except
        Exit(False);
      end;
    end;
    PacketQueue.PreparePacket;
    for I := 0 to High(B) do
      PacketQueue.PacketBot.WriteBInt8(B[I]);
    PacketQueue.SendPacket;
  end;
  Exit(False);
end;

procedure TBBotPacketSender.SendMsg(const Msg: String; MsgType: BInt32);
var
  MsgData: TTibiaMessage;
begin
  if Msg <> '' then begin
    MsgData.Mode := Tibia.MessageModeFrom(MsgType);
    MsgData.Text := Msg;
    BBot.Events.RunSay(MsgData);
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($96);
    PacketQueue.PacketBot.WriteBInt8(MsgType);
    PacketQueue.PacketBot.WriteBStr16(Msg);
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.PartyShareExp(Shared: BBool);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($A8);
  PacketQueue.PacketBot.WriteBInt8(BIf(Shared, 1, 0));
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.PartyPassLeader(NewLeader: BInt32);
begin
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($A6);
  PacketQueue.PacketBot.WriteBInt32(NewLeader);
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.PrivateMesage(const Msg, Dest: String);
var
  MsgData: TTibiaMessage;
  MsgModeID: BInt8;
begin
  if (Msg <> '') and (Dest <> '') then begin
    if AdrSelected > TibiaVer900 then
      MsgModeID := $5
    else
      MsgModeID := $6;
    MsgData.Mode := Tibia.MessageModeFrom(MsgModeID);
    MsgData.Receiver := Dest;
    MsgData.Text := Msg;
    BBot.Events.RunSay(MsgData);
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($96);
    PacketQueue.PacketBot.WriteBInt8(MsgModeID);
    PacketQueue.PacketBot.WriteBStr16(Dest);
    PacketQueue.PacketBot.WriteBStr16(Msg);
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.SayMessage(AMsg: BStr);
begin
  SendMsg(AMsg, 1)
end;

procedure TBBotPacketSender.TradeChannelMessage(AMsg: BStr);
begin
  if AdrSelected <= TibiaVer1054 then
    ChannelMessage(AMsg, 5);
end;

procedure TBBotPacketSender.NPCChannelMessage(AMsg: BStr);
begin
  if AdrSelected >= TibiaVer1036 then
    SendMsg(AMsg, $C)
  else if AdrSelected >= TibiaVer872 then
    SendMsg(AMsg, $B)
  else
    SendMsg(AMsg, 4);
end;

procedure TBBotPacketSender.WhisperMessage(AMsg: BStr);
begin
  SendMsg(AMsg, 2);
end;

procedure TBBotPacketSender.YellMessage(AMsg: BStr);
begin
  SendMsg(AMsg, 3)
end;

procedure TBBotPacketSender.NPCSell(ID, SellCount, Amount: BUInt32);
begin
  if CheckItem(ID, 3) then begin
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($7B);
    PacketQueue.PacketBot.WriteBInt16(BInt16(ID));
    PacketQueue.PacketBot.WriteBInt8(BInt8(Amount));
    PacketQueue.PacketBot.WriteBInt8(BInt8(BMinMax(SellCount, 0, 100)));
    PacketQueue.PacketBot.WriteBInt8(1); { Sell Containers Only }
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.StopAction;
begin
  TibiaProcess.SendKey(VK_ESCAPE);
  BBot.Events.RunStop;
end;

procedure TBBotPacketSender.MoveItem(FromPos: BPos; Item, FromStack, Count: BInt32; ToPos: BPos);
begin
  if CheckItem(Item, 4) then begin
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($78);
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromPos.X));
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromPos.Y));
    PacketQueue.PacketBot.WriteBInt8(BInt8(FromPos.Z));
    PacketQueue.PacketBot.WriteBInt16(BInt16(Item));
    PacketQueue.PacketBot.WriteBInt8(BInt8(FromStack));
    PacketQueue.PacketBot.WriteBInt16(BInt16(ToPos.X));
    PacketQueue.PacketBot.WriteBInt16(BInt16(ToPos.Y));
    PacketQueue.PacketBot.WriteBInt8(BInt8(ToPos.Z));
    PacketQueue.PacketBot.WriteBInt8(BIf(Item = ItemID_Creature, 1, BMinMax(Count, 1, 100)));
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.TurnSelf(Direction: TTibiaDirection);
begin
  PacketQueue.PreparePacket;
  case Direction of
  tdNorth: PacketQueue.PacketBot.WriteBInt8($6F);
  tdEast: PacketQueue.PacketBot.WriteBInt8($70);
  tdSouth: PacketQueue.PacketBot.WriteBInt8($71);
  tdWest: PacketQueue.PacketBot.WriteBInt8($72);
else raise Exception.Create('Critical Invalid Turn direction');
  end;
  PacketQueue.SendPacket;
end;

procedure TBBotPacketSender.UseOnObject(FromPos: BPos; FromID, FromStack: BInt32; ToPos: BPos; ToID, ToStack: BInt32);
var
  UseOnItemData: TTibiaUseOnItem;
begin
  if CheckItem(FromID, 5) and CheckItem(ToID, 6) then begin
    UseOnItemData.FromPosition := FromPos;
    UseOnItemData.FromID := FromID;
    UseOnItemData.FromStack := FromStack;
    UseOnItemData.ToPosition := ToPos;
    UseOnItemData.ToID := ToID;
    UseOnItemData.ToStack := ToStack;
    BBot.Events.RunUseOnItem(UseOnItemData);
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($83);
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromPos.X));
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromPos.Y));
    PacketQueue.PacketBot.WriteBInt8(BInt8(FromPos.Z));
    PacketQueue.PacketBot.WriteBInt16(BInt16(FromID));
    PacketQueue.PacketBot.WriteBInt8(BInt8(FromStack));
    PacketQueue.PacketBot.WriteBInt16(BInt16(ToPos.X));
    PacketQueue.PacketBot.WriteBInt16(BInt16(ToPos.Y));
    PacketQueue.PacketBot.WriteBInt8(BInt8(ToPos.Z));
    PacketQueue.PacketBot.WriteBInt16(BInt16(ToID));
    PacketQueue.PacketBot.WriteBInt8(BInt8(ToStack));
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.UseItem(Position: BPos; Item, Stack, Index: BInt32);
var
  UseOnItemData: TTibiaUseOnItem;
begin
  if CheckItem(Item, 7) then begin
    UseOnItemData.FromPosition := Position;
    UseOnItemData.FromID := Item;
    UseOnItemData.FromStack := Stack;
    UseOnItemData.ToPosition := BPosXYZ(0, 0, 0);
    UseOnItemData.ToID := 0;
    UseOnItemData.ToStack := 0;
    BBot.Events.RunUseOnItem(UseOnItemData);
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($82);
    PacketQueue.PacketBot.WriteBInt16(BInt16(Position.X));
    PacketQueue.PacketBot.WriteBInt16(BInt16(Position.Y));
    PacketQueue.PacketBot.WriteBInt8(BInt8(Position.Z));
    PacketQueue.PacketBot.WriteBInt16(BInt16(Item));
    PacketQueue.PacketBot.WriteBInt8(BInt8(Stack));
    PacketQueue.PacketBot.WriteBInt8(BInt8(Index));
    PacketQueue.SendPacket;
  end;
end;

procedure TBBotPacketSender.TryLogout;
begin
  if (tsInBattle in Me.Status) or (tsCannotLogoutOrEnterProtectionZone in Me.Status) then
    Exit;
  TibiaProcess.SendClose;
  Sleep(60);
  TibiaProcess.SendKey(VK_RETURN);
end;

procedure TBBotPacketSender.ChannelMessage(const Msg: BStr; Channel: BInt32);
var
  MsgData: TTibiaMessage;
begin
  if Msg <> '' then begin
    MsgData.Mode := Tibia.MessageModeFrom(7);
    MsgData.Channel := Channel;
    MsgData.Text := Msg;
    BBot.Events.RunSay(MsgData);
    PacketQueue.PreparePacket;
    PacketQueue.PacketBot.WriteBInt8($96);
    PacketQueue.PacketBot.WriteBInt8(7);
    PacketQueue.PacketBot.WriteBInt16(BInt16(Channel));
    PacketQueue.PacketBot.WriteBStr16(Msg);
    PacketQueue.SendPacket;
  end;
end;

function TBBotPacketSender.CheckItem(const AID, AFunc: BInt32): BBool;
begin
  Result := BInRange(AID, 0, TibiaLastItem);
  if not Result then
    AddDebug('Attempt to send command with unitialized ID ' + BToStr(AID) + ' rejected');
end;

procedure TBBotPacketSender.ToggleMount(AIsMounted: BBool);
begin
  if AdrSelected < TibiaVer870 then
    Exit;
  PacketQueue.PreparePacket;
  PacketQueue.PacketBot.WriteBInt8($D4);
  PacketQueue.PacketBot.WriteBInt8(BIf(AIsMounted, 0, 1));
  PacketQueue.SendPacket;
end;

end.
