unit ucUser;

interface

type

  TUser = class
      id                 // в таблице employees
              : integer;
      name               // имя пользователя в формате: Фамилия И.О.
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
        Core.Log.Error('Не указан логин пользователя. Получение данных невозможно');
        lCE;
        exit;
    end;

    WinLogin := WLogin;

    result := false;
    // получаем данные и инициализируем объект пользователя
    if not Core.DM.OpenQuery( Format( 'SELECT * FROM employees WHERE host = ''%s''', [ WinLogin ] ),
                         'Получение данных пользователя ')
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
