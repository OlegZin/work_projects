object fAddProject: TfAddProject
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1087#1088#1086#1077#1082#1090
  ClientHeight = 575
  ClientWidth = 535
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    535
    575)
  PixelsPerInch = 96
  TextHeight = 17
  object Label3: TLabel
    Left = 20
    Top = 356
    Width = 102
    Height = 17
    Caption = #1056#1072#1073#1086#1095#1072#1103' '#1075#1088#1091#1087#1087#1072
  end
  object Label6: TLabel
    Left = 20
    Top = 423
    Width = 88
    Height = 17
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object Label11: TLabel
    Left = 20
    Top = 212
    Width = 65
    Height = 17
    Caption = #1055#1086#1088#1090#1092#1077#1083#1100
  end
  object Label12: TLabel
    Left = 278
    Top = 212
    Width = 46
    Height = 17
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object Label13: TLabel
    Left = 20
    Top = 258
    Width = 71
    Height = 17
    Caption = #1055#1088#1086#1076#1091#1082#1094#1080#1103
  end
  object lFullProd: TLabel
    Left = 20
    Top = 309
    Width = 494
    Height = 41
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object pgMode: TPageControl
    Left = 0
    Top = 0
    Width = 535
    Height = 201
    ActivePage = tabSpec
    Align = alTop
    TabOrder = 0
    TabWidth = 200
    ExplicitWidth = 479
    object tabSpec: TTabSheet
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      ExplicitLeft = 36
      ExplicitTop = 34
      DesignSize = (
        527
        169)
      object Label1: TLabel
        Left = 16
        Top = 105
        Width = 248
        Height = 17
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080
      end
      object Label2: TLabel
        Left = 16
        Top = 14
        Width = 240
        Height = 17
        Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080
      end
      object Label4: TLabel
        Left = 16
        Top = 63
        Width = 274
        Height = 16
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 16
        Top = 79
        Width = 339
        Height = 16
        Caption = #1042#1074#1077#1076#1080#1090#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1086#1074#1086#1081' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object cbMark: TComboBox
        Left = 16
        Top = 34
        Width = 494
        Height = 25
        TabOrder = 0
        OnChange = cbMarkChange
        OnDropDown = cbMarkDropDown
        OnKeyUp = cbMarkKeyUp
      end
      object eName: TEdit
        Left = 16
        Top = 128
        Width = 494
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        ExplicitWidth = 438
      end
    end
    object tabObject: TTabSheet
      Caption = #1054#1073#1098#1077#1082#1090
      ImageIndex = 1
      ExplicitWidth = 471
      DesignSize = (
        527
        169)
      object Label7: TLabel
        Left = 16
        Top = 14
        Width = 142
        Height = 17
        Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
      end
      object Label8: TLabel
        Left = 16
        Top = 63
        Width = 267
        Height = 16
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1073#1098#1077#1082#1090' '#1087#1086' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1102', '#1077#1089#1083#1080' '#1077#1089#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 16
        Top = 94
        Width = 150
        Height = 17
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
      end
      object Label10: TLabel
        Left = 16
        Top = 143
        Width = 236
        Height = 16
        Caption = #1080#1083#1080' '#1074#1099#1073#1077#1088#1080#1090#1077' '#1086#1073#1098#1077#1082#1090' '#1087#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1102
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object bObjectMark: TImage
        Left = 489
        Top = 36
        Width = 21
        Height = 21
        Cursor = crHandPoint
        Picture.Data = {
          07544269746D61702E060000424D2E0600000000000036040000280000001500
          0000150000000100080000000000F8010000C40E0000C40E0000000100000000
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
          FF00FFFFFFFFFFFFFFF609F4F3F409F6FFFFFFFFFFFFFF000000FFFFFFFFFF09
          E9E0E8E8E8E8E8E0E909FFFFFFFFFF000000FFFFFFFFF3E0E9E9E9E9E9E9E9E9
          E9E0F3FFFFFFFF000000FFFFFFF2E8E9E9E9E9E9E9E9E9E9E9E9E8F2FFFFFF00
          0000FFFFF3E8E9E9E9E9E9E9E9E9E9E9E8E9E9E8F3FFFF000000FF09E0E9E9E9
          E9E9E8E8E8E8E8E909F3E9E9E009FF000000FFE9E9E9E9E9E8E9F40909F4E909
          FF09E8E9E9E9FF000000F6E0E9E9E9E8EA09FFFFFFFFF6FF09E9E9E9E9E0F600
          000009E8E9E9E9E909FFF4E9E909FFF6E9E8E9E9E9E809000000F4E8E9E9E8F4
          FFF4E8E9E9E8F4FFF4E8E9E9E9E8F4000000F3E9E9E9E809FFEAE9E9E9E9E9FF
          09E8E9E9E9E9F3000000F3E8E9E9E909FFEAE9E9E9E9E9FF09E8E9E9E9E8F300
          000009E8E9E9E8F4FFF4E8E9E9E8F4FFF4E8E9E9E9E809000000F6E0E9E9E9EA
          08FFF4EAEAF4FF09E9E9E9E9E9E0F6000000FFE9E9E9E9E8F309FFFFFFFF09F3
          E8E9E9E9E9E9FF000000FF09E0E9E9E9E8EAF40909F4E9E8E9E9E9E9E009FF00
          0000FFFFF3E8E9E9E9E9E8E9E9E8E9E9E9E9E9E8F3FFFF000000FFFFF6EAE8E9
          E9E9E9E9E9E9E9E9E9E9E8EAF6FFFF000000FFFFFFF6F3E0E9E9E9E9E9E9E9E9
          E9E0F3F6FFFFFF000000FFFFFFFFFF09E9E0E8E8E9E8E8E0E909FFFFFFFFFF00
          0000FFFFFFFFFFFFFFF609F3F3F309F6FFFFFFFFFFFFFF000000}
        Stretch = True
        OnClick = bObjectMarkClick
      end
      object bObjectName: TImage
        Left = 489
        Top = 116
        Width = 21
        Height = 21
        Cursor = crHandPoint
        Picture.Data = {
          07544269746D61702E060000424D2E0600000000000036040000280000001500
          0000150000000100080000000000F8010000C40E0000C40E0000000100000000
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
          FF00FFFFFFFFFFFFFFF609F4F3F409F6FFFFFFFFFFFFFF000000FFFFFFFFFF09
          E9E0E8E8E8E8E8E0E909FFFFFFFFFF000000FFFFFFFFF3E0E9E9E9E9E9E9E9E9
          E9E0F3FFFFFFFF000000FFFFFFF2E8E9E9E9E9E9E9E9E9E9E9E9E8F2FFFFFF00
          0000FFFFF3E8E9E9E9E9E9E9E9E9E9E9E8E9E9E8F3FFFF000000FF09E0E9E9E9
          E9E9E8E8E8E8E8E909F3E9E9E009FF000000FFE9E9E9E9E9E8E9F40909F4E909
          FF09E8E9E9E9FF000000F6E0E9E9E9E8EA09FFFFFFFFF6FF09E9E9E9E9E0F600
          000009E8E9E9E9E909FFF4E9E909FFF6E9E8E9E9E9E809000000F4E8E9E9E8F4
          FFF4E8E9E9E8F4FFF4E8E9E9E9E8F4000000F3E9E9E9E809FFEAE9E9E9E9E9FF
          09E8E9E9E9E9F3000000F3E8E9E9E909FFEAE9E9E9E9E9FF09E8E9E9E9E8F300
          000009E8E9E9E8F4FFF4E8E9E9E8F4FFF4E8E9E9E9E809000000F6E0E9E9E9EA
          08FFF4EAEAF4FF09E9E9E9E9E9E0F6000000FFE9E9E9E9E8F309FFFFFFFF09F3
          E8E9E9E9E9E9FF000000FF09E0E9E9E9E8EAF40909F4E9E8E9E9E9E9E009FF00
          0000FFFFF3E8E9E9E9E9E8E9E9E8E9E9E9E9E9E8F3FFFF000000FFFFF6EAE8E9
          E9E9E9E9E9E9E9E9E9E9E8EAF6FFFF000000FFFFFFF6F3E0E9E9E9E9E9E9E9E9
          E9E0F3F6FFFFFF000000FFFFFFFFFF09E9E0E8E8E9E8E8E0E909FFFFFFFFFF00
          0000FFFFFFFFFFFFFFF609F3F3F309F6FFFFFFFFFFFFFF000000}
        Stretch = True
        OnClick = bObjectNameClick
      end
      object eObjectMark: TEdit
        Left = 16
        Top = 34
        Width = 471
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object eObjectName: TEdit
        Left = 16
        Top = 114
        Width = 471
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        ExplicitWidth = 415
      end
    end
  end
  object bCreate: TButton
    Left = 20
    Top = 526
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 1
    OnClick = bCreateClick
  end
  object bClose: TButton
    Left = 377
    Top = 526
    Width = 137
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = bCloseClick
  end
  object cbGroup: TComboBox
    Left = 20
    Top = 379
    Width = 494
    Height = 25
    Style = csDropDownList
    TabOrder = 3
    OnChange = cbGroupChange
    OnDropDown = cbGroupDropDown
  end
  object mComment: TMemo
    Left = 20
    Top = 446
    Width = 494
    Height = 76
    TabOrder = 4
  end
  object cbLvl0: TComboBox
    Left = 20
    Top = 232
    Width = 235
    Height = 25
    Style = csDropDownList
    TabOrder = 5
    OnChange = cbLvl0Change
    OnDropDown = cbLvl0DropDown
    OnKeyUp = cbMarkKeyUp
  end
  object cbLvl1: TComboBox
    Left = 278
    Top = 232
    Width = 236
    Height = 25
    Style = csDropDownList
    TabOrder = 6
    OnChange = cbLvl1Change
    OnDropDown = cbLvl1DropDown
    OnKeyUp = cbMarkKeyUp
  end
  object cbLvl2: TComboBox
    Left = 20
    Top = 278
    Width = 494
    Height = 25
    Style = csDropDownList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnChange = cbLvl2Change
    OnDropDown = cbLvl2DropDown
    OnKeyUp = cbMarkKeyUp
  end
end
