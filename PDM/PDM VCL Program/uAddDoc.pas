unit uAddDoc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VCL.Imaging.jpeg, uConstants, StrUtils;

const
    SAVE_MODE_NEW_DOCUMENT = 0;
    SAVE_MODE_NEW_VERSION  = 1;

type

    TCallback = function (object_id, version_id, doc_type: integer; Name, ext, FileName, Comment: string): boolean of object;

  TfAddDoc = class(TForm)
    eFileName: TEdit;
    bSelectFile: TButton;
    OpenDialog1: TOpenDialog;
    bOk: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    eName: TEdit;
    pUnderline: TPanel;
    Image1: TImage;
    bClose: TButton;
    lPresentError: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    bAddSubFile: TImage;
    bDeleteSubFile: TImage;
    Label4: TLabel;
    lObjectName: TLabel;
    Panel3: TPanel;
    Panel2: TPanel;
    Label5: TLabel;
    mComment: TMemo;
    procedure bSelectFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure eNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    ext : string;       // расширение файла
  public
    { Public declarations }
    object_name             // им€ объекта-владельца документа
   ,filename                // полный путь до файла
   ,name                    // им€ документа. чаще всего совпадает с именем файла
   ,version                 // номер создаваемой версии документа
            : string;

    object_id               // id объекта-владельца документа
   ,version_id              // id предыдущей версии данного документа
   ,mode                    // режим работы:
                            //   0 - добавление первой версии,
                            //   1 - добавление последующей версии (нельз€ править путь и им€)
//   ,doc_type                // тип документа (id из таблицы document_type)
            : integer;

    callback: TCallback;
  end;

var
  fAddDoc: TfAddDoc;

implementation

{$R *.dfm}
uses
    uMain, uPhenixCore, uFileManager;

procedure TfAddDoc.bSelectFileClick(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
        eFileName.Text := OpenDialog1.FileName;
        eName.Text := ChangeFileExt( ExtractFileName( OpenDialog1.FileName ), '' );
        ext := ExtractFileExt( ExtractFileName( OpenDialog1.FileName ) );
        Image1.Picture.Bitmap.Handle := mngFile.GetThumbnailImage( eFileName.Text, IMAGE_PREVWIEW_SIZE, IMAGE_PREVWIEW_SIZE);
//        doc_type := mngFile.GetFileType( ext );

        // проверка на дублирование имени (считаем, что это перва€ верси€ документа)
        if not eName.ReadOnly then
        begin
            lPresentError.Visible := mngData.GetNextVersionNumber( eName.Text + ext, object_id ) <> 1;
            bOk.Enabled := not lPresentError.Visible;
        end;

    end;
end;

procedure TfAddDoc.eNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    // проверка на дублирование имени (считаем, что это перва€ верси€ документа)
    if not eName.ReadOnly then
    begin
        lPresentError.Visible := mngData.GetNextVersionNumber( eName.Text + ext, object_id ) <> 1;
        bOk.Enabled := not lPresentError.Visible;
    end;
end;

procedure TfAddDoc.FormShow(Sender: TObject);
begin
    // сбрасываем данные перед показом
    eFileName.Text        := filename;
    eName.Text            := ChangeFileExt( name, '' );
    lPresentError.Visible := false;
    lObjectName.Caption   := object_name;
    mComment.Lines.Text   := '';
    ext                   := '';

    // сразу подгружаем картинку, если указан файл
    if   filename <> ''
    then Image1.Picture.Bitmap.Handle := mngFile.GetThumbnailImage( eFileName.Text, IMAGE_PREVWIEW_SIZE, IMAGE_PREVWIEW_SIZE)
    else Image1.Picture.Bitmap.Handle := 0;

    if filename <> '' then
    ext := ExtractFileExt( filename );

    case mode of
        0: // добавление нового файла
        begin
            bSelectFile.Visible := true;
            eName.ReadOnly := false;
            bOk.Enabled := false;
        end;
        1, 2: // добавление новой версии существующего / рабочей версии
        begin
            bSelectFile.Visible := false;
            eName.ReadOnly := true;
            bOk.Enabled := true;
        end;
    end;
end;

procedure TfAddDoc.bOkClick(Sender: TObject);
begin

    if    Assigned(Callback) then

    if    Callback( object_id, version_id, 0{doc_type}, eName.Text, ext, eFileName.Text, mComment.Lines.Text )
    then  ShowMessage('ƒокумент успешно добавлен');

    Close;

end;

procedure TfAddDoc.bCloseClick(Sender: TObject);
begin
    Close;
end;

end.
