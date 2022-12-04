unit uMacroVariable;

interface

uses
  uBTypes,
  uBVector,
  System.SysUtils;

type
  BMacroVariableException = class(Exception);
  BMacroVariableKind = (bmvkInt, bmvkStr);

  BMacroVariable = class
  private
    FKind: BMacroVariableKind;
    FName: BStr;
    FValueInt: BInt32;
    FValueStr: BStr;
    WatchersInt: BVector<BBinaryProc<BStr, BInt32>>;
    WatchersStr: BVector<BBinaryProc<BStr, BStr>>;
    procedure SetValueInt(const Value: BInt32);
    function GetValueU32: BUInt32;
    procedure SetValueU32(const Value: BUInt32);
    procedure SetValueStr(const Value: BStr);
    function GetValueI32: BInt32;
    function GetValueStr: BStr;
    procedure CheckKind(const ExpectedKind: BMacroVariableKind);
  public
    constructor Create(const AName: BStr);
    destructor Destroy; override;

    property Name: BStr read FName;
    property Kind: BMacroVariableKind read FKind;
    property Value: BInt32 read GetValueI32 write SetValueInt;
    property ValueU32: BUInt32 read GetValueU32 write SetValueU32;
    property ValueStr: BStr read GetValueStr write SetValueStr;

    procedure Watch(const Handler: BBinaryProc<BStr, BInt32>);
    procedure WatchStr(const Handler: BBinaryProc<BStr, BStr>);

    function ValueAsString: BStr;
  end;

  BMacroSystemVariable = class(BMacroVariable)
  private
    FDefaultValue: BInt32;
    function GetChanged: BBool;
  public
    constructor Create(const AName: BStr; ADefaultValue: BInt32);

    property DefaultValue: BInt32 read FDefaultValue;
    property Changed: BBool read GetChanged;
  end;

const
  BMacroVariableKindNames: array [BMacroVariableKind] of BStr = ('bmvkInt',
    'bmvkStr');

implementation

{ BMacroVariable }

procedure BMacroVariable.CheckKind(const ExpectedKind: BMacroVariableKind);
begin
  if FKind <> ExpectedKind then
    raise BMacroVariableException.CreateFmt
      ('Macro Variable Kind Exception - expected %s received %s for variable %s',
      [BMacroVariableKindNames[ExpectedKind],
      BMacroVariableKindNames[FKind], FName]);
end;

constructor BMacroVariable.Create(const AName: BStr);
begin
  FName := AName;
  FValueInt := 0;
  FValueStr := '';
  FKind := bmvkInt;
  WatchersInt := BVector < BBinaryProc < BStr, BInt32 >>.Create;
  WatchersStr := BVector < BBinaryProc < BStr, BStr >>.Create;
end;

destructor BMacroVariable.Destroy;
begin
  WatchersInt.Free;
  WatchersStr.Free;
  inherited;
end;

function BMacroVariable.GetValueI32: BInt32;
begin
  CheckKind(bmvkInt);
  Exit(FValueInt);
end;

function BMacroVariable.GetValueStr: BStr;
begin
  CheckKind(bmvkStr);
  Exit(FValueStr);
end;

function BMacroVariable.GetValueU32: BUInt32;
begin
  CheckKind(bmvkInt);
  Exit(FValueInt);
end;

procedure BMacroVariable.SetValueInt(const Value: BInt32);
begin
  if (FValueInt <> Value) or (FKind <> bmvkInt) then
  begin
    FValueInt := Value;
    FKind := bmvkInt;
    WatchersInt.ForEach(
      procedure(AIt: BVector < BBinaryProc < BStr, BInt32 >>.It)
      begin
        AIt^(Name, Value);
      end);
  end;
end;

procedure BMacroVariable.SetValueStr(const Value: BStr);
begin
  if (FValueStr <> Value) or (FKind <> bmvkStr) then
  begin
    FValueStr := Value;
    FKind := bmvkStr;
    WatchersStr.ForEach(
      procedure(AIt: BVector < BBinaryProc < BStr, BStr >>.It)
      begin
        AIt^(Name, Value);
      end);
  end;
end;

procedure BMacroVariable.SetValueU32(const Value: BUInt32);
begin
  SetValueInt(BInt32(Value));
end;

function BMacroVariable.ValueAsString: BStr;
begin
  if FKind = bmvkInt then
    Result := BToStr(FValueInt)
  else if FKind = bmvkStr then
    Result := FValueStr;
end;

procedure BMacroVariable.WatchStr(const Handler: BBinaryProc<BStr, BStr>);
begin
  WatchersStr.Add(Handler);
end;

procedure BMacroVariable.Watch(const Handler: BBinaryProc<BStr, BInt32>);
begin
  WatchersInt.Add(Handler);
end;

{ BMacroSystemVariable }

constructor BMacroSystemVariable.Create(const AName: BStr;
ADefaultValue: BInt32);

begin
  inherited Create(AName);
  FDefaultValue := ADefaultValue;
  Value := FDefaultValue;
end;

function BMacroSystemVariable.GetChanged: BBool;

begin
  Exit(DefaultValue <> Value);
end;

end.
