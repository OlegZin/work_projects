unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ksTLB, ActiveX, ComObj, LDefin2D, StrUtils, Math, RegularExpressions, ksConstTLB,
  Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ReadKompassFile( filename: string );
    function Start_Kompas: boolean;
    function OpenDocument( filename: string): boolean;
  public
    { Public declarations }
    Kompas :KompasObject;
  end;

  TRow = array [0..8] of variant;
var
  Form2: TForm2;

  SpecDataArray: array of TRow;
    ///    массив данных, загруженных из файла спецификации.
    ///    содержит откорректированные данные, готовые для дальнейшей обработки:
    ///    корректировки имен, создания объектов в базе, построения структуры
    ///    содержит поля в указанном порядке:
    ///    (0) - секция. строка. тип объекта ('деталь', 'сборка', 'прочее',... )
    ///    (1) - обозначение. строка. (например, 'НПС5.01.02.120В зав.7774')
    ///    (2) - наименование. строка. (например, 'Устройство отборное')
    ///    (3) - исполнение. строка. (например, '', '01', '19')
    ///    (4) - количество. дробное.
    ///    (5) - комментарий. строка.
    ///    (6) - масса в кг. дробное
    ///    (7) - материал. строка.

const
    // синонимы колонок в массиве SpecDataArray
    FIELD_KIND  = 0;
    FIELD_MARK  = 1;
    FIELD_NAME  = 2;
    FIELD_ISP   = 3;
    FIELD_COUNT = 4;
    FIELD_COMM  = 5;
    FIELD_MASS  = 6;
    FIELD_MAT   = 7;
    FIELD_NUMBER = 8;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
        edit1.text := OpenDialog1.FileName;
        ReadKompassFile( OpenDialog1.FileName );
    end;
end;

function TForm2.OpenDocument(filename: string): boolean;
var
    SpcDocument: ksSpcDocument;
    Specification : ksSpecification;
    SpcTuningStyleParam : ksSpcTuningStyleParam;
    DynamicArray: ksDynamicArray;
    DocAttachedSpcParam: ksDocAttachedSpcParam;

    SpcObjParam: ksSpcObjParam;

    iterator: ksIterator;            // курсор для перебора элементов в спецификации
    item: integer;                   // текущий выбранный элемент в списке спецификации

    str, str2, comma : string;
    value : integer;
    block, isp: integer;

    ispNames: array of string;       // массив имен всех исполнений
    ispCount: integer;               // количество исполнений в последнем блоке
    ispFullCount: integer;           // количество исполнений в последнем блоке
    ispBlockCount: integer;          // количество блоков исполнений
    ///    в спецификации лист имеет книжную ориентацию и при большом количестве
    ///    исполнений (10 и более) они не помещаются в ширину на лист и переностяся
    ///    ниже по документу. данный перенос называется блоком спецификации.
    ///    т.е. первые 10 образуют первый блок, 11-20 второй и т.д.
    ///    по сути, это структура двухмерного массива

    I: Integer;

    ///    переменные для разового запоминания при переходе на новую позицию в спецификации.
    ///    в дальнейших записях, касющихся количества позиции в различных исполнениях (если есть)
    ///    большинство полей пусты. для единообразия массива, и его удобной
    ///    дальнейшей обработки, актуальные данные подставляются в каждую строку
    kind
   ,mark
   ,name
   ,note
   ,mass
   ,mat
   ,number
   ,lastMark
   ,lastName
   ,lastNumber

   ,filePath
            : string;

    function GetIspolNames: integer;
    ///    заполняем массив именами исполнений и возвращаем их количество.
    var
        isp, block : integer;
        name : string;
    begin

        // получаем количество блоков исполнений
        ispBlockCount := 0;
        name := specification.ksGetSpcPerformanceName( 0, 1, ispBlockCount );
        while name <> '' do
        begin
            Inc( ispBlockCount );
            name := specification.ksGetSpcPerformanceName( 0, 1, ispBlockCount );
        end;


        ispCount := 0;
        ispFullCount := 0;

        // перебираем все имеющиеся блоки
        for block := 0 to ispBlockCount-1 do
        begin

            // пытаемся получить первый элемент
            isp := 1;
            name := specification.ksGetSpcPerformanceName( 0, isp, block );

            // и перебираем все остальные если есть
            while name <> '' do
            begin

                // после прохождения одного блока, получим его максимальную размерность
                ispFullCount := Max( ispFullCount, isp );

                // дополняем массив имен исполнений
                SetLength( ispNames, Length( ispNames ) + 1 );
                ispNames[ High(ispNames) ] := name;

                // пытаемся получить имя следующего в блоке
                inc(isp);
                name := specification.ksGetSpcPerformanceName( 0, isp, block );

            end;
        end;

        // запоминаем количество элементов в последнем/единственном блоке
        ispCount := isp - 1;

    end;

    procedure CorrectionIspolNames;
    ///    подправляем имена для дальнейшего использования
    ///    требуется убрать все символы кроме цифр и добить
    ///    значения нулем, если номер из одной цифры.
    ///    таким образом, получим рад:
    ///    [пусто], 01, 02, 03,..
    var
        i : integer;
        reg: TRegEx;
        maches : TMatchCollection;
    begin

        // создаем регулярку, ищущую любое сочетание цифр, идущих подряд
        reg:=TRegEx.Create('\d+');

        for i := 0 to High( ispNames ) do
        begin

            // получаем из текущего имени числовую часть, отсекая все остальное
            maches := reg.Matches( ispNames[i] );

            // если найдено, присваиваем элементу списка с приклеиванием нуля, если необходимо
            // иначе, это первый элемент в списке исполнений, не имеющий номера
            if maches.Count > 0
            then ispNames[i] := ifthen( Length(maches[0].Value) <> 1, maches[0].Value, '0' + maches[0].Value )
            else ispNames[i] := '';

        end;
    end;
begin
    result := false;

    if not Assigned( Kompas ) then exit;
    if not FileExists( filename ) then exit;

    // обнуляем ранее загруженные данные
    SetLength( SpecDataArray, 0 );

    // получаем интерфейс работы со спецификациями
    SpcDocument := ksSpcDocument( Kompas.SpcDocument );

    // открываем файл спецификации
    if not SpcDocument.ksOpenDocument( filename, 4 ) then exit;
    // 0 - видимый документ, 1 - невидимый документ, 3 - видимый без синхронизации со сборочным чертежом
    // 4 - невидимый без синхронизации со сборочным чертежом
    // полезный эффект при открытии в невидимом режиме - подавление различных окон с предупреждениями и вопросами.
    // например, в видимом режиме постоянно предлагается перестроить спецификацию и только после ответа на
    // вопрос управление возвращается в программу. в невидимом режиме все проходит гладко
    // и компас не перехватывает инициативу

    // получаем ссылку на саму спецификацию
    specification := ksSpecification( SpcDocument.GetSpecification );

    // получаем массив имен исполнений и их количество
    GetIspolNames;
    // корректируем имена, приводя к стандарту
    CorrectionIspolNames;

    // создаем "курсор" для перебора объектов в текущй активной спецификации
    iterator := ksIterator( kompas.GetIterator() );
	iterator.ksCreateSpcIterator( '', 0, 0 );

    // если нечего перебирать (спецификация пуста), выходим
	if iterator.Reference = 0 then exit;

    // получаем первый элемент
    item := iterator.ksMoveIterator( 'F' );



    ///    загрузка данных в массив для дальнейшей обработки.
    ///
    ///    особенность файла спецификации в том, что для получения данных по количеству
    ///    в нужной спецификации нужно для полученного объекта перебрать все данные
    ///    с указанием номера исполнения и блока исполнений.
    ///
    ///    количестово блоков и их размерность определены при вызове GetIspolNames

    while SpcDocument.ksExistObj( item ) <> 0 do
    begin

        /// читаем прикрепленный к позиции файл
        filePath := '';

        SpcObjParam :=  ksSpcObjParam( kompas.GetParamStruct(ko_SpcObjParam) );
        SpcDocument.ksGetObjParam( item, SpcObjParam, ALLPARAM );
        DynamicArray := ksDynamicArray(SpcObjParam.GetDocArr);

        DocAttachedSpcParam  := ksDocAttachedSpcParam(kompas.GetParamStruct(ko_DocAttachSpcParam));

        if DynamicArray.ksGetArrayCount<>0 then
        begin
            for i := 0 to DynamicArray.ksGetArrayCount - 1 do
            begin
                DynamicArray.ksGetArrayItem(i, DocAttachedSpcParam);
                filePath := DocAttachedSpcParam.fileName;
                ShowMessage( 'Вложен файл: ' + filePath );
            end;
        end;


        // получаем базовые параметры позиции для базового исполнения
        kind := specification.ksGetSpcSectionName( item );
        note := specification.ksGetSpcObjectColumnText( item, SPC_CLM_NOTE,     1, 0 );
        mass := specification.ksGetSpcObjectColumnText( item, SPC_CLM_MASSA,    1, 0 );
        mat  := specification.ksGetSpcObjectColumnText( item, SPC_CLM_MATERIAL, 1, 0 );



        ///    чехорда с mark вместо простого получения объясняется тем, что есть
        ///    два стандарта записи обозначения в спецификации:
        ///    1)
        ///        'ТК-01-58.004'
        ///        'ТК-01-58.004-05'
        ///    2)
        ///        'ТК-01-58.004'
        ///        '-05'
        ///    как видно, во втором случае используется сокращенная форма, не обязательная
        ///    к использованию. для ее определения и приведение данных в массиве к единообразию
        ///    (первой форме записи) и применяется данный говнокод.
        ///
        ///    внутренний id позиции (number) применяется для случая, когда имя совпадает при
        ///    разных mark.
        ///    например, в данном случае сочетания позиций (два разных типа балок идущих подряд):
        ///        ТК-01-58.001-09  Балка
        ///        ТК-01-58.002     Балка
        ///    без учета номера произойдет сбой именования и имена последующих
        ///    позиций начнут склеиваться в длинную портянку
        ///
        lastMark := mark;
        lastName := name;
        lastNumber := number;

        name := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_NAME, 1, 0 ), name);
        name := ReplaceStr( name, '@/', '');   // убираем внутренний макрос Компаса на перенос строки

        number := FloatToStr(specification.ksGetSpcObjectNumber( item ));

        mark := ifthen( specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ) <> '', specification.ksGetSpcObjectColumnText( item, SPC_CLM_MARK, 1, 0 ), mark);

        ///    сокращенная форма будет короче, при том же имени и позиции спецификации
        ///    "та же позиция" означает, что в корректной спецификации все варианты какого-то объекта
        ///    с префиксом '-ХХ' идут под тем же номером позиции в списке, т.е. тем же number
        ///    например:
        ///        6  ТК-01-58.002    Балка
        ///           ТК-01-58.002-1  Балка
        ///           ТК-01-58.002-2  Балка
        ///    если в документе для всех объектов показать позицию, то все они имеют 6 номер
        if   (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( number = lastNumber )) or

        ///    обработка некорректно составленной спецификации с сокращенными обозначениями
        ///    и некорректной расстановкой позиций. так же под этот случай попадает вариант,
        ///    когда позиция выставлена верная, но внутренний number не совпадает
        ///    например:
        ///        6  ТК-01-58.002  Балка
        ///        7           -01  Балка
        ///        8           -02  Балка
             (( length(mark) < length(lastMark) ) and ( name = lastName ) and ( pos('-', mark) = 1 ))
        then mark := lastMark + mark;




        for block := 0 to ispBlockCount - 1 do
        for isp := 1 to ispFullCount do
        if not ((block = ispBlockCount - 1) and (isp > ispCount)) then  // проверка за выход количества элементов в последнем блоке

        if specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT, isp, block ) <> '' then // отсекаем пустые исполнения

        begin

            SetLength( SpecDataArray, Length( SpecDataArray ) + 1 );

            SpecDataArray[High( SpecDataArray )][FIELD_KIND]   := kind;

            SpecDataArray[High( SpecDataArray )][FIELD_MARK]   := mark;
            SpecDataArray[High( SpecDataArray )][FIELD_NAME]   := name;

            SpecDataArray[High( SpecDataArray )][FIELD_ISP]    := ispNames[ block * ispFullCount + isp - 1 ];
            SpecDataArray[High( SpecDataArray )][FIELD_COUNT]  := specification.ksGetSpcObjectColumnText( item, SPC_CLM_COUNT,    isp, block );

            SpecDataArray[High( SpecDataArray )][FIELD_COMM]   := note;
            SpecDataArray[High( SpecDataArray )][FIELD_MASS]   := mass;
            SpecDataArray[High( SpecDataArray )][FIELD_MAT]    := mat;
            SpecDataArray[High( SpecDataArray )][FIELD_NUMBER] := number;


        end;

        // получаем следующий элемент в списке спецификации
        item := iterator.ksMoveIterator( 'N' );
    end;



    for I := 0 to High(SpecDataArray) do

        Memo1.Lines.Add(
            '(' + SpecDataArray[i][FIELD_NUMBER] + ') ' +
            SpecDataArray[i][FIELD_KIND] + ' / ' +
            SpecDataArray[i][FIELD_MARK] + ' / ' +
            SpecDataArray[i][FIELD_NAME] + ' / ' +
            SpecDataArray[i][FIELD_ISP] + ' / ' +
            SpecDataArray[i][FIELD_COUNT] + ' / ' +
            SpecDataArray[i][FIELD_COMM] + ' / ' +
            SpecDataArray[i][FIELD_MASS] + ' / ' +
            SpecDataArray[i][FIELD_MAT]
        );


    result := true;
end;

procedure TForm2.ReadKompassFile(filename: string);
{ открываем файл компаса ком-объектом и пытаемся получить список путей
  всех вложенных файлов }
begin
    if not Start_Kompas then exit;

    OpenDocument( filename );

    Kompas.Quit;
    Kompas:=nil;
end;

function TForm2.Start_Kompas: boolean;
begin
    result := false;

    Kompas := KompasObject( CreateOleObject('Kompas.Application.5') );

    if Assigned( Kompas ) then
    begin
        Kompas.Visible := false;
        result := true;
    end;

end;


end.
