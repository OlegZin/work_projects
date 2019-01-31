unit uListSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList;

type
  TfListSearch = class(TForm)
    Panel1: TPanel;
    lbVariants: TListBox;
    eText: TEdit;
    bSelect: TButton;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    { Private declarations }
  public
    SelText: string;
    SelData: TObject;

    SQL
   ,TitleFieldName
   ,DataFieldName
            : string
    { Public declarations }
  end;

var
  fListSearch: TfListSearch;

implementation

{$R *.dfm}

procedure TfListSearch.Action1Execute(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfListSearch.Action2Execute(Sender: TObject);
begin
    ModalResult := mrOk;
end;

end.
