unit Biblioteca;

interface

Uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ExtCtrls, ComCtrls, StdCtrls, IBX.IBQuery, IniFiles, IBX.IBDatabase, DB,
   IBX.IBCustomDataSet, IBX.IBTable, Menus, Registry, StrUtils,
   ComObj, Winapi.ActiveX, Office2000, Word2000, Excel2000, System.IOUtils,

   // function Finalizar Processos
   TLHelp32, PsAPI, Winapi.WinSock;

   function  CPF(num: string): boolean;
   function  CNPJ(num:string): boolean;
   procedure GravaIni (Caminho, Caminho2, Usuario, Usuario2, Senha, Senha2, CharacterSet, Auto,
                   Arquivo : String; Dialeto : Integer; Maquina: String);
   procedure LeIni (var Caminho, Caminho2, Usuario, Usuario2, Senha, Senha2, CharacterSet, Auto : String;
                   Arquivo : String; var Dialeto : Integer; Maquina: String);
   procedure CapturaError(Sender : TObject; E : Exception);
   procedure AbreForm(aClasseForm: TComponentClass; aForm: TForm);
   function  SoNumeros(pStr:String): String;
   procedure Incrementa(TableName: String; PrimaryKey: TField; Recebe: TField; Connection: TIBDatabase);
   procedure Get_Build_Info(var v1, v2, v3, v4 : Word);
   function  Get_Versao : String;
   function  ExtrairNome(const Filename: String): String;
   procedure LimpaEdit(Form: TForm);
   procedure GravaRegEdit;
   function  SomaHoras(valor1, valor2, operacao: string): string;
   function  FinalizarProcesso(sFile: String): Boolean;
   procedure GravaRegistro(Raiz: HKEY; Chave, Valor, Endereco: string);
   procedure ApagaRegistro(Raiz: HKEY; Chave, Valor: string);
   function  Montante(Capital, Taxa, Tempo: Double): Double;
   function  PreencherZero( const Conteudo : Integer; Const Preencher : String; const TamString : Integer ): String;
   function  LerRegString(const Root: HKey; const key, campo:string): string;
   function  GetNomeComputador : String;
   function  RemoveZeros(S: string): string;
   function  ZeroEsquerda(const I: integer; const Casas: byte): string;
   procedure EntreDatas(DataFinal, DataInicial: TDate; var Anos, Meses, Dias: Integer);
   function  valorPorExtenso(vlr: real): string;
   function  IncluirPonto(ATexto: string): string;
   function  PadR(ATexto: string; ATamanho: integer): string;
   function  LimparString(ATExto, ACaracteres: string): string;
   function  PadL(ATexto: string; ATamanho: Integer): string;
   function  TrocaCaracterEspecial(aTexto : string; aLimExt : boolean) : string;
   function  UltimoDiaDoMes(MesAno: string): string;
   function  ExecAndWait(const FileName: string; const CmdShow: Integer): Longword;
   function  GetIPAddress: String;
   function  KillTask(ExeFileName: string): Integer;
   function  RemoveZerosEsquerdaSIC(ANumStr: String): String;
   function  fValidaTelefone(prTelefone: string): Boolean;
   procedure LimpaMemoria;
   function  CarteiraToTipoOperacaoBNB(const Carteira: string): String;
   function  fCPFRepetido(prQuery: TIBQuery; prCPF, prID, prTipo: string): Boolean;
   function  VerificaData(dataNasc: Tdate): integer;
   function  fEmpty(xValue: Variant): Boolean;
   function  StrTran(const Texto, Esta, PorEsta: string): string;
   function  fIncrementaLetra(prVersao, prParametro: string): string;
   function  AnoBiSexto(Ano : Integer) : Boolean;
   function  DiasPorMes(Ano, Mes : Integer): Integer;
   procedure pArredondaComponente(Control: TWinControl);
   procedure pArredondaTopoComponente(Control: TWinControl);
   procedure ExcelOutStr(OutF: Variant; SLabel, SValue: String);
   function  ForceDeleteFile(const FileName: string): Boolean;
   function  ExportWordStreamToPDF(WordStream: TMemoryStream; prExtensao: string): TMemoryStream;
   function  fRetornaDataServidorIBX(prDatabase: TIBDatabase; prTransaction: TIBTransaction): TDateTime;

   // GED
   function  LoadStreamToMSWord(prDocumentoID, prExtensao: string; const prStream: TStream; prDocumento: TBlobField): string;
   procedure pDocumentoWordRegistro(prData: TDatetime; prOrigem, prUsuario, prOP, prLote, prTeorSan, prDocumento, prCodigo, prRodape: string);
   function  pVisualizarExcel(prDatabase: TIBDatabase; prTransaction: TIBTransaction; prDocumentoID, prOrigem, prArquivoPDF, prUsuario, prTipo, prCodigo: string): TMemoryStream;
   procedure pRodapePOPWord(prData: TDatetime; prDocumentoID, prOrigem, prUsuario, prTipo, prCodigo, prOP, prLote, prDocumento, prTeorSan: string);
   procedure pMardaDaguaWord(prOrigem: string);
   function  fConverteWordStreamPDF(prOrigem: string): TMemoryStream;
   function  fConverteExcelStreamPDF(prOrigem: string): TMemoryStream;
   function  IsVideoFile(const AFileName: string): Boolean;
   function  fFileNameStream(prExtensao: string): string;
   function  LoadFileToMemoryStream(const FilePath: string): TMemoryStream;
   procedure pRegistroExcel(prExcel: Variant; prConfig : TIBQuery; prData: TDateTime; prDocumentoID, prLote, prErpProduto, prOP, prDocumento, prTeorSan, prCodigo, prUsuario, prTipo: string);
   procedure DeleteAllFilesAndSubfolders(const Directory: string);
   function  ExtrairPrimeiroNumero(const S: string): string;
   procedure pImprimirDossie(prDocumentoID, prImpresso: string; prArquivo: TBlobField);
   function  fSaveBlobToTempFile(prArquivo: TBlobField; prExtension: string): string;
   function  fConverteWordPDF(prOrigem: string): string;
   function  CopyBigStream( const source: TStream ): TStream;
   function  MyCrypt(Action, Src: String): String;

implementation

//Usa-se C para Criptografar e D para Descriptografar
function MyCrypt(Action, Src: String): String;
Label Fim;
var KeyLen : Integer;
  KeyPos : Integer;
  OffSet : Integer;
  Dest, Key : String;
  SrcPos : Integer;
  SrcAsc : Integer;
  TmpSrcAsc : Integer;
  Range : Integer;
begin
  if (Src = '') Then
  begin
    Result:= '';
    Goto Fim;
  end;

  Key := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSLC3SOFT';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x',[OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x',[SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$'+ copy(Src,1,2));
    SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
    if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
    TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    Dest := Dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
  until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;

function CopyBigStream( const source: TStream ): TStream;
 //resolve o problema de memory stream com mais de 40kb
var
  BytesRead: Integer;
  Buffer: PByte;
const
  MaxBufSize = $F000;
begin
  { ** Criando a inst�ncia do objeto TMemoryStream para retorno do m�todo ** }
  result := TMemoryStream.Create;

  { ** Reposicionando o stream para o seu in�cio ** }
  source.Seek( 0, TSeekOrigin.soBeginning );
  source.Position := 0;
  GetMem( Buffer, MaxBufSize );

  { ** Realizando a leitura do stream original, buffer a buffer ** }
  repeat
   BytesRead := Source.Read( Buffer^, MaxBufSize );
   if BytesRead > 0 then
    result.WriteBuffer( Buffer^, BytesRead );
  until MaxBufSize > BytesRead;

  { ** Reposicionando o stream de retorno para o seu in�cio ** }
  result.Seek( 0, TSeekOrigin.soBeginning );
end;

function fConverteExcelPDF(prOrigem: string): string;
begin
//var
//  vlExcel : Variant;
//
//  TempPDFFileName   : string;
//  TempPDFFileStream : TFileStream;
//begin
//  // Criar um nome de arquivo tempor�rio com a extens�o .pdf
//  TempPDFFileName := TPath.ChangeExtension(prOrigem, '.pdf');
//
//  vlExcel               := CreateOleObject('Excel.Application');
//  vlExcel.Visible       := False;
//  vlExcel.DisplayAlerts := False;
//  vlExcel.workbooks.open(prOrigem);
//
//  vlExcel.Workbooks[1].ExportAsFixedFormat(0,TempPDFFileName,0,True,False,EmptyParam,EmptyParam,False,EmptyParam);
//
//  vlExcel.ActiveWorkbook.Close(False, EmptyParam, EmptyParam);
//  vlExcel.Quit;
//  vlExcel := Unassigned;// liberar da mem�ria
//
//  // Carregar o arquivo tempor�rio PDF no stream de resultado
//  Result := TMemoryStream.Create;
//  TempPDFFileStream := TFileStream.Create(TempPDFFileName, fmOpenRead);
//  try
//    Result.CopyFrom(TempPDFFileStream, TempPDFFileStream.Size);
//  finally
//    TempPDFFileStream.Free;
//  end;
//
//  Result.Position := 0;
//
//  // Deletar o arquivo Tempor�rio
//  TFile.Delete(TempPDFFileName);
//
//  vlExcel := Unassigned;// Liberar da mem�ria
end;

function fConverteWordPDF(prOrigem: string): string;
var
  WinWordPDF, DocPDF: Variant;
  TempPDFFileName: string;
begin
  // Criar um nome de arquivo tempor�rio com a extens�o .pdf
  TempPDFFileName := TPath.ChangeExtension(prOrigem, '.pdf');

  WinWordPDF         := CreateOleObject('Word.Application');
  WinWordPDF.Visible := False;
  DocPDF             := WinWordPDF.Documents.Open(prOrigem);

  DocPDF.ExportAsFixedFormat(TempPDFFileName, 17);
  WinWordPDF.ActiveDocument.Close(False, EmptyParam, EmptyParam);
  WinWordPDF.Quit;

  WinWordPDF := Unassigned;// liberar da mem�ria
  DocPDF     := Unassigned;// liberar da mem�ria

  Result := TempPDFFileName;
end;

function fSaveBlobToTempFile(prArquivo: TBlobField; prExtension: string): string;
var
  TempFileName, TempFilePath: string;
begin
  // Gerando um nome de arquivo tempor�rio �nico
  TempFileName := TPath.GetGUIDFileName + prExtension;
  TempFilePath := TPath.Combine(TPath.GetTempPath, TempFileName);

  // Salvando o conte�do do campo BLOB diretamente em um arquivo
  prArquivo.SaveToFile(TempFilePath);

  // Retornando o caminho do arquivo salvo
  Result := TempFilePath;
end;

procedure pImprimirDossie(prDocumentoID, prImpresso: string; prArquivo: TBlobField);
var
  vlExcel : Variant;
  vlqtd, vlQtdSemLote : integer;
  vlLimpo             : Boolean;

  StreamArquivo : TMemoryStream;
  FileNamePDF   : string;
  FileStream    : TFileStream;

  vlArquivo : string;
begin
//  try
//    vlQtdSemLote := 0;

//    Form_PDFViewer.cdsLote.Close;
//    Form_PDFViewer.cdsLote.Open;
//    Form_PDFViewer.cdsLote.EmptyDataSet;
//
//    cdsInsumo.First;
//    while not cdsInsumo.Eof do
//      begin
//        if Trim(cdsInsumoLOTE.AsString) = '' then
//          begin
//            vlQtdSemLote := vlQtdSemLote + 1;
//          end
//        else
//          begin
//            Form_PDFViewer.cdsLote.Insert;
//
//            Form_PDFViewer.cdsLoteERP_PRODUTO.AsString := cdsInsumoERP_CODIGO.AsString;
//            Form_PDFViewer.cdsLotePRODUTO.AsString     := cdsInsumoPRODUTO.AsString;
//            Form_PDFViewer.cdsLoteLOTE.AsString        := cdsInsumoLOTE.AsString;
//
//            Form_PDFViewer.cdsLote.Post;
//          end;
//
//        // criar ClientDataSet no PDF Viewer e alimentar com os lotes de insumos e imprimir de la
//
//        cdsInsumo.Next;
//      end;
//
//    if vlQtdSemLote > 0 then
//      begin
//        if Application.MessageBox('Algum lote n�o foi inserido. Deseja continuar?', 'Aten��o', MB_YESNO+MB_ICONQUESTION) = mrNo then
//          begin
//            Form_Activity.Close;
//            Abort;
//          end;
//      end;

//    StreamArquivo := TMemoryStream.Create;
//    prArquivo.SaveToStream(StreamArquivo);
//    StreamArquivo.Position := 0;
//
//    vlArquivo := LoadStreamToMSWord(prDocumentoID,fretor vDocumentoExtensao,StreamArquivo,prArquivo);
//
//    vDocumentoStreamOriginal := StreamArquivo;
//    vDocumentoStreamOriginal.Position := 0;
//
//    vlExcel := CreateOleObject('Excel.Application');
//    vlExcel.workbooks.open(dm1.vlArquivo);
//
//    if Trim(Edit_PesqLote.Text) = '' then
//      vlLimpo := True
//    else
//      vlLimpo := False;
//
//    ExcelOutStr(vlexcel,'#LOTE#',        Trim(Edit_PesqLote.Text));//IfThen(vlLimpo,'',Trim(Edit_PesqLote.Text)));
//    ExcelOutStr(vlexcel,'#ERP_PRODUTO#', Trim(qOPC2_PRODUTO.AsString));
//    ExcelOutStr(vlexcel,'#OP#',          Trim(qOPC2_NUM.AsString));
//    ExcelOutStr(vlexcel,'#DOCUMENTO#',   Trim(Edit_Documento.Text));
//    ExcelOutStr(vlexcel,'#CODIGO#',      Trim(Edit_Documento.Text));
//
//    if Trim(Edit_Sanitizante.Text) <> '' then
//      ExcelOutStr(vlexcel,'#TEOR_SAN#', Trim(Edit_Sanitizante.Text))
//    else
//      ExcelOutStr(vlexcel,'#TEOR_SAN#', '0');
//
//    if prImpresso = 'S' then
//      ExcelOutStr(vlexcel,'#IMPRESSO#', 'Reimpresso por: ' + Usuario + '; Autorizado por: ' + UsuarioMaster + ' em ' + FormatDateTime('DD/MM/YYYY HH:MM', dm1.vDataHoraServidor))
//    else
//      ExcelOutStr(vlexcel,'#IMPRESSO#', 'Impresso por ' + Usuario + ' em ' + FormatDateTime('DD/MM/YYYY HH:MM', dm1.vDataHoraServidor));
//
//    vOP := Trim(qOPC2_NUM.AsString);
//    cdsInsumo.First;
//
//    if cdsInsumo.IsEmpty then
//      begin
//        while fVarIsNothing(vlExcel.cells.find(what := '_LOTE')) = False do
//          begin
//            vlExcel.cells.find(what := '_LOTE').value := '';
//          end;
//
//        while fVarIsNothing(vlExcel.cells.find(what := '_TEOR')) = False do
//          begin
//            vlExcel.cells.find(what := '_TEOR').value := '';
//          end;
//      end
//    else
//      begin
//        while not cdsInsumo.Eof do
//          begin
//            if Trim(cdsInsumoLOTE.AsString) = '' then
//              vlLimpo := True
//            else
//              vlLimpo := False;
//
//            ExcelOutStr(vlexcel,cdsInsumoERP_CODIGO.AsString + '_LOTE',IfThen(vlLimpo,'-',Trim(cdsInsumoLOTE.AsString)));//cdsInsumoLOTE.AsString);
//
//            if Trim(cdsInsumoTEOR.AsString) = '' then
//              vlLimpo := True
//            else
//              vlLimpo := False;
//
//            ExcelOutStr(vlexcel,cdsInsumoERP_CODIGO.AsString + '_TEOR',IfThen(vlLimpo,'-',Trim(cdsInsumoTEOR.AsString)));//cdsInsumoTEOR.AsString);
//
//            cdsInsumo.Next;
//          end;
//      end;
//
//    with qConfig do
//      begin
//        Close;
//        SQL.Text := 'select';
//        SQL.Add(' pagina, coluna_i, linha_i,');
//        SQL.Add(' coluna_f, linha_f');
//        SQL.Add(' from tbdoc_excel');
//        SQL.Add(' where deletado = ''N'' ');
//        SQL.Add(' and doc_id = ''' + vDocumentoID + ''' ');
//        SQL.Add(' order by pagina');
//        Open;
//      end;
//
//      qConfig.First;
//      while not qConfig.Eof do
//      begin
//        if (qConfigPAGINA.AsInteger > 0) and (qConfigPAGINA.AsInteger <= vlExcel.Workbooks[1].Sheets.Count) then
//        begin
//          vlExcel.Workbooks[1].Sheets[qConfigPAGINA.AsInteger].PageSetup.PrintArea  := '$' + qConfigCOLUNA_I.AsString +'$' + qConfigLINHA_I.AsString +
//                                                                                       ':$'+ qConfigCOLUNA_F.AsString +'$' + qConfigLINHA_F.AsString;
//        end
//        else
//        begin
//          ShowMessage('�ndice de folha inv�lido: ' + IntToStr(qConfigPAGINA.AsInteger));
//          Abort
//        end;
//        qConfig.Next;
//      end;
//
//
//    FileNamePDF := TPath.ChangeExtension(dm1.vlArquivo,'.pdf');
//    vlExcel.Workbooks[1].ExportAsFixedFormat(0,FileNamePDF,0,True,False,EmptyParam,EmptyParam,False,EmptyParam);
//
//    vlqtd := 0;
//
//    vlExcel.Visible := False;
//
//    vlExcel.ActiveWorkbook.Close(False, EmptyParam, EmptyParam);
//    vlExcel.Quit;
//    vlExcel := Unassigned;// liberar da mem�ria
//
//    if not Assigned(Form_PDFViewer) then
//      Application.CreateForm(TForm_PDFViewer, Form_PDFViewer);
//
//    vDocumentoStream := LoadFileToMemoryStream(FileNamePDF);
//    vDocumentoStream.Position := 0;
//
//    Form_PDFViewer.dxPDFViewer1.LoadFromStream(vDocumentoStream);
//
//    if FileExists(dm1.vlArquivo) then
//      TFile.Delete(dm1.vlArquivo);
//
//    if FileExists(FileNamePDF) then
//      TFile.Delete(FileNamePDF);
//
//    dm1.pRegistraAcesso('DOC001','Processo','N',Usuario + ', imprimiu a OP ' + Edit_OP.Text + ' Lan�amento ' + vDocumentoID,vDocumentoID);
//
//    if Form_Activity.Showing then
//      Form_Activity.Close;
//
//    Form_PDFViewer.Show;
//    Form_PDFViewer.BringToFront;
//  except on E:Exception do
//    begin
//      if FileExists(FileNamePDF) then
//        TFile.Delete(FileNamePDF);
//
//      if FileExists(dm1.vlArquivo) then
//        TFile.Delete(dm1.vlArquivo);
//
//      // Evita mensagem de Erro do Abort
//      if not (E is EAbort) then
//        ShowMessage('Erro ao tentar enviar: ' + E.Message);
//    end;
//  end;
end;

function ExtrairPrimeiroNumero(const S: string): string;
var
  Inicio, Fim: Integer;
begin
  Inicio := Pos('''', S);
  Fim := PosEx('''', S, Inicio + 1);
  Result := Copy(S, Inicio + 1, Fim - Inicio - 1);
end;

function fConverteWordStreamPDF(prOrigem: string): TMemoryStream;
var
  WinWordPDF, DocPDF: Variant;
  TempPDFFileName: string;
  TempPDFFileStream: TFileStream;
begin
  // Criar um nome de arquivo tempor�rio com a extens�o .pdf
  TempPDFFileName := TPath.ChangeExtension(prOrigem, '.pdf');

  WinWordPDF         := CreateOleObject('Word.Application');
  WinWordPDF.Visible := False;
  DocPDF             := WinWordPDF.Documents.Open(prOrigem);

  DocPDF.ExportAsFixedFormat(TempPDFFileName, 17);
  WinWordPDF.ActiveDocument.Close(False, EmptyParam, EmptyParam);
  WinWordPDF.Quit;

  // Carregar o arquivo tempor�rio PDF no stream de resultado
  Result := TMemoryStream.Create;
  TempPDFFileStream := TFileStream.Create(TempPDFFileName, fmOpenRead);
  try
    Result.CopyFrom(TempPDFFileStream, TempPDFFileStream.Size);
  finally
    TempPDFFileStream.Free;
  end;

  Result.Position := 0;

  // Deletar o arquivo tempor�rio
  TFile.Delete(TempPDFFileName);

  WinWordPDF := Unassigned;// liberar da mem�ria
  DocPDF     := Unassigned;// liberar da mem�ria
end;

function  fConverteExcelStreamPDF(prOrigem: string): TMemoryStream;
var
  vlExcel : Variant;

  TempPDFFileName   : string;
  TempPDFFileStream : TFileStream;
begin
  // Criar um nome de arquivo tempor�rio com a extens�o .pdf
  TempPDFFileName := TPath.ChangeExtension(prOrigem, '.pdf');

  vlExcel               := CreateOleObject('Excel.Application');
  vlExcel.Visible       := False;
  vlExcel.DisplayAlerts := False;
  vlExcel.workbooks.open(prOrigem);

  vlExcel.Workbooks[1].ExportAsFixedFormat(0,TempPDFFileName,0,True,False,EmptyParam,EmptyParam,False,EmptyParam);

  vlExcel.ActiveWorkbook.Close(False, EmptyParam, EmptyParam);
  vlExcel.Quit;
  vlExcel := Unassigned;// liberar da mem�ria

  // Carregar o arquivo tempor�rio PDF no stream de resultado
  Result := TMemoryStream.Create;
  TempPDFFileStream := TFileStream.Create(TempPDFFileName, fmOpenRead);
  try
    Result.CopyFrom(TempPDFFileStream, TempPDFFileStream.Size);
  finally
    TempPDFFileStream.Free;
  end;

  Result.Position := 0;

  // Deletar o arquivo Tempor�rio
  TFile.Delete(TempPDFFileName);

  vlExcel := Unassigned;// Liberar da mem�ria
end;

procedure DeleteAllFilesAndSubfolders(const Directory: string);
var
  Subfolder: string;
  Directories, Files: TStringList;
  SearchRec: TSearchRec;
  i: Integer;
begin
  Directories := TStringList.Create;
  Files := TStringList.Create;
  try
    if FindFirst(IncludeTrailingPathDelimiter(Directory) + '*', faDirectory, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory = faDirectory) and (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
          Directories.Add(IncludeTrailingPathDelimiter(Directory) + SearchRec.Name);
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    if FindFirst(IncludeTrailingPathDelimiter(Directory) + '*.*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory <> faDirectory) then
          Files.Add(IncludeTrailingPathDelimiter(Directory) + SearchRec.Name);
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    for i := 0 to Files.Count - 1 do
    begin
      TFile.Delete(Files[i]);
    end;

    for i := 0 to Directories.Count - 1 do
    begin
      Subfolder := Directories[i];
      DeleteAllFilesAndSubfolders(Subfolder);
      TDirectory.Delete(Subfolder, False);
    end;
  finally
    Directories.Free;
    Files.Free;
  end;
end;

function LoadFileToMemoryStream(const FilePath: string): TMemoryStream;
var
  FileStream: TFileStream;
begin
  Result := TMemoryStream.Create;
  try
    FileStream := TFileStream.Create(FilePath, fmOpenRead);
    try
      Result.CopyFrom(FileStream, FileStream.Size);
    finally
      FileStream.Free;
    end;
  except
    Result.Free;
    raise;
  end;

  Result.Position := 0;
end;

function IsVideoFile(const AFileName: string): Boolean;
const
  VideoExtensions: array[0..10] of string = ('.mp4', '.avi', '.wmv', '.mov', '.flv', '.mkv', '.webm', '.3gp', '.mpg', '.mpeg', '.m4v');
var
  i: Integer;
  Ext: string;
begin
  Ext := LowerCase(ExtractFileExt(AFileName));
  Result := False;

  for i := Low(VideoExtensions) to High(VideoExtensions) do
  begin
    if AnsiLowerCase(Ext) = AnsiLowerCase(VideoExtensions[i]) then
    begin
      Exit(True);
    end;
  end;
end;



function fFileNameStream(prExtensao: string): string;
var
  TempFileName : string;
begin
  TempFileName := TPath.GetTempFileName + prExtensao;

  Result := TempFileName;
end;

function LoadStreamToMSWord(prDocumentoID, prExtensao: string; const prStream: TStream; prDocumento: TBlobField): string;
var
  TempFileName   : string;
  TempFileStream : TFileStream;
begin
  if prStream.Size = 0 then
    begin
      prDocumento.SaveToStream(prStream);
      prStream.Position := 0;
    end;

  TempFileName := TPath.GetTempFileName + prExtensao;

  TempFileStream := TFileStream.Create(TempFileName, fmCreate);
  try
    TempFileStream.CopyFrom(prStream, prStream.Size);
  finally
    TempFileStream.Free;
  end;

  Result := TempFileName;
end;

function ForceDeleteFile(const FileName: string): Boolean;
var
  dwAttrs: DWORD;
  hFile: THandle;
begin
  Result := False;
  if FileExists(FileName) then
  begin
    dwAttrs := GetFileAttributes(PChar(FileName));
    if dwAttrs <> INVALID_FILE_ATTRIBUTES then
    begin
      // Remova o atributo somente leitura, se aplic�vel
      if (dwAttrs and FILE_ATTRIBUTE_READONLY) <> 0 then
        SetFileAttributes(PChar(FileName), dwAttrs and (not FILE_ATTRIBUTE_READONLY));

      // Tente excluir o arquivo
      Result := SysUtils.DeleteFile(FileName);

      // Se falhar, tente o m�todo for�ado
      if not Result then
      begin
        // Usar a fun��o CreateFile com a flag FILE_FLAG_DELETE_ON_CLOSE para tentar for�ar a exclus�o
        hFile := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0, nil,
                            OPEN_EXISTING, FILE_FLAG_DELETE_ON_CLOSE, 0);
        if hFile <> INVALID_HANDLE_VALUE then
        begin
          Result := CloseHandle(hFile); // Feche o manipulador, que deve excluir o arquivo
        end;
      end;
    end;
  end;

  if not Result then
    raise Exception.CreateFmt('N�o foi poss�vel excluir o arquivo "%s".', [FileName]);
end;

//procedure pDocumentoWordRegistro(prData: TDatetime; prOrigem, prUsuario, prOP, prLote, prTeorSan, prDocumento, prCodigo, prRodape: string);
//var
//  MSWord, WordDoc, rng, SectionsVar: Variant;
//  i: Integer;
//  vlData: string;
//const
//  wdReplaceAll = 2;
//  wdHeaderFooterPrimary = 1;
//begin
//  vlData := FormatDateTime('DD/MM/YYYY HH:MM', prData);
//  MSWord := CreateOleObject('Word.Application');
//  MSWord.Visible := False;
//  WordDoc := MSWord.Documents.Open(prOrigem);
//
//  if WordDoc.ProtectionType <> -1 then
//  begin
//    // Documento est� protegido
//    ShowMessage('O documento est� protegido e n�o pode ser editado. Edite e tire o bloqueio.');
//    WordDoc.Close(False, EmptyParam, EmptyParam);
//    MSWord.Quit;
//    MSWord := Unassigned; // Liberar da mem�ria
//    Abort;
//  end
//  else
//  begin
//    // Substituir no corpo principal do documento
//    rng := WordDoc.Content;
//    rng.Find.Text := '<CODIGO>';
//    rng.Find.Replacement.Text := Trim(prCodigo);
//    rng.Find.Execute(Replace := wdReplaceAll);
//
//    rng.Find.Text := '<RODAPE>';
//    rng.Find.Replacement.Text := prRodape + ' por ' + prUsuario + ' em ' + vlData;
//    rng.Find.Execute(Replace := wdReplaceAll);
//
//    // Substituir nos rodap�s de todas as se��es
//    SectionsVar := WordDoc.Sections;
//    for i := 1 to SectionsVar.Count do
//    begin
//      rng := SectionsVar.Item(i).Footers(wdHeaderFooterPrimary).Range;  // <-- Ajuste aqui
//
//      rng.Find.Text := '<CODIGO>';
//      rng.Find.Replacement.Text := Trim(prCodigo);
//      rng.Find.Execute(Replace := wdReplaceAll);
//
//      rng.Find.Text := '<RODAPE>';
//      rng.Find.Replacement.Text := prRodape + ' por ' + prUsuario + ' em ' + vlData;
//      rng.Find.Execute(Replace := wdReplaceAll);
//    end;
//
//    WordDoc.Save;
//    WordDoc.Close(False, EmptyParam, EmptyParam);
//    MSWord.Quit;
//    MSWord := Unassigned; // Liberar da mem�ria
//  end;
//end;

// Funcao abaixo funcional at� 29/08/2023
procedure pDocumentoWordRegistro(prData: TDatetime; prOrigem, prUsuario, prOP, prLote, prTeorSan, prDocumento, prCodigo, prRodape: string);
var
  MSWord : Variant;
  vlData : string;
begin
  vlData := FormatDateTime('DD/MM/YYYY HH:MM', prData);
  MSWord := CreateOleObject('Word.Application');
  MSWord.Visible := False;
  MSWord.Documents.Open(prOrigem);

  if MSWord.ActiveDocument.ProtectionType <> -1 then
    begin
      // Documento est� protegido
      ShowMessage('O documento est� protegido e n�o pode ser editado. Edite e tire o bloqueio.');

      MsWord.ActiveDocument.Close(False, EmptyParam, EmptyParam);
      MsWord.Quit;

      MSWord := Unassigned; // Liberar da mem�ria

      Abort;
    end
  else
    begin
      MsWord.selection.find.text := '<OP>';
      MsWord.selection.find.replacement.text := Trim(prOP);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<LOTE>';
      MsWord.selection.find.replacement.text := Trim(prLote);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<TEOR_SAN>';
      MsWord.selection.find.replacement.text := Trim(prTeorSan);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<DOCUMENTO>';
      MsWord.selection.find.replacement.text := Trim(prDocumento);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<CODIGO>';
      MsWord.selection.find.replacement.text := Trim(prCodigo);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<RODAPE>';
      MsWord.selection.find.replacement.text := prRodape +' por ' + prUsuario + ' em ' + vlData;
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.ActiveDocument.Save;//As(prOrigem);
      MsWord.ActiveDocument.Close(False, EmptyParam, EmptyParam);
      MsWord.Quit;

      vlData := FormatDateTime('DD/MM/YYYY HH:MM', prData);
      MSWord := CreateOleObject('Word.Application');
      MSWord.Documents.Open(prOrigem);

      MsWord.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageFooter;//wdSeekFirstPageFooter;

      MsWord.selection.find.text := '<OP>';
      MsWord.selection.find.replacement.text := Trim(prOP);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<LOTE>';
      MsWord.selection.find.replacement.text := Trim(prLote);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<TEOR_SAN>';
      MsWord.selection.find.replacement.text := Trim(prTeorSan);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<DOCUMENTO>';
      MsWord.selection.find.replacement.text := Trim(prDocumento);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<CODIGO>';
      MsWord.selection.find.replacement.text := Trim(prCodigo);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<RODAPE>';
      MsWord.selection.find.replacement.text := prRodape +' por ' + prUsuario + ' em ' + vlData;
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MSWord.ActiveWindow.ActivePane.View.SeekView := wdSeekMainDocument;

      MSWord.Selection.EndKey(wdStory);

      // Repete nas proximas paginas
      MsWord.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageFooter;

      MsWord.selection.find.text := '<OP>';
      MsWord.selection.find.replacement.text := Trim(prOP);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<LOTE>';
      MsWord.selection.find.replacement.text := Trim(prLote);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<TEOR_SAN>';
      MsWord.selection.find.replacement.text := Trim(prTeorSan);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<DOCUMENTO>';
      MsWord.selection.find.replacement.text := Trim(prDocumento);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<CODIGO>';
      MsWord.selection.find.replacement.text := Trim(prCodigo);
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MsWord.selection.find.text := '<RODAPE>';
      MsWord.selection.find.replacement.text := prRodape +' por ' + prUsuario + ' em ' + vlData;
      MsWord.selection.find.execute(replace  := wdreplaceall);

      MSWord.ActiveWindow.ActivePane.View.SeekView := wdSeekMainDocument;

      MsWord.ActiveDocument.Save; //As(prOrigem);
      MsWord.ActiveDocument.Close(False, EmptyParam, EmptyParam);
      MsWord.Quit;

      MSWord := Unassigned; //liberar da mem�ria
    end;
end;

procedure ExcelOutStr(OutF: Variant; SLabel, SValue: String);
var i,j:integer;
begin
  try
    OutF.DisplayAlerts := false;

    //To place a string with linebreaks into one Cell
    SValue:=StringReplace(SValue,#13#10,#10,[rfReplaceAll, rfIgnoreCase]);

    for j:=1 to OutF.Sheets.Count do
    begin
       OutF.WorkSheets[j].Select;

       if length(SValue)<250 then
       begin
         OutF.Cells.Replace(What:=Slabel, Replacement:=SValue, LookAt:=2,SearchOrder:=1, MatchCase:=False);
       end
       else
       begin
              //Excel .replace fails on string with length >250 so replace it in few steps
              i:=1;
              while i<=length(SValue) do
              begin
                 if i+200-1<length(SValue) then
                    OutF.Cells.Replace(What:=Slabel, Replacement:=Copy(SValue,i,200)+SLabel, LookAt:=2,SearchOrder:=1, MatchCase:=False)
                 else
                    OutF.Cells.Replace(What:=Slabel, Replacement:=Copy(SValue,i,200), LookAt:=2,SearchOrder:=1, MatchCase:=False);
                 i:=i+200;
              end;
       end;
    end;
    OutF.WorkSheets[1].Select;
  except
      on E : Exception do ShowMessage('Error: Lablel ['+SLabel+'] '+E.Message);
  end;
end;

function fRetornaDataServidorIBX(prDatabase: TIBDatabase; prTransaction: TIBTransaction): TDateTime;
var
  qConsulta : TIBQuery;
begin
  qConsulta := TIBQuery.Create(nil);
  with qConsulta do
    begin
      Database    := prDatabase;
      Transaction := prTransaction;

      Close;
      SQL.Text := 'SELECT CURRENT_TIMESTAMP FROM RDB$DATABASE';
      Open;
    end;

  Result := qConsulta.FieldByName('CURRENT_TIMESTAMP').AsDateTime;
  qConsulta.Free;
end;

function pVisualizarExcel(prDatabase: TIBDatabase; prTransaction: TIBTransaction; prDocumentoID, prOrigem, prArquivoPDF, prUsuario, prTipo, prCodigo: string): TMemoryStream;
var
  vlExcel      : Variant;
  vlData       : string;
  qConfig      : TIBQuery;
  vFileNamePDF : string;
begin
  vlExcel := CreateOleObject('Excel.Application');
  vlExcel.Visible       := False;
  vlExcel.workbooks.open(prOrigem);

  ExcelOutStr(vlExcel,'#CODIGO#', prCodigo);
  ExcelOutStr(vlExcel,'#IMPRESSO#', 'Visualizado por: ' + prUsuario + ' em ' + FormatDateTime('DD/MM/YYYY HH:MM', fRetornaDataServidorIBX(prDatabase,prTransaction)));

  qConfig := TIBQuery.Create(Nil);
  with qConfig do
    begin
      Database    := prDatabase;
      Transaction := prTransaction;

      Close;
      SQL.Text := 'select';
      SQL.Add(' pagina, coluna_i, linha_i,');
      SQL.Add(' coluna_f, linha_f');
      SQL.Add(' from tbdoc_excel');
      SQL.Add(' where deletado = ''N'' ');
      SQL.Add(' and doc_id = ''' + prDocumentoID + ''' ');
      SQL.Add(' order by docexcel_id, pagina');
      Open;
    end;

  qConfig.First;
  while not qConfig.Eof do
    begin
      vlExcel.Workbooks[1].Sheets[qConfig.FieldByName('PAGINA').AsInteger].PageSetup.PrintArea  := '$' + qConfig.FieldByName('COLUNA_I').AsString +'$' + qConfig.FieldByName('LINHA_I').AsString +
                                                                                   ':$'+ qConfig.FieldByName('COLUNA_F').AsString +'$' + qConfig.FieldByName('LINHA_F').AsString;
      qConfig.Next;
    end;

  qConfig.Free;

  // Converte pra PDF
  vFileNamePDF := TPath.ChangeExtension(prOrigem,'.pdf');
  vlExcel.Workbooks[1].ExportAsFixedFormat(0,vFileNamePDF,0,True,False,EmptyParam,EmptyParam,False,EmptyParam);

  Result := LoadFileToMemoryStream(vFileNamePDF);
  Result.Position := 0;

  if FileExists(prArquivoPDF) then
    TFile.Delete(prArquivoPDF);

  // Salvar a pasta de trabalho
  // vlExcel.ActiveWorkbook.Save;

  vlExcel.ActiveWorkbook.Close(False, EmptyParam, EmptyParam);
  vlExcel.Quit;
  vlExcel := Unassigned;//liberar da mem�ria
end;

procedure pRegistroExcel(prExcel: Variant; prConfig : TIBQuery; prData: TDateTime; prDocumentoID, prLote, prErpProduto, prOP, prDocumento, prTeorSan, prCodigo, prUsuario, prTipo: string);
//var
//  vlExcel, vlDoc : Variant;
begin
//  vlExcel         := CreateOleObject('Excel.Application');
//  vlExcel.Visible := False;
//  vlExcel.workbooks.open(prOrigem);

  ExcelOutStr(prExcel,'#LOTE#',        Trim(prLote));
  ExcelOutStr(prExcel,'#ERP_PRODUTO#', Trim(prErpProduto));
  ExcelOutStr(prExcel,'#OP#',          Trim(prOP));
  ExcelOutStr(prExcel,'#DOCUMENTO#',   Trim(prDocumento));
  ExcelOutStr(prExcel,'#LANCAMENTO#',  Trim(prDocumentoID));
  ExcelOutStr(prExcel,'#TEOR_SAN#',    Trim(prTeorSan));
  ExcelOutStr(prExcel,'#CODIGO#',      Trim(prCodigo));

  ExcelOutStr(prExcel,'#IMPRESSO#', prTipo + ' por: ' + prUsuario + ' em ' + FormatDateTime('DD/MM/YYYY HH:MM', prData));

  with prConfig do
    begin
      Close;
      SQL.Text := 'select';
      SQL.Add(' pagina, coluna_i, linha_i,');
      SQL.Add(' coluna_f, linha_f');
      SQL.Add(' from tbdoc_excel');
      SQL.Add(' where deletado = ''N'' ');
      SQL.Add(' and doc_id = ''' + prDocumentoID + ''' ');
      SQL.Add(' order by pagina');
      Open;
    end;

  prConfig.First;
  while not prConfig.Eof do
    begin
      prExcel.Workbooks[1].Sheets[prConfig.FieldByName('PAGINA').AsInteger].PageSetup.PrintArea  := '$'  + prConfig.FieldByName('COLUNA_I').AsString +'$' + prConfig.FieldByName('LINHA_I').AsString +
                                                                                                    ':$' + prConfig.FieldByName('COLUNA_F').AsString +'$' + prConfig.FieldByName('LINHA_F').AsString;
      prConfig.Next;
    end;

//  prExcel.Workbooks[1].ExportAsFixedFormat(0,prArquivoPDF, 0, True, False, EmptyParam, EmptyParam, False, EmptyParam);

//  vlExcel.ActiveWorkbook.Close(False, EmptyParam, EmptyParam);
//  vlExcel.Quit;
//  vlExcel := Unassigned; //liberar da mem�ria
end;

function ExportWordStreamToPDF(WordStream: TMemoryStream; prExtensao: string): TMemoryStream;
var
  TempWordFileName, TempPDFFileName: string;
  TempFileStream     : TFileStream;
  ResultStream       : TMemoryStream;
  WinWordPDF, DocPDF : Variant;
begin
  // Criar arquivos tempor�rios para Word e PDF
  TempWordFileName := TPath.GetTempFileName + prExtensao;
  TempPDFFileName  := TPath.GetTempFileName + '.pdf';

  // Salvar o WordStream em um arquivo tempor�rio
  TempFileStream := TFileStream.Create(TempWordFileName, fmCreate);
  try
    TempFileStream.CopyFrom(WordStream, 0);
  finally
    TempFileStream.Free;
  end;

  // Abrir e exportar o arquivo Word como PDF
  WinWordPDF := CreateOleObject('Word.Application');
  try
    WinWordPDF.Visible := False;
    DocPDF := WinWordPDF.Documents.Open(TempWordFileName);
    DocPDF.ExportAsFixedFormat(TempPDFFileName, 17);
    WinWordPDF.ActiveDocument.Close(False, EmptyParam, EmptyParam);
    WinWordPDF.Quit;
  except
    WinWordPDF.Quit;
    raise;
  end;

  // Carregar o arquivo PDF tempor�rio no TMemoryStream e retorn�-lo
  ResultStream   := TMemoryStream.Create;
  TempFileStream := TFileStream.Create(TempPDFFileName, fmOpenRead);
  try
    ResultStream.CopyFrom(TempFileStream, TempFileStream.Size);
  finally
    TempFileStream.Free;
  end;

  // Excluir arquivos tempor�rios
  DeleteFile(TempWordFileName);
  DeleteFile(TempPDFFileName);

  Result := ResultStream;
end;

procedure pRodapePOPWord(prData: TDatetime; prDocumentoID, prOrigem, prUsuario, prTipo, prCodigo, prOP, prLote, prDocumento, prTeorSan: string);
var
  Word: Variant;
  Arquivo: Variant;
  Doc: Variant;
  i, j, k, Ponteiro: Integer;
  vlData : string;
  tags: array of string;
  replacements: array of string;
  returnMarker: string;
  topMargin, bottomMargin: Variant;
begin
  vlData := FormatDateTime('DD/MM/YYYY HH:MM', prData);

  Word := CreateOleObject('Word.Application');
  Word.Visible := False;
  Arquivo := Word.Documents;
  Doc := Arquivo.Open(prOrigem);

  // Store current margins
  topMargin := Doc.PageSetup.TopMargin;
  bottomMargin := Doc.PageSetup.BottomMargin;

  // Marcador tempor�rio para retornar ap�s manipula��o do cabe�alho e rodap�
  returnMarker := '<RETURNMARKER>';

  // Inserir o marcador no in�cio do documento
  Doc.Range(0, 0).InsertBefore(returnMarker);

  // Adicione todas as tags e suas substitui��es nos arrays abaixo.
  tags := ['<RODAPE>', '<LANCAMENTO>', '<CODIGO>', '<TEOR_SAN>', '<OP>', '<LOTE>', '<DOCUMENTO>'];
  replacements := [prTipo +' por ' + prUsuario + ' em ' + vlData, prDocumentoID, prCodigo, prTeorSan, prOP, prLote, prDocumento];

  // Substitua cada tag por seus respectivos valores no corpo do documento.
  for k := Low(tags) to High(tags) do
  begin
    Ponteiro := -1;
    while Ponteiro <> 0 do
      Ponteiro := Doc.Content.Find.Execute(FindText := tags[k], ReplaceWith := replacements[k], MatchWholeWord := True);
  end;

  // Repita o processo para cada se��o (cabe�alho e rodap�) do documento.
  for i := 1 to Doc.Sections.Count do
  begin
    for j := 1 to Doc.Sections.Item(i).Headers.Count do
    begin
      for k := Low(tags) to High(tags) do
      begin
        Ponteiro := -1;
        while Ponteiro <> 0 do
          Ponteiro := Doc.Sections.Item(i).Headers.Item(j).Range.Find.Execute(FindText := tags[k], ReplaceWith := replacements[k], MatchWholeWord := True);
      end;
    end;

    for j := 1 to Doc.Sections.Item(i).Footers.Count do
    begin
      for k := Low(tags) to High(tags) do
      begin
        Ponteiro := -1;
        while Ponteiro <> 0 do
          Ponteiro := Doc.Sections.Item(i).Footers.Item(j).Range.Find.Execute(FindText := tags[k], ReplaceWith := replacements[k], MatchWholeWord := True);
      end;
    end;
  end;

  // Restore margins
  Doc.PageSetup.TopMargin    := topMargin;
  Doc.PageSetup.BottomMargin := bottomMargin;

  // Procure e selecione o marcador
  Ponteiro := Doc.Content.Find.Execute(returnMarker);
  // Remova o marcador
  if Ponteiro <> 0 then
    Doc.Content.Find.Execute(FindText := returnMarker, ReplaceWith := '', MatchWholeWord := True);

  // Move the cursor to the beginning of the document
  Word.ActiveDocument.GoTo(What:=wdGoToLine, Which:=wdGoToFirst);

  Doc.Save;
  Doc.Close;
  Word.Quit;
end;

function HasHeader(const WordDoc: Variant): Boolean;
var
  HeaderText: string;
begin
  HeaderText := WordDoc.Sections(1).Headers(wdHeaderFooterPrimary).Range.Text;
  Result := (HeaderText <> '') and (HeaderText <> Chr(13)); // Chr(13) representa uma quebra de linha
end;

function HasFooter(const WordDoc: Variant): Boolean;
var
  FooterText: string;
begin
  FooterText := WordDoc.Sections(1).Footers(wdHeaderFooterPrimary).Range.Text;
  Result := (FooterText <> '') and (FooterText <> Chr(13));
end;

// Emanuel 13/09/2023
procedure pMardaDaguaWord(prOrigem: string);
var
  MSWord : Variant;
  HeaderContent: string;
begin
  MSWord := CreateOleObject('Word.Application');
  MSWord.Documents.Open(prOrigem);

  // Adicionar shape no corpo principal do documento
  MSWord.ActiveDocument.Shapes.AddTextEffect(msoTextEffect8, 'Em Treinamento', 'Arial Black', 50, False, False, 38, 350).Select();

  // Configurar propriedades do shape
  MsWord.Selection.ShapeRange.Line.Visible := False;
  MsWord.Selection.ShapeRange.Fill.Visible := True;
  MsWord.Selection.ShapeRange.Fill.ForeColor.RGB := RGB(187, 221, 255);
  MsWord.Selection.ShapeRange.Fill.Transparency := 0.0;
  MsWord.Selection.ShapeRange.Rotation := 315;
  MsWord.Selection.ShapeRange.Left := -999995;
  MsWord.Selection.ShapeRange.Shadow.Visible := False;

  // Salvar e fechar
  MsWord.ActiveDocument.Save;
  MsWord.ActiveDocument.Close(False, EmptyParam, EmptyParam);
  MsWord.Quit;

  MSWord := Unassigned; // Liberar da mem�ria
end;

// Emanuel 01/09/2023
//procedure pMardaDaguaWord(prOrigem: string);
//var
//  MSWord : Variant;
//begin
//  MSWord := CreateOleObject('Word.Application');
//  MSWord.Documents.Open(prOrigem);
//
//  MsWord.ActiveWindow.ActivePane.View.SeekView := wdSeekFirstPageHeader;
//
//  MSWord.Selection.HeaderFooter.Shapes.AddTextEffect(msoTextEffect8, 'Em Treinamento', 'Arial Black', 50, False, False, 38, 350).Select();
//  MsWord.Selection.ShapeRange.Select(0);
//  MsWord.Selection.ShapeRange.Line.Visible := False;
//  MsWord.Selection.ShapeRange.Fill.Visible := True;
//  MsWord.Selection.ShapeRange.Fill.ForeColor.RGB := RGB(187, 221, 255);
//  MsWord.Selection.ShapeRange.Fill.Transparency  := 0.0;
//  MsWord.Selection.ShapeRange.Rotation           := 315;
//  MsWord.Selection.ShapeRange.Left               := -999995;
//  MsWord.Selection.ShapeRange.Shadow.Visible     := False;
//  MsWord.ActiveWindow.ActivePane.View.SeekView   := wdSeekMainDocument;
//
//  MSWord.Selection.EndKey(wdStory);
//
//  MsWord.ActiveWindow.ActivePane.View.SeekView := wdSeekCurrentPageHeader;
//  MSWord.Selection.HeaderFooter.Shapes.AddTextEffect(msoTextEffect8, 'Em Treinamento', 'Arial Black', 50, False, False, 38, 350).Select();
//  MsWord.Selection.ShapeRange.Select(0);
//  MsWord.Selection.ShapeRange.Line.Visible := False;
//  MsWord.Selection.ShapeRange.Fill.Visible := True;
//  MsWord.Selection.ShapeRange.Fill.ForeColor.RGB := RGB(187, 221, 255);
//  MsWord.Selection.ShapeRange.Fill.Transparency  := 0.0;
//  MsWord.Selection.ShapeRange.Rotation := 315;
//  MsWord.Selection.ShapeRange.Left     := -999995;
//  MsWord.Selection.ShapeRange.Shadow.Visible   := False;
//  MsWord.ActiveWindow.ActivePane.View.SeekView := wdSeekMainDocument;
//
//  MsWord.ActiveDocument.Save;//As(prOrigem);
//  MsWord.ActiveDocument.Close(False, EmptyParam, EmptyParam);
//  MsWord.Quit;
//
//  MSWord := Unassigned;//liberar da mem�ria
//end;

procedure pArredondaTopoComponente(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
    begin
      R   := ClientRect;
      Rgn := CreateRoundRectRgn(0, 0, width, height + 20, 20, 20);
      Perform(EM_GETRECT, 0, lParam(@r));
      InflateRect(r, - 5, - 5);
      Perform(EM_SETRECTNP, 0, lParam(@r));
      SetWindowRgn(Handle, rgn, True);
      Invalidate;
    end;
end;

procedure pArredondaComponente(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
    begin
      R := ClientRect;
      rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
      Perform(EM_GETRECT, 0, lParam(@r));
      InflateRect(r, - 5, - 5);
      Perform(EM_SETRECTNP, 0, lParam(@r));
      SetWindowRgn(Handle, rgn, True);
      Invalidate;
    end;
end;

{ Fun��o que verefica se o ano � BI-SEXTO}
function AnoBiSexto(Ano : Integer) : Boolean;
begin
  // 04/04/2016 as 14:13
  // Fonte: http://www.planetadelphi.com.br/dica/6552/descobrir-quantos-dias-tem-em-um-determinado-m%C3%AAs-do-ano
  Result := (Ano mod 4 = 0) and ((Ano mod 100 <> 0) or (Ano mod 400 = 0));
end;

{ Fun��o que retornar� quantos dias tem em determinado mes do ano, j� sendo processado os anos que s�o
  BI-SEXTO }
function DiasPorMes(Ano, Mes : Integer): Integer;
const DiasMeses : array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  // 04/04/2016 as 14:13
  // Fonte: http://www.planetadelphi.com.br/dica/6552/descobrir-quantos-dias-tem-em-um-determinado-m%C3%AAs-do-ano

  Result := DiasMeses[Mes];

  if (Mes = 2) and AnoBiSexto(Ano) then
    Inc(Result);
end;

function fIncrementaLetra(prVersao, prParametro: String): String;
var
  letra      :char;
  caracter{ultima letra do campo},variavel{armazena letra}:string;
  quantidade :byte;//quantidade de caracteres
  resultado{caracter tranformado em numero},valida{autoriza mudar caracter}:integer;
  vlNovaVersao : String;
begin
//  if prParametro = '1.0' then
//    begin
      vlNovaVersao := '';//limpa editis antes de adicionar

      caracter   := prVersao;         // caracteres digitado
      variavel   := vlNovaVersao;     // variavel de armazenamento
      quantidade := length(prVersao); // quantidade de caracter para calculo
      valida     := 0;                 // execu��o de processo

      while (quantidade>0) do //repetir varias vezes at� quantidade ser igual a zero
        begin
          letra := caracter[quantidade]; //importar caracter para campo letra

          case letra of //converte letra em n�mero
            'A': variavel:= '1';
            'B': variavel:= '2';
            'C': variavel:= '3';
            'D': variavel:= '4';
            'E': variavel:= '5';
            'F': variavel:= '6';
            'G': variavel:= '7';
            'H': variavel:= '8';
            'I': variavel:= '9';
            'J': variavel:= '10';
            'K': variavel:= '11';
            'L': variavel:= '12';
            'M': variavel:= '13';
            'N': variavel:= '14';
            'O': variavel:= '15';
            'P': variavel:= '16';
            'Q': variavel:= '17';
            'R': variavel:= '18';
            'S': variavel:= '19';
            'T': variavel:= '20';
            'U': variavel:= '21';
            'V': variavel:= '22';
            'W': variavel:= '23';
            'X': variavel:= '24';
            'Y': variavel:= '25';
            'Z': variavel:= '26';
          end;// case letra

          if (strtoint(variavel)<27) and (valida=0) then
            begin
              variavel:=inttostr(strtoint(variavel)+1);
              valida:=-1;
            end;//end do variavel<27 e valida=0

           if (strtoint(variavel)<27) and (valida=1) then
             begin
                variavel:=inttostr(strtoint(variavel)+1);
                  if (strtoint(variavel)<27) then
                    valida:=0
                  else
                    valida:=1;
              end;//end do variavel<27 e valida=1

          if (strtoint(variavel)>26) then
            begin
              variavel := '1';
              valida   := 1;
            end;//end do variavel>26

            resultado:=strtoint(variavel);//retornar Letra no lugar do n�mero

          case resultado of //convertendo e recopiando caracteres anterior
            1: vlNovaVersao  := 'A' + vlNovaVersao;
            2: vlNovaVersao  := 'B' + vlNovaVersao;
            3: vlNovaVersao  := 'C' + vlNovaVersao;
            4: vlNovaVersao  := 'D' + vlNovaVersao;
            5: vlNovaVersao  := 'E' + vlNovaVersao;
            6: vlNovaVersao  := 'F' + vlNovaVersao;
            7: vlNovaVersao  := 'G' + vlNovaVersao;
            8: vlNovaVersao  := 'H' + vlNovaVersao;
            9: vlNovaVersao  := 'I' + vlNovaVersao;
            10: vlNovaVersao := 'J' + vlNovaVersao;
            11: vlNovaVersao := 'K' + vlNovaVersao;
            12: vlNovaVersao := 'L' + vlNovaVersao;
            13: vlNovaVersao := 'M' + vlNovaVersao;
            14: vlNovaVersao := 'N' + vlNovaVersao;
            15: vlNovaVersao := 'O' + vlNovaVersao;
            16: vlNovaVersao := 'P' + vlNovaVersao;
            17: vlNovaVersao := 'Q' + vlNovaVersao;
            18: vlNovaVersao := 'R' + vlNovaVersao;
            19: vlNovaVersao := 'S' + vlNovaVersao;
            20: vlNovaVersao := 'T' + vlNovaVersao;
            21: vlNovaVersao := 'U' + vlNovaVersao;
            22: vlNovaVersao := 'V' + vlNovaVersao;
            23: vlNovaVersao := 'W' + vlNovaVersao;
            24: vlNovaVersao := 'X' + vlNovaVersao;
            25: vlNovaVersao := 'Y' + vlNovaVersao;
            26: vlNovaVersao := 'Z' + vlNovaVersao;
          end;//case result

          quantidade:=quantidade-1; //subtrai quantidade at� chegar a zero

          if (quantidade = 0) and (valida = 1) then//adiciona 'A' se sequencia chegar ao fim
            vlNovaVersao := 'A' + vlNovaVersao;
        end;

      Result := vlNovaVersao;
//    end;
//  else
//    begin
//      if prVersao = '' then
//        Result := '01'
//      else
//        begin
//          prVersao := RemoveZerosEsquerdaSIC(prVersao);
////          prVersao := Inc(StrToInt(prVersao));
////          Result := IntToStr(Inc(StrToInt(RemoveZerosEsquerdaSIC(prVersao))));
//        end;
//    end;
end;

function StrTran(const Texto, Esta, PorEsta: string): string;
begin
  Result := StringReplace(Texto, Esta, PorEsta, [rfReplaceAll, rfIgnoreCase] );
end;

function fEmpty(xValue: Variant): Boolean;
var
  sTmp: String;
  iDia, iMes, iAno: Word;
begin
  // 22/06/2019
  // Fonte: http://www.planetadelphi.com.br/dica/3627/empty---validando-se-a-variavel-ou-campo-esta-vazio

  {Pr�-Defini��o do Retorno}
  Result := False;

  if xValue = Null then begin
    Result := True;
    Exit;
  end;

  if VarType(xValue) = VarEmpty then
    Result := True;

  if VarType(xValue) = varNull then
    Result := True;

  if VarType(xValue) = varSmallInt then
    Result := (xValue = 0);

  if VarType(xValue) = varInteger then
    Result := (xValue = 0);

  if VarType(xValue) = varSingle then
    Result := (xValue = 0);

  if VarType(xValue) = varDouble then
    Result := (xValue = 0);

  if VarType(xValue) = varCurrency then
    Result := (xValue = 0);

  if VarType(xValue) = varDate then begin
    Result := (xValue = Null);
    if not Result then begin
      DecodeDate(xValue,iAno,iMes,iDia);
      if ((iDia = 30) and (iMes = 12) and (iAno = 1899)) then
        Result := True;
    end;

    if not Result then begin
      sTmp := DateToStr(xValue);
      sTmp := StrTran(sTmp,'/','');
      sTmp := StrTran(sTmp,'-','');
      sTmp := StrTran(sTmp,'.','');
      Result := fEmpty(sTmp);
    end;
  end;

  if VarType(xValue) = varString then
    Result := (Length(StrTran(xValue, ' ', '')) = 0);

  if VarType(xValue) = varOleStr then
    Result := (xValue = Null);

  if VarType(xValue) = varDispatch then
    Result := (xValue = Null);

  if VarType(xValue) = varByte then
    Result := (xValue = Null);

end;

function VerificaData(dataNasc: Tdate): integer;
var
  anoN, mes, dia : word;
  anoA, mesA, diaA : word;
begin
  Decodedate(dataNasc,anoN,mes,dia);
  Decodedate(Date,anoA,mesA,diaA);

  //Subtrai Ano atual por Ano de nascimento e retorna a diferen�a.
  Result := anoA - anoN;
end;

function fCPFRepetido(prQuery: TIBQuery; prCPF, prID, prTipo: string): Boolean;
begin
  if prTipo = 'Pessoa' then
    begin
      if ((prID <> '') and (prCPF <> '')) then
        begin
          with prQuery do
            begin
              Close;
              SQL.Text := 'select pessoa_id, nome from tbpessoas where deletado = ''N'' and pessoa_id <> ''' + prID + ''' and CPF_CNPJ = ''' + prCPF + ''' ';
              Open;

              if not IsEmpty then
                Result := True
              else
                Result := False;
            end;
        end;
    end;

  if prTipo = 'Dependente' then
    begin
      if ((prID <> '') and (prCPF <> '')) then
        begin
          with prQuery do
            begin
              Close;
              SQL.Text := 'select pessoadepedente_id as PESSOA_ID, NOME from tbpessoas_dependente where deletado = ''N'' ';
              SQL.Add(' and pessoadepedente_id <> ''' + prID + ''' and CPF = ''' + prCPF + ''' ');
              SQL.Add(' and tipodependente_id <> ''400'' ');
              Open;

              if not IsEmpty then
                Result := True
              else
                Result := False;
            end;
        end;
    end;
end;

procedure ExpDataSetXLS(DataSet: TDataSet; Arq: string);
var
  ExcApp: OleVariant;
  i,l: integer;
begin
  ExcApp := CreateOleObject('Excel.Application');
  ExcApp.Visible := True;
  ExcApp.WorkBooks.Add;
  DataSet.First;
  l := 1;
  DataSet.First;
  while not DataSet.EOF do
//  begin
//    for i := 0 to DataSet.Fields.Count - 1 do
//      ExcApp.WorkBooks[1].Sheets[1].Cells[l,i + 1] :=
//        DataSet.Fields[i].DisplayText;
//    DataSet.Next;
//    l := l + 1;
//  end;
//  ExcApp.WorkBooks[1].SaveAs(Arq);
end;

function CarteiraToTipoOperacaoBNB(const Carteira: string): String;
begin
  if Carteira = '1' then
    Result:= '21'
  else if Carteira = '2' then
    Result:= '41'
  else if Carteira = '4' then
    Result:= '21'
  else if Carteira = '5' then
    Result:= '41'
  else if Carteira = '6' then
    Result:= '31'
  else if Carteira = 'I' then
    Result:= '51'
  else
    Result:= Carteira;
end;

procedure LimpaMemoria;
var
  MainHandle : THandle;
begin
   try
      MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
      SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
      CloseHandle(MainHandle) ;
   except

   end;
   Application.ProcessMessages;
end;

function  fValidaTelefone(prTelefone: string): Boolean;
var
  formato : string;
begin
  formato := Trim(StringReplace(prTelefone, '(', '', []));
  formato := Trim(StringReplace(formato, ')', '', []));
  formato := Trim(StringReplace(formato, '-', '', []));

  if (Length(Trim(formato)) < 10) then
    Result := False
  else
    Result := True;
end;

function RemoveZerosEsquerdaSIC(ANumStr: String): String;
var
  I, L: Integer;
begin
  L := Length(ANumStr);
  I := 1;
  while (I < L) and (ANumStr[I] = '0') do
    Inc(I);

  Result := Copy(ANumStr, I, L);
end;

function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function ExecAndWait(const FileName: string; const CmdShow: Integer): Longword;
var { by Pat Ritchey }
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppIsRunning: DWORD;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    while WaitForSingleObject(ProcessInfo.hProcess, 0) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      Sleep(50);
    end;
    {
    // or:
    repeat
      AppIsRunning := WaitForSingleObject(ProcessInfo.hProcess, 100);
      Application.ProcessMessages;
      Sleep(50);
    until (AppIsRunning <> WAIT_TIMEOUT);
    }

    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end; { WinExecAndWait32 }

function TrocaCaracterEspecial(aTexto : string; aLimExt : boolean) : string;
const
  //Lista de caracteres especiais
  xCarEsp: array[1..39] of String = ('�', '�', '�', '�', '�','�', '�', '�', '�', '�',
                                     '�', '�','�', '�', '�', '�', '�','�', '�',
                                     '�', '�', '�','�', '�','�', '�', '�', '�', '�',
                                     '�', '�', '�','�', '�', '�','�','�','�','�');
  //Lista de caracteres para troca
  xCarTro: array[1..39] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                     'e', 'e','E', 'E', 'e', 'i', 'i','I', 'I',
                                     'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                     'u', 'u', 'u','u', 'u', 'u','c','C','n', 'N');
  //Lista de Caracteres Extras
  xCarExt: array[1..48] of string = ('<','>','!','@','#','$','%','�','&','*',
                                     '(',')','_','+','=','{','}','[',']','?',
                                     ';',':',',','|','*','"','~','^','�','`',
                                     '�','�','�','�','�','�','�','�','�','�',
                                     '�','�','�','�','�','�','�','�');
var
  xTexto : string;
  i : Integer;
begin
   xTexto := aTexto;
   for i:=1 to 38 do
     xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfreplaceall]);
   //De acordo com o par�metro aLimExt, elimina caracteres extras.  
   if (aLimExt) then
     for i:=1 to 48 do
       xTexto := StringReplace(xTexto, xCarExt[i], '', [rfreplaceall]);   
   Result := xTexto;
end;

{usada para alinhar os textos � direita. Tem como fun��o inserir caracteres em
  branco � direita da string at� o limite estabelecido no segundo par�metro}
function PadR(ATexto: string; ATamanho: integer): string;
var
  i: integer;
begin
  Result := ATexto;
  for i := 1 to (ATamanho - Length(Result)) do
    Result := ' ' + Result;
end;

{usada para alinhar os textos � esquerda. Tem como fun��o inserir caracteres em
  branco � direita da string at� o limite estabelecido no segundo par�metro}
function PadL(ATexto: string;
  ATamanho: Integer): string;
var
  i: integer;
begin
  Result := ATexto;
  for i := 1 to (ATamanho - Length(Result)) do
    Result := Result + ' ';
end;

{ser� usada para retirar caracteres especiais da string, como: pontos,
 tra�os ou barras. Ideal para limpar m�scaras de CNPJ, CPF etc}
function LimparString(ATExto, ACaracteres: string): string;
var
  strAux: string;
  i: integer;
begin
  strAux := '';
  for i := 1 to Length(ATexto) do
    if Pos(Copy(ATexto, i, 1), ACaracteres) <= 0 then
      strAux := strAux + Copy(ATexto, i, 1);
  Result := strAux;
end;


{em alguns campos de valor ser� necess�rio formatar incluindo pontos
 de decimal e milhar}
function IncluirPonto(ATexto: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(ATexto) do
    if ATexto[i] = ',' then
      Result := Result + '.'
    else
      Result := Result + ATexto[i];
end;

function valorPorExtenso(vlr: real): string;
const
  unidade: array[1..19] of string = ('um', 'dois', 'tr�s', 'quatro', 'cinco',
             'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
             'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
             'dezessete', 'dezoito', 'dezenove');
  centena: array[1..9] of string = ('cento', 'duzentos', 'trezentos',
             'quatrocentos', 'quinhentos', 'seiscentos',
             'setecentos', 'oitocentos', 'novecentos');
  dezena: array[2..9] of string = ('vinte', 'trinta', 'quarenta', 'cinquenta',
             'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array[0..4] of string = ('', 'mil', 'milh�o', 'bilh�o', 'trilh�o');
  qualificaP: array[0..4] of string = ('', 'mil', 'milh�es', 'bilh�es', 'trilh�es');
var
                        inteiro: Int64;
                          resto: real;
  vlrS, s, saux, vlrP, centavos: string;
     n, unid, dez, cent, tam, i: integer;
                    umReal, tem: boolean;
begin
  if (vlr = 0)
     then begin
            valorPorExtenso := 'zero';
            exit;
          end;

  inteiro := trunc(vlr); // parte inteira do valor
  resto := vlr - inteiro; // parte fracion�ria do valor
  vlrS := inttostr(inteiro);
  if (length(vlrS) > 15)
     then begin
            valorPorExtenso := 'Erro: valor superior a 999 trilh�es.';
            exit;
          end;

  s := '';
  centavos := inttostr(round(resto * 100));

// definindo o extenso da parte inteira do valor
  i := 0;
  umReal := false; tem := false;
  while (vlrS <> '0') do
  begin
    tam := length(vlrS);
// retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
// 1a. parte = 789 (centena)
// 2a. parte = 456 (mil)
// 3a. parte = 123 (milh�es)
    if (tam > 3)
       then begin
              vlrP := copy(vlrS, tam-2, tam);
              vlrS := copy(vlrS, 1, tam-3);
            end
    else begin // �ltima parte do valor
           vlrP := vlrS;
           vlrS := '0';
         end;
    if (vlrP <> '000')
       then begin
              saux := '';
              if (vlrP = '100')
                 then saux := 'cem'
              else begin
                     n := strtoint(vlrP);        // para n = 371, tem-se:
                     cent := n div 100;          // cent = 3 (centena trezentos)
                     dez := (n mod 100) div 10;  // dez  = 7 (dezena setenta)
                     unid := (n mod 100) mod 10; // unid = 1 (unidade um)
                     if (cent <> 0)
                        then saux := centena[cent];
                     if ((dez <> 0) or (unid <> 0))
                        then begin
                               if ((n mod 100) <= 19)
                                  then begin
                                         if (length(saux) <> 0)
                                            then saux := saux + ' e ' + unidade[n mod 100]
                                         else saux := unidade[n mod 100];
                                       end
                               else begin
                                      if (length(saux) <> 0)
                                         then saux := saux + ' e ' + dezena[dez]
                                      else saux := dezena[dez];
                                      if (unid <> 0)
                                         then if (length(saux) <> 0)
                                                 then saux := saux + ' e ' + unidade[unid]
                                              else saux := unidade[unid];
                                    end;
                          end;
                   end;
              if ((vlrP = '1') or (vlrP = '001'))
                 then begin
                        if (i = 0) // 1a. parte do valor (um real)
                           then umReal := true
                        else saux := saux + ' ' + qualificaS[i];
                      end
              else if (i <> 0)
                      then saux := saux + ' ' + qualificaP[i];
              if (length(s) <> 0)
                 then s := saux + ', ' + s
              else s := saux;
            end;
    if (((i = 0) or (i = 1)) and (length(s) <> 0))
       then tem := true; // tem centena ou mil no valor
    i := i + 1; // pr�ximo qualificador: 1- mil, 2- milh�o, 3- bilh�o, ...
  end;

  if (length(s) <> 0)
     then begin
            if (umReal)
               then s := s + ' real'
            else if (tem)
                    then s := s + ' reais'
                 else s := s + ' de reais';
          end;
// definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
     then begin
            if (length(s) <> 0) // se n�o � valor somente com centavos
               then s := s + ' e ';
            if (centavos = '1')
               then s := s + 'um centavo'
            else begin
                   n := strtoint(centavos);
                   if (n <= 19)
                      then s := s + unidade[n]
                   else begin                 // para n = 37, tem-se:
                          unid := n mod 10;   // unid = 37 % 10 = 7 (unidade sete)
                          dez := n div 10;    // dez  = 37 / 10 = 3 (dezena trinta)
                          s := s + dezena[dez];
                          if (unid <> 0)
                             then s := s + ' e ' + unidade[unid];
                       end;
                   s := s + ' centavos';
                 end;
          end;
  valorPorExtenso := s;
end;

Function CPF(num: string): boolean;
var
  n1,n2,n3,n4,n5,n6,n7,n8,n9: integer;
  d1,d2: integer;
  digitado, calculado: string;
  begin
    n1:=strtoint(num[1]);
    n2:=strtoint(num[2]);
    n3:=strtoint(num[3]);
    n4:=strtoint(num[4]);
    n5:=strtoint(num[5]);
    n6:=strtoint(num[6]);
    n7:=strtoint(num[7]);
    n8:=strtoint(num[8]);
    n9:=strtoint(num[9]);
    d1:=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
    d1:=11-(d1 mod 11);

    if d1>=10 then
      d1:=0;
    d2:=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
    d2:=11-(d2 mod 11);

    if d2>=10 then
      d2:=0;
    calculado:=inttostr(d1)+inttostr(d2);
    digitado:=num[10]+num[11];
    if calculado=digitado then
      cpf := true
    Else
      cpf:=false
    end;

Function CNPJ(num:string): boolean;
var
  n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,d2: integer;
  digitado, calculado: string;
begin
  n1:=strtoint(num[1]);
  n2:=strtoint(num[2]);
  n3:=strtoint(num[3]);
  n4:=strtoint(num[4]);
  n5:=strtoint(num[5]);
  n6:=strtoint(num[6]);
  n7:=strtoint(num[7]);
  n8:=strtoint(num[8]);
  n9:=strtoint(num[9]);
  n10:=strtoint(num[10]);
  n11:=strtoint(num[11]);
  n12:=strtoint(num[12]);
  d1:=n12*2+n11*3+n10*4+n9*5+n8*6+n7*7+n6*8+n5*9+n4*2+n3*3+n2*4+n1*5;
  d1:=11-(d1 mod 11);
  if d1>=10 then d1:=0;
    d2:=d1*2+n12*3+n11*4+n10*5+n9*6+n8*7+n7*8+n6*9+n5*2+n4*3+n3*4+n2*5+n1*6;
  d2:=11-(d2 mod 11);
  calculado:=inttostr(d1)+inttostr(d2);
  digitado:=num[13]+num[14];
  if calculado=digitado then
    CNPJ := true
  Else
    CNPJ := false;
end;

procedure GravaIni (Caminho, Caminho2, Usuario, Usuario2, Senha, Senha2, CharacterSet, Auto,
                   Arquivo : String; Dialeto : Integer; Maquina: String);
var
  ArqIni : TIniFile;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+ Arquivo + '.Ini');
  Try
    ArqIni.WriteString ('SIC', 'Caminho',  Caminho);
    ArqIni.WriteInteger('SIC', 'Dialeto',  Dialeto);
    ArqIni.WriteString ('SIC', 'Usuario',  Usuario);
    ArqIni.WriteString ('PED', 'Usuario2', Usuario2);
    ArqIni.WriteString ('SIC', 'Senha',    Senha);
    ArqIni.WriteString ('PED', 'Senha2',   Senha2);
    ArqIni.WriteString ('SIC', 'ChrSet',   CharacterSet);
    ArqIni.WriteString ('SIC', 'Auto',     Auto);
    ArqIni.WriteString ('PED', 'Caminho2', Caminho2);
    ArqIni.WriteString ('SIC', 'Maquina', Maquina);
  Finally
    ArqIni.Free;
  end;
end;

procedure LeIni (var Caminho, Caminho2, Usuario, Usuario2, Senha, Senha2, CharacterSet, Auto : String;
                   Arquivo : String; var Dialeto : Integer; Maquina: String);
var
  ArqIni : tIniFile;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+ Arquivo + '.Ini');
  Try
    Caminho      := ArqIni.ReadString  ('SIC', 'Caminho' , Caminho);
    Caminho2     := ArqIni.ReadString  ('PED', 'Caminho2', Caminho2);
    Dialeto      := ArqIni.ReadInteger ('SIC', 'Dialeto' , Dialeto);
    Usuario      := ArqIni.ReadString  ('SIC', 'Usuario' , Usuario);
    Usuario2     := ArqIni.ReadString  ('PED', 'Usuario2', Usuario2);
    Senha        := ArqIni.ReadString  ('SIC', 'Senha'   , Senha);
    Senha2       := ArqIni.ReadString  ('PED', 'Senha2'  , Senha2);
    CharacterSet := ArqIni.ReadString  ('SIC', 'ChrSet'  , CharacterSet);
    Auto         := ArqIni.ReadString  ('SIC', 'Auto'    , Auto);
  Finally
    ArqIni.Free;
  end;
end;

procedure CapturaError(Sender : TObject; E : Exception);
var
   Msg: string;
   FileName : String;
   LogFile  : TextFile;
begin
//  if UpperCase(Copy(E.Message,1,13)) = 'OUT OF MEMORY' Then
//     begin
//        OutOfMemoryError;
//     end;

   // grava erro no aquivo de log
   FileName := 'C:\Systems\ERROS.TXT';
   AssignFile(LogFile, FileName);
   If NOT FileExists(FileName)Then
      Begin
          ReWrite(LogFile);
          CloseFile(LogFile);
     end;
   try
      Append(LogFile);
      WriteLn(LogFile,FormatDateTime('dd/mm/yyyy hh:mm:ss',now)+' '+Screen.ActiveForm.Name+' '+Screen.ActiveControl.Name+' '+e.Message);
      CloseFile(LogFile);
   except
      // Exibe Mensagem para o Usu�rio
      msg:=E.message+#10+#10;
      msg:=msg+'Form: '+Screen.ActiveForm.Name+#10;
      msg:=msg+'Origem: '+Screen.ActiveControl.Name;
      MessageDlg(msg,mtError,[mbOK],0);
   end;
end;

procedure AbreForm(aClasseForm: TComponentClass; aForm: TForm);
begin
  Application.CreateForm(aClasseForm, aForm);
  try
    aForm.Top  := 53;
    aForm.Left := 213;
    aForm.ShowModal;
  finally
    FreeAndNil(aForm);
  end;
end;

function SoNumeros(pStr:String): String;
Var
  I : Integer;
begin
  Result := '';
  For I := 1 To Length(pStr) do
   If pStr[I] In ['1','2','3','4','5','6','7','8','9','0'] Then
     Result := Result + pStr[I];
end;

procedure Incrementa(TableName: String; PrimaryKey: TField; Recebe: TField; Connection: TIBDatabase);
Var
  QR : TIBQuery;
begin
  QR := TIBQuery.Create(Nil);
  Try
    QR.Database := Connection;
    QR.SQL.Clear;
    QR.SQL.Text := 'SELECT MAX('+PrimaryKey.FieldName+') FROM '+ TableName;
    QR.Open;
    If QR.RecordCount > 0 Then
      PrimaryKey.AsInteger := QR.Fields[0].AsInteger + 1
    else
      PrimaryKey.AsInteger := 0;
    Recebe.Value := PrimaryKey.Value;  
  finally
    FreeAndNil(QR); // Libera a QR da mem�ria
  end;
end;

procedure Get_Build_Info(var v1, v2, v3, v4 : Word);
var
  ver_infosize,
  ver_valuesize,
  dummy          : DWord;
  ver_info       : Pointer;
  ver_value      : PVSFixedFileInfo;
begin
  ver_infosize := GetFileVersionInfoSize(PChar(ParamStr(0)), dummy);
  GetMem(ver_info, ver_infosize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, ver_infosize, ver_info);
  VerQueryValue(ver_info, '\', Pointer(ver_value), ver_valuesize);
  With ver_value^ do begin
    v1 := dwFileVersionMS shr 16;
    v2 := dwFileVersionMS and $FFFF;
    v3 := dwFileVersionLS shr 16;
    v4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(ver_info, ver_infosize);
end;

function Get_Versao : String;
var
  v1, v2, v3, v4 : Word;
begin
  Get_build_info(v1, v2, v3, v4);
  Result := IntToStr(v1) + '.' +
            IntToStr(v2) + '.' +
            IntToStr(v3) + '.' +
            IntToStr(v4);
end;

function ExtrairNome(const Filename: String): String;
{Retorna o nome do Arquivo sem extens�o}
var
  aExt : String;
  aPos : Integer;
begin
  aExt := ExtractFileExt(Filename);
  Result := ExtractFileName(Filename);
  if aExt <> '' then
    begin
     aPos := Pos(aExt,Result);
     if aPos > 0 then
       begin
         Delete(Result,aPos,Length(aExt));
       end;
     end;
end;

procedure LimpaEdit(Form: TForm);
var
  i : Integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
  if Form.Components[i] is TCustomEdit then
    (Form.Components[i] as TCustomEdit).Clear;
end;

function SomaHoras(valor1, valor2, operacao: string): string;
var
  ihoras,iminutos, minutos,horas, somaMin, horaFin, minFin, tam,
  pos1,pos2,pos3,pos4, tam2: integer;
  sinal,min,zeros,zeros2,horasF: String;
begin
  if (Length(valor1) > 6) OR (Length(valor2) > 6) then
    begin
      ShowMessage('A Fun��o SomaHoras 1.0 s� suporta at�'+#13+'centenas de horas para Adi��o'
                   +#13+'e dezenas de horas para subtra��o! Soma');
      exit;
    end;
  If (Length(valor1) > 6) OR (Length(valor2) > 6) AND (operacao ='menos') then
    begin
      ShowMessage('A Fun��o SomaHoras 1.0 s� suporta at�'+#13+'centenas de horas para Adi��o'
                  +#13+'e dezenas de horas para subtra��o! Menos');
      exit;
    end;

  if Length(valor1)= 5 then
    begin
      pos2 := 4;
      pos1 := 2;
    end
  else
    begin
     pos2 := 5;
     pos1 := 3;
    end;

  if Length(valor2)= 5 then
    begin
      pos3 := 4;
      pos4 := 2;
    end
  else
    begin
      pos3 := 5;
      pos4 := 3;
    end;

  iminutos := StrToInt(Copy (valor1,pos2,2));
  ihoras   := StrToInt(Copy (valor1,1,pos1));

  iminutos := iminutos + (ihoras * 60);

  minutos  := StrToInt(Copy (valor2,pos3,2));
  horas    := StrToInt(Copy (valor2,1,pos4));

  minutos  := minutos + (horas * 60);

  If operacao ='menos' then
    somaMin := iminutos - minutos
  else
    somaMin := iminutos + minutos;

  horaFin := somaMin div 60;
  minFin  := somaMin mod 60;

  If (horaFin < 0) OR (minFin < 0) then
    sinal := '-'
  else
    sinal := '';

  min    := IntToStr(abs(minFin));
  horasF := IntToStr(abs(horaFin));

  tam  := Length(min);
  tam2 := Length(horasF);

  If tam = 1 then
    zeros:='0'
  else
    zeros:='';

  If tam2 = 1 then
    zeros2:='0'
  else
    zeros2:='';

  Result:= sinal+zeros2+horasF+':'+zeros+min;
end;

procedure GravaRegEdit;
Const
  Raiz : String = 'C3S\Valida��o';
Var
  Registro : TRegistry;
begin
  // Chama o Construtor do objeto
  Registro := TRegistry.Create;
  // Abre a chave (se o 2� Par�metro for True
  // cria-se a chave caso ela ainda n�o exista
  Registro.OpenKey(Raiz, True);
  // Grava as Informa��es
  Registro.WriteDate('Data', Date);
  Registro.WriteDate('Validade', Date + 30);

//  Registro.WriteBool('NomedoValor', Conte�do); Boolean
//  Registro.WriteBinaryData('NomedoValor', Conte�do); Bin�rio
//  Registro.WriteCurrency('NomedoValor', Conte�do); Currency
//  Registro.WriteDate('NomedoValor', Conte�do); Date
//  Registro.WriteDateTime('NomedoValor', Conte�do); DateTime
//  Registro.WriteFloat('NomedoValor', Conte�do); Float (Real)
//  Registro.WriteInteger('NomedoValor', Conte�do); Integer
//  Registro.WriteString('NomedoValor', Conte�do); String
//  Registro.WriteTime('NomedoValor', Conte�do); Time
  Registro.CloseKey;
  Registro.Free;
end;

{
procedure LerRegEdit;
Const
  Raiz : String = 'C3S\Valida��o';
Var
  Registro : TRegistry;
begin
  Registro := TRegistry.Create;
  with Registro do
    begin
      if OpenKey(Raiz, False) then
        begin
          if ValueExists('Data') then
            If ReadDate('Data') =
          Registro.CloseKey;
          Registro.Free;
        end;
    end;

end;
}

function FinalizarProcesso(sFile: String): Boolean;
var
  verSystem: TOSVersionInfo;
  hdlSnap,hdlProcess: THandle;
  bPath,bLoop: Bool;
  peEntry: TProcessEntry32;
  arrPid: Array [0..1023] of DWORD;
  iC: DWord;
  k,iCount: Integer;
  arrModul: Array [0..299] of Char;
  hdlModul: HMODULE;
begin
  Result := False;
  if ExtractFileName(sFile)=sFile then
    bPath:=false
  else
    bPath:=true;

  verSystem.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(verSystem);
  if verSystem.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS then
  begin
    hdlSnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    peEntry.dwSize:=Sizeof(peEntry);
    bLoop:=Process32First(hdlSnap,peEntry);
    while integer(bLoop)<> 0 do
    begin
      if bPath then
      begin
        if CompareText(peEntry.szExeFile,sFile) = 0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID), 0);
          Result := True;
        end;
      end
      else
      begin
        if CompareText(ExtractFileName(peEntry.szExeFile),sFile) = 0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID), 0);
          Result := True;
        end;
      end;
      bLoop := Process32Next(hdlSnap,peEntry);
    end;
    CloseHandle(hdlSnap);
  end
  else
    if verSystem.dwPlatformId=VER_PLATFORM_WIN32_NT then
    begin
      EnumProcesses(@arrPid,SizeOf(arrPid),iC);
      iCount := iC div SizeOf(DWORD);
      for k := 0 to Pred(iCount) do
      begin
        hdlProcess:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,arrPid [k]);
        if (hdlProcess<>0) then
        begin
          EnumProcessModules(hdlProcess,@hdlModul,SizeOf(hdlModul),iC);
          GetModuleFilenameEx(hdlProcess,hdlModul,arrModul,SizeOf(arrModul));
          if bPath then
          begin
            if CompareText(arrModul,sFile) = 0 then
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
              Result := True;
            end;
          end
          else
          begin
            if CompareText(ExtractFileName(arrModul),sFile) = 0 then
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
              Result := True;
            end;
          end;
          CloseHandle(hdlProcess);
        end;
      end;
    end;
end;

procedure GravaRegistro(Raiz: HKEY; Chave, Valor, Endereco: string);
var
  Registro: TRegistry;
begin
  Registro := TRegistry.Create(KEY_WRITE); // Chama o construtor do objeto
  Registro.RootKey := Raiz; //Define a chave raiz
  Registro.OpenKey(Chave, True); //Cria a chave
  Registro.WriteString(Valor, '"' + Endereco + '"'); //Grava o endere�o da sua aplica��o no Registro
  Registro.CloseKey; // Fecha a chave e o objeto
  Registro.Free;
end;

procedure ApagaRegistro(Raiz: HKEY; Chave, Valor: string);
var
  Registro: TRegistry;
begin
  Registro := TRegistry.Create(KEY_WRITE); // Chama o construtor do objeto
  Registro.RootKey := Raiz;
  Registro.OpenKey(Chave, True); //Cria a chave
  Registro.DeleteValue(Valor); //Grava o endere�o da sua aplica��o no Registro
  Registro.CloseKey; // Fecha a chave e o objeto
  Registro.Free;
end;

function Montante(Capital, Taxa, Tempo: Double): Double;
begin
  Montante := Capital * (1 + (Taxa /100) * Tempo);
end;

Function PreencherZero( const Conteudo : Integer; Const Preencher : String; const TamString : Integer ): String;
Var
qtdFor, i : Integer;
vFull : String;
begin

  qtdFor := Length( IntToStr( Conteudo ) );
  vFull := '';
  If qtdFor >= TamString Then
    result := RightStr( IntToStr( Conteudo ), qtdFor )
  else
    begin
      qtdFor := TamString - QtdFor;
      For i := 1 to qtdFor do
        vFull := vFull + Preencher;
        Result := vFull + IntToStr( Conteudo );
    end;
end;

function LerRegString(const Root: HKey; const key, campo:string): string;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    reg.rootKey := root;
    result := '';
    if Reg.OpenKey(Key, false) then
      result := Reg.ReadString(campo);
  finally
    Reg := nil;
    Reg.Free;
  end;
end;

function GetNomeComputador : String;
var
  lpBuffer : PChar;
  nSize    : DWord;
const Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
begin
  nSize    := Buff_Size;
  lpBuffer := StrAlloc(Buff_Size);
  GetComputerName(lpBuffer,nSize);
  Result   := String(lpBuffer);
  StrDispose(lpBuffer);
end;

function RemoveZeros(S: string): string;
var
I, J : Integer;
begin
{I := Length(S);
while (I > 0) and (S[I] <= ' ') do
      begin
      Dec(I);
      end;
J := 1;
while (J < I) and ((S[J] <= ' ') or (S[J] = '0')) do
      begin
      Inc(J);
      end;
Result := Copy(S, J, (I-J)+1);
}
Result := IntToStr(StrToIntDef(S,0));
end;

function ZeroEsquerda(const I: integer; const Casas: byte): string;
var
  Ch: Char;
begin
  Result := IntToStr(I);
{  if Length(Result) > Casas then
  begin
    Ch := '*';
    Result := '';
  end
  else
}
  Ch := '0';
  while Length(Result) < Casas do
    Result := Ch + Result;
end;

procedure EntreDatas(DataFinal, DataInicial: TDate; var Anos, Meses,
  Dias: Integer);

function Calcula(Periodo: Integer): Integer ;
  var
    intCont: Integer ;
  begin
    intCont := 0 ;
    repeat
      Inc(intCont) ;
      DataFinal := IncMonth(DataFinal,Periodo * -1) ;
    until DataFinal < DataInicial ;
    DataFinal := IncMonth(DataFinal,Periodo) ;
    Inc(intCont,-1) ;
    Result := intCont ;
  end;
begin
  if DataFinal <= DataInicial then
  begin
    Anos := 0 ;
    Meses := 0 ;
    Dias := 0 ;
    exit ;
  end;

  Anos := Calcula(12) ;

  Meses := Calcula(1) ;

  Dias := Round(DataFinal - DataInicial);
end;

function FormataTelefone(sTelefone: String): String;
var
  s: string;
  tam: Integer;
begin
  s   := Trim(sTelefone) ;
  tam := Length(s);

  case tam of
    8: //Ex: 37212121
      begin
        Result:= Copy(s,1,4)+'-'+Copy(s,5,4);
      end;
    10: //Ex: 3237212121 = (32)3721-2121
      begin
        Result:= '('+Copy(s,1,2)+')'+Copy(s,3,4)+'-'+Copy(s,7,4);
      end;
    11: //Ex: 13237212121 = +1(32)3721-2121
      begin
        Result:= '+'+Copy(s,1,1)+'('+Copy(s,2,2)+')'+Copy(s,4,4)+'-'+Copy(s,8,4);
      end;
    12: //Ex: 553237212121 = +55(32)3721-2121
      begin
        Result:= '+'+Copy(s,1,2)+'('+Copy(s,3,2)+')'+Copy(s,5,4)+'-'+Copy(s,9,4);
      end;
    else
      Result := s;
  end;
end;

function UltimoDiaDoMes( MesAno: string ): string;
var
  sMes: string;
  sAno: string;
begin
  sMes := Copy( MesAno, 1, 2 );
  sAno := Copy( MesAno, 4, 2 );
  if Pos(sMes, '01 02 03 04 05 06 07 08 09 10 11 12') > 0 then
    UltimoDiaDoMes := '31'
  else if sMes <> '02' then
    UltimoDiaDoMes := '30'
  else if ( StrToInt( sAno ) mod 4 ) = 0 then
    UltimoDiaDoMes := '29'
  else
    UltimoDiaDoMes := '28';
end;

function GetIPAddress: String;
type
  pu_long = ^u_long;
var
  varTWSAData : TWSAData;
  varPHostEnt : PHostEnt;
  varTInAddr  : TInAddr;
  namebuf     : Array[0..255] of ansichar;
Begin
  try
    try
      if WSAStartup($101,varTWSAData) <> 0 then
        Result := ''
      else
        begin
          gethostname(namebuf, SizeOf(namebuf));
          varPHostEnt       := gethostbyname(namebuf);
          varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
          Result := inet_ntoa(varTInAddr);
        end;
    except
      Result := '';
    end;
  finally
    WSACleanup;
  end;
end;

end.
