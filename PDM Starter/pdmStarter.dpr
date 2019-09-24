program pdmStarter;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uProgManager in '..\PDM Config\Programs\uProgManager.pas',
  uConstants in 'uConstants.pas',
  uPhenixCore in '..\Phenix CORE\uPhenixCore.pas',
  uAtlas in 'uAtlas.pas' {fAtlas};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
