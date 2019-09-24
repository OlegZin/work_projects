unit ucUser;

interface

type

  TUser = class
      id                 // � ������� employees
              : integer;
      name               // ��� ������������ � �������: ������� �.�.
              : string;

      WinLogin: string;

      function initUser( WLogin: string ): boolean;
      function initUserByID( _id: integer ): boolean;

  end;


//var

  //User : TUser;

implementation

uses
    uPhenixCORE, SysUtils;

function TUser.initUser( WLogin: string ): boolean;
label ext;
begin

    lC('TUser.initUser');
    result := false;

    if WLogin = '' then
    begin
        Core.Log.Error('�� ������ ����� ������������. ��������� ������ ����������');
        lCE;
        goto ext;
    end;

    Core.Log.Mess('����� ������������: ' + WLogin);
    WinLogin := WLogin;

    // �������� ������ � �������������� ������ ������������
    if not Core.DM.OpenQuery(
        ' SELECT e.* FROM [nft].[dbo].[EMPLOYEES] e '+
        ' left join [nft].[sec].[objects] o ON o.id = e.user_id '+
        ' WHERE o.name = '''+WinLogin+'''',

        '��������� ������ ������������ ') then
    begin
        Core.Log.Error( Core.DM.DBError );
        goto ext;
    end;

    if Assigned(Core.User) and (Core.DM.Query.RecordCount > 0) then
    with Core.User do
    begin
        id := Core.DM.Query.FieldByName('id').AsInteger;
        name := Core.DM.Query.FieldByName('name').AsString;
        result := true;
        Core.Log.Mess('������ ������������: ' + name + ' ('+ IntToStr(id) +')');
    end
    else
        Core.Log.Error( '�� ������� ������������ � ������ ������� (host)' );

ext:
    lCE;

end;

function TUser.initUserByID( _id: integer ): boolean;
begin

    lC('TUser.initUserByID');
    result := false;

    if id = 0 then
    begin
        Core.Log.Error('�� ������ id ������������. ��������� ������ ����������');
        lCE;
        exit;
    end;

    // �������� ������ � �������������� ������ ������������
    if not Core.DM.OpenQuery( Format( 'SELECT * FROM [nft].[dbo].[EMPLOYEES] WHERE id = %d', [ _id ] ),
                         '��������� ������ ������������ ')
    then
        Core.Log.Error( Core.DM.DBError )
    else
    if Assigned(Core.User) then
    with Core.User do
    begin
        id := _id;
        name := Core.DM.Query.FieldByName('name').AsString;
        WinLogin := Core.DM.Query.FieldByName('host').AsString;;
        result := true;
    end;

    lCE;

end;


end.
