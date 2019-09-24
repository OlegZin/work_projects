unit uDatatableManager;

////////////////////////////////////////////////////////////////////////////////
///
///    набор сервисных методов настройки таблиц для отображения данных в различных
///    конфигурациях, что позволяет через один компонент отображать различные
///    вариации столбцов для разных наборов данных
///
////////////////////////////////////////////////////////////////////////////////

interface

uses DBGridEh, StrUtils, Variants, SysUtils, uPhenixCORE, VCL.Controls, DB,
     VirtualTrees, VCL.Graphics, System.Types;

type

    TFieldInfo = record
        field: string;          // имя поля из датасета данные которого будем отображать
        caption: string;        // текст заголовка таблицы
        kind: integer;          // тип поля текст(0)/картинка(1)
        width: integer;         // ширина столбца
        sort_pass: boolean;     // пропускать ли для данного поля настройку возможности сортировки
        filter_pass: boolean;   // пропускать ли для данного поля настройку возможности фильтрации
        imagelist: TImageList;  // набор картинок для поля
        KeyList: string;        // строка с ключевыми значениями для imagelist
    end;

    TConfig = record
        name : string;                 // имя конфигурации
        fields : array of TFieldInfo;  // данные полей
        /// будут отображены только те поля, которые добавлены в этот массив и
        /// реально существуют в наборе данных
        /// при этом, порядок упоминания важен, поскольку именно в порядке от начала массива к концу
        /// столбцы будут добавляться в таблицу
    end;

    TDatatableManager = class
      public
        function GetFilterByColumns(grid: TDBGridEh; addonPart: string = ''): string;
            // получение sql строки для фильтра датасета из внутреннего формата фильтра грида
            // addonPart будет подставлено вначале фильтра

        function ConfigureForFilter(grid: TDBGridEh; pass: array of integer): boolean;
            // автоматическая настройка грида на работу с фильтрами столбцов
            // позволяет настроить нулевый грид для работы

        function ConfigureForSorting(grid: TDBGridEh; pass: array of integer): boolean;
            // автоматическая настройка грида на сортировку в столбцах
            // позволяет настроить нулевый грид для работы

        function CreateConfiguration( name: string ): boolean;
        /// создает новую пустую конфигурацию
        function ApplyConfiguration( name: string; grid: TDBGridEh ): boolean;
        /// применяет указанную конфигурацию к указанной таблице
        function AddConfigField(conf_name, _field_name, _caption: string; _kind, _width: integer;
            _sort_pass: boolean = false; _filter_pass: boolean = false; _imgList: TImagelist = nil; _keylist: string = '' ): boolean;

      private
        fConfig : array of TConfig;

        function Passed(index: integer; arr: array of integer): boolean;
            // находится ли указанный индекс колонки в списке пропускаемых при инициализации
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
/// находится ли указанный индекс колонки в списке пропускаемых при инициализации
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

    // ищем конфигурацию с указанным именем
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
/// для указанной конфигурации добавляем новое описание поля
var
    i : integer;
begin
    result := false;
    i := ConfIndex( conf_name );

    // конфигурация найдена
    if i = -1 then exit;

    // добавляем данные нового поля
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
/// для переданной таблицы настраниваем поля, согласно указанной конфигурации
///
var
    i, c : integer;
    col: TColumnEh;
    field: TFieldInfo;
begin
    i := ConfIndex( name );
    if i = -1 then exit;

    /// разрешаем автосортировку
    grid.OptionsEh := grid.OptionsEh + [dghAutoSortMarking];

    lE(grid.Columns[0].KeyList.CommaText);
    /// грохаем имеющиеся колонки
    grid.Columns.Clear;

    for c := Low(fConfig[i].fields) to High(fConfig[i].fields) do
    begin
        field := fConfig[i].fields[c];

        /// создаем новую колонку
        col := grid.Columns.Add;

        col.FieldName := field.field;
        col.Title.Caption := field.caption;

        SetColumnFilter( col, col.FieldName, grid.DataSource, not field.filter_pass );
        SetColumnSort( col, not not field.sort_pass );

        if field.kind = FIELD_KIND_TEXT then
        // текстовое поле
        begin
            col.Width := field.width
        end;

        // поле с иконкой
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

function TDatatableManager.CreateConfiguration(name: string): boolean;
var
    i: integer;
begin
    result := false;

    // не допускаем постор имени конфигурации
    for i := Low(fConfig) to High(fConfig) do
    if fConfig[i].name = name then exit;

    // создаем пустую
    SetLength( fConfig, Length(fConfig)+1);
    fConfig[High(fConfig)].name := name;

    result := true;
end;

function TDatatableManager.GetFilterByColumns(grid: TDBGridEh; addonPart: string = '' ): string;
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

    // приклеиваем переданную извне часть
    if   ( Trim( addonPart ) <> '' ) and ( Trim( filter ) <> '' )
    then filter := '(' + addonPart + ') AND ( ' + filter + ' )'
//    then filter := addonPart + ' AND ' + filter
    else filter := addonPart + filter;

    lM('Фильтр: ' + filter);

    result := filter;

end;

end.
