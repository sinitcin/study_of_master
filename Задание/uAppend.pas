unit uAppend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TAppendForm = class(TForm)
    ScrollBox: TScrollBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppendForm: TAppendForm;

implementation

{$R *.dfm}

end.
