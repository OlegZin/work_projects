object Form2: TForm2
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Form2'
  ClientHeight = 413
  ClientWidth = 1044
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1044
    Height = 413
    Align = alClient
    Caption = 'Panel2'
    Color = clYellow
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 264
    ExplicitTop = 240
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Panel1: TPanel
      Left = 6
      Top = 6
      Width = 1032
      Height = 401
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 1044
      ExplicitHeight = 413
      DesignSize = (
        1032
        401)
      object Button1: TButton
        Left = 929
        Top = 8
        Width = 75
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 0
        OnClick = Button1Click
        ExplicitLeft = 941
      end
      object Edit1: TEdit
        Left = 8
        Top = 8
        Width = 915
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        ExplicitWidth = 927
      end
      object Memo1: TMemo
        Left = 8
        Top = 48
        Width = 915
        Height = 327
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 2
        ExplicitWidth = 927
        ExplicitHeight = 339
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 560
    Top = 48
  end
end
