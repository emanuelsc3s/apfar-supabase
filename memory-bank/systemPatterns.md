# System Patterns - Apfar Supabase

## Arquitetura do Sistema

### Visão Geral
O sistema segue uma arquitetura de aplicação desktop tradicional em Delphi VCL, com estrutura modular baseada em formulários e unidades de código. A arquitetura é centrada em torno de um formulário principal que coordena as operações de sincronização entre dois bancos de dados.

### Padrão Arquitetural Principal
**Arquitetura em Camadas com Formulários Coordenadores:**
- **Camada de Apresentação**: Formulários VCL (.dfm + .pas)
- **Camada de Lógica de Negócio**: Units Pascal com regras de negócio
- **Camada de Acesso a Dados**: Componentes FireDAC e SQL direto
- **Camada de Configuração**: Arquivos INI e parâmetros hardcoded

## Componentes Principais e Relacionamentos

### 1. Aplicação Principal (ApfarSupabase.dpr)
**Responsabilidade**: Ponto de entrada e inicialização da aplicação
**Padrão**: Application Controller padrão Delphi
```pascal
// Padrão clássico de inicialização Delphi
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Apfar Supabase';
  Application.CreateForm(TFormApfarSupabase, FormApfarSupabase);
  Application.Run;
end.
```

### 2. Formulário Principal (Unit_ApfarSupabase)
**Responsabilidade**: Coordenação central das operações
**Padrão**: Controller/Form Mediator
**Componentes Críticos**:
- `FDConnection1`: Conexão com Supabase (PostgreSQL)
- `FDConnectionTOTVS`: Conexão com TOTVS (SQL Server)
- `FDQuery1`, `FDQuery2`: Queries para operações de leitura/escrita
- `FDGUIxWaitCursor1`: Gerenciamento de cursor durante operações
- `FDPhysMSSQLDriverLink1`, `FDPhysPGDriverLink1`: Drivers de banco

**Padrões de Conexão**:
```pascal
// Padrão de configuração hardcoded para Supabase
FDConnection1.Params.DriverID := 'PG';
FDConnection1.Params.Database := 'postgres';
FDConnection1.Params.UserName := 'postgres.xxxxxxxxxxxx';
FDConnection1.Params.Password := 'xxxxxxxxxxxx';
FDConnection1.Params.Server := 'aws-0-sa-east-1.pooler.supabase.com';
FDConnection1.Params.Port := '5432';

// Padrão de configuração dinâmica para TOTVS via INI
FDConnectionTOTVS.Params.DriverID := 'MSSQL';
// Parâmetros lidos do arquivo BaseSIC.ini
```

### 3. Formulário de Atividade (Unit_Activity)
**Responsabilidade**: Interface de progresso e logging
**Padrão**: Progress Observer
**Componentes**: Controles visuais para feedback do usuário durante operações

### 4. Formulário de Configuração (Unit_ConfigSqlServer)
**Responsabilidade**: Configuração de parâmetros de conexão SQL Server
**Padrão**: Configuration Form
**Componentes**: Interface para edição de parâmetros de conexão

### 5. Biblioteca de Funções (Biblioteca.pas)
**Responsabilidade**: Funções utilitárias e regras de negócio
**Padrão**: Utility Library
**Funcionalidades**: Funções compartilhadas entre formulários

## Padrões de Design em Uso

### 1. Padrão de Gerenciamento de Conexões
**Strategy Pattern para Conexões**:
- Duas estratégias de conexão: hardcoded (Supabase) e dinâmica (TOTVS)
- Gerenciamento centralizado no formulário principal
- Validação de conexões antes de operações

### 2. Padrão de Operações de Banco de Dados
**Data Access Object (DAO) Implícito**:
- Queries diretas nos componentes FDQuery
- SQL embutido no código (embedded SQL)
- Transações manuais com try-except-end

```pascal
// Padrão típico de operação com transação
try
  FDConnection1.StartTransaction;
  FDQuery1.ExecSQL;
  FDConnection1.Commit;
except
  FDConnection1.Rollback;
  raise;
end;
```

### 3. Padrão de Tratamento de Erros
**Exception Handling Delphi Padrão**:
```pascal
try
  // Operação de risco
except
  on E: Exception do
  begin
    ShowMessage('Erro: ' + E.Message);
    // Logging do erro
  end;
end;
```

### 4. Padrão de Interface com Usuário
**Form-based UI Pattern**:
- Formulários modais para operações específicas
- Progresso visual durante operações longas
- Mensagens de erro amigáveis

## Fluxos de Dados Críticos

### 1. Fluxo de Configuração
```
BaseSIC.ini → Unit_ConfigSqlServer → FDConnectionTOTVS
           ↓
     Unit_ApfarSupabase (validação)
```

### 2. Fluxo de Importação de Dados
```
TOTVS (SQL Server) → FDConnectionTOTVS → FDQuery1 → Processamento
                   ↓
     Transformação de Dados → FDQuery2 → Supabase (PostgreSQL)
```

### 3. Fluxo de Feedback ao Usuário
```
Operação → Unit_Activity → Interface Visual → Usuário
```

## Decisões Técnicas Importantes

### 1. Escolha do FireDAC
**Justificativa**: Componente nativo Delphi com suporte a múltiplos bancos de dados
**Benefícios**: Abstração de driver, gerenciamento de conexões, suporte a transações

### 2. Arquitetura de Formulários Múltiplos
**Justificativa**: Separação de responsabilidades e organização do código
**Benefícios**: Manutenibilidade, reutilização, clareza funcional

### 3. Configuração Mista (Hardcoded + INI)
**Justificativa**: 
- Supabase: parâmetros fixos para simplificar deployment
- TOTVS: configuração dinâmica para flexibilidade em diferentes ambientes

### 4. SQL Embutido no Código
**Justificativa**: Simplicidade para operações diretas e performance
**Trade-off**: Menos flexibilidade para mudanças de schema

## Padrões de Nomenclatura

### Componentes
- Prefixo `FD` para componentes FireDAC
- Nomes descritivos: `FDConnection1`, `FDQuery1`, etc.
- Controles visuais seguem padrão Delphi: `Button1`, `Edit1`, etc.

### Units e Forms
- Units com prefixo `Unit_`: `Unit_ApfarSupabase`, `Unit_Activity`
- Forms com prefixo `Form`: `FormApfarSupabase`, `FormActivity`
- Classes com prefixo `T`: `TFormApfarSupabase`, `TFormActivity`

## Gerenciamento de Recursos

### Memória
- Gerenciamento manual de objetos Delphi
- Padrão create-free para objetos dinâmicos
- Componentes visuais gerenciados automaticamente pelo VCL

### Conexões
- Conexões abertas sob demanda
- Pool de conexões gerenciado pelo FireDAC
- Fechamento explícito de conexões quando não utilizadas

### Transações
- Controle manual de transações
- Rollback automático em exceções
- Commit explícito após sucesso das operações
