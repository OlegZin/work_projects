{*******************************************************************************
  Модуль проедоставляет интерфейс работы с рассылками:
      - создание / удаление рассылок
      - определение списка получателей рассылки
      - массовая рассылка по привязанным пользователям
*******************************************************************************}
unit ucMail;

interface

uses
    classes, SysUtils;

type

    TMailManager = class
    {public}

        function CreateMail(name, subject, body: string): boolean;
                           // создает новую рассылку с указанным именем и темой.
                           // возвращает истину, если создание успешно

        function DeleteMail(name: string): boolean;
                           // удаляет рассылку с указанным именем и все привязанные к ней настройки.
                           // возвращает истину, если удаление успешно

        function SetName(name, newName: string): boolean;
                           // задаем новое имя рассылки

        function SetBody(name, body: string): boolean;
                           // устанавливает текст рассылки (можно с HTML тегами)

        function GetBody(name: string): string;
                           // возвращает текущий текст рассылки

        function SetSubject(name, subject: string): boolean;
        function GetSubject(name: string): string;

        function ClearConditions(name: string): boolean;
        function AddUserCondition(name, condition: string): boolean;
                           // добавляет новое условие для выборки пользователей из таблицы employees
                           // добавляемые условия автоматически упаковываются в круглые скобки
                           // все условия выборки пользователей добавляются к выборке из таблицы через OR
        function DeleteUserCondition(name, condition: string): boolean;
                           // удаляет указанное условие (если есть)
        function UserExists(name, userid: string): boolean;
                           // проверяет, попадает ли пользователь с указанным id в выборку для получения рассылки

        function GetAllMails: string;
                           // получение списка всех рассылок
        function GetAllConditions(name: string): string;
                           // получение списка всех условий указанной выборки

        function Mail(name: string; data: array of variant): boolean;
                           // произведение указанной рассылки с текущим содержимым
                           // data будут подставлены в тело письма

        function GetDataList(name, field, conditions: string): TStringList;
                           // получаем список данных из указанного поля таблицы employees
                           // например,
        function CompileSQL(name, field, conditions: string): string;

    private
        function GetMailList: boolean;
        function GetConditionList(name: string): boolean;

        function SetMailField(field, name, value: string): boolean;
                           // обновляем указанное поле таблицы рассылок

    end;

implementation

uses
    uPhenixCORE;

const
                      // отправляем письмо средствами SQL сервера
    SQL_SEND_EMAIL = 'exec msdb.dbo.sp_send_dbmail '+
                     '@profile_name=''1'', @recipients=''%s'', @subject=''%s'', @body=''%s''';

    SQL_GET_DATA =
        'SELECT DISTINCT( %s ) '                                  + sLineBreak +
        'FROM EMPLOYEES '                                         + sLineBreak +
        'WHERE '                                                  + sLineBreak +
        '    ( ISNULL( %s, '''' ) <> '''' ) '                     + sLineBreak +
        '%s '                                                     + sLineBreak +
        'ORDER BY 1';

    SQL_GET_MAIL_LIST =
        'SELECT naim FROM pdm_MailList WHERE deleted = 0';

    SQL_GET_CONDITION_LIST =
        'SELECT condition FROM pdm_MailCondition '+
        'WHERE id_maillist = (SELECT id FROM pdm_MailList WHERE naim = ''%s'') AND deleted = 0';

    SQL_GET_MAIL_SUBJECT =
        'SELECT subject FROM pdm_MailList WHERE naim = ''%s''';

    SQL_GET_MAIL_BODY =
        'SELECT body FROM pdm_MailList WHERE naim = ''%s''';

    SQL_SET_MAIL_FIELD =
        'UPDATE pdm_MailList SET %s = ''%s'' WHERE naim = ''%s''';

    SQL_DELETE_ALL_MAIL_CONDITIONS =
        'UPDATE pdm_MailCondition SET deleted = 1 WHERE id_mailList = (SELECT id FROM pdm_MailList WHERE naim = ''%s'')';

    SQL_ADD_MAIL_CONDITION =
        'INSERT INTO pdm_MailCondition (condition, id_mailList) VALUES (''%s'', (SELECT id FROM pdm_MailList WHERE naim = ''%s''))';

    SQL_DELETE_MAIL_CONDITION =
        'DELETE FROM pdm_MailCondition WHERE condition = ''%s'' AND id_mailList = (SELECT id FROM pdm_MailList WHERE naim = ''%s'')';

    SQL_CREATE_MAIL =
        'INSERT INTO pdm_MailList (naim, subject, body) VALUES (''%s'', ''%s'', ''%s'')';

    SQL_DELETE_MAIL =
        'UPDATE pdm_MailList SET deleted = 1 WHERE naim = ''%s''';

{ TMailManager }

function TMailManager.ClearConditions(name: string): boolean;
begin
    Core.Log.Comment('TMailManager.ClearConditions');

    result := Core.DM.ExecQuery( Format( SQL_DELETE_ALL_MAIL_CONDITIONS, [name] ),
                            'Удаление всех условий рассылки' );

    Core.Log.CommentExit;
end;

function TMailManager.CreateMail(name, subject, body: string): boolean;
begin
    Core.Log.Comment('mngMail.CreateMail');

    result := Core.DM.ExecQuery( Format( SQL_CREATE_MAIL, [name, subject, body] ),
                                    'Создание рассылки' );

    Core.Log.CommentExit;
end;

function TMailManager.DeleteMail(name: string): boolean;
begin
    Core.Log.Comment('mngMail.DeleteMail');

    ClearConditions( name );
    result := Core.DM.ExecQuery( Format( SQL_DELETE_MAIL, [name] ),
                                    'Удаление рассылки' );

    Core.Log.CommentExit;
end;

function TMailManager.DeleteUserCondition(name, condition: string): boolean;
begin
    Core.Log.Comment('mngMail.GetAllConditions');

    result := Core.DM.ExecQuery( Format( SQL_DELETE_MAIL_CONDITION, [condition, name] ),
                                    'Удаление условия рассылки' );

    Core.Log.CommentExit;
end;

function TMailManager.GetAllConditions(name: string): string;
var
    maillist: TStringList;
begin
    Core.Log.Comment('mngMail.GetAllConditions');
    Core.Log.Mess('Получаем список условий для: ' + name);

    if GetConditionList( name ) then
    begin
        maillist := TStringList.Create;
        while not Core.DM.Query.eof do
        begin
            maillist.Add(Core.DM.Query.FieldByName('condition').AsString);
            Core.DM.Query.Next;
        end;

        Core.Log.Mess('результат: ' + maillist.CommaText);

        result := maillist.CommaText;
    end;

    Core.Log.CommentExit;
end;

function TMailManager.GetAllMails: string;
var
   maillist: TStringList;
begin
    Core.Log.Comment('mngMail.GetAllMails');
    Core.Log.Mess('Получаем список рассылок');

    if GetMailList then
    begin
        maillist := TStringList.Create;
        while not Core.DM.Query.eof do
        begin
            maillist.Add(Core.DM.Query.FieldByName('naim').AsString);
            Core.DM.Query.Next;
        end;

        Core.Log.Mess('результат: ' + maillist.CommaText);

        result := maillist.CommaText;
    end;

    Core.Log.CommentExit;
end;

function TMailManager.GetBody(name: string): string;
begin

    result := Core.DM.SimpleValueQuery( Format( SQL_GET_MAIL_BODY, [name] ) )

end;

function TMailManager.GetSubject(name: string): string;
begin

    result := Core.DM.SimpleValueQuery( Format( SQL_GET_MAIL_SUBJECT, [name] ) )

end;

function TMailManager.Mail(name: string; data: array of variant): boolean;
begin

  Core.Log.Comment('dm.SendMail');


{  dm.ExecQuery(
      Format( SQL_SEND_EMAIL,
             [mail_addr, mail_subject, mail_text]
      )
  );
}
  Core.Log.Mess('Лог отправлен на мыло администратора');
  Core.Log.CommentExit;

end;

function TMailManager.SetMailField(field, name, value: string): boolean;
begin
    Core.Log.Comment('TMailManager.SetMailField');

    result := Core.DM.ExecQuery( Format( SQL_SET_MAIL_FIELD, [field, value, name] ),
                            'Обновление поля таблицы рассылок' );

    Core.Log.CommentExit;
end;

function TMailManager.SetName(name, newName: string): boolean;
{}
begin
    Core.Log.Comment('TMailManager.SetName');

    result := SetMailField('naim', name, newName);

    Core.Log.CommentExit;
end;

function TMailManager.SetSubject(name, subject: string): boolean;
begin
    Core.Log.Comment('TMailManager.SetSubject');

    result := SetMailField('subject', name, subject);

    Core.Log.CommentExit;
end;

function TMailManager.SetBody(name, body: string): boolean;
begin
    Core.Log.Comment('TMailManager.SetBody');

    result := SetMailField('body', name, body);

    Core.Log.CommentExit;
end;

function TMailManager.AddUserCondition(name, condition: string): boolean;
begin
    Core.Log.Comment('TMailManager.AddUserCondition');

    result := Core.DM.OpenQuery( Format( SQL_ADD_MAIL_CONDITION, [condition, name] ),
                           'Добавление нового условия' );

    Core.Log.CommentExit;
end;

function TMailManager.UserExists(name, userid: string): boolean;
begin

end;

function TMailManager.GetMailList: boolean;
begin
    Core.Log.Comment('TMailManager.GetMailList');

    result := Core.DM.OpenQuery( SQL_GET_MAIL_LIST,
                           'Получаем список имен всех рассылок' );

    Core.Log.CommentExit;
end;

function TMailManager.GetConditionList(name: string): boolean;
begin
  Core.Log.Comment('TMailManager.GetConditionList');

  result := Core.DM.OpenQuery( Format( SQL_GET_CONDITION_LIST, [name]),
                      'Получаем список всех условий выборки получателей' );

  Core.Log.CommentExit;
end;


function TMailManager.GetDataList(name, field, conditions: string): TStringList;
{ получаем данные из таблицы employees по указанному полю
  и возвращаем их в виде строки через запятую
}
begin
    Core.Log.Comment('TMailManager.GetDataList');

    result := TStringList.Create;

    if Core.DM.OpenQuery( CompileSQL(name, field, conditions),
                     'Получаем данные поля' )
    then
    begin
       while not Core.DM.Query.eof do
       begin
           result.Add(Core.DM.Query.Fields[0].AsString);
           Core.DM.Query.next;
       end;
    end;

    Core.Log.CommentExit;
end;

function TMailManager.CompileSQL(name, field, conditions: string): string;
{
  компилируем строку запроса по переданному имени поля и набору условий

  name - имя рассылки по условиям которой выбирать получателей
  field - данные какого поля вернуть
  conditions - если не пустая строка, будут использоваться вместо условий указанной рассылки
           представляет собой строку с набором условий, разделенных запятой

  перед получением данных, формируется подстрока условий для подстановки в раздел WHERE
  запроса вида:
  ( условие1 ) OR ( условие2 ) OR ( условие3 ) ...
  ,после чего дополнительно оборачивается перед подстановкой в запрос, если набор условий не пустой:
   AND ( ( условие1 ) OR ( условие2 ) OR ( условие3 ) ... )

}
var
   list: TStringList;
   i: integer;
   sql : string;
   delimer : string;
begin
    Core.Log.Comment('TMailManager.CompileSQL');

    sql := '';
    list := TStringList.Create;

    if Trim(conditions) = '' then conditions := GetAllConditions(name);

    if Trim(conditions) <> '' then
    begin
        try
            delimer := '';
            list.CommaText := conditions;

            for I := 0 to list.count-1 do
            begin
                sql := sql + delimer + '('+ list[i]+')';
                delimer := ' OR ';
            end;

            if sql <> '' then
               sql := ' AND (' + sql + ') ';

        except
            on E:Exception do
            begin
               Core.Log.Mess('sql: ' + sql);
               Core.Log.Error(e.Message)
            end;
        end;
    end;

    result := Format( SQL_GET_DATA, [field, field, sql]);

    list.Free;

    Core.Log.CommentExit;
end;

end.
