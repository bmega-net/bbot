object MacrosFrame: TMacrosFrame
  Left = 0
  Top = 0
  Width = 713
  Height = 506
  Color = 16772841
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Label16: TLabel
    Left = 8
    Top = 4
    Width = 41
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Macros'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GoToVariables: TLabel
    Left = 42
    Top = 483
    Width = 52
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Variables'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = GoToVariablesClick
  end
  object Label1: TLabel
    Left = 363
    Top = 4
    Width = 53
    Height = 13
    Caption = 'Favorites'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lstMacros: TListBox
    Tag = 1
    Left = 2
    Top = 21
    Width = 351
    Height = 431
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = lbOwnerDrawVariable
    ItemHeight = 18
    PopupMenu = popMacro
    TabOrder = 0
    OnDrawItem = lstMacrosDrawItem
    OnKeyDown = lstMacrosKeyDown
  end
  object chkMacroAutos: TCheckBox
    Tag = 1
    Left = 8
    Top = 458
    Width = 124
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Auto Macros enabled'
    TabOrder = 1
    OnClick = ApplySettings
  end
  object CreateMacroButton: TButton
    Left = 199
    Top = 456
    Width = 149
    Height = 42
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Create new Macro'
    TabOrder = 2
    OnClick = CreateMacroButtonClick
  end
  object Favorites: TListBox
    Left = 358
    Top = 21
    Width = 351
    Height = 431
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = lbOwnerDrawVariable
    ItemHeight = 18
    PopupMenu = popMacro
    TabOrder = 3
    OnDblClick = FavoritesDblClick
    OnDrawItem = lstMacrosDrawItem
    OnKeyDown = FavoritesKeyDown
  end
  object popMacro: TPopupMenu
    OnPopup = popMacroPopup
    Left = 334
    Top = 130
    object RemoveSelected1: TMenuItem
      Caption = 'Remove Selected'
      OnClick = RemoveSelected1Click
    end
    object N6: TMenuItem
      Caption = '-'
      OnClick = N6Click
    end
    object Debug1: TMenuItem
      Caption = 'Debug'
      OnClick = Debug1Click
    end
    object Edit2: TMenuItem
      Caption = 'Edit'
      OnClick = Edit2Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object CopyMacro1: TMenuItem
      Caption = 'Copy Selected'
      OnClick = CopyMacro1Click
    end
    object CopyCodes2: TMenuItem
      Caption = 'Copy All'
      OnClick = CopyCodes2Click
    end
    object PasteCodes3: TMenuItem
      Caption = 'Paste'
      OnClick = PasteCodes3Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Addto1: TMenuItem
      Caption = 'Add to ???'
      OnClick = Addto1Click
    end
  end
end
