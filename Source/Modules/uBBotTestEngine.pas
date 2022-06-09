unit uBBotTestEngine;

interface

uses
  uBTypes,
  uBBotAction,
  uBVector;

{$IFNDEF Release}
{ . $DEFINE TestEngine }
{ . $DEFINE TestBotProtocol }
{$ENDIF}
type
  TBBotTestEngineTest = class
  private
    FName: BStr;
    function GetPassed: BBool; virtual; abstract;
  public
    constructor Create(const AName: BStr);

    property Name: BStr read FName write FName;
    property Passed: BBool read GetPassed;

    procedure Reset; virtual; abstract;
  end;

  TBBotTestEngineTestPacket = class(TBBotTestEngineTest)
  private
    FPacket: BStr;
    FBotMethod: BProc;
    FPassed: BBool;
    function GetPassed: BBool; override;
  public
    constructor Create(const AName, APacket: BStr; const ABotMethod: BProc);

    property BotMethod: BProc read FBotMethod write FBotMethod;
    property Packet: BStr read FPacket write FPacket;

    procedure CheckPacket(APacket: BStr);

    procedure Reset; override;
  end;

  TBBotTestEngineTestConditionCheck = class(TBBotTestEngineTest)
  private
    FChecker: BFunc<BBool>;
    function GetPassed: BBool; override;
  public
    constructor Create(const AName: BStr; const AChecker: BFunc<BBool>);

    property Checker: BFunc<BBool> read FChecker write FChecker;

    procedure Reset; override;
  end;

  TBBotTestEngineTests = BVector<TBBotTestEngineTest>;

  TBBotTestEngine = class(TBBotAction)
  private
    FCurrent: BInt32;
    FTests: TBBotTestEngineTests;
{$IFDEF TestEngine}
{$IFDEF TestBotProtocol}
    NextBotAction: BUInt32;
{$ENDIF}
    procedure AddTests;
    procedure AddPacket(AName, APacket: BStr; ABotWay: BProc);
    procedure AddChecker(AName: BStr; AChecker: BFunc<BBool>);
    procedure PrintPlayerStats;
    procedure PrintTestEngine;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    property Current: BInt32 read FCurrent;
    property Tests: TBBotTestEngineTests read FTests;

    procedure OnPacket(ABuffer: BPtr; ASize: BInt32);
  end;

implementation

{ TBBotTestEngine }

uses

  Classes,
  SysUtils,

  uTibiaProcess;

{$IFDEF TestEngine}

procedure TBBotTestEngine.AddChecker(AName: BStr; AChecker: BFunc<BBool>);
begin
  FTests.Add(TBBotTestEngineTestConditionCheck.Create(AName, AChecker));
end;

procedure TBBotTestEngine.AddPacket(AName, APacket: BStr; ABotWay: BProc);
begin
  FTests.Add(TBBotTestEngineTestPacket.Create(AName, APacket, ABotWay));
end;

procedure TBBotTestEngine.AddTests;
var
  AtkDigger: BProc;
  DiggerID: BStr;
  DiggerIDInt: BInt32;
  BL: TBBotCreature;
begin
  AddChecker('Position Digger.X+2',
    function(): BBool
    begin
      Result := (Me.Position.X = 32973) and (Me.Position.Y = 32087) and (Me.Position.Z = 6);
    end);
  AddChecker('No backpacks are open',
    function(): BBool
    begin
      Result := Tibia.TotalOpenContainers = 0;
    end);
  AddPacket('Use Y+1', '82 CD 80 58 7D 06 A1 01 00 00',
    procedure()
    var
      Map: TTibiaTiles;
    begin
      if Tiles(Map, Me.Position.X, Me.Position.Y + 1) then
        Map.Use;
    end);
  AddPacket('Mount (Press CTRL+R)', 'D4 01',
    procedure()
    begin
      BBot.PacketSender.ToggleMount(False);
    end);
  AddPacket('Use inventory Backpack', '82 FF FF 03 00 00 26 0B 00 00',
    procedure()
    begin
      Me.Inventory.Backpack.UseAsContainer;
    end);
  AddPacket('Say: hello World', '96 01 0B 00 68 65 6C 6C 6F 20 57 6F 72 6C 64',
    procedure()
    begin
      Me.Say('hello World');
    end);
  AddPacket('Whisper: <HASHTAG>w whisperz', '96 02 08 00 77 68 69 73 70 65 72 7A',
    procedure()
    begin
      Me.Whisper('whisperz');
    end);
  AddPacket('Yell: <HASHTAG>y hay', '96 03 03 00 68 61 79',
    procedure()
    begin
      Me.Yell('hay');
    end);
  AddPacket('Ads Say (open ADS channel and say): sell', '96 07 05 00 04 00 73 65 6C 6C',
    procedure()
    begin
      Me.TradeSay('sell');
    end);
  AddPacket('NPC Say (say HI to NPC and say): uooo', '96 0C 04 00 75 6F 6F 6F',
    procedure()
    begin
      Me.NPCSay('uooo');
    end);
  AddPacket('Private to Obi (write on default channel: <<*Obi* oie oie o>>): oie oie o',
    '96 05 03 00 4F 62 69 09 00 6F 69 65 20 6F 69 65 20 6F',
    procedure()
    begin
      Me.PrivateMessage('oie oie o', 'Obi');
    end);
  AddChecker('Container 1st item: 30 gold coin',
    function(): BBool
    begin
      Result := (ContainerAt(0, 0) <> nil) and ContainerAt(0, 0).Open and (ContainerAt(0, 0).ID = ItemID_GoldCoin) and
        (ContainerAt(0, 0).Count = 30);
    end);
  AddChecker('Container 2st item: rope',
    function(): BBool
    begin
      Result := (ContainerAt(0, 1) <> nil) and ContainerAt(0, 1).Open and (ContainerAt(0, 1).ID = ItemID_Rope);
    end);
  AddChecker('Container 3st item: 100 gold coins',
    function(): BBool
    begin
      Result := (ContainerAt(0, 2) <> nil) and ContainerAt(0, 2).Open and (ContainerAt(0, 2).ID = ItemID_GoldCoin) and
        (ContainerAt(0, 2).Count = 100);
    end);
  AddPacket('Throw 2 gold from CT1,1 to Y+1', '78 FF FF 40 00 00 D7 0B 00 CD 80 58 7D 06 02',
    procedure()
    begin
      ContainerAt(0, 0).ToGround(BPosXYZ(Me.Position.X, Me.Position.Y + 1, Me.Position.Z), 2);
    end);
  AddPacket('Pickup 2 gold from Y+1 to CT1,1 gold coins', '78 CD 80 58 7D 06 D7 0B 01 FF FF 40 00 00 02',
    procedure()
    var
      Map: TTibiaTiles;
    begin
      if Tiles(Map, Me.Position.X, Me.Position.Y + 1) then
        if Map.ID = ItemID_GoldCoin then
          ContainerAt(0, 1).PullHere(Map);
    end);
  AddPacket('Split 30 gold, move 15 to rope', '78 FF FF 40 00 00 D7 0B 00 FF FF 40 00 01 0F',
    procedure()
    begin
      ContainerAt(0, 1).PullHere(ContainerAt(0, 0), 15);
    end);
  AddPacket('Throw Spike Sword from Left Hand to 100 Gold Coins', '78 FF FF 06 00 00 C7 0C 00 FF FF 40 00 03 01',
    procedure()
    begin
      ContainerAt(0, 3).PullHere(Me.Inventory.Left);
    end);
  AddPacket('Push Spike Sword to left hand from CT1,1', '78 FF FF 40 00 00 C7 0C 00 FF FF 06 00 00 01',
    procedure()
    begin
      ContainerAt(0, 0).ToBody(SlotLeft);
    end);
  AddChecker('Second backpack is open',
    function(): BBool
    begin
      Result := (ContainerAt(1, 0) <> nil) and ContainerAt(1, 0).Open and (ContainerAt(1, 0).Capacity = 20);
    end);
  AddPacket('Thrown first 15 gold coins to CT2,0', '78 FF FF 40 00 00 D7 0B 00 FF FF 41 00 00 0F',
    procedure()
    begin
      if ContainerAt(0, 0).ID = ItemID_GoldCoin then
        ContainerAt(1, 19).PullHere(ContainerAt(0, 0));
    end);
  AddPacket('Turn north', '6F',
    procedure()
    begin
      Me.Turn(tdNorth);
    end);
  AddPacket('Turn east', '70',
    procedure()
    begin
      Me.Turn(tdEast);
    end);
  AddPacket('Turn south', '71',
    procedure()
    begin
      Me.Turn(tdSouth);
    end);
  AddPacket('Turn west', '72',
    procedure()
    begin
      Me.Turn(tdWest);
    end);
  AddChecker('Open trade window',
    function(): BBool
    begin
      Result := BBot.TradeWindow.IsOpen;
    end);
  Me.Reload;
  if Me.ID = 0 then
    raise Exception.Create('Unable to gather Me.ID');
  AddPacket('Use mana potion on self', '84 FF FF 00 00 00 0C 01 00 ' + BStrFromBuffer8(@Me.ID, 4),
    procedure()
    begin
      Me.UseOnMe(ItemID_ManaPotion);
    end);
  AddPacket('Sell 3x empty potion', '7B 1D 01 00 03 01',
    procedure()
    var
      It: TBBotTradeWindowItems.It;
    begin
      It := BBot.TradeWindow.Item(ItemID_PotionFlaskSmall, -1);
      if It <> nil then
        BBot.PacketSender.NPCSell(ItemID_PotionFlaskSmall, 3, It^.Amount);
    end);
  AddPacket('Buy 3x mana potion (ignore cap)', '7A 0C 01 00 03 01 00',
    procedure()
    var
      It: TBBotTradeWindowItems.It;
    begin
      It := BBot.TradeWindow.Item(ItemID_ManaPotion, -1);
      if It <> nil then
        BBot.PacketSender.NPCBuy(ItemID_ManaPotion, 3, It^.Amount, True, False);
    end);
  AddPacket('Close CT1', '87 00',
    procedure()
    begin
      ContainerAt(0, 0).Close();
    end);
  AddPacket('Close CT2', '87 01',
    procedure()
    begin
      ContainerAt(1, 0).Close();
    end);
  AddChecker('Rope is on CT1,2',
    function(): BBool
    begin
      Result := (ContainerAt(0, 1) <> nil) and (ContainerAt(0, 1).ID = ItemID_Rope);
    end);
  AddPacket('Use rope on Y+1', '83 FF FF 40 00 01 BB 0B 01 CD 80 58 7D 06 A1 01 00',
    procedure()
    var
      Map: TTibiaTiles;
    begin
      if Tiles(Map, Me.Position.X, Me.Position.Y + 1) then
        Map.UseOn(ItemID_Rope);
    end);
  AtkDigger := procedure()
    var
      Digger: TBBotCreature;
    begin
      Digger := BBot.Creatures.Find('Digger');
      if Digger <> nil then
        Digger.Attack;
    end;
  AddChecker('Just logged in',
    function(): BBool
    begin
      Result := not BBot.JustLoggedIn.JustLoggedIn;
    end);
  AddChecker('Digger is found',
    function(): BBool
    begin
      BBot.Creatures.Reload;
      BL := BBot.Creatures.Find('Digger');
      if BL = nil then begin
        Result := False;
      end else begin
        DiggerIDInt := BL.ID;
        DiggerID := BStrFromBuffer8(@DiggerIDInt, 4);
        AddPacket('Attack Digger 1', 'A1 ' + DiggerID + '01 00 00 00', AtkDigger);
        AddPacket('Attack Digger 2', 'A1 ' + DiggerID + '02 00 00 00', AtkDigger);
        AddPacket('Attack Digger 3', 'A1 ' + DiggerID + '03 00 00 00', AtkDigger);
        Result := True;
      end;
    end);
end;

procedure TBBotTestEngine.PrintPlayerStats;
var
  HUD: TBBotHUD;
  Skill: TTibiaSkill;
  Slot: TTibiaSlot;
  CT: TTibiaContainer;
  AtkID: BInt32;
begin
  HUD := TBBotHUD.Create(bhgTestEngine);
  HUD.Color := HUDGrayColor;
  HUD.AlignTo(bhaRight, bhaTop);
  HUD.Print('[ Player Stats ]', $FFA0A0);
  HUD.PrintGray(BFormat('HP: %d/%d Mana: %d/%d Exp: %d Level: %d (%d%%)', [Me.HP, Me.HPMax, // 1
    Me.Mana, Me.ManaMax, // 2
    Me.Experience, // 3
    Me.Level, Me.LevelPercent // 4
    ]));

  if AdrSelected >= TibiaVer860 then
    TibiaProcess.Read(TibiaAddresses.AdrAttackID, 4, @AtkID)
  else
    AtkID := 0;

  HUD.PrintGray(BFormat('Cap: %d Soul: %d Stamina: %d Flags: %d', [Me.Capacity, Me.Soul, Me.Stamina,
    BInt32(Me.Status)]));
  HUD.PrintGray(BFormat('AtkSeq: %d AttackId: %d', [AtkID, Me.TargetID]));

  // HUD.PrintGray(BFormat('Account: %s Password: %s..%s', [TibiaState^.Account, BStrCopy(TibiaState^.Password, 1, 3),
  // BStrCopy(TibiaState^.Password, Length(BPChar(@TibiaState^.Password)) - 3, 3)]));
  HUD.Print(' ');
  HUD.Print('[ Player Skills ]', $FFA0A0);
  for Skill := SkillFirst to SkillLast do
    HUD.PrintGray(BFormat('%s %d (%d%%) ', [SkillToStr(Skill), Me.SkillLevel[Skill], Me.SkillPercent[Skill]]));
  HUD.Print(' ');
  HUD.Print('[ Player Inventory ]', $FFA0A0);
  for Slot := SlotFirst to SlotLast do
    if Me.Inventory.GetSlot(Slot).ID <> 0 then
      HUD.PrintGray(BFormat('%s: %s %d %d', [SlotToStr(Slot), Me.Inventory.GetSlot(Slot).Name,
        Me.Inventory.GetSlot(Slot).ID, Me.Inventory.GetSlot(Slot).Count]));
  HUD.Print(' ');
  HUD.Print('[ Player Containers ]', $FFA0A0);
  CT := ContainerFirst;
  while CT <> nil do begin
    if (CT.Prev = nil) or (CT.Prev.Container <> CT.Container) then begin
      HUD.PrintGray(BFormat('%s %d/%d', [CT.ContainerName, CT.Items, CT.Capacity]));
    end;
    HUD.PrintGray(BFormat('-> %s %d %d', [CT.Name, CT.ID, CT.Count]));
    CT := CT.Next;
  end;
  HUD.Free;
end;

procedure TBBotTestEngine.PrintTestEngine;
var
  HUD: TBBotHUD;
  I: BInt32;
begin
  HUD := TBBotHUD.Create(bhgTestEngine);
  HUD.AlignTo(bhaLeft, bhaTop);
  HUD.Print(BFormat('[ Protocol Test %d%% ]', [BCeil((100 * FCurrent) / FTests.Count)]), $FFA0A0);
  HUD.RelativeX := 4;
  for I := BMax(0, FCurrent - 5) to BMin(FCurrent + 4, FTests.Count - 1) do
    HUD.Print(BIf(FCurrent = I, '  [CURRENT] ', '') + FTests[I].Name, BIf(I < FCurrent, $AAFFAA, HUDGrayColor));

  HUD.Print(' ');
  HUD.Print(' ');
  HUD.Print(' ');
  HUD.OnClick := 2221;
  HUD.PrintGray('[ Click here to reset ]');

  HUD.Free;
end;
{$ENDIF}

constructor TBBotTestEngine.Create;
begin
  inherited Create('Test Engine', 200);
  FCurrent := 0;
{$IFDEF TestBotProtocol}
  NextBotAction := 0;
{$ENDIF}
  FTests := TBBotTestEngineTests.Create(
    procedure(It: TBBotTestEngineTests.It)
    begin
      It^.Free;
    end);
end;

destructor TBBotTestEngine.Destroy;
begin
  FTests.Free;
  inherited;
end;

procedure TBBotTestEngine.OnPacket(ABuffer: BPtr; ASize: BInt32);
begin
  if (FCurrent < Tests.Count) and (Tests[FCurrent]^ is TBBotTestEngineTestPacket) then
    TBBotTestEngineTestPacket(Tests[FCurrent]^).CheckPacket(BStrFromBuffer8(ABuffer, ASize));
end;

procedure TBBotTestEngine.OnInit;
begin
  inherited;
{$IFDEF TestEngine}
{$IFDEF TestBotProtocol}
  BBot.Events.OnBotPacket.Add(OnPacket);
{$ELSE}
  BBot.Events.OnClientPacket.Add(OnPacket);
{$ENDIF}
  BBot.Events.OnMenu.Add(
    procedure(AClickID, AData: BUInt32)
    begin
      FCurrent := 0;
      Tests.ForEach(
        procedure(AIt: BVector<TBBotTestEngineTest>.It)
        begin
          AIt^.Reset;
        end);
    end);
  AddTests;
{$ENDIF}
end;

procedure TBBotTestEngine.Run;
begin
{$IFDEF TestEngine}
  if FCurrent < FTests.Count then begin
    if FTests[FCurrent]^.Passed then
      Inc(FCurrent)
{$IFNDEF TestBotProtocol}
        ;
{$ELSE}
    else if (Tick > NextBotAction) and (FTests[FCurrent]^ is TBBotTestEngineTestPacket) then begin
      TBBotTestEngineTestPacket(FTests[FCurrent]^).BotMethod();
      NextBotAction := Tick + 1000;
    end;
{$ENDIF}
  end;
  HUDRemoveAll;
  PrintPlayerStats;
  PrintTestEngine;
{$ENDIF}
end;

{ TBBotTestEngineTest }

constructor TBBotTestEngineTest.Create(const AName: BStr);
begin
  FName := AName;
end;

{ TBBotTestEngineTestPacket }

procedure TBBotTestEngineTestPacket.CheckPacket(APacket: BStr);
begin
  FPassed := FPassed or BStrEqual(BTrim(APacket), BTrim(FPacket))
end;

constructor TBBotTestEngineTestPacket.Create(const AName, APacket: BStr; const ABotMethod: BProc);
begin
  inherited Create(AName);
  FPacket := APacket;
  FBotMethod := ABotMethod;
  FPassed := False;
end;

function TBBotTestEngineTestPacket.GetPassed: BBool;
begin
  Result := FPassed;
end;

procedure TBBotTestEngineTestPacket.Reset;
begin
  FPassed := False;
end;

{ TBBotTestEngineTestConditionCheck }

constructor TBBotTestEngineTestConditionCheck.Create(const AName: BStr; const AChecker: BFunc<BBool>);
begin
  inherited Create(AName);
  FChecker := AChecker;
end;

function TBBotTestEngineTestConditionCheck.GetPassed: BBool;
begin
  Result := Checker;
end;

procedure TBBotTestEngineTestConditionCheck.Reset;

begin

end;

end.
