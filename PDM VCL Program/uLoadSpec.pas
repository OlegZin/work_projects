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
    /// обозначение элемента в дереве проекта для которого будем грузить спецификацию
    fParentID : integer;
    /// обозначение элемента в дереве проекта для которого будем грузить спецификацию

    /// при установке данных переменных, загрузка производится в ограниченном режиме
    /// при выборе спецификации проводится проверка на соответствие выбранному в дереве
    /// спецификации. но это не ограничение, а рекомендация сообщением пользователю

    fProjectID : integer;

    function UploadToProject: boolean;
  public
    error : string;
    /// последняя произошедшая ошибка

    fCallback : TCallback;
    /// метод, вызываемый при успешной выгрузке в проект, перед закрытием формы

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
    /// текущий путь до выбранной спецификации

procedure TfLoadSpec.FormCreate(Sender: TObject);
begin
//    panel1.Height := panel2.top;    // скрываем пенель опций
    mngKompas.SetupMemtable( MemTable );
end;

procedure TfLoadSpec.sbLoadSpecClick(Sender: TObject);
var
   mask : string;
begin

    // спрашиваем, уверен ли пользователь
    if fParentMark <> '' then
    if  Application.MessageBox(
            PChar('Номер исполнения ' + eIspol.Text + ' указан верно?'),
            'Номер исполнения',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    sbToProject.Enabled := false;

    mngKompas.sSetLogMemo( mLog );

    /// сбрасываем ранее загруженные данные
    mngKompas.CleanUp;
    MemTable.EmptyTable;

    /// получаем список директорий, в которых будем искать дополнительные файлы
    /// спецификаций и чертежей для элементов загружаемой спецификации
    case rgrpDirFilter.ItemIndex of
       0 : mask := '*';                // в текущей и вложенных папках
       1 : mask := '';                 // в текущей папке
       2 : mask := eMask.Text          // по маске
    end;

    if not mngKompas.ScanFiles( lbRootDir.Items.CommaText, mask, ePassMask.Text ) then
    begin
        ShowMessage( mngKompas.error );
        exit;
    end;

    /// извлекаем xml файл с описанием спецификации и инициализируем внутренние объекты для работы
    if not mngKompas.Init( currSpecPath ) then
    begin
        ShowMessage( mngKompas.error );
        exit;
    end;

    /// загружаем данные из xml в рабочий массив
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

    OpenDialog.Filter := 'Спецификация|*.spw';

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

    // вызываем внешний метод для обработки успешной выгрузки в проект
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

    // удаляем устаревший путь, если был
    lbRootDir.Items.Delete( lbRootDir.Items.IndexOf( ExtractFilePath(currSpecPath)) );

    // добавляем путь до текущей спецификации
    if lbRootDir.Items.IndexOf( ExtractFilePath( filename ) ) = -1 then
    lbRootDir.Items.Add( ExtractFilePath( filename ) );

    currSpecPath := filename;
end;

function TfLoadSpec.setParentObject(mark: string; id: integer): TfLoadSpec;
begin
    self.Caption := 'Загрузка спецификации для ' + mark;
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
    OpenDialog.Filter := 'Все файлы|*.*';

    // выбор директории через любой файл в ней
    // не совсем красиво, но позволяет лазить по сети
    if OpenDialog.Execute then
    if lbRootDir.Items.IndexOf( ExtractFilePath(OpenDialog.FileName) ) = -1 then
    lbRootDir.Items.Add( ExtractFilePath(OpenDialog.FileName) );

{   // системный метод выбора директории не позволяет выйти в сеть.
    // поддерживает только явно подключенные сетевые диски
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
/// метод загрузки импортированной спецификации в проект.
///
/// * объекты уже проверены по наличию и поле bd_id содержит:
///    bd_id > 0 - объект уже существует в согласованой структуре. в таблице [object]
///    bd_id < 0 - объект уже есть в текущем проекте. в таблице [project_object]
///    bd_id = 0 - объект не содержится в базе
///
/// АЛГОРИТМ
/// - перебираем строки в memtable
///     - при bd_id > 0 копируем объект в проект, пишем в bd_id проектный id
///     - при bd_id < 0 игнорируем. здесь порядок
///     - при bd_id = 0 создаем объект в проекте и пишем bd_id проектный id
/// - снова перебираем строки memtable
///     - получаем bd_id элемента
///     - дополнительным перебором получаем parent.bd_id объекта
///     - создаем связь между parent и child по их bd_id
///     - сохраняем id созданной ссылки в массиве для дальнейшей обработки
/// - перебираем массив с id связей
///     - создаем допсвязи для каждой.
///       это не сделано сразу, поскольку требуется завершенная структура основных
///       связей, чтобы не было попыток отстроить допсвязи для связки, которая
///       еще не привязана к корню структуры через родителей.
/// - для режима импорта основной спецификации (проект пуст), корневой элемент привязываем к
///   проекту, чтобы отобразить струкутуру в окне проекта
/// - для режима загрузки дополнительной спецификации (частичная загрузка по
///   указанному исполнению), пропускаем этот этап, покольку корневой элемент уже
///   привязан к структуре проекта. режим определяется по fParentID <> 0
/// - обновляем все таблицы вкладки структуры проекта
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

        // если связка уже есть, не создаем новую
        link := mngData.PresentLink( parent, child, LNK_PROJECT_STRUCTURE );
        if link = 0
        then link := mngData.AddLink( LNK_PROJECT_STRUCTURE, parent, child );

        if link = 0 then exit;

        // запоминаем в списке созданных связей на пересоздание.
        // хоть такая связка уже и есть, но у нее теперь есть дополнительный родитель
        // на верхних уровнях и без пересоздания, для этого родителя не будет данных в таблице допсвязей
        // для показа списка входящих в него элементов
        SetLength(links, Length(links)+1);
        links[high(links)] := link;

        mngData.UpdateLink( LNK_PROJECT_STRUCTURE, links[high(links)], ['count'], [count] );
    end;

    function GetFromCopied( id: integer ): integer;
    /// ищем среди ранее скопированных из КД объектов и возвращаем id в проекте
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

    /// создаем и копируем объекты
    MemTable.First;
    while not MemTable.Eof and result do
    begin

        /// сразу проверки на наличие привязки объекта типа деталь, материал, стандатное изделие
        /// к справочнику материалов. пропускаем при импорте, если нет привязки


        /// поле [bd_id] содержит значение, указывающее на наличие объекта в базе
        /// при значении >0 объект содержится в согласованной структуре, но не в проекте
        /// при значении <0 объект содержится в в проекте и, возможно, в согласованной структуре
        /// при значении =0 объекта в базе не существует и его нужно добавить
        ///
        /// тонкость заключается в том, что в проект не нужно добавлять объекты,
        /// которые там уже есть ( при [bd_id]<0 ), но может быть, что объект в
        /// проекте уже есть, но привязывается к другому элементу, например, в
        /// другом исполнении. данный случай можно отследить только при раздаче связей.
        /// потому, смело заливаем даже существующий в проекте объект в массив ids

        /// объект в согласованой структуре
        if ( MemTable.FieldByName('bd_id').AsInteger > 0 ) then
        begin
            try

                bd_id := MemTable.FieldByName('bd_id').AsInteger;

                // пытаемся найти в массиве уже скопированных объектов, чтобы избежать дублей
                project_id := GetFromCopied( bd_id );

                // дублей нет - создаем
                if project_id = 0 then
                begin
                    project_id := mngData.CopyObject( MemTable.FieldByName('bd_id').AsInteger, 0, TBL_OBJECT, TBL_PROJECT);

                    // запоминаем для дальнейшего отслеживания дублей
                    SetLength(copied, Length(copied)+1);
                    copied[high(copied)].bd_id := bd_id;
                    copied[high(copied)].project_id := project_id;
                end;

                /// копируем в таблицу проектов
                MemTable.Edit;
                MemTable.FieldByName('bd_id').Value := project_id;
                MemTable.Post;

                /// создаем запись в таблице допданных
                if mngData.AddObject(
                    'original_id, parent, project_id',
                    [ bd_id, MemTable.FieldByName('bd_id').Value, fProjectID ],
                    TBL_PROJECT_OBJECT_EXTRA,
                    true                                       // создание без системнх допполей
                ) = 0 then
                    result := false;


                /// для документа указываем ссылку на копию в проекте
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

        /// объект не существует
        if MemTable.FieldByName('bd_id').AsInteger = 0 then
        begin
            try
                /// создаем в таблице проектов
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

                /// создаем запись с допданными, сразу ставим признак, разрешающий брать в работу
                if mngData.AddObject(
                    'original_id, parent, status, project_id',
                    [ 0, MemTable.FieldByName('bd_id').Value, PROJECT_OBJECT_VIEW, fProjectID ],
                    TBL_PROJECT_OBJECT_EXTRA,
                    true                                       // создание без системнх допполей
                ) = 0 then
                    result := false;

                /// если есть привязанный файл, заливаем его в базу
                if ( MemTable.FieldByName('linked_file').AsString <> '' ) and
                   FileExists( MemTable.FieldByName('linked_file').AsString )
                then
                begin
                    /// создаем документ
                    doc_id := mngData.CreateDocumentVersion(
                        MemTable.FieldByName('bd_id').AsInteger,                        // объект-владелец документа
                        0,                                                              // предыдущая версия
                        2,                                                              // тип из спраовочника [DOCUMENT_TYPE]
                        ExtractFilename( MemTable.FieldByName('linked_file').AsString ),// имя для пользователя
                        MemTable.FieldByName('linked_file').AsString,                   // фактическое имя файла + путь
                        ''                                                              // комментарий
                    );

                    /// проставляем ризнак принадлежности к проекту
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


    /// создаем связи
    if result then
    for I := 0 to High(ids) do
    if  // элемент не корневой
        ( ids[i].parent <> 0 )
    then
        begin
            // ищем bd_id родителя
            if result then
            for j := 0 to High(ids) do
            if ids[i].parent = ids[j].child
            then
                AddLink( ids[j].bd_id, ids[i].bd_id, ids[i].count );
        end
    else
        begin
            // корневой элемент, но родитель определен
            // привязываем к указанному родителю
            if (ids[i].parent = 0) and ( fParentID <>  0)
            then
                AddLink( fParentID, ids[i].bd_id, ids[i].count );

            // или корневой, но загружается базовая спецификация
            // привязываем к корню проекта
            if ( fParentID = 0 )
            then
                AddLink( fProjectID, ids[i].bd_id, ids[i].count );
        end;




    /// создаем допсвязи, которые позволяют делать быструю выборку всех элементов
    /// дерева, вложенных в текущий узел
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
