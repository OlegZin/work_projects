unit uDocCreater;
{ ������ ��������� ������, ������� ��������� ������������� �������� � ������� HTML.

  ����� ������� � ������������ ������� ���������� � ������ ������� ������ ������
  HTML � CSS.

  ������������ ������������ ��� ��������� ���������� WORD ��� EXCEL, ���
  ���� �������� ��������.

  �������������� ���� ����������� � ����������� DOC ��� XLS, ����� �������������
  ����������� ��������������� ����������.

  �������� �������� � ���� �� �������� ������� ��� ����� ���� ��������� ��
  �������� �����.

  ���������� �� ������������ �������:
    - ���� ��� ����������� ������ ����������� ������� ����������� ��������� #.
      �������: #�����#, #zavNom#, #!!!#
    - � ������� ������������ ����������������� �������, ������� ������ ��������
      ����������������� �������, ����� ����� �������� ������ ����������
      ���������:
          #STYLE#     - ������ ����������� ����������� ������������� �����
          #CONTENT#   - ������ ��� ���������� ���������� ��������
                        (���������, ������� � �.�.)
          #ROW[Name]# - ������ ��� ������� �������������� ������ � �������,
                        ��� [Name] ������������ ������������� ��� �������,
                        ����� ����� ���� ��������� �������� � �����������
                        ��������� � ����� ���������. ����� ���� ������.
                        ��� ���������� ����, ������ ����� ����������� � ���������
                        ������ ������������

  ���������� ������������ ������-����. ������ ����� ������� ������������� ������
  ������� #CONTENT#, � ��� ������ ����� ������� ���������� � ����� ���������.
  ��� ���������� ��������� ���� ������� #CONTENT# ������������ ����� ���������
  ����������� ������� � ���������� � ��� ��� ������� ���������.

  ���������� �������� � �������� ��������� ��� ����������� �������� ����������
  �����������/������������� � ������� ������� ����� ������������, ��� � �������
  �������� � ����.

  �������� ������������ ��������� ��������� �������:
  1. ������������� �������
      TDocCreater.Template.LoadFromFile
              ��������� �������� ������� �� �����
      TDocCreater.Template.InitPortrait
              ������������� ������� ������� ���������� ���������� (����������
              �� ���������, ���� �� ����� ������������� �� ������� ����������
              �������� ��� ����������� ��������)
      TDocCreater.Template.InitLandscape
              ������������� ������� ������� ��������� ���������� (���������
              ������ ��� WORD)
      TDocCreater.Template.InitCustom
              ������������� ������� ������� � ����������������� ��������� �����

  3. ��������� ������ � �������������
      TDocCreater.SetBaseStyle
              ��������� � ����� ��������� ������� ����� ������ ��� ���������� � ������
      TDocCreater.SetStyle
              ��������� � ����� ��������� ����� �����
      TDocCreater.Colontitul.WordLoadFromFile
              ��������� �� ����� ������������, ������� ��� �������� ��������� � WORD
      TDocCreater.Colontitul.WordHeaderHTML
      TDocCreater.Colontitul.WordFooterHTML
              ������ ��������� ������������, ������� ��� �������� ��������� � WORD
      TDocCreater.Colontitul.ExcelHeader
      TDocCreater.Colontitul.ExcelFooter
              ��������� ������������, ������� ��� �������� ��������� � EXCEL

  4. ���������� ���������
      TDocCreater.AddParagraph
              ���������� ���������� ������� <p></p>
      TDocCreater.AddTable
              ���������� ������� <table></table>
      TDocCreater.AddRow
              ��������� ������ � ��������� ������� <tr>...</tr>
      TDocCreater.AddImage
              ���������� �������� <img />. ��� ������������ ���������, �����
              ���� �������� ��������� � ������������� �����. � ��� ��������
              ����������� �� ����������.

  5. ��������� �������� ���������
      TDocCreater.Template.HTML
              ��������� HTML ������� � ���� ������ (�������� ���������)
      TDocCreater.SaveToFile
              ���������� ��� ����� � ����� ������� �����������.
      TDocCreater.SaveToExcelFile
              ���������� ��� ����� � �������� ������� excel.
      TDocCreater.OpenFile
              ��������� ��������� ����, ����� ����������� �������
              TDocCreater.SaveToFile, �����������, ����������� � ���������� �����




==  ������ ������������ ����� � ����   =========================================

   dc := TDocCreater.Create;

   // ��� ����� ������������� ��� ������ ���������� ������ �������� ���
   // ������� ������, �������� ���������������� � ������� ���������� �������
   // ��������.
   // �� ������ ������� TEMPLATE_HTML ����� ������ ������������ �����
   // ������������ ������, � ������� ����� ����� ������ �������� ������, ��
   // ���������� �� �������� ����������

   // � ������� ���������� �����-���� �����, ����� ���� ����������� ����������
   // �����, �� ����� ��������� � ������������� � �������.
   // ����� ��������� �������� � ������ ����� ����������� ��������, ����������
   // ��� ���� ������� ��������� ����������
   dc.SetBaseStyle;

   // �������������� ���� ���������
   dc.AddParagraph('<b>�����-01</b>', 'align=right');
   dc.AddParagraph('���������', 'align=center style="font-size:12.0pt;"');
   dc.AddParagraph('������������', 'align=center');
   // ������� ���� ������ � ������������� �� ������ ����
   dc.AddParagraph('������� ��������');

   // ��������� ������ ������� � ����� ��������
   // � ���� �� ����� ������������� �����, ������� ����� �������� �������
   dc.AddTable('', 'align=center', ['10#!#', '20', '30'], ['width=50', 'width=100', 'width=150']);
   dc.AddRow('', ['110', '220', '330']);

   // �������� ���������� ������ HTML � ������� ������� � ��������� (��������,
   // ������� �������������� ��������, ��� ���������� ������� TDocCreater)
   dc.AddHTML('<br>');

   // ��������� ������ ������� � ����� ��������
   dc.AddTable('2', 'align=center', ['�', '�', '�'], ['width=150', 'width=100', 'width=50']);
   dc.AddRow('2', ['��', '��', '��']);

   // � ����� ������ ����� ��������� ����� �������

   // ��������� ��� ������ � ������ �������
   dc.AddRow('', ['1110', '2220', '3330']);
   // ��������� ����������� �����. � ������ ������ ������� ������ � ��� ���� �� 2 �������
   dc.AddRow('', ['1110', '1111'], ['', 'colspan="2"']);
   // ���������� ������� � ������� (������ � ������������ ���� �����
   // ��������� ������ ���� ������ � ����������� �� ��� ������ �������
   // � ������ ������ �� 3 �������
   dc.AddRow('', ['1110'], ['colspan="3"']);

   // ����������� �������� � ���������������� ������ � ������ ������ ������ �������
   dc.SetValue('!', '������');

   // ��������� ������� ���������� � ���� �������, ������� ����� ����� ������ ���
   // �������� ����� ������
   dc.SetWordHeader(
        '<table>'+
          '<tr>'+
            '<td>�����</td>'+
            '<td>��������</td>'+
            '<td>����������</td>'+
          '</tr>'+
          '<tr>'+
            '<td>1</td>'+
            '<td>���-��</td>'+
            '<td>�������-��</td>'+
          '</tr>'+
        '</table>'
   );

   // ��������� ����������� ������� � excel. � ���� ���������� ������ ���������
   // � �������� �� ��� �����: �����, �����������, ������.
   // &P - ����������� ������ excel, ������������ ��������� �������
   dc.SetExcelHeader('&P','','Header &P');
   dc.SetExcelFooter('Footer','','');

   // ��������� ���� � ����������� DOC. � ����� �� ������� ����� ��������� ��� XLS ��� HTML
   dc.SaveToFile( dm.TempDir + 'test.doc' );

   // ��������� ����� ����������� ���� �����������, ����������� � ������� � ����� ����������
   dc.OpenFile( dm.TempDir + 'test.doc' );



==  ������ ������������ ����� �� ������� =======================================

    ������ ('SoprDocReestr1.doc'):

        <html>
        <head>
        <meta http-equiv=Content-Type content="text/html; charset=windows-1251">
        <style>
          body { font-family:"Times New Roman",serif; font-size: 10.0pt;    [����������� �������� ������]
          p { margin:0cm;                                                   [����������� �������� ������]
          table{ border-collapse:collapse; border:none; text-align: center; [����������� �������� ������]
          td{ border:solid windowtext 1.0pt;                                [����������� �������� ������]
          @page page {size:595.3pt 841.9pt; margin:1.0cm 1.0cm 1.0cm 1.0cm; [����������� �������� ������]
          div.page {page:page;                                              [����������� �������� ������]
        </style>
        </head>
        <body lang=RU>
        <div class=page>

        <p align=right style='font-size:12.0pt;'><b>�-02 ��� �� 37</b></p>
        <p align=center><b>������ ���������������� ������������</b></p>
        <p align=center><b>#����.#</span></b></p>
        <p align=center><b>���. �#��.#</b></p>
        <table>
         <tr>
          <td width=40><p><b>� �/�</b></p></td>
          <td width=258><p><b>������������ � ����������� ������������ �� ��������</b></p></td>
          <td width=260><p><b>�������������</b></p></td>
          <td width=47><p><b>���. ���., ��.</b></p></td>
          <td width=102><p><b>���. �</b></p></td>
         </tr>
         #Row#
        </table>
        <br>
        <p>��������:#���.#</p>
        <p>����:#��.#</p>

        </div>
        </body>
        </html>

  ���:
        count:=1;

        dc := TDocCreater.Create;
        dc.Template.LoadFromFile( dm.VPTemplates+'SoprDocReestr1.doc' );
        dc.SetValue('����.', IzdNaim);
        dc.SetValue('��.', IzdCurRec^.ZavNom);
        dc.SetValue('���.', pass.seq.UserName);
        dc.SetValue('��.', datetostr(dm.Today)+'�.');

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
        dc.SaveToFile( dm.TempDir + '������������� '+IzdNaim+'.doc' );
        dc.OpenFile( dm.TempDir + '������������� '+IzdNaim+'.doc' );




==  ��������� HTML �������� ��������� � ������������ �� �������� WORD-����� =========

  1. �������� word �������� �� ����� ������������� � ��������, ��� ������� �������
  2. �������� ����������� � ������� "web-��������".
     ����������� �������� htm-���� - ������ ���������, � � ������������� �����
     header.hml - �����������
  3. ����� �������������� ��������� ������� ���������� �����.
     � �������� ����� (������� � ��������):
        �) ����� � ������� ��������:

          @page
            {mso-footnote-separator:url("...files/header.htm") fs;
             mso-footnote-continuation-separator:url("...files/header.htm") fcs;
             mso-endnote-separator:url("...files/header.htm") es;
             mso-endnote-continuation-separator:url("...files/header.htm") ecs;

          ����� ��������:

          @page WordSection1
            {size:841.9pt 595.3pt;
             mso-page-orientation:landscape;
             margin:1.0cm 1.0cm 1.0cm 1.0cm;
             mso-header-margin:35.4pt;
             mso-footer-margin:35.4pt;
             mso-header:url("...files/header.htm") h1;
             mso-footer:url("...files/header.htm") f1;
             mso-paper-source:0;..

           ������� ������� � ���������
             mso-header:url("...files/header.htm") h1;
             mso-footer:url("...files/header.htm") f1;

           ��� ������ ������ ��� ����� ��������� ������������� � ����������� ������

        �) ����� ����������� ��� </style> � �������� ����� ��� ������ #STYLE#,
           � ��� ����� ����� ������������� ����������� � ������ �����

        �) ���� � ������� ���� �������, ����� ��� ������ ����������� ���
           </table> � �������� ����� ��� ������ #ROW#.
           ���� � ������� ��������� ������, ������� ������� ������� �����������
           ����������� �������������� ��������, ��������:
           #ROW#, #ROWA#, #ROW_#, #ROW111#
           � ������ ������� ��� ���������� ������ � ������ �������, �� ���
           (������ �������� ������ AddRow) �����, ��������������:
           '', '�', '_', '111'

        �) ���� � ������� ���� ���������������� ������� ��� ������� ���������
           �������� �� �������, �������� #�����#, #�������# � �.�.
           ������� ����� ������ ������ � ���������� ��������, ��������� ����
           ��������� ���������� � ������� ������� � ������ �� ������ ����� ������

           ��������, �����: '#marker#, #������#'
           ��� ���������� ������������ �:
           <p class=MsoNormal><span lang=EN-US style='mso-ansi-language:EN-US'>#marker#, #</span>������<span
           lang=EN-US style='mso-ansi-language:EN-US'>#<o:p></o:p></span></p>

           � ������� �������� ��� � ����:
           <p class=MsoNormal><span lang=EN-US style='mso-ansi-language:EN-US'>#marker#, #������#</span></p>
           ���
           <p class=MsoNormal>#marker#, #������#</p>

     � ����� ������������(������� � ��������): �������� �������� �), �), �)

  4. �������� ��� ����� � ����� � ��������� ���������.

  5. ������������ � ��������� ��� ���������� ������:

     dc.Template.LoadFromFile( dm.VPTemplates + 'lzk.htm' );
     dc.Colontitul.WordLoadFromFile( dm.VPTemplates + 'lzk_h.htm' );




==  ���������� ��������� � �������������� ����������� ����� � EXCEL  ===========

   1. ������� ���� excel
   2. ������� � ��� � ��������� ������:

   Sub Auto_Open()
   CreateObject("WScript.Shell").RegWrite "HKCU\Software\Microsoft\Office\" _
            & Val(Application.Version) & ".0" _
            & "\Excel\Security\ExtensionHardening", 0, "REG_DWORD"
   End Sub

   3. ������� ���� ��� ����������.

   ������ ������������� ���������� ���� = 0 � ������� �� ����� ��������������
   ��������� ����� ����������. ������ ��� �� ����� ����������.
   ���� �� ���������: 1 (�������� � ���������������).
   ��� ���� ��������� ��������: 2 (���������� ��������)
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

    // ����������� ����� ������� ������, ������� ����� �������� � ���� ������� SetBaseStyle
    TEMPLATE_BASE_STYLE =
        'body{font-family:"Times New Roman",serif; font-size: 10.0pt;}'+
        'p{margin:0cm;}'+
        'table{border-collapse:collapse; border:none; text-align: center;}'+
        'td{border:solid windowtext 0.1pt;}';


    // ����������� ��� EXCEL.
    // ���������� �������� �� �����, ����������� � ������. � ������������
    // ������ ������ � �����������, �������� &P - ����� ������� ��������.
    // ������� ����� ��������� ����������� � ��� WORD � ��� EXCEL ������������
    // �� ���������� ����� ��������������� ���������� ��� ��������.

    // ����������� � ������ ������ ������� Colontitul.ExcelHeader
    TEMPLATE_EXCEL_HEADER =
        '@page{mso-header-data:"&L%s&C%s&R%s";}';
    // ����������� � ������ ������ ������� Colontitul.ExcelFooter
    TEMPLATE_EXCEL_FOOTER =
        '@page{mso-footer-data:"&L%s&C%s&R%s";}';


    // ����������� ��� WORD. �������� ������ ���� �� �����, ����� ����� �����������
    // ��������� �� ������ ��� �������� ����� (��������: c:/1/header.htm)
    // �� ����������, ��� �������� � ��������� ����� ���� ��� � TEMPLATE_WORD_COLONTITUL_HTML
    // ��� ��������� ��������� � ��� ������� � ������ ��������.
    // ������� ����� ��������� ����������� � ��� WORD � ��� EXCEL ������������
    // �� ���������� ����� ��������������� ���������� ��� ��������

    // ����������� � ������ ������ ������� Colontitul.WordHeaderHTML
    TEMPLATE_WORD_HEADER =
        '@page WordSection1 { mso-header:url("%s") h1;}';
    // ����������� � ������ ������ ������� Colontitul.WordFooterHTML
    TEMPLATE_WORD_FOOTER =
        '@page WordSection1 { mso-footer:url("%s") f1;}';

    // ������� ������ ��� ���������
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

    // ������ ��������������� ����� ��� ������������ WORD.
    // �������� ��������� mso-element:header / mso-element:footer � ��������
    // ���� ���� ������������ ������, ����� ����� ����������� ����������� �
    // ������ ������ ���������
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
       parent: TDocCreater;    // ������ �� ������������ ������ ��� �����������
                               // ������������� ��� �������

       WordHeaderHTML          // ����� (html) �������� ����������� ��� �������� � WORD
      ,WordFooterHTML          // ����� (html) ������� ����������� ��� �������� � WORD
      ,WordFullHTML            // ����� �����������, ������������ �� ����� � ������ �������������
                               // ������� � TEMPLATE_WORD_COLONTITUL_HTML
               : string;

       procedure WordLoadFromFile(filename: string);
                               // �������� ������� ������������ ����� �� ����� � WordFullHTML

       procedure ExcelHeader(left, center, right: string);
       procedure ExcelFooter(left, center, right: string);
   end;

   TTemplate = class
   public
       html: string;

       function LoadFromFile(FileName: string): boolean;
                               // �������� ������� ��������� �� �����
       procedure InitPortrait;
       procedure InitLandscape;
       procedure InitCustom(HTML: string; Height, Width: integer);
   end;

   TDocCreater = class
   private
       tables: TStringList;


       procedure InsToMarker(marker, value: string);
                               // ������ � ������ ��������/������ �� ����� ����������
                               // �������, ��� ��� ���������. ������������ ��� ����������
                               // ��������� � �� �������� #STYLE#, #CONTENT#, #ROW#

       procedure ClearMarks;   // �������� ���� ��������� �������� �����
                               // ���������� � ����

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
            E.ActiveWorkBook.SaveAs( Filename := _Filename, FileFormat := 56 {����� Excel 97-2003} );
                // �������� ��������: https://docs.microsoft.com/ru-ru/office/vba/api/excel.xlfileformat
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



    // ���� ������ ����������� �����, ��������� cc���� � ������� ������������ ����
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



    // ������ ���� �� ��������� �����
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

    // ������ ����� ����� ���� ��������� � ��������� ������
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
