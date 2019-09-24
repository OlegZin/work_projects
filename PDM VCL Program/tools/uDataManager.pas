unit uDataManager;

{ Модуль реализует класс с набором методов, позволяющих манипулировать
  объектами и связями со скрытой от пользователя поддержкой целостности и
  поддержкой архивации изменений.
}

interface

uses  ADODB, DB, StrUtils, dbtables, DateUtils, Windows, uTypes;

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

    // статусы объектов проекта
    STATE_PROJECT_DISABLED = -1;   // скопирован с существующего объекта, не доступен для редактирования в рамках данного проекта
    STATE_PROJECT_READONLY = 0;    // только для чтения, пока не будет назначен редактор
    STATE_PROJECT_INWORK   = 1;    // в работе, назначен исполнитель
    STATE_PROJECT_CHECKING = 2;    // исполнитель завершил работу, ожидается проверка контролера
    STATE_PROJECT_WAITING  = 3;    // исполнитель завершил работу, но есть вложенные объекты в статусе "в работе"
    STATE_PROJECT_READY    = 4;    // позиция проверена и завершена, нельзя назначать исполнителей в обычном порядке

    /// режими получения наборов объектов из проекта
    /// флаги настройки выборки
    ROOT_MY_WORK_OBJECTS  = 1;    ///  получить все свои объекты в статусе "в работе" (я редактор)
    ROOT_MY_CHECK_OBJECTS = 2;    ///  получить все объекты в статусе "в проверке" (я контролер)
    ROOT_MY_READY_OBJECTS = 4;    ///  получить все свои объекты в статусе "готово" (я редактор или контролер)

type

    TArrElem = record
        TableName: string;
        TableFields: string;
    end;

//    TIntArray = array of integer;

    TDataManager = class

        lastVersionNumber : integer;
        // номер версии последнего добавленного в базу документа
        // применяется внешними модулями для формирования имен
        // превью-картинок.

        lastFullVersionNumber : string;


        ////////////////////////////////////////////////////////////////////////
        /// БАЗОВЫЕ МЕТОДЫ
        ////////////////////////////////////////////////////////////////////////

        function UpdateTable(id: integer; tablename: string; Fields, Values: array of variant): boolean;
                    // функция обновления таблицы с плавающим набором полей

        function AddObject(fields: string; values: array of variant; tablename: string = ''; custom_only: boolean = false): integer;
                    // добавляем в базу новый объект, возвращаем id записи этого объекта

        function CopyObject( source_id, target_id: integer; source_table, target_table: string): integer;
                    // копирует запись объекта из одной таблицы в другую. возвращает id
                    // в новой таблице

        function ChangeObject(id: integer; Fields, Values: array of variant; comment: string = ''): boolean;
                    // меняет данные объекта в двух фиксированных таблицах объектов: [object], [project_object]

        function ChangeObjectEx( tablename: string; id: integer; Fields, Values: array of variant; comment: string = ''): boolean;
                    // меняет данные записи в указанной таблице с помещением предыдущего состояния в архив

        function DeleteObject( id: integer; comment: string; to_history: boolean = true): boolean;

        function AddLink(TableName: string; parent, child: integer; uid: integer = -1): integer;
                    // добавляем привязку в указанную таблицу связей.
                    // автоматически формируется набор вспомогательных привязок к родителям более высокого уровня
                    // если подобная связка существует, она скидывается ее в архив (вместе со всеми вспомогательными).
                    // возвращаем id добавленной связки, при неудачном -1

        function PresentLink( parent, child: integer; tablename: string): integer;

        function UpdateLink( tablename: string; id: integer; fields, values: array of variant; comment: string = '' ): boolean;
                    // обновляем данные связки в нестандартных полях с архивацией предыдущего состояния

        function CreateCrossLinks(TableName: string; id: integer; rebuild_sublinks: boolean = false): boolean;
                    // создаем дополнительные ссылки на родителей всех уровней указанной связки
        function DeleteCrossLinks(TableName: string; id: integer; comment: string = ''): boolean;
                    // удаляем доп.связи с помещением в архив

        function DeleteLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
        function DeleteLinkBy(TableName: string; parent, child: integer; comment: string = ''): boolean;

        function ChangeLinkParent( TableName: string; id: integer; parent_id: integer; comment: string = ''): boolean;
        function ChangeLinkChild( TableName: string; id: integer; child_id: integer; comment: string = ''): boolean;

        function SetCustomSQL( id: integer; tag, table, condition, colConfig: string ): boolean;
                    // привязывает к объекту кастомный запрос

        function GetKindByID( kind_id: integer ): integer;

        function GetObjectAttr( id: integer; field: string): variant;
        /// возвращает значение указанного поля для указанного объекта



        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ СО СПЕЦИФИКАЦИЯМИ
        ////////////////////////////////////////////////////////////////////////

        function GetObjectBy( field, value, kind: string ): integer;
        // поиск id объекта по одному любому полю с учетом типа. используется при загрузке спецификации

        function GetProjectObjectBy( project_id: integer; field, value, kind: string ): integer;
        // поиск id объекта по одному любому полю с учетом типа. используется при загрузке спецификации

        function GetProjectObjectPresent(project_id: integer; mark: string): integer;
        /// проверка наличия в проекте (в структуре или не привязанным) объекта по
        /// его обозначению

        function GetObjectByString( value: string ): TADOQuery;
        // поиск по mark. используется при загрузке спецификации

        function SpecInWork( spec_id: integer ): boolean;
        // проверяет, находится ли спецификация с указанным id объекта в работе
        // в любом из существующих проектов

        function GetSpecifList: TDataset;
        /// получаем датасет со всеми спецификациями, которые не находятся в работе



        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ С ДОКУМЕНТАМИ И ФАЙЛАМИ
        ////////////////////////////////////////////////////////////////////////

        function CreateDocumentVersion( object_id, version, doc_type: integer; name, filename, comment: string; is_main: integer = -1): integer;
                    // создание нового документа с привязкой к указанному объекту

        function TakeDocumentToWork( doc_id: integer ): boolean;

        function UpdateDocumentVersion( work_version_id: integer ): boolean;
                    // обновляем данные указанной версии. подразумевается, что это
                    // рабочая версия документа, данные которой можно спокойно перезаприсывать

        function DeleteDocumentVersion( doc_id: integer ): boolean;
                    // удаляем не рабочую версию документа

        function SaveWorkDocumentAsVersion( work_version_id: integer ): boolean;
                    // обновляет текущую рабочую версию и переводит ее в статус новой законченной

        function DeleteWorkDocument( work_version_id: integer ): boolean;
                    // удаляет рабочую версию без сохранения


        function GetFileFromStorage( path, filename, DBName: string ): boolean;
                    // выгружает файл из хранилища в указанную директрию

        function UploadVersionFile( doc_version_id: integer ): boolean;

        function RemoveFileFromStorage( DBName: string ): boolean;

        function SetDocAsMain( doc_id, obj_id: integer ): boolean;
                    // установка указанному документу признак основного среди всех
                    // документов, привязанных к объекту

        function GetGroupSubitems( id, kind: integer; fields: string; query: TDataSet): TADOQuery;
        function GetSpecifSubitems( id, kind: integer; fields: string; query: TDataSet): TADOQuery;
        function GetSpecifSubitemsEx(id, kind, project_id: integer; fields, itemsTable, linksTable: string;
          query: TDataSet): TADOQuery;

        function GetProjectDocsList( id, kind: integer; query: TDataSet ): TADOQuery;
        function GetKDDocsList( id, kind: integer; query: TDataSet ): TADOQuery;

        function UpdateHasDocsFlag( id: integer ): boolean;
                    // приведение к актуальному значению признака наличия привязанных документов у объекта

        function SetInWorkState( child, mode: integer ): boolean;
                    // установка или снятие признака взятия в работу документа

        function GetVersionPath( id: integer; filename: boolean = false ): string;
                    // по id объекта-документа полкчает его данные и строит путь для выгрузки версии на комп пользователя

        function GetNextVersionNumber( name: string; object_id: integer ): integer;
                    // по имени файла и объекту-родителю получает следующий номер версии

        function IsInWork( doc_version_id: integer ): boolean;
                    // по id документа проверяет, не является ли это залоченой версией или ее рабочим документом

        function IsWorkVersion( doc_version_id: integer ): boolean;
                    // по id документа проверяет не является ли это рабочей версией документа
                    // не путать с исходной, которая залочена, но правиться не может

        function HasMainDoc(object_id: integer ): boolean;
                    // проверяет, есть ли у объекта привязанные файлы с признаком основного

        function GetProgramByExt( ext: string ): string;
                    // по расширению файла получает из таблицы [document_type].[program] - программу-обработчик

        function HasDocInWork( object_id: integer; check_childrens: boolean = false): boolean;
        // проверяет, есть ли у указанного объекта или его потомков документы в работе




        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ С РАЗДЕЛАМИ (ПАПКАМИ)
        ////////////////////////////////////////////////////////////////////////

        function AddSection(parent: integer; name, tag, tablename, condition: string; colConfig: string = ''; user_id: integer = -1): integer;
                    // создает новую папку с привязкой к указанному объекту
                    // и задает атрибуты выборки данных

        function GetTypeProdLevel( parent_id: integer ): TDataset;
        /// получение элементов указанного уровня из вьюшки классификации продукции

        function GetColConfigName( object_id: integer; def: string ): string;
        /// возвращает имя конфигурации применяемой для отображения данных вложенных
        /// объектов указанного раздела



        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ С ПРОЕКТАМИ
        ////////////////////////////////////////////////////////////////////////

        function CreateProject( name, comment, mark, parent_prod_kod, prod_kod: string; objectId, workgroupId: integer ): integer;
        // создает новый проект, если выбранный объект еще не взят в работу
        // другим проектом. возвращает его id

        function CopyObjectToProject( projeсt_id, parent_id, object_id: integer ): integer;
        // копирование из основной структуры указанного элемента/ветки в
        // структуру проекта с привязкой к указанному элементу структуры

        function UpdateProjectMark( project_id: integer ): boolean;
        // обновляет обозначение разрабатываемого объекта

        function ProjectStatus( ProjectID: integer ): integer;
        // возвращает текущий статус указанного проекта
        function SetProjectState(ObjectID, status: integer): boolean;
        // устанавливает указанный статус

        function FreezProject( ProjectID: integer ): boolean;
        // замораживает указанный проект в текущем состоянии,
        // блокируя возможность редактирования в нем

        function UnFreezProject( ProjectID: integer): boolean;
        // снимает с проекта статус замороженного, что позволяет его редактировать

        function DoneProject( ProjectID: integer): boolean;
        // устанавливает статус завершенного. проект считается архивным
        // и может быть только удален

        function SetProjectObjectState( ObjectID, status: integer ): boolean;
        // перевод указанного проекта в указанный рабочий статус, если возможно

        function ChildsToReadyStatus( parent_id, project_id: integer; full: boolean = false; recurs: boolean = false): boolean;
        // массовый перевод в статус готовности всех непосредственных или потомков всех уровней

        function DeleteProject( ProjectID: integer ): boolean;
        // полностью удаляет указанный проект со всей историей

        function CheckLinkAllow( child_kind, child_subkind, child_status,
            parent_kind, parent_subkind, parent_status : integer): string;
        // проверка на возможность привязки двух объектов друг к другу, исходя из
        // их типов и текущего рабочего статуса. возвращает строку с описание ошибки,
        // если привязка недопустима.

        function GetProjectWorkgroup( project_id: integer ): integer;

        function GetProjectReadyPercent( project_id: integer ): integer;
        // возвращает процент завершения проекта

        function CreateProjectObject( mark, realization, markTU, name, mass, comment: string; kind_id, material_id, obj_icon, project_id: integer ): integer;
        /// создает в проектк новый объект указанного типа и атрибутами, вместе с записью допданных

        function LinkToProjectObject( parent, child, project_id: integer ): string;
        /// привязка указанного объекта проекта к указанному родителк в проекте
        /// при привязке проверяется возможность привязки (исходя из типов объектов)
        /// ошибка возвращается в виде строки

        function GetNextIspolNumber( child: integer ): integer;
        /// для указанного объекта-спецификации возвращает следубщий максимальный номер
        /// исполнения (не учитывает дыры в нумерации)

        function CreateIspoln( project_id, parent: integer; mark, name: string ): integer;
        /// создание исполнения для указанной спецификации с автоматическим
        /// получением номера и привязкой

        function CopyIspoln( project_id, parent, child: integer; mark, name: string ): integer;
        /// создание исполнения для указанной спецификации с автоматическим
        /// получением номера и привязкой. к новой спецификации привязываются все
        /// позиции исходной

        function ObjectIsReady( object_id: integer ): boolean;
        /// метод сканирует всех потомков на текущий статус и возвращает false,
        /// если есть хоть один в статусе в работе или в проверке

        function GetRootElems( project_id, get_mode: integer ): TIntArray;
        /// получаем набор объектов из проекта, объединенных признаком, установленным
        /// режимом получения



        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ С ПРАВАМИ
        ////////////////////////////////////////////////////////////////////////

        function HasRole( role_id, workgroup_id: integer; value: string = '' ): boolean; overload;
        function HasRole( role_name: string; workgroup_id: integer; value: string = '' ): boolean; overload;
        function HasRole( role_id: integer; value: string = '' ): boolean; overload;
        function HasRole( role_name: string; value: string = '' ): boolean; overload;
        // проверяет наличие у текущего пользователя указанной роли
        // если указано value, результат зависит от совпадения значения с ролью
        // обертки для вызова проверки через CheckRole

        function RoleValue( role_id, workgroup_id: integer ): string; overload;
        function RoleValue( role_name: string; workgroup_id: integer ): string; overload;
        function RoleValue( role_id: integer ): string; overload;
        function RoleValue( role_name: string ): string; overload;
        /// возвращают приоритетное значение роли:
        /// значение привязки перекрывает базовое значение роли
        /// являются оберткой для GetRoleValue

        procedure RefreshRolesList( refresh: boolean = false );
        // проверяет истечение времени актуальности набора данных с ролями
        // и обновляет его из базы, при необходимости


        function CreateWorkgroup( name: string; tag: string = '' ): boolean;
        // создает в таблице [ROLE_WORKGROUPS] новую рабочую группу.
        // если с таким именем уже существует, возвращает ошибку.
        function UpdateWorkgroup(group_id: integer; name: string ): boolean;
        // обновление имени рабочей группы
        function DeleleWorkgroup( group_id: integer ): boolean;
        // удаление рабочей группы и всех связей, завязанных на нее


        function CreateGroup( name: string ): boolean;
        // создает в таблице [ROLE_GROUPS] новую группу прав.
        // если с таким именем уже существует, возвращает ошибку.
        function UpdateGroup( group_id: integer; name : string ): boolean;
        // обновление имени группы прав
        function DeleleGroup( group_id: integer ): boolean;
        // удаление группы прав. чистка связей ролей, указывающих на эту группу


        function CreateRole( name, value: string ): boolean;
        // создает в таблице [ROLE_RIGHTS] новую роль.
        // если с таким именем уже существует, возвращает ошибку.
        function UpdateRole( id: integer; name, value: string ): boolean;
        // обновляет данные указанной роли
        function DeleteRole( role_id: integer ): boolean;
        // удаляет указанную роль, чистит все ссылки на нее


        function LinkUserToWorkroup( workgroup_id, user_id: integer ): integer;
        // включение указанного пользователя в указанную рабочую группу
        function UpdateLinkUserToWorkroup( workgroup_id, user_id: integer; todate: TDate; dateSelected: boolean ): boolean;
        // обновление времени ограничения привязки пользователя к рабочей группе
        function DeleleLinkUserToWorkgroup ( workgroup_id, user_id: integer ): boolean;
        // удаление пользователя из указанной рабочей группы. удаление всех
        // ролей и групп, указывающих на этого пользователя в рамках рабочей группы


        function LinkWorkgroupUserToGroup( workgroup_id, user_id, group_id: integer ): boolean;
        // привязка группы прав к пользователю в рамках рабочей группы
        function UpdateLinkUserToGroup(workgroup_id, user_id, group_id: integer;
          todate: TDate; dateSelected: boolean): boolean;
        // обновление времени ограничения привязки пользователя к группе прав в рамках рабочей группы
        function DeleteLinkWorkgroupUserToGroup( workgroup_id, user_id, group_id: integer ): boolean;
        // удаление привязки пользователя к группе прав в рамках рабочей группы


        function LinkPersonalRole( workgroup_id, user_id, role_id: integer ): boolean;
        // привязка пользователю первональной роли
        function UpdateLinkPersonalRole(workgroup_id, user_id, role_id: integer;
            value: string; todate: TDate; dateSelected: boolean): boolean;
        // обновление данных персональной роли
        function DeleteLinkPersonalRole( workgroup_id, user_id, role_id: integer ): boolean;
        // удаление персональной роли пользователя


        function LinkRoleToGroup( group_id, role_id: integer; value: string = '' ): boolean;
        // включение роли в группу
        function UpdateGroupRole( link_id: integer; value: string ): boolean;
        // обновление значения привязки
        function DelLinkRoleToGroup( role_link_id: integer ): boolean;
        // исключение роли из группы


        function GetWorkgroupName( workgroup_id: integer ): string;
        // возвращает наименование рабочей группы по ее id

        function GetWorkgroupsList( dataset: TDataset = nil; tag: string = '' ): TDataset;
        // получаем список всех существующих рабочих групп

        function GetWorkgroupUserList( workgroup_id: integer; dataset: TDataset ): TDataset;
        // получаем список всех прользователей, привязанных к указанной рабочей группе

        function GetWorkgroupUserGroupsList( workgroup_id, user_id: integer; dataset: TDataset ): TDataset;
        // получение списка всех групп прав, привязанных к пользоватею в рамках рабочей группы

        function GetWorkgroupUserRolesList( workgroup_id, user_id, group_id: integer; dataset: TDataset ): TDataset;
        // получение списка прав прользователя в рамках указанной группы прав

        function GetWorkgroupUserRolesFullList( workgroup_id, user_id: integer; dataset: TDataset ): TDataset;
        // возвращает полный список всех прав из всех групп, привязанных к пользователю
        // используется для наглядного отображения без перехода по группам

        function GetWorkgroupUserPersonalRolesList( workgroup_id, user_id: integer; dataset: TDataset ): TDataset;
        // получение полного списка всех персональных прав пользователя в рамках рабочей группы

        function GetProjectUserList( workgroup_id, project_id: integer ): TADOQuery;
        // получение списка всех пользователей проекта. как привязанных через рабочую группу, так
        // и напрямую к проекту

        function GetGroupsList( dataset: TDataset ): TDataset; overload;
        function GetGroupsList( dataset: TADOQuery ): TADOQuery; overload;
        // получаем список всех существующих групп прав

        function GetRolesList( dataset: TDataset ): TDataset;
        // получаем список всех существующих прав

        function GetGroupRolesList( group_id: integer; dataset: TDataset ): TDataset;
        // получаем список ролей, привязанных к указанной группе прав

        function GetEmplToWorkgroupLink( workgroup_id, user_id: integer ): integer;
        // получение id привязки пользователя к рабочей группе.
        // в некоторых функциях по полученному id производится работа с привязкой
        // пользователя к группам и персональным правам в рамках рабочей группы

        function GetBaseWorkgroupId: integer;
        // получение id ключевой рабочей группы, предназначенной для управления
        // правами работы в PDM, а не в режиме проекта



        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ С РЕДАКТОРАМИ И КОНТРОЛЕРАМИ В РАМКАХ ПРОЕКТА
        ////////////////////////////////////////////////////////////////////////

        function LinkEditorToObject( object_id, user_id, project_id: integer ): integer;
        /// привязка редактора к объекту
        function GetObjectEditors( object_id, project_id: integer ): TDataset;
        /// получение всех редакторов, привязанных к объекту
        function DeleteOjectEditor( object_id, user_id: integer ): boolean;
        /// удаление указанного редактора с объекта
        function UnlinkEditorsFromObject( object_id: integer): boolean;
        /// удаление всех редакторов с объекта

        function LinkCheckerToObject( object_id, user_id, project_id: integer ): integer;
        /// привязка проверяющего к объекту
        function GetObjectCheckers( object_id, project_id: integer ): TDataset;
        /// получам всех проверяющих указанного объекта
        function DeleteOjectChecker( object_id, user_id: integer ): boolean;
        /// удаление указанного проверяющего
        function UnlinkCheckersFromObject( object_id: integer ): boolean;
        /// удаление всех контролеров с объекта


        function UserIsEditor( object_id: integer ): boolean;
        /// находится ли текущий пользователь среди редакторов указанного объекта
        function UserIsChecker( object_id: integer ): boolean;
        /// находится ли текущий пользователь среди контролеров указанного объекта



        ////////////////////////////////////////////////////////////////////////
        /// МЕТОДЫ РАБОТЫ СО СПРАВОЧНИКОМ НОМЕНКЛАТУРЫ
        ///    методы работают с таблицей [nft].[mat].[EPR]
        ////////////////////////////////////////////////////////////////////////

        function GetERP( name: string ): string;
        /// получаем код справочника по имени объекта, с учетом вариаций

        function AddERPVariation( erp, name_variation: string ): boolean;
        /// добавляет вариацию наименования в спецтаблицу

        function GetMaterialRecord( field, value: string ): TDataset;
    private
        LastRightDataset: TDataset;
        /// хранит набор данных с правами текущего пользователя, полученный запросом
        /// на контрольной временной точке. позволяет снизить нагрузку на сервер при постоянной
        /// проверке прав в программе, исходя из того, что полученный набор имеет
        /// длительную валидность.
        /// таким образом, на контрольной временной точке набор обновляется запросом,
        /// а в промежуточные проверки просто возвращается последний набор данных
        /// без опроса базы.
        /// константа RIGHT_TIME_VALIDE_PERIOD содержит период валидности набора ролей в минутах

        LastRightCheck: TDateTime;
        /// временная точка, когда в последний раз был обновлен набор ролей пользователя

//        TableFields: array of TArrElem;
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

        function GetCustomSQL(id: integer; tag: string): string;
                    // возвращает кастомный запрос

        function GetObjectSubitems( id, kind: integer; fields, ItemTable, LinkTable, tag, custom_where: string; query: TDataSet ): TADOQuery;

        function CheckRole( workgroup_id: integer; name: string; key: variant; value: string ): boolean;
        // проверяет наличие у текущего пользователя указанной роли
        // если указано value, результат зависит от совпадения значения с ролью

        function GetRoleValue( workgroup_id: integer; name: string; key: variant ): string;
        /// возвращает приоритетное значение, указанной роли

    end;

implementation

{ TDataManager }

uses
    uPhenixCORE, uConstants, SysUtils, Variants, Math, Classes, uMain;

const

    // копирование актуальной связи в архив
    SQL_COPY_TO_HISTORY_BY_ID =
        ' INSERT INTO %s_history '                + sLineBreak +
        ' SELECT GETDATE(), %d, ''%s'', 0, * '    + sLineBreak +
        ' FROM %s WHERE id = %d ';

    SQL_SELECT_LINK_ID =
        ' SELECT id FROM %s WHERE parent = %d AND child = %d ';
    SQL_SELECT_LINK_DATA =
        ' SELECT * FROM %s WHERE id = %d ';
    SQL_GET_LINK_UID =
        ' SELECT uid FROM %s WHERE id = %d ';

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
        ' EXEC pdm_CREATE_CROSS_LINKS ''%s'', %d, %d, %d ';
    SQL_DELETE_CROSS_LINKS =
        ' DELETE FROM %s_cross WHERE base_link = %d ';
    SQL_GET_CROSS_LINKS_ID =
        ' SELECT id FROM %s_cross WHERE base_link = %d ';
    SQL_GET_ALL_SUB_CHILDS_BY_CROSS =
        ' SELECT DISTINCT(base_link) FROM %s_cross WHERE id = %d ';

    SQL_GET_SUBITEMS =
        ' DECLARE @id int = %d '+
        ' SELECT DISTINCT %s FROM %s '+
        ' WHERE child in ( '+
        '     SELECT DISTINCT child FROM %s_cross '+
        '     WHERE parent = @id )';
{
        ' DECLARE @id int = %d '+
        ' SELECT DISTINCT %s FROM %s '+
        ' WHERE lid in ( '+
        '     SELECT id FROM %s '+
        '     WHERE id in ( '+
        '         SELECT base_link_id FROM %s_cross '+
        '         WHERE link_id = @id AND base_link_id <> @id)) ';
}
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
        ' INSERT INTO %s (%s) VALUES (%s) ';

    SQL_GET_FILE_DATA =
        ' SELECT * FROM '+TBL_FILE+' WHERE name = ''%s'' ';
    SQL_OPEN_FILE_TABLE =
        ' SELECT TOP 1 * FROM '+TBL_FILE;
    SQL_REMOVE_FROM_TABLE =
        ' DELETE FROM %s WHERE %s = ''%s'' ';

    SQL_GET_MAX_VERSION =
//        ' SELECT Max(version) FROM '+VIEW_DOCUMENT+' WHERE doc_name = ''%s''';

//        ' SELECT Max(version) FROM '+TBL_DOCUMENT_EXTRA+' WHERE fullname like ''%s{%d_';
        // получение текущего максимального номера версии указанного документа
        // с учетом объекта, к которому привязан (в рамках разных объектов допустимы
        // одинаковые файлы)

        ' SELECT Max(version) FROM '+VIEW_DOCUMENT_PROJECT+' WHERE filename = ''%s'' AND project_object_id = %d ';

    SQL_CREATE_DOCEXTRA =
        ' INSERT INTO '+TBL_DOCUMENT_EXTRA+' (project_doc_id, project_object_id, version, filename, document_type_id, GUID, hash, is_main) VALUES (%d, %d, %d, ''%s'', %d, ''%s'', ''%s'', %d) ';


    SQL_GET_PROJECT_DOC_VERSIONS =
        ' SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_object_id = %d ';
    SQL_GET_KD_DOC_VERSIONS =
        ' SELECT * FROM ' + VIEW_DOCUMENT_KD + ' WHERE object_id = %d ';
    SQL_GET_ALL_DOC =
        ' SELECT * FROM ' + VIEW_DOCUMENT_KD;

    SQL_GET_SECTION_DOC_VERSIONS =
//        ' SELECT * FROM ' + VIEW_INWORK;
        ' SELECT * FROM ' + VIEW_DOCUMENT_KD + ' WHERE minor_version IS NOT NULL';
    SQL_GET_MY_DOC_VERSIONS =
//        ' SELECT * FROM ' + VIEW_INWORK + ' WHERE uid = %d ';
        ' SELECT * FROM ' + VIEW_DOCUMENT_KD + ' WHERE autor_id = %d AND minor_version IS NOT NULL';
    SQL_GET_OTHER_DOC_VERSIONS =
//        ' SELECT * FROM ' + VIEW_INWORK + ' WHERE uid <> %d ';
        ' SELECT * FROM ' + VIEW_DOCUMENT_KD + ' WHERE autor_id <> %d minor_version IS NOT NULL';

    SQL_SET_DOCUMENT_INWORK_STATE =
        ' UPDATE ' + TBL_DOCUMENT_EXTRA + ' SET work_uid = %d WHERE doc_id = %d ';

    SQL_GET_OBJECT_ID_BY =
        ' SELECT id FROM ' + TBL_OBJECT + ' WHERE %s = ''%s'' AND kind = %s' ;
    SQL_GET_OBJECT_ID_BY_EXT =
        ' SELECT id FROM ' + TBL_OBJECT + ' WHERE %s = ''%s''' ;

    SQL_GET_OBJECT_ID_BY_MARK =
        ' SELECT id FROM ' + TBL_OBJECT + ' WHERE mark like ''%s'' AND kind in (10, 7) ';

    SQL_GET_PROJECT_OBJECT_ID_BY =
        ' SELECT child as id FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE project_id = %d AND %s = ''%s'' AND kind = %s' ;
    SQL_GET_PROJECT_OBJECT_ID_BY_EXT =
        ' SELECT TOP 1 child as id FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE project_id = %d AND %s = ''%s''' ;

    SQL_GET_PROJECT_OBJECT_PRESENT =
        ' SELECT TOP 1 o.id FROM '+TBL_PROJECT+' o '+
        ' left join '+TBL_PROJECT_OBJECT_EXTRA+' oe ON o.id = oe.parent ' +
        ' WHERE ' +
        ' o.mark = ''%s'' and oe.project_id = %d ';

    SQL_GET_PROJECT_OBJECT_ID_BY_MARK =
        ' SELECT id FROM ' + TBL_PROJECT + ' WHERE mark like ''%s'' AND kind in (10, 7) ';

    SQL_GET_TABLE_DATA =
        ' SELECT * FROM %s WHERE %s = ''%s'' ';

    SQL_GET_INWORK_LINK =
        ' DECLARE @ID int = %d ' +
        ' SELECT * FROM '+LNK_DOCUMENT_INWORK+' WHERE parent = @ID OR child = @ID ';


    // создание записи с допполями объекта-раздела (kind = 1)
    SQL_CREATE_SECTION_EXTRA =
        ' INSERT INTO ' + TBL_SECTION_EXTRA + ' (tablename, condition) VALUES (''%s'', ''%s'')';


    SQL_CREATE_PROJECT_EXTRA =
        ' INSERT INTO '+TBL_PROJECT_EXTRA+' (status) VALUES (%d) ';
    SQL_CREATE_PROJECT_OBJECT_EXTRA =
        ' INSERT INTO '+TBL_PROJECT_OBJECT_EXTRA+' (original_id) VALUES (%d) ';
    SQL_DELETE_PROJECT =
        ' exec pdm_delete_project %d ';
    SQL_SET_PROJECT_STATUS =
        ' UPDATE ' + TBL_PROJECT_EXTRA +
        ' SET status = %d '+sLineBreak +
        ' WHERE parent = %d ';

    SQL_GET_PROJECT_STATUS =
        ' SELECT status FROM '+ VIEW_PROJECT + ' WHERE child = %d ' ;

    /// получение всех корневых объектов проекта (привязанных непосредственно к
    /// объекту проекта) и всех прямых потомков корневых, являющихся исполнениями.
    /// при этом, поумолчанию подразумевается, что корневой элемент - спецификация
    /// поскольку исполнения могут быть привязвны только к ней.
    SQL_GET_TOPOBJECT_EXTRA_ID =
        ' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent = %0:d '+ sLineBreak +
        ' UNION '                                                               + sLineBreak +
        ' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent in ('   + sLineBreak +
          ' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE                        + sLineBreak +
          ' WHERE parent = %0:d )'                                               + sLineBreak +
        ' AND icon = 11'; // 11 = исполнение

    SQL_GET_ALL_FIELDS =
    'select stuff( '+                                                           sLineBreak +
    '    (select '','' + name '+                                                sLineBreak +
    '     from sys.syscolumns '+                                                sLineBreak +
    '     where '+                                                              sLineBreak +
    '         id = object_id(''%s'') '+                                         sLineBreak +
    '         and '+                                                            sLineBreak +
    '         name not in ( '+                                                  sLineBreak +
    '             select name '+                                                sLineBreak +
    '             from sys.identity_columns '+                                  sLineBreak +
    '             where object_id in (select id from sys.sysobjects where name like ''%s'') '+ sLineBreak +
    '         ) '+                                                              sLineBreak +
    '     for xml path('''') '+                                                 sLineBreak +
    '    ),1,1,'''' '+                                                          sLineBreak +
    ')';

//         '' + sLineBreak +

var
    base_workgroup_id: integer;
    /// переменная содержит id рабочей группы из [ROLES_WORKGROUPS] с именем
    /// из константы BASE_WORKGROUP_NAME.


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


function TDataManager.GetColConfigName(object_id: integer; def: string): string;
/// возвращает имя конфигурации применяемой для отображения данных вложенных
/// объектов указанного раздела
begin
    result := dmSDQ( 'SELECT column_config FROM '+TBL_CUSTOM_SQL+' WHERE parent = '+IntToStr(object_id), def );
end;

function TDataManager.GetCustomSQL(id: integer; tag: string): string;
begin

    result := '';

    dmOQ( 'SELECT * FROM '+TBL_CUSTOM_SQL+' WHERE parent = '+IntToStr(id)+' AND tag like ''%'+tag+'%''' );
    if ( CORE.DM.Query.Active )and ( CORE.DM.Query.RecordCount > 0) then
    begin

        // формируем запрос
        if CORE.DM.Query.FieldByName('condition').AsString <> ''
        then
            result := Format( 'SELECT * FROM %s WHERE %s',
                              [
                                 CORE.DM.Query.FieldByName('tablename').AsString,
                                 CORE.DM.Query.FieldByName('condition').AsString
                              ]
                      )
        else
            result := 'SELECT * FROM ' + CORE.DM.Query.FieldByName('tablename').AsString;

        // подменяем тэги на актуальные значения
        result := ReplaceStr(result, TAG_USER_ID, IntToStr(CORE.User.id));
    end;

end;

function TDataManager.GetDocsCount( id: integer): integer;
begin
    dmOQ( Format( SQL_GET_PROJECT_DOC_VERSIONS, [ id ] ));
    result := Core.DM.Query.RecordCount;
end;

function TDataManager.GetProjectDocsList(id, kind: integer; query: TDataSet): TADOQuery;
{ для указанного объекта получить набор данных со всеми версиями всех документов.
  возвращаемый датасет подставляется как источник данных для таблицы grdDocs
  id - объект для которого нужно вернуть список привязанных документов
}
var
    sql
            : string;
begin

    if   kind = KIND_SECTION
    then sql := GetCustomSQL( id, TAG_SELECT_DOCUMENTS );

    if sql = ''
    then
        result := Core.DM.OpenQueryEx( Format( SQL_GET_PROJECT_DOC_VERSIONS, [id] ), query )
    else
        result := Core.DM.OpenQueryEx( sql, query );

end;

function TDataManager.GetKDDocsList(id, kind: integer;
  query: TDataSet): TADOQuery;
var
    sql
            : string;
begin

    if   kind = KIND_SECTION
    then sql := GetCustomSQL( id, TAG_SELECT_DOCUMENTS );

    if sql = ''
    then
        result := Core.DM.OpenQueryEx( Format( SQL_GET_KD_DOC_VERSIONS, [id] ), query )
    else
        result := Core.DM.OpenQueryEx( sql, query );


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
    query: TADOQuery;
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
    query := Core.DM.OpenQueryEx( Format( SQL_GET_FILE_DATA, [ DBname ] ));
    if not Assigned( query ) then goto ext;

    if not Query.Active or ( Query.RecordCount = 0 ) then
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


    BlobStream := Query.CreateBlobStream( Query.FieldByName('file_stream'), bmRead );
    FileStream := TFileStream.Create( path + fileName, fmOpenWrite );
    FileStream.CopyFrom( BlobStream, BlobStream.Size );

    // закрываем потоки для корректного завершения операции
    FreeAndNil( FileStream );
    FreeAndNil( BlobStream );

    result := true;

ext:
    lCE;
end;



function TDataManager.GetNextIspolNumber(child: integer): integer;
/// для указанного объекта-спецификации возвращает следубщий максимальный номер
/// исполнения (не учитывает дыры в нумерации)
///    child - объект-спецификация в проекте
///
/// особая тонкость заключается в том, что нумерация исполнений начинается с нуля
begin
    result := dmSDQ( ' SELECT count(child) FROM ' +VIEW_PROJECT_STRUCTURE+ ' WHERE parent = '+IntToStr(child), 0);
end;

function TDataManager.GetNextVersionNumber(name: string; object_id: integer ): integer;
begin
//    result := Integer( dmSDQ( Format( SQL_GET_MAX_VERSION, [ name, object_id ] )+'%''', 0 )) + 1;
    result := Integer( dmSDQ( Format( SQL_GET_MAX_VERSION, [ name, object_id ] ), 0 )) + 1;
    // здесь обход глюка метода Format, сжирающего % в строке, относящийся к like запроса,
    // считая его некорректным аргументом для подстановки. приклеиваем процент после подстановки
    // значений в строку запроса
end;

function TDataManager.GetObjectAttr(id: integer; field: string): variant;
begin
    result := dmSQ('SELECT '+field+' FROM ' + VIEW_OBJECT + ' WHERE child = '+IntToStr(id));
end;

function TDataManager.GetObjectBy(field, value, kind: string): integer;
begin
    if kind = ''
    then result := dmSDQ( Format( SQL_GET_OBJECT_ID_BY_EXT, [ field, value ] ), 0)
    else result := dmSDQ( Format( SQL_GET_OBJECT_ID_BY, [ field, value, kind ] ), 0);
end;
function TDataManager.GetProjectObjectBy(project_id: integer; field, value, kind: string): integer;
begin
    if kind <> ''
    then result := dmSDQ( Format( SQL_GET_PROJECT_OBJECT_ID_BY, [ project_id, field, value, kind ] ), 0)
    else result := dmSDQ( Format( SQL_GET_PROJECT_OBJECT_ID_BY_EXT, [ project_id, field, value ] ), 0);
end;

function TDataManager.GetProjectObjectPresent(project_id: integer; mark: string): integer;
begin
    result := dmSDQ( Format( SQL_GET_PROJECT_OBJECT_PRESENT, [ mark, project_id ] ), 0);
end;


function TDataManager.GetProjectReadyPercent(project_id: integer): integer;
/// считает и возвращает процент завершения указанного проекта
/// процент является отношением общего количества объектов
/// к количеству объектов в статусе готово + недоступно
var
    full_count    // общее количество объектов в проекте
   ,ready_count   // количество завершенных и недоступных
            : integer;
begin
    full_count := dmSDQ('SELECT COUNT(*) FROM '+VIEW_PROJECT_STRUCTURE+' WHERE project_id = ' + IntToStr(project_id), 1);
    ready_count := dmSDQ(Format('SELECT COUNT(*) FROM %s WHERE project_id = %d AND status in (%d, %d)',
                                [VIEW_PROJECT_STRUCTURE, project_id, PROJECT_OBJECT_DONE, PROJECT_OBJECT_READONLY]), 1);
    result := Round((ready_count / full_count) * 100);
end;

function TDataManager.GetProjectUserList(workgroup_id,
  project_id: integer): TADOQuery;
begin
    result := CORE.DM.OpenQueryEx(
         ' SELECT e.id as user_id, E.fio as user_name, ew.parent as workgroup_id, gw.child as group_id FROM '+TBL_EMPLOYEES+' as e '
       + ' left join '+LNK_ROLES_EMPL_WORKGROUP+' as ew on ew.child = e.id '
       + ' left join '+LNK_ROLES_GROUP_WORKGROUP+' as gw on ew.id = gw.parent '
//       + ' WHERE ew.parent in ('+ IntToStr(workgroup_id) +','+ IntToStr(project_id) +')'
    );
end;

function TDataManager.GetObjectByString(value: string): TADOQuery;
begin
    result := Core.DM.OpenQueryEx( Format( SQL_GET_OBJECT_ID_BY_MARK, [ value+'%' ] ));
end;

function TDataManager.GetObjectEditors(object_id, project_id: integer): TDataset;
/// получаем список всех редакторов, назначенных на указанный объект проекта
begin
    result := CORE.DM.OpenQueryEx(
        ' SELECT e.id, e.name FROM ' + TBL_EMPLOYEES + ' e ' +
        ' left join ' + LNK_PROJECT_EDITOR + ' pe ON pe.child = e.id ' +
        ' WHERE pe.parent = ' + IntToStr(object_id) +
        ' AND pe.project_id = ' + IntToStr(project_id)
    );
end;

function TDataManager.DeleteOjectChecker(object_id, user_id: integer): boolean;
begin
    result := dmEQ(
        ' DELETE FROM ' + LNK_PROJECT_CHECKER +
        ' WHERE parent = ' + IntToStr(object_id) +
        ' AND child = ' + IntToStr(user_id) );
end;

function TDataManager.DeleteOjectEditor(object_id, user_id: integer): boolean;
/// удаление редактора, привязанного к объекту
begin
    result := dmEQ(
        ' DELETE FROM ' + LNK_PROJECT_EDITOR +
        ' WHERE parent = ' + IntToStr(object_id) +
        ' AND child = ' + IntToStr(user_id) );
end;

function TDataManager.GetGroupSubitems( id, kind: integer; fields: string; query: TDataSet): TADOQuery;
/// получение данных для таблицы объектов при перемещении по дереву рабочего стола
begin
    result := GetObjectSubitems(id, kind, fields, VIEW_GROUP, LNK_NAVIGATION, TAG_SELECT_OBJECTS, '', query);
end;

function TDataManager.GetKindByID(kind_id: integer): integer;
begin
    result := dmSQ( 'SELECT kind FROM ' + TBL_OBJECT_CLASSIFICATOR + ' WHERE id = ' + IntToStr(kind_id) );
end;

function TDataManager.GetSpecifSubitemsEx(id, kind, project_id: integer; fields, itemsTable, linksTable: string;
  query: TDataSet): TADOQuery;
/// получение данных для таблицы объектов при перемещении по дереву спецификаций
var
    custom_where: string;
begin
    if   project_id <> 0
    then custom_where := ' AND project_id = ' + IntToStr(project_id)
    else custom_where := '';

    result := GetObjectSubitems(id, kind, fields, itemsTable, linksTable, TAG_SELECT_OBJECTS, custom_where, query);
end;

function TDataManager.GetTypeProdLevel(parent_id: integer): TDataset;
begin
    case parent_id of
        0,-1,-2: result := CORE.DM.OpenQueryEx('SELECT * FROM ' +VIEW_TYPE_PROD+ ' WHERE level = ' + IntToStr(Abs(parent_id)));
        else result := CORE.DM.OpenQueryEx('SELECT * FROM ' +VIEW_TYPE_PROD+ ' WHERE id_parent = '+IntToStr(parent_id));
    end;
end;

function TDataManager.GetSpecifList: TDataset;
/// получаем датасет со всеми спецификациями, которые не находятся в работе
begin
    result := CORE.DM.OpenQueryEx(
        ' SELECT child, full_mark, full_name FROM '+ VIEW_OBJECT +
        ' WHERE mark NOT IN ( SELECT mark FROM '+ VIEW_PROJECT +' WHERE status <> '+IntToStr(PROJECT_DONE)+') AND icon = ' + IntToStr(KIND_SPECIF) );
end;

function TDataManager.GetSpecifSubitems(id, kind: integer; fields: string;
  query: TDataSet): TADOQuery;
/// получение данных для таблицы объектов при перемещении по дереву спецификаций
begin
    result := GetObjectSubitems(id, kind, fields, VIEW_OBJECT, LNK_STRUCTURE, TAG_SELECT_OBJECTS, '', query);
end;

function TDataManager.GetObjectSubitems(id, kind: integer; fields, ItemTable,
  LinkTable, tag, custom_where: string; query: TDataSet): TADOQuery;
///  для указанного объекта получить набор данных со всеми вложенными объектами.
///  возвращаемый датасет подставляется как источник данных для таблицы grdObject
///  в список попадает и сам объект-родитель, чтобы иметь возможность работать с ним
///  как м со всеми остальными. например, привязывать/редактировать документы
///
///  при этом, для объекта может существовать настроенный запрос выборки
///
///  id - выбранный объект
///  kind - тип объекта для которого делаем выборку. это может быть папка с кастомным запросом
///  fields - какие поля должен иметь возвращенный набор данных
///  itemtable - таблица или вьюшка, содержащая нужные данные
///  linktable - таблица связей, по которой определять набор вложенных объектов
///  tag - по какому признаку выбирать уникальную выборку, имеет значение только для kind = папка
///  custom_where - особые условия
///  query - датасет в котором вернуть данные
var
    mark_id
            : integer;
    sql
            : string;
begin

    // запоминаем выбранную строку
    if Assigned(query) and query.Active and Assigned(query.FindField('child'))
    then mark_id := query.FieldByName('child').AsInteger;

    // у папок может быть кастомный запрос, пытаемся его найти
    if   kind = KIND_SECTION
    then sql := GetCustomSQL( id, TAG_SELECT_OBJECTS );

    if sql <> ''
    then
        result := Core.DM.OpenQueryEx( sql, query )

    else
{
        result := Core.DM.OpenQueryEx(
            Format(
                ' DECLARE @id int = %d '+
                ' SELECT DISTINCT %s FROM %s '+
                ' WHERE parent = @id ',
                [ id, fields, ItemTable ]
            ),
            query
        );
}

        result := Core.DM.OpenQueryEx(
            Format(
                ' DECLARE @id int = %d '+
                ' SELECT DISTINCT %s FROM %s '+
                ' WHERE '+
                '  (  child in ( '+
                '         SELECT DISTINCT child FROM %s_cross '+
                '         WHERE parent = @id ) '+
                '     OR '+
                '     child = @id '+
                '  )'+
                custom_where,
                [ id, fields, ItemTable, LinkTable ]
            ),
            query
        );

    // восстанавливаем выбранную строку
    if Assigned(query) and query.Active and Assigned(query.FindField('child'))
    then query.Locate('child', mark_id, []);

end;

function TDataManager.GetProgramByExt(ext: string): string;
begin
    result := dmSDQ('SELECT program FROM ' + TBL_DOCUMENT_TYPE + ' WHERE ext = ''' + ext + '''', '');
end;

function TDataManager.HasDocInWork(object_id: integer; check_childrens: boolean = false): boolean;
// проверяет, есть ли у указанного объекта привязанные документы в рабочей версии
begin
    if not check_childrens
    then result := dmSDQ(' SELECT count(*) FROM '+VIEW_DOCUMENT_PROJECT+' WHERE project_object_id = ' +IntToStr(object_id)+ ' AND minor_version IS NOT NULL ', 0) > 0
    else result := dmSDQ(' SELECT count(*) FROM '+VIEW_DOCUMENT_PROJECT+' WHERE project_object_id in (SELECT child FROM '+VIEW_PROJECT_STRUCTURE+' WHERE parent = ' +IntToStr(object_id)+ ') AND minor_version IS NOT NULL ', 0) > 0
end;


function TDataManager.GetVersionPath( id: integer; filename: boolean = false ): string;
begin
    result := '';

    if not dmOQ( Format( SQL_GET_TABLE_DATA, [ VIEW_DOCUMENT_PROJECT, 'project_doc_id', IntToStr(id) ])) then exit;
    result :=
        DIR_DOCUMENT +
        Core.DM.Query.FieldByName('obj_mark').AsString + Core.DM.Query.FieldByName('obj_name').AsString + '\' +
        Core.DM.Query.FieldByName('doc_name').AsString + '\' +
        Core.DM.Query.FieldByName('full_version').AsString + '\';

    if   filename
    then result := result + Core.DM.Query.FieldByName('doc_name').AsString;
end;

function TDataManager.HasMainDoc(object_id: integer): boolean;
/// проверка, есть ли у объекта привязанные документы с признаком основного
/// применяется при привязке файлов к объекту, для выставления им корректного признака
/// основного. основным может быть только один (все его версии так же с признаком главного)
begin
    result := dmSDQ( Format('SELECT COUNT(project_object_id) FROM %s WHERE project_object_id = %d AND is_main <> 0', [VIEW_DOCUMENT_PROJECT, object_id]), 0 ) <> 0
end;

function TDataManager.IsInWork(doc_version_id: integer): boolean;
/// проверяем, не является ли указанный документ взятым в работу или
///  рабочей версией.
var
    query : TADOQuery;
begin
    result := false;

    // получаем данные указанной версии
    query := CORE.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr(doc_version_id) );
    if not assigned(query) or (query.RecordCount=0) then exit;

    /// пытаемся найти рабочую версию, образованную от указанной
    result := dmSDQ(
        'SELECT COUNT(project_doc_id) FROM ' + VIEW_DOCUMENT_PROJECT +
        ' WHERE filename = ''' + query.FieldByName('filename').AsString + '''' +
        ' AND version = ''' + query.FieldByName('version').AsString + '''' +
        ' AND minor_version IS NOT NULL ',
        0
    ) <> 0;

//    dmOQ( Format( SQL_GET_INWORK_LINK, [ doc_version_id ] ));
//    result := Core.DM.Query.Active and (Core.DM.Query.RecordCount > 0);
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


function TDataManager.PresentLink(parent, child: integer;
  tablename: string): integer;
begin
     result := dmSDQ( Format( SQL_SELECT_LINK_ID, [TableName, parent, child] ), 0 );
end;

function TDataManager.ProjectStatus(ProjectID: integer): integer;
/// возвращает текущее состояние указанного проекта (в работе/заморожен и т.д.)
begin
    result := dmSDQ( Format( SQL_GET_PROJECT_STATUS, [ ProjectID ]), -1 );
end;

function TDataManager.RemoveFileFromStorage(DBName: string): boolean;
begin
    result := CORE.DM.ExecQuery( Format( SQL_REMOVE_FROM_TABLE, [ TBL_FILE, 'name', DBName ] ));
end;

function TDataManager.SaveWorkDocumentAsVersion(
  work_version_id: integer): boolean;
{ метод обновляет текущую рабочую версию из файла
  и переводит рабочую версию в статус завершенной (следующей по номеру от исходной)
}
var
    query: TADOQuery;
    filename : string;
    version : integer;
begin
    result := false;

    // сохраняем последние изменения рабочей версии
    if not UpdateDocumentVersion( work_version_id ) then exit;

    /// получаем текущий максимальный номер полной версии документа
    version := dmSQ(
        ' SELECT MAX(version) FROM ' + TBL_DOCUMENT_EXTRA +
        ' WHERE project_doc_id = ' + IntToStr(work_version_id) +
        ' AND filename = ( SELECT filename FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id) + ')'
    );

    /// обнуляем id редактора документа и минорную версию, повышаем текущую
    /// при этом берем максимальную из имеющихся полных версий
    if not dmEQ(
        BuildUpdateSQL(
            dmSQ( 'SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id)),
            TBL_DOCUMENT_EXTRA,
            [ 'version', 'minor_version', 'editor_id' ],
            [ version + 1 ,'*null', '*null' ]
            )
        ) then exit;
{
    // удяляем рабочий файл(-ы) и папку версии
    filename := mngData.GetVersionPath( work_version_id, true );

    if FileExists( filename ) then
    begin
        DeleteFile( filename );
        RemoveDir( ExtractFilePath( filename ));
    end;
}
    result := true;
end;

function TDataManager.SetCustomSQL(id: integer; tag, table,
  condition, colConfig: string): boolean;
/// привязываем к объекту кастомный запрос на выборку данных для указанного потребителя
begin
    result := dmEQ( Format( 'INSERT INTO %s (parent, tag, tablename, condition, column_config) VALUES (%d, ''%s'', ''%s'', ''%s'', ''%s'')',
                            [TBL_CUSTOM_SQL, id, tag, table, condition, colConfig] ));
end;

function TDataManager.SetDocAsMain(doc_id, obj_id: integer): boolean;
// установка указанному документу признак основного среди всех
// документов, привязанных к объекту.
// поскольку основным может быть только один документ, у всех остальных
// этот признак сбрасывается
begin
    result := false;

    // сбрасываем признак основного у всех документов объекта
    dmEQ(' UPDATE ' + TBL_DOCUMENT_EXTRA + ' SET is_main = 0 WHERE project_object_id = ' + IntToStr(obj_id));

    // устанавливаем признак основного
    dmEQ(' UPDATE ' + TBL_DOCUMENT_EXTRA +
         ' SET is_main = 1 '+
         ' WHERE project_object_id = ' + IntToStr(obj_id) +
         ' AND project_doc_id = ' + IntToStr(doc_id) );

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
    result := dmEQ( Format( SQL_SET_DOCUMENT_INWORK_STATE, [ mode, ifthen( mode = 0, 0, Core.User.id), child ] ));
end;

function TDataManager.SetProjectObjectState(ObjectID,
  status: integer): boolean;
/// переводим указанный объект проекта в указанный статус, если возможно
var
    objData : TADOQuery;
    currState: integer;
    objName : string;

begin

    lm('SetProjectObjectState ObjectID='+IntToStr(ObjectID)+', status='+IntToStr(status));

    result := false;

    objData := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE child = ' + IntTostr(ObjectID) );
    if (not Assigned(objData)) or (not objData.Active) or (objData.RecordCount = 0) then
    begin
        CORE.DM.DBError := lW('Объект с id ' + IntTostr(ObjectID) + ' не обнаружен');
        exit;
    end;

    currState := objData.FieldByName('status').AsInteger;
    objName := objData.FieldByName('mark').AsString + ' ' + objData.FieldByName('name').AsString;

    if currState = PROJECT_OBJECT_READONLY then
    begin
        CORE.DM.DBError := lW('Объект '+objName+'(' + IntTostr(ObjectID) + ') в статусе только для просмотра и не может быть изменен.');
        exit;
    end;

    /// если дошли до сюда - статус можно поменять
    result := UpdateTable(
        Integer(dmSQ( 'SELECT id FROM ' + TBL_PROJECT_OBJECT_EXTRA + ' WHERE parent =' + IntToStr(objectID) )),
        TBL_PROJECT_OBJECT_EXTRA,
        ['status'],
        [status]
    );

end;

function TDataManager.SetProjectState(ObjectID, status: integer): boolean;
begin
    result := dmEQ( Format( SQL_SET_PROJECT_STATUS, [status, ObjectID]) );
end;

function TDataManager.ChildsToReadyStatus(parent_id, project_id: integer;
  full: boolean; recurs:boolean): boolean;
/// перевод потомков указанного объекта в статус готовности
/// full = false - только непосредственных потомков
/// full = true - потомков всех уровней
///
/// при этом подразумевается, что текущий пользователь имеет для этого достаточно прав
///
/// - получаем и перебираем всех непосредственных потомков
///     - назначаем текущего пользователя редактором и контролером
///     - выставляем статус готовности
///     - при глубокой обработке, передаем объект на рекурсивную обработку
label ext;
var
    childs: TDataset;
begin
    result := false;

    if not recurs then
    if not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    childs := CORE.DM.OpenQueryEx('SELECT * FROM '+VIEW_PROJECT_STRUCTURE+' WHERE parent = '+IntToStr(parent_id));
    if not Assigned(childs) or (childs.RecordCount = 0) then
    begin
        result := true;
        goto ext;
    end;

    while not childs.Eof do
    begin
        if childs.FieldByName('status').AsInteger <> STATE_PROJECT_DISABLED then
        begin

            if LinkEditorToObject( childs.FieldByName('child').AsInteger, CORE.User.id, project_id ) = 0 then goto ext;
            if LinkCheckerToObject( childs.FieldByName('child').AsInteger, CORE.User.id, project_id ) = 0 then goto ext;

            if not SetProjectObjectState( childs.FieldByName('child').AsInteger, STATE_PROJECT_READY ) then goto ext;

            if full then
            if not ChildsToReadyStatus( childs.FieldByName('child').AsInteger, project_id, full, true ) then goto ext;
            // запуск с флагом рекурсии, чтобы не сломать текущую транзакцию. с ней работает только первый вызов метода

        end;

        childs.Next;
    end;

    if not recurs then
    if CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.CommitTrans;

    result := true;

ext:
    if not recurs then
    if CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.RollbackTrans;

end;

function TDataManager.SpecInWork(spec_id: integer): boolean;
// проверяем на наличие в проектах указанного объекта в режиме редактирования
// смысл в том, что объект спецификации может быть включен как "образец" (не корневой) в состав дерева
// проекта с блокировкой редактирования (поскольку уже согласован) и в качестве
// редактируемого объекта (корня проекта), что делает его редактируемым и только в рамках
// данного проекта. соответсвенно, нас не интересует, если он упоминается среди проектов
// как нередактируемый, но ищем в редактируемом состоянии ( в любом отличном от
// заблокированного)
begin
    result := false;

    if spec_id <> 0 then

    result := dmSDQ(
        ' SELECT mark FROM ' + VIEW_PROJECT_STRUCTURE +
        ' WHERE original_id = '+IntToStr(spec_id)+
        ' AND status <> '+ IntToStr(PROJECT_OBJECT_READONLY), '') <> '';

end;

function TDataManager.TakeDocumentToWork( doc_id: integer ): boolean;
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
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr( doc_id ));
    if not Assigned(query) or (query.RecordCount = 0) then goto ext;

    // выгружаем файл в темповую папку для последующей загрузки в рабочую версию
    GetFileFromStorage( DIR_TEMP, query.FieldByName('filename').AsString, query.FieldByName('GUID').AsString );

    // создаем рабочую версию документа
    work_version_id :=
        CreateDocumentVersion(
            query.FieldByName('project_object_id').AsInteger,  // объект-владелец
            query.FieldByName('version').AsInteger,            // исходная версия
            query.FieldByName('document_type_id').AsInteger,   // тип документа
            query.FieldByName('filename').AsString,            // имя документа с расширением
            DIR_TEMP + query.FieldByName('filename').AsString, // откуда загружать в хранилище
            '',                                                // комментарий
            query.FieldByName('is_main').AsInteger             // признак главного документа
         );
    if work_version_id = 0 then goto ext;

    if not dmEQ(
        BuildUpdateSQL(
            dmSQ( 'SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id)),
            TBL_DOCUMENT_EXTRA,
            [ 'minor_version', 'editor_id', 'version_parent' ],
            [ query.FieldByName('minor_version').AsInteger + 1, CORE.User.id, doc_id ]
            )
        ) then goto ext;

    lastVersionNumber := 0;
    lastFullVersionNumber := query.FieldByName('version').AsString + '.' + IntToStr( query.FieldByName('minor_version').AsInteger + 1 ) ;

    // выгружаем файл из базы в рабочую папку
    UploadVersionFile( work_version_id );

    result := true;

ext:
    lCE;
end;

function TDataManager.UnFreezProject(ProjectID: integer): boolean;
begin
    result := dmEQ( Format( SQL_SET_PROJECT_STATUS, [PROJECT_INWORK, ProjectID]) );
end;

function TDataManager.UnlinkCheckersFromObject(object_id: integer): boolean;
begin
    result := dmEQ(' DELETE FROM ' + LNK_PROJECT_CHECKER + ' WHERE parent = ' + IntToStr(object_id));
end;

function TDataManager.UnlinkEditorsFromObject(object_id: integer): boolean;
begin
    result := dmEQ(' DELETE FROM ' + LNK_PROJECT_EDITOR + ' WHERE parent = ' + IntToStr(object_id));
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
{    if not IsWorkVersion( work_version_id ) then
    begin
        Core.DM.DBError := lW( 'Документ ('+IntToStr(work_version_id)+') не является рабочей версией.');
        goto ext;
    end;
}
    // получаем полное имя рабочего файла
    filename := mngData.GetVersionPath( work_version_id, true );

    // проверяем на наличие. файл мог быть случайно удален или перемещен
    if not FileExists( filename ) then
    begin
        Core.DM.DBError := lW( 'Рабочий файл документа не существует.'+sLineBreak+'('+filename+')');
        goto ext;
    end;

    // получаем данные рабочей версии и обновляем файл в хранилище
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr(work_version_id) );
    if   not Assigned( query ) then goto ext;

    UpdateFileInStorage( query.FieldByName('GUID').AsString, filename );

    // получаем текущий хзш файла
    hash := mngFile.GetHash( filename );

    // обновляем номер минорной версии и хэша
    if not dmEQ(
        BuildUpdateSQL(
            dmSQ( 'SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id)),
            TBL_DOCUMENT_EXTRA,
            ['hash', 'minor_version'],
            [hash, query.FieldByName('minor_version').AsInteger + 1]
        )
    ) then goto ext;

    // перкладываем файл в папку новой версии
    UploadVersionFile( work_version_id );

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
    result := ChangeObject( id, ['has_docs'], [ ifthen( GetDocsCount(id) > 0, 1, 0 ) ] );
end;

function TDataManager.UpdateLink(tablename: string; id: integer; fields,
  values: array of variant; comment: string = ''): boolean;
/// поскольку таблица связей может содержать любое количество информационных полей,
/// например, количество каждого объекта в структуре комплекса
/// данный метод позволяет менять данные в этих дополнительных полях, сохраняя
/// предыдущее состояние связи в архиве
///    tablename - имя таблицы связей "_cross"
///    id - запись из этой таблицы, которую будем апдейтить
///    fields - массив строк с именами полей, которые будем менять
///    values - массив значений в том же порядке, что и поля
///    comment - не обязательный комментарий к операции
begin
    result := false;

    // кидаем текущее состояние объекта в архив
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [tablename, Core.User.id, Comment, tablename, id] )) then exit;
    // обновляем поля
    if not UpdateTable( id, LNK_PROJECT_STRUCTURE, fields, values ) then exit;

    result := true;
end;

function TDataManager.UpdateProjectMark(project_id: integer): boolean;
/// обновляет обозначение разрабатываемого объекта
/// разрабатываемым считается привязанный непосредственно к объекту проекта
/// и его [mark] записывается в [mark] проекта для информативности в списке проектов
///     project_id - проект
begin
    UpdateTable(
        project_id,
        TBL_PROJECT,
        [ 'mark' ],
        [ dmSDQ( 'SELECT TOP 1 mark FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent = ' + IntToStr( project_id )  , '') ]
    );
end;

function TDataManager.UpdateTable(id: integer; tablename: string; Fields,
  Values: array of variant): boolean;
begin
    result := dmEQ( BuildUpdateSQL( id, tablename, fields, values ) );
end;

function TDataManager.UploadVersionFile(doc_version_id: integer): boolean;
/// по id версии документа вычисляем путь для выгрузки на машину пользователя
/// и выгружаем файл из базы
var
    dir: string;
    query: TADOQuery;
begin
    // получаем полный рабочий путь для выгрузки файла
    dir := GetVersionPath( doc_version_id );

    // создаем рабочую папку
    ForceDirectories( dir );

    // получаем данные созданной рабочей версии
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr( doc_version_id ));
    if not Assigned(query) or (query.RecordCount = 0) then exit;

    // выгружаем документ в папку
    if not GetFileFromStorage( dir, query.FieldByName('filename').AsString, query.FieldByName('GUID').AsString ) then exit;

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

    // объект не может быть собственным потомком
    if parent = child then exit;

    // если подобная связь уже есть - оставляем все как есть
    result := PresentLink( parent, child, Tablename );
    if result <> 0 then goto ext;

//    if dmSDQ( Format( SQL_SELECT_LINK_ID, [TableName, parent, child] ), 0 ) <> 0 then goto ext;

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

function TDataManager.DoneProject(ProjectID: integer): boolean;
/// метод завершает указанный проект. ставит признак архивного и вливает
/// структуру проекта ([projrct_object], [project_structure])
/// в согласованную ([object], [stucture]). при этом согласованно сливаются
/// данные: объектов, структуры, документов.
///
/// в частном случае ProjectID является исполнением, которое заливается в КД
/// без завершения самого проекта.
///
/// подразумевается, что все рабрабатываемые объекты утверждены, а документы
/// не находятся в редактировании.
///
///     объекты
///     при отсутствии, создается новый в [object]
///     при наличии, текущее согласованое уходит в архив и замещается данными из проекта
///
///     связи
///     для исполнений обновляется состав первого уровня (не касаясь элементов
///     сборочных единиц и т.п., включенных в спецификацию), поскольку они являются
///     нередактируемыми и связи с новыми элементами всех уровней.
///     для спецификации дополнительно обновляются связи с исполнениями и состав
///     каждой спецификации
///     возможны варианты:
///         добавлена связь с новым объектом
///         добавлена связь с существующим объектом
///         удалена связь с существующим объектом
///         (удаление связи с новым объектом игнорим. это не попадает в слияние структур)
///
///     документы
///     для каждого нового объекта документы копируются как есть со всеми версиями
///     для существующего элемента только те, которые отсутствуют
///
///     АЛГОРИТМ
///     геренация объектов
///       - проходим по всей структуре проекта
///         - заливаем новые объекты
///           - для залитого нового объекта в проекте ставится статус -1 (блокировка редактирования) (перестраховка)
///         - обновляем данные уже существующего объекта
///       - паралельно но строится дерево с сопоставления проектных и реальных id объектов
///     генерация связей
///       чистка удаленных
///       - проходим по всем связям СОГЛАСОВАННОЙ(КД) структуры корневого элемента
///         (удаленные ссылки можно определить только с точки зрения корневой структуры)
///       - если в структуре проекта есть оба этих объекта и нет связи между ними
///         (при создании проекта, если связь присутствовала, то копия привязанного
///          объекта в проекте есть, возможно, непривязанная никуда в проекте)
///          - удаляем связь из согласованной структуры
///          - удаляем все допсвязи для данной ссылки
///       генерация новых
///       - проходим по дереву ПРОЕКТА (на данный момент у всех объектов есть реальные id)
///          - если для двух объектов нет связи в согласованной
///            - создаем связку
///            - сохраняем ее id для дальнейшей генерации допсвязей
///       - генерим допсвязи
///     документы
///       - для каждого объекта КД
///          - получаем список документов своей копии в проекте и перебираем
///          - если отсутствует у объекта в КД - добавляем
///          - перебираем список документов объекта в КД и сравниваем со списком копии
///          - если документ отсутсвует в списке копии - удаляем
///            (при этом, объекты документов просто уходят в архив и файлы в хранилище не трогаются)
label
    ext;
type
    TElem = record
        prjParent
       ,prjChild
       ,kdID
       ,status
       ,kind
                : integer;
        count
                : real;
    end;
    TArr = array of integer;
var
    dsProjectObjects    // все объекты проекта
   ,dsRootElems         // корневые объекты проекта. по ним определяем часть структуры КД с которой работаем
   ,dsKDObjects         // все объекты КД имеющие отношение к проекту
   ,dsProjectLinks      //
   ,dsKDLinks           //
   ,dsProjectObjectDocs // документы привязанные к объекту в проекте
   ,dsKDObjectDocs      // документы привязанные к объекту в КД
   ,dsKDDocExtra
   ,dsProjectDocExtra
            : TADOQuery;
    arr : array of TElem;
                       // массив для сопоставления объектов проекта и КД
                       // содержит id созданных в рамках проектов объектов
                       // и id созданных по ним экземпляров в КД.
                       // после заполнения используется для построения связей
                       // в КД по образцу проекта (для подстановки вместо id
                       // проекта, реальные id)

    lnkArr: array of integer;
                       // массив добавленных в КД новых ссылок. используется
                       // для массового создания допсвязей, после добавления всех
                       // связей

    rootKDID
   ,rootPrjectID
   ,comma
            : string;
    aParent
   ,aChild
            : TArr;
    i, p, c
   ,aParent_
   ,aChild_
   ,extID
   ,doc_id             // содержит id записи объекта-документа после копирования его из проекта в КД
            :integer;
    hasLink : boolean;

    function GetProjectID( KDID: integer ): TArr;
    // по id из КД находим копию в проекте и возвращаем ее id (с минусом)
    var
        i : integer;
    begin
        SetLength(result, 0);
        for I := 0 to High(arr) do
        if (arr[i].kdID = KDID) then
        begin
            SetLength(result, length(result) + 1);
            result[high(result)] := arr[i].prjChild;
        end;
    end;

    function GetKDID( ProjectID: integer ): integer;
    /// поиск id оригинального объекта в проекте по его id в проекте
    var
        i : integer;
    begin
        result := 0;

        for I := 0 to High(arr) do
        if arr[i].prjChild = ProjectID then
        begin
            result := arr[i].kdID;
            exit;
        end;
    end;

    function GetStatus( kd_id: integer ): integer;
    var
        i : integer;
    begin
        result := 0;

        for I := 0 to High(arr) do
        if arr[i].kdID = kd_id then
        begin
            result := arr[i].status;
            exit;
        end;
    end;

    function HasParentsStatus( parent_kd_id, status: integer ): integer;
    /// ищем выше по дереву ближайшего родителя в указанном статусе
    var
        i, j: integer;
    begin
        result := 0;

        // ищем указанный объект-родитель по id в базе
        for I := 0 to High(arr) do
        if arr[i].kdID = parent_kd_id then
        begin
            // если его статус не соответствует заказанному - ищем выше по еирархии
            if arr[i].status <> status then
            begin

                // по значению родителя в рамках проекта находим этот объект
                // и передаем рекурсивно для дальнейшего разбора
                if ( arr[i].prjParent <> 0 ) then
                begin

                    for j := 0 to High(arr) do
                    if arr[j].prjChild = arr[i].prjParent then
                    begin
                        result := HasParentsStatus( arr[j].kdID, status );
                        break;
                    end;

                end;

            end else
            begin
            // иначе возвращаем id этого родителя как имеющего искомы признак
                result := arr[i].kdID;
                break;
            end;
        end;
    end;

    function HasBlockedParent( link_id: integer ): boolean;
    begin
        result := dmSDQ(
            ' SELECT COUNT(parent) FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child in ( SELECT child FROM '+ LNK_PROJECT_STRUCTURE_CROSS +
                             ' WHERE base_link = ' + IntToStr( link_id ) + ' )' +
            ' AND status = ' + IntToStr( PROJECT_OBJECT_READONLY ), 0
        ) > 0;
    end;

begin

    result := false;

{$IFNDEF test}
    if  not core.DM.ADOConnection.InTransaction
    then core.DM.ADOConnection.BeginTrans;
{$ENDIF}

    /// выясняем, является ли переданный объект непосредственно проектом.
    /// возможен вариант, что это отдельная ветка для выгрузки в КД,
    /// тогда подход к выборке стартовых объектов немного меняется.
    /// туда попадает и сам объект, а не только его потомки
    if dmSQ('SELECT kind FROM '+TBL_PROJECT+' WHERE id = '+IntToStr(ProjectID)) = KIND_PROJECT then
    begin

        /// получаем все объекты проекта (кроме документов)
        dsProjectObjects := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child in (SELECT child FROM ' + LNK_PROJECT_STRUCTURE_CROSS + ' WHERE parent = ' + IntToStr(ProjectID) + ')' );
        if not Assigned(dsProjectObjects) then goto ext;

        // получаем корневой элемент(-ы) проекта. он послужит точкой привязки к структуре КД
        dsRootElems := CORE.DM.OpenQueryEx(
            ' SELECT original_id, child FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE parent = ' + IntToStr(ProjectID){ + ' AND original_id IS NOT NULL'} );
        if not Assigned(dsRootElems) then goto ext;

        // собираем строчку для выборки из КД
        // сюда попадут id объектов из КД, которые непосредственно привязаны к объекту проекта
        // и являются корневыми в отображаемом дереве проекта
        rootKDID := '';
        comma := '';
        dsRootElems.First;
        while not dsRootElems.Eof do
        begin
            if not dsRootElems.FieldByName('original_id').IsNull then
            begin
                rootKDID := rootKDID + comma + dsRootElems.FieldByName('original_id').AsString;
                comma := ',';
            end;
            dsRootElems.Next;
        end;

        // выставляем признак архивного для отображения в списке проектов
        UpdateTable( ProjectID, TBL_PROJECT, ['icon'], [KIND_ARCHIVE]);

    end else
    begin

        /// получаем все объекты проекта (кроме документов)
        /// в данном случае, вместе с самим переданным объектом, посколку его тоже нужно залить в КД
        dsProjectObjects := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child = '+ IntToStr(ProjectID)+
            '     AND status = ' + IntToStr(STATE_PROJECT_READY)+
            ' UNION '+
            ' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child in (SELECT child FROM ' + LNK_PROJECT_STRUCTURE_CROSS + ' WHERE parent = ' + IntToStr(ProjectID) + ')'+
            '     AND status = ' + IntToStr(STATE_PROJECT_READY)
        );
        if not Assigned(dsProjectObjects) then goto ext;

        // получаем id переданного корневого объекта в КД
        dsRootElems := CORE.DM.OpenQueryEx(
            ' SELECT original_id, child FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child = ' + IntToStr(ProjectID){ + ' AND original_id IS NOT NULL'} );
        if not Assigned(dsRootElems) then goto ext;

        rootKDID := dsRootElems.FieldByName('original_id').AsString;

    end;

{
    /// получаем все объекты КД (кроме документов)
    if rootKDID <> '' then
    dsKDObjects := CORE.DM.OpenQueryEx(
        ' SELECT * FROM ' + TBL_OBJECT +
        ' WHERE id in (SELECT child FROM ' + LNK_STRUCTURE_CROSS + ' WHERE parent in (' + rootKDID + '))');
    if not Assigned(dsKDObjects) then goto ext;
}


    /// ОБРАБОТКА ОБЪЕКТОВ
    /// перебираем объекты проекта
    while not dsProjectObjects.Eof do
    begin

        /// пишем в рабочий массив данные объекта
        SetLength( arr, Length(arr) + 1);
        arr[high(arr)].prjParent := dsProjectObjects.FieldByName('parent').AsInteger;
        arr[high(arr)].prjChild := dsProjectObjects.FieldByName('child').AsInteger;
        arr[high(arr)].kdID := StrToIntDef(dsProjectObjects.FieldByName('original_id').AsString, 0);
        arr[high(arr)].status := dsProjectObjects.FieldByName('status').AsInteger;
        arr[high(arr)].kind := dsProjectObjects.FieldByName('kind').AsInteger;
        // запоминаем тип объекта, поскольку документы (kind=12) требуют создания отдельной
        // привязки на этапе создания связей

        // если объект отсутствует в КД и в статусе готовности
        if ( arr[high(arr)].kdID = 0 ) AND
           ( dsProjectObjects.FieldByName('status').AsInteger = STATE_PROJECT_READY ) then
        begin
            // создаем новый
            arr[high(arr)].kdID := mngData.CopyObject( arr[high(arr)].prjChild, 0, TBL_PROJECT, TBL_OBJECT);

            if arr[high(arr)].kdID = 0 then goto ext;

            // дописываем проектной копии id созданного по ее образцу оригинала в КД
            // это позволит не создавать кучу копий при повторных заливах проекта в КД:
            // закрытие проекта может быть частично ветками, а не целиком
            UpdateTable(
                Integer(dmSQ( 'SELECT id FROM ' + TBL_PROJECT_OBJECT_EXTRA + ' WHERE parent =' + IntToStr(arr[high(arr)].prjChild) )),
                TBL_PROJECT_OBJECT_EXTRA,
                ['original_id', 'status'],
                [arr[high(arr)].kdID, STATE_PROJECT_DISABLED]
            );

            /// удаляем всех редакторов и проверяющих с этого объекта
//            UnlinkEditorsFromObject( arr[high(arr)].prjChild );
//            UnlinkCheckersFromObject( arr[high(arr)].prjChild );
               // не удаляем, чтобы наглядно иметь информацию о тех, кто с объектом работал
               // после выгрузки удалять их с объекта нельзя

        end else

        if ( arr[high(arr)].kdID <> 0 ) then
        begin
            // иначе, обновляем данные с отправкой средыдущего состояния в архив
            // если объект доступен для редактирования и работа над ним завершена
            if dsProjectObjects.FieldByName('status').AsInteger = PROJECT_OBJECT_DONE then

            // игнорим объекты, котрые являются заблокированными (взяты из КД для показа
            // состава и не огут быть изменены)
            if ( dsProjectObjects.FieldByName('status').AsInteger <> PROJECT_OBJECT_READONLY ) and
            //  а так же, не является потомком одного из объектов с таким статусом (это не допустимо и
            // и является ошибкой)
               not HasBlockedParent( dsProjectObjects.FieldByName('lid').AsInteger )
            then

            if not
                mngData.ChangeObject(
                    arr[high(arr)].kdID,
                    ['mark', 'name', 'mass', 'comment', 'has_docs', 'material_id', 'realization', 'markTU'],
                    [
                       dsProjectObjects.FieldByName('mark').AsString,
                       dsProjectObjects.FieldByName('name').AsString,
                       dsProjectObjects.FieldByName('mass').AsString,
                       dsProjectObjects.FieldByName('comment').AsString,
                       dsProjectObjects.FieldByName('has_docs').AsInteger,
                       dsProjectObjects.FieldByName('material_id').AsInteger,
                       dsProjectObjects.FieldByName('realization').AsString,
                       dsProjectObjects.FieldByName('markTU').AsString
                    ]
                ) then goto ext;
        end;


        // при обновлении документов следует создать привязку к копии объекта-документа
        // в согласованной структуре, если таковой связки еще нет (что бывает, когда
        // документ не был скопирован из согласованной структуры КД, а был создан в рамках
        // проекта

        // получаем список документов текущего объекта
        dsProjectObjectDocs := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_DOCUMENT_PROJECT +
            ' WHERE project_object_id = ' + IntToStr(arr[high(arr)].prjChild)
        );

        /// сначала переберем все документы в проекте и проверим их наличие
        /// в КД. при отсутсвии - создадим
        if Assigned(dsProjectObjectDocs) then
        while not dsProjectObjectDocs.eof do
        begin

            // смотрим, есть ли ссылка данного документа на объект документа в КД
            // при наличии документа в проекте
            if dsProjectObjectDocs.FieldByName('doc_id').IsNull and
               not dsProjectObjectDocs.FieldByName('project_doc_id').IsNull then
            begin
                // копируем объект-документ в КД
                doc_id := mngData.CopyObject(
                    dsProjectObjectDocs.FieldByName('project_doc_id').AsInteger, 0, TBL_PROJECT, TBL_OBJECT );

                // добавляем ссылки на экземпляр документа в КД
                mngData.UpdateTable(
                    dsProjectObjectDocs.FieldByName('doc_extra_id').AsInteger,
                    TBL_DOCUMENT_EXTRA,
                    ['object_id', 'doc_id'],
                    [arr[high(arr)].kdID, doc_id]
                );
            end;

            dsProjectObjectDocs.Next;
        end;


        // получаем список документов текущего объекта
        dsKDObjectDocs := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_DOCUMENT_KD +
            ' WHERE object_id = ' + IntToStr(arr[high(arr)].kdID)
        );

        /// сначала переберем все документы в проекте и проверим их наличие
        /// в КД. при отсутсвии - создадим
        if Assigned(dsKDObjectDocs) then
        while not dsKDObjectDocs.eof do
        begin

            /// если документ упоминается в КД, но в проекте удален -
            /// удаляем в КД
            /// при удалении документа в проекте, удаляется объект-документ из проекта
            /// и сбрасываются ссылки на документ и объект в проекте к которым он был привязан
            /// т.е. по project_doc_id = null и project_object_id = null можно
            /// понять, что документ удален в рамках проекта
            if not dsKDObjectDocs.FieldByName('doc_id').IsNull and
               dsKDObjectDocs.FieldByName('project_doc_id').IsNull then
            begin
                /// удаляем объект документа c помещением в истрию
                DeleteObject( dsKDObjectDocs.FieldByName('doc_id').AsInteger, '' );

                /// удаляем сами допданные документа, поскольку к ним больше не привязано
                /// документов ни в КД ни в проекте
                dmEQ(' DELETE FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE doc_id = ' + dsKDObjectDocs.FieldByName('doc_id').AsString );
            end;

           dsKDObjectDocs.Next;
        end;


        dsProjectObjects.Next;
    end;



    /// ОБРАБОТКА СВЯЗЕЙ
    /// перебираем все связи КД, определяя удаленные в проекте

    // получаем все связи проекта
    dsProjectLinks := CORE.DM.OpenQueryEx(
        ' SELECT * FROM ' + LNK_PROJECT_STRUCTURE + ' WHERE id in (' +
          ' SELECT DISTINCT base_link FROM ' + LNK_PROJECT_STRUCTURE_CROSS +
          ' WHERE parent = ' + IntToStr(ProjectID) +
        ')'
    );

    // получаем все связи всех элементов вложенных в рассматриваемые объекты КД
    if rootKDID <> '' then
    dsKDLinks := CORE.DM.OpenQueryEx(
        ' SELECT * FROM ' + LNK_STRUCTURE + ' WHERE id in (' +
        ' SELECT DISTINCT base_link FROM ' + LNK_STRUCTURE_CROSS +
        ' WHERE parent in (' + rootKDID + '))'
    );


    /// перебираем связи КД и пытаемся найти удаленные в проекте
    /// - получаем связку из КД
    /// - из arr[] находим id в проекте для parent и child связки (с минусами)
    /// - в связках проекта ищем такое сочетание parent и child (с минусами)
    /// - при отсутсвии - удаляем связку из КД (отправляем в архив)
    if Assigned(dsKDLinks) then
    while not dsKDLinks.eof do
    begin
        aParent := GetProjectID(dsKDLinks.FieldByName('parent').AsInteger);
        aChild  := GetProjectID(dsKDLinks.FieldByName('child').AsInteger);

        /// если элемент в проекте имеет статус нередактируемого, то при добавлении
        /// его в проект вложенные в него элементы не были скопированы из согласованной структуры
        /// чтобы не принять их отсутсвие за изменения в рамках проекта и не погрохать их
        /// в КД, просто пропускаем отработку связей таких объектов, при этом требуется
        /// отследить статус не только у самого объекта, но и у всех родителей
        if (GetStatus(dsKDLinks.FieldByName('child').AsInteger) <> PROJECT_OBJECT_READONLY) and
           (HasParentsStatus(dsKDLinks.FieldByName('parent').AsInteger, PROJECT_OBJECT_READONLY) = 0) then
        begin

            hasLink := false;

            // если указанная связка в проекте всего одна и разорвана,
            // массив парентов или чилдов будет пуст
            if (Length(aParent) > 0) and (Length(aChild) > 0) then
            for p := 0 to High(aParent) do
            for c := 0 to High(aChild) do
            begin
                dsProjectLinks.First;
                if dsProjectLinks.Locate('parent;child', VarArrayOf([aParent[p], aChild[c]]), []) then
                begin
                    hasLink := true;

                    /// если количество отличается, обновляем
                    if dsProjectLinks.FieldByName('count').AsFloat <> dsKDLinks.FieldByName('count').AsFloat then
                    UpdateTable( dsKDLinks.FieldByName('id').AsInteger, LNK_STRUCTURE, ['count'], [dsProjectLinks.FieldByName('count').AsFloat] );

                    break;
                end;
            end;

            if not hasLink then
            begin
                /// такой связки в проекте не обнаружено, будем удалять из КД
                mngData.DeleteCrossLinks( LNK_STRUCTURE, dsKDLinks.FieldByName('id').AsInteger );
                mngData.DeleteLink( LNK_STRUCTURE, dsKDLinks.FieldByName('id').AsInteger, DEL_MODE_NO_CROSS );
            end;

        end;

        dsKDLinks.Next;
    end;



    /// теперь добавляем новые ссылки, созданные в рамках проекта
    /// - получаем связку из проекта
    ///     - из arr[] находим id в КД для parent и child связки
    ///     - в связках КД ищем с таким сочетанием объектов
    ///     - есди нет, добавляем, запоминая для создания допсвязей
    /// - после прохрждения всех связок проекта
    ///     - создаем допсязи для всех новых связей
    dsProjectLinks.First;
    while not dsProjectLinks.eof do
    begin
        aParent_ := GetKDID(dsProjectLinks.FieldByName('parent').AsInteger);
        aChild_  := GetKDID(dsProjectLinks.FieldByName('child').AsInteger);

        // в случае, когда проект был пустой при создании и из спецификации было подгружен
        // корненвой объект, которого нет в базе, при заливке в КД привязываем к
        // папке Спецификации
        if   aParent_ = 0
        then aParent_ := GetObjectBy( 'name', SECTION_SPECIF, IntToStr(KIND_SECTION));

        /// id успешно сопоставлены
        /// ищем связку в КД...
        if (aParent_ <> 0) and (aChild_ <> 0) then
        begin
            hasLink := false;

            if Assigned(dsKDLinks) then
            begin
                dsKDLinks.First;
                hasLink := dsKDLinks.Locate('parent;child', VarArrayOf([aParent_, aChild_]), []);
            end;

            if not hasLink then
            begin
                /// такой связки в КД не обнаружено, будем создавать
                SetLength(lnkArr, Length(lnkArr)+1);
                lnkArr[High(lnkArr)] := mngData.AddLink( LNK_STRUCTURE, aParent_, aChild_ );

                /// записываем количество
                UpdateTable( lnkArr[High(lnkArr)], LNK_STRUCTURE, ['count'], [dsProjectLinks.FieldByName('count').AsFloat] );
            end;
        end;

        dsProjectLinks.Next;
    end;

    /// сторим допсвязи ко всем новым связям
    for I := 0 to High(lnkArr) do
       mngData.CreateCrossLinks( LNK_STRUCTURE, lnkArr[i] );


{$IFNDEF test}
    // выставляем признак завершения проекта
    if not dmEQ( Format( SQL_SET_PROJECT_STATUS, [PROJECT_DONE, ProjectID]) )then goto ext;

    // завершаем транзакцию
    if core.DM.ADOConnection.InTransaction
    then core.DM.ADOConnection.CommitTrans;
{$ENDIF}

    result := true;

ext:

{$IFNDEF test}
    if core.DM.ADOConnection.InTransaction
    then core.DM.ADOConnection.RollbackTrans;
{$ENDIF}

end;

function TDataManager.FreezProject(ProjectID: integer): boolean;
begin
    result := dmEQ( Format( SQL_SET_PROJECT_STATUS, [PROJECT_ZREEZE, ProjectID]) );
end;


function TDataManager.DeleteProject(ProjectID: integer): boolean;
/// метод удаляет указанный проект, вместе со всей историей.
/// восстановление удаленного проекта не предпологается.
///    projectID - id объекта проекта в таблице [project_object]
begin
    result := dmEQ( Format( SQL_DELETE_PROJECT, [ProjectID]) );
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

function TDataManager.AddObject(fields: string; values: array of variant; tablename: string = ''; custom_only: boolean = false): integer;
{ метод создает новый объект и возвращает его id
  fields - строка названий полей через запятую для которых предоставлены данные
  values - одномерный массив со значениями для полей из fields, идущие в том же порядке
  tablename - альтенативная таблица хранения объектов
  custom_only - если установлен, к списку полей не будут добавляться uid и created поля,
               что позволит добавить запись в любую не специализированную таблицу
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

        if not custom_only then
        begin
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
        end;

        // создаем объект
        result := dmIQ( Format( SQL_ADD_OBJECT, [ ifthen( tablename = '', TBL_PROJECT, tablename), fields, val ] ));

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
{ метод меняет данные объекта, сохраняя предыдущую версию в архиве
  Fields, Values - одномерный динамический массив. имена полей и значения в том же порядке как и в Fields
}
label ext;
begin
    lC('TDataManager.ChangeObject');
    result := false;

    ChangeObjectEx( TBL_OBJECT, id, Fields, Values );
    ChangeObjectEx( TBL_PROJECT, id, Fields, Values );

    result := true;
ext:
    lCE;
end;

function TDataManager.ChangeObjectEx( tablename: string; id: integer; Fields, Values: array of variant;
  comment: string): boolean;
{ метод меняет данные объекта, сохраняя предыдущую версию в архиве
  Fields, Values - одномерный динамический массив. имена полей и значения в том же порядке как и в Fields
}
label ext;
var
    curr: TADOQuery;
    i: integer;
    identity : boolean;
    _flds, comma: string;
begin
    lC('TDataManager.ChangeObject');
    result := false;

    if Length(Fields) <> Length(Values) then
    begin
        lE('Не совпадает количество полей и переданных значений');
        goto ext;
    end;

    // проверяем, не совпадает ли новый набор значений с текущим, чтобы не забивать истрию
    comma := '';
    _flds := '';
    for I := 0 to High(fields) do
    begin
        _flds := _flds + comma + fields[i];
        comma := ',';
    end;

    identity := true;

    curr := CORE.DM.OpenQueryEx( 'SELECT ' + _flds + ' FROM ' + tablename + ' WHERE id = ' + IntToStr(id) );
    if Assigned(curr) and (curr.RecordCount > 0) then
    begin

        for I := 0 to High(fields) do
        if curr.FieldByName( fields[i] ). AsString <> VarToStr(values[i]) then
        begin
            lM(fields[i] + ': ' + curr.FieldByName( fields[i] ).AsString + ' <> ' + VarToStr(values[i]));
            identity := false;
            break;
        end;

    end;

    // есть расхождения в данных текущего состояния и переданных на изменение?
    if not identity then
    begin

        // кидаем текущее состояние объекта в архив
        if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [tablename, Core.User.id, Comment, tablename, id] )) then goto ext;

        // изменяем актуальное состояние
        // и обновляем новыми данными
        if not dmEQ( BuildUpdateSQL( id, tablename, Fields, Values ) ) then goto ext;

        result := true;

    end;
ext:
    lCE;
end;


function TDataManager.CheckLinkAllow(child_kind, child_subkind, child_status,
  parent_kind, parent_subkind, parent_status: integer): string;
// проверка на возможность привязки двух объектов друг к другу, исходя из
// их типов и текущего рабочего статуса. возвращает строку с описание ошибки,
// если привязка недопустима.
// child_kind, parent_kind - значение поля [kind] объекта
// child_subkind, parent_subkind - значение поля [icon] объекта
// child_status, parent_status - значение поля [status] объекта, если есть
//                               значение из диапазона констант PROJECT_OBJECT_ХХХ

begin
    result := '';

    if   parent_status = PROJECT_OBJECT_READONLY
    then result := 'Объект только для просмотра, привязка невозможна.';

    // далее подразумевается, что родитель доступен для редактирования и может иметь
    // один из статусов этапов разработки: не в работе, в работе, в проверке, в ожидании, завершен

    if   parent_status <> PROJECT_OBJECT_INWORK
    then result := 'Объект не находится в режиме редактирования.';

    // после проверок на статусы, проверяем исходя из самих типов объектов

//    if   ( parent_subkind = KIND_SPECIF ) and
//         ( child_subkind <> KIND_ISPOLN )
//    then result := 'К спецификации может быть привязано только исполнение.';

    if   ( parent_kind in [ KIND_DETAIL, KIND_STANDART, KIND_OTHER, KIND_MATERIAL ] )
    then result := 'Привязка к детали, материалу, стандартному или прочему изделию не допустима.';

    if   ( parent_kind in [ KIND_COMPLECT, KIND_ASSEMBL ] ) and
         ( child_kind = KIND_COMPLEX )
    then result := 'Привязка комплекса к сборочной единице или комплекту не допустима.';

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

    result := true;

ext:

    lCE;
end;

function TDataManager.GetProjectWorkgroup(project_id: integer): integer;
begin
    result := dmSQ(' SELECT workgroup_id FROM ' + TBL_PROJECT_EXTRA + ' WHERE parent = ' + IntToStr( project_id ));
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

    result := true;
ext:
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
  rebuild_sublinks - будут перебраны све связи, которые ссылаются на эту и глубже (вся ветка)
               и для каждой из них будут созданы допссылки)
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
    var
       i : integer;
       present: boolean;
    begin
        if not dmOQ( Format( SQL_GET_CHILDS, [ TableName, id ] )) then exit;
        while not Core.DM.Query.Eof do
        begin
            // проверяем, что эта связка отсутствует в массиве, иначе будут дубли в допсвязях
            present := false;
            for i := 0 to High(arr) do
            if arr[i].link_id = Core.DM.Query.FieldByName('id').AsInteger then
            begin
                present := true;
                break;
            end;

            // добавляем в очередь на создание допсвязей
            if not present then
            begin
                SetLength( arr, Length(arr)+1 );
                arr[ High(arr) ].link_id := Core.DM.Query.FieldByName('id').AsInteger;
                arr[ High(arr) ].child := Core.DM.Query.FieldByName('child').AsInteger;
            end;

            Core.DM.Query.Next;
        end;
    end;

begin
    lC('TDataManager.CreateCrossLinks');
    result := false;

    if id = 0 then goto ext;

    // по child связки ищем все связки, которые ссылаются на него как на родителя
    dmOQ( Format( SQL_SELECT_LINK_DATA, [ TableName, id ] ) );
    child_id := Core.DM.Query.FieldByName('child').AsInteger;

    // создаем допссылки для указанной связки
    if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [TableName, id, id, child_id] )) then goto ext;

    // перелинковка всех потомков при единичном добавлении элемента
    // не рекомендуется при массовом создании элементов, поскольку приводит к
    // страшным тормозам из-за избыточности операций.
    if rebuild_sublinks then
    begin

        // по child связки ищем все связки, которые ссылаются на него как на родителя
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
                if not DeleteCrossLinks( TableName, arr[i].link_id ) then goto ext;

                // создаем допсвязки для указанной связки уже с учетом новой созданой
                if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [ TableName, arr[i].link_id, arr[i].link_id, arr[i].child ] )) then goto ext;

            end;
        end;
    end;

    result := true;
ext:
    lCE;
end;

function TDataManager.CreateDocumentVersion(object_id, version, doc_type: integer; name, filename, comment: string; is_main: integer = -1): integer;
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
  doc_type  - тип документа. id из таблицы-справочника document_type
  name      - имя файла, которое будет идентификатором для связки таблиц [PDM].[Document_extra] и [FilesDB].[PDMFiles]
  filename  - полный путь до файла
  is_main - признак того, что это основной документ. указывает на режим установки признака при создании новой версии
             0 = не является основным
             1 = является основным
             -1 = автоматическая установка 1, если это первый привязанный документ

  Алгоритм
  - создаем новый объект типа документ в таблице object
  - создаем и привязываем к нему запись с допданными в таблице document_extra
  - загружаем указанный файл в хранилище [FilesDB].[PDMFiles]
}
label ext;
var
    doc_id
            : integer;
    fullname
   ,hash
            : string;
    GUID : TGUID;
begin

    lC('CreateDocumentVersion');
    result := 0;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    // проверяем, есть ли уже у объекта главный файл
    if is_main = -1 then
    begin
        if HasMainDoc( object_id )
        then is_main := 0
        else is_main := 1;
    end;

    /// не передан тип файла, определяем сами по расширению
    if   doc_type = 0
    then doc_type := mngFile.GetFileType( ExtractFileExt( ExtractFileName( filename ) ) );

    // новый объект документа
    doc_id := AddObject('kind, name, comment, icon', [ KIND_DOCUMENT, name, comment, doc_type ]);
    if doc_id = 0 then goto ext;

    // привязываем документ к изделию
//    if AddLink( LNK_DOCUMENT_OBJECT, object_id, doc_id ) = 0 then goto ext;

    // ставим объекту-изделию признак наличия привязанных документов
    ChangeObjectEx( TBL_PROJECT, object_id, ['has_docs'], [1] );
    ChangeObjectEx( TBL_OBJECT, object_id, ['has_docs'], [1] );

    // определяемся с номером версии
    lastFullVersionNumber := '';

    if version = 0
    then lastVersionNumber := GetNextVersionNumber( ExtractFileName(filename), object_id )
    else lastVersionNumber := version;

    // уникальное имя с учетом номера версии и родителя для хранилища файла
    CreateGUID(GUID);
    fullname := GUIDToString(GUID);

    // хэш сумма файла для отслеживания наличия изменений при создании новых версий из данной
    hash := mngFile.GetHash( filename );

    // создаем запись с дополнительными данными документа
    if not dmEQ( Format( SQL_CREATE_DOCEXTRA, [doc_id, object_id, lastVersionNumber, name, doc_type, fullname, hash, is_main] )) then goto ext;

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

function TDataManager.CreateProject(name, comment, mark, parent_prod_kod, prod_kod: string; objectId,
  workgroupId: integer): integer;
/// создание нового проекта для переданного объекта (спецификации)
/// name        - пользовательское имя проекта
/// comment     - комментарий к проекту
/// mark        - обозначение базовой спецификации или взятого в работу объекта
/// parent_prod_kod - ниманование родительского раздела типа продкуции
/// prod_kod    - собственное наименование типа продукции к которой привязать проект
/// objectId    - объект-спецификация, либо ноль, если создается пустой проект
/// workgroupId - существующая рабочая группа, либо ноль, если группа будет
///               конфигурироваться позднее
///
/// перед созданием проверяется, не присутствуют ли проект в котором эта
/// спецификация уже редактируется.
var
    project_id
   ,project_extra_id

   ,base_spec_id    /// автоматически создаваемая спецификация
   ,base_isp_id     /// автоматически создаваемое нулевое исполнение
            : integer;
begin
    result := 0;

    /// проверяем, не находится ли данная спецификация в работе в рамках существующего проекта
    if ( objectId <> 0 ) and SpecInWork( objectId ) then
    begin
        CORE.DM.DBError := lW('Спецификация '+mark+' уже находится в разработке.');
        exit;
    end;


    // получаем обозначение редактируемого объекта, чтобы записать его в обозначение проекта
    if (objectId <> 0) and (trim(mark) = '') then
    mark := dmSDQ('SELECT mark FROM ' + VIEW_OBJECT + ' WHERE child = ' + IntToStr(objectId), '');

    // создаем объект проекта
    project_id := AddObject('name, mark, kind, comment', [name, mark, KIND_PROJECT, comment], TBL_PROJECT);
    if project_id = 0 then exit;

    // привязываем к дереве структуры проектов
    if AddLink( LNK_PROJECT_STRUCTURE, 0, project_id ) = 0 then exit;

    /// создаем запись в таблице допданных проекта
    mngData.AddObject(
        'status, parent, workgroup_id, parent_kod, kod',
        [ 0, project_id, workgroupId, parent_prod_kod, prod_kod ],
        TBL_PROJECT_EXTRA,
        true                                       // создание без системнх допполей
    );

    // если это проект по редактированию объекта, копируем его и его непосредственных
    // потомков в рабочую таблицу проектов c привязкой к корню проекта
    if objectId <> 0
    then base_spec_id := CopyObjectToProject( project_id, project_id, objectId );

    /// если будет разрабатываться новая спецификация
    /// автоматом создаем объект спецификации, нулевое исполнение и привязываем их
    /// друг к другу и к проекту, как к корню
    if objectId = 0 then
    begin
        /// создание нулевой спецификации
        base_spec_id := CreateProjectObject( mark, '', '', name, '', '', KIND_ASSEMBL, 0, KIND_SPECIF, project_id );

        /// создание нулевого исполнения
        base_isp_id := CreateProjectObject( mark, '', '', name, '', '', KIND_ASSEMBL, 0, KIND_ISPOLN, project_id );

        /// привязка спецификации к проекту
        if not CreateCrossLinks( LNK_PROJECT_STRUCTURE, AddLink( LNK_PROJECT_STRUCTURE, project_id, base_spec_id )) then exit;

        /// привязка исполнения к спецификации
        if not CreateCrossLinks( LNK_PROJECT_STRUCTURE, AddLink( LNK_PROJECT_STRUCTURE, base_spec_id, base_isp_id )) then exit;
    end;

    /// запустившего проект пользователя делаем редактором и контролером корневой спецификации
    /// что позволяет только ему работать с ее исполненеиями
    LinkEditorToObject( base_spec_id, CORE.User.id, project_id );
    LinkCheckerToObject( base_spec_id, CORE.User.id, project_id );
    /// ...и берем в работу
    SetProjectObjectState( base_spec_id, STATE_PROJECT_INWORK );

    result := project_id;
end;

function TDataManager.CreateProjectObject( mark, realization, markTU, name, mass, comment: string; kind_id, material_id, obj_icon, project_id: integer ): integer;
/// создает в проектк новый объект указанного типа и атрибутами, вместе с записью допданных
var
    ext_id: integer;
begin
    // создаем сам объект
    result := AddObject('mark, realization, markTU, name, kind, mass, material_id, comment, icon ',
                            [mark, realization, markTU, name, kind_id, mass, material_id, comment, obj_icon ]);

    // создаем допданные для объекта
    ext_id := AddObject('status,parent,project_id', [0,result,project_id], TBL_PROJECT_OBJECT_EXTRA, true{не добавлять к списку служебные поля});

    // привязываем допданные к объекту
    AddLink( LNK_PROJECT_OBJECT_EXTRA, result, ext_id );

end;

function TDataManager.CopyObject(source_id, target_id: integer; source_table,
  target_table: string): integer;
/// копирование данных объекта из одной таблицы в другую.
///    - source_id - объект в source_table
///    - target_id - объект в target_table
///    - source_table - имя исходной таблицы
///    - target_table - имя целевой таблицы
///
///  подразумевается, что таблици ымеют одинаковый набор полей.
///  если не указан target_id (=0), будет создана новая запись, иначе - перезаписана
///  указанная.
///  возвращает id созданной/перезаписанной в target_table записи
///
///  используется в механизме проектов для клонирования объектов при создании проекта
///  или перезаписи основной структуры при завершении проекта
var
    fields : string;
begin
    /// получаем список неключевых полей исходной таблицы
    fields := dmSDQ( Format( SQL_GET_ALL_FIELDS, [source_table, source_table] ), '');

    result := dmSDQ( Format( 'INSERT INTO %s (%s) SELECT %s FROM %s WHERE id = %d '+
                  'select scope_identity() as id',
                  [target_table, fields, fields, source_table, source_id] ), 0 );
end;

function TDataManager.CopyObjectToProject(projeсt_id, parent_id,
  object_id: integer): integer;
///  метод копирует из основной структуры (таблиц object и structure) указанный
///  элемент в рабочую структуру указанного проекта
///
///  projeсt_id - существующий проект (id из таблицы project_object)
///  parent_id - существующий в проекте объект (id из таблицы project_object)
///  object_id - копируемый объект (id из таблицы object)
///
///  главная тонкость в том, что копирование происходит между аналогичными по
///  сторениию структурами, но у каждой различный набор id. т.е. требуется
///  создать в целевой структуре новые объекты по образцу исходной и основываясь
///  на исходных id воссоздать связи на новых id
///
///  метод применяется при создании нового проекта на основе выбранногго объекта
///  и добавлении в проект объекта из справочника основных (существующих вне проекта)
///
///  алгоритм:
///  при копировании возможны три основных типа объектов (варианта действий)
///    1) копируется спецификация
///       - копируем спецификацию как отдельный объект
///       - находим все ее исполнения и для каждого
///           - копируем исполнение
///           - подвязываем к спецификации
///           - копируем его непосредственных потомков
///           - подвязываем каждый к исполнению
///    2) исполнение
///       - копируем исполнение
///       - копируем его непосредственных потомков
///       - подвязываем каждый к исполнению
///    3) любой сингловый объект (деталь, прочее изделие, материал и т.п.)
///       - копируем как простой объект
///
var
    kind
   ,id
   ,link_id
   ,i
   ,version_id
            : integer;

    mark_current
   ,mark_new
            : string;

    links : array of integer;

    dsTopElems
   ,ObjectDocs
            : TADOQuery;

    // сохранение созданной ссылки в массиве
    procedure StoreLink( id: integer );
    begin
        SetLength(links, Length(links) + 1);
        links[high(links)] := id;
    end;

    function GetKind( obj_id: integer ): integer;
    begin
        result := dmSDQ(' SELECT isnull(icon, kind) FROM '+ TBL_OBJECT + ' WHERE id = ' + IntToStr(object_id), 0);

        if result = 0
        then result := dmSDQ(' SELECT isnull(icon, kind) FROM '+ TBL_PROJECT + ' WHERE id = ' + IntToStr(object_id), 0);
    end;

    // копирование объекта из основного справочника в рабочий справочник проектов
    function CopySingleObject( obj_id: integer ): integer;
    var
        present_id: integer;

    begin
        // ищем среди рабочих объектов существующую копию указанного (чтобы не создавать лишних копий)
        // если пытаемся привязать объект из objects, поищем его в original_id
        // иначе, привязывается уже скопированный объект и его id уже годится для работы

        // при этом учитывается, что каждый проект имеет собственный набор объектов, взятых из КД и собственных
        present_id := dmSDQ(
            'SELECT TOP 1 child FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE (original_id = ' + IntToStr(obj_id) +
            ' or child = ' + IntToStr(obj_id) +
            ' ) AND project_id = '+IntToStr(projeсt_id), 0 );

        if present_id = 0
        then
        begin
            // копируем объект из основного справочника в рабочий
            result := CopyObject( obj_id, 0, TBL_OBJECT, TBL_PROJECT);
            // связываем объект и его допданные

            /// создаем запись в таблице допданных
            mngData.AddObject(
                'parent, original_id, project_id',
                [ result, obj_id, projeсt_id ],
                TBL_PROJECT_OBJECT_EXTRA,
                true                                       // создание без системнх допполей
            );

            /// проверяем, не привязаны ли к данному объекту документы
            ObjectDocs := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_DOCUMENT_KD + ' WHERE object_id = ' + IntToStr(obj_id) );
            if Assigned(ObjectDocs) and (ObjectDocs.RecordCount > 0) then
            /// перебираем их
            while not ObjectDocs.Eof do
            begin

                /// если отсутствует ссылка на объект-документ в рамках проекта, создаем
//                if ObjectDocs.FieldByName('project_object_id').IsNull then
                begin

                    version_id := CopyObject( ObjectDocs.FieldByName('doc_id').AsInteger, 0, TBL_OBJECT, TBL_PROJECT);

                    /// проставляем ссылку на копию документа в проекте
                    UpdateTable(
                        dmSDQ('SELECT id FROM ' +TBL_DOCUMENT_EXTRA+ ' WHERE object_id = ' + IntToStr(obj_id), 0 ),
                        TBL_DOCUMENT_EXTRA,
                        ['project_id', 'project_object_id', 'project_doc_id'],
                        [projeсt_id, result, version_id ]
                    );

                end;

                ObjectDocs.Next;
            end;
        end
        else
            // берем уже существующий
            result := present_id;

        if result = 0 then exit;

    end;

    // копирование исполнения с наполнением первого уровня
    function CopyIspoln( obj_id: integer ): integer;
    var
        query: TDataset;
    begin
        // копируем исполнение из основного справочника в рабочий
        result := CopySingleObject( obj_id );
        if result = 0 then exit;

        // получаем непосредственных потомков
        query := CORE.DM.OpenQueryEx( 'SELECT child FROM ' + VIEW_OBJECT + ' WHERE parent = ' + IntToStr(obj_id) );
        if assigned(query) then
        while not query.eof do
        begin

            // копируем и привязываем к исполнению
            id := CopySingleObject( query.fields[0].AsInteger );
            link_id := AddLink( LNK_PROJECT_STRUCTURE, result, id );

            if link_id = 0 then
            begin
                result := 0;
                exit;
            end;

            // сохраняем id ссылки для дальнейшего создания допссылок
            StoreLink( link_id );

            query.Next;
        end;
    end;

    function CopySpecification( obj_id: integer ): integer;
    var
        query: TDataset;
    begin
        // копируем спецификацию из основного справочника в рабочий
        result := CopySingleObject( obj_id );
        if result = 0 then exit;

        // получаем непосредственных потомков (по идее, у спецификации это могут быть только исполнения)
        query := CORE.DM.OpenQueryEx( 'SELECT child FROM ' + VIEW_OBJECT + ' WHERE parent = ' + IntToStr(obj_id) + ' AND icon = ' + IntToStr(KIND_ISPOLN));
        if assigned(query) then
        while not query.eof do
        begin

            // копируем и привязываем к исполнению
            id := CopyIspoln( query.fields[0].AsInteger );
            link_id := AddLink( LNK_PROJECT_STRUCTURE, result, id );

            if link_id = 0 then
            begin
                result := 0;
                exit;
            end;

            // сохраняем id ссылки для дальнейшего создания допссылок
            StoreLink( link_id );

            query.Next;
        end;

    end;

begin

    SetLength(links, 0);

    // выбираем алгоритм работы и копируем объекты
    case GetKind( object_id ) of
        KIND_SPECIF : result := CopySpecification(object_id);
        KIND_ISPOLN : result := CopyIspoln(object_id);
        else          result := CopySingleObject(object_id);
        // рекурсивно разбираем все элементы дерева, попадающего в проект
    end;

    // привязываем верхний к проекту, как к корню
    if   result <> 0  then
    begin

        // привязываем верхний из скопированных элементов к проекту/родителю
        if parent_id <> 0
        then
            link_id := AddLink( LNK_PROJECT_STRUCTURE, parent_id, result )
        else
        if parent_id = 0
        then
            link_id := AddLink( LNK_PROJECT_STRUCTURE, projeсt_id, result );

        // косяк при создании ссылки
        if link_id = 0 then
        begin
            result := 0;
            exit;
        end;

        // сохраняем для создания допссылок
        StoreLink( link_id );


        // если копируемый объект является корневым для проекта, то выставляем статус позволяющий его редактирование
        // считается, что взят на редактирование именно этот объект, а все вложенные в него просто
        // отображают наполнение этого объекта и для редактирования не доступны для редактирования.
        // НО, блокировка на редактирование распространяется только на скопированные из реального
        // справочника объекты. все новые объекты созданные в рамках проекта имеют полное
        // разрешение на редактирование, где бы в структуре не находились, поскольку они появятся в
        // основном справочнике только после завершения проекта или его частичного утверждения
        if (parent_id = projeсt_id) or (parent_id = 0) then
        begin

            // разблокируем корневой элемент проекта для назначения редакторов.
            // получаем id записей PROJECT_OBJECT_EXTRA для корневого элемента
            // и всех ссылающихся на него исполнений
            dsTopElems := CORE.DM.OpenQueryEx( Format(SQL_GET_TOPOBJECT_EXTRA_ID, [ projeсt_id ]) );

            while not dsTopElems.eof do
            begin
                UpdateTable(
                    dmSDQ( 'SELECT id FROM '+TBL_PROJECT_OBJECT_EXTRA+ ' WHERE parent = ' + dsTopElems.FieldByName('child').AsString, 0 ),
                    TBL_PROJECT_OBJECT_EXTRA,
                    ['status'],
                    [STATE_PROJECT_READONLY] );
                dsTopElems.Next;
            end;

//            mark_current := dmSQ('SELECT mark FROM '+TBL_PROJECT+' WHERE id = '+IntToStr(projeсt_id));
//            mark_new := dmSQ('SELECT mark FROM '+TBL_PROJECT+' WHERE id = '+IntToStr(result));

            // обновляем список обозначений объектов в работе
            UpdateProjectMark( projeсt_id );
        end;



        // создаем набор допссылок для всех ссылок созданных в рамках создания проекта
        for I := 0 to High(links) do
        if not CreateCrossLinks( LNK_PROJECT_STRUCTURE, links[i] ) then
        begin
           result := 0;
           exit;
        end;

    end;
end;


function TDataManager.AddSection(parent: integer; name, tag, tablename,
  condition: string; colConfig: string = ''; user_id: integer = -1): integer;
///  создание раздела (папки) на рабочем столе с указанем условий выборки данных
label ext;
var
    section_id
   ,section_extra_id
            : integer;
begin

    lC('CreateSection');
    result := 0;

    // создаем папку
    section_id := mngData.AddObject('kind, name', [KIND_SECTION, name], TBL_OBJECT);
    if section_id = 0 then goto ext;

    // привязываем к родителю в навигации
    if mngData.AddLink( LNK_NAVIGATION, parent, section_id, ifthen(user_id <> -1, user_id, CORE.User.id) ) = 0 then goto ext;

    if not SetCustomSQL( section_id, tag, tablename, condition, colConfig ) then goto ext;

    result := section_id;
ext:
    lCE;
end;

function TDataManager.DeleteWorkDocument(work_version_id: integer): boolean;

label ext;
var
    query: TADOQuery;
    filename : string;
begin

    lC('DeleteWorkDocument');
    result := false;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    /// получаем данные удаляемой версии
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr(work_version_id) );
    if not Assigned(query) then goto ext;

    // удяляем рабочий файл(-ы) и папку версии
    filename := mngData.GetVersionPath( work_version_id, true );
    if filename = '' then goto ext;

    DeleteFile( filename );
    RemoveDir( ExtractFilePath( filename ));

    // удаляем файл из хранилища
    if not RemoveFileFromStorage( query.FieldByName('GUID').AsString ) then goto ext;


    // удаляем объект рабочей версии из базы (без занесения в истрию)
    dmEQ( ' DELETE FROM ' + TBL_PROJECT + ' WHERE id = ' + IntToStr(work_version_id) );

    /// если в таблице допданных нет ссылки на документ в согласованной структуре
    if query.FieldByName('doc_id').IsNull
    then
        // удаляем запись из расширенной таблицы свойств документа
        dmEQ( ' DELETE FROM ' + TBL_PROJECT_OBJECT_EXTRA + ' WHERE id = ' + query.FieldByName('doc_extra_id').AsString )
    else
        // удаляем ссылку на документ в проекте
        UpdateTable(
            query.FieldByName('doc_extra_id').AsInteger,
            TBL_PROJECT_OBJECT_EXTRA,
            ['project_doc_id', 'project_id'],
            ['*null', '*null']
        );

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
{
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
 }
    // удаляем все непрямые ссылки связки
    if not dmEQ( Format( SQL_DELETE_CROSS_LINKS, [TableName, id] )) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.DeleteDocumentVersion( doc_id: integer ): boolean;
/// для удаления документа из проекта, удаляем объект документа [project_object]
/// поскольку в рамках проекта не требуется сохранять историю.
/// привязанные к нему допданные [project_object_ext] удаляем только в том случае,
/// если в допданных нет ссылки на документ в КД [project_object_ext].[object_id]
label ext;
var
    query : TADOQuery;
begin

    lC('TDataManager.DeleteDocumentVersion');
    result := false;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    // удаляем объект документа из проекта
    if not dmEQ(' DELETE FROM ' + TBL_PROJECT + ' WHERE id = ' + IntToStr( doc_id )) then goto ext;

    // получаем его дополнительные данные
    query := CORE.DM.OpenQueryEx(' SELECT * FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr( doc_id ));
    if not assigned(query) or (query.RecordCount = 0) then goto ext;

    // если нет ссылки на объект в КД
    if   query.FieldByName('object_id').IsNull
    then
        // удаляем допданные документа. они не нужны
        dmEQ(' DELETE FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE id = ' + query.FieldByName('id').AsString )
    else
        // сбрасываем в допданных ссылки на рабосий документ и объект-владелец
        UpdateTable(
            query.FieldByName('id').AsInteger,
            TBL_DOCUMENT_EXTRA,
            ['project_doc_id', 'project_object_id'],
            ['*null', '*null']
        );

    // обновляем у объекта-владелца в проекте признак наличия привязанных файлов
    UpdateHasDocsFlag( query.FieldByName('project_object_id').AsInteger );

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.CommitTrans;

    result := true;
ext:

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.RollbackTrans;

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
           if quoted and (String(arr[i]) <> '')
            then
                result := result + comma + '''' + String(arr[i]) + ''''
            else
                result := result + comma + ifthen(String(arr[i])='', 'null', String(arr[i]));

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
   comma, val: string;
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
            val := VarToStrDef( Values[i], '' );

            if   val <> '' then
            begin

                if val[1] <> '*'
                then result := result + comma + VarToStrDef( Fields[i], '' ) + '=''' + val + ''''
                else result := result + comma + VarToStrDef( Fields[i], '' ) + '=' + Copy(val, 2, length(val));

                comma := ', ';
            end;
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



function TDataManager.CreateWorkgroup(name: string; tag: string = ''): boolean;
// создает в таблице [ROLE_WORKGROUPS] новую рабочую группу.
// если с таким именем уже существует, возвращает ошибку.
begin
    // проверяем существование группы с таким именем
    result := dmSDQ(' SELECT COUNT(id) FROM ' + TBL_ROLES_WORKGROUPS + ' WHERE name = ''' + name + '''', 0) = 0;

    if not result then
    begin
        CORE.DM.DBError := lE('Рабочая группа с именем "' + name + '" уже существует.');
        exit;
    end;

    // все в порядке, можно создавать
    dmEQ(' INSERT INTO ' + TBL_ROLES_WORKGROUPS + ' ( name, tags ) VALUES ('''+ name +'', ''+ifthen(tag='', 'project', tag)+''')');

    result := true;
end;

function TDataManager.UpdateWorkgroup(group_id: integer; name: string ): boolean;
// обновление имени рабочей группы
begin
    result := dmEQ(' UPDATE ' + TBL_ROLES_WORKGROUPS + ' SET name = '''+name+''' WHERE id = ' + IntToStr(group_id));
end;

function TDataManager.DeleleWorkgroup(group_id: integer): boolean;
// удаление рабочей группы и всех связей, завязанных на нее
label
    ext;
var
    user_links: TADOQuery;
begin
    result := false;

    // проверяем на наличие проектов, использующих данную рабочую группу
    if dmSDQ(' SELECT count(parent) FROM '+TBL_PROJECT_EXTRA+' WHERE workgroup_id = '+IntToStr(group_id),0) > 0 then
    begin
        CORE.DM.DBError := 'Рабочая группа ( ID='+IntToStr(group_id)+' ) используется в проектах и не может быть удалена';
        Exit;
    end;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    // удаляем рабочую группу
    if not dmEQ(' DELETE ' + TBL_ROLES_WORKGROUPS + ' WHERE id = ' + IntToStr( group_id )) then goto ext;

    // получаем данные всех пользователей в рабочей группе
    user_links := CORE.DM.OpenQueryEx(' SELECT id FROM ' + LNK_ROLES_EMPL_WORKGROUP + ' WHERE parent = ' + IntToStr( group_id ));

    // для каждого пользователя чистим связи
    if Assigned(user_links) then
    while not user_links.Eof do
    begin
        // удаляем привязку пользователя к рабочей группе
        if not dmEQ(' DELETE FROM ' + LNK_ROLES_EMPL_WORKGROUP + ' WHERE id = ' + user_links.Fields[0].AsString ) then goto ext;

        // удаляем все связи с группами
        if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL + ' WHERE parent = ' + user_links.Fields[0].AsString ) then goto ext;

        // удаляем все связи роли с персональными ролями
        if not dmEQ(' DELETE FROM ' + LNK_ROLES_GROUP_WORKGROUP + ' WHERE parent = ' + user_links.Fields[0].AsString ) then goto ext;

        user_links.Next;
    end;

    result := true;

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.CommitTrans;

ext:

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.RollbackTrans;
end;

function TDataManager.CreateRole(name, value: string): boolean;
// создает в таблице [ROLE_RIGHTS] новую рабочую группу.
// если с таким именем уже существует, возвращает ошибку.
begin
    // проверяем существование группы с таким именем
    result := dmSDQ(' SELECT COUNT(id) FROM ' + TBL_ROLES_RIGHTS + ' WHERE name = ''' + name + '''', 0) = 0;

    if not result then
    begin
        CORE.DM.DBError := lE('Роль с именем "' + name + '" уже существует.');
        exit;
    end;

    // все в порядке, можно создавать
    dmEQ(' INSERT INTO ' + TBL_ROLES_RIGHTS + ' ( name, value ) VALUES ('''+ name +''', '''+ value +''')');

    result := true;
end;

function TDataManager.UpdateRole(id: integer; name, value: string): boolean;
// обновляет данные указанной роли
begin
    result := dmEQ(' UPDATE ' + TBL_ROLES_RIGHTS + ' SET name = '''+ name +''', value = '''+value+''' WHERE id = ' + IntToStr(id) );
end;

function TDataManager.DeleteRole(role_id: integer): boolean;
// удаляет указанную роль, чистит все ссылки на нее
label
    ext;
begin
    result := false;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    // удаляем роль
    if not dmEQ(' DELETE FROM ' + TBL_ROLES_RIGHTS + ' WHERE id = ' + IntToStr( role_id )) then goto ext;

    // удаляем все связи ролей на группу
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_GROUP + ' WHERE child = ' + IntToStr( role_id )) then goto ext;

    // удаляем все связи роли с персональными ролями
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL + ' WHERE child = ' + IntToStr( role_id )) then goto ext;

    result := true;

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.CommitTrans;

ext:

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.RollbackTrans;
end;

function TDataManager.CreateGroup(name: string): boolean;
// создает в таблице [ROLE_GROUPS] новую рабочую группу.
// если с таким именем уже существует, возвращает ошибку.
begin
    // проверяем существование группы с таким именем
    result := dmSDQ(' SELECT COUNT(id) FROM ' + TBL_ROLES_GROUPS + ' WHERE name = ''' + name + '''', 0) = 0;

    if not result then
    begin
        CORE.DM.DBError := lE('Группа ролей с именем "' + name + '" уже существует.');
        exit;
    end;

    // все в порядке, можно создавать
    dmEQ(' INSERT INTO ' + TBL_ROLES_GROUPS + ' ( name ) VALUES ('''+ name +''')');

    result := true;
end;

function TDataManager.CreateIspoln(project_id, parent: integer; mark, name: string): integer;
/// создание исполнения для указанной спецификации с автоматическим
/// получением номера и привязкой
///    parent - спецификация, для которой нужно создать исполнение
///    mark, name - соответствующие атрибуты спецификации
var
    next_number : integer;
begin

    result := 0;

    /// получаем номер следующего исполнения и спарашиваем у пользователя разрешения создать исполнение
    next_number := GetNextIspolNumber( parent );

    /// создаем исполнение
    result :=
        CreateProjectObject(
            mark, ifthen( next_number = 0, '', IntToStr(next_number)), '', name, '', '', KIND_ASSEMBL, 0, KIND_ISPOLN, project_id );

    if result = 0 then exit;

    /// привязка к спецификации
    CreateCrossLinks(
        LNK_PROJECT_STRUCTURE,
        AddLink( LNK_PROJECT_STRUCTURE, parent, result )
    );

end;

function TDataManager.CopyIspoln(project_id, parent, child: integer; mark, name: string): integer;
/// создание исполнения для указанной спецификации с автоматическим
/// получением номера и привязкой. к новой спецификации привязываются все
/// позиции исходной
///    parent - спецификация, для которой нужно создать исполнение
///    child - исполнение-образец
///    mark, name - соответствующие атрибуты спецификации
var
    dsChilds: TDataset;
begin

    /// создаем исполнение
    result := CreateIspoln( project_id, parent, mark, name );

    if result = 0 then exit;

    /// получаем всех непосредственных потомков
    dsChilds := CORE.DM.OpenQueryEx(' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent = ' + IntToStr(child) );
    if not Assigned( dsChilds ) then exit;

    /// привязываем их к новому исполнению
    while not dsChilds.eof do
    begin
        CreateCrossLinks(
            LNK_PROJECT_STRUCTURE,
            AddLink( LNK_PROJECT_STRUCTURE, result, dsChilds.FieldByName('child').AsInteger )
        );
        dsChilds.Next;
    end;

end;


function TDataManager.UpdateGroup(group_id: integer; name: string): boolean;
// обновление имени группы прав
begin
    result := dmEQ(' UPDATE ' + TBL_ROLES_GROUPS + ' SET name = '''+ name +''' WHERE id = ' + IntToStr( group_id ));
end;

function TDataManager.DeleleGroup(group_id: integer): boolean;
// удаление группы прав. чистка связей ролей, указывающих на эту группу
label
    ext;
begin

    result := false;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    // удаляем группу
    if not dmEQ(' DELETE FROM ' + TBL_ROLES_GROUPS + ' WHERE id = ' + IntToStr( group_id )) then goto ext;

    // удаляем все связи ролей на группу
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_GROUP + ' WHERE parent = ' + IntToStr( group_id )) then goto ext;

    // удаляем все связи группы с рабочими группами
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_GROUP_WORKGROUP + ' WHERE child = ' + IntToStr( group_id )) then goto ext;

    result := true;

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.CommitTrans;

ext:

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.RollbackTrans;

end;

function TDataManager.GetWorkgroupName(workgroup_id: integer): string;
begin
    result := dmSDQ('SELECT name FROM '+TBL_ROLES_WORKGROUPS+' WHERE id = '+IntToStr(workgroup_id), 'Не найдена');
end;

function TDataManager.GetWorkgroupsList( dataset: TDataset; tag : string ): TDataset;
// получаем список всех существующих рабочих групп
var
    addon : string;
begin
    if Trim(tag) <> ''
    then addon := ' WHERE tags like '''+tag+''''
    else addon := '';

    if not Assigned( dataset )
    then result := CORE.DM.OpenQueryEx('SELECT id, name FROM ' + TBL_ROLES_WORKGROUPS + addon)
    else result := CORE.DM.OpenQueryEx('SELECT id, name FROM ' + TBL_ROLES_WORKGROUPS + addon, dataSet);
end;

function TDataManager.GetWorkgroupUserList(workgroup_id: integer;
  dataset: TDataset): TDataset;
// получаем список всех прользователей, привязанных к указанной рабочей группе
begin
    if not Assigned( dataset ) then exit;

    result :=
        CORE.DM.OpenQueryEx(
            ' SELECT  FORMAT(ew.todate, ''d'', ''de-de'') AS todate, ew.child as id, e.name FROM ' + LNK_ROLES_EMPL_WORKGROUP + ' as ew ' +
            ' left join ' + TBL_EMPLOYEES + ' e ON e.id = ew.child ' +
            ' WHERE ew.parent = ' + IntToStr(workgroup_id)

            , dataSet);
end;

function TDataManager.GetWorkgroupUserGroupsList(workgroup_id, user_id: integer;
  dataset: TDataset): TDataset;
// получение списка всех групп прав, привязанных к пользоватею в рамках рабочей группы
begin
    if not Assigned( dataset ) then exit;

    result :=
        CORE.DM.OpenQueryEx(
            ' SELECT g.id, g.name, FORMAT(gw.todate, ''d'', ''de-de'') AS todate FROM ' + TBL_ROLES_GROUPS + ' as g ' +
            ' left join ' + LNK_ROLES_GROUP_WORKGROUP + ' gw ON gw.child = g.id ' +
            ' left join ' + LNK_ROLES_EMPL_WORKGROUP + ' ew ON ew.id = gw.parent ' +
            ' WHERE ew.parent = ' + IntToStr(workgroup_id) +
            ' AND ew.child = ' + IntToStr(user_id)
            , dataSet
        );
end;

function TDataManager.GetWorkgroupUserRolesList(workgroup_id,
  user_id, group_id: integer; dataset: TDataset): TDataset;
// получение списка прав прользователя в рамках указанной группы прав
begin
    result :=
        CORE.DM.OpenQueryEx(
            ' SELECT r.id, r.name, g.name as group_name FROM ' + TBL_ROLES_RIGHTS + ' AS r' +
            ' left join ' + LNK_ROLES_RIGHT_GROUP + ' rg ON rg.child = r.id ' +
            ' left join ' + LNK_ROLES_GROUP_WORKGROUP + ' gw ON gw.child = rg.parent ' +
            ' left join ' + LNK_ROLES_EMPL_WORKGROUP + ' ew ON ew.id = gw.parent ' +
            ' left join ' + TBL_ROLES_GROUPS + ' g ON g.id = gw.child ' +
            ' WHERE ew.parent = ' + IntToStr(workgroup_id) +
            ' AND ew.child = ' + IntToStr(user_id) +
            ' AND rg.parent = ' + IntToStr(group_id)
            ,dataset
        );
end;

function TDataManager.GetWorkgroupUserRolesFullList(workgroup_id,
  user_id: integer; dataset: TDataset): TDataset;
/// данный метод возвращает список всех прав из всех назначенных пользователю групп.
/// применяется в механизме проверки прав в программе перед каждым действием, потому
/// его работа защищена от частых обращений к базе.
begin

    result :=
        CORE.DM.OpenQueryEx(
            ' SELECT r.id, r.name, g.name as group_name FROM ' + TBL_ROLES_RIGHTS + ' AS r' +
            ' left join ' + LNK_ROLES_RIGHT_GROUP + ' rg ON rg.child = r.id ' +
            ' left join ' + LNK_ROLES_GROUP_WORKGROUP + ' gw ON gw.child = rg.parent ' +
            ' left join ' + LNK_ROLES_EMPL_WORKGROUP + ' ew ON ew.id = gw.parent ' +
            ' left join ' + TBL_ROLES_GROUPS + ' g ON g.id = gw.child ' +
            ' WHERE ew.parent = ' + IntToStr(workgroup_id) +
            ' AND ew.child = ' + IntToStr(user_id)
            ,dataset
        );

end;

function TDataManager.GetWorkgroupUserPersonalRolesList(workgroup_id, user_id: integer;
  dataset: TDataset): TDataset;
// получение полного списка всех персональных прав пользователя в рамках рабочей группы
begin
    result :=
        CORE.DM.OpenQueryEx(
            ' SELECT r.id, r.name, FORMAT(re.todate, ''d'', ''de-de'') AS todate, isnull( re.value, r.value) as value FROM ' + TBL_ROLES_RIGHTS + ' AS r' +
            ' left join ' + LNK_ROLES_RIGHT_EMPL + ' re ON re.child = r.id ' +
            ' left join ' + LNK_ROLES_EMPL_WORKGROUP + ' ew ON ew.id = re.parent ' +
            ' WHERE ew.parent = ' + IntToStr(workgroup_id) +
            ' AND ew.child = ' + IntToStr( user_id )
            ,dataset
        );
end;

function TDataManager.GetGroupRolesList(group_id: integer;
  dataset: TDataset): TDataset;
// получаем список ролей, привязанных к указанной группе прав
begin
    if not Assigned( dataset ) then exit;

    result :=
        CORE.DM.OpenQueryEx(
            ' SELECT rg.value, rg.id, rr.name FROM ' + LNK_ROLES_RIGHT_GROUP + ' as rg ' +
            ' left join ' + TBL_ROLES_RIGHTS + ' rr ON rr.id = rg.child ' +
            ' WHERE rg.parent = ' + IntToStr(group_id)
            , dataSet
        );
end;

function TDataManager.GetGroupsList(dataset: TDataset): TDataset;
// получаем список всех существующих групп прав
begin
    if not Assigned( dataset ) then exit;

    result := CORE.DM.OpenQueryEx('SELECT id, name FROM ' + TBL_ROLES_GROUPS, dataSet);
end;

function TDataManager.GetGroupsList(dataset: TADOQuery): TADOQuery;
// получаем список всех существующих групп прав
begin
    result := CORE.DM.OpenQueryEx('SELECT id, name FROM ' + TBL_ROLES_GROUPS, dataSet);
end;

function TDataManager.GetRolesList(dataset: TDataset): TDataset;
// получаем список всех существующих прав
begin
    if not Assigned( dataset ) then exit;

    result := CORE.DM.OpenQueryEx('SELECT id, name, value FROM ' + TBL_ROLES_RIGHTS, dataSet);
end;

function TDataManager.LinkUserToWorkroup(workgroup_id, user_id: integer): integer;
// включение указанного пользователя в указанную рабочую группу
begin
    // проверяем наличие такой связки, чтобы не плодить копий
    result := GetEmplToWorkgroupLink( workgroup_id, user_id );

    // если вернулся ноль, такой связки не существует. создаем
    if result = 0 then
    result := dmIQ( Format(' INSERT INTO %s (parent, child) VALUES (%d, %d) ', [ LNK_ROLES_EMPL_WORKGROUP, workgroup_id, user_id ]));
end;

function TDataManager.UpdateLinkUserToWorkroup(workgroup_id, user_id: integer;
  todate: TDate; dateSelected: boolean): boolean;
/// обновление времени ограничения привязки пользователя к рабочей группе
/// - todate - дата до которой будет актуальна данная привязка
/// - dateSelected - признак того, что переданная дата является актуальной,
///                  иначе необходимо обнулить дату в связке
var
    valDate : string;
begin
    if not dateSelected
    then valDate := 'null'
    else valDate := ''''+DateToStr(todate)+'''';

    result := dmEQ( Format(' UPDATE %s SET todate = %s WHERE child = %d AND parent = %d ',
                           [ LNK_ROLES_EMPL_WORKGROUP, valDate, user_id, workgroup_id ]));
end;

function TDataManager.UpdateLinkUserToGroup(workgroup_id, user_id, group_id: integer;
  todate: TDate; dateSelected: boolean): boolean;
/// обновление времени ограничения привязки пользователя к группе прав в рамках рабочей группы
/// - todate - дата до которой будет актуальна данная привязка
/// - dateSelected - признак того, что переданная дата является актуальной,
///                  иначе необходимо обнулить дату в связке
var
    valDate : string;
begin
    if not dateSelected
    then valDate := 'null'
    else valDate := ''''+DateToStr(todate)+'''';

    result := dmEQ( Format(' UPDATE %s SET todate = %s WHERE child = %d AND parent = %d ',
                           [ LNK_ROLES_GROUP_WORKGROUP, valDate, group_id, GetEmplToWorkgroupLink( workgroup_id, user_id ) ]));
end;

function TDataManager.DeleleLinkUserToWorkgroup(workgroup_id,
  user_id: integer): boolean;
// удаление пользователя из указанной рабочей группы. удаление всех
// ролей и групп, указывающих на этого пользователя в рамках рабочей группы
var
    link_id: integer;
label
    ext;
begin

    result := false;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    /// получаем id связи пользователя с рабочей группой, поскольку на него
    /// ссылаются привязки групп и перваональных ролей
    link_id := GetEmplToWorkgroupLink( workgroup_id, user_id );

    /// грохаем привязку пользователя
    if not dmEQ( Format(' DELETE FROM %s WHERE id = %d ',
                           [ LNK_ROLES_EMPL_WORKGROUP, link_id ])) then goto ext;

    // удаляем все связи с группами
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL + ' WHERE parent = ' + IntToStr(link_id) ) then goto ext;

    // удаляем все связи роли с персональными ролями
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_GROUP_WORKGROUP + ' WHERE parent = ' + IntToStr(link_id) ) then goto ext;

    result := true;

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.CommitTrans;

ext:

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.RollbackTrans;

end;

function TDataManager.LinkWorkgroupUserToGroup(workgroup_id, user_id,
  group_id: integer): boolean;
// привязка группы прав к пользователю в рамках рабочей группы
var
    link_id : integer;
begin
    /// получаем id связки пользователя и рабочей группы
    /// ссылаются привязки групп и перваональных ролей
    link_id := GetEmplToWorkgroupLink( workgroup_id, user_id );

    /// проверяем наличие привязки, чтобы не было дубля
    if dmSDQ(Format(' SELECT id FROM %s WHERE parent = %d AND child = %d ',[LNK_ROLES_GROUP_WORKGROUP, link_id, group_id]), 0) = 0
    then
        /// создаем привязку к группе прав
        result := dmEQ( Format(' INSERT INTO %s (parent, child) VALUES (%d, %d) ', [LNK_ROLES_GROUP_WORKGROUP, link_id, group_id]))
    else
        result := true;
end;

function TDataManager.ObjectIsReady(object_id: integer): boolean;
/// метод сканирует всех потомков на текущий статус и возвращает false,
/// если есть хоть один в статусе в работе или в проверке
begin
    result := dmSDQ(
        ' SELECT count(child) FROM ' + VIEW_PROJECT_STRUCTURE +
        ' WHERE status in ('+IntToStr(STATE_PROJECT_INWORK)+','+IntToStr(STATE_PROJECT_CHECKING)+','+IntToStr(STATE_PROJECT_READONLY)+')' +
        '   AND child in ( SELECT DISTINCT(child) FROM '+LNK_PROJECT_STRUCTURE_CROSS+' WHERE parent = '+IntToStr(object_id)+')'
        , 0
    ) = 0;
end;

function TDataManager.DeleteLinkWorkgroupUserToGroup(workgroup_id, user_id,
  group_id: integer): boolean;
// удаление привязки пользователя к группе прав в рамках рабочей группы
begin
    result := dmEQ(
        ' DELETE FROM ' + LNK_ROLES_GROUP_WORKGROUP +
        ' WHERE parent = ' + IntToStr( GetEmplToWorkgroupLink( workgroup_id, user_id )) +
        ' AND child = ' + IntToStr( group_id) );
end;

function TDataManager.LinkCheckerToObject(object_id, user_id, project_id: integer): integer;
begin
    result := AddLink( LNK_PROJECT_CHECKER, object_id, user_id );

    if result <> 0
    then UpdateTable( result, LNK_PROJECT_CHECKER, ['project_id'], [project_id] );
end;

function TDataManager.GetObjectCheckers(object_id, project_id: integer): TDataset;
/// получаем список всех проверяющих объекта в проекте
begin
    result := CORE.DM.OpenQueryEx(
        ' SELECT e.id, e.name FROM ' + TBL_EMPLOYEES + ' e ' +
        ' left join ' + LNK_PROJECT_CHECKER + ' pe ON pe.child = e.id ' +
        ' WHERE pe.parent = ' + IntToStr(object_id) +
        ' AND pe.project_id = ' + IntToStr(project_id)
    );
end;

function TDataManager.LinkEditorToObject(object_id, user_id, project_id: integer): integer;
begin
    result := AddLink( LNK_PROJECT_EDITOR, object_id, user_id );

    if result <> 0
    then UpdateTable( result, LNK_PROJECT_EDITOR, ['project_id'], [project_id]);
end;

function TDataManager.LinkPersonalRole(workgroup_id, user_id,
  role_id: integer): boolean;
// привязка пользователю первональной роли
var
    link_id : integer;
begin
    // получаем привязку пользовтеля к рабочей группе, поскольку именно на нее ссылается привязка к группе ролей
    link_id := GetEmplToWorkgroupLink( workgroup_id, user_id );

    /// проверяем наличие привязки, чтобы не было дубля
    if dmSDQ(Format(' SELECT id FROM %s WHERE parent = %d AND child = %d ',[LNK_ROLES_RIGHT_EMPL, link_id, role_id]), 0) = 0
    then
        /// создаем привязку к группе прав
        result := dmEQ( Format(' INSERT INTO %s (parent, child) VALUES (%d, %d) ', [LNK_ROLES_RIGHT_EMPL, link_id, role_id]))
    else
        result := true;
end;

function TDataManager.DeleteLinkPersonalRole(workgroup_id, user_id,
  role_id: integer): boolean;
// удаление персональной роли пользователя
begin
    result := dmEQ(
        ' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL +
        ' WHERE parent = ' + IntToStr( GetEmplToWorkgroupLink( workgroup_id, user_id )) +
        ' AND child = ' + IntToStr(role_id));
end;

function TDataManager.UpdateLinkPersonalRole(workgroup_id, user_id,
  role_id: integer; value: string; todate: TDate; dateSelected: boolean): boolean;
// обновление данных персональной роли
/// - todate - дата до которой будет актуальна данная привязка
/// - dateSelected - признак того, что переданная дата является актуальной,
///                  иначе необходимо обнулить дату в связке
var
    valDate : string;
begin
    if not dateSelected
    then valDate := 'null'
    else valDate := ''''+DateToStr(todate)+'''';

    result := dmEQ( Format(' UPDATE %s SET todate = %s, value = ''%s'' WHERE child = %d AND parent = %d ',
                           [ LNK_ROLES_RIGHT_EMPL, valDate, value, role_id, GetEmplToWorkgroupLink( workgroup_id, user_id ) ]));
end;


function TDataManager.LinkRoleToGroup( group_id, role_id: integer; value: string = '' ): boolean;
// включение роли в группу
begin
    // проверяем наличие такой связки, чтобы не плодить копий
    result := dmSDQ(
        Format(' SELECT id FROM %s WHERE parent = %d AND child = %d ',
               [  LNK_ROLES_RIGHT_GROUP,
                  group_id,
                  role_id
               ]
        ), 0
    ) = 0;

    // если вернулся ноль, такой связки не существует
    if result then
    // создаем
    result := dmEQ( Format(' INSERT INTO %s (parent, child, value) VALUES (%d, %d, ''%s'') ',
                 [  LNK_ROLES_RIGHT_GROUP,
                    group_id,
                    role_id,
                    value
                 ]
          )
    )
    else
    result := dmEQ( Format(' UPDATE %s SET value = ''%s'' WHERE parent = %d AND child = %d ',
                 [  LNK_ROLES_RIGHT_GROUP,
                    value,
                    group_id,
                    role_id
                 ]
          )
    );
end;

function TDataManager.LinkToProjectObject(parent, child, project_id: integer): string;
/// привязка указанного объекта проекта к указанному родителк в проекте
/// при привязке проверяется возможность привязки (исходя из типов объектов)
/// ошибка возвращается в виде строки
///    parent, kind, icon, status - параметры родительского объекта
///          используются в проверке возможности привязки потомка
///    child - привязываемый объект
var
    dsParent, dsChild: TDataset;
begin
    dsParent := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE child = ' + IntToStr(parent) );
    dsChild  := CORE.DM.OpenQueryEx(' SELECT * FROM ' + TBL_PROJECT + ' WHERE id = ' + IntToStr(child) );

    // проверка возможности привязки созданного объекта к текущему
    // выбранному элементу в дереве проекта
    result := mngData.CheckLinkAllow(
        dsChild.FieldByName('kind').AsInteger,
        StrToIntDef(dsChild.FieldByName('icon').AsString, 0),
        STATE_PROJECT_READONLY,

        dsParent.FieldByName('kind').AsInteger,
        StrToIntDef(dsParent.FieldByName('icon').AsString, 0),
        dsParent.FieldByName('status').AsInteger
    );

    if result = '' then
    begin

        // исходя из их типов
        // привязываем созданный элемент к выделенному элементу дерева
        mngData.CreateCrossLinks(
            LNK_PROJECT_STRUCTURE,
            mngData.AddLink( LNK_PROJECT_STRUCTURE, parent, child )
        );

        /// после привязки к структуре получаем полные данные по объекту
        dsChild  := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE child = ' + IntToStr(child), dsChild );

        /// устанавливаем объекту привязку к проекту
        mngData.UpdateTable( dsChild.FieldByName('extra_id').AsInteger, TBL_PROJECT_OBJECT_EXTRA, ['project_id'], [project_id]);

//        // обновляем значение mark проекта, если необходимо
//        if parent_id = ProjectID
//        then mngData.UpdateProjectMark( ProjectID );

    end

end;

function TDataManager.UpdateGroupRole(link_id: integer; value: string): boolean;
// обновление значения привязки
begin
    result := dmEQ( Format(' UPDATE %s SET value = ''%s'' WHERE id = %d ', [LNK_ROLES_RIGHT_GROUP, value, link_id]));
end;

function TDataManager.DelLinkRoleToGroup( role_link_id: integer ): boolean;
// исключение роли из группы
begin
    result := dmEQ( Format(' DELETE FROM %s WHERE id = %d ', [  LNK_ROLES_RIGHT_GROUP, role_link_id ] ));
end;

function TDataManager.GetEmplToWorkgroupLink(workgroup_id,
  user_id: integer): integer;
// получение id привязки пользователя к рабочей группе.
// в некоторых функциях по полученному id производится работа с привязкой
// пользователя к группам и персональным правам в рамках рабочей группы
begin
    result := dmSDQ(Format(' SELECT id FROM %s WHERE child = %d AND parent = %d ', [LNK_ROLES_EMPL_WORKGROUP, user_id, workgroup_id]), 0);
end;




function TDataManager.HasRole(role_id, workgroup_id: integer; value: string = ''): boolean;
// обертка для вызова CheckRole
begin
    result := CheckRole( workgroup_id, 'role_id', role_id, value );
end;

function TDataManager.HasRole(role_name: string;
  workgroup_id: integer; value: string = ''): boolean;
// обертка для вызова CheckRole
begin
    result := CheckRole( workgroup_id, 'role_name', role_name, value );
end;

function TDataManager.HasRole(role_id: integer; value: string): boolean;
/// обертка для проверки наличия роли, но в расчете, что права проверяются
/// в рамках базовой группы BASE_WORKGROUP_NAME, содержащей права пользователей
/// на работе в рамках самой PDM
begin
    result := CheckRole( GetBaseWorkgroupId, 'role_id', role_id, value );
end;

function TDataManager.HasRole(role_name, value: string): boolean;
/// обертка для проверки наличия роли, но в расчете, что права проверяются
/// в рамках базовой группы BASE_WORKGROUP_NAME, содержащей права пользователей
/// на работе в рамках самой PDM
begin
    result := CheckRole( GetBaseWorkgroupId, 'role_name', role_name, value );
end;

function TDataManager.CheckRole( workgroup_id: integer; name: string; key: variant; value: string ): boolean;
// проверяет наличие у текущего пользователя указанной роли
// если указано value, результат зависит от совпадения значения с ролью
begin
    /// при необходимости, обновляем список ролей пользователя
    RefreshRolesList();

    // ищем роль по указанному параметру, при этом, персональные роли находятся
    // в начале набора данных, что перекрывает одноименные роли из групп
    LastRightDataset.first;
    result := LastRightDataset.Locate(name+';workgroup_id', VarArrayOf([key, workgroup_id]), []);

    // если роль есть и указано проверочное значение, результат будет зависеть
    // от совпадения значения в базе проверяемому
    if result and (value <> '') then
    result := value = LastRightDataset.FieldByName('value').AsString;
end;

function TDataManager.RoleValue(role_name: string;
  workgroup_id: integer): string;
begin
    result := GetRoleValue( workgroup_id, 'role_name', role_name );
end;

function TDataManager.RoleValue(role_id, workgroup_id: integer): string;
begin
    result := GetRoleValue( workgroup_id, 'role_id', role_id );
end;

function TDataManager.RoleValue(role_name: string): string;
begin
    result := GetRoleValue( GetBaseWorkgroupId, 'role_name', role_name );
end;

function TDataManager.RoleValue(role_id: integer): string;
begin
    result := GetRoleValue( GetBaseWorkgroupId, 'role_id', role_id );
end;

function TDataManager.GetRoleValue( workgroup_id: integer; name: string; key: variant ): string;
// проверяет наличие у текущего пользователя указанной роли
// если указано value, результат зависит от совпадения значения с ролью
begin

    result := '';

    /// при необходимости, обновляем список ролей пользователя
    RefreshRolesList();

    // ищем роль по указанному параметру, при этом, персональные роли находятся
    // в начале набора данных, что перекрывает одноименные роли из групп
    LastRightDataset.first;

    if   LastRightDataset.Locate(name+';workgroup_id', VarArrayOf([key, workgroup_id]), [])
    then result := LastRightDataset.FieldByName('value').AsString;

end;


function TDataManager.GetRootElems(project_id, get_mode: integer): TIntArray;
/// получаем и возвращаем набор объектов из указанного проекта, согласно набору
/// требуемых признаков.
/// используется, чтобы получить набор нескольких корневых объектов для отображения
/// части/частей дерева проекта, а не весь полный
///    project_id - интересующий нас проект
///    get_mode - набор флагов-признаков, по которым формировать набор id
///               константы вида ROOT_MY_XXX
///
var
    ds: TDataset;

    procedure toArray(_id: integer);
    /// добавляем в результатирующий массив id если такого там нет
    var
        i : integer;
    begin

        for I := Low(result) to High(result) do
        if result[i] = _id then exit;

        SetLength(result, Length(result) + 1);
        result[High(result)] := _id;

    end;

    procedure getIds( flag: integer; tablename: string );
    begin
        if (get_mode and flag) <> 0 then
        begin
            ds := CORE.DM.OpenQueryEx(
                Format('SELECT DISTINCT(parent) FROM %s WHERE child = %d AND project_id = %d',
                        [tablename, CORE.User.id, project_id]));
            if assigned(ds) and ds.Active  then
            while not ds.Eof do
            begin
                toArray( ds.FieldByName('parent').AsInteger );
                ds.Next;
            end;
        end;
    end;

begin

    getIDs( ROOT_MY_WORK_OBJECTS, LNK_EDITOR);
    getIDs( ROOT_MY_CHECK_OBJECTS, LNK_CHECKERS);

end;

procedure TDataManager.RefreshRolesList( refresh: boolean = false );
/// метод обновляет данные по имеюшимся у текущего пользователя правам
/// результат хранится в датасете, котрый обновляется спериодичностью в
/// RIGHT_TIME_VALIDE_PERIOD минут
/// датасет используется для опроса программой на доступ к тем или иным возможностям
/// и позволяет избежать нагрузки на базу данных.
/// при выборке, сначала получаются первональные роли пользователя а ниже по
/// выборке - из привязанных рабочих групп. таким образом, персональные роли
/// имеют приоритет, что важно, если требуется перекрыть групповую роль неким
/// особым значением, к тому же, оно может иметь ограниченный строк действия
begin

    // получаем свежие данные, только если истек период актуальности
    // или данные ещ не получались (первая проверка с момента запуска программы)
    if ( MilliSecondsBetween( Now(), LastRightCheck ) > RIGHT_TIME_VALIDE_PERIOD ) or
       ( not Assigned( LastRightDataset ) ) or
       refresh
    then
    begin
        LastRightDataset :=
            CORE.DM.OpenQueryEx(
                ' SELECT role_id, role_name, value, workgroup_id '+ sLineBreak +
                ' FROM ' + VIEW_ROLES_PERSONAL + ' WHERE user_id = ' + IntToStr( CORE.User.id ) + sLineBreak +
                ' UNION ' + sLineBreak +
                ' SELECT role_id, role_name, value, workgroup_id '+ sLineBreak +
                ' FROM ' + VIEW_ROLES_GROUPS + ' WHERE user_id = ' + IntToStr( CORE.User.id )

                ,LastRightDataset
            );

        LastRightCheck := Now();
    end;

end;

function TDataManager.GetBaseWorkgroupId: integer;
/// возврат id базовой рабочей группы, которая содержит настройки прав для
/// работы непосредственно в самой PDM
begin
    if base_workgroup_id <> 0

    /// если id уже определен, возвращаем его
    then result := base_workgroup_id
    else
    begin
        // иначе определяем и запоминаем, чтобы не оращаться к базе в дальнейшем
        base_workgroup_id := dmSDQ(' SELECT id FROM '+TBL_ROLES_WORKGROUPS+' WHERE name = '''+BASE_WORKGROUP_NAME+'''', 0);
        result := base_workgroup_id;
    end;
end;

function TDataManager.UserIsChecker(object_id: integer): boolean;
/// находится ли текущий пользователь среди контролеров указанного объекта
begin
    result :=
        dmSDQ(
            Format(' SELECT count(id) FROM %s WHERE parent = %d AND child = %d ',
                   [LNK_PROJECT_CHECKER, object_id, CORE.User.id]),
            0) > 0;
end;

function TDataManager.UserIsEditor(object_id: integer): boolean;
/// находится ли текущий пользователь среди редакторов указанного объекта
begin
    result :=
        dmSDQ(
            Format(' SELECT count(id) FROM %s WHERE parent = %d AND child = %d ',
                   [LNK_PROJECT_EDITOR, object_id, CORE.User.id]),
            0) > 0;
end;





function TDataManager.GetERP(name: string): string;
/// получение
begin

end;

function TDataManager.AddERPVariation(erp, name_variation: string): boolean;
begin

end;

function TDataManager.GetMaterialRecord(field, value: string): TDataset;
begin
    result := CORE.DM.OpenQueryEx('SELECT * FROM '+ TBL_MAT +' WHERE '+field+' = '''+value+'''');
end;


Initialization
    base_workgroup_id := 0;

end.
