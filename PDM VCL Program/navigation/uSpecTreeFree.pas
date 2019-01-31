unit uSpecTreeFree;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TfSpecTreeFree = class(TForm)
    grdSpecific: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure grdSpecificMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdSpecificDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    constructor Create(owner: TComponent; tablename: string); overload;
  private
    { Private declarations }
  public
    tablename: string;
    { Public declarations }
  end;

var
  fSpecTreeFree: TfSpecTreeFree;

implementation

{$R *.dfm}

uses
    uSpecifTreeManager, uConstants, uMain;

var
    mngTree : TTreeManager;

constructor TfSpecTreeFree.Create(owner: TComponent; tablename: string);
begin
  inherited Create(owner);
  self.tablename := tablename;
end;

procedure TfSpecTreeFree.FormCreate(Sender: TObject);
begin
    // формируем дерево спецификаций
    mngTree := TTreeManager.Create;
    mngTree.init(grdSpecific, tablename);
    mngTree.GetTreeLevel(0,0);
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

end.
