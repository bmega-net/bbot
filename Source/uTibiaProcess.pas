unit uTibiaProcess;


interface

uses
  uBTypes,
  Windows,
  Messages,
  PsAPI,
  SysUtils,
  TlHelp32;

type
  TBBotTibiaProcess = class
  private
    fHandle: BUInt32;
    fhWnd: BUInt32;
    fPID: BUInt32;
    FBaseAddress: BUInt32;
    FhDC: HDC;
    FBaseSize: BUInt32;
    function GetOnTop: BBool;
    function GetFileName: BStr;
    procedure RenewPID;
    procedure SethWnd(const Value: cardinal);
    function GetFileVersion: BStr;
    function GetTibiaRect: TRect;
    function GetTibiaClientRect: TRect;
    function GetPlacement: TWindowPlacement;
  public
    constructor Create;

    property hWnd: cardinal read fhWnd write SethWnd;
    property PID: cardinal read fPID write fPID;
    property HDC: HDC read FhDC;
    property Handle: cardinal read fHandle write fHandle;
    property OnTop: BBool read GetOnTop;
    property BaseAddress: BUInt32 read FBaseAddress;
    property BaseSize: BUInt32 read FBaseSize;
    property FileName: BStr read GetFileName;
    property FileVersion: BStr read GetFileVersion;
    property Rect: TRect read GetTibiaRect;
    property ClientRect: TRect read GetTibiaClientRect;
    property Placement: TWindowPlacement read GetPlacement;

    procedure GetBaseAddress;
    procedure RenewHandle;
    function NewHandle: BUInt32;
    procedure CloseHandle;

    procedure Terminate;

    function Read(Address, Size: BInt32; Buffer: pointer): BInt32;
    function Write(Address, Size: BInt32; Buffer: pointer): BInt32;

    function ReadEx(Address, Size: BInt32; Buffer: pointer): BInt32;
    function WriteEx(Address, Size: BInt32; Buffer: pointer): BInt32;

    function Protect(Address, Size: BInt32; NewProtect: BUInt32): BUInt32;

    function GetAddress(AAddress: BInt32): BUInt32;

    procedure SendClose;
    procedure SendText(S: BStr);
    procedure SendKey(K: Word);
    procedure SendKeyDown(K: Word);
    procedure SendKeyUp(K: Word);
    procedure SendMouseClick(P: TPoint);
    procedure SendMouseClickEx(X, Y: BInt32);

    procedure PrintPixel(const X, Y, R: BInt32; const Color: BUInt32);
    function GetPixelColor(const X, Y: BInt32): BUInt32;
    procedure OpenHDC;
    procedure CloseDC;
  end;

const
  ProcessScanChunkSize = 65535;
  ProcessScanSize = $FEFFFFFF;

function ProcessProtectedWrite(AProcess: BUInt32; AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
function ProcessProtectedRead(AProcess: BUInt32; AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
function ProcessScan(AProcess: BUInt32; ASearchBuffer: BPChar; ASearchSize: BUInt32): BUInt32;

var
  TibiaProcess: TBBotTibiaProcess;

implementation

uses
  uTibiaDeclarations,
  Declaracoes,
  uBBotAddresses;

function ProcessProtectedWrite(AProcess: BUInt32; AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
var
  BytesWritten: NativeUInt;
  OldProtection: BUInt32;
begin
  VirtualProtectEx(AProcess, AAddress, ASize, PAGE_READWRITE, OldProtection);
  WriteProcessMemory(AProcess, AAddress, ABuffer, ASize, BytesWritten);
  VirtualProtectEx(AProcess, AAddress, ASize, OldProtection, OldProtection);
  Result := BytesWritten;
end;

function ProcessProtectedRead(AProcess: BUInt32; AAddress: BPtr; ABuffer: BPInt8; ASize: BUInt32): BUInt32;
var
  BytesRead: NativeUInt;
  OldProtection: BUInt32;
begin
  VirtualProtectEx(AProcess, AAddress, ASize, PAGE_READWRITE, OldProtection);
  ReadProcessMemory(AProcess, AAddress, ABuffer, ASize, BytesRead);
  VirtualProtectEx(AProcess, AAddress, ASize, OldProtection, OldProtection);
  Result := BytesRead;
end;

function ProcessScan(AProcess: BUInt32; ASearchBuffer: BPChar; ASearchSize: BUInt32): BUInt32;
var
  Buffer: array [0 .. ProcessScanChunkSize] of BInt8;
  Offset: BUInt32;
  BytesRead: NativeUInt;
  Buff: BPChar;
begin
  Offset := 0;
  while Offset < ProcessScanSize do begin
    ReadProcessMemory(AProcess, BPtr(Offset), @Buffer[0], ProcessScanChunkSize, BytesRead);
    if BytesRead > 0 then begin
      Buff := @Buffer[0];
      while Buff < @Buffer[High(Buffer) - ASearchSize] do begin
        if CompareMem(Buff, ASearchBuffer, ASearchSize) then
          Exit(BUInt32(Buff) - BUInt32(@Buffer[0]) + Offset);
        Inc(Buff);
        Dec(BytesRead);
        if BytesRead = 0 then
          Break;
      end;
    end;
    Inc(Offset, ProcessScanChunkSize - ASearchSize - 1);
  end;
  Exit(ProcessScanSize);
end;

{ TBBotTibiaProcess }

function TBBotTibiaProcess.NewHandle: BUInt32;
begin
  Result := OpenProcess(BotProcessAccess, False, PID);
end;

procedure TBBotTibiaProcess.PrintPixel(const X, Y, R: BInt32; const Color: BUInt32);
var
  iX, iY: BInt32;
begin
  for iX := X - R to X + R do
    for iY := Y - R to Y + R do
      SetPixel(FhDC, iX, iY, Color);
end;

function TBBotTibiaProcess.Protect(Address, Size: BInt32; NewProtect: BUInt32): BUInt32;
var
  OldProtect: NativeUInt;
begin
  VirtualProtectEx(Handle, Ptr(Address), Size, NewProtect, @OldProtect);
  Result := OldProtect;
end;

procedure TBBotTibiaProcess.RenewHandle;
begin
  CloseHandle;
  Handle := NewHandle;
end;

procedure TBBotTibiaProcess.OpenHDC;
begin
  FhDC := GetDC(fhWnd);
end;

procedure TBBotTibiaProcess.SendClose;
begin
  SendMessageA(hWnd, WM_CLOSE, 0, 0);
end;

procedure TBBotTibiaProcess.SendKey(K: Word);
begin
  SendKeyDown(K);
  SendKeyUp(K);
end;

procedure TBBotTibiaProcess.SendKeyDown(K: Word);
begin
  PostMessageA(hWnd, WM_KEYDOWN, K, 0);
end;

procedure TBBotTibiaProcess.SendKeyUp(K: Word);
begin
  PostMessageA(hWnd, WM_KEYUP, K, NativeInt($C0000000)); // bit 30,31
end;

procedure TBBotTibiaProcess.SendMouseClick(P: TPoint);
var
  Pt: TPoint;
begin
  Pt.X := P.X;
  Pt.Y := P.Y;
  ForceActiveWindow(hWnd);
  ConvertPtToScreen(Pt);
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_MOVE, Pt.X, Pt.Y, 0, 0);
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, Pt.X, Pt.Y, 0, 0);
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, Pt.X, Pt.Y, 0, 0);
end;

procedure TBBotTibiaProcess.SendMouseClickEx(X, Y: BInt32);
var
  P: DWord;
  L: DWord;
  Minimized, Hidden: BBool;
  ShowCMD: BUInt32;
begin
  ShowCMD := Placement.ShowCMD;
  Minimized := (ShowCMD = SW_MINIMIZE) or (ShowCMD = SW_SHOWMINIMIZED);
  Hidden := ShowCMD = SW_HIDE;
  if Hidden or Minimized then
    ShowWindow(hWnd, SW_SHOWMAXIMIZED);
  P := (Y shl 16) or X;
  L := MakeLParam(HTCLIENT, WM_LBUTTONDOWN);
  SendMessage(hWnd, WM_MOUSEACTIVATE, WA_ACTIVE, L);
  SendMessage(hWnd, WM_SETCURSOR, 0, L);
  SendMessage(hWnd, WM_MOUSEMOVE, 0, P);
  SendMessage(hWnd, WM_LBUTTONDOWN, MK_LBUTTON, P);
  SendMessage(hWnd, WM_LBUTTONUP, MK_LBUTTON, P);
end;

procedure TBBotTibiaProcess.SendText(S: BStr);
var
  I: BInt32;
begin
  for I := 1 to Length(S) do
    SendMessage(hWnd, WM_CHAR, Word(S[I]), 0);
end;

procedure TBBotTibiaProcess.SethWnd(const Value: cardinal);
begin
  fhWnd := Value;
  RenewPID;
end;

procedure TBBotTibiaProcess.Terminate;
begin
  TerminateProcess(Handle, 0);
end;

function TBBotTibiaProcess.Read(Address, Size: BInt32; Buffer: pointer): BInt32;
begin
  Result := ReadEx(GetAddress(Address), Size, Buffer);
end;

function TBBotTibiaProcess.Write(Address, Size: BInt32; Buffer: pointer): BInt32;
begin
  Result := WriteEx(GetAddress(Address), Size, Buffer);
end;

procedure TBBotTibiaProcess.RenewPID;
begin
  GetWindowThreadProcessId(hWnd, @fPID);
  if fPID <> 0 then
    GetBaseAddress
  else
    raise Exception.Create('Unable to gather process id, possible anti-virus blocking.');
end;

procedure TBBotTibiaProcess.CloseDC;
begin
  ReleaseDC(hWnd, HDC);
  FhDC := 0;
end;

procedure TBBotTibiaProcess.CloseHandle;
begin
  if Handle <> 0 then begin
    Windows.CloseHandle(Handle);
    Handle := 0;
  end;
end;

constructor TBBotTibiaProcess.Create;
begin
  fHandle := 0;
  fhWnd := 0;
  fPID := 0;
  FBaseAddress := 0;
  FhDC := 0;
end;

procedure TBBotTibiaProcess.GetBaseAddress;
var
  h32SnapShot: BUInt32;
  ModuleEntry32: TModuleEntry32;
begin
  FBaseAddress := 0;
  h32SnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPMODULE, PID);
  if (h32SnapShot <> 0) and (h32SnapShot <> $FFFFFFFF) then begin
    ModuleEntry32.dwSize := SizeOf(TModuleEntry32);
    if Module32First(h32SnapShot, ModuleEntry32) then begin
      repeat
        if AnsiPos('.exe', ModuleEntry32.szModule) > 0 then begin
          FBaseAddress := BUInt32(ModuleEntry32.modBaseAddr);
          FBaseSize := BUInt32(ModuleEntry32.modBaseSize);
          Break;
        end;
      until not Module32Next(h32SnapShot, ModuleEntry32);
    end;
  end;
  if FBaseAddress = 0 then
    raise Exception.Create('BaseAddress not found, possible anti-virus blocking. EC: ' + IntToStr(GetLastError));
end;

function TBBotTibiaProcess.GetTibiaClientRect: TRect;
begin
  GetClientRect(hWnd, Result);
end;

function TBBotTibiaProcess.GetFileName: BStr;
var
  hMod: HMODULE;
  sMod: BStr255;
  cb: DWord;
begin
  if not EnumProcessModules(Handle, @hMod, SizeOf(hMod), cb) then
    raise Exception.Create('Error on P.GetFileName:1');
  if GetModuleFileNameExA(Handle, hMod, @sMod[0], SizeOf(sMod)) = 0 then
    raise Exception.Create('Error on P.GetFileName:2');
  Result := BPChar(@sMod[0]);
end;

function TBBotTibiaProcess.GetFileVersion: BStr;
var
  VerInfoSize: DWord;
  VerInfo: pointer;
  VerValueSize: DWord;
  VerValue: PVSFixedFileInfo;
  Dummy: DWord;
  OverrideSignatureBuffer: BStr255;
  OverrideSignature: BStr;
  Size: BInt32;
  I: BInt32;
begin
  VerInfoSize := GetFileVersionInfoSizeA(@FileName[1], Dummy);
  if VerInfoSize = 0 then
    raise Exception.Create('Error on P.GetFileVersion:1');
  GetMem(VerInfo, VerInfoSize);
  if not GetFileVersionInfoA(@FileName[1], 0, VerInfoSize, VerInfo) then
    raise Exception.Create('Error on P.GetFileVersion:2');
  if not VerQueryValueA(VerInfo, '\', pointer(VerValue), VerValueSize) then
    raise Exception.Create('Error on P.GetFileVersion:3');
  Result := IntToStr(VerValue^.dwFileVersionMS shr 16);
  Result := Result + '.' + IntToStr(VerValue^.dwFileVersionMS and $FFFF);
  Result := Result + IntToStr(VerValue^.dwFileVersionLS shr 16);
  Result := Result + IntToStr(VerValue^.dwFileVersionLS and $FFFF);
  FreeMem(VerInfo, VerInfoSize);
  for I := 0 to High(TibiaVersionOverrides) do
    if BStrEqual(TibiaVersionOverrides[I].FromVersion, Result) then begin
      Size := BCeil(Length(TibiaVersionOverrides[I].HexValue) / 3);
      Read(TibiaVersionOverrides[I].Address, Size, @OverrideSignatureBuffer);
      OverrideSignature := BinToHex(@OverrideSignatureBuffer, Size);
      if BStrStartSensitive(OverrideSignature, TibiaVersionOverrides[I].HexValue) then
        Exit(TibiaVersionOverrides[I].ToVersion);
    end;
end;

function TBBotTibiaProcess.GetAddress(AAddress: BInt32): BUInt32;
begin
  Result := FBaseAddress + BUInt32(AAddress - $400000);
end;

function TBBotTibiaProcess.ReadEx(Address, Size: BInt32; Buffer: pointer): BInt32;
var
  Ret: NativeUInt;
begin
  ReadProcessMemory(Handle, Ptr(Address), Buffer, Size, Ret);
  Result := Ret;
end;

function TBBotTibiaProcess.WriteEx(Address, Size: BInt32; Buffer: pointer): Integer;
var
  Ret: NativeUInt;
begin
  WriteProcessMemory(Handle, Ptr(Address), Buffer, Size, Ret);
  Result := Integer(Ret);
end;

function TBBotTibiaProcess.GetOnTop: BBool;
begin
  Result := GetForegroundWindow = hWnd;
end;

function TBBotTibiaProcess.GetPixelColor(const X, Y: BInt32): BUInt32;
begin
  Result := GetPixel(FhDC, X, Y);
end;

function TBBotTibiaProcess.GetPlacement: TWindowPlacement;
begin
  GetWindowPlacement(hWnd, Result);
end;

function TBBotTibiaProcess.GetTibiaRect: TRect;
begin
  GetWindowRect(hWnd, Result);
end;

initialization

TibiaProcess := TBBotTibiaProcess.Create;

finalization

_SafeFree(TibiaProcess);

end.

