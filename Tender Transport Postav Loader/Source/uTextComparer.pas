unit uTextComparer;

{ метод сравнивает две строки и определяет на сколько процентов они похожи.
  результат - целое число от 0 до 100.
}

interface

uses Math, SysUtils;

function CompareWord(word1, word2: string; minPart: integer = 2): integer;

implementation

function CompareWord(word1, word2: string; minPart: integer = 2): integer;
/// метод стравнения отдельных слов.
///    принцип работы: постепенно уменьшая количестов букв, перебираются все
///    возможные куски слова 1 и сравниваются с образцом 2.
///    максимально большой кусок пересчитывается в проценты от общей длины слова 2
///
///    word1 - проверяемое слово,
///    word2 - образец с которым сравниваем
///    minPart - минимальный размер для curLength
var
    curLength: integer;   // текущая длина сравниваемого фрагмента
    curShift: integer;    // текущее смещение по word1 для взятия фрагмента длиной curLength
    part: string;
    foundStart, foundEnd: integer; // длина обнаруженных совпадающий частейф с начала и конца word2
    foundStartPos, foundEndPos : integer; // позиция в которой найдены данные части
    startDiap, endDiap: integer; // переменные для сложения диапазонов найденных човпадающих частей
    i: integer;
begin

    // будем искать более короткое слово в более длинном, тогда проценты сходства не будут завышены
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

//    if (word1 = 'МАГНИТОГОРСК')
//    then word1 := word1;

    /// ищем длину максимального совпадающего фрагмента в НАЧАЛЕ слова
    while curLength >= minPart do
    begin
        /// перемещаемся по слову, беря шаблоны для поиска
//        for curShift := 0 to Length(word1) - curLength + 1 do
        begin
            /// берем шаблон
            part := Copy(word1, curShift, curLength);

            /// ищем совпадение. если есть, запоминаем самое длинное из встреченных
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
    /// ищем длину максимального совпадающего фрагмента в КОНЦЕ слова
    while curLength >= minPart do
    begin
        /// перемещаемся по слову, беря шаблоны для поиска
//        for curShift := 0 to Length(word1) - curLength + 1 do
        begin
            /// берем шаблон
            part := Copy(word1, Length(word1) - curLength + 1, curLength);

            /// ищем совпадение. если есть, запоминаем самое длинное из встреченных
            if Pos(part, word2) > 0 then
            begin
                foundEndPos := Pos(part, word2);
                foundEnd := curLength;
                break;
            end;
        end;

        Dec(curLength);
    end;



    // складываем диапазоны найденных частей сначала и конца word2.
    // это даст нам общее количество совпадающих букв, что позволит более точно вычислить процент совпадения.
    // например, есть два слова: word1 = бабайка, word2 = балалайка
    // после поиска сначала будет найдено совпадение:
    // балалайка
    // ^^
    // после поиска с конца будет найдено совпадение:
    // балалайка
    //      ^^^^
    // соответсвенно, если сложить оба диаапазона, получаем:
    // балалайка  , что равно примерно 60% совпадения
    // ^^   ^^^^
    // но, при сложении следует учитывать, что они могут наслаиваться!


    // данный блок нужен, если есть результат хотя бы одного из поисков
    if (foundStartPos + foundEndPos) > 0 then
    begin
        if foundStartPos <> 0
        then startDiap := Min(foundStartPos, foundEndPos)
        else startDiap := foundEndPos;

        endDiap := Max(foundStartPos + foundStart - 1, foundEndPos + foundEnd - 1);
        result := 0;

        // перебираем диапазон и увеличиваем каунтер совпавших букв, если
        // текущая позиция попадает в начальный или конечний диапазон
        for I := startDiap to endDiap do
        if ((i >= foundStartPos) and (i <= foundStartPos + foundStart)) or
           ((i >= foundEndPos) and (i <= foundEndPos + foundEnd))
        then
            Inc(result);
    end;


    // преобразуем в процент
    result := Round( (result / Length(word2)) * 100 );
end;

end.
