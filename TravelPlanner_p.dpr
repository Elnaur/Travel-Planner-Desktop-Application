program TravelPlanner_p;

uses
  Vcl.Forms,
  LoginSignup_u in 'LoginSignup_u.pas' {frmLoginSignup},
  Mainmenu_u in 'Mainmenu_u.pas' {frmMainMenu},
  user_cls in 'user_cls.pas',
  TravelRouter_dm in 'TravelRouter_dm.pas' {dmTravelRouter: TDataModule},
  ViewTrip_u in 'ViewTrip_u.pas' {frmViewTrip};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLoginSignup, frmLoginSignup);
  Application.CreateForm(TfrmMainMenu, frmMainMenu);
  Application.CreateForm(TdmTravelRouter, dmTravelRouter);
  Application.CreateForm(TfrmViewTrip, frmViewTrip);
  Application.Run;
end.
