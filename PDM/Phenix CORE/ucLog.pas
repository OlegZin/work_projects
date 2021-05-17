unit ucLog;

interface

uses SysUtils, Classes, System.ZLib, uPhenixTypes;

const
{
  FILTER_BLACK  = 0;
  FILTER_YELLOW = 1;
  FILTER_RED    = 2;
  FILTER_BLUE   = 3;
}
  { ��� ���������� ������� � ����, �� ������������ � ���� ��������� ������,
    ����������� �� �������� ��������� ������������ ��������  }
  ELEM_BREAKER  = '_;_';      // ��������� �������� ������ ���� (TLogRecord)
  FIELD_BREAKER = '_;;_';     // ��������� ������ ����� �������� ������� (_MessTime, _GlobComment,...)
  LINE_BREAKER  = '_;;;_';    // ��������� �������� ���� ���������, ���� ��� �������������

  UNPACKED_EXT = '.txt';
  PACKED_EXT = '.pack';

type
{
    TLogRecord = record
        _MessTime : TDateTime;
        _GlobComment : string[100];  // ���������� �����������(���������)
        _Comment : string[100];      // ��������� ����������� ����� � ���� ������, ����� �������� � �����������
        _Level : integer;            // ������� ����������� ���������(�����������)
        _MessType : integer;         // ��� (����) ������ ����
        _Text : string;              // ���������� ������ ����
        _Index : integer;            // ��� �������� � ���������� ������ ����(lbLog) ��� ���������� �� �����
    end;
}
    TLogManager = class
        SavePath: string;

        procedure Init;
        procedure Comment(PName: string); // ������������� ����������� (��� �������/��������) ��� ����������� ��������� � ����
        procedure CommentExit;               // ������������ � ����������� ����������� � ����� ��� ����������� ��������� � ����
        function Mess(atext: string; comment: string = ''): string;   // ������� ��������� � ���
        function Warning(atext: string; comment: string = ''): string;  // ���������-�������������� � ���
        function Error(atext: string; comment: string = ''): string;  // ��������� �� ������ � ���
        function Query(atext: string; comment: string = ''): string;  // ��������� c sql-������� � ���
        function RowCount: integer;
        function GetRow(index: integer): TLogRecord;
        procedure Clear;

        function SaveToFile: string;  // ��������� ������ � ������� ����� � ���� � ���������� ������ ���� �� ����
        function LoadFromFileEx(filename: string; var targetArr: TLogArray): boolean;
        function LoadFromFile(filename: string): boolean;
    private

        LogArr: TLogArray; // ������ ��������� ����
        CommArr: Array of String;    // ������
        curComment: integer;         // ������ ������� �������� ���������(�����������)

        function toLog(mess_type: integer; atext: string; comm: string = ''): TLogRecord;
    end;

implementation

uses  uPhenixCORE;

function TLogManager.toLog(mess_type: integer; atext: string; comm: string = ''): TLogRecord;
begin

    SetLength(LogArr, Length(LogArr)+1);
    With LogArr[High(LogArr)] do
    begin
        _MessTime := Now;
        _GlobComment := CommArr[curComment];
        _Comment := comm;
        _Level := curComment;
        _MessType := mess_type;
        _Text     := atext;
        _Index    := High(LogArr);
    end;

    result := LogArr[High(LogArr)];

end;

procedure TLogManager.Comment(PName: string);
{ ���������� � ���� �������� ������ ����������� � ������� � ��� }
begin
    Inc(curComment);

    if curComment > High(CommArr) then
    begin
        SetLength(CommArr, Length(CommArr) + 1);
    end;

    CommArr[curComment] := Pname;
end;

procedure TLogManager.CommentExit;
{ ������������ � ����������� ����������� � ����� }
begin
    Dec(curComment);
    if curComment < 0 then curComment := 0;
end;

procedure TLogManager.Clear;
begin
    SetLength( LogArr, 0 );
end;

function TLogManager.GetRow(index: integer): TLogRecord;
begin
    if ( index < 0 ) or ( index > High(LogArr) ) then exit;

    result := LogArr[index];

end;

function TLogManager.Mess(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_BLACK, atext, comment);
    result := atext;
end;

function TLogManager.Warning(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_YELLOW, atext, comment);
    result := atext;
end;

function TLogManager.RowCount: integer;
begin
    result := Length(LogArr);
end;

function TLogManager.SaveToFile: string;
{ ��������� ������� ��� � ���� � ���������� ���� �� ���� }
var
   list: TStringList;
   i: integer;
   breaker,
   filename,
   text: string;
   LInput, LOutput: TFileStream;
   LZip: TZCompressionStream;

   function PackStrings(text: string): string;
   var
       j: integer;
       breaker : string;
   begin

       list.Text := text;
       breaker := '';
       result := '';
       for j := 0 to list.Count -1 do
       begin
          result := result + breaker + list[j];
          breaker := LINE_BREAKER;
       end;

   end;

begin
    result := '';
    text := '';
    breaker := '';

    if Length(LogArr) = 0 then exit;

    if SavePath = '' then
    begin
        lE('�� ������ ���� ��� ���������� ���-������. �������� ����������.');
        exit;
    end;

    filename := Core.User.WinLogin + '('+FormatDateTime('d/m/y h/n', Now)+')';
    list := TStringList.Create;

    for I := 0 to High(LogArr) do
    begin
        text := text + breaker +
            DateTimeToStr(LogArr[i]._MessTime)    + FIELD_BREAKER +
//            PackStrings  (LogArr[i]._GlobComment) + FIELD_BREAKER +
//            PackStrings  (LogArr[i]._Comment)     + FIELD_BREAKER +
            LogArr[i]._GlobComment + FIELD_BREAKER +
            LogArr[i]._Comment     + FIELD_BREAKER +
            IntToStr     (LogArr[i]._Level)       + FIELD_BREAKER +
            IntToStr     (LogArr[i]._MessType)    + FIELD_BREAKER +
            PackStrings  (LogArr[i]._Text)        {+ FIELD_BREAKER};
        breaker := ELEM_BREAKER;
    end;

    list.Free;

    // ����� ������ ��� � ����
    LOutput:= TFileStream.Create(SavePath + filename + UNPACKED_EXT, fmCreate);
    try
        LOutput.WriteBuffer(Pointer(text)^, Length(text)*2);   // ����� ����� �������� � UNICODE, ��� �� 2 ����� �� ������
    finally
        LOutput.Free;
    end;

    // ������� �������������� ���
    try
        LInput := TFileStream.Create(SavePath + filename + UNPACKED_EXT, fmOpenRead);
        LOutput := TFileStream.Create(SavePath + filename + PACKED_EXT, fmCreate);
        LZip := TZCompressionStream.Create(clDefault, LOutput);

        LZip.CopyFrom(LInput, LInput.Size);

    finally
        LZip.Free;
        LInput.Free;
        LOutput.Free;
    end;

    DeleteFile( SavePath + filename + UNPACKED_EXT );

    if FileExists(SavePath + filename + PACKED_EXT) then
        result := SavePath + filename + PACKED_EXT;
end;

function TLogManager.LoadFromFileEx(filename: string; var targetArr: TLogArray): boolean;
var
  LInput, LOutput: TFileStream;
  LUnZip: TZDecompressionStream;
  existFileName,
  text: string;
  LBuff: TArray<Byte>;
  list, elem: TStringList;
  i: integer;

begin

    lC('LogManager.LoadFromFileEx');

    result := false;

    lM('��������� ���-���� "'+filename+'"');

    // ���������, �� �������� �� ������ ��� �����
    if FileExists(filename)                         then existFileName := filename;
    if FileExists(filename + PACKED_EXT)            then existFileName := filename + PACKED_EXT;
    if FileExists(SavePath + filename)              then existFileName := SavePath + filename;
    if FileExists(SavePath + filename + PACKED_EXT) then existFileName := SavePath + filename + PACKED_EXT;

    if filename = '' then
    begin
        lE('�� ������� ��� ���-�����. �������� ����������');
        lCE;
        exit;
    end;

    if existFileName = '' then
    begin
        lE('���� "'+filename+'" �� ���������. �������� ����������.');
        lCE;
        exit;
    end;

    // ������������� ���
    try
    try
        LInput := TFileStream.Create(existFileName, fmOpenRead);
        LOutput := TFileStream.Create(ChangeFileExt(existFileName, UNPACKED_EXT), fmCreate);
        LUnZip := TZDecompressionStream.Create(LInput);

        LOutput.CopyFrom(LUnZip, 0);
    finally
        LUnZip.Free;
        LInput.Free;
        LOutput.Free;
    end;
    except
        on E: Exception do
        begin
           lE('������ ���������� ����:' + sLineBreak + E.Message );
           lCE;
           exit;
        end;
    end;

    // ������ ������������� ��� � ����������
    try
    LInput:= TFileStream.Create(ChangeFileExt(existFileName, UNPACKED_EXT), fmOpenRead);
    try
        SetLength(LBuff, LInput.Size);
        LInput.ReadBuffer(LBuff[0], Length(LBuff));
        text := TEncoding.Unicode.GetString(LBuff);
    finally
        LOutput.Free;
    end;
    except
        on E: Exception do
        begin
           lE('������ ���������� ����:' + sLineBreak + E.Message );
           lCE;
           exit;
        end;
    end;

    if text = '' then
    begin
        lE('���� ���� ��� ���������.');
        lCE;
        exit;
    end;


    // ������ ���� �������������� ����
    if FileExists(ChangeFileExt(existFileName, UNPACKED_EXT)) then
       DeleteFile(ChangeFileExt(existFileName, UNPACKED_EXT));


    // ��������� ���������� ������ �� �������� � ��������� ������ ����
    try
        list := TStringList.Create;
        elem := TStringList.Create;

        SetLength(targetArr, 0);
        list.Text := StringReplace(text, ELEM_BREAKER, sLineBreak, [ rfReplaceAll ] );
        for i := 0 to list.Count - 1 do
        begin
            // ��������� ������ ������ �������� �� ���� � ��������� ������� �������
            SetLength(targetArr, Length(targetArr)+1);
            elem.Text := StringReplace(list[i], FIELD_BREAKER, sLineBreak, [ rfReplaceAll ] );

            // ����� ��������� ������ ���� ���������, ���������� �� ������ ��� ���� � ���������� �� �����
            // (��� ����� ���� ���������� ��� �� ���������� ������ ����)
            if elem.Count >= 1 then targetArr[High(targetArr)]._MessTime    := StrToDateTimeDef(elem[0], Now);
            if elem.Count >= 2 then targetArr[High(targetArr)]._GlobComment := StringReplace(elem[1], LINE_BREAKER, sLineBreak, [ rfReplaceAll ] );
            if elem.Count >= 3 then targetArr[High(targetArr)]._Comment     := StringReplace(elem[2], LINE_BREAKER, sLineBreak, [ rfReplaceAll ] );
            if elem.Count >= 4 then targetArr[High(targetArr)]._Level       := StrToIntDef(elem[3], 0);
            if elem.Count >= 5 then targetArr[High(targetArr)]._MessType    := StrToIntDef(elem[4], 0);
            if elem.Count >= 6 then targetArr[High(targetArr)]._Text        := StringReplace(elem[5], LINE_BREAKER, sLineBreak, [ rfReplaceAll ] );
        end;
    finally
        list.Free;
        elem.Free;
    end;

    result := true;
    lCE;

end;

function TLogManager.Error(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_RED, atext, comment);
    result := atext;
end;

procedure TLogManager.Init;
begin
    curComment := 0;
    SetLength( CommArr, 1 );
    CommArr[ curComment ] := '';
end;

function TLogManager.LoadFromFile(filename: string): boolean;
begin
    LoadFromFileEx(filename, LogArr);
end;

function TLogManager.Query(atext: string; comment: string = ''): string;
begin
    toLog(FILTER_BLUE, atext, comment);
    result := atext;
end;

end.
