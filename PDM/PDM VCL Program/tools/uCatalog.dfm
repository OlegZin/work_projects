object fCatalog: TfCatalog
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
  ClientHeight = 494
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object grdCatalog: TDBGridEh
    Left = 0
    Top = 0
    Width = 485
    Height = 453
    Align = alClient
    AutoFitColWidths = True
    DynProps = <>
    Options = [dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    OnApplyFilter = grdCatalogApplyFilter
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 453
    Width = 485
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      485
      41)
    object Button1: TButton
      Left = 8
      Top = 9
      Width = 121
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
    end
    object Button2: TButton
      Left = 356
      Top = 9
      Width = 121
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1073#1088#1072#1090#1100
      ModalResult = 1
      TabOrder = 1
    end
  end
end
