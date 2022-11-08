unit UnitCarrinho;
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  System.Net.HttpClientComponent;
type
    TFrmCarrinho = class(TForm)
    Label2: TLabel;
    Image2: TImage;
    btnadicionar: TButton;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    lblunidade: TLabel;
    lbltotal: TLabel;
    lbProdutos: TListBox;
    imglimparcarrinho: TImage;
    procedure FormShow(Sender: TObject);
    procedure imglimparcarrinhoClick(Sender: TObject);
    private
    Fid_produto: integer;
    procedure AddProduto(descricao: string; id_produto: integer;
                                 link: string; qtd: integer;
                                 valor: double);
    procedure CarregarCarrinho;
    procedure DownloadFoto(lb: TListBox);
    procedure LoadImageFromURL(img: TBitmap; url: string);
    procedure Qtd(valorqt: integer);
        { Private declarations }
  public
    property id_produto: integer read Fid_produto write Fid_produto;
    //property qtd_produto: integer read Fid_produto write Fid_produto;
    { Public declarations }
  end;
var
  FrmCarrinho: TFrmCarrinho;
implementation
{$R *.fmx}
uses UnitMercado, Frame.ProdutoLista,
  Firebase.Interfaces,
  Firebase.Auth,
  Firebase.Database,
  System.JSON,
  System.Net.HttpClient,
  System.Generics.Collections,
  System.JSON.Types,
  System.JSON.Writers, UnitLogin, UnitProduto;
procedure TFrmCarrinho.LoadImageFromURL(img: TBitmap; url: string);
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
 procedure TFrmCarrinho.DownloadFoto(lb: TListBox);
var
    t: TThread;
    foto: TBitmap;
    frame: TFrameProdutoLista;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := 0 to lb.Items.Count - 1 do
        begin
            //sleep(1000);
            frame := TFrameProdutoLista(lb.ItemByIndex(i).Components[0]);


            if frame.imgFoto.TagString <> '' then
            begin
                foto := TBitmap.Create;
                LoadImageFromURL(foto, frame.imgFoto.TagString);

                frame.imgFoto.TagString := '';
                frame.imgFoto.bitmap := foto;
            end;
        end;

    end);

    t.Start;
end;
procedure TFrmCarrinho.AddProduto(descricao: string; id_produto: integer;
                                 link: string; qtd: integer;
                                 valor: double);
var
    item: TListBoxItem;
    frame: TFrameProdutoLista;
    lbl: TLabel;
    total: double;

    begin
    item := TListBoxItem.Create(lbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 80;
    item.Tag := id_produto;
    //Frame
    frame := TFrameProdutoLista.Create(item);
    frame.lbldescricao.text := descricao;
    frame.lblvalor.text := FormatFloat('R$ #,##0.00', qtd * valor);
    frame.lblquant.text := qtd.ToString + ' x ' + FormatFloat('R$ #,##0.00', valor);
    frame.imgfoto.TagString := link;
    item.AddObject(frame);
    lbProdutos.AddObject(item);

    //total :=

    lbltotal.Text := FormatFloat('R$ #,##0.00', total);

end;
procedure TFrmCarrinho.CarregarCarrinho;
var
  ADatabase: TFirebaseDatabase;
  AResponse: IFirebaseResponse;
  AParams: TDictionary<string, string>;
  JSONResp: TJSONValue;
  x: integer;
  produto: TJsonArray;
  id, qtd: integer;
  valor: double;
  descricao, unidade, link: String;
const
  DOMAIN = 'https://tcc-4a9dc-default-rtdb.firebaseio.com';
begin

  if id_produto > 0 then
  begin
    //Acessar os dados no backend
    ADatabase := TFirebaseDatabase.Create;
    ADatabase.SetBaseURI(DOMAIN);
    ADatabase.SetToken(unitLogin.token);
    AParams := TDictionary<string, string>.Create;
    try
      //AParams.Add('orderBy', '"$key"');
      //AParams.Add('orderBy', '"cod"');
      //AParams.Add('limitToLast', '2');
      //AParams.Add('equalTo', '2');
      //AParams.Add('startAt', '"2"');
      //AParams.Add('endAt', '"4"');
      AResponse := ADatabase.Get(['/produtos.json'], AParams);
      JSONResp := TJSONObject.ParseJSONValue(AResponse.ContentAsString);
      produto :=    TJSONObject.ParseJSONValue(AResponse.ContentAsString) as TJSONArray;


      //for x := 1 to produto.Size -1 do
      //begin
        descricao := produto.Get(id_produto).GetValue<string>('descricao');
        id:= produto.Get(id_produto).GetValue<integer>('id_produto');
        link := produto.Get(id_produto).GetValue<string>('link');
        qtd := produto.Get(id_produto).GetValue<integer>('qtd');
        valor := produto.Get(id_produto).GetValue<double>('valor');


        AddProduto(descricao, id, link, qtd, valor);
      //end;
      DownloadFoto(LbProdutos);
      if (not Assigned(JSONResp)) or (not(JSONResp is TJSONObject)) then
      begin
        if Assigned(JSONResp) then
        begin
          JSONResp.Free;
        end;
        Exit;
      end;
      //memoResp.Lines.Add(JSONResp.ToString);
    finally
      AParams.Free;
      ADatabase.Free;
    end;
  end;
end;

procedure TFrmCarrinho.Qtd(valorqt: integer);
var

frame: TFrameProdutoLista;
lbl: TLabel;

begin
       //qtd := valorqt;
end;

procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
  CarregarCarrinho;
end;
procedure TFrmCarrinho.imglimparcarrinhoClick(Sender: TObject);
begin
     if id_produto > 0 then
     begin
     lbProdutos.Clear
     end;

end;

end.
