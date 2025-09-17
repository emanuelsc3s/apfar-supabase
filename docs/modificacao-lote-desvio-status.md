# Modificação da Lógica de Importação de Lotes com Desvios

## Resumo das Alterações

Foi implementada uma nova lógica no método `btn_ImportarLoteDesvioClick` para gerenciar adequadamente o campo `D7_YSICCQ` na tabela TOTVS baseado no status de todos os desvios de um lote.

## Problema Identificado

Anteriormente, a aplicação não considerava o status individual dos desvios ao atualizar o campo `D7_YSICCQ`. Isso causava problemas quando:

- Um lote possuía múltiplos desvios
- Alguns desvios estavam concluídos e outros ainda pendentes
- O sistema não diferenciava entre lotes totalmente resolvidos e lotes com pendências

## Solução Implementada

### 1. Modificação da Query SICFAR

**Antes:**
```sql
SELECT
  dp.lote,
  d.status,
  LIST(DISTINCT CAST(dp.desvio_id AS VARCHAR(20)), ',') AS desvios_ids
FROM tbdesvio_produto dp 
JOIN tbdesvio d ON d.desvio_id = dp.desvio_id 
WHERE dp.deletado = 'N' 
  AND d.deletado = 'N' 
  AND dp.lote IS NOT NULL 
GROUP BY dp.lote, d.status
```

**Depois:**
```sql
SELECT
  dp.lote,
  CASE
    WHEN COUNT(CASE WHEN d.status NOT IN ('Concluído', 'Rejeitado - GQT', 'Cancelado') THEN 1 END) = 0 THEN 'TODOS_CONCLUIDOS'
    ELSE 'PENDENTE'
  END AS status_lote,
  LIST(DISTINCT CAST(dp.desvio_id AS VARCHAR(20)), ',') AS desvios_ids,
  LIST(DISTINCT d.status, ',') AS status_list
FROM tbdesvio_produto dp
JOIN tbdesvio d ON d.desvio_id = dp.desvio_id
WHERE dp.deletado = 'N'
  AND d.deletado = 'N'
  AND dp.lote IS NOT NULL
GROUP BY dp.lote
```

### 2. Lógica Condicional de Update

A nova implementação verifica o campo `status_lote` para decidir como atualizar o TOTVS:

#### Quando TODOS os desvios estão "Concluído":
```sql
UPDATE SD7010 
SET D7_YSICCQ = '' 
WHERE D_E_L_E_T_ = '' 
  AND D7_LOTECTL = :pLote
```

#### Quando há desvios pendentes:
```sql
UPDATE SD7010 
SET D7_YSICCQ = :pDesvioId 
WHERE D_E_L_E_T_ = '' 
  AND D7_LOTECTL = :pLote
```

## Status de Desvios Considerados

A lógica considera os seguintes status possíveis:

- **Aprovado Parcial** - Pendente
- **Aprovado** - Pendente
- **Reprovado** - Pendente
- **Aberto** - Pendente
- **Aceito - GQT** - Pendente
- **Rejeitado - GQT** - ✅ Encerrado
- **Concluído** - ✅ Encerrado
- **Cancelado** - ✅ Encerrado

Desvios com status "Concluído", "Rejeitado - GQT" ou "Cancelado" são considerados encerrados.

## Melhorias na Interface

- O feedback visual agora mostra o status do lote: `[TODOS_CONCLUIDOS]` ou `[PENDENTE]`
- Contagem de registros otimizada usando `COUNT(DISTINCT dp.lote)`
- Correção do bug na linha 604 onde estava sendo usado campo inexistente `'desvios'`

## Impacto no Negócio

### Antes da Modificação:
- Lotes com múltiplos desvios podiam ser marcados como "liberados" mesmo com pendências
- Falta de controle granular sobre o status real do lote
- Possível inconsistência entre dados SICFAR e TOTVS

### Após a Modificação:
- ✅ Lotes só são "liberados" (D7_YSICCQ vazio) quando TODOS os desvios estão concluídos
- ✅ Controle preciso do status de cada lote baseado em seus desvios
- ✅ Sincronização consistente entre SICFAR e TOTVS
- ✅ Melhor rastreabilidade e controle de qualidade

## Arquivos Modificados

- `Unit_ApfarSupabase.pas` - Método `btn_ImportarLoteDesvioClick`

## Testes Recomendados

1. **Teste com lote com todos desvios concluídos:**
   - Verificar se `D7_YSICCQ` fica vazio

2. **Teste com lote com desvios mistos:**
   - Verificar se `D7_YSICCQ` mantém o ID do primeiro desvio

3. **Teste com lote com todos desvios pendentes:**
   - Verificar se `D7_YSICCQ` é preenchido normalmente

4. **Teste de performance:**
   - Verificar se a nova query não impacta significativamente o tempo de execução