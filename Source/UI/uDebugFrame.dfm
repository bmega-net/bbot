object DebugFrame: TDebugFrame
  Left = 0
  Top = 0
  Width = 852
  Height = 790
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object LabelGoProfilers: TLabel
    Left = 30
    Top = 420
    Width = 47
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taCenter
    Caption = 'Profilers'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = LabelGoProfilersClick
  end
  object LabelGoWalkerDebugger: TLabel
    Left = 4
    Top = 437
    Width = 98
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taCenter
    Caption = 'Walker Debugger'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = LabelGoWalkerDebuggerClick
  end
  object CopyMessages: TLabel
    Left = 10
    Top = 772
    Width = 87
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taCenter
    Caption = 'Copy Messages'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = CopyMessagesClick
  end
  object LabelGoPacketView: TLabel
    Left = 5
    Top = 455
    Width = 96
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taCenter
    Caption = 'Packet Visualizer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = LabelGoPacketViewClick
  end
  object chkDbgAttacker: TCheckBox
    Left = 6
    Top = 6
    Width = 97
    Height = 17
    Caption = 'Attacker'
    TabOrder = 0
    OnClick = DebuggerOptions
  end
  object chkDbgCavebot: TCheckBox
    Left = 6
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Cavebot'
    TabOrder = 1
    OnClick = DebuggerOptions
  end
  object chkDbgEvents: TCheckBox
    Left = 6
    Top = 111
    Width = 97
    Height = 17
    Caption = 'Events'
    TabOrder = 2
    OnClick = DebuggerOptions
  end
  object chkDbgEventsAll: TCheckBox
    Left = 17
    Top = 132
    Width = 80
    Height = 17
    Caption = 'All'
    TabOrder = 3
    OnClick = DebuggerOptions
  end
  object chkDbgOpenCorpses: TCheckBox
    Left = 6
    Top = 27
    Width = 97
    Height = 17
    Caption = 'Open Corpses'
    TabOrder = 4
    OnClick = DebuggerOptions
  end
  object chkDbgWalkersState: TCheckBox
    Left = 6
    Top = 69
    Width = 97
    Height = 17
    Caption = 'Walkers State'
    TabOrder = 5
    OnClick = DebuggerOptions
  end
  object DebugTradeWindow: TCheckBox
    Left = 6
    Top = 90
    Width = 97
    Height = 17
    Caption = 'Trade window'
    TabOrder = 6
    OnClick = DebuggerOptions
  end
  object lstDbgEvents: TListBox
    Left = 126
    Top = 5
    Width = 715
    Height = 780
    ItemHeight = 13
    TabOrder = 7
    OnClick = lstDbgEventsClick
  end
  object DebugPositionStatistics: TCheckBox
    Left = 6
    Top = 153
    Width = 107
    Height = 17
    Caption = 'Position Statistics'
    TabOrder = 8
    OnClick = DebuggerOptions
  end
  object DebugPositionStatisticsHUD: TCheckBox
    Left = 17
    Top = 174
    Width = 97
    Height = 17
    Caption = 'HUD'
    TabOrder = 9
    OnClick = DebuggerOptions
  end
  object DebugChannels: TCheckBox
    Left = 6
    Top = 195
    Width = 97
    Height = 17
    Caption = 'Channels'
    TabOrder = 10
    OnClick = DebuggerOptions
  end
  object DebugWaitLockers: TCheckBox
    Left = 6
    Top = 217
    Width = 114
    Height = 17
    Caption = 'Walk Wait Lockers'
    TabOrder = 11
    OnClick = DebuggerOptions
  end
end
