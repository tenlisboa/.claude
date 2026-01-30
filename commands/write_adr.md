# Write ADR (Architecture Decision Record)

Create an Architecture Decision Record (ADR) following the structure and best practices from Jhony Walker's guide.

**CRITICAL: The ADR document MUST be written entirely in Brazilian Portuguese (PT_BR).**

## Instructions

When the user requests an ADR, gather the necessary context:
1. What architectural decision needs to be documented?
2. What is the context/problem being addressed?
3. What alternatives were considered?
4. What is the chosen solution and why?

If the user provides sufficient context, proceed directly. Otherwise, ask clarifying questions.

## ADR Template Structure

Use this exact structure for all ADRs:

```markdown
# ADR-[NUMBER]: [Título da Decisão]

**Número do ADR:** [NUMBER]
**Título:** [Título descritivo da decisão]
**Data:** YYYY-MM-DD
**Responsável:** [Nome do responsável]
**Status:** [Proposta | Aceito | Depreciado | Substituído por ADR-XXX]

---

## Contexto

Descreva a situação atual e as circunstâncias que levaram à necessidade desta decisão. Inclua informações sobre o projeto, requisitos técnicos, restrições e forças em jogo (técnicas, políticas, sociais, do projeto). Use linguagem neutra, descrevendo fatos objetivamente.

## Decisão

Declare claramente a decisão tomada. Especifique a tecnologia, padrão ou abordagem escolhida.

## Justificativa

Explique detalhadamente POR QUE esta decisão foi escolhida. Liste os motivos principais em tópicos:

- **[Motivo 1]:** Explicação detalhada
- **[Motivo 2]:** Explicação detalhada
- **[Motivo 3]:** Explicação detalhada

## Alternativas Consideradas

Liste as alternativas que foram avaliadas antes da decisão final:

### [Alternativa 1]
Descrição da alternativa e por que não foi escolhida.

### [Alternativa 2]
Descrição da alternativa e por que não foi escolhida.

## Consequências

Descreva os impactos da decisão tomada:

### Positivas
- Benefício 1
- Benefício 2

### Negativas
- Trade-off ou risco 1
- Trade-off ou risco 2

### Neutras
- Impacto que requer adaptação mas não é claramente positivo ou negativo

## Referências

- [Título do recurso](URL)
- [Documentação relevante](URL)
```

## Naming Convention

ADR files MUST be named: `adr-[NUMBER]-[kebab-case-titulo].md`

Examples:
- `adr-001-escolha-banco-dados.md`
- `adr-002-adocao-microsservicos.md`
- `adr-003-estrategia-autenticacao.md`

## Status Values

- **Proposta** - Decisão proposta, aguardando aprovação
- **Aceito** - Decisão aceita e em vigor
- **Depreciado** - Decisão não é mais relevante
- **Substituído** - Decisão foi substituída por uma ADR mais recente (indicar qual)

## Best Practices (from Jhony Walker's guide)

1. **Padronização** - Mantenha formato consistente em todas as ADRs
2. **Número e Rastreabilidade** - Atribua número único a cada ADR
3. **Versionamento** - Mantenha versão clara e atualizada
4. **Inclusão de Justificativa** - Explique o PORQUÊ, não apenas O QUÊ
5. **Manutenção Regular** - Revise e atualize periodicamente
6. **Compartilhamento e Acesso** - Garanta fácil acesso para toda a equipe

## Output Location

Save ADRs in the project's `thoughts/adrs/` directory (create if it doesn't exist).

Before creating, check existing ADRs to determine the next sequential number.

$ARGUMENTS
