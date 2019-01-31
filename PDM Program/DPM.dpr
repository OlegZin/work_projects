program DPM;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uWelcome in 'uWelcome.pas' {fWelcome},
  uConstants in 'uConstants.pas' {$R *.res};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfWelcome, fWelcome);
  Application.Run;
end.
