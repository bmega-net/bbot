unit uBBotSkinner;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  uBVector,
  uBBotSpells,
  Generics.Collections;

type
  TBBotSkinner = class(TBBotAction)
  private type
    TSkinData = record
      Name: BStr;
      ID: BInt32;
      Enabled: BBool;
      WithName: BStr;
      WithID: BInt32;
      MaxDistance: BInt32;
      WaitOpenCorpses: BBool;
      function GetSkinID: BStr;
    end;
  private
    FLastSkin: BPos;
    FLastSkinTry: BInt32;
    Data: BVector<TSkinData>;
    FEnabled: BBool;
    EnableMap: TObjectDictionary<BInt32, BVector<TSkinData>.It>;
    procedure SetLastSkin(const Value: BPos);
    function CheckVersion(const ALine: BStr): BBool;
    function LoadItem(const ALine: BStr): BPair<BInt32, BStr>;
    function GetAvailableSkinnables: BStrArray;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadSkinner;

    procedure SetSkinables(const ACreatures: BStrArray);
    property Enabled: BBool read FEnabled write FEnabled;

    property LastSkin: BPos read FLastSkin write SetLastSkin;
    property LastSkinTry: BInt32 read FLastSkinTry;

    property AvailableSkinnables: BStrArray read GetAvailableSkinnables;

    procedure OnInit; override;
    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTiles,
  System.SysUtils,

  uTibiaState,
  uBBotAddresses;

{ TBBotSkinner }

function TBBotSkinner.CheckVersion(const ALine: BStr): BBool;
var
  VersionName: BStr;
  Version: TTibiaVersion;
begin
  VersionName := BTrim(BStrRight(ALine, '@Version'));
  for Version := TibiaVerFirst to TibiaVerLast do
    if BStrEqual(VersionName, BotVerSupported[Version]) then
      Exit(Version <= AdrSelected);
  raise Exception.Create('Error checking version for BBot.Skinner: ' + ALine +
    ' not found.');
end;

constructor TBBotSkinner.Create;
begin
  inherited Create('Skinner', 500);
  FEnabled := False;
  FLastSkinTry := 0;
  Data := BVector<TSkinData>.Create;
  EnableMap := TObjectDictionary<BInt32, BVector<TSkinData>.It>.Create([]);
end;

destructor TBBotSkinner.Destroy;
begin
  Data.Free;
  EnableMap.Free;
  inherited;
end;

function TBBotSkinner.GetAvailableSkinnables: BStrArray;
var
  Skins: BVector<BStr>;
  I: BInt32;
begin
  Skins := BVector<BStr>.Create;
  Data.ForEach(
    procedure(AIt: BVector<TSkinData>.It)
    begin
      Skins.Add(AIt^.GetSkinID);
    end);
  Skins.Sort(
    function(A, B: BVector<BStr>.It): BInt32
    begin
      Result := BIf(A^ < B^, -1, 1);
    end);

  for I := Skins.Count - 1 downto 1 do
    if Skins.Item[I]^ = Skins.Item[I - 1]^ then
      Skins.Remove(I);

  SetLength(Result, Skins.Count);
  for I := 0 to Skins.Count - 1 do
  begin
    Result[I] := Skins.Item[I]^;
  end;

  Skins.Free;
end;

function TBBotSkinner.LoadItem(const ALine: BStr): BPair<BInt32, BStr>;
var
  ID, Name: BStr;
begin
  if BStrSplit(ALine, '->', Name, ID) then
  begin
    Result.First := BStrTo32(ID);
    Result.Second := Name;
  end
  else
    raise Exception.Create('Error loading BBot.Skinner ID: ' + ALine);
end;

procedure TBBotSkinner.LoadSkinner;
const
  SpellsFile = './Data/BBot.Skinner.txt';
var
  FileHandle: TextFile;
  Line: BStr;
  ValidVersion: BBool;
  Item, SkinWith: BPair<BInt32, BStr>;
  MaxDistance: BInt32;
  WaitOpenCorpses: BBool;
  SkinData: BVector<TSkinData>.It;
begin
  AssignFile(FileHandle, SpellsFile);
  try
    Reset(FileHandle);
    ValidVersion := True;
    WaitOpenCorpses := False;
    MaxDistance := 2;
    while not EOF(FileHandle) do
    begin
      Readln(FileHandle, Line);
      Line := BTrim(Line);
      if Length(Line) > 0 then
      begin
        if BStrStartSensitive(Line, '@With') then
        begin
          ValidVersion := True;
          MaxDistance := 2;
          WaitOpenCorpses := False;
          SkinWith := LoadItem(BStrRight(Line, '@With'));
        end
        else if BStrStartSensitive(Line, '@MaxDistance') then
        begin
          MaxDistance := BStrTo32(BTrim(BStrRight(Line, '@MaxDistance')))
        end
        else if BStrStartSensitive(Line, '@WaitOpenCorpses') then
        begin
          WaitOpenCorpses := True;
        end
        else if BStrStartSensitive(Line, '@Version') then
        begin
          ValidVersion := CheckVersion(Line)
        end
        else if ValidVersion then
        begin
          Item := LoadItem(Line);
          SkinData := Data.Add;
          SkinData^.WithName := SkinWith.Second;
          SkinData^.WithID := SkinWith.First;
          SkinData^.MaxDistance := MaxDistance;
          SkinData^.Name := Item.Second;
          SkinData^.ID := Item.First;
          SkinData^.WaitOpenCorpses := WaitOpenCorpses;
          SkinData^.Enabled := False;
        end;
      end;
    end;
    CloseFile(FileHandle);
  except
    on E: Exception do
      raise BException.Create('Error loading BBot.Skinner:' + BStrLine +
        E.Message);
  end;
end;

procedure TBBotSkinner.OnInit;
begin
  LoadSkinner;
end;

procedure TBBotSkinner.Run;
var
  Map: TTibiaTiles;
begin
  if not Enabled then
    Exit;
  TilesSearch(Map, Me.Position, 5, True,
    function: BBool
    var
      SkinData: BVector<TSkinData>.It;
    begin
      Result := False;
      if (Map.Position <> LastSkin) or (LastSkinTry < 3) then
      begin
        if EnableMap.TryGetValue(Map.ID, SkinData) then
        begin
          if SkinData^.WaitOpenCorpses then
          begin
            if BBot.OpenCorpses.Enabled and BBot.OpenCorpses.HasCorpseOnPosition
              (Map.Position) then
              Exit;
            if BBot.Looter.Enabled and BBot.Looter.IsLooting then
              Exit;
          end;
          if Me.DistanceTo(Map.Position) > SkinData^.MaxDistance then
            Exit;
          Map.UseOn(SkinData.WithID);
          LastSkin := Map.Position;
          Exit(True);
        end;
      end;
    end);
end;

procedure TBBotSkinner.SetLastSkin(const Value: BPos);
begin
  if FLastSkin <> Value then
  begin
    FLastSkin := Value;
    FLastSkinTry := 0;
  end
  else
    Inc(FLastSkinTry);
end;

procedure TBBotSkinner.SetSkinables(const ACreatures: BStrArray);
begin
  EnableMap.Clear;
  Data.ForEach(
    procedure(AIt: BVector<TSkinData>.It)
    var
      I: BInt32;
    begin
      AIt^.Enabled := False;
      for I := 0 to High(ACreatures) do
        if BStrEqual(AIt^.GetSkinID, ACreatures[I]) then
        begin
          AIt^.Enabled := True;
          EnableMap.Add(AIt^.ID, AIt);
        end;
    end);
end;

{ TBBotSkinner.TSkinData }

function TBBotSkinner.TSkinData.GetSkinID: BStr;
begin
  Result := WithName + '@' + Name;
end;

end.

