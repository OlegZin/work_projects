unit uLoadSpec;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, MemTableDataEh, Data.DB, MemTableEh, FileCtrl,
  System.ImageList, Vcl.ImgList;

type

  TCallback = procedure of object;

  TfLoadSpec = class(TForm)
    Panel1: TPanel;
    eFilename: TEdit;
    Label1: TLabel;
    sbSelectSpec: TSpeedButton;
    rgrpDirFilter: TRadioGroup;
    eMask: TEdit;
    ePassMask: TEdit;
    sbLoadSpec: TSpeedButton;
    OpenDialog: TOpenDialog;
    Label2: TLabel;
    Panel2: TPanel;
    sbOption: TSpeedButton;
    Panel3: TPanel;
    lbRootDir: TListBox;
    Label3: TLabel;
    sbAddRootDir: TSpeedButton;
    sbDeleteRootDir: TSpeedButton;
    Panel4: TPanel;
    Splitter1: TSplitter;
    DBGridEh1: TDBGridEh;
    Panel5: TPanel;
    Splitter2: TSplitter;
    mLog: TMemo;
    MemTable: TMemTableEh;
    DataSource1: TDataSource;
    sbToProject: TSpeedButton;
    Panel6: TPanel;
    Panel7: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    lIspol: TLabel;
    eIspol: TEdit;
    ImageList1: TImageList;
    procedure sbSelectSpecClick(Sender: TObject);
    procedure sbLoadSpecClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbOptionClick(Sender: TObject);
    procedure sbAddRootDirClick(Sender: TObject);
    procedure sbDeleteRootDirClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure sbToProjectClick(Sender: TObject);
  private

    fParentMark: string;
    /// ����������� �������� � ������ ������� ��� �������� ����� ������� ������������
    fParentID : integer;
    /// ����������� �������� � ������ ������� ��� �������� ����� ������� ������������

    /// ��� ��������� ������ ����������, �������� ������������ � ������������ ������
    /// ��� ������ ������������ ���������� �������� �� ������������ ���������� � ������
    /// ������������. �� ��� �� �����������, � ������������ ���������� ������������

    fProjectID : integer;

    function UploadToProject: boolean;
  public
    error : string;
    /// ��������� ������������ ������

    fCallback : TCallback;
    /// �����, ���������� ��� �������� �������� � ������, ����� ��������� �����

    { Public declarations }
    function setParentObject( mark: string; id: integer ): TfLoadSpec;
    function setProjectId( projectID: integer ): TfLoadSpec;
    function setCallback( callback: TCallback ): TfLoadSpec;
    procedure SetFile( filename: string );
    procedure LoadSpecData;
  end;

var
  fLoadSpec: TfLoadSpec;

implementation

{$R *.dfm}

uses
    uKompasManager, uMain, uConstants, uPhenixCORE;

var
    currSpecPath : string;
    /// ������� ���� �� ��������� ������������

procedure TfLoadSpec.FormCreate(Sender: TObject);
begin
//    panel1.Height := panel2.top;    // �������� ������ �����
    mngKompas.SetupMemtable( MemTable );
end;

procedure TfLoadSpec.sbLoadSpecClick(Sender: TObject);
var
   mask : string;
begin

    // ����������, ������ �� ������������
    if fParentMark <> '' then
    if  Application.MessageBox(
            PChar('����� ���������� ' + eIspol.Text + ' ������ �����?'),
            '����� ����������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    sbToProject.Enabled := false;

    mngKompas.sSetLogMemo( mLog );

    /// ���������� ����� ����������� ������
    mngKompas.CleanUp;
    MemTable.EmptyTable;

    /// �������� ������ ����������, � ������� ����� ������ �������������� �����
    /// ������������ � �������� ��� ��������� ����������� ������������
    case rgrpDirFilter.ItemIndex of
       0 : mask := '*';                // � ������� � ��������� ������
       1 : mask := '';                 // � ������� �����
       2 : mask := eMask.Text          // �� �����
    end;

    if not mngKompas.ScanFiles( lbRootDir.Items.CommaText, mask, ePassMask.Text ) then
    begin
        ShowMessage( mngKompas.error );
        exit;
    end;

    /// ��������� xml ���� � ��������� ������������ � �������������� ���������� ������� ��� ������
    if not mngKompas.Init( currSpecPath ) then
    begin
        ShowMessage( mngKompas.error );
        exit;
    end;

    /// ��������� ������ �� xml � ������� ������
    if not mngKompas.LoadSpecification( fParentID, fParentMark, StrToIntDef( eIspol.Text, -1) + 1 ) then
    begin
        ShowMessage( mngKompas.error );
        exit;
    end;

    if not mngKompas.UploadToDataset( MemTable ) then exit;

    MemTable.TreeList.FullExpand;

    sbToProject.Enabled := true;
end;

procedure TfLoadSpec.sbOptionClick(Sender: TObject);
begin
    if   panel1.Height = panel2.top
    then panel1.Height := panel2.top + panel2.Height
    else panel1.Height := panel2.top;

end;

procedure TfLoadSpec.sbSelectSpecClick(Sender: TObject);
begin

    OpenDialog.Filter := '������������|*.spw';

    if   OpenDialog.Execute
    then SetFile( OpenDialog.FileName );

end;


procedure TfLoadSpec.sbToProjectClick(Sender: TObject);
begin
    if not UploadToProject then
    begin
        ShowMessage( error );
        exit;
    end;

    // �������� ������� ����� ��� ��������� �������� �������� � ������
    if Assigned(fCallback)
    then fCallback;

    close;
end;

function TfLoadSpec.setCallback(callback: TCallback): TfLoadSpec;
begin
    fCallback := callback;
    result := self;
end;

procedure TfLoadSpec.SetFile(filename: string);
begin
    eFilename.Text := ExtractFileName( filename );
    sbLoadSpec.Enabled := true;

    // ������� ���������� ����, ���� ���
    lbRootDir.Items.Delete( lbRootDir.Items.IndexOf( ExtractFilePath(currSpecPath)) );

    // ��������� ���� �� ������� ������������
    if lbRootDir.Items.IndexOf( ExtractFilePath( filename ) ) = -1 then
    lbRootDir.Items.Add( ExtractFilePath( filename ) );

    currSpecPath := filename;
end;

function TfLoadSpec.setParentObject(mark: string; id: integer): TfLoadSpec;
begin
    self.Caption := '�������� ������������ ��� ' + mark;
    fParentMark := mark;
    fParentID := id;
    result := self;

    eIspol.Text := '0';
    if   fParentMark <> ''
    then
    begin
        eIspol.Text := IntToStr( mngKompas.GetIspoln( fParentMark ) - 1 );
        lIspol.Visible := true;
        eIspol.Visible := true;
    end;
end;

function TfLoadSpec.setProjectId(projectID: integer): TfLoadSpec;
begin
    fProjectID := projectID;
    result := self;
end;

procedure TfLoadSpec.SpeedButton1Click(Sender: TObject);
begin
    MemTable.TreeList.FullExpand;
end;

procedure TfLoadSpec.SpeedButton2Click(Sender: TObject);
begin
    MemTable.TreeList.FullCollapse;
end;

procedure TfLoadSpec.LoadSpecData;
begin
    sbLoadSpec.Click;
end;

procedure TfLoadSpec.sbAddRootDirClick(Sender: TObject);
var
    s: string;

  options : TSelectDirOpts;
  chosenDirectory : string;
begin
    OpenDialog.Filter := '��� �����|*.*';

    // ����� ���������� ����� ����� ���� � ���
    // �� ������ �������, �� ��������� ������ �� ����
    if OpenDialog.Execute then
    if lbRootDir.Items.IndexOf( ExtractFilePath(OpenDialog.FileName) ) = -1 then
    lbRootDir.Items.Add( ExtractFilePath(OpenDialog.FileName) );

{   // ��������� ����� ������ ���������� �� ��������� ����� � ����.
    // ������������ ������ ���� ������������ ������� �����
    chosenDirectory := 'C:\';
    if SelectDirectory(chosenDirectory, options, 0)
    then lbRootDir.Items.Add( chosenDirectory );
}
end;

procedure TfLoadSpec.sbDeleteRootDirClick(Sender: TObject);
begin
    if lbRootDir.ItemIndex = -1 then exit;
    if lbRootDir.Items[ lbRootDir.ItemIndex ] = ExtractFilePath(eFilename.Text) then exit;

    lbRootDir.DeleteSelected;
end;

function TfLoadSpec.UploadToProject: boolean;
/// ����� �������� ��������������� ������������ � ������.
///
/// * ������� ��� ��������� �� ������� � ���� bd_id ��������:
///    bd_id > 0 - ������ ��� ���������� � ������������ ���������. � ������� [object]
///    bd_id < 0 - ������ ��� ���� � ������� �������. � ������� [project_object]
///    bd_id = 0 - ������ �� ���������� � ����
///
/// ��������
/// - ���������� ������ � memtable
///     - ��� bd_id > 0 �������� ������ � ������, ����� � bd_id ��������� id
///     - ��� bd_id < 0 ����������. ����� �������
///     - ��� bd_id = 0 ������� ������ � ������� � ����� bd_id ��������� id
/// - ����� ���������� ������ memtable
///     - �������� bd_id ��������
///     - �������������� ��������� �������� parent.bd_id �������
///     - ������� ����� ����� parent � child �� �� bd_id
///     - ��������� id ��������� ������ � ������� ��� ���������� ���������
/// - ���������� ������ � id ������
///     - ������� �������� ��� ������.
///       ��� �� ������� �����, ��������� ��������� ����������� ��������� ��������
///       ������, ����� �� ���� ������� ��������� �������� ��� ������, �������
///       ��� �� ��������� � ����� ��������� ����� ���������.
/// - ��� ������ ������� �������� ������������ (������ ����), �������� ������� ����������� �
///   �������, ����� ���������� ���������� � ���� �������
/// - ��� ������ �������� �������������� ������������ (��������� �������� ��
///   ���������� ����������), ���������� ���� ����, �������� �������� ������� ���
///   �������� � ��������� �������. ����� ������������ �� fParentID <> 0
/// - ��������� ��� ������� ������� ��������� �������
var
    links: array of integer;
    ids: array of record
       child: integer;
       parent: integer;
       bd_id: integer;
       count: real;
    end;
    copied: array of record
       bd_id, project_id: integer;
    end;
    i, j,
    bd_id
   ,project_id
   ,doc_id : integer;

    procedure AddLink( parent, child: integer; count: real );
    var
        link : integer;
    begin

        // ���� ������ ��� ����, �� ������� �����
        link := mngData.PresentLink( parent, child, LNK_PROJECT_STRUCTURE );
        if link = 0
        then link := mngData.AddLink( LNK_PROJECT_STRUCTURE, parent, child );

        if link = 0 then exit;

        // ���������� � ������ ��������� ������ �� ������������.
        // ���� ����� ������ ��� � ����, �� � ��� ������ ���� �������������� ��������
        // �� ������� ������� � ��� ������������, ��� ����� �������� �� ����� ������ � ������� ���������
        // ��� ������ ������ �������� � ���� ���������
        SetLength(links, Length(links)+1);
        links[high(links)] := link;

        mngData.UpdateLink( LNK_PROJECT_STRUCTURE, links[high(links)], ['count'], [count] );
    end;

    function GetFromCopied( id: integer ): integer;
    /// ���� ����� ����� ������������� �� �� �������� � ���������� id � �������
    var i : integer;
    begin
        result := 0;
        for I := Low(copied) to High(copied) do
        if copied[i].bd_id = id then
        begin
            result := copied[i].project_id;
            exit;
        end;
    end;

begin

    result := true;

    SetLength(links, 0);

{$IFNDEF test}
    if   not Core.DM.ADOConnection.InTransaction
    then Core.DM.ADOConnection.BeginTrans;
{$ENDIF}

    /// ������� � �������� �������
    MemTable.First;
    while not MemTable.Eof and result do
    begin

        /// ����� �������� �� ������� �������� ������� ���� ������, ��������, ���������� �������
        /// � ����������� ����������. ���������� ��� �������, ���� ��� ��������


        /// ���� [bd_id] �������� ��������, ����������� �� ������� ������� � ����
        /// ��� �������� >0 ������ ���������� � ������������� ���������, �� �� � �������
        /// ��� �������� <0 ������ ���������� � � ������� �, ��������, � ������������� ���������
        /// ��� �������� =0 ������� � ���� �� ���������� � ��� ����� ��������
        ///
        /// �������� ����������� � ���, ��� � ������ �� ����� ��������� �������,
        /// ������� ��� ��� ���� ( ��� [bd_id]<0 ), �� ����� ����, ��� ������ �
        /// ������� ��� ����, �� ������������� � ������� ��������, ��������, �
        /// ������ ����������. ������ ������ ����� ��������� ������ ��� ������� ������.
        /// ������, ����� �������� ���� ������������ � ������� ������ � ������ ids

        /// ������ � ������������ ���������
        if ( MemTable.FieldByName('bd_id').AsInteger > 0 ) then
        begin
            try

                bd_id := MemTable.FieldByName('bd_id').AsInteger;

                // �������� ����� � ������� ��� ������������� ��������, ����� �������� ������
                project_id := GetFromCopied( bd_id );

                // ������ ��� - �������
                if project_id = 0 then
                begin
                    project_id := mngData.CopyObject( MemTable.FieldByName('bd_id').AsInteger, 0, TBL_OBJECT, TBL_PROJECT);

                    // ���������� ��� ����������� ������������ ������
                    SetLength(copied, Length(copied)+1);
                    copied[high(copied)].bd_id := bd_id;
                    copied[high(copied)].project_id := project_id;
                end;

                /// �������� � ������� ��������
                MemTable.Edit;
                MemTable.FieldByName('bd_id').Value := project_id;
                MemTable.Post;

                /// ������� ������ � ������� ���������
                if mngData.AddObject(
                    'original_id, parent, project_id',
                    [ bd_id, MemTable.FieldByName('bd_id').Value, fProjectID ],
                    TBL_PROJECT_OBJECT_EXTRA,
                    true                                       // �������� ��� �������� ��������
                ) = 0 then
                    result := false;


                /// ��� ��������� ��������� ������ �� ����� � �������
                if MemTable.FieldByName('kind').AsInteger = KIND_DOCUMENT then
                mngData.UpdateTable(
                    dmSDQ(' SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE doc_id = ' + IntToStr(bd_id), 0),
                    TBL_DOCUMENT_EXTRA,
                    ['project_doc_id', 'project_id'],
                    [ MemTable.FieldByName('bd_id').Value, fProjectID ]
                );


            except
                on E: exception do
                begin
                    error := e.Message;
                    result := false;
                end;
            end;
        end;

        /// ������ �� ����������
        if MemTable.FieldByName('bd_id').AsInteger = 0 then
        begin
            try
                /// ������� � ������� ��������
                MemTable.Edit;
                MemTable.FieldByName('bd_id').Value :=
                    mngData.AddObject(
                        'kind, icon, name, mark',
                        [ MemTable.FieldByName('kind').AsInteger,
                          MemTable.FieldByName('subkind').AsInteger,
                          MemTable.FieldByName('name').AsString,
                          MemTable.FieldByName('mark').AsString
                        ],
                        TBL_PROJECT);
                MemTable.Post;

                /// ������� ������ � ����������, ����� ������ �������, ����������� ����� � ������
                if mngData.AddObject(
                    'original_id, parent, status, project_id',
                    [ 0, MemTable.FieldByName('bd_id').Value, PROJECT_OBJECT_VIEW, fProjectID ],
                    TBL_PROJECT_OBJECT_EXTRA,
                    true                                       // �������� ��� �������� ��������
                ) = 0 then
                    result := false;

                /// ���� ���� ����������� ����, �������� ��� � ����
                if ( MemTable.FieldByName('linked_file').AsString <> '' ) and
                   FileExists( MemTable.FieldByName('linked_file').AsString )
                then
                begin
                    /// ������� ��������
                    doc_id := mngData.CreateDocumentVersion(
                        MemTable.FieldByName('bd_id').AsInteger,                        // ������-�������� ���������
                        0,                                                              // ���������� ������
                        2,                                                              // ��� �� ������������ [DOCUMENT_TYPE]
                        ExtractFilename( MemTable.FieldByName('linked_file').AsString ),// ��� ��� ������������
                        MemTable.FieldByName('linked_file').AsString,                   // ����������� ��� ����� + ����
                        ''                                                              // �����������
                    );

                    /// ����������� ������ �������������� � �������
                    mngData.UpdateTable(
                        dmSDQ(' SELECT id FROM ' + TBL_DOCUMENT_EXTRA + ' WHERE project_doc_id = ' + IntToStr(doc_id), 0),
                        TBL_DOCUMENT_EXTRA,
                        ['project_doc_id', 'project_object_id', 'project_id'],
                        [ doc_id, MemTable.FieldByName('bd_id').AsInteger, fProjectID ]
                    );
                end;
            except
                on E: exception do
                begin
                    error := e.Message;
                    result := false;
                end;
            end;
        end;

        SetLength(ids, Length(ids)+1);
        ids[high(ids)].child := MemTable.FieldByName('child').AsInteger;
        ids[high(ids)].parent := MemTable.FieldByName('parent').AsInteger;
        ids[high(ids)].bd_id := MemTable.FieldByName('bd_id').AsInteger;
        ids[high(ids)].count := StrToFloatDef(MemTable.FieldByName('count').AsString, 1);

        MemTable.Next;
    end;


    /// ������� �����
    if result then
    for I := 0 to High(ids) do
    if  // ������� �� ��������
        ( ids[i].parent <> 0 )
    then
        begin
            // ���� bd_id ��������
            if result then
            for j := 0 to High(ids) do
            if ids[i].parent = ids[j].child
            then
                AddLink( ids[j].bd_id, ids[i].bd_id, ids[i].count );
        end
    else
        begin
            // �������� �������, �� �������� ���������
            // ����������� � ���������� ��������
            if (ids[i].parent = 0) and ( fParentID <>  0)
            then
                AddLink( fParentID, ids[i].bd_id, ids[i].count );

            // ��� ��������, �� ����������� ������� ������������
            // ����������� � ����� �������
            if ( fParentID = 0 )
            then
                AddLink( fProjectID, ids[i].bd_id, ids[i].count );
        end;




    /// ������� ��������, ������� ��������� ������ ������� ������� ���� ���������
    /// ������, ��������� � ������� ����
    if result then
    for I := 0 to High(links) do
    begin
        mngData.DeleteCrossLinks( TBL_PROJECT_STRUCTURE, links[i] );
        mngData.CreateCrossLinks( TBL_PROJECT_STRUCTURE, links[i] );
    end;

{$IFNDEF test}
    if Core.DM.ADOConnection.InTransaction
    then
        if   result
        then Core.DM.ADOConnection.CommitTrans
        else Core.DM.ADOConnection.RollbackTrans;
{$ENDIF}

end;


end.
