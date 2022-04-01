object LooterFrame: TLooterFrame
  Left = 0
  Top = 0
  Width = 919
  Height = 390
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object IgnoreCorpsesGroup: TPanel
    Left = 614
    Top = 0
    Width = 296
    Height = 380
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object Label1: TLabel
      Left = 4
      Top = 6
      Width = 131
      Height = 13
      Caption = 'Ignore creature corpse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object OpenCorpsesIgnoreCreatures: TListBox
      Tag = 1
      Left = 4
      Top = 25
      Width = 290
      Height = 271
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDrawItem = OpenCorpsesIgnoreCreaturesDrawItem
      OnKeyDown = OpenCorpsesIgnoreCreaturesKeyDown
    end
    object OpenCorpsesIgnoreAdd: TEdit
      Left = 5
      Top = 302
      Width = 205
      Height = 22
      TabOrder = 1
      Text = 'Ghost'
    end
    object OpenCorpsesIgnoreAddButton: TButton
      Left = 216
      Top = 302
      Width = 78
      Height = 22
      Caption = 'Ignore'
      TabOrder = 2
      OnClick = OpenCorpsesIgnoreAddButtonClick
    end
    object GoBackIgnoreCorpses: TButton
      Left = 103
      Top = 328
      Width = 91
      Height = 39
      Caption = 'Back'
      TabOrder = 3
      OnClick = GoBackIgnoreCorpsesClick
    end
  end
  object SkinnerGroup: TPanel
    Left = 305
    Top = 3
    Width = 296
    Height = 380
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object Label6: TLabel
      Left = 4
      Top = 6
      Width = 127
      Height = 13
      Caption = 'Skinner configurations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SkinnerCombo: TComboBox
      Left = 4
      Top = 302
      Width = 218
      Height = 22
      Style = csOwnerDrawFixed
      TabOrder = 0
      OnDrawItem = SkinnerComboDrawItem
      OnDropDown = SkinnerComboDropDown
    end
    object SkinnerAdd: TButton
      Left = 228
      Top = 302
      Width = 66
      Height = 22
      Caption = 'Skin'
      TabOrder = 1
      OnClick = SkinnerAddClick
    end
    object SkinnerList: TListBox
      Tag = 1
      Left = 4
      Top = 25
      Width = 290
      Height = 271
      Style = lbOwnerDrawVariable
      TabOrder = 2
      OnDrawItem = SkinnerListDrawItem
      OnKeyDown = SkinnerListKeyDown
    end
    object GoBackSkinner: TButton
      Left = 103
      Top = 328
      Width = 91
      Height = 39
      Caption = 'Back'
      TabOrder = 3
      OnClick = GoBackSkinnerClick
    end
  end
  object LooterGroup: TPanel
    Left = 3
    Top = 3
    Width = 296
    Height = 374
    BevelOuter = bvNone
    TabOrder = 2
    object Label4: TLabel
      Left = 4
      Top = 6
      Width = 77
      Height = 13
      Caption = 'Open Corpses'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GoIgnoreCorpses: TLabel
      Left = 14
      Top = 50
      Width = 155
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'Ignore Corpses (e.g: Ghost)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = GoIgnoreCorpsesClick
    end
    object GoSkinner: TLabel
      Left = 14
      Top = 94
      Width = 199
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'Configure creatures (e.g: Minotaur)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = GoSkinnerClick
    end
    object Label2: TLabel
      Left = 4
      Top = 111
      Width = 37
      Height = 13
      Caption = 'Looter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object chkLOpen: TCheckBox
      Tag = 1
      Left = 4
      Top = 23
      Width = 102
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Open Corpses'
      TabOrder = 0
      OnClick = ApplySettings
    end
    object SkinCorpses: TCheckBox
      Tag = 1
      Left = 4
      Top = 67
      Width = 115
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Skinning'
      TabOrder = 1
      OnClick = ApplySettings
    end
    object cmbLooterPrio: TComboBox
      Tag = 1
      Left = 14
      Top = 215
      Width = 272
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Loot before kill'
      OnChange = ApplySettings
      Items.Strings = (
        'Loot before kill'
        'Loot after kill')
    end
    object chkLLooter: TCheckBox
      Tag = 1
      Left = 14
      Top = 128
      Width = 58
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Loot'
      TabOrder = 3
      OnClick = ApplySettings
    end
    object chkLEat: TCheckBox
      Tag = 1
      Left = 14
      Top = 157
      Width = 154
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Eat Food from Corpses'
      TabOrder = 4
      OnClick = ApplySettings
    end
    object chkRustyRemover: TCheckBox
      Tag = 1
      Left = 14
      Top = 186
      Width = 154
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Rust Remover'
      TabOrder = 5
      OnClick = ApplySettings
    end
    object btnOpenLootlist: TButton
      Left = 4
      Top = 332
      Width = 274
      Height = 35
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Configure Lootable Items'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = btnOpenLootlistClick
    end
    object edtLooterRare: TMemo
      Tag = 1
      Left = 14
      Top = 269
      Width = 274
      Height = 59
      Lines.Strings = (
        'magic plate armor'
        'mastermind shield, demon shield'
        'golden legs')
      TabOrder = 7
    end
    object chkLooterRare: TCheckBox
      Tag = 1
      Left = 14
      Top = 240
      Width = 100
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Rare Loot alarm'
      TabOrder = 8
      OnClick = ApplySettings
    end
  end
end
