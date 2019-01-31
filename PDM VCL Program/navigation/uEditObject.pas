unit uEditObject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfEditObject = class(TForm)
    Label1: TLabel;
    lParent: TLabel;
    bSelParent: TImage;
    Label3: TLabel;
    lObject: TLabel;
    bSelObject: TImage;
    bClose: TButton;
    bSave: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormShow(Sender: TObject);
    procedure bSelParentClick(Sender: TObject);
    procedure bSelObjectClick(Sender: TObject);
  private
    { Private declarations }
    function ExecSearch( lab: TLabel; SQL: string ): integer;
  public
    { Public declarations }
    ParentId                   // �������� �������� � ������. � ������ �������������
                               // ����� ��������, ��� ������ �������������� � ������
   ,NewParentID                // ����� ��������, ���� ���������

   ,ObjectID                   // �������� ������������� ������� (������ ���� �������� ����������)
                               // ���� �� ������ - ��� �������� (������ ����������)
   ,NewObjectID                // ����������� ������������� ��� �������� �����

   ,Mode                       // 0 - �������� �������, 1 - ��������������
                : Integer;
  end;

var
  fEditObject: TfEditObject;

implementation

{$R *.dfm}

uses
    uPhenixCORE, uConstants;

procedure TfEditObject.FormShow(Sender: TObject);
begin

    // ���������� ��� ��������, ���� ����
    if   ParentId <> 0
    then lParent.Caption := dmSQ('SELECT name FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ParentId) )
    else lParent.Caption := '';

    // ���������� ��� ���� ������������ ��������, ���� ����
    if   ObjectId <> 0
    then lObject.Caption := dmSQ('SELECT name FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ObjectId))
    else lObject.Caption := '';

    NewParentID := ParentId;
    NewObjectID := ObjectId;

    case Mode of
        0:
        begin
            Caption := '�������� �������';
            bSave.Caption := '�������';
        end;

        1:
        begin
            Caption := '�������������� �������';
            bSave.Caption := '���������';
        end;
    end;
end;

procedure TfEditObject.bSelObjectClick(Sender: TObject);
begin
    NewObjectId := ExecSearch( lObject, 'SELECT DISTINCT(name), id FROM '+TBL_OBJECT );
end;

procedure TfEditObject.bSelParentClick(Sender: TObject);
begin
    NewParentID := ExecSearch( lParent, 'SELECT DISTINCT(name), id FROM '+TBL_OBJECT );
end;

function TfEditObject.ExecSearch(lab: TLabel; SQL: string): integer;
begin

    Core.LSearch.Init( lab, SQL );
    if Core.LSearch.Execute then
    begin
       lab.Caption := Core.LSearch.SelText;
       result := Core.LSearch.SelData;
    end;

end;


end.
