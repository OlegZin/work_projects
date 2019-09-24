unit uCreateWorkgroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfCreateWorkgroup = class(TForm)
    eGroupName: TEdit;
    bOk: TButton;
    procedure eGroupNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure bOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WorkgroupName: string;
  end;

var
  fCreateWorkgroup: TfCreateWorkgroup;

implementation

{$R *.dfm}

procedure TfCreateWorkgroup.bOkClick(Sender: TObject);
begin
    ModalResult := mrOk;
end;

procedure TfCreateWorkgroup.eGroupNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    WorkgroupName := trim( eGroupName.Text );
//    bOk.Enabled := WorkgroupName <> '';
end;

procedure TfCreateWorkgroup.FormShow(Sender: TObject);
begin
    WorkgroupName := '';
    eGroupName.Text := '';
end;

end.
