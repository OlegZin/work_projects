unit uAddProject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DB,
  Vcl.ComCtrls;

type

  TCallback = function (name, mark: string; objectId, workgroupId: integer; comment, parent_prod_kod, prod_kod: string) : boolean of object;

  TData = class
      name: string;
      id: integer;
  end;

  TfAddProject = class(TForm)
    Label1: TLabel;
    eName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    bClose: TButton;
    bCreate: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mComment: TMemo;
    cbMark: TComboBox;
    cbGroup: TComboBox;
    pgMode: TPageControl;
    tabSpec: TTabSheet;
    tabObject: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    eObjectMark: TEdit;
    Label9: TLabel;
    eObjectName: TEdit;
    Label10: TLabel;
    bObjectMark: TImage;
    bObjectName: TImage;
    Label11: TLabel;
    cbLvl0: TComboBox;
    cbLvl1: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    cbLvl2: TComboBox;
    lFullProd: TLabel;
    procedure bCloseClick(Sender: TObject);
    procedure bCreateClick(Sender: TObject);
    procedure cbMarkDropDown(Sender: TObject);
    procedure cbGroupDropDown(Sender: TObject);
    procedure cbGroupChange(Sender: TObject);
    procedure cbMarkChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbMarkKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bObjectMarkClick(Sender: TObject);
    procedure bObjectNameClick(Sender: TObject);
    procedure cbLvl0DropDown(Sender: TObject);
    procedure cbLvl1DropDown(Sender: TObject);
    procedure cbLvl0Change(Sender: TObject);
    procedure cbLvl1Change(Sender: TObject);
    procedure cbLvl2DropDown(Sender: TObject);
    procedure cbLvl2Change(Sender: TObject);
  private
    { Private declarations }
    procedure GetMarkList;
    procedure GetWorkgroupList;
    procedure SetUpName;
  public

    { Public declarations }
    ObjectId             // id разрабатываемой в проекте спецификации, если будем работать с существующей
   ,WorkgroupId          // id рабочей группы с заранее настроенными участиниками и ролями
   ,CustomObjectId       // id произвольно выбранного для работы объекта
            : integer;

    callback: TCallback;

    procedure Reset;
  end;

var
  fAddProject: TfAddProject;

implementation

{$R *.dfm}

uses
    uDataManager, uConstants, uPhenixCORE, uMain;

procedure TfAddProject.bCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfAddProject.bCreateClick(Sender: TObject);
var
    error: string;
begin
    error := '';

    if WorkgroupId = 0 then error := 'Рабочая группа не выбрана.';
    if cbLvl1.Text = '' then error := 'Не выбрана группа продукции';
    if cbLvl2.Text = '' then error := 'Не выбран тип продукции';

    if error <> '' then
    begin
        ShowMessage(error);
        Exit;
    end;

    if pgMode.ActivePage = tabSpec
    then callback( eName.Text, cbMark.Text, ObjectId, WorkgroupId, mComment.Text, cbLvl1.Text, cbLvl2.Text )
    else callback( eObjectName.Text, eObjectName.Text, CustomObjectId, WorkgroupId, mComment.Text, cbLvl1.Text, cbLvl2.Text );

    close;
end;

procedure TfAddProject.bObjectMarkClick(Sender: TObject);
begin
    Core.LSearch.Init( eObjectMark, 'SELECT DISTINCT(full_mark), child FROM '+VIEW_OBJECT+' WHERE isnull(full_mark,'''') <> '''' ' );
    if Core.LSearch.Execute then
    begin
       eObjectMark.Text := Core.LSearch.SelText;
       CustomObjectId := Core.LSearch.SelData;

       eObjectName.Text := mngData.GetObjectAttr(CustomObjectId, 'full_name');
    end;
end;

procedure TfAddProject.bObjectNameClick(Sender: TObject);
begin
    Core.LSearch.Init( eObjectName, 'SELECT DISTINCT(full_name), child FROM '+VIEW_OBJECT + ' WHERE isnull(full_name,'''') <> '''' ');
    if Core.LSearch.Execute then
    begin
       eObjectName.Text := Core.LSearch.SelText;
       CustomObjectId := Core.LSearch.SelData;

       eObjectMark.Text := mngData.GetObjectAttr(CustomObjectId, 'full_mark');
    end;
end;

procedure TfAddProject.cbGroupChange(Sender: TObject);
begin
    WorkgroupId := Integer(cbGroup.Items.Objects[cbGroup.ItemIndex]);
end;

procedure TfAddProject.cbGroupDropDown(Sender: TObject);
begin
    GetWorkgroupList;
end;

procedure TfAddProject.cbLvl0Change(Sender: TObject);
begin
    cbLvl1.Items.Clear;
    cbLvl2.Items.Clear;
    lFullProd.Caption := '';
end;

procedure TfAddProject.cbLvl0DropDown(Sender: TObject);
var
    ds: TDataset;
begin
    if cbLvl0.Items.Count <> 0 then exit;

    ds := mngData.GetTypeProdLevel(0);
    if not assigned(ds) or (ds.RecordCount = 0) then exit;

    while not ds.eof do
    begin
        cbLvl0.Items.AddObject( ds.FieldByName('kod').AsString, TObject(ds.FieldByName('id').AsInteger) );
        ds.Next;
    end;
end;

procedure TfAddProject.cbLvl1Change(Sender: TObject);
begin
    cbLvl2.Items.Clear;
    lFullProd.Caption := '';
end;

procedure TfAddProject.cbLvl1DropDown(Sender: TObject);
var
    ds: TDataset;
begin

    if cbLvl0.ItemIndex <> -1
    then ds := mngData.GetTypeProdLevel( Integer(cbLvl0.Items.Objects[cbLvl0.ItemIndex]) )
    else ds := mngData.GetTypeProdLevel(-1);

    if not assigned(ds) or (ds.RecordCount = 0) then exit;

    cbLvl1.Items.Clear;
    while not ds.eof do
    begin
        cbLvl1.Items.AddObject( ds.FieldByName('kod').AsString, TObject(ds.FieldByName('id').AsInteger) );
        ds.Next;
    end;
end;

procedure TfAddProject.cbLvl2Change(Sender: TObject);
begin
    lFullProd.Caption := cbLvl2.Text;
end;

procedure TfAddProject.cbLvl2DropDown(Sender: TObject);
var
    ds: TDataset;
begin

    if cbLvl1.ItemIndex <> -1
    then ds := mngData.GetTypeProdLevel( Integer(cbLvl1.Items.Objects[cbLvl1.ItemIndex]) )
    else ds := mngData.GetTypeProdLevel(-2);

    if not assigned(ds) or (ds.RecordCount = 0) then exit;

    cbLvl2.Items.Clear;
    while not ds.eof do
    begin
        /// игнорируем повторы
        if   cbLvl2.Items.IndexOf( ds.FieldByName('name').AsString ) = -1
        then cbLvl2.Items.Add( ds.FieldByName('name').AsString );
        ds.Next;
    end;
end;

procedure TfAddProject.GetWorkgroupList;
var
    ds : TDataset;
    data: TData;
begin
    ds := mngData.GetWorkgroupsList(nil, 'project');
    if not Assigned(ds) then exit;

    cbGroup.Items.Clear;

    while not ds.eof do
    begin
        cbGroup.Items.AddObject( ds.FieldByName('name').AsString, TObject(ds.FieldByName('id').AsInteger) );
        ds.Next;
    end;
end;

procedure TfAddProject.cbMarkChange(Sender: TObject);
begin
    if cbMark.ItemIndex > -1 then SetUpName;
end;

procedure TfAddProject.cbMarkDropDown(Sender: TObject);
begin
    GetMarkList;
end;

procedure TfAddProject.cbMarkKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if cbMark.Items.IndexOf( cbMark.Text ) > -1
    then SetUpName
    else ObjectId := 0;
end;

procedure TfAddProject.SetUpName;
/// метод заполняет id выбранной спецификации
/// и подставляет в поле имени ее имя
var
    data : TData;
begin
    data := TData(cbMark.Items.Objects[cbMark.ItemIndex]);
    ObjectId := data.id;
    eName.Text := data.name;
end;

procedure TfAddProject.FormShow(Sender: TObject);
begin
    GetMarkList;
    GetWorkgroupList;
end;

procedure TfAddProject.GetMarkList;
/// получаем список существующих спецификаций, не находящихся в работе
var
    ds: TDataset;
    data : TData;
begin
    ds := mngData.GetSpecifList;
    if not Assigned(ds) then exit;

    cbMark.Items.Clear;
    while not ds.eof do
    begin
        data := TData.create;
        data.id := ds.FieldByName('child').AsInteger;
        data.name := ds.FieldByName('full_name').AsString;

        cbMark.Items.AddObject( ds.FieldByName('full_mark').AsString, TObject( data ));
        ds.Next;
    end;
end;


procedure TfAddProject.Reset;
begin
    cbMark.ItemIndex := -1;
    cbMark.Text := '';
    cbGroup.ItemIndex := -1;
    ObjectId := 0;

    eObjectMark.Text := '';
    eObjectName.Text := '';
    CustomObjectId := 0;

    WorkgroupId := 0;
    bCreate.Caption := 'Создать';
    eName.Text := '';
end;

end.
