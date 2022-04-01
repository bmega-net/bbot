unit uMacrosFrame;

interface

uses
  uBTypes,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Menus;

type
  TMacrosFrame = class(TFrame)
    Label16: TLabel;
    lstMacros: TListBox;
    chkMacroAutos: TCheckBox;
    GoToVariables: TLabel;
    CreateMacroButton: TButton;
    Label1: TLabel;
    popMacro: TPopupMenu;
    RemoveSelected1: TMenuItem;
    N6: TMenuItem;
    Debug1: TMenuItem;
    Edit2: TMenuItem;
    N4: TMenuItem;
    CopyMacro1: TMenuItem;
    CopyCodes2: TMenuItem;
    PasteCodes3: TMenuItem;
    Favorites: TListBox;
    N1: TMenuItem;
    Addto1: TMenuItem;
    procedure CopyCodes2Click(Sender: TObject);
    procedure CopyMacro1Click(Sender: TObject);
    procedure lstMacrosDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure PasteCodes3Click(Sender: TObject);
    procedure RemoveSelected1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure ApplySettings(Sender: TObject);
    procedure CreateMacroButtonClick(Sender: TObject);
    procedure GoToVariablesClick(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure Addto1Click(Sender: TObject);
    procedure FavoritesDblClick(Sender: TObject);
    procedure FavoritesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure popMacroPopup(Sender: TObject);
    procedure lstMacrosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    FMain: TForm;
    NextLoad: BUInt32;
    function selectedPopupList: TListBox;
    function selectedPopupItem: BStr;
    procedure init;
    procedure SaveMacro(AToList: TListBox; ACode: BStr); overload;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetMacros();
    procedure SaveMacro(ACode: BStr); overload;
    procedure TimerMacros();
    procedure ReloadFavorites();
    procedure SaveFavorites();
  end;

implementation

{$R *.dfm}

uses
  uMain,
  Declaracoes,
  BBotEngine;

const
  MacroFavoritesUpdateDelay = 6000;
  MacroFavoritesFile = './Data/BBot.FavoriteMacros.txt';

procedure TMacrosFrame.CopyMacro1Click(Sender: TObject);
var
  Selected: BStr;
begin
  Selected := selectedPopupItem;
  if Selected <> '' then
    TFMain(FMain).SetClipboard(Selected);
end;

constructor TMacrosFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  init;
end;

procedure TMacrosFrame.Edit2Click(Sender: TObject);
var
  Selected: BStr;
begin
  Selected := selectedPopupItem;
  if Selected <> '' then begin
    TFMain(FMain).MacroEditorLoad(Selected);
    TFMain(FMain).ShowGroupBox(TFMain(FMain).gbMacroEditor);
  end;
end;

procedure TMacrosFrame.FavoritesDblClick(Sender: TObject);
begin
  if Favorites.ItemIndex <> -1 then begin
    SaveMacro(Favorites.Items.Strings[Favorites.ItemIndex]);
    SetMacros;
  end;
end;

procedure TMacrosFrame.FavoritesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
  SaveFavorites;
end;

procedure TMacrosFrame.GoToVariablesClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbVariables);
end;

procedure TMacrosFrame.init;
begin
  NextLoad := 0;
end;

procedure TMacrosFrame.lstMacrosDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
  Delay: BInt32;
  lst: TListBox;
begin
  lst := TListBox(Control);
  Delay := BStrTo32(BStrLeft(lst.Items[Index], ' '), 0);
  A := BStrBetween(lst.Items[Index], '{', '}');
  if Delay = 0 then
    B := 'Manual'
  else if Delay = 1 then
    B := 'Once'
  else
    B := 'Auto every ' + BToStr(Delay) + 'ms';
  BListDrawItem(lst.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TMacrosFrame.lstMacrosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BListboxKeyDown(Sender, Key, Shift);
  SetMacros;
end;

procedure TMacrosFrame.N6Click(Sender: TObject);
var
  Selected: BStr;
begin
  Selected := selectedPopupItem;
  if Selected <> '' then
    BBot.Macros.DebugExecute(Selected);
end;

procedure TMacrosFrame.PasteCodes3Click(Sender: TObject);
var
  I: BInt32;
  Res: BStrArray;
  List: TListBox;
begin
  List := selectedPopupList;
  BStrSplit(Res, #13#10, TFMain(FMain).GetClipboard);
  for I := 0 to High(Res) do
    if BTrim(Res[I]) <> '' then
      SaveMacro(List, Res[I]);
  if List = Favorites then
    SaveFavorites
  else
    SetMacros;
end;

procedure TMacrosFrame.popMacroPopup(Sender: TObject);
begin
  if selectedPopupList = Favorites then
    Addto1.Caption := 'Add to macros'
  else
    Addto1.Caption := 'Add to favorites';
end;

function TMacrosFrame.selectedPopupList: TListBox;
begin
  Result := TListBox(popMacro.PopupComponent);
end;

function TMacrosFrame.selectedPopupItem: BStr;
var
  Index: BInt32;
begin
  Index := selectedPopupList.ItemIndex;
  if Index <> -1 then
    Exit(BTrim(selectedPopupList.Items.Strings[Index]));
  Exit('');
end;

procedure TMacrosFrame.ReloadFavorites;
var
  Buffer: BStr;
  I: BInt32;
  Favorited: BStrArray;
begin
  Favorites.Items.BeginUpdate;
  try
    Favorites.Items.Clear;
    Buffer := BFileGet(MacroFavoritesFile);
    if BStrSplit(Favorited, BStrLine, Buffer) > 0 then
      for I := 0 to High(Favorited) do
        if BTrim(Favorited[I]) <> '' then
          Favorites.AddItem(Favorited[I], nil);
  finally Favorites.Items.EndUpdate;
  end;
end;

procedure TMacrosFrame.SaveFavorites;
var
  Buffer: BStr;
  I: BInt32;
begin
  Buffer := '';
  for I := 0 to Favorites.Items.Count - 1 do
    Buffer := Buffer + Favorites.Items.Strings[I] + BStrLine;
  BFilePut(MacroFavoritesFile, Buffer);
  ReloadFavorites;
end;

procedure TMacrosFrame.SaveMacro(AToList: TListBox; ACode: BStr);
var
  Name: BStr;
  MacroName: BStr;
  Count: BInt32;
begin
  Name := BTrim(BStrBetween(ACode, '{', '}'));
  for Count := 0 to AToList.Items.Count - 1 do begin
    MacroName := BTrim(BStrBetween(AToList.Items[Count], '{', '}'));
    if BStrEqual(MacroName, Name) then begin
      AToList.Items[Count] := ACode;
      Exit;
    end;
  end;
  AToList.AddItem(ACode, nil);
end;

procedure TMacrosFrame.RemoveSelected1Click(Sender: TObject);
begin
  if selectedPopupList.ItemIndex <> -1 then
    selectedPopupList.Items.Delete(selectedPopupList.ItemIndex);
  if selectedPopupList = Favorites then
    SaveFavorites
  else
    SetMacros;
end;

procedure TMacrosFrame.SaveMacro(ACode: BStr);
begin
  SaveMacro(lstMacros, ACode);
end;

procedure TMacrosFrame.SetMacros;
var
  I: BInt32;
begin
  if TFMain(FMain).MutexAcquire then begin
    BBot.Macros.ClearMacros;
    for I := 0 to lstMacros.Count - 1 do
      BBot.Macros.AddMacro(lstMacros.Items.Strings[I]);
    BBot.Macros.AutoExecute := chkMacroAutos.Checked;
    TFMain(FMain).MutexRelease;
  end;
end;

procedure TMacrosFrame.TimerMacros;
begin
  if NextLoad < Tick then begin
    if not Favorites.Focused then begin
      NextLoad := Tick + MacroFavoritesUpdateDelay;
      ReloadFavorites;
    end;
  end;
end;

procedure TMacrosFrame.Addto1Click(Sender: TObject);
begin
  if selectedPopupItem <> '' then
    if selectedPopupList = Favorites then begin
      SaveMacro(lstMacros, selectedPopupItem);
      SetMacros;
    end else begin
      SaveMacro(Favorites, selectedPopupItem);
      SaveFavorites;
    end;
end;

procedure TMacrosFrame.ApplySettings(Sender: TObject);
begin
  SetMacros;
end;

procedure TMacrosFrame.CreateMacroButtonClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBox(TFMain(FMain).gbMacroEditor);
end;

procedure TMacrosFrame.Debug1Click(Sender: TObject);
var
  Selected: BStr;
begin
  Selected := selectedPopupItem;
  if Selected <> '' then
    BBot.Macros.DebugExecute(Selected);
end;

procedure TMacrosFrame.CopyCodes2Click(Sender: TObject);
var
  I: BInt32;
  S: BStr;
  lst: TListBox;
begin
  lst := selectedPopupList;
  S := '';
  for I := 0 to lst.Items.Count - 1 do
    S := S + lst.Items[I] + #13#10;
  TFMain(FMain).SetClipboard(S);
end;

end.
