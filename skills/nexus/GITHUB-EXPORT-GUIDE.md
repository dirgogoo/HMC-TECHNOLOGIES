# GitHub Export Guide - Nexus Plugin

**Repository**: https://github.com/dirgogoo/nexus
**Status**: ✅ Ready to Export
**Version**: 1.1.0

---

## ✅ Files Created

The following files have been created for GitHub export:

### Core Plugin Files
- ✅ `.claude-plugin/plugin.json` - Plugin metadata and dependencies
- ✅ `.gitignore` - Git ignore rules
- ✅ `commands/nexus.md` - /nexus slash command
- ✅ `commands/nexus-setup.md` - /nexus-setup auto-installer
- ✅ `LICENSE` - MIT License
- ✅ `CHANGELOG.md` - Version history
- ✅ `CONTRIBUTING.md` - Contribution guidelines
- ✅ `README-GITHUB.md` - GitHub-ready README

### Existing Files (Already in Nexus)
- ✅ `SKILL.md` - Main orchestrator skill
- ✅ `README.md` - Current documentation (will be replaced)
- ✅ `MCP-INTEGRATION.md` - MCP documentation
- ✅ `INTEGRATION-TESTS.md` - Test suite
- ✅ `core/*.md` - 6 core documentation files
- ✅ `workflows/*.yml` - 7 workflow files
- ✅ `plugins/` - Plugin metadata and registry
- ✅ `config/` - Configuration templates

---

## 📋 Next Steps

### Step 1: Prepare Local Repository

```bash
# Navigate to Nexus directory
cd C:\Users\conta\.claude\skills\nexus

# Initialize git (if not already)
git init

# Replace README.md with GitHub version
mv README.md README-LOCAL.md
mv README-GITHUB.md README.md

# Stage all files
git add .

# Create initial commit
git commit -m "feat: initial release v1.1.0

- Master workflow orchestrator
- MCP auto-injection system
- ALD System integration (155 policies)
- Superpowers coordination
- 5 pre-built workflows
- TDD by default

See CHANGELOG.md for full details"
```

### Step 2: Link to GitHub Repository

```bash
# Add remote origin
git remote add origin https://github.com/dirgogoo/nexus.git

# Verify remote
git remote -v

# Expected output:
# origin  https://github.com/dirgogoo/nexus.git (fetch)
# origin  https://github.com/dirgogoo/nexus.git (push)
```

### Step 3: Push to GitHub

```bash
# Push to main branch
git branch -M main
git push -u origin main

# Create and push version tag
git tag -a v1.1.0 -m "Version 1.1.0 - MCP Integration + TDD by Default"
git push origin v1.1.0
```

### Step 4: Create GitHub Release

1. Go to https://github.com/dirgogoo/nexus/releases
2. Click "Draft a new release"
3. Tag version: `v1.1.0`
4. Release title: `Nexus v1.1.0 - MCP Integration + TDD`
5. Description (copy from CHANGELOG.md):

```markdown
## ⭐ Major Features

### MCP Integration
- **MCP Auto-Detection**: Automatically discovers available MCP servers
- **MCP Auto-Injection**: Keywords trigger MCP usage (zero manual invocation)
- **Policy Enforcement**: MANDATORY MCPs cannot be skipped
- **4 MCP Plugins**: Supabase, Chrome DevTools, Episodic Memory, GitHub

### TDD by Default
- Red-Green-Refactor cycle integrated into all feature workflows
- Test-first development enforced

## 🚀 Quick Start

```bash
/plugin install https://github.com/dirgogoo/nexus
/nexus-setup
/nexus implement [your task]
```

**Full Changelog**: https://github.com/dirgogoo/nexus/blob/main/CHANGELOG.md
```

6. Click "Publish release"

---

## 🧪 Step 5: Test Installation

### From GitHub URL

```bash
# In Claude Code
/plugin install https://github.com/dirgogoo/nexus

# Expected: Nexus plugin installed successfully

# Run setup
/nexus-setup

# Expected: ALD System + Superpowers installed

# Test
/nexus review my code

# Expected: Nexus orchestrates code review workflow
```

### Troubleshooting

**If installation fails**:
1. Check repository is public
2. Verify `.claude-plugin/plugin.json` exists
3. Ensure `main` branch is default

**If setup fails**:
1. Check `commands/nexus-setup.md` exists
2. Verify ALD skills are bundled (see Step 6)
3. Run manual installation (see SETUP-GUIDE.md)

---

## 📦 Step 6: Bundle ALD System (IMPORTANT)

**Current Status**: ALD System is **NOT yet bundled** in the repository.

**Why**: The current implementation assumes ALD skills exist at `~/.claude/skills/ald-*/`. For GitHub export, we need to bundle them in `templates/ald-system/`.

### Option A: Bundle ALD System Now (Recommended)

```bash
# Create templates directory
mkdir -p templates/ald-system

# Copy all ALD skills
cp -r C:\Users\conta\.claude\skills\ald-* templates/ald-system/
cp C:\Users\conta\.claude\skills\CLAUDE.md templates/ald-system/
cp C:\Users\conta\.claude\skills\README.md templates/ald-system/

# Stage and commit
git add templates/
git commit -m "feat: bundle ALD System in templates

- 8 ALD skills (memory, policies, curator, tester, reviewer, orchestrator, policy-finder, sprint)
- 155 policies across 17 categories
- CLAUDE.md controller
- Enables /nexus-setup to auto-install ALD"

# Push
git push origin main
```

### Option B: Defer ALD Bundling (Quick Export)

Keep current structure and update `commands/nexus-setup.md` to provide manual installation instructions for ALD System:

```markdown
## ALD System Installation

**Note**: ALD System is not bundled. Install manually:

1. Clone ALD repository: `git clone https://github.com/[your-ald-repo]`
2. Copy skills to `~/.claude/skills/`
3. Verify with `/skill ald-memory`
```

**Recommendation**: Choose Option A for best user experience.

---

## 📚 Step 7: Update Documentation

### Add to GitHub Repository Description

```
Master workflow orchestrator for Claude Code - Coordinates Superpowers, ALD, and MCP plugins with intelligent intent detection, policy enforcement, and continuous learning.
```

### Add Topics (Keywords)

```
claude-code
workflow-orchestrator
automation
ai-coordination
mcp-integration
policy-enforcement
tdd
development-workflow
superpowers
ald-system
```

### Add README Badges (Optional)

```markdown
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/dirgogoo/nexus/releases)
[![Status](https://img.shields.io/badge/status-production--ready-brightgreen.svg)](https://github.com/dirgogoo/nexus)
```

---

## 🎯 Step 8: Post-Release Tasks

### 1. Announce Release
- [ ] Post in Claude Code community
- [ ] Share on relevant forums/Discord
- [ ] Tweet about release (if applicable)

### 2. Monitor Issues
- [ ] Check for installation issues
- [ ] Respond to bug reports within 24 hours
- [ ] Label issues appropriately

### 3. Update Marketplace (if applicable)
- [ ] Submit to Claude Code plugin marketplace
- [ ] Provide screenshots/demos
- [ ] Include setup video

---

## 📊 Repository Structure (Final)

```
nexus/
├── .claude-plugin/
│   └── plugin.json
├── .gitignore
├── LICENSE
├── README.md (GitHub version)
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SKILL.md
├── MCP-INTEGRATION.md
├── INTEGRATION-TESTS.md
├── commands/
│   ├── nexus.md
│   └── nexus-setup.md
├── core/
│   ├── intent-detector.md
│   ├── workflow-engine.md
│   ├── orchestrator.md
│   ├── mcp-detector.md
│   ├── mcp-injector.md
│   └── state-manager.md
├── workflows/
│   ├── feature-full.yml
│   ├── feature-quick.yml
│   ├── bugfix.yml
│   ├── refactor.yml
│   ├── code-review.yml
│   └── EXAMPLE-enhanced-workflow.yml
├── plugins/
│   ├── registry.json
│   ├── ald/
│   ├── superpowers/
│   ├── superpowers-dev/
│   ├── mcp-supabase/
│   ├── mcp-chrome-devtools/
│   ├── mcp-episodic-memory/
│   └── mcp-github/
├── config/
│   ├── defaults.yml
│   └── user-preferences.template.yml
├── templates/             # ⚠️ TO BE ADDED
│   └── ald-system/        # Bundle ALD skills here
│       ├── ald-memory/
│       ├── ald-policies/
│       ├── ald-curator/
│       ├── ald-tester/
│       ├── ald-code-reviewer/
│       ├── ald-orchestrator/
│       ├── ald-policy-finder/
│       ├── ald-sprint/
│       ├── CLAUDE.md
│       └── README.md
└── docs/                  # ⚠️ TO BE ADDED (optional)
    ├── mcp-setup/
    │   ├── supabase.md
    │   ├── chrome-devtools.md
    │   ├── github.md
    │   └── episodic-memory.md
    └── extending-nexus.md
```

---

## ✅ Validation Checklist

Before pushing to GitHub, verify:

- [ ] `.claude-plugin/plugin.json` has correct repository URL
- [ ] `LICENSE` file exists (MIT)
- [ ] `README.md` has GitHub-ready content
- [ ] `CHANGELOG.md` is complete for v1.1.0
- [ ] `CONTRIBUTING.md` provides clear guidelines
- [ ] `.gitignore` prevents committing user data
- [ ] All existing documentation files are included
- [ ] `commands/nexus-setup.md` installation logic is complete
- [ ] ALD System is bundled in `templates/` (or documented for manual install)
- [ ] Version numbers are consistent across files (1.1.0)

---

## 🚀 Ready to Export!

**Current Status**: ✅ Core files ready, ⚠️ ALD bundling pending

**Recommended Next Action**:
1. Bundle ALD System (Step 6 - Option A)
2. Commit and push to GitHub (Steps 1-3)
3. Create GitHub release (Step 4)
4. Test installation (Step 5)

**Estimated Time**: 30-45 minutes (including ALD bundling)

---

## 📞 Need Help?

If you encounter issues during export:
1. Check `.git/config` for correct remote URL
2. Verify GitHub repository permissions
3. Test with a minimal commit first
4. Review Git/GitHub documentation

---

**Good luck with the export!** 🎉

CLAUDE.MD ATIVO
