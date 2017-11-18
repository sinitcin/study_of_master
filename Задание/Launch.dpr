program Launch;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  uConfig in 'uConfig.pas' {Frame1: TFrame},
  uAbout in 'uAbout.pas' {Frame3: TFrame},
  uTrash in 'uTrash.pas' {Frame4: TFrame},
  uListAll in 'uListAll.pas' {ListAllFrame: TFrame},
  uFind in 'uFind.pas' {Frame6: TFrame},
  uAppend in 'uAppend.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Tablet Light');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
