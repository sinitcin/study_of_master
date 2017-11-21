unit uListAll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Data.DbxSqlite, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.FMTBcd, Vcl.ExtCtrls, Vcl.DBCtrls, Datasnap.DBClient, SimpleDS,
  Vcl.ToolWin, System.ImageList, Vcl.ImgList, DateUtils;

const
  COL_FAMILY = 0;
  COL_NAME = 1;
  COL_PATRONYMIC = 2;
  COL_QUALIF = 3;
  COL_EXPERIENCE = 4;

type
  TQualification = (qCourse { ����� �����\��� } , qTechnician { ������ } , qBachelor { �������� } ,
    qSpecialist { ���������� } , qMaster { ������� } );

  TItemData = record
    // ����
    ExperienceInterval: TDateTime;
    // ������������
    Qualification: TQualification;
  end;

  PItemData = ^TItemData;

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
    CheckBox: TCheckBox;
    procedure FrameResize(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
  private
    { Private declarations }
    ShowOnlyExp: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure ResizeColumns;
    procedure ClearMainTable;
    procedure LoadMainTable;
    function QualifToStr(AValue: TQualification): String;
  end;

implementation

{$R *.dfm}

procedure TListAllFrame.CheckBoxClick(Sender: TObject);
begin
  if CheckBox.Checked = ShowOnlyExp then
    Exit;
  ShowOnlyExp := CheckBox.Checked;
  ClearMainTable;
  LoadMainTable;
end;

procedure TListAllFrame.ClearMainTable;
begin
  //
end;

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
      ShowMessage('������ �������� ��: ' + E.Message);
  end;
end;

procedure TListAllFrame.FrameResize(Sender: TObject);
begin
  ResizeColumns;
end;

procedure TListAllFrame.LoadMainTable;
// �������� �������� �������

  function YearToStr(AValue: Word): String;
  begin
    case AValue of
      0:
        Exit('');
      1:
        Result := ' ���';
      2, 3, 4:
        Result := ' ����';
    else
      Result := ' ���';
    end;
    Result := IntToStr(AValue) + Result;
  end;

  function MounthToStr(AValue: Word): String;
  begin
    case AValue of
      0:
        Exit('');
      1:
        Result := ' �����';
      2, 3, 4:
        Result := ' ������';
    else
      Result := ' �������';
    end;
    Result := IntToStr(AValue) + Result;
  end;

const
  DB_FAMILY = 0;
  DB_NAME = 1;
  DB_PATRONYMIC = 2;
  DB_QUALIF = 3;
  DB_EXPERIENCE = 4;
var
  Item: TListItem;
  ItemData: PItemData;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
  CurrYear, CurrMonth: Word;
  DateInterval: Double;
  Qualif: TQualification;
begin
  SQLQuery.SQL.Text := 'SELECT';
  SQLQuery.SQL.Add('persons.family,');
  SQLQuery.SQL.Add('persons.name,');
  SQLQuery.SQL.Add('persons.patronymic');
  SQLQuery.SQL.Add(',MAX(educations.qualification)');
  SQLQuery.SQL.Add(',SUM(works.leavedate - works.enterdate)');
  SQLQuery.SQL.Add('FROM persons');
  SQLQuery.SQL.Add('JOIN educations USING(id) JOIN works USING(id)');
  SQLQuery.Open;
  while not SQLQuery.Eof do
  begin
    GetMem(ItemData, SizeOf(TItemData));
    Item := ListView.Items.Add;
    Item.Caption := SQLQuery.Fields[DB_FAMILY].AsString;
    Item.SubItems.Add(SQLQuery.Fields[DB_NAME].AsString);
    Item.SubItems.Add(SQLQuery.Fields[DB_PATRONYMIC].AsString);
    if not SQLQuery.Fields[DB_QUALIF].IsNull then
    begin
      Qualif := TQualification(SQLQuery.Fields[DB_QUALIF].AsInteger);
      Item.SubItems.Add(QualifToStr(Qualif));
      ItemData.Qualification := Qualif;
    end
    else
      Item.SubItems.Add('��� ������������');

    if not SQLQuery.Fields[DB_EXPERIENCE].IsNull then
    begin
      DateInterval := StrToFloatDef(SQLQuery.Fields[DB_EXPERIENCE].AsString, 0.0);
      DecodeDateTime(Now, CurrYear, CurrMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
      DecodeDateTime(Now - DateInterval, AYear, AMonth, ADay, AHour, AMinute, ASecond,
        AMilliSecond);
      Item.SubItems.Add(YearToStr(CurrYear - AYear) + ' ' + MounthToStr(CurrMonth - AMonth));
      ItemData.ExperienceInterval := DateInterval;
    end
    else
      Item.SubItems.Add('��� �����');
    Item.Data := ItemData;

    SQLQuery.Next;
  end;
  SQLQuery.Close;
end;

function TListAllFrame.QualifToStr(AValue: TQualification): String;
// ������������ � ������
begin
  case AValue of
    qCourse:
      Result := '������ ����';
    qTechnician:
      Result := '������';
    qBachelor:
      Result := '��������';
    qSpecialist:
      Result := '����������';
    qMaster:
      Result := '�������';
  else
    Result := '����';
  end;
end;

procedure TListAllFrame.ResizeColumns;
// ������������ �������

  function GetWidthByPercent(ControlWidth, Percent: Integer): Integer;
  // �������� ������ � �������� �� Percent
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
