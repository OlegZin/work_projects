unit uPhenixTypes;

interface

const

    FILTER_BLACK  = 0;
    FILTER_YELLOW = 1;
    FILTER_RED    = 2;
    FILTER_BLUE   = 3;

    MESS_TYPE_TEXT    = 0;
    MESS_TYPE_WARNING = 1;
    MESS_TYPE_ERROR   = 2;
    MESS_TYPE_QUERY   = 3;

type

    TLogRecord = record
        _MessTime : TDateTime;
        _GlobComment : string[100];  // глобальный комментарий(процедура)
        _Comment : string[100];      // локальный комментарий имено к этой записи, будет приклеен к глобальному
        _Level : integer;            // уровень вложенности процедуры(комментария)
        _MessType : integer;         // тип (цвет) строки лога
        _Text : string;              // содержимое строки лога
        _Index : integer;            // для привязки к фильтру или виртуальной ноде в VirtualTreeView
    end;

    TLogArray = array of TLogRecord;

implementation

end.
