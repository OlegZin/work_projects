object fSpecTreeFree: TfSpecTreeFree
  Left = 0
  Top = 0
  ClientHeight = 553
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object grdSpecific: TDBGridEh
    Left = 0
    Top = 0
    Width = 327
    Height = 553
    Align = alClient
    AllowedOperations = []
    AllowedSelections = []
    AutoFitColWidths = True
    DynProps = <>
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    Options = [dgIndicator, dgColumnResize, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 0
    OnDragOver = grdSpecificDragOver
    OnMouseDown = grdSpecificMouseDown
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'name'
        Footers = <>
        TextEditing = False
        Title.Caption = #1056#1072#1079#1076#1077#1083
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'icon'
        Footers = <>
        ImageList = fMain.ilTreeIcons
        KeyList.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11')
        Width = 3
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'kind'
        Footers = <>
        ImageList = fMain.ilTreeIcons
        KeyList.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12')
        Width = 3
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'aChild'
        Footers = <>
        Visible = False
        Width = 10
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
end
