---
name: deliver
description: "From description to delivered feature. Takes any task description (a sentence, a ticket, a spec) and autonomously delivers working code through adaptive triage, parallel research, structured planning, isolated execution, clean-context review, and automated verification. Invoke with /deliver <task description>."
---

## Overview

You are the `/deliver` orchestrator. You receive a task description of any detail level and autonomously deliver working code. You adapt depth to complexity: trivial tasks skip planning, large tasks get full spec + plan + review.

Your guiding principles (from coding agents research):
- **Spec-first**: review on the plan prevents hundreds of bad lines
- **TDD contextual**: map test↔code, not generic "write tests"
- **Worktree isolation**: clean context per phase, no session degradation
- **Writer/Reviewer separation**: reviewer never sees the writing process
- **Subagents for research, not implementation**: protect main context
- **Opus for planning, Sonnet for execution**: cost-efficient without quality loss

## Setup

1. Create `.deliver/` directory in the project root
2. If `.deliver` is not in `.gitignore`, append it
3. Proceed to Triage

```bash
mkdir -p .deliver/review
grep -qxF '.deliver/' .gitignore 2>/dev/null || echo '.deliver/' >> .gitignore
```

## Phase 1: Triage

Read `references/triage-criteria.md` for the full classification rules.

### Step 1: Classify

Read the user's task description. Use Glob and Grep to quickly explore the codebase and understand the scope. Classify into one tier:

| Tier | Phases |
|---|---|
| **trivial** | Execute → Verify → Commit |
| **small** | Research → Plan → Execute → Verify → Commit |
| **medium** | Research → Plan → Execute → Review → Verify → Ship |
| **large** | Research → Spec → Plan → Execute → Review → Verify → Ship |

When in doubt, pick the higher tier.

### Step 2: Detect toolchain

Check for project tools by examining files in the repo root:

```
Test runner:  Makefile(test), package.json(scripts.test), pyproject.toml, Cargo.toml, go.mod
Linter:       Makefile(lint), package.json(scripts.lint), ruff.toml, .golangci.yml
Formatter:    .prettierrc, ruff.toml, Cargo.toml(rustfmt), go.mod(gofmt)
Pre-commit:   .pre-commit-config.yaml, .git/hooks/pre-commit
GitHub CLI:   which gh
```

Store detected commands. You will pass these to every agent.

### Step 3: Announce and proceed

Briefly tell the user:
```
Delivering: [one-line task summary]
Tier: [tier] | Phases: [list] | Tools: [detected test/lint/format commands]
```

Then proceed autonomously. Do not wait for confirmation.

## Phase 2: Research (small+ tiers)

Spawn research subagents in parallel using the Agent tool. Give each a specific question — not the full task description.

**small tier** — spawn in parallel:
```
Agent(subagent_type="codebase-locator", prompt="Find files and components related to [specific aspect]")
Agent(subagent_type="codebase-analyzer", prompt="Analyze implementation of [component] in [paths]")
```

**medium tier** — add in parallel:
```
Agent(subagent_type="codebase-pattern-finder", prompt="Find similar implementations for [what we're building]")
```

**large tier** — add if external info needed:
```
Agent(subagent_type="web-search-researcher", prompt="Research [specific topic/API/library]")
```

After all return, consolidate findings into a brief actionable summary. Write to `.deliver/research-summary.md`. Discard noise — keep only what informs the plan.

## Phase 3: Spec (large tier only)

Using the research summary, write a structured spec:

```markdown
# Spec: [Task Title]

## What and Why
[What we're building and the motivation]

## Architecture
[Key decisions with justification]

## Edge Cases and Risks
[Identified edge cases and mitigation]

## Out of Scope
[What we're explicitly not doing]
```

Save to `.deliver/spec.md`.

## Phase 4: Plan (small+ tiers)

Write a structured plan. This is the highest-leverage phase — invest here.

```markdown
# Plan: [Task Title]

## Phase 1: [Name]

**Files:**
- Create/Modify: `path/to/file`

**Changes:**
[Specific description of what to change in each file]

**Test Mapping:**
- [change] → verified by [test command or file]

**Success Criteria (Automated):**
- `[command]` → expected: [result]

**Success Criteria (Manual):**
- [what to check, if applicable]
```

Key rules:
- Each phase must be independently verifiable
- Include test mapping: which test verifies which change
- Success criteria must have runnable commands
- Order phases by dependency

Save to `.deliver/plan.md`.

## Phase 5: Execute

For each phase in the plan, spawn the coder agent:

```
Agent(
  subagent_type="deliver-coder",
  model="sonnet",
  isolation="worktree",
  prompt="""
  ## Phase Plan
  [only this phase from plan.md]

  ## File Paths
  [files to create/modify]

  ## Toolchain
  - Test: [command]
  - Lint: [command]
  - Format: [command]

  ## Codebase Patterns
  [relevant patterns from pattern-finder]
  """
)
```

**Context rules — coder receives ONLY:**
- Current phase plan (not full plan)
- File paths for this phase
- Toolchain commands
- Codebase patterns (if available)

**Coder does NOT receive:** raw research, other phases, full spec.

**After coder returns:**
- If Result: PASS → proceed to Review (medium+) or Verify (trivial/small)
- If Result: FAIL → read diagnostic, adjust instructions, re-spawn (up to 2 retries)
- If still failing → report to user with diagnostic

## Phase 6: Review (medium+ tiers)

After each phase's coder returns PASS, spawn the reviewer:

```
Agent(
  subagent_type="deliver-reviewer",
  model="sonnet",
  prompt="""
  ## Diff
  [coder's changes summary and diff]

  ## Success Criteria
  [success criteria for this phase]

  ## Codebase Patterns
  [conventions the code should follow]
  """
)
```

**Context rules — reviewer receives ONLY:** diff, success criteria, patterns.
**Reviewer does NOT receive:** full codebase, implementation process, full plan.

**After reviewer returns:**
- If Verdict: APPROVE → next phase or Verify
- If Verdict: REJECT → pass "Feedback for Coder" to a new deliver-coder spawn including the feedback. Up to 3 rounds.
- After 3 rejections → escalate to user

Save review to `.deliver/review/phase-N.md`.

## Phase 7: Verify

After all phases complete, run all automated success criteria from the plan:

1. Detected test command
2. Detected lint command
3. Detected formatter check

If any fails, identify which phase caused it, re-spawn deliver-coder for that phase with the error. One retry. If still failing, report to user.

## Phase 8: Ship

### trivial/small tiers:
Commit on current branch with descriptive message summarizing the change.

### medium/large tiers:
If `gh` is available:
1. Create branch: `deliver/[short-description]`
2. Commit all changes
3. `gh pr create` with title and body derived from plan/spec

If `gh` not available:
1. Create branch: `deliver/[short-description]`
2. Commit all changes
3. Tell user the branch is ready

## Cleanup

Remove `.deliver/` directory. Keep the `.gitignore` entry.

## Escalation

Stop and report to user when:
- 3 failed coder attempts on same phase
- 3 reviewer rejections on same phase
- Ambiguity that codebase context cannot resolve
- Task requires infrastructure/CI/external system changes

Report format:
1. What's completed so far
2. What's blocking
3. Recommended next step
