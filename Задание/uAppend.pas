unit uAppend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, math, AnsiStrings,
  uDataBase;

type
  TAppendForm = class(TForm)
    ScrollBox: TScrollBox;
    EditFamily: TLabeledEdit;
    EditName: TLabeledEdit;
    EditPatronymic: TLabeledEdit;
    EditPhone: TLabeledEdit;
    EditMail: TLabeledEdit;
    Label2: TLabel;
    Bevel1: TBevel;
    ListViewExp: TListView;
    Label3: TLabel;
    BtnAddExp: TButton;
    BtnRmExp: TButton;
    Label4: TLabel;
    ListViewEdu: TListView;
    BtnAddEdu: TButton;
    BtnRmEdu: TButton;
    ListViewSkills: TListView;
    BtnRmSkills: TButton;
    BtnAddSkills: TButton;
    Label1: TLabel;
    BtnSave: TButton;
    Bevel2: TBevel;
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnAddExpClick(Sender: TObject);
    procedure BtnRmExpClick(Sender: TObject);
    procedure BtnAddEduClick(Sender: TObject);
    procedure BtnRmEduClick(Sender: TObject);
    procedure BtnAddSkillsClick(Sender: TObject);
    procedure BtnRmSkillsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppendForm: TAppendForm;

implementation

{$R *.dfm}

function TestInput(AValue: String): Boolean;
begin
  Result := AValue <> '';
  if not Result then
    MessageBox(GetActiveWindow(),
      '�� �� ����� ������, �������� ������ ��������...', '��������',
      MB_ICONWARNING);
end;

procedure TAppendForm.BtnAddEduClick(Sender: TObject);
// �������� ������ � ��������
var
  Item: TListItem;
  Edu: PEducation;
  EnterDate, LeaveDate, Qualification: String;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yy';
  FormatSettings.DateSeparator := '.';
  Edu := GetMemory(SizeOf(TEducation));
  Item := ListViewEdu.Items.Add();

  Edu.Name := ShortString(InputBox('������ �� ��������:',
    '����� ��������:', ''));
  if not TestInput(String(Edu.Name)) then
  begin
    FreeMemory(Edu);
    Item.Free;
    Exit;
  end;
  Item.Caption := String(Edu.Name);

  repeat
    Qualification := InputBox('������ �� ��������:',
      '���������� ������������:', '');
    if not TestInput(String(Edu.Name)) then
    begin
      FreeMemory(Edu);
      Item.Free;
      Exit;
    end;
    if IndexText(AnsiString(Qualification), ['���', '������ ����', '������',
      '��������', '����������', '�������']) <> INVALID_VALUE then
      break
    else
      MessageBox(GetActiveWindow(),
        PChar(String
        ('������� ������������, ��������, ���/������ ����/������/��������/����������/�������')
        + DateToStr(Now)), '��������', MB_ICONWARNING);
  until False;
  Edu.Qualification := StrToQualif(Qualification);
  Item.SubItems.Add(QualifToStr(Edu.Qualification));

  repeat
    EnterDate := InputBox('������ �� ��������:', '���� �����������:', '');
    if not TestInput(EnterDate) then
    begin
      FreeMemory(Edu);
      Item.Free;
      Exit;
    end;
    try
      Edu.EnterDate := StrToDate(EnterDate);
    except
      Edu.EnterDate := 0.0;
      MessageBox(GetActiveWindow(),
        PChar(String('������� ���� � ����� ������������ �������, ��������, ') +
        DateToStr(Now)), '��������', MB_ICONWARNING);
    end;
  until not IsZero(Edu.EnterDate, 0.0001);
  Item.SubItems.Add(EnterDate);

  repeat
    LeaveDate := InputBox('������ �� ��������:',
      '���� ��������� ��������:', '');
    if not TestInput(LeaveDate) then
    begin
      FreeMemory(Edu);
      Item.Free;
      Exit;
    end;
    try
      Edu.LeaveDate := StrToDate(LeaveDate);
    except
      Edu.LeaveDate := 0.0;
      MessageBox(GetActiveWindow(),
        PChar(String('������� ���� � ����� ������������ �������, ��������, ') +
        DateToStr(Now)), '��������', MB_ICONWARNING);
    end;
  until not IsZero(Edu.LeaveDate, 0.0001);
  Item.SubItems.Add(LeaveDate);

  Item.Data := Edu;
end;

procedure TAppendForm.BtnAddExpClick(Sender: TObject);
// �������� ������ � �����
var
  Item: TListItem;
  Work: PWork;
  EnterDate, LeaveDate: String;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yy';
  FormatSettings.DateSeparator := '.';
  Work := GetMemory(SizeOf(TWork));
  Item := ListViewExp.Items.Add();

  Work.Name := ShortString(InputBox('������ � ������:', '����� ������:', ''));
  if not TestInput(String(Work.Name)) then
  begin
    FreeMemory(Work);
    Item.Free;
    Exit;
  end;
  Item.Caption := String(Work.Name);

  Work.Position := ShortString(InputBox('������ � ������:', '���������:', ''));
  if not TestInput(String(Work.Position)) then
  begin
    FreeMemory(Work);
    Item.Free;
    Exit;
  end;
  Item.SubItems.Add(String(Work.Position));

  Work.Achievements := ShortString(InputBox('������ � ������:',
    '����������:', ''));
  if not TestInput(String(Work.Achievements)) then
  begin
    FreeMemory(Work);
    Item.Free;
    Exit;
  end;
  Item.SubItems.Add(String(Work.Achievements));

  repeat
    EnterDate := InputBox('������ � ������:', '���� ���������������:', '');
    if not TestInput(EnterDate) then
    begin
      FreeMemory(Work);
      Item.Free;
      Exit;
    end;
    try
      Work.EnterDate := StrToDate(EnterDate);
    except
      Work.EnterDate := 0.0;
      MessageBox(GetActiveWindow(),
        PChar(String('������� ���� � ����� ������������ �������, ��������, ') +
        DateToStr(Now)), '��������', MB_ICONWARNING);
    end;
  until not IsZero(Work.EnterDate, 0.0001);
  Item.SubItems.Add(EnterDate);

  repeat
    LeaveDate := InputBox('������ � ������:', '���� ����������:', '');
    if not TestInput(LeaveDate) then
    begin
      FreeMemory(Work);
      Item.Free;
      Exit;
    end;
    try
      Work.LeaveDate := StrToDate(LeaveDate);
    except
      Work.LeaveDate := 0.0;
      MessageBox(GetActiveWindow(),
        PChar(String('������� ���� � ����� ������������ �������, ��������, ') +
        DateToStr(Now)), '��������', MB_ICONWARNING);
    end;
  until not IsZero(Work.LeaveDate, 0.0001);
  Item.SubItems.Add(LeaveDate);

  Item.Data := Work;
end;

procedure TAppendForm.BtnAddSkillsClick(Sender: TObject);
// �������� ������ � ������� � �����������
var
  Item: TListItem;
  Skill: PSkill;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yy';
  FormatSettings.DateSeparator := '.';
  Skill := GetMemory(SizeOf(TSkill));
  Item := ListViewSkills.Items.Add();

  Skill.Description := ShortString(InputBox('���������� ������:',
    '��� ����� ��� ����������:', ''));
  if not TestInput(String(Skill.Description)) then
  begin
    FreeMemory(Skill);
    Item.Free;
    Exit;
  end;
  Item.Caption := String(Skill.Description);

  Item.Data := Skill;
end;

procedure TAppendForm.BtnRmEduClick(Sender: TObject);
// ������� ������ �� �����������
begin
  if Assigned(ListViewEdu.Selected) then
    ListViewEdu.Selected.Free;
end;

procedure TAppendForm.BtnRmExpClick(Sender: TObject);
// ������� ������ � �����
begin
  if Assigned(ListViewExp.Selected) then
    ListViewExp.Selected.Free;
end;

procedure TAppendForm.BtnRmSkillsClick(Sender: TObject);
// ������� ������ � �������
begin
  if Assigned(ListViewSkills.Selected) then
    ListViewSkills.Selected.Free;
end;

procedure TAppendForm.BtnSaveClick(Sender: TObject);
var
  PID: Integer;
  Person: TPerson;
  I: Integer;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yy';
  FormatSettings.DateSeparator := '.';
  if (EditFamily.Text = '') or (EditName.Text = '') or (EditPatronymic.Text = '')
  then
  begin
    MessageBox(GetActiveWindow(), '������� ������ �.�.� ��� �����������...',
      '��������', MB_ICONWARNING);
    Exit;
  end;

  // �������� ���� � �������
  Person.Family := ShortString(EditFamily.Text);
  Person.Name := ShortString(EditName.Text);
  Person.Patronymic := ShortString(EditPatronymic.Text);
  Person.Phone := ShortString(EditPhone.Text);
  Person.EMail := ShortString(EditMail.Text);
  PID := DataBase.NewPerson(Person);

  // ���� ������
  for I := 0 to ListViewExp.Items.Count - 1 do
    DataBase.NewWork(PID, PWork(ListViewExp.Items[I].Data)^);

  // �����������
  for I := 0 to ListViewEdu.Items.Count - 1 do
    DataBase.NewEducation(PID, PEducation(ListViewEdu.Items[I].Data)^);

  // ����������
  for I := 0 to ListViewEdu.Items.Count - 1 do
    DataBase.NewSkill(PID, PSkill(ListViewSkills.Items[I].Data)^);

  ShowMessage('���������');
  Close;
end;

end.
