#!/bin/bash

# HMC Technologies - Uninstaller
# Removes HMC Technologies installation from ~/.claude/

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Installation paths
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude-uninstall-backup-$(date +%Y%m%d-%H%M%S)"

echo "🗑️  HMC Technologies Uninstaller v3.0.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if installation exists
if [ ! -d "$CLAUDE_DIR/skills/nexus" ] && [ ! -f "$CLAUDE_DIR/commands/nexus.md" ]; then
    echo -e "${YELLOW}⚠️  No HMC Technologies installation found${NC}"
    echo "   Nothing to uninstall."
    exit 0
fi

# Ask for confirmation
echo -e "${YELLOW}⚠️  This will remove:${NC}"
echo "   - /nexus command"
echo "   - All ALD skills (9 skills)"
echo "   - Nexus orchestrator"
echo "   - Configuration files"
echo "   - Hooks"
echo ""
echo -e "${YELLOW}⚠️  User data will be backed up:${NC}"
echo "   - Backup location: $BACKUP_DIR"
echo ""
read -p "Continue with uninstallation? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstallation cancelled"
    exit 0
fi

# Create backup
echo ""
echo "📦 Creating backup..."
mkdir -p "$BACKUP_DIR"

# Backup user data directories
for skill in ald-memory ald-curator ald-sprint ald-tester ald-orchestrator; do
    if [ -d "$CLAUDE_DIR/skills/$skill/data" ]; then
        mkdir -p "$BACKUP_DIR/skills/$skill"
        cp -r "$CLAUDE_DIR/skills/$skill/data" "$BACKUP_DIR/skills/$skill/" 2>/dev/null || true
    fi

    # Backup specific data files
    if [ -d "$CLAUDE_DIR/skills/$skill/memory" ]; then
        mkdir -p "$BACKUP_DIR/skills/$skill"
        cp -r "$CLAUDE_DIR/skills/$skill/memory" "$BACKUP_DIR/skills/$skill/" 2>/dev/null || true
    fi

    if [ -d "$CLAUDE_DIR/skills/$skill/active" ]; then
        mkdir -p "$BACKUP_DIR/skills/$skill"
        cp -r "$CLAUDE_DIR/skills/$skill/active" "$BACKUP_DIR/skills/$skill/" 2>/dev/null || true
    fi
done

echo -e "${GREEN}✓${NC} User data backed up"

# Remove files
echo ""
echo "🗑️  Removing HMC Technologies files..."

# Remove command
if [ -f "$CLAUDE_DIR/commands/nexus.md" ]; then
    rm "$CLAUDE_DIR/commands/nexus.md"
    echo -e "${GREEN}✓${NC} Removed: commands/nexus.md"
fi

# Remove skills
HMC_SKILLS=(
    "ald-memory"
    "ald-policies"
    "ald-curator"
    "ald-tester"
    "ald-orchestrator"
    "ald-sprint"
    "ald-policy-finder"
    "ald-code-reviewer"
    "nexus"
)

for skill in "${HMC_SKILLS[@]}"; do
    if [ -d "$CLAUDE_DIR/skills/$skill" ]; then
        rm -rf "$CLAUDE_DIR/skills/$skill"
        echo -e "${GREEN}✓${NC} Removed: skills/$skill/"
    fi
done

# Remove config (only HMC files)
if [ -f "$CLAUDE_DIR/config/defaults.yml" ]; then
    # Backup before removing
    cp "$CLAUDE_DIR/config/defaults.yml" "$BACKUP_DIR/config-defaults.yml" 2>/dev/null || true
    rm "$CLAUDE_DIR/config/defaults.yml"
    echo -e "${GREEN}✓${NC} Removed: config/defaults.yml"
fi

if [ -d "$CLAUDE_DIR/config/i18n" ]; then
    cp -r "$CLAUDE_DIR/config/i18n" "$BACKUP_DIR/config-i18n" 2>/dev/null || true
    rm -rf "$CLAUDE_DIR/config/i18n"
    echo -e "${GREEN}✓${NC} Removed: config/i18n/"
fi

# Remove hooks (only HMC files)
if [ -f "$CLAUDE_DIR/hooks/hooks.json" ]; then
    cp "$CLAUDE_DIR/hooks/hooks.json" "$BACKUP_DIR/hooks.json" 2>/dev/null || true
    rm "$CLAUDE_DIR/hooks/hooks.json"
    echo -e "${GREEN}✓${NC} Removed: hooks/hooks.json"
fi

if [ -f "$CLAUDE_DIR/hooks/session-start.sh" ]; then
    cp "$CLAUDE_DIR/hooks/session-start.sh" "$BACKUP_DIR/session-start.sh" 2>/dev/null || true
    rm "$CLAUDE_DIR/hooks/session-start.sh"
    echo -e "${GREEN}✓${NC} Removed: hooks/session-start.sh"
fi

# Clean up empty directories
rmdir "$CLAUDE_DIR/commands" 2>/dev/null || true
rmdir "$CLAUDE_DIR/skills" 2>/dev/null || true
rmdir "$CLAUDE_DIR/config/i18n" 2>/dev/null || true
rmdir "$CLAUDE_DIR/config" 2>/dev/null || true
rmdir "$CLAUDE_DIR/hooks" 2>/dev/null || true

# Success message
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Uninstallation complete!${NC}"
echo ""
echo "📦 Backup saved: $BACKUP_DIR"
echo ""
echo "🔄 To restore your data:"
echo "   1. Reinstall HMC Technologies (./install.sh)"
echo "   2. Copy backed up data back:"
echo "      cp -r $BACKUP_DIR/skills/*/data ~/.claude/skills/"
echo "      cp -r $BACKUP_DIR/skills/*/memory ~/.claude/skills/"
echo ""
echo "🆘 Issues?"
echo "   - GitHub: https://github.com/dirgogoo/HMC-TECHNOLOGIES/issues"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
