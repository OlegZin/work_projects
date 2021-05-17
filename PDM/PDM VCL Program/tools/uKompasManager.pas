unit uKompasManager;

////////////////////////////////////////////////////////////////////////////////
///
///  Модуль работы со Спецификациями и Чертежами компас без загрузки самого
///  компаса.
///
///  Открывает файлы как архив и извлекая файл MetaInfo читает данные файла.
///
///  Алгоритм работы
///  - через sTempPath указывается папка для извлечения xml из архива
///  - через Init загружается xml основной спецификации, при этом сканируется
///    папка расположения и все подпапки на наличие файлов Компас с получением их
///    основных данных
///  - вызовом LoadSpecification(0) в рабочий массив из текущей xml загружаются данные
///  - перебором загруженного массива ищутся сборочные единицы для которых через
///    LoadSpecification(X, Y) подгружается состав, при наличии файла спецификации
///  - в рамках того же перебора ищутся детали для которых из массива ранее отсканированных
///    файлов извлекается информация о материале и др.
///  - полученный массив выгружается в указанный датасет методом UploadToDataset(dataset)
///
///  благодаря заранее присвоенным значениям child и parent, данные автоматически
///  выстраиваются в дерево в настроенном DBGridEh, привязанном к датасету
///
///  работа с XML:
///  http://streletzcoder.ru/byistro-i-legko-razbor-parsing-xml-dokumentov-s-pomoshhyu-txmldocument/
///
////////////////////////////////////////////////////////////////////////////////

interface

uses
    System.ZIP, FileCtrl, SysUtils, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, StrUtils,
    System.Classes, System.IOUtils, System.Types, DB, math, StdCtrls, MemTableEh,
    RegularExpressions, IniFiles;

const
    DEF_META_FILE         = 'MetaInfo';         // xml с описанием состава спецификации или чертежа
    DEF_META_PRODUCT_FILE = 'MetaProductInfo';  // xml c общими данными проекта (штамп) и данными всех документов(?)
    DEF_INFO_FILE         = 'FileInfo';         // ini c парамтерами версии файла


    /// массив сопоставления имен полей данных штампа для различных версий
    /// КОМПАС. константы FIELD_XXX - первый индекс для массива FIELDS.
    /// текущая версия - второй индекс (одно из значений VERSION_XXX)

    // идентификаторы полей штампа
    FIELD_MARK     = 0;        // полное обозначение со всеми примисями типа 'СБ'
    FIELD_MARK_BASE = 6;        // обзначение без примесей
    FIELD_NAME     = 1;        // наименование
    FIELD_MASS     = 2;        // масса
    FIELD_MATERIAL = 3;        // материал (указывается в чертеже детали)
    FIELD_COMMENT  = 4;       // комментарий
    FIELD_KIND     = 5;       // тип файла: 'спецификация' / 'чертеж'

    VERSION_INDEX_17 = 0;
    VERSION_INDEX_18 = 1;

    FIELD_MARK_BASE_18 = 'base'; // основное значение mark
    FIELD_MARK_DELIM_18 = 'documentDelimiter';
    FIELD_MARK_NUMBER_18 = 'documentNumber';
    // 18 версии КОМПАС поле mark состоит из набора подполей
    // <property id="marking">
    //     <property id="base" value="ЭТМ2.02.03.100" type="string" />
    //     <property id="embodimentDelimiter" value="-" type="string" />
    //     <property id="embodimentNumber" value="" type="string" />
    //     <property id="additionalDelimiter" value="." type="string" />
    //     <property id="additionalNumber" value="" type="string" />
    //     <property id="documentDelimiter" value="" type="string" />
    //     <property id="documentNumber" value="" type="string" />
    // </property>

    /// массив сопоставления имен полей с соответствующими значениями в разных
    /// версиях файлов КОМПАС в xml фйлах
    FIELDS : array [0..6, 0..1] of string = (
        ('4','marking'), ('5','name'), ('8','mass'), ('9','materal'), ('13','comment'), ('14','kind'), ('4','marking_base'));

    /// значения поддерживаемых версий файлов из файла DEF_INFO_FILE
    VERSION_16 = '0x10001006';//'KOMPAS_16.1';
    VERSION_17 = '0x11001011';//'KOMPAS_17.1';
    VERSION_18 = '0x12001017';//'KOMPAS_18.1';

    FILE_TYPE_SPEC_ID = '5';
    FILE_TYPE_DRAW_ID = '1';

    FILE_TYPE_NONE = '';
    FILE_TYPE_SPEC = 'Спецификация';
    FILE_TYPE_DRAW = 'Чертеж';

type

    TArrayElem = record
        kind                     // основной тип (деталь, сборочная единица,..)
       ,subkind                  // подтип (спецификация/исполнение)
       ,mark                     // обозначение
       ,name                     // наименование
       ,count                    // количество
       ,mass                     // масса
       ,comment                  // комментарий
       ,material                 // материал (указывается только у деталей)
       ,linked_file              // привязанный файл (спецификация/чертеж)
       ,file_id                  // id объекта в файле спецификации
       ,part_id                  // привязка к справочнику материалов [nft].[dbo].[mat].imbase_key
                : string;

        child                    // вычисленный при импорте собственный id для построения дерева
       ,parent                   // вычисленный при импорте id родителя для построения дерева
       ,ispol                    // номер исполнения объекта (в дополненин к маркировке '-0Х' в mark
       ,bd_id                    // id в базе, если такой объект уже есть в проекте(минусовой id)
                                 // или в согласованной структуре(плюсовой id). позволяет не дублировать
                                 // записи в базе, а использовать уже существующие. при этом, минусовой
                                 // id имеет приоритет и будет перекрывать существующий в КД
       ,kd_id                    // устанавливается, если объект есть в КД. этот флаг позволяет
                                 // пропускать загрузку спецификаций для объектов с данным флагом.
                                 // это связано с тем, что проект не должен содержать вложенных
                                 // элементов нередактируемых объектов, чтобы не затирать данные КД
                                 // при выгрузке проекта в КД (что может привести к добавлению левых объектов
                                 // и связей, при подгрузке спецификации не совпадающей с фактическим набором
                                 // вложенных объектов)
                : integer;
    end;

    TFileElem = record
        path
       ,filename
       ,kind                     // 'Спецификация' или 'Чертеж'
       ,mark                     // строка типа '2019.22.00.000' с мусором типа 'СБ'
       ,mark_base                // чистая строка типа для стравнений с файлами чертежей, где мусора в обозначении нет
       ,name
       ,mass
       ,material
       ,comment
                : string;
    end;

    TBuffRow = record
        value              // по какому значению поля fieldName искали
       ,kind
                : string;
        bd_id              // id объекта в базе
       ,kd_id
                : integer;
    end;

    TKompasManager = class
      private
        fProjectID   // проект, в который будем загружать данные
                : integer;

        fTempPath    // папка для выгрузки файлов из архива
       ,fFilename    // имя последнего извлеченного файла из архива
       ,fArchivename // имя последнего открытого архива (файла компас)
       ,fMark        //
                : string;

        fId          // счетчик для раздачи fArray.child значений
                : integer;

        fDoc      // текущий открытый xml со структурой
       ,fProject  // текущий открытый xml с данными проекта
                : IXMLDocument;


        fRootNode         // корневой узел текущего открытого fDoc
       ,fProjectRootNode  // корневой узел текущего открытого fProject
                : IXMLNode;


        fLog : TMemo;
        // внешний компонент, куда выводится информация о прогрессе загрузки и
        // сообщения об ошибках

        fVersion: string;
        // версия текущего открытого файла. на данный момент поддерживаются 17 и 18 версии.
        // поддерживаемые версии в константах VERSION_XXX

        fFileType: string;
        // тип текущего рассматриваемого файла


        fArray  : array of TArrayElem;
        /// массив со всеми загруженными данными из спецификаций.
        /// загрузка спецификации подразумевает, что строится дерево спецификаций
        /// на основе корневой, выбранной для загрузки. после загрузки основной
        /// спецификации для всех элементов ищутся их собственные спецификации
        /// и подгружаются как их подуровни (опеределенного исполнения).
        /// дерево строися по полям child и parent, содержащих искуственный id,
        /// поскольку родной из xml слишком громоздкий

        fFileArray : array of TFileElem;
        /// содержит список файлов Компас с основными данными из текущей и всех
        /// вложенных папок.
        /// заполняется перед загрузкой спецификации и позволяет быстро найти файл
        /// привязанный к рассмативаемому элементу
        /// что позволяет быстро провести подгрузку спейификации элемента или
        /// получить данные детали

        fProcessed : array of String;
        /// массив id уже обработанных (загруженных из xml в рабочий массив) объектов

        fFindBuff : array of TBuffRow;
        // буфер для оптимизации механизма расстановки признаков наличия загружаемых
        // позиций в базе. хранит результаты запрсов до очистки. перед попыткой обращения
        // к базе, сначала перебирается этот массив


        procedure ToLog( text : string );

        function ExtractFile( archive_name: string; file_name: string = DEF_META_FILE ): boolean;
        /// метод выгружает указанный файл из указанного архива в темповую папку

        function GetXMLObject( var doc: IXMLDocument; var root_node: IXMLNode; filename: string = ''): boolean;
        /// открывает файл и возвращает объект с загруженными в него из файла данными

        function GetFileVersion: string;
        /// читает из заранее извлеченного файла информацию о версии файла компаса

        function ClearMacros(text : string): string;
        /// чистим строку от текстовых макросов компаса

        function LoadSpec( parent: integer; ispoln: integer = 0 ): boolean;
        /// внутренний метод полной или частичной загрузки спецификации в рабочий массив

        function GetID: integer;
        /// получение уникального значения для внутреннего id

        function AddArrayElem(parent, child, ispol, bd_id, kd_id: integer; kind, subkind, mark, name, count,
            mass, comment, material, linked_file, id, partID : string): integer;
        /// добавление нового элемента в рабочий массив

        function IsProcessed( id : string ): boolean;
        /// проверяет есть ли указанный идентификатор в списке уже обработанных (загруженных) объектов спецификации

        function ToProcessed( id : string ): boolean;
        /// добавляет указанный идентификатор в список обработанных в процессе загрузки объектов

        function GetKind( name: string ): string;

        function GetVersionField( field: integer ): string;
        /// по универсальному номеру поля получаем его имя для текущей версии

      public
        error : string;
        // последняя ошибка, произошедшая при работе менеджера

        function sProjectID( id: integer ): TKompasManager;
        /// устанавливает id проекта с которым работаем

        function sTempPath( path: string ): TKompasManager;
        /// устанавливает путь до темповой папки куда извлекать файлы из архива

        function sSetLogMemo( log: TMemo ): TKompasManager;
        /// подключает мемо для отображения лога загрузки

        function SetupMemtable( memtable: TMemTableEh ): boolean;
        /// метод настраивает внешний memtable куда будут выгружаться данные из рабочего массива
        /// этим занимается менеджер, поскольку критически важен порядок и набор полей,
        /// совпадающий с рабочим массивом

        procedure CleanUp;
        /// очищает рабочие массивы загруженных из xml данных и сбрасывает счетчик id

        function Init( archive_name: string; file_name: string = DEF_META_FILE ): boolean;
        /// извлекает xml структуры документа и загружает его в объект для дальнейшей работы

        function ScanFiles( path, filter: string; pass_filter: string = '' ): boolean;
        /// сканирует папку и подпапки на наличие файлов Компас, собирает с них базовую информацию
        /// в массив fFileArray

        function GetStampData( field: integer ): string;
        /// возвращает данные указанного поля штампа. параметр - константа вида FIELD_XXX
        /// требует предварительного выполнения функции Init

        function LoadSpecification( parent:integer = 0; mark: string = ''; ispol: integer = 0 ): boolean;
        /// загружает данные спецификации в рабочий массив, включая данные по
        /// ее элементам (вложенные спецификации и данне чертежей деталей)
        /// при успешном завершении, внутренний массив готов к выгрузке в датасет

        function UploadToDataset( dataset: TDataset): boolean;
        /// инициализирует и выгружает в датасет (memtable) данные рабочего массива

        function GetIspoln( mark: string ): integer;
        /// по тексту обозначения определяет и возвращает номер исполнения

        function FindObject( mark, name, kind: string; kd: boolean = false): integer;
    end;

var
    mngKompas: TKompasManager;

implementation

uses
    uPhenixCORE, uMain, uConstants;

{ TKompasManager }


function TKompasManager.Init( archive_name: string; file_name: string = DEF_META_FILE ): boolean;
begin
    result := false;
    error := '';

    ToLog('>>> Читаем данные файла ' + archive_name);

    // извлекаем указанный файл из архива (обычно, это основной xlm со структурой файла)
    if error = '' then ExtractFile( archive_name, file_name );

    // получаем базовые данные
    if error = '' then GetXMLObject( fDoc, fRootNode );


    // извлекаем ini с описанием версии файла
    if error = '' then ExtractFile( archive_name, DEF_INFO_FILE );

    // получаем версию открытого файла
    if error = '' then fVersion := GetFileVersion;

    if error = '' then
    if fVersion = VERSION_18 then
    begin
        // извлекаем файл вспомогательной информации о проекте
        if error = '' then ExtractFile( archive_name, DEF_META_PRODUCT_FILE );

        // получаем базовые данные
        if error = '' then GetXMLObject( fProject, fProjectRootNode );
    end;


    if error <> '' then
    begin
        ToLog( '!!! ' + error );
        exit;
    end;

    result := true;
end;

function TKompasManager.IsProcessed(id: string): boolean;
var
   i : integer;
begin

    result := false;
    for I := 0 to High(fProcessed) do
    if fProcessed[i] = id then
    begin
        result := true;
        exit;
    end;

end;

function TKompasManager.LoadSpecification( parent:integer = 0; mark: string = ''; ispol: integer = 0 ): boolean;
/// метод используется для загрузки полной спецификации
/// сначала грузится корневая спецификация
/// после этого перебираются все ее элементы и проверяются
/// на наличие собственных спецификаций и чертежей среди
/// найденных сканированием файлов.
/// если есть, данные подгружаются в дерево с привязкой к рассматриваемому
/// элементу, причем из спецификаций берутся данные только по конкретному
/// исполнению рассмаотриваемого элемента
var
   i, j, _ispoln : integer;
   found : boolean;
begin
    result := false;

    fMark := mark;

    /// сначала загружаем корневую спецификацию
    if not LoadSpec( parent, ispol ) then exit;

    /// перебираем все элементы рабочего массива
    /// и ищем файлы привязанные к нему
    /// если есть спецификация, подгружаем данные по исполнению объекта, а не
    /// целиком. новые объекты попадают в конец массива, что позволяет постепенно
    /// обработать все элементы дерева
    for I := 0 to High(fArray) do
    begin

        // пропускаем подгрузку спецификаций для уже существующих в КД объектов,
        // (при этом bd_id содержит значение id больше нуля, для объектов Проекта id отрицательный)
        // поскольку они в режиме только для чтения и их состав нам не нужен
        if (fArray[i].kd_id <= 0) then

        // игнорируем базовую спецификацию и ее исполнения
        if (fArray[i].parent <> 1) and (fArray[i].parent <> 0) then

        /// перебираем обнаруженные файлы и пытаесмя найти подходящие этому объекту
        found := false;
        j := 0;
//        for j := 0 to High(fFileArray) do
        while not found and (j <= High(fFileArray)) do
        begin

            _ispoln := GetIspoln(fArray[i].mark);

               // обозначение не имеет префикса - сравниваям напрямую
            if ((GetIspoln(fArray[i].mark) = 1) and ((fFileArray[j].mark = fArray[i].mark) or (fFileArray[j].mark_base = fArray[i].mark))) or
               // обозначение с префиксом - ищем как подстроку в наименовании файла, в котором не указывается исполнение
               ((GetIspoln(fArray[i].mark) > 1) and (pos( fFileArray[j].mark, fArray[i].mark ) <> 0)) or
               // ну и случай, когда номер исполнения зачем-то указан в имени файла
               ((GetIspoln(fArray[i].mark) > 1) and ((fFileArray[j].mark = fArray[i].mark) or (fFileArray[j].mark_base = fArray[i].mark)))
            then

            begin
                found := true;

                /// запоминаем, из какого файла берем данные
                fArray[i].linked_file := fFileArray[j].path + fFileArray[j].filename;

                /// для элемента найден привязанный файл
                /// если это чертеж, берем данные напрямую из массива файлов
                if fFileArray[j].kind = 'Чертеж' then
                begin
                    ToLog('>>> Найден чертеж для ' + fArray[i].mark + '. Данные обновлены.');
                    fArray[i].mass := fFileArray[j].mass;
                    fArray[i].material := fFileArray[j].material;
                    fArray[i].comment := fArray[i].comment + ' ' + fFileArray[j].comment;
                    fArray[i].linked_file := fFileArray[j].path + fFileArray[j].filename;
                end;

                if fFileArray[j].kind = 'Спецификация' then
                begin
                    ToLog('>>> Найдена спецификация для ' + fArray[i].mark );

                    /// загружаем данные из файла
                    if Init( fArray[i].linked_file ) then

                    /// читаем в рабочий массив
                    if not LoadSpec(
                        fArray[i].child,           // данные привязываем к этому элементу
                        GetIspoln(fArray[i].mark)  // из mark извлекаем метку исполнения вида '-0Х' и получаем номер
                    ) then
                    ToLog('!!! ' + error );

                end;
            end;

            Inc(j);
        end;

    end;
    ToLog('');
    ToLog('');
    ToLog('Спецификация загружена.');
    ToLog('Воспользуйтесь кнопкой "В проект", чтобы взять загруженную структуру в работу.');

    result := true;
end;

function TKompasManager.LoadSpec( parent: integer; ispoln: integer = 0 ): boolean;
/// метод подгружает в рабочий массив спецификацию или ее часть с привязкой к
/// указанному элементу ранее загруженных данных
///    parent - к этому элементу будет привязаны подгруженные данные
///    ispoln - загрузить не полные данные спецификации а только по указанному
///             номеру исполнения
///
/// метод используется как для загрузки первичной спецификации, так и для подгрузки
/// данных вложенных сборочных единиц
///
/// Алгоритм
///   - получаем данные о количестве столбцов для показа исполнений. логика такова
///     что при количестве исполнений больше, чем отведенное количество столбцов,
///     исполнения разбиваются на блоки. например, если 10 столбцов, а исполнение 5,
///     объект будет находиться в number="5" blockNumber="0", а для 12 исполнения
///     объект будет находиться в number="2" blockNumber="1".
///     знание количества столбцов дает возможность точно определить к какому исполнению
///     относится данный объект
///   - если номер искомого исполнения не задан, значит в данный момент читаем базовую
///     спецификацию, а значит рабочий массив пуст и нужно создать базовую структуру:
///       - создаем элемент спецификации
///       - записываем ее id_массива как значение parent
///   - получаем массив всех объектов в отдельном объекте
///   - получаем массив состава спецификации
///   - перебираем массив состава:
///       - получаем id_файла объекта из состава
///       - находим в массиве объектов по id_файла
///       - перебираем поля объекта и запоминаем его параметры.
///         далее, они будут служить образцом при раскидывании его по исполнениям
///       - читаем данные о количестве в различных исполнениях
///
///       (для режима чтения базовой спецификации)
///       - проверяем, есть ли уже такое исполнение
///           - если нет - создаем, привязывая к parent, запоминаем id_массива
///           - енсли есть - получаем id_массива
///       - создаем новый элемент рабочего массива, заполняем данными, првязываем к id_массива
///         (на данный момент нет необходимости проверять есть ли для этого
///          элемента спецификация или чертеж, поскольку рабочий массив обрабатывается
///          в порядке очереди и добавляемый элемент добавляется в конец, что
///          значит, что обработка доберется и до него. сейчас важно просто добавить его
///          в дерево считанных объектов)
///
///       (для режима чтения конкретного исполнения)
///       - проверяем, относится ли данная строка количества к искомому исполнению
///       - если да:
///           - создаем новый элемент рабочего массива, заполняем данными, првязываем к parent,
///             поскольку в данном случае мы уже рассматриваем элемент состава базовой
///             спецификации и parent является исполнением
///
var
    node
   ,nodeObjects      // массив всех объектов спецификации
//   ,nodeStruct       // массив структуры спецификации
   ,nodeSection
   ,nodeSectionObject
            : IXMLNode;


    i, j, k, l, m     // циклы. много циклов...
   ,isp_column_count  // количество столбцов для отображения исполнений, используется
                      // для вычисления номера исполнения
   ,IspID             // id корневого элемента спецификации для привязки исполнений
   ,ispol             // вычисленный номер исполнения из number и blockNumber
            : integer;

    mark
   ,name
   ,comment
   ,mass
   ,partID            // привязка к справочнику материалов [nft].[dbo].[mat].imbase_key

   ,tmp
            : string;

    function GetIspol( ispol: integer ): integer;
    /// по номеру и блоку вычисляем исполнение.
    /// проверяем, есть ли исполнение с таким номером
    /// если нет - создаем, иначе просто находим
    /// возвращаем внутренний id для сборки в дерево
    ///
    /// поскольку нет возможности сразу достоверно узнать количество исполнений,
    /// они создаются постепенно, по мере упоминания
    var
        i : integer;
        prefix: string;
    begin
        result := 0;

        /// при добавлении части спецификации, когда указан родитель и номер исполнения
        /// поиск по нему не требуется
        if parent <> 0 then exit;

        // ищем исполнение среди существующих
        for I := 0 to High(fArray) do
        if (fArray[i].parent = IspID) and (fArray[i].ispol = ispol) then
        begin
            result := fArray[i].child;
            exit;
        end;

        // если дошли до сюда - такого исполнения еще нет. добавим

        // по номеру исполнения формируем префикс исполнения
        prefix := '';

        if   ispol in [2..10]
        then prefix := '-0'+IntToStr(ispol-1);

        if   ( ispol > 10 )
        then prefix := '-'+IntToStr(ispol-1);

        // добавляем исполнение
        result := AddArrayElem(
            IspID,     // parent
            GetID,     // child
            ispol,
            FindObject( GetStampData( FIELD_MARK ) + prefix, GetStampData( FIELD_NAME ), IntToStr(KIND_ISPOLN) ), //bd_id
            0,         // prj_id

            'Комплекс',
            'Исполнение',
            GetStampData( FIELD_MARK ) + prefix,
            GetStampData( FIELD_NAME ),
            '1',       // count
            GetStampData( FIELD_MASS ),
            GetStampData( FIELD_COMMENT ),
            '',        // material
            fArchivename,
            '',         // id_файла
            ''          // id материала
        );

    end;

{    function GetMaterial( mark: string ): string;
    /// в списке просканированных файлов ищем чертеж для указанного обозначения
    /// и возвращаем значение материала, если указан
    var
        i : integer;
    begin
        result := '';

        for I := 0 to High(fFileArray) do
        if fFileArray[i].mark = mark then
        begin
            result := fFileArray[i].material;
            exit;
        end;
    end;
}
    procedure ProcessSections( node: IXMLNode );
    /// node - элемет, содержащий массив <section>
    var
        j, k, l, m     // циклы. много циклов...
                : integer;
    begin
        // для каждого раздела
        for j := 0 to node.ChildNodes.Count - 1 do
        begin
            // получаем ноду секции со всеми вложенными объектами
            nodeSection := node.ChildNodes[j];

            // для каждого объекта раздела
            for k := 0 to nodeSection.ChildNodes.Count - 1 do
            begin
                // получаем объект из секции
                nodeSectionObject := nodeSection.ChildNodes[k];

                // проверяем, не находится ли объект в массиве обработанных
                if not IsProcessed( nodeSectionObject.Attributes['id'] ) then

                // ищем его по id среди массива объектов
                for l := 0 to nodeObjects.ChildNodes.Count - 1 do
                if nodeObjects.ChildNodes[l].Attributes['id'] = nodeSectionObject.Attributes['id'] then
                begin

                    // перебираем данные объекта и ищем поля с количеством, по которым можно
                    // определить и исполнение к которому количество относится
                    // пример объекта:
                    //  <object id="283354985543.000000" modified="0">
                    //      <section number="20" subSecNumber="0" additionalBlockNumber="0" additionalSecNumber="0" nestingBlockNumber="0" nestingSecNumber="0"/>
                    //      <columns>
                    //          <column name="Формат" typeName="format" type="1" number="1" blockNumber="0" value="A4" modified="0"/>
                    //          <column name="Позиция" typeName="pos" type="3" number="1" blockNumber="0" value="15" modified="0"/>
                    //          <column name="Обозначение" typeName="mark" type="4" number="1" blockNumber="0" value="ТК-01-58.008" modified="0"/>
                    //          <column name="Наименование" typeName="name" type="5" number="1" blockNumber="0" value="Пластина" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="1" blockNumber="0" value="4" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="2" blockNumber="0" value="4" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="3" blockNumber="0" value="4" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="4" blockNumber="0" value="4" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="5" blockNumber="0" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="6" blockNumber="0" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="7" blockNumber="0" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="8" blockNumber="0" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="9" blockNumber="0" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="10" blockNumber="0" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="1" blockNumber="1" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="2" blockNumber="1" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="3" blockNumber="1" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="4" blockNumber="1" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="5" blockNumber="1" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="6" blockNumber="1" value="8" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="7" blockNumber="1" value="16" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="8" blockNumber="1" value="16" modified="0"/>
                    //          <column name="Количество" typeName="count" type="6" number="9" blockNumber="1" value="16" modified="0"/>
                    //      </columns>
                    //      <additionalColumns>
                    //          <column name="Масса" typeName="massa" type="8" number="1" blockNumber="0" value="2,02" modified="0"/>
                    //          <column name="ID PartLib" typeName="user" type="10" number="4" blockNumber="0" value="i60000010860BC0000A3" modified="0"/>
                    //      </additionalColumns>
                    //  </object>

                    mark := '';
                    name := '';
                    comment := '';
                    mass := '';
                    partID := '';


                    // перебираем основные поля, пока игнорируя количество, поскольку после них могут быть
                    // другие информативные поля типа примечания
                    for m := 0 to nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes.Count - 1 do
                    begin

                        // получаем обозначение
                        if   nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'mark'
                        then mark := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'] );

                        // получаем наименование
                        if   nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'name'
                        then name := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'] );

                        // получаем комментарий
                        if   nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'note'
                        then comment := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'] );

                    end;

                    if name = 'Гайка М8-6Н.5.019 ГОСТ 5915-70' then
                       name := name;

                    // перебираем дополнительные поля, если есть
                    for m := 0 to nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes.Count - 1 do
                    begin
                        tmp := nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['typeName'];

                        // получаем массу
                        if   tmp = 'massa'
                        then mass := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['value'] );

                        // получаем привязку к справочнику материалов, если есть
                        if (tmp = 'user') and
                           (nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['name'] = 'ID PartLib')
                        then partID := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['value'] );
                    end;

                    // после получения всех основных данных, разбираем количество
                    for m := 0 to nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes.Count - 1 do
                    begin

                        // перебирая значения количества, по полям number и blockNumber определяем исполнение к которому относится
                        if nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'count' then
                        begin

                            ispol :=
                                    StrToIntDef(nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['number'], 0) +
                                    StrToIntDef(nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['blockNumber'], 0) *
                                    isp_column_count;

                            // добавляем элемент только если не задано исполнение (грузится базовая спецификация)
                            // или исполнение задано и получены данные именно для него (грузится свпомогательная спецификация)
                            if (ispoln <> 0) and (ispol = ispoln) or
                               (ispoln = 0)
                            then
                                AddArrayElem(
                                    ifthen( parent <> 0, parent, GetIspol( ispol ) ),
                                                                                    // parent (исполнение/указанный родитель)
                                    GetID,                                          // child
                                    ispol,
                                    FindObject(mark, name, nodeSection.Attributes['text']), // bd_id
                                    FindObject(mark, name, nodeSection.Attributes['text'], true), // prj_id

                                    nodeSection.Attributes['text'],                 // имя раздела / тип объекта
                                    ifthen( nodeSection.Attributes['text'] = 'Сборочные единицы', 'Исполнение', '' ),
                                    mark,
                                    name,
                                    nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'], // count
                                    mass,
                                    comment,
                                    '',//GetMaterial( mark ),                            // material
                                    '',                                             // привязанный файл
                                    nodeObjects.ChildNodes[l].Attributes['id'],      // id_файла
                                    partID                                           // id материала
                                );

                            ToProcessed( nodeSectionObject.Attributes['id'] );
                        end;
                    end;
                end;
            end;
        end;
    end;

begin

    result := false;
    IspID := 0;

    if not Assigned(fRootNode) then
    begin
        error := lE('Не проинициализирован XML документ');
        exit;
    end;

    // проверяем наличие и наполненность ключевых разделов, иначе файл не годится для работы
    try
        if
            (fRootNode.ChildNodes['spcDescriptions'].ChildNodes.Count = 0 ) or
            (fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes.Count = 0 ) or
            (fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes.Count = 0 )
        then
            Raise Exception.Create('Не корректный файл спецификации');
    except
        error := lE('Файл не является спецификацией, либо является некорректным');
        exit;
    end;

    // сбрасываем информацию об обработке предыдущей спецификации.
    // поскольку мы строим дерево, где одни и те же элементы могут
    // находиться в разных ветках, то загрузка будет происходить
    // только один раз для первого включения, если не сбросить этот массив
    SetLength(fProcessed, 0);

    // получаем данные о количестве столбцов для показа исполнений
    node := fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['style'].ChildNodes['columns'];

    isp_column_count := 0;
    for I := 0 to node.ChildNodes.Count - 1 do
    if  (node.ChildNodes[i].Attributes['typeName'] = 'count')
    then isp_column_count := max( isp_column_count, StrToIntDef(node.ChildNodes[i].Attributes['number'], 1));


    // если номер искомого исполнения не задан, создаем корневой элемент спецификации
    // при загрузке базовой
    if ( Length(fArray) = 0 ) and ( parent = 0 )
    then
       IspID := AddArrayElem(
            0,         // parent
            GetID,     // child
            0,         // исполнение
            FindObject( GetStampData( FIELD_MARK ), GetStampData( FIELD_NAME ), IntToStr(KIND_SPECIF) ),         // реальный id в базе
            0,

            'Комплекс',
            'Спецификация',
            GetStampData( FIELD_MARK ),
            GetStampData( FIELD_NAME ),
            '1',       // count
            GetStampData( FIELD_MASS ),
            GetStampData( FIELD_COMMENT ),
            '',        // material
            fArchivename,
            '',         // id_файла
            ''
        );

    // при загрузке части спецификации верхний элемент создается чисто условно.
    // просто для того, чтобы к нему прицепить импортированные элементы
    if ( Length(fArray) = 0 ) and ( parent <> 0 )
    then
       IspID := AddArrayElem(
            0,         // parent
            parent,    // child
            ispoln,    // исполнение
            parent,    // реальный id в базе
            0,

            'Сборочные единицы',
            'Исполнение',
            fMark,
            '',
            '',        // count
            '',
            '',
            '',        // material
            '',        // привязанный файл
            '',         // id_файла
            ''
        );

    // получаем массив всех объектов
    nodeObjects :=  fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcObjects'];

    // перебираем структуру спецификации для того, чтобы иметь представление в каком разделе
    // содержится объект, а значит какого он типа. в самих атрибутах объекта такой информации нет
    // пример структуры (в спецификации с одним исполнением может отсутствовать уровень <block>):
	//		<spcStruct>
	//			<block text="Обозн. исполн. - 01 02 03 04 05 06 07 08 09">
	//				<section text="Документация">
	//					<object id="261786785160.000000" text="ТК-01-58.000 СБ  Рама. Сборочный чертеж"/>
	//				</section>
	//				<section text="Сборочные единицы">
	//					<object id="187698667038.000000" text="ТК-01-58.010  Цапфа"/>
	//				</section>
	//				<section text="Детали">
	//					<object id="314150522817.000000" text="ТК-01-58.001  Балка"/>
	//					<object id="310670566502.000000" text="ТК-01-58.001-01  Балка"/>
	//					<object id="310670566602.000000" text="ТК-01-58.001-02  Балка"/>
	//				</section>
	//				<section text="Стандартные изделия">
	//					<object id="228253403033.000000" text="Винт с шестигранной головкой М12x40-5.6-A9A  ГОСТ Р ИСО 4017-2013"/>
	//				</section>
	//				<section text="Материалы">
	//					<object id="339336657291.000000" text="Плита 1250х600х50 TS 034 Aquastatik"/>
	//				</section>
	//			</block>
	//			<block text="Обозн. исполн. 10 11 12 13 14 15 16 17 18">
	//				<section text="Документация">
	//					<object id="261786785160.000000" text="ТК-01-58.000 СБ  Рама. Сборочный чертеж"/>
	//				</section>
	//				<section text="Сборочные единицы">
	//					<object id="187698667038.000000" text="ТК-01-58.010  Цапфа"/>
	//				</section>
	//				<section text="Детали">
	//					<object id="310670567402.000000" text="ТК-01-58.001-10  Балка"/>
	//					<object id="310670567502.000000" text="ТК-01-58.001-11  Балка"/>
	//				</section>
	//				<section text="Стандартные изделия">
	//					<object id="228253403033.000000" text="Винт с шестигранной головкой М12x40-5.6-A9A  ГОСТ Р ИСО 4017-2013"/>
	//					<object id="349041543620.000000" text="Гайка шестигранная нормальная  ГОСТ ISO 4032 М12-5-B9A"/>
	//				</section>
	//				<section text="Материалы">
	//					<object id="339336657291.000000" text="Плита 1250х600х50 TS 034 Aquastatik"/>
	//				</section>
	//			</block>
	//		</spcStruct>

    // если в структуре присутствует раздел <block>, то разделы <section> распиханы по
    // массиву блоков и нужно перебирать каждый блок отдельно, подставляя в качестве корневого элемента
    // очередной <block>
    if   fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes[0].NodeName = 'block'
    then
        for i := 0 to fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes.Count - 1 do
        ProcessSections( fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes[i] )
    // иначе, это простая спецификация с одним исполнением и в качестве корневого
    // достаточно передать только <spcStruct>, непосредственно в котором и находятся все <section>
    else
        ProcessSections( fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'] );

    result := true;
end;

function TKompasManager.ScanFiles(path, filter: string; pass_filter: string = ''): boolean;
/// метод сканирует одну или несколько указанных папок на наличие файлов
/// Компас и записывает их основные данные в массив fFileArray
///
///    path - корневая папка (список через запятую) для поиска
///    filter - метод поиска по подпапкам:
///        '' - не искать в подпапках
///        '*.*' - искать во всех подпапках
///        непустая строка - маска для поиска папки. допустимы несколько масок через запятую
///    pass_filter - маска имени/имен папок, которые исключить из списка поиска файлов
///        по ним найденные папки будут дополнительно отфильтрованы после поиска по
///        маске filter. допустимы несколько масок через запятую
var
    paths
   ,filters
   ,pass_filters
   ,dir_full_list  /// список будет использоваться как словарь ключ=значение
                   /// что позволит проводить поиски в нескольких пересекающихся
                   /// исходных папках. при сохранении в словарь повторяющиеся
                   /// папки будут игнорироваться, что избавляет от ручной проверки
            : TStringList;

    dir_list       /// временный список найденных по макске подпапок по одной из
                   /// корневых папок
            : TStringDynArray;

    i, j, p, f
            : integer;

    SR
            : TSearchRec;

    _mark_base     /// приведенное к человеческому виду обозначение из файла
   ,_kind          // тип текущего документа
            : string;

    function ClearUpMark( mark: string ): string;
    /// в файле значение mark может быть указано как угодно. пытаемся это как-то
    /// проконтролировать: отсекаем пробелы, подменяем английские буквы на русские
    begin
        mark := Trim(mark);
        mark := ReplaceStr( mark, 'E', 'Е');
        mark := ReplaceStr( mark, 'T', 'Т');
        mark := ReplaceStr( mark, 'O', 'О');
        mark := ReplaceStr( mark, 'P', 'Р');
        mark := ReplaceStr( mark, 'A', 'А');
        mark := ReplaceStr( mark, 'H', 'Н');
        mark := ReplaceStr( mark, 'K', 'К');
        mark := ReplaceStr( mark, 'X', 'Х');
        mark := ReplaceStr( mark, 'C', 'С');
        mark := ReplaceStr( mark, 'B', 'В');
        mark := ReplaceStr( mark, 'M', 'М');
        result := mark;
    end;

    function PresentFile( mark, kind: string ): boolean;
    /// ищем повторы загруженного файла по mark и типу
    var
        i : integer;
    begin
        result := false;
        for i := 0 to High(fFileArray) do
        if (fFileArray[i].mark = mark) and (fFileArray[i].kind = kind) then
        begin
            result := true;
            exit;
        end;
    end;

begin

    result := false;

    ToLog('>>> Поиск файлов Компас в указанных папках...');

    // парсим все списки. поскольку элементы разделены запятыми
    // запихивание такой строки в stringlist автоматом разбивает ее на отдельные строки
    paths := TStringList.Create;
    paths.CommaText := path;

    filters := TStringList.Create;
    filters.CommaText := filter;

    pass_filters := TStringList.Create;
    pass_filters.CommaText := pass_filter;


    /// создаем хранилище для всех найденных директорий
    dir_full_list := TStringList.Create;

    /// используя список как словарь ключ=значение, сохраняем исходные папки в списке
    for I := 0 to paths.Count - 1 do
       dir_full_list.Values[paths[i]] := '1';

    /// если задан фильтр, разрешающий сканирование подпапок
    if (filter <> '') then
    for p := 0 to paths.Count - 1 do
    for f := 0 to filters.Count - 1 do
    begin
        try
            dir_list := TDirectory.GetDirectories(trim(paths[p]), trim(filters[f]), TSearchOption.soAllDirectories);

            /// записываем все найденные из в словарь
            /// ставя признак актуальности
            /// если заданы маски игнорирования, признак в дальнейшем будет сброшен
            /// для папок попавших в игнор
            for j := 0 to High(dir_list) do
                dir_full_list.Values[dir_list[j]+'\'] := '1';

        except
            on E : Exception do lE( e.Message );
        end;
    end;

    /// если есть исключения, находим эти папки
    if pass_filter <> '' then
    for p := 0 to paths.Count - 1 do
    for f := 0 to pass_filters.Count - 1 do
    begin
        try
            dir_list := TDirectory.GetDirectories(trim(paths[p]), trim(pass_filters[f]), TSearchOption.soAllDirectories);

            /// и так же записываем из в словарь, автоматически игнорируя повторения
            /// при этом ставим признак, что данную директорию нужно пропустить
            /// если до этого данная директория была найдена фильтрами, ее значение будет сброшено
            for j := 0 to High(dir_list) do
                dir_full_list.Values[dir_list[j]+'\'] := '0';
        except
            on E : Exception do lE( e.Message );
        end;
    end;

    /// перебираем все найденные папки
    for i := 0 to dir_full_list.Count - 1 do
    begin
        // берем актуальные
        if dir_full_list.Values[ dir_full_list.Names[i] ] = '1' then

        // ищем там файлы компаса
        if FindFirst( dir_full_list.Names[i] + '*.*', faAnyFile, SR ) = 0 then
        repeat

            if ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.SPW' ) or
               ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.CDW' ) then
            begin

                /// получаем данные файла
                if not Init( dir_full_list.Names[i] + SR.Name ) then continue;

                /// получаем и очищаем обозначение
                _mark_base := ClearUpMark( GetStampData( FIELD_MARK_BASE ) );
                _kind := GetStampData( FIELD_KIND );

                // отсеиваем лишние повторы и файлы с пустым mark
                if (_mark_base = '') or PresentFile( _mark_base, _kind ) then continue;

                /// добавляем информацию о файле в массив найденных
                SetLength(fFileArray, Length(fFileArray)+1);

                fFileArray[High(fFileArray)].path     := dir_full_list.Names[i];
                fFileArray[High(fFileArray)].filename := SR.Name;
                fFileArray[High(fFileArray)].kind     := _kind;
                fFileArray[High(fFileArray)].mark     := GetStampData( FIELD_MARK );
                fFileArray[High(fFileArray)].mark_base := _mark_base;
                fFileArray[High(fFileArray)].name     := GetStampData( FIELD_NAME );
                fFileArray[High(fFileArray)].mass     := GetStampData( FIELD_MASS );
                fFileArray[High(fFileArray)].material := GetStampData( FIELD_MATERIAL );
                fFileArray[High(fFileArray)].comment  := GetStampData( FIELD_COMMENT );

                ToLog(Format('        mark: %s',[ fFileArray[High(fFileArray)].mark ]));

            end;

        until FindNext( SR ) <> 0;

        FindClose(SR);
    end;

    ToLog('>>> Загружены данные ' + IntToStr(Length(fFileArray)) + ' файлов Компас.');

    result := true;
end;

function TKompasManager.SetupMemtable(memtable: TMemTableEh): boolean;
/// конфигурируем компонент для корректной выгрузки из рабочего массива
/// данный компонент привязан к внешней DBGridEh, которая после выгрузки
/// данных в memtable отобразит их в виде дерева
begin

    Memtable.Close;

    Memtable.FieldDefs.Clear;

    /// создаем набор полей. важен порядок. его следует соблюдать при передаче
    /// данных в метод Memtable.AppendRecord при выгрузке в датасет
    Memtable.FieldDefs.Add('kind',      ftInteger, 0, false);   // тип объекта основной (сборка, деталь, ..)
    Memtable.FieldDefs.Add('subkind',   ftInteger, 0, false);   // тип объекта дополнительный (спецификация, исполнение)
    Memtable.FieldDefs.Add('mark',      ftString,  100, false);  // обозначение
    Memtable.FieldDefs.Add('name',      ftString,  1000, false);  // наименование
    Memtable.FieldDefs.Add('count',     ftString,  10, false);   // количество
    Memtable.FieldDefs.Add('mass',      ftString,  10, false);   // масса
    Memtable.FieldDefs.Add('comment',   ftString,  1000, false);  // примечание
    Memtable.FieldDefs.Add('material',  ftString,  200, false);  // материал (установлен у деталей)
    Memtable.FieldDefs.Add('linked_file',ftString, 200, false);   // файл с дополнительными данными (чертеж/спецификация)
    Memtable.FieldDefs.Add('id',        ftString,  50, false);   // внутренний id в самой спецификации

    Memtable.FieldDefs.Add('child',     ftInteger, 0, false);   // вычисленный при загрузке собственный id
    Memtable.FieldDefs.Add('parent',    ftInteger, 0, false);   // вычисленный при загрузке id родителя
    Memtable.FieldDefs.Add('ispol',     ftInteger, 0, false);   // номер исполнения
    Memtable.FieldDefs.Add('bd_id',     ftInteger, 0, false);   // id в базе, если объект существует
    Memtable.FieldDefs.Add('imbaseKey', ftString,  100, false); // ссылка на справочник материалав в базе NFT
                                                                // актуально для объектов типа материал, деталь или стандартное изделие
    Memtable.FieldDefs.Add('mat_id',    ftInteger, 0, false);   // id записи в справочнике материалав в базе NFT
                                                                // заполняется отдельным запросом по значнию imbaseKey

    /// настраиваем отображение в виде дерева
    Memtable.TreeList.Active := true;
    Memtable.TreeList.FullBuildCheck := false;
    Memtable.TreeList.DefaultNodeHasChildren := false;
    Memtable.TreeList.KeyFieldName := 'child';
    Memtable.TreeList.RefParentFieldName := 'parent';

    /// создаем пустую рабочую структуру, готовыую к загрузке данных
    Memtable.CreateDataSet;

    Memtable.Open;

end;

function TKompasManager.ExtractFile(archive_name: string; file_name: string = DEF_META_FILE ): boolean;
/// извлекает указанный файл из архива в темповую папку
Var
    ZF: TZipFile;
begin
    result := false;
    error := '';
    fFilename := '';

    // принудительно создаем темповую папку
    if Not DirectoryExists( fTempPath ) then ForceDirectories( fTempPath );

    if fTempPath = ''                   then error := lE('Не указана папка для извлечения файла из архива');
    if Not DirectoryExists( fTempPath ) then error := lE('Папка "'+fTempPath+'" для извлечения файла из архива не существует');
    if Not FileExists( archive_name )   then error := lE('Файл архива "'+archive_name+'" не существует');
    if Trim( file_name ) = ''           then error := lE('Не указано имя файла извлекаемого из архива');

    if error <> '' then exit;

    /// удаляем предыдущий распакованный файл, чтобы корректно отследить
    /// неудачу распаковки
    DeleteFile( fTempPath + file_name );

    // непосредственное извлечение файла
    try
        try
            ZF := TZipFile.Create;
            ZF.Open( archive_name, zmRead );
            ZF.Extract( file_name, fTempPath, True );
        finally
            ZF.Free;
        end;
    except
        on E:exception do
        error := E.Message;
    end;

    if Not FileExists( fTempPath + file_name ) then
    begin
        error := lE('Не удалось извлечь файл "'+file_name+'" из архива "'+archive_name+'"' + sLineBreak + error);
        exit;
    end;

    fFilename := file_name;
    fArchivename := archive_name;

    result := true;
end;

function TKompasManager.GetXMLObject(var doc: IXMLDocument; var root_node: IXMLNode; filename: string = ''): boolean;
///  открываем указанный или последний распакованный файл и возвращаем
///  объект-обработчик с загруженными в него данными
label
    ext;
begin

    lC('GetXMLObject (' + filename + ')');

    result := false;

    // если файл не указан, считаем, что эти данные уже есть во внутренних
    // переменных после вызова метода извлечения xml файла из архива ExtractFile
    if ( Trim(filename) = '' ) then filename := fTempPath + fFilename;

    if ( Trim(filename) <> '' ) and not FileExists( filename ) then
    begin
        error := lE('Не указан или не существует указанный файл: ' + filename );
        goto ext;
    end;


    try
        // грузим и парсим файл
        doc := TXMLDocument.Create(nil) as IXMLDocument;
        doc.LoadFromFile( filename );
        doc.Active := true;

        // получаем корневой элемент
        try
            root_node := doc.DocumentElement;
        except
            on E: Exception do
                error := lE('Не удалось получить корневой элемент XML файла ' + filename + sLineBreak + E.Message );
        end;

    except
        on E: Exception do
            error := lE('Не удалось загрузить XML файл ' + filename + sLineBreak + E.Message );
    end;

    result := true;

ext:
    lCE;
end;


function TKompasManager.GetFileVersion: string;
var
    filename
   ,filetype : string;
    sect : TStringList;
begin

    result := '';

    // если файл не указан, считаем, что эти данные уже есть во внутренних
    // переменных после вызова метода извлечения xml файла из архива ExtractFile
    filename := fTempPath + DEF_INFO_FILE;

    if not FileExists( filename ) then
    begin
        error := lE('Не указан или не существует файл: ' + filename );
        exit;
    end;


    /// хоть содержимое файла и выглядит как ini, соответствующий класс его не
    /// пережевывает. при попытке чтения ini.ReadString('FileInfo', 'AppVersion', '');
    /// вываливается GetLastError 'Не удалось найти указанный файл'. при том
    /// ini := TInifile.Create(filename) отрабатывает нормально, объект создается,
    /// т.е. файл существует и доступен. возможно, это связано с кодировкой файла.

    /// успешно обойдено через TStringList как парного хранилища значений

    sect := TStringList.Create;
    sect.LoadFromFile( filename );

    result := sect.Values['AppFileVersion'];

    fVersion := sect.Values['AppFileVersion'];

    filetype := sect.Values['FileType'];
    fFileType := FILE_TYPE_NONE;
    if filetype = FILE_TYPE_SPEC_ID then fFileType := FILE_TYPE_SPEC;
    if filetype = FILE_TYPE_DRAW_ID then fFileType := FILE_TYPE_DRAW;
end;

function TKompasManager.GetID: integer;
begin
    Inc(fID);
    result := fID;
end;

function TKompasManager.GetIspoln(mark: string): integer;
///
var
    reg: TRegEx;
    maches : TMatchCollection;
    tmp: string;
begin
    /// ищем в конце обозначения маркировку исполнения вида: -02, -34 и т.п.
    reg:=TRegEx.Create('\-\0?\d+$');

    // получаем из текущего имени числовую часть, отсекая все остальное
    maches := reg.Matches( mark );

    if maches.Count > 0
    then
    begin
        tmp := copy( maches[0].Value, 2, length(maches[0].Value) );
        result := StrToIntDef( tmp, 1 ) + 1;
        // внутренняя нумерация исполнений в файле спецификации идет с 1, а
        // внешняя с неотображаемого префикса '-00'. поскольку нас интересует
        // внутренний номер, к числе префикса добавляем единицу
    end
    else result := 1;

end;

function TKompasManager.GetStampData(field: integer): string;
/// по указанному id атрибута, ищем и возвращаем значение из xml
var
    i, j, k
            : integer;

    text, doc_id, version_field
   ,base, delim, number
            : string;

    node: IXMLNode;
    prop: IXMLNodeList;

    function GetMark( full: boolean ):string;
    var j,k: integer;
    begin
        for j := 0 to prop.Count - 1 do
        if prop[j].Attributes['id'] = 'marking' then
        begin

            for k := 0 to prop[j].ChildNodes.Count - 1 do
            begin

                if prop[j].ChildNodes[k].Attributes['id'] = FIELD_MARK_BASE_18
                then base := prop[j].ChildNodes[k].Attributes[ 'value' ];

                if prop[j].ChildNodes[k].Attributes['id'] = FIELD_MARK_DELIM_18
                then delim := prop[j].ChildNodes[k].Attributes[ 'value' ];

                if prop[j].ChildNodes[k].Attributes['id'] = FIELD_MARK_NUMBER_18
                then number := prop[j].ChildNodes[k].Attributes[ 'value' ];
            end;

            if full
            then result := base + delim + number
            else result := base;

        end;
    end;

begin
    result := '';

    ///
    version_field := GetVersionField( field );

    // выборка данных, исходя из версии файла
    if (fVersion = VERSION_17) OR (fVersion = VERSION_16) then
    begin
        if not Assigned(fRootNode) then
        begin
            error := lE('Не проинициализирован XML документ');
            exit;
        end;

        for i := 0 to fRootNode.ChildNodes['properties'].ChildNodes.Count - 1 do
        if fRootNode.ChildNodes['properties'].ChildNodes[i].Attributes['id'] = version_field
        then
            result := ClearMacros( fRootNode.ChildNodes['properties'].ChildNodes[i].Attributes['value'] );
    end;



/// в 18 версии добавлен отдельный XML файл, отвечающий за набор документов(?)
/// назначение их не совсем понятно, но можно вычленить основной, в котором содержатся данные
/// соответствующие данным штампа из 17 версии КОМПАС
///
/// объект <product> содержит аттрибут [thisDocument], указывающи на одного из потомков,
/// который и содержит нужные данные
///
/// <?xml version="1.0"?>
/// <document version="1.2" state="ready">
/// 	<descriptions>
///     ....
/// 	</descriptions>
/// 	<dictionaries />
/// 	<product id="6e8dea49-d132-4784-8b94-a5bb3020b92c" thisDocument="870673ca-ff9a-4a85-9ff9-54da24abfd94">
/// 		<document id="870673ca-ff9a-4a85-9ff9-54da24abfd94">
/// 			<property id="name" value="Узел крепления" type="string" />
/// 			<property id="marking">
/// 				<property id="base" value="ЭТМ2.02.01.300" type="string" />
///                 .....
/// 			</property>
/// 			<property id="count" value="1" prodCopy="true" type="int" />
/// 			<property id="mass" value="1.29363" prodCopy="true" type="double" />
/// 			<property id="accuracyClass" value="m" prodCopy="true" type="string" />
/// 			<property id="specRoughSign" value="0" prodCopy="true" type="int" />
/// 			<property id="specRoughValue" value="" prodCopy="true" type="string" />
/// 			<property id="stampAuthor" value="Москвин" type="string" />
/// 			<property id="checkedBy" value="Адайкин" type="string" />
/// 			<property id="rateOfInspection" value="Стулий" type="string" />
/// 			<property id="approvedBy" value="Ефимов" type="string" />
/// 			<property id="format" value="A4" type="string" />
/// 			<property id="sheetsNumber" value="1" type="int" />
/// 			<property id="fullFileName" value="\\Fileserver\ОГК\Изм.Тех\Эталон 2\ЭТМ2.00.00.000\ЭТМ2.02.00.000 Обвязка технологическая\ЭТМ2.02.01.000 Основание\ЭТМ2.02.01.300.spw" type="string" />
/// 		</document>
///         ...
/// 	</product>
/// </document>

    if fVersion = VERSION_18 then
    begin
        if not Assigned(fProjectRootNode) then
        begin
            error := lE('Не проинициализирован XML документ');
            exit;
        end;


        doc_id := fProjectRootNode.ChildNodes['product'].Attributes['thisDocument'];

        /// перебираем элементы <product> -> <document>
        /// ищем основной документ проекта
        for i := 0 to fProjectRootNode.ChildNodes['product'].ChildNodes.Count - 1 do
        if fProjectRootNode.ChildNodes['product'].ChildNodes[i].Attributes['id'] = doc_id
        then
        begin

            /// в 18 версии нет поля отвечающего за тип документа
            /// подставляем значение считанное из файла-описания
            if field = FIELD_KIND then
            begin
                result := fFileType;
                exit;
            end;

            // получаем набор полей документа
            prop := fProjectRootNode.ChildNodes['product'].ChildNodes[i].ChildNodes;

            /// ищем данные нужного стандартного поля
            for j := 0 to prop.Count - 1 do
            if (prop[j].Attributes['id'] = version_field) and prop[j].HasAttribute('value')
            then result := ClearMacros( prop[j].Attributes['value'] );

            if field = FIELD_MARK then result := GetMark(true);  /// полное обозначение
            if field = FIELD_MARK_BASE then result := GetMark(false); /// базовое обозначение

        end;
    end;

end;

function TKompasManager.GetVersionField(field: integer): string;
/// по универсальному номеру поля получаем его имя для текущей версии
var
    version: integer;
begin
    if fVersion = VERSION_16 then version := VERSION_INDEX_17;
    if fVersion = VERSION_17 then version := VERSION_INDEX_17;
    if fVersion = VERSION_18 then version := VERSION_INDEX_18;

    result := FIELDS[ field, version ];
end;

function TKompasManager.AddArrayElem(parent, child, ispol, bd_id, kd_id: integer; kind, subkind,
  mark, name, count, mass, comment, material, linked_file, id, partID: string): integer;
var
    i : integer;
begin

    result := 0;

    /// проверяем наличие элемента в массиве привязанного к данному родителю.
    /// структура xml дает повторения элементов при проходе по структуре спецификации,
    /// а к одному родителю не может быть привязано несколько одинаковых объектов
    for I := 0 to High(fArray) do
    if (fArray[i].mark = mark) and (fArray[i].name = name) and (fArray[i].parent = parent) then
    begin
        result := fArray[i].child;
        break;
    end;

    // если копии не обнаружено - создаем
    if result = 0 then
    begin

        SetLength(fArray, Length(fArray)+1);

        fArray[High(fArray)].parent      := parent;
        fArray[High(fArray)].child       := child;
        fArray[High(fArray)].kind        := GetKind(kind);
        fArray[High(fArray)].subkind     := GetKind(subkind);
        fArray[High(fArray)].mark        := mark;
        fArray[High(fArray)].name        := name;
        fArray[High(fArray)].count       := count;
        fArray[High(fArray)].mass        := mass;
        fArray[High(fArray)].comment     := comment;
        fArray[High(fArray)].material    := material;
        fArray[High(fArray)].linked_file := linked_file;
        fArray[High(fArray)].file_id     := id;
        fArray[High(fArray)].ispol       := ispol;
        fArray[High(fArray)].bd_id       := bd_id;
        fArray[High(fArray)].kd_id       := kd_id;
        fArray[High(fArray)].part_id     := partID;


        // возвращаем внутренний id элемента
        result := fArray[High(fArray)].child;

        ToLog(
            '(' + IntToStr(fArray[High(fArray)].ispol) + ' p:'+IntToStr(fArray[High(fArray)].parent)+' c:'+IntToStr(fArray[High(fArray)].child)+') ' +

            fArray[High(fArray)].kind + ' | ' +
            fArray[High(fArray)].subkind + ' | ' +
            fArray[High(fArray)].mark + ' | ' +
            fArray[High(fArray)].name + ' | ' +
            fArray[High(fArray)].count + ' | ' +
            fArray[High(fArray)].mass + ' | ' +
            fArray[High(fArray)].comment + ' | ' +
            fArray[High(fArray)].material + ' = ' + fArray[High(fArray)].part_id
        );

    end;

end;

procedure TKompasManager.CleanUp;
begin
    if Assigned( fLog ) then fLog.Lines.Clear;

    SetLength(fArray, 0);
    SetLength(fFileArray, 0);
    SetLength(fProcessed, 0);
    SetLength(fFindBuff, 0);

    fId := 1;
end;

function TKompasManager.ClearMacros(text : string): string;
begin
    result := text;
    result := ReplaceStr( result, '@/', ' ');  // убираем внутренний макрос Компаса на перенос строки
    result := ReplaceStr( result, '$d', '');   // убираем внутренний макрос Компаса на отображение в виде формулы
    result := ReplaceStr( result, '@1~', '');  // убираем внутренний макрос
    result := ReplaceStr( result, '@2~', '');  // убираем внутренний макрос
    result := ReplaceStr( result, '$|', '');  // убираем внутренний макрос
    result := trim(result);
end;

function TKompasManager.sProjectID(id: integer): TKompasManager;
begin
    result := self;
    fProjectID := id;
end;

function TKompasManager.sSetLogMemo(log: TMemo): TKompasManager;
begin
   fLog := log;
   result := self;
end;

function TKompasManager.sTempPath(path: string): TKompasManager;
/// метод настраивает темповый путь для выгрузки из архива
/// возврат TKompasManager сделан для возможности опциональной настройки при
/// создании экземпляра менеджера без переписывания конструктора и создания
/// цепочки методов любой длины:
///    TKompasManager.Create( owner ).sTempPath( SomePath ).sSomeOtherMethod();
begin
    result := self;
    fTempPath := path;
end;

procedure TKompasManager.ToLog(text: string);
begin
    if not Assigned( fLog ) then exit;
    fLog.Lines.Add( text );
end;

function TKompasManager.ToProcessed(id: string): boolean;
begin
    SetLength(fProcessed, Length(fProcessed)+1);
    fProcessed[high(fProcessed)] := id;

    result := true;
end;

function TKompasManager.UploadToDataset(dataset: TDataset): boolean;
var
   i: integer;
   ds: TDataset;
   material, imbaseKey : string;
   mat_id: integer;
begin

    result := false;

    if Not Assigned(dataset) then exit;

    ds := nil;

    for I := 0 to High(fArray) do
    begin
         mat_id := 0;
         material := fArray[i].material;
         imbaseKey := fArray[i].part_id;

        if StrToIntDef(fArray[i].kind, 0) in [ KIND_DETAIL, KIND_MATERIAL, KIND_STANDART, KIND_OTHER ] then
        begin

            ToLog( '('+IntToStr(i)+'/'+IntToStr(High(fArray))+') Привязка материала : '+ fArray[i].name + ' (key: '+fArray[i].part_id+')' );

            imbaseKey := '';
            material := '';

            if assigned(ds) and ds.Active then ds.Active := false;

            /// ищем по имеющемуся коду
            if Trim(fArray[i].part_id) <> '' then
            ds := mngData.GetMaterialRecord( 'Imbase_Key', fArray[i].part_id );

            /// кода нет или по немиу не найдено, ищем по наименованию
            if ( StrToIntDef(fArray[i].kind, 0) <> KIND_DETAIL )
               and (not assigned(ds) or not ds.Active or (ds.RecordCount = 0)) then
            ds := mngData.GetMaterialRecord( 'm', fArray[i].name );

            /// забираем данные, если есть
            if Assigned(ds) and ds.Active and (ds.RecordCount > 0) then
            begin
                mat_id := ds.FieldByName('id').AsInteger;
                material := ds.FieldByName('m').AsString;
                imbaseKey := ds.FieldByName('Imbase_Key').AsString;
            end;

        end;

        dataset.AppendRecord([
            fArray[i].kind,
            fArray[i].subkind,
            fArray[i].mark,
            fArray[i].name,
            fArray[i].count,
            fArray[i].mass,
            fArray[i].comment,
            material,
            fArray[i].linked_file,
            fArray[i].file_id,
            fArray[i].child,
            fArray[i].parent,
            fArray[i].ispol,
            fArray[i].bd_id,
            imbaseKey,
            mat_id
        ]);
    end;

    dataset.First;

    if assigned(ds) then ds.Free;

    result := true;
end;

function TKompasManager.FindObject( mark, name, kind: string; kd: boolean = false): integer;
/// проверяем наличие в базе объекта по обозначению и имени

    function getObjectID(field, value: string): integer;
    var
        i
       ,kd_id
           : integer;

    begin
         result := -1;

         for i := 0 to high(fFindBuff) do
         if   fFindBuff[i].value = trim( value ) then
         if   fFindBuff[i].kind = kind then
         begin
             if kd
             then result := fFindBuff[i].kd_id
             else result := fFindBuff[i].bd_id;
             break;
         end;

         // не найдено в буффере
         if result = -1 then
         begin

             /// ищем объект в проекте
             result := mngData.GetProjectObjectBY( fProjectID, field, Trim( value ), kind );
             kd_id := mngData.GetObjectBY( field, Trim( value ), kind );

             /// если не найден, ищем в КД
             if   result = 0
             then result := kd_id;

             if result <> 0 then
             begin
                 SetLength(fFindBuff, Length(fFindBuff)+1);
                 fFindBuff[high(fFindBuff)].value := value;
                 fFindBuff[high(fFindBuff)].kind := kind;
                 fFindBuff[high(fFindBuff)].bd_id := result;
                 fFindBuff[high(fFindBuff)].kd_id := kd_id;
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

function TKompasManager.GetKind( name: string ): string;
begin
    result := '0';
    if name = 'Спецификация'        then result := '10';
    if name = 'Исполнение'          then result := '11';
    if name = 'Документация'        then result := '12';
    if name = 'Комплекс'            then result := '8';
    if name = 'Сборочные единицы'   then result := '7';
    if name = 'Детали'              then result := '4';
    if name = 'Стандартные изделия' then result := '5';
    if name = 'Прочие изделия'      then result := '6';
    if name = 'Материалы'           then result := '3';
end;


initialization
    mngKompas := TKompasManager.Create;

finalization
    mngKompas.Free;


end.
