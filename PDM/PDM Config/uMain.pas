unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls,
  FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.TMSBaseControl, FMX.TMSScrollControl, FMX.TMSRichEditorBase,
  FMX.TMSRichEditor, FMX.TMSRichEditorIO, FMX.TMSMemo, FMX.TMSMemoStyles,
  FMX.TMSToolBar, FMX.TMSRichEditorToolBar, FMX.Objects, FMX.TMSHTMLText,
  System.Actions, FMX.ActnList, FMX.TMSWebBrowser, FMX.ScrollBox, FMX.Memo,
  uPhenixTypes, StrUtils, FMX.TMSTreeViewBase, FMX.TMSTreeViewData,
  FMX.TMSCustomTreeView, FMX.TMSTreeView, FMX.TMSBitmapContainer;


type
  TfMain = class(TForm)
    tcSetup: TTabControl;
    tiMailSetup: TTabItem;
    lbMenu: TListBox;
    lbiMailConfig: TListBoxItem;
    lbMailList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    lbConditionList: TListBox;
    Label3: TLabel;
    eMailSubject: TEdit;
    eEditCondition: TEdit;
    Label4: TLabel;
    eMailNaim: TEdit;
    Label5: TLabel;
    bMailSave: TButton;
    Splitter1: TSplitter;
    tiLogViewer: TTabItem;
    mBody: TTMSFMXMemo;
    StyleBook: TStyleBook;
    MailHTMLStyler: TTMSFMXMemoHTMLStyler;
    ActionList1: TActionList;
    alShowAdminPanel: TAction;
    bAddCondition: TCircle;
    bNewMail: TCircle;
    bDeleteMail: TCircle;
    bDeleteCondition: TCircle;
    bCheckCondition: TCircle;
    bCheckHTML: TCircle;
    lHint: TLabel;
    bChangeCondition: TCircle;
    bMailRollback: TButton;
    lbiLogs: TListBoxItem;
    bOpen: TCircle;
    odLogOpen: TOpenDialog;
    mDetails: TMemo;
    Layout1: TLayout;
    Splitter2: TSplitter;
    tvLog: TTMSFMXTreeView;
    Label6: TLabel;
    lOpenedLogFilename: TLabel;
    lbProgVersions: TListBoxItem;
    tiProgVersions: TTabItem;
    lbPrograms: TListBox;
    Label7: TLabel;
    Label8: TLabel;
    eProgName: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    eProgDetail: TEdit;
    Label11: TLabel;
    bProgAdd: TButton;
    bProgDel: TButton;
    bProgSave: TButton;
    bVersionAdd: TButton;
    bVersionDel: TButton;
    Label13: TLabel;
    eVersionDetail: TEdit;
    bVersionSave: TButton;
    Label15: TLabel;
    eProgIcon: TEdit;
    bProgIconOpen: TRectangle;
    eVersionPath: TEdit;
    bVersionPath: TRectangle;
    bProgClear: TButton;
    Label14: TLabel;
    cbVersionType: TComboBox;
    lVersionCondition: TLabel;
    eVersionCondition: TEdit;
    bVersionClear: TButton;
    lbVersions: TListBox;
    Label12: TLabel;
    eProgCondition: TEdit;
    procedure FormShow(Sender: TObject);
    procedure lbMailListChange(Sender: TObject);
    procedure alShowAdminPanelExecute(Sender: TObject);
    procedure bNewMailMouseEnter(Sender: TObject);
    procedure bNewMailMouseLeave(Sender: TObject);
    procedure bCheckHTMLClick(Sender: TObject);
    procedure lbConditionListChange(Sender: TObject);
    procedure eEditConditionKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure eMailNaimKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure bMailRollbackClick(Sender: TObject);
    procedure bAddConditionClick(Sender: TObject);
    procedure bChangeConditionClick(Sender: TObject);
    procedure bDeleteConditionClick(Sender: TObject);
    procedure bMailSaveClick(Sender: TObject);
    procedure bCheckConditionClick(Sender: TObject);
    procedure bNewMailClick(Sender: TObject);
    procedure bDeleteMailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbMenuChange(Sender: TObject);
    procedure bOpenMouseEnter(Sender: TObject);
    procedure bOpenMouseLeave(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure tvLogGetNodeTextColor(Sender: TObject;
      ANode: TTMSFMXTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TAlphaColor);
    procedure lbProgramsChange(Sender: TObject);
    procedure bProgIconOpenClick(Sender: TObject);
    procedure eProgIconChange(Sender: TObject);
    procedure bProgClearClick(Sender: TObject);
    procedure bProgSaveClick(Sender: TObject);
    procedure bProgAddClick(Sender: TObject);
    procedure bProgDelClick(Sender: TObject);
    procedure lbVersionsChange(Sender: TObject);
    procedure cbVersionTypeChange(Sender: TObject);
    procedure bVersionClearClick(Sender: TObject);
    procedure bVersionSaveClick(Sender: TObject);
    procedure bVersionAddClick(Sender: TObject);
    procedure bVersionDelClick(Sender: TObject);
    procedure bVersionPathClick(Sender: TObject);
    procedure eProgNameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure eVersionDetailKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    Procedure UpdateHTMLPreview;
    procedure MailListEnable(enable: boolean);
    procedure ConditionListEnable;
    procedure SetMailInfo;
    procedure ClearMailInfo;
    { Private declarations }
  public
    procedure RefreshMailList;
    procedure RefreshConditionList;
    function CheckChanges: boolean;
    procedure CheckProgChanges;
    procedure CheckVersChanges;
    procedure ClearProgFields;
    procedure ClearVersFields;
    { Public declarations }
  end;

  TMailData = record
      naim
     ,subject
     ,condition
     ,body
              : string;
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

uses
    uPhenixCORE, ucFMXTools, uAdminPanel, uConfigHTMLPreview, uCheckCondition,
    uConstants, uProgManager;

const

    FIELD_TIME      = 0;
    FIELD_MESS_TEXT = 1;
    FIELD_MESS_TYPE = 2;

var
    MailData: TMailData;
    LogArr: TLogArray;

procedure TfMain.MailListEnable(enable: boolean);
begin
    eMailNaim.Enabled       := enable;
    eMailSubject.Enabled    := enable;
    lbConditionList.Enabled := enable;
    eEditCondition.Enabled  := enable;
    mBody.Enabled           := enable;

    bDeleteMail.Enabled     := enable;
    bCheckHTML.Enabled      := enable;
end;

function TfMain.CheckChanges: boolean;
begin
    bMailSave.Visible :=
        (eMailNaim.Text <> MailData.naim) or
        (eMailSubject.text <> MailData.subject) or
        (lbConditionList.Items.CommaText <> MailData.condition) or
        (Trim(mBody.Lines.Text) <> Trim(MailData.body));

    bMailRollback.Visible := bMailSave.Visible;

    lbMailList.Enabled := not bMailSave.Visible;
    bNewMail.Enabled := not bMailSave.Visible;
    bDeleteMail.Enabled := not bMailSave.Visible;
end;

procedure TfMain.SetMailInfo;
begin
    eMailNaim.Text                  := MailData.naim;
    eMailSubject.Text               := MailData.subject;
    lbConditionList.Items.CommaText := MailData.condition;
    eEditCondition.Text             := '';
    mBody.Lines.Text                := MailData.body;
end;

procedure TfMain.ClearMailInfo;
begin
    MailData.naim      := '';
    MailData.subject   := '';
    MailData.condition := '';
    MailData.body      := '';
end;


procedure TfMain.ConditionListEnable;
var
    i: integer;
    hasDoubles: boolean;
begin

    hasDoubles := false;
    for I := 0 to lbConditionList.Items.Count-1 do
       if Trim(lbConditionList.Items[i]) = Trim(eEditCondition.Text) then
          hasDoubles := true;
    bAddCondition.Enabled    := (eEditCondition.Text <> '') and not hasDoubles;

    bChangeCondition.Enabled := (eEditCondition.Text <> '') and (lbConditionList.ItemIndex <> -1);
    bCheckCondition.Enabled  := lbConditionList.Items.Count > 0;
    bDeleteCondition.Enabled := lbConditionList.ItemIndex <> -1;
end;

procedure TfMain.eEditConditionKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    ConditionListEnable;
end;


procedure TfMain.eMailNaimKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    UpdateHTMLPreview;
    CheckChanges;
    mBody.SetFocus;
end;

procedure TfMain.lbConditionListChange(Sender: TObject);
begin
    if lbConditionList.ItemIndex <> -1 then
        eEditCondition.Text := lbConditionList.Items[lbConditionList.ItemIndex];

    ConditionListEnable;
end;

procedure TfMain.lbMailListChange(Sender: TObject);
begin

    if lbMailList.ItemIndex = -1 then
    begin
        MailListEnable(false);
        RefreshConditionList;
        exit;
    end;

    // получаем данные
    MailData.naim      := lbMailList.Items[ lbMailList.ItemIndex ];
    MailData.subject   := Core.Mail.GetSubject( MailData.naim );
    MailData.condition := Core.Mail.GetAllConditions( MailData.naim );
    MailData.body      := Core.Mail.GetBody( MailData.naim );

    SetMailInfo;
    MailListEnable(true);
    RefreshConditionList;
end;

procedure TfMain.lbMenuChange(Sender: TObject);
begin
    tcSetup.TabIndex := lbMenu.ItemIndex;

    if tcSetup.Tabs[tcSetup.TabIndex].Name = 'tiProgVersions'
    then
    begin
        if mngProgs.LoadProgData
        then
        begin
            mngProgs.RefreshProgList;
            CheckProgChanges;
        end
    end;
end;


procedure TfMain.bVersionPathClick(Sender: TObject);
begin
    odLogOpen.InitialDir := '';
    odLogOpen.DefaultExt := '.exe';
    odLogOpen.Filter := 'Приложение|*.exe';

    if odLogOpen.Execute then
        eVersionPath.Text := odLogOpen.FileName;
end;

procedure TfMain.RefreshConditionList;
var
   naim : string;
begin

    if lbMailList.ItemIndex <> -1 then
    begin

        if lbConditionList.ItemIndex <> -1 then
            naim := lbConditionList.Items[lbConditionList.ItemIndex];

        lbConditionList.Clear;
        lbConditionList.Items.CommaText := Core.Mail.GetAllConditions( lbMailList.Items[lbMailList.ItemIndex] );

        lbConditionList.ItemIndex := lbConditionList.Items.IndexOf(naim);


    end;

    ConditionListEnable;

end;

procedure TfMain.RefreshMailList;
var
    naim: string;
begin

    naim := '';
    if lbMailList.ItemIndex <> -1 then
       naim := lbMailList.Items[lbMailList.ItemIndex];

    lbMailList.Clear;
    lbMailList.Items.CommaText := Core.Mail.GetAllMails;

    lbMailList.ItemIndex := lbMailList.Items.IndexOf(naim);

end;


procedure TfMain.alShowAdminPanelExecute(Sender: TObject);
begin
    if Assigned(fAdminPanel) then
    if not fAdminPanel.Visible
    then
        fAdminPanel.Show
    else
        fAdminPanel.Hide;
end;

procedure TfMain.bNewMailClick(Sender: TObject);
begin
    Core.Mail.CreateMail('Новая рассылка', 'Без темы', '<html><html>');
    RefreshMailList;
    lbMailList.ItemIndex := lbMailList.Items.IndexOf('Новая рассылка');
end;

procedure TfMain.bNewMailMouseEnter(Sender: TObject);
begin
    (Sender as TShape).Opacity := 1;
    lHint.Text := (Sender as TShape).StyleName;
end;

procedure TfMain.bNewMailMouseLeave(Sender: TObject);
begin
    (Sender as TShape).Opacity := 0.7;
    lHint.Text := '';
end;


procedure TfMain.bAddConditionClick(Sender: TObject);
begin
    lbConditionList.Items.Add(eEditCondition.text);
    eEditCondition.Text := '';
    CheckChanges;
end;

procedure TfMain.bChangeConditionClick(Sender: TObject);
begin
    lbConditionList.Items[lbConditionList.ItemIndex] := eEditCondition.text;
    CheckChanges;
end;

procedure TfMain.bDeleteConditionClick(Sender: TObject);
begin
    lbConditionList.Items.Delete(lbConditionList.ItemIndex);
    eEditCondition.Text := '';
    CheckChanges;
end;

procedure TfMain.bDeleteMailClick(Sender: TObject);
begin
    if lbMailList.ItemIndex = -1 then exit;

    if MessageDlg( 'Удалить рассылку?', TMsgDlgType.mtCustom, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo ) = IDNo then exit;
    Core.Mail.DeleteMail( lbMailList.Items[ lbMailList.ItemIndex ] );
    RefreshMailList;
    ClearMailInfo;
    SetMailInfo;
end;

procedure TfMain.bCheckConditionClick(Sender: TObject);
begin
    if not Assigned(fCheckCondition) then
        fCheckCondition := TfCheckCondition.Create(self);

    fCheckCondition.Show;

    fCheckCondition.Refresh( MailData.naim, lbConditionList.Items.CommaText);
end;

procedure TfMain.bCheckHTMLClick(Sender: TObject);
begin
    if not Assigned(fHTMLPreview) then
        fHTMLPreview := TfHTMLPreview.Create(self);
    fHTMLPreview.Show;

    UpdateHTMLPreview;
end;

procedure TfMain.bMailRollbackClick(Sender: TObject);
begin
    SetMailInfo;
    UpdateHTMLPreview;
    CheckChanges;
end;

procedure TfMain.bMailSaveClick(Sender: TObject);
var
   i : integer;
begin

    // обновляем имя, если изменено
    if Trim(eMailNaim.Text) <> MailData.naim then
    begin
        Core.Mail.SetName( MailData.naim, Trim(eMailNaim.Text) );
        MailData.naim := Trim(eMailNaim.Text);
        RefreshMailList;
    end;

    // обновляем тему, если изменена
    if Trim(eMailSubject.Text) <> MailData.subject then
    begin
        Core.Mail.SetSubject( MailData.naim, Trim(eMailSubject.Text) );
        MailData.subject := Trim(eMailSubject.Text);
    end;

    // обновляем условия, если изменены
    if Trim(lbConditionList.Items.CommaText) <> MailData.condition then
    begin
        Core.Mail.ClearConditions(MailData.naim);
        for i := 0 to lbConditionList.Items.Count-1 do
            Core.Mail.AddUserCondition( MailData.naim, Trim(lbConditionList.Items[i]) );
        MailData.condition := Trim(lbConditionList.Items.CommaText);
    end;

    // обновляем тему, если изменена
    if Trim(mBody.Lines.Text) <> MailData.body then
    begin
        Core.Mail.SetBody( MailData.naim, Trim(mBody.Lines.Text) );
        MailData.body := Trim(mBody.Lines.Text);
    end;

    CheckChanges;
end;

Procedure TfMain.UpdateHTMLPreview;
begin
    if Assigned(fHTMLPreview) then
        fHTMLPreview.webHtml.LoadHTML(mBody.Lines.Text);
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    fCheckCondition.SaveWindowState;
    fHTMLPreview.SaveWindowState;
    SaveForm(self);
end;





{*******************************************************************************
     методы функционала закладки ЛОГОВ
*******************************************************************************}
procedure TfMain.bOpenClick(Sender: TObject);
type
    TLevelsInfo = record
//       node: TTMSFMXTreeViewVirtualNode;
       node: TTMSFMXTreeViewNode;
       name: string;
    end;
var
   i: integer;
//   n: TTMSFMXTreeViewVirtualNode;
   n: TTMSFMXTreeViewNode;
   levels: array of TLevelsInfo;
   lastlevel : integer;

   function GetFirstLine(text: string): string;
   begin
       result := ReplaceStr(text, sLineBreak, ' ');
       result := ReplaceStr(result, #13, ' ');
   end;

begin

    odLogOpen.InitialDir := Core.Log.SavePath;
    odLogOpen.DefaultExt := '.pack';
    odLogOpen.Filter := 'Упакованный лог-файл|*.pack';

    if odLogOpen.Execute then
    if Core.Log.LoadFromFileEx(odLogOpen.FileName, LogArr) then
    begin

        SetLength(levels, 1);
        levels[0].node := nil;
        levels[0].name := '';
        lastlevel := 0;

        tvLog.Nodes.Clear;

        for i := 0 to High(LogArr) do
        begin
            // если встречаем подуровень, создаем ноду-заголовок
            // и дальнейшие записи этого уровня будем цеплять к ней
            if (LogArr[i]._Level > lastlevel) then
            begin

                if LogArr[i]._Level > High(levels) then
                    SetLength(levels, length(levels)+1);

                n := tvLog.AddNode( levels[lastlevel].node );
                n.Text[0] := LogArr[i]._GlobComment;
                n.Extended := true;

                levels[LogArr[i]._Level].node := n;
                levels[LogArr[i]._Level].name := LogArr[i]._GlobComment;
            end

            else
            // если уровень не изменился, но изменилась процедура (новая не вложеная),
            // обновляем данные текущего уровня
            if (LogArr[i]._Level = lastlevel) and (levels[LogArr[i]._Level].name <> LogArr[i]._GlobComment) then
            begin
                n := tvLog.AddNode( levels[lastlevel-1].node );
                n.Text[0] := LogArr[i]._GlobComment;
                n.Extended := true;

                levels[LogArr[i]._Level].node := n;
                levels[LogArr[i]._Level].name := LogArr[i]._GlobComment;
            end;


            n := tvLog.AddNode( levels[LogArr[i]._Level].node );

            n.Text[FIELD_TIME] := FormatDateTime('d/m/y h/n', LogArr[i]._MessTime);
            n.Text[FIELD_MESS_TEXT] := GetFirstLine(LogArr[i]._Text);
            n.Text[FIELD_MESS_TYPE] := IntToStr(LogArr[i]._MessType);

            lastlevel := LogArr[i]._Level;

        end;

        lOpenedLogFilename.Text := ExtractFileName(odLogOpen.FileName);
        tvLog.ExpandAllVirtual;

    end;
end;

procedure TfMain.tvLogGetNodeTextColor(Sender: TObject;
  ANode: TTMSFMXTreeViewVirtualNode; AColumn: Integer;
  var ATextColor: TAlphaColor);
begin
    if ANode.Text[FIELD_MESS_TYPE] = IntToStr(MESS_TYPE_TEXT)    then ATextColor := TAlphaColorRec.Slategray;
    if ANode.Text[FIELD_MESS_TYPE] = IntToStr(MESS_TYPE_WARNING) then ATextColor := TAlphaColorRec.Orangered;
    if ANode.Text[FIELD_MESS_TYPE] = IntToStr(MESS_TYPE_ERROR)   then ATextColor := TAlphaColorRec.Red;
    if ANode.Text[FIELD_MESS_TYPE] = IntToStr(MESS_TYPE_QUERY)   then ATextColor := TAlphaColorRec.Dodgerblue;
end;





{*******************************************************************************
     методы функционала закладки ПРОГРАММ И ВЕРСИЙ
*******************************************************************************}
procedure TfMain.lbProgramsChange(Sender: TObject);
begin
    eProgName.Text      := mngProgs.ProgsArray[ lbPrograms.ItemIndex ].name;
    eProgDetail.Text    := mngProgs.ProgsArray[ lbPrograms.ItemIndex ].detail;
    eProgIcon.Text      := mngProgs.ProgsArray[ lbPrograms.ItemIndex ].icon;
    eProgCondition.Text := mngProgs.ProgsArray[ lbPrograms.ItemIndex ].condition;

    ProgData.name      := eProgName.Text;
    ProgData.detail    := eProgDetail.Text;
    ProgData.icon      := eProgIcon.Text;
    ProgData.condition := eProgCondition.Text;

    CheckProgChanges;

    mngProgs.LoadVersionData(true);
    mngProgs.RefreshVersionList;
end;

procedure TfMain.lbVersionsChange(Sender: TObject);
begin

    cbVersionType.ItemIndex := mngProgs.VersionsArray[ lbVersions.ItemIndex ].status;
    eVersionDetail.Text := mngProgs.VersionsArray[ lbVersions.ItemIndex ].detail;
    eVersionPath.Text := mngProgs.VersionsArray[ lbVersions.ItemIndex ].filename;
    eVersionCondition.Text := mngProgs.VersionsArray[ lbVersions.ItemIndex ].condition;

    VersData.status := cbVersionType.ItemIndex;
    VersData.detail := eVersionDetail.Text;
    VersData.filename := eVersionPath.Text;
    VersData.condition := eVersionCondition.Text;

    CheckVersChanges;

end;

procedure TfMain.bProgAddClick(Sender: TObject);
begin
    mngProgs.ProgCreate;
    mngProgs.LoadProgData(true);
    mngProgs.RefreshProgList;
end;

procedure TfMain.bProgClearClick(Sender: TObject);
begin
    eProgName.Text      := ProgData.name;
    eProgDetail.Text    := ProgData.detail;
    eProgIcon.Text      := ProgData.icon;
    eProgCondition.Text := ProgData.condition;
    CheckProgChanges;
end;

procedure TfMain.bVersionAddClick(Sender: TObject);
begin
    mngProgs.VersionCreate;
    mngProgs.LoadVersionData(true);
    mngProgs.RefreshVersionList;
end;

procedure TfMain.bVersionClearClick(Sender: TObject);
begin
    cbVersionType.ItemIndex := VersData.status;
    eVersionDetail.Text     := VersData.detail;
    eVersionPath.Text       := VersData.filename;
    eVersionCondition.Text  := VersData.condition;

    CheckVersChanges;
end;

procedure TfMain.bVersionDelClick(Sender: TObject);
begin
    if MessageDlg('Удалить версию?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = IDNo then exit;

    mngProgs.VersionDelete;
    mngProgs.LoadVersionData(true);
    mngProgs.RefreshVersionList;
    ClearVersFields;
    CheckVersChanges;
end;

procedure TfMain.bProgDelClick(Sender: TObject);
begin
    if MessageDlg('Удалить программу и все ее версии?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = IDNo then exit;

    mngProgs.ProgDelete;
    mngProgs.LoadProgData(true);
    mngProgs.RefreshProgList;
    ClearProgFields;
    CheckProgChanges;
end;

procedure TfMain.bProgIconOpenClick(Sender: TObject);
begin

    odLogOpen.InitialDir := ICON_FILEPATH;
    odLogOpen.DefaultExt := '';
    odLogOpen.Filter := '';

    if odLogOpen.Execute then
        eProgIcon.Text := ExtractFileName(odLogOpen.FileName);

end;

procedure TfMain.bProgSaveClick(Sender: TObject);
begin
    mngProgs.ProgUpdate( eProgName.Text, eProgDetail.Text, eProgIcon.Text, eProgCondition.Text );

    ClearProgFields;

    CheckProgChanges;

    mngProgs.LoadProgData(true);

    mngProgs.RefreshProgList;
end;

procedure TfMain.bVersionSaveClick(Sender: TObject);
begin
    mngProgs.VersionUpdate( cbVersionType.ItemIndex, eVersionDetail.Text, eVersionPath.Text, eVersionCondition.Text );

    ClearVersFields;

    CheckProgChanges;

    mngProgs.LoadVersionData(true);

    mngProgs.RefreshVersionList;

end;

procedure TfMain.cbVersionTypeChange(Sender: TObject);
begin
    if lbVersions.ItemIndex = -1 then exit;

    lVersionCondition.Visible := cbVersionType.ItemIndex = 0;
    eVersionCondition.Visible := cbVersionType.ItemIndex = 0;

    CheckVersChanges;
end;

procedure TfMain.eProgIconChange(Sender: TObject);
begin
    if lbPrograms.ItemIndex = -1 then exit;

    CheckProgChanges;
end;

procedure TfMain.eProgNameKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    if lbPrograms.ItemIndex = -1 then exit;

    CheckProgChanges;
end;

procedure TfMain.eVersionDetailKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    if lbVersions.ItemIndex = -1 then exit;

    lVersionCondition.Visible := cbVersionType.ItemIndex = 0;
    eVersionCondition.Visible := cbVersionType.ItemIndex = 0;

    CheckVersChanges;
end;

procedure TfMain.CheckProgChanges;
{ сравниваем исходные данные выбранной программы с текущими значениями
  и обновляем вид интерфейса }
begin
    bProgSave.Visible :=
        (ProgData.name      <> eProgName.Text) or
        (ProgData.detail    <> eProgDetail.Text) or
        (ProgData.icon      <> eProgIcon.Text) or
        (ProgData.condition <> eProgCondition.Text);

    bProgClear.Visible := bProgSave.Visible;
    lbMenu.Enabled     := not bProgSave.Visible;
    bProgAdd.Enabled   := not bProgSave.Visible;
    bProgDel.Enabled   := not bProgSave.Visible;
    lbPrograms.Enabled := not bProgSave.Visible;

    // блокируем редактирование версии
    lbVersions.Enabled        := not bProgSave.Visible;
    bVersionAdd.Enabled       := not bProgSave.Visible;
    bVersionDel.Enabled       := not bProgSave.Visible;
    cbVersionType.Enabled     := not bProgSave.Visible;
    eVersionDetail.Enabled    := not bProgSave.Visible;
    eVersionPath.Enabled      := not bProgSave.Visible;
    eVersionCondition.Enabled := not bProgSave.Visible;

end;

procedure TfMain.CheckVersChanges;
begin
    bVersionSave.Visible :=
        (VersData.status    <> cbVersionType.ItemIndex) or
        (VersData.detail    <> eVersionDetail.Text) or
        (VersData.filename  <> eVersionPath.Text) or
        (VersData.condition <> eVersionCondition.Text);

    bVersionClear.Visible := bVersionSave.Visible;
    lbVersions.Enabled    := not bVersionSave.Visible;
    bVersionAdd.Enabled   := not bVersionSave.Visible;
    bVersionDel.Enabled   := not bVersionSave.Visible;

    // блокируем редактирование программы
    lbMenu.Enabled        := not bVersionSave.Visible;
    bProgAdd.Enabled      := not bVersionSave.Visible;
    bProgDel.Enabled      := not bVersionSave.Visible;
    lbPrograms.Enabled    := not bVersionSave.Visible;
    eProgName.Enabled     := not bVersionSave.Visible;
    eProgDetail.Enabled   := not bVersionSave.Visible;
    bProgIconOpen.Enabled := not bVersionSave.Visible;

end;

procedure TfMain.ClearProgFields;
begin
    ProgData.name      := '';
    ProgData.detail    := '';
    ProgData.icon      := '';
    ProgData.condition := '';

    eProgName.Text      := '';
    eProgDetail.Text    := '';
    eProgIcon.Text      := '';
    eProgCondition.Text := '';
end;

procedure TfMain.ClearVersFields;
begin
    VersData.detail    := '';
    VersData.icon      := '';
    VersData.filename  := '';
    VersData.condition := '';
    VersData.status    := 2;

    eVersionDetail.Text     := '';
    eVersionPath.Text       := '';
    eVersionCondition.text  := '';
    cbVersionType.ItemIndex := 2;
end;





procedure TfMain.bOpenMouseEnter(Sender: TObject);
begin
    (Sender as TControl).Opacity := 1;
end;

procedure TfMain.bOpenMouseLeave(Sender: TObject);
begin
    (Sender as TControl).Opacity := 0.7;
end;

procedure TfMain.FormShow(Sender: TObject);
var
    Error: string;
begin

    Application.CreateForm(TfAdminPanel, fAdminPanel);

    Core := TCore.Create;
    Core.Init(
        PROG_NAME,
        CONNECTION_STRING,
        SETTINGS_TABLE_NAME,
        LOG_FILEPATH
    );

    mngProgs.Init(lbPrograms, lbVersions, ICON_FILEPATH,
        DEFAULT_PROG_ICON,
        VERSION_PERSONAL_ICON,
        VERSION_WORK_ICON,
        VERSION_TEST_ICON,
        true                   // режим администрирования, не учитывающий персональные настройки версий.
                               // показывать все, не учитывая текущего пользователя
    );

    RestoreForm(self);

    bMailSave.Visible := false;
    bMailRollback.Visible := false;
    lbMenu.ItemIndex := 0;
    RefreshMailList;

    bVersionSave.Visible := false;
    bVersionClear.Visible := false;

    tcSetup.TabIndex := 0;

    lCE;

end;

end.
