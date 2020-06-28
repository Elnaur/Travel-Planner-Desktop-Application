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

function ChecksumLuhnValid(argInput: string): boolean;
function isValidEmail(argEmail: string): integer;
function isValidPhoneNo(argTelephone: string): boolean;
function isValidIDNo(argIDno: string): boolean;
function FileSize(const aFilename: String): Int64;
// https://www.generacodice.com/en/articolo/119049/Getting-size-of-a-file-in-Delphi-2010-or-later

var
  frmLoginSignup: TfrmLoginSignup;
  User: TUser;
  rememberFilePath: string;
  isGuest: boolean = True;

implementation

uses Mainmenu_u, encryption_u;

{$R *.dfm}

function FileSize(const aFilename: String): Int64;
var
  info: TWin32FileAttributeData;
begin
  result := -1;

  if NOT GetFileAttributesEx(PWideChar(aFilename), GetFileExInfoStandard, @info)
  then
    EXIT;

  result := Int64(info.nFileSizeLow) or Int64(info.nFileSizeHigh shl 32);
end;

function ChecksumLuhnValid(argInput: string): boolean;
var
  iSum, i: integer;
  iDigit: integer;
  cDigit: integer;
  iParity: integer;
begin
  for i := 1 to cDigit - 1 do
  begin
    iDigit := StrToInt(argInput[i]);
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

function isValidIDNo(argIDno: string): boolean; // uses the Luhn algorithm
begin
  result := ChecksumLuhnValid(argIDno);
end;

function isValidPhoneNo(argTelephone: string): boolean;
begin
  if length(argTelephone) <> 10 then
    result := False
  else
    result := True;
end;

function isValidEmail(argEmail: string): integer;
var
  iCountAt: integer;
  bHasPeriod: boolean;
  i: integer;
begin
  with dmTravelRouter do
  begin
    tblUsers.Open;
    tblUsers.First;
    while not tblUsers.Eof do
    begin
      if argEmail = tblUsers['Email'] then
      begin
        result := 1; // Email already in use
        EXIT;
      end;
      tblUsers.Next;
    end;
    tblUsers.Close;
  end;

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
      result := 2;
      EXIT;
    end;
  end;

  if (iCountAt = 1) and (bHasPeriod = True) then
    result := 0 // Valid email
  else
    result := 2; // Invalid email format
end;

procedure TfrmLoginSignup.FormCreate(Sender: TObject);
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

  // Place form in exact centre of your screen, excluding the taskbar for measurement.
  left := (Screen.WorkAreaWidth div 2) - (frmLoginSignup.Width div 2);
  top := (Screen.WorkAreaHeight div 2) - (frmLoginSignup.Height div 2);
end;

procedure TfrmLoginSignup.FormShow(Sender: TObject);
var
  fRemember: textfile;
  sEmail, sPassword: string;
begin
  pcLoginSignup.ActivePage := tsLogin;

  pnlLLogin.left := (pcLoginSignup.Width - pnlLLogin.Width) div 2;
  pnlLToSignup.left := (pcLoginSignup.Width - pnlLToSignup.Width) div 2;

  pnlSSignUp.left := (pcLoginSignup.Width - pnlSSignUp.Width) div 2;
  pnlSToLogin.left := (pcLoginSignup.Width - pnlSToLogin.Width) div 2;

  lblLGuest.left := (pcLoginSignup.Width - lblLGuest.Width) div 2;

  rememberFilePath := copy(GetCurrentDir, 1, length(GetCurrentDir) - 11) +
    'media\text\remember_me.txt';

  AssignFile(fRemember, rememberFilePath);
  if FileSize(rememberFilePath) > 0 then
  begin
    Reset(fRemember);
    Readln(fRemember, sEmail);
    Readln(fRemember, sPassword);
    CloseFile(fRemember);

    edtLEmail.Text := DecryptStr(sEmail, Key);
    edtLPassword.Text := DecryptStr(sPassword, Key);
  end;

end;

procedure TfrmLoginSignup.lblLGuestClick(Sender: TObject);
begin
  isGuest := True;
  frmMainMenu.Show;
  frmLoginSignup.Hide;

  with frmMainMenu do
  begin
    pnlPlanTrip.Color := clSelected;
    pnlPlanTrip.BevelInner := bvLowered;

    pnlCurrentTrip.Color := clBase;
    pnlCurrentTrip.BevelInner := bvNone;

    imgSettings.Picture.LoadFromFile(copy(GetCurrentDir, 1,
      length(GetCurrentDir) - 11) + '/media/images/whitesettings.png');
    Refresh;

    pcMainmenu.ActivePage := tsPlanTrip;
  end;

end;

procedure TfrmLoginSignup.pnlLLoginClick(Sender: TObject);
var
  bFound: boolean;
  fRemember: textfile;
begin
  bFound := False;

  with dmTravelRouter do
  begin
    tblUsers.Open;
    tblUsers.First;
    while not tblUsers.Eof do
    begin
      if tblUsers['Email'] = edtLEmail.Text then
      // check if email is registered
      begin
        if DecryptStr(tblUsers['Password'], Key) = edtLPassword.Text then
        // check if the email and password match
        begin
          bFound := True;
          isGuest := False;

          User := TUser.Create(tblUsers['First Name'], tblUsers['Surname'],
            tblUsers['Email'], tblUsers['Phone No'], tblUsers['ID No'],
            DecryptStr(tblUsers['Password'], Key)); // Initiate TUser object
          User.ID := tblUsers['ID'];

          if cbLRemember.Checked = True then    // TEXT FILE
          begin
            AssignFile(fRemember, rememberFilePath);
            Rewrite(fRemember);
            Writeln(fRemember, EncryptStr(User.Email, Key));
            Writeln(fRemember, EncryptStr(User.Password, Key));
            CloseFile(fRemember);
          end;

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
  fRemember: textfile;
begin
  bValid := True;

  if edtSPassword.Text <> edtSRePassword.Text then
  begin
    Showmessage('Passwords must match.');
    bValid := False;
  end;

  if isValidEmail(edtSEmail.Text) = 1 then
  begin
    Showmessage('Email address already in use.');
    bValid := False;
  end
  else if isValidEmail(edtSEmail.Text) = 2 then
  begin
    Showmessage('Invalid email adress.');
    bValid := False;
  end;

  if not isValidPhoneNo(edtSPhoneNo.Text) then
  begin
    Showmessage('Invalid phone number.');
    bValid := False;
  end;

  if not isValidIDNo(edtSIDno.Text) then
  begin
    Showmessage('Invalid ID number.');
    bValid := False;
  end;

  if bValid = True then
  begin
    // Initialising User object
    User := TUser.Create(edtSFirstName.Text, edtSSurname.Text, edtSEmail.Text,
      edtSPhoneNo.Text, edtSIDno.Text, edtSPassword.Text);
    User.AddToDB;
    frmMainMenu.Show;
    Hide;

    // Writing encrypted login details to a textfile to be retrieved on start up
    if cbSRemember.Checked = True then
    begin
      AssignFile(fRemember, rememberFilePath);
      Rewrite(fRemember);
      Writeln(fRemember, EncryptStr(User.Email, Key));
      Writeln(fRemember, EncryptStr(User.Password, Key));
      CloseFile(fRemember);
    end;

    isGuest := False;
  end;

end;

procedure TfrmLoginSignup.pnlSToLoginClick(Sender: TObject);
begin
  pcLoginSignup.ActivePage := tsLogin;
end;

end.
