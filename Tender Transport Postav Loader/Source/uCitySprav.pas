unit uCitySprav;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.ListView.Types;

type
  TfCitySprav = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    procedure Button2Click(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    selText : string;
    selId : integer;
    wasDeleted : boolean;

    procedure Clear;
    procedure AddItem(const text: array of string; id: integer);
  end;

var
  fCitySprav: TfCitySprav;

implementation

{$R *.fmx}

uses uDM;

{ TForm1 }

procedure TfCitySprav.AddItem(const text: array of string; id: integer);
begin
    ListBox1.Items.AddObject( Format('%-30s %-50s %s', [text[0], text[1], text[2]]), TObject(id));
end;

procedure TfCitySprav.Button2Click(Sender: TObject);
begin
    if ListBox1.ItemIndex = -1 then exit;

    DM.DelCityAlternate(selID);
    ListBox1.Items.Delete( ListBox1.ItemIndex );
    wasDeleted := true;

    selText := '';
    selId := -1;
end;

procedure TfCitySprav.Clear;
begin
    ListBox1.Clear;
    selText := '';
    selId := -1;
end;

procedure TfCitySprav.FormShow(Sender: TObject);
begin
    wasDeleted := false;
end;

procedure TfCitySprav.ListBox1Change(Sender: TObject);
begin
    selText := ListBox1.Items[ ListBox1.ItemIndex ];
    selID := Integer(ListBox1.Items.Objects[ ListBox1.ItemIndex ]);
end;

end.
