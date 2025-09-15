# Campos Não Mapeados - tbpessoas (Firebird) → tbcliente (Supabase)

## Introdução

Este documento documenta todos os campos existentes na tabela `tbpessoas` do banco de dados Firebird (TOTVS/SICFAR) que não possuem correspondência direta na tabela `tbcliente` do Supabase (PostgreSQL).

A tabela `tbpessoas` do Firebird contém 120+ campos, enquanto a tabela `tbcliente` do Supabase possui 89 campos. Esta diferença reflete uma abordagem mais simplificada no sistema Supabase, focando nos dados essenciais do cliente.

## Campos Não Mapeados por Categoria

### 1. Endereços Adicionais

Campos relacionados a endereços de entrega que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `ENT_NOME` | VARCHAR(60) | Nome do endereço de entrega | |
| `ENT_ENDERECO` | VARCHAR(60) | Endereço de entrega | |
| `ENT_BAIRRO` | VARCHAR(30) | Bairro de entrega | |
| `ENT_CIDADE` | VARCHAR(30) | Cidade de entrega | |
| `ENT_UF` | VARCHAR(2) | UF de entrega | |
| `ENT_FONE` | INTEGER | Telefone de entrega | |

**Sugestão futura:** Criar tabela relacionada `tbcliente_enderecos` com tipo de endereço (principal, entrega, cobrança).

### 2. Telefones Múltiplos

Campos para telefones adicionais que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `FONE_01` | VARCHAR(20) | Telefone adicional 1 | |
| `FONE_02` | VARCHAR(20) | Telefone adicional 2 | |
| `FONE_03` | VARCHAR(20) | Telefone adicional 3 | |
| `FONE_04` | VARCHAR(20) | Telefone adicional 4 | |
| `WHATSAPP` | VARCHAR(20) | Número de WhatsApp | |

**Sugestão futura:** Criar tabela relacionada `tbcliente_telefones` com tipo de telefone (residencial, comercial, celular, whatsapp).

### 3. Referências Comerciais

Campos para referências comerciais que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `REF_01NOME` | VARCHAR(60) | Nome da referência 1 | |
| `REF_02NOME` | VARCHAR(60) | Nome da referência 2 | |
| `REF_03NOME` | VARCHAR(60) | Nome da referência 3 | |
| `REF_01FONE` | VARCHAR(20) | Telefone da referência 1 | |
| `REF_02FONE` | VARCHAR(20) | Telefone da referência 2 | |
| `REF_03FONE` | VARCHAR(20) | Telefone da referência 3 | |

**Sugestão futura:** Criar tabela relacionada `tbcliente_referencias`.

### 4. Endereço de Cobrança

Campos para endereço de cobrança que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `COB_ENDERECO` | VARCHAR(60) | Endereço de cobrança | |
| `COB_BAIRRO` | VARCHAR(30) | Bairro de cobrança | |
| `COB_CIDADE` | VARCHAR(30) | Cidade de cobrança | |
| `COB_UF` | VARCHAR(2) | UF de cobrança | |
| `COB_CEP` | VARCHAR(20) | CEP de cobrança | |

**Sugestão futura:** Integrar com tabela `tbcliente_enderecos` sugerida anteriormente.

### 5. Documentos Profissionais

Campos de documentos profissionais que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `CTPS_N` | VARCHAR(20) | Número da CTPS | Já existe `ctps_n` no Supabase |
| `CTPS_S` | VARCHAR(10) | Série da CTPS | Já existe `ctps_s` no Supabase |
| `CTPS_UF` | CHAR(2) | UF da CTPS | Já existe `ctps_uf` no Supabase |
| `CTPS_EMISSAO` | DATE | Emissão da CTPS | Já existe `ctps_emissao` no Supabase |
| `NIT` | VARCHAR(30) | NIT/PIS | Já existe `nit` no Supabase |
| `PIS` | VARCHAR(15) | PIS | Duplicado do campo NIT |

**Observação:** Alguns campos já existem no Supabase, mas estão listados aqui para referência completa.

### 6. Título de Eleitor

Campos de título de eleitor que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `TITULO_NUMERO` | VARCHAR(20) | Número do título | |
| `TITULO_ZONA` | VARCHAR(10) | Zona eleitoral | |
| `TITULO_SECAO` | VARCHAR(10) | Seção eleitoral | |

**Sugestão futura:** Criar tabela relacionada `tbcliente_documentos` com tipo de documento.

### 7. Campos de Contabilidade

Campos relacionados à contabilidade que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `CONTABIL` | VARCHAR(1) | Indicador de contabilidade | |
| `CONTATORH_ID` | INTEGER | ID do Contador RH | |
| `CONTATORH` | VARCHAR(80) | Nome do Contador RH | |

### 8. Dados Bancários Adicionais

Campos bancários adicionais que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `SALARIO` | NUMERIC(15,2) | Salário | Campo adicional além de `limite_credito` |

### 9. Departamentos/Setores

Campos de departamento que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `DEPARTAMENTO_ID` | INTEGER | ID do departamento | |
| `DEPARTAMENTO` | VARCHAR(60) | Nome do departamento | |
| `DEPARTAMENTO_ID_SEG` | INTEGER | ID do departamento secundário | |
| `DEPARTAMENTO_SEG` | VARCHAR(30) | Nome do departamento secundário | |

### 10. Compras e Funcionários

Campos de compras e funcionários que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `COMPRAS` | INTEGER | Número de compras | |
| `FUNCIONARIOS` | INTEGER | Número de funcionários | |

### 11. Datas Específicas

Campos de datas específicas que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `DATACADASTRO` | DATE | Data de cadastro | |
| `ALTERADO` | TIMESTAMP | Data de alteração | |
| `DATA_CONVERSAO` | DATE | Data de conversão | |
| `DATA_MEMBRO` | DATE | Data de membro | |
| `DATA_AFASTADO` | DATE | Data de afastamento | |
| `DATA_EXAME` | DATE | Data de exame | |
| `PROXIMO_EXAME` | DATE | Próximo exame | |

### 12. Veículos/Transporte

Campos relacionados a veículos e transporte que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `TIPO_TRANSP` | VARCHAR(1) | Tipo de transporte | |
| `CODIGO_ANTT` | VARCHAR(20) | Código ANTT | |

### 13. Recibos e Contratos

Campos de recibos e contratos que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `REC_CONTRATO` | VARCHAR(1) | Recibo de contrato | |
| `REC_CONTRATO_DATA` | DATE | Data do recibo de contrato | |
| `REC_DIMOB` | VARCHAR(1) | Recibo DIMOB | |
| `REC_DIMOB_DATA` | DATE | Data do recibo DIMOB | |

### 14. Contribuição

Campos relacionados a contribuição que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `VALOR_CONTRIBUICAO` | NUMERIC(15,2) | Valor de contribuição | |
| `CAPTADOR` | CHAR(1) | Indicador de captador | |
| `CONTRIBUINTE` | VARCHAR(1) | Indicador de contribuinte | |

### 15. Deficiência

Campos relacionados a deficiência que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `DEFICIENCIA` | VARCHAR(3) | Indicador de deficiência | |
| `TIPO_DEFICIENCIA` | VARCHAR(40) | Tipo de deficiência | |

### 16. Contrato de Trabalho

Campos de contrato de trabalho que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `CONTRATO_EXPERIENCIA` | INTEGER | Contrato de experiência | |
| `APRENDIZ` | VARCHAR(3) | Indicador de aprendiz | |
| `PRIMEIRO_EMPREGO` | VARCHAR(3) | Primeiro emprego | |

### 17. OPF e Outros

Campos diversos que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `OPF` | VARCHAR(6) | OPF | |
| `OPF_DESCRICAO` | VARCHAR(30) | Descrição OPF | |
| `MES_VENCIMENTO` | VARCHAR(10) | Mês de vencimento | |
| `DIA_FATURA` | INTEGER | Dia de fatura | |

### 18. Sistema/Controle

Campos de sistema e controle que não existem no Supabase:

| Campo Firebird | Tipo | Descrição | Observações |
|----------------|------|-----------|-------------|
| `IDSOFT` | INTEGER | ID do software | |
| `REPLICADO` | CHAR(1) | Indicador de replicação | |
| `ID_OLD` | INTEGER | ID antigo | |
| `RECNO` | INTEGER | Número de registro | |

## Priorização de Implementação Futura

### Alta Prioridade
1. **Telefones múltiplos** - Essencial para comunicação com clientes
2. **Endereços adicionais** - Importante para entrega e cobrança
3. **Referências comerciais** - Útil para análise de crédito

### Média Prioridade
1. **Documentos profissionais** - Importante para clientes PJ
2. **Título de eleitor** - Necessário para algumas operações
3. **Departamentos/Setores** - Útil para organização interna

### Baixa Prioridade
1. **Campos de sistema** - Apenas para controle interno
2. **Campos específicos de processos** - Muito específicos do negócio
3. **Campos duplicados** - Já existem em outras formas

## Estratégia de Implementação

### Fase 1: Dados Essenciais
- Implementar tabelas relacionadas para telefones e endereços
- Manter compatibilidade com o sistema atual

### Fase 2: Documentos Adicionais
- Implementar tabela para documentos diversos
- Incluir integração com validação de documentos

### Fase 3: Dados Complementares
- Implementar campos de referências comerciais
- Adicionar campos específicos do negócio

## Conclusão

A diferença entre as estruturas das tabelas reflete diferentes abordagens de design:
- **Firebird/TOTVS**: Sistema legado com campos abrangentes para todos os cenários
- **Supabase**: Sistema moderno com abordagem simplificada e focada nos dados essenciais

A documentação acima serve como guia para futuras implementações, permitindo a evolução gradual do sistema Supabase para incluir funcionalidades adicionais conforme necessário.
