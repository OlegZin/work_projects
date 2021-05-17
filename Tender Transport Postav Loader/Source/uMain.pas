unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListBox, System.Rtti, FMX.Grid, ComObj,
  Data.DB, Data.Win.ADODB, FMX.ScrollBox, FMX.Memo, StrUtils, FMX.Objects, Math, shellApi;

const
    HELP_FILE = '\\server-htm\bdnft$\templates\TTLoader\Импорт данных поставщика.docx';

type

  TCellKind = (ckNone, ckMarshrut, ckTonnag, ckOtklon, ckPrice);

  TCellData = record
      value       : string[255];  // текст в ячейке
      kind        : TCellKind;    // тип ячейки
      marshrut_id : integer;      // маршрут. актуален для: ckMarshrut, ckPrice.
      group_id    : integer;      // группа маршрутов. актуален для: ckMarshrut, ckOtklon.
      tonnag_id   : integer;      // тоннаж. актуален для: ckTonnag, ckOtklon, ckPrice.
      error       : string[255];  // ошибка, если есть
      info        : string[255];  // подробная информация о данных в ячейке
      warning     : string[255];  // предупреждение, если есть

      city1       : string[255];  // вспомогательные поля для ячейки маршрутов,
      city2       : string[255];  // чтобы быстро создать отсутствующие в ТТ
  end;

  TfMain = class(TForm)
    cbTender: TComboBox;
    lCaptionTT: TLabel;
    lCaptionFile: TLabel;
    bOpenFile: TButton;
    sgData: TStringGrid;
    OpenDialog1: TOpenDialog;
    bImport: TButton;
    pbAnalyze: TProgressBar;
    lOperation: TLabel;
    Rectangle1: TRectangle;
    bAutoAnalyze: TButton;
    lCaptionKinds: TLabel;
    Image1: TImage;
    bSettingsAutoanalyze: TButton;
    bSetMarshrut: TButton;
    Button4: TButton;
    Image2: TImage;
    bSetOtklon: TButton;
    bSetTonnage: TButton;
    bAnalyze: TButton;
    bSetClear: TButton;
    rMarshColor: TRectangle;
    rOtklonColor: TRectangle;
    rTonnageColor: TRectangle;
    rEmptyColor: TRectangle;
    bSetData: TButton;
    rDataColor: TRectangle;
    lCaptionPostav: TLabel;
    lCaptionAnalyze: TLabel;
    lCaptionImport: TLabel;
    Layout1: TLayout;
    bPostavSelect: TButton;
    Rectangle2: TRectangle;
    lPostavName: TLabel;
    Rectangle3: TRectangle;
    lFilename: TLabel;
    lInfo: TLabel;
    lError: TLabel;
    lSystem: TLabel;
    bCreateMarshruts: TButton;
    lWarning: TLabel;
    bCitySprav: TButton;
    Image3: TImage;
    procedure bOpenFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTenderChange(Sender: TObject);
    function Log(mess: string): string;
    procedure Operation(mess: string);
    procedure IncProgress;
    procedure SetProgress(max : real);
    procedure ResetProgress;
    procedure Info(text : string);
    procedure Error(text: string);
    procedure Warning(text: string);
    procedure System(data: TCellData);
    procedure ClearMess;
    procedure bRereadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgDataDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure sgDataSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure bAutoAnalyzeClick(Sender: TObject);
    procedure bSetMarshrutClick(Sender: TObject);
    procedure bSetOtklonClick(Sender: TObject);
    procedure bSetTonnageClick(Sender: TObject);
    procedure bSetDataClick(Sender: TObject);
    procedure bSetClearClick(Sender: TObject);
    procedure sgDataMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure sgDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure sgDataClick(Sender: TObject);
    procedure bPostavSelectClick(Sender: TObject);
    procedure bAnalyzeClick(Sender: TObject);
    procedure bImportClick(Sender: TObject);
    procedure sgDataEditingDone(Sender: TObject; const Col, Row: Integer);
    procedure bCreateMarshrutsClick(Sender: TObject);
    procedure bSettingsAutoanalyzeClick(Sender: TObject);
    procedure rMarshColorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCitySpravClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    _filename: string;      /// имя исходного файла
    _isSelectMode: boolean; /// включен ли режим выделения группы ячеек
    _selHP: integer;
    _postavID : integer;    /// идентификатор поставщика

    _missMarsh : integer;   /// количество обноруженных отсутствующих маршрутов во время анализа
    allMarsh   : integer;   /// общее количество найденных в документе маршрутов

    /// координаты областей с различными типами ячеек данных.
    /// на их основе можно знать занимамое мето на листе и ориентацию (вертикальная, горизонтальная)
    /// что влияет на механизм распространения
    firstMarshCell,   // первая встреченная ячейка Маршрута
    lastMarshCell,    // последняя встреченная / текущая обрабатываемая

    firstTonnagCell,  // первая встреченная ячейка Тоннажа
    lastTonnagCell,   // последняя встреченная / текущая обрабатываемая

    firstOtklCell,    // первая встреченная ячейка Отклонения
    lastOtklCell,     // последняя встреченная / текущая обрабатываемая

    firstDataCell,    // первая встреченная ячейка Данных
    lastDataCell,     // последняя встреченная / текущая обрабатываемая

    selStart,         // начальная точка выделения ячеек в таблице
    selFinish         // конечная точка выделения ячеек в таблице
        : TPoint;

    DocData: array of array of TCellData;

    procedure SetFileName(const Value: string); /// текущий открытый xls
    procedure AnalyzeData;
    procedure AutoAnalyzeKinds;
    function LoadDataFromFile: boolean;
    function OpenFile: boolean;
    procedure CloseFile;
    procedure ClearPoints;
    procedure SelSetStartCoord(col, row: integer);
    procedure SelSetFinishCoord(col, row: integer);
    procedure SetKind(kind : TCellKind);

    /// методы проверяющие строку на принадлежность к определенным типам данных
    /// и интерпретирующие их
    procedure ReadAsMarshrut(var CellData: TCellData; value: string);
    procedure ReadAsTonnage( var CellData: TCellData; value: string);
    procedure ReadAsPrice( var CellData: TCellData);

    procedure CreateMarshruts; // создание в рамках ТТ всех не обнаруженных маршрутов.
    // потребуется один раз при первом импорте в новую тендерную таблицу.

    procedure ClearCellData(var cell: TCellData);
    procedure CellAddError(var cell: TCellData; error: string);
    procedure CellAddInfo(var cell: TCellData; info: string);
    procedure CellAddWarning(var cell: TCellData; info: string);

    procedure ShowData; // отображаем проанализированные данные таблицы
    function ClearUpName(name: string): string;

    procedure SetSelectMode(const Value: boolean);

    function ImportData: boolean;  /// импорт данных в базу. если успешно, возвращает истину
    procedure FullClearUp;
    procedure SetMissMarsh(const Value: integer);
    // полная очистка данных и настроек, для приведения программы в стартовое состояние

    procedure SaveINI;   // чтение настроек из файла
    procedure ReadINI;   // запись настроек в файл

  public
    property FileName: string read _filename write SetFileName;

    property isSelectMode: boolean read _isSelectMode write SetSelectMode;
        /// отвечает за выделение области ячеек
    property missMarsh : integer read _missMarsh write SetMissMarsh;

    function SetFileEnable(val: boolean): boolean;
    function SetPostavEnable(val: boolean): boolean;
    function SetKindsEnable(val: boolean): boolean;
    function SetAnalyzeEnable(val: boolean): boolean;
    function SetImportEnable(val: boolean): boolean;
  end;

var
    fMain: TfMain;

    exl: Variant;             // экземпляр экселя
    ExBk, ExSh: Variant;      // экземпляр книги и листа экселя
    exlRow, exlCol: integer;  // текущая ячейка


    // строка/строки с признаками разных типов полей
    shbl_Marshrut : string = 'ТЮМЕНЬ';
    shbl_Otklon : string   = 'ОТКЛОНЕН';
        // однозначный фрагмент фразы 'Стоимость одного км/ пробега при отклонении от основного маршрута'
    shbl_Tonnage : string  =
        '"до 1,5","до 1.5","от 1,5","от 1.5","от 5т","от 5 т","от 10т","от 10 т","от 18т","от 18 т",габаритный';

    MAX_TABLE_HEIGHT: integer = 150;   /// отвечает за ограничение поиска данных на листе в колонках и столбцах.
    MAX_TABLE_WIDTH: integer = 20;    /// отвечает за ограничение поиска данных на листе в колонках и столбцах.

    INI_FILENAME: string = 'settings.ini';

implementation

{$R *.fmx}

uses uDM, uSelect, uSetupAutoanalyze, IniFiles, uColorPicker, uCitySprav;

procedure TfMain.AnalyzeData;
/// анализ открытого документа excel на корректность данных и перенос их во
/// внутренний массив для отображения в таблице дальнейшей работы.
/// подразумевается, что типы ячеек в таблице уже определены (автоматически или вручную).
/// ячейки не имеющие типа будут проигнорированы.
///
///    работа в несколько этапов

///    Этап 1. Поиск маршрутов.
///    Ячейки файла анализируется слева направа, сверху вниз.
///    Исходя из логики документа, сначала мы должны обнаружить колонку маршрутов и отклонений.
///    Проанализировав ее и раздав ячейкам типы со значениями text, group_id, marshrut_id.
///    По завершении этапа получаем высоту таблицы (или ширину, в зависимости от ориентации).

///    Этап 2. Поиск тоннажей.
///    Начинаем анализ строк выше начала колонки маршрутов – там находятся признаки тоннажа.
///    Обнаружив их, распознав и раздав значения tonnage_id, получаем ширину таблицы.

///    Этап 3. Данные.
///    Все, что находится правее маршрутов и ниже тоннажа – данные.
///    Забиваем данные в ячейки массива и указываем тип ячеек.

///    Этап 4. Экстрополяция отклонений и маршрутов.
///    Перебираем колонку маршрутов и в строках, где попадаются ячейки отклонения – меняем тип всех ячеек на всю ширину таблицы.
///    Для ячеек маршрутов – заносим marshrut_id во все ячейки данных на всю ширину таблицы.

///    Этап 6. Экстрополяция тоннажа.
///    Перебираем все ячейки тоннажа и заносим значение tonnag_id во все ячейки столбца на всю высоту таблицы.

///    Этап 7. Обрезка.
///    Перебираем столбцы и строки и обрезаем те, которые содержат только мустые ячейки
var
    CellData: TCellData;
    i : integer;
    text: string;
begin

    /// сброс ошибок и сообщений
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        DocData[ exlCol, exlRow ].error := '';
        DocData[ exlCol, exlRow ].info := '';
        DocData[ exlCol, exlRow ].warning := '';
    end;



    missMarsh := 0;
    allMarsh  := 0;

    ///1 этап
    Operation('Обработка маршрутов...');
    ResetProgress;

    firstMarshCell.X := -1;
    firstMarshCell.Y := -1;
    lastMarshCell.X := -1;
    lastMarshCell.Y := -1;

    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        IncProgress;

        CellData := DocData[ exlCol, exlRow ];

        if CellData.kind = ckMarshrut then
        Begin
            Inc(allMarsh);

            // по данным в ячейке вычисляем по базе id объектов к которым относится (группа маршрутов, маршрут)
            ReadAsMarshrut( CellData, CellData.value );
            DocData[ exlCol,exlRow ] := CellData;

        End;

        /// в переборе так же встречаем ячейки-заголовки отклонений, подитоживающие группы маршрутов
        if CellData.kind = ckOtklon then
        Begin
            // отклонение относится к тойже группе маршрутов, что и послядняя
            // встреченная ячейка маршрута
            CellData.group_id := DocData[ lastMarshCell.X, lastMarshCell.Y ].group_id;

            DocData[ exlCol,exlRow ] := CellData;
        End;

    end;


    ///2 этап
    Operation('Обработка тоннажа...');
    ResetProgress;

    firstTonnagCell.X := -1;
    firstTonnagCell.Y := -1;
    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;

    firstOtklCell.X := -1;
    firstTonnagCell.Y := -1;
    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;

    /// поиск построчно.
    ///    в первой обнаруженной строке ожидается описание типов тоннажа
    ///    во второй - уточнение габарит/не габарит
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    begin
        IncProgress;

        CellData := DocData[ exlCol, exlRow ];

        if CellData.kind = ckTonnag then
        Begin
            // начальную точку облаcти с тоннажами
            if firstTonnagCell.X = -1 then
            begin
                firstTonnagCell.X := exlCol;
                firstTonnagCell.Y := exlRow;
            end;

            ReadAsTonnage( CellData, CellData.value );
            DocData[ exlCol,exlRow ] := CellData;

            // конечная точка облаcти с тоннажами
            lastTonnagCell.X := exlCol;
            lastTonnagCell.Y := exlRow;
        End;


        /// попутно обрабатываем горизонтально расположенные отклонения.
        ///    на предыдущем этапе вериакльным сканированием, обнаружены
        ///    строки с отклонениями среди маршрутов.
        ///    теперь, нужно распространить данные отклонения на всю строку
        if CellData.kind = ckOtklon then
        Begin

            // начальную точку облаcти с тоннажами.
            // строк отклоенений в документе несколько
            if (firstOtklCell.X = -1) or            // первая встреченная
               (firstOtklCell.Y <> lastOtklCell.Y)  // следующая встреченная
            then
            begin
                firstOtklCell.X := exlCol;
                firstOtklCell.Y := exlRow;
            end;

            CellData.group_id := DocData[firstOtklCell.X, firstOtklCell.Y].group_id;

            // проверка значения
            if (Trim(CellData.value) <> '') and (StrToFloatDef( Trim(CellData.value), -1) = -1)
            then CellAddError( CellData, 'Некорректное число' );

            DocData[ exlCol, exlRow ] := CellData;

            lastOtklCell.Y := exlRow;
        End;
    end;


    /// перебор всех клеток данных, выставление id и проверка значения на число
    Operation('Обработка данных...');
    ResetProgress;

    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    begin
        IncProgress;

        CellData := DocData[ exlCol, exlRow ];

        if CellData.kind = ckPrice then
        Begin
            ReadAsPrice( CellData );
            DocData[ exlCol, exlRow ] := CellData;
        End;
    end;

    ResetProgress;
    Operation('');

end;

procedure TfMain.ReadAsTonnage( var CellData: TCellData; value: string);
/// метод по данным ячейки пытается вычислить ее привязку к справочнику тоннажа.
/// сложность в том, что нужно учитывать данные двух строчек, чтобы определить
/// значение из справочника.
///
/// в первой содержатся значения вида: 'до 1,5 т.'
/// во второй линии значения типа: 'габаритный груз'
///
/// потому, нужно ориентироваться в какой линии сейчас мы находимся.
/// для этого использутся переменная начальной точки области тоннажа.
///
/// для первой строчки мы эстраполируем ранее встреченные тексты в пустые ячейки.
/// для второй строчки по комбинации текущего значения этой строчки и вешестоящей находим элемент справочника
///
Var
    tonnag: string;
    res: TTonnag;
begin
    // обработка верхней линии
    if (firstTonnagCell.Y = exlRow) then
    begin
        if Trim(value) = '' then
           // пишем предыдущее встреченное значние в текущую ячейку
           CellData.value := DocData[ lastTonnagCell.X, lastTonnagCell.Y].value;
    end else
    begin
        /// получаем id оригинального значения справочника по строкам из документа
        tonnag := Trim(value + ' ' + DocData[ exlCol, exlRow - 1 ].value);
        res := DM.GetTonnag( tonnag );

        if res.tonnag_id = -1 then
        begin

            fSelect.DecoratonState(false);
            fSelect.SetMarshrut('Тоннаж: ' + tonnag);
            fSelect.ClearList;

            DM.spTonnag.First;
            while not DM.spTonnag.Eof do
            begin
                fSelect.AddList(
                    DM.spTonnag.FieldByName('name').AsString,
                    TObject(DM.spTonnag.FieldByName('id').AsInteger)
                );
                DM.spTonnag.Next;
            end;

            if fSelect.ShowModal = mrOk then
            begin
                res.tonnag_id := Integer(fSelect.selData);
                res.tonnag := fSelect.selText;

                // сохраняем альтернативное сопоставление в базе
                DM.SaveTonnagAlternate(
                    Trim(value + ' ' + DocData[ exlCol, exlRow - 1 ].value),
                    res.tonnag_id
                );

                // переоткрытие справочника синонимов тоннажей
                DM.tTonnagAlternate.Close;
                DM.tTonnagAlternate.Open;

            end;
        end;

        CellData.tonnag_id := res.tonnag_id;
        CellData.info := 'ТОННАЖ:' + sLineBreak + res.tonnag;

    end;
end;


procedure TfMain.ReadINI;
var
    ini : TINIFile;
begin
    if not FileExists( ExtractFilePath(paramstr(0)) + INI_FILENAME ) then exit;

    ini := TIniFile.Create( ExtractFilePath(paramstr(0)) + INI_FILENAME );

    // шаблоны определения типов объектов
    shbl_Marshrut := ini.ReadString('', 'marshrut', shbl_Marshrut);
    shbl_Otklon   := ini.ReadString('', 'otklon',   shbl_Otklon);
    shbl_Tonnage  := ini.ReadString('', 'tonnage',  shbl_Tonnage);

    // цвета типов ячейки
    rMarshColor.Fill.Color   := TColor(ini.ReadInteger('', 'marshrut_color', Integer(rMarshColor.Fill.Color)));
    rOtklonColor.Fill.Color  := TColor(ini.ReadInteger('', 'otklon_color',   Integer(rOtklonColor.Fill.Color)));
    rTonnageColor.Fill.Color := TColor(ini.ReadInteger('', 'tonnage_color',  Integer(rTonnageColor.Fill.Color)));
    rDataColor.Fill.Color    := TColor(ini.ReadInteger('', 'price_color',    Integer(rDataColor.Fill.Color)));

    ini.Free;
end;

procedure TfMain.ReadAsMarshrut( var CellData: TCellData; value: string);
///    попытка интерпретации значения ячейки как маршрута.
///    формат строки:  Город1-Город2
///    так же по составу строки можно определить группу маршрутов:
///    1 группа () - Город1 = Тюмень (маршрут из Тюмени)
///    2 группа - Город2 = Тюмень (маршрут в Тюмень)
///    возможны другие типы маршрутов, но пока так.
var
    otherCity                // наименование города в паре с Тюменью
   ,codeCity                 // код города из справочника
            : string;
    cityArr : TNameArr;
    i : integer;
begin

    /// запоминаем, если это первая встреченная ячейка маршрута (начало области маршрутов)
    if firstMarshCell.X = -1 then
    begin
        firstMarshCell.X := exlCol;
        firstMarshCell.Y := exlRow;
    end;
    // запоминаем как текущую отбрабатываемую
    lastMarshCell.X := exlCol;
    lastMarshCell.Y := exlRow;


    // убираем избыточные пробелы для удобства работы
    value := trim(value);


    CellData.kind := TCellKind.ckMarshrut;
    CellData.value := value;



    // вычисляем код второго города, куда или откуда идет маршрут в тюмень
    otherCity := ReplaceStr(AnsiUpperCase(value), 'ТЮМЕНЬ', '');
    otherCity := ClearUpName(otherCity);

    cityArr := DM.GetCityCode(otherCity);
            // функция возвращает массив всех городов, на которые походит указанный

    if Length(cityArr) = 0
    then CellAddError( CellData, 'В справочнике не обнаружен код для города ' + otherCity)
    else

    if Length(cityArr) = 1
    then
    begin
        DM.SaveCityAlternate(
            otherCity,
            cityArr[ 0 ].city,
            cityArr[ 0 ].cityCode
        );

        codeCity := cityArr[0].cityCode;
        otherCity := cityArr[0].city;
    end
    else

    // покажем форму выбора верного варианта
    begin
        fSelect.DecoratonState(true);
        fSelect.SetMarshrut(value);
        fSelect.ClearList;

        for I := 0 to High(cityArr) do
           fSelect.AddList(
               cityArr[i].cityCode + ' - ' +
               cityArr[i].city +
               ifthen(cityArr[i].present_past, '', ' (нет маршрутов)'),
               nil
           );

        if fSelect.ShowModal = mrOk then
        begin
           // сохраняем альтернативное сопоставление в базе
           DM.SaveCityAlternate(
               otherCity,
               cityArr[ fSelect.selIndex ].city,
               cityArr[ fSelect.selIndex ].cityCode
           );

           codeCity := cityArr[ fSelect.selIndex ].cityCode;
           otherCity := cityArr[ fSelect.selIndex ].city;
        end else
        CellAddError( CellData, 'В справочнике не обнаружен код для города ' + otherCity);

    end;


    // определяем группу маршрутов
    if Pos('ТЮМЕНЬ', AnsiUpperCase(value)) = 1 then
    begin

        // устанавливаем группу маршрутов
        CellData.group_id := 0;

        CellData.city1 := DM.codeTyumen;
        CellData.city2 := codeCity;

        CellData.marshrut_id := DM.GetMarshrut(DM.codeTyumen, codeCity);
        if CellData.marshrut_id = -1 then
        begin
            CellAddWarning( CellData, 'Маршрут в рамках ТТ еще не создан');
            missMarsh := missMarsh + 1;
        end;

        CellAddInfo( CellData, 'МАРШРУТ:' + sLineBreak + 'ТЮМЕНЬ - ' + otherCity);
    end

    else if Pos('ТЮМЕНЬ', AnsiUpperCase(value)) = Length(value) - Length('ТЮМЕНЬ') + 1 then
    begin

        // устанавливаем группу маршрутов
        CellData.group_id := 1;

        CellData.city1 := codeCity;
        CellData.city2 := DM.codeTyumen;

        // устанавливаем маршрут
        CellData.marshrut_id := DM.GetMarshrut(codeCity, DM.codeTyumen);
        if CellData.marshrut_id = -1 then
        begin
            CellAddWarning( CellData, 'Маршрут в рамках ТТ еще не создан');
            missMarsh := missMarsh + 1;
        end;

        CellAddInfo( CellData, 'МАРШРУТ:' + sLineBreak + otherCity + ' - ТЮМЕНЬ');

    end else

    Begin

        CellAddError( CellData, 'Не удалось определить группу маршрутов');
        Log('Не удалось определить группу маршрутов для: ' + value);
        exit;

    End;

end;

procedure TfMain.ReadAsPrice(var CellData: TCellData);
/// выставляем ячейке значения маршрута и тоннажа
var
    i : integer;
begin
    // ищем тоннаж (в столбце выше ячейки)
    for I := exlRow-1 downto 0 do
    begin
        if DocData[ exlCol, i ].tonnag_id > -1 then
        begin
            CellData.tonnag_id := DocData[ exlCol, i ].tonnag_id;
            break;
        end;
    end;

    // ищем маршрут (в строке левее ячейки)
    for I := exlCol-1 downto 0 do
    begin
        if DocData[ i, exlRow ].marshrut_id > -1 then
        begin
            CellData.marshrut_id := DocData[ i, exlRow ].marshrut_id;
            break;
        end;
    end;

    // проверка значения
    if (Trim(CellData.value) <> '') and (StrToFloatDef( Trim(CellData.value), -1) = -1)
    then CellAddError( CellData, 'Некорректное число' );

end;

procedure TfMain.ResetProgress;
begin
    pbAnalyze.Value := 0;
    Application.ProcessMessages;
end;

procedure TfMain.rMarshColorClick(Sender: TObject);
begin
    if not Assigned( fColorPicker ) then
        fColorPicker := TfColorPicker.Create(self);

    fColorPicker.rectangle := (sender as TRectangle);

    fColorPicker.rColorPanel.Parent := fMain.Layout1;
    fColorPicker.rColorPanel.Position.X := bSetClear.Position.X;
    fColorPicker.rColorPanel.Position.Y := bSetClear.Position.y + bSetClear.Height;
end;

procedure TfMain.ShowData;
var
    col, row
        : integer;
begin

    // настройки таблицы для отображения
    // добавляем колонки
    while sgData.ColumnCount < MAX_TABLE_WIDTH do
    sgData.AddObject( TStringColumn.Create(sgData) );

    // или удаляем
    while sgData.ColumnCount > MAX_TABLE_WIDTH do
    sgData.Columns[ sgData.ColumnCount - 1 ].Destroy;

    sgData.RowCount := MAX_TABLE_HEIGHT;



    for row := 0 to MAX_TABLE_HEIGHT - 1 do
    for col := 0 to MAX_TABLE_WIDTH - 1 do
    begin
        sgData.Cells[col, row] := DocData[col, row].value;
    end;

end;


procedure TfMain.System(data: TCellData);
begin
    lSystem.Text := '';

    if data.marshrut_id > -1 then
    lSystem.Text := lSystem.Text + 'marshrut_id = ' + IntToStr(data.marshrut_id) + sLineBreak;

    if data.group_id > -1 then
    lSystem.Text := lSystem.Text + 'group_id = ' + IntToStr(data.group_id) + sLineBreak;

    if data.tonnag_id > -1 then
    lSystem.Text := lSystem.Text + 'tonnag_id = ' + IntToStr(data.tonnag_id);
end;


procedure TfMain.bOpenFileClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
   begin
       FileName := OpenDialog1.FileName;

       if not OpenFile then exit;

       LoadDataFromFile;

       CloseFile;

       ShowData;

       SetPostavEnable( True );
   end;
end;

procedure TfMain.bPostavSelectClick(Sender: TObject);
begin
    fSelect.SetMarshrut('Поставщик');
    fSelect.DecoratonState(false);
    fSelect.ClearList;


    Operation('Построение справочника поставщиков...');
    ResetProgress;

    DM.spPostav.First;
    while not DM.spPostav.eof do
    begin
       fSelect.AddList(
           DM.spPostav.FieldByName('naim').AsString + ' ' +
           DM.spPostav.FieldByName('inn').AsString,
           TObject(DM.spPostav.FieldByName('ID').AsInteger)
       );

       IncProgress;

       DM.spPostav.next;
    end;

    Operation('');
    ResetProgress;


    if fSelect.ShowModal = mrOk then
    begin
        _postavID := Integer(fSelect.selData);
        lPostavName.Text := fSelect.selText;

        SetKindsEnable( true );
        SetAnalyzeEnable( true );
    end;

end;

procedure TfMain.bRereadClick(Sender: TObject);
begin
    ShowData;
end;

procedure TfMain.bSetClearClick(Sender: TObject);
begin
    SetKind( TCellKind.ckNone );
    sgData.Repaint;
end;

procedure TfMain.bSetDataClick(Sender: TObject);
begin
    SetKind( TCellKind.ckPrice );
    sgData.Repaint;
end;

procedure TfMain.bSetMarshrutClick(Sender: TObject);
begin
    SetKind( TCellKind.ckMarshrut );
    sgData.Repaint;
end;

procedure TfMain.bSetOtklonClick(Sender: TObject);
begin
    SetKind( TCellKind.ckOtklon );
    sgData.Repaint;
end;

procedure TfMain.bSettingsAutoanalyzeClick(Sender: TObject);
begin
    if not Assigned(fSetupAutoanalyze) then
        fSetupAutoanalyze := TfSetupAutoanalyze.Create(self);

    fSetupAutoanalyze.marshrut := shbl_Marshrut;
    fSetupAutoanalyze.otklon   := shbl_Otklon;
    fSetupAutoanalyze.tonnag   := shbl_Tonnage;

    if fSetupAutoanalyze.ShowModal = mrOk then
    begin
        shbl_Marshrut := fSetupAutoanalyze.marshrut;
        shbl_Otklon   := fSetupAutoanalyze.otklon;
        shbl_Tonnage  := fSetupAutoanalyze.tonnag;

        SaveINI;
    end;
end;

procedure TfMain.bSetTonnageClick(Sender: TObject);
begin
    SetKind( TCellKind.ckTonnag );
    sgData.Repaint;
end;

procedure TfMain.Button4Click(Sender: TObject);
begin
    if FileExists( HELP_FILE ) then
    ShellExecute(0,'open',HELP_FILE,nil,nil,1{SW_SHOWNORMAL});
end;

procedure TfMain.SetKind(kind : TCellKind);
var
    top, bottom, left, right : integer;
    col, row: integer;
begin
    top := Min(selStart.Y, selFinish.Y);
    bottom := Max(selStart.Y, selFinish.Y);
    left := Min(selStart.X, selFinish.X);
    right := Max(selStart.X, selFinish.X);

    for row := top to bottom do
    for col := left to right do
    DocData[ col, row ].kind := kind;

end;

function TfMain.SetKindsEnable(val: boolean): boolean;
begin
    result := val;
    bAutoAnalyze.Enabled := val;
    bSetMarshrut.Enabled := val;
    bSetOtklon.Enabled := val;
    bSetTonnage.Enabled := val;
    bSetData.Enabled := val;
    bSetClear.Enabled := val;

    if val
    then lCaptionKinds.FontColor := TAlphaColorRec.Black
    else lCaptionKinds.FontColor := TAlphaColorRec.Gray;

end;

procedure TfMain.SetMissMarsh(const Value: integer);
begin
    _missMarsh := value;

    if value <> 0 then
    begin
        bCreateMarshruts.Enabled := true;
        bCreateMarshruts.Text := 'Создать маршруты (' + IntToStr(missMarsh) + ')'
    end else
    begin
        bCreateMarshruts.Enabled := false;
        bCreateMarshruts.Text := 'Создать маршруты';
    end;



end;

procedure TfMain.AutoAnalyzeKinds;
/// сканируя данные, определяем типы ячеек и занимаемые ими области.
/// этот метод заменяет ручную расстановку типов пользователем.
/// по идее, она должна быть достаточно эффективной, чтобы пользователю не пришлось работать руками.
/// в случае ошибок алгоритма, пользователь может руками подправить огрехи перед анализом данных.
///
/// непосредственное значение далеко не всегда дает возможность определить тип ячейки.
/// к примеру, ячейка данных может быть пустой, а потому, по значениям невозможно точно определить границы области данных.
/// но, границы данных отлично описывает пересечение маршрутов(строк) и тоннажей (столбцов).
/// так же, габариты области тоннажа является ориентиром размера областей цен отклонений.
///    Алгоритм:
///    1. прогоняем все ячейки, пытаясь распознать типы: маршрут, тоннаж, отклонения.
///       этот процесс не занимается анализом данных на достоверность, а просто ориентируется на внешние признаки,
///       заранее заданные пользователем.
///       например, маршрут обязательно содержит "Тюмень", тоннаж фразы типа "от 1,5т" и т.д.
///    2. во время прогона запоминаем крайние координаты каждого типа обнаруженных ячеек:
///       самая верхняя, самая правая и т.д. Это позволяет вычислить занимаемую область.
///    3. по граничным координатам заполняем пробелы в типах ячеек
var
    CellData: TCellData;
    text: string;
    list: TStringList;

    _top, _left, _right, _bottom: integer;   // границы области тоннажа      \
    lastKind : TCellKind;

    function inList(shablon, text: string): boolean;
    var
        i : integer;
    begin
        result := false;

        list.CommaText := shablon;

        for I := 0 to list.Count-1 do
        if Pos(AnsiUpperCase(list[i]), AnsiUpperCase(text)) > 0
        then
           result := true;
    end;

    function IsMarshrut(text: string): boolean;
    /// определяет, является ли ячейка маршрутом.
    /// поскольку шаблон поиска может быть набором строк, работем через список
    begin
        result := inList( shbl_Marshrut, text );

        if not result then exit;

        /// запоминаем, если это первая встреченная ячейка маршрута (начало области маршрутов)
        if firstMarshCell.X = -1 then
        begin
            firstMarshCell.X := exlCol;
            firstMarshCell.Y := exlRow;
        end;

        // запоминаем как вторую точку ограничения области
        lastMarshCell.X := exlCol;
        lastMarshCell.Y := exlRow;
    end;


    function IsOtklon(text: string): boolean;
    /// определяет, является ли ячейка заголовком строки отклонений
    begin
        result := inList( shbl_Otklon, text );
    end;

    function IsTonnag(text: string): boolean;
    /// определяет, является ли ячейка тоннажом
    begin
        result := inList( shbl_Tonnage, text );

        if not result then exit;

        /// запоминаем, если это первая встреченная ячейка тоннажа (начало области)
        if firstTonnagCell.X = -1 then
        begin
            firstTonnagCell.X := exlCol;
            firstTonnagCell.Y := exlRow;
        end;

        // запоминаем как вторую точку ограничения области
        lastTonnagCell.X := exlCol;
        lastTonnagCell.Y := exlRow;
    end;

begin

    Operation('1/3 Определение ячеек маршрутов...');
    ResetProgress;

    list := TStringList.Create;

    firstMarshCell.X := -1;
    firstMarshCell.Y := -1;
    lastMarshCell.X := -1;
    lastMarshCell.Y := -1;

    firstTonnagCell.X := -1;
    firstTonnagCell.Y := -1;
    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;


    // в первый проход находим столбец маршрутов с вкраплением заголовок строчек отклонений.
    // позднее эти отклонения нужно будет "растянуть" на ширину заголовка тоннажа
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin

        IncProgress;



        text := DocData[ exlCol, exlRow ].value;

        if IsMarshrut(text) then DocData[ exlCol,exlRow ].kind := ckMarshrut else
        if IsOtklon(text)   then DocData[ exlCol,exlRow ].kind := ckOtklon else
        DocData[ exlCol,exlRow ].kind := ckNone;

    end;


    Operation('2/3 Определение ячеек тоннажа...');
    ResetProgress;

    /// поиск тоннажа построчным перебором, поскольку предполагается, что он
    /// содержится в шапке импортируемой таблицы.
    ///   при этом, есть тонкость, что значимыми являются и все пустые ячейки в рамках всей области тоннажей,
    ///   однако, до определения границ этой области нельзя быть уверенным, что текущая ячейка является тоннажом.
    ///   поскольку в первой строке заголовка находятся группирующие значения и где они заканчиваются,
    ///   можно сказать только после прохода второй строки, где нет пустых ячеек.
    /// так что, определение тоннажа - двухфазная работа:
    ///    - проходим по всему документу, определяя непустые ячейки тоннажа и границы области
    ///    - повторно проходим по ячейкам области и уверенно раздаем признак тоннажа пустым ячейкам
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    begin

        IncProgress;

        text := DocData[ exlCol, exlRow ].value;

        if IsTonnag(text)  then DocData[ exlCol,exlRow ].kind := ckTonnag;

    end;

    _top := Min(firstTonnagCell.Y, lastTonnagCell.Y);
    _bottom := Max(firstTonnagCell.Y, lastTonnagCell.Y);
    _left := Min(firstTonnagCell.X, lastTonnagCell.X);
    _right := Max(firstTonnagCell.X, lastTonnagCell.X);

    for exlRow := _top to _bottom do
    for exlCol := _left to _right do
    begin
        DocData[ exlCol,exlRow ].kind := ckTonnag;
    end;



    Operation('3/3 Определение ячеек данных...');
    ResetProgress;

    /// на данном этапе можно уже определить где находятся данные: это пересечение
    /// координат областей маршрутов и тоннажа. поскольку, на данном этапе не
    /// требуется контроль данных, относим к данным все ячейки подряд.
    /// дополнительно, на этом этапе требуется "растянуть" области отклонений на ширину данных.

    /// определяем область, в которой содержатся данные.
    ///    будем захватывать и область маршрутов, чтобы была возможность определить
    ///    к данным или отклоенеиям относится текущая обрабатываемая строка.
    /// +1 количеству строк, поскольку нам нужна и стрка последнего отклонения

    /// предполагается, что тип ячеек очищен на этапе поиска маршрутов

    for exlRow := firstMarshCell.Y to lastMarshCell.Y + 1 do
    for exlCol := firstMarshCell.X to lastTonnagCell.X do
    begin

        IncProgress;

        // запоминаем тип последней встреченной типизированной ячейки
        if   DocData[ exlCol,exlRow ].kind <> ckNone
        then lastKind := DocData[ exlCol,exlRow ].kind;

        if DocData[ exlCol,exlRow ].kind <> ckNone then Continue;

        if lastKind = ckMarshrut then DocData[ exlCol,exlRow ].kind := ckPrice;
        if lastKind = ckOtklon then DocData[ exlCol,exlRow ].kind := ckOtklon;

    end;



    ResetProgress;
    Operation('');

    list.Free;
end;

procedure TfMain.bAnalyzeClick(Sender: TObject);
begin
    AnalyzeData;
    ShowData;

    sgData.Repaint;

    DM.OpenAlternate;

    SetImportEnable( missMarsh = 0 );
end;

procedure TfMain.bAutoAnalyzeClick(Sender: TObject);
begin
     AutoAnalyzeKinds;
     sgData.Repaint;
end;

procedure TfMain.bCitySpravClick(Sender: TObject);
begin
    if not Assigned( fCitySprav ) then
        fCitySprav := TfCitySprav.Create(self);

    fCitySprav.Clear;

    DM.spCityAlternate.First;
    while not DM.spCityAlternate.eof do
    begin
        fCitySprav.AddItem(
          [ DM.spCityAlternate.FieldByName('city').AsString,
            DM.spCityAlternate.FieldByName('alt_city').AsString,
            DM.spCityAlternate.FieldByName('alt_code').AsString ],

            DM.spCityAlternate.FieldByName('id').AsInteger
        );
        DM.spCityAlternate.next;
    end;


    fCitySprav.ShowModal;

    if fCitySprav.wasDeleted = true then
    begin
        DM.OpenAlternate;
        bAnalyze.OnClick(bAnalyze);
    end;

end;

procedure TfMain.bCreateMarshrutsClick(Sender: TObject);
begin
    // если есть отсутствующие маршруты и при этом их количество не совпадает с общим,
    // есть подозрение на ошибку пользователя. Поскольку в новой тендерной таблице это
    // количество должно совпадать. Возможно, пользователь выбрал тендер и файл поставщика
    // за разные года, где список маршрутов отличается.
    if (missMarsh > 0) and (missMarsh <> allMarsh) then
    if MessageDlg(
        'Это не первая загрузка данных в тендерную таблицу и обнаружены новые маршруты.' + sLineBreak +
        'Возможно, вы ошиблись при выборе таблицы или открыли файл не за тот год.' + sLineBreak +
        'Вы уверены, что корректно выбрали тендерную таблицу и загружаемый файл?',
        TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
        0
    ) = mrNo then exit;

    /// создаем новые маршруты
    CreateMarshruts;

    /// переоткрываем базу для получения обновленного списка
    DM.InitDB;

    /// снова прогоняем анализ
    AnalyzeData;
    ShowData;
    sgData.Repaint;

    SetImportEnable( missMarsh = 0 );
end;

procedure TfMain.bImportClick(Sender: TObject);
begin
    // если импорт удался, все данные очищаются, кроме выбранного тендера
    if   ImportData
    then FullClearUp;
end;

procedure TfMain.cbTenderChange(Sender: TObject);
begin
    if cbTender.ItemIndex = -1 then exit;

    DM.TenderId := integer(cbTender.Items.Objects[ cbTender.ItemIndex ]);
    ClearPoints;
    DM.InitDB;
    DM.OpenAlternate;

    SetFileEnable( DM.AllowDBStructure );
end;

procedure TfMain.CellAddError(var cell: TCellData; error: string);
begin
    cell.error := cell.error + error + sLineBreak;
end;

procedure TfMain.CellAddInfo(var cell: TCellData; info: string);
begin
    cell.info := cell.info + info + sLineBreak;
end;

procedure TfMain.CellAddWarning(var cell: TCellData; info: string);
begin
    cell.warning := cell.warning + info + sLineBreak;
end;

procedure TfMain.ClearCellData(var cell: TCellData);
begin
//    cell.value := '';
    cell.kind := ckNone;
    cell.marshrut_id := -1;
    cell.group_id := -1;
    cell.tonnag_id := -1;
    cell.error := '';
    cell.info := '';
    cell.city1 := '';
    cell.city2 := '';
    cell.warning := '';
end;

procedure TfMain.ClearMess;
begin
    lInfo.Text := '';
    lError.Text := '';
    lSystem.Text := '';
    lWarning.Text := '';
end;

procedure TfMain.ClearPoints;
begin
    firstMarshCell.X := -1;
    firstMarshCell.Y := -1;

    lastMarshCell.X := -1;
    lastMarshCell.Y := -1;

    firstTonnagCell.X := -1;
    firstTonnagCell.Y := -1;

    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;

    firstDataCell.X := -1;
    firstDataCell.Y := -1;

    lastDataCell.X := -1;
    lastDataCell.Y := -1;
end;

function TfMain.ClearUpName(name: string): string;
/// метод очищает наименование города от мусора.
///    исходник - маршрут с вырезанным наименованием Тюмени
///    может содержать лишние пробелы или символы минуса справа и слева.
///    от них нужно избавиться, тогда получится более-менее адекватное наименование города
begin
    name := trim(name);
    if name[1] = '-' then name[1] := Char(' ');
    if name[Length(name)] = '-' then name[length(name)] := Char(' ');
    name := trim(name);
    result := name;
end;

procedure TfMain.CloseFile;
begin
    exl.Visible := false;
    exl := Unassigned;
end;

procedure TfMain.CreateMarshruts;
/// перебираем все маршруты и скармливаем хранимой процедуре,
/// которая создаст недостающие.
/// делается отдельным от анализа методом по причине возможной ошибки
/// пользователя при выборе тендерной таблицы/файла.
/// большое количество различий после анализа, при наличии созданных маршрутов намекает на ошибку и
/// есть микроскопическая вероятность, что пользователь на это как-то среагирует.
begin

    Operation('Создание недостающих маршрутов...');
    ResetProgress;

    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        IncProgress;

        if DocData[ exlCol, exlRow ].kind = ckMarshrut then
        DM.CreateMarshrut(
            DocData[ exlCol, exlRow ].group_id,
            DocData[ exlCol, exlRow ].city1,
            DocData[ exlCol, exlRow ].city2
        );

    end;

    DM.OpenMarshrut;

    ResetProgress;
    Operation('');

end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SaveINI;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
    SetProgress( MAX_TABLE_HEIGHT * MAX_TABLE_WIDTH );
    ResetProgress;
    Operation('');

    // инициализируем массив данных
    SetLength(DocData, 0, 0);
    SetLength(DocData, MAX_TABLE_WIDTH, MAX_TABLE_HEIGHT);
end;

procedure TfMain.FormShow(Sender: TObject);
begin

   if not DM.OpenQuery(SQL_GET_TENDER_LIST) then exit;

   while not DM.ADOQuery.Eof do
   begin

       cbTender.Items.AddObject(

           Format( '%s (%s) %s-%s',
               [   DM.ADOQuery.FieldByName('NAME').AsString,
                   DM.ADOQuery.FieldByName('TD_NUM').AsString,
                   DM.ADOQuery.FieldByName('DATE_BEGIN').AsString,
                   DM.ADOQuery.FieldByName('DATE_END').AsString
               ]
           ),
           TObject(DM.ADOQuery.FieldByName('ID').AsInteger)

       );

       DM.ADOQuery.Next;
   end;

   SetFileEnable(false);
   SetPostavEnable(false);
   SetKindsEnable(false);
   SetAnalyzeEnable(false);
   SetImportEnable(false);

   ClearMess;
   missMarsh := 0;

   ReadINI;
end;


procedure TfMain.FullClearUp;
var
    row, col: integer;
begin

    FileName := '';

    _postavID := 0;
    lPostavName.Text := '';
    SetPostavEnable( false );

    SetKindsEnable( false );
    SetAnalyzeEnable( false );
    SetImportEnable( false );

    // очистка данных
    while sgData.ColumnCount > 0 do
    sgData.Columns[ sgData.ColumnCount - 1 ].Destroy;

    sgData.RowCount := MAX_TABLE_HEIGHT;

    for row := 0 to MAX_TABLE_HEIGHT - 1 do
    for col := 0 to MAX_TABLE_WIDTH - 1 do
        ClearCellData( DocData[col, row] );

end;

function TfMain.ImportData: boolean;
/// импорт распознанных данных в базу. на данный моент есть следующие условия:
///    - тендерная таблица выбрана
///    - группы маршрутов и маршруты в базе существуют
///    - все корректно заполненные ячейки имеют все необходимые данные для импорта
///    - некорректные ячейки имеют непустое значение CellData.error и буду проигнорированы
/// для непосредственного импорта нужно просканировать весь документ и каждую
/// корректную ячейку данных скормить хранимой процедуре.
/// уже существующие в базе данные с такими параметрами будут обновлены.
begin
    DM.ClearData;

    Operation('Импорт данных...');
    ResetProgress;

    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        IncProgress;

        /// непустая, корректная ячейка данных
        if (DocData[ exlCol, exlRow ].kind = ckPrice) and
           (DocData[ exlCol, exlRow ].value <> '') and
           (DocData[ exlCol, exlRow ].error = '')
        then
           DM.InsertData(
               DocData[ exlCol, exlRow ].marshrut_id,
               DocData[ exlCol, exlRow ].tonnag_id,
               _postavID,
               StrToFloat(DocData[ exlCol, exlRow ].value)
           );

        // непустая, корректная ячейка отклонения
        if (DocData[ exlCol, exlRow ].kind = ckOtklon) and
           (DocData[ exlCol, exlRow ].value <> '') and
           (DocData[ exlCol, exlRow ].error = '')
        then
           DM.InsertOtklon(
               DocData[ exlCol, exlRow ].marshrut_id,
               DocData[ exlCol, exlRow ].tonnag_id,
               _postavID,
               StrToFloat(DocData[ exlCol, exlRow ].value)
           );

    end;

    ResetProgress;
    Operation('');

    result := true;
end;

procedure TfMain.IncProgress;
begin
    pbAnalyze.Value := pbAnalyze.Value + 1;
    Application.ProcessMessages;
end;

procedure TfMain.Info(text: string);
begin
    lInfo.Text := text;
end;

procedure TfMain.Error(text: string);
begin
    lError.Text := text;
end;

procedure TfMain.Warning(text: string);
begin
    lWarning.Text := text;
end;

function TfMain.LoadDataFromFile: boolean;
/// открываем файл, переносим данные в массив, закрываем файл.
/// постоянный экземпляр excel в памяти нам не нужен.
var
    CellData: TCellData;
    text : string;
begin

    result := false;

    try

        Operation('Чтение данных из файла...');
        ResetProgress;
        SetProgress( MAX_TABLE_WIDTH * MAX_TABLE_HEIGHT );

        for exlCol := 1 to MAX_TABLE_WIDTH do
        for exlRow := 1 to MAX_TABLE_HEIGHT do
        begin
            IncProgress;

            text := exl.cells[exlRow, exlCol];

            ClearCellData( CellData );
            CellData.value := text;

            DocData[exlCol-1,exlRow-1] := CellData;
        end;

        ResetProgress;
        Operation('');

        result := true;

    except
    end;
end;

function TfMain.Log(mess: string): string;
begin
    result := mess;
end;

function TfMain.OpenFile: boolean;
begin
  result := false;

  Cursor := crHourGlass;

  exl := CreateOleObject('Excel.Application');
  if not (Vartype(exl)=VarDispatch) then Exit;
//  exl.Visible := True;
  ExBk := exl.Workbooks.Open(FileName);
  ExSh := ExBk.Sheets[1];

  Cursor := crDefault;

  result := true;
end;



procedure TfMain.Operation(mess: string);
begin
    lOperation.Text := mess;
end;

procedure TfMain.SaveINI;
var
    ini : TINIFile;
begin
    ini := TIniFile.Create( ExtractFilePath(paramstr(0)) + INI_FILENAME );

    // шаблоны определения типов объектов
    ini.WriteString('', 'marshrut', shbl_Marshrut);
    ini.WriteString('', 'otklon',   shbl_Otklon);
    ini.WriteString('', 'tonnage',  shbl_Tonnage);

    // цвета типов ячейки
    ini.WriteInteger('', 'marshrut_color', rMarshColor.Fill.Color );
    ini.WriteInteger('', 'otklon_color',   rOtklonColor.Fill.Color );
    ini.WriteInteger('', 'tonnage_color',  rTonnageColor.Fill.Color );
    ini.WriteInteger('', 'price_color',    rDataColor.Fill.Color );

    ini.Free;
end;

procedure TfMain.SelSetFinishCoord(col, row: integer);
begin
    selFinish.X := col;
    selFinish.Y := row;
end;

procedure TfMain.SelSetStartCoord(col, row: integer);
begin
    selStart.X := col;
    selStart.Y := row;
end;

function TfMain.SetAnalyzeEnable(val: boolean): boolean;
begin
    result := val;
    bAnalyze.Enabled := val;
    bCitySprav.Enabled := val;

    if val
    then lCaptionAnalyze.FontColor := TAlphaColorRec.Black
    else lCaptionAnalyze.FontColor := TAlphaColorRec.Gray;
end;

function TfMain.SetFileEnable(val: boolean): boolean;
begin
    result := val;
    bOpenFile.Enabled := val;

    if val
    then lCaptionFile.FontColor := TAlphaColorRec.Black
    else lCaptionFile.FontColor := TAlphaColorRec.Gray;
end;

procedure TfMain.SetFileName(const Value: string);
begin
    _filename := Value;
    lFilename.Text := ExtractFileName(Value);
end;


function TfMain.SetImportEnable(val: boolean): boolean;
begin
    result := val;
    bImport.Enabled := val;

    if val
    then lCaptionImport.FontColor := TAlphaColorRec.Black
    else lCaptionImport.FontColor := TAlphaColorRec.Gray;
end;

function TfMain.SetPostavEnable(val: boolean): boolean;
begin
    result := val;
    bPostavSelect.Enabled := val;

    if val
    then lCaptionPostav.FontColor := TAlphaColorRec.Black
    else lCaptionPostav.FontColor := TAlphaColorRec.Gray;

end;

procedure TfMain.SetProgress( max: real );
begin
    pbAnalyze.Max := max;
end;

procedure TfMain.SetSelectMode(const Value: boolean);
begin
    _isSelectMode := Value;
end;

procedure TfMain.sgDataClick(Sender: TObject);
begin
    isSelectMode := false;
    sgData.Repaint;
end;

procedure TfMain.sgDataDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
  const Column: TColumn; const Bounds: TRectF; const Row: Integer;
  const Value: TValue; const State: TGridDrawStates);
var
  bgBrush: TBrush;
  top, bottom, left, right: integer; // границы выделения
  tmpBounds: TRectF;
begin
    // отрисовка выделенной ячейки по-умолчанию
{    if (TGridDrawState.Selected in State) or
       (TGridDrawState.Focused in State)
    then (Sender as TStringGrid).DefaultDrawColumnCell(Canvas, Column, Bounds, Row, Value, State);
}
    try

    bgBrush:= TBrush.Create(TBrushKind.Solid, TAlphaColors.Null); // default white color

    if (DocData[column.Index, row].kind <> TCellKind.ckNone) then
    begin

        /// ячейка относится к маршруту
        if (DocData[column.Index, row].kind = TCellKind.ckMarshrut)
        then bgBrush.Color := rMarshColor.Fill.Color; // a very light green color

        /// ячейка относится к отклонению
        if (DocData[column.Index, row].kind = TCellKind.ckOtklon)
        then bgBrush.Color := rOtklonColor.Fill.Color;

        /// ячейка относится к тоннажу
        if (DocData[column.Index, row].kind = TCellKind.ckTonnag)
        then bgBrush.Color := rTonnageColor.Fill.Color;

        /// ячейка относится к данным по ценам
        if (DocData[column.Index, row].kind = TCellKind.ckPrice)
        then bgBrush.Color := rDataColor.Fill.Color;


        Canvas.FillRect(Bounds, 0, 0, [], 1, bgBrush);


        Canvas.Fill.Color := TAlphaColors.Black;

        // установка цвета текста
        if DocData[column.Index, row].error <> '' then Canvas.Fill.Color := TAlphaColors.Red;
        if DocData[column.Index, row].warning <> '' then Canvas.Fill.Color := TAlphaColors.Orange;

        Canvas.FillText(Bounds, Value.AsString, false, 1, [], TTextAlign.Leading, TTextAlign.Center);

    end;


    /// если есть выделенная область, отрисовываем обрамление
    if selStart.X > -1 then
    begin
        top := Min(selStart.Y, selFinish.Y);
        bottom := Max(selStart.Y, selFinish.Y);
        left := Min(selStart.X, selFinish.X);
        right := Max(selStart.X, selFinish.X);

        bgBrush.Color := TAlphaColors.Black; // a very light green color

        if (Row = top) and (Column.Index >= left) and (Column.Index <= right) then
        begin
            tmpBounds := Bounds;
            tmpBounds.Height := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

        if (Row = bottom) and (Column.Index >= left) and (Column.Index <= right) then
        begin
            tmpBounds := Bounds;
            tmpBounds.Top := tmpBounds.Top + tmpBounds.Height - 1;
            tmpBounds.Height := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

        if (Row >= top) and (Row <= bottom) and (Column.Index = left)then
        begin
            tmpBounds := Bounds;
            tmpBounds.Width := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

        if (Row >= top) and (Row <= bottom) and (Column.Index = right)then
        begin
            tmpBounds := Bounds;
            tmpBounds.Left := tmpBounds.Left + tmpBounds.Width - 1;
            tmpBounds.Width := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

    end;

    finally
        bgBrush.Free;
    end;

end;

procedure TfMain.sgDataEditingDone(Sender: TObject; const Col, Row: Integer);
begin
    DocData[ col, row ].value := sgData.Cells[ col, row];
end;

procedure TfMain.sgDataMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
   Col: TColumn;
   C,R: integer;
begin
    isSelectMode := true;

    Col := sgData.ColumnByPoint(X, Y);
    if Assigned(Col)
    then C := Col.Index
    else C := -1;

    R := sgData.RowByPoint(X, Y);

    SelSetStartCoord(c, r);
    SelSetFinishCoord(c, r);
end;

procedure TfMain.sgDataMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
    if isSelectMode then
    begin
        SelSetFinishCoord( sgData.ColumnIndex, sgData.Selected );
        sgData.Repaint;
    end;
end;

procedure TfMain.sgDataSelectCell(Sender: TObject; const ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
    ClearMess;
    Error( DocData[ACol, ARow].error );
    Warning( DocData[ACol, ARow].warning );
    Info( DocData[ACol, ARow].info );
    System( DocData[ACol, ARow] );
end;

initialization

finalization
    exl := Unassigned;

end.
