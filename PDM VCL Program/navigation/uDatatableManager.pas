unit uDatatableManager;

interface

uses DBGridEh, StrUtils, Variants, SysUtils, uPhenixCORE;

type

    TDatatableManager = class
      public
        function GetFilterByColumns(grid: TDBGridEh): string;
            // ��������� sql ������ ��� ������� �������� �� ����������� ������� ������� �����

        function ConfigureForFilter(grid: TDBGridEh; pass: array of integer): boolean;
            // �������������� ��������� ����� �� ������ � ��������� ��������
            // ��������� ��������� ������� ���� ��� ������

        function ConfigureForSorting(grid: TDBGridEh; pass: array of integer): boolean;
            // �������������� ��������� ����� �� ���������� � ��������
            // ��������� ��������� ������� ���� ��� ������
      private
        function Passed(index: integer; arr: array of integer): boolean;
    end;


implementation

{ TDatatableManager }

function TDatatableManager.Passed(index: integer;
  arr: array of integer): boolean;
var
   j: integer;
begin
   result := false;
   for j := 0 to High(arr) do
       if   arr[j] = index
       then result := true;
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
    if not Passed(i, pass) then
    begin
        grid.Columns[i].STFilter.DataField := grid.Columns[i].FieldName;
        grid.Columns[i].STFilter.ListSource := grid.DataSource;
        grid.Columns[i].STFilter.Visible := true;
    end else
        grid.Columns[i].STFilter.Visible := false;
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

function TDatatableManager.GetFilterByColumns(grid: TDBGridEh): string;
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

    lM('������: ' + filter);

    result := filter;

end;

end.
