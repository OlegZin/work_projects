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
        _GlobComment : string[100];  // ���������� �����������(���������)
        _Comment : string[100];      // ��������� ����������� ����� � ���� ������, ����� �������� � �����������
        _Level : integer;            // ������� ����������� ���������(�����������)
        _MessType : integer;         // ��� (����) ������ ����
        _Text : string;              // ���������� ������ ����
        _Index : integer;            // ��� �������� � ������� ��� ����������� ���� � VirtualTreeView
    end;

    TLogArray = array of TLogRecord;

implementation

end.
