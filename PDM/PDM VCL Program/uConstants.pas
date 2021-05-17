unit uConstants;

interface

const

    PROG_NAME = 'dpm';

    SETTINGS_TABLE_NAME = 'pdm_Settings';

    /// подключение к основной базе
    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Password=5C5b1YH(33%n;Persist Security Info=True;Application Name=PDM;User ID=userPDM;Data Source=server-htm.ntm.grouphms.local;Initial Catalog=pdm;';
    /// подключение к вспомогательной базе
//    CONNECTION_STRING2 =
//        'Provider=SQLOLEDB.1;Password=5C5b1YH(33%n;Persist Security Info=True;Application Name=PDM;User ID=userPDM;Data Source=server-htm.ntm.grouphms.local;Initial Catalog=FilesDB;';

    /// подключение к вспомогательной базе
{    CONNECTION_STRING2 =
        'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=FilesDB;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'+
        'Workstation ID=AVT_VALUEV;Use Encryption for Data=False;Tag with column collation when possible=False;';
}

    LOG_FILEPATH = '\\fileserver\Общая папка\ОА\! Внутренняя ОА\_Проекты разработчиков\SourceCode\Зиновьев О\DPM Neftrmash\Compiled\Logs\';
    // папка для выгрузки архивов логов при возниконвении критических ошибок.

    DIR_BASE_WORK = 'c:\im\imwork\pdm\';
    // корневой рабочий путь, все остальные рабочие папки внутри него

    DIR_PREVIEW = DIR_BASE_WORK + 'preview\';
    // полный путь до картинок предпросмотров файлов. изначально отсутсвуют, но
    // если пользователь нажмет кнопку Просмотр в списке файлов, оригинал будет выгружен
    // в темповую папку и из него сделан слепок предпросмотра, который будет помещен
    // в данную папку

    DIR_TEMP = DIR_BASE_WORK + 'temp\';
    // полный путь до хранилища временных файлов. при запуске программы папка пересоздается,
    // если существует, очищая все, что было накидано сюда прошлой сессией. так же она удаляется при
    // выходе из программы

    DIR_DOCUMENT = DIR_BASE_WORK + 'document\';
    // корневая папка для взятых в работу документов и новых версий
    // при взятии файла в работу, создаются подпапки: ...[document]\[имя файла]\[номер версии]

    DIR_TEMPLATE = '\\server-htm\bdnft$\templates\pdm\templates\';
    DIR_IMAGE = '\\server-htm\bdnft$\templates\pdm\images\';
    DIR_SHARED = '\\server-htm\bdnft$\templates\pdm\shared\';

    FILE_NAME_PROGRAMM_HELP = 'programm_help.docx';
    FILE_NAME_VERSION_CHANGE = 'version.docx';

    IMAGE_PREVWIEW_SIZE = 400;

    RIGHT_TIME_VALIDE_PERIOD = 600 * 1000;  // 10 минут
    /// время в секундах, когда следует доверять данным о правах пользователя
    /// полученных из базы. будет использван имеющийся набор данных, без запроса к базе
    RIGHT_TIME_INTERFASE_UPDATE_PERIOD = 10 * 1000; // 10 секунд
    /// время в секундах, когда следует доверять данным о правах пользователя

    BASE_WORKGROUP_NAME = 'PDM';
    /// имя базовой рабочей группы, которая применяется для настройки прав в самой PDM,
    /// и не используется в проектах. по этиому имени выбирается id группы для
    /// вызова проверки прав без указания рабочей группы

    ROLE_GROUP_EDITOR = 3;
    ROLE_GROUP_CHECKER = 2;
    /// ID ключевых групп ролей, котрые нельзя удалять
    /// константы применяются для привязки пользователя к соответствующей группе
    /// при назначении пользователя редактором или проверяющим объекту проекта


    // рабочие таблицы
    TBL_OBJECT               = 'Object';               // справочник всех объектов
    TBL_FILE                 = '[FilesDB].[dbo].[PDMFiles]'; // таблица файлового хранилища
    TBL_DOCUMENT_EXTRA       = 'document_extra';       // расширенный набор полей для объектов-файлов(документов) в КД
    TBL_DOCUMENT_TYPE        = 'document_type';        // справочник типов файлов (расширения, описание, иконки)
    TBL_OBJECT_CLASSIFICATOR = 'object_classificator'; // справочник типов объектов
    TBL_SECTION_EXTRA        = 'section_extra';        // дополнительные поля разделов (kind = 1)
    TBL_PROJECT              = 'project_object';       // справочник объектов, находящихся в работе (в проектах)
                                                       // здесь содержатяся копии уже существовавших в TBL_OBJECT и
                                                       // созданных в рамках проекта
    TBL_PROJECT_STRUCTURE    = 'project_structure';    // структуры проектов
    TBL_PROJECT_EXTRA        = 'project_extra';        // дополнительные данные объекта-проекта
    TBL_PROJECT_OBJECT_EXTRA = 'project_object_extra'; // дополнительные данные объектов в проекте
    TBL_CUSTOM_SQL           = 'custom_sql';           // справочник с кастомными выборками для объектов
    TBL_MARK_TU              = 'pdm_MARK_BY_TU';       // справочник обозначений по ТУ

    TBL_EMPLOYEES            = '[nft].[dbo].[EMPLOYEES]'; // справочник сотрудников
    TBL_LOGINS               = '[nft].[sec].[objects]';   // справочник логинов

    TBL_MAT                  = '[nft].[dbo].[mat]';    // справочник материалов

    TBL_ROLES_WORKGROUPS     = 'ROLES_WORKGROUP';      // все существующие рабочие группы
    TBL_ROLES_GROUPS         = 'ROLES_GROUPS';         // все существующие группы прав
    TBL_ROLES_RIGHTS         = 'ROLES_RIGHTS';         // все существующие права
    LNK_ROLES_EMPL_WORKGROUP = 'roles_empl_workgroup_link'; // привязка пользователей к рабочей группе
    LNK_ROLES_RIGHT_GROUP    = 'roles_right_group_link';  // привязка ролей к группам
    LNK_ROLES_GROUP_WORKGROUP = 'roles_group_workgroup_link';  // привязка групп к рабочим группам
    LNK_ROLES_RIGHT_EMPL     = 'roles_right_empl_link'; // персональные роли в рамках рабочей группы

    LNK_STRUCTURE         = 'Structure';           // дерево связей объектов (изделия)
    LNK_STRUCTURE_CROSS   = 'Structure_cross';
    LNK_NAVIGATION        = 'Navigation';          // дерево навигации
    LNK_DOCUMENT_OBJECT   = 'document_object';     // привязки документов к объектам КД
    LNK_DOCUMENT_PROJECT_OBJECT =
                            'document_project_object'; // привязки документов к объектам проектов
    LNK_DOCUMENT_COMPLEX  = 'document_complex';    // привязки вложенных документов к основным. например, картинок, вложенных в чертеж
    LNK_DOCUMENT_VERSION  = 'document_version';    // дерево версий документов. какая из какой была создана
    LNK_DOCUMENT_INWORK   = 'document_inwork';     // привязки рабочих документов к их исходным версиям
    LNK_SECTION_EXTRA     = 'section_link';        // привязка расширенных полей к объекту-разделу
    LNK_PROJECT_STRUCTURE = 'project_structure';   // дерево проектов
    LNK_PROJECT_STRUCTURE_CROSS = 'project_structure_cross';
    LNK_PROJECT_EXTRA     = 'project_extra_link';  // привязка допданных проекта
    LNK_PROJECT_OBJECT_EXTRA = 'project_object_extra_link';
                                                   // привязка объектов проекта к дополнительным данным
    LNK_PROJECT_EDITOR = 'project_editor_link';    // ссылка на редактора объекта
    LNK_PROJECT_CHECKER = 'project_checker_link';  // ссылка на проверяющего объекта

    LNK_EDITOR               = 'project_editor_link';
    LNK_CHECKERS             = 'project_checker_link';

    VIEW_GROUP             = 'vGroup';             // вьюшка с данными для дерева навигации
    VIEW_OBJECT            = 'vObject';            // вьюшка с данными для дерева изделий (связи, базовые данные карточки)
    VIEW_DOCUMENT_KD       = 'vDocumentKD';        // вьюшка со всеми данными документов (объектов типа документ)
    VIEW_DOCUMENT_PROJECT  = 'vDocumentProject';   // вьюшка со всеми данными документов (объектов типа документ)
    VIEW_PROJECT           = 'vProject';           // список существующих проектов
    VIEW_PROJECT_STRUCTURE = 'vProjectStructure1'; // таблица деревьев проектов
    VIEW_ROLES_PERSONAL    = 'vRolesPersonal';     // персональные роли пользователей
    VIEW_ROLES_GROUPS      = 'vRolesGroups';       // роли пользователей из привязанных групп

    VIEW_TYPE_PROD           = '[nft].[dbo].[vTypeProd]';
    // справочник структуры типов продукции. проекты привязывавются к ним для классификации
    // служит основой построения части стуктуры рабочего стола


    // наименования
    SECTION_DOCUMENT_INWORK  = 'Документы в работе';
    SECTION_DOCUMENT_MY      = 'Мои документы';
    SECTION_DOCUMENT_OTHER   = 'Прочие документы';
    SECTION_PROJECT_ALL      = 'Проекты';
    SECTION_PROJECT_INWORK   = 'В работе';
    SECTION_PROJECT_MY       = 'Мои проекты';
    SECTION_PROJECT_OTHER    = 'Прочие';
    SECTION_PROJECT_FAVORITE = 'Подписка';
    SECTION_PROJECT_ARCHIVE  = 'Архив';
    SECTION_EVENTS           = 'События';
    SECTION_MESSAGES         = 'Сообщения';
    SECTION_FAVORITE         = 'Избранное';
    SECTION_DOCUMENTS        = 'Документы';

    SECTION_SPECIF = 'Спецификации';
    SECTION_ASSEMBLY = 'Сборочные единицы';

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
    KIND_SELECTION= 13;
    KIND_ARCHIVE  = 14;    // признак архивного проекта
    KIND_PROJECT  = 100;

    // тэги в строках условий для разделов дерева рабочего стола
    // условия подгружаются из базы и могут содержать эти тэги
    // которые нужно замещать актуальными данными перед выполнением запроса
    TAG_USER_ID = '#USER_ID#';

    TAG_VALUE = '#VALUE#';

    // признаки условий выборки для объектов-разделов
    // к каждому разделу привязывается несколько записей условий: тэг, таблица, условие запроса
    // позволяющих выдавать уникальные данные для каждого раздела.
    // несколько запросов обусловлены тем, что при переходе на папку нужно будет получить
    // данные для нескольких потребителей (таблиц или форм), например для таблицы объектов
    // и таблицы документов, привязанных к этим объектам. если данные запросы по указанному
    // тэгу отсутствуют, выборка поизводится методом по-умолчанию
    TAG_SELECT_OBJECTS = 'objects';
    TAG_SELECT_DOCUMENTS = 'documents';


    /// имена программ-обработчиков файлов
    /// совпадают с именами в []
    WORK_PROG_KOMPAS = 'Компас';
    WORK_PROG_WORD   = 'Word';
    WORK_PROG_EXCEL  = 'Excel';


    LAYER_PRODUCTION_OBJECT  = '0';
    LAYER_PRODUCTION_SUBJECT = '1';
    LAYER_PROGRAM_SUPPORT    = '2';

    // статус проекта
    PROJECT_INWORK = 0;    // в работе
    PROJECT_ZREEZE = -1;   // заморожен и не доступен для редактирования
    PROJECT_DONE   = -2;   // проект завершен и является архивным. может быть только удален

    // статус объекта в проекта
    PROJECT_OBJECT_VIEW     = 0;  // "просмотр" не редактируется но доступен для назначения редактора,
    PROJECT_OBJECT_INWORK   = 1;  // "в работе" редактор назначен,
    PROJECT_OBJECT_CHECKING = 2;  // "готов" ждет согласования редактор закончил работу,
    PROJECT_OBJECT_WAIT     = 3;  // "в ожидании", редактор данного объекта закончил
                                  // работу, но есть вложенные объекты в состоянии "в работе" или "в ожидании"
    PROJECT_OBJECT_DONE     = 4;  // согласован, проверяющий утвердил, больше нельзя брать в работу, кроме особых случаев
    PROJECT_OBJECT_READONLY = -1; // не доступен для редактирования. устанавливается
                                  // для копий существующих в КД(согласованной структуре) объектов.
    PROJECT_OBJECT_NOSTATUS = -999; // статус не установлен, используется для передачи в функцию проверки
                                  // CheckLinkAllow, когда у источника данных нет поля статуса



    ////////////////////////////////////////////////////////////////////////////
    ///    КОНФИГУРАЦИЯ ТАБЛИЦЫ ДАННЫХ
    ////////////////////////////////////////////////////////////////////////////
    COL_CONFIG_DEF = 'default';
    COL_CONFIG_PROJECT = 'project'; // в разделе содержатся проекты


    ////////////////////////////////////////////////////////////////////////////
    ///    РОЛИ ПОЛЬЗОВАТЕЛЕЙ
    ////////////////////////////////////////////////////////////////////////////
    ROLE_ROLES_CONFIGURE      = 31;
    ROLE_WORKGROUPS_CONFIGURE = 32;

    ROLE_CREATE_PROJECT       = 33;
    ROLE_DONE_PROJECT         = 25;
    ROLE_FREEZE_PROJECT       = 26;
    ROLE_UNFREEZE_PROJECT     = 27;
    ROLE_DELETE_PROJECT       = 28;

    ROLE_OBJECT_TO_WORK_PERSONALY = 17; // взятие в работу лично
    ROLE_OBJECT_TO_WORK_ASSIGMENT = 18; // взятие в работу назначением исполнителя
    ROLE_OBJECT_FROM_WORK         = 19; // из статуса в работе в статус не назначено (просмотр)
    ROLE_OBJECT_TO_CHECK          = 20; // в статус проверки
    ROLE_OBJECT_FROM_CHECK        = 21; // возврат из проверки в предыдущий статус
    ROLE_OBJECT_TO_READY_PERSONALY = 45;// в статус готово c самоназначением редактором
    ROLE_OBJECT_TO_READY          = 22; // в статус готово
    ROLE_OBJECT_FROM_READY        = 23; // возврат из готово в статус проверкм

    ROLE_ADD_OBJECT = 34;               // создание нового объекта в рамках проекта
    ROLE_EDIT_OBJECT = 35;              // редактирование карточки объекта
    ROLE_LOAD_SPECIFICATION = 15;       // импорт спецификации в проект

    ROLE_LINK_TO_STRUCTURE = 36;        // привязка объектов к структуре проекта
    ROLE_UNLINK_FROM_STRUCTURE = 37;    // удаление объектов из структуры проекта

    ROLE_ASSIGN_EDITOR = 38;            // назначение/замена редактора из спраовочника пользователей
    ROLE_DELETE_EDITOR = 39;            // удаление редактора с объекта в проекте
    ROLE_ASSIGN_CHECKER = 40;           // назначение контролера из справочника пользователей
    ROLE_DELETE_CHECKER = 41;           // удаление редактра с объекта в проекте

    ROLE_TAKE_DOC_IN_WORK = 42;         // взятие объекта в работу
    ROLE_SET_DOC_AS_MAIN = 43;          // установка признака документа как основного

    ROLE_SET_CURRENT_USER = 46;         // смена текущего пользователя в прогграмме

implementation

end.
