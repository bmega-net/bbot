unit uBBotCreatures;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uBattlelist,
  uTibiaDeclarations,
  uTibiaState;

type
  TBBotCreatures = class(TBBotAction)
  protected type
    TCreatureType = BPair<BBool, TBBotCreature>;
    TCreaturesType = BVector<TCreatureType>;
    TCreatureIter = TCreaturesType.It;
  protected
    FPlayer: TBBotCreature;
    FTarget: TBBotCreature;
    CreatureList: TCreaturesType;
    FKnownCreatureNames: BVector<BStr>;
    procedure Validate;
    procedure Update; virtual; abstract;
    function GetPlayerID: BUInt32; virtual; abstract;
    function GetTargetID: BUInt32; virtual; abstract;
    function GetCreatureBufferSize: BUInt32; virtual; abstract;
    function GetCreatureBufferCount: BUInt32; virtual; abstract;
    function GetCreatureOffset(AIndex: BUInt32): BUInt32;
    function GetBufferSize: BUInt32;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Write(ACreature: BUInt32; AOffset: BUInt32; AValue: BPtr; ASize: BUInt32); virtual; abstract;

    procedure Run; override;
    procedure Reload;

    property PlayerID: BUInt32 read GetPlayerID;
    property TargetID: BUInt32 read GetTargetID;
    property Player: TBBotCreature read FPlayer;
    property Target: TBBotCreature read FTarget;

    procedure Traverse(AIter: BUnaryProc<TBBotCreature>);
    procedure RawTraverse(AIter: BUnaryProc<TBBotCreature>);
    function RawFind(APred: BUnaryFunc<TBBotCreature, BBool>): TBBotCreature;

    function Find(APred: BUnaryFunc<TBBotCreature, BBool>): TBBotCreature; overload;
    function Find(AID: BUInt32): TBBotCreature; overload;
    function Find(AName: BStr): TBBotCreature; overload;
    function Find(APosition: BPos): TBBotCreature; overload;

    function Has(APred: BUnaryFunc<TBBotCreature, BBool>): BBool; overload;
    function Has(AID: BUInt32): BBool; overload;
    function Has(AName: BStr): BBool; overload;
    function Has(APosition: BPos): BBool; overload;

    property KnownCreatureNames: BVector<BStr> read FKnownCreatureNames;

    class function Get(AVersion: TTibiaVersion): TBBotCreatures;
  end;

implementation

{ TTibiaCreatures }

uses
  uBBotCreatures850,
  uBBotCreatures853,
  uBBotCreatures854,
  uBBotCreatures862,
  uBBotCreatures870,
  uBBotCreatures910,
  uBBotCreatures942,
  uBBotCreatures943,
  uBBotCreatures990,
  uBBotCreatures1036,
  uBBotCreatures1057;

constructor TBBotCreatures.Create;
begin
  inherited Create('Creatures', 4000);
  FKnownCreatureNames := BVector<BStr>.Create();
  FPlayer := nil;
  FTarget := nil;
  CreatureList := TCreaturesType.Create(
    procedure(It: TCreatureIter)
    begin
      It^.First := False;
      It^.Second.Free;
    end);
end;

destructor TBBotCreatures.Destroy;
begin
  CreatureList.Free;
  FKnownCreatureNames.Free;
  inherited;
end;

function TBBotCreatures.Find(APosition: BPos): TBBotCreature;
begin
  Result := Find(
    function(Iter: TBBotCreature): BBool
    begin
      Result := APosition = Iter.Position;
    end);
end;

class function TBBotCreatures.Get(AVersion: TTibiaVersion): TBBotCreatures;
begin
  if AVersion >= TibiaVer1057 then
    Result := TBBotCreatures1057.Create
  else if AVersion >= TibiaVer1036 then
    Result := TBBotCreatures1036.Create
  else if AVersion >= TibiaVer990 then
    Result := TBBotCreatures990.Create
  else if AVersion >= TibiaVer943 then
    Result := TBBotCreatures943.Create
  else if AVersion >= TibiaVer942 then
    Result := TBBotCreatures942.Create
  else if AVersion >= TibiaVer910 then
    Result := TBBotCreatures910.Create
  else if AVersion >= TibiaVer870 then
    Result := TBBotCreatures870.Create
  else if AVersion >= TibiaVer862 then
    Result := TBBotCreatures862.Create
  else if AVersion >= TibiaVer854 then
    Result := TBBotCreatures854.Create
  else if AVersion >= TibiaVer853 then
    Result := TBBotCreatures853.Create
  else
    Result := TBBotCreatures850.Create;
end;

function TBBotCreatures.GetBufferSize: BUInt32;
begin
  Result := GetCreatureBufferSize * GetCreatureBufferCount;
end;

function TBBotCreatures.GetCreatureOffset(AIndex: BUInt32): BUInt32;
begin
  Result := AIndex * GetCreatureBufferSize;
end;

function TBBotCreatures.Find(APred: BUnaryFunc<TBBotCreature, BBool>): TBBotCreature;
var
  Found: TCreatureIter;
begin
  Found := CreatureList.Find('Creatures generic find by predicate lamda',
    function(AIter: TCreatureIter): BBool
    begin
      if AIter^.First then
        Result := APred(AIter^.Second)
      else
        Result := False;
    end);
  if Found = nil then
    Exit(nil)
  else
    Exit(Found^.Second);
end;

function TBBotCreatures.Find(AID: BUInt32): TBBotCreature;
begin
  Result := Find(
    function(Iter: TBBotCreature): BBool
    begin
      Result := AID = Iter.ID;
    end);
end;

function TBBotCreatures.Find(AName: BStr): TBBotCreature;
begin
  Result := Find(
    function(Iter: TBBotCreature): BBool
    begin
      Result := BStrEqual(AName, Iter.Name);
    end);
end;

function TBBotCreatures.Has(AID: BUInt32): BBool;
begin
  Result := Find(AID) <> nil;
end;

function TBBotCreatures.Has(AName: BStr): BBool;
begin
  Result := Find(AName) <> nil;
end;

function TBBotCreatures.Has(APosition: BPos): BBool;
begin
  Result := Find(APosition) <> nil;
end;

function TBBotCreatures.Has(APred: BUnaryFunc<TBBotCreature, BBool>): BBool;
begin
  Result := Find(APred) <> nil;
end;

procedure TBBotCreatures.Reload;
begin
  Update;
  Validate;
end;

procedure TBBotCreatures.Run;
begin
  Traverse(
    procedure(C: TBBotCreature)
    begin
      if not C.IsSelf then
        if not KnownCreatureNames.Has('Creatures - run',
          function(AIt: BVector<BStr>.It): BBool
          begin
            Result := BStrEqual(AIt^, C.Name);
          end) then
          KnownCreatureNames.Add(C.Name);
    end);
end;

procedure TBBotCreatures.Traverse(AIter: BUnaryProc<TBBotCreature>);
begin
  CreatureList.ForEach(
    procedure(It: TCreatureIter)
    begin
      if It^.First then
        AIter(It^.Second);
    end);
end;

function TBBotCreatures.RawFind(APred: BUnaryFunc<TBBotCreature, BBool>): TBBotCreature;
var
  P: BVector<BPair<BBool, TBBotCreature>>.It;
begin
  P := CreatureList.Find('Creatures - rawFind',
    function(It: TCreatureIter): BBool
    begin
      Result := False;
      if It^.Second.ID <> 0 then
        if APred(It^.Second) then
          Exit(True);
    end);
  if P <> nil then
    Exit(P^.Second);
  Exit(nil);
end;

procedure TBBotCreatures.RawTraverse(AIter: BUnaryProc<TBBotCreature>);
begin
  CreatureList.ForEach(
    procedure(It: TCreatureIter)
    begin
      if It^.Second.ID <> 0 then
        AIter(It^.Second);
    end);
end;

procedure TBBotCreatures.Validate;
begin
  FPlayer := nil;
  FTarget := nil;
  CreatureList.ForEach(
    procedure(It: TCreatureIter)
    begin
      It^.First := False;
      if It^.Second.IsSelf and It^.Second.IsVisible and It^.Second.IsAlive then begin
        It^.First := True;
        FPlayer := It^.Second;
      end;
    end);
  if FPlayer <> nil then
    CreatureList.ForEach(
      procedure(It: TCreatureIter)
      begin
        if (It^.Second.ID <> 0) and TibiaInScreen(FPlayer.Position, It^.Second.Position, True) then begin
          It^.First := True;
          if It^.Second.IsTarget and It^.Second.IsAlive then
            FTarget := It^.Second;
        end;
      end);
end;

end.
