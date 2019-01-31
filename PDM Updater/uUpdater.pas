unit uUpdater;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSProgressBar, FMX.Objects,
  FMX.Ani, Windows, ShellApi;

const
    SOURCE_PATH = '\\fileserver\Общая папка\ОА\! Внутренняя ОА\_Проекты разработчиков\SourceCode\Зиновьев О\DPM Neftrmash\Compiled\PDM Starter\';
    STARTER_FILENAME = 'pdmStarter.exe';

type
  TfUpdater = class(TForm)
    cGif: TCircle;
    Timer1: TTimer;
    Circle1: TCircle;
    bClose: TCircle;
    procedure Timer1Timer(Sender: TObject);
    procedure bCloseMouseEnter(Sender: TObject);
    procedure bCloseMouseLeave(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure bCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fUpdater: TfUpdater;

implementation

{$R *.fmx}

procedure TfUpdater.FormShow(Sender: TObject);
var
    currentPath: string;
    error : integer;
begin

    currentPath := ExtractFilePath( paramstr(0) );

    // копируем текущую версию стартера на машину пользователя
    if not CopyFile(
        PChar( SOURCE_PATH + STARTER_FILENAME ),
        PChar( currentPath + STARTER_FILENAME ),
        False   // по-умолчанию перезаписываем
    ) then
    begin
        if not FileExists( currentPath + STARTER_FILENAME )
        then
        begin
            ShowMessage(
                'Ошибка: ' + SysErrorMessage(GetLastError) + sLineBreak +
                SOURCE_PATH + STARTER_FILENAME + sLineBreak + sLineBreak +
                'Запуск программы невозможен. Обратитесь к администратору.' + sLineBreak
            );
            Halt;
        end
        else
            ShowMessage(
                'Ошибка: ' + SysErrorMessage(GetLastError) + sLineBreak +
                SOURCE_PATH + STARTER_FILENAME + sLineBreak + sLineBreak +
                'Не удалось обновить программу. Запускаем текущую версию.'
            );
    end;

    // запускаем стартер и самоубиваемся при успешном запуске
    if ShellExecute( HWND(handle), 'open', PChar(currentPath + STARTER_FILENAME), nil, nil, SW_SHOWNORMAL ) <> 42
    then
        ShowMessage( SysErrorMessage(GetLastError) );

    Halt;

end;

procedure TfUpdater.bCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfUpdater.bCloseMouseEnter(Sender: TObject);
begin
    bClose.Opacity := 0.5;
end;

procedure TfUpdater.bCloseMouseLeave(Sender: TObject);
begin
    bClose.Opacity := 0.2;
end;

procedure TfUpdater.FormCreate(Sender: TObject);
begin
    Height := 150;
    Width := 150;
end;

procedure TfUpdater.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
    bClose.Opacity := 0.2;
end;

procedure TfUpdater.Timer1Timer(Sender: TObject);
begin
    cGif.RotationAngle := cGif.RotationAngle + 30;
end;

end.
