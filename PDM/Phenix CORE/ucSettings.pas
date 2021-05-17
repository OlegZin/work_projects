{*******************************************************************************
  ������ ������ � ����������� ���������.
  ������������� ������ ��������� ���:
      - ����������/�������������� ��������� � ������� ����
      - ��������� ������ (������ � ��������� �������)
      - ��������� ���� ��������� (��������, ������ � �.�.)

  ��������� ���������� �������� � ������� GlobalSettings
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
                        // ��������� � ini ��������� ���������� �����
//        Function RestoreForm(form: TForm): boolean;
                        // ������ �� ini ��������� � ��������� � ���������� �����

        Function SaveValue(section, propName: string; value: variant): boolean;
                        // ��������� ��������� ��������
                        // ��� �������, ������������� � �������� section ��������� ��� ����������
                        // � propName - ��� ��������

        Function LoadValue(section, propName: string; def: variant): variant;
                        // ��������� � ������ ����������� ��������

    private
        function SettingsWrite(UserId: integer; progName, section, propName, value: string): boolean;
                             // ����� ��������� � ������� ��������
        function SettingsRead(UserId: integer; progName, section, propName: string; def: variant): variant;
                             // ������ ��������� �� ������� ��������

    end;

implementation

uses
    uPhenixCORE;

const

                      // �������� �������� ��������� ��������� �� ����
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

                     // ��������� �������� ��������� � ���� ��� ������� �����
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
   section     // ������, � ������� ���������/������ ��������
  ,prop        // ��� ��������
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
{ ������ ��������� �� ������� �������� }
begin

    result := Core.DM.SimpleValueQuery( Format(SQL_GET_SETTINGS_VALUE,[TableName, UserId, progName, section, propName]) );

    if result = '' then result := def;

end;

function TSettingsManager.SettingsWrite(UserId: integer; progName, section, propName, value: string): boolean;
{ ������ ��������� �� ������� �������� }
begin

    result := Core.DM.ExecQuery( Format(SQL_SET_SETTINGS_VALUE,[UserId, progName, section, propName, value, TableName, TableName, TableName]) )

end;


end.
