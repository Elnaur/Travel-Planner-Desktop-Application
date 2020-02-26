program TravelPlanner_p;

uses
  Vcl.Forms,
  LoginSignup_u in 'LoginSignup_u.pas' {frmLoginSignup},
  Mainmenu_u in 'Mainmenu_u.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLoginSignup, frmLoginSignup);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
