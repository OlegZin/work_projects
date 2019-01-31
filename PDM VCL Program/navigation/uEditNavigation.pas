unit uEditNavigation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Math;

type
  TfEditNavigation = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    bSave: TButton;
    bClose: TButton;
    Label4: TLabel;
    bSelObject: TImage;
    bSelKind: TImage;
    lKind: TLabel;
    pMain: TPanel;
    pKindObject: TPanel;
    lObject: TLabel;
    pKindSection: TPanel;
    Label5: TLabel;
    eSection: TEdit;
    lParent: TLabel;
    bSelParent: TImage;
    pUnderline: TPanel;
    Label3: TLabel;
    lObjectContent: TLabel;
    Image1: TImage;
    pKinds: TPanel;
    pButtons: TPanel;
    procedure bCloseClick(Sender: TObject);
    procedure bSelObjectClick(Sender: TObject);
    procedure bSelKindClick(Sender: TObject);
    procedure bSelParentClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure eSectionKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ObjectId: integer;        // id ���������� � ���� eObject �������
    ObjectName: string;       // ��� ������� ��� �������

    procedure PanelsVisible;
  public
    ParentId               // id ��������-�������� � ������ ��� �������� ����������������
   ,CurrentId              // id �������� �������� (���� ���������� - ����� ��������������, ����� - ����� ����������)
   ,CurrentContentID

   ,NewCurrentKind         // kind ���������� ��������
   ,NewParentId            // id ��������-�������� � ������ ��� �������� ����������������
   ,NewCurrentId           // id �������� �������� (���� ���������� - ����� ��������������, ����� - ����� ����������)
   ,NewCurrentContentID
            : integer;

    CurrentName            // �������� ��� ������
   ,NewCurrentName         // ����� ��� ���������� ��� ������
            : string;
    { Public declarations }
  end;

var
  fEditNavigation: TfEditNavigation;

implementation

{$R *.dfm}

uses
    uPhenixCORE, uConstants;

const
    NO_VALUE = '...';

procedure TfEditNavigation.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     ParentId := 0;
     CurrentId := 0;
end;

procedure TfEditNavigation.FormShow(Sender: TObject);
begin

    pKinds.Height := Max(pKindObject.Height, pKindSection.Height);

    // ������ ������ � �������� ������
    NewCurrentKind := 0;
    ObjectId := 0;
    lParent.Caption := NO_VALUE;
    lKind.Caption := NO_VALUE;
    lObject.Caption := NO_VALUE;
    eSection.Text := NO_VALUE;
    pKindObject.Visible := false;
    pKindSection.Visible := false;
    bSave.Caption := '�������';
    bSelKind.Visible := true;

    // �������� ������ ��������, ���� ������
    // � ������ ������ ������� ����� �������� �������� ������
    if ParentID <> 0  then
    begin
       lParent.Caption := dmSQ('SELECT name FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ParentId) );

       NewParentID := ParentID;

       CurrentId := 0;
       NewCurrentId := 0;
    end;

    // �������� ������ �������� ��������, ���� ������
    // � ������ ������ ������� ����� �������������� �������� �������� ������
    if CurrentId <> 0 then
    begin
        // �������� ������ �������� ���� � ��������� ����

        ObjectId := CurrentId;
        NewCurrentId := CurrentId;

        NewCurrentKind := dmSQ('SELECT kind FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ObjectId));
        lKind.Caption := dmSQ('SELECT name FROM object_classificator WHERE kind = ' + IntToStr(NewCurrentKind) );
    //    bSelKind.Visible := false;
        ObjectName := dmSQ('SELECT name FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ObjectId));


        ParentID := dmSQ('SELECT parent FROM '+VIEW_GROUP+' WHERE child = ' + IntToStr(ObjectId));
        if ParentID <> 0
        then
            lParent.Caption := dmSQ('SELECT name FROM '+TBL_OBJECT+' WHERE id = ' + IntToStr(ParentId))
        else
            lParent.Caption := NO_VALUE;

        lObject.Caption := ObjectName;
        eSection.Text := ObjectName;
        CurrentName := ObjectName;


        bSave.Caption := '���������';
    end;

    PanelsVisible;
end;

procedure TfEditNavigation.Image1Click(Sender: TObject);
begin

    Core.LSearch.Init( lObjectContent, 'SELECT name, id FROM object_classificstor WHERE kind = ' + IntToStr(NewCurrentKind) );
    if Core.LSearch.Execute then
    begin
       lObjectContent.Caption := Core.LSearch.SelText;
       NewCurrentContentID := Core.LSearch.SelData;
    end;

end;

procedure TfEditNavigation.PanelsVisible;
begin

   if NewCurrentKind > 0 then
   begin
       pKindObject.Visible := not ( NewCurrentKind in [1,2] );
       pKindSection.Visible := NewCurrentKind in [1,2];
   end;

   pKinds.Height :=
       pKindObject.Height  * Integer(pKindObject.Visible) +
       pKindSection.Height * Integer(pKindSection.Visible);

   fEditNavigation.ClientHeight := pMain.Height + pKinds.Height + pButtons.Height;
end;

procedure TfEditNavigation.bSelParentClick(Sender: TObject);
{ �������� ������� � ������, ������� ����� ��������� ��� ������������.
  ��� ������ "���" - ������� ��������� � �������� ��������� (�������� ������)
}
begin

    Core.LSearch.InitEx( lParent, 'SELECT DISTINCT(name), id FROM '+TBL_OBJECT, '���', 0 );
    if Core.LSearch.Execute then
    begin
       lParent.Caption := Core.LSearch.SelText;
       NewParentID := Core.LSearch.SelData;
    end;

end;

procedure TfEditNavigation.eSectionKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    NewCurrentName := eSection.Text;
end;

procedure TfEditNavigation.bSelKindClick(Sender: TObject);
{ �������� ��� ������ ��������, ������������ � ������
}
var
    oldKind: integer;
begin

    oldKind := NewCurrentKind;

    Core.LSearch.Init( lKind, 'SELECT name, kind FROM object_classificator' );
    if Core.LSearch.Execute then
    begin
       lKind.Caption := Core.LSearch.SelText;
       NewCurrentKind := Core.LSearch.SelData;

       if NewCurrentKind <> oldKind then
       begin
           NewCurrentId := 0;
           NewCurrentContentID := 0;
           lObject.Caption := NO_VALUE;
           lObjectContent.Caption := NO_VALUE;
           eSection.Text := NO_VALUE;
       end;

       PanelsVisible;
    end;

end;

procedure TfEditNavigation.bSelObjectClick(Sender: TObject);
{ ���� ��� ������������ ������� - ������� ������ ������,
  �������� ���������� ��� �������
}
begin

    Core.LSearch.Init( lObject, 'SELECT name, id FROM '+TBL_OBJECT+' WHERE kind = ' + IntToStr(NewCurrentKind) );
    if Core.LSearch.Execute then
    begin
       lObject.Caption := Core.LSearch.SelText;
       NewCurrentId := Core.LSearch.SelData;
    end;

end;


procedure TfEditNavigation.bSaveClick(Sender: TObject);
var
    error: string;
begin
    error := '';
    if lParent.Caption = NO_VALUE then error := '�� ������ ��������';
    if lKind.Caption = NO_VALUE then error := '�� ������ ��� ��������';
    if pKindSection.Visible and (( eSection.Text = NO_VALUE ) or (Trim(eSection.Text) = '' )) then error := '�� ������� ��� �������';
    if pKindObject.Visible and ( lObject.Caption = NO_VALUE ) then error := '�� ������ ������';

    if error <> '' then
    begin
        ShowMessage(Error);
        exit;
    end;

    ModalResult := mrOk;
end;


procedure TfEditNavigation.bCloseClick(Sender: TObject);
begin
   ModalResult := mrClose;
end;

end.
