# Agent System Documentation

Multi-agent architecture for phased software development workflows.

## Workflow Chain
```
User Request → product-manager → feature-refiner → coder → qa-code-reviewer
```

## Agent Descriptions

### product-manager (agents/product-manager.md)
- **Purpose**: Requirement clarification, MVP scoping, BDD specifications
- **Triggers**: Complex features, major enhancements, explicit PM requests
- **Model**: sonnet
- **Outputs**: Specs in `specs/[feature-name].md` with Given-When-Then scenarios

### feature-refiner (agents/feature-refiner.md)
- **Purpose**: Technical analysis, library evaluation, risk assessment
- **Triggers**: Technical architecture decisions, dependency evaluation
- **Model**: sonnet
- **Outputs**: Library recommendations, risk matrices, implementation approach

### coder (agents/coder.md)
- **Purpose**: Implementation following specifications
- **Triggers**: Specs ready for implementation
- **Model**: sonnet
- **Key Principle**: Simplicity first - minimal implementation, YAGNI
- **Auto-delegates**: Always invokes qa-code-reviewer after implementation

### qa-code-reviewer (agents/qa-code-reviewer.md)
- **Purpose**: Code quality assurance
- **Triggers**: After coder completes implementation
- **Model**: sonnet
- **Verdict**: APPROVED / REVISE / DISCUSS

## Common Agent Directives

All agents share these operational patterns:

**Context Persistence**: Agents save progress and complete tasks fully regardless of context limits.

**Investigate First**: Never speculate - read files before making claims.

**Parallel Tool Calls**: Execute independent operations simultaneously.

**Reflection**: Pause after tool results to evaluate and plan.

## Invoking Agents

Use the Task tool with appropriate `subagent_type`:
- `subagent_type: "product-manager"` for specifications
- `subagent_type: "feature-refiner"` for technical refinement
- `subagent_type: "coder"` for implementation
- `subagent_type: "qa-code-reviewer"` for code review
