unit uDataManager;

{ Модуль реализует класс с набором методов, позволяющих манипулировать
  объектами и связями со скрытой от пользователя поддержкой целостности и
  поддержкой архивации изменений.
}

interface

uses  ADODB, DB;

const
    // режимы удаления связки
    DEL_MODE_FULL      = 1;    // полное удаление без учета прав доступа.
                               // опасно, если в пользовательской папке привязаны
                               // системные объекты с uid = 0. будут удалены части
                               // базового дерева
    DEL_MODE_SINGLE    = 2;    // удаление указанной связки
    DEL_MODE_FULL_USER = 4;    // удаление указанной и вложенных, с учетом прав
                               // (только созданные этим пользователем). не принадлежвщие
                               // пользователю связки будут пропущены.
                               // суть в том, что при привязке к пользовательской
                               // папке/объекту сложного объекта, на который ссылаются
                               // другие - они подтягиваются автоматом как вложенные
                               // и при массовом удалении так же будут обнаружены,
                               // что неправильно, поскольку они являются частью
                               // основного дерева.
    DEL_MODE_NO_CROSS  = 8;    // удаление в режиме игнорирования таблицы дополнительных ссылок ( ХХХ_cross )
                               // поскольку, не все схемы ссылок имеют данный механизм.
                               // например, привязка документов к объектам ( [document_object] )
    DEL_MODE_NO_HISTORY = 16;  // удаление без помещения ссылок в историю для случаев
                               // когда восстановление на определенную дату невозможно
                               // например, для рабочих версий файлов, которые
                               // в принципе не хранятся в базе

    // типы объектов, совпадающие со значениями таблицы object_classificator.kind
    KIND_NONE     = 0;
    KIND_SECTION  = 1;
    KIND_SECTION2 = 2;
    KIND_MATERIAL = 3;
    KIND_DETAIL   = 4;
    KIND_STANDART = 5;
    KIND_OTHER    = 6;
    KIND_ASSEMBL  = 7;
    KIND_COMPLEX  = 8;
    KIND_COMPLECT = 9;
    KIND_SPECIF   = 10;
    KIND_ISPOLN   = 11;
    KIND_DOCUMENT = 12;
    KIND_SELECTION = 13;

type

    TArrElem = record
        TableName: string;
        TableFields: string;
    end;

    TDataManager = class

        function AddObject(fields: string; values: array of variant): integer;
                    // добавляем в базу новый объект, возвращаем id записи этого объекта

        function ChangeObject(id: integer; Fields, Values: array of variant; comment: string = ''): boolean;
                    // меняет данные объекта

        function DeleteObject( id: integer; comment: string; to_history: boolean = true): boolean;



        function AddLink(TableName: string; parent, child: integer; uid: integer = -1): integer;
                    // добавляем привязку в указанную таблицу связей.
                    // автоматически формируется набор вспомогательных привязок к родителям более высокого уровня
                    // если подобная связка существует, она скидывается ее в архив (вместе со всеми вспомогательными).
                    // возвращаем id добавленной связки, при неудачном -1

        function CreateCrossLinks(TableName: string; id: integer; rebuild_sublinks: boolean = false): boolean;
                    // создаем дополнительные ссылки на родителей всех уровней указанной связки
        function DeleteCrossLinks(TableName: string; id: integer; comment: string = ''): boolean;
                    // удаляем доп.связи с помещением в архив

        function DeleteLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
        function DeleteLinkBy(TableName: string; parent, child: integer; comment: string = ''): boolean;

        function ChangeLinkParent( TableName: string; id: integer; parent_id: integer; comment: string = ''): boolean;
        function ChangeLinkChild( TableName: string; id: integer; child_id: integer; comment: string = ''): boolean;

        function CreateDocumentVersion( object_id, version_id, doc_type: integer; name, filename, comment: string): integer;
                    // создание нового документа с привязкой к указанному объекту

        function UpdateDocumentVersion( work_version_id: integer ): boolean;
                    // обновляем данные указанной версии. подразумевается, что это
                    // рабочая версия документа, данные которой можно спокойно перезаприсывать

        function SaveWorkDocumentAsVersion( work_version_id: integer ): boolean;
                    // обновляет текущую рабочую версию и переводит ее в статус новой законченной

        function DeleteWorkDocument( work_version_id: integer ): boolean;
                    // удаляет рабочую версию без сохранения

        function TakeDocumentToWork( version_id: integer ): boolean;


        function GetFileFromStorage( path, filename, DBName: string ): boolean;
                    // выгружает файл из хранилища в указанную директрию
        function RemoveFileFromStorage( DBName: string ): boolean;

        function GetObjectSubitems( id: integer; ItemTable, LinkTable: string; query: TDataSet ): TADOQuery;
        function GetDocsList( id: integer; query: TDataSet ): TADOQuery;
        function GetSectionDocsList( id: integer; query: TDataSet ): TADOQuery;

        function UpdateHasDocsFlag( id: integer ): boolean;
                    // приведение к актуальному значению признака наличия привязанных документов у объекта

        function SetInWorkState( child, mode: integer ): boolean;
                    // установка или снятие признака взятия в работу документа

        function GetObjectBy( field, value: string ): integer;

        function GetVersionPath( id: integer; filename: boolean = false ): string;
                    // по id объекта-документа полкчает его данные и строит путь для выгрузки версии на комп пользователя

        function GetNextVersionNumber( name: string; object_id: integer ): integer;
                    // по имени файла и объекту-родителю получает следующий номер версии

        function IsInWork( doc_version_id: integer ): boolean;
                    // по id документа проверяет, не является ли это залоченой версией или ее рабочим документом

        function IsWorkVersion( doc_version_id: integer ): boolean;
                    // по id документа проверяет не является ли это рабочей версией документа
                    // не путать с исходной, которая залочена, но правиться не может

    private
        TableFields: array of TArrElem;
                    // массив со списком неключевых полей таблиц.
                    // используется в механизме перемещения данных из актуальной
                    // таблцы в архивную. в первом упоминании выполняется запрос в базу.
                    // в последующих, данные берутся из данного массива (оптимизируем трафик и нагрузку на БД)

        function ArrToString(arr: array of variant; quoted: boolean = false): string;
                    // элементы динамического одномерного массива склеиваются в строку через запятую
                    // при выставленном флаге - оборачиваются в кавычки
                    // полученная строка подставляется в запросы в качестве списка полей, или значений для INSERT INTO

        function DelLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
                    // удаляет связь, помещая в архив. а так же все подуровни (подветку), если
                    // выставлен флаг clear_childrens

        function BuildUpdateSQL(id: integer; TableName: string; Fields, Values: array of variant): string;
                    // метод формирует UPDATE sql-строку

        function AddFileToStorage( name, filename: string ): boolean;
                    // добавляет файл в базу-хранилище
        function UpdateFileInStorage( name, filename: string ): boolean;
                    // перезаписывает файл в хранилище

        function GetDocsCount( id: integer): integer;
    end;

implementation

{ TDataManager }

uses
    uPhenixCORE, uConstants, SysUtils, Variants, Math, Classes, uMain;

const

    // копирование актуальной связи в архив
    SQL_COPY_TO_HISTORY_BY_ID =
        ' INSERT INTO %s_history '                + sLineBreak +
        ' SELECT TOP 1 *, GETDATE(), %d, ''%s'', 0 ' + sLineBreak +
        ' FROM %s WHERE id = %d ';

    SQL_SELECT_LINK_ID =
        ' SELECT id FROM %s WHERE parent = %d AND child = %d ';
    SQL_SELECT_LINK_DATA =
        ' SELECT * FROM %s WHERE id = %d ';
    SQL_GET_LINK_UID =
        ' SELECT uid FROM %s WHERE id = %d ';
    SQL_GET_CROSS_LINKS_ID =
        ' SELECT id FROM %s_cross WHERE base_link_id = %d ';

    SQL_GET_CHILDS_BY_LINKID =
        ' SELECT * FROM %s WHERE link_id = %d ';
    SQL_GET_ALL_SUB_CHILDS_BY_CROSS =
        ' SELECT DISTINCT(base_link_id) FROM %s_cross WHERE link_id = %d ';
    SQL_GET_CHILDS =
        ' SELECT * FROM %s WHERE parent = %d ';

    SQL_ADD_LINK =
        ' INSERT INTO %s (parent, child, uid, created) VALUES (%d, %d, %d, GETDATE()) ';
    // фактическое удаление ссылки из таблицы актуальных
    SQL_DELETE_LINK =
        ' DELETE FROM %s WHERE parent = %d AND child = %d ';
    SQL_DELETE_LINK_BY_ID =
        ' DELETE FROM %s WHERE id = %d ';

    SQL_GREATE_CROSS_LINKS =
        ' EXEC pdm_CREATE_CROSS_LINKS ''%s'', %d ';
    SQL_DELETE_CROSS_LINKS =
        ' DELETE FROM %s_cross WHERE base_link_id = %d ';

{
    SQL_GET_ALL_TOP_PARENTS_FORCED =
        ' DECLARE @parent int = %d ' +
        ' DECLARE @complete bit = 0 ' +
        ' DECLARE @TEMP TABLE (id INT) ' +
        ' WHILE @complete = 0 ' +
        ' BEGIN ' +
        '     SET @parent = isnull((SELECT parent FROM %s WHERE child = @parent AND fact = %d), 0) ' +
        '     IF @parent = 0 SET @complete = 1 ' +
        '     IF @parent <> 0 INSERT INTO @TEMP (id) VALUES (@parent) ' +
        ' END ' +
        ' SELECT id FROM @TEMP ';
}
    SQL_ADD_OBJECT =
        ' INSERT INTO '+TBL_OBJECT+' (%s) VALUES (%s) ';

    SQL_GET_FILE_DATA =
        ' SELECT * FROM '+TBL_FILE+' WHERE name = ''%s'' ';
    SQL_OPEN_FILE_TABLE =
        ' SELECT TOP 1 * FROM '+TBL_FILE;
    SQL_REMOVE_FROM_TABLE =
        ' DELETE FROM %s WHERE %s = ''%s'' ';

    SQL_GET_MAX_VERSION =
//        ' SELECT Max(version) FROM '+VIEW_DOCUMENT+' WHERE doc_name = ''%s''';
        ' SELECT Max(version) FROM '+TBL_DOCUMENT_EXTRA+' WHERE fullname like ''%s{%d_';
        // получение текущего максимального номера версии указанного документа
        // с учетом объекта, к которому привязан (в рамках разных объектов допустимы
        // одинаковые файлы)

    SQL_CREATE_DOCEXTRA =
        ' INSERT INTO '+TBL_DOCUMENT_EXTRA+' (object_id, version, filename, [type], fullname, hash) VALUES (%d, %d, ''%s'', %d, ''%s'', ''%s'') ';

    SQL_GET_SUBITEMS =
        ' DECLARE @id int = %d '+
        ' SELECT DISTINCT(name), icon, kind, child, has_docs, mark, count FROM %s '+
        ' WHERE child in ( '+
        '     SELECT child FROM %s '+
        '     WHERE id in ( '+
        '         SELECT base_link_id FROM %s_cross '+
        '         WHERE link_id = @id AND base_link_id <> @id)) ';

    SQL_GET_DOC_VERSIONS =
        ' SELECT * FROM ' + VIEW_DOCUMENT + ' WHERE parent = %d ';
    SQL_GET_SECTION_DOC_VERSIONS =
        ' SELECT * FROM ' + VIEW_INWORK;
//        ' SELECT * FROM ' + VIEW_DOCUMENT + ' WHERE minor_version IS NOT NULL )';

    SQL_SET_DOCUMENT_INWORK_STATE =
        ' UPDATE ' + TBL_DOCUMENT_EXTRA + ' SET work_uid = %d WHERE object_id = %d ';

    SQL_GET_OBJECT_ID_BY =
        ' SELECT id FROM ' + TBL_OBJECT + ' WHERE %s = ''%s''' ;

    SQL_GET_TABLE_DATA =
        ' SELECT * FROM %s WHERE %s = ''%s'' ';

    SQL_GET_INWORK_LINK =
        ' DECLARE @ID int = %d ' +
        ' SELECT * FROM '+LNK_DOCUMENT_INWORK+' WHERE parent = @ID OR child = @ID ';

function TDataManager.AddFileToStorage( name, filename: string ): boolean;
{ метод добавляет в хранилище указанный файл.

  подразумевается, что Name является уникальным для таблицы значением, и уже
  подготовлено с добавлением номера версии.

  filename - полный путь с именем самого файла
}
label ext;
var
    FileStream: TFileStream;
    BlobStream: TStream;
    Query: TADOQuery;
begin

    lC('AddFileToStorage');
    result := false;

    // проверка наличия файла
    if Not FileExists(filename) then
    begin
        Core.DM.DBError := LE('Файл '+filename+' отсутствует.');
        goto ext;
    end;

    // открываем таблицу, сразу пытаемся найти повтор файла
    Query := Core.DM.OpenQueryEx( Format( SQL_GET_FILE_DATA, [ name ] ));
    if Not Assigned(Query) then goto ext;

    // есть повтор
    if not Query.IsEmpty then
    begin
        Core.DM.DBError := LE('Файл с именем '+name+' уже есть в базе данных. Дублирование не допускается.');
        goto ext;
    end;

    // открываем таблицу-хранилище
    Query := Core.DM.OpenQueryEx( SQL_OPEN_FILE_TABLE );

    // добавляем новый
    Query.Insert;
    Query.FieldByName('name').AsString := name;

    try

        // заливаем файл в поле
        BlobStream := Query.CreateBlobStream( Query.FieldByName('file_stream'), bmWrite );
        FileStream := TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
        BlobStream.CopyFrom( FileStream, FileStream.Size );

        // закрываем потоки для корректного завершения операции
        FreeAndNil( BlobStream );
        FreeAndNil( FileStream );

        Query.Post;

        result := true;

    except
        on E: Exception do
        begin
            Core.DM.DBError := LE( E.Message );
            Query.Cancel;
        end;
    end;

ext:
    lCE;
end;

function TDataManager.GetDocsCount( id: integer): integer;
begin
    dmOQ( Format( SQL_GET_DOC_VERSIONS, [ id ] ));
    result := Core.DM.Query.RecordCount;
end;

function TDataManager.GetDocsList(id: integer; query: TDataSet): TADOQuery;
{ для указанного объекта получить набор данных со всеми версиями всех документов.
  возвращаемый датасет подставляется как источник данных для таблицы grdDocs
}
begin
    result := Core.DM.OpenQueryEx( Format( SQL_GET_DOC_VERSIONS, [ id ] ), query );
end;

function TDataManager.GetFileFromStorage( path, filename, DBName: string): boolean;
{ метод выгружает файл из хранилища файлов на локальный компьютер
  path - путь для выгрузки
  filename - имя файла с расширением, под которым сохранить
  DBname - имя файла в хранилище [FilesDB].[PDMFiles].[name]

  подразумевается, что путь сформирован с учетом версионности, т.е. уже
  созданы все подпапки для данного файла и указанный путь существует.

  По умолчанию, базовый путь с:\im\imwork\pdm\
}
label ext;
var
    FileStream: TFileStream;
    BlobStream: TStream;

begin
    lC('TDataManager.GetFileFromStorage');
    result := false;

    // контроль наличия указанной директории
    if not DirectoryExists( path ) then
    if not CreateDir( path ) then
    begin
        Core.DM.DBError := lW('Директрия '+ path + ' не существует или не может быть создана.');
        goto ext;
    end;

    // получаем данные из базы
    if not dmOQ( Format( SQL_GET_FILE_DATA, [ DBname ] )) then goto ext;

    if not Core.DM.Query.Active or ( Core.DM.Query.RecordCount = 0 ) then
    begin
        Core.DM.DBError := lW('Файл '+ DBname + ' в хранилище не обнаружен.');
        goto ext;
    end;

    // создаем файл, куда заливаем из базы
    if   FileExists( path + filename )
    then DeleteFile( path + filename );

    if   not FileExists( path + filename )
    then FileCLose( FileCreate( path + filename ) );

    if   not FileExists( path + filename ) then
    begin
        Core.DM.DBError := lW('Не удалось создать файл '+ filename );
        goto ext;
    end;


    BlobStream := Core.DM.Query.CreateBlobStream( Core.DM.Query.FieldByName('file_stream'), bmRead );
    FileStream := TFileStream.Create( path + fileName, fmOpenWrite );
    FileStream.CopyFrom( BlobStream, BlobStream.Size );

    // закрываем потоки для корректного завершения операции
    FreeAndNil( FileStream );
    FreeAndNil( BlobStream );

    result := true;

ext:
    lCE;
end;

function TDataManager.GetNextVersionNumber(name: string; object_id: integer ): integer;
begin
    result := Integer( dmSDQ( Format( SQL_GET_MAX_VERSION, [ name, object_id ] )+'%''', 0 )) + 1;
    // здесь обход глюка метода Format, сжирающего % в строке, относящийся к like запроса,
    // считая его некорректным аргументом для подстановки. приклеиваем процент после подстановки
    // значений в строку запроса
end;

function TDataManager.GetObjectBy(field, value: string): integer;

begin
    result := dmSDQ( Format( SQL_GET_OBJECT_ID_BY, [ field, value ] ), 0);
end;

function TDataManager.GetObjectSubitems(id: integer; ItemTable,
  LinkTable: string; query: TDataSet): TADOQuery;
{ для указанного объекта получить набор данных со всеми вложенными объектами.
  возвращаемый датасет подставляется как источник данных для таблицы grdObject
}
begin
    result := Core.DM.OpenQueryEx( Format( SQL_GET_SUBITEMS, [ id, ItemTable, LinkTable, LinkTable ] ), query);
end;

function TDataManager.GetSectionDocsList(id: integer; query: TDataSet ): TADOQuery;
begin
    result := Core.DM.OpenQueryEx( Format( SQL_GET_SECTION_DOC_VERSIONS, [ id ] ), query);
end;

function TDataManager.GetVersionPath( id: integer; filename: boolean = false ): string;
begin
    result := '';

    if not dmOQ( Format( SQL_GET_TABLE_DATA, [ VIEW_DOCUMENT, 'child', IntToStr(id) ])) then exit;
    result :=
        DIR_DOCUMENT +
        Core.DM.Query.FieldByName('object_name').AsString + '\' +
        Core.DM.Query.FieldByName('doc_name').AsString + '\' +
        Core.DM.Query.FieldByName('version').AsString + '\';

    if   filename
    then result := result + Core.DM.Query.FieldByName('doc_name').AsString;
end;

function TDataManager.IsInWork(doc_version_id: integer): boolean;
{ проверяем, не является ли указанный документ взятым в работу или
  рабочей версией.
  это так, если документ упоминается в таблице document_inwork в качестве
  родителя (исходная версия) или потомка (рабочая версия)
 }
begin
    dmOQ( Format( SQL_GET_INWORK_LINK, [ doc_version_id ] ));
    result := Core.DM.Query.Active and (Core.DM.Query.RecordCount > 0);
end;

function TDataManager.IsWorkVersion(doc_version_id: integer): boolean;
{ проверка версии документа на то, что она явдяется рабочей версией
  (куда сохраняются все изменения до тех пор, пока она не будет сохранена,
   как неизменяемая новая версия)
}
begin
    result := false;
    dmOQ( Format( SQL_GET_INWORK_LINK, [ doc_version_id ] ));
    while not Core.DM.Query.EOF do
    begin
        if   Core.DM.Query.FieldByName('child').AsInteger = doc_version_id
        then result := true;
        Core.DM.Query.Next;
    end;
end;

function TDataManager.RemoveFileFromStorage(DBName: string): boolean;
begin
    result := dmEQ( Format( SQL_REMOVE_FROM_TABLE, [ TBL_FILE, 'name', DBName ] ));
end;

function TDataManager.SaveWorkDocumentAsVersion(
  work_version_id: integer): boolean;
{ метод обновляет текущую рабочую версию из файла
  и переводит рабочую версию в статус завершенной (следующей по номеру от исходной)
}
var
    query: TADOQuery;
    filename : string;
begin
    result := false;

    // сохраняем последние изменения рабочей версии
    if not UpdateDocumentVersion( work_version_id ) then exit;

    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ VIEW_INWORK, 'child', IntToStr(work_version_id) ]) );

    // удаляем связку рабочей версии с исходной, что делает ее самостоятельной
    mngData.DeleteLink(
        LNK_DOCUMENT_INWORK,
        query.FieldByName('link_id').AsInteger,
        DEL_MODE_NO_CROSS + DEL_MODE_SINGLE + DEL_MODE_NO_HISTORY
    );

    // удяляем рабочий файл(-ы) и папку версии
    filename := mngData.GetVersionPath( query.FieldByName('child').AsInteger, true );

    if FileExists( filename ) then
    begin
        DeleteFile( filename );
        RemoveDir( ExtractFilePath( filename ));
    end;

    result := true;
end;

function TDataManager.SetInWorkState(child, mode: integer): boolean;
{ метод меняет признак взятия в работу документа
  child - id объекта-документа
  mode - режим в который нужно выставить признак:
       0 - не в таботе, при этом сбрасывается и work_id (редактор)
       1 - в работе, при этом устанавливается и work_id (редактор)
}
begin
    result := false;

    if not dmEQ( Format( SQL_SET_DOCUMENT_INWORK_STATE, [ mode, ifthen( mode = 0, 0, Core.User.id), child ] )) then exit;

    result := true;
end;

function TDataManager.TakeDocumentToWork(version_id: integer): boolean;
{ взятие документа в работу.
  предполагается, что документ (version_id) еще не имеет рабочей версии.

  Алгоритм:
  - исходная версия получает признак блокировки
  - выгружаем документ на машину пользователя (в темп, для создания новой версии)
  - создаем рабочую версию для указанного документа с новым номером и блокировкой
  - создаем для рабочей версии привязку к исходной, что позволит ей отобразиться в списке раздела Документы в работе
  - выгружаем рабочий файл в рабочую папку
}
label ext;
var
    query: TADOQUery;
    dir : string;

    work_version_id
   ,link_id
            : integer;
begin
    lE('TakeDocumentToWork');
    result := false;

    // получаем данные текущей версии
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA,[ VIEW_DOCUMENT, 'child', IntToStr(version_id) ] ));
    if not Assigned(query) then goto ext;

    // выгружаем файл в темповую папку для последующей загрузки в рабочую версию
    GetFileFromStorage( DIR_TEMP, query.FieldByName('filename').AsString, query.FieldByName('fullname').AsString );

    // создаем рабочую версию документа
    work_version_id :=
        CreateDocumentVersion(
            query.FieldByName('parent').AsInteger,             // объект-владелец
            query.FieldByName('child').AsInteger,              // исходная версия
            query.FieldByName('type').AsInteger,               // тип документа
            query.FieldByName('filename').AsString,            // имя документа с расширением
            DIR_TEMP + query.FieldByName('filename').AsString, // откуда загружать в хранилище
            ''                                                 // комментарий
         );
    if work_version_id = 0 then goto ext;

    // связываем исходную и рабочую версию
    link_id := AddLink( LNK_DOCUMENT_INWORK, version_id, work_version_id );
    if link_id = 0 then goto ext;

    if not dmEQ( BuildUpdateSQL( link_id, LNK_DOCUMENT_INWORK, ['minor_version'], [query.FieldByName('minor_version').AsFloat + 0.001] ) ) then goto ext;

    // получаем полный рабочий путь для выгрузки файла
    dir := GetVersionPath( work_version_id );

    // создаем рабочую папку
    ForceDirectories( dir );

    // получаем данные рабочей версии
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA,[ VIEW_DOCUMENT, 'child', IntToStr(work_version_id) ] ));
    if not Assigned(query) then goto ext;

    // выгружаем документ в папку
    if not GetFileFromStorage( dir, query.FieldByName('filename').AsString, query.FieldByName('fullname').AsString ) then goto ext;
    // так же, выгружаем все вложенные файлы, если документ комплексный,
    // но при этом, выгрузка идет в папку с основным документом
{    if dataset.FieldByName('is_complex').AsInteger <> 0 then
    begin
        subfiles := mngData.GetSubfiles(  );
        while not subfiles.Eof do
        begin
            if not mngData.GetFileFromStorage( dir, subfiles.FieldByName('name').AsString, subfiles.FieldByName('fullname').AsString ) then goto ext;
            subfiles.Next;
        end;

    end;
}
    result := true;

ext:
    lCE;
end;

function TDataManager.UpdateDocumentVersion(work_version_id: integer): boolean;
{ метод обновляет данные указанной версии документа.
  предполагается, что это рабочая версия документа, при сохранении которой
  не создается новой версии. файл в хранилище перезаписывается и увеличивается
  минорная версия (редакция) дкумента.

  - получаем путь до рабочей версии файла
  - в хранилище документ перезаписывается текущей версией с локальной машины редактора
  - обновляется значение хэша файла
  - номер минорной версии увеличивается на 1
}
label ext;
var
    filename
   ,fullname
   ,hash
            : string;
    query
            : TADOQuery;
begin

    lC('UpdateDocumentVersion');
    result := false;

    // проверка на то, что мы работаем именно с рабочей версией. проверка, по идее,
    // избыточная, но пусть будет на всякий случай
    if not IsWorkVersion( work_version_id ) then
    begin
        Core.DM.DBError := lW( 'Документ ('+IntToStr(work_version_id)+') не является рабочей версией.');
        goto ext;
    end;

    // получаем полое имя рабочего файла
    filename := mngData.GetVersionPath( work_version_id, true );

    // проверяем на наличие. файл мог быть случайно удален или перемещен
    if not FileExists( filename ) then
    begin
        Core.DM.DBError := lW( 'Рабочий файл документа не существует.'+sLineBreak+'('+filename+')');
        goto ext;
    end;

    // получаем данные рабочей версии и обновляем файл в хранилище
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ VIEW_DOCUMENT, 'child', IntToStr(work_version_id) ] ));
    if   not Assigned( query ) then goto ext;

    UpdateFileInStorage( query.FieldByName('fullname').AsString, filename );

    // получаем текущий хзш файла и обновляем данные рабочей версии
    hash := mngFile.GetHash( filename );

    if not dmEQ( BuildUpdateSQL( work_version_id, TBL_DOCUMENT_EXTRA, ['hash'], [hash] ) ) then goto ext;

    // обновляем номер минорной версии
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ LNK_DOCUMENT_INWORK, 'child', IntToStr(work_version_id) ] ));

    if not dmEQ( BuildUpdateSQL( query.FieldByName('id').AsInteger, LNK_DOCUMENT_INWORK, ['minor_version'], [query.FieldByName('minor_version').AsFloat + 0.001] ) ) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.UpdateFileInStorage(name, filename: string): boolean;
{ метод добавляет в хранилище указанный файл.

  подразумевается, что Name является уникальным для таблицы значением, и уже
  подготовлено с добавлением номера версии.

  filename - полный путь с именем самого файла
}
label ext;
var
    FileStream: TFileStream;
    BlobStream: TStream;
    Query: TADOQuery;
begin

    lC('UpdateFileInStorage');
    result := false;

    // проверка наличия файла
    if Not FileExists(filename) then
    begin
        Core.DM.DBError := LE('Файл '+filename+' отсутствует.');
        goto ext;
    end;

    // открываем хранилище с нужным файлом
    Query := Core.DM.OpenQueryEx( Format( SQL_GET_FILE_DATA, [ name ] ));
    if Not Assigned(Query) then goto ext;

    // обновяем данные файла
    Query.Edit;

    try

        // заливаем файл в поле
        BlobStream := Query.CreateBlobStream( Query.FieldByName('file_stream'), bmWrite );
        FileStream := TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
        BlobStream.CopyFrom( FileStream, FileStream.Size );

        // закрываем потоки для корректного завершения операции
        FreeAndNil( BlobStream );
        FreeAndNil( FileStream );

        Query.Post;

        result := true;

    except
        on E: Exception do
        begin
            Core.DM.DBError := LE( E.Message );
            Query.Cancel;
        end;
    end;

ext:
    lCE;
end;

function TDataManager.UpdateHasDocsFlag(id: integer): boolean;
{ для указанного объекта, проверяем наличие привязанных документов.
  при наличии, устаналиваем флаг в поле [object].[has_docs] = 1, иначе = 0 }
begin

    result := false;

    // выставляем признак
    if not ChangeObject( id, ['has_docs'], [ ifthen( GetDocsCount(id) > 0, 1, 0 ) ] ) then exit;

    result := true;

end;

function TDataManager.AddLink(TableName: string; parent, child: integer; uid: integer = -1): integer;
{ добавление новой связки в указанную таблицу связей
 (без учета дополнительных полей, кроме: UID, FACT, CREATED)
  перед вставкой проверяется наличие подобной связки в таблице.
  при обнаружении - она отправляется в архив и удаляется из актуальной таблицы
  после создания связки возвращаем флаг успешности операции.

  tablename - имя таблицы, в которой будет создаваться связка (навигация или обюъекты)
  parent, child - id связываемых объектов
  uid - id пользователя к которому будет приписано авторство. если не указано,
        привязывается текущий пользователь. при передаче 0, связка будет считаться
        системной и пользователи не смогут ее редактировать

  ВАЖНО!
  следует помнить, что для корректной работы требуется создать еще и вспомогательные
  ссылки для этой связки методом CreateCrossLinks
}
label ext;
begin
    lC('TDataManager.AddLink');
    result := 0;

    // если подобная связь уже есть - оставляем все как есть
    if dmSDQ( Format( SQL_SELECT_LINK_ID, [TableName, parent, child] ), 0 ) <> 0 then goto ext;

    // создаем новую связь
    result := dmIQ( Format( SQL_ADD_LINK, [TableName, parent, child, ifthen(uid <> -1, uid, Core.User.id) ] ));

ext:
    lCE;
end;


function TDataManager.DeleteLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
{ аналог удаления связи для случая, когда известен ee id }
begin

    result := DelLink( TableName, id, mode, comment );

end;


function TDataManager.DeleteLinkBy(TableName: string; parent, child: integer; comment: string = ''): boolean;
// аналог удаления связи для случая, когда известны данные родитель-потомок
begin

    result := DelLink(
                  TableName,
                  dmSQ( Format( SQL_SELECT_LINK_ID, [TableName, parent, child] )),
                  DEL_MODE_SINGLE,
                  comment
              );

end;

function TDataManager.DeleteObject(id: integer; comment: string; to_history: boolean): boolean;
label ext;
begin
    lC('TDataManager.DeleteObject');
    result := false;

    // кидаем текущее состояние объекта в архив
    if to_history then
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TBL_OBJECT, Core.User.id, Comment, TBL_OBJECT, id] )) then goto ext;

    // удаляем из актуальной таблицы
    if not dmEQ( Format( SQL_DELETE_LINK_BY_ID, [TBL_OBJECT, id] )) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.DelLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
{ копирует данные связи в архив, заполняя дополнительные поля:
  id пользователя сделавшего изменение, дату изменения, комментарий
  дополнительно архивируются и текущие дополнительные связки

  TableName - имя таблицы связей, с которой работаем, например: 'navigation', 'structure'
  id - связка в указанной таблице
  mode - режим удаления связки. локальное, либо со всем вложенными связями
  comment - текстовое описание операции

  удаление в дереве изделия
  - удаляется только конкретная связка с очисткой допсвязей всех вложенных связей
    поскольку ветка не должна разрушатся, являясь сборочной единицей или комплексом.

  удаление в дереве навигации
  - поскольку удалять можно только свои элементы и содержать они могут только
    свои же элементы, при удалении связки удаляются все вложенные со всеми допсвязями
    для сохранения внутренних связей, предполагается, что пользователь предварительно
    переместил их в другое место.

 }
var
   subchilds : TADOQuery;
   uid : integer;
label ext;
begin

    lC('TDataManager.DeleteLink');
    result := false;


    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;


    // архивация связки, если нужно
    if mode and DEL_MODE_NO_HISTORY = 0 then
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TableName, Core.User.id, Comment, TableName, id] )) then goto ext;

    // удаляем целевую связь
    if not dmEQ( Format( SQL_DELETE_LINK_BY_ID, [TableName, id] )) then goto ext;

    // если не запрещено обрабатывать дополнительные ссылки
    if mode and DEL_MODE_NO_CROSS = 0 then
    begin
        if not DeleteCrossLinks( TableName, id, comment ) then goto ext;

        // получаем список всех потомков по имеющимся допссылкам
        subchilds := Core.DM.OpenQueryEx( Format( SQL_GET_ALL_SUB_CHILDS_BY_CROSS, [ TableName, id ] ));
        if not Assigned( subchilds ) then goto ext;

        while not subchilds.eof do
        begin
            // архивируем и удаляем допссылки связки
            if not DeleteCrossLinks( TableName, subchilds.Fields[0].AsInteger, comment ) then goto ext;

            uid := Integer(dmSQ( Format( SQL_GET_LINK_UID, [ TableName, subchilds.Fields[0].AsInteger ] )));

            // если режим тотального уничтожения
            // либо режим удаления пользовательских и это пользовательская связка
            if ( mode = DEL_MODE_FULL ) or
               (
                  ( mode = DEL_MODE_FULL_USER ) and
                  ( uid = Core.User.id )
               )
            then
            begin
                if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [ TableName, Core.User.id, Comment, TableName, subchilds.Fields[0].AsInteger ] )) then goto ext;
                if not dmEQ( Format( SQL_DELETE_LINK_BY_ID, [ TableName, subchilds.Fields[0].AsInteger ] )) then goto ext;
            end;

            // для локального удаления связки перестраиваем набор вспомогательных связей вложенной
            if mode = DEL_MODE_SINGLE then
            if not CreateCrossLinks( TableName, subchilds.Fields[0].AsInteger ) then goto ext;

            subchilds.Next;
        end;

    end;

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.CommitTrans;

    result := true;

ext:
    // при неудачном удалении транзакция будет открыта
    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
end;

function TDataManager.AddObject(fields: string; values: array of variant): integer;
{ метод создает новый объект и возвращает его id
  fields - строка названий полей через запятую для которых предоставлены данные
  values - одномерный массив со значениями для полей из fields, идущие в том же порядке
}
var
    val: string;
begin
    lC('TDataManager.AddObject');
    try
        result := 0;

        lM('fields = ' + fields);

        // собираем значения для полей в строку
        val := ArrToString(values, true);
        lM('values = ' + val);

        // подставляем данные для обязательных полей, если они не упомянуты
        if pos('UID', AnsiUpperCase(fields)) = 0 then
        begin
            fields := fields + ',uid';
            val := val + ',' + IntToStr(Core.User.id);
        end;

        if pos('CREATED', AnsiUpperCase(fields)) = 0 then
        begin
            fields := fields + ',created';
            val := val + ',GETDATE()';
        end;

        // создаем объект
        result := dmIQ( Format( SQL_ADD_OBJECT, [ fields, val ] ));

    except
        on e: Exception do
        begin
            lE( e.Message );
            lCE;
        end;

    end;

    lCE;
end;

function TDataManager.ChangeObject( id: integer; Fields, Values: array of variant;
  comment: string): boolean;
{ метод меняет данные связи, сохраняя предыдущую версию в архиве
  Fields, Values - одномерный динамический массив. имена полей и значения в том же порядке как и в Fields
}
label ext;
begin
    lC('TDataManager.ChangeObject');
    result := false;

    // кидаем текущее состояние объекта в архив
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TBL_OBJECT, Core.User.id, Comment, TBL_OBJECT, id] )) then goto ext;

    // изменяем актуальное состояние
    // и обновляем новыми данными
    if not dmEQ( BuildUpdateSQL( id, TBL_OBJECT, Fields, Values ) ) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.ChangeLinkParent(TableName: string; id, parent_id: integer;
  comment: string): boolean;
{ метод отрабатывает изменение родителя в связке.
  требуется перестроить непрямые ссылки всех привязанных к данному child.

  tablename - имя таблицы связей
  id - связка в таблице
  parent_id - новый объект-родитель

  Алгоритм:
      1. текущее состояние связки сбрасывается в архив
      2. обновляется parent
      3. для связки сбрасывается набор вспомогательных связей
      4. для связки строится набор вспомогательных связей
      5. получаем всех child всех уровней для этой связки
      6. для каждого полученного child производим п.п.4, 5
}
label ext;
var
    query: TADOQuery;
begin
    lC('TDataManager.ChangeLinkChild');
    result := false;

//    if not Core.DM.ADOConnection.InTransaction
//    then   Core.DM.ADOConnection.BeginTrans;

    // 1. помещаем в архив текущее состояние связи
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TableName, Core.User.id, Comment, TableName, id] )) then goto ext;

    // 2. и обновляем новыми данными
    if not dmEQ( BuildUpdateSQL( id, TableName, ['parent'], [parent_id] ) ) then goto ext;

    // 3. для связки сбрасывается набор вспомогательных связей
    if not DeleteCrossLinks( TableName, id, comment ) then goto ext;

    // 4. строится набор вспомогательных связей
    if not CreateCrossLinks( TableName, id ) then goto ext;

    // 5. получаем список всех потомков по имеющимся допссылкам
    query := Core.DM.OpenQueryEx( Format( SQL_GET_ALL_SUB_CHILDS_BY_CROSS, [ TableName, id ] ));
    if not Assigned( query ) then goto ext;

    // 6. обновление допсвязок всех потомков
    while not query.eof do
    begin

        // для связки сбрасывается набор вспомогательных связей
        if not DeleteCrossLinks( TableName, query.Fields[0].AsInteger, comment ) then goto ext;

        // строится набор вспомогательных связей
        if not CreateCrossLinks( TableName, query.Fields[0].AsInteger ) then goto ext;

        query.Next;

    end;

    // успешно завершаем транзакцию
//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.CommitTrans;

    result := true;

ext:
    // при возникновении ошибки транзакция не будет закрыта
//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
end;

function TDataManager.ChangeLinkChild(TableName: string; id, child_id: integer;
  comment: string): boolean;
{ метод отрабатывает изменение потомка в связке.
  для текущей связи это будет изменение потомка, без каких либо еще изменений,
  а для всех вложенных связей это будет операция смены родителя.

  tablename - имя таблицы связей
  id - связка в таблице
  child_id - новый объект-потомок

  Алгоритм:
      1. текущее состояние связки сбрасывается в архив
      2. обновляется child
      3. для связки выбираются все непосредственные потомки
      4. для каждого потомка производится замена родителя и перестройка связок
      5. так же перестройка связок произодтся для всех потомков теукущей обрабатываемой
}
label ext;
var
    query: TADOQuery;
    parent : integer;
begin
    lC('TDataManager.ChangeLinkChild');
    result := false;

//    if not Core.DM.ADOConnection.InTransaction
//    then   Core.DM.ADOConnection.BeginTrans;

    // получаем текущего child для дальнейшего поиска непосредственных связей-потомков
    if not dmOQ( Format( SQL_SELECT_LINK_DATA, [ TableName, id ] )) then goto ext;
    parent := Core.DM.Query.FieldByName('child').AsInteger;

    // 1. помещаем в архив текущее состояние связи
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TableName, Core.User.id, Comment, TableName, id] )) then goto ext;

    // 2. и обновляем новыми данными
    if not dmEQ( BuildUpdateSQL( id, TableName, ['child'], [child_id] ) ) then goto ext;

    // 3. непосредственные потомки
    query := Core.DM.OpenQueryEx( Format( SQL_GET_CHILDS, [TableName, parent] ));
    if not Assigned( query ) then goto ext;

    // 4., 5. обновляем всех потомков, вместе с допссылками
    while not query.eof do
    begin
        if not ChangeLinkParent( TableName, query.FieldByName('id').AsInteger, parent ) then goto ext;
        query.Next;
    end;

//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.CommitTrans;
    result := true;

ext:
    // при возникновении ошибки транзакция не будет закрыта
//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
end;

function TDataManager.CreateCrossLinks(TableName: string; id: integer; rebuild_sublinks: boolean = false): boolean;
{ метод вызывает хранимую процедуру, которая создает вспомогательные ссылки
  для указанной связи.
  предполагается, что они отсутствуют да данный момент. проверка на дублирование
  вспомогательных связей отсутсвует.
  так же, возможно что потомок создаваемой связки является потомком для других
  связок. в данном случае требуется найти все вложенные связки и пересозать их
  допсвязи.

  TableName - имя таблицы связей в которой ищем связки
  id - связка для которой создавать допссылки, от ее же CHILD ищем всех потомков
}
label ext;
type
    TElem = record
        link_id: integer;
        child : integer;
    end;
var
    query: TADOQuery;
    arr: array of TElem;
    i: integer;
    child_id : integer;

    // получаем потомки-связки по id связки
    procedure GetChildLinks( id: integer );
    begin
        if not dmOQ( Format( SQL_GET_CHILDS, [ TableName, id ] )) then exit;
        while not Core.DM.Query.Eof do
        begin
            SetLength( arr, Length(arr)+1 );
            arr[ High(arr) ].link_id := Core.DM.Query.FieldByName('id').AsInteger;
            arr[ High(arr) ].child := Core.DM.Query.FieldByName('child').AsInteger;
            Core.DM.Query.Next;
        end;
    end;

begin
    lC('TDataManager.CreateCrossLinks');
    result := false;

    if id = 0 then goto ext;

    // создаем допссылки для указанной связки
    if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [TableName, id] )) then goto ext;

    // перелинковка всех потомков при единичном добавлении элемента
    // не рекомендуется при массовом создании элементов, поскольку приводит к
    // страшным тормозам из-за избыточности операций.
    if rebuild_sublinks then
    begin

        // по child новой связки ищем все связки, которые ссылаются на него как на родителя
        dmOQ( Format( SQL_SELECT_LINK_DATA, [ TableName, id ] ) );
        child_id := Core.DM.Query.FieldByName('child').AsInteger;
        GetChildLinks( child_id );

        // перебирая массив, дополняем его потомками рассматриваемой связки
        // при завершении перебора массива будет получен набор id всех связок-потомков
        // корневой связки
        if Length( arr ) > 0 then
        begin

            i := 0;
            while i <= High(arr) do
            begin
                GetChildLinks( arr[i].child );
                Inc(i);
            end;

            // обновление допсвязей
            for i := 0 to High(arr) do
            begin

                // архивируем и удаляем текущие допсвязи связки
//                if not DeleteCrossLinks( TableName, arr[i].link_id ) then goto ext;

                // создаем допсвязки для указанной связки уже с учетом новой созданой
                if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [ TableName, arr[i].link_id ] )) then goto ext;

            end;
        end;
    end;

    result := true;
ext:
    lCE;
end;

function TDataManager.CreateDocumentVersion(object_id, version_id, doc_type: integer; name, filename, comment: string): integer;
{ добавление нового документа в базу с привязкой к указанному объекту.

  ВАЖНО! не проверяется наличие данного документа в привязке к другим объектам-изделиям,
  что должно отслеживаться до выхова данного метода, поскольку позволяет реализовать
  либо жесткую уникальность одного документа для любого объекта, либо вести версионность
  только в рамках конкретного объекта.

  например, в исполнениях детали, каждая является модификацией исходной и является
  отдельным объектом с наименованием имеющим суффикс '-01', '-02' и т.д., но
  при этом, каждое исполнение привязано к одному и тому же чертежу.

  в случае жестокой уникальности, версии чертежа будут распространяться по всем исполнениям.

  при дополнительной привязке к объекту-изделию, версии будут вестись в рамках конкретного объекта
  и каждый может иметь в итоге разный набор версий с разными итоговыми чертежами. однако, это может
  привести к проблемам пересечения номеров версий при взятии их в работу с разных исполнений,
  поскольку это приведет к их взаимной перезаписи в темповых папках на локальной машине пользователя.
  так же, начнутся пересечения имен файлов в файловом хранилище поскольку в обоих
  случаях в качестве идетнификатора используется сочетание имени и версии

  object_id - объект, к которому привязывается новый документ
  version_id - объект документа, являющегося основой для этой новой версии.
  doc_kind  - тип документа. id из таблицы-справочника document_type
  version   - номер версии файла
  name      - имя файла, которое будет идентификатором для связки таблиц [PDM].[Document_extra] и [FilesDB].[PDMFiles]
  filename  - полный путь до файла

  Алгоритм
  - создаем новый объект типа документ в таблице object
  - создаем и привязываем к нему запись с допданными в таблице document_extra
  - загружаем указанный файл в хранилище [FilesDB].[PDMFiles]
}
label ext;
var
    doc_id
   ,version
            : integer;
    fullname
   ,hash
            : string;
begin

    lC('CreateDocumentVersion');
    result := 0;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    // новый объект документа
    doc_id := AddObject('kind, name, comment', [ KIND_DOCUMENT, name, comment ]);
    if doc_id = 0 then goto ext;

    // привязываем документ к изделию
    if AddLink( LNK_DOCUMENT_OBJECT, object_id, doc_id ) = 0 then goto ext;

    // ставим объекту-изделию признак наличия привязанных документов
    if not ChangeObject( object_id, ['has_docs'], [1] ) then goto ext;

    // определяемся с номером версии
    version := GetNextVersionNumber( name, object_id );
{    version := 1;
    if version_id <> 0 then
    version := Integer( dmEQ( Format( SQL_GET_MAX_VERSION, [ name ] ))) + 1;
}
    // уникальное имя с учетом номера версии и родителя для хранилища файла
    fullname := Format( '%s{%d_%d_%d}', [ ExtractFileName( filename ), object_id, doc_id, version ] );

    // хэш сумма файла для отслеживания наличия изменений при создании новых версий из данной
    hash := mngFile.GetHash( filename );

    // создаем запись с дополнительными данными документа
    if not dmEQ( Format( SQL_CREATE_DOCEXTRA, [doc_id, version, name, doc_type, fullname, hash] )) then goto ext;

    // добавляем файл в хранилище
    if not AddFileToStorage( fullname, filename ) then goto ext;

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.CommitTrans;

    result := doc_id;
ext:

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
end;

function TDataManager.DeleteWorkDocument(work_version_id: integer): boolean;
label ext;
var
    query: TADOQuery;
    filename : string;
begin

    lC('CreateDocumentVersion');
    result := false;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ VIEW_INWORK, 'child', IntToStr(work_version_id) ]) );
    if not Assigned(query) then goto ext;

    // удаляем связку рабочей версии с исходной, что делает ее самостоятельной
    if not DeleteLink(
        LNK_DOCUMENT_INWORK,
        query.FieldByName('link_id').AsInteger,
        DEL_MODE_NO_CROSS + DEL_MODE_SINGLE + DEL_MODE_NO_HISTORY
    ) then goto ext;

    // удяляем рабочий файл(-ы) и папку версии
    filename := mngData.GetVersionPath( query.FieldByName('child').AsInteger, true );
    if filename = '' then goto ext;

    DeleteFile( filename );
    RemoveDir( ExtractFilePath( filename ));

    // удаляем файл из хранилища
    if not RemoveFileFromStorage( query.FieldByName('fullname').AsString ) then goto ext;

    // удаляем привязку документа
    if not DeleteLink( LNK_DOCUMENT_OBJECT, query.FieldByName('document_object_link_id').AsInteger, DEL_MODE_NO_CROSS + DEL_MODE_SINGLE ) then goto ext;

    // удаляем объект рабочей версии из базы (без занесения в истрию)
    if not DeleteObject( query.FieldByName('child').AsInteger, '', false ) then goto ext;

    // удаляем запись из расширенной тпблицы свойств документа
    if not dmEQ( Format( SQL_REMOVE_FROM_TABLE, [ TBL_DOCUMENT_EXTRA, 'object_id', query.FieldByName('child').AsString ] )) then goto ext;


    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.CommitTrans;

    result := true;
ext:

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
end;

function TDataManager.DeleteCrossLinks(TableName: string; id: integer; comment: string = ''): boolean;
{ удаление всех вспомогательных ссылок указанной связки с предварительным
  помещением их в архив
}
var
    query : TADOQuery;
label ext;
begin
    lC('TDataManager.DeleteCrossLinks');
    result := false;

    // скидываем текущие допссылки в архив
    query := Core.DM.OpenQueryEx( Format( SQL_GET_CROSS_LINKS_ID, [ TableName, id ] ));
    if Assigned(query) then
    while not Query.Eof do
    begin
        if not dmEQ( Format(
            SQL_COPY_TO_HISTORY_BY_ID,
            [
                TableName+'_cross',
                Core.User.id,
                Comment,
                TableName+'_cross',
                Query.Fields[0].AsInteger
            ] )) then goto ext;

        Query.Next;
    end;

    // удаляем все непрямые ссылки связки
    if not dmEQ( Format( SQL_DELETE_CROSS_LINKS, [TableName, id] )) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.ArrToString(arr: array of variant; quoted: boolean = false): string;
{ преобразует динамический массив строк (arr) в одну строку значений, разделенных запятыми.
  при quoted = true, значения оборациваются в кавычки.

  используется для получения набора полей или набора значений в виде единой
  строки для подстановки в строку запроса
}
var
    comma
    : string;
    i : integer;
begin
    lC('TDataManager.ArrToString');
    try

        comma := '';

        for I := 0 to Length( arr ) - 1 do
        begin
            if quoted
            then
                result := result + comma + '''' + String(arr[i]) + ''''
            else
                result := result + comma + String(arr[i]);

            comma := ',';
        end;

    except

        on E: Exception do
        begin
            lE( e.Message );
            lCE;
        end;

    end;

    lCE;
end;


function TDataManager.BuildUpdateSQL(id: integer; TableName: string; Fields,
  Values: array of variant): string;
{ формирование завершенного UPDATE sql-запроса
  tablename - имя таблицы
  id - id записи для подстановки в WHERE
  fields, values - динамические массивы. имена полей и значения для них
}
var
   comma: string;
   i: integer;
   t : word;
begin
    lC('TDataManager.BuildUpdateSQL');
    try

        comma := '';

        // непосредственное формирование строки
        result := 'UPDATE ' + TableName + ' SET ';

        for I := 0 to Length( Fields )-1 do
        begin
            result := result + comma + VarToStrDef( Fields[i], '' ) + '=''' + VarToStrDef( Values[i], '' ) + '''';
            comma := ', ';
        end;

        result := result + ' WHERE id = ' + IntToStr(id);

    except
        on e: exception do
        begin
            lE( e.Message );
            lCE;
        end;
    end;

    lCE;
end;

end.
