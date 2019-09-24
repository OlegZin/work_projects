unit uRolesEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.StdCtrls, Vcl.Buttons, EhLibVCL, GridsEh,
  DBAxisGridsEh, DBGridEh, DB;

type
  TfRolesEditor = class(TForm)
    grdGroups: TDBGridEh;
    bAddGroup: TSpeedButton;
    bDeleteGroup: TSpeedButton;
    Label1: TLabel;
    grdGroupRoles: TDBGridEh;
    bAddRoleToGroup: TSpeedButton;
    bDeleteRoleFromGroup: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    grdRoles: TDBGridEh;
    bAddRole: TSpeedButton;
    bDeleteRole: TSpeedButton;
    bEditRole: TSpeedButton;
    bEditGroup: TSpeedButton;
    bEditRoleInGroup: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure grdGroupsCellClick(Column: TColumnEh);
    procedure bAddGroupClick(Sender: TObject);
    procedure bAddRoleToGroupClick(Sender: TObject);
    procedure grdGroupRolesApplyFilter(Sender: TObject);
    procedure grdRolesApplyFilter(Sender: TObject);
    procedure bDeleteRoleFromGroupClick(Sender: TObject);
    procedure bAddRoleClick(Sender: TObject);
    procedure bEditRoleClick(Sender: TObject);
    procedure bEditGroupClick(Sender: TObject);
    procedure bDeleteGroupClick(Sender: TObject);
    procedure bEditRoleInGroupClick(Sender: TObject);
    procedure bDeleteRoleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdGroupsDblClick(Sender: TObject);
    procedure grdGroupRolesDblClick(Sender: TObject);
    procedure grdRolesDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateGroups;
    procedure UpdateRoles;
    procedure UpdateGroupRoles;
  end;

var
  fRolesEditor: TfRolesEditor;

implementation

{$R *.dfm}

uses
    uPhenixCORE, uDatatableManager, uMain, uRoleEdit;

var
    mngDatatable : TDatatableManager;

procedure TfRolesEditor.bAddRoleClick(Sender: TObject);
begin
    if fRoleEdit
           .SetMode(MODE_NAME_EDIT+MODE_VALUE_EDIT)
           .SetName('')
           .SetValue('')
           .ShowModal = mrOK then

    if  not mngData.CreateRole( fRoleEdit.fName, fRoleEdit.fValue )
    then ShowMessage(CORE.DM.DBError)
    else UpdateRoles;
end;

procedure TfRolesEditor.bAddRoleToGroupClick(Sender: TObject);
begin
    if fRoleEdit
           .SetMode( MODE_VALUE_EDIT )
           .SetName( grdRoles.DataSource.DataSet.FieldByName('name').AsString )
           .ShowModal = mrOK then

    if  not mngData.LinkRoleToGroup(
            grdGroups.DataSource.DataSet.FieldByName('id').AsInteger,
            grdRoles.DataSource.DataSet.FieldByName('id').AsInteger,
            fRoleEdit.fValue
        )
    then ShowMessage(CORE.DM.DBError)
    else UpdateGroupRoles;
end;

procedure TfRolesEditor.bDeleteGroupClick(Sender: TObject);
begin
    if  Application.MessageBox(
            PChar('Удалить группу прав "'+ grdGroups.DataSource.DataSet.FieldByName('name').AsString +'"?'),
            'Удаление',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if   not mngData.DeleleGroup( grdGroups.DataSource.DataSet.FieldByName('id').AsInteger )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateGroups;
        UpdateRoles;
    end;
end;

procedure TfRolesEditor.bDeleteRoleClick(Sender: TObject);
begin
    if  Application.MessageBox(
            PChar('Удалить роль "'+ grdRoles.DataSource.DataSet.FieldByName('name').AsString +'"?'),
            'Удаление',
            MB_YESNO + MB_ICONQUESTION
        ) = ID_NO
    then exit;

    if   not mngData.DeleteRole( grdRoles.DataSource.DataSet.FieldByName('id').AsInteger )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateRoles;
        UpdateGroupRoles;
    end;

end;

procedure TfRolesEditor.bDeleteRoleFromGroupClick(Sender: TObject);
begin
    if   mngData.DelLinkRoleToGroup( grdGroupRoles.DataSource.DataSet.FieldByName('id').AsInteger )
    then UpdateGroupRoles;
end;

procedure TfRolesEditor.bEditGroupClick(Sender: TObject);
begin
    // не пытаемся редактировать отсутствующую шруппу
    if not grdGroups.DataSource.DataSet.Active or
      (grdGroups.DataSource.DataSet.RecordCount = 0)
    then exit;

    // показ окна редактора свойств
    if fRoleEdit
           .SetMode(MODE_NAME_EDIT)
           .SetName( grdGroups.DataSource.DataSet.FieldByName('name').AsString )
           .ShowModal = mrOK then

    if   not mngData.UpdateGroup(
             grdGroups.DataSource.DataSet.FieldByName('id').AsInteger,
             fRoleEdit.fName
         )
    then ShowMessage(CORE.DM.DBError)
    else UpdateGroups;
end;

procedure TfRolesEditor.bEditRoleClick(Sender: TObject);
begin
    if fRoleEdit
           .SetMode(MODE_NAME_EDIT+MODE_VALUE_EDIT)
           .SetName( grdRoles.DataSource.DataSet.FieldByName('name').AsString )
           .SetValue( grdRoles.DataSource.DataSet.FieldByName('value').AsString )
           .ShowModal = mrOK then

    if  not mngData.UpdateRole(
            grdRoles.DataSource.DataSet.FieldByName('id').AsInteger,
            fRoleEdit.fName,
            fRoleEdit.fValue
        )
    then ShowMessage(CORE.DM.DBError)
    else
    begin
        UpdateRoles;
        UpdateGroupRoles;
    end;
end;

procedure TfRolesEditor.bEditRoleInGroupClick(Sender: TObject);
begin
    if fRoleEdit
           .SetMode(MODE_VALUE_EDIT)
           .SetName( grdGroupRoles.DataSource.DataSet.FieldByName('name').AsString )
           .ShowModal = mrOK then

    if  not mngData.UpdateGroupRole(
            grdGroupRoles.DataSource.DataSet.FieldByName('id').AsInteger,
            fRoleEdit.fValue
        )
    then ShowMessage(CORE.DM.DBError)
    else UpdateGroupRoles;

end;

procedure TfRolesEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    mngData.RefreshRolesList( true ); // принудительное обновление набора прав
end;

procedure TfRolesEditor.FormCreate(Sender: TObject);
begin

    if not Assigned( mngDatatable ) then
    mngDatatable := TDatatableManager.Create;

    // инициализация списка групп
    grdGroups.DataSource := TDataSource.Create(self);
    grdGroups.DataSource.DataSet := Core.DM.GetDataset;

    // инициализация списка ролей группы
    grdGroupRoles.DataSource := TDataSource.Create(self);
    grdGroupRoles.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdGroupRoles, [] );

    // инициализация списка всех ролей
    grdRoles.DataSource := TDataSource.Create(self);
    grdRoles.DataSource.DataSet := Core.DM.GetDataset;
    mngDatatable.ConfigureForFilter( grdRoles, [] );


    UpdateGroups;
    UpdateGroupRoles;
    UpdateRoles;
end;

procedure TfRolesEditor.grdGroupRolesApplyFilter(Sender: TObject);
begin
    grdGroupRoles.DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( grdGroupRoles );
end;

procedure TfRolesEditor.grdGroupRolesDblClick(Sender: TObject);
begin
    bEditRoleInGroup.Click;
end;

procedure TfRolesEditor.grdGroupsCellClick(Column: TColumnEh);
begin
    UpdateGroupRoles;
end;

procedure TfRolesEditor.grdGroupsDblClick(Sender: TObject);
begin
    bEditGroup.Click;
end;

procedure TfRolesEditor.grdRolesApplyFilter(Sender: TObject);
begin
    grdRoles.DataSource.DataSet.Filter :=
        mngDatatable.GetFilterByColumns( grdRoles );
end;

procedure TfRolesEditor.grdRolesDblClick(Sender: TObject);
begin
    bEditRole.Click;
end;

procedure TfRolesEditor.bAddGroupClick(Sender: TObject);
begin
    if fRoleEdit.SetMode(MODE_NAME_EDIT).ShowModal = mrOK then

    if   not mngData.CreateGroup( fRoleEdit.fName )
    then ShowMessage(CORE.DM.DBError)
    else UpdateGroups;
end;

procedure TfRolesEditor.UpdateGroupRoles;
begin
    grdGroupRoles.DataSource.DataSet :=
        mngData.GetGroupRolesList(
            grdGroups.DataSource.DataSet.FieldByName('id').AsInteger,
            grdGroupRoles.DataSource.DataSet
        );
end;

procedure TfRolesEditor.UpdateGroups;
begin
    grdGroups.DataSource.DataSet := mngData.GetGroupsList( grdGroups.DataSource.DataSet );
end;

procedure TfRolesEditor.UpdateRoles;
begin
    grdRoles.DataSource.DataSet := mngData.GetRolesList( grdRoles.DataSource.DataSet );
end;

end.
