unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListBox, System.Rtti, FMX.Grid, ComObj,
  Data.DB, Data.Win.ADODB, FMX.ScrollBox, FMX.Memo, StrUtils, FMX.Objects, Math, shellApi;

const
    HELP_FILE = '\\server-htm\bdnft$\templates\TTLoader\������ ������ ����������.docx';

type

  TCellKind = (ckNone, ckMarshrut, ckTonnag, ckOtklon, ckPrice);

  TCellData = record
      value       : string[255];  // ����� � ������
      kind        : TCellKind;    // ��� ������
      marshrut_id : integer;      // �������. �������� ���: ckMarshrut, ckPrice.
      group_id    : integer;      // ������ ���������. �������� ���: ckMarshrut, ckOtklon.
      tonnag_id   : integer;      // ������. �������� ���: ckTonnag, ckOtklon, ckPrice.
      error       : string[255];  // ������, ���� ����
      info        : string[255];  // ��������� ���������� � ������ � ������
      warning     : string[255];  // ��������������, ���� ����

      city1       : string[255];  // ��������������� ���� ��� ������ ���������,
      city2       : string[255];  // ����� ������ ������� ������������� � ��
  end;

  TfMain = class(TForm)
    cbTender: TComboBox;
    lCaptionTT: TLabel;
    lCaptionFile: TLabel;
    bOpenFile: TButton;
    sgData: TStringGrid;
    OpenDialog1: TOpenDialog;
    bImport: TButton;
    pbAnalyze: TProgressBar;
    lOperation: TLabel;
    Rectangle1: TRectangle;
    bAutoAnalyze: TButton;
    lCaptionKinds: TLabel;
    Image1: TImage;
    bSettingsAutoanalyze: TButton;
    bSetMarshrut: TButton;
    Button4: TButton;
    Image2: TImage;
    bSetOtklon: TButton;
    bSetTonnage: TButton;
    bAnalyze: TButton;
    bSetClear: TButton;
    rMarshColor: TRectangle;
    rOtklonColor: TRectangle;
    rTonnageColor: TRectangle;
    rEmptyColor: TRectangle;
    bSetData: TButton;
    rDataColor: TRectangle;
    lCaptionPostav: TLabel;
    lCaptionAnalyze: TLabel;
    lCaptionImport: TLabel;
    Layout1: TLayout;
    bPostavSelect: TButton;
    Rectangle2: TRectangle;
    lPostavName: TLabel;
    Rectangle3: TRectangle;
    lFilename: TLabel;
    lInfo: TLabel;
    lError: TLabel;
    lSystem: TLabel;
    bCreateMarshruts: TButton;
    lWarning: TLabel;
    bCitySprav: TButton;
    Image3: TImage;
    procedure bOpenFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTenderChange(Sender: TObject);
    function Log(mess: string): string;
    procedure Operation(mess: string);
    procedure IncProgress;
    procedure SetProgress(max : real);
    procedure ResetProgress;
    procedure Info(text : string);
    procedure Error(text: string);
    procedure Warning(text: string);
    procedure System(data: TCellData);
    procedure ClearMess;
    procedure bRereadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgDataDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure sgDataSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure bAutoAnalyzeClick(Sender: TObject);
    procedure bSetMarshrutClick(Sender: TObject);
    procedure bSetOtklonClick(Sender: TObject);
    procedure bSetTonnageClick(Sender: TObject);
    procedure bSetDataClick(Sender: TObject);
    procedure bSetClearClick(Sender: TObject);
    procedure sgDataMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure sgDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure sgDataClick(Sender: TObject);
    procedure bPostavSelectClick(Sender: TObject);
    procedure bAnalyzeClick(Sender: TObject);
    procedure bImportClick(Sender: TObject);
    procedure sgDataEditingDone(Sender: TObject; const Col, Row: Integer);
    procedure bCreateMarshrutsClick(Sender: TObject);
    procedure bSettingsAutoanalyzeClick(Sender: TObject);
    procedure rMarshColorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCitySpravClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    _filename: string;      /// ��� ��������� �����
    _isSelectMode: boolean; /// ������� �� ����� ��������� ������ �����
    _selHP: integer;
    _postavID : integer;    /// ������������� ����������

    _missMarsh : integer;   /// ���������� ������������ ������������� ��������� �� ����� �������
    allMarsh   : integer;   /// ����� ���������� ��������� � ��������� ���������

    /// ���������� �������� � ���������� ������ ����� ������.
    /// �� �� ������ ����� ����� ��������� ���� �� ����� � ���������� (������������, ��������������)
    /// ��� ������ �� �������� ���������������
    firstMarshCell,   // ������ ����������� ������ ��������
    lastMarshCell,    // ��������� ����������� / ������� ��������������

    firstTonnagCell,  // ������ ����������� ������ �������
    lastTonnagCell,   // ��������� ����������� / ������� ��������������

    firstOtklCell,    // ������ ����������� ������ ����������
    lastOtklCell,     // ��������� ����������� / ������� ��������������

    firstDataCell,    // ������ ����������� ������ ������
    lastDataCell,     // ��������� ����������� / ������� ��������������

    selStart,         // ��������� ����� ��������� ����� � �������
    selFinish         // �������� ����� ��������� ����� � �������
        : TPoint;

    DocData: array of array of TCellData;

    procedure SetFileName(const Value: string); /// ������� �������� xls
    procedure AnalyzeData;
    procedure AutoAnalyzeKinds;
    function LoadDataFromFile: boolean;
    function OpenFile: boolean;
    procedure CloseFile;
    procedure ClearPoints;
    procedure SelSetStartCoord(col, row: integer);
    procedure SelSetFinishCoord(col, row: integer);
    procedure SetKind(kind : TCellKind);

    /// ������ ����������� ������ �� �������������� � ������������ ����� ������
    /// � ���������������� ��
    procedure ReadAsMarshrut(var CellData: TCellData; value: string);
    procedure ReadAsTonnage( var CellData: TCellData; value: string);
    procedure ReadAsPrice( var CellData: TCellData);

    procedure CreateMarshruts; // �������� � ������ �� ���� �� ������������ ���������.
    // ����������� ���� ��� ��� ������ ������� � ����� ��������� �������.

    procedure ClearCellData(var cell: TCellData);
    procedure CellAddError(var cell: TCellData; error: string);
    procedure CellAddInfo(var cell: TCellData; info: string);
    procedure CellAddWarning(var cell: TCellData; info: string);

    procedure ShowData; // ���������� ������������������ ������ �������
    function ClearUpName(name: string): string;

    procedure SetSelectMode(const Value: boolean);

    function ImportData: boolean;  /// ������ ������ � ����. ���� �������, ���������� ������
    procedure FullClearUp;
    procedure SetMissMarsh(const Value: integer);
    // ������ ������� ������ � ��������, ��� ���������� ��������� � ��������� ���������

    procedure SaveINI;   // ������ �������� �� �����
    procedure ReadINI;   // ������ �������� � ����

  public
    property FileName: string read _filename write SetFileName;

    property isSelectMode: boolean read _isSelectMode write SetSelectMode;
        /// �������� �� ��������� ������� �����
    property missMarsh : integer read _missMarsh write SetMissMarsh;

    function SetFileEnable(val: boolean): boolean;
    function SetPostavEnable(val: boolean): boolean;
    function SetKindsEnable(val: boolean): boolean;
    function SetAnalyzeEnable(val: boolean): boolean;
    function SetImportEnable(val: boolean): boolean;
  end;

var
    fMain: TfMain;

    exl: Variant;             // ��������� ������
    ExBk, ExSh: Variant;      // ��������� ����� � ����� ������
    exlRow, exlCol: integer;  // ������� ������


    // ������/������ � ���������� ������ ����� �����
    shbl_Marshrut : string = '������';
    shbl_Otklon : string   = '��������';
        // ����������� �������� ����� '��������� ������ ��/ ������� ��� ���������� �� ��������� ��������'
    shbl_Tonnage : string  =
        '"�� 1,5","�� 1.5","�� 1,5","�� 1.5","�� 5�","�� 5 �","�� 10�","�� 10 �","�� 18�","�� 18 �",����������';

    MAX_TABLE_HEIGHT: integer = 150;   /// �������� �� ����������� ������ ������ �� ����� � �������� � ��������.
    MAX_TABLE_WIDTH: integer = 20;    /// �������� �� ����������� ������ ������ �� ����� � �������� � ��������.

    INI_FILENAME: string = 'settings.ini';

implementation

{$R *.fmx}

uses uDM, uSelect, uSetupAutoanalyze, IniFiles, uColorPicker, uCitySprav;

procedure TfMain.AnalyzeData;
/// ������ ��������� ��������� excel �� ������������ ������ � ������� �� ��
/// ���������� ������ ��� ����������� � ������� ���������� ������.
/// ���������������, ��� ���� ����� � ������� ��� ���������� (������������� ��� �������).
/// ������ �� ������� ���� ����� ���������������.
///
///    ������ � ��������� ������

///    ���� 1. ����� ���������.
///    ������ ����� ������������� ����� �������, ������ ����.
///    ������ �� ������ ���������, ������� �� ������ ���������� ������� ��������� � ����������.
///    ��������������� �� � ������ ������� ���� �� ���������� text, group_id, marshrut_id.
///    �� ���������� ����� �������� ������ ������� (��� ������, � ����������� �� ����������).

///    ���� 2. ����� ��������.
///    �������� ������ ����� ���� ������ ������� ��������� � ��� ��������� �������� �������.
///    ��������� ��, ��������� � ������ �������� tonnage_id, �������� ������ �������.

///    ���� 3. ������.
///    ���, ��� ��������� ������ ��������� � ���� ������� � ������.
///    �������� ������ � ������ ������� � ��������� ��� �����.

///    ���� 4. ������������� ���������� � ���������.
///    ���������� ������� ��������� � � �������, ��� ���������� ������ ���������� � ������ ��� ���� ����� �� ��� ������ �������.
///    ��� ����� ��������� � ������� marshrut_id �� ��� ������ ������ �� ��� ������ �������.

///    ���� 6. ������������� �������.
///    ���������� ��� ������ ������� � ������� �������� tonnag_id �� ��� ������ ������� �� ��� ������ �������.

///    ���� 7. �������.
///    ���������� ������� � ������ � �������� ��, ������� �������� ������ ������ ������
var
    CellData: TCellData;
    i : integer;
    text: string;
begin

    /// ����� ������ � ���������
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        DocData[ exlCol, exlRow ].error := '';
        DocData[ exlCol, exlRow ].info := '';
        DocData[ exlCol, exlRow ].warning := '';
    end;



    missMarsh := 0;
    allMarsh  := 0;

    ///1 ����
    Operation('��������� ���������...');
    ResetProgress;

    firstMarshCell.X := -1;
    firstMarshCell.Y := -1;
    lastMarshCell.X := -1;
    lastMarshCell.Y := -1;

    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        IncProgress;

        CellData := DocData[ exlCol, exlRow ];

        if CellData.kind = ckMarshrut then
        Begin
            Inc(allMarsh);

            // �� ������ � ������ ��������� �� ���� id �������� � ������� ��������� (������ ���������, �������)
            ReadAsMarshrut( CellData, CellData.value );
            DocData[ exlCol,exlRow ] := CellData;

        End;

        /// � �������� ��� �� ��������� ������-��������� ����������, �������������� ������ ���������
        if CellData.kind = ckOtklon then
        Begin
            // ���������� ��������� � ����� ������ ���������, ��� � ���������
            // ����������� ������ ��������
            CellData.group_id := DocData[ lastMarshCell.X, lastMarshCell.Y ].group_id;

            DocData[ exlCol,exlRow ] := CellData;
        End;

    end;


    ///2 ����
    Operation('��������� �������...');
    ResetProgress;

    firstTonnagCell.X := -1;
    firstTonnagCell.Y := -1;
    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;

    firstOtklCell.X := -1;
    firstTonnagCell.Y := -1;
    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;

    /// ����� ���������.
    ///    � ������ ������������ ������ ��������� �������� ����� �������
    ///    �� ������ - ��������� �������/�� �������
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    begin
        IncProgress;

        CellData := DocData[ exlCol, exlRow ];

        if CellData.kind = ckTonnag then
        Begin
            // ��������� ����� ����c�� � ���������
            if firstTonnagCell.X = -1 then
            begin
                firstTonnagCell.X := exlCol;
                firstTonnagCell.Y := exlRow;
            end;

            ReadAsTonnage( CellData, CellData.value );
            DocData[ exlCol,exlRow ] := CellData;

            // �������� ����� ����c�� � ���������
            lastTonnagCell.X := exlCol;
            lastTonnagCell.Y := exlRow;
        End;


        /// ������� ������������ ������������� ������������� ����������.
        ///    �� ���������� ����� ����������� �������������, ����������
        ///    ������ � ������������ ����� ���������.
        ///    ������, ����� �������������� ������ ���������� �� ��� ������
        if CellData.kind = ckOtklon then
        Begin

            // ��������� ����� ����c�� � ���������.
            // ����� ����������� � ��������� ���������
            if (firstOtklCell.X = -1) or            // ������ �����������
               (firstOtklCell.Y <> lastOtklCell.Y)  // ��������� �����������
            then
            begin
                firstOtklCell.X := exlCol;
                firstOtklCell.Y := exlRow;
            end;

            CellData.group_id := DocData[firstOtklCell.X, firstOtklCell.Y].group_id;

            // �������� ��������
            if (Trim(CellData.value) <> '') and (StrToFloatDef( Trim(CellData.value), -1) = -1)
            then CellAddError( CellData, '������������ �����' );

            DocData[ exlCol, exlRow ] := CellData;

            lastOtklCell.Y := exlRow;
        End;
    end;


    /// ������� ���� ������ ������, ����������� id � �������� �������� �� �����
    Operation('��������� ������...');
    ResetProgress;

    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    begin
        IncProgress;

        CellData := DocData[ exlCol, exlRow ];

        if CellData.kind = ckPrice then
        Begin
            ReadAsPrice( CellData );
            DocData[ exlCol, exlRow ] := CellData;
        End;
    end;

    ResetProgress;
    Operation('');

end;

procedure TfMain.ReadAsTonnage( var CellData: TCellData; value: string);
/// ����� �� ������ ������ �������� ��������� �� �������� � ����������� �������.
/// ��������� � ���, ��� ����� ��������� ������ ���� �������, ����� ����������
/// �������� �� �����������.
///
/// � ������ ���������� �������� ����: '�� 1,5 �.'
/// �� ������ ����� �������� ����: '���������� ����'
///
/// ������, ����� ��������������� � ����� ����� ������ �� ���������.
/// ��� ����� ����������� ���������� ��������� ����� ������� �������.
///
/// ��� ������ ������� �� ������������� ����� ����������� ������ � ������ ������.
/// ��� ������ ������� �� ���������� �������� �������� ���� ������� � ����������� ������� ������� �����������
///
Var
    tonnag: string;
    res: TTonnag;
begin
    // ��������� ������� �����
    if (firstTonnagCell.Y = exlRow) then
    begin
        if Trim(value) = '' then
           // ����� ���������� ����������� ������� � ������� ������
           CellData.value := DocData[ lastTonnagCell.X, lastTonnagCell.Y].value;
    end else
    begin
        /// �������� id ������������� �������� ����������� �� ������� �� ���������
        tonnag := Trim(value + ' ' + DocData[ exlCol, exlRow - 1 ].value);
        res := DM.GetTonnag( tonnag );

        if res.tonnag_id = -1 then
        begin

            fSelect.DecoratonState(false);
            fSelect.SetMarshrut('������: ' + tonnag);
            fSelect.ClearList;

            DM.spTonnag.First;
            while not DM.spTonnag.Eof do
            begin
                fSelect.AddList(
                    DM.spTonnag.FieldByName('name').AsString,
                    TObject(DM.spTonnag.FieldByName('id').AsInteger)
                );
                DM.spTonnag.Next;
            end;

            if fSelect.ShowModal = mrOk then
            begin
                res.tonnag_id := Integer(fSelect.selData);
                res.tonnag := fSelect.selText;

                // ��������� �������������� ������������� � ����
                DM.SaveTonnagAlternate(
                    Trim(value + ' ' + DocData[ exlCol, exlRow - 1 ].value),
                    res.tonnag_id
                );

                // ������������ ����������� ��������� ��������
                DM.tTonnagAlternate.Close;
                DM.tTonnagAlternate.Open;

            end;
        end;

        CellData.tonnag_id := res.tonnag_id;
        CellData.info := '������:' + sLineBreak + res.tonnag;

    end;
end;


procedure TfMain.ReadINI;
var
    ini : TINIFile;
begin
    if not FileExists( ExtractFilePath(paramstr(0)) + INI_FILENAME ) then exit;

    ini := TIniFile.Create( ExtractFilePath(paramstr(0)) + INI_FILENAME );

    // ������� ����������� ����� ��������
    shbl_Marshrut := ini.ReadString('', 'marshrut', shbl_Marshrut);
    shbl_Otklon   := ini.ReadString('', 'otklon',   shbl_Otklon);
    shbl_Tonnage  := ini.ReadString('', 'tonnage',  shbl_Tonnage);

    // ����� ����� ������
    rMarshColor.Fill.Color   := TColor(ini.ReadInteger('', 'marshrut_color', Integer(rMarshColor.Fill.Color)));
    rOtklonColor.Fill.Color  := TColor(ini.ReadInteger('', 'otklon_color',   Integer(rOtklonColor.Fill.Color)));
    rTonnageColor.Fill.Color := TColor(ini.ReadInteger('', 'tonnage_color',  Integer(rTonnageColor.Fill.Color)));
    rDataColor.Fill.Color    := TColor(ini.ReadInteger('', 'price_color',    Integer(rDataColor.Fill.Color)));

    ini.Free;
end;

procedure TfMain.ReadAsMarshrut( var CellData: TCellData; value: string);
///    ������� ������������� �������� ������ ��� ��������.
///    ������ ������:  �����1-�����2
///    ��� �� �� ������� ������ ����� ���������� ������ ���������:
///    1 ������ () - �����1 = ������ (������� �� ������)
///    2 ������ - �����2 = ������ (������� � ������)
///    �������� ������ ���� ���������, �� ���� ���.
var
    otherCity                // ������������ ������ � ���� � �������
   ,codeCity                 // ��� ������ �� �����������
            : string;
    cityArr : TNameArr;
    i : integer;
begin

    /// ����������, ���� ��� ������ ����������� ������ �������� (������ ������� ���������)
    if firstMarshCell.X = -1 then
    begin
        firstMarshCell.X := exlCol;
        firstMarshCell.Y := exlRow;
    end;
    // ���������� ��� ������� ���������������
    lastMarshCell.X := exlCol;
    lastMarshCell.Y := exlRow;


    // ������� ���������� ������� ��� �������� ������
    value := trim(value);


    CellData.kind := TCellKind.ckMarshrut;
    CellData.value := value;



    // ��������� ��� ������� ������, ���� ��� ������ ���� ������� � ������
    otherCity := ReplaceStr(AnsiUpperCase(value), '������', '');
    otherCity := ClearUpName(otherCity);

    cityArr := DM.GetCityCode(otherCity);
            // ������� ���������� ������ ���� �������, �� ������� ������� ���������

    if Length(cityArr) = 0
    then CellAddError( CellData, '� ����������� �� ��������� ��� ��� ������ ' + otherCity)
    else

    if Length(cityArr) = 1
    then
    begin
        DM.SaveCityAlternate(
            otherCity,
            cityArr[ 0 ].city,
            cityArr[ 0 ].cityCode
        );

        codeCity := cityArr[0].cityCode;
        otherCity := cityArr[0].city;
    end
    else

    // ������� ����� ������ ������� ��������
    begin
        fSelect.DecoratonState(true);
        fSelect.SetMarshrut(value);
        fSelect.ClearList;

        for I := 0 to High(cityArr) do
           fSelect.AddList(
               cityArr[i].cityCode + ' - ' +
               cityArr[i].city +
               ifthen(cityArr[i].present_past, '', ' (��� ���������)'),
               nil
           );

        if fSelect.ShowModal = mrOk then
        begin
           // ��������� �������������� ������������� � ����
           DM.SaveCityAlternate(
               otherCity,
               cityArr[ fSelect.selIndex ].city,
               cityArr[ fSelect.selIndex ].cityCode
           );

           codeCity := cityArr[ fSelect.selIndex ].cityCode;
           otherCity := cityArr[ fSelect.selIndex ].city;
        end else
        CellAddError( CellData, '� ����������� �� ��������� ��� ��� ������ ' + otherCity);

    end;


    // ���������� ������ ���������
    if Pos('������', AnsiUpperCase(value)) = 1 then
    begin

        // ������������� ������ ���������
        CellData.group_id := 0;

        CellData.city1 := DM.codeTyumen;
        CellData.city2 := codeCity;

        CellData.marshrut_id := DM.GetMarshrut(DM.codeTyumen, codeCity);
        if CellData.marshrut_id = -1 then
        begin
            CellAddWarning( CellData, '������� � ������ �� ��� �� ������');
            missMarsh := missMarsh + 1;
        end;

        CellAddInfo( CellData, '�������:' + sLineBreak + '������ - ' + otherCity);
    end

    else if Pos('������', AnsiUpperCase(value)) = Length(value) - Length('������') + 1 then
    begin

        // ������������� ������ ���������
        CellData.group_id := 1;

        CellData.city1 := codeCity;
        CellData.city2 := DM.codeTyumen;

        // ������������� �������
        CellData.marshrut_id := DM.GetMarshrut(codeCity, DM.codeTyumen);
        if CellData.marshrut_id = -1 then
        begin
            CellAddWarning( CellData, '������� � ������ �� ��� �� ������');
            missMarsh := missMarsh + 1;
        end;

        CellAddInfo( CellData, '�������:' + sLineBreak + otherCity + ' - ������');

    end else

    Begin

        CellAddError( CellData, '�� ������� ���������� ������ ���������');
        Log('�� ������� ���������� ������ ��������� ���: ' + value);
        exit;

    End;

end;

procedure TfMain.ReadAsPrice(var CellData: TCellData);
/// ���������� ������ �������� �������� � �������
var
    i : integer;
begin
    // ���� ������ (� ������� ���� ������)
    for I := exlRow-1 downto 0 do
    begin
        if DocData[ exlCol, i ].tonnag_id > -1 then
        begin
            CellData.tonnag_id := DocData[ exlCol, i ].tonnag_id;
            break;
        end;
    end;

    // ���� ������� (� ������ ����� ������)
    for I := exlCol-1 downto 0 do
    begin
        if DocData[ i, exlRow ].marshrut_id > -1 then
        begin
            CellData.marshrut_id := DocData[ i, exlRow ].marshrut_id;
            break;
        end;
    end;

    // �������� ��������
    if (Trim(CellData.value) <> '') and (StrToFloatDef( Trim(CellData.value), -1) = -1)
    then CellAddError( CellData, '������������ �����' );

end;

procedure TfMain.ResetProgress;
begin
    pbAnalyze.Value := 0;
    Application.ProcessMessages;
end;

procedure TfMain.rMarshColorClick(Sender: TObject);
begin
    if not Assigned( fColorPicker ) then
        fColorPicker := TfColorPicker.Create(self);

    fColorPicker.rectangle := (sender as TRectangle);

    fColorPicker.rColorPanel.Parent := fMain.Layout1;
    fColorPicker.rColorPanel.Position.X := bSetClear.Position.X;
    fColorPicker.rColorPanel.Position.Y := bSetClear.Position.y + bSetClear.Height;
end;

procedure TfMain.ShowData;
var
    col, row
        : integer;
begin

    // ��������� ������� ��� �����������
    // ��������� �������
    while sgData.ColumnCount < MAX_TABLE_WIDTH do
    sgData.AddObject( TStringColumn.Create(sgData) );

    // ��� �������
    while sgData.ColumnCount > MAX_TABLE_WIDTH do
    sgData.Columns[ sgData.ColumnCount - 1 ].Destroy;

    sgData.RowCount := MAX_TABLE_HEIGHT;



    for row := 0 to MAX_TABLE_HEIGHT - 1 do
    for col := 0 to MAX_TABLE_WIDTH - 1 do
    begin
        sgData.Cells[col, row] := DocData[col, row].value;
    end;

end;


procedure TfMain.System(data: TCellData);
begin
    lSystem.Text := '';

    if data.marshrut_id > -1 then
    lSystem.Text := lSystem.Text + 'marshrut_id = ' + IntToStr(data.marshrut_id) + sLineBreak;

    if data.group_id > -1 then
    lSystem.Text := lSystem.Text + 'group_id = ' + IntToStr(data.group_id) + sLineBreak;

    if data.tonnag_id > -1 then
    lSystem.Text := lSystem.Text + 'tonnag_id = ' + IntToStr(data.tonnag_id);
end;


procedure TfMain.bOpenFileClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
   begin
       FileName := OpenDialog1.FileName;

       if not OpenFile then exit;

       LoadDataFromFile;

       CloseFile;

       ShowData;

       SetPostavEnable( True );
   end;
end;

procedure TfMain.bPostavSelectClick(Sender: TObject);
begin
    fSelect.SetMarshrut('���������');
    fSelect.DecoratonState(false);
    fSelect.ClearList;


    Operation('���������� ����������� �����������...');
    ResetProgress;

    DM.spPostav.First;
    while not DM.spPostav.eof do
    begin
       fSelect.AddList(
           DM.spPostav.FieldByName('naim').AsString + ' ' +
           DM.spPostav.FieldByName('inn').AsString,
           TObject(DM.spPostav.FieldByName('ID').AsInteger)
       );

       IncProgress;

       DM.spPostav.next;
    end;

    Operation('');
    ResetProgress;


    if fSelect.ShowModal = mrOk then
    begin
        _postavID := Integer(fSelect.selData);
        lPostavName.Text := fSelect.selText;

        SetKindsEnable( true );
        SetAnalyzeEnable( true );
    end;

end;

procedure TfMain.bRereadClick(Sender: TObject);
begin
    ShowData;
end;

procedure TfMain.bSetClearClick(Sender: TObject);
begin
    SetKind( TCellKind.ckNone );
    sgData.Repaint;
end;

procedure TfMain.bSetDataClick(Sender: TObject);
begin
    SetKind( TCellKind.ckPrice );
    sgData.Repaint;
end;

procedure TfMain.bSetMarshrutClick(Sender: TObject);
begin
    SetKind( TCellKind.ckMarshrut );
    sgData.Repaint;
end;

procedure TfMain.bSetOtklonClick(Sender: TObject);
begin
    SetKind( TCellKind.ckOtklon );
    sgData.Repaint;
end;

procedure TfMain.bSettingsAutoanalyzeClick(Sender: TObject);
begin
    if not Assigned(fSetupAutoanalyze) then
        fSetupAutoanalyze := TfSetupAutoanalyze.Create(self);

    fSetupAutoanalyze.marshrut := shbl_Marshrut;
    fSetupAutoanalyze.otklon   := shbl_Otklon;
    fSetupAutoanalyze.tonnag   := shbl_Tonnage;

    if fSetupAutoanalyze.ShowModal = mrOk then
    begin
        shbl_Marshrut := fSetupAutoanalyze.marshrut;
        shbl_Otklon   := fSetupAutoanalyze.otklon;
        shbl_Tonnage  := fSetupAutoanalyze.tonnag;

        SaveINI;
    end;
end;

procedure TfMain.bSetTonnageClick(Sender: TObject);
begin
    SetKind( TCellKind.ckTonnag );
    sgData.Repaint;
end;

procedure TfMain.Button4Click(Sender: TObject);
begin
    if FileExists( HELP_FILE ) then
    ShellExecute(0,'open',HELP_FILE,nil,nil,1{SW_SHOWNORMAL});
end;

procedure TfMain.SetKind(kind : TCellKind);
var
    top, bottom, left, right : integer;
    col, row: integer;
begin
    top := Min(selStart.Y, selFinish.Y);
    bottom := Max(selStart.Y, selFinish.Y);
    left := Min(selStart.X, selFinish.X);
    right := Max(selStart.X, selFinish.X);

    for row := top to bottom do
    for col := left to right do
    DocData[ col, row ].kind := kind;

end;

function TfMain.SetKindsEnable(val: boolean): boolean;
begin
    result := val;
    bAutoAnalyze.Enabled := val;
    bSetMarshrut.Enabled := val;
    bSetOtklon.Enabled := val;
    bSetTonnage.Enabled := val;
    bSetData.Enabled := val;
    bSetClear.Enabled := val;

    if val
    then lCaptionKinds.FontColor := TAlphaColorRec.Black
    else lCaptionKinds.FontColor := TAlphaColorRec.Gray;

end;

procedure TfMain.SetMissMarsh(const Value: integer);
begin
    _missMarsh := value;

    if value <> 0 then
    begin
        bCreateMarshruts.Enabled := true;
        bCreateMarshruts.Text := '������� �������� (' + IntToStr(missMarsh) + ')'
    end else
    begin
        bCreateMarshruts.Enabled := false;
        bCreateMarshruts.Text := '������� ��������';
    end;



end;

procedure TfMain.AutoAnalyzeKinds;
/// �������� ������, ���������� ���� ����� � ���������� ��� �������.
/// ���� ����� �������� ������ ����������� ����� �������������.
/// �� ����, ��� ������ ���� ���������� �����������, ����� ������������ �� �������� �������� ������.
/// � ������ ������ ���������, ������������ ����� ������ ���������� ������ ����� �������� ������.
///
/// ���������������� �������� ������ �� ������ ���� ����������� ���������� ��� ������.
/// � �������, ������ ������ ����� ���� ������, � ������, �� ��������� ���������� ����� ���������� ������� ������� ������.
/// ��, ������� ������ ������� ��������� ����������� ���������(�����) � �������� (��������).
/// ��� ��, �������� ������� ������� �������� ���������� ������� �������� ��� ����������.
///    ��������:
///    1. ��������� ��� ������, ������� ���������� ����: �������, ������, ����������.
///       ���� ������� �� ���������� �������� ������ �� �������������, � ������ ������������� �� ������� ��������,
///       ������� �������� �������������.
///       ��������, ������� ����������� �������� "������", ������ ����� ���� "�� 1,5�" � �.�.
///    2. �� ����� ������� ���������� ������� ���������� ������� ���� ������������ �����:
///       ����� �������, ����� ������ � �.�. ��� ��������� ��������� ���������� �������.
///    3. �� ��������� ����������� ��������� ������� � ����� �����
var
    CellData: TCellData;
    text: string;
    list: TStringList;

    _top, _left, _right, _bottom: integer;   // ������� ������� �������      \
    lastKind : TCellKind;

    function inList(shablon, text: string): boolean;
    var
        i : integer;
    begin
        result := false;

        list.CommaText := shablon;

        for I := 0 to list.Count-1 do
        if Pos(AnsiUpperCase(list[i]), AnsiUpperCase(text)) > 0
        then
           result := true;
    end;

    function IsMarshrut(text: string): boolean;
    /// ����������, �������� �� ������ ���������.
    /// ��������� ������ ������ ����� ���� ������� �����, ������� ����� ������
    begin
        result := inList( shbl_Marshrut, text );

        if not result then exit;

        /// ����������, ���� ��� ������ ����������� ������ �������� (������ ������� ���������)
        if firstMarshCell.X = -1 then
        begin
            firstMarshCell.X := exlCol;
            firstMarshCell.Y := exlRow;
        end;

        // ���������� ��� ������ ����� ����������� �������
        lastMarshCell.X := exlCol;
        lastMarshCell.Y := exlRow;
    end;


    function IsOtklon(text: string): boolean;
    /// ����������, �������� �� ������ ���������� ������ ����������
    begin
        result := inList( shbl_Otklon, text );
    end;

    function IsTonnag(text: string): boolean;
    /// ����������, �������� �� ������ ��������
    begin
        result := inList( shbl_Tonnage, text );

        if not result then exit;

        /// ����������, ���� ��� ������ ����������� ������ ������� (������ �������)
        if firstTonnagCell.X = -1 then
        begin
            firstTonnagCell.X := exlCol;
            firstTonnagCell.Y := exlRow;
        end;

        // ���������� ��� ������ ����� ����������� �������
        lastTonnagCell.X := exlCol;
        lastTonnagCell.Y := exlRow;
    end;

begin

    Operation('1/3 ����������� ����� ���������...');
    ResetProgress;

    list := TStringList.Create;

    firstMarshCell.X := -1;
    firstMarshCell.Y := -1;
    lastMarshCell.X := -1;
    lastMarshCell.Y := -1;

    firstTonnagCell.X := -1;
    firstTonnagCell.Y := -1;
    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;


    // � ������ ������ ������� ������� ��������� � ����������� ��������� ������� ����������.
    // ������� ��� ���������� ����� ����� "���������" �� ������ ��������� �������
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin

        IncProgress;



        text := DocData[ exlCol, exlRow ].value;

        if IsMarshrut(text) then DocData[ exlCol,exlRow ].kind := ckMarshrut else
        if IsOtklon(text)   then DocData[ exlCol,exlRow ].kind := ckOtklon else
        DocData[ exlCol,exlRow ].kind := ckNone;

    end;


    Operation('2/3 ����������� ����� �������...');
    ResetProgress;

    /// ����� ������� ���������� ���������, ��������� ��������������, ��� ��
    /// ���������� � ����� ������������� �������.
    ///   ��� ����, ���� ��������, ��� ��������� �������� � ��� ������ ������ � ������ ���� ������� ��������,
    ///   ������, �� ����������� ������ ���� ������� ������ ���� ���������, ��� ������� ������ �������� ��������.
    ///   ��������� � ������ ������ ��������� ��������� ������������ �������� � ��� ��� �������������,
    ///   ����� ������� ������ ����� ������� ������ ������, ��� ��� ������ �����.
    /// ��� ���, ����������� ������� - ���������� ������:
    ///    - �������� �� ����� ���������, ��������� �������� ������ ������� � ������� �������
    ///    - �������� �������� �� ������� ������� � �������� ������� ������� ������� ������ �������
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    begin

        IncProgress;

        text := DocData[ exlCol, exlRow ].value;

        if IsTonnag(text)  then DocData[ exlCol,exlRow ].kind := ckTonnag;

    end;

    _top := Min(firstTonnagCell.Y, lastTonnagCell.Y);
    _bottom := Max(firstTonnagCell.Y, lastTonnagCell.Y);
    _left := Min(firstTonnagCell.X, lastTonnagCell.X);
    _right := Max(firstTonnagCell.X, lastTonnagCell.X);

    for exlRow := _top to _bottom do
    for exlCol := _left to _right do
    begin
        DocData[ exlCol,exlRow ].kind := ckTonnag;
    end;



    Operation('3/3 ����������� ����� ������...');
    ResetProgress;

    /// �� ������ ����� ����� ��� ���������� ��� ��������� ������: ��� �����������
    /// ��������� �������� ��������� � �������. ���������, �� ������ ����� ��
    /// ��������� �������� ������, ������� � ������ ��� ������ ������.
    /// �������������, �� ���� ����� ��������� "���������" ������� ���������� �� ������ ������.

    /// ���������� �������, � ������� ���������� ������.
    ///    ����� ����������� � ������� ���������, ����� ���� ����������� ����������
    ///    � ������ ��� ����������� ��������� ������� �������������� ������.
    /// +1 ���������� �����, ��������� ��� ����� � ����� ���������� ����������

    /// ��������������, ��� ��� ����� ������ �� ����� ������ ���������

    for exlRow := firstMarshCell.Y to lastMarshCell.Y + 1 do
    for exlCol := firstMarshCell.X to lastTonnagCell.X do
    begin

        IncProgress;

        // ���������� ��� ��������� ����������� �������������� ������
        if   DocData[ exlCol,exlRow ].kind <> ckNone
        then lastKind := DocData[ exlCol,exlRow ].kind;

        if DocData[ exlCol,exlRow ].kind <> ckNone then Continue;

        if lastKind = ckMarshrut then DocData[ exlCol,exlRow ].kind := ckPrice;
        if lastKind = ckOtklon then DocData[ exlCol,exlRow ].kind := ckOtklon;

    end;



    ResetProgress;
    Operation('');

    list.Free;
end;

procedure TfMain.bAnalyzeClick(Sender: TObject);
begin
    AnalyzeData;
    ShowData;

    sgData.Repaint;

    DM.OpenAlternate;

    SetImportEnable( missMarsh = 0 );
end;

procedure TfMain.bAutoAnalyzeClick(Sender: TObject);
begin
     AutoAnalyzeKinds;
     sgData.Repaint;
end;

procedure TfMain.bCitySpravClick(Sender: TObject);
begin
    if not Assigned( fCitySprav ) then
        fCitySprav := TfCitySprav.Create(self);

    fCitySprav.Clear;

    DM.spCityAlternate.First;
    while not DM.spCityAlternate.eof do
    begin
        fCitySprav.AddItem(
          [ DM.spCityAlternate.FieldByName('city').AsString,
            DM.spCityAlternate.FieldByName('alt_city').AsString,
            DM.spCityAlternate.FieldByName('alt_code').AsString ],

            DM.spCityAlternate.FieldByName('id').AsInteger
        );
        DM.spCityAlternate.next;
    end;


    fCitySprav.ShowModal;

    if fCitySprav.wasDeleted = true then
    begin
        DM.OpenAlternate;
        bAnalyze.OnClick(bAnalyze);
    end;

end;

procedure TfMain.bCreateMarshrutsClick(Sender: TObject);
begin
    // ���� ���� ������������� �������� � ��� ���� �� ���������� �� ��������� � �����,
    // ���� ���������� �� ������ ������������. ��������� � ����� ��������� ������� ���
    // ���������� ������ ���������. ��������, ������������ ������ ������ � ���� ����������
    // �� ������ ����, ��� ������ ��������� ����������.
    if (missMarsh > 0) and (missMarsh <> allMarsh) then
    if MessageDlg(
        '��� �� ������ �������� ������ � ��������� ������� � ���������� ����� ��������.' + sLineBreak +
        '��������, �� �������� ��� ������ ������� ��� ������� ���� �� �� ��� ���.' + sLineBreak +
        '�� �������, ��� ��������� ������� ��������� ������� � ����������� ����?',
        TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
        0
    ) = mrNo then exit;

    /// ������� ����� ��������
    CreateMarshruts;

    /// ������������� ���� ��� ��������� ������������ ������
    DM.InitDB;

    /// ����� ��������� ������
    AnalyzeData;
    ShowData;
    sgData.Repaint;

    SetImportEnable( missMarsh = 0 );
end;

procedure TfMain.bImportClick(Sender: TObject);
begin
    // ���� ������ ������, ��� ������ ���������, ����� ���������� �������
    if   ImportData
    then FullClearUp;
end;

procedure TfMain.cbTenderChange(Sender: TObject);
begin
    if cbTender.ItemIndex = -1 then exit;

    DM.TenderId := integer(cbTender.Items.Objects[ cbTender.ItemIndex ]);
    ClearPoints;
    DM.InitDB;
    DM.OpenAlternate;

    SetFileEnable( DM.AllowDBStructure );
end;

procedure TfMain.CellAddError(var cell: TCellData; error: string);
begin
    cell.error := cell.error + error + sLineBreak;
end;

procedure TfMain.CellAddInfo(var cell: TCellData; info: string);
begin
    cell.info := cell.info + info + sLineBreak;
end;

procedure TfMain.CellAddWarning(var cell: TCellData; info: string);
begin
    cell.warning := cell.warning + info + sLineBreak;
end;

procedure TfMain.ClearCellData(var cell: TCellData);
begin
//    cell.value := '';
    cell.kind := ckNone;
    cell.marshrut_id := -1;
    cell.group_id := -1;
    cell.tonnag_id := -1;
    cell.error := '';
    cell.info := '';
    cell.city1 := '';
    cell.city2 := '';
    cell.warning := '';
end;

procedure TfMain.ClearMess;
begin
    lInfo.Text := '';
    lError.Text := '';
    lSystem.Text := '';
    lWarning.Text := '';
end;

procedure TfMain.ClearPoints;
begin
    firstMarshCell.X := -1;
    firstMarshCell.Y := -1;

    lastMarshCell.X := -1;
    lastMarshCell.Y := -1;

    firstTonnagCell.X := -1;
    firstTonnagCell.Y := -1;

    lastTonnagCell.X := -1;
    lastTonnagCell.Y := -1;

    firstDataCell.X := -1;
    firstDataCell.Y := -1;

    lastDataCell.X := -1;
    lastDataCell.Y := -1;
end;

function TfMain.ClearUpName(name: string): string;
/// ����� ������� ������������ ������ �� ������.
///    �������� - ������� � ���������� ������������� ������
///    ����� ��������� ������ ������� ��� ������� ������ ������ � �����.
///    �� ��� ����� ����������, ����� ��������� �����-����� ���������� ������������ ������
begin
    name := trim(name);
    if name[1] = '-' then name[1] := Char(' ');
    if name[Length(name)] = '-' then name[length(name)] := Char(' ');
    name := trim(name);
    result := name;
end;

procedure TfMain.CloseFile;
begin
    exl.Visible := false;
    exl := Unassigned;
end;

procedure TfMain.CreateMarshruts;
/// ���������� ��� �������� � ����������� �������� ���������,
/// ������� ������� �����������.
/// �������� ��������� �� ������� ������� �� ������� ��������� ������
/// ������������ ��� ������ ��������� �������/�����.
/// ������� ���������� �������� ����� �������, ��� ������� ��������� ��������� �������� �� ������ �
/// ���� ���������������� �����������, ��� ������������ �� ��� ���-�� ����������.
begin

    Operation('�������� ����������� ���������...');
    ResetProgress;

    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        IncProgress;

        if DocData[ exlCol, exlRow ].kind = ckMarshrut then
        DM.CreateMarshrut(
            DocData[ exlCol, exlRow ].group_id,
            DocData[ exlCol, exlRow ].city1,
            DocData[ exlCol, exlRow ].city2
        );

    end;

    DM.OpenMarshrut;

    ResetProgress;
    Operation('');

end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SaveINI;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
    SetProgress( MAX_TABLE_HEIGHT * MAX_TABLE_WIDTH );
    ResetProgress;
    Operation('');

    // �������������� ������ ������
    SetLength(DocData, 0, 0);
    SetLength(DocData, MAX_TABLE_WIDTH, MAX_TABLE_HEIGHT);
end;

procedure TfMain.FormShow(Sender: TObject);
begin

   if not DM.OpenQuery(SQL_GET_TENDER_LIST) then exit;

   while not DM.ADOQuery.Eof do
   begin

       cbTender.Items.AddObject(

           Format( '%s (%s) %s-%s',
               [   DM.ADOQuery.FieldByName('NAME').AsString,
                   DM.ADOQuery.FieldByName('TD_NUM').AsString,
                   DM.ADOQuery.FieldByName('DATE_BEGIN').AsString,
                   DM.ADOQuery.FieldByName('DATE_END').AsString
               ]
           ),
           TObject(DM.ADOQuery.FieldByName('ID').AsInteger)

       );

       DM.ADOQuery.Next;
   end;

   SetFileEnable(false);
   SetPostavEnable(false);
   SetKindsEnable(false);
   SetAnalyzeEnable(false);
   SetImportEnable(false);

   ClearMess;
   missMarsh := 0;

   ReadINI;
end;


procedure TfMain.FullClearUp;
var
    row, col: integer;
begin

    FileName := '';

    _postavID := 0;
    lPostavName.Text := '';
    SetPostavEnable( false );

    SetKindsEnable( false );
    SetAnalyzeEnable( false );
    SetImportEnable( false );

    // ������� ������
    while sgData.ColumnCount > 0 do
    sgData.Columns[ sgData.ColumnCount - 1 ].Destroy;

    sgData.RowCount := MAX_TABLE_HEIGHT;

    for row := 0 to MAX_TABLE_HEIGHT - 1 do
    for col := 0 to MAX_TABLE_WIDTH - 1 do
        ClearCellData( DocData[col, row] );

end;

function TfMain.ImportData: boolean;
/// ������ ������������ ������ � ����. �� ������ ����� ���� ��������� �������:
///    - ��������� ������� �������
///    - ������ ��������� � �������� � ���� ����������
///    - ��� ��������� ����������� ������ ����� ��� ����������� ������ ��� �������
///    - ������������ ������ ����� �������� �������� CellData.error � ���� ���������������
/// ��� ����������������� ������� ����� �������������� ���� �������� � ������
/// ���������� ������ ������ �������� �������� ���������.
/// ��� ������������ � ���� ������ � ������ ����������� ����� ���������.
begin
    DM.ClearData;

    Operation('������ ������...');
    ResetProgress;

    for exlCol := 0 to MAX_TABLE_WIDTH -1 do
    for exlRow := 0 to MAX_TABLE_HEIGHT -1 do
    begin
        IncProgress;

        /// ��������, ���������� ������ ������
        if (DocData[ exlCol, exlRow ].kind = ckPrice) and
           (DocData[ exlCol, exlRow ].value <> '') and
           (DocData[ exlCol, exlRow ].error = '')
        then
           DM.InsertData(
               DocData[ exlCol, exlRow ].marshrut_id,
               DocData[ exlCol, exlRow ].tonnag_id,
               _postavID,
               StrToFloat(DocData[ exlCol, exlRow ].value)
           );

        // ��������, ���������� ������ ����������
        if (DocData[ exlCol, exlRow ].kind = ckOtklon) and
           (DocData[ exlCol, exlRow ].value <> '') and
           (DocData[ exlCol, exlRow ].error = '')
        then
           DM.InsertOtklon(
               DocData[ exlCol, exlRow ].marshrut_id,
               DocData[ exlCol, exlRow ].tonnag_id,
               _postavID,
               StrToFloat(DocData[ exlCol, exlRow ].value)
           );

    end;

    ResetProgress;
    Operation('');

    result := true;
end;

procedure TfMain.IncProgress;
begin
    pbAnalyze.Value := pbAnalyze.Value + 1;
    Application.ProcessMessages;
end;

procedure TfMain.Info(text: string);
begin
    lInfo.Text := text;
end;

procedure TfMain.Error(text: string);
begin
    lError.Text := text;
end;

procedure TfMain.Warning(text: string);
begin
    lWarning.Text := text;
end;

function TfMain.LoadDataFromFile: boolean;
/// ��������� ����, ��������� ������ � ������, ��������� ����.
/// ���������� ��������� excel � ������ ��� �� �����.
var
    CellData: TCellData;
    text : string;
begin

    result := false;

    try

        Operation('������ ������ �� �����...');
        ResetProgress;
        SetProgress( MAX_TABLE_WIDTH * MAX_TABLE_HEIGHT );

        for exlCol := 1 to MAX_TABLE_WIDTH do
        for exlRow := 1 to MAX_TABLE_HEIGHT do
        begin
            IncProgress;

            text := exl.cells[exlRow, exlCol];

            ClearCellData( CellData );
            CellData.value := text;

            DocData[exlCol-1,exlRow-1] := CellData;
        end;

        ResetProgress;
        Operation('');

        result := true;

    except
    end;
end;

function TfMain.Log(mess: string): string;
begin
    result := mess;
end;

function TfMain.OpenFile: boolean;
begin
  result := false;

  Cursor := crHourGlass;

  exl := CreateOleObject('Excel.Application');
  if not (Vartype(exl)=VarDispatch) then Exit;
//  exl.Visible := True;
  ExBk := exl.Workbooks.Open(FileName);
  ExSh := ExBk.Sheets[1];

  Cursor := crDefault;

  result := true;
end;



procedure TfMain.Operation(mess: string);
begin
    lOperation.Text := mess;
end;

procedure TfMain.SaveINI;
var
    ini : TINIFile;
begin
    ini := TIniFile.Create( ExtractFilePath(paramstr(0)) + INI_FILENAME );

    // ������� ����������� ����� ��������
    ini.WriteString('', 'marshrut', shbl_Marshrut);
    ini.WriteString('', 'otklon',   shbl_Otklon);
    ini.WriteString('', 'tonnage',  shbl_Tonnage);

    // ����� ����� ������
    ini.WriteInteger('', 'marshrut_color', rMarshColor.Fill.Color );
    ini.WriteInteger('', 'otklon_color',   rOtklonColor.Fill.Color );
    ini.WriteInteger('', 'tonnage_color',  rTonnageColor.Fill.Color );
    ini.WriteInteger('', 'price_color',    rDataColor.Fill.Color );

    ini.Free;
end;

procedure TfMain.SelSetFinishCoord(col, row: integer);
begin
    selFinish.X := col;
    selFinish.Y := row;
end;

procedure TfMain.SelSetStartCoord(col, row: integer);
begin
    selStart.X := col;
    selStart.Y := row;
end;

function TfMain.SetAnalyzeEnable(val: boolean): boolean;
begin
    result := val;
    bAnalyze.Enabled := val;
    bCitySprav.Enabled := val;

    if val
    then lCaptionAnalyze.FontColor := TAlphaColorRec.Black
    else lCaptionAnalyze.FontColor := TAlphaColorRec.Gray;
end;

function TfMain.SetFileEnable(val: boolean): boolean;
begin
    result := val;
    bOpenFile.Enabled := val;

    if val
    then lCaptionFile.FontColor := TAlphaColorRec.Black
    else lCaptionFile.FontColor := TAlphaColorRec.Gray;
end;

procedure TfMain.SetFileName(const Value: string);
begin
    _filename := Value;
    lFilename.Text := ExtractFileName(Value);
end;


function TfMain.SetImportEnable(val: boolean): boolean;
begin
    result := val;
    bImport.Enabled := val;

    if val
    then lCaptionImport.FontColor := TAlphaColorRec.Black
    else lCaptionImport.FontColor := TAlphaColorRec.Gray;
end;

function TfMain.SetPostavEnable(val: boolean): boolean;
begin
    result := val;
    bPostavSelect.Enabled := val;

    if val
    then lCaptionPostav.FontColor := TAlphaColorRec.Black
    else lCaptionPostav.FontColor := TAlphaColorRec.Gray;

end;

procedure TfMain.SetProgress( max: real );
begin
    pbAnalyze.Max := max;
end;

procedure TfMain.SetSelectMode(const Value: boolean);
begin
    _isSelectMode := Value;
end;

procedure TfMain.sgDataClick(Sender: TObject);
begin
    isSelectMode := false;
    sgData.Repaint;
end;

procedure TfMain.sgDataDrawColumnCell(Sender: TObject; const Canvas: TCanvas;
  const Column: TColumn; const Bounds: TRectF; const Row: Integer;
  const Value: TValue; const State: TGridDrawStates);
var
  bgBrush: TBrush;
  top, bottom, left, right: integer; // ������� ���������
  tmpBounds: TRectF;
begin
    // ��������� ���������� ������ ��-���������
{    if (TGridDrawState.Selected in State) or
       (TGridDrawState.Focused in State)
    then (Sender as TStringGrid).DefaultDrawColumnCell(Canvas, Column, Bounds, Row, Value, State);
}
    try

    bgBrush:= TBrush.Create(TBrushKind.Solid, TAlphaColors.Null); // default white color

    if (DocData[column.Index, row].kind <> TCellKind.ckNone) then
    begin

        /// ������ ��������� � ��������
        if (DocData[column.Index, row].kind = TCellKind.ckMarshrut)
        then bgBrush.Color := rMarshColor.Fill.Color; // a very light green color

        /// ������ ��������� � ����������
        if (DocData[column.Index, row].kind = TCellKind.ckOtklon)
        then bgBrush.Color := rOtklonColor.Fill.Color;

        /// ������ ��������� � �������
        if (DocData[column.Index, row].kind = TCellKind.ckTonnag)
        then bgBrush.Color := rTonnageColor.Fill.Color;

        /// ������ ��������� � ������ �� �����
        if (DocData[column.Index, row].kind = TCellKind.ckPrice)
        then bgBrush.Color := rDataColor.Fill.Color;


        Canvas.FillRect(Bounds, 0, 0, [], 1, bgBrush);


        Canvas.Fill.Color := TAlphaColors.Black;

        // ��������� ����� ������
        if DocData[column.Index, row].error <> '' then Canvas.Fill.Color := TAlphaColors.Red;
        if DocData[column.Index, row].warning <> '' then Canvas.Fill.Color := TAlphaColors.Orange;

        Canvas.FillText(Bounds, Value.AsString, false, 1, [], TTextAlign.Leading, TTextAlign.Center);

    end;


    /// ���� ���� ���������� �������, ������������ ����������
    if selStart.X > -1 then
    begin
        top := Min(selStart.Y, selFinish.Y);
        bottom := Max(selStart.Y, selFinish.Y);
        left := Min(selStart.X, selFinish.X);
        right := Max(selStart.X, selFinish.X);

        bgBrush.Color := TAlphaColors.Black; // a very light green color

        if (Row = top) and (Column.Index >= left) and (Column.Index <= right) then
        begin
            tmpBounds := Bounds;
            tmpBounds.Height := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

        if (Row = bottom) and (Column.Index >= left) and (Column.Index <= right) then
        begin
            tmpBounds := Bounds;
            tmpBounds.Top := tmpBounds.Top + tmpBounds.Height - 1;
            tmpBounds.Height := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

        if (Row >= top) and (Row <= bottom) and (Column.Index = left)then
        begin
            tmpBounds := Bounds;
            tmpBounds.Width := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

        if (Row >= top) and (Row <= bottom) and (Column.Index = right)then
        begin
            tmpBounds := Bounds;
            tmpBounds.Left := tmpBounds.Left + tmpBounds.Width - 1;
            tmpBounds.Width := 1;
            Canvas.FillRect(tmpBounds, 0, 0, [], 1, bgBrush);
        end;

    end;

    finally
        bgBrush.Free;
    end;

end;

procedure TfMain.sgDataEditingDone(Sender: TObject; const Col, Row: Integer);
begin
    DocData[ col, row ].value := sgData.Cells[ col, row];
end;

procedure TfMain.sgDataMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
   Col: TColumn;
   C,R: integer;
begin
    isSelectMode := true;

    Col := sgData.ColumnByPoint(X, Y);
    if Assigned(Col)
    then C := Col.Index
    else C := -1;

    R := sgData.RowByPoint(X, Y);

    SelSetStartCoord(c, r);
    SelSetFinishCoord(c, r);
end;

procedure TfMain.sgDataMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
    if isSelectMode then
    begin
        SelSetFinishCoord( sgData.ColumnIndex, sgData.Selected );
        sgData.Repaint;
    end;
end;

procedure TfMain.sgDataSelectCell(Sender: TObject; const ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
    ClearMess;
    Error( DocData[ACol, ARow].error );
    Warning( DocData[ACol, ARow].warning );
    Info( DocData[ACol, ARow].info );
    System( DocData[ACol, ARow] );
end;

initialization

finalization
    exl := Unassigned;

end.
