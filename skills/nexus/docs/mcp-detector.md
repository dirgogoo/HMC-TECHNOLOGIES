# MCP Detector - Auto-Discovery System

**Version**: 1.0.0
**Created**: 2025-10-28

---

## Overview

The MCP Detector is responsible for automatically discovering available MCP (Model Context Protocol) servers and registering them as Nexus plugins.

---

## Detection Algorithm

### Step 1: Scan Plugin Directories

```typescript
function scanForMcpServers(): McpServer[] {
  const pluginDirs = [
    "~/.claude/plugins/cache/",
    "~/.claude/plugins/marketplaces/"
  ];

  const mcpServers = [];

  for (const dir of pluginDirs) {
    const plugins = listDirectories(dir);

    for (const plugin of plugins) {
      const configPath = `${dir}/${plugin}/.claude-plugin/plugin.json`;

      if (fileExists(configPath)) {
        const config = readJson(configPath);

        if (config.mcpServers) {
          mcpServers.push({
            pluginName: plugin,
            servers: config.mcpServers
          });
        }
      }
    }
  }

  return mcpServers;
}
```

### Step 2: Identify Available MCP Tools

```typescript
function identifyMcpTools(serverPrefix: string): string[] {
  // List all available tools
  const allTools = listAvailableTools();

  // Filter by prefix (e.g., "mcp__supabase__")
  const mcpTools = allTools.filter(tool =>
    tool.startsWith(serverPrefix)
  );

  // Extract tool names (remove prefix)
  return mcpTools.map(tool =>
    tool.replace(serverPrefix, "")
  );
}

// Example:
// Input: "mcp__supabase__"
// Available tools: [
//   "mcp__supabase__execute_sql",
//   "mcp__supabase__apply_migration",
//   "mcp__supabase__get_advisors"
// ]
// Output: ["execute_sql", "apply_migration", "get_advisors"]
```

### Step 3: Map to Plugin Metadata

```typescript
function mapToPluginMetadata(
  serverName: string,
  availableTools: string[]
): McpPluginMetadata {
  // Load plugin.yml for this MCP server
  const pluginPath = `~/.claude/skills/nexus/plugins/mcp-${serverName}/plugin.yml`;

  if (!fileExists(pluginPath)) {
    return {
      name: `mcp-${serverName}`,
      status: "not_configured",
      availableTools,
      message: `Plugin metadata missing. Create ${pluginPath}`
    };
  }

  const metadata = readYaml(pluginPath);

  // Validate that hooks reference available tools
  for (const hook of metadata.hooks) {
    for (const tool of hook.mcp_tools) {
      if (!availableTools.includes(tool)) {
        console.warn(`Hook "${hook.name}" references unavailable tool "${tool}"`);
      }
    }
  }

  return {
    ...metadata,
    status: "ready",
    availableTools
  };
}
```

---

## Auto-Detection Triggers

### On Nexus Initialization

When Nexus orchestrator starts:

```typescript
function initializeNexus(): void {
  console.log("🔍 Detecting available MCP servers...");

  const mcpServers = scanForMcpServers();
  console.log(`Found ${mcpServers.length} MCP servers`);

  const mcpPlugins = [];

  for (const server of mcpServers) {
    for (const [serverName, serverConfig] of Object.entries(server.servers)) {
      const prefix = guessMcpPrefix(serverName, server.pluginName);
      const tools = identifyMcpTools(prefix);

      if (tools.length > 0) {
        const plugin = mapToPluginMetadata(serverName, tools);
        mcpPlugins.push(plugin);

        console.log(`✅ ${serverName}: ${tools.length} tools available`);
      } else {
        console.log(`⚠️  ${serverName}: No tools found with prefix "${prefix}"`);
      }
    }
  }

  // Update registry with detected MCPs
  updateRegistryWithMcps(mcpPlugins);
}
```

### Prefix Guessing

```typescript
function guessMcpPrefix(serverName: string, pluginName: string): string {
  // Pattern 1: Standard (mcp__serverName__)
  // Example: mcp__supabase__
  const standard = `mcp__${serverName}__`;

  // Pattern 2: Plugin-scoped (mcp__pluginName_serverName__)
  // Example: mcp__plugin_superpowers-chrome_chrome__
  const pluginScoped = `mcp__plugin_${pluginName}_${serverName}__`;

  // Pattern 3: Plugin-scoped with episodic-memory format
  // Example: mcp__plugin_episodic-memory_episodic-memory__
  const episodicFormat = `mcp__plugin_${pluginName}_${pluginName}__`;

  // Try patterns in order
  const allTools = listAvailableTools();

  if (allTools.some(tool => tool.startsWith(pluginScoped))) {
    return pluginScoped;
  }

  if (allTools.some(tool => tool.startsWith(episodicFormat))) {
    return episodicFormat;
  }

  return standard;
}
```

---

## Registry Updates

### Automatic Registration

```typescript
function updateRegistryWithMcps(mcpPlugins: McpPluginMetadata[]): void {
  const registry = readJson("~/.claude/skills/nexus/plugins/registry.json");

  for (const mcpPlugin of mcpPlugins) {
    // Check if already registered
    const existing = registry.plugins.find(p => p.name === mcpPlugin.name);

    if (existing) {
      // Update existing entry
      existing.description = mcpPlugin.description;
      existing.enabled = mcpPlugin.status === "ready";
    } else {
      // Add new entry
      registry.plugins.push({
        name: mcpPlugin.name,
        path: `~/.claude/skills/nexus/plugins/${mcpPlugin.name}/plugin.yml`,
        type: "mcp",
        enabled: mcpPlugin.status === "ready",
        priority: getNextMcpPriority(registry),
        description: mcpPlugin.description,
        auto_inject: mcpPlugin.mcp_config.auto_detect
      });
    }
  }

  writeJson("~/.claude/skills/nexus/plugins/registry.json", registry);
}

function getNextMcpPriority(registry: Registry): number {
  const mcpPlugins = registry.plugins.filter(p => p.type === "mcp");
  const maxPriority = Math.max(...mcpPlugins.map(p => p.priority), 9);
  return maxPriority + 1;
}
```

---

## Detection Examples

### Example 1: Supabase MCP

```typescript
// Detected from plugin.json:
{
  "name": "supabase-plugin",
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["@supabase/mcp-server"]
    }
  }
}

// Detection flow:
scanForMcpServers()
  → Found "supabase" server in "supabase-plugin"
  → Guess prefix: "mcp__supabase__"
  → Identify tools: ["execute_sql", "apply_migration", "get_advisors", ...]
  → Map to plugin: "~/.claude/skills/nexus/plugins/mcp-supabase/plugin.yml"
  → Status: ✅ ready (9 tools available)
```

### Example 2: Chrome DevTools MCP

```typescript
// Detected from plugin.json:
{
  "name": "superpowers-chrome",
  "mcpServers": {
    "chrome": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/mcp/dist/index.js"]
    }
  }
}

// Detection flow:
scanForMcpServers()
  → Found "chrome" server in "superpowers-chrome"
  → Guess prefix: "mcp__plugin_superpowers-chrome_chrome__"
  → Identify tools: ["use_browser"]
  → Map to plugin: "~/.claude/skills/nexus/plugins/mcp-chrome-devtools/plugin.yml"
  → Status: ✅ ready (1 tool available)
```

### Example 3: Missing Plugin Metadata

```typescript
// Detected from plugin.json:
{
  "name": "new-mcp-plugin",
  "mcpServers": {
    "awesome": {
      "command": "awesome-mcp"
    }
  }
}

// Detection flow:
scanForMcpServers()
  → Found "awesome" server
  → Guess prefix: "mcp__awesome__"
  → Identify tools: ["do_something", "do_another"]
  → Map to plugin: NOT FOUND
  → Status: ⚠️  not_configured
  → Message: "Create ~/.claude/skills/nexus/plugins/mcp-awesome/plugin.yml to enable"
```

---

## Error Handling

### Missing Plugin Metadata

If MCP server detected but no plugin.yml exists:
- Log warning with path to create
- Do NOT register in Nexus
- Suggest user create plugin.yml with template

### Tool Mismatch

If plugin.yml references tools not available:
- Log warning for each missing tool
- Still register plugin (partial functionality)
- Mark hook as "unavailable" if all tools missing

### Duplicate Servers

If same MCP server found in multiple plugins:
- Use first occurrence
- Log warning about duplicate
- Suggest consolidation

---

## Manual Override

Users can manually disable auto-detection in registry.json:

```json
{
  "mcp_config": {
    "auto_detect": false
  }
}
```

Or disable specific MCP plugin:

```json
{
  "name": "mcp-supabase",
  "enabled": false
}
```

---

## Testing Detection

```bash
# Test MCP detection
/nexus test-mcp-detection

# Expected output:
🔍 Detecting available MCP servers...
Found 3 MCP servers
✅ supabase: 9 tools available
✅ chrome: 1 tool available
✅ episodic-memory: 2 tools available
⚠️  github: No tools found (MCP not installed)

Registry updated: 3 MCPs registered
```

---

**Next**: See `mcp-injector.md` for how detected MCPs are injected into workflows.

CLAUDE.MD ATIVO
