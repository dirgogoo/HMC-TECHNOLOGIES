# Nexus - Master Workflow Orchestrator

**Version**: 1.1.0
**Created**: 2025-10-28
**Updated**: 2025-10-28
**Status**: ✅ Operational

---

## 🎯 What is Nexus?

**Nexus** is a master orchestrator that coordinates multiple AI workflow systems (Superpowers, ALD, and future plugins) to deliver the optimal development experience.

Think of Nexus as a **conductor** leading an orchestra:
- Each plugin is an instrument (Superpowers, ALD, MCPs, etc.)
- Nexus makes them play together harmoniously
- You get beautiful music (efficient, high-quality development)

### ⭐ NEW: MCP Integration (v1.1.0)

Nexus now automatically integrates **MCP (Model Context Protocol) tools**:

- ✅ **Auto-Detection**: Discovers Supabase, Chrome DevTools, GitHub MCPs automatically
- ✅ **Auto-Injection**: Keywords trigger MCP usage (zero manual invocation)
- ✅ **Policy Enforcement**: Mandatory validations (UI, security) auto-enforced
- ✅ **Zero Configuration**: Works out-of-the-box

**Example**:
```bash
/nexus implement product listing UI
# → Auto-injects Chrome DevTools UI validation (MANDATORY via Policy 12.2)
# → Validates console (0 errors), network (all succeed), UI snapshot
# → Workflow FAILS if validation fails
```

📖 **Full MCP Integration Guide**: [`MCP-INTEGRATION.md`](./MCP-INTEGRATION.md)

---

## 🚀 Quick Start

### Usage

```bash
/nexus [task description]
```

### Examples

```bash
# Complex feature
/nexus implement checkout with Stripe

# Quick bugfix
/nexus fix login button spacing

# Code review
/nexus review my implementation

# Refactoring
/nexus refactor UserList component for performance
```

---

## ⚡ How It Works

```
1. User invokes: /nexus implement checkout
                      ↓
2. Nexus analyzes:   Intent? Complexity? Context?
                      ↓
3. Nexus suggests:   "Recommended: feature-full.yml"
                      ↓
4. User confirms:    "Use as-is" or customize
                      ↓
5. Nexus executes:   Brainstorm → Plan → Execute → Validate → Review
    (coordinates)    (Superpowers + ALD working together)
                      ↓
6. Result:           Feature complete, policies followed, ready to merge
```

---

## 📋 Available Workflows

### 1. **feature-full.yml** - Complex Features (TDD by Default ⭐)
**When**: Large/complex features, needs planning
**Duration**: 60-120 minutes
**Phases**:
1. Brainstorming (Superpowers) - Refine requirements
2. Planning (Superpowers) - Create detailed plan
3. Load Context (ALD) - Memory + sprint
4. Sprint Check (ALD) - Validate scope
5. Find Policies (ALD) - Identify relevant rules
6. **TDD Implementation (Superpowers-dev)** - Red-Green-Refactor for each task in plan
7. **Defense-in-Depth (Superpowers-dev)** - Multi-layer validation
8. E2E Validation (ALD) - Full testing
9. Code Review (ALD) - Policy compliance + code quality
10. Learn (ALD) - Curator learns patterns

**TDD Enforced**: Every task in plan implemented with test-first discipline. Ensures 100% coverage.

**Use for**: "Implement checkout", "Create dashboard", "Add authentication"

---

### 2. **feature-quick.yml** - Medium Features (TDD by Default ⭐)
**When**: Medium complexity, clear requirements
**Duration**: 30-45 minutes
**Phases**:
1. Load Context (ALD)
2. Sprint Check (ALD)
3. Quick Planning (Superpowers)
4. Find Policies (ALD)
5. **TDD Implementation (Superpowers-dev)** - Red-Green-Refactor
6. **Defense-in-Depth (Superpowers-dev)** - Multi-layer validation
7. E2E Validation (ALD)
8. Code Review (ALD)

**TDD Enforced**: Test-first for all tasks. Lighter than feature-full (no brainstorming) but same TDD quality.

**Use for**: "Add API endpoint", "Create form component"

---

### 3. **bugfix.yml** - Systematic Bugfix (Enhanced ⭐)
**When**: Bug fixes with systematic debugging
**Duration**: 15-30 minutes
**Phases**:
1. Load Context (ALD)
2. Sprint Check (ALD) - optional
3. Find Policies (ALD)
4. **Systematic Debugging (Superpowers-dev)** - 4-phase framework:
   - Root cause investigation
   - Pattern analysis
   - Hypothesis testing
   - Implementation
5. Root Cause Tracing (Superpowers-dev) - optional for complex bugs
6. Fix (ALD direct)
7. **Defense-in-Depth (Superpowers-dev)** - Add validation layers:
   - Entry point validation
   - Business logic validation
   - Environment guards
   - Debug logging
8. Validate (ALD)
9. Quick Review (ALD)

**Enhanced with**: Systematic debugging framework + defense-in-depth validation to prevent recurrence

**Use for**: "Fix login spacing", "Resolve API error", "Debug performance issue"

---

### 4. **feature-tdd.yml** - TDD Strict (Advanced, Optional)
**When**: STRICT TDD-only workflow for experienced devs
**Duration**: 45-90 minutes
**Phases**:
1. Load Context (ALD)
2. Sprint Check (ALD)
3. Find Policies (ALD)
4. **TDD Red-Green-Refactor (Superpowers-dev)** - Pure TDD, no planning phase
5. **Defense-in-Depth (Superpowers-dev)** - Add validation layers
6. E2E Validation (ALD)
7. Code Review (ALD)

**Difference from feature-full/quick**:
- ❌ No brainstorming phase
- ❌ No planning phase
- ✅ Jump straight into test-first development
- ✅ For when you already know exactly what to build

**Use when**: You know requirements perfectly and want pure TDD without planning overhead

**Recommendation**: For most features, use **feature-full** or **feature-quick** (they now include TDD by default with planning benefits)

---

### 5. **refactor.yml** - Code Refactoring
**When**: Improving existing code
**Duration**: 20-40 minutes
**Phases**:
1. Load Context (ALD)
2. Find Policies (ALD)
3. Refactor (ALD)
4. Regression Testing (ALD)
5. Quality Review (ALD)

**Use for**: "Refactor UserList", "Optimize queries"

---

### 6. **code-review.yml** - Review Only
**When**: Code already implemented
**Duration**: 5-10 minutes
**Phases**:
1. Load Context (ALD)
2. Comprehensive Review (ald-code-reviewer: ALD policies + Superpowers)

**Use for**: "Review my implementation", "Check if ready to merge"

---

## 🔌 Plugin System

Nexus coordinates multiple plugins through a standardized interface.

### Current Plugins

#### 1. **ALD Plugin**
**What**: Autonomous Learning & Development system
**Capabilities**:
- Context management (155 policies, memory, integrations)
- Sprint management (scope isolation)
- E2E validation (testing as end user)
- Code review with policies
- Continuous learning (curator)

**Hooks**:
- `load-memory`: Load project context
- `sprint-check`: Validate sprint scope
- `policy-finder`: Identify relevant policies
- `tester`: E2E validation
- `code-reviewer`: Policy + Superpowers review
- `curator`: Learn patterns

---

#### 2. **Superpowers Plugin**
**What**: Structured workflow system
**Capabilities**:
- Socratic brainstorming
- Detailed planning
- Batch execution with checkpoints
- Standard code review

**Hooks**:
- `brainstorm`: /superpowers:brainstorm
- `write-plan`: /superpowers:write-plan
- `execute-plan`: /superpowers:execute-plan
- `code-reviewer`: superpowers:code-reviewer subagent

---

#### 3. **Superpowers-dev Plugin** ⭐ NEW
**What**: Advanced debugging, TDD, and quality engineering
**Capabilities**:
- Systematic debugging (4-phase framework)
- Test-driven development (Red-Green-Refactor)
- Root cause tracing (backward call stack analysis)
- Defense-in-depth (multi-layer validation)
- Quality engineering workflows

**Hooks**:
- `systematic-debugging`: 4-phase framework (root cause → pattern → hypothesis → implementation)
- `test-driven-development`: Red-Green-Refactor TDD cycle
- `root-cause-tracing`: Trace bugs backward to original trigger
- `defense-in-depth`: Add validation at multiple layers
- `subagent-driven-development`: Fresh subagent per task + code review
- `verification-before-completion`: Run verification before claiming success
- `using-git-worktrees`: Create isolated git worktrees

**When to use**:
- **Bugfix**: Systematic debugging + defense-in-depth
- **Feature-TDD**: Full TDD workflow with tests-first discipline
- **Complex bugs**: Root-cause tracing for deep stack traces
- **Quality focus**: Verification and validation workflows

---

### Adding New Plugins

Want to add LangChain, AutoGen, or custom systems?

1. **Create plugin metadata**: `skills/nexus/plugins/[name]/plugin.yml`
2. **Register**: Add to `skills/nexus/plugins/registry.json`
3. **Create workflows**: Use new plugin in `nexus/workflows/`

Example:
```yaml
# skills/nexus/plugins/langchain/plugin.yml
name: "langchain"
hooks:
  - name: "research"
    description: "Web research with agents"
```

Then use in workflow:
```yaml
phases:
  - id: "research"
    plugin: "langchain"
    hook: "research"
```

---

## 🎨 Customization

### Interactive Refinement

Nexus **always asks** before executing:

```
🎯 Nexus Analysis

Task: implement checkout
Detected: Complex feature
Suggested: feature-full.yml

This workflow includes:
✅ Brainstorming
✅ Planning
✅ Execution with policies
✅ Validation
✅ Review

Estimated: 60-120 minutes

Customize?
1. Use as-is (recommended)
2. Skip brainstorming
3. Skip planning
4. Custom workflow

Choose:
```

You can:
- Accept recommendation
- Skip phases
- Add phases
- Switch to different workflow
- Create custom on-the-fly

---

### User Preferences

Edit `~/.claude/skills/nexus/config/user-preferences.yml`:

```yaml
default_workflow: "feature-quick"

plugins:
  ald:
    always_use_policies: true

workflows:
  bugfix:
    skip_phases: ["brainstorm", "planning"]  # Fast bug fixes
```

---

## 📊 Real-World Examples

### Example 1: Complex Feature (TDD by Default)

```bash
User: /nexus implement real-time chat with WebSockets

Nexus Analysis:
- Intent: feature-development
- Complexity: large
- Suggested: feature-full.yml (TDD by default)

User: Use as-is

Nexus Executes:
✅ Brainstorming (8 min) → Requirements refined
✅ Planning (12 min) → 10 tasks identified
✅ Load Context (1 min) → Project + sprint loaded
✅ Sprint Check (30s) → In scope ✅
✅ Find Policies (2 min) → 9 policies identified
✅ TDD Implementation (50 min):
   Task 1: WebSocket connection
   - RED: Test "should connect to server"
   - Verify RED: Test fails ✅
   - GREEN: Basic connection code
   - Verify GREEN: Test passes ✅
   - REFACTOR: Extract connection logic
   [Repeat for all 10 tasks...]
✅ Defense-in-Depth (8 min) → 4 validation layers added
✅ E2E Validate (5 min) → All tests passing, 100% coverage
✅ Review (10 min) → 9/9 policies ✅
✅ Learn (2 min) → WebSocket pattern learned

Result: Feature complete with 100% test coverage in 95 minutes
Every line of code has tests that failed first ✅
Ready to merge ✅
```

---

### Example 2: Quick Bugfix

```bash
User: /nexus fix the button spacing on mobile

Nexus Analysis:
- Intent: bugfix
- Complexity: small
- Auto-selected: bugfix.yml

Nexus Executes (no confirmation for simple tasks):
✅ Load Context (30s)
✅ Sprint Check (skip - urgent fix)
✅ Find Policies (1 min) → UI/UX policies
✅ Fix (5 min) → Applied CSS fix
✅ Validate (2 min) → Visual validation ✅
✅ Quick Review (1 min) → No issues

Result: Bug fixed in 10 minutes
```

---

### Example 3: Custom Workflow

```bash
User: /nexus I want to brainstorm, then code directly without planning

Nexus: Creating custom workflow...

Custom Workflow:
1. Brainstorm (Superpowers)
2. Load Context (ALD)
3. Find Policies (ALD)
4. Execute (ALD direct)
5. Validate (ALD)
6. Review (ALD)

Proceed? Yes

[Executes custom workflow]

Result: Flexible, user-driven workflow
```

---

### Example 4: TDD Feature (NEW ⭐)

```bash
User: /nexus implement user authentication with TDD

Nexus Analysis:
- Intent: feature-development
- Approach: tdd (keyword detected)
- Suggested: feature-tdd.yml

User: Use as-is

Nexus Executes:
✅ Load Context (1 min) → Project + sprint loaded
✅ Sprint Check (30s) → In scope ✅
✅ Find Policies (2 min) → Security + auth policies
✅ TDD Cycle 1: Login validation
   RED (3 min) → Test: "should reject empty email"
   Verify RED → Test fails ✅
   GREEN (5 min) → Minimal validation code
   Verify GREEN → Test passes ✅
   REFACTOR (2 min) → Extract validator
✅ TDD Cycle 2: Password strength
   RED → GREEN → REFACTOR
✅ TDD Cycle 3: Session handling
   RED → GREEN → REFACTOR
✅ Defense-in-Depth (8 min) → Added 4 validation layers
✅ E2E Validation (6 min) → All tests passing, UX validated
✅ Code Review (8 min) → Security policies ✅
✅ Learn (2 min) → Auth pattern learned

Result: Feature complete with 100% test coverage in 65 minutes
All tests written BEFORE implementation ✅
```

---

### Example 5: Systematic Bug Debugging (ENHANCED ⭐)

```bash
User: /nexus debug the checkout failing on edge case

Nexus Analysis:
- Intent: bugfix
- Auto-selected: bugfix.yml (enhanced)

Nexus Executes:
✅ Load Context (30s)
✅ Sprint Check (30s) → In scope
✅ Find Policies (1 min)
✅ Systematic Debugging (8 min):
   Phase 1: Root Cause Investigation
   - Identified: null cartItems not handled
   Phase 2: Pattern Analysis
   - Found: Similar null checks missing in 3 places
   Phase 3: Hypothesis Testing
   - Confirmed: Missing null guard at entry
   Phase 4: Implementation Strategy
   - Plan: Add entry validation + tests
✅ Root Cause Tracing (3 min):
   - Traced back to: loadCart() doesn't validate API response
   - Original trigger: Supabase returned null on timeout
✅ Fix (6 min) → Applied entry validation
✅ Defense-in-Depth (10 min):
   ✓ Entry: cartItems validation added
   ✓ Business: checkout logic checks null
   ✓ Environment: API timeout handling added
   ✓ Debug: Added logging for cart operations
✅ Validate (3 min) → All tests passing, edge cases covered
✅ Review (2 min) → No violations

Result: Bug fixed with 4 layers of protection in 35 minutes
Recurrence prevention: ✅ Validated at 4 layers
Pattern learned: Always validate API responses
```

---

## 🧩 Architecture

```
nexus/
├── SKILL.md                    # Entry point (orchestrator core)
├── README.md                   # This file
├── core/
│   ├── intent-detector.md      # Analyzes user requests
│   ├── orchestrator.md         # Coordinates plugins
│   ├── workflow-engine.md      # Executes workflows
│   └── state-manager.md        # Tracks execution state
├── plugins/
│   ├── registry.json                  # Plugin registry
│   ├── ald/plugin.yml                 # ALD plugin metadata
│   ├── superpowers/plugin.yml         # Superpowers metadata
│   └── superpowers-dev/plugin.yml     # Superpowers-dev metadata (NEW ⭐)
├── workflows/
│   ├── feature-full.yml        # Complex features (TDD by default ⭐)
│   ├── feature-quick.yml       # Medium features (TDD by default ⭐)
│   ├── feature-tdd.yml         # TDD strict - no planning (advanced)
│   ├── bugfix.yml              # Systematic bugfix (ENHANCED ⭐)
│   ├── refactor.yml            # Refactoring
│   └── code-review.yml         # Review only
└── config/
    ├── defaults.yml            # System defaults
    └── user-preferences.yml    # Your preferences
```

---

## 🔄 Integration with Existing Systems

### CLAUDE.md

**Nexus extends CLAUDE.md**:
- CLAUDE.md = Constitution (fundamental rules)
- Nexus = Government (executes within constitutional bounds)

When Nexus not used:
- CLAUDE.md rules apply directly (Pre-Flight Check, etc.)

When Nexus used:
- Nexus coordinates
- CLAUDE.md enforced within each plugin
- Output contract still applies: `CLAUDE.MD ATIVO`

---

### ALD System

Nexus doesn't replace ALD - it **coordinates** it:

**Before Nexus**:
- User manually invokes ald-memory, ald-policies, ald-tester, etc.
- Easy to forget steps
- No standardized workflow

**With Nexus**:
- Nexus automatically coordinates all ALD skills
- Workflow ensures nothing is skipped
- ALD Pre-Flight Check still runs for each implementation
- All 155 policies still enforced

---

### Superpowers

Nexus makes Superpowers and ALD work together:

**Before Nexus**:
- Superpowers: Great for planning/execution
- ALD: Great for policies/validation
- But: Two separate systems, manual coordination

**With Nexus**:
- Superpowers handles macro (brainstorm, plan, execute)
- ALD provides micro enforcement (policies, validation, memory)
- Seamless integration
- Best of both worlds

---

## 📈 Benefits

### Before Nexus

❌ Manual workflow coordination
❌ Easy to skip steps (memory, policies, validation)
❌ Superpowers and ALD separate
❌ Inconsistent process
❌ No standardized workflows

### With Nexus

✅ Intelligent workflow selection
✅ Automated step coordination
✅ Superpowers + ALD integrated seamlessly
✅ Consistent, repeatable process
✅ Extensible (add new plugins easily)
✅ Natural language customization
✅ Learning improves system over time

---

## 🚧 Future Roadmap

### Planned Features

- [ ] More workflows (spike, experiment, migration, deployment)
- [ ] Workflow templates (save custom workflows)
- [ ] Metrics dashboard (pass@1, workflow efficiency)
- [ ] Plugin marketplace (community-contributed plugins)
- [ ] Workflow visualization (see execution flow)
- [ ] LangChain integration (research workflows)
- [ ] AutoGen integration (multi-agent workflows)

### GitHub Repository (Planned)

Future plans to open-source Nexus:
- Kaizen Core (nexus orchestrator)
- ALD Plugin (included)
- Superpowers Adapter
- Plugin development kit
- Example workflows
- Community contributions

---

## ❓ FAQ

**Q: Is Nexus a replacement for ALD?**
A: No! Nexus **coordinates** ALD. All ALD policies, memory, and validation still apply. Nexus just orchestrates when/how they're invoked.

**Q: Do I need Superpowers installed?**
A: For full workflows (feature-full), yes. But bugfix/refactor workflows work with ALD only.

**Q: Can I use Nexus without Superpowers?**
A: Yes! Use bugfix.yml, refactor.yml, or feature-quick.yml (ALD-only workflows).

**Q: How do I add my own workflow?**
A: Create YAML file in `nexus/workflows/my-workflow.yml` following the format of existing workflows.

**Q: Can I skip phases in a workflow?**
A: Yes! Nexus asks before executing. You can skip optional phases or customize the workflow.

**Q: Does Nexus replace CLAUDE.md?**
A: No! CLAUDE.md is the foundation. Nexus extends it with orchestration layer.

**Q: What if a phase fails?**
A: Nexus pauses, shows error, offers options: fix & retry, skip, abort, or switch workflow.

**Q: What's new with superpowers-dev integration?**
A: Added systematic debugging, TDD workflow, root-cause tracing, and defense-in-depth validation. Bugfix workflow now includes 4-phase debugging framework. New feature-tdd.yml workflow enforces Red-Green-Refactor discipline.

**Q: Do I need to use feature-tdd.yml for TDD?**
A: No! **feature-full.yml** and **feature-quick.yml** now include TDD by default. Use those for most features. feature-tdd.yml is only for advanced users who want pure TDD without any planning phase.

**Q: What does "defense-in-depth" mean?**
A: Multi-layer validation strategy that adds checks at 4 levels: entry points, business logic, environment guards, and debug logging. Prevents bugs from recurring by validating at every layer data passes through.

**Q: Why is TDD now default in feature workflows?**
A: TDD ensures every line of code has tests that actually work (you watched them fail first). Making it default means all features get 100% test coverage automatically. You get:
- Tests that prove they work (failed first)
- Zero untested code
- Better design (tests force good APIs)
- Refactoring confidence (tests catch breaks)
- Documentation (tests show usage)

**Q: Can I skip TDD if I'm in a hurry?**
A: TDD is actually faster than debugging later. But if you must, you can customize the workflow to skip the TDD phase. However, you'll lose the benefits and likely spend more time debugging later.

---

## 🔄 Keeping Nexus Updated

### Check for Updates

```bash
/nexus-update
```

**What it does**:
1. Checks GitHub for newer versions
2. If update available, asks for confirmation
3. Creates backup of current installation
4. Downloads and installs update
5. Verifies installation
6. Runs migrations if needed
7. Shows "What's New" from release notes

**Example**:
```
You: /nexus-update

Nexus:
⬇️ Checking for updates...

🆕 Update Available!
Current version: v1.1.0
Latest version: v1.2.0

Nexus v1.2.0 - Enhanced Workflows
Released: 2025-11-01

Would you like to update? (yes/no)

[You confirm]

📦 Creating backup...
⬇️ Downloading...
⚙️ Installing...
🔍 Verifying...

✅ Nexus Updated Successfully!

Backup saved at: ~/.claude/skills/.nexus-backups/backup-20251101_143022
```

**Rollback** (if update fails):
```bash
# Automatic rollback on failure
# Or manual:
cp -r ~/.claude/skills/.nexus-backups/backup-[timestamp]/nexus ~/.claude/skills/
```

**Recommended**:
- Check for updates monthly
- Always backup before major projects
- Read release notes to understand new features

---

## 🎓 Learn More

- [SKILL.md](./SKILL.md) - Full orchestrator logic
- [Workflow Examples](./examples/) - Real-world usage
- [Plugin Development](./plugins/_template/) - Create your own plugins
- [ALD System](../README.md) - Understand ALD
- [Superpowers](https://github.com/superpowers-marketplace) - Learn about Superpowers

---

## 💬 Support

**Questions?**
- Read this README
- Check examples/ directory
- Review existing workflows

**Want to contribute?**
- Create custom workflows
- Build new plugins
- Share patterns learned

---

**Nexus v1.0.0**
Making AI workflows orchestrate beautifully.

🎵 You're the user. Nexus is the conductor. Your code is the symphony.

---

CLAUDE.MD ATIVO
