unit uMacroCore;

interface

uses
  uBTypes,
  uBVector,

  uMacroVariable,
  uMacroRegistry,
  uIMacro,
  uMacroEngine;

type
  BMacroOperationKind = (bmoFunc, bmoText, bmoNumber, bmoEqual, bmoNotEqual, bmoBigger, bmoBiggerEqual, bmoSmaller,
    bmoSmallerEqual, bmoVar, bmoLabel, bmoFalseLabel);

  BMacroOperation = record
    Kind: BMacroOperationKind;
    Func: BMacroFunc;
    FuncIdx: BInt32;
    FuncParams: BStrArray;
    Datas: BStr;
    Datan: BInt32;
    Res: BInt32;
  end;

  BMacroCore = class(BMacro)
  private type
    _DebugData = record
      Enabled: BBool;
      Info: BStr;
      LastLN: BBool;
    end;
  private
    _Debug: _DebugData;
    _Macro: array of BMacroOperation;
    _ExecIndex: BInt32;
    _CallingIdx: BInt32;
    FName: BStr;
    FDelay: BInt32;
    FCode: BStr;
  protected
    _Engine: BMacroEngine;
    procedure Parse(ACode: BStr);
    procedure DoParse(ACode: BStr);
    procedure AddMacroOperation(S: BStr);
    procedure DoExecute(const AInitialIndex: BInt32);
    function GetDebugging: BBool; override;
    function GetName: BStr; override;
  public
    constructor Create(AEngine: BMacroEngine; ADebug: BBool; ACode: BStr);
    destructor Destroy; override;

    // BMacro Parameters
    function ParamCount: BInt32; override;
    function ParamStr(const AIndex: BInt32): BStr; override;
    function ParamInt(const AIndex: BInt32): BInt32; override;

    // BMacro Variables
    procedure SetVariable(const AName: BStr; const AValue: BInt32); overload; override;
    procedure SetVariable(const AName: BStr; const AValue: BStr); overload; override;
    function HasVariable(const AName: BStr): BBool; override;
    function Variable(const AName: BStr): BInt32; override;
    function VariableStr(const AName: BStr): BStr; override;

    // BMacro Constants
    function Constant(const AName: BStr): BInt32; override;

    // BMacro Whens
    procedure WatchWhen(const AEvent, AHandlerLabel: BStr; const ACond: BFunc<BBool>); override;
    procedure UnwatchWhen(); override;
    procedure CastWhen(const AEvent: BStr); override;

    // BMacro Execution Control
    procedure Execute; overload; override;
    procedure Execute(const AGoLabel: BStr); overload; override;
    procedure GoLabel(const AName: BStr); override;
    procedure GoExit(); override;

    procedure AddDebug(const AMessage: BStr); override;
    procedure AddDebugFmt(const AMessageFmt: BStr; const AArgs: array of const); override;
    property Debugging: BBool read GetDebugging;

    // BMacro Internal
    function CurrentOp: BStr;
    procedure AddDebugSpacer;
    property Debug: BStr read _Debug.Info;

    function FormatMacroCode: BStr;
    property Name: BStr read FName;
    property Delay: BInt32 read FDelay;
    property Code: BStr read FCode;
  end;

implementation

uses
  Forms,
  StdCtrls,
  SysUtils,
  Windows,
  StrUtils,

  Declaracoes,
  Generics.Collections,
  Generics.Defaults;

const
  cOperators = ['=', '>', '<', ':'];
  ckOperators = [bmoEqual, bmoNotEqual, bmoBigger, bmoBiggerEqual, bmoSmaller, bmoSmallerEqual, bmoVar];

  { BMacroCore }

procedure GetDText(var B: BStr; var C: BPChar; EOC: BPChar; DemStart, DemEnd: BChar);
var
  PDeph: BInt32;
begin
  PDeph := 0;
  while C <= EOC do begin
    B := B + C^;
    if C^ = DemStart then
      Inc(PDeph);
    if C^ = DemEnd then begin
      Dec(PDeph);
      if PDeph = 0 then
        Break
    end;
    Inc(C);
  end;
end;

procedure GetPText(var R: BStrArray; S: BStr);
var
  C, EOP: BPChar;
  B: BStr;
  procedure AddP;
  begin
    B := Trim(B);
    if B <> '' then begin
      SetLength(R, Length(R) + 1);
      R[High(R)] := B;
      B := '';
      Inc(C);
    end;
  end;
  procedure AddS;
  begin
    Inc(C);
    if C <= EOP then
      B := B + C^;
  end;

begin
  if Length(S) > 0 then begin
    C := @S[1];
    EOP := @S[Length(S)];
    B := '';
    while C <= EOP do begin
      if C^ = '(' then
        GetDText(B, C, EOP, '(', ')')
      else if C^ = ',' then
        AddP
      else if C^ = '\' then
        AddS
      else
        B := B + C^;
      Inc(C);
    end;
    AddP;
  end;
end;

procedure BMacroCore.AddDebug(const AMessage: BStr);
begin
  _Debug.Info := _Debug.Info + AMessage + #13#10;
  _Debug.LastLN := False;
end;

procedure BMacroCore.CastWhen(const AEvent: BStr);
begin
  _Engine.Registry.CastWhen(AEvent);
end;

function BMacroCore.Constant(const AName: BStr): BInt32;
begin
  Result := _Engine.Registry.Constants[AName];
end;

constructor BMacroCore.Create(AEngine: BMacroEngine; ADebug: BBool; ACode: BStr);
begin
  FCode := ACode;
  _Engine := AEngine;
  _Debug.Enabled := ADebug;
  _Debug.Info := '';
  _Debug.LastLN := True;
  DoParse(ACode);
end;

function BMacroCore.CurrentOp: BStr;
begin
  Result := _Macro[_CallingIdx].Datas;
end;

destructor BMacroCore.Destroy;
begin
  UnwatchWhen;
end;

procedure BMacroCore.DoParse(ACode: BStr);
begin
  BExecuteInSafeScope('Macro:Parse:' + ACode,
    procedure
    begin
      Parse(ACode);
    end);
end;

procedure BMacroCore.Execute;
begin
  DoExecute(1); // From first step/index
end;

procedure BMacroCore.Execute(const AGoLabel: BStr);
begin
  GoLabel(AGoLabel);
  DoExecute(_ExecIndex); // From Label
end;

procedure BMacroCore.DoExecute(const AInitialIndex: BInt32);
var
  H: BInt32;
  LeftSideVal, RightSideVal: BInt32;
  O: ^BMacroOperation;
  procedure _Compare(LeftVal, RightVal: BInt32; B: BBool);
  var
    CompStrExpr, CompStrEval, CompStatus: BStr;
  begin
    if Debugging then begin
      AddDebugSpacer;
      CompStatus := BIf(B, 'True', 'False');

      CompStrExpr := BFormat('%s %s %s', [_Macro[_ExecIndex - 1].Datas, _Macro[_ExecIndex].Datas,
        _Macro[_ExecIndex + 1].Datas]);
      AddDebugFmt('[%s] %s', [CompStatus, CompStrExpr]);

      CompStrEval := BFormat('%d %s %d', [LeftVal, _Macro[_ExecIndex].Datas, RightVal]);
      AddDebugFmt('[%s] => %s', [CompStatus, CompStrEval]);
      AddDebugSpacer;
    end;
    if B then begin
      Inc(_ExecIndex, 2);
    end else begin
      Inc(_ExecIndex, 2);
      if _ExecIndex < H then
        if _Macro[_ExecIndex].Kind = bmoFalseLabel then
          GoLabel(_Macro[_ExecIndex].Datas)
        else
          GoExit;
    end;
  end;
  function _Res(Idx: BInt32): BInt32;
  begin
    Result := -1;
    if (Idx > 0) and (Idx < H) then
      Result := _Macro[Idx].Res
    else if Debugging then
      AddDebug('[Critical] executing result out of range [' + IntToStr(Idx) + ']');
  end;
  procedure _CallF(Idx: BInt32);
  var
    F: ^BMacroOperation;
    Consts: BStr;
  begin
    if (Idx > 0) and (Idx < H) then begin
      F := @_Macro[Idx];
      if F^.Kind = bmoFunc then begin
        _CallingIdx := Idx;
        if Debugging then
          AddDebugSpacer;
        F^.Res := F^.Func.FuncAsInt(Self);
        if Debugging then begin
          AddDebug('[Function] ' + F^.Datas);
          Consts := BStrJoin(_Engine.Registry.ConstantsForValue(F^.Res), ' | ');
          AddDebug('[Function] -> ' + IntToStr(F^.Res) + '  ' + Consts);
          AddDebugSpacer;
        end;
      end else if F^.Kind = bmoText then
        F^.Res := StrToIntDef(_Engine.VarsText(F^.Datas), 0)
      else if F^.Kind = bmoNumber then
        F^.Res := F^.Datan
      else if Debugging then
        AddDebug('[Critical] invalid operation [' + IntToStr(Idx) + ']');
    end else if Debugging then
      AddDebug('[Critical] executing func out of range [' + IntToStr(Idx) + ']');
  end;
  function _LRes: BInt32;
  begin
    Result := _Res(_ExecIndex - 1);
  end;
  function _RRes: BInt32;
  begin
    _CallF(_ExecIndex + 1);
    Result := _Res(_ExecIndex + 1);
  end;
  procedure _CallC;
  begin
    _CallF(_ExecIndex);
    Inc(_ExecIndex);
  end;
  procedure _Skip;
  begin
    Inc(_ExecIndex);
  end;
  procedure _SetVar;
  begin
    SetVariable(_Macro[_ExecIndex - 1].Datas, _RRes);
    Inc(_ExecIndex, 2);
  end;

begin
  _ExecIndex := AInitialIndex;
  H := High(_Macro);
  if Debugging then begin
    AddDebug('Start-Of-Macro');
    AddDebugSpacer;
  end;
  while (_ExecIndex > 0) and (_ExecIndex < H) do
    try
      O := @_Macro[_ExecIndex];
      case O^.Kind of
      bmoFunc: _CallC;
      bmoText: _CallC;
      bmoNumber: _CallC;
      bmoEqual: begin
          LeftSideVal := _LRes;
          RightSideVal := _RRes;
          _Compare(LeftSideVal, RightSideVal, LeftSideVal = RightSideVal);
        end;
      bmoNotEqual: begin
          LeftSideVal := _LRes;
          RightSideVal := _RRes;
          _Compare(LeftSideVal, RightSideVal, LeftSideVal <> RightSideVal);
        end;
      bmoBigger: begin
          LeftSideVal := _LRes;
          RightSideVal := _RRes;
          _Compare(LeftSideVal, RightSideVal, LeftSideVal > RightSideVal);
        end;
      bmoBiggerEqual: begin
          LeftSideVal := _LRes;
          RightSideVal := _RRes;
          _Compare(LeftSideVal, RightSideVal, LeftSideVal >= RightSideVal);
        end;
      bmoSmaller: begin
          LeftSideVal := _LRes;
          RightSideVal := _RRes;
          _Compare(LeftSideVal, RightSideVal, LeftSideVal < RightSideVal);
        end;
      bmoSmallerEqual: begin
          LeftSideVal := _LRes;
          RightSideVal := _RRes;
          _Compare(LeftSideVal, RightSideVal, LeftSideVal <= RightSideVal);
        end;
      bmoVar: _SetVar;
      bmoLabel: _Skip;
      bmoFalseLabel: _Skip;
      end;
    except
      on e: Exception do begin
        if Debugging then
          AddDebug('[Critical] Crashed executing ' + _Macro[_ExecIndex].Datas + ': ' + e.Message);
        Exit;
      end;
      else
      begin
        if Debugging then
          AddDebug('[Critical] Crashed executing ' + _Macro[_ExecIndex].Datas + ' unknown exception');
        Exit;
      end;
    end;
  if Debugging then begin
    AddDebugSpacer;
    AddDebug('End-Of-Macro');
  end;
end;

function BMacroCore.GetDebugging: BBool;
begin
  Exit(_Debug.Enabled);
end;

function BMacroCore.GetName: BStr;
begin
  Exit(FName);
end;

procedure BMacroCore.GoExit;
begin
  if Debugging then
    AddDebug('[Exit] Go to exit');
  _ExecIndex := High(_Macro) + 1;
end;

procedure BMacroCore.GoLabel(const AName: BStr);
var
  I: BInt32;
begin
  for I := 0 to High(_Macro) do
    if _Macro[I].Kind = bmoLabel then
      if AnsiSameText(_Macro[I].Datas, AName) then begin
        if Debugging then
          AddDebug('[GoLabel] ' + AName);
        _ExecIndex := I;
        Exit;
      end;
  if Debugging then
    AddDebug('[Critical] Label(' + AName + ') not found');
  GoExit;
end;

function BMacroCore.HasVariable(const AName: BStr): BBool;
var
  V: BMacroVariable;
begin
  Exit(_Engine.Registry.VariablesTryGet(AName, v));
end;

function BMacroCore.ParamStr(const AIndex: BInt32): BStr;
begin
  if High(_Macro[_CallingIdx].FuncParams) >= AIndex then
    Result := _Engine.VarsText(_Macro[_CallingIdx].FuncParams[AIndex])
  else begin
    Result := '';
    if Debugging then
      AddDebug('[Critical] Param[' + IntToStr(AIndex) + '] out of range');
  end;
end;

function BMacroCore.ParamInt(const AIndex: BInt32): BInt32;
begin
  try Result := StrToInt(ParamStr(AIndex));
  except
    Result := MaxInt;
    if Debugging then
      AddDebug('[Critical] Param[' + IntToStr(AIndex) + ']{' + ParamStr(AIndex) + '} is not a number');
  end;
end;

procedure BMacroCore.Parse(ACode: BStr);
var
  I, P1, P2: BInt32;
  C, EOC: BPChar;
  B: BStr;
  T: array of BStr;
  procedure AddT;
  begin
    B := Trim(B);
    if B <> '' then begin
      SetLength(T, Length(T) + 1);
      T[High(T)] := B;
      B := '';
    end;
  end;

begin
  if ACode = '' then
    Exit;
  P1 := AnsiPos(' ', ACode);
  FDelay := -1;
  FName := '';
  if P1 > 0 then
    FDelay := StrToIntDef(Copy(ACode, 1, P1 - 1), -1);
  if FDelay = -1 then
    Exit;
  P1 := AnsiPos('{', ACode);
  P2 := AnsiPos('}', ACode);
  if (P1 > 0) and (P2 > 0) then
    FName := Copy(ACode, P1 + 1, P2 - P1 - 1);
  if FName = '' then
    Exit;
  if Length(ACode) = P2 then
    Exit;
  C := @ACode[P2 + 1];
  EOC := @ACode[Length(ACode)];
  while C <= EOC do begin
    if (C^ = ' ') then
      AddT
    else if C^ = '{' then begin
      GetDText(B, C, EOC, '{', '}');
      AddT;
    end else if C^ = '[' then begin
      GetDText(B, C, EOC, '[', ']');
      AddT;
    end else if C^ = '(' then begin
      GetDText(B, C, EOC, '(', ')');
      AddT;
    end
    else
      B := B + C^;
    Inc(C);
  end;
  AddT;
  AddMacroOperation('{' + Name + '-Start}');
  for I := 0 to High(T) do
    AddMacroOperation(T[I]);
  AddMacroOperation('{' + Name + '-End}');
end;

procedure BMacroCore.SetVariable(const AName: BStr; const AValue: BStr);
var
  Variable: BMacroVariable;
begin
  Variable := _Engine.Registry.Variables[AName];
  if Debugging then
    AddDebug(BFormat('[Variable] !%s! has been set to <<%s>> (old value <<%s>>)',
      [AName, AValue, Variable.ValueAsString]));
  Variable.ValueStr := AValue;
end;

procedure BMacroCore.UnwatchWhen;
begin
  _Engine.Registry.UnwatchWhen(Self);
end;

procedure BMacroCore.SetVariable(const AName: BStr; const AValue: BInt32);
var
  Variable: BMacroVariable;
begin
  Variable := _Engine.Registry.Variables[AName];
  if Debugging then
    AddDebug(BFormat('[Variable] !%s! has been set to <<%d>> (old value <<%s>>)',
      [AName, AValue, Variable.ValueAsString]));
  Variable.Value := AValue;
end;

function BMacroCore.Variable(const AName: BStr): BInt32;
begin
  if not _Engine.Registry.VariablesTry(AName, Result) then begin
    if Debugging then
      AddDebug('[Warning] unable to get variable value ' + AName);
    Result := 0;
  end;
end;

function BMacroCore.VariableStr(const AName: BStr): BStr;
begin
  if not _Engine.Registry.VariablesTry(AName, Result) then begin
    if Debugging then
      AddDebug('[Warning] unable to get variable value ' + AName);
    Result := '';
  end;
end;

procedure BMacroCore.WatchWhen(const AEvent, AHandlerLabel: BStr; const ACond: BFunc<BBool>);
begin
  _Engine.Registry.WatchWhen(AEvent, AHandlerLabel, ACond, Self);
end;

procedure BMacroCore.AddMacroOperation(S: BStr);
var
  AFunc: BMacroFunc;
  B: BStr;
  C, EOP: BPChar;
  P1, P2: BInt32;
  O: ^BMacroOperation;
  procedure AddOperation;
  begin
    SetLength(_Macro, Length(_Macro) + 1);
    O := @_Macro[High(_Macro)];
  end;
  procedure CreateFO;
  var
    Fn: BStr;
    Fi: BInt32;
  begin
    B := Trim(B);
    if B = '' then
      Exit;
    AddOperation;
    O^.Datas := B;
    Fn := B;
    P1 := AnsiPos('(', Fn);
    if P1 > 0 then
      Fn := Copy(Fn, 1, P1 - 1);
    if _Engine.Registry.FuncByName(Fn, AFunc) then begin
      O^.Kind := bmoFunc;
      O^.Func := AFunc;
      SetLength(O^.FuncParams, 0);
      if P1 > 0 then begin
        B := Copy(B, P1 + 1, Length(B) - P1 - 1);
        GetPText(O^.FuncParams, B);
      end;
    end else begin
      Fi := StrToIntDef(B, -MaxInt);
      if Fi <> -MaxInt then begin
        O^.Kind := bmoNumber;
        O^.Datan := Fi;
      end else begin
        O^.Kind := bmoText;
        if (P1 > 0) and (BStrPos(Fn, '!') = 0) and (BStrPos(Fn, ':') = 0) then
          if Debugging then
            AddDebug('[Parsing] Possible wrong function call: ' + B);
      end;
    end;
    B := '';
  end;
  function TryAddOperator(const AOperator: BStr; AKind: BMacroOperationKind): BBool;
  begin
    if Trim(B) = AOperator then begin
      AddOperation;
      O^.Datas := B;
      O^.Kind := AKind;
      B := '';
      Exit(True);
    end else begin
      Exit(False);
    end;
  end;
  function TryAddOperators: BBool;
  begin
    if TryAddOperator('==', bmoEqual) or TryAddOperator('<>', bmoNotEqual) or TryAddOperator(':=', bmoVar) or
      TryAddOperator('>', bmoBigger) or TryAddOperator('<', bmoSmaller) or TryAddOperator('>=', bmoBiggerEqual) or
      TryAddOperator('=>', bmoBiggerEqual) or TryAddOperator('<=', bmoSmallerEqual) or
      TryAddOperator('=<', bmoSmallerEqual) then
      Exit(True);
    Exit(False);
  end;
  function TryParseOperator: BBool;
  begin
    if C^ in cOperators then begin
      CreateFO;
      B := C^;

      Inc(C);
      if (C <= EOP) and (C^ in ['=', '<', '>']) then begin
        B := B + C^;
      end else begin
        Dec(C);
      end;

      if TryAddOperators then begin
        Inc(C);
        AddMacroOperation(C);
        Exit(True);
      end;

      B := '';
    end;
    Exit(False);
  end;
  function TryAddLabel(const AStart, AEnd: BStr; const AKind: BMacroOperationKind): BBool;
  begin
    P1 := BStrPos(AStart, S);
    if P1 = 1 then begin
      P2 := BStrPos(AEnd, S);
      if P2 > 0 then begin
        AddOperation;
        O^.Kind := AKind;
        O^.Datas := Copy(S, 2, P2 - 2);
        Exit(True);
      end;
    end;
    Exit(False);
  end;

begin
  if TryAddLabel('[', ']', bmoFalseLabel) or TryAddLabel('{', '}', bmoLabel) then
    Exit;
  B := '';
  C := @S[1];
  EOP := @S[Length(S)];
  while C <= EOP do begin
    if TryParseOperator then begin
      Exit;
    end else if C^ = '(' then
      GetDText(B, C, EOP, '(', ')')
    else
      B := B + C^;
    Inc(C);
  end;
  CreateFO;
end;

function BMacroCore.ParamCount: BInt32;
begin
  Result := High(_Macro[_CallingIdx].FuncParams) + 1;
end;

function BMacroCore.FormatMacroCode: BStr;
var
  I, L: BInt32;
  KN: BMacroOperationKind;
  procedure _R(S: BStr);
  begin
    Result := Result + S;
  end;

begin
  Result := '';
  I := 1;
  L := 1;
  while I < High(_Macro) do begin
    if _Macro[I].Kind = bmoLabel then
      _R(BStrLine + '{');
    if _Macro[I].Kind = bmoFalseLabel then
      _R(' [');
    _R(_Macro[I].Datas);
    if _Macro[I].Kind = bmoLabel then
      _R('} ');
    if _Macro[I].Kind = bmoFalseLabel then
      _R(']');
    KN := _Macro[I + 1].Kind;
    if KN in ckOperators then
      Inc(L, 2);
    if KN = bmoFalseLabel then
      Inc(L);
    Dec(L);
    if L = 0 then begin
      L := 1;
      if Result <> '' then
        _R(#13#10);
    end;
    Inc(I);
  end;
end;

procedure BMacroCore.AddDebugFmt(const AMessageFmt: BStr; const AArgs: array of const);
begin
  AddDebug(BFormat(AMessageFmt, AArgs));
end;

procedure BMacroCore.AddDebugSpacer;
begin
  if _Debug.LastLN then
    Exit;
  _Debug.LastLN := True;
  _Debug.Info := _Debug.Info + #13#10;
end;

end.
