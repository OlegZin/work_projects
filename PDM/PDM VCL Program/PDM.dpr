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
  uObjectCatalog in 'uObjectCatalog.pas' {fObjectCatalog},
  uDatatableManager in 'navigation\uDatatableManager.pas',
  uSpecTreeFree in 'navigation\uSpecTreeFree.pas' {fSpecTreeFree},
  uObjectCard in 'uObjectCard.pas' {fObjectCard},
  uProject in 'uProject.pas' {fProject},
  uTemplatesHTML in 'templates\uTemplatesHTML.pas',
  uAddProject in 'uAddProject.pas' {fAddProject},
  uCommonOperations in 'tools\uCommonOperations.pas',
  uFileCatcher in 'tools\uFileCatcher.pas',
  uKompasManager in 'tools\uKompasManager.pas',
  uLoadSpec in 'uLoadSpec.pas' {fLoadSpec},
  uWorkGroupEditor in 'uWorkGroupEditor.pas' {fWorkgroupEditor},
  uCatalog in 'tools\uCatalog.pas' {fCatalog},
  uRolesEditor in 'tools\uRolesEditor.pas' {fRolesEditor},
  uRoleEdit in 'tools\uRoleEdit.pas' {fRoleEdit},
  uUserListManager in 'tools\uUserListManager.pas',
  uUserList in 'tools\uUserList.pas' {fUserList},
  uDrawSpecifManager in 'tools\uDrawSpecifManager.pas',
  uTypes in 'uTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfEditObject, fEditObject);
  Application.CreateForm(TfAddDoc, fAddDoc);
  Application.CreateForm(TfAddProject, fAddProject);
  Application.CreateForm(TfRoleEdit, fRoleEdit);
  Application.Run;
end.
