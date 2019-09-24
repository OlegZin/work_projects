unit uProject;

interface

uses
  uObjectCatalog, uObjectCard, uUserList, uLoadSpec, uDrawSpecifManager, uSpecTreeFree,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Menus, DB, ShellAPI, System.Actions, Vcl.ActnList,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, System.ImageList, Vcl.ImgList, StrUtils, Math,
  Vcl.Grids, Vcl.OleCtnrs, MemTableDataEh, MemTableEh, VirtualTrees, uKompasManager, uTypes;

type
  TfProject = class(TForm)
    pcProject: TPageControl;
    tabStructure: TTabSheet;
    tabTasks: TTabSheet;
    tabMessages: TTabSheet;
    Panel1: TPanel;
    tabEvents: TTabSheet;
    gridProjectTree: TDBGridEh;
    Splitter1: TSplitter;
    grdProjectObject: TDBGridEh;
    ScrollBox1: TScrollBox;
    Panel11: TPanel;
    Label9: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lRedyPercent: TLabel;
    lStatus: TLabel;
    bAddTask: TButton;
    bDoneProject: TButton;
    bDeleteProject: TButton;
    Panel15: TPanel;
    bCreateMessage: TButton;
    Edit1: TEdit;
    SpeedButton4: TSpeedButton;
    Panel16: TPanel;
    Edit2: TEdit;
    SpeedButton6: TSpeedButton;
    CheckBox1: TCheckBox;
    Panel23: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel6: TPanel;
    SpeedButton1: TSpeedButton;
    WebBrowser1: TWebBrowser;
    tabStatus: TTabSheet;
    Panel7: TPanel;
    bCreateTask: TButton;
    Panel8: TPanel;
    SpeedButton2: TSpeedButton;
    bCreateEvent: TButton;
    Edit3: TEdit;
    browserEvents: TWebBrowser;
    browserTasks: TWebBrowser;
    sbShowObjectCatalog: TSpeedButton;
    bWorkgroupSetup: TButton;
    sbAddObject: TSpeedButton;
    PageControl1: TPageControl;
    pageList: TTabSheet;
    TabSheet2: TTabSheet;
    webSpecification: TWebBrowser;
    Splitter2: TSplitter;
    grdDocs: TDBGridEh;
    bCreateDocPreview: TButton;
    Splitter3: TSplitter;
    Panel9: TPanel;
    iProjectFilePreview: TImage;
    Splitter4: TSplitter;
    mProjectFileComment: TMemo;
    popObject1: TPopupMenu;
    N10: TMenuItem;
    menuAddDocument: TMenuItem;
    popDocument: TPopupMenu;
    menuViewFile: TMenuItem;
    menuTakeFileToWork: TMenuItem;
    menuDeleteFile: TMenuItem;
    popWorkDocument: TPopupMenu;
    MenuItem2: TMenuItem;
    menuEditFile: TMenuItem;
    N9: TMenuItem;
    menuSaveToPDM: TMenuItem;
    menuSaveAsVersion: TMenuItem;
    menuCancelVersion: TMenuItem;
    menuMakeFileMain: TMenuItem;
    N2: TMenuItem;
    menuChangeCount: TMenuItem;
    ActionList1: TActionList;
    actEditCount: TAction;
    sbLoadSpec: TSpeedButton;
    bSendMessage: TButton;
    bFreezeProject: TButton;
    bUnFreezeProject: TButton;
    popStructure: TPopupMenu;
    N1: TMenuItem;
    imgObjectState: TImageList;
    sbObjectToWork: TSpeedButton;
    sbObjectToCheck: TSpeedButton;
    sbObjectToReady: TSpeedButton;
    Panel2: TPanel;
    pToolPanel: TPanel;
    bRefresh: TImage;
    sbObjectToView: TSpeedButton;
    sbObjectCheckingBack: TSpeedButton;
    sbObjectReadyBack: TSpeedButton;
    timerCheckRole: TTimer;
    actToWork: TAction;
    actFromWork: TAction;
    actToCheck: TAction;
    actFromCheck: TAction;
    actToReady: TAction;
    actFromReady: TAction;
    cbUserGroups: TComboBox;
    listUsers: TListBox;
    sbShowUsers: TSpeedButton;
    eUserFilter: TEdit;
    listEditor: TImageList;
    listChecker: TImageList;
    menuDelEditor: TMenuItem;
    menuDelChecker: TMenuItem;
    DataSource1: TDataSource;
    MemTableEh1: TMemTableEh;
    MemTableEh1col2: TStringField;
    MemTableEh1col1: TStringField;
    MemTableEh1name: TStringField;
    MemTableEh1number: TStringField;
    StringGrid: TStringGrid;
    menuCreateIspol: TMenuItem;
    menuCopyIspol: TMenuItem;
    N5: TMenuItem;
    SpeedButton3: TSpeedButton;
    N3: TMenuItem;
    N4: TMenuItem;
    menuReadySubitems: TMenuItem;
    menuReadyAllSubitems: TMenuItem;
    Label3: TLabel;
    lWorkgroupName: TLabel;
    vsgProjectTree: TVirtualStringTree;
    cbMyObjects: TCheckBox;
    cbIEditor: TCheckBox;
    cbIChecker: TCheckBox;
    procedure pcProjectChange(Sender: TObject);
    procedure browserTasksBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure sbShowObjectCatalogClick(Sender: TObject);
    procedure sbAddObjectClick(Sender: TObject);
    procedure gridProjectTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure gridProjectTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure gridProjectTreeCellClick(Column: TColumnEh);
    procedure N10Click(Sender: TObject);
    procedure ObjectPageCardCallback;
    procedure menuViewFileClick(Sender: TObject);
    procedure menuTakeFileToWorkClick(Sender: TObject);
    procedure menuDeleteFileClick(Sender: TObject);
    procedure menuEditFileClick(Sender: TObject);
    procedure menuSaveToPDMClick(Sender: TObject);
    procedure menuSaveAsVersionClick(Sender: TObject);
    procedure menuCancelVersionClick(Sender: TObject);
    procedure grdDocsDblClick(Sender: TObject);
    procedure menuAddDocumentClick(Sender: TObject);
    procedure AddDocumentDialog;
    function AddDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
    procedure grdDocsSelectionChanged(Sender: TObject);
    procedure grdProjectObjectSelectionChanged(Sender: TObject);
    procedure gridProjectTreeSelectionChanged(Sender: TObject);
    procedure grdProjectObjectCellClick(Column: TColumnEh);
    procedure SetupPopup;
    procedure grdDocsCellMouseClick(Grid: TCustomGridEh; Cell: TGridCoord;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
      var Processed: Boolean);
    procedure grdProjectObjectApplyFilter(Sender: TObject);
    procedure grdProjectObjectDblClick(Sender: TObject);
    procedure grdProjectObjectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actEditCountExecute(Sender: TObject);
    procedure grdProjectObjectColumns5UpdateData(Sender: TObject;
      var Text: string; var Value: Variant; var UseText, Handled: Boolean);
    procedure sbLoadSpecClick(Sender: TObject);
    procedure bDeleteProjectClick(Sender: TObject);
    procedure bFreezeProjectClick(Sender: TObject);
    procedure bUnFreezeProjectClick(Sender: TObject);
    procedure bDoneProjectClick(Sender: TObject);
    procedure popObject1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure sbObjectToReadyClick(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure menuMakeFileMainClick(Sender: TObject);
    procedure timerCheckRoleTimer(Sender: TObject);
    procedure actToWorkExecute(Sender: TObject);
    procedure actFromWorkExecute(Sender: TObject);
    procedure actToCheckExecute(Sender: TObject);
    procedure actFromCheckExecute(Sender: TObject);
    procedure actToReadyExecute(Sender: TObject);
    procedure actFromReadyExecute(Sender: TObject);
    procedure sbShowUsersClick(Sender: TObject);
    procedure popStructurePopup(Sender: TObject);
    procedure DeleteEditor(Sender: TObject);
    procedure DeleteChecker(Sender: TObject);
    procedure menuCreateIspolClick(Sender: TObject);
    procedure menuCopyIspolClick(Sender: TObject);
    procedure gridProjectTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menuReadySubitemsClick(Sender: TObject);
    procedure menuReadyAllSubitemsClick(Sender: TObject);
    procedure grdProjectObjectGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure cbMyObjectsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gridProjectTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    wndObjectCatalog : TfObjectCatalog;  // окно справочника объектов
    wndUserList : TfUserList;            // окно справочника пользователей
    wndObjectCard : TfObjectCard;        // карточка объекта
    wndLoadSpec : TFLoadSpec;
    wndSpecTreeFree : TfSpecTreeFree;

    mngDrawSpecif : TDrawSpecifManager;

    fDropedFile : string;
    /// содержит имя файла, который перемещен на форму из проводника

//    fOldWindowProc: TWndMethod;
    fRoots: TIntArray;
    /// текущий набор корневых элементов, использующихся для перестройки дерева
    /// методом mngProjectTree.Refresh
    fRootsInclude: boolean;
    /// указывает, включать ли в дерево проекта указанные в массиве fRoots
    /// объекты. при построении от корня проекта это не требуется, а при выборке
    /// только привязанных к пользователю объектов - необходимо

    procedure UpdatePanel;

    procedure SetObjectStatus( status: integer );
    // обновляем элементы управления исходя из статуса проекта

    function SaveWorkDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
    procedure ReadySubitems( full: boolean);

    procedure SetLocalStatus(base_id, status, mode: integer);

    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure ImportFileToProject;
    /// привязка объекта в структуру из файла, если возможно
    procedure ImportFileToObject;
    /// привязка объекта в структуру из файла, если возможно

  public
    { Public declarations }
    ProjectID       // проект
   ,WorkgroupID     // привязанная к проекту рабочая группа
   ,ProjectStatus
            : integer;
    ProjectName
   ,ProjectMark
            : string;

    is_ctrl   // флаг установлен, когда нажат Ctrl
   ,is_alt    // флаг установлен, когда нажат Alt
            : boolean;

    procedure Init;
    procedure ObjectCreateCallback;
    procedure ShowSubitems;
    procedure UpdateFilePreview;
    procedure UpdateDocList;
    function SaveDocVersionCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
    procedure SpecLoadCallback;
    procedure CheckRole;
  end;

var
  fProject: TfProject;

implementation

{$R *.dfm}

uses
    uDocCreater, uTemplatesHTML, uPhenixCORE, uConstants, uSpecifTreeManager,
    uMain, uCommonOperations, uDataManager, uAddDoc, uUserListManager, uFileCatcher;

const
    // режимы для метода SetLocalStatus
    // установки статусов объктов в локальном датасете
    MODE_LOCAL_SOLO   = 0;  // только указанный объект
    MODE_LOCAL_CHILDS = 1;  // указанный и непосредственные потомки
    MODE_LOCAL_ALL    = 2;  // указанный и все потомки

var
    mngProjectTree : TTreeManager;
    mngUserList : TUserListManager;

procedure TfProject.AddDocumentDialog;
var
   dataset: TDataSet;
begin

    dataset := grdProjectObject.DataSource.DataSet;

    if   not DataSet.Active or ( DataSet.RecordCount = 0 ) then
    begin
        ShowMessage('Не выбран объект, привязка невозможна');
        exit;
    end;

    if Dataset.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не переведен в статус "В работе"');
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
    fAddDoc.mode        := SAVE_MODE_NEW_DOCUMENT; // добавление первой версии
    fAddDoc.callback    := AddDocCallback;
                           // замысел в том, что окно добавления файла не должно быть
                           // блокирующим (модальным) и не должно содержать функционала
                           // добавления документа, поскольку он может вызываться
                           // отдельно от окна или быть разным в различных ситуациях
                           // например, добавление первой версии нового документа, или
                           // добавление/сохранение новой редакции документа находящегося в работе
                           // все это решается методом callback-функции.

    fAddDoc.Show;

end;
procedure TfProject.actEditCountExecute(Sender: TObject);
// редактирование количества
var
    ds: TDataset;
begin

    ds := grdProjectObject.DataSource.DataSet;
    // работаем с фокусированной наполненной таблицей
    if not Assigned(ds) or not ds.Active or (ds.RecNo = 0) or not grdProjectObject.Focused then exit;

    //
end;

procedure TfProject.actFromCheckExecute(Sender: TObject);
begin
    SetObjectStatus( PROJECT_OBJECT_INWORK );
end;

procedure TfProject.actFromReadyExecute(Sender: TObject);
begin
    SetObjectStatus( PROJECT_OBJECT_CHECKING );
end;

procedure TfProject.actFromWorkExecute(Sender: TObject);
begin
    SetObjectStatus( PROJECT_OBJECT_VIEW );
end;

procedure TfProject.actToCheckExecute(Sender: TObject);
begin
    SetObjectStatus( PROJECT_OBJECT_CHECKING );
end;

procedure TfProject.actToReadyExecute(Sender: TObject);
begin
    SetObjectStatus( PROJECT_OBJECT_DONE );
end;

procedure TfProject.actToWorkExecute(Sender: TObject);
begin
    SetObjectStatus( PROJECT_OBJECT_INWORK );
end;

function TfProject.AddDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
begin

    result := false;

    if   mngData.CreateDocumentVersion( object_id, version_id, doc_type, Name + ext, FileName, Comment ) = 0
    then ShowMessage( Core.DM.DBError )
    else
        begin
            ShowSubitems;
            UpdateDocList;
            UpdateFilePreview;
            result := true;
        end;


end;

procedure TfProject.browserTasksBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
///    перехватываем переход по ссылке, если это не переход на сформированную
///    программой страницу. значит это нажатие на кнопку(ссылку) и в тексте
///    URL содержится запрошенное действие и id элемента
begin

    if not FileExists(URL) then
    begin
        Cancel := true;
        ShowMessage(URL);
    end;

end;

procedure TfProject.bUnFreezeProjectClick(Sender: TObject);
begin

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Вы действительно хотите вернуть проект в работу? '+ sLineBreak +
            'Проект будет разаморожен и редактирование будет разрешено.',
            'Возврат проекта в работу',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if not mngData.UnFreezProject( ProjectID ) then
    begin
        ShowMessage('Ошибка возврата проекта в работу');
        exit;
    end;

end;

procedure TfProject.cbMyObjectsClick(Sender: TObject);
/// переключение режима построения дерева: полное, только назначенные объекты
begin
    if cbMyObjects.Checked then
    begin
        /// отоброжаем список "своих" объектов
        fRoots :=
            mngData.GetRootElems(
                projectID,
                /// показываем объекты где пользователь редактор, если установлен флаг
                ifthen( cbIEditor.Checked, ROOT_MY_WORK_OBJECTS, 0 ) +
                /// показываем объекты где пользователь контролер, если установлен флаг
                ifthen( cbIChecker.Checked, ROOT_MY_CHECK_OBJECTS, 0 )
            );
        fRootsInclude := true;
    end
    else
    begin
        /// будем строить от корня проекта
        fRoots := [ProjectID];
        fRootsInclude := false;
    end;

    mngProjectTree.Refresh( fRoots, fRootsInclude );
end;

procedure TfProject.CheckRole;
var
    state: boolean;
    i: integer;
begin
    case ProjectStatus of
        PROJECT_INWORK :
        begin
            lStatus.Caption := 'В работе';
            state := true;
        end;
        PROJECT_ZREEZE :
        begin
            lStatus.Caption := 'Заморожен';
            state := false;
        end;
        PROJECT_DONE :
        begin
            lStatus.Caption := 'Завершен';
            state := true;
        end;
    end;

    pToolPanel.Enabled := state;

    // чтобы не вешать роль на каждую возможную кнопочку и менюшку
    // блочим их скопом, а потом обработаем кнопки с ролями
    for I := 0 to self.ComponentCount - 1 do
    begin
        // блочим/разблочим все кнопки
        if   self.Components[i] is TButton
        then (self.Components[i] as TButton).Enabled := state;

        // и пункты меню
        if   self.Components[i] is TMenuItem
        then (self.Components[i] as TMenuItem).Enabled := state;
    end;

    // обработка зароленных элементов управоения

    if ProjectStatus <> PROJECT_ZREEZE then
    begin

        // кнопки управления статусом проекта
        bFreezeProject.Enabled :=
            (ProjectStatus <> PROJECT_DONE) and
            mngData.HasRole( ROLE_FREEZE_PROJECT, WorkgroupID );

        bDoneProject.Enabled :=
            (ProjectStatus <> PROJECT_DONE) and
            mngData.HasRole( ROLE_DONE_PROJECT, WorkgroupID );

        bDeleteProject.Enabled := mngData.HasRole( ROLE_DELETE_PROJECT, WorkgroupID );

        bWorkgroupSetup.Enabled := mngData.HasRole( ROLE_WORKGROUPS_CONFIGURE, WorkgroupID );

        sbAddObject.Enabled := mngData.HasRole( ROLE_ADD_OBJECT, WorkgroupID );
        sbLoadSpec.Enabled := mngData.HasRole( ROLE_LOAD_SPECIFICATION, WorkgroupID );
    end;

    bUnFreezeProject.Visible := ProjectStatus = PROJECT_ZREEZE;
    bUnFreezeProject.Enabled := mngData.HasRole( ROLE_UNFREEZE_PROJECT, WorkgroupID );

    // обновляем доступность кнопок изменения статуса объекта
    UpdatePanel;

    self.Caption := 'Проект: ' + ProjectMark + ' ' + ProjectName + ' [' + lStatus.Caption + ']';

end;

procedure TfProject.bDoneProjectClick(Sender: TObject);
begin

    // проверка на завершение работы над всеми объектами
    if not mngData.ObjectIsReady( ProjectID ) then
    begin
        ShowMessage(lW('Содержит неразработанные позиции, или позиции в разработке или проверке. Операция не допустима'));
        exit;
    end;

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Вы действительно хотите завершить проект? '+ sLineBreak +
            'Данные проекта будут добавлены в рабочую КД и редактирование будет не доступно.',
            'Завершение проекта',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if not mngData.DoneProject( ProjectID ) then
    begin
        ShowMessage(lW('Ошибка завершения проекта'));
        exit;
    end else

    if mngData.SetProjectState( ProjectID, PROJECT_DONE ) then
    begin
        ProjectStatus := PROJECT_DONE;

        mngProjectTree.Refresh( [ProjectID] ); // обновляем состояние дерева

{$IFDEF VT}
        // вместо полного перестроения, чтобы избежать ненужных лагов, обновляем статус
        // всех записей в локальном датасете, полагаясь, что в базе все прошло успешно
        SetLocalStatus( ProjectID, PROJECT_OBJECT_READONLY, MODE_LOCAL_ALL );
        // не работает. дерево не желает обновляться при изменениях в локальном датасете
{$ENDIF}

        CheckRole;    // обновляем состояние кнопок управления проектом
        UpdatePanel;  // обновляем состояние кнопок изменения статуса объекта
        ShowSubItems; // обновляем список детей, чтобы показать изменение статуса объектов

        ShowMessage(lM('Проект успешно завершен'));
    end;

end;

procedure TfProject.bFreezeProjectClick(Sender: TObject);
begin

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Вы действительно хотите заморозить проект? '+ sLineBreak +
            'Проект будет заморожен в текущем состоянии и редактирование будет не доступно.',
            'Заморозка проекта',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if not mngData.FreezProject( ProjectID ) then
    begin
        ShowMessage('Ошибка заморозки проекта');
        exit;
    end;

end;

procedure TfProject.bRefreshClick(Sender: TObject);
begin
    mngProjectTree.Refresh( [ProjectID] );
end;

procedure TfProject.bDeleteProjectClick(Sender: TObject);
/// удаление текущего проекта со всей историей изменений
begin

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Вы действительно хотите удалить проект? ' + sLineBreak +
            'Все сделанные в нем изменения будут потеряны безвозвратно.',
            'Удаление проекта',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if not mngData.DeleteProject( ProjectID ) then
    begin
        ShowMessage('Ошибка удаления проекта');
        exit;
    end;

    /// обновляем список проектов на главной форме
    fMain.ShowSubItems;

    /// закрываем окно проекта, поскольку его больше не существует
    close;
end;

procedure TfProject.ShowSubitems;
var
   id : integer;
begin

    if not gridProjectTree.DataSource.DataSet.Active or
       (gridProjectTree.DataSource.DataSet.RecordCount = 0)
    then
        exit;

    /// запоминаем текущий элемент списк, если есть записи, чтобы вернуться на него после обновления
    id := 0;
    if   grdProjectObject.DataSource.DataSet.Active and (grdProjectObject.DataSource.DataSet.RecordCount > 0)
    then id := grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger;

    // получаем список вложенныъ объектов
    grdProjectObject.DataSource.DataSet :=
         mngData.GetSpecifSubitemsEx(
             gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger,
             gridProjectTree.DataSource.DataSet.FieldByName('mem_kind').AsInteger,
             ProjectID,
//             'kind, icon, has_docs, mark, markTU, name, child, status, mass, comment, realization, count, lid',
// lid убранно из запроса, поскольку вызывает двоение записей, если объект привзан еще где-то в дереве проекта,
// выдавая id связок по всей струкутуре, а не только в рамках текущего выбранного родителя
// такой же эффект дают поля c уникальными значениями типа parent, count
// upd: эффект двоения использован для показа всех вхождений копий объекта в структуру (был баг, стал фича)
             'kind, icon, has_docs, mark, markTU, name, child, status, mass, comment, realization, count, full_mark, parent_name, lid, dbo.GetIspol(lid) as ispol',
             VIEW_PROJECT_STRUCTURE,
             LNK_PROJECT_STRUCTURE,
             grdProjectObject.DataSource.DataSet
         );

    /// пытаемся вернуться на элемент выделенный до обновления
    grdProjectObject.DataSource.DataSet.Locate('child', id, []);

    UpdateDocList;

    UpdateFilePreview;
end;

procedure TfProject.UpdateDocList;
begin
    if not grdProjectObject.DataSource.DataSet.Active or
       (grdProjectObject.DataSource.DataSet.RecordCount = 0)
    then
        exit;

    // получаем список документов текущего элемента. если это раздел - у него может быть персональная выборка, это тоже учитывается
    grdDocs.DataSource.DataSet :=
        mngData.GetProjectDocsList(
            grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger,
            grdProjectObject.DataSource.DataSet.FieldByName('kind').AsInteger,
            grdDocs.DataSource.DataSet
        );
end;

procedure TfProject.UpdateFilePreview;
var
    image: TImage;
    filename : string;
begin
    // очищаем предпросмотр файла
    mProjectFileComment.Lines.Text := '';
    iProjectFilePreview.Picture := nil;

    // игнорируем пустой список файлов
    if not grdDocs.DataSource.Dataset.Active or
       (grdDocs.DataSource.Dataset.RecordCount = 0)
    then
        exit;

    // получаем комментарий к файлу
    mProjectFileComment.Lines.Text := grdDocs.DataSource.DataSet.FieldByName('doc_comment').AsString;

    // загрузка/создание превьюшки
    filename :=
        DIR_PREVIEW +
        '(' + grdDocs.DataSource.Dataset.FieldByName('full_version').AsString + ')' +
        ChangeFileExt( grdDocs.DataSource.Dataset.FieldByName('filename').AsString, '.jpg');

    /// есть ли привьюшка для этого файла
    if   FileExists( filename )
    then
        // подгружаем и показываем
        ShowPreview( filename, iProjectFilePreview )
    else
    begin
//        iProjectFilePreview.Picture := nil;
        /// сформируем на лету
        if   mngData.GetFileFromStorage( DIR_TEMP, grdDocs.DataSource.Dataset.FieldByName('filename').AsString, grdDocs.DataSource.Dataset.FieldByName('GUID').AsString )
        then
        begin
             iProjectFilePreview.Picture.Bitmap.Handle := mngFile.GetThumbnailImage( DIR_TEMP + grdDocs.DataSource.Dataset.FieldByName('filename').AsString, IMAGE_PREVWIEW_SIZE, IMAGE_PREVWIEW_SIZE);
             mngFile.CreatePreviewFile( iProjectFilePreview.Picture.Graphic, ExtractFilename(filename) );
        end;
    end;

end;

procedure TfProject.UpdatePanel;
var
    dataset: TDataset;

    procedure SS(button: TSpeedButton; vis: boolean = true; enab: boolean = true);
    begin
        button.visible := vis;
//        button.Enabled := enab;
        TAction(button.Action).Enabled := enab;
    end;
begin

    dataset := nil;

    if gridProjectTree.Focused
    then dataset := gridProjectTree.DataSource.DataSet;

    if grdProjectObject.Focused
    then dataset := grdProjectObject.DataSource.DataSet;

    if   not Assigned(dataset) or not DataSet.Active or ( DataSet.RecordCount = 0 )
    then
    begin
        SS(sbObjectToWork, true, false);
        SS(sbObjectToView, false);

        SS(sbObjectToCheck, true, false);
        SS(sbObjectCheckingBack, false);

        SS(sbObjectToReady, true, false);
        SS(sbObjectReadyBack, false);

        exit;
    end;

    sbObjectToView.Visible := false;

    case DataSet.FieldByName('status').AsInteger of
        STATE_PROJECT_DISABLED:
        begin
            SS(sbObjectToWork, true, false);
            SS(sbObjectToView, false);

            SS(sbObjectToCheck, true, false);
            SS(sbObjectCheckingBack, false);

            SS(sbObjectToReady, true, false);
            SS(sbObjectReadyBack, false);
        end;
        STATE_PROJECT_READONLY:
        begin
            SS(sbObjectToWork, true, mngData.HasRole( ROLE_OBJECT_TO_WORK_PERSONALY, WorkgroupID ) or mngData.HasRole( ROLE_OBJECT_TO_WORK_ASSIGMENT, WorkgroupID ));
            SS(sbObjectToView, false);

            SS(sbObjectToCheck, true, false);
            SS(sbObjectCheckingBack, false);

            SS(sbObjectToReady, true, false);
            SS(sbObjectReadyBack, false);
        end;
        STATE_PROJECT_INWORK:
        begin
            SS(sbObjectToWork, false);
            SS(sbObjectToView, true, mngData.HasRole( ROLE_OBJECT_FROM_WORK, WorkgroupID ));

            SS(sbObjectToCheck, true, mngData.HasRole( ROLE_OBJECT_TO_CHECK, WorkgroupID ));
            SS(sbObjectCheckingBack, false);

            SS(sbObjectToReady, true, false);
            SS(sbObjectReadyBack, false);
        end;
        STATE_PROJECT_CHECKING, STATE_PROJECT_WAITING:
        begin
            SS(sbObjectToWork, true, false);
            SS(sbObjectToView, false);

            SS(sbObjectToCheck, false);
            SS(sbObjectCheckingBack, true, mngData.HasRole( ROLE_OBJECT_FROM_CHECK, WorkgroupID ));

            SS(sbObjectToReady, true, mngData.HasRole( ROLE_OBJECT_TO_READY, WorkgroupID ));
            SS(sbObjectReadyBack, false);
        end;
        STATE_PROJECT_READY:
        begin
            SS(sbObjectToWork, true, false);
            SS(sbObjectToView, false);

            SS(sbObjectToCheck, true, false);
            SS(sbObjectCheckingBack, false);

            SS(sbObjectToReady, false);
            SS(sbObjectReadyBack, true, mngData.HasRole( ROLE_OBJECT_FROM_READY, WorkgroupID ));
        end;
    end;

end;

procedure TfProject.grdDocsCellMouseClick(Grid: TCustomGridEh; Cell: TGridCoord;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  var Processed: Boolean);
begin
    UpdateFilePreview;
    SetupPopup;
end;

procedure TfProject.grdDocsDblClick(Sender: TObject);
begin
    OpenFilePreview( grdDocs.DataSource.DataSet );
end;

procedure TfProject.grdDocsSelectionChanged(Sender: TObject);
begin
    UpdateFilePreview;
    SetupPopup;
end;

procedure TfProject.grdProjectObjectApplyFilter(Sender: TObject);
begin
    (Sender as TDBGridEh).DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( Sender as TDBGridEh );
end;

procedure TfProject.grdProjectObjectCellClick(Column: TColumnEh);
begin
    UpdatePanel;
    UpdateDocList;
    UpdateFilePreview;
    SetupPopup;
end;

procedure TfProject.grdProjectObjectColumns5UpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
/// обработка ввода нового числа в колонке с количеством
var
    lid : integer;
begin

    // признак того, что событие обработано
    Handled := true;

    if Value <= 0 then Value := 1;

    /// менять количество можно только если объект в работе
    if grdProjectObject.DataSource.DataSet.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не находится в работе');
        exit;
    end;

    // и пользователь является редактором
    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь назначенным редактором объекта');
        exit;
    end;

    /// поскольку в наборе данных нет поля с id связки, содержащей количество
    /// (что связано с появлением некрасивых повторов объектов из разных веток
    /// дерева) сначала получаем id связки по родителю и объекту
{    lid := mngData.PresentLink(
        gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger,
        grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger,
        LNK_PROJECT_STRUCTURE
    );
}
    lid := grdProjectObject.DataSource.DataSet.FieldByName('lid').AsInteger;

    if lid <> 0 then
    if mngData.ChangeObjectEx( LNK_PROJECT_STRUCTURE, lid, ['count'], [Value] )
    then
       ShowSubitems;

end;

procedure TfProject.grdProjectObjectDblClick(Sender: TObject);
var
   mode, child : integer;
   ds : TDataset;
begin
    // установка одного из этих флагов означает, что пользователь
    // работает в режиме быстрого изменения количества и обрабатывать
    // клики не нужно
    if is_ctrl or is_alt then exit;

    ds := (Sender as TDBGridEh).DataSource.DataSet;

    if assigned(ds.FindField('mem_child')) then child := ds.FieldByName('mem_child').AsInteger;
    if assigned(ds.FindField('child')) then child := ds.FieldByName('child').AsInteger;

    if not ds.Active or
       ( ds.RecordCount = 0 )
    then exit;

    // выбираем режим показа карточки. по умолчанию только просмотр
    mode := OBJECT_CARD_MODE_VIEW;

    // если режим допускает редактирование
    if  ds.FieldByName('status').AsInteger = PROJECT_OBJECT_INWORK
    then
        // и проект не заморожен или завершен
        if  ( ProjectStatus <> PROJECT_ZREEZE ) and
            ( ProjectStatus <> PROJECT_DONE ) and
            mngData.HasRole( ROLE_EDIT_OBJECT, WorkgroupID ) AND
            mngData.UserIsEditor( child )
        // можно редактировать
        then mode := OBJECT_CARD_MODE_EDIT;

    TfObjectCard
        .Create( self, mode, ObjectPageCardCallback, ds, grdDocs.DataSource.DataSet )
        .SetProject(ProjectID)
        .SetChild( child )
        .Init
        .Show;
end;


procedure TfProject.grdProjectObjectGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin


    // дерево проекта не готово
    if not gridProjectTree.DataSource.DataSet.Active or (gridProjectTree.DataSource.DataSet.RecordCount = 0) then exit;
    // список объектов не готов
    if not grdProjectObject.DataSource.DataSet.Active or (grdProjectObject.DataSource.DataSet.RecordCount = 0) then exit;

    // текущий объект выбранный в дереве совпадает с отрисовываемым в списке объектов
    if gridProjectTree.DataSource.DataSet.FieldByName('mem_aChild').AsInteger =
           grdProjectObject.DataSource.DataSet.FieldByName('lid').AsInteger
     then
     begin
         // выделяем в списке
         // {!} позднее получать от менеджера кастомной настройки интерфейса
//         AFont.Style := [fsBold];
//         AFont.Color := clWhite;
         Background := clMenu;//clSilver;
     end
end;

procedure TfProject.grdProjectObjectMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    coord: GridsEh.TGridCoord;
    grid : TDBGridEh;
    i, count_field, increment : integer;
begin
    // если не зажат control - сразу на выход
    if (not is_ctrl) and (not is_alt) then exit;

    grid := Sender as TDBGridEh;

    // если источник данных неготов - выходим
    if not grid.DataSource.DataSet.Active or (grid.DataSource.DataSet.RecordCount = 0) then exit;

    // ищем индекс поля, в котором хранится количество
    count_field := -1;
    for i := 0 to grid.FieldCount-1 do
    if   grid.Fields[i].FieldName = 'count'
    then count_field := i;

    // поле не найдено - выходим
    if count_field = -1 then exit;

    // получаем координаты в ячейках, куда кликнули мышкой
    coord := grid.MouseCoord(X, Y);
    grid.DataSource.DataSet.RecNo := coord.y - 1;

    // щелчек не по колонке в количеством - выходим
    if coord.X <> count_field then exit;

    /// менять количество можно только если объект в работе
    if grid.DataSource.DataSet.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не находится в работе');
        exit;
    end;

    // и пользователь является редактором
    if not mngData.UserIsEditor( grid.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь назначенным редактором объекта');
        exit;
    end;

    increment := 0;
    // увеличиваем на 1
    if is_ctrl then increment := 1;
    // уменьшаем на 1, если это не снизит до нуля
    if (is_alt) and ((grid.Fields[count_field].AsFloat - 1) > 0) then increment := -1;

    if increment <> 0 then
    begin
        // меняем в базе
        if mngData.ChangeObjectEx(
            LNK_PROJECT_STRUCTURE,
            grid.DataSource.DataSet.FieldByName('lid').AsInteger,
            ['count'],
            [grid.DataSource.DataSet.FieldByName('count').AsFloat + increment]
        )
        // если успешно, обновляем список объектов
        then
            ShowSubitems;
    end;

end;

procedure TfProject.grdProjectObjectSelectionChanged(Sender: TObject);
begin
    UpdatePanel;
    UpdateDocList;
    UpdateFilePreview;
    SetupPopup;
end;

procedure TfProject.gridProjectTreeCellClick(Column: TColumnEh);
begin
    if fDropedFile <> '' then ImportFileToProject;
    UpdatePanel;
    ShowSubitems;
end;

procedure TfProject.SetLocalStatus(base_id, status, mode: integer);
/// метод для локального обновления статусов объектов без перестроения
/// дерева из базы
/// base_id - базовый объект в дереве
/// status  - нужный статус
/// mode    - 0 - только этот объект, 1 - сам и непосредственные потомки, 2 - сам и все потомки
var
    ds: TDataset;
    to_work: array of integer;
  I: Integer;
    /// массив всех id для которых нужно будет обработать потомков

    procedure SetStatus;
    begin
        ds.Edit;
        ds.FieldByName('status').AsInteger := status;
        ds.Post;
    end;
begin
    ds := gridProjectTree.DataSource.DataSet;
    if not ds.Active or (ds.RecordCount = 0) then exit;

    /// устанавливаем сам объект
    ds.First;
    if ds.Locate('mem_child', VarArrayOf([base_id]), []) then SetStatus;

    /// обновляем непосредственных потомков
    if mode = MODE_LOCAL_CHILDS then
    begin
        ds.First;
        while ds.eof do
        begin
            if ds.FieldByName('mem_parent').AsInteger = base_id then
            begin
                SetStatus;
                /// запоминаем для дальнейшей более глубокой обработки
                SetLength(to_work, Length(to_work)+1);
                to_work[High(to_work)] := ds.FieldByName('mem_child').AsInteger;
            end;

            ds.Next;
        end;
    end;

{$IFDEF VT}
    /// глубокая обработка
    if mode = MODE_LOCAL_CHILDS then
    for I := Low(to_work) to High(to_work) do
        SetLocalStatus( to_work[i], status, MODE_LOCAL_CHILDS );
{$ENDIF}

    // не хочет дерево обновляться без полного перестроения. шляпа.
{    gridProjectTree.DataSource.DataSet.Close;
    gridProjectTree.DataSource.DataSet.Open;
}
end;

procedure TfProject.SetObjectStatus(status: integer);
var
    ds
   ,dsEditors
    : TDataset;

    error : string;
    has_to_work_personaly
   ,is_editor
   ,is_checker
   ,has_doc_in_work
            : boolean;

    child : integer;
begin

    ds := nil;
    error := '';
    child := 0;

    /// получаем таблицу, которая активна при вызове функции (дерево состава или спеисок объектов)
    if gridProjectTree.Focused
    then ds := gridProjectTree.DataSource.DataSet;

    if grdProjectObject.Focused
    then ds := grdProjectObject.DataSource.DataSet;

    if not Assigned(ds) or not ds.Active or (ds.RecordCount = 0) then exit;


    /// получаем id объекта потенциального родителя
    /// у дерева проекта и таблицы вложенных объектов они имеют разные имена
    if Assigned(ds.Fields.FindField('child')) then child := ds.Fields.FindField('child').AsInteger;
    if Assigned(ds.Fields.FindField('mem_child')) then child := ds.Fields.FindField('mem_child').AsInteger;

    if child = 0 then exit;


    ///
    dsEditors := mngData.GetObjectEditors( child, ProjectID );


    // получаем результаты для повторяющихся проверок
    is_editor := mngData.UserIsEditor( child );
    is_checker := mngData.UserIsChecker( child );
    has_doc_in_work := mngData.HasDocInWork( child );


    // проверки для текущего статуса "просмотр" => "в работу"
    if ( ds.FieldByName('status').AsInteger = STATE_PROJECT_READONLY ) AND
       ( status = STATE_PROJECT_INWORK )
    then
    begin
        has_to_work_personaly := mngData.HasRole( ROLE_OBJECT_TO_WORK_PERSONALY, WorkgroupID );

        /// проверяем право самоназначения редактором, если редактор не назначен
        if error = '' then
        if not has_to_work_personaly
        then error := 'Отсутствует право самоназаначения редактором.';

        /// при возможности самоназначаться и
        if error = '' then
        if has_to_work_personaly and (not is_editor) and (dsEditors.RecordCount > 0 )
        then error := 'Редактор уже назначен.';

        /// привязываем текущего пользователя как редактора
        if error = '' then
        mngData.LinkEditorToObject( child, CORE.User.id, ProjectID );
    end;


    /// проверка для текущего статуса "в работе" => "для просмотра"
    if ( ds.FieldByName('status').AsInteger = STATE_PROJECT_INWORK ) and
       ( status = STATE_PROJECT_READONLY )
    then
    begin
        // проверка на наличие текущего пользователя в редакторах
        if not is_editor
        then error := 'Пользователь не является редактором объекта для изменения статуса.';

        // проверяем на наличие документов в работе у редактируемого объекта
        if has_doc_in_work
        then error := 'У объекта есть документы в работе. Сначала завершите работу с ними.';

        if not mngData.HasRole( ROLE_OBJECT_TO_WORK_PERSONALY, WorkgroupID )
        then error := 'Отсутствуют права возврата из статуса редактирования.';
    end;


    /// проверка для статуса "в работе" => "в проверку"
    if ( ds.FieldByName('status').AsInteger = STATE_PROJECT_INWORK ) and
       ( status = STATE_PROJECT_CHECKING )
    then
    begin
        if not is_editor
        then error := 'Пользователь не является редактором объекта для изменения статуса.';

        // проверяем на наличие документов в работе у редактируемого объекта
        if has_doc_in_work
        then error := 'У объекта есть документы в работе. Сначала завершите работу с ними.';

        if not mngData.HasRole( ROLE_OBJECT_TO_CHECK, WorkgroupID )
        then error := 'Отсутствуют права на перевод в статус проверки.';
    end;


    /// проверка для статуса "в проверке" => "в работу"
    if ( ds.FieldByName('status').AsInteger = STATE_PROJECT_CHECKING ) and
       ( status = STATE_PROJECT_INWORK )
    then
    begin
        if not is_editor and not is_checker
        then error := 'Пользователь не является редактором или контролером объекта для изменения статуса.';

        if not mngData.HasRole( ROLE_OBJECT_FROM_CHECK, WorkgroupID )
        then error := 'Отсутствуют права на возврат в работу.';
    end;


    /// проверка для статуса "в проверке" => "готово"
    if ( ds.FieldByName('status').AsInteger = STATE_PROJECT_CHECKING ) and
       ( status = STATE_PROJECT_READY)
    then
    begin
        /// привязываем текущего пользователя как проверяющего, если есть право самоназначения
        if not is_checker and mngData.HasRole( ROLE_OBJECT_TO_READY_PERSONALY , WorkgroupID) then
        begin
            mngData.LinkCheckerToObject( child, CORE.User.id, ProjectID );
            is_checker := true;
        end;

        if not is_checker
        then error := 'Пользователь не является контролером объекта для изменения статуса.';

        if not mngData.HasRole( ROLE_OBJECT_TO_READY, WorkgroupID )
        then error := 'Отсутствуют права на установку статуса готовности.';
    end;


    /// проверка для статуса "готово" => "в проверке"
    if ( ds.FieldByName('status').AsInteger = STATE_PROJECT_READY ) and
       ( status = STATE_PROJECT_CHECKING)
    then
    begin
        if not mngData.HasRole( ROLE_OBJECT_FROM_READY, WorkgroupID )
        then error := 'Отсутствуют права на возврат из готовности.';
    end;


    // при наличии ошибки, сообщаем о ней и не меняем стстус
    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    /// меняем статус
    if   not mngData.SetProjectObjectState( child, status ) then
    begin
        ShowMessage( CORE.DM.DBError );
        exit;
    end;

    mngProjectTree.Refresh( [ProjectID] );
///    SetLocalStatus( child, status, MODE_LOCAL_SOLO );

    UpdatePanel;
    ShowSubitems;

end;

procedure TfProject.SetupPopup;
begin
    grdDocs.PopupMenu := nil;

    if Assigned(grdDocs.DataSource.DataSet) and (grdDocs.DataSource.DataSet.RecordCount > 0) then
    if grdDocs.DataSource.DataSet.FieldByName('editor_fio').IsNull
    then grdDocs.PopupMenu := popDocument
    else grdDocs.PopupMenu := popWorkDocument;
end;

procedure TfProject.gridProjectTreeDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
   coord: GridsEh.TGridCoord;
   TargetGrid
  ,SourceGrid
           : TDBGridEh;
   child_id
  ,parent_id
  ,parent_status
  ,parent_kind
  ,parent_icon

  ,child_kind
  ,child_icon
  ,child_link
  ,child_status

  ,link_id
           : integer;
   link_error
           : string;
   list: TListBox;

    procedure AssignUserToObject;
    // назначение пользователя на объект (редактор, контролер)
    begin

        /// проверка состояния объекта
        if parent_status = STATE_PROJECT_DISABLED then
        begin
            ShowMessage('Объект не доступен для редактирования');
            exit;
        end;

        list := Source as TListBox;

        // спрашиваем, действительно ли пользователь хочет назначить исполнителя
        if (TargetGrid.Columns[coord.X].FieldName = 'editor_id')
        then
        begin
            /// проверка возможности назначения контролера
            if not mngData.HasRole( ROLE_ASSIGN_EDITOR, WorkgroupID) then
            begin
                ShowMessage('Нет прав назначения исполнителя');
                exit;
            end;

            if mngData.HasDocInWork( parent_id ) then
            begin
                ShowMessage('Есть документы в работе. Нельзя заместить исполнителя.');
                exit;
            end;

            if  Application.MessageBox(
                    PChar('Вы действительно хотите назначить ' + sLineBreak +
                           list.Items[list.Itemindex]+ sLineBreak + sLineBreak +
                          ' ИСПОЛНИТЕЛЕМ?'+ sLineBreak +
                          ' Текущий исполнитель будет заменен, если есть'),
                    'Назначение исполнителя',
                    MB_YESNO + MB_ICONQUESTION
                ) = ID_NO
            then exit;

            /// переводим объект в статус редактирования, если он еще не устанолен
            mngData.SetProjectObjectState( parent_id, STATE_PROJECT_INWORK );

            /// удаляем текущего редактора, если есть
            /// поскольку можно назначить только одного
            mngData.UnlinkEditorsFromObject(parent_id);

            /// привязываем пользователя как редактора
            if mngData.LinkEditorToObject( parent_id, Integer(list.Items.Objects[list.Itemindex]), ProjectID ) <> 0
            then mngProjectTree.Refresh([ProjectID]);

            /// привязываем ему группу с правами редактора, если еще нет
            mngData.LinkUserToWorkroup( WorkgroupID, Integer(list.Items.Objects[list.Itemindex]));
            mngData.LinkWorkgroupUserToGroup( WorkgroupID, Integer(list.Items.Objects[list.Itemindex]), ROLE_GROUP_EDITOR );

        end;
        if (TargetGrid.Columns[coord.X].FieldName = 'checker_id') then
        begin
            /// проверка возможности назначения контролера
            if not mngData.HasRole( ROLE_ASSIGN_CHECKER, WorkgroupID) then
            begin
                ShowMessage('Нет прав назначения контролера');
                exit;
            end;

            if  Application.MessageBox(
                    PChar('Вы действительно хотите назначить '+ sLineBreak +
                          list.Items[list.Itemindex] + sLineBreak +
                          'КОНТРОЛЕРОМ?'),
                    'Назначение контролера',
                    MB_YESNO + MB_ICONQUESTION
                ) = ID_NO
            then exit;

            /// привязываем пользователя как редактора
            if mngData.LinkCheckerToObject( parent_id, Integer(list.Items.Objects[list.Itemindex]), ProjectID ) <> 0
            then mngProjectTree.Refresh([ProjectID]);

            /// привязываем ему группу с правами проверяющего, если еще нет
            mngData.LinkUserToWorkroup( WorkgroupID, Integer(list.Items.Objects[list.Itemindex]));
            mngData.LinkWorkgroupUserToGroup( WorkgroupID, Integer(list.Items.Objects[list.Itemindex]), ROLE_GROUP_CHECKER );
        end;

    end;

    procedure AddObjectToProject;
    // привязка к дереву проекта объекта из справочника
    begin
        // определяем источник взятия добавляемого объекта
        // это может быть реальный объект из таблицы objects и тогда его придется
        // сначала скопировать в project_object

        // для этого смотрим имя таблицы.
        if SourceGrid.Name = 'grdCatalogObjects' then
        begin

            if ( TargetGrid.DataSource.DataSet.RecordCount = 0 ) then
            begin
                /// отсекаем уже разрабатываемую спецификацию
                if mngData.SpecInWork( child_id ) then
                begin
                    ShowMessage('Cпецификация уже находится в работе в другом проекте!');
                    exit;
                end;

                // отсекаем объекты не являющиеся спецификацией
                if child_kind <> KIND_SPECIF
                then
                begin
                    ShowMessage('Корневым объектом проекта может быть только спецификация!');
                    exit;
                end;
            end else
            begin
                link_error := '';

                // проверка возможности связки исходя из наличия ролей
                if not mngData.HasRole( ROLE_LINK_TO_STRUCTURE, WorkgroupID )
                then link_error := 'Отсутствует право привязки объектов к структуре.';

                if not mngData.UserIsEditor( parent_id )
                then link_error := 'Пользователь не является редактором целевого объекта.';

                // проверка возможности связки объектов исходя из логики вложенности объектов
                if link_error = '' then
                link_error := mngData.CheckLinkAllow(
                    // данные привязываемого объекта
                    child_kind, child_icon, PROJECT_OBJECT_NOSTATUS,
                    // данные потенциального родителя
                    parent_kind, parent_icon, parent_status
                );
                if link_error <> '' then
                begin
                    ShowMessage( link_error );
                    exit;
                end;

            end;

            if not Core.DM.ADOConnection.InTransaction
            then   Core.DM.ADOConnection.BeginTrans;

            // если данные пришли из реального справочника, у него будет TAG = -1
            // иначе, tag содержит id проекта из которого взяты
    //        if ( SourceGrid.tag = -1 ) then
            begin
                // копируется объект из согласованного справочника
                if ( child_id > 0 ) then
                begin
                    child_id := mngData.CopyObjectToProject( ProjectID, parent_id, child_id );
                    if child_id = 0 then
                    begin
                        Core.DM.ADOConnection.RollbackTrans;
                        ShowMessage('Нельзя привязать элемент!'+sLineBreak+CORE.DM.DBError);
                    end
                end
            end;

            // копируется объект, созданный в рамках проекта
            if ( child_id < 0 ) then
            begin
                // просто привязываем объект к дереву, создавая допссылки, чтобы он отображался в списке объектов для родителей
                mngData.CreateCrossLinks(
                    LNK_PROJECT_STRUCTURE,
                    mngData.AddLink(LNK_PROJECT_STRUCTURE, parent_id, child_id)
                );

                // если привязываем объект к корню проекта
                if   parent_id = ProjectID then
                begin
                    // обновляем список обозначений объектов в работе проекта, при необходимости
                    mngData.UpdateProjectMark( ProjectID );

                    // принудительно снимаем статус только для просмотра для этого объекта
                    // и непосредственно привязанные исполнения, если это спецификация

                end;
            end;


            if   Core.DM.ADOConnection.InTransaction
            then Core.DM.ADOConnection.CommitTrans;

        end;

        mngProjectTree.Expand;
        mngProjectTree.Refresh([ProjectID]);

    end;

    procedure MoveObject;
    /// перемещение или копирование объекта в дереве проекта
    begin
        /// проверяем потенциального родителя на возможность привязки
        link_error := '';

        // проверка возможности связки исходя из наличия ролей
        if not mngData.HasRole( ROLE_LINK_TO_STRUCTURE, WorkgroupID )
        then link_error := 'Отсутствует право привязки объектов к структуре.';

        if not mngData.UserIsEditor( parent_id )
        then link_error := 'Пользователь не является редактором целевого объекта.';

        // проверка возможности связки объектов исходя из логики вложенности объектов
        if link_error = '' then
        link_error := mngData.CheckLinkAllow(
            // данные привязываемого объекта
            child_kind, child_icon, child_status,
            // данные потенциального родителя
            parent_kind, parent_icon, parent_status
        );
        if link_error <> '' then
        begin
            ShowMessage( link_error );
            exit;
        end;

        /// при нажатом ctrl это считается копированием, удаляем привязку к старому месту
        if not is_ctrl then
        begin
            mngData.DeleteCrossLinks( LNK_PROJECT_STRUCTURE, child_link );
            mngData.DeleteLink( LNK_PROJECT_STRUCTURE, child_link, DEL_MODE_NO_CROSS );
        end;

        /// привязываем объект к указанному родителю
        mngData.CreateCrossLinks( LNK_PROJECT_STRUCTURE, mngData.AddLink( LNK_PROJECT_STRUCTURE, parent_id, child_id ) );

        mngProjectTree.Refresh([ProjectID]);
        ShowSubitems;
    end;

begin

    TargetGrid := (Sender as TDBGridEh);

    if Source is TDBGridEh then
    begin
        SourceGrid := (Source as TDBGridEh);


        /// получаем данные перемещаемого объекта до того, как переместим текущую запись
        /// в целевой таблице.
        /// это нужно из-за того, что исходная и целевая таблиц может быть одной и той же
        /// (в случае перемещения/копирования объекта по самому дереву)
        /// для надежности, сохраняем данные обоих объектов в переменных, учитывая, что
        /// поля с данными могут быть различны у разных источников и приемников

        // id привязываемого элемента
        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('child'))
        then child_id := SourceGrid.DataSource.DataSet.FieldByName('child').AsInteger;
        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('mem_child'))
        then child_id := SourceGrid.DataSource.DataSet.FieldByName('mem_child').AsInteger;
        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('id'))
        then child_id := SourceGrid.DataSource.DataSet.FieldByName('id').AsInteger;

        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('kind'))
        then child_kind := SourceGrid.DataSource.DataSet.FieldByName('kind').AsInteger;
        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('mem_kind'))
        then child_kind := SourceGrid.DataSource.DataSet.FieldByName('mem_kind').AsInteger;

        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('icon'))
        then child_icon := StrToIntDef(SourceGrid.DataSource.DataSet.FieldByName('icon').AsString, 0);
        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('mem_icon'))
        then child_icon := StrToIntDef(SourceGrid.DataSource.DataSet.FieldByName('mem_icon').AsString, 0);

        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('status'))
        then child_status := SourceGrid.DataSource.DataSet.FieldByName('status').AsInteger
        else child_status := PROJECT_OBJECT_NOSTATUS;

        if   Assigned(SourceGrid.DataSource.DataSet.Fields.FindField('mem_aChild'))
        then child_link := SourceGrid.DataSource.DataSet.FieldByName('mem_aChild').AsInteger
        else child_link := 0;
    end;



    /// перемещаем текущую запись в таблице приемнике на ту, где отпущена мышка
    coord := TargetGrid.MouseCoord(X, Y);
    TargetGrid.DataSource.DataSet.RecNo := coord.y + 1;



    // id объекта в дереве проекта который готовится стать папой
    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('mem_child'))
    then parent_id := TargetGrid.DataSource.DataSet.FieldByName('mem_child').AsInteger;
    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('child'))
    then parent_id := TargetGrid.DataSource.DataSet.FieldByName('child').AsInteger;
    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('id'))
    then parent_id := TargetGrid.DataSource.DataSet.FieldByName('id').AsInteger;
    if   parent_id = 0
    then parent_id := ProjectID;

    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('kind'))
    then parent_kind := StrToIntDef(TargetGrid.DataSource.DataSet.FieldByName('icon').AsString, 0);
    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('mem_kind'))
    then parent_kind := StrToIntDef(TargetGrid.DataSource.DataSet.FieldByName('mem_icon').AsString, 0);

    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('icon'))
    then parent_icon := TargetGrid.DataSource.DataSet.FieldByName('icon').AsInteger;
    if   Assigned(TargetGrid.DataSource.DataSet.Fields.FindField('mem_icon'))
    then parent_icon := TargetGrid.DataSource.DataSet.FieldByName('mem_icon').AsInteger;

    parent_status := TargetGrid.DataSource.DataSet.FieldByName('status').AsInteger;


    /// если пользователь отпустил мышку на том же элементе (простой клик)
    if parent_id = child_id then exit;


    /// источник перетаскивания - список пользователей
    if (Source is TListBox) and ((Source as TListBox).Name = 'listUsers')
    then AssignUserToObject;

    /// источник перетаскивания - справочник объектов
    if   (Source is TDBGridEh) and ((Source as TDBGridEh).Name = 'grdCatalogObjects')
    then AddObjectToProject;

    /// источник перетаскивания - сама структура проекта
    if   (Source is TDBGridEh) and (((Source as TDBGridEh).Name = 'gridProjectTree') OR ((Source as TDBGridEh).Name = 'grdSpecific'))
    then MoveObject;
end;

procedure TfProject.gridProjectTreeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfProject.gridProjectTreeEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
    lM('file: ' + fDropedFile);
end;

procedure TfProject.gridProjectTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    /// клик, не являющийся перетаскиванием файла из проводника
    if   (Button = TMouseButton.mbLeft) and (fDropedFile = '')
    then gridProjectTree.BeginDrag(true);
end;

procedure TfProject.gridProjectTreeSelectionChanged(Sender: TObject);
begin
    UpdatePanel;
    ShowSubitems;
end;

procedure TfProject.Init;
/// инициализация формы данными указанного проекта
begin

    if ProjectID = 0 then
    begin
        ShowMessage('Не выбран проект для отображения.');
        exit;
    end;

    // обнуляем ссылки на подсиненные окна
    wndObjectCatalog := nil;
    wndUserList := nil;
    wndObjectCard := nil;
    wndLoadSpec := nil;
    wndSpecTreeFree := nil;

    /// получаем основные параметры проекта
    ProjectStatus := mngData.ProjectStatus( ProjectID );
    WorkgroupID := mngData.GetProjectWorkgroup( ProjectID );

    // формируем дерево групп
    mngProjectTree := TTreeManager.Create.SetExtFields(
        ['status','editor_id','checker_id', 'name', 'markTU'],
        [FT_INTEGER, FT_INTEGER, FT_INTEGER, FT_STRING, FT_STRING]
    );
    mngProjectTree.init(gridProjectTree, VIEW_PROJECT_STRUCTURE);

{$IFDEF VT}
    mngProjectTree.initVT(vsgProjectTree);
    mngProjectTree.ClearColumns;
    mngProjectTree.AddColumn( 'mem_name', FIELD_KIND_TEXT, -1, nil );
    mngProjectTree.AddColumn( 'mem_kind', FIELD_KIND_IMAGE, -1, fMain.ilTreeIcons );
    mngProjectTree.AddColumn( 'mem_icon', FIELD_KIND_IMAGE, -1, fMain.ilTreeIcons );
    mngProjectTree.AddColumn( 'status', FIELD_KIND_IMAGE, -1, imgObjectState );
    mngProjectTree.AddColumn( 'editor_id', FIELD_KIND_IMAGE, 0, listEditor );
    mngProjectTree.AddColumn( 'checker_id', FIELD_KIND_IMAGE, 0, listChecker );
    mngProjectTree.SetVirtualTreeMode;
{$ENDIF}

//    mngProjectTree.GetTreeLevel(ProjectID, 0);
    fRoots := [ProjectID];
    fRootsInclude := false;

    mngProjectTree.Refresh( fRoots, fRootsInclude );
    mngProjectTree.FullExpand;

    grdProjectObject.DataSource := TDataSource.Create(self);
    grdProjectObject.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdProjectObject, [0,1,2] );
    mngDatatable.ConfigureForSorting( grdProjectObject, [] );

    grdDocs.DataSource := TDataSource.Create(self);
    grdDocs.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdDocs, [0,1] );
    mngDatatable.ConfigureForSorting( grdDocs, [] );


    /// инициализируем менеджер отрисовки спецификации
    mngDrawSpecif := TDrawSpecifManager.Create.SetGrid( StringGrid );
    if not mngDrawSpecif.Init
    then ShowMessage( mngDrawSpecif.error );

    /// настраиваем функции интерфейса, исходя из текущих ролей
    CheckRole;
    /// запускаем периодическую проверку изменения ролей
    timerCheckRole.Enabled := false;
    timerCheckRole.Interval := RIGHT_TIME_INTERFASE_UPDATE_PERIOD;
    timerCheckRole.Enabled := true;

    mngUserList := TUserListManager
        .Create
        .SetKindComponent(cbUserGroups)
        .SetFindComponent(eUserFilter)
        .SetListComponent(listUsers)
        .SetProjectId(ProjectID)
        .SetWorkgroupId(WorkgroupID)
        .SetDataManager(mngData);

    if not mngUserList.Init
    then lW(mngUserList.error);

    UpdatePanel;
end;

procedure TfProject.menuViewFileClick(Sender: TObject);
begin
    OpenFilePreview( grdDocs.DataSource.DataSet );
end;

procedure TfProject.pcProjectChange(Sender: TObject);
var
   doc : TDocCreater;
   i : integer;
begin
    if pcProject.ActivePage = tabTasks then
    begin

        doc := TDocCreater.Create;

        doc.Template.InitLandscape;
        doc.SetStyle( TASKLIST_STYLE );

        doc.AddHTML( TASK_TEMPLATE_HTML );
        doc.SetValue('class', ' complete');
        doc.SetValue('initiator', CORE.User.name);
        doc.SetValue('created', DateToStr(Now()));
        doc.SetValue('status', 'Завершено');
        doc.SetValue('executer', CORE.User.name);
        doc.SetValue('complete', DateToStr(Now()));
        doc.SetValue('accepted', DateToStr(Now()));
        doc.SetValue('edit_img', DIR_IMAGE + 'edit.bmp');
        doc.SetValue('delete_img', DIR_IMAGE + 'close_athcetic.bmp');
        doc.SetValue('text', 'Первое задание.');

        doc.SetValue('comment', COMMENT_TEMPLATE_HTML + '#comment#');
        doc.SetValue('initiator', CORE.User.name);
        doc.SetValue('created', DateToStr(Now()));
        doc.SetValue('project', '-');
        doc.SetValue('edit_img', DIR_IMAGE + 'edit.bmp');
        doc.SetValue('delete_img', DIR_IMAGE + 'close_athcetic.bmp');
        doc.SetValue('text', 'Комментарий к заданию');

        doc.SetValue('comment', COMMENT_TEMPLATE_HTML);
        doc.SetValue('initiator', CORE.User.name);
        doc.SetValue('created', DateToStr(Now()));
        doc.SetValue('project', '-');
        doc.SetValue('edit_img', DIR_IMAGE + 'edit.bmp');
        doc.SetValue('delete_img', DIR_IMAGE + 'close_athcetic.bmp');
        doc.SetValue('text', 'Еще один комментарий');

        doc.AddHTML( TASK_TEMPLATE_HTML );
        doc.SetValue('initiator', CORE.User.name);
        doc.SetValue('created', DateToStr(Now()));
        doc.SetValue('status', 'В работе');
        doc.SetValue('executer', CORE.User.name);
        doc.SetValue('complete', '-');
        doc.SetValue('accepted', '-');
        doc.SetValue('edit_img', DIR_IMAGE + 'edit.bmp');
        doc.SetValue('delete_img', DIR_IMAGE + 'close_athcetic.bmp');
        doc.SetValue('text', 'Второе задание.');
        doc.SetValue('comment', '');

        doc.SaveToFile(DIR_TEMP + 'tasks.html');

        browserTasks.Navigate(DIR_TEMP + 'tasks.html');

    end;

    if pcProject.ActivePage = tabStatus then
    begin
        if lWorkgroupName.Caption = '...' then lWorkgroupName.Caption := mngData.GetWorkgroupName( WorkgroupID );
        lRedyPercent.Caption := IntToStr( mngData.GetProjectReadyPercent( ProjectID ) ) + '%';
    end;
end;

procedure TfProject.popObject1Popup(Sender: TObject);
begin
    Application.ProcessMessages;
end;

procedure TfProject.popStructurePopup(Sender: TObject);
var
    ds: TDataset;
    item: TMenuItem;
begin
    if not gridProjectTree.DataSource.DataSet.Active or (gridProjectTree.DataSource.DataSet.RecordCount = 0)
    then exit;

    menuDelEditor.Clear;

    ds := mngData.GetObjectEditors( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, ProjectID );
    if not Assigned(ds) then exit;

    while not ds.Eof do
    begin
        item := TMenuItem.Create(menuDelEditor);
        item.Caption := ds.FieldByName('name').AsString;
        item.Tag := ds.FieldByName('id').AsInteger;
        item.OnClick := DeleteEditor;
        menuDelEditor.Add( item );
        ds.Next;
    end;

    menuDelChecker.Clear;

    ds := mngData.GetObjectCheckers( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, ProjectID );
    if not Assigned(ds) then exit;

    while not ds.Eof do
    begin
        item := TMenuItem.Create(menuDelEditor);
        item.Caption := ds.FieldByName('name').AsString;
        item.Tag := ds.FieldByName('id').AsInteger;
        item.OnClick := DeleteChecker;
        menuDelChecker.Add( item );
        ds.Next;
    end;

end;

procedure TfProject.DeleteEditor(Sender: TObject);
var
    error: string;
begin
    if not (sender is TMenuItem) then exit;

    error := '';

    if not mngData.HasRole( ROLE_DELETE_EDITOR, WorkgroupID)
    then error := 'Отсутствует право удаления исполнителя.';

    if mngData.HasDocInWork( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger )
    then error := 'Есть документы в работе. Нельзя удалить исполнителя.';

    if gridProjectTree.DataSource.DataSet.FieldByName('status').AsInteger = STATE_PROJECT_DISABLED
    then error := 'Работа над объектом завершена. Редактирование недопустимо.';

    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    if mngData.DeleteOjectEditor( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, (sender as TMenuItem).Tag )
    then mngProjectTree.Refresh( fRoots, fRootsInclude );
end;

procedure TfProject.DeleteChecker(Sender: TObject);
begin
    if not (sender is TMenuItem) then exit;

    /// проверка на наличие права на удаление
    if not mngData.HasRole( ROLE_DELETE_CHECKER, WorkgroupID) then
    begin
        ShowMessage('Отсутствует право удаления контролера.');
        exit;
    end;

    if gridProjectTree.DataSource.DataSet.FieldByName('status').AsInteger = STATE_PROJECT_DISABLED
    then
    begin
        ShowMessage('Работа над объектом завершена. Редактирование недопустимо.');
        exit;
    end;

    if mngData.DeleteOjectChecker( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, (sender as TMenuItem).Tag )
    then mngProjectTree.Refresh( fRoots, fRootsInclude );
end;

procedure TfProject.menuAddDocumentClick(Sender: TObject);
begin
   AddDocumentDialog;
end;

procedure TfProject.menuCancelVersionClick(Sender: TObject);
{ возвращаем взятый в редактирование документ без сохранения изменений.
  при этом рабочая версия полностью удаляется }
begin

    /// проверка на наличие права взятия документа в работу
    if not mngData.HasRole( ROLE_TAKE_DOC_IN_WORK, WorkgroupID) then
    begin
        ShowMessage('Отсутствует право взятия документа в работу.');
        exit;
    end;

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь редактором объекта для выполнения данной операции.');
        exit;
    end;

    if grdProjectObject.DataSource.Dataset.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не переведен в статус "В работе"');
        exit;
    end;

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Вернуть документ из редактирования без сохранения изменений? Новая версия не будет создана.',
            'Возврат без сохранения',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if not mngData.DeleteWorkDocument( grdDocs.DataSource.DataSet.FieldByName('project_doc_id').AsInteger ) then
    begin
        ShowMessage( Core.DM.DBError );
        exit;
    end;

    // обновляем список документов
    UpdateDocList;
    UpdateFilePreview;
end;

procedure TfProject.menuCopyIspolClick(Sender: TObject);
/// метод работает на любом исполнении корневой спецификации проекта
/// берет это исполнение за образец, создает новое и заполняет его по образцу
var
    error : string;
    spec, status: integer;
begin

    error := '';
    /// проверяем, выбрана ли корневая спецификация. ее родитель - объект проекта
    if gridProjectTree.DataSource.DataSet.FieldByName('mem_icon').AsInteger <> KIND_ISPOLN
    then error := 'Выберите исполнение корневой спецификации для выполнения данной операции.';

    // проверяем, что исполнение принадлежит корневой спецификации
    /// получаем данные спецификации и ее родитель должен быть объект-проект
    spec := dmSQ(' SELECT parent FROM ' + VIEW_PROJECT_STRUCTURE +
                 ' WHERE child = ' + gridProjectTree.DataSource.DataSet.FieldByName('mem_parent').AsString );

    if spec <> ProjectID
    then error := 'Исполнение не принадлежит корневой спецификации';


    if error = '' then
    begin
        status := dmSQ(' SELECT status FROM ' + VIEW_PROJECT_STRUCTURE +
                       ' WHERE child = ' + gridProjectTree.DataSource.DataSet.FieldByName('mem_parent').AsString);

        if status = STATE_PROJECT_DISABLED
        then error := 'Спецификация уже выгружена в КД и не может быть отредактирована.';
    end;

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger )
    then error := 'Вы не являетесь редактором спецификации для выполнения данной операции.';


    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    /// копируем исполнение под новым номером
    if mngData.CopyIspoln(
        ProjectID,
        gridProjectTree.DataSource.DataSet.FieldByName('mem_parent').AsInteger,
        gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger,
        gridProjectTree.DataSource.DataSet.FieldByName('mem_mark').AsString,
        gridProjectTree.DataSource.DataSet.FieldByName('name').AsString
    ) = 0 then exit;

    /// показываем изменения
    mngProjectTree.Refresh( fRoots, fRootsInclude );
end;

procedure TfProject.menuCreateIspolClick(Sender: TObject);
var
    next_number : integer;
    error : string;
begin

    error := '';

    /// проверяем, выбрана ли корневая спецификация. ее родитель - объект проекта
    if gridProjectTree.DataSource.DataSet.FieldByName('mem_parent').AsInteger <> ProjectID
    then error := 'Выберите корневую спецификацию для выполнения данной операции.';

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger )
    then error := 'Вы не являетесь редактором спецификации для выполнения данной операции.';

    if error = '' then
    if gridProjectTree.DataSource.dataset.FieldByName('status').AsInteger = STATE_PROJECT_DISABLED
    then error := 'Спецификация уже выгружена в КД и не может быть отредактирована.';

    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    /// создаем исполнение
    if mngData.CreateIspoln(
        ProjectID,
        gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger,
        gridProjectTree.DataSource.DataSet.FieldByName('mem_mark').AsString,
        gridProjectTree.DataSource.DataSet.FieldByName('name').AsString
    ) = 0 then exit;

    /// показываем изменения
    mngProjectTree.Refresh( fRoots, fRootsInclude );
end;

procedure TfProject.menuEditFileClick(Sender: TObject);
{ нажатие кнопки открытия файла в списке объектов для раздела
  навигации "Документы в работе"  }
var
    path, error: string;
begin

    error := '';
    /// проверка на наличие права взятия документа в работу
    if not mngData.HasRole( ROLE_TAKE_DOC_IN_WORK, WorkgroupID)
    then error := 'Отсутствует право взятия документа в работу.';

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger )
    then error := 'Вы не являетесь редактором объекта для выполнения данной операции.';

    if grdProjectObject.DataSource.Dataset.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK
    then error := 'Объект не переведен в статус "В работе"';

    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    path := mngData.GetVersionPath( grdDocs.DataSource.DataSet.FieldByName('project_doc_id').AsInteger, true );
    ShellExecute(Application.Handle, 'open', PChar(path), nil, nil, SW_SHOWDEFAULT);
end;

procedure TfProject.menuMakeFileMainClick(Sender: TObject);
/// устанавливаем указанному документу признак основного,
/// но с проверкой, что это не рабочая версия +
/// в дальнейшем прверять на признак утверждения
begin

    if not grdDocs.DataSource.DataSet.FieldByName('minor_version').IsNull then
    begin
        ShowMessage( 'Рабочую версию нельзя сделать основным документом!');
        exit;
    end;

    /// проверка на наличие права установки признака основного
    if not mngData.HasRole( ROLE_SET_DOC_AS_MAIN, WorkgroupID) then
    begin
        ShowMessage('Отсутствует право установки признака основного документа.');
        exit;
    end;

    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь редактором объекта для выполнения данной операции.');
        exit;
    end;


    if not mngData.SetDocAsMain(
        grdDocs.DataSource.DataSet.FieldByName('project_doc_id').AsInteger,
        grdDocs.DataSource.DataSet.FieldByName('project_object_id').AsInteger
    ) then exit;

    UpdateDocList;

    ShowMessage('Основной файл установлен.');
end;

procedure TfProject.menuReadyAllSubitemsClick(Sender: TObject);
begin
    ReadySubitems( true ); // перевод в статус готовности всех потомков
end;

procedure TfProject.menuReadySubitemsClick(Sender: TObject);
begin
    ReadySubitems( false ); // перевод в статус готовности только непосредственных потомков
end;

procedure TfProject.ReadySubitems( full: boolean);
/// для выбранного объекта, имеющего вложенные элементы
/// пытаемся перевести их в статус готовности
/// для этого текущий пользователь должен иметь право самоназначаться или уже являться
/// редактором и проверяющим
var
    error: string;
    has_doc_in_work : boolean;
begin
    if not gridProjectTree.DataSource.DataSet.Active or ( gridProjectTree.DataSource.DataSet.RecordCount = 0 ) then exit;

    error := '';

    /// проверяем, что у объекта нет потомков в работе, на проверке или не взятые в работу
    if mngData.ObjectIsReady( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger )
    then error := 'Не содержит объектов, которые можно перевести в статус готовности.';

    if error = '' then
    if not mngData.HasRole( ROLE_OBJECT_TO_WORK_PERSONALY, WorkgroupID )
    then error := 'Отсутствует роль самоназанчения редактором';

    if error = '' then
    if not mngData.HasRole( ROLE_OBJECT_TO_READY_PERSONALY, WorkgroupID )
    then error := 'Отсутствует роль самоназанчения контролером';

    if error = '' then
    if mngData.HasDocInWork( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, true )
    then error := 'В составе есть объекты с документами в работе';

    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    if mngData.ChildsToReadyStatus( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, ProjectID, full )
    then mngProjectTree.Refresh( fRoots, fRootsInclude )
    else ShowMessage( CORE.DM.DBError );

end;


procedure TfProject.menuSaveAsVersionClick(Sender: TObject);
{ сохранение текущего состояния рабочего документа, как новой версии }
label ext;
var
    filename: string;
    dsDoc : TDataset;
    hash, parent_hash: string;
begin

    lC('sbSaveVersionClick');

    /// проверка на наличие права взятия документа в работу
    if not mngData.HasRole( ROLE_TAKE_DOC_IN_WORK, WorkgroupID) then
    begin
        ShowMessage('Отсутствует право взятия документа в работу.');
        exit;
    end;

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь редактором объекта для выполнения данной операции.');
        exit;
    end;

    if grdProjectObject.DataSource.Dataset.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не переведен в статус "В работе"');
        exit;
    end;

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Загрузить отредакированный документ в систему как новую версию?',
            'Возврат с сохранением',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then goto ext;

    dsDoc := grdDocs.DataSource.DataSet;

    filename := mngData.GetVersionPath( dsDoc.FieldByName('project_doc_id').AsInteger, true );

    if not FileExists(filename) then
    begin
        ShowMessage( lW( 'Рабочий файл версии отсутствует. Сохранение отменено.' + sLineBreak+ '(' + filename + ')'));
        exit;
    end;

    /// при сохрарнении новой версии, необходимо проверять отличие от исходной версии,
    /// поскольку в рабочей могуть быть любые последовательные изменения, которые, в итоге,
    /// вернут документ к состоянию исходной версии.
    hash := mngFile.GetHash( filename );
    parent_hash := dmSDQ('SELECT hash FROM '+ VIEW_DOCUMENT_PROJECT + ' WHERE project_doc_id = ' + dsDoc.FieldByName('version_parent').AsString, '' );
    if hash = parent_hash then
    begin
        ShowMessage( lW( 'В файл ' + ExtractFileName(filename) + ' не внесено изменений. Создание новой версии отменено.'));
        goto ext;
    end;

    // показываем окно добавления документа в режиме следующей версии (нельзя править путь и имя документа)
    if   not Assigned( fAddDoc )
    then fAddDoc := TfAddDoc.Create(self);

    fAddDoc.object_id   := dsDoc.FieldByName('project_object_id').AsInteger;
    fAddDoc.object_name :=
        '(' + dsDoc.FieldByName('project_object_id').AsString + ') ' +
              dsDoc.FieldByName('obj_name').AsString;
    fAddDoc.filename    := filename;
    fAddDoc.name        := dsDoc.FieldByName('filename').AsString;
    fAddDoc.version_id  := dsDoc.FieldByName('project_doc_id').AsInteger;
    fAddDoc.version     := dsDoc.FieldByName('version').AsString;
//    fAddDoc.doc_type    := dsDoc.FieldByName('document_type_id').AsInteger;
    fAddDoc.mode        := SAVE_MODE_NEW_VERSION; // добавление следующей версии
    fAddDoc.callback    := SaveDocVersionCallback;

    fAddDoc.Show;

ext:
    lCE;

end;

function TfProject.SaveDocVersionCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
begin
    result := false;

    if not mngData.SaveWorkDocumentAsVersion( version_id ) then
    begin
        ShowMessage( Core.DM.DBError );
        exit;
    end;

    // обновляем список документов
    UpdateDocList;
    UpdateFilePreview;

    result := true;
end;


procedure TfProject.menuSaveToPDMClick(Sender: TObject);
{ сохранение рабочей версии в базу.
  данные файла в хранилище обновляются (перезаписываются), минорная версия увеличивается на 1 }
var
    dsDoc: TDataset;
    filename
   ,hash
            : string;
begin
    /// проверка на наличие права взятия документа в работу
    if not mngData.HasRole( ROLE_TAKE_DOC_IN_WORK, WorkgroupID) then
    begin
        ShowMessage('Отсутствует право взятия документа в работу.');
        exit;
    end;

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь редактором объекта для выполнения данной операции.');
        exit;
    end;

    // показываем окно добавления документа в режиме следующей версии (нельзя править путь и имя документа)
    if   not Assigned( fAddDoc )
    then fAddDoc := TfAddDoc.Create(self);

    dsDoc := grdDocs.DataSource.DataSet;

    filename := mngData.GetVersionPath( dsDoc.FieldByName('project_doc_id').AsInteger, true );

    if grdProjectObject.DataSource.Dataset.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не переведен в статус "В работе"');
        exit;
    end;

    if not FileExists(filename) then
    begin
        ShowMessage( lW( 'Рабочий файл версии отсутствует. Сохранение отменено.' + sLineBreak+ '(' + filename + ')'));
        exit;
    end;

    hash := mngFile.GetHash( filename );
    if hash = dsDoc.FieldByName('hash').AsString then
    begin
        ShowMessage( lW( 'В файл ' + ExtractFileName(filename) + ' не внесено изменений. Сохранение отменено.'));
        exit;
    end;


    fAddDoc.object_id   := dsDoc.FieldByName('project_object_id').AsInteger;
    fAddDoc.object_name :=
        '(' + dsDoc.FieldByName('project_object_id').AsString + ') ' +
              dsDoc.FieldByName('obj_name').AsString;
    fAddDoc.filename    := filename;
    fAddDoc.name        := dsDoc.FieldByName('filename').AsString;
    fAddDoc.version_id  := dsDoc.FieldByName('project_doc_id').AsInteger;
    fAddDoc.version     := dsDoc.FieldByName('version').AsString;
//    fAddDoc.doc_type    := dsDoc.FieldByName('document_type_id').AsInteger;
    fAddDoc.mode        := SAVE_MODE_NEW_VERSION; // добавление следующей версии
    fAddDoc.callback    := SaveWorkDocCallback;

    fAddDoc.Show;

end;


function TfProject.SaveWorkDocCallback(object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean;
begin

    result := false;

    if not mngData.UpdateDocumentVersion( version_id ) then
    begin
        ShowMessage( Core.DM.DBError );
        exit;
    end;

    // обновляем список документов
    ShowSubItems;
    UpdateDocList;
    UpdateFilePreview;

    result := true;

end;


// показ карточки объекта в режиме редактирования
procedure TfProject.N10Click(Sender: TObject);
begin
     TfObjectCard.Create(
         self,
         ifthen( mngData.HasRole( ROLE_EDIT_OBJECT, WorkgroupID ) AND mngData.UserIsEditor(grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger) , OBJECT_CARD_MODE_EDIT, OBJECT_CARD_MODE_VIEW),
         ObjectPageCardCallback,
         grdProjectObject.DataSource.DataSet,
         grdDocs.DataSource.DataSet )
     .SetProject( ProjectID )
     .Init
     .AddFile( grdDocs.DataSource.DataSet.FieldByName('fullname').AsString )
     .Show;
end;


procedure TfProject.ObjectPageCardCallback;
/// вызывается после редактирования объекта
begin
    ShowSubitems;
end;


procedure TfProject.menuDeleteFileClick(Sender: TObject);
{ метод удаляет документ (выбранную версию) у выбранного объекта.
  фактически, документ остается в базе, просто скидывается в архив связка с объектом,
  и при выборке за дату, когда связка была актуальна, документ снова будет отображен в списке.

  Алгоритм:
  - удаляем связку самого документа
  - ищем привязанные к нему другие файлы, если он комплексный
      - удаляем связки для них
  - проверяем наличие неудаленных файлов привязанных к данному объекту
  - при нулевом количестве, сбрасываем флаг налиция файла
  -обновляем список документов
}
label ext;
begin
    lC('sbDeleteDocumentClick');

    // перед удалением документа в работе требуется его сохранить или отменить редактирование
    // поскольку это твлияет на то, в каком сотоянии будет отображен этот документ при
    // просмотре данных на указанный момент истории, когда он еще не был удален
    if not grdDocs.DataSource.Dataset.FieldByName('editor_id').IsNull
    then
    begin
        ShowMessage('Удаление невозможно. Завершите работу с версией, для возможности удаления.');
        goto ext;
    end;

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Удалить документ со всеми вложенными (если есть)?',
            'Удаление',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then goto ext;

    if not mngData.DeleteDocumentVersion( grdDocs.DataSource.Dataset.FieldByName('project_doc_id').AsInteger ) then exit;

    // обновляем список файлов
    ShowSubItems;

ext:
    lCE;
end;

procedure TfProject.menuTakeFileToWorkClick(Sender: TObject);
{ забираем файл на редактирование под текущим пользователем. }
label ext;
begin
    lC('TfMain.sbTakeToWorkClick');

    /// проверка на наличие права взятия документа в работу
    if not mngData.HasRole( ROLE_TAKE_DOC_IN_WORK, WorkgroupID) then
    begin
        ShowMessage('Отсутствует право взятия документа в работу.');
        exit;
    end;

    /// проверяем, является ли текущий пользователь редактором
    if not mngData.UserIsEditor( grdProjectObject.DataSource.DataSet.FieldByName('child').AsInteger ) then
    begin
        ShowMessage('Вы не являетесь редактором объекта для выполнения данной операции.');
        exit;
    end;

    // спрашиваем, уверен ли пользователь
    if  Application.MessageBox(
            'Взять документ в работу? Другие пользователи смогут его только просмотреть.',
            'Взять в работу',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then goto ext;

    if grdProjectObject.DataSource.Dataset.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK then
    begin
        ShowMessage('Объект не переведен в статус "В работе"');
        exit;
    end;

    // берем документ в работу
    if mngData.IsInWork( grdDocs.DataSource.DataSet.FieldByName('project_doc_id').AsInteger ) then
    begin
        ShowMessage('Документ уже в работе!');
        exit;
    end;

    /// создаем рабочую копию
    if not mngData.TakeDocumentToWork( grdDocs.DataSource.DataSet.FieldByName('project_doc_id').AsInteger ) then
    begin
        ShowMessage( Core.DM.DBError );
        goto ext;
    end;

    // обновляем список документов
    ShowSubItems;

ext:
    lCE;
end;

// показ карточки объекта в режиме создания нового
procedure TfProject.sbAddObjectClick(Sender: TObject);
begin
    if not mngData.HasRole( ROLE_ADD_OBJECT, WorkgroupID ) then
    begin
        ShowMessage('Не установлено право добавления объектов.');
        exit;
    end;

    if not assigned(wndObjectCard)
    then
        wndObjectCard :=
            TfObjectCard.Create( self, OBJECT_CARD_MODE_CREATE, ObjectCreateCallback )
                .SetProject( ProjectID )
                .SetTreeDS( gridProjectTree.DataSource.DataSet )
    else
        wndObjectCard.BringToFront;

    wndObjectCard.Show;
end;
procedure TfProject.sbLoadSpecClick(Sender: TObject);
begin

    // при наличии выделенного элемента загрузить специфификацию можно только для исполнения
    if ( gridProjectTree.DataSource.DataSet.Active ) and
       ( gridProjectTree.DataSource.DataSet.RecordCount > 0 ) and
       ( gridProjectTree.DataSource.DataSet.FieldByName('mem_icon').AsInteger <> KIND_ISPOLN )
    then
    begin
        ShowMessage('Спецификация может быть загружена только для исполнения.');
        exit;
    end;

    if ( gridProjectTree.DataSource.DataSet.Active ) and
       ( gridProjectTree.DataSource.DataSet.RecordCount > 0 ) and
       ( gridProjectTree.DataSource.DataSet.FieldByName('status').AsInteger <> STATE_PROJECT_INWORK )
    then
    begin
        ShowMessage('Спецификация не находится в режиме редактирования.');
        exit;
    end;



    /// не закрытую форму импорта просто вываливаем пользователю
    if assigned(wndLoadSpec) and wndLoadSpec.Visible then
    begin
        wndLoadSpec.BringToFront;
        exit;
    end;

    /// закрытую после импорта форму грохаем, чтобы проинициализировать снова
    if assigned(wndLoadSpec) and not wndLoadSpec.Visible then
    begin
        wndLoadSpec.Free;
        wndLoadSpec := nil;
    end;



    // при выбранном исполнении запускаем в режиме ограниченной загрузки (только
    // одного конкретного исполнения для выделенного объекта
    if ( gridProjectTree.DataSource.DataSet.Active ) and
       ( gridProjectTree.DataSource.DataSet.RecordCount > 0 ) and
       ( gridProjectTree.DataSource.DataSet.FieldByName('mem_icon').AsInteger = KIND_ISPOLN )
    then
    begin
{        // спрашиваем, уверен ли пользователь
        if  Application.MessageBox(
                PChar('Загрузить спецификацию для объекта ' + gridProjectTree.DataSource.DataSet.FieldByName('mark').AsString + '?'),
                'Импорт спецификации',
                MB_YESNO + MB_ICONQUESTION
            ) = ID_NO
        then exit;
}
        wndLoadSpec :=
        TFLoadSpec.Create(self)
            .setParentObject(
                 gridProjectTree.DataSource.DataSet.FieldByName('mem_mark').AsString,
                 gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger
             )
            .setProjectId( ProjectID )
            .setCallback( SpecLoadCallback );

        wndLoadSpec.Show;
    end
    else
    begin
        wndLoadSpec :=
        TFLoadSpec.Create(self)
            .setProjectId( ProjectID )
            .setCallback( SpecLoadCallback );
        wndLoadSpec.Show;
    end;
end;

procedure TfProject.SpecLoadCallback;
begin
    mngData.UpdateProjectMark( ProjectID );
    mngProjectTree.Refresh( fRoots, fRootsInclude );
    mngProjectTree.FullExpand;
    ShowSubitems;
end;

procedure TfProject.SpeedButton3Click(Sender: TObject);
begin

    if Assigned(wndSpecTreeFree) AND wndSpecTreeFree.Visible = false then
    begin
        wndSpecTreeFree.Free;
        wndSpecTreeFree := nil;
    end;

    if not Assigned(wndSpecTreeFree)
    then
        wndSpecTreeFree :=
            TfSpecTreeFree
                .Create(self, VIEW_PROJECT_STRUCTURE)
                .SetRootId( ProjectID )
    else
        wndSpecTreeFree.BringToFront;

    wndSpecTreeFree.Show;

end;

procedure TfProject.timerCheckRoleTimer(Sender: TObject);
begin
    CheckRole;
end;


procedure TfProject.sbObjectToReadyClick(Sender: TObject);
begin
end;

/// вызывается после создания нового объекта
procedure TfProject.ObjectCreateCallback;
begin
    mngProjectTree.Refresh( fRoots, fRootsInclude );
    mngProjectTree.Expand;
    UpdateDocList;
end;

procedure TfProject.sbShowObjectCatalogClick(Sender: TObject);
begin
    if not Assigned( wndObjectCatalog )
    then
        wndObjectCatalog := TfObjectCatalog.Create(self).setProject(ProjectID, ProjectName, ProjectMark)
    else
        wndObjectCatalog.BringToFront;

    wndObjectCatalog.Show;
end;

procedure TfProject.sbShowUsersClick(Sender: TObject);
begin
    if not Assigned(wndUserList)
    then
        wndUserList := TfUserList.Create(self).SetProjectId(ProjectID).SetWorkgroupId(WorkgroupID)
    else
        wndUserList.BringToFront;

    wndUserList.Show;
end;

procedure TfProject.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // на закрытие формы закрываем все подчиненные
    if Assigned(wndObjectCatalog) then wndObjectCatalog.Close;
    if Assigned(wndUserList) then wndUserList.Close;
    if Assigned(wndObjectCard) then wndObjectCard.Close;
    if Assigned(wndLoadSpec) then wndLoadSpec.Close;
    if Assigned(wndSpecTreeFree) then wndSpecTreeFree.Close;

    if (owner is TfMain) then (owner as TfMain).ClearProjectWndLink(self);

end;


procedure TfProject.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   is_ctrl := ssCtrl in Shift;
   is_alt := ssAlt in Shift;
end;

procedure TfProject.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   is_ctrl := ssCtrl in Shift;
   is_alt := ssAlt in Shift;
end;

procedure TfProject.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if fDropedFile <> '' then showmessage('up!');
end;

procedure TfProject.N1Click(Sender: TObject);
begin
    if not gridProjectTree.DataSource.DataSet.Active and
      (gridProjectTree.DataSource.DataSet.RecordCount = 0) and
      (gridProjectTree.DataSource.DataSet.RecNo < 0)
    then exit;

    // проверка возможности удаления связки исходя из наличия ролей
    if not mngData.HasRole( ROLE_UNLINK_FROM_STRUCTURE, WorkgroupID ) then
    begin
        ShowMessage('Отсутствует право удаления объектов из структуры.');
        exit;
    end;

    /// тонкость удаления в том, что это изменение состава родительского объекта
    /// и требуется проверка на доступ его редактирования текущим пользователем
    if not mngData.UserIsEditor( gridProjectTree.DataSource.DataSet.FieldByName('mem_parent').AsInteger ) then
    begin
        ShowMessage('Пользователь не является редактором родительского объекта.');
        exit;
    end;

    mngData.DeleteLink( LNK_PROJECT_STRUCTURE, gridProjectTree.DataSource.DataSet.FieldByName('mem_aChild').AsInteger, DEL_MODE_SINGLE );

    mngProjectTree.Refresh( fRoots, fRootsInclude );
end;

procedure TfProject.N4Click(Sender: TObject);
var
    error : string;
begin
    if not gridProjectTree.DataSource.DataSet.Active or ( gridProjectTree.DataSource.DataSet.RecordCount = 0 ) then exit;

    error := '';

    /// отсекаем выгрузку корневой спецификации данным образом (только через завершение проекта)
    if error = '' then
    if gridProjectTree.DataSource.DataSet.FieldByName('mem_parent').AsInteger = ProjectID
    then error := 'Коневую спецификацию можно выгрузить в КД только через завершение проекта.';

    /// проверяем, что объект в состоянии готовности
    if error = '' then
    if gridProjectTree.DataSource.DataSet.FieldByName('status').AsInteger <> STATE_PROJECT_READY
    then error := 'Операция проводится только позиций в статусе "Готово"';

    /// проверяем, что у объекта нет потомков в работе, на проверке или не взятые в работу
    if error = '' then
    if not mngData.ObjectIsReady( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger )
    then error := 'Содержит объекты в разработке, проверке или не взятые в работу. Операция не допустима';

    /// проверяем, что пользователь имеет право заливать объект в КД
    if error = '' then
    if not mngData.HasRole( ROLE_DONE_PROJECT, WorkgroupID)
    then error := 'Пользователь не имеет права выгрузки позиций в КД';

    if error <> '' then
    begin
        ShowMessage( error );
        exit;
    end;

    if mngData.DoneProject( gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger ) then
    begin
        mngProjectTree.Refresh( fRoots, fRootsInclude );
        ShowSubitems;
    end;

end;




////////////////////////////////////////////////////////////////////////////////
/// механизм перетаскивания документов из проводника в дерево проекта
///
/// при захвате файла в проводнике и перетаскивании его на компонент дерева ожидается
/// отпускание клавиши мыши.
/// в этот момент
////////////////////////////////////////////////////////////////////////////////

procedure TfProject.FormCreate(Sender: TObject);
begin
    DragAcceptFiles(Self.Handle, True);
end;

procedure TfProject.FormDestroy(Sender: TObject);
begin
    DragAcceptFiles(Self.Handle, False);
end;

procedure TfProject.WMDropFiles(var Msg: TWMDropFiles);
/// на примере статьи:
/// https://habr.com/ru/post/179131/
var
  Catcher: TFileCatcher;
  ctrl: TControl;
  point : TPoint;
begin

  inherited;

  fDropedFile := '';
  Catcher := TFileCatcher.Create(Msg.Drop);

  try

    if Catcher.FileCount = 0 then
    begin
        ShowMessage('Файл не выбран.');
    end else
    if Catcher.FileCount > 1 then
    begin
        ShowMessage('Выберите только один файл.');
    end else

    // берем только один первый файл, поскольку основным может быть только один
    if   Catcher.FileCount = 1 then
    begin
        if  (GetFileAttributes( PChar(Catcher.Files[0]) ) and FILE_ATTRIBUTE_DIRECTORY) <> 0
        then ShowMessage('Выберите файл, а не директорию.')
        else
            if ExtractFileExt(ExtractFileName(Catcher.Files[0])) = '.lnk'
            then ShowMessage('Выберите файл, а не ярлык.')
            else fDropedFile := Catcher.Files[0];
    end;

  finally
    Catcher.Free;
  end;

  // сообщаем Windows, что сообщение обработано
  Msg.Result := 0;

  if fDropedFile <> '' then
  begin
      /// получаем координаты в рамках экрана
      GetCursorPos(point);

      /// имитируем клик по форме, что вызовет обработчик компонента над
      /// которым файл брошен, а непустое значение fDropedFile будет признаком
      /// того, что это перетаскивание, а не обычный клик
      mouse_event(MOUSEEVENTF_LEFTDOWN, Point.X, Point.y, 0, 0);
      mouse_event(MOUSEEVENTF_LEFTUP, Point.X, Point.y, 0, 0);
  end;
end;

procedure TfProject.ImportFileToObject;
/// обработка перетаскивания файла из проводника в список документов текущего объекта
/// в момент вызова метода активирована запись объекта на который был
/// перемещен файл и его имя содержится в переменной fDropedFile
begin
    lM('ImportFileToObject ' + fDropedFile);

    /// проверяем наличие выбранного объекта

    /// проверяем наличие прав

    /// привязываем документ к объекту

    fDropedFile := '';
end;

procedure TfProject.ImportFileToProject;
/// обработка перетаскивания файла из проводника на дерево проекта
/// в момент вызова метода активирована запись объекта на который был
/// перемещен файл и его имя содержится в переменной fDropedFile
///
/// для начала определяем тип файла по расширению, чтобы решить что с ним делать
///  - для спеификации вызываем инициализированный режим импорта спецификации
///  - для чертежа открываем заполненый диалог создания объекта, если не существует
///  - автоматом привязываем объект, если такой существует в КД или проекте
var
    ext               // расширение брошенного из проводника файла
   ,mark              // обозначение объекта из файла
   ,kind
   ,_kind
   ,f
   ,error
            : string;
    id
   ,_id
            : integer;

begin
    lM('[ImportFileToProject] file: ' + fDropedFile);

    /// для облегчения аглоритма, глобальную переменную сбрасываем сразу, как
    /// обработанную, чтобы не делать это в каждой успешной ветке
    f := fDropedFile;
    fDropedFile := '';

    error := '';

    if ( not gridProjectTree.DataSource.DataSet.Active) or
       (gridProjectTree.DataSource.DataSet.RecordCount = 0)
    then error := 'Структура проекта пуста. Новый объект не может быть привязан.';

    /// проверяем наличие прав
    if error = '' then
    if not mngData.UserIsEditor(gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger)
       and not mngData.HasRole( ROLE_OBJECT_TO_WORK_PERSONALY, WorkgroupID )
    then error := 'Объект-родитель не находится в работе текущего пользователя и не может быть взять в работу автоматически.';

    if error <> '' then
    begin
        ShowMessage(lW( error ));
        exit;
    end;

    /// автоматом привязываем пользователя редактором
    if not mngData.UserIsEditor(gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger)
       and mngData.HasRole( ROLE_OBJECT_TO_WORK_PERSONALY, WorkgroupID )
    then mngData.LinkEditorToObject(
        gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger,
        CORE.User.id,
        ProjectID
    );

    /// проверяем тип документа
    ext := AnsiUpperCase( ExtractFileExt( ExtractFileName( f )));
    if (ext <> '.SPW') and (ext <> '.CDW') then
    begin
        ShowMessage(lW(
             ExtractFileName( f ) + ' не является файлом КОМПАС '+sLineBreak+
            'и не может быть включен в структуру проекта'));
        exit;
    end;

    /// получаем его обозначение
    if not  mngKompas.Init( f ) then
    begin
        ShowMessage( mngKompas.error );
        exit;
    end;

    mark := mngKompas.GetStampData( FIELD_MARK );

    lM('[ImportFileToProject] mark из файла: ' + mark);

    /// для чертежа
    if (ext = '.CDW') then
    begin
        lM('[ImportFileToProject] ищем объект в проекте...');

        /// ищем совпадения в проекте, при наличии - привязываем
        id := mngData.GetProjectObjectPresent( ProjectID, mark );  // получаем объект

        /// ищем совпадения в КД и копируем в проект при наличии и привязываем
        if id = 0 then
        begin
            lM('[ImportFileToProject] ищем объект в КД...');

            // получаем объект
            id := mngData.GetObjectBy('mark', mark, '');

            if id > 0 then
            begin
                lM('[ImportFileToProject] объект найден в КД: ' + IntToStr(id));

                /// копируем в проект
                id := mngData.CopyObjectToProject( ProjectID, gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger, id );

                lM('[ImportFileToProject] скопирован в проект как : ' + IntToStr(id));

            end;
        end;

        /// объект в проекте найден или только что скопирован
        if id < 0 then
        begin
            lM('[ImportFileToProject] объект найден в проекте: ' + IntToStr(id));

            /// привязываем его
            _id := mngData.AddLink(
                LNK_PROJECT_STRUCTURE,
                gridProjectTree.DataSource.DataSet.FieldByName('mem_child').AsInteger,
                id
            );

            lM('[ImportFileToProject] добавлена связка: ' + IntToStr(_id));

            mngData.CreateCrossLinks(
                LNK_PROJECT_STRUCTURE,
                _id
            );

            mngProjectTree.Refresh( fRoots, fRootsInclude );

            exit;
        end;


        /// если дошли до сюда, объект не сущетвует ни в кроекте, ни в КД
        /// запускаем карточку создания с заполненными из файла
        /// полями и привязанным документом
        lM('[ImportFileToProject] объект не существует, инифиализация формы создания нового...');

        if not assigned(wndObjectCard)
        then
            wndObjectCard :=
                TfObjectCard.Create( self, OBJECT_CARD_MODE_CREATE, ObjectCreateCallback )
                    .SetProject( ProjectID )
                    .SetTreeDS( gridProjectTree.DataSource.DataSet )
        else
            wndObjectCard.BringToFront;

        // заполняем поля известной информацией
        wndObjectCard.pKind     := -1;
        wndObjectCard.pIcon     := -1;
        wndObjectCard.pName     := mngKompas.GetStampData( FIELD_NAME );
        wndObjectCard.pMark     := mngKompas.GetStampData( FIELD_MARK );
        wndObjectCard.pMaterial := mngData.GetObjectBy('name', mngKompas.GetStampData( FIELD_MATERIAL ), '');
        wndObjectCard.pMass     := mngKompas.GetStampData( FIELD_MASS );
        wndObjectCard.pComment  := mngKompas.GetStampData( FIELD_COMMENT );

        wndObjectCard.pFileName := f;
        wndObjectCard.pFileKind := mngFile.GetFileType( ExtractFileExt( ExtractFileName( f ) ) );

        wndObjectCard.AddFile( f );
        wndObjectCard.Show;

        exit;
    end;

    /// для спецификации
    if (ext = '.SPW') then
    begin

        if not mngData.HasRole( ROLE_LOAD_SPECIFICATION, WorkgroupID ) then
        begin
            ShowMessage(lW('Отсутствует право загрузки спецификации'));
            exit;
        end;

        /// отрабатываем проверки и показ формы загрузки спецификации
        sbLoadSpec.Click;

        /// если форма успешно проинициализирована
        if assigned(wndLoadSpec) then
        begin
            wndLoadSpec.SetFile( f );
            wndLoadSpec.LoadSpecData;
        end;
    end;

end;

end.
