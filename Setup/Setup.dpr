program Setup;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IOUtils,
  RegularExpressions,
  Zip;

type
  TZip = class(TZipFile)
  public
    constructor Create(const AFileName: TFileName); reintroduce;
    procedure AddDir(const ADir: string); inline;
    procedure AddFile(const AFileName: TFileName); inline;
  end;

constructor TZip.Create(const AFileName: TFileName);
begin
  inherited Create;
  if TFile.Exists(AFileName) then
    TFile.Delete(AFileName);
  Self.Open(AFileName, zmWrite);
end;

procedure TZip.AddDir(const ADir: string);
begin
  for var VFile in TDirectory.GetFiles(ADir, '*',
    TSearchOption.soAllDirectories) do
    Self.Add(VFile, VFile.Substring(IncludeTrailingPathDelimiter(ADir).Length,
      VFile.Length).Replace('\', '/', [rfReplaceAll]));
end;

procedure TZip.AddFile(const AFileName: TFileName);
begin
  Self.Add(AFileName, TPath.GetFileName(AFileName));
end;

function GetVersion: string; inline;
begin
  Result := TRegEx.Match(TFile.ReadAllText('..\Source\uTibiaDeclarations.pas'),
    'BotVer: BStr = ''(\d{0,2}\.\d{0,2})''').Value.Substring(15).DeQuotedString;
end;

function GetOutputName(const ADir: string): string; inline;
begin
  Result := TPath.Combine(ADir, Concat('BBot-', GetVersion, '.zip'));
end;

begin
  with TZip.Create(GetOutputName('..\Output')) do
  try
    AddDir('..\Contrib\Dist');
    AddFile('..\Output\BDll.dll');
    AddFile('..\Output\BMega.exe');
  finally
    Destroy;
  end;
end.
