object frmMC: TfrmMC
  Left = 495
  Top = 291
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Client Tools'
  ClientHeight = 277
  ClientWidth = 514
  Color = 16707048
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000400E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000008
    78000000000000000000887800000008F8780000000000000008F87800000000
    8F87800000000000008F87800000000008F878000000000008F8780000000000
    008F8780000000008F878000000000000008F87800000008F878000000000000
    00008F878000008F8780000000000000000008F8780008F87800000000000000
    0000008F87808F87800000000000000000000008F87808780000000000000000
    000000008F87808000000000000000000000000008F878000000000000000000
    000000008F8F8780000000000000000000000008F878F8780000000000000000
    0000008F87808F878000000000000000000008F8780008F87800000000000030
    00008F878000008F87800000030003B77000F87800000008F87800077B303B30
    00330880000000008F70300003B33F0003F33000000000000803330000B33B00
    3FBB3303000000030033B33000B33F03FBB3033B00000003B33FBB3300B33B08
    7B33003B00000003F303FBB380B33FB08330003B00000003B3003F780BB303BB
    0300003B00000003F3000330BB30003BB00000B0000000003B00000BB3000003
    BBBBBB000000000003FBFBFB3000000033333300000000000033333300000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFE3FFFFC7E0FFFF07E07FFE07F03FFC0FF81FF81FFC0FF03FFE07E07FFF03
    C0FFFF8181FFFFC003FFFFE007FFFFF00FFFFFF81FFFFFF00FFFFFE007FFFFC0
    03FFFF8181FFC703C0E38207E041040FF020181FF8181007E0080007E0000047
    E20000C7E30081C7E381C00FF003E01FF807F03FFC0FFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 314
    Top = 7
    Width = 84
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Register Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 314
    Top = 24
    Width = 28
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Name'
  end
  object Label3: TLabel
    Left = 314
    Top = 68
    Width = 16
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'File'
  end
  object Label4: TLabel
    Left = 314
    Top = 112
    Width = 30
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Param'
  end
  object Label5: TLabel
    Left = 150
    Top = 249
    Width = 31
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Delete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 11
    Top = 249
    Width = 23
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Click'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 36
    Top = 249
    Width = 17
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'edit'
  end
  object Label10: TLabel
    Left = 183
    Top = 249
    Width = 46
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'unregister'
  end
  object Label7: TLabel
    Left = 314
    Top = 203
    Width = 61
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Tibia Version'
  end
  object Label9: TLabel
    Left = 69
    Top = 249
    Width = 34
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'D-Click'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 105
    Top = 249
    Width = 32
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'launch'
  end
  object lstClients: TListBox
    Left = 7
    Top = 7
    Width = 302
    Height = 232
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = lbOwnerDrawVariable
    ItemHeight = 18
    TabOrder = 0
    OnClick = lstClientsClick
    OnDblClick = lstClientsDblClick
    OnDrawItem = lstClientsDrawItem
    OnKeyDown = lstClientsKeyDown
  end
  object edtClientName: TEdit
    Left = 314
    Top = 42
    Width = 197
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Color = clRed
    TabOrder = 1
    OnChange = edtClientNameChange
  end
  object edtClientFile: TEdit
    Left = 314
    Top = 86
    Width = 197
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Color = clRed
    TabOrder = 2
    OnChange = edtClientNameChange
  end
  object btnAdd: TButton
    Left = 347
    Top = 241
    Width = 131
    Height = 31
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Save'
    Enabled = False
    TabOrder = 3
    OnClick = btnAddClick
  end
  object edtClientParam: TEdit
    Left = 314
    Top = 130
    Width = 197
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 4
    OnChange = edtClientNameChange
  end
  object btnFile: TButton
    Left = 478
    Top = 68
    Width = 33
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '...'
    TabOrder = 5
    OnClick = btnFileClick
  end
  object chkOTServer: TCheckBox
    Left = 314
    Top = 156
    Width = 97
    Height = 17
    Caption = 'OTServer IP:'
    TabOrder = 6
    OnClick = chkOTServerClick
  end
  object edtClientIP: TEdit
    Left = 314
    Top = 178
    Width = 197
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    TabOrder = 7
    OnChange = edtClientNameChange
  end
  object cmbVersion: TComboBox
    Left = 314
    Top = 218
    Width = 197
    Height = 21
    TabOrder = 8
    Text = 'Auto'
    OnDropDown = cmbVersionDropDown
  end
end
