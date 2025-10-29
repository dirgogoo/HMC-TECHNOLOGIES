# MCP Injector - Workflow Phase Injection

**Version**: 1.0.0
**Created**: 2025-10-28

---

## Overview

The MCP Injector automatically enhances workflows by injecting MCP hooks into appropriate phases based on task analysis, keywords, and policy enforcement.

---

## Injection Algorithm

### Step 1: Task Analysis

```typescript
function analyzeTask(taskDescription: string): TaskAnalysis {
  return {
    keywords: extractKeywords(taskDescription),
    intent: detectIntent(taskDescription),
    complexity: assessComplexity(taskDescription),
    technologies: detectTechnologies(taskDescription)
  };
}

function extractKeywords(text: string): string[] {
  const normalized = text.toLowerCase();
  const words = normalized.split(/\s+/);

  // Remove stop words
  const stopWords = ["the", "a", "an", "and", "or", "but", "in", "on", "at"];
  return words.filter(word => !stopWords.includes(word));
}

// Example:
// Input: "Implement product listing UI with Supabase database"
// Output: {
//   keywords: ["implement", "product", "listing", "ui", "supabase", "database"],
//   intent: "feature-development",
//   complexity: "medium",
//   technologies: ["ui", "database", "supabase"]
// }
```

### Step 2: Match MCP Plugins

```typescript
function findRelevantMcpPlugins(
  analysis: TaskAnalysis,
  mcpPlugins: McpPlugin[]
): RelevantPlugin[] {
  const relevantPlugins = [];

  for (const plugin of mcpPlugins) {
    if (!plugin.enabled) continue;

    const matchedHooks = [];

    // Check auto_triggers keywords
    for (const trigger of plugin.auto_triggers.keywords) {
      const keywordMatches = trigger.trigger.filter(keyword =>
        analysis.keywords.includes(keyword)
      );

      if (keywordMatches.length > 0) {
        for (const hookName of trigger.hooks) {
          const hook = plugin.hooks.find(h => h.name === hookName);

          if (hook) {
            matchedHooks.push({
              hook,
              matchedKeywords: keywordMatches,
              mandatory: trigger.mandatory
            });
          }
        }
      }
    }

    if (matchedHooks.length > 0) {
      relevantPlugins.push({
        plugin,
        matchedHooks
      });
    }
  }

  return relevantPlugins;
}

// Example:
// Task: "Implement product listing UI"
// Keywords: ["implement", "product", "listing", "ui"]
//
// Matched plugins:
// - mcp-chrome-devtools:
//     Trigger: ["ui", "component", "page"] → MATCHED "ui"
//     Hooks: ["ui-validation", "console-check", "network-check"]
//     Mandatory: true (Policy 12.2)
```

### Step 3: Inject into Workflow Phases

```typescript
function injectMcpHooks(
  workflow: Workflow,
  relevantPlugins: RelevantPlugin[]
): Workflow {
  for (const phase of workflow.phases) {
    phase.mcp_hooks = phase.mcp_hooks || [];

    for (const { plugin, matchedHooks } of relevantPlugins) {
      for (const { hook, mandatory } of matchedHooks) {
        // Check if hook should be injected in this phase
        if (hook.workflow_phases.includes(phase.id)) {
          phase.mcp_hooks.push({
            plugin: plugin.name,
            hook: hook.name,
            mcp_tools: hook.mcp_tools,
            inputs: hook.inputs,
            outputs: hook.outputs,
            required: mandatory || hook.validation?.mandatory || false,
            reason: hook.validation?.reason || "Auto-injected based on keywords"
          });
        }
      }
    }
  }

  return workflow;
}

// Example workflow enhancement:
// Original phase:
{
  id: "validate",
  plugin: "ald",
  hook: "tester"
}

// After injection (task had "ui" keyword):
{
  id: "validate",
  plugin: "ald",
  hook: "tester",
  mcp_hooks: [
    {
      plugin: "mcp-chrome-devtools",
      hook: "ui-validation",
      mcp_tools: ["use_browser"],
      required: true,
      reason: "Policy 12.2 - MANDATORY UI validation after any UI changes"
    }
  ]
}
```

---

## Policy Enforcement

### Mandatory MCP Hooks

Certain MCPs are **MANDATORY** based on policies:

```typescript
const MANDATORY_MCPS = {
  "ui_change": {
    plugin: "mcp-chrome-devtools",
    hooks: ["ui-validation", "console-check", "network-check"],
    policy: "12.2",
    failure_mode: "fail_workflow",
    triggers: ["ui", "component", "page", "form", "button", "frontend"]
  },
  "database_change": {
    plugin: "mcp-supabase",
    hooks: ["security-audit"],
    policy: "12.1",
    failure_mode: "fail_workflow",
    triggers: ["database", "migration", "schema", "supabase"]
  }
};

function enforceMandatoryMcps(
  workflow: Workflow,
  analysis: TaskAnalysis
): void {
  for (const [changeType, config] of Object.entries(MANDATORY_MCPS)) {
    const hasRelevantKeywords = config.triggers.some(trigger =>
      analysis.keywords.includes(trigger)
    );

    if (hasRelevantKeywords) {
      // Ensure mandatory MCP hooks are injected
      const validatePhase = workflow.phases.find(p => p.id === "validate");

      if (validatePhase) {
        for (const hookName of config.hooks) {
          const alreadyInjected = validatePhase.mcp_hooks?.some(
            h => h.plugin === config.plugin && h.hook === hookName
          );

          if (!alreadyInjected) {
            validatePhase.mcp_hooks = validatePhase.mcp_hooks || [];
            validatePhase.mcp_hooks.push({
              plugin: config.plugin,
              hook: hookName,
              required: true,
              reason: `Policy ${config.policy} - MANDATORY enforcement`,
              failure_mode: config.failure_mode
            });
          }
        }
      }
    }
  }
}
```

### Required-After Rules

Some hooks must run AFTER specific events:

```typescript
function applyRequiredAfterRules(workflow: Workflow): void {
  // Example: security-audit required after database-migration
  const executePhase = workflow.phases.find(p => p.id === "execute");
  const validatePhase = workflow.phases.find(p => p.id === "validate");

  if (executePhase && validatePhase) {
    const hasMigrationHook = executePhase.mcp_hooks?.some(
      h => h.hook === "database-migration"
    );

    if (hasMigrationHook) {
      // Automatically inject security-audit in validate phase
      const hasSecurityAudit = validatePhase.mcp_hooks?.some(
        h => h.hook === "security-audit"
      );

      if (!hasSecurityAudit) {
        validatePhase.mcp_hooks = validatePhase.mcp_hooks || [];
        validatePhase.mcp_hooks.push({
          plugin: "mcp-supabase",
          hook: "security-audit",
          required: true,
          reason: "Required after database-migration (Policy 12.1)"
        });
      }
    }
  }
}
```

---

## Injection Examples

### Example 1: UI Feature

```typescript
// Task: "/nexus implement product listing UI"
// Analysis:
{
  keywords: ["implement", "product", "listing", "ui"],
  intent: "feature-development",
  complexity: "medium",
  technologies: ["ui"]
}

// Matched MCPs:
- mcp-chrome-devtools (ui-validation, console-check, network-check)

// Workflow before injection:
{
  phases: [
    { id: "brainstorm", ... },
    { id: "plan", ... },
    { id: "execute", ... },
    { id: "validate", plugin: "ald", hook: "tester" },
    { id: "review", ... }
  ]
}

// Workflow after injection:
{
  phases: [
    { id: "brainstorm", ... },
    { id: "plan", ... },
    { id: "execute", ... },
    {
      id: "validate",
      plugin: "ald",
      hook: "tester",
      mcp_hooks: [
        {
          plugin: "mcp-chrome-devtools",
          hook: "ui-validation",
          required: true,
          reason: "Policy 12.2 - MANDATORY"
        },
        {
          plugin: "mcp-chrome-devtools",
          hook: "console-check",
          required: true,
          reason: "Policy 12.2 - Console must be clean"
        },
        {
          plugin: "mcp-chrome-devtools",
          hook: "network-check",
          required: true,
          reason: "Policy 12.2 - Network requests must succeed"
        }
      ]
    },
    { id: "review", ... }
  ]
}
```

### Example 2: Database Migration

```typescript
// Task: "/nexus create migration add_users_table"
// Analysis:
{
  keywords: ["create", "migration", "add", "users", "table"],
  intent: "database-change",
  complexity: "small",
  technologies: ["database", "migration"]
}

// Matched MCPs:
- mcp-supabase (database-migration, security-audit)

// Workflow after injection:
{
  phases: [
    { id: "load-context", ... },
    {
      id: "execute",
      plugin: "ald",
      mcp_hooks: [
        {
          plugin: "mcp-supabase",
          hook: "database-migration",
          required: true,
          reason: "Policy 12.1 - Use Supabase MCP for migrations"
        }
      ]
    },
    {
      id: "validate",
      plugin: "ald",
      hook: "tester",
      mcp_hooks: [
        {
          plugin: "mcp-supabase",
          hook: "security-audit",
          required: true,
          reason: "Required after database-migration (Policy 12.1)"
        }
      ]
    }
  ]
}
```

### Example 3: Full-Stack Feature

```typescript
// Task: "/nexus implement user authentication with database and UI"
// Analysis:
{
  keywords: ["implement", "user", "authentication", "database", "ui"],
  intent: "feature-development",
  complexity: "large",
  technologies: ["database", "ui", "authentication"]
}

// Matched MCPs:
- mcp-supabase (database-migration, security-audit)
- mcp-chrome-devtools (ui-validation)

// Workflow after injection:
{
  phases: [
    { id: "brainstorm", ... },
    { id: "plan", ... },
    {
      id: "execute",
      mcp_hooks: [
        {
          plugin: "mcp-supabase",
          hook: "database-migration",
          required: true
        }
      ]
    },
    {
      id: "validate",
      mcp_hooks: [
        {
          plugin: "mcp-supabase",
          hook: "security-audit",
          required: true,
          reason: "Required after database-migration"
        },
        {
          plugin: "mcp-chrome-devtools",
          hook: "ui-validation",
          required: true,
          reason: "Policy 12.2 - MANDATORY"
        }
      ]
    }
  ]
}
```

---

## User Control

### Review Before Execution

Before executing workflow, show user:

```
🎯 Nexus Analysis: Implement product listing UI

Workflow: feature-full.yml (TDD by default)
Estimated: 60-120 minutes

MCP Hooks Auto-Injected:
✅ Phase "validate":
   - mcp-chrome-devtools/ui-validation (REQUIRED - Policy 12.2)
   - mcp-chrome-devtools/console-check (REQUIRED - Policy 12.2)
   - mcp-chrome-devtools/network-check (REQUIRED - Policy 12.2)

Options:
1. Use as-is (recommended)
2. Skip optional MCP hooks
3. Customize workflow

Choose:
```

### Adjusting Injected Hooks

User can:
- Skip optional hooks (mandatory hooks cannot be skipped)
- Add additional hooks manually
- Change hook parameters

---

## Execution Flow

### During Phase Execution

```typescript
async function executePhase(phase: Phase): Promise<PhaseResult> {
  // 1. Execute main plugin hook
  console.log(`🎯 Phase: ${phase.name}`);
  const mainResult = await invokePluginHook(phase.plugin, phase.hook);

  // 2. Execute MCP hooks (if any)
  if (phase.mcp_hooks && phase.mcp_hooks.length > 0) {
    console.log(`🔌 Executing ${phase.mcp_hooks.length} MCP hooks...`);

    for (const mcpHook of phase.mcp_hooks) {
      console.log(`   → ${mcpHook.plugin}/${mcpHook.hook}`);

      const mcpResult = await invokeMcpHook(mcpHook);

      if (mcpHook.required && !mcpResult.success) {
        throw new McpValidationError(
          `MANDATORY MCP validation failed: ${mcpHook.hook}`,
          mcpHook.reason
        );
      }

      if (!mcpResult.success) {
        console.warn(`⚠️  Optional MCP hook failed: ${mcpHook.hook}`);
      } else {
        console.log(`   ✅ ${mcpHook.hook} passed`);
      }
    }
  }

  return {
    main: mainResult,
    mcps: mcpResults
  };
}
```

---

## Testing Injection

```bash
# Test MCP injection
/nexus test-injection "implement product listing UI"

# Expected output:
🔍 Analyzing task...
Keywords: ["implement", "product", "listing", "ui"]
Intent: feature-development
Complexity: medium

🔌 Matching MCP plugins...
Found 1 relevant MCP: mcp-chrome-devtools

💉 Injecting hooks into workflow...
Phase "validate":
  ✅ Injected: mcp-chrome-devtools/ui-validation (MANDATORY)
  ✅ Injected: mcp-chrome-devtools/console-check (MANDATORY)
  ✅ Injected: mcp-chrome-devtools/network-check (MANDATORY)

Enhanced workflow: feature-full.yml + 3 MCP hooks
```

---

**Next**: See workflow YAML files for how `mcp_hooks: []` fields are used during execution.

CLAUDE.MD ATIVO
