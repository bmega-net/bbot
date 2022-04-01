unit uIMacro;

interface

uses
  uBTypes;

const
  BMacroTrue = 1;
  BMacroFalse = 0;

type
  BMacro = class
  protected
    function GetDebugging: BBool; virtual; abstract;
    function GetName: BStr; virtual; abstract;
  public
    // BMacro Parameters
    function ParamCount: BInt32; virtual; abstract;
    function ParamStr(const AIndex: BInt32): BStr; virtual; abstract;
    function ParamInt(const AIndex: BInt32): BInt32; virtual; abstract;

    // BMacro Variables
    function Variable(const AName: BStr): BInt32; virtual; abstract;
    function VariableStr(const AName: BStr): BStr; virtual; abstract;
    function HasVariable(const AName: BStr): BBool; virtual; abstract;
    procedure SetVariable(const AName: BStr; const AValue: BInt32); overload; virtual; abstract;
    procedure SetVariable(const AName: BStr; const AValue: BStr); overload; virtual; abstract;

    // BMacro Constants
    function Constant(const AName: BStr): BInt32; virtual; abstract;

    // BMacro Whens
    procedure WatchWhen(const AEvent, AHandlerLabel: BStr; const ACond: BFunc<BBool>); virtual; abstract;
    procedure UnwatchWhen(); virtual; abstract;
    procedure CastWhen(const AEvent: BStr); virtual; abstract;

    // BMacro Execution Control
    procedure Execute; overload; virtual; abstract;
    procedure Execute(const AGoLabel: BStr); overload; virtual; abstract;
    procedure GoLabel(const AName: BStr); virtual; abstract;
    procedure GoExit(); virtual; abstract;
    property Debugging: BBool read GetDebugging;
    procedure AddDebug(const AMessage: BStr); virtual; abstract;
    procedure AddDebugFmt(const AMessageFmt: BStr; const AArgs: array of const); virtual; abstract;

    property Name: BStr read GetName;
  end;

function MacroBool(const AValue: BBool): BInt32;

implementation

function MacroBool(const AValue: BBool): BInt32;
begin
  Exit(BIf(AValue, BMacroTrue, BMacroFalse));
end;

end.
