unit UnitCarrinho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox;

type
  TFrmCarrinho = class(TForm)
    Label2: TLabel;
    Image2: TImage;
    btnadicionar: TButton;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    lblunidade: TLabel;
    Label1: TLabel;
    ListBox1: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation

{$R *.fmx}

uses UnitMercado;

end.
