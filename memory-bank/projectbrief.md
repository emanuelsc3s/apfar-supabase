# Project Brief - Apfar Supabase

## Visão Geral
Apfar Supabase é uma aplicação Delphi VCL desenvolvida para sincronização de bancos de dados entre Supabase (PostgreSQL) e TOTVS (SQL Server). A aplicação fornece uma interface gráfica para importar dados do sistema TOTVS para o banco de dados Supabase do projeto apfar.

## Objetivo Principal
Desenvolver e manter uma ferramenta robusta de sincronização de dados que permita a transferência eficiente e segura de informações entre o sistema ERP TOTVS e a plataforma Supabase, garantindo integridade dos dados e compatibilidade com as estruturas de ambos os bancos.

## Escopo do Projeto

### Funcionalidades Principais
- Conexão simultânea com Supabase (PostgreSQL) e TOTVS (SQL Server)
- Interface visual para operações de importação de dados
- Configuração de parâmetros de conexão para ambos os bancos
- Sincronização seletiva de tabelas e registros
- Tratamento de erros e logging de operações

### Tecnologias Utilizadas
- **Linguagem**: Object Pascal/Delphi 10.4 Seattle
- **Framework**: VCL (Visual Component Library)
- **Banco de Dados**: 
  - Supabase (PostgreSQL) - destino
  - SQL Server (TOTVS) - origem
- **Conectividade**: FireDAC
- **Plataforma**: Windows 64-bit

### Componentes Principais
- **Aplicação Principal**: `ApfarSupabase.dpr`
- **Formulário Principal**: `Unit_ApfarSupabase.pas/.dfm`
- **Formulário de Atividade**: `Unit_Activity.pas/.dfm`
- **Formulário de Configuração**: `Unit_ConfigSqlServer.pas/.dfm`
- **Biblioteca de Funções**: `Biblioteca.pas`

### Requisitos Técnicos
- Compatibilidade com Delphi 10.4 Seattle
- Utilização de componentes FireDAC para conectividade
- Suporte a SSL para conexão com Supabase
- Leitura de configurações via arquivo INI para conexão TOTVS
- Gerenciamento manual de memória e recursos

## Restrições e Considerações
- Manter compatibilidade com Delphi 10.4 Seattle
- Não utilizar recursos de versões mais recentes do Delphi
- Focar apenas em arquivos de código fonte (*.pas, *.dfm)
- Ignorar arquivos de configuração e build do IDE
- Não incluir funcionalidades de compilação ou execução no código

## Entregáveis Esperados
- Aplicação funcional de sincronização de dados
- Documentação técnica completa
- Código fonte bem estruturado e documentado
- Interface intuitiva para operações de importação
