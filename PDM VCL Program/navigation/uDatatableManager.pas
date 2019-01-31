unit uDatatableManager;

interface

uses DBGridEh, StrUtils, Variants, SysUtils, uPhenixCORE;

type

    TDatatableManager = class
      public
        function GetFilterByColumns(grid: TDBGridEh): string;
            // получение sql строки для фильтра датасета из внутреннего формата фильтра грида

        function ConfigureForFilter(grid: TDBGridEh; pass: array of integer): boolean;
            // автоматическая настройка грида на работу с фильтрами столбцов
            // позволяет настроить нулевый грид для работы

        function ConfigureForSorting(grid: TDBGridEh; pass: array of integer): boolean;
            // автоматическая настройка грида на сортировку в столбцах
            // позволяет настроить нулевый грид для работы
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
{ метод принимает грид с настроенными колонками и донастраивает его для корректной работы с
  фильтром столбцов.

  pass - массив индексов столбцов, для которых не требуется настройка фильтра
         (будет не доступен для указанного столбца). имеет вид типа [0,3,5]

  ВАЖНО!
  датасет грида должен быть со включенной фильтрацией:
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
{ метод принимает грид с настроенными колонками и донастраивает его для корректной
  работы сортировки столбцов.

  pass - массив индексов столбцов, для которых не требуется настройка сортитровки
         (будет не доступен для указанного столбца). имеет вид типа [0,3,5]
}
var
    i: integer;
begin
    grid.OptionsEh := grid.OptionsEh + [dghAutoSortMarking];

    for I := 0 to grid.Columns.Count-1 do
        grid.Columns[i].Title.TitleButton := not Passed(i, pass);
end;

function TDatatableManager.GetFilterByColumns(grid: TDBGridEh): string;
{ используется в обработчике события OnApplyFilter компонента DBGridEh
  для формирования из строки внутреннего формата в sql cтроку фильтра
  для подстановки в датасет таблицы.

  внутренний формат грида возвращает что-то типа:
    '1'
    '>=1'
    '>1 AND <=5'
    '~ TestStr%'
    '!~ TestStr_'
    'in (1,2,3,4,5,6) and >100'
    'in (Str1,Str2,Str3)'
  т.е. нет имен полей и собственный подход к оператору like

  метод перебирает столбцы полученного грида, вычленяет из каждого строку
  фильтра, если есть, склеивает в общий sql-фильтр и возвращает его.

  полученную строку можно сразу подставлять в dataset.filter
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
        // при выборе условия "in" / "not in", операнд будет массвом, в любом другом случае - простой строкой
        // массив игнорируем, поскольку "in" - неподдерживаемй фильтром оператор
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

                     // : result := FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz', oper);  // не работает
                     // http://www.sql.ru/faq/faq_topic.aspx?fid=109

                     // очередная проблема с DBGridEh. при получении даты в чистом виде из базы
                     // обрезаются (обнуляются) милисекунды при показе в гриде, что при форматировании даты дает
                     // не соответствие с данными в датасете. 
                     // единственный выход - во вьюшке списка документов применить форматирование
                     // возвращаемой даты: FORMAT(created, 'd', 'de-de') AS created,
                     // что приводит дату в датасете к виду, соответствующему отображаемому
                     // в гриде и начинает работать обычный DateTimeToStr.
                     // можно задать полный формат отображения в столбце даты с миллисекундами,
                     // но пользователю не требуется такая информация. приходится получать ее в том виде,
                     // как она показывется в таблице, чтобы срабатывал фильтр
            varBoolean
                     : result := ifthen(oper, '1', '0');
            else       result := '';
        end;
    end;

    function GetOperator(oper: TSTFilterOperatorEh): string;
    begin
        // DBGridEh не по-человечески оформляет некоторые условия фильтра,
        // (например, "~ TestStr%" это "like 'TestStr%'"), плюс, не подставляет
        // имя поля (например,
        // приходится их подгонять под формат SQL вручную
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

            // операторы склейки двух условий, если заданы в конструкторе условий
            foAND            : result := '({1}) and ({2})';
            foOR             : result := '({1}) or ({2})';

            else               result := '';
            // спорные операторы
//            foIn             : result := '{a} in({b})';  // фильтр датасета не понимает оператор in
//            foNotIn          : result := '{a} not in({b})';
//            foValue          : result := '';             // вообще не понятно, когда возвращается
        end;
    end;
begin

    result := '';
    fields_and := '';
    filter := '';

    for I := 0 to grid.Columns.Count-1 do
    if grid.Columns[i].STFilter.ExpressionStr <> '' then
    begin

        // получаем значение операндов
        _operand1 := GetOperand( grid.Columns[i].STFilter.Expression.Operand1 );
        _operand2 := GetOperand( grid.Columns[i].STFilter.Expression.Operand2 );

        // получение операторов
        _operator1 := GetOperator( grid.Columns[i].STFilter.Expression.Operator1 );
        _operator2 := GetOperator( grid.Columns[i].STFilter.Expression.Operator2 );

        _relation := GetOperator( grid.Columns[i].STFilter.Expression.Relation );
        // если не задан второй оператор, используем шаблон для одного
        if _relation = '' then _relation := '{1}';


        // при простом вводе текста в поле фильтра (без применения построителя условия)
        // операция считается как foLike и введенный текст - точное значение без %, что не очень удобно.
        // поэтому, для операций foLike / foNotLike к значению сразу приклеевается с двух сторон %
        // для более функционального поиска. если в значении есть % только с одной стороны - оставляем как есть,
        // пользователь выбрал оператор поиска по началу или концу строки
        if (grid.Columns[i].STFilter.Expression.Operator1 in [foLike, foNotLike]) and
           (Pos('%', _operand1) = 0)
        then
           _operand1 := '%'+_operand1+'%';

        if (grid.Columns[i].STFilter.Expression.Operator2 in [foLike, foNotLike]) and
           (Pos('%', _operand2) = 0)
        then
           _operand2 := '%'+_operand2+'%';


        // подставляем операнды в операцию
        _operator1 := ReplaceStr(_operator1, '{a}', grid.Columns[i].STFilter.DataField);
        _operator1 := ReplaceStr(_operator1, '{b}', _operand1);

        _operator2 := ReplaceStr(_operator2, '{a}', grid.Columns[i].STFilter.DataField);
        _operator2 := ReplaceStr(_operator2, '{b}', _operand2);

        // связываем операторы в общую строку для текущей колонки
        _relation := ReplaceStr(_relation, '{1}', _operator1);
        _relation := ReplaceStr(_relation, '{2}', _operator2);

        // формирование строки фильтра для всех колонок
        // пустой операнд означает выбор некорректного оператора - игнорируем
        if _relation <> '' then
        begin
            filter := filter + fields_and + _relation;
            fields_and := ' and ';
        end;
    end;

    lM('Фильтр: ' + filter);

    result := filter;

end;

end.
