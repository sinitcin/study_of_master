unit uListAll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.DbxSqlite, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.FMTBcd, Vcl.ExtCtrls, Vcl.DBCtrls, Datasnap.DBClient, SimpleDS, AnsiStrings,
  Vcl.ToolWin, System.ImageList, Vcl.ImgList, DateUtils, uDataBase, uPreview,
  Vcl.Menus, Generics.Collections;

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
    ListView: TListView;
    SQLQuery: TSQLQuery;
    ImageList: TImageList;
    Bevel2: TBevel;
    ComboBox: TComboBox;
    Label2: TLabel;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    R1: TMenuItem;
    procedure FrameResize(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    ShowOnlyExp: Boolean;
  public
    { Public declarations }
    procedure ResizeColumns;
    procedure LoadMainTable;
    procedure ReFilterByQualif(Qualification: TQualification; Symbol: Char);
    procedure ReFilterByExp(YearOfExperience: Integer; Symbol: Char);
  end;

implementation

{$R *.dfm}

procedure TListAllFrame.ReFilterByExp(YearOfExperience: Integer; Symbol: Char);
// Фильтрация по стажу
var
  I: Integer;
  DateInterval: Double;
  Item: TListItem;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
  CurrYear, CurrMonth: Word;
  Qualif: TQualification;
begin
  for I := ListView.Items.Count - 1 downto 0 do
  begin
    DateInterval := DataBase.PersonExperience[DataBase.Persons[Integer(ListView.Items[I].Data)].ID];
    DecodeDateTime(Now, CurrYear, CurrMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
    DecodeDateTime(Now - DateInterval, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
    case Symbol of
      '>':
        if (CurrYear - AYear) < YearOfExperience then
          ListView.Items[I].Free;
      '=':
        if (CurrYear - AYear) <> YearOfExperience then
          ListView.Items[I].Free;
      '<':
        if (CurrYear - AYear) > YearOfExperience then
          ListView.Items[I].Free;
    end;
  end;
end;

procedure TListAllFrame.ReFilterByQualif(Qualification: TQualification; Symbol: Char);
// Фильтрация по квалификации
var
  I: Integer;
begin
  for I := ListView.Items.Count - 1 downto 0 do
    case Symbol of
      '>':
        if StrToQualif(ListView.Items[I].SubItems[COL_QUALIF - 1]) < Qualification then
          ListView.Items[I].Free;
      '=':
        if StrToQualif(ListView.Items[I].SubItems[COL_QUALIF - 1]) <> Qualification then
          ListView.Items[I].Free;
      '<':
        if StrToQualif(ListView.Items[I].SubItems[COL_QUALIF - 1]) > Qualification then
          ListView.Items[I].Free;
    end;
end;

procedure TListAllFrame.ComboBoxChange(Sender: TObject);
const
  KEYWORDS: array of AnsiString = ['<', '=', '>'];
var
  TokenList: TQueue<String>;
  ch: Char;
  Token, PrevToken: String;
  I: Integer;

  function TestPrevNextToken: Boolean;
  begin
    Result := (PrevToken <> '') and (I < TokenList.Count);
    // and not CharInSet(PrevToken[1], KEYWORDS) and not CharInSet(PrevToken[1], KEYWORDS)
  end;

  function DoQualification(): Boolean;
  // Фильтр по квалификации
  var
    Symbol: Char;
  begin
    if TokenList.Count = 0 then
      Exit(False);
    Result := true;
    Token := TokenList.Dequeue();
    case IndexText(Token, KEYWORDS) of
      0: // <
        Symbol := '<';
      1: // =
        Symbol := '=';
      2: // >
        Symbol := '>';
    else
      Result := False;
    end;

    if Result then
    begin
      if TokenList.Count = 0 then
        Exit(False);
      Token := TokenList.Dequeue();
      if IndexText(Token, ['Нет данных', 'Прошёл курс', 'Техник', 'Бакалавр', 'Специалист',
        'Магистр', 'Иное']) = INVALID_VALUE then
        Exit(False);

      ReFilterByQualif(StrToQualif(Token), Symbol);
    end;
  end;

  function DoExperience(): Boolean;
  // Фильтр по стажу
  var
    Symbol: Char;
    Years: Integer;
  begin
    if TokenList.Count = 0 then
      Exit(False);
    Result := true;
    Token := TokenList.Dequeue();
    case IndexText(Token, KEYWORDS) of
      0: // <
        Symbol := '<';
      1: // =
        Symbol := '=';
      2: // >
        Symbol := '>';
    else
      Result := False;
    end;

    if Result then
    begin
      if TokenList.Count = 0 then
        Exit(False);
      Token := TokenList.Dequeue();
      if TryStrToInt(Token, Years) then
        ReFilterByExp(Years, Symbol);
    end;
  end;

begin
  LoadMainTable();
  TokenList := TQueue<String>.Create;
  try
    // Надо разбить текст на токены
    Token := '';
    for ch in AnsiLowerCase(ComboBox.Text) do
      if CharInSet(ch, [' ', #9]) then
      begin
        TokenList.Enqueue(Token);
        Token := '';
      end
      else
        Token := Token + ch;
    if Token <> '' then
      TokenList.Enqueue(Token);
    if TokenList.Count = 0 then
      Exit;

    // Окей, сразу разберём синтаксис и сделаем трансляцию
    I := 0;
    while I < TokenList.Count do
    begin
      Token := TokenList.Dequeue();
      case IndexText(Token, ['квалификация', 'стаж', '&']) of
        0: // Квалификация
          DoQualification();
        1: // Стаж
          DoExperience();
        2: // &
          begin
            if TokenList.Count = 0 then
              Exit;
          end;
      else
        Exit;
      end;
      inc(I);
    end;
  finally
    TokenList.Free;
  end;
end;

procedure TListAllFrame.FrameResize(Sender: TObject);
begin
  ResizeColumns;
end;

procedure TListAllFrame.ListViewDblClick(Sender: TObject);
// Генерируем страницу
const
  PREVIEW_FILE = 'index.html';
var
  PersonIndex: Integer;
  myFile: TextFile;
  path: String;
  I: Integer;
begin
  if not Assigned(ListView.Selected) then
    Exit;
  PersonIndex := Integer(ListView.Selected.Data);
  path := ExtractFilePath(Application.ExeName) + PREVIEW_FILE;
  // Создание страницы
  AssignFile(myFile, path);
  ReWrite(myFile);
  WriteLn(myFile,
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">');

  WriteLn(myFile, '<html><head>');

  WriteLn(myFile, '<meta http-equiv="content-type "content="text/html; charset=utf-8"/>');

  WriteLn(myFile, '<style type="text/css" media="screen">@import url(screen.css);</style>');

  WriteLn(myFile, '<link rel="stylesheet" type="text/css" media="print" href="print.css" />');

  WriteLn(myFile, '<script type="text/javascript" src="main.js" charset="UTF-8"></script>');

  WriteLn(myFile, '</head>');

  WriteLn(myFile, Format('<body><h1>%s %s</h1>', [DataBase.Persons[PersonIndex].Name,
    DataBase.Persons[PersonIndex].Family]));

  WriteLn(myFile, Format('<p id="bio_left">%s<br/><a href="mailto:%s">%s</a></p>',
    [DataBase.Persons[PersonIndex].Phone, DataBase.Persons[PersonIndex].EMail,
    DataBase.Persons[PersonIndex].EMail]));

  WriteLn(myFile, '<h2>ЦЕЛЬ</h2>');

  // Доделать
  WriteLn(myFile, '<p class="data">Найти высокооплачиваемую работу в крупной компании.</p>');

  WriteLn(myFile, '<h2>ОПЫТ РАБОТЫ</h2>');
  for I := 0 to DataBase.GetPersonWorksCount(DataBase.Persons[PersonIndex].ID) - 1 do
  begin
    WriteLn(myFile, Format('<div class="job"><p class="date">%s<BR>%s</p>',
      [DateToStr(DataBase.Works[DataBase.Persons[PersonIndex].ID, I].EnterDate),
      DateToStr(DataBase.Works[DataBase.Persons[PersonIndex].ID, I].LeaveDate)]));

    WriteLn(myFile, '<div class="job_data">');

    WriteLn(myFile, Format('<h3><a href="">%s</a></h3>',
      [DataBase.Works[DataBase.Persons[PersonIndex].ID, I].Name]));

    WriteLn(myFile, Format('<p class="position">%s</p>',
      [DataBase.Works[DataBase.Persons[PersonIndex].ID, I].Position]));

    WriteLn(myFile, Format('<ul><li>%s</li></ul>	&nbsp;',
      [DataBase.Works[DataBase.Persons[PersonIndex].ID, I].Achievements]));
    WriteLn(myFile, '</div></div>');
  end;

  WriteLn(myFile, '<h2>НАВЫКИ, ТЕХНОЛОГИИ И ПРОЕКТЫ</h2><ul>');
  for I := 0 to DataBase.GetPersonSkillsCount(DataBase.Persons[PersonIndex].ID) - 1 do
    WriteLn(myFile, Format('<li>%s</li>', [DataBase.Skills[DataBase.Persons[PersonIndex].ID,
      I].Description]));
  WriteLn(myFile, '</ul>');

  WriteLn(myFile, '<h2>ОБРАЗОВАНИЕ</h2>');
  for I := 0 to DataBase.GetPersonEduCount(DataBase.Persons[PersonIndex].ID) - 1 do
  begin
    WriteLn(myFile, Format('<div class="job"><p class="date">%s<BR>%s</p>',
      [DateToStr(DataBase.Educations[DataBase.Persons[PersonIndex].ID, I].EnterDate),
      DateToStr(DataBase.Educations[DataBase.Persons[PersonIndex].ID, I].LeaveDate)]));

    WriteLn(myFile, '<div class="job_data">');

    WriteLn(myFile, Format('<h3><a href="">%s</a></h3>',
      [DataBase.Educations[DataBase.Persons[PersonIndex].ID, I].Name]));

    WriteLn(myFile, Format('<p class="position">%s</p>',
      [QualifToStr(DataBase.Educations[DataBase.Persons[PersonIndex].ID, I].Qualification)]));

    WriteLn(myFile, '</div></div>');
  end;

  WriteLn(myFile, '</body>');
  CloseFile(myFile);

  // Отображение
  FormPreview.WebBrowser.Navigate(path);
  FormPreview.ShowModal;
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
  ListView.Items.Clear;
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
