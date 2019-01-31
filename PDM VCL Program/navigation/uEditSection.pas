unit uEditSection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfEditSection = class(TForm)
    Label1: TLabel;
    lParent: TLabel;
    bSelParent: TImage;
    Label5: TLabel;
    eSection: TEdit;
    Label3: TLabel;
    lKind: TLabel;
    bSelKind: TImage;
    pUnderline: TPanel;
    bClose: TButton;
    bSave: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    lbAllowUsers: TListBox;
    Panel3: TPanel;
    Image2: TImage;
    Image3: TImage;
    procedure FormShow(Sender: TObject);
    procedure bSelParentClick(Sender: TObject);
    procedure bSelKindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function ExecSearch( lab: TLabel; SQL: string ): integer;
  public
    { Public declarations }
    ParentId                   // �������� �������� � ������. � ������ �������������
                               // ����� ��������, ��� ������ �������������� � ������
   ,NewParentID                // ����� ��������, ���� ���������

   ,ItemsKind                  // �������� ������������� ������� (������ ���� �������� ����������)
                               // ���� �� ������ - ��� �������� (������ ����������)
   ,NewItemsKind               // ����������� ������������� ��� �������� �����

   ,Mode                       // 0 - �������� �������, 1 - ��������������
                : Integer;

    SectionName                // �������� ��� �������. ���� ������ � ������ ��������������
                               // ������������� ��� ������� ��� (���������������) � ��
                               // ������������ ����������� ������ ���������, ���� ��
                               // �������� � ������������ ���������.
                               // ���� �� ������, ������� ������� (��� ��������������)
   ,NewSectionName             // ����������� ��� ������� ��� �������� �����
                : string;

//    procedure Clear;           // ����� ������� �������� ���� ���������� � ���������� ����������� �����
  end;

var
  fEditSection: TfEditSection;

implementation

{$R *.dfm}

uses
    uPhenixCORE, uConstants;

procedure TfEditSection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    NewSectionName := eSection.Text;
end;

procedure TfEditSection.FormShow(Sender: TObject);
begin

    // ���������� ��� ��������, ���� ����
    if   ParentId <> 0
    then lParent.Caption := dmSQ('SELECT name FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ParentId) )
    else lParent.Caption := '';

    // ���������� ��� �������
    eSection.Text := SectionName;

    // ���������� ��� ���� ������������ ��������, ���� ����
    if   ItemsKind <> 0
    then lKind.Caption := dmSQ('SELECT name FROM object_classifi�ator WHERE kind = ' + IntToStr(ItemsKind))
    else lKind.Caption := '';

    // ������ �������������, ������� ������ ������ � ����� �������� ������
    // ������������ �� ������������ ���������������� ����� ����� �������������.
    // ��������� ������� (� ������� �������������) ������������ ��������
    lbAllowUsers.Items.Clear;
    //

    NewParentID := ParentId;
    NewItemsKind := ItemsKind;
    NewSectionName := SectionName;

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

procedure TfEditSection.bSelKindClick(Sender: TObject);
begin
    NewItemsKind := ExecSearch( lKind, 'SELECT name, id FROM Object_classificator' );
end;

procedure TfEditSection.bSelParentClick(Sender: TObject);
begin
    NewParentID := ExecSearch( lParent, 'SELECT DISTINCT(name), id FROM '+TBL_OBJECT );
end;

function TfEditSection.ExecSearch(lab: TLabel; SQL: string): integer;
begin

    Core.LSearch.Init( lab, SQL );
    if Core.LSearch.Execute then
    begin
       lab.Caption := Core.LSearch.SelText;
       result := Core.LSearch.SelData;
    end;

end;


end.
