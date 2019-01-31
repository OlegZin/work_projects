program pdmUpdater;

uses
  System.StartUpCopy,
  FMX.Forms,
  uUpdater in 'uUpdater.pas' {fUpdater};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfUpdater, fUpdater);
  Application.Run;
end.
