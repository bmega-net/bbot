object VariablesFrame: TVariablesFrame
  Left = 0
  Top = 0
  Width = 811
  Height = 638
  Color = 16772841
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Label138: TLabel
    Left = 6
    Top = 6
    Width = 52
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Variables'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label139: TLabel
    Left = 425
    Top = 6
    Width = 31
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'State'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 652
    Top = 4
    Width = 24
    Height = 13
    Caption = 'Filter'
  end
  object ApplyVariablesButton: TButton
    Left = 116
    Top = 584
    Width = 190
    Height = 39
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Apply'
    TabOrder = 0
    OnClick = ApplyVariablesButtonClick
  end
  object BackButton: TButton
    Left = 515
    Top = 587
    Width = 190
    Height = 39
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Back'
    TabOrder = 1
    OnClick = BackButtonClick
  end
  object VariableStates: TListBox
    Left = 425
    Top = 23
    Width = 377
    Height = 560
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = lbOwnerDrawVariable
    ItemHeight = 18
    TabOrder = 2
    OnDblClick = VariableDoubleClick
    OnDrawItem = VariableDrawItem
  end
  object VariablesEditor: TMemo
    Tag = 1
    Left = 6
    Top = 22
    Width = 411
    Height = 558
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Lines.Strings = (
      '# Available on FullCheck/Macros'
      '# This is a comment'
      'One=1')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object FilterVariables: TEdit
    Left = 680
    Top = 1
    Width = 121
    Height = 21
    TabOrder = 4
  end
end
