# HMC Technologies - AI Development Tools

**AI-Powered Development System for Claude Code**

A unified marketplace combining powerful development tools: ALD System (Autonomous Learning & Development) and Nexus (Master Workflow Orchestrator).

---

## 🎯 What's Included

### 1. **ALD System** (v1.3.3)
**Autonomous Learning & Development with 155 Validated Policies**

- 🧠 **Persistent Memory** - Context across conversations
- 📜 **155 Policies** - 17 categories (Database, UI/UX, Security, API Design, Testing, etc.)
- 🎯 **Sprint Management** - Scope isolation and regression prevention
- ✅ **E2E Validation** - Tests like a real user (console, network, UX)
- 📊 **Continuous Learning** - Curator learns patterns and improves over time
- 🔍 **Policy Finder** - Intelligent search across all policies
- 🛡️ **Code Reviewer** - Validates against policies

**8 Specialized Skills:**
- `ald-memory` - Project context and preferences
- `ald-policies` - 155 validated development policies
- `ald-curator` - Pattern detection and learning
- `ald-tester` - E2E validation as end user
- `ald-orchestrator` - Workflow coordination
- `ald-sprint` - Sprint lifecycle management
- `ald-policy-finder` - Smart policy search
- `ald-code-reviewer` - Policy-aware code review

### 2. **Nexus** (v1.1.3)
**Master Workflow Orchestrator**

- 🎯 **Intent Detection** - Analyzes tasks to select optimal workflows
- 🔄 **Multi-Plugin Coordination** - Seamlessly coordinates Superpowers + ALD + MCPs
- 📋 **Declarative Workflows** - YAML-based workflow templates
- ✅ **Policy Enforcement** - Automatic validation using ALD policies
- 🔌 **MCP Auto-Injection** - Keywords trigger MCP usage automatically
- 🚀 **TDD by Default** - Red-Green-Refactor cycle for quality code
- 📊 **Unified Reporting** - Aggregates results across all plugins

**3 Commands:**
- `/nexus` - Invoke orchestrator for intelligent workflow management
- `/nexus-setup` - Auto-install dependencies (ALD System, Superpowers, MCPs)
- `/nexus-update` - Check and install updates from GitHub

---

## 🚀 Installation

### One-Line Install (Both Plugins)

```bash
/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES
```

This installs **both** ALD System and Nexus with a single command!

### Verify Installation

```bash
/plugin menu
```

You should see:
- ✅ **ald-system** (8 skills)
- ✅ **nexus** (3 commands)

---

## 📚 Quick Start

### Using ALD System

```bash
# Invoke any ALD skill automatically
# Skills are used automatically by Claude based on context

# Example workflow:
# 1. Start a task → ald-memory loads project context
# 2. Implement code → ald-policies enforces 155 policies
# 3. Validate → ald-tester checks as end user
# 4. Learn → ald-curator extracts patterns
```

### Using Nexus

```bash
# Orchestrate complex workflows
/nexus implement checkout with Stripe

# Setup dependencies
/nexus-setup

# Check for updates
/nexus-update
```

---

## 📖 Documentation

### ALD System
- **Main Docs**: `plugins/ald-system/README.md`
- **System Controller**: `plugins/ald-system/CLAUDE.md`
- **Skill Entry Point**: `plugins/ald-system/SKILL.md`
- **Migration Guide**: `plugins/ald-system/docs/MIGRATION.md`
- **Enforcement Guide**: `plugins/ald-system/docs/HOW_TO_ENFORCE_ALD.md`

### Nexus
- **Main Docs**: `plugins/nexus/README.md`
- **Skill Entry Point**: `plugins/nexus/SKILL.md`
- **Workflow Templates**: `plugins/nexus/workflows/`
- **MCP Integration**: `plugins/nexus/MCP-INTEGRATION.md`
- **Integration Tests**: `plugins/nexus/INTEGRATION-TESTS.md`

---

## 🔄 How They Work Together

```
User Task → Nexus (Orchestrator)
              ↓
         Analyze Intent
              ↓
      Select Workflow
              ↓
    ┌─────────┴─────────┐
    ↓                   ↓
Superpowers          ALD System
(Brainstorm,      (Memory, Policies,
 Planning,         Testing, Learning)
 TDD, Review)
    ↓                   ↓
    └─────────┬─────────┘
              ↓
      Unified Result
```

**Nexus** coordinates the workflow, **Superpowers** provides structured methodologies, and **ALD** enforces policies and validates quality.

---

## 🎯 Features

### ALD System Features
- ✅ 155 validated policies across 17 categories
- ✅ Persistent memory across conversations
- ✅ Sprint management with scope isolation
- ✅ E2E validation (console, network, UX)
- ✅ Continuous learning via curator
- ✅ Intelligent policy search
- ✅ Policy-aware code review

### Nexus Features
- ✅ Intent detection → workflow selection
- ✅ Multi-plugin coordination (Superpowers + ALD + MCPs)
- ✅ Declarative YAML workflows
- ✅ Policy enforcement
- ✅ MCP auto-injection
- ✅ TDD by default
- ✅ Unified reporting
- ✅ Auto-update system

---

## 🛠️ Technology Stack

**Languages**: Markdown (Skills), YAML (Workflows), JSON (Config)

**Integrations**:
- Claude Code plugin system
- Superpowers marketplace (optional)
- MCP servers (Supabase, GitHub, Chrome DevTools, etc.)

---

## 📊 Quality Gates

Task is only complete when (enforced by ALD):
- ✅ Tests passing
- ✅ Console clean (0 errors)
- ✅ Network requests OK
- ✅ UX validated
- ✅ Policies followed
- ✅ Zero regressions
- ✅ Edge cases handled
- ✅ Performance acceptable
- ✅ Accessibility working

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Reporting issues
- Submitting PRs
- Adding new policies
- Creating workflows
- Testing changes

---

## 📝 License

MIT License - Copyright (c) 2025 dirgogoo

See [LICENSE](LICENSE) for details.

---

## 📦 Version Information

**Marketplace Version**: 1.0.0
- **ALD System**: v1.3.3
- **Nexus**: v1.1.3

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## 🔗 Links

- **Repository**: https://github.com/dirgogoo/HMC-TECHNOLOGIES
- **Issues**: https://github.com/dirgogoo/HMC-TECHNOLOGIES/issues
- **Individual Plugin Repos** (deprecated):
  - ALD System: https://github.com/dirgogoo/ald-system
  - Nexus: https://github.com/dirgogoo/nexus

---

## ⚡ Why Use This Marketplace?

1. **Single Command Install** - One line installs everything
2. **Unified System** - ALD + Nexus work together seamlessly
3. **Production Ready** - 155 validated policies + tested workflows
4. **Self-Improving** - Curator learns from your patterns
5. **Quality Focused** - Zero compromises on code quality
6. **Community Standard** - Follows Claude Code marketplace patterns

---

**Made with ❤️ by dirgogoo**
