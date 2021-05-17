unit uCommonOperations;

interface

uses
    DB, SysUtils, ShellAPI, Windows, Classes, Vcl.ExtCtrls,

    uMain, uConstants;

    procedure OpenFilePreview(dataset: TDataset);
    procedure ShowPreview( filename: string; var image: TImage );

implementation

procedure OpenFilePreview(dataset: TDataset);
{ ��������� ��������� ���� ��� ��������� �� ������ ������������.

  ��������:
  - ��������� ���� � �������� ����� � �������: ���_�����(������).����������
  - �������� ������� ���������� � ������� ����������
}
var
    filename
   ,DBname
            : string;
begin

    // ����� �������� ������ � �������� ���������
    if not Assigned(dataset) or Not dataset.Active or (dataset.RecordCount = 0) then exit;


    // ��������� ���
    filename := ExtractFileName( dataSet.FieldByName('filename').AsString ) +
                '(' + dataSet.FieldByName('version').AsString + ')' +
                ExtractFileExt( dataSet.FieldByName('filename').AsString );

    // ��������� �� ���� ��� ���� ������
    mngData.GetFileFromStorage( DIR_TEMP, Filename, dataSet.FieldByName('GUID').AsString );

    // �������� �������
    ShellExecute(0, 'open', PChar( DIR_TEMP + filename ), nil, nil, SW_SHOWNORMAL);
end;

procedure ShowPreview( filename: string; var image: TImage );
var
    F: TFileStream;
    size : integer;
begin

    // �������� ������ ������ �����. ���� ������� - ����������� �����������
    size := 0;
    if FileExists( Filename ) then
    begin
        F := TFileStream.Create(Filename, fmOpenRead);
        size := F.Size;
        F.Free;
    end;

    if FileExists( filename ) and ( size <> 0 ) then
    begin

        try
            image.Picture.LoadFromFile( filename );
        except
            // ����� ������ �� ����������� �������������� ���������.
            // ����� ���������, ��������, � doc ��� xls ������, ���� ��������� �� ��������� �� ���������� ������ � ������
        end;

    end else
        image.Picture := nil;
end;


end.
