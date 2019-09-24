unit uKompasManager;

////////////////////////////////////////////////////////////////////////////////
///
///  ������ ������ �� �������������� � ��������� ������ ��� �������� ������
///  �������.
///
///  ��������� ����� ��� ����� � �������� ���� MetaInfo ������ ������ �����.
///
///  �������� ������
///  - ����� sTempPath ����������� ����� ��� ���������� xml �� ������
///  - ����� Init ����������� xml �������� ������������, ��� ���� �����������
///    ����� ������������ � ��� �������� �� ������� ������ ������ � ���������� ��
///    �������� ������
///  - ������� LoadSpecification(0) � ������� ������ �� ������� xml ����������� ������
///  - ��������� ������������ ������� ������ ��������� ������� ��� ������� �����
///    LoadSpecification(X, Y) ������������ ������, ��� ������� ����� ������������
///  - � ������ ���� �� �������� ������ ������ ��� ������� �� ������� ����� ���������������
///    ������ ����������� ���������� � ��������� � ��.
///  - ���������� ������ ����������� � ��������� ������� ������� UploadToDataset(dataset)
///
///  ��������� ������� ����������� ��������� child � parent, ������ �������������
///  ������������� � ������ � ����������� DBGridEh, ����������� � ��������
///
///  ������ � XML:
///  http://streletzcoder.ru/byistro-i-legko-razbor-parsing-xml-dokumentov-s-pomoshhyu-txmldocument/
///
////////////////////////////////////////////////////////////////////////////////

interface

uses
    System.ZIP, FileCtrl, SysUtils, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, StrUtils,
    System.Classes, System.IOUtils, System.Types, DB, math, StdCtrls, MemTableEh,
    RegularExpressions, IniFiles;

const
    DEF_META_FILE         = 'MetaInfo';         // xml � ��������� ������� ������������ ��� �������
    DEF_META_PRODUCT_FILE = 'MetaProductInfo';  // xml c ������ ������� ������� (�����) � ������� ���� ����������(?)
    DEF_INFO_FILE         = 'FileInfo';         // ini c ����������� ������ �����


    /// ������ ������������� ���� ����� ������ ������ ��� ��������� ������
    /// ������. ��������� FIELD_XXX - ������ ������ ��� ������� FIELDS.
    /// ������� ������ - ������ ������ (���� �� �������� VERSION_XXX)

    // �������������� ����� ������
    FIELD_MARK     = 0;        // ������ ����������� �� ����� ��������� ���� '��'
    FIELD_MARK_BASE = 6;        // ���������� ��� ��������
    FIELD_NAME     = 1;        // ������������
    FIELD_MASS     = 2;        // �����
    FIELD_MATERIAL = 3;        // �������� (����������� � ������� ������)
    FIELD_COMMENT  = 4;       // �����������
    FIELD_KIND     = 5;       // ��� �����: '������������' / '������'

    VERSION_INDEX_17 = 0;
    VERSION_INDEX_18 = 1;

    FIELD_MARK_BASE_18 = 'base'; // �������� �������� mark
    FIELD_MARK_DELIM_18 = 'documentDelimiter';
    FIELD_MARK_NUMBER_18 = 'documentNumber';
    // 18 ������ ������ ���� mark ������� �� ������ ��������
    // <property id="marking">
    //     <property id="base" value="���2.02.03.100" type="string" />
    //     <property id="embodimentDelimiter" value="-" type="string" />
    //     <property id="embodimentNumber" value="" type="string" />
    //     <property id="additionalDelimiter" value="." type="string" />
    //     <property id="additionalNumber" value="" type="string" />
    //     <property id="documentDelimiter" value="" type="string" />
    //     <property id="documentNumber" value="" type="string" />
    // </property>

    /// ������ ������������� ���� ����� � ���������������� ���������� � ������
    /// ������� ������ ������ � xml �����
    FIELDS : array [0..6, 0..1] of string = (
        ('4','marking'), ('5','name'), ('8','mass'), ('9','materal'), ('13','comment'), ('14','kind'), ('4','marking_base'));

    /// �������� �������������� ������ ������ �� ����� DEF_INFO_FILE
    VERSION_16 = '0x10001006';//'KOMPAS_16.1';
    VERSION_17 = '0x11001011';//'KOMPAS_17.1';
    VERSION_18 = '0x12001017';//'KOMPAS_18.1';

    FILE_TYPE_SPEC_ID = '5';
    FILE_TYPE_DRAW_ID = '1';

    FILE_TYPE_NONE = '';
    FILE_TYPE_SPEC = '������������';
    FILE_TYPE_DRAW = '������';

type

    TArrayElem = record
        kind                     // �������� ��� (������, ��������� �������,..)
       ,subkind                  // ������ (������������/����������)
       ,mark                     // �����������
       ,name                     // ������������
       ,count                    // ����������
       ,mass                     // �����
       ,comment                  // �����������
       ,material                 // �������� (����������� ������ � �������)
       ,linked_file              // ����������� ���� (������������/������)
       ,file_id                  // id ������� � ����� ������������
       ,part_id                  // �������� � ����������� ���������� [nft].[dbo].[mat].imbase_key
                : string;

        child                    // ����������� ��� ������� ����������� id ��� ���������� ������
       ,parent                   // ����������� ��� ������� id �������� ��� ���������� ������
       ,ispol                    // ����� ���������� ������� (� ���������� � ���������� '-0�' � mark
       ,bd_id                    // id � ����, ���� ����� ������ ��� ���� � �������(��������� id)
                                 // ��� � ������������� ���������(�������� id). ��������� �� �����������
                                 // ������ � ����, � ������������ ��� ������������. ��� ����, ���������
                                 // id ����� ��������� � ����� ����������� ������������ � ��
       ,kd_id                    // ���������������, ���� ������ ���� � ��. ���� ���� ���������
                                 // ���������� �������� ������������ ��� �������� � ������ ������.
                                 // ��� ������� � ���, ��� ������ �� ������ ��������� ���������
                                 // ��������� ��������������� ��������, ����� �� �������� ������ ��
                                 // ��� �������� ������� � �� (��� ����� �������� � ���������� ����� ��������
                                 // � ������, ��� ��������� ������������ �� ����������� � ����������� �������
                                 // ��������� ��������)
                : integer;
    end;

    TFileElem = record
        path
       ,filename
       ,kind                     // '������������' ��� '������'
       ,mark                     // ������ ���� '2019.22.00.000' � ������� ���� '��'
       ,mark_base                // ������ ������ ���� ��� ���������� � ������� ��������, ��� ������ � ����������� ���
       ,name
       ,mass
       ,material
       ,comment
                : string;
    end;

    TBuffRow = record
        value              // �� ������ �������� ���� fieldName ������
       ,kind
                : string;
        bd_id              // id ������� � ����
       ,kd_id
                : integer;
    end;

    TKompasManager = class
      private
        fProjectID   // ������, � ������� ����� ��������� ������
                : integer;

        fTempPath    // ����� ��� �������� ������ �� ������
       ,fFilename    // ��� ���������� ������������ ����� �� ������
       ,fArchivename // ��� ���������� ��������� ������ (����� ������)
       ,fMark        //
                : string;

        fId          // ������� ��� ������� fArray.child ��������
                : integer;

        fDoc      // ������� �������� xml �� ����������
       ,fProject  // ������� �������� xml � ������� �������
                : IXMLDocument;


        fRootNode         // �������� ���� �������� ��������� fDoc
       ,fProjectRootNode  // �������� ���� �������� ��������� fProject
                : IXMLNode;


        fLog : TMemo;
        // ������� ���������, ���� ��������� ���������� � ��������� �������� �
        // ��������� �� �������

        fVersion: string;
        // ������ �������� ��������� �����. �� ������ ������ �������������� 17 � 18 ������.
        // �������������� ������ � ���������� VERSION_XXX

        fFileType: string;
        // ��� �������� ���������������� �����


        fArray  : array of TArrayElem;
        /// ������ �� ����� ������������ ������� �� ������������.
        /// �������� ������������ �������������, ��� �������� ������ ������������
        /// �� ������ ��������, ��������� ��� ��������. ����� �������� ��������
        /// ������������ ��� ���� ��������� ������ �� ����������� ������������
        /// � ������������ ��� �� ��������� (�������������� ����������).
        /// ������ ������� �� ����� child � parent, ���������� ������������ id,
        /// ��������� ������ �� xml ������� ����������

        fFileArray : array of TFileElem;
        /// �������� ������ ������ ������ � ��������� ������� �� ������� � ����
        /// ��������� �����.
        /// ����������� ����� ��������� ������������ � ��������� ������ ����� ����
        /// ����������� � ��������������� ��������
        /// ��� ��������� ������ �������� ��������� ������������ �������� ���
        /// �������� ������ ������

        fProcessed : array of String;
        /// ������ id ��� ������������ (����������� �� xml � ������� ������) ��������

        fFindBuff : array of TBuffRow;
        // ����� ��� ����������� ��������� ����������� ��������� ������� �����������
        // ������� � ����. ������ ���������� ������� �� �������. ����� �������� ���������
        // � ����, ������� ������������ ���� ������


        procedure ToLog( text : string );

        function ExtractFile( archive_name: string; file_name: string = DEF_META_FILE ): boolean;
        /// ����� ��������� ��������� ���� �� ���������� ������ � �������� �����

        function GetXMLObject( var doc: IXMLDocument; var root_node: IXMLNode; filename: string = ''): boolean;
        /// ��������� ���� � ���������� ������ � ������������ � ���� �� ����� �������

        function GetFileVersion: string;
        /// ������ �� ������� ������������ ����� ���������� � ������ ����� �������

        function ClearMacros(text : string): string;
        /// ������ ������ �� ��������� �������� �������

        function LoadSpec( parent: integer; ispoln: integer = 0 ): boolean;
        /// ���������� ����� ������ ��� ��������� �������� ������������ � ������� ������

        function GetID: integer;
        /// ��������� ����������� �������� ��� ����������� id

        function AddArrayElem(parent, child, ispol, bd_id, kd_id: integer; kind, subkind, mark, name, count,
            mass, comment, material, linked_file, id, partID : string): integer;
        /// ���������� ������ �������� � ������� ������

        function IsProcessed( id : string ): boolean;
        /// ��������� ���� �� ��������� ������������� � ������ ��� ������������ (�����������) �������� ������������

        function ToProcessed( id : string ): boolean;
        /// ��������� ��������� ������������� � ������ ������������ � �������� �������� ��������

        function GetKind( name: string ): string;

        function GetVersionField( field: integer ): string;
        /// �� �������������� ������ ���� �������� ��� ��� ��� ������� ������

      public
        error : string;
        // ��������� ������, ������������ ��� ������ ���������

        function sProjectID( id: integer ): TKompasManager;
        /// ������������� id ������� � ������� ��������

        function sTempPath( path: string ): TKompasManager;
        /// ������������� ���� �� �������� ����� ���� ��������� ����� �� ������

        function sSetLogMemo( log: TMemo ): TKompasManager;
        /// ���������� ���� ��� ����������� ���� ��������

        function SetupMemtable( memtable: TMemTableEh ): boolean;
        /// ����� ����������� ������� memtable ���� ����� ����������� ������ �� �������� �������
        /// ���� ���������� ��������, ��������� ���������� ����� ������� � ����� �����,
        /// ����������� � ������� ��������

        procedure CleanUp;
        /// ������� ������� ������� ����������� �� xml ������ � ���������� ������� id

        function Init( archive_name: string; file_name: string = DEF_META_FILE ): boolean;
        /// ��������� xml ��������� ��������� � ��������� ��� � ������ ��� ���������� ������

        function ScanFiles( path, filter: string; pass_filter: string = '' ): boolean;
        /// ��������� ����� � �������� �� ������� ������ ������, �������� � ��� ������� ����������
        /// � ������ fFileArray

        function GetStampData( field: integer ): string;
        /// ���������� ������ ���������� ���� ������. �������� - ��������� ���� FIELD_XXX
        /// ������� ���������������� ���������� ������� Init

        function LoadSpecification( parent:integer = 0; mark: string = ''; ispol: integer = 0 ): boolean;
        /// ��������� ������ ������������ � ������� ������, ������� ������ ��
        /// �� ��������� (��������� ������������ � ����� �������� �������)
        /// ��� �������� ����������, ���������� ������ ����� � �������� � �������

        function UploadToDataset( dataset: TDataset): boolean;
        /// �������������� � ��������� � ������� (memtable) ������ �������� �������

        function GetIspoln( mark: string ): integer;
        /// �� ������ ����������� ���������� � ���������� ����� ����������

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

    ToLog('>>> ������ ������ ����� ' + archive_name);

    // ��������� ��������� ���� �� ������ (������, ��� �������� xlm �� ���������� �����)
    if error = '' then ExtractFile( archive_name, file_name );

    // �������� ������� ������
    if error = '' then GetXMLObject( fDoc, fRootNode );


    // ��������� ini � ��������� ������ �����
    if error = '' then ExtractFile( archive_name, DEF_INFO_FILE );

    // �������� ������ ��������� �����
    if error = '' then fVersion := GetFileVersion;

    if error = '' then
    if fVersion = VERSION_18 then
    begin
        // ��������� ���� ��������������� ���������� � �������
        if error = '' then ExtractFile( archive_name, DEF_META_PRODUCT_FILE );

        // �������� ������� ������
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
/// ����� ������������ ��� �������� ������ ������������
/// ������� �������� �������� ������������
/// ����� ����� ������������ ��� �� �������� � �����������
/// �� ������� ����������� ������������ � �������� �����
/// ��������� ������������� ������.
/// ���� ����, ������ ������������ � ������ � ��������� � ����������������
/// ��������, ������ �� ������������ ������� ������ ������ �� �����������
/// ���������� ����������������� ��������
var
   i, j, _ispoln : integer;
   found : boolean;
begin
    result := false;

    fMark := mark;

    /// ������� ��������� �������� ������������
    if not LoadSpec( parent, ispol ) then exit;

    /// ���������� ��� �������� �������� �������
    /// � ���� ����� ����������� � ����
    /// ���� ���� ������������, ���������� ������ �� ���������� �������, � ��
    /// �������. ����� ������� �������� � ����� �������, ��� ��������� ����������
    /// ���������� ��� �������� ������
    for I := 0 to High(fArray) do
    begin

        // ���������� ��������� ������������ ��� ��� ������������ � �� ��������,
        // (��� ���� bd_id �������� �������� id ������ ����, ��� �������� ������� id �������������)
        // ��������� ��� � ������ ������ ��� ������ � �� ������ ��� �� �����
        if (fArray[i].kd_id <= 0) then

        // ���������� ������� ������������ � �� ����������
        if (fArray[i].parent <> 1) and (fArray[i].parent <> 0) then

        /// ���������� ������������ ����� � �������� ����� ���������� ����� �������
        found := false;
        j := 0;
//        for j := 0 to High(fFileArray) do
        while not found and (j <= High(fFileArray)) do
        begin

            _ispoln := GetIspoln(fArray[i].mark);

               // ����������� �� ����� �������� - ���������� ��������
            if ((GetIspoln(fArray[i].mark) = 1) and ((fFileArray[j].mark = fArray[i].mark) or (fFileArray[j].mark_base = fArray[i].mark))) or
               // ����������� � ��������� - ���� ��� ��������� � ������������ �����, � ������� �� ����������� ����������
               ((GetIspoln(fArray[i].mark) > 1) and (pos( fFileArray[j].mark, fArray[i].mark ) <> 0)) or
               // �� � ������, ����� ����� ���������� �����-�� ������ � ����� �����
               ((GetIspoln(fArray[i].mark) > 1) and ((fFileArray[j].mark = fArray[i].mark) or (fFileArray[j].mark_base = fArray[i].mark)))
            then

            begin
                found := true;

                /// ����������, �� ������ ����� ����� ������
                fArray[i].linked_file := fFileArray[j].path + fFileArray[j].filename;

                /// ��� �������� ������ ����������� ����
                /// ���� ��� ������, ����� ������ �������� �� ������� ������
                if fFileArray[j].kind = '������' then
                begin
                    ToLog('>>> ������ ������ ��� ' + fArray[i].mark + '. ������ ���������.');
                    fArray[i].mass := fFileArray[j].mass;
                    fArray[i].material := fFileArray[j].material;
                    fArray[i].comment := fArray[i].comment + ' ' + fFileArray[j].comment;
                    fArray[i].linked_file := fFileArray[j].path + fFileArray[j].filename;
                end;

                if fFileArray[j].kind = '������������' then
                begin
                    ToLog('>>> ������� ������������ ��� ' + fArray[i].mark );

                    /// ��������� ������ �� �����
                    if Init( fArray[i].linked_file ) then

                    /// ������ � ������� ������
                    if not LoadSpec(
                        fArray[i].child,           // ������ ����������� � ����� ��������
                        GetIspoln(fArray[i].mark)  // �� mark ��������� ����� ���������� ���� '-0�' � �������� �����
                    ) then
                    ToLog('!!! ' + error );

                end;
            end;

            Inc(j);
        end;

    end;
    ToLog('');
    ToLog('');
    ToLog('������������ ���������.');
    ToLog('�������������� ������� "� ������", ����� ����� ����������� ��������� � ������.');

    result := true;
end;

function TKompasManager.LoadSpec( parent: integer; ispoln: integer = 0 ): boolean;
/// ����� ���������� � ������� ������ ������������ ��� �� ����� � ��������� �
/// ���������� �������� ����� ����������� ������
///    parent - � ����� �������� ����� ��������� ������������ ������
///    ispoln - ��������� �� ������ ������ ������������ � ������ �� ����������
///             ������ ����������
///
/// ����� ������������ ��� ��� �������� ��������� ������������, ��� � ��� ���������
/// ������ ��������� ��������� ������
///
/// ��������
///   - �������� ������ � ���������� �������� ��� ������ ����������. ������ ������
///     ��� ��� ���������� ���������� ������, ��� ���������� ���������� ��������,
///     ���������� ����������� �� �����. ��������, ���� 10 ��������, � ���������� 5,
///     ������ ����� ���������� � number="5" blockNumber="0", � ��� 12 ����������
///     ������ ����� ���������� � number="2" blockNumber="1".
///     ������ ���������� �������� ���� ����������� ����� ���������� � ������ ����������
///     ��������� ������ ������
///   - ���� ����� �������� ���������� �� �����, ������ � ������ ������ ������ �������
///     ������������, � ������ ������� ������ ���� � ����� ������� ������� ���������:
///       - ������� ������� ������������
///       - ���������� �� id_������� ��� �������� parent
///   - �������� ������ ���� �������� � ��������� �������
///   - �������� ������ ������� ������������
///   - ���������� ������ �������:
///       - �������� id_����� ������� �� �������
///       - ������� � ������� �������� �� id_�����
///       - ���������� ���� ������� � ���������� ��� ���������.
///         �����, ��� ����� ������� �������� ��� ������������ ��� �� �����������
///       - ������ ������ � ���������� � ��������� �����������
///
///       (��� ������ ������ ������� ������������)
///       - ���������, ���� �� ��� ����� ����������
///           - ���� ��� - �������, ���������� � parent, ���������� id_�������
///           - ����� ���� - �������� id_�������
///       - ������� ����� ������� �������� �������, ��������� �������, ���������� � id_�������
///         (�� ������ ������ ��� ������������� ��������� ���� �� ��� �����
///          �������� ������������ ��� ������, ��������� ������� ������ ��������������
///          � ������� ������� � ����������� ������� ����������� � �����, ���
///          ������, ��� ��������� ��������� � �� ����. ������ ����� ������ �������� ���
///          � ������ ��������� ��������)
///
///       (��� ������ ������ ����������� ����������)
///       - ���������, ��������� �� ������ ������ ���������� � �������� ����������
///       - ���� ��:
///           - ������� ����� ������� �������� �������, ��������� �������, ���������� � parent,
///             ��������� � ������ ������ �� ��� ������������� ������� ������� �������
///             ������������ � parent �������� �����������
///
var
    node
   ,nodeObjects      // ������ ���� �������� ������������
//   ,nodeStruct       // ������ ��������� ������������
   ,nodeSection
   ,nodeSectionObject
            : IXMLNode;


    i, j, k, l, m     // �����. ����� ������...
   ,isp_column_count  // ���������� �������� ��� ����������� ����������, ������������
                      // ��� ���������� ������ ����������
   ,IspID             // id ��������� �������� ������������ ��� �������� ����������
   ,ispol             // ����������� ����� ���������� �� number � blockNumber
            : integer;

    mark
   ,name
   ,comment
   ,mass
   ,partID            // �������� � ����������� ���������� [nft].[dbo].[mat].imbase_key

   ,tmp
            : string;

    function GetIspol( ispol: integer ): integer;
    /// �� ������ � ����� ��������� ����������.
    /// ���������, ���� �� ���������� � ����� �������
    /// ���� ��� - �������, ����� ������ �������
    /// ���������� ���������� id ��� ������ � ������
    ///
    /// ��������� ��� ����������� ����� ���������� ������ ���������� ����������,
    /// ��� ��������� ����������, �� ���� ����������
    var
        i : integer;
        prefix: string;
    begin
        result := 0;

        /// ��� ���������� ����� ������������, ����� ������ �������� � ����� ����������
        /// ����� �� ���� �� ���������
        if parent <> 0 then exit;

        // ���� ���������� ����� ������������
        for I := 0 to High(fArray) do
        if (fArray[i].parent = IspID) and (fArray[i].ispol = ispol) then
        begin
            result := fArray[i].child;
            exit;
        end;

        // ���� ����� �� ���� - ������ ���������� ��� ���. �������

        // �� ������ ���������� ��������� ������� ����������
        prefix := '';

        if   ispol in [2..10]
        then prefix := '-0'+IntToStr(ispol-1);

        if   ( ispol > 10 )
        then prefix := '-'+IntToStr(ispol-1);

        // ��������� ����������
        result := AddArrayElem(
            IspID,     // parent
            GetID,     // child
            ispol,
            FindObject( GetStampData( FIELD_MARK ) + prefix, GetStampData( FIELD_NAME ), IntToStr(KIND_ISPOLN) ), //bd_id
            0,         // prj_id

            '��������',
            '����������',
            GetStampData( FIELD_MARK ) + prefix,
            GetStampData( FIELD_NAME ),
            '1',       // count
            GetStampData( FIELD_MASS ),
            GetStampData( FIELD_COMMENT ),
            '',        // material
            fArchivename,
            '',         // id_�����
            ''          // id ���������
        );

    end;

{    function GetMaterial( mark: string ): string;
    /// � ������ ���������������� ������ ���� ������ ��� ���������� �����������
    /// � ���������� �������� ���������, ���� ������
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
    /// node - ������, ���������� ������ <section>
    var
        j, k, l, m     // �����. ����� ������...
                : integer;
    begin
        // ��� ������� �������
        for j := 0 to node.ChildNodes.Count - 1 do
        begin
            // �������� ���� ������ �� ����� ���������� ���������
            nodeSection := node.ChildNodes[j];

            // ��� ������� ������� �������
            for k := 0 to nodeSection.ChildNodes.Count - 1 do
            begin
                // �������� ������ �� ������
                nodeSectionObject := nodeSection.ChildNodes[k];

                // ���������, �� ��������� �� ������ � ������� ������������
                if not IsProcessed( nodeSectionObject.Attributes['id'] ) then

                // ���� ��� �� id ����� ������� ��������
                for l := 0 to nodeObjects.ChildNodes.Count - 1 do
                if nodeObjects.ChildNodes[l].Attributes['id'] = nodeSectionObject.Attributes['id'] then
                begin

                    // ���������� ������ ������� � ���� ���� � �����������, �� ������� �����
                    // ���������� � ���������� � �������� ���������� ���������
                    // ������ �������:
                    //  <object id="283354985543.000000" modified="0">
                    //      <section number="20" subSecNumber="0" additionalBlockNumber="0" additionalSecNumber="0" nestingBlockNumber="0" nestingSecNumber="0"/>
                    //      <columns>
                    //          <column name="������" typeName="format" type="1" number="1" blockNumber="0" value="A4" modified="0"/>
                    //          <column name="�������" typeName="pos" type="3" number="1" blockNumber="0" value="15" modified="0"/>
                    //          <column name="�����������" typeName="mark" type="4" number="1" blockNumber="0" value="��-01-58.008" modified="0"/>
                    //          <column name="������������" typeName="name" type="5" number="1" blockNumber="0" value="��������" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="1" blockNumber="0" value="4" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="2" blockNumber="0" value="4" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="3" blockNumber="0" value="4" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="4" blockNumber="0" value="4" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="5" blockNumber="0" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="6" blockNumber="0" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="7" blockNumber="0" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="8" blockNumber="0" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="9" blockNumber="0" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="10" blockNumber="0" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="1" blockNumber="1" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="2" blockNumber="1" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="3" blockNumber="1" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="4" blockNumber="1" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="5" blockNumber="1" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="6" blockNumber="1" value="8" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="7" blockNumber="1" value="16" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="8" blockNumber="1" value="16" modified="0"/>
                    //          <column name="����������" typeName="count" type="6" number="9" blockNumber="1" value="16" modified="0"/>
                    //      </columns>
                    //      <additionalColumns>
                    //          <column name="�����" typeName="massa" type="8" number="1" blockNumber="0" value="2,02" modified="0"/>
                    //          <column name="ID PartLib" typeName="user" type="10" number="4" blockNumber="0" value="i60000010860BC0000A3" modified="0"/>
                    //      </additionalColumns>
                    //  </object>

                    mark := '';
                    name := '';
                    comment := '';
                    mass := '';
                    partID := '';


                    // ���������� �������� ����, ���� ��������� ����������, ��������� ����� ��� ����� ����
                    // ������ ������������� ���� ���� ����������
                    for m := 0 to nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes.Count - 1 do
                    begin

                        // �������� �����������
                        if   nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'mark'
                        then mark := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'] );

                        // �������� ������������
                        if   nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'name'
                        then name := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'] );

                        // �������� �����������
                        if   nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'note'
                        then comment := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'] );

                    end;

                    if name = '����� �8-6�.5.019 ���� 5915-70' then
                       name := name;

                    // ���������� �������������� ����, ���� ����
                    for m := 0 to nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes.Count - 1 do
                    begin
                        tmp := nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['typeName'];

                        // �������� �����
                        if   tmp = 'massa'
                        then mass := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['value'] );

                        // �������� �������� � ����������� ����������, ���� ����
                        if (tmp = 'user') and
                           (nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['name'] = 'ID PartLib')
                        then partID := ClearMacros( nodeObjects.ChildNodes[l].ChildNodes['additionalColumns'].ChildNodes[m].Attributes['value'] );
                    end;

                    // ����� ��������� ���� �������� ������, ��������� ����������
                    for m := 0 to nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes.Count - 1 do
                    begin

                        // ��������� �������� ����������, �� ����� number � blockNumber ���������� ���������� � �������� ���������
                        if nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['typeName'] = 'count' then
                        begin

                            ispol :=
                                    StrToIntDef(nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['number'], 0) +
                                    StrToIntDef(nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['blockNumber'], 0) *
                                    isp_column_count;

                            // ��������� ������� ������ ���� �� ������ ���������� (�������� ������� ������������)
                            // ��� ���������� ������ � �������� ������ ������ ��� ���� (�������� ��������������� ������������)
                            if (ispoln <> 0) and (ispol = ispoln) or
                               (ispoln = 0)
                            then
                                AddArrayElem(
                                    ifthen( parent <> 0, parent, GetIspol( ispol ) ),
                                                                                    // parent (����������/��������� ��������)
                                    GetID,                                          // child
                                    ispol,
                                    FindObject(mark, name, nodeSection.Attributes['text']), // bd_id
                                    FindObject(mark, name, nodeSection.Attributes['text'], true), // prj_id

                                    nodeSection.Attributes['text'],                 // ��� ������� / ��� �������
                                    ifthen( nodeSection.Attributes['text'] = '��������� �������', '����������', '' ),
                                    mark,
                                    name,
                                    nodeObjects.ChildNodes[l].ChildNodes['columns'].ChildNodes[m].Attributes['value'], // count
                                    mass,
                                    comment,
                                    '',//GetMaterial( mark ),                            // material
                                    '',                                             // ����������� ����
                                    nodeObjects.ChildNodes[l].Attributes['id'],      // id_�����
                                    partID                                           // id ���������
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
        error := lE('�� ������������������ XML ��������');
        exit;
    end;

    // ��������� ������� � ������������� �������� ��������, ����� ���� �� ������� ��� ������
    try
        if
            (fRootNode.ChildNodes['spcDescriptions'].ChildNodes.Count = 0 ) or
            (fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes.Count = 0 ) or
            (fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes.Count = 0 )
        then
            Raise Exception.Create('�� ���������� ���� ������������');
    except
        error := lE('���� �� �������� �������������, ���� �������� ������������');
        exit;
    end;

    // ���������� ���������� �� ��������� ���������� ������������.
    // ��������� �� ������ ������, ��� ���� � �� �� �������� �����
    // ���������� � ������ ������, �� �������� ����� �����������
    // ������ ���� ��� ��� ������� ���������, ���� �� �������� ���� ������
    SetLength(fProcessed, 0);

    // �������� ������ � ���������� �������� ��� ������ ����������
    node := fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['style'].ChildNodes['columns'];

    isp_column_count := 0;
    for I := 0 to node.ChildNodes.Count - 1 do
    if  (node.ChildNodes[i].Attributes['typeName'] = 'count')
    then isp_column_count := max( isp_column_count, StrToIntDef(node.ChildNodes[i].Attributes['number'], 1));


    // ���� ����� �������� ���������� �� �����, ������� �������� ������� ������������
    // ��� �������� �������
    if ( Length(fArray) = 0 ) and ( parent = 0 )
    then
       IspID := AddArrayElem(
            0,         // parent
            GetID,     // child
            0,         // ����������
            FindObject( GetStampData( FIELD_MARK ), GetStampData( FIELD_NAME ), IntToStr(KIND_SPECIF) ),         // �������� id � ����
            0,

            '��������',
            '������������',
            GetStampData( FIELD_MARK ),
            GetStampData( FIELD_NAME ),
            '1',       // count
            GetStampData( FIELD_MASS ),
            GetStampData( FIELD_COMMENT ),
            '',        // material
            fArchivename,
            '',         // id_�����
            ''
        );

    // ��� �������� ����� ������������ ������� ������� ��������� ����� �������.
    // ������ ��� ����, ����� � ���� ��������� ��������������� ��������
    if ( Length(fArray) = 0 ) and ( parent <> 0 )
    then
       IspID := AddArrayElem(
            0,         // parent
            parent,    // child
            ispoln,    // ����������
            parent,    // �������� id � ����
            0,

            '��������� �������',
            '����������',
            fMark,
            '',
            '',        // count
            '',
            '',
            '',        // material
            '',        // ����������� ����
            '',         // id_�����
            ''
        );

    // �������� ������ ���� ��������
    nodeObjects :=  fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcObjects'];

    // ���������� ��������� ������������ ��� ����, ����� ����� ������������� � ����� �������
    // ���������� ������, � ������ ������ �� ����. � ����� ��������� ������� ����� ���������� ���
    // ������ ��������� (� ������������ � ����� ����������� ����� ������������� ������� <block>):
	//		<spcStruct>
	//			<block text="�����. ������. - 01 02 03 04 05 06 07 08 09">
	//				<section text="������������">
	//					<object id="261786785160.000000" text="��-01-58.000 ��  ����. ��������� ������"/>
	//				</section>
	//				<section text="��������� �������">
	//					<object id="187698667038.000000" text="��-01-58.010  �����"/>
	//				</section>
	//				<section text="������">
	//					<object id="314150522817.000000" text="��-01-58.001  �����"/>
	//					<object id="310670566502.000000" text="��-01-58.001-01  �����"/>
	//					<object id="310670566602.000000" text="��-01-58.001-02  �����"/>
	//				</section>
	//				<section text="����������� �������">
	//					<object id="228253403033.000000" text="���� � ������������ �������� �12x40-5.6-A9A  ���� � ��� 4017-2013"/>
	//				</section>
	//				<section text="���������">
	//					<object id="339336657291.000000" text="����� 1250�600�50 TS 034 Aquastatik"/>
	//				</section>
	//			</block>
	//			<block text="�����. ������. 10 11 12 13 14 15 16 17 18">
	//				<section text="������������">
	//					<object id="261786785160.000000" text="��-01-58.000 ��  ����. ��������� ������"/>
	//				</section>
	//				<section text="��������� �������">
	//					<object id="187698667038.000000" text="��-01-58.010  �����"/>
	//				</section>
	//				<section text="������">
	//					<object id="310670567402.000000" text="��-01-58.001-10  �����"/>
	//					<object id="310670567502.000000" text="��-01-58.001-11  �����"/>
	//				</section>
	//				<section text="����������� �������">
	//					<object id="228253403033.000000" text="���� � ������������ �������� �12x40-5.6-A9A  ���� � ��� 4017-2013"/>
	//					<object id="349041543620.000000" text="����� ������������ ����������  ���� ISO 4032 �12-5-B9A"/>
	//				</section>
	//				<section text="���������">
	//					<object id="339336657291.000000" text="����� 1250�600�50 TS 034 Aquastatik"/>
	//				</section>
	//			</block>
	//		</spcStruct>

    // ���� � ��������� ������������ ������ <block>, �� ������� <section> ��������� ��
    // ������� ������ � ����� ���������� ������ ���� ��������, ���������� � �������� ��������� ��������
    // ��������� <block>
    if   fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes[0].NodeName = 'block'
    then
        for i := 0 to fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes.Count - 1 do
        ProcessSections( fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'].ChildNodes[i] )
    // �����, ��� ������� ������������ � ����� ����������� � � �������� ���������
    // ���������� �������� ������ <spcStruct>, ��������������� � ������� � ��������� ��� <section>
    else
        ProcessSections( fRootNode.ChildNodes['spcDescriptions'].ChildNodes['spcDescription'].ChildNodes['spcStruct'] );

    result := true;
end;

function TKompasManager.ScanFiles(path, filter: string; pass_filter: string = ''): boolean;
/// ����� ��������� ���� ��� ��������� ��������� ����� �� ������� ������
/// ������ � ���������� �� �������� ������ � ������ fFileArray
///
///    path - �������� ����� (������ ����� �������) ��� ������
///    filter - ����� ������ �� ���������:
///        '' - �� ������ � ���������
///        '*.*' - ������ �� ���� ���������
///        �������� ������ - ����� ��� ������ �����. ��������� ��������� ����� ����� �������
///    pass_filter - ����� �����/���� �����, ������� ��������� �� ������ ������ ������
///        �� ��� ��������� ����� ����� ������������� ������������� ����� ������ ��
///        ����� filter. ��������� ��������� ����� ����� �������
var
    paths
   ,filters
   ,pass_filters
   ,dir_full_list  /// ������ ����� �������������� ��� ������� ����=��������
                   /// ��� �������� ��������� ������ � ���������� ��������������
                   /// �������� ������. ��� ���������� � ������� �������������
                   /// ����� ����� ��������������, ��� ��������� �� ������ ��������
            : TStringList;

    dir_list       /// ��������� ������ ��������� �� ������ �������� �� ����� ��
                   /// �������� �����
            : TStringDynArray;

    i, j, p, f
            : integer;

    SR
            : TSearchRec;

    _mark_base     /// ����������� � ������������� ���� ����������� �� �����
   ,_kind          // ��� �������� ���������
            : string;

    function ClearUpMark( mark: string ): string;
    /// � ����� �������� mark ����� ���� ������� ��� ������. �������� ��� ���-��
    /// �����������������: �������� �������, ��������� ���������� ����� �� �������
    begin
        mark := Trim(mark);
        mark := ReplaceStr( mark, 'E', '�');
        mark := ReplaceStr( mark, 'T', '�');
        mark := ReplaceStr( mark, 'O', '�');
        mark := ReplaceStr( mark, 'P', '�');
        mark := ReplaceStr( mark, 'A', '�');
        mark := ReplaceStr( mark, 'H', '�');
        mark := ReplaceStr( mark, 'K', '�');
        mark := ReplaceStr( mark, 'X', '�');
        mark := ReplaceStr( mark, 'C', '�');
        mark := ReplaceStr( mark, 'B', '�');
        mark := ReplaceStr( mark, 'M', '�');
        result := mark;
    end;

    function PresentFile( mark, kind: string ): boolean;
    /// ���� ������� ������������ ����� �� mark � ����
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

    ToLog('>>> ����� ������ ������ � ��������� ������...');

    // ������ ��� ������. ��������� �������� ��������� ��������
    // ����������� ����� ������ � stringlist ��������� ��������� �� �� ��������� ������
    paths := TStringList.Create;
    paths.CommaText := path;

    filters := TStringList.Create;
    filters.CommaText := filter;

    pass_filters := TStringList.Create;
    pass_filters.CommaText := pass_filter;


    /// ������� ��������� ��� ���� ��������� ����������
    dir_full_list := TStringList.Create;

    /// ��������� ������ ��� ������� ����=��������, ��������� �������� ����� � ������
    for I := 0 to paths.Count - 1 do
       dir_full_list.Values[paths[i]] := '1';

    /// ���� ����� ������, ����������� ������������ ��������
    if (filter <> '') then
    for p := 0 to paths.Count - 1 do
    for f := 0 to filters.Count - 1 do
    begin
        try
            dir_list := TDirectory.GetDirectories(trim(paths[p]), trim(filters[f]), TSearchOption.soAllDirectories);

            /// ���������� ��� ��������� �� � �������
            /// ����� ������� ������������
            /// ���� ������ ����� �������������, ������� � ���������� ����� �������
            /// ��� ����� �������� � �����
            for j := 0 to High(dir_list) do
                dir_full_list.Values[dir_list[j]+'\'] := '1';

        except
            on E : Exception do lE( e.Message );
        end;
    end;

    /// ���� ���� ����������, ������� ��� �����
    if pass_filter <> '' then
    for p := 0 to paths.Count - 1 do
    for f := 0 to pass_filters.Count - 1 do
    begin
        try
            dir_list := TDirectory.GetDirectories(trim(paths[p]), trim(pass_filters[f]), TSearchOption.soAllDirectories);

            /// � ��� �� ���������� �� � �������, ������������� ��������� ����������
            /// ��� ���� ������ �������, ��� ������ ���������� ����� ����������
            /// ���� �� ����� ������ ���������� ���� ������� ���������, �� �������� ����� ��������
            for j := 0 to High(dir_list) do
                dir_full_list.Values[dir_list[j]+'\'] := '0';
        except
            on E : Exception do lE( e.Message );
        end;
    end;

    /// ���������� ��� ��������� �����
    for i := 0 to dir_full_list.Count - 1 do
    begin
        // ����� ����������
        if dir_full_list.Values[ dir_full_list.Names[i] ] = '1' then

        // ���� ��� ����� �������
        if FindFirst( dir_full_list.Names[i] + '*.*', faAnyFile, SR ) = 0 then
        repeat

            if ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.SPW' ) or
               ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.CDW' ) then
            begin

                /// �������� ������ �����
                if not Init( dir_full_list.Names[i] + SR.Name ) then continue;

                /// �������� � ������� �����������
                _mark_base := ClearUpMark( GetStampData( FIELD_MARK_BASE ) );
                _kind := GetStampData( FIELD_KIND );

                // ��������� ������ ������� � ����� � ������ mark
                if (_mark_base = '') or PresentFile( _mark_base, _kind ) then continue;

                /// ��������� ���������� � ����� � ������ ���������
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

    ToLog('>>> ��������� ������ ' + IntToStr(Length(fFileArray)) + ' ������ ������.');

    result := true;
end;

function TKompasManager.SetupMemtable(memtable: TMemTableEh): boolean;
/// ������������� ��������� ��� ���������� �������� �� �������� �������
/// ������ ��������� �������� � ������� DBGridEh, ������� ����� ��������
/// ������ � memtable ��������� �� � ���� ������
begin

    Memtable.Close;

    Memtable.FieldDefs.Clear;

    /// ������� ����� �����. ����� �������. ��� ������� ��������� ��� ��������
    /// ������ � ����� Memtable.AppendRecord ��� �������� � �������
    Memtable.FieldDefs.Add('kind',      ftInteger, 0, false);   // ��� ������� �������� (������, ������, ..)
    Memtable.FieldDefs.Add('subkind',   ftInteger, 0, false);   // ��� ������� �������������� (������������, ����������)
    Memtable.FieldDefs.Add('mark',      ftString,  100, false);  // �����������
    Memtable.FieldDefs.Add('name',      ftString,  1000, false);  // ������������
    Memtable.FieldDefs.Add('count',     ftString,  10, false);   // ����������
    Memtable.FieldDefs.Add('mass',      ftString,  10, false);   // �����
    Memtable.FieldDefs.Add('comment',   ftString,  1000, false);  // ����������
    Memtable.FieldDefs.Add('material',  ftString,  200, false);  // �������� (���������� � �������)
    Memtable.FieldDefs.Add('linked_file',ftString, 200, false);   // ���� � ��������������� ������� (������/������������)
    Memtable.FieldDefs.Add('id',        ftString,  50, false);   // ���������� id � ����� ������������

    Memtable.FieldDefs.Add('child',     ftInteger, 0, false);   // ����������� ��� �������� ����������� id
    Memtable.FieldDefs.Add('parent',    ftInteger, 0, false);   // ����������� ��� �������� id ��������
    Memtable.FieldDefs.Add('ispol',     ftInteger, 0, false);   // ����� ����������
    Memtable.FieldDefs.Add('bd_id',     ftInteger, 0, false);   // id � ����, ���� ������ ����������
    Memtable.FieldDefs.Add('imbaseKey', ftString,  100, false); // ������ �� ���������� ���������� � ���� NFT
                                                                // ��������� ��� �������� ���� ��������, ������ ��� ����������� �������
    Memtable.FieldDefs.Add('mat_id',    ftInteger, 0, false);   // id ������ � ����������� ���������� � ���� NFT
                                                                // ����������� ��������� �������� �� ������� imbaseKey

    /// ����������� ����������� � ���� ������
    Memtable.TreeList.Active := true;
    Memtable.TreeList.FullBuildCheck := false;
    Memtable.TreeList.DefaultNodeHasChildren := false;
    Memtable.TreeList.KeyFieldName := 'child';
    Memtable.TreeList.RefParentFieldName := 'parent';

    /// ������� ������ ������� ���������, �������� � �������� ������
    Memtable.CreateDataSet;

    Memtable.Open;

end;

function TKompasManager.ExtractFile(archive_name: string; file_name: string = DEF_META_FILE ): boolean;
/// ��������� ��������� ���� �� ������ � �������� �����
Var
    ZF: TZipFile;
begin
    result := false;
    error := '';
    fFilename := '';

    // ������������� ������� �������� �����
    if Not DirectoryExists( fTempPath ) then ForceDirectories( fTempPath );

    if fTempPath = ''                   then error := lE('�� ������� ����� ��� ���������� ����� �� ������');
    if Not DirectoryExists( fTempPath ) then error := lE('����� "'+fTempPath+'" ��� ���������� ����� �� ������ �� ����������');
    if Not FileExists( archive_name )   then error := lE('���� ������ "'+archive_name+'" �� ����������');
    if Trim( file_name ) = ''           then error := lE('�� ������� ��� ����� ������������ �� ������');

    if error <> '' then exit;

    /// ������� ���������� ������������� ����, ����� ��������� ���������
    /// ������� ����������
    DeleteFile( fTempPath + file_name );

    // ���������������� ���������� �����
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
        error := lE('�� ������� ������� ���� "'+file_name+'" �� ������ "'+archive_name+'"' + sLineBreak + error);
        exit;
    end;

    fFilename := file_name;
    fArchivename := archive_name;

    result := true;
end;

function TKompasManager.GetXMLObject(var doc: IXMLDocument; var root_node: IXMLNode; filename: string = ''): boolean;
///  ��������� ��������� ��� ��������� ������������� ���� � ����������
///  ������-���������� � ������������ � ���� �������
label
    ext;
begin

    lC('GetXMLObject (' + filename + ')');

    result := false;

    // ���� ���� �� ������, �������, ��� ��� ������ ��� ���� �� ����������
    // ���������� ����� ������ ������ ���������� xml ����� �� ������ ExtractFile
    if ( Trim(filename) = '' ) then filename := fTempPath + fFilename;

    if ( Trim(filename) <> '' ) and not FileExists( filename ) then
    begin
        error := lE('�� ������ ��� �� ���������� ��������� ����: ' + filename );
        goto ext;
    end;


    try
        // ������ � ������ ����
        doc := TXMLDocument.Create(nil) as IXMLDocument;
        doc.LoadFromFile( filename );
        doc.Active := true;

        // �������� �������� �������
        try
            root_node := doc.DocumentElement;
        except
            on E: Exception do
                error := lE('�� ������� �������� �������� ������� XML ����� ' + filename + sLineBreak + E.Message );
        end;

    except
        on E: Exception do
            error := lE('�� ������� ��������� XML ���� ' + filename + sLineBreak + E.Message );
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

    // ���� ���� �� ������, �������, ��� ��� ������ ��� ���� �� ����������
    // ���������� ����� ������ ������ ���������� xml ����� �� ������ ExtractFile
    filename := fTempPath + DEF_INFO_FILE;

    if not FileExists( filename ) then
    begin
        error := lE('�� ������ ��� �� ���������� ����: ' + filename );
        exit;
    end;


    /// ���� ���������� ����� � �������� ��� ini, ��������������� ����� ��� ��
    /// ������������. ��� ������� ������ ini.ReadString('FileInfo', 'AppVersion', '');
    /// ������������ GetLastError '�� ������� ����� ��������� ����'. ��� ���
    /// ini := TInifile.Create(filename) ������������ ���������, ������ ���������,
    /// �.�. ���� ���������� � ��������. ��������, ��� ������� � ���������� �����.

    /// ������� �������� ����� TStringList ��� ������� ��������� ��������

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
    /// ���� � ����� ����������� ���������� ���������� ����: -02, -34 � �.�.
    reg:=TRegEx.Create('\-\0?\d+$');

    // �������� �� �������� ����� �������� �����, ������� ��� ���������
    maches := reg.Matches( mark );

    if maches.Count > 0
    then
    begin
        tmp := copy( maches[0].Value, 2, length(maches[0].Value) );
        result := StrToIntDef( tmp, 1 ) + 1;
        // ���������� ��������� ���������� � ����� ������������ ���� � 1, �
        // ������� � ��������������� �������� '-00'. ��������� ��� ����������
        // ���������� �����, � ����� �������� ��������� �������
    end
    else result := 1;

end;

function TKompasManager.GetStampData(field: integer): string;
/// �� ���������� id ��������, ���� � ���������� �������� �� xml
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

    // ������� ������, ������ �� ������ �����
    if (fVersion = VERSION_17) OR (fVersion = VERSION_16) then
    begin
        if not Assigned(fRootNode) then
        begin
            error := lE('�� ������������������ XML ��������');
            exit;
        end;

        for i := 0 to fRootNode.ChildNodes['properties'].ChildNodes.Count - 1 do
        if fRootNode.ChildNodes['properties'].ChildNodes[i].Attributes['id'] = version_field
        then
            result := ClearMacros( fRootNode.ChildNodes['properties'].ChildNodes[i].Attributes['value'] );
    end;



/// � 18 ������ �������� ��������� XML ����, ���������� �� ����� ����������(?)
/// ���������� �� �� ������ �������, �� ����� ��������� ��������, � ������� ���������� ������
/// ��������������� ������ ������ �� 17 ������ ������
///
/// ������ <product> �������� �������� [thisDocument], ���������� �� ������ �� ��������,
/// ������� � �������� ������ ������
///
/// <?xml version="1.0"?>
/// <document version="1.2" state="ready">
/// 	<descriptions>
///     ....
/// 	</descriptions>
/// 	<dictionaries />
/// 	<product id="6e8dea49-d132-4784-8b94-a5bb3020b92c" thisDocument="870673ca-ff9a-4a85-9ff9-54da24abfd94">
/// 		<document id="870673ca-ff9a-4a85-9ff9-54da24abfd94">
/// 			<property id="name" value="���� ���������" type="string" />
/// 			<property id="marking">
/// 				<property id="base" value="���2.02.01.300" type="string" />
///                 .....
/// 			</property>
/// 			<property id="count" value="1" prodCopy="true" type="int" />
/// 			<property id="mass" value="1.29363" prodCopy="true" type="double" />
/// 			<property id="accuracyClass" value="m" prodCopy="true" type="string" />
/// 			<property id="specRoughSign" value="0" prodCopy="true" type="int" />
/// 			<property id="specRoughValue" value="" prodCopy="true" type="string" />
/// 			<property id="stampAuthor" value="�������" type="string" />
/// 			<property id="checkedBy" value="�������" type="string" />
/// 			<property id="rateOfInspection" value="������" type="string" />
/// 			<property id="approvedBy" value="������" type="string" />
/// 			<property id="format" value="A4" type="string" />
/// 			<property id="sheetsNumber" value="1" type="int" />
/// 			<property id="fullFileName" value="\\Fileserver\���\���.���\������ 2\���2.00.00.000\���2.02.00.000 ������� ���������������\���2.02.01.000 ���������\���2.02.01.300.spw" type="string" />
/// 		</document>
///         ...
/// 	</product>
/// </document>

    if fVersion = VERSION_18 then
    begin
        if not Assigned(fProjectRootNode) then
        begin
            error := lE('�� ������������������ XML ��������');
            exit;
        end;


        doc_id := fProjectRootNode.ChildNodes['product'].Attributes['thisDocument'];

        /// ���������� �������� <product> -> <document>
        /// ���� �������� �������� �������
        for i := 0 to fProjectRootNode.ChildNodes['product'].ChildNodes.Count - 1 do
        if fProjectRootNode.ChildNodes['product'].ChildNodes[i].Attributes['id'] = doc_id
        then
        begin

            /// � 18 ������ ��� ���� ����������� �� ��� ���������
            /// ����������� �������� ��������� �� �����-��������
            if field = FIELD_KIND then
            begin
                result := fFileType;
                exit;
            end;

            // �������� ����� ����� ���������
            prop := fProjectRootNode.ChildNodes['product'].ChildNodes[i].ChildNodes;

            /// ���� ������ ������� ������������ ����
            for j := 0 to prop.Count - 1 do
            if (prop[j].Attributes['id'] = version_field) and prop[j].HasAttribute('value')
            then result := ClearMacros( prop[j].Attributes['value'] );

            if field = FIELD_MARK then result := GetMark(true);  /// ������ �����������
            if field = FIELD_MARK_BASE then result := GetMark(false); /// ������� �����������

        end;
    end;

end;

function TKompasManager.GetVersionField(field: integer): string;
/// �� �������������� ������ ���� �������� ��� ��� ��� ������� ������
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

    /// ��������� ������� �������� � ������� ������������ � ������� ��������.
    /// ��������� xml ���� ���������� ��������� ��� ������� �� ��������� ������������,
    /// � � ������ �������� �� ����� ���� ��������� ��������� ���������� ��������
    for I := 0 to High(fArray) do
    if (fArray[i].mark = mark) and (fArray[i].name = name) and (fArray[i].parent = parent) then
    begin
        result := fArray[i].child;
        break;
    end;

    // ���� ����� �� ���������� - �������
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


        // ���������� ���������� id ��������
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
    result := ReplaceStr( result, '@/', ' ');  // ������� ���������� ������ ������� �� ������� ������
    result := ReplaceStr( result, '$d', '');   // ������� ���������� ������ ������� �� ����������� � ���� �������
    result := ReplaceStr( result, '@1~', '');  // ������� ���������� ������
    result := ReplaceStr( result, '@2~', '');  // ������� ���������� ������
    result := ReplaceStr( result, '$|', '');  // ������� ���������� ������
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
/// ����� ����������� �������� ���� ��� �������� �� ������
/// ������� TKompasManager ������ ��� ����������� ������������ ��������� ���
/// �������� ���������� ��������� ��� ������������� ������������ � ��������
/// ������� ������� ����� �����:
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

            ToLog( '('+IntToStr(i)+'/'+IntToStr(High(fArray))+') �������� ��������� : '+ fArray[i].name + ' (key: '+fArray[i].part_id+')' );

            imbaseKey := '';
            material := '';

            if assigned(ds) and ds.Active then ds.Active := false;

            /// ���� �� ���������� ����
            if Trim(fArray[i].part_id) <> '' then
            ds := mngData.GetMaterialRecord( 'Imbase_Key', fArray[i].part_id );

            /// ���� ��� ��� �� ����� �� �������, ���� �� ������������
            if ( StrToIntDef(fArray[i].kind, 0) <> KIND_DETAIL )
               and (not assigned(ds) or not ds.Active or (ds.RecordCount = 0)) then
            ds := mngData.GetMaterialRecord( 'm', fArray[i].name );

            /// �������� ������, ���� ����
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
/// ��������� ������� � ���� ������� �� ����������� � �����

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

         // �� ������� � �������
         if result = -1 then
         begin

             /// ���� ������ � �������
             result := mngData.GetProjectObjectBY( fProjectID, field, Trim( value ), kind );
             kd_id := mngData.GetObjectBY( field, Trim( value ), kind );

             /// ���� �� ������, ���� � ��
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

    // ����������� ��������� ��� � ��������, ���� ����������
    if   length(kind) > 2
    then kind := GetKind( kind );

    if Trim( mark ) <> ''
    then result := getObjectID('mark', mark)
    else result := getObjectID('name', name);
end;

function TKompasManager.GetKind( name: string ): string;
begin
    result := '0';
    if name = '������������'        then result := '10';
    if name = '����������'          then result := '11';
    if name = '������������'        then result := '12';
    if name = '��������'            then result := '8';
    if name = '��������� �������'   then result := '7';
    if name = '������'              then result := '4';
    if name = '����������� �������' then result := '5';
    if name = '������ �������'      then result := '6';
    if name = '���������'           then result := '3';
end;


initialization
    mngKompas := TKompasManager.Create;

finalization
    mngKompas.Free;


end.
