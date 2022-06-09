unit uBBotClientTools;

interface

uses
  uBTypes,
  uBVector,
  Menus,
  Forms,
  uTibiaState;

const
  TibiaPlayerMutex: BStr = 'TibiaPlayerMutex';
  OTServerRSA: BStr = //
    '1091201329673994292788609605089955415282375029027981291234687579' + //
    '3726629149257644633073969600111060390723088861007265581882535850' + //
    '3429057592827629436413108566029093628212635953836686562675849720' + //
    '6207862794310902180176810615217550567108238764764442605581471797' + //
    '07119674283982419152118103759076030616683978566631413';

type
  TBBotClientTools = class;

  PBBotClientToolsUnpatch = ^TBBotClientToolsUnpatch;

  TBBotClientToolsUnpatch = record
    NewMutex: BStr;
    hProc: BUInt32;
    hThread: BUInt32;
  end;

  TBBotClientToolsLaunchedEntries = record
    PID: BUInt32;
    Version: TTibiaVersion;
  end;

  TBBotClientToolsClient = class
  private type
    TBBotClientToolsPatchKind = (bctpkMutex, bctpkIP, bctpkRSA, bctpkUpdateDialog);

    TBBotClientToolsPatch = record
      Original: BBInt8Buffer;
      Address: BUInt32;
      Kind: TBBotClientToolsPatchKind;
    end;
  private
    FFileName: BStr;
    FName: BStr;
    FParam: BStr;
    FClientTools: TBBotClientTools;
    NewMutex: BStr;
    hProcess: BUInt32;
    FIP: BStr;
    Patches: BVector<TBBotClientToolsPatch>;
    FVersion: BStr;
    function WriteProcess(AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
    function ReadProcess(AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
    procedure GatherAddresses();
    procedure PatchTibia();
    procedure AddPatch(const AOriginal: BStr; const AKind: TBBotClientToolsPatchKind); overload;
    procedure AddPatch(const AOriginal: array of BInt8; const AKind: TBBotClientToolsPatchKind); overload;
  public
    constructor Create(AClientTools: TBBotClientTools);
    destructor Destroy; override;

    property ClientTools: TBBotClientTools read FClientTools;

    function Serialize: BStr;
    function UnSerialize(const ACode: BStr): BBool;
    procedure ClearPatches;

    procedure Launch;

    property Name: BStr read FName write FName;
    property FileName: BStr read FFileName write FFileName;
    property Param: BStr read FParam write FParam;
    property IP: BStr read FIP write FIP;
    property Version: BStr read FVersion write FVersion;
  end;

  TBBotClients = BVector<TBBotClientToolsClient>;

  TBBotClientTools = class
  private const
    MCFile = 'Data/MegaMC';
  private
    FClients: TBBotClients;
    Menu: TPopupMenu;
    function GetMCFileName: BStr;
    procedure LoadClients;
    procedure SaveClients;
    procedure OnClick(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Popup(X, Y: BInt32);

    property Clients: TBBotClients read FClients;
    function Client(const AName: BStr): TBBotClients.It;

    procedure SaveClient(const AName, AFileName, AParam, AIP, AVersion: BStr);
    procedure RemoveClient(const AName: BStr);
  end;

procedure BBotClientToolsPopup(X, Y: BInt32); overload;
procedure BBotClientToolsPopup(X, Y: BInt32; Form: TForm); overload;

var
  ClientToolsLaunchedCustomEntries: BVector<TBBotClientToolsLaunchedEntries>;

implementation

uses
  BBotEngine,
  Windows,
  SysUtils,

  Declaracoes,
  uTibiaProcess,
  Dialogs,
  uTibiaDeclarations;

procedure BBotClientToolsPopup(X, Y: BInt32);
var
  MC: TBBotClientTools;
begin
  MC := TBBotClientTools.Create;
  MC.Popup(X, Y);
  MC.Free;
end;

procedure BBotClientToolsPopup(X, Y: BInt32; Form: TForm);
var
  P: TPoint;
begin
  P.SetLocation(X, Y);
  P := Form.ClientToScreen(P);
  BBotClientToolsPopup(P.X, P.Y);
end;

{ TBBotMC }

function TBBotClientTools.Client(const AName: BStr): TBBotClients.It;
begin
  Result := FClients.Find('Find client with name ' + AName,
    function(It: TBBotClients.It): BBool
    begin
      Result := BStrEqual(AName, It^.Name);
    end);
end;

constructor TBBotClientTools.Create;
begin
  FClients := TBBotClients.Create(
    procedure(It: TBBotClients.It)
    begin
      It^.Free;
    end);
  Menu := TPopupMenu.Create(nil);
  LoadClients;
end;

destructor TBBotClientTools.Destroy;
begin
  Menu.Free;
  FClients.Free;
  inherited;
end;

function TBBotClientTools.GetMCFileName: BStr;
begin
  Result := BotPath + MCFile;
end;

procedure TBBotClientTools.LoadClients;
var
  Buffer: BStr;
  I: BInt32;
  Res: BStrArray;
  Add: TBBotClientToolsClient;
begin
  FClients.Clear;
  Buffer := BFileGet(GetMCFileName);
  if (Buffer <> '') and (BStrSplit(Res, BStrLine, Buffer) > 0) then
    for I := 0 to High(Res) do
      if Res[I] <> '' then begin
        Add := TBBotClientToolsClient.Create(Self);
        if Add.UnSerialize(Res[I]) then
          FClients.Add(Add)
        else
          Add.Free;
      end;
end;

procedure TBBotClientTools.OnClick(Sender: TObject);
var
  OpenName: BStr;
  C: TBBotClients.It;
begin
  OpenName := TMenuItem(Sender).Hint;
  if OpenName = 'Edit' then
    ExecNewProcess(Application.EXEName + ' clienttools')
  else begin
    C := Client(OpenName);
    if C <> nil then
      C^.Launch;
  end;
end;

procedure TBBotClientTools.Popup(X, Y: BInt32);
var
  Edt: TMenuItem;
  Sep: TMenuItem;
begin
  Menu.Items.Clear;
  Clients.ForEach(
    procedure(It: TBBotClients.It)
    var
      Item: TMenuItem;
    begin
      Item := TMenuItem.Create(Menu);
      Menu.Items.Add(Item);
      Item.Caption := It^.Name;
      if It^.Version <> 'Auto' then
        Item.Caption := Item.Caption + ' [' + It^.Version + ']';
      if It^.IP <> '' then
        Item.Caption := Item.Caption + ' (' + It^.IP + ')';
      Item.Hint := It^.Name;
      Item.OnClick := OnClick;
    end);
  Edt := TMenuItem.Create(Menu);
  Sep := TMenuItem.Create(Menu);
  Edt.Caption := 'Edit';
  Edt.Hint := 'Edit';
  Edt.OnClick := OnClick;
  Sep.Caption := '-';
  Menu.Items.Add(Sep);
  Menu.Items.Add(Edt);
  Menu.Popup(X, Y);
  Application.ProcessMessages;
end;

procedure TBBotClientTools.RemoveClient(const AName: BStr);
begin
  Clients.Delete(
    function(It: TBBotClients.It): BBool
    begin
      Result := BStrEqual(AName, It^.Name);
    end);
  SaveClients;
end;

procedure TBBotClientTools.SaveClients;
var
  Buffer: BStr;
begin
  Buffer := '';
  Clients.ForEach(
    procedure(It: TBBotClients.It)
    begin
      Buffer := Buffer + It^.Serialize + BStrLine;
    end);
  BFilePut(GetMCFileName, Buffer);
end;

procedure TBBotClientTools.SaveClient(const AName, AFileName, AParam, AIP, AVersion: BStr);
var
  Add: TBBotClients.It;
begin
  Add := Clients.Find('Saving client ' + AName,
    function(It: TBBotClients.It): BBool
    begin
      Result := BStrEqual(It^.Name, AName);
    end);
  if Add = nil then
    Add := Clients.Add(TBBotClientToolsClient.Create(Self));
  Add^.Name := AName;
  Add^.FileName := AFileName;
  Add^.Param := AParam;
  Add^.IP := AIP;
  Add^.Version := AVersion;
  Add^.ClearPatches;
  SaveClients;
end;

{ TBBotClientToolsClient }

procedure TBBotClientToolsClient.AddPatch(const AOriginal: BStr; const AKind: TBBotClientToolsPatchKind);
var
  Buffer: array of BInt8;
  I: BInt32;
begin
  SetLength(Buffer, Length(AOriginal));
  for I := 0 to Length(AOriginal) - 1 do
    Buffer[I] := Ord(AOriginal[I + 1]);
  AddPatch(Buffer, AKind);
end;

procedure TBBotClientToolsClient.AddPatch(const AOriginal: array of BInt8; const AKind: TBBotClientToolsPatchKind);
var
  It: BVector<TBBotClientToolsPatch>.It;
  I: BInt32;
begin
  It := Patches.Add;
  SetLength(It^.Original, Length(AOriginal));
  for I := 0 to High(AOriginal) do
    It^.Original[I] := AOriginal[I];
  It^.Kind := AKind;
  It^.Address := 0;
end;

procedure TBBotClientToolsClient.ClearPatches;
begin
  Patches.ForEach(
    procedure(It: BVector<TBBotClientToolsPatch>.It)
    begin
      It^.Address := 0;
    end);
end;

constructor TBBotClientToolsClient.Create(AClientTools: TBBotClientTools);
begin
  FClientTools := AClientTools;
  FName := '';
  FFileName := '';
  FParam := '';
  FIP := '';
  FVersion := 'Auto';
  Patches := BVector<TBBotClientToolsPatch>.Create;
  AddPatch(TibiaPlayerMutex, bctpkMutex);
  AddPatch('login01.tibia.com', bctpkIP);
  AddPatch('login02.tibia.com', bctpkIP);
  AddPatch('login03.tibia.com', bctpkIP);
  AddPatch('login04.tibia.com', bctpkIP);
  AddPatch('login05.tibia.com', bctpkIP);
  AddPatch('tibia01.cipsoft.com', bctpkIP);
  AddPatch('tibia02.cipsoft.com', bctpkIP);
  AddPatch('tibia03.cipsoft.com', bctpkIP);
  AddPatch('tibia04.cipsoft.com', bctpkIP);
  AddPatch('tibia05.cipsoft.com', bctpkIP);
  AddPatch('test.tibia.com', bctpkIP);
  AddPatch('test.cipsoft.com', bctpkIP);
  AddPatch('tibia1.cipsoft.com', bctpkIP);
  AddPatch('tibia2.cipsoft.com', bctpkIP);
  AddPatch('server.tibia.com', bctpkIP);
  AddPatch('server2.tibia.com', bctpkIP);

  AddPatch('1247104594268279430043764498979855821678017079606970371640449048' +
  //
    '6294856938085042139690459768695387702239460423942818549828416906' + //
    '8581802277612081027966724336319448537811441719076484340922854929' + //
    '2735173086613707271053828991189994038080458464446472844991231648' + //
    '79035103627004668521005328367415259939915284902061793', bctpkRSA);

  AddPatch('1321277432058722840622950990822933849527763264961655079678763618' +
  //
    '4334395343554449668205332383339435179772895415509701210392836078' + //
    '6959821132214473291575712138800495033169914814069637740318278150' + //
    '2907336840325241747827401343576296990629870233111328210165697754' + //
    '88792221429527047321331896351555606801473202394175817', bctpkRSA);

  AddPatch('1429962396241639952007017738289889555079540334546615321747051608' +
  //
    '2934737582776038882967213386204600674145392845853859217990626450' + //
    '9724520840657286865659265687630979195970404721891201847792002125' + //
    '5354012927791239372074475745966927885136471792353355293072513505' + //
    '70728407373705564708871762033017096809910315212883967', bctpkRSA);

  AddPatch([$6A, $00, $6A, $01, $6A, $4D, $E8], bctpkUpdateDialog);
end;

destructor TBBotClientToolsClient.Destroy;
begin
  Patches.Free;
  inherited;
end;

procedure TBBotClientToolsClient.GatherAddresses();
begin
  Patches.ForEach(
    procedure(It: BVector<TBBotClientToolsPatch>.It)
    var
      Buffer: BBInt8Buffer;
      I: BInt32;
    begin
      if (It^.Address <> 0) and (It^.Address <> ProcessScanSize) then begin
        SetLength(Buffer, Length(It^.Original));
        ReadProcess(BPtr(It^.Address), @Buffer[0], Length(Buffer));
        for I := 0 to High(It^.Original) do
          if It^.Original[I] <> Buffer[I] then begin
            It^.Address := 0;
            Break;
          end;
      end;
      if It^.Address = 0 then
        It^.Address := ProcessScan(hProcess, @It^.Original[0], Length(It^.Original));
    end);
  ClientTools.SaveClients;
end;

procedure UnPatchTibia(Data: PBBotClientToolsUnpatch); stdcall;
var
  MutexAddr: BUInt32;
begin
  ResumeThread(Data^.hThread);
  Sleep(5000);
  MutexAddr := ProcessScan(Data^.hProc, BPChar(@Data^.NewMutex[1]), Length(Data^.NewMutex));
  if (MutexAddr <> 0) and (MutexAddr <> ProcessScanSize) then
    ProcessProtectedWrite(Data^.hProc, BPtr(MutexAddr), @TibiaPlayerMutex[1], Length(TibiaPlayerMutex));
  CloseHandle(Data^.hThread);
  CloseHandle(Data^.hProc);
  Dispose(Data);
end;

procedure TBBotClientToolsClient.Launch;
var
  ProcInfo: TProcessInformation;
  StartInfo: _STARTUPINFOA;
  Command, Path: BStr;
  UnPatchData: PBBotClientToolsUnpatch;
  LaunchEntry: BVector<TBBotClientToolsLaunchedEntries>.It;
  TibiaVer: TTibiaVersion;
begin
  Command := FileName + ' ' + Param;
  Path := ExtractFilePath(FileName);
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  FillChar(ProcInfo, SizeOf(ProcInfo), 0);
  if not FileExists(FileName) then begin
    ShowMessage('The file ' + FileName + ' does not exist!');
    Exit;
  end;
  if not CreateProcessA(nil, @Command[1], nil, nil, False, CREATE_SUSPENDED, nil, @Path[1], StartInfo, ProcInfo) then
    ShowMessage(BFormat('Unable to create tibia process, error %d', [GetLastError]));
  hProcess := ProcInfo.hProcess;
  if Version <> 'Auto' then begin
    for TibiaVer := TibiaVerFirst to TibiaVerLast do
      if BStrEqual(Version, BotVerSupported[TibiaVer]) then begin
        LaunchEntry := ClientToolsLaunchedCustomEntries.Add;
        LaunchEntry.PID := ProcInfo.dwProcessId;
        LaunchEntry.Version := TibiaVer;
        Break;
      end;
  end;
  GatherAddresses();
  PatchTibia();
  New(UnPatchData);
  UnPatchData^.NewMutex := NewMutex;
  UnPatchData^.hProc := ProcInfo.hProcess;
  UnPatchData^.hThread := ProcInfo.hThread;
  BThread(@UnPatchTibia, UnPatchData);
  hProcess := 0;
end;

procedure TBBotClientToolsClient.PatchTibia();
var
  S: BStr;
begin
  NewMutex := 'TibiaPlay' + FormatDateTime('nnsszzz', Now);
  Patches.ForEach(
    procedure(It: BVector<TBBotClientToolsPatch>.It)
    begin
      if (It^.Address <> 0) and (It^.Address <> ProcessScanSize) then begin
        if It^.Kind = bctpkMutex then begin
          if WriteProcess(BPtr(It^.Address), @NewMutex[1], Length(NewMutex)) <> BUInt32(Length(NewMutex)) then
            raise BException.Create(BFormat('Unable to patch Tibia mutex, error %d', [GetLastError]));
        end else if (It^.Kind = bctpkRSA) and (FIP <> '') then begin
          if WriteProcess(BPtr(It^.Address), @OTServerRSA[1], Length(OTServerRSA)) <> BUInt32(Length(OTServerRSA)) then
            raise BException.Create(BFormat('Unable to patch Tibia rsa, error %d', [GetLastError]));
        end else if (It^.Kind = bctpkIP) and (FIP <> '') then begin
          S := FIP + #0;
          if WriteProcess(BPtr(It^.Address), @S[1], Length(S)) <> BUInt32(Length(S)) then
            raise BException.Create(BFormat('Unable to patch Tibia ip, error %d', [GetLastError]));
        end else if It^.Kind = bctpkUpdateDialog then begin
          S := '';
          while Length(S) <> (Length(It^.Original) + 4) do // +4 = call address
            S := S + #$90;
          if WriteProcess(BPtr(It^.Address), @S[1], Length(S)) <> BUInt32(Length(S)) then
            raise BException.Create(BFormat('Unable to patch Tibia update dialog, error %d', [GetLastError]));
        end;
      end;
    end);
end;

function TBBotClientToolsClient.ReadProcess(AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
begin
  Result := ProcessProtectedRead(hProcess, AAddress, ABuffer, ASize);
end;

function TBBotClientToolsClient.Serialize: BStr;
var
  Addresses: BStr;
begin
  Addresses := '';
  Patches.ForEach(
    procedure(It: BVector<TBBotClientToolsPatch>.It)
    begin
      Addresses := Addresses + BFormat('%d,', [It^.Address]);
    end);
  Delete(Addresses, Length(Addresses), 1);
  Result := BFormat('%s@@%s@@%s@@%s@@%s@@%s', [FName, FFileName, FIP, Addresses, FParam, FVersion]);
end;

function TBBotClientToolsClient.UnSerialize(const ACode: BStr): BBool;
var
  R, A: BStrArray;
  N, J: BInt32;
begin
  N := BStrSplit(R, '@@', ACode);
  if BIntIn(N, [3, 5, 6]) then begin
    if N = 3 then begin
      FName := R[0];
      FFileName := R[1];
      FParam := R[2];
    end else begin
      FName := R[0];
      FFileName := R[1];
      FIP := R[2];
      if BStrSplit(A, ',', R[3]) = Patches.Count then
        for J := 0 to High(A) do
          Patches[J].Address := BUInt32(BStrTo32(A[J], 0));
      FParam := R[4];
      if N = 6 then
        FVersion := R[5];
    end;
    Exit(True);
  end
  else
    Exit(False);
end;

function TBBotClientToolsClient.WriteProcess(AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
begin
  Result := ProcessProtectedWrite(hProcess, AAddress, ABuffer, ASize);
end;

initialization

ClientToolsLaunchedCustomEntries := BVector<TBBotClientToolsLaunchedEntries>.Create();

finalization

ClientToolsLaunchedCustomEntries.Free;

end.
