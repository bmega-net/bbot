unit uDllHookInput;

interface

procedure InitInputHook;

implementation

uses Windows, Messages, uDLL, uDllHUD, Math,
  uDllTibiaState, uDllDash;

const
  WM_KEYDOWN_FIRST = 1 shl 30;

var
  WNDProcOrig: pointer;
  MousePosX: Integer;
  MousePosY: Integer;
  HUDClicked: Boolean;
  HotkeyPressed: Cardinal;

function MyMsgLoop(hWnd: hWnd; Msg: UINT; wParam: wParam; lParam: lParam)
  : LRESULT; stdcall;
begin
  Result := 0;
  case Msg of
    WM_MOUSEMOVE:
      begin
        MousePosX := LoWord(lParam);
        MousePosY := HiWord(lParam);
      end;
    WM_LBUTTONDOWN:
      begin
        HUDClicked := HUDManager.OnMouseClick(MousePosX, MousePosY);
        if HUDClicked then
          Exit;
      end;
    WM_LBUTTONUP:
      begin
        if HUDClicked then
        begin
          HUDClicked := False;
          Exit;
        end;
      end;
    WM_KEYDOWN:
      begin
        if InRange(wParam, 0, 255) then
        begin
          if not(bksPressed in TibiaState^.Keys[wParam]) then
            TibiaState^.Keys[wParam] := TibiaState^.Keys[wParam] +
              [bksDown, bksPressed];

          if (bksCallOff in TibiaState^.Keys[wParam]) or
            ((bksCallOffShift in TibiaState^.Keys[wParam]) and
            (bksPressed in TibiaState^.Keys[VK_SHIFT])) or
            ((bksCallOffCtrl in TibiaState^.Keys[wParam]) and
            (bksPressed in TibiaState^.Keys[VK_CONTROL])) then
          begin
            HotkeyPressed := GetTickCount + 3000;
            Exit;
          end;
        end;
      end;
    WM_KEYUP:
      begin
        if InRange(wParam, 0, 255) then
        begin
          if (bksPressed in TibiaState^.Keys[wParam]) then
            TibiaState^.Keys[wParam] := TibiaState^.Keys[wParam] - [bksPressed];
          if (bksDown in TibiaState^.Keys[wParam]) then
            TibiaState^.Keys[wParam] := TibiaState^.Keys[wParam] - [bksDown];

          if (bksCallOff in TibiaState^.Keys[wParam]) or
            ((bksCallOffShift in TibiaState^.Keys[wParam]) and
            (bksPressed in TibiaState^.Keys[VK_SHIFT])) or
            ((bksCallOffCtrl in TibiaState^.Keys[wParam]) and
            (bksPressed in TibiaState^.Keys[VK_CONTROL])) then
          begin
            HotkeyPressed := 0;
            Exit;
          end;
        end;
      end;
    WM_CHAR:
      begin
        if HotkeyPressed > GetTickCount then
          Exit;
      end;
  end;
  if TibiaState^.Dash then
  begin
    case Msg of
      WM_KEYDOWN:
        begin
          if Dash_KeyDown(wParam) then
            Exit;
        end;
      WM_KEYUP:
        begin
          if Dash_KeyUp(wParam) then
            Exit;
        end;
      WM_CHAR:
        begin
          if Dash_KeyDown(wParam) then
            Exit;
        end
    else
      ;
    end;
    Dash_Run;
  end;
  Result := CallWindowProc(WNDProcOrig, hWnd, Msg, wParam, lParam);
end;

function InitBBotMsgLoop(hWnd: hWnd; Msg: UINT; wParam: wParam; lParam: lParam)
  : LRESULT; stdcall;
begin
  InitThreadHook;
  SetWindowLong(TibiaState^.hWnd, GWL_WNDPROC, Integer(@MyMsgLoop));
  Result := CallWindowProc(WNDProcOrig, hWnd, Msg, wParam, lParam);
end;

procedure InitInputHook;
begin
  HUDClicked := False;
  HotkeyPressed := 0;
  WNDProcOrig := Ptr(SetWindowLong(TibiaState^.hWnd, GWL_WNDPROC,
    Integer(@InitBBotMsgLoop)));
end;

end.
