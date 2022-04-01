object WarNetFrame: TWarNetFrame
  Left = 0
  Top = 0
  Width = 1110
  Height = 615
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object WarNetStatus: TLabel
    Left = 469
    Top = 4
    Width = 70
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taRightJustify
    Caption = 'Not connected'
  end
  object Disconnect: TLabel
    Left = 278
    Top = 4
    Width = 62
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Disconnect'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    OnClick = DisconnectClick
    OnMouseEnter = LinkMouseEnter
    OnMouseLeave = LinkMouseLeave
  end
  object GoViewRooms: TLabel
    Left = 7
    Top = 4
    Width = 65
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'View rooms'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = GoViewRoomsClick
    OnMouseEnter = LinkMouseEnter
    OnMouseLeave = LinkMouseLeave
  end
  object GoViewActions: TLabel
    Left = 87
    Top = 4
    Width = 70
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'View actions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = GoViewActionsClick
    OnMouseEnter = LinkMouseEnter
    OnMouseLeave = LinkMouseLeave
  end
  object RoomsPanel: TPanel
    Left = 3
    Top = 22
    Width = 542
    Height = 287
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object Label56: TLabel
      Left = 411
      Top = 217
      Width = 58
      Height = 13
      Caption = 'Double-Click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label80: TLabel
      Left = 472
      Top = 217
      Width = 57
      Height = 13
      Caption = 'to join room'
    end
    object Label52: TLabel
      Left = 7
      Top = 0
      Width = 39
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Rooms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GoCreateRoom: TLabel
      Left = 458
      Top = 0
      Width = 71
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Create room'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = GoCreateRoomClick
      OnMouseEnter = LinkMouseEnter
      OnMouseLeave = LinkMouseLeave
    end
    object WarNetRooms: TListBox
      Left = 7
      Top = 18
      Width = 529
      Height = 194
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDblClick = WarNetRoomsDblClick
      OnDrawItem = ServerRoomDrawItem
    end
  end
  object ActionsPanel: TPanel
    Left = 559
    Top = 22
    Width = 542
    Height = 287
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object Label13: TLabel
      Left = 7
      Top = 4
      Width = 42
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Actions'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label77: TLabel
      Left = 388
      Top = 215
      Width = 61
      Height = 13
      Caption = 'Shift+Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label168: TLabel
      Left = 452
      Top = 215
      Width = 84
      Height = 13
      Caption = 'to delete a action'
    end
    object GoCreateAction: TLabel
      Left = 460
      Top = 0
      Width = 76
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Create action'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = GoCreateActionClick
      OnMouseEnter = LinkMouseEnter
      OnMouseLeave = LinkMouseLeave
    end
    object WarNetActions: TListBox
      Tag = 1
      Left = 7
      Top = 18
      Width = 529
      Height = 194
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDrawItem = WarNetActionsDrawItem
      OnKeyDown = WarNetActionsKeyDown
    end
    object WarNetItemCombos: TCheckBox
      Tag = 1
      Left = 7
      Top = 215
      Width = 242
      Height = 17
      Caption = 'Enable Magic Wall/Wild Growth combo'
      TabOrder = 1
      OnClick = WarNetItemCombosClick
    end
  end
  object CreateActionPanel: TPanel
    Left = 3
    Top = 315
    Width = 542
    Height = 287
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object Label165: TLabel
      Left = 243
      Top = 105
      Width = 39
      Height = 13
      Caption = 'Combo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label167: TLabel
      Left = 249
      Top = 125
      Width = 33
      Height = 13
      Caption = 'Combo'
    end
    object Label164: TLabel
      Left = 243
      Top = 57
      Width = 41
      Height = 13
      Caption = 'Duration'
    end
    object WarNetSignalChangeColor: TLabel
      Left = 382
      Top = 32
      Width = 29
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Color'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = WarNetSignalChangeColorClick
      OnMouseEnter = LinkMouseEnter
      OnMouseLeave = LinkMouseLeave
    end
    object Label163: TLabel
      Left = 262
      Top = 32
      Width = 22
      Height = 13
      Caption = 'Text'
    end
    object Label137: TLabel
      Left = 242
      Top = 11
      Width = 34
      Height = 13
      Caption = 'Signal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label81: TLabel
      Left = 8
      Top = 11
      Width = 40
      Height = 13
      Caption = 'When I'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object WarNetComboCombo: TComboBox
      Left = 287
      Top = 122
      Width = 155
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 0
      OnCloseUp = WarNetComboComboCloseUp
      OnDropDown = WarNetComboComboDropDown
    end
    object WarNetAddCombo: TButton
      Left = 448
      Top = 115
      Width = 85
      Height = 25
      Caption = 'Start combo'
      TabOrder = 1
      OnClick = WarNetAddComboClick
    end
    object WarNetAddSignal: TButton
      Left = 448
      Top = 36
      Width = 85
      Height = 25
      Caption = 'Send signal'
      TabOrder = 2
      OnClick = WarNetAddSignalClick
    end
    object WarNetSignalDuration: TMemo
      Left = 290
      Top = 53
      Width = 71
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '1200')
      MaxLength = 8
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object WarNetSignalName: TEdit
      Left = 290
      Top = 28
      Width = 87
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'Attack!!'
    end
    object WarNetTriggerKey: TEdit
      Left = 82
      Top = 78
      Width = 134
      Height = 21
      ReadOnly = True
      TabOrder = 5
      Text = 'F5'
      OnKeyDown = WarNetTriggerKeyKeyDown
    end
    object WarNetTriggerSay: TEdit
      Left = 82
      Top = 53
      Width = 134
      Height = 21
      TabOrder = 6
      Text = 'Utevo Kill'
    end
    object WarNetTriggerShoot: TMemo
      Left = 82
      Top = 28
      Width = 71
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '3155')
      MaxLength = 6
      TabOrder = 7
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object WarNetTriggerSelectedShoot: TRadioButton
      Left = 10
      Top = 30
      Width = 70
      Height = 17
      Caption = 'Shoot item'
      TabOrder = 8
    end
    object WarNetTriggerSelectedSay: TRadioButton
      Left = 10
      Top = 55
      Width = 70
      Height = 17
      Caption = 'Say'
      Checked = True
      TabOrder = 9
      TabStop = True
    end
    object WarNetTriggerSelectedKey: TRadioButton
      Left = 10
      Top = 80
      Width = 70
      Height = 17
      Caption = 'Press key'
      TabOrder = 10
    end
  end
  object CreateRoomPanel: TPanel
    Left = 559
    Top = 315
    Width = 542
    Height = 287
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object Label2: TLabel
      Left = 7
      Top = 0
      Width = 71
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Create room'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 7
      Top = 13
      Width = 85
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '1. Select a server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 7
      Top = 165
      Width = 106
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '2. Room configuration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 7
      Top = 186
      Width = 27
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 7
      Top = 211
      Width = 82
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Normal password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 7
      Top = 236
      Width = 82
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Leader password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 274
      Top = 176
      Width = 253
      Height = 91
      Caption = 
        'Players who connect using Leader Password are always visible on ' +
        'HUD and can start combos.'#13#10#13#10'Players who connect using the Norma' +
        'l Password are NOT visible on HUD, they only are visible when th' +
        'ey are with low health/mana and they cannot start combos.'
      WordWrap = True
    end
    object WarNetServers: TListBox
      Left = 7
      Top = 30
      Width = 529
      Height = 130
      Style = lbOwnerDrawFixed
      TabOrder = 0
      OnDrawItem = ServerRoomDrawItem
    end
    object CreateRoomName: TEdit
      Left = 98
      Top = 182
      Width = 170
      Height = 21
      MaxLength = 30
      TabOrder = 1
    end
    object CreateRoomPassword: TEdit
      Left = 98
      Top = 207
      Width = 170
      Height = 21
      MaxLength = 30
      TabOrder = 2
    end
    object CreateRoomLeaderPassword: TEdit
      Left = 98
      Top = 232
      Width = 170
      Height = 21
      MaxLength = 30
      TabOrder = 3
    end
    object RoomCreate: TButton
      Left = 125
      Top = 259
      Width = 116
      Height = 25
      Caption = 'Create room'
      TabOrder = 4
      OnClick = RoomCreateClick
    end
  end
end
