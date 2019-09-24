object fUserList: TfUserList
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
  ClientHeight = 445
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object Edit1: TEdit
    Left = 0
    Top = 25
    Width = 319
    Height = 25
    Align = alTop
    TabOrder = 0
    Text = 'Edit1'
  end
  object ComboBox1: TComboBox
    Left = 0
    Top = 0
    Width = 319
    Height = 25
    Align = alTop
    TabOrder = 1
    Text = 'ComboBox1'
  end
  object listUsers: TListBox
    Left = 0
    Top = 50
    Width = 319
    Height = 395
    Align = alClient
    DragMode = dmAutomatic
    ItemHeight = 17
    TabOrder = 2
    OnDblClick = listUsersDblClick
    OnDragOver = listUsersDragOver
  end
end
