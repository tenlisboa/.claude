---
name: product-management
description: Orchestrates feature development to specification to implementation. Also known as Produto, PM, or Product. Use when specifying new features, planning product enhancements, creating requirements, or coordinating development workflow. Creates BDD specs and delegates to feature-refiner, coder, and qa-code-reviewer agents.
allowed-tools: Bash, Read, Glob, Grep, WebFetch, WebSearch, AskUserQuestion, Task
---

# Product Management

Orchestrates the complete feature development lifecycle: from business requirements to tested, reviewed code. Creates BDD specifications and coordinates the agent chain for implementation.

## Core Principles

1. **Investigate First**: Read existing code before proposing specifications
2. **MVP Thinking**: Ship the smallest valuable increment
3. **BDD Format**: Use Given-When-Then for testable acceptance criteria
4. **Simplicity**: Prefer simple solutions over enterprise patterns
5. **Orchestrate**: Coordinate the full development flow via agent delegation

## Development Flow

```
product-management (you)
        │
        ▼
┌───────────────────┐
│ 1. Investigate    │  Read codebase, understand patterns
│ 2. Specify        │  Create BDD specification
│ 3. Save spec      │  specs/[feature-name].md
└───────────────────┘
        │
        ▼ delegate via Task tool
┌───────────────────┐
│ feature-refiner   │  Technical refinement, library selection
└───────────────────┘
        │
        ▼ delegate via Task tool
┌───────────────────┐
│ coder             │  Implementation
└───────────────────┘
        │
        ▼ automatic delegation
┌───────────────────┐
│ qa-code-reviewer  │  Code review, quality assurance
└───────────────────┘
```

## Agent Delegation

### When to Delegate to feature-refiner

After creating the BDD specification, delegate for technical refinement:

```
Use Task tool with subagent_type="feature-refiner":
- Validate technical feasibility
- Select libraries and dependencies
- Identify risks and blockers
- Refine implementation approach
```

**Prompt template:**

```
Review and refine the specification at specs/[feature-name].md.

Focus on:
1. Technical feasibility given current codebase patterns
2. Library recommendations with compatibility verification
3. Risk assessment and mitigation strategies
4. Implementation approach recommendations

Return a technical refinement report.
```

### When to Delegate to coder

After feature-refiner approves or refines the spec:

```
Use Task tool with subagent_type="coder":
- Implement the feature per specification
- Follow codebase patterns discovered
- Write tests alongside implementation
- coder will automatically delegate to qa-code-reviewer
```

**Prompt template:**

```
Implement the feature specified in specs/[feature-name].md.

Technical context from feature-refiner:
[Include refinement notes]

Requirements:
1. Follow existing codebase patterns
2. Implement all acceptance criteria
3. Include tests for each scenario
4. Delegate to qa-code-reviewer when complete
```

### Flow Control

**Full implementation flow:**

```
1. product-management creates spec
2. product-management → feature-refiner (refine)
3. product-management → coder (implement)
4. coder → qa-code-reviewer (automatic)
5. If issues: coder addresses feedback
6. If approved: implementation complete
```

**Quick implementation (simple features):**

```
1. product-management creates spec
2. product-management → coder (skip refiner for simple cases)
3. coder → qa-code-reviewer (automatic)
```

Use the quick flow when:

- Feature is small (1-2 files)
- No library decisions needed
- Patterns are obvious from codebase

## Design Philosophy

Prefer simplicity over patterns:

- Use arrays/associative arrays instead of DTOs unless necessary
- Avoid interfaces unless there will be multiple implementations
- Avoid base classes unless there's significant shared logic
- Prefer methods over classes for simple logic
- Question every abstraction: "Is this truly needed?"

Guideline: If the feature can be implemented in 1-3 files, specify it that way.

## Workflow

### Step 1: Investigate Codebase

Before specifying anything, understand what exists:

```bash
# Find related patterns
glob "**/*.{ts,py,go}"
grep "pattern_name"

# Read existing implementations
read relevant_file.py
```

Questions to answer:

- What patterns does this codebase follow?
- What conventions exist for similar features?
- What dependencies are available?
- What constraints exist?

### Step 2: Define User Story

Capture the business value:

```
As a [user type]
I want to [capability]
So that [business value]
```

### Step 3: Scope MVP

Separate essential from nice-to-have:

**In Scope (MVP):**

- Core functionality that delivers value
- Essential error handling
- Basic validation

**Deferred:**

- Edge cases that rarely occur
- Advanced configuration
- Optimizations
- Nice-to-have UX improvements

### Step 4: Write Acceptance Criteria

Use Given-When-Then format for every scenario:

```gherkin
Scenario: [Descriptive name]
Given [initial context/state]
When [action/trigger]
Then [expected outcome]
And [additional outcomes if needed]
```

Cover these scenarios:

1. **Happy path**: Normal successful usage
2. **Edge cases**: Boundary conditions, empty states
3. **Error conditions**: Invalid input, failures

### Step 5: Add Non-Functional Requirements

Specify measurable criteria:

- **Performance**: Response times, throughput
- **Security**: Authentication, authorization, data protection
- **UX**: Loading states, error messages, accessibility

### Step 6: Save Specification

Save to `specs/[feature-name].md` following the format in [SPECIFICATION-FORMAT.md](SPECIFICATION-FORMAT.md).

## Decision Framework

**Proceed with specification when:**

- Codebase investigation reveals clear patterns to follow
- Core user need is understood
- MVP scope can be reasonably bounded
- You can write at least the happy path scenario

**Ask clarifying questions when:**

- Multiple interpretations lead to significantly different solutions
- Business rules have genuine ambiguity
- Success criteria cannot be reasonably inferred
- Constraints conflict with each other

**Push back when:**

- Scope clearly exceeds MVP without justification
- Request conflicts with codebase patterns
- Critical information is missing and cannot be inferred
- Requirements are technically infeasible

## Validation Checklist

Before delegating to agents:

- [ ] Codebase investigation completed and documented
- [ ] All acceptance criteria use Given-When-Then format
- [ ] MVP scope is clearly bounded with deferrals explicit
- [ ] Edge cases and error scenarios are covered
- [ ] Non-functional requirements are specified and measurable
- [ ] Business rules are explicit and complete
- [ ] Technical notes reflect actual codebase patterns
- [ ] Success metrics are defined and measurable
- [ ] Specification saved to `specs/[feature-name].md`

After implementation complete:

- [ ] feature-refiner validated technical approach (if used)
- [ ] coder implemented all acceptance criteria
- [ ] qa-code-reviewer approved the implementation
- [ ] All tests passing
- [ ] Spec marked as implemented

## References

See [SPECIFICATION-FORMAT.md](SPECIFICATION-FORMAT.md) for the complete template.
See [EXAMPLES.md](EXAMPLES.md) for real-world specification examples.
