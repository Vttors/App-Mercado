unit Frame.ProdutoLista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TFrameProdutoLista = class(TFrame)
    lblvalor: TLabel;
    lbldescricao: TLabel;
    imgfoto: TImage;
    Layout1: TLayout;
    lblquant: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
