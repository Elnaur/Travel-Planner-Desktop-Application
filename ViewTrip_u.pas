unit ViewTrip_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, displayTrip_u,
  Vcl.Imaging.pngimage, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  EASendMailObjLib_TLB, math, IdHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdSSLOpenSSLHeaders, IdSMTP, IdAttachment, IdMessage,
  IdMessageParts, IdEMailAddress, IdAttachmentFile, IdText,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, Data.DB, Vcl.DBGrids, Data.Win.ADODB, DateUtils;

type
  TfrmViewTrip = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlClose: TPanel;
    pnlDelete: TPanel;
    imgBackground: TImage;
    pcViewTrip: TPageControl;
    tsViewTrip: TTabSheet;
    tsCheckout: TTabSheet;
    pnlCheckout: TPanel;
    pnlViewTrip: TPanel;
    edtCardNum: TEdit;
    lblCardNum: TLabel;
    imgMastercard: TImage;
    imgVISA: TImage;
    lblLHeading2: TLabel;
    lblLHeading1: TLabel;
    imgLLogo: TImage;
    lblExpiry: TLabel;
    edtYY: TEdit;
    lblSlash: TLabel;
    edtMM: TEdit;
    lblCVV: TLabel;
    pnlConfirm: TPanel;
    lblTotal: TLabel;
    lblExplainCVV: TLabel;
    edtCVV: TEdit;
    pnlViewTripBackground: TPanel;
    dbgViewTrip: TDBGrid;
    lblAmountOfPlacesBooked: TLabel;
    procedure FormShow(Sender: TObject);
    procedure pnlCloseClick(Sender: TObject);
    procedure pnlCheckoutClick(Sender: TObject);
    procedure pnlViewTripClick(Sender: TObject);
    procedure pnlConfirmClick(Sender: TObject);
    procedure pnlDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function isValidCreditCardNum(argNum: string): boolean;
function isValidCreditCardExpiryDate(argDate: string): boolean;

var
  frmViewTrip: TfrmViewTrip;
  qryViewTrip: TADOQuery;
  qryTotalPrice: TADOQuery;
  qryTotalPlaces: TADOQuery;
  dsViewTrip: TDataSource;

const
  ConnectSSLAuto = 1;

implementation

uses Mainmenu_u, LoginSignup_u, TravelRouter_dm;

{$R *.dfm}

function isValidCreditCardNum(argNum: string): boolean;
begin
  Result := False;
  if length(argNum) <> 16 then
    exit;

  if (argNum[1] <> '4' { VISA } ) and (argNum[1] <> '5' { MASTERCARD } ) then
    exit;

  if CheckSumLuhnValid(argNum) = False then
    exit;

  Result := True;
end;

function isValidCreditCardExpiryDate(argDate: string): boolean;
var
  dtDate: TDateTime;
begin
  FormatSettings.ShortDateFormat := 'mm/yy';
  dtDate := StrToDate(argDate);

  FormatSettings.ShortDateFormat := 'dd/mm/yyyy'; // Set back to defaults

  if dtDate < Now then
    Result := False
  else
    Result := True;
end;

procedure TfrmViewTrip.FormShow(Sender: TObject);
begin
  left := (Screen.WorkAreaWidth - frmMainMenu.Width) div 2;
  top := (Screen.WorkAreaHeight - frmMainMenu.Height) div 2;

  pnlTop.Color := clSecondary;
  pnlBottom.Color := clSecondary;
  pnlClose.Color := clBase;
  pnlDelete.Color := clBase;

  qryViewTrip := TADOQuery.Create(nil);
  with qryViewTrip do
  begin
    connection := dmTravelRouter.connTravelRouterDB;
    SQL.Add('SELECT Bookings.ID AS BookingID, ');

    SQL.Add('Accomodation.Place_Name AS [Accomodation Name],');

    SQL.Add('FORMAT(Bookings.Arrival_Date, "ddd, d mmm yyyy") & " - " & FORMAT(Bookings.Departure_Date, "ddd, d mmm yyyy") AS [Dates of stay],');
    // STRING MANIPULATION

    SQL.Add('Bookings.Amount_of_Adults & " adults, " & Bookings.Amount_of_Children & " children" AS [Amount of people],');

    SQL.Add('"R" & CStr((DATEDIFF("d", Bookings.Arrival_Date, Bookings.Departure_Date) * Bookings.Amount_of_Adults * Accomodation.Adult_ppn) + ');
    SQL.Add('(DATEDIFF("d", Bookings.Arrival_Date, Bookings.Departure_Date) * Bookings.Amount_of_Children * Accomodation.Child_ppn))  AS [Total price]');

    SQL.Add('FROM Bookings ');
    SQL.Add('INNER JOIN Accomodation ON Accomodation.Place_ID = Bookings.Accomodation_ID ');
    // COMPLEX SQL
    SQL.Add('WHERE (Bookings.Trip_ID = :TripID) AND (Bookings.User_ID = :UserID) ');
    SQL.Add('ORDER BY Bookings.Arrival_Date');
    Parameters.ParamByName('TripID').Value := plan_tripid;
    Parameters.ParamByName('UserID').Value := User.ID;
  end;

  qryViewTrip.Open;
  dsViewTrip := TDataSource.Create(nil);
  dsViewTrip.DataSet := qryViewTrip;
  dbgViewTrip.DataSource := dsViewTrip;
  dbgViewTrip.Columns[0].Visible := False;

  qryTotalPrice := TADOQuery.Create(nil);
  with qryTotalPrice do
  begin
    connection := dmTravelRouter.connTravelRouterDB;
    SQL.Add('SELECT SUM((DATEDIFF("d", Arrival_Date, Bookings.Departure_Date) * Bookings.Amount_of_Adults * Accomodation.Adult_ppn) + ');
    SQL.Add('(DATEDIFF("d", Bookings.Arrival_Date, Bookings.Departure_Date) * Bookings.Amount_of_Children * Accomodation.Child_ppn))');
    SQL.Add('AS Total');
    SQL.Add('FROM Bookings, Accomodation');
    SQL.Add('WHERE (Bookings.Trip_ID = :TripID) AND (Bookings.User_ID = :UserID) ');
    Parameters.ParamByName('TripID').Value := plan_tripid;
    Parameters.ParamByName('UserID').Value := User.ID;

    qryTotalPrice.Open;
    qryTotalPrice.First;
  end;

  qryTotalPrice.Open;
  qryTotalPrice.First;
  lblTotal.Caption := 'Total: R' + FormatFloat('0.00', qryTotalPrice['Total']);
  qryTotalPrice.Close;

  qryTotalPlaces := TADOQuery.Create(nil);
  with qryTotalPlaces do
  begin
    connection := dmTravelRouter.connTravelRouterDB;
    SQL.Add('SELECT COUNT(Accomodation_ID) AS [Amount]');
    SQL.Add('FROM Bookings ');
    SQL.Add('WHERE (Bookings.Trip_ID = :TripID) AND (Bookings.User_ID = :UserID) ');
    Parameters.ParamByName('TripID').Value := plan_tripid;
    Parameters.ParamByName('UserID').Value := User.ID;
  end;

  qryTotalPlaces.Open;
  qryTotalPlaces.First;
  lblAmountOfPlacesBooked.Caption := 'Amount of places booked at: ' +
    IntToStr(qryTotalPlaces['Amount']);
  qryTotalPlaces.Close;
end;

procedure TfrmViewTrip.pnlCheckoutClick(Sender: TObject);
begin
  pnlCheckout.Color := clSelected;
  pnlCheckout.BevelInner := bvLowered;

  pnlViewTrip.Color := clBase;
  pnlViewTrip.BevelInner := bvNone;

  pcViewTrip.ActivePage := tsCheckout;
end;

procedure TfrmViewTrip.pnlCloseClick(Sender: TObject);
begin
  frmViewTrip.Hide;
  frmMainMenu.Enabled := True;
  frmMainMenu.Show;
end;

procedure TfrmViewTrip.pnlConfirmClick(Sender: TObject);
var
  code: string;
  SMTP: TIdSMTP;
  Msg: TIdMessage;
  i: Integer;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdText: TIdText;
  DLLpath: string;
begin
  if isValidCreditCardNum(edtCardNum.Text) = False then
  begin
    Showmessage('Invalid credit card number.');
    exit;
  end;

  if isValidCreditCardExpiryDate(edtMM.Text + '/' + edtYY.Text) = False then
  begin
    Showmessage('Invalid expiry date.');
    exit;
  end;

  if length(edtCVV.Text) <> 3 then
  begin
    Showmessage('Invalid CVV');
    exit;
  end;

  code := '';
  Randomize;
  for i := 0 to 6 do
  begin
    code := code + IntToStr(random(10));
  end;

  // Delphi SMTP with Indy and Gmail:
  // http://www.andrecelestino.com/delphi-xe-envio-de-e-mail-com-componentes-indy/

  Msg := TIdMessage.Create(nil);
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  SMTP := TIdSMTP.Create(nil);

  try
    Msg.From.Address := 'travelrouter.whereyouwanttogo@gmail.com';
    Msg.From.Name := 'Travel Router';
    Msg.ReplyTo.EMailAddresses := Msg.From.Address;
    Msg.Recipients.EMailAddresses := User.Email;
    Msg.Subject := 'Verification code';

    IdText := TIdText.Create(Msg.MessageParts);
    IdText.Body.Add('Hi, ' + User.FirstName + '!');
    IdText.Body.Add('');
    IdText.Body.Add('Thank you for using Travel Router.');
    IdText.Body.Add('Your verification code is: ' + code);
    IdText.Body.Add('');
    IdText.Body.Add('Enjoy your trip!');
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    try
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
      IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

      SMTP.IOHandler := IdSSLIOHandlerSocket;
      SMTP.UseTLS := utUseImplicitTLS;
      SMTP.Host := 'smtp.gmail.com';
      SMTP.Port := 465;
      SMTP.AuthType := satDefault;
      SMTP.Username := 'travelrouter.whereyouwanttogo@gmail.com';
      SMTP.Password := 'Gr12ITpat';

      DLLpath := GetCurrentDir + '\OpenSSL';
      IdOpenSSLSetLibPath(DLLpath);

      try
        SMTP.Connect;
        SMTP.Authenticate;
      except
        on E: Exception do
        begin
          MessageDlg('Cannot authenticate: ' + E.Message, mtWarning, [mbOK], 0);
          exit;
        end;
      end;

      SMTP.Send(Msg);
    finally
      SMTP.Free;
    end;
  finally
    Msg.Free;
  end;

  if code = InputBox('Verification',
    'A verification code has been emailed to you. Please enter the code below in order to verify your booking.',
    '') then
  begin
    with TADOQuery.Create(nil) do
    begin
      connection := dmTravelRouter.connTravelRouterDB;
      SQL.Add('UPDATE Trips');
      SQL.Add('SET Finalised = True');
      SQL.Add('WHERE ID = :id');
      Parameters.ParamByName('id').Value := plan_tripid;
    end;

    Showmessage('Booking successfully placed.')
  end
  else
    Showmessage('Incorrect code.');
end;

procedure TfrmViewTrip.pnlDeleteClick(Sender: TObject);
var
  i: Integer;
  idstr: string;
begin
  if dbgViewTrip.SelectedRows.Count > 0 then
  begin

    idstr := '(';
    for i := 0 to dbgViewTrip.SelectedRows.Count - 1 do
    begin
      qryViewTrip.GoToBookmark
        (TArray<Byte>(Pointer(dbgViewTrip.SelectedRows.Items[i])));

      idstr := idstr + qryViewTrip.FieldByName('BookingID').AsString + ',';
    end;

    Setlength(idstr, length(idstr) - 1);
    idstr := idstr + ')';

    // DELETE RECORD
    with TADOQuery.Create(nil) do
    begin
      connection := dmTravelRouter.connTravelRouterDB;

      SQL.Add('DELETE * FROM Bookings');
      SQL.Add('WHERE ID IN ' + idstr);

      ExecSQL;
      Free;
    end;

    Showmessage('Booking(s) successfully deleted');

    qryViewTrip.Close;
    qryViewTrip.Open;
    dbgViewTrip.Refresh;
    dbgViewTrip.Columns[0].Visible := False;

    qryTotalPrice.Open;
    qryTotalPrice.First;
    lblTotal.Caption := 'Total: R' + FormatFloat('0.00',
      qryTotalPrice['Total']);
    qryTotalPrice.Close;

    qryTotalPlaces.Open;
    qryTotalPlaces.First;
    lblAmountOfPlacesBooked.Caption := 'Amount of places booked at: ' +
      IntToStr(qryTotalPlaces['Amount']);
    qryTotalPlaces.Close;
  end;
end;

procedure TfrmViewTrip.pnlViewTripClick(Sender: TObject);
begin
  pnlViewTrip.Color := clSelected;
  pnlViewTrip.BevelInner := bvLowered;

  pnlCheckout.Color := clBase;
  pnlCheckout.BevelInner := bvNone;

  pcViewTrip.ActivePage := tsViewTrip;
end;

end.
