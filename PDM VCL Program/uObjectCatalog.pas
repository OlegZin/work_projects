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
        // ������������� ������ ����������� ��������� ��������
    procedure SetFullFilter;
        // ������������� ������ ���������� (��� ������������ ���������)
    procedure UpdateFilterElem( kind: integer; mode: boolean );
        // ��������� ���������� ��� �������� ������� �������
    function GetKindFilterPart: string;
    procedure RefreshDSFilter;
    function GetSQL: string;
  public
    ProjectId: integer;
        // ���� = -1, ������ �������� �������� ������ �� ������� [object]
        // ���� = 0, ������ ���������� ��� �������, ��������� � ������ ���� ��������
        // ���� > 0, ������ �������� ������� ��������� � ������
        // ���������� �������

        // ��� ��, ��� drag`n`drop � ���� �����, ���������� �������� ����������
        // � ���� ������������ ������
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
    /// �������� ������ ������� �������� �������� �� ����� (���������)
    /// ���� ��� ���� � �������, �� �� ������������ � ������ ��������
    /// ������ ������ �������� ����� ���� ����� ��������
    /// ��������� ������� ������� �� ������� ������ �������

    /// ��� ������� �������� ������������ "kind not in (�,y,z,..)", ���
    /// �,y,z,.. - �������� ������� �������

    /// ������������ ������ ����������� ��� ����, ����� �� ������������� �
    /// �������� ������ ����� � ���������� ������ ��������, � �� ����������
    /// ����� ���������� � �����������. ������������� ���������� �������
    /// ������ �������� ������� ����� ���������� ����� � ����������� �������� ����

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

    // �������������� ����������� ����, � ������� ��������� ������
    // ��� ����� ������ �������, ����� ������������ ��� ��������
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

    // ���������� ������ �� ����� ���� ���������
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
/// ����� �������� ������� � ������ ���������
begin
    if   not assigned(wndCard)
    then
        wndCard := TfObjectCard.Create(self, OBJECT_CARD_MODE_VIEW, Refresh, grdCatalogObjects.DataSource.DataSet).Init
    else
        wndCard.BringToFront;

    wndCard.Show;
end;

function TfObjectCatalog.SetFilter(kinds: array of integer): TfObjectCatalog;
/// ��������� ������� ���������� �� ����� �������� � ���������� ������
/// ����������� �������� ����������, ������� ��������� ���������� �����
/// ���������� ��� ������ �����������
/// kinds - �������� ����, ������� ������ ���� ����������
var
    i: integer;
begin
    result := self;

    // ��������� ����� ���� ���������
    SetFullFilter;

    // ��������� ����, ������� ����������
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
    // � ������ ������� � tag ����� ��� ������� �� ������� [object_classificator].[kind]
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

  self.Caption := '���������� ��������. [ ' + ProjectName + ' ' + ProjectMark + ' ]';

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
        ShowMessage('����������� ������ ��� ����������� ������');
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
/// ����� ��������� ������ ����� ������ �������� � �������� ��� ������ �������
/// ��������� ����� ����� �������������� �������, ��������� ������ ��������
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
/// ���������� ���� ������ �������
begin
    UpdateFilterElem( (sender as TSpeedButton).tag, (sender as TSpeedButton).down );

    RefreshDSFilter;
end;

procedure TfObjectCatalog.sbKindSectionMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
/// �� ����� �� ������������ ���� ���������� �� ����� ������ ��� ������������
/// ����� �������� �� ��� ��� �������, �� ������� �������� � �������� ������
begin
   if   Button = mbRight
   then popOwner := TSpeedButton(Sender);
end;

procedure TfObjectCatalog.UpdateFilterElem( kind: integer; mode: boolean );
/// ��������� ����� �� ������������ �����
/// mode - false = ��������� �������� kind �� ������� (�� ���������� �������� ������� ����)
///        true = �������� � ������
var
    i: integer;
    found: boolean;
begin

    if not mode then
    /// ��������� �� �������
    begin

        // ��������� ������ � ��� ����������� �������� ��������
        // �������� �������� �������� ������� � ������ �� ���� �������,
        // ��� ����� ������� �������. ����� �������� ��������� ������
        // ��������� ����� ������� �� 1
        for I := 0 to High(arrKindFilter) do
        begin
            if found then arrKindFilter[i-1] := arrKindFilter[i];
            if arrKindFilter[i] = kind then found := true;
        end;

        SetLength( arrKindFilter, Length( arrKindFilter )-1);

    end else
    begin

        // ���� ��������� �������� � ����� �������
        SetLength( arrKindFilter, Length( arrKindFilter )+1);
        arrKindFilter[ high( arrKindFilter ) ] := kind;

    end;

    // ������������� ��������� ������ �������
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
/// �������� ������ ��� ����������� � ������ ��������� � ������ ��������
begin
    // �������� �������� ������
      grdCatalogObjects.DataSource.DataSet :=
             Core.DM.OpenQueryEx( GetSQL, grdCatalogObjects.DataSource.DataSet )
end;

procedure TfObjectCatalog.RefreshDSFilter;
/// ��������� ������ ������� �� ������� ������� �������� ����� � �������� ��
/// ������ ����������� ������ �� ����
begin
    RefreshData( mngDatatable.GetFilterByColumns( grdCatalogObjects, GetKindFilterPart ) );
end;

end.
