unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ksTLB, ActiveX, ComObj, LDefin2D, StrUtils, Math, RegularExpressions, ksConstTLB,
  Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ReadKompassFile( filename: string );
    function Start_Kompas: boolean;
    function OpenDocument( filename: string): boolean;
  public
    { Public declarations }
    Kompas :KompasObject;
  end;

  TRow = array [0..8] of variant;
var
  Form2: TForm2;

  SpecDataArray: array of TRow;
    ///    ������ ������, ����������� �� ����� ������������.
    ///    �������� ������������������ ������, ������� ��� ���������� ���������:
    ///    ������������� ����, �������� �������� � ����, ���������� ���������
    ///    �������� ���� � ��������� �������:
    ///    (0) - ������. ������. ��� ������� ('������', '������', '������',... )
    ///    (1) - �����������. ������. (��������, '���5.01.02.120� ���.7774')
    ///    (2) - ������������. ������. (��������, '���������� ��������')
    ///    (3) - ����������. ������. (��������, '', '01', '19')
    ///    (4) - ����������. �������.
    ///    (5) - �����������. ������.
    ///    (6) - ����� � ��. �������
    ///    (7) - ��������. ������.

const
    // �������� ������� � ������� SpecDataArray
    FIELD_KIND  = 0;
    FIELD_MARK  = 1;
    FIELD_NAME  = 2;
    FIELD_ISP   = 3;
    FIELD_COUNT = 4;
    FIELD_COMM  = 5;
    FIELD_MASS  = 6;
    FIELD_MAT   = 7;
    FIELD_NUMBER = 8;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
        edit1.text := OpenDialog1.FileName;
        ReadKompassFile( OpenDialog1.FileName );
    end;
end;

function TForm2.OpenDocument(filename: string): boolean;
var
    SpcDocument: ksSpcDocument;
    Specification : ksSpecification;
    SpcTuningStyleParam : ksSpcTuningStyleParam;
    DynamicArray: ksDynamicArray;
    DocAttachedSpcParam: ksDocAttachedSpcParam;

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
    ///    � ������������ ���� ����� ������� ���������� � ��� ������� ����������
    ///    ���������� (10 � �����) ��� �� ���������� � ������ �� ���� � �����������
    ///    ���� �� ���������. ������ ������� ���������� ������ ������������.
    ///    �.�. ������ 10 �������� ������ ����, 11-20 ������ � �.�.
    ///    �� ����, ��� ��������� ����������� �������

    I: Integer;

    ///    ���������� ��� �������� ����������� ��� �������� �� ����� ������� � ������������.
    ///    � ���������� �������, ��������� ���������� ������� � ��������� ����������� (���� ����)
    ///    ����������� ����� �����. ��� ������������ �������, � ��� �������
    ///    ���������� ���������, ���������� ������ ������������� � ������ ������
    kind
   ,mark
   ,name
   ,note
   ,mass
   ,mat
   ,number
   ,lastMark
   ,lastName
   ,lastNumber

   ,filePath
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

    end;

    procedure CorrectionIspolNames;
    ///    ����������� ����� ��� ����������� �������������
    ///    ��������� ������ ��� ������� ����� ���� � ������
    ///    �������� �����, ���� ����� �� ����� �����.
    ///    ����� �������, ������� ���:
    ///    [�����], 01, 02, 03,..
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
            then ispNames[i] := ifthen( Length(maches[0].Value) <> 1, maches[0].Value, '0' + maches[0].Value )
            else ispNames[i] := '';

        end;
    end;
begin
    result := false;

    if not Assigned( Kompas ) then exit;
    if not FileExists( filename ) then exit;

    // �������� ����� ����������� ������
    SetLength( SpecDataArray, 0 );

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

    // �������� ������ ���� ���������� � �� ����������
    GetIspolNames;
    // ������������ �����, ������� � ���������
    CorrectionIspolNames;

    // ������� "������" ��� �������� �������� � ������ �������� ������������
    iterator := ksIterator( kompas.GetIterator() );
	iterator.ksCreateSpcIterator( '', 0, 0 );

    // ���� ������ ���������� (������������ �����), �������
	if iterator.Reference = 0 then exit;

    // �������� ������ �������
    item := iterator.ksMoveIterator( 'F' );



    ///    �������� ������ � ������ ��� ���������� ���������.
    ///
    ///    ����������� ����� ������������ � ���, ��� ��� ��������� ������ �� ����������
    ///    � ������ ������������ ����� ��� ����������� ������� ��������� ��� ������
    ///    � ��������� ������ ���������� � ����� ����������.
    ///
    ///    ����������� ������ � �� ����������� ���������� ��� ������ GetIspolNames

    while SpcDocument.ksExistObj( item ) <> 0 do
    begin

        /// ������ ������������� � ������� ����
        filePath := '';

        SpcObjParam :=  ksSpcObjParam( kompas.GetParamStruct(ko_SpcObjParam) );
        SpcDocument.ksGetObjParam( item, SpcObjParam, ALLPARAM );
        DynamicArray := ksDynamicArray(SpcObjParam.GetDocArr);

        DocAttachedSpcParam  := ksDocAttachedSpcParam(kompas.GetParamStruct(ko_DocAttachSpcParam));

        if DynamicArray.ksGetArrayCount<>0 then
        begin
            for i := 0 to DynamicArray.ksGetArrayCount - 1 do
            begin
                DynamicArray.ksGetArrayItem(i, DocAttachedSpcParam);
                filePath := DocAttachedSpcParam.fileName;
                ShowMessage( '������ ����: ' + filePath );
            end;
        end;


        // �������� ������� ��������� ������� ��� �������� ����������
        kind := specification.ksGetSpcSectionName( item );
        note := specification.ksGetSpcObjectColumnText( item, SPC_CLM_NOTE,     1, 0 );
        mass := specification.ksGetSpcObjectColumnText( item, SPC_CLM_MASSA,    1, 0 );
        mat  := specification.ksGetSpcObjectColumnText( item, SPC_CLM_MATERIAL, 1, 0 );



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

        name := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ), name);
        name := ReplaceStr( name, '@/', '');   // ������� ���������� ������ ������� �� ������� ������

        number := FloatToStr(specification.ksGetSpcObjectNumber( item ));

        mark := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ), mark);

        ///    ����������� ����� ����� ������, ��� ��� �� ����� � ������� ������������
        ///    "�� �� �������" ��������, ��� � ���������� ������������ ��� �������� ������-�� �������
        ///    � ��������� '-��' ���� ��� ��� �� ������� ������� � ������, �.�. ��� �� number
        ///    ��������:
        ///        6  ��-01-58.002    �����
        ///           ��-01-58.002-1  �����
        ///           ��-01-58.002-2  �����
        ///    ���� � ��������� ��� ���� �������� �������� �������, �� ��� ��� ����� 6 �����
        if   (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( number = lastNumber )) or

        ///    ��������� ����������� ������������ ������������ � ������������ �������������
        ///    � ������������ ������������ �������. ��� �� ��� ���� ������ �������� �������,
        ///    ����� ������� ���������� ������, �� ���������� number �� ���������
        ///    ��������:
        ///        6  ��-01-58.002  �����
        ///        7           -01  �����
        ///        8           -02  �����
             (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( pos('-', mark) = 1 ))
        then mark := lastMark + mark;




        for block := 0 to ispBlockCount - 1 do
        for isp := 1 to ispFullCount do
        if not ((block = ispBlockCount - 1) and (isp > ispCount)) then  // �������� �� ����� ���������� ��������� � ��������� �����

        if specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT, isp, block ) <> '' then // �������� ������ ����������

        begin

            SetLength( SpecDataArray, Length( SpecDataArray ) + 1 );

            SpecDataArray[High( SpecDataArray )][FIELD_KIND]   := kind;

            SpecDataArray[High( SpecDataArray )][FIELD_MARK]   := mark;
            SpecDataArray[High( SpecDataArray )][FIELD_NAME]   := name;

            SpecDataArray[High( SpecDataArray )][FIELD_ISP]    := ispNames[ block * ispFullCount + isp - 1 ];
            SpecDataArray[High( SpecDataArray )][FIELD_COUNT]  := specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT,    isp, block );

            SpecDataArray[High( SpecDataArray )][FIELD_COMM]   := note;
            SpecDataArray[High( SpecDataArray )][FIELD_MASS]   := mass;
            SpecDataArray[High( SpecDataArray )][FIELD_MAT]    := mat;
            SpecDataArray[High( SpecDataArray )][FIELD_NUMBER] := number;


        end;

        // �������� ��������� ������� � ������ ������������
        item := iterator.ksMoveIterator( 'N' );
    end;



    for I := 0 to High(SpecDataArray) do

        Memo1.Lines.Add(
            '(' + SpecDataArray[i][FIELD_NUMBER] + ') ' +
            SpecDataArray[i][FIELD_KIND] + ' / ' +
            SpecDataArray[i][FIELD_MARK] + ' / ' +
            SpecDataArray[i][FIELD_NAME] + ' / ' +
            SpecDataArray[i][FIELD_ISP] + ' / ' +
            SpecDataArray[i][FIELD_COUNT] + ' / ' +
            SpecDataArray[i][FIELD_COMM] + ' / ' +
            SpecDataArray[i][FIELD_MASS] + ' / ' +
            SpecDataArray[i][FIELD_MAT]
        );


    result := true;
end;

procedure TForm2.ReadKompassFile(filename: string);
{ ��������� ���� ������� ���-�������� � �������� �������� ������ �����
  ���� ��������� ������ }
begin
    if not Start_Kompas then exit;

    OpenDocument( filename );

    Kompas.Quit;
    Kompas:=nil;
end;

function TForm2.Start_Kompas: boolean;
begin
    result := false;

    Kompas := KompasObject( CreateOleObject('Kompas.Application.5') );

    if Assigned( Kompas ) then
    begin
        Kompas.Visible := false;
        result := true;
    end;

end;


end.
