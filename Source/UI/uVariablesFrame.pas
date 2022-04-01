unit uVariablesFrame;

interface

uses
  uBTypes,
  uBVector,
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
  BBotEngine;

type
  TVariablesFrame = class(TFrame)
    ApplyVariablesButton: TButton;
    BackButton: TButton;
    Label138: TLabel;
    Label139: TLabel;
    VariableStates: TListBox;
    VariablesEditor: TMemo;
    FilterVariables: TEdit;
    Label1: TLabel;
    procedure ApplyVariablesButtonClick(Sender: TObject);
    procedure VariableDoubleClick(Sender: TObject);
    procedure VariableDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure BackButtonClick(Sender: TObject);
  protected
    FMain: TForm;
    procedure init;
    procedure updateLists;
  public
    constructor Create(AOwner: TComponent); override;

    procedure timerVariables;
    procedure applyVariables;
  end;

implementation

{$R *.dfm}

uses
  Declaracoes,
  uMain,

  uMacroVariable;

procedure TVariablesFrame.applyVariables;
var
  I: BInt32;
  S, N, V: BStr;
  Vaar: BMacroVariable;
begin
  for I := 0 to VariablesEditor.Lines.Count - 1 do begin
    S := VariablesEditor.Lines.Strings[I];
    if BStrPos('#', S) > 0 then
      S := BStrLeft(S, '#');
    S := Trim(S);
    if Length(S) > 0 then
    begin
      BStrSplit(S, '=', N, V);
      N := Trim(N);
      V := Trim(V);
      Vaar := BBot.Macros.Registry.Variables[N];
      if BStrIsNumber(V) then
        Vaar.Value := BStrTo32(V, 0)
      else
        Vaar.ValueStr := V;
    end;
  end;
  updateLists;
end;

procedure TVariablesFrame.ApplyVariablesButtonClick(Sender: TObject);
begin
  applyVariables;
end;

procedure TVariablesFrame.BackButtonClick(Sender: TObject);
begin
  TFMain(FMain).ShowGroupBoxLast;
end;

constructor TVariablesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  init;
end;

procedure TVariablesFrame.init;
begin
end;

procedure TVariablesFrame.timerVariables;
begin
  updateLists;
end;

procedure TVariablesFrame.updateLists;
var
  Variables: BVector<BStr>;
begin
  Variables := nil;
  try
    Variables := BBot.Macros.VarsList();
    BListUpdate(VariableStates, procedure
    var
      Index: BInt32;
      It: BVectorIterator<BStr>;
      S: BStr;
      FilteringV: BStr;
    begin
      FilteringV := BStrLower(FilterVariables.Text);
      It := Variables.Iter.Filter(function(AIt: BInt32): BBool
      var
        AItS: BStr;
        Kept: BBool;
      begin
        if FilteringV = '' then
          Exit(True);
        AItS := Variables.Item[AIt]^;
        Kept := BStrPos(FilteringV, BStrLower(AItS)) > 0;
        Exit(Kept);
      end);
      Index := -1;
      while It.HasNext do begin
        Inc(Index);
        S := It.Next;
        if Index < VariableStates.Items.Count then begin
          if VariableStates.Items[Index] <> S then
            VariableStates.Items[Index] := S;
        end else begin
          VariableStates.Items.Add(S);
        end;
      end;
      while (Index + 1) < VariableStates.Items.Count do
        VariableStates.Items.Delete(Index + 1);
    end);
  finally
    if Variables <> nil then
      Variables.Free;
  end;
end;

procedure TVariablesFrame.VariableDoubleClick(Sender: TObject);
var
  List: TListBox;
begin
  List := TListBox(Sender);
  if List.ItemIndex <> -1 then
    VariablesEditor.Lines.Add(List.Items.Strings[List.ItemIndex]);
end;

procedure TVariablesFrame.VariableDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  A, B: BStr;
  List: TListBox;
begin
  List := TListBox(Control);
  BStrSplit(List.Items[Index], '=', A, B);
  BListDrawItem(List.Canvas, Index, odSelected in State, Rect, A, B);
end;

end.
