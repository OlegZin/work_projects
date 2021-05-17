unit uAtlas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects;

type
  TfAtlas = class(TForm)
    prog_default: TImage;
    icon_work: TImage;
    icon_test: TImage;
    icon_personal: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAtlas: TfAtlas;

implementation

{$R *.fmx}

end.
