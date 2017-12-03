program Launch;

uses
  Windows,
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  uAbout in 'uAbout.pas' {AboutFrame: TFrame},
  uListAll in 'uListAll.pas' {ListAllFrame: TFrame},
  uAppend in 'uAppend.pas' {AppendForm},
  uDataBase in 'uDataBase.pas',
  uPreview in 'uPreview.pas' {FormPreview};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Tablet Light');
  if MessageBox(HWND_DESKTOP, 'Внести новое резюме?', 'Вопрос', MB_ICONQUESTION or MB_YESNO) = IDNO
  then
    Application.CreateForm(TMainForm, MainForm)
  else
    Application.CreateForm(TAppendForm, AppendForm);
  Application.CreateForm(TFormPreview, FormPreview);
  Application.Run;

end.
