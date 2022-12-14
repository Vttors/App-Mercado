unit UnitProduto;
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, System.Net.HttpClientComponent;
type
  TFrmProduto = class(TForm)
    Image2: TImage;
    lytfoto: TLayout;
    imgfoto: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    lblunidade: TLabel;
    lblvalor: TLabel;
    lbltexto: TLabel;
    Rectrodape: TRectangle;
    Layout3: TLayout;
    imgmais: TImage;
    imgmenos: TImage;
    lblqtd: TLabel;
    btnadicionar: TButton;
    lbldescricao: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnadicionarClick(Sender: TObject);
    procedure imgmenosClick(Sender: TObject);
  private
    qtd_carrinho, qtd_maximo: integer;
    Fid_produto: integer;
    procedure CriarProduto(descricao: string; id_produto:integer; link: string; texto: string;
    unidade: string; valor: double);
    procedure CarregarDados;
    procedure DownloadFoto(img: TImage);
    procedure LoadImageFromURL(img: TBitmap; url: string);
    procedure AdicionarItemCarrinho(descricao: string; id_produto:integer; link: string; qtd: integer;
    valor: double);
    procedure Qtd(valorqt: integer);
    { Private declarations }
  public
    property id_produto: integer read Fid_produto write Fid_produto;
    { Public declarations }
  end;
var
  FrmProduto: TFrmProduto;
implementation
{$R *.fmx}
uses UnitMercado,
  Firebase.Interfaces,
  Firebase.Auth,
  Firebase.Database,
  System.JSON,
  System.Net.HttpClient,
  System.Generics.Collections,
  System.JSON.Types,
  System.JSON.Writers, UnitLogin, FrameProdutoCard, UnitCarrinho,
  Frame.ProdutoLista;

procedure TFrmProduto.LoadImageFromURL(img: TBitmap; url: string);
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    try
        try
            http := TNetHTTPClient.Create(nil);
            vStream :=  TMemoryStream.Create;

            if (Pos('https', LowerCase(url)) > 0) then
                  HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                            THTTPSecureProtocol.TLS11,
                                            THTTPSecureProtocol.TLS12];

            http.Get(url, vStream);
            vStream.Position  :=  0;


            img.LoadFromStream(vStream);
        except
        end;

    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;
end;

 procedure TFrmProduto.DownloadFoto(img: TImage);
var
    t: TThread;
    foto: TBitmap;
    //frame: TFrameProdutoCard1;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := id_produto to imgfoto.Tag + id_produto do
        begin
            //sleep(1000);
            //frame := TFrameProdutoCard1(lb.ItemByIndex(i).Components[0]);


            if imgFoto.TagString <> '' then
            begin
                foto := TBitmap.Create;
                LoadImageFromURL(foto, imgFoto.TagString);

                imgFoto.TagString := '';
                imgFoto.bitmap := foto;
            end;
        end;

    end);

    t.Start;
end;
 procedure TFrmProduto.CriarProduto(descricao: string; id_produto:integer; link: string;
 texto: string; unidade: string; valor: double);
var
    lbl: TLabel;
    img: TImage;
begin

  lbldescricao.Text := descricao;
  imgfoto.TagString := link;
  //lblqtd.Text := FormatFloat('##', qtd);
  lbltexto.Text := texto;
  lblunidade.Text := unidade;
  lblvalor.Text := FormatFloat('R$ #,##0.00', valor);


  end;


procedure TFrmProduto.CarregarDados;

var
  ADatabase: TFirebaseDatabase;
  AResponse: IFirebaseResponse;
  AParams: TDictionary<string, string>;
  JSONResp: TJSONValue;
  x: integer;
  produto: TJsonArray;
  id: integer;
  valor: double;
  descricao, unidade, texto, link,teste: String;
const
  DOMAIN = 'https://tcc-4a9dc-default-rtdb.firebaseio.com';
begin
  qtd(0);
//Acessar os dados no backend
  ADatabase := TFirebaseDatabase.Create;
  ADatabase.SetBaseURI(DOMAIN);
  ADatabase.SetToken(unitLogin.token);
  AParams := TDictionary<string, string>.Create;


  AResponse := ADatabase.Get(['/app/' + id_produto.ToString + '.json'], AParams);
  qtd_maximo := AResponse.ContentAsString.ToInteger;

  try
    AResponse := ADatabase.Get(['/usuarios/' + localId + '/carrinho.json'], AParams);
    if AResponse.ContentAsString.CompareTo('""').ToBoolean then
    begin
      qtd_carrinho := (TJSONObject.ParseJSONValue(AResponse.ContentAsString) as TJSONArray).Count;
    end
    else
    begin
       qtd_carrinho := 1;
    end;
    AResponse := ADatabase.Get(['/produtos.json'], AParams);
    JSONResp := TJSONObject.ParseJSONValue(AResponse.ContentAsString);
    produto :=    TJSONObject.ParseJSONValue(AResponse.ContentAsString) as TJSONArray;
      link := produto.Get(id_produto).GetValue<string>('link');
      imgfoto.TagString := 'link';
      descricao := produto.Get(id_produto).GetValue<string>('descricao');
      id:= produto.Get(id_produto).GetValue<integer>('id_produto');
      texto := produto.Get(id_produto).GetValue<string>('texto');
      unidade := produto.Get(id_produto).GetValue<string>('unidade');
      valor := produto.Get(id_produto).GetValue<double>('valor');

      LoadImageFromURL(imgfoto.Bitmap, 'link');

      CriarProduto(descricao, id, link, texto, unidade, valor);
      DownloadFoto(imgfoto);

    if (not Assigned(JSONResp)) or (not(JSONResp is TJSONObject)) then
      begin
      if Assigned(JSONResp) then
        begin
        JSONResp.Free;
        end;
      Exit;
      end;
    finally
    AParams.Free;
    ADatabase.Free;
    end;
  end;

  procedure TFrmProduto.FormShow(Sender: TObject);
begin
      CarregarDados;
end;

procedure TFrmProduto.Qtd(valorqt: integer);
begin
     try
        if valorqt = 0 then
            lblqtd.Tag  := 1
        else
            lblqtd.Tag := lblqtd.Tag + valorqt;

        if lblqtd.Tag <= 0 then
            lblqtd.Tag := 1

        else if lblqtd.Tag > qtd_maximo then
             lblqtd.Tag := qtd_maximo;

     except
         lblqtd.Tag := 1;
     end;

      lblqtd.Text := FormatFloat('##', lblqtd.Tag);
end;

procedure TFrmProduto.imgmenosClick(Sender: TObject);
begin
      Qtd(TImage(Sender).Tag);
end;

procedure TFrmProduto.btnadicionarClick(Sender: TObject);
var
  frame: TFrameProdutoLista;
  ADatabase: TFirebaseDatabase;
  AResponse: IFirebaseResponse;
  JSONReq: TJSONObject;
  JSONResp: TJSONValue;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
const
  DOMAIN = 'https://tcc-4a9dc-default-rtdb.firebaseio.com';
begin


  if NOT Assigned(FrmCarrinho) then
    Application.CreateForm(TFrmCarrinho, FrmCarrinho);

  StringWriter := TStringWriter.Create();
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.None;
  //Escrevendo os dados
  Writer.WriteStartObject;
  Writer.WritePropertyName(qtd_carrinho.ToString);
  Writer.WriteStartObject;
  Writer.WritePropertyName('id_produto');
  Writer.WriteValue(id_produto);
  Writer.WritePropertyName('valor');
  Writer.WriteValue(lblvalor.Text.Remove(0,3).ToDouble);
  Writer.WritePropertyName('qtd');
  Writer.WriteValue(lblqtd.Text.toInteger);
  Writer.WriteEndObject;
  Writer.WriteEndObject;

  JSONReq := TJSONObject.ParseJSONValue(StringWriter.ToString) as TJSONObject;

  ADatabase := TFirebaseDatabase.Create;

  ADatabase.SetBaseURI(DOMAIN);
  ADatabase.SetToken(token);

  try
    AResponse := ADatabase.Patch(['/usuarios/' + localId + '/carrinho.json'], JSONReq);
    qtd_carrinho := qtd_carrinho + 1;

    JSONResp := TJSONObject.ParseJSONValue(AResponse.ContentAsString);
    if (not Assigned(JSONResp)) or (not(JSONResp is TJSONObject)) then
    begin
      if Assigned(JSONResp) then
      begin
        JSONResp.Free;
      end;
      Exit;
    end;
  finally
    ADatabase.Free;
  end;

  FrmCarrinho.Show;
end;


procedure TFrmProduto.AdicionarItemCarrinho(descricao: string; id_produto:integer; link: string;
qtd: integer; valor: double);
begin

end;

end.
