{*******************************************************************************
  ������ �������������� ��������� ������ � ����������:
      - �������� / �������� ��������
      - ����������� ������ ����������� ��������
      - �������� �������� �� ����������� �������������
*******************************************************************************}
unit ucMail;

interface

uses
    classes, SysUtils;

type

    TMailManager = class
    {public}

        function CreateMail(name, subject, body: string): boolean;
                           // ������� ����� �������� � ��������� ������ � �����.
                           // ���������� ������, ���� �������� �������

        function DeleteMail(name: string): boolean;
                           // ������� �������� � ��������� ������ � ��� ����������� � ��� ���������.
                           // ���������� ������, ���� �������� �������

        function SetName(name, newName: string): boolean;
                           // ������ ����� ��� ��������

        function SetBody(name, body: string): boolean;
                           // ������������� ����� �������� (����� � HTML ������)

        function GetBody(name: string): string;
                           // ���������� ������� ����� ��������

        function SetSubject(name, subject: string): boolean;
        function GetSubject(name: string): string;

        function ClearConditions(name: string): boolean;
        function AddUserCondition(name, condition: string): boolean;
                           // ��������� ����� ������� ��� ������� ������������� �� ������� employees
                           // ����������� ������� ������������� ������������� � ������� ������
                           // ��� ������� ������� ������������� ����������� � ������� �� ������� ����� OR
        function DeleteUserCondition(name, condition: string): boolean;
                           // ������� ��������� ������� (���� ����)
        function UserExists(name, userid: string): boolean;
                           // ���������, �������� �� ������������ � ��������� id � ������� ��� ��������� ��������

        function GetAllMails: string;
                           // ��������� ������ ���� ��������
        function GetAllConditions(name: string): string;
                           // ��������� ������ ���� ������� ��������� �������

        function Mail(name: string; data: array of variant): boolean;
                           // ������������ ��������� �������� � ������� ����������
                           // data ����� ����������� � ���� ������

        function GetDataList(name, field, conditions: string): TStringList;
                           // �������� ������ ������ �� ���������� ���� ������� employees
                           // ��������,
        function CompileSQL(name, field, conditions: string): string;

    private
        function GetMailList: boolean;
        function GetConditionList(name: string): boolean;

        function SetMailField(field, name, value: string): boolean;
                           // ��������� ��������� ���� ������� ��������

    end;

implementation

uses
    uPhenixCORE;

const
                      // ���������� ������ ���������� SQL �������
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
                            '�������� ���� ������� ��������' );

    Core.Log.CommentExit;
end;

function TMailManager.CreateMail(name, subject, body: string): boolean;
begin
    Core.Log.Comment('mngMail.CreateMail');

    result := Core.DM.ExecQuery( Format( SQL_CREATE_MAIL, [name, subject, body] ),
                                    '�������� ��������' );

    Core.Log.CommentExit;
end;

function TMailManager.DeleteMail(name: string): boolean;
begin
    Core.Log.Comment('mngMail.DeleteMail');

    ClearConditions( name );
    result := Core.DM.ExecQuery( Format( SQL_DELETE_MAIL, [name] ),
                                    '�������� ��������' );

    Core.Log.CommentExit;
end;

function TMailManager.DeleteUserCondition(name, condition: string): boolean;
begin
    Core.Log.Comment('mngMail.GetAllConditions');

    result := Core.DM.ExecQuery( Format( SQL_DELETE_MAIL_CONDITION, [condition, name] ),
                                    '�������� ������� ��������' );

    Core.Log.CommentExit;
end;

function TMailManager.GetAllConditions(name: string): string;
var
    maillist: TStringList;
begin
    Core.Log.Comment('mngMail.GetAllConditions');
    Core.Log.Mess('�������� ������ ������� ���: ' + name);

    if GetConditionList( name ) then
    begin
        maillist := TStringList.Create;
        while not Core.DM.Query.eof do
        begin
            maillist.Add(Core.DM.Query.FieldByName('condition').AsString);
            Core.DM.Query.Next;
        end;

        Core.Log.Mess('���������: ' + maillist.CommaText);

        result := maillist.CommaText;
    end;

    Core.Log.CommentExit;
end;

function TMailManager.GetAllMails: string;
var
   maillist: TStringList;
begin
    Core.Log.Comment('mngMail.GetAllMails');
    Core.Log.Mess('�������� ������ ��������');

    if GetMailList then
    begin
        maillist := TStringList.Create;
        while not Core.DM.Query.eof do
        begin
            maillist.Add(Core.DM.Query.FieldByName('naim').AsString);
            Core.DM.Query.Next;
        end;

        Core.Log.Mess('���������: ' + maillist.CommaText);

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
  Core.Log.Mess('��� ��������� �� ���� ��������������');
  Core.Log.CommentExit;

end;

function TMailManager.SetMailField(field, name, value: string): boolean;
begin
    Core.Log.Comment('TMailManager.SetMailField');

    result := Core.DM.ExecQuery( Format( SQL_SET_MAIL_FIELD, [field, value, name] ),
                            '���������� ���� ������� ��������' );

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
                           '���������� ������ �������' );

    Core.Log.CommentExit;
end;

function TMailManager.UserExists(name, userid: string): boolean;
begin

end;

function TMailManager.GetMailList: boolean;
begin
    Core.Log.Comment('TMailManager.GetMailList');

    result := Core.DM.OpenQuery( SQL_GET_MAIL_LIST,
                           '�������� ������ ���� ���� ��������' );

    Core.Log.CommentExit;
end;

function TMailManager.GetConditionList(name: string): boolean;
begin
  Core.Log.Comment('TMailManager.GetConditionList');

  result := Core.DM.OpenQuery( Format( SQL_GET_CONDITION_LIST, [name]),
                      '�������� ������ ���� ������� ������� �����������' );

  Core.Log.CommentExit;
end;


function TMailManager.GetDataList(name, field, conditions: string): TStringList;
{ �������� ������ �� ������� employees �� ���������� ����
  � ���������� �� � ���� ������ ����� �������
}
begin
    Core.Log.Comment('TMailManager.GetDataList');

    result := TStringList.Create;

    if Core.DM.OpenQuery( CompileSQL(name, field, conditions),
                     '�������� ������ ����' )
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
  ����������� ������ ������� �� ����������� ����� ���� � ������ �������

  name - ��� �������� �� �������� ������� �������� �����������
  field - ������ ������ ���� �������
  conditions - ���� �� ������ ������, ����� �������������� ������ ������� ��������� ��������
           ������������ ����� ������ � ������� �������, ����������� �������

  ����� ���������� ������, ����������� ��������� ������� ��� ����������� � ������ WHERE
  ������� ����:
  ( �������1 ) OR ( �������2 ) OR ( �������3 ) ...
  ,����� ���� ������������� ������������� ����� ������������ � ������, ���� ����� ������� �� ������:
   AND ( ( �������1 ) OR ( �������2 ) OR ( �������3 ) ... )

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
