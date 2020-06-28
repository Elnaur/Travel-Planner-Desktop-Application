unit Mainmenu_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils,
  System.Variants,
  System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
  Data.Win.ADODB, REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.Grids, Vcl.DBGrids, IdHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, JSON, DateUtils, IdSSLOpenSSLHeaders, Data.DB;

type
  TfrmMainMenu = class(TForm)
    imgBackground: TImage;
    pcMainmenu: TPageControl;
    pnlCurrentTrip: TPanel;
    pnlPlanTrip: TPanel;
    tsCurrentTrip: TTabSheet;
    tsPlanTrip: TTabSheet;
    pnlTabHolder: TPanel;
    imCTBackground: TImage;
    imgPTBackground: TImage;
    tsSettings: TTabSheet;
    imgSBackground: TImage;
    lblInput: TLabel;
    imgAccomodation1: TImage;
    imgAccomodation2: TImage;
    imgAccomodation3: TImage;
    rbSelect1: TRadioButton;
    rbSelect2: TRadioButton;
    rbSelect3: TRadioButton;
    lblLHeading2: TLabel;
    lblLHeading1: TLabel;
    imgLLogo: TImage;
    lblAdults: TLabel;
    lblChildren: TLabel;
    pnlAdd: TPanel;
    pnlViewPlanned: TPanel;
    pnlFinalise: TPanel;
    lblTopMatches: TLabel;
    speAdults: TSpinEdit;
    speChildren: TSpinEdit;
    dtpArrive: TDateTimePicker;
    dtpLeave: TDateTimePicker;
    lblLeave: TLabel;
    lblArrive: TLabel;
    imgSettings: TImage;
    edtName: TEdit;
    lblName: TLabel;
    lblCost: TLabel;
    lblSetSurname: TLabel;
    lblSetEmail: TLabel;
    lblSetPhone: TLabel;
    lblPassword: TLabel;
    lblSetPassword: TLabel;
    lblRePassword: TLabel;
    lblSetName: TLabel;
    edtSetName: TEdit;
    edtSetSurname: TEdit;
    edtSetEmail: TEdit;
    edtSetPhone: TEdit;
    edtPassword: TEdit;
    edtSetPassword: TEdit;
    edtRePassword: TEdit;
    redAccomodation1: TRichEdit;
    redAccomodation2: TRichEdit;
    redAccomodation3: TRichEdit;
    pnlSearch: TPanel;
    pnlSavePassword: TPanel;
    pnlChangePassword: TPanel;
    pnlSaveSettings: TPanel;
    dbgTrips: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    lblHeading2: TLabel;
    lblHeading1: TLabel;
    imgLogo: TImage;
    cbTripName: TComboBox;
    pnlNewTrip: TPanel;
    lblTripName: TLabel;
    lblID: TLabel;
    lblBirthday: TLabel;
    lblGender: TLabel;
    lblUserBirthday: TLabel;
    lblUserID: TLabel;
    lblUserGender: TLabel;
    imgViewAccomodation: TImage;
    redAccomodation_view: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlCurrentTripClick(Sender: TObject);
    procedure pnlPlanTripClick(Sender: TObject);
    procedure imgSettingsClick(Sender: TObject);
    procedure pnlSearchClick(Sender: TObject);

    procedure edtInput(Sender: TObject);
    procedure outsideClick(Sender: TObject);
    procedure Recalculate(Sender: TObject);
    procedure pnlAddClick(Sender: TObject);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure pnlViewPlannedClick(Sender: TObject);
    procedure pnlFinaliseClick(Sender: TObject);
    procedure pnlSavePasswordClick(Sender: TObject);
    procedure pnlChangePasswordClick(Sender: TObject);
    procedure pnlSaveSettingsClick(Sender: TObject);
    procedure pnlNewTripClick(Sender: TObject);
    procedure cbTripNameSelect(Sender: TObject);
    procedure cbTripNameDropDown(Sender: TObject);
    procedure dbgTripsCellClick(Column: TColumn);

    { Private declarations }
  public
    { Public declarations }
  end;

function countOccurences(s: string; b: Char): integer;
procedure getImage(argPhotoref: string; argImg: TImage);

var
  frmMainMenu: TfrmMainMenu;
  searchStr: string;
  selected: integer;

  arrImages: array [0 .. 2] of TImage;
  arrREds: array [0 .. 2] of TRichEdit;
  arrRBs: array [0 .. 2] of TRadioButton;

  arrPlaceIDs: array [0 .. 2] of string;

  found: Boolean;
  plan_tripid: integer;

  arr_perperson: array [0 .. 2] of array [0 .. 1] of currency;
  // [0] adult, [1] child
  arr_rating: array [0 .. 2] of real;
  arr_attractions: array [0 .. 2] of array [0 .. 1] of string;
  // [0] first attraction, [1] second attraction
  arr_name: array [0 .. 2] of string;
  arr_address: array [0 .. 2] of string;
  arr_placeid: array [0 .. 2] of string;
  arr_photoref: array [0 .. 2] of string;

  arr_dates: array [0 .. 1] of TDateTime;
  // [0] arrival date, [1] departure date
  arr_amount: array [0 .. 1] of integer;
  // [0] amount of adult, [1], amount of children

  qryTripNames: TADOQuery;

const
  clBase = $00C8CCA8;
  clSelected = $007B814B;
  clSecondary = $009FA666;

  API_Key = 'AIzaSyC10J95nYpMWJFKhh5ee7CFzkJRJWO1RZ0';

implementation

{$R *.dfm}

uses LoginSignup_u, TravelRouter_dm, ViewTrip_u, displayTrip_u;

function countOccurences(s: string; b: Char): integer;
var
  i, count: integer;
begin
  count := 0;
  for i := low(s) to high(s) do
  begin
    if s[i] = b then
    begin
      count := count + 1;
    end;
  end;
  Result := count;
end;

procedure TfrmMainMenu.outsideClick(Sender: TObject);
begin
  if edtName.Text = '' then
  begin
    edtName.Text := 'Country, province, or town...';
    edtName.Font.Color := clGray;
  end;
end;

procedure TfrmMainMenu.pnlNewTripClick(Sender: TObject);
var
  tripname: string;
begin
  if isGuest = True then
  begin
    showmessage('Please sign up or log in.');
    frmMainMenu.Hide;
    frmLoginSignup.Show;
  end
  else
  begin

    tripname := Inputbox('Trip name',
      'Please enter a name to identify your trip', '');

    pnlAdd.Enabled := True;
    pnlAdd.BevelOuter := bvRaised;
    pnlFinalise.Enabled := True;
    pnlFinalise.BevelOuter := bvRaised;
    pnlViewPlanned.Enabled := True;
    pnlViewPlanned.BevelOuter := bvRaised;

    with TADOQuery.Create(nil) do
    begin
      connection := dmTravelRouter.connTravelRouterDB;
      SQL.Add('INSERT INTO Trips (Trip_Name, Finalised)');
      SQL.Add('VALUES (:trip_name, :finalised)');
      Parameters.ParamByName('trip_name').Value := tripname;
      Parameters.ParamByName('finalised').Value := False;
      ExecSQL;
      Free;
    end;

    with dmTravelRouter do
    begin
      tblTrips.Open;
      tblTrips.Last;
      plan_tripid := tblTrips['ID'];
      tblTrips.Close;
    end;

    lblTripName.Caption := tripname;
  end;
end;

procedure TfrmMainMenu.cbTripNameDropDown(Sender: TObject);
begin

  qryTripNames := TADOQuery.Create(nil);
  with qryTripNames do
  begin
    connection := dmTravelRouter.connTravelRouterDB;
    SQL.Add('SELECT ID, Trip_Name FROM Trips');
    SQL.Add('WHERE (ID IN (SELECT DISTINCT Trip_ID FROM Bookings WHERE User_ID = :UserID))');
    SQL.Add('AND (Finalised = True)');
    Parameters.ParamByName('UserID').Value := User.ID;
    Open;
  end;

  qryTripNames.First;
  cbTripName.Items.Clear;
  while not qryTripNames.EoF do
  begin
    cbTripName.Items.Add(qryTripNames['Trip_Name']);
    qryTripNames.Next;
  end;

end;

procedure TfrmMainMenu.cbTripNameSelect(Sender: TObject);
var
  selected_tripid, i: integer;
  qryTripDetails: TADOQuery;
  dsTripDetails: TDataSource;

begin
  imgViewAccomodation.Picture := nil;
  redAccomodation_view.Clear;
  redAccomodation_view.Visible := False;

  i := 0;
  qryTripNames.Open;
  qryTripNames.First;
  while not qryTripNames.EoF do
  begin
    if i = cbTripName.ItemIndex then
    begin
      selected_tripid := qryTripNames['ID'];
      break;
    end;
    qryTripNames.Next;
    inc(i);
  end;

  qryTripDetails := TADOQuery.Create(nil);
  with qryTripDetails do
  begin
    connection := dmTravelRouter.connTravelRouterDB;
    SQL.Add('SELECT Bookings.ID AS BookingID, ');

    SQL.Add('Accomodation.Place_Name AS [Accomodation Name],');

    SQL.Add('FORMAT(Bookings.Arrival_Date, "ddd, d mmm yyyy") & " - " & FORMAT(Bookings.Departure_Date, "ddd, d mmm yyyy") AS [Dates of stay],');

    SQL.Add('Bookings.Amount_of_Adults & " adults, " & Bookings.Amount_of_Children & " children" AS [Amount of people],');

    SQL.Add('"R" & CStr((DATEDIFF("d", Bookings.Arrival_Date, Bookings.Departure_Date) * Bookings.Amount_of_Adults * Accomodation.Adult_ppn) + ');
    SQL.Add('(DATEDIFF("d", Bookings.Arrival_Date, Bookings.Departure_Date) * Bookings.Amount_of_Children * Accomodation.Child_ppn))  AS [Total price]');

    SQL.Add('FROM Bookings ');
    SQL.Add('INNER JOIN Accomodation ON Accomodation.Place_ID = Bookings.Accomodation_ID ');
    SQL.Add('WHERE (Bookings.Trip_ID = :TripID) AND (Bookings.User_ID = :UserID) ');
    SQL.Add('ORDER BY Bookings.Arrival_Date'); // Uses ORDER BY to sort query
    Parameters.ParamByName('TripID').Value := selected_tripid;
    Parameters.ParamByName('UserID').Value := User.ID;
  end;

  qryTripDetails.Open;
  dsTripDetails := TDataSource.Create(nil);
  dsTripDetails.DataSet := qryTripDetails;
  dbgTrips.DataSource := dsTripDetails;
  dbgTrips.Columns[0].Visible := False;
end;

procedure TfrmMainMenu.dbgTripsCellClick(Column: TColumn);
var
  photoref_view: string;
  row_id: integer;
  accomodation_id: string;
begin
  row_id := dbgTrips.DataSource.DataSet['BookingID'];
  redAccomodation_view.Clear;
  redAccomodation_view.Visible := False;

  with dmTravelRouter do
  begin
    tblBookings.Open;
    tblBookings.First;
    while not tblBookings.EoF do
    begin

      if row_id = tblBookings['ID'] then
      begin
        accomodation_id := tblBookings['Accomodation_ID'];

        tblAccomodation.Open;
        tblAccomodation.First;

        while not tblAccomodation.EoF do
        begin
          if accomodation_id = tblAccomodation['Place_ID'] then
          begin
            photoref_view := tblAccomodation['Photo_ref'];

            redAccomodation_view.Clear;
            redAccomodation_view.Visible := True;
            with redAccomodation_view.Lines do
            begin
              Add(Uppercase(tblAccomodation['Place_Name']));
              Add('');
              Add(tblAccomodation['Attraction_1']);
              Add(tblAccomodation['Attraction_2']);
              Add(tblAccomodation['Address']);
            end;

            break;
          end;
          tblAccomodation.Next;
        end;

        break;
      end;
      tblBookings.Next;
    end;

  end;

  getImage(photoref_view, imgViewAccomodation);
end;

procedure TfrmMainMenu.edtInput(Sender: TObject);
var
  obj: TEdit;
begin
  obj := Sender as TEdit;
  if obj.Font.Color = clGray then
  begin
    obj.Font.Color := clBlack;
    obj.Text := '';
  end;
end;

procedure TfrmMainMenu.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    pnlSearchClick(Sender);
end;

procedure TfrmMainMenu.FormCreate(Sender: TObject);
begin
  left := (Screen.WorkAreaWidth - frmMainMenu.Width) div 2;
  top := (Screen.WorkAreaHeight - frmMainMenu.Height) div 2;

  found := False;
end;

procedure TfrmMainMenu.FormShow(Sender: TObject);
begin
  pnlCurrentTrip.top := (pnlTabHolder.Height - pnlCurrentTrip.Height) div 2;
  pnlPlanTrip.top := (pnlTabHolder.Height - pnlPlanTrip.Height) div 2;
  imgSettings.top := (pnlTabHolder.Height - imgSettings.Height) div 2;

  pnlPlanTrip.Color := clBase;
  pnlPlanTrip.BevelInner := bvNone;

  pnlCurrentTrip.Color := clSelected;
  pnlCurrentTrip.BevelInner := bvLowered;

  pcMainmenu.ActivePage := tsCurrentTrip;

  if isGuest = False then
    lblName.Caption := ' Hello, ' + User.FirstName + '.'
  else
    lblName.Caption := ' Hello, guest.';
  lblName.left := imgSettings.left - lblName.Width - 30;
  lblName.top := (pnlTabHolder.Height - lblName.Height) div 2;

  lblTripName.Caption := '';
  pnlAdd.Enabled := False;
  pnlAdd.BevelOuter := bvLowered;
  pnlFinalise.Enabled := False;
  pnlFinalise.BevelOuter := bvLowered;
  pnlViewPlanned.Enabled := False;
  pnlViewPlanned.BevelOuter := bvLowered;

  redAccomodation_view.Visible := False;
end;

procedure TfrmMainMenu.imgSettingsClick(Sender: TObject);
begin
  if isGuest = True then
  begin
    showmessage('Please sign up or log in.');
    frmLoginSignup.Show;
    frmMainMenu.Hide;
  end
  else
  begin

    imgSettings.Picture.LoadFromFile(copy(GetCurrentDir, 1,
      length(GetCurrentDir) - 11) + '/media/images/darkgreensettings.png');
    Refresh;

    pnlPlanTrip.Color := clBase;
    pnlPlanTrip.BevelInner := bvNone;

    pnlCurrentTrip.Color := clBase;
    pnlCurrentTrip.BevelInner := bvNone;
    pcMainmenu.ActivePage := tsSettings;

    edtSetName.Text := User.FirstName;
    edtSetSurname.Text := User.Surname;
    edtSetEmail.Text := User.Email;
    edtSetPhone.Text := User.PhoneNo;

    edtPassword.Enabled := False;
    edtSetPassword.Enabled := False;
    edtRePassword.Enabled := False;
    pnlSavePassword.Enabled := False;
    pnlSavePassword.BevelOuter := bvLowered;

    lblUserID.Caption := User.IDNo;
    lblUserBirthday.Caption := FormatDateTime('ddddd', User.DoB);
    lblUserGender.Caption := User.Gender;

  end;
end;

procedure TfrmMainMenu.pnlAddClick(Sender: TObject);
var
  accomodationFound: Boolean;
begin
  with dmTravelRouter do
  begin
    try
      // Check if accomodation is already in accomodation table
      tblAccomodation.Open;
      tblAccomodation.First;
      accomodationFound := False;

      while not tblAccomodation.EoF do // SEARCH DATABASE
      begin
        if tblAccomodation['Place_ID'] = arr_placeid[selected] then
        begin
          accomodationFound := True;
          break;
        end;
        tblAccomodation.Next;
      end;

      if accomodationFound = False then
      begin
        with TADOQuery.Create(nil) do
        begin
          connection := connTravelRouterDB;

          // ADD accomodation values to the table
          SQL.Add('INSERT INTO Accomodation (Place_ID, Place_Name, Address, Attraction_1, Attraction_2, Adult_ppn, Child_ppn, Rating, Photo_ref)');
          SQL.Add('VALUES (:place_id, :name, :address, :attraction1, :attraction2, :ppadult, :ppchild, :rating, :photo_ref);');
          Parameters.ParamByName('place_id').Value := arr_placeid[selected];
          Parameters.ParamByName('name').Value := arr_name[selected];
          Parameters.ParamByName('address').Value := arr_address[selected];
          Parameters.ParamByName('attraction1').Value :=
            arr_attractions[selected][0];
          Parameters.ParamByName('attraction2').Value :=
            arr_attractions[selected][1];
          Parameters.ParamByName('ppadult').Value := arr_perperson[selected][0];
          Parameters.ParamByName('ppchild').Value := arr_perperson[selected][1];
          Parameters.ParamByName('rating').Value := arr_rating[selected];
          Parameters.ParamByName('photo_ref').Value := arr_photoref[selected];

          ExecSQL;
          Free;
        end;
      end;

      // Add booking to booking table
      with TADOQuery.Create(nil) do
      begin
        connection := connTravelRouterDB;
        SQL.Add('INSERT INTO Bookings (User_ID, Trip_ID, Accomodation_ID, Arrival_Date, Departure_Date, Amount_of_Adults, Amount_of_Children)');
        SQL.Add('VALUES (:userID, :tripid, :placeID, :arrivedate, :leavedate, :amountadult, :amountchildren);');

        Parameters.ParamByName('userID').Value := User.ID;
        Parameters.ParamByName('tripid').Value := plan_tripid;
        Parameters.ParamByName('placeID').Value := arr_placeid[selected];
        Parameters.ParamByName('arrivedate').Value := arr_dates[0];
        Parameters.ParamByName('leavedate').Value := arr_dates[1];
        Parameters.ParamByName('amountadult').Value := arr_amount[0];
        Parameters.ParamByName('amountchildren').Value := arr_amount[1];

        ExecSQL;
        Free;
      end;

      showmessage('Accomodation booking at ' + arr_name[selected] +
        ' successfully added to trip.');
    except
      on E: Exception do
      begin
        showmessage('Error adding accomodation to trip: ' + E.Message);
      end;
    end;

  end;
end;

procedure TfrmMainMenu.pnlChangePasswordClick(Sender: TObject);
begin
  edtPassword.Enabled := True;
  edtSetPassword.Enabled := True;
  edtRePassword.Enabled := True;
  pnlSavePassword.Enabled := True;
  pnlSavePassword.BevelOuter := bvRaised;
end;

procedure TfrmMainMenu.pnlCurrentTripClick(Sender: TObject);
begin
  if isGuest = True then
  begin
    showmessage('Please sign up or log in.');
    frmLoginSignup.Show;
    frmMainMenu.Hide;
  end
  else
  begin
    pnlCurrentTrip.Color := clSelected;
    pnlCurrentTrip.BevelInner := bvLowered;

    pnlPlanTrip.Color := clBase;
    pnlPlanTrip.BevelInner := bvNone;

    imgSettings.Picture.LoadFromFile(copy(GetCurrentDir, 1,
      length(GetCurrentDir) - 11) + '/media/images/whitesettings.png');
    Refresh;

    pcMainmenu.ActivePage := tsCurrentTrip;
  end;
end;

procedure TfrmMainMenu.pnlFinaliseClick(Sender: TObject);
begin
  frmMainMenu.Enabled := False;
  frmViewTrip.pcViewTrip.ActivePage := frmViewTrip.tsCheckout;
  frmViewTrip.pnlCheckout.Color := clSelected;
  frmViewTrip.pnlCheckout.BevelInner := bvLowered;

  frmViewTrip.pnlViewTrip.Color := clBase;
  frmViewTrip.pnlViewTrip.BevelInner := bvNone;

  frmViewTrip.pnlViewTrip.Visible := True;
  frmViewTrip.pnlCheckout.Visible := True;

  frmViewTrip.Show;
end;

procedure TfrmMainMenu.pnlPlanTripClick(Sender: TObject);
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

procedure TfrmMainMenu.pnlSavePasswordClick(Sender: TObject);
begin
  if edtPassword.Text = User.Password then
  begin
    if edtSetPassword.Text = edtRePassword.Text then
    begin
      User.Password := edtSetPassword.Text;
      try
        User.UpdateDB;
      except
        on E: Exception do
          showmessage('Failed to update database.');
      end;
    end
    else
      showmessage('Passwords do not match');
  end
  else
    showmessage('Password is incorrect');

  edtPassword.Text := '';
  edtSetPassword.Text := '';
  edtRePassword.Text := '';

  edtPassword.Enabled := False;
  edtSetPassword.Enabled := False;
  edtRePassword.Enabled := False;
  pnlSavePassword.Enabled := False;
  pnlSavePassword.BevelOuter := bvLowered;
end;

procedure TfrmMainMenu.pnlSaveSettingsClick(Sender: TObject);
begin
  User.FirstName := edtSetName.Text;
  User.Surname := edtSetSurname.Text;

  if edtSetEmail.Text <> User.Email then
  begin
    if isValidEmail(edtSetEmail.Text) = 0 then
    begin
      User.Email := edtSetEmail.Text;
    end
    else if isValidEmail(edtSetEmail.Text) = 1 then
    begin
      showmessage('Email address already in use.');
    end
    else if isValidEmail(edtSetEmail.Text) = 2 then
    begin
      showmessage('Invalid email adress.');
    end;
  end;

  if isValidPhoneNo(edtSetPhone.Text) then
    User.PhoneNo := edtSetPhone.Text
  else
    showmessage('Invalid phone number');

  try
    User.UpdateDB;
    showmessage('Setting successfully updated.');
    lblName.Caption := 'Hello, ' + User.FirstName;
  except
    on E: Exception do
      showmessage('Failed to update database.');
  end;

end;

procedure TfrmMainMenu.pnlSearchClick(Sender: TObject);
var
  searchStr: string;
  searchURL: string;

  pricerange: real;

  attractionValue1, attractionValue2: integer;
  photoRefStart: integer;

  strJSON: string;
  objJSON: TJSONObject;
  resultsJSON: TJSONArray;
  resultJSON: TJSONObject;
  placeJSON: TJSONArray;
  photosJson: TJSONArray;
  photoJson: TJSONObject;

  RESTClnt: TRESTClient;
  RESTReq: TRESTRequest;
  RESTResp: TRESTResponse;

  j, i, iEnd: integer;

const
  attractions: array [0 .. 21] of string = ('Swimming pool', 'Free wifi',
    'Mountain view', 'Free parking', 'Bed and breakfast', 'Room service',
    'Laundry service', 'DSTV', 'Restuarant', 'Mini golf', 'Underfloor heating',
    'Jacuzzi', 'Bicycle rental', 'Free car service', 'Heated swimming pool',
    'Gym', 'Bar', 'Spa', 'Air conditioning', 'Beach view', 'Tennis court',
    'Mountain-bike trails');

begin
  lblTopMatches.Visible := True;

  arrImages[0] := imgAccomodation1;
  arrImages[1] := imgAccomodation2;
  arrImages[2] := imgAccomodation3;

  arrREds[0] := redAccomodation1;
  arrREds[1] := redAccomodation2;
  arrREds[2] := redAccomodation3;

  arrRBs[0] := rbSelect1;
  arrRBs[1] := rbSelect2;
  arrRBs[2] := rbSelect3;

  searchStr := edtName.Text + ' accomodation';

  for i := 0 to 2 do
  begin
    arrREds[i].Visible := False;
    arrRBs[i].Visible := False;
    arrImages[i].Picture := nil;
  end;

  try
    try
      RESTClnt := TRESTClient.Create
        ('https://maps.googleapis.com/maps/api/place/textsearch/json?parameters');
      with RESTClnt do
      begin
        Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
        AcceptCharSet := 'utf-8, *;q=0.8';
        RaiseExceptionOn500 := False;
      end;

      RESTResp := TRESTResponse.Create(nil);
      with RESTResp do
      begin
        ContentType := 'application/json';
      end;

      RESTReq := TRESTRequest.Create(nil);
      with RESTReq do
      begin
        Client := RESTClnt;
        Response := RESTResp;

        Params.Clear;
        Params.AddItem('input', searchStr, pkGETorPOST);
        Params.AddItem('fields',
          'place_id,formatted_address,name,rating,photos', pkGETorPOST);
        Params.AddItem('key', API_Key, pkGETorPOST);
        Params.AddItem('type', 'lodging', pkGETorPOST);
      end;

      RESTReq.Execute;

    except
      on E: Exception do
      begin
        showmessage('Unable to process REST request');
      end;

    end;

    strJSON := RESTResp.JSONText;
    objJSON := TJSONObject.ParseJSONValue(strJSON) as TJSONObject;

    try
      resultsJSON := objJSON.GetValue('results') as TJSONArray;

      if resultsJSON.count >= 3 then
      begin
        iEnd := 2
      end
      else
      begin
        iEnd := resultsJSON.count - 1;
      end;

      for i := 0 to iEnd do
      begin

        resultJSON := resultsJSON.Get(i) as TJSONObject;

        arr_name[i] := resultJSON.GetValue<string>('name');
        arr_address[i] := resultJSON.GetValue<string>('formatted_address');
        arr_rating[i] := resultJSON.GetValue<real>('rating');
        arr_placeid[i] := resultJSON.GetValue<string>('place_id');

        try
          photosJson := resultJSON.GetValue('photos') as TJSONArray;
          photoJson := photosJson.Get(0) as TJSONObject;
          arr_photoref[i] := photoJson.GetValue<string>('photo_reference');
        except
          on E: Exception do
          begin
            arr_photoref[i] := 'none';
          end;
        end;


        // Fill out each accomodation

        pricerange := (countOccurences(arr_placeid[i],
          arr_placeid[i][high(arr_placeid[i])]) +
          countOccurences(arr_placeid[i], 'X') + length(arr_name[i])) /
          ((countOccurences(arr_placeid[i], 'a') +
          length(arr_placeid[i])) div 5);
        // price range is a value between 1 and 5 generated from the place ID

        arr_perperson[i][0] := pricerange * 100; // adults
        arr_perperson[i][1] := pricerange * 75; // children

        attractionValue1 :=
          (length(arr_name[i]) + countOccurences(arr_placeid[i],
          arr_placeid[i][high(arr_placeid[i])])) mod high(attractions);

        j := 65;
        repeat
        begin
          attractionValue2 := (countOccurences(arr_placeid[i], Char(j)) +
            length(arr_name[i])) mod high(attractions);
          inc(j);
        end;
        until (attractionValue2 <> attractionValue1) or (j = 172);

        arr_attractions[i][0] := attractions[attractionValue1];
        arr_attractions[i][1] := attractions[attractionValue2];

        arrREds[i].Clear;
        with arrREds[i].Lines do
        begin
          Add(Uppercase(arr_name[i]));
          Add('');
          Add(formatfloat('0.0', arr_rating[i]) + '/5 stars');
          Add(arr_attractions[i][0]);
          Add(arr_attractions[i][1]);
          Add('Price/night for adults: R' + formatfloat('0',
            arr_perperson[i][0]));
          Add('Price/night for children: R' + formatfloat('0',
            arr_perperson[i][1]));
          Add(arr_address[i]);
        end;

        getImage(arr_photoref[i], arrImages[i]);

        arrImages[i].Visible := True;
        arrREds[i].Visible := True;

      end;

      rbSelect1.Checked := True;
      found := True;
    finally
      FreeAndNil(objJSON);
    end;
  except
    on E: Exception do
    begin
      showmessage('Error excecuting API request');
      exit;
    end;
  end;

  for i := 0 to iEnd do
    arrRBs[i].Visible := True;
end;

procedure getImage(argPhotoref: string; argImg: TImage);
var
  DLLpath: string;
  imageURL: string;

  IdHTTPReq: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  lResponse: TMemoryStream;

begin
  try
    try
      // request image

      if argPhotoref <> 'none' then
      begin

        DLLpath := GetCurrentDir + '\OpenSSL';
        IdOpenSSLSetLibPath(DLLpath);

        imageURL :=
          'https://maps.googleapis.com/maps/api/place/photo?maxheight=' + '150'
          + '&photoreference=' + argPhotoref + '&key=' + API_Key;

        IdHTTPReq := TIdHTTP.Create;
        lResponse := TMemoryStream.Create;

        SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTPReq);
        SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_1, sslvTLSv1_2];
        IdHTTPReq.IOHandler := SSLHandler;

        IdHTTPReq.HandleRedirects := True;
        IdHTTPReq.Get(imageURL, lResponse);

        lResponse.Position := 0;
        lResponse.Seek(0, soFromBeginning);

        argImg.Picture.LoadFromStream(lResponse);
      end
      else
        argImg.Picture.LoadFromFile(copy(GetCurrentDir, 1,
          length(GetCurrentDir) - 11) + '\media\images\no_image_available.png');

    except
      on E: Exception do
      begin
        showmessage('Error getting image');
      end;
    end;
  finally
    FreeAndNil(lResponse);
    FreeAndNil(IdHTTPReq);
  end;
end;

procedure TfrmMainMenu.pnlViewPlannedClick(Sender: TObject);
begin
  frmMainMenu.Enabled := False;
  frmViewTrip.pcViewTrip.ActivePage := frmViewTrip.tsViewTrip;
  frmViewTrip.pnlViewTrip.Visible := False;
  frmViewTrip.pnlCheckout.Visible := False;

  frmViewTrip.Show;
end;

procedure TfrmMainMenu.Recalculate(Sender: TObject);
var
  totalCost: real;
  nights: integer;
begin
  if found = True then
  begin
    if rbSelect1.Checked = True then
      selected := 0
    else if rbSelect2.Checked = True then
      selected := 1
    else if rbSelect3.Checked = True then
      selected := 2;

    arr_dates[0] := dtpArrive.Date;
    arr_dates[1] := dtpLeave.Date;

    nights := DaysBetween(arr_dates[0], arr_dates[1]);
    arr_amount[0] := speAdults.Value;
    arr_amount[1] := speChildren.Value;

    totalCost := (arr_amount[0] * arr_perperson[selected][0] * nights) +
      (arr_amount[1] * arr_perperson[selected][1] * nights);
    lblCost.Caption := 'Cost: R' + formatfloat('0.00', totalCost);
  end;

end;

end.
