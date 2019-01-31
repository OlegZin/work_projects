unit uDocCreater;
{ Модуль реализует объект, который формирует универсальный документ в формате HTML.

  Очень поможет в формировании сложных документов с помощю данного модуля знание
  HTML и CSS.

  Формирование производится без подгрузки экземпляра WORD или EXCEL, что
  дает огромную скорость.

  Сформированный файл сохраняется с расширением DOC или XLS, чтобы автоматически
  открываться соответствующей программой.

  Документ строится с нуля из базового шаблона или может быть подгружен из
  внешнего файла.

  Соглашения по формированию шаблона:
    - Поля для подстановки данных маркируются такстом обрамленным символами #.
      Примеры: #Номер#, #zavNom#, #!!!#
    - в шаблоне используются зарезервированные маркеры, которые нельзя замещать
      пользовательскими данными, иначе будет нарушена логика построения
      документа:
          #STYLE#     - маркер подстановки следукющего определяемого стиля
          #CONTENT#   - маркер для добавления следующего элемента
                        (параграфа, таблицы и т.д.)
          #ROW[Name]# - маркер для вставки дополнительной строки в таблицу,
                        где [Name] определяемое пользователем имя таблицы,
                        чтобы можно было раздельно работать с несколькими
                        таблицами в одном документе. может быть пустым.
                        при совпадении имен, строка будет добавляться в несколько
                        таблиц одновременно

  Построение производится сверху-вниз. Каждый новый элемент подставляется вместо
  маркера #CONTENT#, а сам маркер после вставки сдвигается в конец документа.
  Для добавления элементов выше маркера #CONTENT# пользователь может вставлять
  собственные маркеры и обращаться к ним при вставке элементов.

  Применение шаблонов и маркеров позволяет как формировать документ небольшими
  изменениями/подстановками в готовом шаблоне любой конфигурации, так и строить
  документ с нуля.

  Алгоритм формирования документа методамми объекта:
  1. Инициализация шаблона
      TDocCreater.Template.LoadFromFile
              подгрузка готового шаблона из файла
      TDocCreater.Template.InitPortrait
              инициализация пустого шаблона портретной ориентации (выбирается
              по умолчанию, если не будет инициализации до первого добавления
              элемента или подстановки значения)
      TDocCreater.Template.InitLandscape
              инициализация пустого шаблона альбомной ориентации (сработает
              только для WORD)
      TDocCreater.Template.InitCustom
              инициализация пустого шаблона с пользовательскими размерами листа

  3. Установка стилей и колонититулов
      TDocCreater.SetBaseStyle
              добавляет в стили документа базовый набор правил для параграфов и таблиц
      TDocCreater.SetStyle
              добавляет в стили документа новый стиль
      TDocCreater.Colontitul.WordLoadFromFile
              установка из файла колонтитулов, видимых при открытии документа в WORD
      TDocCreater.Colontitul.WordHeaderHTML
      TDocCreater.Colontitul.WordFooterHTML
              ручная установка колонтитулов, видимых при открытии документа в WORD
      TDocCreater.Colontitul.ExcelHeader
      TDocCreater.Colontitul.ExcelFooter
              установка колонтитулов, видимых при открытии документа в EXCEL

  4. Добавление элементов
      TDocCreater.AddParagraph
              добавление текстового раздела <p></p>
      TDocCreater.AddTable
              добавление таблицы <table></table>
      TDocCreater.AddRow
              добавляет строку в указанную таблицу <tr>...</tr>
      TDocCreater.AddImage
              добавление картинки <img />. Для корректности требуется, чтобы
              файл картинки находился в общедоступной папке. в сам документ
              изображение не включается.

  5. Получение готового документа
      TDocCreater.Template.HTML
              получение HTML шаблона в виде строки (текущего состояния)
      TDocCreater.SaveToFile
              сохренение как файла с любым удобным расширением.
      TDocCreater.SaveToExcelFile
              сохренение как файла в реальном формате excel.
      TDocCreater.OpenFile
              открывает указанный файл, ранее сохраненный методом
              TDocCreater.SaveToFile, приложением, привязанным к расширению файла




==  ПРИМЕР ФОРМИРОВАНИЯ ФАЙЛА С НУЛЯ   =========================================

   dc := TDocCreater.Create;

   // без явной инициализации при первом добавлении любого элемента или
   // базовых стилей, документ инициализируется в книжной ориентации базовым
   // шаблоном.
   // на основе шаблона TEMPLATE_HTML можно зарнее сформировать некий
   // персональный шаблон, в который нужно будет только добавить данные, не
   // отвлекаясь на создание оформления

   // в шаблоне отсутсвуют какие-либо стили, чтобы была возможность определить
   // любые, не боясь пересечся с определенными в шаблоне.
   // метод позволяет включить в шаблон набор стандартных настроек, подходящих
   // для всех простых табличных документов
   dc.SetBaseStyle;

   // дополнительные тэги допустимы
   dc.AddParagraph('<b>БЛАНК-01</b>', 'align=right');
   dc.AddParagraph('Заголовок', 'align=center style="font-size:12.0pt;"');
   dc.AddParagraph('Подзаголовок', 'align=center');
   // обычный блок текста с выравниванием по левому краю
   dc.AddParagraph('Простой параграф');

   // добавляем первую таблицу с двумя строками
   // в одну из ячеек закладывается метка, которую можно заполить позднее
   dc.AddTable('', 'align=center', ['10#!#', '20', '30'], ['width=50', 'width=100', 'width=150']);
   dc.AddRow('', ['110', '220', '330']);

   // возможно добавления читого HTML в текущую позицию в документе (например,
   // заранее сформированный документ, без применения методов TDocCreater)
   dc.AddHTML('<br>');

   // добавляем вторую таблицу с двумя строками
   dc.AddTable('2', 'align=center', ['А', 'Б', 'В'], ['width=150', 'width=100', 'width=50']);
   dc.AddRow('2', ['АБ', 'БВ', 'ВГ']);

   // в любой момент можно дополнить любую таблицу

   // добавляем три строки в первую таблицу
   dc.AddRow('', ['1110', '2220', '3330']);
   // применяем объединение строк. в данном случае простая ячейка и еще одна на 2 колонки
   dc.AddRow('', ['1110', '1111'], ['', 'colspan="2"']);
   // добавления раздела в таблицу (строка с объединением всех ячеек
   // добавляем только одну ячкйку и растягиваем на всю ширину таблицы
   // в данном случае на 3 колонки
   dc.AddRow('', ['1110'], ['colspan="3"']);

   // подставляем значение в пользовательский маркер в первой строки первой таблицы
   dc.SetValue('!', 'замена');

   // добавляем верхний колонтитул в виде таблицы, который будет виден только при
   // открытии файла вордом
   dc.SetWordHeader(
        '<table>'+
          '<tr>'+
            '<td>Номер</td>'+
            '<td>название</td>'+
            '<td>количество</td>'+
          '</tr>'+
          '<tr>'+
            '<td>1</td>'+
            '<td>что-то</td>'+
            '<td>сколько-то</td>'+
          '</tr>'+
        '</table>'
   );

   // добавляем колонтитулы видимые в excel. у него колонтитул только текстовый
   // и разделен на три части: левый, центральный, правый.
   // &P - стандартный макрос excel, отображающий номерацию страниц
   dc.SetExcelHeader('&P','','Header &P');
   dc.SetExcelFooter('Footer','','');

   // сохраняем файл с расширением DOC. с таким же успехом можно сохранить как XLS или HTML
   dc.SaveToFile( dm.TempDir + 'test.doc' );

   // открываем ранее сохраненный файл приложением, привязанным в системе к этому расширению
   dc.OpenFile( dm.TempDir + 'test.doc' );



==  ПРИМЕР ФОРМИРОВАНИЯ ФАЙЛА ИЗ ШАБЛОНА =======================================

    ШАБЛОН ('SoprDocReestr1.doc'):

        <html>
        <head>
        <meta http-equiv=Content-Type content="text/html; charset=windows-1251">
        <style>
          body { font-family:"Times New Roman",serif; font-size: 10.0pt;    [закрывающая фигурная скобка]
          p { margin:0cm;                                                   [закрывающая фигурная скобка]
          table{ border-collapse:collapse; border:none; text-align: center; [закрывающая фигурная скобка]
          td{ border:solid windowtext 1.0pt;                                [закрывающая фигурная скобка]
          @page page {size:595.3pt 841.9pt; margin:1.0cm 1.0cm 1.0cm 1.0cm; [закрывающая фигурная скобка]
          div.page {page:page;                                              [закрывающая фигурная скобка]
        </style>
        </head>
        <body lang=RU>
        <div class=page>

        <p align=right style='font-size:12.0pt;'><b>Ф-02 СТП НМ 37</b></p>
        <p align=center><b>Реестр сопроводительной документации</b></p>
        <p align=center><b>#наим.#</span></b></p>
        <p align=center><b>Зав. №#зн.#</b></p>
        <table>
         <tr>
          <td width=40><p><b>№ п/п</b></p></td>
          <td width=258><p><b>Наименование и обозначение оборудования по паспорту</b></p></td>
          <td width=260><p><b>Комплектность</b></p></td>
          <td width=47><p><b>Кол. экз., шт.</b></p></td>
          <td width=102><p><b>Зав. №</b></p></td>
         </tr>
         #Row#
        </table>
        <br>
        <p>Составил:#исп.#</p>
        <p>Дата:#дт.#</p>

        </div>
        </body>
        </html>

  КОД:
        count:=1;

        dc := TDocCreater.Create;
        dc.Template.LoadFromFile( dm.VPTemplates+'SoprDocReestr1.doc' );
        dc.SetValue('наим.', IzdNaim);
        dc.SetValue('зн.', IzdCurRec^.ZavNom);
        dc.SetValue('исп.', pass.seq.UserName);
        dc.SetValue('дт.', datetostr(dm.Today)+'г.');

        while not dataset.Eof do
        begin

            if (dataset.Fields[1].Value='') and
               (dataset.Fields[2].Value='') and
               (dataset.Fields[3].Value='')
            then
                dc.AddRow('', [dataset.Fields[0].Value], ['colspan="5" style="background-color: #ddd;"'] )
            else
            begin
                dc.AddRow('',
                          [ IntToStr(count)+'.', dataset.Fields[0].Value,
                            dataset.Fields[1].Value, dataset.Fields[2].Value,
                            dataset.Fields[3].Value
                          ],
                          [ 'width=40', 'width=260', 'width=260', 'width=50', 'width=100' ]
                );
                Inc(count);
            end;

            dataset.MoveNext;
        end;
        dc.SaveToFile( dm.TempDir + 'РеестрСопрДок '+IzdNaim+'.doc' );
        dc.OpenFile( dm.TempDir + 'РеестрСопрДок '+IzdNaim+'.doc' );




==  ПОЛУЧЕНИЕ HTML ШАБЛОНОВ ДОКУМЕНТА И КОЛОНТИТУЛОВ ИЗ ГОТОВОГО WORD-ФАЙЛА =========

  1. Рисуется word документ со всеми колонтитулами и шаблоном, или берется готовый
  2. Документ сохраняется в формате "web-страница".
     Сохраняется основной htm-файл - шаблон документа, а в сопутствующей папке
     header.hml - колонтитулы
  3. Перед использованием требуется немного доработать файлы.
     В основном файле (открыть в блокноте):
        а) найти и удалить фрагмент:

          @page
            {mso-footnote-separator:url("...files/header.htm") fs;
             mso-footnote-continuation-separator:url("...files/header.htm") fcs;
             mso-endnote-separator:url("...files/header.htm") es;
             mso-endnote-continuation-separator:url("...files/header.htm") ecs;

          найти фрагмент:

          @page WordSection1
            {size:841.9pt 595.3pt;
             mso-page-orientation:landscape;
             margin:1.0cm 1.0cm 1.0cm 1.0cm;
             mso-header-margin:35.4pt;
             mso-footer-margin:35.4pt;
             mso-header:url("...files/header.htm") h1;
             mso-footer:url("...files/header.htm") f1;
             mso-paper-source:0;..

           удалить строчки с правилами
             mso-header:url("...files/header.htm") h1;
             mso-footer:url("...files/header.htm") f1;

           при работе модуля они будут добавлены автоматически с правильными путями

        б) найти закрывающий тэг </style> и добавить перед ним маркер #STYLE#,
           в это место будут подставляться добавляемые в шаблон стили

        в) если в шаблоне есть таблицы, найти для каждой закрывающий тэг
           </table> и вставить перед ним маркер #ROW#.
           если в наличии несколько таблиц, следует сделать маркеры уникальными
           добавлением дополнительных символов, например:
           #ROW#, #ROWA#, #ROW_#, #ROW111#
           в данном примере для добавления строки в нужную таблицу, ее имя
           (первый параметр метода AddRow) будет, соответственно:
           '', 'А', '_', '111'

        г) если в шаблоне есть пользовательские маркеры для вставки одиночных
           значений на русском, например #номер#, #бригада# и т.п.
           следует найти каждый маркер и подчистить разметку, поскольку ворд
           разделяет английские и русские символы и модуль не найдет такой маркер

           например, текст: '#marker#, #маркер#'
           при сохранении превращается в:
           <p class=MsoNormal><span lang=EN-US style='mso-ansi-language:EN-US'>#marker#, #</span>маркер<span
           lang=EN-US style='mso-ansi-language:EN-US'>#<o:p></o:p></span></p>

           и следует привести его к виду:
           <p class=MsoNormal><span lang=EN-US style='mso-ansi-language:EN-US'>#marker#, #маркер#</span></p>
           или
           <p class=MsoNormal>#marker#, #маркер#</p>

     В файле колонтитулов(открыть в блокноте): провести операции б), в), г)

  4. положить оба файла в папку с шаблонами программы.

  5. использовать в программе при построении отчета:

     dc.Template.LoadFromFile( dm.VPTemplates + 'lzk.htm' );
     dc.Colontitul.WordLoadFromFile( dm.VPTemplates + 'lzk_h.htm' );




==  УСТРАНЕНИЕ СООБЩЕНИЯ О НЕСООТВЕТСТВИИ СОДЕРЖИМОГО ФАЙЛА В EXCEL  ===========

   1. Создать файл excel
   2. Создать в нем и выполнить макрос:

   Sub Auto_Open()
   CreateObject("WScript.Shell").RegWrite "HKCU\Software\Microsoft\Office\" _
            & Val(Application.Version) & ".0" _
            & "\Excel\Security\ExtensionHardening", 0, "REG_DWORD"
   End Sub

   3. закрыть файл без сохранения.

   Макрос устанавливает глобальный флаг = 0 в реестре на игнор несоответствия
   структуры файла расширению. Больше оно не будет появляться.
   Флаг по умолчанию: 1 (открытие с предупреждением).
   Еще одно возможное значение: 2 (блокировка открытия)
}

interface

uses
    StrUtils, SysUtils, Classes, ShellApi, Windows, ComObj, Variants;

const

    QUOTE = '#';

    MARKER_CONTENT     = QUOTE+'CONTENT'+QUOTE;
    MARKER_STYLE       = QUOTE+'STYLE'+QUOTE;
    MARKER_ORIENTATION = QUOTE+'ORIENTATION'+QUOTE;
    MARKER_ROW         = QUOTE+'ROW'+QUOTE;

    // стандартный набор базовых стилей, который можно добавить в файл методом SetBaseStyle
    TEMPLATE_BASE_STYLE =
        'body{font-family:"Times New Roman",serif; font-size: 10.0pt;}'+
        'p{margin:0cm;}'+
        'table{border-collapse:collapse; border:none; text-align: center;}'+
        'td{border:solid windowtext 0.1pt;}';


    // колонтитулы для EXCEL.
    // колонитиул делмится на левый, центральный и правый. и поддерживает
    // только строки и спецсимволы, например &P - номер текущей страницы.
    // докумет может содержать колонтитулы и для WORD и для EXCEL одновременно
    // не подходящие будут проигнорированы программой при открытии.

    // добавляется в раздел стилей методом Colontitul.ExcelHeader
    TEMPLATE_EXCEL_HEADER =
        '@page{mso-header-data:"&L%s&C%s&R%s";}';
    // добавляется в раздел стилей методом Colontitul.ExcelFooter
    TEMPLATE_EXCEL_FOOTER =
        '@page{mso-footer-data:"&L%s&C%s&R%s";}';


    // колонтитулы для WORD. задается полный путь до файла, иначе будет выскакивать
    // сообщение об ошибке при открытии файла (например: c:/1/header.htm)
    // по технологии, они хранятся в отдельном файле вида как в TEMPLATE_WORD_COLONTITUL_HTML
    // что позволяет добавлять в них таблицы и прочие элементы.
    // докумет может содержать колонтитулы и для WORD и для EXCEL одновременно
    // не подходящие будут проигнорированы программой при открытии

    // добавляется в раздел стилей методом Colontitul.WordHeaderHTML
    TEMPLATE_WORD_HEADER =
        '@page WordSection1 { mso-header:url("%s") h1;}';
    // добавляется в раздел стилей методом Colontitul.WordFooterHTML
    TEMPLATE_WORD_FOOTER =
        '@page WordSection1 { mso-footer:url("%s") f1;}';

    // базовый шаблон для документа
    TEMPLATE_HTML =
        '<html>'+
        ' <head>'+
        ' <meta http-equiv=Content-Type content="text/html; charset=windows-1251">'+
        ' <style>'+
        '  @page WordSection1 {#ORIENTATION# margin:1.0cm 1.0cm 1.0cm 1.0cm; }'+
        '  div.page   {page:page;}'+
        '  #STYLE#'+
        ' </style>'+
        ' </head>'+
        ' <body lang=RU>'+
        '  <div class=WordSection1>'+
        '   #CONTENT#'+
        '  </div>'+
        ' </body>'+
        '</html>';

    // шаблон дополнительного файла для колонтитулов WORD.
    // внесение элементов mso-element:header / mso-element:footer в основной
    // файл дает неустранимый эффект, когда текст колонтитула дублируется в
    // тексте самого документа
    TEMPLATE_WORD_COLONTITUL_HTML =
        '<html>'+
        '<head>'+
        '<meta http-equiv=Content-Type content="text/html; charset=windows-125=1">'+
        '</head>'+
        ' <body lang=RU>'+
        '  <div style="mso-element:header" id=h1>%s</div>'+
        '  <div style="mso-element:footer" id=f1>%s</div>'+
        ' </body>'+
        '</html>';

    ORI_PORTRAIT  = 'size:595.3pt 841.9pt;';
    ORI_LANDSCAPE = 'size:841.9pt 595.3pt;';
    ORI_CUSTOM    = 'size:%dpt %dpt;';

    TEMPLATE_PARAGRAPH  = '<p %s>%s</p>';
    TEMPLATE_TABLE      = '<table %s><tr>%s</tr>#ROW%s#</table>';
    TEMPLATE_ROW        = '<tr %s>%s</tr>';
    TEMPLATE_SECTIONROW = '<tr %s><td colspan="%s">%s</td></tr>';
    TEMPLATE_CELL       = '<td %s>%s</td>';


type
   TArray = array of string;

   TDocCreater = class;

   TColontitul = class
       parent: TDocCreater;    // ссылка на родительский объект для возможности
                               // использования его методов

       WordHeaderHTML          // текст (html) верхнего колонтитула при открытии в WORD
      ,WordFooterHTML          // текст (html) нижнего колонтитула при открытии в WORD
      ,WordFullHTML            // текст колонтитула, загруженного из файла с обеими колонтитулами
                               // образец в TEMPLATE_WORD_COLONTITUL_HTML
               : string;

       procedure WordLoadFromFile(filename: string);
                               // загрузка шаблона колонтитулов ворда из ворда в WordFullHTML

       procedure ExcelHeader(left, center, right: string);
       procedure ExcelFooter(left, center, right: string);
   end;

   TTemplate = class
   public
       html: string;

       function LoadFromFile(FileName: string): boolean;
                               // загрузка шаблона документа из файла
       procedure InitPortrait;
       procedure InitLandscape;
       procedure InitCustom(HTML: string; Height, Width: integer);
   end;

   TDocCreater = class
   private
       tables: TStringList;


       procedure InsToMarker(marker, value: string);
                               // запись в шаблон значения/текста по месту нахождения
                               // маркера, без его затирания. используется для добавления
                               // элементов в по маркерам #STYLE#, #CONTENT#, #ROW#

       procedure ClearMarks;   // удаление всех служебных маркеров перед
                               // соранением в файл

   public
       Template: TTemplate;
       Colontitul: TColontitul;

       constructor Create;
       destructor Destroy;

       function SetBaseStyle: boolean;
       function SetStyle(style: string): boolean;
       function SetValue(Marker, Value: string): boolean;
       function AddParagraph(Text: string; Style: string = ''): boolean;
       function AddTable(TableName, Style: string; Values: TArray; Styles: TArray = nil): boolean;
       function AddRow(TableName: string; Values: TArray; Styles: TArray = nil): boolean;
       function AddHTML(html: string): boolean;
       function SaveToFile(FileName: string): boolean;
       function SaveToExcelFile(_FileName: string): boolean;
       procedure OpenFile(FileName: string);
//       function AddImage
   end;

implementation


{ TDocCreater }

function TDocCreater.SetBaseStyle: boolean;
begin
    if Template.html = '' then Template.InitPortrait;

    InsToMarker( MARKER_STYLE, TEMPLATE_BASE_STYLE );
end;

function TDocCreater.SetStyle(style: string): boolean;
begin
    if Template.html = '' then Template.InitPortrait;

    InsToMarker( MARKER_STYLE, Style );
end;

function TDocCreater.SetValue(Marker, Value: string): boolean;
begin
    if Template.html = '' then Template.InitPortrait;

    Template.html := ReplaceStr( Template.html, QUOTE + Marker + QUOTE, Value );
    Colontitul.WordFullHTML := ReplaceStr( Colontitul.WordFullHTML, QUOTE + Marker + QUOTE, Value );
    Colontitul.WordHeaderHTML := ReplaceStr( Colontitul.WordHeaderHTML, QUOTE + Marker + QUOTE, Value );
    Colontitul.WordFooterHTML := ReplaceStr( Colontitul.WordFooterHTML, QUOTE + Marker + QUOTE, Value );
end;

function TDocCreater.AddHTML(html: string): boolean;
begin
    if Template.html = '' then Template.InitPortrait;

    InsToMarker( MARKER_CONTENT, HTML )
end;

function TDocCreater.AddParagraph(Text, Style: string): boolean;
begin
    if Template.html = '' then Template.InitPortrait;

    InsToMarker( MARKER_CONTENT, Format( TEMPLATE_PARAGRAPH, [ Style, Text ]));
end;

function TDocCreater.AddTable(TableName, Style: string; Values: TArray; Styles: TArray = nil): boolean;
var
   cells, cell_style: string;
   i : integer;
begin
    if Length(Values) = 0 then exit;

    tables.Add(TableName);

    if Template.html = '' then Template.InitPortrait;

    for I := 0 to High(Values) do
    begin
        cell_style := '';
        if Assigned(Styles) then
        if i <= High(Styles) then cell_style := Styles[i];

        cells := cells + Format( TEMPLATE_CELL, [ cell_style, Values[i] ]);
    end;

    InsToMarker( MARKER_CONTENT, Format( TEMPLATE_TABLE, [ Style, cells, TableName ] ));

end;

function TDocCreater.AddRow(TableName: string; Values, Styles: TArray): boolean;
var
    cells, marker, style: string;
    i : integer;
begin

    if Length(Values) = 0 then exit;

    marker := QUOTE + 'ROW' + TableName + QUOTE;

    for I := 0 to High(Values) do
    begin

        style := '';
        if Assigned(Styles) then
        if i <= High(Styles) then style := Styles[i];

        cells := cells + Format( TEMPLATE_CELL, [ style, Values[i] ]);
    end;

    InsToMarker( marker, Format( TEMPLATE_ROW, [style, cells] ));

end;

function TDocCreater.SaveToExcelFile(_FileName: string): boolean;
var
    E: OleVariant;
begin

    SaveToFile(_FileName);

    try

        E := CreateOleObject('Excel.Application');

        if Vartype(E)=VarDispatch then
        begin
            E.WorkBooks.Open( _FileName );
            E.ActiveWorkBook.SaveAs( Filename := _Filename, FileFormat := 56 {Книга Excel 97-2003} );
                // значения форматов: https://docs.microsoft.com/ru-ru/office/vba/api/excel.xlfileformat
        end;

    finally

        e.Quit;
        e := Unassigned;

    end;

end;

function TDocCreater.SaveToFile(FileName: string): boolean;
var
    sl: TStringList;
    word_header_file: string;
begin
    result := false;

    if Trim(FileName) = '' then exit;

    sl := TStringList.Create;
    word_header_file := ExtractFilePath( FileName ) + '_' + ExtractFileName( FileName );
    word_header_file := ReplaceStr( word_header_file, '\', '/' );



    // если заданы колонтитулы ворда, добавляем ccылки и создаем сопутсвующий файл
    if ( Colontitul.WordHeaderHTML <> '' ) or ( Colontitul.WordFullHTML <> '' ) then
        InsToMarker( MARKER_STYLE, Format( TEMPLATE_WORD_HEADER, [word_header_file] ));

    if ( Colontitul.WordFooterHTML <> '' ) or ( Colontitul.WordFullHTML <> '' ) then
        InsToMarker( MARKER_STYLE, Format( TEMPLATE_WORD_FOOTER, [word_header_file] ));

    if (( Colontitul.WordHeaderHTML <> '' ) or ( Colontitul.WordFooterHTML <> '')) and ( Colontitul.WordFullHTML = '' ) then
    begin
        sl.Text := Format( TEMPLATE_WORD_COLONTITUL_HTML, [Colontitul.WordHeaderHTML, Colontitul.WordFooterHTML] );
        sl.SaveToFile(word_header_file);
    end;

    if ( Colontitul.WordFullHTML <> '' ) then
    begin
        sl.text := Colontitul.WordFullHTML;
        sl.SaveToFile(word_header_file);
    end;



    // чистим файл от системных меток
    ClearMarks;

    try
        sl.Text := Template.html;
        sl.SaveToFile(FileName);
        result := true;
    finally
        if Assigned(sl) then sl.Free;
    end;

end;

procedure TDocCreater.ClearMarks;
var
    i: integer;
begin
    Template.html := ReplaceStr( Template.html, MARKER_CONTENT, '' );
    Template.html := ReplaceStr( Template.html, MARKER_STYLE, '' );
    Template.html := ReplaceStr( Template.html, MARKER_ROW, '' );

    // чистим метки строк всех имеющихся в документе таблиц
    for I := 0 to tables.Count -1 do
        Template.html := ReplaceStr( Template.html, QUOTE+'Row'+tables[i]+QUOTE, '' );

    tables.Clear;
end;

procedure TDocCreater.InsToMarker(marker, value: string);
begin
    Template.html := ReplaceStr( Template.html, marker, value + marker );
end;

constructor TDocCreater.Create;
begin
    Inherited;
    Template := TTemplate.Create;
    Colontitul := TColontitul.Create;
    Colontitul.parent := self;
    tables := TStringList.Create;
end;

destructor TDocCreater.Destroy;
begin
    tables.Free;
    Colontitul.Free;
    Template.Free;
    Inherited;
end;

procedure TDocCreater.OpenFile(FileName: string);
begin
    ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
end;

{ TTemplate }

procedure TTemplate.InitCustom(HTML: string; Height, Width: integer);
begin
    if (Height <= 0) or (Width <= 0) then exit;

    html := ifthen(TRIM(HTML) = '', TEMPLATE_HTML, HTML);
    html := ReplaceStr( html, MARKER_ORIENTATION, Format( ORI_CUSTOM, [Width, Height]));
end;

procedure TTemplate.InitLandscape;
begin
    html := TEMPLATE_HTML;
    html := ReplaceStr( html, MARKER_ORIENTATION, ORI_LANDSCAPE );
end;

procedure TTemplate.InitPortrait;
begin
    html := TEMPLATE_HTML;
    html := ReplaceStr( html, MARKER_ORIENTATION, ORI_PORTRAIT );
end;

function TTemplate.LoadFromFile(FileName: string): boolean;
var
   sl: TStringList;
begin
    result := false;

    if ( Trim(FileName) = '' ) or
       not FileExists(FileName) then exit;

   try
       try
           sl := TStringList.Create;
           sl.LoadFromFile(FileName);

           html := sl.Text;
           result := true;
       finally
           sl.Free
       end;
   except
   end;

end;

{ TColontitul }

procedure TColontitul.WordLoadFromFile(filename: string);
var
    sl: TStringList;
begin
    if not FileExists( filename ) then exit;

    sl := TStringList.Create;
    sl.LoadFromFile( filename );

    WordFullHTML := sl.Text;

    sl.Free;
end;

procedure TColontitul.ExcelFooter(left, center, right: string);
begin
    parent.InsToMarker( MARKER_STYLE, Format( TEMPLATE_EXCEL_FOOTER, [left, center, right] ));
end;

procedure TColontitul.ExcelHeader(left, center, right: string);
begin
    parent.InsToMarker( MARKER_STYLE, Format( TEMPLATE_EXCEL_HEADER, [left, center, right] ));
end;


end.
