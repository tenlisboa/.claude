# Directory Structure

## Core Directories

```
~/.claude/
├── agents/              # Agent definitions (YAML frontmatter + markdown)
├── commands/            # Custom slash commands
├── skills/              # Skill definitions (atomic-commits)
├── utils/               # Utility scripts
├── projects/            # Per-project conversation history
├── todos/               # Todo state per conversation
├── file-history/        # Version history of edited files
├── debug/               # Debug logs
├── session-env/         # Session environment state
├── shell-snapshots/     # Shell state snapshots
├── plans/               # Planning documents
├── downloads/           # Downloaded files
├── ide/                 # IDE integration
└── statsig/             # Feature flags
```

## Configuration Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Primary instructions for Claude Code |
| `settings.json` | Global settings (alwaysThinkingEnabled) |
| `settings.local.json` | Web access permissions per domain |
| `.gitignore` | Version control exclusions |

## Agent Files

| Agent | File | Purpose |
|-------|------|---------|
| product-manager | `agents/product-manager.md` | Specifications |
| feature-refiner | `agents/feature-refiner.md` | Technical analysis |
| coder | `agents/coder.md` | Implementation |
| qa-code-reviewer | `agents/qa-code-reviewer.md` | Quality review |

## Skills

| Skill | Location | Purpose |
|-------|----------|---------|
| atomic-commits | `skills/atomic-commits/` | Semantic commit creation |

## Output Locations

- Specifications: `specs/[feature-name].md`
- Progress tracking: `progress.md`
