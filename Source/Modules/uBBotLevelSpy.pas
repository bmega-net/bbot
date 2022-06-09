unit uBBotLevelSpy;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotLevelSpy = class(TBBotAction)
  private type
    TTibiaLevelSpyOperation = array [0 .. 5] of BInt8;
    TTibiaLevelSpyOperations = array [0 .. 2] of TTibiaLevelSpyOperation;
  private
    DefaultOPs: TTibiaLevelSpyOperations;
    FLevel: BInt32;
    function _IsDefaultValid: BBool;
    function IsDefaultValid: BBool;
    function IsPatched: BBool;
    procedure Patch;
    procedure UnPatch;
    procedure SetLevel(const Value: BInt32);
  public
    constructor Create;
    destructor Destroy; override;

    property Level: BInt32 read FLevel;

    procedure Run; override;
    procedure OnInit; override;
    procedure OnWalk(Pos: BPos);

    procedure Reset;
    procedure IncFloor;
    procedure DecFloor;
  end;

implementation

{ TBBotLevelSpy }

uses
  BBotEngine,
  uTibiaProcess,
  uBBotAddresses;

constructor TBBotLevelSpy.Create;
begin
  inherited Create('LevelSpy', 10000);
  FillChar(DefaultOPs[0][0], SizeOf(DefaultOPs), $90);
  FLevel := 0;
end;

procedure TBBotLevelSpy.DecFloor;
begin
  SetLevel(FLevel - 1);
end;

destructor TBBotLevelSpy.Destroy;
begin
  // TODO :: CRASH USING TIBIAPROCESS ALREADY FREE
  // UnPatch;
  inherited;
end;

procedure TBBotLevelSpy.IncFloor;
begin
  SetLevel(FLevel + 1);
end;

function TBBotLevelSpy.IsDefaultValid: BBool;
var
  I: BInt32;
begin
  Result := _IsDefaultValid;
  if not Result then begin
    for I := 0 to High(DefaultOPs) do
      if TibiaAddresses.LevelSpy[I] <> 0 then
        TibiaProcess.Read(TibiaAddresses.LevelSpy[I], SizeOf(DefaultOPs[I]), @DefaultOPs[I][0]);
    Result := _IsDefaultValid;
  end;
end;

function TBBotLevelSpy.IsPatched: BBool;
var
  V: BInt8;
begin
  TibiaProcess.Read(TibiaAddresses.LevelSpy[0], 1, @V);
  Result := V = $90;
end;

procedure TBBotLevelSpy.OnInit;
begin
  inherited;
  BBot.Events.OnWalk.Add(OnWalk);
end;

procedure TBBotLevelSpy.OnWalk(Pos: BPos);
begin
  Reset;
end;

procedure TBBotLevelSpy.Patch;
const
  Nops: TTibiaLevelSpyOperation = ($90, $90, $90, $90, $90, $90);
var
  I: BInt32;
begin
  if IsDefaultValid and (not IsPatched) then
    for I := 0 to High(DefaultOPs) do
      TibiaProcess.Write(TibiaAddresses.LevelSpy[I], SizeOf(Nops), @Nops[0]);
end;

procedure TBBotLevelSpy.Reset;
begin
  if IsPatched then begin
    FLevel := 0;
    UnPatch;
  end;
end;

procedure TBBotLevelSpy.Run;
begin
end;

procedure TBBotLevelSpy.SetLevel(const Value: BInt32);
var
  Z, P: BInt32;
begin
  FLevel := Value;
  Z := Me.Position.Z;
  if (Z <= 7) and BInRange(Z - FLevel, 0, 7) then
    Z := 7 - Z + FLevel
  else if (Z > 7) and (BAbs(FLevel) <= 2) and ((Z - FLevel) < 16) then
    Z := 2 + FLevel
  else
    Exit;
  Patch;
  if IsPatched and BInRange(Z, 0, 15) then begin
    TibiaProcess.Read(TibiaAddresses.AdrScreenRectAndLevelSpyPtr, 4, @P);
    TibiaProcess.ReadEx(TibiaAddresses.LevelSpyAdd1 + P, 4, @P);
    TibiaProcess.WriteEx(TibiaAddresses.LevelSpyAdd2 + P, 4, @Z);
  end;
end;

procedure TBBotLevelSpy.UnPatch;
var
  I: BInt32;
begin
  if IsDefaultValid and IsPatched then
    for I := 0 to High(DefaultOPs) do
      TibiaProcess.Write(TibiaAddresses.LevelSpy[I], SizeOf(DefaultOPs[I]), @DefaultOPs[I]);
end;

function TBBotLevelSpy._IsDefaultValid: BBool;
begin
  Result := (DefaultOPs[0][0] <> 0) and (DefaultOPs[0][0] <> $90);
end;

end.
