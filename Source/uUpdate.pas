unit uUpdate;

interface

uses
  uBTypes;

function BBHasUpdate: BBool;
procedure BBApplyUpdate(Data: BStr);
procedure BBExecUpdater;
procedure BBClearUpdate;

implementation

uses
  BBotEngine,
  Windows,
  Forms,
  SysUtils,
  Declaracoes,
  SevenZipVCL;

const
  UpdateFile = 'Data/Update.7z';
  UpdateExe = 'Update.exe';

function BBHasUpdate: BBool;
begin
  Result := BFileExists(UpdateFile);
end;

procedure BBApplyUpdate(Data: BStr);
var
  ExeFrom, ExeTo: String;
begin
  BFilePut(UpdateFile, Data);
  ExeFrom := Application.ExeName;
  ExeTo := ExtractFilePath(Application.ExeName) + UpdateExe;
  CopyFile(@ExeFrom[1], @ExeTo[1], False);
  ExecNewProcess(UpdateExe + ' update');
  Halt(0);
end;

procedure BBExecUpdater;
const
  DeleteList: array [0 .. 1] of BStr = ('BMega.exe', 'BDll.dll');
var
  Z: TSevenZip;
  I: BInt32;
begin
  I := 0;
  while I <= High(DeleteList) do
    if BFileExists(DeleteList[I]) then
      BFileDelete(DeleteList[I])
    else
      Inc(I);
  Z := TSevenZip.Create(nil);
  Z.ExtrBaseDir := ExtractFilePath(Application.ExeName);
  Z.ExtractOptions := Z.ExtractOptions + [ExtractOverwrite];
  Z.SZFileName := BotPath + UpdateFile;
  Z.Extract();
  Z.Free;
  BFileDelete(UpdateFile);
  ExecNewProcess(ExtractFilePath(Application.ExeName) + 'BMega.exe');
  Halt(0);
end;

procedure BBClearUpdate;
begin
  if BFileExists(UpdateExe) then
    BFileDelete(UpdateExe);
end;

end.
