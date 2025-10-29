---
name: nexus
description: Master workflow orchestrator that coordinates multiple AI systems (Superpowers, ALD, future plugins). Automatically detects task intent, selects optimal workflow, and coordinates execution across registered plugins. Use with '/nexus [task]' for intelligent workflow management.
---

# Nexus - Master Workflow Orchestrator

This skill orchestrates complex development workflows by coordinating multiple AI systems (Superpowers, ALD, and future plugins) to deliver optimal development experience.

## When to Invoke

**Automatically invoke this skill when:**
- User types `/nexus [task description]`
- Complex feature development requiring multiple phases
- Need to coordinate Superpowers + ALD workflows
- Task requires brainstorming → planning → execution → validation cycle

## Workflow: How to Execute

When this skill is invoked with a task, follow these steps:

### Step 1: Intent Detection

Analyze user's task to understand intent and complexity.

**Analyze these signals:**

1. **Keywords** (what verbs/actions?)
   - "implement", "create", "build" → feature-development
   - "fix", "debug", "resolve" → bugfix
   - "refactor", "improve", "optimize" → refactor
   - "review", "check", "validate" → code-review
   - "research", "spike", "investigate" → spike
   - "migrate", "database", "schema" → migration
   - "document", "readme", "api docs" → documentation
   - "performance", "slow", "optimize" → performance
   - "hotfix", "emergency", "urgent" → hotfix

2. **Complexity** (how big is this?)
   - **small**: 1-2 files, < 100 lines, simple change
   - **medium**: 3-5 files, new component/endpoint
   - **large**: Feature with multiple components, complex logic

3. **Context** (what's the conversation history?)
   - Following existing plan? → execution mode
   - Fresh request? → planning mode
   - Reviewing completed work? → review mode

**Output**:
```json
{
  "intent": "feature-development",
  "complexity": "large",
  "keywords": ["implement", "checkout", "Stripe"]
}
```

---

### Step 2: Workflow Selection

Based on detected intent and complexity, select the most appropriate workflow.

**Selection Logic:**

```
IF intent === "hotfix" OR keywords include "emergency", "urgent", "critical"
  → LOAD workflows/hotfix.yml

ELSE IF intent === "review" OR keywords include "review", "check"
  → LOAD workflows/code-review.yml

ELSE IF intent === "bugfix" OR keywords include "fix", "bug"
  → LOAD workflows/bugfix.yml

ELSE IF intent === "refactor" OR keywords include "refactor", "improve"
  → LOAD workflows/refactor.yml

ELSE IF intent === "spike" OR keywords include "research", "investigate"
  → LOAD workflows/spike.yml

ELSE IF intent === "migration" OR keywords include "database", "schema", "migration"
  → LOAD workflows/migration.yml

ELSE IF intent === "documentation" OR keywords include "document", "readme", "docs"
  → LOAD workflows/documentation.yml

ELSE IF intent === "performance" OR keywords include "performance", "slow", "optimize"
  → LOAD workflows/performance.yml

ELSE IF intent === "feature-development"
  IF complexity === "large" OR no_existing_plan
    → LOAD workflows/feature-full.yml
  ELSE IF complexity === "medium"
    → LOAD workflows/feature-quick.yml
  ELSE
    → LOAD workflows/feature-tdd.yml

ELSE
  → LOAD workflows/feature-quick.yml (default)
```

**Load selected workflow:**

```bash
Read: C:\Users\conta\dirgogoo-marketplace\skills\nexus\workflows\[selected-workflow].yml
```

**Parse workflow YAML** into execution plan with phases.

---

### Step 3: Present Workflow to User

**IMPORTANT**: Don't execute blindly. Present workflow and ask for confirmation.

**Format:**

```markdown
🎯 Nexus Analysis

**Task**: [user's task description]

**Detected**:
- Intent: [intent]
- Complexity: [complexity]
- Keywords: [relevant keywords]

**Selected Workflow**: `[workflow-name].yml`

**This workflow includes**:
✅ Phase 1: [Name] - [description] (~duration)
✅ Phase 2: [Name] - [description] (~duration)
✅ Phase 3: [Name] - [description] (~duration)
...

**Estimated total duration**: [X minutes/hours]

**Options**:
1. ✅ Execute as-is (recommended)
2. Skip specific phases (specify which)
3. Switch to different workflow (suggest alternative)
4. Customize workflow (tell me what to change)

How would you like to proceed?
```

**Wait for user response** before executing.

---

### Step 4: Execute Workflow Phases

Once user confirms, execute each phase sequentially.

**For each phase in workflow:**

1. **Read phase configuration** from YAML:
   ```yaml
   - id: "load-context"
     name: "Load Project Context"
     description: "Load memory, tech stack, sprint info"
     timeout: 60000
     hooks:
       - plugin: "ald-system"
         hook: "load-memory"
         required: true
   ```

2. **Announce phase start**:
   ```markdown
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ## Phase [X]/[Total]: [Phase Name] ⚙️
   Plugin: [plugin-name]
   Action: [description]

   [Executing...]
   ```

3. **Invoke plugin hook**:

   **If plugin = "ald-system"**:
   - Hook "load-memory" → Invoke `ald-memory` skill
   - Hook "sprint-check" → Read sprint context from memory
   - Hook "policy-finder" → Invoke `ald-policy-finder` skill
   - Hook "tester" → Invoke `ald-tester` skill
   - Hook "code-reviewer" → Invoke `ald-code-reviewer` skill
   - Hook "curator" → Invoke `ald-curator` skill

   **If plugin = "superpowers"**:
   - Hook "brainstorm" → Use SlashCommand tool: `/superpowers:brainstorm`
   - Hook "write-plan" → Use SlashCommand tool: `/superpowers:write-plan`
   - Hook "execute-plan" → Use SlashCommand tool: `/superpowers:execute-plan`

   **If plugin = "mcp-chrome-devtools"**:
   - Hook "performance-audit" → Use mcp chrome tool for Lighthouse audit

   **If plugin = "mcp-supabase"**:
   - Hook "list-migrations" → Use mcp__supabase__list_migrations
   - Hook "apply-migration" → Use mcp__supabase__apply_migration
   - Hook "get-advisors" → Use mcp__supabase__get_advisors

4. **Capture phase output**:
   ```json
   {
     "phase_id": "load-context",
     "status": "success",
     "output": "[phase output summary]",
     "duration": "45s"
   }
   ```

5. **Announce phase complete**:
   ```markdown
   ✅ Phase [X] Complete
   Output: [key output summary]
   Duration: [duration]
   ```

6. **Check for phase failure**:
   - If phase has `on_failure: "abort"` and fails → Stop workflow, present options
   - If phase has `on_failure: "prompt"` and fails → Ask user what to do
   - If phase has `on_failure: "skip"` and fails → Log warning, continue

7. **Continue to next phase** or stop if failure requires it.

---

### Step 5: Aggregate Results

After all phases complete, present unified report.

**Format:**

```markdown
# 🎯 Nexus Execution Report: [Task Name]

## Workflow Summary
- **Workflow**: [workflow-name]
- **Duration**: [total time]
- **Phases Completed**: [X/Y]
- **Status**: ✅ Success | ⚠️ Partial | ❌ Failed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Phase Execution Details

### Phase 1: [Name] ✅
**Plugin**: [plugin-name]
**Duration**: [time]
**Output**: [key output summary]

### Phase 2: [Name] ✅
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Key Deliverables

✅ [Deliverable 1]
✅ [Deliverable 2]
✅ [Deliverable 3]

## Quality Metrics

- **Policy Compliance**: [X/Y] policies followed
- **Test Coverage**: [if applicable]
- **Code Quality**: [Excellent/Good/Needs Work]
- **Ready for Production**: [Yes/No]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Next Steps

1. [Action item 1]
2. [Action item 2]
3. [Action item 3]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLAUDE.MD ATIVO
```

---

## Error Handling

### When Phase Fails

1. **Pause workflow**
2. **Present options**:
   ```markdown
   ⚠️ Phase Failed: [Phase Name]

   **Issue**: [error description]

   **Options**:
   1. 🔧 Fix issues and retry phase
   2. ⏭️ Skip phase (continue workflow)
   3. 🔄 Re-run previous phase
   4. ❌ Abort workflow
   5. 🔀 Switch to different workflow

   What would you like to do?
   ```

3. **Handle user choice** accordingly

---

## Available Workflows

**12 workflows** in `skills/nexus/workflows/`:

1. **feature-full.yml** - Complex feature development with brainstorm + plan
2. **feature-quick.yml** - Medium feature development
3. **feature-tdd.yml** - TDD-first feature development
4. **bugfix.yml** - Quick bug fixes
5. **refactor.yml** - Code refactoring
6. **code-review.yml** - Review only (no implementation)
7. **spike.yml** - Research and investigation
8. **hotfix.yml** - Emergency production fixes (< 10 min)
9. **migration.yml** - Database migrations with security validation
10. **documentation.yml** - API docs, READMEs, guides
11. **performance.yml** - Performance optimization with before/after comparison
12. **custom.yml** - User-defined workflow

---

## Plugin Integration

### ALD Plugin

Hooks available:
- `load-memory`: Load project context (ald-memory skill)
- `sprint-check`: Validate sprint scope (read sprint from memory)
- `policy-finder`: Identify relevant policies (ald-policy-finder skill)
- `tester`: E2E validation (ald-tester skill)
- `code-reviewer`: Review with policies (ald-code-reviewer skill)
- `curator`: Learn patterns (ald-curator skill)

### Superpowers Plugin

Hooks available:
- `brainstorm`: Socratic refinement (`/superpowers:brainstorm` slash command)
- `write-plan`: Create implementation plan (`/superpowers:write-plan` slash command)
- `execute-plan`: Execute plan in batches (`/superpowers:execute-plan` slash command)

### MCP Plugins

Hooks available based on installed MCPs:
- `mcp-chrome-devtools`: Performance audits, profiling
- `mcp-supabase`: Database operations, migrations, security audits
- `mcp-github`: Repository operations, PRs, issues
- (More MCPs can be integrated via plugin registry)

---

## Configuration

User preferences in `skills/nexus/config/user-preferences.yml`:

```yaml
default_workflow: "feature-quick"  # Default when ambiguous

plugins:
  ald:
    always_use_policies: true
    auto_curator: true
  superpowers:
    skip_brainstorm_for_simple_tasks: true

workflows:
  feature-full:
    skip_phases: []  # Never skip
  bugfix:
    skip_phases: ["brainstorm", "planning"]  # Fast fixes
```

**Load preferences** before workflow selection to apply user customizations.

---

## Integration with CLAUDE.md

- **CLAUDE.md remains**: Output contract (`CLAUDE.MD ATIVO`), core rules
- **Nexus extends**: Adds orchestration layer for multi-plugin coordination
- **When Nexus not used**: CLAUDE.md workflow applies directly
- **When Nexus used**: Nexus coordinates, CLAUDE.md rules enforced within each phase

---

## Usage Examples

### Example 1: Complex Feature
```
User: /nexus implement real-time notifications with WebSockets

Nexus:
- Detects: feature-development, large complexity
- Selects: feature-full.yml
- User confirms
- Executes: brainstorm → plan → load context → execute → validate → review → learn
- Result: Feature complete with policies followed
```

### Example 2: Quick Bugfix
```
User: /nexus fix login button spacing

Nexus:
- Detects: bugfix, small complexity
- Selects: bugfix.yml
- Executes: load context → fix → validate → quick review
- Result: Bug fixed in 5 minutes
```

### Example 3: Emergency Hotfix
```
User: /nexus hotfix production checkout failing

Nexus:
- Detects: hotfix (emergency)
- Selects: hotfix.yml
- Executes: load context (minimal) → immediate fix → smoke test → deploy
- Result: Production issue resolved in < 10 minutes
```

---

## Output Contract

**Every response MUST end with**:

```
CLAUDE.MD ATIVO
```

No exceptions.

---

## Summary: Execution Flow

1. **Receive**: User invokes `/nexus [task]`
2. **Analyze**: Detect intent, complexity, context
3. **Select**: Choose optimal workflow
4. **Present**: Show workflow, ask for confirmation
5. **Execute**: Run phases sequentially, coordinating plugins
6. **Track**: Monitor progress, handle errors
7. **Aggregate**: Present unified execution report
8. **Learn**: Each workflow makes system smarter (via curator)

---

CLAUDE.MD ATIVO
