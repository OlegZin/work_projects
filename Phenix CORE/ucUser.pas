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
  end;


//var

  //User : TUser;

implementation

uses
    uPhenixCORE, SysUtils;

function TUser.initUser( WLogin: string ): boolean;
begin

    lC('TUser.initUser');

    if WLogin = '' then
    begin
        Core.Log.Error('�� ������ ����� ������������. ��������� ������ ����������');
        lCE;
        exit;
    end;

    WinLogin := WLogin;

    result := false;
    // �������� ������ � �������������� ������ ������������
    if not Core.DM.OpenQuery( Format( 'SELECT * FROM employees WHERE host = ''%s''', [ WinLogin ] ),
                         '��������� ������ ������������ ')
    then
        Core.Log.Error(''{geError.mess})
    else
    if Assigned(Core.User) then
    with Core.User do
    begin
        id := Core.DM.Query.FieldByName('id').AsInteger;
        name := Core.DM.Query.FieldByName('name').AsString;
        result := true;
    end;

    lCE;

end;

end.
