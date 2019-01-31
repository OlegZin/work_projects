unit uDataManager;

{ ������ ��������� ����� � ������� �������, ����������� ��������������
  ��������� � ������� �� ������� �� ������������ ���������� ����������� �
  ���������� ��������� ���������.
}

interface

uses  ADODB, DB;

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
    KIND_SELECTION = 13;

type

    TArrElem = record
        TableName: string;
        TableFields: string;
    end;

    TDataManager = class

        function AddObject(fields: string; values: array of variant): integer;
                    // ��������� � ���� ����� ������, ���������� id ������ ����� �������

        function ChangeObject(id: integer; Fields, Values: array of variant; comment: string = ''): boolean;
                    // ������ ������ �������

        function DeleteObject( id: integer; comment: string; to_history: boolean = true): boolean;



        function AddLink(TableName: string; parent, child: integer; uid: integer = -1): integer;
                    // ��������� �������� � ��������� ������� ������.
                    // ������������� ����������� ����� ��������������� �������� � ��������� ����� �������� ������
                    // ���� �������� ������ ����������, ��� ����������� �� � ����� (������ �� ����� ����������������).
                    // ���������� id ����������� ������, ��� ��������� -1

        function CreateCrossLinks(TableName: string; id: integer; rebuild_sublinks: boolean = false): boolean;
                    // ������� �������������� ������ �� ��������� ���� ������� ��������� ������
        function DeleteCrossLinks(TableName: string; id: integer; comment: string = ''): boolean;
                    // ������� ���.����� � ���������� � �����

        function DeleteLink(TableName: string; id, mode: integer; comment: string = ''): boolean;
        function DeleteLinkBy(TableName: string; parent, child: integer; comment: string = ''): boolean;

        function ChangeLinkParent( TableName: string; id: integer; parent_id: integer; comment: string = ''): boolean;
        function ChangeLinkChild( TableName: string; id: integer; child_id: integer; comment: string = ''): boolean;

        function CreateDocumentVersion( object_id, version_id, doc_type: integer; name, filename, comment: string): integer;
                    // �������� ������ ��������� � ��������� � ���������� �������

        function UpdateDocumentVersion( work_version_id: integer ): boolean;
                    // ��������� ������ ��������� ������. ���������������, ��� ���
                    // ������� ������ ���������, ������ ������� ����� �������� ���������������

        function SaveWorkDocumentAsVersion( work_version_id: integer ): boolean;
                    // ��������� ������� ������� ������ � ��������� �� � ������ ����� �����������

        function DeleteWorkDocument( work_version_id: integer ): boolean;
                    // ������� ������� ������ ��� ����������

        function TakeDocumentToWork( version_id: integer ): boolean;


        function GetFileFromStorage( path, filename, DBName: string ): boolean;
                    // ��������� ���� �� ��������� � ��������� ���������
        function RemoveFileFromStorage( DBName: string ): boolean;

        function GetObjectSubitems( id: integer; ItemTable, LinkTable: string; query: TDataSet ): TADOQuery;
        function GetDocsList( id: integer; query: TDataSet ): TADOQuery;
        function GetSectionDocsList( id: integer; query: TDataSet ): TADOQuery;

        function UpdateHasDocsFlag( id: integer ): boolean;
                    // ���������� � ����������� �������� �������� ������� ����������� ���������� � �������

        function SetInWorkState( child, mode: integer ): boolean;
                    // ��������� ��� ������ �������� ������ � ������ ���������

        function GetObjectBy( field, value: string ): integer;

        function GetVersionPath( id: integer; filename: boolean = false ): string;
                    // �� id �������-��������� �������� ��� ������ � ������ ���� ��� �������� ������ �� ���� ������������

        function GetNextVersionNumber( name: string; object_id: integer ): integer;
                    // �� ����� ����� � �������-�������� �������� ��������� ����� ������

        function IsInWork( doc_version_id: integer ): boolean;
                    // �� id ��������� ���������, �� �������� �� ��� ��������� ������� ��� �� ������� ����������

        function IsWorkVersion( doc_version_id: integer ): boolean;
                    // �� id ��������� ��������� �� �������� �� ��� ������� ������� ���������
                    // �� ������ � ��������, ������� ��������, �� ��������� �� �����

    private
        TableFields: array of TArrElem;
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
    end;

implementation

{ TDataManager }

uses
    uPhenixCORE, uConstants, SysUtils, Variants, Math, Classes, uMain;

const

    // ����������� ���������� ����� � �����
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
    // ����������� �������� ������ �� ������� ����������
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
        // ��������� �������� ������������� ������ ������ ���������� ���������
        // � ������ �������, � �������� �������� (� ������ ������ �������� ���������
        // ���������� �����)

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

function TDataManager.GetDocsCount( id: integer): integer;
begin
    dmOQ( Format( SQL_GET_DOC_VERSIONS, [ id ] ));
    result := Core.DM.Query.RecordCount;
end;

function TDataManager.GetDocsList(id: integer; query: TDataSet): TADOQuery;
{ ��� ���������� ������� �������� ����� ������ �� ����� �������� ���� ����������.
  ������������ ������� ������������� ��� �������� ������ ��� ������� grdDocs
}
begin
    result := Core.DM.OpenQueryEx( Format( SQL_GET_DOC_VERSIONS, [ id ] ), query );
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
    if not dmOQ( Format( SQL_GET_FILE_DATA, [ DBname ] )) then goto ext;

    if not Core.DM.Query.Active or ( Core.DM.Query.RecordCount = 0 ) then
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


    BlobStream := Core.DM.Query.CreateBlobStream( Core.DM.Query.FieldByName('file_stream'), bmRead );
    FileStream := TFileStream.Create( path + fileName, fmOpenWrite );
    FileStream.CopyFrom( BlobStream, BlobStream.Size );

    // ��������� ������ ��� ����������� ���������� ��������
    FreeAndNil( FileStream );
    FreeAndNil( BlobStream );

    result := true;

ext:
    lCE;
end;

function TDataManager.GetNextVersionNumber(name: string; object_id: integer ): integer;
begin
    result := Integer( dmSDQ( Format( SQL_GET_MAX_VERSION, [ name, object_id ] )+'%''', 0 )) + 1;
    // ����� ����� ����� ������ Format, ���������� % � ������, ����������� � like �������,
    // ������ ��� ������������ ���������� ��� �����������. ����������� ������� ����� �����������
    // �������� � ������ �������
end;

function TDataManager.GetObjectBy(field, value: string): integer;

begin
    result := dmSDQ( Format( SQL_GET_OBJECT_ID_BY, [ field, value ] ), 0);
end;

function TDataManager.GetObjectSubitems(id: integer; ItemTable,
  LinkTable: string; query: TDataSet): TADOQuery;
{ ��� ���������� ������� �������� ����� ������ �� ����� ���������� ���������.
  ������������ ������� ������������� ��� �������� ������ ��� ������� grdObject
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
{ ���������, �� �������� �� ��������� �������� ������ � ������ ���
  ������� �������.
  ��� ���, ���� �������� ����������� � ������� document_inwork � ��������
  �������� (�������� ������) ��� ������� (������� ������)
 }
begin
    dmOQ( Format( SQL_GET_INWORK_LINK, [ doc_version_id ] ));
    result := Core.DM.Query.Active and (Core.DM.Query.RecordCount > 0);
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

function TDataManager.RemoveFileFromStorage(DBName: string): boolean;
begin
    result := dmEQ( Format( SQL_REMOVE_FROM_TABLE, [ TBL_FILE, 'name', DBName ] ));
end;

function TDataManager.SaveWorkDocumentAsVersion(
  work_version_id: integer): boolean;
{ ����� ��������� ������� ������� ������ �� �����
  � ��������� ������� ������ � ������ ����������� (��������� �� ������ �� ��������)
}
var
    query: TADOQuery;
    filename : string;
begin
    result := false;

    // ��������� ��������� ��������� ������� ������
    if not UpdateDocumentVersion( work_version_id ) then exit;

    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ VIEW_INWORK, 'child', IntToStr(work_version_id) ]) );

    // ������� ������ ������� ������ � ��������, ��� ������ �� ���������������
    mngData.DeleteLink(
        LNK_DOCUMENT_INWORK,
        query.FieldByName('link_id').AsInteger,
        DEL_MODE_NO_CROSS + DEL_MODE_SINGLE + DEL_MODE_NO_HISTORY
    );

    // ������� ������� ����(-�) � ����� ������
    filename := mngData.GetVersionPath( query.FieldByName('child').AsInteger, true );

    if FileExists( filename ) then
    begin
        DeleteFile( filename );
        RemoveDir( ExtractFilePath( filename ));
    end;

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
    result := false;

    if not dmEQ( Format( SQL_SET_DOCUMENT_INWORK_STATE, [ mode, ifthen( mode = 0, 0, Core.User.id), child ] )) then exit;

    result := true;
end;

function TDataManager.TakeDocumentToWork(version_id: integer): boolean;
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
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA,[ VIEW_DOCUMENT, 'child', IntToStr(version_id) ] ));
    if not Assigned(query) then goto ext;

    // ��������� ���� � �������� ����� ��� ����������� �������� � ������� ������
    GetFileFromStorage( DIR_TEMP, query.FieldByName('filename').AsString, query.FieldByName('fullname').AsString );

    // ������� ������� ������ ���������
    work_version_id :=
        CreateDocumentVersion(
            query.FieldByName('parent').AsInteger,             // ������-��������
            query.FieldByName('child').AsInteger,              // �������� ������
            query.FieldByName('type').AsInteger,               // ��� ���������
            query.FieldByName('filename').AsString,            // ��� ��������� � �����������
            DIR_TEMP + query.FieldByName('filename').AsString, // ������ ��������� � ���������
            ''                                                 // �����������
         );
    if work_version_id = 0 then goto ext;

    // ��������� �������� � ������� ������
    link_id := AddLink( LNK_DOCUMENT_INWORK, version_id, work_version_id );
    if link_id = 0 then goto ext;

    if not dmEQ( BuildUpdateSQL( link_id, LNK_DOCUMENT_INWORK, ['minor_version'], [query.FieldByName('minor_version').AsFloat + 0.001] ) ) then goto ext;

    // �������� ������ ������� ���� ��� �������� �����
    dir := GetVersionPath( work_version_id );

    // ������� ������� �����
    ForceDirectories( dir );

    // �������� ������ ������� ������
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA,[ VIEW_DOCUMENT, 'child', IntToStr(work_version_id) ] ));
    if not Assigned(query) then goto ext;

    // ��������� �������� � �����
    if not GetFileFromStorage( dir, query.FieldByName('filename').AsString, query.FieldByName('fullname').AsString ) then goto ext;
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
    result := true;

ext:
    lCE;
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
    if not IsWorkVersion( work_version_id ) then
    begin
        Core.DM.DBError := lW( '�������� ('+IntToStr(work_version_id)+') �� �������� ������� �������.');
        goto ext;
    end;

    // �������� ����� ��� �������� �����
    filename := mngData.GetVersionPath( work_version_id, true );

    // ��������� �� �������. ���� ��� ���� �������� ������ ��� ���������
    if not FileExists( filename ) then
    begin
        Core.DM.DBError := lW( '������� ���� ��������� �� ����������.'+sLineBreak+'('+filename+')');
        goto ext;
    end;

    // �������� ������ ������� ������ � ��������� ���� � ���������
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ VIEW_DOCUMENT, 'child', IntToStr(work_version_id) ] ));
    if   not Assigned( query ) then goto ext;

    UpdateFileInStorage( query.FieldByName('fullname').AsString, filename );

    // �������� ������� ��� ����� � ��������� ������ ������� ������
    hash := mngFile.GetHash( filename );

    if not dmEQ( BuildUpdateSQL( work_version_id, TBL_DOCUMENT_EXTRA, ['hash'], [hash] ) ) then goto ext;

    // ��������� ����� �������� ������
    query := Core.DM.OpenQueryEx( Format( SQL_GET_TABLE_DATA, [ LNK_DOCUMENT_INWORK, 'child', IntToStr(work_version_id) ] ));

    if not dmEQ( BuildUpdateSQL( query.FieldByName('id').AsInteger, LNK_DOCUMENT_INWORK, ['minor_version'], [query.FieldByName('minor_version').AsFloat + 0.001] ) ) then goto ext;

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

    result := false;

    // ���������� �������
    if not ChangeObject( id, ['has_docs'], [ ifthen( GetDocsCount(id) > 0, 1, 0 ) ] ) then exit;

    result := true;

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

    // ���� �������� ����� ��� ���� - ��������� ��� ��� ����
    if dmSDQ( Format( SQL_SELECT_LINK_ID, [TableName, parent, child] ), 0 ) <> 0 then goto ext;

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

function TDataManager.AddObject(fields: string; values: array of variant): integer;
{ ����� ������� ����� ������ � ���������� ��� id
  fields - ������ �������� ����� ����� ������� ��� ������� ������������� ������
  values - ���������� ������ �� ���������� ��� ����� �� fields, ������ � ��� �� �������
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

        // ������� ������
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
{ ����� ������ ������ �����, �������� ���������� ������ � ������
  Fields, Values - ���������� ������������ ������. ����� ����� � �������� � ��� �� ������� ��� � � Fields
}
label ext;
begin
    lC('TDataManager.ChangeObject');
    result := false;

    // ������ ������� ��������� ������� � �����
    if not dmEQ( Format( SQL_COPY_TO_HISTORY_BY_ID, [TBL_OBJECT, Core.User.id, Comment, TBL_OBJECT, id] )) then goto ext;

    // �������� ���������� ���������
    // � ��������� ������ �������
    if not dmEQ( BuildUpdateSQL( id, TBL_OBJECT, Fields, Values ) ) then goto ext;

    result := true;
ext:
    lCE;
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

//    if not Core.DM.ADOConnection.InTransaction
//    then   Core.DM.ADOConnection.BeginTrans;

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

    // ������� ��������� ����������
//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.CommitTrans;

    result := true;

ext:
    // ��� ������������� ������ ���������� �� ����� �������
//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.RollbackTrans;

    lCE;
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

//    if not Core.DM.ADOConnection.InTransaction
//    then   Core.DM.ADOConnection.BeginTrans;

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

//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.CommitTrans;
    result := true;

ext:
    // ��� ������������� ������ ���������� �� ����� �������
//    if   Core.DM.ADOConnection.InTransaction
//    then Core.DM.ADOConnection.RollbackTrans;

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

    // ������� ��������� ��� ��������� ������
    if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [TableName, id] )) then goto ext;

    // ������������ ���� �������� ��� ��������� ���������� ��������
    // �� ������������� ��� �������� �������� ���������, ��������� �������� �
    // �������� �������� ��-�� ������������ ��������.
    if rebuild_sublinks then
    begin

        // �� child ����� ������ ���� ��� ������, ������� ��������� �� ���� ��� �� ��������
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
//                if not DeleteCrossLinks( TableName, arr[i].link_id ) then goto ext;

                // ������� ��������� ��� ��������� ������ ��� � ������ ����� ��������
                if not dmEQ( Format( SQL_GREATE_CROSS_LINKS, [ TableName, arr[i].link_id ] )) then goto ext;

            end;
        end;
    end;

    result := true;
ext:
    lCE;
end;

function TDataManager.CreateDocumentVersion(object_id, version_id, doc_type: integer; name, filename, comment: string): integer;
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
  doc_kind  - ��� ���������. id �� �������-����������� document_type
  version   - ����� ������ �����
  name      - ��� �����, ������� ����� ��������������� ��� ������ ������ [PDM].[Document_extra] � [FilesDB].[PDMFiles]
  filename  - ������ ���� �� �����

  ��������
  - ������� ����� ������ ���� �������� � ������� object
  - ������� � ����������� � ���� ������ � ���������� � ������� document_extra
  - ��������� ��������� ���� � ��������� [FilesDB].[PDMFiles]
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

    // ����� ������ ���������
    doc_id := AddObject('kind, name, comment', [ KIND_DOCUMENT, name, comment ]);
    if doc_id = 0 then goto ext;

    // ����������� �������� � �������
    if AddLink( LNK_DOCUMENT_OBJECT, object_id, doc_id ) = 0 then goto ext;

    // ������ �������-������� ������� ������� ����������� ����������
    if not ChangeObject( object_id, ['has_docs'], [1] ) then goto ext;

    // ������������ � ������� ������
    version := GetNextVersionNumber( name, object_id );
{    version := 1;
    if version_id <> 0 then
    version := Integer( dmEQ( Format( SQL_GET_MAX_VERSION, [ name ] ))) + 1;
}
    // ���������� ��� � ������ ������ ������ � �������� ��� ��������� �����
    fullname := Format( '%s{%d_%d_%d}', [ ExtractFileName( filename ), object_id, doc_id, version ] );

    // ��� ����� ����� ��� ������������ ������� ��������� ��� �������� ����� ������ �� ������
    hash := mngFile.GetHash( filename );

    // ������� ������ � ��������������� ������� ���������
    if not dmEQ( Format( SQL_CREATE_DOCEXTRA, [doc_id, version, name, doc_type, fullname, hash] )) then goto ext;

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

    // ������� ������ ������� ������ � ��������, ��� ������ �� ���������������
    if not DeleteLink(
        LNK_DOCUMENT_INWORK,
        query.FieldByName('link_id').AsInteger,
        DEL_MODE_NO_CROSS + DEL_MODE_SINGLE + DEL_MODE_NO_HISTORY
    ) then goto ext;

    // ������� ������� ����(-�) � ����� ������
    filename := mngData.GetVersionPath( query.FieldByName('child').AsInteger, true );
    if filename = '' then goto ext;

    DeleteFile( filename );
    RemoveDir( ExtractFilePath( filename ));

    // ������� ���� �� ���������
    if not RemoveFileFromStorage( query.FieldByName('fullname').AsString ) then goto ext;

    // ������� �������� ���������
    if not DeleteLink( LNK_DOCUMENT_OBJECT, query.FieldByName('document_object_link_id').AsInteger, DEL_MODE_NO_CROSS + DEL_MODE_SINGLE ) then goto ext;

    // ������� ������ ������� ������ �� ���� (��� ��������� � ������)
    if not DeleteObject( query.FieldByName('child').AsInteger, '', false ) then goto ext;

    // ������� ������ �� ����������� ������� ������� ���������
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
{ �������� ���� ��������������� ������ ��������� ������ � ���������������
  ���������� �� � �����
}
var
    query : TADOQuery;
label ext;
begin
    lC('TDataManager.DeleteCrossLinks');
    result := false;

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

    // ������� ��� �������� ������ ������
    if not dmEQ( Format( SQL_DELETE_CROSS_LINKS, [TableName, id] )) then goto ext;

    result := true;
ext:
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
{ ������������ ������������ UPDATE sql-�������
  tablename - ��� �������
  id - id ������ ��� ����������� � WHERE
  fields, values - ������������ �������. ����� ����� � �������� ��� ���
}
var
   comma: string;
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
