unit uDatatableManager;

////////////////////////////////////////////////////////////////////////////////
///
///    ����� ��������� ������� ��������� ������ ��� ����������� ������ � ���������
///    �������������, ��� ��������� ����� ���� ��������� ���������� ���������
///    �������� �������� ��� ������ ������� ������
///
////////////////////////////////////////////////////////////////////////////////

interface

uses DBGridEh, StrUtils, Variants, SysUtils, uPhenixCORE, VCL.Controls, DB,
     VirtualTrees, VCL.Graphics, System.Types;

type

    TFieldInfo = record
        field: string;          // ��� ���� �� �������� ������ �������� ����� ����������
        caption: string;        // ����� ��������� �������
        kind: integer;          // ��� ���� �����(0)/��������(1)
        width: integer;         // ������ �������
        sort_pass: boolean;     // ���������� �� ��� ������� ���� ��������� ����������� ����������
        filter_pass: boolean;   // ���������� �� ��� ������� ���� ��������� ����������� ����������
        imagelist: TImageList;  // ����� �������� ��� ����
        KeyList: string;        // ������ � ��������� ���������� ��� imagelist
    end;

    TConfig = record
        name : string;                 // ��� ������������
        fields : array of TFieldInfo;  // ������ �����
        /// ����� ���������� ������ �� ����, ������� ��������� � ���� ������ �
        /// ������� ���������� � ������ ������
        /// ��� ����, ������� ���������� �����, ��������� ������ � ������� �� ������ ������� � �����
        /// ������� ����� ����������� � �������
    end;

    TDatatableManager = class
      public
        function GetFilterByColumns(grid: TDBGridEh; addonPart: string = ''): string;
            // ��������� sql ������ ��� ������� �������� �� ����������� ������� ������� �����
            // addonPart ����� ����������� ������� �������

        function ConfigureForFilter(grid: TDBGridEh; pass: array of integer): boolean;
            // �������������� ��������� ����� �� ������ � ��������� ��������
            // ��������� ��������� ������� ���� ��� ������

        function ConfigureForSorting(grid: TDBGridEh; pass: array of integer): boolean;
            // �������������� ��������� ����� �� ���������� � ��������
            // ��������� ��������� ������� ���� ��� ������

        function CreateConfiguration( name: string ): boolean;
        /// ������� ����� ������ ������������
        function ApplyConfiguration( name: string; grid: TDBGridEh ): boolean;
        /// ��������� ��������� ������������ � ��������� �������
        function AddConfigField(conf_name, _field_name, _caption: string; _kind, _width: integer;
            _sort_pass: boolean = false; _filter_pass: boolean = false; _imgList: TImagelist = nil; _keylist: string = '' ): boolean;

      private
        fConfig : array of TConfig;

        function Passed(index: integer; arr: array of integer): boolean;
            // ��������� �� ��������� ������ ������� � ������ ������������ ��� �������������
        function ConfIndex( name: string ): integer;

        procedure SetColumnFilter( column: TColumnEh; name: string; ds: TDataSource; filter: boolean );
        procedure SetColumnSort( column: TColumnEh; filter: boolean );

    end;


implementation

{ TDatatableManager }

const
    FIELD_KIND_TEXT = 0;
    FIELD_KIND_IMAGE = 1;


function TDatatableManager.Passed(index: integer;
  arr: array of integer): boolean;
/// ��������� �� ��������� ������ ������� � ������ ������������ ��� �������������
var
   j: integer;
begin
   result := false;
   for j := 0 to High(arr) do
       if   arr[j] = index
       then result := true;
end;

function TDatatableManager.ConfIndex(name: string): integer;
var
    i : integer;
    found : boolean;
begin
    result := -1;

    // ���� ������������ � ��������� ������
    for i := Low(fConfig) to High(fConfig) do
    if fConfig[i].name = name then
    begin
        result := i;
        exit;
    end;
end;

function TDatatableManager.AddConfigField(conf_name, _field_name, _caption: string; _kind,
  _width: integer; _sort_pass, _filter_pass: boolean; _imgList: TImagelist;
  _keylist: string): boolean;
/// ��� ��������� ������������ ��������� ����� �������� ����
var
    i : integer;
begin
    result := false;
    i := ConfIndex( conf_name );

    // ������������ �������
    if i = -1 then exit;

    // ��������� ������ ������ ����
    SetLength(fConfig[i].fields, Length(fConfig[i].fields)+1);
    with fConfig[i].fields[High(fConfig[i].fields)] do
    begin
        field := _field_name;
        caption := _caption;
        kind := _kind;
        width := _width;
        sort_pass := _sort_pass;
        filter_pass := _filter_pass;
        imagelist := _imgList;
        keylist := _keylist;
    end;

    result := true;
end;

function TDatatableManager.ApplyConfiguration(name: string;
  grid: TDBGridEh): boolean;
/// ��� ���������� ������� ������������ ����, �������� ��������� ������������
///
var
    i, c : integer;
    col: TColumnEh;
    field: TFieldInfo;
begin
    i := ConfIndex( name );
    if i = -1 then exit;

    /// ��������� ��������������
    grid.OptionsEh := grid.OptionsEh + [dghAutoSortMarking];

    lE(grid.Columns[0].KeyList.CommaText);
    /// ������� ��������� �������
    grid.Columns.Clear;

    for c := Low(fConfig[i].fields) to High(fConfig[i].fields) do
    begin
        field := fConfig[i].fields[c];

        /// ������� ����� �������
        col := grid.Columns.Add;

        col.FieldName := field.field;
        col.Title.Caption := field.caption;

        SetColumnFilter( col, col.FieldName, grid.DataSource, not field.filter_pass );
        SetColumnSort( col, not not field.sort_pass );

        if field.kind = FIELD_KIND_TEXT then
        // ��������� ����
        begin
            col.Width := field.width
        end;

        // ���� � �������
        if field.kind = FIELD_KIND_IMAGE then
        begin
            col.MinWidth := field.width;
            col.MaxWidth := field.width;
            col.ImageList := field.imagelist;
            col.KeyList.CommaText := field.KeyList;
        end;

    end;


end;

procedure TDatatableManager.SetColumnFilter( column: TColumnEh; name: string; ds: TDataSource; filter: boolean );
begin
    if filter then
    begin
        column.STFilter.DataField := name;
        column.STFilter.ListSource := ds;
        column.STFilter.Visible := true;
    end else
        column.STFilter.Visible := false;
end;

procedure TDatatableManager.SetColumnSort(column: TColumnEh; filter: boolean);
begin
    column.Title.TitleButton := filter;
end;

function TDatatableManager.ConfigureForFilter(grid: TDBGridEh; pass: array of integer): boolean;
{ ����� ��������� ���� � ������������ ��������� � ������������� ��� ��� ���������� ������ �
  �������� ��������.

  pass - ������ �������� ��������, ��� ������� �� ��������� ��������� �������
         (����� �� �������� ��� ���������� �������). ����� ��� ���� [0,3,5]

  �����!
  ������� ����� ������ ���� �� ���������� �����������:
  grid.DataSource.DataSet.Filtered := true;
}
var
    i: integer;
begin

    if   Assigned(grid.DataSource) and Assigned(grid.DataSource.DataSet)
    then grid.DataSource.DataSet.Filtered := true;

    grid.STFilter.Visible := true;
    for I := 0 to grid.Columns.Count-1 do
    SetColumnFilter( grid.Columns[i], grid.Columns[i].FieldName, grid.DataSource, not Passed(i, pass) );
{    if not Passed(i, pass) then
    begin
        grid.Columns[i].STFilter.DataField := grid.Columns[i].FieldName;
        grid.Columns[i].STFilter.ListSource := grid.DataSource;
        grid.Columns[i].STFilter.Visible := true;
    end else
        grid.Columns[i].STFilter.Visible := false;
}
    if   Assigned(grid.DataSource) and Assigned(grid.DataSource.DataSet)
    then grid.DataSource.DataSet.Filtered := true;

end;

function TDatatableManager.ConfigureForSorting(grid: TDBGridEh;
  pass: array of integer): boolean;
{ ����� ��������� ���� � ������������ ��������� � ������������� ��� ��� ����������
  ������ ���������� ��������.

  pass - ������ �������� ��������, ��� ������� �� ��������� ��������� �����������
         (����� �� �������� ��� ���������� �������). ����� ��� ���� [0,3,5]
}
var
    i: integer;
begin
    grid.OptionsEh := grid.OptionsEh + [dghAutoSortMarking];

    for I := 0 to grid.Columns.Count-1 do
        grid.Columns[i].Title.TitleButton := not Passed(i, pass);
end;

function TDatatableManager.CreateConfiguration(name: string): boolean;
var
    i: integer;
begin
    result := false;

    // �� ��������� ������ ����� ������������
    for i := Low(fConfig) to High(fConfig) do
    if fConfig[i].name = name then exit;

    // ������� ������
    SetLength( fConfig, Length(fConfig)+1);
    fConfig[High(fConfig)].name := name;

    result := true;
end;

function TDatatableManager.GetFilterByColumns(grid: TDBGridEh; addonPart: string = '' ): string;
{ ������������ � ����������� ������� OnApplyFilter ���������� DBGridEh
  ��� ������������ �� ������ ����������� ������� � sql c����� �������
  ��� ����������� � ������� �������.

  ���������� ������ ����� ���������� ���-�� ����:
    '1'
    '>=1'
    '>1 AND <=5'
    '~ TestStr%'
    '!~ TestStr_'
    'in (1,2,3,4,5,6) and >100'
    'in (Str1,Str2,Str3)'
  �.�. ��� ���� ����� � ����������� ������ � ��������� like

  ����� ���������� ������� ����������� �����, ��������� �� ������� ������
  �������, ���� ����, ��������� � ����� sql-������ � ���������� ���.

  ���������� ������ ����� ����� ����������� � dataset.filter
}
var
    filter
   ,fields_and
   ,_operator1
   ,_operand1
   ,_relation
   ,_operator2
   ,_operand2
   ,comma
            : string;

    i, j: integer;

    function GetOperand(oper: variant): string;
    var
        t: integer;
    begin
        // ��� ������ ������� "in" / "not in", ������� ����� �������, � ����� ������ ������ - ������� �������
        // ������ ����������, ��������� "in" - ��������������� �������� ��������
        t := VarType( oper );
        case t of
            varOleStr
           ,varString
           ,varVariant
                     : result := oper;
            varSmallInt
           ,varInteger
           ,varByte
           ,varWord
           ,varLongWord
           ,varInt64
                     : result := IntToStr(oper);
            varSingle
           ,varDouble
           ,varCurrency
                     : result := FloatToStr(oper);
            varDate
                     : result := DateTimeToStr(oper);

                     // : result := FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz', oper);  // �� ��������
                     // http://www.sql.ru/faq/faq_topic.aspx?fid=109

                     // ��������� �������� � DBGridEh. ��� ��������� ���� � ������ ���� �� ����
                     // ���������� (����������) ����������� ��� ������ � �����, ��� ��� �������������� ���� ����
                     // �� ������������ � ������� � ��������. 
                     // ������������ ����� - �� ������ ������ ���������� ��������� ��������������
                     // ������������ ����: FORMAT(created, 'd', 'de-de') AS created,
                     // ��� �������� ���� � �������� � ����, ���������������� �������������
                     // � ����� � �������� �������� ������� DateTimeToStr.
                     // ����� ������ ������ ������ ����������� � ������� ���� � ��������������,
                     // �� ������������ �� ��������� ����� ����������. ���������� �������� �� � ��� ����,
                     // ��� ��� ����������� � �������, ����� ���������� ������
            varBoolean
                     : result := ifthen(oper, '1', '0');
            else       result := '';
        end;
    end;

    function GetOperator(oper: TSTFilterOperatorEh): string;
    begin
        // DBGridEh �� ��-����������� ��������� ��������� ������� �������,
        // (��������, "~ TestStr%" ��� "like 'TestStr%'"), ����, �� �����������
        // ��� ���� (��������,
        // ���������� �� ��������� ��� ������ SQL �������
        case oper of
            foEqual          : result := ' {a} = ''{b}'' ';
            foNotEqual       : result := ' {a} <> ''{b}'' ';
            foGreaterThan    : result := ' {a} > ''{b}'' ';
            foLessThan       : result := ' {a} < ''{b}'' ';
            foGreaterOrEqual : result := ' {a} >= ''{b}'' ';
            foLessOrEqual    : result := ' {a} <= ''{b}'' ';
            foLike           : result := ' {a} like ''{b}'' ';
            foNotLike        : result := ' {a} not like ''{b}'' ';
            foNull           : result := ' {a} = '''' ';                        // ' {a} is NULL '
            foNotNull        : result := ' {a} <> '''' ';                       // ' {a} not is NULL '
            foEqualToNull    : result := ' {a} = '''' ';                        // ' {a} = NULL '
            foNotEqualToNull : result := ' {a} <> '''' ';                       // ' {a} <> NULL '

            // ��������� ������� ���� �������, ���� ������ � ������������ �������
            foAND            : result := '({1}) and ({2})';
            foOR             : result := '({1}) or ({2})';

            else               result := '';
            // ������� ���������
//            foIn             : result := '{a} in({b})';  // ������ �������� �� �������� �������� in
//            foNotIn          : result := '{a} not in({b})';
//            foValue          : result := '';             // ������ �� �������, ����� ������������
        end;
    end;
begin

    result := '';
    fields_and := '';
    filter := '';

    for I := 0 to grid.Columns.Count-1 do
    if grid.Columns[i].STFilter.ExpressionStr <> '' then
    begin

        // �������� �������� ���������
        _operand1 := GetOperand( grid.Columns[i].STFilter.Expression.Operand1 );
        _operand2 := GetOperand( grid.Columns[i].STFilter.Expression.Operand2 );

        // ��������� ����������
        _operator1 := GetOperator( grid.Columns[i].STFilter.Expression.Operator1 );
        _operator2 := GetOperator( grid.Columns[i].STFilter.Expression.Operator2 );

        _relation := GetOperator( grid.Columns[i].STFilter.Expression.Relation );
        // ���� �� ����� ������ ��������, ���������� ������ ��� ������
        if _relation = '' then _relation := '{1}';


        // ��� ������� ����� ������ � ���� ������� (��� ���������� ����������� �������)
        // �������� ��������� ��� foLike � ��������� ����� - ������ �������� ��� %, ��� �� ����� ������.
        // �������, ��� �������� foLike / foNotLike � �������� ����� ������������� � ���� ������ %
        // ��� ����� ��������������� ������. ���� � �������� ���� % ������ � ����� ������� - ��������� ��� ����,
        // ������������ ������ �������� ������ �� ������ ��� ����� ������
        if (grid.Columns[i].STFilter.Expression.Operator1 in [foLike, foNotLike]) and
           (Pos('%', _operand1) = 0)
        then
           _operand1 := '%'+_operand1+'%';

        if (grid.Columns[i].STFilter.Expression.Operator2 in [foLike, foNotLike]) and
           (Pos('%', _operand2) = 0)
        then
           _operand2 := '%'+_operand2+'%';


        // ����������� �������� � ��������
        _operator1 := ReplaceStr(_operator1, '{a}', grid.Columns[i].STFilter.DataField);
        _operator1 := ReplaceStr(_operator1, '{b}', _operand1);

        _operator2 := ReplaceStr(_operator2, '{a}', grid.Columns[i].STFilter.DataField);
        _operator2 := ReplaceStr(_operator2, '{b}', _operand2);

        // ��������� ��������� � ����� ������ ��� ������� �������
        _relation := ReplaceStr(_relation, '{1}', _operator1);
        _relation := ReplaceStr(_relation, '{2}', _operator2);

        // ������������ ������ ������� ��� ���� �������
        // ������ ������� �������� ����� ������������� ��������� - ����������
        if _relation <> '' then
        begin
            filter := filter + fields_and + _relation;
            fields_and := ' and ';
        end;
    end;

    // ����������� ���������� ����� �����
    if   ( Trim( addonPart ) <> '' ) and ( Trim( filter ) <> '' )
    then filter := '(' + addonPart + ') AND ( ' + filter + ' )'
//    then filter := addonPart + ' AND ' + filter
    else filter := addonPart + filter;

    lM('������: ' + filter);

    result := filter;

end;

end.
