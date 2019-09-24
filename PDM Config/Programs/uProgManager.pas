unit uProgManager;

interface

uses
    FMX.ListBox, FMX.Layouts, SysUtils, uAtlas;

type

    TProgInfo = record
        id                   // id ���������
                : integer;
        name                 // ������� ��� ���������, ������������ � ������ ������
       ,detail               // ������� ��������
       ,icon                 // ��� ������ ���������
       ,condition            // ������� sql-������� ������������� ������� � ���������
                : string;
    end;
    TProgsArray = array of TProgInfo;

    TVersionInfo = record
        Id                   //
                : integer;
        detail               // ����������� ����������� (����� ���������� � ������ ���������� �������� � ������ ��������
       ,icon                 // ��� ������, ����������� � ���� ������
       ,filename             // ��� ������������ ����� ������ � ����� �� ����
       ,condition            // ������� sql-������� ������������� ��� ������������ ������
                : string;
        status               // ������ ������: 0 - ������������, 1 - �������, 3 - ��������
                : integer;
    end;
    TVersionsArray = array of TVersionInfo;

    // �������� ��������� ������ ��� ������ �������� ������ ��������
    // ����������� ��� �������� ��������� ������������� ���������
    TProgData = record
        name
       ,detail
       ,icon
       ,condition
                : string;
    end;

    // �������� ��������� ������ ��� ������ �������� ������ ��������
    // ����������� ��� �������� ��������� ������������� ���������
    TVersionData = record
        detail
       ,icon
       ,filename
       ,condition
                : string;
        status
                : integer;
    end;

    TProgManager = class

        // ������� ��������� � ������
        ProgsArray: TProgsArray;        // ������ ���������� ������ ������ ��������
        VersionsArray: TVersionsArray;  // ������ ���������� ������ ������ ������ ��������

        function isReady: boolean;      // ��������� ������ ��������� � ���������� true, ���� ��� ������ � ������
        procedure Init( lb, fly: TListBox; Path, ProgIcon, VerPers, VerWork, VerTest: string; mode: boolean );
        function LoadProgData(forsed: boolean = false): boolean;
        function LoadVersionData(forsed: boolean = false): boolean;
        procedure RefreshProgList;
        procedure RefreshVersionList;
        procedure ProgUpdate(name, detail, icon, condition: string);
        procedure VersionUpdate(status: integer; detail, filename, condition: string);
        procedure ProgDelete;
        procedure VersionDelete;
        procedure ProgCreate;
        procedure VersionCreate;

    private

        lbProgs                         // ������� ��������� � ������� ����� ����������� ������ �������� � ��������� ��
       ,lbVersions                      // ������� ���������, ��� ����� ����������� ������ ������
                : TListBox;
        IconPath                        // ���� �� �����, ��� ����� ������
       ,DefaultProgIcon                 // ��� ������ ��������� ��-���������
       ,IconPersonal
       ,IconWork
       ,IconTest
                : string;
        AdminMode                       // ������� ������������� ����������� ��������� ������������ ������ (��� �����������������)
                : boolean;

    end;

var
   mngProgs : TProgManager;
   ProgData: TProgData;
   VersData: TVersionData;

implementation

{ TProgManager }

uses
    uPhenixCORE
   ,FMX.StdCtrls
   ,System.UITypes
   ,FMX.Types
   ,FMX.Objects
   ,Data.Win.ADODB
   ,FMX.Graphics
   ;

const

    // ��� ������
    STATE_PERSONAL = 0;   // ������������, ����� �� �������
    STATE_WORK     = 1;   // ����� �������
    STATE_TEST     = 2;   // ����� ��������

    SQL_GET_PROG_LIST =
        'SELECT * FROM pdm_Programs WHERE deleted = 0';

    SQL_CHECK_ALLOWING =
        'SELECT CASE WHEN %d in (SELECT id FROM employees WHERE %s) THEN ''1'' ELSE ''0'' END';

    SQL_GET_VERION_LIST =
        'SELECT * FROM pdm_ProgVersions WHERE deleted = 0 AND ProgId = %d ORDER BY status';


procedure TProgManager.Init(lb, fly: TListBox; Path, ProgIcon, VerPers, VerWork, VerTest: string; mode: boolean );
{ ���������������� ������������� ��������� }
begin
    lbProgs := lb;
    lbVersions := fly;
    IconPath := Path;
    DefaultProgIcon := ProgIcon;
    IconPersonal := VerPers;
    IconWork := VerWork;
    IconTest := VerTest;
    AdminMode := mode;
end;

function TProgManager.isReady: boolean;
{ ��������� ������������ ������� ��������
  ���������� �� ���������� ��������, � ��� �� ����� ���������� ������ }
begin
    result :=
        Assigned(lbProgs) and
        Assigned(lbVersions) and
        ((IconPath <> '') and DirectoryExists(IconPath));
end;

function TProgManager.LoadProgData(forsed: boolean = false): boolean;
var
   query: TADOQuery;
   allowed : boolean;
   condition : string;
begin

    result := false;

    if ( Length(ProgsArray) > 0 ) and not forsed then exit;

    SetLength(ProgsArray, 0);

    // �������� ������ ��������
    query := Core.DM.OpenQueryEx( SQL_GET_PROG_LIST );
    if Assigned( query ) then
    while not Query.Eof do
    begin

        allowed := true;
        condition := Query.FieldByName('condition').AsString;
        // ��� ������������ ������ ���������� �� ��������� ��� �������� ������������
        if (condition <> '') and
            not AdminMode
        then
            allowed := dmSQ( Format( SQL_CHECK_ALLOWING, [ Core.User.id, condition ] )) = '1';

        if (condition = '')
        then
            allowed := true;

        if allowed then
        begin

            SetLength(ProgsArray, Length(ProgsArray)+1);

            ProgsArray[High(ProgsArray)].id        := Query.FieldByName('id').AsInteger;
            ProgsArray[High(ProgsArray)].name      := Query.FieldByName('name').AsString;
            ProgsArray[High(ProgsArray)].detail    := Query.FieldByName('detail').AsString;
            ProgsArray[High(ProgsArray)].icon      := Query.FieldByName('icon').AsString;
            ProgsArray[High(ProgsArray)].condition := Query.FieldByName('condition').AsString;

        end;

        Query.Next;
    end;

    result := true;

end;

function TProgManager.LoadVersionData(forsed: boolean): boolean;
var
   query: TADOQuery;
   allowed: boolean;
begin

    result := false;

    SetLength(VersionsArray, 0);

    if ( Length(VersionsArray) > 0 ) and not forsed then exit;
    if lbProgs.ItemIndex = -1 then exit;


    // �������� ������ ������ ��������
    query := Core.DM.OpenQueryEx( Format(SQL_GET_VERION_LIST, [lbProgs.ListItems[lbProgs.ItemIndex].Tag]) );
    if Assigned( query ) then
    while not query.Eof do
    begin

        allowed := true;

        // ��� ������������ ������ ���������� �� ��������� ��� �������� ������������
        if (Query.FieldByName('status').AsInteger = STATE_PERSONAL) and
            (Query.FieldByName('condition').AsString <> '') and
            not AdminMode
        then
            allowed := dmSQ( Format( SQL_CHECK_ALLOWING, [ Core.User.id, Query.FieldByName('condition').AsString ] )) = '1';


        // �������������, �������� ������ � ������������ ��� ������ �����������
        if not FileExists(Query.FieldByName('filename').AsString) and
           not AdminMode
        then
           allowed := false;


        if allowed then
        begin
            SetLength(VersionsArray, Length(VersionsArray)+1);

            VersionsArray[High(VersionsArray)].Id        := Query.FieldByName('id').AsInteger;
            VersionsArray[High(VersionsArray)].detail    := Query.FieldByName('detail').AsString;
            VersionsArray[High(VersionsArray)].icon      := Query.FieldByName('icon').AsString;
            VersionsArray[High(VersionsArray)].filename  := Query.FieldByName('filename').AsString;
            VersionsArray[High(VersionsArray)].status    := Query.FieldByName('status').AsInteger;
            VersionsArray[High(VersionsArray)].condition := Query.FieldByName('condition').AsString;
        end;

        query.Next;
    end;

    if Assigned(query) then query.free;

    result := true;

end;

procedure TProgManager.ProgCreate;
begin
    dmEQ( 'INSERT INTO pdm_Programs(name, detail, icon) VALUES (''����� ���������'', '''', ''' + DefaultProgIcon + ''')' );
end;

procedure TProgManager.ProgDelete;
begin
    if lbProgs.ItemIndex = -1 then exit;

    dmEQ( Format('UPDATE pdm_Programs SET deleted = 1 WHERE ID = %d',
                 [lbProgs.ListItems[lbProgs.ItemIndex].Tag]));
end;

procedure TProgManager.ProgUpdate(name, detail, icon, condition: string);
begin
    if lbProgs.ItemIndex = -1 then exit;

    dmEQ( Format('UPDATE pdm_Programs SET name = ''%s'', detail = ''%s'', icon = ''%s'', condition = ''%s'' WHERE id = %d',
                 [ name, detail, icon, condition, lbProgs.ListItems[lbProgs.ItemIndex].Tag ]));
end;

procedure TProgManager.VersionCreate;
begin
    if lbProgs.ItemIndex = -1 then exit;

    dmEQ( 'INSERT INTO pdm_ProgVersions(progid, detail, filename, condition, status) '+
          'VALUES ('+ IntToStr(lbProgs.ListItems[lbProgs.ItemIndex].Tag) +', ''�������� ������'', '''', '''', 2)' );
end;

procedure TProgManager.VersionDelete;
begin
    if lbVersions.ItemIndex = -1 then exit;

    dmEQ( Format('UPDATE pdm_ProgVersions SET deleted = 1 WHERE ID = %d',
                 [lbVersions.ListItems[lbVersions.ItemIndex].Tag]));
end;

procedure TProgManager.VersionUpdate(status: integer; detail, filename,
  condition: string);
begin
    if lbVersions.ItemIndex = -1 then exit;

    // ������� ����� ���� ������ ���� ������. ���������� � ����, � ����� ��������� � �������
    if status = STATE_WORK then
        dmEQ( Format('UPDATE pdm_ProgVersions SET status = %d WHERE progId = %d AND status = %d',
                     [ STATE_TEST, lbProgs.ListItems[lbProgs.ItemIndex].Tag, STATE_WORK ]));

    dmEQ( Format('UPDATE pdm_ProgVersions SET filename = ''%s'', detail = ''%s'', condition = ''%s'', status = %d WHERE id = %d',
                 [ filename, detail, condition, status, lbVersions.ListItems[lbVersions.ItemIndex].Tag ]));
end;


procedure TProgManager.RefreshProgList;
{ ������������� ������ �������� � ������ ��� ������� ��������� ��������� }
var
    i: integer;
    lab: TLabel;
    ly: TLayout;
    source: TImage;
begin

    lbProgs.Items.Clear;

    if Length(ProgsArray) = 0 then exit;

    for I := 0 to High(ProgsArray) do
    begin

        // ��������� ������� � ������
        lbProgs.Items.Add('');
        lbProgs.ListItems[lbProgs.Items.Count-1].Height          := 46;
        lbProgs.ListItems[lbProgs.Items.Count-1].Tag             := ProgsArray[i].id;
        lbProgs.ListItems[lbProgs.Items.Count-1].ItemData.Detail := ProgsArray[i].detail;
{
        if FileExists(IconPath + ProgsArray[i].icon) then
            lbProgs.ListItems[lbProgs.Items.Count-1].ItemData.Bitmap.LoadFromFile( IconPath + ProgsArray[i].icon );
}
        source := TImage( fAtlas.FindComponent( ProgsArray[i].icon ) );
        lbProgs.ListItems[lbProgs.Items.Count-1].ItemData.Bitmap.Assign( source.MultiResBitmap.Bitmaps[1.0] );

        lbProgs.ListItems[lbProgs.Items.Count-1].StyleLookup     := 'listboxitembottomdetail';

        // ���������� � ���� ��������� ��� �������������� ��������
        ly := TLayout.Create(lbProgs.ListItems[lbProgs.Items.Count-1]);
        ly.Parent := lbProgs.ListItems[lbProgs.Items.Count-1];
        ly.Position.X := 54;
        ly.Position.Y := -10;
        ly.Width := lbProgs.ListItems[lbProgs.Items.Count-1].Width - ly.Position.X;
        ly.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];

        // ��������� � ��������� ������ ������������� ����� ������������
        lab := TLabel.Create(ly);
        lab.Parent := ly;
        lab.StyledSettings := [];
        lab.Align := TAlignLayout.Left;

        lab.Text := Copy(ProgsArray[i].name, 0, AnsiPos(' ', ProgsArray[i].name));
        if lab.Text = '' then lab.Text := ProgsArray[i].name;

        lab.AutoSize := true;
        lab.TextSettings.WordWrap := false;
        lab.TextSettings.Font.Size := 16;
        lab.TextSettings.Font.Style := [TFontStyle.fsBold];
        lab.TextSettings.FontColor := TAlphaColorRec.Crimson;

        // ��������� � ��������� ��������������� ��������� ����� ��������
        lab := TLabel.Create(ly);
        lab.Parent := ly;
        lab.StyledSettings := [];
        lab.Align := TAlignLayout.Left;

        if AnsiPos(' ', ProgsArray[i].name) <> 0
        then
            lab.Text := Copy(ProgsArray[i].name, AnsiPos(' ', ProgsArray[i].name)+1, Length(ProgsArray[i].name))
        else
            lab.Text := '';

        lab.AutoSize := true;
        lab.TextSettings.WordWrap := false;
        lab.TextSettings.Font.Size := 16;

    end;
end;

procedure TProgManager.RefreshVersionList;
var
    i: integer;
    ProgId: integer;
    source : TImage;
begin
    lbVersions.Items.Clear;

    if Length(VersionsArray) = 0 then exit;

    ProgId := lbProgs.ListItems[ lbProgs.ItemIndex ].Tag;

    for I := 0 to High(VersionsArray) do
    begin
        lbVersions.Items.Add('');
        lbVersions.ListItems[lbVersions.Items.Count-1].Height          := 46;
        lbVersions.ListItems[lbVersions.Items.Count-1].tag             := VersionsArray[i].id;
        lbVersions.ListItems[lbVersions.Items.Count-1].ItemData.Detail := VersionsArray[i].detail;

        case VersionsArray[i].Status of

            STATE_PERSONAL: source := TImage( fAtlas.FindComponent( IconPersonal ) );
            STATE_WORK:     source := TImage( fAtlas.FindComponent( IconWork ) );
            STATE_TEST:     source := TImage( fAtlas.FindComponent( IconTest ) );
        end;

        lbVersions.ListItems[lbVersions.Items.Count-1].ItemData.Bitmap.Assign( source.MultiResBitmap.Bitmaps[1.0] );

        lbVersions.ListItems[lbVersions.Items.Count-1].StyleLookup     := 'listboxitembottomdetail';

    end;
end;


initialization

    mngProgs := TProgManager.Create;

finalization

    mngProgs.Free;

end.
