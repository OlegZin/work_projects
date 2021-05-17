unit uSelect;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Edit;

type
  TfSelect = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Panel1: TPanel;
    lmarshrut: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    eFilter: TEdit;
    Label3: TLabel;
    procedure ListBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eFilterTyping(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    values: array of string;
    datas: array of TObject;

    _updated: boolean; // если установлен, список в процессе обновлени€
    procedure UpdateList;
  public
    selIndex: integer;
    selText: string;
    selData: TObject;

    { Public declarations }
    procedure ClearList;
    procedure SetMarshrut(text: string);
    procedure AddList(text: string; data: TObject);
    procedure DecoratonState(val: boolean);
  end;

var
  fSelect: TfSelect;

implementation

{$R *.fmx}

procedure TfSelect.AddList(text: string; data: TObject);
begin
    SetLength(values, Length(values)+1);
    values[High(values)] := text;

    SetLength(datas, Length(datas)+1);
    datas[High(datas)] := data;
end;

procedure TfSelect.ClearList;
begin
    selIndex := -1;
    button1.EnableD := false;

    SetLength(values,0);
    SetLength(datas,0);

    UpdateList;
end;

procedure TfSelect.DecoratonState(val: boolean);
begin
    Label1.Visible := val;
    label2.Visible := val;
end;

procedure TfSelect.eFilterTyping(Sender: TObject);
begin
    UpdateList;
end;

procedure TfSelect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    eFilter.Text := '';
end;

procedure TfSelect.FormShow(Sender: TObject);
begin
    UpdateList;
end;

procedure TfSelect.ListBox1Change(Sender: TObject);
begin
    selIndex := ListBox1.ItemIndex;
    selText := ListBox1.Items[ListBox1.ItemIndex];
    selData := ListBox1.Items.Objects[ListBox1.ItemIndex];

    Button1.Enabled := selIndex <> -1;
end;

procedure TfSelect.SetMarshrut(text: string);
begin
    lmarshrut.Text := text;
end;

procedure TfSelect.UpdateList;
var
    i, displayed: integer;
begin
    if _updated then exit;

    _updated := true;

    ListBox1.Items.Clear;
    ListBox1.BeginUpdate;
    displayed := 0;

    for I := 0 to High(values) do
    if ((Length(Trim(eFilter.Text)) > 2) and (Pos(AnsiUppercase(eFilter.Text), AnsiUpperCase(values[i])) > 0)) or
       (Length(Trim(eFilter.Text)) < 3 ) then
    begin
        ListBox1.Items.AddObject(values[i], datas[i]);
        Application.ProcessMessages;

        Inc(displayed);
        if displayed > 99 then break;

    end;

    ListBox1.EndUpdate;

    _updated := false;
end;

end.
