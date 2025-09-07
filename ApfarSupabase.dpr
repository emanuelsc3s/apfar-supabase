program ApfarSupabase;

uses
  Vcl.Forms,
  Unit_ApfarSupabase in 'Unit_ApfarSupabase.pas' {Form_Principal},
  Unit_ConfigSqlServer in 'Unit_ConfigSqlServer.pas' {Form_ConfigSqlServer},
  Biblioteca in 'Biblioteca.pas',
  Unit_Activity in 'Unit_Activity.pas' {Form_Activity};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
