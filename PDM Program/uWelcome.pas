unit uWelcome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uMain;

type
  TfWelcome = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    pbLoading: TProgressBar;
    Label3: TLabel;
    StyleBook1: TStyleBook;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Progress(step: integer);
  end;

var
  fWelcome: TfWelcome;

implementation

uses
    uAdminPanel;

{$R *.fmx}

procedure TfWelcome.FormShow(Sender: TObject);
begin
    Application.CreateForm(TfAdminPanel, fAdminPanel);
    Application.CreateForm(TfMain, fMain);
    fMain.Show;
end;

procedure TfWelcome.Progress(step: integer);
begin
    pbLoading.Value := pbLoading.Value + step;
    Application.ProcessMessages;
end;

end.
