unit uListAll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.DbxSqlite, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.FMTBcd, Vcl.ExtCtrls, Vcl.DBCtrls, Datasnap.DBClient, SimpleDS,
  Vcl.ToolWin;

const
  COL_FAMILY = 0;
  COL_NAME = 1;
  COL_PATRONYMIC = 2;
  COL_QUALIF = 3;
  COL_EXPERIENCE = 4;

type
  TQualification = (qCourse { Любые курсы\ПТУ } , qTechnician { Техник } , qBachelor { Бакалавр } ,
    qSpecialist { Специалист } , qMaster { Магистр } );

type
  TListAllFrame = class(TFrame)
    SQLConnection: TSQLConnection;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ListView: TListView;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    SQLQuery: TSQLQuery;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure ResizeColumns;
    procedure LoadMainTable;
    function QualifToStr(AValue: TQualification): String;
  end;

implementation

{$R *.dfm}
{ TListAllFrame }

constructor TListAllFrame.Create(AOwner: TComponent);
var
  DBName: String;
begin
  inherited;
  DBName := ExtractFilePath(Application.ExeName) + 'main.db';
  SQLConnection.Params.Add('Database=' + DBName);
  try
    SQLConnection.Connected := true;
    SQLConnection.ExecuteDirect('PRAGMA foreign_keys=ON;');
  except
    on E: EDatabaseError do
      ShowMessage('Ошибка открытия БД: ' + E.Message);
  end;
end;

procedure TListAllFrame.FrameResize(Sender: TObject);
begin
  ResizeColumns;
end;

procedure TListAllFrame.LoadMainTable;
// Загрузка основной таблицы
const
  DB_FAMILY = 0;
  DB_NAME = 1;
  DB_PATRONYMIC = 2;
  DB_QUALIF = 3;
  DB_EXPERIENCE = 4;
var
  Item: TListItem;
begin
  SQLQuery.SQL.Text := 'SELECT';
  SQLQuery.SQL.Add('persons.family,');
  SQLQuery.SQL.Add('persons.name,');
  SQLQuery.SQL.Add('persons.patronymic,');
  SQLQuery.SQL.Add('MAX(educations.qualification)');
  SQLQuery.SQL.Add('SUMM(educations.leavedate - educations.enterdate)');
  SQLQuery.SQL.Add('FROM persons JOIN educations USING(id)');
  SQLQuery.Open;
  while not SQLQuery.Eof do
  begin
    Item := ListView.Items.Add;
    Item.Caption := SQLQuery.Fields[DB_FAMILY].AsString;
    Item.SubItems.Add(SQLQuery.Fields[DB_NAME].AsString);
    Item.SubItems.Add(SQLQuery.Fields[DB_PATRONYMIC].AsString);
    Item.SubItems.Add(QualifToStr(TQualification(SQLQuery.Fields[DB_QUALIF].AsInteger)));
    Item.SubItems.Add(SQLQuery.Fields[DB_EXPERIENCE].AsString);
    SQLQuery.Next;
  end;
  SQLQuery.Close;
end;

function TListAllFrame.QualifToStr(AValue: TQualification): String;
// Квалификация в строку
begin
  case AValue of
    qCourse:
      Result := 'Прошёл курс';
    qTechnician:
      Result := 'Техник';
    qBachelor:
      Result := 'Бакалавр';
    qSpecialist:
      Result := 'Специалист';
    qMaster:
      Result := 'Магистр';
  else
    Result := 'Иное';
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
