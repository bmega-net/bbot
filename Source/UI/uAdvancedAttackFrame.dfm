object AdvancedAttackFrame: TAdvancedAttackFrame
  Left = 0
  Top = 0
  Width = 733
  Height = 518
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Label208: TLabel
    Left = 9
    Top = 4
    Width = 89
    Height = 13
    Caption = 'Current attacks'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label209: TLabel
    Left = 236
    Top = 6
    Width = 121
    Height = 13
    Caption = 'New advanced attack'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label219: TLabel
    Left = 239
    Top = 120
    Width = 102
    Height = 13
    Caption = 'Step 2 - creatures'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label210: TLabel
    Left = 473
    Top = 19
    Width = 86
    Height = 13
    Caption = 'Step 3 - trigger'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label184: TLabel
    Left = 8
    Top = 498
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
  object Label185: TLabel
    Left = 73
    Top = 498
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
  object Label186: TLabel
    Left = 9
    Top = 483
    Width = 43
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Shift+Up'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label187: TLabel
    Left = 55
    Top = 482
    Width = 192
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'move up selected item (execute before)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
  end
  object Label188: TLabel
    Left = 9
    Top = 466
    Width = 57
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Shift+Down'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label189: TLabel
    Left = 70
    Top = 466
    Width = 198
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'move down selected item (execute after)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 46
    Top = 448
    Width = 150
    Height = 13
    Caption = 'Low priority, last executed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 45
    Top = 21
    Width = 155
    Height = 13
    Caption = 'High priority, first executed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Step3placeholder: TLabel
    Left = 476
    Top = 135
    Width = 89
    Height = 13
    Caption = 'Step 3 placeholder'
    Visible = False
  end
  object AdvancedAttackList: TListBox
    Tag = 1
    Left = 9
    Top = 40
    Width = 224
    Height = 404
    Style = lbOwnerDrawVariable
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = AdvancedAttackListDblClick
    OnDrawItem = AdvancedAttackListDrawItem
    OnKeyDown = AdvancedAttackListKeyDown
  end
  object AdvancedAttackCreatures: TCheckListBox
    Left = 239
    Top = 136
    Width = 228
    Height = 308
    ItemHeight = 13
    Items.Strings = (
      '%Any'
      '%Players'
      '%Monsters'
      '%Double-click to add')
    Style = lbOwnerDrawVariable
    TabOrder = 1
    OnClick = AdvancedAttackCreaturesClick
    OnDblClick = AdvancedAttackCreaturesDblClick
    OnDrawItem = AdvancedAttackCreaturesDrawItem
  end
  object AdvancedAttackTriggerKind: TRadioGroup
    Left = 472
    Top = 38
    Width = 228
    Height = 95
    Caption = 'Trigger'
    ItemIndex = 0
    Items.Strings = (
      'Single target (normal attack)'
      'Area spell (Exori, UE...)'
      'Area shoot (GFB, Avalanche..)'
      'Wave (Energy Beam, Flam Wave...)')
    TabOrder = 2
    OnClick = AdvancedAttackTriggerKindClick
  end
  object AdvancedAttackWaverPanel: TPanel
    Left = 21
    Top = 93
    Width = 212
    Height = 284
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object Label217: TLabel
      Left = 0
      Top = 42
      Width = 67
      Height = 13
      Caption = 'Wave format:'
    end
    object AdvancedAttackLabelAreaTitle2: TLabel
      Left = 0
      Top = 0
      Width = 76
      Height = 13
      Caption = 'Configuration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label218: TLabel
      Left = 0
      Top = 21
      Width = 107
      Height = 13
      Caption = 'Min. creature number:'
    end
    object Label3: TLabel
      Left = 9
      Top = 246
      Width = 44
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Left-Click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 55
      Top = 246
      Width = 69
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'increase beam'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 9
      Top = 263
      Width = 50
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Right-Click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 61
      Top = 263
      Width = 73
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'decrease beam'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object AdvancedAttackWaveMinCreatures: TMemo
      Left = 110
      Top = 17
      Width = 67
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '0')
      MaxLength = 5
      TabOrder = 0
      WantReturns = False
      WordWrap = False
    end
    object WaveFormatDesignerPlaceholder: TPanel
      Left = 9
      Top = 60
      Width = 196
      Height = 181
      Caption = 'Wave Format Designer'
      TabOrder = 1
    end
  end
  object AdvancedAttackSelfShooterPanel: TPanel
    Left = 473
    Top = 154
    Width = 224
    Height = 72
    BevelOuter = bvNone
    TabOrder = 4
    Visible = False
    object Label215: TLabel
      Left = 71
      Top = 46
      Width = 36
      Height = 13
      Caption = 'Radius:'
    end
    object Label216: TLabel
      Left = 0
      Top = 21
      Width = 107
      Height = 13
      Caption = 'Min. creature number:'
    end
    object AdvancedAttackLabelAreaTitle: TLabel
      Left = 0
      Top = -1
      Width = 138
      Height = 13
      Caption = 'Configuration - Self Area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AdvancedAttackSelfAreaRadius: TMemo
      Left = 109
      Top = 42
      Width = 67
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '0')
      MaxLength = 5
      TabOrder = 0
      WantReturns = False
      WordWrap = False
    end
    object AdvancedAttackSelfAreaMinCreatures: TMemo
      Left = 109
      Top = 17
      Width = 67
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '0')
      MaxLength = 5
      TabOrder = 1
      WantReturns = False
      WordWrap = False
    end
  end
  object AdvancedAttackNameActionPanel: TPanel
    Left = 239
    Top = 21
    Width = 228
    Height = 98
    BevelOuter = bvNone
    TabOrder = 5
    object LastStepLabel: TLabel
      Left = 0
      Top = 0
      Width = 141
      Height = 13
      Caption = 'Step 1 - name and action'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 0
      Top = 56
      Width = 34
      Height = 13
      Caption = 'Action:'
    end
    object Label2: TLabel
      Left = 0
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object AdvancedAttackAction: TComboBox
      Left = 0
      Top = 72
      Width = 228
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 0
      OnCloseUp = AdvancedAttackActionCloseUp
      OnDropDown = AdvancedAttackActionDropDown
    end
    object AdvancedAttackName: TEdit
      Left = 0
      Top = 33
      Width = 228
      Height = 21
      TabOrder = 1
    end
  end
  object AdvancedAttackSavePanel: TPanel
    Left = 485
    Top = 401
    Width = 212
    Height = 43
    BevelOuter = bvNone
    TabOrder = 6
    object AdvancedAttackSave: TButton
      Left = 40
      Top = 1
      Width = 132
      Height = 38
      Caption = 'Save'
      TabOrder = 0
      OnClick = AdvancedAttackSaveClick
    end
  end
  object AdvancedAttackTargetShooterPanel: TPanel
    Left = 473
    Top = 234
    Width = 227
    Height = 96
    BevelOuter = bvNone
    TabOrder = 7
    Visible = False
    object Label9: TLabel
      Left = 71
      Top = 46
      Width = 36
      Height = 13
      Caption = 'Radius:'
    end
    object Label10: TLabel
      Left = 0
      Top = 21
      Width = 107
      Height = 13
      Caption = 'Min. creature number:'
    end
    object Label11: TLabel
      Left = 0
      Top = -1
      Width = 155
      Height = 13
      Caption = 'Configuration - Target Area'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 46
      Top = 71
      Width = 61
      Height = 13
      Caption = 'Screen Limit:'
    end
    object AdvancedAttackTargetAreaRadius: TMemo
      Left = 109
      Top = 42
      Width = 67
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '0')
      MaxLength = 5
      TabOrder = 0
      WantReturns = False
      WordWrap = False
    end
    object AdvancedAttackTargetAreaMinCreatures: TMemo
      Left = 109
      Top = 17
      Width = 67
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '0')
      MaxLength = 5
      TabOrder = 1
      WantReturns = False
      WordWrap = False
    end
    object AdvancedAttackTargetAreaLimitScreen: TComboBox
      Left = 109
      Top = 67
      Width = 108
      Height = 22
      Style = csOwnerDrawFixed
      TabOrder = 2
      OnDrawItem = AdvancedAttackTargetAreaLimitScreenDrawItem
      Items.Strings = (
        '0 disabled'
        '1 invisible sqm'
        '2 first visible sqm'
        '3 second visible sqm'
        '4 third visible sqm')
    end
  end
  object RefreshTargetCreatures: TTimer
    Interval = 4000
    OnTimer = RefreshTargetCreaturesTimer
    Left = 336
    Top = 468
  end
end
