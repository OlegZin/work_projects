unit uSpecTreeFree;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Vcl.ExtCtrls;

type
  TfSpecTreeFree = class(TForm)
    grdSpecific: TDBGridEh;
    Panel1: TPanel;
    bRefresh: TImage;
    procedure grdSpecificMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdSpecificDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    constructor Create(owner: TComponent; tablename: string); overload;
    procedure FormShow(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    RootID: integer;
    tablename: string;
  public
    function SetRootId( root_id: integer ): TfSpecTreeFree;
    procedure Refresh;
    { Public declarations }
  end;

var
  fSpecTreeFree: TfSpecTreeFree;

implementation

{$R *.dfm}

uses
    uSpecifTreeManager, uConstants, uMain, uObjectCatalog;

var
    mngTree : TTreeManager;

procedure TfSpecTreeFree.bRefreshClick(Sender: TObject);
begin
    mngTree.Refresh( [RootID] );
end;

constructor TfSpecTreeFree.Create(owner: TComponent; tablename: string);
begin
  inherited Create(owner);
  self.tablename := tablename;
  RootID := 0;
end;

procedure TfSpecTreeFree.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (owner is TfObjectCatalog) then (owner as TfObjectCatalog).ClearStructLink;
end;

procedure TfSpecTreeFree.FormShow(Sender: TObject);
begin
    // формируем дерево спецификаций
    mngTree := TTreeManager.Create;
    mngTree.init(grdSpecific, tablename);
    mngTree.Refresh( [RootID] );
    mngTree.FullExpand;
//    mngTree.GetTreeLevel(0,0);
end;

procedure TfSpecTreeFree.grdSpecificDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfSpecTreeFree.grdSpecificMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     (Sender as TDBGridEh).BeginDrag(true);
end;

procedure TfSpecTreeFree.Refresh;
begin
    mngTree.Refresh( [RootID] );
end;

function TfSpecTreeFree.SetRootId(root_id: integer): TfSpecTreeFree;
begin
    result := self;
    RootID := root_id;
end;

end.
