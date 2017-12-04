unit uAppend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, math, AnsiStrings,
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
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnAddExpClick(Sender: TObject);
    procedure BtnRmExpClick(Sender: TObject);
    procedure BtnAddEduClick(Sender: TObject);
    procedure BtnRmEduClick(Sender: TObject);
    procedure BtnAddSkillsClick(Sender: TObject);
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
    MessageBox(GetActiveWindow(), '�� �� ����� ������, �������� ������ ��������...', '��������',
      MB_ICONWARNING);
end;

procedure TAppendForm.BtnAddEduClick(Sender: TObject);
// �������� ������ � ��������
var
  Item: TListItem;
  Edu: PEducation;
  EnterDate, LeaveDate, Qualification: String;
begin
  BtnAddEdu.Enabled := False;
  try
    FormatSettings.ShortDateFormat := 'dd.mm.yy';
    FormatSettings.DateSeparator := '.';
    Edu := GetMemory(SizeOf(TEducation));
    Item := ListViewEdu.Items.Add();

    Edu.Name := ShortString(InputBox('������ �� ��������:', '����� ��������:', ''));
    if not TestInput(String(Edu.Name)) then
    begin
      FreeMemory(Edu);
      Item.Free;
      Exit;
    end;
    Item.Caption := String(Edu.Name);

    repeat
      Qualification := InputBox('������ �� ��������:', '���������� ������������:', '');
      if not TestInput(String(Edu.Name)) then
      begin
        FreeMemory(Edu);
        Item.Free;
        Exit;
      end;
      if IndexText(AnsiString(Qualification), ['���', '������ ����', '������', '��������', '����������',
        '�������']) <> INVALID_VALUE then
        break
      else
        MessageBox(GetActiveWindow(),
          PChar(String
          ('������� ������������, ��������, ���/������ ����/������/��������/����������/�������') +
          DateToStr(Now)), '��������', MB_ICONWARNING);
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
          PChar(String('������� ���� � ����� ������������ �������, ��������, ') + DateToStr(Now)),
          '��������', MB_ICONWARNING);
      end;
    until not IsZero(Edu.EnterDate, 0.0001);
    Item.SubItems.Add(EnterDate);

    repeat
      LeaveDate := InputBox('������ �� ��������:', '���� ��������� ��������:', '');
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
          PChar(String('������� ���� � ����� ������������ �������, ��������, ') + DateToStr(Now)),
          '��������', MB_ICONWARNING);
      end;
    until not IsZero(Edu.LeaveDate, 0.0001);
    Item.SubItems.Add(LeaveDate);

    Item.Data := Edu;
  finally
    BtnAddEdu.Enabled := True;
  end;
end;

procedure TAppendForm.BtnAddExpClick(Sender: TObject);
// �������� ������ � �����
var
  Item: TListItem;
  Work: PWork;
  EnterDate, LeaveDate: String;
begin
  BtnAddExp.Enabled := False;
  try
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

    Work.Achievements := ShortString(InputBox('������ � ������:', '����������:', ''));
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
          PChar(String('������� ���� � ����� ������������ �������, ��������, ') + DateToStr(Now)),
          '��������', MB_ICONWARNING);
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
          PChar(String('������� ���� � ����� ������������ �������, ��������, ') + DateToStr(Now)),
          '��������', MB_ICONWARNING);
      end;
    until not IsZero(Work.LeaveDate, 0.0001);
    Item.SubItems.Add(LeaveDate);

    Item.Data := Work;
  finally
    BtnAddExp.Enabled := True;
  end;
end;

procedure TAppendForm.BtnAddSkillsClick(Sender: TObject);
// �������� ������ � ������� � �����������
var
  Item: TListItem;
  Skill: PSkill;
begin
  BtnAddEdu.Enabled := False;
  try
    FormatSettings.ShortDateFormat := 'dd.mm.yy';
    FormatSettings.DateSeparator := '.';
    Skill := GetMemory(SizeOf(TSkill));
    Item := ListViewSkills.Items.Add();

    Skill.Description := InputBox('���������� ������:', '��� ����� ��� ����������:', '');
    if not TestInput(Skill.Description) then
    begin
      FreeMemory(Skill);
      Item.Free;
      Exit;
    end;
    Item.Caption := Skill.Description;

    Item.Data := Skill;
  finally
    BtnAddEdu.Enabled := True;
  end;
end;

procedure TAppendForm.BtnRmEduClick(Sender: TObject);
// ������� ������ �� �����������
begin
  if Assigned(ListViewExp.Selected) then
    ListViewEdu.Selected.Free;
end;

procedure TAppendForm.BtnRmExpClick(Sender: TObject);
// ������� ������ � �����
begin
  if Assigned(ListViewExp.Selected) then
    ListViewExp.Selected.Free;
end;

procedure TAppendForm.BtnSaveClick(Sender: TObject);
var
  Person: TPerson;
begin
  // �������� ���� � �������
  Person.Family := EditFamily.Text;
  Person.Name := EditName.Text;
  Person.Patronymic := EditPatronymic.Text;
  Person.Phone := EditPhone.Text;
  Person.EMail := EditMail.Text;
  DataBase.NewPerson(Person);
  ShowMessage('���������');

  // ���� ������

  Close;
end;

end.
