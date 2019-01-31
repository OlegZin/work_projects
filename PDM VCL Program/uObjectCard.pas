unit uObjectCard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Buttons;

type
  TfObjectCard = class(TForm)
    Label1: TLabel;
    eKind: TEdit;
    bSelParent: TImage;
    Label2: TLabel;
    eMark: TEdit;
    Label3: TLabel;
    eName: TEdit;
    Label4: TLabel;
    mComment: TMemo;
    bOk: TButton;
    bClose: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure bSelParentClick(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure bCloseClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure eKindDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure eKindDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure eMarkDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure eNameDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure mCommentDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    kind: integer;
    dataset: TDataset;
  public
    { Public declarations }
  end;

var
  fObjectCard: TfObjectCard;

implementation

{$R *.dfm}

uses
    uPhenixCORE, uConstants, uMain, uObjectCatalog, DBGridEh, GridsEh;

procedure TfObjectCard.bSelParentClick(Sender: TObject);
begin

    Core.LSearch.Init( eKind, 'SELECT DISTINCT(name), kind FROM '+TBL_OBJECT_CLASSIFICATOR );
    if Core.LSearch.Execute then
    begin
       eKind.Text := Core.LSearch.SelText;
       kind := Core.LSearch.SelData;
    end;

end;

procedure TfObjectCard.eKindDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    dataset := (Source as TDBGridEh).DataSource.DataSet;

    if   Assigned( dataset.fields.FindField('kind') )
    then
    begin
        kind := dataset.FieldByName('kind').AsInteger;
        eKind.Text := dmSDQ( 'SELECT name FROM '+TBL_OBJECT_CLASSIFICATOR +' WHERE kind = '+IntToStr(kind), '' );
    end;
end;

procedure TfObjectCard.eKindDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfObjectCard.eMarkDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    dataset := (Source as TDBGridEh).DataSource.DataSet;

    if   Assigned( dataset.fields.FindField('mark') )
    then eMark.Text := dataset.FieldByName('mark').AsString;
end;

procedure TfObjectCard.eNameDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    dataset := (Source as TDBGridEh).DataSource.DataSet;

    if   Assigned( dataset.fields.FindField('name') )
    then eName.Text := dataset.FieldByName('name').AsString;
end;

procedure TfObjectCard.bOkClick(Sender: TObject);
begin
    mngData.AddObject('kind, mark, name, comment, mass', [kind, eMark.Text, eName.Text, mComment.Lines.Text, 0]);
    (self.Owner as TfObjectCatalog).grdObjects.DataSource.DataSet.Close;
    (self.Owner as TfObjectCatalog).grdObjects.DataSource.DataSet.Open;
    Close;
end;

procedure TfObjectCard.bCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfObjectCard.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin

    dataset := (Source as TDBGridEh).DataSource.DataSet;

    if   Assigned( dataset.fields.FindField('kind') )
    then
    begin
        kind := dataset.FieldByName('kind').AsInteger;
        eKind.Text := dmSDQ( 'SELECT name FROM '+TBL_OBJECT_CLASSIFICATOR +' WHERE kind = '+IntToStr(kind), '' );
    end;

    if   Assigned( dataset.fields.FindField('mark') )
    then eMark.Text := dataset.FieldByName('mark').AsString;

    if   Assigned( dataset.fields.FindField('name') )
    then eName.Text := dataset.FieldByName('name').AsString;

    if   Assigned( dataset.fields.FindField('comment') )
    then mComment.Text := dataset.FieldByName('comment').AsString;

end;

procedure TfObjectCard.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfObjectCard.mCommentDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    dataset := (Source as TDBGridEh).DataSource.DataSet;

    if   Assigned( dataset.fields.FindField('comment') )
    then mComment.Text := dataset.FieldByName('comment').AsString;
end;

procedure TfObjectCard.SpeedButton1Click(Sender: TObject);
begin
    eMark.Text := '';
end;

procedure TfObjectCard.SpeedButton2Click(Sender: TObject);
begin
    eName.Text := '';
end;

procedure TfObjectCard.SpeedButton3Click(Sender: TObject);
begin
    mComment.Lines.Text := '';
end;

end.
