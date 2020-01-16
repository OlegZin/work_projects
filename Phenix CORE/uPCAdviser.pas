unit uPCAdviser;

///
///    < �������� �.�. >
///    < 05.11.2019 >
///    < ��� �������� >
///
///    ������ ��� ������������ ��������� ������������ ����������.
///    �������� ���� �� MAC-������.
///
///    ������������� ���������:
///       - ��� ����������
///       - ����� ����������� ������
///       - ��� ����������
///       - ���������� � ����� ���������� ������ �� ����������
///
///    ������ ��� ������ �������� � ���� [nft].[dbo].[tool_pcadviser_hostinfo].
///
///    ��� ����������� ������� ������ � ���������, �� ������ �������������
///    ��� ��������� ��������� ������� � ���������� PCAdviser. ��������������
///    ����������� ��� ������������� �� ���������.
///
///    ��� ������ ������������ ������ ������� ������, �� ������� �������� ���������.
///
///
///    ��������� �����:
///
///        PCAdviser.Check
///
///    ���������� ������ ������������ ����������, ������������ ���������� ������������ �
///    ���� ���������. ���� ������� �� ������ MAC ��� - ��������� ������, �
///    ������������ ������ ����. ��� ��, ������ ����� ����, ���� ��������� ���.
///
///
///    ��������������� �����:
///
///        PCAdviser.FormatArray ( array )
///
///    ����������� ������ ��������� � ������������� ��������� ����:
///
///        ������: 2.00�� -> 8.00��
///        �:\: 100�� -> 200��
///
///
{
////////////////////////////////////////////////////////////////////////////////
/// ������ ������������� ������
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
    PCAdviser.setEmail('zinovev@hms-neftemash.ru');      /// ��� �������� email, ������������ ����� �� ��������
    devices := PCAdviser.Check;

    if Length(devices) = 0 then
    begin
        if   PCAdviser.Error = ''
        then ShowMessage( '������� � ������������ �� ����������, ���� ��������� �����' )
        else ShowMessage( '������ ��� ��������: ' + PCAdviser.Error )
    end
    else
        ShowMessage( '���������� ��������� ������������! ���������� email-��������� ����������:' + sLineBreak +
                     PCAdviser.FormatArray(devices) );
end;

}

interface

uses
    ADODB, Winapi.Windows, System.SysUtils, Vcl.ExtCtrls, System.Classes, NB30, registry;

const

    /// ����������� � ���� �������� (������� �������� � ������)
    CONNECTION_STRING =
        'Provider=SQLOLEDB.1;Password=H6v92InV;Persist Security Info=True;'+
        'User ID=UserProgNFT;Data Source=server-htm.ntm.grouphms.local';
    DEFAULT_DATABASE = 'nft';

    /// ��� ������� � ����, ��� �������� ������ �� �������������
    DATA_TABLE = 'tool_pcadviser_hostinfo';

    /// ����������� ���� ���������� �����������
    DEF_EMAIL = 'Mahalov@hms-neftemash.ru';

    /// ����� ����������, �������� � ������ ������������
    PRM_MEMORY     = '������';
    PRM_PROCESSOR  = '���������';
    PRM_VIDEO      = '�����';
    PRM_HDD_C      = 'C:\';
    PRM_HDD_D      = 'D:\';
    PRM_HDD_E      = 'E:\';
    PRM_HDD_F      = 'F:\';

type

    /// �������� ��������� �������� ������������.
    /// ��� ��������� ������� �������� - ��� ����� ���������
    TDevice = record
        name,           // ������������. �������� "���������"
        old_value,      // ������ ��������
        new_value       // ����� ��������
                : string;
    end;

    TDeviceArray = array of TDevice;


    /// ��� ������� ������������ � �������� callback
    TCallback = procedure( devices: TDeviceArray ) of object;


    TPCAdviser = class
      private
        fConnection: TADOConnection;
        fQuery : TADOQuery;

        fEmail: string;
        fPCName : string;  /// ��� �������� �����
        fDBInfo : string;  /// ������ �� ���� ���������� �������� �����
        fUserHost: string;     /// ������� ����������� ������������ (�����)
        fUserName: string;     /// ������� ����������� ������������ (���)
        fUserId: integer;     /// ������� ����������� ������������ (id �� employees)
        fMacAddress : string;

        fDevices: TDeviceArray;

        function GetMACAddress: string;
        function GetAdapterInfo(Lana: Char): string;
      public

        Error: string;
        /// �������� ��������� ������ � ������ ������.
        /// ���� ��������� �������� ����, ����� ������������� ��������� ������� ������
        /// ��� �����������, ��� ��������� ���������.

        constructor Create;

        function setEmail( email: string ): TPCAdviser;
        /// �������� email

        function Check: TDeviceArray;
        /// ������ �������� ������������ ������ �� ������� ������ � ���������
        /// � ����������� � ���� �������
        /// � �������� ���������� - ������ � ��������� ������������ ���������.
        /// ���� ������ ���� - ��������� ��� ���� ������, ������� ������� �����
        /// ���������� � TPCAdviser.Error

        function FormatArray( arr : TDeviceArray ): string;
        /// ����������� ������ ������� ��������� � ������������� ���������

        function GetBDInfoString(field, value: string): string;
        /// ��������� ������ ���������� ����������. ���� �� ����������� ���������
        /// ���� � ��������. ��� ����������� ���������� ���������� �������, ������������
        /// ������ � ������
    end;

var

    PCAdviser : TPCAdviser;

implementation


{ TPCAdviser }

function TPCAdviser.GetBDInfoString(field, value: string): string;
begin
    /// �������� ����� ������ �������� ������������ ������� ���������� �� ����.
    /// ��� ������������ ����� ������������ � ������ StringList
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

    /// �������� ������ � ������
    result := fDBInfo;

end;

function TPCAdviser.Check: TDeviceArray;
///    ������� �������� ����������
var
    file_list,       // ��������� ������������ �� �����
    db_list          // ��������� ������������ �� ����
            : TStringList;

    i : integer;

    ms: TMemoryStatusEx;
    reg:tregistry;
    tmp_separator: char;

    function GetProc( name: string ): string;
    /// ������ �� ���������� ������������ ����������
    /// �������� ����� �������� �� �������
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

    /// ���������� ��������� ��������� ���������� ��������
    SetLength(fDevices, 0);
    result := [];
    Error := '';

    MS.dwLength:=SizeOf(MS);
    GlobalMemoryStatusEx(MS);

    tmp_separator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';

    /// ����� ���������� ������ ���������� �������� ������ ��� �� �����
    /// ������� ��� � �������� � ����, � ������� �� �������� � ����
    file_list := TStringList.Create;
    file_list.Values[ PRM_MEMORY ]     := Format('%f ��', [MS.ullTotalPhys/1024/1024/1024]);

    reg:=tregistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('HARDWARE\DESCRIPTION\System\CentralProcessor\0')
    then file_list.Values[ PRM_PROCESSOR ] := reg.ReadString('ProcessorNameString')
    else Error := IntToStr(GetLastError);
    reg.Free;

//    file_list.Values[ PRM_PROCESSOR ]  := GetEnvironmentVariable('PROCESSOR_IDENTIFIER');

    file_list.Values[ PRM_VIDEO ]      := GetDisplayDevice;

    /// ���������� ��� ����� �� ����� � �������� ���� �� ������ ��� ���� ���������� �� �����
    for i := 0 to 25 do
    if (GetLogicalDrives and (1 shl i)) <> 0 then
    begin
        case GetDriveType(PChar(Char(Ord('A') + i) + ':\')) of
        DRIVE_FIXED:
            file_list.Values[ Char(Ord('A') + i) + ':\' ] := Format('%f ��', [DiskSize(i+1)/1024/1024/1024]);
        end;
    end;


    db_list := TStringList.Create;
    db_list.CommaText := GetBDInfoString('mac', fMacAddress);


    if   fQuery.RecordCount <> 0 then
    /// ������������ ������������ � �����, ����������
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

    /// ������������ ����������� � �����
    /// ���� ���������� ������� �� ����������
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
                Error := '���������� � ���� ������ ���������� � ' + fPCName + ' �� �������';
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
                        ' @subject = ''��������� ������������ %s'', ' +
                        ' @body_format  = ''HTML'', ' +
                        ' @body = ''%s''',
                        [ fEmail, fPCName, '<body><p>������������: '+fUserName+'</p><pre>'+FormatArray(fDevices)+'</pre></body>' ]);

            fQuery.ExecSQL;

        except
            on e: Exception do
            begin
                Error := e.Message;
                exit;
            end;
        end;

    end;

    /// ���������� ������ �� ����������� ��������.
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

    /// ����������� � ��
    fConnection := TADOConnection.Create(nil);
    fConnection.LoginPrompt:= false;
    fConnection.ConnectionString := CONNECTION_STRING;
    fConnection.DefaultDatabase := DEFAULT_DATABASE;
    fConnection.Connected := true;

    /// ��������� ���������� ��� ��������
    fQuery := TADOQuery.Create(nil);
    fQuery.Connection := fConnection;

    /// ���� ���������� ��������� �� ��������� ������������
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
    Result := '����� �� ��������';
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
    Result := '����� �� ��������';
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
    Result := '����� �� ��������';
end;

initialization

    PCAdviser := TPCAdviser.Create;

finalization

    PCAdviser.Free;

end.


