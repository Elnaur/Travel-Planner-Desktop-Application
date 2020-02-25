program TravelPlanner_p;

uses
  Vcl.Forms,
  LoginSignup_u in 'LoginSignup_u.pas' {frmLoginSignup};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLoginSignup, frmLoginSignup);
  Application.Run;
end.
