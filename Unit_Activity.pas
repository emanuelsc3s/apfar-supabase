unit Unit_Activity;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls;

type
  TForm_Activity = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Label_Status: TLabel;
    Panel3: TPanel;
    ActivityIndicator: TActivityIndicator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Activity: TForm_Activity;

implementation

{$R *.dfm}

end.
