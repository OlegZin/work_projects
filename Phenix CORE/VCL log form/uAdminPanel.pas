unit uAdminPanel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw,
  Vcl.Menus, ComObj, uPhenixCORE, uPhenixTypes, StrUtils;

type

  TfAdminPanel = class(TForm)
    sbMailLog: TSpeedButton;
    Panel2: TPanel;
    sbClearLog: TSpeedButton;
    lbLog: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    lProcName: TLabel;
    sbSQLFilter: TSpeedButton;
    sbErrorFilter: TSpeedButton;
    sbCommonFilter: TSpeedButton;
    sbWarningFilter: TSpeedButton;
    pcAdminTabs: TPageControl;
    tsLog: TTabSheet;
    tsDetail: TTabSheet;
    mDetail: TMemo;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure sbClearLogClick(Sender: TObject);
    procedure sbMailLogClick(Sender: TObject);
    procedure lbLogDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure lbLogClick(Sender: TObject);
    procedure sbCommonFilterClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddMessToLog(item: TLogRecord);
    procedure UpdateErrorList;
  end;

var
  fAdminPanel: TfAdminPanel;

implementation

{$R *.dfm}

type
    TMessElem = record
        prefix: string[3];
        visible: boolean;
    end;

var
    MessTypes : array [0..5] of boolean = (true,true,true,true,true,true);

procedure TfAdminPanel.UpdateErrorList;
var
   i: integer;
begin
    if not Assigned(Core) then exit;

    if lbLog.Items.Count < Core.Log.RowCount then
    for I := lbLog.Items.Count to Core.Log.RowCount-1 do
        AddMessToLog( Core.Log.GetRow(i) );
end;

procedure TfAdminPanel.sbMailLogClick(Sender: TObject);
begin
    Core.Mail.Mail(
        'log',
        [  // данные, которые будут подставлены в тело письма
           Core.Log.SaveToFile    // путь+имя файла лога
        ]
    );
    ShowMessage('Лог отправлен на email разработчика.');
end;

procedure TfAdminPanel.Timer1Timer(Sender: TObject);
begin
    UpdateErrorList;
end;

procedure TfAdminPanel.sbClearLogClick(Sender: TObject);
begin
    lbLog.Items.Clear;
    mDetail.Lines.Clear;
    Core.Log.Clear;
end;

procedure TfAdminPanel.sbCommonFilterClick(Sender: TObject);
begin
    MessTypes[(Sender as TSpeedButton).tag] := (Sender as TSpeedButton).Down;
    lbLog.Items.Clear;
    UpdateErrorList;
end;

procedure TfAdminPanel.FormShow(Sender: TObject);
begin
    self.Top := Screen.Height - self.Height - 50;
    self.Left := Screen.Width - self.Width;
end;

procedure TfAdminPanel.lbLogClick(Sender: TObject);
begin
    if lbLog.ItemIndex <> -1 then

    With Core.Log.GetRow(lbLog.ItemIndex) do
    begin
        lProcName.Caption := ifthen( _Comment = '', _GlobComment, _GlobComment + ': ' + _Comment);
        mDetail.Lines.Text := _Text;
    end;

end;

procedure TfAdminPanel.lbLogDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  text: string;
  arrIndex : integer;
begin

    Text := (Control as TListBox).Items[Index];
    arrIndex := Integer((Control as TListBox).Items.Objects[Index]);

    with lbLog.Canvas do
    begin
        Brush.Color := clWhite;
        FillRect(Rect);

        Font.Color := clBlack;

        With Core.Log.GetRow( arrIndex ) do
        begin
            if _MessType = MESS_TYPE_WARNING then Font.Color := RGB(255, 128, 64);
            if _MessType = MESS_TYPE_ERROR   then Font.Color := clRed;
            if _MessType = MESS_TYPE_QUERY   then Font.Color := clBlue;
        end;

        TextOut(Rect.Left, Rect.Top, text);
    end;
end;

procedure TfAdminPanel.AddMessToLog(item: TLogRecord);
var
    atext, formattedDateTime: string;
    selstart: integer;
begin

    if MessTypes[item._MessType] then
    begin
        atext := '['+DateTimeToStr(item._MessTime)+'] ' + item._Text;
        lbLog.Items.AddObject( atext, TObject(item._Index) );

        lblog.TopIndex := lbLog.Items.Count-1;
        Application.ProcessMessages;
    end;

end;

initialization

    if not Assigned(fAdminPanel) then
        fAdminPanel := TfAdminPanel.Create(nil);

finalization

    if Assigned(fAdminPanel) then
        FreeAndNil(fAdminPanel);

end.
