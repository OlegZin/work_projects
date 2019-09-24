unit uUserListManager;

///  модуль содержит класс, котррый через два внешних компонента
///  LiatBox и Combobox реализует механизм справочника пользователей
///  как в целом, имеющихся в системе, так и тех, кто привязан к проекту к
///  какой-либо группе или напрямую
///  выбор типа пользователей производится комбобоксом, листбокс отображает список
///  так же поддерживается механизм drag-n-drop из списка для прямого накидывания
///  пользователей в дерево проекта.
///
///  используется как единый механизм, который может работать как с отдельной формой
///  так и встроенным в польшую форму разделом

interface

uses
    StdCtrls, System.Classes, uDataManager, ADODB, DB, SysUtils;

type

    TUserListManager = class
    private
        fCombobox : TCombobox;     // выпадающий список показа типов пользователей
        fListBox : TListBox;       // отображение пользователей выбранного типа
        fFilterEdit: TEdit;        // поле быстрого фильтра для списка пользователей
        fDataManager: TDataManager;// класс для получения данных
        fWorkgroupId               // ссылка на рабочую группу проекта
       ,fProjectId                 // ссылка на сам проект (пользователи могут быть привязаны напрямую)
                : integer;

        ready_to_work: boolean;  // признак того, что компоненты привязаны и настроены
                                 // для быстрой проверки методами класса, можно ли
                                 // работать

        fGroupList               // список всех групп
       ,fUserList                // список всех пользователей в текущей группе
                : TADOQuery;

        // обработчик смены типа группы пользователей
        procedure cbOnChange(Sender: TObject);
        procedure cbOnDropDown(Sender: TObject);
        // обработчик изменения текста фильтра
        procedure eFilterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

        procedure RefreshUserList;
    public
        /// при возникновении ошибки, ее текст складывается сюда
        error : string;

        constructor Create;
        destructor Destroy;

        // передача классу компонент с которыми работать
        function SetKindComponent( combo: TCombobox ): TUserListManager;
        function SetFindComponent( edit: TEdit ): TUserListManager;
        function SetListComponent( list: TListBox ): TUserListManager;
        function SetDataManager( manager: TDataManager ): TUserListManager;
        function SetWorkgroupId( workgroup_id: integer ): TUserListManager;
        function SetProjectId( project_id: integer ): TUserListManager;

        // вызывается после привязки всех компонент для настройки и получения
        // первичных данных
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
        // проверяем, подходит ли пользователь по типу выбранной группы
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

        // проверяем, подходит ли пользователь по текущему фильтру
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

    // проверка подключения всех компонент
    if not Assigned(fCombobox)    then error := 'Не привязан выпадающий список для отображения групп пользователей';
    if not Assigned(fFilterEdit)  then error := 'Не привязано поле ввода для фильтрации списка пользователей';
    if not Assigned(fListBox)     then error := 'Не привязан компонент списка для вывода пользователей';
    if not Assigned(fDataManager) then error := 'Не привязан компонент работы с данными';
//    if fWorkgroupId = 0           then error := 'Не указана рабочая группа';
//    if fProjectId = 0             then error := 'Не указан проект';

    if error <> '' then exit;

    // настройка компонент
    fCombobox.Style := csDropDownList;
    fCombobox.Items.Clear;
    fCombobox.OnDropDown := cbOnDropDown;
    fCombobox.OnChange := cbOnChange;

    fFilterEdit.Text := '';
    fFilterEdit.OnKeyUp := eFilterKeyUp;

    fListBox.Items.Clear;

    ready_to_work := true;

    // получаем набор групп
    fGroupList := fDataManager.GetGroupsList(nil);
    fCombobox.Items.AddObject('Все пользователи', TObject(0));
    if fProjectId <> 0   then fCombobox.Items.AddObject('Участники проекта', TObject(-1));
    if fWorkgroupId <> 0 then fCombobox.Items.AddObject('Участники в рабочей группе', TObject(-2));
    if fProjectId <> 0   then fCombobox.Items.AddObject('Участники в привязке к проекту', TObject(-3));

    while not fGroupList.Eof do
    begin
        fCombobox.Items.AddObject(fGroupList.FieldByName('name').AsString, TObject( fGroupList.FieldByName('id').AsInteger ));
        fGroupList.Next;
    end;

    if fProjectId <> 0
    then fCombobox.ItemIndex := fCombobox.Items.IndexOf('Участники проекта')
    else fCombobox.ItemIndex := fCombobox.Items.IndexOf('Все пользователи');

    // получаем данные всех пользователей
    fUserList := fDataManager.GetProjectUserList( fWorkgroupId, fProjectId );

    RefreshUserList;

    /// удачное завершение инициализации
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
