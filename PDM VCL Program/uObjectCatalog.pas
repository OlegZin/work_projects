unit uObjectCatalog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.Buttons, Vcl.StdCtrls, EhLibVCL, GridsEh,
  DBAxisGridsEh, DBGridEh, Vcl.ExtCtrls, uMain, Data.DB, StrUtils;

type
  TfObjectCatalog = class(TForm)
    Panel1: TPanel;
    grdObjects: TDBGridEh;
    Panel2: TPanel;
    sbKindDocument: TSpeedButton;
    sbKindMaterial: TSpeedButton;
    sbKindDetail: TSpeedButton;
    sbKindStandart: TSpeedButton;
    sbKindOther: TSpeedButton;
    sbKindAssembly: TSpeedButton;
    sbKindKomplect: TSpeedButton;
    sbKindKomplex: TSpeedButton;
    sbKindSection: TSpeedButton;
    sbKindSpecification: TSpeedButton;
    sbKindExecution: TSpeedButton;
    sbAddObject: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdObjectsApplyFilter(Sender: TObject);
    procedure grdObjectsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdObjectsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbAddObjectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fObjectCatalog: TfObjectCatalog;

implementation

{$R *.dfm}

uses
    uPhenixCore, uConstants, uDatatableManager, uObjectCard;

procedure TfObjectCatalog.FormCreate(Sender: TObject);
var
    i : integer;
begin
    grdObjects.DataSource := TDataSource.Create(self);
    mngDatatable.ConfigureForFilter( grdObjects, [0] );
    mngDatatable.ConfigureForSorting( grdObjects, [] );
end;

procedure TfObjectCatalog.FormShow(Sender: TObject);
begin
    grdObjects.DataSource.DataSet := Core.DM.OpenQueryEx( 'SELECT * FROM '+ TBL_OBJECT );
    grdObjects.DataSource.DataSet.Filtered := true;
end;

procedure TfObjectCatalog.grdObjectsApplyFilter(Sender: TObject);
begin
    (Sender as TDBGridEh).DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( Sender as TDBGridEh );
end;

procedure TfObjectCatalog.grdObjectsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfObjectCatalog.grdObjectsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     grdObjects.BeginDrag(true);
end;

procedure TfObjectCatalog.sbAddObjectClick(Sender: TObject);
begin
    if   not Assigned( fObjectCard )
    then fObjectCard := TfObjectCard.Create(self);
    fObjectCard.Show;
end;

end.
