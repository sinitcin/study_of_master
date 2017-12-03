object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1079#1102#1084#1077' '#1082#1086#1085#1090#1088#1086#1083#1083#1077#1088
  ClientHeight = 449
  ClientWidth = 863
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 3
  Padding.Top = 3
  Padding.Right = 3
  Padding.Bottom = 3
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LeftPanel: TPanel
    Left = 3
    Top = 3
    Width = 185
    Height = 443
    Margins.Top = 10
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'LeftPanel'
    Color = 3152923
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 28
      Height = 13
      Caption = #1041#1040#1047#1040
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object LabelAll: TLabel
      Left = 13
      Top = 35
      Width = 96
      Height = 15
      Caption = #1042#1089#1077' '#1082#1072#1085#1076#1080#1076#1072#1090#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -13
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
      OnClick = LabelAllClick
      OnMouseMove = OnMenuMouseMove
      OnMouseLeave = OnMenuMouseLeave
    end
    object Label6: TLabel
      Left = 8
      Top = 72
      Width = 43
      Height = 13
      Caption = #1056#1040#1047#1053#1054#1045
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object LabelAbout: TLabel
      Left = 13
      Top = 91
      Width = 91
      Height = 15
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -13
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
      OnClick = LabelAboutClick
      OnMouseMove = OnMenuMouseMove
      OnMouseLeave = OnMenuMouseLeave
    end
  end
  object ScrollBox: TScrollBox
    Left = 188
    Top = 3
    Width = 672
    Height = 443
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 1
  end
end
