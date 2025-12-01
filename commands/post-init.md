---
description: Optimize a CLAUDE.md file using HumanLayer best practices (WHY/WHAT/HOW framework, progressive disclosure)
argument-hint: "<path/to/CLAUDE.md>"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, Task
---

# Optimize CLAUDE.md

Analyze and optimize the CLAUDE.md file at the provided path using best practices from HumanLayer's guide.

## Target File

```
$1
```

## Step 1: Fetch Best Practices

Use WebFetch to retrieve the HumanLayer blog post:
- URL: https://www.humanlayer.dev/blog/writing-a-good-claude-md
- Extract all recommendations, anti-patterns, and the WHY/WHAT/HOW framework

## Step 2: Analyze Current CLAUDE.md

Read the CLAUDE.md file at `$1` and evaluate against these criteria:

| Criteria | Target |
|----------|--------|
| Total lines | Under 60 (max 300) |
| Structure | WHY/WHAT/HOW framework |
| Code examples | Pointers, not inline |
| Instructions | Universal only, ~15-20 max |
| Style guidelines | Remove (anti-pattern) |

## Step 3: Explore Project Structure

The parent directory of `$1` is the project root. Use Glob and Bash to:
- List root-level directories
- Identify main source folders
- Find existing documentation
- Understand the tech stack from package.json, requirements.txt, etc.

## Step 4: Create Progressive Disclosure Structure

Create `agent_docs/` in the project root with separate files for detailed documentation:

```
agent_docs/
├── database.md      # Schema, queries, migrations (if applicable)
├── architecture.md  # Detailed architecture docs
├── api.md           # Endpoints, auth, config
└── development.md   # Dev workflow, patterns, examples
```

Extract verbose content from the original CLAUDE.md into these files.

## Step 5: Rewrite CLAUDE.md

Create a new CLAUDE.md following this structure:

```markdown
# CLAUDE.md

## WHY - Project Purpose
[1-2 sentences explaining what the project does and why]

## WHAT - Architecture
[Brief directory structure with inline comments]
[Tech stack in one line]

## HOW - Key Commands
[Only essential commands: start, build, test, deploy]

## Coding Guidelines
[Only 3-5 universal rules from the original]

## Documentation Pointers
[Table pointing to agent_docs/ files]

## Critical Notes
[5-7 must-know constraints/gotchas]
```

## Step 6: Verify

Count lines in the new CLAUDE.md:
```bash
wc -l <path-to-new-claude-md>
```

Target: Under 60 lines.

## Output Summary

After completion, provide:

1. **Before/After comparison** - Line count, structure changes
2. **Files created** - List of agent_docs/ files
3. **Key improvements** - What was fixed based on blog recommendations
4. **Verification** - Confirm line count target met
