unit uDrawSpecifManager;

interface

uses
    Classes, Vcl.Grids, Windows;

type
    TDrawSpecifManager = class
    private
        fGrid : TStringGrid;  // ������� ���������, ��� ������ � �������� �� �������������

        // ���������� ������� �������
        procedure StringGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    public
        error : string;

        function SetGrid( grid: TStringGrid ): TDrawSpecifManager;
        // ����������� � ������ ������� ��������� �������
        function Init: boolean;
    end;

implementation

{ TDrawSpecifManager }

function TDrawSpecifManager.Init: boolean;
begin
    result := false;
    error := '';

    if not Assigned( fGrid ) then error:= '�� �������� TStringGrid ��� ������������';

    if error <> '' then exit;

    // ������ �����������
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
