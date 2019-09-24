object fCreateWorkgroup: TfCreateWorkgroup
  Left = 0
  Top = 0
  ActiveControl = eGroupName
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1088#1072#1073#1086#1095#1077#1081' '#1075#1088#1091#1087#1087#1099
  ClientHeight = 82
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object eGroupName: TEdit
    Left = 8
    Top = 13
    Width = 327
    Height = 25
    TabOrder = 0
    OnKeyUp = eGroupNameKeyUp
  end
  object bOk: TButton
    Left = 128
    Top = 49
    Width = 75
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 1
    OnClick = bOkClick
  end
end
