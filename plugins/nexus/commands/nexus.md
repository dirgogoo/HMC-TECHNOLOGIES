# /nexus - Master Workflow Orchestrator

Invoke the Nexus skill to coordinate Superpowers + ALD workflows.

**Arguments provided by user**: {{ARGS}}

---

## Instructions for Claude

When this command is invoked, you MUST:

1. **Use the Skill tool** to invoke the `nexus` skill
2. **Pass the arguments** exactly as provided by user in {{ARGS}}
3. **Follow the nexus workflow** as defined in `~/.claude/skills/nexus/SKILL.md`

Example:
```
User types: /nexus implement checkout with Stripe

You should:
1. Invoke Skill tool with command: "nexus"
2. The nexus skill will then:
   - Analyze intent (feature-development, complexity: large)
   - Suggest workflow (feature-full.yml)
   - Ask user for confirmation
   - Coordinate plugins (Superpowers + ALD)
   - Execute phases
   - Return unified report
```

**Important**: The nexus skill handles ALL the orchestration logic. You just need to invoke it with the Skill tool.

---

## Nexus Skill Location

- **Skill path**: `~/.claude/skills/nexus/SKILL.md`
- **Workflows**: `~/.claude/skills/nexus/workflows/*.yml`
- **Documentation**: `~/.claude/skills/nexus/README.md`

---

**Now invoke the nexus skill with the user's task**: {{ARGS}}
