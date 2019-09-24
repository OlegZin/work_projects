object fRoleEdit: TfRoleEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1087#1086#1083#1077#1081
  ClientHeight = 230
  ClientWidth = 398
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
  object Label1: TLabel
    Left = 19
    Top = 12
    Width = 61
    Height = 17
    Caption = #1048#1084#1103' '#1088#1086#1083#1080
  end
  object Label2: TLabel
    Left = 19
    Top = 68
    Width = 60
    Height = 17
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
  end
  object Label3: TLabel
    Left = 20
    Top = 125
    Width = 148
    Height = 17
    Caption = #1040#1082#1090#1091#1072#1083#1100#1085#1086#1089#1090#1100' '#1076#1086' '#1076#1072#1090#1099
  end
  object eName: TEdit
    Left = 16
    Top = 32
    Width = 362
    Height = 25
    TabOrder = 0
    OnKeyUp = eNameKeyUp
  end
  object eValue: TEdit
    Left = 16
    Top = 88
    Width = 362
    Height = 25
    TabOrder = 1
    OnKeyUp = eValueKeyUp
  end
  object bSave: TButton
    Left = 144
    Top = 188
    Width = 106
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 2
  end
  object pickDate: TDateTimePicker
    Left = 16
    Top = 148
    Width = 362
    Height = 25
    Date = 43651.360528819440000000
    Time = 43651.360528819440000000
    ShowCheckbox = True
    TabOrder = 3
    OnChange = pickDateChange
  end
end
