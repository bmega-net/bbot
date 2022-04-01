unit uDLL;

interface

uses uBTypes, Windows;

procedure InitDLL;

const
  BDllU32: BUInt32 = 14243642;

var
  DLLEngineShowFPS: BPBool;
  DLLEngineLastSeeID: BPInt32;

procedure BGetError;
procedure DllMain(Reason: Integer);
procedure InitThreadHook;

implementation

uses StrUtils, uDllHookHUD, uDllHookInput, uDllHookNET,
  SysUtils, Classes, uDllTibiaState, uDllCodecave;

procedure BGetError;
var
  Es: BStr;
begin
  Es := 'Critical error code: ' + BStr(IntToStr(GetLastError));
  MessageBoxA(0, BPChar(@Es[1]), 'Error', 0);
  ExitProcess(0);
end;

type
  TPeekMessageFunc = function(lpMsg: LPVOID; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall;
  TSleepFunc = procedure(dwMilliseconds: DWORD); stdcall;
var
  OriginalPeekMessage: BPtr;
  OriginalSleep: BPtr;
  TibiaThreadID: BUInt32;

function BDllPeekMessage(lpMsg: LPVOID; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall;
begin
  UpdateTibiaState;
  Result := TPeekMessageFunc(OriginalPeekMessage)(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax, wRemoveMsg);
end;

procedure BDllSleep(dwMilliseconds: DWORD); stdcall;
var
  D: DWORD;
begin
  if GetCurrentThreadId = TibiaThreadID then
  begin
    D := dwMilliseconds;
    while D > 10 do
    begin
      UpdateTibiaState;
      TSleepFunc(OriginalSleep)(10);
      Dec(D, 10);
    end;
    TSleepFunc(OriginalSleep)(D);
  end else
    TSleepFunc(OriginalSleep)(dwMilliseconds);
end;

procedure InitThreadHook;
begin
  TibiaThreadID := GetCurrentThreadId;
  InitHUDHook;
  InitNETHook;

  InjectIATHook(GetModuleHandle(nil), 'PeekMessageA', BPtr(@BDllPeekMessage), @OriginalPeekMessage);
  InjectIATHook(GetModuleHandle(nil), 'Sleep', BPtr(@BDllSleep), @OriginalSleep);
end;

procedure InitDLL;
begin
  InitTibiaState;
  InitInputHook;
end;

procedure UnInitDll;
begin
  DeInitTibiaState;
end;

procedure DllMain(Reason: Integer);
begin
  if Reason = DLL_PROCESS_ATTACH then
    InitDLL
  else if Reason = DLL_PROCESS_DETACH then
    UnInitDll;
end;

end.
