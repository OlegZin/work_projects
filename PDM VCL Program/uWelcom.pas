unit uWelcom;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, uMain;

type
  TfWelcome = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    pbLoading: TProgressBar;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Progress(step: integer);
    { Public declarations }
  end;

var
  fWelcome: TfWelcome;

implementation

{$R *.dfm}

procedure TfWelcome.FormShow(Sender: TObject);
begin
    pbLoading.Position := 0;
end;

procedure TfWelcome.Progress(step: integer);
begin
    pbLoading.Position := pbLoading.Position + step;
    Application.ProcessMessages;
end;

end.
