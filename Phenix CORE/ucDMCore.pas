unit ucDMCore;

interface

uses
    ADODB, SysUtils;

    function dbUtils_ExecQuery(Query: TADOQuery; sql: string; errorMessage: string = ''): boolean;
                         // метод-оболочка для выполнения запросов, не возвращающих данные
                         // при успешном запросе возвращает true

    function dbUtils_SimpleValueQuery(Query: TADOQuery; sql: string; errorMessage: string = ''): variant;
                         // метод-оболочка для выполнения запросов, возвращающих одно значение

    function dbUtils_SimpleValueDefQuery(Query: TADOQuery; sql: string; def: variant; errorMessage: string = ''): variant;
                         // метод-оболочка для выполнения запросов, возвращающих одно значение.
                         // при неудачном запросе или пустых данных возвращается значение def

    function dbUtils_OpenQuery(Query: TADOQuery; sql: string; errorMessage: string): boolean;
                         // метод-оболочка, открывающий набор данных по запросу

implementation

uses
    ucDM
   ,uPhenixCORE;

function dbUtils_ExecQuery(Query: TADOQuery; sql: string; errorMessage: string = ''): boolean;
begin

    Core.DM.DBError := '';

    if sql = '' then exit;
    if not Assigned(Query) then exit;

    result := true;

    try
        Core.Log.Query(sql, errorMessage);

        Query.Close;
        Query.SQL.text := sql;
        Query.ExecSql
    except
        on E:Exception do
        begin
            Core.Log.Error(E.Message, errorMessage);
            Core.DM.DBError := errorMessage + #13#13 + E.Message;
            result := false;
        end;
    end;
end;

function dbUtils_SimpleValueDefQuery(Query: TADOQuery; sql: string; def: variant; errorMessage: string = ''): variant;
begin

    Core.DM.DBError := '';

    result := false;

    if sql = '' then exit;
    if not Assigned(Query) then exit;

    try
        Core.Log.Query(sql, errorMessage);

        Query.Close;
        Query.SQL.text := sql;
        Query.Open;

        if Query.IsEmpty
        then
            result := def
        else
            if Query.fields[0].IsNull
            then
                result := def
            else
                result := Query.fields[0].AsVariant;

        Query.Close;

    except
        on E:Exception do
        begin
          Core.Log.Error(E.Message, errorMessage);
          Core.DM.DBError := errorMessage + #13#13 + E.Message;
          Query.Close;
        end;
    end;
end;

function dbUtils_SimpleValueQuery(Query: TADOQuery; sql: string; errorMessage: string = ''): variant;
begin
    result := dbUtils_SimpleValueDefQuery( Query, sql, '', errorMessage );
end;

function dbUtils_OpenQuery(Query: TADOQuery; sql: string; errorMessage: string): boolean;
begin

    Core.DM.DBError := '';

    result := false;

    if sql = '' then exit;
    if not Assigned(Query) then exit;


    try
        Core.Log.Query(sql, errorMessage);

        Query.Close;
        Query.SQL.text := sql;
        Query.Open;
        result := true;
    except
        on E:Exception do
        begin
          Core.Log.Error(E.Message, errorMessage);
          Core.DM.DBError := errorMessage + #13#13 + E.Message;
        end;
    end;
end;


end.
