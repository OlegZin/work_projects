unit uCommonOperations;

interface

uses
    DB, SysUtils, ShellAPI, Windows, Classes, Vcl.ExtCtrls,

    uMain, uConstants;

    procedure OpenFilePreview(dataset: TDataset);
    procedure ShowPreview( filename: string; var image: TImage );

implementation

procedure OpenFilePreview(dataset: TDataset);
{ открываем выбранный файл для просмотра на машине пользователя.

  алгоритм:
  - выгружаем файл в темповую папку в формате: имя_файла(версия).расширение
  - пытаемся открыть настроеннй в системе программой
}
var
    filename
   ,DBname
            : string;
begin

    // будем работать только с непустым датасетом
    if not Assigned(dataset) or Not dataset.Active or (dataset.RecordCount = 0) then exit;


    // формируем имя
    filename := ExtractFileName( dataSet.FieldByName('filename').AsString ) +
                '(' + dataSet.FieldByName('version').AsString + ')' +
                ExtractFileExt( dataSet.FieldByName('filename').AsString );

    // выгружаем из базы под этим именем
    mngData.GetFileFromStorage( DIR_TEMP, Filename, dataSet.FieldByName('GUID').AsString );

    // пытаемся открыть
    ShellExecute(0, 'open', PChar( DIR_TEMP + filename ), nil, nil, SW_SHOWNORMAL);
end;

procedure ShowPreview( filename: string; var image: TImage );
var
    F: TFileStream;
    size : integer;
begin

    // получаем размер превью файла. если нулевой - некорректно сформирован
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
            // тихая ошибка на некорректно сформированную превьюшку.
            // такое случается, например, у doc или xls файлов, если программы не настроены на сохранение файлов с превью
        end;

    end else
        image.Picture := nil;
end;


end.
