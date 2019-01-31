program PDMConfig;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {fMain},
  uConstants in 'uConstants.pas',
  uCheckCondition in 'MailList\uCheckCondition.pas' {fCheckCondition},
  uConfigHTMLPreview in 'MailList\uConfigHTMLPreview.pas' {fHTMLPreview},
  uPhenixTypes in '..\Phenix CORE\uPhenixTypes.pas',
  ucFMXTools in '..\Phenix CORE\ucFMXTools.pas',
  uProgManager in 'Programs\uProgManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
