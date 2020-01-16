unit uObjectCard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Buttons, uDataManager, Vcl.ComCtrls, ShellApi;

const
    OBJECT_CARD_MODE_CREATE = 0;
    OBJECT_CARD_MODE_VIEW = 1;
    OBJECT_CARD_MODE_EDIT = 2;

type

  TCallback = procedure of object;

  TfObjectCard = class(TForm)
    lObjectKind: TLabel;
    kind: TEdit;
    bSelKind: TImage;
    Label2: TLabel;
    mark: TEdit;
    Label3: TLabel;
    name: TEdit;
    Label4: TLabel;
    comment: TMemo;
    bOk: TButton;
    bClose: TButton;
    sbEraserMark: TSpeedButton;
    sbEraserName: TSpeedButton;
    sbEraserComment: TSpeedButton;
    Label5: TLabel;
    sbEraserRealization: TSpeedButton;
    realization: TEdit;
    Label6: TLabel;
    sbEraserSubmark: TSpeedButton;
    markTU: TEdit;
    Label7: TLabel;
    mass: TEdit;
    sbEraserMass: TSpeedButton;
    lMaterial: TLabel;
    sbEraserMaterial: TSpeedButton;
    material_id: TEdit;
    sbAllRealization: TSpeedButton;
    bSelMaterial: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    sbSelSubmark: TSpeedButton;
    Panel1: TPanel;
    bSelMarkTU: TImage;
    PageControl1: TPageControl;
    pageInfo: TTabSheet;
    pageFile: TTabSheet;
    iPreview: TImage;
    Label9: TLabel;
    file_comment: TMemo;
    Label10: TLabel;
    doc_name: TEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    Splitter1: TSplitter;
    bAddDocument: TButton;
    OpenDialog: TOpenDialog;
    Label11: TLabel;
    file_icon: TEdit;
    Panel10: TPanel;
    bSelIcon: TImage;
    checkAutoLink: TCheckBox;
    icon: TEdit;
    bSelObjIcon: TImage;
    lObjectIcon: TLabel;
    Panel11: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure bSelKindClick(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure bCloseClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure sbEraserMarkClick(Sender: TObject);
    procedure bSelMaterialClick(Sender: TObject);
    procedure bSelMarkTUClick(Sender: TObject);
    procedure bAddDocumentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bSelDocIconClick(Sender: TObject);
    procedure bSelObjIconClick(Sender: TObject);
    procedure markKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
//    kind_id
//   material_id_
   fMode
//   ,mark_tu_id
   ,ProjectID
   ,ChildID
//   ,file_icon_       // [document_type].[kind]
//   ,file_icon_id_    // [document_type].[id]
//   ,file_icon_old    // ������ �������� ���� ��������� �� ������ �������� �����
                     // ��������� ���������� ���� ��������� ���������� ������� � ����,
                     // ����� �������� ������ ��������, ����� ��� ������, ����
                     // ��� ������� ���������
//   ,obj_icon         // [document_type].[kind] - ������������ ��� ���������� ��� �������
            : integer;
    dsTreeSource
   ,dsObjectSource
   ,dsDocSource
            : TDataset;
    fCallback : TCallback;
    _filename: string;

    /// �������� ��������������� ����� �� dsObjectSource
    /// ��������� ��������� ������, ����� ����� � ��������� ���������, ������� ����� ���� ��������
    /// �������� ����� ���������� (� ��������, ��������� ���� ����� ������� 'mem_'
    /// ��� ��� ���������� ����� ������ �������� � ���������� ��� �������������,
    /// ����� �� ��������� ��� ������ � �������� ����������
    fKind, fIcon, fMaterial, fFileKind: integer;
    fRealization, fMark, fName, fMarkTU, fMass, fComment, fFileName, fFileComment, fERP: string;

    function SetField( component: TComponent; dataset: TDataset = nil ): integer;
    procedure FillField( component: TComponent; dataset: TDataset = nil );
    procedure TextToField( component: TComponent; text: string );
    procedure SetMode( mode: integer );
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure CheckMaterialSetupAllow;
    procedure CheckIconSetupAllow;

    procedure SetKind(_kind: integer);
    procedure SetIcon(_icon: integer);
    procedure SetMaterial(_material: integer);
    procedure SetComment(const Value: string);
    procedure SetFileComment(const Value: string);
    procedure SetFileKind(const Value: integer);
    procedure SetFileName(const Value: string);
    procedure SetMark(const Value: string);
    procedure SetMarkTU(const Value: string);
    procedure SetMass(const Value: string);
    procedure SetName(const Value: string);
    procedure SetRealization(const Value: string);
  public

    property pKind: integer read fKind write SetKind;
//    property pKindName: string read GetKindName;
    property pIcon: integer read fIcon write SetIcon;
//    property pIconName: string read GetIconName;
    property pMaterial: integer read fIcon write SetMaterial;
//    property pMaterialName: string read GetMaterialName;
    property pFileKind: integer read fFileKind write SetFileKind;
//    property pFileKindName: string read GetFileKindName;
    property pRealization: string read fRealization write SetRealization;
    property pMark: string read fMark write SetMark;
    property pName: string read fName write SetName;
    property pMarkTU: string read fMarkTU write SetMarkTU;
    property pMass: string read fMass write SetMass;
    property pComment: string read fComment write SetComment;
    property pFileName: string read fFileName write SetFileName;
    property pFileComment: string read fFileComment write SetFileComment;

    { Public declarations }
    constructor Create( owner: TComponent; mode: integer; callback: TCallback; ObjectDataset: TDataset = nil; DocDataset: TDataset = nil ); overload;
    function SetProject( project_id: integer): TfObjectCard;
    function SetChild( child_id: integer): TfObjectCard;
    function SetTreeDS( dataset: TDataset ): TfObjectCard;
    function AddFile( filename: string ): TfObjectCard;
    function Init: TfObjectCard;

  end;

implementation

{$R *.dfm}

uses
    uPhenixCORE, uConstants, uMain, uObjectCatalog, DBGridEh, GridsEh, StrUtils,
    uFileCatcher, uCommonOperations, uKompasManager;

procedure TfObjectCard.bSelMarkTUClick(Sender: TObject);
const
    delimeter = ' --- ';
begin
    Core.LSearch.Init( markTU, 'SELECT TU + ''' + delimeter + ''' + Oboz, id FROM '+TBL_MARK_TU );
    if Core.LSearch.Execute then
    begin
       markTU.Text := Copy(Core.LSearch.SelText, 1, Pos(delimeter, Core.LSearch.SelText));
       fMarkTU := Core.LSearch.SelData;
    end;
end;

procedure TfObjectCard.bSelMaterialClick(Sender: TObject);
begin

    // ����� ��������� �� ���� NFT
    if trim(material_id.Text) <> ''
    then Core.LSearch.InitEx( material_id, 'SELECT TOP 100 m, id FROM '+TBL_MAT+' WHERE m like ''%'+TAG_VALUE+'%''', material_id.Text, fMaterial)
    else Core.LSearch.Init( material_id, 'SELECT TOP 100 m, id FROM '+TBL_MAT+' WHERE m like ''%'+TAG_VALUE+'%''');

    if Core.LSearch.Execute then
    begin
       material_id.Text := Core.LSearch.SelText;
       fMaterial := Core.LSearch.SelData;
    end;

end;

procedure TfObjectCard.bSelKindClick(Sender: TObject);
begin

    Core.LSearch.Init( kind, 'SELECT DISTINCT(name), kind FROM '+TBL_OBJECT_CLASSIFICATOR + ' WHERE layer = ' + LAYER_PRODUCTION_OBJECT );
    if Core.LSearch.Execute then
    begin
       kind.Text := Core.LSearch.SelText;
       fKind := Core.LSearch.SelData;

       CheckIconSetupAllow;
       CheckMaterialSetupAllow;
    end;

end;

constructor TfObjectCard.Create( owner: TComponent; mode: integer; callback: TCallback; ObjectDataset: TDataset = nil; DocDataset: TDataset = nil );
begin
  inherited Create( owner );

  dsObjectSource := ObjectDataset;
  dsDocSource := DocDataset;
  fCallback := callback;
  fMode := mode;
end;

function TfObjectCard.Init: TfObjectCard;
begin
  result := self;

  if assigned(dsObjectSource) then
  begin
      if Assigned(dsObjectSource.FindField('mem_kind')) then pKind := dsObjectSource.FieldByName('mem_kind').AsInteger;
      if Assigned(dsObjectSource.FindField('kind'))     then pKind := dsObjectSource.FieldByName('kind').AsInteger;

      if Assigned(dsObjectSource.FindField('mem_icon')) then pIcon := StrToIntDef(dsObjectSource.FieldByName('mem_icon').AsString, 0);
      if Assigned(dsObjectSource.FindField('icon'))     then pIcon := StrToIntDef(dsObjectSource.FieldByName('icon').AsString, 0);

      if Assigned(dsObjectSource.FindField('realization')) then pRealization := dsObjectSource.FieldByName('realization').AsString;

      if Assigned(dsObjectSource.FindField('mem_mark')) then pMark := dsObjectSource.FieldByName('mem_mark').AsString;
      if Assigned(dsObjectSource.FindField('mark'))     then pMark := dsObjectSource.FieldByName('mark').AsString;

      if Assigned(dsObjectSource.FindField('markTU'))   then pMarkTU := dsObjectSource.FieldByName('markTU').AsString;

      if Assigned(dsObjectSource.FindField('mem_name')) then pName := dsObjectSource.FieldByName('mem_name').AsString;
      if Assigned(dsObjectSource.FindField('name'))     then pName := dsObjectSource.FieldByName('name').AsString;

      if Assigned(dsObjectSource.FindField('material')) then pMaterial := dsObjectSource.FieldByName('material').AsInteger;
      if Assigned(dsObjectSource.FindField('mass'))     then pMass := dsObjectSource.FieldByName('mass').AsString;
      if Assigned(dsObjectSource.FindField('comment'))  then pComment := dsObjectSource.FieldByName('comment').AsString;
  end;

  if assigned(dsDocSource) then
  begin
      if Assigned(dsDocSource.FindField('doc_name'))  then pFileName := dsDocSource.FieldByName('doc_name').AsString;
      if Assigned(dsDocSource.FindField('type_icon'))  then pFileKind := dsDocSource.FieldByName('type_icon').AsInteger;
      if Assigned(dsDocSource.FindField('doc_comment'))  then pFileComment := dsDocSource.FieldByName('doc_comment').AsString;
  end;

  SetMode( fMode );

//  UpdateFieldsData;

end;

procedure TfObjectCard.bOkClick(Sender: TObject);
var
    id
   ,parent_id
   ,ext_id
   ,parent_kind
   ,parent_icon
   ,parent_status
            : integer;
    amass
   ,ext
   ,error
            : string;

    procedure AddDoc;
    begin
        // �������� ������� ������� � ��� �������� ��������
        if (id <> 0) and (_filename <> '') then
        begin
            // ����������� �������� � �������
            ext := ExtractFileExt( ExtractFileName( _filename ) );
            if mngData.CreateDocumentVersion( id, 0{������ ������� ���������}, 0{file_icon_id_} , doc_name.text, _filename, file_comment.Lines.Text, 1{������� ��������� �����} ) <> 0
            then
                mngFile.CreatePreviewFile( iPreview.Picture.Graphic, '(' + IntToStr( mngData.lastVersionNumber ) + ')' + ChangeFileExt( ExtractFileName( doc_name.text ), '' ) )
        end;
    end;

begin

    error := '';

    /// ��������� �� ���������� �������� ����� ����� �����������
    if fKind <= 0 then error := '�� ������ '+lObjectKind.Caption+'!';

    if error = '' then
    if (fKind in [KIND_ASSEMBL, KIND_COMPLEX, KIND_COMPLECT]) and
       not (fIcon in [KIND_SPECIF, KIND_ISPOLN])
    then error := '�� ������ '+lObjectIcon.Caption+' �������!';

    if error = '' then
    if (fKind in [{KIND_STANDART,} KIND_DETAIL]) and
       (fMaterial = 0)
    then error := '�� ������ '+lMaterial.Caption+' �������!';

    if error <> '' then
    begin
        ShowMessage( lW(error) );
        exit;
    end;


    case fMode of

        OBJECT_CARD_MODE_CREATE:
        begin
            /// ������� ������ ������������
            id := mngData.CreateProjectObject( mark.Text, realization.Text, markTU.Text, name.Text, ifthen(trim(mass.Text)='', '0', Trim(mass.text)), comment.Lines.Text, fKind, fMaterial, fIcon, ProjectID );

            // ������� � ����������� ��������
            AddDoc;

            // ���� ����������� ������� �������������� �������� � ������
            if checkAutoLink.Checked then
            begin
                /// ���� � ������ ������� ���� �������, ����� ��� ��� ��������
                /// ����� ����������� � ����� �������
                if   Assigned(dsTreeSource) and dsTreeSource.Active and (dsTreeSource.RecordCount <> 0)
                then error := mngData.LinkToProjectObject( dsTreeSource.FieldByName('mem_child').AsInteger, id, ProjectID )
                else error := mngData.LinkToProjectObject( ProjectID, id, ProjectID );

                if error <> '' then ShowMessage( error + sLineBreak + '�������� ��������.' );
            end;

        end;
        OBJECT_CARD_MODE_EDIT:
        begin
            // �������� id ������� ������� ��������
            id := ChildID;
{            if   Assigned( dsObjectSource ) and dsObjectSource.Active and Assigned( dsObjectSource.fields.FindField('id') )
            then id := dsObjectSource.FieldByName('id').AsInteger;

            if   Assigned( dsObjectSource ) and dsObjectSource.Active and Assigned( dsObjectSource.fields.FindField('mem_child') )
            then id := dsObjectSource.FieldByName('mem_child').AsInteger;

            if   Assigned( dsObjectSource ) and dsObjectSource.Active and Assigned( dsObjectSource.fields.FindField('child') )
            then id := dsObjectSource.FieldByName('child').AsInteger;
}
            amass := ReplaceStr(mass.Text, ',', '.');
            if amass = '' then amass := '0';

            mngData.ChangeObject(id, ['mark', 'realization', 'markTU', 'name', 'kind', 'mass', 'material_id', 'comment', 'icon'],
                                     [mark.Text, realization.Text, markTU.Text, name.Text, fKind, amass, fMaterial, comment.Lines.Text, fIcon ]);

            /// ��������� ����� �������� ���� ���������, ���� ����������
            if   Assigned( dsDocSource ) and dsDocSource.Active and Assigned( dsDocSource.fields.FindField('child') ) then
            begin
                mngData.UpdateTable(
                    dsDocSource.FieldByName('child').AsInteger,
                    TBL_PROJECT,
                    ['icon'],
                    [fFileKind]
                );
            end;

            // ������� � ����������� ��������
            AddDoc;

        end;
    end;


    fCallback;

    Close;
end;

function TfObjectCard.AddFile(filename: string): TfObjectCard;
/// ���������� ������ ���������� �����
/// ���� �� �� �������� ������ ������, �������� ������ ��� � ��������
/// �����, ���� ������������ ����������, �������� ���� �������� ������� �� �����
/// (����������� ����� ����� ������ ���� ��������� �� �����, ������� ��������)
var
   ext
  ,material
           : string;

   query: TDataset;
begin

    result := self;

    if not FileExists( filename) then
    begin
        iPreview.Picture.Bitmap.Handle := 0;
        exit;
    end;

    // ���������� ���� �� ��������� ����� ��� ���������� ���������
    _filename := filename;

    // ���������� � ��������� ������� ���������
    pageFile.TabVisible := true;
    doc_name.Text := ExtractFileName( filename );
    iPreview.Picture.Bitmap.Handle := mngFile.GetThumbnailImage( filename, IMAGE_PREVWIEW_SIZE, IMAGE_PREVWIEW_SIZE);

    ext := ExtractFileExt(_filename);
    // ����������, �������� �� ���� ���� �������
    if mngData.GetProgramByExt( ext ) <> WORK_PROG_KOMPAS then exit;

    // ��������� ���� � ���������� ������ ��� ���������� �����
    if (ext = '.spw') or (ext = '.cdw') then
    begin

        if not mngKompas.Init( _filename ) then exit;

        // ���������� ������ � ��������������� ����
        mark.Text := mngKompas.GetStampData( FIELD_MARK );
        name.Text := mngKompas.GetStampData( FIELD_NAME );
        mass.Text := mngKompas.GetStampData( FIELD_MASS );
        if Trim(mass.Text) = '' then mass.Text := '0';

        /// ��� ������� ���������� ��������� ��������� ������������
        /// - ������� �������� ����� ����� �������� �������
        /// - ���� ���, ���� � �������� �����������
        ///       - ���� ����, ��������
        /// ! ���������� �������� ��������� ������, ������� ���� ������� ������������
        ///     ���� ������� �� ���������� � ���������� ������� �� ���������
        material := mngKompas.GetStampData( FIELD_MATERIAL );

        if material <> '' then
        begin
            fMaterial := dmSDQ( 'SELECT id FROM '+TBL_PROJECT+' WHERE mark = ''' + material + '''', 0);

            if fMaterial = 0
            then
            begin
                fMaterial := dmSDQ( 'SELECT id FROM '+TBL_OBJECT+' WHERE mark = ''' + material + '''', 0);

                // �������� �� ������ � ������� �����������, �� ��������� � ��������
                if fMaterial <> 0 then
                // �������� � �������. ��� ���������� ������ ��������, id ��������� ����� ���������
                fMaterial := mngData.CopyObjectToProject(ProjectID, -1, fMaterial); // ������ �� �����������
            end;

            if   fMaterial <> 0
            then material_id.Text := material;
        end;

    end;

    // ��������� ���� ���� ���������
    // �� ���������� ����� ���������� ������ ���������� ��� �� ����������� [document_type]
    // � ����������� ��� � ����
    file_icon.Text := '�����������';
    fFileKind := 0;

    query := CORE.DM.OpenQueryEx(
        'SELECT TOP 1 name, icon FROM ' + TBL_DOCUMENT_TYPE + ' WHERE ext like ''%' + ExtractFileExt( ExtractFilename(_filename) ) + '%''' );
    if not Assigned(query) or not query.Active or (query.RecordCount = 0) then exit;

    file_icon.Text := query.FieldByName('name').AsString;
    fFileKind      := query.FieldByName('icon').AsInteger;

end;

procedure TfObjectCard.bAddDocumentClick(Sender: TObject);
/// ����������� �������� � �������
/// ���� ��� ������ ��� ������������, �������� ������ �� ��� � ��������� �����
/// �����, ���� ������������ ��������
begin
    if   OpenDialog.Execute
    then AddFile( OpenDialog.FileName );
end;

procedure TfObjectCard.bCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfObjectCard.FillField( component: TComponent; dataset: TDataset = nil );
var
    id: integer;
    query: TDataset;
begin

    // ��� �������� ����������� �� ���������� ���� id ����� �������
    // ��� ��������� - ��������� ���������� �������������
    // (��������� ������ �������)
    id := SetField( component, dataset );

    // ���� ���� ���������.
    // SetField ��� ��������� � file_icon.Text �������� icon, ������� ������
    // ����� ���������� � ������������
    if ( id = 0 ) and ( component.Name = 'file_icon' ) then
    begin

        if file_icon.Text <> '' then
        begin
            query := CORE.DM.OpenQueryEx( 'SELECT name, icon, id FROM '+TBL_DOCUMENT_TYPE +' WHERE icon = ' + file_icon.Text );
            if not Assigned(query) or not query.Active or (query.RecordCount = 0) then
            query := CORE.DM.OpenQueryEx( 'SELECT name, icon, id FROM '+TBL_DOCUMENT_TYPE +' WHERE icon = 0');

            if Assigned(query) and query.Active and (query.RecordCount > 0) then
            begin
                TextToField( component, query.FieldByName('name').AsString );
                fFileKind    := query.FieldByName('icon').AsInteger;
            end;
        end;
    end;



    // ���� ������� �������
    // ���� ��������� ����� � ���������, ��� � ������ �������� ���� icon �����
    // ������ ��� (integer ��� string), ������������, � ������ ������ ��� ��������
    // ����� ������� � ���������� id, � �� ������ � icon.Text.
    // �������� ���������� ��� ��������
    if (component.Name = 'mem_icon') or (component.Name = 'icon') then
    begin

        if id <> 0
        then fIcon := id
        else fIcon := StrToInt(icon.Text);

        // ��������, ����� �������� �� �������������� ���������� �����������
        id := 0;

        TextToField( component, dmSDQ( 'SELECT name FROM '+ TBL_OBJECT_CLASSIFICATOR +' WHERE id = '+IntToStr(fIcon), '' ) );
    end;

    /// ������� ���������� id ��������, ��� ���� ��������, � �� ���������.
    /// ���������, ����������� ��� ���� � �������� ���������, ������������ ���� ������
    /// ��� ��������� id ��� ���������� ��������� ���� � ���������� �������, ���
    /// ������������ �����...

    // ���� ���� �������
    if   ( id > 0 ) and (( component.Name = 'mem_kind' ) or ( component.Name = 'kind' )) then
    begin
        TextToField( component, dmSDQ( 'SELECT name FROM '+TBL_OBJECT_CLASSIFICATOR +' WHERE kind = '+IntToStr(id), '' ) );
        fKind := id;
    end

    // ���� ���������
    else if ( id > 0 ) and ( component.Name = 'material_id' ) then
    begin
        TextToField( component, dmSDQ( 'SELECT name FROM '+TBL_OBJECT +' WHERE id = '+IntToStr(id), '' ) );
        fMaterial := id;
    end

    // else if ... then
    // ����� ������������� ������ ����������

    // � ����� ���������, ��� ���� ����� ������������� �������� � �� ��������
    // ������� �� ������ �������. ����������� �������� ��� ����
    else if ( id > 0 ) then TextToField( component, IntToStr(id) );


end;

procedure TfObjectCard.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
{ ����������, �������������� �������������� ��� �� �����, ��� � ���������� ����
  � ����������� ��� ������� �� ��������� (���� ����)
}
var
    dataset
            : TDataSet;
    i
            : integer;
begin

    dataset := (Source as TDBGridEh).DataSource.DataSet;

    // ��� �������������� �� ���� �����, ����� ��������� ��� ��������� ���� �����.
    // ���������� �������� ���������� � ���� TEdit � TMemo
    if (Sender is TfObjectCard) or (Sender is TTabSheet)
    then
        begin

            for I := 0 to (Sender as TWinControl).ControlCount-1 do
                if   ((Sender as TWinControl).Controls[i] is TCustomEdit) // TEdit ��� TMemo
                then FillField( (Sender as TWinControl).Controls[i], dataset );

        end
    else
    // �����, �������������� � ���������� ����. ��������� ������ ���
        FillField( Sender as TComponent, dataset );
end;

procedure TfObjectCard.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := true;
end;

procedure TfObjectCard.FormShow(Sender: TObject);
var
    i
   ,child
   ,version
            : integer;
    filename
            : string;
begin

    // ���� ������ ������. ��� ����� ������������ ��� �������������� ���������� �����
    child := 0;
    version := 0;
    if Assigned( dsDocSource ) and dsDocSource.Active and (dsDocSource.RecordCount > 0) then
    begin

        // ���� ������ � ����� ������ ������� ��������� �����
        dsDocSource.First;
        while not dsDocSource.eof do
        begin
            if (dsDocSource.FieldByName('is_main').AsInteger <> 0) and
               (dsDocSource.FieldByName('editor_fio').IsNull) and
               (dsDocSource.FieldByName('version').AsInteger > version) then
            begin
                version := dsDocSource.FieldByName('version').AsInteger;
                child := dsDocSource.FieldByName('project_doc_id').AsInteger;
            end;
            dsDocSource.Next;
        end;

        // ��������� �� ������ ������, ����� �������� � ��� ������ ��� ��������� ���������� �����
        if not dsDocSource.Locate( 'project_doc_id', child, [] )
        // ��� �������, �������� ������ �� ������������ ����� ������, ����� �� ���������
        // ���� ��������� �������
        then dsDocSource := nil
        else
        begin
            // �������� ��������� ���������
            filename := DIR_PREVIEW + '(' + dsDocSource.FieldByName('version').AsString + ')' + ChangeFileExt( dsDocSource.FieldByName('filename').AsString, '.jpg');

            if   FileExists( filename )
            then
                ShowPreview( filename, iPreview )
            else
                iPreview.Picture := nil;
        end;


    end;

{
    // ���������, ����� ����� ����� � ������ ��������� �� ������������
    if Assigned( dsObjectSource ) or Assigned( dsDocSource ) then
    begin
        for I := 0 to self.ComponentCount-1 do
            if   (self.Components[i] is TCustomEdit) // TEdit ��� TMemo
            then FillField( self.Components[i] );
    end;
}


    CheckMaterialSetupAllow;

end;

procedure TfObjectCard.markKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   key := key;
end;

procedure TfObjectCard.bSelObjIconClick(Sender: TObject);
begin
    Core.LSearch.Init( icon, 'SELECT DISTINCT(name), kind FROM '+TBL_OBJECT_CLASSIFICATOR + ' WHERE layer = ' + LAYER_PRODUCTION_SUBJECT );
    if Core.LSearch.Execute then
    begin
       icon.Text := Core.LSearch.SelText;
       fIcon := Core.LSearch.SelData;

       CheckMaterialSetupAllow;
    end;
end;

procedure TfObjectCard.bSelDocIconClick(Sender: TObject);
var
    ext: string;
begin

    if _filename <> ''
    then
        // ���� ��� ������ ����, ����� ��� ����������
        // ��� �������� � � ������ �������� � � ������ ��������������
        ext := ExtractFileExt(_filename)
    else
        // ���� ��� �������� ������, ������ ��� ����� ��������������� � �������� �����
        // ���������� � ������� ����������� ������
        if   Assigned( dsDocSource ) and dsDocSource.Active and (dsDocSource.RecordCount > 0)
        then ext := dsDocSource.FieldByName('type_ext').AsString;


    Core.LSearch.Init( file_icon, 'SELECT Name, icon FROM '+ TBL_DOCUMENT_TYPE + ifthen(ext <> '', ' WHERE ext like ''%'+ext+'%''', '') );
    if Core.LSearch.Execute then
    begin
       file_icon.Text := Core.LSearch.SelText;
       fFileKind := Core.LSearch.SelData;
    end;
end;

procedure TfObjectCard.sbEraserMarkClick(Sender: TObject);
var
    i : integer;
begin
    for I := 0 to self.ComponentCount-1 do
        if   (self.Components[i] as TComponent).Name = (Sender as TControl).Hint
        then TextToField(self.Components[i], '' );
end;

function TfObjectCard.SetField(component: TComponent; dataset: TDataset = nil): integer;
{ ����� �������� ����� � �������� ���� � ������, ����������� � ������ ����������.
  ���� ������� � �������� � � ���� ��������� - ��� ������� ������������� � ����,
  �����, ��� �������� �������� id-������, ����� ���������� ��� �������� �� ���������� ���������

  dataset - ���� ��������� �������� ������, ������� ���������� �� ��������� drag`n`drop � ������ ����� ������ �� ����.
            ���� �� �����, ����� ������ �� ���������� ��������� dsObjectSource � dsDocSource
}
var
    name : string;

    function Fill( ds: TDataset ): integer;
    begin
        result := -1;
        if   Assigned( ds ) and ds.Active and  Assigned( ds.fields.FindField(name) )  then
        begin

            if   ds.FieldByName( name ).DataType in [ ftString, ftMemo, ftFloat, ftDateTime ]
            then
                begin
                    TextToField( component, ds.FieldByName( name ).AsString );
                    result := 0;
                end
            else
                result := ds.FieldByName( name ).AsInteger;
        end
    end;

begin

    result := -1;
    name := Component.Name;

    if Assigned( dataset )
    then
        result := Fill( dataset )
    else
    begin

        // �������� ����� ���� � �������� �������
        result := Fill( dsObjectSource );

        // �����, ���� � �������� ���������
        if result = -1
        then result := Fill( dsDocSource );

    end;

end;

procedure TfObjectCard.SetFileComment(const Value: string);
begin
  fFileComment := Value;
  comment.Text := fFileComment;
end;

procedure TfObjectCard.SetFileKind(const Value: integer);
var
    query: TDataset;
begin
    fFileKind := Value;

    query := CORE.DM.OpenQueryEx( 'SELECT name, icon, id FROM '+TBL_DOCUMENT_TYPE +' WHERE icon = ' + IntToStr(fFileKind) );
    if Assigned(query) and query.Active and (query.RecordCount > 0) then
    begin
        TextToField( file_icon, query.FieldByName('name').AsString );
        fFileKind    := query.FieldByName('icon').AsInteger;
    end;
end;

procedure TfObjectCard.SetFileName(const Value: string);
begin
    fFileName := Value;
    doc_name.Text := fFileName;
end;

procedure TfObjectCard.SetIcon(_icon: integer);
begin
    fIcon := _icon;
    TextToField( kind, dmSDQ( 'SELECT name FROM '+TBL_OBJECT_CLASSIFICATOR +' WHERE kind = '+IntToStr(fIcon), '' ) );
end;

procedure TfObjectCard.SetKind(_kind: integer);
begin
    fKind := _kind;
    TextToField( kind, dmSDQ( 'SELECT name FROM '+TBL_OBJECT_CLASSIFICATOR +' WHERE kind = '+IntToStr(fKind), '' ) );
end;

procedure TfObjectCard.SetMaterial(_material: integer);
begin
    fMaterial := _material;
    TextToField( material_id, dmSDQ( 'SELECT m FROM '+TBL_MAT +' WHERE id = '+IntToStr(fMaterial), '' ) );
end;

procedure TfObjectCard.SetMark(const Value: string);
begin
  fMark := Value;
  mark.Text := fMark;
end;

procedure TfObjectCard.SetMarkTU(const Value: string);
begin
  fMarkTU := Value;
  markTU.Text := fMarkTU;
end;

procedure TfObjectCard.SetMass(const Value: string);
begin
  fMass := Value;
  mass.Text := fMass;
end;


procedure TfObjectCard.SetMode(mode: integer);
var
    has_main_doc : boolean;

    procedure SetComponents(enable: boolean);
    var
        i : integer;
    begin
        // ������ ������������ ��� �������������� ��� TEdit � TMemo �� �����
        for I := 0 to (self as TForm).ComponentCount-1 do
        begin
            if   ((self as TForm).Components[i] is TCustomEdit)
            then ((self as TForm).Components[i] as TCustomEdit).ReadOnly := not enable;

            if   ((self as TForm).Components[i] is TSpeedButton) or
                 ((self as TForm).Components[i] is TImage)
            then ((self as TForm).Components[i] as TGraphicControl).Enabled := enable;
        end;

    end;

begin

    // � ������ �������� �������� ����������� ��� �������� ���������
    if   assigned(dsObjectSource)
    then has_main_doc := mngData.HasMainDoc( ChildID );

    case mode of
        OBJECT_CARD_MODE_CREATE:
        begin
            bOk.Caption := '�������';
            bAddDocument.Visible := true;
            pageFile.TabVisible := false;
            SetComponents(true);
            // �������������� ������������ �������� ����� ��������� SetComponents
            bSelKind.Enabled := true;
            checkAutoLink.Visible := true;
        end;
        OBJECT_CARD_MODE_VIEW:
        begin
            bOk.Visible := false;
            bAddDocument.Visible := false;
            pageFile.TabVisible := has_main_doc;
            SetComponents(false);
            // �������������� ������������ �������� ����� ��������� SetComponents
            bSelKind.Enabled := false;
            checkAutoLink.Visible := false;
        end;
        OBJECT_CARD_MODE_EDIT:
        begin
            bOk.Caption := '���������';
            bAddDocument.Visible := not has_main_doc;
            pageFile.TabVisible := has_main_doc;
            SetComponents(true);
            // �������������� ������������ �������� ����� ��������� SetComponents
            bSelKind.Enabled := false;
            checkAutoLink.Visible := false;
            file_comment.ReadOnly := true;
            doc_name.ReadOnly := true;

            CheckIconSetupAllow;
            CheckMaterialSetupAllow;
        end;
    end;

    // �������������� ������������ �������� ����� ��������� SetComponents
    kind.ReadOnly        := true;
    icon.ReadOnly        := true;
    material_id.ReadOnly := true;
    markTU.ReadOnly      := true;
    file_icon.ReadOnly   := true;
    bSelObjIcon.Enabled  := false;

end;

procedure TfObjectCard.SetName(const Value: string);
begin
  fName := Value;
end;

function TfObjectCard.SetProject(project_id: integer): TfObjectCard;
begin
    ProjectID := project_id;
    result := self;
end;

procedure TfObjectCard.SetRealization(const Value: string);
begin
  fRealization := Value;
end;

function TfObjectCard.SetChild(child_id: integer): TfObjectCard;
begin
    ChildID := child_id;
    result := self;
end;

procedure TfObjectCard.SetComment(const Value: string);
begin
  fComment := Value;
end;


function TfObjectCard.SetTreeDS(dataset: TDataset): TfObjectCard;
begin
    dsTreeSource := dataset;
    result := self;
end;

procedure TfObjectCard.TextToField(component: TComponent; text: string);
begin
    if   (component is TEdit)
    then (component as TEdit).Text := text;

    if   (component is TMemo)
    then (component as TMemo).Lines.Text := text;
end;

procedure TfObjectCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (owner is TfObjectCatalog) then (owner as TfObjectCatalog).ClearCardLink;
end;

procedure TfObjectCard.FormCreate(Sender: TObject);
begin
    DragAcceptFiles(Self.Handle, True);
end;

procedure TfObjectCard.FormDestroy(Sender: TObject);
begin
    DragAcceptFiles(Self.Handle, False);
end;

procedure TfObjectCard.WMDropFiles(var Msg: TWMDropFiles);
/// �� ������� ������:
/// https://habr.com/ru/post/179131/
var
  Catcher: TFileCatcher;
begin
  inherited;

  // � �������� ��������� ������ ��������� �������� ��� ��� ����������.
  // ��� ������� ������������ ���������, ������ � ����
  if Assigned(dsObjectSource) then
  if mngData.HasMainDoc( dsObjectSource.FieldByName('child').AsInteger ) then
  begin
      ShowMessage('�������� �������� ��� ��������.');
      exit;
  end;

  Catcher := TFileCatcher.Create(Msg.Drop);

  try

    if Catcher.FileCount = 0 then
    begin
        ShowMessage('���� �� ������.');
    end else
    if Catcher.FileCount > 1 then
    begin
        ShowMessage('�������� ������ ���� ����.');
    end else

    // ����� ������ ���� ������ ����, ��������� �������� ����� ���� ������ ����
    if   Catcher.FileCount = 1 then
    begin
        if  (GetFileAttributes( PChar(Catcher.Files[0]) ) and FILE_ATTRIBUTE_DIRECTORY) <> 0
        then ShowMessage('�������� ����, � �� ����������.')
        else
            if ExtractFileExt(ExtractFileName(Catcher.Files[0])) = '.lnk'
            then ShowMessage('�������� ����, � �� �����.')
            else AddFile( Catcher.Files[0] );
    end;

  finally
    Catcher.Free;
  end;

  // �������� Windows, ��� ��������� ����������
  Msg.Result := 0;
end;

procedure TfObjectCard.CheckIconSetupAllow;
/// ������ �� ���������� ����, ����������� ��� ���������� ������ �������
/// ��� ��������� �������, ��������� � ��������� �������� ������ ������������ � ������������ �����
/// ��� ��������� - �������� � ��������� �����
begin
    // ���� ������ �������, ���������� �� ����������� � ��������������
    if fKind in [KIND_ASSEMBL, KIND_COMPLEX, KIND_COMPLECT] then
    begin
        // � ������ �� ����������
        if not (fIcon in [KIND_SPECIF, KIND_ISPOLN]) then
        begin
            /// ������������� � ���������� ��� ������������
            icon.Text := dmSDQ('SELECT name FROM '+TBL_OBJECT_CLASSIFICATOR+' WHERE kind = ' + IntToStr(KIND_ISPOLN), '');
            fIcon := KIND_ISPOLN;
        end;
        bSelObjIcon.Enabled := true;
    end else
    begin
        /// ������������� � ���������� ��� ������������
        icon.Text := '';
        fIcon := 0;
        bSelObjIcon.Enabled := false;
    end;

end;

procedure TfObjectCard.CheckMaterialSetupAllow;
/// ������ �� ���������� ���� �������, ��������� ��� ���������
/// ��������� ��������
begin
    if fKind = 0 then exit;

    case fKind of
        KIND_DETAIL: bSelMaterial.Enabled := true;
        else
        begin
            bSelMaterial.Enabled := false;
            material_id.Text := '';
            fMaterial := 0;
        end;
    end;
end;

end.
