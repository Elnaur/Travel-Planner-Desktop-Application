unit Mainmenu_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.StdCtrls;

type
  TfrmMainMenu = class(TForm)
    imgBackground: TImage;
    pcMainmenu: TPageControl;
    pnlCurrentTrip: TPanel;
    pnlPlanTrip: TPanel;
    imgSettings: TImage;
    tsCurrentTrip: TTabSheet;
    tsPlanTrip: TTabSheet;
    pnlTabHolder: TPanel;
    imCTBackground: TImage;
    imgPTBackground: TImage;
    tsSettings: TTabSheet;
    imgSBackground: TImage;
    lblCTHeading2: TLabel;
    lblCTHeading1: TLabel;
    lblPTHeading1: TLabel;
    lblPTHeading2: TLabel;
    lblSHeading1: TLabel;
    lblSHeading2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlCurrentTripClick(Sender: TObject);
    procedure pnlPlanTripClick(Sender: TObject);
    procedure imgSettingsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainMenu: TfrmMainMenu;

const
  clBase = $00C8CCA8;
  clSelected = $007B814B;
  clSecondary = $009FA666;

implementation

{$R *.dfm}

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

end.
