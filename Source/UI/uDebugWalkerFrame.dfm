object DebugWalkerFrame: TDebugWalkerFrame
  Left = 0
  Top = 0
  Width = 650
  Height = 617
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object BackBuffer: TImage
    Left = 241
    Top = 54
    Width = 209
    Height = 84
    Visible = False
  end
  object MainBuffer: TImage
    Left = 241
    Top = 144
    Width = 209
    Height = 84
  end
  object ListEvents: TListBox
    Left = 3
    Top = 25
    Width = 222
    Height = 574
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = ListEventsDblClick
    OnKeyDown = ListEventsKeyDown
  end
  object DebugWalkerEnabled: TCheckBox
    Left = 7
    Top = 4
    Width = 97
    Height = 17
    Caption = 'Enable'
    TabOrder = 1
    OnClick = DebugWalkerEnabledClick
  end
  object DebugWalkerFocus: TEdit
    Left = 231
    Top = 3
    Width = 416
    Height = 21
    BevelOuter = bvNone
    Color = clGray
    ReadOnly = True
    TabOrder = 2
    Text = 'Select a walker activity'
  end
end
