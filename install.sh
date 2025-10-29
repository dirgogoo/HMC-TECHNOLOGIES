#!/bin/bash

# HMC Technologies - Automated Installer
# Installs commands, skills, config, and hooks directly to ~/.claude/

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Installation paths
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"

echo "🚀 HMC Technologies Installer v3.0.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if running from correct directory
if [ ! -f "./install.sh" ] || [ ! -d "./skills" ]; then
    echo -e "${RED}❌ Error: Must run from HMC-TECHNOLOGIES repository root${NC}"
    echo "   Usage: cd HMC-TECHNOLOGIES && ./install.sh"
    exit 1
fi

# Check if Claude directory exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}⚠️  ~/.claude directory not found${NC}"
    echo "   Creating $CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR"
fi

# Backup existing installation
if [ -d "$CLAUDE_DIR/skills" ] || [ -d "$CLAUDE_DIR/commands" ]; then
    echo -e "${YELLOW}⚠️  Existing installation detected${NC}"
    echo "   Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    [ -d "$CLAUDE_DIR/commands" ] && cp -r "$CLAUDE_DIR/commands" "$BACKUP_DIR/"
    [ -d "$CLAUDE_DIR/skills" ] && cp -r "$CLAUDE_DIR/skills" "$BACKUP_DIR/"
    [ -d "$CLAUDE_DIR/config" ] && cp -r "$CLAUDE_DIR/config" "$BACKUP_DIR/"
    [ -d "$CLAUDE_DIR/hooks" ] && cp -r "$CLAUDE_DIR/hooks" "$BACKUP_DIR/"

    echo -e "${GREEN}✓${NC} Backup created"
    echo ""
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/config/i18n"
mkdir -p "$CLAUDE_DIR/hooks"

# Install commands
echo "📝 Installing commands..."
cp -r commands/* "$CLAUDE_DIR/commands/"
echo -e "${GREEN}✓${NC} Commands installed"

# Install skills
echo "🎯 Installing skills (9 skills)..."
cp -r skills/* "$CLAUDE_DIR/skills/"
echo -e "${GREEN}✓${NC} Skills installed:"
echo "   - ald-memory (contextual memory)"
echo "   - ald-policies (155 coding policies)"
echo "   - ald-curator (learning system)"
echo "   - ald-tester (E2E validation)"
echo "   - ald-orchestrator (workflow coordination)"
echo "   - ald-sprint (sprint management)"
echo "   - ald-policy-finder (policy search)"
echo "   - ald-code-reviewer (policy compliance)"
echo "   - nexus (master orchestrator)"

# Install config
echo "⚙️  Installing configuration..."
cp config/defaults.yml "$CLAUDE_DIR/config/"
cp config/i18n/* "$CLAUDE_DIR/config/i18n/"
echo -e "${GREEN}✓${NC} Config installed (pt-BR + en-US)"

# Install hooks
echo "🪝 Installing hooks..."
cp hooks/hooks.json "$CLAUDE_DIR/hooks/"
cp hooks/session-start.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/session-start.sh"
echo -e "${GREEN}✓${NC} Hooks installed"

# Initialize empty data directories
echo "📂 Initializing data directories..."
for skill in ald-memory ald-curator ald-orchestrator ald-sprint ald-tester; do
    mkdir -p "$CLAUDE_DIR/skills/$skill/data"
done
echo -e "${GREEN}✓${NC} Data directories created"

# Verify installation
echo ""
echo "🔍 Verifying installation..."
ERRORS=0

[ ! -f "$CLAUDE_DIR/commands/nexus.md" ] && echo -e "${RED}✗${NC} Missing: commands/nexus.md" && ERRORS=$((ERRORS+1))
[ ! -d "$CLAUDE_DIR/skills/nexus" ] && echo -e "${RED}✗${NC} Missing: skills/nexus/" && ERRORS=$((ERRORS+1))
[ ! -f "$CLAUDE_DIR/config/defaults.yml" ] && echo -e "${RED}✗${NC} Missing: config/defaults.yml" && ERRORS=$((ERRORS+1))
[ ! -f "$CLAUDE_DIR/hooks/hooks.json" ] && echo -e "${RED}✗${NC} Missing: hooks/hooks.json" && ERRORS=$((ERRORS+1))

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All files verified"
else
    echo -e "${RED}❌ Installation incomplete (${ERRORS} errors)${NC}"
    exit 1
fi

# Success message
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "📍 Installed to: $CLAUDE_DIR"
echo "📦 Backup saved: $BACKUP_DIR"
echo ""
echo "🎯 Next steps:"
echo "   1. Restart Claude Code"
echo "   2. Use /nexus command to start workflows"
echo "   3. Commands available:"
echo "      - /nexus [task]  → Master orchestrator"
echo ""
echo "📖 Documentation:"
echo "   - README: skills/nexus/README.md"
echo "   - Workflows: skills/nexus/workflows/"
echo "   - Policies: skills/ald-policies/policies/"
echo ""
echo "🆘 Support:"
echo "   - GitHub: https://github.com/dirgogoo/HMC-TECHNOLOGIES"
echo "   - Issues: https://github.com/dirgogoo/HMC-TECHNOLOGIES/issues"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
