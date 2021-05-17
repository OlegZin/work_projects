object fListSearch: TfListSearch
  Left = 0
  Top = 0
  ActiveControl = eText
  BorderStyle = bsNone
  Caption = 'fListSearch'
  ClientHeight = 312
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 370
    Height = 312
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    TabOrder = 0
    object lbVariants: TListBox
      Left = 1
      Top = 22
      Width = 368
      Height = 264
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = 23
      ExplicitWidth = 366
      ExplicitHeight = 262
    end
    object eText: TEdit
      Left = 1
      Top = 1
      Width = 368
      Height = 21
      Align = alTop
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
    end
    object bSelect: TButton
      Left = 1
      Top = 286
      Width = 368
      Height = 25
      Align = alBottom
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 2
      ExplicitLeft = 2
      ExplicitTop = 285
      ExplicitWidth = 366
    end
  end
  object ActionList1: TActionList
    Left = 320
    Top = 40
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 27
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Action2'
      ShortCut = 13
      OnExecute = Action2Execute
    end
  end
end
