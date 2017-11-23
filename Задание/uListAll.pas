unit uListAll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.DbxSqlite, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.FMTBcd, Vcl.ExtCtrls, Vcl.DBCtrls, Datasnap.DBClient, SimpleDS,
  Vcl.ToolWin, System.ImageList, Vcl.ImgList, DateUtils, uDataBase;

const
  COL_FAMILY = 0;
  COL_NAME = 1;
  COL_PATRONYMIC = 2;
  COL_QUALIF = 3;
  COL_EXPERIENCE = 4;

type
  TListAllFrame = class(TFrame)
    SQLConnection: TSQLConnection;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ListView: TListView;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    SQLQuery: TSQLQuery;
    ToolButton2: TToolButton;
    ImageList: TImageList;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    ShowOnlyExp: Boolean;
  public
    { Public declarations }
    procedure ResizeColumns;
    procedure LoadMainTable;
  end;

implementation

{$R *.dfm}

procedure TListAllFrame.FrameResize(Sender: TObject);
begin
  ResizeColumns;
end;

procedure TListAllFrame.LoadMainTable;
// Загрузка основной таблицы

  function YearToStr(AValue: Word): String;
  begin
    case AValue of
      0:
        Exit('');
      1:
        Result := ' год';
      2, 3, 4:
        Result := ' года';
    else
      Result := ' лет';
    end;
    Result := IntToStr(AValue) + Result;
  end;

  function MounthToStr(AValue: Word): String;
  begin
    case AValue of
      0:
        Exit('');
      1:
        Result := ' месяц';
      2, 3, 4:
        Result := ' месяца';
    else
      Result := ' месяцев';
    end;
    Result := IntToStr(AValue) + Result;
  end;

var
  Item: TListItem;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
  CurrYear, CurrMonth: Word;
  DateInterval: Double;
  Qualif: TQualification;
  I: Integer;
  Buffer: String;
begin
  for I := 0 to DataBase.PersonCount - 1 do
  begin
    Item := ListView.Items.Add;
    Item.Caption := DataBase.Persons[I].Family;
    Item.SubItems.Add(DataBase.Persons[I].Name);
    Item.SubItems.Add(DataBase.Persons[I].Patronymic);
    Item.SubItems.Add(QualifToStr(DataBase.PersonQuality[DataBase.Persons[I].ID]));
    DateInterval := DataBase.PersonExperience[DataBase.Persons[I].ID];
    DecodeDateTime(Now, CurrYear, CurrMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
    DecodeDateTime(Now - DateInterval, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
    Buffer := Trim(YearToStr(CurrYear - AYear) + ' ' + MounthToStr(CurrMonth - AMonth));
    if Buffer <> '' then
      Item.SubItems.Add(Buffer)
    else
      Item.SubItems.Add('Нет данных');
    Item.Data := Pointer(I);
  end;
end;

procedure TListAllFrame.ResizeColumns;
// Выравнивание колонок

  function GetWidthByPercent(ControlWidth, Percent: Integer): Integer;
  // Получить ширину в пикселях от Percent
  begin
    Result := (ControlWidth div 100) * Percent;
  end;

begin
  ListView.Column[COL_FAMILY].Width := GetWidthByPercent(ListView.Width, 15);
  ListView.Column[COL_NAME].Width := GetWidthByPercent(ListView.Width, 15);
  ListView.Column[COL_PATRONYMIC].Width := GetWidthByPercent(ListView.Width, 15);
  ListView.Column[COL_QUALIF].Width := GetWidthByPercent(ListView.Width, 20);
  ListView.Column[COL_EXPERIENCE].Width := GetWidthByPercent(ListView.Width, 25);
end;

end.
