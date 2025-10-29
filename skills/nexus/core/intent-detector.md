# Intent Detector - Nexus Core Component

## Purpose
Analyze user requests to detect task intent, complexity, and context.

## Detection Logic

### Intent Categories
- **feature-development**: "implement", "create", "build", "add"
- **bugfix**: "fix", "debug", "resolve", "repair"
- **refactor**: "refactor", "improve", "optimize", "clean"
- **review**: "review", "check", "validate", "inspect"
- **planning**: "plan", "design", "brainstorm", "architect"

### Complexity Assessment
- **Small**: 1-2 files, <100 lines, simple change
- **Medium**: 3-5 files, new component/endpoint, moderate logic
- **Large**: Full feature, multiple components, complex integration

### Context Analysis
- Has existing plan? (conversation history)
- Sprint active? (check ald-sprint)
- Following up on previous task?

## Output Format
```json
{
  "intent": "feature-development",
  "complexity": "large",
  "context": {
    "has_plan": false,
    "sprint_active": true,
    "sprint_related": true
  },
  "confidence": 0.95
}
```
