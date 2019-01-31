program PDM;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uWelcom in 'uWelcom.pas' {fWelcome},
  uConstants in 'uConstants.pas',
  uEditNavigation in 'navigation\uEditNavigation.pas' {fEditNavigation},
  uSpecifTreeManager in 'navigation\uSpecifTreeManager.pas',
  uDataManager in 'tools\uDataManager.pas',
  uEditObject in 'navigation\uEditObject.pas' {fEditObject},
  uEditSection in 'navigation\uEditSection.pas' {fEditSection},
  uFileManager in 'tools\uFileManager.pas',
  uAddDoc in 'uAddDoc.pas' {fAddDoc},
  Unit2 in 'test\Unit2.pas' {Form2},
  uObjectCatalog in 'uObjectCatalog.pas' {fObjectCatalog},
  uDatatableManager in 'navigation\uDatatableManager.pas',
  uSpecTreeFree in 'navigation\uSpecTreeFree.pas' {fSpecTreeFree},
  uObjectCard in 'uObjectCard.pas' {fObjectCard};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfEditObject, fEditObject);
  Application.CreateForm(TfAddDoc, fAddDoc);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
