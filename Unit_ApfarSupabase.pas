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
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, FireDAC.Phys.FB, FireDAC.Phys.FBDef, System.IniFiles,
  Vcl.ExtCtrls, FireDAC.Phys.IBBase;

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
    btn_ImportarReceber: TPanel;
    btn_Fechar: TPanel;
    btn_Configurar: TPanel;
    btn_ImportarLicitacao: TPanel;
    btn_ImportarLoteDesvio: TPanel;
    FDConnectionSICFAR: TFDConnection;
    qSICFAR: TFDQuery;
    FBDriverLink: TFDPhysFBDriverLink;
    btn_Cliente: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_ImportarReceberClick(Sender: TObject);
    procedure btn_ConfigurarClick(Sender: TObject);
    procedure btn_FecharClick(Sender: TObject);
    procedure btn_ImportarLoteDesvioClick(Sender: TObject);
    procedure btn_ImportarLicitacaoClick(Sender: TObject);
    procedure btn_ClienteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

uses Unit_ConfigSqlServer, Unit_Activity;


procedure TForm_Principal.btn_FecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm_Principal.btn_ImportarLicitacaoClick(Sender: TObject);
const
  WHERE_CLAUSE =
    ' WHERE pessoa_vr in (''16531'',''11020'')';

  SQL_UPSERT =
    'INSERT INTO public.tblicitacao (' +
    '  licitacao_id, cliente_id, orgao_id, data, processo, processo_ano,' +
    '  processo_admin, processo_admin_ano, portaria, portaria_ano,' +
    '  modalidade_id, modalidade_numero, modalidade_ano, objeto_id,' +
    '  data_inc, usuario_i, data_alt, usuario_a, data_del, usuario_d,' +
    '  hora, participa, motivo, obs, tipo, deletado, ganha,' +
    '  vendedor_id, vigencia, entrega, validade_cotacao, vigencia_data,' +
    '  homologacao, tipo_entrega, origem, garantia_preco, site,' +
    '  entregas, licitacao_origem, vigencia_ini, status,' +
    '  obs_interno, obs_cliente, sync, sync_data, objeto, modalidade,' +
    '  usuarionome_i, usuarionome_a, usuarionome_d, pessoa_vr, vendedor' +
    ') VALUES (' +
    '  :licitacao_id, :cliente_id, :orgao_id, :data, :processo, :processo_ano,' +
    '  :processo_admin, :processo_admin_ano, :portaria, :portaria_ano,' +
    '  :modalidade_id, :modalidade_numero, :modalidade_ano, :objeto_id,' +
    '  :data_inc, :usuario_i, :data_alt, :usuario_a, :data_del, :usuario_d,' +
    '  :hora, :participa, :motivo, :obs, :tipo, :deletado, :ganha,' +
    '  :vendedor_id, :vigencia, :entrega, :validade_cotacao, :vigencia_data,' +
    '  :homologacao, :tipo_entrega, :origem, :garantia_preco, :site,' +
    '  :entregas, :licitacao_origem, :vigencia_ini, :status,' +
    '  :obs_interno, :obs_cliente, :sync, (now() at time zone ''America/Sao_Paulo''), :objeto, :modalidade,' +
    '  :usuarionome_i, :usuarionome_a, :usuarionome_d, :pessoa_vr, :vendedor' +
    ') ON CONFLICT (licitacao_id) DO UPDATE SET ' +
    '  cliente_id=EXCLUDED.cliente_id, orgao_id=EXCLUDED.orgao_id, data=EXCLUDED.data,' +
    '  processo=EXCLUDED.processo, processo_ano=EXCLUDED.processo_ano,' +
    '  processo_admin=EXCLUDED.processo_admin, processo_admin_ano=EXCLUDED.processo_admin_ano,' +
    '  portaria=EXCLUDED.portaria, portaria_ano=EXCLUDED.portaria_ano,' +
    '  modalidade_id=EXCLUDED.modalidade_id, modalidade_numero=EXCLUDED.modalidade_numero,' +
    '  modalidade_ano=EXCLUDED.modalidade_ano, objeto_id=EXCLUDED.objeto_id,' +
    '  data_inc=EXCLUDED.data_inc, usuario_i=EXCLUDED.usuario_i,' +
    '  data_alt=EXCLUDED.data_alt, usuario_a=EXCLUDED.usuario_a,' +
    '  data_del=EXCLUDED.data_del, usuario_d=EXCLUDED.usuario_d,' +
    '  hora=EXCLUDED.hora, participa=EXCLUDED.participa, motivo=EXCLUDED.motivo,' +
    '  obs=EXCLUDED.obs, tipo=EXCLUDED.tipo, deletado=EXCLUDED.deletado,' +
    '  ganha=EXCLUDED.ganha, vendedor_id=EXCLUDED.vendedor_id,' +
    '  vigencia=EXCLUDED.vigencia, entrega=EXCLUDED.entrega,' +
    '  validade_cotacao=EXCLUDED.validade_cotacao, vigencia_data=EXCLUDED.vigencia_data,' +
    '  homologacao=EXCLUDED.homologacao, tipo_entrega=EXCLUDED.tipo_entrega,' +
    '  origem=EXCLUDED.origem, garantia_preco=EXCLUDED.garantia_preco,' +
    '  site=EXCLUDED.site, entregas=EXCLUDED.entregas,' +
    '  licitacao_origem=EXCLUDED.licitacao_origem, vigencia_ini=EXCLUDED.vigencia_ini,' +
    '  status=EXCLUDED.status, obs_interno=EXCLUDED.obs_interno,' +
    '  obs_cliente=EXCLUDED.obs_cliente, sync=EXCLUDED.sync,' +
    '  sync_data=(now() at time zone ''America/Sao_Paulo''),' +
    '  objeto=EXCLUDED.objeto, modalidade=EXCLUDED.modalidade,' +
    '  usuarionome_i=EXCLUDED.usuarionome_i, usuarionome_a=EXCLUDED.usuarionome_a,' +
    '  usuarionome_d=EXCLUDED.usuarionome_d, pessoa_vr=EXCLUDED.pessoa_vr,' +
    '  vendedor=EXCLUDED.vendedor';

var
  qUp: TFDQuery;
  fs: TFormatSettings;
  Ini: TIniFile;
  TotalRecords, CurrentRecord: Integer;

  procedure CloseActivityForm;
  begin
    if Assigned(Form_Activity) then
    begin
      try
        Form_Activity.Close;
      except
        // Ignora erros de fechamento
      end;
      try
        FreeAndNil(Form_Activity);
      except
        // Ignora erros de liberação
      end;
    end;
  end;

  procedure SetDateParam(const PName: string; F: TField);
  var s: string; d: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftDate;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else
    begin
      if F.DataType = ftDate then
        qUp.ParamByName(PName).AsDate := F.AsDateTime
      else
      begin
        s := Trim(F.AsString);
        if s = '' then qUp.ParamByName(PName).Clear
        else if TryStrToDate(s, d, fs) then
          qUp.ParamByName(PName).AsDate := d
        else
          qUp.ParamByName(PName).Clear;
      end;
    end;
  end;

  procedure SetTimeParam(const PName: string; F: TField);
  var s: string; t: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftTime;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else
    begin
      if F.DataType = ftTime then
        qUp.ParamByName(PName).AsTime := F.AsDateTime
      else
      begin
        s := Trim(F.AsString);
        if s = '' then qUp.ParamByName(PName).Clear
        else
        begin
          try
            t := StrToTime(s);
            qUp.ParamByName(PName).AsTime := t;
          except
            qUp.ParamByName(PName).Clear;
          end;
        end;
      end;
    end;
  end;

  procedure SetTimestampParam(const PName: string; F: TField);
  var s: string; dt: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftDateTime;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else
    begin
      if F.DataType in [ftDateTime, ftTimeStamp] then
        qUp.ParamByName(PName).AsDateTime := F.AsDateTime
      else
      begin
        s := Trim(F.AsString);
        if s = '' then qUp.ParamByName(PName).Clear
        else if TryStrToDateTime(s, dt, fs) then
          qUp.ParamByName(PName).AsDateTime := dt
        else
          qUp.ParamByName(PName).Clear;
      end;
    end;
  end;

begin
  // formato para parse dd/MM/yyyy (somente se o SQL retornar texto)
  fs := TFormatSettings.Create;
  fs.DateSeparator   := '/';
  fs.ShortDateFormat := 'dd/MM/yyyy';
  fs.TimeSeparator   := ':';
  fs.ShortTimeFormat := 'hh:nn:ss';

  FDConnectionSupabase.Connected := True;

  // 1) Configurar conexão SICFAR (Firebird)
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');
  try
    if not Assigned(Form_ConfigSqlServer) then
      Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionSICFAR, 'SICFAR');
  finally
    Ini.Free;
  end;

  // 2) Preparar consulta no SICFAR usando o componente qSICFAR do formulário
  qSICFAR.Close;
  qSICFAR.Connection := FDConnectionSICFAR;
  qSICFAR.SQL.Clear;
  qSICFAR.SQL.Add('SELECT');
  qSICFAR.SQL.Add('  LICITACAO_ID,');
  qSICFAR.SQL.Add('  PESSOA_ID,');
  qSICFAR.SQL.Add('  DATA,');
  qSICFAR.SQL.Add('  PROCESSO,');
  qSICFAR.SQL.Add('  PROCESSO_ANO,');
  qSICFAR.SQL.Add('  PROCESSO_ADMIN,');
  qSICFAR.SQL.Add('  PROCESSO_ADMIN_ANO,');
  qSICFAR.SQL.Add('  PORTARIA,');
  qSICFAR.SQL.Add('  PORTARIA_ANO,');
  qSICFAR.SQL.Add('  MODALIDADE_ID,');
  qSICFAR.SQL.Add('  MODALIDADE_NUMERO,');
  qSICFAR.SQL.Add('  MODALIDADE_ANO,');
  qSICFAR.SQL.Add('  OBJETO_ID,');
  qSICFAR.SQL.Add('  DATA_INC,');
  qSICFAR.SQL.Add('  USUARIO_ID,');
  qSICFAR.SQL.Add('  DATA_ALT,');
  qSICFAR.SQL.Add('  USUARIO_A,');
  qSICFAR.SQL.Add('  DATA_DEL,');
  qSICFAR.SQL.Add('  USUARIO_D,');
  qSICFAR.SQL.Add('  HORA,');
  qSICFAR.SQL.Add('  PARTICIPA,');
  qSICFAR.SQL.Add('  MOTIVO,');
  qSICFAR.SQL.Add('  OBS,');
  qSICFAR.SQL.Add('  TIPO,');
  qSICFAR.SQL.Add('  DELETADO,');
  qSICFAR.SQL.Add('  GANHA,');
  qSICFAR.SQL.Add('  PESSOA_VR,');
  qSICFAR.SQL.Add('  VIGENCIA,');
  qSICFAR.SQL.Add('  ENTREGA,');
  qSICFAR.SQL.Add('  VALIDADE_COTACAO,');
  qSICFAR.SQL.Add('  CLIENTE_ID,');
  qSICFAR.SQL.Add('  VIGENCIA_DATA,');
  qSICFAR.SQL.Add('  HOMOLOGACAO,');
  qSICFAR.SQL.Add('  TIPO_ENTREGA,');
  qSICFAR.SQL.Add('  ORIGEM,');
  qSICFAR.SQL.Add('  GARANTIA_PRECO,');
  qSICFAR.SQL.Add('  SITE,');
  qSICFAR.SQL.Add('  ENTREGAS,');
  qSICFAR.SQL.Add('  USUARIONOME_I,');
  qSICFAR.SQL.Add('  USUARIONOME_A,');
  qSICFAR.SQL.Add('  USUARIONOME_D,');
  qSICFAR.SQL.Add('  LICITACAO_ORIGEM,');
  qSICFAR.SQL.Add('  VIGENCIA_INI,');
  qSICFAR.SQL.Add('  STATUS,');
  qSICFAR.SQL.Add('  OBS_INTERNO,');
  qSICFAR.SQL.Add('  OBS_CLIENTE,');
  qSICFAR.SQL.Add('  SYNC,');
  qSICFAR.SQL.Add('  SYNC_DATA');
  qSICFAR.SQL.Add('FROM TBLICITACAO');
  qSICFAR.SQL.Add(WHERE_CLAUSE);
  qSICFAR.SQL.Add('ORDER BY LICITACAO_ID');

  // Exibir Form de Atividade e contar registros
  if not Assigned(Form_Activity) then
  begin
    try
      Form_Activity := TForm_Activity.Create(Application);
      Form_Activity.Show;
      Form_Activity.Label_Status.Caption := 'Executando consulta...';
      Application.ProcessMessages;
    except
      on E: Exception do
      begin
        if Assigned(Form_Activity) then
          FreeAndNil(Form_Activity);
        raise Exception.Create('Erro ao criar formulário de atividade: ' + E.Message);
      end;
    end;
  end;

  qSICFAR.Open;

  TotalRecords := FDConnectionSICFAR.ExecSQLScalar(
    'SELECT COUNT(*) FROM TBLICITACAO' + WHERE_CLAUSE
  );

  if Assigned(Form_Activity) then
  begin
    try
      Form_Activity.Label_Status.Caption := Format('Preparando para importar... %d registros encontrados.', [TotalRecords]);
      Application.ProcessMessages;
    except
      // Ignora erros na interface
    end;
  end;
  Sleep(500);

  // 3) Prepara o UPSERT no Supabase
  qUp := TFDQuery.Create(nil);
  try
    qUp.Connection := FDConnectionSupabase;
    qUp.SQL.Text   := SQL_UPSERT;

    FDConnectionSupabase.StartTransaction;
    try
      qSICFAR.First;
      CurrentRecord := 0;
      while not qSICFAR.Eof do
      begin
        Inc(CurrentRecord);

        if Assigned(Form_Activity) then
        begin
          try
            Form_Activity.Label_Status.Caption := Format('Importando registro %d de %d...', [CurrentRecord, TotalRecords]);
            Application.ProcessMessages;
          except
            // Ignora erros na interface
          end;
        end;

        // Mapeamento de parâmetros Firebird → Supabase
        qUp.ParamByName('licitacao_id').AsInteger := qSICFAR.FieldByName('LICITACAO_ID').AsInteger;
        qUp.ParamByName('cliente_id').AsInteger := qSICFAR.FieldByName('PESSOA_ID').AsInteger;
        qUp.ParamByName('orgao_id').AsInteger := qSICFAR.FieldByName('CLIENTE_ID').AsInteger;

        SetDateParam('data', qSICFAR.FieldByName('DATA'));

        qUp.ParamByName('processo').AsString := qSICFAR.FieldByName('PROCESSO').AsString;
        qUp.ParamByName('processo_ano').AsString := qSICFAR.FieldByName('PROCESSO_ANO').AsString;
        qUp.ParamByName('processo_admin').AsString := qSICFAR.FieldByName('PROCESSO_ADMIN').AsString;
        qUp.ParamByName('processo_admin_ano').AsString := qSICFAR.FieldByName('PROCESSO_ADMIN_ANO').AsString;
        qUp.ParamByName('portaria').AsString := qSICFAR.FieldByName('PORTARIA').AsString;
        qUp.ParamByName('portaria_ano').AsString := qSICFAR.FieldByName('PORTARIA_ANO').AsString;
        qUp.ParamByName('modalidade_id').AsInteger := qSICFAR.FieldByName('MODALIDADE_ID').AsInteger;
        qUp.ParamByName('modalidade_numero').AsString := qSICFAR.FieldByName('MODALIDADE_NUMERO').AsString;
        qUp.ParamByName('modalidade_ano').AsString := qSICFAR.FieldByName('MODALIDADE_ANO').AsString;
        qUp.ParamByName('objeto_id').AsInteger := qSICFAR.FieldByName('OBJETO_ID').AsInteger;

        SetTimestampParam('data_inc', qSICFAR.FieldByName('DATA_INC'));
        qUp.ParamByName('usuario_i').AsInteger := qSICFAR.FieldByName('USUARIO_ID').AsInteger;
        SetTimestampParam('data_alt', qSICFAR.FieldByName('DATA_ALT'));
        qUp.ParamByName('usuario_a').AsInteger := qSICFAR.FieldByName('USUARIO_A').AsInteger;
        SetTimestampParam('data_del', qSICFAR.FieldByName('DATA_DEL'));
        qUp.ParamByName('usuario_d').AsInteger := qSICFAR.FieldByName('USUARIO_D').AsInteger;

        SetTimeParam('hora', qSICFAR.FieldByName('HORA'));

        qUp.ParamByName('participa').AsString := qSICFAR.FieldByName('PARTICIPA').AsString;
        qUp.ParamByName('motivo').AsString := qSICFAR.FieldByName('MOTIVO').AsString;
        qUp.ParamByName('obs').AsString := qSICFAR.FieldByName('OBS').AsString;
        qUp.ParamByName('tipo').AsString := qSICFAR.FieldByName('TIPO').AsString;
        qUp.ParamByName('deletado').AsString := qSICFAR.FieldByName('DELETADO').AsString;
        qUp.ParamByName('ganha').AsString := qSICFAR.FieldByName('GANHA').AsString;
        qUp.ParamByName('vendedor_id').AsInteger := qSICFAR.FieldByName('PESSOA_VR').AsInteger;
        qUp.ParamByName('vigencia').AsFloat := qSICFAR.FieldByName('VIGENCIA').AsFloat;
        qUp.ParamByName('entrega').AsFloat := qSICFAR.FieldByName('ENTREGA').AsFloat;

        SetDateParam('validade_cotacao', qSICFAR.FieldByName('VALIDADE_COTACAO'));
        SetDateParam('vigencia_data', qSICFAR.FieldByName('VIGENCIA_DATA'));
        SetDateParam('homologacao', qSICFAR.FieldByName('HOMOLOGACAO'));

        qUp.ParamByName('tipo_entrega').AsString := qSICFAR.FieldByName('TIPO_ENTREGA').AsString;
        qUp.ParamByName('origem').AsString := qSICFAR.FieldByName('ORIGEM').AsString;

        SetDateParam('garantia_preco', qSICFAR.FieldByName('GARANTIA_PRECO'));

        qUp.ParamByName('site').AsString := qSICFAR.FieldByName('SITE').AsString;
        qUp.ParamByName('entregas').AsInteger := qSICFAR.FieldByName('ENTREGAS').AsInteger;
        qUp.ParamByName('licitacao_origem').AsInteger := qSICFAR.FieldByName('LICITACAO_ORIGEM').AsInteger;

        SetDateParam('vigencia_ini', qSICFAR.FieldByName('VIGENCIA_INI'));

        qUp.ParamByName('status').AsString := qSICFAR.FieldByName('STATUS').AsString;
        qUp.ParamByName('obs_interno').AsString := qSICFAR.FieldByName('OBS_INTERNO').AsString;
        qUp.ParamByName('obs_cliente').AsString := qSICFAR.FieldByName('OBS_CLIENTE').AsString;
        qUp.ParamByName('sync').AsString := qSICFAR.FieldByName('SYNC').AsString;

        // Campos adicionais no Supabase que não existem no Firebird
        qUp.ParamByName('objeto').AsString := '';
        qUp.ParamByName('modalidade').AsString := '';
        qUp.ParamByName('usuarionome_i').AsString := qSICFAR.FieldByName('USUARIONOME_I').AsString;
        qUp.ParamByName('usuarionome_a').AsString := qSICFAR.FieldByName('USUARIONOME_A').AsString;
        qUp.ParamByName('usuarionome_d').AsString := qSICFAR.FieldByName('USUARIONOME_D').AsString;
        qUp.ParamByName('pessoa_vr').AsInteger := qSICFAR.FieldByName('PESSOA_VR').AsInteger;
        qUp.ParamByName('vendedor').AsString := '';

        qUp.ExecSQL;

        // Controle de performance: atualiza interface a cada 10 registros
        if CurrentRecord mod 10 = 0 then
        begin
          try
            Application.ProcessMessages;
          except
            // Ignora erros no ProcessMessages
          end;
          Sleep(10);
        end;

        qSICFAR.Next;
      end;

      FDConnectionSupabase.Commit;
      CloseActivityForm;
      ShowMessage('Importação de licitações concluída com sucesso.');
    except
      on E: Exception do
      begin
        FDConnectionSupabase.Rollback;
        CloseActivityForm;
        raise;
      end;
    end;
  finally
    qUp.Free;
    if qSICFAR.Active then qSICFAR.Close;
    if FDConnectionSICFAR.Connected then FDConnectionSICFAR.Connected := False;
  end;
end;

procedure TForm_Principal.btn_ImportarLoteDesvioClick(Sender: TObject);
var
  Ini          : TIniFile;
  TotalRecords, CurrentRecord: Integer;
  ids, firstId: string;
  posComma: Integer;

  procedure CloseActivityForm;
  begin
    if Assigned(Form_Activity) then
    begin
      try
        Form_Activity.Close;
      except
        // Ignora erros de fechamento
      end;
      try
        FreeAndNil(Form_Activity);
      except
        // Ignora erros de liberação
      end;
    end;
  end;
begin
  // Desabilita botão durante a operação
  btn_ImportarLoteDesvio.Enabled := False;
  Ini        := nil;

  try
    try
    // 1) Ler configurações e garantir conexões (TOTVS e SICFAR)
    if not Assigned(Form_ConfigSqlServer) then
      Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);

    Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');

    // 1) Conecta ao Banco FDConnection
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionTOTVS, 'Protheus');

    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionSICFAR, 'SICFAR');

    // 2) Preparar consulta no SICFAR usando o componente qSICFAR do formulário
    qSICFAR.Close;
    qSICFAR.Connection := FDConnectionSICFAR;
    qSICFAR.SQL.Clear;
    qSICFAR.SQL.Add('SELECT');
    qSICFAR.SQL.Add('  dp.lote,');
    qSICFAR.SQL.Add('  LIST(DISTINCT d.desvio, '', '') AS desvios,');
    qSICFAR.SQL.Add('  LIST(DISTINCT CAST(dp.desvio_id AS VARCHAR(20)), '','') AS desvios_ids');
    qSICFAR.SQL.Add('FROM tbdesvio_produto dp');
    qSICFAR.SQL.Add('JOIN tbdesvio d');
    qSICFAR.SQL.Add('  ON d.desvio_id = dp.desvio_id');
    qSICFAR.SQL.Add('WHERE dp.deletado = ''N''');
    qSICFAR.SQL.Add('  AND d.deletado  = ''N''');
    qSICFAR.SQL.Add('  AND dp.lote IS NOT NULL');

//    qSICFAR.SQL.Add(' and dp.lote = ''24C12184E'' ');

    qSICFAR.SQL.Add('GROUP BY dp.lote;');


    // 2.1) Form de atividade
    if not Assigned(Form_Activity) then
    begin
      try
        Form_Activity := TForm_Activity.Create(Application);
        Form_Activity.Show;
        Form_Activity.Label_Status.Caption := 'Executando consulta no SICFAR...';
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          if Assigned(Form_Activity) then
            FreeAndNil(Form_Activity);
          raise Exception.Create('Erro ao criar formulário de atividade: ' + E.Message);
        end;
      end;
    end;

    // 2.2) Abrir
    qSICFAR.Open;

    // 2.3) Contar total para feedback (usa subselect)
    try
      TotalRecords := FDConnectionSICFAR.ExecSQLScalar(
        'SELECT COUNT(*) FROM ( ' +
        'SELECT dp.lote ' +
        'FROM tbdesvio_produto dp ' +
        'JOIN tbdesvio d ON d.desvio_id = dp.desvio_id ' +
        'WHERE dp.deletado = ''N'' AND d.deletado = ''N'' AND dp.lote IS NOT NULL ' +
//        ' AND dp.lote = ''24C12184E'' ' +
        'GROUP BY dp.lote ' +
        ') T'
      );
    except
      // Se falhar a contagem, segue sem total
      TotalRecords := -1;
    end;

    if Assigned(Form_Activity) then
    begin
      try
        if TotalRecords >= 0 then
          Form_Activity.Label_Status.Caption := Format('Preparando para atualizar... %d registros encontrados.', [TotalRecords])
        else
          Form_Activity.Label_Status.Caption := 'Preparando para atualizar...';
        Application.ProcessMessages;
      except
        // Ignora erros na interface
      end;
    end;
    Sleep(300);

    try
      // 5) Iterar registros SICFAR e atualizar TOTVS
      qSICFAR.First;
      CurrentRecord := 0;
      while not qSICFAR.Eof do
      begin
        Inc(CurrentRecord);

        if Assigned(Form_Activity) then
        begin
          try
            if TotalRecords > 0 then
              Form_Activity.Label_Status.Caption :=
                Format('Atualizando registro %d de %d... Lote: %s', [CurrentRecord, TotalRecords, Trim(qSICFAR.FieldByName('lote').AsString)])
            else
              Form_Activity.Label_Status.Caption :=
                'Atualizando... Lote: ' + Trim(qSICFAR.FieldByName('lote').AsString);
            Application.ProcessMessages;
          except
            // Ignora erros na interface
          end;
        end;
        // Extrair o primeiro ID de desvio da lista concatenada (desvios_ids)
        ids := Trim(qSICFAR.FieldByName('desvios_ids').AsString);
        firstId := ids;
        posComma := Pos(',', firstId);

        if posComma > 0 then
          firstId := Copy(firstId, 1, posComma - 1);

        // 3) Preparar UPDATE no TOTVS (parametrizado)
        with qTOTVS do
          begin
              Close;
              Connection := FDConnectionTOTVS;
              SQL.Text :=
              'UPDATE SD7010 ' +
              'SET D7_YSICCQ = :pDesvioId ' +
              'WHERE D_E_L_E_T_ = '''' ' +
              '  AND D7_LOTECTL = :pLote';

              ParamByName('pDesvioId').AsString := Copy(qSICFAR.FieldByName('desvios').AsString,1,10);
              ParamByName('pLote').AsString     := qSICFAR.FieldByName('lote').AsString;

              qTOTVS.ExecSQL;
          end;

        // Suavizar UI a cada 25 registros
        if (CurrentRecord mod 25 = 0) then
        begin
          try
            Application.ProcessMessages;
          except
          end;
          Sleep(5);
        end;

        qSICFAR.Next;
      end;

      FDConnectionTOTVS.Commit;
      CloseActivityForm;
      ShowMessage('Importação de lotes para desvio concluída com sucesso.');
    except
      on E: Exception do
      begin
        if FDConnectionTOTVS.InTransaction then
          FDConnectionTOTVS.Rollback;
        CloseActivityForm;
        raise;
      end;
    end;

  except
    on E: Exception do
    begin
      // Feedback de erro
      if Assigned(Form_Activity) then
        CloseActivityForm;
      ShowMessage('Erro ao importar lotes para desvio: ' + E.Message);
    end;
  end;
  finally
    // Limpeza e reabilitação do botão
    try
      if qSICFAR.Active then qSICFAR.Close;
    except
      // ignora
    end;
    if Assigned(Ini) then Ini.Free;
    btn_ImportarLoteDesvio.Enabled := True;
  end;
end;

procedure TForm_Principal.btn_ImportarReceberClick(Sender: TObject);
const
  FROM_JOIN_CLAUSE =
    'FROM SE1010 (NOLOCK) SE1 ' +
    'LEFT JOIN SA1010 (NOLOCK) SA1 ON SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '''' ';

  WHERE_CLAUSE =
    ' WHERE SE1.D_E_L_E_T_ = '''' ' +
    ' AND ((SA1.A1_YENTREG = '''') OR (SA1.A1_YENTREG = ''N'')) ' +
    ' AND SE1.E1_VEND1 = ''000050'' ' +
    ' AND SE1.E1_TIPO NOT IN (''NCC'',''RA'') ' +
//    ' AND SE1.E1_SALDO > 0 ' +
    ' AND SE1.E1_SUSPENS <> ''S'' ';
    // Condições opcionais (comentadas):
    // ' AND DATEDIFF(DAY, CONVERT(DATETIME, SE1.E1_VENCREA, 112), GETDATE()) BETWEEN ''1'' AND ''99999'' ';

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
  TotalRecords, CurrentRecord: Integer;

  procedure CloseActivityForm;
  begin
    if Assigned(Form_Activity) then
    begin
      try
        Form_Activity.Close;
      except
        // Ignora erros de fechamento
      end;
      try
        FreeAndNil(Form_Activity);
      except
        // Ignora erros de liberação
      end;
    end;
  end;

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
    SQL.Add(FROM_JOIN_CLAUSE);
    SQL.Add(WHERE_CLAUSE);
    SQL.Add(' ORDER BY SA1.A1_COD, SE1.E1_VENCREA');

  end;
  qTOTVS.Open;

  // Exibir Form de Atividade e contar registros
  if not Assigned(Form_Activity) then
  begin
    try
      Form_Activity := TForm_Activity.Create(Application);
      Form_Activity.Show;
      Form_Activity.Label_Status.Caption := 'Executando consulta...';
      Application.ProcessMessages;
    except
      on E: Exception do
      begin
        if Assigned(Form_Activity) then
          FreeAndNil(Form_Activity);
        raise Exception.Create('Erro ao criar formulário de atividade: ' + E.Message);
      end;
    end;
  end;

  TotalRecords := FDConnectionTOTVS.ExecSQLScalar(
    'SELECT COUNT(*) ' + FROM_JOIN_CLAUSE + WHERE_CLAUSE
  );

  if Assigned(Form_Activity) then
  begin
    try
      Form_Activity.Label_Status.Caption := Format('Preparando para importar... %d registros encontrados.', [TotalRecords]);
      Application.ProcessMessages;
    except
      // Ignora erros na interface
    end;
  end;
  Sleep(500);

  // 3) Prepara o UPSERT no Supabase
  qUp := TFDQuery.Create(nil);
  try
    qUp.Connection := FDConnectionSupabase;
    qUp.SQL.Text   := SQL_UPSERT;

    FDConnectionSupabase.StartTransaction;
    try
      qTOTVS.First;
      CurrentRecord := 0;
      while not qTOTVS.Eof do
      begin
        Inc(CurrentRecord);

        if Assigned(Form_Activity) then
        begin
          try
            Form_Activity.Label_Status.Caption := Format('Importando registro %d de %d...', [CurrentRecord, TotalRecords]);
            Application.ProcessMessages;
          except
            // Ignora erros na interface
          end;
        end;

        qUp.ParamByName('e1_recno').DataType           := ftLargeint;
        qUp.ParamByName('e1_recno').AsLargeInt         := qTOTVS.FieldByName('e1_recno').AsLargeInt;
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

        // Controle de performance: atualiza interface a cada 10 registros
        if CurrentRecord mod 10 = 0 then
        begin
          try
            // Mantém interface responsiva durante operação longa
            Application.ProcessMessages;
          except
            // Ignora erros no ProcessMessages
          end;
          // Pausa de 10ms para melhor experiência visual e reduzir uso de CPU
          Sleep(10);
        end;

        qTOTVS.Next;
      end;

      FDConnectionSupabase.Commit;
      CloseActivityForm;
      ShowMessage('Importação concluída com sucesso.');
    except
      on E: Exception do
      begin
        FDConnectionSupabase.Rollback;
        CloseActivityForm;
        raise;
      end;
    end;
  finally
    qUp.Free;
  end;
end;

procedure TForm_Principal.btn_ClienteClick(Sender: TObject);
const
  // WHERE_CLAUSE pode ser ajustado conforme necessidade para filtrar registros específicos
  WHERE_CLAUSE =
    ' WHERE pessoa_id > 0';

  SQL_UPSERT =
    'INSERT INTO public.tbcliente (' +
    '  cliente_id, empresa_id, nome_pupular, nome, endereco, complemento,' +
    '  bairro, cidade_id, uf, cep, vendedor_id, naturalidade, nascimento,' +
    '  sexo, tipo, cpf_cnpj, rg_cgf, estcivil, obs, pai, mae,' +
    '  limite_credito, conjuge, comissao, situacao, deletado, email, site,' +
    '  cpf_conjuge, rg_conjuge, rg_orgao, rg_uf, rg_orgao_conjuge, rg_uf_conjuge,' +
    '  profissao, natural_id, nacionalidade, regime_casamento, renda_conjuge,' +
    '  nacionalidade_conjuge, profissao_conjuge, numero, suframa, pais_id,' +
    '  data_batismo, cargo_id, funcao_id, grupo_id, subgrupo_id,' +
    '  nascimento_conjuge, dia_vencimento, cnh, cnh_categoria,' +
    '  cnh_emissao, cnh_vencimento, rg_emissao, data_inc, usuario_i,' +
    '  data_alt, usuario_a, data_del, usuario_d, erp_codigo, ctps_n,' +
    '  ctps_s, ctps_uf, nit, ctps_emissao, cnh_uf, data_admissao,' +
    '  titulo_numero, titulo_zona, titulo_secao, banco_id, banco,' +
    '  agencia, conta, cor, grau_instrucao, bloqueio_id, setor_id,' +
    '  sync, sync_data, cidade' +
    ') VALUES (' +
    '  :cliente_id, :empresa_id, :nome_pupular, :nome, :endereco, :complemento,' +
    '  :bairro, :cidade_id, :uf, :cep, :vendedor_id, :naturalidade, :nascimento,' +
    '  :sexo, :tipo, :cpf_cnpj, :rg_cgf, :estcivil, :obs, :pai, :mae,' +
    '  :limite_credito, :conjuge, :comissao, :situacao, :deletado, :email, :site,' +
    '  :cpf_conjuge, :rg_conjuge, :rg_orgao, :rg_uf, :rg_orgao_conjuge, :rg_uf_conjuge,' +
    '  :profissao, :natural_id, :nacionalidade, :regime_casamento, :renda_conjuge,' +
    '  :nacionalidade_conjuge, :profissao_conjuge, :numero, :suframa, :pais_id,' +
    '  :data_batismo, :cargo_id, :funcao_id, :grupo_id, :subgrupo_id,' +
    '  :nascimento_conjuge, :dia_vencimento, :cnh, :cnh_categoria,' +
    '  :cnh_emissao, :cnh_vencimento, :rg_emissao, :data_inc, :usuario_i,' +
    '  :data_alt, :usuario_a, :data_del, :usuario_d, :erp_codigo, :ctps_n,' +
    '  :ctps_s, :ctps_uf, :nit, :ctps_emissao, :cnh_uf, :data_admissao,' +
    '  :titulo_numero, :titulo_zona, :titulo_secao, :banco_id, :banco,' +
    '  :agencia, :conta, :cor, :grau_instrucao, :bloqueio_id, :setor_id,' +
    '  :sync, (now() at time zone ''America/Sao_Paulo''), :cidade' +
    ') ON CONFLICT (cliente_id) DO UPDATE SET ' +
    '  empresa_id=EXCLUDED.empresa_id, nome_pupular=EXCLUDED.nome_pupular,' +
    '  nome=EXCLUDED.nome, endereco=EXCLUDED.endereco, complemento=EXCLUDED.complemento,' +
    '  bairro=EXCLUDED.bairro, cidade_id=EXCLUDED.cidade_id, uf=EXCLUDED.uf,' +
    '  cep=EXCLUDED.cep, vendedor_id=EXCLUDED.vendedor_id, naturalidade=EXCLUDED.naturalidade,' +
    '  nascimento=EXCLUDED.nascimento, sexo=EXCLUDED.sexo, tipo=EXCLUDED.tipo,' +
    '  cpf_cnpj=EXCLUDED.cpf_cnpj, rg_cgf=EXCLUDED.rg_cgf, estcivil=EXCLUDED.estcivil,' +
    '  obs=EXCLUDED.obs, pai=EXCLUDED.pai, mae=EXCLUDED.mae,' +
    '  limite_credito=EXCLUDED.limite_credito, conjuge=EXCLUDED.conjuge,' +
    '  comissao=EXCLUDED.comissao, situacao=EXCLUDED.situacao, deletado=EXCLUDED.deletado,' +
    '  email=EXCLUDED.email, site=EXCLUDED.site, cpf_conjuge=EXCLUDED.cpf_conjuge,' +
    '  rg_conjuge=EXCLUDED.rg_conjuge, rg_orgao=EXCLUDED.rg_orgao, rg_uf=EXCLUDED.rg_uf,' +
    '  rg_orgao_conjuge=EXCLUDED.rg_orgao_conjuge, rg_uf_conjuge=EXCLUDED.rg_uf_conjuge,' +
    '  profissao=EXCLUDED.profissao, natural_id=EXCLUDED.natural_id,' +
    '  nacionalidade=EXCLUDED.nacionalidade, regime_casamento=EXCLUDED.regime_casamento,' +
    '  renda_conjuge=EXCLUDED.renda_conjuge, nacionalidade_conjuge=EXCLUDED.nacionalidade_conjuge,' +
    '  profissao_conjuge=EXCLUDED.profissao_conjuge, numero=EXCLUDED.numero,' +
    '  suframa=EXCLUDED.suframa, pais_id=EXCLUDED.pais_id,' +
    '  data_batismo=EXCLUDED.data_batismo, cargo_id=EXCLUDED.cargo_id,' +
    '  funcao_id=EXCLUDED.funcao_id, grupo_id=EXCLUDED.grupo_id, subgrupo_id=EXCLUDED.subgrupo_id,' +
    '  nascimento_conjuge=EXCLUDED.nascimento_conjuge, dia_vencimento=EXCLUDED.dia_vencimento,' +
    '  cnh=EXCLUDED.cnh, cnh_categoria=EXCLUDED.cnh_categoria,' +
    '  cnh_emissao=EXCLUDED.cnh_emissao, cnh_vencimento=EXCLUDED.cnh_vencimento,' +
    '  rg_emissao=EXCLUDED.rg_emissao, data_inc=EXCLUDED.data_inc, usuario_i=EXCLUDED.usuario_i,' +
    '  data_alt=EXCLUDED.data_alt, usuario_a=EXCLUDED.usuario_a, data_del=EXCLUDED.data_del,' +
    '  usuario_d=EXCLUDED.usuario_d, erp_codigo=EXCLUDED.erp_codigo, ctps_n=EXCLUDED.ctps_n,' +
    '  ctps_s=EXCLUDED.ctps_s, ctps_uf=EXCLUDED.ctps_uf, nit=EXCLUDED.nit,' +
    '  ctps_emissao=EXCLUDED.ctps_emissao, cnh_uf=EXCLUDED.cnh_uf,' +
    '  data_admissao=EXCLUDED.data_admissao, titulo_numero=EXCLUDED.titulo_numero,' +
    '  titulo_zona=EXCLUDED.titulo_zona, titulo_secao=EXCLUDED.titulo_secao,' +
    '  banco_id=EXCLUDED.banco_id, banco=EXCLUDED.banco, agencia=EXCLUDED.agencia,' +
    '  conta=EXCLUDED.conta, cor=EXCLUDED.cor, grau_instrucao=EXCLUDED.grau_instrucao,' +
    '  bloqueio_id=EXCLUDED.bloqueio_id, setor_id=EXCLUDED.setor_id,' +
    '  sync=EXCLUDED.sync, sync_data=(now() at time zone ''America/Sao_Paulo''),' +
    '  cidade=EXCLUDED.cidade';

var
  qUp: TFDQuery;
  fs: TFormatSettings;
  Ini: TIniFile;
  TotalRecords, CurrentRecord: Integer;

  procedure CloseActivityForm;
  begin
    if Assigned(Form_Activity) then
    begin
      try
        Form_Activity.Close;
      except
        // Ignora erros de fechamento
      end;
      try
        FreeAndNil(Form_Activity);
      except
        // Ignora erros de liberação
      end;
    end;
  end;

  procedure SetDateParam(const PName: string; F: TField);
  var s: string; d: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftDate;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else
    begin
      if F.DataType = ftDate then
        qUp.ParamByName(PName).AsDate := F.AsDateTime
      else
      begin
        s := Trim(F.AsString);
        if s = '' then qUp.ParamByName(PName).Clear
        else if TryStrToDate(s, d, fs) then
          qUp.ParamByName(PName).AsDate := d
        else
          qUp.ParamByName(PName).Clear;
      end;
    end;
  end;

  procedure SetTimestampParam(const PName: string; F: TField);
  var s: string; dt: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftDateTime;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else
    begin
      if F.DataType in [ftDateTime, ftTimeStamp] then
        qUp.ParamByName(PName).AsDateTime := F.AsDateTime
      else
      begin
        s := Trim(F.AsString);
        if s = '' then qUp.ParamByName(PName).Clear
        else if TryStrToDateTime(s, dt, fs) then
          qUp.ParamByName(PName).AsDateTime := dt
        else
          qUp.ParamByName(PName).Clear;
      end;
    end;
  end;

begin
  // formato para parse dd/MM/yyyy (somente se o SQL retornar texto)
  fs := TFormatSettings.Create;
  fs.DateSeparator   := '/';
  fs.ShortDateFormat := 'dd/MM/yyyy';
  fs.TimeSeparator   := ':';
  fs.ShortTimeFormat := 'hh:nn:ss';

  FDConnectionSupabase.Connected := True;

  // 1) Configurar conexão SICFAR (Firebird)
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');
  try
    if not Assigned(Form_ConfigSqlServer) then
      Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionSICFAR, 'SICFAR');
  finally
    Ini.Free;
  end;

  // 2) Preparar consulta no SICFAR usando o componente qSICFAR do formulário
  qSICFAR.Close;
  qSICFAR.Connection := FDConnectionSICFAR;
  qSICFAR.SQL.Clear;
  qSICFAR.SQL.Add('SELECT');
  qSICFAR.SQL.Add('  PESSOA_ID,');
  qSICFAR.SQL.Add('  EMPRESA_ID,');
  qSICFAR.SQL.Add('  NOME_PUPULAR,');
  qSICFAR.SQL.Add('  NOME,');
  qSICFAR.SQL.Add('  ENDERECO,');
  qSICFAR.SQL.Add('  COMPLEMENTO,');
  qSICFAR.SQL.Add('  BAIRRO,');
  qSICFAR.SQL.Add('  CIDADE_ID,');
  qSICFAR.SQL.Add('  CIDADE,');
  qSICFAR.SQL.Add('  UF,');
  qSICFAR.SQL.Add('  CEP,');
  qSICFAR.SQL.Add('  PESSOA_VR,');
  qSICFAR.SQL.Add('  NATURALIDADE,');
  qSICFAR.SQL.Add('  NASCIMENTO,');
  qSICFAR.SQL.Add('  SEXO,');
  qSICFAR.SQL.Add('  TIPO,');
  qSICFAR.SQL.Add('  CPF_CNPJ,');
  qSICFAR.SQL.Add('  RG_CGF,');
  qSICFAR.SQL.Add('  ESTCIVIL,');
  qSICFAR.SQL.Add('  OBS,');
  qSICFAR.SQL.Add('  PAI,');
  qSICFAR.SQL.Add('  MAE,');
  qSICFAR.SQL.Add('  LIMITE_CREDITO,');
  qSICFAR.SQL.Add('  CONJUGE,');
  qSICFAR.SQL.Add('  COMISSAO,');
  qSICFAR.SQL.Add('  SITUACAO,');
  qSICFAR.SQL.Add('  DELETADO,');
  qSICFAR.SQL.Add('  EMAIL,');
  qSICFAR.SQL.Add('  SITE,');
  qSICFAR.SQL.Add('  CPF_CONJUGE,');
  qSICFAR.SQL.Add('  RG_CONJUGE,');
  qSICFAR.SQL.Add('  RG_ORGAO,');
  qSICFAR.SQL.Add('  RG_UF,');
  qSICFAR.SQL.Add('  RG_ORGAO_CONJUGE,');
  qSICFAR.SQL.Add('  RG_UF_CONJUGE,');
  qSICFAR.SQL.Add('  PROFISSAO,');
  qSICFAR.SQL.Add('  NATURAL_ID,');
  qSICFAR.SQL.Add('  NACIONALIDADE,');
  qSICFAR.SQL.Add('  REGIME_CASAMENTO,');
  qSICFAR.SQL.Add('  RENDA_CONJUGE,');
  qSICFAR.SQL.Add('  NACIONALIDADE_CONJUGE,');
  qSICFAR.SQL.Add('  PROFISSAO_CONJUGE,');
  qSICFAR.SQL.Add('  NUMERO,');
  qSICFAR.SQL.Add('  SUFRAMA,');
  qSICFAR.SQL.Add('  PAIS_ID,');
  qSICFAR.SQL.Add('  DATA_BATISMO,');
  qSICFAR.SQL.Add('  CARGO_ID,');
  qSICFAR.SQL.Add('  FUNCAO_ID,');
  qSICFAR.SQL.Add('  GRUPO_ID,');
  qSICFAR.SQL.Add('  SUBGRUPO_ID,');
  qSICFAR.SQL.Add('  NASCIMENTO_CONJUGE,');
  qSICFAR.SQL.Add('  DIA_VENCIMENTO,');
  qSICFAR.SQL.Add('  CNH,');
  qSICFAR.SQL.Add('  CNH_CATEGORIA,');
  qSICFAR.SQL.Add('  CNH_EMISSAO,');
  qSICFAR.SQL.Add('  CNH_VENCIMENTO,');
  qSICFAR.SQL.Add('  RG_EMISSAO,');
  qSICFAR.SQL.Add('  DATA_INC,');
  qSICFAR.SQL.Add('  USUARIO_ID,');
  qSICFAR.SQL.Add('  DATA_ALT,');
  qSICFAR.SQL.Add('  USUARIO_A,');
  qSICFAR.SQL.Add('  DATA_DEL,');
  qSICFAR.SQL.Add('  USUARIO_D,');
  qSICFAR.SQL.Add('  ERP_CODIGO,');
  qSICFAR.SQL.Add('  CTPS_N,');
  qSICFAR.SQL.Add('  CTPS_S,');
  qSICFAR.SQL.Add('  CTPS_UF,');
  qSICFAR.SQL.Add('  NIT,');
  qSICFAR.SQL.Add('  CTPS_EMISSAO,');
  qSICFAR.SQL.Add('  CNH_UF,');
  qSICFAR.SQL.Add('  DATA_ADMISSAO,');
  qSICFAR.SQL.Add('  TITULO_NUMERO,');
  qSICFAR.SQL.Add('  TITULO_ZONA,');
  qSICFAR.SQL.Add('  TITULO_SECAO,');
  qSICFAR.SQL.Add('  BANCO_ID,');
  qSICFAR.SQL.Add('  BANCO,');
  qSICFAR.SQL.Add('  AGENCIA,');
  qSICFAR.SQL.Add('  CONTA,');
  qSICFAR.SQL.Add('  COR,');
  qSICFAR.SQL.Add('  GRAU_INSTRUCAO,');
  qSICFAR.SQL.Add('  BLOQUEIO_ID,');
  qSICFAR.SQL.Add('  SETOR_ID,');
  qSICFAR.SQL.Add('  SYNC');
  qSICFAR.SQL.Add('FROM TBPESSOAS');
  qSICFAR.SQL.Add(WHERE_CLAUSE);
  qSICFAR.SQL.Add('ORDER BY PESSOA_ID');

  // Exibir Form de Atividade e contar registros
  if not Assigned(Form_Activity) then
  begin
    try
      Form_Activity := TForm_Activity.Create(Application);
      Form_Activity.Show;
      Form_Activity.Label_Status.Caption := 'Executando consulta...';
      Application.ProcessMessages;
    except
      on E: Exception do
      begin
        if Assigned(Form_Activity) then
          FreeAndNil(Form_Activity);
        raise Exception.Create('Erro ao criar formulário de atividade: ' + E.Message);
      end;
    end;
  end;

  qSICFAR.Open;

  TotalRecords := FDConnectionSICFAR.ExecSQLScalar(
    'SELECT COUNT(*) FROM TBPESSOAS' + WHERE_CLAUSE
  );

  if Assigned(Form_Activity) then
  begin
    try
      Form_Activity.Label_Status.Caption := Format('Preparando para importar... %d registros encontrados.', [TotalRecords]);
      Application.ProcessMessages;
    except
      // Ignora erros na interface
    end;
  end;
  Sleep(500);

  // 3) Prepara o UPSERT no Supabase
  qUp := TFDQuery.Create(nil);
  try
    qUp.Connection := FDConnectionSupabase;
    qUp.SQL.Text   := SQL_UPSERT;

    FDConnectionSupabase.StartTransaction;
    try
      qSICFAR.First;
      CurrentRecord := 0;
      while not qSICFAR.Eof do
      begin
        Inc(CurrentRecord);

        if Assigned(Form_Activity) then
        begin
          try
            Form_Activity.Label_Status.Caption := Format('Importando registro %d de %d...', [CurrentRecord, TotalRecords]);
            Application.ProcessMessages;
          except
            // Ignora erros na interface
          end;
        end;

        // Mapeamento de parâmetros Firebird → Supabase
        qUp.ParamByName('cliente_id').AsInteger := qSICFAR.FieldByName('PESSOA_ID').AsInteger;
        qUp.ParamByName('empresa_id').AsInteger := qSICFAR.FieldByName('EMPRESA_ID').AsInteger;
        qUp.ParamByName('nome_pupular').AsString := qSICFAR.FieldByName('NOME_PUPULAR').AsString;
        qUp.ParamByName('nome').AsString := qSICFAR.FieldByName('NOME').AsString;
        qUp.ParamByName('endereco').AsString := qSICFAR.FieldByName('ENDERECO').AsString;
        qUp.ParamByName('complemento').AsString := qSICFAR.FieldByName('COMPLEMENTO').AsString;
        qUp.ParamByName('bairro').AsString := qSICFAR.FieldByName('BAIRRO').AsString;
        qUp.ParamByName('cidade_id').AsInteger := qSICFAR.FieldByName('CIDADE_ID').AsInteger;
        qUp.ParamByName('cidade').AsString := qSICFAR.FieldByName('CIDADE').AsString;
        qUp.ParamByName('uf').AsString := qSICFAR.FieldByName('UF').AsString;
        qUp.ParamByName('cep').AsString := qSICFAR.FieldByName('CEP').AsString;
        qUp.ParamByName('vendedor_id').AsInteger := qSICFAR.FieldByName('PESSOA_VR').AsInteger;
        qUp.ParamByName('naturalidade').AsString := qSICFAR.FieldByName('NATURALIDADE').AsString;

        SetDateParam('nascimento', qSICFAR.FieldByName('NASCIMENTO'));

        qUp.ParamByName('sexo').AsString := qSICFAR.FieldByName('SEXO').AsString;
        qUp.ParamByName('tipo').AsString := qSICFAR.FieldByName('TIPO').AsString;
        qUp.ParamByName('cpf_cnpj').AsString := qSICFAR.FieldByName('CPF_CNPJ').AsString;
        qUp.ParamByName('rg_cgf').AsString := qSICFAR.FieldByName('RG_CGF').AsString;
        qUp.ParamByName('estcivil').AsString := qSICFAR.FieldByName('ESTCIVIL').AsString;
        qUp.ParamByName('obs').AsString := qSICFAR.FieldByName('OBS').AsString;
        qUp.ParamByName('pai').AsString := qSICFAR.FieldByName('PAI').AsString;
        qUp.ParamByName('mae').AsString := qSICFAR.FieldByName('MAE').AsString;
        qUp.ParamByName('limite_credito').AsFloat := qSICFAR.FieldByName('LIMITE_CREDITO').AsFloat;
        qUp.ParamByName('conjuge').AsString := qSICFAR.FieldByName('CONJUGE').AsString;
        qUp.ParamByName('comissao').AsFloat := qSICFAR.FieldByName('COMISSAO').AsFloat;
        qUp.ParamByName('situacao').AsString := qSICFAR.FieldByName('SITUACAO').AsString;
        qUp.ParamByName('deletado').AsString := qSICFAR.FieldByName('DELETADO').AsString;
        qUp.ParamByName('email').AsString := qSICFAR.FieldByName('EMAIL').AsString;
        qUp.ParamByName('site').AsString := qSICFAR.FieldByName('SITE').AsString;
        qUp.ParamByName('cpf_conjuge').AsString := qSICFAR.FieldByName('CPF_CONJUGE').AsString;
        qUp.ParamByName('rg_conjuge').AsString := qSICFAR.FieldByName('RG_CONJUGE').AsString;
        qUp.ParamByName('rg_orgao').AsString := qSICFAR.FieldByName('RG_ORGAO').AsString;
        qUp.ParamByName('rg_uf').AsString := qSICFAR.FieldByName('RG_UF').AsString;
        qUp.ParamByName('rg_orgao_conjuge').AsString := qSICFAR.FieldByName('RG_ORGAO_CONJUGE').AsString;
        qUp.ParamByName('rg_uf_conjuge').AsString := qSICFAR.FieldByName('RG_UF_CONJUGE').AsString;
        qUp.ParamByName('profissao').AsString := qSICFAR.FieldByName('PROFISSAO').AsString;
        qUp.ParamByName('natural_id').AsInteger := qSICFAR.FieldByName('NATURAL_ID').AsInteger;
        qUp.ParamByName('nacionalidade').AsString := qSICFAR.FieldByName('NACIONALIDADE').AsString;
        qUp.ParamByName('regime_casamento').AsString := qSICFAR.FieldByName('REGIME_CASAMENTO').AsString;
        qUp.ParamByName('renda_conjuge').AsFloat := qSICFAR.FieldByName('RENDA_CONJUGE').AsFloat;
        qUp.ParamByName('nacionalidade_conjuge').AsString := qSICFAR.FieldByName('NACIONALIDADE_CONJUGE').AsString;
        qUp.ParamByName('profissao_conjuge').AsString := qSICFAR.FieldByName('PROFISSAO_CONJUGE').AsString;
        qUp.ParamByName('numero').AsInteger := qSICFAR.FieldByName('NUMERO').AsInteger;
        qUp.ParamByName('suframa').AsString := qSICFAR.FieldByName('SUFRAMA').AsString;
        qUp.ParamByName('pais_id').AsInteger := qSICFAR.FieldByName('PAIS_ID').AsInteger;

        SetDateParam('data_batismo', qSICFAR.FieldByName('DATA_BATISMO'));

        qUp.ParamByName('cargo_id').AsInteger := qSICFAR.FieldByName('CARGO_ID').AsInteger;
        qUp.ParamByName('funcao_id').AsInteger := qSICFAR.FieldByName('FUNCAO_ID').AsInteger;
        qUp.ParamByName('grupo_id').AsInteger := qSICFAR.FieldByName('GRUPO_ID').AsInteger;
        qUp.ParamByName('subgrupo_id').AsInteger := qSICFAR.FieldByName('SUBGRUPO_ID').AsInteger;

        SetDateParam('nascimento_conjuge', qSICFAR.FieldByName('NASCIMENTO_CONJUGE'));

        qUp.ParamByName('dia_vencimento').AsInteger := qSICFAR.FieldByName('DIA_VENCIMENTO').AsInteger;
        qUp.ParamByName('cnh').AsString := qSICFAR.FieldByName('CNH').AsString;
        qUp.ParamByName('cnh_categoria').AsString := qSICFAR.FieldByName('CNH_CATEGORIA').AsString;

        SetDateParam('cnh_emissao', qSICFAR.FieldByName('CNH_EMISSAO'));
        SetDateParam('cnh_vencimento', qSICFAR.FieldByName('CNH_VENCIMENTO'));
        SetDateParam('rg_emissao', qSICFAR.FieldByName('RG_EMISSAO'));

        SetTimestampParam('data_inc', qSICFAR.FieldByName('DATA_INC'));
        qUp.ParamByName('usuario_i').AsInteger := qSICFAR.FieldByName('USUARIO_ID').AsInteger;
        SetTimestampParam('data_alt', qSICFAR.FieldByName('DATA_ALT'));
        qUp.ParamByName('usuario_a').AsInteger := qSICFAR.FieldByName('USUARIO_A').AsInteger;
        SetTimestampParam('data_del', qSICFAR.FieldByName('DATA_DEL'));
        qUp.ParamByName('usuario_d').AsInteger := qSICFAR.FieldByName('USUARIO_D').AsInteger;

        qUp.ParamByName('erp_codigo').AsString := qSICFAR.FieldByName('ERP_CODIGO').AsString;
        qUp.ParamByName('ctps_n').AsString := qSICFAR.FieldByName('CTPS_N').AsString;
        qUp.ParamByName('ctps_s').AsString := qSICFAR.FieldByName('CTPS_S').AsString;
        qUp.ParamByName('ctps_uf').AsString := qSICFAR.FieldByName('CTPS_UF').AsString;
        qUp.ParamByName('nit').AsString := qSICFAR.FieldByName('NIT').AsString;

        SetDateParam('ctps_emissao', qSICFAR.FieldByName('CTPS_EMISSAO'));

        qUp.ParamByName('cnh_uf').AsString := qSICFAR.FieldByName('CNH_UF').AsString;

        SetDateParam('data_admissao', qSICFAR.FieldByName('DATA_ADMISSAO'));

        qUp.ParamByName('titulo_numero').AsString := qSICFAR.FieldByName('TITULO_NUMERO').AsString;
        qUp.ParamByName('titulo_zona').AsString := qSICFAR.FieldByName('TITULO_ZONA').AsString;
        qUp.ParamByName('titulo_secao').AsString := qSICFAR.FieldByName('TITULO_SECAO').AsString;
        qUp.ParamByName('banco_id').AsInteger := qSICFAR.FieldByName('BANCO_ID').AsInteger;
        qUp.ParamByName('banco').AsString := qSICFAR.FieldByName('BANCO').AsString;
        qUp.ParamByName('agencia').AsString := qSICFAR.FieldByName('AGENCIA').AsString;
        qUp.ParamByName('conta').AsString := qSICFAR.FieldByName('CONTA').AsString;
        qUp.ParamByName('cor').AsString := qSICFAR.FieldByName('COR').AsString;
        qUp.ParamByName('grau_instrucao').AsString := qSICFAR.FieldByName('GRAU_INSTRUCAO').AsString;
        qUp.ParamByName('bloqueio_id').AsInteger := qSICFAR.FieldByName('BLOQUEIO_ID').AsInteger;
        qUp.ParamByName('setor_id').AsInteger := qSICFAR.FieldByName('SETOR_ID').AsInteger;
        qUp.ParamByName('sync').AsString := qSICFAR.FieldByName('SYNC').AsString;

        qUp.ExecSQL;

        // Controle de performance: atualiza interface a cada 10 registros
        if CurrentRecord mod 10 = 0 then
        begin
          try
            Application.ProcessMessages;
          except
            // Ignora erros no ProcessMessages
          end;
          Sleep(10);
        end;

        qSICFAR.Next;
      end;

      FDConnectionSupabase.Commit;
      CloseActivityForm;
      ShowMessage('Importação de clientes concluída com sucesso.');
    except
      on E: Exception do
      begin
        FDConnectionSupabase.Rollback;
        CloseActivityForm;
        raise;
      end;
    end;
  finally
    qUp.Free;
    if qSICFAR.Active then qSICFAR.Close;
    if FDConnectionSICFAR.Connected then FDConnectionSICFAR.Connected := False;
  end;

  {
    **************************************************************************
    * CAMPOS FIREBIRD (TBPESSOAS) NÃO MAPEADOS PARA SUPABASE (TBCLIENTE)       *
    *                                                                        *
    * Campos abaixo existem no Firebird mas não têm correspondência na         *
    * tabela tbcliente do Supabase. Foram intencionalmente ignorados nesta    *
    * implementação. Consulte docs/campos-nao-mapeados-tbcliente.md para      *
    * documentação completa e sugestões de implementação futura.            *
    **************************************************************************
    
    // Endereços Adicionais
    // ENT_NOME, ENT_ENDERECO, ENT_BAIRRO, ENT_CIDADE, ENT_UF, ENT_FONE
    
    // Telefones Múltiplos
    // FONE_01, FONE_02, FONE_03, FONE_04, WHATSAPP
    
    // Referências Comerciais
    // REF_01NOME, REF_02NOME, REF_03NOME, REF_01FONE, REF_02FONE, REF_03FONE
    
    // Endereço de Cobrança
    // COB_ENDERECO, COB_BAIRRO, COB_CIDADE, COB_UF, COB_CEP
    
    // Datas Específicas
    // DATACADASTRO, ALTERADO, DATA_CONVERSAO, DATA_MEMBRO, DATA_AFASTADO
    // DATA_EXAME, PROXIMO_EXAME
    
    // Veículos/Transporte
    // TIPO_TRANSP, CODIGO_ANTT
    
    // Recibos e Contratos
    // REC_CONTRATO, REC_CONTRATO_DATA, REC_DIMOB, REC_DIMOB_DATA
    
    // Contribuição
    // VALOR_CONTRIBUICAO, CAPTADOR, CONTRIBUINTE
    
    // Deficiência
    // DEFICIENCIA, TIPO_DEFICIENCIA
    
    // Contrato de Trabalho
    // CONTRATO_EXPERIENCIA, APRENDIZ, PRIMEIRO_EMPREGO
    
    // OPF e Outros
    // OPF, OPF_DESCRICAO, MES_VENCIMENTO, DIA_FATURA
    
    // Sistema/Controle
    // IDSOFT, REPLICADO, ID_OLD, RECNO
    
    // Outros campos diversos
    // CLASSES, DATACADASTRO, ALTERADO, TIPO_TRANSP, CODIGO_ANTT, CONTABIL
    // MEMBRO, EQUIPE_ID, DATA_CONVERSAO, DATA_MEMBRO, EMPREGADO, DOM_ID
    // DATA_AFASTADO, VIUVO, ORFAO, PAGAMENTO_ID, ORACAO, PAGAMENTO_VALOR
    // PERIODO, DC, FV, IMPOSTOS, PESSOAL, CAMPANHA_ID, CC_ID, TIPO_CLIENTE
    // ESPECIE, CNH_EMISSAO1, USUARIONOME_I, USUARIONOME_A, USUARIONOME_D
    // TIPO_FISCAL, CRACHA, NOME_CRACHA, BATE_PONTO, CARGO, FUNCAO
    // DEPARTAMENTO_ID, DEPARTAMENTO, COMPRAS, FUNCIONARIOS
    // DEPARTAMENTO_ID_SEG, DEPARTAMENTO_SEG, ULTIMA_COMPRA, BLOQUEADO
    // CONTATORH_ID, CONTATORH, DIA_FATURA, PIS, SETOR, SALARIO
    
    **************************************************************************
  }
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
