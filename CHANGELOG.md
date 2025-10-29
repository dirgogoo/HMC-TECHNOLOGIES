# Changelog

All notable changes to HMC Technologies will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [3.0.0] - 2025-10-29

### 🚨 BREAKING CHANGE: Direct Installation Model

**Complete restructuring from marketplace-based to direct user installation.**

This is a **major breaking change** - the entire installation model has changed. Users must uninstall v2.x and reinstall v3.0.

#### Migration Path

**From v2.x (Marketplace)**:
```bash
# Old installation (no longer supported)
/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES
```

**To v3.0 (Direct Installation)**:
```bash
# New installation
git clone https://github.com/dirgogoo/HMC-TECHNOLOGIES.git
cd HMC-TECHNOLOGIES
./install.sh
```

### Added

- **install.sh** - Automated installer with backup support
- **uninstall.sh** - Clean uninstaller with user data backup
- **README.md** - Completely rewritten for direct installation
- **.gitignore** - Ignore user-generated data directories

### Changed

- **Installation Model**: Marketplace → Direct `~/.claude/` installation
- **Repository Focus**: From marketplace container to installable system
- **config/defaults.yml**: Updated repository URL to reflect new structure
- **Version**: Bumped to 3.0.0 to reflect breaking changes

### Removed

- **.claude-plugin/** directory - No longer marketplace-based
- **marketplace.json** - Not needed for direct installation
- **plugin.json** - Not needed for direct installation
- **CONTRIBUTING.md** - Will be recreated if needed
- **lib/** - Empty directory removed

### Why This Change?

The marketplace model added unnecessary complexity:
- Users faced installation errors (plugin not found, schema issues)
- Cache conflicts between versions
- Dependency on Claude Code marketplace infrastructure
- Limited control over installation location

**Direct installation benefits**:
- ✅ Complete control - install once, use forever
- ✅ No marketplace dependencies
- ✅ Easier debugging - files visible in `~/.claude/`
- ✅ Simpler updates - just `git pull` and reinstall
- ✅ Better backup - direct access to user data
- ✅ Cross-platform - works anywhere Claude Code runs

---

## [2.0.0] - 2025-10-29

### 🚀 Marketplace Restructuring (DEPRECATED)

**Note**: This version is deprecated. Use v3.0.0 instead.

### Added
- Flat skills-based marketplace structure (Superpowers pattern)
- `.claude-plugin/marketplace.json` + `plugin.json`
- `hooks/hooks.json` + SessionStart hook
- `config/defaults.yml` + i18n (pt-BR, en-US)
- 12 workflows including new `chore.yml`

### Removed
- Nested `plugins/` structure (134 files)
- Legacy marketplace files

---

## [1.0.0] - 2025-10-29

### 🎉 Initial Release

**First unified marketplace release combining ALD System and Nexus!**

### Added

#### Marketplace Structure
- Created unified marketplace repository
- Central `.claude-plugin/marketplace.json` registering both plugins
- Single-command installation: `/plugin marketplace add dirgogoo/marketplace`
- Comprehensive README with installation and usage guides
- CONTRIBUTING.md with development guidelines
- MIT License
- This CHANGELOG

#### Plugins Included

**ALD System v1.3.3** - Autonomous Learning & Development
- 8 specialized skills:
  - `ald-memory` - Persistent context management
  - `ald-policies` - 155 validated policies (17 categories)
  - `ald-curator` - Pattern detection and continuous learning
  - `ald-tester` - E2E validation as end user
  - `ald-orchestrator` - Workflow coordination
  - `ald-sprint` - Sprint lifecycle management
  - `ald-policy-finder` - Intelligent policy search
  - `ald-code-reviewer` - Policy-aware code review
- Complete documentation (SKILL.md, CLAUDE.md, examples)
- 155 policies across 17 categories:
  - Database (13 policies)
  - UI/UX (14 policies)
  - Code Quality (17 policies)
  - Security (13 policies)
  - API Design (10 policies)
  - Testing (8 policies)
  - Performance (8 policies)
  - Git/CI-CD (8 policies)
  - Logging/Monitoring (6 policies)
  - External Integrations (11 policies)
  - MCP Usage (4 policies)
  - Error Recovery (6 policies)
  - State Management (7 policies)
  - Data Fetching (6 policies)
  - File Uploads (5 policies)
  - Forms/Validation (7 policies)
  - Sprint Scope Isolation (12 policies)

**Nexus v1.1.3** - Master Workflow Orchestrator
- 3 commands:
  - `/nexus` - Intelligent workflow orchestration
  - `/nexus-setup` - Dependency auto-installation
  - `/nexus-update` - Version check and auto-update
- Complete documentation (SKILL.md, README.md, examples)
- Workflow templates (YAML-based):
  - `feature-full.yml` - Complex features (60-120 min)
  - `feature-quick.yml` - Medium features (30-45 min)
  - `bugfix.yml` - Quick fixes (10-20 min)
  - `refactor.yml` - Code refactoring (20-40 min)
  - `code-review.yml` - Review only (5-10 min)
- Features:
  - Intent detection and workflow selection
  - Multi-plugin coordination (Superpowers + ALD + MCPs)
  - Policy enforcement via ALD integration
  - MCP auto-injection based on keywords
  - TDD by default (Red-Green-Refactor)
  - Unified reporting across plugins
  - Auto-update system with semantic versioning

### Documentation

- **Root README.md**: Marketplace overview, quick start, documentation links
- **CONTRIBUTING.md**: Contribution guidelines, testing, versioning
- **LICENSE**: MIT License
- **CHANGELOG.md**: Version history (this file)

### Installation

```bash
# Single command installs both plugins
/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES

# Verify installation
/plugin menu
```

### Quality Standards

All code follows ALD quality gates:
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

## Version Mapping

| Marketplace | ALD System | Nexus | Release Date |
|------------|------------|-------|--------------|
| 1.0.0      | 1.3.3      | 1.1.3 | 2025-10-29   |

---

## Migration from Individual Repos

### Before (Deprecated)
```bash
# These no longer work as intended
/plugin install https://github.com/dirgogoo/ald-system
/plugin install https://github.com/dirgogoo/nexus
```

### After (Current)
```bash
# Single command installs both
/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES
```

**Note**: Individual repositories (dirgogoo/ald-system, dirgogoo/nexus) are kept for reference but are deprecated in favor of the unified marketplace.

---

## Links

- **Repository**: https://github.com/dirgogoo/HMC-TECHNOLOGIES
- **Issues**: https://github.com/dirgogoo/HMC-TECHNOLOGIES/issues
- **Releases**: https://github.com/dirgogoo/HMC-TECHNOLOGIES/releases

---

## Future Roadmap

### Planned for v1.1.0
- Additional workflow templates
- Enhanced MCP integrations
- More policy categories

### Planned for v2.0.0
- Additional plugins (TBD)
- Breaking changes to marketplace structure (if needed)
- Enhanced coordination features

---

**Made with ❤️ by dirgogoo**
