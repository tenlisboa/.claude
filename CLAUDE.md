# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the `.claude` directory - the configuration and state repository for Claude Code itself. It contains agent definitions, user settings, session history, and utility scripts that control how Claude Code operates.

## Architecture

### Agent System
The repository defines a multi-agent architecture with specialized agents for different phases of software development:

- **product-manager** (`agents/product-manager.md`): Handles requirement clarification, MVP scoping, and BDD-style specification writing. Delegates to feature-refiner when specifications are complete.

- **feature-refiner** (`agents/feature-refiner.md`): Performs technical analysis, identifies idiomatic libraries, verifies dependency compatibility, and conducts risk/blocker analysis. Produces implementable technical specifications.

- **coder** (`agents/coder.md`): Implements code based on specifications. Expert in React functional components, clean architecture, domain-driven design. ALWAYS delegates to qa-code-reviewer after implementation.

- **qa-code-reviewer** (`agents/qa-code-reviewer.md`): Performs rigorous code quality reviews covering flexibility, duplication, SRP, error handling, domain language, and 20+ other quality dimensions.

### Agent Workflow
The standard workflow follows this delegation chain:
```
User Request → product-manager → feature-refiner → coder → qa-code-reviewer
```

### Directory Structure

- `agents/` - Agent definitions (markdown files with YAML frontmatter)
- `commands/` - Custom slash commands (currently empty)
- `utils/` - Utility scripts including `shell-alias-setup.sh` for the `cl` helper function
- `projects/` - Conversation history per project
- `todos/` - Todo list state per conversation
- `file-history/` - Version history of edited files
- `debug/` - Debug logs
- `session-env/` - Session environment state
- `shell-snapshots/` - Shell state snapshots
- `settings.json` - Global settings (`alwaysThinkingEnabled: false`)
- `settings.local.json` - Permission settings for web access

## Key Conventions

### Coding Standards (from user preferences)
- Never add code comments
- Minimize logging and console output

### Agent-Specific Standards

**coder agent follows:**
- Functional React components only (no classes)
- Clean JSX with fragments, destructuring
- Custom hooks for duplicated logic
- Service delegation for business logic
- State locality and immutability
- Domain-driven naming
- Security: external config, input sanitization, validation

**qa-code-reviewer evaluates:**
- Change flexibility and extensibility
- Code duplication
- Single Responsibility Principle
- Contract integrity and fail-fast behavior
- Domain language clarity
- Scope management
- Over-engineering detection
- State management patterns
- Coupling and dependencies

## Shell Integration

The `cl` command (defined in `utils/shell-alias-setup.sh`) provides a terminal helper that:
- Adds strategic directories to context (`~/.config`, `/etc`, `/usr/local/bin`, current directory)
- Uses limited tool access: Bash, Read, WebSearch only
- Appends system context with OS information
- Designed for quick terminal assistance

## Settings

**Global settings** (`settings.json`):
- `alwaysThinkingEnabled: false` - Thinking mode disabled by default

**Local settings** (`settings.local.json`):
- Web permissions configured for specific domains: n8n.io, github.com, blog.horizon.dev, marekbrze.com, community.n8n.io, freshbrewed.science
- WebSearch allowed globally

## Git Management

This repository uses Git for version control. Recent commits show ongoing configuration refinement. The main branch is `main`.

## Development Workflow

1. For complex features: Start with product-manager agent for requirements
2. For technical refinement: Use feature-refiner agent
3. For implementation: Use coder agent (automatically delegates to QA)
4. For code review: qa-code-reviewer agent runs automatically after coder

All agents have access to appropriate tools based on their role (defined in YAML frontmatter).
