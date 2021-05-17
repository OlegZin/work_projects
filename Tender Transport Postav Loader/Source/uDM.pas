unit uDM;

interface

uses
  System.SysUtils, System.Classes, ADODB, Data.DB, FMX.Dialogs, StrUtils, Variants;

const
   SQL_GET_TENDER_LIST = 'EXEC GET_TENDERLIST';

type

    TName = record
        city: string;         /// наименование предполагаемого города
        cityCode: string;     /// код из справочника
        percent: integer;        /// процент похожести. будет не равен 100, если есть искажения
        ///    и равен 100, если будет несколько вариантов с одним наименованием, находящихся в разных областях, к приметру
        present_past: boolean;   /// устанавливается, если город с таким кодом упоминался в предыдущих тендерных таблицах
        present_curr: boolean;   /// устанавливается, если город с таким кодом упоминался в текущей тендерной таблице
    end;
    TNameArr = array of TName;

    TTonnag = record
        tonnag_id: integer;
        tonnag: string;
    end;

  TDM = class(TDataModule)
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    spGroups: TADOStoredProc;
    spMarshrut: TADOStoredProc;
    spTonnag: TADOStoredProc;
    spCity: TADOStoredProc;
    spCityPresent: TADOStoredProc;
    spSaveCityAlternate: TADOStoredProc;
    spCityAlternate: TADOStoredProc;
    spPostav: TADOStoredProc;
    tTonnagAlternate: TADOTable;
    spSaveTonnagAlternate: TADOStoredProc;
    spCreateMarshrut: TADOStoredProc;
    spInsertData: TADOStoredProc;
    spInsertOtklon: TADOStoredProc;
    spClearData: TADOStoredProc;
    spDelCityAlternate: TADOStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    DB_FAIL : boolean;

    _ttid : integer; // id выбранной тендерной таблицы
    _allowDBConnect: boolean; // флаг успешности подключения к базе
    _allowDBStruct: boolean; // флаг наличия в базе необходимой структуры данных выбранной тендерной таблицы:
                             // групп маршрутов и самих маршрутов.
    _codeTyumen: string;     // код идентификации Тюмени из справочника city

    function isPresentPast(code: string): boolean; /// упоминается ли город в старых тендерных таблицах
    function isPresentCurr(code: string): boolean; /// упоминается ли город в текущей тендерной таблице
    function HasAlternate(city: string): TName;   /// по наименованию насюпункта сопоставляет его со справочником TT_CITY_ALTERNATE
                                                   ///    и возвращает альтернативный код города, если есть
  public
    { Public declarations }

    property AllowDBConnect: boolean read _allowDBConnect write _allowDBConnect;
    property AllowDBStructure: boolean read _allowDBStruct write _allowDBStruct;
    property TenderID: integer read _ttid write _ttid;
    property codeTyumen: string read _codeTyumen write _codeTyumen;

    function OpenQuery(sql: string): boolean;
    function InitDB: boolean;
    procedure OpenAlternate;
    function GetCityCode(city: string; optimistic: boolean = false): TNameArr;
    function GetMarshrut(cityCode1, cityCode2: string): integer;
    function GetTonnag(tonnag: string): TTonnag;
    procedure SaveCityAlternate(city, alt_city, alt_code: string);
    procedure DelCityAlternate(id: integer);
    procedure SaveTonnagAlternate(tonnag: string; tonnag_id: integer);
    procedure CreateMarshrut( group_index: integer; city1, city2: string);
    procedure InsertData(marshrut_id, tonnag_id, postav_id: integer; price : real);
    procedure ClearData;
    procedure InsertOtklon(marshrut_id, tonnag_id, postav_id: integer; price: real );
    procedure OpenMarshrut;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses uMain, uTextComparer;



procedure TDM.ClearData;
begin
    spClearData.Parameters.ParamByName('@HEAD_ID').Value := TenderID;
    spClearData.ExecProc;
end;

procedure TDM.CreateMarshrut(group_index: integer; city1, city2: string);
begin
    spCreateMarshrut.Parameters.ParamByName('@TT_HEAD_ID').Value := TenderID;
    spCreateMarshrut.Parameters.ParamByName('@TT_GR_INDEX').Value := group_index;
    spCreateMarshrut.Parameters.ParamByName('@CITY1').Value := city1;
    spCreateMarshrut.Parameters.ParamByName('@CITY2').Value := city2;
    spCreateMarshrut.ExecProc;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
    ADOConnection.close;
{$IFDEF test}
    ADOConnection.ConnectionString :=
        'Provider=SQLOLEDB.1;Password=H6v92InV;Persist Security Info=True;User ID=UserProgNFT'+
    {!} ';Initial Catalog=neftemash_TU;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;'+
        'Packet Size=4096;Workstation ID=OA_ZINOVYEV;Use Encryption for Data=False;'+
        'Tag with column collation when possible=False';
{$ELSEIF}
    ADOConnection.ConnectionString :=
        'Provider=SQLOLEDB.1;Password=H6v92InV;Persist Security Info=True;User ID=UserProgNFT;'+
    {!} 'Initial Catalog=nft_TU;'+
        'Data Source=server-htm;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'+
        'Workstation ID=OA_ZINOVYEV;Use Encryption for Data=False;Tag with column collation when possible=False';
{$ENDIF}
end;

procedure TDM.DelCityAlternate(id: integer);
begin
    spDelCityAlternate.Parameters.ParamByName('@HEAD_TT').Value := TenderID;
    spDelCityAlternate.Parameters.ParamByName('@ID').Value := id;
    spDelCityAlternate.ExecProc;
end;

function TDM.GetCityCode(city: string; optimistic: boolean = false): TNameArr;
/// при определении города могут быть две проблемы:
///    - написание с ошибками/искажениями
///    - наличие нескольких населенных пунктов с одним наименованием
var
    cityName: TNameArr; /// массив альтернатив, найденных для искомого наименования.
    ///    сюда попадают и похожие по названию и близнецы из разных областей
    percent, i: integer;
    alternate: TName;

    procedure CompareNames(name, code, region, raion: string);
    var
        rec : TName;
        percent: integer;
    begin
        if name = city then
        begin
            rec.city := name + ', ' + region + ifthen(raion <> '', ', ' + raion, '');
            rec.cityCode := code;
            rec.percent := 100;

            SetLength(cityName, Length(cityName)+1);
            cityName[High(cityName)] := rec;

            exit;
        end;

        // по оптимистической модели поиска мы уверены, что наименование в справочнике точно есть,
        // частями искать не нужно
        if optimistic then exit;

        percent := CompareWord(city, name);

        if percent >= 50 then
        begin
            rec.city := name + ', ' + region + ifthen(raion <> '', ', ' + raion, '');
            rec.cityCode := code;
            rec.percent := percent;

            SetLength(cityName, Length(cityName)+1);
            cityName[High(cityName)] := rec;
        end;

    end;
begin

    if not AllowDBConnect or not AllowDBStructure then exit;

    city := AnsiUpperCase(city);


    // пробуем сразу найти сопоставление для экономии времени
    if length(result) = 0 then
    begin
        alternate := HasAlternate(city);
        if alternate.city <> '' then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := alternate;
            exit;
        end;
    end;


    /// ищем все похожие наименования в справочнике
    spCity.First;
    while not spCity.Eof do
    begin
        CompareNames(
            AnsiUpperCase(spCity.FieldByName('city').AsString),
            spCity.FieldByName('code').AsString,
            spCity.FieldByName('region').AsString,
            spCity.FieldByName('raion').AsString
        );

        spCity.Next;
    end;


    /// проверка на наличие в прошлые тендеры
    for i := 0 to High(cityName) do
    begin
       cityName[i].present_past := isPresentPast( cityName[i].cityCode );
       cityName[i].present_curr := isPresentCurr( cityName[i].cityCode );
    end;


    /// полученный по наименованию города список вариантов теперь можно отфильтровать
    /// по ранее упоминаемым городам в тендерных таблицах (включая текущую).

    // фильтрация: если уже упоминается в текущей ТТ и полное совпадение по имени
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if (cityName[i].present_curr) and (cityName[i].percent = 100) then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

{
    // !!! данный механизм фильтров отрезан, поскольку не дает надежной выборки
    // !!! хоть и достаточно функционален. заменен механизмом сопоставлений по
    // !!! отдельному справочнику

    // фильтрация: если уже упоминается в текущей ТТ и совпадение не полное
    // например, написано с опечаткой или сокращением наименования.

    // данная проверка отделно от предыдущей, поскольку если есть нуждный вариант, его нужно вернуть единственным
    // и не смешивать с прочими почти похожими, тогда не будет появляться окно для выбора варианта.
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if (cityName[i].present_curr) and (cityName[i].percent >= 75) then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

    // фильтрация: если уже упоминается в текущей ТТ и полное совпадение по имени
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if (cityName[i].present_past) and (cityName[i].percent >= 75) then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

    // фильтрация: полное совпадение по имени
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if cityName[i].percent > 90 then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

    // фильтрация: если есть упоминание в других ТТ
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if cityName[i].present_past then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;
}


    /// возвращаем все, что нашли
    if length(result) = 0
    then  result := cityName;

end;

function TDM.GetMarshrut(cityCode1, cityCode2: string): integer;
begin
    result := -1;

    if not AllowDBConnect or not AllowDBStructure then exit;

    spMarshrut.First;
    while not spMarshrut.Eof and (result = -1) do
    begin

        if (spMarshrut.FieldByName('city1').AsString = cityCode1) and
           (spMarshrut.FieldByName('city2').AsString = cityCode2)
        then result := spMarshrut.FieldByName('id').AsInteger;

        spMarshrut.Next;
    end;
end;



function TDM.GetTonnag(tonnag: string): TTonnag;
begin
    result.tonnag_id := -1;
    result.tonnag := '';

    tonnag := AnsiUpperCase(Trim(tonnag));

    tTonnagAlternate.First;
    while not tTonnagAlternate.Eof do
    begin
        if tonnag = AnsiUpperCase(Trim(tTonnagAlternate.FieldByName('tonnag').AsString)) then
        begin
            result.tonnag_id := tTonnagAlternate.FieldByName('tonnag_id').AsInteger;
            result.tonnag := tTonnagAlternate.FieldByName('tonnag_origin').AsString;
            exit;
        end;

        tTonnagAlternate.next;
    end;

end;

function TDM.HasAlternate(city: string): TName;
begin
    result.city := '';
    result.cityCode := '';
    result.percent := 0;
    result.present_past := false;
    result.present_curr := false;

    if not AllowDBConnect then exit;

    spCityAlternate.First;
    while not spCityAlternate.Eof do
    begin
        if spCityAlternate.FieldByName('city').AsString = city then
        begin
            result.city := spCityAlternate.FieldByName('alt_city').AsString;
            result.cityCode := spCityAlternate.FieldByName('alt_code').AsString;
            result.percent := 100;
            result.present_past := true;
            result.present_curr := true;
            break;
        end;

        spCityAlternate.Next;
    end;

end;

function TDM.InitDB: boolean;
/// получаем из базы инфу по выбранной тендерной таблицы.
/// этот метод используется как для первичного подключения, так и для
/// повторного после выполнения инициализации структуры БД для текущей
/// тендерной таблицы.
var
    error: string;
    buf: TNameArr;
begin
    result := false;
    _allowDBConnect := false;
    AllowDBStructure := false;

    try
       if not DM.ADOConnection.Connected then
       ADOConnection.Connected := true;
       _allowDBConnect := true;
    except
       on E:exception do
       begin
           ShowMessage('Не удалось подключиться к базе данных:' + sLineBreak + E.Message);
           Exit;
       end;
    end;

    // получаем группы маршрутов
    spGroups.Close;
    spGroups.Parameters.ParamByName('@HEAD_ID').Value := TenderID;
    spGroups.Open;

    if not spGroups.Active or (spGroups.RecordCount = 0)
    then error := fMain.Log('Для тендерной таблицы в базе отсутствуют группы маршрутов.');


    // получаем маршруты
    OpenMarshrut;

//    if not spMarshrut.Active or (spMarshrut.RecordCount = 0)
//    then error := fMain.Log('Для тендерной таблицы в базе отсутствуют маршруты.');


    // получаем типы тоннажа
    spTonnag.Close;
    spTonnag.Open;

    if not spTonnag.Active or (spTonnag.RecordCount = 0)
    then error := fMain.Log('Отсутствуют данные в справочнике тоннажа.');


    // получаем данные городов
    spCity.Close;
    spCity.Open;

    if not spCity.Active or (spCity.RecordCount = 0)
    then error := fMain.Log('Отсутствуют данные в справочнике городов.');


    // получаем данные поставщиков
    spPostav.Close;
    spPostav.Open;

    if not spPostav.Active or (spPostav.RecordCount = 0)
    then error := fMain.Log('Отсутствуют данные в справочнике поставщиков.');


    // открытие справочника синонимов городов
    OpenAlternate;

    // открытие справочника синонимов тоннажей
    tTonnagAlternate.Close;
    tTonnagAlternate.Open;

    // при отсутствии корректной структуры в базе - выходим
    if error <> '' then exit;

    AllowDBStructure := true;

    // получаем код тюмени
    buf := GetCityCode('Тюмень', true);
    codeTyumen := buf[0].cityCode;

    result := true;
end;

procedure TDM.InsertData(marshrut_id, tonnag_id, postav_id: integer;
  price: real);
begin
    spInsertData.Parameters.ParamByName('@TT_MARSHRUT_ID').Value := marshrut_id;
    spInsertData.Parameters.ParamByName('@TONNAG_ID').Value := tonnag_id;
    spInsertData.Parameters.ParamByName('@POSTAV_ID').Value := postav_id;
    spInsertData.Parameters.ParamByName('@PRICE').Value := price;
    spInsertData.ExecProc;
end;

procedure TDM.InsertOtklon(marshrut_id, tonnag_id, postav_id: integer;
  price: real);
begin
    spInsertOtklon.Parameters.ParamByName('@TT_GROUPS_ID').Value := marshrut_id;
    spInsertOtklon.Parameters.ParamByName('@TONNAG_ID').Value := tonnag_id;
    spInsertOtklon.Parameters.ParamByName('@POSTAV_ID').Value := postav_id;
    spInsertOtklon.Parameters.ParamByName('@PRICE').Value := price;
    spInsertOtklon.ExecProc;
end;

function TDM.isPresentCurr(code: string): boolean;
begin
    result := false;
    if not AllowDBConnect or not AllowDBStructure then exit;

    spCityPresent.Close;
    spCityPresent.Parameters.ParamByName('@code').Value := code;
    spCityPresent.Parameters.ParamByName('@tt_id').Value := TenderID;
    spCityPresent.Open;

    result := spCityPresent.Fields[0].AsInteger > 0;
end;

function TDM.isPresentPast(code: string): boolean;
begin
    result := false;
    if not AllowDBConnect or not AllowDBStructure then exit;

    spCityPresent.Close;
    spCityPresent.Parameters.ParamByName('@code').Value := code;
    spCityPresent.Parameters.ParamByName('@tt_id').ParameterObject.Value := Unassigned;
    spCityPresent.Open;

    result := spCityPresent.Fields[0].AsInteger > 0;

end;

procedure TDM.OpenAlternate;
/// синонимы городов привзаны к тендерной таблице, а не сделаны общим справочником,
/// поскольку есть небольшой шанс на то, что одинаковое написание в разных таблицах
/// будет означать разные населенные пункты
begin
    spCityAlternate.Close;
    spCityAlternate.Parameters.ParamByName('@tt_head_id').Value := TenderID;
    spCityAlternate.Open;
end;

procedure TDM.OpenMarshrut;
begin
    spMarshrut.Close;
    spMarshrut.Parameters.ParamByName('@HEAD_ID').Value := TenderID;
    spMarshrut.Open;
end;

function TDM.OpenQuery(sql: string): boolean;
begin
    result := false;

    if DB_FAIL then exit;   // при неудачном подключении обрубаются все последующие попытки,
                            // чтобы не засирать пользователя сообщениями

    if not ADOConnection.Connected then
    begin
        try
            ADOConnection.Connected := true;
        except
            on e: exception do
            begin
                ShowMessage('Ошибка получения к базе данных: '+ sLineBreak + E.Message);
                DB_FAIL := true;
            end;
        end;
    end;

    ADOQuery.Close;
    ADOQuery.SQL.Text := sql;

    try
        ADOQuery.Open;
    except
        on E:Exception do
        begin
            ShowMessage('Ошибка получения списка тендеров: '+ sLineBreak + E.Message);
            exit;
        end;
    end;

    Result := ADOQuery.Active;
end;

procedure TDM.SaveTonnagAlternate(tonnag: string; tonnag_id: integer);
begin
    spSaveTonnagAlternate.Parameters.ParamByName('@tonnag_id').Value := tonnag_id;
    spSaveTonnagAlternate.Parameters.ParamByName('@tonnag').Value := tonnag;
    spSaveTonnagAlternate.ExecProc;
end;


procedure TDM.SaveCityAlternate(city, alt_city, alt_code: string);
begin
    spSaveCityAlternate.Parameters.ParamByName('@tt_head_id').Value := TenderID;
    spSaveCityAlternate.Parameters.ParamByName('@city').Value := city;
    spSaveCityAlternate.Parameters.ParamByName('@alt_city').Value := alt_city;
    spSaveCityAlternate.Parameters.ParamByName('@alt_code').Value := alt_code;
    spSaveCityAlternate.ExecProc;
end;

end.
