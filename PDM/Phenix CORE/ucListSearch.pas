unit ucListSearch;

interface

uses
    VCL.Controls, Types
    ,uListSearch    // включить в пути поиска проекта путь до данного модуля. например:
                    // Y:\DPM Neftrmash\Source\Phenix CORE\VCL ListSearch
    ,Math
    ,VCL.Forms
    ,Vcl.StdCtrls
    ,System.StrUtils
    ;
type

    TListSearch = class

        SelText: string;
        SelData: variant;

        procedure Init(parent: TControl;  SQL: string);
        procedure InitEx(parent: TControl; SQL, DefText: string; DefValue: variant);
        function Execute: boolean;

    private
        Parent: TControl;
        SQL               // готовый sql для полкчения данных из текущей базы
       ,DefText
                : string;

        DefValue : Variant;

        procedure CustomData(value: string);

    end;

implementation

uses
    uPhenixCORE;

{ TListSearch }

procedure TListSearch.CustomData(value: string);
var
    currSQL: string;
begin

    currSQL := ReplaceStr( SQL, '#VALUE#', value );

    /// получаем данные.
    /// подразумевается, что запрос возвращает только два поля
    /// первое - отображается в списке, второе - id соответствующей записи в базе
    if not dmOQ(currSQL) then exit;

    // заполняем массив данных списка, на который будем опираться при построении и фильтрации
    if DefText <> '' then
        fListSearch.addData( DefText, DefValue );

    while not Core.DM.Query.Eof do
    begin
        fListSearch.addData(
            Core.DM.Query.Fields[0].AsString,
            Core.DM.Query.Fields[1].AsString
        );
        Core.DM.Query.Next;
    end;

end;

function TListSearch.Execute: boolean;
begin
    result := false;

    // проверяем инициализацию
    if not Assigned(Parent) or (SQL = '') then exit;

    SelText := '';
    SelData := 0;

    // создаем и инициализируем форму
    if not Assigned( fListSearch ) then
       fListSearch := TfListSearch.Create(nil);

    // очищаем данные предыдущей активации
    fListSearch.ClearUp;

    // располагаем под целевым компонентом
    fListSearch.Width := parent.Width;//max(parent.Width, 300);
    fListSearch.Top := parent.ClientToScreen(Point(0,0)).Y + parent.Height;
    fListSearch.Left := parent.ClientToScreen(Point(0,0)).X;

    if   pos( '#', SQL ) <> 0
    then fListSearch.Callback := CustomData;
    /// метод, вызываемый для обновления данных в списке формы при изменении
    /// строки поиска. будет вызываться, если в запросе есть динамическая составляющая:
    /// переменная в решетках, например #VALUE#.

    if fListSearch.Top + fListSearch.Height > Screen.Height
    then
        fListSearch.Top := parent.ClientToScreen(Point(0,0)).Y - fListSearch.Height;

    /// первоначальное получение данных и заполнение списка
    CustomData( '' );

    // показываем форму и забираем данные, если не было отмены вызова
    if (fListSearch.ShowModal = mrOk) and
       (fListSearch.lbVariants.ItemIndex <> -1) then
    begin
        SelText := fListSearch.lbVariants.Items[fListSearch.lbVariants.ItemIndex];
        SelData := Integer(fListSearch.lbVariants.Items.Objects[fListSearch.lbVariants.ItemIndex]);
        result := true;
    end;

end;

procedure TListSearch.Init(parent: TControl; SQL: string);
begin
    self.Parent := parent;
    self.SQL := SQL;
end;

procedure TListSearch.InitEx(parent: TControl; SQL, DefText: string;
  DefValue: variant);
begin
    Init(parent, SQL);
    self.DefText := DefText;
    self.DefValue := DefValue;
end;

end.
