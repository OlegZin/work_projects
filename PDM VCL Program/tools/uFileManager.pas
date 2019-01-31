unit uFileManager;
{ модуль извлечения превьюшки из файла
  http://www.delphisources.ru/forum/showthread.php?t=22710

  пример использования:
  Image.Picture.Bitmap.Handle := GetThumbnailImage( OpenDialog.FileName, 400, 400);
}
interface

uses
  ActiveX, ShlObj, Windows, SysUtils, IdHashSHA, Classes;

type

    TFileManager = class
      private
      public

        function GetThumbnailImage(const DisplayName: String; Width: Integer; Height: Integer): HBITMAP;
        // получение картинки-превьюшки содержимого указанного файла

        function GetFileType( ext: string ): integer;
        // получение id типа файла из таблицы

        function GetHash( filename: string ): string;
        // получаем хэш-сумму указанного файла

    end;


implementation

uses uPhenixCORE, uConstants;

type

    IExtractImage = interface
        ['{BB2E617C-0920-11d1-9A0B-00C04FC2D6C1}']
        function GetLocation(pszPathBuffer: LPWSTR; cchMax: DWORD;
            var pdwPriority: DWORD; var prgSize: TSize; dwRecClrDepth: DWORD;
            var pdwFlags: DWORD): HRESULT; stdcall;
        function Extract(var phBmpImage: HBITMAP): HRESULT; stdcall;
    end;



function TFileManager.GetFileType(ext: string): integer;
begin
    result := dmSDQ( 'SELECT icon FROM '+TBL_DOCUMENT_TYPE+' WHERE ext = '''+ ext +'''', 0 );
end;

function TFileManager.GetHash(filename: string): string;
var
    IdHashSHA1: TIdHashSHA1;
    FS: TFileStream;
begin
    FS := TFileStream.Create(FileName,fmOpenRead or fmShareDenyRead);
    IdHashSHA1 := TIdHashSHA1.Create;

    try
        result := IdHashSHA1.HashStreamAsHex(FS);
    finally
        IdHashSHA1.Free;
    end;
    FS.Free;
end;

function TFileManager.GetThumbnailImage(const DisplayName: String;
  Width: Integer; Height: Integer): HBITMAP;
const
    IEIFLAG_OFFLINE = $008;
    IEIFLAG_SCREEN = $020;
    IEIFLAG_QUALITY = $200;
var
    FilePath: String;
    FileName: String;
    DesktopFolder: IShellFolder;
    Eaten: ULONG;
    DirectoryItemIDList: PItemIDList;
    Attributes: ULONG;
    ShellFolder: IShellFolder;
    ExtractImage: IExtractImage;
    PathBuffer: array [0..MAX_PATH-1] of WideChar;
    Priority: DWORD;
    Flags: DWORD;
    ColorDepth: DWORD;
    Size: TSize;
   Res: HRESULT;
begin
    Result:=0;

    FilePath:=ExcludeTrailingPathDelimiter(ExtractFilePath(DisplayName));
    FileName:=ExtractFileName(DisplayName);

    if   FilePath[Length(FilePath)]=':'
    then FilePath:=IncludeTrailingPathDelimiter(FilePath);

    SHGetDesktopFolder(DesktopFolder);

    DesktopFolder.ParseDisplayName( 0, nil, StringToOleStr(FilePath), Eaten, DirectoryItemIDList, Attributes );

    DesktopFolder.BindToObject(DirectoryItemIDList, nil, IShellFolder, ShellFolder);

    CoTaskMemFree(DirectoryItemIDList);

    ShellFolder.ParseDisplayName(0, nil, StringToOleStr(ExtractFileName(FileName)), Eaten, DirectoryItemIDList, Attributes);

    ShellFolder.GetUIObjectOf(0, 1, DirectoryItemIDList, IExtractImage, nil, ExtractImage);

    CoTaskMemFree(DirectoryItemIDList);

    if Assigned(ExtractImage) then
    begin

        Priority:=0;
        Size.cx:=Width;
        Size.cy:=Height;
        Flags:=IEIFLAG_SCREEN or IEIFLAG_OFFLINE or IEIFLAG_QUALITY;
        ColorDepth:=32;

        Res:=ExtractImage.GetLocation(@PathBuffer[0], Length(PathBuffer), Priority, Size, ColorDepth, Flags);

        if   (Res=NOERROR) or (Res=E_PENDING)
        then if   not Succeeded(ExtractImage.Extract(Result))
             then Result:=0;

    end;

end;

end.
