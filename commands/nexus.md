# /nexus - Nexus Orchestrator

Invokes the Nexus skill to coordinate intelligent workflows.

**User arguments**: {{ARGS}}

---

## Instructions for Claude

When this command is invoked:

1. **Use the Skill tool** to invoke the `nexus` skill
2. **Pass {{ARGS}}** exactly as provided by the user

Example:
```
User: /nexus implement checkout with Stripe

You:
- Invoke Skill tool with command: "nexus"
- Nexus skill analyzes task and selects appropriate workflow
```

---

## Nexus Skill Location

- **Path**: `skills/nexus/SKILL.md`
- **Workflows**: `skills/nexus/workflows/*.yml`

---

**Now invoke the nexus skill**: {{ARGS}}
