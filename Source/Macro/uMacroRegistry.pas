unit uMacroRegistry;

interface

uses
  uBTypes,
  uBVector,
  Generics.Collections,
  uIMacro,
  uMacroVariable,
  Generics.Defaults;

type
  BMacroFunc = record
    Name: BStr;
    Params: BStr;
    Desc: BStr;
    Kind: BMacroVariableKind;
    FuncAsInt: BUnaryFunc<BMacro, BInt32>;
    FuncAsStr: BUnaryFunc<BMacro, BStr>;
  end;

  BMacroRegistry = class
  private type
    BMacroWhen = record
      Event: BStr;
      Cond: BFunc<BBool>;
      Macro: BStr;
      HandlerLabel: BStr;
    end;
  private
    Funcs: TDictionary<BStr, BMacroFunc>;
    Whens: TObjectDictionary<BStr, BVector<BMacroWhen>>;
    Docs: BVector<BMacroFunc>;

    FVariables: TObjectDictionary<BStr, BMacroVariable>;
    FVariablesSorted: TList<BStr>;

    FConstants: TDictionary<BStr, BFunc<BInt32>>;
    FConstantsSorted: TList<BStr>;
    FConstantsDesc: TDictionary<BStr, BStr>;

    FCooldown: TDictionary<BStr, BUInt32>;
  protected
    function GetConstant(const AName: BStr): BInt32;
    function NormalizeVariableName(const AName: BStr): BStr;
    procedure AddVariable(const AName: BStr; const AVariable: BMacroVariable);
    function GetVariable(const AName: BStr): BMacroVariable;
    function GenConstantsDoc(): BStr;
  public
    constructor Create;
    destructor Destroy; override;

    // Registry Functions
    procedure AddFunc(AName, AParams, ADesc: BStr; AFunc: BUnaryFunc<BMacro, BInt32>); overload;
    procedure AddFunc(AName, AParams, ADesc: BStr; AFunc: BUnaryFunc<BMacro, BStr>); overload;
    function FuncByName(AName: BStr; var AFunc: BMacroFunc): BBool; overload;

    // Registry Constants
    property AllConstants: TDictionary < BStr, BFunc < BInt32 >> read FConstants;
    property ConstantsSorted: TList<BStr> read FConstantsSorted;
    procedure AddConst(const AName, ADesc: BStr; const AValue: BFunc<BInt32>); overload;
    procedure AddConst(const AName, ADesc: BStr; const AValue: BInt32); overload;
    property Constants[const AName: BStr]: BInt32 read GetConstant; // Change to ConstantByName
    function ConstantByName(const AName: BStr): BInt32;
    function ConstantsForValue(const AValue: BInt32): BStrArray;

    // Registry Variables
    property AllVariables: TObjectDictionary<BStr, BMacroVariable> read FVariables;
    property VariablesSorted: TList<BStr> read FVariablesSorted;
    property Variables[const AName: BStr]: BMacroVariable read GetVariable;
    function VariablesTryGet(const AName: BStr; out AVariable: BMacroVariable): BBool;
    function VariablesTry(const AName: BStr; out AValue: BInt32): BBool; overload;
    function VariablesTry(const AName: BStr; out AValue: BStr): BBool; overload;
    function CreateSystemVariable(const AName: BStr; const ADefaultValue: BInt32): BMacroVariable;

    // Registry Cooldowns
    function CooldownBlocked(ACooldown: BStr): BBool;
    property Cooldown: TDictionary<BStr, BUInt32> read FCooldown write FCooldown;

    // Registry Whens
    procedure WatchWhen(const AEvent, AHandlerLabel: BStr; const ACond: BFunc<BBool>; const AHandler: BMacro);
    procedure UnwatchWhen(const AHandler: BMacro);
    procedure CastWhen(const AEvent: BStr);
    procedure CastWhenWith(const AEvent: BStr; const ASetup: BProc);
    function HasWhen(const AEvent: BStr): BBool;

    // Registry Utils / Documentation
    procedure TraverseFunctions(AIter: BBinaryProc<BStr, BStr>);
    procedure AddWikiSection(AName: BStr);
    procedure GenWikiDoc;
  end;

  BMacroRegistryCore = class(BMacroRegistry)
  protected
    procedure CreateCooldownFunctions;
    procedure CreateMathFunctions;
    procedure CreateStringFunctions;
    procedure CreateInternalFunctions;
    procedure InitConstants;
  public
    constructor Create;

    function MatchRegex(const M: BMacro; const APattern, ASubject: BStr): BInt32;
  end;

implementation

uses

  uRegex,
  Declaracoes, BBotEngine;

const
  WikiDocSection = 'WikiDocSection';

procedure BMacroRegistry.AddWikiSection(AName: BStr);
var
  F: BVector<BMacroFunc>.It;
begin
  F := Docs.Add;
  F^.Name := WikiDocSection;
  F^.Params := '';
  F^.Desc := AName;
  F^.Kind := bmvkInt;
  F^.FuncAsInt := function(M: BMacro): BInt32
    begin
      Result := 0;
    end;
end;

procedure BMacroRegistry.AddConst(const AName, ADesc: BStr; const AValue: BFunc<BInt32>);
begin
  FConstants.Add(AName, AValue);
  FConstantsSorted.Add(AName);
  FConstantsSorted.Sort;
  FConstantsDesc.Add(AName, ADesc);
end;

procedure BMacroRegistry.AddConst(const AName, ADesc: BStr; const AValue: BInt32);
begin
  AddConst(AName, ADesc,
    function: BInt32
    begin
      Exit(AValue);
    end);
end;

function CreateListSortedByLength: TList<BStr>;
begin
  Exit(TList<BStr>.Create(TComparer<BStr>.Construct(
    function(const A, B: BStr): Integer
    begin
      Exit(Length(B) - Length(A));
    end)));
end;

procedure BMacroRegistry.AddVariable(const AName: BStr; const AVariable: BMacroVariable);
var
  Name: BStr;
begin
  Name := NormalizeVariableName(AName);
  FVariables.Add(Name, AVariable);
  FVariablesSorted.Add(Name);
  FVariablesSorted.Sort;
end;

function BMacroRegistry.VariablesTry(const AName: BStr; out AValue: BStr): BBool;
var
  Variable: BMacroVariable;
begin
  if VariablesTryGet(AName, Variable) then begin
    AValue := Variable.ValueStr;
    Exit(True);
  end else begin
    Exit(False);
  end;
end;

function BMacroRegistry.VariablesTryGet(const AName: BStr; out AVariable: BMacroVariable): BBool;
begin
  Exit(FVariables.TryGetValue(NormalizeVariableName(AName), AVariable));
end;

function BMacroRegistry.GetVariable(const AName: BStr): BMacroVariable;
begin
  if not VariablesTryGet(AName, Result) then begin
    Result := BMacroVariable.Create(AName);
    AddVariable(AName, Result);
  end;
end;

function BMacroRegistry.NormalizeVariableName(const AName: BStr): BStr;
begin
  Exit(BStrLower(AName));
end;

function BMacroRegistry.CreateSystemVariable(const AName: BStr; const ADefaultValue: BInt32): BMacroVariable;
begin
  if not VariablesTryGet(AName, Result) then begin
    Result := BMacroSystemVariable.Create(AName, ADefaultValue);
    AddVariable(AName, Result);
  end;
end;

function BMacroRegistry.VariablesTry(const AName: BStr; out AValue: BInt32): BBool;
var
  Variable: BMacroVariable;
begin
  if VariablesTryGet(AName, Variable) then begin
    AValue := Variable.Value;
    Exit(True);
  end else begin
    Exit(False);
  end;
end;

procedure BMacroRegistry.AddFunc(AName, AParams, ADesc: BStr; AFunc: BUnaryFunc<BMacro, BInt32>);
var
  R: BStrArray;
  I: BInt32;
  F: BMacroFunc;
begin
  if BStrSplit(R, '|', AName) <> 1 then begin
    for I := 0 to High(R) do
      AddFunc(R[I], AParams, ADesc, AFunc);
  end else begin
    F.Name := AName;
    F.Params := AParams;
    F.FuncAsInt := AFunc;
    F.Kind := bmvkInt;
    F.Desc := ADesc;
    Funcs.Add(BStrLower(AName), F);
    Docs.Add(F);
  end;
end;

procedure BMacroRegistry.AddFunc(AName, AParams, ADesc: BStr; AFunc: BUnaryFunc<BMacro, BStr>);
var
  R: BStrArray;
  I: BInt32;
  F: BMacroFunc;
begin
  if BStrSplit(R, '|', AName) <> 1 then begin
    for I := 0 to High(R) do
      AddFunc(R[I], AParams, ADesc, AFunc);
  end else begin
    F.Name := AName;
    F.Params := AParams;
    F.FuncAsStr := AFunc;
    F.Kind := bmvkStr;
    F.Desc := ADesc;
    Funcs.Add(BStrLower(AName), F);
    Docs.Add(F);
  end;
end;

function BMacroRegistry.ConstantByName(const AName: BStr): BInt32;
var
  Fn: BFunc<BInt32>;
begin
  if FConstants.TryGetValue(AName, Fn) then
    Exit(Fn());
  Exit(-1);
end;

function BMacroRegistry.ConstantsForValue(const AValue: BInt32): BStrArray;
var
  ConstIter: TDictionary < BStr, BFunc < BInt32 >>.TPairEnumerator;
begin
  SetLength(Result, 0);
  ConstIter := FConstants.GetEnumerator;
  while ConstIter.MoveNext do
    if ConstIter.Current.Value() = AValue then begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := ':' + ConstIter.Current.Key;
    end;
  ConstIter.Free;
end;

procedure BMacroRegistry.TraverseFunctions(AIter: BBinaryProc<BStr, BStr>);
var
  Name, Insert: BStr;
var
  ConstIter: TDictionary < BStr, BFunc < BInt32 >>.TPairEnumerator;
  FuncsIter: TObjectDictionary<BStr, BMacroFunc>.TPairEnumerator;
  F: BMacroFunc;
begin
  FuncsIter := Funcs.GetEnumerator;
  while FuncsIter.MoveNext do begin
    F := FuncsIter.Current.Value;
    if F.Name <> WikiDocSection then begin
      Name := F.Name + '||' + F.Params + '||' + F.Desc;
      Insert := F.Name + '(' + F.Params + ')';
      AIter(Name, Insert);
    end;
  end;
  FuncsIter.Free;
  ConstIter := FConstants.GetEnumerator;
  while ConstIter.MoveNext do begin
    Name := ConstIter.Current.Key;
    Insert := ':' + Name;
    Name := Insert + '|| ||(constant)';
    AIter(Name, Insert);
  end;
  ConstIter.Free;
end;

procedure BMacroRegistry.WatchWhen(const AEvent, AHandlerLabel: BStr; const ACond: BFunc<BBool>;
const AHandler: BMacro);
var
  Handlers: BVector<BMacroWhen>;
  WhenHandler: BVector<BMacroWhen>.It;
begin
  if not Whens.TryGetValue(AEvent, Handlers) then begin
    Handlers := BVector<BMacroWhen>.Create;
    Whens.Add(AEvent, Handlers);
  end;
  if Handlers.Has('Macro Registry - When ' + AEvent, function(AIt: BVector<BMacroWhen>.It): BBool
  begin
    Exit((AIt^.Event = AEvent) and (AIt^.Macro = AHandler.Name) and (AIt^.HandlerLabel = AHandlerLabel));
  end) then
    Exit;
  WhenHandler := Handlers.Add();
  WhenHandler^.Event := AEvent;
  WhenHandler^.Cond := ACond;
  WhenHandler^.Macro := AHandler.Name;
  WhenHandler^.HandlerLabel := AHandlerLabel;
end;

procedure BMacroRegistry.UnwatchWhen(const AHandler: BMacro);
var
  WhenIter: TObjectDictionary < BStr, BVector < BMacroWhen >>.TPairEnumerator;
begin
  WhenIter := Whens.GetEnumerator;
  while WhenIter.MoveNext do begin
    WhenIter.Current.Value.Delete(
      function(AIt: BVector<BMacroWhen>.It): BBool
      begin
        Exit(AIt^.Macro = AHandler.Name);
      end);
  end;
  WhenIter.Free;
end;

procedure BMacroRegistry.CastWhen(const AEvent: BStr);
begin
  BExecuteInSafeScope('Macro:When:' + AEvent,
    procedure()
    var
      Handlers: BVector<BMacroWhen>;
    begin
      if Whens.TryGetValue(AEvent, Handlers) then begin
        Handlers.ForEach(
          procedure(AIt: BVector<BMacroWhen>.It)
          begin
            BExecuteInSafeScope('Macro:When:' + AEvent + '::' + AIt^.Macro,
              procedure()
              begin
                if AIt^.Cond() then
                  BBot.Macros.Execute(AIt^.Macro, AIt^.HandlerLabel);
              end);
          end);
      end;
    end);
end;

procedure BMacroRegistry.CastWhenWith(const AEvent: BStr; const ASetup: BProc);
begin
  if HasWhen(AEvent) then begin
    ASetup();
    CastWhen(AEvent);
  end;
end;

function BMacroRegistry.HasWhen(const AEvent: BStr): BBool;
var
  Handlers: BVector<BMacroWhen>;
begin
  if Whens.TryGetValue(AEvent, Handlers) then
    Exit(not Handlers.Empty);
  Exit(False);
end;

function BMacroRegistry.GetConstant(const AName: BStr): BInt32;
var
  Fn: BFunc<BInt32>;
begin
  if FConstants.TryGetValue(AName, Fn) then
    Exit(Fn());
  Exit(-1);
end;

function BMacroRegistry.CooldownBlocked(ACooldown: BStr): BBool;
var
  Expire: BUInt32;
begin
  if FCooldown.TryGetValue(ACooldown, Expire) then
    if Expire > Tick then
      Exit(True);
  Exit(False);
end;

constructor BMacroRegistry.Create;
begin
  Funcs := TDictionary<BStr, BMacroFunc>.Create();
  Docs := BVector<BMacroFunc>.Create;
  Whens := TObjectDictionary < BStr, BVector < BMacroWhen >>.Create([doOwnsValues]);

  FConstants := TDictionary < BStr, BFunc < BInt32 >>.Create();
  FConstantsSorted := CreateListSortedByLength;
  FConstantsDesc := TDictionary<BStr, BStr>.Create();

  FVariables := TObjectDictionary<BStr, BMacroVariable>.Create([doOwnsValues]);
  FVariablesSorted := CreateListSortedByLength;

  FCooldown := TDictionary<BStr, BUInt32>.Create;
end;

destructor BMacroRegistry.Destroy;
begin
  Funcs.Free;
  Docs.Free;
  Whens.Free;

  FConstants.Free;
  FConstantsSorted.Free;
  FConstantsDesc.Free;

  FVariables.Free;
  FVariablesSorted.Free;

  FCooldown.Free;
  inherited;
end;

function BMacroRegistry.FuncByName(AName: BStr; var AFunc: BMacroFunc): BBool;
begin
  Exit(Funcs.TryGetValue(BStrLower(AName), AFunc));
end;

function BMacroRegistry.GenConstantsDoc: BStr;
var
  I: BInt32;
  Name: BStr;
begin
  Result := '';
  for I := 0 to FConstantsSorted.Count - 1 do begin
    Name := FConstantsSorted[I];
    Result := Result +
      '**'  + Name + '**//' + FConstantsDesc[Name] + '//' + #13#10;
  end;
end;

procedure BMacroRegistry.GenWikiDoc;
var
  S: BStr;
  FuncsIter: BVectorIterator<BMacroFunc>;
  F: BMacroFunc;
begin
  S := '' +
'' + #13#10 +
'====== Macro Commands ======' + #13#10 +
'' + #13#10 +
'===== Creating Variables =====' + #13#10 +
'' + #13#10 +
'To create variables you must use the following syntax:' + #13#10 +
'' + #13#10 +
'**VariableName** := //DefaultValue//' + #13#10 +
'' + #13#10 +
'Example:' + #13#10 +
'' + #13#10 +
'**HP**:=//Self.Health()//' + #13#10 +
'' + #13#10 +
'**MagicNumber**:=//3529//' + #13#10 +
'' + #13#10 +
'===== Using Variables =====' + #13#10 +
'' + #13#10 +
'You can use the variables in many places of the BBot, to use a variable use this syntax:' + #13#10 +
'' + #13#10 +
'**!**//VariableName//**!**' + #13#10 +
'' + #13#10 +
'Self.Say(**!**//HP//**!** or shorthand **!**//HP//)' + #13#10 +
'' + #13#10 +
'SecondMagicNumber:=**!**//MagicNumber//**!**' + #13#10 +
'ThirdMagicNumber:=**!**//MagicNumber//' + #13#10 +
'' + #13#10 +
'Variables can be used in the FullCheck and some other features of the BBot.' + #13#10 +
'' + #13#10 +
'===== Constants and Shortcuts =====' + #13#10 + GenConstantsDoc();

  FuncsIter := Docs.Iter;
  while FuncsIter.HasNext do begin
    F := FuncsIter.Next;
    if F.Name <> WikiDocSection then
      S := S + BFormat('**%s**//(%s)// %s' + BStrLine + BStrLine, [F.Name, F.Params, F.Desc])
    else
      S := S + BFormat('===== %s =====' + BStrLine + BStrLine, [F.Desc]);
  end;
  BFilePut('BBot.Macros.Documentation.txt', S);
end;

{ BMacroRegistryCore }

constructor BMacroRegistryCore.Create;
begin
  inherited;
  InitConstants;
  CreateInternalFunctions;
  CreateMathFunctions;
  CreateStringFunctions;
  CreateCooldownFunctions;
end;

procedure BMacroRegistryCore.CreateCooldownFunctions;
begin
  AddWikiSection('Cooldown variables');
  AddFunc('Cooldown.Create', 'CooldownName, Delay', 'Create a cooldown named CooldownName with Delay',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      FCooldown.AddOrSetValue(M.ParamStr(0), Tick + BUInt32(M.ParamInt(1)));
    end);

  AddFunc('Cooldown.Clear', 'CooldownName', 'Clear a cooldown named CooldownName',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      FCooldown.Remove(M.ParamStr(0));
    end);

  AddFunc('Cooldown.Rest', 'CooldownName', 'How many miliseconds Cooldown will be still active (or return 0)',
    function(M: BMacro): BInt32
    var
      Expire: BUInt32;
    begin
      if FCooldown.TryGetValue(M.ParamStr(0), Expire) then
        if Expire > Tick then
          Exit(Expire - Tick);
      Exit(0);
    end);

  AddFunc('Cooldown.Blocked', 'CooldownName', 'Verifies if there is an active Cooldown named CooldownName',
    function(M: BMacro): BInt32
    begin
      Result := BIf(CooldownBlocked(M.ParamStr(0)), BMacroTrue, BMacroFalse);
    end);

  AddFunc('Cooldown.UnBlocked', 'CooldownName', 'Verifies if there is not an active Cooldown named CooldownName',
    function(M: BMacro): BInt32
    begin
      Result := BIf(CooldownBlocked(M.ParamStr(0)), BMacroFalse, BMacroTrue);
    end);
end;

procedure BMacroRegistryCore.CreateInternalFunctions;
begin
  AddWikiSection('Internals');
  AddFunc('Exit', '', 'Stop the macro execution',
    function(M: BMacro): BInt32
    begin
      Result := BMacroFalse;
      M.GoExit;
    end);
  AddFunc('Label|GoLabel', 'Name', 'Go to a Label',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.GoLabel(M.ParamStr(0));
    end);
  AddFunc('Comment', '', 'No-op',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
    end);
  AddFunc('VarSet', 'Name, Value', 'Set the variable to given value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.SetVariable(M.ParamStr(0), M.ParamInt(1));
    end);
  AddFunc('VarGet', 'Name', 'Return the INT value of a variable by its name (only for numeric variables!!)',
    function(M: BMacro): BInt32
    begin
      Exit(M.Variable(M.ParamStr(0)));
    end);
  AddFunc('HasVar', 'VarName', 'If a variable exists',
  function(M: BMacro): BInt32
    begin
      Result := MacroBool(M.HasVariable(M.ParamStr(0)));
    end);
  AddFunc('GenWikiDoc', '', 'Generates the Macro Documentation in the BBot.Macros.Documentation.txt file',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      GenWikiDoc;
    end);
end;

procedure BMacroRegistryCore.CreateMathFunctions;
begin
  AddWikiSection('Math');
  AddFunc('VarAdd', 'Name, Value', 'Increase the variable by a given value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.SetVariable(M.ParamStr(0), M.Variable(M.ParamStr(0)) + M.ParamInt(1));
    end);
  AddFunc('VarSub', 'Name, Value', 'Decrease the variable by a given value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.SetVariable(M.ParamStr(0), M.Variable(M.ParamStr(0)) - M.ParamInt(1));
    end);
  AddFunc('VarMult', 'Name, Value', 'Multiplies the variable by the given value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.SetVariable(M.ParamStr(0), M.Variable(M.ParamStr(0)) * M.ParamInt(1));
    end);
  AddFunc('VarDiv', 'Name, Value', 'Divides the variable by the given value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      if M.ParamInt(1) = 0 then
        Exit;
      M.SetVariable(M.ParamStr(0), M.Variable(M.ParamStr(0)) div M.ParamInt(1));
    end);
  AddFunc('VarMod', 'Name, Value', 'Returns the modulos remainder of the Variable by the Value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.SetVariable(M.ParamStr(0), M.Variable(M.ParamStr(0)) mod M.ParamInt(1));
    end);
  AddFunc('Add', 'A, B', 'Return A + B',
    function(M: BMacro): BInt32
    begin
      Result := M.ParamInt(0) + M.ParamInt(1);
    end);
  AddFunc('Sub', 'A, B', 'Return A - B',
    function(M: BMacro): BInt32
    begin
      Result := M.ParamInt(0) - M.ParamInt(1);
    end);
  AddFunc('Mult', 'A, B', 'Return A * B',
    function(M: BMacro): BInt32
    begin
      Result := M.ParamInt(0) * M.ParamInt(1);
    end);
  AddFunc('Div', 'A, B', 'Return A / B (integer)',
    function(M: BMacro): BInt32
    begin
      if M.ParamInt(1) = 0 then
        Exit(0);
      Result := M.ParamInt(0) div M.ParamInt(1);
    end);
  AddFunc('Mod', 'A, B', 'Return A % B (modulos remainder)',
    function(M: BMacro): BInt32
    begin
      if M.ParamInt(1) = 0 then
        Exit(0);
      Result := M.ParamInt(0) div M.ParamInt(1);
    end);
  AddFunc('Smallest', 'A, B, C...', 'Return smallest of all the parameters',
    function(M: BMacro): BInt32
    var
      I, V: BInt32;
    begin
      Result := M.ParamInt(0);
      I := 1;
      while I < M.ParamCount do begin
        V := M.ParamInt(I);
        if V < Result then
          Result := V;
        Inc(I);
      end;
    end);
  AddFunc('Greatest', 'A, B, C...', 'Return greatest of all the parameters',
    function(M: BMacro): BInt32
    var
      I, V: BInt32;
    begin
      Result := M.ParamInt(0);
      I := 1;
      while I < M.ParamCount do begin
        V := M.ParamInt(I);
        if V > Result then
          Result := V;
        Inc(I);
      end;
    end);

end;

procedure BMacroRegistryCore.CreateStringFunctions;
begin
  AddWikiSection('String');
  AddFunc('Str.Set', 'StrVariableName, StrValue', 'Set variable name to STR value',
    function(M: BMacro): BInt32
    begin
      Result := BMacroTrue;
      M.SetVariable(M.ParamStr(0), M.ParamStr(1));
    end);
  AddFunc('Str.Copy', 'StrInputVariable, StrOutputVariable', 'Copy a Input variable into a Output variable',
    function(M: BMacro): BInt32
    var
      V: BStr;
    begin
      V := M.VariableStr(M.ParamStr(0));
      M.SetVariable(M.ParamStr(1), V);
      Exit(BMacroTrue);
    end);
  AddFunc('Str.VarEquals', 'StrVariableNameA, StrVariableNameB', 'Check if two STR variables are equals (non-sensitive)',
    function(M: BMacro): BInt32
    var
      A, B: BStr;
    begin
      A := M.VariableStr(M.ParamStr(0));
      B := M.VariableStr(M.ParamStr(1));
      if BStrEqual(A, B) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);
    end);
  AddFunc('Str.VarEqualsSensitive', 'StrVariableNameA, StrVariableNameB',
    'Check if two STR variables are equals (sensitive)',
    function(M: BMacro): BInt32
    var
      A, B: BStr;
    begin
      A := M.VariableStr(M.ParamStr(0));
      B := M.VariableStr(M.ParamStr(1));
      if BStrEqualSensitive(A, B) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);
    end);
  AddFunc('Str.Equals', 'StrA, StrB', 'Check if two strings are equals',
    function(M: BMacro): BInt32
    var
      A, B: BStr;
    begin
      A := M.ParamStr(0);
      B := M.ParamStr(1);
      if BStrEqual(A, B) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);
    end);
  AddFunc('Str.EqualsSensitive', 'StrA, StrB',
    'Check if two strings are equals (sensitive)',
    function(M: BMacro): BInt32
    var
      A, B: BStr;
    begin
      A := M.ParamStr(0);
      B := M.ParamStr(1);
      if BStrEqualSensitive(A, B) then
        Exit(BMacroTrue)
      else
        Exit(BMacroFalse);
    end);
  AddFunc('Str.Regex', 'PatternVariableName, SubjectVariableName',
    'Check SubjectVariable content matches to PatternVariable content regex, outputs to !Str.MatchSucced, !Str.MatchFailed, !Str.Match.0, !Str.Match.1 [..] !Str.Match.9',
    function(M: BMacro): BInt32
    var
      Pattern, Subject: BStr;
    begin
      Pattern := M.VariableStr(M.ParamStr(0));
      Subject := M.VariableStr(M.ParamStr(1));
      Exit(MatchRegex(M, Pattern, Subject));
    end);
  AddFunc('Str.Upper', 'StrVariableName', 'Makes a string variable uppercase',
    function(M: BMacro): BInt32
    begin
      M.SetVariable(M.ParamStr(0), BStrUpper(M.VariableStr(M.ParamStr(0))));
      Exit(BMacroTrue);
    end);
  AddFunc('Str.Lower', 'StrVariableName', 'Makes a string variable lowercase',
    function(M: BMacro): BInt32
    begin
      M.SetVariable(M.ParamStr(0), BStrLower(M.VariableStr(M.ParamStr(0))));
      Exit(BMacroTrue);
    end);
  AddFunc('Str.Reverse', 'StrVariableName', 'Reverses a string variable',
    function(M: BMacro): BInt32
    var
      I: BInt32;
      SIn, SOut: BStr;
    begin
      SIn := M.VariableStr(M.ParamStr(0));
      SetLength(SOut, Length(SIn));
      for I := 1 to Length(SIn) do
        SOut[I] := SIn[Length(SIn) - I + 1];
      M.SetVariable(M.ParamStr(0), SOut);
      Exit(BMacroTrue);
    end);
  AddFunc('Str.ToHex8', 'OutHex8, Int8', 'Convert a number to Hex8 string representation',
    function(M: BMacro): BInt32
    var
      InValue: BInt8;
      OutHex: BStr;
    begin
      InValue := M.ParamInt(1);
      OutHex := BStrFromBuffer8(@InValue, 1);
      M.SetVariable(M.ParamStr(0), OutHex);
      Exit(BMacroTrue);
    end);
  AddFunc('Str.ToHex16', 'OutHex16, Int16', 'Convert a number to Hex16 string representation',
    function(M: BMacro): BInt32
    var
      InValue: BInt16;
      OutHex: BStr;
    begin
      InValue := M.ParamInt(1);
      OutHex := BStrFromBuffer8(@InValue, 2);
      M.SetVariable(M.ParamStr(0), OutHex);
      Exit(BMacroTrue);
    end);
  AddFunc('Str.ToHex32', 'OutHex32, Int32', 'Convert a number to Hex32 string representation',
    function(M: BMacro): BInt32
    var
      InValue: BInt32;
      OutHex: BStr;
    begin
      InValue := M.ParamInt(1);
      OutHex := BStrFromBuffer8(@InValue, 4);
      M.SetVariable(M.ParamStr(0), OutHex);
      Exit(BMacroTrue);
    end);
end;

procedure BMacroRegistryCore.InitConstants;
begin
  AddConst('False', 'False', BMacroFalse);
  AddConst('No', 'False', BMacroFalse);

  AddConst('True', 'True', BMacroTrue);
  AddConst('Yes', 'True', BMacroTrue);
  AddConst('Ok', 'True', BMacroTrue);
end;

function BMacroRegistryCore.MatchRegex(const M: BMacro; const APattern, ASubject: BStr): BInt32;
var
  Res: BStrArray;
  I: BInt32;
begin
  if M.Debugging then
    M.AddDebugFmt('[Regex] %s trying match against \n %s', [APattern, ASubject]);
  if BSimpleRegex(APattern, ASubject, Res) then begin
    for I := 0 to High(Res) do
      M.SetVariable('Str.Match.' + BToStr(I), Res[I]);
    M.SetVariable('Str.MatchFailed', BMacroFalse);
    M.SetVariable('Str.MatchSucced', BMacroTrue);
    Exit(BMacroTrue)
  end else begin
    M.SetVariable('Str.MatchFailed', BMacroTrue);
    M.SetVariable('Str.MatchSucced', BMacroFalse);
    Exit(BMacroFalse);
  end;
end;

end.
