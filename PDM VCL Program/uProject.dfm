object fProject: TfProject
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1077#1082#1090': '#1053#1055#1057'5.01.02.114'#1042' '#1044#1086#1088#1072#1073#1086#1090#1082#1072
  ClientHeight = 676
  ClientWidth = 1000
  Color = clBtnFace
  Constraints.MinWidth = 1000
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 17
  object pcProject: TPageControl
    Left = 0
    Top = 0
    Width = 1000
    Height = 651
    ActivePage = tabStructure
    Align = alClient
    TabOrder = 0
    TabWidth = 199
    OnChange = pcProjectChange
    object tabStructure: TTabSheet
      Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072
      object Splitter1: TSplitter
        Left = 401
        Top = 0
        Width = 5
        Height = 619
        ExplicitLeft = 385
        ExplicitHeight = 495
      end
      object PageControl1: TPageControl
        Left = 406
        Top = 0
        Width = 586
        Height = 619
        ActivePage = pageList
        Align = alClient
        TabOrder = 0
        TabWidth = 200
        object pageList: TTabSheet
          Caption = #1057#1087#1080#1089#1086#1082
          object Splitter2: TSplitter
            Left = 0
            Top = 321
            Width = 578
            Height = 5
            Cursor = crVSplit
            Align = alTop
            ExplicitWidth = 688
          end
          object Splitter3: TSplitter
            Left = 401
            Top = 326
            Width = 5
            Height = 261
            ExplicitHeight = 220
          end
          object grdProjectObject: TDBGridEh
            Left = 0
            Top = 0
            Width = 578
            Height = 321
            Align = alTop
            AllowedOperations = [alopUpdateEh]
            DynProps = <>
            IndicatorOptions = []
            Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            PopupMenu = popObject1
            TabOrder = 0
            OnApplyFilter = grdProjectObjectApplyFilter
            OnCellClick = grdProjectObjectCellClick
            OnDblClick = grdProjectObjectDblClick
            OnGetCellParams = grdProjectObjectGetCellParams
            OnMouseDown = grdProjectObjectMouseDown
            OnSelectionChanged = grdProjectObjectSelectionChanged
            Columns = <
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'kind'
                Footers = <>
                ImageList = fMain.ilTreeIcons
                KeyList.Strings = (
                  '0'
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
                  '12'
                  '100')
                MaxWidth = 20
                MinWidth = 20
                ReadOnly = True
                Title.Caption = ' '
                Width = 20
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'icon'
                Footers = <>
                ImageList = fMain.ilTreeIcons
                KeyList.Strings = (
                  '0'
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
                MaxWidth = 20
                MinWidth = 20
                ReadOnly = True
                Title.Caption = ' '
                Width = 20
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'has_docs'
                Footers = <>
                ImageList = fMain.ilHas_docs
                KeyList.Strings = (
                  '0'
                  '1')
                MaxWidth = 20
                MinWidth = 20
                ReadOnly = True
                Title.Caption = ' '
                Width = 20
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'status'
                Footers = <>
                ImageList = imgObjectState
                KeyList.Strings = (
                  '-1'
                  '0'
                  '1'
                  '2'
                  '3'
                  '4')
                MaxWidth = 20
                MinWidth = 20
                ReadOnly = True
                Title.Caption = ' '
                Width = 20
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'full_mark'
                Footers = <>
                TextEditing = False
                Title.Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
                Width = 300
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'name'
                Footers = <>
                TextEditing = False
                Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                Width = 300
              end
              item
                AlwaysShowEditButton = True
                ButtonStyle = cbsNone
                CellButtons = <>
                DynProps = <>
                EditButton.DefaultAction = False
                EditButton.Enabled = False
                EditButton.ShortCut = 32
                EditButton.Style = ebsEllipsisEh
                EditButton.Visible = False
                EditButton.Width = 10
                EditButtons = <>
                FieldName = 'count'
                Footers = <>
                Title.Caption = #1050#1086#1083'-'#1074#1086
                OnUpdateData = grdProjectObjectColumns5UpdateData
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'parent_name'
                Footers = <>
                Title.Caption = #1042#1093#1086#1076#1080#1090' '#1074' '#1089#1086#1089#1090#1072#1074
                Width = 180
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'ispol'
                Footers = <>
                Title.Caption = #1048#1089#1087#1086#1083#1085#1077#1085#1080#1077
                Width = 100
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
          object grdDocs: TDBGridEh
            Left = 0
            Top = 326
            Width = 401
            Height = 261
            Align = alLeft
            ColumnDefValues.Title.TitleButton = True
            DynProps = <>
            GridLineParams.VertEmptySpaceStyle = dessNonEh
            IndicatorOptions = []
            OddRowColor = clWindow
            Options = [dgTitles, dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
            ReadOnly = True
            RowDetailPanel.Height = 600
            RowDetailPanel.BevelInner = bvNone
            RowDetailPanel.BevelOuter = bvNone
            RowDetailPanel.BorderStyle = bsNone
            RowDetailPanel.Color = clWhite
            RowDetailPanel.MinHeight = 350
            RowPanel.Active = True
            STFilter.InstantApply = True
            STFilter.Location = stflInTitleFilterEh
            TabOrder = 1
            TitleParams.BorderInFillStyle = True
            OnCellMouseClick = grdDocsCellMouseClick
            OnDblClick = grdDocsDblClick
            OnSelectionChanged = grdDocsSelectionChanged
            Columns = <
              item
                Alignment = taRightJustify
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'type'
                Footers = <>
                KeyList.Strings = (
                  '0'
                  '1'
                  '2'
                  '3'
                  '4'
                  '5'
                  '6'
                  '7'
                  '8'
                  '9'
                  '10')
                MaxWidth = 40
                MinWidth = 40
                ShowImageAndText = True
                STFilter.Visible = False
                Title.Caption = ' '
                Width = 40
              end
              item
                AutoFitColWidth = False
                CellButtons = <>
                Checkboxes = False
                DynProps = <>
                EditButtons = <>
                FieldName = 'is_agree'
                Footers = <>
                KeyList.Strings = (
                  '0'
                  '1')
                MaxWidth = 20
                MinWidth = 20
                STFilter.Visible = False
                Title.Caption = ' '
                Title.ShowImageAndText = False
                Width = 20
              end
              item
                Alignment = taCenter
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'full_version'
                Footers = <>
                MinWidth = 40
                STFilter.Visible = False
                Title.Alignment = taCenter
                Title.Caption = #1042#1077#1088'.'
              end
              item
                Alignment = taCenter
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'created'
                Footers = <>
                MinWidth = 70
                STFilter.Visible = False
                Title.Alignment = taCenter
                Title.Caption = #1044#1072#1090#1072
                Width = 100
              end
              item
                Alignment = taLeftJustify
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'doc_name'
                Footers = <>
                STFilter.Visible = False
                TextEditing = False
                Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                Width = 350
              end
              item
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'obj_name'
                Footers = <>
                STFilter.Visible = False
                Title.Caption = #1054#1073#1098#1077#1082#1090
                Width = 200
              end
              item
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'autor_fio'
                Footers = <>
                STFilter.Visible = False
                Title.Caption = #1040#1074#1090#1086#1088
                Width = 200
              end
              item
                AutoFitColWidth = False
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'editor_fio'
                Footers = <>
                STFilter.Visible = False
                Title.Caption = #1056#1077#1076#1072#1082#1090#1086#1088
                Width = 200
              end
              item
                CellButtons = <>
                DynProps = <>
                EditButtons = <>
                FieldName = 'doc_comment'
                Footers = <>
                STFilter.Visible = False
                Visible = False
              end>
            object RowDetailData: TRowDetailPanelControlEh
              object bCreateDocPreview: TButton
                Left = 584
                Top = 179
                Width = 115
                Height = 25
                Caption = #1055#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088
                TabOrder = 0
              end
            end
          end
          object Panel9: TPanel
            Left = 406
            Top = 326
            Width = 172
            Height = 261
            Align = alClient
            TabOrder = 2
            object iProjectFilePreview: TImage
              Left = 1
              Top = 1
              Width = 170
              Height = 136
              Align = alTop
              Center = True
              Proportional = True
              Stretch = True
              ExplicitWidth = 242
            end
            object Splitter4: TSplitter
              Left = 1
              Top = 137
              Width = 170
              Height = 5
              Cursor = crVSplit
              Align = alTop
              ExplicitTop = 106
              ExplicitWidth = 280
            end
            object mProjectFileComment: TMemo
              Left = 1
              Top = 142
              Width = 170
              Height = 118
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              TabOrder = 0
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
          ImageIndex = 1
          object webSpecification: TWebBrowser
            Left = 0
            Top = 0
            Width = 578
            Height = 587
            Align = alClient
            TabOrder = 0
            ExplicitLeft = 2
            ExplicitTop = 2
            ExplicitWidth = 688
            ExplicitHeight = 546
            ControlData = {
              4C000000BD3B0000AB3C00000000000000000000000000000000000000000000
              000000004C000000000000000000000001000000E0D057007335CF11AE690800
              2B2E126209000000000000004C0000000114020000000000C000000000000046
              8000000000000000000000000000000000000000000000000000000000000000
              00000000000000000100000000000000000000000000000000000000}
          end
          object StringGrid: TStringGrid
            Left = 0
            Top = 0
            Width = 578
            Height = 587
            Align = alClient
            ColCount = 10
            FixedCols = 0
            RowCount = 100
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
            TabOrder = 1
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 401
        Height = 619
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel2'
        TabOrder = 1
        object gridProjectTree: TDBGridEh
          Left = 0
          Top = 89
          Width = 401
          Height = 530
          Align = alClient
          AutoFitColWidths = True
          DynProps = <>
          IndicatorOptions = []
          Options = [dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghExtendVertLines]
          PopupMenu = popStructure
          SortLocal = True
          TabOrder = 0
          OnCellClick = gridProjectTreeCellClick
          OnDblClick = grdProjectObjectDblClick
          OnDragDrop = gridProjectTreeDragDrop
          OnDragOver = gridProjectTreeDragOver
          OnEndDrag = gridProjectTreeEndDrag
          OnMouseDown = gridProjectTreeMouseDown
          OnSelectionChanged = gridProjectTreeSelectionChanged
          Columns = <
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'mem_name'
              Footers = <>
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'mem_kind'
              Footers = <>
              ImageList = fMain.ilTreeIcons
              KeyList.Strings = (
                '0'
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
              MaxWidth = 20
              MinWidth = 20
              ReadOnly = True
              Width = 20
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'mem_icon'
              Footers = <>
              ImageList = fMain.ilTreeIcons
              KeyList.Strings = (
                '0'
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
              MaxWidth = 20
              MinWidth = 20
              ReadOnly = True
              Width = 20
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'mem_child'
              Footers = <>
              Visible = False
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'status'
              Footers = <>
              ImageList = imgObjectState
              KeyList.Strings = (
                '-1'
                '0'
                '1'
                '2'
                '3'
                '4')
              MaxWidth = 20
              MinWidth = 20
              ReadOnly = True
              Width = 20
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'editor_id'
              Footers = <>
              ImageList = listEditor
              KeyList.Strings = (
                '0')
              MaxWidth = 20
              MinWidth = 20
              NotInKeyListIndex = 1
              ReadOnly = True
              Width = 20
            end
            item
              CellButtons = <>
              DynProps = <>
              EditButtons = <>
              FieldName = 'checker_id'
              Footers = <>
              ImageList = listChecker
              KeyList.Strings = (
                '0')
              MaxWidth = 20
              MinWidth = 20
              NotInKeyListIndex = 1
              ReadOnly = True
              Width = 20
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object pToolPanel: TPanel
          Left = 0
          Top = 0
          Width = 401
          Height = 89
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            401
            89)
          object sbObjectToWork: TSpeedButton
            Left = 2
            Top = 3
            Width = 34
            Height = 34
            Hint = #1042#1079#1103#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
            Action = actToWork
            Flat = True
            Glyph.Data = {
              4E150000424D4E1500000000000036000000280000003C0000001E0000000100
              18000000000018150000C40E0000C40E00000000000000000000FFFFFFFFFFFF
              9B9B9B3A3A3A454545939393FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9B9B9B7F7F7F
              7F7F7F939393FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2F2F0000007171716E6E6E0B0B0B
              1B1B1BE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7F4CB1224CB1224CB1224CB1224CB1227F7F7F7F7F7FFF
              FFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7171716E6E6E7F7F7F7F7F7FE8E8E8
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF818181000000EFEFEFFFFFFFFFFFFFFFFFFF2B2B2B0E0E0EFDFDFDFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB1224CB1224CB1
              224CB1224CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFF8181817F
              7F7FEFEFEFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFDFDFDFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000B4B4B4FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF5B5B5B030303909090C0C0C0FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB122FFFFFF4CB1224CB1224CB1
              224CB1224CB1224CB1227F7F7FFFFFFF7F7F7FB4B4B4FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF5B5B5B7F7F7F909090C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF000000D2D2D2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B
              5B5B000000111111000000777777A6A6A6C8C8C8FFFFFFFFFFFF7F7F7F4CB122
              4CB1224CB1224CB122FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F
              7FFFFFFF7F7F7FD2D2D2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B5B5B7F7F7F7F
              7F7F7F7F7F7F7F7FA6A6A6C8C8C8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1919
              19727272FFFFFFFFFFFFFFFFFFFFFFFF454545010101E2E2E2FFFFFF96969600
              00000000000000004949497F7F7F4CB1224CB1224CB1224CB1224CB122FFFFFF
              FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F7F7F7F7F727272FFFF
              FFFFFFFFFFFFFFFFFFFF4545457F7F7FE2E2E2FFFFFF9696967F7F7F7F7F7F7F
              7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB9B9B9000000B0B0B0FFFFFFFFFF
              FF444444070707FCFCFCFFFFFFFFFFFFFAFAFACBCBCBFFFFFFE1E1E10000007F
              7F7F4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFF4CB122
              4CB1224CB1224CB1227F7F7FB9B9B97F7F7FB0B0B0FFFFFFFFFFFF4444447F7F
              7FFCFCFCFFFFFFFFFFFFFAFAFACBCBCBFFFFFFE1E1E17F7F7F989898DCDCDCFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFF7E7E7E000000C8C8C8585858000000FCFCFCFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2B2B2B7F7F7F4CB1224CB1224CB1224C
              B1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1227F7F7F
              FFFFFF7E7E7E7F7F7FC8C8C85858587F7F7FFCFCFCFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              A3A3A3000000070707EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFF4F4F46D6D6D7F7F7F4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFF
              FFFFFFFFFF4CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFA3A3A37F7F7F
              7F7F7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F47F7F
              7FDCDCDCC8C8C87F7F7F8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF525252121212FCFCFCFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB1
              224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224C
              B1224CB1227F7F7FFFFFFFFFFFFF5252527F7F7FFCFCFCFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8C8C7F7F
              7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF676767000000FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB1
              22FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFF67
              67677F7F7FFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF797979858585C4C4C47F7F7F7F7F7FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1D1D1000000DADADAFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB122FFFFFF4CB1224CB1224CB1
              224CB1224CB1224CB1227F7F7FFFFFFFD1D1D17F7F7FDADADAFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFF8F8F8FFFFFFFFFFFFE9E9E97F7F7FEDEDEDFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF515151676767FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F
              4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1227F7F7FFFFF
              FFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              B4B4B47F7F7FF9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0F0F
              0FC5C5C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F4CB1224CB122
              4CB1224CB1224CB1227F7F7F7F7F7FFFFFFFFFFFFFFFFFFF7F7F7FC5C5C5FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7C7C77F7F7FA0A0A0FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000DCDCDCFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7F7F7FDCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFD7D7D77F7F7F797979FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF232323A9A9A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D600000000
              0000E7E7E7FFFFFFDBDBDBADADADAFAFAFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFF
              7F7F7FA9A9A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D67F7F7F7F7F7FE7E7E7FF
              FFFFDBDBDBADADADAFAFAFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F303030
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFC8C8C80000008A8A8A5D5D5D0000003B3B3B0303030C
              0C0C080808000000747474FFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFC8C8C87F7F7F8A8A8A5D5D5D7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F747474FFFFFFFFFFFFFFFFFFF0F0F00000009F9F9FFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D60000
              00616161FFFFFFFFFFFF5555553C3C3CCACACAFFFFFFFDFDFD9B9B9B00000089
              8989FFFFFFFFFFFFF0F0F07F7F7F9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D67F7F7F616161FFFF
              FFFFFFFF5555557F7F7FCACACAFFFFFFFDFDFD9B9B9B7F7F7F898989FFFFFFFF
              FFFFFFFFFFC6C6C6000000AFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFD3D3D3000000888888FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC9C9C9000000CBCBCBFFFFFFFFFFFFC6
              C6C67F7F7FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFD3D3D37F7F7F888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFC9C9C97F7F7FCBCBCBFFFFFFFFFFFFFFFFFFB9B9B900
              0000A7A7A7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECEC
              0A0A0A000000CCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFF4545452E2E2EFFFFFFFFFFFFFFFFFFB9B9B97F7F7FA7A7A7FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECEC7F7F7F7F7F7F
              CCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFA1A1A1000000AFAFAFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDDDD010101000000CFCFCF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7B7B7B777777FFFFFFDDDDDD0000
              00DADADAFFFFFFFFFFFFFFFFFFA1A1A17F7F7FAFAFAFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDDDD7F7F7F7F7F7FCFCFCFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7B7B7B777777FFFFFFDDDDDD7F7F7FDADADAFFFF
              FFFFFFFFFFFFFFFFFFFFB9B9B9000000AEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2727272D2D2D0909096A6A6AFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF3030300909091B1B1B000000FFFFFF3232328B8B8BFFFFFFFFFFFFFFFF
              FFFFFFFFB9B9B97F7F7FAEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7F7F7F7F6A6A6AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F
              7F7F7F7F7F7F7F7F7FFFFFFF7F7F7F8B8B8BFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFB9B9B9000000818181F9F9F9FFFFFFFFFFFFFFFFFFD9D9D9232323101010C6
              C6C60A0A0AE0E0E0FFFFFFFFFFFFFFFFFFFFFFFF3E3E3E040404FFFFFFFEFEFE
              3232322727276E6E6E535353FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB9B9B97F7F
              7F818181F9F9F9FFFFFFFFFFFFFFFFFFD9D9D97F7F7F7F7F7FC6C6C67F7F7FE0
              E0E0FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFEFEFE7F7F7F7F7F7F
              6E6E6E7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF0000000000
              004545454D4D4D2D2D2D0000003E3E3EFFFFFF9090901B1B1BFFFFFFFFFFFFFF
              FFFFFFFFFF2F2F2F050505F3F3F3FFFFFFFFFFFFFFFFFF161616000000484848
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7FFFFFFF9090907F7F7FFFFFFFFFFFFFFFFFFFFFFFFF7F
              7F7F7F7F7FF3F3F3FFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7FFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC2C2C2676767606060818181F2F2
              F2FFFFFFFFFFFF7575752C2C2CFFFFFFFFFFFFFFFFFF626262131313FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF3535357E7E7EFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFC2C2C2676767606060818181F2F2F2FFFFFFFFFF
              FF7575757F7F7FFFFFFFFFFFFFFFFFFF6262627F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF7F7F7F7E7E7EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFABABAB0202
              02F6F6F6FFFFFFFFFFFF333333636363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFBFBFBF9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFABABAB7F7F7FF6F6F6FFFF
              FFFFFFFF7F7F7F636363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF9
              F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0D0D0D313131FFFFFFFFFFFFC7C7
              C7000000929292FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFC7C7C77F7F7F9292
              92FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFF1F1F10F0F0F000000B2B2B2FFFFFFCCCCCC0000007D7D7DFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              F1F1F17F7F7F7F7F7FB2B2B2FFFFFFCCCCCC7F7F7F7D7D7DFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              5757570000001010109797977878780000009A9A9AFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5757577F7F7F
              7F7F7F9797977878787F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E59090902B2B2B
              040404020202616161FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E59090907F7F7F7F7F7F7F7F7F
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
          end
          object sbObjectToCheck: TSpeedButton
            Left = 38
            Top = 3
            Width = 34
            Height = 34
            Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1085#1072' '#1087#1088#1086#1074#1077#1088#1082#1091
            Action = actToCheck
            Flat = True
            Glyph.Data = {
              4E150000424D4E1500000000000036000000280000003C0000001E0000000100
              18000000000018150000C40E0000C40E00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF868686FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8686
              867F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A2A2AFFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7F4CB1224CB1224CB1224CB1224CB1227F7F7F7F7F7FFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7878787F7F7F7F7F
              7F9393938B8B8B8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A9393937F7F7F7F
              7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF292929FFFFFFFFFFFF7F7F7F4CB1224CB1224CB1
              224CB1224CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F9B9B9BFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8383837F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              2C2C2CFFFFFF7F7F7F4CB1224CB1224CB1224CB122FFFFFF4CB1224CB1224CB1
              224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F777777
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7C7C7C7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFF6F6F6F2F2F2FFFFFFFFFFFFFFFFFF393939FFFFFF7F7F7F4CB122
              4CB1224CB1224CB122FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F
              7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6
              F6F6F2F2F2FFFFFFFFFFFFFFFFFF7F7F7F7F7F7FC8C8C8FFFFFFEFEFEF7F7F7F
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C7C7C7F7F7FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFADADAD04040400000050
              5050FFFFFFFFFFFF3838387F7F7F4CB1224CB1224CB1224CB1224CB122FFFFFF
              FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFADADAD7F7F7F7F7F7F7F7F7FFFFFFFFF
              FFFF7F7F7F7F7F7F7F7F7FF8F8F8FFFFFFC7C7C77F7F7FBFBFBFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7C7C7C7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFF8A8A8A000000A3A3A3C9C9C9222222070707EBEBEB3636367F
              7F7F4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFF4CB122
              4CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF8A8A8A7F7F7FA3A3A3C9C9C97F7F7F7F7F7FEBEBEB7F7F7FA2A2A27F7F7F7F
              7F7FFFFFFFFFFFFFAEAEAE7F7F7FD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              7C7C7C7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9F000000A6A6
              A6FFFFFFFFFFFFFFFFFF3939390B0B0B0D0D0D7F7F7F4CB1224CB1224CB1224C
              B1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1227F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9F7F7F7FA6A6A6FFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7F7F7F7F999999FFFFFF7F7F7F7F7F7FFFFFFFFFFFFF7F
              7F7F7F7F7FF9F9F9FFFFFFFFFFFFFFFFFFFFFFFF7C7C7C7F7F7FFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFD4D4D4000000919191FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF6363630000007F7F7F4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFF
              FFFFFFFFFF4CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFD4D4D47F7F7F919191FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F
              7F8F8F8FFFFFFFEAEAEA7F7F7F7F7F7FFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFF
              FFFFFFFFFFFFFFFF7C7C7C7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6000000
              979797FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8A8A87F7F7F4CB1
              224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224C
              B1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFFFFFFC6C6C67F7F7F979797FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8A8A8E4E4E4FFFFFFFFFFFFB7B7
              B77F7F7FBBBBBBFFFFFFF7F7F77F7F7F797979FFFFFFFFFFFFFFFFFF7C7C7C7F
              7F7FFFFFFFFFFFFFFFFFFFD7D7D7000000626262FFFFFFFFFFFFFFFFFFA9A9A9
              3C3C3CEFEFEFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB1
              22FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFF
              FFFFFFFFFFD7D7D77F7F7F626262FFFFFFFFFFFFFFFFFFA9A9A97F7F7FEFEFEF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7979797F7F7FFCFCFCFFFF
              FFCFCFCF7F7F7FB4B4B4FFFFFFFFFFFF7C7C7C7F7F7FFFFFFFFFFFFFFFFFFF00
              0000646464FFFFFFFFFFFFFFFFFFCBCBCB0000000A0A0A000000FFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB122FFFFFF4CB1224CB1224CB1
              224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F646464FF
              FFFFFFFFFFFFFFFFCBCBCB7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFF7979797F7F7FEDED
              EDFFFFFF7C7C7C7F7F7FFFFFFFFBFBFB1515150000000B0B0B00000000000000
              00000000004B4B4BFFFFFF646464000000C9C9C9FFFFFFFFFFFFFFFFFF7F7F7F
              4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1227F7F7FFFFF
              FFFFFFFFFFFFFFFBFBFB7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7FFFFFFF7F7F7F7F7F7FC9C9C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF7F7F7F7F7F7FFFFFFFFFFFFF7F7F7F7F7F7FFFFFFF8080807F7F7FFFFF
              FFC3C3C3000000CBCBCBB4B4B4B3B3B3B3B3B3BBBBBB7E7E7E121212FEFEFEFF
              FFFF676767000000B0B0B0FFFFFFFFFFFFFFFFFF7F7F7F7F7F7F4CB1224CB122
              4CB1224CB1224CB1227F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFC3C3C37F7F
              7FCBCBCBB4B4B4B3B3B3B3B3B3BBBBBB7E7E7E7F7F7FFEFEFEFFFFFF7F7F7F7F
              7F7FB0B0B0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9D97F7F7F858585
              FFFFFFFBFBFB7F7F7F6363637E7E7E7F7F7FFFFFFF808080242424FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF838383333333F8F8F8D7D7D7FFFFFF848484000000FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080807F7F7FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF8383837F7F7FF8F8F8D7D7D7FFFFFF7F7F7F7F7F7FB4B4B4FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC7F7F7FD9D9D9FFFFFFF5F5F57F7F7F
              7F7F7F6C6C6CFFFFFF2F2F2F747474FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3B3B
              3B7D7D7D727272262626FFFFFFFFFFFFC0C0C0000000606060E9E9E9FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFA6A6A6000000EAEAEAFFFFFF7D7D7D000000DDDDDD
              FFFFFF7F7F7F747474FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7D7D7D7272
              727F7F7FFFFFFFFFFFFFC0C0C07F7F7F7F7F7FE9E9E9FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFA6A6A67F7F7FEAEAEAFFFFFF7D7D7D7F7F7FDDDDDDFFFFFF0C0C0C
              ABABABFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9101010C5C5C5303030797979FFFF
              FFFFFFFFFFFFFFC4C4C415151500000020202037373736363636363638383841
              41410000000C0C0C1B1B1B000000999999FFFFFFFFFFFF7F7F7FABABABFFFFFF
              FFFFFFFFFFFFFFFFFFF9F9F97F7F7FC5C5C57F7F7F797979FFFFFFFFFFFFFFFF
              FFC4C4C47F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F999999FFFFFFE2E2E20C0C0CD5D5D5FFFFFFFFFFFFFFFFFF
              FFFFFFEBEBEB000000F4F4F40D0D0DAEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFBABABA8080806E6E6E6F6F6F7676767979797878787A7A7A7575758C8C8CE3
              E3E3FFFFFFFFFFFFE2E2E27F7F7FD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFEBEBEB
              7F7F7FF4F4F47F7F7FAEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBABABA8080
              806E6E6E6F6F6F7676767979797878787A7A7A7575758C8C8CE3E3E3FFFFFFFF
              FFFFB7B7B70A0A0AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0000000F1F1F1
              0A0A0ADCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFD9D9D9C0C0C0CECECEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB7B7B77F
              7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C07F7F7FF1F1F17F7F7FDCDCDC
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9D9C0C0
              C0CECECEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF868686303030FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF7B7B7B313131C0C0C00A0A0AFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D72222220606060E0E0E0A0A0A0D0D
              0DB0B0B0FFFFFFFFFFFFFFFFFFFFFFFF8686867F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF7B7B7B7F7F7FC0C0C07F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFD7D7D77F7F7F7F7F7F7F7F7F7F7F7F7F7F7FB0B0B0FFFF
              FFFFFFFFFFFFFFFFFFFF474747757575FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF36
              36367979798484842C2C2CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              E6E6E6000000474747E9E9E9FFFFFFF5F5F57B7B7B000000B4B4B4FFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F79797984
              84847F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E67F7F7F
              7F7F7FE9E9E9FFFFFFF5F5F57B7B7B7F7F7FB4B4B4FFFFFFFFFFFFFFFFFF0000
              00D8D8D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF080808C2C2C22F2F2F7B7B7BFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF242424545454FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFA4A4A4000000FFFFFFFFFFFFFFFFFF7F7F7FD8D8D8FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FC2C2C27F7F7F7B7B7BFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFA4A4A47F7F7FFFFFFFFFFFFFFFFFFF0606062323233939393939393434
              342B2B2B1E1E1E030303FBFBFB000000BEBEBEFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFE5E5E5F2F2F2000000BFBFBFE9E9E9E2E2E2E2E2E2E2E2E2E6E6E6DADADA
              000000C8C8C8FFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7FFBFBFB7F7F7FBEBEBEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5F2
              F2F27F7F7FBFBFBFE9E9E9E2E2E2E2E2E2E2E2E2E6E6E6DADADA7F7F7FC8C8C8
              FFFFFFFFFFFFDBDBDB4F4F4F0000000000001616169494949D9D9DC9C9C9FFFF
              FF000000E8E8E8FFFFFFFFFFFFFFFFFFFFFFFF9D9D9D00000000000000000000
              0000000000000000000000000000000000000000000000A3A3A3FFFFFFFFFFFF
              DBDBDB7F7F7F7F7F7F7F7F7F7F7F7F9494949D9D9DC9C9C9FFFFFF7F7F7FE8E8
              E8FFFFFFFFFFFFFFFFFFFFFFFF9D9D9D7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FA3A3A3FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF8A8A8A222222000000626262D8D8D8B3B3B3101010F9F9F9FFFFFFFFFF
              FFFFFFFFFFFFFFCECECE010101434343FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2D2D2D9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8A8A8A
              7F7F7F7F7F7F7F7F7FD8D8D8B3B3B37F7F7FF9F9F9FFFFFFFFFFFFFFFFFFFFFF
              FFCECECE7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA
              313131030303000000505050FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8
              E81C1C1C0C0C0C1E1E1E1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1E1E1E000000A1
              A1A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA7F7F7F7F7F7F
              7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E87F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FA1A1A1FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDB939393EDEDED
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2525253434349292928B8B
              8B8A8A8A8B8B8B8D8D8D9090909191910B0B0B9E9E9EFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDB939393EDEDEDFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F9292928B8B8B8A8A8A8B8B
              8B8D8D8D9090909191917F7F7F9E9E9EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF3131311D1D1DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
              F8DFDFDF151515989898FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8DFDFDF7F7F
              7F989898FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8B000000AFAFAF
              9F9F9F7676765454542929290E0E0E0C0C0C0D0D0D0E0E0E000000C1C1C1FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8B7F7F7FAFAFAF9F9F9F767676
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FC1C1C1FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFBFBFBF0000000000002424244444446464648A8A8A
              A8A8A8BBBBBBD2D2D2E6E6E6FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFBFBFBF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F8A8A8AA8A8A8BBBBBB
              D2D2D2E6E6E6FAFAFAFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
          end
          object sbObjectToReady: TSpeedButton
            Left = 76
            Top = 3
            Width = 34
            Height = 34
            Hint = #1055#1088#1080#1089#1074#1086#1080#1090#1100' '#1089#1090#1072#1090#1091#1089' "'#1075#1086#1090#1086#1074#1086'"'
            Action = actToReady
            Flat = True
            Glyph.Data = {
              4E150000424D4E1500000000000036000000280000003C0000001E0000000100
              18000000000018150000C40E0000C40E00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7F4CB1224CB1224CB1224CB1224CB1227F7F7F7F7F7FFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D79B9B9B969696969696969696
              9696969696969696969696969696969A9A9A9A9A9A7F7F7F4CB1224CB1224CB1
              224CB1224CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFD7D7D79B9B9B969696969696969696969696969696
              9696969696969696969696969696969696969696969696969696969696969696
              96A0A0A0F0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3
              E3E30F0F0F000000232323242424242424242424242424242424242424242424
              2424242424247F7F7F4CB1224CB1224CB1224CB122FFFFFF4CB1224CB1224CB1
              224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFFFFFFFFE3E3E37F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000004F4F4FF4F4F4FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB122
              4CB1224CB1224CB122FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F
              7FFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FF4F4F4FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFDFDFDF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF9E9E9E060606FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB1224CB122FFFFFF
              FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFF9E9E
              9E7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFDEDEDE7F7F7FF0F0F0FFFFFFFFFFFFFFFFFFFFFFFF505050595959FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F
              7F7F4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFFFFFFFF4CB122
              4CB1224CB1224CB1227F7F7FFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FA0A0A0
              FFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224C
              B1224CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1227F7F7F
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF
              4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFF7F7F7F4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFF
              FFFFFFFFFF4CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFF7F7F7F7F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FCFCFC7F7F7F4CB1
              224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224C
              B1224CB1227F7F7FFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FCFCFCFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFF
              FFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF9B9B9B0000005A5A5AFFFFFF7F7F7F4CB1224CB1224CB1224CB1
              22FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              9B9B9B7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E
              5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6A6A6000000797979
              0000007272727F7F7F4CB1224CB1224CB1224CB122FFFFFF4CB1224CB1224CB1
              224CB1224CB1224CB1227F7F7FFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6A6A67F7F7F7979797F7F7FA0A0A0
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF767676000000CBCBCBFFFFFFCDCDCD2424247272727F7F7F
              4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1227F7F7FFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7676767F7F7FCBCBCBFFFFFFCDCDCD7F7F7FACACACFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFF
              FFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF646464000000BA
              BABAFFFFFFFFFFFFFFFFFFD5D5D52424247272727F7F7F7F7F7F4CB1224CB122
              4CB1224CB1224CB1227F7F7F7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FBABABAFFFFFFFF
              FFFFFFFFFF8585857F7F7FD0D0D0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFF
              FFFFFFFFFFFFFFFFFFFF606060000000CACACAFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFD5D5D5242424727272FFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF
              2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7FCACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F
              7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9A
              FFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFF8C8C
              8CE9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343111111FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF8C8C8CE9E9E9FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF
              4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF050505494949FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFE5E5E5000000727272FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A
              9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5
              E57F7F7F727272FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFF
              FFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD5D5D50000
              00A2A2A2FFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD5D5D57F7F7FA2A2A2FFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E
              5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC000000D0D0D0FFFFFFFFFF
              FFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFACACAC7F7F7FD0D0D0FFFFFFFFFFFFFFFFFF7F7F
              7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFA1A1A1ECECECFFFFFFFFFFFFFFFFFF2121219A9A9AFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFA1A1A1ECECECFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFF
              FFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5F5F5FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9A
              FFFFFFFFFFFFFFFFFFFFFFFF4C4C4C5D5D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219C9C9CFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9C9C9CFFFFFFFFFFFFFFFFFFFFFFFF
              808080242424FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFF4F4F4000000D8D8D8FFFFFFFFFFFFFFFFFFFFFFFF8080807F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4
              F4F47F7F7FD8D8D8FFFFFFFFFFFFFFFFFFFFFFFFFDFDFD000000909090FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4F0F0F0FFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFD7F7F7F909090FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFAEAEAE0000002424245D5D5D6060605F5F5F5F5F5F
              5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F
              5F5F5F5F5F5F5F595959070707000000E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFAEAEAE7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7FE4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFDFDFD8181814F4F4F515151515151515151515151515151515151515151
              5151515151515151515151515151515151515151515151515151515151519E9E
              9EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFD81
              81817F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9E9E9EFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
          end
          object sbLoadSpec: TSpeedButton
            Left = 264
            Top = 3
            Width = 34
            Height = 34
            Hint = #1048#1084#1087#1086#1088#1090' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080
            Anchors = [akTop, akRight]
            Flat = True
            Glyph.Data = {
              FE0A0000424DFE0A00000000000036000000280000001E0000001E0000000100
              180000000000C80A000074120000741200000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFDFCEC3E7DFDBD2C8C3D7CDC8D0C6C1E0D7D2DAD1CCDAD0CCD9D0
              CBD8CFCAD8CFCADBD1CCD9CFCBD8CFCAD7CDC8DAD0CBDCD2CEDCD2CDDBD1CDDB
              D2CEC7B8ADC7B8ADFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
              FFFFF5ECE6F5F7F9999B9BBBBCBC8F9090BBBCBCDBDCDDD7D8D8DCDDDEFFFFFF
              FFFFFFEBECECFDFEFFFFFFFFF4F5F5FFFFFFDCDDDEE3E5E5EAEBECFAFCFDDAD1
              CBDAD1CBFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9
              E2F4F5F6A8A8A8E0E0E08C8C8CA3A3A3E0E0E0DADADAE2E2E27ACDF97DCCF67D
              CCF67DCCF67DCCF67DCCF67DCCF67DCCF67DCCF67DCCF67DCCF67DCCF67DCEF8
              6AB4DBFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF4E9E3F0F1F2
              9F9F9FBABABAC6C6C6C6C6C6BBBBBBB6B6B6B9B9B982D0F985CEF585CEF585CE
              F585CEF585CEF585CEF585CEF585CEF585CEF585CEF585CEF586CFF667B6E0FF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2EFF0F1D9D9D9D7
              D7D7E5E5E5E7E7E7D9D9D9DADADADDDDDD82CFF985CEF585CEF585CEF585CEF5
              85CEF585CEF585CEF585CEF585CEF585CEF585CEF585CEF576C7F2FFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2E5E5E5E6E6E6E3E3
              E3F6F6F6F5F5F5F5F5F5F5F5F577C1E886CFF685CEF585CEF585CEF585CEF585
              CEF585CEF585CEF585CEF585CEF585CEF585CEF57CCCF6FFFFFFFFFFFFFFFFFF
              0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2EFF0F1D2D2D2D5D5D5D3D3D3E3E3E3
              E1E1E1E1E1E1E1E1E16EB7DD86D0F785CEF585CEF585CEF585CEF585CEF585CE
              F585CEF585CEF585CEF585CEF585CEF57DCCF6FFFFFFFFFFFFFFFFFF0000FFFF
              FFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2E4E4E4E6E6E6E4E4E4F4F4F4F3F3F3F3
              F3F3F3F3F369B2D987D0F885CEF585CEF585CEF585CEF585CEF585CEF585CEF5
              85CEF585CEF585CEF585CEF57FCDF6FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFF3E9E2F0F1F2E1E1E1E3E3E3E1E1E1F2F2F2F0F0F0F0F0F0F0F0
              F064ADD587D1F885CEF585CEF585CEF585CEF585CEF585CEF585CEF585CEF585
              CEF585CEF585CEF581CEF7FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
              FFFFF3E9E2F0F1F2E5E5E5E6E6E6E5E5E5F5F5F5F4F4F4F4F4F4F4F4F45EA7D0
              8CD6FD89D2F989D2F989D2F987D1F885CEF585CEF585CEF585CEF585CEF585CE
              F585CEF583CEF7FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9
              E2EFF0F0CACACACECECECCCCCCDBDBDBDADADADADADADADADA59A6D161A6CC60
              A6CC60A6CC5FA5CC69ACD189D2F988D2F888D1F888D1F888D1F888D1F888D1F8
              86D2FBFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2
              E5E5E5E6E6E6E4E4E4F5F5F5F4F4F4F4F4F4F4F4F45EAEDB65B0DC65B0DC65B0
              DC65B0DC64B0DC599FC759A0C759A0C759A0C759A0C759A0C7579FC8649DBCFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2E4E4E4E4
              E4E4E2E2E2F7F7F7F5F5F5F6F6F6F4F4F45EADDB65B0DB65B0DB65B0DB5FAEDB
              56A8D856AAD956AADA56AADA56AADA56AADA56AADA53A9DA64A6CBFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F1F3F3D2D2D2E7E7E7E8E8
              E8C6C6C6CCCCCCBCBCBCDBDBDB53A8DA5AABDA5AABDA54A9DA80B0CAECECECE3
              E7E9E3E7E9E3E7E9E3E7E9E3E7E9DAD1CADAD1CAFFFFFFFFFFFFFFFFFFFFFFFF
              0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2EFF0F1D5D5D5D5D5D5D3D3D3EBEBEB
              E9E9E9EBEBEBE6E6E6E1E1E1E1E1E1E5E5E5BBBBBBBEBEBEC4C4C4BDBDBDD3D3
              D3CECECEE4E4E4D8D9DADAD1CBDAD1CBFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
              FFFFFFFFFFFFFFFFFFFFF3E9E2F1F2F3CCCCCCDFDFDFE0E0E0C2C2C2CBCBCBB9
              B9B9D5D5D5EDEDEDEAEAEAEEEEEEC6C6C6CDCDCDCACACAE7E7E7DEDEDEDDDDDD
              EDEDEDE0E1E2DAD1CADAD1CAFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFF3E9E2F3F4F4C6C6C6E8E8E8EAEAEAAEAEAEBBBBBBA4A4A4DADA
              DAF5F5F5F2F2F2F8F8F8B4B4B4B2B2B29F9F9FE0E0E0E7E7E7D8D8D8F6F6F6E7
              E8E8D9D0C9D9D0C9FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
              FFFFF3E9E2F2F3F4D0D0D0E6E6E6E8E8E8C0C0C0C8C8C8B8B8B8D0D0D0F5F5F5
              F2F2F2F6F6F6C6C6C6CECECEC7C7C7EBEBEBE5E5E5DCDCDCF5F5F5E6E7E8D9D0
              C9D9D0C9FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9
              E2EFF0F1D3D3D3D4D4D4D2D2D2E7E7E7E5E5E5E6E6E6E4E4E4E0E0E0E0E0E0E4
              E4E4B7B7B7E7E7E7E9E9E9E7E7E7D3D3D3CCCCCCE3E3E3D7D8D9DAD1CBDAD1CB
              FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2
              E6E6E6E6E6E6E4E4E4F9F9F9F8F8F8F9F9F9F6F6F6F3F3F3F3F3F3F7F7F7D0D0
              D0CFCFCFCDCDCDCACACAE7E7E7E5E5E5F6F6F6E7E8E9D9D0C9D9D0C9FFFFFFFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F2F3F4C6C6C6E6
              E6E6E9E9E9ADADADBBBBBBA1A1A1C7C7C7F5F5F5F1F1F1F7F7F7BBBBBBDAD1CA
              CBCBCBD0D0D0D8D8D8E1E1E1F4F4F4E6E7E8D9D0C9D9D0C9FFFFFFFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2E0E0E0E5E5E5E4E4
              E4ECECECE9E9E9E8E8E8E9E9E9F3F3F3F2F2F2F6F6F6BEBEBEE0E0E0FBFBFBF8
              F8F8E5E5E5D9D9D9F5F5F5E6E7E8D9D0C9D9D0C9FFFFFFFFFFFFFFFFFFFFFFFF
              0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F2F2C2C2C2D6D6D6D7D7D7BBBBBB
              C1C1C1B5B5B5C9C9C9E3E3E3E1E1E1E5E5E5BDBDBDC3C3C3B5B5B5DBDBDBD5D5
              D5D5D5D5E3E3E3D8D9DADAD1CBDAD1CBFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
              FFFFFFFFFFFFFFFFFFFFF3E9E2F1F3F3D4D4D4E7E7E7E8E8E8CECECED3D3D3CB
              CBCBDBDBDBF5F5F5F3F3F3F7F7F7CFCFCFD3D3D3D3D3D3CFCFCFDCDCDCDEDEDE
              F6F6F6E7E8E9D9D0C9D9D0C9FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFF3E9E2F1F2F3D8D8D8E5E5E5E5E5E5DADADAE3E3E3D7D7D7E7E7
              E7F3F3F3F1F1F1F7F7F7B3B3B3A8A8A8CACACAFFFFFFE5E5E5DDDDDDF5F5F5E6
              E7E8D9D0C9D9D0C9FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
              FFFFF3E9E2F2F3F4CACACAE7E7E7E8E8E8BEBEBEC1C1C1B2B2B2C9C9C9F6F6F6
              F2F2F2F6F6F6C8C8C8D3D3D3CFCFCFD0D0D0D7D7D7DEDEDEF5F5F5E7E8E8D9D0
              C9D9D0C9FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9
              E2EFF0F1D4D4D4D5D5D5D3D3D3E7E7E7E6E6E6E7E7E7E5E5E5E1E1E1E1E1E1E2
              E2E2D7D7D7A6A6A6AFAFAFA9A9A9DADADAD4D4D4E3E3E3D8D9DADAD1CBDAD1CB
              FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF3E9E2F0F1F2
              E2E2E2E3E3E3DFDFDFF3F3F3F1F1F1F3F3F3F5F5F5F3F3F3F1F1F1F2F2F2E1E1
              E1FBFBFBFBFBFBFAFAFAE2E2E2DFDFDFF9F9F9E8E9EAD9D0C9D9D0C9FFFFFFFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF4EBE5F4F7F8CCCDCDD5
              D6D7DCDDDEFFFFFFFFFFFFE7E9E9D6D7D8EEEFF0FFFFFFFFFFFFF4F5F5E3E4E5
              D1D2D3E9EAEBF7F8F9DFE0E0CCCDCEDEE0E1DBD3CDDBD3CDFFFFFFFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFE6D5C9F0E7E1E3D9D2E5DBD4E3D8
              D2E2D7D0E1D7D0E4DAD3E6DBD4E3D9D2E1D7D0E1D7D0E1D6D0E5DAD4E6DBD5E4
              DAD3E2D7D0E3D9D2E7DCD6E8DED8D2C1B6D2C1B6FFFFFFFFFFFFFFFFFFFFFFFF
              0000}
            ParentShowHint = False
            ShowHint = True
            Transparent = False
            OnClick = sbLoadSpecClick
          end
          object sbAddObject: TSpeedButton
            Left = 224
            Top = 3
            Width = 34
            Height = 34
            Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1086#1073#1098#1077#1082#1090
            Anchors = [akTop, akRight]
            Flat = True
            Glyph.Data = {
              4E1B0000424D4E1B000000000000360000002800000044000000220000000100
              180000000000181B0000C30E0000C30E00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFEFCDAEDF46CC2E2A2
              D6E8FFFFFFFFFFFEADDCEC6AC0E1D6ECF10000004CB1224CB1224CB1224CB122
              000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFEFCE8
              E8E8D4D4D4D4D4D4FFFFFFFFFFFEE8E8E8D4D4D4E8E8E80000007F7F7F7F7F7F
              7F7F7F7F7F7F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF9FAFF
              FFFFFFFFFE73C6E415B7EB1AA7D3FFFFFFFFFFFF45BCE200A2D554B7E0000000
              4CB1224CB1224CB1224CB122000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFBF9FAFFFFFFFFFFFEC3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3
              C3C3C30000007F7F7F7F7F7F7F7F7F7F7F7F000000FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFCFBFB4BBBDF00A0D7E9EFF2FFFFFFA9D8ED2CC1ED019FD3F9F8F8FAFCF8
              31B4E100A1D89AD1E80000004CB1224CB1224CB1224CB122000000FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFCFBFBD4D4D4C3C3C3F4F4F4FFFFFFE8E8E8C3C3C3C3C3C3
              F9F8F8FAFCF8C3C3C3C3C3C3D4D4D40000007F7F7F7F7F7F7F7F7F7F7F7F0000
              00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFEFEFEFDFEFEFFFFFFF0F5FA33C7E500AFE647B7D9EAF1F25BBBDD
              23BAE40CABDF009CD2009BD510A8DB08A4DB48B3DA0000004CB1224CB1224CB1
              224CB122000000FEFEFEFDFEFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFEFEFEFDFEFEFFFFFFF4F4F4C3C3C3C3C3C3C3C3C3
              F4F4F4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C30000007F7F
              7F7F7F7F7F7F7F7F7F7F000000FEFEFEFDFEFDFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFBFFFFFFFFFFFF95CEE7
              33C9EC00ADE100A5DA09AEDF0AADDD10ACDE0FA9DD11AADE0FA7DB0FA6D908A4
              D70000004CB1224CB1224CB1224CB122000000FFFFFCFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFBFFFFFF
              FFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C30000007F7F7F7F7F7F7F7F7F7F7F7F000000FFFFFCFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFEFBFFFFFCA9D7EA
              00AEDF86CAE0FFFFFF8ECEE02BC5EA0AB1E10EB1E411AFE10FAEE00000000000
              000000000000000000000000000000004CB1224CB1224CB1224CB12200000000
              0000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFDFEFB
              FFFFFCD4D4D4C3C3C3D4D4D4FFFFFFE8E8E8C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C30000000000000000000000000000000000000000007F7F7F7F7F7F7F7F7F7F
              7F7F000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF
              FFFFFFFDFEFEFFFFFF50C2E30AC0EB00B1E51BA8D918BCE709B0E413B2E40AB1
              DF05ABE013ACDE0000004CB1224CB1224CB1224CB1224CB1224CB1224CB1224C
              B1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB122000000FFFFFF
              FFFFFFFFFFFFFFFFFFFDFEFEFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C30000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFF4F84CBDDE16C0E805B6
              E70BB5E710B4E405B0E21FB1E460C5ED6AC9EE0000004CB1224CB1224CB1224C
              B1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB122
              4CB1224CB122000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C30000007F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F000000FFFFFFFFFFFFFFFFFFFCFEFCFFFFFFFFFF
              FFFFFFFFC5DEEA47D1F306B8E60EB5E603ADE147BEEC81D6F56DCEF066C9ED00
              00004CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB122
              4CB1224CB1224CB1224CB1224CB1224CB122000000FFFFFFFFFFFFFFFFFFFCFE
              FCFFFFFFFFFFFFFFFFFFF4F4F4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3D4D4D4E8
              E8E8E8E8E80000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F000000FFFFFFFFFF
              FFFFFFFFFFFFFF59C1DD2FB6DDAED3E655C3E113BEE80EB7E501B3E648C2EB87
              DDF577D2F462C4E93DB5E00000004CB1224CB1224CB1224CB1224CB1224CB122
              4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1220000
              00FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3E8E8E8C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3E8E8E8C3C3C3C3C3C30000007F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F000000FFFFFFFFFFFFFFFFFFE7F1F32EC5ED00C0EB00B8E905B8EB0A
              BAE508BAE421B3E196E4FE7CD7F756C3E544C1EE5FD8FC000000000000000000
              0000000000000000000000004CB1224CB1224CB1224CB1220000000000000000
              00000000000000000000000000FFFFFFFFFFFFFFFFFFE8E8E8C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3E8E8E8E8E8E8C3C3C3C3C3C3C3C3C3000000
              0000000000000000000000000000000000007F7F7F7F7F7F7F7F7F7F7F7F0000
              00000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFE94
              CDE328B4DC17BEEB0DBAEA0DBCE600ADE384DCF886E0F86DCCEE46C5EB63DCFB
              43C6F129B3E929B7ED33C1F04FCCF73CC1ED21ACE80000004CB1224CB1224CB1
              224CB1220000000C9ACF0797CF229ECE87C6E0FFFFFDFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFED4D4D4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3D4D4D4E8E8E8C3C3C3
              C3C3C3C3C3C3D4D4D4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C30000007F7F
              7F7F7F7F7F7F7F7F7F7F000000C3C3C3C3C3C3C3C3C3E8E8E8FFFFFDFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF53C7E609B9E70ABAE81EB5E595E8FE
              88E0F843BBE06EE4FF41C5F008A3E273D0F1DCF4F6D8F1F87BD9F656DAFC3BBF
              EC0000004CB1224CB1224CB1224CB1220000000B9ACF0F96CBFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
              C3C3C3E8E8E8E8E8E8C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3FFFFFFFFFFFFC3C3
              C3D4D4D4C3C3C30000007F7F7F7F7F7F7F7F7F7F7F7F000000C3C3C3C3C3C3FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCF4F6F8E4E8EE41C9EC
              07BAE906B8E447C4EE92E9FC7CDAF84BC8E96BE1FD0AA1DD76CFEDFFFFFFFFFF
              FFFFFFFEFFFFFC88E1F865DEFF0000004CB1224CB1224CB1224CB1220000000C
              9AD00091C9E4EEF4F6F9FAFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCE8E8E8
              E8E8E8C3C3C3C3C3C3C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3E8E8E8C3C3C3C3C3
              C3FFFFFFFFFFFFFFFFFEFFFFFCC3C3C3D4D4D40000007F7F7F7F7F7F7F7F7F7F
              7F7F000000C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              59C2DF00B1E300AFDE0BBFE80DBAE703B5E75DCCEF91E9FD69CCEC5ED8F556D3
              F6009FDFFCFAF9FFFFFEFFFFFFFFFFFFFFFFFFE7F6F95ADFFC0000004CB1224C
              B1224CB1224CB1220000000C9ACF0B9ACF0090C8008DC5249ECEFFFFFFFFFFFF
              FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3E8E8E8C3C3
              C3C3C3C3E8E8E8C3C3C3FCFAF9FFFFFEFFFFFFFFFFFFFFFFFFFFFFFFD4D4D400
              00007F7F7F7F7F7F7F7F7F7F7F7F000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              FFFFFFFFFFFFFFFFFFFFFFFF5AC5E700BDED00B9E906BCEB0FBAE801B6E360CE
              F191E9FF67CAEC5FDAF754D0F6009BDEFFFFFDFFFFFDFFFFFFFFFFFFFDFEFDEE
              FAF963DFFB0000004CB1224CB1224CB1224CB1220000000C9ACF0F9CD10091C9
              008DC91598CCFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3E8E8E8C3C3C3FFFFFDFFFFFDFFFFFFFF
              FFFFFDFEFDFFFFFFD4D4D40000007F7F7F7F7F7F7F7F7F7F7F7F000000C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFE2F0F4BADDE9AED1
              E136C8EF09B9EA06BAE74BC6EB93E8FF7AD9F74ECBEC6BE0FC039FE09CDBEFFF
              FFFFFDFFFFFEFFFEFFFFFEA3E9FB65E0FD000000000000000000000000000000
              0000000C9BD00092CBAFD6EABDE4EEE3F0F6FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFD4D4D4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3E8E8E8C3
              C3C3C3C3C3FFFFFFFDFFFFFEFFFEFFFFFED4D4D4C3C3C3000000000000000000
              000000000000000000C3C3C3C3C3C3E8E8E8F4F4F4FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF53C7E703B9E60BB9E728B9E993E9FC8AE0FB44
              BDE16EE2FF33BBEC0BA6E4ACE1F4FFFEFBFFFCFCACE7F650D4F948C6F119ACE5
              13AEE5209ECE1798CB0D97CB0C9ED20B9ACF0D97CCFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3E8
              E8E8E8E8E8C3C3C3E8E8E8C3C3C3C3C3C3C3C3C3FFFEFBFFFCFCC3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC5E2E85BC0E21DBFE90BBCE80D
              BBE600AFE18CE1F982E0F861C7EB55CEF069DCFF33BDEB1AB1E528B7EF34C4F0
              4DCDF948C7F21FAFE417AFE81DABDB229CCF1395CB0E9ACF0E9ED30C9ACF0595
              CB54B3D8C5E6EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED4D4D4C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3D4D4D4E8E8E8C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4F2F624
              C1EA00BCEB00BBE905BAE60CBAE504B8E438B9E892E5FC81DAF749BAE24FCDF3
              5CD6FD4DCCF73FC6F042C2F035BCEB2BB5EA21B4E91BB0DF269ED11E9CD00D96
              CC0F9FD40F9DD20999CF0098CC0194CB0080C3E1F1F5FFFFFFFFFFFFFFFFFFFF
              FFFFE8E8E8C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3E8E8E8E8E8E8
              C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3E8E8E8FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF42BADE05ABDD73C4E03BC0E40BBDE70CB7E700ADE0
              65CDF684DBF576D6F655C0E43EB9E445C6F042C9F439C0F230BEEE26B8EB23B0
              DF34A3D526A2D41696CD0E9BD10E9FD30C9CD11099D07AC2E20491C40F93C8FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3E8E8E8E8E8E8C3C3C3C3C3C3D4D4D4E8E8E8D4D4D4D4D4
              D4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFEFDF8F9FBFFFFFFFFFFFC
              BBDAE93CCDF007B9E70EB6E706ABDF5ECDF280D8F66ACDF063C9EF54BBE447B4
              E044B5E13CB2DD3FAEDB3CAADB2FA4D51C9ACE0B9DD20FA1D50E9DD10096CFB2
              DAE8FFFFFFFFFFFCFDFEFCFFFEFDFFFFFFFFFFFFFFFFFFFFFFFFFAFEFDF8F9FB
              FFFFFFFFFFFCE8E8E8C3C3C3C3C3C3C3C3C3C3C3C3D4D4D4E8E8E8E8E8E8E8E8
              E8C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3FFFFFFFFFFFCFDFEFCFFFEFDFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFC6AC2E027C6ED05B6E40CB5E70FB3E103ACDB35B8
              E66ECDF36CCAEF63C3EC57BFE652B9E447B5DE40B0DE36A7D71C9ED00D9FD40E
              A2D610A1D50E9DD10599D14CB2D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3D4D4D4E8E8E8E8E8E8E8E8E8E8E8E8C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFEFFFFFE58C2E014BFE900B8E500A4
              D90FB7E80CB6E30DB3DF09B1E30CAADE29B0E13FB5E440B2E03AABDA2EA8D81A
              9FD2089FD10BA3D60FA3D710A0D4079DD20092CB0A9AD00092C92BA4CDFFFFFF
              FEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFEFFFFFEC3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3FFFFFFFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFCFFFF
              FD82CBE105BDE949B1D8FFFFFB6AC2DF22BEE90AB3DF0EB0E310AEE109ADE007
              ACDD0CA9DB08ACDD0BA7DA0DA7DB0EA6DA0BA4D711A1D6049DD24AB1D9FFFFFE
              5EB9DE008BC96ABBDCFFFFFEFCFFFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFBFFFCFFFFFDC3C3C3C3C3C3C3C3C3FFFFFBC3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              D4D4D4D4D4D4C3C3C3D4D4D4D4D4D4FFFFFEFCFFFDFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC1E0EDFFFFFFFFFFFFB2D8E838C8EF04
              B1E100ADE205AEDE0EADDA13ACDD0FA9DD11AADD0FA7DB0FA6DA0EA6D6009DD4
              04A1D4009BCFA9D9E8FFFFFFFFFFFFCBE4F2FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED4D4D4FFFFFFFFFFFFD4
              D4D4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3D4D4D4FFFFFFFFFFFFE8E8E8FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFEFFFFFFFF
              FFFFFFFAFC40C4E500B1E227AFD9ADD5E43CB5E11FB7E40DABDD00A2D900A2DC
              0AA5D90DA6DB25A4D4A6D7E73FB0D90AA2D90097CBFEFBFEFFFFFFFFFFFDFEFD
              FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE
              FCFEFFFFFFFFFFFFFFFAFCD4D4D4C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FEFBFEFFFF
              FFFFFFFDFEFDFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0F6F930B7E300A8DED2E7EFFFFFFFB0D9E9
              31C3EF03A2DAC1DEE9C3DFE82DB8E200A0D8A9D9EAFFFFFFD9ECF3029AD40093
              CAECF7F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0F6F9C3C3C3C3C3C3E8E8E8
              FFFFFFC3C3C3C3C3C3C3C3C3E8E8E8C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFC3C3
              C3C3C3C3D4D4D4E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC
              CBE2F3FFFFFFFFFFFF76CBE51CB8E716A6D6FFFFFFFFFFFF3DB7DF00A3D85EBC
              E0FFFFFEFFFFFFCBE7F4FFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFCE8E8E8FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3
              C3C3C3C3C3C3C3FFFFFEFFFFFFD4D4D4FFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBCE3EF46B8E07FCAE3FFFF
              FBFFFFFF8FD0E641B2DAABDBEAFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED4D4D4C3C3
              C3C3C3C3FFFFFBFFFFFFC3C3C3C3C3C3D4D4D4FFFFFEFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
            OnClick = sbAddObjectClick
          end
          object sbShowObjectCatalog: TSpeedButton
            Left = 184
            Top = 3
            Width = 34
            Height = 34
            Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
            Anchors = [akTop, akRight]
            Flat = True
            Glyph.Data = {
              36080000424D3608000000000000360400002800000020000000200000000100
              0800000000000004000000000000000000000001000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A6000020400000206000002080000020A0000020C0000020E000004000000040
              20000040400000406000004080000040A0000040C0000040E000006000000060
              20000060400000606000006080000060A0000060C0000060E000008000000080
              20000080400000806000008080000080A0000080C0000080E00000A0000000A0
              200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
              200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
              200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
              20004000400040006000400080004000A0004000C0004000E000402000004020
              20004020400040206000402080004020A0004020C0004020E000404000004040
              20004040400040406000404080004040A0004040C0004040E000406000004060
              20004060400040606000406080004060A0004060C0004060E000408000004080
              20004080400040806000408080004080A0004080C0004080E00040A0000040A0
              200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
              200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
              200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
              20008000400080006000800080008000A0008000C0008000E000802000008020
              20008020400080206000802080008020A0008020C0008020E000804000008040
              20008040400080406000804080008040A0008040C0008040E000806000008060
              20008060400080606000806080008060A0008060C0008060E000808000008080
              20008080400080806000808080008080A0008080C0008080E00080A0000080A0
              200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
              200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
              200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
              2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
              2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
              2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
              2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
              2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
              2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
              2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
              000000000000000000000000000000000000000000000000FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1453FFFFFFFFFFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFF071414147F6653535307FFFF00FFFFFFFF00FFA4A4
              A4A4A4FFFFFFA4A4A4A4A415776E14777F14267753FFFF00FFFFFFFF00FFA4A4
              A4A4A4FFFFFFA4A4A4A4A4AE77BF77BFBF77772653FFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFF14547FBF2626BF77155353FF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFF15266EBF15FFFF26BF772715FF00FFFFFFFF00FFA4A4
              A4A4A4A4FFFFA4A4A4A4267F7F7F53A4A426BF7FBF1EFF00FFFFFFFF00FFA4A4
              A4A4A4A4FFFFA4A4A4A4A4AE5D7F6F53156F771D53FFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFF5D147F7F7F7F77771E15FFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFF157F7715B77F2727771DFFFF00FFFFFFFF00FFA4A4
              A4A4A4A4FFFFA4A4A4A4A4072627AEB76F15A427B7FFFF00FFFFFFFF00FFA4A4
              A4A4A4A4FFFFA4A4A4A4A4A4A4A4A4272707A4A4FFFFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00FFA4A4
              A4A4A4FFFFFFA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4FF00FFFFFFFF00FFA4A4
              A4A4A4FFFFFFA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4FF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00FFA4A4
              A4A4A4A4FFFFA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4FFFF00FFFFFFFF00FFA4A4
              A4A4A4A4FFFFA4A4A4A4A4A4A4A4A4A4A4A4A4A4A4FFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF00000000
              000000000000000000000000000000000000000000000000FFFFFFFF00E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E800FFFFFFFF00E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E800FFFFFFFF00E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E800FFFFFFFF00000000
              000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            ParentShowHint = False
            ShowHint = True
            Transparent = False
            OnClick = sbShowObjectCatalogClick
          end
          object bRefresh: TImage
            Left = 374
            Top = 9
            Width = 21
            Height = 22
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            Picture.Data = {
              07544269746D6170C6050000424DC60500000000000036040000280000001400
              0000140000000100080000000000900100000000000000000000000100000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
              E00000400000004020000040400000406000004080000040A0000040C0000040
              E00000600000006020000060400000606000006080000060A0000060C0000060
              E00000800000008020000080400000806000008080000080A0000080C0000080
              E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
              E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
              E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
              E00040000000400020004000400040006000400080004000A0004000C0004000
              E00040200000402020004020400040206000402080004020A0004020C0004020
              E00040400000404020004040400040406000404080004040A0004040C0004040
              E00040600000406020004060400040606000406080004060A0004060C0004060
              E00040800000408020004080400040806000408080004080A0004080C0004080
              E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
              E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
              E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
              E00080000000800020008000400080006000800080008000A0008000C0008000
              E00080200000802020008020400080206000802080008020A0008020C0008020
              E00080400000804020008040400080406000804080008040A0008040C0008040
              E00080600000806020008060400080606000806080008060A0008060C0008060
              E00080800000808020008080400080806000808080008080A0008080C0008080
              E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
              E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
              E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
              E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
              E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
              E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
              E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
              E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
              E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
              E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
              A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF006A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6AB5B5B5
              B5B5B56A6A6A6A6A6A6A6A6A6A6A6AB5B56A6A6A6A6A6AB4F56A6A6A6A6A6A6A
              6A6A086A6A6A6A6A6A6A6A6A6A08736A6A6A6A6A6A086A6A6A6A6A6A6A6A6A6A
              6A6A086A6A6A6A6AB56A6A3E6A6AFFFFFF3E6A6A6A6A6AF56A6A6A6AB56A6AFF
              6AFF6A6A6A6AFF6A6A6A6AB4736A6AB56A6A6AFFFF6A6A6A6A6A6AFF6A6A6A6A
              BD6A6AB56A6A6AFFFFFF3E6A6A6A6A6A3E6A6A6AB56A6AB56A6A6A6A6A6A6A6A
              6A6A6A6A6A6A6A6AB56A6AB56A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6AB56A6AB5
              6A6A6A3E6A6A6A6A6A3EFFFFFF6A6A6AB56A6AB46A6A6A6AFF6A6A6A6A6A6AFF
              FF6A6A6ABD6A6A6AB56A6A6A6AFF6A6A6A6AFF6AFF6A6AB4736A6A6AB56A6A6A
              6A6A3EFFFF3E6A6A3E6A6AF56A6A6A6A6A086A6A6A6A6A6A6A6A6A6A6A6A086A
              6A6A6A6A6A6A086A6A6A6A6A6A6A6A6A6A086A6A6A6A6A6A6A6A6AB5B56A6A6A
              6A6A6AB5B56A6A6A6A6A6A6A6A6A6A6A6AB4B5B5B5B5B46A6A6A6A6A6A6A6A6A
              6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A}
            Stretch = True
            OnClick = bRefreshClick
          end
          object sbObjectToView: TSpeedButton
            Left = 2
            Top = 3
            Width = 34
            Height = 34
            Hint = #1057#1085#1103#1090#1100' '#1089#1090#1072#1090#1091#1089' "'#1074' '#1088#1072#1073#1086#1090#1077'"'
            Action = actFromWork
            Flat = True
            Glyph.Data = {
              4E150000424D4E1500000000000036000000280000003C0000001E0000000100
              18000000000018150000C40E0000C40E00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9B9B9B7F7F7F
              7F7F7F939393FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F277FFF
              277FFF277FFF277FFF277FFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7171716E6E6E7F7F7F7F7F7FE8E8E8
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFF277FFF277FFF
              277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8181817F
              7F7FEFEFEFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFDFDFDFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF27
              7FFF277FFF277FFF277FFF277FFFFFFFFF277FFF277FFF277FFF277FFF7F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FB4B4B4FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF5B5B5B7F7F7F909090C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFFFF
              FFFFFFFFFF277FFF277FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7F7F7FD2D2D2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B5B5B7F7F7F7F
              7F7F7F7F7F7F7F7FA6A6A6C8C8C8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F277FFF277FFF277FFF277FFF277FFFFFFFFFFFFFFFFFFFFF277FFF277FFF27
              7FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F727272FFFF
              FFFFFFFFFFFFFFFFFFFF4545457F7F7FE2E2E2FFFFFF9696967F7F7F7F7F7F7F
              7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277F
              FFFFFFFFFFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277FFF277FFF7F7F7F98
              9898DCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFB9B9B97F7F7FB0B0B0FFFFFFFFFFFF4444447F7F
              7FFCFCFCFFFFFFFFFFFFFAFAFACBCBCBFFFFFFE1E1E17F7F7F989898DCDCDCFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F277FFF277FFF277FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF277FFF277FFF277FFF277FFF277FFF7F7F7F000000020202363636FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF7E7E7E7F7F7FC8C8C85858587F7F7FFCFCFCFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF
              277FFF277FFF277FFFFFFFFFFFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277F
              FF277FFF7F7F7FDCDCDCC8C8C80000008F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA3A3A37F7F7F
              7F7F7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F47F7F
              7FDCDCDCC8C8C87F7F7F8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFF
              FFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277FFF277FFF7F7F7FFFFFFFFFFF
              FF8C8C8C000000000000343434FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF5252527F7F7FFCFCFCFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8C8C7F7F
              7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFAFAFAF7F7F7F277FFF277FFF277FFF277FFF277FFFFFFFFFFFFFFF277FFF
              277FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFF797979858585C4C4C41E1E
              1E4C4C4CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF67
              67677F7F7FFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF797979858585C4C4C47F7F7F7F7F7FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F277FFF27
              7FFF277FFF277FFF277FFF277FFFFFFFFF277FFF277FFF277FFF277FFF7F7F7F
              FFFFFFFFFFFFFFFFFFF8F8F8FFFFFFFFFFFFE9E9E9000000EDEDEDFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1D1D17F7F7FDADADAFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFF8F8F8FFFFFFFFFFFFE9E9E97F7F7FEDEDEDFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF232323AFAFAF7F7F7F277FFF277FFF277FFF277FFF27
              7FFF277FFF277FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFB4B4B4080808F9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              B4B4B47F7F7FF9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2323
              23FFFFFFFFFFFF7F7F7F7F7F7F277FFF277FFF277FFF277FFF277FFF7F7F7F7F
              7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7C7C7000000A0A0A0
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FC5C5C5FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7C7C77F7F7FA0A0A0FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF232323FFFFFFFFFFFFFFFFFFFFFF
              FF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFD7D7D7000000797979FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7F7F7FDCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFD7D7D77F7F7F797979FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF232323A9A9A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D600000000
              0000E7E7E7FFFFFFDBDBDBADADADAFAFAFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFF
              7F7F7FA9A9A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D67F7F7F7F7F7FE7E7E7FF
              FFFFDBDBDBADADADAFAFAFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F303030
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFC8C8C80000008A8A8A5D5D5D0000003B3B3B0303030C
              0C0C080808000000747474FFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFC8C8C87F7F7F8A8A8A5D5D5D7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F747474FFFFFFFFFFFFFFFFFFF0F0F00000009F9F9FFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D60000
              00616161FFFFFFFFFFFF5555553C3C3CCACACAFFFFFFFDFDFD9B9B9B00000089
              8989FFFFFFFFFFFFF0F0F07F7F7F9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D67F7F7F616161FFFF
              FFFFFFFF5555557F7F7FCACACAFFFFFFFDFDFD9B9B9B7F7F7F898989FFFFFFFF
              FFFFFFFFFFC6C6C6000000AFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFD3D3D3000000888888FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC9C9C9000000CBCBCBFFFFFFFFFFFFC6
              C6C67F7F7FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFD3D3D37F7F7F888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFC9C9C97F7F7FCBCBCBFFFFFFFFFFFFFFFFFFB9B9B900
              0000A7A7A7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECEC
              0A0A0A000000CCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFF4545452E2E2EFFFFFFFFFFFFFFFFFFB9B9B97F7F7FA7A7A7FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECEC7F7F7F7F7F7F
              CCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFA1A1A1000000AFAFAFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDDDD010101000000CFCFCF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7B7B7B777777FFFFFFDDDDDD0000
              00DADADAFFFFFFFFFFFFFFFFFFA1A1A17F7F7FAFAFAFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDDDD7F7F7F7F7F7FCFCFCFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7B7B7B777777FFFFFFDDDDDD7F7F7FDADADAFFFF
              FFFFFFFFFFFFFFFFFFFFB9B9B9000000AEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2727272D2D2D0909096A6A6AFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF3030300909091B1B1B000000FFFFFF3232328B8B8BFFFFFFFFFFFFFFFF
              FFFFFFFFB9B9B97F7F7FAEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7F7F7F7F6A6A6AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F
              7F7F7F7F7F7F7F7F7FFFFFFF7F7F7F8B8B8BFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFB9B9B9000000818181F9F9F9FFFFFFFFFFFFFFFFFFD9D9D9232323101010C6
              C6C60A0A0AE0E0E0FFFFFFFFFFFFFFFFFFFFFFFF3E3E3E040404FFFFFFFEFEFE
              3232322727276E6E6E535353FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB9B9B97F7F
              7F818181F9F9F9FFFFFFFFFFFFFFFFFFD9D9D97F7F7F7F7F7FC6C6C67F7F7FE0
              E0E0FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFEFEFE7F7F7F7F7F7F
              6E6E6E7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF0000000000
              004545454D4D4D2D2D2D0000003E3E3EFFFFFF9090901B1B1BFFFFFFFFFFFFFF
              FFFFFFFFFF2F2F2F050505F3F3F3FFFFFFFFFFFFFFFFFF161616000000484848
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7FFFFFFF9090907F7F7FFFFFFFFFFFFFFFFFFFFFFFFF7F
              7F7F7F7F7FF3F3F3FFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7FFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC2C2C2676767606060818181F2F2
              F2FFFFFFFFFFFF7575752C2C2CFFFFFFFFFFFFFFFFFF626262131313FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF3535357E7E7EFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFC2C2C2676767606060818181F2F2F2FFFFFFFFFF
              FF7575757F7F7FFFFFFFFFFFFFFFFFFF6262627F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF7F7F7F7E7E7EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFABABAB0202
              02F6F6F6FFFFFFFFFFFF333333636363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFBFBFBF9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFABABAB7F7F7FF6F6F6FFFF
              FFFFFFFF7F7F7F636363FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF9
              F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0D0D0D313131FFFFFFFFFFFFC7C7
              C7000000929292FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFC7C7C77F7F7F9292
              92FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFF1F1F10F0F0F000000B2B2B2FFFFFFCCCCCC0000007D7D7DFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              F1F1F17F7F7F7F7F7FB2B2B2FFFFFFCCCCCC7F7F7F7D7D7DFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              5757570000001010109797977878780000009A9A9AFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5757577F7F7F
              7F7F7F9797977878787F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E59090902B2B2B
              040404020202616161FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E59090907F7F7F7F7F7F7F7F7F
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
          end
          object sbObjectCheckingBack: TSpeedButton
            Left = 39
            Top = 3
            Width = 34
            Height = 34
            Hint = #1042#1077#1088#1085#1091#1090#1100' '#1074' '#1089#1090#1072#1090#1091#1089' "'#1074' '#1088#1072#1073#1086#1090#1077'"'
            Action = actFromCheck
            Flat = True
            Glyph.Data = {
              4E150000424D4E1500000000000036000000280000003C0000001E0000000100
              18000000000018150000C40E0000C40E00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFF3232
              323232323232323232323333334242423A3A3A33333333333333333333333333
              33333333333333333333333232323232329A9A9AFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8686
              867F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F9A9A9AFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F277FFF
              277FFF277FFF277FFF277FFF7F7F7F7F7F7F323232323232FFFFFF4A4A4A7878
              780000006060609393938B8B8B8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A93
              93933B3B3B404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7878787F7F7F7F7F
              7F9393938B8B8B8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A9393937F7F7F7F
              7F7FFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFF277FFF277FFF
              277FFF277FFF7F7F7FFFFFFFFFFFFF9B9B9BFFFFFF6464640C0C0CFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF838383404040FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F9B9B9BFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8383837F7F7FFFFFFF7F7F7F277FFF27
              7FFF277FFF277FFF277FFF277FFFFFFFFF277FFF277FFF277FFF277FFF7F7F7F
              FFFFFF777777FFFFFFFFFFFF202020262626FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7C7C7C404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F777777
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7C7C7C7F7F7FFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFFFF
              FFFFFFFFFF277FFF277FFF277FFF277FFF7F7F7FFFFFFF000000C8C8C8FFFFFF
              EFEFEF070707646464FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C7C
              7C404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6
              F6F6F2F2F2FFFFFFFFFFFFFFFFFF7F7F7F7F7F7FC8C8C8FFFFFFEFEFEF7F7F7F
              7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C7C7C7F7F7F7F7F
              7F277FFF277FFF277FFF277FFF277FFFFFFFFFFFFFFFFFFFFF277FFF277FFF27
              7FFF277FFF277FFF7F7F7F080808090909F8F8F8FFFFFFC7C7C7000000BFBFBF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C7C7C404040FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFADADAD7F7F7F7F7F7F7F7F7FFFFFFFFF
              FFFF7F7F7F7F7F7F7F7F7FF8F8F8FFFFFFC7C7C77F7F7FBFBFBFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7C7C7C7F7F7F7F7F7F277FFF277FFF277FFF277F
              FFFFFFFFFFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277FFF277FFF7F7F7FA2
              A2A24D4D4D080808FFFFFFFFFFFFAEAEAE000000D5D5D5FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7C7C7C404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF8A8A8A7F7F7FA3A3A3C9C9C97F7F7F7F7F7FEBEBEB7F7F7FA2A2A27F7F7F7F
              7F7FFFFFFFFFFFFFAEAEAE7F7F7FD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              7C7C7C7F7F7F7F7F7F277FFF277FFF277FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF277FFF277FFF277FFF277FFF277FFF7F7F7F999999FFFFFF0E0E0E606060FF
              FFFFFFFFFF525252121212F9F9F9FFFFFFFFFFFFFFFFFFFFFFFF7C7C7C404040
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9F7F7F7FA6A6A6FFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7F7F7F7F999999FFFFFF7F7F7F7F7F7FFFFFFFFFFFFF7F
              7F7F7F7F7FF9F9F9FFFFFFFFFFFFFFFFFFFFFFFF7C7C7C7F7F7F7F7F7F277FFF
              277FFF277FFF277FFFFFFFFFFFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277F
              FF277FFF7F7F7F8F8F8FFFFFFFEAEAEA0000009B9B9BFFFFFFFFFFFF18181834
              3434FFFFFFFFFFFFFFFFFFFFFFFF7C7C7C404040FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFD4D4D47F7F7F919191FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F
              7F8F8F8FFFFFFFEAEAEA7F7F7F7F7F7FFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFF
              FFFFFFFFFFFFFFFF7C7C7C7F7F7F7F7F7F277FFF277FFF277FFF277FFF277FFF
              FFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277FFF277FFF7F7F7FE4E4E4FFFF
              FFFFFFFFB7B7B7000000BBBBBBFFFFFFF7F7F7000000797979FFFFFFFFFFFFFF
              FFFF7C7C7C404040FFFFFFFFFFFFFFFFFFFFFFFFC6C6C67F7F7F979797FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8A8A8E4E4E4FFFFFFFFFFFFB7B7
              B77F7F7FBBBBBBFFFFFFF7F7F77F7F7F797979FFFFFFFFFFFFFFFFFF7C7C7C7F
              7F7FFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFFFFFFFFFFFFFF277FFF
              277FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7979790000
              00FCFCFCFFFFFFCFCFCF000000B4B4B4FFFFFFFFFFFF7C7C7C404040FFFFFFFF
              FFFFFFFFFFD7D7D77F7F7F626262FFFFFFFFFFFFFFFFFFA9A9A97F7F7FEFEFEF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7979797F7F7FFCFCFCFFFF
              FFCFCFCF7F7F7FB4B4B4FFFFFFFFFFFF7C7C7C7F7F7FFFFFFF7F7F7F277FFF27
              7FFF277FFF277FFF277FFF277FFFFFFFFF277FFF277FFF277FFF277FFF7F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF343434252525FFFFFFFFFFFF7979
              79000000EDEDEDFFFFFF7C7C7C404040FFFFFFFFFFFFFFFFFF7F7F7F646464FF
              FFFFFFFFFFFFFFFFCBCBCB7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFF7979797F7F7FEDED
              EDFFFFFF7C7C7C7F7F7FFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF27
              7FFF277FFF277FFF277FFF277FFF7F7F7F323232323232FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFF0000004A4A4AFFFFFFFFFFFF555555000000FFFFFF8080
              80404040FFFFFFFBFBFB7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7FFFFFFF7F7F7F7F7F7FC9C9C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF7F7F7F7F7F7FFFFFFFFFFFFF7F7F7F7F7F7FFFFFFF8080807F7F7FFFFF
              FFFFFFFF3232327F7F7F7F7F7F277FFF277FFF277FFF277FFF277FFF7F7F7F7F
              7F7F323232323232323232FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9D9
              000000858585FFFFFFFBFBFB1C1C1C6363637E7E7E444444FFFFFFC3C3C37F7F
              7FCBCBCBB4B4B4B3B3B3B3B3B3BBBBBB7E7E7E7F7F7FFEFEFEFFFFFF7F7F7F7F
              7F7FB0B0B0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9D97F7F7F858585
              FFFFFFFBFBFB7F7F7F6363637E7E7E7F7F7FFFFFFF323232323232FFFFFFFFFF
              FF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFF323232FFFFFFFFFFFF32323232
              3232FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC000000D9D9D9FFFFFF
              F5F5F50000000303036C6C6CFFFFFF8080807F7F7FFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF8383837F7F7FF8F8F8D7D7D7FFFFFF7F7F7F7F7F7FB4B4B4FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC7F7F7FD9D9D9FFFFFFF5F5F57F7F7F
              7F7F7F6C6C6CFFFFFF2F2F2F747474FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3B3B
              3B7D7D7D727272262626FFFFFFFFFFFFC0C0C0000000606060E9E9E9FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFA6A6A6000000EAEAEAFFFFFF7D7D7D000000DDDDDD
              FFFFFF7F7F7F747474FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7D7D7D7272
              727F7F7FFFFFFFFFFFFFC0C0C07F7F7F7F7F7FE9E9E9FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFA6A6A67F7F7FEAEAEAFFFFFF7D7D7D7F7F7FDDDDDDFFFFFF0C0C0C
              ABABABFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9101010C5C5C5303030797979FFFF
              FFFFFFFFFFFFFFC4C4C415151500000020202037373736363636363638383841
              41410000000C0C0C1B1B1B000000999999FFFFFFFFFFFF7F7F7FABABABFFFFFF
              FFFFFFFFFFFFFFFFFFF9F9F97F7F7FC5C5C57F7F7F797979FFFFFFFFFFFFFFFF
              FFC4C4C47F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F999999FFFFFFE2E2E20C0C0CD5D5D5FFFFFFFFFFFFFFFFFF
              FFFFFFEBEBEB000000F4F4F40D0D0DAEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFBABABA8080806E6E6E6F6F6F7676767979797878787A7A7A7575758C8C8CE3
              E3E3FFFFFFFFFFFFE2E2E27F7F7FD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFEBEBEB
              7F7F7FF4F4F47F7F7FAEAEAEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBABABA8080
              806E6E6E6F6F6F7676767979797878787A7A7A7575758C8C8CE3E3E3FFFFFFFF
              FFFFB7B7B70A0A0AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0000000F1F1F1
              0A0A0ADCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFD9D9D9C0C0C0CECECEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB7B7B77F
              7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C07F7F7FF1F1F17F7F7FDCDCDC
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9D9C0C0
              C0CECECEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF868686303030FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF7B7B7B313131C0C0C00A0A0AFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D72222220606060E0E0E0A0A0A0D0D
              0DB0B0B0FFFFFFFFFFFFFFFFFFFFFFFF8686867F7F7FFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF7B7B7B7F7F7FC0C0C07F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFD7D7D77F7F7F7F7F7F7F7F7F7F7F7F7F7F7FB0B0B0FFFF
              FFFFFFFFFFFFFFFFFFFF474747757575FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF36
              36367979798484842C2C2CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              E6E6E6000000474747E9E9E9FFFFFFF5F5F57B7B7B000000B4B4B4FFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F79797984
              84847F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E67F7F7F
              7F7F7FE9E9E9FFFFFFF5F5F57B7B7B7F7F7FB4B4B4FFFFFFFFFFFFFFFFFF0000
              00D8D8D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF080808C2C2C22F2F2F7B7B7BFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF242424545454FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFA4A4A4000000FFFFFFFFFFFFFFFFFF7F7F7FD8D8D8FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FC2C2C27F7F7F7B7B7BFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFA4A4A47F7F7FFFFFFFFFFFFFFFFFFF0606062323233939393939393434
              342B2B2B1E1E1E030303FBFBFB000000BEBEBEFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFE5E5E5F2F2F2000000BFBFBFE9E9E9E2E2E2E2E2E2E2E2E2E6E6E6DADADA
              000000C8C8C8FFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7FFBFBFB7F7F7FBEBEBEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5F2
              F2F27F7F7FBFBFBFE9E9E9E2E2E2E2E2E2E2E2E2E6E6E6DADADA7F7F7FC8C8C8
              FFFFFFFFFFFFDBDBDB4F4F4F0000000000001616169494949D9D9DC9C9C9FFFF
              FF000000E8E8E8FFFFFFFFFFFFFFFFFFFFFFFF9D9D9D00000000000000000000
              0000000000000000000000000000000000000000000000A3A3A3FFFFFFFFFFFF
              DBDBDB7F7F7F7F7F7F7F7F7F7F7F7F9494949D9D9DC9C9C9FFFFFF7F7F7FE8E8
              E8FFFFFFFFFFFFFFFFFFFFFFFF9D9D9D7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FA3A3A3FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF8A8A8A222222000000626262D8D8D8B3B3B3101010F9F9F9FFFFFFFFFF
              FFFFFFFFFFFFFFCECECE010101434343FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2D2D2D9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8A8A8A
              7F7F7F7F7F7F7F7F7FD8D8D8B3B3B37F7F7FF9F9F9FFFFFFFFFFFFFFFFFFFFFF
              FFCECECE7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA
              313131030303000000505050FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8
              E81C1C1C0C0C0C1E1E1E1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1E1E1E000000A1
              A1A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA7F7F7F7F7F7F
              7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E87F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FA1A1A1FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDB939393EDEDED
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2525253434349292928B8B
              8B8A8A8A8B8B8B8D8D8D9090909191910B0B0B9E9E9EFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDB939393EDEDEDFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F9292928B8B8B8A8A8A8B8B
              8B8D8D8D9090909191917F7F7F9E9E9EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF3131311D1D1DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8
              F8DFDFDF151515989898FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8DFDFDF7F7F
              7F989898FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8B000000AFAFAF
              9F9F9F7676765454542929290E0E0E0C0C0C0D0D0D0E0E0E000000C1C1C1FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8B7F7F7FAFAFAF9F9F9F767676
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FC1C1C1FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFBFBFBF0000000000002424244444446464648A8A8A
              A8A8A8BBBBBBD2D2D2E6E6E6FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFBFBFBF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F8A8A8AA8A8A8BBBBBB
              D2D2D2E6E6E6FAFAFAFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
          end
          object sbObjectReadyBack: TSpeedButton
            Left = 76
            Top = 3
            Width = 34
            Height = 34
            Hint = #1042#1077#1088#1085#1091#1090#1100' '#1074' '#1089#1090#1072#1090#1091#1089' "'#1074' '#1087#1088#1086#1074#1077#1088#1082#1077'"'
            Action = actFromReady
            Flat = True
            Glyph.Data = {
              4E150000424D4E1500000000000036000000280000003C0000001E0000000100
              18000000000018150000C40E0000C40E00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F277FFF
              277FFF277FFF277FFF277FFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFF277FFF277FFF
              277FFF277FFF7F7F7F9696969696969696969696969696969696969696969696
              96969696969696A0A0A0F0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFD7D7D79B9B9B969696969696969696969696969696
              9696969696969696969696969696969696969696969696969696969696969696
              96A0A0A0F0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF27
              7FFF277FFF277FFF277FFF277FFFFFFFFF277FFF277FFF277FFF277FFF7F7F7F
              2424242424242424242424242424242424242424242424242424241E1E1E0000
              003F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E3E37F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFFFF
              FFFFFFFFFF277FFF277FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDF1B1B1B3F3F3FFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FF4F4F4FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFDFDFDF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFF7F7F
              7F277FFF277FFF277FFF277FFF277FFFFFFFFFFFFFFFFFFFFF277FFF277FFF27
              7FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFDEDEDE000000F0F0F0FFFFFFFFFFFFFFFFFFFFFFFF9E9E
              9E7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFDEDEDE7F7F7FF0F0F0FFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277F
              FFFFFFFFFFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277FFF277FFF7F7F7FFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              1E1E1EA0A0A0FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FA0A0A0
              FFFFFFFFFFFF7F7F7F277FFF277FFF277FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF277FFF277FFF277FFF277FFF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2222229A9A9AFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFF7F7F7F277FFF
              277FFF277FFF277FFFFFFFFFFFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277F
              FF277FFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F9A9A9AFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFF
              FFFFFFFFFFFFFFFFFF277FFF277FFF277FFF277FFF277FFF7F7F7FFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A
              9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FCFCFCFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFF
              FFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF277FFFFFFFFFFFFFFF277FFF
              277FFF277FFF277FFF7F7F7F858585FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              9B9B9B7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFF7F7F7F277FFF27
              7FFF277FFF277FFF277FFF277FFFFFFFFF277FFF277FFF277FFF277FFF7F7F7F
              242424A0A0A0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6A6A67F7F7F7979797F7F7FA0A0A0
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F277FFF277FFF277FFF277FFF27
              7FFF277FFF277FFF277FFF277FFF7F7F7FFFFFFF858585000000ACACACFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7676767F7F7FCBCBCBFFFFFFCDCDCD7F7F7FACACACFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFF
              FFFFFFFF4A4A4A7F7F7F7F7F7F277FFF277FFF277FFF277FFF277FFF7F7F7F7F
              7F7FFFFFFFFFFFFFFFFFFF858585000000D0D0D0FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FBABABAFFFFFFFF
              FFFFFFFFFF8585857F7F7FD0D0D0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFF
              FF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF5A5A5A000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFF7F7F7F7F7F7FCACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F
              7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9A
              FFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFF8C8C
              8CE9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343111111FF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF8C8C8CE9E9E9FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF
              4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF050505494949FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFE5E5E5000000727272FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219A
              9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5
              E57F7F7F727272FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFF
              FFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD5D5D50000
              00A2A2A2FFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFF
              FFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD5D5D57F7F7FA2A2A2FFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E
              5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC000000D0D0D0FFFFFFFFFF
              FFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFACACAC7F7F7FD0D0D0FFFFFFFFFFFFFFFFFF7F7F
              7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFA1A1A1ECECECFFFFFFFFFFFFFFFFFF2121219A9A9AFFFF
              FFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFA1A1A1ECECECFFFFFFFFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFF
              FFFFFFFF4A4A4A5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFF2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F
              7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F9A9A9AFFFFFFFFFFFFFFFFFFFFFFFF4A4A4A5F5F5FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              2121219A9A9AFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9A9A9A
              FFFFFFFFFFFFFFFFFFFFFFFF4C4C4C5D5D5DFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2121219C9C9CFFFFFFFFFFFF
              FFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F9C9C9CFFFFFFFFFFFFFFFFFFFFFFFF
              808080242424FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFF4F4F4000000D8D8D8FFFFFFFFFFFFFFFFFFFFFFFF8080807F7F7F
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4
              F4F47F7F7FD8D8D8FFFFFFFFFFFFFFFFFFFFFFFFFDFDFD000000909090FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4F0F0F0FFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFD7F7F7F909090FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFAEAEAE0000002424245D5D5D6060605F5F5F5F5F5F
              5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F
              5F5F5F5F5F5F5F595959070707000000E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFAEAEAE7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7FE4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFDFDFD8181814F4F4F515151515151515151515151515151515151515151
              5151515151515151515151515151515151515151515151515151515151519E9E
              9EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFD81
              81817F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
              7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F9E9E9EFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Transparent = False
          end
          object sbShowUsers: TSpeedButton
            Left = 144
            Top = 3
            Width = 34
            Height = 34
            Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
            Anchors = [akTop, akRight]
            Flat = True
            Glyph.Data = {
              FE0A0000424DFE0A00000000000036000000280000001E0000001E0000000100
              180000000000C80A000000000000000000000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF00
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
              FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
              FFFFFFFFFFFFECEBEAEAE8E7E9E8E7F0F0F1FCFBFAF7ECE1F7F0E8F7EDE2FBF9
              F6F3F3F4E9E7E6EAE9E8EBEAE9FEFEFEFFFFFFFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFF7
              F5F44D40372E1F14291A0C757172DEC4A4B04E00B2620DB35300D7B0848B8C8F
              24130730211842382DE5E3E1FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFEEEBEB6154
              4C4C4136433529949396E2C29AB76716C0792CBC6D19D8B07EA9ABAF3F322650
              4038574D43DEDDDAFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
              0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFECEAE85F524B4B4135
              413428989799DDBE9CBB6614BE782ABA6C1AD7AB79ADAFB83D30244E4038584C
              41DDDBD9FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
              FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFE5E3E25D4F474C4136403327A2
              A1A5D3B587BF6B16BE772BBB6E1BD3A369B5B9BA3C2E234D413755483FD6D3D1
              FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
              FFFFFF000000FFFFFFFFFFFFFFFFFFE2DFDE5A4E454C41363F3226A3A7ABDBB2
              83BB6A17BF762BBC6F1FD09E61B7BABD3D2F244F423852473DD2CFCDFFFFFFFF
              FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF00
              0000FFFFFFFFFFFFFFFFFFE0DEDD594C444E423834261B9EA3A7DBAD7EB96C18
              C0772BBB7021D1985AB0B0B23123184F433850453BD1CECCFFFFFFFFFFFFFFFF
              FF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFF
              FFFFFFFFFFFFFFCCC9C651443A4839315D514BF6FFFFD4A46CB96D1CBF772ABC
              7222C38D4AFEFFFF675E554539304B4135B7B6B0FFFFFFFFFFFFFFFFFF000000
              FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
              D4D1CF1F0F034D4137483B33D4DAD5CF9A5EB36411BF782ABF772ABF7729B768
              17CA8942EBECEA493D344F4339211207B3AFA9FFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF837E7847
              382C4F453B473D34E9E1D9C37D33BE7322BD762ABF772ABE762ABE7526BB7223
              FAEBDA473F364F443B44372A908982FFFFFFFFFFFF000000FFFFFFFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF6B65604A3C304F43
              39493F38FFEDDCBA7022BF7525BD752ABF772ABF772ABF762AB66814FCE5CD56
              4C454D4137483A30766F69FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
              0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF665E594B3D324E42374D433E
              FCE8D1B56A1ABF7527BD762ABD7728BF752ABF772BB5640EF8DEC5645C5B4A3F
              33483A30736A63FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
              FFFFFFFFFFFFFF000000FFFFFFFFFFFF8E888544362C52443A453835FFEFDDBC
              7025BE7526BD7629BF7428BD7628BF7629B66916FBE6CD50453C4E423944372C
              8B857FFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
              FFFFFF000000FFFFFFFFFFFFEAEAE8231509382A1E5B534CFEF4E5C1752DBA73
              22BE7425BB7528BF7428BF7424BA6E1DFAE8D56E676234271C27190DA8A49EFF
              FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF00
              0000FFFFFFFFFFFFF6F5F5A39E9A8B857FEFEFEDFFFFFFCA9353B4610DB86C1D
              E6DFCFBB742DB06008C48742FFFDF4FDFEFF89827EA19B97EFEDECFFFFFFFFFF
              FF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF786F6B817974F6F9F7F3EEE5F7F5F4FBFFFFF4
              F7F3F6EEE4FFFFFF908E87655A57FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
              FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
              FFFFFFFFFFFFA8A39C392B1E32241AAEA9A7FFFFFFD0AF86A64000C79763FFFF
              FFBCB6B2392B1F392E228C837BFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
              FFFF8B86823C2E22312318ACA7A4FFFFFFAE5800C3782CAC5000FFFFFFB0ABA6
              32261A3C3025756C65FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFEAE9
              E9655A54756D68EAE9E8FEFFFFB15D0BBA6610AA5300FFFFFFEBEAEA78716A5F
              544AE2E0E0FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
              0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6
              FAFAFBFFFFFFFFFFFFF1E2D3D09F68EEDECDFFFFFFFFFFFFFAFAFAF5F4F4FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
              FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
              FFFFFF0000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF00
              0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000
              FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
              FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF00000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF
              FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              0000}
            ParentShowHint = False
            ShowHint = True
            Transparent = False
            OnClick = sbShowUsersClick
          end
          object SpeedButton3: TSpeedButton
            Left = 334
            Top = 3
            Width = 34
            Height = 34
            Hint = #1054#1090#1082#1088#1099#1090#1100' '#1086#1090#1076#1077#1083#1100#1085#1099#1084' '#1086#1082#1085#1086#1084
            Anchors = [akTop, akRight]
            Flat = True
            Glyph.Data = {
              36080000424D3608000000000000360400002800000020000000200000000100
              0800000000000004000000000000000000000001000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A6000020400000206000002080000020A0000020C0000020E000004000000040
              20000040400000406000004080000040A0000040C0000040E000006000000060
              20000060400000606000006080000060A0000060C0000060E000008000000080
              20000080400000806000008080000080A0000080C0000080E00000A0000000A0
              200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
              200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
              200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
              20004000400040006000400080004000A0004000C0004000E000402000004020
              20004020400040206000402080004020A0004020C0004020E000404000004040
              20004040400040406000404080004040A0004040C0004040E000406000004060
              20004060400040606000406080004060A0004060C0004060E000408000004080
              20004080400040806000408080004080A0004080C0004080E00040A0000040A0
              200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
              200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
              200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
              20008000400080006000800080008000A0008000C0008000E000802000008020
              20008020400080206000802080008020A0008020C0008020E000804000008040
              20008040400080406000804080008040A0008040C0008040E000806000008060
              20008060400080606000806080008060A0008060C0008060E000808000008080
              20008080400080806000808080008080A0008080C0008080E00080A0000080A0
              200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
              200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
              200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
              2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
              2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
              2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
              2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
              2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
              2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
              2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4A4A4A4
              A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF000000000000000000000000FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FF0707
              070707FFFFFF0707070700FF07FF07FF07070707FF00FFA4FFFFFFFFA4FF0707
              070707FFFFFF0707070700FFFFFFFFFF07070707FF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FF07FFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FFFFFF0707070707FFFF00FFA4FFFFFFFFA4FF0707
              0707FFFFFFFF0707070700FF07FF0707070707FFFF00FFA4FFFFFFFFA4FF0707
              0707FFFFFFFF0707070700FFFFFFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FF07070707FFFFFFFFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FF07070707FFFFFFFFFF00FFA4FFFFFFFFA4FF0707
              07070707FFFF0707070700FFFFFFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FF0707
              07070707FFFF0707070700FF07FF0707070707FFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FFFFFF0707070707FFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FF07FFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FF0707
              0707FFFFFFFF0707070700FFFFFF0707070707FFFF00FFA4FFFFFFFFA4FF0707
              0707FFFFFFFF0707070700FF07FF0707070707FFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00FF07070707FFFFFFFFFF00FFA4FFFFFFFFA4FF0707
              07070707FFFF0707070700FF07070707FFFFFFFFFF00FFA4FFFFFFFFA4FF0707
              07070707FFFF0707070700FFFFFFFFFFFFFFFFFFFF00FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF000000000000000000000000FFA4FFFFFFFFA4FFFFFF
              FFFFFFFFFFFFFFFFFFFF00E8E8E8E8E8E8E8E8E8E800FFA4FFFFFFFFA4A4A4A4
              A4A4A4A4A4A4A4A4A4A400E8E8E8E8E8E8E8E8E8E800A4A4FFFFFFFFA4070707
              0707070707070707070700000000000000000000000007A4FFFFFFFFA4070707
              0707070707070707070707070707070707070707070707A4FFFFFFFFA4070707
              0707070707070707070707070707070707070707070707A4FFFFFFFFA4A4A4A4
              A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            ParentShowHint = False
            ShowHint = True
            Transparent = False
            OnClick = SpeedButton3Click
          end
          object cbMyObjects: TCheckBox
            Left = 6
            Top = 45
            Width = 389
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = #1058#1086#1083#1100#1082#1086' '#1084#1086#1080' '#1086#1073#1098#1077#1082#1090#1099
            TabOrder = 0
            OnClick = cbMyObjectsClick
          end
          object cbIEditor: TCheckBox
            Left = 6
            Top = 65
            Width = 100
            Height = 17
            Caption = #1103' '#1088#1077#1076#1072#1082#1090#1086#1088
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = cbMyObjectsClick
          end
          object cbIChecker: TCheckBox
            Left = 112
            Top = 66
            Width = 106
            Height = 17
            Caption = #1103' '#1082#1086#1085#1090#1088#1086#1083#1077#1088
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = cbMyObjectsClick
          end
        end
        object vsgProjectTree: TVirtualStringTree
          Left = 57
          Top = 152
          Width = 241
          Height = 113
          Header.AutoSizeIndex = 0
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          TabOrder = 2
          Visible = False
          Columns = <
            item
              Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus]
              Position = 0
              Width = 300
              WideText = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            end
            item
              Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coFixed, coAllowFocus]
              Position = 1
              Width = 20
            end
            item
              Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coFixed, coAllowFocus]
              Position = 2
              Width = 20
            end
            item
              Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coFixed, coAllowFocus]
              Position = 3
              Width = 20
            end
            item
              Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coFixed, coAllowFocus]
              Position = 4
              Width = 20
            end
            item
              Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coFixed, coAllowFocus]
              Position = 5
              Width = 20
            end>
        end
      end
    end
    object tabTasks: TTabSheet
      Caption = #1047#1072#1076#1072#1095#1080
      ImageIndex = 1
      TabVisible = False
      object Panel16: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          992
          33)
        object SpeedButton6: TSpeedButton
          Left = 961
          Top = 2
          Width = 26
          Height = 25
          Anchors = [akTop, akRight]
          Flat = True
          Glyph.Data = {
            5E060000424D5E06000000000000360400002800000017000000170000000100
            08000000000028020000C40E0000C40E00000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFF0909F4F3F40909FFFFFFFFFFFFFFFF00FFFFFFFFFFFFF4E9E8E9E9E9E9E9
            E8E9F4FFFFFFFFFFFF00FFFFFFFFF6E9E9E9E9E9E9E9E9E9E9E9E9E9F6FFFFFF
            FF00FFFFFF09E8E9E9E9E9E9E9E9E9E9E9E9E9E9E809FFFFFF00FFFFF6E8E9E9
            E9E9E9E9E9E9E9E9E9E9E9E9E9E8F6FFFF00FFFFE9E9E9E9E9E9E9E9E9E9E9E9
            E9E8E9E9E9E9E9FFFF00FFF4E9E9E9E9E9E9E9E8E8E8E8E9E8F6FFE9E9E9E9F4
            FF00FFE8E9E9E9E9E9E8F3F6FFFFF6EAF6FFFFE9E9E9E9E8FF0009E8E9E9E9E9
            E809FFFFFFFFFFFFFFFFE8E9E9E9E9E8090009E9E9E9E9E9F4FFFFF2E8E8F3FF
            FFF2E9E9E9E9E9E90900F3E9E9E9E9E8FFFFEAE9E9E9E8F3FFF6E8E9E9E9E9E9
            F300F3E9E9E9E9E9FFF6E8E9E9E9E9E8FFFFE8E9E9E9E9E9F300F3E9E9E9E9E9
            FFF6E8E9E9E9E9E8FFFFE8E9E9E9E9E9F30009E9E9E9E9E8FFFFE9E9E9E9E9EA
            FFFFE8E9E9E9E9E9090009E8E9E9E9E909FFFFE9E8E8E9FFFFF3E9E9E9E9E9E8
            0900FFE8E9E9E9E9E8F6FFFFF6F6FFFF09E8E9E9E9E9E9E8FF00FFF4E9E9E9E9
            E9E809FFFFFFFFF4E8E9E9E9E9E9E9F4FF00FFFFE8E9E9E9E9E9E9E8E9E9E8E9
            E9E9E9E9E9E9E8FFFF00FFFFF6E8E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E8F6FF
            FF00FFFFFF09E8E9E9E9E9E9E9E9E9E9E9E9E9E9E809FFFFFF00FFFFFFFFF6E8
            E9E9E9E9E9E9E9E9E9E9E9E8F6FFFFFFFF00FFFFFFFFFFFFF4E8E8E9E9E9E9E9
            E8E8F4FFFFFFFFFFFF00FFFFFFFFFFFFFFFF09F4F3F3F3F409FFFFFFFFFFFFFF
            FF00}
          ExplicitLeft = 1055
        end
        object Edit2: TEdit
          Left = 703
          Top = 2
          Width = 257
          Height = 25
          Anchors = [akTop, akRight]
          TabOrder = 0
          Text = #1055#1086#1080#1089#1082
        end
        object CheckBox1: TCheckBox
          Left = 0
          Top = 7
          Width = 97
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1089#1074#1086#1080
          TabOrder = 1
        end
        object bCreateTask: TButton
          Left = 112
          Top = 2
          Width = 105
          Height = 25
          Caption = #1057#1086#1079#1076#1072#1090#1100
          TabOrder = 2
        end
      end
      object browserTasks: TWebBrowser
        Left = 0
        Top = 33
        Width = 992
        Height = 586
        Align = alClient
        TabOrder = 1
        OnBeforeNavigate2 = browserTasksBeforeNavigate2
        ExplicitWidth = 1086
        ExplicitHeight = 543
        ControlData = {
          4C00000087660000913C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object tabMessages: TTabSheet
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
      ImageIndex = 2
      TabVisible = False
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 35
        Width = 992
        Height = 543
        Align = alTop
        BorderStyle = bsNone
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        object Panel23: TPanel
          Left = 0
          Top = 0
          Width = 992
          Height = 441
          Align = alTop
          Caption = 'Panel23'
          TabOrder = 0
          object Panel11: TPanel
            Left = 1
            Top = 210
            Width = 990
            Height = 230
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            Ctl3D = True
            Padding.Left = 5
            Padding.Top = 5
            Padding.Right = 5
            Padding.Bottom = 5
            ParentBackground = False
            ParentCtl3D = False
            TabOrder = 0
            StyleElements = [seFont, seClient]
          end
          object Panel3: TPanel
            Left = 1
            Top = 1
            Width = 990
            Height = 209
            Align = alTop
            BevelKind = bkFlat
            BevelOuter = bvNone
            Color = clInactiveBorder
            Padding.Left = 5
            Padding.Top = 5
            Padding.Right = 5
            Padding.Bottom = 5
            ParentBackground = False
            TabOrder = 1
            StyleElements = [seFont, seClient]
            object Panel4: TPanel
              Left = 5
              Top = 5
              Width = 976
              Height = 50
              Align = alTop
              BevelOuter = bvNone
              Padding.Left = 5
              Padding.Top = 5
              Padding.Right = 5
              Padding.Bottom = 5
              ParentColor = True
              TabOrder = 0
              object Image1: TImage
                Left = 5
                Top = 5
                Width = 40
                Height = 40
                Align = alLeft
                ExplicitLeft = 4
                ExplicitTop = 4
              end
              object Panel5: TPanel
                Left = 45
                Top = 5
                Width = 741
                Height = 40
                Align = alClient
                BevelOuter = bvNone
                Padding.Left = 5
                Padding.Right = 5
                ParentColor = True
                TabOrder = 0
                object Label1: TLabel
                  Left = 5
                  Top = 0
                  Width = 731
                  Height = 17
                  Align = alTop
                  Caption = #1048#1074#1072#1085#1086#1074' '#1048#1074#1072#1085' '#1048#1074#1072#1085#1086#1074#1080#1095
                  ExplicitWidth = 147
                end
                object Label2: TLabel
                  Left = 5
                  Top = 17
                  Width = 731
                  Height = 23
                  Align = alClient
                  Caption = #1055#1088#1086#1077#1082#1090' "'#1050#1072#1090#1102#1096#1072'", 12 '#1103#1085#1074#1072#1088#1103' 2056 '#1075'.'
                  ExplicitWidth = 236
                  ExplicitHeight = 17
                end
              end
              object Panel6: TPanel
                Left = 786
                Top = 5
                Width = 185
                Height = 40
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 1
                object SpeedButton1: TSpeedButton
                  Left = 153
                  Top = 0
                  Width = 32
                  Height = 40
                  Align = alRight
                  Flat = True
                  Glyph.Data = {
                    E6040000424DE604000000000000360000002800000014000000140000000100
                    180000000000B0040000C30E0000C30E00000000000000000000FFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF241CEDFFFFFFFFFFFF
                    FFFFFFFFFFFF241CEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF241CED241CED241CEDFFFFFFFFFFFF24
                    1CED241CED241CEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF241CED241CED241CED241CED241CED241C
                    EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFF241CED241CED241CED241CEDFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFF241CED241CED241CED241CEDFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFF241CED241CED241CED241CED241CED241CEDFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF241CED24
                    1CED241CEDFFFFFFFFFFFF241CED241CED241CEDFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF241CEDFFFF
                    FFFFFFFFFFFFFFFFFFFF241CEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                    FFFFFFFFFFFFFFFFFFFF}
                  ExplicitLeft = 1
                  ExplicitTop = 1
                  ExplicitHeight = 32
                end
              end
            end
            object WebBrowser1: TWebBrowser
              Left = 5
              Top = 55
              Width = 976
              Height = 145
              Align = alClient
              TabOrder = 1
              ExplicitWidth = 933
              ExplicitHeight = 133
              ControlData = {
                4C000000DF640000FC0E00000000000000000000000000000000000000000000
                000000004C000000000000000000000001000000E0D057007335CF11AE690800
                2B2E126209000000000000004C0000000114020000000000C000000000000046
                8000000000000000000000000000000000000000000000000000000000000000
                00000000000000000100000000000000000000000000000000000000}
            end
          end
        end
      end
      object Panel15: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 35
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          992
          35)
        object SpeedButton4: TSpeedButton
          Left = 959
          Top = 4
          Width = 26
          Height = 25
          Anchors = [akTop, akRight]
          Flat = True
          Glyph.Data = {
            5E060000424D5E06000000000000360400002800000017000000170000000100
            08000000000028020000C40E0000C40E00000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFF0909F4F3F40909FFFFFFFFFFFFFFFF00FFFFFFFFFFFFF4E9E8E9E9E9E9E9
            E8E9F4FFFFFFFFFFFF00FFFFFFFFF6E9E9E9E9E9E9E9E9E9E9E9E9E9F6FFFFFF
            FF00FFFFFF09E8E9E9E9E9E9E9E9E9E9E9E9E9E9E809FFFFFF00FFFFF6E8E9E9
            E9E9E9E9E9E9E9E9E9E9E9E9E9E8F6FFFF00FFFFE9E9E9E9E9E9E9E9E9E9E9E9
            E9E8E9E9E9E9E9FFFF00FFF4E9E9E9E9E9E9E9E8E8E8E8E9E8F6FFE9E9E9E9F4
            FF00FFE8E9E9E9E9E9E8F3F6FFFFF6EAF6FFFFE9E9E9E9E8FF0009E8E9E9E9E9
            E809FFFFFFFFFFFFFFFFE8E9E9E9E9E8090009E9E9E9E9E9F4FFFFF2E8E8F3FF
            FFF2E9E9E9E9E9E90900F3E9E9E9E9E8FFFFEAE9E9E9E8F3FFF6E8E9E9E9E9E9
            F300F3E9E9E9E9E9FFF6E8E9E9E9E9E8FFFFE8E9E9E9E9E9F300F3E9E9E9E9E9
            FFF6E8E9E9E9E9E8FFFFE8E9E9E9E9E9F30009E9E9E9E9E8FFFFE9E9E9E9E9EA
            FFFFE8E9E9E9E9E9090009E8E9E9E9E909FFFFE9E8E8E9FFFFF3E9E9E9E9E9E8
            0900FFE8E9E9E9E9E8F6FFFFF6F6FFFF09E8E9E9E9E9E9E8FF00FFF4E9E9E9E9
            E9E809FFFFFFFFF4E8E9E9E9E9E9E9F4FF00FFFFE8E9E9E9E9E9E9E8E9E9E8E9
            E9E9E9E9E9E9E8FFFF00FFFFF6E8E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E8F6FF
            FF00FFFFFF09E8E9E9E9E9E9E9E9E9E9E9E9E9E9E809FFFFFF00FFFFFFFFF6E8
            E9E9E9E9E9E9E9E9E9E9E9E8F6FFFFFFFF00FFFFFFFFFFFFF4E8E8E9E9E9E9E9
            E8E8F4FFFFFFFFFFFF00FFFFFFFFFFFFFFFF09F4F3F3F3F409FFFFFFFFFFFFFF
            FF00}
          ExplicitLeft = 1053
        end
        object bCreateMessage: TButton
          Left = 0
          Top = 4
          Width = 105
          Height = 25
          Caption = #1057#1086#1079#1076#1072#1090#1100
          TabOrder = 0
        end
        object Edit1: TEdit
          Left = 698
          Top = 4
          Width = 257
          Height = 25
          Anchors = [akTop, akRight]
          TabOrder = 1
          Text = #1055#1086#1080#1089#1082
        end
      end
    end
    object tabEvents: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1103
      ImageIndex = 3
      TabVisible = False
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 35
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          992
          35)
        object SpeedButton2: TSpeedButton
          Left = 959
          Top = 4
          Width = 26
          Height = 25
          Anchors = [akTop, akRight]
          Flat = True
          Glyph.Data = {
            5E060000424D5E06000000000000360400002800000017000000170000000100
            08000000000028020000C40E0000C40E00000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFF0909F4F3F40909FFFFFFFFFFFFFFFF00FFFFFFFFFFFFF4E9E8E9E9E9E9E9
            E8E9F4FFFFFFFFFFFF00FFFFFFFFF6E9E9E9E9E9E9E9E9E9E9E9E9E9F6FFFFFF
            FF00FFFFFF09E8E9E9E9E9E9E9E9E9E9E9E9E9E9E809FFFFFF00FFFFF6E8E9E9
            E9E9E9E9E9E9E9E9E9E9E9E9E9E8F6FFFF00FFFFE9E9E9E9E9E9E9E9E9E9E9E9
            E9E8E9E9E9E9E9FFFF00FFF4E9E9E9E9E9E9E9E8E8E8E8E9E8F6FFE9E9E9E9F4
            FF00FFE8E9E9E9E9E9E8F3F6FFFFF6EAF6FFFFE9E9E9E9E8FF0009E8E9E9E9E9
            E809FFFFFFFFFFFFFFFFE8E9E9E9E9E8090009E9E9E9E9E9F4FFFFF2E8E8F3FF
            FFF2E9E9E9E9E9E90900F3E9E9E9E9E8FFFFEAE9E9E9E8F3FFF6E8E9E9E9E9E9
            F300F3E9E9E9E9E9FFF6E8E9E9E9E9E8FFFFE8E9E9E9E9E9F300F3E9E9E9E9E9
            FFF6E8E9E9E9E9E8FFFFE8E9E9E9E9E9F30009E9E9E9E9E8FFFFE9E9E9E9E9EA
            FFFFE8E9E9E9E9E9090009E8E9E9E9E909FFFFE9E8E8E9FFFFF3E9E9E9E9E9E8
            0900FFE8E9E9E9E9E8F6FFFFF6F6FFFF09E8E9E9E9E9E9E8FF00FFF4E9E9E9E9
            E9E809FFFFFFFFF4E8E9E9E9E9E9E9F4FF00FFFFE8E9E9E9E9E9E9E8E9E9E8E9
            E9E9E9E9E9E9E8FFFF00FFFFF6E8E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E8F6FF
            FF00FFFFFF09E8E9E9E9E9E9E9E9E9E9E9E9E9E9E809FFFFFF00FFFFFFFFF6E8
            E9E9E9E9E9E9E9E9E9E9E9E8F6FFFFFFFF00FFFFFFFFFFFFF4E8E8E9E9E9E9E9
            E8E8F4FFFFFFFFFFFF00FFFFFFFFFFFFFFFF09F4F3F3F3F409FFFFFFFFFFFFFF
            FF00}
          ExplicitLeft = 1053
        end
        object bCreateEvent: TButton
          Left = 0
          Top = 4
          Width = 105
          Height = 25
          Caption = #1057#1086#1079#1076#1072#1090#1100
          TabOrder = 0
        end
        object Edit3: TEdit
          Left = 698
          Top = 4
          Width = 257
          Height = 25
          Anchors = [akTop, akRight]
          TabOrder = 1
          Text = #1055#1086#1080#1089#1082
        end
      end
      object browserEvents: TWebBrowser
        Left = 0
        Top = 35
        Width = 992
        Height = 584
        Align = alClient
        TabOrder = 1
        ExplicitLeft = 464
        ExplicitTop = 304
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C000000876600005C3C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object tabStatus: TTabSheet
      Caption = #1057#1090#1072#1090#1091#1089
      ImageIndex = 4
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 619
        Align = alClient
        TabOrder = 0
        DesignSize = (
          992
          619)
        object Label9: TLabel
          Left = 18
          Top = 146
          Width = 199
          Height = 17
          Caption = #1059#1095#1072#1089#1090#1085#1080#1082#1080' '#1088#1072#1073#1086#1095#1077#1081' '#1075#1088#1091#1087#1087#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lStatus: TLabel
          Left = 129
          Top = 54
          Width = 12
          Height = 17
          Caption = '...'
        end
        object lRedyPercent: TLabel
          Left = 129
          Top = 81
          Width = 12
          Height = 17
          Caption = '...'
        end
        object Label14: TLabel
          Left = 49
          Top = 81
          Width = 74
          Height = 17
          Caption = #1047#1072#1074#1077#1088#1096#1077#1085#1086':'
        end
        object Label13: TLabel
          Left = 71
          Top = 54
          Width = 52
          Height = 17
          Caption = #1057#1090#1072#1090#1091#1089':'
        end
        object Label3: TLabel
          Left = 16
          Top = 109
          Width = 107
          Height = 17
          Caption = #1056#1072#1073#1086#1095#1072#1103' '#1075#1088#1091#1087#1087#1072':'
        end
        object lWorkgroupName: TLabel
          Left = 129
          Top = 109
          Width = 12
          Height = 17
          Caption = '...'
        end
        object bAddTask: TButton
          Left = 416
          Top = 430
          Width = 185
          Height = 30
          Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1076#1072#1095#1091
          TabOrder = 0
          Visible = False
        end
        object bDeleteProject: TButton
          Left = 349
          Top = 11
          Width = 161
          Height = 30
          Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1077#1082#1090
          TabOrder = 1
          OnClick = bDeleteProjectClick
        end
        object bDoneProject: TButton
          Left = 16
          Top = 11
          Width = 160
          Height = 30
          Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1087#1088#1086#1077#1082#1090
          TabOrder = 2
          OnClick = bDoneProjectClick
        end
        object bWorkgroupSetup: TButton
          Left = 581
          Top = 11
          Width = 212
          Height = 30
          Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1088#1072#1073#1086#1095#1077#1081' '#1075#1088#1091#1087#1087#1099
          TabOrder = 3
        end
        object listUsers: TListBox
          Left = 16
          Top = 216
          Width = 345
          Height = 280
          ItemHeight = 17
          TabOrder = 4
        end
        object bSendMessage: TButton
          Left = 416
          Top = 466
          Width = 185
          Height = 30
          Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
          TabOrder = 5
          Visible = False
        end
        object bFreezeProject: TButton
          Left = 182
          Top = 11
          Width = 161
          Height = 30
          Caption = #1047#1072#1084#1086#1088#1086#1079#1080#1090#1100' '#1087#1088#1086#1077#1082#1090
          TabOrder = 6
          OnClick = bFreezeProjectClick
        end
        object bUnFreezeProject: TButton
          Left = 816
          Top = 11
          Width = 161
          Height = 30
          Anchors = [akTop, akRight]
          Caption = #1042#1077#1088#1085#1091#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
          TabOrder = 7
          OnClick = bUnFreezeProjectClick
        end
        object cbUserGroups: TComboBox
          Left = 16
          Top = 168
          Width = 345
          Height = 25
          Style = csDropDownList
          TabOrder = 8
        end
        object eUserFilter: TEdit
          Left = 16
          Top = 192
          Width = 345
          Height = 25
          TabOrder = 9
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 651
    Width = 1000
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
  object popObject1: TPopupMenu
    OnPopup = popObject1Popup
    Left = 192
    Top = 585
    object N10: TMenuItem
      Caption = #1050#1072#1088#1090#1086#1095#1082#1072'...'
      OnClick = N10Click
    end
    object menuAddDocument: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090'...'
      OnClick = menuAddDocumentClick
    end
    object menuChangeCount: TMenuItem
      Action = actEditCount
      Visible = False
    end
  end
  object popDocument: TPopupMenu
    Left = 32
    Top = 585
    object menuViewFile: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
      OnClick = menuViewFileClick
    end
    object menuTakeFileToWork: TMenuItem
      Caption = #1042#1079#1103#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      OnClick = menuTakeFileToWorkClick
    end
    object menuMakeFileMain: TMenuItem
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1086#1089#1085#1086#1074#1085#1099#1084
      OnClick = menuMakeFileMainClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object menuDeleteFile: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = menuDeleteFileClick
    end
  end
  object popWorkDocument: TPopupMenu
    Left = 120
    Top = 585
    object MenuItem2: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
      OnClick = menuViewFileClick
    end
    object menuEditFile: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
      OnClick = menuEditFileClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object menuSaveToPDM: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1074' PDM'
      OnClick = menuSaveToPDMClick
    end
    object menuSaveAsVersion: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082' '#1085#1086#1074#1091#1102' '#1074#1077#1088#1089#1080#1102
      OnClick = menuSaveAsVersionClick
    end
    object menuCancelVersion: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1088#1072#1073#1086#1095#1091#1102' '#1074#1077#1088#1089#1080#1102
      OnClick = menuCancelVersionClick
    end
  end
  object ActionList1: TActionList
    Left = 118
    Top = 529
    object actEditCount: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086'...'
      Enabled = False
      ShortCut = 32
      OnExecute = actEditCountExecute
    end
    object actToWork: TAction
      OnExecute = actToWorkExecute
    end
    object actFromWork: TAction
      OnExecute = actFromWorkExecute
    end
    object actToCheck: TAction
      OnExecute = actToCheckExecute
    end
    object actFromCheck: TAction
      OnExecute = actFromCheckExecute
    end
    object actToReady: TAction
      OnExecute = actToReadyExecute
    end
    object actFromReady: TAction
      OnExecute = actFromReadyExecute
    end
  end
  object popStructure: TPopupMenu
    OnPopup = popStructurePopup
    Left = 148
    Top = 421
    object menuCreateIspol: TMenuItem
      Caption = #1053#1086#1074#1086#1077' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1077
      OnClick = menuCreateIspolClick
    end
    object menuCopyIspol: TMenuItem
      Caption = #1053#1086#1074#1086#1077' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1077' '#1087#1086' '#1086#1073#1088#1072#1079#1094#1091
      OnClick = menuCopyIspolClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object menuReadySubitems: TMenuItem
      Caption = #1055#1088#1080#1085#1103#1090#1100' '#1074#1093#1086#1076#1103#1097#1080#1077' '#1074' '#1089#1086#1089#1090#1072#1074
      OnClick = menuReadySubitemsClick
    end
    object menuReadyAllSubitems: TMenuItem
      Caption = #1055#1088#1080#1085#1103#1090#1100' '#1074#1089#1077' '#1074#1093#1086#1076#1103#1097#1080#1077
      OnClick = menuReadyAllSubitemsClick
    end
    object N4: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1080' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1050#1044
      OnClick = N4Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N1Click
    end
    object menuDelEditor: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1086#1088#1072'...'
    end
    object menuDelChecker: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1086#1085#1090#1088#1086#1083#1077#1088#1072'...'
    end
  end
  object imgObjectState: TImageList
    Height = 20
    Width = 20
    Left = 28
    Top = 525
    Bitmap = {
      494C010106000800A40014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000002800000001002000000000000032
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F7F8FFC0BBBCFFC0BBBCFFC0BBBCFFC0BB
      BCFFC0BBBCFFC0BBBCFFC0BBBCFFC0BBBCFFC0BBBCFFC0BBBCFFC0BABCFFC2BD
      BEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDBFF010101FF101010FFF6F6
      F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF736F70FF0D0C0DFF405C56FF415A54FF415A54FF415A
      54FF415A54FF415A54FF415A54FF415A54FF415A54FF415A54FF415A54FF3D59
      52FF000000FFA5A1A2FFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF2F2F2FFCECECEFFFFFFFFFFFFFFFFFF7C7C7CFF929292FF4E4E4EFFB8B8
      B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFDBD9D9FF261F20FF4BFFD9FF13F5BEFF17F4BEFF17F4BEFF17F4
      BEFF17F4BEFF17F4BEFF17F4BEFF17F4BEFF17F4BEFF17F4BEFF17F4BEFF14F7
      BFFF3FF9CCFF000000FFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFE0E0
      E0FF020202FF2C2C2CFF7D7D7DFFFFFFFFFFFFFFFFFF404040FF656565FFFFFF
      FFFFFFFFFFFFDEDEDEFF0F0F0FFF848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF908588FF318B75FF15F1BBFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF14F7C0FF3C5851FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF8383
      83FF8B8B8BFFFFFFFFFF0E0E0EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF757575FF4F4F4FFF0E0E0EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF948588FF028465FF1DF0BDFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF14EAB6FF17EDB9FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF17F4BEFF3F5851FFC2BDBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF222222FF000000FFDBDBDBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF747474FFDEDEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF1DE6B5FF1DE6B5FF1DE6B5FF0CEE
      B7FF7DCFBBFF55A793FF10F2BAFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF1DE6B5FF1DE6B5FF0FF1BAFF71DB
      C1FF2B040EFF260009FF6DD9BFFF0DEDB7FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFF5A5A5AFF2F2F
      2FFFE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF1DE6B5FF12F4BCFF5FBBA5FF2D00
      06FF7CF2D5FF7EF4D8FF2C0004FF74E8CCFF12EAB5FF1DE6B5FF1DE6B5FF1DE6
      B5FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFF6E6E6EFF797979FFE3E3
      E3FF0A0A0AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEBEBEBFF000000FF959595FFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF18EDB9FF4DA892FF230007FF76EB
      CFFF0BEBB5FF0DEFB8FF61BDA7FF21030AFF3BFFD2FF15E7B4FF1DE6B5FF1DE6
      B5FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFF565656FFA5A5A5FFFFFF
      FFFF050505FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D7FF000000FF747474FFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF14E9B5FF78C0AEFF2DE9BBFF12EA
      B6FF1DE6B5FF1DE6B5FF0DF5BDFF82A29AFF42252CFF43FED1FF18E6B4FF1DE6
      B5FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFF282828FF0C0C
      0CFFC5C5C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F5FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF1DE6B5FF14E9B5FF1AE7B5FF1DE6
      B5FF1DE6B5FF1DE6B5FF1AE5B4FF26FEC9FF646262FF7B5D65FF0DFEC3FF1CE6
      B4FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFEFEFEFFE3E3E3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF1DE6B5FF1DE6B5FF1DE6B5FF19E6B4FF25FFC9FF2B3331FF598177FF1FF0
      BDFF16F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFC4C4
      C4FF010101FF1E1E1EFF616161FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF958589FF068466FF1DF0BDFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF16E7B4FF4CF7CDFFA5737FFF33F0
      C2FF14F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000
      00FFFFFFFFFFFFFFFFFF1F1F1FFFE5E5E5FFFFFFFFFFADADADFFBDBDBDFFFFFF
      FFFFFFFFFFFFFFFFFFFF000000FFA6A6A6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF948589FF028465FF1DF0BDFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF17E6B4FF10F0B9FF1AE6
      B4FF17F4BEFF3E5751FFC3BEBFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF1E1E
      1EFFCDCDCDFFFFFFFFFF020202FFFFFFFFFF202020FF595959FF3C3C3CFF5252
      52FFFFFFFFFFFFFFFFFF555555FFD5D5D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF8F8386FF358D78FF18F0BCFF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6B5FF1DE6
      B5FF13F5BEFF3E5A54FFC1BCBDFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF1E1E1EFF000000FFCBCBCBFFD2D2D2FF444444FFFFFFFFFFFFFFFFFF0707
      07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC9C5C6FF2D3A37FF1DFFCBFF18F0BCFF1DF0BDFF1DF0BDFF1DF0
      BDFF1DF0BDFF1DF0BDFF1DF0BDFF1DF0BDFF1DF0BDFF1DF0BDFF1DF0BDFF15F1
      BBFF4BFFD8FF0E0D0DFFF9F7F8FFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E9FF0F0F0FFFFFFFFFFFFFFFFFFF0000
      00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF423A3CFF2D3A37FF358E78FF038465FF078566FF0785
      66FF078566FF078566FF078566FF078566FF078566FF078566FF038565FF318B
      76FF261F21FF736F70FFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848484FF090909FF030303FFB4B4
      B4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFC7C3C4FF94898BFF9C8D90FF9C8D90FF9C8D
      90FF9C8D90FF9C8D90FF9C8D90FF9C8D90FF9C8D90FF9C8D90FF9C8D90FF9489
      8BFFDBD9D9FFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF2A2A2AFF4343
      43FFE9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF9C9C9CFF262626FF1E1E1EFF3E3E3EFF333333FF323232FF3232
      32FF323232FF333333FF2F2F2FFF646464FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF666666FF636363FFFFFFFFFFD8D8
      D8FF000000FFDDDDDDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF616161FFC3C3C3FF6F6F6FFF656565FFFFFFFFFFFCFCFCFFFCFC
      FCFFFCFCFCFFFFFFFFFFF3F3F3FF343434FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF131313FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF000000FF444444FFD8D8D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF686868FF868686FFFFFFFFFF212121FFABABABFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF9F9F9FF373737FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0F0F0FFFFFFFFFFFFFFFFFFFFFFF
      FFFF484848FF6D6D6DFFCCCCCCFF000000FF000000FF575757FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E9FF313131FF6A6A
      6AFFFFFFFFFF7A7A7AFF000000FFD8D8D8FFFFFFFFFF000000FFF6F6F6FFFFFF
      FFFFFFFFFFFFFFFFFFFFF7F7F7FF373737FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF969696FF303030FFFFFFFFFF4343
      43FF757575FFFFFFFFFFFFFFFFFFE9E9E9FFFFFFFFFF2C2C2CFF5C5C5CFFC9C9
      C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1E1E1FF000000FFDEDEDEFF8484
      84FF222222FF626262FFB1B1B1FF000000FFFFFFFFFFF1F1F1FF000000FFFFFF
      FFFFFFFFFFFFFFFFFFFFF7F7F7FF373737FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8D8DFF000000FF7373
      73FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF818181FF929292FF0808
      08FFDBDBDBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFE4E4E4FFFFFFFFFFFFFF
      FFFFB5B5B5FF000000FFC6C6C6FFD8D8D8FF070707FFFFFFFFFF9D9D9DFF2D2D
      2DFFFFFFFFFFFFFFFFFFF7F7F7FF373737FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E7E7FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFE7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E7
      E7FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFE7E7E7FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF545454FF7E7E7EFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB9B9
      B9FF000000FF010101FFEBEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFDFDFDFFFFFFFFFFFF6F6F6FFFFFF
      FFFFFFFFFFFFE3E3E3FFF6F6F6FFFFFFFFFF8C8C8CFF3C3C3CFFFFFFFFFF5A5A
      5AFF737373FFFFFFFFFFF7F7F7FF373737FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFE7E7E7FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FFE7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E7E7FFC3C3
      C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFE7E7E7FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1A1A1FF545454FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E3
      E3FFFFFFFFFFD9D9D9FF343434FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF0F0F0FFFCECECEFFFFFFFFFFFFFFFFFF000000FF1A1A
      1AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3E3E3EFF8E8E8EFFFFFF
      FFFF111111FFC5C5C5FFFFFFFFFF373737FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FFC3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF323232FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFA3A3A3FF5C5C5CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF393939FF0D0D0DFF222222FF191919FF000000FF818181FFD1D1
      D1FF000000FFF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF090909FFC7C7
      C7FFFFFFFFFF000000FFF3F3F3FF3B3B3BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FFC3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF262626FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFB7B7B7FF202020FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF151515FFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBFFF616161FFFFFF
      FFFFD1D1D1FF000000FFF0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFF0000
      00FFFFFFFFFFE7E7E7FF010101FF464646FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FFC3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF323232FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8B8
      B8FF000000FF737373FFDBDBDBFF636363FF686868FFE6E6E6FFFFFFFFFFFFFF
      FFFFDEDEDEFF404040FFFFFFFFFFFFFFFFFFFFFFFFFF707070FF979797FF1F1F
      1FFFFFFFFFFFF6F6F6FF000000FF7E7E7EFFE2E2E2FFE0E0E0FFEBEBEBFFB8B8
      B8FF060606FFF4F4F4FF161616FFB5B5B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FFC3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8B8B8BFF737373FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB5B5B5FF0707
      07FFFFFFFFFF535353FF282828FFB3B3B3FFA3A3A3FF000000FFD7D7D7FFFFFF
      FFFFA7A7A7FF7C7C7CFFFFFFFFFFFFFFFFFFFFFFFFFF2B2B2BFFB3B3B3FF5454
      54FFFFFFFFFFFFFFFFFFFFFFFFFF7E7E7EFF373737FF3C3C3CFF464646FF4F4F
      4FFF434343FF3A3A3AFFB9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFE7E7E7FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFC3C3C3FFE7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E7E7FFC3C3
      C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FFE7E7E7FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF303030FF8F8F8FFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEAEFF000000FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF
      FFFF626262FFC8C8C8FFFFFFFFFFFFFFFFFFFFFFFFFF171717FF939393FF9C9C
      9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFF818181FF7979
      79FFECECECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3
      C3FFE6E6E6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6
      E6FFC3C3C3FFC3C3C3FFC3C3C3FFC3C3C3FFE6E6E6FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF282828FF8F8F
      8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB4B4B4FF000000FFB9B9
      B9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9C9C9CFFFFFFFFFF727272FFA5A5
      A5FF3F3F3FFFF6F6F6FFFFFFFFFFFFFFFFFFEBEBEBFF404040FF525252FFD7D7
      D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3FF010101FFAAAAAAFFB6B6
      B6FF141414FF959595FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2C2C
      2CFF888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF363636FF424242FF4646
      46FFFFFFFFFFFFFFFFFFFFFFFFFF363636FF565656FF000000FFCCCCCCFF5151
      51FF101010FFF3F3F3FFE6E6E6FFE5E5E5FF929292FF7B7B7BFF252525FFFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF070707FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF080808FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF474747FF1C1C1CFF878787FF737373FF000000FF9B9B9BFF5F5F5FFFCECE
      CEFFFFFFFFFFFFFFFFFF343434FF717171FFFFFFFFFFF2F2F2FF000000FF2F2F
      2FFF838383FF000000FF000000FF3B3B3BFF5E5E5EFFF9F9F9FF0F0F0FFFFFFF
      FFFFFFFFFFFFFFFFFFFF848484FF191919FF000000FF181818FF0F0F0FFF0F0F
      0FFF151515FF000000FFCDCDCDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFEBEBEBFF949494FFA2A2A2FFFFFFFFFFFFFFFFFF383838FFE0E0
      E0FFFFFFFFFF7E7E7EFF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E8FF7F7F
      7FFFFFFFFFFFFFFFFFFFA6A6A6FF1D1D1DFF4A4A4AFF868686FF555555FFFFFF
      FFFFFFFFFFFFFFFFFFFFB4B4B4FF131313FFE7E7E7FFE9E9E9FFE7E7E7FFE7E7
      E7FFF4F4F4FF515151FFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA6A6A6FF2727
      27FFFFFFFFFFC4C4C4FF181818FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCECECEFF4B4B4BFFDEDEDEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6FFF161616FF4A4A4AFF474747FF4A4A
      4AFF545454FF0C0C0CFFC6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7D7D
      7DFF030303FFCACACAFFA4A4A4FF222222FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFA8A8A8FF2F2F2FFFFFFFFFFFFFFFFFFFEDEDEDFFD2D2
      D2FFB3B3B3FF1B1B1BFFC1C1C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFE3E3E3FF5E5E5EFF333333FF000000FF919191FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF676767FF141414FF323232FF404040FF515151FF6B6B
      6BFF909090FFB4B4B4FFFFFFFFFFFFFFFFFF424D3E000000000000003E000000
      2800000050000000280000000100010000000000E00100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object timerCheckRole: TTimer
    Enabled = False
    OnTimer = timerCheckRoleTimer
    Left = 326
    Top = 592
  end
  object listEditor: TImageList
    Height = 20
    Width = 20
    Left = 268
    Top = 532
    Bitmap = {
      494C010102000800540014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000001400000001002000000000000019
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC8E2BDFFA0D0
      8CFF8AC870FF7CBD62FF7CBD62FF8AC870FFA0D08CFFC8E2BDFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF87C46EFF34A504FF3CAA0EFF41AC
      14FF43AD17FF44AE18FF44AE18FF43AD17FF41AC14FF3CAA0EFF34A504FF87C4
      6EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFF96C881FF38A909FF4BB021FF4CB122FF4CB1
      22FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4BB021FF38A9
      09FF96C781FFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFA0D08DFF41AC14FF4CB122FF4CB122FF4CB1
      22FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF41AC
      14FFA1D08DFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFADD79BFF3FAC12FF4CB122FF4CB122FF4CB1
      22FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF3FAC
      12FFADD79BFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFC9E2BFFF3BAA0DFF4CB122FF4CB122FF4CB1
      22FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF3BAA
      0DFFC9E2BFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF34A405FF49B01FFF4CB122FF4CB1
      22FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF4CB122FF49B01FFF34A4
      05FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1E4C9FF34A405FF3EAB10FF44AE
      19FF40AC14FF38A809FF38A809FF40AC14FF44AE19FF3EAB10FF34A405FFD1E5
      C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB3D9A3FF72BD
      53FFA9D497FFFFFFFFFFFFFFFFFFA9D397FF72BD53FFB3D9A3FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFB9DBACFF57B131FF57B131FFBADBACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF98CD
      83FF35A805FF48AF1DFF48AF1DFF35A805FF98CD83FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9FDFF31A5
      01FF4BB021FF4CB122FF4CB122FF4BB021FF31A501FFFCF9FDFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB9DCABFF3EAB
      10FF4CB122FF4CB122FF4CB122FF4CB122FF3EAB10FFB9DCABFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9D099FF40AC
      12FF4CB122FF4CB122FF4CB122FF4CB122FF40AC12FFA9D098FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8DCA9FF3EAB
      11FF4CB122FF4CB122FF4CB122FF4CB122FF3EAB11FFB8DDA9FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8F0E6FF32A6
      02FF4CB122FF4CB122FF4CB122FF4CB122FF32A602FFE9F0E6FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF79BD
      5DFF34A805FF41AC14FF41AC14FF34A705FF79BE5DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFCEE5C5FF9DCD88FF9DCD88FFCEE5C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000140000000100010000000000F00000000000000000000000
      000000000000000000000000FFFFFF00FFFFF0000000000000000000FFFFF000
      0000000000000000FFFFF0000000000000000000FFFFF0000000000000000000
      FFFFF0000000000000000000FFFFF0000000000000000000FFFFF00000000000
      00000000FFFFF0000000000000000000FFFFF0000000000000000000FFFFF000
      0000000000000000FFFFF0000000000000000000FFFFF0000000000000000000
      FFFFF0000000000000000000FFFFF0000000000000000000FFFFF00000000000
      00000000FFFFF0000000000000000000FFFFF0000000000000000000FFFFF000
      0000000000000000FFFFF0000000000000000000FFFFF0000000000000000000
      00000000000000000000000000000000000000000000}
  end
  object listChecker: TImageList
    Height = 20
    Width = 20
    Left = 268
    Top = 484
    Bitmap = {
      494C010102000800480014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000001400000001002000000000000019
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFF1DEB4FFEAC9
      7CFFE9BF5BFFE0B34CFFE0B34CFFE9BF5BFFEAC97CFFF1DEB4FFFBFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5BB59FFE39500FFE69A00FFE79C
      00FFE79D00FFE89E00FFE89E00FFE79D00FFE79C00FFE69A00FFE39500FFE5BB
      5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFE4C070FFE79900FFE8A100FFE8A200FFE8A2
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A100FFE799
      00FFE2C070FFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFE9C97DFFE79C00FFE8A200FFE8A200FFE8A2
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE79C
      00FFE9C97EFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFEED18DFFE79C00FFE8A200FFE8A200FFE8A2
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE79C
      00FFEED18DFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFEFDEB7FFE79A00FFE8A200FFE8A200FFE8A2
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE79A
      00FFEFDEB7FFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFE19300FFE8A100FFE8A200FFE8A2
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A200FFE8A100FFE193
      00FFFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE2C2FFE29400FFE79B00FFE79E
      00FFE79C00FFE69800FFE69800FFE79C00FFE79E00FFE79B00FFE29400FFEFE2
      C2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFEED396FFE6B2
      3AFFEBCD89FFFDFFFFFFFDFFFFFFEBCD89FFE6B23AFFEED396FFFBFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEDD6A0FFE3A412FFE3A412FFEDD6A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9C5
      71FFE69700FFE8A000FFE8A000FFE69700FFE9C571FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FAFEFFE494
      00FFE8A100FFE8A200FFE8A200FFE8A100FFE49400FFF8FAFEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEED7A0FFE79B
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE79B00FFEED7A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5CA8CFFE79C
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE79C00FFE5CA8CFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0D79DFFE69B
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE69B00FFF0D79DFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3EFE3FFE695
      00FFE8A200FFE8A200FFE8A200FFE8A200FFE69500FFF3EFE4FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3B3
      46FFE69600FFE79C00FFE79C00FFE69600FFE3B346FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF1E1BDFFE8C678FFE8C678FFF1E1BDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000140000000100010000000000F00000000000000000000000
      000000000000000000000000FFFFFF00FFFFF0000000000000000000FFFFF000
      0000000000000000FFFFF0000000000000000000FFFFF0000000000000000000
      FFFFF0000000000000000000FFFFF0000000000000000000FFFFF00000000000
      00000000FFFFF0000000000000000000FFFFF0000000000000000000FFFFF000
      0000000000000000FFFFF0000000000000000000FFFFF0000000000000000000
      FFFFF0000000000000000000FFFFF0000000000000000000FFFFF00000000000
      00000000FFFFF0000000000000000000FFFFF0000000000000000000FFFFF000
      0000000000000000FFFFF0000000000000000000FFFFF0000000000000000000
      00000000000000000000000000000000000000000000}
  end
  object DataSource1: TDataSource
    DataSet = MemTableEh1
    Left = 872
    Top = 608
  end
  object MemTableEh1: TMemTableEh
    Active = True
    FieldDefs = <
      item
        Name = 'col2'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'col1'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'name'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'number'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 814
    Top = 608
    object MemTableEh1col2: TStringField
      FieldName = 'col2'
    end
    object MemTableEh1col1: TStringField
      FieldName = 'col1'
    end
    object MemTableEh1name: TStringField
      FieldName = 'name'
    end
    object MemTableEh1number: TStringField
      FieldName = 'number'
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object col2: TMTStringDataFieldEh
          FieldName = 'col2'
          StringDataType = fdtStringEh
        end
        object col1: TMTStringDataFieldEh
          FieldName = 'col1'
          StringDataType = fdtStringEh
        end
        object name: TMTStringDataFieldEh
          FieldName = 'name'
          StringDataType = fdtStringEh
        end
        object number: TMTStringDataFieldEh
          FieldName = 'number'
          StringDataType = fdtStringEh
        end
      end
      object RecordsList: TRecordsListEh
        Data = (
          (
            '1'
            '1'
            '1'
            '1')
          (
            '1'
            '1'
            '1'
            '1')
          (
            '1'
            '1'
            '1'
            '1')
          (
            '1'
            '1'
            '1'
            '1'))
      end
    end
  end
end
