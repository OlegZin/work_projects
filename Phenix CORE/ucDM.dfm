object dm: Tdm
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ADOConnection: TADOConnection
    CommandTimeout = 300
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=nft;Data Source=server-htm;Use Procedur' +
      'e for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation' +
      ' ID=AVT_VALUEV;Use Encryption for Data=False;Tag with column col' +
      'lation when possible=False;'
    ConnectionTimeout = 60
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 32
    Top = 8
  end
end
