unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Vcl.StdCtrls, Data.DB, Data.Win.ADODB, MemTableDataEh, DataDriverEh,
  MemTableEh, Vcl.ExtCtrls, VirtualTrees, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList, Vcl.Mask, DBCtrlsEh, Vcl.Buttons,
  Vcl.OleCtrls, SHDocVw, EhLibADO, VCL.Imaging.jpeg,
  Vcl.Menus, uFileManager, System.IOUtils, ShellApi,

  uDatatableManager, uObjectCard, uUserList, uDataManager, uSpecifTreeManager;

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
    Panel2: TPanel;
    Panel3: TPanel;
    aSearch: TAction;
    dateSelected: TDBDateTimeEditEh;
    bRefresh: TImage;
    sbAddSection: TSpeedButton;
    sbEditSection: TSpeedButton;
    sbDelSection: TSpeedButton;
    pcObjects: TPageControl;
    tsObjects: TTabSheet;
    grdDocs: TDBGridEh;
    iPreview: TImage;
    mDocComment: TMemo;
    ilDocTypes: TImageList;
    ilAgree: TImageList;
    ilInwork: TImageList;
    bCreateDocPreview: TButton;
    popObject: TPopupMenu;
    ilHas_docs: TImageList;
    sbShowObjectCatalog: TSpeedButton;
    mnMain: TMainMenu;
    N1: TMenuItem;
    Panel7: TPanel;
    lMainInfo: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    popDocument: TPopupMenu;
    menuOpenFile: TMenuItem;
    N10: TMenuItem;
    popNavFavorite: TPopupMenu;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    popNavEvents: TPopupMenu;
    N14: TMenuItem;
    popNavWorkObjects: TPopupMenu;
    sbCreateProject: TSpeedButton;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Panel9: TPanel;
    Splitter4: TSplitter;
    N15: TMenuItem;
    N5: TMenuItem;
    menuWorkgroupEdit: TMenuItem;
    menuGroupEdit: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    menuProgrammHelp: TMenuItem;
    N9: TMenuItem;
    menuUserChange: TMenuItem;
    N16: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure button1Click(Sender: TObject);
    procedure aAdminPanelExecute(Sender: TObject);
    procedure bAddSectionClick(Sender: TObject);
    procedure bEditSectionClick(Sender: TObject);
    procedure grdGroupGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure grdGroupSelectionChanged(Sender: TObject);
    procedure grdGroupCellClick(Column: TColumnEh);
    procedure grdSpecificCellClick(Column: TColumnEh);
    procedure sbDelSectionClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sbAddObject_Click(Sender: TObject);
    procedure pcObjectsChange(Sender: TObject);
    procedure grdDocsApplyFilter(Sender: TObject);
    procedure bCreateDocPreviewClick(Sender: TObject);
    procedure grdDocsCellClick(Column: TColumnEh);
    procedure sbOpenDocClick(Sender: TObject);
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
    procedure sbShowObjectCatalogClick(Sender: TObject);
    procedure grdObjectApplyFilter(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure grdSpecificDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure grdGroupDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdGroupDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure grdObjectDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdObjectDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sbAddObjectClick(Sender: TObject);
    procedure sbOpenCardClick(Sender: TObject);
    procedure grdGroupColumns0CellButtons0Down(Sender: TObject;
      TopButton: Boolean; var AutoRepeat, Handled: Boolean);
    procedure grdObjectColumns3CellButtons0Down(Sender: TObject;
      TopButton: Boolean; var AutoRepeat, Handled: Boolean);
    procedure sbCreateProjectClick(Sender: TObject);
    procedure grdObjectCellClick(Column: TColumnEh);
    procedure grdObjectDblClick(Sender: TObject);
    procedure grdDocsDblClick(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure menuWorkgroupEditClick(Sender: TObject);
    procedure menuGroupEditClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure menuProgrammHelpClick(Sender: TObject);
    procedure menuUserChangeClick(Sender: TObject);
    function ChangeUser( user_id: integer ): string;
    procedure N16Click(Sender: TObject);
  private
    { Private declarations }
    wndUserList : TfUserList;
    wndArrProject : array of TForm;

    fConfig: string;
    /// ��� ������������, ������� � ������ ������ ���������� ��� ������� grdObjects.
    /// ����� ��������� ������������ ��������� ������������ ����� � ������ ��������
    /// � ����������� �� ���������� ������� � ��������� �������� �����.
    /// ���� ������������ ����������� ��� ������������� ���������.

    procedure EditSection;
    procedure EditObject;
    procedure ShowPreview( filename: string );

  public
    { Public declarations }
    procedure SetCaption;

    procedure OnGroupCellChange;
    procedure ShowSubItems;

    function CreateNavigationObject( parent, child: integer; fields: string; values: array of variant ): integer;
    function CreatePreview( path, filename: string ): boolean;
    procedure ClearStructure;

    procedure ObjectPageCardCallback;
    procedure CreateWorkTree;
    function CreateStructTree(var SpecSection, AssSecttion: integer): integer;
    procedure RefreshFilePreview;
    procedure ShowObjectCard;

    function CreateProject(name, mark: string; objectId, workgroupId: integer; comment, parent_prod_kod, prod_kod: string): boolean;
        // ������� ���������� �� ������ �������� �������, ����� ������������ ������������ ��������
        // ���������� callback �����������, ����� �� ���������� ������ �������������� �����
        // � ����� ����������� ������ ���������, ��������� ������ callback ������

    function OpenProject( project_id: integer; pname, mark: string): TForm;
        // �� ���������� id ��������� ���� ������� � ���������� � ���� ��� ������

    procedure ClearProjectWndLink( form: TForm );
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
    Math, uAddDoc, uObjectCatalog, uSpecTreeFree,
    uAddProject, uCommonOperations, uKompasManager, uWorkGroupEditor,
    uRolesEditor, uProject;

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
    SPC_COL_CHILD = 4;      // id �������

    // ������� ������� ������
    SRH_COL_LID   = 3;      // id ������ �����
    SRH_COL_CHILD = 4;      // id �������

    // ������� ������� � ��������� (grdObject)
    COL_OBJECT_FILE_BUTTONS = 5;


{$R *.dfm}


procedure TfMain.FormShow(Sender: TObject);
var
   error: string;
begin

    fWelcome := TfWelcome.Create(nil);
    fWelcome.Show;

    // ��������������
    Core := TCore.Create;
    if not Core.Init(
                PROG_NAME,
                CONNECTION_STRING,
                '',
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

{$IFDEF test}
//    CORE.User.initUserByID(27);
{$ENDIF}

//    Core.Settings.RestoreForm(self);

    fWelcome.Progress(10);

    // ��������� ������ �����
    mngGroupTree := TTreeManager.Create;
    mngGroupTree.init(grdGroup, VIEW_GROUP);
//    mngGroupTree.GetTreeLevel(0,0);
    mngGroupTree.Refresh([]);

    fWelcome.Progress(10);

    // ��������� ������ ������������
    mngSpecTree := TTreeManager.Create;
    mngSpecTree.SetExtFields(['full_name'], ['ftString']);
    mngSpecTree.init(grdSpecific, VIEW_OBJECT);
//    mngSpecTree.GetTreeLevel(0,0);
    // ����� ���������� ������ �� ��������� ������� ������, ��� ���������
    // ��������� ���������� ��������, ��� ���� ��������� �����, ���������
    // ��������� �� ��������� �������� ��������� ���, ���, ��������, VirtualTree
    mngSpecTree.Refresh([]);

    fWelcome.Progress(10);

    // �������������� ������ ���������� � ������� � �� ����������
    mngFile := TFileManager.Create;
    mngDatatable := TDatatableManager.Create;

    // ������� �������� � ������������ ������� ������������� ������� � ���� ������
    // ����������, ��������, ��������� �������� � ������ � ��������������
    // ��������������� ������� ���������
    mngData := TDataManager.Create;

    mngKompas.sTempPath( DIR_TEMP );

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

    /// ������������ ����� �����������
    if mngDatatable.CreateConfiguration( COL_CONFIG_DEF ) then
    begin
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'kind', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100;');
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'icon', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100');
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'has_docs', '', FIELD_KIND_IMAGE, 20, true, true, ilHas_docs, '0,1');
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'full_mark', '�����������', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'name', '������������', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'count', '���-��', FIELD_KIND_TEXT, 50);
    end;

    /// ������������ ��� ������ ������ ��������
    if mngDatatable.CreateConfiguration( COL_CONFIG_PROJECT ) then
    begin
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'kind', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100');
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'icon', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100');
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'has_docs', '', FIELD_KIND_IMAGE, 20, true, true, ilHas_docs, '0,1');
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'full_mark', '�����������', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'name', '������������', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'parent_kod', '���', FIELD_KIND_TEXT, 50);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'kod', '���������', FIELD_KIND_TEXT, 200);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'created', '������', FIELD_KIND_TEXT, 50);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'user_name', '�����', FIELD_KIND_TEXT, 80);
    end;

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
    SetCaption;

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

procedure TfMain.bAddSectionClick(Sender: TObject);
begin
    if not Assigned(fEditSection) then
       fEditSection := TfEditSection.Create(self);

    fEditSection.Mode := 0;  // �������� �������
    fEditSection.ParentId := mngGroupTree.GetValue('mem_child');
    fEditSection.ItemsKind := 0;
    fEditSection.SectionName := '����� ������';

    if fEditSection.ShowModal = mrOk then
    begin

        mngGroupTree.Expand;

        // ������� ������� � ����
        CreateNavigationObject(
            fEditSection.NewParentId,            // ��������
            0,                                   // ������ (����� ������ �����)
            'icon, kind, name',          // ����� ����������� ��� �������� �����
            [
                fEditSection.NewItemsKind,       // ��� ���������
                KIND_SECTION,                    // �������� ��� �������
                fEditSection.NewSectionName      // ������������ �������
            ]
        );

        // ��������� ������
        mngGroupTree.Refresh([]);

    end;
end;



procedure TfMain.bEditSectionClick(Sender: TObject);
begin

    if   mngGroupTree.GetValue('kind') = KIND_SECTION
    then EditSection
    else EditObject;

end;

procedure TfMain.bRefreshClick(Sender: TObject);
begin
    mngSpecTree.Refresh([]);
end;

procedure TfMain.EditSection;
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
        mngGroupTree.Refresh([]);
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
        mngGroupTree.Refresh([]);
    end;
end;

procedure TfMain.sbAddObjectClick(Sender: TObject);
begin
    ( TfObjectCard.Create( self, OBJECT_CARD_MODE_CREATE, ObjectPageCardCallback ) ).Show;
end;


procedure TfMain.sbAddObject_Click(Sender: TObject);
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
        mngGroupTree.Refresh([]);

    end;

end;

procedure TfMain.sbCreateProjectClick(Sender: TObject);
/// ������� �� ������ �������� �������. ���������� �����. ���� ��� �� ��������
/// ���� ��� ��������, ����������� �� ������ ������������ ������ �� ������
/// �������� �������� ��� �������������� ����������� � ���� ������������ ��������
/// ������������
begin

    if not mngData.HasRole( ROLE_CREATE_PROJECT ) then
    begin
        ShowMessage('����������� ���� �������� �������');
        exit;
    end;

    if fAddProject.Visible then exit;

    fAddProject.Reset;

    fAddProject.callback := CreateProject;

    fAddProject.Show;

end;

function TfMain.CreateProject(name, mark: string; objectId, workgroupId: integer; comment, parent_prod_kod, prod_kod: string): boolean;
/// ���������� ��� ������� �� ������ �������/������������� ����� �������� �������
/// ��������� �� ����������� �������� � ������� ������. ��������� �����
/// �������������� ������� ��� �������� ��������
var
    project_id: integer;
begin

    result := false;

    // �������� ������� ������
    project_id := mngData.CreateProject( name, comment, mark, parent_prod_kod, prod_kod, objectId, workgroupId );
    if project_id = 0 then
    begin
        ShowMessage( lW( CORE.DM.DBError ) );
        exit;
    end;

    OpenProject( project_id, name, mark );

    result := true;
end;

procedure TfMain.sbDelSectionClick(Sender: TObject);
begin
    if  Application.MessageBox(
            '������� ������ �� ������?',
            '��������',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    // ������� ������ �� ����
    if not mngData.DeleteLink( LNK_NAVIGATION, mngGroupTree.GetValue('mem_aChild'), DEL_MODE_FULL_USER ) then exit;

    // ��������� ������
    mngGroupTree.Refresh([]);
end;

procedure TfMain.sbOpenCardClick(Sender: TObject);
begin
    ShowObjectCard;
end;

procedure TfMain.ObjectPageCardCallback;
begin
    ShowSubItems;
end;

procedure TfMain.sbOpenDocClick(Sender: TObject);
begin
    OpenFilePreview( grdDocs.DataSource.DataSet );
end;

procedure TfMain.sbOpenVersionDirClick(Sender: TObject);
{ ������� ������ �������� ����� � ���������� � ������ �������� ��� �������
  ��������� "��������� � ������"
}
var
    path: string;
begin
    path := mngData.GetVersionPath( grdDocs.DataSource.DataSet.FieldByName('mem_child').AsInteger );
    ShellExecute(Application.Handle, 'explore', PChar(path), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfMain.OnGroupCellChange;
var
   isUserObject: boolean;
begin
    // ����������� ������ ��������������/�������� ��������
    sbAddSection.Enabled := grdGroup.SelectedIndex <> -1;

    isUserObject := StrToIntDef(grdGroup.Columns[GRP_COL_LUID].DisplayText, 0) = Core.User.id;
    sbEditSection.Enabled := isUserObject;
    sbDelSection.Enabled := isUserObject;

    // ����� ������ ������������ �������� ���������� � ������ ��������
    ShowSubItems;

    // ����� ������ ������ ����������� �������
    RefreshFilePreview;

    // ���� ������� ���� �������� �������, �������� ��� ������ �������� ����������
    // �������� ������ ������������, ����� ���������� ������, ���� ��������
//    if   assigned(fAddProject)
//    then fAddProject.SelectSpecification( grdSpecific.DataSource.DataSet );

end;

function TfMain.OpenProject(project_id: integer; pname, mark: string ): TForm;
/// ����� ���������� ������ ������� �� ��� id � ��������� ����� ������ � ���
var
    i : integer;
begin

    result := nil;

    // ���������, �� ������ �� ��� ����� ������
    for i := 0 to High(wndArrProject) do
    if Assigned(wndArrProject[i]) and (TfProject(wndArrProject[i]).ProjectID = project_id)
    then result := wndArrProject[i];

    if not Assigned(result) then
    begin
        result := TfProject.Create(self);
        with TfProject(result) do
        begin
            ProjectID := project_id;
            ProjectName := pname;
            ProjectMark := mark;
            Init;
            Show;
        end;

        /// ����� � ������ ����� ���� �������
        SetLength(wndArrProject, Length(wndArrProject)+1);
        wndArrProject[High(wndArrProject)] := result;
    end;
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
/// ������ �� �������� ��������� ������, ���������� � ������� ������ �����������
/// ��������� (���� ����������)
var
    config : string;
begin

    // �������� ����� ��������� �������� �� �� ������ �������� �����
    if pnNavigation.ActivePage = pageGroups then
    begin
        grdObject.DataSource.DataSet :=
             mngData.GetGroupSubitems(
                 grdGroup.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                 grdGroup.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
                 'kind, icon, has_docs, mark, name, child, full_mark',
                 grdObject.DataSource.DataSet
             );

        // �������� ������ ���������� �������� ��������. ���� ��� ������ - � ���� ����� ���� ������������ �������, ��� ���� �����������
        grdDocs.DataSource.DataSet :=
            mngData.GetKDDocsList(
                grdGroup.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                grdGroup.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
                grdDocs.DataSource.DataSet
            );

        /// �������� ��������� ����� ��� ������� ��������� ���������, ������ �� ���������� � ������ ���������
        config := mngData.GetColConfigName( grdGroup.DataSource.DataSet.FieldByName('mem_child').AsInteger, COL_CONFIG_DEF );
        /// ������������ �� ��������� ��� ���������� �� ��������� �����������
        if config <> fConfig then
        begin
            /// ��������� ������������ �������� � ���������� ��� ��������� �����������
            mngDatatable.ApplyConfiguration( config, grdObject );
            fConfig := config;
        end;

    end;

    // �������� ����� ��������� �������� �� �� ������ ������������
    if   pnNavigation.ActivePage = pageSpecif then
    begin
        grdObject.DataSource.DataSet :=
            mngData.GetSpecifSubitems(
                grdSpecific.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                grdSpecific.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
                'kind, icon, has_docs, mark, name, count, child, full_mark',
                grdObject.DataSource.DataSet
            );

        // �������� ������ ���������� �������� ���������� � ������ �������
        grdDocs.DataSource.DataSet :=
            mngData.GetKDDocsList(
                grdObject.DataSource.DataSet.FieldByName('child').AsInteger,
                grdObject.DataSource.DataSet.FieldByName('kind').AsInteger,
                grdDocs.DataSource.DataSet
            );
    end;
end;

procedure TfMain.SpeedButton2Click(Sender: TObject);
begin
    // ����������� �������� ��������������� ���������� ����������� �����������
    TfSpecTreeFree.Create(self, VIEW_OBJECT).Show;
end;

procedure TfMain.SpeedButton3Click(Sender: TObject);
begin
    TfSpecTreeFree.Create(self, VIEW_GROUP).Show;
end;

procedure TfMain.RefreshFilePreview;
var
    dataset: TDataSet;
    image: TImage;
    filename : string;
begin

    dataset := grdDocs.DataSource.DataSet;

    iPreview.Picture := nil;
    mDocComment.Lines.Text := '';

    if not Assigned(dataset) or
       not dataset.Active or
       (dataset.RecordCount = 0)
    then
        exit;

    mDocComment.Lines.Text := DataSet.FieldByName('doc_comment').AsString;


    filename := DIR_PREVIEW + '(' + dataset.FieldByName('version').AsString + ')' + ChangeFileExt( dataset.FieldByName('filename').AsString, '.jpg');

    if Not FileExists( filename ) then
    begin
        if mngData.GetFileFromStorage( DIR_PREVIEW, filename, dataset.FieldByName('GUID').AsString ) then
        CreatePreview( DIR_PREVIEW, filename );
    end;

    // �������� ���������, ���� ����
    if   FileExists( filename )
    then ShowPreview( filename );

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
   ,sec_specif
            : integer;

   query1, query2: TADOQuery;

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

   CreateWorkTree;

   CreateStructTree( sec_specif, sec_assembly);

   // �������� ������� � ����������
   spec1  := mngData.AddObject('kind, icon, name, mark', [ KIND_COMPLEX, KIND_SPECIF, '���.7774', '���5.01.02.100�' ], TBL_OBJECT);
   isp1_1 := mngData.AddObject('kind, icon, name, mark', [ KIND_COMPLEX, KIND_ISPOLN, '���.7774', '���5.01.02.100�' ], TBL_OBJECT);
   isp1_2 := mngData.AddObject('kind, icon, name, mark, realization', [ KIND_COMPLEX, KIND_ISPOLN, '���.7774', '���5.01.02.100�', '1' ], TBL_OBJECT);


   // ������������ � ���������� ����� ����������� � ������ ���������
//   mngData.AddLink( LNK_STRUCTURE, sec_specif, spec1 );
//   mngData.AddLink( LNK_STRUCTURE, spec1, isp1_1 );
//   mngData.AddLink( LNK_STRUCTURE, spec1, isp1_2 );


   // ���������� ��������� �������, ����� ���������� � ������� "��������� �������" ������ ���������
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.110�', '�������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name, realization', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.110�', '�������', '1' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.120�', '����������� ��������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.130�', '����������� ������ ����������������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name, realization', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.130�', '����������� ������ ����������������', '1' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.140�', '���������� ��������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.150�', '�����������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.160�', '�����������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.170�', '�����������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.200�', '�������' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name, realization', [ KIND_ASSEMBL, KIND_ISPOLN, '���5.01.02.200�', '�������', '1' ], TBL_OBJECT) );

   // ���������� ������
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '814-17.2.04.00.007', '������' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '2013.136.00.007', '���������' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '2013.136.01.012', '�����' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.101�', '��������' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name, realization', [ KIND_DETAIL, '���5.01.02.101�', '��������', '1' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.102�', '��������' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.01.02.103�', '��������' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '���5.02.02.101�', '�����' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '��.81.44.000-23', '��������� ��� � ���� 15180-86' ], TBL_OBJECT);

   // ���������� ����������� �������
   mngData.AddObject('kind, name', [ KIND_STANDART, '���� � ������������ �������� ���� � ��� 4017-�12�40-5.6' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '����� ��16-6�.35.III.3.019 ���� 9064-75' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '����� ������������ ���������� ���� ISO 4032-�12-8-�3�' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������ 50-16-01-�-��09�2����� 33259-2015' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� �165-6gx100 ���� 22042-76' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� �16-6g�300.58.019���� 22042-76' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '�������� 2,5�7.00���� 10299-80' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '����� �.16.01.08��.016 ���� 11371-78' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� ��16-6gx95.32.35.III.2.019 ���� 9066-75' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, '������� ��16-6g�70.32.35.III.2.019 ���� 9066-75 �������. �1083079' ], TBL_OBJECT);

   // ������ �������
   mngData.AddObject('kind, name', [ KIND_OTHER, '��������������� ���.������ 1/2 �������. �755855' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ ������� ���-25��,����������: � ����������, 6,3 ��� (��������� ���� ����1�-20), ��� ��� ���-25� �� �� 2,5 ���, �������� ��������� ����� �0618/18 �� 28.07.2018 �������. �1160137' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ �������� ������������ �����������WB 26 �� 50 �� 16 ���/��2�������. �1031654' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ ���������� VT.539.N.04 1/2" �������. �751589' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '���� ������� �������� ���� 025.016.10-03� ��1 DN 25 PN 16 ���/��2 �� 3742-002-52838824-2006  �������. �:1040810' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '�������� ��22� (6 ���)-�20-1,5 �� 4212-002-4719015564-2008�������. �1225261' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '�������� ��3-� 0...16 ���/��2 �� 311-00225621.167-97' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '�������� ��3-��2-(0...1)���/��2-1,5 �20�1,5���������� ��� ������ �� 25-02.180335-84 �������. �1220625' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������� � 57�5-32�4 ���� 17378-2001 �������. �1062104' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, '������ 2-032-40 ���� 12821-80' ], TBL_OBJECT);

   // ���������
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, '���� �-��-�-1,5x1250x2500 ���� 19904-90/��360�-4-IV-��3 ���� 16523-97' ], TBL_OBJECT);
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, '��������� 3-12�18�10� ���� 18143-72' ], TBL_OBJECT);
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, '����� �4-1,6 ���� 3306-88' ], TBL_OBJECT);
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, '������� ��� ���� 14791-79' ], TBL_OBJECT);

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
   mngSpecTree.Refresh([]);
   mngGroupTree.Refresh([]);

   ShowMessage('��������� ���������');
end;

procedure TfMain.Button4Click(Sender: TObject);
var
  a,b:integer;
begin
   ClearStructure;

   CreateWorkTree;
   CreateStructTree(a,b);

   ShowSubItems;
   mngSpecTree.Refresh([]);
   mngGroupTree.Refresh([]);

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
        result := mngData.AddObject( fields, values, TBL_OBJECT );
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
begin
    (Sender as TDBGridEh).DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( Sender as TDBGridEh );
end;

procedure TfMain.grdDocsCellClick(Column: TColumnEh);
begin
     RefreshFilePreview;
end;

procedure TfMain.grdDocsDblClick(Sender: TObject);
begin
    OpenFilePreview( grdDocs.DataSource.DataSet );
end;

procedure TfMain.SetCaption;
begin
    Caption := 'PDM �������� ' + '(' + GetFileVersion() + ') ' + '(' + CORE.User.name + ') ';
end;

procedure TfMain.ShowObjectCard;
begin
    TfObjectCard.Create( self, OBJECT_CARD_MODE_VIEW, ObjectPageCardCallback, grdObject.DataSource.DataSet ).Init.Show;
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

    if mngData.GetFileFromStorage( DIR_TEMP, '('+ dataset.FieldByName('version').AsString +')' + dataset.FieldByName('filename').AsString, dataset.FieldByName('fullname').AsString ) then

    CreatePreview( DIR_TEMP, '('+ dataset.FieldByName('version').AsString +')' + dataset.FieldByName('filename').AsString );

    ShowPreview( DIR_PREVIEW + '('+ dataset.FieldByName('version').AsString +')' + ChangeFileExt( dataset.FieldByName('filename').AsString, '.jpg' ));
end;

function TfMain.CreatePreview( path, filename: string ): boolean;
var
    image: TImage;
    jpg: TJPEGImage;
begin
    if FileExists( path + filename ) then
    begin
        image := TImage.Create(nil);
        image.Picture.Bitmap.Handle := mngFile.GetThumbnailImage( DIR_TEMP + filename, IMAGE_PREVWIEW_SIZE, IMAGE_PREVWIEW_SIZE);

        jpg:=TJPEGImage.Create();
        jpg.Assign(image.Picture.Graphic);
        jpg.CompressionQuality:=60;
        jpg.Compress();
        jpg.SaveToFile( DIR_PREVIEW + ChangeFileExt( filename, '.jpg' ) );
        jpg.Free;

    end;
end;

function TfMain.CreateStructTree(var SpecSection, AssSecttion: integer): integer;
begin
   SpecSection := mngData.AddObject('kind, name', [ KIND_SECTION, SECTION_SPECIF ], TBL_OBJECT);
   AssSecttion := mngData.AddObject('kind, name', [ KIND_SECTION, SECTION_ASSEMBLY ], TBL_OBJECT);

   mngData.AddLink( LNK_STRUCTURE, 0, SpecSection );
   mngData.AddLink( LNK_STRUCTURE, 0, AssSecttion );
end;

procedure TfMain.grdGroupCellClick(Column: TColumnEh);
begin
    OnGroupCellChange;
end;

procedure TfMain.grdGroupColumns0CellButtons0Down(Sender: TObject;
  TopButton: Boolean; var AutoRepeat, Handled: Boolean);
begin
    (sender as TDBGridCellButtonEh).DropdownMenu := nil;

    // ������ ������ ��������� � ������
    if   ( grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_PROJECT_ALL ) or
         ( grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_PROJECT_MY )
    then (sender as TDBGridCellButtonEh).DropdownMenu := popNavWorkObjects;

    // ������ ������ ����������
    if   grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_FAVORITE
    then (sender as TDBGridCellButtonEh).DropdownMenu := popNavFavorite;


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


    /// � ������ ���������� ������ ���������� ���� � id ������������� �������
    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('child'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('child').AsInteger;

    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('id'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('id').AsInteger;

    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('mem_child'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('mem_child').AsInteger;


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

    mngGroupTree.Refresh([]);
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

procedure TfMain.grdObjectCellClick(Column: TColumnEh);
begin
    OnGroupCellChange;
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

procedure TfMain.grdObjectColumns3CellButtons0Down(Sender: TObject;
  TopButton: Boolean; var AutoRepeat, Handled: Boolean);
begin
    (sender as TDBGridCellButtonEh).DropdownMenu := popObject;
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

procedure TfMain.grdObjectDblClick(Sender: TObject);
/// ������� ������ �� ������� � ������. ���������� ��������, ������ �� ��� ����
///    - ����� - ������
///    - ������ - ��������� ����� �������
///    - ������ - ��������� ��������
///    - ���� - ��������� ��� ���������
var
    dataset : TDataset;
begin

    dataset := grdObject.DataSource.DataSet;

    // �������� ������������ �������
    if not Assigned(dataset) or
       not dataset.Active or
       (dataset.RecordCount = 0) or
       not Assigned( dataset.FindField('kind')) or
       not Assigned( dataset.FindField('child'))
    then
        exit;

    // �������� �������� ������ �� ���� �������
    case dataset.FieldByName('kind').AsInteger of
        KIND_PROJECT  :
        begin
            OpenProject(   dataset.FieldByName('child').AsInteger,
                           dataset.FieldByName('name').AsString,
                           dataset.FieldByName('mark').AsString
                        ).BringToFront;
        end;
        KIND_SECTION  : {nothing};
        else           ShowObjectCard;
    end;
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

    mngSpecTree.Refresh([]);
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
{    fMain.Cursor := crHourGlass;

    TargetGrid := (Sender as TDBGridEh);
    SourceGrid := (Source as TDBGridEh);

    coord := TargetGrid.MouseCoord(X, Y);
    TargetGrid.DataSource.DataSet.RecNo := coord.y + 1;

    if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('child'))
    then child_id := SourceGrid.DataSource.DataSet.FieldByName('child').AsInteger
    else child_id := SourceGrid.DataSource.DataSet.FieldByName('id').AsInteger;

    parent_id := TargetGrid.DataSource.DataSet.FieldByName('child').AsInteger;

//    mngData.AddLink( LNK_STRUCTURE, parent_id, child_id );

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

    mngSpecTree.Expand;
    mngSpecTree.Refresh;

    fMain.Cursor := crDefault;
}
end;

procedure TfMain.menuGroupEditClick(Sender: TObject);
begin
    if not mngData.HasRole( ROLE_ROLES_CONFIGURE ) then
    begin
        ShowMessage('����������� ���� �������������� ����� �����');
        exit;
    end;

    if not Assigned(fRolesEditor) then
    fRolesEditor := TfRolesEditor.Create(self);

    fRolesEditor.Show;
end;

procedure TfMain.menuProgrammHelpClick(Sender: TObject);
begin
    ShellExecute(0, 'open', PChar( DIR_SHARED + FILE_NAME_PROGRAMM_HELP ), nil, nil, SW_SHOWNORMAL);
end;

procedure TfMain.menuUserChangeClick(Sender: TObject);
begin
    if not mngData.HasRole( ROLE_SET_CURRENT_USER ) then
    begin
        ShowMessage('����������� ���� ����� ������������');
        exit;
    end;

    if not Assigned(wndUserList)
    then
        wndUserList := TfUserList.Create(self).SetCallback(ChangeUser)
    else
        wndUserList.BringToFront;

    wndUserList.Show;

end;

function TfMain.ChangeUser( user_id: integer ): string;
/// ���������� ������ ������������ �� ������.
/// ������������ ���������� �� ������� ������ ������ ����� TfUserList
begin
    result := '';

    if user_id <> 0 then
    begin
        // ��������� �������� ������������
        Core.User.initUserByID( user_id );

        lM('������ ����� ������������: ' + Core.User.name );

        // �������������� ���������� ������ � ��� ������
        mngData.RefreshRolesList( true );

        SetCaption;
    end;

end;

procedure TfMain.menuWorkgroupEditClick(Sender: TObject);
begin
    if not mngData.HasRole( ROLE_WORKGROUPS_CONFIGURE ) then
    begin
        ShowMessage('����������� ���� �������������� ������� �����');
        exit;
    end;

    if not Assigned(fWorkgroupEditor) then
    fWorkgroupEditor := TfWorkgroupEditor.Create(self);

    fWorkgroupEditor.Show;
end;

procedure TfMain.N16Click(Sender: TObject);
begin
    ShellExecute(0, 'open', PChar( DIR_SHARED + FILE_NAME_VERSION_CHANGE ), nil, nil, SW_SHOWNORMAL);
end;

procedure TfMain.N7Click(Sender: TObject);
/// ��������� ���������� ������ � ����� �� ����
begin
    mngData.RefreshRolesList( true );  // �������������� ���������� ������
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

procedure TfMain.ClearProjectWndLink(form: TForm);
/// ����� ���������� ��� �������� ����� �������, ����� ������ ������ �� ����
/// �� ������� ��������, ��� �������� ������� ����� ���� ��� ��������������
var
    i: integer;
begin
    for I := 0 to High(wndArrProject) do
    if wndArrProject[i] = form
    then wndArrProject[i] := nil;
end;

procedure TfMain.ClearStructure;
begin
   dmEQ('DELETE FROM '+TBL_OBJECT);
   dmEQ('DELETE FROM '+TBL_OBJECT + '_history');

   // ��������� �������
   dmEQ('DELETE FROM '+LNK_STRUCTURE);
   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_cross');
   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_history');

   // �������� ���������
   dmEQ('DELETE FROM '+LNK_NAVIGATION);
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_cross');
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_history');

   // ������� ������ � �����������
   dmEQ('DELETE FROM '+TBL_DOCUMENT_EXTRA);

   // �������
   dmEQ('DELETE FROM '+TBL_PROJECT);
   dmEQ('DELETE FROM '+LNK_PROJECT_STRUCTURE);
   dmEQ('DELETE FROM '+LNK_PROJECT_STRUCTURE+'_cross');
   dmEQ('DELETE FROM '+TBL_PROJECT_EXTRA);
   dmEQ('DELETE FROM '+LNK_PROJECT_EXTRA);
   dmEQ('DELETE FROM '+TBL_PROJECT_OBJECT_EXTRA);
   dmEQ('DELETE FROM '+LNK_PROJECT_OBJECT_EXTRA);
   dmEQ('DELETE FROM '+LNK_PROJECT_EDITOR);
   dmEQ('DELETE FROM '+LNK_PROJECT_CHECKER);

   // ��������� ����������
   dmEQ('DELETE FROM '+TBL_FILE);

   dmEQ('DELETE FROM '+TBL_CUSTOM_SQL);
end;

procedure TfMain.CreateWorkTree;
var
   tmpID
  ,tmpID2
           : integer;
   q0, q1: TDataset; // ������ ���������������� ������ ������ �������������� ���������

   function AddSection(id, icon: integer; section: string): integer;
   begin
       result := mngData.AddObject('kind, name, icon', ['1', section, icon], TBL_OBJECT);
       mngData.AddLink( LNK_NAVIGATION, id, result, 0 );
   end;

begin

   // ������� � ����� ����������� �������� �������������� ������� ������ ���������
   mngData.AddSection(0, SECTION_DOCUMENTS, TAG_SELECT_DOCUMENTS, VIEW_DOCUMENT_KD, '', COL_CONFIG_DEF, 0 );

   tmpID := mngData.AddSection( 0, SECTION_DOCUMENT_INWORK, TAG_SELECT_DOCUMENTS, VIEW_DOCUMENT_PROJECT, 'minor_version IS NOT NULL', COL_CONFIG_DEF, 0 );
   mngData.AddSection( tmpID, SECTION_DOCUMENT_MY, TAG_SELECT_DOCUMENTS, VIEW_DOCUMENT_PROJECT, 'autor_id = #USER_ID# AND minor_version IS NOT NULL', COL_CONFIG_DEF, 0 );
   mngData.AddSection( tmpID, SECTION_DOCUMENT_OTHER, TAG_SELECT_DOCUMENTS, VIEW_DOCUMENT_PROJECT, 'autor_id <> #USER_ID# AND minor_version IS NOT NULL', COL_CONFIG_DEF, 0 );

   tmpID := mngData.AddSection( 0, SECTION_PROJECT_ALL, TAG_SELECT_OBJECTS, VIEW_PROJECT, '', COL_CONFIG_PROJECT, 0 );
   mngData.AddSection( tmpID, SECTION_PROJECT_MY, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'uid = #USER_ID# AND status <> '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );
   mngData.AddSection( tmpID, SECTION_PROJECT_FAVORITE, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'uid = #USER_ID# AND status <> '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );
   mngData.AddSection( tmpID, SECTION_PROJECT_OTHER, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'uid <> #USER_ID# AND status <> '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );
   mngData.AddSection( tmpID, SECTION_PROJECT_ARCHIVE, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'status = '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );
   mngData.AddSection( tmpID, SECTION_PROJECT_INWORK, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'status = '+IntToStr(PROJECT_INWORK), COL_CONFIG_PROJECT, 0 );

   AddSection( 0, KIND_NONE, SECTION_EVENTS );
   AddSection( 0, KIND_NONE, SECTION_MESSAGES );
   AddSection( 0, KIND_NONE, SECTION_FAVORITE );

   /// ������ ��������� ���������� �������� �� ��������������
   /// �������� ������ �������� ������
   q0 := mngData.GetTypeProdLevel(0);
   if assigned(q0) and (q0.RecordCount > 0) then
   while not q0.eof do
   begin
       /// ��������� ������� �������� ������
       tmpID2 := mngData.AddSection( tmpID, q0.FieldByName('name'{'kod'}).AsString, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'parent_kod = '''''+q0.FieldByName('kod').AsString+''''' AND status <> '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );

       /// �������� ��� ��� ��������� � ��������� � ������
       q1 := mngData.GetTypeProdLevel(q0.FieldByName('id').AsInteger);
       if assigned(q1) and (q1.RecordCount > 0) then
       while not q1.eof do
       begin
           mngData.AddSection( tmpID2, q1.FieldByName('name'{'kod'}).AsString, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'kod = '''''+q1.FieldByName('kod').AsString+''''' AND status <> '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );
           q1.Next;
       end;
       q0.Next;
   end;

{
   AddSection( 0, KIND_NONE, SECTION_DOCUMENTS );

   tmpID := AddSection( 0, KIND_NONE, SECTION_DOCUMENT_INWORK );
   AddSection( tmpID, KIND_NONE, SECTION_DOCUMENT_MY );
   AddSection( tmpID, KIND_NONE, SECTION_DOCUMENT_OTHER );

   tmpID := AddSection( 0, KIND_NONE, SECTION_OBJECT_INWORK );
   AddSection( tmpID, KIND_NONE, SECTION_OBJECT_MY );
   AddSection( tmpID, KIND_NONE, SECTION_OBJECT_FAVORITE );
   AddSection( tmpID, KIND_NONE, SECTION_OBJECT_OBJECT );

   AddSection( 0, KIND_NONE, SECTION_EVENTS );
   AddSection( 0, KIND_NONE, SECTION_MESSAGES );
   AddSection( 0, KIND_NONE, SECTION_FAVORITE );
}

end;

procedure TfMain.button1Click(Sender: TObject);
var
   i, j
   ,izdid
   ,blockid
   ,ispolid
   ,userID
   ,tmpID
   : integer;
   query1, query2: TADOQuery;

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

   CreateWorkTree;

   // ��������� �������� �������
   izdid   := mngData.AddObject('kind, name', [ KIND_SECTION, '�������' ]);
   blockid := mngData.AddObject('kind, name', [ KIND_SECTION, '������' ]);

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

           lMainInfo.Caption := '���������� ' + IntToStr(j) + ', ' + IntToStr(i);
           Application.ProcessMessages;
       end;

       query1.Next;
   end;


   // ������ �� �������� �������
   mngData.AddLink( LNK_STRUCTURE, 0, izdid );
   mngData.AddLink( LNK_STRUCTURE, 0, blockid );

   // �������� �������� ��������
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 10'); // ��� ������������
   while not query1.eof do
   begin

       j := 1;

       // ������� �������� ������ � ������
       mngData.AddLink( LNK_STRUCTURE, izdid, query1.FieldByName('id').AsInteger );

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

   mngSpecTree.Refresh([]);
   mngGroupTree.Refresh([]);
   ShowSubItems;

   lMainInfo.Caption := '';
   ShowMessage('���������');
end;


procedure TfMain.sbShowObjectCatalogClick(Sender: TObject);
begin
    // ����������� �������� ��������������� ���������� ����������� �����������
    TfObjectCatalog.Create(self).Show;
end;




end.
