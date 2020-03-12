object dmTravelRouter: TdmTravelRouter
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 262
  Width = 338
  object connTravelRouterDB: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\Nicole\Doc' +
      'uments\High School PHA\Gr 12 WK 2020\IT - Mr W Theron\IT PAT Gr ' +
      '12 2020\Desktop application\database\dbTravelRouter.mdb;Persist ' +
      'Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 112
  end
  object tblUsers: TADOTable
    Connection = connTravelRouterDB
    TableName = 'Users'
    Left = 168
    Top = 48
  end
end
