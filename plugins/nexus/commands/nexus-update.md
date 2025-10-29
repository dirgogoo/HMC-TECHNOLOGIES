# /nexus-update - Check and Update Nexus

Check GitHub for Nexus version updates and auto-update if newer version is available.

---

## Instructions for Claude

When `/nexus-update` is invoked, execute this update workflow:

### Step 1: Load Current Version

**Action**: Read current version from version.json

```typescript
Read("~/.claude/skills/nexus/version.json");
```

**Expected output**:
```json
{
  "version": "1.1.0",
  "last_updated": "2025-10-28",
  "update_check_url": "https://api.github.com/repos/dirgogoo/nexus/releases/latest",
  "repository": "https://github.com/dirgogoo/nexus"
}
```

**Store**:
```typescript
const currentVersion = "1.1.0"; // Parse from version.json
```

---

### Step 2: Fetch Latest Release from GitHub

**Action**: Use WebFetch to get latest release information

```typescript
WebFetch({
  url: "https://api.github.com/repos/dirgogoo/nexus/releases/latest",
  prompt: "Extract the tag_name, name, published_at, and tarball_url from this GitHub release"
});
```

**Expected response**:
```json
{
  "tag_name": "v1.2.0",
  "name": "Nexus v1.2.0 - Enhanced Workflows",
  "published_at": "2025-11-01T10:00:00Z",
  "tarball_url": "https://api.github.com/repos/dirgogoo/nexus/tarball/v1.2.0"
}
```

**Store**:
```typescript
const latestVersion = "1.2.0"; // Parse from tag_name (remove "v" prefix)
const releaseUrl = "https://api.github.com/repos/dirgogoo/nexus/tarball/v1.2.0";
```

---

### Step 3: Compare Versions

**Action**: Compare semantic versions (major.minor.patch)

```typescript
function compareVersions(current: string, latest: string): "outdated" | "up-to-date" {
  const [cMajor, cMinor, cPatch] = current.split(".").map(Number);
  const [lMajor, lMinor, lPatch] = latest.split(".").map(Number);

  if (lMajor > cMajor) return "outdated";
  if (lMajor === cMajor && lMinor > cMinor) return "outdated";
  if (lMajor === cMajor && lMinor === cMinor && lPatch > cPatch) return "outdated";

  return "up-to-date";
}

const status = compareVersions(currentVersion, latestVersion);
```

**Outcome A**: Up-to-date
```markdown
✅ **Nexus is up-to-date!**

Current version: v1.1.0
Latest version: v1.1.0

No update needed.
```
→ EXIT workflow

**Outcome B**: Outdated
```markdown
🆕 **Update Available!**

Current version: v1.1.0
Latest version: v1.2.0

Nexus v1.2.0 - Enhanced Workflows
Released: 2025-11-01

Would you like to update? (yes/no)
```
→ Wait for user confirmation before proceeding

---

### Step 4: User Confirmation (If Outdated)

**Action**: Wait for user response

**If user says "no" or "cancel"**:
```markdown
❌ Update cancelled.

You can update later by running: /nexus-update
```
→ EXIT workflow

**If user says "yes"**:
→ PROCEED to Step 5

---

### Step 5: Create Backup

**Action**: Backup current Nexus installation before updating

```bash
# Create backup directory with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.claude/skills/.nexus-backups/backup-$TIMESTAMP"

# Create backup
mkdir -p "$BACKUP_DIR"
cp -r "$HOME/.claude/skills/nexus" "$BACKUP_DIR/"
```

**Progress output**:
```markdown
📦 Creating backup...

✅ Backup created: ~/.claude/skills/.nexus-backups/backup-20251101_143022

This allows rollback if update fails.
```

**Error handling**:
If backup fails:
```markdown
❌ Backup creation failed!

Cannot proceed with update without backup.
Check directory permissions: ~/.claude/skills/.nexus-backups/

Error: [error message]
```
→ EXIT workflow

---

### Step 6: Download and Extract Update

**Action**: Download tarball and extract to temporary directory

```bash
# Create temp directory
TEMP_DIR=$(mktemp -d)

# Download tarball
curl -L "$RELEASE_URL" -o "$TEMP_DIR/nexus.tar.gz"

# Extract
cd "$TEMP_DIR"
tar -xzf nexus.tar.gz

# GitHub tarballs extract to: owner-repo-commitHash/
# Find the extracted directory
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "dirgogoo-nexus-*" | head -n 1)
```

**Progress output**:
```markdown
⬇️ Downloading Nexus v1.2.0...

✅ Downloaded: 2.4 MB

📦 Extracting files...

✅ Extracted to: /tmp/tmp.XYZ123/dirgogoo-nexus-abc1234/
```

**Error handling**:
If download fails:
```markdown
❌ Download failed!

Could not fetch release from GitHub.
Check internet connection and try again.

URL: https://api.github.com/repos/dirgogoo/nexus/tarball/v1.2.0
Error: [error message]

Backup preserved at: ~/.claude/skills/.nexus-backups/backup-20251101_143022
```
→ EXIT workflow

---

### Step 7: Install Update

**Action**: Replace current installation with new version

```bash
# Remove current installation (backup exists)
rm -rf "$HOME/.claude/skills/nexus"

# Copy new version
cp -r "$EXTRACTED_DIR" "$HOME/.claude/skills/nexus"

# Update version.json with new version
cat > "$HOME/.claude/skills/nexus/version.json" <<EOF
{
  "version": "$LATEST_VERSION",
  "last_updated": "$(date +%Y-%m-%d)",
  "update_check_url": "https://api.github.com/repos/dirgogoo/nexus/releases/latest",
  "repository": "https://github.com/dirgogoo/nexus"
}
EOF

# Cleanup temp directory
rm -rf "$TEMP_DIR"
```

**Progress output**:
```markdown
⚙️ Installing Nexus v1.2.0...

🗑️ Removing old version...
✅ Old version removed

📁 Installing new version...
✅ New version installed

📝 Updating version.json...
✅ Version file updated

🧹 Cleaning up temporary files...
✅ Cleanup complete
```

**Error handling**:
If installation fails:
```markdown
❌ Installation failed!

Error during file copy: [error message]

🔄 **Rolling back to previous version...**

[Execute rollback from backup]

✅ Rollback complete. Previous version restored.

Backup preserved at: ~/.claude/skills/.nexus-backups/backup-20251101_143022
```
→ EXIT workflow with rollback

---

### Step 8: Verify Installation

**Action**: Verify new version is correctly installed

```bash
# Verify SKILL.md exists
test -f "$HOME/.claude/skills/nexus/SKILL.md" || exit 1

# Verify version.json has correct version
grep "\"version\": \"$LATEST_VERSION\"" "$HOME/.claude/skills/nexus/version.json" || exit 1

# Verify key directories exist
test -d "$HOME/.claude/skills/nexus/workflows" || exit 1
test -d "$HOME/.claude/skills/nexus/commands" || exit 1
```

**Progress output**:
```markdown
🔍 Verifying installation...

✅ SKILL.md found
✅ version.json correct
✅ workflows/ directory present
✅ commands/ directory present

Installation verified!
```

**Error handling**:
If verification fails:
```markdown
❌ Verification failed!

Issue detected: [missing file/directory]

🔄 **Rolling back to previous version...**

[Execute rollback from backup]

✅ Rollback complete. Previous version restored.

Please report this issue: https://github.com/dirgogoo/nexus/issues
```
→ EXIT workflow with rollback

---

### Step 9: Run Migrations (If Needed)

**Action**: Check for and run migration scripts

```bash
# Check if migrations/ directory exists
if [ -d "$HOME/.claude/skills/nexus/migrations/" ]; then
  # Find migration scripts newer than backup version
  for migration in "$HOME/.claude/skills/nexus/migrations/"*.sh; do
    if [ -f "$migration" ]; then
      bash "$migration"
    fi
  done
fi
```

**Progress output** (if migrations exist):
```markdown
⚙️ Running migrations...

✅ Migration 001-update-workflow-schema.sh completed
✅ Migration 002-migrate-config-format.sh completed

Migrations complete!
```

**Progress output** (if no migrations):
```markdown
ℹ️ No migrations needed for this update.
```

---

### Step 10: Cleanup Old Backups

**Action**: Keep only the 5 most recent backups

```bash
# Count backups
BACKUP_COUNT=$(ls -1 "$HOME/.claude/skills/.nexus-backups/" | wc -l)

# If more than 5, remove oldest
if [ "$BACKUP_COUNT" -gt 5 ]; then
  cd "$HOME/.claude/skills/.nexus-backups/"
  ls -t | tail -n +6 | xargs rm -rf
fi
```

**Progress output**:
```markdown
🧹 Cleaning up old backups...

Keeping 5 most recent backups.
Removed 2 old backups.

✅ Backup cleanup complete
```

---

### Step 11: Success Message

**Action**: Display success summary

```markdown
✅ **Nexus Updated Successfully!**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Update Summary

**Previous version**: v1.1.0
**New version**: v1.2.0

**Updated**: 2025-11-01

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What's New in v1.2.0

[Fetch release notes from GitHub API and display here]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Next Steps

Nexus is ready to use with the latest features!

Try the new features:
```bash
/nexus [your task]
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Backup**: Previous version saved at:
`~/.claude/skills/.nexus-backups/backup-20251101_143022`

**Rollback**: If you encounter issues:
```bash
cp -r ~/.claude/skills/.nexus-backups/backup-20251101_143022/nexus ~/.claude/skills/
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Documentation**: https://github.com/dirgogoo/nexus#readme
**Issues**: https://github.com/dirgogoo/nexus/issues
```

---

## Error Recovery Workflow

### Rollback Procedure

If any step fails after Step 5 (backup created), execute rollback:

```bash
# Find most recent backup
LATEST_BACKUP=$(ls -t "$HOME/.claude/skills/.nexus-backups/" | head -n 1)

# Remove failed installation
rm -rf "$HOME/.claude/skills/nexus"

# Restore from backup
cp -r "$HOME/.claude/skills/.nexus-backups/$LATEST_BACKUP/nexus" "$HOME/.claude/skills/"
```

**Rollback output**:
```markdown
🔄 **Rolling Back Update**

❌ Update failed at: [step name]
📦 Restoring from backup: backup-20251101_143022

✅ Previous version restored successfully

Nexus v1.1.0 is active again.

**Troubleshooting**:
If the issue persists, report it here:
https://github.com/dirgogoo/nexus/issues

Include:
- Error message
- Current version
- Target version
```

---

## Implementation Notes for Claude

When executing `/nexus-update`:

1. **Use WebFetch** for GitHub API calls (not Bash curl if possible)
2. **Use Bash tool** for file operations (backup, copy, extract)
3. **Always create backup** before modifying anything
4. **Verify each step** before proceeding to next
5. **Handle errors gracefully** with clear messages and rollback
6. **Display progress** after each major step
7. **Preserve user data** (configs, custom workflows if they exist)

**Estimated execution time**: 2-4 minutes

**Token estimate**: ~15K tokens (reasonable for update operation)

---

## Version.json Schema

The `version.json` file stores:

```json
{
  "version": "1.1.0",              // Current installed version (semver)
  "last_updated": "2025-10-28",    // Date of last update (YYYY-MM-DD)
  "update_check_url": "https://api.github.com/repos/dirgogoo/nexus/releases/latest",
  "repository": "https://github.com/dirgogoo/nexus"
}
```

**Update on**:
- Manual update via `/nexus-update`
- Successful installation from `/plugin install`

---

## GitHub Release Format Expected

Nexus expects GitHub releases to follow this format:

```json
{
  "tag_name": "v1.2.0",
  "name": "Nexus v1.2.0 - Enhanced Workflows",
  "published_at": "2025-11-01T10:00:00Z",
  "body": "## What's New\n\n- Feature 1\n- Feature 2...",
  "tarball_url": "https://api.github.com/repos/dirgogoo/nexus/tarball/v1.2.0"
}
```

**Tag naming**: Must be `vX.Y.Z` (semantic versioning with "v" prefix)

---

## Testing Update Command

Before first release, test with:

```bash
# Simulate outdated version
echo '{"version":"1.0.0","last_updated":"2025-10-01","update_check_url":"https://api.github.com/repos/dirgogoo/nexus/releases/latest","repository":"https://github.com/dirgogoo/nexus"}' > ~/.claude/skills/nexus/version.json

# Run update
/nexus-update

# Should detect v1.1.0 as newer and offer to update
```

---

CLAUDE.MD ATIVO
