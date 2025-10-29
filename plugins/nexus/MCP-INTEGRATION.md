# MCP Integration in Nexus

**Version**: 1.0.0
**Status**: ✅ Operational
**Last Updated**: 2025-10-28

---

## 🎯 Overview

Nexus now automatically integrates **MCP (Model Context Protocol) tools** as plugins, enabling zero-configuration usage of external services like Supabase, Chrome DevTools, GitHub, and more.

**Key Features**:
- ✅ **Auto-Detection**: Scans and registers available MCPs automatically
- ✅ **Auto-Injection**: Keywords trigger MCP usage without manual invocation
- ✅ **Policy Enforcement**: Mandatory validations (UI, security) auto-enforced
- ✅ **Zero Configuration**: Works out-of-the-box with installed MCPs

---

## 📦 Available MCP Plugins

### 1. **mcp-supabase** (Priority 10)

**What**: Supabase database operations, migrations, security audits
**Auto-inject**: ✅ YES (mandatory for database tasks)
**Policy**: 12.1 - MANDATORY for database operations

**Hooks**:
- `database-migration`: Apply migrations + automatic security validation
- `database-query`: Execute SQL queries
- `security-audit`: Check RLS policies and vulnerabilities (MANDATORY after migrations)
- `performance-audit`: Check indexes and query optimization
- `type-generation`: Generate TypeScript types from schema
- `schema-inspection`: List tables, extensions, migrations

**Triggers**:
- Keywords: `["database", "schema", "migration", "supabase", "query"]`
- Phases: `execute`, `validate`

**Example**:
```bash
/nexus create migration add_users_table

# Auto-injects:
# - Phase "execute": mcp-supabase/database-migration
# - Phase "validate": mcp-supabase/security-audit (MANDATORY)
```

---

### 2. **mcp-chrome-devtools** (Priority 11)

**What**: UI validation, E2E testing, performance audits
**Auto-inject**: ✅ YES (mandatory for UI tasks)
**Policy**: 12.2 - MANDATORY for UI changes

**Hooks**:
- `ui-validation`: Complete UI checklist (console, network, structure, screenshot)
- `console-check`: Verify console has 0 errors (MANDATORY)
- `network-check`: Verify all network requests succeed (MANDATORY)
- `e2e-test`: Execute end-to-end user flows
- `performance-audit`: Measure Core Web Vitals (LCP, FID, CLS)
- `accessibility-check`: Check ARIA and keyboard navigation

**Triggers**:
- Keywords: `["ui", "component", "page", "form", "button", "frontend"]`
- Phases: `validate`

**Example**:
```bash
/nexus implement product listing UI

# Auto-injects (MANDATORY):
# - Phase "validate": mcp-chrome-devtools/ui-validation
# - Phase "validate": mcp-chrome-devtools/console-check
# - Phase "validate": mcp-chrome-devtools/network-check

# Workflow FAILS if:
# - Console has errors
# - Network requests fail
# - UI validation fails
```

---

### 3. **mcp-episodic-memory** (Priority 12)

**What**: Search past conversations and patterns
**Auto-inject**: ❌ NO (optional, user-triggered)
**Policy**: None (always optional)

**Hooks**:
- `search-conversations`: Search past conversations for relevant context
- `recall-patterns`: Recall patterns from similar implementations
- `recall-decisions`: Recall architectural decisions and rationale
- `recall-bugs`: Search for similar bugs fixed in the past

**Triggers**:
- Keywords: `["remember", "past", "previous", "history", "similar"]`
- Phases: `load-context`, `brainstorm`, `plan`

**Example**:
```bash
/nexus implement checkout similar to past implementations

# Auto-suggests (optional):
# - Phase "load-context": mcp-episodic-memory/recall-patterns
```

---

### 4. **mcp-github** (Priority 13)

**What**: GitHub operations (issues, PRs, code review)
**Auto-inject**: ❌ NO (conditional - only if MCP available)
**Policy**: 11.4 - Track usage, document if needed

**Hooks**:
- `create-issue`: Create GitHub issue from task
- `create-pr`: Create pull request after implementation
- `fetch-issues`: List open issues for context
- `code-review-comment`: Add review comments to PR
- `search-code`: Search code across repositories

**Triggers**:
- Keywords: `["issue", "pr", "pull request", "merge", "review"]`
- Phases: `plan`, `review`

**Example**:
```bash
/nexus implement feature and create PR

# Auto-suggests (if GitHub MCP available):
# - Phase "review": mcp-github/create-pr
```

---

## 🔄 How Auto-Injection Works

### 1. Task Analysis

When you invoke Nexus:
```
/nexus implement product listing UI
```

Nexus analyzes:
```typescript
{
  keywords: ["implement", "product", "listing", "ui"],
  intent: "feature-development",
  complexity: "medium",
  technologies: ["ui"]
}
```

### 2. MCP Matching

Nexus matches keywords to MCP plugins:
```typescript
// "ui" keyword matches:
- mcp-chrome-devtools → triggers: ["ui", "component", "page"]
  → Hooks: ["ui-validation", "console-check", "network-check"]
  → Mandatory: TRUE (Policy 12.2)
```

### 3. Phase Injection

Nexus enhances workflow:
```yaml
phases:
  - id: "validate"
    plugin: "ald"
    hook: "tester"
    mcp_hooks:  # ← Auto-injected
      - plugin: "mcp-chrome-devtools"
        hook: "ui-validation"
        required: true
        reason: "Policy 12.2 - MANDATORY"
```

### 4. Execution

During `validate` phase:
```
🎯 Phase: E2E Validation
   → Main: ald/tester ✅

   🔌 MCP Hooks (3):
      → mcp-chrome-devtools/ui-validation ✅
      → mcp-chrome-devtools/console-check ✅
      → mcp-chrome-devtools/network-check ✅

✅ Phase complete
```

---

## 🚨 Policy Enforcement

### Mandatory MCPs (Cannot Skip)

**Policy 12.2 - UI Changes**:
```bash
# Task with "ui" keyword:
/nexus implement login page

# MANDATORY validations auto-enforced:
✅ Chrome DevTools UI validation
✅ Console check (must be 0 errors)
✅ Network check (all requests must succeed)

# Workflow FAILS if any validation fails
```

**Policy 12.1 - Database Changes**:
```bash
# Task with "database" or "migration" keyword:
/nexus create migration add_users

# MANDATORY validations auto-enforced:
✅ Supabase migration via MCP
✅ Security audit (RLS policies check)

# Workflow FAILS if security issues found
```

### Optional MCPs (Can Skip)

```bash
# Optional hooks suggested but not required:
- Episodic memory search
- Performance audits
- Accessibility checks
- GitHub PR creation

# User can:
1. Accept suggestion
2. Skip
3. Customize
```

---

## 📊 Benefits

### Before MCP Integration:

```bash
User: /nexus implement product listing UI
→ Workflow executes
→ User manually invokes mcp__chrome-devtools__ for validation
→ Easy to forget steps
→ Inconsistent validation
```

### After MCP Integration:

```bash
User: /nexus implement product listing UI
→ Nexus detects "ui" keyword
→ Auto-injects chrome-devtools validation (MANDATORY)
→ Phase "validate" automatically:
   ✅ Captures UI snapshot
   ✅ Checks console (0 errors)
   ✅ Checks network (all succeed)
   ✅ Takes screenshot
→ Workflow FAILS if validation fails
→ Consistent, automatic validation
```

### Key Improvements:

| Aspect | Before | After |
|--------|--------|-------|
| **MCP Usage** | Manual invocation | Automatic injection |
| **Policy Enforcement** | Optional (easy to forget) | Mandatory (auto-enforced) |
| **Validation** | Inconsistent | Consistent, repeatable |
| **User Effort** | Remember to validate | Zero effort |
| **Failure Detection** | Post-deployment | Pre-deployment |

---

## 🛠️ Configuration

### Enable/Disable MCP Plugins

Edit `plugins/registry.json`:

```json
{
  "name": "mcp-supabase",
  "enabled": false  // ← Disable Supabase MCP
}
```

### Disable Auto-Injection Globally

```json
{
  "mcp_config": {
    "auto_inject": false  // ← Disable auto-injection
  }
}
```

### Customize Keywords

Edit plugin.yml:

```yaml
auto_triggers:
  keywords:
    - trigger: ["ui", "component", "page", "custom-keyword"]
      hooks: ["ui-validation"]
      mandatory: true
```

---

## 🧪 Testing MCP Integration

### Test 1: UI Feature

```bash
/nexus implement product listing UI

# Expected:
✅ Detects "ui" keyword
✅ Auto-injects mcp-chrome-devtools/ui-validation (MANDATORY)
✅ Validates console, network, UI
✅ Fails if console has errors
```

### Test 2: Database Migration

```bash
/nexus create migration add_users_table

# Expected:
✅ Detects "migration" keyword
✅ Auto-injects mcp-supabase/database-migration
✅ Auto-injects mcp-supabase/security-audit (MANDATORY after migration)
✅ Fails if RLS policies missing
```

### Test 3: Full-Stack Feature

```bash
/nexus implement user authentication with database and UI

# Expected:
✅ Detects "database" + "ui" keywords
✅ Auto-injects mcp-supabase (database validation)
✅ Auto-injects mcp-chrome-devtools (UI validation)
✅ Both validations MANDATORY
```

---

## 📚 Documentation

- **MCP Detector**: `core/mcp-detector.md` - How MCPs are auto-discovered
- **MCP Injector**: `core/mcp-injector.md` - How hooks are injected into workflows
- **Enhanced Workflow Example**: `workflows/EXAMPLE-enhanced-workflow.yml` - Full examples

---

## 🚀 Future Enhancements

- [ ] More MCP plugins (Vercel, Git, Stripe, etc.)
- [ ] Custom MCP plugin templates
- [ ] MCP usage analytics
- [ ] Workflow visualization with MCP hooks
- [ ] MCP hook chaining (output → input)

---

## ❓ FAQ

**Q: Do I need to manually invoke MCPs?**
A: No! Nexus auto-injects based on keywords. Just use `/nexus` normally.

**Q: Can I skip mandatory MCPs?**
A: No. Mandatory MCPs (Policy 12.1, 12.2) cannot be skipped. They enforce critical validations.

**Q: What if MCP tool fails?**
A: If MANDATORY → workflow fails. If OPTIONAL → warning logged, workflow continues.

**Q: How do I add a new MCP?**
A: 1) Install MCP, 2) Create `plugins/mcp-name/plugin.yml`, 3) Nexus auto-detects it.

**Q: Can I customize MCP hooks?**
A: Yes! Before workflow execution, Nexus shows injected hooks. You can customize or skip optional ones.

---

**MCP Integration makes Nexus workflows smarter, safer, and more consistent** 🚀

CLAUDE.MD ATIVO
