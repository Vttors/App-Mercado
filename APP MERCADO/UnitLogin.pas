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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Login: TLogin;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

end.