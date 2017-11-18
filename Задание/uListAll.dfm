object ListAllFrame: TListAllFrame
  Left = 0
  Top = 0
  Width = 577
  Height = 348
  Align = alClient
  TabOrder = 0
  OnResize = FrameResize
  object Label1: TLabel
    AlignWithMargins = True
    Left = 14
    Top = 14
    Width = 549
    Height = 18
    Margins.Left = 14
    Margins.Top = 14
    Margins.Right = 14
    Margins.Bottom = 6
    Align = alTop
    BiDiMode = bdRightToLeft
    Caption = #1042#1089#1077' '#1082#1072#1085#1076#1080#1076#1072#1090#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 3152923
    Font.Height = -15
    Font.Name = 'Raboto'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
    ExplicitLeft = 448
    ExplicitTop = 3
    ExplicitWidth = 113
  end
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 14
    Top = 38
    Width = 549
    Height = 9
    Margins.Left = 14
    Margins.Top = 0
    Margins.Right = 14
    Margins.Bottom = 14
    Align = alTop
    Shape = bsTopLine
    ExplicitTop = 49
  end
  object Bevel2: TBevel
    AlignWithMargins = True
    Left = 14
    Top = 289
    Width = 549
    Height = 13
    Margins.Left = 14
    Margins.Top = 14
    Margins.Right = 14
    Margins.Bottom = 0
    Align = alBottom
    Shape = bsTopLine
    ExplicitTop = 287
  end
  object ListView: TListView
    AlignWithMargins = True
    Left = 44
    Top = 61
    Width = 519
    Height = 200
    Margins.Left = 44
    Margins.Top = 0
    Margins.Right = 14
    Margins.Bottom = 14
    Align = alClient
    Columns = <
      item
        Caption = #1060#1072#1084#1080#1083#1080#1103
      end
      item
        Caption = #1048#1084#1103
      end
      item
        Caption = #1054#1090#1095#1077#1089#1090#1074#1086
      end
      item
        Caption = #1050#1074#1072#1083#1080#1092#1080#1082#1072#1094#1080#1103
      end
      item
        Caption = #1057#1090#1072#1078
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitHeight = 207
  end
  object ToolBar1: TToolBar
    AlignWithMargins = True
    Left = 14
    Top = 305
    Width = 549
    Height = 29
    Margins.Left = 14
    Margins.Right = 14
    Margins.Bottom = 14
    Align = alBottom
    ButtonHeight = 25
    ButtonWidth = 65
    Caption = 'ToolBar1'
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 0
    end
  end
  object SQLConnection: TSQLConnection
    DriverName = 'Sqlite'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver230.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver230.bpl'
      'FailIfMissing=True'
      'Database=D:\'#1055#1088#1086#1077#1082#1090#1099'\'#1047#1072#1076#1072#1085#1080#1077'\main.db')
    Connected = True
    Left = 496
    Top = 240
  end
  object SQLQuery: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection
    Left = 480
    Top = 184
  end
end
