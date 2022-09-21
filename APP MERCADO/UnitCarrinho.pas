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
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
  private
    procedure AddProduto(id_produto: integer; descricao: string; qtd,
      valor_unit: double; foto: TStream);
    procedure CarregarCarrinho;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation

{$R *.fmx}

uses UnitMercado, Frame.ProdutoLista;

procedure TFrmCarrinho.AddProduto(id_produto: integer;
                                 descricao: string;
                                 qtd, valor_unit: double;
                                 foto: TStream);
var
    item: TListBoxItem;
    frame: TFrameProdutoLista;

    begin
    item := TListBoxItem.Create(lbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 80;
    item.Tag := id_produto;

    //Frame
    frame := TFrameProdutoLista.Create(item);
    //frame.imgfoto.bitmap :=
    frame.lbldescricao.text := descricao;
    frame.lblvalor.text := FormatFloat('R$ #,##0.00', qtd * valor_unit);
    frame.lblquant.text := qtd.ToString + ' x ' + FormatFloat('R$ #,##0.00', valor_unit);

     item.AddObject(frame);

    lbProdutos.AddObject(item);
end;

procedure TFrmCarrinho.CarregarCarrinho;
begin
       AddProduto(0, 'Caf� Pil�o', 2, 15, nil);
       AddProduto(0, 'Caf� Pil�o', 2, 15, nil);
       AddProduto(0, 'Caf� Pil�o', 2, 15, nil);
       AddProduto(0, 'Caf� Pil�o', 2, 15, nil);
end;
procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
  CarregarCarrinho;
end;

end.
