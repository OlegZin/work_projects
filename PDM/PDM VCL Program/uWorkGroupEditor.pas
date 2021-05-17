unit uWorkGroupEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.StdCtrls, Vcl.Buttons, EhLibVCL, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, Vcl.ExtCtrls;

type
  TfWorkgroupEditor = class(TForm)
    grdWorkgroups: TDBGridEh;
    grdUsers: TDBGridEh;
    grdRightsGroups: TDBGridEh;
    grdRights: TDBGridEh;
    grdRightsPersonal: TDBGridEh;
    bCreateWorkgroup: TSpeedButton;
    bDeleteWorkgroup: TSpeedButton;
    bAddUser: TSpeedButton;
    bDeleteUser: TSpeedButton;
    bLinkGroup: TSpeedButton;
    bUnlinkGroup: TSpeedButton;
    bAddPersonalRole: TSpeedButton;
    bDeletePersonalRole: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    bUserEdit: TSpeedButton;
    checkShowAll: TCheckBox;
    bEditLinkGroup: TSpeedButton;
    bEditPersonalRole: TSpeedButton;
    bEditWorkgroup: TSpeedButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    Splitter3: TSplitter;
    Panel6: TPanel;
    Panel7: TPanel;
    Splitter4: TSplitter;
    Panel8: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure bCreateWorkgroupClick(Sender: TObject);
    procedure bAddUserClick(Sender: TObject);
    procedure grdWorkgroupsCellClick(Column: TColumnEh);
    procedure bDeleteWorkgroupClick(Sender: TObject);
    procedure bDeleteUserClick(Sender: TObject);
    procedure bUserEditClick(Sender: TObject);
    procedure bLinkGroupClick(Sender: TObject);
    procedure bUnlinkGroupClick(Sender: TObject);
    procedure grdWorkgroupsSelectionChanged(Sender: TObject);
    procedure grdUsersCellClick(Column: TColumnEh);
    procedure grdUsersSelectionChanged(Sender: TObject);
    procedure grdRightsGroupsCellClick(Column: TColumnEh);
    procedure grdRightsGroupsSelectionChanged(Sender: TObject);
    procedure checkShowAllClick(Sender: TObject);
    procedure bAddPersonalRoleClick(Sender: TObject);
    procedure bEditLinkGroupClick(Sender: TObject);
    procedure bDeletePersonalRoleClick(Sender: TObject);
    procedure bEditPersonalRoleClick(Sender: TObject);
    procedure bEditWorkgroupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdWorkgroupsDblClick(Sender: TObject);
    procedure grdUsersDblClick(Sender: TObject);
    procedure grdRightsGroupsDblClick(Sender: TObject);
    procedure grdRightsPersonalDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateWorkgroups;
    procedure UpdateUsers;
    procedure UpdateRights;
    procedure UpdatePersonalRights;
    procedure UpdateGroups;
  public
    { Public declarations }
  end;

var
  fWorkgroupEditor: TfWorkgroupEditor;

implementation

{$R *.dfm}

uses uPhenixCORE, uDatatableManager, uConstants, uMain, uCatalog, uRoleEdit;

var
    mngDatatable : TDatatableManager;
    fCatalog : TfCatalog;

procedure TfWorkgroupEditor.bDeletePersonalRoleClick(Sender: TObject);
begin
    if not grdRightsPersonal.DataSource.DataSet.Active or (grdRightsPersonal.DataSource.DataSet.RecordCount = 0) then exit;

    if   not mngData.DeleteLinkPersonalRole(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
             grdRightsPersonal.DataSource.DataSet.FieldByName('id').AsInteger
         )
    then ShowMessage(CORE.DM.DBError)
    else UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.bDeleteUserClick(Sender: TObject);
begin
    if not grdUsers.DataSource.DataSet.Active or (grdUsers.DataSource.DataSet.RecordCount = 0) then exit;

    if   not mngData.DeleleLinkUserToWorkgroup(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger
         )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateUsers;
        UpdateRights;
        UpdatePersonalRights;
        UpdateGroups;
    end;
end;

procedure TfWorkgroupEditor.bDeleteWorkgroupClick(Sender: TObject);
begin
    if  Application.MessageBox(
            PChar('”далить рабочую группу "'+ grdWorkgroups.DataSource.DataSet.FieldByName('name').AsString +'"?'),
            '”даление',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if   not mngData.DeleleWorkgroup( grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateWorkgroups;
        UpdateUsers;
        UpdateGroups;
    end;
end;

procedure TfWorkgroupEditor.bEditLinkGroupClick(Sender: TObject);
begin
    if not grdRightsGroups.DataSource.DataSet.Active or ( grdRightsGroups.DataSource.DataSet.RecordCount = 0 ) then exit;

    if fRoleEdit
           .SetMode(MODE_DATE_EDIT)
           .SetName( grdRightsGroups.DataSource.DataSet.FieldByName('name').AsString )
           .SetDate( grdRightsGroups.DataSource.DataSet.FieldByName('todate').AsString )
           .ShowModal = mrOK then

    if   not mngData.UpdateLinkUserToGroup(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
             grdRightsGroups.DataSource.DataSet.FieldByName('id').AsInteger,
             fRoleEdit.fDate,
             fRoleEdit.fDateSelected
         )
    then ShowMessage(CORE.DM.DBError)
    else UpdateGroups;
end;

procedure TfWorkgroupEditor.bEditPersonalRoleClick(Sender: TObject);
begin
    if not grdRightsPersonal.DataSource.DataSet.Active or (grdRightsPersonal.DataSource.DataSet.RecordCount = 0) then exit;

    if fRoleEdit
           .SetMode(MODE_VALUE_EDIT+MODE_DATE_EDIT)
           .SetName( grdRightsPersonal.DataSource.DataSet.FieldByName('name').AsString )
           .SetValue( grdRightsPersonal.DataSource.DataSet.FieldByName('value').AsString )
           .SetDate( grdRightsPersonal.DataSource.DataSet.FieldByName('todate').AsString )
           .ShowModal = mrOK then

    if   not mngData.UpdateLinkPersonalRole(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
             grdRightsPersonal.DataSource.DataSet.FieldByName('id').AsInteger,
             fRoleEdit.fValue,
             fRoleEdit.fDate,
             fRoleEdit.fDateSelected
         )
    then ShowMessage(CORE.DM.DBError)
    else UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.bEditWorkgroupClick(Sender: TObject);
begin
    // не пытаемс€ редактировать отсутствующую шруппу
    if not grdWorkgroups.DataSource.DataSet.Active or (grdWorkgroups.DataSource.DataSet.RecordCount = 0)
    then exit;

    // показ окна редактора свойств
    if fRoleEdit
           .SetMode(MODE_NAME_EDIT)
           .SetName( grdWorkgroups.DataSource.DataSet.FieldByName('name').AsString )
           .ShowModal = mrOK then

    if   not mngData.UpdateWorkgroup(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             fRoleEdit.fName
         )
    then ShowMessage(CORE.DM.DBError)
    else UpdateWorkgroups;
end;

procedure TfWorkgroupEditor.bLinkGroupClick(Sender: TObject);
begin
    // отмен€ем прив€зку, если нет выбранного пользовател€
    if not grdUsers.DataSource.DataSet.Active or (grdUsers.DataSource.DataSet.RecordCount = 0) then exit;

    if fCatalog
        .SetSQL(' SELECT id, name FROM ' + TBL_ROLES_GROUPS )
        .SetFields(['name'])
        .SetFilter([])
        .ShowModal = mrOK
    then
    if   not mngData.LinkWorkgroupUserToGroup(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
             fCatalog.GetDataset.FieldByName('id').AsInteger
         )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateGroups;
        UpdateRights;
    end;
end;

procedure TfWorkgroupEditor.bUnlinkGroupClick(Sender: TObject);
begin
    if not grdRightsGroups.DataSource.DataSet.Active or (grdRightsGroups.DataSource.DataSet.RecordCount = 0) then exit;

    if   not mngData.DeleteLinkWorkgroupUserToGroup(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
             grdRightsGroups.DataSource.DataSet.FieldByName('id').AsInteger
         )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateGroups;
        UpdateRights;
    end;
end;

procedure TfWorkgroupEditor.bUserEditClick(Sender: TObject);
begin
    if not grdUsers.DataSource.DataSet.Active or ( grdUsers.DataSource.DataSet.RecordCount = 0 ) then exit;

    if fRoleEdit
           .SetMode(MODE_DATE_EDIT)
           .SetName( grdUsers.DataSource.DataSet.FieldByName('name').AsString )
           .SetDate( grdUsers.DataSource.DataSet.FieldByName('todate').AsString )
           .ShowModal = mrOK then

    if   not mngData.UpdateLinkUserToWorkroup(
             grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
             grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
             fRoleEdit.fDate,
             fRoleEdit.fDateSelected
         )
    then ShowMessage(CORE.DM.DBError)
    else UpdateUsers;
end;

procedure TfWorkgroupEditor.checkShowAllClick(Sender: TObject);
begin
    UpdateRights;
end;

procedure TfWorkgroupEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    mngData.RefreshRolesList( true ); // принудительное обновление набора прав
end;

procedure TfWorkgroupEditor.FormCreate(Sender: TObject);
begin

    if not Assigned( mngDatatable ) then
    mngDatatable := TDatatableManager.Create;

    // инициализаци€ списка рабочих групп
    grdWorkgroups.DataSource := TDataSource.Create(self);
    grdWorkgroups.DataSource.DataSet := Core.DM.GetDataset;

    // инициализаци€ списка пользователей в рабочей группе
    grdUsers.DataSource := TDataSource.Create(self);
    grdUsers.DataSource.DataSet := Core.DM.GetDataset;

    // инициализаци€ списка групп прав прив€занных к пользователю
    grdRightsGroups.DataSource := TDataSource.Create(self);
    grdRightsGroups.DataSource.DataSet := Core.DM.GetDataset;

    // инициализаци€ списка всех прав из прив€занных групп пользовател€
    grdRights.DataSource := TDataSource.Create(self);
    grdRights.DataSource.DataSet := Core.DM.GetDataset;

    // инициализаци€ списка индивидуальных прав пользовател€
    grdRightsPersonal.DataSource := TDataSource.Create(self);
    grdRightsPersonal.DataSource.DataSet := Core.DM.GetDataset;

    fCatalog := TfCatalog.Create(self);

    UpdateWorkgroups;
    UpdateUsers;
    UpdateGroups;
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.grdRightsGroupsCellClick(Column: TColumnEh);
begin
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.grdRightsGroupsDblClick(Sender: TObject);
begin
    bEditLinkGroup.Click;
end;

procedure TfWorkgroupEditor.grdRightsGroupsSelectionChanged(Sender: TObject);
begin
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.grdRightsPersonalDblClick(Sender: TObject);
begin
    bEditPersonalRole.Click;
end;

procedure TfWorkgroupEditor.grdUsersCellClick(Column: TColumnEh);
begin
    UpdateGroups;
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.grdUsersDblClick(Sender: TObject);
begin
    bUserEdit.Click;
end;

procedure TfWorkgroupEditor.grdUsersSelectionChanged(Sender: TObject);
begin
    UpdateGroups;
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.grdWorkgroupsCellClick(Column: TColumnEh);
begin
    UpdateUsers;
    UpdateGroups;
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.grdWorkgroupsDblClick(Sender: TObject);
begin
    bEditWorkgroup.Click;
end;

procedure TfWorkgroupEditor.grdWorkgroupsSelectionChanged(Sender: TObject);
begin
    UpdateUsers;
    UpdateGroups;
    UpdateRights;
    UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.bCreateWorkgroupClick(Sender: TObject);
begin
    if fRoleEdit
           .SetMode(MODE_NAME_EDIT)
           .SetName('')
           .ShowModal = mrOK then

    if   not mngData.CreateWorkgroup( fRoleEdit.fName )
    then ShowMessage(CORE.DM.DBError)
    else UpdateWorkgroups;
end;

procedure TfWorkgroupEditor.bAddPersonalRoleClick(Sender: TObject);
begin

    if fCatalog
        .SetSQL(' SELECT id, name FROM ' + TBL_ROLES_RIGHTS )
        .SetFields(['name'])
        .SetFilter([])
        .ShowModal = mrOK
    then

    if  not mngData.LinkPersonalRole(
            grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
            grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
            fCatalog.GetDataset.FieldByName('id').AsInteger
        )
    then ShowMessage(CORE.DM.DBError)
    else UpdatePersonalRights;
end;

procedure TfWorkgroupEditor.bAddUserClick(Sender: TObject);
begin

    if fCatalog
        .SetSQL(' SELECT id, fio FROM ' + TBL_EMPLOYEES )
        .SetFields(['fio'])
        .SetFilter([])
        .ShowModal = mrOK
    then

    if   mngData.LinkUserToWorkroup(
                 grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
                 fCatalog.GetDataset.FieldByName('id').AsInteger
         ) = 0
    then ShowMessage( lE( CORE.DM.DBError ) )
    else UpdateUsers;

end;

procedure TfWorkgroupEditor.UpdateGroups;
begin
    grdRightsGroups.DataSource.DataSet :=
        mngData.GetWorkgroupUserGroupsList(
            grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
            grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
            grdRightsGroups.DataSource.DataSet
        );
end;

procedure TfWorkgroupEditor.UpdatePersonalRights;
begin
    grdRightsPersonal.DataSource.DataSet :=
        mngData.GetWorkgroupUserPersonalRolesList(
            grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
            grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
            grdRightsPersonal.DataSource.DataSet
        );
end;

procedure TfWorkgroupEditor.UpdateRights;
// получаем список всех пользователей указанной рабочей группы
begin
    if checkShowAll.Checked
    then
        grdRights.DataSource.DataSet :=
            mngData.GetWorkgroupUserRolesFullList(
                grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
                grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
                grdRights.DataSource.DataSet
            )
    else
        grdRights.DataSource.DataSet :=
            mngData.GetWorkgroupUserRolesList(
                grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
                grdUsers.DataSource.DataSet.FieldByName('id').AsInteger,
                grdRightsGroups.DataSource.DataSet.FieldByName('id').AsInteger,
                grdRights.DataSource.DataSet
            );
end;


procedure TfWorkgroupEditor.UpdateUsers;
// получаем список всех пользователей указанной рабочей группы
begin
    grdUsers.DataSource.DataSet :=
        mngData.GetWorkgroupUserList(
            grdWorkgroups.DataSource.DataSet.FieldByName('id').AsInteger,
            grdUsers.DataSource.DataSet
        );
end;

procedure TfWorkgroupEditor.UpdateWorkgroups;
// получаем список всех существующих рабочих групп
begin
    grdWorkgroups.DataSource.DataSet := mngData.GetWorkgroupsList( grdWorkgroups.DataSource.DataSet );
end;

end.
