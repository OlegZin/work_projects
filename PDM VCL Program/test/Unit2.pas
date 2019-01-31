unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ksTLB, ActiveX, ComObj;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ReadKompassFile( filename: string );
    procedure Start_Kompas;
  public
    { Public declarations }
    Kompas :KompasObject;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
    if OpenDialog1.Execute then ReadKompassFile( OpenDialog1.FileName );
end;

procedure TForm2.ReadKompassFile(filename: string);
{ открываем файл компаса ком0объектом и пытаемся получить список путей
  всех вложенных файлов }
begin
    Start_Kompas;
end;

procedure TForm2.Start_Kompas;
var
  Result:     HRESULT;
  Unknown:    IInterface;
begin
  //---Проверка, загружен ли КОМПАС---
  Result := GetActiveObject(ProgIDToClassID('Kompas.Application.5'),nil,Unknown);
  if (Result = MK_E_UNAVAILABLE) then//если не доступен
  begin
    //---Загрузить Компас---
    Kompas := KompasObject( CreateOleObject('Kompas.Application.5') );
    if Kompas <> nil then
    Kompas.Visible := true;
  end
  else begin
    //---Соединиться с уже запущенной копией сервера---
    Kompas := KompasObject(GetActiveOleObject('Kompas.Application.5'));
  end;

end;


end.
