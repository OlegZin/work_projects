unit uConstants;

interface

const

    PROG_NAME = 'dpmConfig';

    SETTINGS_TABLE_NAME = 'pdm_Settings';

    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=nft;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'+
        'Workstation ID=AVT_VALUEV;Use Encryption for Data=False;Tag with column collation when possible=False;';

    LOG_FILEPATH = '\\fileserver\Общая папка\ОА\! Внутренняя ОА\_Проекты разработчиков\SourceCode\Зиновьев О\DPM Neftrmash\Compiled\Logs\';

    ICON_FILEPATH = '\\fileserver\Общая папка\ОА\! Внутренняя ОА\_Проекты разработчиков\SourceCode\Зиновьев О\DPM Neftrmash\Compiled\PDM Starter\icons\';
    DEFAULT_PROG_ICON = 'prog_default.jpg';

    VERSION_PERSONAL_ICON = 'icon_personal.png';
    VERSION_WORK_ICON     = 'icon_work.png';
    VERSION_TEST_ICON     = 'icon_test.png';

implementation

end.
