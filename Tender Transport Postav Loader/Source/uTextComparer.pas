unit uTextComparer;

{ ����� ���������� ��� ������ � ���������� �� ������� ��������� ��� ������.
  ��������� - ����� ����� �� 0 �� 100.
}

interface

uses Math, SysUtils;

function CompareWord(word1, word2: string; minPart: integer = 2): integer;

implementation

function CompareWord(word1, word2: string; minPart: integer = 2): integer;
/// ����� ���������� ��������� ����.
///    ������� ������: ���������� �������� ���������� ����, ������������ ���
///    ��������� ����� ����� 1 � ������������ � �������� 2.
///    ����������� ������� ����� ��������������� � �������� �� ����� ����� ����� 2
///
///    word1 - ����������� �����,
///    word2 - ������� � ������� ����������
///    minPart - ����������� ������ ��� curLength
var
    curLength: integer;   // ������� ����� ������������� ���������
    curShift: integer;    // ������� �������� �� word1 ��� ������ ��������� ������ curLength
    part: string;
    foundStart, foundEnd: integer; // ����� ������������ ����������� ������� � ������ � ����� word2
    foundStartPos, foundEndPos : integer; // ������� � ������� ������� ������ �����
    startDiap, endDiap: integer; // ���������� ��� �������� ���������� ��������� ����������� ������
    i: integer;
begin

    // ����� ������ ����� �������� ����� � ����� �������, ����� �������� �������� �� ����� ��������
    if Length(word1) > Length(word2) then
    begin
        part := word1;
        word1 := word2;
        word2 := part;
    end;

    curLength := Min( Length(word1), Length(word2));
    curShift := 0;
    result := 0;
    minPart := min(minPart, curLength);
    minPart := min(minPart, Length(word2));
    foundStart := 0;
    foundEnd := 0;
    foundStartPos := 0;
    foundEndPos := 0;

//    if (word1 = '������������')
//    then word1 := word1;

    /// ���� ����� ������������� ������������ ��������� � ������ �����
    while curLength >= minPart do
    begin
        /// ������������ �� �����, ���� ������� ��� ������
//        for curShift := 0 to Length(word1) - curLength + 1 do
        begin
            /// ����� ������
            part := Copy(word1, curShift, curLength);

            /// ���� ����������. ���� ����, ���������� ����� ������� �� �����������
            if Pos(part, word2) > 0 then
            begin
                foundStartPos := Pos(part, word2);
                foundStart := curLength;
                break;
            end;
        end;

        Dec(curLength);
    end;


    curLength := Min( Length(word1), Length(word2));
    /// ���� ����� ������������� ������������ ��������� � ����� �����
    while curLength >= minPart do
    begin
        /// ������������ �� �����, ���� ������� ��� ������
//        for curShift := 0 to Length(word1) - curLength + 1 do
        begin
            /// ����� ������
            part := Copy(word1, Length(word1) - curLength + 1, curLength);

            /// ���� ����������. ���� ����, ���������� ����� ������� �� �����������
            if Pos(part, word2) > 0 then
            begin
                foundEndPos := Pos(part, word2);
                foundEnd := curLength;
                break;
            end;
        end;

        Dec(curLength);
    end;



    // ���������� ��������� ��������� ������ ������� � ����� word2.
    // ��� ���� ��� ����� ���������� ����������� ����, ��� �������� ����� ����� ��������� ������� ����������.
    // ��������, ���� ��� �����: word1 = �������, word2 = ���������
    // ����� ������ ������� ����� ������� ����������:
    // ���������
    // ^^
    // ����� ������ � ����� ����� ������� ����������:
    // ���������
    //      ^^^^
    // �������������, ���� ������� ��� ����������, ��������:
    // ���������  , ��� ����� �������� 60% ����������
    // ^^   ^^^^
    // ��, ��� �������� ������� ���������, ��� ��� ����� ������������!


    // ������ ���� �����, ���� ���� ��������� ���� �� ������ �� �������
    if (foundStartPos + foundEndPos) > 0 then
    begin
        if foundStartPos <> 0
        then startDiap := Min(foundStartPos, foundEndPos)
        else startDiap := foundEndPos;

        endDiap := Max(foundStartPos + foundStart - 1, foundEndPos + foundEnd - 1);
        result := 0;

        // ���������� �������� � ����������� ������� ��������� ����, ����
        // ������� ������� �������� � ��������� ��� �������� ��������
        for I := startDiap to endDiap do
        if ((i >= foundStartPos) and (i <= foundStartPos + foundStart)) or
           ((i >= foundEndPos) and (i <= foundEndPos + foundEnd))
        then
            Inc(result);
    end;


    // ����������� � �������
    result := Round( (result / Length(word2)) * 100 );
end;

end.
