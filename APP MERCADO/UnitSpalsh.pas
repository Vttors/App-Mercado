unit UnitSpalsh;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects;

type
  TFormSplash = class(TForm)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSplash: TFormSplash;

implementation

{$R *.fmx}

uses UnitLogin;

procedure TFormSplash.Image1Click(Sender: TObject);
begin
   if NOT Assigned(Login) then
    Application.CreateForm(TLogin, Login);

    Login.Show;
end;

end.
