unit uListSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Imaging.pngimage;

type
  TElem = array[0..1] of Variant;
  TData = array of TElem;

  TCallback = procedure(value: string) of object;

  TfListSearch = class(TForm)
    Panel1: TPanel;
    lbVariants: TListBox;
    eText: TEdit;
    bSelect: TButton;
    ActionList1: TActionList;
    Action1: TAction;
    Panel2: TPanel;
    bClose: TImage;
    procedure Action1Execute(Sender: TObject);
    procedure lbVariantsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eTextKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbVariantsClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure lbVariantsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    data : TData;
    procedure RefreshList;
    { Private declarations }
  public
    Callback : TCallback;

    procedure ClearUp;
    procedure AddData(val1, val2: variant);

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

procedure TfListSearch.AddData(val1, val2: variant);
begin
    SetLength(Data, Length(Data)+1);
    Data[High(Data)][0] := val1;   // показываемое в списке значение
    Data[High(Data)][1] := val2;   // скрытое значение. например, id записи
end;

procedure TfListSearch.bCloseClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfListSearch.ClearUp;
begin
    eText.Text := '';
    lbVariants.Items.Clear;
    SetLength(data, 0);
end;

procedure TfListSearch.eTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_DOWN then
    begin
        lbVariants.SetFocus;
        exit;
    end;

    RefreshList;
end;

procedure TfListSearch.FormShow(Sender: TObject);
begin
    RefreshList;
    eText.SetFocus;
end;

procedure TfListSearch.lbVariantsClick(Sender: TObject);
begin
    bSelect.Enabled := lbVariants.ItemIndex <> -1;
end;

procedure TfListSearch.lbVariantsDblClick(Sender: TObject);
begin
    ModalResult := mrOk;
end;

procedure TfListSearch.lbVariantsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

    if ( KEY = VK_UP ) and ((lbVariants.Items.Count = 0 ) or ( lbVariants.ItemIndex = 0 )) then
    begin
        eText.SetFocus;
    end;

    if key = VK_HOME then lbVariants.ItemIndex := 0;
    if key = VK_END then lbVariants.ItemIndex := lbVariants.Items.Count - 1;

    if key = VK_RETURN then ModalResult := mrOk;
    if key = VK_ESCAPE then ModalResult := mrCancel;

end;

procedure TfListSearch.RefreshList;
var
    i: integer;
begin
    bSelect.Enabled := false;

    if Assigned(Callback) then Callback( eText.Text );

    lbVariants.Items.Clear;

    for I := 0 to High(Data) do
    if ( Trim(eText.Text) = '' ) or
       ( Pos(AnsiUpperCase(eText.text), AnsiUpperCase(Data[i][0])) > 0 ) then
        lbVariants.Items.AddObject(Data[i][0], TObject(Integer(Data[i][1])));
end;

end.
