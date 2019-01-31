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
{ ��������� ���� ������� ���0�������� � �������� �������� ������ �����
  ���� ��������� ������ }
begin
    Start_Kompas;
end;

procedure TForm2.Start_Kompas;
var
  Result:     HRESULT;
  Unknown:    IInterface;
begin
  //---��������, �������� �� ������---
  Result := GetActiveObject(ProgIDToClassID('Kompas.Application.5'),nil,Unknown);
  if (Result = MK_E_UNAVAILABLE) then//���� �� ��������
  begin
    //---��������� ������---
    Kompas := KompasObject( CreateOleObject('Kompas.Application.5') );
    if Kompas <> nil then
    Kompas.Visible := true;
  end
  else begin
    //---����������� � ��� ���������� ������ �������---
    Kompas := KompasObject(GetActiveOleObject('Kompas.Application.5'));
  end;

end;


end.
