unit uDataBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.DbxSqlite, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.FMTBcd, Vcl.ExtCtrls, Vcl.DBCtrls, Datasnap.DBClient, SimpleDS,
  Vcl.ToolWin, System.ImageList, Vcl.ImgList, DateUtils, AnsiStrings;

const
  INVALID_VALUE = -1;

type
  TQualification = (qUnknown { Не известно } , qCourse { Любые курсы\ПТУ } ,
    qTechnician { Техник } , qBachelor { Бакалавр } , qSpecialist { Специалист } ,
    qMaster { Магистр } );

  TPerson = record
    ID: Integer;
    Family: String;
    Name: String;
    Patronymic: String;
    Phone: String;
    EMail: String;
  end;

  TEducation = record
    ID: Integer;
    Name: String;
    Qualification: TQualification;
    EnterDate: TDateTime;
    LeaveDate: TDateTime;
  end;

  TSkill = record
    ID: Integer;
    Description: String;
  end;

  TWork = record
    ID: Integer;
    Name: String;
    Position: String;
    Achievements: String;
    EnterDate: TDateTime;
    LeaveDate: TDateTime;
  end;

  TDataBase = class
  private
    fDataBasePath: String;
    fSQLConnection: TSQLConnection;
    function GetEducation(PersonID, Index: Integer): TEducation;
    function GetPerson(ID: Integer): TPerson;
    function GetSkill(PersonID, Index: Integer): TSkill;
    function GetWork(PersonID, Index: Integer): TWork;
    procedure SetEducation(PersonID, Index: Integer; const Value: TEducation);
    procedure SetPerson(ID: Integer; const Value: TPerson);
    procedure SetSkill(PersonID, Index: Integer; const Value: TSkill);
    procedure SetWork(PersonID, Index: Integer; const Value: TWork);
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
    procedure NewPerson(APerson: TPerson);
    property PersonCount: Integer read GetPersonCount;
    property Persons[ID: Integer]: TPerson read GetPerson write SetPerson;
    property PersonQuality[ID: Integer]: TQualification read GetPersonQuality;
    property PersonExperience[ID: Integer]: Double read GetPersonExperience;
    property EducationCount: Integer read GetEducationCount;
    property Educations[PersonID, Index: Integer]: TEducation read GetEducation write SetEducation;
    property SkillsCount: Integer read GetSkillsCount;
    property Skills[PersonID, Index: Integer]: TSkill read GetSkill write SetSkill;
    property WorksCount: Integer read GetWorksCount;
    property Works[PersonID, Index: Integer]: TWork read GetWork write SetWork;
    property DataBasePath: String read fDataBasePath;
  end;

var
  DataBase: TDataBase;

function QualifToStr(AValue: TQualification): String;
function StrToQualif(AValue: String): TQualification;

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
  case IndexText(AValue, ['Нет данных', 'Прошёл курс', 'Техник', 'Бакалавр', 'Специалист',
    'Магистр', 'Иное']) of
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
    SQLQuery.SQL.Text := Format('SELECT * FROM educations WHERE ID = %d LIMIT 1 OFFSET %d;',
      [PersonID, Index]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Name := SQLQuery.Fields[1].AsString;
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

end;

function TDataBase.GetPerson(ID: Integer): TPerson;
var
  SQLQuery: TSQLQuery;
begin
  // Result := INVALID_VALUE;
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text := Format('SELECT * FROM persons LIMIT 1 OFFSET %d;', [ID]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Family := SQLQuery.Fields[1].AsString;
      Result.Name := SQLQuery.Fields[2].AsString;
      Result.Patronymic := SQLQuery.Fields[3].AsString;
      Result.Phone := SQLQuery.Fields[4].AsString;
      Result.EMail := SQLQuery.Fields[5].AsString;
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
    SQLQuery.SQL.Text := Format('SELECT COUNT(*) FROM educations WHERE ID = %d;', [PersonID]);
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
      Format('SELECT ID, SUM(LeaveDate) - SUM(EnterDate) FROM works WHERE ID = %d;', [ID]);
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
      Format('SELECT ID, MAX(Qualification) FROM educations WHERE ID = %d;', [ID]);
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
    SQLQuery.SQL.Text := Format('SELECT COUNT(*) FROM skills WHERE ID = %d;', [PersonID]);
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
    SQLQuery.SQL.Text := Format('SELECT COUNT(*) FROM persons WHERE ID = %d;', [PersonID]);
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
    SQLQuery.SQL.Text := Format('SELECT * FROM skills WHERE ID = %d LIMIT 1 OFFSET %d;',
      [PersonID, Index]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Description := SQLQuery.Fields[1].AsString;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
  finally
    SQLQuery.Free;
  end;
end;

function TDataBase.GetSkillsCount: Integer;
begin

end;

function TDataBase.GetWork(PersonID, Index: Integer): TWork;
var
  SQLQuery: TSQLQuery;
  BufDate: Double;
begin
  SQLQuery := TSQLQuery.Create(nil);
  try
    SQLQuery.SQLConnection := fSQLConnection;
    SQLQuery.SQL.Text := Format('SELECT * FROM works WHERE ID = %d LIMIT 1 OFFSET %d;',
      [PersonID, Index]);
    SQLQuery.Open;
    while not SQLQuery.Eof do
    begin
      Result.ID := SQLQuery.Fields[0].AsInteger;
      Result.Name := SQLQuery.Fields[1].AsString;
      Result.Position := SQLQuery.Fields[2].AsString;
      Result.Achievements := SQLQuery.Fields[3].AsString;
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

end;

procedure TDataBase.NewPerson(APerson: TPerson);
begin
  fSQLConnection.ExecuteDirect
    (Format('INSERT INTO persons (ID, Family, Name, Patronymic, Phone, Email) ' +
    'VALUES (%d, "%s", "%s", "%s", "%s", "%s")', [PersonCount + 1, APerson.Family, APerson.Name,
    APerson.Patronymic, APerson.Phone, APerson.EMail]));
end;

procedure TDataBase.SetEducation(PersonID, Index: Integer; const Value: TEducation);
begin

end;

procedure TDataBase.SetPerson(ID: Integer; const Value: TPerson);
begin

end;

procedure TDataBase.SetSkill(PersonID, Index: Integer; const Value: TSkill);
begin

end;

procedure TDataBase.SetWork(PersonID, Index: Integer; const Value: TWork);
begin

end;

initialization

DataBase := TDataBase.Create;

finalization

if Assigned(DataBase) then
  DataBase.Free;

end.
