unit uBBotMacroRegistry;

interface

uses
  uMacroRegistry;

type
  BBotMacroRegistry = class(BMacroRegistryCore)
  public
    constructor Create;
  end;

implementation

uses
  uBBotMacroFunctions;

{ BBotMacroRegistry }

constructor BBotMacroRegistry.Create;
begin
  inherited Create;
  MacroRegisterFunctions(Self);
  MacroRegisterConstants(Self);
end;

end.
