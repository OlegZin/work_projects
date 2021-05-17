unit uRoleEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

const
   MODE_NAME_EDIT  = 1;
   MODE_VALUE_EDIT = 2;
   MODE_DATE_EDIT  = 4;

type
  TfRoleEdit = class(TForm)
    eName: TEdit;
    Label1: TLabel;
    eValue: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    bSave: TButton;
    pickDate: TDateTimePicker;
    procedure FormShow(Sender: TObject);
    procedure eNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure eValueKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pickDateChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fName
   ,fValue
            : string;
    fDate   : TDate;
    fMode   : integer;
    fDateSelected : boolean;

    function SetMode( mode: integer ): TfRoleEdit;
    function SetName( name: string ): TfRoleEdit;
    function SetValue( value: string ): TfRoleEdit;
    function SetDate( date: string ): TfRoleEdit;
  end;

var
  fRoleEdit: TfRoleEdit;

implementation

{$R *.dfm}

{ TfRoleEdit }

procedure TfRoleEdit.eNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    fName := trim( eName.Text );
end;

procedure TfRoleEdit.eValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    fValue := trim( eValue.Text );
end;

procedure TfRoleEdit.FormShow(Sender: TObject);
begin
    eName.Enabled := fMode AND MODE_NAME_EDIT > 0;
    eValue.Enabled := fMode AND MODE_VALUE_EDIT > 0;
    pickDate.Enabled := fMode AND MODE_DATE_EDIT > 0;
end;

procedure TfRoleEdit.pickDateChange(Sender: TObject);
begin
    fDate := pickDate.Date;
    fDateSelected := pickDate.Checked;
end;

function TfRoleEdit.SetDate(date: string): TfRoleEdit;
var
   locDate: TDate;
begin
    Result := self;
    if date = ''
    then locDate := Now()
    else locDate := StrToDate(date);

    fDate := locDate;
    pickDate.Date := locDate;
    pickDate.Checked := true;
    fDateSelected := true;
end;

function TfRoleEdit.SetMode( mode: integer ): TfRoleEdit;
begin
    Result := self;
    fMode := mode;
end;

function TfRoleEdit.SetName(name: string): TfRoleEdit;
begin
    Result := self;
    fName := name;
    eName.Text := name;
end;

function TfRoleEdit.SetValue(value: string): TfRoleEdit;
begin
    Result := self;
    fValue := value;
    eValue.Text := value;
end;

end.
