# /nexus:execute - Execute Workflow

Invoca o Nexus orchestrator para coordenar workflows entre Superpowers + ALD + MCPs.

**Argumentos fornecidos pelo usuário**: {{ARGS}}

---

## Instruções para Claude

Quando este comando é invocado, você DEVE:

1. **Usar a ferramenta Skill** para invocar a skill `nexus`
2. **Passar os argumentos** exatamente como fornecidos em {{ARGS}}
3. **Seguir o workflow nexus** conforme definido em `skills/nexus/SKILL.md`

Exemplo:
```
Usuário digita: /nexus:execute implement checkout with Stripe

Você deve:
1. Invocar Skill tool com comando: "nexus"
2. A skill nexus então:
   - Analisa intent (feature-development, complexity: large)
   - Sugere workflow (feature-full.yml)
   - Pede confirmação do usuário
   - Coordena plugins (Superpowers + ALD)
   - Executa fases do workflow
   - Retorna resultado unificado
```

**Importante**: A skill nexus gerencia TODA a lógica de orquestração. Você só precisa invocá-la.

---

## Localização da Skill Nexus

- **Skill path**: `skills/nexus/SKILL.md`
- **Workflows**: `skills/nexus/workflows/*.yml`
- **Documentação**: `skills/nexus/README.md`

---

## Exemplos de Uso

```bash
# Feature development
/nexus:execute implement checkout with Stripe

# Bugfix
/nexus:execute fix cart total calculation

# Research/Spike
/nexus:execute research GraphQL vs REST

# Migration
/nexus:execute add user_preferences table

# Performance optimization
/nexus:execute optimize page load speed

# Documentation
/nexus:execute write API documentation for auth
```

---

## Workflows Disponíveis

Ver `skills/nexus/workflows/` para lista completa de 12 workflows:
- feature-full, feature-quick, feature-tdd
- bugfix, hotfix
- refactor, code-review
- spike, migration, documentation, performance

---

**Agora invoque a skill nexus com a tarefa do usuário**: {{ARGS}}
