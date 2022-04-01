unit uBBotReconnectManager;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  DateUtils,
  ucLogin;

const
  BBotReconnectManagerStatusEvery = 5 * 60 * 1000;

type
  TBBotReconnectManager = class;
  TBBotReconnectAccount = class;

  TBBotReconnectCharacter = class
  private
    FAccount: TBBotReconnectAccount;
    FManager: TBBotReconnectManager;
    FID: BUInt32;
    FName: BStr;
    FIndex: BInt32;
    FBlock: TDateTime;
  public
    constructor Create(AManager: TBBotReconnectManager; AAccount: TBBotReconnectAccount); overload;
    constructor Create(AManager: TBBotReconnectManager; ASerialized: BStr); overload;

    property Account: TBBotReconnectAccount read FAccount;
    property Manager: TBBotReconnectManager read FManager;

    property ID: BUInt32 read FID write FID;
    property Name: BStr read FName write FName;
    property Index: BInt32 read FIndex write FIndex;

    procedure Block(ADelay: BUInt32);
    function getBlock(): BUInt32;
    function getBlocked(): BBool;
    function getBlockDate(): TDateTime;

    function Serialize: BStr;
  end;

  TBBotReconnectCharacters = BVector<TBBotReconnectCharacter>;

  TBBotReconnectAccount = class
  private
    FManager: TBBotReconnectManager;
    FID: BUInt32;
    FName: BStr;
    FPassword: BStr;
    FCharacters: TBBotReconnectCharacters;
  protected
    function GetSerializedPassword: BStr;
    procedure UnSerializePassword(ASerialized: BStr);
  public
    constructor Create(AManager: TBBotReconnectManager); overload;
    constructor Create(AManager: TBBotReconnectManager; ASerialized: BStr); overload;
    destructor Destroy; override;

    property Manager: TBBotReconnectManager read FManager;

    property ID: BUInt32 read FID;

    property Name: BStr read FName write FName;
    property Password: BStr read FPassword write FPassword;
    property Characters: TBBotReconnectCharacters read FCharacters;

    function CharacterByID(AID: BUInt32): TBBotReconnectCharacter;
    function CharacterByName(AName: BStr): TBBotReconnectCharacter;

    function Serialize: BStr;
  end;

  TBBotReconnectAccounts = BVector<TBBotReconnectAccount>;

  TBBotReconnectScheduleItem = class
  private
    FManager: TBBotReconnectManager;
    function GetFinished: BBool;
  protected
    FEnabled: BBool;
    FID: BUInt32;
    FVariation: BUInt32;
    FDuration: BUInt32;
    FStartTime: TDateTime;
    FFinishTime: TDateTime;
    FShouldLoadScript: BBool;
    function getBlocked: BBool; virtual;
  public
    constructor Create(AManager: TBBotReconnectManager);

    property Manager: TBBotReconnectManager read FManager;

    property Enabled: BBool read FEnabled write FEnabled;
    property ID: BUInt32 read FID;
    property Duration: BUInt32 read FDuration write FDuration;
    property Variation: BUInt32 read FVariation write FVariation;
    property Blocked: BBool read getBlocked;
    property ShouldLoadScript: BBool read FShouldLoadScript write FShouldLoadScript;

    procedure Start; virtual;
    procedure Process; virtual; abstract;
    function getRandomDuration: BUInt32;

    function DurationStr: BStr;

    property Finished: BBool read GetFinished;
    property StartTime: TDateTime read FStartTime;
    property FinishTime: TDateTime read FFinishTime write FFinishTime;

    function FormatListLeft: BStr; virtual; abstract;
    function FormatListRight: BStr; virtual; abstract;
    function Serialize: BStr; virtual; abstract;
  end;

  TBBotReconnectScheduleOfflineItem = class(TBBotReconnectScheduleItem)
  public
    constructor Create(AManager: TBBotReconnectManager; ASerialized: BStr); overload;
    constructor Create(AManager: TBBotReconnectManager); overload;

    procedure Process; override;

    function FormatListLeft: BStr; override;
    function FormatListRight: BStr; override;
    function Serialize: BStr; override;
  end;

  TBBotReconnectScheduleOnlineItem = class(TBBotReconnectScheduleItem)
  private
    FScript: BStr;
    FCharacter: BUInt32;
    FAccount: BUInt32;
    FBlockCharacter: BUInt32;
    function GetAccount: TBBotReconnectAccount;
    function GetCharacter: TBBotReconnectCharacter;
    procedure SetAccount(const Value: TBBotReconnectAccount);
    procedure SetCharacter(const Value: TBBotReconnectCharacter);
  protected
    function getBlocked: BBool; override;
  public
    constructor Create(AManager: TBBotReconnectManager; ASerialized: BStr); overload;
    constructor Create(AManager: TBBotReconnectManager); overload;

    procedure Start; override;
    procedure Process; override;

    property Account: TBBotReconnectAccount read GetAccount write SetAccount;
    property Character: TBBotReconnectCharacter read GetCharacter write SetCharacter;
    property BlockCharacter: BUInt32 read FBlockCharacter write FBlockCharacter;
    property Script: BStr read FScript write FScript;

    function FormatListLeft: BStr; override;
    function FormatListRight: BStr; override;
    function Serialize: BStr; override;
  end;

  TBBotReconnectSchedule = BVector<TBBotReconnectScheduleItem>;

  TBBotReconnectManager = class(TBBotAction)
  const
    ReconnectManagerProfileFile = 'Data/%s.reconnect.bbot';
    ReconnectManagerAccountsFile = 'Data/Accounts';
  private
    FCurrentID: BUInt32;
    FName: BStr;
    FSchedule: TBBotReconnectSchedule;
    FAccounts: TBBotReconnectAccounts;
    FEnabled: BBool;
    function GetProfileFileName: BStr;
    procedure SetEnabled(const Value: BBool);
    function GetCurrent: TBBotReconnectScheduleItem;
    procedure SetCurrent(const Value: TBBotReconnectScheduleItem);
  protected
    NextStatus: BUInt32;
    NextReconnect: BUInt32;
    procedure SaveStatus;
    procedure NextAfter(AIndex: BInt32);
    procedure Next;
    procedure Process;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;

    property Name: BStr read FName write FName;
    property Enabled: BBool read FEnabled write SetEnabled;

    property Accounts: TBBotReconnectAccounts read FAccounts;
    property Schedule: TBBotReconnectSchedule read FSchedule;

    property Current: TBBotReconnectScheduleItem read GetCurrent write SetCurrent;
    property CurrentID: BUInt32 read FCurrentID;

    function AccountByID(AID: BUInt32): TBBotReconnectAccount;
    function ScheduleByID(AID: BUInt32): TBBotReconnectScheduleItem;
    function CharacterByID(AID: BUInt32): TBBotReconnectCharacter;
    function CharacterByName(AName: BStr): TBBotReconnectCharacter;

    procedure TerminateTask;

    procedure LoadProfile(AName: BStr); overload;
    procedure LoadProfile; overload;
    procedure LoadAccounts;
    function UpdateSchedule(AUpdate: BProc): BBool;
    function UpdateAccounts(AUpdate: BProc): BBool;
  end;

function BotManagerDurToStr(ADuration: BUInt32): BStr;
function BotManagerStrToDur(ADuration: BStr): BUInt32;

implementation

{$IFDEF TEST}

uses
  TestFramework,
{$ELSE}

uses
{$ENDIF}
  uEngine,

  BBotEngine,
  SysUtils,
  Classes,
  uTibiaDeclarations,
  uTibiaProcess,
  Windows;

function BotManagerDurToStr(ADuration: BUInt32): BStr;
var
  H, M, S: BUInt32;
begin
  S := ADuration mod 60;
  M := ADuration div 60;
  H := M div 60;
  M := M mod 60;
  Result := BFormat('%.2d:%.2d:%.2d', [H, M, S])
end;

function BotManagerStrToDur(ADuration: BStr): BUInt32;
var
  R: BStrArray;
begin
  BStrSplit(R, ':', ADuration);
  if Length(R) = 3 then
    Exit((60 * 60 * BStrTo32(R[0], 1)) + (60 * BStrTo32(R[1], 0)) + BStrTo32(R[2]))
  else if Length(R) = 2 then
    Exit((60 * 60 * BStrTo32(R[0], 1)) + (60 * BStrTo32(R[1], 0)))
  else if Length(R) = 1 then
    Exit(60 * BStrTo32(R[0], 1))
  else
    Exit(0);
end;

function GenerateID: BUInt32;
begin
  Result := Tick;
  while Tick = Result do
    SetTick;
end;

{ TBBotReconnectScheduleItem }

constructor TBBotReconnectScheduleOnlineItem.Create(AManager: TBBotReconnectManager; ASerialized: BStr);
var
  R: BStrArray;
begin
  inherited Create(AManager);
  try
    BStrSplit(R, '/', ASerialized);
    FID := BUInt32(BStrTo32(R[2]));
    Enabled := R[3] = '1';
    FAccount := BUInt32(BStrTo32(R[4]));
    FCharacter := BUInt32(BStrTo32(R[5]));
    FDuration := BUInt32(BStrTo32(R[6]));
    FVariation := BUInt32(BStrTo32(R[7]));
    FStartTime := BStrToDate(R[8]);
    FFinishTime := BStrToDate(R[9]);
    FBlockCharacter := BUInt32(BStrTo32(R[10]));
    FScript := R[11];
  except raise Exception.Create('Unable to unserialize online: ' + ASerialized);
  end;
end;

constructor TBBotReconnectScheduleOnlineItem.Create(AManager: TBBotReconnectManager);
begin
  inherited Create(AManager);
  FAccount := 0;
  FScript := '';
  FCharacter := 0;
  FBlockCharacter := 0;
  FShouldLoadScript := False;
end;

function TBBotReconnectScheduleOnlineItem.FormatListLeft: BStr;
var
  Char: TBBotReconnectCharacter;
begin
  Char := GetCharacter;
  if Char <> nil then begin
    Result := '';
    if not Enabled then
      Result := Result + '[Disabled]';
    if not Finished then
      Result := Result + '[Active]';
    Result := Result + ' ' + BotManagerDurToStr(Duration) + ' ' + Char.Name;
  end
  else
    Result := 'Error';
end;

function TBBotReconnectScheduleOnlineItem.FormatListRight: BStr;
var
  Char: TBBotReconnectCharacter;
  Blk: BStr;
begin
  Char := GetCharacter;
  if Char <> nil then begin
    if Char.getBlocked then
      Blk := 'blocked till ' + FormatDateTime('dd-mm hh:nn', Char.getBlockDate)
    else
      Blk := '';
    Result := BFormat('%s %s', [Script, Blk]);
  end
  else
    Result := 'Error' + Script;
end;

function TBBotReconnectScheduleOnlineItem.GetAccount: TBBotReconnectAccount;
begin
  Result := Manager.AccountByID(FAccount);
end;

function TBBotReconnectScheduleOnlineItem.getBlocked: BBool;
var
  Char: TBBotReconnectCharacter;
begin
  Result := inherited;
  if not Result then begin
    Char := GetCharacter;
    Result := (Char = nil) or (Char.getBlocked);
  end;
end;

function TBBotReconnectScheduleOnlineItem.GetCharacter: TBBotReconnectCharacter;
var
  Acc: TBBotReconnectAccount;
begin
  Acc := Manager.AccountByID(FAccount);
  if Acc <> nil then
    Exit(Acc.CharacterByID(FCharacter))
  else
    Exit(nil);
end;

procedure TBBotReconnectScheduleOnlineItem.Process;
begin
  if (Account <> nil) and (Character <> nil) then begin
    if Me.Connected and (not BStrEqual(Me.Name, Character.Name)) then begin
      Me.Logout;
      Manager.NextReconnect := 0;
    end else if (not Me.Connected) and (not BBot.ServerSave.IsServerSave) then begin
      if Manager.NextReconnect < Tick then begin
        while BRandom(0, 100) < 80 do begin
          TibiaProcess.SendKey(VK_ESCAPE);
          if BRandom(0, 100) < 50 then
            TibiaProcess.SendKey(VK_RETURN);
        end;
        Tibia.Login(Account.Name, Account.Password, Character.Index + 1);
        Manager.NextReconnect := BRandom(1 * 60 * 1000, 15 * 60 * 1000);
      end;
    end else if (not Me.Connected) or (Me.Connected and (BStrEqual(Me.Name, Character.Name))) then begin
      if ShouldLoadScript then begin
        Engine.LoadSettings := Script;
        FShouldLoadScript := False;
      end;
    end;
  end;
end;

function TBBotReconnectScheduleOnlineItem.Serialize: BStr;
begin
  Result := BFormat('Schedule/Online/%d/%d/%d/%d/%d/%d/%s/%s/%d/%s', [FID, BIf(Enabled, 1, 0), FAccount, FCharacter,
    FDuration, FVariation, BDateToStr(StartTime), BDateToStr(FinishTime), FBlockCharacter, FScript]);
end;

procedure TBBotReconnectScheduleOnlineItem.SetAccount(const Value: TBBotReconnectAccount);
begin
  if Value <> nil then
    FAccount := Value.ID
  else
    FAccount := 0;
end;

procedure TBBotReconnectScheduleOnlineItem.SetCharacter(const Value: TBBotReconnectCharacter);
begin
  if Value <> nil then
    FCharacter := Value.ID
  else
    FCharacter := 0;
end;

procedure TBBotReconnectScheduleOnlineItem.Start;
var
  Char: TBBotReconnectCharacter;
begin
  inherited;
  Char := GetCharacter;
  if Char <> nil then begin
    Char.Block(1000 * BRandom(FBlockCharacter, BUInt32(BCeil(FBlockCharacter * (1 + (Variation / 100))))));
    FShouldLoadScript := True;
  end
  else
    FFinishTime := Now();
end;

{ TBBotReconnectScheduleItem }

constructor TBBotReconnectScheduleItem.Create(AManager: TBBotReconnectManager);
begin
  FManager := AManager;
  FID := GenerateID;
  FDuration := 60 * 60;
  FVariation := 0;
end;

function TBBotReconnectScheduleItem.DurationStr: BStr;
begin
  if FinishTime > Now() then
    Result := BotManagerDurToStr(SecondsBetween(Now, FinishTime))
  else
    Result := 'done';
end;

function TBBotReconnectScheduleItem.getBlocked: BBool;
begin
  Result := (not Enabled) or (not Finished);
end;

function TBBotReconnectScheduleItem.GetFinished: BBool;
begin
  Result := CompareDateTime(FinishTime, Now) < 0;
end;

function TBBotReconnectScheduleItem.getRandomDuration: BUInt32;
begin
  Result := BRandom(Duration, BUInt32(BCeil(Duration * (1 + (Variation / 100))))) * 1000;
end;

procedure TBBotReconnectScheduleItem.Start;
begin
  FStartTime := Now;
  FFinishTime := IncMilliSecond(Now, getRandomDuration);
end;

{ TBBotReconnectManager }

function TBBotReconnectManager.AccountByID(AID: BUInt32): TBBotReconnectAccount;
var
  Acc: BVector<TBBotReconnectAccount>.It;
begin
  Acc := FAccounts.Find('Reconnect Manager - accountById',
    function(It: BVector<TBBotReconnectAccount>.It): BBool
    begin
      Result := It^.ID = AID;
    end);
  if Acc <> nil then
    Exit(Acc^)
  else
    Exit(nil);
end;

function TBBotReconnectManager.CharacterByID(AID: BUInt32): TBBotReconnectCharacter;
var
  Char: TBBotReconnectCharacter;
begin
  if FAccounts.Has('Reconnect Manager - characterById',
    function(It: BVector<TBBotReconnectAccount>.It): BBool
    begin
      Char := It^.CharacterByID(AID);
      Result := Char <> nil;
    end) then
    Exit(Char)
  else
    Exit(nil);
end;

function TBBotReconnectManager.CharacterByName(AName: BStr): TBBotReconnectCharacter;
var
  Char: TBBotReconnectCharacter;
begin
  if FAccounts.Has('Reconnect Manager - characterByName ' + AName,
    function(It: BVector<TBBotReconnectAccount>.It): BBool
    begin
      Char := It^.CharacterByName(AName);
      Result := Char <> nil;
    end) then
    Exit(Char)
  else
    Exit(nil);
end;

constructor TBBotReconnectManager.Create;
begin
  inherited Create('ReconnectManager', 10 * 1000);
  FAccounts := TBBotReconnectAccounts.Create(
    procedure(It: TBBotReconnectAccounts.It)
    begin
      It^.Free;
    end);
  FSchedule := TBBotReconnectSchedule.Create(
    procedure(It: TBBotReconnectSchedule.It)
    begin
      It^.Free;
    end);
  FEnabled := False;
  NextStatus := 0;
  FName := '';
  FCurrentID := 0;
end;

destructor TBBotReconnectManager.Destroy;
begin
  FAccounts.Free;
  FSchedule.Free;
  inherited;
end;

function TBBotReconnectManager.GetCurrent: TBBotReconnectScheduleItem;
begin
  if CurrentID = 0 then
    Exit(nil);
  Exit(ScheduleByID(CurrentID));
end;

function TBBotReconnectManager.GetProfileFileName: BStr;
begin
  Result := BFormat(ReconnectManagerProfileFile, [FName]);
end;

procedure TBBotReconnectManager.LoadProfile(AName: BStr);
begin
  FName := AName;
  LoadProfile;
end;

procedure TBBotReconnectManager.Next;
var
  Index: BInt32;
  Curr: TBBotReconnectScheduleItem;
begin
  Curr := GetCurrent;
  if (Curr = nil) or (Curr.Finished) then begin
    LoadProfile;
    if Schedule.Count > 0 then begin
      if CurrentID <> 0 then begin
        Index := Schedule.Search('Reconnect Manager - next task',
          function(It: BVector<TBBotReconnectScheduleItem>.It): BBool
          begin
            Result := It^.ID = CurrentID;
          end);
        if Index <> BVector<TBBotReconnectScheduleItem>.Invalid then begin
          NextAfter(Index);
          Exit;
        end;
      end;
      NextAfter(-1);
    end;
  end;
end;

procedure TBBotReconnectManager.NextAfter(AIndex: BInt32);
var
  Index, Count: BInt32;
begin
  Count := 1;
  while Count <= Schedule.Count do begin
    Index := (AIndex + Count) mod Schedule.Count;
    if Index <> AIndex then begin
      if not Schedule.Item[Index]^.Blocked then begin
        Current := Schedule.Item[Index]^;
        NextStatus := 0;
        SaveStatus;
        Exit;
      end;
    end;
    Inc(Count);
  end;
  if Me.Connected then
    Me.Logout;
  Current := nil;
end;

procedure TBBotReconnectManager.Process;
var
  Curr: TBBotReconnectScheduleItem;
begin
  Curr := GetCurrent;
  if Curr <> nil then
    Curr.Process;
end;

procedure TBBotReconnectManager.Run;
begin
  if Enabled then begin
    Next;
    SaveStatus;
    Process;
  end;
end;

procedure TBBotReconnectManager.LoadAccounts;
var
  I: BInt32;
  Buffer: BStr;
  L: BStrArray;
begin
  FAccounts.Clear;
  if BFileExists(ReconnectManagerAccountsFile) then begin
    Buffer := BFileGet(ReconnectManagerAccountsFile);
    if (BStrSplit(L, BStrLine, Buffer) > 1) and BStrEqualSensitive(L[0], 'ReconnectManager.V1') then begin
      for I := 1 to High(L) do
        if BStrStartSensitive(L[I], 'Account') then
          FAccounts.Add(TBBotReconnectAccount.Create(Self, L[I]))
        else if BStrStartSensitive(L[I], 'Character') then
          TBBotReconnectCharacter.Create(Self, L[I]);
    end;
  end;
end;

procedure TBBotReconnectManager.LoadProfile;
var
  I: BInt32;
  Buffer: BStr;
  L: BStrArray;
begin
  LoadAccounts;
  FSchedule.Clear;
  if BFileExists(GetProfileFileName) then begin
    Buffer := BFileGet(GetProfileFileName);
    if (BStrSplit(L, BStrLine, Buffer) > 1) and BStrEqualSensitive(L[0], 'ReconnectManager.V1') then begin
      for I := 1 to High(L) do
        if BStrStartSensitive(L[I], 'Schedule/Online') then
          FSchedule.Add(TBBotReconnectScheduleOnlineItem.Create(Self, L[I]))
        else if BStrStartSensitive(L[I], 'Schedule/Offline') then
          FSchedule.Add(TBBotReconnectScheduleOfflineItem.Create(Self, L[I]));
    end;
  end;
end;

function TBBotReconnectManager.UpdateAccounts(AUpdate: BProc): BBool;
var
  Res: BStr;
  AccountFile: TFileStream;
begin
  Result := False;
  AccountFile := nil;
  try
    try
      AccountFile := TFileStream.Create(ReconnectManagerAccountsFile, fmCreate or fmShareDenyWrite);
      AUpdate();
      Res := 'ReconnectManager.V1' + BStrLine;
      FAccounts.ForEach(
        procedure(It: TBBotReconnectAccounts.It)
        begin
          Res := Res + BStrLine + It^.Serialize;
        end);
      AccountFile.Write(BPChar(Res)^, Length(Res));
      Result := True;
    except
      on E: BException do
        AddDebug('Error UpdatingAccounts: ' + E.Message);
    end;
  finally
    if AccountFile <> nil then
      AccountFile.Destroy;
  end;
end;

function TBBotReconnectManager.UpdateSchedule(AUpdate: BProc): BBool;
var
  Res: BStr;
  ScheduleFile: TFileStream;
begin
  Result := False;
  ScheduleFile := nil;
  try
    try
      ScheduleFile := TFileStream.Create(GetProfileFileName, fmCreate or fmShareDenyWrite);
      AUpdate();
      Res := 'ReconnectManager.V1' + BStrLine;
      FSchedule.ForEach(
        procedure(It: TBBotReconnectSchedule.It)
        begin
          Res := Res + BStrLine + It^.Serialize;
        end);
      ScheduleFile.Write(BPChar(Res)^, Length(Res));
      Result := True;
    except
      on E: BException do
        AddDebug('Error UpdatingSchedule: ' + E.Message);
    end;
  finally
    if ScheduleFile <> nil then
      ScheduleFile.Destroy;
  end;
end;

procedure TBBotReconnectManager.SaveStatus;
var
  SavedSuccessfuly: BBool;
begin
  if NextStatus < Tick then begin
    SavedSuccessfuly := True;
    if GetCurrent <> nil then begin
      SavedSuccessfuly := SavedSuccessfuly and UpdateAccounts(
        procedure()
        begin
        end);
      SavedSuccessfuly := SavedSuccessfuly and UpdateSchedule(
        procedure()
        begin
        end);
    end;
    if SavedSuccessfuly then
      NextStatus := Tick + BBotReconnectManagerStatusEvery;
  end;
end;

function TBBotReconnectManager.ScheduleByID(AID: BUInt32): TBBotReconnectScheduleItem;
var
  Res: BVector<TBBotReconnectScheduleItem>.It;
begin
  Res := Schedule.Find('Reconnect Manager - scheduleById',
    function(It: BVector<TBBotReconnectScheduleItem>.It): BBool
    begin
      Result := It^.ID = AID;
    end);
  if Res <> nil then
    Exit(Res^)
  else
    Exit(nil);
end;

procedure TBBotReconnectManager.SetCurrent(const Value: TBBotReconnectScheduleItem);
begin
  FCurrentID := 0;
  if Value <> nil then begin
    FCurrentID := Value.ID;
    Value.Start;
    NextReconnect := 0;
  end;
end;

procedure TBBotReconnectManager.SetEnabled(const Value: BBool);
begin
  FEnabled := Value;
  NextStatus := Tick + BBotReconnectManagerStatusEvery;
end;

procedure TBBotReconnectManager.TerminateTask;
begin
  UpdateSchedule(
    procedure()
    var
      Curr: TBBotReconnectScheduleItem;
    begin
      Curr := Current;
      if Curr <> nil then
        Curr.FinishTime := Now;
    end);
end;

{ TBBotReconnectCharacter }

constructor TBBotReconnectCharacter.Create(AManager: TBBotReconnectManager; AAccount: TBBotReconnectAccount);
begin
  FID := GenerateID;
  FIndex := 0;
  FManager := AManager;
  FAccount := AAccount;
  FBlock := Now();
end;

procedure TBBotReconnectCharacter.Block(ADelay: BUInt32);
begin
  FBlock := DateUtils.IncMilliSecond(Now(), ADelay);
end;

constructor TBBotReconnectCharacter.Create(AManager: TBBotReconnectManager; ASerialized: BStr);
var
  R: BStrArray;
begin
  FManager := AManager;
  try
    BStrSplit(R, '/', ASerialized);
    FAccount := Manager.AccountByID(BStrTo32(R[1]));
    FID := BStrTo32(R[2]);
    FIndex := BStrTo32(R[3]);
    FName := R[4];
    FBlock := BStrToDate(R[5]);
    // Unused: R[6]
    FAccount.Characters.Add(Self);
  except raise Exception.Create('Unable to unserialize character: ' + ASerialized);
  end;
end;

function TBBotReconnectCharacter.getBlock: BUInt32;
begin
  if FBlock > Now() then
    Result := DateUtils.MilliSecondsBetween(Now(), FBlock)
  else
    Result := 0;
end;

function TBBotReconnectCharacter.getBlockDate: TDateTime;
begin
  Result := FBlock;
end;

function TBBotReconnectCharacter.getBlocked: BBool;
begin
  Result := FBlock > Now();
end;

function TBBotReconnectCharacter.Serialize: BStr;
begin
  Result := BFormat('Character/%d/%d/%d/%s/%s/%s\n', [FAccount.ID, FID, FIndex, FName, BDateToStr(FBlock), 'NULL']);
end;

{ TBBotReconnectAccount }

constructor TBBotReconnectAccount.Create(AManager: TBBotReconnectManager);
begin
  FCharacters := TBBotReconnectCharacters.Create(
    procedure(It: BVector<TBBotReconnectCharacter>.It)
    begin
      It^.Free;
    end);
  FManager := AManager;
  FID := GenerateID;
end;

function TBBotReconnectAccount.CharacterByID(AID: BUInt32): TBBotReconnectCharacter;
var
  Char: BVector<TBBotReconnectCharacter>.It;
begin
  Char := FCharacters.Find('Reconnect Manager - characterById2',
    function(It: BVector<TBBotReconnectCharacter>.It): BBool
    begin
      Result := It^.ID = AID;
    end);
  if Char <> nil then
    Exit(Char^)
  else
    Exit(nil);
end;

function TBBotReconnectAccount.CharacterByName(AName: BStr): TBBotReconnectCharacter;
var
  Char: BVector<TBBotReconnectCharacter>.It;
begin
  Char := FCharacters.Find('Reconnect Manager - characterByName2',
    function(It: BVector<TBBotReconnectCharacter>.It): BBool
    begin
      Result := BStrEqual(It^.Name, AName);
    end);
  if Char <> nil then
    Exit(Char^)
  else
    Exit(nil);
end;

constructor TBBotReconnectAccount.Create(AManager: TBBotReconnectManager; ASerialized: BStr);
var
  R: BStrArray;
begin
  FCharacters := TBBotReconnectCharacters.Create(
    procedure(It: BVector<TBBotReconnectCharacter>.It)
    begin
      It^.Free;
    end);
  FManager := AManager;
  try
    BStrSplit(R, '/', ASerialized);
    FID := BStrTo32(R[1]);
    FName := R[2];
    UnSerializePassword(R[3]);
  except raise Exception.Create('Unable to unserialize account: ' + ASerialized);
  end;
end;

destructor TBBotReconnectAccount.Destroy;
begin
  FCharacters.Free;
  inherited;
end;

function TBBotReconnectAccount.GetSerializedPassword: BStr;
var
  C: Cipher;
begin
  C := Cipher.Create(FName);
  Result := BStrReplace(C.encrypt(FPassword), '/', '@');
  C.Free;
end;

procedure TBBotReconnectAccount.UnSerializePassword(ASerialized: BStr);
var
  C: Cipher;
begin
  C := Cipher.Create(FName);
  FPassword := C.decrypt(BStrReplace(ASerialized, '@', '/'));
  C.Free;
end;

function TBBotReconnectAccount.Serialize: BStr;
var
  Chars: BStr;
begin
  Chars := '';
  FCharacters.ForEach(
    procedure(It: TBBotReconnectCharacters.It)
    begin
      Chars := Chars + It^.Serialize;
    end);
  Result := BFormat('Account/%d/%s/%s\n%s', [FID, FName, GetSerializedPassword, Chars]);
end;

{ TBBotReconnectScheduleOfflineItem }

constructor TBBotReconnectScheduleOfflineItem.Create(AManager: TBBotReconnectManager; ASerialized: BStr);
var
  R: BStrArray;
begin
  inherited Create(AManager);
  try
    BStrSplit(R, '/', ASerialized);
    FID := BStrTo32(R[2]);
    Enabled := R[3] = '1';
    FDuration := BUInt32(BStrTo32(R[4]));
    FVariation := BUInt32(BStrTo32(R[5]));
    FStartTime := BStrToDate(R[6]);
    FFinishTime := BStrToDate(R[7]);
  except raise Exception.Create('Unable to unserialize offline: ' + ASerialized);
  end;
end;

constructor TBBotReconnectScheduleOfflineItem.Create(AManager: TBBotReconnectManager);
begin
  inherited Create(AManager);
end;

function TBBotReconnectScheduleOfflineItem.FormatListLeft: BStr;
begin
  Result := '';
  if not Enabled then
    Result := Result + '[Disabled] ';
  Result := Result + BotManagerDurToStr(Duration) + ' Offline';
end;

function TBBotReconnectScheduleOfflineItem.FormatListRight: BStr;
begin
  if FinishTime > Now() then
    Result := 'blocked till ' + FormatDateTime('dd-mm hh:nn', FinishTime)
  else
    Result := '';
end;

procedure TBBotReconnectScheduleOfflineItem.Process;
begin
  if Me.Connected then
    Me.Logout;
end;

function TBBotReconnectScheduleOfflineItem.Serialize: BStr;
begin
  Result := BFormat('Schedule/Offline/%d/%d/%d/%d/%s/%s', [FID, BIf(Enabled, 1, 0), Duration, Variation,
    BDateToStr(StartTime), BDateToStr(FinishTime)]);
end;

end.
