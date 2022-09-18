program Mercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {Login},
  UnitMercado in 'UnitMercado.pas' {FrmMercado},
  FrameProdutoCard in 'Frames\FrameProdutoCard.pas' {FrameProdutoCard1: TFrame},
  UnitSpalsh in 'UnitSpalsh.pas' {FormSplash},
  UnitProduto in 'UnitProduto.pas' {FrmProduto},
  UnitCarrinho in 'UnitCarrinho.pas' {FrmCarrinho},
  Frame.ProdutoLista in 'Frames\Frame.ProdutoLista.pas' {FrameProdutoLista: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormSplash, FormSplash);
  Application.CreateForm(TFrmMercado, FrmMercado);
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TFrmProduto, FrmProduto);
  Application.CreateForm(TFrmCarrinho, FrmCarrinho);
  Application.Run;
end.
