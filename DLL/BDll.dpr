library BDll;

{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

uses
  uBTypes in '..\Source\uBTypes.pas',
  uBotPacket in '..\Source\uBotPacket.pas',
  uDLL in 'uDLL.pas',
  uDllHUD in 'uDllHUD.pas',
  uDllPackets in 'uDllPackets.pas',
  uDllHookHUD in 'uDllHookHUD.pas',
  uDllHookNET in 'uDllHookNET.pas',
  uDllHookInput in 'uDllHookInput.pas',
  uDllCodecave in 'uDllCodecave.pas',
  uDllContainerState in 'uDllContainerState.pas',
  uDllTibiaState in 'uDllTibiaState.pas',
  Windows,
  uDllDash in 'uDllDash.pas',
  uBVector in '..\Source\uBVector.pas',
  uDllAccountState in 'uDllAccountState.pas',
  uDllContainerState850 in 'DLLContainerState\uDllContainerState850.pas',
  uDllContainerState942 in 'DLLContainerState\uDllContainerState942.pas',
  uDllContainerState943 in 'DLLContainerState\uDllContainerState943.pas',
  uDllContainerState984 in 'DLLContainerState\uDllContainerState984.pas',
  uDllContainerState990 in 'DLLContainerState\uDllContainerState990.pas',
  uDllContainerState991 in 'DLLContainerState\uDllContainerState991.pas',
  uDllContainerState1021 in 'DLLContainerState\uDllContainerState1021.pas',
  uDllContainerState1050 in 'DLLContainerState\uDllContainerState1050.pas';

{$R *.res}

begin
  DllProc := DllMain;
  DllProc(DLL_PROCESS_ATTACH);
end.
