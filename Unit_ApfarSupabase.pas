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
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, System.IniFiles,
  Vcl.ExtCtrls;

type
  TForm_Principal = class(TForm)
    FDConnectionSupabase: TFDConnection;
    qSupabase: TFDQuery;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    DBGrid1: TDBGrid;
    FDConnectionTOTVS: TFDConnection;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    qTOTVS: TFDQuery;
    DataSource1: TDataSource;
    btn_Importar: TPanel;
    btn_Fechar: TPanel;
    btn_Configurar: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_ImportarClick(Sender: TObject);
    procedure btn_ConfigurarClick(Sender: TObject);
    procedure btn_FecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

uses Unit_ConfigSqlServer;


procedure TForm_Principal.btn_FecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm_Principal.btn_ImportarClick(Sender: TObject);
const
  SQL_UPSERT =
    'INSERT INTO public.tbreceber (' +
    '  e1_recno, titulo, prefixo, tipo, saldo, valor, valor_pago,' +
    '  vencimento, emissao, data_baixa,' +
    '  cliente, cidade, uf, erp_cliente, obs, endereco, cep, cnpj, telefone,' +
    '  valor_mcompra, data_pcompra, data_ultimacompra, valor_limitecredito,' +
    '  bairro, maior_atraso, valor_desconto, valor_liquidado, cliente_ddd,' +
    '  cliente_pessoa, cliente_tipo, empenho, processo, updated_at' +
    ') VALUES (' +
    '  :e1_recno, :titulo, :prefixo, :tipo, :saldo, :valor, :valor_pago,' +
    '  :vencimento, :emissao, :data_baixa,' +
    '  :cliente, :cidade, :uf, :erp_cliente, :obs, :endereco, :cep, :cnpj, :telefone,' +
    '  :valor_mcompra, :data_pcompra, :data_ultimacompra, :valor_limitecredito,' +
    '  :bairro, :maior_atraso, :valor_desconto, :valor_liquidado, :cliente_ddd,' +
    '  :cliente_pessoa, :cliente_tipo, :empenho, :processo,' +
    '  (now() at time zone ''America/Sao_Paulo'')' +
    ') ON CONFLICT (e1_recno) DO UPDATE SET ' +
    '  titulo=EXCLUDED.titulo, prefixo=EXCLUDED.prefixo, tipo=EXCLUDED.tipo,' +
    '  saldo=EXCLUDED.saldo, valor=EXCLUDED.valor, valor_pago=EXCLUDED.valor_pago,' +
    '  vencimento=EXCLUDED.vencimento, emissao=EXCLUDED.emissao, data_baixa=EXCLUDED.data_baixa,' +
    '  cliente=EXCLUDED.cliente, cidade=EXCLUDED.cidade, uf=EXCLUDED.uf,' +
    '  erp_cliente=EXCLUDED.erp_cliente, obs=EXCLUDED.obs, endereco=EXCLUDED.endereco,' +
    '  cep=EXCLUDED.cep, cnpj=EXCLUDED.cnpj, telefone=EXCLUDED.telefone,' +
    '  valor_mcompra=EXCLUDED.valor_mcompra, data_pcompra=EXCLUDED.data_pcompra,' +
    '  data_ultimacompra=EXCLUDED.data_ultimacompra, valor_limitecredito=EXCLUDED.valor_limitecredito,' +
    '  bairro=EXCLUDED.bairro, maior_atraso=EXCLUDED.maior_atraso,' +
    '  valor_desconto=EXCLUDED.valor_desconto, valor_liquidado=EXCLUDED.valor_liquidado,' +
    '  cliente_ddd=EXCLUDED.cliente_ddd, cliente_pessoa=EXCLUDED.cliente_pessoa,' +
    '  cliente_tipo=EXCLUDED.cliente_tipo, empenho=EXCLUDED.empenho, processo=EXCLUDED.processo,' +
    '  updated_at=(now() at time zone ''America/Sao_Paulo'')';
var
  qUp: TFDQuery;
  fs: TFormatSettings;
  Ini: TIniFile;

  procedure SetDateParam(const PName: string; F: TField);
  var s: string; d: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftDate;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else
    begin
      // se a sua query do SQL Server já devolver DATE, use simplesmente:
      // qUp.ParamByName(PName).AsDate := F.AsDateTime;
      // Senão, parse dd/MM/yyyy:
      s := Trim(F.AsString);
      if s = '' then qUp.ParamByName(PName).Clear
      else if TryStrToDate(s, d, fs) then
        qUp.ParamByName(PName).AsDate := d
      else
        qUp.ParamByName(PName).Clear;
    end;
  end;

begin
  // formato para parse dd/MM/yyyy (somente se o SQL retornar texto)
  fs := TFormatSettings.Create;
  fs.DateSeparator   := '/';
  fs.ShortDateFormat := 'dd/MM/yyyy';

  FDConnectionSupabase.Connected     := True;

  if not Assigned(Form_ConfigSqlServer) then
    Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');
  try
    // Configura e conecta seu TFDConnection lá em Unit_ConfigSqlServer
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionTOTVS);
  finally
    Ini.Free;
  end;


  // 2) Abre o SELECT no SQL Server
  with qTOTVS do
  begin
    Close;
    Connection := FDConnectionTOTVS;

    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add(' SE1.R_E_C_N_O_ e1_recno,');
    SQL.Add(' SE1.E1_NUM titulo, SE1.E1_PREFIXO prefixo, SE1.E1_TIPO tipo, SE1.E1_SALDO saldo,');
    SQL.Add(' SE1.E1_VALOR valor, SE1.E1_VALOR - SE1.E1_SALDO valor_pago,');
    SQL.Add(' CASE WHEN SE1.E1_VENCREA <> '''' THEN CONVERT(VARCHAR,CAST(SE1.E1_VENCREA AS DATETIME),103)  END AS vencimento,');
    SQL.Add(' CASE WHEN SE1.E1_EMISSAO <> '''' THEN CONVERT(VARCHAR,CAST(SE1.E1_EMISSAO AS DATETIME),103) END AS emissao,');
    SQL.Add(' CASE WHEN SE1.E1_BAIXA   <> '''' THEN CONVERT(VARCHAR,CAST(SE1.E1_BAIXA AS DATETIME),103)   END AS data_baixa,');
    SQL.Add(' RTRIM(SA1.A1_NOME) cliente,');
    SQL.Add(' RTRIM(SA1.A1_MUN) cidade,');
    SQL.Add(' RTRIM(SA1.A1_EST) uf,');
    SQL.Add(' SE1.E1_CLIENTE erp_cliente, SE1.E1_HIST obs,');
    SQL.Add(' SA1.A1_END endereco,');
    SQL.Add(' SA1.A1_CEP cep,');
    SQL.Add(' SA1.A1_CGC cnpj,');
    SQL.Add(' SA1.A1_TEL telefone,');
    SQL.Add(' SA1.A1_MCOMPRA valor_mcompra,');
    SQL.Add(' CONVERT(VARCHAR,CAST(SA1.A1_PRICOM AS DATETIME),103) data_pcompra,');
    SQL.Add(' CONVERT(VARCHAR,CAST(SA1.A1_ULTCOM AS DATETIME),103) data_ultimacompra,');
    SQL.Add(' SA1.A1_LC valor_limitecredito,');
    SQL.Add(' SA1.A1_EST uf, SA1.A1_MUN cidade, SA1.A1_BAIRRO bairro, SA1.A1_MATR maior_atraso,');
    SQL.Add(' SE1.E1_DESCONT valor_desconto, SE1.E1_VALLIQ valor_liquidado, SA1.A1_DDD cliente_ddd,');
    SQL.Add(' CASE SA1.A1_PESSOA');
    SQL.Add(' WHEN ''F'' THEN ''Fisica''');
    SQL.Add(' WHEN ''J'' THEN ''Juridica''');
    SQL.Add(' END AS cliente_pessoa,');
    SQL.Add(' CASE SA1.A1_YTPCLI');
    SQL.Add(' WHEN ''1'' THEN ''Publico''');
    SQL.Add(' WHEN ''2'' THEN ''Privado''');
    SQL.Add(' WHEN ''3'' THEN ''Distribuidor''');
    SQL.Add(' WHEN ''4'' THEN ''Farmacias e Drogarias Privadas''');
    SQL.Add(' WHEN ''5'' THEN ''Demais Clientes''');
    SQL.Add(' END AS cliente_tipo,');
    SQL.Add(' SE1.E1_XEMPENH empenho, SE1.E1_XPROCES processo');
    SQL.Add(' FROM SE1010 (NOLOCK) SE1');
    SQL.Add(' LEFT JOIN SA1010 (NOLOCK) SA1 ON SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''''');
    SQL.Add(' WHERE SE1.D_E_L_E_T_ = ''''');
    SQL.Add(' AND ((SA1.A1_YENTREG = '''') OR (SA1.A1_YENTREG = ''N''))');
    SQL.Add(' AND SE1.E1_VEND1 = ''000050''');
    SQL.Add(' AND SE1.E1_TIPO NOT IN (''NCC'',''RA'')');
    SQL.Add(' AND SE1.E1_SUSPENS <> ''S''');
//    SQL.Add(' AND SE1.E1_SALDO > 0');
//    SQL.Add('-- AND DATEDIFF(DAY, CONVERT(DATETIME, SE1.E1_VENCREA, 112), GETDATE()) BETWEEN ''1'' AND ''99999''');

    SQL.Add(' ORDER BY SA1.A1_COD, SE1.E1_VENCREA');

  end;
  qTOTVS.Open;

  // 3) Prepara o UPSERT no Supabase
  qUp := TFDQuery.Create(nil);
  try
    qUp.Connection := FDConnectionSupabase;
    qUp.SQL.Text   := SQL_UPSERT;

    FDConnectionSupabase.StartTransaction;
    try
      qTOTVS.First;
      while not qTOTVS.Eof do
      begin
        qUp.ParamByName('e1_recno').DataType           := ftLargeint;
        qUp.ParamByName('e1_recno').AsLargeInt          := qTOTVS.FieldByName('e1_recno').AsLargeInt;
        qUp.ParamByName('titulo').AsString             := qTOTVS.FieldByName('titulo').AsString;
        qUp.ParamByName('prefixo').AsString            := qTOTVS.FieldByName('prefixo').AsString;
        qUp.ParamByName('tipo').AsString               := qTOTVS.FieldByName('tipo').AsString;
        qUp.ParamByName('saldo').AsFloat               := qTOTVS.FieldByName('saldo').AsFloat;
        qUp.ParamByName('valor').AsFloat               := qTOTVS.FieldByName('valor').AsFloat;
        qUp.ParamByName('valor_pago').AsFloat          := qTOTVS.FieldByName('valor_pago').AsFloat;

        SetDateParam('vencimento',        qTOTVS.FieldByName('vencimento'));
        SetDateParam('emissao',           qTOTVS.FieldByName('emissao'));
        SetDateParam('data_baixa',        qTOTVS.FieldByName('data_baixa'));
        SetDateParam('data_pcompra',      qTOTVS.FieldByName('data_pcompra'));
        SetDateParam('data_ultimacompra', qTOTVS.FieldByName('data_ultimacompra'));

        qUp.ParamByName('cliente').AsString            := qTOTVS.FieldByName('cliente').AsString;
        qUp.ParamByName('cidade').AsString             := qTOTVS.FieldByName('cidade').AsString;
        qUp.ParamByName('uf').AsString                 := qTOTVS.FieldByName('uf').AsString;
        qUp.ParamByName('erp_cliente').AsString        := qTOTVS.FieldByName('erp_cliente').AsString;
        qUp.ParamByName('obs').AsString                := qTOTVS.FieldByName('obs').AsString;
        qUp.ParamByName('endereco').AsString           := qTOTVS.FieldByName('endereco').AsString;
        qUp.ParamByName('cep').AsString                := qTOTVS.FieldByName('cep').AsString;
        qUp.ParamByName('cnpj').AsString               := qTOTVS.FieldByName('cnpj').AsString;
        qUp.ParamByName('telefone').AsString           := qTOTVS.FieldByName('telefone').AsString;
        qUp.ParamByName('valor_mcompra').AsFloat       := qTOTVS.FieldByName('valor_mcompra').AsFloat;
        qUp.ParamByName('valor_limitecredito').AsFloat := qTOTVS.FieldByName('valor_limitecredito').AsFloat;
        qUp.ParamByName('bairro').AsString             := qTOTVS.FieldByName('bairro').AsString;
        qUp.ParamByName('maior_atraso').AsInteger      := qTOTVS.FieldByName('maior_atraso').AsInteger;
        qUp.ParamByName('valor_desconto').AsFloat      := qTOTVS.FieldByName('valor_desconto').AsFloat;
        qUp.ParamByName('valor_liquidado').AsFloat     := qTOTVS.FieldByName('valor_liquidado').AsFloat;
        qUp.ParamByName('cliente_ddd').AsString        := qTOTVS.FieldByName('cliente_ddd').AsString;
        qUp.ParamByName('cliente_pessoa').AsString     := qTOTVS.FieldByName('cliente_pessoa').AsString;
        qUp.ParamByName('cliente_tipo').AsString       := qTOTVS.FieldByName('cliente_tipo').AsString;
        qUp.ParamByName('empenho').AsString            := qTOTVS.FieldByName('empenho').AsString;
        qUp.ParamByName('processo').AsString           := qTOTVS.FieldByName('processo').AsString;

        qUp.ExecSQL;
        qTOTVS.Next;
      end;

      FDConnectionSupabase.Commit;
      ShowMessage('Importação concluída com sucesso.');
    except
      on E: Exception do
      begin
        FDConnectionSupabase.Rollback;
        raise;
      end;
    end;
  finally
    qUp.Free;
  end;
end;

procedure TForm_Principal.btn_ConfigurarClick(Sender: TObject);
begin
  if not Assigned(Form_ConfigSqlServer) then
    Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);

  Form_ConfigSqlServer.ShowModal;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin

 // Referencia de conexão: https://supabase.com/docs/guides/database/pgadmin
//  libpq.dll compatível com a sua “bitness”
//  {$IFDEF WIN64}
//  FDPhysPgDriverLink1.VendorLib := ExtractFilePath(ParamStr(0)) + 'pgclient\win64\libpq.dll';
//  {$ELSE}
//  FDPhysPgDriverLink1.VendorLib := ExtractFilePath(ParamStr(0)) + 'pgclient\win32\libpq.dll';
//  {$ENDIF}

  FDConnectionSupabase.Params.Clear;
  FDConnectionSupabase.Params.Add('DriverID=PG');

  // ----- SUPABASE (MODO APP) -----
  FDConnectionSupabase.Params.Add('Server=aws-0-sa-east-1.pooler.supabase.com');
  FDConnectionSupabase.Params.Add('Port=5432'); // session pooler
  FDConnectionSupabase.Params.Add('Database=postgres');

  // usuário COM project-ref (ex.: postgres.dojavjvqvobnumebaouc)
  FDConnectionSupabase.Params.Add('User_Name=postgres.dojavjvqvobnumebaouc');
  FDConnectionSupabase.Params.Add('Password=aUilaqvCRLaFLOqr');

  // TLS obrigatório
  FDConnectionSupabase.Params.Add('SSLMode=require');

  // encoding
  FDConnectionSupabase.Params.Add('CharacterSet=UTF8');

  // extras
  FDConnectionSupabase.Params.Add('MetaDefSchema=public');
  FDConnectionSupabase.Params.Add('MetaCurSchema=public');
  FDConnectionSupabase.Params.Add('LoginTimeout=30');
  FDConnectionSupabase.LoginPrompt := False;

  try
    FDConnectionSupabase.Connected := True;
  except
    on E: Exception do ShowMessage('Erro: ' + E.Message);
  end;
end;

end.
