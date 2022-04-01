unit Declaracoes;


interface

uses
  uBTypes,
  StrUtils,
  Math,
  SysUtils,
  Classes,
  Windows,
  Graphics,
  StdCtrls,
  ComCtrls,
  Menus,
  Forms,
  Spin,
  Messages,
  Grids,
  Buttons,
  uTibiaDeclarations,
  ExtCtrls,
  SyncObjs,
  Generics.Defaults;

var
  Loginad: boolean;

type
  TGradientDirection = (gdHorizontal, gdVertical);
function FillGradient(DC: HDC; ARect: TRect; ColorCount: BInt32; StartColor, EndColor: TColor;
  ADirection: TGradientDirection): BBool;

function BBotApiUrl(const ACmd: BStr): BStr;

procedure DoOpenURL(Url: BStr);

function ComboSelected(cmb: TComboBox): BStr;

function ComboSelectedObj(cmb: TComboBox): TObject;

function DeleteSpaces(Str: BStr): BStr;

function FileDialog(Title, Filter, SaveOrLoad: BStr; Owner: TComponent): BStr;

function UnixToDateTime(USec: Longint): TDateTime;

function GambitBox(Caption, Intro, Params: BStr; HaveReturn: boolean; var Values: BStrArray): boolean;

function GetInventoryName(IID: BInt32): BStr;

function GetUID: BInt32;

function HotkeyBox(var Hotkey: BStr): boolean;

function HPColor(HP: BInt32): TColor;

function I2FS(N: BInt32): BStr;

function NYByID(ID: BInt32): BPos;

function SecToTime(Sec: BInt32): BStr;

{$IFNDEF Release}
procedure setThisThreadName(const Name: BStr);
{$ENDIF}
procedure ShortCutToHotKey(Hotkey: TShortCut; var Key: Word; var Modifiers: Uint);

procedure ShutdownPC;

function ForceForegroundWindow(hwnd: THandle): boolean;

procedure ForceActiveWindow(hwnd: THandle);

procedure ConvertPtToScreen(var PT: TPoint);

function IntIn(Value: BInt32; const Values: array of BInt32): boolean; overload;

function IntIn(Value: BUInt32; const Values: array of BUInt32): boolean; overload;

function HexToInt(HexStr: BStr): Int64;

function BinToHex(const Buffer: BPtr; const Size: BInt32): BStr;

function UrlEncode(const DecodedStr: BStr; Pluses: BBool): BStr;

function UrlDecode(const EncodedStr: BStr): BStr;

function CRC32(p: pointer; ByteCount: DWORD): BInt32; overload;

function CRC32(s: BStr): BInt32; overload;

procedure OnLinkLabelEnter(Sender: TObject);

procedure OnLinkLabelLeave(Sender: TObject);

function DirToStr(Dir: TTibiaDirection): BStr;

function StrToDir(Str: BStr): TTibiaDirection;

procedure PlayWav(const FileName: BStr; const ALoop: BBool);

procedure StopWav;

function DistanceBetween(const PFrom, PTo: BPos): BInt32;

function HasFlag(Flags, Flag: BInt32): boolean;

function ExecNewProcess(FileName: BStr): THandle;

procedure ListShuffle(List: TList);

procedure PaintFormBackground(Canvas: TCanvas; Rect: TRect);

procedure BListDrawItem(Canvas: TCanvas; Index: BInt32; Selected: BBool; Rect: TRect; A: BStr); overload;

procedure BListDrawItem(Canvas: TCanvas; Index: BInt32; Selected: BBool; Rect: TRect; A, B: BStr); overload;

procedure BListUpdate(const AList: TListBox; const AUpdateCallback: BProc);

procedure _SafeFree(var Obj);

function KeyToStr(const AShiftState: TShiftState; const AKeyCode: BInt16): BStr;

function StrToKey(const AKeyName: BStr): BPair<BInt16, TShiftState>;

procedure IterateComponentControls(const AComponent: TComponent; const AProc: BUnaryProc<TComponent>);

procedure BListboxKeyDown(const Sender: TObject; var Key: Word; const Shift: TShiftState);

function ListToBStrArray(const AItems: TStrings): BStrArray;

type
  TFrameClass = class of TFrame;
function InsertFrame(const AParent: TPanel; const AFrameClass: TFrameClass): TFrame;

procedure BExecuteInSafeScope(const AName: BStr; const AMethod: BProc); // inline;

function BPosComparator: IEqualityComparer<BPos>;

implementation

uses

  Dialogs,

  ShellAPI,

  mmSystem,

  TlHelp32,
  uDistance,
  Controls;

function BBotApiUrl(const ACmd: BStr): BStr;
begin
  Result := 'http://api.bmega.net:80/api/' + ACmd + '.bbot';
  // Result := 'http://10.0.2.2:80/api/' + ACmd + '.bbot';
end;

function ListToBStrArray(const AItems: TStrings): BStrArray;
var
  I: BInt32;
begin
  SetLength(Result, AItems.Count);
  for I := 0 to AItems.Count - 1 do
    Result[I] := AItems.Strings[I];
end;

procedure BListboxKeyDown(const Sender: TObject; var Key: Word; const Shift: TShiftState);
var
  Selected: BInt32;
  Lst: TListBox;
begin
  if ssShift in Shift then begin
    Lst := TListBox(Sender);
    Selected := Lst.ItemIndex;
    if Selected <> -1 then begin
      case Key of
      VK_UP: begin
          if Selected > 0 then begin
            Lst.Items.Exchange(Selected - 1, Selected);
            Lst.ItemIndex := Selected;
          end;
        end;
      VK_DOWN: begin
          if Selected < (Lst.Items.Count - 1) then begin
            Lst.Items.Exchange(Selected + 1, Selected);
            Lst.ItemIndex := Selected;
          end;
        end;
      VK_DELETE: begin
          Lst.Items.Delete(Selected);
        end;
      end;
    end;
  end;
end;

procedure BListDrawItem(Canvas: TCanvas; Index: BInt32; Selected: BBool; Rect: TRect; A, B: BStr); overload;
begin
  if Selected then begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end else begin
    if Odd(Index) then
      Canvas.Brush.Color := $FFEEDD
    else
      Canvas.Brush.Color := $FFFFFF;
    Canvas.Font.Color := clBlack;
  end;
  Canvas.Font.Size := 8;
  Canvas.FillRect(Rect);
  Canvas.Font.Style := [fsBold];
  Canvas.TextOut(Rect.Left + 2, Rect.Top, A);
  if B <> '' then begin
    Inc(Rect.Left, Canvas.TextWidth(A) + 4);
    Canvas.Font.Style := [];
    Canvas.TextOut(Rect.Left + 2, Rect.Top, B);
  end;
end;

procedure BListDrawItem(Canvas: TCanvas; Index: BInt32; Selected: BBool; Rect: TRect; A: BStr); overload;
begin
  BListDrawItem(Canvas, Index, Selected, Rect, A, '');
end;

procedure BListUpdate(const AList: TListBox; const AUpdateCallback: BProc);
var
  Index: BInt32;
  TopIndex: BInt32;
begin
  try
    TopIndex := AList.TopIndex;
    AList.Items.BeginUpdate;
    Index := AList.ItemIndex;
    AUpdateCallback();
    AList.ItemIndex := Index;
    AList.TopIndex := TopIndex;
  finally AList.Items.EndUpdate;
  end;
end;

procedure _SafeFree(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  if Assigned(Temp) then begin
    pointer(Obj) := nil;
{$IFDEF Release}
    try Temp.Free;
    except
    end;
{$ELSE}
    Temp.Free;
{$ENDIF}
  end;
end;

procedure PaintFormBackground(Canvas: TCanvas; Rect: TRect);
const
  frmGradientA: TColor = $FFEEE9;
  frmGradientB: TColor = $F4E3DE;
var
  hMid: BInt32;
begin
  hMid := (Rect.Bottom - Rect.Top) div 2;
  Rect.Bottom := Rect.Bottom - hMid;
  FillGradient(Canvas.Handle, Rect, 256, frmGradientA, frmGradientB, gdVertical);
  Rect.Bottom := Rect.Bottom + hMid;
  Rect.Top := Rect.Top + hMid;
  FillGradient(Canvas.Handle, Rect, 256, frmGradientB, frmGradientA, gdVertical);
end;

function FillGradient(DC: HDC; ARect: TRect; ColorCount: BInt32; StartColor, EndColor: TColor;
  ADirection: TGradientDirection): BBool;
var
  StartRGB: array [0 .. 2] of Byte;
  RGBKoef: array [0 .. 2] of Double;
  Brush: HBRUSH;
  AreaWidth, AreaHeight, I: BInt32;
  ColorRect: TRect;
  RectOffset: Double;
begin
  RectOffset := 0;
  Result := False;
  if ColorCount < 1 then
    Exit;
  StartColor := ColorToRGB(StartColor);
  EndColor := ColorToRGB(EndColor);
  StartRGB[0] := GetRValue(StartColor);
  StartRGB[1] := GetGValue(StartColor);
  StartRGB[2] := GetBValue(StartColor);
  RGBKoef[0] := (GetRValue(EndColor) - StartRGB[0]) / ColorCount;
  RGBKoef[1] := (GetGValue(EndColor) - StartRGB[1]) / ColorCount;
  RGBKoef[2] := (GetBValue(EndColor) - StartRGB[2]) / ColorCount;
  AreaWidth := ARect.Right - ARect.Left;
  AreaHeight := ARect.Bottom - ARect.Top;
  case ADirection of
  gdHorizontal: RectOffset := AreaWidth / ColorCount;
  gdVertical: RectOffset := AreaHeight / ColorCount;
  end;
  for I := 0 to ColorCount - 1 do begin
    Brush := CreateSolidBrush(RGB(StartRGB[0] + Round((I + 1) * RGBKoef[0]), StartRGB[1] + Round((I + 1) * RGBKoef[1]),
      StartRGB[2] + Round((I + 1) * RGBKoef[2])));
    case ADirection of
    gdHorizontal: SetRect(ColorRect, Round(RectOffset * I), 0, Round(RectOffset * (I + 1)), AreaHeight);
    gdVertical: SetRect(ColorRect, 0, Round(RectOffset * I), AreaWidth, Round(RectOffset * (I + 1)));
    end;
    OffsetRect(ColorRect, ARect.Left, ARect.Top);
    FillRect(DC, ColorRect, Brush);
    DeleteObject(Brush);
  end;
  Result := True;
end;

procedure ListShuffle(List: TList);
var
  randomIndex: BInt32;
  cnt: BInt32;
begin
  Randomize;
  for cnt := 0 to -1 + List.Count do begin
    randomIndex := Random(-cnt + List.Count);
    List.Exchange(cnt, cnt + randomIndex);
  end;
end;

function ExecNewProcess(FileName: BStr): THandle;
var
  SUInfo: _STARTUPINFOA;
  ProcInfo: TProcessInformation;
  lCmd, lPath: BStr;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;
  SUInfo.wShowWindow := SW_SHOWNORMAL;
  lCmd := FileName;
  lPath := ExtractFilePath(lCmd);
  CreateProcessA(nil, @lCmd[1], nil, nil, False, CREATE_NEW_PROCESS_GROUP, nil, @lPath[1], SUInfo, ProcInfo);
  Result := ProcInfo.dwProcessId;
  Sleep(100);
end;

function HasFlag(Flags, Flag: BInt32): boolean;
begin
  Result := (Flags and Flag) = Flag;
end;

function DistanceBetween(const PFrom, PTo: BPos): BInt32;
begin
  Result := 99999;
  if PFrom.Z = PTo.Z then
    Result := NormalDistance(PFrom.X, PFrom.Y, PTo.X, PTo.Y);
end;

procedure ForceActiveWindow(hwnd: THandle);
var
  Tries: BInt32;
begin
  Tries := 0;
  while Tries < 10 do begin
    if ForceForegroundWindow(hwnd) then
      Break;
    Sleep(300);
    Inc(Tries);
  end;
  Sleep(1000); // Wait to Redraw
end;

procedure ConvertPtToScreen(var PT: TPoint);
begin
  PT.X := Round(PT.X * (65535 / Screen.Width));
  PT.Y := Round(PT.Y * (65535 / Screen.Height));
end;

function DirToStr(Dir: TTibiaDirection): BStr;
begin
  case Dir of
  tdNorth: Result := 'North';
  tdEast: Result := 'East';
  tdSouth: Result := 'South';
  tdWest: Result := 'West';
  tdNorthEast: Result := 'North-East';
  tdSouthEast: Result := 'South-East';
  tdSouthWest: Result := 'South-West';
  tdNorthWest: Result := 'North-West';
  tdCenter: Result := 'Center';
  end;
end;

function StrToDir(Str: BStr): TTibiaDirection;
begin
  if BStrEqual(Str, 'North') then
    Exit(tdNorth);
  if BStrEqual(Str, 'East') then
    Exit(tdEast);
  if BStrEqual(Str, 'South') then
    Exit(tdSouth);
  if BStrEqual(Str, 'West') then
    Exit(tdWest);
  if BStrEqual(Str, 'North-East') then
    Exit(tdNorthEast);
  if BStrEqual(Str, 'South-East') then
    Exit(tdSouthEast);
  if BStrEqual(Str, 'South-West') then
    Exit(tdSouthWest);
  if BStrEqual(Str, 'North-West') then
    Exit(tdNorthWest);
  Exit(tdCenter);
end;

procedure DoOpenURL(Url: BStr);
begin
  ShellExecuteA(0, 'open', BPChar(Url), nil, nil, SW_SHOWNORMAL);
end;

procedure OnLinkLabelEnter(Sender: TObject);
var
  F: TFont;
begin
  F := TLabel(Sender).Font;
  F.Color := clNavy;
  F.Style := [fsBold, fsUnderline];
end;

procedure OnLinkLabelLeave(Sender: TObject);
var
  F: TFont;
begin
  F := TLabel(Sender).Font;
  F.Color := clBlue;
  F.Style := [fsBold];
end;

function BStrsToStrArray(const BStrs: TStrings): BStrArray;
var
  I: BInt32;
begin
  SetLength(Result, 0);
  if BStrs.Count > 0 then begin
    SetLength(Result, BStrs.Count);
    for I := 0 to BStrs.Count - 1 do
      Result[I] := BStrs.Strings[I];
  end;
end;

function HexToInt(HexStr: BStr): Int64;
var
  RetVar: Int64;
  I: Byte;
begin
  HexStr := UpperCase(HexStr);
  if HexStr[length(HexStr)] = 'H' then
    Delete(HexStr, length(HexStr), 1);
  RetVar := 0;

  for I := 1 to length(HexStr) do begin
    RetVar := RetVar shl 4;
    if HexStr[I] in ['0' .. '9'] then
      RetVar := RetVar + (Byte(HexStr[I]) - 48)
    else if HexStr[I] in ['A' .. 'F'] then
      RetVar := RetVar + (Byte(HexStr[I]) - 55)
    else begin
      RetVar := 0;
      Break;
    end;
  end;

  Result := RetVar;
end;

function BinToHex(const Buffer: BPtr; const Size: BInt32): BStr;
const
  sHexChars: array [0 .. 15] of BChar = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D',
    'E', 'F');
var
  I: BInt32;
  C: BPInt8;
begin
  Result := '';
  C := BPInt8(Buffer);
  for I := 1 to Size do begin
    Result := Result + sHexChars[C^ div 16] + sHexChars[C^ mod 16] + ' ';
    Inc(C);
  end;
end;

function UrlEncode(const DecodedStr: BStr; Pluses: BBool): BStr;
var
  I: BInt32;
begin
  Result := '';
  if length(DecodedStr) > 0 then
    for I := 1 to length(DecodedStr) do begin
      if not(DecodedStr[I] in ['0' .. '9', 'a' .. 'z', 'A' .. 'Z', ' ']) then
        Result := Result + '%' + IntToHex(Ord(DecodedStr[I]), 2)
      else if not(DecodedStr[I] = ' ') then
        Result := Result + DecodedStr[I]
      else begin
        if not Pluses then
          Result := Result + '%20'
        else
          Result := Result + '+';
      end;
    end;
end;

function UrlDecode(const EncodedStr: BStr): BStr;
var
  I: BInt32;
begin
  Result := '';
  if length(EncodedStr) > 0 then begin
    I := 1;
    while I <= length(EncodedStr) do begin
      if EncodedStr[I] = '%' then begin
        Result := Result + Chr(HexToInt(EncodedStr[I + 1] + EncodedStr[I + 2]));
        I := Succ(Succ(I));
      end else if EncodedStr[I] = '+' then
        Result := Result + ' '
      else
        Result := Result + EncodedStr[I];

      I := Succ(I);
    end;
  end;
end;

function CRC32(s: BStr): BInt32; overload;
begin
  Result := CRC32(@s[1], length(s));
end;

function CRC32(p: pointer; ByteCount: DWORD): BInt32;
const
  CRC32Table: ARRAY [0 .. 255] OF DWORD = ($00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F, $E963A535,
    $9E6495A3, $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064,
    $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7, $136C9856, $646BA8C0, $FD62F97A,
    $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1,
    $4B04D447, $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF,
    $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E,
    $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106, $98D220BC,
    $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB,
    $086D3D2D, $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1,
    $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65, $4DB26158,
    $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846,
    $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525,
    $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B,
    $C0BA6CAD, $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615, $73DC1683, $E3630B12,
    $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1, $F00F9344, $8708A3D2, $1E01F268,
    $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F,
    $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD,
    $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C,
    $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28, $2BB45A92,
    $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D, $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9,
    $EB0E363F, $72076785, $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7,
    $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777, $88085AE6,
    $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354,
    $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53,
    $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729,
    $23D967BF, $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);
var
  I: DWORD;
  q: ^Byte;
  R: BUInt32;
begin
  Result := 0;
  R := 0;
  if ByteCount <= 0 then
    Exit;
  q := p;
  for I := 0 to ByteCount - 1 do begin
    R := (R shr 8) xor CRC32Table[q^ xor (R and $000000FF)];
    Inc(q)
  end;
  Result := BInt32(R);
end;

function IntIn(Value: BInt32; const Values: array of BInt32): boolean;
var
  I: BInt32;
begin
  Result := False;
  for I := Low(Values) to High(Values) do
    if Values[I] = Value then begin
      Result := True;
      Exit;
    end;
end;

function IntIn(Value: BUInt32; const Values: array of BUInt32): boolean;
var
  I: BUInt32;
begin
  Result := False;
  for I := Low(Values) to High(Values) do
    if Values[I] = Value then begin
      Result := True;
      Exit;
    end;
end;

function ForceForegroundWindow(hwnd: THandle): BBool;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then
    ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then
    Result := True
  else begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadProcessID(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end else begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

function ComboSelected(cmb: TComboBox): BStr;
begin
  Result := '';
  if cmb.ItemIndex <> -1 then
    Result := cmb.Items[cmb.ItemIndex];
end;

function ComboSelectedObj(cmb: TComboBox): TObject;
begin
  Result := nil;
  if cmb.ItemIndex <> -1 then
    Result := cmb.Items.Objects[cmb.ItemIndex];
end;

function DeleteSpaces(Str: BStr): BStr;
var
  I: BInt32;
begin
  Result := '';
  for I := 1 to length(Str) do
    if Str[I] <> ' ' then
      Result := Result + Str[I];
end;

function FileDialog(Title, Filter, SaveOrLoad: BStr; Owner: TComponent): BStr;
var
  openDialog: TOpenDialog;
  saveDialog: TSaveDialog;
begin
  Result := '';
  if AnsiSameText(SaveOrLoad, 'load') then begin
    openDialog := TOpenDialog.Create(Owner);
    openDialog.InitialDir := GetCurrentDir;
    openDialog.Options := [ofFileMustExist];
    openDialog.Filter := Filter;
    openDialog.FilterIndex := 0;
    openDialog.Title := Title;
    if openDialog.Execute then
      if FileExists(openDialog.FileName) then
        Result := openDialog.FileName;
    openDialog.Free;
  end else begin
    saveDialog := TSaveDialog.Create(Owner);
    saveDialog.InitialDir := GetCurrentDir;
    saveDialog.Options := [ofFileMustExist];
    saveDialog.DefaultExt := SaveOrLoad;
    saveDialog.Filter := Filter;
    saveDialog.FilterIndex := 0;
    saveDialog.Title := Title;
    if saveDialog.Execute then
      Result := saveDialog.FileName;
    saveDialog.Free;
  end;
end;

function UnixToDateTime(USec: Longint): TDateTime;
const
  UnixStartDate: TDateTime = 25569.0;
begin
  Result := (USec / 86400) + UnixStartDate;
end;

function GambitBox(Caption, Intro, Params: BStr; HaveReturn: boolean; var Values: BStrArray): boolean;
  function FastButtonCreate(Caption: BStr; X, Y, Width, Height: BInt32; Parent: TWinControl; Kind: TBitBtnKind)
    : TBitBtn;
  begin
    Result := TBitBtn.Create(nil);
    Result.Parent := Parent;
    Result.Top := Y;
    Result.Left := X;
    Result.Width := Width;
    Result.Height := Height;
    Result.Caption := Caption;
    Result.Kind := Kind;
  end;
  function FastLabelCreate(Caption: BStr; X, Y: BInt32; Parent: TWinControl): TLabel;
  begin
    Result := TLabel.Create(nil);
    Result.Parent := Parent;
    Result.Top := Y;
    Result.Left := X;
    Result.Caption := Caption;
    Result.AutoSize := True;
    Result.Visible := True;
  end;
  function FastMemoCreate(Name: BStr; Y: BInt32; Parent: TWinControl; Default: BStr = ''): TEdit;
  begin
    Result := TEdit.Create(nil);
    Result.Parent := Parent;
    Result.Top := Y;
    Result.Left := 100;
    Result.Width := 115;
    Result.Height := 21;
    Result.Text := Default;
    Result.Visible := True;
  end;

const
  DialogWidth = 250;
var
  F: TForm;
  Ret: BStrArray;
  Lst: array of TObject;
  Y: BInt32;
  I: BInt32;
begin
  F := TForm.Create(nil);

  SetLength(Lst, 1);
  Lst[0] := FastLabelCreate(WrapText(Intro, 46), 8, 5, F);
  Y := (Lst[0] as TLabel).Top + (Lst[0] as TLabel).Height + 8;

  if Params <> '' then begin
    BStrSplit(Ret, ', ', Params);
    SetLength(Lst, High(Lst) + 2);
    Lst[High(Lst)] := FastLabelCreate('Parameters', 8, Y, F);
    Inc(Y, 20);
    for I := 0 to High(Ret) do begin

      SetLength(Lst, High(Lst) + 3);
      Lst[High(Lst) - 1] := FastLabelCreate(Ret[I], 20, Y, F);
      Lst[High(Lst)] := FastMemoCreate('Value' + IntToStr(I), Y - 3, F);
      Inc(Y, 25);

    end;
  end;
  Inc(Y, 10);

  if not HaveReturn then
    Inc(Y, 2000);
  SetLength(Lst, High(Lst) + 5);
  Lst[High(Lst) - 2] := FastLabelCreate('Condition:', 8, Y, F);
  Inc(Y, 19);
  Lst[High(Lst) - 1] := FastLabelCreate('Result', 20, Y, F);
  Lst[High(Lst)] := FastMemoCreate('CondRet', Y - 3, F, IfThen(not HaveReturn, '', '=1'));
  Inc(Y, 25);
  Lst[High(Lst) - 3] := FastLabelCreate('E.g. =X >X >=X <X <=X <>X (1 is True, 0 is False)', 8, Y, F);
  Inc(Y, 25);
  if not HaveReturn then
    Dec(Y, 2000 + 19 + 25 + 25);

  SetLength(Lst, High(Lst) + 3);
  Lst[High(Lst) - 1] := FastButtonCreate('Ok', 20, Y, 100, 25, F, bkOk);
  Lst[High(Lst)] := FastButtonCreate('Cancel', 130, Y, 100, 25, F, bkCancel);
  Inc(Y, 32);

  F.Caption := Caption;
  F.Position := poMainFormCenter;
  F.BorderStyle := bsDialog;
  F.Width := DialogWidth;
  F.Height := Y + GetSystemMetrics(SM_CYCAPTION) + 5;
  Result := (F.ShowModal() = mrOk);

  for I := 0 to High(Lst) do begin
    if Lst[I] is TEdit then begin
      SetLength(Values, High(Values) + 2);
      Values[High(Values)] := (Lst[I] as TEdit).Text;
    end;
    Lst[I].Free;
  end;
  F.Free;
end;

function GetInventoryName(IID: BInt32): BStr;
begin
  Result := '?';
  case IID of
  1: Result := 'Helmet';
  2: Result := 'Amulet';
  3: Result := 'Backpack';
  4: Result := 'Armor';
  5: Result := 'Right Hand';
  6: Result := 'Left Hand';
  7: Result := 'Legs';
  8: Result := 'Boots';
  9: Result := 'Ring';
  10: Result := 'Ammunition';
  end;
end;

function GetUID: BInt32;
const
{$J+}
  vUID: BInt32 = 1;
{$J-}
begin
  if vUID = MaxInt then
    vUID := 1;
  Inc(vUID);
  Result := vUID;
end;

function HotkeyBox(var Hotkey: BStr): boolean;
  function FastButtonCreate(Caption: BStr; X, Y, Width, Height: BInt32; Parent: TWinControl; Kind: TBitBtnKind)
    : TBitBtn;
  begin
    Result := TBitBtn.Create(nil);
    Result.Parent := Parent;
    Result.Top := Y;
    Result.Left := X;
    Result.Width := Width;
    Result.Height := Height;
    Result.Caption := Caption;
    Result.Kind := Kind;
  end;
  function FastLabelCreate(Caption: BStr; X, Y: BInt32; Parent: TWinControl): TLabel;
  begin
    Result := TLabel.Create(nil);
    Result.Parent := Parent;
    Result.Top := Y;
    Result.Left := X;
    Result.Caption := Caption;
    Result.AutoSize := True;
    Result.Visible := True;
  end;

const
  DialogWidth = 170;
var
  F: TForm;
  Lst: array of TObject;
  HK: THotKey;
  Y: BInt32;
  I: BInt32;
begin
  F := TForm.Create(nil);
  SetLength(Lst, 1);
  Lst[0] := FastLabelCreate('Please insert the Hotkey', 25, 5, F);
  Y := (Lst[0] as TLabel).Top + (Lst[0] as TLabel).Height + 8;

  HK := THotKey.Create(nil);
  HK.Parent := F;
  HK.Height := 21;
  HK.Width := (Lst[0] as TLabel).Width;
  HK.Top := Y;
  HK.Left := 25;
  HK.InvalidKeys := [hcNone, hcAlt, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt];
  HK.Hotkey := TextToShortCut(Hotkey);
  SetLength(Lst, High(Lst) + 2);
  Lst[High(Lst)] := HK;
  Inc(Y, HK.Height + 5);

  SetLength(Lst, High(Lst) + 2);
  Lst[High(Lst) - 1] := FastButtonCreate('Ok', 10, Y, 70, 25, F, bkOk);
  SetLength(Lst, High(Lst) + 2);
  Lst[High(Lst)] := FastButtonCreate('Cancel', 86, Y, 70, 25, F, bkCancel);
  Inc(Y, 32);

  F.Caption := 'Hotkey';
  F.Position := poMainFormCenter;
  F.BorderStyle := bsDialog;
  F.Width := DialogWidth;
  F.Height := Y + GetSystemMetrics(SM_CYCAPTION) + 5;
  Result := (F.ShowModal() = mrOk);
  if Result and (HK.Hotkey <> 0) then
    Hotkey := ShortCutToText(HK.Hotkey);

  for I := 0 to High(Lst) do
    Lst[I].Free;
  F.Free;
end;

function HPColor(HP: BInt32): TColor;
begin
  if HP <= 3 then
    Result := RGB($60, 0, 0)
  else if HP <= 9 then
    Result := RGB($C0, 0, 0)
  else if HP <= 29 then
    Result := RGB($C0, 30, 30)
  else if HP <= 59 then
    Result := RGB($C0, $C0, 0)
  else if HP <= 94 then
    Result := RGB($60, $C0, $60)
  else
    Result := RGB(0, $C0, 0);

  {
    HPBar = Tibia.HPBar
    HP      R G B
    0-3     600000
    4-9      C00000
    10-29    C03030
    30-59    C0C000
    60-94    60C060
    95-100  00C000
  }

end;

function I2FS(N: BInt32): BStr;
begin
  Result := FormatFloat(',0', N);
end;

function NYByID(ID: BInt32): BPos;
begin
  case ID of
  0: begin
      Result.X := -1;
      Result.Y := -1;
    end;
  1: begin
      Result.X := 0;
      Result.Y := -1;
    end;
  2: begin
      Result.X := 1;
      Result.Y := -1;
    end;
  3: begin
      Result.X := 1;
      Result.Y := 0;
    end;
  4: begin
      Result.X := 0;
      Result.Y := 0;
    end;
  5: begin
      Result.X := -1;
      Result.Y := 0;
    end;
  6: begin
      Result.X := -1;
      Result.Y := 1;
    end;
  7: begin
      Result.X := 0;
      Result.Y := 1;
    end;
  8: begin
      Result.X := 1;
      Result.Y := 1;
    end;
  end;
end;

function SecToTime(Sec: BInt32): BStr;
var
  D, H, M, s: BStr;
  ZD, ZH, ZM, ZS: BInt32;
const
  SHour = 3600;
  SMaxHoras = 240;
  SDiaEmHoras = 24;
  SSecInMinInHour = 60;
begin
  if Sec > (SHour * SMaxHoras) then begin
    Result := '???';
    Exit;
  end;
  ZM := 0;
  ZH := 0;
  ZD := 0;
  if Sec >= SSecInMinInHour then begin
    ZS := Sec mod SSecInMinInHour;
    ZM := Sec div SSecInMinInHour;
    if ZM >= 60 then begin
      ZH := ZM div SSecInMinInHour;
      ZM := ZM mod SSecInMinInHour;
      if ZH > 23 then begin
        ZD := ZH div SDiaEmHoras;
        ZH := ZH mod SDiaEmHoras;
      end;
    end;
  end
  else
    ZS := Sec;
  H := IntToStr(ZH);
  M := IntToStr(ZM);
  s := IntToStr(ZS);
  D := IntToStr(ZD);
  if length(H) = 1 then
    H := '0' + H;
  if length(M) = 1 then
    M := '0' + M;
  if length(s) = 1 then
    s := '0' + s;
  Result := IfThen((ZD > 0), D + 'd', '') + IfThen((ZH > 0), H + 'h', '') + IfThen((ZM > 0), M + 'm', '') + s + 's';
end;

{$IFNDEF Release}

procedure setThisThreadName(const Name: BStr);
type
  TInfo = record
    RecType: LongWord;
    Name: BPChar;
    ThreadID: LongWord;
    Flags: LongWord;
  end;
var
  Info: TInfo;
begin
  Info.RecType := $1000;
  Info.Name := BPChar(Name);
  Info.ThreadID := $FFFFFFFF;
  Info.Flags := 0;
  try RaiseException($406D1388, 0, SizeOf(Info) div SizeOf(LongWord), PUINT_PTR(@Info));
  except
  end;
end;
{$ENDIF}

procedure ShortCutToHotKey(Hotkey: TShortCut; var Key: Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(Hotkey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
    Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
    Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
    Modifiers := Modifiers or MOD_CONTROL;
end;

procedure ShutdownPC;
begin
  ShellExecuteA(0, 'Open', BPChar('shutdown.exe'), BPChar('-s'), nil, SW_SHOW);
end;

procedure PlayWav(const FileName: BStr; const ALoop: BBool);
begin
  if not sndPlaySoundA(BPChar(FileName), BIf(ALoop, SND_ASYNC or SND_LOOP, SND_ASYNC)) then
    SysUtils.Beep;
end;

procedure StopWav;
begin
  sndPlaySound(nil, 0);
end;

function KeyCodeToName(const AKeyCode: BInt16): BStr;
begin
  case AKeyCode of
  $01: Result := 'Left mouse button';
  $02: Result := 'Right mouse button';
  $03: Result := 'Cancel';
  $04: Result := 'Middle mouse button';
  $05: Result := 'X1 mouse button';
  $06: Result := 'X2 mouse button';
  $08: Result := 'BACKSPACE';
  $09: Result := 'TAB';
  $0C: Result := 'CLEAR';
  $0D: Result := 'ENTER';
  $10: Result := 'SHIFT';
  $11: Result := 'CTRL';
  $12: Result := 'ALT';
  $13: Result := 'PAUSE';
  $14: Result := 'CAPS LOCK';
  $1B: Result := 'ESC';
  $20: Result := 'SPACEBAR';
  $21: Result := 'PAGE UP';
  $22: Result := 'PAGE DOWN';
  $23: Result := 'END';
  $24: Result := 'HOME';
  $25: Result := 'LEFT ARROW';
  $26: Result := 'UP ARROW';
  $27: Result := 'RIGHT ARROW';
  $28: Result := 'DOWN ARROW';
  $29: Result := 'SELECT';
  $2A: Result := 'PRINT';
  $2B: Result := 'EXECUTE';
  $2C: Result := 'PRINT SCREEN';
  $2D: Result := 'INS';
  $2E: Result := 'DEL';
  $2F: Result := 'HELP';
  $30: Result := '0';
  $31: Result := '1';
  $32: Result := '2';
  $33: Result := '3';
  $34: Result := '4';
  $35: Result := '5';
  $36: Result := '6';
  $37: Result := '7';
  $38: Result := '8';
  $39: Result := '9';
  $41: Result := 'A';
  $42: Result := 'B';
  $43: Result := 'C';
  $44: Result := 'D';
  $45: Result := 'E';
  $46: Result := 'F';
  $47: Result := 'G';
  $48: Result := 'H';
  $49: Result := 'I';
  $4A: Result := 'J';
  $4B: Result := 'K';
  $4C: Result := 'L';
  $4D: Result := 'M';
  $4E: Result := 'N';
  $4F: Result := 'O';
  $50: Result := 'P';
  $51: Result := 'Q';
  $52: Result := 'R';
  $53: Result := 'S';
  $54: Result := 'T';
  $55: Result := 'U';
  $56: Result := 'V';
  $57: Result := 'W';
  $58: Result := 'X';
  $59: Result := 'Y';
  $5A: Result := 'Z';
  $5B: Result := 'Left Windows';
  $5C: Result := 'Right Windows';
  $5D: Result := 'Applications';
  $5F: Result := 'Computer Sleep';
  $60: Result := 'Numeric 0';
  $61: Result := 'Numeric 1';
  $62: Result := 'Numeric 2';
  $63: Result := 'Numeric 3';
  $64: Result := 'Numeric 4';
  $65: Result := 'Numeric 5';
  $66: Result := 'Numeric 6';
  $67: Result := 'Numeric 7';
  $68: Result := 'Numeric 8';
  $69: Result := 'Numeric 9';
  $6A: Result := 'Multiply';
  $6B: Result := 'Add';
  $6C: Result := 'Separator';
  $6D: Result := 'Subtract';
  $6E: Result := 'Decimal';
  $6F: Result := 'Divide';
  $70: Result := 'F1';
  $71: Result := 'F2';
  $72: Result := 'F3';
  $73: Result := 'F4';
  $74: Result := 'F5';
  $75: Result := 'F6';
  $76: Result := 'F7';
  $77: Result := 'F8';
  $78: Result := 'F9';
  $79: Result := 'F10';
  $7A: Result := 'F11';
  $7B: Result := 'F12';
  $7C: Result := 'F13';
  $7D: Result := 'F14';
  $7E: Result := 'F15';
  $7F: Result := 'F16';
  $80: Result := 'F17';
  $81: Result := 'F18';
  $82: Result := 'F19';
  $83: Result := 'F20';
  $84: Result := 'F21';
  $85: Result := 'F22';
  $86: Result := 'F23';
  $87: Result := 'F24';
  $90: Result := 'NUM LOCK';
  $91: Result := 'SCROLL LOCK';
  $A0: Result := 'Left SHIFT';
  $A1: Result := 'Right SHIFT';
  $A2: Result := 'Left CONTROL';
  $A3: Result := 'Right CONTROL';
  $A4: Result := 'Left MENU';
  $A5: Result := 'Right MENU';
  $A6: Result := 'Browser Back';
  $A7: Result := 'Browser Forward';
  $A8: Result := 'Browser Refresh';
  $A9: Result := 'Browser Stop';
  $AA: Result := 'Browser Search';
  $AB: Result := 'Browser Favorites';
  $AC: Result := 'Browser Start and Home';
  $AD: Result := 'Volume Mute';
  $AE: Result := 'Volume Down';
  $AF: Result := 'Volume Up';
  $B0: Result := 'Next Track';
  $B1: Result := 'Previous Track';
  $B2: Result := 'Stop Media';
  $B3: Result := 'Play/Pause Media';
  $B4: Result := 'Start Mail';
  $B5: Result := 'Select Media';
  $B6: Result := 'Start Application 1';
  $B7: Result := 'Start Application 2';
  $F6: Result := 'Attn';
  $F7: Result := 'CrSel';
  $F8: Result := 'ExSel';
  $F9: Result := 'Erase EOF';
  $FA: Result := 'Play';
  $FB: Result := 'Zoom';
  $FD: Result := 'PA1';
  $FE: Result := 'Clear';
else Result := '';
  end;
end;

function KeyToStr(const AShiftState: TShiftState; const AKeyCode: BInt16): BStr;
begin
  if (AKeyCode <> VK_CONTROL) and (ssCtrl in AShiftState) then
    Result := KeyCodeToName(VK_CONTROL) + ' + ';
  if (AKeyCode <> VK_SHIFT) and (ssShift in AShiftState) then
    Result := Result + KeyCodeToName(VK_SHIFT) + ' + ';
  if (AKeyCode <> VK_MENU) and (ssAlt in AShiftState) then
    Result := Result + KeyCodeToName(VK_MENU) + ' + ';
  Result := Result + KeyCodeToName(AKeyCode);
end;

function StrToKey(const AKeyName: BStr): BPair<BInt16, TShiftState>;
var
  I: BInt32;
  R: BStrArray;
  KeyName: BStr;
  Res: BPair<BInt16, TShiftState>;
begin
  Res.First := 0;
  Res.Second := [];
  if BStrSplit(R, ' + ', AKeyName) > 1 then begin
    KeyName := R[High(R)];
    for I := 0 to High(R) - 1 do
      if R[I] = KeyCodeToName(VK_CONTROL) then
        Include(Res.Second, ssCtrl)
      else if R[I] = KeyCodeToName(VK_SHIFT) then
        Include(Res.Second, ssShift)
      else if R[I] = KeyCodeToName(VK_MENU) then
        Include(Res.Second, ssAlt);
  end
  else
    KeyName := AKeyName;
  for I := 0 to $FF do
    if BStrEqual(KeyName, KeyCodeToName(I)) then begin
      Res.First := I;
      Exit(Res);
    end;
  Result := Res;
end;

procedure TestKeyTool(const AName: BStr; const AKey: BInt16; const AShift: TShiftState);
var
  K: BPair<BInt16, TShiftState>;
  s: BStr;
begin
  K.First := AKey;
  K.Second := AShift;
  s := KeyToStr(K.Second, K.First);
  Write(AName, ': ', s);
  K := StrToKey(s);
  if (K.First = AKey) and (K.Second = AShift) then
    WriteLn(' [Ok]')
  else
    WriteLn(' [Failed]');
end;

procedure TestKeyTools;
var
  C: Char;
begin
  AllocConsole;
  TestKeyTool('Ctrl', VK_CONTROL, []);
  TestKeyTool('Shift', VK_SHIFT, []);
  TestKeyTool('Alt', VK_MENU, []);
  TestKeyTool('Ctrl + Alt', VK_MENU, [ssCtrl]);
  TestKeyTool('Shift + Alt', VK_MENU, [ssShift]);
  TestKeyTool('A', Ord('A'), []);
  TestKeyTool('Ctrl + B', Ord('B'), [ssCtrl]);
  TestKeyTool('Ctrl + Shift + C', Ord('C'), [ssCtrl, ssShift]);
  TestKeyTool('Ctrl + Shift + Alt + Numpad 1', VK_NUMPAD1, [ssCtrl, ssShift, ssAlt]);
  C := #0;
  while C <> 'q' do
    Read(C);
  FreeConsole;
  Halt;
end;

function InsertFrame(const AParent: TPanel; const AFrameClass: TFrameClass): TFrame;
var
  Frame: TFrame;
begin
  AParent.Caption := '';
  Frame := AFrameClass.Create(AParent);
  Frame.SetParentComponent(AParent);
  AParent.Width := Frame.Width;
  AParent.Height := Frame.Height;
  Exit(Frame);
end;

procedure IterateComponentControls(const AComponent: TComponent; const AProc: BUnaryProc<TComponent>);
var
  I: BInt32;
begin
  AProc(AComponent);
  for I := 0 to AComponent.ComponentCount - 1 do begin
    IterateComponentControls(AComponent.Components[I], AProc);
  end;
end;

procedure BExecuteInSafeScope(const AName: BStr; const AMethod: BProc);
begin
  try AMethod();
  except
    on E: Exception do
      raise BException.Create(AName + BStrLine + E.Message)
    else
      raise;
  end;
end;

function BPosComparator: IEqualityComparer<BPos>;
begin
  Exit(TEqualityComparer<BPos>.Construct(
    function(const ALeft, ARight: BPos): boolean
    begin
      Exit(ALeft = ARight);
    end,
    function(const AValue: BPos): Integer
    begin
      Exit(CRC32(@AValue, SizeOf(BPos)));
    end));
end;

end.

