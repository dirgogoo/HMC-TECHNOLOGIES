# Nexus - Master Workflow Orchestrator

**Version**: 1.1.0
**Status**: ✅ Production Ready
**Repository**: https://github.com/dirgogoo/nexus

---

## 🎯 What is Nexus?

**Nexus** is the master workflow orchestrator for Claude Code that intelligently coordinates multiple AI systems (Superpowers, ALD, MCP plugins) to deliver optimal development workflows.

Think of Nexus as a **conductor leading an orchestra** where each plugin is an instrument. Nexus makes them play together harmoniously.

### ⭐ Key Features

- 🎯 **Intent Detection** - Analyzes your task to select the optimal workflow automatically
- 🔄 **Multi-Plugin Coordination** - Seamlessly orchestrates Superpowers + ALD + MCPs
- 📋 **Declarative Workflows** - YAML-based workflow templates (customizable)
- ✅ **Policy Enforcement** - Automatic validation using 155 ALD policies
- 🧠 **Continuous Learning** - Curator learns patterns and improves over time
- 🔌 **MCP Auto-Injection** - Keywords trigger MCP usage automatically
- 🚀 **TDD by Default** - Red-Green-Refactor cycle built into workflows
- 📊 **Unified Reporting** - Aggregates results across all plugins
- 🛡️ **Sprint Isolation** - Prevents scope creep and regressions
- 🎓 **Self-Improving** - Gets progressively smarter with usage

---

## 🚀 Quick Start

```bash
# 1. Install Nexus plugin
/plugin install https://github.com/dirgogoo/nexus

# 2. Run auto-setup (installs ALD + Superpowers)
/nexus-setup

# 3. Start orchestrating
/nexus implement user authentication
```

**Done!** Nexus will analyze your task, select the optimal workflow, and coordinate execution.

---

## 📖 How It Works

### Example: Implement a Feature

```bash
/nexus implement product listing UI
```

**Nexus orchestrates**:

1. 🔍 **Analyzes**: "implement" + "UI" → Feature development
2. 🎯 **Suggests**: `feature-full.yml` (TDD + validation)
3. ✅ **You confirm** or adjust
4. 🔄 **Executes**:
   - Brainstorm → Plan → Load Context → Find Policies
   - Execute (TDD) → Validate (E2E + **UI validation**)
   - Review → Learn

5. 📊 **Result**: Feature complete, tested, policies followed

**MCP Auto-Injection**: Nexus detected "UI" → Auto-injected Chrome DevTools validation (MANDATORY)

---

## 🎨 Available Workflows

| Workflow | Use Case | Duration | Example |
|----------|----------|----------|---------|
| **feature-full** | Complex features | 60-120min | `/nexus implement notifications` |
| **feature-quick** | Medium features | 30-45min | `/nexus create API endpoint` |
| **bugfix** | Quick fixes | 10-20min | `/nexus fix login spacing` |
| **refactor** | Code improvements | 20-40min | `/nexus refactor UserList` |
| **code-review** | Review only | 5-10min | `/nexus review my code` |

---

## ⭐ MCP Integration (v1.1.0)

Nexus auto-injects MCP tools based on keywords:

### Example: Database Migration

```bash
/nexus create migration add_users_table
```

**Nexus detects "migration"** → Auto-injects:
- ✅ Supabase migration (execute phase)
- ✅ Security audit (validate phase - MANDATORY)

**Workflow FAILS if**: RLS policies missing or security issues found

### Available MCPs

| MCP | Purpose | Auto-Inject | Policy |
|-----|---------|-------------|--------|
| **Supabase** | Database operations | ✅ YES | 12.1 (MANDATORY) |
| **Chrome DevTools** | UI validation | ✅ YES | 12.2 (MANDATORY) |
| **Episodic Memory** | Context recall | ❌ Optional | - |
| **GitHub** | Code operations | ❌ Conditional | - |

**See full docs**: [MCP-INTEGRATION.md](./MCP-INTEGRATION.md)

---

## 🏗️ Architecture

```
USER → NEXUS (Orchestrator) → PLUGINS
                │
                ├─ ALD (Memory, Policies, Tester, Reviewer, Curator, Sprint)
                ├─ Superpowers (Brainstorm, Planning, TDD, Debugging)
                └─ MCPs (Supabase, Chrome DevTools, GitHub, Memory)
```

---

## 🧩 Dependencies

### Auto-Installed via `/nexus-setup`

**ALD System** (8 skills + 155 policies):
- ald-memory, ald-policies, ald-tester, ald-code-reviewer
- ald-curator, ald-orchestrator, ald-policy-finder, ald-sprint

**Superpowers**:
- superpowers@superpowers-marketplace
- superpowers@superpowers-dev

### Manual Setup (Optional)

**MCP Plugins** (require Claude Desktop config):
- Supabase, Chrome DevTools, GitHub, Episodic Memory

**See**: [SETUP-GUIDE.md](./SETUP-GUIDE.md)

---

## 💡 Usage Examples

### Complex Feature

```bash
/nexus implement real-time notifications
```
→ Brainstorm → Plan → TDD → E2E Validation → Review → Learn
**Result**: Feature complete with patterns learned

### Quick Bugfix

```bash
/nexus fix login button spacing
```
→ Context → Sprint Check → Fix → Validate → Review
**Result**: Fixed in 5 minutes

### UI Feature with Auto-Validation

```bash
/nexus implement checkout page
```
→ Auto-injects Chrome DevTools validation (MANDATORY)
**Fails if**: Console errors or network failures
**Result**: Fully validated UI, zero errors

---

## 📚 Documentation

- **[SETUP-GUIDE.md](./SETUP-GUIDE.md)** - Installation & configuration
- **[MCP-INTEGRATION.md](./MCP-INTEGRATION.md)** - MCP system guide
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Common issues
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history

**Core Documentation**: `core/*.md` (intent detector, workflow engine, orchestrator, MCP system)
**Workflows**: `workflows/*.yml` (5 pre-built workflows + examples)

---

## ⚙️ Configuration

Customize in `config/user-preferences.yml`:

```yaml
default_workflow: "feature-quick"

plugins:
  ald:
    always_use_policies: true
    auto_curator: true
  superpowers:
    skip_brainstorm_for_simple_tasks: true
```

---

## 📊 Before vs After

| Aspect | Before | After |
|--------|--------|-------|
| Workflow Selection | Manual | Automatic |
| Plugin Coordination | Manual | Seamless |
| Policy Enforcement | Easy to forget | Auto-enforced (155 policies) |
| MCP Usage | Manual | Auto-injected |
| Validation | Inconsistent | Always (E2E + policies) |
| Learning | None | Continuous |

---

## 🔧 Extending Nexus

### Custom Workflow

Create `workflows/my-workflow.yml`:

```yaml
name: "My Workflow"
triggers:
  keywords: ["custom"]

phases:
  - id: "load-context"
    plugin: "ald"
    hook: "load-memory"

  - id: "execute"
    plugin: "ald"
    hook: "executor"
```

### Custom MCP Plugin

1. Create `plugins/mcp-[name]/plugin.yml`
2. Register in `plugins/registry.json`
3. Nexus auto-detects

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](./CONTRIBUTING.md)

```bash
git clone https://github.com/dirgogoo/nexus
cd nexus
cp -r . ~/.claude/skills/nexus
/nexus review my code
```

---

## 📝 License

MIT License - see [LICENSE](./LICENSE)

---

## 🐛 Support

- **Issues**: https://github.com/dirgogoo/nexus/issues
- **Discussions**: https://github.com/dirgogoo/nexus/discussions

---

## 🙏 Credits

- **Superpowers** - Structured workflows
- **ALD System** - Policy-driven development
- **MCP Community** - Tool integrations
- **Claude Code** - Plugin architecture

---

## 📈 Roadmap

- v1.2.0: Workflow visualization
- v1.3.0: Multi-repository support
- v1.4.0: Custom MCP templates
- v1.5.0: Analytics dashboard

---

**Made with ❤️ by the ALD community**

**Status**: ✅ Production Ready | **Version**: 1.1.0

CLAUDE.MD ATIVO
