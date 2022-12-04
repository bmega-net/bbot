unit uMacroEngine;

interface

uses
  AnsiStrings,
  uBTypes,
  uBVector,

  uMacroVariable,
  uMacroRegistry,
  uIMacro;

type
  BMacroEngine = class
  private type
    BMacroMacro = record
      Name: BStr;
      Delay: BUInt32;
      Next: BLock;
      Macro: BMacro;
    end;
  private
    ListMacros: array of BMacroMacro;
    FAutoExecute: BBool;
    FRegistry: BMacroRegistry;
  public
    constructor Create;
    destructor Destroy; override;

    property AutoExecute: BBool read FAutoExecute write FAutoExecute;
    property Registry: BMacroRegistry read FRegistry;

    procedure FormatMacro(AICode: BStr; var AName: BStr; var ADelay: BInt32;
      var ACode: BStr);

    procedure ClearMacros;
    procedure AddMacro(ACode: BStr);

    procedure Execute; overload;
    procedure Execute(const AName: BStr); overload;
    procedure Execute(const AName, ALabel: BStr); overload;
    procedure DebugExecute(ACode: BStr);
    procedure ExecuteCode(ACode: BStr);

    function VarsText(const AText: BStr): BStr;
    function VarsList: BVector<BStr>;
  end;

implementation

uses
  Forms,
  StdCtrls,
  SysUtils,
  Windows,
  StrUtils,

  uMacroCore,
  uBBotMacroRegistry,
  Generics.Collections,
  Generics.Defaults;

const
  cOperators = ['=', '>', '<', ':'];
  ckOperators = [bmoEqual, bmoNotEqual, bmoBigger, bmoBiggerEqual, bmoSmaller,
    bmoSmallerEqual, bmoVar];

  { BMacroEngine }

procedure BMacroEngine.AddMacro(ACode: BStr);
var
  BM: BMacroCore;
begin
  SetLength(ListMacros, Length(ListMacros) + 1);
  BM := BMacroCore.Create(Self, False, ACode);
  ListMacros[High(ListMacros)].Macro := BM;
  ListMacros[High(ListMacros)].Name := BM.Name;
  ListMacros[High(ListMacros)].Delay := BM.Delay;
  ListMacros[High(ListMacros)].Next := BLock.Create(BM.Delay, 20);
end;

procedure BMacroEngine.ClearMacros;
var
  I: BInt32;
begin
  for I := High(ListMacros) downto 0 do
  begin
    ListMacros[I].Next.Free;
    ListMacros[I].Macro.Free;
  end;
  SetLength(ListMacros, 0);
  ListMacros := nil;
end;

constructor BMacroEngine.Create;
begin
  ListMacros := nil;
  FAutoExecute := False;
  FRegistry := BBotMacroRegistry.Create;
end;

procedure BMacroEngine.DebugExecute(ACode: BStr);
var
  BM: BMacroCore;
  Res: BStr;
  F: TForm;
  M: TMemo;
begin
  Res := '';
  try
    BM := BMacroCore.Create(Self, True, ACode);
    BM.Execute;
    Res := BM.Debug;
    BM.Free;
  except
    on E: Exception do
      Res := Res + E.Message;
  end;
  F := TForm.Create(nil);
  F.Caption := 'Macro Debug';
  F.BorderStyle := bsSingle;
  F.FormStyle := fsStayOnTop;
  F.Left := 0;
  F.Top := 0;
  M := TMemo.Create(nil);
  M.Parent := F;
  M.Left := 0;
  M.Top := 0;
  M.Text := Res;
  M.Width := 540;
  M.Height := 760;
  M.ScrollBars := ssVertical;
  F.ClientWidth := M.Width;
  F.ClientHeight := M.Height;
  F.ShowModal;
  M.Free;
  F.Free;
end;

destructor BMacroEngine.Destroy;
begin
  ClearMacros;
  ListMacros := nil;
  FRegistry.Free;
  inherited;
end;

procedure BMacroEngine.Execute(const AName: BStr);
begin
  Execute(AName, '');
end;

procedure BMacroEngine.Execute(const AName, ALabel: BStr);
var
  I: BInt32;
begin
  if AName = '' then
    Exit;
  for I := 0 to High(ListMacros) do
    if AnsiSameText(AName, ListMacros[I].Name) then
    begin
      if ALabel <> '' then
        ListMacros[I].Macro.Execute(ALabel)
      else
        ListMacros[I].Macro.Execute;
      Exit;
    end;
end;

procedure BMacroEngine.Execute;
var
  I: BInt32;
begin
  if AutoExecute then
    for I := 0 to High(ListMacros) do
      if ListMacros[I].Delay <> 0 then
        if not ListMacros[I].Next.Locked then
        begin
          ListMacros[I].Macro.Execute;
          ListMacros[I].Next.Lock;
          if ListMacros[I].Delay = 1 then
            ListMacros[I].Delay := 0;
        end;
end;

function BMacroEngine.VarsList: BVector<BStr>;
var
  Iter: TDictionary<BStr, BMacroVariable>.TPairEnumerator;
  IterVar: BMacroVariable;
  Value: BStr;
begin
  Result := BVector<BStr>.Create;
  Iter := Registry.AllVariables.GetEnumerator;
  while Iter.MoveNext do
  begin
    IterVar := Iter.Current.Value;
    Value := IterVar.ValueAsString;
    Result.Add(BFormat('%s=%s', [Iter.Current.Value.Name, Value]));
  end;
  Iter.Free;
  Result.Sort(
    function(A, B: BVector<BStr>.It): BInt32
    begin
      Result := AnsiStrings.StrComp(PAnsiChar(@A^[1]), PAnsiChar(@B^[1]));
      if BStrStartSensitive(A^, 'BBot.') xor BStrStartSensitive(B^, 'BBot.')
      then
        if BStrStartSensitive(A^, 'BBot.') then
          Exit(+1)
        else
          Exit(-1);
    end);
end;

function applyVariablesDict(const AText: BStr;
const AChange: BFunc < BPair < BStr, BStr >> ): BStr;
var
  Change: BPair<BStr, BStr>;
begin
  Result := AText;
  Change := AChange();
  while Change.First <> '' do
  begin
    Result := StringReplace(Result, Change.First, Change.Second,
      [rfReplaceAll, rfIgnoreCase]);
    Change := AChange();
  end;
end;

function BMacroEngine.VarsText(const AText: BStr): BStr;
var
  VarIter, ConstIter: TList<BStr>.TEnumerator;
  First: BBool;
begin
  Result := AText;

  VarIter := Registry.VariablesSorted.GetEnumerator;
  First := True;
  Result := applyVariablesDict(Result,
    function: BPair<BStr, BStr>
    var
      MacroVar: BMacroVariable;
    begin
      if First then
        if not VarIter.MoveNext then
        begin
          Result.First := '';
          Result.Second := '';
          Exit;
        end;
      if Registry.VariablesTryGet(VarIter.Current, MacroVar) then
      begin
        Result.First := '!' + MacroVar.Name + BIf(First, '!', '');
        Result.Second := MacroVar.ValueAsString;
        First := not First;
      end;
    end);
  VarIter.Free;

  ConstIter := Registry.ConstantsSorted.GetEnumerator;
  Result := applyVariablesDict(Result,
    function: BPair<BStr, BStr>
    var
      ConstVal: BFunc<BInt32>;
    begin
      if not ConstIter.MoveNext then
      begin
        Result.First := '';
        Result.Second := '';
        Exit;
      end;
      if Registry.AllConstants.TryGetValue(ConstIter.Current, ConstVal) then
      begin
        Result.First := ':' + ConstIter.Current;
        Result.Second := IntToStr(ConstVal());
      end;
    end);
  ConstIter.Free;
end;

procedure BMacroEngine.FormatMacro(AICode: BStr; var AName: BStr;
var ADelay: BInt32; var ACode: BStr);
var
  BM: BMacroCore;
begin
  BM := BMacroCore.Create(Self, True, AICode);
  AName := BM.Name;
  ADelay := BM.Delay;
  ACode := BM.FormatMacroCode;
  BM.Free;
end;

procedure BMacroEngine.ExecuteCode(ACode: BStr);
var
  BM: BMacroCore;
begin
  BM := BMacroCore.Create(Self, False, ACode);
  BM.Execute;
  BM.Free;
end;

end.
