unit uPhenixCore;

interface

uses
    ucDM         // модуль работы с базой данных
   ,ucLog        // модуль логировния
   ,ucSettings   // модуль хранения настроек в БД
   ,ucMail       // модуль рассылок
   ,ucUser       // модуль работы с данными пользователя
   ,ucTools      // модуль вспомогательных функций
   ,ucListSearch // модуль показа формы для выбора варианта из списка

   ,SysUtils
   ;
type

    TCore = class

        SavePath: string;

        DM : Tdm;
        Log : TLogManager;
        Settings : TSettingsManager;
        Mail: TMailManager;
        User: TUser;
        LSearch: TListSearch;

        function Init(
            ProgramName: string;
            ConnectionString: WideString;
            SettingsTableName,
            LogFilepath: string;
            var error: string
        ): boolean;

    end;

    procedure lC(comment: string);
    procedure lCE;
    function lM(text: string; comment: string = ''): string;
    function lW(text: string; comment: string = ''): string;
    function lE(text: string; comment: string = ''): string;
    function lQ(text: string; comment: string = ''): string;

    function dmOQ(sql: string; errorMessage: string = ''): boolean;
    function dmEQ(sql: string; errorMessage: string = ''): boolean;
    function dmSQ(sql: string; errorMessage: string = ''): variant;
    function dmSDQ(sql: string; def: variant; errorMessage: string = ''): variant;
    function dmIQ(sql: string; errorMessage: string = ''): variant;

//    function sSF(form: TForm): boolean;
//    function sRF(form: TForm): boolean;

var

   Core : TCore;

implementation


{ TCore }

function TCore.Init(ProgramName: string; ConnectionString: WideString;
  SettingsTableName, LogFilepath: string; var error : string): boolean;
begin

    result := true;

    try

        Log          := TLogManager.Create;
        Log.SavePath := LogFilepath;
        Log.Init;

        Settings := TSettingsManager.Create;
        Mail     := TMailManager.Create;

        DM       := Tdm.Create(nil);
        DM.InitDBConnection(ConnectionString);

        User     := TUser.Create;
        User.initUser( GetComputerNetName { GetWinLogin } );

        LSearch := TListSearch.Create;

        Settings.ProgramName := ProgramName;
        Settings.TableName := SettingsTableName;

    except

        on e: Exception do
        begin
             error := e.Message;
             result := false;
        end;

    end;

end;

{*******************************************************************************
    Обертки для методов класса LOG для более краткого вызова в коде программ
*******************************************************************************}
procedure lC(comment: string);
begin
    Core.Log.Comment(comment);
end;

procedure lCE;
begin
    Core.Log.CommentExit;
end;

function lE(text: string; comment: string = ''): string;
begin
    result := Core.Log.Error(text, comment);
end;

function lM(text: string; comment: string = ''): string;
begin
    result := Core.Log.Mess(text, comment);
end;

function lQ(text: string; comment: string = ''): string;
begin
    result := Core.Log.Query(text, comment);
end;

function lW(text: string; comment: string = ''): string;
begin
    result := Core.Log.Warning(text, comment);
end;




{*******************************************************************************
    Обертки для методов класса DM для более краткого вызова в коде программ
*******************************************************************************}

function dmEQ(sql: string; errorMessage: string = ''): boolean;
begin
    result := Core.dm.ExecQuery(sql, errorMessage);
end;

function dmOQ(sql: string; errorMessage: string = ''): boolean;
begin
    result := Core.dm.OpenQuery(sql, errorMessage);
end;

function dmSQ(sql: string; errorMessage: string = ''): variant;
begin
    result := Core.dm.SimpleValueQuery(sql, errorMessage);
end;

function dmSDQ(sql: string; def: variant; errorMessage: string = ''): variant;
begin
    result := Core.dm.SimpleValueDefQuery(sql, def, errorMessage);
end;

function dmIQ(sql: string; errorMessage: string = ''): variant;
begin
    result := Core.dm.InsertQuery(sql, errorMessage);
end;



{*******************************************************************************
    Обертки для методов класса Settings
*******************************************************************************}

{
function sSF(form: TForm): boolean;
begin
    result := Core.Settings.SaveForm(TForm(form));
end;

function sRF(form: TForm): boolean;
begin
    result := Core.Settings.RestoreForm(form);
end;
}
end.
