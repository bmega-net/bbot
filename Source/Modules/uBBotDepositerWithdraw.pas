unit uBBotDepositerWithdraw;


interface

uses
  uBTypes,
  uBBotAction,
  uBBotDepotTools,
  uBBotBackpacks,
  uBVector,
  uContainer;

const
  BBotWithdrawWaitLock = 6000;

type
  TBBotWithdraw = class;

  TBBotWithdrawIdle = class(TBBotActionState)
  public
    constructor Create;
    procedure Run; override;
  end;

  TBBotWithdrawBeforePush = class(TBBotActionState)
  private
    FWithdraw: TBBotWithdraw;
  public
    constructor Create(AWithdraw: TBBotWithdraw);

    procedure onStart; override;
    procedure Run; override;

    property Withdraw: TBBotWithdraw read FWithdraw;

  end;

  TBBotWithdrawPushItems = class(TBBotActionState)
  private
    FWithdraw: TBBotWithdraw;
    FDepotContainer: BInt32;
  protected
    LastPushed: TTibiaContainer;
    procedure PushFromDepotToBP;
  public
    constructor Create(AWithdraw: TBBotWithdraw);

    procedure onStart; override;
    procedure Run; override;

    property Withdraw: TBBotWithdraw read FWithdraw;
    property DepotContainer: BInt32 read FDepotContainer;
  end;

  TBBotWithdrawAfterPush = class(TBBotActionState)
  public
    constructor Create;

    procedure onStart; override;
    procedure Run; override;
  end;

  TBBotWithdraw = class(TBBotActions)
  private type
    TBBotWithdrawState = record
      Current: TBBotActionState;
      OnSuccess: TBBotActionState;
      OnFail: TBBotActionState;
    end;
  public type
    TBBotWithdrawItems = record
      ID: BInt32;
      Want: BInt32;
      Needed: BInt32;
    end;
  private
    FItems: BVector<TBBotWithdrawItems>;
    States: BVector<TBBotWithdrawState>;
    FWalker: TBBotDepotWalker;
    FOpener: TBBotDepotOpener;
    FIdle: TBBotWithdrawIdle;
    FPushItems: TBBotWithdrawPushItems;
    FAfterPush: TBBotWithdrawAfterPush;
    FBeforePush: TBBotWithdrawBeforePush;
    FCurrent: TBBotActionState;
    procedure AddState(const AState, AOnFail, AOnSuccess: TBBotActionState);
    procedure SetCurrent(const AValue: TBBotActionState);
    function getIsWorking: BBool;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Run; override;
    procedure OnInit; override;

    property Current: TBBotActionState read FCurrent;

    property isWorking: BBool read getIsWorking;
    property Items: BVector<TBBotWithdrawItems> read FItems;
    procedure LoadItems(const ACode: BStr);

    procedure Error(const AText: BStr);

    property Idle: TBBotWithdrawIdle read FIdle;
    property Walker: TBBotDepotWalker read FWalker;
    property BeforePush: TBBotWithdrawBeforePush read FBeforePush;
    property Opener: TBBotDepotOpener read FOpener;
    property PushItems: TBBotWithdrawPushItems read FPushItems;
    property AfterPush: TBBotWithdrawAfterPush read FAfterPush;
  end;

implementation

{ TBBotWithdraw }

uses
  BBotEngine,
  uTibiaDeclarations,
  uUserError;

procedure TBBotWithdraw.AddState(const AState, AOnFail, AOnSuccess: TBBotActionState);
var
  State: BVector<TBBotWithdrawState>.It;
begin
  State := States.Add;
  State^.Current := AState;
  State^.OnSuccess := AOnSuccess;
  State^.OnFail := AOnFail;
end;

constructor TBBotWithdraw.Create;
begin
  inherited Create('Withdraw', 0);
  States := BVector<TBBotWithdrawState>.Create;
  FItems := BVector<TBBotWithdrawItems>.Create;

  FOpener := TBBotDepotOpener.Create;
  FWalker := TBBotDepotWalker.Create;
  FIdle := TBBotWithdrawIdle.Create;
  FBeforePush := TBBotWithdrawBeforePush.Create(Self);
  FPushItems := TBBotWithdrawPushItems.Create(Self);
  FAfterPush := TBBotWithdrawAfterPush.Create;

  AddActions([FIdle, FWalker, FOpener, FPushItems, FAfterPush, FBeforePush]);
end;

destructor TBBotWithdraw.Destroy;
begin
  States.Free;
  FItems.Free;
  inherited;
end;

procedure TBBotWithdraw.Error(const AText: BStr);
var
  Err: BUserError;
begin
  Err := BUserError.Create(Self, AText);
  Err.DisableCavebot := True;
  Err.Actions := [uraEditCavebot];
  Err.Execute;
  ActionNext.Lock(30 * 1000);
end;

function TBBotWithdraw.getIsWorking: BBool;
begin
  Result := Current <> FIdle;
end;

procedure TBBotWithdraw.LoadItems(const ACode: BStr);
var
  R: BStrArray;
  I: BInt32;
  SID, SWant: BStr;
  Item: BVector<TBBotWithdrawItems>.It;
begin
  Items.Clear;
  if BStrSplit(R, ';', ACode) > 0 then
    for I := 0 to High(R) do
      if BStrSplit(R[I], ' ', SID, SWant) then begin
        Item := Items.Add;
        try
          Item^.ID := BStrTo32(SID);
          Item^.Want := BStrTo32(SWant);
        except
          Error('Invalid withdraw expression (should be <ID QUANTITY> numbers) "' + R[I] +
            '". Possible reason: variable not set.');
          Items.Remove(Item);
        end;
      end;
end;

procedure TBBotWithdraw.OnInit;
begin
  inherited;
  SetCurrent(FIdle);
  AddState(FIdle, FIdle, FIdle);
  AddState(FWalker, FWalker, FBeforePush);
  AddState(FBeforePush, FBeforePush, FOpener);
  AddState(FOpener, FWalker, FPushItems);
  AddState(FPushItems, FWalker, FAfterPush);
  AddState(FAfterPush, FIdle, FIdle);
end;

procedure TBBotWithdraw.Run;
begin
  FCurrent.RunAction;
  if FCurrent.isFailed or FCurrent.isSucceed or (not FCurrent.isRunning) then
    States.Search('Withdraw State Engine',
      function(It: BVector<TBBotWithdrawState>.It): BBool
      begin
        Result := It^.Current = FCurrent;
        if Result then
          if FCurrent.isSucceed then
            SetCurrent(It^.OnSuccess)
          else if FCurrent.isFailed then
            SetCurrent(It^.OnFail);
      end);
end;

procedure TBBotWithdraw.SetCurrent(const AValue: TBBotActionState);
begin
  FCurrent := AValue;
  FCurrent.doStart;
end;

procedure TBBotWithdraw.Start;
begin
  SetCurrent(FWalker);
end;

{ TBBotWithdrawPushItems }

constructor TBBotWithdrawPushItems.Create(AWithdraw: TBBotWithdraw);
begin
  inherited Create('Withdraw.PushItems', 600);
  FWithdraw := AWithdraw;
end;

procedure TBBotWithdrawPushItems.onStart;
begin
  inherited;
  FDepotContainer := Withdraw.Opener.DepotContainer;
  LastPushed := nil;
end;

procedure TBBotWithdrawPushItems.PushFromDepotToBP;
var
  LastCT: TTibiaContainer;
  CT: TTibiaContainer;
begin
  LastCT := nil;
  CT := ContainerLast;
  while (CT <> nil) and (CT.Container = DepotContainer) do begin
    if (CT.IsContainer) and (LastCT = nil) then
      LastCT := CT;
    if Withdraw.Items.Has('Withdraw push items from DP to BP',
      function(It: BVector<TBBotWithdraw.TBBotWithdrawItems>.It): BBool
      var
        MoveCount: BInt32;
      begin
        if (CT.ID = BUInt32(It^.ID)) and (It^.Needed > 0) then begin
          MoveCount := BMin(It^.Needed, BMax(CT.Count, 1));
          if (CT.Weight * MoveCount) <= Me.Capacity then begin
            case ContainerAt(0).PullHere(CT, BMin(MoveCount, CT.Count)) of
            bcpsError:
                Withdraw.Error(BFormat('Unable to push item %d (%d/%d), full backpack', [It^.ID, It^.Want - It^.Needed,
                It^.Want]));
            bcpsTryAgain: Exit(True);
            bcpsSuccess: begin
                if CT <> LastPushed then begin
                  It^.Needed := It^.Needed - MoveCount;
                  LastPushed := CT;
                end;
                Exit(True);
              end;
            end;
          end
          else
            Withdraw.Error(BFormat('Unable to push item %d (%d/%d), no capacity', [It^.ID, It^.Want - It^.Needed,
              It^.Want]));
        end;
        Exit(False);
      end) then
      Exit;
    CT := CT.Prev;
  end;
  if LastCT <> nil then begin
    LastCT.Use;
    LastPushed := nil;
  end else begin
    Withdraw.Items.ForEach(
      procedure(It: BVector<TBBotWithdraw.TBBotWithdrawItems>.It)
      begin
        if It^.Needed <> 0 then
          Withdraw.Error(BFormat('A item was not full withdrawed %d (want: %d need: %d)',
            [It^.ID, It^.Want, It^.Needed]));
      end);
    doSuccess;
  end;
end;

procedure TBBotWithdrawPushItems.Run;
var
  CT: TTibiaContainer;
begin
  BBot.Walker.WaitLock('Withdrawing push items', BBotWithdrawWaitLock);
  // If Locker found, use it
  CT := ContainerFind(ItemID_Locker);
  if CT <> nil then
    CT.Use
  else begin
    CT := ContainerAt(DepotContainer, 0);
    if not CT.Open then
      doFail
    else if BBot.DepotList.IsWithdrawerLockerOpen then
      PushFromDepotToBP;
  end;
end;

{ TBBotWithdrawIdle }

constructor TBBotWithdrawIdle.Create;
begin
  inherited Create('Withdraw.Idle', 10000);
end;

procedure TBBotWithdrawIdle.Run;
begin
end;

{ TBBotWithdrawBeforeOpener }

constructor TBBotWithdrawBeforePush.Create(AWithdraw: TBBotWithdraw);
begin
  inherited Create('Withdraw.BeforePush', 600);
  FWithdraw := AWithdraw;
end;

procedure TBBotWithdrawBeforePush.onStart;
begin
  inherited;
  BBot.Backpacks.ResetBackpacks;
end;

procedure TBBotWithdrawBeforePush.Run;
begin
  BBot.Walker.WaitLock('Withdrawing before push', BBotWithdrawWaitLock);
  if not BBot.Backpacks.isWorking then begin
    Withdraw.Items.ForEach(
      procedure(It: BVector<TBBotWithdraw.TBBotWithdrawItems>.It)
      begin
        It^.Needed := BMax(It^.Want - CountItem(It^.ID), 0);
      end);
    doSuccess;
  end;
end;

{ TBBotWithdrawAfterPush }

constructor TBBotWithdrawAfterPush.Create;
begin
  inherited Create('Withdraw.AfterPush', 600);
end;

procedure TBBotWithdrawAfterPush.onStart;
begin
  inherited;
  BBot.Backpacks.ResetBackpacks;
end;

procedure TBBotWithdrawAfterPush.Run;
begin
  BBot.Walker.WaitLock('Withdrawing after items', BBotWithdrawWaitLock);
  if not BBot.Backpacks.isWorking then
    doSuccess;
end;

end.

