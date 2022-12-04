unit uMCEditor;

interface

uses
  uBTypes,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Vcl.Menus,
  uBBotClientTools;

type
  TfrmMC = class(TForm)
    lstClients: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtClientName: TEdit;
    edtClientFile: TEdit;
    btnAdd: TButton;
    edtClientParam: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    btnFile: TButton;
    Label6: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    chkOTServer: TCheckBox;
    edtClientIP: TEdit;
    Label7: TLabel;
    cmbVersion: TComboBox;
    Label9: TLabel;
    Label11: TLabel;
    procedure edtClientNameChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lstClientsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstClientsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFileClick(Sender: TObject);
    procedure lstClientsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstClientsDblClick(Sender: TObject);
    procedure chkOTServerClick(Sender: TObject);
    procedure cmbVersionDropDown(Sender: TObject);
  private
    ClientTools: TBBotClientTools;
    { Private declarations }
  public
    procedure UpdateList;
    { Public declarations }
  end;

implementation

uses
  Declaracoes,
  uTibiaDeclarations,
  uTibiaState;

{$R *.dfm}

procedure TfrmMC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientTools.Free;
end;

procedure TfrmMC.FormCreate(Sender: TObject);
begin
  ClientTools := TBBotClientTools.Create;
  UpdateList;
end;

procedure TfrmMC.edtClientNameChange(Sender: TObject);
begin
  if Length(edtClientName.Text) < 2 then
    edtClientName.Color := clRed
  else
    edtClientName.Color := clWindow;
  if (Length(edtClientFile.Text) < 2) or (not FileExists(edtClientFile.Text))
  then
    edtClientFile.Color := clRed
  else
    edtClientFile.Color := clWindow;
  btnAdd.Enabled := (edtClientFile.Color = clWindow) and
    (edtClientName.Color = clWindow);
end;

procedure TfrmMC.btnAddClick(Sender: TObject);
begin
  ClientTools.SaveClient(edtClientName.Text, edtClientFile.Text,
    edtClientParam.Text, edtClientIP.Text, cmbVersion.Text);
  UpdateList;
end;

procedure TfrmMC.lstClientsDblClick(Sender: TObject);
var
  Client: TBBotClients.It;
begin
  if lstClients.ItemIndex <> -1 then
  begin
    Client := ClientTools.Client
      (BStrLeft(lstClients.Items.Strings[lstClients.ItemIndex], '@@'));
    if Client <> nil then
      Client^.Launch;
  end;
end;

procedure TfrmMC.lstClientsDrawItem(Control: TWinControl; Index: BInt32;
  Rect: TRect; State: TOwnerDrawState);
var
  A, B, T: BStr;
begin
  T := lstClients.Items.Strings[Index];
  if not BStrSplit(lstClients.Items.Strings[Index], '@@', A, B) then
  begin
    A := T;
    B := '';
  end;
  BListDrawItem(lstClients.Canvas, Index, odSelected in State, Rect, A, B);
end;

procedure TfrmMC.lstClientsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    if lstClients.ItemIndex <> -1 then
    begin
      ClientTools.RemoveClient
        (BStrLeft(lstClients.Items.Strings[lstClients.ItemIndex], '@@'));
      UpdateList;
    end;
end;

procedure TfrmMC.UpdateList;
begin
  lstClients.Items.Clear;
  ClientTools.Clients.ForEach(
    procedure(It: TBBotClients.It)
    begin
      lstClients.Items.Add(It^.Name + '@@ [' + It^.Version + '] ' + It^.IP)
    end);
end;

procedure TfrmMC.btnFileClick(Sender: TObject);
begin
  edtClientFile.Text := FileDialog('Select a client', 'Tibia Client|*.exe',
    'load', nil);
end;

procedure TfrmMC.chkOTServerClick(Sender: TObject);
begin
  edtClientIP.Enabled := chkOTServer.Checked;
  if not chkOTServer.Checked then
    edtClientIP.Text := '';
end;

procedure TfrmMC.cmbVersionDropDown(Sender: TObject);
var
  V: TTibiaVersion;
  S: BStr;
begin
  S := cmbVersion.Text;
  cmbVersion.Clear;
  cmbVersion.AddItem('Auto', nil);
  for V := TibiaVerFirst to TibiaVerLast do
    cmbVersion.AddItem(BotVerSupported[V], nil);
  if cmbVersion.Items.IndexOf(S) <> -1 then
    cmbVersion.ItemIndex := cmbVersion.Items.IndexOf(S);
end;

procedure TfrmMC.lstClientsClick(Sender: TObject);
var
  C: TBBotClients.It;
begin
  if lstClients.ItemIndex <> -1 then
  begin
    C := ClientTools.Client
      (BStrLeft(lstClients.Items.Strings[lstClients.ItemIndex], '@@'));
    if C <> nil then
    begin
      edtClientName.Text := C^.Name;
      edtClientFile.Text := C^.FileName;
      edtClientParam.Text := C^.Param;
      edtClientIP.Text := C^.IP;
      cmbVersion.Text := C^.Version;
      chkOTServer.Checked := C^.IP <> '';
    end;
  end;
end;

end.

