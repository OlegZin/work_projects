unit uUserList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCallback = function(result: integer): string of object;

  TfUserList = class(TForm)
    Edit1: TEdit;
    ComboBox1: TComboBox;
    listUsers: TListBox;
    procedure FormShow(Sender: TObject);
    procedure listUsersDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure listUsersDblClick(Sender: TObject);
  private
    { Private declarations }
    ProjectId
   ,WorkgroupId
            : integer;
    fCallback : TCallback;
  public
    { Public declarations }
    function SetProjectId( project_id: integer): TfUserList;
    function SetWorkgroupId( workgroup_id: integer): TfUserList;
    function SetCallback( callback: TCallback ): TfUserList;
  end;

var
  fUserList: TfUserList;

implementation

{$R *.dfm}

uses
    uUserListManager, uMain, uPhenixCORE;

var
    mngUserList: TUserListManager;

procedure TfUserList.FormShow(Sender: TObject);
begin
    mngUserList := TUserListManager
        .Create
        .SetKindComponent(ComboBox1)
        .SetFindComponent(Edit1)
        .SetListComponent(listUsers)
        .SetProjectId(ProjectID)
        .SetWorkgroupId(WorkgroupID)
        .SetDataManager(mngData);

    if not mngUserList.Init
    then lW(mngUserList.error);
end;

procedure TfUserList.listUsersDblClick(Sender: TObject);
var
    error: string;
begin

    // если есть обработчик на двойной клик выбора (не примен€€ перетаскивание)
    if Assigned(fCallback) then
    begin
        // передаем обработчику. он возвращает текст ошибки, если что не так
        error := fCallback( Integer(listUsers.Items.Objects[listUsers.ItemIndex]) );

        if error <> ''
        then ShowMessage( error )  // показываем ошибку
        else Close;                // закрываем форму, если все в пор€дке

    end;
end;

procedure TfUserList.listUsersDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

function TfUserList.SetCallback(callback: TCallback): TfUserList;
begin
    result := self;
    fCallback := callback;
end;

function TfUserList.SetProjectId(project_id: integer): TfUserList;
begin
    result := self;
    ProjectId := project_id;
end;

function TfUserList.SetWorkgroupId(workgroup_id: integer): TfUserList;
begin
    result := self;
    WorkgroupId := workgroup_id;
end;

end.
