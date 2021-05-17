object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 407
  Width = 601
  object ADOConnection: TADOConnection
    CommandTimeout = 0
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=H6v92InV;Persist Security Info=True' +
      ';User ID=UserProgNFT;Initial Catalog=nft_TU;Data Source=server-h' +
      'tm'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 24
    Top = 22
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 24
    Top = 78
  end
  object spGroups: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_GROUPS;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@HEAD_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 88
    Top = 16
  end
  object spMarshrut: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_MARSHRUT;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@HEAD_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 504
    Top = 16
  end
  object spTonnag: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_TONNAG;1'
    Parameters = <>
    Left = 368
    Top = 16
  end
  object spCity: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_CITY;1'
    Parameters = <>
    Left = 232
    Top = 16
  end
  object spCityPresent: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_PRESENT_CITY;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 100
        Value = Null
      end
      item
        Name = '@tt_id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 232
    Top = 64
  end
  object spSaveCityAlternate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'TT_SAVE_ALTERNATE;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@city'
        Attributes = [paNullable]
        DataType = ftString
        Size = 50
        Value = Null
      end
      item
        Name = '@alt_city'
        Attributes = [paNullable]
        DataType = ftString
        Size = 200
        Value = Null
      end
      item
        Name = '@alt_code'
        Attributes = [paNullable]
        DataType = ftString
        Size = 50
        Value = Null
      end
      item
        Name = '@tt_head_id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 232
    Top = 160
  end
  object spCityAlternate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_ALTERNATE;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@tt_head_id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 232
    Top = 112
  end
  object spPostav: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'GET_TT_POSTAV;1'
    Parameters = <>
    Left = 160
    Top = 16
  end
  object tTonnagAlternate: TADOTable
    Connection = ADOConnection
    TableName = 'TT_TONNAG_ALTERNATE'
    Left = 368
    Top = 64
  end
  object spSaveTonnagAlternate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'TT_SAVE_TONNAG_ALTERNATE;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@tonnag'
        Attributes = [paNullable]
        DataType = ftString
        Size = 100
        Value = Null
      end
      item
        Name = '@tonnag_id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 368
    Top = 112
  end
  object spCreateMarshrut: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'INS_TT_MARSHRUT_EXT;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@TT_HEAD_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@TT_GR_INDEX'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@CITY1'
        Attributes = [paNullable]
        DataType = ftString
        Size = 255
        Value = Null
      end
      item
        Name = '@CITY2'
        Attributes = [paNullable]
        DataType = ftString
        Size = 255
        Value = Null
      end>
    Left = 504
    Top = 64
  end
  object spInsertData: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'INS_TT_DATA_EXT;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@TT_MARSHRUT_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@TONNAG_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@POSTAV_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PRICE'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end>
    Left = 64
    Top = 264
  end
  object spInsertOtklon: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'INS_TT_OTKLON_EXT;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@TT_GROUPS_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@TONNAG_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@POSTAV_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@PRICE_1KM'
        Attributes = [paNullable]
        DataType = ftFloat
        Precision = 15
        Value = Null
      end>
    Left = 64
    Top = 168
  end
  object spClearData: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'CLEAR_TT_DATA;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@HEAD_ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 64
    Top = 216
  end
  object spDelCityAlternate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'TT_DEL_CITY_ALTERNATE;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
      end
      item
        Name = '@HEAD_TT'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@ID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end>
    Left = 232
    Top = 216
  end
end
