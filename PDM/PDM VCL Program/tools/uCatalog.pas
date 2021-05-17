unit uCatalog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.StdCtrls, Vcl.ExtCtrls, EhLibVCL, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, ADODB;

type
  TfCatalog = class(TForm)
    grdCatalog: TDBGridEh;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdCatalogApplyFilter(Sender: TObject);
  private
    { Private declarations }
    fSQL : string;
  public
    { Public declarations }
    function SetSQL( sql: string ): TfCatalog;
    function SetFields( fields: array of string ): TfCatalog;
    function SetFilter( pass: array of integer ): TfCatalog;
    function SetSorting( pass: array of integer ): TfCatalog;
    function GetDataset: TADOQuery;
  end;

var
  fCatalog: TfCatalog;

implementation

{$R *.dfm}

uses
    uPhenixCORE
   ,uDatatableManager;

var
    mngDatatable : TDatatableManager;

procedure TfCatalog.FormCreate(Sender: TObject);
begin
    if not Assigned( mngDatatable ) then
    mngDatatable := TDatatableManager.Create;

    // инициализация списка рабочих групп
    grdCatalog.DataSource := TDataSource.Create(self);
    grdCatalog.DataSource.DataSet := Core.DM.GetDataset;

end;

procedure TfCatalog.FormShow(Sender: TObject);
begin
    if not Assigned( grdCatalog.DataSource.DataSet ) or ( fSQL = '' )
    then exit;

    grdCatalog.DataSource.DataSet.Filter := '';

    grdCatalog.DataSource.DataSet := Core.DM.OpenQueryEx( fSQL, grdCatalog.DataSource.DataSet );
end;

function TfCatalog.GetDataset: TADOQuery;
begin
    result := TADOQuery(grdCatalog.DataSource.DataSet);
end;

procedure TfCatalog.grdCatalogApplyFilter(Sender: TObject);
begin
    grdCatalog.DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( grdCatalog );
end;

function TfCatalog.SetFields(fields: array of string): TfCatalog;
var
    i: integer;
    column : TColumnEh;
begin
    result := self;

    if not Assigned(grdCatalog.DataSource.DataSet) then exit;
    grdCatalog.DataSource.DataSet.Close;

    grdCatalog.Columns.Clear;

    for I := Low(fields) to High(fields) do
    begin
        column := grdCatalog.Columns.Add;
        column.FieldName := fields[i];
    end;
end;

function TfCatalog.SetFilter(pass: array of integer): TfCatalog;
begin
    result := self;
    mngDatatable.ConfigureForFilter( grdCatalog, pass );
end;

function TfCatalog.SetSorting(pass: array of integer): TfCatalog;
begin
    result := self;
    mngDatatable.ConfigureForSorting( grdCatalog, pass );
end;

function TfCatalog.SetSQL(sql: string): TfCatalog;
begin
    result := self;
    fSQL := sql;
end;

end.


