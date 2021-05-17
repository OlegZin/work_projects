unit uDataManager;

{ ������ ��������� ����� � ������� �������, ����������� ��������������
  ��������� � ������� �� ������� �� ������������ ���������� ����������� �
  ���������� ��������� ���������.
}

interface

uses  ADODB, DB, StrUtils, dbtables, DateUtils, Windows, uTypes;

const
    // ������ �������� ������
    DEL_MODE_FULL      = 1;    // ������ �������� ��� ����� ���� �������.
                               // ������, ���� � ���������������� ����� ���������
                               // ��������� ������� � uid = 0. ����� ������� �����
                               // �������� ������
    DEL_MODE_SINGLE    = 2;    // �������� ��������� ������
    DEL_MODE_FULL_USER = 4;    // �������� ��������� � ���������, � ������ ����
                               // (������ ��������� ���� �������������). �� �������������
                               // ������������ ������ ����� ���������.
                               // ���� � ���, ��� ��� �������� � ����������������
                               // �����/������� �������� �������, �� ������� ���������
                               // ������ - ��� ������������� ��������� ��� ���������
                               // � ��� �������� �������� ��� �� ����� ����������,
                               // ��� �����������, ��������� ��� �������� ������
                               // ��������� ������.
    DEL_MODE_NO_CROSS  = 8;    // �������� � ������ ������������� ������� �������������� ������ ( ���_cross )
                               // ���������, �� ��� ����� ������ ����� ������ ��������.
                               // ��������, �������� ���������� � �������� ( [document_object] )
    DEL_MODE_NO_HISTORY = 16;  // �������� ��� ��������� ������ � ������� ��� �������
                               // ����� �������������� �� ������������ ���� ����������
                               // ��������, ��� ������� ������ ������, �������
                               // � �������� �� �������� � ����

    // ������� �������� �������
    STATE_PROJECT_DISABLED = -1;   // ���������� � ������������� �������, �� �������� ��� �������������� � ������ ������� �������
    STATE_PROJECT_READONLY = 0;    // ������ ��� ������, ���� �� ����� �������� ��������
    STATE_PROJECT_INWORK   = 1;    // � ������, �������� �����������
    STATE_PROJECT_CHECKING = 2;    // ����������� �������� ������, ��������� �������� ����������
    STATE_PROJECT_WAITING  = 3;    // ����������� �������� ������, �� ���� ��������� ������� � ������� "� ������"
    STATE_PROJECT_READY    = 4;    // ������� ��������� � ���������, ������ ��������� ������������ � ������� �������

    /// ������ ��������� ������� �������� �� �������
    /// ����� ��������� �������
    ROOT_MY_WORK_OBJECTS  = 1;    ///  �������� ��� ���� ������� � ������� "� ������" (� ��������)
    ROOT_MY_CHECK_OBJECTS = 2;    ///  �������� ��� ������� � ������� "� ��������" (� ���������)
    ROOT_MY_READY_OBJECTS = 4;    ///  �������� ��� ���� ������� � ������� "������" (� �������� ��� ���������)

type

    TArrElem = record
        TableName: string;
        TableFields: string;
    end;

//    TIntArray = array of integer;

    TDataManager = class

        lastVersionNumber : integer;
        // ����� ������ ���������� ������������ � ���� ���������
        // ����������� �������� �������� ��� ������������ ����
        // ������-��������.

        lastFullVersionNumber : string;


        ////////////////////////////////////////////////////////////////////////
        /// ������� ������
        ////////////////////////////////////////////////////////////////////////

        function UpdateTable(id: integer; tablename: string; Fields, Values: array of variant): boolean;
                    // ������� ���������� ������� � ��������� ������� �����

        function AddObject(fields: string; values: array of variant; tablename: string = ''; custom_only: boolean = false): integer;
                    // ��������� � ���� ����� ������, ���������� id ������ ����� �������

        function CopyObject( source_id, target_id: integer; source_table, target_table: string): integer;
                    // �������� ������ ������� �� ����� ������� � ������. ���������� id
                    // � ����� �������

        function ChangeObject(id: integer; Fields, Values: array of variant; comment: string = ''): boolean;
                    // ������ ������ ������� � ���� ������������� �������� ��������: [object], [project_object]

        function ChangeObjectEx( tablename: string; id: integer; Fields, Values: array of variant; comment: string = ''): boolean;
                    // ������ ������ ������ � ��������� ������� � ���������� ����������� ��������� � �����

        function DeleteObject( id: integer; comment: string; to_history: boolean = true): boolean;

        function AddLink(TableName: string; parent, child: integer; uid: integer = -1): integer;
                    // ��������� �������� � ��������� ������� ������.
                    // ������������� ����������� ����� ��������������� �������� � ��������� ����� �������� ������
                    // ���� �������� ������ ����������, ��� ����������� �� � ����� (������ �� ����� ����������������).
                    // ���������� id ����������� ������, ��� ��������� -1

        function PresentLink( parent, child: integer; tablename: string): integer;

        function UpdateLink( tablename: string; id: integer; fields, values: array of variant; comment: string = '' ): boolean;
                    // ��������� ������ ������ � ������������� ����� � ���������� ����������� ���������

        function CreateCrossLinks(TableName: string; id: integer; rebuild_sublinks: boolean = false): boolean;
                    // ������� �������������� ������ �� ��������� ���� ������� ��������� ������
        function DeleteCrossLinks(TableName: string; id: integer; comment: string = ''): boolean;
                    // ������� ���.����� � ���������� � �����

        function DeleteLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
        function DeleteLinkBy(TableName: string; parent, child: integer; comment: string = ''): boolean;

        function ChangeLinkParent( TableName: string; id: integer; parent_id: integer; comment: string = ''): boolean;
        function ChangeLinkChild( TableName: string; id: integer; child_id: integer; comment: string = ''): boolean;

        function SetCustomSQL( id: integer; tag, table, condition, colConfig: string ): boolean;
                    // ����������� � ������� ��������� ������

        function GetKindByID( kind_id: integer ): integer;

        function GetObjectAttr( id: integer; field: string): variant;
        /// ���������� �������� ���������� ���� ��� ���������� �������



        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ �� ��������������
        ////////////////////////////////////////////////////////////////////////

        function GetObjectBy( field, value, kind: string ): integer;
        // ����� id ������� �� ������ ������ ���� � ������ ����. ������������ ��� �������� ������������

        function GetProjectObjectBy( project_id: integer; field, value, kind: string ): integer;
        // ����� id ������� �� ������ ������ ���� � ������ ����. ������������ ��� �������� ������������

        function GetProjectObjectPresent(project_id: integer; mark: string): integer;
        /// �������� ������� � ������� (� ��������� ��� �� �����������) ������� ��
        /// ��� �����������

        function GetObjectByString( value: string ): TADOQuery;
        // ����� �� mark. ������������ ��� �������� ������������

        function SpecInWork( spec_id: integer ): boolean;
        // ���������, ��������� �� ������������ � ��������� id ������� � ������
        // � ����� �� ������������ ��������

        function GetSpecifList: TDataset;
        /// �������� ������� �� ����� ��������������, ������� �� ��������� � ������



        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ � ����������� � �������
        ////////////////////////////////////////////////////////////////////////

        function CreateDocumentVersion( object_id, version, doc_type: integer; name, filename, comment: string; is_main: integer = -1): integer;
                    // �������� ������ ��������� � ��������� � ���������� �������

        function TakeDocumentToWork( doc_id: integer ): boolean;

        function UpdateDocumentVersion( work_version_id: integer ): boolean;
                    // ��������� ������ ��������� ������. ���������������, ��� ���
                    // ������� ������ ���������, ������ ������� ����� �������� ���������������

        function DeleteDocumentVersion( doc_id: integer ): boolean;
                    // ������� �� ������� ������ ���������

        function SaveWorkDocumentAsVersion( work_version_id: integer ): boolean;
                    // ��������� ������� ������� ������ � ��������� �� � ������ ����� �����������

        function DeleteWorkDocument( work_version_id: integer ): boolean;
                    // ������� ������� ������ ��� ����������


        function GetFileFromStorage( path, filename, DBName: string ): boolean;
                    // ��������� ���� �� ��������� � ��������� ���������

        function UploadVersionFile( doc_version_id: integer ): boolean;

        function RemoveFileFromStorage( DBName: string ): boolean;

        function SetDocAsMain( doc_id, obj_id: integer ): boolean;
                    // ��������� ���������� ��������� ������� ��������� ����� ����
                    // ����������, ����������� � �������

        function GetGroupSubitems( id, kind: integer; fields: string; query: TDataSet): TADOQuery;
        function GetSpecifSubitems( id, kind: integer; fields: string; query: TDataSet): TADOQuery;
        function GetSpecifSubitemsEx(id, kind, project_id: integer; fields, itemsTable, linksTable: string;
          query: TDataSet): TADOQuery;

        function GetProjectDocsList( id, kind: integer; query: TDataSet ): TADOQuery;
        function GetKDDocsList( id, kind: integer; query: TDataSet ): TADOQuery;

        function UpdateHasDocsFlag( id: integer ): boolean;
                    // ���������� � ����������� �������� �������� ������� ����������� ���������� � �������

        function SetInWorkState( child, mode: integer ): boolean;
                    // ��������� ��� ������ �������� ������ � ������ ���������

        function GetVersionPath( id: integer; filename: boolean = false ): string;
                    // �� id �������-��������� �������� ��� ������ � ������ ���� ��� �������� ������ �� ���� ������������

        function GetNextVersionNumber( name: string; object_id: integer ): integer;
                    // �� ����� ����� � �������-�������� �������� ��������� ����� ������

        function IsInWork( doc_version_id: integer ): boolean;
                    // �� id ��������� ���������, �� �������� �� ��� ��������� ������� ��� �� ������� ����������

        function IsWorkVersion( doc_version_id: integer ): boolean;
                    // �� id ��������� ��������� �� �������� �� ��� ������� ������� ���������
                    // �� ������ � ��������, ������� ��������, �� ��������� �� �����

        function HasMainDoc(object_id: integer ): boolean;
                    // ���������, ���� �� � ������� ����������� ����� � ��������� ���������

        function GetProgramByExt( ext: string ): string;
                    // �� ���������� ����� �������� �� ������� [document_type].[program] - ���������-����������

        function HasDocInWork( object_id: integer; check_childrens: boolean = false): boolean;
        // ���������, ���� �� � ���������� ������� ��� ��� �������� ��������� � ������




        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ � ��������� (�������)
        ////////////////////////////////////////////////////////////////////////

        function AddSection(parent: integer; name, tag, tablename, condition: string; colConfig: string = ''; user_id: integer = -1): integer;
                    // ������� ����� ����� � ��������� � ���������� �������
                    // � ������ �������� ������� ������

        function GetTypeProdLevel( parent_id: integer ): TDataset;
        /// ��������� ��������� ���������� ������ �� ������ ������������� ���������

        function GetColConfigName( object_id: integer; def: string ): string;
        /// ���������� ��� ������������ ����������� ��� ����������� ������ ���������
        /// �������� ���������� �������



        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ � ���������
        ////////////////////////////////////////////////////////////////////////

        function CreateProject( name, comment, mark, parent_prod_kod, prod_kod: string; objectId, workgroupId: integer ): integer;
        // ������� ����� ������, ���� ��������� ������ ��� �� ���� � ������
        // ������ ��������. ���������� ��� id

        function CopyObjectToProject( proje�t_id, parent_id, object_id: integer ): integer;
        // ����������� �� �������� ��������� ���������� ��������/����� �
        // ��������� ������� � ��������� � ���������� �������� ���������

        function UpdateProjectMark( project_id: integer ): boolean;
        // ��������� ����������� ���������������� �������

        function ProjectStatus( ProjectID: integer ): integer;
        // ���������� ������� ������ ���������� �������
        function SetProjectState(ObjectID, status: integer): boolean;
        // ������������� ��������� ������

        function FreezProject( ProjectID: integer ): boolean;
        // ������������ ��������� ������ � ������� ���������,
        // �������� ����������� �������������� � ���

        function UnFreezProject( ProjectID: integer): boolean;
        // ������� � ������� ������ �������������, ��� ��������� ��� �������������

        function DoneProject( ProjectID: integer): boolean;
        // ������������� ������ ������������. ������ ��������� ��������
        // � ����� ���� ������ ������

        function SetProjectObjectState( ObjectID, status: integer ): boolean;
        // ������� ���������� ������� � ��������� ������� ������, ���� ��������

        function ChildsToReadyStatus( parent_id, project_id: integer; full: boolean = false; recurs: boolean = false): boolean;
        // �������� ������� � ������ ���������� ���� ���������������� ��� �������� ���� �������

        function DeleteProject( ProjectID: integer ): boolean;
        // ��������� ������� ��������� ������ �� ���� ��������

        function CheckLinkAllow( child_kind, child_subkind, child_status,
            parent_kind, parent_subkind, parent_status : integer): string;
        // �������� �� ����������� �������� ���� �������� ���� � �����, ������ ��
        // �� ����� � �������� �������� �������. ���������� ������ � �������� ������,
        // ���� �������� �����������.

        function GetProjectWorkgroup( project_id: integer ): integer;

        function GetProjectReadyPercent( project_id: integer ): integer;
        // ���������� ������� ���������� �������

        function CreateProjectObject( mark, realization, markTU, name, mass, comment: string; kind_id, material_id, obj_icon, project_id: integer ): integer;
        /// ������� � ������� ����� ������ ���������� ���� � ����������, ������ � ������� ���������

        function LinkToProjectObject( parent, child, project_id: integer ): string;
        /// �������� ���������� ������� ������� � ���������� �������� � �������
        /// ��� �������� ����������� ����������� �������� (������ �� ����� ��������)
        /// ������ ������������ � ���� ������

        function GetNextIspolNumber( child: integer ): integer;
        /// ��� ���������� �������-������������ ���������� ��������� ������������ �����
        /// ���������� (�� ��������� ���� � ���������)

        function CreateIspoln( project_id, parent: integer; mark, name: string ): integer;
        /// �������� ���������� ��� ��������� ������������ � ��������������
        /// ���������� ������ � ���������

        function CopyIspoln( project_id, parent, child: integer; mark, name: string ): integer;
        /// �������� ���������� ��� ��������� ������������ � ��������������
        /// ���������� ������ � ���������. � ����� ������������ ������������� ���
        /// ������� ��������

        function ObjectIsReady( object_id: integer ): boolean;
        /// ����� ��������� ���� �������� �� ������� ������ � ���������� false,
        /// ���� ���� ���� ���� � ������� � ������ ��� � ��������

        function GetRootElems( project_id, get_mode: integer ): TIntArray;
        /// �������� ����� �������� �� �������, ������������ ���������, �������������
        /// ������� ���������



        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ � �������
        ////////////////////////////////////////////////////////////////////////

        function HasRole( role_id, workgroup_id: integer; value: string = '' ): boolean; overload;
        function HasRole( role_name: string; workgroup_id: integer; value: string = '' ): boolean; overload;
        function HasRole( role_id: integer; value: string = '' ): boolean; overload;
        function HasRole( role_name: string; value: string = '' ): boolean; overload;
        // ��������� ������� � �������� ������������ ��������� ����
        // ���� ������� value, ��������� ������� �� ���������� �������� � �����
        // ������� ��� ������ �������� ����� CheckRole

        function RoleValue( role_id, workgroup_id: integer ): string; overload;
        function RoleValue( role_name: string; workgroup_id: integer ): string; overload;
        function RoleValue( role_id: integer ): string; overload;
        function RoleValue( role_name: string ): string; overload;
        /// ���������� ������������ �������� ����:
        /// �������� �������� ����������� ������� �������� ����
        /// �������� �������� ��� GetRoleValue

        procedure RefreshRolesList( refresh: boolean = false );
        // ��������� ��������� ������� ������������ ������ ������ � ������
        // � ��������� ��� �� ����, ��� �������������


        function CreateWorkgroup( name: string; tag: string = '' ): boolean;
        // ������� � ������� [ROLE_WORKGROUPS] ����� ������� ������.
        // ���� � ����� ������ ��� ����������, ���������� ������.
        function UpdateWorkgroup(group_id: integer; name: string ): boolean;
        // ���������� ����� ������� ������
        function DeleleWorkgroup( group_id: integer ): boolean;
        // �������� ������� ������ � ���� ������, ���������� �� ���


        function CreateGroup( name: string ): boolean;
        // ������� � ������� [ROLE_GROUPS] ����� ������ ����.
        // ���� � ����� ������ ��� ����������, ���������� ������.
        function UpdateGroup( group_id: integer; name : string ): boolean;
        // ���������� ����� ������ ����
        function DeleleGroup( group_id: integer ): boolean;
        // �������� ������ ����. ������ ������ �����, ����������� �� ��� ������


        function CreateRole( name, value: string ): boolean;
        // ������� � ������� [ROLE_RIGHTS] ����� ����.
        // ���� � ����� ������ ��� ����������, ���������� ������.
        function UpdateRole( id: integer; name, value: string ): boolean;
        // ��������� ������ ��������� ����
        function DeleteRole( role_id: integer ): boolean;
        // ������� ��������� ����, ������ ��� ������ �� ���


        function LinkUserToWorkroup( workgroup_id, user_id: integer ): integer;
        // ��������� ���������� ������������ � ��������� ������� ������
        function UpdateLinkUserToWorkroup( workgroup_id, user_id: integer; todate: TDate; dateSelected: boolean ): boolean;
        // ���������� ������� ����������� �������� ������������ � ������� ������
        function DeleleLinkUserToWorkgroup ( workgroup_id, user_id: integer ): boolean;
        // �������� ������������ �� ��������� ������� ������. �������� ����
        // ����� � �����, ����������� �� ����� ������������ � ������ ������� ������


        function LinkWorkgroupUserToGroup( workgroup_id, user_id, group_id: integer ): boolean;
        // �������� ������ ���� � ������������ � ������ ������� ������
        function UpdateLinkUserToGroup(workgroup_id, user_id, group_id: integer;
          todate: TDate; dateSelected: boolean): boolean;
        // ���������� ������� ����������� �������� ������������ � ������ ���� � ������ ������� ������
        function DeleteLinkWorkgroupUserToGroup( workgroup_id, user_id, group_id: integer ): boolean;
        // �������� �������� ������������ � ������ ���� � ������ ������� ������


        function LinkPersonalRole( workgroup_id, user_id, role_id: integer ): boolean;
        // �������� ������������ ������������ ����
        function UpdateLinkPersonalRole(workgroup_id, user_id, role_id: integer;
            value: string; todate: TDate; dateSelected: boolean): boolean;
        // ���������� ������ ������������ ����
        function DeleteLinkPersonalRole( workgroup_id, user_id, role_id: integer ): boolean;
        // �������� ������������ ���� ������������


        function LinkRoleToGroup( group_id, role_id: integer; value: string = '' ): boolean;
        // ��������� ���� � ������
        function UpdateGroupRole( link_id: integer; value: string ): boolean;
        // ���������� �������� ��������
        function DelLinkRoleToGroup( role_link_id: integer ): boolean;
        // ���������� ���� �� ������


        function GetWorkgroupName( workgroup_id: integer ): string;
        // ���������� ������������ ������� ������ �� �� id

        function GetWorkgroupsList( dataset: TDataset = nil; tag: string = '' ): TDataset;
        // �������� ������ ���� ������������ ������� �����

        function GetWorkgroupUserList( workgroup_id: integer; dataset: TDataset ): TDataset;
        // �������� ������ ���� ��������������, ����������� � ��������� ������� ������

        function GetWorkgroupUserGroupsList( workgroup_id, user_id: integer; dataset: TDataset ): TDataset;
        // ��������� ������ ���� ����� ����, ����������� � ����������� � ������ ������� ������

        function GetWorkgroupUserRolesList( workgroup_id, user_id, group_id: integer; dataset: TDataset ): TDataset;
        // ��������� ������ ���� ������������� � ������ ��������� ������ ����

        function GetWorkgroupUserRolesFullList( workgroup_id, user_id: integer; dataset: TDataset ): TDataset;
        // ���������� ������ ������ ���� ���� �� ���� �����, ����������� � ������������
        // ������������ ��� ���������� ����������� ��� �������� �� �������

        function GetWorkgroupUserPersonalRolesList( workgroup_id, user_id: integer; dataset: TDataset ): TDataset;
        // ��������� ������� ������ ���� ������������ ���� ������������ � ������ ������� ������

        function GetProjectUserList( workgroup_id, project_id: integer ): TADOQuery;
        // ��������� ������ ���� ������������� �������. ��� ����������� ����� ������� ������, ���
        // � �������� � �������

        function GetGroupsList( dataset: TDataset ): TDataset; overload;
        function GetGroupsList( dataset: TADOQuery ): TADOQuery; overload;
        // �������� ������ ���� ������������ ����� ����

        function GetRolesList( dataset: TDataset ): TDataset;
        // �������� ������ ���� ������������ ����

        function GetGroupRolesList( group_id: integer; dataset: TDataset ): TDataset;
        // �������� ������ �����, ����������� � ��������� ������ ����

        function GetEmplToWorkgroupLink( workgroup_id, user_id: integer ): integer;
        // ��������� id �������� ������������ � ������� ������.
        // � ��������� �������� �� ����������� id ������������ ������ � ���������
        // ������������ � ������� � ������������ ������ � ������ ������� ������

        function GetBaseWorkgroupId: integer;
        // ��������� id �������� ������� ������, ��������������� ��� ����������
        // ������� ������ � PDM, � �� � ������ �������



        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ � ����������� � ������������ � ������ �������
        ////////////////////////////////////////////////////////////////////////

        function LinkEditorToObject( object_id, user_id, project_id: integer ): integer;
        /// �������� ��������� � �������
        function GetObjectEditors( object_id, project_id: integer ): TDataset;
        /// ��������� ���� ����������, ����������� � �������
        function DeleteOjectEditor( object_id, user_id: integer ): boolean;
        /// �������� ���������� ��������� � �������
        function UnlinkEditorsFromObject( object_id: integer): boolean;
        /// �������� ���� ���������� � �������

        function LinkCheckerToObject( object_id, user_id, project_id: integer ): integer;
        /// �������� ������������ � �������
        function GetObjectCheckers( object_id, project_id: integer ): TDataset;
        /// ������� ���� ����������� ���������� �������
        function DeleteOjectChecker( object_id, user_id: integer ): boolean;
        /// �������� ���������� ������������
        function UnlinkCheckersFromObject( object_id: integer ): boolean;
        /// �������� ���� ����������� � �������


        function UserIsEditor( object_id: integer ): boolean;
        /// ��������� �� ������� ������������ ����� ���������� ���������� �������
        function UserIsChecker( object_id: integer ): boolean;
        /// ��������� �� ������� ������������ ����� ����������� ���������� �������



        ////////////////////////////////////////////////////////////////////////
        /// ������ ������ �� ������������ ������������
        ///    ������ �������� � �������� [nft].[mat].[EPR]
        ////////////////////////////////////////////////////////////////////////

        function GetERP( name: string ): string;
        /// �������� ��� ����������� �� ����� �������, � ������ ��������

        function AddERPVariation( erp, name_variation: string ): boolean;
        /// ��������� �������� ������������ � �����������

        function GetMaterialRecord( field, value: string ): TDataset;
    private
        LastRightDataset: TDataset;
        /// ������ ����� ������ � ������� �������� ������������, ���������� ��������
        /// �� ����������� ��������� �����. ��������� ������� �������� �� ������ ��� ����������
        /// �������� ���� � ���������, ������ �� ����, ��� ���������� ����� �����
        /// ���������� ����������.
        /// ����� �������, �� ����������� ��������� ����� ����� ����������� ��������,
        /// � � ������������� �������� ������ ������������ ��������� ����� ������
        /// ��� ������ ����.
        /// ��������� RIGHT_TIME_VALIDE_PERIOD �������� ������ ���������� ������ ����� � �������

        LastRightCheck: TDateTime;
        /// ��������� �����, ����� � ��������� ��� ��� �������� ����� ����� ������������

//        TableFields: array of TArrElem;
                    // ������ �� ������� ���������� ����� ������.
                    // ������������ � ��������� ����������� ������ �� ����������
                    // ������ � ��������. � ������ ���������� ����������� ������ � ����.
                    // � �����������, ������ ������� �� ������� ������� (������������ ������ � �������� �� ��)



        function ArrToString(arr: array of variant; quoted: boolean = false): string;
                    // �������� ������������� ����������� ������� ����������� � ������ ����� �������
                    // ��� ������������ ����� - ������������� � �������
                    // ���������� ������ ������������� � ������� � �������� ������ �����, ��� �������� ��� INSERT INTO

        function DelLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
                    // ������� �����, ������� � �����. � ��� �� ��� ��������� (��������), ����
                    // ��������� ���� clear_childrens

        function BuildUpdateSQL(id: integer; TableName: string; Fields, Values: array of variant): string;
                    // ����� ��������� UPDATE sql-������

        function AddFileToStorage( name, filename: string ): boolean;
                    // ��������� ���� � ����-���������
        function UpdateFileInStorage( name, filename: string ): boolean;
                    // �������������� ���� � ���������

        function GetDocsCount( id: integer): integer;

        function GetCustomSQL(id: integer; tag: string): string;
                    // ���������� ��������� ������

        function GetObjectSubitems( id, kind: integer; fields, ItemTable, LinkTable, tag, custom_where: string; query: TDataSet ): TADOQuery;

        function CheckRole( workgroup_id: integer; name: string; key: variant; value: string ): boolean;
        // ��������� ������� � �������� ������������ ��������� ����
        // ���� ������� value, ��������� ������� �� ���������� �������� � �����

        function GetRoleValue( workgroup_id: integer; name: string; key: variant ): string;
        /// ���������� ������������ ��������, ��������� ����

    end;

implementation

{ TDataManager }

uses
    uPhenixCORE, uConstants, SysUtils, Variants, Math, Classes, uMain;

const

    // ����������� ���������� ����� � �����
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
    // ����������� �������� ������ �� ������� ����������
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
        // ��������� �������� ������������� ������ ������ ���������� ���������
        // � ������ �������, � �������� �������� (� ������ ������ �������� ���������
        // ���������� �����)

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


    // �������� ������ � ��������� �������-������� (kind = 1)
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

    /// ��������� ���� �������� �������� ������� (����������� ��������������� �
    /// ������� �������) � ���� ������ �������� ��������, ���������� ������������.
    /// ��� ����, ����������� ���������������, ��� �������� ������� - ������������
    /// ��������� ���������� ����� ���� ��������� ������ � ���.
    SQL_GET_TOPOBJECT_EXTRA_ID =
        ' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent = %0:d '+ sLineBreak +
        ' UNION '                                                               + sLineBreak +
        ' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent in ('   + sLineBreak +
          ' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE                        + sLineBreak +
          ' WHERE parent = %0:d )'                                               + sLineBreak +
        ' AND icon = 11'; // 11 = ����������

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
    /// ���������� �������� id ������� ������ �� [ROLES_WORKGROUPS] � ������
    /// �� ��������� BASE_WORKGROUP_NAME.


function TDataManager.AddFileToStorage( name, filename: string ): boolean;
{ ����� ��������� � ��������� ��������� ����.

  ���������������, ��� Name �������� ���������� ��� ������� ���������, � ���
  ������������ � ����������� ������ ������.

  filename - ������ ���� � ������ ������ �����
}
label ext;
var
    FileStream: TFileStream;
    BlobStream: TStream;
    Query: TADOQuery;
begin

    lC('AddFileToStorage');
    result := false;

    // �������� ������� �����
    if Not FileExists(filename) then
    begin
        Core.DM.DBError := LE('���� '+filename+' �����������.');
        goto ext;
    end;

    // ��������� �������, ����� �������� ����� ������ �����
    Query := Core.DM.OpenQueryEx( Format( SQL_GET_FILE_DATA, [ name ] ));
    if Not Assigned(Query) then goto ext;

    // ���� ������
    if not Query.IsEmpty then
    begin
        Core.DM.DBError := LE('���� � ������ '+name+' ��� ���� � ���� ������. ������������ �� �����������.');
        goto ext;
    end;

    // ��������� �������-���������
    Query := Core.DM.OpenQueryEx( SQL_OPEN_FILE_TABLE );

    // ��������� �����
    Query.Insert;
    Query.FieldByName('name').AsString := name;

    try

        // �������� ���� � ����
        BlobStream := Query.CreateBlobStream( Query.FieldByName('file_stream'), bmWrite );
        FileStream := TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
        BlobStream.CopyFrom( FileStream, FileStream.Size );

        // ��������� ������ ��� ����������� ���������� ��������
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
/// ���������� ��� ������������ ����������� ��� ����������� ������ ���������
/// �������� ���������� �������
begin
    result := dmSDQ( 'SELECT column_config FROM '+TBL_CUSTOM_SQL+' WHERE parent = '+IntToStr(object_id), def );
end;

function TDataManager.GetCustomSQL(id: integer; tag: string): string;
begin

    result := '';

    dmOQ( 'SELECT * FROM '+TBL_CUSTOM_SQL+' WHERE parent = '+IntToStr(id)+' AND tag like ''%'+tag+'%''' );
    if ( CORE.DM.Query.Active )and ( CORE.DM.Query.RecordCount > 0) then
    begin

        // ��������� ������
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

        // ��������� ���� �� ���������� ��������
        result := ReplaceStr(result, TAG_USER_ID, IntToStr(CORE.User.id));
    end;

end;

function TDataManager.GetDocsCount( id: integer): integer;
begin
    dmOQ( Format( SQL_GET_PROJECT_DOC_VERSIONS, [ id ] ));
    result := Core.DM.Query.RecordCount;
end;

function TDataManager.GetProjectDocsList(id, kind: integer; query: TDataSet): TADOQuery;
{ ��� ���������� ������� �������� ����� ������ �� ����� �������� ���� ����������.
  ������������ ������� ������������� ��� �������� ������ ��� ������� grdDocs
  id - ������ ��� �������� ����� ������� ������ ����������� ����������
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
{ ����� ��������� ���� �� ��������� ������ �� ��������� ���������
  path - ���� ��� ��������
  filename - ��� ����� � �����������, ��� ������� ���������
  DBname - ��� ����� � ��������� [FilesDB].[PDMFiles].[name]

  ���������������, ��� ���� ����������� � ������ ������������, �.�. ���
  ������� ��� �������� ��� ������� ����� � ��������� ���� ����������.

  �� ���������, ������� ���� �:\im\imwork\pdm\
}
label ext;
var
    FileStream: TFileStream;
    BlobStream: TStream;
    query: TADOQuery;
begin
    lC('TDataManager.GetFileFromStorage');
    result := false;

    // �������� ������� ��������� ����������
    if not DirectoryExists( path ) then
    if not CreateDir( path ) then
    begin
        Core.DM.DBError := lW('��������� '+ path + ' �� ���������� ��� �� ����� ���� �������.');
        goto ext;
    end;

    // �������� ������ �� ����
    query := Core.DM.OpenQueryEx( Format( SQL_GET_FILE_DATA, [ DBname ] ));
    if not Assigned( query ) then goto ext;

    if not Query.Active or ( Query.RecordCount = 0 ) then
    begin
        Core.DM.DBError := lW('���� '+ DBname + ' � ��������� �� ���������.');
        goto ext;
    end;

    // ������� ����, ���� �������� �� ����
    if   FileExists( path + filename )
    then DeleteFile( path + filename );

    if   not FileExists( path + filename )
    then FileCLose( FileCreate( path + filename ) );

    if   not FileExists( path + filename ) then
    begin
        Core.DM.DBError := lW('�� ������� ������� ���� '+ filename );
        goto ext;
    end;


    BlobStream := Query.CreateBlobStream( Query.FieldByName('file_stream'), bmRead );
    FileStream := TFileStream.Create( path + fileName, fmOpenWrite );
    FileStream.CopyFrom( BlobStream, BlobStream.Size );

    // ��������� ������ ��� ����������� ���������� ��������
    FreeAndNil( FileStream );
    FreeAndNil( BlobStream );

    result := true;

ext:
    lCE;
end;



function TDataManager.GetNextIspolNumber(child: integer): integer;
/// ��� ���������� �������-������������ ���������� ��������� ������������ �����
/// ���������� (�� ��������� ���� � ���������)
///    child - ������-������������ � �������
///
/// ������ �������� ����������� � ���, ��� ��������� ���������� ���������� � ����
begin
    result := dmSDQ( ' SELECT count(child) FROM ' +VIEW_PROJECT_STRUCTURE+ ' WHERE parent = '+IntToStr(child), 0);
end;

function TDataManager.GetNextVersionNumber(name: string; object_id: integer ): integer;
begin
//    result := Integer( dmSDQ( Format( SQL_GET_MAX_VERSION, [ name, object_id ] )+'%''', 0 )) + 1;
    result := Integer( dmSDQ( Format( SQL_GET_MAX_VERSION, [ name, object_id ] ), 0 )) + 1;
    // ����� ����� ����� ������ Format, ���������� % � ������, ����������� � like �������,
    // ������ ��� ������������ ���������� ��� �����������. ����������� ������� ����� �����������
    // �������� � ������ �������
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
/// ������� � ���������� ������� ���������� ���������� �������
/// ������� �������� ���������� ������ ���������� ��������
/// � ���������� �������� � ������� ������ + ����������
var
    full_count    // ����� ���������� �������� � �������
   ,ready_count   // ���������� ����������� � �����������
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
/// �������� ������ ���� ����������, ����������� �� ��������� ������ �������
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
/// �������� ���������, ������������ � �������
begin
    result := dmEQ(
        ' DELETE FROM ' + LNK_PROJECT_EDITOR +
        ' WHERE parent = ' + IntToStr(object_id) +
        ' AND child = ' + IntToStr(user_id) );
end;

function TDataManager.GetGroupSubitems( id, kind: integer; fields: string; query: TDataSet): TADOQuery;
/// ��������� ������ ��� ������� �������� ��� ����������� �� ������ �������� �����
begin
    result := GetObjectSubitems(id, kind, fields, VIEW_GROUP, LNK_NAVIGATION, TAG_SELECT_OBJECTS, '', query);
end;

function TDataManager.GetKindByID(kind_id: integer): integer;
begin
    result := dmSQ( 'SELECT kind FROM ' + TBL_OBJECT_CLASSIFICATOR + ' WHERE id = ' + IntToStr(kind_id) );
end;

function TDataManager.GetSpecifSubitemsEx(id, kind, project_id: integer; fields, itemsTable, linksTable: string;
  query: TDataSet): TADOQuery;
/// ��������� ������ ��� ������� �������� ��� ����������� �� ������ ������������
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
/// �������� ������� �� ����� ��������������, ������� �� ��������� � ������
begin
    result := CORE.DM.OpenQueryEx(
        ' SELECT child, full_mark, full_name FROM '+ VIEW_OBJECT +
        ' WHERE mark NOT IN ( SELECT mark FROM '+ VIEW_PROJECT +' WHERE status <> '+IntToStr(PROJECT_DONE)+') AND icon = ' + IntToStr(KIND_SPECIF) );
end;

function TDataManager.GetSpecifSubitems(id, kind: integer; fields: string;
  query: TDataSet): TADOQuery;
/// ��������� ������ ��� ������� �������� ��� ����������� �� ������ ������������
begin
    result := GetObjectSubitems(id, kind, fields, VIEW_OBJECT, LNK_STRUCTURE, TAG_SELECT_OBJECTS, '', query);
end;

function TDataManager.GetObjectSubitems(id, kind: integer; fields, ItemTable,
  LinkTable, tag, custom_where: string; query: TDataSet): TADOQuery;
///  ��� ���������� ������� �������� ����� ������ �� ����� ���������� ���������.
///  ������������ ������� ������������� ��� �������� ������ ��� ������� grdObject
///  � ������ �������� � ��� ������-��������, ����� ����� ����������� �������� � ���
///  ��� � �� ����� ����������. ��������, �����������/������������� ���������
///
///  ��� ����, ��� ������� ����� ������������ ����������� ������ �������
///
///  id - ��������� ������
///  kind - ��� ������� ��� �������� ������ �������. ��� ����� ���� ����� � ��������� ��������
///  fields - ����� ���� ������ ����� ������������ ����� ������
///  itemtable - ������� ��� ������, ���������� ������ ������
///  linktable - ������� ������, �� ������� ���������� ����� ��������� ��������
///  tag - �� ������ �������� �������� ���������� �������, ����� �������� ������ ��� kind = �����
///  custom_where - ������ �������
///  query - ������� � ������� ������� ������
var
    mark_id
            : integer;
    sql
            : string;
begin

    // ���������� ��������� ������
    if Assigned(query) and query.Active and Assigned(query.FindField('child'))
    then mark_id := query.FieldByName('child').AsInteger;

    // � ����� ����� ���� ��������� ������, �������� ��� �����
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

    // ��������������� ��������� ������
    if Assigned(query) and query.Active and Assigned(query.FindField('child'))
    then query.Locate('child', mark_id, []);

end;

function TDataManager.GetProgramByExt(ext: string): string;
begin
    result := dmSDQ('SELECT program FROM ' + TBL_DOCUMENT_TYPE + ' WHERE ext = ''' + ext + '''', '');
end;

function TDataManager.HasDocInWork(object_id: integer; check_childrens: boolean = false): boolean;
// ���������, ���� �� � ���������� ������� ����������� ��������� � ������� ������
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
/// ��������, ���� �� � ������� ����������� ��������� � ��������� ���������
/// ����������� ��� �������� ������ � �������, ��� ����������� �� ����������� ��������
/// ���������. �������� ����� ���� ������ ���� (��� ��� ������ ��� �� � ��������� ��������)
begin
    result := dmSDQ( Format('SELECT COUNT(project_object_id) FROM %s WHERE project_object_id = %d AND is_main <> 0', [VIEW_DOCUMENT_PROJECT, object_id]), 0 ) <> 0
end;

function TDataManager.IsInWork(doc_version_id: integer): boolean;
/// ���������, �� �������� �� ��������� �������� ������ � ������ ���
///  ������� �������.
var
    query : TADOQuery;
begin
    result := false;

    // �������� ������ ��������� ������
    query := CORE.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr(doc_version_id) );
    if not assigned(query) or (query.RecordCount=0) then exit;

    /// �������� ����� ������� ������, ������������ �� ���������
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
{ �������� ������ ��������� �� ��, ��� ��� �������� ������� �������
  (���� ����������� ��� ��������� �� ��� ���, ���� ��� �� ����� ���������,
   ��� ������������ ����� ������)
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
/// ���������� ������� ��������� ���������� ������� (� ������/��������� � �.�.)
begin
    result := dmSDQ( Format( SQL_GET_PROJECT_STATUS, [ ProjectID ]), -1 );
end;

function TDataManager.RemoveFileFromStorage(DBName: string): boolean;
begin
    result := CORE.DM.ExecQuery( Format( SQL_REMOVE_FROM_TABLE, [ TBL_FILE, 'name', DBName ] ));
end;

function TDataManager.SaveWorkDocumentAsVersion(
  work_version_id: integer): boolean;
{ ����� ��������� ������� ������� ������ �� �����
  � ��������� ������� ������ � ������ ����������� (��������� �� ������ �� ��������)
}
var
    query: TADOQuery;
    filename : string;
    version : integer;
begin
    result := false;

    // ��������� ��������� ��������� ������� ������
    if not UpdateDocumentVersion( work_version_id ) then exit;

    /// �������� ������� ������������ ����� ������ ������ ���������
    version := dmSQ(
        ' SELECT MAX(version) FROM ' + TBL_DOCUMENT_EXTRA +
        ' WHERE project_doc_id = ' + IntToStr(work_version_id) +
        ' AND filename = ( SELECT filename FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id) + ')'
    );

    /// �������� id ��������� ��������� � �������� ������, �������� �������
    /// ��� ���� ����� ������������ �� ��������� ������ ������
    if not dmEQ(
        BuildUpdateSQL(
            dmSQ( 'SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id)),
            TBL_DOCUMENT_EXTRA,
            [ 'version', 'minor_version', 'editor_id' ],
            [ version + 1 ,'*null', '*null' ]
            )
        ) then exit;
{
    // ������� ������� ����(-�) � ����� ������
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
/// ����������� � ������� ��������� ������ �� ������� ������ ��� ���������� �����������
begin
    result := dmEQ( Format( 'INSERT INTO %s (parent, tag, tablename, condition, column_config) VALUES (%d, ''%s'', ''%s'', ''%s'', ''%s'')',
                            [TBL_CUSTOM_SQL, id, tag, table, condition, colConfig] ));
end;

function TDataManager.SetDocAsMain(doc_id, obj_id: integer): boolean;
// ��������� ���������� ��������� ������� ��������� ����� ����
// ����������, ����������� � �������.
// ��������� �������� ����� ���� ������ ���� ��������, � ���� ���������
// ���� ������� ������������
begin
    result := false;

    // ���������� ������� ��������� � ���� ���������� �������
    dmEQ(' UPDATE ' + TBL_DOCUMENT_EXTRA + ' SET is_main = 0 WHERE project_object_id = ' + IntToStr(obj_id));

    // ������������� ������� ���������
    dmEQ(' UPDATE ' + TBL_DOCUMENT_EXTRA +
         ' SET is_main = 1 '+
         ' WHERE project_object_id = ' + IntToStr(obj_id) +
         ' AND project_doc_id = ' + IntToStr(doc_id) );

    result := true;
end;

function TDataManager.SetInWorkState(child, mode: integer): boolean;
{ ����� ������ ������� ������ � ������ ���������
  child - id �������-���������
  mode - ����� � ������� ����� ��������� �������:
       0 - �� � ������, ��� ���� ������������ � work_id (��������)
       1 - � ������, ��� ���� ��������������� � work_id (��������)
}
begin
    result := dmEQ( Format( SQL_SET_DOCUMENT_INWORK_STATE, [ mode, ifthen( mode = 0, 0, Core.User.id), child ] ));
end;

function TDataManager.SetProjectObjectState(ObjectID,
  status: integer): boolean;
/// ��������� ��������� ������ ������� � ��������� ������, ���� ��������
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
        CORE.DM.DBError := lW('������ � id ' + IntTostr(ObjectID) + ' �� ���������');
        exit;
    end;

    currState := objData.FieldByName('status').AsInteger;
    objName := objData.FieldByName('mark').AsString + ' ' + objData.FieldByName('name').AsString;

    if currState = PROJECT_OBJECT_READONLY then
    begin
        CORE.DM.DBError := lW('������ '+objName+'(' + IntTostr(ObjectID) + ') � ������� ������ ��� ��������� � �� ����� ���� �������.');
        exit;
    end;

    /// ���� ����� �� ���� - ������ ����� ��������
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
/// ������� �������� ���������� ������� � ������ ����������
/// full = false - ������ ���������������� ��������
/// full = true - �������� ���� �������
///
/// ��� ���� ���������������, ��� ������� ������������ ����� ��� ����� ���������� ����
///
/// - �������� � ���������� ���� ���������������� ��������
///     - ��������� �������� ������������ ���������� � �����������
///     - ���������� ������ ����������
///     - ��� �������� ���������, �������� ������ �� ����������� ���������
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
            // ������ � ������ ��������, ����� �� ������� ������� ����������. � ��� �������� ������ ������ ����� ������

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
// ��������� �� ������� � �������� ���������� ������� � ������ ��������������
// ����� � ���, ��� ������ ������������ ����� ���� ������� ��� "�������" (�� ��������) � ������ ������
// ������� � ����������� �������������� (��������� ��� ����������) � � ��������
// �������������� ������� (����� �������), ��� ������ ��� ������������� � ������ � ������
// ������� �������. �������������, ��� �� ����������, ���� �� ����������� ����� ��������
// ��� ���������������, �� ���� � ������������� ��������� ( � ����� �������� ��
// ����������������)
begin
    result := false;

    if spec_id <> 0 then

    result := dmSDQ(
        ' SELECT mark FROM ' + VIEW_PROJECT_STRUCTURE +
        ' WHERE original_id = '+IntToStr(spec_id)+
        ' AND status <> '+ IntToStr(PROJECT_OBJECT_READONLY), '') <> '';

end;

function TDataManager.TakeDocumentToWork( doc_id: integer ): boolean;
{ ������ ��������� � ������.
  ��������������, ��� �������� (version_id) ��� �� ����� ������� ������.

  ��������:
  - �������� ������ �������� ������� ����������
  - ��������� �������� �� ������ ������������ (� ����, ��� �������� ����� ������)
  - ������� ������� ������ ��� ���������� ��������� � ����� ������� � �����������
  - ������� ��� ������� ������ �������� � ��������, ��� �������� �� ������������ � ������ ������� ��������� � ������
  - ��������� ������� ���� � ������� �����
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

    // �������� ������ ������� ������
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr( doc_id ));
    if not Assigned(query) or (query.RecordCount = 0) then goto ext;

    // ��������� ���� � �������� ����� ��� ����������� �������� � ������� ������
    GetFileFromStorage( DIR_TEMP, query.FieldByName('filename').AsString, query.FieldByName('GUID').AsString );

    // ������� ������� ������ ���������
    work_version_id :=
        CreateDocumentVersion(
            query.FieldByName('project_object_id').AsInteger,  // ������-��������
            query.FieldByName('version').AsInteger,            // �������� ������
            query.FieldByName('document_type_id').AsInteger,   // ��� ���������
            query.FieldByName('filename').AsString,            // ��� ��������� � �����������
            DIR_TEMP + query.FieldByName('filename').AsString, // ������ ��������� � ���������
            '',                                                // �����������
            query.FieldByName('is_main').AsInteger             // ������� �������� ���������
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

    // ��������� ���� �� ���� � ������� �����
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
{ ����� ��������� ������ ��������� ������ ���������.
  ��������������, ��� ��� ������� ������ ���������, ��� ���������� �������
  �� ��������� ����� ������. ���� � ��������� ���������������� � �������������
  �������� ������ (��������) ��������.

  - �������� ���� �� ������� ������ �����
  - � ��������� �������� ���������������� ������� ������� � ��������� ������ ���������
  - ����������� �������� ���� �����
  - ����� �������� ������ ������������� �� 1
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

    // �������� �� ��, ��� �� �������� ������ � ������� �������. ��������, �� ����,
    // ����������, �� ����� ����� �� ������ ������
{    if not IsWorkVersion( work_version_id ) then
    begin
        Core.DM.DBError := lW( '�������� ('+IntToStr(work_version_id)+') �� �������� ������� �������.');
        goto ext;
    end;
}
    // �������� ������ ��� �������� �����
    filename := mngData.GetVersionPath( work_version_id, true );

    // ��������� �� �������. ���� ��� ���� �������� ������ ��� ���������
    if not FileExists( filename ) then
    begin
        Core.DM.DBError := lW( '������� ���� ��������� �� ����������.'+sLineBreak+'('+filename+')');
        goto ext;
    end;

    // �������� ������ ������� ������ � ��������� ���� � ���������
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr(work_version_id) );
    if   not Assigned( query ) then goto ext;

    UpdateFileInStorage( query.FieldByName('GUID').AsString, filename );

    // �������� ������� ��� �����
    hash := mngFile.GetHash( filename );

    // ��������� ����� �������� ������ � ����
    if not dmEQ(
        BuildUpdateSQL(
            dmSQ( 'SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(work_version_id)),
            TBL_DOCUMENT_EXTRA,
            ['hash', 'minor_version'],
            [hash, query.FieldByName('minor_version').AsInteger + 1]
        )
    ) then goto ext;

    // ������������ ���� � ����� ����� ������
    UploadVersionFile( work_version_id );

    result := true;
ext:
    lCE;
end;

function TDataManager.UpdateFileInStorage(name, filename: string): boolean;
{ ����� ��������� � ��������� ��������� ����.

  ���������������, ��� Name �������� ���������� ��� ������� ���������, � ���
  ������������ � ����������� ������ ������.

  filename - ������ ���� � ������ ������ �����
}
label ext;
var
    FileStream: TFileStream;
    BlobStream: TStream;
    Query: TADOQuery;
begin

    lC('UpdateFileInStorage');
    result := false;

    // �������� ������� �����
    if Not FileExists(filename) then
    begin
        Core.DM.DBError := LE('���� '+filename+' �����������.');
        goto ext;
    end;

    // ��������� ��������� � ������ ������
    Query := Core.DM.OpenQueryEx( Format( SQL_GET_FILE_DATA, [ name ] ));
    if Not Assigned(Query) then goto ext;

    // �������� ������ �����
    Query.Edit;

    try

        // �������� ���� � ����
        BlobStream := Query.CreateBlobStream( Query.FieldByName('file_stream'), bmWrite );
        FileStream := TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
        BlobStream.CopyFrom( FileStream, FileStream.Size );

        // ��������� ������ ��� ����������� ���������� ��������
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
{ ��� ���������� �������, ��������� ������� ����������� ����������.
  ��� �������, ������������ ���� � ���� [object].[has_docs] = 1, ����� = 0 }
begin
    result := ChangeObject( id, ['has_docs'], [ ifthen( GetDocsCount(id) > 0, 1, 0 ) ] );
end;

function TDataManager.UpdateLink(tablename: string; id: integer; fields,
  values: array of variant; comment: string = ''): boolean;
/// ��������� ������� ������ ����� ��������� ����� ���������� �������������� �����,
/// ��������, ���������� ������� ������� � ��������� ���������
/// ������ ����� ��������� ������ ������ � ���� �������������� �����, ��������
/// ���������� ��������� ����� � ������
///    tablename - ��� ������� ������ "_cross"
///    id - ������ �� ���� �������, ������� ����� ���������
///    fields - ������ ����� � ������� �����, ������� ����� ������
///    values - ������ �������� � ��� �� �������, ��� � ����
///    comment - �� ������������ ����������� � ��������
begin
    result := false;

    // ������ ������� ��������� ������� � �����
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [tablename, Core.User.id, Comment, tablename, id] )) then exit;
    // ��������� ����
    if not UpdateTable( id, LNK_PROJECT_STRUCTURE, fields, values ) then exit;

    result := true;
end;

function TDataManager.UpdateProjectMark(project_id: integer): boolean;
/// ��������� ����������� ���������������� �������
/// ��������������� ��������� ����������� ��������������� � ������� �������
/// � ��� [mark] ������������ � [mark] ������� ��� ��������������� � ������ ��������
///     project_id - ������
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
/// �� id ������ ��������� ��������� ���� ��� �������� �� ������ ������������
/// � ��������� ���� �� ����
var
    dir: string;
    query: TADOQuery;
begin
    // �������� ������ ������� ���� ��� �������� �����
    dir := GetVersionPath( doc_version_id );

    // ������� ������� �����
    ForceDirectories( dir );

    // �������� ������ ��������� ������� ������
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr( doc_version_id ));
    if not Assigned(query) or (query.RecordCount = 0) then exit;

    // ��������� �������� � �����
    if not GetFileFromStorage( dir, query.FieldByName('filename').AsString, query.FieldByName('GUID').AsString ) then exit;

    // ��� ��, ��������� ��� ��������� �����, ���� �������� �����������,
    // �� ��� ����, �������� ���� � ����� � �������� ����������
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
{ ���������� ����� ������ � ��������� ������� ������
 (��� ����� �������������� �����, �����: UID, FACT, CREATED)
  ����� �������� ����������� ������� �������� ������ � �������.
  ��� ����������� - ��� ������������ � ����� � ��������� �� ���������� �������
  ����� �������� ������ ���������� ���� ���������� ��������.

  tablename - ��� �������, � ������� ����� ����������� ������ (��������� ��� ��������)
  parent, child - id ����������� ��������
  uid - id ������������ � �������� ����� ��������� ���������. ���� �� �������,
        ������������� ������� ������������. ��� �������� 0, ������ ����� ���������
        ��������� � ������������ �� ������ �� �������������

  �����!
  ������� �������, ��� ��� ���������� ������ ��������� ������� ��� � ���������������
  ������ ��� ���� ������ ������� CreateCrossLinks
}
label ext;
begin
    lC('TDataManager.AddLink');
    result := 0;

    // ������ �� ����� ���� ����������� ��������
    if parent = child then exit;

    // ���� �������� ����� ��� ���� - ��������� ��� ��� ����
    result := PresentLink( parent, child, Tablename );
    if result <> 0 then goto ext;

//    if dmSDQ( Format( SQL_SELECT_LINK_ID, [TableName, parent, child] ), 0 ) <> 0 then goto ext;

    // ������� ����� �����
    result := dmIQ( Format( SQL_ADD_LINK, [TableName, parent, child, ifthen(uid <> -1, uid, Core.User.id) ] ));

ext:
    lCE;
end;


function TDataManager.DeleteLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
{ ������ �������� ����� ��� ������, ����� �������� ee id }
begin
    result := DelLink( TableName, id, mode, comment );
end;


function TDataManager.DeleteLinkBy(TableName: string; parent, child: integer; comment: string = ''): boolean;
// ������ �������� ����� ��� ������, ����� �������� ������ ��������-�������
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

    // ������ ������� ��������� ������� � �����
    if to_history then
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TBL_OBJECT, Core.User.id, Comment, TBL_OBJECT, id] )) then goto ext;

    // ������� �� ���������� �������
    if not dmEQ( Format( SQL_DELETE_LINK_BY_ID, [TBL_OBJECT, id] )) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.DoneProject(ProjectID: integer): boolean;
/// ����� ��������� ��������� ������. ������ ������� ��������� � �������
/// ��������� ������� ([projrct_object], [project_structure])
/// � ������������� ([object], [stucture]). ��� ���� ������������ ���������
/// ������: ��������, ���������, ����������.
///
/// � ������� ������ ProjectID �������� �����������, ������� ���������� � ��
/// ��� ���������� ������ �������.
///
/// ���������������, ��� ��� ��������������� ������� ����������, � ���������
/// �� ��������� � ��������������.
///
///     �������
///     ��� ����������, ��������� ����� � [object]
///     ��� �������, ������� ������������ ������ � ����� � ���������� ������� �� �������
///
///     �����
///     ��� ���������� ����������� ������ ������� ������ (�� ������� ���������
///     ��������� ������ � �.�., ���������� � ������������), ��������� ��� ��������
///     ���������������� � ����� � ������ ���������� ���� �������.
///     ��� ������������ ������������� ����������� ����� � ������������ � ������
///     ������ ������������
///     �������� ��������:
///         ��������� ����� � ����� ��������
///         ��������� ����� � ������������ ��������
///         ������� ����� � ������������ ��������
///         (�������� ����� � ����� �������� �������. ��� �� �������� � ������� ��������)
///
///     ���������
///     ��� ������� ������ ������� ��������� ���������� ��� ���� �� ����� ��������
///     ��� ������������� �������� ������ ��, ������� �����������
///
///     ��������
///     ��������� ��������
///       - �������� �� ���� ��������� �������
///         - �������� ����� �������
///           - ��� �������� ������ ������� � ������� �������� ������ -1 (���������� ��������������) (�������������)
///         - ��������� ������ ��� ������������� �������
///       - ���������� �� �������� ������ � ������������� ��������� � �������� id ��������
///     ��������� ������
///       ������ ���������
///       - �������� �� ���� ������ �������������(��) ��������� ��������� ��������
///         (��������� ������ ����� ���������� ������ � ����� ������ �������� ���������)
///       - ���� � ��������� ������� ���� ��� ���� ������� � ��� ����� ����� ����
///         (��� �������� �������, ���� ����� ��������������, �� ����� ������������
///          ������� � ������� ����, ��������, ������������� ������ � �������)
///          - ������� ����� �� ������������� ���������
///          - ������� ��� �������� ��� ������ ������
///       ��������� �����
///       - �������� �� ������ ������� (�� ������ ������ � ���� �������� ���� �������� id)
///          - ���� ��� ���� �������� ��� ����� � �������������
///            - ������� ������
///            - ��������� �� id ��� ���������� ��������� ���������
///       - ������� ��������
///     ���������
///       - ��� ������� ������� ��
///          - �������� ������ ���������� ����� ����� � ������� � ����������
///          - ���� ����������� � ������� � �� - ���������
///          - ���������� ������ ���������� ������� � �� � ���������� �� ������� �����
///          - ���� �������� ���������� � ������ ����� - �������
///            (��� ����, ������� ���������� ������ ������ � ����� � ����� � ��������� �� ���������)
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
    dsProjectObjects    // ��� ������� �������
   ,dsRootElems         // �������� ������� �������. �� ��� ���������� ����� ��������� �� � ������� ��������
   ,dsKDObjects         // ��� ������� �� ������� ��������� � �������
   ,dsProjectLinks      //
   ,dsKDLinks           //
   ,dsProjectObjectDocs // ��������� ����������� � ������� � �������
   ,dsKDObjectDocs      // ��������� ����������� � ������� � ��
   ,dsKDDocExtra
   ,dsProjectDocExtra
            : TADOQuery;
    arr : array of TElem;
                       // ������ ��� ������������� �������� ������� � ��
                       // �������� id ��������� � ������ �������� ��������
                       // � id ��������� �� ��� ����������� � ��.
                       // ����� ���������� ������������ ��� ���������� ������
                       // � �� �� ������� ������� (��� ����������� ������ id
                       // �������, �������� id)

    lnkArr: array of integer;
                       // ������ ����������� � �� ����� ������. ������������
                       // ��� ��������� �������� ���������, ����� ���������� ����
                       // ������

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
   ,doc_id             // �������� id ������ �������-��������� ����� ����������� ��� �� ������� � ��
            :integer;
    hasLink : boolean;

    function GetProjectID( KDID: integer ): TArr;
    // �� id �� �� ������� ����� � ������� � ���������� �� id (� �������)
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
    /// ����� id ������������� ������� � ������� �� ��� id � �������
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
    /// ���� ���� �� ������ ���������� �������� � ��������� �������
    var
        i, j: integer;
    begin
        result := 0;

        // ���� ��������� ������-�������� �� id � ����
        for I := 0 to High(arr) do
        if arr[i].kdID = parent_kd_id then
        begin
            // ���� ��� ������ �� ������������� ����������� - ���� ���� �� ��������
            if arr[i].status <> status then
            begin

                // �� �������� �������� � ������ ������� ������� ���� ������
                // � �������� ���������� ��� ����������� �������
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
            // ����� ���������� id ����� �������� ��� �������� ������ �������
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

    /// ��������, �������� �� ���������� ������ ��������������� ��������.
    /// �������� �������, ��� ��� ��������� ����� ��� �������� � ��,
    /// ����� ������ � ������� ��������� �������� ������� ��������.
    /// ���� �������� � ��� ������, � �� ������ ��� �������
    if dmSQ('SELECT kind FROM '+TBL_PROJECT+' WHERE id = '+IntToStr(ProjectID)) = KIND_PROJECT then
    begin

        /// �������� ��� ������� ������� (����� ����������)
        dsProjectObjects := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child in (SELECT child FROM ' + LNK_PROJECT_STRUCTURE_CROSS + ' WHERE parent = ' + IntToStr(ProjectID) + ')' );
        if not Assigned(dsProjectObjects) then goto ext;

        // �������� �������� �������(-�) �������. �� �������� ������ �������� � ��������� ��
        dsRootElems := CORE.DM.OpenQueryEx(
            ' SELECT original_id, child FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE parent = ' + IntToStr(ProjectID){ + ' AND original_id IS NOT NULL'} );
        if not Assigned(dsRootElems) then goto ext;

        // �������� ������� ��� ������� �� ��
        // ���� ������� id �������� �� ��, ������� ��������������� ��������� � ������� �������
        // � �������� ��������� � ������������ ������ �������
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

        // ���������� ������� ��������� ��� ����������� � ������ ��������
        UpdateTable( ProjectID, TBL_PROJECT, ['icon'], [KIND_ARCHIVE]);

    end else
    begin

        /// �������� ��� ������� ������� (����� ����������)
        /// � ������ ������, ������ � ����� ���������� ��������, �������� ��� ���� ����� ������ � ��
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

        // �������� id ����������� ��������� ������� � ��
        dsRootElems := CORE.DM.OpenQueryEx(
            ' SELECT original_id, child FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE child = ' + IntToStr(ProjectID){ + ' AND original_id IS NOT NULL'} );
        if not Assigned(dsRootElems) then goto ext;

        rootKDID := dsRootElems.FieldByName('original_id').AsString;

    end;

{
    /// �������� ��� ������� �� (����� ����������)
    if rootKDID <> '' then
    dsKDObjects := CORE.DM.OpenQueryEx(
        ' SELECT * FROM ' + TBL_OBJECT +
        ' WHERE id in (SELECT child FROM ' + LNK_STRUCTURE_CROSS + ' WHERE parent in (' + rootKDID + '))');
    if not Assigned(dsKDObjects) then goto ext;
}


    /// ��������� ��������
    /// ���������� ������� �������
    while not dsProjectObjects.Eof do
    begin

        /// ����� � ������� ������ ������ �������
        SetLength( arr, Length(arr) + 1);
        arr[high(arr)].prjParent := dsProjectObjects.FieldByName('parent').AsInteger;
        arr[high(arr)].prjChild := dsProjectObjects.FieldByName('child').AsInteger;
        arr[high(arr)].kdID := StrToIntDef(dsProjectObjects.FieldByName('original_id').AsString, 0);
        arr[high(arr)].status := dsProjectObjects.FieldByName('status').AsInteger;
        arr[high(arr)].kind := dsProjectObjects.FieldByName('kind').AsInteger;
        // ���������� ��� �������, ��������� ��������� (kind=12) ������� �������� ���������
        // �������� �� ����� �������� ������

        // ���� ������ ����������� � �� � � ������� ����������
        if ( arr[high(arr)].kdID = 0 ) AND
           ( dsProjectObjects.FieldByName('status').AsInteger = STATE_PROJECT_READY ) then
        begin
            // ������� �����
            arr[high(arr)].kdID := mngData.CopyObject( arr[high(arr)].prjChild, 0, TBL_PROJECT, TBL_OBJECT);

            if arr[high(arr)].kdID = 0 then goto ext;

            // ���������� ��������� ����� id ���������� �� �� ������� ��������� � ��
            // ��� �������� �� ��������� ���� ����� ��� ��������� ������� ������� � ��:
            // �������� ������� ����� ���� �������� �������, � �� �������
            UpdateTable(
                Integer(dmSQ( 'SELECT id FROM ' + TBL_PROJECT_OBJECT_EXTRA + ' WHERE parent =' + IntToStr(arr[high(arr)].prjChild) )),
                TBL_PROJECT_OBJECT_EXTRA,
                ['original_id', 'status'],
                [arr[high(arr)].kdID, STATE_PROJECT_DISABLED]
            );

            /// ������� ���� ���������� � ����������� � ����� �������
//            UnlinkEditorsFromObject( arr[high(arr)].prjChild );
//            UnlinkCheckersFromObject( arr[high(arr)].prjChild );
               // �� �������, ����� �������� ����� ���������� � ���, ��� � �������� �������
               // ����� �������� ������� �� � ������� ������

        end else

        if ( arr[high(arr)].kdID <> 0 ) then
        begin
            // �����, ��������� ������ � ��������� ����������� ��������� � �����
            // ���� ������ �������� ��� �������������� � ������ ��� ��� ���������
            if dsProjectObjects.FieldByName('status').AsInteger = PROJECT_OBJECT_DONE then

            // ������� �������, ������ �������� ���������������� (����� �� �� ��� ������
            // ������� � �� ���� ���� ��������)
            if ( dsProjectObjects.FieldByName('status').AsInteger <> PROJECT_OBJECT_READONLY ) and
            //  � ��� ��, �� �������� �������� ������ �� �������� � ����� �������� (��� �� ��������� �
            // � �������� �������)
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


        // ��� ���������� ���������� ������� ������� �������� � ����� �������-���������
        // � ������������� ���������, ���� ������� ������ ��� ��� (��� ������, �����
        // �������� �� ��� ���������� �� ������������� ��������� ��, � ��� ������ � ������
        // �������

        // �������� ������ ���������� �������� �������
        dsProjectObjectDocs := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_DOCUMENT_PROJECT +
            ' WHERE project_object_id = ' + IntToStr(arr[high(arr)].prjChild)
        );

        /// ������� ��������� ��� ��������� � ������� � �������� �� �������
        /// � ��. ��� ��������� - ��������
        if Assigned(dsProjectObjectDocs) then
        while not dsProjectObjectDocs.eof do
        begin

            // �������, ���� �� ������ ������� ��������� �� ������ ��������� � ��
            // ��� ������� ��������� � �������
            if dsProjectObjectDocs.FieldByName('doc_id').IsNull and
               not dsProjectObjectDocs.FieldByName('project_doc_id').IsNull then
            begin
                // �������� ������-�������� � ��
                doc_id := mngData.CopyObject(
                    dsProjectObjectDocs.FieldByName('project_doc_id').AsInteger, 0, TBL_PROJECT, TBL_OBJECT );

                // ��������� ������ �� ��������� ��������� � ��
                mngData.UpdateTable(
                    dsProjectObjectDocs.FieldByName('doc_extra_id').AsInteger,
                    TBL_DOCUMENT_EXTRA,
                    ['object_id', 'doc_id'],
                    [arr[high(arr)].kdID, doc_id]
                );
            end;

            dsProjectObjectDocs.Next;
        end;


        // �������� ������ ���������� �������� �������
        dsKDObjectDocs := CORE.DM.OpenQueryEx(
            ' SELECT * FROM ' + VIEW_DOCUMENT_KD +
            ' WHERE object_id = ' + IntToStr(arr[high(arr)].kdID)
        );

        /// ������� ��������� ��� ��������� � ������� � �������� �� �������
        /// � ��. ��� ��������� - ��������
        if Assigned(dsKDObjectDocs) then
        while not dsKDObjectDocs.eof do
        begin

            /// ���� �������� ����������� � ��, �� � ������� ������ -
            /// ������� � ��
            /// ��� �������� ��������� � �������, ��������� ������-�������� �� �������
            /// � ������������ ������ �� �������� � ������ � ������� � ������� �� ��� ��������
            /// �.�. �� project_doc_id = null � project_object_id = null �����
            /// ������, ��� �������� ������ � ������ �������
            if not dsKDObjectDocs.FieldByName('doc_id').IsNull and
               dsKDObjectDocs.FieldByName('project_doc_id').IsNull then
            begin
                /// ������� ������ ��������� c ���������� � ������
                DeleteObject( dsKDObjectDocs.FieldByName('doc_id').AsInteger, '' );

                /// ������� ���� ��������� ���������, ��������� � ��� ������ �� ���������
                /// ���������� �� � �� �� � �������
                dmEQ(' DELETE FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE doc_id = ' + dsKDObjectDocs.FieldByName('doc_id').AsString );
            end;

           dsKDObjectDocs.Next;
        end;


        dsProjectObjects.Next;
    end;



    /// ��������� ������
    /// ���������� ��� ����� ��, ��������� ��������� � �������

    // �������� ��� ����� �������
    dsProjectLinks := CORE.DM.OpenQueryEx(
        ' SELECT * FROM ' + LNK_PROJECT_STRUCTURE + ' WHERE id in (' +
          ' SELECT DISTINCT base_link FROM ' + LNK_PROJECT_STRUCTURE_CROSS +
          ' WHERE parent = ' + IntToStr(ProjectID) +
        ')'
    );

    // �������� ��� ����� ���� ��������� ��������� � ��������������� ������� ��
    if rootKDID <> '' then
    dsKDLinks := CORE.DM.OpenQueryEx(
        ' SELECT * FROM ' + LNK_STRUCTURE + ' WHERE id in (' +
        ' SELECT DISTINCT base_link FROM ' + LNK_STRUCTURE_CROSS +
        ' WHERE parent in (' + rootKDID + '))'
    );


    /// ���������� ����� �� � �������� ����� ��������� � �������
    /// - �������� ������ �� ��
    /// - �� arr[] ������� id � ������� ��� parent � child ������ (� ��������)
    /// - � ������� ������� ���� ����� ��������� parent � child (� ��������)
    /// - ��� ��������� - ������� ������ �� �� (���������� � �����)
    if Assigned(dsKDLinks) then
    while not dsKDLinks.eof do
    begin
        aParent := GetProjectID(dsKDLinks.FieldByName('parent').AsInteger);
        aChild  := GetProjectID(dsKDLinks.FieldByName('child').AsInteger);

        /// ���� ������� � ������� ����� ������ ����������������, �� ��� ����������
        /// ��� � ������ ��������� � ���� �������� �� ���� ����������� �� ������������� ���������
        /// ����� �� ������� �� ��������� �� ��������� � ������ ������� � �� ��������� ��
        /// � ��, ������ ���������� ��������� ������ ����� ��������, ��� ���� ���������
        /// ��������� ������ �� ������ � ������ �������, �� � � ���� ���������
        if (GetStatus(dsKDLinks.FieldByName('child').AsInteger) <> PROJECT_OBJECT_READONLY) and
           (HasParentsStatus(dsKDLinks.FieldByName('parent').AsInteger, PROJECT_OBJECT_READONLY) = 0) then
        begin

            hasLink := false;

            // ���� ��������� ������ � ������� ����� ���� � ���������,
            // ������ �������� ��� ������ ����� ����
            if (Length(aParent) > 0) and (Length(aChild) > 0) then
            for p := 0 to High(aParent) do
            for c := 0 to High(aChild) do
            begin
                dsProjectLinks.First;
                if dsProjectLinks.Locate('parent;child', VarArrayOf([aParent[p], aChild[c]]), []) then
                begin
                    hasLink := true;

                    /// ���� ���������� ����������, ���������
                    if dsProjectLinks.FieldByName('count').AsFloat <> dsKDLinks.FieldByName('count').AsFloat then
                    UpdateTable( dsKDLinks.FieldByName('id').AsInteger, LNK_STRUCTURE, ['count'], [dsProjectLinks.FieldByName('count').AsFloat] );

                    break;
                end;
            end;

            if not hasLink then
            begin
                /// ����� ������ � ������� �� ����������, ����� ������� �� ��
                mngData.DeleteCrossLinks( LNK_STRUCTURE, dsKDLinks.FieldByName('id').AsInteger );
                mngData.DeleteLink( LNK_STRUCTURE, dsKDLinks.FieldByName('id').AsInteger, DEL_MODE_NO_CROSS );
            end;

        end;

        dsKDLinks.Next;
    end;



    /// ������ ��������� ����� ������, ��������� � ������ �������
    /// - �������� ������ �� �������
    ///     - �� arr[] ������� id � �� ��� parent � child ������
    ///     - � ������� �� ���� � ����� ���������� ��������
    ///     - ���� ���, ���������, ��������� ��� �������� ���������
    /// - ����� ����������� ���� ������ �������
    ///     - ������� ������� ��� ���� ����� ������
    dsProjectLinks.First;
    while not dsProjectLinks.eof do
    begin
        aParent_ := GetKDID(dsProjectLinks.FieldByName('parent').AsInteger);
        aChild_  := GetKDID(dsProjectLinks.FieldByName('child').AsInteger);

        // � ������, ����� ������ ��� ������ ��� �������� � �� ������������ ���� ���������
        // ��������� ������, �������� ��� � ����, ��� ������� � �� ����������� �
        // ����� ������������
        if   aParent_ = 0
        then aParent_ := GetObjectBy( 'name', SECTION_SPECIF, IntToStr(KIND_SECTION));

        /// id ������� ������������
        /// ���� ������ � ��...
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
                /// ����� ������ � �� �� ����������, ����� ���������
                SetLength(lnkArr, Length(lnkArr)+1);
                lnkArr[High(lnkArr)] := mngData.AddLink( LNK_STRUCTURE, aParent_, aChild_ );

                /// ���������� ����������
                UpdateTable( lnkArr[High(lnkArr)], LNK_STRUCTURE, ['count'], [dsProjectLinks.FieldByName('count').AsFloat] );
            end;
        end;

        dsProjectLinks.Next;
    end;

    /// ������ �������� �� ���� ����� ������
    for I := 0 to High(lnkArr) do
       mngData.CreateCrossLinks( LNK_STRUCTURE, lnkArr[i] );


{$IFNDEF test}
    // ���������� ������� ���������� �������
    if not dmEQ( Format( SQL_SET_PROJECT_STATUS, [PROJECT_DONE, ProjectID]) )then goto ext;

    // ��������� ����������
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
/// ����� ������� ��������� ������, ������ �� ���� ��������.
/// �������������� ���������� ������� �� ��������������.
///    projectID - id ������� ������� � ������� [project_object]
begin
    result := dmEQ( Format( SQL_DELETE_PROJECT, [ProjectID]) );
end;

function TDataManager.DelLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
{ �������� ������ ����� � �����, �������� �������������� ����:
  id ������������ ���������� ���������, ���� ���������, �����������
  ������������� ������������ � ������� �������������� ������

  TableName - ��� ������� ������, � ������� ��������, ��������: 'navigation', 'structure'
  id - ������ � ��������� �������
  mode - ����� �������� ������. ���������, ���� �� ���� ���������� �������
  comment - ��������� �������� ��������

  �������� � ������ �������
  - ��������� ������ ���������� ������ � �������� ��������� ���� ��������� ������
    ��������� ����� �� ������ ����������, ������� ��������� �������� ��� ����������.

  �������� � ������ ���������
  - ��������� ������� ����� ������ ���� �������� � ��������� ��� ����� ������
    ���� �� ��������, ��� �������� ������ ��������� ��� ��������� �� ����� ����������
    ��� ���������� ���������� ������, ��������������, ��� ������������ ��������������
    ���������� �� � ������ �����.

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


    // ��������� ������, ���� �����
    if mode and DEL_MODE_NO_HISTORY = 0 then
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TableName, Core.User.id, Comment, TableName, id] )) then goto ext;

    // ������� ������� �����
    if not dmEQ( Format( SQL_DELETE_LINK_BY_ID, [TableName, id] )) then goto ext;

    // ���� �� ��������� ������������ �������������� ������
    if mode and DEL_MODE_NO_CROSS = 0 then
    begin
        if not DeleteCrossLinks( TableName, id, comment ) then goto ext;

        // �������� ������ ���� �������� �� ��������� ����������
        subchilds := Core.DM.OpenQueryEx( Format( SQL_GET_ALL_SUB_CHILDS_BY_CROSS, [ TableName, id ] ));
        if not Assigned( subchilds ) then goto ext;

        while not subchilds.eof do
        begin
            // ���������� � ������� ��������� ������
            if not DeleteCrossLinks( TableName, subchilds.Fields[0].AsInteger, comment ) then goto ext;

            uid := Integer(dmSQ( Format( SQL_GET_LINK_UID, [ TableName, subchilds.Fields[0].AsInteger ] )));

            // ���� ����� ���������� �����������
            // ���� ����� �������� ���������������� � ��� ���������������� ������
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

            // ��� ���������� �������� ������ ������������� ����� ��������������� ������ ���������
            if mode = DEL_MODE_SINGLE then
            if not CreateCrossLinks( TableName, subchilds.Fields[0].AsInteger ) then goto ext;

            subchilds.Next;
        end;

    end;

    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.CommitTrans;

    result := true;

ext:
    // ��� ��������� �������� ���������� ����� �������
    if   Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
end;

function TDataManager.AddObject(fields: string; values: array of variant; tablename: string = ''; custom_only: boolean = false): integer;
{ ����� ������� ����� ������ � ���������� ��� id
  fields - ������ �������� ����� ����� ������� ��� ������� ������������� ������
  values - ���������� ������ �� ���������� ��� ����� �� fields, ������ � ��� �� �������
  tablename - ������������� ������� �������� ��������
  custom_only - ���� ����������, � ������ ����� �� ����� ����������� uid � created ����,
               ��� �������� �������� ������ � ����� �� ������������������ �������
}
var
    val: string;
begin
    lC('TDataManager.AddObject');
    try
        result := 0;

        lM('fields = ' + fields);

        // �������� �������� ��� ����� � ������
        val := ArrToString(values, true);
        lM('values = ' + val);

        if not custom_only then
        begin
            // ����������� ������ ��� ������������ �����, ���� ��� �� ���������
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

        // ������� ������
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
{ ����� ������ ������ �������, �������� ���������� ������ � ������
  Fields, Values - ���������� ������������ ������. ����� ����� � �������� � ��� �� ������� ��� � � Fields
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
{ ����� ������ ������ �������, �������� ���������� ������ � ������
  Fields, Values - ���������� ������������ ������. ����� ����� � �������� � ��� �� ������� ��� � � Fields
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
        lE('�� ��������� ���������� ����� � ���������� ��������');
        goto ext;
    end;

    // ���������, �� ��������� �� ����� ����� �������� � �������, ����� �� �������� ������
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

    // ���� ����������� � ������ �������� ��������� � ���������� �� ���������?
    if not identity then
    begin

        // ������ ������� ��������� ������� � �����
        if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [tablename, Core.User.id, Comment, tablename, id] )) then goto ext;

        // �������� ���������� ���������
        // � ��������� ������ �������
        if not dmEQ( BuildUpdateSQL( id, tablename, Fields, Values ) ) then goto ext;

        result := true;

    end;
ext:
    lCE;
end;


function TDataManager.CheckLinkAllow(child_kind, child_subkind, child_status,
  parent_kind, parent_subkind, parent_status: integer): string;
// �������� �� ����������� �������� ���� �������� ���� � �����, ������ ��
// �� ����� � �������� �������� �������. ���������� ������ � �������� ������,
// ���� �������� �����������.
// child_kind, parent_kind - �������� ���� [kind] �������
// child_subkind, parent_subkind - �������� ���� [icon] �������
// child_status, parent_status - �������� ���� [status] �������, ���� ����
//                               �������� �� ��������� �������� PROJECT_OBJECT_���

begin
    result := '';

    if   parent_status = PROJECT_OBJECT_READONLY
    then result := '������ ������ ��� ���������, �������� ����������.';

    // ����� ���������������, ��� �������� �������� ��� �������������� � ����� �����
    // ���� �� �������� ������ ����������: �� � ������, � ������, � ��������, � ��������, ��������

    if   parent_status <> PROJECT_OBJECT_INWORK
    then result := '������ �� ��������� � ������ ��������������.';

    // ����� �������� �� �������, ��������� ������ �� ����� ����� ��������

//    if   ( parent_subkind = KIND_SPECIF ) and
//         ( child_subkind <> KIND_ISPOLN )
//    then result := '� ������������ ����� ���� ��������� ������ ����������.';

    if   ( parent_kind in [ KIND_DETAIL, KIND_STANDART, KIND_OTHER, KIND_MATERIAL ] )
    then result := '�������� � ������, ���������, ������������ ��� ������� ������� �� ���������.';

    if   ( parent_kind in [ KIND_COMPLECT, KIND_ASSEMBL ] ) and
         ( child_kind = KIND_COMPLEX )
    then result := '�������� ��������� � ��������� ������� ��� ��������� �� ���������.';

end;

function TDataManager.ChangeLinkParent(TableName: string; id, parent_id: integer;
  comment: string): boolean;
{ ����� ������������ ��������� �������� � ������.
  ��������� ����������� �������� ������ ���� ����������� � ������� child.

  tablename - ��� ������� ������
  id - ������ � �������
  parent_id - ����� ������-��������

  ��������:
      1. ������� ��������� ������ ������������ � �����
      2. ����������� parent
      3. ��� ������ ������������ ����� ��������������� ������
      4. ��� ������ �������� ����� ��������������� ������
      5. �������� ���� child ���� ������� ��� ���� ������
      6. ��� ������� ����������� child ���������� �.�.4, 5
}
label ext;
var
    query: TADOQuery;
begin
    lC('TDataManager.ChangeLinkChild');
    result := false;

    // 1. �������� � ����� ������� ��������� �����
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TableName, Core.User.id, Comment, TableName, id] )) then goto ext;

    // 2. � ��������� ������ �������
    if not dmEQ( BuildUpdateSQL( id, TableName, ['parent'], [parent_id] ) ) then goto ext;

    // 3. ��� ������ ������������ ����� ��������������� ������
    if not DeleteCrossLinks( TableName, id, comment ) then goto ext;

    // 4. �������� ����� ��������������� ������
    if not CreateCrossLinks( TableName, id ) then goto ext;

    // 5. �������� ������ ���� �������� �� ��������� ����������
    query := Core.DM.OpenQueryEx( Format( SQL_GET_ALL_SUB_CHILDS_BY_CROSS, [ TableName, id ] ));
    if not Assigned( query ) then goto ext;

    // 6. ���������� ��������� ���� ��������
    while not query.eof do
    begin

        // ��� ������ ������������ ����� ��������������� ������
        if not DeleteCrossLinks( TableName, query.Fields[0].AsInteger, comment ) then goto ext;

        // �������� ����� ��������������� ������
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
{ ����� ������������ ��������� ������� � ������.
  ��� ������� ����� ��� ����� ��������� �������, ��� ����� ���� ��� ���������,
  � ��� ���� ��������� ������ ��� ����� �������� ����� ��������.

  tablename - ��� ������� ������
  id - ������ � �������
  child_id - ����� ������-�������

  ��������:
      1. ������� ��������� ������ ������������ � �����
      2. ����������� child
      3. ��� ������ ���������� ��� ���������������� �������
      4. ��� ������� ������� ������������ ������ �������� � ����������� ������
      5. ��� �� ����������� ������ ���������� ��� ���� �������� �������� ��������������
}
label ext;
var
    query: TADOQuery;
    parent : integer;
begin
    lC('TDataManager.ChangeLinkChild');
    result := false;

    // �������� �������� child ��� ����������� ������ ���������������� ������-��������
    if not dmOQ( Format( SQL_SELECT_LINK_DATA, [ TableName, id ] )) then goto ext;
    parent := Core.DM.Query.FieldByName('child').AsInteger;

    // 1. �������� � ����� ������� ��������� �����
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TableName, Core.User.id, Comment, TableName, id] )) then goto ext;

    // 2. � ��������� ������ �������
    if not dmEQ( BuildUpdateSQL( id, TableName, ['child'], [child_id] ) ) then goto ext;

    // 3. ���������������� �������
    query := Core.DM.OpenQueryEx( Format( SQL_GET_CHILDS, [TableName, parent] ));
    if not Assigned( query ) then goto ext;

    // 4., 5. ��������� ���� ��������, ������ � �����������
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
{ ����� �������� �������� ���������, ������� ������� ��������������� ������
  ��� ��������� �����.
  ��������������, ��� ��� ����������� �� ������ ������. �������� �� ������������
  ��������������� ������ ����������.
  ��� ��, �������� ��� ������� ����������� ������ �������� �������� ��� ������
  ������. � ������ ������ ��������� ����� ��� ��������� ������ � ���������� ��
  ��������.

  TableName - ��� ������� ������ � ������� ���� ������
  id - ������ ��� ������� ��������� ���������, �� �� �� CHILD ���� ���� ��������
  rebuild_sublinks - ����� ��������� ��� �����, ������� ��������� �� ��� � ������ (��� �����)
               � ��� ������ �� ��� ����� ������� ���������)
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

    // �������� �������-������ �� id ������
    procedure GetChildLinks( id: integer );
    var
       i : integer;
       present: boolean;
    begin
        if not dmOQ( Format( SQL_GET_CHILDS, [ TableName, id ] )) then exit;
        while not Core.DM.Query.Eof do
        begin
            // ���������, ��� ��� ������ ����������� � �������, ����� ����� ����� � ���������
            present := false;
            for i := 0 to High(arr) do
            if arr[i].link_id = Core.DM.Query.FieldByName('id').AsInteger then
            begin
                present := true;
                break;
            end;

            // ��������� � ������� �� �������� ���������
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

    // �� child ������ ���� ��� ������, ������� ��������� �� ���� ��� �� ��������
    dmOQ( Format( SQL_SELECT_LINK_DATA, [ TableName, id ] ) );
    child_id := Core.DM.Query.FieldByName('child').AsInteger;

    // ������� ��������� ��� ��������� ������
    if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [TableName, id, id, child_id] )) then goto ext;

    // ������������ ���� �������� ��� ��������� ���������� ��������
    // �� ������������� ��� �������� �������� ���������, ��������� �������� �
    // �������� �������� ��-�� ������������ ��������.
    if rebuild_sublinks then
    begin

        // �� child ������ ���� ��� ������, ������� ��������� �� ���� ��� �� ��������
        dmOQ( Format( SQL_SELECT_LINK_DATA, [ TableName, id ] ) );
        child_id := Core.DM.Query.FieldByName('child').AsInteger;
        GetChildLinks( child_id );

        // ��������� ������, ��������� ��� ��������� ��������������� ������
        // ��� ���������� �������� ������� ����� ������� ����� id ���� ������-��������
        // �������� ������
        if Length( arr ) > 0 then
        begin

            i := 0;
            while i <= High(arr) do
            begin
                GetChildLinks( arr[i].child );
                Inc(i);
            end;

            // ���������� ���������
            for i := 0 to High(arr) do
            begin

                // ���������� � ������� ������� �������� ������
                if not DeleteCrossLinks( TableName, arr[i].link_id ) then goto ext;

                // ������� ��������� ��� ��������� ������ ��� � ������ ����� ��������
                if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [ TableName, arr[i].link_id, arr[i].link_id, arr[i].child ] )) then goto ext;

            end;
        end;
    end;

    result := true;
ext:
    lCE;
end;

function TDataManager.CreateDocumentVersion(object_id, version, doc_type: integer; name, filename, comment: string; is_main: integer = -1): integer;
{ ���������� ������ ��������� � ���� � ��������� � ���������� �������.

  �����! �� ����������� ������� ������� ��������� � �������� � ������ ��������-��������,
  ��� ������ ������������� �� ������ ������� ������, ��������� ��������� �����������
  ���� ������� ������������ ������ ��������� ��� ������ �������, ���� ����� ������������
  ������ � ������ ����������� �������.

  ��������, � ����������� ������, ������ �������� ������������ �������� � ��������
  ��������� �������� � ������������� ������� ������� '-01', '-02' � �.�., ��
  ��� ����, ������ ���������� ��������� � ������ � ���� �� �������.

  � ������ �������� ������������, ������ ������� ����� ���������������� �� ���� �����������.

  ��� �������������� �������� � �������-�������, ������ ����� ������� � ������ ����������� �������
  � ������ ����� ����� � ����� ������ ����� ������ � ������� ��������� ���������. ������, ��� �����
  �������� � ��������� ����������� ������� ������ ��� ������ �� � ������ � ������ ����������,
  ��������� ��� �������� � �� �������� ���������� � �������� ������ �� ��������� ������ ������������.
  ��� ��, �������� ����������� ���� ������ � �������� ��������� ��������� � �����
  ������� � �������� �������������� ������������ ��������� ����� � ������

  object_id - ������, � �������� ������������� ����� ��������
  version_id - ������ ���������, ����������� ������� ��� ���� ����� ������.
  doc_type  - ��� ���������. id �� �������-����������� document_type
  name      - ��� �����, ������� ����� ��������������� ��� ������ ������ [PDM].[Document_extra] � [FilesDB].[PDMFiles]
  filename  - ������ ���� �� �����
  is_main - ������� ����, ��� ��� �������� ��������. ��������� �� ����� ��������� �������� ��� �������� ����� ������
             0 = �� �������� ��������
             1 = �������� ��������
             -1 = �������������� ��������� 1, ���� ��� ������ ����������� ��������

  ��������
  - ������� ����� ������ ���� �������� � ������� object
  - ������� � ����������� � ���� ������ � ���������� � ������� document_extra
  - ��������� ��������� ���� � ��������� [FilesDB].[PDMFiles]
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

    // ���������, ���� �� ��� � ������� ������� ����
    if is_main = -1 then
    begin
        if HasMainDoc( object_id )
        then is_main := 0
        else is_main := 1;
    end;

    /// �� ������� ��� �����, ���������� ���� �� ����������
    if   doc_type = 0
    then doc_type := mngFile.GetFileType( ExtractFileExt( ExtractFileName( filename ) ) );

    // ����� ������ ���������
    doc_id := AddObject('kind, name, comment, icon', [ KIND_DOCUMENT, name, comment, doc_type ]);
    if doc_id = 0 then goto ext;

    // ����������� �������� � �������
//    if AddLink( LNK_DOCUMENT_OBJECT, object_id, doc_id ) = 0 then goto ext;

    // ������ �������-������� ������� ������� ����������� ����������
    ChangeObjectEx( TBL_PROJECT, object_id, ['has_docs'], [1] );
    ChangeObjectEx( TBL_OBJECT, object_id, ['has_docs'], [1] );

    // ������������ � ������� ������
    lastFullVersionNumber := '';

    if version = 0
    then lastVersionNumber := GetNextVersionNumber( ExtractFileName(filename), object_id )
    else lastVersionNumber := version;

    // ���������� ��� � ������ ������ ������ � �������� ��� ��������� �����
    CreateGUID(GUID);
    fullname := GUIDToString(GUID);

    // ��� ����� ����� ��� ������������ ������� ��������� ��� �������� ����� ������ �� ������
    hash := mngFile.GetHash( filename );

    // ������� ������ � ��������������� ������� ���������
    if not dmEQ( Format( SQL_CREATE_DOCEXTRA, [doc_id, object_id, lastVersionNumber, name, doc_type, fullname, hash, is_main] )) then goto ext;

    // ��������� ���� � ���������
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
/// �������� ������ ������� ��� ����������� ������� (������������)
/// name        - ���������������� ��� �������
/// comment     - ����������� � �������
/// mark        - ����������� ������� ������������ ��� ������� � ������ �������
/// parent_prod_kod - ����������� ������������� ������� ���� ���������
/// prod_kod    - ����������� ������������ ���� ��������� � ������� ��������� ������
/// objectId    - ������-������������, ���� ����, ���� ��������� ������ ������
/// workgroupId - ������������ ������� ������, ���� ����, ���� ������ �����
///               ����������������� �������
///
/// ����� ��������� �����������, �� ������������ �� ������ � ������� ���
/// ������������ ��� �������������.
var
    project_id
   ,project_extra_id

   ,base_spec_id    /// ������������� ����������� ������������
   ,base_isp_id     /// ������������� ����������� ������� ����������
            : integer;
begin
    result := 0;

    /// ���������, �� ��������� �� ������ ������������ � ������ � ������ ������������� �������
    if ( objectId <> 0 ) and SpecInWork( objectId ) then
    begin
        CORE.DM.DBError := lW('������������ '+mark+' ��� ��������� � ����������.');
        exit;
    end;


    // �������� ����������� �������������� �������, ����� �������� ��� � ����������� �������
    if (objectId <> 0) and (trim(mark) = '') then
    mark := dmSDQ('SELECT mark FROM ' + VIEW_OBJECT + ' WHERE child = ' + IntToStr(objectId), '');

    // ������� ������ �������
    project_id := AddObject('name, mark, kind, comment', [name, mark, KIND_PROJECT, comment], TBL_PROJECT);
    if project_id = 0 then exit;

    // ����������� � ������ ��������� ��������
    if AddLink( LNK_PROJECT_STRUCTURE, 0, project_id ) = 0 then exit;

    /// ������� ������ � ������� ��������� �������
    mngData.AddObject(
        'status, parent, workgroup_id, parent_kod, kod',
        [ 0, project_id, workgroupId, parent_prod_kod, prod_kod ],
        TBL_PROJECT_EXTRA,
        true                                       // �������� ��� �������� ��������
    );

    // ���� ��� ������ �� �������������� �������, �������� ��� � ��� ����������������
    // �������� � ������� ������� �������� c ��������� � ����� �������
    if objectId <> 0
    then base_spec_id := CopyObjectToProject( project_id, project_id, objectId );

    /// ���� ����� ��������������� ����� ������������
    /// ��������� ������� ������ ������������, ������� ���������� � ����������� ��
    /// ���� � ����� � � �������, ��� � �����
    if objectId = 0 then
    begin
        /// �������� ������� ������������
        base_spec_id := CreateProjectObject( mark, '', '', name, '', '', KIND_ASSEMBL, 0, KIND_SPECIF, project_id );

        /// �������� �������� ����������
        base_isp_id := CreateProjectObject( mark, '', '', name, '', '', KIND_ASSEMBL, 0, KIND_ISPOLN, project_id );

        /// �������� ������������ � �������
        if not CreateCrossLinks( LNK_PROJECT_STRUCTURE, AddLink( LNK_PROJECT_STRUCTURE, project_id, base_spec_id )) then exit;

        /// �������� ���������� � ������������
        if not CreateCrossLinks( LNK_PROJECT_STRUCTURE, AddLink( LNK_PROJECT_STRUCTURE, base_spec_id, base_isp_id )) then exit;
    end;

    /// ������������ ������ ������������ ������ ���������� � ����������� �������� ������������
    /// ��� ��������� ������ ��� �������� � �� �������������
    LinkEditorToObject( base_spec_id, CORE.User.id, project_id );
    LinkCheckerToObject( base_spec_id, CORE.User.id, project_id );
    /// ...� ����� � ������
    SetProjectObjectState( base_spec_id, STATE_PROJECT_INWORK );

    result := project_id;
end;

function TDataManager.CreateProjectObject( mark, realization, markTU, name, mass, comment: string; kind_id, material_id, obj_icon, project_id: integer ): integer;
/// ������� � ������� ����� ������ ���������� ���� � ����������, ������ � ������� ���������
var
    ext_id: integer;
begin
    // ������� ��� ������
    result := AddObject('mark, realization, markTU, name, kind, mass, material_id, comment, icon ',
                            [mark, realization, markTU, name, kind_id, mass, material_id, comment, obj_icon ]);

    // ������� ��������� ��� �������
    ext_id := AddObject('status,parent,project_id', [0,result,project_id], TBL_PROJECT_OBJECT_EXTRA, true{�� ��������� � ������ ��������� ����});

    // ����������� ��������� � �������
    AddLink( LNK_PROJECT_OBJECT_EXTRA, result, ext_id );

end;

function TDataManager.CopyObject(source_id, target_id: integer; source_table,
  target_table: string): integer;
/// ����������� ������ ������� �� ����� ������� � ������.
///    - source_id - ������ � source_table
///    - target_id - ������ � target_table
///    - source_table - ��� �������� �������
///    - target_table - ��� ������� �������
///
///  ���������������, ��� ������� ����� ���������� ����� �����.
///  ���� �� ������ target_id (=0), ����� ������� ����� ������, ����� - ������������
///  ���������.
///  ���������� id ���������/�������������� � target_table ������
///
///  ������������ � ��������� �������� ��� ������������ �������� ��� �������� �������
///  ��� ���������� �������� ��������� ��� ���������� �������
var
    fields : string;
begin
    /// �������� ������ ���������� ����� �������� �������
    fields := dmSDQ( Format( SQL_GET_ALL_FIELDS, [source_table, source_table] ), '');

    result := dmSDQ( Format( 'INSERT INTO %s (%s) SELECT %s FROM %s WHERE id = %d '+
                  'select scope_identity() as id',
                  [target_table, fields, fields, source_table, source_id] ), 0 );
end;

function TDataManager.CopyObjectToProject(proje�t_id, parent_id,
  object_id: integer): integer;
///  ����� �������� �� �������� ��������� (������ object � structure) ���������
///  ������� � ������� ��������� ���������� �������
///
///  proje�t_id - ������������ ������ (id �� ������� project_object)
///  parent_id - ������������ � ������� ������ (id �� ������� project_object)
///  object_id - ���������� ������ (id �� ������� object)
///
///  ������� �������� � ���, ��� ����������� ���������� ����� ������������ ��
///  ��������� �����������, �� � ������ ��������� ����� id. �.�. ���������
///  ������� � ������� ��������� ����� ������� �� ������� �������� � �����������
///  �� �������� id ���������� ����� �� ����� id
///
///  ����� ����������� ��� �������� ������ ������� �� ������ ����������� �������
///  � ���������� � ������ ������� �� ����������� �������� (������������ ��� �������)
///
///  ��������:
///  ��� ����������� �������� ��� �������� ���� �������� (�������� ��������)
///    1) ���������� ������������
///       - �������� ������������ ��� ��������� ������
///       - ������� ��� �� ���������� � ��� �������
///           - �������� ����������
///           - ����������� � ������������
///           - �������� ��� ���������������� ��������
///           - ����������� ������ � ����������
///    2) ����������
///       - �������� ����������
///       - �������� ��� ���������������� ��������
///       - ����������� ������ � ����������
///    3) ����� ��������� ������ (������, ������ �������, �������� � �.�.)
///       - �������� ��� ������� ������
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

    // ���������� ��������� ������ � �������
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

    // ����������� ������� �� ��������� ����������� � ������� ���������� ��������
    function CopySingleObject( obj_id: integer ): integer;
    var
        present_id: integer;

    begin
        // ���� ����� ������� �������� ������������ ����� ���������� (����� �� ��������� ������ �����)
        // ���� �������� ��������� ������ �� objects, ������ ��� � original_id
        // �����, ������������� ��� ������������� ������ � ��� id ��� ������� ��� ������

        // ��� ���� �����������, ��� ������ ������ ����� ����������� ����� ��������, ������ �� �� � �����������
        present_id := dmSDQ(
            'SELECT TOP 1 child FROM ' + VIEW_PROJECT_STRUCTURE +
            ' WHERE (original_id = ' + IntToStr(obj_id) +
            ' or child = ' + IntToStr(obj_id) +
            ' ) AND project_id = '+IntToStr(proje�t_id), 0 );

        if present_id = 0
        then
        begin
            // �������� ������ �� ��������� ����������� � �������
            result := CopyObject( obj_id, 0, TBL_OBJECT, TBL_PROJECT);
            // ��������� ������ � ��� ���������

            /// ������� ������ � ������� ���������
            mngData.AddObject(
                'parent, original_id, project_id',
                [ result, obj_id, proje�t_id ],
                TBL_PROJECT_OBJECT_EXTRA,
                true                                       // �������� ��� �������� ��������
            );

            /// ���������, �� ��������� �� � ������� ������� ���������
            ObjectDocs := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_DOCUMENT_KD + ' WHERE object_id = ' + IntToStr(obj_id) );
            if Assigned(ObjectDocs) and (ObjectDocs.RecordCount > 0) then
            /// ���������� ��
            while not ObjectDocs.Eof do
            begin

                /// ���� ����������� ������ �� ������-�������� � ������ �������, �������
//                if ObjectDocs.FieldByName('project_object_id').IsNull then
                begin

                    version_id := CopyObject( ObjectDocs.FieldByName('doc_id').AsInteger, 0, TBL_OBJECT, TBL_PROJECT);

                    /// ����������� ������ �� ����� ��������� � �������
                    UpdateTable(
                        dmSDQ('SELECT id FROM ' +TBL_DOCUMENT_EXTRA+ ' WHERE object_id = ' + IntToStr(obj_id), 0 ),
                        TBL_DOCUMENT_EXTRA,
                        ['project_id', 'project_object_id', 'project_doc_id'],
                        [proje�t_id, result, version_id ]
                    );

                end;

                ObjectDocs.Next;
            end;
        end
        else
            // ����� ��� ������������
            result := present_id;

        if result = 0 then exit;

    end;

    // ����������� ���������� � ����������� ������� ������
    function CopyIspoln( obj_id: integer ): integer;
    var
        query: TDataset;
    begin
        // �������� ���������� �� ��������� ����������� � �������
        result := CopySingleObject( obj_id );
        if result = 0 then exit;

        // �������� ���������������� ��������
        query := CORE.DM.OpenQueryEx( 'SELECT child FROM ' + VIEW_OBJECT + ' WHERE parent = ' + IntToStr(obj_id) );
        if assigned(query) then
        while not query.eof do
        begin

            // �������� � ����������� � ����������
            id := CopySingleObject( query.fields[0].AsInteger );
            link_id := AddLink( LNK_PROJECT_STRUCTURE, result, id );

            if link_id = 0 then
            begin
                result := 0;
                exit;
            end;

            // ��������� id ������ ��� ����������� �������� ���������
            StoreLink( link_id );

            query.Next;
        end;
    end;

    function CopySpecification( obj_id: integer ): integer;
    var
        query: TDataset;
    begin
        // �������� ������������ �� ��������� ����������� � �������
        result := CopySingleObject( obj_id );
        if result = 0 then exit;

        // �������� ���������������� �������� (�� ����, � ������������ ��� ����� ���� ������ ����������)
        query := CORE.DM.OpenQueryEx( 'SELECT child FROM ' + VIEW_OBJECT + ' WHERE parent = ' + IntToStr(obj_id) + ' AND icon = ' + IntToStr(KIND_ISPOLN));
        if assigned(query) then
        while not query.eof do
        begin

            // �������� � ����������� � ����������
            id := CopyIspoln( query.fields[0].AsInteger );
            link_id := AddLink( LNK_PROJECT_STRUCTURE, result, id );

            if link_id = 0 then
            begin
                result := 0;
                exit;
            end;

            // ��������� id ������ ��� ����������� �������� ���������
            StoreLink( link_id );

            query.Next;
        end;

    end;

begin

    SetLength(links, 0);

    // �������� �������� ������ � �������� �������
    case GetKind( object_id ) of
        KIND_SPECIF : result := CopySpecification(object_id);
        KIND_ISPOLN : result := CopyIspoln(object_id);
        else          result := CopySingleObject(object_id);
        // ���������� ��������� ��� �������� ������, ����������� � ������
    end;

    // ����������� ������� � �������, ��� � �����
    if   result <> 0  then
    begin

        // ����������� ������� �� ������������� ��������� � �������/��������
        if parent_id <> 0
        then
            link_id := AddLink( LNK_PROJECT_STRUCTURE, parent_id, result )
        else
        if parent_id = 0
        then
            link_id := AddLink( LNK_PROJECT_STRUCTURE, proje�t_id, result );

        // ����� ��� �������� ������
        if link_id = 0 then
        begin
            result := 0;
            exit;
        end;

        // ��������� ��� �������� ���������
        StoreLink( link_id );


        // ���� ���������� ������ �������� �������� ��� �������, �� ���������� ������ ����������� ��� ��������������
        // ���������, ��� ���� �� �������������� ������ ���� ������, � ��� ��������� � ���� ������
        // ���������� ���������� ����� ������� � ��� �������������� �� �������� ��� ��������������.
        // ��, ���������� �� �������������� ���������������� ������ �� ������������� �� ���������
        // ����������� �������. ��� ����� ������� ��������� � ������ ������� ����� ������
        // ���������� �� ��������������, ��� �� � ��������� �� ����������, ��������� ��� �������� �
        // �������� ����������� ������ ����� ���������� ������� ��� ��� ���������� �����������
        if (parent_id = proje�t_id) or (parent_id = 0) then
        begin

            // ������������ �������� ������� ������� ��� ���������� ����������.
            // �������� id ������� PROJECT_OBJECT_EXTRA ��� ��������� ��������
            // � ���� ����������� �� ���� ����������
            dsTopElems := CORE.DM.OpenQueryEx( Format(SQL_GET_TOPOBJECT_EXTRA_ID, [ proje�t_id ]) );

            while not dsTopElems.eof do
            begin
                UpdateTable(
                    dmSDQ( 'SELECT id FROM '+TBL_PROJECT_OBJECT_EXTRA+ ' WHERE parent = ' + dsTopElems.FieldByName('child').AsString, 0 ),
                    TBL_PROJECT_OBJECT_EXTRA,
                    ['status'],
                    [STATE_PROJECT_READONLY] );
                dsTopElems.Next;
            end;

//            mark_current := dmSQ('SELECT mark FROM '+TBL_PROJECT+' WHERE id = '+IntToStr(proje�t_id));
//            mark_new := dmSQ('SELECT mark FROM '+TBL_PROJECT+' WHERE id = '+IntToStr(result));

            // ��������� ������ ����������� �������� � ������
            UpdateProjectMark( proje�t_id );
        end;



        // ������� ����� ��������� ��� ���� ������ ��������� � ������ �������� �������
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
///  �������� ������� (�����) �� ������� ����� � �������� ������� ������� ������
label ext;
var
    section_id
   ,section_extra_id
            : integer;
begin

    lC('CreateSection');
    result := 0;

    // ������� �����
    section_id := mngData.AddObject('kind, name', [KIND_SECTION, name], TBL_OBJECT);
    if section_id = 0 then goto ext;

    // ����������� � �������� � ���������
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

    /// �������� ������ ��������� ������
    query := Core.DM.OpenQueryEx( 'SELECT * FROM ' + VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + IntToStr(work_version_id) );
    if not Assigned(query) then goto ext;

    // ������� ������� ����(-�) � ����� ������
    filename := mngData.GetVersionPath( work_version_id, true );
    if filename = '' then goto ext;

    DeleteFile( filename );
    RemoveDir( ExtractFilePath( filename ));

    // ������� ���� �� ���������
    if not RemoveFileFromStorage( query.FieldByName('GUID').AsString ) then goto ext;


    // ������� ������ ������� ������ �� ���� (��� ��������� � ������)
    dmEQ( ' DELETE FROM ' + TBL_PROJECT + ' WHERE id = ' + IntToStr(work_version_id) );

    /// ���� � ������� ��������� ��� ������ �� �������� � ������������� ���������
    if query.FieldByName('doc_id').IsNull
    then
        // ������� ������ �� ����������� ������� ������� ���������
        dmEQ( ' DELETE FROM ' + TBL_PROJECT_OBJECT_EXTRA + ' WHERE id = ' + query.FieldByName('doc_extra_id').AsString )
    else
        // ������� ������ �� �������� � �������
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
{ �������� ���� ��������������� ������ ��������� ������ � ���������������
  ���������� �� � �����
}
var
    query : TADOQuery;
label ext;
begin
    lC('TDataManager.DeleteCrossLinks');
    result := false;
{
    // ��������� ������� ��������� � �����
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
    // ������� ��� �������� ������ ������
    if not dmEQ( Format( SQL_DELETE_CROSS_LINKS, [TableName, id] )) then goto ext;

    result := true;
ext:
    lCE;
end;

function TDataManager.DeleteDocumentVersion( doc_id: integer ): boolean;
/// ��� �������� ��������� �� �������, ������� ������ ��������� [project_object]
/// ��������� � ������ ������� �� ��������� ��������� �������.
/// ����������� � ���� ��������� [project_object_ext] ������� ������ � ��� ������,
/// ���� � ��������� ��� ������ �� �������� � �� [project_object_ext].[object_id]
label ext;
var
    query : TADOQuery;
begin

    lC('TDataManager.DeleteDocumentVersion');
    result := false;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    // ������� ������ ��������� �� �������
    if not dmEQ(' DELETE FROM ' + TBL_PROJECT + ' WHERE id = ' + IntToStr( doc_id )) then goto ext;

    // �������� ��� �������������� ������
    query := CORE.DM.OpenQueryEx(' SELECT * FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr( doc_id ));
    if not assigned(query) or (query.RecordCount = 0) then goto ext;

    // ���� ��� ������ �� ������ � ��
    if   query.FieldByName('object_id').IsNull
    then
        // ������� ��������� ���������. ��� �� �����
        dmEQ(' DELETE FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE id = ' + query.FieldByName('id').AsString )
    else
        // ���������� � ��������� ������ �� ������� �������� � ������-��������
        UpdateTable(
            query.FieldByName('id').AsInteger,
            TBL_DOCUMENT_EXTRA,
            ['project_doc_id', 'project_object_id'],
            ['*null', '*null']
        );

    // ��������� � �������-�������� � ������� ������� ������� ����������� ������
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
{ ����������� ������������ ������ ����� (arr) � ���� ������ ��������, ����������� ��������.
  ��� quoted = true, �������� ������������� � �������.

  ������������ ��� ��������� ������ ����� ��� ������ �������� � ���� ������
  ������ ��� ����������� � ������ �������
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
{ ������������ ������������ UPDATE sql-�������
  tablename - ��� �������
  id - id ������ ��� ����������� � WHERE
  fields, values - ������������ �������. ����� ����� � �������� ��� ���
}
var
   comma, val: string;
   i: integer;
   t : word;
begin
    lC('TDataManager.BuildUpdateSQL');
    try

        comma := '';

        // ���������������� ������������ ������
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
// ������� � ������� [ROLE_WORKGROUPS] ����� ������� ������.
// ���� � ����� ������ ��� ����������, ���������� ������.
begin
    // ��������� ������������� ������ � ����� ������
    result := dmSDQ(' SELECT COUNT(id) FROM ' + TBL_ROLES_WORKGROUPS + ' WHERE name = ''' + name + '''', 0) = 0;

    if not result then
    begin
        CORE.DM.DBError := lE('������� ������ � ������ "' + name + '" ��� ����������.');
        exit;
    end;

    // ��� � �������, ����� ���������
    dmEQ(' INSERT INTO ' + TBL_ROLES_WORKGROUPS + ' ( name, tags ) VALUES ('''+ name +'', ''+ifthen(tag='', 'project', tag)+''')');

    result := true;
end;

function TDataManager.UpdateWorkgroup(group_id: integer; name: string ): boolean;
// ���������� ����� ������� ������
begin
    result := dmEQ(' UPDATE ' + TBL_ROLES_WORKGROUPS + ' SET name = '''+name+''' WHERE id = ' + IntToStr(group_id));
end;

function TDataManager.DeleleWorkgroup(group_id: integer): boolean;
// �������� ������� ������ � ���� ������, ���������� �� ���
label
    ext;
var
    user_links: TADOQuery;
begin
    result := false;

    // ��������� �� ������� ��������, ������������ ������ ������� ������
    if dmSDQ(' SELECT count(parent) FROM '+TBL_PROJECT_EXTRA+' WHERE workgroup_id = '+IntToStr(group_id),0) > 0 then
    begin
        CORE.DM.DBError := '������� ������ ( ID='+IntToStr(group_id)+' ) ������������ � �������� � �� ����� ���� �������';
        Exit;
    end;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    // ������� ������� ������
    if not dmEQ(' DELETE ' + TBL_ROLES_WORKGROUPS + ' WHERE id = ' + IntToStr( group_id )) then goto ext;

    // �������� ������ ���� ������������� � ������� ������
    user_links := CORE.DM.OpenQueryEx(' SELECT id FROM ' + LNK_ROLES_EMPL_WORKGROUP + ' WHERE parent = ' + IntToStr( group_id ));

    // ��� ������� ������������ ������ �����
    if Assigned(user_links) then
    while not user_links.Eof do
    begin
        // ������� �������� ������������ � ������� ������
        if not dmEQ(' DELETE FROM ' + LNK_ROLES_EMPL_WORKGROUP + ' WHERE id = ' + user_links.Fields[0].AsString ) then goto ext;

        // ������� ��� ����� � ��������
        if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL + ' WHERE parent = ' + user_links.Fields[0].AsString ) then goto ext;

        // ������� ��� ����� ���� � ������������� ������
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
// ������� � ������� [ROLE_RIGHTS] ����� ������� ������.
// ���� � ����� ������ ��� ����������, ���������� ������.
begin
    // ��������� ������������� ������ � ����� ������
    result := dmSDQ(' SELECT COUNT(id) FROM ' + TBL_ROLES_RIGHTS + ' WHERE name = ''' + name + '''', 0) = 0;

    if not result then
    begin
        CORE.DM.DBError := lE('���� � ������ "' + name + '" ��� ����������.');
        exit;
    end;

    // ��� � �������, ����� ���������
    dmEQ(' INSERT INTO ' + TBL_ROLES_RIGHTS + ' ( name, value ) VALUES ('''+ name +''', '''+ value +''')');

    result := true;
end;

function TDataManager.UpdateRole(id: integer; name, value: string): boolean;
// ��������� ������ ��������� ����
begin
    result := dmEQ(' UPDATE ' + TBL_ROLES_RIGHTS + ' SET name = '''+ name +''', value = '''+value+''' WHERE id = ' + IntToStr(id) );
end;

function TDataManager.DeleteRole(role_id: integer): boolean;
// ������� ��������� ����, ������ ��� ������ �� ���
label
    ext;
begin
    result := false;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    // ������� ����
    if not dmEQ(' DELETE FROM ' + TBL_ROLES_RIGHTS + ' WHERE id = ' + IntToStr( role_id )) then goto ext;

    // ������� ��� ����� ����� �� ������
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_GROUP + ' WHERE child = ' + IntToStr( role_id )) then goto ext;

    // ������� ��� ����� ���� � ������������� ������
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL + ' WHERE child = ' + IntToStr( role_id )) then goto ext;

    result := true;

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.CommitTrans;

ext:

    if   CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.RollbackTrans;
end;

function TDataManager.CreateGroup(name: string): boolean;
// ������� � ������� [ROLE_GROUPS] ����� ������� ������.
// ���� � ����� ������ ��� ����������, ���������� ������.
begin
    // ��������� ������������� ������ � ����� ������
    result := dmSDQ(' SELECT COUNT(id) FROM ' + TBL_ROLES_GROUPS + ' WHERE name = ''' + name + '''', 0) = 0;

    if not result then
    begin
        CORE.DM.DBError := lE('������ ����� � ������ "' + name + '" ��� ����������.');
        exit;
    end;

    // ��� � �������, ����� ���������
    dmEQ(' INSERT INTO ' + TBL_ROLES_GROUPS + ' ( name ) VALUES ('''+ name +''')');

    result := true;
end;

function TDataManager.CreateIspoln(project_id, parent: integer; mark, name: string): integer;
/// �������� ���������� ��� ��������� ������������ � ��������������
/// ���������� ������ � ���������
///    parent - ������������, ��� ������� ����� ������� ����������
///    mark, name - ��������������� �������� ������������
var
    next_number : integer;
begin

    result := 0;

    /// �������� ����� ���������� ���������� � ����������� � ������������ ���������� ������� ����������
    next_number := GetNextIspolNumber( parent );

    /// ������� ����������
    result :=
        CreateProjectObject(
            mark, ifthen( next_number = 0, '', IntToStr(next_number)), '', name, '', '', KIND_ASSEMBL, 0, KIND_ISPOLN, project_id );

    if result = 0 then exit;

    /// �������� � ������������
    CreateCrossLinks(
        LNK_PROJECT_STRUCTURE,
        AddLink( LNK_PROJECT_STRUCTURE, parent, result )
    );

end;

function TDataManager.CopyIspoln(project_id, parent, child: integer; mark, name: string): integer;
/// �������� ���������� ��� ��������� ������������ � ��������������
/// ���������� ������ � ���������. � ����� ������������ ������������� ���
/// ������� ��������
///    parent - ������������, ��� ������� ����� ������� ����������
///    child - ����������-�������
///    mark, name - ��������������� �������� ������������
var
    dsChilds: TDataset;
begin

    /// ������� ����������
    result := CreateIspoln( project_id, parent, mark, name );

    if result = 0 then exit;

    /// �������� ���� ���������������� ��������
    dsChilds := CORE.DM.OpenQueryEx(' SELECT child FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE parent = ' + IntToStr(child) );
    if not Assigned( dsChilds ) then exit;

    /// ����������� �� � ������ ����������
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
// ���������� ����� ������ ����
begin
    result := dmEQ(' UPDATE ' + TBL_ROLES_GROUPS + ' SET name = '''+ name +''' WHERE id = ' + IntToStr( group_id ));
end;

function TDataManager.DeleleGroup(group_id: integer): boolean;
// �������� ������ ����. ������ ������ �����, ����������� �� ��� ������
label
    ext;
begin

    result := false;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    // ������� ������
    if not dmEQ(' DELETE FROM ' + TBL_ROLES_GROUPS + ' WHERE id = ' + IntToStr( group_id )) then goto ext;

    // ������� ��� ����� ����� �� ������
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_GROUP + ' WHERE parent = ' + IntToStr( group_id )) then goto ext;

    // ������� ��� ����� ������ � �������� ��������
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
    result := dmSDQ('SELECT name FROM '+TBL_ROLES_WORKGROUPS+' WHERE id = '+IntToStr(workgroup_id), '�� �������');
end;

function TDataManager.GetWorkgroupsList( dataset: TDataset; tag : string ): TDataset;
// �������� ������ ���� ������������ ������� �����
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
// �������� ������ ���� ��������������, ����������� � ��������� ������� ������
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
// ��������� ������ ���� ����� ����, ����������� � ����������� � ������ ������� ������
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
// ��������� ������ ���� ������������� � ������ ��������� ������ ����
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
/// ������ ����� ���������� ������ ���� ���� �� ���� ����������� ������������ �����.
/// ����������� � ��������� �������� ���� � ��������� ����� ������ ���������, ������
/// ��� ������ �������� �� ������ ��������� � ����.
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
// ��������� ������� ������ ���� ������������ ���� ������������ � ������ ������� ������
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
// �������� ������ �����, ����������� � ��������� ������ ����
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
// �������� ������ ���� ������������ ����� ����
begin
    if not Assigned( dataset ) then exit;

    result := CORE.DM.OpenQueryEx('SELECT id, name FROM ' + TBL_ROLES_GROUPS, dataSet);
end;

function TDataManager.GetGroupsList(dataset: TADOQuery): TADOQuery;
// �������� ������ ���� ������������ ����� ����
begin
    result := CORE.DM.OpenQueryEx('SELECT id, name FROM ' + TBL_ROLES_GROUPS, dataSet);
end;

function TDataManager.GetRolesList(dataset: TDataset): TDataset;
// �������� ������ ���� ������������ ����
begin
    if not Assigned( dataset ) then exit;

    result := CORE.DM.OpenQueryEx('SELECT id, name, value FROM ' + TBL_ROLES_RIGHTS, dataSet);
end;

function TDataManager.LinkUserToWorkroup(workgroup_id, user_id: integer): integer;
// ��������� ���������� ������������ � ��������� ������� ������
begin
    // ��������� ������� ����� ������, ����� �� ������� �����
    result := GetEmplToWorkgroupLink( workgroup_id, user_id );

    // ���� �������� ����, ����� ������ �� ����������. �������
    if result = 0 then
    result := dmIQ( Format(' INSERT INTO %s (parent, child) VALUES (%d, %d) ', [ LNK_ROLES_EMPL_WORKGROUP, workgroup_id, user_id ]));
end;

function TDataManager.UpdateLinkUserToWorkroup(workgroup_id, user_id: integer;
  todate: TDate; dateSelected: boolean): boolean;
/// ���������� ������� ����������� �������� ������������ � ������� ������
/// - todate - ���� �� ������� ����� ��������� ������ ��������
/// - dateSelected - ������� ����, ��� ���������� ���� �������� ����������,
///                  ����� ���������� �������� ���� � ������
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
/// ���������� ������� ����������� �������� ������������ � ������ ���� � ������ ������� ������
/// - todate - ���� �� ������� ����� ��������� ������ ��������
/// - dateSelected - ������� ����, ��� ���������� ���� �������� ����������,
///                  ����� ���������� �������� ���� � ������
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
// �������� ������������ �� ��������� ������� ������. �������� ����
// ����� � �����, ����������� �� ����� ������������ � ������ ������� ������
var
    link_id: integer;
label
    ext;
begin

    result := false;

    if   not CORE.DM.ADOConnection.InTransaction
    then CORE.DM.ADOConnection.BeginTrans;

    /// �������� id ����� ������������ � ������� �������, ��������� �� ����
    /// ��������� �������� ����� � ������������� �����
    link_id := GetEmplToWorkgroupLink( workgroup_id, user_id );

    /// ������� �������� ������������
    if not dmEQ( Format(' DELETE FROM %s WHERE id = %d ',
                           [ LNK_ROLES_EMPL_WORKGROUP, link_id ])) then goto ext;

    // ������� ��� ����� � ��������
    if not dmEQ(' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL + ' WHERE parent = ' + IntToStr(link_id) ) then goto ext;

    // ������� ��� ����� ���� � ������������� ������
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
// �������� ������ ���� � ������������ � ������ ������� ������
var
    link_id : integer;
begin
    /// �������� id ������ ������������ � ������� ������
    /// ��������� �������� ����� � ������������� �����
    link_id := GetEmplToWorkgroupLink( workgroup_id, user_id );

    /// ��������� ������� ��������, ����� �� ���� �����
    if dmSDQ(Format(' SELECT id FROM %s WHERE parent = %d AND child = %d ',[LNK_ROLES_GROUP_WORKGROUP, link_id, group_id]), 0) = 0
    then
        /// ������� �������� � ������ ����
        result := dmEQ( Format(' INSERT INTO %s (parent, child) VALUES (%d, %d) ', [LNK_ROLES_GROUP_WORKGROUP, link_id, group_id]))
    else
        result := true;
end;

function TDataManager.ObjectIsReady(object_id: integer): boolean;
/// ����� ��������� ���� �������� �� ������� ������ � ���������� false,
/// ���� ���� ���� ���� � ������� � ������ ��� � ��������
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
// �������� �������� ������������ � ������ ���� � ������ ������� ������
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
/// �������� ������ ���� ����������� ������� � �������
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
// �������� ������������ ������������ ����
var
    link_id : integer;
begin
    // �������� �������� ����������� � ������� ������, ��������� ������ �� ��� ��������� �������� � ������ �����
    link_id := GetEmplToWorkgroupLink( workgroup_id, user_id );

    /// ��������� ������� ��������, ����� �� ���� �����
    if dmSDQ(Format(' SELECT id FROM %s WHERE parent = %d AND child = %d ',[LNK_ROLES_RIGHT_EMPL, link_id, role_id]), 0) = 0
    then
        /// ������� �������� � ������ ����
        result := dmEQ( Format(' INSERT INTO %s (parent, child) VALUES (%d, %d) ', [LNK_ROLES_RIGHT_EMPL, link_id, role_id]))
    else
        result := true;
end;

function TDataManager.DeleteLinkPersonalRole(workgroup_id, user_id,
  role_id: integer): boolean;
// �������� ������������ ���� ������������
begin
    result := dmEQ(
        ' DELETE FROM ' + LNK_ROLES_RIGHT_EMPL +
        ' WHERE parent = ' + IntToStr( GetEmplToWorkgroupLink( workgroup_id, user_id )) +
        ' AND child = ' + IntToStr(role_id));
end;

function TDataManager.UpdateLinkPersonalRole(workgroup_id, user_id,
  role_id: integer; value: string; todate: TDate; dateSelected: boolean): boolean;
// ���������� ������ ������������ ����
/// - todate - ���� �� ������� ����� ��������� ������ ��������
/// - dateSelected - ������� ����, ��� ���������� ���� �������� ����������,
///                  ����� ���������� �������� ���� � ������
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
// ��������� ���� � ������
begin
    // ��������� ������� ����� ������, ����� �� ������� �����
    result := dmSDQ(
        Format(' SELECT id FROM %s WHERE parent = %d AND child = %d ',
               [  LNK_ROLES_RIGHT_GROUP,
                  group_id,
                  role_id
               ]
        ), 0
    ) = 0;

    // ���� �������� ����, ����� ������ �� ����������
    if result then
    // �������
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
/// �������� ���������� ������� ������� � ���������� �������� � �������
/// ��� �������� ����������� ����������� �������� (������ �� ����� ��������)
/// ������ ������������ � ���� ������
///    parent, kind, icon, status - ��������� ������������� �������
///          ������������ � �������� ����������� �������� �������
///    child - ������������� ������
var
    dsParent, dsChild: TDataset;
begin
    dsParent := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE child = ' + IntToStr(parent) );
    dsChild  := CORE.DM.OpenQueryEx(' SELECT * FROM ' + TBL_PROJECT + ' WHERE id = ' + IntToStr(child) );

    // �������� ����������� �������� ���������� ������� � ��������
    // ���������� �������� � ������ �������
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

        // ������ �� �� �����
        // ����������� ��������� ������� � ����������� �������� ������
        mngData.CreateCrossLinks(
            LNK_PROJECT_STRUCTURE,
            mngData.AddLink( LNK_PROJECT_STRUCTURE, parent, child )
        );

        /// ����� �������� � ��������� �������� ������ ������ �� �������
        dsChild  := CORE.DM.OpenQueryEx(' SELECT * FROM ' + VIEW_PROJECT_STRUCTURE + ' WHERE child = ' + IntToStr(child), dsChild );

        /// ������������� ������� �������� � �������
        mngData.UpdateTable( dsChild.FieldByName('extra_id').AsInteger, TBL_PROJECT_OBJECT_EXTRA, ['project_id'], [project_id]);

//        // ��������� �������� mark �������, ���� ����������
//        if parent_id = ProjectID
//        then mngData.UpdateProjectMark( ProjectID );

    end

end;

function TDataManager.UpdateGroupRole(link_id: integer; value: string): boolean;
// ���������� �������� ��������
begin
    result := dmEQ( Format(' UPDATE %s SET value = ''%s'' WHERE id = %d ', [LNK_ROLES_RIGHT_GROUP, value, link_id]));
end;

function TDataManager.DelLinkRoleToGroup( role_link_id: integer ): boolean;
// ���������� ���� �� ������
begin
    result := dmEQ( Format(' DELETE FROM %s WHERE id = %d ', [  LNK_ROLES_RIGHT_GROUP, role_link_id ] ));
end;

function TDataManager.GetEmplToWorkgroupLink(workgroup_id,
  user_id: integer): integer;
// ��������� id �������� ������������ � ������� ������.
// � ��������� �������� �� ����������� id ������������ ������ � ���������
// ������������ � ������� � ������������ ������ � ������ ������� ������
begin
    result := dmSDQ(Format(' SELECT id FROM %s WHERE child = %d AND parent = %d ', [LNK_ROLES_EMPL_WORKGROUP, user_id, workgroup_id]), 0);
end;




function TDataManager.HasRole(role_id, workgroup_id: integer; value: string = ''): boolean;
// ������� ��� ������ CheckRole
begin
    result := CheckRole( workgroup_id, 'role_id', role_id, value );
end;

function TDataManager.HasRole(role_name: string;
  workgroup_id: integer; value: string = ''): boolean;
// ������� ��� ������ CheckRole
begin
    result := CheckRole( workgroup_id, 'role_name', role_name, value );
end;

function TDataManager.HasRole(role_id: integer; value: string): boolean;
/// ������� ��� �������� ������� ����, �� � �������, ��� ����� �����������
/// � ������ ������� ������ BASE_WORKGROUP_NAME, ���������� ����� �������������
/// �� ������ � ������ ����� PDM
begin
    result := CheckRole( GetBaseWorkgroupId, 'role_id', role_id, value );
end;

function TDataManager.HasRole(role_name, value: string): boolean;
/// ������� ��� �������� ������� ����, �� � �������, ��� ����� �����������
/// � ������ ������� ������ BASE_WORKGROUP_NAME, ���������� ����� �������������
/// �� ������ � ������ ����� PDM
begin
    result := CheckRole( GetBaseWorkgroupId, 'role_name', role_name, value );
end;

function TDataManager.CheckRole( workgroup_id: integer; name: string; key: variant; value: string ): boolean;
// ��������� ������� � �������� ������������ ��������� ����
// ���� ������� value, ��������� ������� �� ���������� �������� � �����
begin
    /// ��� �������������, ��������� ������ ����� ������������
    RefreshRolesList();

    // ���� ���� �� ���������� ���������, ��� ����, ������������ ���� ���������
    // � ������ ������ ������, ��� ����������� ����������� ���� �� �����
    LastRightDataset.first;
    result := LastRightDataset.Locate(name+';workgroup_id', VarArrayOf([key, workgroup_id]), []);

    // ���� ���� ���� � ������� ����������� ��������, ��������� ����� ��������
    // �� ���������� �������� � ���� ������������
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
// ��������� ������� � �������� ������������ ��������� ����
// ���� ������� value, ��������� ������� �� ���������� �������� � �����
begin

    result := '';

    /// ��� �������������, ��������� ������ ����� ������������
    RefreshRolesList();

    // ���� ���� �� ���������� ���������, ��� ����, ������������ ���� ���������
    // � ������ ������ ������, ��� ����������� ����������� ���� �� �����
    LastRightDataset.first;

    if   LastRightDataset.Locate(name+';workgroup_id', VarArrayOf([key, workgroup_id]), [])
    then result := LastRightDataset.FieldByName('value').AsString;

end;


function TDataManager.GetRootElems(project_id, get_mode: integer): TIntArray;
/// �������� � ���������� ����� �������� �� ���������� �������, �������� ������
/// ��������� ���������.
/// ������������, ����� �������� ����� ���������� �������� �������� ��� �����������
/// �����/������ ������ �������, � �� ���� ������
///    project_id - ������������ ��� ������
///    get_mode - ����� ������-���������, �� ������� ����������� ����� id
///               ��������� ���� ROOT_MY_XXX
///
var
    ds: TDataset;

    procedure toArray(_id: integer);
    /// ��������� � ���������������� ������ id ���� ������ ��� ���
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
/// ����� ��������� ������ �� ��������� � �������� ������������ ������
/// ��������� �������� � ��������, ������ ����������� ��������������� �
/// RIGHT_TIME_VALIDE_PERIOD �����
/// ������� ������������ ��� ������ ���������� �� ������ � ��� ��� ���� ������������
/// � ��������� �������� �������� �� ���� ������.
/// ��� �������, ������� ���������� ������������ ���� ������������ � ���� ��
/// ������� - �� ����������� ������� �����. ����� �������, ������������ ����
/// ����� ���������, ��� �����, ���� ��������� ��������� ��������� ���� �����
/// ������ ���������, � ���� ��, ��� ����� ����� ������������ ����� ��������
begin

    // �������� ������ ������, ������ ���� ����� ������ ������������
    // ��� ������ �� �� ���������� (������ �������� � ������� ������� ���������)
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
/// ������� id ������� ������� ������, ������� �������� ��������� ���� ���
/// ������ ��������������� � ����� PDM
begin
    if base_workgroup_id <> 0

    /// ���� id ��� ���������, ���������� ���
    then result := base_workgroup_id
    else
    begin
        // ����� ���������� � ����������, ����� �� ��������� � ���� � ����������
        base_workgroup_id := dmSDQ(' SELECT id FROM '+TBL_ROLES_WORKGROUPS+' WHERE name = '''+BASE_WORKGROUP_NAME+'''', 0);
        result := base_workgroup_id;
    end;
end;

function TDataManager.UserIsChecker(object_id: integer): boolean;
/// ��������� �� ������� ������������ ����� ����������� ���������� �������
begin
    result :=
        dmSDQ(
            Format(' SELECT count(id) FROM %s WHERE parent = %d AND child = %d ',
                   [LNK_PROJECT_CHECKER, object_id, CORE.User.id]),
            0) > 0;
end;

function TDataManager.UserIsEditor(object_id: integer): boolean;
/// ��������� �� ������� ������������ ����� ���������� ���������� �������
begin
    result :=
        dmSDQ(
            Format(' SELECT count(id) FROM %s WHERE parent = %d AND child = %d ',
                   [LNK_PROJECT_EDITOR, object_id, CORE.User.id]),
            0) > 0;
end;





function TDataManager.GetERP(name: string): string;
/// ���������
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
