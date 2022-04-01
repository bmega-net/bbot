object FMain: TFMain
  Left = 0
  Top = 478
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BBot - Init'
  ClientHeight = 804
  ClientWidth = 1242
  Color = 16772841
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Pitch = fpFixed
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
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object gbAlliesAndEnemies: TPanel
    Left = 268
    Top = 19
    Width = 439
    Height = 507
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 18
    Visible = False
    object Label58: TLabel
      Left = 14
      Top = 70
      Width = 90
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Allies - one per line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label82: TLabel
      Left = 231
      Top = 70
      Width = 105
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Enemies - one per line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object memoAllies: TMemo
      Tag = 1
      Left = 8
      Top = 90
      Width = 210
      Height = 411
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 5
      OnExit = WarToolsSettings
    end
    object memoEnemies: TMemo
      Tag = 1
      Left = 222
      Top = 90
      Width = 210
      Height = 411
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 6
      OnExit = WarToolsSettings
    end
    object chkMarkAlliesAndenemies: TCheckBox
      Tag = 1
      Left = 7
      Top = 4
      Width = 145
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Show Allies and Enemies'
      TabOrder = 0
      OnClick = WarToolsSettings
    end
    object chkAllyParty: TCheckBox
      Tag = 1
      Left = 7
      Top = 26
      Width = 166
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Mark party members as ally'
      TabOrder = 2
      OnClick = WarToolsSettings
    end
    object chkEnemyNoAlly: TCheckBox
      Tag = 1
      Left = 7
      Top = 48
      Width = 181
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Mark non-ally as enemy'
      TabOrder = 4
      OnClick = WarToolsSettings
    end
    object chkAutoAttackEnemies: TCheckBox
      Tag = 1
      Left = 198
      Top = 4
      Width = 132
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Auto Attack Enemies'
      TabOrder = 1
      OnClick = WarToolsSettings
    end
    object chkPushParalyed: TCheckBox
      Tag = 1
      Left = 198
      Top = 26
      Width = 132
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Push Paralyzed Enemies'
      TabOrder = 3
      OnClick = WarToolsSettings
    end
  end
  object gbEnchanter: TPanel
    Left = 268
    Top = 19
    Width = 219
    Height = 175
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 12
    Visible = False
    object Label7: TLabel
      Left = 18
      Top = 12
      Width = 39
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Enchant'
    end
    object Label14: TLabel
      Left = 31
      Top = 89
      Width = 26
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Mana'
    end
    object Label15: TLabel
      Left = 35
      Top = 63
      Width = 22
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Cast'
    end
    object Label34: TLabel
      Left = 37
      Top = 116
      Width = 20
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Soul'
    end
    object cmbEnchanterHand: TComboBox
      Tag = 1
      Left = 62
      Top = 34
      Width = 144
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'on Left (<=) Hand'
      Items.Strings = (
        'on Left (<=) Hand'
        'on Right (=>) Hand'
        'on Backpack')
    end
    object rbEnchanterUseBlank: TRadioButton
      Tag = 1
      Left = 61
      Top = 7
      Width = 80
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Blank Rune'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbEnchanterUseSpear: TRadioButton
      Tag = 1
      Left = 148
      Top = 7
      Width = 58
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Spear'
      TabOrder = 1
    end
    object numEnchanterMana: TMemo
      Tag = 1
      Left = 62
      Top = 84
      Width = 64
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '1000')
      MaxLength = 5
      TabOrder = 4
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object txtEnchanterSpell: TEdit
      Tag = 1
      Left = 62
      Top = 59
      Width = 144
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 3
      Text = 'adori min vis'
    end
    object numEnchanterSoul: TMemo
      Tag = 1
      Left = 62
      Top = 111
      Width = 38
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '5')
      MaxLength = 3
      TabOrder = 5
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object chkEnchanter: TCheckBox
      Tag = 1
      Left = 62
      Top = 138
      Width = 51
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Active'
      TabOrder = 6
      OnClick = AutomationToolsSettings
    end
  end
  object gbReUserCures: TPanel
    Left = 268
    Top = 19
    Width = 226
    Height = 462
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 9
    Visible = False
    object Label39: TLabel
      Left = 12
      Top = 4
      Width = 61
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Cast Spells'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label40: TLabel
      Left = 12
      Top = 231
      Width = 34
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Items'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 12
      Top = 329
      Width = 26
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Cure'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object chkRUhaste: TCheckBox
      Tag = 1
      Left = 16
      Top = 21
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Haste'
      TabOrder = 0
      OnClick = HealingToolsSettings
    end
    object chkRUms: TCheckBox
      Tag = 1
      Left = 16
      Top = 44
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Magic Shield'
      TabOrder = 2
      OnClick = HealingToolsSettings
    end
    object chkRUrecovery: TCheckBox
      Tag = 1
      Left = 16
      Top = 71
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Recovery'
      TabOrder = 4
      OnClick = HealingToolsSettings
    end
    object chkRUsharpshooter: TCheckBox
      Tag = 1
      Left = 16
      Top = 98
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Sharpshooter'
      TabOrder = 6
      OnClick = HealingToolsSettings
    end
    object chkRUbloodrage: TCheckBox
      Tag = 1
      Left = 16
      Top = 127
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Blood Rage'
      TabOrder = 8
      OnClick = HealingToolsSettings
    end
    object chkRUcharge: TCheckBox
      Tag = 1
      Left = 16
      Top = 150
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Charge'
      TabOrder = 10
      OnClick = HealingToolsSettings
    end
    object chkRUlight1: TCheckBox
      Tag = 1
      Left = 16
      Top = 177
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Light'
      TabOrder = 11
      OnClick = HealingToolsSettings
    end
    object chkRUlight3: TCheckBox
      Tag = 1
      Left = 16
      Top = 204
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Ultimate Light'
      TabOrder = 13
      OnClick = HealingToolsSettings
    end
    object chkRUlight2: TCheckBox
      Tag = 1
      Left = 123
      Top = 177
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Great Light'
      TabOrder = 12
      OnClick = HealingToolsSettings
    end
    object chkRUprotector: TCheckBox
      Tag = 1
      Left = 123
      Top = 127
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Protector'
      TabOrder = 9
      OnClick = HealingToolsSettings
    end
    object chkRUswiftfoot: TCheckBox
      Tag = 1
      Left = 123
      Top = 98
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Swift Foot'
      TabOrder = 7
      OnClick = HealingToolsSettings
    end
    object chkRUintenserecovery: TCheckBox
      Tag = 1
      Left = 123
      Top = 71
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Int. Recovery'
      TabOrder = 5
      OnClick = HealingToolsSettings
    end
    object chkRUinvis: TCheckBox
      Tag = 1
      Left = 123
      Top = 44
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Invisible'
      TabOrder = 3
      OnClick = HealingToolsSettings
    end
    object chkRUshaste: TCheckBox
      Tag = 1
      Left = 123
      Top = 21
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Strong Haste'
      TabOrder = 1
      OnClick = HealingToolsSettings
    end
    object chkRUamulet: TCheckBox
      Tag = 1
      Left = 16
      Top = 248
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Amulet'
      TabOrder = 14
      OnClick = HealingToolsSettings
    end
    object chkRUring: TCheckBox
      Tag = 1
      Left = 16
      Top = 275
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Ring'
      TabOrder = 16
      OnClick = HealingToolsSettings
    end
    object chkRUleft: TCheckBox
      Tag = 1
      Left = 16
      Top = 302
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Left Hand'
      TabOrder = 18
      OnClick = HealingToolsSettings
    end
    object chkCurePoison: TCheckBox
      Tag = 1
      Left = 16
      Top = 346
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Poison'
      TabOrder = 20
      OnClick = HealingToolsSettings
    end
    object chkCureBleeding: TCheckBox
      Tag = 1
      Left = 16
      Top = 373
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Bleeding'
      TabOrder = 22
      OnClick = HealingToolsSettings
    end
    object chkCureBurning: TCheckBox
      Tag = 1
      Left = 16
      Top = 400
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Burning'
      TabOrder = 24
      OnClick = HealingToolsSettings
    end
    object chkCureParalyze: TCheckBox
      Tag = 1
      Left = 16
      Top = 427
      Width = 62
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Paralyze'
      TabOrder = 25
      OnClick = HealingToolsSettings
    end
    object edtCureParalyzeSpell: TEdit
      Tag = 1
      Left = 84
      Top = 430
      Width = 85
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 26
      Text = 'exura'
    end
    object numCureParalyzeMana: TMemo
      Tag = 1
      Left = 174
      Top = 430
      Width = 42
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '20')
      MaxLength = 5
      TabOrder = 27
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object chkCureEletrification: TCheckBox
      Tag = 1
      Left = 118
      Top = 373
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Eletrification'
      TabOrder = 23
      OnClick = HealingToolsSettings
    end
    object chkCureCurse: TCheckBox
      Tag = 1
      Left = 118
      Top = 346
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Curse'
      TabOrder = 21
      OnClick = HealingToolsSettings
    end
    object chkRUright: TCheckBox
      Tag = 1
      Left = 118
      Top = 302
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Right Hand'
      TabOrder = 19
      OnClick = HealingToolsSettings
    end
    object chkRUsoft: TCheckBox
      Tag = 1
      Left = 118
      Top = 275
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Soft Boots'
      TabOrder = 17
      OnClick = HealingToolsSettings
    end
    object chkRUammo: TCheckBox
      Tag = 1
      Left = 118
      Top = 248
      Width = 90
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Ammo'
      TabOrder = 15
      OnClick = HealingToolsSettings
    end
  end
  object gbPackets: TPanel
    Left = 268
    Top = 19
    Width = 703
    Height = 513
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 0
    Visible = False
    object lstSC: TListBox
      Left = 3
      Top = 6
      Width = 697
      Height = 165
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ItemHeight = 13
      Items.Strings = (
        'Client')
      ParentFont = False
      TabOrder = 0
    end
    object lstSS: TListBox
      Left = 3
      Top = 341
      Width = 697
      Height = 164
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = cl3DDkShadow
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ItemHeight = 13
      Items.Strings = (
        'Server')
      ParentFont = False
      TabOrder = 2
    end
    object lstSB: TListBox
      Left = 3
      Top = 174
      Width = 697
      Height = 164
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ItemHeight = 13
      Items.Strings = (
        'Bot')
      ParentFont = False
      TabOrder = 1
    end
  end
  object gbHUD: TPanel
    Left = 268
    Top = 19
    Width = 209
    Height = 246
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 20
    Visible = False
    object chkCLevels: TCheckBox
      Tag = 1
      Left = 10
      Top = 53
      Width = 158
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Estimated Creature Level'
      TabOrder = 2
      OnClick = BasicToolsSettings
    end
    object chkAdvanced: TCheckBox
      Tag = 1
      Left = 10
      Top = 94
      Width = 149
      Height = 23
      HelpContext = 100
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Skill Advanced Messages'
      TabOrder = 3
      OnClick = BasicToolsSettings
    end
    object chkHUDspells: TCheckBox
      Tag = 1
      Left = 10
      Top = 8
      Width = 128
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Spells Timer'
      TabOrder = 0
      OnClick = BasicToolsSettings
    end
    object chkHUDmwalls: TCheckBox
      Tag = 1
      Left = 10
      Top = 31
      Width = 128
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Magic Wall Timer'
      TabOrder = 1
      OnClick = BasicToolsSettings
    end
    object chkExp: TCheckBox
      Tag = 1
      Left = 10
      Top = 140
      Width = 149
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Exp Statistics'
      TabOrder = 5
      OnClick = BasicToolsSettings
    end
    object chkGotInfo: TCheckBox
      Tag = 1
      Left = 10
      Top = 163
      Width = 149
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Exp Gain Informations'
      TabOrder = 6
      OnClick = BasicToolsSettings
    end
    object chkAutoStatistics: TCheckBox
      Tag = 1
      Left = 10
      Top = 187
      Width = 149
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Auto Show Statistics'
      TabOrder = 7
      OnClick = BasicToolsSettings
    end
    object Button4: TButton
      Left = 10
      Top = 216
      Width = 178
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Reset All Statistics'
      TabOrder = 8
      OnClick = btnResetStatistics
    end
    object chkLootHUD: TCheckBox
      Tag = 1
      Left = 10
      Top = 117
      Width = 149
      Height = 23
      HelpContext = 100
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Loot HUD'
      TabOrder = 4
      OnClick = BasicToolsSettings
    end
    object chkPlayerGroups: TCheckBox
      Tag = 1
      Left = 10
      Top = 73
      Width = 158
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Player Group Count'
      TabOrder = 9
      OnClick = BasicToolsSettings
    end
  end
  object gbTrainer: TPanel
    Left = 268
    Top = 19
    Width = 214
    Height = 364
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 13
    Visible = False
    object Label42: TLabel
      Left = 12
      Top = 1
      Width = 181
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Select the Slime Mother / Monk:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label45: TLabel
      Left = 35
      Top = 308
      Width = 51
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Attack HP:'
    end
    object Label43: TLabel
      Left = 125
      Top = 309
      Width = 11
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '%'
    end
    object Label46: TLabel
      Left = 125
      Top = 333
      Width = 11
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '%'
    end
    object Label44: TLabel
      Left = 43
      Top = 333
      Width = 42
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Stop HP:'
    end
    object lstTrainers: TCheckListBox
      Left = 12
      Top = 19
      Width = 191
      Height = 211
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      OnClickCheck = lstTrainersClickCheck
      ItemHeight = 32
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDrawItem = lstTrainersDrawItem
    end
    object chkHPTrain: TCheckBox
      Tag = 1
      Left = 16
      Top = 283
      Width = 93
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'HP Training'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = AutomationToolsSettings
    end
    object chkSlimeTrain: TCheckBox
      Tag = 1
      Left = 17
      Top = 261
      Width = 97
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Slime Training'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = AutomationToolsSettings
    end
    object cmdTre: TButton
      Left = 33
      Top = 236
      Width = 149
      Height = 22
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Refresh Trainers'
      TabOrder = 1
      OnClick = cmdTreClick
    end
    object TrainerHPMax: TMemo
      Tag = 1
      Left = 91
      Top = 303
      Width = 33
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '90')
      MaxLength = 2
      TabOrder = 4
      WantReturns = False
      WordWrap = False
    end
    object TrainerHPMin: TMemo
      Tag = 1
      Left = 91
      Top = 329
      Width = 33
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '40')
      MaxLength = 2
      TabOrder = 5
      WantReturns = False
      WordWrap = False
    end
  end
  object gbProtector: TPanel
    Left = 268
    Top = 19
    Width = 483
    Height = 424
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 5
    Visible = False
    object Label11: TLabel
      Left = 274
      Top = 25
      Width = 20
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Kind'
    end
    object Label25: TLabel
      Left = 267
      Top = 68
      Width = 27
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Name'
    end
    object Label26: TLabel
      Left = 270
      Top = 132
      Width = 25
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Label'
    end
    object Label27: TLabel
      Left = 280
      Top = 170
      Width = 16
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'File'
    end
    object Label28: TLabel
      Left = 265
      Top = 209
      Width = 29
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Macro'
    end
    object Label32: TLabel
      Left = 281
      Top = 247
      Width = 12
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'To'
    end
    object Label33: TLabel
      Left = 272
      Top = 269
      Width = 22
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Text'
    end
    object Label53: TLabel
      Left = 73
      Top = 402
      Width = 115
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Caption = 'Friends and Enemies'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Label53Click
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label78: TLabel
      Left = 268
      Top = 3
      Width = 80
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'New protector'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label118: TLabel
      Left = 90
      Top = 371
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
    object Label120: TLabel
      Left = 155
      Top = 371
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
    object Label55: TLabel
      Left = 90
      Top = 384
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
    object Label60: TLabel
      Left = 155
      Top = 384
      Width = 84
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'edit selected item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label86: TLabel
      Left = 265
      Top = 92
      Width = 29
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Pause'
    end
    object Label111: TLabel
      Left = 268
      Top = 46
      Width = 26
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Value'
    end
    object lstProtectors: TListBox
      Tag = 1
      Left = 6
      Top = 5
      Width = 252
      Height = 363
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = lbOwnerDrawVariable
      ItemHeight = 18
      TabOrder = 0
      OnDblClick = lstProtectorsDblClick
      OnDrawItem = lstProtectorsDrawItem
      OnKeyDown = lstProtectorsKeyDown
    end
    object chkProtectorsActive: TCheckBox
      Tag = 1
      Left = 6
      Top = 375
      Width = 74
      Height = 19
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Active'
      TabOrder = 16
      OnClick = BasicToolsSettings
    end
    object edtProtectorName: TEdit
      Left = 297
      Top = 65
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 3
    end
    object cmbProtectorKind: TComboBox
      Left = 297
      Top = 22
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csDropDownList
      TabOrder = 2
      OnChange = cmbProtectorKindCloseUp
      OnClick = cmbProtectorKindCloseUp
      OnCloseUp = cmbProtectorKindCloseUp
    end
    object chkProtectorLogout: TCheckBox
      Left = 263
      Top = 304
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Logout'
      TabOrder = 14
    end
    object chkProtectorScreenshot: TCheckBox
      Left = 263
      Top = 288
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Screenshot'
      TabOrder = 13
    end
    object chkProtectorSound: TCheckBox
      Left = 263
      Top = 151
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Sound'
      TabOrder = 6
      OnClick = ProtectorTextFields
    end
    object chkProtectorGoLabel: TCheckBox
      Left = 263
      Top = 113
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Cavebot Label'
      TabOrder = 4
      OnClick = ProtectorTextFields
    end
    object edtProtectorGoLabel: TEdit
      Left = 297
      Top = 129
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Enabled = False
      TabOrder = 5
    end
    object chkProtectorMacro: TCheckBox
      Left = 263
      Top = 189
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Macro'
      TabOrder = 8
      OnClick = ProtectorTextFields
    end
    object cmbProtectorMacro: TComboBox
      Left = 297
      Top = 205
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csDropDownList
      Enabled = False
      TabOrder = 9
      OnCloseUp = MacroCloseUp
      OnDropDown = MacroList
    end
    object chkProtectorPrivateMessage: TCheckBox
      Left = 263
      Top = 228
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Private Message'
      TabOrder = 10
      OnClick = ProtectorTextFields
    end
    object edtProtectorPrivateMessageTo: TEdit
      Left = 297
      Top = 244
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Enabled = False
      TabOrder = 11
    end
    object edtProtectorPrivateMessageText: TEdit
      Left = 297
      Top = 266
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Enabled = False
      TabOrder = 12
    end
    object chkProtectorCloseTibia: TCheckBox
      Left = 263
      Top = 320
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Close Tibia'
      TabOrder = 17
    end
    object chkProtectorShutdown: TCheckBox
      Left = 263
      Top = 336
      Width = 154
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Shutdown PC'
      TabOrder = 18
    end
    object btnProtector: TButton
      Left = 349
      Top = 359
      Width = 74
      Height = 32
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Save'
      TabOrder = 15
      OnClick = btnProtectorClick
    end
    object numProtector: TMemo
      Left = 297
      Top = 43
      Width = 62
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Enabled = False
      Lines.Strings = (
        '0')
      MaxLength = 7
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object cmbProtectorSoundfile: TComboBox
      Left = 297
      Top = 167
      Width = 177
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csDropDownList
      Enabled = False
      TabOrder = 7
      OnDropDown = cmbProtectorSoundfileDropDown
    end
    object cmbProtectorPause: TComboBox
      Left = 297
      Top = 87
      Width = 176
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 19
      Text = 'None'
      OnChange = cmbProtectorKindCloseUp
      OnClick = cmbProtectorKindCloseUp
      OnCloseUp = cmbProtectorKindCloseUp
      Items.Strings = (
        'All'
        'Automation'
        'None')
    end
  end
  object gbReview: TPanel
    Left = 268
    Top = 19
    Width = 550
    Height = 462
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 25
    Visible = False
    object Label114: TLabel
      Left = 8
      Top = 5
      Width = 85
      Height = 13
      Caption = 'Write a Review'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label115: TLabel
      Left = 8
      Top = 26
      Width = 27
      Height = 13
      Caption = 'Rate:'
    end
    object Label116: TLabel
      Left = 8
      Top = 45
      Width = 42
      Height = 13
      Caption = 'Message'
    end
    object Label122: TLabel
      Left = 144
      Top = 5
      Width = 49
      Height = 13
      Caption = 'Be polite'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label124: TLabel
      Left = 144
      Top = 19
      Width = 279
      Height = 13
      Caption = 'What you write here will be sent to our administrators and'
    end
    object Label125: TLabel
      Left = 144
      Top = 33
      Width = 201
      Height = 13
      Caption = 'will help bbot become increasingly better. '
    end
    object Label132: TLabel
      Left = 144
      Top = 46
      Width = 179
      Height = 13
      Caption = 'With respect, your criticism or praise.'
    end
    object cmbRateStars: TComboBox
      Left = 39
      Top = 22
      Width = 90
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Select'
      Items.Strings = (
        'Select'
        '1 Star'
        '2 Stars'
        '3 Stars'
        '4 Stars'
        '5 Stars')
    end
    object memoRateReview: TMemo
      Left = 8
      Top = 64
      Width = 539
      Height = 345
      TabOrder = 1
      OnChange = memoRateReviewChange
    end
    object btnRateSend: TButton
      Left = 344
      Top = 415
      Width = 203
      Height = 36
      Caption = 'Send review'
      TabOrder = 2
      OnClick = btnRateSendClick
    end
  end
  object gbProfilers: TPanel
    Left = 268
    Top = 19
    Width = 879
    Height = 702
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 26
    Visible = False
    object lvProfilers: TListView
      Left = 1
      Top = 4
      Width = 872
      Height = 693
      Columns = <
        item
          Caption = 'Name'
          Width = 400
        end
        item
          Caption = 'Calls'
          Width = 100
        end
        item
          Caption = 'Total'
          Width = 100
        end
        item
          Caption = 'Avg'
          Width = 100
        end
        item
          Caption = 'Max'
          Width = 100
        end>
      GridLines = True
      SortType = stData
      TabOrder = 0
      ViewStyle = vsReport
      OnCompare = lvProfilersCompare
    end
  end
  object gbSettingFile: TPanel
    Left = 268
    Top = 19
    Width = 368
    Height = 440
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 8
    Visible = False
    object Label9: TLabel
      Left = 12
      Top = 374
      Width = 19
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSettingsTitle: TLabel
      Left = 7
      Top = 10
      Width = 25
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Title'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lstConfigs: TListBox
      Left = 5
      Top = 28
      Width = 351
      Height = 334
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstConfigsClick
      OnDblClick = lstConfigsDblClick
    end
    object edtConfig: TEdit
      Left = 37
      Top = 370
      Width = 319
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 1
    end
    object btnConfig: TButton
      Left = 27
      Top = 401
      Width = 48
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Ok'
      TabOrder = 2
      OnClick = btnConfigClick
    end
    object btnConfigCancel: TButton
      Left = 82
      Top = 401
      Width = 104
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btnConfigClick
    end
  end
  object gbTradeHelper: TPanel
    Left = 268
    Top = 19
    Width = 228
    Height = 229
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 7
    Visible = False
    object Label2: TLabel
      Left = 13
      Top = 8
      Width = 39
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Watch:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label74: TLabel
      Left = 13
      Top = 25
      Width = 125
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Words (Word1, Word2...)'
    end
    object Label73: TLabel
      Left = 13
      Top = 109
      Width = 85
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Auto-Message:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 13
      Top = 126
      Width = 206
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Send on Trade is a Real Tibia feature'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtTHwatch: TEdit
      Tag = 1
      Left = 13
      Top = 42
      Width = 188
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 0
    end
    object chkTHwatch: TCheckBox
      Tag = 1
      Left = 13
      Top = 67
      Width = 76
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Active'
      TabOrder = 1
      OnClick = BasicToolsSettings
    end
    object edtTHmsg: TEdit
      Tag = 1
      Left = 13
      Top = 143
      Width = 187
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 2
      Text = 'Selling.... Buying....'
    end
    object chkTHmsg: TCheckBox
      Tag = 1
      Left = 13
      Top = 207
      Width = 98
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Trade Channel'
      TabOrder = 3
      OnClick = BasicToolsSettings
    end
    object chkTHmsgyell: TCheckBox
      Tag = 1
      Left = 13
      Top = 190
      Width = 45
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Yell'
      TabOrder = 4
      OnClick = BasicToolsSettings
    end
    object chkTHmsgsay: TCheckBox
      Tag = 1
      Left = 13
      Top = 171
      Width = 45
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Say'
      TabOrder = 5
      OnClick = BasicToolsSettings
    end
  end
  object gbSpecialSQMs: TPanel
    Left = 398
    Top = 302
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Special SQMs'
    UseDockManager = False
    ParentColor = True
    TabOrder = 15
    Visible = False
  end
  object gbCavebot: TPanel
    Left = 398
    Top = 142
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Cavebot'
    UseDockManager = False
    ParentColor = True
    TabOrder = 3
    Visible = False
  end
  object mmLooter: TMemo
    Tag = 1
    Left = 34
    Top = 203
    Width = 114
    Height = 113
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 23
    Visible = False
  end
  object gbAdvancedAttack: TPanel
    Left = 398
    Top = 122
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Advanced Attack'
    UseDockManager = False
    ParentColor = True
    TabOrder = 28
    Visible = False
  end
  object gbDebug: TPanel
    Left = 398
    Top = 182
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Debug'
    UseDockManager = False
    ParentColor = True
    TabOrder = 4
    Visible = False
  end
  object gbBotManager: TPanel
    Left = 398
    Top = 222
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Reconnect Manager'
    UseDockManager = False
    ParentColor = True
    TabOrder = 27
    Visible = False
  end
  object gbUserError: TPanel
    Left = 398
    Top = 262
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'User Error'
    UseDockManager = False
    ParentColor = True
    TabOrder = 29
    Visible = False
  end
  object gbMacros: TPanel
    Left = 398
    Top = 162
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Macros'
    UseDockManager = False
    ParentColor = True
    TabOrder = 10
    Visible = False
  end
  object vstMenu: TVirtualStringTree
    Left = -2
    Top = -1
    Width = 261
    Height = 638
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BorderStyle = bsNone
    ButtonStyle = bsTriangle
    BorderWidth = 1
    Color = 16707048
    Colors.BorderColor = 10707477
    Colors.DisabledColor = clGray
    Colors.DropMarkColor = 15385233
    Colors.DropTargetColor = 15385233
    Colors.DropTargetBorderColor = 15385233
    Colors.FocusedSelectionColor = 15385233
    Colors.FocusedSelectionBorderColor = 15385233
    Colors.GridLineColor = 15987699
    Colors.HeaderHotColor = clBlack
    Colors.HotColor = clBlack
    Colors.SelectionRectangleBlendColor = 15385233
    Colors.SelectionRectangleBorderColor = 15385233
    Colors.SelectionTextColor = clBlack
    Colors.TreeLineColor = 9471874
    Colors.UnfocusedColor = clGray
    Colors.UnfocusedSelectionColor = 13421772
    Colors.UnfocusedSelectionBorderColor = 13421772
    DefaultNodeHeight = 22
    Header.AutoSizeIndex = 0
    Header.MainColumn = -1
    LineMode = lmBands
    ScrollBarOptions.AlwaysVisible = True
    ScrollBarOptions.ScrollBars = ssVertical
    TabOrder = 30
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toAlwaysHideSelection]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    OnBeforeCellPaint = vstMenuBeforeCellPaint
    OnChange = vstMenuChange
    OnCollapsing = vstMenuCollapsing
    OnDrawText = vstMenuDrawText
    OnMeasureItem = vstMenuMeasureItem
    OnMouseDown = vstMenuMouseDown
    Columns = <>
  end
  object gbLooter: TPanel
    Left = 398
    Top = 202
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Looter'
    UseDockManager = False
    ParentColor = True
    TabOrder = 19
    Visible = False
  end
  object gbWarNet: TPanel
    Left = 398
    Top = 242
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'WarNet'
    UseDockManager = False
    ParentColor = True
    TabOrder = 6
    Visible = False
  end
  object gbDebugWalker: TPanel
    Left = 398
    Top = 282
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Debug Walker'
    UseDockManager = False
    ParentColor = True
    TabOrder = 31
    Visible = False
  end
  object gbKiller: TPanel
    Left = 398
    Top = 322
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Killer'
    UseDockManager = False
    ParentColor = True
    TabOrder = 2
    Visible = False
  end
  object gbFriendHealer: TPanel
    Left = 398
    Top = 342
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Friend Healer'
    UseDockManager = False
    ParentColor = True
    TabOrder = 17
    Visible = False
  end
  object gbAtkSequences: TPanel
    Left = 398
    Top = 362
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Attack Sequences'
    UseDockManager = False
    ParentColor = True
    TabOrder = 21
    Visible = False
  end
  object gbManaTools: TPanel
    Left = 398
    Top = 382
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Mana Tools'
    UseDockManager = False
    ParentColor = True
    TabOrder = 22
    Visible = False
  end
  object gbHealer: TPanel
    Left = 398
    Top = 402
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Healer'
    UseDockManager = False
    ParentColor = True
    TabOrder = 24
    Visible = False
  end
  object gbBasic: TPanel
    Left = 268
    Top = 19
    Width = 406
    Height = 348
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 14
    Visible = False
    object Label3: TLabel
      Left = 81
      Top = 279
      Width = 36
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'min cap'
    end
    object Label54: TLabel
      Left = 333
      Top = 109
      Width = 34
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'HH:MM'
    end
    object chkTray: TCheckBox
      Tag = 1
      Left = 9
      Top = 5
      Width = 117
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'BBot Tray Icon'
      TabOrder = 1
      OnClick = chkTrayClick
    end
    object chkXRay: TCheckBox
      Tag = 1
      Left = 184
      Top = 5
      Width = 63
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'XRay'
      TabOrder = 0
      OnClick = BasicToolsSettings
    end
    object chkAutoOpenBP: TCheckBox
      Tag = 1
      Left = 9
      Top = 32
      Width = 133
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Open Backpacks'
      TabOrder = 4
      OnClick = BasicToolsSettings
    end
    object chkEat: TCheckBox
      Tag = 1
      Left = 9
      Top = 166
      Width = 65
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Eat Food'
      TabOrder = 10
      OnClick = BasicToolsSettings
    end
    object chkEatFoodGround: TCheckBox
      Tag = 1
      Left = 29
      Top = 194
      Width = 86
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'From Ground'
      TabOrder = 12
      OnClick = BasicToolsSettings
    end
    object chkAntiIDLE: TCheckBox
      Tag = 1
      Left = 185
      Top = 112
      Width = 85
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Anti AFK Kick'
      TabOrder = 9
      OnClick = BasicToolsSettings
    end
    object chkFishing: TCheckBox
      Tag = 1
      Left = 9
      Top = 221
      Width = 57
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Fishing'
      TabOrder = 14
      OnClick = BasicToolsSettings
    end
    object chkFishingWorm: TCheckBox
      Tag = 1
      Left = 29
      Top = 247
      Width = 83
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Need Worm'
      TabOrder = 16
      OnClick = BasicToolsSettings
    end
    object numFisherCap: TMemo
      Tag = 1
      Left = 29
      Top = 275
      Width = 46
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '10')
      MaxLength = 5
      TabOrder = 18
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object chkAmmoCounter: TCheckBox
      Tag = 1
      Left = 184
      Top = 167
      Width = 95
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Ammo Counter'
      TabOrder = 13
      OnClick = BasicToolsSettings
    end
    object chkAutoDropVials: TCheckBox
      Tag = 1
      Left = 9
      Top = 140
      Width = 115
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Drop Empty Vials'
      TabOrder = 8
      OnClick = BasicToolsSettings
    end
    object chkGroup: TCheckBox
      Tag = 1
      Left = 184
      Top = 140
      Width = 107
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Stack Items'
      TabOrder = 11
      OnClick = BasicToolsSettings
    end
    object chkOtMoney: TCheckBox
      Tag = 1
      Left = 184
      Top = 248
      Width = 143
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '[OT] Auto Change Gold'
      TabOrder = 19
      OnClick = BasicToolsSettings
    end
    object chkReconnect: TCheckBox
      Tag = 1
      Left = 184
      Top = 59
      Width = 190
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Reconnect when disconnected'
      TabOrder = 3
      OnClick = BasicToolsSettings
    end
    object chkFrameRate: TCheckBox
      Tag = 1
      Left = 184
      Top = 221
      Width = 120
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Framerate Limit'
      TabOrder = 17
      OnClick = BasicToolsSettings
    end
    object chkSS: TCheckBox
      Tag = 1
      Left = 184
      Top = 194
      Width = 202
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Screenshot Advancements and Death'
      TabOrder = 15
      OnClick = BasicToolsSettings
    end
    object cmbLightHack: TComboBox
      Tag = 1
      Left = 184
      Top = 274
      Width = 198
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Style = csOwnerDrawFixed
      ItemHeight = 18
      TabOrder = 21
      OnChange = BasicToolsSettings
      OnCloseUp = BasicToolsSettings
    end
    object chkServerSaveLogout: TCheckBox
      Tag = 1
      Left = 184
      Top = 86
      Width = 125
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Server Save Logout:'
      TabOrder = 5
      OnClick = BasicToolsSettings
    end
    object numSSLogoutHH: TMemo
      Tag = 1
      Left = 312
      Top = 86
      Width = 35
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '07')
      MaxLength = 5
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object numSSLogoutMM: TMemo
      Tag = 1
      Left = 352
      Top = 86
      Width = 35
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '55')
      MaxLength = 5
      TabOrder = 7
      WantReturns = False
      WordWrap = False
      OnKeyPress = OnKeyPressNumOnly
    end
    object chkLevelSpy: TCheckBox
      Tag = 1
      Left = 184
      Top = 32
      Width = 82
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Level Spy'
      TabOrder = 2
      OnClick = BasicToolsSettings
    end
    object chkMapClick: TCheckBox
      Tag = 1
      Left = 9
      Top = 302
      Width = 143
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Map Click'
      TabOrder = 20
      OnClick = BasicToolsSettings
    end
    object chkAutoMinimizeBP: TCheckBox
      Tag = 1
      Left = 29
      Top = 59
      Width = 86
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Minimizer'
      TabOrder = 22
      OnClick = BasicToolsSettings
    end
    object chkAutoMinimizeBPsInventory: TCheckBox
      Tag = 1
      Left = 29
      Top = 86
      Width = 129
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Inventory is minimized'
      TabOrder = 23
      OnClick = BasicToolsSettings
    end
    object chkAutoMinimizeBPsMinimizedGetPremium: TCheckBox
      Tag = 1
      Left = 28
      Top = 112
      Width = 153
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Get Premium is minimized'
      TabOrder = 24
      OnClick = BasicToolsSettings
    end
  end
  object gbVariables: TPanel
    Left = 398
    Top = 422
    Width = 127
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    Caption = 'Variables'
    UseDockManager = False
    ParentColor = True
    TabOrder = 11
    Visible = False
  end
  object gbMacroEditor: TPanel
    Left = 263
    Top = 19
    Width = 538
    Height = 662
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 1
    Visible = False
    object lblMacroEditorCopy: TLabel
      Left = 501
      Top = 30
      Width = 28
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Copy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblMacroEditorCopyClick
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label117: TLabel
      Left = 40
      Top = 6
      Width = 27
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Name'
    end
    object Label119: TLabel
      Left = 42
      Top = 56
      Width = 25
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Code'
    end
    object Label24: TLabel
      Left = 353
      Top = 31
      Width = 13
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'ms'
    end
    object Label121: TLabel
      Left = 462
      Top = 30
      Width = 36
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Debug'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Label121Click
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label140: TLabel
      Left = 406
      Top = 30
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
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object Label95: TLabel
      Left = 30
      Top = 31
      Width = 39
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Execute'
    end
    object Label4: TLabel
      Left = 408
      Top = 644
      Width = 121
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Copy current position'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Label4Click
      OnMouseEnter = LinkEnter
      OnMouseLeave = LinkLeave
    end
    object numMacroEditorDelay: TMemo
      Left = 286
      Top = 26
      Width = 62
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Alignment = taCenter
      Lines.Strings = (
        '1000')
      MaxLength = 5
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      OnChange = edtMacroEditorNameChange
      OnKeyPress = OnKeyPressNumOnly
    end
    object edtMacroEditorCode: TEdit
      Left = 72
      Top = 52
      Width = 457
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 5
    end
    object edtMacroEditorName: TEdit
      Left = 72
      Top = 2
      Width = 137
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 0
      OnChange = edtMacroEditorNameChange
    end
    object btnMacroBack: TButton
      Left = 455
      Top = -1
      Width = 73
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Back'
      TabOrder = 2
      OnClick = btnMacroBackClick
    end
    object btnMacroDone: TButton
      Left = 394
      Top = -1
      Width = 59
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Done'
      TabOrder = 4
      OnClick = btnMacroDoneClick
    end
    object btnPasteEdit: TButton
      Left = 300
      Top = -1
      Width = 92
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Paste-Edit'
      TabOrder = 1
      OnClick = btnPasteEditClick
    end
    object sMacro: TSynEdit
      Left = 12
      Top = 84
      Width = 517
      Height = 556
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 6
      CodeFolding.GutterShapeSize = 11
      CodeFolding.CollapsedLineColor = clGrayText
      CodeFolding.FolderBarLinesColor = clGrayText
      CodeFolding.IndentGuidesColor = clGray
      CodeFolding.IndentGuides = True
      CodeFolding.ShowCollapsedLine = False
      CodeFolding.ShowHintMark = True
      UseCodeFolding = False
      Gutter.DigitCount = 2
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -13
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.ZeroStart = True
      RightEdge = 120
      OnChange = sMacroChange
      FontSmoothing = fsmNone
    end
    object rdMacroOnce: TRadioButton
      Left = 72
      Top = 31
      Width = 70
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Once'
      TabOrder = 7
      OnClick = MacroExecuteMethod
    end
    object rdMacroManual: TRadioButton
      Left = 142
      Top = 31
      Width = 71
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Manual'
      TabOrder = 8
      OnClick = MacroExecuteMethod
    end
    object rdMacroAuto: TRadioButton
      Left = 213
      Top = 31
      Width = 70
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Automatic'
      Checked = True
      TabOrder = 9
      TabStop = True
      OnClick = MacroExecuteMethod
    end
  end
  object gbWarbot: TPanel
    Left = 268
    Top = 19
    Width = 214
    Height = 409
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelOuter = bvNone
    UseDockManager = False
    ParentColor = True
    TabOrder = 16
    Visible = False
    object Label57: TLabel
      Left = 170
      Top = 57
      Width = 18
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'End'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label64: TLabel
      Left = 9
      Top = 218
      Width = 32
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Shoot:'
    end
    object Label65: TLabel
      Left = 45
      Top = 218
      Width = 42
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Pg Down'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label62: TLabel
      Left = 9
      Top = 238
      Width = 69
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Change Rune:'
    end
    object Label61: TLabel
      Left = 82
      Top = 238
      Width = 28
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Pg Up'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label47: TLabel
      Left = 177
      Top = 304
      Width = 32
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Target'
    end
    object cmbCombo: TComboBox
      Tag = 1
      Left = 7
      Top = 372
      Width = 192
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 13
      OnClick = edtComboSpellClick
      OnCloseUp = onAtkSeqCloseUp
      OnDropDown = onAtkSeqDropDown
    end
    object edtLeaders: TEdit
      Tag = 1
      Left = 7
      Top = 345
      Width = 192
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 12
      Text = 'Leader1, Leader2, Leader3....'
      OnClick = edtComboSpellClick
    end
    object chkWBCActive: TCheckBox
      Tag = 1
      Left = 9
      Top = 255
      Width = 194
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Combo Leader:'
      TabOrder = 7
      OnClick = WarToolsSettings
    end
    object chkMWallFrontEnemies: TCheckBox
      Tag = 1
      Left = 10
      Top = 52
      Width = 158
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Magic Wall in front of target'
      TabOrder = 1
      OnClick = WarToolsSettings
    end
    object chkDash: TCheckBox
      Tag = 1
      Left = 10
      Top = 78
      Width = 74
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Dash'
      TabOrder = 2
      OnClick = WarToolsSettings
    end
    object chkLockTarget: TCheckBox
      Tag = 1
      Left = 10
      Top = 0
      Width = 88
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Lock Target'
      TabOrder = 0
      OnClick = WarToolsSettings
    end
    object chkAim: TCheckBox
      Tag = 1
      Left = 10
      Top = 103
      Width = 56
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Aimbot'
      TabOrder = 3
      OnClick = WarToolsSettings
    end
    object cmbAim1: TComboBox
      Tag = 1
      Left = 7
      Top = 163
      Width = 193
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 5
      OnClick = cmbAim1Click
      OnCloseUp = onAtkSeqCloseUp
      OnDropDown = onAtkSeqDropDown
    end
    object cmbAim2: TComboBox
      Tag = 1
      Left = 7
      Top = 190
      Width = 193
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 6
      OnClick = cmbAim1Click
      OnCloseUp = onAtkSeqCloseUp
      OnDropDown = onAtkSeqDropDown
    end
    object cmbAim3: TComboBox
      Tag = 1
      Left = 7
      Top = 135
      Width = 193
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 4
      OnClick = cmbAim1Click
      OnCloseUp = onAtkSeqCloseUp
      OnDropDown = onAtkSeqDropDown
    end
    object chkWBCattack: TCheckBox
      Tag = 1
      Left = 16
      Top = 281
      Width = 74
      Height = 18
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '-> Attack'
      TabOrder = 8
      OnClick = WarToolsSettings
    end
    object chkComboSay: TCheckBox
      Tag = 1
      Left = 16
      Top = 303
      Width = 94
      Height = 17
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '-> Say Combo'
      TabOrder = 10
      OnClick = WarToolsSettings
    end
    object chkWCBparalyzed: TCheckBox
      Tag = 1
      Left = 8
      Top = 325
      Width = 168
      Height = 16
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '-> Combo Paralyzed Enemies'
      TabOrder = 11
      OnClick = WarToolsSettings
    end
    object edtComboSay: TEdit
      Left = 110
      Top = 301
      Width = 64
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 9
      Text = 'exiva'
      OnChange = WarToolsSettings
    end
    object chkSuperFollow: TCheckBox
      Tag = 1
      Left = 10
      Top = 25
      Width = 88
      Height = 23
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Super Follow'
      TabOrder = 14
      OnClick = WarToolsSettings
    end
  end
  object imgMenu: TImageList
    Height = 32
    ShareImages = True
    Width = 32
    Left = 94
    Top = 4
    Bitmap = {
      494C010119004402040020002000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000080000000E0000000010020000000000000C0
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000010104001F1F2000050508000000
      000000000000000000000E0F1100131415001617170000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000004040700181817001D1D1D000F0F0E000403
      070000000000141516001C1C1C001C1C1C0007070A0005040800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001B1B1C002323230023232300141414001415
      16000000000004040700060609001F1F20000707090015161600000000000000
      00000E0F11001314150016171700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000005050800090A0B000D0E0E001A1A1A001D1D1D00131313002221
      23000505080003030600181817001D1D1D000F0F0E0004030700000000001415
      16001D1D1D001C1C1C0008080B00050408000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000004040600060606001B1B1B001A1A1A0010101000050505000F0F
      0F000B0B0B0019191A0022222200232323001414140012131500000000000404
      0700242423002323230014141500161717000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000F0F0E0008080800090909000D0D0D001F1F1F00252525001717
      1800121313000D0E0E001A1A1A001D1D1D0013131300201F2100050508000202
      0200252525001F1F1F0009090C00050508000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000303060010101000606061005B5B5B000B0B0B00292A2D00474646000404
      0600060606001B1B1B001A1A1A001010100005050500101010000B0B0B000D0D
      0D001C1C1C001818180009090A00040407000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000404
      0800201F1D0003010000020100001110110012181B0092350200822905000F0E
      0D0008080800090909000D0D0D001F1F1F00252525001D1D1D00181818002020
      20000B0B0B001111110006060A00040407000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000005050500000000000009
      0F00182C4200106393001070A90005213600500E0C00E5A55300030306001010
      1000606061005B5B5B000B0B0B002A2B2E00494848003B3837000B0C0C000E0E
      0E00111111000B0B0B00070709000B0C0E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000505050015151500040304000E14
      180008090B00227BB400000A090008121B000400000004040800201F1D000301
      0000020100001110110012181B009436020096300600570A040029201E002424
      24001F1F1F001E1F1E002020210008080B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000020201000F0F0F00010101002D2D2D0027272A0020201F001616
      16001E1D1D00020406000B0C0F00050505000000000000090F00182C42001063
      93001070A90006223700500E0C00EBA9550099360B005F0E0400261B1B001716
      1600121211001616160017181900131314000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000444444006F6F6E002323230003040400030000000E0B0B000000
      0000252424001B1B1B000505050015151500040304000E14180008090B00227B
      B400010B0A000A1520004D060100BF51060090310600381312001E1C1B000A0B
      0C000C0C0D00090A0B001E1E1E0009090C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005A5A5B0040403F0007060600030000000DD5DA00121E1F00081F
      20000F0F0F00010101002C2C2C0027272A0020201F00161616001F1E1E000305
      07000B0C0F000E304900514F5A004D090000500E0800161B1C000F0F11008A8A
      8A00949494009090900000000000050506000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000001010100171E24000E090400001329000015300007010100020000004444
      44006F6F6E002323230003040400030000000E0B0B0000000000282727001E1E
      1E001F1E1D002537450011568B000B0A0A00131617002B2B2B00545354003B3B
      3B00080808001B1B1B0015151500040406000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE000E0C2D0013110E00001630006689A9007EABD100091F3600082B46005959
      5C0040403F0007060600030000000DD5DA00121E1F000E3B3D00010505001313
      1300161616000505050015283C001F1E1C000E0E0D002A2A2A00505050005F5F
      5F001A1A1A002222220018181800040406000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000002151500089F9B000404
      0500443F500032628D001F2631009CC7ED005F7E99005B7E9E0001010200171E
      24000E09040000132900001530000701010005000000000000005A5A5A002F2F
      2F0018181800040406001C1C1B000D0B0B00201D1B0066666600424242000505
      0500404040000B0B0B001C1D1C00242325000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006061300383CBD000506
      0500625F5D006D93B3006D91AF009DC8ED00698EAF002D547A000E0C2D001311
      0E00001630006689A9007EABD100091F36000E4B7A00352A9100030400006B6C
      6C00686868000606090000000100537087006A8FAE003A393600111111002727
      2700121212000D0D0C0015151500111213000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000060613003E3BC6000E0E
      0F0000000000A2ABB6008C979E0002151500089F9B0004040500443F50003262
      8D001F2631009CC7ED0061809C006991B50026537C000F132B00081A1800003F
      3B0070737300505050002121210016120F002A5D88000C090500343434000C0C
      0C00090A0B000B0B0C00090A0B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000005040E001A1853000F0F
      1300E2E2E300D7D8D8008B8B8C0006061300383CBD0005060500625F5D006D93
      B3006D91AF009DC8ED0079A4C90038689500A8A6A50000000100080918001415
      480031313300656565001D1C1D0010101000090B0D00353333000B0B0B000E0E
      0F008A8A8A009494940090909000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000005050A0018164D000E0E
      0F00F9F9FB00E9E9E900B9B9BB00060613003E3BC6000E0E0F0000000000A4AD
      B80098A2A900ACB4BA00C3CAD200B8B8B7007576770001010200050511001614
      4E002E2E3100313131001F1F2000272727004646470007080700242424005352
      53003B3B3B00080808001B1B1B00151515000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000002010600423D
      D60047482E00F8F8F800D6D6D6007E7E82001A1853000F0F1300E2E2E300D9DA
      DA0099999900DEDEDE00BFBFBF00878788007474740000000000403AD3000000
      00003A3A3B0031313100474747001F202000080808000B0B0A00292929005050
      50005F5F5F001A1A1A0022222200181818000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000302
      06001F1C7600504E4B00484847003938380018164C000E0E0F00F9F9FB00EBEB
      EB00CECECE00E7E7E700C2C2C200969696000000000001010000433CE2000E0E
      0600101010000C0C0C0009090900161615000C0A0A001F1C1A00666666004242
      420005050500404040000B0B0B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE000E0C
      2D0009060500238DDE003C35CA00265FCD001C175900433EDA0047482E00F8F8
      F800DADADA00DDDDDD00CBCBCB002525250008080A00000000004B44FB000001
      00004D4E4E004D4D4D000404060000000100526F86006A8FAE003A3936001111
      1100272727001212120004040400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000002151500089F9B0004040500433E
      4F0031608A000A101700344254001F2B380002080E00031116001F1C7600504E
      4B004A4A49004E4D4B003C3C3A00000000000A0711002220700004060D000819
      1800003E3A006E7171004F4F4F002121210016120F002A5D88000C0905003434
      34000C0C0C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000006061300383CBD0005060500625F
      5D006C91B1006D91AF009BC6EB006E95B80005051200373BBC00030201002790
      E0003D36CB002965DA004338C9003F38CE002287CD00413E3F00000002000708
      17001415480031313300656565001D1C1D0010101000090B0D00353434000B0B
      0B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000060613003E3BC6000E0E0F000000
      0000A4ADB80098A2A900AAB2B800AFB6BE00060613003D3AC5000D0D0F004C4F
      5400383B4400343940003B3D440043454D004246490072737400010102000505
      110016144E002E2E3100313131001F1F2000272727004646470007070600FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000005040E001A1853000F0F1300E2E2
      E300D9DADA0099999900DEDEDE00BCBCBC004E4D52001A1853000E0E1200E2E2
      E300D9DADA0099999900DEDEDE00BFBFBF00878788007373730000000000403A
      D300000000003A3A3B0031313100474747002020200008080800030303000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000005050A0018164D000E0E0F00F9F9
      FB00EBEBEB00CECECE00E7E7E700BEBEBE006C6C6D0017154B000E0E0F00F9F9
      FB00EBEBEB00CECECE00E7E7E700C2C2C200969696000000000001010000433C
      E2000E0E0600101010000C0C0C00090909000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000002010600443FDB004748
      2E00F8F8F800DADADA00DDDDDD00CACACA002323230004040700413CD1004748
      2E00F8F8F800DADADA00DDDDDD00CBCBCB002525250008080A00000000004C45
      FD00FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000040309001F1C
      7600504E4B004A4A49004E4D4B003C3C3A00000000000A0712000C0B26001F1C
      7600504E4B004A4A49004E4D4B003C3C3A00000000000A071100222070000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000300
      00002592E6003D35CC002865DB004236C9003F37CF002287CC00030003000300
      00002592E6003D35CC002865DB004236C9003F37CF002288CE00030002000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000002070D0003030B0002050C0003020A0003030B0022262B00000000000000
      000002070D0003030B0002050C0003020A0003030B0002080E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00F7F7F700F0F0
      F000ECECEC00EAEAEA00EBEBEB00EEEEEE00F0F0F000F5F5F500FBFBFB00FCFC
      FC00FDFDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AFB0B00016060C001B0006007B757700FBFBFB000000000000000000D4D5
      D600170B13001B0006006B626400FAFAFA000000000000000000000000000000
      00000000000000000000E7E6E500C7C7C600C6C5C400C2C2C100C6C4C300C6C4
      C300C6C4C300C5C3C200C5C3C200C7C4C300C1C2C300C5C6C700BFC1C100C3C4
      C500C4C5C600D4D5D500F9F9F900000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EDED
      ED00C7C7C700BABABA00B5B5B500ACACAC0098979600827C7400776D5F007265
      540071624F0070614D0070614F007164550074685B00776F65007E7A74008886
      8500939393009E9E9E00ABABAB00B3B3B300B6B6B600B8B8B800BABABA00C7C7
      C700E6E6E600FBFBFB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F8F8
      F8006C6569004D040700670202002C000000817D7D00FDFDFD00FDFDFD00928D
      8E0046060A006E02020034000000736D6E000000000000000000000000000000
      0000F9F8F800A39E9A007A756F00827C77007D7872007F7974007B7671007B77
      72007A7671007D7973007975700076726D007B7773007A767200797671007A76
      72007B77720083817D00AFAEAE00D8D7D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C3C3C3008484
      84008A8A8A00909090009293930094939400979695009F9C9700A7A19A00ABA4
      9C00ACA59D00ADA69E00ADA69E00ADA69E00ABA59E00A7A39D00A3A09C009D9C
      9A00999898009696950094949500929292008F8F8F008E8E8E008C8C8C008080
      800084848400CACACA00F8F8F800000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F3F5
      FA005378E9006B7DE200C2C7F500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE0000000000CBCC
      CE002E080C005E020200570000005902020014020300DBDBDB00ECEDED00280A
      0C0065020200640000005D020200160002000000000000000000000000000000
      0000817773009C979400D2CECC00D5D0CE00D1CDCB00D6D1CF00DAD7D400DAD8
      D500DDDAD800DCDAD700E3E1DE00E9E6E400E7E3DF00E6E3DE00E7E4DF00F0EC
      E800ACA8A40093908B0086827E0084817F00BABABA00EDEDEE00000000000000
      00000000000000000000000000000000000000000000CACACA008C8C8C00B3B3
      B300C4C4C400CBCBCB00C7C7C700C9C9C900CCCCCC00CECFCF00D1D1D300D3D3
      D400D4D5D600D5D6D700D5D6D700D5D6D700D4D5D600D2D3D300D0D1D100CDCD
      CD00C9C9C900C4C4C400BFBFBF00B9B9B900B5B5B500AFAFAF00ABABAB00ADAD
      AD009D9D9D007C7C7C00D8D8D800FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CED6EA005270
      B500548BEE003B59E5003A4FE1004553DF00777BE500B5B5F000F3F3FD00F4FB
      F800F4F8F6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE00B5B3B300A7A6A700ABACAC007170
      6E0019070300250000002E000000410000001B0B0D00C9C9C9009FA0A0001F08
      0B004B0000005B0000005700000018020600000000000000000000000000DCDA
      D600887E7B00D2D0D000D5D7D800D5D6D700CFD0D200D5D6D800DEE1E200E4E7
      E900E0E3E400E3E7E800F5F8FA00F4F8F900F6F7F800F9FAFB00000000000000
      0000C2C4C5008A898500D1CEC9009997950079787700A9AAAB00F6F6F6000000
      0000000000000000000000000000000000000000000096969600B2B2B200D1D1
      D100D0D0D00086868600686868006A6A6A006C6C6C006D6D6D006E6E6E006F6F
      6F006F6F6F00707070006F6F6F006F6F6F006E6E6E006E6E6E006C6C6C006969
      69006767670064646400616161005F5F5F005C5C5C00575757005D5D5D008D8D
      8D00B1B1B1008F8F8F00A2A2A200F8F8F8000000000000000000000000000000
      000000000000000000000000000000000000F4DDCA00F5CB9900395BAA00395B
      AA005594F2003C64EA003B5AE5003A51E1003947DD00383EDA003837D600689F
      9C006FD0990082D0AA00BBE3CF00F4FAF7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B6B5B400421C0A000F06020006070900190C
      0600270E0200070300000E0808001F060300180907005D5A5800200E0500200A
      03002D070600450000005000000016010500000000000000000000000000BDBC
      BB00B3ACAA00D4D3D2008C8E8E008F919000D1D3D200D7D9D8009C9E9D009A9A
      9A00E2E3E200F3F4F300ADAEAD00A6A7A700F7F5F600F4F2F300A8A6A700ADAC
      AD00949294007E7C7A00DEDBD800DDDBDA00ACA9A70076747200A7A5A400E3E4
      E40000000000000000000000000000000000E7E7E70099999900C8C8C800E8E8
      E8009F9F9F00161616001F1F1F00202020002020200020202000202020002020
      200020202000202020001F1F1F001E1E1E001D1D1D001D1D1D001B1B1B001818
      18001616160014141400111111000F0F0F000D0D0D000A0A0A00080808006767
      6700BABABA00A5A5A50085858500F6F6F6000000000000000000000000000000
      00000000000000000000FAF1EA00E3A87B00DD915400F7D5A400395BAA00395B
      AA00569CF6003D70EF003C66EA003B5CE6003A52E2003949DE003940DA00216B
      57007BD6A0004ABA830048B57F0047AF7C007FC5A200AED8C300E8F4EE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBEC000461E0A0093310200230F0500120E0C00401B
      09005A1E0100240A0000170F0B00190B04002C0E00001E0800003B1302003115
      0600211009002C0400004200000013000200000000000000000000000000BEBB
      B900BAB6B400858484005C5C5B0042424200ADADAC009A9A99005F5F5E004F4E
      4E00AEADAD00BDBCBC005B5A5A005D5C5C00A1A1A000F3F3F2006C6C6B003938
      38008C8B8B00817E7D00EBE7E700E3E2E200CDCBCB00B7B2AF007A757000A7A5
      A400F5F5F500000000000000000000000000E4E4E400AEAFB000DDDDDD00E8E8
      E800CBCBCB005C5C5C0051515100545454005555550056565600575757005757
      5700575757005757570056565600565656005555550055555500545454005252
      52004F4F4F004D4D4D004A4A4A0047474700434343003D3D3D004D4D4D00A9A9
      A900C6C6C600A2A2A3007F7F7F00F7F7F7000000000000000000000000000000
      000000000000FCFCFC00D98B4F00DA8C5000DF935700F7D5A400395BAA00395B
      AA0057A5F8003F7CF3003E71EF003D67EB003C5EE7003B54E3003A4ADF00216E
      58007BD6A0004ABB840048B6800047B07C0045AB790044A5750042A072000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000363737008C2D0000822B00001B0E0700150700004716
      00006A230000491700002D0E00001E090000381200005E1F0000642100004516
      000046160000400F00003502020013040300000000000000000000000000C4C0
      BD00B0AEAB003F3E3E00CDCDCD00A1A1A100595959004C4C4C00CBCBCB00C0C0
      C000575858005B5B5B00D0D0D000E2E2E2005050500000000000C9C9C9006767
      6700BEBEBF00807E7900FEFCFA00E8EAEA00DDE0E100D4D3D300B9B4B1007774
      7100AAABAB00EBECEC000000000000000000F6F6F600B1AFAC00F9FAFB00E7E7
      E700EEEEEE00F2F2F200F0F0F000F4F4F400F8F8F800FBFBFB00FBFBFB00FBFB
      FB00FBFBFB00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FAFA
      FA00F5F5F500F0F0F000EBEBEB00E5E5E500DFDFDF00D8D8D800D6D6D600D4D4
      D400BABABA008C8C8E0087868500F7F7F7000000000000000000000000000000
      0000F6F6F600D4D4D400D98B4F00DC8F5200E1965900F7D5A400395BAA00395B
      AA0059ADF9004187F5003F7DF3003E73F0003D69EC003C5FE7003B55E3002170
      59007BD6A0004ABC850049B7810047B17D0046AC790044A6760043A172000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2C4C600572C170096320000551C0000160F0B001D0B0200210B
      00003B13000046160000321000002B0E00005A1D0000A0350000B13B00007A28
      00006D2400005C18020022050300716C6C00000000000000000000000000C5C3
      BF00ADABA7003E3D3E00CFCFCF00A5A5A5005757570046464600D2D2D200C3C3
      C3005858580056565600D1D1D100EAEAEA004B4B4B0000000000BFBFBF006B6B
      6B00D6D7D70088858000F9F6F30000000000E4E7E900D5D8D900CFD0CE00B2AE
      AC007A797800B6B6B5000000000000000000F7F7F700C2976500E0E1E300FEFF
      FF00F4F4F500F6F6F700FAFAFB00FBFDFD00FEFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD00FBFB
      FB00F8F8F800F4F4F400EEEFEF00EAEAEB00E6E6E700E2E2E200DDDDDD00C5C7
      C8009A9FA400816E5900958E8600FBFBFB00000000000000000000000000F9F9
      F900D7D7D700CCCCCC00D98B4F00DE925500E3995C00F8D5A500395BAA00395B
      AA005AB6FA004393F7004189F6003F7FF4003E75F1003D6BEC003C61E8002273
      5A007BD6A0004ABD850049B8820047B27E0046AD7A0044A7770043A273000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00616263007D2A0200822C02002F0F000012060400140501000D04
      0000190800002B0E00002E0F00005C1E000098320000AC390000A93700009130
      0000712500003E10000047413F00EAEAEA00000000000000000000000000BFBD
      B800C0BCB9005E5E5F007E7E7E005E5E5E009F9F9F0075757500757575007474
      74009A9A9A0091919100747474008A8A8A008C8C8C00F3F3F300737373005E5E
      5E0000000000C9C6C300CCCAC60000000000F6F7F800ECEFF000D5D7D600DAD7
      D7009997950084828000D5D4D30000000000F8F8F800E5984300DBAE7B00D5D2
      CD00E7E7E900E6E8EB00E5E8EA00E5E7EA00E5E7EA00E5E7EA00E5E7EA00E5E6
      E900E5E6E900E5E6E900E4E6E900E4E5E800E4E5E800E7E8E900E6E6E600E7E7
      E700E9E9E900E8E8E900E3E4E600E0E2E500E0E2E500E1E4E700D9DBDE00ADAC
      AD00A2856700A15E0F00AAA49E00000000000000000000000000F8F8F800E3E3
      E300D7D7D700CFCFCF00DA8D5100E0945700E59B5E00F8D6A600395BAA00395B
      AA005CBFFB00459EF9004394F700418AF6003F80F4003E76F1003D6CED002276
      5B007BD6A0004BBD850049B9830048B47F0046AE7B0045A8770043A374000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CCCED000582E180093300000451700001504000043000000380000001003
      0000230B00002E0F00005E1F000097310000A63600009B3300009B330000A737
      00009B3200007C2800005A3B2C00C2C0BF00000000000000000000000000BDBA
      B700BEBAB700C7C8C8005959590076767600D6D6D600CBCBCB006B6B6B007777
      7700EBEBEB00E3E3E300767676007C7C7C00F7F7F700E9E9E90071717100ABAB
      AB0000000000FFFFFE00C1C0BE00D6D5D400FFFDFC00F2F1F000E3E2E100D4D1
      CE00D0CDC80087837F00AAA8A900FAFAFA0000000000D1A16900FFDA8800EFE4
      AA00DEBF8700D9AF7700D9AE7400DBB17600DAB27600D8B37900D8B57B00D8B8
      7E00D8BA8000D8BC8200D7BD8400D8BF8600D3BA8000918A7800A4A5A8007E7E
      7E0046474800625E5500BCA27600D6B37E00D6B07B00D6AC7700D7A46E00E198
      5500E0842100A4641800D1D1D000000000000000000000000000F4F4F400E6E6
      E600DBDBDB00D2D2D200DC905300E2975A00E79E6000F9D7A700395BAA00395B
      AA005EC7FD0047AAFB0045A0F9004496F800428CF6004082F4003E78F2002279
      5C007BD6A0004BBE86004ABA830048B5800047AF7C0045AA780044A474000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ACAFB100642506007F2B0200200900002A000000550000004D0000001905
      0000220B00004C18000092300000A235000099320000A1340000A7370000A436
      00009932000090300200802A0000422D2400000000000000000000000000C0BE
      B900B9B6B300D4D3D400CCCCCC00CECECE00C6C6C600D9D9D900DADADA00DBDB
      DB00E1E1E100E4E4E400EEEEEE00ECECEC00E8E8E800FBFBFB0000000000F0F0
      F000FAFAFA00FDFCFD00FDFBFB00C5C2C200C2BEBE00C1BDBD00B7B4B300A9A7
      A400B8B6B300A8A5A1007C797500CECDCD0000000000D4C9BD00FFC36700FFFF
      E600FFF0AB00FFCD7200F9B24F00EFA33F00FBB65000FFC35D00FFCB6800FFCF
      6C00FFD26E00FFD47100FFD57300FFD67500FFDA750094815800A2A5AB007A7A
      7A002324250025221D00BB935400FCC06600FFC06400FFB65B00FFAA5000F898
      3A00D97B0B009E8A7200FEFEFE0000000000000000000000000000000000FAFA
      FA00EEEEEE00DCDCDC00DE925600E49A5C00E9A06200F9D7A800395BAA004067
      B00065D4FE0056C1FD0050B3FB0047A3F9004498F800428EF6004084F500237C
      5E007BD6A0004BBE86004ABB840048B6800047B07C0045AB790044A575000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00828586004A1C050040120000320100002D00000025000000180200001F09
      00003E140000882C0000A03500009D340000A7370000A9370000943100007E29
      0000822B0000912F0000AC3902002F0F0000000000000000000000000000C2BE
      BB00BFBDBA00A6A5A500343434002F2F2F00ABABAB00C5C5C500444444004444
      4400CCCCCC00CCCCCC003E3E3E0038383800B2B2B200F5F5F500585858004949
      4900D0D0D000000000006060600050505000C1C1C100000000006C6C6B00504F
      4F00BABCBE00D1CFCC00726D6800C0BDBC000000000000000000D1A36B00FFE9
      B300FFFFF100FFEDA700FAB95900E98C2200E38F3300E7993B00F0A54100E8AA
      4D00E6B15800F5C26500FFD07300FFD47700FFDC7A00A48B58009FA1A6008A8A
      8A00454545000F11120092744B00F3B25E00FFB85F00FFAD5500FC9E4400EB88
      1900A6763900E7E7E70000000000000000000000000000000000000000000000
      00000000000000000000E0955800E69C5F00EBA36500F7D7A8004E80BD005D9B
      CD004E8ED5004E9EE50054B0F1005AC0FC0057B6FA0050A8F9004998F700237F
      5E007BD6A0004BBE86004ABC850049B7810047B17D0046AC790044A676000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E5E5E500E1E0E000FCFCFC0000000000A8A8
      AE000A0B1C0014040100440100005E0000005E00000034000000060100002F0F
      0000842B0000AC390000AC390000AA3800009E34000072250000601F00007025
      0000862C0000912F00009B33020033180B00000000000000000000000000C2C0
      BB00BCB8B500E3E3E300737373007F7F7F00DDDDDD004E4E4E00B4B4B4009A9A
      9A0064646400EFEFEF00A5A5A5006B6B6B000000000075757500ACACAC00DBDB
      DB00585858009292920099999900EDEDED0052525200A6A6A600818180000000
      0000393B3C00EEECEA0088847F00B6B3B3000000000000000000EFEDEC00E6A5
      5400FFF3C800FFFFE200FFE89E00FFBF5F00FEA53A00FFA84000BD7A3200482D
      11006A492200B2762E00DB953700E4A14100EEAC4A00A2783B009A9B9D009394
      9400595959000F12150068543900E4A05000FFAD5300FFA04200F38D1C00B479
      2E00DAD9D7000000000000000000000000000000000000000000000000000000
      00000000000000000000E2985B00E89F6100ECA56700EDD4A7008B9DAD00597A
      C0004372CD004372CD004372CD004372CD004884D8004D91E100509FE1002281
      52007BD6A0004BBE86004ABD850049B8820047B27E0046AD7A0044A777000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EBEBEB0042464B0034394400ADADAF00BCBCBE000B0B
      4C000103440013022700340704000F0100006300000055000000190000003A12
      0000902F0000B13A0000AC3900008E2E00005F20000021120C00090402000F07
      04001D1310001F1512001E151100B7B5B400000000000000000000000000C3BF
      BC00BFBCBA00DDDCDD00787878007B7B7B00E0E0E00042424200D9D9D900C4C4
      C40057575700F1F1F100A5A5A5006A6A6A00000000005B5B5B00C3C3C300F6F6
      F600535353006F6F6F00B2B2B200000000004B4B4B0076767600A4A3A3000000
      000047494A00E0DEDC00817C7700B9B6B500000000000000000000000000E5E1
      DE00E8A45100FFE8A200FFFEC200FFE39800FFC76F00FFB0440085663E004952
      5D00161C2400764F2600E3861E00E9891B00E7851600B0660D008D8B88009C9D
      9F00676767001C1F21003F342800CD884000FF9C3800F18B1600B1804400E0DF
      DE00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E59A5D00E9A16300EEA76900F9D4A300F0AF7400EBA5
      6800C99573009E888C00757EA9004372CD003E76BF002B756D001A772B002A89
      48007BD6A0004BBE86004BBD850049B9830048B47F0046AE7B0045A877000000
      0000000000000000000000000000000000000000000000000000FEFEFE000000
      00000000000000000000585657005D798D007095C2001E2231000C0C3E000909
      65000F0F31000000180019084F003D1507005402000024020000320000002707
      00006420000099320000882C00005B1E020022150E007C7D7E001F273000454D
      5300CECECF00FCFCFC00FEFEFE0000000000000000000000000000000000C0BD
      B900C8C4C100F7F6F6007A7A7A0092929200000000005A5A5A00BDBDBD00B1B1
      B1006E6E6E00FBFBFB00959595006C6C6C0000000000777777009B9B9B00D2D2
      D200646464008D8D8D0092929200DEDEDE005F5F5F00A0A1A1007C7C7B00F5F5
      F40047494A00E7E5E30087827E00B8B5B5000000000000000000000000000000
      0000EEEBE900D69F5F00FFC05D00FFD98B00FFD48400E4AC5E00696258008082
      85001C1F2300744F2000F9AB4600FFB04A00FFB34D00E69E4300837D7700A5A6
      A8006E6E6E00353637001D1D1C00AA6A2500D37D1700B49D8200F5F5F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E69D5F00EBA36500F0A96A00FBDAAB00F9C38D00F8C2
      8B00F7C18A00F5BE8500F2B67C00EDAC70004084A000338659003E8F6600419A
      6E007BD6A0004BBE86004BBE86004ABA830048B5800047AF7C0045AA78000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF003F444D007BA4B900789FC40013193800000064000202
      4400000074000000910000008200200A81002C0D04002E0A00002E0B00001D01
      0000300F0100571D00005A1E020026140D00838383001D232B007096C200678B
      AA0083868A00FBFBFB000000000000000000000000000000000000000000BEBB
      B700D2CECC00B6B6B60024242400A0A0A00000000000BCBCBC00404040004646
      4600DEDEDE00C5C5C500232323007B7B7B0000000000CECECE003D3D3D004141
      4100CACACA00E4E4E4004242420047474700BBBBBB00F3F3F400444443004A49
      4800A7A8AA00F7F5F200817C7700B8B5B5000000000000000000000000000000
      000000000000FEFEFE00CEBBA600E4984300FFB14200AC793C006E717500696A
      6C0014141400A7703200FFB15000FFAF4F00FFAF4E00EF9E400087786600AAAD
      B000737373004E4E4F0014151500705D4700CAC6C30000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E89F6200EDA56700F1AB6C00FBDAAC00F9C48E00F9C3
      8D00F8C28B00F7C18A00F6C08800F6C08700418EBC003A8B64003E8F6600419A
      6E007BD6A0004BBE86004BBE86004ABB840048B6800047B07C0045AB79000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007C7A7A00557994006A86A4002F31450004043400000036000000
      5C000000A4000000D5000000A10006075D00090434005B100900792400001008
      0300170A04001F120C001212130083838300191D1E004257690078A2CD005473
      9D0080828800FBFBFB000000000000000000000000000000000000000000BEBB
      B700CDCAC800000000000000000000000000FBFBFB0000000000FCFCFC00FDFD
      FD00F9F9F900F2F2F200FDFDFD00F7F7F700EDEDED00F1F1F100F8F8F800F6F6
      F600F5F5F500F5F5F500F9F9F900F6F6F600F7F7F700F5F5F500FBFAFA00EFF0
      EF00F9FCFE00E9E7E300817D7800B8B7B6000000000000000000000000000000
      0000000000000000000000000000F8F7F700CBBBAA00735C4100818489004F51
      540021170C00D37F2400FFA43000FFA13000FFA02E00F7921E008A6C4A00A9AD
      B30077777700606060001B1B1B005C5D5F00E2E2E20000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EAA26400EFA86900F2AC6E00FCDBAD00FAC59000F9C4
      8E00F9C38D00F8C28B00F7C18A00F6C18900418EBD003A8B64003E8F6600419A
      6E007BD6A0004BBE86004BBE86004ABC850049B7810047B17D0046AC7A000000
      00000000000000000000000000000000000000000000FEFEFE00000000000000
      0000F1F1F100474646004C627A001B24520003033600060A4600020C41000310
      7000030C88000001CB00000080001D1D2F0009094F001A087200501A07001306
      0000000000005A5A5B00C6C6C600242A2E005366730085A9C3004F6E91002538
      5C0093949600FCFCFC000000000000000000000000000000000000000000BFBC
      B800D2CFCC00D9D7D800808080007E7E7E00CFCFCF00DCDCDC007F7F7F007C7C
      7C00BEBEBE00FCFCFC009393930084848400E9E9E900F9F9F9009D9D9D007A7A
      7A00ECECEC00E1E1E1008080800081818100A4A4A400E3E3E300828281007979
      79009A9D9E00E6E4E20083807A00B6B4B3000000000000000000000000000000
      000000000000000000000000000000000000E3E3E30061636500858585003C3E
      3F003D372F00B4A08800BDA58800BBA38500BEA88D00CBBCAC007E776E00AFB0
      B3007D7E7F0067686A002426280031323300BEBEBF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000ECA46600F0A96B00F3AE6F00FCDBAE00FBC69100FAC5
      9000F9C48E00F9C38D00F8C28B00F7C28A00418FBE003A8B64003E8F6600419A
      6E007BD6A0004BBE86004BBE86004ABD850049B8820047B27E0046AD7A000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD00818285000B0C1C000202280008083300171E2D002C4253002A4E6C001D49
      67000A2777000104A90000005E0013133000060650000000640009032E001C09
      030004020200121D250027313900586F80009BC4E3006C9DC10024374400878C
      9100FCFCFC00000000000000000000000000000000000000000000000000BFBC
      B900D0CDCB00F6F6F7006060600068686800F1F1F100F3F3F300696969005656
      5600F8F8F80096969600767676007878780086868600A7A7A700666666008585
      85006E6E6E00EEEEEE008383830033333300D4D4D400EBEBEB008B8A8A002F2F
      2E00C9CCCD00E4E2DF00827E7900BBB8B7000000000000000000000000000000
      000000000000000000000000000000000000979797007D7D7D00767676002C2C
      2C006B6B6B00000000000000000000000000000000000000000098989800A3A7
      AC00757676005A544A003D3222001C170F007F7F7E00E2E2E200FDFDFD000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EDA66800F1AB6D00F4AF7000FDDCAF00FBC79200FBC6
      9100FAC59000F9C48E00F9C38D00F8C38B004291BF003A8B640046966C0063B0
      830091E1AC006BCE970063CA93005BC68E0049B9830048B47F0046AE7B000000
      0000000000000000000000000000000000000000000000000000FDFDFD00CBCB
      CC005151690000003B0009083D001B2136002C4563007098BE0081ABD3005380
      AA00142E61000C207500060E4E00000039000000510000003E0000002C000000
      1500040B1700456C89008EB4D10081A6C100679BBF00375F7F0075797B00F9F9
      F90000000000000000000000000000000000000000000000000000000000BFBC
      B800CECCC9000000000094949400949494000000000000000000A0A0A0009090
      90000000000058585800D5D5D500DBDBDB005A5A5A0065656500BDBDBD00E4E4
      E40043434300ECECEC00BBBBBB0057575700F6F6F600EAEAEA00C2C1C0005152
      5100E9EDEE00E1DFDC0085807B00B6B5B3000000000000000000000000000000
      0000000000000000000000000000FBFBFB005F6265007A7D8200616364001A1A
      1A00949494000000000000000000000000000000000000000000ADADAC008B70
      4F00AB6D2500B76A1400B86B1600A760110085531B0081756600CBCBCB00F6F6
      F600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFA86A00F3AD6E00F4B37600FDE7BD00FCCA9600FBC7
      9200FBC69100FAC59000F9C48E00F9C38D004394C10052A6880080C3950061AB
      7F0054A0760059A87C0064B4850077C8960081D19E0082D5A1006CC592000000
      0000000000000000000000000000000000000000000000000000E9E9E9002222
      2F000909450002023B001C1F2F001A265E005977A00094BBDD007999C300597D
      C2003F6B9600235271000B1D5D00000040000000520000005800000039000000
      2F00142E5D004E87B60081B1D5005B8DB10023465F00686E7500F9F9F9000000
      000000000000000000000000000000000000000000000000000000000000BFBC
      B800CECDC9000000000095959500949494000000000000000000A0A0A0007C7C
      7C000000000056565600D2D2D200DDDDDD005F5F5F0065656500B8B8B800ECEC
      EC0043434300F1F1F100BBBBBB005C5C5C00ECECEC00E3E3E300C1C1C0004949
      4900E0E4E500DFDDDA00807B7600BBBAB9000000000000000000000000000000
      00000000000000000000DDDDDC00968979007150270071593B00403C36001214
      1600BEBEBE0000000000000000000000000000000000F6F6F600A8855B00DF82
      2100F2943900F69B4800F59D4F00ED984D00D9873B00B46A1E007F664800C5C5
      C500F9F9F9000000000000000000000000000000000000000000000000000000
      00000000000000000000F1AF7200F7C79100F6D1A000F4CC9C00FAD7A800FDE1
      B600FCDDB000FCD6A600FBD09E00FACA95004497C3002EC5EA000BA9D90018A1
      BA00239BA300309484003E8F66003E8F66003093840093C0A900C6E5D3000000
      00000000000000000000000000000000000000000000FEFEFE009C9CA2001818
      400008073C0000053400273851003C468A006C85AE0090B7D800657FAA004557
      9700517AA8001F3D520002086000000077000000650000006E0000002D000000
      3A000D1A83002A5C9E0048729100243D4E005E606300F6F6F500000000000000
      000000000000000000000000000000000000000000000000000000000000BFBB
      B800D9D6D400C9C8C800393939008F8F8F0000000000CBCBCB003D3D3D008181
      81000000000096969600646464006A6A6A00A3A3A300AFAFAF00505050007373
      730086868600DDDDDD00484848004A4A4A00F0F0F000CDCDCD00565554003A3C
      3B00E0E4E600D9D7D50084807A00B9B7B6000000000000000000000000000000
      000000000000C6C0B900C4803700ED923500EE953D00DC883800A76623004534
      1F00BDBDBD0000000000000000000000000000000000B59D8000FA962F00FFA3
      4900FFAC5600FFB35F00FFB86900FFB96F00FDB06A00E4944F00B86E23008473
      5E00DFDFDF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFD00FADFB700E8B07900E39A5E00E9A06200EFA86A00F4B0
      7200F7BF8600F8CD9A00F9D1A100FCDAAC00449DCA0031D0F3000ECFF4000ECA
      F2000CBFED000BBAEB000AB0E60009A9E20009A1DE0000000000000000000000
      00000000000000000000000000000000000000000000F6F6F6001E1E32000A0A
      4D0008062E0010203C005273910061727E00657989007CA2C400709BC200577A
      9A003E6287001A2E380002056B000000BA0000007F0000005900000053000000
      3D0000006500091450001D2630005B5A5A00F3F3F30000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFBD
      B800D4D0CE00EEEEEE00A7A7A700EBEBEB00FEFEFE00E9E9E900AAAAAA00E3E3
      E3000000000000000000A7A7A700AFAFAF0000000000FAFAFA00ADADAD00A2A2
      A200FBFBFB00E4E4E4009E9E9E00C1C1C100E6E6E600E0E0E00092909100B1B0
      B000D6DADB00DDDBD70084807B00B7B4B4000000000000000000000000000000
      0000E1DFDD00DC913E00FFB05200FFB66100FFBE6E00FFC17800FDB06900BB76
      3100928B8300F0F0F0000000000000000000E4E2E000E18C3100FFA54800FFB1
      5700FFBB6200FFC26C00FFC97700FFCD8200FFC78100FCB26D00DB8B4500965E
      2000B2B1B000FCFCFC0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAECE100F8DDC600F7D0AD00F7C5
      9500F4B97E00F3C4930094A098004D95B5001896D80031D4F50011DDFB0011DA
      FB0011D8FB0011D5FA0011D3FA0011D1F90011CEF90000000000000000000000
      000000000000000000000000000000000000FDFDFD0093939A000D0D47000707
      44001A1A27002F373F005B6E7E00969A9E006F6E6C0065748000526B82004F77
      9E0039638D0014273300030461000000B9000000A00000005A00000064000000
      34000202310003052E0051525800F0F0F0000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFBC
      B800D1CFCB0000000000FBFBFB00EFEFEF0000000000FCFCFC00EEEEEE00EAEA
      EA00E4E4E40000000000F6F6F600E9E9E900FDFDFD00F8F8F800E4E4E400E5E5
      E500DADADA00EAEAEA00DEDEDE00D3D3D300CFCFCF00E0E0E000E6E4E500BFC0
      BF00D6DADA00D7D4D10086827C00BCB9B8000000000000000000000000000000
      0000C2A78700FFB04B00FFBD6300FFC76E00FFD07C00FFD88D00FFCD8700F4A4
      5A008D6B4600DCDCDC000000000000000000C3B29F00FF9C3300FFAD5000FFBC
      6000FFC66C00FFCD7400FFD58100FFDB8E00FFD38A00FFBF7900EE9C5400B56C
      2000948A7E00F5F5F50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000C9FE5000DA3E7000CA1E70032D8F70011DFFC0011DD
      FB0011DAFB0011D8FB0011D5FA0011D3FA0011D1F90000000000000000000000
      00000000000000000000000000000000000099999A000F0F4400020272000505
      40002E2E3100747371008E8C8A00DCDCDB00B8B8B800AAA8A70077787900475C
      70002D50730010213100232444000D0D7B000000970000004B0000005C000000
      670002033100565A6E00EFEFF000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBA
      B600DBD8D500BCBBBB004D4D4D0044444400D4D4D400DEDEDE00353535002B2B
      2B00CECECE00D5D5D5004949490047474700B7B7B700E7E7E700444444001A1A
      1A00B2B2B200E7E7E70042424200202020009B9B9B00DEDEDE00414140004D4E
      4D0071757700E0DEDC0084807A00B5B4B3000000000000000000000000000000
      0000CA9A6500FFBA5900FFC86B00FFD37700FFDA8300FFDC8D00FFCE8200FCAA
      5D00A56D3200CECECE000000000000000000B89E8100FFA63B00FFB35600FFC2
      6600FFCE7200FFD67B00FFDB8400FFDC8C00FFD28400FFC07400F5A05300C675
      22008E7C6700F4F4F40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000FACED000EA8EB000DA4E90032DAF80011E1FC0011DF
      FC0011DDFB0011DAFB0011D8FB0011D6FA0011D3FA0000000000000000000000
      0000000000000000000000000000000000002323260003035300000073000404
      420042424600BCBCBC00C6C6C600E7E7E700CACACA00D2D2D200C8C8C7007A7D
      7F003F4852003A3F460060615D0027273900060A380002023100000064000000
      860007083600A0A1A20000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBB
      B600DAD8D4005B5B5B00EEEEEE00ACACAC007B7B7B0000000000A5A5A5008787
      8700000000006B6B6B00C7C7C700CECECE005B5B5B0000000000BBBBBB006767
      6700FDFDFD00F6F6F600BCBCBC005959590000000000959696007A797800E4E5
      E30033373800D8D6D30086827C00B7B6B5000000000000000000000000000000
      0000CEA16F00FFD57C00FFE49000FFDF8600FFD47700FFCB7100FFC06B00FBA1
      4600A46D2F00D9D9D9000000000000000000C0A78A00FFAE4500FFC87200FFD5
      7C00FFDA8100FFDC8100FFD27600FFCC7400FFC67100FFB76500F59B4800C773
      180096867300FAFAFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010AFEF000FABED000EA8EB0032DCF90010E4FD0011E1
      FC0011DFFC0011DDFB0011DAFB0011D8FB0011D6FA0000000000000000000000
      0000000000000000000000000000000000002323260004044F00000066000303
      460049495200CECECD00CACACA00E2E2E200E7E7E700C5C5C500DADADA00D6D6
      D600ADACAB008282810044444400ACACAA001A1C1B0003032500000063000000
      84000A0A37009B9B9D00FEFEFE00000000000000000000000000000000000000
      00000000000000000000FEFEFE0000000000000000000000000000000000BEBC
      B900D2CFCB004D4B4B00FCFCFB00CBCBCA006D6C6B0000000000A6A6A5008181
      80000000000056555400DFDFDE00EDEDEC004F4E4D0000000000BBBBBA006666
      650000000000F7F7F600C3C2C2005C5B5B0000000000747372009A999900F3F5
      F5003B3E3F00D1CFCC00837F7B00C3BFBF000000000000000000000000000000
      0000CCB8A100FFE49F00FFFFE500FFE69100FFCA6B00FFC06200FFB15400F590
      22009E846300F9F9F9000000000000000000D2C6B900FFAF4900FFF5B800FFF9
      B800FFEA9700FFD77B00FFCB6C00FFC36700FFBB6000FFAD5400F0903200B968
      0900AFA9A3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000011B2F10010AFEF000FABED0033DEF90010E6FD0010E4
      FD0011E1FC0011DFFC0011DDFB0011DAFB0011D8FB0000000000000000000000
      0000000000000000000000000000000000002323260004044F00000067000707
      4D0011112A0085858700CBCBCB00D7D7D700F2F2F200D7D7D700CACACA00E2E2
      E200DBDBDB006A6A6A009F9F9F00FDFDFD00F1F1F1000C0C2B00000061000000
      7D000A0A35009B9B9D00FEFEFE00000000000000000000000000000000000000
      0000FEFEFE00000000000000000000000000000000000000000000000000C0BF
      BC00D0CBC7005F5C5D00D7D5D6009A999A0095949400000000008F8D8E008482
      83000000000071707100AEACAE00BEBCBE006C6A6B00000000009D9B9C005F5D
      5F0000000000F8F6F700A4A3A400514F5100000000009F9D9E0068686900D4D8
      DA0045454400DDDAD900837F7E00D6D2D3000000000000000000000000000000
      0000F9F8F800E7B37000FFF7BC00FFE19000FFBF5F00FFB55200FFA23000C07C
      2900D8D6D500000000000000000000000000F9F8F800E4A24D00FFF2C700FFFF
      F900FFF3AB00FFCE7200FFC26200FFBC5C00FFB25400FEA04200E88515009F6F
      3200E5E5E5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000012B6F30011B2F1001EB7F00046E0F9002DEEFE0027EA
      FD001CE6FD0019E3FC0011DFFC0011DDFB0011DBFB0000000000000000000000
      0000000000000000000000000000000000002323250003034E00020255000707
      370017172F002121240089898900A9A9A900E5E5E500FCFCFC00DDDDDD00B9B9
      B9007474740099999900FBFBFB0000000000000000000F0F2900020260000202
      83000A0A3C0095959700FDFDFD0000000000FDFDFD0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4E1
      DE00988F8C00E4E2E2004E5051007172730000000000CBCCCD0043454500AEAF
      B00000000000F1F4F400555657005B5D5D00FEFFFF00DFE0E10044454600999B
      9C0000000000DFE0E10048494A00898B8B0000000000F2F3F400666768004F4C
      4B00CAC5C200BCB8B40088858100000000000000000000000000000000000000
      000000000000F0EEED00D3AA7800F8A64200FD9F3100EF942900C0915800DAD8
      D5000000000000000000000000000000000000000000D2C7BA00FCB34F00FFF6
      C300FFEDA700FFC46900FFB75600FFB15000FFA54400F9922100C7750D00BFBA
      B300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000029C5F7003ACBF60033C4F30026B6EE001BABE90024B6
      EB002AC0ED002FC8F0003ADBF70038E5FB0019DFFC0000000000000000000000
      0000000000000000000000000000000000002C2C2E0013134C000F0F48003838
      4900C2C2C300FBFBFB00C7C7C700B4B4B40093939300A5A5A500A2A2A200AAAA
      AA00D1D1D100F9F9F9000000000000000000000000005B5B6900101058001212
      760070708F00E0E0E0000000000000000000FEFEFE0000000000000000000000
      000000000000FEFEFE0000000000000000000000000000000000000000000000
      00009B918E009A949000DEDBD700EEEAE600E7E3DE00EBE8E400EAE6E200EAE6
      E200E6E3DF00EBE8E400E5E1DD00E1DDD800E7E3DF00E8E4DF00E1DDD900E5E1
      DD00D7D3CF00DCD8D400DBD7D300D6D2CE00D0CDC800D0CCC800CCC8C500C4BF
      BF00A29D9900716C6900E4E2DE00000000000000000000000000000000000000
      0000000000000000000000000000EFEDEB00DDD7D000E7E5E300FEFEFE000000
      0000000000000000000000000000000000000000000000000000CFC1B200F3A0
      3B00FFB44C00FFAD4700FFA63F00FFA13400FC921B00C77C2000C2BAB0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C9F4FD00BBEBFC0088D8F8005AC5F3004ABCEF000CA0
      E6000B9AE30037A7E40064B8E900A3D4F100C3EDFA0000000000000000000000
      0000000000000000000000000000000000002424260009094300080840005B5B
      6500F7F7F6000000000000000000000000002D2D2D001E1E1E004F4F4F00F4F4
      F400000000000000000000000000000000000000000021212A0003035D000606
      630080808A00FBFBFB0000000000000000000000000000000000000000000000
      000000000000FEFEFE0000000000000000000000000000000000000000000000
      000000000000D2CFCC00A9A6A200A8A6A200B4B1AD00A8A6A200AFACA800B1AE
      AA00A9A6A200AEABA700AAA7A400B2AFAC00ABA8A400ADABA700AFACA900A8A5
      A200AEABA700ACA9A500ADAAA700ACA9A500AFACA800ADAAA600AFACA900AEAB
      AB00B7B5B200F2F0ED0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EAE8
      E600CAAE8C00CE975800DF9A4700C6945600BDA88E00E7E6E500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002D2D2D002323240071717100FCFC
      FC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000021212800080844000909
      3A0080808700FCFCFC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F2F2F200E2E2E200D9D9D900D6D6D600D8D8
      D800DEDEDE00E7E7E700EFEFEF00F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000431B
      01006F2B0200953E0400A5460400AC480400A64604009B3F0400743003004F1F
      0100120600000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DFDFDF00A5A5A5008C8C8C008A8A8A008A8A8A008B8B8B008B8B
      8B008C8C8C00868686008A8A8A009B9B9B00B7B7B700DADADA00F4F4F4000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001E0B00007E330300AC490500AC4B
      05008C560900B5530500B0570700B0570700B0580700AD550600AB510600A74D
      0600AA490500903A040031130100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B3B3B30094949400B8B8B800C8C8C800CFCFCF00C6C6C600D8D8D800C6C6
      C600B5B5B500C3C3C300C6C6C600B4B4B40099999900838383009E9E9E00DFDF
      DF00FCFCFC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000762F0300A9490600A74F0500AF580700DC5C
      03000087280083741000D46D0700CC6F0800CB6E0900C96D0900C5690800BD62
      0700B4590700A9510600A84A0500913B04000802000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B5B5
      B500A2A2A200C8C8C800CDCDCD00C2C2C200D2D2D200D9D9D900E0E0E000CFCF
      CF00A8A8A8009D9D9D00A5A5A500B3B3B300C2C2C200C5C5C5009B9B9B008989
      8900E1E1E1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000011060000A6430400A44C0600B1580700C1640800CA6F0900F674
      03000F98370033922C00FF800500E1840B00E2840A00E0820A00DB7E0B00D67A
      0A00CE710900C4680800B55A0700A64E0600AC48050039170100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EAEAEA007C7C
      7C009191910094949400949494009E9E9E00A2A2A2008F8F8F0091919100A2A2
      A200AFAFAF00AEAEAE00AAAAAA00B2B2B200AEAEAE00BEBEBE00CACACA008E8E
      8E00B5B5B500FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002CA4E000000000000206090000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000180A0000AD480600A74E0600BA5F0700CB6E0900D77A0B00E0830C00FF88
      0600329C330000B35A00C68F0A00FF930A00F1930C00F1920D00EE8F0C00EA8B
      0B00E3850C00DA7C0B00CE710900BE630800AA520600AA490600561C00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFCFC00878787007C7C
      7C0096979A009B9DA40096999F008D8F940087888B007B7B7D00777778007A7A
      7A00818181008989890089898900A1A1A100CACACA00CDCDCD00C1C1C100A4A4
      A400A5A5A5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003273940038BCF1002CA4E0002CA4E0003284AF0001020300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001307
      0000AC480600A7500700BE620800CF730900DF810C00E98B0D00F0910D00FF96
      0A003D9D2B002BC36C0000B25200BF980E00FF9D0E00FB9C0F00F99B0E00F697
      0E00F3940D00EB8C0C00E2840C00D5770A00C3670900B8520500695A0C001C24
      0200000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D6D500908A83006C6C6D00A4A5
      A800D5CEBD00CEBB9000C8B68B00C2B59400BCB6A600ADABA600A1A2A600989B
      A4008B8D93008586880079797A006666660080808000A8A8A800B8B8B8009191
      9100C8C8C8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000394964003FCBFC008C4A20002CA4E0003E5C780001020300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009E41
      0500A54D0700BD620800D2750B00E2840D00EE8F0D00F5970F00FA9C1000FF9E
      0E008C9B17001CBF64002DC66F002AA33300FFA10900FFA11000FEA00F00FD9E
      1000FB9B0F00F6970D00F0920C00E5880C00D77A0C00D862020000823200148A
      38000C0600000000000000000000000000000000000000000000000000000000
      00000000000000000000EAEAEA00A58E7200B87F33008972530073787F009C93
      8000AB811F00D19E2D00E8B74900ECBC4B00E9B94600E6BA4E00DFBB5F00D0B4
      7100C1B28D00AFABA100A1A2A60093969F0086878C0082828400858585007272
      7200DFDFDF00FCFCFC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000041CFFF00EAFA1C0041CFFF000001010000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006E2B0300A34A
      0500B85F0900CF730A00E1850D00EF910D00F6991100FB9E1100FEA01300FFA2
      1200FF9D060005B3570037C7710005BA6100C59A0F00FFA10D00FFA01100FFA1
      1000FEA00F00FC9C0F00F8990F00F1930C00EA870B00BD75060003994C002391
      51001B6F21000000000000000000000000000000000000000000000000000000
      000000000000D2D0CD00A8763D00EAAC5E00F8E2C200857E740075787C007A68
      3000966B0400CAA33700DFBA5100E9C76000F2D36A00F8D96E00FADA6600F9D7
      5B00F8D05000F1C74D00E6C25E00D1B87400B8AE92009E9E9E008C8E97007A7B
      7E0084848400CCCCCC00F7F7F700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004FBFF60041CFFF0048B7F000040C0E0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000C040000AA480500AE57
      0800C86D0B00DC800E00ED900F00F6991300FC9E1500FEA11600FFA21600FFA3
      1500E39E120012BA63003AC66F0039C56F0001B960007D9B1A00FFA11200FFA0
      1300FFA01100FEA01100FD9D1000F9990F00FA910B008A850F0012A35400279C
      56001A8C43001023050000000000000000000000000000000000000000000000
      0000CAC6C100BA772800E8882500E99E4E00E6CAA50077767700777877007E69
      25009D771100B4901600BA951800BE9A1A00C49F1F00CCA92900D8B63A00E4C8
      4F00F1DA6500F9E67200FDE86E00FDE06000F8D55100ECCA5A00CDBA7700A7A3
      970083848A0074747400D3D3D300FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004DCAFD0041CFFF0047C3F8000713180000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006D2C0400A54D0700BD63
      0900D5790C00E88B1100F5971300FB9F1700FEA21800FFA41900FFA51B00FAA1
      170000B054003EC874003CC672003CC671003BCA78002AAA4200FFA21100FFA2
      1500FFA21400FFA01200FFA11000FC9D1000FB970E00ED88050003A6510029A3
      5A00239250001C6E22000000000000000000000000000000000000000000D9D7
      D500BE792A00EE8E2C00F2953D00FC9E4500E3974E00716F6E0077787500866C
      1900A7801500BC991A00BE991800C19E1C00C3A11E00C6A41E00C8A51D00CAA7
      1C00CFAA1E00D6B22700DEBF3700EAD25100F8E97300FEF07D00FDE76D00F1D7
      6300A79E7A006A6B70009B9B9B00F6F6F6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000051C6FC004FBFF80047BAF300040C0F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A2270400CC620700EA9F0C00EA9F0C00ECB81400F4E64D009D26
      0400C75F0700E69A0C00E79C0C00EAB51400F3E34B00F4F18A00F5F297009D26
      0400C9600700E99E0C00EBA00C00EEBB1400F8EB4F00FAF99300FBFAA1000000
      00000000000000000000000000000000000000000000AA470700AD550800C96E
      0B00DF831100EF941400FA9E1800FEA31A00FFA61F00FFA82200FFA9230069A4
      320038C7760047CA7A0045C9790044C9790028C4710000A64400F9A51A00FFA4
      1A00FFA31700FFA11500FFA11300FFA11100FF9C0E009A91130015B05B002DA8
      5A0025995400158B3D00130A0000000000000000000000000000F6F6F600B182
      4900F18F2A00F5963C00FD9E4500FFA84D00DE9C590070707000777770008C6D
      1600B1861600C29D1900C7A01A00C9A21A00CAA41B00CBA51B00CDA71C00CFA9
      1B00D0A91900D1AA1800CFA81100CFA60B00DDBA2600EDD14100F9E77000F7E3
      7600CCAE44007B79760083838500F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000002
      02003B5F78003891D00034204C00317DBC0040688300091A2000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009F260400CB610700E99D0C00E99E0C00EBB61400F3E34B009D26
      0400C65F0700E59A0C00E79C0C00EBB61400F3E54C00F5F38D00F6F399009E26
      0400CB610700EB9F0C00EDA30C00F0BD1400FAEE5100FCFB9500FDFCA2000000
      0000000000000000000000000000000000002D110000A4490700B75E0A00D277
      0F00E68B1500F59A1900FCA31F00FFA82300FFA92800FFAB2B00FFAD3000D4AA
      310034C5790052CD83004ECC810022B96600B7A72F00FFA92300FFA82500FFA7
      2200FFA61B00FFA41500D49D1200EE9D0C00DF99090002AE50002FB866002AAD
      5D002A9E55001F8E490012390B00000000000000000000000000BAAE9D00E988
      1F00F6963900FE9E4300FFA64C00FFB05300CF9A5E006D7074007A7767009473
      1A00BA901D00CBA62000C9A31E00CDA72000D1AB2200D3AC2100D5AC2000D7AD
      1F00D9AE1E00D8AC1B00D4AA1600CFA60F00D2B01D00E0C13000E9C93600EBC2
      4500BF9B3200848176007C7C7E00EDEDED000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003658
      77003DC0F3008A5A5300991F00005C282E003598D400386E8F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009E260400C9600700E69C0C00E79C0C00EAB61400F3E4
      4C00F4F28B00F5F298009D260400C9600700E99E0C00EBA00C00EEBA1400F8EB
      4F00FAF99300FBFAA10000000000000000000000000000000000000000000000
      00000000000000000000000000000000000052210200A64E0900C0670D00D77D
      1300EA921800F8A01F00FEA92600FFAB2C00FFAF3300FFB13900FFB33C00F9B2
      3E002BBC6F0061D08B0053C17100F8AF3800FFB23B00FFB03600FFAD3000FFAB
      2800E7A522007FA1290000B2560009B960000EBC640032C167002FBB66002BB0
      5E0028A2570022944F001D5015000000000000000000F3F3F300BF823C00F794
      3000FD9C3E00FFA44800FFAB5000FFB55700C39762006C707700797460009B77
      1D00C0962200CBA72100C49D1800C6A21B00CDA71F00D2AC2100D8B12600DBB2
      2600DDB22400DEB12100D9AD1B00D2A71200CDA61200DDC23800EBCF4300EDC5
      4E00BE9C3A008580700075767800E8E8E8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A78
      94003DC0F200BAAA6F00FFFF0000984E430046ADE700458CAE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009E260400C9600700E69C0C00E89D0C00EBB61400F4E6
      4D00F6F48D00F8F59B009E260400CB610700EBA10C00ECA30C00F0BD1400FAEE
      5100FCFB9500FCFCA20000000000000000000000000000000000000000000000
      00000000000000000000000000000000000061270300AC540B00C46C1000DD84
      1700EE961F00FBA52800FFAD2F00FFB23600FFB33D00C2B44D002EB76B00DBBA
      5500EEBA550059C57F003FBF7800FFBB4E00FFB84D00FFB54500FFB23D00FFAF
      2F007AAA3E0029C6770040C976003AC6710037C66F0032C26A0030BB66002DB1
      610029A559002196510036671C000000000000000000CBC4BC00E6851C00FA98
      3700FFA04200FFA84B00FFB05400FFBA5B00BA9665006B7078007A745D009D76
      1B00BA8F1900C4A01C00CDA41E00CEAB2B00CCA92700C8A31B00D0AA2000E0B8
      2E00E1B72B00E2B52800DFB12200D7A81600CCA10E00D4B83000EBD25000EDCB
      5B00BC9C410086806C0073747700E1E1E1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002F6786003EC7F8009F93690041ACDA003368850003080A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009E260400CB61
      0700EB9F0C00ECA30C00F0BD1400FAED5100FBFB9500FCFCA200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000632A0500B0570D00C7701400DF88
      1C00F19C2500FBA93000FFB1350098B24F0021BA72008EBE6A0062C68100B8C5
      76007BC07700F5C369008FBF7200FFC26400FFC05E00FFBC5500FFB84A00B3AF
      440002AF590033C6760040C877003CC7720036C56E0034C36C0031BF690030B5
      630028A85D0021975200307120000000000000000000B7A18600FA932700FE9B
      3B00FFA34500FFAB4E00FFB25600FFBE5C00B39366006A707A007B745B009B70
      1300C8982100D5AE2C00D7AD2A00D9AF2C00DAB32F00D0AB2500D6AF2700E4BD
      3500E4BB3100E6B82E00E4B32800DBAB1C00CD9F1000CCAD2600E9D55C00EECF
      6700BA9C460087806A0072737600DCDCDC000000000000000000000000000000
      000000000000000000001892AE00000000000000000000000000000000000000
      00000103040061CFFC0047BBFA003BBDF1000106070000000000000000000000
      000000000000000000001791B200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0270400CD62
      0700ECA30C00EEA40C00F2BF1400FBEE5200FCFC9600FDFCA300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000642B0600B15A1000CA731800E08A
      2200F19F2C00FFAB330054B55B0055D294007BCB8600FFC25E00F1C673007AD1
      9900BAC98400FFCD7F00FFCC7D00FFCA7800FFC67000FFC26600FFBD5A00FFBA
      4B00FFB33900ABA8340037B559003DC874003BC6720035C36A000DB45D0006AA
      510027943F00179248005E6115000000000000000000BB936300FD962C00FF9E
      3D00FFA64700FFAD4F00FFB55700FFBF5D00B09267006B707B007C745800A580
      2D00D3A73B00DBB13200DDB13400DEB33400DFB53500D2AF3300CFA92700E7C0
      3D00E7BD3900E8BB3500E8B42F00DFAB2300D1A01600C9A72400E8D56600F0D3
      7500B89B4D0087816B006F707300D9D9D9000000000000000000000000000000
      000000000000000000002F80B4002283A6000000000015A6B5001F5F75000000
      00002597B4006FE0FA0051CAF60041D5FA002693B50000000000206F8A0018A2
      B70000000000298CAC003A7CA700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A2270400CF640700EDA40C00F0A50C00F3C01400FCF05300FDFD9800FDFD
      A500000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000642A0700B15A1300C9751B00E08E
      2700FFA231008BAF4B0053D0900079D89F007CD8A20080D19A0097D7A400B4D3
      9B00FFD39000FFD39200FFD39100FFD28B00FFCD8200FFC97600FFC36800FFBE
      5A00FFB84B00FFB23A00D3A92E0028C2720032C8750014B85D00FF8C0000A683
      0E00E76700000D8F45004964180000000000FAFAFA00BD894B00FF983000FFA1
      4100FFA84900FFAF5000FFB65800FFC15E00AD9269006B717B007C735800AB86
      3700DCBA5900E2B63E00E2B74100E3B84100E5B94100DFBB4B00CBA83400E1BA
      3B00ECC14300ECBC3E00ECB63700E2AB2A00D49F1C00C6A12400E6D57100F1D8
      8600B49A530087816D006E6F7200D8D8D8000000000000000000000000000000
      000000000000737C7500FFFF00002CA4E00034E8FF0035DCFF0035D9FC0030D3
      FD0063DFFF004B7F9500257091002176920032DBFC0031CCF90034D3F90035D9
      FD0032E5FF003BBFF400FFFF0000593228000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A2270400D0640700EEA50C00F0A50C00F4C11400FCF05300FDFD9800FDFD
      A500000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000652C0700AE5A1500C8751F00E78E
      2C00B3A23D003FC9860077D89C0082DBA40091DFB0009AE2B800A3E6C00096E1
      BB00F6D89F00FFDAA200FFD9A100FFD79900FFD39100FFCF8600FFC87600FFC2
      6600FFBC5500FFB545009CAA38001CBF6F0087B851002BBA5D0046A53F0005A4
      4C000AA355001F944F003C5C150000000000F6F6F600CB8C4300FF9A3400FFA5
      4600FFAB4C00FFB05100FFB75800FFC15E00B0946C006D727B0078725C00A67F
      2E00E1B85700E9BC4D00EABD4E00EBBE4E00ECBF4E00EDC25200D8B54700DCB3
      3900F2C74B00F2C04600F2B83E00E8AB2F00D49B1C00C59D2700E7D98200F2DD
      9800AA945800837F6F0072737600DADADA000000000000000000000000000000
      00000000000041CFFF0041CFFF000000000000000000000000000000000044CA
      F800356370000000000000000000000000001D6F7F0045C4F300000000000000
      0000000000000000000041CFFF0041CFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000491F0600AC581800C4722200EA8D
      2F007DA9510065D295007CD9A1008CDDAB0099E2B500A6E5BF00B0E9C600B6EA
      CB00ABE4C200E5DDAF00FFDFAD00FFDCA700FFD89F00FFD39100FFCD8200FFC7
      7100FFBF5E00FFB84D00FFB1370078AE44002FC8780039C26F0030BD6B0030B2
      63002AA35A0021914D001D48120000000000FAFAFA00C28B4A00FF9E3900FFAB
      5100FFAF5100FFB15100FFB75700FFC05C00C4A5760072777F006E6A61009279
      3300C39C4D00D2A35000D7A95400D9AD5600DBAF5700DDB25A00CDA85400BA90
      3300C89A3300E4AD4000E6A63900DA972700C6891700B4892100D9CA8900D4C1
      8900897A50008380750081818200E8E8E8000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000033D1
      E200000000000000000000000000000000000000000033D6E600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000030140300A9551900BD6F2500E68A
      3300A6A8520067D3980083DAA50094E0B100A1E4BC00AFE7C400B7EBCC00BFED
      D100C1EED400BCE4C600FFE2B300FFE0B000FFDCA700FFD89A00FFD18A00FFC9
      7800FFC26500FFBB5300FFB23C005CB2520025C5770036C26E0033B969002FAE
      6000299F55001A8B45001B2A05000000000000000000C3966100FFA23C00FFB9
      6500FFB65C00FFB25300FFB65500FFBC5900EFC37F00A7AAAD0078797C009996
      8300A4987200A3916900A4926B00A4946D00A4956F00A5957300A38D6400A08B
      6200947A4A00A5834D00A9834C00A27B430099763F009278460098896800857A
      5F0079746500AAA9A700A6A6A600FDFDFD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000040E4FF000643
      54000000000000000000000000000000000000000000095266003FDEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BA5A1D00B6682600C784
      32003FBB790075D2990087DAA70098E1B400A7E6BF00B3E9C800B2E8CB00C1EB
      D100C8EFD800C3EED500B7E3C600FFE2B600FFDEAD00FFD9A100FFD39000FFCC
      7E00FFC46A00FFBC550091B14B001EC37800DAA4280042AB4D0030B363001EA8
      5D00289953001B833100170000000000000000000000C1A88A00FFA23800FFCB
      7F00FFC77400FFB65A00FFB65500FFBA5900FFC06100F5E2C300CACFD600ABAE
      B400ABADB100A7A8AB00A3A4A500A4A5A300A5A3A000A4A39E00A5A39D00A5A4
      9C00A6A39C00A4A19900A3A19700A4A09700A3A19600A39F9400A09D9500A6A5
      A200D2D2D200BCBCBD00EBEBEB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000041CFFF00289DB9000000
      00000000000000000000000000000000000000000000000000002DA7C50041CF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006A341100CF5920004F96
      4F005EC2880076CF990089D9A80099E1B500A9E5C000A2E1BF00FFE0AF00CFE6
      C600C7F0DA00CBF0DA00B7E6CA00FFE4B700FFE0B000FFDBA300FFD49300FFCD
      8000FFC56D00FFBD5800ABB1490007B46100BF9C240044A5450030A551008275
      1C000D8F48002E511200000000000000000000000000D6D1CB00F6932600FFDA
      9100FFE79F00FFC36D00FFB75800FFB85800FFBC5A00FEC36800FFE3B200FAED
      D600F1EBE100ECE9E500E9E7E300E6E4E200E4E2E100E5E3E200E4E3E300E3E2
      E200E2E2E200E2E1E200E2E1E200E3E2E300E5E4E300E5E6E700E5E5E600E0E0
      E000C4C4C500F2F2F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000041CFFF00107095000000
      0000000000000000000000000000000000000000000000000000157EA80041CF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000060000004A873B0041A5
      6D0062BC860074CB950088D6A60099DFB4009DE3BE00F5DAA600FFE1B200CEE5
      C400C6EFD800BBEAD200EDE4BE00FFE4B800FFE0AE00FFDAA100FFD49200FFCC
      8000FFC56B00FFBC5600FFB34400CDA53400FF97200000A14A0015A85B00B359
      09000088330033040000000000000000000000000000FCFCFC00D0914800FFCD
      7900FFFFD200FFE49A00FFC06700FFB85800FFBA5A00FFBE5D00FFC15D00FFC8
      6C00FFCC7500FECF7C00FFD28000E6BC7E00EBC29100FDDEB100FDE0B500FBDE
      B300F9DBB100F8DAAF00F8DAAF00F3CD9C00B4936F00D1D1D100ECECEC00F7F7
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000041CFFF0023A4D2000000
      000000000000000000000000000000000000000000000000000041CFFF0041CF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004F471D003CA1
      67005EB47F0070C4910083D1A10095DCB100A2E1BC00A9DEB600EFDDAF00B6E5
      C800B5E9CD00EAE4BE00FBE3BA00FFE2B300DADBAC0087D6AD00FFD08700FFCB
      7700BFC06D0053B46100CEAD4700FCA23000EF902300AE7C160007984C000692
      4C0042410A000000000000000000000000000000000000000000CCC1B500FDA2
      3200FFF7D000FFFFDE00FFDE8F00FFBF6400FFB85900FFBB5B00FFBE5F00FFC2
      6300FFC46600FFC86800F2BB6700E3B37700FDD59D00FFE0AA00FFDFAB00FFE0
      AD00FFDEAC00FFDEAB00FFDAA500E9B47600A193830000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000041CFFF0026A9
      D800000000000000000000000000000000000000000041CFFF0077D1F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000577E
      3F004DA8740063BB890074C999008DD5A8009BDFB700A9E4C100A1E6C700DEDE
      B300FFDFAE00A9E7CB00B2DFBB00FFDFA900BCDBAE00A1E5BF0087D9A8005CCA
      9100C1BB6400C8B25300E3A43E00E8952D00D6812000D768130050671A002375
      220013000000000000000000000000000000000000000000000000000000C797
      6000FFC46800FFFFF200FFFDD500FFDA8900FFBE6400FFB95A00FFBA5A00FFBC
      5D00FFBF6000FABB5F00DDAA6C00F7D7AF00FEF0D500FFF3DC00FFE6BF00FFD8
      A300FFDAA700FEDAA700F8C68800B78D5F00DEDDDD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000041CF
      FF001A9AC80000000000000000000000000041CFFF006BD7F300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001002
      0000708A4A00818E56009AA670007DCB9E009ED2A7009ADCB6009BD7AF00E9D5
      A300CEDAAF0092DFBD00FDD9A600FFD79D008ED9AF009CE2B7008EDEAF0070D6
      A100C2B25C00FBA64500E4973600D5842800C36F1B00AC571100AD4F0C001E04
      000000000000000000000000000000000000000000000000000000000000EEED
      EC00DA923D00FFCC7800FFFEE000FFFDC200FFD68500FFBF6500FFB85A00FFB7
      5800FFB95900EEAC5900E4AF7100EABE8700EEBA7B00F0CCA000FAF3E600FFE6
      C500FFCD9300FABF7D00D4995800B9B3AD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000041CFFF0041CFFF00FFFF0000457EA70052D2EE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000014010000D77243004EA66F0075BD910090C3940079CB9D00FFBD8300C5CB
      9A00A0D4A900F2CF9900FFCE9500ECCB8F008AD9AE008FDAAD0082D5A10070D0
      980057AF6400EB923C00D2822E00C06F2100AB5A1700B15111001A0900000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E6E3E100D9923D00FFBC5800FFE8A500FFE69F00FFCB7A00FFBB6100FFB4
      5600FFB25200FFB25300FEAF5000FBAA4B00FEA84800FBA03E00EEAE6800FBF0
      DE00FED19E00C88C4C00B3AAA100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000012030000728A520060A975006CAD7C00D4A370008DBA8600B9BF
      8E0098CA9A00FEBA80006BCB9C0082D3A8008AD3A60080CF9D0073C9950064C3
      8D006CA15A00DB7B2F00B76B2500AC5A1B00A54C130014080100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EEEDEC00C7996300FF992700FFB55600FFB96300FFB35900FFAD
      4F00FFAA4900FFA94700FFA74500FFA44200FF9F3D00FD983100F58D1A00DE8C
      2800B8906300C8C4C10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000062563000AA9B640072A36F0078A8750083B7
      8A007CC89E007CC193009EBE8D007ACA9C0070C697006FC1900064BB860059B2
      7D00259E5C00CC5D2200B65E200074360F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CDC3B600D0934C00F38F1E00FF9B2700FF9D
      2E00FF9D3000FF9C2F00FF9A2B00FF962200F98F1600E0810C00BB823B00BCB0
      A300F7F7F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000555B3700F6885A0069A4
      6C006EB07E006BB98B0067BB8D0077A56D008F955C004DA9700051A87200419F
      620056893E004D491D0011030000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D7D3CD00C1AB8F00C399
      6400BE894800C1884200BA874800BA946400B8A48B00CDC8C100F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003721
      12006E2F1D00435E380036613B0081472A008343260066432200274722001F20
      0B00050000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBFBFB00F8F8F800FBFBFB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C0008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000404
      0400010101000101010000000000000000000000000005050500141414000505
      0500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080808000C0C0C000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF0080808000C0C0C0008080
      8000000000000000000000000000000000000000000000000000806060008060
      6000806060008060600080606000806060008060600080606000806060008060
      6000806060008060600080606000806060008060600080606000806060008060
      6000806060008060600080606000806060008060600080606000806060008060
      600080606000806060000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001E20
      21005C666C004C555B002C2F32001E2021001C1C1D002B3032004F575E003A3F
      4400040404000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF0080808000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000C0C0C000808080000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000B0B0B004444
      4500626A6F004C555B004C535A004B535A00434B52003A4246003C4346004047
      4C00282C2F000101010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF0080808000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF0080808000C0C0C00080808000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000607070033393C00717A
      8200545C6400434B520069737A005E686F00626E7500647077004C555B003238
      3C002A2F33000B0C0C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF0080808000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF0080808000C0C0C0008080800000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004040400545C63006069
      72006E777E008E969E0099A0A7007E878F0081888F00858D930078828A005E67
      6C003A42460031363A000B0C0C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF0080808000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080808000C0C0C000808080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF00F0FBFF00F0FBFF0040A0E0004080E0004080E0004080E0004080E0004080
      E0004080C0004040A0004040A0004040A0004040A0004040A0004040A0004080
      800040A0600040A0600040A0600040A0600040A0600040A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000080909005E686F006772
      7A00949FA400959FA700838C94008B969D00848E9500CDD9E000A3ADB500929D
      A600565F64004C55580022252600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF0080808000C0C0
      C00080808000000000000000000000000000000000000000000080808000FFFF
      FF0080808000C0C0C00080808000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF00F0FBFF00F0FBFF000080E00040C0E00040C0E00040C0E00040C0E00040C0
      E0000060C0000040E0004060E0000040E0000040E0000040E0000020C0004080
      A00080E0C00080E0C00080E0A00040E0A00040E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000004040400363E420065717B00AFBC
      C400969FA8004D4D4E00D1E3ED009BA4AB009AA5AE005C636700DBDBDB00BDCB
      D200818D97004C565B003E464B000D0E0F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF008080
      8000C0C0C0008080800000000000000000000000000080808000FFFFFF008080
      8000C0C0C0008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF00F0FBFF00F0FBFF000080E00040C0E00040C0E00040C0E00040C0E00040C0
      E0000060C0000040E0004060E0000040E0000040E0000040E0000020C0004080
      A00080E0C00080E0C00080E0A00040E0A00040E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008090900555D6600828F9500959F
      A5001C1E200001010100868686008B979E009CA6AD001617180014141400CFCF
      CF008B959B00494F58004B535A000E0F0F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF0080808000C0C0C000808080000000000080808000FFFFFF0080808000C0C0
      C000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF00F0FBFF00F0FBFF000080E00040E0E00040E0E00040C0E00040C0E00040C0
      E0000060C0000040E0004060E0000060E0000040E0000040E0000020C0004080
      A00080E0C00080E0C00080E0A00080E0A00040E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000080909006D7277007F89910089919600727D
      8400747D83000809090022252600E6E6E600676E7200252729005D666B009CA7
      B1007E8A9100475156003E444A00101214000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080808000C0C0C000808080000000000080808000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF0000000000F0FBFF004080E00080E0E00040E0E00040E0E00040E0E00040C0
      E0000060C0000040E0004060E0004060E0000040E0000040E0000020C0004080
      A00080E0C00080E0C00080E0C00080E0A00040E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000040404004D4D4E00626C7100656F7800808C9300727D
      8400848E95007F899200454B4F00111213001E202100BFCFDB00ACB8C1007E89
      9100828B9300535C6300363C4000121414000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF0080808000C0C0C0008080800000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF0000000000000000004080E00080E0E00080E0E00080E0E00040E0E00040E0
      E0004060C0000040E0004060E0004060E0000040E0000040E0000020C0004080
      A00080E0C00080E0C00080E0C00080E0A00040E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000050505005E676C005F676F006D7880007D888F00757F
      8600717A81002F3235005C63670088919900454B4F001E202100A5A5A500AFBF
      C9008A9298006D757B002E333800111213000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF0080808000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF0000000000000000004080E00080E0E00080E0E00080E0E00080E0E00080E0
      E0004060C0000020C0000040C0000020C0000020C0000020C0000020A0004060
      A00080E0C00080E0C00080E0C00080E0C00040E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000006070700848E950099A7AF00838D940077828A008997
      9F002A2E31001C1E20007E878F00828C950098A3AA0050575C001C1E20007D7D
      7D008A949900616B700031363A000D0E0F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF0080808000FFFFFF0080808000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF0000000000000000004080E00080E0E00080E0E00080E0E00080E0E00080E0
      E0004080E000C0C0C000F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0C00040A0
      800080E0E00080E0C00080E0C00080E0C00080E0A00000A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000006070700A4B1BC00BCD1DC007F8A9000727D84007A86
      8E00828B9300929A9F004E55590005050500515353008B979E00494F5300808B
      9200828B9300494F5300363C40000D0E0F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080808000C0C0C00080808000FFFFFF0080808000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF0000000000000000004080E00080E0E00080E0E00080E0E00080E0E00080E0
      E00040A0E000C0C0C000F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0DCC00040C0
      800080E0E00080E0C00080E0C00080E0C00080E0A00040A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000006070700A9B8C600E2F8FE00A4B2BD00778189006E77
      7E007E88900079848C0011121300060707001E202100D5D5D500747D86007681
      89007A8287005D636A0042454A00040404000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF0080808000C0C0C000808080000000000080808000FFFFFF0080808000C0C0
      C000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF0000000000000000004080E00040A0E00040A0E00040A0E00040A0E00040A0
      E0004080E000C0DCC000F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0DCC00040C0
      800080E0E00080E0E00080E0C00080E0C00080E0C00040A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000040404009EACB300D0E5F400CBE1ED00B3C0CB007F8A
      9100717D85000B0B0B000101010001010100040404001C1C1D00C8DAE7007F88
      8F00778188005A60620015181A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF008080
      8000C0C0C0008080800000000000000000000000000080808000FFFFFF008080
      8000C0C0C0008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000F0FB
      FF000000000000000000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0DCC00040C0
      800080E0E00080E0E00080E0C00080E0C00080E0C00040A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000141414008D9AA300C7D7E500C4D6E400B4C5
      D0005B646C0004040400484D5200040404003E44480005050500C8CECE008890
      9800727C830052575A000B0C0C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      00000000000000000000000000000000000080808000FFFFFF0080808000C0C0
      C00080808000000000000000000000000000000000000000000080808000FFFF
      FF0080808000C0C0C00080808000000000000000000000000000000000000000
      000000000000008080000000000000000000000000000000000080808000F0FB
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0DCC00040C0
      800080E0E00080E0E00080E0C00080E0C00080E0C00040A06000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002A2D3000A1AEB800A6B4BD007F8D
      95006B777E000E0F0F0004040400010101000101010033393C007A848E00828C
      920069737A003D4244000B0B0B00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF00C0C0
      C000C0C0C000000000000000000000000000FFFFFF0080808000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080808000C0C0C00080808000000000000000000000000000C0C0
      C000C0C0C00000FFFF000080800000000000000000000000000080808000F0FB
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0DCC00040A0
      600040A0600040A0600040A0600040A0600040A0600000A04000F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000292B2E00A9B9C30086919A006B78
      8000808F97005E676C0015181A00010101001C1E2000909CA3007B858B007079
      81007E888E003A3E420004040400000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000FFFF00008080000000
      0000000000000000000000808000008080000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00C0C0C000000000000080800000000000000000000000
      0000000000000080800000FFFF0000808000000000000000000080808000F0FB
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000001010100879199009AA9B600677076006C79
      81007F899200808B9300738086006B788000808B9300727E840077808600818C
      9200869096003A3F440004040400000000000000000000000000000000000000
      00000000000000000000000000000000000000808000FFFFFF00000000000000
      00000000000000808000FFFFFF00008080000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000008080000080800000808000000000000000
      0000000000000000000000FFFF0000808000000000000000000080808000F0FB
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000008090900F6FFFF00919FA9005B656B006D78
      8100768089007B888E007D89940081909A0098A2AA0098A3AA007A838C007F88
      8F00778188003E43460005050500000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000FFFF00000000000000
      000000808000FFFFFF0000FFFF0000FFFF000080800000808000000000000080
      8000000000000000000000000000000000000000000000000000000000000080
      80000000000000000000008080000080800000FFFF0000808000008080000000
      0000000000000000000000FFFF0000808000000000000000000080802000C0A0
      4000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A0
      6000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A0
      6000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A0
      6000C0A04000808020000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000292A2B0000000000C0CCD300919CA4009FAB
      B20098A3AA008E9BA2008F99A200A4B0B900C1C9D200C7D2DD00A9B7BF008590
      9800687177004F565A0004040400000000000000000000000000000000000000
      00000000000000000000000000000000000000808000FFFFFF00000000000080
      8000FFFFFF0000FFFF0000FFFF000080800000000000008080000080800000FF
      FF00000000000000000000000000000000000000000000000000000000000080
      800000FFFF000080800000808000FFFFFF0000FFFF0000FFFF00008080000080
      8000000000000000000000FFFF00008080000000000000000000C0802000C0C0
      6000C0C08000C0C08000C0C08000C0C08000C0C06000C0C06000C0C06000C0C0
      6000C0C06000C0C06000C0C06000C0C06000C0C04000C0A04000C0A04000C0A0
      4000C0A04000C0A04000C0A04000C0A04000C0A04000C0A04000C0A04000C0A0
      4000C0A04000C08000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000008090900858F9700B6C3CD00A9B7BF00BBC9
      D000D0DFE900B3C0CB00A3ADB500939EA50089949A00B0BDC700AFBCC7008895
      9F005A646800575E630005050500000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000FFFF00000000008080
      8000C0C0C00000FFFF00008080000080800000000000000000000080800000FF
      FF00000000000000000000000000000000000000000000000000000000000080
      8000FFFFFF00008080000000000000808000FFFFFF0000FFFF0000FFFF000080
      8000808080000000000000FFFF00008080000000000000000000C0802000F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600C0C06000C08020000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050505001E20210025292B003A3E
      4200626A7000818C9200A0AEB300ABB5BE009098A200777E8700B0BEC900C1CE
      DB005F656C0034393D0001010100000000000000000000000000000000000000
      00000000000000000000000000000000000000808000FFFFFF0000FFFF000000
      00008080800000808000008080000000000000000000000000000080800000FF
      FF00000000000000000000000000000000000000000000000000000000000080
      800000FFFF0000808000000000000000000000808000FFFFFF00C0C0C0008080
      80000000000000FFFF0000FFFF00008080000000000000000000C0802000F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600C0C06000C08020000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000005050500060707000F1012002527290042454A0053585E008A949F008795
      9D0042454A000505050000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF0000FF
      FF000000000000808000000000000000000000000000000000000080800000FF
      FF00000000000000000000000000000000000000000000000000000000000080
      8000FFFFFF000080800000000000000000000000000000808000008080000000
      000000FFFF0000FFFF0000808000000000000000000000000000C0802000F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600F0CA
      A600C0C06000C08020000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004040400040404000101
      0100010101000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080800000FF
      FF0000FFFF00000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000080800000FFFF00000000000000000000000000000000000000000000FF
      FF0000FFFF000080800000000000000000000000000000000000C0800000C0A0
      6000F0CAA600C0C08000C0C08000C0C08000C0C08000C0C08000C0C08000C0C0
      6000C0C06000C0C06000C0C06000C0C06000C0C06000C0C06000C0C06000C0C0
      6000C0A04000C0A04000C0A04000C0A04000C0A04000C0A04000C0A04000C0A0
      4000C0A02000C08000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00008080000000000000000000000000000000000000000000C0800000C080
      0000C0800000C0800000C0800000C0800000C0800000C0800000C0800000C080
      0000C0800000C0800000C0800000C0800000C0800000C0800000C0800000C080
      0000C0800000C0800000C0800000C0800000C0800000C0800000C0800000C080
      0000C0800000C08000000000000000000000000000000000000080808000FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF008080800000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008080000080800000808000008080000080800000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF008080800000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF008080800080808000FFFFFF008080800080808000FFFFFF008080
      800080808000FFFFFF008080800080808000FFFFFF008080800080808000FFFF
      FF008080800080808000FFFFFF008080800080808000FFFFFF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001619160024271A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000005070500A9CBEC001C2218000D100C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000020
      4000406080004060800040608000402040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000D100C00161916005984C200050705001C221800050705000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000040202000402040000020
      4000000000000020400040404000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002C2C2C008D8D8D00ABABAB007C7C7C00282828000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000005070500252826004879A800748A95001C221800161D21002F4039000507
      0500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000040202000402040004060800040608000406080004040
      8000404060000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003B3B3B00909090006B6B6B005B5B5B006B6B6B00717171002727
      2700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000507
      0500384546004C787A001A4E84003475A30039443700161D210027343800353A
      3800050705000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000404040004040600040408000406080004060A00040608000404080004040
      8000406080004040800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E5E5E0088888800797979006B6B6B0079797900757575005353
      5300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000182428004956
      56005B898B00103D4C004879A80081CEF3003E5158001C221800242E3500303D
      50002A322A000507050000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000402020004040
      60004060800040408000406080004060A0004060800040408000404060004060
      8000404060000040600000204000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000333333006D6D6D006C6C6C0098989800525252008D8D8D006B6B6B005959
      5900323232000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000D100C004A625B006889
      97001E4660004F7985001C6CA6005EB5E6002734380038454600161D2100242E
      3500353C4400353A380005070500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000040202000004040004080
      A00040608000406080004060A0004060A0004040800040406000406080004040
      6000002040000040600000406000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004040400040404000000000000000000000000000000000000000
      0000404040004040400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000616161006C6C6C00B3B3B30088888800E2E2E2007B7B7B00989898005A5A
      5A00616161000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000D100C000D100C005569670076A4B4001B36
      57005180B20015587F003E6989002B5C82000A1414000A141400273438001824
      2800172739003D4E690025282600161916000D100C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000040202000004060004060A0004060
      A000404080004060A0004060A000406080004040600040608000004060000020
      4000004060000040600000204000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004040400040404000000000000000000000000000000000000000
      0000404040004060600040404000402020000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006E6E6E005C5C5C005555550078787800ADADAD006D6D6D00555555005353
      53006A6A6A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000172739006376790091B0B6003B566700456A
      9200306295003B5667002A322A00A9CBEC00242E35000507050027343800161D
      2100161D21002A3647002A457100172D44001619160000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000404060004060A0004060A0004040
      8000406080004080A00040608000404060004040600000406000002040000020
      4000002040000020400000204000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000406060008060600040606000406060000000000000000000000000004060
      6000406060008060600040404000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000959595005D5D5D005555550076767600ADADAD006D6D6D00555555005353
      5300939393000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000182428005B777700577988004A759700456A
      92003F5471002A322A0043373E0085919500535965001B36570016191600353A
      38000A14140018242800172739002A4571000507050000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000204000404080004060A0004060A000406080004060
      80004060A0004060800040406000404060000040600000204000002040000020
      4000002040000020400000204000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000404040000000000000000000000000008060
      6000806060008080800040606000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006B6B6B008888880084848400C1C1C100E7E7E700B8B8B800707070006969
      6900757575000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000507050017273900748A95006797C600588196004458
      6800353A38005B7777004458680032331C00AEB0B7006C92B6002A4571002427
      1A0045484600172D440027343800172D44000507050005070500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404060004060A0004060A0004060A0004080A0004080
      A000406080004060800040406000004060000020400000204000002040000020
      4000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004020
      2000806060008060600080808000406060000000000000000000000000004060
      6000806060008080800040404000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004B4B4B00AFAFAF00EDEDED00EDEDED00E9E9E900E4E4E400E2E2E2009090
      9000474747000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000507050076A4B4008FBBCB006889970048617200454A
      560058819600384853002A322A004A58330032331C00454A56006C92B6002746
      640025282600252826003845460038485300172D440005070500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000002040004020400000000000000000000000
      000040202000002040004060800080C0E0004080A0004060800040A0E0004060
      A000406080004040800000406000002040000020400000204000002040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004020
      2000406060004060600040606000406060000000000000000000402020004040
      4000404040004040400040404000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000B0B0B007A7A7A00C3C3C300ECECEC00EBEBEB00E3E3E300B7B7B7007373
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000D100C00E8F7FD00596F930048617200454846006C92
      B60044586800343A29007584760089A17E0055575700353C4400384853007598
      B700303D50000E152100182428003B5667004C787A0005070500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000020400040406000002040000020400000204000000000000000
      000000204000404060004060A00040A0E000404060004060A00080C0E0004060
      A000404080000040600000204000002040000020400000204000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      4000404040004040400040606000406060004020200000000000402020004040
      4000404040004060600040404000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003A3A3A0086868600989898007F7F7F00414141000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000005070500ABDBEE00678AB4003E515800273438008EBBDA006889
      970028311D007B97990064756C00AED0AB0053634B0093A8AA00353A38003D4E
      69006C92B6004D616A00242E3500242E35005B898B00353A38000A1414000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004060A0004080C000002040000020400000204000002040000000
      0000002040004060800000404000002040004040600000204000000000000020
      4000004060000020400000204000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      4000404040004060600040404000404040004020200000000000000000004040
      4000404040004060600040404000406060004020200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000005080A002E495C004268830016232C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D100C0044586800CDECFA00454A560075888600D1EFFB008AA7B4002427
      1A00556967006B86880047493E00B1D6CE00343A29005569670063767900242E
      35003B566700B3DEF900748A9500242E3500242E35005B777700636A69001619
      1600000000000000000000000000000000000000000000000000000000000000
      00000000000080A0E00080A0E000404060000040400000404000002040000020
      4000406080000020400040406000404060000000000000406000002040000000
      0000000000000020400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000402020004020
      2000404040004040400040404000404040004020200000000000402020004020
      2000404040004040400040404000404040004020200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000446B86006096BC005A8CB100446B87000D141A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000D10
      0C006A6C7600FDE8F700E4DAEA00CDECFA00E8F7FD00D4F0EC00384628002F40
      3900242E35001619160024271A00465549002A322A001C221800353A38002A32
      2A002A322A002F404B008AA3C900505E750025282600353A3800B8A1A200353A
      38000D100C000000000000000000000000000000000000000000000000000000
      0000000000004080C00000404000002040000020400000204000002040004040
      60000020400080A0C0004080C0004060A0000000000040406000002040000020
      4000000000000000000000204000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004020
      2000402020004040400040404000404040004020200000000000000000004020
      2000404040004040400040404000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005280A1005787AB001B2A35000E161C005788AB00446B87000508
      0A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001619
      1600BEAFC3007A7C8900766A77008ED6F5006A7D95004B4D0C004B4D0C00748A
      9500B8E7D700384546006E8B6C00758476008591950045484600AED0AB003846
      2800454A560025282600242E3500596F93003D4E690055575700555757004548
      4600161916000000000000000000000000000000000000000000000000000000
      0000000000004060800000204000404060000020400000406000404080004060
      80000020400080A0C00080A0E000406080000020400040608000404080000040
      6000002040000020400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000040404000402020004040
      4000404040004040400040606000402020004040400040404000402020004040
      4000404040004040400040404000404040004040400000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C2C
      38005C8FB500456B86000000000000000000000000001B2A35006096BD003451
      6600000102000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000E15
      21001D1C4D00242E3500454A5600E8F7FD004861720056563C00637679004548
      4600637679004655490091B0B60044586800748A95002A322A00495656004956
      56001824280025282600252826008AA3C900475B7700353C4400161916002A32
      2A00161916000000000000000000000000000000000000000000000000000000
      00000000000000204000000000000020400000406000406080004060A0004060
      A000406080000020400000204000004040000000000040406000004040000040
      6000404060000040400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004040400080606000404040004040
      4000404040004040400040404000402020004060600040606000404040004040
      4000404040004040400040404000406060004020200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000253A49005A8D
      B1002F4A5E0003060800000000000000000000000000000000002A415200639B
      C200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000161D21001C221800C9C6E1005777A900343A29007B9799006376
      79003846280053634B008AA7B400637679005D716B002A322A00182428004548
      46006A6C76001C221800454A5600596F9300161D21000A141400161916000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000002040000020400040404000404080004040600040406000406080004060
      8000406080004060800040608000404080000040400000000000002040000020
      4000004040000020400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040004040400040404000404040008060
      6000404040004040400040404000404040004020200040606000406060004060
      6000404040004040400040404000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002D475900649AC3002D47
      5900000102000000000000000000000000000000000000000000000102003B5C
      75005788AB00060B0E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000252826003E515800588196009ABEE200161916007B9799008AA7
      B400343A2900343A29004A625B00758886002F403900353A3800161916005D71
      6B008591950025282600586D8D004458680025282600445868000D100C000000
      0000000000000000000000000000000000000000000000000000000000000020
      4000000000000020400000204000002060000020600000204000002040004040
      6000404060000040400000406000404080004040600000204000004040004060
      8000004060000020400000204000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000040404000406060004020200040202000406060008080
      8000404040004020200040404000404040004060600000000000404040008080
      8000806060004040400040404000402020000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003A5B73005B8FB4002A4152000001
      0200000000000000000000000000000000000000000000000000000000000000
      00005E92B9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D100C005557570066909A00242E3500D1EFFB0024271A005D716B0084A5
      A60028311D008BC1CD002A322A0028311D005D716B0065798400161916008080
      8000919DA400273438006797C600161D21003B56670038485300050705000507
      0500000000000000000000000000000000000000000000000000000000000020
      4000002040004040A0004080C0004080C0000060A00000206000000000000020
      4000002040000020400040406000406080000040600000406000406080004060
      8000004060000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000040202000404040004060600000000000404040008080
      8000406060004020200040404000806060004040400000000000406060008060
      6000404040004040400040202000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003A5B72005E93B9001C2C3800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005786AA002F495C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D100C00758886006B86880045484600A9CBEC0064756C00555757005662
      57002A322A00182428001C2218003845460024271A006B86880025282600848D
      780053596500454A5600586D8D0025282600588196002F404B00161D21000A14
      1400000000000000000000000000000000000000000000000000000000000020
      40004080C00080C0E00080C0E00080C0E00080A0E0004080A000004060000020
      400000000000002040004040800040406000404060004060A000406080004040
      6000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000040404000406060004020200000000000404040004040
      4000406060004020200040606000404040004040400000000000404040004040
      4000404040004020200000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005F95BC00273C4C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000476F8C004368830000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D100C0097B6C300688997004655490092AEC400BDD6D800343A29004E66
      43004655490075847600748A95007C96A40049565600343A290047493E008890
      7B002528260090B7F300353C44005359650066909A0039443700384546001619
      1600000000000000000000000000000000000000000000000000000000004040
      800080C0E00080C0E00080A0E00080A0E00080A0C0004060A000002040000000
      0000002040000020400000406000404060004060A0004080A000404060000020
      4000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040004020200040404000404040004020
      2000000000000000000000000000404040004020200040404000404040004020
      2000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000304C60005483A60005090B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005B8EB4002F4A5E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002A364700C7F5FC006B8688002F4039007C96A400D4F1FC00161916001C22
      1800566257003E5158005B7777004D616A00454A560024271A00252826002427
      1A002A3647008A9DB200242E3500766A77004E66430039443700353A38002528
      2600000000000000000000000000000000000000000000000000000000004040
      8000000000004060A0004060A000000000004040600000404000000000000020
      4000002040000020400000204000406080004080A00040608000004060000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004040400040606000402020004020
      2000000000000000000000000000000000004040400040606000402020004020
      2000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000070B0E00588AAE002F4A5D000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000273E
      4E006096BE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000005070500B8E7D70093A8AA004956560038485300A1A6A800252826001619
      1600353A3800161916001619160018242800161D21001619160025282600242E
      35005668770045484600454A56008E9D8C004A5833002F4039000A1414001619
      1600000000000000000000000000000000000000000000000000000000000020
      4000002040000020400000204000002040000020400000204000002040000020
      4000002040000000000000404000406080004060A00040608000002040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000040202000402020000000
      0000000000000000000000000000000000000000000040202000402020000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000203340005E93B9000C1318000000000000000000000000000000
      000000000000000000000000000000000000000000000000000017252E005E93
      B9003A5B72000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000D100C00AFC9C600A4B5A80043373E008080800082797D0094A9
      B600FAFCFD00FAFCFD00C7F5FC00A4D0FF00A0C2F300AAC5DA0091A298006475
      6C0045484600645D670045484600766A7700384628002A322A00050705000000
      0000000000000000000000000000000000000000000000000000000000004060
      8000406080004060800040608000406080004040800040406000004060000020
      4000002040000020400000404000404080004040600000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000253B4A005A8DB10005080A000000000000000000000000000000
      00000000000000000000000000000000000000000000131E26005382A4004972
      900005080A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000005070500CDDBD1007B6F8000FAFCFD00766A77002A36
      47003E5158006A7D9500353A3800353A3800353A380038454600454A56005349
      4700766A7700E4DAEA0053494700616B5D004A625B0005070500000000000000
      0000000000000000000000000000000000000000000000000000000000004060
      80004080A0004060A0004060A000406080004040800040406000004060004040
      6000002040000020400040406000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000335065006197BE00314C6000080D100000000000000000000000
      0000000000000000000000000000030608002C4557005E92B7004E7A9A000E16
      1C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000050705008A9DB200C9C6E10065798400AEB0
      B700FAFCFD00AAC5DA007B9799005D716B005662570056625700636A6900766A
      7700645D6700A3A8B80075888600394437000D100C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000020
      40004080A0004060A0004080A000406080004060800000406000404080000040
      4000000000000040400000204000402020000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000335065006299C100598BAF003A5B7300000000000508
      0A0005090B0000000000345166004F7B9B00598CB0002C45570005090B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000507050038485300748A950095BA
      DB00FAFCFD00E8F7FD00D1EFFB009ABEE200657984007588860085919500636A
      6900353A3800161916003E5158001C2218000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000020
      40004080A0004080A0004080A0004060A0004060800040406000004060000020
      4000000000004020200000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000034516600598AAF005E92B8005585
      A7005686A8005E92B8004B7694002A4253000B11160000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050705000D100C00161916001619
      1600273438005569670091A29800CDDBD100848D7800353C4400353A38001619
      16000D100C000D100C000D100C00050705000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000004060004080C0004080A0004080A0004040800040406000002040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000060B0E00121D2500131E
      2600131E26000D161B0001020200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D100C000D100C000D100C000D100C000D100C000D100C00050705000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000002040004080A0004080A000406080004060800000204000002040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000040600040608000406080000040600000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000020A0004020E0004040
      E0004020C000000080000000800000008000002040000000000000000000C080
      0000C0C020000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000170303001D050500220707001D0505000D0000000D000000120202000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000204000002040000020
      400000204000002040000020400000000000002040000020A0000040C0004040
      4000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001202
      020059241D0051191A004E181A004F17190051181900421416002D0D0E000D00
      00000D0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000002040000020400000008000000080000000
      800000008000002060000020600040204000C0C0200040404000404040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000120202003D1111007643
      29005A231E0042141600421416005A201D006A3823005A251E003E1315003E13
      15003D1111000D00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000040202000000080000020C000000080000000FF000020E0000020
      A000000080000000800040204000C0C020004040400000204000002040000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000800000008000000080000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000411112007240270082572E00602B
      21005C221D00612A20006B372300743F27007743270087562D0077442800531D
      1C0045171900491517000D000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000040202000000080000020E000000080000020E0000000FF000000FF000000
      800000008000402040000020A000406060000000800000008000002040000020
      4000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000008006B007B006B00
      840073007B00520063005A006B00000800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001D0505006D3924009268350075442800622C
      2000724327005D2720005D241E006A362400673222006A3523007A4728006A36
      240059241F0038131600371011000D0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000020C0000020C0000000FF000000FF000000FF004020C0000020
      C00040204000C0C0200040404000000080000000800000206000000080000020
      4000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000800AD00C6009C00AD00B500
      9C009C0094007B0094006B007B00520063000008000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001A040400AE853D008B5F3100743F27007E4D
      2A0084552D007F4D2A0083502A0089552C009A6632008B582E00774327006630
      22006A352300551F1D00250E1100340F11000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000040A000000000000020
      4000000080000020C0000000FF000000FF004020E0004040E0004020A0000020
      A00040204000C0A000004060600000008000000080000020C000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000008008C00B500BD00B500DE10A500C600
      94009C0094007B008400730084004A005A005200630000100000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001A040400EECC53009D7135007C492900976B
      340084532C0082502B00814F2A000C07040009060300AA6C3700996731007D49
      2800673222005E2B20002D0D0E002B0F12001806070000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000020A000000000000000
      80000020C0000020C0000000FF004020E0008060E0008060E0000020A0004020
      4000000080004040400000008000000080000000FF0000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000008009C00AD00C610CE00FF42C600FF4AD600D608
      B500940094006B007B007300840052005A004200520000100000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001D050500E5C35000AB7D3A009A6A33009463
      3200764227007A472800804E2B000704020000000000E0AE580092612F008753
      2C0077442800774126004B171900461517001608090000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000066
      CC000066CC000099FF000099FF0000CCFF0033FFFF0066FFFF0099FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000020A000402020000000
      80000020C0000020C0000000FF000000FF008060E0004020E0000020A0004020
      400000008000404060000020A0000020A0000000FF0000008000000080000000
      8000000000000000000000208000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000008008C009400A500A500DE18FF00F79CCE00D610B500BD00
      B5009C009C0084008C0073007B004A005A004200520000100000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002D0B0C00B2873C00B2873C00AD7F39008955
      2D007946280082512B0087562D000402010000000000B08142007D4A29008754
      2C008B592D007C48290069352300401314001806070000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000066CC000066CC000099FF000099FF000066
      CC000066CC000099FF000099FF0000CCFF0033FFFF0066FFFF0099FFFF0000CC
      FF0033FFFF0066FFFF0099FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000206000000000000000
      8000000080000020A0000020A0000020C000000080000020E0000020E0004020
      40000040C000406060000020C0000000FF00000080000020A000000080000000
      800000204000000000000040A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000008006B087B00941894007B088400E729CE00A500A500C600
      BD00BD00BD008C0094006B006B0052005A005200630000080000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000360E0F008C5A2E00D2AC4700A97D3900844F
      2B00844F2C00784928007A4A28000402010000000000AD6E3C00985D3200AA76
      3A00804E2A0083502B00804C2A00401314003710110025080800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000066CC000066CC000099FF000099FF000066
      CC000066CC000099FF000099FF0000CCFF0033FFFF0066FFFF0099FFFF0000CC
      FF0033FFFF0099FFFF0099FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000002040000000
      80000020E0004040E0004040E0004040E0000020E0000020A00040204000C0C0
      C00040404000000080000020E0000000FF000000800000008000000000000000
      0000000000000020600000A0E000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000080063086B00CE39BD00CE39BD00A5219C009C009C00C600
      C600A5009C00840084006B0073004A005A004A005A0000000800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000360E0F0097673200FFE45400936231007C4B
      280026180D0069402200724726000402010000000000B4723C00724726000E09
      0500844F2B0086532B0083502A00340F11004C1516001A040400000000000000
      00000000000000000000000000000000000000000000000000000066CC000066
      CC000099FF000099FF0000CCFF000066CC000066CC000099FF000099FF000066
      CC000066CC000099FF000099FF0000CCFF0033FFFF0066FFFF0099FFFF0000CC
      FF0033FFFF0099FFFF0099FFFF000099FF000099FF0000CCFF0033FFFF0066FF
      FF0099FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020600000000000002040000020
      C0000000FF000020E0000020A0004040C0004040E0000020E00040204000F0FB
      FF00404040000020E0000000FF00000080000020400000000000000080000020
      60000020800000A0E00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000080073008400BD18B500C618BD00DE52C600AD29A500BD00
      BD00C600C60084008C006B087B004A0052000000080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000048141400BB904000F4D353007D4F28000C07
      0400945C3000814F2B0087552C000402010000000000BE7B40008A572D005E39
      1E0004020100A46836007743270040131400511819000D000000000000000000
      00000000000000000000000000000000000000000000000000000066CC000066
      CC000099FF000099FF0000CCFF000066CC000066CC000099FF000099FF0000CC
      FF0033FFFF0066FFFF0099FFFF000066CC000066CC000099FF000099FF0000CC
      FF0033FFFF0099FFFF0099FFFF000099FF000099FF0000CCFF0033FFFF0066FF
      FF0099FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020600000000000002040000020
      A0000020C0000020C0000020C0000020C00000008000C0C0C000F0FBFF000000
      0000F0FBFF00C0C0C0000020C0000000800000000000000080000060C00000A0
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000080073008400BD08AD00CE08C600D629BD00DE4ABD007B08
      8400B518C600B539AD0063087300000008000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000017030300692F1F00E0BA4C00BC924000694022000704
      0200C987470083522C00814F2B000906030000000000D7944E0088552C00905F
      2F00120B0600D1964E00733E2600551F1D00411112000D000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000066CC000066CC000099FF000099FF0000CC
      FF0033FFFF0066FFFF0099FFFF000099FF000099FF0000CCFF0033FFFF0066FF
      FF0099FFFF000099FF000099FF0000CCFF0033FFFF0066FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020600000000000402040004040
      400000000000402040004040E0004040E000402040000020A000404040000000
      000000008000000080000000800000000000002060000060C000000000000020
      6000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000180000001800
      00001818000010001800000000006B007300AD10AD00C631B500C631B5009C10
      940073007B007B18840000000800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000017030300874F2900E2BD4E00A4743700633E20000402
      0100956736008B582E007E4C2A0009060300000000008F592E008A572D008B58
      2D00120B06009568360076422700602B2100360E0F000D000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000066CC000066CC000099FF000099FF0000CC
      FF0033FFFF0066FFFF0099FFFF000099FF000099FF0000CCFF0033FFFF0066FF
      FF0099FFFF000099FF000099FF0000CCFF0033FFFF0066FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000208000000000000040A00000000000000000000000
      00000040C000000000000000000040204000C0800000C0C0200040404000C0DC
      C000000080000020A0000020C0000000000000206000000000000020C0000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000018000000181818000000
      0000737373007373730018000000181818001810100018292900840884006300
      730052005A001800290000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000015030300B2823900DDB64B009C6D34007A4A27000906
      03006F47250085532C007C4A2900120B060000000000CF804400996731005434
      1B000E090500C47C4100794628006F3924000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000066CC000066CC000099
      FF000099FF000066CC000066CC000099FF000099FF0000CCFF0033FFFF0066FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000020800000208000000000000000000000000000C0802000C08020004080
      E000000000000020A00000204000C0800000FFFF0000404040000020E000C0C0
      C000002060000020A00000206000000000000020600040202000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001800000018000000000000000008
      180008101800ADADB5009CADAD00180000000000080021182900181818001000
      1800100018000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000017030300D7AD4700ECC85200AF833B007D4A29005833
      1D0009060300DF834900724327001B1109003A2413003A24130090602F000906
      030026180D00996132007C492900794326000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000066CC000066CC000099
      FF000099FF000066CC000066CC000099FF000099FF0000CCFF0033FFFF0066FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      E00000008000000000000000000000000000C0C0400000000000000000000020
      400040C0E0004080E00040A0E00040A0E000404040000020A0000020E0000020
      C000002060000000800000204000000000000020800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000018000000427BAD0000000000001829001842
      6B00315A84002131390073737300000000000000000039527B00181818001800
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001D050500DBB44A00F4D05400D2AB48008D5E30008756
      2D003622120022140B001B1109008D592E0082512A001B1109000E0905002214
      0B00B16E3A0089572D00804E2A007F4B29000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000066
      CC000066CC000099FF000099FF0000CCFF0033FFFF0066FFFF0099FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000020
      A000000000000000000000000000000000008080800040406000808080004040
      6000002040004080E00040202000402020000000800000000000000000000020
      4000000000000020A00000000000002060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000180000005AB5FF0000294A00185A7B00528C
      C600295A8C00000818004A8CBD000000000000000000427BAD00180000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001A0404008F592C00D0A94700CCA44600A77939008F5F
      300088572C0082512A00814E2C00814F2A008A572D009361300084562B00A667
      360087552C00804F2B008E5D300082512B000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000066
      CC000066CC000099FF000099FF0000CCFF0033FFFF0066FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080E0000020
      8000000000000000000000000000000000004040C0000020A0004040A0008080
      800000204000C0C0200000000000402020000000000000206000000080000000
      00000000000000000000000000000040A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000180000001800000000294A00426373004A7B
      A50000294A0000000000395A84005AB5FF005AB5FF0018000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001D0505008B582C00B88C3E00BD934100A779
      39008B5C2F0085522C007F4C2900814F2A008B592D0089562D007C4A29007A48
      29007F4D2A0096663200BB9240007D4C2B000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000066CC000066CC000099
      FF000099FF0000CCFF0033FFFF0066FFFF00CCFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080E0000020
      80000020800000208000000000000040E0000060E0000060E000000080008080
      A00040404000C080200000000000404040000000800000008000000000000000
      00000000000000000000000080000080E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000018000000180000001800000018000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001202020094633200C49A4300C298
      4200BF9441009568340087552C008A582D0089572D0089562D0088572D009E6F
      3500A2743700B38A3D009D7135006F4228000D00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000066CC000066CC000099
      FF000099FF0000CCFF0033FFFF0066FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000A0
      E0000060C00000008000000000004080E00040A0E00040A0E0000040C0004040
      A00000204000C0C0200000000000404040000000000000208000002080000020
      800000208000002080000080E000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D050500AA7B3800CAA0
      4400D6AF4900F8DC5400CFA94700CEA64600DDB84C00E2BD4D00B3873C00A071
      350087582E0084552D0059241F00260B0D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004080E00040C0E00040A0E0000060C0000020
      600000000000000000000000000000000000000000000000800000A0E00000A0
      E00040C0E0000080E00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000250808009C73
      3800C09F4600E2C75300E1C25000DAB74C00B4883C00AB7D3900966633007744
      28007A472800521A1A0021090B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000040E0000040E000002060000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000290A
      0A004B151700390F0F002207070025080800320C0C00310B0B00290A0A002207
      0700360E0F001202020000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004A6163005265
      63005A757300637D840094BABD009CC7CE00B5E7EF000000A5000000A5002128
      2900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000001
      09000002110002031A0001021700010315000101110001011100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005A7573008CAE
      B500213C5A0000000000000000006B8A8C00738E9400B5E7EF00B5E7EF002128
      2900212829000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000010B000103150002051D000305
      290004073E0004073E000407420005094600030529000205260002041F000102
      170000010C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002134
      4A00429ABD000000000000000000000000006B8A8C00738E9400A5CBD60084A2
      A500B5E7EF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000021100073B83001241920004063B0005094600040852000610
      7800050A6900050A4C0005094600050A4C00060B5700060B570005115300074D
      9100092D630001051C0001051900000211000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000018304A003992B5000000000000000000000000000000A5000000A5001820
      2100182421002130310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D70000000000000000000000000000000000
      0000000000000000000000000000D70000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000004073E000858B500050A69000610780008148F0007108300061078000811
      880008148F0008118800060D530008148F0008107100080E5900073B83000306
      350002052600051E4C000921550003092F0000010E0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000018344A004296B50000000000000000000000A500B5E7EF001824
      29001820210018202100E7FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF6868000000000000000000000000000000
      00000000000000000000D7000000FF686800D700000000000000000000000000
      00000000000000000000D7000000FF686800D700000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001302
      020023070700250808001F060600230707002508080013020200100101000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000203
      11001276D8000A189F0008148F000D20B6000A189F000912A4000912A4000811
      9A000912A4000A1683000A145E00061078000A145E0008107100074EA1000205
      1D0001021E0001011C00020526000C237A000103130001020C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000182C420018384A00212C29007B9EA500B5E7EF007BA2
      A50031454A006B7D7B00E7FFFF00DEFBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFC1C1000000000000000000000000000000
      0000000000000000000000000000D70000000000000000000000000000000000
      0000000000000000000000000000D70000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000020060600824E
      2A00734027005D251E0061291F0051171900521819005A1F1B00441212000D00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000BB6
      EC001832D0000A189F001832D000142ABA00080E94000D18CC000D18CC000D18
      CC000E1DA70011197D0013207E000C1E8B00081071000810710006668E000204
      1800020327000102220002042C000C237A00030826001757A2002462B200117B
      C200000003000000000000000000000000000000000000000000000000000000
      000000000000000000000000000010284200212C31003145420073969C00B5E7
      EF00E7FFFF000000A50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF686800FFC1C100FFF7F700FFC1C100FF686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000230809008C5A2E008D5C
      2F00622A1F0058201C00622B2100622A1F0050181900471416004D1618004312
      13001F0606000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010204002291
      EC00254BD9001936B900117BC2001757A2002D79C800142ABA000D18CC000E21
      AE00162B7C002545A90018328F00122AAE000C1887000A189F000B62B5000104
      15000102250001012A00010123000A1B64000A15440000010B00010415001D4D
      8B00051037000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000021303100394D4A00B5E7EF000000
      A5000000A500000000000000840000007B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFC1C1000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF68
      6800000000000000000000000000000000000000000000000000000000000000
      0000D70000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000025080800986532009F6D34006B37
      2300541B1A00632D2000854B2C0077432600673021004F171800461415004D16
      1800491516001001010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010204002C9B
      F1003261E1000DA5E20001012E00030539000B0E5300266CC7001832D0001936
      B9001A35A9000858B5000858B500142ABA000B1895000C1887000B62B5000203
      1400010218000000260001011C00050A4C000F25630000010900000000000000
      00001D4D8B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000394D4A00394D4A000000A500DEFBFF00E7FF
      FF000000000000007B009C8A8400000073000000AD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF6868000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFC1
      C10000000000000000000000000000000000000000000000000000000000D700
      0000FF686800D700000000000000000000000000000000000000000000000000
      0000000000000000000000000000160303009E6E3500BB913F0084512B006730
      210076412700703E2600743B2600652F2100753F2700714026005A211C004E16
      1800511819004112130010010100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002DB2
      F3002C69EA000450820002042C0003062D00050931002987F3002C69EA002851
      C1000575CB0001032700020545001351C9000E1DA7000C1887000575CB000001
      0C0001031D000101200000011600010327000F25630000000700000000000000
      00002768B5000000070000000000000000000000000000000000000000000000
      00000000000000000000394D520042555A009CC7CE00ADD3DE00D6F7FF000000
      0000947D7300C6B2AD00C6BAB5006B5D5200A58E840000009400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF68680000000000000000000000000000000000FF686800FFC1C100FFF7
      F700FFC1C100FF68680000000000000000000000000000000000000000000000
      0000D70000000000000000000000000000000000000000000000000000000000
      00000000000000000000230707007F4B2900C79C43008A572D00804E2A006A35
      23007E4A29007F4D2A0097553200784229007A462800A2733600764428005A20
      1C00581D1B0051181900350D0D00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000001020C002DB2
      F3002851C10005AED3000406310004064F00030539001F9CF8003673EB000D7D
      D0000205450003052900030832002291EC000A37BD000C237A00197DB2000204
      1800030529000205320001011F0001011B00092D630000000500000000000000
      0000276ABA0001071C0000000000000000000000000000000000000000000000
      000000000000000000004A656300738E9400738E9400B5E7EF00000000006B5D
      5200A58E840073655A008C7D7300DED7CE006B5D520000007300000094000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFC1C100000000000000000000000000000000000000000000000000FFC1
      C100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000040607005A201C00E5BF4E009A6B330084512B00814F2A007945
      270086532C0084522B00190D0800B0693A0086522C0085522C008A582E006B37
      23005D251E0046131500551A1900160303000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000102090018C7
      EE002851C10005AED30003062D0004064F0003053D0011BCF6003673EB000BB6
      EC00050A42000307300003062D00197DB200124192001A92D400093A78000204
      230003062200050B34000101250000011600092D630000000500000000000000
      0000276ABA000108210000000000000000000000000000000000000000000000
      0000000000000000000000000000738E94009CC7CE0000000000000000000000
      00006355520063514A0052453900948A8400CEC3BD0000005200000084000000
      A500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF68680000000000000000000000000000000000FF686800FFC1
      C100FFF7F700FFC1C100FF68680000000000000000000000000000000000FF68
      6800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000012020200BE903F00D8B24A0086532C00834F2B00804E2A008250
      2A008D5A2E00170D080005030200492E180084512B0084522B0084522C008C58
      2D006F3A240048151600531818001A0404000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000109002DB3
      D1002DB3D1000693BB000205260004065B0004074200094583001DA5E50005AE
      D300060D530005093C0005093C001A92D4001DA5E500060E3D00074D91000205
      32000203210004092A0001012000000113000921550001041500000000000208
      23002969BB000108210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000063514A0000000000000000004A413900B5AABD0000004A000000
      630000007B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF686800FFC1C100FF686800000000000000000000000000000000000000
      0000FFC1C1000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D700000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000013020200D7AC4700AE7F3A0089552D0086532C0087552D009861
      310027190D008A572E003B2613009666310040271500824E2A008B552D008F5C
      2F007F4C2A006732220049151600160303000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002DB3D1000B2949000205450004065B001E2C9C00070E370006668E0018C7
      EE000A145E00080F440004092A00050B2E000921550002042C00096AAE000509
      46000102220004092A0001011900000211000A1C4C0001051C00000000000206
      1D00266CC70000010B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B655A000000A5000000
      520000007B000000BD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF68680000000000000000000000000000000000000000000000
      0000FF6868000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D7000000FF686800D7000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000016030300C0944000A878380089552C007B472800966030003E2B
      1400A36C3500633D20000101010057391D00C58740002B1A0E00824E2A008D57
      2E0086532C006F38240050171900130202000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000203
      25002DB2F300020336000A1B640004064F00050A690002032100060E3D000102
      220004072D00050B3400050B2E000D1B3E00050B34000305290001012E000B6B
      C100000026000205200001011C000101150001051C0002051D00000000000107
      1C00266CC7000000010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000007300000C
      BD000000180000004A000000D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D700000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A040400B3843B00A27337007B472800824D2A00372612000C08
      040023160B0006040200010101000503020021160B000503020006040200AA68
      38007D4928007641260069332200100101000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      07000BB6EC0002033600050A4200030635000305390002042300010120000204
      1F0003072100050B2E000307240002042300060A3A0002043F0002043F000693
      BB0002042C0004062A0001031D0001031D000306220000021100000000000107
      1C002D79C8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006B5D5200A58E
      8400CEC3BD005A49420000004A000000D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000018040400B4883C00AD8139007B47280087532C008E5B2E003B26
      1300895A2D0090602F000B07040080552A008B592E001F140A0083522C008C56
      2C0086532C0082502B008E5B2D00130202000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      03001A92D40003053D000408520002043F00070E3100060E3D0061D6F7000BB6
      EC001A92D400197DB200050B2E0003062200020423000204250001023200096A
      AE0002042C000101200001011B0001021E0002041F0000011300000000000000
      00002462B2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B5D520063514A006355
      520063555200CEC3BD0073655A00000084000000D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A040400B3833B00B4853B007C4728008A572D0088552C008656
      2C00362512009767320048311800CC8A4300462E16008B582E008B552C00905C
      2E00804F2A0085532C0078402500180303000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000020520001A62CB000102320003062D00050C2D00289EE1000E1A45001322
      5700111D4B000B113300289EE100289EE10004092A000308260001031D000742
      7F00020336000102180000011300020423000205260000000700000005002462
      B20000010C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000063514A000000
      0000000000006B5D5200C6BEB5006355520000007B000018C600000000000000
      000000000000000000000000000000000000000000000000000000000000FF68
      68000000000000000000000000000000000000000000FF686800000000000000
      00000000000000000000000000000000000000000000FFC1C100000000000000
      0000000000000000000000000000000000000000000000000000FF6868000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000016030300B1853B00D3AC48007E4A2A007C4828008C582D009463
      300086582C00513B1B00060402001D130A0095613000814D2B008B592E00AE76
      3900A06F3400834F2A0024070700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001454B5000102320004092A00398CD7000A1C4C00213B97000A15
      44000B1133000A145E000C153E0013225700329CE700060C2B00040823000203
      1D000945830001021B0000010E00000211000307300000010E00030928002462
      B200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006B5D5200C6B6AD0000002100000094006375D6000000
      0000000000000000000000000000000000000000000000000000FF686800FFC1
      C100FF68680000000000000000000000000000000000FFC1C100000000000000
      0000000000000000000000000000FF686800FFC1C100FFF7F700FFC1C100FF68
      6800000000000000000000000000000000000000000000000000FFC1C1000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000160303009E6E3500E6BF4E007C482800834F2C00A77636008E5C
      2F009F6E3400855B2C000906030083532B00834B2B0084512B009D6C3400AF81
      3A008A582D004C1516001A040400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000003072100398CD7001A2D6E002E50A9000A1C4C000DA5
      E200096AAE00080F3700152A7500142A6E000E1A45002470B9000C153E000203
      160002031D000102170000010E000001090005093C0002061E002D79C8000208
      2300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000846D6B00B5AAA50073655A00000094000000
      000000000000000000000000000000000000000000000000000000000000FF68
      6800000000000000000000000000FF686800FFC1C100FFF7F700FFC1C100FF68
      68000000000000000000000000000000000000000000FFC1C100000000000000
      000000000000000000000000000000000000FF686800FFC1C100FFF7F700FFC1
      C100FF6868000000000000000000000000000000000000000000000000000000
      0000000000001603030097673200D6AE4800794427009A6B3400905D2F00AC7F
      3A009664310075422600844F2B00804C2B00834E2B008E5D2F00A57638009C6C
      34006B3522001C05050000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000050B2E001C4E9500203A8E002D51B60014276B0061D6
      F7000DA5E20005093C001226730012236A00101F620008103A002470B9000A15
      440002031600010115000001090001011100093A780009326F00398CD7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000846D6B00A58E840000007300B5A29C006375
      D600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFC1C100000000000000
      00000000000000000000000000000000000000000000FF686800000000000000
      0000000000000000000000000000000000000000000000000000FFC1C1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001603030098673200D9B04B007A4528007F4B29007E4928008651
      2B00794527007A452800784428007945280096643100B3863C00B88B3D00662F
      20001A0404000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000002061E001A2E74003F61C2004071F400355BE4001322
      570009123F000A1B6400172D830012236A00101F6200162B7C00070E37001B69
      B100050C2D000103130000010E0001031500094583002D79C800000001000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006B5D520063514A006B5D520094827B008C7D73000000
      AD00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF6868000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000016030300A4743600FEE354009A6932007E4A290090602F00814D
      2A008A5A2F0086512B0088542D00A0713500BC903F00A97B3900824B28002709
      0900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000020823002545A9003F61C2005E95F6003261E100274E
      CE00213B9700162B7C0018328F001933880012236A0012236A001B368900050C
      2D001C65AD000306220001031300030826001D4D8B0000010E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000846D6B00000000006B5D520094827B000000
      A5007B8EDE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000025080800D2A44400FFE45400FFE45400DBB64B00BF954000C198
      4100CA9E4500DAB54A00DEB94A00BB8D3F00A4763600824927001A0404000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000003001D358D003F61C2004772E0003D69E3002E5B
      DF002648B6002648B600203A8E001D328900152A750013266D001A3383001933
      8800070E31001C65AD0008103A00030622001D4D8B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000073655A009482
      7B007B8EDE000000000000000000000000000000000000000000000000000000
      00000000000000000000FF686800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF6868000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000016030300945D2D00D5AC4700DFBB4D00FFE45400E8C24F00D2A7
      4600C4994200AD7F3900AC7B38007B4225001F06060018030300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000007001E378A003557BB003C66DA003D69
      E3003D69E3004071F4002D51B600213B9700172D83001226730014276B001327
      6B0013276B000508260011548E00165590000000070000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007365
      5A000000BD000000000000000000000000000000000000000000000000000000
      000000000000FF686800FFC1C100FF6868000000000000000000000000000000
      000000000000FF68680000000000000000000000000000000000000000000000
      0000FFC1C1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000012020200834E2A00B78A3D009D6C34008A592D007742
      26005A211C00380E0F001A040400180303000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000002061D0013266D00203A8E00385F
      C4003557BB003C66DA002648B6002545A900162B7C001B3689000F2563000F25
      6300172D830013266D000309280002051D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000073655A007365
      5A00C6B6AD000000000000000000000000000000000000000000000000000000
      00000000000000000000FF686800000000000000000000000000000000000000
      0000FF686800FFC1C100FF686800000000000000000000000000FF686800FFC1
      C100FFF7F700FFC1C100FF686800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000130202002508080023070700180303001A04
      04001A0404000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000101F6200213B
      97001E378A001A3383001A33830013266D00132257000A154400000003000000
      0300010519000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007365
      5A00B5A29C0094A2DE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF68680000000000000000000000000000000000000000000000
      0000FFC1C1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001051900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000073655A006375D60000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF6868000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000AD0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF686800FFC1C100FF6868000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000E00000000100010000000000000E00000000000000000000
      000000000000000000000000FFFFFF00FFFF1C7F000000000000000000000000
      FFFE083F000000000000000000000000FFFE0831000000000000000000000000
      FFF80020000000000000000000000000FFF80020000000000000000000000000
      FFF80000000000000000000000000000FFF00000000000000000000000000000
      FFC00000000000000000000000000000FF800000000000000000000000000000
      FF000000000000000000000000000000F8000000000000000000000000000000
      F0000000000000000000000000000000F0000000000000000000000000000000
      F0000000000000000000000000000000E0000000000000000000000000000000
      8000000000000000000000000000000080000000000000000000000000000000
      8800000100000000000000000000000080000000000000000000000000000000
      80200000000000000000000000000000C0000000000000000000000000000000
      E0000001000000000000000000000000C0000001000000000000000000000000
      000000070000000000000000000000000000000F000000000000000000000000
      1000000F0000000000000000000000000000001F000000000000000000000000
      000000FF000000000000000000000000800007FF000000000000000000000000
      C0000FFF000000000000000000000000E0001FFF000000000000000000000000
      F0303FFF000000000000000000000000FF8007FFFFFFFFFFFFFFF060FC0001FF
      E0000003FFFFFFFFFFFFE000F00000FFC0000001FFE1FFFFFFFFA000F000003F
      80000000FFC007FFFFFE0000E000301F80000000FF0000FFFFFE0000E000000F
      00000000FC00001FFFFC0000E000000700000000F800001FFFFC0000E0004003
      00000000F000001FFFF80000E0004103007FC000E000001FFFF00000E0000901
      00000001C000001FFFF00000E000080080000001C000001FFFF00000E0002000
      80000001E000001FFFE00000E0000440C0000003FC00001FFE200000E0008010
      C0000007FC00001FFC000000E0008110E000000FFC00001FDC000001E0808000
      F000001FFC00001FF8000003E0808000F800007FFC00001FF8000003E7400000
      FE00007FFC00001FB0000003E0000000FF00007FFC00001FE0000007E0000000
      FF07C01FFC00001FC000000FE4C80000FE07C00FFC00001FC000001FE4C80000
      FC078007FC00001F8000003FE0880000F8078007F800007F8000007FE00C8000
      F0030003FF00007F000000FFE4840000F0030003FFFC007F000001FFE0000000
      F0030003FFFC007F000003FFE0484080F0030003FFFC007F000001FDE0484880
      F0030007FFFC007F000001F7E0484880F0070007FFFC007F0001817FE0880881
      F80F800FFFFC007F0003837BF0000001FE1FC01FFFFC007F070F83FBF8000003
      FFFFE03FFFFFFFFF0FFF83FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00FF
      FFFFFFFFFFFFFFFFFFE007FFFFF8001FFFFFFFFFFFFFFFFFFF0001FFFFF00007
      FFFFFFFFFFFFFFFFFE00007FFFE00007FFFDFFFFFFFFFFFFF800003FFFC00003
      FFF07FFFFFFFFFFFF000001FFF800007FFE03FFFFFFFFFFFE000000FFF000007
      FFE03FFFFFFFFFFFE0000007FC000003FFF07FFFFFFFFFFFC0000007F8000001
      FFF07FFFFFFFFFFF80000003F0000000FFF07FFFF000000F80000003E0000000
      FFF07FFFF000000F80000001C0000000FFE03FFFF000000F00000001C0000000
      FFC01FFFF000000F0000000180000000FFC01FFFF80001FF0000000180000000
      FDE03DFFF80001FF0000000180000000F89048FFFF8007FF0000000180000000
      F80000FFFF8007FF0000000100000000F000007FFFE007FF0000000100000000
      F000007FFFE007FF0000000100000000F9C71CFFFFFFFFFF0000000180000000
      FF870FFFFFFFFFFF8000000180000001FF0F87FFFFFFFFFF8000000380000003
      FF0F87FFFFFFFFFF800000038000000FFF0F87FFFFFFFFFFC0000007C000007F
      FF870FFFFFFFFFFFE0000007E000007FFFC01FFFFFFFFFFFE000000FE00000FF
      FFE03FFFFFFFFFFFF000001FF00001FFFFF07FFFFFFFFFFFF800003FF80003FF
      FFFFFFFFFFFFFFFFFE0000FFFE0007FFFFFFFFFFFFFFFFFFFF8001FFFF801FFF
      FFFFFFFFFFFFFFFFFFE007FFFFF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000001F
      FFFFFFFFE3FFFFC7FFFFFFFFE000000FFFFFFFFFE0FFFF07FFFFFFFFC0000007
      FFE38FFFE07FFE07C0000003C0000007FFE007FFF03FFC0FC0000003C0000007
      FFC003FFF81FF81FCFFF8003C0000007FF8003FFFC0FF03FC0000003C0000007
      FF8001FFFE07E07FC0000003C0000007FF8001FFFF03C0FFC0000003C0000007
      FF0000FFFF8181FFC0000003C0000007FF0000FFFFC003FFC0000003C0000007
      FE0000FFFFE007FFC8000003C0000007FC0000FFFFF00FFFCC000003C0000007
      FC0000FFFFF81FFFCC000003C0000007FC0000FFFFF00FFFCC000003C0000007
      FC0000FFFFE007FFCC000003C0000007FC0000FFFFC003FFCC000003C0000007
      FC0001FFFF8181FFCC000003C0000007FE0001FFC703C0E3CFF80003C0000007
      FF0001FF8207E041CFFC0003C0000007FF0001FF040FF020CFFE0003C0000007
      FE0001FF181FF818CFFF0003C0000007FE0001FF1007E008C0000003C0000007
      FE8001FF0007E000C0000003C0000007FE0001FF0047E200C0000003C0000007
      FF0001FF00C7E300C0000003C0000007FFF003FF81C7E381C0000003C0000007
      FFFF87FFC00FF003C0000003C0000007FFFFFFFFE01FF807C0000003C0000007
      FFFFFFFFF03FFC0FFFFFFFFFC0000007FFFFFFFFFFFFFFFFFFFFFFFFE000000F
      FFFFFFFFFFFFFFFFFFFFFFFFF24924BFFFFE7FFFFFFFFFE1FFFFFFFFFFFFFFFF
      FFFC3FFFFFFFFFC0FFFFFFFFFFFC1FFFFFF81FFFFFFFFF00FFFFFFFFFFF80FFF
      FFF00FFFFFFFF000FFFFFFFFFFF007FFFFE007FFFFFFE000FFFFFFFFFFF007FF
      FFC003FFFFFFC000FFF9F1FFFFE003FFFF8001FFFFFF8000FFF0E1FFFFE003FF
      FE00007FFFFF0000FFE0E0FFFFE003FFFE00007FFFFE0000FFE040FFFFE003FF
      FE00007FFFFC0000FFC0407FFFE003FFFC00003FFFF80001FFC0007FFFE003FF
      FC00003FFC700003FFC0007FFFF007FFFC00003FF830000FFFC0003FFFF80FFF
      F800001FF000003FFFC0003FFFFC1FFFF000000FF000007FFF80003FFFF81FFF
      E0000007F00000FFFF00003FFFE00FFFE0000007F00001FFFE00003FFFC007FF
      E0000007F00001FFFC00003FFF8387FFF800001FF00001FFF800003FFF07C3FF
      F800001FE00001FFF800003FFE0FE3FFF000000FE00003FFF800007FFC1FE1FF
      F000000FE00003FFF80000FFFC3FE1FFF000000FC00007FFF80001FFF87FE1FF
      F000000FC00007FFFC0003FFF87FC3FFF000000FC0000FFFFE0607FFF0FF83FF
      F800001FC0001FFFFF0F0FFFF0FF07FFFC00003FC0003FFFFFFFFFFFF03C0FFF
      FE00007FC000FFFFFFFFFFFFF8001FFFFF0000FFC003FFFFFFFFFFFFFC003FFF
      FF0000FFE00FFFFFFFFFFFFFFF00FFFFFFF01FFFE01FFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFF03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0067FFFFFFFF
      FFFFFFFFFFFFFFFFFFFE0003FFFFFFFFFFF01FFFFFFFFFFFFFFE0003FFFFFFFF
      FFE007FFFFFFFFFFFFFC000FFFFFFFFFFF8003FFFFFFFFFFFFF80007FFFFC1FF
      FF0001FFFFFFFFFFFFF00003FFFF80FFFE0000FFFFFFFFFFFF800003FFFF007F
      FE00007FFFFFFFFFFF000003FFFE003FFE00007FFFC00FFFFF000001FFFC003F
      FE00007FFC0000FFFF000000FFF8003FFE00007FFC0000FFFF000000FFF8003F
      FE00003F80000003FF000000FFF8003FFE00003F80000003FE000001FFF8007F
      FE00003F80000003FE001001FFF000FFFC00003F80000023FC001003FFC201FF
      FC00003FFC00002FF0000007FF8003FFFC00007FFC00080FE200000FFF0007FF
      FC00007FFF000BFFC600001FFE008FFFFC00007FFF0003FFCE00003FFE019FFF
      FC00007FFF002FFF8C00007FFE003FFFFE00007FFF000FFF80001C7FFFC43FFF
      FF00007FFF00BFFFC00000FFFFFFFFFFFF8000FFFF003FFFE00001FFFFFFFFFF
      FFC001FFFFFFFFFFFE0F83FFFFFFFFFFFFE003FFFFFFFFFFFF1FFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF800FFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF8007FFFFFFFFFFFFFFFFFFFFFFE03FFF8003FFFFFFFFFFFF
      FFFFFFFFFC0007FF8203FFFFFFFFFFFFFFFFFFFFF80000FFE101FFFFFFFEFEFF
      FFFFFFFFF000007FF000FFFFFEFC7C7FFFE01FFFE000000FF8007FFFFEFEFEFF
      FFC00FFFC0000007FC00FFFFF83FFFFFFF8007FFC0000007FE007FFFFEFFEFF7
      FF0003FFC0000023FC003FFFFEFFEFE3FE0001FFC0000023F8001FFFFFF783F7
      FC0001FFC0000023F8000FFFFFF7EFFFF80000FFC0000023FC2007FFFBC1EFFF
      F80000FFC0000023FE7003FFF1F7FF7FF80000FFE0000023FFFB01FFFBF7FE3F
      F80000FFE0000023FFFF80FFFFFFFF7FF80000FFE0000023FFFF807FFFFFFFFF
      F80000FFE0000023FFFF003FFFFFBFFFF80000FFF0000007FFFF801FEFBFBFDF
      F80001FFF0000007FFFFD80FC7BE0FDFF80001FFF800000FFFFFFC0FEE0FBF07
      F80003FFFC00000FFFFFFC07FFBFBFDFF80007FFFC00001FFFFFF807FFBFFFDF
      F8000FFFFC00003FFFFFFC03FFFFFFFFF8001FFFFC00003FFFFFFE83FDFFF7FF
      F8003FFFFE00007FFFFFFFC3F8FBF7FFFC00FFFFFF0000FFFFFFFF83FDF1C1FF
      FE07FFFFFF8001FFFFFFFFC1FFFBF7FFFFFFFFFFFFC03FFFFFFFFFE1FFBFF7FF
      FFFFFFFFFFFFFFFFFFFFFFF1FF1FFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFBFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object imgManaDrinker: TImageList
    Left = 64
    Top = 4
    Bitmap = {
      494C010106004402040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF0001042600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF0001042600FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00390642004524560044245600200325001F20
      2C001447B90000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00002A56000013280000132800001B33001F20
      2C001447B90000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00571E70005B287B0073359B00672D8A002C2C31004B4B
      4B0028042E0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00002D7100002864002C2C31004B4B
      4B00001D3C0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000014071900652D8700955BC3007D3BAA002C2C31003D3D42004E1B
      65003E09480028042E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000916000027610000418600004889002C2C31003D3D4200002C
      5B00001E4B00001D3C00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      00000A0A0A0076359E008644B800FFFFFF0067288800000B93006A308F006030
      830033053B000F02120000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000A0A0A00003A7800003D7E003B73A80000448000000B930000296500002D
      5E00001C45000008150000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000393939005E21770066358D00FFFFFF00722F97001447B90074339B00602D
      82003C06470028042F00003A9F00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000B1B000022550000235700001E4B00002C6F001447B900205890000024
      59000021530000163700003A9F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF003F3F
      3F00260A2F00772F9B005D2C7E007641A6002C2C3000393A3F00531E6C002209
      2A0000349A000A3E8F0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF003F3F
      3F0000122D000056930000436F0030618A002C2C3000393A3F00003065000010
      290000349A000A3E8F0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000003F3F
      3F001B07210001042600823AAD002C2C300032323700652380003A0644000034
      9A0009010B0015021800FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000003F3F
      3F00000D200001042600005998002C2C300032323700FFFFFF00FFFFFF000034
      9A001B1B1B00000B1C00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000349A00292929000000
      0000CC851A00000000001F202B00E9F31D006523800033053C002E053500003A
      9F000D010F00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000349A00292929000000
      0000CC851A00000000001F202B00E9F31D00004B8000001C460000193F00003A
      9F0000071100C2C2C200FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000025262600232323007072
      8000797D7D00010538002323230041074B0012021500120215001D0322000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000025262600232323007072
      8000797D7D00010538002323230000245900000D1C00000A1900001028000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000075D80000349A00000000001363
      DF00000E950044433800000000002528320000000000222222000041A6000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000075D80000349A00000000001363
      DF00000E950044433800000000002528320000000000222222000041A6000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00000000000000000049BE
      FF001751C6000000000018000000000000000091F30038B4FC0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000049BE
      FF001751C6000000000018000000000000000091F30038B4FC0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000050505006C3A8C009158BA00502257006F3C
      7600030202000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020400000204000002040000020
      4000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004627550041074B0040124F00390643003906
      4300130217000505050000000000000000000000000000000000000000000000
      0000000000000000000000000000002060000020600000206000002060000020
      6000002040000020400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000800000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002A005C002A005C002A005C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000704982004D1B63006D2B9200793CA4005E267A005A1C
      73003906430013021700100E0E00000000000000000000000000000000000000
      0000000000000000000000206000002080000040800000408000002060000020
      6000002040000020400000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD00C600B5009C007B0094005200
      6300000000000000000000000000000000000000000000000000000000000000
      000000000000000000006300C6008C00B40046007E0053008F0046007E002A00
      5C00000000000000000000000000000000000000000000000000000000000000
      00000239A10025072D007F44B2008546B9007C35A2005A1C7300692786006528
      8300622980002C07350005050500000000000000000000000000000000000000
      000000A0E00000206000004080004060A0004060A00000408000002060000040
      8000002060000020400000000000000000000000000000000000000000000000
      00000000000000000000000000009C00AD00FF42C600D608B5006B007B005200
      5A00001000000000000000000000000000000000000000000000000000000000
      0000000000005E00AB00F600D500A700CE0052008F004E00880053008F002A00
      5C00000000000000000000000000000000000000000000000000000000000000
      00000191F4005A1C73006C258A00AC7CE10074339A006C258A00662E8900622B
      850040124F003906430003020200030202000000000000000000000000000000
      00000040A0000020400000206000002060000020600000408000004080004060
      8000002060000020400000000000000000000000000000000000000000000000
      000000000000000000000000080094189400E729CE00C600BD008C0094005200
      5A00000800000000000000000000000000000000000000000000000000000000
      00001C111800520088008300A90059008F004F00880048007E004E0088002A00
      5C00000000000000000000000000000000000000000000000000000000000000
      000003020200692888008540B5008546B9006C3A8C00712E9600642685006229
      800040124F002D2E2C00013B9D000A0607000000000000000000000000000000
      0000000000004080A00000608000004060000060800000408000004080000020
      4000000000000040A00000A0E000000000000000000000000000000000000000
      0000000000000000000000000800BD18B500DE52C600BD00BD0084008C004A00
      5200000000000000000000000000000000000000000000000000000000002F2F
      2F002D2A2A008000A6008700B0007C00AB008F00B40054008F008F00AD002A00
      5C00201E1E000000000000000000000000000000000000000000000000000505
      0500030202006C258A00672E8600652883005C2175004D1B63005A1C73003906
      430001349A000191F40005050500000000000000000000000000000000000000
      0000000000000040800000408000004080000040600000206000002060000000
      00000060C0000020400000000000000000000000000000000000000000000000
      00000000000018000000100018006B007300C631B5009C1094007B1884000000
      0000000000000000000000000000000000000000000000000000000000009392
      920000000000E500D50074009C009400B0009A00B700B000BD003A007000181A
      1F005B5B5C000000000000000000000000000000000000000000100E0E000302
      0200000000005D0E6A006B318F00813AAD00551B6B005D0E6A0041074B001D04
      23000A06070036213D00000000000000000000000000000000000040A0000000
      0000404040004060600000408000004080000040800000408000002060000020
      4000402020000000000000000000000000000000000000000000000000000000
      00001800000000081800ADADB500180000002118290010001800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000090A0700B6B9CB0058627A0008070B0059027000F400DB002A005C008F8F
      9000181A1F00000000000000000000000000000000000173D800000000000302
      0200100E0E0008010E0041074B0050095D004909560050095D00390643002C07
      350005050500000000000000000000000000000000000060C000000000000000
      0000404060004040600040404000002040000000000000204000002040004060
      A000000000000000000000000000000000000000000000000000000000001800
      000000294A00528CC6000008180000000000427BAD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000C0B2800105CDB000025B100A9A49A00090F150044007B00000000000000
      0000000000000000000000000000000000000505050001349A00000000000302
      02000D269E007A80850037364000050505000173D80005050500050505000142
      A80000000000000000000000000000000000000000000040A0000040C0000040
      E0000060E0008080A00040404000000000000040A00000000000000000000080
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000180000001800000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004BC3FF002779EE00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000191F400010D96002E8E
      F2002E8EF2002F56A2002E1417004F4F4E0001349A000239A100014CB1000302
      0200000000000000000000000000000000000000000000000000000000004080
      E00040A0E0000020600000000000000000000000800000A0E0000080E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000505
      0500084BCE000302020000000000000000000302020005050500050505000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FE07FF07FFFFFFFFFE03FC03FF9FFC1FFC01FC01FF0FF80FF001F001FE07F007
      F000F001FC07E003F000F801FC0FE007E001F803F81FC007C003D007F03FE007
      8007B00FE17FF01F000F800FFA7FF0FF800FE21FFFFFF9FFE31FFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object imgHealer: TImageList
    Left = 4
    Top = 4
    Bitmap = {
      494C01010A004402040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000109000007640000075E0000075E0000075E000004
      350000022200E7D12000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF0001042600FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000585000005BB00282B35000005BB0000069B0000058500E1B4
      130039393900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00002A56000013280000132800001B33001F20
      2C001447B90000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000109000005BB00C5CBDB00C5CBDB00939DB6002C2C3100031298000008
      96000008960000054400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00002D7100002864002C2C31004B4B
      4B00001D3C0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00D4D4D4000000
      0000E6E6E6000005BB00282B3500282B3500282B35002C2C3000505055000004
      AA000004AA0000067300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000916000027610000418600004889002C2C31003D3D4200002C
      5B00001E4B00001D3C00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF001C1C1C000005BA000002F0007761F2000006AE00020F96000004CE000004
      CE000004AA000006730000228300FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000A0A0A00003A7800003D7E003B73A80000448000000B930000296500002D
      5E00001C45000008150000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00D4D4D4000000
      0000C8C8C8000003DE005546F000D4D4D4002C2C30003B3B3B000002D8000005
      D5000001130007091B000091F300FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000B1B000022550000235700001E4B00002C6F001447B900205890000024
      59000021530000163700003A9F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF001F27
      5500000540000003C400D4D4D400FFFFFF00C8C8C8000005D5000005D5000000
      00000061C5000D010F0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF003F3F
      3F0000122D000056930000436F0030618A002C2C3000393A3F00003065000010
      290000349A000A3E8F0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000001B7A001A38
      9700000000000332C10000001C00E6E6E6003D3D3D000001FA000001FA000011
      6D000004CE000006AB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000003F3F
      3F00000D200001042600005998002C2C300032323700FFFFFF00FFFFFF000034
      9A001B1B1B00000B1C00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000F6A0024242400BED7
      44000C0C1C0038B4FC004B9CEC00373737000002DD007761F2007761F2000028
      8B000002F20000010900FFFFFF00FFFFFF00FFFFFF0000349A00292929000000
      0000CC851A00000000001F202B00E9F31D00004B8000001C460000193F00003A
      9F0000071100C2C2C200FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000075D80024242400000000002247
      CF003E4FA0001F284B000000000000010D00020F93000006AB00000000000000
      00000006AB00FFFFFF00FFFFFF00FFFFFF000000000025262600232323007072
      8000797D7D00010538002323230000245900000D1C00000A1900001028000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000061C5000000000041A7
      FB001149C900000000000000000000000000001A7700001B7A000076DA000001
      0900FFFFFF00FFFFFF00FFFFFF00FFFFFF000075D80000349A00000000001363
      DF00000E950044433800000000002528320000000000222222000041A6000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00084A
      D00000165A00ADC0F000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000049BE
      FF001751C6000000000018000000000000000091F30038B4FC0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0018000000939DB60018000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00180000001F28A700C5CBDB0018000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF001800000018000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003020000060400000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000125C0000125C0000125C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001302020025080800230707001302020000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000506060018191A00151616000506060000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000106E001900B4001207A8000010
      5F00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000001DC6001600B400000C7E00000A8F00000C7E000012
      5C00000000000000000000000000000000000000000000000000000000000000
      0000230809008D5C2F0058201C00622A1F004714160043121300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000016171A007D888E004950560053595E00383E420034373900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001312AC001A16B80000107E001701
      AD00130E01000000000000000000000000000000000000000000000000000000
      0000000000000011AB004200EE001000E7000301E400000A9400000A8F000012
      5C00000000000000000000000000000000000000000000000000000000001603
      0300BB913F0067302100703E2600652F2100714026004E161800411213000000
      0000000000000000000000000000000000000000000000000000000000000909
      0900AAB8C000585F6400616C7200555D6400626E74003F43480032373A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000020500000000001715AF00291EC2001A16B800030A
      76000A0803000000000000000000000000000000000000000000000000000000
      00001C1118000C04BA001100E4000F01E5000506B5000105BA00000A94000012
      5C0000000000000000000000000000000000000000000000000004060700E5BF
      4E0084512B007945270084522B00B0693A0085522C006B372300461315001603
      030000000000000000000000000000000000000000000000000005060600D3E3
      ED00757D84006A7277008B969E0079818800767E86005C656A00383B41000808
      0800000000000000000000000000000000000000000000000000000000000000
      000000000000000000000002050000000000000000001915B5001916B2000311
      5A00000000000000000000000000000000000000000000000000000000002F2F
      2F002D2A2A000901CF001204AC001100AD001200D6000804BC001600C4000012
      5C00201E1E00000000000000000000000000000000000000000013020200AE7F
      3A0086532C00986131008A572E0096663100824E2A008F5C2F00673222001603
      0300000000000000000000000000000000000000000000000000050606009DA7
      AF00777F86005C6267001D1F20001D1F200097A0A9007F878F00586166000909
      0900000000000000000000000000000000000000000000000000000000000000
      0000000000001800000000071800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009392
      9200000000006000E5000F009C002100B0002300B7000800F500000D7F00181A
      1F005B5B5C0000000000000000000000000000000000000000001A040400A273
      3700824D2A000C080400060402000503020005030200AA683800764126001001
      01000000000000000000000000000000000000000000000000000C0C0C00929C
      A6006F787D0060666D00585E6200222527007E868D00747C8200676E75000202
      0200000000000000000000000000000000000000000000000000000000000000
      000018000000000D1700ADAFB20018000000231E290000071800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000090A0700C8CAD60058627A0008070B00070636001700C20000125C008F8F
      9000181A1F0000000000000000000000000000000000000000001A040400B485
      3B008A572D0086562C0097673200CC8A43008B582E00905C2E0085532C001803
      03000000000000000000000000000000000000000000000000000B0B0B00A3AC
      B2007A8389007C868C0050565A006B7479007B848B007D858A00757F85000A0A
      0A00000000000000000000000000000000000000000000000000000000001800
      000002294800528DC500000A1A0000000000477DAF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000C0B2800105CDB000025B100A9A49A00090F1500000B7E00000000000000
      000000000000000000000000000000000000000000000000000016030300E6BF
      4E00834F2C008E5C2F00855B2C0083532B0084512B00AF813A004C1516000000
      000000000000000000000000000000000000000000000000000008080800D5E1
      EE00747B85007E878E007E878C00848C9200757D84009EA9B1003D4043000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000180000001800000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004BC3FF002779EE00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000016030300D9B0
      4B007F4B290086512B007A45280079452800B3863C00662F2000000000000000
      000000000000000000000000000000000000000000000000000009090900C8D4
      E4006F777B00767D82006B7278006A727800A2AEB600575E6200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000025080800FFE4
      5400DBB64B00C1984100DAB54A00BB8D3F008249270000000000000000000000
      0000000000000000000000000000000000000000000000000000171818000000
      0000CADAE400B0BFC600C8D9E100AAB3BE007174750000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000834E
      2A009D6C340077422600380E0F00180303000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000737A
      7E008D969E00686F74002A2C2E000A0A0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020400000204000002040000000
      00000020A0004040400000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000043E0000033C0000054D000002
      2100000549000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020400000204000002040000020
      4000002040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000402020000020C0000000FF000020A00000008000C0C0
      2000002040000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000586000005AC000008A000000787000005
      930000054D000006530000000000000000000000000000000000000000000000
      0000000000000000000000000000002060000020600000206000002060000020
      6000002040000020400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003020000060400000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000020C0000000FF000000FF000020C000C0C020000000
      8000002060000020400000000000000000000000000000000000000000000000
      0000000000000000000000078D000004CE000002E8000006B10000069F000008
      7100000457000003390000010900000000000000000000000000000000000000
      0000000000000000000000206000002080000040800000408000002060000020
      6000002040000020400000000000000000000000000000000000000000000000
      000000000000000000000000000000000000001AC6001900B400001991000010
      5F00000000000000000000000000000000000000000000000000000000000000
      00000020A000000080000020C0004020E0008060E00040204000404040000000
      8000000080000000800000000000000000000000000000000000000000000000
      00000091F30000078B000002C7002721F7006956EC000005B700000790000008
      930000049200000475000F0F0F00000000000000000000000000000000000000
      000000A0E00000206000004080004060A0004060A00000408000002060000040
      8000002060000020400000000000000000000000000000000000000000000000
      00000000000000000000000000000018B1007544F800260AD00000107E00000D
      5D00130E01000000000000000000000000000000000000000000000000000000
      000000206000000080000020A0000020C0000020E00040204000406060000000
      FF000020A0000000800000000000000000000000000000000000000000000000
      0000003A9F00000466000001AA000001BF000002D4000006AE00000896000003
      A7000005A5000006730000000000000000000000000000000000000000000000
      00000040A0000020400000206000002060000020600000408000004080004060
      8000002060000020400000000000000000000000000000000000000000000000
      0000000000000000000000020500191B9600472BE5000C00C60000039300000B
      5B000A0803000000000000000000000000000000000000000000000000000000
      0000000000000020C0000020E0004040C0000020E000F0FBFF000020E0000000
      8000000000000020600000A0E000000000000000000000000000000000000000
      0000000000000006B1000002B7004236C7000002DC000006AE000005B2000004
      76001616160000349A000091F300000000000000000000000000000000000000
      0000000000004080A00000608000004060000060800000408000004080000020
      4000000000000040A00000A0E000000000000000000000000000000000000000
      0000000000000000000000020500231ABB006D55DA000101BE00050D8F000412
      5500000000000000000000000000000000000000000000000000000000000000
      00000000000040404000402040004040E0000020A00000000000000080000000
      00000060C0000020600000000000000000000000000000000000000000000000
      00000000000000089D000002AE004237EB00000194000003840000067E000002
      2300005BBF000003350000000000000000000000000000000000000000000000
      0000000000000040800000408000004080000040600000206000002060000000
      00000060C0000020400000000000000000000000000000000000000000000000
      0000000000001800000000071800000B7500362FC10023179E001D2582000000
      0000000000000000000000000000000000000000000000000000002080000000
      0000C08020004080E0000020A000C080000040404000C0C0C0000020A0000000
      000040202000000000000000000000000000000000000000000000349A000000
      00004B4B4B000003320000089F000007900000049F000005A700000981000004
      36001919190000000000000000000000000000000000000000000040A0000000
      0000404040004060600000408000004080000040800000408000002060000020
      4000402020000000000000000000000000000000000000000000000000000000
      000018000000000D1700ADAFB20018000000231E290000071800000000000000
      000000000000000000000000000000000000000000000020A000000000000000
      000040406000404060004080E0004020200000000000002040000020A0000020
      600000000000000000000000000000000000000000000053B800252524000000
      00003B445700474C5B003C3C3C00000451000002240000043800000761002E5B
      A10000000000000000000000000000000000000000000060C000000000000000
      0000404060004040600040404000002040000000000000204000002040004060
      A000000000000000000000000000000000000000000000000000000000001800
      000002294800528DC500000A1A00080B0A00477DAF0000000000000000000000
      0000000000000000000000000000000000000000000000208000002080000040
      E0000060E0008080A000C0802000404040000000800000000000000000000080
      E000000000000000000000000000000000000000000000319600004CB000084A
      D0001153D600878CAF00414347002A2A2A0000349A0021212000232323000071
      D50000000000000000000000000000000000000000000040A0000040C0000040
      E0000060E0008080A00040404000000000000040A00000000000000000000080
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000180000001800000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004080
      E00040A0E0000020600000000000000000000000800000A0E0000080E0000000
      0000000000000000000000000000000000000000000000000000000000002D8B
      F20040A8FC0000165A00000000000A000000000E9500169FF7000088EB000000
      0000000000000000000000000000000000000000000000000000000000004080
      E00040A0E0000020600000000000000000000000800000A0E0000080E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF9FFC1FF87FF87FFF0FF80FF03FF03FFF07F007E01FE01F
      FD07E003C00FC00FFD8FE007C00FC00FF9FFC007C00FC00FF03FE007C00FC00F
      E17FF01FC01FC01FFA7FF0FFC03FC03FFFFFF9FFC07FD07FFFFFFFFFE0FFE0FF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0BFF0FFFFFFFFF
      FE01FE07FF07FFFFFC03FE03FC03FF9FF001F001FC01FF0FF001F001F001FE07
      F000F000F001FC07E001E001F801FC0FE041E001F803F81F80038003D007F03F
      A0078007B00FE07F006F000F800FFA7F801F821FE21FFFFFF7FFF7FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object imgTools: TImageList
    Left = 34
    Top = 4
    Bitmap = {
      494C010107004402040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000094959400524B4A008486840077797B007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007569690068646400474E54007B86920060646D00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      00007F7F7F00BFBFBF0000000000000000000000000000000000000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      00007F7F7F00BFBFBF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C5C1C1006B6A6F0047464700585F6600798896009EA3AA00666666000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7475008080800000000000000000007F7F7F005552
      54009C8E900040404000726D6D00000000000000000000000000000000000000
      000000000000000000007B7475008080800000000000000000007F7F7F005552
      54009C8E900040404000726D6D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000877F7F007B7B7B0052555A006B6F790056616D00A4A9B300393F46000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000077737300675E5D000000000080808000675C5800897D
      7E005B4E52003E383F00635D6000000000000000000000000000000000000000
      0000000000000000000077737300675E5D000000000080808000675C5800897D
      7E005B4E52003E383F00635D6000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008B7F7F009E9B9E006A6A6A00969BA20056646C00B2B6BF0056595C000000
      0000000000000000000000000000000000000000000000000000BFBFBF00786E
      6F0080808000000000004040400098898800808080000000000080808000B2A6
      B400000000009593A10057576000565660000000000000000000BFBFBF00786E
      6F0080808000000000004040400098898800808080000000000080808000B2A6
      B400000000009593A30057576000565660000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000857F7F006B6163004941410083858900333539004E50540027282B000000
      00000000000000000000000000000000000000000000BFBFBF00A49496008D81
      8600BFBFBF0080808000B8AAAB00332F30004040400005043100555560003939
      49006F6F7E006C6C7100BFBFBF008080800000000000BFBFBF00A39396008C80
      8600BFBFBF0080808000B8ADAA00332F3000404040002404320058555F003C3A
      4800726E7E006C6C7100BFBFBF00808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000877F7F0079787B002B2A2B0000000000000000000000
      000000000000000000000000000000000000BFBFBF009687860064595B005552
      540000000000404040002E2D520072728B00080551000B0A4300282839001A19
      310003022C00404045000000000000000000BFBFBF009586860063585B005552
      54000000000040404000462D510083728B003B055100320A4300342937002A19
      310020032C004440450000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000094858300395A75000615210000000000000000000000
      000000000000000000000000000000000000BFBFBF007F7F7F00808080006B61
      72002B283200181643000704430009062700090843000B0764000F0A8100100B
      8E000E09770043415B000000000000000000BFBFBF007F7F7F00808080007462
      6F003128320036164300310443001E06270031084200490764005E0A83006A0C
      91005709780054425B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000090828100375E7D000816230000000000000000000000
      000000000000000000000000000000000000716D6F007F7F7F0003021E000604
      3C0019173A000F0B6500130DA200110CA500160FB900150FB800150FBA001810
      C200160FBC00808080000000000000000000716D6F007F7F7F0016021F002C04
      3E002F173B00470A6100730C9F00770DA400880FBA00880FBB00890FBC008F10
      C3008A0FBD008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008B7F7F004167870006141F0000000000000000000000
      0000000000000000000000000000000000006C66680080717A0009081D000E09
      6E001B12CD001D13CE001810C3004943D3004E48D9005049D6001810C3001810
      C3000E0976000000000000000000000000006C6668008071740016081C005208
      6C009110C1008D10C1008E10C200A843D300AC48D800AD49D6008D10C1008E10
      C200560976000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008B7F7F003F66850006131D0000000000000000000000
      0000000000000000000000000000000000007571710039343800110C9A001A12
      D3001810C2001810C2001810CA001810CA004942D100170FC900130DAD000302
      280087878A00000000000000000000000000757171003D3438007B0D9D009E12
      D1008B0FC0008C0FC0009511CC009611CF00A742D1009D11CF00860EB4001C02
      2800878789000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008D807F00375F81000A141B0000000000000000000000
      00000000000000000000000000000000000000000000818193004537EB003023
      D2001911D0001810CE001E14DC001C12DA00130DA4000B076700555459006D69
      770015131A00BFBFBF000000000000000000000000008E819300C940EA00A82A
      D600A514D7009510CC00AD15DE00AB15DC007E0FA8004A076600585459006D69
      770016121A00BFBFBF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008B7F7F002D4F6F000C13190000000000000000000000
      00000000000000000000000000000000000000000000000000004E4997001811
      980017109800140E90008382A80082819800C0C0C700BFBFBF008B8188009A8E
      8F0079717600564C5800808080000000000000000000000000007F4796007810
      97007B109800750E9000A083AC0092819900C5C0C700BFBFBF008B8188009A8E
      8F0079717600544A560080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008B7F7F00242F37000C0D0C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BFBFBF002B25
      2700C3BABA00615C5F0036323D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BFBFBF002B25
      2700C3BABA00615C5F0036323D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004E5056001A222D00122433000A151E000E1A2500BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFBF
      BF0040404000676164009A96A100010101000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFBF
      BF0040404000676164009A96A100010101000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000646169003D4C58002B3D5000273A4C00273A4C00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF007F7F7F00808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF007F7F7F00808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000241010001A10
      1000130F0F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      000000000000000000000000000000000000000000007064660061626B00727D
      860047565F007063650000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000877F8000808080000000000000000000000000008080
      8000C5B0B500000000008080800000000000000000000000000000000000BFBF
      BF001E4856002E616F001E3E4400265C70001E4856001E3E4400404A52007F7F
      7F00000000000000000000000000000000009A8B8B00535257005B636D009BA6
      B100A7B1B900818D96007D707200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      000000000000BFBFBF0000000000000000000000000000000000000000000000
      0000000000000000000071696900736C6C0000000000BFBFBF00675C5800675B
      5D00544D4D0040404000655C5E00000000000000000000000000BFBFBF001E48
      5600337E94003995B0002A6C7C0048AAC0003496B6002A7B97002D677800265C
      7000484F51000000000000000000000000009080800056565A00454D57005F6B
      7600747E8800B6BDC300757F86009D8F8F000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000464A
      4F00233650002539550021334C0022334D002031490030496D00484C53000000
      0000808080001E2E450000000000000000000000000000000000000000008887
      8700BFBFBF00000000008080800082747300BFBFBF00BFBFBF00404040009B8F
      9100BFB6BB00968E990078767F008080800000000000000000004F5F62002A76
      8E00245F7200071923001E3E44003995B0003995B0001E5268003995B000337E
      94002E616F008080800000000000000000009080800066686F003A3C41005D67
      6E008E98A0005E677000534E5100EDEBEB000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000263B
      580020324A0034507600203149001D2D44002B4262001E2D43002F486B001D2C
      42001A283C004D545F0000000000000000000000000000000000807B7B00AB9A
      9D0080808000BFBFBF006E6666007F747500808080007F7F7F006A6A70006B68
      7C00B2B2BB006A6A79004E4E510055555F0000000000000000002A6C7C00337E
      9400001E3600BFBFBF0000000000BFBFBF004F6974004798B100418195003995
      B0002557670010232B000000000000000000EAE7E7006A6063004D4F55003C44
      4B005E656D00474F560076656700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000172435002031
      4A002D446500253853002D44660023354F00304A6E002C436300253955000D14
      1E002A405F008080800000000000000000000000000075707000907E8200A7A1
      A40000000000808080006E6F6A0035302E001F1007004D271200504B48003833
      310049403C0080808000000000000000000000000000000000002A6C7C002A80
      A0000014240000000000000000000000000000000000BFBFBF00478E9F001E52
      6800327D91001E3E4400000000000000000000000000E6E3E300686063005058
      5F00493F43005D5053005F5E62008F8485000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F3048002437
      5200111A280022344E000F182400243752002539550016223200131D2C00121C
      2A002E4568008080800000000000000000008080800062565700777373004748
      42007F7F7F002111080042210F005E504A00311A0E0023140C002D1A10003C20
      11002F180B0010080300000000000000000000000000000000002455600048AA
      C0002455600000000000000000000000000000000000000000004F6974002A80
      A0002A6C7C001E3E440000000000000000000000000000000000E3DFDF007063
      6500E3DFDF00E3DFDF007D7374008C8F93008E86860000000000000000000000
      00000000000000000000000000000000000000000000000000001E2E45001C2C
      410037547D000D131D007F7F7F00BFBFBF00484C52001C2B4100141E2D000A10
      18001D2D4300808080000000000000000000BFBFBF0000000000404040003028
      21004D453F002C20190040200F004B261200783D1C008F4922009A4F2500A053
      26009E5125008A85820000000000000000000000000000000000808080003995
      B0003995B000808A920000000000000000000000000000000000808080001E3E
      440046727F001E3E440000000000000000000000000000000000000000000000
      00000000000000000000DFDBDB006F6D6F00344D6300948F9300000000000000
      0000000000000000000000000000000000000000000000000000152131001826
      38002F476A002E466900152131007F7F7F000000000006090F000E1621000509
      0D00172436008080800000000000000000006760620024262200190C06003C1E
      0E005E2F16008F492300A6562800A1532700B3785700A6592E00A0532700A354
      27008A462100BFBFBF0000000000000000000000000000000000BFBFBF00398B
      9E0048AAC0000F334600BFBFBF0000000000000000000000000080808000082C
      4400386F7D001E3E440000000000000000000000000000000000000000000000
      0000000000000000000000000000DCD7D70046597600355880009C9598000000
      0000000000000000000000000000000000000000000000000000808080003652
      7B002D4567002B4262002E46690024385300121D2B00121B2900131D2C00080C
      13000F1823008080800000000000000000006A6465009086820044241500A259
      2B00A65629009E512600A5552800B8795400B87A5500B6775400A7552800743B
      1C00665349000000000000000000000000000000000000000000000000004F5F
      620048AAC000478E9F001E4856007F8991000000000000000000808080001738
      45002E839F001E3E440000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D8D3D30040526F00304A6B00A39A
      9C0000000000000000000000000000000000000000000000000000000000494E
      56003A5985001B2A3F00283D5C00324D7200203149001E2D43002A3F5F001A28
      3C000E141F00808080000000000000000000BFBFBF0048444100C6713800AC58
      2A00A8562900A3532700AF5A2B00AF5A2A00AD5A2B00974C24003D1E0E00211E
      2900504F5500000000000000000000000000000000000000000000000000BFBF
      BF004177830064B0C3003995B0002D677800001424000F212600000000003381
      9400255C7000808A920000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D5CFCF0039465F00293B
      5500ABA7AB0000000000F1EFEF00000000000000000000000000000000000000
      0000494F5600304A6E0034507700273C5900223550001F30480017233500141F
      2E004F58640000000000000000000000000000000000C7C3C100AD774E00C97E
      4E00C36E3600C57037008E4E25007E4924007E614F0052494400ADA4A800766F
      7500342E3500605C6100BFBFBF00000000000000000000000000000000000000
      0000BFBFBF004177830048AAC0003995B0003C8B9D000F384F00081E2C002153
      64001E526800BFBFBF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D1CBCB002C37
      4A001C273900796B6D004B474F00000000000000000000000000000000000000
      000000000000BFBFBF007F7F7F00808081007F7F7F007F7F7F007F7F7F00C5C6
      C500000000000000000000000000000000000000000000000000CBC5C200988B
      85009B8D8600958A840000000000000000000000000000000000767273007069
      6800A6A0A300554B550059585E00000000000000000000000000000000000000
      000000000000BFBFBF004F5F6200398B9E005CA4B70052ADC700081E2C001E3E
      4400BFC9D1000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C7BF
      BF00130E160024385000726B7700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006B65
      67006D676600A7A1A40049424F00808080000000000000000000000000000000
      0000000000000000000000000000BFBFBF004F5F6200265866007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009383
      83002A405A005F5A620000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF0040404000706D6F00010101000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00F83FFFFFFFFF0000F81FFDF3FDF30000
      F01FFCC1FCC10000F01FFC81FC810000F01FC448C4480000F01F800080000000
      FC7F080308030000FC7F000300030000FC7F000300030000FC7F000700070000
      FC7F000700070000FC7F800380030000FC7FC001C0010000FC7FFFC1FFC10000
      F81FFFE0FFE00000F81FFFF8FFF80000FFFFFFFFC7FFFFFFFFFFF8FF83FFFFFF
      FCE1E00F01FFF03BFC81C00700FFE013E400C00300FFC003C000C20301FFC003
      8803C78380FFC0030003C7C3C07FC0034003C3C3FC3FC0830003C1C3FE1FC003
      0007E0C3FF0FE0030007E003FF85F0078001F003FFC1F80FC3C1F807FFE1FFFF
      FFE0FE1FFFE3FFFFFFF0FFFFFFF7FFFF00000000000000000000000000000000
      000000000000}
  end
  object PopTray: TPopupMenu
    Left = 92
    Top = 50
    object ShowTibia1: TMenuItem
      Caption = 'Show Tibia'
      OnClick = ShowTibia1Click
    end
    object HideTibia1: TMenuItem
      Caption = 'Hide Tibia'
      OnClick = HideTibia1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object ShowBBot1: TMenuItem
      Caption = 'Show BBot'
      OnClick = ShowBBot1Click
    end
    object HideBBot1: TMenuItem
      Caption = 'Hide BBot'
      OnClick = HideBBot1Click
    end
  end
  object tmrEngine: TTimer
    Interval = 450
    OnTimer = tmrEngineTimer
    Left = 48
    Top = 96
  end
  object sMacroCP: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUseBuiltInTimer, scoCompleteWithTab, scoCompleteWithEnter]
    Width = 600
    EndOfTokenChr = '() =<>'
    TriggerChars = '.=><:!'
    Title = 'Macro Functions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    ItemHeight = 32
    OnPaintItem = sMacroCPPaintItem
    OnShow = sMacroCPShow
    ShortCut = 16416
    Editor = sMacro
    TimerInterval = 200
    Left = 128
    Top = 70
  end
  object tmrDelete: TTimer
    Enabled = False
    OnTimer = tmrDeleteTimer
    Left = 96
    Top = 112
  end
end
