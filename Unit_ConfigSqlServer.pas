unit Unit_ConfigSqlServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IniFiles, // Para TIniFile
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.ODBCBase, Data.DB;

type
  TForm_ConfigSqlServer = class(TForm)
    Panel1: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    EditServer: TEdit;
    EditDatabase: TEdit;
    EditUsername: TEdit;
    EditPassword: TEdit;
    EditNetwork: TEdit;
    EditAddress: TEdit;
    ComboBoxOSAuthent: TComboBox;
    ComboBoxMARS: TComboBox;
    EditWorkstation: TEdit;
    EditApplicationName: TEdit;
    EditVendorLib: TEdit;
    btnSalvar: TPanel;
    btnFechar: TPanel;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConfigureAndConnectFDConnection(AIniFile: TIniFile; AFDConnection: TFDConnection);
  end;

var
  Form_ConfigSqlServer: TForm_ConfigSqlServer;

implementation

{$R *.dfm}

uses Biblioteca;

procedure TForm_ConfigSqlServer.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_ConfigSqlServer.btnSalvarClick(Sender: TObject);
var
  IniFile        : TIniFile;
  IniFileName    : string;
  OSAuthentValue : string;
  MARSValue      : string;
begin
  // Criar o caminho completo para o arquivo INI
  IniFileName := ExtractFilePath(Application.ExeName) + 'BaseSIC.ini';
  IniFile := TIniFile.Create(IniFileName);
  try
    try
      // Salvar as configurações no arquivo INI na seção [Protheus]
      IniFile.WriteString('Protheus', 'Server',      Trim(EditServer.Text));
      IniFile.WriteString('Protheus', 'Database',    Trim(EditDatabase.Text));
      IniFile.WriteString('Protheus', 'Username',    Trim(EditUsername.Text));
      IniFile.WriteString('Protheus', 'Password',    Biblioteca.MyCrypt('C', Trim(EditPassword.Text)));  // Criptografar senha
      IniFile.WriteString('Protheus', 'Network',     Trim(EditNetwork.Text));
      IniFile.WriteString('Protheus', 'Address',     Trim(EditAddress.Text));
      IniFile.WriteString('Protheus', 'Workstation', Trim(EditWorkstation.Text));
      IniFile.WriteString('Protheus', 'ApplicationName', Trim(EditApplicationName.Text));
      IniFile.WriteString('Protheus', 'VendorLib',   Trim(EditVendorLib.Text));

      // Verificar o valor do ComboBoxOSAuthent (True/False)
      if ComboBoxOSAuthent.ItemIndex = 0 then
        OSAuthentValue := 'True'
      else
        OSAuthentValue := 'False';

      IniFile.WriteString('Protheus', 'OSAuthent', OSAuthentValue);

      // Verificar o valor do ComboBoxMARS (Yes/No)
      if ComboBoxMARS.ItemIndex = 0 then
        MARSValue := 'Yes'
      else
        MARSValue := 'No';

      IniFile.WriteString('Protheus', 'MARS', MARSValue);

      // Exibir uma mensagem de sucesso
      ShowMessage('Configurações salvas com sucesso!');
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao tentar salvar as configurações: ' + E.Message);
      end;
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TForm_ConfigSqlServer.FormCreate(Sender: TObject);
//var
//  IniFile     : TIniFile;
//  IniFileName : string;
begin
  // Criar o caminho completo para o arquivo INI
//  IniFileName := ExtractFilePath(Application.ExeName) + 'BaseSIC.ini';
//  IniFile     := TIniFile.Create(IniFileName);
//  try
//  ConfigureAndConnectFDConnection(IniFile);
//  finally
//    IniFile.Free;
//  end;
end;

procedure TForm_ConfigSqlServer.FormShow(Sender: TObject);
var
  IniFile     : TIniFile;
  IniFileName : string;
  OSAuthent   : string;
  MARS        : string;
begin
  // Criar o caminho completo para o arquivo INI
  IniFileName := ExtractFilePath(Application.ExeName) + 'BaseSIC.ini';
  IniFile := TIniFile.Create(IniFileName);
  try
    // Carregar as configurações da seção [Protheus] do arquivo INI
    EditServer.Text            := IniFile.ReadString('Protheus', 'Server',   '');
    EditDatabase.Text          := IniFile.ReadString('Protheus', 'Database', '');
    EditUsername.Text          := IniFile.ReadString('Protheus', 'Username', '');
    EditPassword.Text          := Biblioteca.MyCrypt('D', IniFile.ReadString('Protheus', 'Password', ''));
    EditNetwork.Text           := IniFile.ReadString('Protheus', 'Network', '');
    EditAddress.Text           := IniFile.ReadString('Protheus', 'Address', '');
    EditWorkstation.Text       := IniFile.ReadString('Protheus', 'Workstation', '');
    EditApplicationName.Text   := IniFile.ReadString('Protheus', 'ApplicationName', '');
    EditVendorLib.Text         := IniFile.ReadString('Protheus', 'VendorLib', '');

    // Carregar o valor de OSAuthent (True/False) e selecionar a opção correta no ComboBox
    OSAuthent := IniFile.ReadString('Protheus', 'OSAuthent', 'False');

    if OSAuthent = 'Yes' then
      ComboBoxOSAuthent.ItemIndex := 0  // Sim (True)
    else
      ComboBoxOSAuthent.ItemIndex := 1; // Não (False)
    // Carregar o valor de MARS (Yes/No) e selecionar a opção correta no ComboBox

    MARS := IniFile.ReadString('Protheus', 'MARS', 'No');

//    ConfigureAndConnectFDConnection();

    if MARS = 'Yes' then
      ComboBoxMARS.ItemIndex := 0  // Yes
    else
      ComboBoxMARS.ItemIndex := 1; // No
  finally
    IniFile.Free;
  end;
end;

procedure TForm_ConfigSqlServer.ConfigureAndConnectFDConnection(AIniFile: TIniFile; AFDConnection: TFDConnection);
var
  sServer, sDatabase, sUsername, sPassword,
  sNetwork, sAddress, sWorkstation, sAppName, sVendorLib,
  sOSAuthent, sMARS : string;

  OSAuthentValue, MARSValue, NetworkLibValue : string;
begin
  if not Assigned(AFDConnection) then
  begin
    ShowMessage('Componente FDConnection não encontrado.');
    Exit;
  end;

  // Ler todos os valores do INI primeiro
  sServer           := AIniFile.ReadString('Protheus', 'Server', '');
  sDatabase         := AIniFile.ReadString('Protheus', 'Database', '');
  sUsername         := AIniFile.ReadString('Protheus', 'Username', '');
  sPassword         := Biblioteca.MyCrypt('D', AIniFile.ReadString('Protheus', 'Password', ''));
  sNetwork          := AIniFile.ReadString('Protheus', 'Network', '');
  sAddress          := AIniFile.ReadString('Protheus', 'Address', '');
  sWorkstation      := AIniFile.ReadString('Protheus', 'Workstation', '');
  sAppName          := AIniFile.ReadString('Protheus', 'ApplicationName', '');
  sVendorLib        := AIniFile.ReadString('Protheus', 'VendorLib', '');
  sOSAuthent        := AIniFile.ReadString('Protheus', 'OSAuthent', 'False');
  sMARS             := AIniFile.ReadString('Protheus', 'MARS', 'No');

  // Driver e parâmetros básicos
  AFDConnection.Params.Clear;
  AFDConnection.DriverName := 'MSSQL';
  AFDConnection.Params.Add('Server='   + sServer);
  AFDConnection.Params.Add('Database=' + sDatabase);

  // Autenticação integrada ou não
  sOSAuthent := AIniFile.ReadString('Protheus', 'OSAuthent', 'False');

  if SameText(sOSAuthent, 'Yes') then
    OSAuthentValue := 'Yes'
  else
    OSAuthentValue := 'No';

  AFDConnection.Params.Add('OSAuthent=' + OSAuthentValue);

  // Se for SQL Auth, informe usuário e senha
  if OSAuthentValue = 'No' then
  begin
    AFDConnection.Params.Add('User_Name=' + sUsername);
    AFDConnection.Params.Add('Password='  + sPassword);
  end;

  // MARS
  if SameText(sMARS, 'Yes') then
    MARSValue := 'Yes'
  else
    MARSValue := 'No';

  AFDConnection.Params.Add('MARS=' + MARSValue);

  // NetworkLibrary / Address
  if SameText(Trim(sNetwork), 'TCP/IP') then
    NetworkLibValue := 'DBMSSOCN'
  else if SameText(Trim(sNetwork), 'Named Pipes') then
    NetworkLibValue := 'DBNMPNTW'
  else
    NetworkLibValue := sNetwork;

  AFDConnection.Params.Add('NetworkLibrary=' + NetworkLibValue);

  if Trim(sAddress) <> '' then
    AFDConnection.Params.Add('NetworkAddress=' + sAddress);

  // WorkstationID, ApplicationName, VendorLib (se houver)
  if Trim(sWorkstation) <> '' then
    AFDConnection.Params.Add('WorkstationID=' + sWorkstation);
  if Trim(sAppName) <> '' then
    AFDConnection.Params.Add('ApplicationName=' + sAppName);
  if Trim(sVendorLib) <> '' then
    AFDConnection.Params.Add('VendorLib=' + sVendorLib);

  // Conecta
  try
    AFDConnection.Connected := True;
  except
    on E: Exception do
      ShowMessage('Falha ao conectar na TOTVS: ' + E.Message);
  end;
end;

end.
