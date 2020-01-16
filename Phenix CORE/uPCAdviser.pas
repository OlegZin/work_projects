unit uPCAdviser;

///
///    < Зиновьев О.Н. >
///    < 05.11.2019 >
///    < ГМС Нефтемаш >
///
///    Модуль для отслеживания изменения конфигурации компьютера.
///    Привязка идет по MAC-адресу.
///
///    Отслеживаемые параметры:
///       - имя процессора
///       - объем оперативной памяти
///       - имя видеокарты
///       - количество и объем логических дисков на винчестере
///
///    Данные для сверки хранятся в базе [nft].[dbo].[tool_pcadviser_hostinfo].
///
///    При подключении данного модуля к программе, на момент инициализации
///    уже создается экземпляр объекта в переменной PCAdviser. Дополнительных
///    манипуляций для инициализации не требуется.
///
///    Для работы используются данные текущей машины, на которой запущена программа.
///
///
///    Титульный метод:
///
///        PCAdviser.Check
///
///    Возвращает массив изменившихся параметров, относительно последнего сохраненного в
///    базе состояния. Если записей на данный MAC нет - создается запись, а
///    возвращаемый массив пуст. Так же, массив будет пуст, если изменений нет.
///
///
///    Вспомогательный метод:
///
///        PCAdviser.FormatArray ( array )
///
///    преобразует массив изменений в многострочный миниотчет вида:
///
///        Память: 2.00Гб -> 8.00Гб
///        С:\: 100Гб -> 200Гб
///
///
{
////////////////////////////////////////////////////////////////////////////////
/// пример использования модуля
////////////////////////////////////////////////////////////////////////////////

uses
  ..., uPCAdviser;

type
  TForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form: TForm;
  devices: TDeviceArray;

implementation

procedure TForm.Button1Click(Sender: TObject);
begin
    PCAdviser.setEmail('zinovev@hms-neftemash.ru');      /// без указания email, отправляться будет на Махалова
    devices := PCAdviser.Check;

    if Length(devices) = 0 then
    begin
        if   PCAdviser.Error = ''
        then ShowMessage( 'Отличий в конфигурации не обнаружено, либо добавлена новая' )
        else ShowMessage( 'Ошибка при проверке: ' + PCAdviser.Error )
    end
    else
        ShowMessage( 'Обнаружены изменения конфигурации! Отправлено email-извещение контролеру:' + sLineBreak +
                     PCAdviser.FormatArray(devices) );
end;

}

interface

uses
    ADODB, Winapi.Windows, System.SysUtils, Vcl.ExtCtrls, System.Classes, NB30, registry;

const

    /// подключение к базе адвизера (таблица сведений о компах)
    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Password=H6v92InV;Persist Security Info=True;'+
        'User ID=UserProgNFT;Data Source=server-htm.ntm.grouphms.local';
    DEFAULT_DATABASE = 'nft';

    /// имя таблицы в базе, где хранятся данные по конфигурациям
    DATA_TABLE = 'tool_pcadviser_hostinfo';

    /// электронный ящик контролера поумолчанию
    DEF_EMAIL = 'Mahalov@hms-neftemash.ru';

    /// имена параметров, хранимых в списке конфигурации
    PRM_MEMORY     = 'Память';
    PRM_PROCESSOR  = 'Процессор';
    PRM_VIDEO      = 'Видео';
    PRM_HDD_C      = 'C:\';
    PRM_HDD_D      = 'D:\';
    PRM_HDD_E      = 'E:\';
    PRM_HDD_F      = 'F:\';

type

    /// описание изменения элемента конфигурации.
    /// при отсутсвии старого значение - это новый компонент
    TDevice = record
        name,           // наименование. например "процессор"
        old_value,      // старое значение
        new_value       // новое значение
                : string;
    end;

    TDeviceArray = array of TDevice;


    /// тип функции передаваемой в качестве callback
    TCallback = procedure( devices: TDeviceArray ) of object;


    TPCAdviser = class
      private
        fConnection: TADOConnection;
        fQuery : TADOQuery;

        fEmail: string;
        fPCName : string;  /// имя текущего компа
        fDBInfo : string;  /// строка из базы параметров текущего компа
        fUserHost: string;     /// текущий залогиненый пользователь (логин)
        fUserName: string;     /// текущий залогиненый пользователь (фио)
        fUserId: integer;     /// текущий залогиненый пользователь (id из employees)
        fMacAddress : string;

        fDevices: TDeviceArray;

        function GetMACAddress: string;
        function GetAdapterInfo(Lana: Char): string;
      public

        Error: string;
        /// содержит последнюю ошибку в работе модуля.
        /// если результат проверки пуст, можно дополнительно проверить наличие ошибки
        /// для уверенности, что результат корректен.

        constructor Create;

        function setEmail( email: string ): TPCAdviser;
        /// указание email

        function Check: TDeviceArray;
        /// запуск проверки конфигурации железа на текущей машине и сравнение
        /// с сохраненным в базе слепком
        /// в качестве результата - массив с описанием изменившихся устройств.
        /// если список пуст - изменений нет была ошибка, причину которой можно
        /// посмотреть в TPCAdviser.Error

        function FormatArray( arr : TDeviceArray ): string;
        /// форматирует данные массива изменений в многострочный миниотчет

        function GetBDInfoString(field, value: string): string;
        /// получение строки параметров компьютера. поис ко переданному сочетанию
        /// поля и значения. при обнаружении нескольких подходящих записей, возвращается
        /// первое в списке
    end;

var

    PCAdviser : TPCAdviser;

implementation


{ TPCAdviser }

function TPCAdviser.GetBDInfoString(field, value: string): string;
begin
    /// получаем самое свежее значение конфигурации данного компьютера из базы.
    /// оно представляет собой переведенный в строку StringList
    try
        fQuery.SQL.Text := 'SELECT TOP 1 info FROM ' + DATA_TABLE + ' WHERE '+field+' = ''' + value + ''' ORDER BY date DESC';
        fQuery.Open;
    except
        on e: Exception do
        begin
            Error := e.Message;
            exit;
        end;
    end;

    fDBInfo := fQuery.Fields[0].AsString;

    /// заливаем данные в список
    result := fDBInfo;

end;

function TPCAdviser.Check: TDeviceArray;
///    функция проверки имеющегося
var
    file_list,       // параметры оборудования из файла
    db_list          // параметры оборудования из базы
            : TStringList;

    i : integer;

    ms: TMemoryStatusEx;
    reg:tregistry;
    tmp_separator: char;

    function GetProc( name: string ): string;
    /// фильтр на корректное наименование процессора
    /// отсекаем левые значения из массива
    begin
        result := name;
        if Pos('KB', name) <> 0 then result := '';
    end;

    procedure Compare( key: string );
    begin

        if db_list.Values[key] <> file_list.Values[key] then
        begin
            SetLength( fDevices, Length(fDevices)+1 );
            fDevices[High(fDevices)].name := key;
            fDevices[High(fDevices)].old_value := db_list.Values[key];
            fDevices[High(fDevices)].new_value := file_list.Values[key];
        end;

    end;

    function GetDisplayDevice: string;
    var
     lpDisplayDevice: TDisplayDevice;
    begin
     lpDisplayDevice.cb := sizeof(lpDisplayDevice);
     EnumDisplayDevices(nil, 0, lpDisplayDevice , 0);
     Result:=lpDisplayDevice.DeviceString;
    end;

begin

    /// сбрасываем результат возможной предыдущей проверки
    SetLength(fDevices, 0);
    result := [];
    Error := '';

    MS.dwLength:=SizeOf(MS);
    GlobalMemoryStatusEx(MS);

    tmp_separator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';

    /// после извлечения нужных параметров исходный список нам не нужен
    /// очищаем его и приводим к виду, в котором он хранится в базе
    file_list := TStringList.Create;
    file_list.Values[ PRM_MEMORY ]     := Format('%f Гб', [MS.ullTotalPhys/1024/1024/1024]);

    reg:=tregistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('HARDWARE\DESCRIPTION\System\CentralProcessor\0')
    then file_list.Values[ PRM_PROCESSOR ] := reg.ReadString('ProcessorNameString')
    else Error := IntToStr(GetLastError);
    reg.Free;

//    file_list.Values[ PRM_PROCESSOR ]  := GetEnvironmentVariable('PROCESSOR_IDENTIFIER');

    file_list.Values[ PRM_VIDEO ]      := GetDisplayDevice;

    /// перебираем все диски на компе и собираем инфу по объему для всех логических на винте
    for i := 0 to 25 do
    if (GetLogicalDrives and (1 shl i)) <> 0 then
    begin
        case GetDriveType(PChar(Char(Ord('A') + i) + ':\')) of
        DRIVE_FIXED:
            file_list.Values[ Char(Ord('A') + i) + ':\' ] := Format('%f Гб', [DiskSize(i+1)/1024/1024/1024]);
        end;
    end;


    db_list := TStringList.Create;
    db_list.CommaText := GetBDInfoString('mac', fMacAddress);


    if   fQuery.RecordCount <> 0 then
    /// конфигурация присутствует в учете, сравниваем
    begin

        Compare( PRM_MEMORY );
        Compare( PRM_PROCESSOR );
        Compare( PRM_VIDEO );
        Compare( PRM_HDD_C );
        Compare( PRM_HDD_D );
        Compare( PRM_HDD_E );
        Compare( PRM_HDD_F );

    end;

    FormatSettings.DecimalSeparator := tmp_separator;

    /// конфигурация отсутствует в учете
    /// либо обнаружено отличие от актуальной
    if (fQuery.RecordCount = 0) or
       ( Length(fDevices) <> 0)
    then
    begin

        try
            fQuery.Close;
            fQuery.SQL.Text :=
                Format('INSERT INTO %s ( mac, host, info, [user], empl_id ) VALUES ( ''%s'', ''%s'', ''%s'', ''%s'', %d )',
                        [ DATA_TABLE, fMacAddress, fPCName, file_list.CommaText, fUserHost, fUserId ]);

            if fQuery.ExecSQL = 0 then
            begin
                Error := 'Добавление в базу данных информации о ' + fPCName + ' не удалась';
                exit;
            end;

        except
            on e: Exception do
            begin
                Error := e.Message;
                exit;
            end;
        end;

    end;

    if Length( fDevices ) > 0 then
    begin

        try
            fQuery.Close;

            fQuery.SQL.Text :=
                Format('EXEC msdb.dbo.sp_send_dbmail @profile_name = ''1'', '+
                        ' @recipients = ''%s'', ' +
                        ' @subject = ''Изменение конфигурации %s'', ' +
                        ' @body_format  = ''HTML'', ' +
                        ' @body = ''%s''',
                        [ fEmail, fPCName, '<body><p>Пользователь: '+fUserName+'</p><pre>'+FormatArray(fDevices)+'</pre></body>' ]);

            fQuery.ExecSQL;

        except
            on e: Exception do
            begin
                Error := e.Message;
                exit;
            end;
        end;

    end;

    /// возвращаем данные об изменнениях массивом.
    result := fDevices;

end;

function TPCAdviser.setEmail(email: string): TPCAdviser;
begin
    result := self;
    fEmail := email;
end;


constructor TPCAdviser.Create;
begin

    inherited;

    /// подключение к БД
    fConnection := TADOConnection.Create(nil);
    fConnection.LoginPrompt:= false;
    fConnection.ConnectionString := CONNECTION_STRING;
    fConnection.DefaultDatabase := DEFAULT_DATABASE;
    fConnection.Connected := true;

    /// настройка компонента для запросов
    fQuery := TADOQuery.Create(nil);
    fQuery.Connection := fConnection;

    /// ящик получателя извещений об изменении конфигурации
    fEmail := DEF_EMAIL;

    fPCName := GetEnvironmentVariable('COMPUTERNAME');
    fUserHost := GetEnvironmentVariable('USERNAME');
    fUserName := fUserHost;
    fUserId := 0;

    try
        fQuery.SQL.Text := 'SELECT id, name FROM employees WHERE host like ''' + fPCName + '''';
        fQuery.Open;

        if ( fQuery.Active ) and ( fQuery.RecordCount > 0 ) then
        begin
            fUserId := fQuery.Fields[0].AsInteger;
            fUserName := fQuery.Fields[1].AsString;
        end;

    except
        on e: Exception do
        begin
            Error := e.Message;
            exit;
        end;
    end;

    fMacAddress := GetMacAddress;
end;

function TPCAdviser.FormatArray(arr: TDeviceArray): string;
var
    i : integer;
begin
    For i := 0 to High( arr ) do
        result := result + Format( '%s: %s -> %s', [arr[i].name, arr[i].old_value, arr[i].new_value]) + sLineBreak;
end;

function TPCAdviser.GetAdapterInfo(Lana: Char): string;
var
  Adapter: TAdapterStatus;
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBRESET);
  NCB.ncb_lana_num := AnsiChar(Lana);
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin
    Result := 'Адрес не известен';
    Exit;
  end;

  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBASTAT);
  NCB.ncb_lana_num := AnsiChar(Lana);
  NCB.ncb_callname := '*';

  FillChar(Adapter, SizeOf(Adapter), 0);
  NCB.ncb_buffer := @Adapter;
  NCB.ncb_length := SizeOf(Adapter);
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin
    Result := 'Адрес не известен';
    Exit;
  end;
  Result :=
  IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[5]), 2);
end;

function TPCAdviser.GetMACAddress: string;
var
  AdapterList: TLanaEnum;
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBENUM);
  NCB.ncb_buffer := @AdapterList;
  NCB.ncb_length := SizeOf(AdapterList);
  Netbios(@NCB);
  if Byte(AdapterList.length) > 0 then
    Result := GetAdapterInfo(Char(AdapterList.lana[0]))
  else
    Result := 'Адрес не известен';
end;

initialization

    PCAdviser := TPCAdviser.Create;

finalization

    PCAdviser.Free;

end.


