unit LoginSignup_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, user_cls,
  TravelRouter_dm;

type
  TfrmLoginSignup = class(TForm)
    pcLoginSignup: TPageControl;
    tsLogin: TTabSheet;
    tsSignup: TTabSheet;
    edtLEmail: TEdit;
    edtLPassword: TEdit;
    lblLEmail: TLabel;
    lblLPassword: TLabel;
    cbLRemember: TCheckBox;
    lblSFirstName: TLabel;
    edtSFirstName: TEdit;
    edtSPassword: TEdit;
    lblSPassword: TLabel;
    cbSRemember: TCheckBox;
    edtSEmail: TEdit;
    lblSEmail: TLabel;
    edtSPhoneNo: TEdit;
    lblPhoneNo: TLabel;
    edtSRePassword: TEdit;
    lblSRePassword: TLabel;
    pnlLLogin: TPanel;
    pnlSSignUp: TPanel;
    lblSIDno: TLabel;
    pnlSToLogin: TPanel;
    pnlLToSignup: TPanel;
    imgSBackground: TImage;
    imgLBackground: TImage;
    lblLHeading1: TLabel;
    lblLHeading2: TLabel;
    lblLTagline1: TLabel;
    lblLTagline2: TLabel;
    imgLLogo: TImage;
    lblLGuest: TLabel;
    lblSSurname: TLabel;
    edtSSurname: TEdit;
    edtSIDno: TEdit;
    procedure FormShow(Sender: TObject);
    procedure pnlLToSignupClick(Sender: TObject);
    procedure pnlSToLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblLGuestClick(Sender: TObject);
    procedure pnlSSignUpClick(Sender: TObject);
    procedure pnlLLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function isValidEmail(argEmail: string): boolean;
function isValidTelephoneNo(argTelephone: string): boolean;
function isValidIDNo(argIDno: string): boolean;

var
  frmLoginSignup: TfrmLoginSignup;
  User: TUser;

implementation

uses Mainmenu_u, encryption_u;

{$R *.dfm}

function isValidIDNo(argIDno: string): boolean; // uses the Luhn algorithm
var
  iSum, i: integer;
  iDigit: integer;
  cDigit: integer;
  iParity: integer;
begin
  iSum := StrToInt(argIDno[length(argIDno)]);
  cDigit := length(argIDno);
  iParity := cDigit mod 2;

  for i := 1 to cDigit - 1 do
  begin
    iDigit := StrToInt(argIDno[i]);
    if (i - 1) mod 2 = iParity then
      iDigit := iDigit * 2;
    if iDigit > 9 then
      iDigit := iDigit - 9;
    iSum := iSum + iDigit;
  end;

  if iSum mod 10 = 0 then
    result := True
  else
    result := False;
end;

function isValidTelephoneNo(argTelephone: string): boolean;
begin
  if length(argTelephone) <> 10 then
    result := False
  else
    result := True;
end;

function isValidEmail(argEmail: string): boolean;
var
  iCountAt: integer;
  bHasPeriod: boolean;
  i: integer;
begin
  bHasPeriod := False;
  iCountAt := 0;

  for i := 1 to length(argEmail) do
  begin
    if argEmail[i] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '@', '.', '_',
      '-', '+'] then
    // Checks if characters in given email adress are valid in email adresses
    begin
      if argEmail[i] = '@' then
      begin
        inc(iCountAt);
        // Count the amount of '@' signs because a valid email adress is supposed to only have one
      end
      else if argEmail[i] = '.' then
      begin
        bHasPeriod := True;
        // Check if there is a '.' in the email adress, because valid email adress will have at least one '.'
      end;
    end
    else
    begin
      result := False;
      exit;
    end;
  end;

  if (iCountAt = 1) and (bHasPeriod = True) then
    result := True
  else
    result := False;
end;

procedure TfrmLoginSignup.FormCreate(Sender: TObject);
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

  // Place form in exact centre of your screen, excluding the taskbar for measurement.
  left := (Screen.WorkAreaWidth div 2) - (frmLoginSignup.Width div 2);
  top := (Screen.WorkAreaHeight div 2) - (frmLoginSignup.Height div 2);
end;

procedure TfrmLoginSignup.FormShow(Sender: TObject);
begin
  pcLoginSignup.ActivePage := tsLogin;

  pnlLLogin.left := (pcLoginSignup.Width - pnlLLogin.Width) div 2;
  pnlLToSignup.left := (pcLoginSignup.Width - pnlLToSignup.Width) div 2;

  pnlSSignUp.left := (pcLoginSignup.Width - pnlSSignUp.Width) div 2;
  pnlSToLogin.left := (pcLoginSignup.Width - pnlSToLogin.Width) div 2;

  lblLGuest.left := (pcLoginSignup.Width - lblLGuest.Width) div 2;
end;

procedure TfrmLoginSignup.lblLGuestClick(Sender: TObject);
begin
  frmMainMenu.Show;
  frmLoginSignup.Hide;
end;

procedure TfrmLoginSignup.pnlLLoginClick(Sender: TObject);
var
  bFound: boolean;
begin
  bFound := False;

  with dmTravelRouter do
  begin
    tblUsers.Open;
    tblUsers.First;
    while not tblUsers.Eof do
    begin
      if tblUsers['Email'] = edtLEmail.Text then // check if email is registered
      begin
        if DecryptStr(tblUsers['Password'], Key) = edtLPassword.Text then
        // check if the email and password match
        begin
          bFound := True;
          User := TUser.Create(tblUsers['First Name'], tblUsers['Surname'],
            tblUsers['Email'], tblUsers['Phone No'], tblUsers['ID No'],
            EncryptStr(tblUsers['Password'], Key)); // Initiate TUser object
          frmMainMenu.Show;
          Hide;
          break;
        end;
      end;
      tblUsers.Next;
    end;
    if bFound = False then
      Showmessage('Incorrect password or email.');
    tblUsers.Close;
  end;
end;

procedure TfrmLoginSignup.pnlLToSignupClick(Sender: TObject);
begin
  pcLoginSignup.ActivePage := tsSignup;
end;

procedure TfrmLoginSignup.pnlSSignUpClick(Sender: TObject);
var
  bValid: boolean;
begin
  bValid := True;

  if not isValidEmail(edtSEmail.Text) then
  begin
    Showmessage('Invalid email adress.');
    bValid := False;
  end;

  if not isValidTelephoneNo(edtSPhoneNo.Text) then
  begin
    Showmessage('Invalid telephone number.');
    bValid := False;
  end;

  if not isValidIDNo(edtSIDno.Text) then
  begin
    Showmessage('Invalid ID number.');
    bValid := False;
  end;

  with dmTravelRouter do
  begin
    tblUsers.Open;
    tblUsers.First;
    while not tblUsers.Eof do
    begin
      if edtSEmail.Text = tblUsers['Email'] then
      begin
        bValid := False;
        Showmessage('Email already in use.');
        break;
      end;
      tblUsers.Next;
    end;
    tblUsers.Close;

    if bValid = True then
    begin
      User := TUser.Create(edtSFirstName.Text, edtSSurname.Text, edtSEmail.Text,
        edtSPhoneNo.Text, edtSIDno.Text, edtSPassword.Text);
      User.AddToDB;
      frmMainMenu.Show;
      Hide;
    end;
  end;

end;

procedure TfrmLoginSignup.pnlSToLoginClick(Sender: TObject);
begin
  pcLoginSignup.ActivePage := tsLogin;
end;

end.
