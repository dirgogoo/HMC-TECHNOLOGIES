# Contributing to Dirgogoo Marketplace

Thank you for your interest in contributing to the Dirgogoo Marketplace! This document provides guidelines for contributing to the ALD System and Nexus plugins.

---

## 🎯 Ways to Contribute

1. **Report Issues** - Bug reports, feature requests, documentation improvements
2. **Submit PRs** - Code improvements, new policies, workflow templates
3. **Share Feedback** - Usage patterns, pain points, success stories
4. **Improve Documentation** - Clarify instructions, add examples

---

## 📁 Repository Structure

```
dirgogoo-marketplace/
├── .claude-plugin/
│   └── marketplace.json          # Central plugin registry
├── plugins/
│   ├── ald-system/               # ALD System (v1.3.3)
│   │   ├── skills/               # 8 specialized skills
│   │   ├── SKILL.md              # Plugin entry point
│   │   ├── CLAUDE.md             # System controller
│   │   └── docs/                 # Documentation
│   └── nexus/                    # Nexus (v1.1.3)
│       ├── commands/             # 3 slash commands
│       ├── workflows/            # YAML workflow templates
│       ├── SKILL.md              # Plugin entry point
│       └── docs/                 # Documentation
├── README.md                     # Marketplace overview
├── CONTRIBUTING.md               # This file
├── LICENSE                       # MIT License
└── CHANGELOG.md                  # Version history
```

---

## 🐛 Reporting Issues

### Before Creating an Issue

1. **Search existing issues** - Check if already reported
2. **Try latest version** - Update with `/nexus-update`
3. **Reproduce the bug** - Ensure it's consistent
4. **Gather context** - Claude Code version, OS, error messages

### Creating a Good Issue

**Bug Report Template:**
```markdown
## Bug Description
[Clear description of the problem]

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Claude Code Version: [e.g., 0.8.5]
- OS: [e.g., macOS 14.1, Windows 11, Ubuntu 22.04]
- Marketplace Version: [e.g., 1.0.0]
- Plugin: [ALD System / Nexus / Both]

## Screenshots/Logs
[If applicable]

## Additional Context
[Any other relevant information]
```

**Feature Request Template:**
```markdown
## Feature Description
[Clear description of the proposed feature]

## Use Case
[Why is this needed? What problem does it solve?]

## Proposed Solution
[How would you implement this?]

## Alternatives Considered
[Other approaches you've thought about]

## Plugin
[ALD System / Nexus / Marketplace / All]
```

---

## 🔀 Submitting Pull Requests

### Before Starting Work

1. **Check existing PRs** - Avoid duplicate work
2. **Open an issue first** - Discuss major changes
3. **Fork the repository** - Work in your own fork
4. **Create a branch** - Use descriptive names

### Branch Naming Conventions

```bash
# Features
feature/add-new-policy-validation
feature/nexus-github-integration

# Bugfixes
fix/ald-memory-loading-error
fix/nexus-update-version-check

# Documentation
docs/improve-installation-guide
docs/add-policy-examples

# Refactoring
refactor/simplify-workflow-engine
```

### Development Workflow

#### For ALD System Changes

1. **Add/modify policies**: `plugins/ald-system/skills/ald-policies/policies/*.md`
2. **Update policy finder** if adding new categories
3. **Test with real scenarios** - Implement code that uses the policy
4. **Update documentation** - SKILL.md, CLAUDE.md if needed
5. **Add examples** - `plugins/ald-system/examples/`

#### For Nexus Changes

1. **Modify workflows**: `plugins/nexus/workflows/*.yml`
2. **Update commands** if needed
3. **Test workflow execution** - Run with `/nexus [task]`
4. **Update documentation** - SKILL.md, README.md
5. **Add integration tests** - See INTEGRATION-TESTS.md

### Commit Message Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format
<type>(<scope>): <description>

# Types
feat:     New feature
fix:      Bug fix
docs:     Documentation only
style:    Code style (formatting, no logic change)
refactor: Code restructuring (no feature/bug change)
test:     Adding/updating tests
chore:    Maintenance (deps, build, etc.)

# Examples
feat(ald-policies): add RLS policy for user data isolation
fix(nexus): resolve workflow selection edge case
docs(readme): clarify installation steps for Windows
refactor(ald-tester): simplify console error detection
chore(marketplace): bump ALD System to v1.3.4
```

### PR Template

```markdown
## Description
[What does this PR do?]

## Related Issue
Closes #[issue number]

## Type of Change
- [ ] Bug fix (non-breaking)
- [ ] New feature (non-breaking)
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
[How did you test this?]

## Checklist
- [ ] Code follows project style
- [ ] Documentation updated
- [ ] Tests added/updated (if applicable)
- [ ] CHANGELOG.md updated
- [ ] No breaking changes (or documented)
- [ ] Tested locally

## Screenshots
[If applicable]

## Additional Notes
[Any other context]
```

---

## 🧪 Testing Guidelines

### Manual Testing

**For ALD System:**
```bash
# 1. Test memory loading
# Create a project, add context, reload session

# 2. Test policy enforcement
# Implement code that should trigger specific policies

# 3. Test validation
# Run ald-tester after implementation

# 4. Test curator
# Complete multiple tasks, check pattern detection
```

**For Nexus:**
```bash
# 1. Test workflow selection
/nexus implement [feature]
# Verify correct workflow chosen

# 2. Test plugin coordination
# Check Superpowers + ALD integration

# 3. Test auto-update
/nexus-update
# Verify version detection works

# 4. Test setup
/nexus-setup
# Verify dependency installation
```

### Integration Testing

See `plugins/nexus/INTEGRATION-TESTS.md` for comprehensive test scenarios.

---

## 📜 Adding New Policies (ALD System)

### Policy File Structure

**Location**: `plugins/ald-system/skills/ald-policies/policies/[category].md`

**Template**:
```markdown
# [Category Name] Policies

## Policy [X.Y]: [Policy Title]

**Why**: [Reason this policy exists]

**What**: [What the policy requires]

**How**: [Implementation guidance]

**Example**:
```[language]
[Good example code]
```

**Anti-pattern**:
```[language]
[Bad example code]
```

**Related Policies**: [X.Z], [A.B]

---
```

### Policy Categories

Current categories (17):
1. Database
2. UI/UX
3. Code Quality
4. Security
5. API Design
6. Testing
7. Performance
8. Git/CI-CD
9. Logging/Monitoring
10. External Integrations
11. MCP Usage
12. Error Recovery
13. State Management
14. Data Fetching
15. File Uploads
16. Forms/Validation
17. Sprint Scope Isolation

### Adding a New Category

1. Create new markdown file: `[category].md`
2. Update `ald-policies/SKILL.md` - add to category list
3. Update policy-finder keyword mappings
4. Add examples in `examples/`
5. Update CHANGELOG.md

---

## 🎯 Creating Workflows (Nexus)

### Workflow File Structure

**Location**: `plugins/nexus/workflows/[name].yml`

**Template**:
```yaml
name: [Workflow Name]
description: [What this workflow does]
version: 1.0.0
author: [Your name]

metadata:
  intent: [feature-development|bugfix|refactor|code-review]
  complexity: [small|medium|large|complex]
  estimated_time: [minutes]
  required_plugins:
    - superpowers
    - ald-system

phases:
  - name: [Phase Name]
    plugin: [superpowers|ald-system|mcp]
    action: [skill|command|tool]
    params:
      [key]: [value]
    on_failure: [retry|skip|abort]

  - name: [Next Phase]
    plugin: [...]
    action: [...]

quality_gates:
  - [gate 1]
  - [gate 2]

deliverables:
  - [deliverable 1]
  - [deliverable 2]
```

### Workflow Best Practices

1. **Keep phases atomic** - Each phase should do one thing
2. **Define clear success criteria** - Quality gates
3. **Handle failures gracefully** - on_failure strategies
4. **Document dependencies** - required_plugins
5. **Estimate realistically** - estimated_time
6. **Test thoroughly** - Run multiple scenarios

---

## 📋 Versioning

We follow [Semantic Versioning](https://semver.org/):

**Marketplace Version** (major.minor.patch):
- **Major**: Breaking changes in any plugin
- **Minor**: New plugin added OR new feature in existing plugin
- **Patch**: Bugfixes only

**Individual Plugin Versions**:
- Tracked independently in `plugins/[plugin]/CHANGELOG.md`
- Marketplace.json references current versions

### Version Update Checklist

```bash
# 1. Update plugin version
# Edit plugins/[plugin]/CHANGELOG.md

# 2. Update marketplace.json
# Bump version in .claude-plugin/marketplace.json

# 3. Update root CHANGELOG.md
# Document all changes

# 4. Create git tag
git tag -a v[version] -m "Release v[version]"
git push origin v[version]

# 5. Create GitHub Release
# Use gh cli or web interface
```

---

## 🔒 Security

### Reporting Security Issues

**DO NOT** open a public issue for security vulnerabilities.

Instead:
1. Email: [Your security email]
2. Subject: `[SECURITY] [Brief description]`
3. Include: Detailed description, steps to reproduce, impact assessment

### Security Review Checklist

- [ ] No hardcoded credentials
- [ ] No sensitive data in logs
- [ ] Input validation implemented
- [ ] No arbitrary code execution
- [ ] Dependencies up to date
- [ ] Follows least privilege principle

---

## 🎨 Code Style

### Markdown
- Use ATX-style headers (`#` not underlines)
- One blank line between sections
- Code blocks with language tags
- Tables for structured data
- Lists for sequences/alternatives

### YAML
- 2-space indentation
- Quotes for strings with special chars
- Comments for complex logic
- Descriptive keys

### File Naming
- Lowercase with hyphens: `my-file-name.md`
- Directories: `my-directory/`
- Skills: `ald-[skill-name]/`

---

## 🤝 Code of Conduct

### Our Standards

- **Be respectful** - Treat everyone with kindness
- **Be constructive** - Focus on solutions, not blame
- **Be collaborative** - Help others succeed
- **Be inclusive** - Welcome diverse perspectives
- **Be patient** - Remember we're all learning

### Unacceptable Behavior

- Harassment, discrimination, or offensive comments
- Personal attacks or insults
- Publishing private information
- Spam or self-promotion
- Any illegal activity

### Enforcement

Issues will be reviewed by maintainers. Consequences range from warnings to permanent bans depending on severity.

---

## 📞 Getting Help

- **Documentation**: Check `README.md` and plugin docs
- **Issues**: Search existing issues first
- **Discussions**: Use GitHub Discussions for questions
- **Examples**: See `plugins/[plugin]/examples/`

---

## 🙏 Recognition

Contributors are recognized in:
- CHANGELOG.md for each release
- GitHub contributors page
- Special mentions for significant contributions

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Dirgogoo Marketplace!** 🎉
