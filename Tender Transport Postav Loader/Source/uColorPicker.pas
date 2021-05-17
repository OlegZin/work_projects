unit uColorPicker;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Colors,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TfColorPicker = class(TForm)
    ColorPanel1: TColorPanel;
    rColorPanel: TRectangle;
    Button1: TButton;
    ColorBox1: TColorBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    _rectangle : TRectangle;
    procedure SetRectangle(const Value: TRectangle);
  public
    { Public declarations }
    property Rectangle: TRectangle read _rectangle write SetRectangle;
  end;

var
  fColorPicker: TfColorPicker;

implementation

{$R *.fmx}

{ TfColorPicker }

procedure TfColorPicker.Button1Click(Sender: TObject);
begin
    rColorPanel.Parent := fColorPicker;
end;

procedure TfColorPicker.Button2Click(Sender: TObject);
begin
    Rectangle.Fill.Color := ColorBox1.Color;
    rColorPanel.Parent := fColorPicker;
end;

procedure TfColorPicker.SetRectangle(const Value: TRectangle);
begin
    _rectangle := Value;
    ColorPanel1.Color := _rectangle.Fill.Color;
end;

end.
