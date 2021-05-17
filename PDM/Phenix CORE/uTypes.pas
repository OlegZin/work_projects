unit uTypes;

interface

type

    TLogRecord = record
        _MessTime : TDateTime;
        _GlobComment : string[100];  // ���������� �����������(���������)
        _Comment : string[100];      // ��������� ����������� ����� � ���� ������, ����� �������� � �����������
        _Level : integer;            // ������� ����������� ���������(�����������)
        _MessType : integer;         // ��� (����) ������ ����
        _Text : string;              // ���������� ������ ����
        _Index : integer;            // ��� �������� � ���������� ������ ����(lbLog) ��� ���������� �� �����
    end;

implementation

end.
