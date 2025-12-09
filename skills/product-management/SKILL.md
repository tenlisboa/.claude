---
name: product-management
description: Orchestrates ALL implementation requests. Use when user asks to implement, add, create, build, refactor, adjust, fix, update, or change any feature or code. Also triggers on "produto", "PM", "spec", "feature", "requirement", "BDD". Handles both simple tasks (direct to coder) and complex workflows (feature-refiner → coder → qa).
allowed-tools: Read, Write, Edit, Glob, Grep, Task, AskUserQuestion
---

# Product Management & Workflow Orchestration

You orchestrate ALL development requests - from simple fixes to complex features.

## FIRST: Quick Complexity Check (5 seconds)

Before anything, answer these 3 questions mentally:

1. **Is it a typo/text change/single-line fix?** → TRIVIAL, skip to Trivial Path
2. **Is it a single file with clear scope?** → SIMPLE, skip to Simple Path
3. **Does it need planning/multiple files?** → Continue to Full Assessment

### Trivial Path (Score < 6)

For truly trivial changes, **delegate immediately without spec**:

```
Task: [Exact user request]
subagent_type: coder
```

Examples: typo fix, CSS tweak, rename variable, update string literal, add simple validation

### Simple Path (Score 6-8)

For simple but non-trivial changes:

1. Brief mental assessment (no written spec needed)
2. Delegate to coder with clear instructions:

```
Task: [Clear description with context]
subagent_type: coder
```

Examples: add button, new simple endpoint, basic component, configuration change

### Full Path (Score 9+)

Continue to Complexity Assessment Matrix below.

---

## Complexity Assessment Matrix (Only for Score 9+)

| Factor           | Simple (1pt) | Medium (2pt)         | Complex (3pt)        |
| ---------------- | ------------ | -------------------- | -------------------- |
| Files affected   | 1-2          | 3-5                  | 6+                   |
| New dependencies | None         | 1-2 known            | New/unfamiliar       |
| Database changes | None         | Add columns          | New tables/relations |
| External APIs    | None         | Existing integration | New integration      |
| Business logic   | CRUD         | Some rules           | Complex rules        |
| Risk level       | Low          | Medium               | High                 |

**Score interpretation:**

- **6-8 points**: Simple → Coder only
- **9-12 points**: Medium → Coder → QA
- **13-18 points**: Complex → Feature-Refiner → Coder → QA

## Workflow Patterns

### Pattern 1: Simple (Score 6-8)

```
Direct to Coder (no QA needed for trivial changes)

Examples:
- Fix typo
- Update copy/text
- Add simple validation
- CSS adjustments
```

**Delegation:**

```
Task: Implement [description]
subagent_type: coder
```

### Pattern 2: Medium (Score 9-12)

```
Coder → QA

Examples:
- New CRUD endpoint
- Add form field with validation
- Simple new component
- Bug fix with tests
```

**Delegation sequence:**

```
1. Create spec in specs/[feature].md
2. Task: Implement spec at specs/[feature].md
   subagent_type: coder
3. Coder auto-delegates to qa-code-reviewer
```

### Pattern 3: Complex (Score 13-18)

```
Feature-Refiner → Update Spec → Coder → QA

Examples:
- New authentication system
- Payment integration
- Complex business workflow
- Architecture changes
```

**Delegation sequence:**

```
1. Create initial spec in specs/[feature].md
2. Task: Analyze technical feasibility and refine spec at specs/[feature].md
   subagent_type: feature-refiner
3. Update spec with refinements
4. Task: Implement refined spec at specs/[feature].md
   subagent_type: coder
5. Coder auto-delegates to qa-code-reviewer
```

### Pattern 4: Parallel Independent Tasks

```
When feature has independent parts that don't share state:

┌─────────────┐     ┌─────────────┐
│   Coder A   │     │   Coder B   │
│  (API work) │     │  (UI work)  │
└──────┬──────┘     └──────┬──────┘
       │                   │
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│    QA A     │     │    QA B     │
└─────────────┘     └─────────────┘
```

**Identification criteria for parallel work:**

- Different file domains (backend vs frontend)
- No shared state or dependencies
- Can be tested independently
- No database migration conflicts

**Delegation:**

```
# Spawn parallel coders
Task: Implement API endpoints per specs/[feature]-api.md
subagent_type: coder

Task: Implement UI components per specs/[feature]-ui.md
subagent_type: coder
```

## Specification Format (BDD)

Always create specs before delegation:

```markdown
# Feature: [Name]

## Context

[What exists, what patterns to follow]

## Complexity Assessment

- Files affected: X
- New dependencies: X
- Database changes: X
- External APIs: X
- Business logic: X
- Risk level: X
- **Total Score: X → [Simple/Medium/Complex]**
- **Workflow: [Pattern to use]**

## User Story

As a [user type]
I want to [capability]  
So that [business value]

## MVP Scope

**In Scope:**

- ...

**Deferred:**

- ... → Future

## Acceptance Criteria

### Scenario: [Happy path]

Given [context]
When [action]
Then [outcome]

### Scenario: [Edge case]

...

## Technical Notes

[From feature-refiner if complex]

## Implementation Plan

- [ ] Part 1: [description] → Coder A
- [ ] Part 2: [description] → Coder B (parallel if independent)
```

## Decision Tree

```
START: Any implementation request
  │
  ▼
QUICK CHECK (5 seconds):
  │
  ├── Typo/text/single-line? ─────→ TRIVIAL: Delegate to coder immediately
  │
  ├── Single file, clear scope? ──→ SIMPLE: Delegate to coder with context
  │
  └── Needs planning? ────────────→ Continue below
         │
         ▼
    Create spec with complexity assessment
         │
         ▼
    Score >= 13? ─────YES────→ feature-refiner → coder → qa
         │
         NO
         │
         ▼
    Has independent parts?
         │
         ├──YES──→ Split specs, spawn parallel coders
         │
         NO
         │
         ▼
    Delegate to coder (auto-QA for score 9+)
```

## Agent Capabilities Reference

### feature-refiner

- Technical feasibility analysis
- Library evaluation
- Risk assessment
- Architecture recommendations
- **Output**: Technical refinements for spec

### coder

- Implementation from specs
- Follows codebase patterns
- Auto-delegates to QA when done
- **Output**: Working code

### qa-code-reviewer

- Code quality review
- Security check
- Standards compliance
- **Output**: APPROVED / REVISE / DISCUSS

## Orchestration Commands

When delegating, use Task tool with:

```
Task: [Clear description of what to do]
subagent_type: [agent-name]
```

For resumable long tasks:

```
Task: [Description]
subagent_type: [agent-name]
# Note: Save agentId for potential resume
```

## Examples

### Example 1: "Fix typo in login button" → TRIVIAL

```
Quick check: Single text change? YES → TRIVIAL
Action: Delegate immediately

Task: Fix typo in login button
subagent_type: coder
```

### Example 2: "Add loading spinner to submit button" → SIMPLE

```
Quick check: Single file, clear scope? YES → SIMPLE
Action: Delegate with context

Task: Add loading spinner to submit button. Show spinner while form submits, disable button during loading.
subagent_type: coder
```

### Example 3: "Add dark mode toggle" → SIMPLE

```
Quick check: Needs planning? Borderline, but scope is clear
Assessment: 2 files, no deps, no DB, simple logic
Score: 6 → Simple
Action: Delegate to coder with context (no spec needed)

Task: Add dark mode toggle. Create toggle in settings, persist preference in localStorage, apply dark theme class to body.
subagent_type: coder
```

### Example 4: "Add user profile page with avatar upload" → MEDIUM

```
Quick check: Needs planning? YES (multiple files, new feature)
Assessment: 4 files, 1 dep (image lib), add column, some logic
Score: 11 → Medium
Workflow: Coder → QA

Action: Create spec, delegate to coder
```

### Example 5: "Integrate Stripe payments" → COMPLEX

```
Quick check: Needs planning? YES (new integration, high risk)
Assessment: 8+ files, new dep, new tables, new API, complex logic, high risk
Score: 17 → Complex
Workflow: Feature-Refiner → Coder → QA

Action: Create spec, delegate to feature-refiner, update spec, delegate to coder
```

### Example 6: "Build admin dashboard with API and UI" → PARALLEL

```
Assessment: Complex BUT has independent parts
- API: backend only, no UI deps
- UI: frontend only, mocks API initially

Action:
1. Create specs/admin-api.md and specs/admin-ui.md
2. Spawn parallel coders
3. Each auto-delegates to QA
```
