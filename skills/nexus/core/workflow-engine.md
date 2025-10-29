# Workflow Engine - Selection & Parsing System

The Workflow Engine is responsible for analyzing user intent, selecting the most appropriate workflow, and parsing/validating workflow YAML files.

**Version**: 2.0.0
**Component Type**: Core Engine
**Responsibility**: Intent analysis, workflow matching, YAML parsing, dependency resolution

---

## Overview

The Workflow Engine bridges the gap between user intent (detected by Intent Detector) and workflow execution (handled by Orchestrator).

```
User Task → Intent Detector → WORKFLOW ENGINE → Orchestrator
                                     ↓
                          1. Analyze intent
                          2. Match workflow
                          3. Parse YAML
                          4. Resolve dependencies
                          5. Validate configuration
                          6. Return workflow object
```

---

## Architecture

### Component Structure

```
Workflow Engine
├── Intent Analyzer (receives intent from intent-detector)
├── Workflow Matcher (selects best workflow)
├── YAML Parser (loads and validates YAML)
├── Dependency Resolver (resolves phase dependencies)
├── Configuration Validator (checks prerequisites)
└── Workflow Builder (constructs executable workflow object)
```

---

## Intent Analysis Algorithm

### Input: Detected Intent

```typescript
interface DetectedIntent {
  type: "feature-development" | "bugfix" | "refactor" | "review" | "spike" | "migration" | "documentation" | "performance";
  complexity: "small" | "medium" | "large";
  confidence: number; // 0.0 - 1.0
  keywords: string[];
  mcpKeywords: string[];
  estimatedDuration: number; // minutes
}
```

### Output: Workflow Recommendation

```typescript
interface WorkflowRecommendation {
  workflowFile: string; // e.g., "feature-full.yml"
  confidence: number;
  reasoning: string;
  alternatives: WorkflowRecommendation[];
  estimatedDuration: number;
  requiredPlugins: string[];
  requiredMCPs: string[];
}
```

### Algorithm: Analyze Intent and Recommend Workflow

```typescript
function analyzeAndRecommendWorkflow(intent: DetectedIntent, userTask: string): WorkflowRecommendation {
  // Step 1: Load available workflows
  const workflows = loadAllWorkflows();

  // Step 2: Score each workflow based on intent
  const scored = workflows.map(workflow => ({
    workflow,
    score: calculateWorkflowScore(workflow, intent, userTask)
  }));

  // Step 3: Sort by score (descending)
  scored.sort((a, b) => b.score - a.score);

  // Step 4: Select best match
  const best = scored[0];
  const alternatives = scored.slice(1, 4); // Top 3 alternatives

  // Step 5: Explain reasoning
  const reasoning = explainWorkflowChoice(best.workflow, intent, userTask);

  return {
    workflowFile: best.workflow.file,
    confidence: best.score,
    reasoning,
    alternatives: alternatives.map(a => ({
      workflowFile: a.workflow.file,
      confidence: a.score,
      reasoning: explainWorkflowChoice(a.workflow, intent, userTask)
    })),
    estimatedDuration: best.workflow.metadata.estimatedDuration,
    requiredPlugins: extractRequiredPlugins(best.workflow),
    requiredMCPs: extractRequiredMCPs(best.workflow, userTask)
  };
}
```

---

## Workflow Matching Logic

### Scoring Algorithm

```typescript
function calculateWorkflowScore(workflow: Workflow, intent: DetectedIntent, userTask: string): number {
  let score = 0;

  // Factor 1: Intent type match (weight: 40%)
  if (workflow.metadata.intendedFor.includes(intent.type)) {
    score += 0.4;
  }

  // Factor 2: Complexity match (weight: 20%)
  if (workflow.metadata.complexity === intent.complexity) {
    score += 0.2;
  } else if (Math.abs(complexityToNumber(workflow.metadata.complexity) - complexityToNumber(intent.complexity)) === 1) {
    score += 0.1; // Close match
  }

  // Factor 3: Keyword overlap (weight: 15%)
  const keywordOverlap = calculateKeywordOverlap(workflow.metadata.keywords, intent.keywords);
  score += keywordOverlap * 0.15;

  // Factor 4: Duration match (weight: 10%)
  const durationDiff = Math.abs(workflow.metadata.estimatedDuration - intent.estimatedDuration);
  const durationScore = 1 - (durationDiff / 180); // Normalize to 0-1 (max 180 min diff)
  score += Math.max(0, durationScore) * 0.10;

  // Factor 5: User history (weight: 10%)
  const historyScore = getUserPreferenceScore(workflow, userTask);
  score += historyScore * 0.10;

  // Factor 6: Required MCPs available (weight: 5%)
  const mcpAvailability = checkMCPAvailability(workflow, intent.mcpKeywords);
  score += mcpAvailability * 0.05;

  return Math.min(1.0, score); // Cap at 1.0
}

function complexityToNumber(complexity: string): number {
  switch (complexity) {
    case "small": return 1;
    case "medium": return 2;
    case "large": return 3;
    default: return 2;
  }
}

function calculateKeywordOverlap(workflowKeywords: string[], intentKeywords: string[]): number {
  const overlap = workflowKeywords.filter(k => intentKeywords.includes(k)).length;
  return overlap / Math.max(workflowKeywords.length, intentKeywords.length);
}

function getUserPreferenceScore(workflow: Workflow, userTask: string): number {
  // Check user history for similar tasks
  const history = loadWorkflowHistory();
  const similarTasks = history.filter(h => isSimilarTask(h.userTask, userTask));

  if (similarTasks.length === 0) return 0.5; // No history, neutral score

  const usageCount = similarTasks.filter(h => h.workflowUsed === workflow.file).length;
  return usageCount / similarTasks.length; // 0.0 - 1.0
}
```

---

## YAML Parsing & Validation

### Workflow YAML Schema v2.0

```yaml
# Example: workflows/feature-full.yml

metadata:
  name: "Full Feature Development with TDD"
  description: "Complete feature workflow with brainstorming, planning, TDD, and E2E validation"
  version: "2.0.0"
  intendedFor: ["feature-development"]
  complexity: "large"
  estimatedDuration: 90  # minutes
  keywords: ["tdd", "planning", "validation", "ui", "database"]

defaults:
  timeout: 300000  # 5 minutes per phase
  on_failure: "prompt"  # abort | retry | skip | prompt
  on_timeout: "prompt"  # abort | extend | skip | prompt
  max_retries: 3

required:
  plugins: ["ald-system", "superpowers"]
  mcps: []  # Optional MCPs injected based on keywords

phases:
  - id: "load-context"
    name: "Load Project Context"
    description: "Load memory, tech stack, and sprint status"
    timeout: 60000  # 1 minute
    hooks:
      - plugin: "ald-system"
        hook: "load-memory"
        required: true
    on_failure: "abort"

  - id: "brainstorm"
    name: "Brainstorm Solution"
    description: "Explore alternatives using Socratic questioning"
    timeout: 480000  # 8 minutes
    hooks:
      - plugin: "superpowers"
        hook: "brainstorm"
        required: true
    on_failure: "prompt"
    dependencies: ["load-context"]

  - id: "plan"
    name: "Create Implementation Plan"
    description: "Detailed plan with bite-sized tasks"
    timeout: 720000  # 12 minutes
    hooks:
      - plugin: "superpowers"
        hook: "write-plan"
        required: true
    dependencies: ["brainstorm"]

  # ... more phases ...

phases_optional:
  - id: "post-deploy"
    name: "Post-Deployment Validation"
    description: "Optional production smoke tests"
    hooks:
      - plugin: "mcp-vercel"
        hook: "smoke-test"
    skip_if_mcp_unavailable: true
```

### YAML Parser Implementation

```typescript
function parseWorkflowYAML(filePath: string): Workflow {
  // Step 1: Load and parse YAML
  const raw = readFile(filePath);
  const parsed = YAML.parse(raw);

  // Step 2: Validate schema
  const validation = validateWorkflowSchema(parsed);
  if (!validation.valid) {
    throw new Error(`Invalid workflow YAML: ${validation.errors.join(", ")}`);
  }

  // Step 3: Extract metadata
  const metadata = {
    name: parsed.metadata.name,
    description: parsed.metadata.description,
    version: parsed.metadata.version || "1.0.0",
    intendedFor: parsed.metadata.intendedFor || [],
    complexity: parsed.metadata.complexity || "medium",
    estimatedDuration: parsed.metadata.estimatedDuration || 60,
    keywords: parsed.metadata.keywords || []
  };

  // Step 4: Extract defaults
  const defaults = {
    timeout: parsed.defaults?.timeout || 300000,
    on_failure: parsed.defaults?.on_failure || "prompt",
    on_timeout: parsed.defaults?.on_timeout || "prompt",
    max_retries: parsed.defaults?.max_retries || 3
  };

  // Step 5: Parse phases
  const phases = parsed.phases.map(p => parsePhase(p, defaults));

  // Step 6: Parse optional phases
  const optionalPhases = (parsed.phases_optional || []).map(p => parsePhase(p, defaults));

  // Step 7: Extract requirements
  const required = {
    plugins: parsed.required?.plugins || [],
    mcps: parsed.required?.mcps || []
  };

  return {
    file: filePath,
    metadata,
    defaults,
    required,
    phases,
    optionalPhases
  };
}

function parsePhase(phaseData: any, defaults: any): Phase {
  return {
    id: phaseData.id,
    name: phaseData.name,
    description: phaseData.description || "",
    timeout: phaseData.timeout || defaults.timeout,
    hooks: phaseData.hooks || [],
    on_failure: phaseData.on_failure || defaults.on_failure,
    on_timeout: phaseData.on_timeout || defaults.on_timeout,
    dependencies: phaseData.dependencies || [],
    optional: phaseData.optional || false,
    skip_if_mcp_unavailable: phaseData.skip_if_mcp_unavailable || false
  };
}
```

### Schema Validation Rules

```typescript
const WORKFLOW_SCHEMA_V2 = {
  metadata: {
    name: { type: "string", required: true },
    description: { type: "string", required: true },
    version: { type: "string", required: false, pattern: /^\d+\.\d+\.\d+$/ },
    intendedFor: { type: "array", required: true, items: { type: "string" } },
    complexity: { type: "string", required: false, enum: ["small", "medium", "large"] },
    estimatedDuration: { type: "number", required: false, min: 1, max: 480 },
    keywords: { type: "array", required: false, items: { type: "string" } }
  },
  defaults: {
    timeout: { type: "number", required: false, min: 1000, max: 3600000 },
    on_failure: { type: "string", required: false, enum: ["abort", "retry", "skip", "prompt"] },
    on_timeout: { type: "string", required: false, enum: ["abort", "extend", "skip", "prompt"] },
    max_retries: { type: "number", required: false, min: 0, max: 10 }
  },
  required: {
    plugins: { type: "array", required: false, items: { type: "string" } },
    mcps: { type: "array", required: false, items: { type: "string" } }
  },
  phases: {
    type: "array",
    required: true,
    minItems: 1,
    items: {
      id: { type: "string", required: true, pattern: /^[a-z0-9-]+$/ },
      name: { type: "string", required: true },
      description: { type: "string", required: false },
      timeout: { type: "number", required: false },
      hooks: { type: "array", required: false },
      on_failure: { type: "string", required: false },
      on_timeout: { type: "string", required: false },
      dependencies: { type: "array", required: false, items: { type: "string" } },
      optional: { type: "boolean", required: false }
    }
  }
};

function validateWorkflowSchema(parsed: any): { valid: boolean; errors: string[] } {
  const errors: string[] = [];

  // Validate metadata
  if (!parsed.metadata) errors.push("Missing 'metadata' section");
  else {
    if (!parsed.metadata.name) errors.push("Missing 'metadata.name'");
    if (!parsed.metadata.description) errors.push("Missing 'metadata.description'");
    if (!parsed.metadata.intendedFor || !Array.isArray(parsed.metadata.intendedFor)) {
      errors.push("Missing or invalid 'metadata.intendedFor'");
    }
  }

  // Validate phases
  if (!parsed.phases || !Array.isArray(parsed.phases) || parsed.phases.length === 0) {
    errors.push("Missing or empty 'phases' array");
  } else {
    parsed.phases.forEach((phase, index) => {
      if (!phase.id) errors.push(`Phase ${index}: missing 'id'`);
      if (!phase.name) errors.push(`Phase ${index}: missing 'name'`);
      if (phase.id && !/^[a-z0-9-]+$/.test(phase.id)) {
        errors.push(`Phase ${index}: invalid 'id' format (must be lowercase alphanumeric with hyphens)`);
      }
    });
  }

  return {
    valid: errors.length === 0,
    errors
  };
}
```

---

## Phase Dependency Resolution

### Dependency Graph

```typescript
interface DependencyGraph {
  nodes: Phase[];
  edges: Map<string, string[]>; // phaseId -> [dependsOn...]
}

function buildDependencyGraph(phases: Phase[]): DependencyGraph {
  const graph: DependencyGraph = {
    nodes: phases,
    edges: new Map()
  };

  phases.forEach(phase => {
    graph.edges.set(phase.id, phase.dependencies || []);
  });

  return graph;
}

function resolveDependencies(graph: DependencyGraph): Phase[] {
  // Topological sort (Kahn's algorithm)
  const inDegree = new Map<string, number>();
  const queue: string[] = [];
  const sorted: Phase[] = [];

  // Step 1: Calculate in-degree for each node
  graph.nodes.forEach(node => {
    inDegree.set(node.id, 0);
  });

  graph.edges.forEach((deps, phaseId) => {
    deps.forEach(dep => {
      inDegree.set(dep, (inDegree.get(dep) || 0) + 1);
    });
  });

  // Step 2: Add nodes with in-degree 0 to queue
  graph.nodes.forEach(node => {
    if (inDegree.get(node.id) === 0) {
      queue.push(node.id);
    }
  });

  // Step 3: Process queue
  while (queue.length > 0) {
    const phaseId = queue.shift()!;
    const phase = graph.nodes.find(n => n.id === phaseId)!;
    sorted.push(phase);

    // Reduce in-degree for dependent phases
    const dependents = Array.from(graph.edges.entries())
      .filter(([_, deps]) => deps.includes(phaseId))
      .map(([id, _]) => id);

    dependents.forEach(depId => {
      const newDegree = (inDegree.get(depId) || 0) - 1;
      inDegree.set(depId, newDegree);
      if (newDegree === 0) {
        queue.push(depId);
      }
    });
  }

  // Step 4: Check for circular dependencies
  if (sorted.length !== graph.nodes.length) {
    throw new Error("Circular dependency detected in workflow phases");
  }

  return sorted;
}
```

### Example: Dependency Resolution

```yaml
phases:
  - id: "validate"
    dependencies: ["execute"]

  - id: "execute"
    dependencies: ["plan"]

  - id: "plan"
    dependencies: ["brainstorm"]

  - id: "brainstorm"
    dependencies: ["load-context"]

  - id: "load-context"
    dependencies: []
```

**Resolved Order**: `load-context → brainstorm → plan → execute → validate`

---

## Configuration Validation

### Pre-flight Checks

```typescript
function validateWorkflowConfiguration(workflow: Workflow, userTask: string): ValidationResult {
  const errors: string[] = [];
  const warnings: string[] = [];

  // Check 1: Required plugins available
  workflow.required.plugins.forEach(plugin => {
    if (!isPluginAvailable(plugin)) {
      errors.push(`Required plugin '${plugin}' not available. Install via /nexus-setup.`);
    }
  });

  // Check 2: Required MCPs available
  workflow.required.mcps.forEach(mcp => {
    if (!isMCPAvailable(mcp)) {
      errors.push(`Required MCP '${mcp}' not available. Install via 'claude mcp add ${mcp}'.`);
    }
  });

  // Check 3: Detected MCP keywords match available MCPs
  const mcpKeywords = detectMCPKeywords(userTask);
  mcpKeywords.forEach(keyword => {
    const requiredMCP = getMCPForKeyword(keyword);
    if (requiredMCP && !isMCPAvailable(requiredMCP.name)) {
      if (requiredMCP.mandatory) {
        errors.push(`Task requires MCP '${requiredMCP.name}' (keyword: ${keyword}). Install via 'claude mcp add ${requiredMCP.name}'.`);
      } else {
        warnings.push(`Task benefits from MCP '${requiredMCP.name}' (keyword: ${keyword}), but it's optional.`);
      }
    }
  });

  // Check 4: Phase dependencies are valid
  workflow.phases.forEach(phase => {
    phase.dependencies?.forEach(dep => {
      if (!workflow.phases.find(p => p.id === dep)) {
        errors.push(`Phase '${phase.id}' depends on non-existent phase '${dep}'`);
      }
    });
  });

  // Check 5: No circular dependencies
  try {
    const graph = buildDependencyGraph(workflow.phases);
    resolveDependencies(graph);
  } catch (error) {
    errors.push(error.message);
  }

  // Check 6: Workflow duration reasonable
  const totalDuration = workflow.metadata.estimatedDuration;
  if (totalDuration > 240) {
    warnings.push(`Workflow estimated at ${totalDuration} minutes. Consider using a smaller workflow for faster iteration.`);
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings
  };
}
```

---

## Workflow Builder

### Build Executable Workflow Object

```typescript
function buildExecutableWorkflow(
  workflow: Workflow,
  userTask: string,
  customization?: WorkflowCustomization
): ExecutableWorkflow {

  // Step 1: Resolve dependencies
  const graph = buildDependencyGraph(workflow.phases);
  const orderedPhases = resolveDependencies(graph);

  // Step 2: Apply customization (if any)
  let finalPhases = orderedPhases;
  if (customization) {
    if (customization.skipPhases) {
      finalPhases = finalPhases.filter(p => !customization.skipPhases.includes(p.id));
    }
    if (customization.addPhases) {
      finalPhases = [...finalPhases, ...customization.addPhases];
    }
    if (customization.reorderPhases) {
      finalPhases = reorderPhases(finalPhases, customization.reorderPhases);
    }
  }

  // Step 3: Inject MCP hooks
  finalPhases = finalPhases.map(phase => {
    const mcpHooks = getMCPHooksForPhase(phase, userTask);
    return {
      ...phase,
      hooks: [...(phase.hooks || []), ...mcpHooks]
    };
  });

  // Step 4: Build executable object
  return {
    id: generateWorkflowId(),
    workflowName: workflow.metadata.name,
    userTask,
    phases: finalPhases,
    metadata: workflow.metadata,
    defaults: workflow.defaults,
    status: "INITIALIZED",
    createdAt: Date.now()
  };
}

interface WorkflowCustomization {
  skipPhases?: string[];
  addPhases?: Phase[];
  reorderPhases?: string[];  // New phase order by IDs
}
```

---

## User Confirmation & Customization

### Interactive Workflow Selection

```typescript
function confirmWorkflowWithUser(recommendation: WorkflowRecommendation): {
  confirmed: boolean;
  customization?: WorkflowCustomization;
} {

  console.log(`\n🎯 Nexus recommends: ${recommendation.workflowFile}`);
  console.log(`   Reasoning: ${recommendation.reasoning}`);
  console.log(`   Estimated: ${recommendation.estimatedDuration} minutes`);

  if (recommendation.alternatives.length > 0) {
    console.log(`\n💡 Alternatives:`);
    recommendation.alternatives.forEach((alt, index) => {
      console.log(`   ${index + 1}. ${alt.workflowFile} (${alt.estimatedDuration} min)`);
    });
  }

  const choice = promptUser(
    "\nProceed with recommended workflow?",
    [
      "Yes, use recommended workflow",
      "Select alternative workflow",
      "Customize workflow (skip/add phases)",
      "Abort"
    ]
  );

  switch (choice) {
    case "Yes, use recommended workflow":
      return { confirmed: true };

    case "Select alternative workflow":
      const altIndex = promptUserForNumber("Enter alternative number (1-3):");
      const selected = recommendation.alternatives[altIndex - 1];
      return { confirmed: true, selectedWorkflow: selected.workflowFile };

    case "Customize workflow (skip/add phases)":
      return { confirmed: true, customization: promptForCustomization() };

    case "Abort":
    default:
      return { confirmed: false };
  }
}

function promptForCustomization(): WorkflowCustomization {
  const customization: WorkflowCustomization = {};

  const skipChoice = promptUser("Skip any phases?", ["Yes", "No"]);
  if (skipChoice === "Yes") {
    const phases = promptUserForPhaseList("Enter phase IDs to skip (comma-separated):");
    customization.skipPhases = phases;
  }

  const addChoice = promptUser("Add custom phases?", ["Yes", "No"]);
  if (addChoice === "Yes") {
    // Complex phase addition logic (omitted for brevity)
    customization.addPhases = [];
  }

  return customization;
}
```

---

## Workflow Selection Examples

### Example 1: Feature Development

```
User Task: "implement checkout with Stripe"

Intent Detection:
  - type: feature-development
  - complexity: large
  - keywords: ["implement", "checkout", "stripe"]
  - mcpKeywords: ["database", "ui"]

Workflow Matching Scores:
  1. feature-full.yml: 0.92 (RECOMMENDED)
     - Intent match: feature-development ✓
     - Complexity match: large ✓
     - Keywords: ["tdd", "ui", "database"] (high overlap)
     - User history: Used 3/5 times for similar tasks

  2. feature-quick.yml: 0.65
     - Intent match: feature-development ✓
     - Complexity mismatch: medium (expected large)
     - Faster but less thorough

  3. feature-tdd.yml: 0.58
     - Intent match: feature-development ✓
     - Too strict for initial implementation

Recommendation: feature-full.yml
Reasoning: Large feature requiring UI + database integration. TDD recommended. History shows preference for full workflow.
```

### Example 2: Bugfix

```
User Task: "fix cart total calculation bug"

Intent Detection:
  - type: bugfix
  - complexity: small
  - keywords: ["fix", "bug", "calculation"]
  - mcpKeywords: []

Workflow Matching Scores:
  1. bugfix.yml: 0.95 (RECOMMENDED)
     - Intent match: bugfix ✓
     - Complexity match: small ✓
     - Duration: 15-30 min (appropriate)

  2. hotfix.yml: 0.42
     - Too fast, skips important debugging steps

Recommendation: bugfix.yml
Reasoning: Standard bugfix workflow with systematic debugging.
```

---

## Error Handling

### Engine Error Codes

| Code | Name | Description | Recovery |
|------|------|-------------|----------|
| WE-001 | WORKFLOW_NOT_FOUND | Workflow file doesn't exist | Check workflows/ directory |
| WE-002 | INVALID_YAML | YAML syntax error | Fix workflow YAML |
| WE-003 | SCHEMA_VALIDATION_FAILED | Workflow doesn't match schema | Update to v2.0 schema |
| WE-004 | CIRCULAR_DEPENDENCY | Phase dependencies form cycle | Remove circular dependencies |
| WE-005 | MISSING_PHASE_DEPENDENCY | Phase depends on non-existent phase | Fix dependencies |
| WE-006 | NO_WORKFLOW_MATCH | No workflow matches intent | Provide more specific task description |

---

## Performance Optimizations

### Caching Strategy

```typescript
// Cache parsed workflows to avoid re-parsing
const workflowCache = new Map<string, Workflow>();

function loadWorkflow(file: string): Workflow {
  if (workflowCache.has(file)) {
    return workflowCache.get(file)!;
  }

  const workflow = parseWorkflowYAML(file);
  workflowCache.set(file, workflow);
  return workflow;
}

// Invalidate cache when workflow files change
watchWorkflowDirectory(() => {
  workflowCache.clear();
});
```

---

## Integration Points

### With Other Core Components

1. **intent-detector.md** → Provides initial intent analysis
2. **workflow-engine.md** (this) → Selects and parses workflow
3. **orchestrator.md** → Executes selected workflow
4. **mcp-detector.md** → Detects MCP keywords for hook injection

### Call Flow

```
User Task
    ↓
intent-detector.analyze() → DetectedIntent
    ↓
workflow-engine.recommend() → WorkflowRecommendation
    ↓
workflow-engine.confirm() → User confirmation
    ↓
workflow-engine.build() → ExecutableWorkflow
    ↓
orchestrator.execute() → Workflow execution
```

---

## Configuration

### Engine Configuration (defaults.yml)

```yaml
workflow_engine:
  # Workflow directory
  workflow_dir: "~/.claude/skills/nexus/workflows"

  # Workflow matching
  confidence_threshold: 0.5  # Minimum confidence to recommend
  max_alternatives: 3  # Number of alternative workflows to show

  # User preferences
  remember_user_choices: true
  preference_weight: 0.10  # Weight for user history in scoring

  # Validation
  validate_on_load: true
  strict_schema_validation: false  # Allow extra fields if false

  # Caching
  cache_parsed_workflows: true
  cache_invalidation_on_file_change: true
```

---

## Testing

### Unit Tests

```typescript
describe("WorkflowEngine", () => {
  it("should parse valid YAML workflow", () => {...});
  it("should reject invalid YAML workflow", () => {...});
  it("should score workflows correctly", () => {...});
  it("should detect circular dependencies", () => {...});
  it("should resolve phase dependencies correctly", () => {...});
  it("should inject MCP hooks based on keywords", () => {...});
  it("should apply user customization", () => {...});
});
```

---

## Related Documentation

- `intent-detector.md` - Intent detection logic
- `orchestrator.md` - Workflow execution
- `mcp-injector.md` - MCP hook injection
- `../workflows/*.yml` - Workflow definitions
- `../TROUBLESHOOTING.md` - Common workflow selection issues

---

**Last Updated**: 2025-10-29
**Version**: 2.0.0
**Maintainer**: Nexus Team
