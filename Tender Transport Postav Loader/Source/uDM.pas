unit uDM;

interface

uses
  System.SysUtils, System.Classes, ADODB, Data.DB, FMX.Dialogs, StrUtils, Variants;

const
   SQL_GET_TENDER_LIST = 'EXEC GET_TENDERLIST';

type

    TName = record
        city: string;         /// ������������ ��������������� ������
        cityCode: string;     /// ��� �� �����������
        percent: integer;        /// ������� ���������. ����� �� ����� 100, ���� ���� ���������
        ///    � ����� 100, ���� ����� ��������� ��������� � ����� �������������, ����������� � ������ ��������, � ��������
        present_past: boolean;   /// ���������������, ���� ����� � ����� ����� ���������� � ���������� ��������� ��������
        present_curr: boolean;   /// ���������������, ���� ����� � ����� ����� ���������� � ������� ��������� �������
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

    _ttid : integer; // id ��������� ��������� �������
    _allowDBConnect: boolean; // ���� ���������� ����������� � ����
    _allowDBStruct: boolean; // ���� ������� � ���� ����������� ��������� ������ ��������� ��������� �������:
                             // ����� ��������� � ����� ���������.
    _codeTyumen: string;     // ��� ������������� ������ �� ����������� city

    function isPresentPast(code: string): boolean; /// ����������� �� ����� � ������ ��������� ��������
    function isPresentCurr(code: string): boolean; /// ����������� �� ����� � ������� ��������� �������
    function HasAlternate(city: string): TName;   /// �� ������������ ���������� ������������ ��� �� ������������ TT_CITY_ALTERNATE
                                                   ///    � ���������� �������������� ��� ������, ���� ����
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
/// ��� ����������� ������ ����� ���� ��� ��������:
///    - ��������� � ��������/�����������
///    - ������� ���������� ���������� ������� � ����� �������������
var
    cityName: TNameArr; /// ������ �����������, ��������� ��� �������� ������������.
    ///    ���� �������� � ������� �� �������� � �������� �� ������ ��������
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

        // �� ��������������� ������ ������ �� �������, ��� ������������ � ����������� ����� ����,
        // ������� ������ �� �����
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


    // ������� ����� ����� ������������� ��� �������� �������
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


    /// ���� ��� ������� ������������ � �����������
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


    /// �������� �� ������� � ������� �������
    for i := 0 to High(cityName) do
    begin
       cityName[i].present_past := isPresentPast( cityName[i].cityCode );
       cityName[i].present_curr := isPresentCurr( cityName[i].cityCode );
    end;


    /// ���������� �� ������������ ������ ������ ��������� ������ ����� �������������
    /// �� ����� ����������� ������� � ��������� �������� (������� �������).

    // ����������: ���� ��� ����������� � ������� �� � ������ ���������� �� �����
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
    // !!! ������ �������� �������� �������, ��������� �� ���� �������� �������
    // !!! ���� � ���������� ������������. ������� ���������� ������������� ��
    // !!! ���������� �����������

    // ����������: ���� ��� ����������� � ������� �� � ���������� �� ������
    // ��������, �������� � ��������� ��� ����������� ������������.

    // ������ �������� ������� �� ����������, ��������� ���� ���� ������� �������, ��� ����� ������� ������������
    // � �� ��������� � ������� ����� ��������, ����� �� ����� ���������� ���� ��� ������ ��������.
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if (cityName[i].present_curr) and (cityName[i].percent >= 75) then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

    // ����������: ���� ��� ����������� � ������� �� � ������ ���������� �� �����
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if (cityName[i].present_past) and (cityName[i].percent >= 75) then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

    // ����������: ������ ���������� �� �����
    if length(result) = 0 then
    begin
        for i := 0 to High(cityName) do
        if cityName[i].percent > 90 then
        begin
            SetLength(result, Length(result)+1);
            result[high(result)] := cityName[i];
        end;
    end;

    // ����������: ���� ���� ���������� � ������ ��
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


    /// ���������� ���, ��� �����
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
/// �������� �� ���� ���� �� ��������� ��������� �������.
/// ���� ����� ������������ ��� ��� ���������� �����������, ��� � ���
/// ���������� ����� ���������� ������������� ��������� �� ��� �������
/// ��������� �������.
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
           ShowMessage('�� ������� ������������ � ���� ������:' + sLineBreak + E.Message);
           Exit;
       end;
    end;

    // �������� ������ ���������
    spGroups.Close;
    spGroups.Parameters.ParamByName('@HEAD_ID').Value := TenderID;
    spGroups.Open;

    if not spGroups.Active or (spGroups.RecordCount = 0)
    then error := fMain.Log('��� ��������� ������� � ���� ����������� ������ ���������.');


    // �������� ��������
    OpenMarshrut;

//    if not spMarshrut.Active or (spMarshrut.RecordCount = 0)
//    then error := fMain.Log('��� ��������� ������� � ���� ����������� ��������.');


    // �������� ���� �������
    spTonnag.Close;
    spTonnag.Open;

    if not spTonnag.Active or (spTonnag.RecordCount = 0)
    then error := fMain.Log('����������� ������ � ����������� �������.');


    // �������� ������ �������
    spCity.Close;
    spCity.Open;

    if not spCity.Active or (spCity.RecordCount = 0)
    then error := fMain.Log('����������� ������ � ����������� �������.');


    // �������� ������ �����������
    spPostav.Close;
    spPostav.Open;

    if not spPostav.Active or (spPostav.RecordCount = 0)
    then error := fMain.Log('����������� ������ � ����������� �����������.');


    // �������� ����������� ��������� �������
    OpenAlternate;

    // �������� ����������� ��������� ��������
    tTonnagAlternate.Close;
    tTonnagAlternate.Open;

    // ��� ���������� ���������� ��������� � ���� - �������
    if error <> '' then exit;

    AllowDBStructure := true;

    // �������� ��� ������
    buf := GetCityCode('������', true);
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
/// �������� ������� �������� � ��������� �������, � �� ������� ����� ������������,
/// ��������� ���� ��������� ���� �� ��, ��� ���������� ��������� � ������ ��������
/// ����� �������� ������ ���������� ������
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

    if DB_FAIL then exit;   // ��� ��������� ����������� ���������� ��� ����������� �������,
                            // ����� �� �������� ������������ �����������

    if not ADOConnection.Connected then
    begin
        try
            ADOConnection.Connected := true;
        except
            on e: exception do
            begin
                ShowMessage('������ ��������� � ���� ������: '+ sLineBreak + E.Message);
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
            ShowMessage('������ ��������� ������ ��������: '+ sLineBreak + E.Message);
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
