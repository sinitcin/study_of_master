unit uDataBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, Data.DbxSqlite, Data.SqlExpr, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Data.FMTBcd, Vcl.ExtCtrls, Vcl.DBCtrls,
  Datasnap.DBClient, SimpleDS, Vcl.ToolWin, System.ImageList, Vcl.ImgList,
  DateUtils, AnsiStrings;

const
  INVALID_VALUE = -1;

type
  TQualification = (qUnknown { Не известно } , qCourse { Любые курсы\ПТУ } ,
    qTechnician { Техник } , qBachelor { Бакалавр } ,
    qSpecialist { Специалист } , qMaster { Магистр } );

  TPerson = record
    ID: Integer;
    Family: String[255];
    Name: String[255];
    Patronymic: String[255];
    Phone: String[255];
    EMail: String[255];
  end;

  TEducation = record
    ID: Integer;
    Name: String[255];
    Qualification: TQualification;
    EnterDate: TDateTime;
    LeaveDate: TDateTime;
  end;

  PEducation = ^TEducation;

  TSkill = record
    ID: Integer;
    Description: String[255];
  end;

  PSkill = ^TSkill;

  TWork = record
    ID: Integer;
    Name: String[255];
    Position: String[255];
    Achievements: String[255];
    EnterDate: TDateTime;
    LeaveDate: TDateTime;
  end;

  PWork = ^TWork;

  TDataBase = class
  private
    fDataBasePath: String;
    fSQLConnection: TSQLConnection;
    function GetEducation(PersonID, Index: Integer): TEducation;
    function GetPerson(ID: Integer): TPerson;
    function GetSkill(PersonID, Index: Integer): TSkill;
    function GetWork(PersonID, Index: Integer): TWork;
    function GetPersonCount: Integer;
    function GetEducationCount: Integer;
    function GetSkillsCount: Integer;
    function GetWorksCount: Integer;
    function GetPersonQuality(ID: Integer): TQualification;
    function GetPersonExperience(ID: Integer): Double;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetPersonEduCount(PersonID: Integer): Integer;
    function GetPersonWorksCount(PersonID: Integer): Integer;
    function GetPersonSkillsCount(PersonID: Integer): Integer;
    function NewPerson(APerson: TPerson): Integer;
    procedure NewWork(APerson: Integer; Work: TWork);
    procedure NewEducation(APerson: Integer; Education: TEducation);
    procedure NewSkill(APerson: Integer; Skill: TSkill);
    property PersonCount: Integer read GetPersonCount;
    property Persons[ID: Integer]: TPerson read GetPerson;
    property PersonQuality[ID: Integer]: TQualification read GetPersonQuality;
    property PersonExperience[ID: Integer]: Double read GetPersonExperience;
    property EducationCount: Integer read GetEducationCount;
    property Educations[PersonID, Index: Integer]: TEducation read GetEducation;
    property SkillsCount: Integer read GetSkillsCount;
    property Skills[PersonID, Index: Integer]: TSkill read GetSkill;
    property WorksCount: Integer read GetWorksCount;
    property Works[PersonID, Index: Integer]: TWork read GetWork;
    property DataBasePath: String read fDataBasePath;
  end;

var
  DataBase: TDataBase;

function QualifToStr(AValue: TQualification): String;
function StrToQualif(AValue: String): TQualification;
function EscapeStr(AValue: String): String;

implementation

function QualifToStr(AValue: TQualification): String;
// Квалификация в строку
begin
  case AValue of
    qUnknown:
      Result := 'Нет данных';
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

function StrToQualif(AValue: String): TQualification;
// Строка в квалификацию
begin
  case IndexText(AnsiString(AValue), ['Нет данных', 'Прошёл курс', 'Техник',
    'Бакалавр', 'Специалист', 'Магистр', 'Иное']) of
    0:
      Result := qUnknown;
    1:
      Result := qCourse;
    2:
      Result := qTechnician;
    3:
      Result := qBachelor;
    4:
      Result := qSpecialist;
    5:
      Result := qMaster;
  else
    Result := qUnknown;
  end;
end;

function EscapeStr(AValue: String): String;
// Экранирование запросов
var
  ch: Char;
begin
  for ch in AValue do
    if ch = '"' then
      Result := Result + '''''' // Сразу понятно, да? =)
    else
      Result := Result + ch;
end;
{ TDataBase }

constructor TDataBase.Create;
begin
  fSQLConnection := TSQLConnection.Create(nil);
  fSQLConnection.DriverName := 'Sqlite';
  fSQLConnection.LoginPrompt := False;
  fDataBasePath := ExtractFilePath(Application.ExeName) + 'main.db';
  fSQLConnection.Params.Add('Database=' + DataBasePath);
  try
    fSQLConnection.Connected := true;
    fSQLConnection.ExecuteDirect('PRAGMA foreign_keys=ON;');
  except
    on E: EDatabaseError do
      ShowMessage('Ошибка открытия БД: ' + E.Message);
  end;
end;

destructor TDataBase.Destroy;
begin
  if Assigned(fSQLConnection) then
    fSQLConnection.Free;
  inherited;
end;

function TDataBase.GetEducation(PersonID, Index: Integer): TEducation;
var
  SQLQuery: TSQLQuery;
begin
  // Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT * FROM educations WHERE ID = %d LIMIT 1 OFFSET %d;',
      [PersonID, Index]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Name := ShortString(SQLQuery.Fields[1].AsString);
      Result.Qualification := TQualification(SQLQuery.Fields[2].AsInteger);
      Result.EnterDate := TDateTime(SQLQuery.Fields[3].AsFloat);
      Result.LeaveDate := TDateTime(SQLQuery.Fields[4].AsFloat);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetEducationCount: Integer;
begin
  Result := INVALID_VALUE;
end;

function TDataBase.GetPerson(ID: Integer): TPerson;
var
  SQLQuery: TSQLQuery;
begin
  // Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT * FROM persons LIMIT 1 OFFSET %d;', [ID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Family := ShortString(SQLQuery.Fields[1].AsString);
      Result.Name := ShortString(SQLQuery.Fields[2].AsString);
      Result.Patronymic := ShortString(SQLQuery.Fields[3].AsString);
      Result.Phone := ShortString(SQLQuery.Fields[4].AsString);
      Result.EMail := ShortString(SQLQuery.Fields[5].AsString);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetPersonCount: Integer;
var
  SQLQuery: TSQLQuery;
begin
  Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text := 'SELECT COUNT(*) FROM persons;';
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result := SQLQuery.Fields[0].AsInteger;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetPersonEduCount(PersonID: Integer): Integer;
var
  SQLQuery: TSQLQuery;
begin
  Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT COUNT(*) FROM educations WHERE ID = %d;', [PersonID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result := SQLQuery.Fields[0].AsInteger;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetPersonExperience(ID: Integer): Double;
var
  SQLQuery: TSQLQuery;
begin
  Result := 0.0;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT ID, SUM(LeaveDate) - SUM(EnterDate) FROM works WHERE ID = %d;',
      [ID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      if not SQLQuery.Fields[1].IsNull then
        Result := StrToFloatDef(StringReplace(SQLQuery.Fields[1].AsString, '.',
          FormatSettings.DecimalSeparator, [rfReplaceAll]), 0.0);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetPersonQuality(ID: Integer): TQualification;
var
  SQLQuery: TSQLQuery;
begin
  Result := TQualification.qUnknown;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT ID, MAX(Qualification) FROM educations WHERE ID = %d;',
      [ID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      if not SQLQuery.Fields[1].IsNull then
        Result := TQualification(SQLQuery.Fields[1].AsInteger);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetPersonSkillsCount(PersonID: Integer): Integer;
var
  SQLQuery: TSQLQuery;
begin
  Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text := Format('SELECT COUNT(*) FROM skills WHERE ID = %d;',
      [PersonID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result := SQLQuery.Fields[0].AsInteger;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetPersonWorksCount(PersonID: Integer): Integer;

var
  SQLQuery: TSQLQuery;
begin
  Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text := Format('SELECT COUNT(*) FROM works WHERE ID = %d;',
      [PersonID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result := SQLQuery.Fields[0].AsInteger;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetSkill(PersonID, Index: Integer): TSkill;

var
  SQLQuery: TSQLQuery;
begin
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT * FROM skills WHERE ID = %d LIMIT 1 OFFSET %d;',
      [PersonID, Index]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Description := ShortString(SQLQuery.Fields[1].AsString);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetSkillsCount: Integer;
begin
  Result := INVALID_VALUE;
end;

function TDataBase.GetWork(PersonID, Index: Integer): TWork;
var
  SQLQuery: TSQLQuery;
  BufDate: Double;
begin
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text :=
      Format('SELECT * FROM works WHERE ID = %d LIMIT 1 OFFSET %d;',
      [PersonID, Index]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Name := ShortString(SQLQuery.Fields[1].AsString);
      Result.Position := ShortString(SQLQuery.Fields[2].AsString);
      Result.Achievements := ShortString(SQLQuery.Fields[3].AsString);
      BufDate := StrToFloatDef(SQLQuery.Fields[4].AsString, 0.0);
      Result.EnterDate := TDateTime(BufDate);
      BufDate := StrToFloatDef(SQLQuery.Fields[5].AsString, 0.0);
      Result.LeaveDate := TDateTime(BufDate);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetWorksCount: Integer;
begin
  Result := INVALID_VALUE;
end;

procedure TDataBase.NewEducation(APerson: Integer; Education: TEducation);
var
  EnterDate, LeaveDate: String;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yy';
  FormatSettings.DateSeparator := '.';
  FormatSettings.DecimalSeparator := '.';
  EnterDate := FloatToStr(Education.EnterDate);
  LeaveDate := FloatToStr(Education.LeaveDate);
  fSQLConnection.ExecuteDirect
    (Format('INSERT INTO educations (ID, Name, Qualification, EnterDate, LeaveDate) '
    + 'VALUES (%d, "%s", "%d", %s, %s)', [APerson, EscapeStr(String(Education.Name)),
    Integer(Education.Qualification), EnterDate, LeaveDate]));
end;

function TDataBase.NewPerson(APerson: TPerson): Integer;
begin
  Result := PersonCount + 1;
  fSQLConnection.ExecuteDirect
    (Format('INSERT INTO persons (ID, Family, Name, Patronymic, Phone, Email) '
    + 'VALUES (%d, "%s", "%s", "%s", "%s", "%s")', [PersonCount + 1,
    EscapeStr(String(APerson.Family)), EscapeStr(String(APerson.Name)),
    EscapeStr(String(APerson.Patronymic)), EscapeStr(String(APerson.Phone)),
    EscapeStr(String(APerson.EMail))]));
end;

procedure TDataBase.NewSkill(APerson: Integer; Skill: TSkill);
begin
  fSQLConnection.ExecuteDirect
    (Format('INSERT INTO skills (ID, Description) VALUES (%d, "%s")',
    [APerson, EscapeStr(String(Skill.Description))]));
end;

procedure TDataBase.NewWork(APerson: Integer; Work: TWork);
var
  EnterDate, LeaveDate: String;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yy';
  FormatSettings.DateSeparator := '.';
  FormatSettings.DecimalSeparator := '.';
  EnterDate := FloatToStr(Work.EnterDate);
  LeaveDate := FloatToStr(Work.LeaveDate);
  fSQLConnection.ExecuteDirect
    (Format('INSERT INTO works (ID, Name, Position, Achievements, EnterDate, LeaveDate) '
    + 'VALUES (%d, "%s", "%s", "%s", %s, %s)',
    [APerson, EscapeStr(String(Work.Name)), EscapeStr(String(Work.Position)),
    EscapeStr(String(Work.Achievements)), EnterDate, LeaveDate]));
end;

initialization

DataBase := TDataBase.Create;

finalization

if Assigned(DataBase) then
  DataBase.Free;

end.
