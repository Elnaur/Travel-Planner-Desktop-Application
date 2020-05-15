unit user_cls;

interface

uses
  SysUtils, TravelRouter_dm, encryption_u;

type
  TUser = class
  private
    fFirstName: string;
    fSurname: string;
    fDoB: TDateTime;
    fGender: Char;
    fEmail: string;
    fPhoneNo: string;
    fIDNo: string;
    fPassword: string;

  public
    property FirstName: string read fFirstName write fFirstName;
    property Surname: string read fSurname write fSurname;
    property Email: string read fEmail write fEmail;
    property Password: string read fPassword write fPassword;

    constructor Create(argFirstName, argSurname, argEmail, argPhoneNo, argIDno,
      argPassword: string);

    procedure AddToDB;
    procedure UpdateDB;
  end;

const
  Key = 2321;

implementation

{ TUser }

procedure TUser.AddToDB;
begin
  with dmTravelRouter do
  begin
    tblUsers.Open;
    tblUsers.Append;
    tblUsers['First Name'] := fFirstName;
    tblUsers['Surname'] := fSurname;
    // Uses encryption module
    tblUsers['Password'] := EncryptStr(fPassword, Key);
    tblUsers['Email'] := fEmail;
    tblUsers['Phone No'] := fPhoneNo;
    tblUsers['Birthdate'] := fDoB;
    tblUsers['ID No'] := fIDNo;
    tblUsers['Gender'] := fGender;
    tblUsers.Post;
    tblUsers.Close;
  end;
end;

constructor TUser.Create(argFirstName, argSurname, argEmail, argPhoneNo,
  argIDno, argPassword: string);
begin
  fFirstName := argFirstName;
  fSurname := argSurname;

  if StrToInt(copy(argIDno, 1, 2)) < StrToInt(copy(DateToStr(Now), 9, 2)) then
  // Born between the start of this century and this current year
  begin
    fDoB := StrToDate(copy(argIDno, 5, 2) + '/' + copy(argIDno, 3, 2) + '/' +
      copy(DateToStr(Now), 9, 2) + copy(argIDno, 1, 2));
  end
  else
  begin
    fDoB := StrToDate(copy(argIDno, 5, 2) + '/' + copy(argIDno, 3, 2) + '/' +
      IntToStr(StrToInt(copy(DateToStr(Now), 9, 2)) - 1) + copy(argIDno, 1, 2));
  end;

  if StrToInt(copy(argIDno, 7, 4)) < 5000 then
  begin
    fGender := 'F';
  end
  else
    fGender := 'M';

  fPhoneNo := argPhoneNo;
  fIDNo := argIDno;
  fPassword := argPassword;
  fEmail := argEmail;

end;

procedure TUser.UpdateDB;
begin
  with dmTravelRouter do
  begin
    tblUsers.Open;
    tblUsers.First;
    while not tblUsers.Eof do
    begin
      if tblUsers['Email'] = fEmail then
      begin
        tblUsers.Edit;
        tblUsers['First Name'] := fFirstName;
        tblUsers['Surname'] := fSurname;
        // Uses encryption module
        tblUsers['Password'] := EncryptStr(fPassword, Key);
        tblUsers['Email'] := fEmail;
        tblUsers['Phone No'] := fPhoneNo;
        tblUsers['Birthdate'] := fDoB;
        tblUsers['ID No'] := fIDNo;
        tblUsers['Gender'] := fGender;
        tblUsers.Post;
        tblUsers.Close;
        break;
      end;
    end;
  end;
end;

end.
