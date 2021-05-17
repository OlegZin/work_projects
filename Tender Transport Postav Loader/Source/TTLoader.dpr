program TTLoader;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uDM in 'uDM.pas' {DM: TDataModule},
  uTextComparer in 'uTextComparer.pas',
  uSelect in 'uSelect.pas' {fSelect},
  uColorPicker in 'uColorPicker.pas' {fColorPicker},
  uCitySprav in 'uCitySprav.pas' {fCitySprav};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfSelect, fSelect);
  Application.CreateForm(TfColorPicker, fColorPicker);
  Application.CreateForm(TfCitySprav, fCitySprav);
  Application.Run;
end.
