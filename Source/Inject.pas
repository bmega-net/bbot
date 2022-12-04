unit Inject;

interface

uses
  uBTypes;

procedure InjectDll(PID: BInt32; DLL: BPChar);

implementation

uses
  Windows,
  SysUtils;

procedure InjectDll(PID: BInt32; DLL: BPChar);
const
  PROC_ALL_ACCESS = PROCESS_TERMINATE or PROCESS_CREATE_THREAD or
    PROCESS_VM_OPERATION or PROCESS_VM_READ or PROCESS_VM_WRITE or
    PROCESS_DUP_HANDLE or PROCESS_CREATE_PROCESS or PROCESS_SET_QUOTA or
    PROCESS_SET_INFORMATION or PROCESS_QUERY_INFORMATION;
var
  hProcess, hThread, TID: BUInt32;
  Param: BPtr;
  pThreadStartRoutine: BPtr;
  Ret: NativeUInt;
begin
  hProcess := OpenProcess(PROC_ALL_ACCESS, False, PID);
  Param := VirtualAllocEx(hProcess, nil, Length(DLL) + 1,
    MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE);
  if Param = nil then
    raise Exception.Create('RT LLB 0 not created');
  WriteProcessMemory(hProcess, Param, BPtr(DLL), Length(DLL) + 1, Ret);
  if Ret = 0 then
    raise Exception.Create('RT LLB 1 not created');
  pThreadStartRoutine := GetProcAddress(GetModuleHandle('KERNEL32.DLL'),
    'LoadLibraryA');
  hThread := CreateRemoteThread(hProcess, nil, 0, pThreadStartRoutine,
    Param, 0, TID);
  if hThread = 0 then
    raise Exception.Create('RT LLB 2 not created');
  CloseHandle(hProcess);
  Sleep(500);
end;

end.

