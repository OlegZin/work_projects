object fRolesEditor: TfRolesEditor
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1088#1086#1083#1077#1081
  ClientHeight = 556
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    954
    556)
  PixelsPerInch = 96
  TextHeight = 17
  object bAddGroup: TSpeedButton
    Left = 184
    Top = 5
    Width = 23
    Height = 22
    Caption = '+'
    OnClick = bAddGroupClick
  end
  object bDeleteGroup: TSpeedButton
    Left = 206
    Top = 5
    Width = 22
    Height = 22
    Caption = '-'
    OnClick = bDeleteGroupClick
  end
  object Label1: TLabel
    Left = 11
    Top = 7
    Width = 92
    Height = 17
    Caption = #1043#1088#1091#1087#1087#1099' '#1088#1086#1083#1077#1081
  end
  object bAddRoleToGroup: TSpeedButton
    Left = 575
    Top = 5
    Width = 23
    Height = 22
    Caption = '<-'
    OnClick = bAddRoleToGroupClick
  end
  object bDeleteRoleFromGroup: TSpeedButton
    Left = 526
    Top = 5
    Width = 22
    Height = 22
    Caption = '-'
    OnClick = bDeleteRoleFromGroupClick
  end
  object Label2: TLabel
    Left = 258
    Top = 7
    Width = 170
    Height = 17
    Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1077' '#1088#1086#1083#1080
  end
  object Label3: TLabel
    Left = 604
    Top = 7
    Width = 121
    Height = 17
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1088#1086#1083#1077#1081
  end
  object bAddRole: TSpeedButton
    Left = 881
    Top = 5
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '+'
    OnClick = bAddRoleClick
  end
  object bDeleteRole: TSpeedButton
    Left = 903
    Top = 5
    Width = 22
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '-'
    OnClick = bDeleteRoleClick
  end
  object bEditRole: TSpeedButton
    Left = 924
    Top = 5
    Width = 22
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '...'
    OnClick = bEditRoleClick
  end
  object bEditGroup: TSpeedButton
    Left = 227
    Top = 5
    Width = 22
    Height = 22
    Caption = '...'
    OnClick = bEditGroupClick
  end
  object bEditRoleInGroup: TSpeedButton
    Left = 547
    Top = 5
    Width = 22
    Height = 22
    Caption = '...'
    OnClick = bEditRoleInGroupClick
  end
  object grdGroups: TDBGridEh
    Left = 8
    Top = 27
    Width = 241
    Height = 521
    Anchors = [akLeft, akTop, akBottom]
    AutoFitColWidths = True
    DynProps = <>
    IndicatorOptions = []
    Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    OnCellClick = grdGroupsCellClick
    OnDblClick = grdGroupsDblClick
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'name'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object grdGroupRoles: TDBGridEh
    Left = 255
    Top = 27
    Width = 314
    Height = 521
    Anchors = [akLeft, akTop, akBottom]
    AutoFitColWidths = True
    DynProps = <>
    IndicatorOptions = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    OnApplyFilter = grdGroupRolesApplyFilter
    OnDblClick = grdGroupRolesDblClick
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'name'
        Footers = <>
        Title.Caption = #1056#1086#1083#1100
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'value'
        Footers = <>
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object grdRoles: TDBGridEh
    Left = 575
    Top = 27
    Width = 371
    Height = 521
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DynProps = <>
    IndicatorOptions = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 2
    OnApplyFilter = grdRolesApplyFilter
    OnDblClick = grdRolesDblClick
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'name'
        Footers = <>
        Title.Caption = #1056#1086#1083#1100
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'value'
        Footers = <>
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
end
