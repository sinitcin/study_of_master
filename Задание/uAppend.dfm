object AppendForm: TAppendForm
  Left = 0
  Top = 0
  Caption = 'AppendForm'
  ClientHeight = 299
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 18
    Top = 187
    Width = 71
    Height = 13
    Caption = #1054#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077':'
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 584
    Height = 299
    VertScrollBar.Position = 423
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 14
      Top = -409
      Width = 535
      Height = 18
      Margins.Left = 14
      Margins.Top = 14
      Margins.Right = 14
      Margins.Bottom = 6
      Align = alTop
      BiDiMode = bdRightToLeft
      Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1088#1077#1079#1102#1084#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3152923
      Font.Height = -15
      Font.Name = 'Raboto'
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
      StyleElements = [seClient, seBorder]
      ExplicitLeft = 340
      ExplicitTop = -68
      ExplicitWidth = 209
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 14
      Top = -385
      Width = 535
      Height = 9
      Margins.Left = 14
      Margins.Top = 0
      Margins.Right = 14
      Margins.Bottom = 14
      Align = alTop
      Shape = bsTopLine
      ExplicitTop = 49
      ExplicitWidth = 549
    end
    object Label3: TLabel
      Left = 16
      Top = -252
      Width = 72
      Height = 13
      Caption = #1057#1090#1072#1078' '#1088#1072#1073#1086#1090#1099':'
    end
    object Label4: TLabel
      Left = 16
      Top = -82
      Width = 71
      Height = 13
      Caption = #1054#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077':'
    end
    object Label1: TLabel
      Left = 16
      Top = 94
      Width = 115
      Height = 13
      Caption = #1053#1072#1074#1099#1082#1080' \ '#1076#1086#1089#1090#1080#1078#1077#1085#1080#1103':'
    end
    object EditFamily: TLabeledEdit
      Left = 16
      Top = -343
      Width = 121
      Height = 21
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = #1060#1072#1084#1080#1083#1080#1103
      TabOrder = 0
    end
    object EditName: TLabeledEdit
      Left = 143
      Top = -343
      Width = 121
      Height = 21
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103
      TabOrder = 1
    end
    object EditPatronymic: TLabeledEdit
      Left = 270
      Top = -343
      Width = 121
      Height = 21
      EditLabel.Width = 49
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
      TabOrder = 2
    end
    object EditPhone: TLabeledEdit
      Left = 397
      Top = -343
      Width = 121
      Height = 21
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = #1058#1077#1083#1077#1092#1086#1085
      TabOrder = 3
    end
    object EditMail: TLabeledEdit
      Left = 16
      Top = -298
      Width = 121
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = 'EMail'
      TabOrder = 4
    end
    object ListViewExp: TListView
      Left = 16
      Top = -233
      Width = 502
      Height = 93
      Columns = <
        item
          Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
          Width = 80
        end
        item
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          Width = 70
        end
        item
          Caption = #1044#1086#1089#1090#1080#1078#1077#1085#1080#1103
          Width = 100
        end
        item
          Caption = #1044#1072#1090#1072' '#1087#1088#1080#1105#1084#1072
          Width = 90
        end
        item
          Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
          Width = 120
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 5
      ViewStyle = vsReport
    end
    object BtnAddExp: TButton
      Left = 16
      Top = -134
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 6
      OnClick = BtnAddExpClick
    end
    object BtnRmExp: TButton
      Left = 97
      Top = -134
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 7
    end
    object ListViewEdu: TListView
      Left = 16
      Top = -63
      Width = 502
      Height = 93
      Columns = <
        item
          Caption = #1059#1095#1077#1073#1085#1086#1077' '#1079#1072#1074#1077#1076#1077#1085#1080#1077
          Width = 120
        end
        item
          Caption = #1050#1074#1072#1083#1080#1092#1080#1082#1072#1094#1080#1103
          Width = 90
        end
        item
          Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103
          Width = 110
        end
        item
          Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
          Width = 100
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 8
      ViewStyle = vsReport
    end
    object BtnAddEdu: TButton
      Left = 16
      Top = 36
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 9
    end
    object BtnRmEdu: TButton
      Left = 97
      Top = 36
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 10
    end
    object ListViewSkills: TListView
      Left = 16
      Top = 113
      Width = 502
      Height = 93
      Columns = <>
      TabOrder = 11
    end
    object BtnRmSkills: TButton
      Left = 97
      Top = 212
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 12
    end
    object BtnAddSkills: TButton
      Left = 16
      Top = 212
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 13
    end
    object BtnSave: TButton
      Left = 16
      Top = 270
      Width = 533
      Height = 25
      Margins.Bottom = 30
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1088#1077#1079#1102#1084#1077
      TabOrder = 14
      OnClick = BtnSaveClick
    end
  end
  object Button5: TButton
    Left = 18
    Top = 305
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
  end
  object Button6: TButton
    Left = 99
    Top = 305
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 2
  end
end
