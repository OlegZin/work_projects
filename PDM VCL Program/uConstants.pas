unit uConstants;

interface

const

    PROG_NAME = 'dpm';

    SETTINGS_TABLE_NAME = 'pdm_Settings';

    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=PDM;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'+
        'Workstation ID=AVT_VALUEV;Use Encryption for Data=False;Tag with column collation when possible=False;';

    LOG_FILEPATH = '\\fileserver\����� �����\��\! ���������� ��\_������� �������������\SourceCode\�������� �\DPM Neftrmash\Compiled\Logs\';
    // ����� ��� �������� ������� ����� ��� ������������� ����������� ������.

    DIR_BASE_WORK = 'c:\im\imwork\pdm\';
    // �������� ������� ����, ��� ��������� ������� ����� ������ ����

    DIR_PREVIEW = DIR_BASE_WORK + 'preview\';
    // ������ ���� �� �������� �������������� ������. ���������� ����������, ��
    // ���� ������������ ������ ������ �������� � ������ ������, �������� ����� ��������
    // � �������� ����� � �� ���� ������ ������ �������������, ������� ����� �������
    // � ������ �����

    DIR_TEMP = DIR_BASE_WORK + 'temp\';
    // ������ ���� �� ��������� ��������� ������. ��� ������� ��������� ����� �������������,
    // ���� ����������, ������ ���, ��� ���� �������� ���� ������� �������. ��� �� ��� ��������� ���
    // ������ �� ���������

    DIR_DOCUMENT = DIR_BASE_WORK + 'document\';
    // �������� ����� ��� ������ � ������ ���������� � ����� ������
    // ��� ������ ����� � ������, ��������� ��������: ...[document]\[��� �����]\[����� ������]

    // ������� �������
    TBL_OBJECT         = 'Object';                     // ���������� ���� ��������
    TBL_FILE           = '[FilesDB].[dbo].[PDMFiles]'; // ������� ��������� ���������
    TBL_DOCUMENT_EXTRA = 'document_extra';             // ����������� ����� ����� ��� ��������-������(����������)
    TBL_DOCUMENT_TYPE  = 'document_type';              // ���������� ����� ������ (����������, ��������, ������)
    TBL_OBJECT_CLASSIFICATOR = 'object_classificator'; // ���������� ����� ��������


    LNK_STRUCTURE        = 'Structure';           // ������ ������ �������� (�������)
    LNK_NAVIGATION       = 'Navigation';          // ������ ���������
    LNK_DOCUMENT_OBJECT  = 'document_object';     // �������� ���������� � ��������
    LNK_DOCUMENT_COMPLEX = 'document_complex';    // �������� ��������� ���������� � ��������. ��������, ��������, ��������� � ������
    LNK_DOCUMENT_VERSION = 'document_version';    // ������ ������ ����������. ����� �� ����� ���� �������
    LNK_DOCUMENT_INWORK  = 'document_inwork';     // �������� ������� ���������� � �� �������� �������

    VIEW_GROUP    = 'vGroup';                     // ������ � ������� ��� ������ ���������
    VIEW_OBJECT   = 'vObject';                    // ������ � ������� ��� ������ ������� (�����, ������� ������ ��������)
    VIEW_DOCUMENT = 'vDocument1';                 // ������ �� ����� ������� ���������� (�������� ���� ��������)
    VIEW_INWORK   = 'vDocInWork';                 // ������ �� ����� �������� �������� ����������

    // ������������
    SECTION_DOCUMENT_INWORK = '��������� � ������';

implementation

end.
