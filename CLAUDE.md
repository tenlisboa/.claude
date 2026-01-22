# CLAUDE.md

## WHY - Purpose

Configuration repository for Claude Code: agent definitions, settings, and utilities that control how Claude Code operates across all projects.

## WHAT - Architecture

```
~/.claude/
├── agents/           # Multi-agent system: feature-refiner → coder → reviewer
├── commands/         # Custom slash commands
├── skills/           # atomic-commits, product-management
├── utils/            # Shell helpers (cl command)
├── settings.json     # Global settings
└── settings.local.json  # Web permissions
```

**Stack**: Markdown agents with YAML frontmatter, bash utilities

## HOW - Key Commands

```bash
source ~/.claude/utils/shell-alias-setup.sh  # Enable cl helper
cl "your question"                            # Quick terminal help
```

## Coding Guidelines

1. Never add code comments
2. Minimize logging and console output
3. Functional React only (no classes)
4. Simplicity first - YAGNI

## Documentation Pointers

| Topic | File |
|-------|------|
| Agent workflow & invocation | `agent_docs/agents.md` |
| Coding standards & QA criteria | `agent_docs/coding-standards.md` |
| Full directory structure | `agent_docs/directory-structure.md` |
| Shell integration details | `agent_docs/shell-integration.md` |

## Critical Notes

- Skills: product-management (auto-loaded), atomic-commits
- Agent chain: feature-refiner → coder → reviewer
- coder ALWAYS delegates to reviewer after implementation
- Specs go in `specs/[feature-name].md`
- Use Task tool with `subagent_type` to invoke agents
- `alwaysThinkingEnabled: true` in settings.json
