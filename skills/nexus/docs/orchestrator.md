# Orchestrator - Central Workflow Coordinator

The Orchestrator is the central engine that coordinates workflow execution across multiple plugins (Superpowers, ALD, MCPs).

**Version**: 2.0.0
**Component Type**: Core Engine
**Responsibility**: Phase coordination, plugin hook execution, state management

---

## Overview

The Orchestrator receives a selected workflow (YAML) and executes it phase-by-phase, coordinating hooks from multiple plugin systems while managing state, errors, and progress.

```
User Task → Intent Detector → Workflow Selection → ORCHESTRATOR → Unified Result
                                                         ↓
                                    ┌───────────────────┴────────────────────┐
                                    ↓                    ↓                    ↓
                              Superpowers            ALD System          MCP Plugins
                           (Brainstorm, TDD)    (Policies, Testing)   (Supabase, Chrome)
```

---

## Architecture

### 1. Orchestrator State Machine

```
IDLE → INITIALIZING → EXECUTING → COMPLETED
                  ↓                   ↓
                ERROR ←─────────── PAUSED
                  ↓
              ROLLBACK → IDLE
```

**States**:
- **IDLE**: No workflow active
- **INITIALIZING**: Loading context, validating prerequisites
- **EXECUTING**: Running workflow phases
- **PAUSED**: Workflow paused (user intervention or phase timeout)
- **ERROR**: Unrecoverable error occurred
- **ROLLBACK**: Reverting changes from failed workflow
- **COMPLETED**: All phases executed successfully

### 2. Phase Execution Cycle

```
For each phase in workflow:
  1. Pre-flight validation
  2. Hook execution (plugins)
  3. Result aggregation
  4. State persistence
  5. Error handling
  6. Progress update
```

---

## Phase Coordination Algorithm

### Algorithm: Execute Workflow

```typescript
function executeWorkflow(workflow: Workflow, userTask: string): WorkflowResult {
  // Step 0: Initialize
  const state = initializeWorkflowState(workflow);
  state.status = "INITIALIZING";

  // Step 1: Pre-flight validation
  const validation = validatePrerequisites(workflow);
  if (!validation.passed) {
    return {
      status: "ERROR",
      error: validation.errors,
      message: "Prerequisites not met. Run /nexus-setup or install missing MCPs."
    };
  }

  // Step 2: Execute phases sequentially
  state.status = "EXECUTING";
  for (const phase of workflow.phases) {
    console.log(`▶ Phase ${phase.id}: ${phase.name}`);

    // Step 2.1: Check phase timeout
    const timeout = phase.timeout || workflow.defaults.timeout || 300000; // 5 min default
    const phaseResult = await executePhaseWithTimeout(phase, state, timeout);

    // Step 2.2: Handle phase result
    if (phaseResult.status === "SUCCESS") {
      state.completedPhases.push(phase.id);
      state.results[phase.id] = phaseResult.output;
      persistState(state); // Save progress
      console.log(`✅ Phase ${phase.id} completed`);
    } else if (phaseResult.status === "TIMEOUT") {
      return handlePhaseTimeout(phase, state, workflow);
    } else if (phaseResult.status === "ERROR") {
      return handlePhaseError(phase, state, workflow, phaseResult.error);
    }
  }

  // Step 3: Finalize
  state.status = "COMPLETED";
  state.endTime = Date.now();
  persistState(state);
  logWorkflowExecution(state);

  return {
    status: "SUCCESS",
    workflowId: state.id,
    duration: state.endTime - state.startTime,
    phasesCompleted: state.completedPhases.length,
    results: aggregateResults(state.results)
  };
}
```

---

## Plugin Hook Execution Order

### Execution Model: Sequential per Phase

```
Phase: "load-context"
  ↓
  1. Execute ALD hooks (ald-memory/load-context)
  2. Execute Superpowers hooks (if any)
  3. Execute MCP hooks (episodic-memory/recall - if keyword detected)
  ↓
Phase: "validate"
  ↓
  1. Execute ALD hooks (ald-tester/validate)
  2. Execute MCP hooks (chrome-devtools/validate-ui - if UI task)
  3. Execute MCP hooks (supabase/security-audit - if database task)
```

### Hook Execution Function

```typescript
function executePhase(phase: Phase, state: WorkflowState): PhaseResult {
  const hooks = resolveHooksForPhase(phase, state);
  const results = [];

  for (const hook of hooks) {
    const plugin = getPlugin(hook.plugin);

    // Inject MCP if needed
    if (hook.mcp_required) {
      const mcpAvailable = checkMCPAvailability(hook.mcp_name);
      if (!mcpAvailable && hook.mcp_mandatory) {
        return {
          status: "ERROR",
          error: `Required MCP ${hook.mcp_name} not available`,
          hook: hook.id
        };
      } else if (!mcpAvailable) {
        console.warn(`⚠️  MCP ${hook.mcp_name} unavailable, skipping hook ${hook.id}`);
        continue;
      }
    }

    // Execute hook
    console.log(`  → Executing ${plugin.name}/${hook.id}`);
    const hookResult = plugin.executeHook(hook.id, {
      userTask: state.userTask,
      phaseContext: state.results,
      previousPhases: state.completedPhases
    });

    if (hookResult.status === "ERROR" && !hook.optional) {
      return {
        status: "ERROR",
        error: hookResult.error,
        hook: hook.id,
        plugin: plugin.name
      };
    }

    results.push(hookResult);
  }

  return {
    status: "SUCCESS",
    output: aggregateHookResults(results)
  };
}
```

---

## State Transitions

### State Persistence Format

```json
{
  "id": "workflow-20251029-123456",
  "workflowName": "feature-full",
  "userTask": "implement checkout with Stripe",
  "status": "EXECUTING",
  "startTime": 1730207096000,
  "endTime": null,
  "currentPhase": "validate",
  "completedPhases": ["load-context", "brainstorm", "plan", "execute"],
  "results": {
    "load-context": { "project": "ecommerce", "techStack": "Next.js" },
    "brainstorm": { "alternatives": [...], "selected": "..." },
    "plan": { "tasks": [...] },
    "execute": { "filesChanged": 5, "linesAdded": 234 }
  },
  "error": null,
  "metadata": {
    "nexusVersion": "2.0.0",
    "pluginsUsed": ["ald-system", "superpowers", "mcp-supabase"]
  }
}
```

### Persistence Triggers

1. **After phase completion** (successful)
2. **On error** (before error handling)
3. **On timeout** (before pause)
4. **On user interruption** (Ctrl+C)

---

## Error Propagation Handling

### Error Hierarchy

```
Plugin Hook Error
    ↓
Phase Error
    ↓
Workflow Error
    ↓
Orchestrator Error
    ↓
User-Facing Error Report
```

### Error Handling Strategy

```typescript
function handlePhaseError(
  phase: Phase,
  state: WorkflowState,
  workflow: Workflow,
  error: Error
): WorkflowResult {

  const strategy = phase.on_failure || workflow.defaults.on_failure || "abort";

  switch (strategy) {
    case "retry":
      if (state.retries[phase.id] < (phase.max_retries || 3)) {
        state.retries[phase.id]++;
        console.log(`⚠️  Retrying phase ${phase.id} (attempt ${state.retries[phase.id]})`);
        return executePhase(phase, state); // Recursive retry
      }
      // Fall through to abort if max retries reached

    case "skip":
      console.warn(`⚠️  Skipping phase ${phase.id} due to error: ${error.message}`);
      state.skippedPhases.push(phase.id);
      return { status: "SKIPPED", phase: phase.id };

    case "prompt":
      const userChoice = promptUser(
        `Phase ${phase.id} failed. What would you like to do?`,
        ["Retry", "Skip", "Abort"]
      );
      if (userChoice === "Retry") return executePhase(phase, state);
      if (userChoice === "Skip") return handlePhaseError(phase, state, workflow, error, "skip");
      // Fall through to abort

    case "abort":
    default:
      state.status = "ERROR";
      state.error = {
        phase: phase.id,
        message: error.message,
        stack: error.stack,
        timestamp: Date.now()
      };
      persistState(state);

      return {
        status: "ERROR",
        workflowId: state.id,
        phase: phase.id,
        error: error.message,
        message: `Workflow aborted at phase ${phase.id}. Use '/nexus resume ${state.id}' to resume.`
      };
  }
}
```

---

## MCP Injection Timing

MCP hooks are injected at **phase execution time**, not workflow selection time.

### MCP Injection Algorithm

```typescript
function resolveHooksForPhase(phase: Phase, state: WorkflowState): Hook[] {
  const hooks = phase.hooks || [];

  // Step 1: Detect MCP keywords in user task
  const mcpKeywords = detectMCPKeywords(state.userTask);

  // Step 2: Inject MCP hooks based on phase type and keywords
  if (phase.id === "validate") {
    if (mcpKeywords.includes("ui")) {
      hooks.push({
        id: "validate-ui",
        plugin: "mcp-chrome-devtools",
        mcp_required: true,
        mcp_name: "chrome-devtools",
        mcp_mandatory: true
      });
    }

    if (mcpKeywords.includes("database") || mcpKeywords.includes("migration")) {
      hooks.push({
        id: "security-audit",
        plugin: "mcp-supabase",
        mcp_required: true,
        mcp_name: "supabase",
        mcp_mandatory: true
      });
    }
  }

  if (phase.id === "load-context" && mcpKeywords.includes("remember")) {
    hooks.push({
      id: "recall-patterns",
      plugin: "mcp-episodic-memory",
      mcp_required: true,
      mcp_name: "episodic-memory",
      mcp_mandatory: false // Optional
    });
  }

  return hooks;
}
```

---

## Timeout Handling

### Timeout Strategy

```typescript
async function executePhaseWithTimeout(
  phase: Phase,
  state: WorkflowState,
  timeout: number
): Promise<PhaseResult> {

  return Promise.race([
    executePhase(phase, state),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error("TIMEOUT")), timeout)
    )
  ]).catch(error => {
    if (error.message === "TIMEOUT") {
      return {
        status: "TIMEOUT",
        phase: phase.id,
        elapsedTime: timeout
      };
    }
    throw error;
  });
}

function handlePhaseTimeout(
  phase: Phase,
  state: WorkflowState,
  workflow: Workflow
): WorkflowResult {

  const strategy = phase.on_timeout || workflow.defaults.on_timeout || "prompt";

  switch (strategy) {
    case "extend":
      console.warn(`⚠️  Phase ${phase.id} timed out. Extending timeout by 50%.`);
      return executePhaseWithTimeout(phase, state, phase.timeout * 1.5);

    case "skip":
      console.warn(`⚠️  Phase ${phase.id} timed out. Skipping.`);
      state.skippedPhases.push(phase.id);
      return { status: "SKIPPED", phase: phase.id };

    case "prompt":
    default:
      state.status = "PAUSED";
      persistState(state);

      const choice = promptUser(
        `Phase ${phase.id} timed out after ${phase.timeout}ms. What would you like to do?`,
        ["Extend timeout", "Skip phase", "Abort workflow"]
      );

      if (choice === "Extend timeout") return handlePhaseTimeout(phase, state, workflow, "extend");
      if (choice === "Skip phase") return handlePhaseTimeout(phase, state, workflow, "skip");

      state.status = "ERROR";
      return {
        status: "ERROR",
        message: `Workflow aborted due to phase ${phase.id} timeout.`
      };
  }
}
```

---

## Result Aggregation

### Aggregation Strategy

```typescript
function aggregateResults(phaseResults: Record<string, any>): UnifiedResult {
  return {
    summary: {
      phasesCompleted: Object.keys(phaseResults).length,
      filesChanged: sum(phaseResults, "filesChanged"),
      linesAdded: sum(phaseResults, "linesAdded"),
      testsRun: sum(phaseResults, "testsRun"),
      testsPasssed: sum(phaseResults, "testsPassed")
    },
    phases: phaseResults,
    recommendations: extractRecommendations(phaseResults),
    nextSteps: extractNextSteps(phaseResults),
    policiesEnforced: extractPolicies(phaseResults),
    learnings: extractLearnings(phaseResults)
  };
}
```

---

## Resume/Rollback Operations

### Resume Workflow

```typescript
function resumeWorkflow(workflowId: string): WorkflowResult {
  // Step 1: Load saved state
  const state = loadWorkflowState(workflowId);

  if (state.status !== "ERROR" && state.status !== "PAUSED") {
    return {
      status: "ERROR",
      message: `Cannot resume workflow ${workflowId}. Status is ${state.status}.`
    };
  }

  // Step 2: Determine resume point
  const workflow = loadWorkflow(state.workflowName);
  const failedPhaseIndex = workflow.phases.findIndex(p => p.id === state.currentPhase);

  // Step 3: Ask user where to resume from
  const choice = promptUser(
    "Resume workflow from:",
    [
      `Retry failed phase: ${state.currentPhase}`,
      `Start from previous phase: ${workflow.phases[failedPhaseIndex - 1]?.id}`,
      `Skip failed phase and continue`,
      `Abort and rollback`
    ]
  );

  // Step 4: Resume execution
  state.status = "EXECUTING";
  state.resumedAt = Date.now();

  if (choice.includes("Retry")) {
    return executeFromPhase(workflow, state, failedPhaseIndex);
  } else if (choice.includes("previous")) {
    return executeFromPhase(workflow, state, failedPhaseIndex - 1);
  } else if (choice.includes("Skip")) {
    state.skippedPhases.push(state.currentPhase);
    return executeFromPhase(workflow, state, failedPhaseIndex + 1);
  } else {
    return rollbackWorkflow(workflowId);
  }
}
```

### Rollback Workflow

```typescript
function rollbackWorkflow(workflowId: string): WorkflowResult {
  const state = loadWorkflowState(workflowId);

  console.log(`🔄 Rolling back workflow ${workflowId}...`);

  // Step 1: Revert file changes (if tracked)
  if (state.results.execute?.filesChanged) {
    revertFiles(state.results.execute.filesChanged);
  }

  // Step 2: Rollback database migrations (if any)
  if (state.results.execute?.migrationsApplied) {
    rollbackMigrations(state.results.execute.migrationsApplied);
  }

  // Step 3: Clean up temporary files
  cleanupTempFiles(state.id);

  // Step 4: Update state
  state.status = "ROLLBACK";
  state.rolledBackAt = Date.now();
  persistState(state);

  console.log(`✅ Workflow ${workflowId} rolled back successfully.`);

  return {
    status: "ROLLBACK",
    message: "Workflow rolled back. All changes reverted."
  };
}
```

---

## Integration with Other Core Components

### Dependencies

1. **intent-detector.md**: Provides initial task analysis
2. **workflow-engine.md**: Selects workflow based on intent
3. **mcp-detector.md**: Detects MCP keywords
4. **mcp-injector.md**: Injects MCP hooks into phases
5. **state-manager.md**: Persists and loads workflow state

### Call Flow

```
User Task
    ↓
intent-detector → analyze intent
    ↓
workflow-engine → select workflow
    ↓
orchestrator → initialize state
    ↓
orchestrator → execute phases (loop)
    ↓
    ├→ mcp-injector → inject MCP hooks
    ├→ plugin.executeHook() → run hooks
    ├→ state-manager → persist progress
    └→ orchestrator → aggregate results
    ↓
orchestrator → return unified result
```

---

## Configuration

### Orchestrator Configuration (defaults.yml)

```yaml
orchestrator:
  # Timeout settings
  default_phase_timeout: 300000  # 5 minutes
  max_workflow_duration: 7200000  # 2 hours

  # Error handling
  default_on_failure: "prompt"  # abort | retry | skip | prompt
  default_on_timeout: "prompt"  # abort | extend | skip | prompt
  max_retries: 3

  # State persistence
  state_persistence_enabled: true
  state_save_interval: 30000  # Save every 30 seconds
  state_file_path: "~/.claude/skills/nexus/history/.current-workflow.json"

  # Logging
  log_workflow_execution: true
  log_file_path: "~/.claude/skills/nexus/history/executions.jsonl"

  # Resume/rollback
  allow_resume: true
  allow_rollback: true

  # Progress reporting
  progress_update_interval: 10000  # Update every 10 seconds
  show_estimated_time_remaining: true
```

---

## Error Codes

| Code | Name | Description | Recovery |
|------|------|-------------|----------|
| ORCH-001 | PREREQUISITES_NOT_MET | Required plugins/MCPs missing | Run /nexus-setup |
| ORCH-002 | PHASE_TIMEOUT | Phase exceeded timeout | Resume with --extend-timeout |
| ORCH-003 | PHASE_ERROR | Phase execution failed | Resume from previous phase |
| ORCH-004 | MCP_UNAVAILABLE | Required MCP not available | Install MCP and resume |
| ORCH-005 | HOOK_ERROR | Plugin hook failed | Check plugin logs |
| ORCH-006 | STATE_CORRUPTION | Workflow state corrupted | Cannot resume, restart |
| ORCH-007 | INVALID_WORKFLOW | Workflow YAML invalid | Fix workflow file |

---

## Performance Considerations

### Optimization Strategies

1. **Parallel Hook Execution**: Execute independent hooks in parallel within a phase
2. **Lazy Plugin Loading**: Load plugins only when their hooks are needed
3. **State Compression**: Compress large phase results before persisting
4. **Incremental Logging**: Append to log file instead of rewriting
5. **Result Caching**: Cache expensive operations (e.g., policy lookups)

### Performance Metrics

```typescript
interface PerformanceMetrics {
  workflowStartTime: number;
  workflowEndTime: number;
  phaseTimings: Record<string, number>;
  hookTimings: Record<string, number>;
  statePeristenceTime: number;
  totalHooksExecuted: number;
  mcpsInjected: number;
}
```

---

## Testing

### Unit Tests

```typescript
describe("Orchestrator", () => {
  it("should execute all phases sequentially", () => {...});
  it("should handle phase errors according to strategy", () => {...});
  it("should inject MCP hooks correctly", () => {...});
  it("should persist state after each phase", () => {...});
  it("should resume from saved state", () => {...});
  it("should rollback workflow correctly", () => {...});
  it("should handle timeouts gracefully", () => {...});
});
```

### Integration Tests

See `INTEGRATION-TESTS.md` for full test suite.

---

## Related Documentation

- `workflow-engine.md` - Workflow selection logic
- `state-manager.md` - State persistence implementation
- `mcp-injector.md` - MCP hook injection
- `../plugins/registry.json` - Plugin registry
- `../workflows/*.yml` - Workflow definitions
- `../TROUBLESHOOTING.md` - Common orchestration issues

---

**Last Updated**: 2025-10-29
**Version**: 2.0.0
**Maintainer**: Nexus Team
