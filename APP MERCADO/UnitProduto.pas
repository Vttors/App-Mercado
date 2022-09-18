unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmProduto = class(TForm)
    Image2: TImage;
    lytfoto: TLayout;
    Image3: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    lblunidade: TLabel;
    lblvalor: TLabel;
    lbldescrição: TLabel;
    Rectrodape: TRectangle;
    Layout3: TLayout;
    imgmais: TImage;
    imgmenos: TImage;
    lblquant: TLabel;
    btnadicionar: TButton;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitMercado;

end.
