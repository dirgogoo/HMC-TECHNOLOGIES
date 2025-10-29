# Contributing to Nexus

Thank you for your interest in contributing to Nexus! This document provides guidelines and instructions for contributing.

---

## 🎯 How to Contribute

### Reporting Bugs

**Before submitting**:
1. Check [existing issues](https://github.com/dirgogoo/nexus/issues)
2. Verify you're using the latest version
3. Reproduce the bug with minimal steps

**Bug report template**:
```markdown
**Description**: Brief description of the bug

**Steps to Reproduce**:
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior**: What should happen

**Actual Behavior**: What actually happens

**Environment**:
- Nexus version: 1.1.0
- Claude Code version: X.X.X
- OS: Windows/Mac/Linux

**Logs**: (if applicable)
```

### Suggesting Features

**Feature request template**:
```markdown
**Problem**: What problem does this solve?

**Proposed Solution**: How would you solve it?

**Alternatives Considered**: Other approaches you thought about

**Additional Context**: Mockups, examples, related issues
```

### Pull Requests

1. **Fork** the repository
2. **Create branch**: `git checkout -b feature/your-feature-name`
3. **Make changes**: Follow coding standards (see below)
4. **Test**: Ensure everything works
5. **Commit**: Use conventional commits (see below)
6. **Push**: `git push origin feature/your-feature-name`
7. **Open PR**: Use PR template

---

## 📝 Development Guidelines

### Code Style

**YAML (Workflows)**:
```yaml
# Use 2-space indentation
name: "Workflow Name"
description: "Brief description"

phases:
  - id: "phase-id"
    name: "Phase Name"
    plugin: "plugin-name"
```

**Markdown (Documentation)**:
- Use headers hierarchically (H1 → H2 → H3)
- Code blocks with language tags
- Bullet points with `-` (not `*`)
- Max line length: 120 characters

**File Headers**:
```yaml
# File: filename.yml
# Purpose: Brief description
# Created: YYYY-MM-DD
# Updated: YYYY-MM-DD
```

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add workflow visualization
fix: correct MCP auto-detection bug
docs: update README with new examples
refactor: simplify intent detection logic
test: add integration tests for MCP injection
chore: update dependencies
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

**Scope (optional)**:
```
feat(mcp): add auto-retry for failed MCPs
fix(workflows): correct phase dependency order
docs(setup): clarify MCP installation steps
```

### Branch Naming

```
feature/workflow-visualization
fix/mcp-detection-bug
docs/contributing-guide
refactor/orchestrator-simplification
```

---

## 🔧 Development Setup

### 1. Clone Repository

```bash
git clone https://github.com/dirgogoo/nexus
cd nexus
```

### 2. Install to Claude Code

```bash
# Copy to Claude Code skills directory
cp -r . ~/.claude/skills/nexus
```

### 3. Test

```bash
# In Claude Code
/nexus review my code
```

---

## 🧪 Testing

### Manual Testing

Before submitting PR, test these scenarios:

1. **Intent Detection**:
   ```bash
   /nexus implement feature X
   /nexus fix bug Y
   /nexus refactor component Z
   /nexus review my code
   ```
   Verify correct workflow selected.

2. **Workflow Execution**:
   - Test each workflow (feature-full, feature-quick, bugfix, refactor, code-review)
   - Verify all phases execute correctly
   - Check error handling

3. **MCP Auto-Injection**:
   ```bash
   /nexus implement UI component
   # Verify Chrome DevTools MCP auto-injected

   /nexus create migration add_table
   # Verify Supabase MCP auto-injected
   ```

4. **Policy Enforcement**:
   - Verify MANDATORY MCPs cannot be skipped
   - Check policy compliance in code-review phase

### Integration Tests

Run validation tests:
```bash
# See INTEGRATION-TESTS.md for complete test suite
```

---

## 📖 Adding New Features

### Adding a New Workflow

1. **Create YAML** in `workflows/`:
   ```yaml
   # workflows/my-workflow.yml
   name: "My Workflow"
   description: "Description of what this workflow does"
   triggers:
     keywords: ["keyword1", "keyword2"]
     complexity: "small" | "medium" | "large"

   phases:
     - id: "phase-id"
       name: "Phase Name"
       plugin: "plugin-name"
       hook: "hook-name"
   ```

2. **Document** in README.md
3. **Test** with `/nexus [trigger keywords]`
4. **Submit PR** with examples

### Adding MCP Plugin

1. **Create plugin.yml** in `plugins/mcp-[name]/`:
   ```yaml
   name: "mcp-[name]"
   description: "What this MCP does"
   version: "1.0.0"
   type: "mcp"

   mcp_config:
     server_name: "[mcp-server-name]"
     prefix: "mcp__[service]__"
     auto_detect: true
     priority: [10-99]

   hooks:
     - name: "[hook-name]"
       description: "What this hook does"
       mcp_tools: ["tool1", "tool2"]
       workflow_phases: ["execute", "validate"]

   auto_triggers:
     keywords:
       - trigger: ["keyword1", "keyword2"]
         hooks: ["hook1", "hook2"]
         mandatory: true | false
   ```

2. **Register** in `plugins/registry.json`
3. **Document** in MCP-INTEGRATION.md
4. **Create setup guide** in `docs/mcp-setup/[name].md`
5. **Submit PR**

### Updating Documentation

1. **README.md**: High-level overview, quick start
2. **SKILL.md**: Complete orchestrator documentation
3. **Core docs** (`core/*.md`): Technical implementation details
4. **MCP-INTEGRATION.md**: MCP system documentation
5. **CHANGELOG.md**: Version history

---

## 📊 Project Structure

```
nexus/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── commands/
│   ├── nexus.md             # /nexus command
│   └── nexus-setup.md       # /nexus-setup command
├── core/
│   ├── intent-detector.md   # Intent detection algorithm
│   ├── workflow-engine.md   # Workflow selection logic
│   ├── orchestrator.md      # Plugin coordination
│   ├── mcp-detector.md      # MCP auto-discovery
│   ├── mcp-injector.md      # MCP hook injection
│   └── state-manager.md     # State tracking
├── workflows/
│   ├── feature-full.yml     # Complex features
│   ├── feature-quick.yml    # Medium features
│   ├── bugfix.yml           # Quick fixes
│   ├── refactor.yml         # Refactoring
│   ├── code-review.yml      # Review only
│   └── EXAMPLE-enhanced-workflow.yml
├── plugins/
│   ├── registry.json        # Plugin registry
│   ├── ald/                 # ALD plugin metadata
│   ├── superpowers/         # Superpowers metadata
│   ├── mcp-supabase/        # Supabase MCP
│   ├── mcp-chrome-devtools/ # Chrome DevTools MCP
│   ├── mcp-episodic-memory/ # Memory MCP
│   └── mcp-github/          # GitHub MCP
├── config/
│   ├── defaults.yml         # Default configuration
│   └── user-preferences.template.yml
├── docs/
│   └── mcp-setup/          # MCP setup guides
├── SKILL.md                 # Main skill file
├── README.md                # Project overview
├── MCP-INTEGRATION.md       # MCP documentation
├── INTEGRATION-TESTS.md     # Test suite
├── CHANGELOG.md             # Version history
├── CONTRIBUTING.md          # This file
└── LICENSE                  # MIT License
```

---

## 🚀 Release Process

### Version Numbering

- **Major (X.0.0)**: Breaking changes
- **Minor (1.X.0)**: New features (backward compatible)
- **Patch (1.0.X)**: Bug fixes

### Release Checklist

1. Update version in:
   - `.claude-plugin/plugin.json`
   - `README.md`
   - `CHANGELOG.md`

2. Test all workflows:
   - feature-full, feature-quick, bugfix, refactor, code-review
   - MCP auto-injection
   - Policy enforcement

3. Update documentation:
   - README.md (if features added)
   - CHANGELOG.md (version entry)
   - MCP-INTEGRATION.md (if MCP changes)

4. Create release:
   ```bash
   git tag -a v1.X.0 -m "Version 1.X.0"
   git push origin v1.X.0
   ```

5. Create GitHub Release:
   - Copy CHANGELOG entry
   - Attach any assets
   - Publish

---

## 💬 Communication

- **Issues**: https://github.com/dirgogoo/nexus/issues
- **Discussions**: https://github.com/dirgogoo/nexus/discussions
- **Pull Requests**: https://github.com/dirgogoo/nexus/pulls

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## 🙏 Recognition

Contributors will be recognized in:
- README.md (Contributors section)
- CHANGELOG.md (version entries)
- GitHub contributor graph

---

**Thank you for contributing to Nexus!** 🚀

CLAUDE.MD ATIVO
