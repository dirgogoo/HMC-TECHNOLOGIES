# Nexus - Master Workflow Orchestrator

Invoke the Nexus skill to coordinate Superpowers + ALD workflows.

*Arguments provided by user*: {{ARGS}}

---

## Instructions for Claude

When this command is invoked, you MUST follow these steps EXACTLY:

---

### ⚠️ STEP 0 - MANDATORY (DO NOT SKIP!)

**Read the complete SKILL.md file:**
```
Read: ~/.claude/skills/nexus/SKILL.md
```

This file contains the complete workflow protocol. You MUST read it before proceeding.

---

### 📋 STEP 1-5 - WORKFLOW EXECUTION

After reading SKILL.md, follow **Steps 1-5** defined in that file:

**Step 1: Intent Detection**
- Analyze task: "{{ARGS}}"
- Identify: intent, complexity, keywords
- Output JSON with analysis

**Step 2: Workflow Selection**
- Use selection logic from SKILL.md
- **Read the selected workflow YAML file** (e.g., feature-full.yml, feature-quick.yml)
- Parse ALL phases from the YAML

**Step 3: Present Workflow to User**
- Show workflow name and estimated duration
- **List ALL phases** from the YAML (do NOT omit any!)
- Ask user for confirmation before executing

**Step 4: Execute Workflow Phases**
- After user confirms, execute each phase sequentially
- Follow the YAML exactly - do NOT skip phases
- Invoke appropriate plugins for each phase

**Step 5: Aggregate Results**
- Present unified execution report
- Include all deliverables and metrics

---

### ⚠️ CRITICAL RULES

**NEVER:**
- ❌ Skip Step 0 (reading SKILL.md)
- ❌ Skip Step 2 (reading workflow YAML)
- ❌ Create a custom plan (use YAML phases as-is)
- ❌ Omit ALD phases (policies, tester, code-reviewer, curator)
- ❌ Assume you know the workflow without reading it

**ALWAYS:**
- ✅ Read SKILL.md first (Step 0)
- ✅ Read the workflow YAML file (Step 2)
- ✅ Show ALL phases to user (Step 3)
- ✅ Wait for user confirmation before executing
- ✅ Follow YAML phases exactly as defined

---

### 📝 Example

User types: `/nexus implement checkout with Stripe`

You should:
1. ✅ Read ~/.claude/skills/nexus/SKILL.md
2. ✅ Detect: intent=feature-development, complexity=large
3. ✅ Read ~/.claude/skills/nexus/workflows/feature-full.yml
4. ✅ Present ALL 9-10 phases to user (brainstorm, plan, load-context, sprint-check, find-policies, tdd-cycle, defense-in-depth, validate, review, learn)
5. ✅ Wait for confirmation
6. ✅ Execute phases sequentially
7. ✅ Present unified report

---

## Nexus Skill Location

- *Skill path*: ~/.claude/skills/nexus/SKILL.md
- *Workflows*: ~/.claude/skills/nexus/workflows/*.yml
- *Documentation*: ~/.claude/skills/nexus/README.md

---

ARGUMENTS: {{ARGS}}
