unit uTypes;

interface

type

    TLogRecord = record
        _MessTime : TDateTime;
        _GlobComment : string[100];  // глобальный комментарий(процедура)
        _Comment : string[100];      // локальный комментарий имено к этой записи, будет приклеен к глобальному
        _Level : integer;            // уровень вложенности процедуры(комментария)
        _MessType : integer;         // тип (цвет) строки лога
        _Text : string;              // содержимое строки лога
        _Index : integer;            // для привязки к компоненту вывода лога(lbLog) для фильтрации по типам
    end;

implementation

end.
