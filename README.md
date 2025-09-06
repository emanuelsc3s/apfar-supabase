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

## Licença

Este projeto é proprietário e destinado ao uso interno da organização.

---

**Desenvolvido com Delphi 10.4 Sydney**