unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSBaseControl, FMX.TMSTreeViewBase, FMX.TMSTreeViewData,
  FMX.TMSCustomTreeView, FMX.TMSTreeView, FMX.Controls.Presentation,
  Windows, FMX.StdCtrls, Messages, System.Actions, FMX.ActnList;

type
  TfMain = class(TForm)
    TMSFMXTreeView1: TTMSFMXTreeView;
    Button1: TButton;
    actlGlobal: TActionList;
    actShowAdminPanel: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actShowAdminPanelExecute(Sender: TObject);
  private
    { Private declarations }
    procedure InProc;
  public
    { Public declarations }
  end;

var
    fMain: TfMain;

implementation

{$R *.fmx}

uses
    uPhenixCore, uAdminPanel, uConstants, uWelcome, ucTools;

procedure TfMain.actShowAdminPanelExecute(Sender: TObject);
{ открытие / закрытие панели администратора }
begin

    if Assigned(fAdminPanel) then
    if not fAdminPanel.Visible
    then
        fAdminPanel.Show
    else
        fAdminPanel.Hide;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
   error: string;
begin

    Core := TCore.Create;
    Core.Init(
        PROG_NAME,
        CONNECTION_STRING,
        SETTINGS_TABLE_NAME,
        LOG_FILEPATH
    );

    fWelcome.Progress(10);

    Core.Log.Comment('uMain.FormCreate');
    Core.Settings.RestoreForm(self);

    fWelcome.Progress(10);

    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);
    Sleep(100);
    fWelcome.Progress(10);

    // отоброжаем текущую версию программы
    Caption := Caption + ' (' + GetFileVersion() + ')';

    // пр€чем приветственное окно
    fWelcome.Hide;

    Core.Log.CommentExit;
end;

procedure TfMain.InProc;
begin
    Core.Log.Comment('fMain.InProc');
    Core.Log.Mess('¬нутренн€€ процедурка');
    Core.Log.CommentExit;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Core.Settings.SaveForm(self);
    fWelcome.Close;
end;

end.
