object fListSearch: TfListSearch
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'fListSearch'
  ClientHeight = 192
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 213
    Height = 192
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    TabOrder = 0
    object lbVariants: TListBox
      Left = 1
      Top = 20
      Width = 211
      Height = 146
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbVariantsClick
      OnDblClick = lbVariantsDblClick
      OnKeyUp = lbVariantsKeyUp
    end
    object bSelect: TButton
      Left = 1
      Top = 166
      Width = 211
      Height = 25
      Align = alBottom
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Enabled = False
      TabOrder = 1
      OnClick = lbVariantsDblClick
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 211
      Height = 19
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 2
      object bClose: TImage
        Left = 192
        Top = 0
        Width = 19
        Height = 19
        Cursor = crHandPoint
        Align = alRight
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000140000
          0014080200000002EB8A5A000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
          434944415478DA63FCFFFF3F03B9807154333534BF9355157A7C1B17179F66A0
          520803A2018D4B94CD6822C4DA8CA91FAB4EDA6826DFD954083032A38A7830AA
          99440000C51E5FD986BEA8850000000049454E44AE426082}
        Stretch = True
        OnClick = bCloseClick
        ExplicitLeft = 348
      end
      object eText: TEdit
        Left = 0
        Top = 0
        Width = 192
        Height = 19
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        Text = 'assa'
        OnKeyUp = eTextKeyUp
        ExplicitHeight = 21
      end
    end
  end
  object ActionList1: TActionList
    Left = 16
    Top = 32
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 27
      OnExecute = Action1Execute
    end
  end
end
