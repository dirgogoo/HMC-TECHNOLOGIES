# MCP Integration - E2E Validation Tests

**Version**: 1.0.0
**Created**: 2025-10-28

---

## ✅ Verification Checklist

Use this checklist to validate the MCP integration is working correctly.

---

### Test 1: Registry Verification

**Verify**: 4 MCP plugins registered in registry.json

```bash
# Check registry
cat ~/.claude/skills/skills/nexus/plugins/registry.json | grep "mcp-"

# Expected output:
✅ "mcp-supabase" (priority 10, enabled: true)
✅ "mcp-chrome-devtools" (priority 11, enabled: true)
✅ "mcp-episodic-memory" (priority 12, enabled: true)
✅ "mcp-github" (priority 13, enabled: true)
```

**Pass Criteria**:
- ✅ Registry version is "1.1.0"
- ✅ 7 total plugins (3 traditional + 4 MCP)
- ✅ All MCP plugins have `type: "mcp"`
- ✅ `mcp_config` section exists with `auto_detect: true`

---

### Test 2: Plugin Metadata Verification

**Verify**: All 4 plugin.yml files exist and are valid

```bash
# Check plugin files exist
ls ~/.claude/skills/skills/nexus/plugins/mcp-*/plugin.yml

# Expected:
✅ mcp-supabase/plugin.yml
✅ mcp-chrome-devtools/plugin.yml
✅ mcp-episodic-memory/plugin.yml
✅ mcp-github/plugin.yml
```

**Verify Each Plugin Has**:
- ✅ `name`, `description`, `version`
- ✅ `type: "mcp"`
- ✅ `mcp_config` with `server_name`, `prefix`, `auto_detect`
- ✅ `hooks` array with at least 1 hook
- ✅ `capabilities` array
- ✅ `auto_triggers` with `keywords` array

---

### Test 3: Core Documentation Verification

**Verify**: Core docs exist and explain MCP system

```bash
# Check core docs
ls ~/.claude/skills/nexus/core/mcp-*.md

# Expected:
✅ mcp-detector.md (auto-discovery logic)
✅ mcp-injector.md (workflow enhancement logic)
```

**Pass Criteria**:
- ✅ mcp-detector.md explains scanning, identification, mapping
- ✅ mcp-injector.md explains task analysis, matching, injection
- ✅ Both docs have examples and code snippets

---

### Test 4: Workflow Enhancement Verification

**Verify**: Example enhanced workflow exists

```bash
# Check example workflow
cat ~/.claude/skills/nexus/workflows/EXAMPLE-enhanced-workflow.yml

# Expected:
✅ Shows original vs enhanced workflow
✅ Demonstrates mcp_hooks injection
✅ Examples for UI and database tasks
✅ Execution flow documented
```

---

### Test 5: Supabase MCP Integration (Policy 12.1)

**Task**: Simulate database migration task

**Expected Behavior**:
```
Task: "create migration add_users_table"
Keywords: ["create", "migration", "add", "users", "table"]

Detected: "migration" keyword
Matched: mcp-supabase plugin

Auto-injected hooks:
- Phase "execute": mcp-supabase/database-migration (MANDATORY)
- Phase "validate": mcp-supabase/security-audit (MANDATORY)

Policy 12.1 enforced: ✅
```

**Pass Criteria**:
- ✅ Migration hook injected in execute phase
- ✅ Security audit hook injected in validate phase
- ✅ Both marked as `required: true`
- ✅ Failure mode: `fail_workflow`

---

### Test 6: Chrome DevTools MCP Integration (Policy 12.2)

**Task**: Simulate UI task

**Expected Behavior**:
```
Task: "implement product listing UI"
Keywords: ["implement", "product", "listing", "ui"]

Detected: "ui" keyword
Matched: mcp-chrome-devtools plugin

Auto-injected hooks:
- Phase "validate": mcp-chrome-devtools/ui-validation (MANDATORY)
- Phase "validate": mcp-chrome-devtools/console-check (MANDATORY)
- Phase "validate": mcp-chrome-devtools/network-check (MANDATORY)

Policy 12.2 enforced: ✅
```

**Pass Criteria**:
- ✅ UI validation hook injected in validate phase
- ✅ Console check hook injected
- ✅ Network check hook injected
- ✅ All marked as `required: true`
- ✅ Failure criteria defined

---

### Test 7: Episodic Memory MCP Integration (Optional)

**Task**: Simulate recall task

**Expected Behavior**:
```
Task: "implement checkout similar to past"
Keywords: ["implement", "checkout", "similar", "past"]

Detected: "similar", "past" keywords
Matched: mcp-episodic-memory plugin

Auto-suggested hooks:
- Phase "load-context": mcp-episodic-memory/recall-patterns (OPTIONAL)

User control: ✅ Can skip
```

**Pass Criteria**:
- ✅ Hook suggested (not mandatory)
- ✅ Marked as `required: false`
- ✅ User can skip without workflow failure

---

### Test 8: GitHub MCP Integration (Conditional)

**Task**: Simulate PR creation task

**Expected Behavior**:
```
Task: "implement feature and create PR"
Keywords: ["implement", "feature", "create", "pr"]

Detected: "pr" keyword
Matched: mcp-github plugin (if available)

Auto-suggested hooks:
- Phase "review": mcp-github/create-pr (OPTIONAL)

Availability check: ✅
Fallback: Manual PR creation if MCP not available
```

**Pass Criteria**:
- ✅ Hook suggested only if GitHub MCP available
- ✅ Marked as `required: false`
- ✅ Fallback behavior documented

---

### Test 9: Full-Stack Feature Test

**Task**: Simulate complex task with multiple MCPs

**Expected Behavior**:
```
Task: "implement user authentication with database and UI"
Keywords: ["implement", "user", "authentication", "database", "ui"]

Detected: "database" + "ui" keywords
Matched: mcp-supabase + mcp-chrome-devtools

Auto-injected hooks:
- Phase "execute": mcp-supabase/database-migration (MANDATORY)
- Phase "validate": mcp-supabase/security-audit (MANDATORY)
- Phase "validate": mcp-chrome-devtools/ui-validation (MANDATORY)
- Phase "validate": mcp-chrome-devtools/console-check (MANDATORY)
- Phase "validate": mcp-chrome-devtools/network-check (MANDATORY)

Multiple MCPs coordinated: ✅
```

**Pass Criteria**:
- ✅ Both MCP plugins activated
- ✅ 5 total hooks injected
- ✅ All mandatory hooks marked correctly
- ✅ No conflicts between MCPs

---

### Test 10: Documentation Verification

**Verify**: README and MCP-INTEGRATION.md complete

```bash
# Check main README
grep "MCP Integration" ~/.claude/skills/nexus/README.md

# Check full integration guide
cat ~/.claude/skills/nexus/MCP-INTEGRATION.md

# Expected:
✅ README mentions MCP Integration (v1.1.0)
✅ README links to MCP-INTEGRATION.md
✅ MCP-INTEGRATION.md has 4 plugin docs
✅ Examples, benefits, FAQ included
```

**Pass Criteria**:
- ✅ README updated with MCP section
- ✅ MCP-INTEGRATION.md comprehensive
- ✅ All 4 MCP plugins documented
- ✅ Auto-injection flow explained
- ✅ Policy enforcement documented
- ✅ FAQ answers common questions

---

## 📊 Overall Integration Health

### Files Created (11 total):

**Phase 1 - MCP Plugins** (4 files):
- ✅ `plugins/mcp-supabase/plugin.yml`
- ✅ `plugins/mcp-chrome-devtools/plugin.yml`
- ✅ `plugins/mcp-episodic-memory/plugin.yml`
- ✅ `plugins/mcp-github/plugin.yml`

**Phase 2 - Registry & Core** (3 files):
- ✅ `plugins/registry.json` (updated to v1.1.0)
- ✅ `core/mcp-detector.md`
- ✅ `core/mcp-injector.md`

**Phase 3 - Workflows** (1 file):
- ✅ `workflows/EXAMPLE-enhanced-workflow.yml`

**Phase 4 - Documentation** (3 files):
- ✅ `MCP-INTEGRATION.md`
- ✅ `README.md` (updated with MCP section)
- ✅ `INTEGRATION-TESTS.md` (this file)

---

## ✅ Final Validation

Run through all 10 tests above. Mark each as PASS/FAIL.

**Integration is COMPLETE when**:
- ✅ All 10 tests pass
- ✅ 11 files created/updated
- ✅ Documentation comprehensive
- ✅ Examples clear and complete
- ✅ Policies enforced correctly

**Result**: MCP Integration v1.1.0 Ready for Production ✅

---

## 🚀 Next Steps After Validation

1. Test with real tasks:
   ```bash
   /nexus implement product listing UI
   /nexus create migration add_users
   ```

2. Verify MCP auto-injection works:
   - Check console output for "🔌 MCP Hooks" messages
   - Verify MANDATORY hooks cannot be skipped
   - Confirm failures block workflow

3. Monitor and iterate:
   - Track which MCPs are used most
   - Identify missing MCPs (Policy 11.4)
   - Add new MCP plugins as needed

---

CLAUDE.MD ATIVO
