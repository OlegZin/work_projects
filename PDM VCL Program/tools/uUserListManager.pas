unit uUserListManager;

///  ������ �������� �����, ������� ����� ��� ������� ����������
///  LiatBox � Combobox ��������� �������� ����������� �������������
///  ��� � �����, ��������� � �������, ��� � ���, ��� �������� � ������� �
///  �����-���� ������ ��� ��������
///  ����� ���� ������������� ������������ �����������, �������� ���������� ������
///  ��� �� �������������� �������� drag-n-drop �� ������ ��� ������� �����������
///  ������������� � ������ �������.
///
///  ������������ ��� ������ ��������, ������� ����� �������� ��� � ��������� ������
///  ��� � ���������� � ������� ����� ��������

interface

uses
    StdCtrls, System.Classes, uDataManager, ADODB, DB, SysUtils;

type

    TUserListManager = class
    private
        fCombobox : TCombobox;     // ���������� ������ ������ ����� �������������
        fListBox : TListBox;       // ����������� ������������� ���������� ����
        fFilterEdit: TEdit;        // ���� �������� ������� ��� ������ �������������
        fDataManager: TDataManager;// ����� ��� ��������� ������
        fWorkgroupId               // ������ �� ������� ������ �������
       ,fProjectId                 // ������ �� ��� ������ (������������ ����� ���� ��������� ��������)
                : integer;

        ready_to_work: boolean;  // ������� ����, ��� ���������� ��������� � ���������
                                 // ��� ������� �������� �������� ������, ����� ��
                                 // ��������

        fGroupList               // ������ ���� �����
       ,fUserList                // ������ ���� ������������� � ������� ������
                : TADOQuery;

        // ���������� ����� ���� ������ �������������
        procedure cbOnChange(Sender: TObject);
        procedure cbOnDropDown(Sender: TObject);
        // ���������� ��������� ������ �������
        procedure eFilterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

        procedure RefreshUserList;
    public
        /// ��� ������������� ������, �� ����� ������������ ����
        error : string;

        constructor Create;
        destructor Destroy;

        // �������� ������ ��������� � �������� ��������
        function SetKindComponent( combo: TCombobox ): TUserListManager;
        function SetFindComponent( edit: TEdit ): TUserListManager;
        function SetListComponent( list: TListBox ): TUserListManager;
        function SetDataManager( manager: TDataManager ): TUserListManager;
        function SetWorkgroupId( workgroup_id: integer ): TUserListManager;
        function SetProjectId( project_id: integer ): TUserListManager;

        // ���������� ����� �������� ���� ��������� ��� ��������� � ���������
        // ��������� ������
        function Init: boolean;

    end;

implementation

{ TUserListManager }
const
    GROUP_ALL_USERS = 0;
    GROUP_ALL_IN_PROJECT = -1;
    GROUP_IN_WORKGROUP = -2;
    GROUP_IN_PROJECT = -3;

    MAX_IN_LIST = 100;

procedure TUserListManager.cbOnChange(Sender: TObject);
begin
    RefreshUserList;
end;

procedure TUserListManager.RefreshUserList;
var
    add: boolean;
begin
    if not ready_to_work then exit;


    fListBox.Items.Clear;
    fUserList.First;
    while not fUserList.eof do
    begin
        // ���������, �������� �� ������������ �� ���� ��������� ������
        add := false;
        case Integer(fCombobox.Items.Objects[ fCombobox.ItemIndex ]) of
            GROUP_ALL_USERS:      add := true;
            GROUP_ALL_IN_PROJECT: add :=
                (fUserList.FieldByName('workgroup_id').AsInteger = fWorkgroupId) or
                (fUserList.FieldByName('workgroup_id').AsInteger = fProjectId);
            GROUP_IN_WORKGROUP:   add := fUserList.FieldByName('workgroup_id').AsInteger = fWorkgroupId;
            GROUP_IN_PROJECT:     add := fUserList.FieldByName('workgroup_id').AsInteger = fProjectId;
            else
                add := fUserList.FieldByName('group_id').AsInteger = Integer(fCombobox.Items.Objects[ fCombobox.ItemIndex ]);
        end;

        // ���������, �������� �� ������������ �� �������� �������
        if add and (Trim(fFilterEdit.Text) <> '') then
        add := Pos( AnsiUpperCase(Trim(fFilterEdit.Text)), AnsiUpperCase(fUserList.FieldByName('user_name').AsString )) > 0;

        if add and ( fListBox.Items.Count < MAX_IN_LIST )
        then
            if   fListBox.Items.IndexOf( fUserList.FieldByName('user_name').AsString ) = -1
            then fListBox.Items.AddObject( fUserList.FieldByName('user_name').AsString, TObject( fUserList.FieldByName('user_id').AsInteger ));

        fUserList.Next;
    end;
end;

procedure TUserListManager.cbOnDropDown(Sender: TObject);
begin

end;

constructor TUserListManager.Create;
begin
    Inherited;
    ready_to_work := false;
    fWorkgroupId := 0;
    fProjectId := 0;
    fGroupList := TADOQuery.Create(nil);
    fUserList := TADOQuery.Create(nil);
end;

destructor TUserListManager.Destroy;
begin
    fGroupList.Free;
    fUserList.free;
    inherited;
end;

procedure TUserListManager.eFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    RefreshUserList;
end;

function TUserListManager.Init: boolean;
begin

    error := '';
    result := false;

    // �������� ����������� ���� ���������
    if not Assigned(fCombobox)    then error := '�� �������� ���������� ������ ��� ����������� ����� �������������';
    if not Assigned(fFilterEdit)  then error := '�� ��������� ���� ����� ��� ���������� ������ �������������';
    if not Assigned(fListBox)     then error := '�� �������� ��������� ������ ��� ������ �������������';
    if not Assigned(fDataManager) then error := '�� �������� ��������� ������ � �������';
//    if fWorkgroupId = 0           then error := '�� ������� ������� ������';
//    if fProjectId = 0             then error := '�� ������ ������';

    if error <> '' then exit;

    // ��������� ���������
    fCombobox.Style := csDropDownList;
    fCombobox.Items.Clear;
    fCombobox.OnDropDown := cbOnDropDown;
    fCombobox.OnChange := cbOnChange;

    fFilterEdit.Text := '';
    fFilterEdit.OnKeyUp := eFilterKeyUp;

    fListBox.Items.Clear;

    ready_to_work := true;

    // �������� ����� �����
    fGroupList := fDataManager.GetGroupsList(nil);
    fCombobox.Items.AddObject('��� ������������', TObject(0));
    if fProjectId <> 0   then fCombobox.Items.AddObject('��������� �������', TObject(-1));
    if fWorkgroupId <> 0 then fCombobox.Items.AddObject('��������� � ������� ������', TObject(-2));
    if fProjectId <> 0   then fCombobox.Items.AddObject('��������� � �������� � �������', TObject(-3));

    while not fGroupList.Eof do
    begin
        fCombobox.Items.AddObject(fGroupList.FieldByName('name').AsString, TObject( fGroupList.FieldByName('id').AsInteger ));
        fGroupList.Next;
    end;

    if fProjectId <> 0
    then fCombobox.ItemIndex := fCombobox.Items.IndexOf('��������� �������')
    else fCombobox.ItemIndex := fCombobox.Items.IndexOf('��� ������������');

    // �������� ������ ���� �������������
    fUserList := fDataManager.GetProjectUserList( fWorkgroupId, fProjectId );

    RefreshUserList;

    /// ������� ���������� �������������
    result := true;
end;

function TUserListManager.SetDataManager(
  manager: TDataManager): TUserListManager;
begin
    result := self;
    fDataManager := manager;
end;

function TUserListManager.SetFindComponent(edit: TEdit): TUserListManager;
begin
    result := self;
    fFilterEdit := edit;
end;

function TUserListManager.SetKindComponent(combo: TCombobox): TUserListManager;
begin
    result := self;
    fCombobox := combo;
end;

function TUserListManager.SetListComponent(list: TListBox): TUserListManager;
begin
    result := self;
    fListBox := list;
end;

function TUserListManager.SetProjectId(project_id: integer): TUserListManager;
begin
    result := self;
    fProjectId := project_id;
end;

function TUserListManager.SetWorkgroupId(
  workgroup_id: integer): TUserListManager;
begin
    result := self;
    fWorkgroupId := workgroup_id;
end;

end.
