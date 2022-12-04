unit uDllContainerState;

interface

uses uBTypes;

var
  LoadStateContainer: procedure;
procedure InitStateContainer;

implementation

uses uDllTibiaState, StrUtils, SysUtils, uDllContainerState850,
  uDllContainerState942, uDllContainerState943, uDllContainerState984,
  uDllContainerState990, uDllContainerState991, uDllContainerState1021,
  uDllContainerState1050;

procedure InitStateContainer;
var
  C: BInt32;
begin
  for C := 0 to High(TibiaState^.Container) do
    TibiaState^.Container[C].Open := False;
  if TibiaState^.Version >= TibiaVer1050 then
    InitState1050
  else if TibiaState^.Version >= TibiaVer1021 then
    InitState1021
  else if TibiaState^.Version >= TibiaVer991 then
    InitState991
  else if TibiaState^.Version >= TibiaVer990 then
    InitState990
  else if TibiaState^.Version >= TibiaVer984 then
    InitState984
  else if TibiaState^.Version >= TibiaVer943 then
    InitState943
  else if TibiaState^.Version >= TibiaVer942 then
    InitState942
  else if TibiaState^.Version >= TibiaVer850 then
    InitState850;
end;

end.
