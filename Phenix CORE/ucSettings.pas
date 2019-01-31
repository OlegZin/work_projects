{*******************************************************************************
  Модуль работы с настройками программы.
  Предоставляет единый интерфейс для:
      - Сохранения/восстановления положения и размера окон
      - Состояние таблиц (ширина и видимость колонок)
      - Состояние иных компонент (фильтров, кнопок и т.д.)

  Настройки компонента хранятся в таблице GlobalSettings
*******************************************************************************}
unit ucSettings;

interface

uses

   SysUtils;

type

    TSettingsManager = class
    {public}
        UserId: integer;
        ProgramName: string;
        TableName: string;

//        Function SaveForm(form: TForm): boolean;
                        // сохраняет в ini параметры переданной формы
//        Function RestoreForm(form: TForm): boolean;
                        // читает из ini параметры и применяет к переданной форме

        Function SaveValue(section, propName: string; value: variant): boolean;
                        // сохраняет отдельное значение
                        // для ясности, рекомендуется в качестве section указывать имя компенента
                        // а propName - имя свойства

        Function LoadValue(section, propName: string; def: variant): variant;
                        // загружает и отдает сохраненное значение

    private
        function SettingsWrite(UserId: integer; progName, section, propName, value: string): boolean;
                             // пишем настройку в таблицу настроек
        function SettingsRead(UserId: integer; progName, section, propName: string; def: variant): variant;
                             // читаем настройку из таблицы настроек

    end;

implementation

uses
    uPhenixCORE;

const

                      // получаем значение указанной настройки из базы
    SQL_GET_SETTINGS_VALUE =
         'SELECT value '                                    + sLineBreak +
         'FROM %s '                                         + sLineBreak +
         'WHERE '                                           + sLineBreak +
             'EmpID = %d '                                  + sLineBreak +
             'AND '                                         + sLineBreak +
             'progName = ''%s'' '                           + sLineBreak +
             'AND '                                         + sLineBreak +
             'section = ''%s'''                             + sLineBreak +
             'AND '                                         + sLineBreak +
             'propName = ''%s''';

                     // обновляем значение настройки в базе или создаем новую
    SQL_SET_SETTINGS_VALUE =
         'DECLARE @EmpId int             = %d'                   + sLineBreak +
         'DECLARE @progName varchar(100) = ''%s'''               + sLineBreak +
         'DECLARE @section varchar(100)  = ''%s'''               + sLineBreak +
         'DECLARE @propName varchar(100) = ''%s'''               + sLineBreak +
         'DECLARE @value varchar(100)    = ''%s'''               + sLineBreak +

         'DECLARE @ID int = ('                              + sLineBreak +
         'SELECT id '                                       + sLineBreak +
         'FROM %s '                                         + sLineBreak +
         'WHERE '                                           + sLineBreak +
             'EmpId = @EmpId '                              + sLineBreak +
           'AND '                                           + sLineBreak +
             'progName = @progName '                        + sLineBreak +
           'AND '                                           + sLineBreak +
             'section = @section '                          + sLineBreak +
           'AND '                                           + sLineBreak +
             'propName = @propName) '                       + sLineBreak +
         'IF @ID is null '                                  + sLineBreak +
         'BEGIN '                                           + sLineBreak +
             'INSERT INTO %s '                              + sLineBreak +
             '(EmpId, progName, section, propName, value) ' + sLineBreak +
             'VALUES '                                      + sLineBreak +
             '(@EmpId, @progName, @section, @propName, @value) ' + sLineBreak +
         'END ELSE '                                        + sLineBreak +
         'BEGIN '                                           + sLineBreak +
             'UPDATE %s '                                   + sLineBreak +
             'SET value = @value '                          + sLineBreak +
             'WHERE '                                       + sLineBreak +
                 'EmpId = @EmpId '                          + sLineBreak +
               'AND '                                       + sLineBreak +
                 'progName = @progName '                    + sLineBreak +
               'AND '                                       + sLineBreak +
                 'section = @section '                      + sLineBreak +
               'AND '                                       + sLineBreak +
                 'propName = @propName '                    + sLineBreak +
         'END ';


var
   section     // раздел, в который сохранять/читать значения
  ,prop        // имя свойства
           : string;

function TSettingsManager.LoadValue(section, propName: string; def: variant): variant;
begin
    result := SettingsRead(UserId, ProgramName, section, propName, def);
end;

function TSettingsManager.SaveValue(section, propName: string; value: variant): boolean;
begin
    result := SettingsWrite(UserId, ProgramName, section, propName, value);
end;

function TSettingsManager.SettingsRead(UserId: integer; progName, section, propName: string; def: variant): variant;
{ читаем настройку из таблицы настроек }
begin

    result := Core.DM.SimpleValueQuery( Format(SQL_GET_SETTINGS_VALUE,[TableName, UserId, progName, section, propName]) );

    if result = '' then result := def;

end;

function TSettingsManager.SettingsWrite(UserId: integer; progName, section, propName, value: string): boolean;
{ читаем настройку из таблицы настроек }
begin

    result := Core.DM.ExecQuery( Format(SQL_SET_SETTINGS_VALUE,[UserId, progName, section, propName, value, TableName, TableName, TableName]) )

end;


end.
