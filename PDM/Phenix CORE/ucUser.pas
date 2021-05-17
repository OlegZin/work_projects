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
        Core.Log.Error('Не указан логин пользователя. Получение данных невозможно');
        lCE;
        goto ext;
    end;

    Core.Log.Mess('Логин пользователя: ' + WLogin);
    WinLogin := WLogin;

    // получаем данные и инициализируем объект пользователя
    if not Core.DM.OpenQuery(
        ' SELECT e.* FROM [nft].[dbo].[EMPLOYEES] e '+
        ' left join [nft].[sec].[objects] o ON o.id = e.user_id '+
        ' WHERE o.name = '''+WinLogin+'''',

        'Получение данных пользователя ') then
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
        Core.Log.Mess('Найден пользователь: ' + name + ' ('+ IntToStr(id) +')');
    end
    else
        Core.Log.Error( 'Не найдено пользователя с данным логином (host)' );

ext:
    lCE;

end;

function TUser.initUserByID( _id: integer ): boolean;
begin

    lC('TUser.initUserByID');
    result := false;

    if id = 0 then
    begin
        Core.Log.Error('Не указан id пользователя. Получение данных невозможно');
        lCE;
        exit;
    end;

    // получаем данные и инициализируем объект пользователя
    if not Core.DM.OpenQuery( Format( 'SELECT * FROM [nft].[dbo].[EMPLOYEES] WHERE id = %d', [ _id ] ),
                         'Получение данных пользователя ')
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
