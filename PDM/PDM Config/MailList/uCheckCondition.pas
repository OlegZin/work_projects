unit uCheckCondition;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls;

type
  TfCheckCondition = class(TForm)
    mSQL: TMemo;
    lbUserList: TListBox;
    Splitter1: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure Refresh(nameMail, conditions: string);
    procedure SaveWindowState;
    { Public declarations }
  end;

var
  fCheckCondition: TfCheckCondition;

implementation

{$R *.fmx}

{ TfCheckCondition }

uses uPhenixCORE, ucFMXTools;

procedure TfCheckCondition.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SaveWindowState;
end;

procedure TfCheckCondition.FormShow(Sender: TObject);
begin
    RestoreForm(self);
    lbUserList.Width := Core.Settings.LoadValue('lbUserList', 'width', lbUserList.Width);
end;

procedure TfCheckCondition.Refresh(nameMail, conditions: string);
{ обновляем список пользователей по текущему запросу }
begin
    lbUserList.Items.QuoteChar := ',';
    lbUserList.Items :=  Core.Mail.GetDataList( nameMail, 'fio', conditions );
    mSQL.Lines.Text := Core.Mail.CompileSQL( nameMail, 'fio', conditions );

end;

procedure TfCheckCondition.SaveWindowState;
begin
    if not Assigned(self) then exit;

    SaveForm(self);
    Core.Settings.SaveValue('lbUserList', 'width', lbUserList.Width);
end;

end.
