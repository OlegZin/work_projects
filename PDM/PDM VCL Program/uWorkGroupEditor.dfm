object fWorkgroupEditor: TfWorkgroupEditor
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1088#1072#1073#1086#1095#1080#1093' '#1075#1088#1091#1087#1087
  ClientHeight = 654
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object Splitter1: TSplitter
    Left = 253
    Top = 0
    Width = 5
    Height = 654
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 253
    Height = 654
    Align = alLeft
    TabOrder = 0
    DesignSize = (
      253
      654)
    object bCreateWorkgroup: TSpeedButton
      Left = 183
      Top = 11
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '+'
      OnClick = bCreateWorkgroupClick
    end
    object bDeleteWorkgroup: TSpeedButton
      Left = 205
      Top = 11
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '-'
      OnClick = bDeleteWorkgroupClick
    end
    object bEditWorkgroup: TSpeedButton
      Left = 227
      Top = 11
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '...'
      OnClick = bEditWorkgroupClick
    end
    object Label1: TLabel
      Left = 4
      Top = 14
      Width = 106
      Height = 17
      Caption = #1056#1072#1073#1086#1095#1080#1077' '#1075#1088#1091#1087#1087#1099
    end
    object grdWorkgroups: TDBGridEh
      Left = 1
      Top = 34
      Width = 251
      Height = 619
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoFitColWidths = True
      DynProps = <>
      IndicatorOptions = []
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      OnCellClick = grdWorkgroupsCellClick
      OnDblClick = grdWorkgroupsDblClick
      OnSelectionChanged = grdWorkgroupsSelectionChanged
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
  end
  object Panel2: TPanel
    Left = 258
    Top = 0
    Width = 758
    Height = 654
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 0
      Top = 337
      Width = 758
      Height = 5
      Cursor = crVSplit
      Align = alTop
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 758
      Height = 337
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Splitter3: TSplitter
        Left = 328
        Top = 0
        Width = 5
        Height = 337
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 328
        Height = 337
        Align = alLeft
        Caption = 'Panel5'
        TabOrder = 0
        DesignSize = (
          328
          337)
        object bAddUser: TSpeedButton
          Left = 258
          Top = 11
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '+'
          OnClick = bAddUserClick
        end
        object bDeleteUser: TSpeedButton
          Left = 280
          Top = 11
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '-'
          OnClick = bDeleteUserClick
        end
        object bUserEdit: TSpeedButton
          Left = 302
          Top = 11
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = bUserEditClick
        end
        object Label2: TLabel
          Left = 4
          Top = 14
          Width = 151
          Height = 17
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' '#1074' '#1075#1088#1091#1087#1087#1077
        end
        object grdUsers: TDBGridEh
          Left = 1
          Top = 34
          Width = 326
          Height = 302
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoFitColWidths = True
          DynProps = <>
          IndicatorOptions = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          OnCellClick = grdUsersCellClick
          OnDblClick = grdUsersDblClick
          OnSelectionChanged = grdUsersSelectionChanged
          Columns = <
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'name'
              Footers = <>
              Title.Caption = #1048#1084#1103
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'todate'
              Footers = <>
              Title.Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object Panel6: TPanel
        Left = 333
        Top = 0
        Width = 425
        Height = 337
        Align = alClient
        Caption = 'Panel6'
        TabOrder = 1
        DesignSize = (
          425
          337)
        object bAddPersonalRole: TSpeedButton
          Left = 355
          Top = 11
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '+'
          OnClick = bAddPersonalRoleClick
          ExplicitLeft = 359
        end
        object bDeletePersonalRole: TSpeedButton
          Left = 377
          Top = 11
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '-'
          OnClick = bDeletePersonalRoleClick
          ExplicitLeft = 381
        end
        object bEditPersonalRole: TSpeedButton
          Left = 399
          Top = 11
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = bEditPersonalRoleClick
          ExplicitLeft = 403
        end
        object Label6: TLabel
          Left = 5
          Top = 14
          Width = 152
          Height = 17
          Caption = #1048#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1077' '#1087#1088#1072#1074#1072
        end
        object grdRightsPersonal: TDBGridEh
          Left = 1
          Top = 34
          Width = 423
          Height = 302
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoFitColWidths = True
          DynProps = <>
          IndicatorOptions = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          OnDblClick = grdRightsPersonalDblClick
          Columns = <
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'name'
              Footers = <>
              Title.Caption = #1048#1084#1103
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'value'
              Footers = <>
              Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'todate'
              Footers = <>
              Title.Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 342
      Width = 758
      Height = 312
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter4: TSplitter
        Left = 328
        Top = 0
        Width = 5
        Height = 312
      end
      object Panel8: TPanel
        Left = 333
        Top = 0
        Width = 425
        Height = 312
        Align = alClient
        Caption = 'Panel8'
        TabOrder = 0
        DesignSize = (
          425
          312)
        object Label5: TLabel
          Left = 6
          Top = 11
          Width = 192
          Height = 17
          Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1072#1084#1080' '#1087#1088#1072#1074#1072
        end
        object grdRights: TDBGridEh
          Left = 1
          Top = 31
          Width = 423
          Height = 280
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoFitColWidths = True
          DynProps = <>
          IndicatorOptions = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          Columns = <
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'group_name'
              Footers = <>
              Title.Caption = #1043#1088#1091#1087#1087#1072
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'name'
              Footers = <>
              Title.Caption = #1048#1084#1103
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
        object checkShowAll: TCheckBox
          Left = 317
          Top = 12
          Width = 103
          Height = 17
          Anchors = [akTop, akRight]
          Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
          TabOrder = 1
          OnClick = checkShowAllClick
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 328
        Height = 312
        Align = alLeft
        Caption = 'Panel7'
        TabOrder = 1
        DesignSize = (
          328
          312)
        object bEditLinkGroup: TSpeedButton
          Left = 303
          Top = 8
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = bEditLinkGroupClick
          ExplicitLeft = 302
        end
        object bLinkGroup: TSpeedButton
          Left = 259
          Top = 8
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '+'
          OnClick = bLinkGroupClick
          ExplicitLeft = 258
        end
        object bUnlinkGroup: TSpeedButton
          Left = 281
          Top = 8
          Width = 23
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '-'
          OnClick = bUnlinkGroupClick
          ExplicitLeft = 280
        end
        object Label3: TLabel
          Left = 5
          Top = 11
          Width = 83
          Height = 17
          Caption = #1043#1088#1091#1087#1087#1099' '#1087#1088#1072#1074
        end
        object grdRightsGroups: TDBGridEh
          Left = 1
          Top = 31
          Width = 326
          Height = 280
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoFitColWidths = True
          DynProps = <>
          IndicatorOptions = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          OnCellClick = grdRightsGroupsCellClick
          OnDblClick = grdRightsGroupsDblClick
          OnSelectionChanged = grdRightsGroupsSelectionChanged
          Columns = <
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'name'
              Footers = <>
              Title.Caption = #1048#1084#1103
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'todate'
              Footers = <>
              Title.Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
  end
end
