unit uDrawSpecifManager;

interface

uses
    Classes, Vcl.Grids, Windows;

type
    TDrawSpecifManager = class
    private
        fGrid : TStringGrid;  // внешний компонент, где рисуем и работаем со спецификацией

        // обработчик нажатия клавиши
        procedure StringGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    public
        error : string;

        function SetGrid( grid: TStringGrid ): TDrawSpecifManager;
        // привязываем к классу внешний компонент таблицы
        function Init: boolean;
    end;

implementation

{ TDrawSpecifManager }

function TDrawSpecifManager.Init: boolean;
begin
    result := false;
    error := '';

    if not Assigned( fGrid ) then error:= 'Не привязан TStringGrid для визуализации';

    if error <> '' then exit;

    // вешаем обработчики
    fGrid.OnKeyUp := StringGridKeyUp;

    result := true;
end;

function TDrawSpecifManager.SetGrid(grid: TStringGrid): TDrawSpecifManager;
begin
    result := self;
    fGrid := grid;
end;

procedure TDrawSpecifManager.StringGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    col, row: integer;
begin

    for col := fGrid.Selection.left to fGrid.Selection.Right do
    for row := fGrid.Selection.top to fGrid.Selection.Bottom do

    CASE Key of
        VK_DELETE : fGrid.Cells[Col, Row] := '';
        VK_BACK : fGrid.Cells[Col, Row] := Copy(fGrid.Cells[Col, Row], 1, Length(fGrid.Cells[Col, Row])-1);
        48..57 {0..9}: fGrid.Cells[Col, Row] := fGrid.Cells[Col, Row] + Char(Key);
    END

end;

end.
