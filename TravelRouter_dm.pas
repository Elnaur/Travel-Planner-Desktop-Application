unit TravelRouter_dm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmTravelRouter = class(TDataModule)
    connTravelRouterDB: TADOConnection;
    tblUsers: TADOTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTravelRouter: TdmTravelRouter;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TdmTravelRouter.DataModuleCreate(Sender: TObject);
begin
  connTravelRouterDB.Connected := False;
  connTravelRouterDB.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + copy(GetCurrentDir, 1, length(GetCurrentDir) - 11) +
    '\database\dbTravelRouter.mdb;Persist Security Info=False';
  connTravelRouterDB.Connected := True;
  tblUsers.Active := True;
end;

end.
