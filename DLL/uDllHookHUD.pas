unit uDllHookHUD;

interface

uses uBTypes;

procedure InitHUDHook;

var
  PrintText: procedure(ASurface, AX, AY, AFont, AR, AG, AB, AAlign: BInt32;
    Text: BPChar);

implementation

uses uDllHUD, Windows, Math, SysUtils, uDllCodecave, uDllTibiaState;

var
  PrintMapOriginal, PrintMapMy: BPtr;
  _AbsX, _AbsY, _AbsZ, _ScreenX, _ScreenY: BInt32;

  PrintFPSEnabled: BPBool;
  LastClickID: BPInt32;

procedure HUDManagerUpdate;
begin
  HUDManager.UpdatePosition(_AbsX, _AbsY, _AbsZ, _ScreenX, _ScreenY);
end;

procedure DoPrintFPS(Text: BPChar; Surface, X, Y, Font, Red, Green, Blue,
  Align: BInt32);
var
  Buffer: BStr;
begin
  Buffer := Text;
  Buffer := Buffer + ' Ping: ' + BStr(IntToStr(TibiaState^.Ping));
  Buffer := Buffer + ' ID: ' + BStr(IntToStr(LastClickID^));
  Buffer := Buffer + #0;
  PrintText(Surface, X, Y, Font, Red, Green, Blue, Align, @Buffer[1]);
end;

{$REGION 'Print Text 850'}

var
  PrintTextFunc850: procedure(nSuface, NX, NY, nFont, nRed, nGreen,
    nBlue: integer; lpText: BPChar; nAlign: integer); cdecl;

procedure PrintText850(ASurface, AX, AY, AFont, AR, AG, AB, AAlign: integer;
  Text: BPChar);
begin
  PrintTextFunc850(ASurface, AX, AY, AFont, AR, AG, AB, Text, AAlign);
end;

procedure MyPrintName850(nSurface, NX, NY, nFont, nRed, nGreen, nBlue: integer;
  lpText: BPChar; nAlign: integer); cdecl;
var
  CID: BInt32;
begin
  CID := BPInt32(BPtr(BUInt32(lpText) - 4))^;
  PrintTextFunc850(nSurface, NX, NY, nFont, nRed, nGreen, nBlue,
    lpText, nAlign);
  HUDManager.OnPrintCreature(CID, nSurface, nFont, NX, NY);
end;

procedure MyPrintFps850(nSurface, NX, NY, nFont, nRed, nGreen, nBlue: BInt32;
  lpText: BPChar; nAlign: BInt32); cdecl;
begin
  if PrintFPSEnabled^ then
    DoPrintFPS(lpText, nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign);
  HUDManager.OnPrintFPS(nSurface, nFont);
end;
{$ENDREGION}
{$REGION 'Print Text 910'}

var
  PrintTextFunc910: procedure(nSuface, NX, NY, nFont, nRed, nGreen,
    nBlue: integer; nAlign: integer); cdecl;

procedure PrintText910(ASurface, AX, AY, AFont, AR, AG, AB, AAlign: BInt32;
  Text: BPChar);
begin
  asm
    PUSH EDX
    MOV EDX, DWORD PTR DS:[Text]
  end;
  PrintTextFunc910(ASurface, AX, AY, AFont, AR, AG, AB, AAlign);
  asm
    POP EDX
  end;
end;

procedure MyPrintName910(nSurface, NX, NY, nFont, nRed, nGreen, nBlue: BInt32;
  nAlign: BInt32); cdecl;
var
  CID: BInt32;
  lpText: BPChar;
begin
  asm
    MOV DWORD PTR DS:[lpText], EDX
  end;
  CID := BPInt32(BPtr(BUInt32(lpText) - 4))^;
  PrintTextFunc910(nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign);
  HUDManager.OnPrintCreature(CID, nSurface, nFont, NX, NY);
end;

procedure MyPrintFps910(nSurface, NX, NY, nFont, nRed, nGreen, nBlue: BInt32;
  nAlign: BInt32); cdecl;
var
  lpText: BPChar;
begin
  if PrintFPSEnabled^ then
  begin
    asm
      MOV DWORD PTR DS:[lpText], EDX
    end;
    DoPrintFPS(lpText, nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign);
  end;
  HUDManager.OnPrintFPS(nSurface, nFont);
end;
{$ENDREGION}
{$REGION 'Print Text 942'}

var
  PrintTextFunc942: procedure(nSuface, NX, NY, nFont, nRed, nGreen,
    nBlue: integer; nAlign: integer); cdecl;

procedure PrintText942(ASurface, AX, AY, AFont, AR, AG, AB, AAlign: BInt32;
  Text: BPChar);
begin
  asm
    PUSH ECX
    MOV ECX, DWORD PTR DS:[Text]
  end;
  PrintTextFunc942(ASurface, AX, AY, AFont, AR, AG, AB, AAlign);
  asm
    POP ECX
  end;
end;

procedure MyPrintName942(nSurface, NX, NY, nFont, nRed, nGreen, nBlue: BInt32;
  nAlign: BInt32); cdecl;
var
  CID: BInt32;
  lpText: BPChar;
begin
  asm
    MOV DWORD PTR DS:[lpText], ECX
  end;
  PrintTextFunc942(nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign);
  CID := BPInt32(PTR(BUInt32(lpText) - 4))^;
  HUDManager.OnPrintCreature(CID, nSurface, nFont, NX, NY);
end;

procedure MyPrintFps942(nSurface, NX, NY, nFont, nRed, nGreen, nBlue: BInt32;
  nAlign: BInt32); cdecl;
var
  lpText: BPChar;
begin
  if PrintFPSEnabled^ then
  begin
    asm
      MOV DWORD PTR DS:[lpText], ECX
    end;
    DoPrintFPS(lpText, nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign);
  end
  else
    PrintTextFunc942(nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign);
  HUDManager.OnPrintFPS(nSurface, nFont);
end;
{$ENDREGION}
{$REGION 'Print Text 1050'}

var
  PrintTextFunc1050: procedure(NY, nFont, nRed, nGreen,
    nBlue: integer; Text: BPChar; nAlign: integer); cdecl;

procedure PrintText1050(ASurface, AScreenX, AScreenY, AFont, AR, AG, AB, AAlign: BInt32;
  Text: BPChar);
begin
  asm
    PUSH ECX
    PUSH EDX
    MOV ECX, DWORD PTR DS:[ASurface]
    MOV EDX, DWORD PTR DS:[AScreenX]
  end;
  PrintTextFunc1050(AScreenY, AFont, AR, AG, AB, Text, AAlign);
  asm
    POP EDX
    POP ECX
  end;
end;

procedure MyPrintName1050(NY, nFont, nRed, nGreen,
    nBlue: integer; Text: BPChar; nAlign: integer); cdecl;
var
  CID: BInt32;
  NX, nSurface: BInt32;
begin
  asm
    MOV DWORD PTR DS:[nSurface], ECX
    MOV DWORD PTR DS:[NX], EDX
  end;
  PrintTextFunc1050(NY, nFont, nRed, nGreen, nBlue, Text, nAlign);
  CID := BPInt32(PTR(BUInt32(Text) - 4))^;
  HUDManager.OnPrintCreature(CID, nSurface, nFont, NX, NY);
end;

procedure MyPrintFps1050(NY, nFont, nRed, nGreen,
    nBlue: integer; Text: BPChar; nAlign: integer); cdecl;
var
  NX, nSurface: BInt32;
begin
  asm
    MOV DWORD PTR DS:[nSurface], ECX
    MOV DWORD PTR DS:[NX], EDX
  end;
  if PrintFPSEnabled^ then
    DoPrintFPS(Text, nSurface, NX, NY, nFont, nRed, nGreen, nBlue, nAlign)
  else
    PrintTextFunc1050(NY, nFont, nRed, nGreen, nBlue, Text, nAlign);
  HUDManager.OnPrintFPS(nSurface, nFont);
end;
{$ENDREGION}



{$REGION 'Print Map 850'}

procedure MyPrintMapHook850(retn, ScreenX, ScreenY, a3, a4, a5, a6, AbsX, AbsY,
  AbsZ: BInt32); cdecl;
begin
  asm
    PUSH EAX
    PUSH EDX
    PUSH ECX
  end;
  _AbsX := AbsX;
  _AbsY := AbsY;
  _AbsZ := AbsZ;
  _ScreenX := ScreenX;
  _ScreenY := ScreenY;
  HUDManagerUpdate;
  asm
    POP ECX
    POP EDX
    POP EAX
  end;
end;
{$ENDREGION}
{$REGION 'Print Map 910'}

procedure MyPrintMapHook910(retn, a1, ScreenX, ScreenY, a4, a5, a6, a7,
  AbsZ: BInt32); cdecl;
begin
  asm
    PUSH EAX
    MOV DWORD PTR DS:[_AbsX], EDX
    MOV DWORD PTR DS:[_AbsY], ECX
  end;
  _AbsZ := AbsZ;
  _ScreenX := ScreenX;
  _ScreenY := ScreenY;
  HUDManagerUpdate;
  asm
    POP EAX
    MOV ECX, DWORD PTR DS:[_AbsY]
    MOV EDX, DWORD PTR DS:[_AbsX]
  end;
end;
{$ENDREGION}
{$REGION 'Print Map 942'}

procedure MyPrintMapHook942(retn, a1, ScreenX, ScreenY, a4, a5, a6, a7,
  AbsZ: BInt32); cdecl;
begin
  asm
    MOV DWORD PTR DS:[_AbsX], ECX
    MOV DWORD PTR DS:[_AbsY], EDX
  end;
  _AbsZ := AbsZ;
  _ScreenX := ScreenX;
  _ScreenY := ScreenY;
  HUDManagerUpdate;
  asm
    MOV ECX, DWORD PTR DS:[_AbsX]
    MOV EDX, DWORD PTR DS:[_AbsY]
  end;
end;
{$ENDREGION}
{$REGION 'Print Map 990'}

procedure MyPrintMapHook990(retn, a1, ScreenX, ScreenY, a4, a5, a6, a7, a8, a9,
  a10, a11, AbsX: BInt32); cdecl;
asm
  MOV DWORD PTR DS:[_AbsY], ECX
  MOV DWORD PTR DS:[_AbsZ], EDX

  MOV ECX, DWORD PTR DS:[AbsX]
  MOV DWORD PTR DS:[_AbsX], ECX

  MOV ECX, DWORD PTR DS:[ScreenX]
  MOV DWORD PTR DS:[_ScreenX], ECX

  MOV ECX, DWORD PTR DS:[ScreenY]
  MOV DWORD PTR DS:[_ScreenY], ECX

  PUSH EAX
  CALL HUDManagerUpdate
  POP EAX

  MOV ECX, DWORD PTR DS:[_AbsY]
  MOV EDX, DWORD PTR DS:[_AbsZ]
end;
{$ENDREGION}
{$REGION 'Print Map 1021'}

procedure MyPrintMapHook1021(retn, a1, ScreenX, a3, a4, a5, a6, a7, a8, a9, a10,
  a11, a12, AbsX, AbsY: BInt32); cdecl;
asm
  MOV DWORD PTR DS:[_ScreenY], ECX
  MOV DWORD PTR DS:[_AbsZ], EDX

  MOV ECX, DWORD PTR DS:[AbsX]
  MOV DWORD PTR DS:[_AbsX], ECX

  MOV ECX, DWORD PTR DS:[AbsY]
  MOV DWORD PTR DS:[_AbsY], ECX

  MOV ECX, DWORD PTR DS:[ScreenX]
  MOV DWORD PTR DS:[_ScreenX], ECX

  PUSH EAX
  CALL HUDManagerUpdate
  POP EAX

  MOV ECX, DWORD PTR DS:[_ScreenY]
  MOV EDX, DWORD PTR DS:[_AbsZ]
end;
{$ENDREGION}
{$REGION 'Print Map 1050'}

procedure MyPrintMapHook1050(retn, ScreenX, ScreenY, a3, a4, a5, a6, a7, a8, a9, a10,
  a11, AbsX, AbsY, AbsZ: BInt32); cdecl;
asm
  PUSH ECX
  MOV ECX, DWORD PTR DS:[AbsX]
  MOV DWORD PTR DS:[_AbsX], ECX

  MOV ECX, DWORD PTR DS:[AbsY]
  MOV DWORD PTR DS:[_AbsY], ECX

  MOV ECX, DWORD PTR DS:[AbsZ]
  MOV DWORD PTR DS:[_AbsZ], ECX

  MOV ECX, DWORD PTR DS:[ScreenX]
  MOV DWORD PTR DS:[_ScreenX], ECX

  MOV ECX, DWORD PTR DS:[ScreenY]
  MOV DWORD PTR DS:[_ScreenY], ECX

  PUSH EAX
  CALL HUDManagerUpdate
  POP EAX

  POP ECX
end;
{$ENDREGION}
{$REGION 'Print Map Codecave'}

procedure CodeCavePrintMap; assembler;
asm
  PUSH PrintMapOriginal
  JMP PrintMapMy
end;
{$ENDREGION}

procedure InitHUDHook;
var
  fpName: BPtr;
  fpFPS: BPtr;
begin
  HUDManager := TBBotHUDManager.Create;

  PrintFPSEnabled := BPtr(TibiaState^.Addresses.PrintFPSEnabled);
  LastClickID := BPtr(TibiaState^.Addresses.AdrLastClickID);

  @PrintTextFunc850 := BPtr(TibiaState^.Addresses.PrintTextFunc);
  @PrintTextFunc910 := BPtr(TibiaState^.Addresses.PrintTextFunc);
  @PrintTextFunc942 := BPtr(TibiaState^.Addresses.PrintTextFunc);
  @PrintTextFunc1050 := BPtr(TibiaState^.Addresses.PrintTextFunc);
  fpName := nil;
  fpFPS := nil;


  if TibiaState^.Version >= TibiaVer1050 then
  begin
    PrintText := PrintText1050;
    PrintMapMy := @MyPrintMapHook1050;
    fpName := @MyPrintName1050;
    fpFPS := @MyPrintFps1050;
  end else if TibiaState^.Version >= TibiaVer1021 then
  begin
    PrintText := PrintText942;
    PrintMapMy := @MyPrintMapHook1021;
    fpName := @MyPrintName942;
    fpFPS := @MyPrintFps942;
  end
  else if TibiaState^.Version >= TibiaVer942 then
  begin
    PrintText := PrintText942;
    PrintMapMy := @MyPrintMapHook942;
    fpName := @MyPrintName942;
    fpFPS := @MyPrintFps942;
  end
  else if TibiaState^.Version >= TibiaVer910 then
  begin
    PrintText := PrintText910;
    PrintMapMy := @MyPrintMapHook910;
    fpName := @MyPrintName910;
    fpFPS := @MyPrintFps910;
  end
  else if TibiaState^.Version >= TibiaVer850 then
  begin
    PrintText := PrintText850;
    PrintMapMy := @MyPrintMapHook850;
    fpName := @MyPrintName850;
    fpFPS := @MyPrintFps850;
  end;

  InjectCodeCave(BPtr(TibiaState^.Addresses.PrintNameCall), 5, fpName, nil,
    ICC_CALL);
  InjectCodeCave(BPtr(TibiaState^.Addresses.PrintFPSCall), 5, fpFPS, nil,
    ICC_CALL);
  InjectCodeCave(BPtr(TibiaState^.Addresses.PrintMapCall), 5, @CodeCavePrintMap,
    @PrintMapOriginal, ICC_CALL);
  InjectNop(BPtr(TibiaState^.Addresses.PrintFPSNop), 6);

end;

end.
