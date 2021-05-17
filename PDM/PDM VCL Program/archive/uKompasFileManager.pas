unit uKompasFileManager;

interface

uses
    ksTLB, ksConstTLB, LDefin2D,  // ������ ������

    ComObj, SysUtils, Math, RegularExpressions, StrUtils;

const

    // �������� ������� � ������� SpecDataArray
    FIELD_KIND   =  0;          // ��� ������� (������, ������,.. )
    FIELD_MARK   =  1;          // ����������� ������� (��������, '���5.01.02.120� ���.7774')
    FIELD_NAME   =  2;          // ������������ ������� (��������, '���������� ��������')
    FIELD_ISP    =  3;          // ������ ������������ ���������� �������� ����������� (��������, '��-01-58.000-16')
    FIELD_COUNT  =  4;          // ���������� � ����������
    FIELD_COMM   =  5;          // �����������
    FIELD_MASS   =  6;          // �����
    FIELD_MAT    =  7;          // ��������, ��������� � ����� ������������
    FIELD_NUMBER =  8;          // �������������� id
    FIELD_CHILD  =  9;          // ������������ ���������� id ��� ������������ ������. �������� �� ������� ��-�� ���������� ��������
    FIELD_PARENT = 10;          // ������ �� FIELD_CHILD ������ ��� ������������ ������ �����������
    FIELD_ID     = 11;          // �������� id ������� � ����, ���� ����.
                                // �������� �� ��, ����� ��������������� � ������ ������� �������� � ����
                                // � �� ����������� ��������� ��� �������� ��������� � ����
    FIELD_FILE   = 12;          // ����������� � ������� ����, ���� ���������.
                                // ��������, ������ ������. ���� ���� ��������� - ������ ���� ����� ����� � �������
    FIELD_SPEC_FILE = 13;       // ��� ����� ����������� ������������, ���� ����
    FIELD_MATERIAL  = 14;       // ��������, ��������� � ����������� ����� �������

    // ������ ��������� �������� ������������
    STATE_NOT_LOADED = 1;    // �� ���������
    STATE_LOADING    = 2;    // �������� � ��������
    STATE_LOADED     = 3;    // �������� ���������

    // �������� ������� ����� � ��������� ������ � ������ ������ ����� ������
    STAMP_NAME_FIELD     = 1;
    STAMP_MARK_FIELD     = 2;
    STAMP_MATERIAL_FIELD = 3;
    STAMP_MASS_FIELD     = 5;

    // ������ ����������� ����� �� ����������� � ������� � ����������� �������������
    DND_MODE_NULL         = 0;        // ��� ���������� ������ ��� ��������
    DND_MODE_ADD_MATERIAL = 1;        // ������� ��������� �� ������

    BUFF_FIELD_VALUE = 0;
    BUFF_KIND        = 1;
    BUFF_BD_VALUE    = 2;

type

    TStampData = record
        Name
       ,Mark
       ,Material
       ,Mass
                : shortstring;
    end;

    TSpecDataArrayRow = array [0..14] of variant;
    /// ������� ������� SpecDataArray, �������� ������ ������ ������� �� ������������

    TBuffRow = array [0..2] of string;

    TKompasManager = class
      private
        Kompas: KompasObject;

        SpecDataArray: array of TSpecDataArrayRow;
        ///    ������ ������, ����������� �� ����� ������������.
        ///    �������� ������������������ ������, ������� ��� ���������� ���������:
        ///    ������������� ����, �������� �������� � ����, ���������� ���������
        ///    ���������� ����� ��������� ��������� FIELD_XXX
        ///
        ///    ��� ������� ������, ���������� ������ ��� �������� ������������, ���
        ///    � ������ ������������ ��������� �������� (��������� ������, ����������, ����������),
        ///    ���� ����

        FindBuff : array of TBuffRow;
        // ����� ��� ����������� ��������� ����������� ��������� ������� �����������
        // ������� � ����. ������ ���������� ������� �� �������. ����� �������� ���������
        // � ����, ������� ������������ ���� ������

        GlobID: integer;
        ///    ������� ��� ������� ��������� id ���� �����������
        ///    ������� �� ������. ������������ ��� ���������� ������ �����������
        ///    ��������� ������, ������������, ���������� � �� �������

        function GetId: variant;
        function GetKind( name: string ): string;
        ///    �� ����� ���� ������� �� ������������ �������� ����� ���� �� ����
        ///    �� ����� ���� ����������� ������. ���������, ����� ��������� � �������
        ///    ������� objec_classificator
        function FindObject( mark, name, kind: string): integer;
        function ReadSpecStamp( stamp : ksStamp; col: integer ): string;

        function ReadStamp( stamp: ksStamp ): TStampData;

      public
        CurrElem: integer;

        procedure CleanUp;
        function StartKompas( show: boolean ): boolean;
        procedure StopKompas;

        // �����������
        function OpenSpecification( filename: string ): ksSpcDocument;
        function OpenDocument2D( filename: string ): ksDocument2D;

        function CloseSpecification( var SpcDocument: ksSpcDocument ): boolean;
        function CloseDocument2D( var Document2D: ksDocument2D ): boolean;

        function GetSpecificationStampData( SpcDocument: ksSpcDocument ): TStampData; overload;
        function GetSpecificationStampData( filename: string ): TStampData; overload;

        function GetDocument2DStampData( Document2D: ksDocument2D ): TStampData; overload;
        function GetDocument2DStampData( filename: string ): TStampData; overload;

        function ReadSpecificationToArray(filename: string): boolean;

    end;

var
    mngKompas : TKompasManager;

implementation

uses
    uPhenixCORE, uMain;

procedure TKompasManager.CleanUp;
begin
    SetLength( SpecDataArray, 0 );
    SetLength( FindBuff, 0 );
end;

function TKompasManager.ReadSpecificationToArray(filename: string): boolean;
var
    SpcDocument: ksSpcDocument;
    Specification : ksSpecification;
    SpcTuningStyleParam : ksSpcTuningStyleParam;
    DynamicArray: ksDynamicArray;
    DocAttachedSpcParam: ksDocAttachedSpcParam;
    stamp : TStampData;


    SpcObjParam: ksSpcObjParam;

    iterator: ksIterator;            // ������ ��� �������� ��������� � ������������
    item: integer;                   // ������� ��������� ������� � ������ ������������

    str, str2, comma : string;
    value : integer;
    block, isp: integer;

    ispNames: array of string;       // ������ ���� ���� ����������
    ispCount: integer;               // ���������� ���������� � ��������� �����
    ispFullCount: integer;           // ���������� ���������� � ��������� �����
    ispBlockCount: integer;          // ���������� ������ ����������
    ///    � ������������ ���� ����� ���������� ������� � ��� ������� ����������
    ///    ���������� (10 � �����) ��� �� ���������� �� ���� � �����������
    ///    ���� �� ���������. ������ ������� ���������� ������ ������������.
    ///    �.�. ������ 10 �������� ������ ����, 11-20 ������ � �.�.
    ///    �� ����, ��� ��������� ����������� �������

    I
            : Integer;

    ///    ���������� ��� �������� ����������� ��� �������� �� ����� ������� � ������������.
    ///    ��������, � ���������� �������, ��������� ���������� ������� � ��������� ����������� (���� ����)
    ///    ����������� ����� �����, ��� ������������ �������, � ��� �������
    ///    ���������� ���������, ���������� ������ ������������� � ������ ������
    kind
   ,mark
   ,name
   ,note
   ,mass
   ,mat
   ,number
   ,material
   ,lastNumber
   ,lastMark
   ,lastName
   ,lastFilePath
   ,filePath       // ��� ������������ ����� (������ ��� ������)
   ,specFilePath   // ��� ����������� ������������ (spw ����)
   ,SpecBaseMark
   ,WorkDir
   ,lastBaseMark   // ����������� ������� �������� � ������ � ���������� ������� (number)
                   // ������� �������� ������� ����������� ��� ��������� ����������.
                   // ����������� � ���������� ��������� ������ ��� ����������, ������������
                   // �� ������� �����������
            : string;

    function GetIspolNames: integer;
    ///    ��������� ������ ������� ���������� � ���������� �� ����������.
    var
        isp, block : integer;
        name : string;
    begin

        // �������� ���������� ������ ����������
        ispBlockCount := 0;
        name := specification.ksGetSpcPerformanceName( 0, 1, ispBlockCount );
        while name <> '' do
        begin
            Inc( ispBlockCount );
            name := specification.ksGetSpcPerformanceName( 0, 1, ispBlockCount );
        end;


        ispCount := 0;
        ispFullCount := 0;

        // ���������� ��� ��������� �����
        for block := 0 to ispBlockCount-1 do
        begin

            // �������� �������� ������ �������
            isp := 1;
            name := specification.ksGetSpcPerformanceName( 0, isp, block );

            // � ���������� ��� ��������� ���� ����
            while name <> '' do
            begin

                // ����� ����������� ������ �����, ������� ��� ������������ �����������
                ispFullCount := Max( ispFullCount, isp );

                // ��������� ������ ���� ����������
                SetLength( ispNames, Length( ispNames ) + 1 );
                ispNames[ High(ispNames) ] := name;

                // �������� �������� ��� ���������� � �����
                inc(isp);
                name := specification.ksGetSpcPerformanceName( 0, isp, block );

            end;
        end;

        // ���������� ���������� ��������� � ���������/������������ �����
        ispCount := isp - 1;

        result := Length( ispNames );

    end;

    procedure CorrectionIspolNames(basename: string = '');
    ///    ����������� ����� ��� ����������� �������������
    ///    ��������� ������ ��� ������� ����� ���� � ������
    ///    �������� �����, ���� ����� �� ����� �����.
    ///    ����� �������, ������� ���:
    ///    [�����], 01, 02, 03,..
    ///    ���� basename �� ������, �� � ���� ����� ������������� ���������,
    ///    ������� ������ ������������ ����������
    var
        i : integer;
        reg: TRegEx;
        maches : TMatchCollection;
    begin

        // ������� ���������, ������ ����� ��������� ����, ������ ������
        reg:=TRegEx.Create('\d+');

        for i := 0 to High( ispNames ) do
        begin

            // �������� �� �������� ����� �������� �����, ������� ��� ���������
            maches := reg.Matches( ispNames[i] );

            // ���� �������, ����������� �������� ������ � ������������� ����, ���� ����������
            // �����, ��� ������ ������� � ������ ����������, �� ������� ������
            if maches.Count > 0
            then ispNames[i] := basename + '-' + ifthen( Length(maches[0].Value) <> 1, maches[0].Value, '0' + maches[0].Value )
            else ispNames[i] := basename;

        end;
    end;

    function ClearMacros(text : string): string;
    begin
        result := text;
        result := ReplaceStr( result, '@/', ' ');  // ������� ���������� ������ ������� �� ������� ������
        result := ReplaceStr( result, '$d', '');   // ������� ���������� ������ ������� �� ����������� � ���� �������
        result := ReplaceStr( result, '@1~', '');  // ������� ���������� ������
        result := ReplaceStr( result, '@2~', '');  // ������� ���������� ������
    end;

    function trimFull( text: string ): string;
    /// �������� ��� ������� � ��� ������� ������ ������, �������� ������ ��������� �������
    begin
        result := trim( text );
        while pos('  ', result) > 0 do
           result := replaceStr( result, '  ', ' ' );
    end;

    function GetParentByIsp( IspName: string ): integer;
    ///    ������ �� ������������ ������ ���� �������� � ����������, ������
    ///    �� �� ����, ������ ��� ������ ���������� ��������
    var
        i : integer;
    begin
        result := 0;
        for I := High( SpecDataArray ) downto 0 do
        if ( SpecDataArray[i][FIELD_MARK] = IspName ) and
           ( SpecDataArray[i][FIELD_KIND] = '����������' ) then
        begin
            result := SpecDataArray[i][FIELD_CHILD];
            break;
        end;
    end;

    function GetConnectedFile(mark, name, ext: string): string;
    ///    �������� ����� ����������� � ������� ������������ ����.
    ///    ��������� ������:
    ///      - �������� � ����� ������������ � ������ �������
    ///          (��������, �� ��� �� ����� ������, � ���������� ������)
    ///      - ���� � ������, ����������� � ������������ � ����� �� �������������
    ///          (��������� ��������� ��������� ������. ���������� ������ ������� ��� � ���� ��� �������)
    var
        SR: TSearchRec; // ��������� ����������
        i: integer;
    begin
        result := '';

        SpcObjParam :=  ksSpcObjParam( kompas.GetParamStruct(ko_SpcObjParam) );
        SpcDocument.ksGetObjParam( item, SpcObjParam, ALLPARAM );
        DynamicArray := ksDynamicArray(SpcObjParam.GetDocArr);

        DocAttachedSpcParam  := ksDocAttachedSpcParam(kompas.GetParamStruct(ko_DocAttachSpcParam));

        if DynamicArray.ksGetArrayCount<>0 then
        begin
            for i := 0 to DynamicArray.ksGetArrayCount - 1 do
            begin
                DynamicArray.ksGetArrayItem(i, DocAttachedSpcParam);
                result := DocAttachedSpcParam.fileName;
            end;
        end;

{        if result = '' then
        begin
            // ���������� ������ ������ ������� � ����� � ����������� �������������
            for I := 0 to High(NearFiles) do
            // ���� ��������� � �������� �������� ������������?
            if NearFiles[i][NEAR_MARK] = mark then
            // ���� ���� ����� ����, ����� ������������ - ���������� ���� ����
            if   (ext = '*') and ( ExtractFileExt( NearFiles[i][NEAR_FILENAME] ) = '.spw' )
            then continue
            else result := NearFiles[i][NEAR_FILENAME];
        end;
}    end;

    function AddSpecRow(kind, mark, name: string; parent: integer = 0): integer;
    /// ���������� � ������ ����������� ������ �������� ������������ ��� ����������
    begin

        SetLength( SpecDataArray, Length( SpecDataArray ) + 1 );

        SpecDataArray[High( SpecDataArray )][FIELD_KIND]   := trimFull( kind );
        SpecDataArray[High( SpecDataArray )][FIELD_MARK]   := trimFull( mark );
        SpecDataArray[High( SpecDataArray )][FIELD_NAME]   := trimFull( name );
        SpecDataArray[High( SpecDataArray )][FIELD_PARENT] := parent;
        SpecDataArray[High( SpecDataArray )][FIELD_CHILD]  := GetID;

        SpecDataArray[High( SpecDataArray )][FIELD_ISP]    := '';
        SpecDataArray[High( SpecDataArray )][FIELD_COUNT]  := '1';

        SpecDataArray[High( SpecDataArray )][FIELD_COMM]   := '';
        SpecDataArray[High( SpecDataArray )][FIELD_MASS]   := '0';
        SpecDataArray[High( SpecDataArray )][FIELD_MAT]    := '';
        SpecDataArray[High( SpecDataArray )][FIELD_NUMBER] := '';
        SpecDataArray[High( SpecDataArray )][FIELD_FILE]   := GetConnectedFile(mark, name, '*');
        SpecDataArray[High( SpecDataArray )][FIELD_SPEC_FILE] := ''; //filename;

        SpecDataArray[High( SpecDataArray )][FIELD_ID]     := FindObject( mark, name, trimFull( kind ) );


        result := SpecDataArray[High( SpecDataArray )][FIELD_CHILD];

        // ��������� �� ������� ������������. ��� �������, ��������� id �
        // ��������� ������ � ����� �������� �������, � �� ������� ��������� � ����
        {!}

    end;

begin
    result := false;

    if not Assigned( Kompas ) then exit;
    if not FileExists( filename ) then exit;

    lM( '�������� ����� ' + filename );

    // �������� ���� �� ����� ������������, ����� �������� ����������� �����
    // ��� �� �������� ������, ��� ��������� ������� ��������� � ����� ������������
    WorkDir := ExtractFilePath( filename );

    // �������� ����� ����������� ������
    SpecBaseMark := '';

    // �������� ��������� ������ �� ��������������
    SpcDocument := ksSpcDocument( Kompas.SpcDocument );

    // ��������� ���� ������������
    if not SpcDocument.ksOpenDocument( filename, 4 ) then exit;
    // 0 - ������� ��������, 1 - ��������� ��������, 3 - ������� ��� ������������� �� ��������� ��������
    // 4 - ��������� ��� ������������� �� ��������� ��������
    // �������� ������ ��� �������� � ��������� ������ - ���������� ��������� ���� � ���������������� � ���������.
    // ��������, � ������� ������ ��������� ������������ ����������� ������������ � ������ ����� ������ ��
    // ������ ���������� ������������ � ���������. � ��������� ������ ��� �������� ������
    // � ������ �� ������������� ����������

    // �������� ������ �� ���� ������������
    specification := ksSpecification( SpcDocument.GetSpecification );

     // ������� "������" ��� �������� �������� � ������ �������� ������������
    iterator := ksIterator( kompas.GetIterator() );
	iterator.ksCreateSpcIterator( '', 0, 0 );

    // ���� ������ ���������� (������������ �����), �������
	if iterator.Reference = 0 then exit;

    // �������� ������ �������
    item := iterator.ksMoveIterator( 'F' );



    // ������������� �������

    // ���� id �� ������, ������ ������ �������� ������������ � ����� ��������
    // �� � ������ ��������� ������ ��� ���������� �������� ��������� � ��� ���
    // ��������� ��������.
    // �������� ���� ���� ��������, ��� ���������� ��������������� ������������
    // ������ �� ��������� � �������� ������������ �������� � �������� �����
    // ����� ������ ����� ��� � ����, � �� ����� ������
    stamp := GetSpecificationStampData( SpcDocument );
    mark := Trim( stamp.Mark );
    name := Trim( stamp.Name );
    SpecBaseMark := mark;

    if   CurrElem = -1
    then CurrElem := AddSpecRow( '������������', mark, name );

    lM('������������: ' + mark + ' ' + name );

    // �������� ������ ���� ���������� � �� ����������
    lM( '����������: ' + IntToStr( GetIspolNames ) );
    // ������������ �����, ������� � ���������
    CorrectionIspolNames( SpecBaseMark );

    // ��������� ����� ����������
    for I := 0 to High( ispNames ) do
    AddSpecRow( '����������', ispNames[i], name, CurrElem );





    ///    �������� ������ � ������ ��� ���������� ���������.
    ///
    ///    ����������� ����� ������������ � ���, ��� ��� ��������� ������ �� ����������
    ///    � ������ ������������ ����� ��� ����������� ������� ��������� ��� ������
    ///    � ��������� ������ ���������� � ����� ����������.
    ///    �.�. ���������� ������, �� ���� �������� �������� �������� �� ����������
    ///    ��������� ����������
    ///
    ///    ����������� ������ � �� ����������� ���������� ��� ������ GetIspolNames

    lastNumber := '';
    lastBaseMark := '';

    while SpcDocument.ksExistObj( item ) <> 0 do
    begin


        // �������� ������� ��������� ������� ��� �������� ����������
        kind  := trimFull( specification.ksGetSpcSectionName( item ) );
        note  := trimFull( ClearMacros( specification.ksGetSpcObjectColumnText( item, SPC_CLM_NOTE,     1, 0 ) ) );
        mass  := trimFull( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MASSA,    1, 0 ) );
        mat   := trimFull( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MATERIAL, 1, 0 ) );



        ///    ������� � mark ������ �������� ��������� ����������� ���, ��� ����
        ///    ��� ��������� ������ ����������� � ������������:
        ///    1)
        ///        '��-01-58.004'
        ///        '��-01-58.004-05'
        ///    2)
        ///        '��-01-58.004'
        ///        '-05'
        ///    ��� �����, �� ������ ������ ������������ ����������� �����, �� ������������
        ///    � �������������. ��� �� ����������� � ���������� ������ � ������� � ������������
        ///    (������ ����� ������) � ����������� ������ ��������.
        ///
        ///    ���������� id ������� (number) ����������� ��� ������, ����� ��� ��������� ���
        ///    ������ mark.
        ///    ��������, � ������ ������ ��������� ������� (��� ������ ���� ����� ������ ������):
        ///        ��-01-58.001-09  �����
        ///        ��-01-58.002     �����
        ///    ��� ����� ������ ���������� ���� ���������� � ����� �����������
        ///    ������� ������ ����������� � ������� ��������
        ///
        lastMark := mark;
        lastName := name;
        lastNumber := number;
        lastFilePath := filePath;

        // �������� ���������� id �������� � ������������
        number := FloatToStr( specification.ksGetSpcObjectNumber( item ) );

        // ���� ��� ������ (��� ������ � ����������), ����� ��� �����������
        name := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ), name);
        name := trimFull( ClearMacros( name ) );

        // ��� ���������� �� ������� �����������. ����� ��� �� ���������� ������������ �������� ����������
        mark := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ), mark);
        mark := trimFull( mark );

        ///    ����������� ����� ����� ������, ��� ��� �� ����� � ������� ������������
        ///    "�� �� �������" ��������, ��� � ���������� ������������ ��� �������� ������-�� �������
        ///    � ��������� '-��' ���� ��� ��� �� ������� ������� � ������, �.�. ��� �� number
        ///    ��������:
        ///        6  ��-01-58.002     �����
        ///           ��-01-58.002-01  �����
        ///           ��-01-58.002-02  �����
        ///    ���� � ��������� ��� ���� �������� �������� �������, �� ��� ��� ����� 6 �����
        if   (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( number = lastNumber ))
        then mark := lastMark + mark

        else
        ///    ��������� ����������� ������������ ������������ � ������������ �������������
        ///    � ������������ ������������ �������. ��� �� ��� ���� ������ �������� �������,
        ///    ����� ������� ���������� ������, �� ���������� number �� ���������
        ///    ��������:
        ///        6  ��-01-58.002  �����
        ///        7           -01  �����
        ///        8           -02  �����
        if   (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( pos('-', mark) = 1 ))
        then
        begin
            // ��-�� ������������� ������ ��������� �������� �����������, ����� ��������������� ���
            // ���������� �� ������ ������. ���� ���� "-��" �����, �������� �� ��� ����������� ���������
            if Pos('-', lastMark) <> 0
            then lastMark := Copy( lastMark, 0, Pos('-', lastMark)-1);

            mark := lastMark + mark;
        end;

        // ��� ����������� � ������ ������� ����������� �� ������������ � ��������.
        // ����� ������� ����� �� ��������� ������� ���� �� ���������
        if  ( kind = '����������� �������' ) or ( kind = '������ �������' ) or ( kind = '���������' )
        then mark := '';

        if number <> lastNumber then
        begin
            lastBaseMark := specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 );

            // ������������
            if ( kind = '��������� �������' ) then
                specFilePath := GetConnectedFile( lastBaseMark, name, 'spw' );
            // ����� ������, ����� ������������
            if ( kind <> '���������' ) then
                filePath := GetConnectedFile( lastBaseMark, name, '*' );

//            material := trimFull( ClearMacros( GetFromNearFile( lastBaseMark, NEAR_MATERIAL ) ) );

        end;


        // ��� �������� ���������� �������� ���������� ��� ��� ����������
        for block := 0 to ispBlockCount - 1 do
        for isp := 1 to ispFullCount do
        if not ((block = ispBlockCount - 1) and (isp > ispCount)) then  // �������� �� ����� ���������� ��������� � ��������� �����

        if specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT, isp, block ) <> '' then // �������� ������ ����������

        begin

            SetLength( SpecDataArray, Length( SpecDataArray ) + 1 );

            SpecDataArray[High( SpecDataArray )][FIELD_KIND]  := kind;

            SpecDataArray[High( SpecDataArray )][FIELD_MARK]  := mark;
            SpecDataArray[High( SpecDataArray )][FIELD_NAME]  := name;

            SpecDataArray[High( SpecDataArray )][FIELD_ISP]   := ispNames[ block * ispFullCount + isp - 1 ];
            SpecDataArray[High( SpecDataArray )][FIELD_COUNT] := specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT,    isp, block );

            SpecDataArray[High( SpecDataArray )][FIELD_COMM]      := note;
            SpecDataArray[High( SpecDataArray )][FIELD_MASS]      := mass;
            SpecDataArray[High( SpecDataArray )][FIELD_MAT]       := mat;
            SpecDataArray[High( SpecDataArray )][FIELD_NUMBER]    := number;
            SpecDataArray[High( SpecDataArray )][FIELD_FILE]      := filePath;
            SpecDataArray[High( SpecDataArray )][FIELD_SPEC_FILE] := SpecfilePath;

            SpecDataArray[High( SpecDataArray )][FIELD_PARENT]   := GetParentByIsp( ispNames[ block * ispFullCount + isp - 1 ] );
            SpecDataArray[High( SpecDataArray )][FIELD_CHILD]    := GetID;
            SpecDataArray[High( SpecDataArray )][FIELD_ID]       := FindObject( mark, name, kind ); // mngData.GetObjectBY( 'mark', mark )
            SpecDataArray[High( SpecDataArray )][FIELD_MATERIAL] := material;
            // �������� ����� ������ � ���������� ����, ����� �������� ������������ ��� ��������

        end;

        // �������� ��������� ������� � ������ ������������
        item := iterator.ksMoveIterator( 'N' );

    end;


    // ����� ����������� ������ � ����
    for I := 0 to High(SpecDataArray) do

        Core.Log.Mess(
            '(' + SpecDataArray[i][FIELD_NUMBER] + ') ' +
            SpecDataArray[i][FIELD_KIND] + ' / ' +
            SpecDataArray[i][FIELD_MARK] + ' / ' +
            SpecDataArray[i][FIELD_NAME] + ' / ' +
            SpecDataArray[i][FIELD_ISP] + ' / ' +
            SpecDataArray[i][FIELD_COUNT] + ' / ' +
            SpecDataArray[i][FIELD_COMM] + ' / ' +
            SpecDataArray[i][FIELD_MASS] + ' / ' +
            SpecDataArray[i][FIELD_MAT] + ' / ' +
            SpecDataArray[i][FIELD_MATERIAL]
        );


    result := true;
end;


function TKompasManager.StartKompas( show: boolean ): boolean;
begin
    result := false;

    Kompas := KompasObject( CreateOleObject('Kompas.Application.5') );

    if Assigned( Kompas ) then
    begin
        /// ��������� ������ � ��������, ��������� ����� ��������� ������������
        /// ���������� ������������ ����� � ��������� ������ ���� ������������
        /// ������ ������. ��� ����, ����� ��������� ������, ���������� ������
        /// ��� ������ ��������. ��� ������� ������� ������������� ��������, ���
        /// ��������� ������� �������.
        Kompas.Visible := show;
        result := true;
    end;

end;

procedure TKompasManager.StopKompas;
begin
    // ������ ������ �� �����
    Kompas.Quit;
    Kompas:=nil;
end;

function TKompasManager.ReadSpecStamp( stamp : ksStamp; col: integer ): string;
///    ����� ��� ��������� �� ��������� ��������
///    �������� �� �������� ���� ������ ������ ���������
var
    da, dai: ksDynamicArray;
    i, j, k, l: integer;
    tlp: ksTextLineParam;
    tip: ksTextItemParam;
    s: string;
begin

if ( stamp.ksOpenStamp <> 0 ) then
  begin
    stamp.ksColumnNumber( col );

    da:=ksDynamicArray( stamp.ksGetStampColumnText( col ) );

    //---������������� ������ ����� � ���� ������ s---
    if ((da<>nil) and (Kompas<>nil)) then
      begin
        i:=da.ksGetArrayCount; //showmessage(inttostr(i));
        tlp:=ksTextLineParam(Kompas.GetParamStruct(ko_TextLineParam));
        tip:=ksTextItemParam(Kompas.GetParamStruct(ko_TextItemParam));
        for j := 0 to i - 1 do
        begin
          da.ksGetArrayItem(j,tlp);
          dai:=ksDynamicArray(tlp.GetTextItemArr);
          k:=dai.ksGetArrayCount;
          for l := 0 to k - 1 do
          begin
            dai.ksGetArrayItem(l,tip);
            if tip.iSNumb=0 then s:=s+' '+trim(tip.s)
            else s:=s+' @'+IntToStr(tip.iSNumb)+'~';
          end;
        end;
      end;
      //---�������� ������ s �� ������---
    Result:=s;

     //---������� �����---
    stamp.ksCloseStamp;
  end;

end;


function TKompasManager.GetId: variant;
begin
    Inc( GlobId );
    Result := GlobId;
end;

function TKompasManager.GetKind( name: string ): string;
begin
    result := '0';
    if name = '������������'        then result := '10';
    if name = '����������'          then result := '11';
    if name = '������������'        then result := '12';
    if name = '��������� �������'   then result := '7';
    if name = '������'              then result := '4';
    if name = '����������� �������' then result := '5';
    if name = '������ �������'      then result := '6';
    if name = '���������'           then result := '3';
end;

function TKompasManager.GetSpecificationStampData(filename: string): TStampData;
var
    SpcDocument: ksSpcDocument;
begin
    if not FileExists( filename ) then exit;

    SpcDocument := OpenSpecification( filename );

    if not Assigned( SpcDocument ) then exit;

    result := GetSpecificationStampData( SpcDocument );

    CloseSpecification( SpcDocument );
end;

function TKompasManager.GetSpecificationStampData(
  SpcDocument: ksSpcDocument): TStampData;
begin
    result := ReadStamp( ksStamp( SpcDocument.GetStampEx(0) ) );
end;

function TKompasManager.GetDocument2DStampData(
  Document2D: ksDocument2D): TStampData;
begin
    result := ReadStamp( ksStamp( Document2D.GetStampEx(0) ) );
end;

function TKompasManager.GetDocument2DStampData(filename: string): TStampData;
var
    Document2D: ksDocument2D;
begin
    if not FileExists( filename ) then exit;

    Document2D := OpenDocument2D( filename );

    if not Assigned( Document2D ) then exit;

    result := GetDocument2DStampData( Document2D );

    CloseDocument2D( Document2D );
end;

function TKompasManager.ReadStamp(stamp: ksStamp): TStampData;
begin
    if not Assigned(stamp) then exit;

    result.Name     := Trim( ReadSpecStamp( stamp, STAMP_NAME_FIELD ) );
    result.mark     := Trim( ReadSpecStamp( stamp, STAMP_MARK_FIELD ) );
    result.material := Trim( ReadSpecStamp( stamp, STAMP_MATERIAL_FIELD ) );
    result.mass     := Trim( ReadSpecStamp( stamp, STAMP_MASS_FIELD ) );
end;

function TKompasManager.CloseDocument2D(var Document2D: ksDocument2D): boolean;
begin
    if Assigned(Document2D) then Document2D.ksCloseDocument;
end;

function TKompasManager.CloseSpecification(var SpcDocument: ksSpcDocument): boolean;
begin
    if Assigned(SpcDocument) then SpcDocument.ksCloseDocument;
end;

function TKompasManager.OpenDocument2D(filename: string): ksDocument2D;
begin
    result := nil;

    if not Assigned( Kompas ) then exit;

    result := ksDocument2D( Kompas.Document2D );
    if   not result.ksOpenDocument( filename, true )
    then result := nil;
end;

function TKompasManager.OpenSpecification(filename: string): ksSpcDocument;
begin
    result := nil;

    if not Assigned( Kompas ) then exit;

    result := ksSpcDocument( Kompas.SpcDocument );
    if   not result.ksOpenDocument( filename, 4 {������, � ����������� ���������} )
    then result := nil;
end;

function TKompasManager.FindObject( mark, name, kind: string): integer;
/// ��������� ������� � ���� ������� �� ����������� � �����

    function getObjectID(field, value: string): integer;
    var
        i : integer;
    begin
         result := -1;

         for i := 0 to high(FindBuff) do
         if   FindBuff[i][BUFF_FIELD_VALUE] = trim( value ) then
         if   FindBuff[i][BUFF_KIND] = kind then
         begin
             result := StrToInt( FindBuff[i][BUFF_BD_VALUE] );
             break;
         end;

         if result = -1 then
         begin
             result := mngData.GetObjectBY( field, Trim( value ), kind );

             if result <> 0 then
             begin
                 SetLength(FindBuff, Length(FindBuff)+1);
                 FindBuff[high(FindBuff)][BUFF_FIELD_VALUE] := value;
                 FindBuff[high(FindBuff)][BUFF_KIND] := kind;
                 FindBuff[high(FindBuff)][BUFF_BD_VALUE] := IntToStr( result );
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

initialization

    mngKompas := TKompasManager.Create;

finalization

    mngKompas.Free;

end.
