unit Mainmenu_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfrmMainMenu = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainMenu: TfrmMainMenu;

implementation

{$R *.dfm}

procedure TfrmMainMenu.FormCreate(Sender: TObject);
begin
  left := (Screen.WorkAreaWidth div 2) - (frmMainMenu.Width div 2);
  top := (Screen.WorkAreaHeight div 2) - (frmMainMenu.Height div 2);
end;

end.
