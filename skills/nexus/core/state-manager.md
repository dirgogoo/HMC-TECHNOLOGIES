# State Manager - Workflow State Persistence & Recovery

The State Manager is responsible for persisting workflow state, enabling resume/rollback operations, and managing workflow history.

**Version**: 2.0.0
**Component Type**: Core Engine
**Responsibility**: State persistence, state loading, history tracking, resume/rollback support

---

## Overview

The State Manager ensures workflow progress is never lost, enabling users to resume from failures, rollback changes, and track execution history.

```
Orchestrator → STATE MANAGER → File System
                     ↓
             ┌───────┴────────┐
             ↓                ↓
     Current State      History Log
  (.current-workflow)  (executions.jsonl)
```

---

## Architecture

### State Storage Structure

```
~/.claude/skills/nexus/history/
├── .current-workflow.json      # Active workflow state (single file)
├── executions.jsonl            # All workflow executions (append-only)
├── daily-summary.json          # Aggregated statistics
└── backups/                    # State backups
    ├── workflow-20251029-123456.json
    ├── workflow-20251029-145632.json
    └── ...
```

---

## State Schema

### Current Workflow State (JSON)

```typescript
interface WorkflowState {
  // Identification
  id: string;                    // e.g., "workflow-20251029-123456"
  workflowName: string;          // e.g., "feature-full"
  workflowFile: string;          // e.g., "feature-full.yml"
  userTask: string;              // Original user task

  // Status
  status: WorkflowStatus;        // INITIALIZING | EXECUTING | PAUSED | ERROR | COMPLETED | ROLLBACK
  currentPhase: string | null;   // Current phase ID
  currentPhaseStartTime: number | null;

  // Timeline
  startTime: number;             // Timestamp (ms)
  endTime: number | null;        // Timestamp (ms) or null if not finished
  pausedAt: number | null;       // Timestamp when paused
  resumedAt: number | null;      // Timestamp when resumed

  // Progress
  completedPhases: string[];     // Array of completed phase IDs
  skippedPhases: string[];       // Array of skipped phase IDs
  failedPhases: string[];        // Array of failed phase IDs

  // Results
  results: Record<string, any>;  // Phase ID → Phase result

  // Error tracking
  error: WorkflowError | null;   // Error details if failed
  retries: Record<string, number>; // Phase ID → retry count

  // Metadata
  metadata: {
    nexusVersion: string;        // e.g., "2.0.0"
    pluginsUsed: string[];       // e.g., ["ald-system", "superpowers"]
    mcpsUsed: string[];          // e.g., ["supabase", "chrome-devtools"]
    totalPhases: number;
    estimatedDuration: number;   // minutes
  };

  // Resume/Rollback
  checkpoints: Checkpoint[];     // State checkpoints for rollback
  rollbackAvailable: boolean;
}

type WorkflowStatus =
  | "INITIALIZING"   // Loading context, validating prerequisites
  | "EXECUTING"      // Running phases
  | "PAUSED"         // Paused (timeout, user intervention)
  | "ERROR"          // Failed with error
  | "COMPLETED"      // Successfully completed
  | "ROLLBACK";      // Rolled back

interface WorkflowError {
  phase: string;              // Phase ID where error occurred
  message: string;            // Error message
  stack?: string;             // Stack trace (if available)
  timestamp: number;          // When error occurred
  recoverable: boolean;       // Can workflow resume?
}

interface Checkpoint {
  id: string;                 // Checkpoint ID
  phase: string;              // Phase ID at checkpoint
  timestamp: number;          // When checkpoint created
  filesSnapshot: FileSnapshot[]; // Files state (for rollback)
  databaseSnapshot: any;      // Database state (for migrations)
}
```

---

## State Persistence Operations

### Save Current State

```typescript
function persistState(state: WorkflowState): void {
  const statePath = getStatePath();

  // Step 1: Create backup of existing state (if any)
  if (fileExists(statePath)) {
    const backup = `${getBackupDir()}/${state.id}.json`;
    copyFile(statePath, backup);
  }

  // Step 2: Write new state
  const json = JSON.stringify(state, null, 2);
  writeFile(statePath, json);

  // Step 3: Log to execution history
  appendToHistory(state);
}

function getStatePath(): string {
  return expandPath("~/.claude/skills/nexus/history/.current-workflow.json");
}

function getBackupDir(): string {
  return expandPath("~/.claude/skills/nexus/history/backups");
}
```

### Load Current State

```typescript
function loadWorkflowState(workflowId?: string): WorkflowState | null {
  // If workflowId provided, load from backups
  if (workflowId) {
    const backupPath = `${getBackupDir()}/${workflowId}.json`;
    if (fileExists(backupPath)) {
      return JSON.parse(readFile(backupPath));
    }
    throw new Error(`Workflow ${workflowId} not found in backups`);
  }

  // Otherwise, load current workflow
  const statePath = getStatePath();
  if (!fileExists(statePath)) {
    return null; // No active workflow
  }

  const json = readFile(statePath);
  return JSON.parse(json);
}
```

### Clear Current State

```typescript
function clearCurrentState(): void {
  const statePath = getStatePath();
  if (fileExists(statePath)) {
    deleteFile(statePath);
  }
}
```

---

## History Tracking

### Execution Log Format (JSONL)

Each line in `executions.jsonl` is a complete JSON object representing one workflow execution.

```jsonl
{"id":"workflow-20251029-123456","workflowName":"feature-full","userTask":"implement checkout","status":"COMPLETED","duration":4500000,"phasesCompleted":10,"timestamp":1730207096000}
{"id":"workflow-20251029-145632","workflowName":"bugfix","userTask":"fix cart total bug","status":"COMPLETED","duration":1200000,"phasesCompleted":5,"timestamp":1730212432000}
{"id":"workflow-20251029-163018","workflowName":"feature-quick","userTask":"add wishlist","status":"ERROR","duration":1800000,"phasesCompleted":4,"timestamp":1730218218000}
```

### Append to History

```typescript
function appendToHistory(state: WorkflowState): void {
  const historyPath = getHistoryPath();

  const entry: HistoryEntry = {
    id: state.id,
    workflowName: state.workflowName,
    userTask: state.userTask,
    status: state.status,
    duration: state.endTime ? state.endTime - state.startTime : null,
    phasesCompleted: state.completedPhases.length,
    phasesFailed: state.failedPhases.length,
    phasesSkipped: state.skippedPhases.length,
    pluginsUsed: state.metadata.pluginsUsed,
    mcpsUsed: state.metadata.mcpsUsed,
    timestamp: state.startTime,
    error: state.error?.message || null
  };

  const line = JSON.stringify(entry) + "\n";
  appendToFile(historyPath, line);
}

function getHistoryPath(): string {
  return expandPath("~/.claude/skills/nexus/history/executions.jsonl");
}
```

### Query History

```typescript
function queryHistory(filter?: HistoryFilter): HistoryEntry[] {
  const historyPath = getHistoryPath();
  if (!fileExists(historyPath)) return [];

  const lines = readFile(historyPath).split("\n").filter(Boolean);
  let entries = lines.map(line => JSON.parse(line) as HistoryEntry);

  // Apply filters
  if (filter) {
    if (filter.workflowName) {
      entries = entries.filter(e => e.workflowName === filter.workflowName);
    }
    if (filter.status) {
      entries = entries.filter(e => e.status === filter.status);
    }
    if (filter.since) {
      entries = entries.filter(e => e.timestamp >= filter.since);
    }
    if (filter.userTaskContains) {
      entries = entries.filter(e => e.userTask.includes(filter.userTaskContains));
    }
  }

  return entries;
}

interface HistoryFilter {
  workflowName?: string;
  status?: WorkflowStatus;
  since?: number;           // Timestamp
  userTaskContains?: string;
}
```

---

## Checkpoint System

### Create Checkpoint

```typescript
function createCheckpoint(state: WorkflowState, phase: Phase): Checkpoint {
  const checkpoint: Checkpoint = {
    id: `checkpoint-${Date.now()}`,
    phase: phase.id,
    timestamp: Date.now(),
    filesSnapshot: captureFilesSnapshot(),
    databaseSnapshot: captureDatabaseSnapshot() // If migration workflow
  };

  state.checkpoints.push(checkpoint);
  persistState(state);

  return checkpoint;
}

function captureFilesSnapshot(): FileSnapshot[] {
  // Capture current state of modified files
  const gitStatus = execSync("git status --porcelain").toString();
  const files = parseGitStatus(gitStatus);

  return files.map(file => ({
    path: file.path,
    status: file.status,        // M, A, D, etc.
    contentHash: hashFile(file.path),
    timestamp: Date.now()
  }));
}

function captureDatabaseSnapshot(): any {
  // For migration workflows, capture database schema
  // Implementation depends on database type (e.g., Supabase)
  return {
    migrations: getCurrentMigrations(),
    schema: getDatabaseSchema()
  };
}
```

### Rollback to Checkpoint

```typescript
function rollbackToCheckpoint(state: WorkflowState, checkpointId: string): void {
  const checkpoint = state.checkpoints.find(c => c.id === checkpointId);
  if (!checkpoint) {
    throw new Error(`Checkpoint ${checkpointId} not found`);
  }

  console.log(`🔄 Rolling back to checkpoint: ${checkpoint.phase}`);

  // Step 1: Rollback file changes
  checkpoint.filesSnapshot.forEach(snapshot => {
    rollbackFile(snapshot);
  });

  // Step 2: Rollback database changes (if any)
  if (checkpoint.databaseSnapshot) {
    rollbackDatabase(checkpoint.databaseSnapshot);
  }

  // Step 3: Update state
  const checkpointIndex = state.checkpoints.indexOf(checkpoint);
  state.checkpoints = state.checkpoints.slice(0, checkpointIndex + 1);
  state.completedPhases = state.completedPhases.filter(p => {
    const phaseIndex = state.completedPhases.indexOf(p);
    const checkpointPhaseIndex = state.completedPhases.indexOf(checkpoint.phase);
    return phaseIndex <= checkpointPhaseIndex;
  });

  state.status = "PAUSED";
  persistState(state);

  console.log(`✅ Rolled back to phase: ${checkpoint.phase}`);
}

function rollbackFile(snapshot: FileSnapshot): void {
  // Revert file to snapshot state
  if (snapshot.status === "A") {
    // File was added, delete it
    deleteFile(snapshot.path);
  } else if (snapshot.status === "D") {
    // File was deleted, restore from git
    execSync(`git checkout HEAD -- ${snapshot.path}`);
  } else if (snapshot.status === "M") {
    // File was modified, restore from git
    execSync(`git checkout HEAD -- ${snapshot.path}`);
  }
}
```

---

## Resume Operations

### Resume Workflow

```typescript
function resumeWorkflow(workflowId: string, resumeStrategy: ResumeStrategy): WorkflowResult {
  // Step 1: Load state
  const state = loadWorkflowState(workflowId);
  if (!state) {
    throw new Error(`Workflow ${workflowId} not found`);
  }

  if (state.status !== "ERROR" && state.status !== "PAUSED") {
    throw new Error(`Cannot resume workflow with status: ${state.status}`);
  }

  // Step 2: Validate workflow still exists
  const workflow = loadWorkflow(state.workflowFile);
  if (!workflow) {
    throw new Error(`Workflow file ${state.workflowFile} not found`);
  }

  // Step 3: Determine resume point
  const currentPhaseIndex = workflow.phases.findIndex(p => p.id === state.currentPhase);
  let resumePhaseIndex: number;

  switch (resumeStrategy) {
    case "retry-current":
      resumePhaseIndex = currentPhaseIndex;
      break;

    case "retry-previous":
      resumePhaseIndex = Math.max(0, currentPhaseIndex - 1);
      state.completedPhases.pop(); // Remove last completed phase
      break;

    case "skip-current":
      state.skippedPhases.push(state.currentPhase!);
      resumePhaseIndex = currentPhaseIndex + 1;
      break;

    case "from-checkpoint":
      // User selects checkpoint
      const checkpoint = selectCheckpoint(state);
      rollbackToCheckpoint(state, checkpoint.id);
      resumePhaseIndex = workflow.phases.findIndex(p => p.id === checkpoint.phase);
      break;

    default:
      throw new Error(`Unknown resume strategy: ${resumeStrategy}`);
  }

  // Step 4: Update state
  state.status = "EXECUTING";
  state.resumedAt = Date.now();
  state.error = null; // Clear error
  persistState(state);

  // Step 5: Resume execution
  console.log(`▶ Resuming workflow from phase: ${workflow.phases[resumePhaseIndex].id}`);
  return executeFromPhase(workflow, state, resumePhaseIndex);
}

type ResumeStrategy =
  | "retry-current"      // Retry failed phase
  | "retry-previous"     // Re-run previous phase
  | "skip-current"       // Skip failed phase
  | "from-checkpoint";   // Rollback to checkpoint
```

---

## Rollback Operations

### Full Workflow Rollback

```typescript
function rollbackWorkflow(workflowId: string): void {
  // Step 1: Load state
  const state = loadWorkflowState(workflowId);
  if (!state) {
    throw new Error(`Workflow ${workflowId} not found`);
  }

  console.log(`🔄 Rolling back workflow: ${state.id}`);

  // Step 2: Rollback to first checkpoint (before any changes)
  if (state.checkpoints.length > 0) {
    const firstCheckpoint = state.checkpoints[0];
    rollbackToCheckpoint(state, firstCheckpoint.id);
  }

  // Step 3: Clean up any remaining changes
  cleanupWorkflowArtifacts(state);

  // Step 4: Update state
  state.status = "ROLLBACK";
  state.endTime = Date.now();
  persistState(state);

  // Step 5: Clear current workflow
  clearCurrentState();

  console.log(`✅ Workflow ${workflowId} rolled back successfully`);
}

function cleanupWorkflowArtifacts(state: WorkflowState): void {
  // Remove temporary files
  const tempDir = `~/.claude/skills/nexus/temp/${state.id}`;
  if (dirExists(tempDir)) {
    deleteDir(tempDir);
  }

  // Rollback uncommitted git changes
  const gitStatus = execSync("git status --porcelain").toString();
  if (gitStatus.trim().length > 0) {
    const confirm = promptUser(
      "Uncommitted changes detected. Rollback git changes?",
      ["Yes", "No"]
    );
    if (confirm === "Yes") {
      execSync("git reset --hard HEAD");
      execSync("git clean -fd");
    }
  }
}
```

---

## State Validation

### Validate State Integrity

```typescript
function validateState(state: WorkflowState): { valid: boolean; errors: string[] } {
  const errors: string[] = [];

  // Check required fields
  if (!state.id) errors.push("Missing 'id'");
  if (!state.workflowName) errors.push("Missing 'workflowName'");
  if (!state.userTask) errors.push("Missing 'userTask'");
  if (!state.status) errors.push("Missing 'status'");

  // Check status consistency
  if (state.status === "COMPLETED" && !state.endTime) {
    errors.push("COMPLETED status requires 'endTime'");
  }

  if (state.status === "ERROR" && !state.error) {
    errors.push("ERROR status requires 'error' object");
  }

  if (state.status === "EXECUTING" && !state.currentPhase) {
    errors.push("EXECUTING status requires 'currentPhase'");
  }

  // Check phase consistency
  if (state.completedPhases.some(p => state.failedPhases.includes(p))) {
    errors.push("Phase cannot be both completed and failed");
  }

  // Check timestamps
  if (state.endTime && state.endTime < state.startTime) {
    errors.push("endTime cannot be before startTime");
  }

  return {
    valid: errors.length === 0,
    errors
  };
}
```

---

## Statistics & Analytics

### Daily Summary

```typescript
interface DailySummary {
  date: string;               // YYYY-MM-DD
  totalWorkflows: number;
  completedWorkflows: number;
  failedWorkflows: number;
  totalDuration: number;      // milliseconds
  averageDuration: number;    // milliseconds
  workflowBreakdown: Record<string, number>; // workflowName → count
  mostUsedWorkflow: string;
  successRate: number;        // 0.0 - 1.0
}

function generateDailySummary(date: string): DailySummary {
  const startOfDay = new Date(date).setHours(0, 0, 0, 0);
  const endOfDay = new Date(date).setHours(23, 59, 59, 999);

  const entries = queryHistory({
    since: startOfDay
  }).filter(e => e.timestamp <= endOfDay);

  const completed = entries.filter(e => e.status === "COMPLETED");
  const failed = entries.filter(e => e.status === "ERROR");

  const workflowBreakdown: Record<string, number> = {};
  entries.forEach(e => {
    workflowBreakdown[e.workflowName] = (workflowBreakdown[e.workflowName] || 0) + 1;
  });

  const mostUsed = Object.entries(workflowBreakdown)
    .sort((a, b) => b[1] - a[1])[0]?.[0] || "none";

  const totalDuration = entries
    .filter(e => e.duration)
    .reduce((sum, e) => sum + e.duration!, 0);

  return {
    date,
    totalWorkflows: entries.length,
    completedWorkflows: completed.length,
    failedWorkflows: failed.length,
    totalDuration,
    averageDuration: entries.length > 0 ? totalDuration / entries.length : 0,
    workflowBreakdown,
    mostUsedWorkflow: mostUsed,
    successRate: entries.length > 0 ? completed.length / entries.length : 0
  };
}

function saveDailySummary(summary: DailySummary): void {
  const summaryPath = expandPath("~/.claude/skills/nexus/history/daily-summary.json");
  let summaries: DailySummary[] = [];

  if (fileExists(summaryPath)) {
    summaries = JSON.parse(readFile(summaryPath));
  }

  // Replace or add summary for this date
  const index = summaries.findIndex(s => s.date === summary.date);
  if (index >= 0) {
    summaries[index] = summary;
  } else {
    summaries.push(summary);
  }

  // Keep only last 90 days
  summaries = summaries
    .sort((a, b) => b.date.localeCompare(a.date))
    .slice(0, 90);

  writeFile(summaryPath, JSON.stringify(summaries, null, 2));
}
```

---

## Cleanup & Maintenance

### Cleanup Old History

```typescript
function cleanupOldHistory(retentionDays: number = 30): void {
  const cutoffTime = Date.now() - (retentionDays * 24 * 60 * 60 * 1000);

  // Clean up old backups
  const backupDir = getBackupDir();
  const backups = listFiles(backupDir);
  backups.forEach(file => {
    const stats = fileStats(file);
    if (stats.mtime < cutoffTime) {
      deleteFile(file);
    }
  });

  // Trim execution log
  const historyPath = getHistoryPath();
  if (fileExists(historyPath)) {
    const lines = readFile(historyPath).split("\n").filter(Boolean);
    const filtered = lines.filter(line => {
      const entry = JSON.parse(line) as HistoryEntry;
      return entry.timestamp >= cutoffTime;
    });

    writeFile(historyPath, filtered.join("\n") + "\n");
  }

  console.log(`✅ Cleaned up history older than ${retentionDays} days`);
}
```

---

## Error Recovery

### Corrupt State Recovery

```typescript
function recoverFromCorruptState(): WorkflowState | null {
  console.warn("⚠️  Current workflow state corrupted. Attempting recovery...");

  // Step 1: Try to load from most recent backup
  const backupDir = getBackupDir();
  const backups = listFiles(backupDir).sort((a, b) => {
    return fileStats(b).mtime - fileStats(a).mtime;
  });

  for (const backup of backups) {
    try {
      const state = JSON.parse(readFile(backup));
      const validation = validateState(state);

      if (validation.valid) {
        console.log(`✅ Recovered state from backup: ${backup}`);
        persistState(state); // Restore to current
        return state;
      }
    } catch (error) {
      continue; // Try next backup
    }
  }

  // Step 2: No valid backup found
  console.error("❌ Could not recover workflow state");
  clearCurrentState();
  return null;
}
```

---

## Configuration

### State Manager Configuration (defaults.yml)

```yaml
state_manager:
  # Persistence
  state_file_path: "~/.claude/skills/nexus/history/.current-workflow.json"
  history_file_path: "~/.claude/skills/nexus/history/executions.jsonl"
  backup_dir: "~/.claude/skills/nexus/history/backups"

  # Checkpoints
  create_checkpoints: true
  checkpoint_interval: 2  # Create checkpoint every N phases
  max_checkpoints: 10     # Maximum checkpoints per workflow

  # History
  log_execution_history: true
  retention_days: 30       # Keep history for 30 days
  daily_summary_enabled: true

  # Validation
  validate_on_load: true
  auto_recover_corrupt_state: true

  # Cleanup
  auto_cleanup_enabled: true
  cleanup_interval_days: 7  # Run cleanup weekly
```

---

## Performance Considerations

### Optimization Strategies

1. **Incremental Writes**: Append to JSONL instead of rewriting entire file
2. **Lazy Loading**: Only load history when needed (don't load on startup)
3. **Compression**: Compress old backups (gzip) to save disk space
4. **Async Persistence**: Persist state asynchronously to avoid blocking
5. **In-Memory Cache**: Cache current state in memory, only write on changes

---

## Integration Points

### With Other Core Components

1. **orchestrator.md** → Calls `persistState()` after each phase
2. **workflow-engine.md** → No direct interaction
3. **state-manager.md** (this) → Provides state persistence
4. **Commands** (`/nexus resume`, `/nexus rollback`) → Use resume/rollback functions

---

## Testing

### Unit Tests

```typescript
describe("StateManager", () => {
  it("should persist state correctly", () => {...});
  it("should load state correctly", () => {...});
  it("should append to history log", () => {...});
  it("should create checkpoints", () => {...});
  it("should rollback to checkpoint", () => {...});
  it("should resume workflow", () => {...});
  it("should validate state integrity", () => {...});
  it("should recover from corrupt state", () => {...});
  it("should cleanup old history", () => {...});
});
```

---

## Related Documentation

- `orchestrator.md` - Workflow execution and state updates
- `../commands/nexus.md` - Resume/rollback commands
- `../TROUBLESHOOTING.md` - State corruption issues

---

**Last Updated**: 2025-10-29
**Version**: 2.0.0
**Maintainer**: Nexus Team
