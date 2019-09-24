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
    /// имя конфигурации, которая в данный момент определена для таблицы grdObjects.
    /// часть механизма динамической постройки отображаемых полей в списке объектов
    /// в зависимости от выбранного раздела в структуре рабочего стола.
    /// сами конфигурации формируются при инициализации программы.

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
        // функция вызывается из окошка создания проекта, когда пользователь подтверждает операцию
        // технология callback применяется, чтобы не захламлять диалог функциональным кодом
        // и иметь возможность менять поведение, передавая разные callback методы

    function OpenProject( project_id: integer; pname, mark: string): TForm;
        // по указанному id открывает окно проекта и подгружает в него все данные

    procedure ClearProjectWndLink( form: TForm );
  end;

var
  fMain: TfMain;
    mngSpecTree             // менеджер формирования дерева Групп
   ,mngGroupTree            // менеджер формирования дерева Спецификаций
   ,mngSearchTree           // менеджер формирования дерева Поиска
            : TTreeManager;

    mngData                 // менеджер, предоставляющий интерфейс работы с базой
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

    // страницы с данными
    PAGE_OBJECTS = 0;
    PAGE_DOCUMENT = 1;

    // колонки таблицы групп (grdGroup)
    GRP_COL_NAME  = 0;      // отображаемое имя элемента
    GRP_COL_LUID  = 3;      // id пользователя, создавшего связь
    GRP_COL_CHILD = 4;      // id объекта
    GRP_COL_LID   = 5;      // id записи связи

    // колонки таблицы спецификаций
    SPC_COL_LID   = 3;      // id записи связи
    SPC_COL_CHILD = 4;      // id объекта

    // колонки таблицы поиска
    SRH_COL_LID   = 3;      // id записи связи
    SRH_COL_CHILD = 4;      // id объекта

    // колонки таблицы с объектами (grdObject)
    COL_OBJECT_FILE_BUTTONS = 5;


{$R *.dfm}


procedure TfMain.FormShow(Sender: TObject);
var
   error: string;
begin

    fWelcome := TfWelcome.Create(nil);
    fWelcome.Show;

    // инициализируем
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
        ShowMessage('Ошибка инициализации программы:' + sLineBreak + sLineBreak +
                     error + sLineBreak + sLineBreak +
                    'Запуск отменен.');
        halt;
    end;

    lC('uMain.FormCreate');

{$IFDEF test}
//    CORE.User.initUserByID(27);
{$ENDIF}

//    Core.Settings.RestoreForm(self);

    fWelcome.Progress(10);

    // формируем дерево групп
    mngGroupTree := TTreeManager.Create;
    mngGroupTree.init(grdGroup, VIEW_GROUP);
//    mngGroupTree.GetTreeLevel(0,0);
    mngGroupTree.Refresh([]);

    fWelcome.Progress(10);

    // формируем дерево спецификаций
    mngSpecTree := TTreeManager.Create;
    mngSpecTree.SetExtFields(['full_name'], ['ftString']);
    mngSpecTree.init(grdSpecific, VIEW_OBJECT);
//    mngSpecTree.GetTreeLevel(0,0);
    // метод подгружает дерево на несколько уровней стразу, что позволяет
    // корректно отобразить крестики, где есть вложенные ветки, поскольку
    // компонент не позволяет напрямую управлять ими, как, например, VirtualTree
    mngSpecTree.Refresh([]);

    fWelcome.Progress(10);

    // инициализируем модуль работающий с файлами и их атрибутами
    mngFile := TFileManager.Create;
    mngDatatable := TDatatableManager.Create;

    // создаем менеджер с интерефейсом методов оперированием данными в базе данных
    // добавление, удаление, изменение объектов и связей с автоматическим
    // гененрированием истории изменений
    mngData := TDataManager.Create;

    mngKompas.sTempPath( DIR_TEMP );

    fWelcome.Progress(10);

    // инициализируем таблицу объектов
    grdObject.DataSource := TDataSource.Create(self);
    grdObject.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdObject, [0,1,2] );
    mngDatatable.ConfigureForSorting( grdObject, [] );

    grdDocs.DataSource := TDataSource.Create(self);
    grdDocs.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdDocs, [0,1] );
    mngDatatable.ConfigureForSorting( grdDocs, [] );

    /// конфигурация полей поумолчанию
    if mngDatatable.CreateConfiguration( COL_CONFIG_DEF ) then
    begin
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'kind', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100;');
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'icon', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100');
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'has_docs', '', FIELD_KIND_IMAGE, 20, true, true, ilHas_docs, '0,1');
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'full_mark', 'Обозначение', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'name', 'Наименование', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_DEF, 'count', 'Кол-во', FIELD_KIND_TEXT, 50);
    end;

    /// конфигурация для показа списка проектов
    if mngDatatable.CreateConfiguration( COL_CONFIG_PROJECT ) then
    begin
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'kind', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100');
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'icon', '', FIELD_KIND_IMAGE, 20, true, true, ilTreeIcons, '0,1,2,3,4,5,6,7,8,9,10,11,12,100');
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'has_docs', '', FIELD_KIND_IMAGE, 20, true, true, ilHas_docs, '0,1');
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'full_mark', 'Обозначение', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'name', 'Наименование', FIELD_KIND_TEXT, 300);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'parent_kod', 'Тип', FIELD_KIND_TEXT, 50);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'kod', 'Продукция', FIELD_KIND_TEXT, 200);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'created', 'Создан', FIELD_KIND_TEXT, 50);
        mngDatatable.AddConfigField( COL_CONFIG_PROJECT, 'user_name', 'Автор', FIELD_KIND_TEXT, 80);
    end;

    fWelcome.Progress(10);

    // инициализируем папки
    if   not DirectoryExists( DIR_BASE_WORK )       // корневая рабочая
    then ForceDirectories( DIR_BASE_WORK );

    if DirectoryExists( DIR_TEMP ) then             // временные файлы
    TDirectory.Delete( DIR_TEMP, true );

    if   not DirectoryExists( DIR_TEMP )
    then ForceDirectories( DIR_TEMP );

    if   not DirectoryExists( DIR_PREVIEW )         // превьюшки документов
    then ForceDirectories( DIR_PREVIEW );

    if   not DirectoryExists( DIR_DOCUMENT )        // документы в работе
    then ForceDirectories( DIR_DOCUMENT );

    fWelcome.Progress(10);

    // отображаем текущую версию программы
    SetCaption;

    fMain.KeyPreview := true;

    // флаг для мгновенного обновления данных при изменении фильтрации столбца
    DBGridEhCenter.FilterEditCloseUpApplyFilter:=true;

    // прячем приветственное окно
    fWelcome.Free;

    lCE; // выход на предыдущий уровень вложенности логов

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

    fEditSection.Mode := 0;  // создание раздела
    fEditSection.ParentId := mngGroupTree.GetValue('mem_child');
    fEditSection.ItemsKind := 0;
    fEditSection.SectionName := 'Новый раздел';

    if fEditSection.ShowModal = mrOk then
    begin

        mngGroupTree.Expand;

        // создаем элемент в базе
        CreateNavigationObject(
            fEditSection.NewParentId,            // родитель
            0,                                   // раздел (будет создан новый)
            'icon, kind, name',          // набор заполняемых при создании полей
            [
                fEditSection.NewItemsKind,       // тип допиконки
                KIND_SECTION,                    // основной тип объекта
                fEditSection.NewSectionName      // наименование объекта
            ]
        );

        // обновляем дерево
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

    fEditSection.Mode := 1;  // редактирование раздела
    fEditSection.ParentId := mngGroupTree.GetValue('parent');
    fEditSection.ItemsKind := mngGroupTree.GetValue('icon');
    fEditSection.SectionName := mngGroupTree.GetValue('name');

    if fEditSection.ShowModal = mrOk then
    begin

        // меняется РОДИТЕЛЬ связки между объектами
        if   fEditSection.NewParentId <> mngGroupTree.GetValue('parent')
        then mngData.ChangeLinkParent( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), fEditSection.NewParentId);

        // меняется объект (имя объекта-раздела)
        if   fEditSection.SectionName <> fEditSection.NewSectionName
        then mngData.ChangeObject( mngGroupTree.GetValue('child'), ['name'], [fEditSection.NewSectionName] );

        // меняется тип отображаемых элементов
        if   fEditSection.ItemsKind <> fEditSection.NewItemsKind
        then mngData.ChangeObject( mngGroupTree.GetValue('child'), ['icon'], [fEditSection.NewItemsKind] );

        // перестраиваем дерево с сохранением текущего раскрытия веток
        mngGroupTree.Refresh([]);
    end;
end;

procedure TfMain.EditObject;
begin
    if not Assigned(fEditObject) then
       fEditObject := TfEditObject.Create(self);

    fEditObject.Mode := 1;  // редактирование раздела
    fEditObject.ParentId := mngGroupTree.GetValue('parent');
    fEditObject.ObjectID := mngGroupTree.GetValue('child');

    if fEditObject.ShowModal = mrOk then
    begin

        // меняется РОДИТЕЛЬ связки между объектами
        if   fEditObject.NewParentId <> mngGroupTree.GetValue('parent')
        then mngData.ChangeLinkParent( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), fEditObject.NewParentId);

        // меняется ПОТОМОК связки между объектами.
        if   fEditObject.NewObjectId <> mngGroupTree.GetValue('child')
        then mngData.ChangeLinkChild( LNK_NAVIGATION, mngGroupTree.GetValue('aChild'), fEditObject.NewObjectId );

        // перестраиваем дерево с сохранением текущего раскрытия веток
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

    fEditObject.Mode := 0;  // создание привязки объекта
    fEditObject.ParentId := mngGroupTree.GetValue('child');
    fEditObject.ObjectId := 0;

    if fEditObject.ShowModal = mrOk then
    begin
        if ( fEditObject.ObjectId = fEditObject.NewObjectId ) or
           ( fEditObject.NewObjectId = 0 )
        then exit;

        mngGroupTree.Expand;

        // создаем элемент в базе
        ChildId :=
            CreateNavigationObject(
                fEditObject.NewParentId,            // родитель
                fEditObject.NewObjectId,            // существубщий объект
                '',
                []
            );

        // обновляем дерево
        mngGroupTree.Refresh([]);

    end;

end;

procedure TfMain.sbCreateProjectClick(Sender: TObject);
/// нажатие на кнопку создания проекта. показываем форму. если еще не показана
/// пока она показана, перемещение по дереву спецификаций отдает ей данные
/// текущего элемента для автоматической подстановки в поле редактруемой проектом
/// спецификации
begin

    if not mngData.HasRole( ROLE_CREATE_PROJECT ) then
    begin
        ShowMessage('Отсутствует роль создания проекта');
        exit;
    end;

    if fAddProject.Visible then exit;

    fAddProject.Reset;

    fAddProject.callback := CreateProject;

    fAddProject.Show;

end;

function TfMain.CreateProject(name, mark: string; objectId, workgroupId: integer; comment, parent_prod_kod, prod_kod: string): boolean;
/// вызывается при нажатии на кнопку создать/редактировать формы создания проекта
/// проверяет на возможность создания и создает проект. запускает режим
/// редактирования объекта при успешном создании
var
    project_id: integer;
begin

    result := false;

    // пытаемся создать проект
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
            'Удалить объект из дерева?',
            'Удаление',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    // удаляем связку из базы
    if not mngData.DeleteLink( LNK_NAVIGATION, mngGroupTree.GetValue('mem_aChild'), DEL_MODE_FULL_USER ) then exit;

    // обновляем дерево
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
{ нажатие кнопки открытия папки с документом в списке объектов для раздела
  навигации "Документы в работе"
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
    // доступность кнопок редактирования/удаления разделов
    sbAddSection.Enabled := grdGroup.SelectedIndex <> -1;

    isUserObject := StrToIntDef(grdGroup.Columns[GRP_COL_LUID].DisplayText, 0) = Core.User.id;
    sbEditSection.Enabled := isUserObject;
    sbDelSection.Enabled := isUserObject;

    // показ списка подэлементов текущего выбранного в дереве элемента
    ShowSubItems;

    // показ списка файлов выделенного объекта
    RefreshFilePreview;

    // если открыто окно создания проекта, передаем ему данные текущего выбранного
    // элемента дерева спецификаций, чтобы подставить данные, если подойдут
//    if   assigned(fAddProject)
//    then fAddProject.SelectSpecification( grdSpecific.DataSource.DataSet );

end;

function TfMain.OpenProject(project_id: integer; pname, mark: string ): TForm;
/// метод подгружает данные проекта по его id и открывает форму работы с ним
var
    i : integer;
begin

    result := nil;

    // проверяем, не открыт ли уже такой проект
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

        /// пишем в массив новое окно проекта
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
/// исходя из текущего активного дерева, показываем в таблице список привязанных
/// элементов (всех подуровней)
var
    config : string;
begin

    // получаем набор вложенных объектов из по дереву рабочего стола
    if pnNavigation.ActivePage = pageGroups then
    begin
        grdObject.DataSource.DataSet :=
             mngData.GetGroupSubitems(
                 grdGroup.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                 grdGroup.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
                 'kind, icon, has_docs, mark, name, child, full_mark',
                 grdObject.DataSource.DataSet
             );

        // получаем список документов текущего элемента. если это раздел - у него может быть персональная выборка, это тоже учитывается
        grdDocs.DataSource.DataSet :=
            mngData.GetKDDocsList(
                grdGroup.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                grdGroup.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
                grdDocs.DataSource.DataSet
            );

        /// получаем настройки полей для таблицы вложенных элементов, исходя из выбранного в дереве навигации
        config := mngData.GetColConfigName( grdGroup.DataSource.DataSet.FieldByName('mem_child').AsInteger, COL_CONFIG_DEF );
        /// конфигурация не применена или отличается от последней примененной
        if config <> fConfig then
        begin
            /// обновляем конфигурацию столбцов и запоминаем как последнюю примененную
            mngDatatable.ApplyConfiguration( config, grdObject );
            fConfig := config;
        end;

    end;

    // получаем набор вложенных объектов из по дереву спецификаций
    if   pnNavigation.ActivePage = pageSpecif then
    begin
        grdObject.DataSource.DataSet :=
            mngData.GetSpecifSubitems(
                grdSpecific.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                grdSpecific.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
                'kind, icon, has_docs, mark, name, count, child, full_mark',
                grdObject.DataSource.DataSet
            );

        // получаем список документов текущего выбранного в списке объекта
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
    // допускается открытие неограниченного количества экземпляров справочника
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

    // загрузка превьюшки, если есть
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

   // забиваем объекты в справочник
   spec1  := mngData.AddObject('kind, icon, name, mark', [ KIND_COMPLEX, KIND_SPECIF, 'зав.7774', 'НПС5.01.02.100В' ], TBL_OBJECT);
   isp1_1 := mngData.AddObject('kind, icon, name, mark', [ KIND_COMPLEX, KIND_ISPOLN, 'зав.7774', 'НПС5.01.02.100В' ], TBL_OBJECT);
   isp1_2 := mngData.AddObject('kind, icon, name, mark, realization', [ KIND_COMPLEX, KIND_ISPOLN, 'зав.7774', 'НПС5.01.02.100В', '1' ], TBL_OBJECT);


   // спецификации и исполнения сразу подвязываем к дереву структуры
//   mngData.AddLink( LNK_STRUCTURE, sec_specif, spec1 );
//   mngData.AddLink( LNK_STRUCTURE, spec1, isp1_1 );
//   mngData.AddLink( LNK_STRUCTURE, spec1, isp1_2 );


   // накидываем сборочные единицы, сразу привязфвая к разделу "Сборочные единицы" дереву структуры
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.110В', 'Дозатор' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name, realization', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.110В', 'Дозатор', '1' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.120В', 'Трубопровод напорный' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.130В', 'Трубопровод подачи пенообразователя' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name, realization', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.130В', 'Трубопровод подачи пенообразователя', '1' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.140В', 'Устройство отборное' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.150В', 'Трубопровод' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.160В', 'Трубопровод' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.170В', 'Трубопровод' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.200В', 'Ёмкость' ], TBL_OBJECT) );
   mngData.AddLink( LNK_STRUCTURE, sec_assembly, mngData.AddObject('kind, icon, mark, name, realization', [ KIND_ASSEMBL, KIND_ISPOLN, 'НПС5.01.02.200В', 'Ёмкость', '1' ], TBL_OBJECT) );

   // накидываем детали
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '814-17.2.04.00.007', 'Штуцер' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '2013.136.00.007', 'Прокладка' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, '2013.136.01.012', 'Скоба' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, 'НПС5.01.02.101В', 'Патрубок' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name, realization', [ KIND_DETAIL, 'НПС5.01.02.101В', 'Патрубок', '1' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, 'НПС5.01.02.102В', 'Патрубок' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, 'НПС5.01.02.103В', 'Табличка' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, 'НПС5.02.02.101В', 'Отвод' ], TBL_OBJECT);
   mngData.AddObject('kind, mark, name', [ KIND_DETAIL, 'РЗ.81.44.000-23', 'Прокладка тип А ГОСТ 15180-86' ], TBL_OBJECT);

   // накидываем стандартные изделия
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Винт с шестигранной головкой ГОСТ Р ИСО 4017-М12х40-5.6' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Гайка АМ16-6Н.35.III.3.019 ГОСТ 9064-75' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Гайка шестигранная нормальная ГОСТ ISO 4032-М12-8-А3А' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Фланец 50-16-01-В-Ст09Г2СГОСТ 33259-2015' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Шпилька М165-6gx100 ГОСТ 22042-76' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Шпилька М16-6gх300.58.019ГОСТ 22042-76' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Заклепка 2,5х7.00ГОСТ 10299-80' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Шайба А.16.01.08кп.016 ГОСТ 11371-78' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Шпилька АМ16-6gx95.32.35.III.2.019 ГОСТ 9066-75' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_STANDART, 'Шпилька АМ16-6gх70.32.35.III.2.019 ГОСТ 9066-75 номенкл. №1083079' ], TBL_OBJECT);

   // прочие изделия
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Воздухоотводчик авт.прямой 1/2 номенкл. №755855' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Датчик расхода ДРС-25МИ,исполнение: с индикацией, 6,3 МПа (кабельный ввод КНВМ1М-20), КМЧ для ДРС-25М на Рр 2,5 МПа, согласно опросному листу №0618/18 от 28.07.2018 номенкл. №1160137' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Клапан обратный межфланцевый лепестковыйWB 26 Ду 50 Ру 16 кгс/см2номенкл. №1031654' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Клапан отсекающий VT.539.N.04 1/2" номенкл. №751589' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Кран шаровой муфтовый ЗАРД 025.016.10-03Р ХЛ1 DN 25 PN 16 кгс/см2 ТУ 3742-002-52838824-2006  номенкл. №:1040810' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Манометр КМ22Р (6 кПа)-М20-1,5 ТУ 4212-002-4719015564-2008номенкл. №1225261' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Манометр МП3-У 0...16 кгс/см2 ТУ 311-00225621.167-97' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Манометр МП3-УУ2-(0...1)кгс/см2-1,5 М20х1,5радиальный без фланца ТУ 25-02.180335-84 номенкл. №1220625' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Переход К 57х5-32х4 ГОСТ 17378-2001 номенкл. №1062104' ], TBL_OBJECT);
   mngData.AddObject('kind, name', [ KIND_OTHER, 'Фланец 2-032-40 ГОСТ 12821-80' ], TBL_OBJECT);

   // материалы
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, 'Лист Б-ПН-О-1,5x1250x2500 ГОСТ 19904-90/ОК360В-4-IV-Ст3 ГОСТ 16523-97' ], TBL_OBJECT);
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, 'Проволока 3-12Х18Н10Т ГОСТ 18143-72' ], TBL_OBJECT);
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, 'Сетка Р4-1,6 ГОСТ 3306-88' ], TBL_OBJECT);
//   mngData.AddObject('kind, name', [ KIND_MATERIAL, 'Мастика ГНС ГОСТ 14791-79' ], TBL_OBJECT);

   // генерим непрямые ссылки
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

   ShowMessage('Генерация завершена');
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
        // добавляем новый объект
        result := mngData.AddObject( fields, values, TBL_OBJECT );
        if result = 0 then
        begin
            ShowMessage( 'Не удалось добавить объект.' );
            exit;
        end;
    end;

    // создаем привязку к родителю
    LinkId := mngData.AddLink( LNK_NAVIGATION, parent, result );
    if LinkId = 0 then
    begin
        ShowMessage( 'Данная связка уже существует.' );
        exit;
    end;

    // создаем допссылки для новой связки
    if not mngData.CreateCrossLinks( LNK_NAVIGATION, linkId, true ) then
    begin
        ShowMessage( 'Не удалось создать набор допссылок.' + sLineBreak +
                     Core.DM.DBError );
        exit;
    end;

end;

procedure TfMain.grdDocsApplyFilter(Sender: TObject);
{ при изменении фильтрации, перебираем все столбцы и склеиваем общую строку
  фильтра для датасета }
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
    Caption := 'PDM Нефтемаш ' + '(' + GetFileVersion() + ') ' + '(' + CORE.User.name + ') ';
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

    // получаем размер превью файла. если нулевой - некорректно сформирован
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
            // тихая ошибка на некорректно сформированную превьюшку.
            // такое случается, например, у doc или xls файлов, если программы не настроены на сохранение файлов с превью
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

    // выбран раздел документы в работе
    if   ( grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_PROJECT_ALL ) or
         ( grdGroup.Columns[GRP_COL_NAME].DisplayText = SECTION_PROJECT_MY )
    then (sender as TDBGridCellButtonEh).DropdownMenu := popNavWorkObjects;

    // выбран раздел избранного
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


    /// в разных источниках разное именование поля с id перемещаемого объекта
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
        ShowMessage('Не удалось привязать элемент!');
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
{ нажатие кнопки открытия папки с документом в списке объектов для раздела
  навигации "Документы в работе"
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
{ нажатие кнопки открытия файла в списке объектов для раздела
  навигации "Документы в работе"  }
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
/// двойной щелчок на объекте в списке. производим действия, исходя из его типа
///    - папка - ничего
///    - проект - открываем режим проекта
///    - объект - открываем карточку
///    - файл - открываем для просмотра
var
    dataset : TDataset;
begin

    dataset := grdObject.DataSource.DataSet;

    // отсекаем некорректный датасет
    if not Assigned(dataset) or
       not dataset.Active or
       (dataset.RecordCount = 0) or
       not Assigned( dataset.FindField('kind')) or
       not Assigned( dataset.FindField('child'))
    then
        exit;

    // выбираем действие исходя из типа объекта
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
        ShowMessage('Не удалось привязать элемент!');
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
        ShowMessage('Не удалось привязать элемент!');
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
        ShowMessage('Отсутствует роль редактирования групп ролей');
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
        ShowMessage('Отсутствует роль смены пользователя');
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
/// обработчик выбора пользователя из списка.
/// пользователь выбирается из двойным кликом списка формы TfUserList
begin
    result := '';

    if user_id <> 0 then
    begin
        // подменяем текущего пользователя
        Core.User.initUserByID( user_id );

        lM('Выбран новый пользователь: ' + Core.User.name );

        // принудительное обновление данных о его правах
        mngData.RefreshRolesList( true );

        SetCaption;
    end;

end;

procedure TfMain.menuWorkgroupEditClick(Sender: TObject);
begin
    if not mngData.HasRole( ROLE_WORKGROUPS_CONFIGURE ) then
    begin
        ShowMessage('Отсутствует роль редактирования рабочих групп');
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
/// получение актуальных данных о ролях из базы
begin
    mngData.RefreshRolesList( true );  // принудительное обновление данных
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
                        // сначала чистим содержимое найденной папки
                        RemoveEmptyDir( path + searchRec.Name + '\' );
                        // после этого грохаем и ее
                        RemoveDir( path + searchRec.Name );
                    end;
                end;
            until FindNext(searchRec) <> 0;
            FindClose(searchRec);
        end;
    end;

begin
//    Core.Settings.SaveForm(self);

    // грохаем папку со всеми временными файлами
    // (принудительное удаление непустой папки )
    if DirectoryExists( DIR_TEMP ) then
    TDirectory.Delete( DIR_TEMP, true );

    // из рабочей папки удаляем все пустые директории, которые могли образоваться
    // после сохранения редактируемых пользователем документов как новых версий
    // или отмены взятия на редактирование. при этом файл физически удаляется, а
    // директория версии остается пустой
    RemoveEmptyDir( DIR_DOCUMENT );
end;

procedure TfMain.ClearProjectWndLink(form: TForm);
/// метод вызывается при закрытии формы проекта, чтобы убрать ссылку на него
/// из массива открытых, что позволит создать новую фому при необходлимости
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

   // структура изделий
   dmEQ('DELETE FROM '+LNK_STRUCTURE);
   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_cross');
   dmEQ('DELETE FROM '+LNK_STRUCTURE+'_history');

   // сруктура навигации
   dmEQ('DELETE FROM '+LNK_NAVIGATION);
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_cross');
   dmEQ('DELETE FROM '+LNK_NAVIGATION+'_history');

   // таблицы работы с документами
   dmEQ('DELETE FROM '+TBL_DOCUMENT_EXTRA);

   // проекты
   dmEQ('DELETE FROM '+TBL_PROJECT);
   dmEQ('DELETE FROM '+LNK_PROJECT_STRUCTURE);
   dmEQ('DELETE FROM '+LNK_PROJECT_STRUCTURE+'_cross');
   dmEQ('DELETE FROM '+TBL_PROJECT_EXTRA);
   dmEQ('DELETE FROM '+LNK_PROJECT_EXTRA);
   dmEQ('DELETE FROM '+TBL_PROJECT_OBJECT_EXTRA);
   dmEQ('DELETE FROM '+LNK_PROJECT_OBJECT_EXTRA);
   dmEQ('DELETE FROM '+LNK_PROJECT_EDITOR);
   dmEQ('DELETE FROM '+LNK_PROJECT_CHECKER);

   // хранилище документов
   dmEQ('DELETE FROM '+TBL_FILE);

   dmEQ('DELETE FROM '+TBL_CUSTOM_SQL);
end;

procedure TfMain.CreateWorkTree;
var
   tmpID
  ,tmpID2
           : integer;
   q0, q1: TDataset; // данные соответствующего уровня дерева классификатора продукции

   function AddSection(id, icon: integer; section: string): integer;
   begin
       result := mngData.AddObject('kind, name, icon', ['1', section, icon], TBL_OBJECT);
       mngData.AddLink( LNK_NAVIGATION, id, result, 0 );
   end;

begin

   // создаем и сразу привязываем корневые типизированные разделы дерева навигации
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

   /// строим структуру разделения проектов по классификатору
   /// получаем данные нулевого уровня
   q0 := mngData.GetTypeProdLevel(0);
   if assigned(q0) and (q0.RecordCount > 0) then
   while not q0.eof do
   begin
       /// добавляем элемент нулевого уровня
       tmpID2 := mngData.AddSection( tmpID, q0.FieldByName('name'{'kod'}).AsString, TAG_SELECT_OBJECTS, VIEW_PROJECT, 'parent_kod = '''''+q0.FieldByName('kod').AsString+''''' AND status <> '+IntToStr(PROJECT_DONE), COL_CONFIG_PROJECT, 0 );

       /// получаем все его подуровни и добавляем в дерево
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

   // добавляем корневые разделы
   izdid   := mngData.AddObject('kind, name', [ KIND_SECTION, 'Изделия' ]);
   blockid := mngData.AddObject('kind, name', [ KIND_SECTION, 'Сборки' ]);

   // добавляем пачки различных объектов
   addObjects(4, 'Деталь');
   addObjects(7, 'Сборка');
   addObjects(10, 'Спецификация');


   // добавляем пачку исполнений
   query1 := Core.DM.OpenQueryEx('SELECT id, name FROM '+TBL_OBJECT+' WHERE kind = 10'); // все спецификации
   while not query1.eof do
   begin

       j := 1;

       for I := 1 to 3 do
       begin
           ispolid := mngData.AddObject('kind, name', [ 11, 'Исполение' + query1.fieldByName('name').AsString + '-' + IntToStr(i) ]);

           // сразу привязываем к спецификации в структуре и навигации
           mngData.AddLink( LNK_STRUCTURE, query1.fieldByName('id').AsInteger, ispolid );

           lMainInfo.Caption := 'Исполнение ' + IntToStr(j) + ', ' + IntToStr(i);
           Application.ProcessMessages;
       end;

       query1.Next;
   end;


   // ссылки на корневые разделы
   mngData.AddLink( LNK_STRUCTURE, 0, izdid );
   mngData.AddLink( LNK_STRUCTURE, 0, blockid );

   // гененрим корневые элементы
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 10'); // все спецификации
   while not query1.eof do
   begin

       j := 1;

       // создаем привязку детали к сборке
       mngData.AddLink( LNK_STRUCTURE, izdid, query1.FieldByName('id').AsInteger );

       inc(j);

       lMainInfo.Caption := Format('Комплексы: %d',[j]);
       Application.ProcessMessages;

       query1.Next;
   end;


   // генерим сборки
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 7'); // все сборки
   query2 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 4'); // все детали

   i := 1;

   if Assigned(query1) and Assigned(query2) then

   // для каждой сборки
   while not query1.eof do
   begin

       j := 1;

       // берем каждую деталь
       while not query2.eof do
       begin

           // создаем привязку детали к сборке
           mngData.AddLink( LNK_STRUCTURE, query1.FieldByName('id').AsInteger, query2.FieldByName('id').AsInteger );

           query2.next;
           inc(j);

           lMainInfo.Caption := Format('Сборки: %d, %d',[i, j]);
           Application.ProcessMessages;

       end;

       // за одно, привязываем сборку к разделу сборок в дереве изделий
       mngData.AddLink( LNK_STRUCTURE, blockid, query1.FieldByName('id').AsInteger );

       query2.First;
       query1.Next;
       inc(i);
   end;

   // генерим исполнения
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 11'); // все исполнения
   query2 := Core.DM.OpenQueryEx('SELECT id FROM '+TBL_OBJECT+' WHERE kind = 7'); // все сборки

   if Assigned(query1) and Assigned(query2) then

   i := 1;

   // для каждого комплекса
   while not query1.eof do
   begin

       j := 1;

       // берем каждую сборку
       while not query2.eof do
       begin

           // создаем привязку сборки к комплексу
           mngData.AddLink( LNK_STRUCTURE, query1.FieldByName('id').AsInteger, query2.FieldByName('id').AsInteger );

           query2.next;
           inc(j);

           lMainInfo.Caption := Format('Исполнения: %d, %d',[i, j]);
           Application.ProcessMessages;
       end;

       query2.First;
       query1.Next;
       inc(i);
   end;

   // генерим непрямые ссылки
   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+LNK_STRUCTURE);
   i := 1;
   while not query1.eof do
   begin

       mngData.CreateCrossLinks( LNK_STRUCTURE, query1.FieldByName('id').AsInteger );

       lMainInfo.Caption := Format('Подсвязи спец.: %d / %d',[i, query1.RecordCount]);
       Application.ProcessMessages;

       query1.Next;
       inc(i);
   end;

   query1 := Core.DM.OpenQueryEx('SELECT id FROM '+LNK_NAVIGATION);
   i := 1;
   while not query1.eof do
   begin

       mngData.CreateCrossLinks( LNK_NAVIGATION, query1.FieldByName('id').AsInteger );

       lMainInfo.Caption := Format('Подсвязи группы: %d / %d',[i, query1.RecordCount]);
       Application.ProcessMessages;

       query1.Next;
       inc(i);
   end;

   mngSpecTree.Refresh([]);
   mngGroupTree.Refresh([]);
   ShowSubItems;

   lMainInfo.Caption := '';
   ShowMessage('Завершено');
end;


procedure TfMain.sbShowObjectCatalogClick(Sender: TObject);
begin
    // допускается открытие неограниченного количества экземпляров справочника
    TfObjectCatalog.Create(self).Show;
end;




end.
