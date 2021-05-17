unit uObjectCatalog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.Buttons, Vcl.StdCtrls, EhLibVCL, GridsEh,
  DBAxisGridsEh, DBGridEh, Vcl.ExtCtrls, uMain, Data.DB, StrUtils, Vcl.Menus,
  System.ImageList, Vcl.ImgList, uSpecTreeFree;

type
  TfObjectCatalog = class(TForm)
    Panel1: TPanel;
    grdCatalogObjects: TDBGridEh;
    Panel2: TPanel;
    sbKindDocument: TSpeedButton;
    sbKindMaterial: TSpeedButton;
    sbKindDetail: TSpeedButton;
    sbKindStandart: TSpeedButton;
    sbKindOther: TSpeedButton;
    sbKindAssembly: TSpeedButton;
    sbKindKomplect: TSpeedButton;
    sbKindKomplex: TSpeedButton;
    sbKindSection: TSpeedButton;
    sbKindSpecification: TSpeedButton;
    sbKindExecution: TSpeedButton;
    sbAddObject: TSpeedButton;
    popFilter: TPopupMenu;
    menuShowAll: TMenuItem;
    menyShowItOnly: TMenuItem;
    listProjectMark: TImageList;
    sbKindProject: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure grdCatalogObjectsApplyFilter(Sender: TObject);
    procedure grdCatalogObjectsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdCatalogObjectsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbAddObjectClick(Sender: TObject);
    procedure sbKindSectionClick(Sender: TObject);
    procedure menuShowAllClick(Sender: TObject);
    procedure menyShowItOnlyClick(Sender: TObject);
    procedure sbKindSectionMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdCatalogObjectsCellClick(Column: TColumnEh);
    procedure grdCatalogObjectsSelectionChanged(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private

    popOwner : TSpeedButton;
    wndSpecTreeFree : TfSpecTreeFree;
    fSQL : string;

    procedure SetEmptyFilter;
        // устанавливает полное отображение элементов фильтром
    procedure SetFullFilter;
        // устанавливает полную фильтрацию (нет отображаемых элементов)
    procedure UpdateFilterElem( kind: integer; mode: boolean );
        // позволяет установить или сбросить элемент фильтра
    function GetKindFilterPart: string;
    procedure RefreshDSFilter;
    function GetSQL: string;
  public
    ProjectId: integer;
        // если = -1, значит содержит реальные данные из таблицы [object]
        // если = 0, значит показывает все объекты, созданные в рамках всех проектов
        // если > 0, значит содержит объекты созданные в рамках
        // указанного проекта

        // так же, при drag`n`drop с этой формы, получатель получает информацию
        // о типе содержащихся данных
    ProjectName
   ,ProjectMark
          : string;

    { Public declarations }
    constructor create(owner: TComponent); overload;
    function setProject( p_id: integer; p_name, p_mark: string ): TfObjectCatalog;
    function SetFilter( kinds: array of integer ): TfObjectCatalog;
    function SetSQL( sql: string ): TfObjectCatalog;
    procedure Refresh;
    procedure RefreshData(filter: string = '');
    procedure ClearCardLink;
    procedure ClearStructLink;
  end;

var
  fObjectCatalog: TfObjectCatalog;

implementation

{$R *.dfm}

uses
    uPhenixCore, uConstants, uDatatableManager, uObjectCard, uDataManager;

var
    arrKindFilter: array of integer;
    /// содержит массив текущих активных фильтров по типам (включеных)
    /// если тип есть в массиве, он НЕ отображается в списке объектов
    /// пустой массив означает показ всех типов объектов
    /// стстояние массива зависит от нажатия кнопок фильтра

    /// при выборке объектов используется "kind not in (х,y,z,..)", где
    /// х,y,z,.. - значения дпнного массива

    /// динамический массив применяется для того, чтобы не привязываться к
    /// текущему набору типов и количеству кнопок фильтров, и не заниматься
    /// тупым обращением к компонентам. универсальный обработчик нажатия
    /// кнопки позволит вводить любое количество типов с минимальным измением кода

    wndCard: TfObjectCard;

procedure TfObjectCatalog.ClearCardLink;
begin
    wndCard := nil;
end;

procedure TfObjectCatalog.ClearStructLink;
begin
    wndSpecTreeFree := nil;
end;

constructor TfObjectCatalog.create(owner: TComponent);
begin
  inherited Create(owner);
  ProjectID := -1;
  grdCatalogObjects.Tag := -1;
end;

procedure TfObjectCatalog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if assigned(wndCard) then wndCard.Free;
    if assigned(wndSpecTreeFree) then wndSpecTreeFree.Free;
end;

procedure TfObjectCatalog.FormCreate(Sender: TObject);
var
    i : integer;
    filter : string;
begin
    grdCatalogObjects.DataSource := TDataSource.Create(self);

    wndCard := nil;

    RefreshData;

    mngDatatable.ConfigureForFilter( grdCatalogObjects, [0, 1] );
    mngDatatable.ConfigureForSorting( grdCatalogObjects, [] );

    // принудителдьно прописываем типы, к которым привязаны кнопки
    // при сборе строки фильтра, будут подсталяться эти значения
    sbKindSection.Tag       := KIND_SECTION;
    sbKindDocument.Tag      := KIND_DOCUMENT;
    sbKindMaterial.Tag      := KIND_MATERIAL;
    sbKindDetail.Tag        := KIND_DETAIL;
    sbKindStandart.Tag      := KIND_STANDART;
    sbKindOther.Tag         := KIND_OTHER;
    sbKindAssembly.Tag      := KIND_ASSEMBL;
    sbKindKomplect.Tag      := KIND_COMPLECT;
    sbKindKomplex.Tag       := KIND_COMPLEX;
    sbKindSpecification.Tag := KIND_SPECIF;
    sbKindExecution.Tag     := KIND_ISPOLN;
    sbKindProject.Tag       := KIND_PROJECT;

    // выставляем фильтр на показ всех элементов
    SetEmptyFilter;

end;

function TfObjectCatalog.GetKindFilterPart: string;
var
   i : integer;
   comma, kinds : string;
begin
    comma := '';
    result := '';
    kinds := '';

    for I := 0 to High(arrKindFilter) do
    begin
        kinds := kinds + comma + '( kind = ' + IntToStr(arrKindFilter[i]) + ' ) ';
        comma := ' OR ';
    end;

    result := kinds;

end;

function TfObjectCatalog.GetSQL: string;
var
   filter: string;
begin

    if fSQL = '' then
    begin
        filter := mngDatatable.GetFilterByColumns( grdCatalogObjects, GetKindFilterPart );
        result :=
            'SELECT TOP 100 *, 0 as project FROM '+ TBL_OBJECT + ifthen(filter <> '', ' WHERE '+filter, '') +
            ' UNION ' +
            'SELECT TOP 100 *, 1 as project FROM '+ TBL_PROJECT + ifthen(filter <> '', ' WHERE '+filter, '')
    end else
       result := fSQL;

end;

procedure TfObjectCatalog.grdCatalogObjectsApplyFilter(Sender: TObject);
begin
    RefreshDSFilter;
end;


procedure TfObjectCatalog.grdCatalogObjectsCellClick(Column: TColumnEh);
begin
    if Assigned(wndCard) then wndCard.Init;

    if Assigned(wndSpecTreeFree) then
        wndSpecTreeFree
            .SetRootId( grdCatalogObjects.DataSource.DataSet.FieldByName('id').AsInteger )
            .Refresh;
end;

procedure TfObjectCatalog.sbAddObjectClick(Sender: TObject);
/// показ карточки объекта в режиме просмотра
begin
    if   not assigned(wndCard)
    then
        wndCard := TfObjectCard.Create(self, OBJECT_CARD_MODE_VIEW, Refresh, grdCatalogObjects.DataSource.DataSet).Init
    else
        wndCard.BringToFront;

    wndCard.Show;
end;

function TfObjectCatalog.SetFilter(kinds: array of integer): TfObjectCatalog;
/// установка текущей фильтрации по типам объектов и обновление списка
/// применяется внешними процессами, которым требуется установить режим
/// фильтрации при показе справочника
/// kinds - содержат типы, которые должны быть отображены
var
    i: integer;
begin
    result := self;

    // блокируем показ всех элементов
    SetFullFilter;

    // добавляем типы, которые отобразить
    for i := 0 to High(kinds) do
       UpdateFilterElem( kinds[i], true );

    RefreshDSFilter;
end;

procedure TfObjectCatalog.SetFullFilter;
var
    i: integer;
begin
    SetLength( arrKindFilter, 0 );

    for i := 0 to self.ComponentCount-1 do
    if (self.Components[i] is TSpeedButton) and
       ( TSpeedButton(self.Components[i]).Tag <> 0 )
    // у кнопки фильтра в tag зашит тип объекта из таблицы [object_classificator].[kind]
    then
        TSpeedButton(self.Components[i]).Down := false;
end;

function TfObjectCatalog.setProject(p_id: integer; p_name,
  p_mark: string): TfObjectCatalog;
begin
  ProjectID := -1;
  ProjectName := p_name;
  ProjectMark := p_mark;
  grdCatalogObjects.Tag := -1;

  self.Caption := 'Справочник объектов. [ ' + ProjectName + ' ' + ProjectMark + ' ]';

  result := self;
end;

function TfObjectCatalog.SetSQL(sql: string): TfObjectCatalog;
begin
    result := self;
    fSQL := sql;
end;

procedure TfObjectCatalog.SpeedButton3Click(Sender: TObject);
begin
    if not grdCatalogObjects.DataSource.DataSet.Active or
       (grdCatalogObjects.DataSource.DataSet.RecordCount = 0) then
    begin
        ShowMessage('Отсутствует объект для отображения данных');
        exit;
    end;


    if not Assigned(wndSpecTreeFree)
    then
        wndSpecTreeFree :=
            TfSpecTreeFree
                .Create(self, VIEW_OBJECT)
                .SetRootId( grdCatalogObjects.DataSource.DataSet.FieldByName('id').AsInteger )
    else
        wndSpecTreeFree.BringToFront;

    wndSpecTreeFree.Show;

end;

procedure TfObjectCatalog.SetEmptyFilter;
/// метод заполняет массив всеми типами объектов и нажимает все кнопки фильтра
/// позволяет после этого модифицировать выборку, выборочно удаляя элементы
var
    i: integer;
begin
    SetLength( arrKindFilter, 0 );

    for i := 0 to self.ComponentCount-1 do
    if (self.Components[i] is TSpeedButton) and
       ( TSpeedButton(self.Components[i]).Tag <> 0 )
    then
    begin

        TSpeedButton(self.Components[i]).Down := true;

        SetLength( arrKindFilter, Length( arrKindFilter ) +1 );
        arrKindFilter[ high( arrKindFilter ) ] := TSpeedButton(self.Components[i]).Tag;

    end;
end;

procedure TfObjectCatalog.sbKindSectionClick(Sender: TObject);
/// обработчик всех кнопок фильтра
begin
    UpdateFilterElem( (sender as TSpeedButton).tag, (sender as TSpeedButton).down );

    RefreshDSFilter;
end;

procedure TfObjectCatalog.sbKindSectionMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
/// на клике по всплывающему меню запоминаем на какой кнопке его активировали
/// чтобы получить из нее тип объекта, за который отвечает и поменять фильтр
begin
   if   Button = mbRight
   then popOwner := TSpeedButton(Sender);
end;

procedure TfObjectCatalog.UpdateFilterElem( kind: integer; mode: boolean );
/// обновляет набор не показываемых типов
/// mode - false = исключить значение kind из массива (не отображать элементы данного типа)
///        true = добавить в массив
var
    i: integer;
    found: boolean;
begin

    if not mode then
    /// исключаем из фильтра
    begin

        // сканируем массив и при обнаружении искомого значения
        // начинаем сдвигать значения массива к началу на одну позицию,
        // тем самым затирая элемент. после перебора останется только
        // сократить длину массива на 1
        for I := 0 to High(arrKindFilter) do
        begin
            if found then arrKindFilter[i-1] := arrKindFilter[i];
            if arrKindFilter[i] = kind then found := true;
        end;

        SetLength( arrKindFilter, Length( arrKindFilter )-1);

    end else
    begin

        // тупо добавляем значение в конец массива
        SetLength( arrKindFilter, Length( arrKindFilter )+1);
        arrKindFilter[ high( arrKindFilter ) ] := kind;

    end;

    // устанавливаем состояние кнопки фильтра
    for i := 0 to self.ComponentCount-1 do
    if (self.Components[i] is TSpeedButton) and
       ( TSpeedButton(self.Components[i]).Tag = kind )
    then
        TSpeedButton(self.Components[i]).Down := mode;

end;

procedure TfObjectCatalog.grdCatalogObjectsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfObjectCatalog.grdCatalogObjectsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     grdCatalogObjects.BeginDrag(true);
end;

procedure TfObjectCatalog.grdCatalogObjectsSelectionChanged(Sender: TObject);
begin
    if Assigned(wndCard) then wndCard.Init;

    if Assigned(wndSpecTreeFree) then
        wndSpecTreeFree
            .SetRootId( grdCatalogObjects.DataSource.DataSet.FieldByName('id').AsInteger )
            .Refresh;
end;

procedure TfObjectCatalog.menuShowAllClick(Sender: TObject);
begin
    SetEmptyFilter;
    RefreshDSFilter;
end;

procedure TfObjectCatalog.menyShowItOnlyClick(Sender: TObject);
begin
    SetFullFilter;
    UpdateFilterElem( popOwner.Tag, true );
    RefreshDSFilter;
end;

procedure TfObjectCatalog.Refresh;
begin
    grdCatalogObjects.DataSource.DataSet.Close;
    grdCatalogObjects.DataSource.DataSet.Open;
end;


procedure TfObjectCatalog.RefreshData(filter: string = '');
/// получаем данные для справочника с учетом источника и набора фильтров
begin
    // получаем реальные данные
      grdCatalogObjects.DataSource.DataSet :=
             Core.DM.OpenQueryEx( GetSQL, grdCatalogObjects.DataSource.DataSet )
end;

procedure TfObjectCatalog.RefreshDSFilter;
/// формируем строку фильтра по текущим нажатым кнопками типов и передаем ее
/// методу перезапроса данных из базы
begin
    RefreshData( mngDatatable.GetFilterByColumns( grdCatalogObjects, GetKindFilterPart ) );
end;

end.
