unit uAdminPanel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.TMSButton, FMX.TabControl, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox, FMX.TMSCustomButton, FMX.TMSSpeedButton, FMX.ScrollBox, FMX.Memo,
  FMX.Ani, FMX.Objects, StrUtils, ucLog, uPhenixTypes;

const
  ANI_SPEED = 0.3;

type

  TFilterElem = record
      button: TSpeedButton;
      shape: TShape;
      state: integer;
  end;

  TFilterManager = class
      filter : array[0..3] of TFilterElem;

      procedure SetupFilter(index: integer; shape: TShape);
      procedure ChangeFilter(index: integer);
      function IsFilterOn(index: integer): boolean;
  end;

  TfAdminPanel = class(TForm)
    Panel1: TPanel;
    tcAdmin: TTabControl;
    tbiLog: TTabItem;
    tbiDetail: TTabItem;
    lbLog: TListBox;
    mDetail: TMemo;
    StyleBook1: TStyleBook;
    shFilterBlack: TRoundRect;
    shFilterYellow: TRoundRect;
    shRedFilter: TRoundRect;
    shBlueFilter: TRoundRect;
    Circle1: TCircle;
    Circle2: TCircle;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    lComment: TLabel;
    Image1: TImage;
    Timer1: TTimer;
    procedure sbBlackFilterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Circle1MouseEnter(Sender: TObject);
    procedure Circle1MouseLeave(Sender: TObject);
    procedure Circle2Click(Sender: TObject);
    procedure lbLogChange(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
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

{$R *.fmx}

uses
    uPhenixCORE;

var
    fm : TFilterManager;


procedure TfAdminPanel.AddMessToLog(item: TLogRecord);
var
    atext, formattedDateTime: string;
    selstart: integer;
    i: integer;
begin

    if fm.IsFilterOn(item._MessType) then
    begin
        atext := '['+DateTimeToStr(item._MessTime)+']';

        for I := 1 to item._Level do
           atext := atext + '    ';

        atext := atext + item._Text;

        with lbLog.ItemByIndex(lbLog.Items.Add('')) do
        begin
            StyledSettings := StyledSettings - [TStyledSetting.FontColor];

            Text := ReplaceStr( aText, sLineBreak, ' ' );
            Data := TObject(item._Index);

            case item._MessType of
                FILTER_BLACK:  TextSettings.FontColor := TAlphaColorRec.Black;
                FILTER_YELLOW: TextSettings.FontColor := TAlphaColorRec.Coral;
                FILTER_RED:    TextSettings.FontColor := TAlphaColorRec.Red;
                FILTER_BLUE:   TextSettings.FontColor := TAlphaColorRec.Royalblue;
            end;
        end;

        lbLog.ItemIndex := lbLog.Items.Count-1;
        Application.ProcessMessages;
    end;

end;

procedure TfAdminPanel.UpdateErrorList;
var
    i: integer;
begin
    lbLog.Items.Clear;
    for I := 0 to Core.Log.RowCount - 1 do
        AddMessToLog( Core.Log.GetRow(i) );
end;

procedure TfAdminPanel.Circle1Click(Sender: TObject);
begin
    //dm.SendMail(ADMIN_EMAIL, 'Лог', 'Тест'{lbLog.Items.Text} );
    Core.Log.SaveToFile;
    lM('Письмо и лог-файл высланы разработчику.');
end;

procedure TfAdminPanel.Circle1MouseEnter(Sender: TObject);
begin
    (Sender as TShape).Opacity := 1;
    lComment.Text := (Sender as TShape).StyleName;
end;

procedure TfAdminPanel.Circle1MouseLeave(Sender: TObject);
begin
    (Sender as TShape).Opacity := 0.7;
    if assigned(lbLog.Selected)
    then
        lComment.Text := Core.Log.GetRow(Integer(lbLog.Selected.Data))._Comment
    else
        lComment.Text := '';
end;

procedure TfAdminPanel.Circle2Click(Sender: TObject);
begin
    lbLog.Items.Clear;
    mDetail.Lines.Clear;
    Core.Log.Clear;
end;

procedure TfAdminPanel.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    fAdminPanel.Hide;
    CanClose := false;
end;

procedure TfAdminPanel.FormCreate(Sender: TObject);
begin
    // инициализируем менеджер фильтра
    fm := TFilterManager.Create;
    fm.SetupFilter(0, shFilterBlack);
    fm.SetupFilter(1, shFilterYellow);
    fm.SetupFilter(2, shRedFilter);
    fm.SetupFilter(3, shBlueFilter);

    // позиционируем окно
    self.Top := Screen.Height - self.Height - 50;
    self.Left := Screen.Width - self.Width;

    Timer1.Enabled := true;
end;

procedure TfAdminPanel.lbLogChange(Sender: TObject);
begin
    if lbLog.ItemIndex <> -1 then

    With Core.Log.GetRow(lbLog.ItemIndex) do
    begin
        lComment.Text := ifthen( _Comment = '', _GlobComment, _GlobComment + ': ' + _Comment);
        mDetail.Lines.Text := _Text;
    end;
end;

procedure TfAdminPanel.sbBlackFilterClick(Sender: TObject);
begin
    fm.ChangeFilter((sender as TComponent).Tag);
end;

procedure TfAdminPanel.Timer1Timer(Sender: TObject);
{ поскольку модуль логирования независим от реализации, он не имеет возможности вызвать
  явный внешний метод при обновлении лога (например, для добавления нового сообщения в листбокс).
  но его можно периодически опрашивать и сравнивать информацию о количестве строк в листбоксе и количестве строк в логе
  и заливать недостающие.
 }
var
   i: integer;
begin
    if lbLog.Items.Count < Core.Log.RowCount then
    for I := lbLog.Items.Count to Core.Log.RowCount-1 do
        AddMessToLog( Core.Log.GetRow(i) );
end;

{ TFilterManager }

procedure TFilterManager.ChangeFilter(index: integer);
begin

     with filter[index] do
     begin

         if state = 1 then
         begin
             shape.AnimateFloat('Opacity',    0.5, ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Scale.X',    0.5, ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Scale.Y',    0.5, ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Position.X', 5,   ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Position.Y', 5,   ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             state := 0;
         end else
         begin
             shape.AnimateFloat('Opacity',    0.7, ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Scale.X',    1,   ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Scale.Y',    1,   ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Position.X', 0,   ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             shape.AnimateFloat('Position.Y', 0,   ANI_SPEED, TAnimationType.In, TInterpolationType.Linear);
             state := 1;
         end;
     end;

     fAdminPanel.UpdateErrorList;
end;

function TFilterManager.IsFilterOn(index: integer): boolean;
begin
    result := filter[index].state = 1;
end;

procedure TFilterManager.SetupFilter(index: integer; shape: TShape);
begin
    filter[index].shape  := shape;
    filter[index].state  := 1;
end;

end.
