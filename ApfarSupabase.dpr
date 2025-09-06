program ApfarSupabase;

uses
  Vcl.Forms,
  Unit_ApfarSupabase in 'Unit_ApfarSupabase.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
