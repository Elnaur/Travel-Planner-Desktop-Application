unit Mainmenu_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
  Data.Win.ADODB, REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.Grids, Vcl.DBGrids, IdHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, JSON;

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
    edtCity: TEdit;
    edtNumber: TEdit;
    edtProvince: TEdit;
    edtStreet: TEdit;
    edtSuburb: TEdit;
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
    pnlSave: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlCurrentTripClick(Sender: TObject);
    procedure pnlPlanTripClick(Sender: TObject);
    procedure imgSettingsClick(Sender: TObject);
    procedure pnlSearchClick(Sender: TObject);

    procedure edtInput(Sender: TObject);
    procedure outsideClick(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainMenu: TfrmMainMenu;
  searchStr: string;

const
  clBase = $00C8CCA8;
  clSelected = $007B814B;
  clSecondary = $009FA666;

  Key = 'AIzaSyC10J95nYpMWJFKhh5ee7CFzkJRJWO1RZ0';

implementation

{$R *.dfm}

uses LoginSignup_u, TravelRouter_dm, fuzzystring_u;

procedure TfrmMainMenu.outsideClick(Sender: TObject);
begin
  if edtName.Text = '' then
  begin
    edtName.Text := 'Name';
    edtName.Font.Color := clGray;
  end;

  if edtProvince.Text = '' then
  begin
    edtProvince.Text := 'Province';
    edtProvince.Font.Color := clGray;
  end;

  if edtCity.Text = '' then
  begin
    edtCity.Text := 'City/Town';
    edtCity.Font.Color := clGray;
  end;

  if edtSuburb.Text = '' then
  begin
    edtSuburb.Text := 'Suburb';
    edtSuburb.Font.Color := clGray;
  end;

  if edtNumber.Text = '' then
  begin
    edtNumber.Text := 'Number';
    edtNumber.Font.Color := clGray;
  end;

  if edtStreet.Text = '' then
  begin
    edtStreet.Text := 'Street';
    edtStreet.Font.Color := clGray;
  end;

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

procedure TfrmMainMenu.FormCreate(Sender: TObject);
begin
  left := (Screen.WorkAreaWidth - frmMainMenu.Width) div 2;
  top := (Screen.WorkAreaHeight - frmMainMenu.Height) div 2;
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

  lblName.Caption := ' Hello, ' + User.FirstName + '.';
  lblName.left := imgSettings.left - lblName.Width - 30;
  lblName.top := (pnlTabHolder.Height - lblName.Height) div 2;

end;

procedure TfrmMainMenu.imgSettingsClick(Sender: TObject);
begin
  imgSettings.Picture.LoadFromFile(copy(GetCurrentDir, 1,
    length(GetCurrentDir) - 11) + '/media/images/darkgreensettings.png');
  Refresh;

  pnlPlanTrip.Color := clBase;
  pnlPlanTrip.BevelInner := bvNone;

  pnlCurrentTrip.Color := clBase;
  pnlCurrentTrip.BevelInner := bvNone;
  pcMainmenu.ActivePage := tsSettings;
end;

procedure TfrmMainMenu.pnlCurrentTripClick(Sender: TObject);
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

procedure TfrmMainMenu.pnlSearchClick(Sender: TObject);
var

  {
    placesearchURL: string;
    recordStr: string;

    // DLD: Damerau-Levenshtein Distance
    // Array that holds the DLD of records with the lowest DLD, arranged in asending order
    lowestDLDid: array [0 .. 2] of integer;
    // Array that holds the ids of records with the lowest DLD, arranged in asending order
    lowestDLD: array [0 .. 2] of integer;
    currDLD: integer;

    qryGetMatches: TADOQuery;
  }
  searchStr: string;
  searchURL: string;
  name, address, place_id: string;
  rating: real;
  pricerange: real;
  ppadult, ppchild: real;
  Attraction1, Attraction2: string;
  imageURL, photoref: string;

  IdHTTPReq: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;

  photoRefStart: Integer;

  lResponse: TMemoryStream;
  strJSON: string;
  objJSON: TJSONObject;
  candidatesJSON: TJSONArray;
  candidateJSON: TJSONObject;
  placeJSON: TJSONArray;
  photosJson: TJSONArray;
  photoJson: TJSONObject;

  RESTClnt: TRESTClient;
  RESTReq: TRESTRequest;
  RESTResp: TRESTResponse;

const
  attractions: array [0 .. 21] of string = ('Swimming pool', 'Free wifi',
    'Mountain view', 'Free parking', 'Bed and breakfast', 'Room service',
    'Laundry service', 'DSTV', 'Restuarant', 'Mini golf', 'Underfloor heating',
    'Jacuzzi', 'Bicycle rental', 'Free car service', 'Heated swimming pool',
    'Gym', 'Bar', 'Spa', 'Air conditioning', 'Beach view', 'Tennis court',
    'Mountain-bike trails');
begin {
    lowestDLDid[0] := 0;
    lowestDLDid[1] := 0;
    lowestDLDid[2] := 0;

    lowestDLD[0] := 0;
    lowestDLD[1] := 0;
    lowestDLD[2] := 0;

    searchStr := ifthen(edtName.Text = 'Name', '', edtName.Text) +
    ifthen(edtProvince.Text = 'Province', '', edtProvince.Text) +
    ifthen(edtCity.Text = 'City/Town', '', edtCity.Text) +
    ifthen(edtSuburb.Text = 'Suburb', '', edtSuburb.Text) +
    ifthen(edtNumber.Text = 'Number', '', edtNumber.Text) +
    ifthen(edtStreet.Text = 'Street', '', edtStreet.Text);

    with dmTravelRouter do
    begin
    tblAccomodation.Open;
    tblAccomodation.First;

    while not tblAccomodation.EoF do
    begin
    recordStr := ifthen(edtName.Text = 'Name', '', tblAccomodation['Name']) +
    ifthen(edtProvince.Text = 'Province', '', tblAccomodation['Province']) +
    ifthen(edtCity.Text = 'City/Town', '', tblAccomodation['City/Town']) +
    ifthen(edtSuburb.Text = 'Suburb', '', tblAccomodation['Suburb']) +
    ifthen(edtNumber.Text = 'Number', '', IntToStr(tblAccomodation['Number']
    )) + ifthen(edtStreet.Text = 'Street', '', tblAccomodation['Street']);

    currDLD := DamerauLevenshteinDistance(searchStr, recordStr);

    if currDLD < lowestDLD[0] then
    begin
    lowestDLDid[2] := lowestDLDid[1];
    lowestDLDid[1] := lowestDLDid[0];
    lowestDLD[0] := currDLD;

    lowestDLD[2] := lowestDLD[1];
    lowestDLD[1] := lowestDLD[0];
    lowestDLDid[0] := tblAccomodation['ID'];
    end
    else if currDLD < lowestDLD[1] then
    begin
    lowestDLDid[2] := lowestDLDid[1];
    lowestDLD[1] := currDLD;

    lowestDLD[2] := lowestDLD[1];
    lowestDLDid[1] := tblAccomodation['ID'];
    end
    else if currDLD < lowestDLD[2] then
    begin
    lowestDLD[2] := currDLD;

    lowestDLDid[2] := tblAccomodation['ID'];
    end;

    tblAccomodation.Next;
    end;
    end;

    qryGetMatches := TADOQuery.Create(nil);
    with qryGetMatches do
    begin
    Close;
    Connection := dmTravelRouter.connTravelRouterDB;
    SQL.Clear;
    SQL.Add('SELECT * ');
    SQL.Add('FROM Accomodation');
    SQL.Add('WHERE ID = ' + IntToStr(lowestDLDid[0]) + ' OR');
    SQL.Add('ID = ' + IntToStr(lowestDLDid[1]) + ' OR');
    SQL.Add('ID = ' + IntToStr(lowestDLDid[2]) + ';');
    Open;
    First;
    end;

    // First accomodation match
    imgAccomodation1.Picture.LoadFromFile(['ImagePath']);
    redAccomodation1.Clear;
    redAccomodation1.Lines.Add(UpperCase(qryGetMatches['Name']));
    redAccomodation1.Lines.Add('');
    redAccomodation1.Lines.Add(FormatFloat('0.0', qryGetMatches['Star rating']) +
    '/5 stars');
    if qryGetMatches['Attraction1'] <> 'None' then
    redAccomodation1.Lines.Add(qryGetMatches['Attraction1']);
    if qryGetMatches['Attraction2'] <> 'None' then
    redAccomodation1.Lines.Add(qryGetMatches['Attraction2']);

    redAccomodation1.Lines.Add('Price per night for adults: R' +
    FormatFloat('0.00', qryGetMatches['Price per adult per night']));
    redAccomodation1.Lines.Add('Price per night for children: R' +
    FormatFloat('0.00', qryGetMatches['Price per child per night']));

    Next;

    // Second accomodation match
    imgAccomodation2.Picture.LoadFromFile(['ImagePath']);
    redAccomodation2.Clear;
    redAccomodation2.Lines.Add(UpperCase(qryGetMatches['Name']));
    redAccomodation2.Lines.Add('');
    redAccomodation2.Lines.Add(FormatFloat('0.0', qryGetMatches['Star rating']) +
    '/5 stars');
    if qryGetMatches['Attraction1'] <> 'None' then
    redAccomodation2.Lines.Add(qryGetMatches['Attraction1']);
    if qryGetMatches['Attraction2'] <> 'None' then
    redAccomodation2.Lines.Add(qryGetMatches['Attraction2']);

    redAccomodation2.Lines.Add('Price per night for adults: R' +
    FormatFloat('0.00', qryGetMatches['Price per adult per night']));
    redAccomodation2.Lines.Add('Price per night for children: R' +
    FormatFloat('0.00', qryGetMatches['Price per child per night']));

    Next;

    // Third accomodation match
    imgAccomodation3.Picture.LoadFromFile(['ImagePath']);
    redAccomodation3.Clear;
    redAccomodation3.Lines.Add(UpperCase(qryGetMatches['Name']));
    redAccomodation3.Lines.Add('');
    redAccomodation3.Lines.Add(FormatFloat('0.0', qryGetMatches['Star rating']) +
    '/5 stars');
    if qryGetMatches['Attraction1'] <> 'None' then
    redAccomodation3.Lines.Add(qryGetMatches['Attraction1']);
    if qryGetMatches['Attraction2'] <> 'None' then
    redAccomodation3.Lines.Add(qryGetMatches['Attraction2']);

    redAccomodation3.Lines.Add('Price per night for adults: R' +
    FormatFloat('0.00', qryGetMatches['Price per adult per night']));
    redAccomodation3.Lines.Add('Price per night for children: R' +
    FormatFloat('0.00', qryGetMatches['Price per child per night']));

  }
  searchStr := edtName.Text;
  searchURL :=
    format('https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=%s&inputtype=textquery&fields=%s&key=%s',
    [searchStr, 'place_id,formatted_address,name,rating,photos', Key]);

  try
    try
      try
        RESTClnt := TRESTClient.Create
          ('https://maps.googleapis.com/maps/api/place/findplacefromtext/json?parameters');
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
          Params.AddItem('inputtype', 'textquery', pkGETorPOST);
          Params.AddItem('fields',
            'place_id,formatted_address,name,rating,photos', pkGETorPOST);
          Params.AddItem('key', Key, pkGETorPOST);
        end;

        RESTReq.Execute;

      except
        on E: Exception do
        begin
          Showmessage('Unable to process REST request');
        end;

      end;

      strJSON := RESTResp.JSONText;
      Showmessage(strJSON);

      objJSON := TJSONObject.ParseJSONValue(strJSON) as TJSONObject;

      try
        candidatesJSON := objJSON.GetValue('candidates') as TJSONArray;
        candidateJSON := candidatesJSON.Get(0) as TJSONObject;

        name := candidateJSON.GetValue<string>('name');
        address := candidateJSON.GetValue<string>('formatted_address');
        rating := candidateJSON.GetValue<real>('rating');
        place_id := candidateJSON.GetValue<string>('place_id');

        photosJson := candidateJSON.GetValue('photos') as TJSONArray;
        photoJson := photosJson.Get(0) as TJSONObject;
        photoref := photoJson.GetValue<string>('photo_reference');

      finally
        FreeAndNil(objJSON);
      end;

    except
      on E: Exception do
      begin
        Showmessage('Error excecuting API request');
        exit;
      end;
    end;
  finally
    lResponse.Free;
    IdHTTPReq.Free;;
  end;

  pricerange := (random(41) + 10) / 10;
  // price range is a value between 1 and 5

  ppadult := pricerange * 100;
  ppchild := pricerange * 75;

  Attraction1 := attractions[random(length(attractions))];

  Attraction2 := attractions[random(length(attractions))];
  while Attraction1 = Attraction2 do
    Attraction2 := attractions[random(length(attractions))];

  redAccomodation1.Clear;
  with redAccomodation1.Lines do
  begin
    Add(Uppercase(name));
    Add('');
    Add(FormatFloat('0.0', rating) + '/5 stars');
    Add(Attraction1);
    Add(Attraction2);
    Add('Price per night (adults): R' + FormatFloat('0', ppadult));
    Add('Price per night (children): R' + FormatFloat('0', ppchild));
  end;

  try
    try
      // request image
      imageURL := 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=' +
        '400' + '&photoreference=' + photoref + '&key=' + Key;

      IdHTTPReq := TIdHTTP.Create;
      lResponse := TMemoryStream.Create;

      SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTPReq);
      SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_1, sslvTLSv1_2];
      IdHTTPReq.IOHandler := SSLHandler;

      IdHTTPReq.HandleRedirects := True;
      IdHTTPReq.Get(imageURL, lResponse);

      lResponse.Position := 0;
      lResponse.Seek(0, soFromBeginning);
      imgAccomodation1.Picture.LoadFromStream(lResponse);

    except
      on E: Exception do
        Showmessage('Error getting image');
    end;
  finally
    FreeAndNil(lResponse);
    FreeAndNil(IdHTTPReq);
  end;

end;

end.
