unit displayTrip_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.ExtCtrls, Data.Win.ADODB, System.ImageList, Vcl.ImgList, Vcl.Grids,
  IdSSLOpenSSLHeaders, IdHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, Data.DB, Vcl.DBGrids, DateUtils;

type
  TframeDisplayTrip = class(TFrame)
    strgTrip: TStringGrid;
    procedure DisplayItems;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  qryAccomodationInfo: TADOQuery;

  arrTripImg: array of TImage;
  runOnce: boolean = false;

implementation

{$R *.dfm}

uses TravelRouter_dm, LoginSignup_u;
{ TframeDisplayTrip }

procedure TframeDisplayTrip.DisplayItems;
var
  DLLpath: string;
  imageURL: string;
  IdHTTPReq: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  lResponse: TMemoryStream;
  i: Integer;
begin
  // Set default col width
  strgTrip.defaultColWidth := strgTrip.Width div 4;

  // Get user booking
  strgTrip.Cells[0, 0] := 'Name';
  strgTrip.Cells[1, 0] := 'Dates of stay';
  strgTrip.Cells[2, 0] := 'Amount of people';
  strgTrip.Cells[3, 0] := 'Total price';

  qryAccomodationInfo := TADOQuery.Create(nil);
  with qryAccomodationInfo do
  begin
    connection := dmTravelRouter.connTravelRouterDB;
    SQL.Clear;
    SQL.Add('SELECT Place_Name, Arrival_Date, Departure_Date, Amount_of_Adults, Amount_of_Children, Adult_ppn, Child_ppn');
    SQL.Add('FROM Bookings');
    SQL.Add('INNER JOIN Accomodation ON Accomodation.Place_ID = Bookings.Accomodation_ID');
    SQL.Add('WHERE User_ID = :UserID');
    Parameters.ParamByName('UserID').Value := User.ID;
    Open;
  end;

  i := 1;
  qryAccomodationInfo.First;
  while not qryAccomodationInfo.Eof do
  begin
    strgTrip.RowCount := strgTrip.RowCount + 1;
    // Fill column cells of row
    strgTrip.Cells[0, i] := { name } qryAccomodationInfo['Place_Name'];
    strgTrip.Cells[1, i] := { arrive-leave } FormatDateTime('dd/mm/yy',
      qryAccomodationInfo['Arrival_Date']) + ' - ' + FormatDateTime('dd/mm/yy',
      qryAccomodationInfo['Departure_Date']);
    strgTrip.Cells[2, i] := { amount adults, amount kids } IntToStr
      (qryAccomodationInfo['Amount_of_Adults']) + ' adults, ' +
      IntToStr(qryAccomodationInfo['Amount_of_Children']) + ' children';
    strgTrip.Cells[3, i] :=
    { total price } formatfloat('R0.00',
      (qryAccomodationInfo['Amount_of_Adults'] * qryAccomodationInfo
      ['Adult_ppn'] * DaysBetween(qryAccomodationInfo['Arrival_Date'],
      qryAccomodationInfo['Departure_Date'])) +
      (qryAccomodationInfo['Amount_of_Children'] * qryAccomodationInfo
      ['Child_ppn'] * DaysBetween(qryAccomodationInfo['Arrival_Date'],
      qryAccomodationInfo['Departure_Date'])));

    inc(i);
    qryAccomodationInfo.Next;
  end;
end;

end.
