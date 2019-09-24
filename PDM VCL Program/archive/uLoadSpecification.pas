unit uLoadSpecification;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ksTLB, ActiveX, ComObj, LDefin2D, StrUtils, Math, RegularExpressions, ksConstTLB,
  Vcl.ExtCtrls, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, MemTableDataEh, Data.DB,
  MemTableEh, System.ImageList, Vcl.ImgList, Vcl.Menus;

type
  TfLoadSpecification = class(TForm)
    eFilename: TEdit;
    Button1: TButton;
    odSecification: TOpenDialog;
    mLog: TMemo;
    Panel1: TPanel;
    Button2: TButton;
    grdSpecification: TDBGridEh;
    mem: TMemTableEh;
    DataSource: TDataSource;
    ImageList1: TImageList;
    Panel2: TPanel;
    Splitter1: TSplitter;
    popMark: TPopupMenu;
    N1: TMenuItem;
    bUploadToPDM: TButton;
    checkScanSubdir: TCheckBox;
    bRefresh: TButton;
    bCollapse: TButton;
    bExpand: TButton;
    odFile: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SetLoadState(state: integer);
    procedure FormCreate(Sender: TObject);
    procedure memBeforePost(DataSet: TDataSet);
    procedure grdSpecificationColumns0CellButtons0Down(Sender: TObject;
      TopButton: Boolean; var AutoRepeat, Handled: Boolean);
    procedure bUploadToPDMClick(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure bCollapseClick(Sender: TObject);
    procedure bExpandClick(Sender: TObject);
    procedure grdSpecificationFileFieldButtonsClick(Sender: TObject;
      var Handled: Boolean);
    procedure grdSpecificationDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdSpecificationDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure grdSpecificationColumns6CellButtons0GetEnabledState(
      Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
      var ButtonEnabled: Boolean);
    procedure grdSpecificationColumns6CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure grdSpecificationColumns9CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure grdSpecificationColumns9CellButtons0GetEnabledState(
      Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
      var ButtonEnabled: Boolean);
  private
    { Private declarations }

    fLoadState: integer;
    ///    текущее состояние загрузки спецификации.
    ///    константы группы

    procedure ReadKompassFile( filename: string );
    procedure ScanDirectory( path: string );
    function CreateTree(startIndex: integer = 0): boolean;

    procedure ToLog(text: string);
    procedure ClearLog;
    function GetFromNearFile(mark: string; field: integer): string;

  public
    { Public declarations }
    property LoadState: integer read fLoadState write SetLoadState;

  end;

    // значение полей определяется константаим BUFF_ХХХ
    TNearFile = array [0..5] of string;

var
  fLoadSpecification: TfLoadSpecification;

    dndMode
    ///    режим переноса данных из справочника в загруженную спецификацию
    ///    позволяет в событии завершения перетаскивания не делать повторных
    ///    проверок, что и для чего перетаскивается, а стразу выполнить
    ///    необходимую операцию
            : integer;

        NearFiles: array of TNearFile;
        // массив данных о находящихся в текущей папке файлах компас.
        // перед открытием спецификации опрашивается папка и через открытие в компасе каждого
        // найденного файла получается его основная информация: наименование, обозначение, масса, материал
        // в дальнейшем этот массив используется для быстрой привязки файлов к элементам
        // загружаемой спецификации с применением точной ссылки через обозначение,
        // а не наименование файла, что очень ненадежно ил-за частых искажений.

implementation

{$R *.dfm}

uses uMain, uConstants, uObjectCatalog, uPhenixCORE, uDataManager, uKompasFileManager;

const
    NEAR_KIND     = 0;
    NEAR_MARK     = 1;
    NEAR_NAME     = 2;
    NEAR_MATERIAL = 3;
    NEAR_MASS     = 4;
    NEAR_FILENAME = 5;

procedure TfLoadSpecification.ReadKompassFile(filename: string);
{ открываем файл компаса ком-объектом и пытаемся получить список путей
  всех вложенных файлов }
var
    item                  // рабочий элемент массива SpecDataArray
   ,fromIndex             // позиция в рабочем массиве с коророй добавлять данные
                          // в таблицу с деревом спецификации
   ,hi
            : integer;
begin
    ToLog('Загрузка КОМПАС...');
    LoadState := STATE_LOADING;

    if not mngKompas.StartKompas(true) then exit;

    // сканируем папку и подпапки на файлы спецификаций и чертежей
    ScanDirectory( ExtractFilePath( filename ));

    // загружаем данные из основной спецификации в рабочий массив
    mngKompas.ReadSpecificationToArray( filename );

    // по полученным данным создаем рабочую версию дерева
    CreateTree;

    // перебираем массив и ищем вложенные спецификации
    // обнаруженные читаем и добавляем в конец массива. таким образом обеспечивается
    // полное прохождение всех элементов дерева на всех уровнях. однако,
    // нет оптимизации на чтение одинаковых спецификаций для разных исполнений
    // что приводит к повторным чтениям для разных веток дерева
{
    item := 1;
    hi := High( SpecDataArray );
    while ( item <= hi ) do
    begin
        if   SpecDataArray[item][FIELD_SPEC_FILE] <> '' then
        begin
            fromIndex := High( SpecDataArray );
            OpenDocument( SpecDataArray[item][FIELD_SPEC_FILE], SpecDataArray[item][FIELD_CHILD] );
            CreateTree( fromIndex + 1 );
        end;
        inc( item );
        hi := High( SpecDataArray )
    end;
}
    // по завершении построения дерева пихаем в чат короткую инструкцию по работе
    ToLog('');
    ToLog('Загрузка завершена!');
    ToLog('');
    ToLog('- Удостоверьтесь в правильности загруженных данных и нажмите "Загрузить в PDM" для внесения данных в базу.');
    ToLog('- Строки с жёлтым значком отсутствуют в базе и будут созданы при загрузке спецификации. '+
            'Воизбежание дублирования данных, следует убедиться, что обозначения указаны верно. В противном случае их можно подправить вручную прямо в таблице и программа перепроверит наличие в базе.');
    ToLog('- Указанные файлы в одноименной колонке будут автоматически привязаны к новым объектам в базе. Для уже существующих будут проигнорированы.');
    ToLog('- Убедитесь, что для сборочных единиц выбраны правильные файлы спецификации. Через меню в колонке "Спецификация" можно выбрать другой файл и состав будет обновлен.');

    mngKompas.StopKompas;

    LoadState := STATE_LOADED;
end;

procedure TfLoadSpecification.ScanDirectory(path: string);
///    метод сканирует все файлы в указанной папке, находит спецификации и
///    чертежи. открывает их в компасе и заполняет глобальный массив аттрибутов.
///    данный массив будет применяться при загрузке спецификации для быстрой
///    идентификации нужного файла в папке по обозначению рассматриваемого элемента
///    спецификации. часто обозначение содержится в имени файла, но для надежности
///    лучше ориентироваться исключительно на внутренние атрибуты компас-файла
var
    SR: TSearchRec; // поисковая переменная
    StampData: TStampData;
    fileKind
            : string;
begin

    if FindFirst( path + '*.*', faAnyFile, SR ) = 0 then
    repeat
        fileKind := '';

        // сканируем подпапки, если установлена опция
        if   checkScanSubdir.Checked and ((SR.Attr and faDirectory) <> 0) and ( SR.Name <> '.' ) and ( SR.Name <> '..' )
        then ScanDirectory( path + SR.Name + '\' );

        // обращаем внимание только на спецификации и чертежи
        if    ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.SPW' )
        then
        begin
            StampData := mngKompas.GetSpecificationStampData(path + SR.Name);
            fileKind := 'SPEC';
        end;

        if    ( AnsiUpperCase(ExtractFileExt( SR.Name )) = '.CDW' )
        then
        begin
            StampData := mngKompas.GetDocument2DStampData(path + SR.Name);
            fileKind := 'DRAW';
        end;

        if fileKind <> '' then
        begin

            // добавляем данные по файлу в массив
            SetLength( NearFiles, Length(NearFiles)+1);
            NearFiles[high(NearFiles)][ NEAR_KIND ]     := fileKind;
            NearFiles[high(NearFiles)][ NEAR_MARK ]     := StampData.Mark;
            NearFiles[high(NearFiles)][ NEAR_NAME ]     := StampData.Name;
            NearFiles[high(NearFiles)][ NEAR_MATERIAL ] := StampData.Material;
            NearFiles[high(NearFiles)][ NEAR_MASS ]     := StampData.Mass;
            NearFiles[high(NearFiles)][ NEAR_FILENAME ] := path + SR.Name;

            ToLog( 'Анализ файла: ' + SR.Name );

        end;

    until FindNext( SR ) <> 0;

    FindClose(SR);
end;


procedure TfLoadSpecification.Button1Click(Sender: TObject);
begin
    if odSecification.Execute then
    begin

        mem.EmptyTable;
        ClearLog;
        mngKompas.CleanUp;

        eFilename.text := odSecification.FileName;
        ReadKompassFile( odSecification.FileName );
    end;
end;

procedure TfLoadSpecification.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TfLoadSpecification.bCollapseClick(Sender: TObject);
begin
   mem.TreeList.FullCollapse;
end;

procedure TfLoadSpecification.bExpandClick(Sender: TObject);
begin
   mem.TreeList.FullExpand;
end;

procedure TfLoadSpecification.bRefreshClick(Sender: TObject);
begin
    mem.EmptyTable;
    CreateTree;
end;

procedure TfLoadSpecification.bUploadToPDMClick(Sender: TObject);
/// на основе массива SpecDataArray производит загрузку загруженных данных из
/// спецификации в PDM.
/// этапы:
///
///  * создание материалов
///    - перебираем массив, ищем строки с указанием материала
///    - ищем материал в базе, если нет - создаем
///
///  * создание объектов
///    - массив сканируется и все записи с FIELD_ID = 0 создаются в базе,
///      полученные id записываются в массив. перед созданием проверяем наличие,
///      поскольку одни и теже объекты могут повторяться в рамках различных исполнений
///      тогда просто получаем id. ключем для поиска является сочетание
///      обозначения, наименование и типа
///    - при добавлении нового объекта, если к нему привязан файл (FIELD_FILE <> '')
///      добавляем файл в хранилище
///
///  * создание связей
///    - перебираем массив и для каждого элемента получаем FIELD_ID непосредственного
///      родителя, если есть. по сочетанию родительского и текущего id пытаемся найти
///      связку в таблице связей структуры (Link). при отсутсвии, создаем и сохраняем
///      id связки в отдельный массив
///    - перебираем массив новых связок и для каждой создаем комплект дополнительных ссылок
var
   i
  ,j
  ,obj_id               // id нового созданного объекта
  ,obj_count            // количество созданных для статистики
  ,mat_id               // id материала для привязки к создаваемому объекту
  ,doc_type
  ,parent_id
  ,link_id
           : integer;

   material             // имя материала
           : string;
   new_links
  ,arrParents
           : array of integer;

   function GetParent( parent: integer ): integer;
   /// по локальному id записи получаем ее FIELD_ID
   var
      i : integer;
   begin
       result := 0;
{       for i := 0 to High(SpecDataArray) do
       if SpecDataArray[i][FIELD_CHILD] = parent then
       begin
           result := SpecDataArray[i][FIELD_ID];
           exit;
       end;
}   end;

   function GetStructureParents( mark: string ): integer;
   // поскольку у конструкторской документации есть строгая система маркировки
   // по ней можно однозначно определить привязку.
   // для автоматической привязки нужно поискать среди существующих объектов
   // с таким же обозначением (и учетом наличия исполнений). если нет - будем
   // создавать текущий корневой и привязываться к нему.
   // иначе, текущий корневой считается заглушкой и игнорируется, а ссылающиеся
   // на него элементы дерева привязываются к обнаруженным в базе элементам.
   var
       query: TDataset;
   begin
       result := 0;
       SetLength( arrParents, 0 );
       query := mngData.GetObjectByString( mark );
       if Assigned(query) then
       while not query.Eof do
       begin
           SetLength( arrParents, Length(arrParents)+1 );
           arrParents[High(arrParents)] := query.Fields[0].AsInteger;

           query.Next;
       end;
       result := length(arrParents);
   end;

   procedure CreateLink( parent_id: integer );
   begin
      // создаем связку с заполнением базовых полей
//      link_id := mngData.AddLink( LNK_STRUCTURE, parent_id, SpecDataArray[i][FIELD_ID] );
      if link_id <> 0 then
      begin
          // дописываем количество привязанных объектов
//          mngData.UpdateTable( link_id, LNK_STRUCTURE, [ 'count' ], [ StrToFloatDef( SpecDataArray[i][FIELD_COUNT], 1 ) ] );

          // запоминаем id связки для дальнейшей генерации допсвязей
          SetLength( new_links, Length( new_links ) + 1 );
          new_links[ high(new_links) ] := link_id;
      end;
   end;

begin

//    GetStructureParents( SpecDataArray[0][FIELD_MARK] );


    SetLength( new_links, 0 );

    ToLog('Создание новых объектов...');
    obj_count := 0;

{    for i := 0 to High(SpecDataArray) do
    if SpecDataArray[i][FIELD_ID] = 0 then
    begin
        // ищем объект среди существующих в базе
        if   FindObject( SpecDataArray[i][FIELD_MARK], SpecDataArray[i][FIELD_NAME], SpecDataArray[i][FIELD_KIND] ) <> 0 then
        begin
            SpecDataArray[i][FIELD_ID] := obj_id;
            Continue;
        end;

        // получаем привязанный материал
        mat_id := 0;
        material :=
            ifthen( SpecDataArray[i][FIELD_MAT] <> '',
                    String(SpecDataArray[i][FIELD_MAT]),
                    String(SpecDataArray[i][FIELD_MATERIAL])
            );

        if Trim( material ) <> '' then
        // ищем материал среди существующих в базе
        if   FindObject( '', material, GetKind('Материалы') ) = 0
        // если не нашли - создаем
        then mat_id := mngData.AddObject('name, kind', [ material, GetKind('Материалы') ]);

        // создаем обект
        obj_id := mngData.AddObject('mark, name, kind, mass, comment, material_id', [
            SpecDataArray[i][FIELD_MARK],
            SpecDataArray[i][FIELD_NAME],
            GetKind( SpecDataArray[i][FIELD_KIND] ),
            SpecDataArray[i][FIELD_MASS],
            SpecDataArray[i][FIELD_COMM],
            mat_id
        ]);

        // есть ли привязанный файл
        if Trim(SpecDataArray[i][FIELD_FILE]) <> '' then
        begin
            // получаем тип привязанного документа (какую иконку показывать в списке документов)
            doc_type := mngFile.GetFileType( ExtractFileExt(ExtractFileName(SpecDataArray[i][FIELD_FILE])) );

            // добавляем файл в хранилище, если есть
            mngData.CreateDocumentVersion( obj_id, 0, doc_type, ExtractFileName(SpecDataArray[i][FIELD_FILE]), SpecDataArray[i][FIELD_FILE], SpecDataArray[i][FIELD_COMM] );
        end;

        // пишем id созданного объекта в массив для дальнейшей работы
        SpecDataArray[i][FIELD_ID] := obj_id;

        // считаем статистику
        inc( obj_count );
    end;
    ToLog('...создано ' + IntToStr( obj_count ) );
}


    // полкчаем всех родителей из базы, имеющих такое же обозначение, что корневая и спецификация
    // (с учетом исполнений). в дальнейшем, все элементы ссылающиеся на корень дерева
    // будем цеплять на каждого из этих родителей, что автоматически дополнит рабочую структуру
    // базы загруженными данными
//    GetStructureParents( SpecDataArray[0][FIELD_MARK] );


    ToLog('Создание структуры...');
    obj_count := 0;
{
    // нулевой элемент нас не интересует, поскольку является просто корнем дерева и сам
    // по себе никуда привязываться не будет
    for i := 1 to High(SpecDataArray) do
    begin
        // получаем родителя
        parent_id := GetParent( SpecDataArray[i][FIELD_PARENT] );


        if parent_id <> SpecDataArray[0][FIELD_ID]
        then
            // если элемент ссылается не на корневой элемент - добавляем в обычном режиме
            CreateLink( parent_id )
        else
            if   Length(arrParents) = 0
            then
                // потенциальные родители в базе не найдены. привязываем к корню спецификации
                CreateLink( SpecDataArray[0][FIELD_ID] )
            else
                // иначе, будем привязывать к найденным в базе родителям
                for j := 0 to High(arrParents) do CreateLink( arrParents[j] );


        // считаем статистику
        inc( obj_count );
    end;
    ToLog('...создано ' + IntToStr( obj_count ) );
}
    /// если спецификация сразу не привязывается к структуре, в создании
    /// допссылок нет необходимости. они будут созданы при добавлении
    /// объекта в дерево структуры (например, при перетаскивании из справочника)
{
    ToLog('Создание вспомогательных связей...');
    for I := 0 to High(new_links) do
    begin
        mngData.CreateCrossLinks( LNK_STRUCTURE, new_links[i] );
        ToLog( IntToStr( i + 1 ) + ' из ' + IntToStr( Length( new_links ) ));
        Vcl.Forms.Application.ProcessMessages;
    end;
}
    ToLog('');
    ToLog('Загрузка спецификации в PDM завершена');
    ToLog('');
    ToLog('Спецификация добавлена в справочник. Из него спецификацию можно перетаскиванием добавить в нужное место структуры.');

    (TfObjectCatalog.Create(self)).Show;

    mem.EmptyTable;
    eFilename.Text := '';

end;

procedure TfLoadSpecification.ClearLog;
begin
    mLog.Lines.Clear;
end;

function TfLoadSpecification.CreateTree(startIndex: integer = 0): boolean;
///    на основе массива SpecDataArray загруженных из файла данных строим
///    дерево спецификации.
///    подразумевается, что загружены данные и по всем вложенным сборкам
var
    i : integer;

begin
{    for I := startIndex to High(SpecDataArray) do
    begin
        mem.AppendRecord([
            ifthen( SpecDataArray[i][FIELD_MAT] <> '', String(SpecDataArray[i][FIELD_MAT]), String(SpecDataArray[i][FIELD_MATERIAL])),
            ExtractFileName( SpecDataArray[i][FIELD_SPEC_FILE] ),
            StrToFloatDef( ReplaceStr(SpecDataArray[i][FIELD_MASS], ',', '.'), 0 ),
            SpecDataArray[i][FIELD_COMM],
            SpecDataArray[i][FIELD_ID],
            GetKind(SpecDataArray[i][FIELD_KIND]),
            SpecDataArray[i][FIELD_MARK],
            SpecDataArray[i][FIELD_NAME],
            StrToFloatDef( ReplaceStr(SpecDataArray[i][FIELD_COUNT], ',', '.'), 1 ),
            ExtractFileName( SpecDataArray[i][FIELD_FILE] ),
            SpecDataArray[i][FIELD_CHILD],
            SpecDataArray[i][FIELD_PARENT]
        ]);
    end;
    mem.First;
}
end;


procedure TfLoadSpecification.FormCreate(Sender: TObject);
begin
    LoadState := STATE_NOT_LOADED;
end;

procedure TfLoadSpecification.grdSpecificationColumns0CellButtons0Down(
  Sender: TObject; TopButton: Boolean; var AutoRepeat, Handled: Boolean);
begin
    (sender as TDBGridCellButtonEh).DropdownMenu := popMark
end;

procedure TfLoadSpecification.grdSpecificationColumns6CellButtons0Click(
  Sender: TObject; var Handled: Boolean);
/// для поля материала, для объекта - деталь, открываем справочник с фильтрацией
/// по материалам
//var
//   objCat : TfObjectCatalog;
begin
{    objCat := TfObjectCatalog.Create(self);
    objCat.SetFilter([KIND_MATERIAL]);
    objCat.Show;
}
    ((TfObjectCatalog.Create(self)).SetFilter([KIND_MATERIAL])).Show;

end;

procedure TfLoadSpecification.grdSpecificationColumns6CellButtons0GetEnabledState(
  Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
  var ButtonEnabled: Boolean);
/// для поля материала кнопка открытия справочника доступна только для детали
/// чтобы привязать материал
begin
    if   Grid.DataSource.DataSet.Active and ( Grid.DataSource.DataSet.RecordCount > 0 )
    then ButtonEnabled := Grid.DataSource.DataSet.FieldByName('kind').AsInteger = KIND_DETAIL;
end;

procedure TfLoadSpecification.grdSpecificationColumns9CellButtons0Click(
  Sender: TObject; var Handled: Boolean);
///  кнопка в поле имени спецификации. открывает диалог для выбора файла спецификации
///  после успешного добавления подгружает данные с привязкой к элементу и
///  всем его исполнениям
///  событие на проверку доступности кнопки разблокирует ее только для сборочных единиц
///
///  позволяет привязывать спецификацию к любому исполнению. все остальные в
///  массиве будут найдены автоматически
var
    ispoln : array of integer;
    // массив всех исполнений данного объекта во всех исполнениях родительских объектов
    // после полного поиска по массиву загруженной на данный момент спецификации

    mark : string;
    // обозначение по которому ищутся исполнения. если при активации режима было
    // выбрано исполнение с префиксом, префикс обрезается для корректного поиска

    i
   ,last
            : integer;

    reg     : TRegEx;
    maches  : TMatchCollection;
begin

    // не совершаем лишних телодвижений
    if   not mem.Active or ( mem.RecordCount = 0 )
    then exit;

    // записываем файл в таблицу (чисто информативно)
    if odFile.Execute then
    begin
        mem.Edit;
        mem.FieldByName('specfilename').AsString := odFile.FileName;
        mem.Post;
    end;


    // создаем регулярку, ищущую стандартное обозначение:
    // AAAA.BB.CC.DDDD-EE, где
    // AAAA - сочетание букв, цифр и дефиса = ([a-z,A-Z,а-я,А-Я]|\d|\-)+
    // .BB.CC - две группы из двух и более (про запас) цифр = (\.\d+){2}
    // .DDDD - финальная группа из цифр, которая может оканчиваться буквами, цифрами, пробелами и точками = .\d+[a-z,A-Z,а-я,А-Я, ,\d,\.]*
    // -EE - номер исполнения из дефиса и двух и более цифр (может отсутствовать) = (-\d+)?

    // в данном случае нужно извлеч из текста обозначения часть без номера исполнения
    reg:=TRegEx.Create('([a-z,A-Z,а-я,А-Я]|\d|\-)+(\.\d+){2}\.\d+[a-z,A-Z,а-я,А-Я, ,\d,\.]*');
    maches := reg.Matches( mem.FieldByName('mark').AsString );

    // если удалось достать, берем найденную часть,
    // иначе полное обозначение из записи, что не гарантирует нахождение других исполнений этого объекта,
    // но спецификация прочитается хотя бы для него
    if maches.Count > 0
    then mark := maches[0].Value
    else mark := mem.FieldByName('mark').AsString;

    // создаем универсальную регулярку под все возможные исполнения
    reg:=TRegEx.Create( mark + '(-\d+)?' );

    // запоминаем текущее количество элементов
//    last := High( SpecDataArray );

    if not mngKompas.StartKompas(true) then exit;

    // просканируем массив спецификации
    for I := 0 to last do
    // регуляркой выясняем, является ли данный объект одним из исполнений искомого
//    if   reg.Match( SpecDataArray[i][FIELD_MARK] ).Success
    // подгружаем данные из файла в дерево, подвязывая к нему
//    then OpenDocument( odFile.FileName, SpecDataArray[i][FIELD_CHILD] );

    // добавляем в мемори таблицу свежие данные, тем самым достраивая дерево
    CreateTree( last + 1);

    mngKompas.StopKompas;
end;

procedure TfLoadSpecification.grdSpecificationColumns9CellButtons0GetEnabledState(
  Grid: TCustomDBGridEh; Column: TColumnEh; CellButton: TDBGridCellButtonEh;
  var ButtonEnabled: Boolean);
/// разрешаем подгрузку спецификации только для сборочных единиц
begin
    if   Grid.DataSource.DataSet.Active and ( Grid.DataSource.DataSet.RecordCount > 0 )
    then ButtonEnabled := Grid.DataSource.DataSet.FieldByName('kind').AsInteger = KIND_ASSEMBL;
end;

procedure TfLoadSpecification.grdSpecificationFileFieldButtonsClick(
  Sender: TObject; var Handled: Boolean);
///    диалогом выбора файла получаем от пользователя полный путь
///    записываем в ячейку таблицы, при этом обработчик на BeforePost
///    автоматически запишет значение в рабочий массив
begin

   // не совершаем лишних телодвижений
   if   not mem.Active or ( mem.RecordCount = 0 )
   then exit;

   if odFile.Execute then
   begin
       mem.Edit;
       mem.FieldByName('filename').AsString := odFile.FileName;
       mem.Post;
   end;

end;

procedure TfLoadSpecification.grdSpecificationDragDrop(Sender, Source: TObject;
  X, Y: Integer);
/// заносим в спецификацию информацию из источника
var
   srcDataset
  ,trgDataset: TDataset;
begin

    // при отсутствии корректных данных - не заморачиваемся
    if dndMode = DND_MODE_NULL then exit;

    // сокращаем обращение к датасетам
    srcDataset := (Source as TDBGridEh).DataSource.DataSet;
    trgDataset := (Sender as TDBGridEh).DataSource.DataSet;

    // назначение материала детали
    if dndMode = DND_MODE_ADD_MATERIAL then
    begin
        mem.Edit;
        mem.FieldByName('material').AsString := srcDataset.FieldByName('name').AsString;
        mem.Post;
    end;

end;

procedure TfLoadSpecification.grdSpecificationDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
/// проверка на возможность пермещения данных из справочника в таблицу с загруженной
/// спецификацией. допустимы случаи:
///    - материал из справочника на деталь в спецификации
var
   srcDataset
  ,trgDataset: TDataset;

   coord: TGridCoord;
begin

    dndMode := DND_MODE_NULL;

    // сокращаем обращение к датасетам
    srcDataset := (Source as TDBGridEh).DataSource.DataSet;
    trgDataset := (Sender as TDBGridEh).DataSource.DataSet;

    // перемещаемся на запись, на которую указывает курсор мыши
    coord := (Sender as TDBGridEh).MouseCoord(X, Y);
    (Sender as TDBGridEh).DataSource.DataSet.RecNo := coord.y;

    // можно перетаскивать, если источник - объект материала,
    // а приемник - объект детали
    Accept :=
       Assigned(srcDataSet.FindField('kind')) and
       ( srcDataset.FieldByName('kind').AsInteger = KIND_MATERIAL ) and
       ( trgDataset.FieldByName('kind').AsInteger = KIND_DETAIL );
    if Accept then dndMode := DND_MODE_ADD_MATERIAL;


end;

procedure TfLoadSpecification.memBeforePost(DataSet: TDataSet);
var
  I: Integer;
///    после ручной правки поля Обозначение или Наименование
///    перепроверяем наличие объекта в базе
begin
{
    if LoadState = STATE_LOADING then exit;

    Dataset.FieldByName('object_id').AsInteger :=
        FindObject( Dataset.FieldByName('mark').AsString, Dataset.FieldByName('name').AsString, Dataset.FieldByName('kind').AsString );

    ///    из текущей записи обновляем данные в массиве. поскольку именно он является
    ///    рабочим источником данных, которй потом будет использоваться для загрузки
    ///    структуры спецификации в базу
    for I := 0 to High(SpecDataArray) do
    if Dataset.FieldByName('child').AsInteger = SpecDataArray[i][FIELD_CHILD] then
    begin
        SpecDataArray[i][FIELD_MAT] := Dataset.FieldByName('material').AsString;

        if   ExtractFilepath(Dataset.FieldByName('specfilename').AsString) <> ''
        then SpecDataArray[i][FIELD_SPEC_FILE] := Dataset.FieldByName('specfilename').AsString;

        SpecDataArray[i][FIELD_MASS] := ReplaceStr(Dataset.FieldByName('mass').AsString, ',', '.');
        SpecDataArray[i][FIELD_COMM] := Dataset.FieldByName('comment').AsString;
        SpecDataArray[i][FIELD_ID] := Dataset.FieldByName('object_id').AsString;
        SpecDataArray[i][FIELD_MARK] := Dataset.FieldByName('mark').AsString;
        SpecDataArray[i][FIELD_NAME] := Dataset.FieldByName('name').AsString;
        SpecDataArray[i][FIELD_COUNT] := ReplaceStr(Dataset.FieldByName('count').AsString, ',', '.');

        if   ExtractFilepath(Dataset.FieldByName('filename').AsString) <> ''
        then SpecDataArray[i][FIELD_FILE] := Dataset.FieldByName('filename').AsString;

        SpecDataArray[i][FIELD_PARENT] := Dataset.FieldByName('parent').AsString;
    end;
}
end;



procedure TfLoadSpecification.SetLoadState(state: integer);
begin
    fLoadState := state;

    case state of
       STATE_NOT_LOADED: grdSpecification.ReadOnly := true;
       STATE_LOADING: ;
       STATE_LOADED: grdSpecification.ReadOnly := false;
    end;
end;


function TfLoadSpecification.GetFromNearFile(mark: string; field: integer): string;
///    для указанного обозначения ищем привязанный файл, если есть и возыращаем
///    указанный в файле материал
var
    i: integer;
begin
    result := '';
    for i := 0 to High(NearFiles) do
    if NearFiles[i][NEAR_MARK] = mark then
    begin
        result := NearFiles[i][NEAR_MATERIAL];
        break;
    end;
end;

procedure TfLoadSpecification.ToLog(text: string);
begin
    mLog.Lines.Add( text );
    // KsTLB переопределяет Application как KompasObject;
    Vcl.Forms.Application.ProcessMessages;
end;

end.
