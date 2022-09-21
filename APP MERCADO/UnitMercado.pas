unit UnitMercado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.ListBox;

type
  TFrmMercado = class(TForm)
    imgCarrinho: TImage;
    LytPesquisa: TLayout;
    StyleBook1: TStyleBook;
    RecPesquisa: TRectangle;
    Edit1: TEdit;
    Button1: TButton;
    Lbcategoria: TListBox;
    ListBoxItem1: TListBoxItem;
    Rectangle1: TRectangle;
    Label1: TLabel;
    ListBoxItem2: TListBoxItem;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Libprodutos: TListBox;
    imgmenu: TImage;
    Rectmenu: TRectangle;
    Image1: TImage;
    imgfecharmenu: TImage;
    Label3: TLabel;
    Label4: TLabel;
    rectlogoff: TRectangle;
    Label5: TLabel;
    rectperfil: TRectangle;
    Label6: TLabel;
    rectpedidos: TRectangle;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LbcategoriaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure LibprodutosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure imgCarrinhoClick(Sender: TObject);
    procedure imgmenuClick(Sender: TObject);
    procedure imgfecharmenuClick(Sender: TObject);
  private
    procedure AddProduto(id_produto: integer; descricao, unidade: string;
      valor: double);
    procedure ListarProdutos;
    procedure ListarCategorias;
    procedure AddCategoria(id_categoria: integer; descricao: string);
    procedure SelecionarCategoria(item: TListBoxItem);
    procedure OpenMenu(ind: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMercado: TFrmMercado;

implementation

{$R *.fmx}

uses UnitLogin, FrameProdutoCard, UnitProduto, UnitCarrinho;

procedure TFrmMercado.AddProduto(id_produto: integer;
                                 descricao, unidade: string;
                                 valor: double);
var
    item: TListBoxItem;
    frame: TFrameProdutoCard1;

    begin
    item := TListBoxItem.Create(Libprodutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 200;
    item.Tag := id_produto;

    //Frame
    frame := TFrameProdutoCard1.Create(item);
    //frame.imgfoto.bitmap :=
    frame.lbldescricao.text := descricao;
    frame.lblvalor.text := FormatFloat('R$ #,##0.00', valor);
    frame.lblunidade.text := unidade;

     item.AddObject(frame);

    Libprodutos.AddObject(item);
end;

procedure TFrmMercado.ListarProdutos;
begin
//Acessar os dados no backend

    AddProduto(0, 'Café Pilão Torrado e Moído', '500g', 15);
    AddProduto(0, 'Café Pilão Torrado e Moído', '500g', 15);
    AddProduto(0, 'Café Pilão Torrado e Moído', '500g', 15);
    AddProduto(0, 'Café Pilão Torrado e Moído', '500g', 15);
    AddProduto(0, 'Café Pilão Torrado e Moído', '500g', 15);
end;

procedure TFrmMercado.SelecionarCategoria (item: TListBoxItem);
var
  x: integer;
  item_loop: TListBoxItem;
  rect: TRectangle;
  lbl: TLabel;

begin
  //zerar itens
  for x := 0 to Lbcategoria.Items.Count -1 do
  begin
     item_loop := Lbcategoria.ItemByIndex(x);

     rect := TRectangle(item_loop.Components[0]);
     rect.Fill.Color := $FFE2E2E2;

     lbl := TLabel(rect.Components[0]);
     lbl.FontColor := $FFA3A3A3;
  end;

  //ajusta somente o item selecionado

   rect := TRectangle(item.Components[0]);
   rect.Fill.Color := $FFBE6BFF;

   lbl := TLabel(rect.Components[0]);
   lbl.FontColor := $FF134C76;

   //salvar a categoria selecionada
   Lbcategoria.Tag := item.Tag;

end;

procedure TFrmMercado.AddCategoria(id_categoria: integer;
                                   descricao: string);

var item: TListBoxItem;
    rect: TRectangle;
    lbl: TLabel;

begin
    item := TListBoxItem.Create(lbCategoria);
    item.Selectable := false;
    item.Text := '';
    item.Width := 130;
    item.Tag := id_categoria;

    rect := TRectangle.Create(item);
    rect.Cursor := crHandPoint;
    rect.HitTest := false;
    rect.Fill.Color := $FFE2E2E2;
    rect.Align := TAlignLayout.Client;
    rect.Margins.Top := 5;
    rect.Margins.Left := 5;
    rect.Margins.Right := 5;
    rect.Margins.Bottom := 5;
    rect.XRadius := 6;
    rect.YRadius := 6;
    rect.Stroke.Kind := TBrushKind.None;

    lbl := Tlabel.Create(rect);
    lbl.Align := TAlignLayout.Client;
    lbl.Text := descricao;
    lbl.TextSettings.HorzAlign := TTextAlign.Center;
    lbl.TextSettings.VertAlign := TTextAlign.Center;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size,
                                                TStyledSetting.FontColor,
                                                TStyledSetting.Style,
                                                TStyledSetting.Other];
    lbl.Font.Size := 12;
    lbl.FontColor := $FFA3A3A3;

    rect.AddObject(lbl);
    item.AddObject(rect);
    Lbcategoria.AddObject(item);
end;

procedure TFrmMercado.LbcategoriaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
     SelecionarCategoria(item);
end;

procedure TFrmMercado.LibprodutosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    if NOT Assigned(FrmProduto) then
      Application.CreateForm(TFrmProduto, FrmProduto);

      FrmProduto.Show;

end;

procedure TFrmMercado.ListarCategorias;

begin
    Lbcategoria.Items.Clear;

    AddCategoria(0, 'Alimentos');
    AddCategoria(1, 'Bebidas');
    AddCategoria(2, 'Limpeza');
    AddCategoria(3, 'Pets');

    ListarProdutos;
end;
procedure TFrmMercado.FormShow(Sender: TObject);
begin
   ListarCategorias;
end;

procedure TFrmMercado.imgCarrinhoClick(Sender: TObject);
begin
    if NOT Assigned(FrmCarrinho) then
      Application.CreateForm(TfrmCarrinho, FrmCarrinho);

    FrmCarrinho.Show;
end;

procedure TFrmMercado.imgfecharmenuClick(Sender: TObject);
begin
    OpenMenu(false);
end;

procedure TFrmMercado.OpenMenu(ind: boolean);
begin
  rectMenu.Visible := ind;
end;

procedure TFrmMercado.imgmenuClick(Sender: TObject);
begin
    OpenMenu(true);
end;

end.
