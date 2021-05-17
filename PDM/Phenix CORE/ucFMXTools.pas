unit ucFMXTools;


interface

uses uPhenixCORE, FMX.Forms, SysUtils;

    Function SaveForm(form: TForm): boolean;
    Function RestoreForm(form: TForm): boolean;

implementation

Function SaveForm(form: TForm): boolean;
begin
    Core.Log.Comment('uIniStore.SaveForm');
    Core.Log.Mess('Сохраняем параметры формы ' + form.Name);

    if Core.Settings.TableName = '' then
    begin
        Core.Log.Error('Не указано имя таблицы настроек');
        Core.Log.CommentExit;
        exit;
    end;

    try
        Core.Settings.SaveValue( form.Name, 'Left',   IntToStr(form.Left) );
        Core.Settings.SaveValue( form.Name, 'Top',    IntToStr(form.Top) );
        Core.Settings.SaveValue( form.Name, 'Width',  IntToStr(form.Width) );
        Core.Settings.SaveValue( form.Name, 'Height', IntToStr(form.Height) );
    except
        on E:Exception do
        begin
            Core.Log.Error(E.Message);
            Core.Log.CommentExit;
        end;

    end;

    Core.Log.CommentExit;
end;

Function RestoreForm(form: TForm): boolean;
begin
    Core.Log.Comment('uIniStore.RestoreForm');
    Core.Log.Mess('Загружаем параметры формы ' + form.Name);

    if Core.Settings.TableName = '' then
    begin
        Core.Log.Error('Не указано имя таблицы настроек');
        Core.Log.CommentExit;
        exit;
    end;

    try
        form.Left   := Core.Settings.LoadValue( form.name, 'Left',   form.Left );
        form.Top    := Core.Settings.LoadValue( form.name, 'Top',    form.Top );
        form.Width  := Core.Settings.LoadValue( form.name, 'Width',  form.Width );
        form.Height := Core.Settings.LoadValue( form.name, 'Height', form.Height );
    except
        on E:Exception do
        begin
            Core.Log.Error(E.Message);
            Core.Log.CommentExit;
        end;

    end;

    form.BringToFront;

    Core.Log.CommentExit;
end;


end.
