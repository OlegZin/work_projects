unit uSpecifTreeManager;

interface

uses
    MemTableEh, DBGridEh, Data.DB, SysUtils, MemTableDataEh, System.Variants,
    Data.Win.ADODB, math;

const
    SQL_GET_SUBITEMS =
        ' DECLARE @child int = %d '
      + ' SELECT DISTINCT(Child), parent, CASE WHEN mark is null THEN name ELSE mark + '' '' + name END as name, kind, icon, lId, luid, mark FROM %s '
      + ' WHERE parent = @child '
//      + ' GROUP BY child, parent, name, kind, icon, lId, luid '
      ;

type

    TTreeManager = class
        procedure init(TreeGrid: TDBGridEh; TableName: string);
                     // ����������� �������� � ���������� ����������� � �������-���������

        function GetTreeLevel(parent, aParent: integer): boolean;
                     // �������� �������� ���������� �������
                     // parent - ����������� id � ����
                     // aParent - ��������� id � ������ � �������� ����� �����������

        procedure Refresh;
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
    private
        TableName       // ��� ������� ��� ������� �� ���� �����������
       ,SQL             // ���������������� ������ ��� ������� ������
                : string;

        MemTable        //  �������� �������������� ������ ��� ����������� ������ � TreeGrid
                : TMemTableEh;

        TreeGrid: TDBGridEh;
        DataSource: TDataSource;

        procedure RecordsViewTreeNodeExpanding(Sender: TObject; Node: TMemRecViewEh; var AllowExpansion: Boolean);
        procedure RecordsViewTreeNodeExpanded(Sender: TObject; Node: TMemRecViewEh);
    end;

implementation

{ TSpecifTreeManager }

uses
    uPhenixCORE;

procedure TTreeManager.RecordsViewTreeNodeExpanded(Sender: TObject;
  Node: TMemRecViewEh);
begin

    if Node.NodeHasChildren then exit;

    GetTreeLevel(
        node.Rec.DataValues['child', TDataValueVersionEh.dvvCurValueEh],
        node.Rec.DataValues['aChild', TDataValueVersionEh.dvvCurValueEh]
    );
end;

procedure TTreeManager.RecordsViewTreeNodeExpanding(Sender: TObject;
  Node: TMemRecViewEh; var AllowExpansion: Boolean);
var
   i : integer;
begin

    if Node.NodeHasChildren then exit;

    GetTreeLevel(
        node.Rec.DataValues['child', TDataValueVersionEh.dvvCurValueEh],
        node.Rec.DataValues['aChild', TDataValueVersionEh.dvvCurValueEh]
    );

end;

procedure TTreeManager.Refresh;
{ ����������� ������, � ������ ��������� �� ������ ������ ����� }
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

    // ���������� �������� ������ � ���������� ��������� (�������� �����, ������� �������)
    selected_id := MemTable.RecView.Rec.DataValues[ 'aChild', TDataValueVersionEh.dvvCurValueEh ];
    MemTable.First;
    while not MemTable.Eof do
    begin
        if MemTable.RecView.NodeExpanded then
            AddToArr( MemTable.RecView.Rec.DataValues[ 'aChild', TDataValueVersionEh.dvvCurValueEh ], true, false );
        MemTable.Next;
    end;


    // �������������
    Memtable.Close;
    Memtable.CreateDataSet;
    GetTreeLevel(0,0);

    if Length(arr) = 0 then exit;

    // �������������� ��������� ������
    someFound := true;
    while someFound do
    begin

        someFound := false;

        for I := 0 to High(arr) do
        if Locate('aChild', arr[i].id ) then
        begin
            MemTable.RecView.NodeExpanded := arr[i].expand;
            arr[i].id := 0;
            someFound := true;
        end;

    end;
    Locate('aChild', selected_id );

end;

procedure TTreeManager.SetSQL(sql: string);
begin
    Self.SQL := sql;
end;

function TTreeManager.UpdateField(id: integer; field: string; value: variant): boolean;

begin
    result := false;

    if   Locate( 'child', id )
    then
    begin
        MemTable.Edit;
        MemTable.FieldByName( field ).value := value;
        MemTable.Post;

        result := true;
    end;

end;

function TTreeManager.AddChild(aParent, child: integer): boolean;
begin
    result := false;

    if not dmOQ( 'select * FROM '+TableName+' WHERE child = ' + IntToStr(child) ) then exit;

    memtable.AppendRecord([
        Core.DM.Query.FieldByName('name').Value,
        Core.DM.Query.FieldByName('kind').Value,
        Core.DM.Query.FieldByName('parent').Value,
        Core.DM.Query.FieldByName('child').Value,
        Core.DM.Query.FieldByName('icon').Value,
        aParent,
        Core.DM.Query.FieldByName('lid').Value,
        Core.DM.Query.FieldByName('luid').Value,
        Core.DM.Query.FieldByName('count').Value
//       ,ifthen( Assigned(Core.DM.Query.Fields.FindField('count')), Core.DM.Query.FieldByName('count').Value, 0 )
    ]);

    result := true;
end;


procedure TTreeManager.Delete(id: integer);
{ �������� �� ������ ������ �� �� lid (id �� ������� ������) }
begin

    if   Locate('aChild', id)
    then MemTable.Delete;

end;

procedure TTreeManager.Expand;
begin
    MemTable.RecView.NodeExpanded := true;
end;

function TTreeManager.GetTreeLevel(parent, aParent: integer): boolean;
var
   query: TADOQuery;
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
{
        dmOQ( Format( ' DECLARE @child int = %d ' +
                      ' SELECT * FROM '+TableName+' WHERE parent = @child GROIP BY child UNION '+
                      ' SELECT * FROM '+TableName+' WHERE parent in (SELECT child FROM '+TableName+' WHERE parent = @child) GROIP BY child', [parent] ))
}
        dmOQ( Format( SQL_GET_SUBITEMS, [parent, TableName] ))
    else
        dmOQ( Format( SQL, [parent] ));

    // ��������� ������ � ������� ���������, �� ������ ���� ������ ������ ����������� �������������
    while not Core.DM.Query.Eof do
    begin
        if Core.DM.Query.FieldByName('parent').Value = Parent  then
        begin
            memtable.AppendRecord([
                Core.DM.Query.FieldByName('name').Value,
                Core.DM.Query.FieldByName('kind').Value,
                Core.DM.Query.FieldByName('parent').Value,
                Core.DM.Query.FieldByName('child').Value,
                Core.DM.Query.FieldByName('icon').Value,
                aParent,                                   // aParent
                Core.DM.Query.FieldByName('lid').Value,    // aChild
                Core.DM.Query.FieldByName('luid').Value
//               ,ifthen( Assigned(Core.DM.Query.Fields.FindField('count')), Core.DM.Query.FieldByName('count').Value, 0 )
            ]);

            result := true;
        end;

        Core.DM.Query.Next;
    end;

    lCE;

end;

function TTreeManager.GetValue(fieldname: string): variant;
begin
    Result := Memtable.RecView.Rec.DataValues[ fieldname, TDataValueVersionEh.dvvCurValueEh ];
end;

procedure TTreeManager.init(TreeGrid: TDBGridEh; TableName: string);
begin

    if not Assigned(TreeGrid) then exit;

    self.TreeGrid := TreeGrid;
    self.TableName := TableName;

    Memtable := TMemTableEh.Create(nil);
    DataSource := TDataSource.Create(nil);

    DataSource.DataSet := Memtable;
    TreeGrid.DataSource := DataSource;

    Memtable.FieldDefs.Clear;
    Memtable.FieldDefs.Add('name',    ftString, 100, false);  // ��� �������� (������������ � ������)
    Memtable.FieldDefs.Add('kind',    ftInteger, 0, false);   // ��� �������� (����� �����������)
    Memtable.FieldDefs.Add('parent',  ftInteger, 0, false);   // ����������� id �������� ��������
    Memtable.FieldDefs.Add('child',   ftInteger, 0, false);   // ����������� id �������� (��� ������� ������� �� ����)
    Memtable.FieldDefs.Add('icon',    ftInteger, 0, false);   // ����� ������, ���� ����
    Memtable.FieldDefs.Add('aParent', ftInteger, 0, false);   // ��������������� id �������� (��� ���������� �������� ������)
    Memtable.FieldDefs.Add('aChild',  ftInteger, 0, false);   // id ������� (��� ���������� �������� ������ � ���� ���� �����
                                                              // ��������� id ������ �� ������� ������, ����� ���������
                                                              // ���������� id ������� � ������ ������)
    Memtable.FieldDefs.Add('lUid',    ftInteger, 0, false);   // id ������������, ���������� ����� (����������� �������������)
//    Memtable.FieldDefs.Add('count',   ftInteger, 0, false);   // ���������� �������� ������� ������������

    Memtable.TreeList.Active := true;
    Memtable.TreeList.FullBuildCheck := false;
    Memtable.TreeList.DefaultNodeHasChildren := false;
    Memtable.TreeList.KeyFieldName := 'aChild';
    Memtable.TreeList.RefParentFieldName := 'aParent';

    Memtable.OnRecordsViewTreeNodeExpanding := RecordsViewTreeNodeExpanding;
    Memtable.OnRecordsViewTreeNodeExpanded := RecordsViewTreeNodeExpanded;

    Memtable.CreateDataSet;

    Memtable.Open;

end;

function TTreeManager.Locate(fieldname: string; value: variant): boolean;
begin
    result := Memtable.Locate(fieldname, value, []);
end;

end.
