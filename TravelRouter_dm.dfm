object dmTravelRouter: TdmTravelRouter
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 415
  Width = 292
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
    CursorType = ctStatic
    TableName = 'Users'
    Left = 152
    Top = 56
  end
  object tblBookings: TADOTable
    Connection = connTravelRouterDB
    TableName = 'Bookings'
    Left = 152
    Top = 152
  end
  object tblAccomodation: TADOTable
    Connection = connTravelRouterDB
    TableName = 'Accomodation'
    Left = 152
    Top = 248
  end
  object tblTrips: TADOTable
    Connection = connTravelRouterDB
    TableName = 'Trips'
    Left = 152
    Top = 328
  end
end
