unit uConstants;

interface

const

    PROG_NAME = 'dpm';

    SETTINGS_TABLE_NAME = 'pdm_Settings';

    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=PDM;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'+
        'Workstation ID=AVT_VALUEV;Use Encryption for Data=False;Tag with column collation when possible=False;';

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

    // рабочие таблицы
    TBL_OBJECT         = 'Object';                     // справочник всех объектов
    TBL_FILE           = '[FilesDB].[dbo].[PDMFiles]'; // таблица файлового хранилища
    TBL_DOCUMENT_EXTRA = 'document_extra';             // расширенный набор полей для объектов-файлов(документов)
    TBL_DOCUMENT_TYPE  = 'document_type';              // справочник типов файлов (расширения, описание, иконки)
    TBL_OBJECT_CLASSIFICATOR = 'object_classificator'; // справочник типов объектов


    LNK_STRUCTURE        = 'Structure';           // дерево связей объектов (изделия)
    LNK_NAVIGATION       = 'Navigation';          // дерево навигации
    LNK_DOCUMENT_OBJECT  = 'document_object';     // привязки документов к объектам
    LNK_DOCUMENT_COMPLEX = 'document_complex';    // привязки вложенных документов к основным. например, картинок, вложенных в чертеж
    LNK_DOCUMENT_VERSION = 'document_version';    // дерево версий документов. какая из какой была создана
    LNK_DOCUMENT_INWORK  = 'document_inwork';     // привязки рабочих документов к их исходным версиям

    VIEW_GROUP    = 'vGroup';                     // вьюшка с данными для дерева навигации
    VIEW_OBJECT   = 'vObject';                    // вьюшка с данными для дерева изделий (связи, базовые данные карточки)
    VIEW_DOCUMENT = 'vDocument1';                 // вьюшка со всеми данными документов (объектов типа документ)
    VIEW_INWORK   = 'vDocInWork';                 // вьюшка со всеми рабочими версиями документов

    // наименования
    SECTION_DOCUMENT_INWORK = 'Документы в работе';

implementation

end.
