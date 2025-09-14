---
type: "always_apply"
---

# CLAUDE.md

Este arquivo fornece orientação a Claude Code (claude.ai/code) ao trabalhar com código neste repositório.

# LANGUAGE

Sempre me responda, escreva comentários no código, gere documentações no idioma português do Brasil.

# Projeto apfar-supabase - Importador de dados para Supabase

## Visão Geral do Projeto

Esta é uma aplicação Delphi VCL para sincronização de bancos de dados entre Supabase (PostgreSQL) projeto apfar e TOTVS (SQL Server). A aplicação fornece uma interface simples para importar dados para o Supabase.
Foque apenas nos arquivos de código fonte *.pas e *.dfm .
**ATUE COMO UM DESENVOLVEDOR SÊNIOR EM DELPHI** com profundo conhecimento da linguagem Object Pascal/Delphi.

### Versão do Delphi
- **Delphi 10.4 Seattle** (Embarcadero RAD Studio)
- Compatibilidade com recursos até essa versão
- Evitar sintaxe/recursos de versões mais recentes

## Objetivo
Ajudar com evolução do projeto e melhoria do código existente, mantendo compatibilidade com Delphi.
Build e testes serão feitos externamente na IDE do Delphi.
Ignore completamente a estrutura de configuração - trabalhe apenas com código fonte.

## Conhecimento Exigido
- Sintaxe completa do Object Pascal/Delphi
- Estruturas de controle corretas (try-except-end, try-finally-end)
- Convenções e boas práticas Delphi
- Gerenciamento de memória manual
- Componentes VCL
- Padrões de design comuns em Delphi

## Arquivos Relevantes
- **Analisar apenas**: arquivos `.pas` e `.dfm`
- **Ignorar**: `.dpr`, `.dcu`, `.exe`, `.dof`, `.cfg`, `.res`, `.dproj.local`, `.identcache` e outros arquivos de build

## Estrutura dos Arquivos
- `.pas`: Arquivos de código Object Pascal (units, forms, classes)
- `.dfm`: Arquivos de design/formulários (sempre relacionados ao `.pas` de mesmo nome)
- Exemplo: `FormPrincipal.pas` + `FormPrincipal.dfm` = um formulário completo

## Arquivos que NÃO devem ser tocados:
- *.res (arquivos de recursos)
- *.dpr (arquivo principal do projeto)

## Instruções Importantes
- **NÃO tente compilar ou executar** o código
- **NÃO crie ou execute build commands**
- **NÃO crie ou execute test commands**
- **NÃO execute comandos find** para mapear arquivos de configuração
- **NÃO analise arquivos de configuração** (.dof, .dproj.local, .identcache, etc.)
- **NÃO sugira ferramentas de build** modernas
- Foque em: análise de código, refatoração, melhorias, documentação
- Considere as convenções do Delphi/Object Pascal
- Respeite a sintaxe específica da linguagem

## Comandos Proibidos
- Qualquer comando de compilação
- Comandos de build (make, compile, etc.)
- Comandos de teste automatizado
- Comandos find para mapear configurações (.dof, .dproj.local, .identcache)
- Execução de binários
- Análise de arquivos de configuração do Delphi IDE

## Arquitetura

- **Aplicação Principal**: `ApfarSupabase.dpr` - Ponto de entrada padrão da aplicação Delphi
- **Formulário Primário**: `Unit_ApfarSupabase.pas` - Formulário principal que gerencia conexões e operações com o banco de dados
- **Layout do Formulário**: `Unit_ApfarSupabase.dfm` - Componentes visuais e propriedades

### Arquitetura do Banco de Dados

A aplicação utiliza componentes FireDAC para conectividade dupla com o banco de dados:

1. **Conexão Supabase** (`FDConnection1`):
- Banco de dados PostgreSQL via Supabase
- Conexão: `aws-0-sa-east-1.pooler.supabase.com:5432`
- Banco de Dados: `postgres`
- Utiliza o modo de pooler de sessões com SSL necessário

2. **Conexão TOTVS** (`FDConnectionTOTVS`):
- Banco de dados SQL Server para integração com o TOTVS ERP
- Configuração carregada do arquivo `BaseSIC.ini`
- Suporta Autenticação SQL e Autenticação do Windows

### Dependências
- Bibliotecas do cliente PostgreSQL (libpq.dll e DLLs relacionadas na pasta Win64)
- Drivers FireDAC para PostgreSQL e SQL Server

## Configuração

- Os parâmetros de conexão do Supabase são codificados na criação do formulário
- Os parâmetros de conexão do TOTVS são lidos do arquivo `BaseSIC.ini` no diretório do aplicativo
- O arquivo INI deve conter uma seção `[Protheus]` com detalhes da conexão com o banco de dados

## Estrutura de Documentação
- **Diretório docs/**: Toda nova documentação deve ser salva em formato `*.md` no diretório `/docs/`
- **NÃO criar documentação** na raiz do projeto

## Screenshots e Análise Visual
- **Diretório de Screenshots**: `C:\Users\Administrador\Pictures\Screenshots`
- **Análise automática**: Sempre que solicitado para analisar prints ou screenshots, visualizar automaticamente o arquivo mais recente deste diretório
- **Uso**: Para resolução de tarefas baseadas em capturas de tela do sistema