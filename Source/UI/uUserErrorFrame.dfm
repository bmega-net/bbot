object UserErrorFrame: TUserErrorFrame
  Left = 0
  Top = 0
  Width = 617
  Height = 535
  Color = 16707048
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 28
    Height = 13
    Caption = 'Error'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object RecommendedActionsLabel: TLabel
    Left = 244
    Top = 295
    Width = 129
    Height = 13
    Caption = 'Recommended actions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object editCavebot: TLabel
    Left = 268
    Top = 312
    Width = 80
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Go to Cavebot'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = editCavebotClick
    OnMouseEnter = LinkEnter
    OnMouseLeave = LinkLeave
  end
  object editAdvancedAttack: TLabel
    Left = 243
    Top = 329
    Width = 130
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Go to Advanced Attack'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = editAdvancedAttackClick
    OnMouseEnter = LinkEnter
    OnMouseLeave = LinkLeave
  end
  object editReconnectManager: TLabel
    Left = 235
    Top = 346
    Width = 146
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Go to Reconnect Manager'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = editReconnectManagerClick
    OnMouseEnter = LinkEnter
    OnMouseLeave = LinkLeave
  end
  object editMacros: TLabel
    Left = 271
    Top = 363
    Width = 74
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Go to Macros'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = editMacrosClick
    OnMouseEnter = LinkEnter
    OnMouseLeave = LinkLeave
  end
  object editEnchanter: TLabel
    Left = 263
    Top = 380
    Width = 90
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Go to Enchanter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = editEnchanterClick
    OnMouseEnter = LinkEnter
    OnMouseLeave = LinkLeave
  end
  object pauseBot: TLabel
    Left = 280
    Top = 397
    Width = 56
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Pause bot'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Pitch = fpFixed
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = pauseBotClick
    OnMouseEnter = LinkEnter
    OnMouseLeave = LinkLeave
  end
  object Error: TMemo
    Left = 7
    Top = 24
    Width = 602
    Height = 265
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Error')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
end
