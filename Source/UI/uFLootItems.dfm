object FLootItems: TFLootItems
  Left = 471
  Top = 330
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Loot Items'
  ClientHeight = 382
  ClientWidth = 726
  Color = 16707048
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 328
    Top = 336
    Width = 33
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Loot to'
  end
  object Label1: TLabel
    Left = 5
    Top = 2
    Width = 67
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Not Looting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 323
    Top = 2
    Width = 43
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Looting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 323
    Top = 362
    Width = 38
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Min cap'
  end
  object txtSearch: TEdit
    Left = 5
    Top = 333
    Width = 241
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 9868950
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = 'Search....'
    OnEnter = txtSearchEnter
    OnExit = txtSearchExit
    OnKeyDown = txtSearchKeyDown
  end
  object lstLoot: TListView
    Left = 323
    Top = 18
    Width = 393
    Height = 306
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Columns = <
      item
        Caption = 'Name'
        Width = 141
      end
      item
        Caption = 'To'
        Width = 30
      end
      item
        Caption = 'Drop'
        Width = 33
      end
      item
        Caption = 'Deposit'
        Width = 33
      end
      item
        Caption = 'Min Cap'
        Width = 41
      end
      item
        Caption = 'ID'
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = lstLootAdvancedCustomDrawItem
    OnAdvancedCustomDrawSubItem = lstLootAdvancedCustomDrawSubItem
  end
  object Button1: TButton
    Left = 249
    Top = 236
    Width = 70
    Height = 71
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Done'
    TabOrder = 1
    OnClick = Button1Click
  end
  object lstItems: TListView
    Left = 5
    Top = 19
    Width = 241
    Height = 307
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Columns = <
      item
        Caption = 'Name'
        Width = 167
      end
      item
        Caption = 'ID'
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    GridLines = True
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SortType = stText
    TabOrder = 2
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = lstItemsAdvancedCustomDrawItem
    OnAdvancedCustomDrawSubItem = lstItemsAdvancedCustomDrawSubItem
  end
  object MovLoot: TButton
    Left = 249
    Top = 53
    Width = 70
    Height = 71
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '==>'
    TabOrder = 3
    OnClick = MovLootClick
  end
  object MovNLoot: TButton
    Left = 249
    Top = 128
    Width = 70
    Height = 71
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '<=='
    TabOrder = 4
    OnClick = MovNLootClick
  end
  object cmbSetBP: TComboBox
    Left = 366
    Top = 333
    Width = 122
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = csDropDownList
    TabOrder = 6
    OnDropDown = cmbSetBPDropDown
    OnSelect = cmbSetBPSelect
  end
  object chkDrop: TCheckBox
    Left = 505
    Top = 358
    Width = 86
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Dropable'
    TabOrder = 7
    OnClick = chkDropClick
  end
  object chkDeposit: TCheckBox
    Left = 505
    Top = 334
    Width = 86
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Depositable'
    TabOrder = 8
    OnClick = chkDepositClick
  end
  object numMinCap: TMemo
    Left = 366
    Top = 357
    Width = 65
    Height = 22
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taCenter
    Lines.Strings = (
      '30')
    MaxLength = 8
    TabOrder = 9
    WantReturns = False
    WordWrap = False
    OnChange = numMinCapChange
    OnKeyPress = numMinCapKeyPress
  end
end
