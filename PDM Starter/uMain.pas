unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  uProgManager, uConstants, uPhenixCore, Windows, ShellApi;

type
  TfMain = class(TForm)
    lbPrograms: TListBox;
    ListBoxHeader1: TListBoxHeader;
    lHeaderCaption: TLabel;
    bDetails: TCircle;
    lyProgList: TLayout;
    lFooter: TLayout;
    bRun: TRectangle;
    Label3: TLabel;
    StyleBook1: TStyleBook;
    rVersions: TRectangle;
    Label1: TLabel;
    lyInfo: TLayout;
    Image1: TImage;
    lbVersions: TListBox;
    procedure bDetailsMouseEnter(Sender: TObject);
    procedure bDetailsMouseLeave(Sender: TObject);
    procedure lbProgramsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bDetailsClick(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
    procedure bRunClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetWindowWidth;
  public
    { Public declarations }
  end;

  TProgInfo = record
      id                   // id ���������
              : integer;
      name                 // ������� ��� ���������, ������������ � ������ ������
     ,detail               // ������� ��������
     ,iconName             // ��� ������ ���������
              : string;
  end;

  TVersionInfo = record
      id                   // id ���������, ������� ������� ��������
     ,state                // ������� ����: 0 - �������, 1 - ��������
              : integer;
      hint                 // ������� ������� �� ������ ������
     ,detail               // ����������� ����������� (����� ���������� � ������ ���������� �������� � ������ ��������
     ,iconName             // ��� ������, ����������� � ���� ������
     ,path                 // ����, ������ ����� ����������� ���� ������ ������
     ,filename             // ��� ������������ �����
              : string
  end;

  TVersionManager = class

  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

procedure TfMain.bDetailsClick(Sender: TObject);
begin
    rVersions.Visible := not rVersions.Visible;
    SetWindowWidth;
end;

procedure TfMain.bDetailsMouseEnter(Sender: TObject);
begin
    (Sender as TShape).Opacity := 0.8;
end;

procedure TfMain.bDetailsMouseLeave(Sender: TObject);
begin
    (Sender as TShape).Opacity := 0.5;
end;

procedure TfMain.bRunClick(Sender: TObject);
var
    sourcePath
   ,targetPath
   ,FileName
            : string;
    error   : integer;
begin

    FileName := ExtractFileName(mngProgs.VersionsArray[lbVersions.ItemIndex].filename);
    sourcePath := ExtractFilePath(mngProgs.VersionsArray[lbVersions.ItemIndex].filename);
    targetPath := ExtractFilePath( paramstr(0) );


    // �������� ������� ������ �������� �� ������ ������������
    if not CopyFile(
        PChar( sourcePath + filename ),
        PChar( targetPath + filename ),
        False   // ��-��������� ��������������
    ) then
    begin
        if not FileExists( targetPath + filename )
        then
        begin
            ShowMessage(
                '������: ' + SysErrorMessage(GetLastError) + sLineBreak +
                sourcePath + filename + sLineBreak + sLineBreak +
                '������ ��������� ����������. ���������� � ��������������.' + sLineBreak
            );
            Halt;
        end
        else
            ShowMessage(
                '������: ' + SysErrorMessage(GetLastError) + sLineBreak +
                targetPath + filename + sLineBreak + sLineBreak +
                '�� ������� �������� ���������. ��������� ������� ������.'
            );
    end;

    // ��������� ������� � ������������� ��� �������� �������
    if ShellExecute( HWND(handle), 'open', PChar(targetPath + filename), nil, nil, SW_SHOWNORMAL ) <> 42
    then
        ShowMessage( SysErrorMessage(GetLastError) );

    Halt;

end;

procedure TfMain.Circle1Click(Sender: TObject);
begin
    if Round((Sender as TShape).Stroke.Thickness) <> 0
    then
       (Sender as TShape).Stroke.Thickness := 0
    else
       (Sender as TShape).Stroke.Thickness := 1;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
    bRun.Visible := false;
    SetWindowWidth;

    Core := TCore.Create;
    Core.Init(
        PROG_NAME,
        CONNECTION_STRING,
        SETTINGS_TABLE_NAME,
        LOG_FILEPATH
    );

    mngProgs.Init(
        lbPrograms,
        lbVersions,
        ICON_FILEPATH,
        DEFAULT_PROG_ICON,
        VERSION_PERSONAL_ICON,
        VERSION_WORK_ICON,
        VERSION_TEST_ICON,
        false                  // ����� �����������������, �� ����������� ������������ ��������� ������.
                               // ���������� ���, �� �������� �������� ������������
    );

    if mngProgs.LoadProgData
    then
        mngProgs.RefreshProgList;

end;

procedure TfMain.lbProgramsChange(Sender: TObject);
begin
    // �������� ������ ������ ������� ���������
    mngProgs.LoadVersionData(true);
    mngProgs.RefreshVersionList;
    // �������� ������������
    lbVersions.ItemIndex := 0;

    bRun.Visible :=
        (lbPrograms.ItemIndex <> -1) and
        (lbVersions.Items.Count > 0);

end;

procedure TfMain.SetWindowWidth;
var
    w: single;
begin
    if lyProgList.Visible then w := w + lyProgList.Width;
    if rVersions.Visible then w := w + rVersions.Width;
    if lyInfo.Visible then w := w + lyInfo.Width;

    fMain.ClientWidth := Round( w );
    fMain.Left := (Screen.Width - fMain.Width) div 2;
end;

end.
