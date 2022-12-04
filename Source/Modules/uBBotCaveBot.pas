unit uBBotCaveBot;

interface

uses
  uBTypes,
  uBBotAction,

  Math,
  SysUtils,
  Classes,
  uBattlelist,
  uContainer,
  uItem,
  uTibiaDeclarations,
  StrUtils,
  uBBotWalkerTask,
  uItemLoader,
  uBBotGUIMessages;

const
  BBotCavebotNoKillMaxStand = 10000;
  BBotCavebotNoKillMaxStandVar = 'BBot.Cavebot.NoKillMaxStandTime';
  BBotCavebotSmartMapClickAnalyzeCount = 6;
  BBotCavebotSmartMapClickAnalyzeCountVar =
    'BBot.Cavebot.SmartClick.AnalyzeCount';
  BBotCavebotSmartMapClickAnalyzeMaxAttacks = 2;
  BBotCavebotSmartMapClickAnalyzeMaxAttacksVar =
    'BBot.Cavebot.SmartClick.MaxAttacks';

type
  EBBotCavebot = class(Exception)
  public
    constructor Create(Name: BStr; E: Exception);
  end;

  TBBotCavebotNormalNode = class;

  TBBotCaveBot = class(TBBotAction)
  private
    FLearnIgnoreNextFrom: BBool;
    LastLearn: BPos;
    FLearn: BBool;
    FEnabled: BBool;
    FRope: BInt32;
    FShovel: BInt32;
    FNoKill: BBool;
    FCurrent: TBBotCavebotNormalNode;
    FFirstNode: TBBotCavebotNormalNode;
    FLastNode: TBBotCavebotNormalNode;
    FStartItemIndex: BInt32;
    FNoKillMaxStandTime: BUInt32;
    FDebug: BBool;
    FLoadErrorIndex: BInt32;
    FIsOpennigCorpse: BBool;
    FWithdrawRounding: BInt32;
    FSmartMapClickAnalyzeCount: BUInt32;
    FSmartMapClickAnalyzeMaxAttacks: BUInt32;
    FSmartMapClick: BBool;
    procedure SetEnabled(const Value: boolean);
    procedure SetCurrent(const Value: TBBotCavebotNormalNode);
    procedure SetLearn(const Value: boolean);
    function GetIsNoKill: BBool;
    function GetIsWaiting: BBool;
    function ShouldUseMapClick: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    property Debug: BBool read FDebug write FDebug;
    property Enabled: BBool read FEnabled write SetEnabled;
    property Learn: BBool read FLearn write SetLearn;
    property SmartMapClick: BBool read FSmartMapClick write FSmartMapClick;
    property NoKill: BBool read FNoKill write FNoKill;
    property IsNoKill: BBool read GetIsNoKill;
    property IsWaiting: BBool read GetIsWaiting;
    property WithdrawRounding: BInt32 read FWithdrawRounding
      write FWithdrawRounding;

    property IsOpenningCorpse: BBool read FIsOpennigCorpse
      write FIsOpennigCorpse;

    property Current: TBBotCavebotNormalNode read FCurrent write SetCurrent;
    property FirstNode: TBBotCavebotNormalNode read FFirstNode write FFirstNode;
    property LastNode: TBBotCavebotNormalNode read FLastNode write FLastNode;

    property StartItemIndex: BInt32 read FStartItemIndex write FStartItemIndex;
    property LoadErrorIndex: BInt32 read FLoadErrorIndex write FLoadErrorIndex;

    procedure ClearWaypoint;
    procedure LoadWaypoint(List: TStrings);
    procedure FindNearestPoint;

    function GoLabel(ALabel: BStr): BBool;
    procedure GoStart;

    procedure OnInit; override;
    procedure Run; override;
    procedure RunPoint;

    property NoKillMaxStandTime: BUInt32 read FNoKillMaxStandTime;
    property SmartMapClickAnalyzeCount: BUInt32 read FSmartMapClickAnalyzeCount;
    property SmartMapClickAnalyzeMaxAttacks: BUInt32
      read FSmartMapClickAnalyzeMaxAttacks;

    property Rope: BInt32 read FRope write FRope;
    property Shovel: BInt32 read FShovel write FShovel;

    function WalkTo(APosition: BPos; ADistance: BUInt32): BBool;

    procedure OnWalk(FromPos: BPos);
    procedure DoLearn(FromPos, ToPos: BPos);

    function FullCheck(const AExpr: BStr): BBool;
    property LearnIgnoreNextFrom: BBool read FLearnIgnoreNextFrom
      write FLearnIgnoreNextFrom;

    function GoFloorUp(const Position: BPos): BBool;
    function GoFloorDown(const Position: BPos): BBool;
  end;

  TBBotCavebotNodeState = (bcnsReach, bcnsReached, bcnsOk, bcnsError);

  TBBotCavebotNormalNode = class(TBBotRunnable)
  private
    FState: TBBotCavebotNodeState;
    FPosition: BPos;
    FName: BStr;
    FNext: TBBotCavebotNormalNode;
    FPrev: TBBotCavebotNormalNode;
    FWait: BLock;
    FParam: BStr;
    FIndex: BInt32;
    FCavebot: TBBotCaveBot;
    FReachErrors: BInt32;
    function GetParam: BStr;
    function GetParamInt: BInt32;
    function GetDistanceToSelf: BInt32;
  protected
    procedure SetState(AState: TBBotCavebotNodeState);
    function DoReach: BBool;
    procedure WalkError;
    function GoFloorUp: BBool;
    function GoFloorDown: BBool;
    function GoPosition: BBool; virtual;
    function IsReached: BBool; virtual;
  public
    constructor Create(ACavebot: TBBotCaveBot; AName: BStr; APosition: BPos;
      AParam: BStr; AIndex: BInt32);
    destructor Destroy; override;

    procedure DoRun;
    procedure OnStart; virtual;
    procedure OnPreRun; virtual;

    property DistanceToSelf: BInt32 read GetDistanceToSelf;

    property Name: BStr read FName;
    property Index: BInt32 read FIndex;
    property Position: BPos read FPosition;
    property State: TBBotCavebotNodeState read FState;
    property Wait: BLock read FWait;

    property Cavebot: TBBotCaveBot read FCavebot;
    property ReachErrors: BInt32 read FReachErrors write FReachErrors;

    property Param: BStr read GetParam write FParam;
    property ParamInt: BInt32 read GetParamInt;

    property Next: TBBotCavebotNormalNode read FNext write FNext;
    property Prev: TBBotCavebotNormalNode read FPrev write FPrev;
  end;

  TBBotCavebotFixedNode = class(TBBotCavebotNormalNode)
  protected
    function GoPosition: BBool; override;
    function IsReached: BBool; override;
  end;

  TBBotCavebotNodePoint = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeFixed = class(TBBotCavebotFixedNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeTeleport = class(TBBotCavebotNormalNode)
  private
    TeleportPos: BPos;
  public
    procedure OnStart; override;
    procedure OnPreRun; override;
    procedure Run; override;
  end;

  TBBotCavebotNodeLabel = class(TBBotCavebotNormalNode)
  public
    procedure OnStart; override;
    procedure Run; override;
  end;

  TBBotCavebotNodeSay = class(TBBotCavebotFixedNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeNPCSay = class(TBBotCavebotFixedNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeDepositer = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeDelay = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeGoLabel = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeGoRandomLabel = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeMacro = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeDropLoot = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeMapTool = class(TBBotCavebotNormalNode)
  private
    FUseID: BUInt32;
    FTargetID: BUInt32;
    FTargetPos: BPos;
  public
    property TargetPos: BPos read FTargetPos;
    property TargetID: BUInt32 read FTargetID;
    property UseID: BUInt32 read FUseID;

    procedure OnStart; override;
    procedure OnPreRun; override;
    procedure Run; override;
  end;

  TBBotCavebotNodeFullCheck = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeResetBackpacks = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeNoKill = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeOpenCorpse = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeResetTasks = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeWithdraw = class(TBBotCavebotFixedNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeSupliesWithdraw = class(TBBotCavebotNormalNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeBuy = class(TBBotCavebotFixedNode)
  public
    procedure Run; override;
  end;

  TBBotCavebotNodeSell = class(TBBotCavebotFixedNode)
  public
    procedure Run; override;
  end;

implementation

uses
  uSelf,
  uTiles,
  BBotEngine,
  uRegex,
  uHUD,
  uMain,

  uAStar,
  uDistance,
  uBBotTradeWindow,
  uBBotWalkerPathFinderPosition;

{ TBBotCaveBot }

procedure TBBotCaveBot.ClearWaypoint;
var
  Curr, Tmp: TBBotCavebotNormalNode;
begin
  Curr := FirstNode;
  if Assigned(Curr) then
  begin
    LastNode.Next := nil;
    FFirstNode := nil;
    FLastNode := nil;
    FCurrent := nil;
    while Curr <> nil do
    begin
      Tmp := Curr;
      Curr := Curr.Next;
      Tmp.Free;
    end;
  end;
end;

constructor TBBotCaveBot.Create;
begin
  inherited Create('Cavebot', 1);
  FLearn := False;
  FSmartMapClick := False;
  FLearnIgnoreNextFrom := False;
  FEnabled := False;
  FDebug := False;
  FWithdrawRounding := 0;
  Rope := ItemID_Rope;
  Shovel := ItemID_Shovel;
  FIsOpennigCorpse := True;

  FirstNode := nil;
  LastNode := nil;
  Current := nil;

  NoKill := False;

  FStartItemIndex := -1;

  FNoKillMaxStandTime := BBotCavebotNoKillMaxStand;
  FSmartMapClickAnalyzeCount := BBotCavebotSmartMapClickAnalyzeCount;
  FSmartMapClickAnalyzeMaxAttacks := BBotCavebotSmartMapClickAnalyzeMaxAttacks;
end;

destructor TBBotCaveBot.Destroy;
begin
  ClearWaypoint;
  inherited;
end;

procedure TBBotCaveBot.DoLearn(FromPos, ToPos: BPos);
  procedure LearnAdd(P: BPos);
  var
    HUD: TBBotHUD;
    MsgPos: TBBotGUIMessageAddCavebotPoint;
  begin
    if (P <> LastLearn) and (P.X <> 0) and (P.Y <> 0) then
    begin
      MsgPos := TBBotGUIMessageAddCavebotPoint.Create;
      MsgPos.Position := P;
      FMain.AddBBotMessage(MsgPos);
      HUD := TBBotHUD.Create(bhgAny);
      HUD.SetPosition(P);
      HUD.Expire := 2000;
      HUD.Print('[ Point ]', $FFFFFF);
      HUD.Free;
      LastLearn := P;
    end;
  end;

var
  AddTo, AddFrom: BBool;
begin
  if not Learn then
    Exit;
  AddFrom := (not FLearnIgnoreNextFrom) and
    ((FromPos.Z <> ToPos.Z) or (not Me.CanSee(LastLearn)) or
    (not InRange(BBot.Walker.ApproachToCost(LastLearn, 8), 0, 5)));
  FLearnIgnoreNextFrom := False;
  AddTo := (FromPos.Z <> ToPos.Z);
  if AddFrom then
    LearnAdd(FromPos);
  if AddTo then
    LearnAdd(ToPos);
end;

procedure TBBotCaveBot.Run;
begin
  if Enabled and (not(BBot.Depositer.Working or BBot.Withdraw.isWorking)) and
    (Current <> nil) then
  begin
    if (Current.DistanceToSelf < 2) and (Current is TBBotCavebotNodePoint) and
      (Current.Next is TBBotCavebotNodePoint) and
      (Current.Position.Z = Me.Position.Z) and
      (Current.Position.Z = Current.Next.Position.Z) then
    begin
      Current := Current.Next;
      if Debug then
        AddDebug('Skipping point, next reached');
    end;
  end;
end;

procedure TBBotCaveBot.RunPoint;
begin
  if Enabled and (not(BBot.Depositer.Working or BBot.Withdraw.isWorking)) and
    (Current <> nil) and (not BBot.ServerSave.IsServerSave) and
    (not Current.Wait.Locked) and (not BBot.Looter.IsLooting) and
    (not Me.LoggingOut) and (not BBot.Backpacks.isWorking) and
    (not BBot.ManaDrinker.PauseCavebot) then
    if BBot.Walker.Task = nil then
    begin
      if Current.State = bcnsOk then
        Current := Current.Next
      else if Current.State = bcnsError then
        FindNearestPoint;
      try
        Current.DoRun;
      except
        on E: Exception do
          if FCurrent = nil then
            raise EBBotCavebot.Create('NULLNODE', E)
          else
            raise EBBotCavebot.Create(Current.Name, E)
        else
          raise;
      end;
    end;
end;

procedure TBBotCaveBot.FindNearestPoint;
var
  N, B: TBBotCavebotNormalNode;
  D: BInt32;
begin
  N := FirstNode.Next;
  B := N;
  D := MaxInt;
  while N <> FirstNode do
  begin
    if ((N.DistanceToSelf < D) and (StartItemIndex = -1)) or
      (StartItemIndex = N.Index) then
    begin
      D := N.DistanceToSelf;
      B := N;
    end;
    N := N.Next;
  end;
  Current := B;
  FStartItemIndex := -1;
end;

function TBBotCaveBot.FullCheck(const AExpr: BStr): BBool;
var
  R, Ret, Ret2: BStrArray;
  CH, CC, I, J, N: BInt32;
  V, OP: BStr;
  Creature: TBBotCreature;
begin
  Result := False;
  if BStrSplit(Ret, ';', ';' + BBot.Macros.VarsText(AExpr) + ';') > 0 then
  begin
    for I := 0 to High(Ret) do
    begin
      if BSimpleRegex('#([\w~@ ]+)(<|<=|>|>=|==)(\d+)#', '#' + Ret[I] + '#', R)
      then
      begin
        V := Trim(R[1]);
        OP := Trim(R[2]);
        CC := StrToIntDef(Trim(R[3]), 0);
        if BStrIsNumber(V) then
        begin
          CH := StrToIntDef(V, 0);
          if CH > 100 then
            CH := CountItem(CH);
        end
        else if BStrEqual(V, 'Cap') or BStrEqual(V, 'Capacity') then
          CH := Me.Capacity div 100
        else if BStrEqual(V, 'Balance') then
        begin
          CH := BBot.TradeWindow.BankBalance;
          if CH = -1 then
            Continue;
        end
        else if BStrEqual(V, 'IsTradeOpen') then
          CH := BIf(BBot.TradeWindow.IsOpen, 1, 0)
        else if BStrEqual(V, 'Soul') then
          CH := Me.Soul
        else if BStrEqual(V, 'Stamina') then
          CH := Me.Stamina
        else if BStrStart(V, '@') then
        begin
          CH := -1;
          Creature := BBot.Creatures.Find(BStrRight(V, '@'));
          if Creature <> nil then
            CH := Me.DistanceTo(Creature);
          if CH = -1 then
            Continue;
        end
        else
        begin
          CH := -1;
          if (Length(V) > 1) then
          begin
            if V[1] = '~' then
            begin
              CH := 0;
              BStrSplit(Ret2, '~', V);
              for J := 0 to High(Ret2) do
              begin
                N := BBot.KillStats.TaskKills(Ret2[J]);
                if N <> -1 then
                  Inc(CH, N);
              end;
            end
            else
              CH := BBot.SupliesStats.Suplies(V);
          end;
          if CH = -1 then
            Continue;
        end;
        Result := ((OP = '>') and (CH > CC)) or ((OP = '<') and (CH < CC)) or
          ((OP = '<=') and (CH <= CC)) or ((OP = '>=') and (CH >= CC)) or
          ((OP = '==') and (CH = CC));
        if Result then
          Break;
      end;
    end;
  end;
end;

function TBBotCaveBot.GetIsNoKill: BBool;
begin
  Result := FNoKill and (BBot.StandTime < NoKillMaxStandTime);
end;

function TBBotCaveBot.GetIsWaiting: BBool;
begin
  Result := (Current <> nil) and (Current.Wait.Locked);
end;

function TBBotCaveBot.GoFloorDown(const Position: BPos): BBool;
var
  Map: TTibiaTiles;
  Origin: BPos;
begin
  if SQMDistance(Me.Position.X, Me.Position.Y, Position.X, Position.Y) <= 5 then
  begin
    Origin := BPosXYZ((Position.X + Me.Position.X) div 2,
      (Position.Y + Me.Position.Y) div 2, Me.Position.Z);
    if TilesSearch(Map, Origin, 5, False,
      function: BBool
      begin
        Result := Map.ChangeLevelDown;
      end) then
      if Me.Position = Map.Position then
      begin
        BBot.Walker.RandomStep;
        Exit(True);
      end
      else if Map.Cleanup then
      begin
        Exit(True);
      end
      else if Map.ChangeLevelHole then
      begin
        if Current <> nil then
          Current.Wait.Lock;
        Map.Use;
        Exit(True);
      end
      else if Map.ChangeLevelShovel then
      begin
        if Current <> nil then
          Current.Wait.Lock;
        Map.UseOn(Shovel);
        Exit(True);
      end
      else if WalkTo(Map.Position, 0) then
        Exit(True);
  end;
  Result := False;
end;

function TBBotCaveBot.GoFloorUp(const Position: BPos): BBool;
var
  Map: TTibiaTiles;
  Origin: BPos;
begin
  if SQMDistance(Me.Position.X, Me.Position.Y, Position.X, Position.Y) <= 5 then
  begin
    Origin := BPosXYZ((Position.X + Me.Position.X) div 2,
      (Position.Y + Me.Position.Y) div 2, Me.Position.Z);
    if TilesSearch(Map, Origin, 5, False,
      function: BBool
      begin
        Result := Map.ChangeLevelUp;
      end) then
      if Me.Position = Map.Position then
      begin
        BBot.Walker.RandomStep;
        Exit(True);
      end
      else if Map.Cleanup then
      begin
        Exit(True);
      end
      else if Map.ChangeLevelLadder then
      begin
        if Current <> nil then
          Current.Wait.Lock;
        Map.Use;
        Exit(True);
      end
      else if Map.ChangeLevelRope then
      begin
        if Current <> nil then
          Current.Wait.Lock;
        Map.UseOn(Rope);
        Exit(True);
      end
      else if WalkTo(Map.Position, 0) then
        Exit(True);
  end;
  Result := False;
end;

function TBBotCaveBot.GoLabel(ALabel: BStr): BBool;
var
  P: TBBotCavebotNormalNode;
begin
  P := Current.Next;
  while P <> Current do
  begin
    if P is TBBotCavebotNodeLabel then
      if P.Param = ALabel then
      begin
        Current := P;
        Result := True;
        Exit;
      end;
    P := P.Next;
  end;
  Result := False;
end;

procedure TBBotCaveBot.GoStart;
begin
  Current := FirstNode;
end;

procedure TBBotCaveBot.LoadWaypoint(List: TStrings);
var
  I: BInt32;
  Next: TBBotCavebotNormalNode;
  Res: BStrArray;
  M, S, L: BStr;
  P: BPos;
begin
  LoadErrorIndex := -1;
  FEnabled := False;
  ClearWaypoint;
  Next := nil;
  for I := 0 to List.Count - 1 do
  begin
    L := List.Strings[I];
    if BSimpleRegex('^(\w+) \((\d{1,7} \d{1,7} \d{1,2})(?::(.*?))?\)$', L, Res)
    then
    begin
      M := Res[1];
      P := BPos(Res[2]);
      if Length(Res) = 4 then
        S := Res[3]
      else
        S := '';
      if M = 'Point' then
        Next := TBBotCavebotNodePoint.Create(Self, L, P, S, I)
      else if M = 'Fixed' then
        Next := TBBotCavebotNodeFixed.Create(Self, L, P, S, I)
      else if M = 'Teleport' then
        Next := TBBotCavebotNodeTeleport.Create(Self, L, P, S, I)
      else if M = 'Label' then
        Next := TBBotCavebotNodeLabel.Create(Self, L, P, S, I)
      else if M = 'Say' then
        Next := TBBotCavebotNodeSay.Create(Self, L, P, S, I)
      else if M = 'SayNPC' then
        Next := TBBotCavebotNodeNPCSay.Create(Self, L, P, S, I)
      else if M = 'NPCSay' then
        Next := TBBotCavebotNodeNPCSay.Create(Self, L, P, S, I)
      else if M = 'Depositer' then
        Next := TBBotCavebotNodeDepositer.Create(Self, L, P, S, I)
      else if M = 'Delay' then
        Next := TBBotCavebotNodeDelay.Create(Self, L, P, S, I)
      else if M = 'GoLabel' then
        Next := TBBotCavebotNodeGoLabel.Create(Self, L, P, S, I)
      else if M = 'ApproachNPC' then
        Next := TBBotCavebotNodeGoLabel.Create(Self, L, P, S, I)
      else if M = 'GoRandomLabel' then
        Next := TBBotCavebotNodeGoRandomLabel.Create(Self, L, P, S, I)
      else if M = 'Macro' then
        Next := TBBotCavebotNodeMacro.Create(Self, L, P, S, I)
      else if M = 'DropLoot' then
        Next := TBBotCavebotNodeDropLoot.Create(Self, L, P, S, I)
      else if M = 'MapTool' then
        Next := TBBotCavebotNodeMapTool.Create(Self, L, P, S, I)
      else if M = 'FullCheck' then
        Next := TBBotCavebotNodeFullCheck.Create(Self, L, P, S, I)
      else if M = 'FullCheckLabel' then
        Next := TBBotCavebotNodeFullCheck.Create(Self, L, P, S, I)
      else if M = 'ResetBackpacks' then
        Next := TBBotCavebotNodeResetBackpacks.Create(Self, L, P, S, I)
      else if M = 'NoKill' then
        Next := TBBotCavebotNodeNoKill.Create(Self, L, P, S, I)
      else if M = 'OpenCorpse' then
        Next := TBBotCavebotNodeOpenCorpse.Create(Self, L, P, S, I)
      else if M = 'ResetTasks' then
        Next := TBBotCavebotNodeResetTasks.Create(Self, L, P, S, I)
      else if M = 'Withdraw' then
        Next := TBBotCavebotNodeWithdraw.Create(Self, L, P, S, I)
      else if M = 'SupliesWithdraw' then
        Next := TBBotCavebotNodeSupliesWithdraw.Create(Self, L, P, S, I)
      else if M = 'Buy' then
        Next := TBBotCavebotNodeBuy.Create(Self, L, P, S, I)
      else if M = 'Sell' then
        Next := TBBotCavebotNodeSell.Create(Self, L, P, S, I);
      Next.Prev := LastNode;
      if FirstNode = nil then
        FirstNode := Next
      else
        LastNode.Next := Next;
      LastNode := Next;
      FirstNode.Prev := Next;
      LastNode.Next := FirstNode;
    end
    else
    begin
      ClearWaypoint;
      LoadErrorIndex := I;
      Break;
    end;
  end;
end;

procedure TBBotCaveBot.OnInit;
begin
  BBot.Events.OnWalk.Add(OnWalk);

  BBot.Macros.Registry.CreateSystemVariable(BBotCavebotNoKillMaxStandVar,
    BBotCavebotNoKillMaxStand).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FNoKillMaxStandTime := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable
    (BBotCavebotSmartMapClickAnalyzeCountVar,
    BBotCavebotSmartMapClickAnalyzeCount).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FSmartMapClickAnalyzeCount := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable
    (BBotCavebotSmartMapClickAnalyzeMaxAttacksVar,
    BBotCavebotSmartMapClickAnalyzeMaxAttacks).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FSmartMapClickAnalyzeMaxAttacks := AValue;
    end);
end;

procedure TBBotCaveBot.OnWalk(FromPos: BPos);
begin
  DoLearn(FromPos, Me.Position);
  if Enabled and (Current <> nil) and (FromPos.Z <> Me.Position.Z) then
    Current.Wait.Lock;
end;

procedure TBBotCaveBot.SetCurrent(const Value: TBBotCavebotNormalNode);
begin
  FCurrent := Value;
  if Assigned(FCurrent) then
    FCurrent.SetState(bcnsReach);
end;

procedure TBBotCaveBot.SetEnabled(const Value: boolean);
begin
  if FEnabled = Value then
    Exit;
  if Value and (FirstNode = nil) then
    Exit;
  FEnabled := Value;
  FNoKill := False;
  if Value then
  begin
    Learn := False;
    FindNearestPoint;
    if Current = nil then
      FEnabled := False;
  end
  else
    BBot.Walker.Stop;
end;

procedure TBBotCaveBot.SetLearn(const Value: boolean);
begin
  FLearn := Value;
  LastLearn := Me.Position;
end;

function TBBotCaveBot.ShouldUseMapClick: BBool;
var
  Node: TBBotCavebotNormalNode;
  I: BInt32;
  TotalAttacks: BUInt32;
  CreaturesOnScreen: BInt32;
  Map: TTibiaTiles;
begin
  if not SmartMapClick then
    Exit(False);
  CreaturesOnScreen := 0;
  BBot.Creatures.Traverse(
    procedure(Creature: TBBotCreature)
    begin
      if (not Creature.IsSelf) and Creature.IsAlive and Creature.IsOnScreen then
        Inc(CreaturesOnScreen);
    end);
  if CreaturesOnScreen > 1 then
    Exit(False);
  Node := Current;
  TotalAttacks := 0;
  for I := 1 to SmartMapClickAnalyzeCount do
  begin
    if not(Node is TBBotCavebotNodePoint) then
      Exit(False);
    if Node.Position.Z <> Me.Position.Z then
      Exit(False);
    Inc(TotalAttacks, BBot.PositionStatistics.AttackedCount(Node.Position));
    Node := Node.Next;
  end;
  if TotalAttacks > SmartMapClickAnalyzeMaxAttacks then
    Exit(False);
  if TilesSearch(Map, Me.Position, 7, False,
    function: BBool
    begin
      Exit(BIntIn(Map.ID, ItemsFirePoison));
    end) then
    Exit(False);

  Exit(True);
end;

function TBBotCaveBot.WalkTo(APosition: BPos; ADistance: BUInt32): BBool;
var
  Path: TBBotPathFinderPosition;
  Task: TBBotWalkerTask;
begin
  if BBot.Walker.Task = nil then
  begin
    Path := TBBotPathFinderPosition.Create('Cavebot WalkTo <' + BStr(APosition)
      + '> distance ' + BToStr(ADistance));
    Path.Position := APosition;
    Path.Distance := ADistance;
    Path.Execute;
    if Path.Cost <> PathCost_NotPossible then
    begin
      Task := TBBotWalkerTask.Create(Path);
      Task.UseMapClick := ShouldUseMapClick;
      BBot.Walker.Task := Task;
      if Debug then
      begin
        if Task.UseMapClick then
          AddDebug(Current.Position, 'CB.SmartMapClick')
        else
          AddDebug(Current.Position, 'CB.NormalWalk');
        AddDebug(Current.Next.Position, 'CB.Next')
      end;
      Exit(True);
    end
    else
      Path.Free;
  end;
  Exit(False);
end;

{ TBBotCavebotNode }

constructor TBBotCavebotNormalNode.Create(ACavebot: TBBotCaveBot; AName: BStr;
APosition: BPos; AParam: BStr; AIndex: BInt32);
begin
  FReachErrors := 0;
  FCavebot := ACavebot;
  FName := AName;
  FPosition := APosition;
  FState := bcnsReach;
  FNext := nil;
  FPrev := nil;
  FIndex := AIndex;
  FParam := AParam;
  FWait := BLock.Create(1000, 20);
end;

destructor TBBotCavebotNormalNode.Destroy;
begin
  FWait.Free;
  inherited;
end;

procedure TBBotCavebotNormalNode.DoRun;
begin
  OnPreRun;
  if State = bcnsReach then
    DoReach
  else if State = bcnsReached then
  begin
    Wait.Lock;
    Run;
  end;
end;

function TBBotCavebotNormalNode.GetDistanceToSelf: BInt32;
begin
  Result := Me.GetDistance(Position);
end;

function TBBotCavebotNormalNode.GetParam: BStr;
begin
  Result := BBot.Macros.VarsText(FParam);
end;

function TBBotCavebotNormalNode.GetParamInt: BInt32;
begin
  Result := StrToIntDef(Param, -1);
end;

function TBBotCavebotNormalNode.GoFloorDown: BBool;
begin
  Exit(Cavebot.GoFloorDown(Position));
end;

function TBBotCavebotNormalNode.GoFloorUp: BBool;
begin
  Exit(Cavebot.GoFloorUp(Position));
end;

procedure TBBotCavebotNormalNode.SetState(AState: TBBotCavebotNodeState);
begin
  FState := AState;
  if FState = bcnsReach then
  begin
    ReachErrors := 0;
    Wait.Unlock;
    OnStart;
  end;
end;

procedure TBBotCavebotNormalNode.WalkError;
begin
  ReachErrors := ReachErrors + 1;
  if ReachErrors > 10 then
    SetState(bcnsError);
  Wait.Lock;
end;

function TBBotCavebotNormalNode.GoPosition: BBool;
begin
  Result := Cavebot.WalkTo(Position, 1);
end;

function TBBotCavebotNormalNode.DoReach: BBool;
begin
  if IsReached then
  begin
    SetState(bcnsReached);
    Exit(True);
  end
  else
  begin
    if BBot.Walker.Task <> nil then
      Exit(True)
    else
    begin
      if ((Position.Z > Me.Position.Z) and GoFloorDown) or
        ((Position.Z < Me.Position.Z) and GoFloorUp) or
        ((Position.Z = Me.Position.Z) and GoPosition) then
        Exit(True);
      if Position.Z = Me.Position.Z then
        Tibia.SetMove(Position);
    end;
  end;
  if BBot.StandTime > 3000 then
    WalkError;
  Result := False;
end;

function TBBotCavebotNormalNode.IsReached: BBool;
begin
  Result := DistanceToSelf <= 1;
end;

procedure TBBotCavebotNormalNode.OnPreRun;
begin

end;

procedure TBBotCavebotNormalNode.OnStart;
begin

end;

{ TBBotCavebotNodeResetBackpacks }

procedure TBBotCavebotNodeResetBackpacks.Run;
begin
  BBot.Backpacks.ResetBackpacks;
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeFixed }

procedure TBBotCavebotNodeFixed.Run;
begin
  SetState(bcnsOk);
  Wait.Unlock;
end;

{ TBBotCavebotNodeLabel }

procedure TBBotCavebotNodeLabel.Run;
begin
  SetState(bcnsOk);
end;

procedure TBBotCavebotNodeLabel.OnStart;
begin
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeSay }

procedure TBBotCavebotNodeSay.Run;
begin
  Me.Say(Param);
  SetState(bcnsOk);
  Wait.Lock(Length(Param) * (250 + BRandom(80)));
end;

{ TBBotCavebotNodeDepositer }

procedure TBBotCavebotNodeDepositer.Run;
begin
  BBot.Depositer.Start;
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeDelay }

procedure TBBotCavebotNodeDelay.Run;
begin
  Wait.Lock(StrToIntDef(Param, 1) * 1000);
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeGoLabel }

procedure TBBotCavebotNodeGoLabel.Run;
begin
  if Cavebot.GoLabel(Param) then
    SetState(bcnsOk)
  else
    SetState(bcnsError);
end;

{ TBBotCavebotNodeMacro }

procedure TBBotCavebotNodeMacro.Run;
begin
  BBot.Macros.Execute(Param);
  SetState(bcnsOk)
end;

{ TBBotCavebotNodeDropLoot }

procedure TBBotCavebotNodeDropLoot.Run;
var
  Item: TTibiaContainer;
begin
  if Me.DistanceTo(Position) < 4 then
  begin
    Item := ContainerLast;
    while Item <> nil do
    begin
      if Item.LootDrop then
      begin
        Item.ToGround(Position);
        Wait.Lock(800 + BRandom(300));
        Exit;
      end;
      Item := Item.Prev;
    end;
    SetState(bcnsOk)
  end
  else
    SetState(bcnsReach);
end;

{ TBBotCavebotNodeMapTool }

procedure TBBotCavebotNodeMapTool.OnPreRun;
var
  Map: TTibiaTiles;
begin
  if ((Next.Position = Me.Position) and (Next.Position <> Position)) or
    (Tiles(Map, TargetPos) and (not Map.Has(TargetID))) then
    SetState(bcnsOk);
end;

procedure TBBotCavebotNodeMapTool.Run;
var
  S: BInt32;
  Map: TTibiaTiles;
begin
  if Tiles(Map, TargetPos) then
  begin
    if Map.ID <> TargetID then
      if Map.Cleanup then
        Exit;
    for S := 0 to Map.ItemsOnTile - 1 do
    begin
      Map.ItemFromStack(S);
      if Map.ID = TargetID then
      begin
        if UseID = 0 then
          Map.Use
        else
          Map.UseOn(UseID);
      end;
    end;
  end;
end;

procedure TBBotCavebotNodeMapTool.OnStart;
begin
  FTargetPos := BPos(BStrBetween(Param + ' :::', 'Pos: ', ' :::'));
  FTargetID := StrToIntDef(BStrBetween(Param, 'Target: ', ' Use: '), -1);
  FUseID := StrToIntDef(BStrBetween(Param, 'Use: ', ' Pos: '), -1);
end;

{ TBBotCavebotNodeNPCSay }

procedure TBBotCavebotNodeNPCSay.Run;
begin
  Me.NPCSay(Param);
  Wait.Lock(Length(Param) * (250 + BRandom(80)));
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeFullCheck }

procedure TBBotCavebotNodeFullCheck.Run;
var
  S, LTrue, LFalse, LCode: BStr;
begin
  S := Param;
  LTrue := '';
  LFalse := '';
  LCode := '';
  if BStrStart(S, 'Full') then
  begin
    LTrue := BStrBetween(S, 'Full ', ' Else');
    LFalse := BStrBetween(S, 'Else ', ' Code');
    LCode := BStrRight(S, 'Code ');
  end
  else
    LCode := S;
  if Cavebot.FullCheck(LCode) then
  begin
    if (LTrue = '') or Cavebot.GoLabel(LTrue) then
      SetState(bcnsOk)
    else
      SetState(bcnsError);
  end
  else
  begin
    if LFalse = '' then
      Cavebot.GoStart
    else if Cavebot.GoLabel(LFalse) then
      SetState(bcnsOk)
    else
      SetState(bcnsError);
  end;
end;

{ TBBotCavebotNodeNoKill }

procedure TBBotCavebotNodeNoKill.Run;
begin
  if BStrEqual(Param, 'On') then
    Cavebot.NoKill := True
  else if BStrEqual(Param, 'Off') then
    Cavebot.NoKill := False
  else
    Cavebot.NoKill := not Cavebot.NoKill;
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeOpenCorpse }

procedure TBBotCavebotNodeOpenCorpse.Run;
begin
  if BStrEqual(Param, 'On') then
    Cavebot.IsOpenningCorpse := True
  else if BStrEqual(Param, 'Off') then
    Cavebot.IsOpenningCorpse := False
  else
    Cavebot.IsOpenningCorpse := not Cavebot.IsOpenningCorpse;
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeResetTasks }

procedure TBBotCavebotNodeResetTasks.Run;
begin
  BBot.KillStats.ResetTask;
  SetState(bcnsOk);
end;

{ TBBotCavebotNodeWithdraw }

function WithdrawRound(Number, RoundingNumber: BFloat): BInt32;
begin
  Result := Round(Ceil(Number / Power(10, RoundingNumber)) * Power(10,
    RoundingNumber));
end;

procedure TBBotCavebotNodeWithdraw.Run;
var
  W, R: BStrArray;
  ID, UnitPrice, TotalItem, Total, I: BInt32;
begin
  Total := 0;
  if BStrSplit(W, ';', Param) > 0 then
  begin
    for I := 0 to High(W) do
    begin
      if BStrSplit(R, ' ', W[I]) = 3 then
      begin
        ID := StrToIntDef(R[0], -1);
        UnitPrice := StrToIntDef(R[1], -1);
        TotalItem := StrToIntDef(R[2], -1);
        if (ID = -1) or (TotalItem = -1) or (UnitPrice = -1) then
        begin
          SetState(bcnsError);
          Exit;
        end;
        Dec(TotalItem, CountItem(ID));
        TotalItem := TotalItem * UnitPrice;
        Inc(Total, TotalItem);
      end
      else
        SetState(bcnsError);
    end;
    Total := WithdrawRound(Total, Cavebot.WithdrawRounding);
    if Total > 0 then
      Me.NPCSay(IntToStr(Total));
    Wait.Lock(Length(IntToStr(Total)) * (250 + BRandom(80)));
    SetState(bcnsOk);
  end
  else
    SetState(bcnsError);
end;

{ TBBotCavebotNodeBuy }

procedure TBBotCavebotNodeBuy.Run;
var
  R: BStrArray;
  ID, Total: BInt32;
begin
  if BStrSplit(R, ' ', Param) = 2 then
  begin
    ID := StrToIntDef(R[0], -1);
    Total := StrToIntDef(R[1], -1);
    Dec(Total, CountItem(ID));
    if BBot.TradeWindow.Buy(ID, Total) then
      SetState(bcnsOk)
    else
      SetState(bcnsError);
    Wait.Lock(1200 + BRandom(1000));
  end
  else
    SetState(bcnsError);
end;

{ TBBotCavebotNodeSell }

procedure TBBotCavebotNodeSell.Run;
var
  ID: BInt32;
begin
  ID := ParamInt;
  if BBot.TradeWindow.SellAll(ID) then
    SetState(bcnsOk)
  else
    SetState(bcnsError);
  Wait.Lock(1200 + BRandom(1000));
end;

{ TBBotCavebotNodePoint }

procedure TBBotCavebotNodePoint.Run;
begin
  SetState(bcnsOk);
  Wait.Unlock;
end;

{ TBBotCavebotFixedNode }

function TBBotCavebotFixedNode.GoPosition: BBool;
begin
  Result := Cavebot.WalkTo(Position, 0);
end;

function TBBotCavebotFixedNode.IsReached: BBool;
begin
  Result := DistanceToSelf = 0;
end;

{ TBBotCavebotNodeSupliesWithdraw }

procedure TBBotCavebotNodeSupliesWithdraw.Run;
begin
  SetState(bcnsOk);
  BBot.Withdraw.LoadItems(Param);
  BBot.Withdraw.Start;
end;

{ EBBotCavebot }

constructor EBBotCavebot.Create(Name: BStr; E: Exception);
begin
  inherited Create('Cavebot->' + Name + BStrLine + E.Message);
end;

{ TBBotCavebotNodeGoRandomLabel }

procedure TBBotCavebotNodeGoRandomLabel.Run;
var
  R: BStrArray;
begin
  if (BStrSplit(R, ',', Param) > 0) and
    Cavebot.GoLabel(BTrim(R[BRandom(0, High(R))])) then
    SetState(bcnsOk)
  else
    SetState(bcnsError);
end;

{ TBBotCavebotNodeTeleport }

procedure TBBotCavebotNodeTeleport.OnPreRun;
begin
  if (TeleportPos.X <> 0) and ((TeleportPos.Z <> Me.Position.Z) or
    (BBot.Walker.ApproachToCost(TeleportPos, 4) = PathCost_NotPossible)) then
    SetState(bcnsOk);
end;

procedure TBBotCavebotNodeTeleport.OnStart;
begin
  inherited;
  TeleportPos.zero;
end;

procedure TBBotCavebotNodeTeleport.Run;
var
  Map: TTibiaTiles;
begin
  if TeleportPos.X = 0 then
  begin
    if TilesSearch(Map, Me.Position, 4, False,
      function: BBool
      begin
        Result := Map.IsTeleport;
      end) then
      TeleportPos := Map.Position;
  end;
  Cavebot.WalkTo(TeleportPos, 0);
end;

end.
