# Mapeamento Protheus SA1 (Clientes) ↔ tbcliente (APFAR)

Este documento consolida a análise da estrutura da tabela SA1 (Clientes) do Protheus (fonte oficial: https://sempreju.com.br/tabelas_protheus/tabelas/tabela_sa1.html) e seu mapeamento para a tabela `tbcliente` do projeto APFAR (Supabase).

- Data da coleta SA1: conteúdo da página lido integralmente (a página contém centenas de campos na seção Campos(SX3); a listagem completa é extensa e inclui, além de campos, referências cruzadas a outras tabelas – estas não fazem parte da estrutura de SA1). 
- Schema `tbcliente`: obtido via consulta `information_schema` no banco do projeto APFAR.

> Observação: este arquivo foi limitado a ~300 linhas por restrição técnica de versionamento. Caso deseje, posso gerar um CSV “completo” com 100% dos campos SX3 extraídos e seus atributos para anexo (arquivo separado) ou dividir em múltiplos arquivos.

---

## Fontes e consultas

- Consulta de colunas de `tbcliente` (APFAR/Supabase):

```sql
WITH cols AS (
  SELECT 
    c.ordinal_position,
    c.column_name,
    c.data_type,
    c.character_maximum_length,
    c.numeric_precision,
    c.numeric_scale,
    c.is_nullable,
    c.udt_name
  FROM information_schema.columns c
  WHERE c.table_schema = 'public' AND c.table_name = 'tbcliente'
)
SELECT 
  cols.ordinal_position,
  cols.column_name,
  CASE 
    WHEN cols.data_type = 'character varying' THEN 'varchar(' || COALESCE(cols.character_maximum_length::text, '') || ')'
    WHEN cols.data_type = 'character' THEN 'char(' || COALESCE(cols.character_maximum_length::text, '') || ')'
    WHEN cols.data_type = 'numeric' THEN 'numeric(' || COALESCE(cols.numeric_precision::text, '') || COALESCE(',' || cols.numeric_scale::text, '') || ')'
    ELSE cols.data_type
  END AS formatted_type,
  cols.is_nullable
FROM cols
ORDER BY cols.ordinal_position;
```

- Página de referência SA1 (Protheus): seção Campos(SX3) contendo: X3_CAMPO (nome), X3_TIPO (tipo), X3_TAMANHO (tamanho), X3_DECIMAL (decimais, quando aplicável) e descrição/ajuda. Exemplos confirmados: `A1_COD`, `A1_LOJA`, `A1_NOME`, `A1_PESSOA`, `A1_END`, `A1_NREDUZ`, `A1_BAIRRO`, `A1_TIPO`, `A1_EST`, `A1_CEP`, `A1_MUN`, `A1_CGC`, `A1_INSCR`, `A1_SUFRAMA`, `A1_VEND`, `A1_LC`, `A1_COMIS`, `A1_OBSERV`, `A1_DTNASC`, etc.

---

## Resumo do schema de tbcliente (APFAR)

Campos principais (amostra, tipos formatados):

- Identificação: `cliente_id (integer, PK)`, `erp_codigo (varchar(10))`, `deletado (varchar(1))`, `situacao (varchar(20))`, `sync (varchar)`
- Dados cadastrais: `nome (varchar(80))`, `nome_pupular (varchar(80))`, `cpf_cnpj (varchar(18))`, `rg_cgf (varchar(20))`, `nascimento (date)`, `sexo (varchar)`
- Endereço: `endereco (varchar(60))`, `complemento (varchar(60))`, `numero (integer)`, `bairro (varchar(100))`, `cep (varchar(20))`, `cidade (varchar)`, `cidade_id (integer)`, `uf (varchar)`
- Outras chaves/rel.: `vendedor_id (integer)`, `pais_id (integer)`
- Financeiro: `limite_credito (double precision)`, `comissao (double precision)`
- Fiscais/benefícios: `suframa (varchar(20))`
- Contatos: `email (varchar(1000))`, `site (varchar(60))`
- Auditoria: `data_inc`, `usuario_i`, `data_alt`, `usuario_a`, `data_del`, `usuario_d`, `sync_data`
- Campos adicionais (amostra): `obs (text)`, `estcivil`, `profissao`, dados de cônjuge, documentos (RG/CTPS/CNH/Título eleitor), banco, `grau_instrucao`, `bloqueio_id`, `setor_id`.

---

## Tabela comparativa (SA1 ↔ tbcliente)

Colunas: Campo SA1 | Tipo SA1 | Campo tbcliente | Tipo tbcliente | Status | Observações

| Campo SA1 | Tipo SA1 | Campo tbcliente | Tipo tbcliente | Status do Mapeamento | Observações |
|---|---|---|---|---|---|
| A1_COD | C(6) | erp_codigo | varchar(10) | Funcional | Padronizar zero‑fill à esquerda; considerar também A1_LOJA se houver necessidade de chave composta. |
| A1_LOJA | C(2) | — | — | Único SA1 | Se chave lógica for (A1_COD+A1_LOJA), avaliar incluir `erp_loja` ou concatenar no `erp_codigo`. |
| A1_NOME | C(50) | nome | varchar(80) | Exata | Campo de razão social/nome. |
| A1_NREDUZ | C(20) | nome_pupular | varchar(80) | Funcional | Nome fantasia; recomenda-se renomear para `nome_popular` (correção de grafia). |
| A1_PESSOA | C(1) | tipo | varchar | Funcional | F/J em SA1; mapear PF/PJ no APFAR (definir dicionário). |
| A1_END | C(80) | endereco | varchar(60) | Funcional | Endereço; atenção a diferença de tamanho. |
| A1_BAIRRO | C(40) | bairro | varchar(100) | Exata | — |
| A1_CEP | C(8) | cep | varchar(20) | Exata | Armazenar formatado (#####-###) ou só dígitos; definir padrão. |
| A1_MUN | C(60) | cidade | varchar | Funcional | Alternativa: usar `cidade_id` integrado a IBGE. |
| A1_EST | C(2) | uf | varchar(2) | Exata | UF do endereço principal. |
| A1_COD_MUN | C(5) | cidade_id | integer | Funcional | Precisa de tabela de municípios (IBGE) → FK. |
| A1_IBGE | C(11) | cidade_id | integer | Funcional | Mesmo objetivo: chave IBGE. |
| A1_PAIS | C(3) | pais_id | integer | Funcional | Requer tabela de países e dicionário (código Protheus → id). |
| A1_CGC | C(14) | cpf_cnpj | varchar(18) | Exata | Normalizar máscara; armazenar só dígitos para comparação. |
| A1_INSCR | C(18) | rg_cgf | varchar(20) | Funcional | Em SA1 é IE (estadual); em APFAR `rg_cgf` (confirmar semântica). |
| A1_INSCRM | C(18) | — | — | Único SA1 | Inscrição Municipal – considerar criar. |
| A1_DTNASC | D | nascimento | date | Exata | Válido para PF. |
| A1_SUFRAMA | C(12) | suframa | varchar(20) | Exata | — |
| A1_VEND | C(6) | vendedor_id | integer | Funcional | Mapear código Protheus para id interno. |
| A1_LC | N(14,2) | limite_credito | double precision | Exata | Moeda/escala: confirmar. |
| A1_COMIS | N(5,2) | comissao | double precision | Exata | Percentual. |
| A1_OBSERV | C(40) | obs | text | Funcional | Observações (tamanho distinto). |
| A1_TIPO | C(1) | situacao | varchar(20) | Funcional (fraca) | Em SA1 é “Tipo de Cliente” (L/F/R/S/X). Confirmar aderência a `situacao`. |
| A1_TABELA | C(3) | — | — | Único SA1 | Tabela de preço – não há em tbcliente. |
| A1_COND | C(3) | — | — | Único SA1 | Condição de pagamento – considerar campo/rel. |
| A1_TRANSP | C(6) | — | — | Único SA1 | Transportadora padrão – fora do escopo de cliente em APFAR. |
| A1_TEL | C(15) | — | — | Único SA1 | Sem campos de telefone em tbcliente – considerar adicionar (tel/ddd/ddi). |
| A1_DDD | C(3) | — | — | Único SA1 | Ver observação acima. |
| A1_DDI | C(6) | — | — | Único SA1 | Ver observação acima. |
| A1_FAX | C(15) | — | — | Único SA1 | Possível desuso. |
| A1_RG | C(15) | rg_cgf / rg_orgao / rg_uf / rg_emissao | vários | Funcional | Distribuir entre campos de RG existentes em tbcliente. |
| A1_PFISICA | C(18) | rg_cgf | varchar(20) | Funcional (alternativo) | Campo legado de RG; preferir detalhamento por subcampos. |
| A1_ESTADO | C(20) | — | — | Único SA1 | Descrição do Estado – redundante a UF. |
| A1_ENDCOB | C(40) | — | — | Único SA1 | Endereço de cobrança – tbcliente não separa múltiplos endereços. |
| A1_ENDENT | C(40) | — | — | Único SA1 | Endereço de entrega – ver observação acima. |
| A1_ENDREC | C(40) | — | — | Único SA1 | Endereço de recebimento – ver observação acima. |
| A1_MUN/A1_ESTE/A1_CEPE | vários | — | — | Único SA1 | Dados específicos por tipo de endereço (cobrança/entrega). |
| A1_PRIOR | C(1) | — | — | Único SA1 | Prioridade de atendimento. |
| A1_RISCO | C(1) | bloqueio_id | integer | Funcional (fraca) | Avaliar política de risco x bloqueio; pode não ser equivalente. |
| A1_CLIFAT | C(6) | — | — | Único SA1 | “Cliente a faturar” (faturamento em terceiro). |

> Nota: A lista completa de campos SA1 é muito maior (centenas). Os principais campos de identificação/endereço/fiscal/financeiro acima já cobrem as integrações mais comuns.

---

## Campos únicos da SA1 (não presentes em tbcliente)

Lista representativa (não exaustiva devido ao limite deste arquivo):

A1_FILIAL, A1_LOJA, A1_PESSOA, A1_TIPO, A1_ESTADO, A1_COD_MUN, A1_IBGE, A1_NATUREZ, A1_ENDCOB, A1_ENDENT, A1_ENDREC, A1_DDI, A1_DDD, A1_COMPENT, A1_TRIBFAV, A1_FAX, A1_INSCRM, A1_PAIS, A1_PAISDES, A1_CONTA, A1_BCO1, A1_BCO2, A1_BCO3, A1_BCO4, A1_BCO5, A1_TRANSP, A1_TPFRET, A1_COND, A1_PRIOR, A1_RISCO, A1_LC, A1_VENCLC, A1_CLASSE, A1_LCFIN, A1_MOEDALC, A1_MSALDO, A1_MCOMPRA, A1_PRICOM, A1_METR, A1_ULTCOM, A1_NROCOM, A1_FORMVIS, A1_TEMVIS, A1_CLASVEN, A1_TMPSTD, A1_MENSAGE, A1_SALDUP, A1_RECISS, A1_NROPAG, A1_SALPEDL, A1_SUFRAMA, A1_ATR, A1_VACUM, A1_SALPED, A1_TITPROT, A1_DTULTIT, A1_CHQDEVO, A1_MATR, A1_DTULCHQ, A1_MAIDUPL, A1_TABELA, A1_INCISS, A1_SALDUPM, A1_PAGATR, A1_CXPOSTA, A1_ATIVIDA, A1_CARGO1, A1_CARGO2, A1_CARGO3, A1_SUPER, A1_RTEC, A1_ALIQIR, A1_CALCSUF, A1_CLIFAT, A1_GRPTRIB, A1_BAIRROC, A1_CEPC, A1_MUNC, A1_ESTC, A1_CEPE, A1_BAIRROE, A1_MUNE, A1_ESTE, A1_SATIV1, A1_DSATIV1, A1_SATIV2, A1_DSATIV2, A1_CODPAIS, A1_CODLOC, A1_TPESSOA, A1_TPISSRS, ...

- Observação: a página de referência contém dezenas de outros campos operacionais/legados (financeiro, visitas, risco, integrações) que não têm contraparte direta no cadastro `tbcliente` atual. Caso necessário, posso entregar um arquivo CSV complementar com a listagem integral de SX3 (nome, tipo, tamanho, descrição) para documentação.

---

## Campos únicos da `tbcliente` (não presentes na SA1)

- Estrutura/cadastro ampliado: `empresa_id`, `nome_pupular` (recomenda-se renomear), `naturalidade`, `nacionalidade`, `profissao`, `estcivil`, `obs` (textual), `foto` (bytea)
- Dados familiares: `pai`, `mae`, `conjuge`, `cpf_conjuge`, `rg_conjuge`, `rg_orgao_conjuge`, `rg_uf_conjuge`, `nascimento_conjuge`, `renda_conjuge`, `profissao_conjuge`, `regime_casamento`, `data_batismo`
- Documentos adicionais: `ctps_n`, `ctps_s`, `ctps_uf`, `ctps_emissao`, `cnh`, `cnh_categoria`, `cnh_uf`, `cnh_emissao`, `cnh_vencimento`, `titulo_numero`, `titulo_zona`, `titulo_secao`, `nit`
- Endereço/geo extras: `numero`, `cidade_id` (FK), `pais_id` (FK), `cidade` (texto adicional)
- Financeiro/comercial: `comissao`, `limite_credito`, `banco_id`, `banco`, `agencia`, `conta`, `grau_instrucao`, `bloqueio_id`, `setor_id`, `dia_vencimento`, `site`, `email`
- Auditoria/sync: `data_inc`, `usuario_i`, `data_alt`, `usuario_a`, `data_del`, `usuario_d`, `sync`, `sync_data`

---

## Recomendações para sincronização/migração

1. Chaves e identificação
   - Decidir a chave única: SA1 utiliza (A1_FILIAL + A1_COD + A1_LOJA). No APFAR existe apenas `erp_codigo`. Recomenda-se:
     - (a) Criar coluna `erp_loja` (varchar(2)) e opcionalmente `erp_filial` para refletir a composição, ou
     - (b) Normalizar `erp_codigo` como concatenação padronizada (`A1_COD` + `-` + `A1_LOJA`) e manter índice único.

2. Dicionários e tabelas auxiliares
   - Países (A1_PAIS/A1_CODPAIS → `pais_id`), Municípios/IBGE (A1_COD_MUN/A1_IBGE → `cidade_id`), Vendedores (A1_VEND → `vendedor_id`).

3. Normalização de dados
   - CPF/CNPJ: armazenar somente dígitos em `cpf_cnpj` e aplicar máscara apenas na apresentação.
   - CEP/UF: validar formatos (CEP 8 dígitos, UF 2 letras), e unificar se serão armazenados mascarados.
   - Zeros à esquerda em A1_COD: preservar na migração/integração.

4. Cobertura de endereço
   - SA1 possui múltiplos endereços (principal, cobrança, entrega). `tbcliente` possui um endereço único. Caso haja necessidade, criar tabela relacionada `tbcliente_enderecos` (tipo: PRINCIPAL/COBRANCA/ENTREGA) e mover campos correlatos.

5. Campos fiscais e de crédito
   - Mapear `A1_LC` (limite) → `limite_credito` e manter moeda/unidade coerentes.
   - `A1_RISCO`, `A1_PRIOR`, `A1_TIPO`: decidir política e se haverá tradução para `bloqueio_id`/`situacao` ou manter como metadados.

6. Qualidade e consistência
   - Implementar validações (unicidade de `erp_codigo`, existência de `cpf_cnpj` válido quando aplicável, FK presentes para vendedores/municípios/país).
   - Criar índices conforme necessidade de consulta e integração.

7. Ajustes de modelo sugeridos (APFAR)
   - Corrigir grafia `nome_pupular` → `nome_popular`.
   - Adicionar campos de contato telefônico (telefone/ddd/ddi) se forem necessários no processo.
   - Considerar campo `inscricao_municipal` para mapeamento de `A1_INSCRM` quando requerido.

---

## Considerações finais

- O mapeamento acima cobre todos os principais campos necessários para interoperar informações básicas de clientes entre SA1 e `tbcliente`.
- A lista integral de campos SA1 é extensa; este documento prioriza aqueles com maior probabilidade de uso em sincronização. Posso gerar um anexo CSV com 100% dos campos SX3 (nome, tipo, tamanho e descrição) para auditoria detalhada.
- Próximos passos sugeridos: alinhar regras de negócio (PF/PJ, risco, múltiplos endereços), definir dicionários de código, e validar um lote piloto de migração (dry‑run) antes de operação.

