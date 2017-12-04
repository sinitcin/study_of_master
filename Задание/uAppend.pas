unit uAppend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
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
    Label5: TLabel;
    Button5: TButton;
    Button6: TButton;
    ListViewSkills: TListView;
    BtnRmSkills: TButton;
    BtnAddSkills: TButton;
    Label1: TLabel;
    BtnSave: TButton;
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnAddExpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppendForm: TAppendForm;

implementation

{$R *.dfm}

procedure TAppendForm.BtnAddExpClick(Sender: TObject);
var
  Item: TListItem;
  Work: TWork;
  Person: TPerson;
  EnterDate, LeaveDate: String;
begin
  Work.Name := InputBox('Запись о работе:', 'Место работы:', '');
  Work.Position := InputBox('Запись о работе:', 'Должность:', '');
  Work.Achievements := InputBox('Запись о работе:', 'Достижения:', '');
  EnterDate := InputBox('Запись о работе:', 'Дата трудоустройства:', '');
  LeaveDate := InputBox('Запись о работе:', 'Дата увольнения:', '');
  // Work.EnterDate
  // Work.LeaveDate
  Item := ListViewExp.Items.Add();
  Item.Caption := Work.Name;
  Item.SubItems.Add(Work.Position);
  Item.SubItems.Add(Work.Achievements);
  Item.SubItems.Add(EnterDate);
  Item.SubItems.Add(LeaveDate);
end;

procedure TAppendForm.BtnSaveClick(Sender: TObject);
var
  Person: TPerson;
begin
  // Сохраним инфу о персоне
  Person.Family := EditFamily.Text;
  Person.Name := EditName.Text;
  Person.Patronymic := EditPatronymic.Text;
  Person.Phone := EditPhone.Text;
  Person.EMail := EditMail.Text;
  DataBase.NewPerson(Person);
  ShowMessage('Сохранено');

  // Стаж работы

  Close;
end;

end.
