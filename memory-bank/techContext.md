# Tech Context - Apfar Supabase

## Tecnologias Utilizadas

### Linguagem e Framework
- **Linguagem**: Object Pascal/Delphi
- **Versão**: Delphi 10.4 Seattle (Embarcadero RAD Studio)
- **Framework**: VCL (Visual Component Library)
- **Runtime**: Windows 64-bit
- **Paradigma**: Programação orientada a objetos com componentes visuais

### Bancos de Dados
- **Supabase**: PostgreSQL 15+ (via Supabase cloud)
  - Driver: FireDAC PostgreSQL Driver
  - Conexão: SSL obrigatório via pooler de sessões
  - Host: aws-0-sa-east-1.pooler.supabase.com:5432
  
- **TOTVS**: Microsoft SQL Server
  - Versões suportadas: SQL Server 2012+
  - Driver: FireDAC SQL Server Driver
  - Autenticação: SQL Server Authentication ou Windows Authentication

### Bibliotecas e Componentes
- **FireDAC**: Framework de acesso a dados da Embarcadero
  - FDConnection, FDQuery, FDTransaction
  - FDPhysMSSQLDriverLink, FDPhysPGDriverLink
  - FDGUIxWaitCursor para feedback visual
  
- **VCL Standard**: Componentes visuais padrão
  - TForm, TButton, TEdit, TMemo, TProgressBar
  - TMainMenu, TPopupMenu para menus
  - TTimer para operações agendadas

## Setup de Desenvolvimento

### Ambiente Requerido
- **IDE**: Delphi 10.4 Seattle ou superior (compatível com 10.4)
- **Sistema Operacional**: Windows 10/11 64-bit
- **Memória**: Mínimo 8GB RAM, recomendado 16GB+
- **Espaço em Disco**: 2GB para IDE + dependências

### Estrutura de Diretórios
```
apfar-supabase/
├── ApfarSupabase.dpr          # Arquivo principal do projeto
├── ApfarSupabase.dproj        # Arquivo de projeto Delphi
├── Unit_*.pas                 # Units de código fonte
├── Unit_*.dfm                 # Formulários VCL
├── Biblioteca.pas             # Biblioteca de funções
├── Win64/                     # Dependências de runtime
│   ├── libpq.dll              # PostgreSQL client
│   ├── libcrypto-3-x64.dll    # OpenSSL crypto
│   ├── libssl-3-x64.dll       # OpenSSL SSL
│   └── BaseSIC.ini.example    # Exemplo de configuração
├── docs/                      # Documentação
└── memory-bank/               # Memory bank do projeto
```

### Dependências de Runtime
**DLLs Essenciais (pasta Win64/)**:
- **PostgreSQL Client**: libpq.dll, libiconv-2.dll, libintl-9.dll, libpgtypes.dll
- **OpenSSL**: libcrypto-3-x64.dll, libssl-3-x64.dll
- **Compression**: liblz4.dll, libzstd.dll
- **XML/XSLT**: libxml2.dll, libxslt.dll
- **cURL**: libcurl.dll
- **Outras**: zlib1.dll, libwinpthread-1.dll

## Restrições Técnicas

### Limitações do Delphi 10.4
- Não utilizar recursos de versões mais recentes (10.5+)
- Sintaxe compatível com Delphi 10.4 Seattle
- Componentes VCL disponíveis na versão 10.4
- Restrições de gerenciamento de memória manual

### Restrições de Banco de Dados
- **Supabase**: Apenas conexão via pooler de sessões
- **TOTVS**: Limitado a configurações via arquivo INI
- **FireDAC**: Utilizar apenas componentes disponíveis em 10.4

### Restrições de Plataforma
- **Windows Only**: Apenas plataforma Windows 64-bit
- **No Cross-Platform**: Sem suporte a macOS, Linux, iOS, Android
- **No UWP**: Sem suporte a Universal Windows Platform

## Padrões de Uso de Ferramentas

### IDE Delphi
- **Gerenciamento de Projetos**: Utilizar .dproj para configurações
- **Versionamento**: Ignorar arquivos .dproj.local, .identcache
- **Build**: Manual via IDE (não automatizar builds)
- **Debug**: Utilizar debugger integrado do Delphi

### Controle de Versão
- **Git**: Utilizar para versionamento de código fonte
- **.gitignore**: Configurado para ignorar arquivos de build e temporários
- **Branch Strategy**: Branch principal para desenvolvimento estável

### Documentação
- **Memory Bank**: Utilizar estrutura padrão de memory bank
- **Markdown**: Formato padrão para documentação
- **Diretório docs/**: Documentação adicional em formato .md

## Configuração de Ambiente

### Variáveis de Ambiente
- **PATH**: Incluir pasta Win64/ com DLLs necessárias
- **DELPHI**: Apontar para instalação do Delphi 10.4
- **SUPABASE_URL**: Configurar URL do Supabase (opcional)

### Arquivos de Configuração
- **BaseSIC.ini**: Configuração de conexão TOTVS
  ```
  [Protheus]
  Server=servidor_sql
  Database=nome_banco
  User=usuario
  Password=senha
  ```

### FireDAC Configuration
- **Driver Registration**: Drivers registrados em tempo de design
- **Connection Parameters**: Parâmetros definidos em runtime
- **Transaction Isolation**: Padrão read committed

## Performance e Otimização

### Estratégias de Performance
- **Connection Pooling**: Utilizar pool do FireDAC
- **Batch Operations**: Operações em lote para grandes volumes
- **Indexação**: Garantir índices adequados nas tabelas
- **Memory Management**: Gerenciamento manual cuidadoso de objetos

### Monitoramento
- **Query Performance**: Monitorar tempo de execução de queries
- **Connection Status**: Verificar estado das conexões
- **Memory Usage**: Controlar uso de memória da aplicação
- **Error Logging**: Registrar erros para análise posterior

## Segurança

### Conexões Seguras
- **SSL/TLS**: Obrigatório para conexão Supabase
- **Credential Storage**: Senhas não armazenadas em código
- **Connection Validation**: Validar conexões antes de operações

### Tratamento de Dados
- **SQL Injection**: Utilizar parâmetros em queries
- **Data Validation**: Validar dados antes de inserção
- **Error Handling**: Não expor informações sensíveis em erros

## Manutenção e Deploy

### Distribuição
- **Executable**: Único arquivo .exe + pasta Win64/ com DLLs
- **Dependencies**: Todas as DLLs na mesma pasta do executável
- **Configuration**: Arquivo BaseSIC.ini no mesmo diretório

### Atualizações
- **Version Control**: Utilizar Git para controle de versões
- **Backward Compatibility**: Manter compatibilidade com configurações existentes
- **Rollback**: Capacidade de reverter para versões anteriores
