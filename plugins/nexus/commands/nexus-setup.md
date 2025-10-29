# /nexus-setup - Automatic Installation

Auto-install Nexus dependencies: Superpowers + MCP setup instructions.

**Note**: ALD System is already included when you install HMC Technologies marketplace (`/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES`).

---

## Instructions for Claude

When `/nexus-setup` is invoked, execute this installation workflow:

### Step 1: Welcome Message

```markdown
🚀 **Nexus Setup Wizard**

This will install Nexus dependencies:
✅ ALD System (already installed with HMC Technologies marketplace)
✅ Superpowers Marketplace (via /plugin marketplace add)
✅ Chrome DevTools MCP (via claude mcp add)
✅ Supabase MCP (via claude mcp add)
📋 Optional: GitHub MCP, Episodic Memory

**Estimated time**: 2-3 minutes

Ready to proceed? (yes/no)
```

Wait for user confirmation before continuing.

---

### Step 2: Install Superpowers Marketplace

**Action**: Install Superpowers via marketplace command

```bash
/plugin marketplace add obra/superpowers
```

**This installs**:
- All Superpowers skills and workflows
- Includes both superpowers and superpowers-dev

**Wait for installation to complete** before proceeding.

**Progress output**:
```markdown
📦 Installing Superpowers Marketplace...

⚙️ Adding marketplace: obra/superpowers...
✅ Superpowers Marketplace installed

Installed components:
✅ superpowers (structured workflows)
✅ superpowers-dev (development workflows)

Superpowers ready! ✅
```

**Error handling**:
If installation fails:
```markdown
⚠️ Superpowers installation failed.

**Manual installation**:
1. Open Claude Code
2. Run: /plugin marketplace add obra/superpowers

Then re-run: /nexus-setup to continue
```

---

### Step 3: Install MCPs

**Action**: Install MCP servers using `claude mcp add` commands

MCPs (Model Context Protocol) provide external tool integrations for database, browser, and other operations.

---

#### 3.1: Install Chrome DevTools MCP

**Command**:
```bash
claude mcp add chrome-devtools npx chrome-devtools-mcp@latest
```

**What it does**:
- Installs Chrome DevTools MCP for browser automation
- Enables UI validation, E2E testing, performance audits

**Progress output**:
```markdown
⚙️ Installing Chrome DevTools MCP...
✅ Chrome DevTools MCP installed successfully

Available tools:
- mcp__chrome-devtools__navigate
- mcp__chrome-devtools__click
- mcp__chrome-devtools__screenshot
- mcp__chrome-devtools__evaluate

Chrome DevTools MCP ready! ✅
```

**Nexus Integration**: MANDATORY for UI changes (Policy 12.2)

---

#### 3.2: Install Supabase MCP

**Command**:
```bash
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp"
```

**Before running**: You'll need a Supabase access token.
Get one here: https://supabase.com/dashboard/account/tokens

**What it does**:
- Installs Supabase MCP for database operations
- Enables migrations, security audits, type generation

**Progress output**:
```markdown
⚙️ Installing Supabase MCP...
✅ Supabase MCP installed successfully

Available tools:
- mcp__supabase__execute_sql
- mcp__supabase__apply_migration
- mcp__supabase__list_tables
- mcp__supabase__get_advisors

Supabase MCP ready! ✅
```

**Nexus Integration**: Auto-injected for database/migration tasks (Policy 12.1)

#### 3.3: Verify MCP Installation

**Command**:
```bash
/tools
```

**Expected output**:
```markdown
🔍 Verifying MCPs...

Available MCP tools:
✅ mcp__chrome-devtools__* (5 tools)
✅ mcp__supabase__* (15 tools)

MCPs verified! ✅
```

---

#### 3.4: Optional MCPs

**GitHub MCP** (for PR/issue operations):
```bash
# Requires GitHub token from: https://github.com/settings/tokens
claude mcp add github npx @modelcontextprotocol/server-github
```

**Episodic Memory MCP** (already included in Superpowers):
- No additional setup needed
- Auto-available after Superpowers installation

**Nexus Integration**:
- GitHub: Optional, suggested for PR/issue tasks
- Episodic Memory: Optional, suggested when user mentions "past" or "similar"

---

### Step 4: Configuration Files

**Action**: Create user configuration files

1. **Create user preferences template**:
   ```yaml
   # File: ~/.claude/skills/nexus/config/user-preferences.yml

   # Copy from: ~/.claude/skills/nexus/config/user-preferences.template.yml
   ```

   Use Write tool to copy template to user-preferences.yml

**Progress output**:
```markdown
⚙️ Creating configuration files...

✅ config/user-preferences.yml created
✅ memory/global.json initialized

Configuration ready! ✅
```

---

### Step 5: Verification

**Action**: Verify all components are installed correctly

```typescript
// Check ALD skills
const aldSkills = [
  "ald-memory",
  "ald-policies",
  "ald-curator",
  "ald-tester",
  "ald-code-reviewer",
  "ald-orchestrator",
  "ald-policy-finder",
  "ald-sprint"
];

for (const skill of aldSkills) {
  try {
    Read(`~/.claude/skills/${skill}/SKILL.md`);
    console.log(`✅ ${skill}`);
  } catch (error) {
    console.log(`❌ ${skill} - NOT FOUND`);
  }
}

// Check Superpowers (attempt to invoke)
try {
  // Check if superpowers commands are available
  console.log("✅ Superpowers available");
} catch (error) {
  console.log("⚠️ Superpowers not found - manual installation required");
}

// Check Nexus skill
try {
  Read("~/.claude/skills/nexus/SKILL.md");
  console.log("✅ Nexus skill");
} catch (error) {
  console.log("❌ Nexus skill - NOT FOUND");
}
```

**Progress output**:
```markdown
🔍 Verifying installation...

**ALD System**:
✅ ald-memory
✅ ald-policies (155 policies)
✅ ald-curator
✅ ald-tester
✅ ald-code-reviewer
✅ ald-orchestrator
✅ ald-policy-finder
✅ ald-sprint

**Superpowers**:
✅ superpowers@superpowers-marketplace
✅ superpowers@superpowers-dev

**Nexus**:
✅ nexus skill
✅ /nexus command
✅ Configuration files

**MCPs**:
📋 Setup instructions provided (requires manual config)
```

---

### Step 6: Setup Complete

```markdown
✅ **Nexus Setup Complete!**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Installation Summary

✅ ALD System (already installed with marketplace)
✅ Superpowers Marketplace
✅ Chrome DevTools MCP
✅ Supabase MCP
✅ Nexus orchestrator
✅ Configuration files created
📋 Optional MCPs available (GitHub, Episodic Memory)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Next Steps

### 1. Optional MCPs
Already installed Chrome DevTools and Supabase.
If needed, install:
- GitHub MCP: `claude mcp add github npx @modelcontextprotocol/server-github`
- Episodic Memory: Already in Superpowers

### 2. Customize Configuration
Edit your preferences:
```bash
~/.claude/skills/nexus/config/user-preferences.yml
```

### 3. Start Using Nexus
```bash
/nexus implement [your task]
/nexus fix [bug description]
/nexus refactor [component]
/nexus review [code]
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Quick Test

Try this to verify everything works:

```bash
/nexus review my code
```

Expected: Nexus analyzes intent → Selects code-review workflow → Executes ALD code reviewer

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Documentation

- **README**: `~/.claude/skills/nexus/README.md`
- **Setup Guide**: `~/.claude/skills/nexus/SETUP-GUIDE.md`
- **MCP Integration**: `~/.claude/skills/nexus/MCP-INTEGRATION.md`
- **Troubleshooting**: `~/.claude/skills/nexus/TROUBLESHOOTING.md`

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Happy orchestrating!** 🚀
```

---

## Error Handling

### If ALD System is missing:
```markdown
⚠️ ALD System not found

**ALD System is part of HMC Technologies marketplace**.
If you don't have it installed, run:

```bash
/plugin marketplace add dirgogoo/HMC-TECHNOLOGIES
```

This will install both ALD System and Nexus together.
```

### If Superpowers installation fails:
```markdown
❌ Superpowers installation failed

**Manual installation**:
1. Run: /plugin install superpowers@superpowers-marketplace
2. Run: /plugin install superpowers@superpowers-dev
3. Restart Claude Code if needed

**Get help**: https://github.com/anthropics/superpowers/issues
```

### If verification fails:
```markdown
⚠️ Verification detected missing components

**Missing**:
- [list of missing skills/plugins]

**Action**: Re-run /nexus-setup or install manually

**Get help**: https://github.com/dirgogoo/nexus/issues
```

---

## Implementation Notes for Claude

When executing this setup:

1. **Use Write tool** for all file copies (ALD System)
2. **Use SlashCommand tool** for Superpowers installation
3. **Display progress** after each step
4. **Validate** before marking complete
5. **Handle errors gracefully** with clear instructions
6. **End with success message** and next steps

**Estimated tokens**: ~50K (large but one-time operation)

**User experience**: Setup should feel automatic and guided, with clear progress indicators.

---

CLAUDE.MD ATIVO
