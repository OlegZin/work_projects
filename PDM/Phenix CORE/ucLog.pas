unit ucLog;

interface

uses SysUtils, Classes, System.ZLib, uPhenixTypes;

const
{
  FILTER_BLACK  = 0;
  FILTER_YELLOW = 1;
  FILTER_RED    = 2;
  FILTER_BLUE   = 3;
}
  { при сохранении массива в файл, он перегоняется в одну текстовую строку,
    разделенную на элементы условными комбинациями символов  }
  ELEM_BREAKER  = '_;_';      // разделяет элементы массва лога (TLogRecord)
  FIELD_BREAKER = '_;;_';     // разделяет данные полей элемента массива (_MessTime, _GlobComment,...)
  LINE_BREAKER  = '_;;;_';    // разделяет значение поля сообщения, если оно многострочное

  UNPACKED_EXT = '.txt';
  PACKED_EXT = '.pack';

type
{
    TLogRecord = record
        _MessTime : TDateTime;
        _GlobComment : string[100];  // глобальный комментарий(процедура)
        _Comment : string[100];      // локальный комментарий имено к этой записи, будет приклеен к глобальному
        _Level : integer;            // уровень вложенности процедуры(комментария)
        _MessType : integer;         // тип (цвет) строки лога
        _Text : string;              // содержимое строки лога
        _Index : integer;            // для привязки к компоненту вывода лога(lbLog) для фильтрации по типам
    end;
}
    TLogManager = class
        SavePath: string;

        procedure Init;
        procedure Comment(PName: string); // Устанавливает комментарий (имя раздела/операции) для последующих сообщений в логе
        procedure CommentExit;               // Возвращается к предыдущему комментарию в стеке для последующих сообщений в логе
        function Mess(atext: string; comment: string = ''): string;   // обычное сообщение в лог
        function Warning(atext: string; comment: string = ''): string;  // сообщение-предупреждение в лог
        function Error(atext: string; comment: string = ''): string;  // сообщение об ошибке в лог
        function Query(atext: string; comment: string = ''): string;  // сообщение c sql-строкой в лог
        function RowCount: integer;
        function GetRow(index: integer): TLogRecord;
        procedure Clear;

        function SaveToFile: string;  // выгружает массив с текущим логом в файл и возвращает полный путь до него
        function LoadFromFileEx(filename: string; var targetArr: TLogArray): boolean;
        function LoadFromFile(filename: string): boolean;
    private

        LogArr: TLogArray; // массив сообщений лога
        CommArr: Array of String;    // массив
        curComment: integer;         // индекс текущей активной процедуры(комментария)

        function toLog(mess_type: integer; atext: string; comm: string = ''): TLogRecord;
    end;

implementation

uses  uPhenixCORE;

function TLogManager.toLog(mess_type: integer; atext: string; comm: string = ''): TLogRecord;
begin

    SetLength(LogArr, Length(LogArr)+1);
    With LogArr[High(LogArr)] do
    begin
        _MessTime := Now;
        _GlobComment := CommArr[curComment];
        _Comment := comm;
        _Level := curComment;
        _MessType := mess_type;
        _Text     := atext;
        _Index    := High(LogArr);
    end;

    result := LogArr[High(LogArr)];

end;

procedure TLogManager.Comment(PName: string);
{ добавление в стек процедур нового комментария и переход в нее }
begin
    Inc(curComment);

    if curComment > High(CommArr) then
    begin
        SetLength(CommArr, Length(CommArr) + 1);
    end;

    CommArr[curComment] := Pname;
end;

procedure TLogManager.CommentExit;
{ возвращаемся к предыдущему комментарию в стеке }
begin
    Dec(curComment);
    if curComment < 0 then curComment := 0;
end;

procedure TLogManager.Clear;
begin
    SetLength( LogArr, 0 );
end;

function TLogManager.GetRow(index: integer): TLogRecord;
begin
    if ( index < 0 ) or ( index > High(LogArr) ) then exit;

    result := LogArr[index];

end;

function TLogManager.Mess(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_BLACK, atext, comment);
    result := atext;
end;

function TLogManager.Warning(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_YELLOW, atext, comment);
    result := atext;
end;

function TLogManager.RowCount: integer;
begin
    result := Length(LogArr);
end;

function TLogManager.SaveToFile: string;
{ сохраняем текущий лог в файл и возвращает путь до него }
var
   list: TStringList;
   i: integer;
   breaker,
   filename,
   text: string;
   LInput, LOutput: TFileStream;
   LZip: TZCompressionStream;

   function PackStrings(text: string): string;
   var
       j: integer;
       breaker : string;
   begin

       list.Text := text;
       breaker := '';
       result := '';
       for j := 0 to list.Count -1 do
       begin
          result := result + breaker + list[j];
          breaker := LINE_BREAKER;
       end;

   end;

begin
    result := '';
    text := '';
    breaker := '';

    if Length(LogArr) = 0 then exit;

    if SavePath = '' then
    begin
        lE('Не указан путь для сохранения лог-файлов. Выгрузка невозможна.');
        exit;
    end;

    filename := Core.User.WinLogin + '('+FormatDateTime('d/m/y h/n', Now)+')';
    list := TStringList.Create;

    for I := 0 to High(LogArr) do
    begin
        text := text + breaker +
            DateTimeToStr(LogArr[i]._MessTime)    + FIELD_BREAKER +
//            PackStrings  (LogArr[i]._GlobComment) + FIELD_BREAKER +
//            PackStrings  (LogArr[i]._Comment)     + FIELD_BREAKER +
            LogArr[i]._GlobComment + FIELD_BREAKER +
            LogArr[i]._Comment     + FIELD_BREAKER +
            IntToStr     (LogArr[i]._Level)       + FIELD_BREAKER +
            IntToStr     (LogArr[i]._MessType)    + FIELD_BREAKER +
            PackStrings  (LogArr[i]._Text)        {+ FIELD_BREAKER};
        breaker := ELEM_BREAKER;
    end;

    list.Free;

    // пишем полный лог в файл
    LOutput:= TFileStream.Create(SavePath + filename + UNPACKED_EXT, fmCreate);
    try
        LOutput.WriteBuffer(Pointer(text)^, Length(text)*2);   // текст будет писаться в UNICODE, где по 2 байта на символ
    finally
        LOutput.Free;
    end;

    // создаем архивированный лог
    try
        LInput := TFileStream.Create(SavePath + filename + UNPACKED_EXT, fmOpenRead);
        LOutput := TFileStream.Create(SavePath + filename + PACKED_EXT, fmCreate);
        LZip := TZCompressionStream.Create(clDefault, LOutput);

        LZip.CopyFrom(LInput, LInput.Size);

    finally
        LZip.Free;
        LInput.Free;
        LOutput.Free;
    end;

    DeleteFile( SavePath + filename + UNPACKED_EXT );

    if FileExists(SavePath + filename + PACKED_EXT) then
        result := SavePath + filename + PACKED_EXT;
end;

function TLogManager.LoadFromFileEx(filename: string; var targetArr: TLogArray): boolean;
var
  LInput, LOutput: TFileStream;
  LUnZip: TZDecompressionStream;
  existFileName,
  text: string;
  LBuff: TArray<Byte>;
  list, elem: TStringList;
  i: integer;

begin

    lC('LogManager.LoadFromFileEx');

    result := false;

    lM('Загружаем лог-файл "'+filename+'"');

    // проверяем, не передано ли полное имя файла
    if FileExists(filename)                         then existFileName := filename;
    if FileExists(filename + PACKED_EXT)            then existFileName := filename + PACKED_EXT;
    if FileExists(SavePath + filename)              then existFileName := SavePath + filename;
    if FileExists(SavePath + filename + PACKED_EXT) then existFileName := SavePath + filename + PACKED_EXT;

    if filename = '' then
    begin
        lE('Не указано имя лог-файла. Загрузка невозможна');
        lCE;
        exit;
    end;

    if existFileName = '' then
    begin
        lE('Файл "'+filename+'" не обнаружен. Загрузка невозможна.');
        lCE;
        exit;
    end;

    // распаковываем лог
    try
    try
        LInput := TFileStream.Create(existFileName, fmOpenRead);
        LOutput := TFileStream.Create(ChangeFileExt(existFileName, UNPACKED_EXT), fmCreate);
        LUnZip := TZDecompressionStream.Create(LInput);

        LOutput.CopyFrom(LUnZip, 0);
    finally
        LUnZip.Free;
        LInput.Free;
        LOutput.Free;
    end;
    except
        on E: Exception do
        begin
           lE('Ошибка распаковки лога:' + sLineBreak + E.Message );
           lCE;
           exit;
        end;
    end;

    // читаем распакованный лог в переменную
    try
    LInput:= TFileStream.Create(ChangeFileExt(existFileName, UNPACKED_EXT), fmOpenRead);
    try
        SetLength(LBuff, LInput.Size);
        LInput.ReadBuffer(LBuff[0], Length(LBuff));
        text := TEncoding.Unicode.GetString(LBuff);
    finally
        LOutput.Free;
    end;
    except
        on E: Exception do
        begin
           lE('Ошибка распаковки лога:' + sLineBreak + E.Message );
           lCE;
           exit;
        end;
    end;

    if text = '' then
    begin
        lE('Файл пуст или поврежден.');
        lCE;
        exit;
    end;


    // чистим файл распакованного лога
    if FileExists(ChangeFileExt(existFileName, UNPACKED_EXT)) then
       DeleteFile(ChangeFileExt(existFileName, UNPACKED_EXT));


    // разбиваем полученную строку на элементы и заполняем массив лога
    try
        list := TStringList.Create;
        elem := TStringList.Create;

        SetLength(targetArr, 0);
        list.Text := StringReplace(text, ELEM_BREAKER, sLineBreak, [ rfReplaceAll ] );
        for i := 0 to list.Count - 1 do
        begin
            // разбиваем данные одного элемента на поля и заполняем элемент массива
            SetLength(targetArr, Length(targetArr)+1);
            elem.Text := StringReplace(list[i], FIELD_BREAKER, sLineBreak, [ rfReplaceAll ] );

            // перед получение данных поля проверяем, достаточно ли данных для него в полученных из файла
            // (это может быть устаревшая или не корректная версия лога)
            if elem.Count >= 1 then targetArr[High(targetArr)]._MessTime    := StrToDateTimeDef(elem[0], Now);
            if elem.Count >= 2 then targetArr[High(targetArr)]._GlobComment := StringReplace(elem[1], LINE_BREAKER, sLineBreak, [ rfReplaceAll ] );
            if elem.Count >= 3 then targetArr[High(targetArr)]._Comment     := StringReplace(elem[2], LINE_BREAKER, sLineBreak, [ rfReplaceAll ] );
            if elem.Count >= 4 then targetArr[High(targetArr)]._Level       := StrToIntDef(elem[3], 0);
            if elem.Count >= 5 then targetArr[High(targetArr)]._MessType    := StrToIntDef(elem[4], 0);
            if elem.Count >= 6 then targetArr[High(targetArr)]._Text        := StringReplace(elem[5], LINE_BREAKER, sLineBreak, [ rfReplaceAll ] );
        end;
    finally
        list.Free;
        elem.Free;
    end;

    result := true;
    lCE;

end;

function TLogManager.Error(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_RED, atext, comment);
    result := atext;
end;

procedure TLogManager.Init;
begin
    curComment := 0;
    SetLength( CommArr, 1 );
    CommArr[ curComment ] := '';
end;

function TLogManager.LoadFromFile(filename: string): boolean;
begin
    LoadFromFileEx(filename, LogArr);
end;

function TLogManager.Query(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_BLUE, atext, comment);
    result := atext;
end;

end.
