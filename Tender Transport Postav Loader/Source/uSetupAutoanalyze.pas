unit uSetupAutoanalyze;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfSetupAutoanalyze = class(TForm)
    Label1: TLabel;
    mMarshrut: TMemo;
    mOtklon: TMemo;
    Label2: TLabel;
    mTonnag: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
  private
    function ReadMarshrut: string;
    procedure WriteMarshtut(const Value: string);
    function ReadOtklon: string;
    function ReadTonnag: string;
    procedure WriteOtklon(const Value: string);
    procedure WriteTonnag(const Value: string);
    { Private declarations }
    procedure CleanUp(var memo: TMemo);
  public
    { Public declarations }
    property marshrut: string read ReadMarshrut write WriteMarshtut;
    property otklon: string read ReadOtklon write WriteOtklon;
    property tonnag: string read ReadTonnag write WriteTonnag;
  end;

var
  fSetupAutoanalyze: TfSetupAutoanalyze;

implementation

{$R *.fmx}

{ TfSetupAutoanalyze }

procedure TfSetupAutoanalyze.CleanUp(var memo: TMemo);
var
    i : integer;
begin
    for I := memo.lines.Count - 1 to 0 do
    if Trim(memo.lines[i]) = '' then memo.lines.Delete(i);
end;

function TfSetupAutoanalyze.ReadMarshrut: string;
begin
    CleanUp( mMarshrut );
    result := mMarshrut.Lines.CommaText;
end;

function TfSetupAutoanalyze.ReadOtklon: string;
begin
    CleanUp( mOtklon );
    result := mOtklon.Lines.CommaText;
end;

function TfSetupAutoanalyze.ReadTonnag: string;
begin
    CleanUp( mTonnag );
    result := mTonnag.Lines.CommaText;
end;

procedure TfSetupAutoanalyze.WriteMarshtut(const Value: string);
begin
    mMarshrut.Lines.CommaText := value;
end;

procedure TfSetupAutoanalyze.WriteOtklon(const Value: string);
begin
    mOtklon.Lines.CommaText := value;
end;

procedure TfSetupAutoanalyze.WriteTonnag(const Value: string);
begin
    mTonnag.Lines.CommaText := value;
end;

end.
