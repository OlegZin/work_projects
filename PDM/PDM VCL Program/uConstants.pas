unit uConstants;

interface

const

    PROG_NAME = 'dpm';

    SETTINGS_TABLE_NAME = 'pdm_Settings';

    /// ����������� � �������� ����
    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Password=5C5b1YH(33%n;Persist Security Info=True;Application Name=PDM;User ID=userPDM;Data Source=server-htm.ntm.grouphms.local;Initial Catalog=pdm;';
    /// ����������� � ��������������� ����
//    CONNECTION_STRING2 =
//        'Provider=SQLOLEDB.1;Password=5C5b1YH(33%n;Persist Security Info=True;Application Name=PDM;User ID=userPDM;Data Source=server-htm.ntm.grouphms.local;Initial Catalog=FilesDB;';

    /// ����������� � ��������������� ����
{    CONNECTION_STRING2 =
        'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=FilesDB;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'+
        'Workstation ID=AVT_VALUEV;Use Encryption for Data=False;Tag with column collation when possible=False;';
}

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

    DIR_TEMPLATE = '\\server-htm\bdnft$\templates\pdm\templates\';
    DIR_IMAGE = '\\server-htm\bdnft$\templates\pdm\images\';
    DIR_SHARED = '\\server-htm\bdnft$\templates\pdm\shared\';

    FILE_NAME_PROGRAMM_HELP = 'programm_help.docx';
    FILE_NAME_VERSION_CHANGE = 'version.docx';

    IMAGE_PREVWIEW_SIZE = 400;

    RIGHT_TIME_VALIDE_PERIOD = 600 * 1000;  // 10 �����
    /// ����� � ��������, ����� ������� �������� ������ � ������ ������������
    /// ���������� �� ����. ����� ���������� ��������� ����� ������, ��� ������� � ����
    RIGHT_TIME_INTERFASE_UPDATE_PERIOD = 10 * 1000; // 10 ������
    /// ����� � ��������, ����� ������� �������� ������ � ������ ������������

    BASE_WORKGROUP_NAME = 'PDM';
    /// ��� ������� ������� ������, ������� ����������� ��� ��������� ���� � ����� PDM,
    /// � �� ������������ � ��������. �� ������ ����� ���������� id ������ ���
    /// ������ �������� ���� ��� �������� ������� ������

    ROLE_GROUP_EDITOR = 3;
    ROLE_GROUP_CHECKER = 2;
    /// ID �������� ����� �����, ������ ������ �������
    /// ��������� ����������� ��� �������� ������������ � ��������������� ������
    /// ��� ���������� ������������ ���������� ��� ����������� ������� �������


    // ������� �������
    TBL_OBJECT               = 'Object';               // ���������� ���� ��������
    TBL_FILE                 = '[FilesDB].[dbo].[PDMFiles]'; // ������� ��������� ���������
    TBL_DOCUMENT_EXTRA       = 'document_extra';       // ����������� ����� ����� ��� ��������-������(����������) � ��
    TBL_DOCUMENT_TYPE        = 'document_type';        // ���������� ����� ������ (����������, ��������, ������)
    TBL_OBJECT_CLASSIFICATOR = 'object_classificator'; // ���������� ����� ��������
    TBL_SECTION_EXTRA        = 'section_extra';        // �������������� ���� �������� (kind = 1)
    TBL_PROJECT              = 'project_object';       // ���������� ��������, ����������� � ������ (� ��������)
                                                       // ����� ����������� ����� ��� �������������� � TBL_OBJECT �
                                                       // ��������� � ������ �������
    TBL_PROJECT_STRUCTURE    = 'project_structure';    // ��������� ��������
    TBL_PROJECT_EXTRA        = 'project_extra';        // �������������� ������ �������-�������
    TBL_PROJECT_OBJECT_EXTRA = 'project_object_extra'; // �������������� ������ �������� � �������
    TBL_CUSTOM_SQL           = 'custom_sql';           // ���������� � ���������� ��������� ��� ��������
    TBL_MARK_TU              = 'pdm_MARK_BY_TU';       // ���������� ����������� �� ��

    TBL_EMPLOYEES            = '[nft].[dbo].[EMPLOYEES]'; // ���������� �����������
    TBL_LOGINS               = '[nft].[sec].[objects]';   // ���������� �������

    TBL_MAT                  = '[nft].[dbo].[mat]';    // ���������� ����������

    TBL_ROLES_WORKGROUPS     = 'ROLES_WORKGROUP';      // ��� ������������ ������� ������
    TBL_ROLES_GROUPS         = 'ROLES_GROUPS';         // ��� ������������ ������ ����
    TBL_ROLES_RIGHTS         = 'ROLES_RIGHTS';         // ��� ������������ �����
    LNK_ROLES_EMPL_WORKGROUP = 'roles_empl_workgroup_link'; // �������� ������������� � ������� ������
    LNK_ROLES_RIGHT_GROUP    = 'roles_right_group_link';  // �������� ����� � �������
    LNK_ROLES_GROUP_WORKGROUP = 'roles_group_workgroup_link';  // �������� ����� � ������� �������
    LNK_ROLES_RIGHT_EMPL     = 'roles_right_empl_link'; // ������������ ���� � ������ ������� ������

    LNK_STRUCTURE         = 'Structure';           // ������ ������ �������� (�������)
    LNK_STRUCTURE_CROSS   = 'Structure_cross';
    LNK_NAVIGATION        = 'Navigation';          // ������ ���������
    LNK_DOCUMENT_OBJECT   = 'document_object';     // �������� ���������� � �������� ��
    LNK_DOCUMENT_PROJECT_OBJECT =
                            'document_project_object'; // �������� ���������� � �������� ��������
    LNK_DOCUMENT_COMPLEX  = 'document_complex';    // �������� ��������� ���������� � ��������. ��������, ��������, ��������� � ������
    LNK_DOCUMENT_VERSION  = 'document_version';    // ������ ������ ����������. ����� �� ����� ���� �������
    LNK_DOCUMENT_INWORK   = 'document_inwork';     // �������� ������� ���������� � �� �������� �������
    LNK_SECTION_EXTRA     = 'section_link';        // �������� ����������� ����� � �������-�������
    LNK_PROJECT_STRUCTURE = 'project_structure';   // ������ ��������
    LNK_PROJECT_STRUCTURE_CROSS = 'project_structure_cross';
    LNK_PROJECT_EXTRA     = 'project_extra_link';  // �������� ��������� �������
    LNK_PROJECT_OBJECT_EXTRA = 'project_object_extra_link';
                                                   // �������� �������� ������� � �������������� ������
    LNK_PROJECT_EDITOR = 'project_editor_link';    // ������ �� ��������� �������
    LNK_PROJECT_CHECKER = 'project_checker_link';  // ������ �� ������������ �������

    LNK_EDITOR               = 'project_editor_link';
    LNK_CHECKERS             = 'project_checker_link';

    VIEW_GROUP             = 'vGroup';             // ������ � ������� ��� ������ ���������
    VIEW_OBJECT            = 'vObject';            // ������ � ������� ��� ������ ������� (�����, ������� ������ ��������)
    VIEW_DOCUMENT_KD       = 'vDocumentKD';        // ������ �� ����� ������� ���������� (�������� ���� ��������)
    VIEW_DOCUMENT_PROJECT  = 'vDocumentProject';   // ������ �� ����� ������� ���������� (�������� ���� ��������)
    VIEW_PROJECT           = 'vProject';           // ������ ������������ ��������
    VIEW_PROJECT_STRUCTURE = 'vProjectStructure1'; // ������� �������� ��������
    VIEW_ROLES_PERSONAL    = 'vRolesPersonal';     // ������������ ���� �������������
    VIEW_ROLES_GROUPS      = 'vRolesGroups';       // ���� ������������� �� ����������� �����

    VIEW_TYPE_PROD           = '[nft].[dbo].[vTypeProd]';
    // ���������� ��������� ����� ���������. ������� �������������� � ��� ��� �������������
    // ������ ������� ���������� ����� �������� �������� �����


    // ������������
    SECTION_DOCUMENT_INWORK  = '��������� � ������';
    SECTION_DOCUMENT_MY      = '��� ���������';
    SECTION_DOCUMENT_OTHER   = '������ ���������';
    SECTION_PROJECT_ALL      = '�������';
    SECTION_PROJECT_INWORK   = '� ������';
    SECTION_PROJECT_MY       = '��� �������';
    SECTION_PROJECT_OTHER    = '������';
    SECTION_PROJECT_FAVORITE = '��������';
    SECTION_PROJECT_ARCHIVE  = '�����';
    SECTION_EVENTS           = '�������';
    SECTION_MESSAGES         = '���������';
    SECTION_FAVORITE         = '���������';
    SECTION_DOCUMENTS        = '���������';

    SECTION_SPECIF = '������������';
    SECTION_ASSEMBLY = '��������� �������';

    // ���� ��������, ����������� �� ���������� ������� object_classificator.kind
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
    KIND_ARCHIVE  = 14;    // ������� ��������� �������
    KIND_PROJECT  = 100;

    // ���� � ������� ������� ��� �������� ������ �������� �����
    // ������� ������������ �� ���� � ����� ��������� ��� ����
    // ������� ����� �������� ����������� ������� ����� ����������� �������
    TAG_USER_ID = '#USER_ID#';

    TAG_VALUE = '#VALUE#';

    // �������� ������� ������� ��� ��������-��������
    // � ������� ������� ������������� ��������� ������� �������: ���, �������, ������� �������
    // ����������� �������� ���������� ������ ��� ������� �������.
    // ��������� �������� ����������� ���, ��� ��� �������� �� ����� ����� ����� ��������
    // ������ ��� ���������� ������������ (������ ��� ����), �������� ��� ������� ��������
    // � ������� ����������, ����������� � ���� ��������. ���� ������ ������� �� ����������
    // ���� �����������, ������� ����������� ������� ��-���������
    TAG_SELECT_OBJECTS = 'objects';
    TAG_SELECT_DOCUMENTS = 'documents';


    /// ����� ��������-������������ ������
    /// ��������� � ������� � []
    WORK_PROG_KOMPAS = '������';
    WORK_PROG_WORD   = 'Word';
    WORK_PROG_EXCEL  = 'Excel';


    LAYER_PRODUCTION_OBJECT  = '0';
    LAYER_PRODUCTION_SUBJECT = '1';
    LAYER_PROGRAM_SUPPORT    = '2';

    // ������ �������
    PROJECT_INWORK = 0;    // � ������
    PROJECT_ZREEZE = -1;   // ��������� � �� �������� ��� ��������������
    PROJECT_DONE   = -2;   // ������ �������� � �������� ��������. ����� ���� ������ ������

    // ������ ������� � �������
    PROJECT_OBJECT_VIEW     = 0;  // "��������" �� ������������� �� �������� ��� ���������� ���������,
    PROJECT_OBJECT_INWORK   = 1;  // "� ������" �������� ��������,
    PROJECT_OBJECT_CHECKING = 2;  // "�����" ���� ������������ �������� �������� ������,
    PROJECT_OBJECT_WAIT     = 3;  // "� ��������", �������� ������� ������� ��������
                                  // ������, �� ���� ��������� ������� � ��������� "� ������" ��� "� ��������"
    PROJECT_OBJECT_DONE     = 4;  // ����������, ����������� ��������, ������ ������ ����� � ������, ����� ������ �������
    PROJECT_OBJECT_READONLY = -1; // �� �������� ��� ��������������. ���������������
                                  // ��� ����� ������������ � ��(������������� ���������) ��������.
    PROJECT_OBJECT_NOSTATUS = -999; // ������ �� ����������, ������������ ��� �������� � ������� ��������
                                  // CheckLinkAllow, ����� � ��������� ������ ��� ���� �������



    ////////////////////////////////////////////////////////////////////////////
    ///    ������������ ������� ������
    ////////////////////////////////////////////////////////////////////////////
    COL_CONFIG_DEF = 'default';
    COL_CONFIG_PROJECT = 'project'; // � ������� ���������� �������


    ////////////////////////////////////////////////////////////////////////////
    ///    ���� �������������
    ////////////////////////////////////////////////////////////////////////////
    ROLE_ROLES_CONFIGURE      = 31;
    ROLE_WORKGROUPS_CONFIGURE = 32;

    ROLE_CREATE_PROJECT       = 33;
    ROLE_DONE_PROJECT         = 25;
    ROLE_FREEZE_PROJECT       = 26;
    ROLE_UNFREEZE_PROJECT     = 27;
    ROLE_DELETE_PROJECT       = 28;

    ROLE_OBJECT_TO_WORK_PERSONALY = 17; // ������ � ������ �����
    ROLE_OBJECT_TO_WORK_ASSIGMENT = 18; // ������ � ������ ����������� �����������
    ROLE_OBJECT_FROM_WORK         = 19; // �� ������� � ������ � ������ �� ��������� (��������)
    ROLE_OBJECT_TO_CHECK          = 20; // � ������ ��������
    ROLE_OBJECT_FROM_CHECK        = 21; // ������� �� �������� � ���������� ������
    ROLE_OBJECT_TO_READY_PERSONALY = 45;// � ������ ������ c ��������������� ����������
    ROLE_OBJECT_TO_READY          = 22; // � ������ ������
    ROLE_OBJECT_FROM_READY        = 23; // ������� �� ������ � ������ ��������

    ROLE_ADD_OBJECT = 34;               // �������� ������ ������� � ������ �������
    ROLE_EDIT_OBJECT = 35;              // �������������� �������� �������
    ROLE_LOAD_SPECIFICATION = 15;       // ������ ������������ � ������

    ROLE_LINK_TO_STRUCTURE = 36;        // �������� �������� � ��������� �������
    ROLE_UNLINK_FROM_STRUCTURE = 37;    // �������� �������� �� ��������� �������

    ROLE_ASSIGN_EDITOR = 38;            // ����������/������ ��������� �� ������������ �������������
    ROLE_DELETE_EDITOR = 39;            // �������� ��������� � ������� � �������
    ROLE_ASSIGN_CHECKER = 40;           // ���������� ���������� �� ����������� �������������
    ROLE_DELETE_CHECKER = 41;           // �������� �������� � ������� � �������

    ROLE_TAKE_DOC_IN_WORK = 42;         // ������ ������� � ������
    ROLE_SET_DOC_AS_MAIN = 43;          // ��������� �������� ��������� ��� ���������

    ROLE_SET_CURRENT_USER = 46;         // ����� �������� ������������ � ����������

implementation

end.
