# ApfarSupabase - Importador de Dados

Aplicação Delphi VCL para sincronização de bancos de dados entre Supabase (PostgreSQL) e TOTVS (SQL Server).

## Visão Geral

Esta aplicação fornece uma interface simples para importar e sincronizar dados entre sistemas, conectando especificamente:
- **Supabase** (PostgreSQL) - Banco de dados do projeto apfar
- **TOTVS ERP** (SQL Server) - Sistema de gestão empresarial

## Tecnologias Utilizadas

- **Delphi 10.4 Sydney** (Embarcadero RAD Studio)
- **Object Pascal/Delphi**
- **FireDAC** - Componentes de conectividade com banco de dados
- **PostgreSQL** (via Supabase)
- **SQL Server** (TOTVS local)

## Arquitetura

### Conexões de Banco de Dados

1. **Conexão Supabase** (`FDConnectionSupabase`):
   - Banco de dados PostgreSQL via Supabase
   - Servidor: `aws-0-sa-east-1.pooler.supabase.com:5432`
   - Banco: `postgres`
   - Utiliza pooler de sessões com SSL

2. **Conexão TOTVS** (`FDConnectionTOTVS`):
   - Banco de dados SQL Server
   - Configuração via arquivo `BaseSIC.ini`
   - Suporte a Autenticação SQL e Windows

### Estrutura de Arquivos

- **`ApfarSupabase.dpr`** - Arquivo principal da aplicação
- **`Unit_ApfarSupabase.pas`** - Formulário principal com lógica de conexão
- **`Unit_ApfarSupabase.dfm`** - Layout e componentes visuais
- **`Win64/`** - Bibliotecas necessárias (libpq.dll e dependências)
- **`prod-ca-2021.crt`** - Certificado SSL para conexão segura

## Configuração

### Pré-requisitos

- Delphi 10.4 Sydney
- Drivers FireDAC para PostgreSQL e SQL Server
- Arquivo `BaseSIC.ini` configurado no diretório da aplicação

### Arquivo de Configuração

Crie o arquivo `BaseSIC.ini` no diretório da aplicação com o seguinte formato:

```ini
[Protheus]
DriverID=MSSQL
Database=TOTVS_PRODUCAO
Username=sa
Password=321654654
Server=192.168.0.0
Network=TCPIP
Address=192.168.0.0
OSAuthent=False
MARS=Yes
Workstation=supabase
ApplicationName=apfarsupabase
VendorLib=sqlncli11.dll

```

### Bibliotecas Necessárias

As seguintes DLLs devem estar na pasta `Win64/`:
- `libpq.dll` - Driver PostgreSQL
- `libcrypto-3-x64.dll`, `libssl-3-x64.dll` - Suporte SSL
- Outras dependências incluídas na pasta Win64

## Funcionalidades

- ✅ Conexão simultânea com Supabase e TOTVS
- ✅ Interface gráfica amigável
- ✅ Configuração flexível via arquivo INI
- ✅ Suporte a SSL para conexões seguras
- ✅ Sincronização de dados (em desenvolvimento)

## Como Usar

1. Configure o arquivo `BaseSIC.ini` com os dados do seu servidor TOTVS
2. Execute a aplicação `ApfarSupabase.exe`
3. A aplicação irá conectar automaticamente aos dois bancos de dados
4. Utilize a interface para realizar as operações de importação

## Desenvolvimento

### Compilação

- Abra o projeto no Delphi 10.4 Seattle
- Compile usando `Ctrl+F9` ou menu Project → Build
- O executável será gerado na pasta Win64

### Estrutura do Código

```
├── ApfarSupabase.dpr          # Arquivo principal do projeto
├── Unit_ApfarSupabase.pas     # Lógica principal da aplicação
├── Unit_ApfarSupabase.dfm     # Interface visual
├── Win64/                     # Bibliotecas e DLLs
│   ├── libpq.dll             # Driver PostgreSQL
│   └── ...                   # Outras dependências
└── BaseSIC.ini               # Configuração (criar manualmente)
```

## Contribuição

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Crie um Pull Request

## Licença

Este projeto é proprietário e destinado ao uso interno da organização.

## Suporte

Para questões técnicas ou problemas, entre em contato com a equipe de desenvolvimento.

---

**Desenvolvido com Delphi 10.4 Sydney**