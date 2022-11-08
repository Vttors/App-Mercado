unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TLogin = class(TForm)
    Image1: TImage;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Layout1: TLayout;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    StyleBook1: TStyleBook;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //function setToken(value: String): String;
  end;
var
  Login: TLogin;
  token: String;

implementation
uses
  Firebase.Interfaces,
  Firebase.Auth,
  Firebase.Database,
  System.JSON,
  System.Net.HttpClient,
  System.Generics.Collections,
  System.JSON.Types,
  System.JSON.Writers,
  UnitMercado;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

function setToken(value: String): String;
begin
  token := value
end;

function getToken(): String;
begin
  Result := token;
end;

procedure TLogin.Button1Click(Sender: TObject);
var
  Auth: IFirebaseAuth;
  AResponse: IFirebaseResponse;
  JSONResp: TJSONValue;
  Obj: TJSONObject;
const
  API_KEY = 'AIzaSyCDU505sOjvy3IZnSpoyyNF_L1AvydKDi8';
begin
  Auth := TFirebaseAuth.Create;
  Auth.SetApiKey(API_KEY);
  AResponse := Auth.SignInWithEmailAndPassword(edit1.Text, edit2.Text);
  JSONResp := TJSONObject.ParseJSONValue(AResponse.ContentAsString);
  if (not Assigned(JSONResp)) or (not(JSONResp is TJSONObject)) then
  begin
    if Assigned(JSONResp) then
    begin
      JSONResp.Free;
    end;
    Exit;
  end;
  Obj := JSONResp as TJSONObject;
  Obj.Values['idToken'].Value;
  token := Obj.Values['idToken'].Value;
  if NOT Assigned(FRmMercado) then
    Application.CreateForm(TFRmMercado, FrmMercado);

    FRmMercado.Show;
  //memoToken.Lines.Add(JSONResp.ToString);

end;

end.
