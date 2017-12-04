unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uListAll, uAbout;

type
  TMainForm = class(TForm)
    LeftPanel: TPanel;
    Label1: TLabel;
    LabelAll: TLabel;
    Label6: TLabel;
    LabelAbout: TLabel;
    ScrollBox: TScrollBox;
    procedure OnMenuMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnMenuMouseLeave(Sender: TObject);
    procedure LabelAllClick(Sender: TObject);
    procedure LabelGoodClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure HideFrames;
    procedure OpenListAll;
    procedure OpenAbout;
  end;

var
  MainForm: TMainForm;
  ListAllFrame: TListAllFrame;
  AboutFrame: TAboutFrame;

implementation

{$R *.dfm}

procedure TMainForm.FormShow(Sender: TObject);
begin
  OpenListAll;
end;

procedure TMainForm.HideFrames;
// Скрыть все фрэймы
begin
  if Assigned(AboutFrame) then
    FreeAndNil(AboutFrame);
  if Assigned(ListAllFrame) then
    FreeAndNil(ListAllFrame);
  LabelAll.Font.Color := clHighlightText;
  LabelAbout.Font.Color := clHighlightText;
end;

procedure TMainForm.LabelAboutClick(Sender: TObject);
begin
  OpenAbout();
end;

procedure TMainForm.LabelAllClick(Sender: TObject);
begin
  OpenListAll;
end;

procedure TMainForm.LabelGoodClick(Sender: TObject);
begin
  HideFrames();
end;

procedure TMainForm.OnMenuMouseLeave(Sender: TObject);
// Уход мыши с лэйблов
begin
  if Sender is TLabel then
    TLabel(Sender).Font.Style := [fsBold];
end;

procedure TMainForm.OnMenuMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
// Движение мыши над меню из лайблов слева
begin
  if Sender is TLabel then
    TLabel(Sender).Font.Style := [fsBold, fsUnderline];
end;

procedure TMainForm.OpenAbout;
// Открыть фрэйм "О программе"
begin
  HideFrames();
  LabelAbout.Font.Color := clHighlight;
  AboutFrame := TAboutFrame.Create(nil);
  AboutFrame.Parent := ScrollBox;
  AboutFrame.Show;
end;

procedure TMainForm.OpenListAll;
// Открыть список всех кандидатов
begin
  HideFrames();
  LabelAll.Font.Color := clHighlight;
  ListAllFrame := TListAllFrame.Create(nil);
  ListAllFrame.Parent := ScrollBox;
  ListAllFrame.LoadMainTable;
  ListAllFrame.Show;
end;

end.
