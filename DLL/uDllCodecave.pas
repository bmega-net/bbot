unit uDllCodecave;

interface

uses uBTypes, Windows;

procedure InjectCodeCave(TargetAddress: BPtr; TargetSize: BUInt32;
  RedirectAddress: BPtr; OriginalCall: BPtr; OPJmpOrCall: BInt8);
procedure InjectNop(TargetAddress: BPtr; TargetSize: BUInt32);
procedure InjectIATHook(TargetModule: HMODULE; TargetFunction: BStr;
  RedirectAddress: BPtr; OriginalCall: BPtr);

const
  ICC_JMP = $E9;
  ICC_CALL = $E8;

implementation

uses SysUtils;

procedure InjectCodeCave(TargetAddress: BPtr; TargetSize: BUInt32;
  RedirectAddress: BPtr; OriginalCall: BPtr; OPJmpOrCall: BInt8);
var
  oldProtect, newProtect: BUInt32;
  PatchOP: BPInt8;
  PatchAddress: BPPtr;
  PatchPad: BPInt8;
  PadI: BInt32;
begin
  VirtualProtectEx(GetCurrentProcess, TargetAddress, TargetSize, PAGE_READWRITE,
    @oldProtect);

  PatchOP := TargetAddress;
  PatchAddress := BPtr(BUInt32(TargetAddress) + 1);
  PatchPad := BPtr(BUInt32(TargetAddress) + 5);

  if Assigned(OriginalCall) then
    BPUInt32(OriginalCall)^ :=
      BUInt32(BUInt32(PatchAddress^) + BUInt32(TargetAddress) + 5);

  PatchOP^ := OPJmpOrCall;
  PatchAddress^ := BPtr(BUInt32(RedirectAddress) - BUInt32(TargetAddress) - 5);

  if TargetSize > 5 then
  begin
    for PadI := 1 to (TargetSize - 5) do
    begin
      PatchPad^ := $90; // NOP
      Inc(PatchPad);
    end;
  end;

  VirtualProtectEx(GetCurrentProcess, TargetAddress, TargetSize, oldProtect,
    @newProtect);
end;

procedure InjectNop(TargetAddress: BPtr; TargetSize: BUInt32);
var
  oldProtect: BUInt32;
  PatchOP: BPInt8;
  I: BUInt32;
begin
  VirtualProtectEx(GetCurrentProcess, TargetAddress, TargetSize, PAGE_READWRITE,
    @oldProtect);
  PatchOP := TargetAddress;
  for I := 0 to TargetSize - 1 do
  begin
    PatchOP^ := $90;
    Inc(PatchOP);
  end;
  VirtualProtectEx(GetCurrentProcess, TargetAddress, TargetSize, oldProtect,
    @oldProtect);
end;

function GetModuleImportTable(Module: HMODULE): PIMAGE_IMPORT_DESCRIPTOR;
var
  DosHeader: ^IMAGE_DOS_HEADER;
  OptionalHeader: ^IMAGE_OPTIONAL_HEADER32;
begin
  DosHeader := BPtr(Module);
  if DosHeader^.e_magic <> $5A4D then
    Exit(nil);
  OptionalHeader := BPtr(BUInt32(Module + BUInt32(dosHeader^._lfanew) + 24));
  if OptionalHeader^.Magic <> $10B then
    Exit(nil);
  if (OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].Size = 0) or
  (OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress = 0) then
    Exit(nil);
  Result := BPtr(Module + OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);
end;

function GetIATAddress(Module: HMODULE; Name: BStr): BUInt32;
var
  N: BUInt32;
  Descriptor: PIMAGE_IMPORT_DESCRIPTOR;
  Thunk: PIMAGE_THUNK_DATA32;
  ThunkFuncName: BPChar;
begin
  Descriptor := GetModuleImportTAble(Module);
  while Descriptor.FirstThunk <> 0 do
  begin
    N := 0;
    Thunk := BPtr(Module + Descriptor.OriginalFirstThunk);
    while Thunk^._Function <> 0 do
    begin
      ThunkFuncName := BPtr(Module + Thunk^.AddressOfData + 2);
      if BStrEqual(ThunkFuncName, Name) then
      begin
        Result := BUInt32(Module + Descriptor.FirstThunk + (N * SizeOf(DWord)));
        Exit;
      end;
      Inc(N);
      Inc(Thunk);
    end;
    Inc(Descriptor);
  end;
  Result := 0;
end;


procedure InjectIATHook(TargetModule: HMODULE; TargetFunction: BStr;
  RedirectAddress: BPtr; OriginalCall: BPtr);
var
  oldProtect: BUInt32;
  IATAddress: BUInt32;
begin
  IATAddress := GetIATAddress(TargetModule, TargetFunction);
  VirtualProtectEx(GetCurrentProcess, BPtr(IATAddress), 4, PAGE_READWRITE,
    @oldProtect);

  if OriginalCall <> nil then
    BPUInt32(OriginalCall)^ := BPUInt32(IATAddress)^;
  BPUInt32(IATAddress)^ := BUInt32(RedirectAddress);

  VirtualProtectEx(GetCurrentProcess, BPtr(IATAddress), 4, oldProtect,
    @oldProtect);
end;

end.
