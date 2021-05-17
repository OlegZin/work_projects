unit uLoadSpecification;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ksTLB, ActiveX, ComObj, LDefin2D, StrUtils, Math, RegularExpressions, ksConstTLB,
  Vcl.ExtCtrls, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, MemTableDataEh, Data.DB,
  MemTableEh, System.ImageList, Vcl.ImgList, Vcl.Menus;

type
  TfLoadSpecification = class(TForm)
    eFilename: TEdit;
    Button1: TButton;
    odSecification: TOpenDialog;
    mLog: TMemo;
    Panel1: TPanel;
    Button2: TButton;
    grdSpecification: TDBGridEh;
    mem: TMemTableEh;
    DataSource: TDataSource;
    ImageList1: TImageList;
    Panel2: TPanel;
    Splitter1: TSplitter;
    popMark: TPopupMenu;
    N1: TMenuItem;
    bUploadToPDM: TButton;
    checkScanSubdir: TCheckBox;
    bRefresh: TButton;
    bCollapse: TButton;
    bExpand: TButton;
    odFile: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SetLoadState(state: integer);
    procedure FormCreate(Sender: TObject);
    procedure memBeforePost(DataSet: TDataSet);
    procedure grdSpecificationColumns0CellButtons0Down(Sender: TObject;
      TopButton: Boolean; var AutoRepeat, Handled: Boolean);
    procedure bUploadToPDMClick(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure bCollapseClick(Sender: TObject);
    procedure bExpandClick(Sender: TObject);
    procedure grdSpecificationFileFieldButtonsClick(Sender: TObject;
      var Handled: Boolean);
    procedure grdSpecificationDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdSpecificationDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure grdSpecificationColumns6CellButtons0GetEnabledState(
      Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
      var ButtonEnabled: Boolean);
    procedure grdSpecificationColumns6CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure grdSpecificationColumns9CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure grdSpecificationColumns9CellButtons0GetEnabledState(
      Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
      var ButtonEnabled: Boolean);
  private
    { Private declarations }

    fLoadState: integer;
    ///    ������� ��������� �������� ������������.
    ///    ��������� ������

    procedure ReadKompassFile( filename: string );
    procedure ScanDirectory( path: string );
    function CreateTree(startIndex: integer = 0): boolean;

    procedure ToLog(text: string);
    procedure ClearLog;
    function GetFromNearFile(mark: string; field: integer): string;

  public
    { Public declarations }
    property LoadState: integer read fLoadState write SetLoadState;

  end;

    // �������� ����� ������������ ����������� BUFF_���
    TNearFile = array [0..5] of string;

var
  fLoadSpecification: TfLoadSpecification;

    dndMode
    ///    ����� �������� ������ �� ����������� � ����������� ������������
    ///    ��������� � ������� ���������� �������������� �� ������ ���������
    ///    ��������, ��� � ��� ���� ���������������, � ������ ���������
    ///    ����������� ��������
            : integer;

        NearFiles: array of TNearFile;
        // ������ ������ � ����������� � ������� ����� ������ ������.
        // ����� ��������� ������������ ������������ ����� � ����� �������� � ������� �������
        // ���������� ����� ���������� ��� �������� ����������: ������������, �����������, �����, ��������
        // � ���������� ���� ������ ������������ ��� ������� �������� ������ � ���������
        // ����������� ������������ � ����������� ������ ������ ����� �����������,
        // � �� ������������ �����, ��� ����� ��������� ��-�� ������ ���������.

implementation

{$R *.dfm}

uses uMain, uConstants, uObjectCatalog, uPhenixCORE, uDataManager, uKompasFileManager;

const
    NEAR_KIND     = 0;
    NEAR_MARK     = 1;
    NEAR_NAME     = 2;
    NEAR_MATERIAL = 3;
    NEAR_MASS     = 4;
    NEAR_FILENAME = 5;

procedure TfLoadSpecification.ReadKompassFile(filename: string);
{ ��������� ���� ������� ���-�������� � �������� �������� ������ �����
  ���� ��������� ������ }
var
    item                  // ������� ������� ������� SpecDataArray
   ,fromIndex             // ������� � ������� ������� � ������� ��������� ������
                          // � ������� � ������� ������������
   ,hi
            : integer;
begin
    ToLog('�������� ������...');
    LoadState := STATE_LOADING;

    if not mngKompas.StartKompas(true) then exit;

    // ��������� ����� � �������� �� ����� ������������ � ��������
    ScanDirectory( ExtractFilePath( filename ));

    // ��������� ������ �� �������� ������������ � ������� ������
    mngKompas.ReadSpecificationToArray( filename );

    // �� ���������� ������ ������� ������� ������ ������
    CreateTree;

    // ���������� ������ � ���� ��������� ������������
    // ������������ ������ � ��������� � ����� �������. ����� ������� ��������������
    // ������ ����������� ���� ��������� ������ �� ���� �������. ������,
    // ��� ����������� �� ������ ���������� ������������ ��� ������ ����������
    // ��� �������� � ��������� ������� ��� ������ ����� ������
{
    item := 1;
    hi := High( SpecDataArray );
    while ( item <= hi ) do
    begin
        if   SpecDataArray[item][FIELD_SPEC_FILE] <> '' then
        begin
            fromIndex := High( SpecDataArray );
            OpenDocument( SpecDataArray[item][FIELD_SPEC_FILE], SpecDataArray[item][FIELD_CHILD] );
            CreateTree( fromIndex + 1 );
        end;
        inc( item );
        hi := High( SpecDataArray )
    end;
}
    // �� ���������� ���������� ������ ������ � ��� �������� ���������� �� ������
    ToLog('');
    ToLog('�������� ���������!');
    ToLog('');
    ToLog('- �������������� � ������������ ����������� ������ � ������� "��������� � PDM" ��� �������� ������ � ����.');
    ToLog('- ������ � ����� ������� ����������� � ���� � ����� ������� ��� �������� ������������. '+
            '����������� ������������ ������, ������� ���������, ��� ����������� ������� �����. � ��������� ������ �� ����� ���������� ������� ����� � ������� � ��������� ������������ ������� � ����.');
    ToLog('- ��������� ����� � ����������� ������� ����� ������������� ��������� � ����� �������� � ����. ��� ��� ������������ ����� ���������������.');
    ToLog('- ���������, ��� ��� ��������� ������ ������� ���������� ����� ������������. ����� ���� � ������� "������������" ����� ������� ������ ���� � ������ ����� ��������.');

    mngKompas.StopKompas;

    LoadState := STATE_LOADED;
end;

procedure TfLoadSpecification.ScanDirectory(path: string);
///    ����� ��������� ��� ����� � ��������� �����, ������� ������������ �
///    �������. ��������� �� � ������� � ��������� ���������� ������ ����������.
///    ������ ������ ����� ����������� ��� �������� ������������ ��� �������
///    ������������� ������� ����� � ����� �� ����������� ���������������� ��������
///    ������������. ����� ����������� ���������� � ����� �����, �� ��� ����������
///    ����� ��������������� ������������� �� ���������� �������� ������-�����
var
    SR: TSearchRec; // ��������� ����������
    StampData: TStampData;
    fileKind
            : string;
begin

    if FindFirst( path + '*.*', faAnyFile, SR ) = 0 then
    repeat
        fileKind := '';

        // ��������� ��������, ���� ����������� �����
        if   checkScanSubdir.Checked and ((SR.Attr and faDirectory) <> 0) and ( SR.Name <> '.' ) and ( SR.Name <> '..' )
        then ScanDirectory( path + SR.Name + '\' );

        // �������� �������� ������ �� ������������ � �������
        if    ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.SPW' )
        then
        begin
            StampData := mngKompas.GetSpecificationStampData(path + SR.Name);
            fileKind := 'SPEC';
        end;

        if    ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.CDW' )
        then
        begin
            StampData := mngKompas.GetDocument2DStampData(path + SR.Name);
            fileKind := 'DRAW';
        end;

        if fileKind <> '' then
        begin

            // ��������� ������ �� ����� � ������
            SetLength( NearFiles, Length(NearFiles)+1);
            NearFiles[high(NearFiles)][ NEAR_KIND ]     := fileKind;
            NearFiles[high(NearFiles)][ NEAR_MARK ]     := StampData.Mark;
            NearFiles[high(NearFiles)][ NEAR_NAME ]     := StampData.Name;
            NearFiles[high(NearFiles)][ NEAR_MATERIAL ] := StampData.Material;
            NearFiles[high(NearFiles)][ NEAR_MASS ]     := StampData.Mass;
            NearFiles[high(NearFiles)][ NEAR_FILENAME ] := path + SR.Name;

            ToLog( '������ �����: ' + SR.Name );

        end;

    until FindNext( SR ) <> 0;

    FindClose(SR);
end;


procedure TfLoadSpecification.Button1Click(Sender: TObject);
begin
    if odSecification.Execute then
    begin

        mem.EmptyTable;
        ClearLog;
        mngKompas.CleanUp;

        eFilename.text := odSecification.FileName;
        ReadKompassFile( odSecification.FileName );
    end;
end;

procedure TfLoadSpecification.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TfLoadSpecification.bCollapseClick(Sender: TObject);
begin
   mem.TreeList.FullCollapse;
end;

procedure TfLoadSpecification.bExpandClick(Sender: TObject);
begin
   mem.TreeList.FullExpand;
end;

procedure TfLoadSpecification.bRefreshClick(Sender: TObject);
begin
    mem.EmptyTable;
    CreateTree;
end;

procedure TfLoadSpecification.bUploadToPDMClick(Sender: TObject);
/// �� ������ ������� SpecDataArray ���������� �������� ����������� ������ ��
/// ������������ � PDM.
/// �����:
///
///  * �������� ����������
///    - ���������� ������, ���� ������ � ��������� ���������
///    - ���� �������� � ����, ���� ��� - �������
///
///  * �������� ��������
///    - ������ ����������� � ��� ������ � FIELD_ID = 0 ��������� � ����,
///      ���������� id ������������ � ������. ����� ��������� ��������� �������,
///      ��������� ���� � ���� ������� ����� ����������� � ������ ��������� ����������
///      ����� ������ �������� id. ������ ��� ������ �������� ���������
///      �����������, ������������ � ����
///    - ��� ���������� ������ �������, ���� � ���� �������� ���� (FIELD_FILE <> '')
///      ��������� ���� � ���������
///
///  * �������� ������
///    - ���������� ������ � ��� ������� �������� �������� FIELD_ID �����������������
///      ��������, ���� ����. �� ��������� ������������� � �������� id �������� �����
///      ������ � ������� ������ ��������� (Link). ��� ���������, ������� � ���������
///      id ������ � ��������� ������
///    - ���������� ������ ����� ������ � ��� ������ ������� �������� �������������� ������
var
   i
  ,j
  ,obj_id               // id ������ ���������� �������
  ,obj_count            // ���������� ��������� ��� ����������
  ,mat_id               // id ��������� ��� �������� � ������������ �������
  ,doc_type
  ,parent_id
  ,link_id
           : integer;

   material             // ��� ���������
           : string;
   new_links
  ,arrParents
           : array of integer;

   function GetParent( parent: integer ): integer;
   /// �� ���������� id ������ �������� �� FIELD_ID
   var
      i : integer;
   begin
       result := 0;
{       for i := 0 to High(SpecDataArray) do
       if SpecDataArray[i][FIELD_CHILD] = parent then
       begin
           result := SpecDataArray[i][FIELD_ID];
           exit;
       end;
}   end;

   function GetStructureParents( mark: string ): integer;
   // ��������� � ��������������� ������������ ���� ������� ������� ����������
   // �� ��� ����� ���������� ���������� ��������.
   // ��� �������������� �������� ����� �������� ����� ������������ ��������
   // � ����� �� ������������ (� ������ ������� ����������). ���� ��� - �����
   // ��������� ������� �������� � ������������� � ����.
   // �����, ������� �������� ��������� ��������� � ������������, � �����������
   // �� ���� �������� ������ ������������� � ������������ � ���� ���������.
   var
       query: TDataset;
   begin
       result := 0;
       SetLength( arrParents, 0 );
       query := mngData.GetObjectByString( mark );
       if Assigned(query) then
       while not query.Eof do
       begin
           SetLength( arrParents, Length(arrParents)+1 );
           arrParents[High(arrParents)] := query.Fields[0].AsInteger;

           query.Next;
       end;
       result := length(arrParents);
   end;

   procedure CreateLink( parent_id: integer );
   begin
      // ������� ������ � ����������� ������� �����
//      link_id := mngData.AddLink( LNK_STRUCTURE, parent_id, SpecDataArray[i][FIELD_ID] );
      if link_id <> 0 then
      begin
          // ���������� ���������� ����������� ��������
//          mngData.UpdateTable( link_id, LNK_STRUCTURE, [ 'count' ], [ StrToFloatDef( SpecDataArray[i][FIELD_COUNT], 1 ) ] );

          // ���������� id ������ ��� ���������� ��������� ���������
          SetLength( new_links, Length( new_links ) + 1 );
          new_links[ high(new_links) ] := link_id;
      end;
   end;

begin

//    GetStructureParents( SpecDataArray[0][FIELD_MARK] );


    SetLength( new_links, 0 );

    ToLog('�������� ����� ��������...');
    obj_count := 0;

{    for i := 0 to High(SpecDataArray) do
    if SpecDataArray[i][FIELD_ID] = 0 then
    begin
        // ���� ������ ����� ������������ � ����
        if   FindObject( SpecDataArray[i][FIELD_MARK], SpecDataArray[i][FIELD_NAME], SpecDataArray[i][FIELD_KIND] ) <> 0 then
        begin
            SpecDataArray[i][FIELD_ID] := obj_id;
            Continue;
        end;

        // �������� ����������� ��������
        mat_id := 0;
        material :=
            ifthen( SpecDataArray[i][FIELD_MAT] <> '',
                    String(SpecDataArray[i][FIELD_MAT]),
                    String(SpecDataArray[i][FIELD_MATERIAL])
            );

        if Trim( material ) <> '' then
        // ���� �������� ����� ������������ � ����
        if   FindObject( '', material, GetKind('���������') ) = 0
        // ���� �� ����� - �������
        then mat_id := mngData.AddObject('name, kind', [ material, GetKind('���������') ]);

        // ������� �����
        obj_id := mngData.AddObject('mark, name, kind, mass, comment, material_id', [
            SpecDataArray[i][FIELD_MARK],
            SpecDataArray[i][FIELD_NAME],
            GetKind( SpecDataArray[i][FIELD_KIND] ),
            SpecDataArray[i][FIELD_MASS],
            SpecDataArray[i][FIELD_COMM],
            mat_id
        ]);

        // ���� �� ����������� ����
        if Trim(SpecDataArray[i][FIELD_FILE]) <> '' then
        begin
            // �������� ��� ������������ ��������� (����� ������ ���������� � ������ ����������)
            doc_type := mngFile.GetFileType( ExtractFileExt(ExtractFileName(SpecDataArray[i][FIELD_FILE])) );

            // ��������� ���� � ���������, ���� ����
            mngData.CreateDocumentVersion( obj_id, 0, doc_type, ExtractFileName(SpecDataArray[i][FIELD_FILE]), SpecDataArray[i][FIELD_FILE], SpecDataArray[i][FIELD_COMM] );
        end;

        // ����� id ���������� ������� � ������ ��� ���������� ������
        SpecDataArray[i][FIELD_ID] := obj_id;

        // ������� ����������
        inc( obj_count );
    end;
    ToLog('...������� ' + IntToStr( obj_count ) );
}


    // �������� ���� ��������� �� ����, ������� ����� �� �����������, ��� �������� � ������������
    // (� ������ ����������). � ����������, ��� �������� ����������� �� ������ ������
    // ����� ������� �� ������� �� ���� ���������, ��� ������������� �������� ������� ���������
    // ���� ������������ �������
//    GetStructureParents( SpecDataArray[0][FIELD_MARK] );


    ToLog('�������� ���������...');
    obj_count := 0;
{
    // ������� ������� ��� �� ����������, ��������� �������� ������ ������ ������ � ���
    // �� ���� ������ ������������� �� �����
    for i := 1 to High(SpecDataArray) do
    begin
        // �������� ��������
        parent_id := GetParent( SpecDataArray[i][FIELD_PARENT] );


        if parent_id <> SpecDataArray[0][FIELD_ID]
        then
            // ���� ������� ��������� �� �� �������� ������� - ��������� � ������� ������
            CreateLink( parent_id )
        else
            if   Length(arrParents) = 0
            then
                // ������������� �������� � ���� �� �������. ����������� � ����� ������������
                CreateLink( SpecDataArray[0][FIELD_ID] )
            else
                // �����, ����� ����������� � ��������� � ���� ���������
                for j := 0 to High(arrParents) do CreateLink( arrParents[j] );


        // ������� ����������
        inc( obj_count );
    end;
    ToLog('...������� ' + IntToStr( obj_count ) );
}
    /// ���� ������������ ����� �� ������������� � ���������, � ��������
    /// ��������� ��� �������������. ��� ����� ������� ��� ����������
    /// ������� � ������ ��������� (��������, ��� �������������� �� �����������)
{
    ToLog('�������� ��������������� ������...');
    for I := 0 to High(new_links) do
    begin
        mngData.CreateCrossLinks( LNK_STRUCTURE, new_links[i] );
        ToLog( IntToStr( i + 1 ) + ' �� ' + IntToStr( Length( new_links ) ));
        Vcl.Forms.Application.ProcessMessages;
    end;
}
    ToLog('');
    ToLog('�������� ������������ � PDM ���������');
    ToLog('');
    ToLog('������������ ��������� � ����������. �� ���� ������������ ����� ��������������� �������� � ������ ����� ���������.');

    (TfObjectCatalog.Create(self)).Show;

    mem.EmptyTable;
    eFilename.Text := '';

end;

procedure TfLoadSpecification.ClearLog;
begin
    mLog.Lines.Clear;
end;

function TfLoadSpecification.CreateTree(startIndex: integer = 0): boolean;
///    �� ������ ������� SpecDataArray ����������� �� ����� ������ ������
///    ������ ������������.
///    ���������������, ��� ��������� ������ � �� ���� ��������� �������
var
    i : integer;

begin
{    for I := startIndex to High(SpecDataArray) do
    begin
        mem.AppendRecord([
            ifthen( SpecDataArray[i][FIELD_MAT] <> '', String(SpecDataArray[i][FIELD_MAT]), String(SpecDataArray[i][FIELD_MATERIAL])),
            ExtractFileName( SpecDataArray[i][FIELD_SPEC_FILE] ),
            StrToFloatDef( ReplaceStr(SpecDataArray[i][FIELD_MASS], ',', '.'), 0 ),
            SpecDataArray[i][FIELD_COMM],
            SpecDataArray[i][FIELD_ID],
            GetKind(SpecDataArray[i][FIELD_KIND]),
            SpecDataArray[i][FIELD_MARK],
            SpecDataArray[i][FIELD_NAME],
            StrToFloatDef( ReplaceStr(SpecDataArray[i][FIELD_COUNT], ',', '.'), 1 ),
            ExtractFileName( SpecDataArray[i][FIELD_FILE] ),
            SpecDataArray[i][FIELD_CHILD],
            SpecDataArray[i][FIELD_PARENT]
        ]);
    end;
    mem.First;
}
end;


procedure TfLoadSpecification.FormCreate(Sender: TObject);
begin
    LoadState := STATE_NOT_LOADED;
end;

procedure TfLoadSpecification.grdSpecificationColumns0CellButtons0Down(
  Sender: TObject; TopButton: Boolean; var AutoRepeat, Handled: Boolean);
begin
    (sender as TDBGridCellButtonEh).DropdownMenu := popMark
end;

procedure TfLoadSpecification.grdSpecificationColumns6CellButtons0Click(
  Sender: TObject; var Handled: Boolean);
/// ��� ���� ���������, ��� ������� - ������, ��������� ���������� � �����������
/// �� ����������
//var
//   objCat : TfObjectCatalog;
begin
{    objCat := TfObjectCatalog.Create(self);
    objCat.SetFilter([KIND_MATERIAL]);
    objCat.Show;
}
    ((TfObjectCatalog.Create(self)).SetFilter([KIND_MATERIAL])).Show;

end;

procedure TfLoadSpecification.grdSpecificationColumns6CellButtons0GetEnabledState(
  Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
  var ButtonEnabled: Boolean);
/// ��� ���� ��������� ������ �������� ����������� �������� ������ ��� ������
/// ����� ��������� ��������
begin
    if   Grid.DataSource.DataSet.Active and ( Grid.DataSource.DataSet.RecordCount > 0 )
    then ButtonEnabled := Grid.DataSource.DataSet.FieldByName('kind').AsInteger = KIND_DETAIL;
end;

procedure TfLoadSpecification.grdSpecificationColumns9CellButtons0Click(
  Sender: TObject; var Handled: Boolean);
///  ������ � ���� ����� ������������. ��������� ������ ��� ������ ����� ������������
///  ����� ��������� ���������� ���������� ������ � ��������� � �������� �
///  ���� ��� �����������
///  ������� �� �������� ����������� ������ ������������ �� ������ ��� ��������� ������
///
///  ��������� ����������� ������������ � ������ ����������. ��� ��������� �
///  ������� ����� ������� �������������
var
    ispoln : array of integer;
    // ������ ���� ���������� ������� ������� �� ���� ����������� ������������ ��������
    // ����� ������� ������ �� ������� ����������� �� ������ ������ ������������

    mark : string;
    // ����������� �� �������� ������ ����������. ���� ��� ��������� ������ ����
    // ������� ���������� � ���������, ������� ���������� ��� ����������� ������

    i
   ,last
            : integer;

    reg     : TRegEx;
    maches  : TMatchCollection;
begin

    // �� ��������� ������ ������������
    if   not mem.Active or ( mem.RecordCount = 0 )
    then exit;

    // ���������� ���� � ������� (����� ������������)
    if odFile.Execute then
    begin
        mem.Edit;
        mem.FieldByName('specfilename').AsString := odFile.FileName;
        mem.Post;
    end;


    // ������� ���������, ������ ����������� �����������:
    // AAAA.BB.CC.DDDD-EE, ���
    // AAAA - ��������� ����, ���� � ������ = ([a-z,A-Z,�-�,�-�]|\d|\-)+
    // .BB.CC - ��� ������ �� ���� � ����� (��� �����) ���� = (\.\d+){2}
    // .DDDD - ��������� ������ �� ����, ������� ����� ������������ �������, �������, ��������� � ������� = .\d+[a-z,A-Z,�-�,�-�, ,\d,\.]*
    // -EE - ����� ���������� �� ������ � ���� � ����� ���� (����� �������������) = (-\d+)?

    // � ������ ������ ����� ������ �� ������ ����������� ����� ��� ������ ����������
    reg:=TRegEx.Create('([a-z,A-Z,�-�,�-�]|\d|\-)+(\.\d+){2}\.\d+[a-z,A-Z,�-�,�-�, ,\d,\.]*');
    maches := reg.Matches( mem.FieldByName('mark').AsString );

    // ���� ������� �������, ����� ��������� �����,
    // ����� ������ ����������� �� ������, ��� �� ����������� ���������� ������ ���������� ����� �������,
    // �� ������������ ����������� ���� �� ��� ����
    if maches.Count > 0
    then mark := maches[0].Value
    else mark := mem.FieldByName('mark').AsString;

    // ������� ������������� ��������� ��� ��� ��������� ����������
    reg:=TRegEx.Create( mark + '(-\d+)?' );

    // ���������� ������� ���������� ���������
//    last := High( SpecDataArray );

    if not mngKompas.StartKompas(true) then exit;

    // ������������ ������ ������������
    for I := 0 to last do
    // ���������� ��������, �������� �� ������ ������ ����� �� ���������� ��������
//    if   reg.Match( SpecDataArray[i][FIELD_MARK] ).Success
    // ���������� ������ �� ����� � ������, ���������� � ����
//    then OpenDocument( odFile.FileName, SpecDataArray[i][FIELD_CHILD] );

    // ��������� � ������ ������� ������ ������, ��� ����� ���������� ������
    CreateTree( last + 1);

    mngKompas.StopKompas;
end;

procedure TfLoadSpecification.grdSpecificationColumns9CellButtons0GetEnabledState(
  Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
  var ButtonEnabled: Boolean);
/// ��������� ��������� ������������ ������ ��� ��������� ������
begin
    if   Grid.DataSource.DataSet.Active and ( Grid.DataSource.DataSet.RecordCount > 0 )
    then ButtonEnabled := Grid.DataSource.DataSet.FieldByName('kind').AsInteger = KIND_ASSEMBL;
end;

procedure TfLoadSpecification.grdSpecificationFileFieldButtonsClick(
  Sender: TObject; var Handled: Boolean);
///    �������� ������ ����� �������� �� ������������ ������ ����
///    ���������� � ������ �������, ��� ���� ���������� �� BeforePost
///    ������������� ������� �������� � ������� ������
begin

   // �� ��������� ������ ������������
   if   not mem.Active or ( mem.RecordCount = 0 )
   then exit;

   if odFile.Execute then
   begin
       mem.Edit;
       mem.FieldByName('filename').AsString := odFile.FileName;
       mem.Post;
   end;

end;

procedure TfLoadSpecification.grdSpecificationDragDrop(Sender, Source: TObject;
  X, Y: Integer);
/// ������� � ������������ ���������� �� ���������
var
   srcDataset
  ,trgDataset: TDataset;
begin

    // ��� ���������� ���������� ������ - �� ��������������
    if dndMode = DND_MODE_NULL then exit;

    // ��������� ��������� � ���������
    srcDataset := (Source as TDBGridEh).DataSource.DataSet;
    trgDataset := (Sender as TDBGridEh).DataSource.DataSet;

    // ���������� ��������� ������
    if dndMode = DND_MODE_ADD_MATERIAL then
    begin
        mem.Edit;
        mem.FieldByName('material').AsString := srcDataset.FieldByName('name').AsString;
        mem.Post;
    end;

end;

procedure TfLoadSpecification.grdSpecificationDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
/// �������� �� ����������� ���������� ������ �� ����������� � ������� � �����������
/// �������������. ��������� ������:
///    - �������� �� ����������� �� ������ � ������������
var
   srcDataset
  ,trgDataset: TDataset;

   coord: TGridCoord;
begin

    dndMode := DND_MODE_NULL;

    // ��������� ��������� � ���������
    srcDataset := (Source as TDBGridEh).DataSource.DataSet;
    trgDataset := (Sender as TDBGridEh).DataSource.DataSet;

    // ������������ �� ������, �� ������� ��������� ������ ����
    coord := (Sender as TDBGridEh).MouseCoord(X, Y);
    (Sender as TDBGridEh).DataSource.DataSet.RecNo := coord.y;

    // ����� �������������, ���� �������� - ������ ���������,
    // � �������� - ������ ������
    Accept :=
       Assigned(srcDataSet.FindField('kind')) and
       ( srcDataset.FieldByName('kind').AsInteger = KIND_MATERIAL ) and
       ( trgDataset.FieldByName('kind').AsInteger = KIND_DETAIL );
    if Accept then dndMode := DND_MODE_ADD_MATERIAL;


end;

procedure TfLoadSpecification.memBeforePost(DataSet: TDataSet);
var
  I: Integer;
///    ����� ������ ������ ���� ����������� ��� ������������
///    ������������� ������� ������� � ����
begin
{
    if LoadState = STATE_LOADING then exit;

    Dataset.FieldByName('object_id').AsInteger :=
        FindObject( Dataset.FieldByName('mark').AsString, Dataset.FieldByName('name').AsString, Dataset.FieldByName('kind').AsString );

    ///    �� ������� ������ ��������� ������ � �������. ��������� ������ �� ��������
    ///    ������� ���������� ������, ������ ����� ����� �������������� ��� ��������
    ///    ��������� ������������ � ����
    for I := 0 to High(SpecDataArray) do
    if Dataset.FieldByName('child').AsInteger = SpecDataArray[i][FIELD_CHILD] then
    begin
        SpecDataArray[i][FIELD_MAT] := Dataset.FieldByName('material').AsString;

        if   ExtractFilepath(Dataset.FieldByName('specfilename').AsString) <> ''
        then SpecDataArray[i][FIELD_SPEC_FILE] := Dataset.FieldByName('specfilename').AsString;

        SpecDataArray[i][FIELD_MASS] := ReplaceStr(Dataset.FieldByName('mass').AsString, ',', '.');
        SpecDataArray[i][FIELD_COMM] := Dataset.FieldByName('comment').AsString;
        SpecDataArray[i][FIELD_ID] := Dataset.FieldByName('object_id').AsString;
        SpecDataArray[i][FIELD_MARK] := Dataset.FieldByName('mark').AsString;
        SpecDataArray[i][FIELD_NAME] := Dataset.FieldByName('name').AsString;
        SpecDataArray[i][FIELD_COUNT] := ReplaceStr(Dataset.FieldByName('count').AsString, ',', '.');

        if   ExtractFilepath(Dataset.FieldByName('filename').AsString) <> ''
        then SpecDataArray[i][FIELD_FILE] := Dataset.FieldByName('filename').AsString;

        SpecDataArray[i][FIELD_PARENT] := Dataset.FieldByName('parent').AsString;
    end;
}
end;



procedure TfLoadSpecification.SetLoadState(state: integer);
begin
    fLoadState := state;

    case state of
       STATE_NOT_LOADED: grdSpecification.ReadOnly := true;
       STATE_LOADING: ;
       STATE_LOADED: grdSpecification.ReadOnly := false;
    end;
end;


function TfLoadSpecification.GetFromNearFile(mark: string; field: integer): string;
///    ��� ���������� ����������� ���� ����������� ����, ���� ���� � ����������
///    ��������� � ����� ��������
var
    i: integer;
begin
    result := '';
    for i := 0 to High(NearFiles) do
    if NearFiles[i][NEAR_MARK] = mark then
    begin
        result := NearFiles[i][NEAR_MATERIAL];
        break;
    end;
end;

procedure TfLoadSpecification.ToLog(text: string);
begin
    mLog.Lines.Add( text );
    // KsTLB �������������� Application ��� KompasObject;
    Vcl.Forms.Application.ProcessMessages;
end;

end.
