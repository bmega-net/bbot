object SpecialSQMsFrame: TSpecialSQMsFrame
  Left = 0
  Top = 0
  Width = 287
  Height = 512
  Color = 16772841
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Label160: TLabel
    Left = 68
    Top = 343
    Width = 61
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Shift+Delete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label91: TLabel
    Left = 131
    Top = 343
    Width = 96
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'delete selected item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
  end
  object Label49: TLabel
    Left = 8
    Top = 386
    Width = 94
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'New Special SQM'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label161: TLabel
    Left = 8
    Top = 422
    Width = 20
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Kind'
  end
  object Label162: TLabel
    Left = 8
    Top = 464
    Width = 31
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Range'
  end
  object lstSpecialSQMs: TListBox
    Tag = 1
    Left = 8
    Top = 9
    Width = 272
    Height = 331
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = lbOwnerDrawVariable
    ItemHeight = 18
    TabOrder = 0
    OnDrawItem = lstSpecialSQMsDrawItem
    OnKeyDown = lstSpecialSQMsKeyDown
  end
  object SpecialSQMsShow: TCheckBox
    Tag = 1
    Left = 8
    Top = 359
    Width = 193
    Height = 23
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Show special SQMs HUD'
    TabOrder = 1
    OnClick = ApplySettings
  end
  object SpecialSQMsKind: TComboBox
    Left = 8
    Top = 439
    Width = 249
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'Avoid'
    Items.Strings = (
      'Avoid'
      'Like'
      'Attacking Avoid'
      'Attacking Like'
      'Block'
      'Area Spells Avoid')
  end
  object SpecialSQMsRange: TComboBox
    Left = 8
    Top = 481
    Width = 156
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = '1 sqm'
    Items.Strings = (
      '1 sqm'
      '3x3 sqms'
      '5x5 sqms'
      '7x7 sqms')
  end
  object SpecialSQMsAdd: TButton
    Left = 168
    Top = 464
    Width = 89
    Height = 39
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Add'
    TabOrder = 4
    OnClick = SpecialSQMsAddClick
  end
  object SpecialSQMsEditorHUD: TCheckBox
    Tag = 1
    Left = 8
    Top = 401
    Width = 156
    Height = 23
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Show editor HUD'
    TabOrder = 5
    OnClick = ApplySettings
  end
end
