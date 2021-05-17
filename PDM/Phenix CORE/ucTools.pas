unit ucTools;

interface

function GetFileVersion:string;  // получает версию программы
function GetWinLogin: string;    // получаем логин пользователя
function GetComputerNetName: string; // получаем имя компьютера

implementation

uses Windows, SysUtils, ComObj;

function GetFileVersion:string;
{ получает версию программы }
var InfoSize, puLen: DWORD;
    Pt, InfoPtr: Pointer;
    VerInfo : TVSFixedFileInfo;
begin
  result:='';

  InfoSize := GetFileVersionInfoSize( PChar(ParamStr(0)), puLen );
  FillChar(VerInfo, SizeOf(TVSFixedFileInfo), 0);
  if InfoSize > 0 then
  begin
    GetMem(Pt,InfoSize);
    GetFileVersionInfo(PChar(ParamStr(0)), 0, InfoSize, Pt);
    VerQueryValue(Pt,'\',InfoPtr,puLen);
    Move(InfoPtr^, VerInfo, sizeof(TVSFixedFileInfo));
    Result:=Format('%u.%u.%u.%u',[HiWord(VerInfo.dwFileVersionMS), LoWord(VerInfo.dwFileVersionMS),
      HiWord(VerInfo.dwFileVersionLS), LoWord(VerInfo.dwFileVersionLS)]);
    FreeMem(Pt);
  end;
end;

function GetWinLogin: string;
var
    WshNet:variant;
begin

    WshNet:=CreateOleObject('WScript.Network');

    if (WshNet.UserDomain='NM') or (WshNet.UserDomain='NTM')
    then
        result := WshNet.UserName
    else
        result := WshNet.UserDomain+'\'+WshNet.UserName;

end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

end.
