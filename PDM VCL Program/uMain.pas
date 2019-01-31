unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Vcl.StdCtrls, Data.DB, Data.Win.ADODB, MemTableDataEh, DataDriverEh,
  MemTableEh, Vcl.ExtCtrls, VirtualTrees, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList, Vcl.Mask, DBCtrlsEh, Vcl.Buttons,
  Vcl.OleCtrls, SHDocVw, uSpecifTreeManager, uDataManager, EhLibADO, VCL.Imaging.jpeg,
  Vcl.Menus, uFileManager, System.IOUtils, ShellApi, uDatatableManager;

type

  TfMain = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    grdSpecific: TDBGridEh;
    grdObject: TDBGridEh;
    ActionList1: TActionList;
    aAdminPanel: TAction;
    pnNavigation: TPageControl;
    pageGroups: TTabSheet;
    pageSpecif: TTabSheet;
    grdGroup: TDBGridEh;
    ilTreeIcons: TImageList;
    pSearch: TPanel;
    pageSearch: TTabSheet;
    grdSearch: TDBGridEh;
    Panel2: TPanel;
    bSearch: TImage;
    Panel3: TPanel;
    aSearch: TAction;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    eValue: TEdit;
    dateSelected: TDBDateTimeEditEh;
    bRefresh: TImage;
    cbField: TComboBox;
    sbAddSection: TSpeedButton;
    sbEditSection: TSpeedButton;
    sbAddObject: TSpeedButton;
    sbDelSection: TSpeedButton;
    pcObjects: TPageControl;
    tsObjects: TTabSheet;
    tsDocument: TTabSheet;
    grdDocs: TDBGridEh;
    iPreview: TImage;
    Label2: TLabel;
    lAutor: TLabel;
    mDocComment: TMemo;
    ilDocTypes: TImageList;
    Label3: TLabel;
    lEditor: TLabel;
    Label5: TLabel;
    lbDocSupportFiles: TListBox;
    Panel4: TPanel;
    Label6: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    sbShowAgreeVersions: TSpeedButton;
    sbShowAllVersions: TSpeedButton;
    ilAgree: TImageList;
    ilInwork: TImageList;
    bCreateDocPreview: TButton;
    sbAddDocument: TSpeedButton;
    popObject: TPopupMenu;
    menuAddDocument: TMenuItem;
    ilHas_docs: TImageList;
    sbDeleteDocument: TSpeedButton;
    sbOpenDoc: TSpeedButton;
    sbTakeToWork: TSpeedButton;
    sbSaveVersion: TSpeedButton;
    sbCancelVersion: TSpeedButton;
    sbOpenVersionDir: TSpeedButton;
    sbOpenVersionFile: TSpeedButton;
    Button3: TButton;
    sbShowObjectCatalog: TSpeedButton;
    mnMain: TMainMenu;
    N1: TMenuItem;
    Panel7: TPanel;
    lMainInfo: TLabel;
    sbSaveWorkVersion: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure aAdminPanelExecute(Sender: TObject);
    procedure bAddSectionClick(Sender: TObject);
    procedure bSearchClick(Sender: TObject);
    procedure bEditSectionClick(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure grdGroupGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure grdGroupSelectionChanged(Sender: TObject);
    procedure grdGroupCellClick(Column: TColumnEh);
    procedure grdSpecificCellClick(Column: TColumnEh);
    procedure sbDelSectionClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sbAddObjectClick(Sender: TObject);
    procedure pcObjectsChange(Sender: TObject);
    procedure grdDocsRowDetailPanelShow(Sender: TCustomDBGridEh;
      var CanShow: Boolean);
    procedure grdDocsCheckRowHaveDetailPanel(Sender: TCustomDBGridEh;
      var RowHaveDetailPanel: Boolean);
    procedure sbAddDocumentClick(Sender: TObject);
    procedure menuAddDocumentClick(Sender: TObject);
    procedure grdDocsApplyFilter(Sender: TObject);
    procedure bCreateDocPreviewClick(Sender: TObject);
    procedure sbDeleteDocumentClick(Sender: TObject);
    procedure grdDocsCellClick(Column: TColumnEh);
    procedure sbOpenDocClick(Sender: TObject);
    procedure sbTakeToWorkClick(Sender: TObject);
    procedure grdObjectColumns3CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure grdObjectColumns6CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure grdObjectColumns5CellButtons0GetEnabledState(
      Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
      var ButtonEnabled: Boolean);
    procedure grdObjectColumns6CellButtons0GetEnabledState(
      Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
      var ButtonEnabled: Boolean);
    procedure pnNavigationChange(Sender: TObject);
    procedure sbOpenVersionDirClick(Sender: TObject);
    procedure sbOpenVersionFileClick(Sender: TObject);
    procedure sbCancelVersionClick(Sender: TObject);
    procedure sbSaveVersionClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure sbShowObjectCatalogClick(Sender: TObject);
    procedure grdObjectApplyFilter(Sender: TObject);
    procedure sbSaveWorkVersionClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure grdSpecificDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdSpecificDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure grdGroupDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdGroupDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure grdObjectDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdObjectDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    { Private declarations }
    procedure RefreshSubitems( ItemTable, LinkTable: string; id: integer);
    procedure EditSection;
    procedure EditObject;
    procedure ShowPreview( filename: string );
  public
    { Public declarations }
    procedure OnGroupCellChange;
    procedure ShowSubItems;

    function CreateNavigationObject( parent, child: integer; fields: string; values: array of variant ): integer;
    procedure AddDocumentDialog;
    function CreatePreview( path, filename: string ): boolean;
    procedure CheckButtons;
    procedure ClearStructure;
    function AddDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
    function SaveWorkDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
    function SaveDocVersionCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
  end;

var
  fMain: TfMain;
    mngSpecTree             // �������� ������������ ������ �����
   ,mngGroupTree            // �������� ������������ ������ ������������
   ,mngSearchTree           // �������� ������������ ������ ������
            : TTreeManager;

    mngData                 // ��������, ��������������� ��������� ������ � �����
            : TDataManager;

    mngFile
            : TFileManager;

    mngDatatable
            : TDatatableManager;

implementation

uses
    uPhenixCORE, uConstants, uWelcom, ucTools, uAdminPanel,
    uEditNavigation, uEditSection, uEditObject,
    Math, uAddDoc, Unit2, uObjectCatalog, uSpecTreeFree;

const

    // �������� � �������
    PAGE_OBJECTS = 0;
    PAGE_DOCUMENT = 1;

    // ������� ������� ����� (grdGroup)
    GRP_COL_NAME  = 0;      // ������������ ��� ��������
    GRP_COL_LUID  = 3;      // id ������������, ���������� �����
    GRP_COL_CHILD = 4;      // id �������
    GRP_COL_LID   = 5;      // id ������ �����

    // ������� ������� ������������
    SPC_COL_LID   = 3;      // id ������ �����

    // ������� ������� ������
    SRH_COL_LID   = 3;      // id ������ �����

    // ������� ������� � ��������� (grdObject)
    COL_OBJECT_FILE_BUTTONS = 5;


{$R *.dfm}


procedure TfMain.FormShow(Sender: TObject);
var
   error: string;
   i: integer;
begin

    fWelcome := TfWelcome.Create(nil);
    fWelcome.Show;

    // ��������������
    Core := TCore.Create;
    if not Core.Init(
                PROG_NAME,
                CONNECTION_STRING,
                SETTINGS_TABLE_NAME,
                LOG_FILEPATH,
                error
            ) then
    begin
        ShowMessage('������ ������������� ���������:' + sLineBreak + sLineBreak +
                     error + sLineBreak + sLineBreak +
                    '������ �������.');
        halt;
    end;


    lC('uMain.FormCreate');
    lM(IntToStr(Core.User.id));

//    Core.Settings.RestoreForm(self);

    fWelcome.Progress(10);

    // ��������� ������ �����
    mngGroupTree := TTreeManager.Create;
    mngGroupTree.init(grdGroup, VIEW_GROUP);
    mngGroupTree.GetTreeLevel(0,0);

    fWelcome.Progress(10);

    // ��������� ������ ������������
    mngSpecTree := TTreeManager.Create;
    mngSpecTree.init(grdSpecific, VIEW_OBJECT);
    mngSpecTree.GetTreeLevel(0,0);

    fWelcome.Progress(10);

    // ����������� �������� ������
    mngSearchTree := TTreeManager.Create;
    mngSearchTree.init(grdSearch, VIEW_OBJECT);

    fWelcome.Progress(10);

    // �������������� ������ ���������� � ������� � �� ����������
    mngFile := TFileManager.Create;
    mngDatatable := TDatatableManager.Create;

    // ������� �������� � ������������ ������� ������������� ������� � ���� ������
    // ����������, ��������, ��������� �������� � ������ � ��������������
    // ��������������� ������� ���������
    mngData := TDataManager.Create;

    fWelcome.Progress(10);

    // �������������� ������� ��������
    grdObject.DataSource := TDataSource.Create(self);
    grdObject.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdObject, [0,1,2] );
    mngDatatable.ConfigureForSorting( grdObject, [] );

    grdDocs.DataSource := TDataSource.Create(self);
    grdDocs.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdDocs, [0,1] );
    mngDatatable.ConfigureForSorting( grdDocs, [] );

//    for I := 0 to grdDocs.Columns.Count-1 do
//        grdDocs.Columns[i].STFilter.ListSource := grdDocs.DataSource;

    fWelcome.Progress(10);

    // �������������� �����
    if   not DirectoryExists( DIR_BASE_WORK )       // �������� �������
    then ForceDirectories( DIR_BASE_WORK );

    if DirectoryExists( DIR_TEMP ) then             // ��������� �����
    TDirectory.Delete( DIR_TEMP, true );

    if   not DirectoryExists( DIR_TEMP )
    then ForceDirectories( DIR_TEMP );

    if   not DirectoryExists( DIR_PREVIEW )         // ��������� ����������
    then ForceDirectories( DIR_PREVIEW );

    if   not DirectoryExists( DIR_DOCUMENT )        // ��������� � ������
    then ForceDirectories( DIR_DOCUMENT );

    fWelcome.Progress(10);

    // ���������� ������� ������ ���������
    Caption := Caption + ' (' + GetFileVersion() + ')';

    fMain.KeyPreview := true;

    // ���� ��� ����������� ���������� ������ ��� ��������� ���������� �������
    DBGridEhCenter.FilterEditCloseUpApplyFilter:=true;

    // ������ �������������� ����
    fWelcome.Free;

    lCE; // ����� �� ���������� ������� ����������� �����

end;

procedure TfMain.grdGroupGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
    if StrToIntDef((Sender as TDBGridEh).Columns[GRP_COL_LUID].DisplayText, 0) = Core.User.id then
        AFont.Style := [fsBold, fsItalic];
end;

procedure TfMain.aSearchExecute(Sender: TObject);
begin
    pnNavigation.ActivePage := pageSearch;
    bSearch.OnClick(self);
end;

procedure TfMain.bAddSectionClick(Sender: TObject);
var
    ChildId : integer;
begin
    if not Assigned(fEditSection) then
       fEditSection := TfEditSection.Create(self);

    fEditSection.Mode := 0;  // �������� �������
    fEditSection.ParentId := mngGroupTree.GetValue('child');
    fEditSection.ItemsKind := 0;
    fEditSection.SectionName := '����� ������';

    if fEditSection.ShowModal = mrOk then
    begin

        mngGroupTree.Expand;

        // ������� ������� � ����
        ChildId :=
            CreateNavigationObject(
                fEditSection.NewParentId,            // ��������
                0,                                   // ������ (����� ������ �����)
                'icon, kind, name',                  // ����� ����������� ��� �������� �����
                [
                    fEditSection.NewItemsKind,       // ��� ���������
                    KIND_SECTION,                    // �������� ��� �������
                    fEditSection.NewSectionName      // ������������ �������
                ]
            );

        // ��������� ������
        mngGroupTree.Refresh;

    end;
end;



procedure TfMain.bEditSectionClick(Sender: TObject);
begin

    if   mngGroupTree.GetValue('kind') = KIND_SECTION
    then EditSection
    else EditObject;

end;

procedure TfMain.EditSection;
var
    doRefresh: boolean;
begin
    if not Assigned(fEditSection) then
       fEditSection := TfEditSection.Create(self);

    fEditSection.Mode := 1;  // �������������� �������
    fEditSection.ParentId := mngGroupTree.GetValue('parent');
    fEditSection.ItemsKind := mngGroupTree.GetValue('icon');
    fEditSection.SectionName := mngGroupTree.GetValue('name');

    if fEditSection.ShowModal = mrOk then
    begin

        // �������� �������� ������ ����� ���������
        if   fEditSection.NewParentId <> mngGroupTree.GetValue('parent')
        then mngData.ChangeLinkParent( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), fEditSection.NewParentId);

        // �������� ������ (��� �������-�������)
        if   fEditSection.SectionName <> fEditSection.NewSectionName
        then mngData.ChangeObject( mngGroupTree.GetValue('child'), ['name'], [fEditSection.NewSectionName] );

        // �������� ��� ������������ ���������
        if   fEditSection.ItemsKind <> fEditSection.NewItemsKind
        then mngData.ChangeObject( mngGroupTree.GetValue('child'), ['icon'], [fEditSection.NewItemsKind] );

        // ������������� ������ � ����������� �������� ��������� �����
        mngGroupTree.Refresh;
    end;
end;

procedure TfMain.EditObject;
begin
    if not Assigned(fEditObject) then
       fEditObject := TfEditObject.Create(self);

    fEditObject.Mode := 1;  // �������������� �������
    fEditObject.ParentId := mngGroupTree.GetValue('parent');
    fEditObject.ObjectID := mngGroupTree.GetValue('child');

    if fEditObject.ShowModal = mrOk then
    begin

        // �������� �������� ������ ����� ���������
        if   fEditObject.NewParentId <> mngGroupTree.GetValue('parent')
        then mngData.ChangeLinkParent( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), fEditObject.NewParentId);

        // �������� ������� ������ ����� ���������.
        if   fEditObject.NewObjectId <> mngGroupTree.GetValue('child')
        then mngData.ChangeLinkChild( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), fEditObject.NewObjectId );

        // ������������� ������ � ����������� �������� ��������� �����
        mngGroupTree.Refresh;
    end;
end;

procedure TfMain.sbAddObjectClick(Sender: TObject);
var
    ChildId : integer;
begin

    if not Assigned(fEditObject) then
       fEditObject := TfEditObject.Create(self);

    fEditObject.Mode := 0;  // �������� �������� �������
    fEditObject.ParentId := mngGroupTree.GetValue('child');
    fEditObject.ObjectId := 0;

    if fEditObject.ShowModal = mrOk then
    begin
        if ( fEditObject.ObjectId = fEditObject.NewObjectId ) or
           ( fEditObject.NewObjectId = 0 )
        then exit;

        mngGroupTree.Expand;

        // ������� ������� � ����
        ChildId :=
            CreateNavigationObject(
                fEditObject.NewParentId,            // ��������
                fEditObject.NewObjectId,            // ������������ ������
                '',
                []
            );

        // ��������� ������
        mngGroupTree.Refresh;

    end;

end;

procedure TfMain.sbCancelVersionClick(Sender: TObject);
{ ���������� ������ � �������������� �������� ��� ���������� ���������.
  ��� ���� ������� ������ ��������� ��������� }
begin

    // ����������, ������ �� ������������
    if  Application.MessageBox(
            '������� �������� �� �������������� ��� ���������� ���������? ����� ������ �� ����� �������.',
            '������� ��� ����������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if not mngData.DeleteWorkDocument( grdDocs.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage( Core.DM.DBError );
        exit;
    end;

    // ��������� ������ ����������
    ShowSubItems;
end;

procedure TfMain.sbDelSectionClick(Sender: TObject);
begin
    if  Application.MessageBox(
            '������� �������� �� ����� �������?',
            '��������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    // ������� ������ �� ����
    if not mngData.DeleteLink( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), DEL_MODE_FULL_USER ) then exit;

    // ��������� ������
    mngGroupTree.Refresh;
end;

procedure TfMain.sbOpenDocClick(Sender: TObject);
{ ��������� ��������� ���� ��� ��������� �� ������ ������������.

  ��������:
  - ��������� ���� � �������� ����� � �������: ���_�����(������).����������
  - �������� ������� ���������� � ������� ����������
}
var
    filename
   ,DBname
            : string;
    dataset
            : TDataSet;
begin
    // ������ ��� ���������� ������������
    dataset := grdDocs.DataSource.DataSet;

    // ��������� ���
    filename := ExtractFileName( dataSet.FieldByName('filename').AsString ) +
                '(' + dataSet.FieldByName('version').AsString + ')' +
                ExtractFileExt( dataSet.FieldByName('filename').AsString );

    // ��������� �� ���� ��� ���� ������
    mngData.GetFileFromStorage( DIR_TEMP, Filename, dataSet.FieldByName('fullname').AsString );

    // �������� �������
    ShellExecute(0, 'open', PChar( DIR_TEMP + filename ), nil, nil, SW_SHOWNORMAL);
end;

procedure TfMain.sbOpenVersionDirClick(Sender: TObject);
{ ������� ������ �������� ����� � ���������� � ������ �������� ��� �������
  ��������� "��������� � ������"
}
var
    path: string;
begin
    path := mngData.GetVersionPath( grdDocs.DataSource.DataSet.FieldByName('child').AsInteger );
    ShellExecute(Application.Handle, 'explore', PChar(path), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfMain.sbOpenVersionFileClick(Sender: TObject);
{ ������� ������ �������� ����� � ������ �������� ��� �������
  ��������� "��������� � ������"  }
var
    path: string;
begin
    path := mngData.GetVersionPath( grdDocs.DataSource.DataSet.FieldByName('child').AsInteger, true );
    ShellExecute(Application.Handle, 'open', PChar(path), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfMain.sbSaveVersionClick(Sender: TObject);
{ ���������� �������� ��������� �������� ���������, ��� ����� ������ }
label ext;
var
    filename: string;
    dsDoc : TDataset;
    hash: string;
begin

    lC('sbSaveVersionClick');

    // ����������, ������ �� ������������
    if  Application.MessageBox(
            '��������� ���������������� �������� � ������� ��� ����� ������?',
            '������� � �����������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then goto ext;

    dsDoc := grdDocs.DataSource.DataSet;

    filename := mngData.GetVersionPath( dsDoc.FieldByName('child').AsInteger, true );

    if not FileExists(filename) then
    begin
        ShowMessage( lW( '������� ���� ������ �����������. ���������� ��������.' + sLineBreak+ '(' + filename + ')'));
        exit;
    end;

    hash := mngFile.GetHash( filename );
    if hash = dsDoc.FieldByName('hash').AsString then
    begin
        ShowMessage( lW( '� ���� ' + ExtractFileName(filename) + ' �� ������� ���������. �������� ����� ������ ��������.'));
        goto ext;
    end;

    // ���������� ���� ���������� ��������� � ������ ��������� ������ (������ ������� ���� � ��� ���������)
    if   not Assigned( fAddDoc )
    then fAddDoc := TfAddDoc.Create(self);

    fAddDoc.object_id   := dsDoc.FieldByName('parent').AsInteger;
    fAddDoc.object_name :=
        '(' + dsDoc.FieldByName('parent').AsString + ') ' +
              dsDoc.FieldByName('object_name').AsString;
    fAddDoc.filename    := filename;
    fAddDoc.name        := dsDoc.FieldByName('filename').AsString;
    fAddDoc.version_id  := dsDoc.FieldByName('child').AsInteger;
    fAddDoc.version     := dsDoc.FieldByName('version').AsString;
    fAddDoc.doc_type    := dsDoc.FieldByName('type').AsInteger;
    fAddDoc.mode        := SAVE_MODE_NEW_VERSION; // ���������� ��������� ������
    fAddDoc.callback    := fMain.SaveDocVersionCallback;

    fAddDoc.Show;

ext:
    lCE;

end;

function TfMain.SaveDocVersionCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
begin
    result := false;

    if not mngData.SaveWorkDocumentAsVersion( version_id ) then
    begin
        ShowMessage( Core.DM.DBError );
        exit;
    end;

    // ��������� ������ ����������
    ShowSubItems;

    result := true;
end;

procedure TfMain.sbTakeToWorkClick(Sender: TObject);
{ �������� ���� �� �������������� ��� ������� �������������. }
label ext;
begin
    lC('TfMain.sbTakeToWorkClick');

    // ����������, ������ �� ������������
    if  Application.MessageBox(
            '����� �������� � ������? ������ ������������ ������ ��� ������ �����������.',
            '����� � ������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then goto ext;

    // ����� �������� � ������
    if not mngData.TakeDocumentToWork( grdDocs.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage( Core.DM.DBError );
        goto ext;
    end;

    // ��������� ������ ����������
    ShowSubItems;

ext:
    lCE;
end;

procedure TfMain.sbDeleteDocumentClick(Sender: TObject);
{ ����� ������� �������� (��������� ������) � ���������� �������.
  ����������, �������� �������� � ����, ������ ����������� � ����� ������ � ��������,
  � ��� ������� �� ����, ����� ������ ���� ���������, �������� ����� ����� ��������� � ������.

  ��������:
  - ������� ������ ������ ���������
  - ���� ����������� � ���� ������ �����, ���� �� �����������
      - ������� ������ ��� ���
  - ��������� ������� ����������� ������ ����������� � ������� �������
  - ��� ������� ����������, ���������� ���� ������� �����
  -��������� ������ ����������
}
label ext;
var
    doc_id
   ,link_id
            : integer;
    path
            : string;
begin
    lC('sbDeleteDocumentClick');

    // ����� ��������� ��������� � ������ ��������� ��� ��������� ��� �������� ��������������
    // ��������� ��� ������� �� ��, � ����� �������� ����� ��������� ���� �������� ���
    // ��������� ������ �� ��������� ������ �������, ����� �� ��� �� ��� ������
    if mngData.IsInWork( grdDocs.DataSource.Dataset.FieldByName('child').AsInteger ) OR
       mngData.IsWorkVersion( grdDocs.DataSource.Dataset.FieldByName('child').AsInteger )
    then
    begin
        ShowMessage('�������� ����������. ��������� ������ � �������, ��� ����������� ��������.');
        goto ext;
    end;

    // ����������, ������ �� ������������
    if  Application.MessageBox(
            '������� �������� �� ����� ���������� (���� ����)?',
            '��������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then goto ext;

    doc_id := grdObject.DataSource.Dataset.FieldByName('child').AsInteger;
    link_id := grdDocs.DataSource.Dataset.FieldByName('link_id').AsInteger;

    // ������� �������� ������ �� ����
    if not mngData.DeleteLink( LNK_DOCUMENT_OBJECT, link_id, DEL_MODE_SINGLE + DEL_MODE_NO_CROSS ) then exit;
{
    // ���� ��������� ����������� � �������
    if dataset.FieldByName('is_complex').AsInteger = 1 then
    begin
        if not dmOQ( Format( SQL_GET_SUBDOCS, [ dataset.FieldByName('child').AsInteger ] )) then goto ext;

    end;
}

    // ��������� ������� ����������� ������
    mngData.UpdateHasDocsFlag( doc_id );

    // ��������� ������ ������
    ShowSubItems;

ext:
    lCE;
end;

procedure TfMain.bSearchClick(Sender: TObject);
begin

     mngSearchTree.SetSQL('SELECT * FROM ' + VIEW_OBJECT + ' WHERE parent = name like ''%'+eValue.Text+'%''');

end;

procedure TfMain.OnGroupCellChange;
var
   isUserObject: boolean;
begin
    // ����������� ������ ��������������/�������� ��������

    sbAddSection.Enabled := grdGroup.SelectedIndex <> -1;
    sbAddObject.Enabled := grdGroup.SelectedIndex <> -1;

    isUserObject := StrToIntDef(grdGroup.Columns[GRP_COL_LUID].DisplayText, 0) = Core.User.id;
    sbEditSection.Enabled := isUserObject;
    sbDelSection.Enabled := isUserObject;

    // ����� ������ ������������ �������� ���������� � ������ ��������
    ShowSubItems;

end;

procedure TfMain.pcObjectsChange(Sender: TObject);
begin
    ShowSubItems;
end;

procedure TfMain.pnNavigationChange(Sender: TObject);
begin
    OnGroupCellChange;
end;

procedure TfMain.ShowSubItems;
{ ������ �� �������� ��������� ������, ���������� � ������� ������ �����������
  ��������� (���� ����������) }
begin

    if   pnNavigation.ActivePage = pageGroups
    then RefreshSubitems( VIEW_GROUP, LNK_NAVIGATION, StrToIntDef(grdGroup.Columns[GRP_COL_LID].DisplayText, 0) );

    if   pnNavigation.ActivePage = pageSpecif
    then RefreshSubitems( VIEW_OBJECT, LNK_STRUCTURE, StrToIntDef(grdSpecific.Columns[SPC_COL_LID].DisplayText, 0) );

    if   pnNavigation.ActivePage = pageSearch
    then RefreshSubitems( VIEW_OBJECT, LNK_STRUCTURE, StrToIntDef(grdSearch.Columns[SRH_COL_LID].DisplayText, 0) );

end;

procedure TfMain.SpeedButton2Click(Sender: TObject);
begin
    // ����������� �������� ��������������� ���������� ����������� �����������
    (TfSpecTreeFree.Create(self, VIEW_OBJECT)).Show;
end;

procedure TfMain.SpeedButton3Click(Sender: TObject);
begin
    (TfSpecTreeFree.Create(self, VIEW_GROUP)).Show;
end;

procedure TfMain.sbAddDocumentClick(Sender: TObject);
begin
    AddDocumentDialog;
end;

procedure TfMain.RefreshSubitems( ItemTable, LinkTable: string; id: integer);
{ ��������� ������ ������ ���������, ������ �� ������� ��������� ������ (�������)
  � ������� �������� ������� ������ ��������
 }
    procedure RefreshObjects;
    var
        mark_id: integer;
        i: integer;
        childs: string;
    begin

        // ��� ���������� ������ ���������� ��� ���������� ��������, ����� ������������ �����
        if   Assigned(grdObject.DataSource.DataSet) and grdObject.DataSource.DataSet.Active
        then mark_id := grdObject.DataSource.DataSet.FieldByName('child').AsInteger;

        // ������������� �������
        grdObject.DataSource.DataSet := mngData.GetObjectSubitems( id, ItemTable, LinkTable, grdObject.DataSource.DataSet );

        // ��������������� ��������� �������
        if   Assigned(grdObject.DataSource.DataSet) and grdObject.DataSource.DataSet.Active
        then grdObject.DataSource.DataSet.Locate('child', mark_id, []);

    end;

    procedure RefreshDocument;
    var
        mark_id: integer;
    begin

        // �������� ������ ���� ����������, ����������� � �������� �������
        // {!} ������ ��������� ���������� ��� ���������� ���������� ��������

        if   Assigned(grdDocs.DataSource.DataSet) and grdDocs.DataSource.DataSet.Active
        then mark_id := grdDocs.DataSource.DataSet.FieldByName('child').AsInteger;

        if   Assigned(grdObject.DataSource.DataSet) and grdObject.DataSource.DataSet.Active {and ( grdObject.DataSource.Dataset.RecordCount > 0 )} then
        begin

            // ��� ������� ��������� � ����������� � ��������������, ����� ������ � �������� � �������, � �� ������� (��������� �� ��� � �������)
            if   grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_DOCUMENT_INWORK
            then grdDocs.DataSource.DataSet := mngData.GetSectionDocsList( grdGroup.DataSource.DataSet.FieldByName('child').AsInteger, grdDocs.DataSource.DataSet )
            else grdDocs.DataSource.DataSet := mngData.GetDocsList( grdObject.DataSource.DataSet.FieldByName('child').AsInteger, grdDocs.DataSource.DataSet );

            if   Assigned(grdDocs.DataSource.DataSet) and grdDocs.DataSource.DataSet.Active
            then grdDocs.DataSource.DataSet.Locate('child', mark_id, []);
        end else
            grdDocs.DataSource.DataSet.Close;

        sbAddDocument.Enabled := Assigned( grdObject.DataSource.DataSet ) and ( grdObject.DataSource.DataSet.RecordCount > 0 );

        sbDeleteDocument.Enabled := false;
        sbOpenDoc.Enabled := false;

        CheckButtons;

    end;

begin

    RefreshObjects;
    RefreshDocument;

    // ������ � ��������� �������, � ����������� �� ���������� ������� � ���������

    // �������� "������" ������������ �� ���� �������, ����� ������ ������� "��������� � ������"
    tsObjects.TabVisible :=
        (pnNavigation.ActivePage <> pageGroups) or
        ( not (grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_DOCUMENT_INWORK) );

{
    case pcObjects.ActivePageIndex of
        PAGE_OBJECTS : RefreshObjects;
        PAGE_DOCUMENT : RefreshDocument;
    end;
}
end;


procedure TfMain.AddDocumentDialog;
var
   dataset: TDataSet;
begin

    dataset := grdObject.DataSource.DataSet;

    if   not DataSet.Active or ( DataSet.RecordCount = 0 ) then
    begin
        ShowMessage('�� ������ ������, �������� ����������');
        exit;
    end;

    if   not Assigned( fAddDoc )
    then fAddDoc := TfAddDoc.Create(self);

    fAddDoc.object_id   := Dataset.FieldByName('child').AsInteger;
    fAddDoc.object_name := '(' + Dataset.FieldByName('child').AsString + ') ' + Dataset.FieldByName('name').AsString;
    fAddDoc.filename    := '';
    fAddDoc.name        := '';
    fAddDoc.version_id  := 0;
    fAddDoc.version     := '1';
    fAddDoc.mode        := SAVE_MODE_NEW_DOCUMENT; // ���������� ������ ������
    fAddDoc.callback    := fMain.AddDocCallback;
                           // ������� � ���, ��� ���� ���������� ����� �� ������ ����
                           // ����������� (���������) � �� ������ ��������� �����������
                           // ���������� ���������, ��������� �� ����� ����������
                           // �������� �� ���� ��� ���� ������ � ��������� ���������
                           // ��������, ���������� ������ ������ ������ ���������, ���
                           // ����������/���������� ����� �������� ��������� ������������ � ������
                           // ��� ��� �������� ������� callback-�������.

    fAddDoc.Show;

end;

function TfMain.AddDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
begin

    result := false;

    if   mngData.CreateDocumentVersion( object_id, version_id, doc_type, Name + ext, FileName, Comment ) = 0
    then ShowMessage( Core.DM.DBError )
    else
        begin
            fMain.OnGroupCellChange;
            result := true;
        end;

end;


procedure TfMain.Button2Click(Sender: TObject);
var
   i, j
   ,izdid
   ,blockid
   ,ispolid
   ,specid
   ,userID

   ,spec1
   ,isp1_1
   ,isp1_2

   ,sec_detail
   ,sec_standart
   ,sec_material
   ,sec_other
   ,sec_assembly
   ,sec_complect
   ,sec_complex
            : integer;

   query1, query2: TADOQuery;

   function AddSection(id, icon: integer; section: string): integer;
   begin
       result := mngData.AddObject('kind, name, icon', ['1', section, icon]);
       mngData.AddLink( LNK_NAVIGATION, id, result, 0 );
   end;

   procedure AddObjects(kind: integer; name: string);
   var i : integer;
   begin
       for I := 1 to 10 do
       begin

           mngData.AddObject('kind, mark, name', [ kind, name, name + IntToStr(i) ]);

           lMainInfo.Caption := name + ' ' + IntToStr(i);
           Application.ProcessMessages;
       end;
   end;

begin

   ClearStructure;

   // ��������� �������� �������
   izdid   := mngData.AddObject('kind, name', [ KIND_SECTION, '�������' ]);
   specid  := mngData.AddObject('kind, name', [ KIND_SECTION, '������������' ]);
   blockid := mngData.AddObject('kind, name', [ KIND_SECTION, '��������� �������' ]);

   mngData.AddLink( LNK_NAVIGATION, 0, izdid, 0 );
   mngData.AddLink( LNK_STRUCTURE, 0, specid );
   mngData.AddLink( LNK_STRUCTURE, 0, blockid );

   // ������� � ����� ����������� �������� �������������� ������� ������ ���������
   AddSection( 0, KIND_NONE,     SECTION_DOCUMENT_INWORK );
   sec_detail   := AddSection( 0, KIND_DETAIL,   '������' );
   sec_standart := AddSection( 0, KIND_STANDART, '����������� �������' );
   sec_material := AddSection( 0, KIND_MATERIAL, '���������' );
   sec_other    := AddSection( 0, KIND_OTHER,    '������ �������' );
   sec_assembly := AddSection( 0, KIND_ASSEMBL,  '��������� �������' );
   sec_complect := AddSection( 0, KIND_COMPLECT, '���������' );
   sec_complex  := AddSection( 0, KIND_COMPLEX,  '���������' );

   // �������� ������� � ����������
   spec1  := mngData.AddObject('kind, name, mark', [ KIND_SPECIF, '���.7774', '���5.01.02.100�' ]);
   isp1_1 := mngData.AddObject('kind, name, mark', [ KIND_ISPOLN, '���.7774', '���5.01.02.100�' ]);
   isp1_2 := mngData.AddObject('kind, name, mark', [ KIND_ISPOLN, '���.7774', '���5.01.02.100�-01' ]);

   // ������������ � ���������� ����� ����������� � ������ ���������
   mngData.AddLink( LNK_STRUCTURE, specid, spec1 );
   mngData.AddLink( LNK_STRUCTURE, spec1, isp1_1 );
   mngData.AddLink( LNK_STRUCTURE, spec1, isp1_2 );

   mngData.AddLink( LNK_NAVIGATION, izdid, spec1, 0 );
   mngData.AddLink( LNK_NAVIGATION, spec1, isp1_1, 0 );
   mngData.AddLink( LNK_NAVIGATION, spec1, isp1_2, 0 );

   // �������� ����������� � ����������� � ���������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 11'); // ��� ����������
   // ��� ������� ���������
   while not query1.eof do
   begin

       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_detail,   0 );
       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_standart, 0 );
       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_material, 0 );
       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_other,    0 );
       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_assembly, 0 );
       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_complect, 0 );
       mngData.AddLink( LNK_NAVIGATION, query1.FieldByName('id').AsInteger, sec_complex,  0 );

       query1.Next;
   end;

   // ���������� ��������� �������, ����� ���������� � ������� "��������� �������" ������ ���������
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.110� ���.7774', '�������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.110�-01 ���.7774', '�������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.120� ���.7774', '����������� ��������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.130� ���.7774', '����������� ������ ����������������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.130�-01 ���.7774', '����������� ������ ����������������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.140� ���.7774', '���������� ��������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.150� ���.7774', '�����������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.160� ���.7774', '�����������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.170� ���.7774', '�����������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.200� ���.7774', '�������' ]) );
   mngData.AddLink( LNK_STRUCTURE, blockid, mngData.AddObject('kind, mark, name', [ KIND_ASSEMBL, '���5.01.02.200�-01 ���.7774', '�������' ]) );

   // ���������� ������
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '814-17.2.04.00.007 ���.4378', '������' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '2013.136.00.007', '���������' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '2013.136.01.012', '�����' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.101� ���.7774', '��������' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.101�-01 ���.7774', '��������' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.102� ���.7774', '��������' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.103� ���.7774', '��������' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.02.02.101� ���.6953', '�����' ]);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '��.81.44.000-23', '��������� ��� � ���� 15180-86' ]);

   // ���������� ����������� �������
   mngData.AddObject('kind, name', [ KIND_STANDART, '���� � ������������ �������� ���� � ��� 4017-�12�40-5.6' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '����� ��16-6�.35.III.3.019 ���� 9064-75' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '����� ������������ ���������� ���� ISO 4032-�12-8-�3�' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������ 50-16-01-�-��09�2����� 33259-2015' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� �165-6gx100 ���� 22042-76' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� �16-6g�300.58.019���� 22042-76' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '�������� 2,5�7.00���� 10299-80' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '����� �.16.01.08��.016 ���� 11371-78' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� ��16-6gx95.32.35.III.2.019 ���� 9066-75' ]);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� ��16-6g�70.32.35.III.2.019 ���� 9066-75 �������. �1083079' ]);

   // ������ �������
   mngData.AddObject('kind, name', [ KIND_OTHER, '��������������� ���.������ 1/2 �������. �755855' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ ������� ���-25��,����������: � ����������, 6,3 ��� (��������� ���� ����1�-20), ��� ��� ���-25� �� �� 2,5 ���, �������� ��������� ����� �0618/18 �� 28.07.2018 �������. �1160137' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ �������� ������������ �����������WB 26 �� 50 �� 16 ���/��2�������. �1031654' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ ���������� VT.539.N.04 1/2" �������. �751589' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '���� ������� �������� ���� 025.016.10-03� ��1 DN 25 PN 16 ���/��2 �� 3742-002-52838824-2006  �������. �:1040810' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '�������� ��22� (6 ���)-�20-1,5 �� 4212-002-4719015564-2008�������. �1225261' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '�������� ��3-� 0...16 ���/��2 �� 311-00225621.167-97' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '�������� ��3-��2-(0...1)���/��2-1,5 �20�1,5���������� ��� ������ �� 25-02.180335-84 �������. �1220625' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������� � 57�5-32�4 ���� 17378-2001 �������. �1062104' ]);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ 2-032-40 ���� 12821-80' ]);

   // ������� �������� ������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+LNK_STRUCTURE);
   while not query1.eof do
   begin
       mngData.CreateCrossLinks( LNK_STRUCTURE, query1.FieldByName('id').AsInteger );
       query1.Next;
   end;

   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+LNK_NAVIGATION);
   while not query1.eof do
   begin

       mngData.CreateCrossLinks( LNK_NAVIGATION, query1.FieldByName('id').AsInteger );
       query1.Next;
   end;

   ShowSubItems;
   mngSpecTree.Refresh;
   mngGroupTree.Refresh;

   ShowMessage('��������� ���������');
end;

procedure TfMain.Button3Click(Sender: TObject);
begin
    Form2.SHow;
end;

procedure TfMain.Button4Click(Sender: TObject);
begin
   ClearStructure;
   ShowSubItems;
   mngSpecTree.Refresh;
   mngGroupTree.Refresh;
end;

procedure TfMain.CheckButtons;
var
   filename : string;
   docs_enabled
  ,is_work_version
  ,is_in_work
           : boolean;
begin
    // ���������� �������� ����
    docs_enabled := Assigned(grdDocs.DataSource.DataSet) AND grdDocs.DataSource.DataSet.Active and ( grdDocs.DataSource.DataSet.RecordCount > 0 );
    is_work_version := mngData.IsWorkVersion(grdDocs.DataSource.DataSet.FieldByName('child').AsInteger);
    is_in_work := mngData.IsInWork( grdDocs.DataSource.DataSet.FieldByName('child').AsInteger );

    sbDeleteDocument.Enabled := docs_enabled AND not is_in_work AND not is_work_version;
    sbOpenDoc.Enabled := docs_enabled;
    sbTakeToWork.Enabled := docs_enabled AND not is_in_work;
    sbSaveWorkVersion.Enabled := is_work_version AND docs_enabled;
    sbSaveVersion.Enabled := is_work_version AND docs_enabled;
    sbCancelVersion.Enabled := is_work_version AND docs_enabled;

    if docs_enabled then
    begin
        filename := mngData.GetVersionPath( grdDocs.DataSource.DataSet.FieldByName('child').AsInteger, true );
        sbOpenVersionFile.Enabled := FileExists( filename );
        sbOpenVersionDir.Enabled := sbOpenVersionFile.Enabled;
    end else
    begin
        sbOpenVersionFile.Enabled := false;
        sbOpenVersionDir.Enabled := false;
    end;
end;

function TfMain.CreateNavigationObject(parent, child: integer; fields: string; values: array of variant): integer;
var
   LinkId: integer;
begin

    if   child <> 0
    then result := child
    else
    begin
        // ��������� ����� ������
        result := mngData.AddObject( fields, values );
        if result = 0 then
        begin
            ShowMessage( '�� ������� �������� ������.' );
            exit;
        end;
    end;

    // ������� �������� � ��������
    LinkId := mngData.AddLink( LNK_NAVIGATION, parent, result );
    if LinkId = 0 then
    begin
        ShowMessage( '������ ������ ��� ����������.' );
        exit;
    end;

    // ������� ��������� ��� ����� ������
    if not mngData.CreateCrossLinks( LNK_NAVIGATION, linkId, true ) then
    begin
        ShowMessage( '�� ������� ������� ����� ���������.' + sLineBreak +
                     Core.DM.DBError );
        exit;
    end;

end;

procedure TfMain.grdDocsApplyFilter(Sender: TObject);
{ ��� ��������� ����������, ���������� ��� ������� � ��������� ����� ������
  ������� ��� �������� }
var
    filter, oper : string;
    i: integer;
begin
    (Sender as TDBGridEh).DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( Sender as TDBGridEh );
{
    oper := '';
    filter := '';

    for I := 0 to grdDocs.Columns.Count-1 do
    if grdDocs.Columns[i].STFilter.ExpressionStr <> '' then
    begin
        filter := filter + oper + grdDocs.Columns[i].STFilter.DataField + grdDocs.Columns[i].STFilter.ExpressionStr;
        oper := ' and ';
    end;
    grdDocs.DataSource.DataSet.Filter := filter;
}
end;

procedure TfMain.grdDocsCellClick(Column: TColumnEh);
begin
    CheckButtons;
end;

procedure TfMain.grdDocsCheckRowHaveDetailPanel(Sender: TCustomDBGridEh;
  var RowHaveDetailPanel: Boolean);
begin
//    grdDocs.RowDetailPanel.Visible := true;
end;

procedure TfMain.grdDocsRowDetailPanelShow(Sender: TCustomDBGridEh;
  var CanShow: Boolean);
var
    jpg : TJPEGImage;
    dataset: TDataSet;

    function GetColumn(name: string): TColumnEh;
    var
        i: integer;
    begin
        for I := 0 to grdDocs.Columns.Count-1 do
            if grdDocs.Columns[i].FieldName = name then result := grdDocs.Columns[i];
    end;
begin

    dataset := grdDocs.DataSource.DataSet;

    lAutor.Caption         := DataSet.FieldByName('autor_fio').AsString;
    lEditor.Caption        := DataSet.FieldByName('work_fio').AsString;
    mDocComment.Lines.Text := DataSet.FieldByName('comment').AsString;

    // ���������� ������ �������� ������
    lbDocSupportFiles.Items.Clear;

    // �������� ���������, ���� ����
    ShowPreview( DIR_PREVIEW + '(' + dataset.FieldByName('version').AsString + ')' + ChangeFileExt( dataset.FieldByName('name').AsString, '.jpg' ) );

end;

procedure TfMain.ShowPreview(filename: string);
var
    F: TFileStream;
    size : integer;
begin
    bCreateDocPreview.Visible := true;

    // �������� ������ ������ �����. ���� ������� - ����������� �����������
    size := 0;
    if FileExists( Filename ) then
    begin
        F := TFileStream.Create(Filename, fmOpenRead);
        size := F.Size;
        F.Free;
    end;

    if FileExists( filename ) and ( size <> 0 ) then
    begin

        try
            iPreview.Picture.LoadFromFile( filename );
        except
            // ����� ������ �� ����������� �������������� ���������.
            // ����� ���������, ��������, � doc ��� xls ������, ���� ��������� �� ��������� �� ���������� ������ � ������
        end;

        bCreateDocPreview.Visible := false;
    end else
        iPreview.Picture := nil;

end;

procedure TfMain.bCreateDocPreviewClick(Sender: TObject);
var
    dataset: TDataSet;
    image: TImage;
begin

    dataset := grdDocs.DataSource.Dataset;

    if mngData.GetFileFromStorage( DIR_TEMP, '('+ dataset.FieldByName('version').AsString +')' + dataset.FieldByName('name').AsString, dataset.FieldByName('fullname').AsString ) then

    CreatePreview( DIR_TEMP, '('+ dataset.FieldByName('version').AsString +')' + dataset.FieldByName('name').AsString );

    ShowPreview( DIR_PREVIEW + '('+ dataset.FieldByName('version').AsString +')' + ChangeFileExt( dataset.FieldByName('name').AsString, '.jpg' ));
end;

function TfMain.CreatePreview( path, filename: string ): boolean;
var
    image: TImage;
    jpg: TJPEGImage;
begin
    if FileExists( path + filename ) then
    begin
        image := TImage.Create(nil);
        image.Picture.Bitmap.Handle := mngFile.GetThumbnailImage( DIR_TEMP + filename, 400, 400);

        jpg:=TJPEGImage.Create();
        jpg.Assign(image.Picture.Graphic);
        jpg.CompressionQuality:=60;
        jpg.Compress();
        jpg.SaveToFile( DIR_PREVIEW + ChangeFileExt( filename, '.jpg' ) );
        jpg.Free;

    end;
end;

procedure TfMain.grdGroupCellClick(Column: TColumnEh);
begin
    OnGroupCellChange;
end;

procedure TfMain.grdGroupDragDrop(Sender, Source: TObject; X, Y: Integer);
var
   coord: TGridCoord;
   TargetGrid
  ,SourceGrid
           : TDBGridEh;
   child_id
  ,parent_id
           : integer;
begin
    TargetGrid := (Sender as TDBGridEh);
    SourceGrid := (Source as TDBGridEh);

    coord := TargetGrid.MouseCoord(X, Y);
    TargetGrid.DataSource.DataSet.RecNo := coord.y + 1;

    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('child'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('child').AsInteger
    else child_id := SourceGrid.DataSource.DataSet.FieldByName('id').AsInteger;

    parent_id := TargetGrid.DataSource.DataSet.FieldByName('child').AsInteger;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    if not mngData.CreateCrossLinks(
        LNK_NAVIGATION,
        mngData.AddLink( LNK_NAVIGATION, parent_id, child_id ),
        true
    ) then
    begin
        ShowMessage('�� ������� ��������� �������!');
        if   Core.DM.ADOConnection.InTransaction
        then Core.DM.ADOConnection.RollbackTrans;
    end
    else
        if   Core.DM.ADOConnection.InTransaction
        then Core.DM.ADOConnection.CommitTrans;

    mngGroupTree.Refresh;
end;

procedure TfMain.grdGroupDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfMain.grdGroupSelectionChanged(Sender: TObject);
begin
    OnGroupCellChange;
end;

procedure TfMain.grdObjectApplyFilter(Sender: TObject);
begin
    (Sender as TDBGridEh).DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( Sender as TDBGridEh );
end;

procedure TfMain.grdObjectColumns3CellButtons0Click(Sender: TObject;
  var Handled: Boolean);
{ ������� ������ �������� ����� � ���������� � ������ �������� ��� �������
  ��������� "��������� � ������"
}
var
    path: string;
begin
    path := mngData.GetVersionPath( grdObject.DataSource.DataSet.FieldByName('child').AsInteger );
    ShellExecute(Application.Handle, 'explore', PChar(path), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfMain.grdObjectColumns5CellButtons0GetEnabledState(
  Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
  var ButtonEnabled: Boolean);
begin
    ButtonEnabled :=
        DirectoryExists( mngData.GetVersionPath( grdObject.DataSource.DataSet.FieldByName('child').AsInteger ) );
end;

procedure TfMain.grdObjectColumns6CellButtons0Click(Sender: TObject;
  var Handled: Boolean);
{ ������� ������ �������� ����� � ������ �������� ��� �������
  ��������� "��������� � ������"  }
var
    path: string;
begin
    path := mngData.GetVersionPath( grdObject.DataSource.DataSet.FieldByName('child').AsInteger, true );
    ShellExecute(Application.Handle, 'open', PChar(path), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfMain.grdObjectColumns6CellButtons0GetEnabledState(
  Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
  var ButtonEnabled: Boolean);
begin
    ButtonEnabled :=
        FileExists( mngData.GetVersionPath( grdObject.DataSource.DataSet.FieldByName('child').AsInteger, true ) );
end;

procedure TfMain.grdObjectDragDrop(Sender, Source: TObject; X, Y: Integer);
var
   TargetGrid
  ,SourceGrid
           : TDBGridEh;
   child_id
  ,parent_id
           : integer;
begin
    TargetGrid := grdSpecific;
    SourceGrid := (Source as TDBGridEh);

    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('child'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('child').AsInteger
    else child_id := SourceGrid.DataSource.DataSet.FieldByName('id').AsInteger;

    parent_id := TargetGrid.DataSource.DataSet.FieldByName('child').AsInteger;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    if not mngData.CreateCrossLinks(
        LNK_STRUCTURE,
        mngData.AddLink( LNK_STRUCTURE, parent_id, child_id ),
        true
    ) then
    begin
        ShowMessage('�� ������� ��������� �������!');
        if   Core.DM.ADOConnection.InTransaction
        then Core.DM.ADOConnection.RollbackTrans;
    end
    else
        if   Core.DM.ADOConnection.InTransaction
        then Core.DM.ADOConnection.CommitTrans;

    mngSpecTree.Refresh;
    ShowSubItems;
end;

procedure TfMain.grdObjectDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := pnNavigation.ActivePage = pageSpecif;
end;

procedure TfMain.grdSpecificCellClick(Column: TColumnEh);
begin
    OnGroupCellChange;
end;

procedure TfMain.grdSpecificDragDrop(Sender, Source: TObject; X, Y: Integer);
var
   coord: TGridCoord;
   TargetGrid
  ,SourceGrid
           : TDBGridEh;
   child_id
  ,parent_id
           : integer;
begin
    TargetGrid := (Sender as TDBGridEh);
    SourceGrid := (Source as TDBGridEh);

    coord := TargetGrid.MouseCoord(X, Y);
    TargetGrid.DataSource.DataSet.RecNo := coord.y + 1;

    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('child'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('child').AsInteger
    else child_id := SourceGrid.DataSource.DataSet.FieldByName('id').AsInteger;

    parent_id := TargetGrid.DataSource.DataSet.FieldByName('child').AsInteger;

    if not Core.DM.ADOConnection.InTransaction
    then   Core.DM.ADOConnection.BeginTrans;

    if not mngData.CreateCrossLinks(
        LNK_STRUCTURE,
        mngData.AddLink( LNK_STRUCTURE, parent_id, child_id ),
        true
    ) then
    begin
        ShowMessage('�� ������� ��������� �������!');
        if   Core.DM.ADOConnection.InTransaction
        then Core.DM.ADOConnection.RollbackTrans;
    end
    else
        if   Core.DM.ADOConnection.InTransaction
        then Core.DM.ADOConnection.CommitTrans;

    mngSpecTree.Refresh;
end;

procedure TfMain.grdSpecificDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfMain.menuAddDocumentClick(Sender: TObject);
begin
    AddDocumentDialog;
end;

procedure TfMain.aAdminPanelExecute(Sender: TObject);
begin
    if not Assigned(fAdminPanel) then
       fAdminPanel := TfAdminPanel.Create(self);

    fAdminPanel.Visible := not fAdminPanel.Visible;

end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);

    procedure RemoveEmptyDir(path: string);
    var
        searchRec: TSearchRec;
    begin
        if FindFirst(path + '*', faDirectory, searchRec) = 0 then
        begin
            repeat
                if (searchRec.attr and faDirectory) = faDirectory then
                begin
                    if   (searchRec.Name <> '.') and (searchRec.Name <> '..') then
                    begin
                        // ������� ������ ���������� ��������� �����
                        RemoveEmptyDir( path + searchRec.Name + '\' );
                        // ����� ����� ������� � ��
                        RemoveDir( path + searchRec.Name );
                    end;
                end;
            until FindNext(searchRec) <> 0;
            FindClose(searchRec);
        end;
    end;

begin
//    Core.Settings.SaveForm(self);

    // ������� ����� �� ����� ���������� �������
    // (�������������� �������� �������� ����� )
    if DirectoryExists( DIR_TEMP ) then
    TDirectory.Delete( DIR_TEMP, true );

    // �� ������� ����� ������� ��� ������ ����������, ������� ����� ������������
    // ����� ���������� ������������� ������������� ���������� ��� ����� ������
    // ��� ������ ������ �� ��������������. ��� ���� ���� ��������� ���������, �
    // ���������� ������ �������� ������
    RemoveEmptyDir( DIR_DOCUMENT );
end;

procedure TfMain.ClearStructure;
begin
   dmEQ('DELETE FROM '+TBL_OBJECT);

   // ��������� �������
   dmEQ('DELETE FROM '+LNK_STRUCTURE);
   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_cross');
//   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_cross_history');
   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_history');

   // �������� ���������
   dmEQ('DELETE FROM '+LNK_NAVIGATION);
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_cross');
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_cross_history');
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_history');

   // ������� ������ � �����������
   dmEQ('DELETE FROM '+TBL_DOCUMENT_EXTRA);
   dmEQ('DELETE FROM '+LNK_DOCUMENT_COMPLEX);
   dmEQ('DELETE FROM '+LNK_DOCUMENT_OBJECT);
   dmEQ('DELETE FROM '+LNK_DOCUMENT_OBJECT+'_history');
   dmEQ('DELETE FROM '+LNK_DOCUMENT_VERSION);
   dmEQ('DELETE FROM '+LNK_DOCUMENT_INWORK);

   // ��������� ����������
   dmEQ('DELETE FROM '+TBL_FILE);
end;


procedure TfMain.Button1Click(Sender: TObject);
var
   i, j
   ,izdid
   ,blockid
   ,ispolid
   ,specid
   ,userID
   : integer;
   query1, query2: TADOQuery;

   procedure AddSection(id, icon: integer; section: string);
   begin
       mngData.AddLink( LNK_NAVIGATION, id, mngData.AddObject('kind, name, icon', ['1', section, icon]), 0 );
   end;

   procedure AddObjects(kind: integer; name: string);
   var i : integer;
   begin
       for I := 1 to 10 do
       begin

           mngData.AddObject('kind, name', [ kind, name + IntToStr(i) ]);

           lMainInfo.Caption := name + ' ' + IntToStr(i);
           Application.ProcessMessages;
       end;
   end;

begin

   userID := 0;//Core.User.id;

   ClearStructure;

   // ��������� �������� �������
   izdid   := mngData.AddObject('kind, name', [ KIND_SECTION, '�������' ]);
   blockid := mngData.AddObject('kind, name', [ KIND_SECTION, '������' ]);
   specid  := mngData.AddObject('kind, name', [ KIND_SECTION, '������������' ]);


   // ������� � ����� ����������� �������� �������������� ������� ������ ���������
   AddSection( 0, KIND_NONE,     SECTION_DOCUMENT_INWORK );
   AddSection( 0, KIND_DETAIL,   '������' );
   AddSection( 0, KIND_STANDART, '����������� �������' );
   AddSection( 0, KIND_MATERIAL, '���������' );
   AddSection( 0, KIND_OTHER,    '������ �������' );
   AddSection( 0, KIND_ASSEMBL,  '��������� �������' );
   AddSection( 0, KIND_COMPLECT, '���������' );
   AddSection( 0, KIND_COMPLEX,  '���������' );


   // ��������� ����� ��������� ��������
   addObjects(4, '������');
   addObjects(7, '������');
   addObjects(10, '������������');


   // ��������� ����� ����������
   query1 := Core.DM.OpenQueryEx('SELECT id, name FROM '+TBL_OBJECT+' WHERE kind = 10'); // ��� ������������
   while not query1.eof do
   begin

       j := 1;

       for I := 1 to 3 do
       begin
           ispolid := mngData.AddObject('kind, name', [ 11, '���������' + query1.fieldByName('name').AsString + '-' + IntToStr(i) ]);

           // ����� ����������� � ������������ � ��������� � ���������
           mngData.AddLink( LNK_STRUCTURE, query1.fieldByName('id').AsInteger, ispolid );
           mngData.AddLink( LNK_NAVIGATION, query1.fieldByName('id').AsInteger, ispolid, 0 );

           lMainInfo.Caption := '���������� ' + IntToStr(j) + ', ' + IntToStr(i);
           Application.ProcessMessages;
       end;

       query1.Next;
   end;


   // ������ �� �������� �������
   mngData.AddLink( LNK_STRUCTURE, 0, izdid );
   mngData.AddLink( LNK_STRUCTURE, 0, blockid );
   mngData.AddLink( LNK_NAVIGATION, 0, specid, 0 );

   // �������� �������� ��������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 10'); // ��� ������������
   while not query1.eof do
   begin

       j := 1;

       // ������� �������� ������ � ������
       mngData.AddLink( LNK_STRUCTURE, izdid, query1.FieldByName('id').AsInteger );
       mngData.AddLink( LNK_NAVIGATION, specid, query1.FieldByName('id').AsInteger, 0 );

       inc(j);

       lMainInfo.Caption := Format('���������: %d',[j]);
       Application.ProcessMessages;

       query1.Next;
   end;


   // ������� ������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 7'); // ��� ������
   query2 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 4'); // ��� ������

   i := 1;

   if Assigned(query1) and Assigned(query2) then

   // ��� ������ ������
   while not query1.eof do
   begin

       j := 1;

       // ����� ������ ������
       while not query2.eof do
       begin

           // ������� �������� ������ � ������
           mngData.AddLink( LNK_STRUCTURE, query1.FieldByName('id').AsInteger, query2.FieldByName('id').AsInteger );

           query2.next;
           inc(j);

           lMainInfo.Caption := Format('������: %d, %d',[i, j]);
           Application.ProcessMessages;

       end;

       // �� ����, ����������� ������ � ������� ������ � ������ �������
       mngData.AddLink( LNK_STRUCTURE, blockid, query1.FieldByName('id').AsInteger );

       query2.First;
       query1.Next;
       inc(i);
   end;

   // ������� ����������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 11'); // ��� ����������
   query2 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 7'); // ��� ������

   if Assigned(query1) and Assigned(query2) then

   i := 1;

   // ��� ������� ���������
   while not query1.eof do
   begin

       j := 1;

       // ����� ������ ������
       while not query2.eof do
       begin

           // ������� �������� ������ � ���������
           mngData.AddLink( LNK_STRUCTURE, query1.FieldByName('id').AsInteger, query2.FieldByName('id').AsInteger );

           query2.next;
           inc(j);

           lMainInfo.Caption := Format('����������: %d, %d',[i, j]);
           Application.ProcessMessages;
       end;

       query2.First;
       query1.Next;
       inc(i);
   end;


   // ������� ������ ���������
   // ��� ������� ���������� ��������� ����� ��������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 11'); // ��� ����������
   i := 1;
   // ��� ������� ���������
   while not query1.eof do
   begin

       AddSection( query1.FieldByName('id').AsInteger, KIND_DETAIL,   '������' );
       AddSection( query1.FieldByName('id').AsInteger, KIND_STANDART, '����������� �������' );
       AddSection( query1.FieldByName('id').AsInteger, KIND_MATERIAL, '���������' );
       AddSection( query1.FieldByName('id').AsInteger, KIND_OTHER,    '������ �������' );
       AddSection( query1.FieldByName('id').AsInteger, KIND_ASSEMBL,  '��������� �������' );
       AddSection( query1.FieldByName('id').AsInteger, KIND_COMPLECT, '���������' );
       AddSection( query1.FieldByName('id').AsInteger, KIND_COMPLEX,  '���������' );

       lMainInfo.Caption := Format('�������: %d',[i]);
       Application.ProcessMessages;

       query1.Next;
       inc(i);
   end;

   // ������� �������� ������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+LNK_STRUCTURE);
   i := 1;
   while not query1.eof do
   begin

       mngData.CreateCrossLinks( LNK_STRUCTURE, query1.FieldByName('id').AsInteger );

       lMainInfo.Caption := Format('�������� ����.: %d / %d',[i, query1.RecordCount]);
       Application.ProcessMessages;

       query1.Next;
       inc(i);
   end;

   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+LNK_NAVIGATION);
   i := 1;
   while not query1.eof do
   begin

       mngData.CreateCrossLinks( LNK_NAVIGATION, query1.FieldByName('id').AsInteger );

       lMainInfo.Caption := Format('�������� ������: %d / %d',[i, query1.RecordCount]);
       Application.ProcessMessages;

       query1.Next;
       inc(i);
   end;

   mngSpecTree.Refresh;
   mngGroupTree.Refresh;
   ShowSubItems;

   lMainInfo.Caption := '';
   ShowMessage('���������');
end;


procedure TfMain.sbShowObjectCatalogClick(Sender: TObject);
begin
    // ����������� �������� ��������������� ���������� ����������� �����������
    (TfObjectCatalog.Create(self)).Show;
end;

procedure TfMain.sbSaveWorkVersionClick(Sender: TObject);
{ ���������� ������� ������ � ����.
  ������ ����� � ��������� ����������� (����������������), �������� ������ ������������� �� 1 }
var
    dsDoc: TDataset;
    filename
   ,hash
            : string;
begin
    // ���������� ���� ���������� ��������� � ������ ��������� ������ (������ ������� ���� � ��� ���������)
    if   not Assigned( fAddDoc )
    then fAddDoc := TfAddDoc.Create(self);

    dsDoc := grdDocs.DataSource.DataSet;

    filename := mngData.GetVersionPath( dsDoc.FieldByName('child').AsInteger, true );

    if not FileExists(filename) then
    begin
        ShowMessage( lW( '������� ���� ������ �����������. ���������� ��������.' + sLineBreak+ '(' + filename + ')'));
        exit;
    end;

    hash := mngFile.GetHash( filename );
    if hash = dsDoc.FieldByName('hash').AsString then
    begin
        ShowMessage( lW( '� ���� ' + ExtractFileName(filename) + ' �� ������� ���������. ���������� �������.'));
        exit;
    end;


    fAddDoc.object_id   := dsDoc.FieldByName('parent').AsInteger;
    fAddDoc.object_name :=
        '(' + dsDoc.FieldByName('parent').AsString + ') ' +
              dsDoc.FieldByName('object_name').AsString;
    fAddDoc.filename    := filename;
    fAddDoc.name        := dsDoc.FieldByName('filename').AsString;
    fAddDoc.version_id  := dsDoc.FieldByName('child').AsInteger;
    fAddDoc.version     := dsDoc.FieldByName('version').AsString;
    fAddDoc.doc_type    := dsDoc.FieldByName('type').AsInteger;
    fAddDoc.mode        := SAVE_MODE_NEW_VERSION; // ���������� ��������� ������
    fAddDoc.callback    := fMain.SaveWorkDocCallback;

    fAddDoc.Show;

end;

function TfMain.SaveWorkDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
begin

    result := false;

    if not mngData.UpdateDocumentVersion( version_id ) then
    begin
        ShowMessage( Core.DM.DBError );
        exit;
    end;

    // ��������� ������ ����������
    ShowSubItems;

    result := true;

end;




end.
