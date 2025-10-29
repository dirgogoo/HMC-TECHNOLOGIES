# Changelog

All notable changes to Nexus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2025-10-29

### 🚀 BREAKING CHANGE: Flat Marketplace Structure

Complete restructuring from nested plugin-based to flat skills-based marketplace following Superpowers pattern.

**Migration Guide**:
- Old `plugins/` structure → New flat `skills/` at marketplace root
- Old `.claude-plugin/marketplace.json` → Auto-discovery from `skills/`
- Command renamed: `/nexus:nexus` → `/nexus:execute`
- All content preserved, only structure changed

**Added**:
- `commands/execute.md` - `/nexus:execute` command (renamed from `/nexus`)
- `hooks/hooks.json` + `hooks/session-start.sh` - SessionStart welcome message
- `config/defaults.yml` - Global configuration (200+ settings)
- `config/i18n/pt-BR.yml` - Brazilian Portuguese translations
- `config/i18n/en-US.yml` - US English translations
- `skills/nexus/SKILL.md` - Redesigned as executable (not just instructional)
- `skills/nexus/docs/` - Technical docs (moved from `core/`)

**Changed**:
- Structure: Nested plugins → Flat skills
- Discovery: marketplace.json registry → Auto-discovery
- Hooks: None → SessionStart with welcome message
- Config: Hardcoded → YAML with i18n support
- SKILL.md: Instructional → Executable workflow
- Paths: All references updated to new structure

**Removed**:
- `plugins/` directory (134 files) - Moved to `skills/`
- `.claude-plugin/marketplace.json` - No longer needed
- `/nexus-setup` and `/nexus-update` commands

**Note**: Versions 1.x below used old nested `plugins/` structure. References to `plugins/` in changelog entries are historical.

---

## [1.1.0] - 2025-10-28

### ⭐ Major Features

#### MCP Integration
- **MCP Auto-Detection**: Automatically discovers available MCP servers by scanning for `mcp__` prefixed tools
- **MCP Auto-Injection**: Keywords in task descriptions trigger automatic MCP usage (zero manual invocation)
- **Policy Enforcement**: MANDATORY MCPs cannot be skipped (Policy 12.1 for database, 12.2 for UI)
- **4 MCP Plugins**: Supabase, Chrome DevTools, Episodic Memory, GitHub

#### TDD by Default
- **feature-full.yml**: Red-Green-Refactor cycle integrated by default
- **feature-quick.yml**: TDD for medium features
- **feature-tdd.yml**: Renamed to "TDD Strict Workflow (Advanced)" for pure test-first development

### Added

**Core**:
- `core/mcp-detector.md` - MCP auto-discovery algorithm
- `core/mcp-injector.md` - Workflow phase injection logic
- `MCP-INTEGRATION.md` - Complete MCP integration documentation
- `INTEGRATION-TESTS.md` - E2E validation tests (10 test cases)
- `workflows/EXAMPLE-enhanced-workflow.yml` - MCP injection examples

**MCP Plugins** (`plugins/mcp-*/plugin.yml`):
- `mcp-supabase` - Database operations, migrations, security audits (Priority 10)
- `mcp-chrome-devtools` - UI validation, E2E testing, performance (Priority 11)
- `mcp-episodic-memory` - Context recall, pattern search (Priority 12)
- `mcp-github` - Issues, PRs, code review (Priority 13)

**Registry**:
- Updated `plugins/registry.json` to v1.1.0
- Added MCP configuration section (`mcp_config`)
- 7 total plugins (3 traditional + 4 MCP)

### Changed

**Workflows**:
- `feature-full.yml`: Execute phase changed from "superpowers/execute-plan" to "superpowers-dev/test-driven-development"
- `feature-quick.yml`: Execute phase changed to TDD cycle
- `feature-tdd.yml`: Renamed to "TDD Strict Workflow (Advanced)" with concept clarification

**Documentation**:
- `README.md`: Added MCP Integration section at top
- Updated workflow descriptions to reflect TDD by default
- Added MCP auto-injection examples

### Fixed
- None (new major version)

### Security
- Policy 12.1: MANDATORY Supabase MCP for database operations (RLS validation)
- Policy 12.2: MANDATORY Chrome DevTools MCP for UI changes (console + network validation)

---

## [1.0.0] - 2025-10-23

### Initial Release

#### Core Features
- **Intent Detection**: Analyzes task description to select optimal workflow
- **Workflow Selection**: 5 pre-built workflows (feature-full, feature-quick, bugfix, refactor, code-review)
- **Plugin Coordination**: Seamless orchestration of Superpowers + ALD
- **State Management**: Tracks execution state throughout workflow
- **Result Aggregation**: Unified comprehensive reports

#### Architecture
- **Nexus Skill**: Master orchestrator (`SKILL.md`)
- **Plugin Registry**: Central plugin tracking (`plugins/registry.json`)
- **Workflow Engine**: Declarative YAML-based workflows
- **ALD Integration**: 8 skills + 155 policies across 17 categories
- **Superpowers Integration**: Brainstorming, planning, execution, TDD, debugging

#### Documentation
- `README.md` - Overview and quick start
- `SKILL.md` - Complete orchestrator documentation
- `core/intent-detector.md` - Intent detection algorithm
- `core/workflow-engine.md` - Workflow selection logic
- `core/orchestrator.md` - Plugin coordination
- `core/state-manager.md` - Execution state tracking

#### Workflows
- `feature-full.yml` - Complex feature development (60-120 min)
- `feature-quick.yml` - Medium feature development (30-45 min)
- `bugfix.yml` - Quick bug fixes (10-20 min)
- `refactor.yml` - Code refactoring (20-40 min)
- `code-review.yml` - Review only (5-10 min)

#### Plugin System
- `plugins/ald/plugin.yml` - ALD plugin metadata
- `plugins/superpowers/plugin.yml` - Superpowers plugin metadata
- `plugins/superpowers-dev/plugin.yml` - Superpowers Dev plugin metadata

#### Configuration
- `config/defaults.yml` - Default settings
- `config/user-preferences.template.yml` - User customization template

---

## [Unreleased]

### Planned Features

#### v1.2.0 - Workflow Visualization
- Workflow execution graph visualization
- Real-time phase progress tracking
- MCP hook injection visualization
- Export execution reports as diagrams

#### v1.3.0 - Multi-Repository Support
- Work across multiple repositories in single workflow
- Cross-repo dependency tracking
- Monorepo-aware workflows

#### v1.4.0 - Custom MCP Templates
- MCP plugin generator
- Template for creating custom MCP integrations
- MCP hook chaining (output → input)

#### v1.5.0 - Analytics Dashboard
- MCP usage analytics
- Workflow success rates
- Policy compliance metrics
- Learning curve tracking

#### v2.0.0 - Cloud Sync
- Cloud-based state synchronization
- Team workflow sharing
- Collaborative policy curation
- Cross-machine memory sync

---

## Version Numbering

- **Major (X.0.0)**: Breaking changes, major architecture updates
- **Minor (1.X.0)**: New features, backward compatible
- **Patch (1.0.X)**: Bug fixes, documentation updates

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to contribute to this changelog.

---

CLAUDE.MD ATIVO
