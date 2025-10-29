# HMC Technologies Marketplace

**AI-Powered Development System for Claude Code**

A unified skills-based marketplace combining powerful development tools: ALD System (Autonomous Learning & Development) and Nexus (Master Workflow Orchestrator).

> **Note**: As of v2.0.0, this marketplace follows a **flat skills-based structure** using the Superpowers pattern. All skills are auto-discovered from the `skills/` directory.

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

### 2. **Nexus** (v2.0.0)
**Master Workflow Orchestrator**

- 🎯 **Intent Detection** - Analyzes tasks to select optimal workflows
- 🔄 **Multi-Plugin Coordination** - Seamlessly coordinates Superpowers + ALD + MCPs
- 📋 **Declarative Workflows** - 12 YAML-based workflow templates
- ✅ **Policy Enforcement** - Automatic validation using ALD policies
- 🔌 **MCP Auto-Injection** - Keywords trigger MCP usage automatically
- 🚀 **TDD by Default** - Red-Green-Refactor cycle for quality code
- 📊 **Unified Reporting** - Aggregates results across all plugins
- 🌍 **Multi-Language** - Brazilian Portuguese + US English (i18n)
- 🎨 **SessionStart Hook** - Welcome message on startup

**Command:**
- `/nexus:execute [task]` - Invoke orchestrator for intelligent workflow management

---

## 🚀 Installation

### One-Line Install

```bash
/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES
```

This installs the entire marketplace with all skills!

### Verify Installation

```bash
/plugin menu
```

You should see:
- ✅ **HMC Technologies Marketplace** (9 skills total)
  - 8 ALD skills (ald-memory, ald-policies, ald-curator, etc.)
  - 1 Nexus orchestrator skill
- ✅ **Commands**: `/nexus:execute`
- ✅ **Hooks**: SessionStart (welcome message)

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
/nexus:execute implement checkout with Stripe

# Or simply use /nexus (activates nexus skill automatically)
/nexus implement user authentication

# Nexus automatically:
# 1. Detects intent (feature, bugfix, hotfix, etc.)
# 2. Selects optimal workflow
# 3. Coordinates Superpowers + ALD + MCPs
# 4. Presents workflow for confirmation
# 5. Executes phases and aggregates results
```

---

## 📖 Documentation

### Marketplace Structure (v2.0.0)
```
hmc-marketplace/
├── commands/                 # Slash commands
│   └── execute.md           # /nexus:execute command
├── hooks/                   # Event hooks
│   ├── hooks.json           # Hook configuration
│   └── session-start.sh     # SessionStart welcome message
├── config/                  # Global configuration
│   ├── defaults.yml         # 200+ settings
│   └── i18n/                # Multi-language support
│       ├── pt-BR.yml        # Brazilian Portuguese
│       └── en-US.yml        # US English
└── skills/                  # Auto-discovered skills
    ├── ald-memory/          # ALD System skills (8 total)
    ├── ald-policies/
    ├── ald-curator/
    ├── ald-tester/
    ├── ald-orchestrator/
    ├── ald-sprint/
    ├── ald-policy-finder/
    ├── ald-code-reviewer/
    └── nexus/               # Nexus orchestrator
        ├── SKILL.md         # Executable orchestrator skill
        ├── workflows/       # 12 workflow templates
        ├── docs/            # Technical documentation
        ├── plugins/         # Internal plugin registry
        └── config/          # Nexus-specific config
```

### ALD System
- **Main Docs**: `skills/ald-memory/README.md` (and other ald-* skills)
- **System Controller**: `skills/ald-memory/CLAUDE.md`
- **Enforcement Guide**: `skills/ald-memory/docs/HOW_TO_ENFORCE_ALD.md`

### Nexus
- **Main Docs**: `skills/nexus/README.md`
- **Skill Entry Point**: `skills/nexus/SKILL.md` (executable orchestrator)
- **Workflow Templates**: `skills/nexus/workflows/` (12 workflows)
- **MCP Integration**: `skills/nexus/MCP-INTEGRATION.md`
- **Integration Tests**: `skills/nexus/INTEGRATION-TESTS.md`
- **Changelog**: `skills/nexus/CHANGELOG.md`
- **Contributing**: `skills/nexus/CONTRIBUTING.md`

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

**Marketplace Version**: 2.0.0 (Flat Structure)
- **ALD System**: v1.3.3 (8 skills)
- **Nexus**: v2.0.0 (orchestrator skill)

**Breaking Changes in v2.0.0**:
- Migrated from nested `plugins/` to flat `skills/` structure
- Command renamed: `/nexus:nexus` → `/nexus:execute`
- Auto-discovery replaces marketplace.json registry
- Added hooks system (SessionStart welcome message)
- Added global config (200+ settings, i18n support)

See [skills/nexus/CHANGELOG.md](skills/nexus/CHANGELOG.md) for complete version history.

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
6. **Community Standard** - Follows Superpowers flat marketplace pattern
7. **Multi-Language** - Brazilian Portuguese + US English (i18n)
8. **Smart Hooks** - SessionStart welcome message shows capabilities

---

**Made with ❤️ by dirgogoo**
