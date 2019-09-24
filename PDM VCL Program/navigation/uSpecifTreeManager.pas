unit uSpecifTreeManager;

interface

uses
    MemTableEh, DBGridEh, Data.DB, SysUtils, MemTableDataEh, System.Variants,
    Data.Win.ADODB, math, VirtualTrees, VCL.Graphics, System.Types, VCL.Controls, uTypes;

const

    FT_INTEGER = 'ftInteger';
    FT_STRING = 'ftString';

    /// ����� ���������� ������
    MODE_DBGRID = 0;   // ����� TDBGridEh
    MODE_VTREE  = 1;   // ����� TVirtualStringTree

    FIELD_KIND_TEXT = 0;
    FIELD_KIND_IMAGE = 1;

type
    TStrArray = array of string;
//    TIntArray = array of integer;

    /// ������ ��� �������� ������ � ������ VTTreeGrid
    TRecData = record
        mem_kind
       ,mem_parent
       ,mem_child
       ,mem_icon
       ,mem_aParent
       ,mem_aChild
       ,mem_luid
       ,status
       ,editor_id
       ,checker_id
                 : integer;
        mem_name
       ,mem_mark
       ,name
       ,markTU
                 : string;
    end;
    PRecData = ^TRecData;

    TColumns = array of record
        field: string;          // ��� ���� �� MemTable ������ �������� ����� ����������
        kind: integer;          // ��� ���� �����(0)/��������(1)
        imagelist: TImageList;  // ����� �������� ��� ����
        defImageIndex: integer; // ������ �������� �� ������ �� ���������. -1 - �� �����������
    end;

    TTreeManager = class
        function SetExtFields( fields, types: TStrArray ): TTreeManager;
                     // ������ ������ �������������� ����� ��� �������
                     // ���������� �� ������ Init
        procedure init(TreeGrid: TDBGridEh; TableName: string);
                     // ����������� �������� � ���������� ����������� � �������-���������
        procedure initVT(VTree: TVirtualStringTree);
        // �������� ���������� ��� ��������������� ����������� ������

        function GetTreeLevel(parent, aParent: integer; show_parent: boolean = false): boolean;
                     // �������� �������� ���������� �������
                     // parent - ����������� id � ����
                     // aParent - ��������� id � ������ � �������� ����� �����������
                     // show_parent - �������� �� � ������ ������ parent

//        procedure Refresh(baseID: integer = 0); OVERLOAD;
        procedure Refresh(baseID: TIntArray; show_root: boolean = false); OVERLOAD;

        function GetValue(fieldname: string): variant;
        function Locate(fieldname: string; value: variant): boolean;
        function AddChild(aParent, child: integer): boolean;

        function UpdateField( id: integer; field: string; value: variant): boolean;
                     // ��������� ������ ������ ���� � ������ memtable

        procedure Delete(id: integer);
                     // ������� ������� ���������� ������� � ������

        procedure SetSQL(sql: string);
                     // ��������� ������ ��� ������ ��������� ��� ������

        procedure Expand;
        procedure FullExpand;
        procedure FullCollapse;
        procedure SetDBGridMode;

        procedure ClearColumns;
        procedure AddColumn( field: string; kind, imageIndex: integer; ilist: TImageList );
        procedure SetVirtualTreeMode;
        /// ��������� ������ ����������� virtualtree
        /// �������������� ��������� �������� ���� ������� AddColumn

    private
        TableName       // ��� ������� ��� ������� �� ���� �����������
       ,SQL             // ���������������� ������ ��� ������� ������
                : string;

        MemTable : TMemTableEh;
        //  �������� �������������� ������ ��� ����������� ������ � TreeGrid

        fExtraFieldsArr
       ,fExtraTypesArr : TStrArray;
        // ������ ���� �������������� �����, ������������ ��� ������������ ������ fExtraFields
        // � �������� ��� ����� ��� ������ � �������
        fExtraFields : string;
        // ��������� ������ � ������� ����� ����� ������� ��� ����������� � ������ ������� ������

        fMode: integer;
        /// ����� ���������� ������

        fColumns: TColumns;
        /// ������ ���������� ������� ��� ������ ������������ ������

        TreeGrid: TDBGridEh;
        VTTreeGrid: TVirtualStringTree;
        /// ���� ����������, ��������� ���������� ������ � �������������� ������ ����� ���� ���������
        /// ������� ����� ������� ������� �������� � ���������� ����������� � ����������
        DataSource: TDataSource;

        function ScanVTree( parent: PVirtualNode; value: variant ): PVirtualNode;
        /// �� �������� parent ���� node � virtualtree
        /// ����������� ��� ������� ���������� ���������� ������ ������

        procedure AddRecToMemtable( ds: TDataset; aParent: integer; parent_node: PVirtualNode );


        // ����������� ������� ��� ������ dbgrid
        procedure RecordsViewTreeNodeExpanding(Sender: TObject; Node: TMemRecViewEh; var AllowExpansion: Boolean);
        procedure RecordsViewTreeNodeExpanded(Sender: TObject; Node: TMemRecViewEh);

        /// ����������� ������� ��� ������ virtualtree
        procedure VTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
        procedure VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
            Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
        procedure VTBeforeCellPaint(Sender: TBaseVirtualTree;
          TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
          CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    end;


implementation

{ TSpecifTreeManager }

uses
    uPhenixCORE;

const
    SQL_GET_SUBITEMS =
        ' DECLARE @child int = %d '
      + ' SELECT DISTINCT(Child), parent, full_name, kind, icon, lId, luid, mark %s FROM %s '
      + ' WHERE %s = @child '
      ;

{    SQL_GET_ITEM =
        ' DECLARE @child int = %d '
      + ' SELECT DISTINCT(Child), parent, full_name, kind, icon, lId, luid, mark %s FROM %s '
      + ' WHERE child = @child '
      ;
}
procedure TTreeManager.RecordsViewTreeNodeExpanded(Sender: TObject;
  Node: TMemRecViewEh);
begin

    if Node.NodeHasChildren then exit;

    GetTreeLevel(
        node.Rec.DataValues['mem_child', TDataValueVersionEh.dvvCurValueEh],
        node.Rec.DataValues['mem_aChild', TDataValueVersionEh.dvvCurValueEh]
    );
end;

procedure TTreeManager.RecordsViewTreeNodeExpanding(Sender: TObject;
  Node: TMemRecViewEh; var AllowExpansion: Boolean);
var
   i : integer;
begin

    if Node.NodeHasChildren then exit;

    GetTreeLevel(
        node.Rec.DataValues['mem_child', TDataValueVersionEh.dvvCurValueEh],
        node.Rec.DataValues['mem_aChild', TDataValueVersionEh.dvvCurValueEh]
    );

end;

procedure TTreeManager.Refresh(baseID: TIntArray; show_root: boolean = false);
/// ����������� ������, � ������ ��������� �� ������ ������ �����
/// baseID - ������ ��������� ������� ������� ������ ������
/// show_root - � ������� �� � ������ ���������� ��������. � ������� ������
///        ����� ������� ��� ������ �� �������� �������� - ��� ������ ������� �
///        ���������� ��� �� �����. � ������ ������ ������ ��������� ���������
///        (����� ������ ���������) ����� ������������, ����� ��� ���� ����������
///        � ������
type
    TElem = record
        id : integer;
        expand : boolean;
        selected : boolean;
    end;
var
    someFound: boolean;
    i, selected_id: integer;
    arr: array of TElem;

    procedure AddToArr( id: integer; expand, selected: boolean );
    begin
        SetLength(arr, Length(arr)+1);
        arr[High(arr)].id := id;
        arr[High(arr)].expand := expand;
        arr[High(arr)].selected := selected;
    end;
begin
    if length(baseID) = 0 then
    begin
       setLength(baseID, Length(baseID) +1);
       baseid[0] := 0;
    end;

    lM('TTreeManager.Refresh ��� ID ' + IntToStr(baseID[0]));

    // ���������� �������� ������ � ���������� ��������� (�������� �����, ������� �������)
    if MemTable.Active and ( MemTable.RecordCount > 0 ) then
    if not VarIsNull(MemTable.RecView.Rec.DataValues[ 'mem_aChild', TDataValueVersionEh.dvvCurValueEh ]) then
    begin
        selected_id :=  MemTable.RecView.Rec.DataValues[ 'mem_aChild', TDataValueVersionEh.dvvCurValueEh ];
        MemTable.First;
        while not MemTable.Eof do
        begin
            if MemTable.RecView.NodeExpanded then
                AddToArr( MemTable.RecView.Rec.DataValues[ 'mem_aChild', TDataValueVersionEh.dvvCurValueEh ], true, false );
            MemTable.Next;
        end;
    end;


    // �������������
    Memtable.Close;
    Memtable.CreateDataSet;


    /// �������� ������ �� ���� ��������� ��������
    for i := 0 to High(BASEID) do
    begin

        /// ���� ��������� �������� ������ � ������, ���������� ���/�� ������
        /// ������� ������
        if show_root then
        begin
            if SQL = ''
            then
                dmOQ( Format( SQL_GET_SUBITEMS, [baseID[I], fExtraFields, TableName, 'child'] ))
            else
                dmOQ( Format( SQL, [baseID[I]] ));

            if Core.DM.Query.Active and (Core.DM.Query.RecordCount > 0) then
            begin
                AddRecToMemtable( Core.DM.Query, 0, nil );
                GetTreeLevel( baseID[I], Core.DM.Query.FieldByName('lid').AsInteger );
            end;
        end else
            GetTreeLevel(baseID[I],0);
    end;

    /// �������� �� ������ � ������������� ��������� ��� ����.
    /// Memtable.TreeList.FullExpand � ������ ������ �� ��������, ���������
    /// ������ ������������� ������������ �� ������ ������ ������, �� �������
    /// ���������� ��������� ��������
    Memtable.First;
    while not Memtable.eof do
    begin
        MemTable.RecView.NodeExpanded := true;
        memtable.Next;
    end;
    Memtable.TreeList.FullCollapse;

    if Length(arr) = 0 then exit;

    // �������������� ��������� ������
    someFound := true;
    while someFound do
    begin

        someFound := false;

        for I := 0 to High(arr) do
        if Locate('mem_aChild', arr[i].id ) then
        begin
            MemTable.RecView.NodeExpanded := arr[i].expand;
            arr[i].id := 0;
            someFound := true;
        end;

    end;
    Locate('mem_aChild', selected_id );

end;

function TTreeManager.ScanVTree(parent: PVirtualNode; value: variant): PVirtualNode;
var
   child: PVirtualNode;
   data: PRecData;
begin
    result := nil;
    child := parent.FirstChild;
    while Assigned(child) and (not Assigned(result)) do
    begin
        data := child.GetData;

        if   data^.mem_child = value
        then result := child
        else result := ScanVTree( child, value );

        child := child.NextSibling;
    end;
end;

procedure TTreeManager.SetDBGridMode;
begin
    fMode := MODE_DBGRID;
    if Assigned(TreeGrid) then TreeGrid.Visible := true;
    if Assigned(VTTreeGrid) then VTTreeGrid.Visible := false;
end;

function TTreeManager.SetExtFields(fields, types: TStrArray): TTreeManager;
var
   i : integer;
begin

    if (length(fields) > 0) and (length(types) > 0) and (length(fields) = length(types)) then
    begin
        fExtraFieldsArr := fields;
        fExtraTypesArr := types;

        // ��������� ������ ��� ����������� � SQL
        for I := 0 to High(fields) do
            fExtraFields := fExtraFields + ',' + fields[i];
    end;

    result := self;
end;

procedure TTreeManager.SetSQL(sql: string);
begin
    Self.SQL := sql;
end;

procedure TTreeManager.SetVirtualTreeMode;
var
    i : integer;
begin
    if Length(fColumns) = 0 then exit;

    fMode := MODE_VTREE;
    if Assigned(TreeGrid) then TreeGrid.Visible := false;
    if Assigned(VTTreeGrid) then VTTreeGrid.Visible := true;

    VTTreeGrid.Header.Columns.Clear;

    for I := 0 to High(fColumns) do
    with VTTreeGrid.Header.Columns.Add do
    begin
       if fColumns[i].kind = FIELD_KIND_TEXT then
       begin
           Options := Options - [coDraggable] - [coEditable];
           Width := 300;
       end;

       if fColumns[i].kind = FIELD_KIND_IMAGE then
       begin
           Options := Options - [coDraggable] - [coEditable] + [coFixed] - [coResizable];
           Width := 20;
       end;
    end;

end;

function TTreeManager.UpdateField(id: integer; field: string; value: variant): boolean;

begin
    result := false;

    if   Locate( 'mem_child', id )
    then
    begin
        MemTable.Edit;
        MemTable.FieldByName( field ).value := value;
        MemTable.Post;

        result := true;
    end;

end;

function TTreeManager.AddChild(aParent, child: integer): boolean;
var
    i : integer;
begin
    result := false;

    if not dmOQ( 'select * FROM '+TableName+' WHERE child = ' + IntToStr(child) ) then exit;

    memtable.AppendRecord([
        Core.DM.Query.FieldByName('full_name').Value,
        Core.DM.Query.FieldByName('kind').Value,
        Core.DM.Query.FieldByName('parent').Value,
        Core.DM.Query.FieldByName('child').Value,
        Core.DM.Query.FieldByName('icon').Value,
        aParent,
        Core.DM.Query.FieldByName('lid').Value,
        Core.DM.Query.FieldByName('luid').Value,
        Core.DM.Query.FieldByName('count').Value,
        Core.DM.Query.FieldByName('mark').Value
    ]);

    // �������� ��������� ����, ���� ������
    if length(fExtraFieldsArr) > 0 then
    begin
        memtable.Locate('mem_aChild', Core.DM.Query.FieldByName('lid').Value, [] );

        memtable.Edit;

        for I := 0 to High(fExtraFieldsArr) do
            memtable.FieldByName( fExtraFieldsArr[i] ).Value :=
            Core.DM.Query.FieldByName(fExtraFieldsArr[i]).Value;

        memtable.Post;
    end;

    result := true;
end;

procedure TTreeManager.AddColumn(field: string; kind, imageIndex: integer;
  ilist: TImageList);
/// ��������� �������� ������� ��� ������ virtualtree
begin
    SetLength(fColumns, Length(fColumns) +1);
    fColumns[High(fColumns)].kind := kind;
    fColumns[High(fColumns)].field := field;
    fColumns[High(fColumns)].imagelist := ilist;
    fColumns[High(fColumns)].defImageIndex := imageIndex;
end;

procedure TTreeManager.ClearColumns;
begin
    SetLength(fColumns, 0);
end;

procedure TTreeManager.Delete(id: integer);
{ �������� �� ������ ������ �� �� lid (id �� ������� ������) }
begin

    if   Locate('mem_aChild', id)
    then MemTable.Delete;

end;

procedure TTreeManager.Expand;
begin
    if   assigned(MemTable.RecView)
    then MemTable.RecView.NodeExpanded := true;
end;

procedure TTreeManager.FullCollapse;
begin
    MemTable.TreeList.FullCollapse;
end;

procedure TTreeManager.FullExpand;
begin
//    MemTable.TreeList.DefaultNodeExpanded := TRUE;
    MemTable.TreeList.FullExpand;
end;

procedure TTreeManager.AddRecToMemtable( ds: TDataset; aParent: integer; parent_node: PVirtualNode );
var
   node : PVirtualNode;
   data : PRecData;
   i: integer;
begin
    if (fMode = MODE_DBGRID) and Assigned(TreeGrid) then
    begin
        /// ���� TDBGridEh � ���, ��� � ������ ������ �� ��� �������� ��� ��
        /// ��������� ����� ���������� parent � child. ���������� ������ ���������� �
        /// ������� ������, ���������� ��������

        memtable.Insert;

        memtable.FieldByName('mem_name').Value    := ds.FieldByName('full_name').Value;
        memtable.FieldByName('mem_kind').Value    := ds.FieldByName('kind').Value;
        memtable.FieldByName('mem_parent').Value  := ds.FieldByName('parent').Value;
        memtable.FieldByName('mem_child').Value   := ds.FieldByName('child').Value;
        memtable.FieldByName('mem_icon').Value    := ds.FieldByName('icon').Value;
        memtable.FieldByName('mem_aParent').Value := aParent;
        memtable.FieldByName('mem_aChild').Value  := ds.FieldByName('lid').Value;
        memtable.FieldByName('mem_luid').Value    := ds.FieldByName('luid').Value;
        memtable.FieldByName('mem_mark').Value    := ds.FieldByName('mark').Value;

        // ��������� �������������� ����
        for I := 0 to High(fExtraFieldsArr) do
            memtable.FieldByName( fExtraFieldsArr[i] ).Value :=
                ds.FieldByName(fExtraFieldsArr[i]).Value;

        memtable.Post;

    end;

    if (fMode = MODE_VTREE) and Assigned(VTTreeGrid) then
    begin

        node := VTTreeGrid.AddChild(parent_node);
        data:=VTTreeGrid.GetNodeData(node);

        data^.mem_name    := ds.FieldByName('full_name').AsString;
        data^.mem_kind    := ds.FieldByName('kind').AsInteger;
        data^.mem_parent  := ds.FieldByName('parent').AsInteger;
        data^.mem_child   := ds.FieldByName('child').AsInteger;
        data^.mem_icon    := StrToIntDef(ds.FieldByName('icon').AsString, 0);
        data^.mem_aParent := aParent;
        data^.mem_aChild  := ds.FieldByName('lid').AsInteger;
        data^.mem_luid    := ds.FieldByName('luid').AsInteger;
        data^.mem_mark    := ds.FieldByName('mark').AsString;

        if Assigned(Core.DM.Query.FindField('status')) then
            data^.status := ds.FieldByName('status').AsInteger;

        if Assigned(Core.DM.Query.FindField('editor_id')) then
            data^.editor_id := ds.FieldByName('editor_id').AsInteger;

        if Assigned(Core.DM.Query.FindField('checker_id')) then
            data^.checker_id := ds.FieldByName('checker_id').AsInteger;

        if Assigned(Core.DM.Query.FindField('name')) then
            else data^.name := ds.FieldByName('name').AsString;

        if Assigned(Core.DM.Query.FindField('markTU')) then
            else data^.markTU := ds.FieldByName('markTU').AsString;
    end;
end;

function TTreeManager.GetTreeLevel(parent, aParent: integer; show_parent: boolean = false): boolean;
var
   query: TADOQuery;
   i : integer;
   node, parent_node : PVirtualNode;
   data : PRecData;
begin

    result := false;

    lC('TTreeManager.GetTreeLevel');

    lM(Format('parent = %d, aParent = %d', [parent, aParent] ));

   if not Assigned(MemTable) then
    begin
        lW('�� ������������������� MemTable');
        exit;
    end;

    // �������� ������ ���������
    if SQL = ''
    then
        dmOQ( Format( SQL_GET_SUBITEMS, [parent, fExtraFields, TableName, 'parent'] ))
    else
        dmOQ( Format( SQL, [parent] ));


    /// ��������� ���� ��������� �� ����� ������������� ���������, �� parent
    /// ������ ������ ���� � ����� �� ��� �������
    /// ������� �������� �����������, ��������� �������������� �����������
    /// ������������ ������� �� ����
    if  (fMode = MODE_VTREE) and Assigned(VTTreeGrid)
    then parent_node := ScanVTree(VTTreeGrid.RootNode, parent);

    // ��������� ������ � ������� ���������, �� ������ ���� ������ ������ ����������� �������������
    while not Core.DM.Query.Eof do
    begin

        if Core.DM.Query.FieldByName('parent').Value = Parent  then
        AddRecToMemtable( Core.DM.Query, aParent, parent_node );

        Core.DM.Query.Next;
    end;

    lCE;

end;

function TTreeManager.GetValue(fieldname: string): variant;
begin
    Result := Memtable.RecView.Rec.DataValues[ fieldname, TDataValueVersionEh.dvvCurValueEh ];
end;

procedure TTreeManager.init(TreeGrid: TDBGridEh; TableName: string);
var
  I: Integer;
begin

    if not Assigned(TreeGrid) then exit;

    fMode := MODE_DBGRID;

    self.TreeGrid := TreeGrid;
    self.TableName := TableName;

    Memtable := TMemTableEh.Create(nil);
    DataSource := TDataSource.Create(nil);

    DataSource.DataSet := Memtable;
    TreeGrid.DataSource := DataSource;

    Memtable.FieldDefs.Clear;
    Memtable.FieldDefs.Add('mem_name',    ftString, 100, false);  // ��� �������� (������������ � ������)
    Memtable.FieldDefs.Add('mem_kind',    ftInteger, 0, false);   // ��� �������� (����� �����������)
    Memtable.FieldDefs.Add('mem_parent',  ftInteger, 0, false);   // ����������� id �������� ��������
    Memtable.FieldDefs.Add('mem_child',   ftInteger, 0, false);   // ����������� id �������� (��� ������� ������� �� ����)
    Memtable.FieldDefs.Add('mem_icon',    ftInteger, 0, false);   // ����� ������, ���� ����
    Memtable.FieldDefs.Add('mem_aParent', ftInteger, 0, false);   // ��������������� id �������� (��� ���������� �������� ������)
    Memtable.FieldDefs.Add('mem_aChild',  ftInteger, 0, false);   // id ������� (��� ���������� �������� ������ � ���� ���� �����
                                                              // ��������� id ������ �� ������� ������, ����� ���������
                                                              // ���������� id ������� � ������ ������)
    Memtable.FieldDefs.Add('mem_lUid',    ftInteger, 0, false);   // id ������������, ���������� ����� (����������� �������������)
    Memtable.FieldDefs.Add('mem_mark',    ftString, 100, false);  // ����������� �������

    // ���� ������ �������
    if ( Length(fExtraFieldsArr) > 0 ) and
    ( length(fExtraFieldsArr) = length(fExtraTypesArr) ) then
    for I := 0 to High(fExtraFieldsArr) do
    begin

        if   fExtraTypesArr[i] = FT_INTEGER
        then Memtable.FieldDefs.Add(fExtraFieldsArr[i], ftInteger, 0, false);

        if   fExtraTypesArr[i] = FT_STRING
        then Memtable.FieldDefs.Add(fExtraFieldsArr[i], ftString, 100, false);

    end;

    Memtable.OnRecordsViewTreeNodeExpanding := RecordsViewTreeNodeExpanding;
    Memtable.OnRecordsViewTreeNodeExpanded := RecordsViewTreeNodeExpanded;

    Memtable.TreeList.Active := true;
    Memtable.TreeList.FullBuildCheck := false;
    Memtable.TreeList.DefaultNodeHasChildren := false;
    Memtable.TreeList.KeyFieldName := 'mem_aChild';
    Memtable.TreeList.RefParentFieldName := 'mem_aParent';


    Memtable.CreateDataSet;

    Memtable.Open;

end;

procedure TTreeManager.initVT(VTree: TVirtualStringTree);
begin
    VTTreeGrid := VTree;
    VTTreeGrid.NodeDataSize:=SizeOf(TRecData);
    VTTreeGrid.OnFreeNode := VTFreeNode;
    VTTreeGrid.OnGetText := VTGetText;
    VTTreeGrid.OnBeforeCellPaint := VTBeforeCellPaint;
//    VTTreeGrid.Align := alClient;
end;

function TTreeManager.Locate(fieldname: string; value: variant): boolean;
begin
    result := Memtable.Locate(fieldname, value, []);
end;



procedure TTreeManager.VTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var rec: PRecData;
begin
    if node=nil then exit;

    rec:=VTTreeGrid.GetNodeData(node);

    if assigned(rec) then finalize(rec^);
end;

procedure TTreeManager.VTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var rec: PRecData;
begin
    if node=nil then exit;

    rec:=VTTreeGrid.GetNodeData(node);

    if Column = 0
    then CellText:=rec^.mem_name
    else CellText:='';
end;

procedure TTreeManager.VTBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
    rec: PRecData;
    bitmap: TBitmap;
    index: integer;
begin
    if node=nil then exit;

    rec:=VTTreeGrid.GetNodeData(node);

    index := fColumns[column].defImageIndex;

    case Column of
        1: index := rec^.mem_kind;
        2: index := rec^.mem_icon;
        3: index := rec^.status;
        4: index := Abs(Ord(rec^.editor_id > 0));   // ����� ������������� id �������� � ������� 1
        5: index := Abs(Ord(rec^.checker_id > 0));  // ����� ������������� id �������� � ������� 1
    end;

    if Assigned(fColumns[column].imagelist) AND
       ((index > -1) and (index <= fColumns[column].imagelist.Count-1)) and
       (index > 0)
    then
    begin
        try
            bitmap:=TBitmap.Create;
            fColumns[column].imagelist.GetBitmap(index, bitmap);
            TargetCanvas.Draw(CellRect.Left, CellRect.Top, bitmap);
        finally
            bitmap.Free;
        end;
    end;

//   if rec^.HasChildren then
//   node.States:=node.States+[vsHasChildren];
end;

end.
