# HMC Technologies

**AI-Powered Development System for Claude Code**

A complete development system combining ALD (Autonomous Learning & Development) with Nexus (Master Workflow Orchestrator) - ready to install directly into your `~/.claude/` directory.

> **v3.0.0**: Now available as **direct installation** - no marketplace required. Install once, use forever.

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
- `/nexus [task]` - Invoke orchestrator for intelligent workflow management

---

## 🚀 Installation

### Automated Installation (Recommended)

```bash
# Clone repository
git clone https://github.com/dirgogoo/HMC-TECHNOLOGIES.git
cd HMC-TECHNOLOGIES

# Run installer
./install.sh
```

The installer will:
- ✅ Backup any existing installation
- ✅ Install commands to `~/.claude/commands/`
- ✅ Install skills to `~/.claude/skills/`
- ✅ Install config to `~/.claude/config/`
- ✅ Install hooks to `~/.claude/hooks/`
- ✅ Set correct permissions
- ✅ Verify installation

### Manual Installation

If you prefer manual control:

```bash
# Clone repository
git clone https://github.com/dirgogoo/HMC-TECHNOLOGIES.git
cd HMC-TECHNOLOGIES

# Copy commands
cp -r commands/* ~/.claude/commands/

# Copy skills
cp -r skills/* ~/.claude/skills/

# Copy config
mkdir -p ~/.claude/config/i18n
cp config/defaults.yml ~/.claude/config/
cp config/i18n/* ~/.claude/config/i18n/

# Copy hooks
mkdir -p ~/.claude/hooks
cp hooks/hooks.json ~/.claude/hooks/
cp hooks/session-start.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/session-start.sh
```

### Verify Installation

```bash
ls ~/.claude/commands/nexus.md
ls ~/.claude/skills/nexus/
ls ~/.claude/config/defaults.yml
ls ~/.claude/hooks/hooks.json
```

All files should exist. Restart Claude Code and you're ready!

---

## 📚 Quick Start

### Using ALD System

```bash
# Skills are invoked automatically by Claude based on context

# Example workflow (automatic):
# 1. Start a task → ald-memory loads project context
# 2. Implement code → ald-policies enforces 155 policies
# 3. Validate → ald-tester checks as end user
# 4. Learn → ald-curator extracts patterns
```

### Using Nexus

```bash
# Orchestrate complex workflows
/nexus implement checkout with Stripe

# Nexus will:
# 1. Analyze intent (feature-development, high complexity)
# 2. Suggest workflow (feature-full.yml)
# 3. Ask for confirmation
# 4. Coordinate: Brainstorm → Plan → Load Context → Execute → Validate → Review
# 5. Return unified report
```

### Available Workflows

**Feature Development:**
- `feature-full.yml` - Complex features with brainstorming (60-120 min)
- `feature-quick.yml` - Medium features with planning (30-45 min)
- `feature-tdd.yml` - TDD-focused development (45-90 min)

**Maintenance:**
- `bugfix.yml` - Bug fixes with root cause analysis (10-20 min)
- `hotfix.yml` - Emergency fixes, minimal steps (5-10 min)
- `refactor.yml` - Code refactoring with quality focus (20-40 min)
- `chore.yml` - Maintenance tasks (dependencies, config) (5-15 min)

**Quality:**
- `code-review.yml` - Policy compliance review (5-10 min)
- `documentation.yml` - Documentation improvements (10-20 min)

**Special:**
- `migration.yml` - Database migrations (15-30 min)
- `performance.yml` - Performance optimization (30-60 min)
- `spike.yml` - Research and prototyping (variable)

---

## 📖 Documentation

### Comprehensive Docs

- **Nexus Orchestrator**: `~/.claude/skills/nexus/README.md` (785 lines)
- **ALD Policies**: `~/.claude/skills/ald-policies/policies/` (155 policies)
- **Sprint System**: `~/.claude/skills/ald-sprint/README.md`
- **Workflows**: `~/.claude/skills/nexus/workflows/` (12 YAML files)

### Directory Structure

```
~/.claude/
├── commands/
│   └── nexus.md                 # /nexus command
├── config/
│   ├── defaults.yml             # 200+ configuration settings
│   └── i18n/
│       ├── pt-BR.yml            # Brazilian Portuguese
│       └── en-US.yml            # US English
├── hooks/
│   ├── hooks.json               # Hook configuration
│   └── session-start.sh         # Welcome message
└── skills/                      # 9 auto-discovered skills
    ├── ald-memory/
    ├── ald-policies/
    ├── ald-curator/
    ├── ald-tester/
    ├── ald-orchestrator/
    ├── ald-sprint/
    ├── ald-policy-finder/
    ├── ald-code-reviewer/
    └── nexus/                   # Master orchestrator
        ├── SKILL.md             # Executable skill
        ├── workflows/           # 12 workflows
        ├── docs/                # Architecture
        └── config/              # Nexus-specific config
```

---

## 🔧 Configuration

### Global Settings

Edit `~/.claude/config/defaults.yml` to customize:

```yaml
# Language
locale:
  default: "pt-BR"              # pt-BR | en-US
  fallback: "en-US"

# Nexus behavior
nexus:
  default_workflow: "feature-quick"
  auto_confirm_simple_tasks: false
  show_workflow_details: true

# ALD System
plugins:
  ald:
    enabled: true
    always_use_policies: true
    auto_load_memory: true
    sprint_validation: true

# Output
output:
  verbose: false
  show_policy_ids: true
  use_emojis: true
```

---

## 🗑️ Uninstallation

### Automated Uninstall

```bash
cd HMC-TECHNOLOGIES
./uninstall.sh
```

The uninstaller will:
- ✅ Backup all user data (memory, sprints, learnings)
- ✅ Remove HMC Technologies files
- ✅ Keep Claude Code installation intact
- ✅ Provide restore instructions

### Manual Uninstall

```bash
# Backup user data first
mkdir -p ~/hmc-backup
cp -r ~/.claude/skills/ald-memory/memory ~/hmc-backup/
cp -r ~/.claude/skills/ald-sprint/active ~/hmc-backup/
cp -r ~/.claude/skills/ald-curator ~/hmc-backup/

# Remove HMC files
rm ~/.claude/commands/nexus.md
rm -rf ~/.claude/skills/ald-*
rm -rf ~/.claude/skills/nexus
rm ~/.claude/config/defaults.yml
rm -rf ~/.claude/config/i18n
rm ~/.claude/hooks/hooks.json
rm ~/.claude/hooks/session-start.sh
```

---

## 🆘 Support

### Issues & Questions

- **GitHub Issues**: https://github.com/dirgogoo/HMC-TECHNOLOGIES/issues
- **Discussions**: https://github.com/dirgogoo/HMC-TECHNOLOGIES/discussions

### Common Issues

**Problem**: `/nexus command not found`
- **Solution**: Restart Claude Code after installation

**Problem**: Skills not loading
- **Solution**: Check file permissions: `chmod +x ~/.claude/hooks/session-start.sh`

**Problem**: Policies not enforcing
- **Solution**: Check config: `~/.claude/config/defaults.yml` → `plugins.ald.enabled: true`

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🎯 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📊 Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

**Current Version**: v3.0.0 (Direct Installation)

---

## 🌟 Features at a Glance

| Feature | ALD System | Nexus | Combined |
|---------|-----------|-------|----------|
| Workflow Orchestration | ✅ Basic | ✅ Advanced | ✅✅ Multi-Plugin |
| Policy Enforcement | ✅ 155 Policies | ✅ Auto-Applied | ✅✅ Comprehensive |
| Memory System | ✅ Persistent | ✅ Workflow State | ✅✅ Full Context |
| Sprint Management | ✅ Scope Isolation | ✅ Workflow Integration | ✅✅ Complete Lifecycle |
| Testing | ✅ E2E Validation | ✅ Phase Validation | ✅✅ Multi-Level |
| Learning | ✅ Pattern Detection | ✅ Workflow Optimization | ✅✅ Continuous Improvement |
| Multi-Language | ❌ | ✅ pt-BR + EN | ✅ Full i18n |
| MCP Integration | ✅ Policy-Based | ✅ Auto-Injection | ✅✅ Seamless |

---

**Built with ❤️ by dirgogoo**
