object ReconnectManagerFrame: TReconnectManagerFrame
  Left = 0
  Top = 0
  Width = 1139
  Height = 506
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object gbBotManagerAccountManagement: TPanel
    Left = 570
    Top = 269
    Width = 560
    Height = 230
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object Label182: TLabel
      Left = 12
      Top = 6
      Width = 124
      Height = 13
      Caption = 'Account Management'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label179: TLabel
      Left = 19
      Top = 29
      Width = 43
      Height = 13
      Caption = 'Account:'
    end
    object BotManagerViewAcc: TLabel
      Left = 293
      Top = 29
      Width = 26
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'View'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = ViewAccPass
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object BotManagerViewPass: TLabel
      Left = 293
      Top = 56
      Width = 26
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'View'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = ViewAccPass
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label180: TLabel
      Left = 12
      Top = 56
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label181: TLabel
      Left = 12
      Top = 77
      Width = 57
      Height = 13
      Caption = 'Characters:'
    end
    object BotManagerDeleteAccount: TLabel
      Left = 375
      Top = 78
      Width = 85
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'Delete account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BotManagerDeleteAccountClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label184: TLabel
      Left = 294
      Top = 206
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
      Left = 359
      Top = 206
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
      Left = 294
      Top = 189
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
      Left = 341
      Top = 189
      Width = 107
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'move up selected item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label188: TLabel
      Left = 294
      Top = 172
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
      Left = 355
      Top = 172
      Width = 121
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'move down selected item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label190: TLabel
      Left = 294
      Top = 155
      Width = 58
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Double-Click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label191: TLabel
      Left = 356
      Top = 155
      Width = 119
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'add or rename character'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object BotManagerAcc: TEdit
      Left = 64
      Top = 25
      Width = 225
      Height = 21
      PasswordChar = '*'
      TabOrder = 0
      Text = 'BotManager'
    end
    object BotManagerPass: TEdit
      Left = 64
      Top = 52
      Width = 225
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
      Text = 'BotManagerPass'
    end
    object BotManagerChars: TListBox
      Left = 12
      Top = 96
      Width = 277
      Height = 125
      Style = lbOwnerDrawVariable
      ItemHeight = 13
      TabOrder = 2
      OnDblClick = BotManagerCharsDblClick
      OnDrawItem = BotManagerCharsDrawItem
      OnKeyDown = BotManagerCharsKeyDown
    end
    object BotManagerSaveAcc: TButton
      Left = 363
      Top = 25
      Width = 109
      Height = 48
      Caption = 'Save account'
      TabOrder = 3
      OnClick = BotManagerSaveAccClick
    end
  end
  object gbBotManagerScheduleManagement: TPanel
    Left = 569
    Top = 28
    Width = 560
    Height = 227
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object Label192: TLabel
      Left = 12
      Top = 6
      Width = 129
      Height = 13
      Caption = 'Schedule Management'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Duration: TLabel
      Left = 20
      Top = 53
      Width = 45
      Height = 13
      Caption = 'Duration:'
    end
    object Label193: TLabel
      Left = 117
      Top = 53
      Width = 4
      Height = 13
      Caption = ':'
    end
    object Label194: TLabel
      Left = 173
      Top = 53
      Width = 46
      Height = 13
      Caption = 'Variation:'
    end
    object Label195: TLabel
      Left = 269
      Top = 53
      Width = 11
      Height = 13
      Caption = '%'
    end
    object BotManagerScheduleDeleteItem: TLabel
      Left = 386
      Top = 76
      Width = 65
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'Delete task'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BotManagerScheduleDeleteItemClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object BotManagerRunTask: TLabel
      Left = 77
      Top = 27
      Width = 112
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'force start this task'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BotManagerRunTaskClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object BotManagerScheduleOffline: TRadioButton
      Left = 12
      Top = 77
      Width = 205
      Height = 17
      Caption = 'Disconnect and wait for the next tak'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = SchedulerKindChange
    end
    object BotManagerScheduleOnline: TRadioButton
      Left = 12
      Top = 100
      Width = 189
      Height = 17
      Caption = 'Login and play with a character'
      TabOrder = 1
      OnClick = SchedulerKindChange
    end
    object BotManagerScheduleEnabled: TCheckBox
      Left = 13
      Top = 25
      Width = 60
      Height = 17
      Caption = 'Enabled'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object BotManagerScheduleHour: TMemo
      Left = 69
      Top = 48
      Width = 46
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '2')
      MaxLength = 2
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object BotManagerScheduleMinute: TMemo
      Left = 122
      Top = 48
      Width = 46
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '30')
      MaxLength = 2
      TabOrder = 4
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object BotManagerScheduleVariation: TMemo
      Left = 223
      Top = 48
      Width = 46
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '30')
      MaxLength = 2
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object BotManagerScheduleSave: TButton
      Left = 364
      Top = 23
      Width = 109
      Height = 48
      Caption = 'Save task'
      TabOrder = 6
      OnClick = BotManagerScheduleSaveClick
    end
    object ScheduleCharacterSettings: TPanel
      Left = 12
      Top = 120
      Width = 289
      Height = 104
      BevelOuter = bvNone
      TabOrder = 7
      object Label196: TLabel
        Left = 0
        Top = 0
        Width = 106
        Height = 13
        Caption = 'Character Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label197: TLabel
        Left = 18
        Top = 22
        Width = 52
        Height = 13
        Caption = 'Character:'
      end
      object Label199: TLabel
        Left = 42
        Top = 48
        Width = 28
        Height = 13
        Caption = 'Block:'
      end
      object Label200: TLabel
        Left = 124
        Top = 48
        Width = 4
        Height = 13
        Caption = ':'
      end
      object Label198: TLabel
        Left = 39
        Top = 75
        Width = 31
        Height = 13
        Caption = 'Script:'
      end
      object BotManagerScheduleCharacter: TComboBox
        Left = 76
        Top = 17
        Width = 213
        Height = 22
        Style = csOwnerDrawVariable
        TabOrder = 0
        OnDrawItem = BotManagerScheduleCharacterDrawItem
        OnDropDown = BotManagerScheduleCharacterDropDown
      end
      object BotManagerScheduleBlockCharMinutes: TMemo
        Left = 127
        Top = 43
        Width = 46
        Height = 23
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Alignment = taCenter
        Lines.Strings = (
          '00')
        MaxLength = 2
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        OnKeyPress = OnKeyPressNumOnly
      end
      object BotManagerScheduleBlockCharHours: TMemo
        Left = 77
        Top = 43
        Width = 46
        Height = 23
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Alignment = taCenter
        Lines.Strings = (
          '12')
        MaxLength = 2
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        OnKeyPress = OnKeyPressNumOnly
      end
      object BotManagerScheduleScript: TComboBox
        Left = 76
        Top = 71
        Width = 213
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        OnDropDown = BotManagerScheduleScriptDropDown
      end
    end
  end
  object gbBotManagerSchedulerList: TPanel
    Left = 0
    Top = -1
    Width = 560
    Height = 462
    BevelOuter = bvNone
    TabOrder = 2
    object Label183: TLabel
      Left = 13
      Top = 10
      Width = 129
      Height = 13
      Caption = 'Schedule Management'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BotManagerManageAcc: TLabel
      Left = 445
      Top = 55
      Width = 100
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'Manage Accounts'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      PopupMenu = BotManagerAccPopup
      OnClick = BotManagerManageAccClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label201: TLabel
      Left = 363
      Top = 438
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
    object Label202: TLabel
      Left = 424
      Top = 438
      Width = 121
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'move down selected item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label203: TLabel
      Left = 393
      Top = 422
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
    object Label204: TLabel
      Left = 438
      Top = 422
      Width = 107
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'move up selected item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label205: TLabel
      Left = 13
      Top = 55
      Width = 34
      Height = 13
      Caption = 'Profile:'
    end
    object Label206: TLabel
      Left = 12
      Top = 422
      Width = 74
      Height = 13
      Caption = 'Current task:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label207: TLabel
      Left = 33
      Top = 438
      Width = 53
      Height = 13
      Caption = 'Time left:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BotManagerStatusCurrent: TLabel
      Left = 91
      Top = 422
      Width = 28
      Height = 13
      Caption = 'none'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BotManagerStatusCurrentClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object BotManagerStatusTime: TLabel
      Left = 91
      Top = 438
      Width = 28
      Height = 13
      Caption = 'done'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BotManagerStatusTimeClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object BotManagerEnabled: TCheckBox
      Left = 14
      Top = 30
      Width = 163
      Height = 17
      Caption = 'Enable Reconnect Manager'
      TabOrder = 3
      OnClick = BotManagerEnabledClick
    end
    object BotManagerLoad: TButton
      Left = 210
      Top = 49
      Width = 85
      Height = 26
      Caption = 'Load'
      TabOrder = 0
      OnClick = BotManagerLoadClick
    end
    object BotManagerSchedule: TListBox
      Left = 12
      Top = 78
      Width = 534
      Height = 338
      Style = lbOwnerDrawVariable
      Items.Strings = (
        '0/New/Double-Click to schedule')
      TabOrder = 1
      OnDblClick = BotManagerScheduleDblClick
      OnDrawItem = BotManagerScheduleDrawItem
      OnKeyDown = BotManagerScheduleKeyDown
    end
    object BotManagerProfile: TComboBox
      Left = 52
      Top = 52
      Width = 154
      Height = 21
      TabOrder = 2
      OnChange = BotManagerProfileChange
      OnDropDown = BotManagerProfileDropDown
    end
  end
  object BotManagerAccPopup: TPopupMenu
    OnPopup = BotManagerAccPopupPopup
    Left = 400
    Top = 136
  end
  object LoadProfileMonitor: TTimer
    OnTimer = LoadProfileMonitorTimer
    Left = 168
    Top = 440
  end
end
