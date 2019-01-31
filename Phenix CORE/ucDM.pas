unit ucDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, VCL.Dialogs;

type
  Tdm = class(TDataModule)
    ADOConnection: TADOConnection;
  private
    ADOQTemp : TADOQuery;
  public
    { Public declarations }
    Query: TADOQuery;
    DBError: String;

    function InitDBConnection(conString: widestring): boolean;
                         // ��������� �������� � ����������� � ��
    function GetDataset: TADOQuery;

    function ExecQuery(sql: string; errorMessage: string = ''): boolean;
                         // �����-�������� ��� ���������� ��������, �� ������������ ������ � ��������������
                         // ���������� dm.ADOQtemp. ��� �������� ������� ���������� true
    function InsertQuery(sql: string; errorMessage: string = ''): integer;
                         // �����-�������� ��� ���������� �������� ������� ������, ������������ id ����������� ������
    function SimpleValueQuery(sql: string; errorMessage: string = ''): variant;
                         // �����-�������� ��� ���������� ��������, ������������ ���� �������� � ��������������
                         // ���������� dm.ADOQtemp
    function SimpleValueDefQuery(sql: string; def: variant; errorMessage: string = ''): variant;
                         // �����-�������� ��� ���������� ��������, ������������ ���� �������� � ��������������
                         // ���������� dm.ADOQtemp. ���� ������ ���������, ������������ �������� def.
    function OpenQuery(sql: string; errorMessage: string = ''): Boolean;
                         // �����-�������� ��� �������� ������ ������ � ��������������
                         // ���������� dm.ADOQtemp

    function OpenQueryEx(sql: string; query: TDataSet = nil; errorMessage: string = ''): TADOQuery;
                         // ��������������� �������, ����������� ��������� ������ �
                         // ��������� ������ ������, ����� ADOQTemp �����

  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ Tdm }

uses
    ucDMCore, uPhenixCORE;


{ �������� ������ ���������� �������� }

function Tdm.OpenQueryEx(sql: string; query: TDataSet = nil; errorMessage: string = ''): TADOQuery;
begin

    if not Assigned(query)
    then result := GetDataset
    else result := query as TADOQuery;

    if not dbUtils_OpenQuery(result, sql, errorMessage) then
    begin
        result.free;
        result := nil;
    end;

end;

function Tdm.OpenQuery(sql, errorMessage: string): boolean;
begin

    result := dbUtils_OpenQuery(ADOQtemp, sql, errorMessage);

end;

function Tdm.ExecQuery(sql: string; errorMessage: string = ''): boolean;
begin

    result := dbUtils_ExecQuery(ADOQtemp, sql, errorMessage);

end;

function Tdm.InsertQuery(sql, errorMessage: string): integer;
begin

    sql := sql + ' select scope_identity() as id';
    result := dbUtils_SimpleValueQuery(ADOQtemp, sql, errorMessage);

end;

function Tdm.SimpleValueQuery(sql: string; errorMessage: string = ''): variant;
begin

   result := dbUtils_SimpleValueQuery(ADOQtemp, sql, errorMessage);

end;

function Tdm.SimpleValueDefQuery(sql: string; def: variant; errorMessage: string = ''): variant;
begin

   result := dbUtils_SimpleValueDefQuery(ADOQtemp, sql, def, errorMessage);

end;

function Tdm.GetDataset: TADOQuery;
begin
    result := TADOQuery.Create(self);
    result.Connection := ADOConnection;
end;

function Tdm.InitDBConnection(conString: widestring): boolean;
begin

    result := false;

    if Trim(conString) = '' then
    begin
//        error := '�� ������� ������ ���������� �����������';
        exit;
    end;

    ADOConnection.ConnectionString := conString;
    ADOConnection.Connected := true;
    result := ADOConnection.Connected;

    ADOQTemp := TADOQuery.Create(self);
    ADOQTemp.Connection := ADOConnection;
    Query := ADOQtemp;


end;



end.
