object fAdminPanel: TfAdminPanel
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  ClientHeight = 201
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcAdminTabs: TPageControl
    Left = 0
    Top = 0
    Width = 684
    Height = 201
    ActivePage = tsLog
    Align = alClient
    TabOrder = 0
    object tsLog: TTabSheet
      Caption = #1051#1086#1075
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel2: TPanel
        Left = 0
        Top = 25
        Width = 40
        Height = 148
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          40
          148)
        object sbMailLog: TSpeedButton
          Left = 0
          Top = 0
          Width = 40
          Height = 40
          Hint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1083#1086#1075#1072' '#1085#1072' '#1084#1099#1083#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1080#1089#1090#1091
          Caption = ' '
          Flat = True
          Glyph.Data = {
            FE0A0000424DFE0A00000000000036000000280000001E0000001E0000000100
            180000000000C80A000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFF7878781C1C1C000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000001C1C
            1C787878FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFE3E3E30000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000E3E3E3FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000
            0000001616162121212020202020202020202020202020202020202020202020
            2020202020202020202020202021212116161600000000000000000000000000
            0000FFFFFFFFFFFF0000FFFFFF7878780000000000000000003D3D3DE8E8E8FF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E83D3D3D0000000000000000007878
            78FFFFFF0000FFFFFF1C1C1C0000000000003E3E3EFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3E3E3E0000000000001C1C1CFFFFFF
            0000FFFFFF000000000000000000E7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFE7E7E7000000000000000000FFFFFF0000FFFF
            FF000000000000161616FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF161616000000000000FFFFFF0000FFFFFF000000
            000000212121FFFFFFFFFFFFA1A1A1E1E1E19F9F9F0000000000000000000000
            000000000000000000000000000000000000000000000000009F9F9FE1E1E1A1
            A1A1FFFFFFFFFFFF212121000000000000FFFFFF0000FFFFFF00000000000020
            2020FFFFFFFFFFFF9C9C9C000000F9F9F9F5F5F5131313000000000000000000
            000000000000000000000000000000131313F5F5F5F9F9F90000009C9C9CFFFF
            FFFFFFFF202020000000000000FFFFFF0000FFFFFF000000000000202020FFFF
            FFFFFFFFA3A3A3000000000000EFEFEFFFFFFF58585800000000000000000000
            0000000000000000585858FFFFFFEEEEEE000000000000A3A3A3FFFFFFFFFFFF
            202020000000000000FFFFFF0000FFFFFF000000000000202020FFFFFFFFFFFF
            A3A3A3000000000000000000E7E7E7FFFFFFA3A3A3000000BDBDBDBDBDBD0000
            00A3A3A3FFFFFFE7E7E7000000000000000000A3A3A3FFFFFFFFFFFF20202000
            0000000000FFFFFF0000FFFFFF000000000000202020FFFFFFFFFFFFA3A3A300
            0000000000000000000000E4E4E4FFFFFFFBFBFBFFFFFFFFFFFFFBFBFBFFFFFF
            E4E4E4000000000000000000000000A3A3A3FFFFFFFFFFFF2020200000000000
            00FFFFFF0000FFFFFF000000000000202020FFFFFFFFFFFFA3A3A30000000000
            00000000000000000000FFFFFFFFFFFFF3F3F3F3F3F3FFFFFFFFFFFF00000000
            0000000000000000000000A3A3A3FFFFFFFFFFFF202020000000000000FFFFFF
            0000FFFFFF000000000000202020FFFFFFFFFFFFA3A3A3000000000000000000
            000000B2B2B2FFFFFFECECEC000000000000ECECECFFFFFFB2B2B20000000000
            00000000000000A3A3A3FFFFFFFFFFFF202020000000000000FFFFFF0000FFFF
            FF000000000000202020FFFFFFFFFFFFA3A3A3000000000000000000BBBBBBFF
            FFFFBABABA000000000000000000000000BABABAFFFFFFBBBBBB000000000000
            000000A3A3A3FFFFFFFFFFFF202020000000000000FFFFFF0000FFFFFF000000
            000000202020FFFFFFFFFFFFA3A3A3000000000000BDBDBDFFFFFF8484840000
            00000000000000000000000000000000848484FFFFFFBDBDBD000000000000A3
            A3A3FFFFFFFFFFFF202020000000000000FFFFFF0000FFFFFF00000000000020
            2020FFFFFFFFFFFFA0A0A0000000C0C0C0FFFFFF525252000000000000000000
            000000000000000000000000000000525252FFFFFFC0C0C0000000A0A0A0FFFF
            FFFFFFFF202020000000000000FFFFFF0000FFFFFF000000000000202020FFFF
            FFFFFFFF949494AEAEAEFFFFFF24242400000000000000000000000000000000
            0000000000000000000000000000242424FFFFFFAEAEAE949494FFFFFFFFFFFF
            202020000000000000FFFFFF0000FFFFFF000000000000202020FFFFFFFFFFFF
            FFFFFFE2E2E20000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000E2E2E2FFFFFFFFFFFFFFFFFF20202000
            0000000000FFFFFF0000FFFFFF000000000000202020FFFFFFFFFFFFFBFBFB5B
            5B5B6363636A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A
            6A6A6A6A6A6A6A6A6A6363635B5B5BFBFBFBFFFFFFFFFFFF2020200000000000
            00FFFFFF0000FFFFFF000000000000212121FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF212121000000000000FFFFFF
            0000FFFFFF000000000000161616FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF161616000000000000FFFFFF0000FFFF
            FF000000000000000000E7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFE7E7E7000000000000000000FFFFFF0000FFFFFF1C1C1C
            0000000000003E3E3EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF3E3E3E0000000000001C1C1CFFFFFF0000FFFFFF78787800000000
            00000000003E3E3EE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E83E3E
            3E000000000000000000787878FFFFFF0000FFFFFFFFFFFF0000000000000000
            0000000000000016161621212120202020202020202020202020202020202020
            2020202020202020202020202020202020212121161616000000000000000000
            000000000000FFFFFFFFFFFF0000FFFFFFFFFFFFE3E3E3000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000000000000E3
            E3E3FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFF7878781C1C1C00000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000001C1C1C787878FFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            0000}
          Margin = 5
          ParentShowHint = False
          ShowHint = True
          OnClick = sbMailLogClick
        end
        object sbClearLog: TSpeedButton
          Left = 0
          Top = 108
          Width = 40
          Height = 40
          Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1083#1086#1075
          Anchors = [akLeft, akBottom]
          Caption = ' '
          Flat = True
          Glyph.Data = {
            FE0A0000424DFE0A00000000000036000000280000001E0000001E0000000100
            180000000000C80A000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF6666660000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000066
            6666FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF151515000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000151515FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF08080800000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000080808FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            000000000000000000727272E4E4E4090909000000000000B1B1B1B1B1B10000
            00000000090909E4E4E4727272000000000000000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
            0000000000E7E7E7FFFFFF303030000000000000FFFFFFFFFFFF000000000000
            303030FFFFFFE7E7E7000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F60000000000000000
            00F9F9F9FFFFFF161616000000000000FFFFFFFFFFFF000000000000161616FF
            FFFFF9F9F9000000000000000000F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCDCDC000000000000000000FFFFFF
            FFFFFF000000000000000000FFFFFFFFFFFF000000000000000000FFFFFFFFFF
            FF000000000000000000DCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFBABABA000000000000000000FFFFFFF6F6F600
            0000000000000000FFFFFFFFFFFF000000000000000000F6F6F6FFFFFF000000
            000000000000BABABAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF9F9F9F0000000000000F0F0FFFFFFFE6E6E60000000000
            00000000FFFFFFFFFFFF000000000000000000E6E6E6FFFFFF0F0F0F00000000
            00009F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF808080000000000000222222FFFFFFD1D1D1000000000000000000
            FFFFFFFFFFFF000000000000000000D1D1D1FFFFFF2222220000000000008080
            80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF6161610000000000003B3B3BFFFFFFBBBBBB000000000000000000FFFFFFFF
            FFFF000000000000000000BBBBBBFFFFFF3B3B3B000000000000616161FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF494949
            000000000000585858FFFFFFA5A5A5000000000000000000FFFFFFFFFFFF0000
            00000000000000A5A5A5FFFFFF585858000000000000494949FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF34343400000000
            00007D7D7DFFFFFF898989000000000000000000FFFFFFFFFFFF000000000000
            000000898989FFFFFF7D7D7D000000000000343434FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF222222000000000000A4A4
            A4FFFFFF6A6A6A000000000000000000FFFFFFFFFFFF0000000000000000006A
            6A6AFFFFFFA4A4A4000000000000222222FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF141414000000000000C5C5C5FFFFFF
            454545000000000000000000FFFFFFFFFFFF000000000000000000454545FFFF
            FFC5C5C5000000000000141414FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF030303000000000000DCDCDCFFFFFF1D1D1D00
            0000000000000000FFFFFFFFFFFF0000000000000000001D1D1DFFFFFFDCDCDC
            000000000000030303FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
            FFFFFFFFFFFFFEFEFE000000000000000000F2F2F2FFFFFF0707070000000000
            00000000FFFFFFFFFFFF000000000000000000070707FFFFFFF2F2F200000000
            0000000000FEFEFEFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFF0F0F0000000000000000000EFEFEFFFFFFF000000000000000000000000
            F9F9F9F9F9F9000000000000000000000000FFFFFFEFEFEF0000000000000000
            00F0F0F0FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFD3D3
            D300000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000D3D3D3
            FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFAEAEAE000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000AEAEAEFFFFFFFF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFA9A9A900000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000A9A9A9FFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9D9D1D1D1D3D3D3D3D3
            D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3
            D3D3D3D3D3D3D3D3D3D3D3D1D1D1D9D9D9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
            FFFFFFFFFFFFFFFFFFFFEFEFEF2B2B2B23232325252525252525252525252525
            2525252525252525252525252525252525252525252525252525252525252525
            2525252323232B2B2BEFEFEFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
            FFFFFFFFFFFFA3A3A30000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000A3A3A3FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF010101000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000101
            01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFC3C3C300000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000C3C3C3FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            D5D5D52E2E2E0000000000000000000000000000000000000000000000000000
            000000000000000000000000000000002E2E2ED5D5D5FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFF7F7F7DEDEDEE1E1E1E0E0E0000000000000000000000000000000000000
            E0E0E0E1E1E1DEDEDEF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            0000}
          Margin = 5
          ParentShowHint = False
          ShowHint = True
          OnClick = sbClearLogClick
          ExplicitTop = 271
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 676
        Height = 25
        Align = alTop
        TabOrder = 1
        DesignSize = (
          676
          25)
        object Label1: TLabel
          Left = 2
          Top = 6
          Width = 71
          Height = 13
          Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
        end
        object lProcName: TLabel
          Left = 74
          Top = 6
          Width = 498
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          ExplicitWidth = 699
        end
        object sbSQLFilter: TSpeedButton
          Tag = 3
          Left = 651
          Top = 1
          Width = 22
          Height = 22
          Hint = #1047#1072#1087#1088#1086#1089#1099
          AllowAllUp = True
          Anchors = [akTop, akRight]
          GroupIndex = 4
          Down = True
          Glyph.Data = {
            C6040000424DC60400000000000036040000280000000C0000000C0000000100
            0800000000009000000000000000000000000001000000000000000000000000
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
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFD2D2D2D2D2
            D2D2D2D2D2FFD2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
            D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
            D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
            D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2FFD2
            D2D2D2D2D2D2D2D2D2FF}
          ParentShowHint = False
          ShowHint = True
          OnClick = sbCommonFilterClick
          ExplicitLeft = 839
        end
        object sbErrorFilter: TSpeedButton
          Tag = 2
          Left = 629
          Top = 1
          Width = 22
          Height = 22
          Hint = #1054#1096#1080#1073#1082#1080
          AllowAllUp = True
          Anchors = [akTop, akRight]
          GroupIndex = 3
          Down = True
          Glyph.Data = {
            C6040000424DC60400000000000036040000280000000C0000000C0000000100
            0800000000009000000000000000000000000001000000000000000000000000
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
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF4F4F4F4F4F
            4F4F4F4F4FFF4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F
            4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F
            4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F
            4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4FFF4F
            4F4F4F4F4F4F4F4F4FFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = sbCommonFilterClick
          ExplicitLeft = 817
        end
        object sbCommonFilter: TSpeedButton
          Left = 585
          Top = 1
          Width = 22
          Height = 22
          Hint = #1054#1073#1099#1095#1085#1085#1099#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
          AllowAllUp = True
          Anchors = [akTop, akRight]
          GroupIndex = 1
          Down = True
          Glyph.Data = {
            C6040000424DC60400000000000036040000280000000C0000000C0000000100
            0800000000009000000000000000000000000001000000000000000000000000
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
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            0000000000FF0000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            000000000000000000FF}
          ParentShowHint = False
          ShowHint = True
          OnClick = sbCommonFilterClick
          ExplicitLeft = 773
        end
        object sbWarningFilter: TSpeedButton
          Tag = 1
          Left = 607
          Top = 1
          Width = 22
          Height = 22
          Hint = #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103
          AllowAllUp = True
          Anchors = [akTop, akRight]
          GroupIndex = 2
          Down = True
          Glyph.Data = {
            C6040000424DC60400000000000036040000280000000C0000000C0000000100
            0800000000009000000000000000000000000001000000000000000000000000
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
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF6767676767
            6767676767FF6767676767676767676767676767676767676767676767676767
            6767676767676767676767676767676767676767676767676767676767676767
            6767676767676767676767676767676767676767676767676767676767676767
            676767676767676767676767676767676767676767676767676767676767FF67
            676767676767676767FF}
          ParentShowHint = False
          ShowHint = True
          OnClick = sbCommonFilterClick
          ExplicitLeft = 795
        end
      end
      object lbLog: TListBox
        Left = 40
        Top = 25
        Width = 636
        Height = 148
        Style = lbOwnerDrawFixed
        Align = alClient
        TabOrder = 2
        OnClick = lbLogClick
        OnDrawItem = lbLogDrawItem
      end
    end
    object tsDetail: TTabSheet
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object mDetail: TMemo
        Left = 0
        Top = 0
        Width = 676
        Height = 173
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 644
    Top = 56
  end
end
