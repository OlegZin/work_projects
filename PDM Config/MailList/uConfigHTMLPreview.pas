unit uConfigHTMLPreview;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSWebBrowser;

type
  TfHTMLPreview = class(TForm)
    webHTML: TTMSFMXWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure SaveWindowState;
    { Public declarations }
  end;

var
  fHTMLPreview: TfHTMLPreview;

implementation

{$R *.fmx}

uses
    uPhenixCORE, ucFMXTools;

procedure TfHTMLPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SaveWindowState;
end;

procedure TfHTMLPreview.FormShow(Sender: TObject);
begin
    RestoreForm(self);
end;

procedure TfHTMLPreview.SaveWindowState;
begin
    if not Assigned(self) then exit;
    SaveForm(self);
end;

end.
