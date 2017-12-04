unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TAboutFrame = class(TFrame)
    Memo: TMemo;
    Image: TImage;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TAboutFrame.FrameResize(Sender: TObject);
begin
  Image.Top := 0;
  Image.Height := ClientHeight;
  Image.Width := ClientWidth;
end;

procedure TAboutFrame.TimerTimer(Sender: TObject);
begin
  Image.Visible := False;
  Memo.Visible := True;
  Timer.Enabled := False;
end;

end.
