unit uBBotSpells;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction;

type
  TTibiaSpellKind = (tskAttack, tskHealing, tskSummon, tskSupply, tskSupport);
  PTibiaSpell = ^TTibiaSpell;

  TTibiaSpell = class
  private
    FName: BStr;
    FSpell: BStr;
    FKind: TTibiaSpellKind;
    FMana: BInt32;
    FStrippedSpell: BStr;
    function StripSpell(const ASpell: BStr): BStr;
  public
    constructor Create(ACode: BStr);

    property Name: BStr read FName;
    property Spell: BStr read FSpell;
    property StrippedSpell: BStr read FStrippedSpell;
    property Mana: BInt32 read FMana;
    property Kind: TTibiaSpellKind read FKind;

    function EqualTo(const AText: BStr): BBool;
    function NotEqualTo(const AText: BStr): BBool;
  end;

  TBBotSpells = class(TBBotAction)
  private
    FSpells: BVector<TTibiaSpell>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadSpells;
    procedure AddSpell(ACode: BStr);

    procedure OnInit; override;
    procedure Run; override;

    property Spells: BVector<TTibiaSpell> read FSpells;
    function Spell(AText: BStr): TTibiaSpell;
  end;

implementation

uses
  SysUtils;

{ TTibiaSpell }

constructor TTibiaSpell.Create(ACode: BStr);
var
  R: BStrArray;
begin
  if BStrSplit(R, '/', ACode) = 4 then
  begin
    FName := R[0];
    FSpell := BStrLower(R[1]);
    FStrippedSpell := StripSpell(FSpell);
    try
      FMana := BStrTo32(R[2]);
    except
      raise Exception.Create('Invalid spell mana in ' + ACode);
    end;
    if BStrEqual(R[3], 'Healing') then
      FKind := tskHealing
    else if BStrEqual(R[3], 'Attack') then
      FKind := tskAttack
    else if BStrEqual(R[3], 'Supply') then
      FKind := tskSupply
    else if BStrEqual(R[3], 'Support') then
      FKind := tskSupport
    else if BStrEqual(R[3], 'Summon') then
      FKind := tskSummon
    else
      raise Exception.Create('Invalid spell kind in ' + ACode);
  end
  else
    raise Exception.Create('Invalid spell number of arguments in ' + ACode);
end;

function TTibiaSpell.EqualTo(const AText: BStr): BBool;
begin
  Result := BStrEqualSensitive(FStrippedSpell, StripSpell(AText));
end;

function TTibiaSpell.NotEqualTo(const AText: BStr): BBool;
begin
  Result := not EqualTo(AText);
end;

function TTibiaSpell.StripSpell(const ASpell: BStr): BStr;
var
  P: BInt32;
begin
  P := BStrPos('"', ASpell);
  if P > 0 then
    Result := BStrLeft(ASpell, P - 1)
  else
    Result := ASpell;
  Result := BStrReplaceSensitive(BStrLower(Result), ' ', '');
end;

{ TBBotSpells }

procedure TBBotSpells.AddSpell(ACode: BStr);
begin
  FSpells.Add(TTibiaSpell.Create(ACode));
end;

constructor TBBotSpells.Create;
begin
  inherited Create('Spells', 10000);
  FSpells := BVector<TTibiaSpell>.Create(
    procedure(It: BVector<TTibiaSpell>.It)
    begin
      It^.Free;
    end);
end;

destructor TBBotSpells.Destroy;
begin
  FSpells.Free;
  inherited;
end;

procedure TBBotSpells.LoadSpells;
const
  SpellsFile = './Data/BBot.Spells.txt';
var
  FileHandle: TextFile;
  Line: BStr;
begin
  AssignFile(FileHandle, SpellsFile);
  try
    Reset(FileHandle);
    while not EOF(FileHandle) do
    begin
      Readln(FileHandle, Line);
      Line := BTrim(Line);
      if (Length(Line) > 0) and (Line[1] <> '#') then
        AddSpell(Line);
    end;
    CloseFile(FileHandle);
  except
    on E: Exception do
      raise BException.Create('Error loading BBot.Spells:' + BStrLine +
        E.Message);
  end;
end;

procedure TBBotSpells.OnInit;
begin
  LoadSpells;
end;

procedure TBBotSpells.Run;
begin
end;

function TBBotSpells.Spell(AText: BStr): TTibiaSpell;
var
  It: BVector<TTibiaSpell>.It;
begin
  It := FSpells.Find('Looking for spell [' + AText + ']',
    function(It: BVector<TTibiaSpell>.It): BBool
    begin
      Result := It^.EqualTo(AText);
    end);
  if It <> nil then
    Result := It^
  else
    Result := nil;
end;

{$IFNDEF Release}
{ .$DEFINE TestSpells }
{$IFDEF TestSpells}

procedure _TestSpell(const A, B: BStr);
var
  S: TTibiaSpell;
begin
  S := TTibiaSpell.Create('x/' + A + '/0/Support');
  if not S.EqualTo(B) then
    raise Exception.Create('Failed on test A: ' + A + ' B: ' + B);
  S.Free;
end;

procedure TestSpell(const A, B: BStr);
begin
  _TestSpell(A, B);
  _TestSpell(B, A);
end;

procedure TestSpells;
begin
  TestSpell('exura', 'exura');
  TestSpell('exura ', 'exura');
  TestSpell('exura', 'exura ');
  TestSpell('ex ura', 'exu ra');
  TestSpell('exura sio "Test', 'exura sio"test"');
  TestSpell('exura sio " ', 'exura sio"');
  TestSpell('eXurA', 'exUrA');
  Halt;
end;

initialization

TestSpells;
{$ENDIF}
{$ENDIF}

end.

