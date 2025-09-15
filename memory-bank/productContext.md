# Product Context - Apfar Supabase

## Por que este projeto existe

### Problema Resolvido
O projeto Apfar Supabase nasceu da necessidade de integrar sistemas legados de ERP (TOTVS/Protheus) com plataformas modernas de banco de dados (Supabase/PostgreSQL). Muitas empresas possuem dados críticos em sistemas TOTVS que precisam ser migrados ou sincronizados com aplicações modernas que utilizam Supabase como backend, mas não existiam ferramentas adequadas para essa integração específica.

### Contexto de Negócio
- Empresas que utilizam TOTVS como sistema ERP principal
- Necessidade de modernizar aplicações utilizando Supabase/PostgreSQL
- Migração gradual de sistemas legados para arquiteturas modernas
- Requisito de manter dados sincronizados entre ambos os sistemas durante transição

## Como o produto deve funcionar

### Fluxo Principal de Operação
1. **Configuração Inicial**
   - Usuário configura parâmetros de conexão com Supabase (já pré-configurados)
   - Usuário configura parâmetros de conexão com TOTVS via arquivo INI
   - Aplicação valida conexões com ambos os bancos

2. **Operação de Importação**
   - Usuário seleciona tabelas/registros para importar
   - Aplicação lê dados do TOTVS (SQL Server)
   - Aplicação processa e transforma dados conforme necessário
   - Aplicação grava dados no Supabase (PostgreSQL)
   - Aplicação registra log de operações realizadas

3. **Monitoramento e Controle**
   - Interface visual mostra progresso das operações
   - Tratamento de erros com mensagens claras para o usuário
   - Logs detalhados para auditoria e troubleshooting

### Características Essenciais
- **Confiabilidade**: Garantir integridade dos dados durante transferência
- **Performance**: Operações eficientes mesmo com grandes volumes de dados
- **Simplicidade**: Interface intuitiva que não requer conhecimento técnico avançado
- **Segurança**: Conexões seguras com SSL e tratamento adequado de credenciais
- **Flexibilidade**: Suporte a diferentes estruturas de tabelas e tipos de dados

## Experiência do Usuário

### Perfil do Usuário
- **Administradores de Sistemas**: Responsáveis pela manutenção e integração de sistemas
- **Desenvolvedores**: Precisam migrar dados entre ambientes legados e modernos
- **Analistas de TI**: Responsáveis por operações de migração e sincronização

### Jornada do Usuário
1. **Primeiro Uso**
   - Instalação simples (apenas copiar executável e dependências)
   - Configuração mínima via interface gráfica
   - Documentação clara para parâmetros de conexão

2. **Uso Contínuo**
   - Interface familiar e consistente com aplicações Windows
   - Operações intuitivas com feedback visual claro
   - Recuperação fácil de erros com mensagens descritivas

3. **Operações Avançadas**
   - Configuração de parâmetros específicos para diferentes ambientes
   - Monitoramento detalhado de operações em tempo real
   - Logs completos para análise e auditoria

### Objetivos de Experiência
- **Redução de Complexidade**: Tornar operações complexas de integração simples e acessíveis
- **Confiabilidade**: Minimizar erros e garantir consistência dos dados
- **Eficiência**: Permitir que operações demoradas sejam realizadas com mínimo esforço
- **Transparência**: Fornecer feedback claro sobre o status das operações
- **Segurança**: Garantir que dados sensíveis sejam tratados com segurança adequada

## Valor Proposto
- **Redução de Tempo**: Automatiza processos que seriam manuais e demorados
- **Redução de Erros**: Elimina falhas humanas em processos de migração de dados
- **Modernização**: Facilita transição de sistemas legados para arquiteturas modernas
- **Custo-Benefício**: Solução econômica comparada a alternativas complexas ou customizadas
- **Independência**: Não depende de serviços em nuvem de terceiros para operação
