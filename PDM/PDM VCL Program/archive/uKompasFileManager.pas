unit uKompasFileManager;

interface

uses
    ksTLB, ksConstTLB, LDefin2D,  // модули Компас

    ComObj, SysUtils, Math, RegularExpressions, StrUtils;

const

    // синонимы колонок в массиве SpecDataArray
    FIELD_KIND   =  0;          // тип объекта (деталь, сборка,.. )
    FIELD_MARK   =  1;          // обозначение объекта (например, 'НПС5.01.02.120В зав.7774')
    FIELD_NAME   =  2;          // наименование объекта (например, 'Устройство отборное')
    FIELD_ISP    =  3;          // полное наименование исполнения которому принадлежит (например, 'ТК-01-58.000-16')
    FIELD_COUNT  =  4;          // количество в исполнении
    FIELD_COMM   =  5;          // комментарий
    FIELD_MASS   =  6;          // масса
    FIELD_MAT    =  7;          // материал, указанный в файле спецификации
    FIELD_NUMBER =  8;          // внутрифайловый id
    FIELD_CHILD  =  9;          // персональный внутренний id для формирования дерева. файловый не годится из-за непомерной величины
    FIELD_PARENT = 10;          // ссылка на FIELD_CHILD предка для формирования дерева вложенности
    FIELD_ID     = 11;          // реальный id объекта в базе, если есть.
                                // отвечает за то, чтобы визуализировать в дереве наличие объектов в базе
                                // и не дублировать имеющееся при загрузке структуры в базу
    FIELD_FILE   = 12;          // привязанный к объекту файл, если обнаружен.
                                // например, чертеж детали. если есть несколько - строка имен через точку с запятой
    FIELD_SPEC_FILE = 13;       // имя файла привязанной спецификации, если есть
    FIELD_MATERIAL  = 14;       // материал, указанный в привязанном файле чертежа

    // режимы состояния загрузки спецификации
    STATE_NOT_LOADED = 1;    // не загружена
    STATE_LOADING    = 2;    // загрузка в процессе
    STATE_LOADED     = 3;    // загрузка завершена

    // синонимы номеров полей с полезными данным в записи штампа файла КОмпас
    STAMP_NAME_FIELD     = 1;
    STAMP_MARK_FIELD     = 2;
    STAMP_MATERIAL_FIELD = 3;
    STAMP_MASS_FIELD     = 5;

    // режимы перемещения даных из справочника в таблицу с загруженной спецификацией
    DND_MODE_NULL         = 0;        // нет корректных данных для переноса
    DND_MODE_ADD_MATERIAL = 1;        // перенос материала на деталь

    BUFF_FIELD_VALUE = 0;
    BUFF_KIND        = 1;
    BUFF_BD_VALUE    = 2;

type

    TStampData = record
        Name
       ,Mark
       ,Material
       ,Mass
                : shortstring;
    end;

    TSpecDataArrayRow = array [0..14] of variant;
    /// элемент массива SpecDataArray, хранящий данные одного объекта из спецификации

    TBuffRow = array [0..2] of string;

    TKompasManager = class
      private
        Kompas: KompasObject;

        SpecDataArray: array of TSpecDataArrayRow;
        ///    массив данных, загруженных из файла спецификации.
        ///    содержит откорректированные данные, готовые для дальнейшей обработки:
        ///    корректировки имен, создания объектов в базе, построения структуры
        ///    назначение полей описывают константы FIELD_XXX
        ///
        ///    это сборный массив, содержащий данные как основной спецификации, так
        ///    и данные спецификаций вложенных объектов (сборочных единиц, комплексов, комплектов),
        ///    если есть

        FindBuff : array of TBuffRow;
        // буфер для оптимизации механизма расстановки признаков наличия загружаемых
        // позиций в базе. хранит результаты запрсов до очистки. перед попыткой обращения
        // к базе, сначала перебирается этот массив

        GlobID: integer;
        ///    счетчик для раздачи локальных id всем загружаемым
        ///    записям из файлов. используется для построения дерева вложенности
        ///    сборочных единиц, спецификаций, исполнений и их состава

        function GetId: variant;
        function GetKind( name: string ): string;
        ///    по имени типа раздела из спецификации получаем номер типа из базы
        ///    на самом деле проставлено руками. требуется, чтобы совпадало с данными
        ///    таблицы objec_classificator
        function FindObject( mark, name, kind: string): integer;
        function ReadSpecStamp( stamp : ksStamp; col: integer ): string;

        function ReadStamp( stamp: ksStamp ): TStampData;

      public
        CurrElem: integer;

        procedure CleanUp;
        function StartKompas( show: boolean ): boolean;
        procedure StopKompas;

        // открываваем
        function OpenSpecification( filename: string ): ksSpcDocument;
        function OpenDocument2D( filename: string ): ksDocument2D;

        function CloseSpecification( var SpcDocument: ksSpcDocument ): boolean;
        function CloseDocument2D( var Document2D: ksDocument2D ): boolean;

        function GetSpecificationStampData( SpcDocument: ksSpcDocument ): TStampData; overload;
        function GetSpecificationStampData( filename: string ): TStampData; overload;

        function GetDocument2DStampData( Document2D: ksDocument2D ): TStampData; overload;
        function GetDocument2DStampData( filename: string ): TStampData; overload;

        function ReadSpecificationToArray(filename: string): boolean;

    end;

var
    mngKompas : TKompasManager;

implementation

uses
    uPhenixCORE, uMain;

procedure TKompasManager.CleanUp;
begin
    SetLength( SpecDataArray, 0 );
    SetLength( FindBuff, 0 );
end;

function TKompasManager.ReadSpecificationToArray(filename: string): boolean;
var
    SpcDocument: ksSpcDocument;
    Specification : ksSpecification;
    SpcTuningStyleParam : ksSpcTuningStyleParam;
    DynamicArray: ksDynamicArray;
    DocAttachedSpcParam: ksDocAttachedSpcParam;
    stamp : TStampData;


    SpcObjParam: ksSpcObjParam;

    iterator: ksIterator;            // курсор для перебора элементов в спецификации
    item: integer;                   // текущий выбранный элемент в списке спецификации

    str, str2, comma : string;
    value : integer;
    block, isp: integer;

    ispNames: array of string;       // массив имен всех исполнений
    ispCount: integer;               // количество исполнений в последнем блоке
    ispFullCount: integer;           // количество исполнений в последнем блоке
    ispBlockCount: integer;          // количество блоков исполнений
    ///    в спецификации лист имеет физические размеры и при большом количестве
    ///    исполнений (10 и более) они не помещаются на лист и переностяся
    ///    ниже по документу. данный перенос называется блоком спецификации.
    ///    т.е. первые 10 образуют первый блок, 11-20 второй и т.д.
    ///    по сути, это структура двухмерного массива

    I
            : Integer;

    ///    переменные для разового запоминания при переходе на новую позицию в спецификации.
    ///    посколку, в дальнейших записях, касющихся количества позиции в различных исполнениях (если есть)
    ///    большинство полей пусты, для единообразия массива, и его удобной
    ///    дальнейшей обработки, актуальные данные подставляются в каждую строку
    kind
   ,mark
   ,name
   ,note
   ,mass
   ,mat
   ,number
   ,material
   ,lastNumber
   ,lastMark
   ,lastName
   ,lastFilePath
   ,filePath       // имя привязанного файла (чертеж или прочее)
   ,specFilePath   // имя привязанной спецификации (spw файл)
   ,SpecBaseMark
   ,WorkDir
   ,lastBaseMark   // обозначение первого элемента в списке с одинаковым номером (number)
                   // который содержит базовое обозначение без префиксов исполнений.
                   // применяется в корректной приваязке файлов для исполнений, ориентируясь
                   // на базовое обозначение
            : string;

    function GetIspolNames: integer;
    ///    заполняем массив именами исполнений и возвращаем их количество.
    var
        isp, block : integer;
        name : string;
    begin

        // получаем количество блоков исполнений
        ispBlockCount := 0;
        name := specification.ksGetSpcPerformanceName( 0, 1, ispBlockCount );
        while name <> '' do
        begin
            Inc( ispBlockCount );
            name := specification.ksGetSpcPerformanceName( 0, 1, ispBlockCount );
        end;


        ispCount := 0;
        ispFullCount := 0;

        // перебираем все имеющиеся блоки
        for block := 0 to ispBlockCount-1 do
        begin

            // пытаемся получить первый элемент
            isp := 1;
            name := specification.ksGetSpcPerformanceName( 0, isp, block );

            // и перебираем все остальные если есть
            while name <> '' do
            begin

                // после прохождения одного блока, получим его максимальную размерность
                ispFullCount := Max( ispFullCount, isp );

                // дополняем массив имен исполнений
                SetLength( ispNames, Length( ispNames ) + 1 );
                ispNames[ High(ispNames) ] := name;

                // пытаемся получить имя следующего в блоке
                inc(isp);
                name := specification.ksGetSpcPerformanceName( 0, isp, block );

            end;
        end;

        // запоминаем количество элементов в последнем/единственном блоке
        ispCount := isp - 1;

        result := Length( ispNames );

    end;

    procedure CorrectionIspolNames(basename: string = '');
    ///    подправляем имена для дальнейшего использования
    ///    требуется убрать все символы кроме цифр и добить
    ///    значения нулем, если номер из одной цифры.
    ///    таким образом, получим рад:
    ///    [пусто], 01, 02, 03,..
    ///    если basename не пустое, то к нему будут приклеиваться нумерация,
    ///    образуя полное наименования исполнения
    var
        i : integer;
        reg: TRegEx;
        maches : TMatchCollection;
    begin

        // создаем регулярку, ищущую любое сочетание цифр, идущих подряд
        reg:=TRegEx.Create('\d+');

        for i := 0 to High( ispNames ) do
        begin

            // получаем из текущего имени числовую часть, отсекая все остальное
            maches := reg.Matches( ispNames[i] );

            // если найдено, присваиваем элементу списка с приклеиванием нуля, если необходимо
            // иначе, это первый элемент в списке исполнений, не имеющий номера
            if maches.Count > 0
            then ispNames[i] := basename + '-' + ifthen( Length(maches[0].Value) <> 1, maches[0].Value, '0' + maches[0].Value )
            else ispNames[i] := basename;

        end;
    end;

    function ClearMacros(text : string): string;
    begin
        result := text;
        result := ReplaceStr( result, '@/', ' ');  // убираем внутренний макрос Компаса на перенос строки
        result := ReplaceStr( result, '$d', '');   // убираем внутренний макрос Компаса на отображение в виде формулы
        result := ReplaceStr( result, '@1~', '');  // убираем внутренний макрос
        result := ReplaceStr( result, '@2~', '');  // убираем внутренний макрос
    end;

    function trimFull( text: string ): string;
    /// обрезает все пробелы и все повторы внутри строки, оставляя только единичные пробелы
    begin
        result := trim( text );
        while pos('  ', result) > 0 do
           result := replaceStr( result, '  ', ' ' );
    end;

    function GetParentByIsp( IspName: string ): integer;
    ///    объект из спецификации должен быть привязан к исполнению, исходя
    ///    из из того, данные для какого исполнения содержит
    var
        i : integer;
    begin
        result := 0;
        for I := High( SpecDataArray ) downto 0 do
        if ( SpecDataArray[i][FIELD_MARK] = IspName ) and
           ( SpecDataArray[i][FIELD_KIND] = 'Исполнение' ) then
        begin
            result := SpecDataArray[i][FIELD_CHILD];
            break;
        end;
    end;

    function GetConnectedFile(mark, name, ext: string): string;
    ///    пытаемся найти привязанный к позиции специцикации файл.
    ///    приоритет поиска:
    ///      - привязка в файле спецификации к самому объекту
    ///          (например, он был не забит руками, а прикреплен файлом)
    ///      - файл с именем, совпадающим с обозначением в папке со спецификацией
    ///          (поддержка непрямого включения файлов. достаточно просто свалить все в кучу при импорте)
    var
        SR: TSearchRec; // поисковая переменная
        i: integer;
    begin
        result := '';

        SpcObjParam :=  ksSpcObjParam( kompas.GetParamStruct(ko_SpcObjParam) );
        SpcDocument.ksGetObjParam( item, SpcObjParam, ALLPARAM );
        DynamicArray := ksDynamicArray(SpcObjParam.GetDocArr);

        DocAttachedSpcParam  := ksDocAttachedSpcParam(kompas.GetParamStruct(ko_DocAttachSpcParam));

        if DynamicArray.ksGetArrayCount<>0 then
        begin
            for i := 0 to DynamicArray.ksGetArrayCount - 1 do
            begin
                DynamicArray.ksGetArrayItem(i, DocAttachedSpcParam);
                result := DocAttachedSpcParam.fileName;
            end;
        end;

{        if result = '' then
        begin
            // перебираем список файлов компаса в папке с загружаемой спецификацией
            for I := 0 to High(NearFiles) do
            // файл относится к текущему элементу спецификации?
            if NearFiles[i][NEAR_MARK] = mark then
            // если ищем любой файл, кроме спецификации - пропускаем этот файл
            if   (ext = '*') and ( ExtractFileExt( NearFiles[i][NEAR_FILENAME] ) = '.spw' )
            then continue
            else result := NearFiles[i][NEAR_FILENAME];
        end;
}    end;

    function AddSpecRow(kind, mark, name: string; parent: integer = 0): integer;
    /// добавление в массив загруженных данных основной спецификации или исполнений
    begin

        SetLength( SpecDataArray, Length( SpecDataArray ) + 1 );

        SpecDataArray[High( SpecDataArray )][FIELD_KIND]   := trimFull( kind );
        SpecDataArray[High( SpecDataArray )][FIELD_MARK]   := trimFull( mark );
        SpecDataArray[High( SpecDataArray )][FIELD_NAME]   := trimFull( name );
        SpecDataArray[High( SpecDataArray )][FIELD_PARENT] := parent;
        SpecDataArray[High( SpecDataArray )][FIELD_CHILD]  := GetID;

        SpecDataArray[High( SpecDataArray )][FIELD_ISP]    := '';
        SpecDataArray[High( SpecDataArray )][FIELD_COUNT]  := '1';

        SpecDataArray[High( SpecDataArray )][FIELD_COMM]   := '';
        SpecDataArray[High( SpecDataArray )][FIELD_MASS]   := '0';
        SpecDataArray[High( SpecDataArray )][FIELD_MAT]    := '';
        SpecDataArray[High( SpecDataArray )][FIELD_NUMBER] := '';
        SpecDataArray[High( SpecDataArray )][FIELD_FILE]   := GetConnectedFile(mark, name, '*');
        SpecDataArray[High( SpecDataArray )][FIELD_SPEC_FILE] := ''; //filename;

        SpecDataArray[High( SpecDataArray )][FIELD_ID]     := FindObject( mark, name, trimFull( kind ) );


        result := SpecDataArray[High( SpecDataArray )][FIELD_CHILD];

        // проверить на наличие спецификации. при наличии, запомнить id и
        // перевести работу в режим создания проекта, а не прямого занесения в базу
        {!}

    end;

begin
    result := false;

    if not Assigned( Kompas ) then exit;
    if not FileExists( filename ) then exit;

    lM( 'Загрузка файла ' + filename );

    // получаем путь до файла спецификации, чтобы пытаться подтягивать файлы
    // для ее объектов оттуда, при отсутсвии прямого включения в самой спецификации
    WorkDir := ExtractFilePath( filename );

    // обнуляем ранее загруженные данные
    SpecBaseMark := '';

    // получаем интерфейс работы со спецификациями
    SpcDocument := ksSpcDocument( Kompas.SpcDocument );

    // открываем файл спецификации
    if not SpcDocument.ksOpenDocument( filename, 4 ) then exit;
    // 0 - видимый документ, 1 - невидимый документ, 3 - видимый без синхронизации со сборочным чертежом
    // 4 - невидимый без синхронизации со сборочным чертежом
    // полезный эффект при открытии в невидимом режиме - подавление различных окон с предупреждениями и вопросами.
    // например, в видимом режиме постоянно предлагается перестроить спецификацию и только после ответа на
    // вопрос управление возвращается в программу. в невидимом режиме все проходит гладко
    // и компас не перехватывает инициативу

    // получаем ссылку на саму спецификацию
    specification := ksSpecification( SpcDocument.GetSpecification );

     // создаем "курсор" для перебора объектов в текущй активной спецификации
    iterator := ksIterator( kompas.GetIterator() );
	iterator.ksCreateSpcIterator( '', 0, 0 );

    // если нечего перебирать (спецификация пуста), выходим
	if iterator.Reference = 0 then exit;

    // получаем первый элемент
    item := iterator.ksMoveIterator( 'F' );



    // инициализация массива

    // если id не указан, значит читаем корневую спецификацию и нужно добавить
    // ее в массив считанных данных для дальнейшей привязки элементов к ней как
    // корневому элементу.
    // значение выше нуля означает, что рекурсивно рассматривается спецификация
    // одного из вложенных в основную спецификацию объектов и привязка новых
    // строк данных будет уже к нему, а не корню дерева
    stamp := GetSpecificationStampData( SpcDocument );
    mark := Trim( stamp.Mark );
    name := Trim( stamp.Name );
    SpecBaseMark := mark;

    if   CurrElem = -1
    then CurrElem := AddSpecRow( 'Спецификация', mark, name );

    lM('Спецификация: ' + mark + ' ' + name );

    // получаем массив имен исполнений и их количество
    lM( 'Исполнений: ' + IntToStr( GetIspolNames ) );
    // корректируем имена, приводя к стандарту
    CorrectionIspolNames( SpecBaseMark );

    // добавляем пачку реализаций
    for I := 0 to High( ispNames ) do
    AddSpecRow( 'Исполнение', ispNames[i], name, CurrElem );





    ///    загрузка данных в массив для дальнейшей обработки.
    ///
    ///    особенность файла спецификации в том, что для получения данных по количеству
    ///    в нужной спецификации нужно для полученного объекта перебрать все данные
    ///    с указанием номера исполнения и блока исполнений.
    ///    т.е. полученный объект, по сути является массивом объектов по количеству
    ///    имеющихся исполнений
    ///
    ///    количестово блоков и их размерность определены при вызове GetIspolNames

    lastNumber := '';
    lastBaseMark := '';

    while SpcDocument.ksExistObj( item ) <> 0 do
    begin


        // получаем базовые параметры позиции для базового исполнения
        kind  := trimFull( specification.ksGetSpcSectionName( item ) );
        note  := trimFull( ClearMacros( specification.ksGetSpcObjectColumnText( item, SPC_CLM_NOTE,     1, 0 ) ) );
        mass  := trimFull( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MASSA,    1, 0 ) );
        mat   := trimFull( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MATERIAL, 1, 0 ) );



        ///    чехорда с mark вместо простого получения объясняется тем, что есть
        ///    два стандарта записи обозначения в спецификации:
        ///    1)
        ///        'ТК-01-58.004'
        ///        'ТК-01-58.004-05'
        ///    2)
        ///        'ТК-01-58.004'
        ///        '-05'
        ///    как видно, во втором случае используется сокращенная форма, не обязательная
        ///    к использованию. для ее определения и приведение данных в массиве к единообразию
        ///    (первой форме записи) и применяется данный говнокод.
        ///
        ///    внутренний id позиции (number) применяется для случая, когда имя совпадает при
        ///    разных mark.
        ///    например, в данном случае сочетания позиций (два разных типа балок идущих подряд):
        ///        ТК-01-58.001-09  Балка
        ///        ТК-01-58.002     Балка
        ///    без учета номера произойдет сбой именования и имена последующих
        ///    позиций начнут склеиваться в длинную портянку
        ///
        lastMark := mark;
        lastName := name;
        lastNumber := number;
        lastFilePath := filePath;

        // получаем внутренний id элемента в спецификации
        number := FloatToStr( specification.ksGetSpcObjectNumber( item ) );

        // если имя пустое (что бывает у исполнения), берем имя предыдущего
        name := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ), name);
        name := trimFull( ClearMacros( name ) );

        // для исполнений не указано обозначение. берем его из последнего встреченного базового исполнения
        mark := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ), mark);
        mark := trimFull( mark );

        ///    сокращенная форма будет короче, при том же имени и позиции спецификации
        ///    "та же позиция" означает, что в корректной спецификации все варианты какого-то объекта
        ///    с префиксом '-ХХ' идут под тем же номером позиции в списке, т.е. тем же number
        ///    например:
        ///        6  ТК-01-58.002     Балка
        ///           ТК-01-58.002-01  Балка
        ///           ТК-01-58.002-02  Балка
        ///    если в документе для всех объектов показать позицию, то все они имеют 6 номер
        if   (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( number = lastNumber ))
        then mark := lastMark + mark

        else
        ///    обработка некорректно составленной спецификации с сокращенными обозначениями
        ///    и некорректной расстановкой позиций. так же под этот случай попадает вариант,
        ///    когда позиция выставлена верная, но внутренний number не совпадает
        ///    например:
        ///        6  ТК-01-58.002  Балка
        ///        7           -01  Балка
        ///        8           -02  Балка
        if   (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( pos('-', mark) = 1 ))
        then
        begin
            // из-за невозможности просто отследить исходное обозначение, будем восстанавливать его
            // имеющегося на данный момент. если есть "-ХХ" часть, обрезаем ее для подстановки следующей
            if Pos('-', lastMark) <> 0
            then lastMark := Copy( lastMark, 0, Pos('-', lastMark)-1);

            mark := lastMark + mark;
        end;

        // для стандартных и прочих изделий обозначение не используется в принципе.
        // будем очищать мусор от обработки позиций выше по документу
        if  ( kind = 'Стандартные изделия' ) or ( kind = 'Прочие изделия' ) or ( kind = 'Материалы' )
        then mark := '';

        if number <> lastNumber then
        begin
            lastBaseMark := specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 );

            // спецификация
            if ( kind = 'Сборочные единицы' ) then
                specFilePath := GetConnectedFile( lastBaseMark, name, 'spw' );
            // любой другой, кроме спецификации
            if ( kind <> 'Материалы' ) then
                filePath := GetConnectedFile( lastBaseMark, name, '*' );

//            material := trimFull( ClearMacros( GetFromNearFile( lastBaseMark, NEAR_MATERIAL ) ) );

        end;


        // для текущего выбранного элемента перебираем все его исполнения
        for block := 0 to ispBlockCount - 1 do
        for isp := 1 to ispFullCount do
        if not ((block = ispBlockCount - 1) and (isp > ispCount)) then  // проверка за выход количества элементов в последнем блоке

        if specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT, isp, block ) <> '' then // отсекаем пустые исполнения

        begin

            SetLength( SpecDataArray, Length( SpecDataArray ) + 1 );

            SpecDataArray[High( SpecDataArray )][FIELD_KIND]  := kind;

            SpecDataArray[High( SpecDataArray )][FIELD_MARK]  := mark;
            SpecDataArray[High( SpecDataArray )][FIELD_NAME]  := name;

            SpecDataArray[High( SpecDataArray )][FIELD_ISP]   := ispNames[ block * ispFullCount + isp - 1 ];
            SpecDataArray[High( SpecDataArray )][FIELD_COUNT] := specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT,    isp, block );

            SpecDataArray[High( SpecDataArray )][FIELD_COMM]      := note;
            SpecDataArray[High( SpecDataArray )][FIELD_MASS]      := mass;
            SpecDataArray[High( SpecDataArray )][FIELD_MAT]       := mat;
            SpecDataArray[High( SpecDataArray )][FIELD_NUMBER]    := number;
            SpecDataArray[High( SpecDataArray )][FIELD_FILE]      := filePath;
            SpecDataArray[High( SpecDataArray )][FIELD_SPEC_FILE] := SpecfilePath;

            SpecDataArray[High( SpecDataArray )][FIELD_PARENT]   := GetParentByIsp( ispNames[ block * ispFullCount + isp - 1 ] );
            SpecDataArray[High( SpecDataArray )][FIELD_CHILD]    := GetID;
            SpecDataArray[High( SpecDataArray )][FIELD_ID]       := FindObject( mark, name, kind ); // mngData.GetObjectBY( 'mark', mark )
            SpecDataArray[High( SpecDataArray )][FIELD_MATERIAL] := material;
            // пытаемся найти объект в актуальной базе, чтобы избежать дублирования при загрузке

        end;

        // получаем следующий элемент в списке спецификации
        item := iterator.ksMoveIterator( 'N' );

    end;


    // показ загруженных данных в логе
    for I := 0 to High(SpecDataArray) do

        Core.Log.Mess(
            '(' + SpecDataArray[i][FIELD_NUMBER] + ') ' +
            SpecDataArray[i][FIELD_KIND] + ' / ' +
            SpecDataArray[i][FIELD_MARK] + ' / ' +
            SpecDataArray[i][FIELD_NAME] + ' / ' +
            SpecDataArray[i][FIELD_ISP] + ' / ' +
            SpecDataArray[i][FIELD_COUNT] + ' / ' +
            SpecDataArray[i][FIELD_COMM] + ' / ' +
            SpecDataArray[i][FIELD_MASS] + ' / ' +
            SpecDataArray[i][FIELD_MAT] + ' / ' +
            SpecDataArray[i][FIELD_MATERIAL]
        );


    result := true;
end;


function TKompasManager.StartKompas( show: boolean ): boolean;
begin
    result := false;

    Kompas := KompasObject( CreateOleObject('Kompas.Application.5') );

    if Assigned( Kompas ) then
    begin
        /// запускаем компас в открытую, поскольку перед загрузкой спецификации
        /// проводится сканирование папки и получение данных всех обнаруженных
        /// файлов компас. при этом, часто возникают ошибки, вызывающие окошки
        /// для выбора действий. при скрытом компасе складывыается ощущение, что
        /// программа наглухо зависла.
        Kompas.Visible := show;
        result := true;
    end;

end;

procedure TKompasManager.StopKompas;
begin
    // компас больше не нужен
    Kompas.Quit;
    Kompas:=nil;
end;

function TKompasManager.ReadSpecStamp( stamp : ksStamp; col: integer ): string;
///    взято без изменений из Ведомости покупных
///    получаем из указанно поля штампа данные документа
var
    da, dai: ksDynamicArray;
    i, j, k, l: integer;
    tlp: ksTextLineParam;
    tip: ksTextItemParam;
    s: string;
begin

if ( stamp.ksOpenStamp <> 0 ) then
  begin
    stamp.ksColumnNumber( col );

    da:=ksDynamicArray( stamp.ksGetStampColumnText( col ) );

    //---Преобразовать массив строк в одну строку s---
    if ((da<>nil) and (Kompas<>nil)) then
      begin
        i:=da.ksGetArrayCount; //showmessage(inttostr(i));
        tlp:=ksTextLineParam(Kompas.GetParamStruct(ko_TextLineParam));
        tip:=ksTextItemParam(Kompas.GetParamStruct(ko_TextItemParam));
        for j := 0 to i - 1 do
        begin
          da.ksGetArrayItem(j,tlp);
          dai:=ksDynamicArray(tlp.GetTextItemArr);
          k:=dai.ksGetArrayCount;
          for l := 0 to k - 1 do
          begin
            dai.ksGetArrayItem(l,tip);
            if tip.iSNumb=0 then s:=s+' '+trim(tip.s)
            else s:=s+' @'+IntToStr(tip.iSNumb)+'~';
          end;
        end;
      end;
      //---Показать строку s на экране---
    Result:=s;

     //---закрыть штамп---
    stamp.ksCloseStamp;
  end;

end;


function TKompasManager.GetId: variant;
begin
    Inc( GlobId );
    Result := GlobId;
end;

function TKompasManager.GetKind( name: string ): string;
begin
    result := '0';
    if name = 'Спецификация'        then result := '10';
    if name = 'Исполнение'          then result := '11';
    if name = 'Документация'        then result := '12';
    if name = 'Сборочные единицы'   then result := '7';
    if name = 'Детали'              then result := '4';
    if name = 'Стандартные изделия' then result := '5';
    if name = 'Прочие изделия'      then result := '6';
    if name = 'Материалы'           then result := '3';
end;

function TKompasManager.GetSpecificationStampData(filename: string): TStampData;
var
    SpcDocument: ksSpcDocument;
begin
    if not FileExists( filename ) then exit;

    SpcDocument := OpenSpecification( filename );

    if not Assigned( SpcDocument ) then exit;

    result := GetSpecificationStampData( SpcDocument );

    CloseSpecification( SpcDocument );
end;

function TKompasManager.GetSpecificationStampData(
  SpcDocument: ksSpcDocument): TStampData;
begin
    result := ReadStamp( ksStamp( SpcDocument.GetStampEx(0) ) );
end;

function TKompasManager.GetDocument2DStampData(
  Document2D: ksDocument2D): TStampData;
begin
    result := ReadStamp( ksStamp( Document2D.GetStampEx(0) ) );
end;

function TKompasManager.GetDocument2DStampData(filename: string): TStampData;
var
    Document2D: ksDocument2D;
begin
    if not FileExists( filename ) then exit;

    Document2D := OpenDocument2D( filename );

    if not Assigned( Document2D ) then exit;

    result := GetDocument2DStampData( Document2D );

    CloseDocument2D( Document2D );
end;

function TKompasManager.ReadStamp(stamp: ksStamp): TStampData;
begin
    if not Assigned(stamp) then exit;

    result.Name     := Trim( ReadSpecStamp( stamp, STAMP_NAME_FIELD ) );
    result.mark     := Trim( ReadSpecStamp( stamp, STAMP_MARK_FIELD ) );
    result.material := Trim( ReadSpecStamp( stamp, STAMP_MATERIAL_FIELD ) );
    result.mass     := Trim( ReadSpecStamp( stamp, STAMP_MASS_FIELD ) );
end;

function TKompasManager.CloseDocument2D(var Document2D: ksDocument2D): boolean;
begin
    if Assigned(Document2D) then Document2D.ksCloseDocument;
end;

function TKompasManager.CloseSpecification(var SpcDocument: ksSpcDocument): boolean;
begin
    if Assigned(SpcDocument) then SpcDocument.ksCloseDocument;
end;

function TKompasManager.OpenDocument2D(filename: string): ksDocument2D;
begin
    result := nil;

    if not Assigned( Kompas ) then exit;

    result := ksDocument2D( Kompas.Document2D );
    if   not result.ksOpenDocument( filename, true )
    then result := nil;
end;

function TKompasManager.OpenSpecification(filename: string): ksSpcDocument;
begin
    result := nil;

    if not Assigned( Kompas ) then exit;

    result := ksSpcDocument( Kompas.SpcDocument );
    if   not result.ksOpenDocument( filename, 4 {скрыто, с подавлением сообщений} )
    then result := nil;
end;

function TKompasManager.FindObject( mark, name, kind: string): integer;
/// проверяем наличие в базе объекта по обозначению и имени

    function getObjectID(field, value: string): integer;
    var
        i : integer;
    begin
         result := -1;

         for i := 0 to high(FindBuff) do
         if   FindBuff[i][BUFF_FIELD_VALUE] = trim( value ) then
         if   FindBuff[i][BUFF_KIND] = kind then
         begin
             result := StrToInt( FindBuff[i][BUFF_BD_VALUE] );
             break;
         end;

         if result = -1 then
         begin
             result := mngData.GetObjectBY( field, Trim( value ), kind );

             if result <> 0 then
             begin
                 SetLength(FindBuff, Length(FindBuff)+1);
                 FindBuff[high(FindBuff)][BUFF_FIELD_VALUE] := value;
                 FindBuff[high(FindBuff)][BUFF_KIND] := kind;
                 FindBuff[high(FindBuff)][BUFF_BD_VALUE] := IntToStr( result );
             end;
         end;
    end;

begin
    result := 0;

    // преобразуем текстовый тип в числовой, если необходимо
    if   length(kind) > 2
    then kind := GetKind( kind );

    if Trim( mark ) <> ''
    then result := getObjectID('mark', mark)
    else result := getObjectID('name', name);
end;

initialization

    mngKompas := TKompasManager.Create;

finalization

    mngKompas.Free;

end.
