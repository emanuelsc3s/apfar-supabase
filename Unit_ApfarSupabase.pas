
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
    btn_ExportaCotacao: TPanel;
    btn_ImportarLicitacaoItem: TPanel;
    btn_ImportarProduto: TPanel;
    btn_Produto: TPanel;
    Button1: TButton;
    btn_IntegrarPesagem: TPanel;
    Edit_OP: TEdit;
    OP: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_ImportarReceberClick(Sender: TObject);
    procedure btn_ConfigurarClick(Sender: TObject);
    procedure btn_FecharClick(Sender: TObject);
    procedure btn_ImportarLoteDesvioClick(Sender: TObject);
    procedure btn_ImportarLicitacaoClick(Sender: TObject);
    procedure btn_ClienteClick(Sender: TObject);
    procedure btn_ExportaCotacaoClick(Sender: TObject);
    procedure btn_ImportarLicitacaoItemClick(Sender: TObject);
    procedure btn_ImportarProdutoClick(Sender: TObject);
    procedure btn_ProdutoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_IntegrarPesagemClick(Sender: TObject);
  private
    { Private declarations }
    FBusy: Boolean;
    FShutdownRequested: Boolean;
    procedure pImportaClienteSA1(prCodCliente: string);
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
  Close;
end;

procedure TForm_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FBusy then
  begin
    CanClose := False;
    FShutdownRequested := True;
    Exit;
  end;
  CanClose := True;
end;


procedure TForm_Principal.btn_ImportarLicitacaoClick(Sender: TObject);
const
  WHERE_CLAUSE =
    ' WHERE deletado = ''N'' and pessoa_vr in (''16531'',''11020'')';

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

  // Mapeia o código da modalidade (MODALIDADE_ID) para sua descrição textual
  function MapModalidadeDescricao(const AId: Integer): string;
  begin
    case AId of
      1:  Result := 'Pregão Eletrônico';
      2:  Result := 'Pregão Presencial';
      3:  Result := 'Tomada de Preços';
      4:  Result := 'Convite';
      5:  Result := 'Dispensa';
      6:  Result := 'Concorrência';
      7:  Result := 'Inexigibilidade';
      8:  Result := 'Leilão';
      9:  Result := 'Concurso';
      10: Result := 'Cotação';
      11: Result := 'Estimativa';
      12: Result := 'Orçamento';
      13: Result := 'EDENIO REPRESENTAÇÕES';
      14: Result := 'Compra Direta';
      15: Result := 'Proposta Comercial';
      16: Result := 'Ordem de Compra';
      17: Result := 'BIONEXO';
      18: Result := 'OFICIO';
    else
      // Valor padrão quando o código não corresponde à tabela
      Result := 'Não Informada';
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
  qSICFAR.SQL.Add('  USUARIO_I,');
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

        // Tratar nulos corretamente para colunas inteiras (PostgreSQL: integer)
        qUp.ParamByName('cliente_id').DataType := ftInteger;

        if qSICFAR.FieldByName('CLIENTE_ID').IsNull then
          qUp.ParamByName('cliente_id').Clear
        else
          qUp.ParamByName('cliente_id').AsInteger := qSICFAR.FieldByName('CLIENTE_ID').AsInteger;

        qUp.ParamByName('orgao_id').DataType := ftInteger;

        if qSICFAR.FieldByName('PESSOA_ID').IsNull then
          qUp.ParamByName('orgao_id').Clear
        else
          qUp.ParamByName('orgao_id').AsInteger := qSICFAR.FieldByName('PESSOA_ID').AsInteger;

        SetDateParam('data', qSICFAR.FieldByName('DATA'));

        qUp.ParamByName('processo').AsString           := qSICFAR.FieldByName('PROCESSO').AsString;
        qUp.ParamByName('processo_ano').AsString       := qSICFAR.FieldByName('PROCESSO_ANO').AsString;
        qUp.ParamByName('processo_admin').AsString     := qSICFAR.FieldByName('PROCESSO_ADMIN').AsString;
        qUp.ParamByName('processo_admin_ano').AsString := qSICFAR.FieldByName('PROCESSO_ADMIN_ANO').AsString;
        qUp.ParamByName('portaria').AsString           := qSICFAR.FieldByName('PORTARIA').AsString;
        qUp.ParamByName('portaria_ano').AsString       := qSICFAR.FieldByName('PORTARIA_ANO').AsString;
        qUp.ParamByName('modalidade_id').AsInteger     := qSICFAR.FieldByName('MODALIDADE_ID').AsInteger;

        qUp.ParamByName('modalidade').AsString         := MapModalidadeDescricao(qSICFAR.FieldByName('MODALIDADE_ID').AsInteger);

        qUp.ParamByName('modalidade_numero').AsString  := qSICFAR.FieldByName('MODALIDADE_NUMERO').AsString;
        qUp.ParamByName('modalidade_ano').AsString     := qSICFAR.FieldByName('MODALIDADE_ANO').AsString;
        qUp.ParamByName('objeto_id').AsInteger         := qSICFAR.FieldByName('OBJETO_ID').AsInteger;

        SetTimestampParam('data_inc', qSICFAR.FieldByName('DATA_INC'));
        qUp.ParamByName('usuario_i').AsInteger := qSICFAR.FieldByName('USUARIO_I').AsInteger;
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

        qUp.ParamByName('site').AsString              := qSICFAR.FieldByName('SITE').AsString;
        qUp.ParamByName('entregas').AsInteger         := qSICFAR.FieldByName('ENTREGAS').AsInteger;
        qUp.ParamByName('licitacao_origem').AsInteger := qSICFAR.FieldByName('LICITACAO_ORIGEM').AsInteger;

        SetDateParam('vigencia_ini', qSICFAR.FieldByName('VIGENCIA_INI'));

        qUp.ParamByName('status').AsString := qSICFAR.FieldByName('STATUS').AsString;
        qUp.ParamByName('obs_interno').AsString := qSICFAR.FieldByName('OBS_INTERNO').AsString;
        qUp.ParamByName('obs_cliente').AsString := qSICFAR.FieldByName('OBS_CLIENTE').AsString;
        qUp.ParamByName('sync').AsString := qSICFAR.FieldByName('SYNC').AsString;

        // Campos adicionais no Supabase que não existem no Firebird
        qUp.ParamByName('objeto').AsString := '';
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

procedure TForm_Principal.btn_ImportarLicitacaoItemClick(Sender: TObject);
  const
    WHERE_CLAUSE =
      ' WHERE i.deletado = ''N'' AND l.deletado = ''N'' AND l.pessoa_vr in (''16531'',''11020'')';

    SQL_UPSERT =
      'INSERT INTO public.tblicitacao_item (' +
      '  litem_id, licitacao_id, produto_id, preco, quantidade, data_inc, usuario_i, ' +
      '  data_alt, usuario_a, data_del, usuario_d, deletado, preco_inicial, preco_final, ' +
      '  pdv, preco_ganho, participa, concorrente_id, preco_concorrente, item_edital, ' +
      '  status, margem, qtde_pedido, qtde_nf, resultado, marca, motivoperda_id, ' +
      '  motivoperda, preco_maximo, sync, sync_data, usuarionome_i, marca2, ' +
      '  concorrente2_id, concorrente2' +
      ') VALUES (' +
      '  :litem_id, :licitacao_id, :produto_id, :preco, :quantidade, :data_inc, :usuario_i, ' +
      '  :data_alt, :usuario_a, :data_del, :usuario_d, :deletado, :preco_inicial, :preco_final, ' +
      '  :pdv, :preco_ganho, :participa, :concorrente_id, :preco_concorrente, :item_edital, ' +
      '  :status, :margem, :qtde_pedido, :qtde_nf, :resultado, :marca, :motivoperda_id, ' +
      '  :motivoperda, :preco_maximo, :sync, (now() at time zone ''America/Sao_Paulo''), ' +
      '  :usuarionome_i, :marca2, :concorrente2_id, :concorrente2' +
      ') ON CONFLICT (litem_id) DO UPDATE SET ' +
      '  licitacao_id=EXCLUDED.licitacao_id, produto_id=EXCLUDED.produto_id, ' +
      '  preco=EXCLUDED.preco, quantidade=EXCLUDED.quantidade, data_inc=EXCLUDED.data_inc, ' +
      '  usuario_i=EXCLUDED.usuario_i, data_alt=EXCLUDED.data_alt, usuario_a=EXCLUDED.usuario_a, ' +
      '  data_del=EXCLUDED.data_del, usuario_d=EXCLUDED.usuario_d, deletado=EXCLUDED.deletado, ' +
      '  preco_inicial=EXCLUDED.preco_inicial, preco_final=EXCLUDED.preco_final, pdv=EXCLUDED.pdv, ' +
      '  preco_ganho=EXCLUDED.preco_ganho, participa=EXCLUDED.participa, concorrente_id=EXCLUDED.concorrente_id, ' +
      '  preco_concorrente=EXCLUDED.preco_concorrente, item_edital=EXCLUDED.item_edital, status=EXCLUDED.status, ' +
      '  margem=EXCLUDED.margem, qtde_pedido=EXCLUDED.qtde_pedido, qtde_nf=EXCLUDED.qtde_nf, ' +
      '  resultado=EXCLUDED.resultado, marca=EXCLUDED.marca, motivoperda_id=EXCLUDED.motivoperda_id, ' +
      '  motivoperda=EXCLUDED.motivoperda, preco_maximo=EXCLUDED.preco_maximo, sync=EXCLUDED.sync, ' +
      '  sync_data=(now() at time zone ''America/Sao_Paulo''), usuarionome_i=EXCLUDED.usuarionome_i, ' +
      '  marca2=EXCLUDED.marca2, concorrente2_id=EXCLUDED.concorrente2_id, concorrente2=EXCLUDED.concorrente2';
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
        end;
        try
          FreeAndNil(Form_Activity);
        except
        end;
      end;
    end;

    procedure SetTimestampParam(const PName: string; F: TField);
    var s: string; dt: TDateTime;
    begin
      qUp.ParamByName(PName).DataType := ftDateTime;
      if F.IsNull then
        qUp.ParamByName(PName).Clear
      else if F.DataType in [ftDateTime, ftTimeStamp] then
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

    procedure SetIntParam(const PName: string; F: TField);
    begin
      qUp.ParamByName(PName).DataType := ftInteger;
      if F.IsNull then qUp.ParamByName(PName).Clear
      else qUp.ParamByName(PName).AsInteger := F.AsInteger;
    end;

    procedure SetFloatParam(const PName: string; F: TField);
    begin
      qUp.ParamByName(PName).DataType := ftFloat;
      if F.IsNull then qUp.ParamByName(PName).Clear
      else qUp.ParamByName(PName).AsFloat := F.AsFloat;
    end;

    procedure SetStrParam(const PName: string; F: TField);
    begin
      // Define tipo explicitamente para evitar EFDException: data type is unknown
      qUp.ParamByName(PName).DataType := ftString;
      if F.IsNull then
        qUp.ParamByName(PName).Clear
      else
        qUp.ParamByName(PName).AsString := F.AsString;
    end;
  begin
    // formato para parse dd/MM/yyyy hh:nn:ss quando vier como texto
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

    // 2) Preparar consulta no SICFAR
    DataSource1.DataSet := qSICFAR;
    qSICFAR.Close;
    qSICFAR.Connection := FDConnectionSICFAR;
    qSICFAR.SQL.Clear;
    qSICFAR.SQL.Add('SELECT i.LITEM_ID, i.LICITACAO_ID, i.PRODUTO_ID, i.PRECO, i.QUANTIDADE, i.DATA_INC, i.USUARIO_I, ' +
                    'i.DATA_ALT, i.USUARIO_A, i.DATA_DEL, i.USUARIO_D, i.DELETADO, i.PRECO_INICIAL, i.PRECO_FINAL, ' +
                    'i.PDV, i.PRECO_GANHO, i.PARTICIPA, i.CONCORRENTE_ID, i.PRECO_CONCORRENTE, i.ITEM_EDITAL, ' +
                    'i.STATUS, i.MARGEM, i.QTDE_PEDIDO, i.QTDE_NF, i.RESULTADO, i.MARCA, i.MOTIVOPERDA_ID, i.MOTIVOPERDA, ' +
                    'i.PRECO_MAXIMO, i.SYNC, i.SYNC_DATA, i.USUARIONOME_I, i.MARCA2, i.CONCORRENTE2_ID');
    qSICFAR.SQL.Add('FROM TBLICITACAO_ITEM i JOIN TBLICITACAO l ON l.LICITACAO_ID = i.LICITACAO_ID');
    qSICFAR.SQL.Add(WHERE_CLAUSE);
    qSICFAR.SQL.Add('ORDER BY i.LITEM_ID');

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

    try
      TotalRecords := FDConnectionSICFAR.ExecSQLScalar(
        'SELECT COUNT(*) FROM TBLICITACAO_ITEM i JOIN TBLICITACAO l ON l.LICITACAO_ID = i.LICITACAO_ID' + WHERE_CLAUSE
      );
    except
      TotalRecords := -1;
    end;

    if Assigned(Form_Activity) then
    begin
      try
        if TotalRecords >= 0 then
          Form_Activity.Label_Status.Caption := Format('Preparando para importar... %d registros encontrados.', [TotalRecords])
        else
          Form_Activity.Label_Status.Caption := 'Preparando para importar...';
        Application.ProcessMessages;
      except
      end;
    end;
    Sleep(400);

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
              if TotalRecords > 0 then
                Form_Activity.Label_Status.Caption := Format('Importando registro %d de %d...', [CurrentRecord, TotalRecords])
              else
                Form_Activity.Label_Status.Caption := 'Importando...';
              Application.ProcessMessages;
            except
            end;
          end;

          // Mapeamento Firebird -> Supabase
          SetIntParam('litem_id',        qSICFAR.FieldByName('LITEM_ID'));
          SetIntParam('licitacao_id',    qSICFAR.FieldByName('LICITACAO_ID'));
          SetIntParam('produto_id',      qSICFAR.FieldByName('PRODUTO_ID'));
          SetFloatParam('preco',         qSICFAR.FieldByName('PRECO'));
          SetFloatParam('quantidade',    qSICFAR.FieldByName('QUANTIDADE'));
          SetTimestampParam('data_inc',  qSICFAR.FieldByName('DATA_INC'));
          SetIntParam('usuario_i',       qSICFAR.FieldByName('USUARIO_I'));
          SetTimestampParam('data_alt',  qSICFAR.FieldByName('DATA_ALT'));
          SetIntParam('usuario_a',       qSICFAR.FieldByName('USUARIO_A'));
          SetTimestampParam('data_del',  qSICFAR.FieldByName('DATA_DEL'));
          SetIntParam('usuario_d',       qSICFAR.FieldByName('USUARIO_D'));
          SetStrParam('deletado',        qSICFAR.FieldByName('DELETADO'));
          SetFloatParam('preco_inicial', qSICFAR.FieldByName('PRECO_INICIAL'));
          SetFloatParam('preco_final',   qSICFAR.FieldByName('PRECO_FINAL'));
          SetFloatParam('pdv',           qSICFAR.FieldByName('PDV'));
          SetFloatParam('preco_ganho',   qSICFAR.FieldByName('PRECO_GANHO'));
          SetStrParam('participa',       qSICFAR.FieldByName('PARTICIPA'));
          SetIntParam('concorrente_id',  qSICFAR.FieldByName('CONCORRENTE_ID'));
          SetFloatParam('preco_concorrente', qSICFAR.FieldByName('PRECO_CONCORRENTE'));
          SetStrParam('item_edital',     qSICFAR.FieldByName('ITEM_EDITAL'));
          SetStrParam('status',          qSICFAR.FieldByName('STATUS'));
          SetFloatParam('margem',        qSICFAR.FieldByName('MARGEM'));
          SetFloatParam('qtde_pedido',   qSICFAR.FieldByName('QTDE_PEDIDO'));
          SetFloatParam('qtde_nf',       qSICFAR.FieldByName('QTDE_NF'));
          SetStrParam('resultado',       qSICFAR.FieldByName('RESULTADO'));
          SetStrParam('marca',           qSICFAR.FieldByName('MARCA'));
          SetIntParam('motivoperda_id',  qSICFAR.FieldByName('MOTIVOPERDA_ID'));
          SetStrParam('motivoperda',     qSICFAR.FieldByName('MOTIVOPERDA'));
          SetFloatParam('preco_maximo',  qSICFAR.FieldByName('PRECO_MAXIMO'));
          SetStrParam('sync',            qSICFAR.FieldByName('SYNC'));
          // sync_data é setado no SQL como now() at time zone 'America/Sao_Paulo'
          SetStrParam('usuarionome_i',   qSICFAR.FieldByName('USUARIONOME_I'));
          SetStrParam('marca2',          qSICFAR.FieldByName('MARCA2'));
          SetIntParam('concorrente2_id', qSICFAR.FieldByName('CONCORRENTE2_ID'));
          // Campo concorrente2 não existe no Firebird -> enviar vazio
          qUp.ParamByName('concorrente2').DataType := ftString;
          qUp.ParamByName('concorrente2').AsString := '';

          qUp.ExecSQL;

          if (CurrentRecord mod 15 = 0) then
          begin
            try
              Application.ProcessMessages;
            except
            end;
            Sleep(10);
          end;

          qSICFAR.Next;
        end;

        FDConnectionSupabase.Commit;
        CloseActivityForm;
        ShowMessage('Importação de itens de licitação concluída com sucesso.');
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
      try if qSICFAR.Active then qSICFAR.Close; except end;
      if FDConnectionSICFAR.Connected then FDConnectionSICFAR.Connected := False;
    end;
end;

procedure TForm_Principal.btn_ImportarLoteDesvioClick(Sender: TObject);
const
  FROM_JOIN_CLAUSE =
    'FROM tbdesvio_produto dp ' +
    'JOIN tbdesvio d ON d.desvio_id = dp.desvio_id ';
  WHERE_CLAUSE =
    ' WHERE dp.deletado = ''N'' ' +
    ' AND d.deletado  = ''N'' ' +
    ' AND dp.lote IS NOT NULL ';
  // Condição opcional:
  // ' AND dp.lote = ''24C12184E'' ';
var
  Ini          : TIniFile;
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
    DataSource1.DataSet := qSICFAR;

    qSICFAR.Close;
    qSICFAR.Connection := FDConnectionSICFAR;
    qSICFAR.SQL.Clear;
    qSICFAR.SQL.Add('SELECT');
    qSICFAR.SQL.Add('  dp.lote,');
    qSICFAR.SQL.Add('  CASE');
    qSICFAR.SQL.Add('    WHEN COUNT(CASE WHEN d.status NOT IN (''Concluído'', ''Rejeitado - GQT'', ''Cancelado'') THEN 1 END) = 0 THEN ''TODOS_CONCLUIDOS''');
    qSICFAR.SQL.Add('    ELSE ''PENDENTE''');
    qSICFAR.SQL.Add('  END AS status_lote,');
    qSICFAR.SQL.Add('  LIST(DISTINCT CAST(dp.desvio_id AS VARCHAR(20)), '','') AS desvios_ids,');
    qSICFAR.SQL.Add('  LIST(DISTINCT d.status, '','') AS status_list');
    qSICFAR.SQL.Add(FROM_JOIN_CLAUSE);
    qSICFAR.SQL.Add(WHERE_CLAUSE);

    qSICFAR.SQL.Add('GROUP BY dp.lote');


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
        'SELECT COUNT(DISTINCT dp.lote) ' +
        FROM_JOIN_CLAUSE +
        WHERE_CLAUSE
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
                Format('Atualizando registro %d de %d... Lote: %s [%s]',
                  [CurrentRecord, TotalRecords,
                   Trim(qSICFAR.FieldByName('lote').AsString),
                   Trim(qSICFAR.FieldByName('status_lote').AsString)])
            else
              Form_Activity.Label_Status.Caption :=
                Format('Atualizando... Lote: %s [%s]',
                  [Trim(qSICFAR.FieldByName('lote').AsString),
                   Trim(qSICFAR.FieldByName('status_lote').AsString)]);
            Application.ProcessMessages;
          except
            // Ignora erros na interface
          end;
        end;
        // Utiliza a lista completa de IDs (desvios_ids) sem extrair apenas o primeiro ID

        // 3) Preparar UPDATE no TOTVS (parametrizado) com lógica condicional baseada no status do lote
        with qTOTVS do
          begin
              Close;
              Connection := FDConnectionTOTVS;

              // Verificar se todos os desvios do lote estão concluídos
              if Trim(qSICFAR.FieldByName('status_lote').AsString) = 'TODOS_CONCLUIDOS' then
              begin
                // Se todos os desvios estão concluídos, limpar o campo D7_YSICCQ
                SQL.Text :=
                'UPDATE SD7010 ' +
                'SET D7_YSICCQ = '''' ' +
                'WHERE D_E_L_E_T_ = '''' ' +
                '  AND D7_LOTECTL = :pLote';

                ParamByName('pLote').AsString := qSICFAR.FieldByName('lote').AsString;
              end
              else
              begin
                // Se há desvios pendentes, manter/alimentar o campo D7_YSICCQ normalmente
                SQL.Text :=
                'UPDATE SD7010 ' +
                'SET D7_YSICCQ = :pDesvioId ' +
                'WHERE D_E_L_E_T_ = '''' ' +
                '  AND D7_LOTECTL = :pLote';

                // Obs.: Certifique-se de que o campo D7_YSICCQ no TOTVS comporte o tamanho total da lista
                ParamByName('pDesvioId').AsString := qSICFAR.FieldByName('desvios_ids').AsString;
                ParamByName('pLote').AsString     := qSICFAR.FieldByName('lote').AsString;
              end;

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

procedure TForm_Principal.btn_ImportarProdutoClick(Sender: TObject);
const
  // Importa apenas produtos não deletados
  WHERE_CLAUSE =
    ' WHERE deletado = ''N'' ';

  SQL_UPSERT =
    'INSERT INTO public.tbproduto (' +
    '  produto_id, empresa_id, usuario_id, referencia, descricao, codbarra,' +
    '  ipi, icms, unidade, peso_bruto, peso_liquido, estoque_minimo,' +
    '  deletado, comissao, estoque_id, tipoproduto_id, grupo_id, subgrupo_id,' +
    '  ncm, obs, erp_codigo, qtde_caixa, preco_maximo, data_inc, usuario_i,' +
    '  data_alt, usuario_a, data_del, usuario_d, bloqueado, sync, sync_data' +
    ') VALUES (' +
    '  :produto_id, :empresa_id, :usuario_id, :referencia, :descricao, :codbarra,' +
    '  :ipi, :icms, :unidade, :peso_bruto, :peso_liquido, :estoque_minimo,' +
    '  :deletado, :comissao, :estoque_id, :tipoproduto_id, :grupo_id, :subgrupo_id,' +
    '  :ncm, :obs, :erp_codigo, :qtde_caixa, :preco_maximo, :data_inc, :usuario_i,' +
    '  :data_alt, :usuario_a, :data_del, :usuario_d, :bloqueado, :sync,' +
    '  (now() at time zone ''America/Sao_Paulo'')' +
    ') ON CONFLICT (produto_id) DO UPDATE SET ' +
    '  empresa_id=EXCLUDED.empresa_id, usuario_id=EXCLUDED.usuario_id,' +
    '  referencia=EXCLUDED.referencia, descricao=EXCLUDED.descricao,' +
    '  codbarra=EXCLUDED.codbarra, ipi=EXCLUDED.ipi, icms=EXCLUDED.icms,' +
    '  unidade=EXCLUDED.unidade, peso_bruto=EXCLUDED.peso_bruto,' +
    '  peso_liquido=EXCLUDED.peso_liquido, estoque_minimo=EXCLUDED.estoque_minimo,' +
    '  deletado=EXCLUDED.deletado, comissao=EXCLUDED.comissao,' +
    '  estoque_id=EXCLUDED.estoque_id, tipoproduto_id=EXCLUDED.tipoproduto_id,' +
    '  grupo_id=EXCLUDED.grupo_id, subgrupo_id=EXCLUDED.subgrupo_id,' +
    '  ncm=EXCLUDED.ncm, obs=EXCLUDED.obs, erp_codigo=EXCLUDED.erp_codigo,' +
    '  qtde_caixa=EXCLUDED.qtde_caixa, preco_maximo=EXCLUDED.preco_maximo,' +
    '  data_inc=EXCLUDED.data_inc, usuario_i=EXCLUDED.usuario_i,' +
    '  data_alt=EXCLUDED.data_alt, usuario_a=EXCLUDED.usuario_a,' +
    '  data_del=EXCLUDED.data_del, usuario_d=EXCLUDED.usuario_d,' +
    '  bloqueado=EXCLUDED.bloqueado, sync=EXCLUDED.sync,' +
    '  sync_data=(now() at time zone ''America/Sao_Paulo'')';
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
      end;
      try
        FreeAndNil(Form_Activity);
      except
      end;
    end;
  end;

  // Ajusta parâmetro DATE (quando vier como string dd/MM/yyyy)
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

  // Ajusta parâmetro TIMESTAMP
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

  // Converte campo varchar numérico para inteiro (grupo_id/subgrupo_id)
  procedure SetIntFromStrParam(const PName: string; F: TField);
  var s: string; v: Integer;
  begin
    qUp.ParamByName(PName).DataType := ftInteger;
    s := Trim(F.AsString);
    if s = '' then qUp.ParamByName(PName).Clear
    else
      try
        v := StrToInt(s);
        qUp.ParamByName(PName).AsInteger := v;
      except
        qUp.ParamByName(PName).Clear;
      end;
  end;
begin
  // Formato para parse dd/MM/yyyy e hh:nn:ss quando necessário
  fs := TFormatSettings.Create;
  fs.DateSeparator   := '/';
  fs.ShortDateFormat := 'dd/MM/yyyy';
  fs.TimeSeparator   := ':';
  fs.ShortTimeFormat := 'hh:nn:ss';

  FDConnectionSupabase.Connected := True;

  // 1) Conectar ao SICFAR (Firebird)
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');
  try
    if not Assigned(Form_ConfigSqlServer) then
      Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionSICFAR, 'SICFAR');
  finally
    Ini.Free;
  end;

  // 2) Preparar consulta de produtos no SICFAR
  DataSource1.DataSet := qSICFAR;
  qSICFAR.Close;
  qSICFAR.Connection := FDConnectionSICFAR;
  qSICFAR.SQL.Clear;
  qSICFAR.SQL.Add('SELECT');
  qSICFAR.SQL.Add('  PRODUTO_ID, EMPRESA_ID, USUARIO_ID, REFERENCIA, DESCRICAO, CODBARRA,');
  qSICFAR.SQL.Add('  IPI, ICMS, UNIDADE, PESO_BRUTO, PESO_LIQUIDO, ESTOQUE_MINIMO,');
  qSICFAR.SQL.Add('  DELETADO, COMISSAO, ESTOQUE_ID, TIPOPRODUTO_ID, GRUPO_ID, SUBGRUPO_ID,');
  qSICFAR.SQL.Add('  NCM, OBS, ERP_CODIGO, QTDE_CAIXA, PRECO_MAXIMO, DATA_INC, USUARIO_I,');
  qSICFAR.SQL.Add('  DATA_ALT, USUARIO_A, DATA_DEL, USUARIO_D, BLOQUEADO, SYNC, SYNC_DATA');
  qSICFAR.SQL.Add('FROM TBPRODUTOS');
  qSICFAR.SQL.Add(WHERE_CLAUSE);
  qSICFAR.SQL.Add('ORDER BY PRODUTO_ID');

  // 2.1) Form de atividade
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

  try
    TotalRecords := FDConnectionSICFAR.ExecSQLScalar(
      'SELECT COUNT(*) FROM TBPRODUTOS' + WHERE_CLAUSE
    );
  except
    TotalRecords := -1;
  end;

  if Assigned(Form_Activity) then
  begin
    try
      if TotalRecords >= 0 then
        Form_Activity.Label_Status.Caption := Format('Preparando para importar... %d registros encontrados.', [TotalRecords])
      else
        Form_Activity.Label_Status.Caption := 'Preparando para importar...';
      Application.ProcessMessages;
    except
    end;
  end;
  Sleep(400);

  // 3) UPSERT no Supabase
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
            if TotalRecords > 0 then
              Form_Activity.Label_Status.Caption := Format('Importando produto %d de %d...', [CurrentRecord, TotalRecords])
            else
              Form_Activity.Label_Status.Caption := 'Importando produtos...';
            Application.ProcessMessages;
          except
          end;
        end;

        // Mapeamento TBPRODUTOS (Firebird) -> TBPRODUTO (Supabase)
        qUp.ParamByName('produto_id').AsInteger      := qSICFAR.FieldByName('PRODUTO_ID').AsInteger;
        qUp.ParamByName('empresa_id').AsInteger      := qSICFAR.FieldByName('EMPRESA_ID').AsInteger;
        qUp.ParamByName('usuario_id').AsInteger      := qSICFAR.FieldByName('USUARIO_ID').AsInteger;
        qUp.ParamByName('referencia').AsString       := qSICFAR.FieldByName('REFERENCIA').AsString;
        qUp.ParamByName('descricao').AsString        := qSICFAR.FieldByName('DESCRICAO').AsString;
        qUp.ParamByName('codbarra').AsString         := qSICFAR.FieldByName('CODBARRA').AsString;
        qUp.ParamByName('ipi').AsFloat               := qSICFAR.FieldByName('IPI').AsFloat;
        qUp.ParamByName('icms').AsFloat              := qSICFAR.FieldByName('ICMS').AsFloat;
        qUp.ParamByName('unidade').AsString          := qSICFAR.FieldByName('UNIDADE').AsString;
        qUp.ParamByName('peso_bruto').AsFloat        := qSICFAR.FieldByName('PESO_BRUTO').AsFloat;
        qUp.ParamByName('peso_liquido').AsFloat      := qSICFAR.FieldByName('PESO_LIQUIDO').AsFloat;
        // ESTOQUE_MINIMO é integer no Firebird; Supabase aceita numeric
        qUp.ParamByName('estoque_minimo').AsFloat    := qSICFAR.FieldByName('ESTOQUE_MINIMO').AsFloat;

        qUp.ParamByName('deletado').AsString         := qSICFAR.FieldByName('DELETADO').AsString;
        qUp.ParamByName('comissao').AsFloat          := qSICFAR.FieldByName('COMISSAO').AsFloat;
        qUp.ParamByName('estoque_id').AsInteger      := qSICFAR.FieldByName('ESTOQUE_ID').AsInteger;
        qUp.ParamByName('tipoproduto_id').AsInteger  := qSICFAR.FieldByName('TIPOPRODUTO_ID').AsInteger;
        SetIntFromStrParam('grupo_id',               qSICFAR.FieldByName('GRUPO_ID'));
        SetIntFromStrParam('subgrupo_id',            qSICFAR.FieldByName('SUBGRUPO_ID'));
        qUp.ParamByName('ncm').AsString              := qSICFAR.FieldByName('NCM').AsString;
        qUp.ParamByName('obs').DataType              := ftMemo; // OBS é BLOB SUB_TYPE 1 (texto)
        qUp.ParamByName('obs').AsString              := qSICFAR.FieldByName('OBS').AsString;
        qUp.ParamByName('erp_codigo').AsString       := qSICFAR.FieldByName('ERP_CODIGO').AsString;
        qUp.ParamByName('qtde_caixa').AsFloat        := qSICFAR.FieldByName('QTDE_CAIXA').AsFloat;
        qUp.ParamByName('preco_maximo').AsFloat      := qSICFAR.FieldByName('PRECO_MAXIMO').AsFloat;

        SetTimestampParam('data_inc',                qSICFAR.FieldByName('DATA_INC'));
        qUp.ParamByName('usuario_i').AsInteger       := qSICFAR.FieldByName('USUARIO_I').AsInteger;
        SetTimestampParam('data_alt',                qSICFAR.FieldByName('DATA_ALT'));
        qUp.ParamByName('usuario_a').AsInteger       := qSICFAR.FieldByName('USUARIO_A').AsInteger;
        SetTimestampParam('data_del',                qSICFAR.FieldByName('DATA_DEL'));
        qUp.ParamByName('usuario_d').AsInteger       := qSICFAR.FieldByName('USUARIO_D').AsInteger;

        qUp.ParamByName('bloqueado').AsString        := qSICFAR.FieldByName('BLOQUEADO').AsString;
        qUp.ParamByName('sync').AsString             := qSICFAR.FieldByName('SYNC').AsString;
        // sync_data é ajustado no SQL com now() at time zone 'America/Sao_Paulo'

        qUp.ExecSQL;

        // Atualiza UI a cada 20 registros
        if (CurrentRecord mod 20 = 0) then
        begin
          try
            Application.ProcessMessages;
          except
          end;
          Sleep(10);
        end;

        qSICFAR.Next;
      end;

      FDConnectionSupabase.Commit;
      CloseActivityForm;
      ShowMessage('Importação de produtos concluída com sucesso.');
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
    try if qSICFAR.Active then qSICFAR.Close; except end;
    if FDConnectionSICFAR.Connected then FDConnectionSICFAR.Connected := False;
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
        pImportaClienteSA1(qTOTVS.FieldByName('erp_cliente').AsString);

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

procedure TForm_Principal.btn_ProdutoClick(Sender: TObject);
const
  // Filtrar somente produtos não deletados
  WHERE_CLAUSE = ' WHERE deletado = ''N'' and subgrupo_id = ''07'' ';

  SQL_UPSERT =
    'INSERT INTO public.tbproduto (' +
    '  produto_id, empresa_id, usuario_id, referencia, descricao, codbarra, ' +
    '  ipi, icms, unidade, peso_bruto, peso_liquido, estoque_minimo, ' +
    '  deletado, comissao, estoque_id, tipoproduto_id, grupo_id, subgrupo_id, ' +
    '  ncm, obs, erp_codigo, qtde_caixa, preco_maximo, data_inc, usuario_i, ' +
    '  data_alt, usuario_a, data_del, usuario_d, bloqueado, sync, sync_data' +
    ') VALUES (' +
    '  :produto_id, :empresa_id, :usuario_id, :referencia, :descricao, :codbarra, ' +
    '  :ipi, :icms, :unidade, :peso_bruto, :peso_liquido, :estoque_minimo, ' +
    '  :deletado, :comissao, :estoque_id, :tipoproduto_id, :grupo_id, :subgrupo_id, ' +
    '  :ncm, :obs, :erp_codigo, :qtde_caixa, :preco_maximo, :data_inc, :usuario_i, ' +
    '  :data_alt, :usuario_a, :data_del, :usuario_d, :bloqueado, :sync, (now() at time zone ''America/Sao_Paulo'')' +
    ') ON CONFLICT (produto_id) DO UPDATE SET ' +
    '  empresa_id=EXCLUDED.empresa_id, usuario_id=EXCLUDED.usuario_id, ' +
    '  referencia=EXCLUDED.referencia, descricao=EXCLUDED.descricao, ' +
    '  codbarra=EXCLUDED.codbarra, ipi=EXCLUDED.ipi, icms=EXCLUDED.icms, ' +
    '  unidade=EXCLUDED.unidade, peso_bruto=EXCLUDED.peso_bruto, ' +
    '  peso_liquido=EXCLUDED.peso_liquido, estoque_minimo=EXCLUDED.estoque_minimo, ' +
    '  deletado=EXCLUDED.deletado, comissao=EXCLUDED.comissao, ' +
    '  estoque_id=EXCLUDED.estoque_id, tipoproduto_id=EXCLUDED.tipoproduto_id, ' +
    '  grupo_id=EXCLUDED.grupo_id, subgrupo_id=EXCLUDED.subgrupo_id, ' +
    '  ncm=EXCLUDED.ncm, obs=EXCLUDED.obs, erp_codigo=EXCLUDED.erp_codigo, ' +
    '  qtde_caixa=EXCLUDED.qtde_caixa, preco_maximo=EXCLUDED.preco_maximo, ' +
    '  data_inc=EXCLUDED.data_inc, usuario_i=EXCLUDED.usuario_i, ' +
    '  data_alt=EXCLUDED.data_alt, usuario_a=EXCLUDED.usuario_a, ' +
    '  data_del=EXCLUDED.data_del, usuario_d=EXCLUDED.usuario_d, ' +
    '  bloqueado=EXCLUDED.bloqueado, sync=EXCLUDED.sync, ' +
    '  sync_data=(now() at time zone ''America/Sao_Paulo'')';

var
  qUp: TFDQuery;
  fs: TFormatSettings;
  Ini: TIniFile;
  TotalRecords, CurrentRecord: Integer;
  grpInt, subgrpInt: Integer;
  s: string;

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

  procedure SetTimestampParam(const PName: string; F: TField);
  var sdt: string; dt: TDateTime;
  begin
    qUp.ParamByName(PName).DataType := ftDateTime;
    if F.IsNull then
      qUp.ParamByName(PName).Clear
    else if F.DataType in [ftDateTime, ftTimeStamp, ftDate] then
      qUp.ParamByName(PName).AsDateTime := F.AsDateTime
    else
    begin
      sdt := Trim(F.AsString);
      if (sdt = '') or (not TryStrToDateTime(sdt, dt, fs)) then
        qUp.ParamByName(PName).Clear
      else
        qUp.ParamByName(PName).AsDateTime := dt;
    end;
  end;

begin
  // Formatação para parse de datas/texto quando vier como string
  fs := TFormatSettings.Create;
  fs.DateSeparator   := '/';
  fs.ShortDateFormat := 'dd/MM/yyyy';
  fs.TimeSeparator   := ':';
  fs.ShortTimeFormat := 'hh:nn:ss';

  FDConnectionSupabase.Connected := True;

  // 1) Configurar conexão SICFAR (Firebird) via INI
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');
  try
    if not Assigned(Form_ConfigSqlServer) then
      Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionSICFAR, 'SICFAR');
  finally
    Ini.Free;
  end;

  // 2) Preparar consulta de origem (TBPRODUTOS)
  DataSource1.DataSet := qSICFAR;
  qSICFAR.Close;
  qSICFAR.Connection := FDConnectionSICFAR;
  qSICFAR.SQL.Clear;
  qSICFAR.SQL.Add('select');
  qSICFAR.SQL.Add('  p.produto_id, p.empresa_id, p.usuario_id, p.referencia, p.descricao,');
  qSICFAR.SQL.Add('  p.codbarra, p.ipi, p.icms, p.unidade, p.peso_bruto, p.peso_liquido,');
  qSICFAR.SQL.Add('  p.estoque_minimo, p.deletado, p.comissao, p.estoque_id, p.tipoproduto_id,');
  qSICFAR.SQL.Add('  p.grupo_id, p.subgrupo_id, p.ncm, p.obs, p.erp_codigo, p.qtde_caixa,');
  qSICFAR.SQL.Add('  p.preco_maximo, p.data_inc, p.usuario_i, p.data_alt, p.usuario_a,');
  qSICFAR.SQL.Add('  p.data_del, p.usuario_d, p.bloqueado, p.sync, p.sync_data');
  qSICFAR.SQL.Add('from tbprodutos p');
  qSICFAR.SQL.Add(WHERE_CLAUSE);

  // Exibir Form de atividade e contar registros
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
    'SELECT COUNT(*) FROM TBPRODUTOS' + WHERE_CLAUSE
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

        // Mapeamento Firebird (TBPRODUTOS) -> Supabase (TBPRODUTO)
        qUp.ParamByName('produto_id').AsInteger     := qSICFAR.FieldByName('PRODUTO_ID').AsInteger;
        qUp.ParamByName('empresa_id').AsInteger     := qSICFAR.FieldByName('EMPRESA_ID').AsInteger;
        qUp.ParamByName('usuario_id').AsInteger     := qSICFAR.FieldByName('USUARIO_ID').AsInteger;
        qUp.ParamByName('referencia').AsString      := qSICFAR.FieldByName('REFERENCIA').AsString;
        qUp.ParamByName('descricao').AsString       := qSICFAR.FieldByName('DESCRICAO').AsString;
        qUp.ParamByName('codbarra').AsString        := qSICFAR.FieldByName('CODBARRA').AsString;
        qUp.ParamByName('ipi').AsFloat              := qSICFAR.FieldByName('IPI').AsFloat;
        qUp.ParamByName('icms').AsFloat             := qSICFAR.FieldByName('ICMS').AsFloat;
        qUp.ParamByName('unidade').AsString         := qSICFAR.FieldByName('UNIDADE').AsString;
        qUp.ParamByName('peso_bruto').AsFloat       := qSICFAR.FieldByName('PESO_BRUTO').AsFloat;
        qUp.ParamByName('peso_liquido').AsFloat     := qSICFAR.FieldByName('PESO_LIQUIDO').AsFloat;
        qUp.ParamByName('estoque_minimo').AsFloat   := qSICFAR.FieldByName('ESTOQUE_MINIMO').AsFloat;
        qUp.ParamByName('deletado').AsString        := qSICFAR.FieldByName('DELETADO').AsString;
        qUp.ParamByName('comissao').AsFloat         := qSICFAR.FieldByName('COMISSAO').AsFloat;
        qUp.ParamByName('estoque_id').AsInteger     := qSICFAR.FieldByName('ESTOQUE_ID').AsInteger;
        qUp.ParamByName('tipoproduto_id').AsInteger := qSICFAR.FieldByName('TIPOPRODUTO_ID').AsInteger;

        // GRUPO_ID e SUBGRUPO_ID são VARCHAR no Firebird e INTEGER no Supabase
        s := Trim(qSICFAR.FieldByName('GRUPO_ID').AsString);
        if TryStrToInt(s, grpInt) then qUp.ParamByName('grupo_id').AsInteger := grpInt
        else qUp.ParamByName('grupo_id').Clear;

        s := Trim(qSICFAR.FieldByName('SUBGRUPO_ID').AsString);
        if TryStrToInt(s, subgrpInt) then qUp.ParamByName('subgrupo_id').AsInteger := subgrpInt
        else qUp.ParamByName('subgrupo_id').Clear;

        qUp.ParamByName('ncm').AsString             := qSICFAR.FieldByName('NCM').AsString;
        qUp.ParamByName('obs').AsString             := qSICFAR.FieldByName('OBS').AsString;
        qUp.ParamByName('erp_codigo').AsString      := qSICFAR.FieldByName('ERP_CODIGO').AsString;
        qUp.ParamByName('qtde_caixa').AsFloat       := qSICFAR.FieldByName('QTDE_CAIXA').AsFloat;
        qUp.ParamByName('preco_maximo').AsFloat     := qSICFAR.FieldByName('PRECO_MAXIMO').AsFloat;

        SetTimestampParam('data_inc', qSICFAR.FieldByName('DATA_INC'));
        qUp.ParamByName('usuario_i').AsInteger      := qSICFAR.FieldByName('USUARIO_I').AsInteger;
        SetTimestampParam('data_alt', qSICFAR.FieldByName('DATA_ALT'));
        qUp.ParamByName('usuario_a').AsInteger      := qSICFAR.FieldByName('USUARIO_A').AsInteger;
        SetTimestampParam('data_del', qSICFAR.FieldByName('DATA_DEL'));
        qUp.ParamByName('usuario_d').AsInteger      := qSICFAR.FieldByName('USUARIO_D').AsInteger;
        qUp.ParamByName('bloqueado').AsString       := qSICFAR.FieldByName('BLOQUEADO').AsString;
        qUp.ParamByName('sync').AsString            := qSICFAR.FieldByName('SYNC').AsString;

        qUp.ExecSQL;

        // Atualizações de UI e respiração de CPU a cada 10 registros
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
      ShowMessage('Importação de produtos concluída com sucesso.');
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

procedure TForm_Principal.Button1Click(Sender: TObject);
begin
  pImportaClienteSA1('000256');

  ShowMessage('OK');
end;

procedure TForm_Principal.btn_ClienteClick(Sender: TObject);
const
  // WHERE_CLAUSE pode ser ajustado conforme necessidade para filtrar registros específicos
  WHERE_CLAUSE =
    ' WHERE deletado = ''N'' ' +
    ' AND pessoa_id IN (' +
    '   SELECT l.pessoa_id FROM TBLICITACAO l ' +
    '   WHERE l.deletado = ''N'' AND l.pessoa_vr IN (''16531'',''11020'') ' +
    '   UNION ' +
    '   SELECT l.cliente_id FROM TBLICITACAO l ' +
    '   WHERE l.deletado = ''N'' AND l.pessoa_vr IN (''16531'',''11020'') ' +
    ')';

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
  DataSource1.DataSet := qSICFAR;
  qSICFAR.Close;
  qSICFAR.Connection := FDConnectionSICFAR;
  qSICFAR.SQL.Clear;
  qSICFAR.SQL.Add('select p.pessoa_id as cliente_id, p.empresa_id, p.nome_pupular, p.nome, p.endereco, ');
  qSICFAR.SQL.Add('       p.complemento, p.bairro, p.cidade_id, p.uf, p.cep, p.naturalidade, ');
  qSICFAR.SQL.Add('       p.nascimento, p.sexo, p.tipo, p.cpf_cnpj, p.rg_cgf, p.estcivil, p.obs, ');
  qSICFAR.SQL.Add('       p.pai, p.mae, p.limite_credito, p.conjuge, p.comissao, p.situacao, ');
  qSICFAR.SQL.Add('       p.deletado, p.email, p.site, p.cpf_conjuge, p.rg_conjuge, p.rg_orgao, ');
  qSICFAR.SQL.Add('       p.rg_uf, p.rg_orgao_conjuge, p.rg_uf_conjuge, p.profissao, p.natural_id, ');
  qSICFAR.SQL.Add('       p.nacionalidade, p.regime_casamento, p.renda_conjuge, p.nacionalidade_conjuge, ');
  qSICFAR.SQL.Add('       p.profissao_conjuge, p.numero, p.suframa, p.pais_id, p.foto, p.data_batismo, ');
  qSICFAR.SQL.Add('       p.cargo_id, p.funcao_id, p.grupo_id, p.subgrupo_id, p.nascimento_conjuge, ');
  qSICFAR.SQL.Add('       p.dia_vencimento, p.cnh, p.cnh_categoria, p.cnh_emissao, p.cnh_vencimento, ');
  qSICFAR.SQL.Add('       p.rg_emissao, p.data_inc, p.data_alt, p.usuario_a, p.data_del, p.usuario_d, ');
  qSICFAR.SQL.Add('       p.erp_codigo, p.ctps_n, p.ctps_s, p.ctps_uf, p.nit, p.ctps_emissao, ');
  qSICFAR.SQL.Add('       p.cnh_uf, p.data_admissao, p.titulo_numero, p.titulo_zona, p.titulo_secao, ');
  qSICFAR.SQL.Add('       p.banco_id, p.banco, p.agencia, p.conta, p.cor, p.grau_instrucao, ');
  qSICFAR.SQL.Add('       p.bloqueio_id, p.setor_id, p.sync, p.sync_data');
  qSICFAR.SQL.Add('from tbpessoas p');
  qSICFAR.SQL.Add(WHERE_CLAUSE);

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
        // Ajuste: cliente_id vem do alias CLIENTE_ID no SELECT
        qUp.ParamByName('cliente_id').AsInteger := qSICFAR.FieldByName('CLIENTE_ID').AsInteger;
        qUp.ParamByName('empresa_id').AsInteger := qSICFAR.FieldByName('EMPRESA_ID').AsInteger;
        qUp.ParamByName('nome_pupular').AsString := qSICFAR.FieldByName('NOME_PUPULAR').AsString;
        qUp.ParamByName('nome').AsString := qSICFAR.FieldByName('NOME').AsString;
        qUp.ParamByName('endereco').AsString := qSICFAR.FieldByName('ENDERECO').AsString;
        qUp.ParamByName('complemento').AsString := qSICFAR.FieldByName('COMPLEMENTO').AsString;
        qUp.ParamByName('bairro').AsString := qSICFAR.FieldByName('BAIRRO').AsString;
        qUp.ParamByName('cidade_id').AsInteger := qSICFAR.FieldByName('CIDADE_ID').AsInteger;

        // Campo CIDADE não está no SELECT; enviar nulo (definir DataType explícito)
        qUp.ParamByName('cidade').DataType := ftString;
        qUp.ParamByName('cidade').Clear;

        qUp.ParamByName('uf').AsString := qSICFAR.FieldByName('UF').AsString;
        qUp.ParamByName('cep').AsString := qSICFAR.FieldByName('CEP').AsString;

        // Campo PESSOA_VR não está no SELECT; enviar nulo (definir DataType explícito para evitar erro do FireDAC)
        qUp.ParamByName('vendedor_id').DataType := ftInteger;
        qUp.ParamByName('vendedor_id').Clear;

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

        // Campo USUARIO_ID não está no SELECT; enviar nulo (definir DataType explícito)
        qUp.ParamByName('usuario_i').DataType := ftInteger;
        qUp.ParamByName('usuario_i').Clear;

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

procedure TForm_Principal.btn_ExportaCotacaoClick(Sender: TObject);
begin
// Implementar
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  // Inicializa flags de estado da aplicação
  FBusy := False;
  FShutdownRequested := False;

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

procedure TForm_Principal.FormDestroy(Sender: TObject);
begin
  try
    if FDConnectionSupabase.InTransaction then
      FDConnectionSupabase.Rollback;
  except end;
  try
    if FDConnectionSupabase.Connected then
      FDConnectionSupabase.Connected := False;
  except end;
end;

procedure TForm_Principal.btn_IntegrarPesagemClick(Sender: TObject);
var
  Ini: TIniFile;
  qIns, qZC3: TFDQuery;
  vRecno: Int64;
begin
  // Conectar TOTVS (SQL Server) e SICFAR (Firebird)
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'BaseSIC.ini');
  try
    if not Assigned(Form_ConfigSqlServer) then
      Application.CreateForm(TForm_ConfigSqlServer, Form_ConfigSqlServer);
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionTOTVS, 'Protheus');
    Form_ConfigSqlServer.ConfigureAndConnectFDConnection(Ini, FDConnectionSICFAR, 'SICFAR');
  finally
    Ini.Free;
  end;

  // Consulta no SICFAR
  qSICFAR.Close;
  qSICFAR.Connection := FDConnectionSICFAR;
  qSICFAR.SQL.Clear;
  qSICFAR.SQL.Add('SELECT');
  qSICFAR.SQL.Add('  ''01''        ZC3_FILIAL,');
  qSICFAR.SQL.Add('  ''0''         ZC3_STATUS,');
  qSICFAR.SQL.Add('  ''CON''       ZC3_TIPO,');
  qSICFAR.SQL.Add('  p.balanca     ZC3_ROTINA,');
  qSICFAR.SQL.Add('  ''PESAGEM''   ZC3_PROCES,');
  qSICFAR.SQL.Add('  p.pesagem_id ZC3_YSIC,');
  qSICFAR.SQL.Add('  substring(p.insumo FROM 1 FOR 8) ZC3_PROD,');
  qSICFAR.SQL.Add('  CAST(');
  qSICFAR.SQL.Add('    EXTRACT(YEAR  FROM p.data_inc) * 10000 +');
  qSICFAR.SQL.Add('    EXTRACT(MONTH FROM p.data_inc) * 100   +');
  qSICFAR.SQL.Add('    EXTRACT(DAY   FROM p.data_inc)');
  qSICFAR.SQL.Add('  AS VARCHAR(8)) AS ZC3_DATA,');
  qSICFAR.SQL.Add('  ''11''       ZC3_LOCAL,');
  qSICFAR.SQL.Add('  p.lote_mp  ZC3_LOTE,');
  qSICFAR.SQL.Add('  p.endereco ZC3_END,');
  qSICFAR.SQL.Add('  CAST(p.quantidade_pesada / 1000 AS DECIMAL(18,7)) ZC3_QTD,');
  qSICFAR.SQL.Add('  p.op||''01002'' ZC3_OP,');
  qSICFAR.SQL.Add('  ''1020405'' ZC3_CC');

  qSICFAR.SQL.Add('FROM tbpesagem p');
  qSICFAR.SQL.Add('WHERE p.deletado = ''N'' ');

  qSICFAR.SQL.Add(' AND cast(p.data_inc as date) >= ''18.09.2025'' ');

  qSICFAR.SQL.Add(' AND p.balanca_id IN (5,6,14,15)');

  qSICFAR.SQL.Add(' AND p.status = ''Impressa Aprovada'' ');
  qSICFAR.SQL.Add(' AND ((p.sync IS NULL) OR (p.sync = ''N''))');

  if Trim(Edit_OP.Text) <> '' then
    qSICFAR.SQL.Add(' and p.op = ''' + Copy(Trim(Edit_OP.Text),1,6) + ''' ');

  qSICFAR.SQL.Add(' ORDER BY p.op, p.pesagem_id');

  qSICFAR.Open;

  if not qSICFAR.IsEmpty then
    begin
      qSICFAR.First;
      while not qSICFAR.Eof do
        begin
          // Verifica se o registro já existe na ZC3 (TOTVS)
          qZC3 := TFDQuery.Create(nil);
          try
            with qZC3 do
            begin
              Close;
              Connection := FDConnectionTOTVS;
              SQL.Clear;
              SQL.Add('SELECT COUNT(*) AS TOTAL FROM ZC3010');
              SQL.Add('WHERE D_E_L_E_T_ = '''' AND ZC3_YSIC = ' + QuotedStr(qSICFAR.FieldByName('ZC3_YSIC').AsString));
              Open;

              // Se o registro já existe, pula para o próximo
              if FieldByName('TOTAL').AsInteger > 0 then
              begin
                qSICFAR.Next;
                Continue; // Sai do loop atual e vai para o próximo registro
              end;
            end;
          finally
            qZC3.Free;
          end;

          // Validação na base TOTVS, caso não exista registro incluir no SQL de Insert
          with qTOTVS do
            begin
              Close;
              Connection := FDConnectionTOTVS;
              SQL.Text   := 'SELECT TOP 1 D3_OP ';
              SQL.Add(' FROM SD3010 SD3 ');
              SQL.Add(' WHERE SD3.D_E_L_E_T_ = '''' ');

              SQL.Add(' AND D3_OP      = :pOP');
              SQL.Add(' AND D3_COD     = :pProduto');
              SQL.Add(' AND D3_LOTECTL = :pLote');

              SQL.Add(' AND D3_ESTORNO = '''' ');
              SQL.Add(' AND D3_TM = ''510'' ');
//              SQL.Add(' AND D3_DOC LIKE ''S-%'' ');

              ParamByName('pOP').AsString      := qSICFAR.FieldByName('ZC3_OP').AsString;
              ParamByName('pProduto').AsString := qSICFAR.FieldByName('ZC3_PROD').AsString;
              ParamByName('pLote').AsString    := qSICFAR.FieldByName('ZC3_LOTE').AsString;

              Open;
            end;

            if qTOTVS.IsEmpty then // Se vazio, então linha não existe na TOTVS, pode inserir no SQL de insert
              begin
                // Inserção direta na ZC3010 baseada no modelo (um registro por vez)
                // Atenção ao R_E_C_N_O_: calcula o próximo recno atual da tabela
                try
                  vRecno := FDConnectionTOTVS.ExecSQLScalar('SELECT ISNULL(MAX(R_E_C_N_O_), 0) + 1 FROM ZC3010');
                except
                  on E: Exception do
                    raise Exception.Create('Falha ao obter próximo R_E_C_N_O_ da ZC3010: ' + E.Message);
                end;

                qIns := TFDQuery.Create(nil);
                try
                  qIns.Connection := FDConnectionTOTVS;
                  qIns.SQL.Clear;
                  qIns.SQL.Add('INSERT INTO ZC3010 (');
                  qIns.SQL.Add('  R_E_C_N_O_, ZC3_TIPO, ZC3_FILIAL, ZC3_STATUS,');
                  qIns.SQL.Add('  ZC3_PROD, ZC3_DATA, ZC3_LOCAL, ZC3_LOTE,');
                  qIns.SQL.Add('  ZC3_QTD, ZC3_END, ZC3_OP,');
                  qIns.SQL.Add('  ZC3_ROTINA, ZC3_PROCES, ZC3_YSIC, ZC3_CC');
                  qIns.SQL.Add(') VALUES (');
                  qIns.SQL.Add('  :recno, :tipo, :filial, :status,');
                  qIns.SQL.Add('  :prod, :data, :local, :lote,');
                  qIns.SQL.Add('  :qtd, :end, :op,');
                  qIns.SQL.Add('  :rotina, :proces, :ysic, :cc');
                  qIns.SQL.Add(')');

                  qIns.ParamByName('recno').AsLargeInt := vRecno;
                  qIns.ParamByName('tipo').AsString    := qSICFAR.FieldByName('ZC3_TIPO').AsString;
                  qIns.ParamByName('filial').AsString  := qSICFAR.FieldByName('ZC3_FILIAL').AsString;
                  qIns.ParamByName('status').AsString  := qSICFAR.FieldByName('ZC3_STATUS').AsString;

                  qIns.ParamByName('prod').AsString    := qSICFAR.FieldByName('ZC3_PROD').AsString;
                  qIns.ParamByName('data').AsString    := qSICFAR.FieldByName('ZC3_DATA').AsString;   // formato yyyymmdd
                  qIns.ParamByName('local').AsString   := qSICFAR.FieldByName('ZC3_LOCAL').AsString;
                  qIns.ParamByName('lote').AsString    := qSICFAR.FieldByName('ZC3_LOTE').AsString;

                  qIns.ParamByName('qtd').AsFloat      := qSICFAR.FieldByName('ZC3_QTD').AsFloat;     // DECIMAL(18,7)
                  qIns.ParamByName('end').AsString     := qSICFAR.FieldByName('ZC3_END').AsString;
                  qIns.ParamByName('op').AsString      := qSICFAR.FieldByName('ZC3_OP').AsString;

                  qIns.ParamByName('rotina').AsString  := qSICFAR.FieldByName('ZC3_ROTINA').AsString;
                  qIns.ParamByName('proces').AsString  := qSICFAR.FieldByName('ZC3_PROCES').AsString;
                  qIns.ParamByName('ysic').AsString    := qSICFAR.FieldByName('ZC3_YSIC').AsString;
                  qIns.ParamByName('cc').AsString      := qSICFAR.FieldByName('ZC3_CC').AsString;

                  qIns.ExecSQL;
                finally
                  qIns.Free;
                end;
              end;

          qSICFAR.Next;
        end;
    end;
end;

procedure TForm_Principal.pImportaClienteSA1(prCodCliente: string);
const
  // Sem UNIQUE: estratégia UPDATE-then-INSERT atômica via transação
  SQL_UPDATE =
    'UPDATE public.tbcliente t SET ' +
    '  empresa_id=:empresa_id, nome_pupular=:nome_pupular, nome=:nome, endereco=:endereco, complemento=:complemento, ' +
    '  bairro=:bairro, cidade_id=:cidade_id, uf=:uf, cep=:cep, vendedor_id=:vendedor_id, naturalidade=:naturalidade, ' +
    '  nascimento=:nascimento, sexo=:sexo, tipo=:tipo, cpf_cnpj=:cpf_cnpj, rg_cgf=:rg_cgf, estcivil=:estcivil, ' +
    '  obs=:obs, pai=:pai, mae=:mae, limite_credito=:limite_credito, conjuge=:conjuge, comissao=:comissao, situacao=:situacao, ' +
    '  deletado=:deletado, email=:email, site=:site, cpf_conjuge=:cpf_conjuge, rg_conjuge=:rg_conjuge, rg_orgao=:rg_orgao, rg_uf=:rg_uf, ' +
    '  rg_orgao_conjuge=:rg_orgao_conjuge, rg_uf_conjuge=:rg_uf_conjuge, profissao=:profissao, natural_id=:natural_id, ' +
    '  nacionalidade=:nacionalidade, regime_casamento=:regime_casamento, renda_conjuge=:renda_conjuge, nacionalidade_conjuge=:nacionalidade_conjuge, ' +
    '  profissao_conjuge=:profissao_conjuge, numero=:numero, suframa=:suframa, pais_id=:pais_id, data_batismo=:data_batismo, ' +
    '  cargo_id=:cargo_id, funcao_id=:funcao_id, grupo_id=:grupo_id, subgrupo_id=:subgrupo_id, nascimento_conjuge=:nascimento_conjuge, ' +
    '  dia_vencimento=:dia_vencimento, cnh=:cnh, cnh_categoria=:cnh_categoria, cnh_emissao=:cnh_emissao, cnh_vencimento=:cnh_vencimento, ' +
    '  rg_emissao=:rg_emissao, data_alt=:data_alt, usuario_a=:usuario_a, data_del=:data_del, usuario_d=:usuario_d, ' +
    '  ctps_n=:ctps_n, ctps_s=:ctps_s, ctps_uf=:ctps_uf, nit=:nit, ctps_emissao=:ctps_emissao, cnh_uf=:cnh_uf, data_admissao=:data_admissao, ' +
    '  titulo_numero=:titulo_numero, titulo_zona=:titulo_zona, titulo_secao=:titulo_secao, banco_id=:banco_id, banco=:banco, ' +
    '  agencia=:agencia, conta=:conta, cor=:cor, grau_instrucao=:grau_instrucao, bloqueio_id=:bloqueio_id, setor_id=:setor_id, ' +
    '  sync=:sync, sync_data=(now() at time zone ''America/Sao_Paulo''), cidade=:cidade ' +
    'WHERE (:erp_codigo IS NOT NULL AND :erp_codigo <> '''') AND t.erp_codigo = :erp_codigo';

  SQL_INSERT =
    'INSERT INTO public.tbcliente (' +
    '  empresa_id, nome_pupular, nome, endereco, complemento,' +
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
    '  :empresa_id, :nome_pupular, :nome, :endereco, :complemento,' +
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
    ')';
var
  qUp, qSelectTOTVS: TFDQuery;
  fs: TFormatSettings;
  vNascimento: TDateTime;
  s: string;

  function SA1Str(const AField: string): string;
  begin
    if qSelectTOTVS.FieldByName(AField).IsNull then Result := ''
    else Result := Trim(qSelectTOTVS.FieldByName(AField).AsString);
  end;

  function SA1Date(const AField: string; out ADate: TDateTime): Boolean;
  var txt: string; y, m, d: Word;
  begin
    Result := False; ADate := 0;
    if qSelectTOTVS.FieldByName(AField).IsNull then Exit;

    // Datas do Protheus geralmente vêm como 'yyyymmdd' (char)
    txt := Trim(qSelectTOTVS.FieldByName(AField).AsString);
    if txt = '' then Exit;  // evita tentar converter '        '

    if Length(txt) = 8 then
    try
      y := StrToInt(Copy(txt, 1, 4));
      m := StrToInt(Copy(txt, 5, 2));
      d := StrToInt(Copy(txt, 7, 2));
      ADate := EncodeDate(y, m, d);
      Exit(True);
    except
    end;

    // Caso o driver já entregue como date/datetime, tenta somente se o tipo do campo for realmente de data
    if qSelectTOTVS.FieldByName(AField).DataType in [ftDate, ftDateTime, ftTimeStamp] then
    try
      ADate := qSelectTOTVS.FieldByName(AField).AsDateTime;
      Exit(ADate > 0);
    except
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

  function TryToInt(const AValue: string; out AInt: Integer): Boolean;
  begin
    Result := False;
    AInt := 0;
    if Trim(AValue) = '' then Exit;
    try
      AInt := StrToInt(Trim(AValue));
      Result := True;
    except
      Result := False;
    end;
  end;

  procedure MapCommonParams(const Up: TFDQuery; const IsInsert: Boolean);
  begin
    // Texto
    Up.ParamByName('erp_codigo').AsString     := SA1Str('A1_COD');
    Up.ParamByName('nome').AsString           := SA1Str('A1_NOME');
    Up.ParamByName('nome_pupular').AsString   := SA1Str('A1_NREDUZ');
    Up.ParamByName('endereco').AsString       := SA1Str('A1_END');
    Up.ParamByName('bairro').AsString         := SA1Str('A1_BAIRRO');
    Up.ParamByName('cep').AsString            := SA1Str('A1_CEP');
    Up.ParamByName('cidade').AsString         := SA1Str('A1_MUN');
    Up.ParamByName('uf').AsString             := SA1Str('A1_EST');
    Up.ParamByName('cpf_cnpj').AsString       := SA1Str('A1_CGC');
    Up.ParamByName('rg_cgf').AsString         := SA1Str('A1_INSCR');
    Up.ParamByName('suframa').AsString        := SA1Str('A1_SUFRAMA');
    Up.ParamByName('obs').AsString            := SA1Str('A1_OBSERV');

    // tipo (PF/PJ) a partir de A1_PESSOA (F/J)
    s := UpperCase(SA1Str('A1_PESSOA'));
    if s = 'F' then Up.ParamByName('tipo').AsString := 'Pessoa Física'
    else if s = 'J' then Up.ParamByName('tipo').AsString := 'Pessoa Jurídica'
    else Up.ParamByName('tipo').AsString := s;

    // numérico
    Up.ParamByName('limite_credito').AsFloat := qSelectTOTVS.FieldByName('A1_LC').AsFloat;
    Up.ParamByName('comissao').AsFloat       := qSelectTOTVS.FieldByName('A1_COMIS').AsFloat;

    Up.ParamByName('cidade_id').DataType := ftInteger;
    Up.ParamByName('cidade_id').Clear;

    // nascimento
    Up.ParamByName('nascimento').DataType := ftDate;
    if SA1Date('A1_DTNASC', vNascimento) then
      Up.ParamByName('nascimento').AsDate := vNascimento
    else
      Up.ParamByName('nascimento').Clear;

    Up.ParamByName('complemento').DataType := ftString;
    Up.ParamByName('complemento').AsString := SA1Str('A1_COMPLEM');

    Up.ParamByName('email').DataType     := ftString;
    Up.ParamByName('email').AsString     := SA1Str('A1_EMAIL');

    Up.ParamByName('numero').DataType    := ftInteger;
    Up.ParamByName('numero').Clear;

    // usuario_i será definido apenas no INSERT

    Up.ParamByName('deletado').AsString  := 'N';
    Up.ParamByName('sync').AsString      := 'S';

    // campos opcionais sem mapeamento direto -> NULL
    if IsInsert then
      begin
        // auditoria/sync
        Up.ParamByName('data_inc').DataType   := ftDateTime;
        Up.ParamByName('data_inc').AsDateTime := Now;
        // auditoria de inclusão
        Up.ParamByName('usuario_i').DataType  := ftInteger;
        Up.ParamByName('usuario_i').AsInteger := 1;
      end
    else
      begin
        // Para UPDATE
        Up.ParamByName('usuario_a').DataType  := ftInteger;
        Up.ParamByName('usuario_a').AsInteger := 1;

        Up.ParamByName('data_alt').DataType   := ftDateTime;
        Up.ParamByName('data_alt').AsDateTime := Now;
      end;
  end;
begin
  // Sem interface visual: operação unitária (um cliente A1_COD)
  if Trim(prCodCliente) = '' then Exit;

  // Garantir Supabase conectado
  FDConnectionSupabase.Connected := True;

  // Buscar no SA1
  qSelectTOTVS := TFDQuery.Create(nil);
  qSelectTOTVS.Close;
  qSelectTOTVS.Connection := FDConnectionTOTVS;
  qSelectTOTVS.SQL.Clear;
  qSelectTOTVS.SQL.Add('SELECT');
  qSelectTOTVS.SQL.Add('  A1_COD, A1_NOME, A1_NREDUZ, A1_END, A1_BAIRRO, A1_CEP, A1_MUN, A1_EST,');
  qSelectTOTVS.SQL.Add('  A1_CGC, A1_INSCR, A1_DTNASC, A1_SUFRAMA, A1_VEND, A1_LC, A1_COMIS,');
  qSelectTOTVS.SQL.Add('  A1_PESSOA, A1_TIPO, A1_COD_MUN, A1_IBGE, A1_OBSERV, A1_COMPLEM, A1_EMAIL');
  qSelectTOTVS.SQL.Add('FROM SA1010 (NOLOCK)');
  qSelectTOTVS.SQL.Add('WHERE D_E_L_E_T_ = ''''');

  qSelectTOTVS.SQL.Add('  AND A1_COD = :pCod');

  qSelectTOTVS.ParamByName('pCod').AsString := prCodCliente;

  qSelectTOTVS.Open;

  if qSelectTOTVS.IsEmpty then
    Exit; // nada a importar

  qUp := TFDQuery.Create(nil);
  try
    qUp.Connection := FDConnectionSupabase;

    FDConnectionSupabase.StartTransaction;
    try
      // Primeiro tenta UPDATE
      qUp.SQL.Text := SQL_UPDATE;

      // Preenche parâmetros comuns para UPDATE
      MapCommonParams(qUp, False);

      // Chave de negócio (WHERE)
      qUp.ParamByName('erp_codigo').AsString := SA1Str('A1_COD');

      // Campos adicionais não mapeados na SA1 -> NULL/Defaults
      // Inteiros
      qUp.ParamByName('empresa_id').DataType := ftInteger;      qUp.ParamByName('empresa_id').Clear;
      qUp.ParamByName('vendedor_id').DataType := ftInteger;     qUp.ParamByName('vendedor_id').Clear;
      qUp.ParamByName('natural_id').DataType := ftInteger;      qUp.ParamByName('natural_id').Clear;
      qUp.ParamByName('pais_id').DataType := ftInteger;         qUp.ParamByName('pais_id').Clear;
      qUp.ParamByName('cargo_id').DataType := ftInteger;        qUp.ParamByName('cargo_id').Clear;
      qUp.ParamByName('funcao_id').DataType := ftInteger;       qUp.ParamByName('funcao_id').Clear;
      qUp.ParamByName('grupo_id').DataType := ftInteger;        qUp.ParamByName('grupo_id').Clear;
      qUp.ParamByName('subgrupo_id').DataType := ftInteger;     qUp.ParamByName('subgrupo_id').Clear;
      qUp.ParamByName('dia_vencimento').DataType := ftInteger;  qUp.ParamByName('dia_vencimento').Clear;
      qUp.ParamByName('usuario_a').DataType := ftInteger;       qUp.ParamByName('usuario_a').Clear;
      qUp.ParamByName('usuario_d').DataType := ftInteger;       qUp.ParamByName('usuario_d').Clear;
      qUp.ParamByName('banco_id').DataType := ftInteger;        qUp.ParamByName('banco_id').Clear;
      qUp.ParamByName('bloqueio_id').DataType := ftInteger;     qUp.ParamByName('bloqueio_id').Clear;
      qUp.ParamByName('setor_id').DataType := ftInteger;        qUp.ParamByName('setor_id').Clear;

      // Float
      qUp.ParamByName('renda_conjuge').DataType := ftFloat;     qUp.ParamByName('renda_conjuge').Clear;

      // String
      qUp.ParamByName('situacao').DataType := ftString;         qUp.ParamByName('situacao').Clear;

      qUp.ParamByName('naturalidade').DataType := ftString;     qUp.ParamByName('naturalidade').Clear;
      qUp.ParamByName('sexo').DataType := ftString;             qUp.ParamByName('sexo').Clear;
      qUp.ParamByName('estcivil').DataType := ftString;         qUp.ParamByName('estcivil').Clear;
      qUp.ParamByName('pai').DataType := ftString;              qUp.ParamByName('pai').Clear;
      qUp.ParamByName('mae').DataType := ftString;              qUp.ParamByName('mae').Clear;
      qUp.ParamByName('conjuge').DataType := ftString;          qUp.ParamByName('conjuge').Clear;
      qUp.ParamByName('site').DataType := ftString;             qUp.ParamByName('site').Clear;
      qUp.ParamByName('cpf_conjuge').DataType := ftString;      qUp.ParamByName('cpf_conjuge').Clear;
      qUp.ParamByName('rg_conjuge').DataType := ftString;       qUp.ParamByName('rg_conjuge').Clear;
      qUp.ParamByName('rg_orgao').DataType := ftString;         qUp.ParamByName('rg_orgao').Clear;
      qUp.ParamByName('rg_uf').DataType := ftString;            qUp.ParamByName('rg_uf').Clear;
      qUp.ParamByName('rg_orgao_conjuge').DataType := ftString; qUp.ParamByName('rg_orgao_conjuge').Clear;
      qUp.ParamByName('rg_uf_conjuge').DataType := ftString;    qUp.ParamByName('rg_uf_conjuge').Clear;
      qUp.ParamByName('profissao').DataType := ftString;        qUp.ParamByName('profissao').Clear;
      qUp.ParamByName('nacionalidade').DataType := ftString;    qUp.ParamByName('nacionalidade').Clear;
      qUp.ParamByName('regime_casamento').DataType := ftString; qUp.ParamByName('regime_casamento').Clear;
      qUp.ParamByName('nacionalidade_conjuge').DataType := ftString; qUp.ParamByName('nacionalidade_conjuge').Clear;
      qUp.ParamByName('profissao_conjuge').DataType := ftString; qUp.ParamByName('profissao_conjuge').Clear;
      qUp.ParamByName('cnh').DataType := ftString;              qUp.ParamByName('cnh').Clear;
      qUp.ParamByName('cnh_categoria').DataType := ftString;    qUp.ParamByName('cnh_categoria').Clear;
      qUp.ParamByName('ctps_n').DataType := ftString;           qUp.ParamByName('ctps_n').Clear;
      qUp.ParamByName('ctps_s').DataType := ftString;           qUp.ParamByName('ctps_s').Clear;
      qUp.ParamByName('ctps_uf').DataType := ftString;          qUp.ParamByName('ctps_uf').Clear;
      qUp.ParamByName('nit').DataType := ftString;              qUp.ParamByName('nit').Clear;
      qUp.ParamByName('cnh_uf').DataType := ftString;           qUp.ParamByName('cnh_uf').Clear;
      qUp.ParamByName('titulo_numero').DataType := ftString;    qUp.ParamByName('titulo_numero').Clear;
      qUp.ParamByName('titulo_zona').DataType := ftString;      qUp.ParamByName('titulo_zona').Clear;
      qUp.ParamByName('titulo_secao').DataType := ftString;     qUp.ParamByName('titulo_secao').Clear;
      qUp.ParamByName('banco').DataType := ftString;            qUp.ParamByName('banco').Clear;
      qUp.ParamByName('agencia').DataType := ftString;          qUp.ParamByName('agencia').Clear;
      qUp.ParamByName('conta').DataType := ftString;            qUp.ParamByName('conta').Clear;
      qUp.ParamByName('cor').DataType := ftString;              qUp.ParamByName('cor').Clear;
      qUp.ParamByName('grau_instrucao').DataType := ftString;   qUp.ParamByName('grau_instrucao').Clear;

      // Datas (DATE) e Timestamps (DATETIME)
      qUp.ParamByName('ctps_emissao').DataType := ftDate;       qUp.ParamByName('ctps_emissao').Clear;
      qUp.ParamByName('data_batismo').DataType := ftDate;       qUp.ParamByName('data_batismo').Clear;
      qUp.ParamByName('nascimento_conjuge').DataType := ftDate; qUp.ParamByName('nascimento_conjuge').Clear;
      qUp.ParamByName('cnh_emissao').DataType := ftDate;        qUp.ParamByName('cnh_emissao').Clear;
      qUp.ParamByName('cnh_vencimento').DataType := ftDate;     qUp.ParamByName('cnh_vencimento').Clear;
      qUp.ParamByName('rg_emissao').DataType := ftDate;         qUp.ParamByName('rg_emissao').Clear;
      qUp.ParamByName('data_alt').DataType := ftDateTime;       qUp.ParamByName('data_alt').Clear;
      qUp.ParamByName('data_del').DataType := ftDateTime;       qUp.ParamByName('data_del').Clear;
      qUp.ParamByName('data_admissao').DataType := ftDate;      qUp.ParamByName('data_admissao').Clear;

      // Auditoria para UPDATE
      qUp.ParamByName('usuario_a').AsInteger := 1;
      qUp.ParamByName('data_alt').AsDateTime := Now;

      // 1) Tenta UPDATE primeiro
      qUp.SQL.Text := SQL_UPDATE;
      qUp.ExecSQL;

      // 2) Se não atualizou nenhuma linha, faz INSERT
      if qUp.RowsAffected = 0 then
      begin
        // Prepara INSERT
        qUp.SQL.Text := SQL_INSERT;

        // Preenche parâmetros para INSERT (inclui auditoria de inclusão)
        MapCommonParams(qUp, True);

        // Chave de negócio (valor a inserir)
        qUp.ParamByName('erp_codigo').AsString := SA1Str('A1_COD');

        // Campos adicionais não mapeados na SA1 -> NULL/Defaults (mesmo conjunto do UPDATE)
        // Inteiros
        qUp.ParamByName('empresa_id').DataType := ftInteger;      qUp.ParamByName('empresa_id').Clear;
        qUp.ParamByName('vendedor_id').DataType := ftInteger;     qUp.ParamByName('vendedor_id').Clear;
        qUp.ParamByName('natural_id').DataType := ftInteger;      qUp.ParamByName('natural_id').Clear;
        qUp.ParamByName('pais_id').DataType := ftInteger;         qUp.ParamByName('pais_id').Clear;
        qUp.ParamByName('cargo_id').DataType := ftInteger;        qUp.ParamByName('cargo_id').Clear;
        qUp.ParamByName('funcao_id').DataType := ftInteger;       qUp.ParamByName('funcao_id').Clear;
        qUp.ParamByName('grupo_id').DataType := ftInteger;        qUp.ParamByName('grupo_id').Clear;
        qUp.ParamByName('subgrupo_id').DataType := ftInteger;     qUp.ParamByName('subgrupo_id').Clear;
        qUp.ParamByName('dia_vencimento').DataType := ftInteger;  qUp.ParamByName('dia_vencimento').Clear;
        qUp.ParamByName('usuario_a').DataType := ftInteger;       qUp.ParamByName('usuario_a').Clear;
        qUp.ParamByName('usuario_d').DataType := ftInteger;       qUp.ParamByName('usuario_d').Clear;
        qUp.ParamByName('banco_id').DataType := ftInteger;        qUp.ParamByName('banco_id').Clear;
        qUp.ParamByName('bloqueio_id').DataType := ftInteger;     qUp.ParamByName('bloqueio_id').Clear;
        qUp.ParamByName('setor_id').DataType := ftInteger;        qUp.ParamByName('setor_id').Clear;

        // Float
        qUp.ParamByName('renda_conjuge').DataType := ftFloat;     qUp.ParamByName('renda_conjuge').Clear;

        // String
        qUp.ParamByName('situacao').DataType := ftString;         qUp.ParamByName('situacao').Clear;
        qUp.ParamByName('naturalidade').DataType := ftString;     qUp.ParamByName('naturalidade').Clear;
        qUp.ParamByName('sexo').DataType := ftString;             qUp.ParamByName('sexo').Clear;
        qUp.ParamByName('estcivil').DataType := ftString;         qUp.ParamByName('estcivil').Clear;
        qUp.ParamByName('pai').DataType := ftString;              qUp.ParamByName('pai').Clear;
        qUp.ParamByName('mae').DataType := ftString;              qUp.ParamByName('mae').Clear;
        qUp.ParamByName('conjuge').DataType := ftString;          qUp.ParamByName('conjuge').Clear;
        qUp.ParamByName('site').DataType := ftString;             qUp.ParamByName('site').Clear;
        qUp.ParamByName('cpf_conjuge').DataType := ftString;      qUp.ParamByName('cpf_conjuge').Clear;
        qUp.ParamByName('rg_conjuge').DataType := ftString;       qUp.ParamByName('rg_conjuge').Clear;
        qUp.ParamByName('rg_orgao').DataType := ftString;         qUp.ParamByName('rg_orgao').Clear;
        qUp.ParamByName('rg_uf').DataType := ftString;            qUp.ParamByName('rg_uf').Clear;
        qUp.ParamByName('rg_orgao_conjuge').DataType := ftString; qUp.ParamByName('rg_orgao_conjuge').Clear;
        qUp.ParamByName('rg_uf_conjuge').DataType := ftString;    qUp.ParamByName('rg_uf_conjuge').Clear;
        qUp.ParamByName('profissao').DataType := ftString;        qUp.ParamByName('profissao').Clear;
        qUp.ParamByName('nacionalidade').DataType := ftString;    qUp.ParamByName('nacionalidade').Clear;
        qUp.ParamByName('regime_casamento').DataType := ftString; qUp.ParamByName('regime_casamento').Clear;
        qUp.ParamByName('nacionalidade_conjuge').DataType := ftString; qUp.ParamByName('nacionalidade_conjuge').Clear;
        qUp.ParamByName('profissao_conjuge').DataType := ftString; qUp.ParamByName('profissao_conjuge').Clear;
        qUp.ParamByName('cnh').DataType := ftString;              qUp.ParamByName('cnh').Clear;
        qUp.ParamByName('cnh_categoria').DataType := ftString;    qUp.ParamByName('cnh_categoria').Clear;
        qUp.ParamByName('ctps_n').DataType := ftString;           qUp.ParamByName('ctps_n').Clear;
        qUp.ParamByName('ctps_s').DataType := ftString;           qUp.ParamByName('ctps_s').Clear;
        qUp.ParamByName('ctps_uf').DataType := ftString;          qUp.ParamByName('ctps_uf').Clear;
        qUp.ParamByName('nit').DataType := ftString;              qUp.ParamByName('nit').Clear;
        qUp.ParamByName('cnh_uf').DataType := ftString;           qUp.ParamByName('cnh_uf').Clear;
        qUp.ParamByName('titulo_numero').DataType := ftString;    qUp.ParamByName('titulo_numero').Clear;
        qUp.ParamByName('titulo_zona').DataType := ftString;      qUp.ParamByName('titulo_zona').Clear;
        qUp.ParamByName('titulo_secao').DataType := ftString;     qUp.ParamByName('titulo_secao').Clear;
        qUp.ParamByName('banco').DataType := ftString;            qUp.ParamByName('banco').Clear;
        qUp.ParamByName('agencia').DataType := ftString;          qUp.ParamByName('agencia').Clear;
        qUp.ParamByName('conta').DataType := ftString;            qUp.ParamByName('conta').Clear;
        qUp.ParamByName('cor').DataType := ftString;              qUp.ParamByName('cor').Clear;
        qUp.ParamByName('grau_instrucao').DataType := ftString;   qUp.ParamByName('grau_instrucao').Clear;

        // Datas (DATE) e Timestamps (DATETIME)
        qUp.ParamByName('ctps_emissao').DataType := ftDate;       qUp.ParamByName('ctps_emissao').Clear;
        qUp.ParamByName('data_batismo').DataType := ftDate;       qUp.ParamByName('data_batismo').Clear;
        qUp.ParamByName('nascimento_conjuge').DataType := ftDate; qUp.ParamByName('nascimento_conjuge').Clear;
        qUp.ParamByName('cnh_emissao').DataType := ftDate;        qUp.ParamByName('cnh_emissao').Clear;
        qUp.ParamByName('cnh_vencimento').DataType := ftDate;     qUp.ParamByName('cnh_vencimento').Clear;
        qUp.ParamByName('rg_emissao').DataType := ftDate;         qUp.ParamByName('rg_emissao').Clear;
        qUp.ParamByName('data_alt').DataType := ftDateTime;       qUp.ParamByName('data_alt').Clear;
        qUp.ParamByName('data_del').DataType := ftDateTime;       qUp.ParamByName('data_del').Clear;
        qUp.ParamByName('data_admissao').DataType := ftDate;      qUp.ParamByName('data_admissao').Clear;

        // Garantir que data_alt/usuario_a fiquem NULL no INSERT
        qUp.ParamByName('usuario_a').Clear;
        qUp.ParamByName('data_alt').Clear;

        qUp.ExecSQL;
      end;

      FDConnectionSupabase.Commit;
    except
      on E: Exception do
      begin
        FDConnectionSupabase.Rollback;
        raise;
      end;
    end;
  finally
    qUp.Free;
    qSelectTOTVS.Free;
  end;
end;

end.