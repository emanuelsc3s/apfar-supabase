unit Unit_ApfarSupabase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, System.IniFiles;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    qSupabase: TFDQuery;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    DBGrid1: TDBGrid;
    btn_Importar: TButton;
    FDConnectionTOTVS: TFDConnection;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    qTOTVS: TFDQuery;
    DataSource1: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btn_ImportarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn_ImportarClick(Sender: TObject);
begin
  with qSupabase do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from tbreceber');
      Open;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  IniFile     : TIniFile;
  IniFileName : string;

  sServer, sDatabase, sUsername, sPassword,
  sNetwork, sAddress, sWorkstation, sAppName, sVendorLib,
  sOSAuthent, sMARS : string;

  OSAuthentValue, MARSValue, NetworkLibValue : string;
begin
 // Referencia de conexão: https://supabase.com/docs/guides/database/pgadmin
//  libpq.dll compatível com a sua “bitness”
//  {$IFDEF WIN64}
//  FDPhysPgDriverLink1.VendorLib := ExtractFilePath(ParamStr(0)) + 'pgclient\win64\libpq.dll';
//  {$ELSE}
//  FDPhysPgDriverLink1.VendorLib := ExtractFilePath(ParamStr(0)) + 'pgclient\win32\libpq.dll';
//  {$ENDIF}
  FDConnection1.Params.Clear;
  FDConnection1.Params.Add('DriverID=PG');
  // ----- SUPABASE (MODO APP) -----
  FDConnection1.Params.Add('Server=aws-0-sa-east-1.pooler.supabase.com');
  FDConnection1.Params.Add('Port=5432'); // session pooler
  FDConnection1.Params.Add('Database=postgres');
  // usuário COM project-ref (ex.: postgres.dojavjvqvobnumebaouc)
  FDConnection1.Params.Add('User_Name=postgres.dojavjvqvobnumebaouc');
  FDConnection1.Params.Add('Password=aUilaqvCRLaFLOqr');
  // TLS obrigatório
  FDConnection1.Params.Add('SSLMode=require');
  // encoding
  FDConnection1.Params.Add('CharacterSet=UTF8');
  // extras
  FDConnection1.Params.Add('MetaDefSchema=public');
  FDConnection1.Params.Add('MetaCurSchema=public');
  FDConnection1.Params.Add('LoginTimeout=30');
  FDConnection1.LoginPrompt := False;
  try
    FDConnection1.Connected := True;
  except
    on E: Exception do ShowMessage('Erro: ' + E.Message);
  end;
  // --- SQL Server (TOTVS) ---
  // Ler todos os valores do INI primeiro
  IniFileName := ExtractFilePath(Application.ExeName) + 'BaseSIC.ini';
  IniFile := TIniFile.Create(IniFileName);

  sServer           := IniFile.ReadString('Protheus', 'Server', '');
  sDatabase         := IniFile.ReadString('Protheus', 'Database', '');
  sUsername         := IniFile.ReadString('Protheus', 'Username', '');
//  sPassword         := Biblioteca.MyCrypt('D', IniFile.ReadString('Protheus', 'Password', ''));
  sNetwork          := IniFile.ReadString('Protheus', 'Network', '');
  sAddress          := IniFile.ReadString('Protheus', 'Address', '');
  sWorkstation      := IniFile.ReadString('Protheus', 'Workstation', '');
  sAppName          := IniFile.ReadString('Protheus', 'ApplicationName', '');
  sVendorLib        := IniFile.ReadString('Protheus', 'VendorLib', '');
  sOSAuthent        := IniFile.ReadString('Protheus', 'OSAuthent', 'False');
  sMARS             := IniFile.ReadString('Protheus', 'MARS', 'No');

  // Driver e parâmetros básicos
  FDConnection.Params.Clear;
  FDConnection.DriverName := 'MSSQL';
  FDConnection.Params.Add('Server='   + sServer);
  FDConnection.Params.Add('Database=' + sDatabase);

  // Autenticação integrada ou não
  sOSAuthent := AIniFile.ReadString('Protheus', 'OSAuthent', 'False');

  if SameText(sOSAuthent, 'Yes') then
    OSAuthentValue := 'Yes'
  else
    OSAuthentValue := 'No';

  FDConnection.Params.Add('OSAuthent=' + OSAuthentValue);

  // Se for SQL Auth, informe usuário e senha
  if OSAuthentValue = 'No' then
  begin
    FDConnectionTOTVS.Params.Add('User_Name=' + sUsername);
    FDConnectionTOTVS.Params.Add('Password='  + sPassword);
  end;

  // MARS
  if SameText(sMARS, 'Yes') then
    MARSValue := 'Yes'
  else
    MARSValue := 'No';

  FDConnectionTOTVS.Params.Add('MARS=' + MARSValue);

  // NetworkLibrary / Address
  if SameText(Trim(sNetwork), 'TCP/IP') then
    NetworkLibValue := 'DBMSSOCN'
  else if SameText(Trim(sNetwork), 'Named Pipes') then
    NetworkLibValue := 'DBNMPNTW'
  else
    NetworkLibValue := sNetwork;

  FDConnectionTOTVS.Params.Add('NetworkLibrary=' + NetworkLibValue);

  if Trim(sAddress) <> '' then
    FDConnectionTOTVS.Params.Add('NetworkAddress=' + sAddress);

  // WorkstationID, ApplicationName, VendorLib (se houver)
  if Trim(sWorkstation) <> '' then
    FDConnectionTOTVS.Params.Add('WorkstationID=' + sWorkstation);

  if Trim(sAppName) <> '' then
    FDConnectionTOTVS.Params.Add('ApplicationName=' + sAppName);

  if Trim(sVendorLib) <> '' then
    FDConnectionTOTVS.Params.Add('VendorLib=' + sVendorLib);

  // Conecta
  try
    FDConnectionTOTVS.Connected := True;
  except
    on E: Exception do
      ShowMessage('Falha ao conectar na TOTVS: ' + E.Message);
  end;
end;

end.
