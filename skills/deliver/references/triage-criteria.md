# Triage Criteria

## Tier Classification

Classify the task into exactly one tier based on the signals below. When in doubt, pick the higher tier.

### trivial

Signal: 1-2 files, mechanical change — typo, rename, config value, dependency version bump, import fix.

Phases: Execute → Verify → Commit

### small

Signal: Bugfix with clear root cause, localized change affecting <5 files, well-scoped refactor within one module.

Phases: Research → Plan → Execute → Verify → Commit

### medium

Signal: New feature, multi-file refactor, new integration, new API endpoint, adding a new module or component.

Phases: Research → Plan → Execute → Review → Verify → Ship (PR)

### large

Signal: Architectural change, cross-cutting concern (auth, logging, error handling), ambiguous requirements, 10+ files, new subsystem.

Phases: Research → Spec → Plan → Execute → Review → Verify → Ship (PR)

## Escalation

If during any phase the actual complexity exceeds the current tier, escalate to the next tier and re-enter the flow from the phase that triggered escalation.

## Toolchain Detection

Run these checks once during triage. Store results and pass to all agents.

### Test Runner

| File | Command |
|---|---|
| `Makefile` with `test` target | `make test` |
| `package.json` with `scripts.test` | `npm test` |
| `pyproject.toml` or `pytest.ini` | `pytest` |
| `Cargo.toml` | `cargo test` |
| `go.mod` | `go test ./...` |

### Linter

| File | Command |
|---|---|
| `Makefile` with `lint` target | `make lint` |
| `package.json` with `scripts.lint` | `npm run lint` |
| `ruff.toml` or `[tool.ruff]` in pyproject.toml | `ruff check .` |
| `Cargo.toml` | `cargo clippy` |
| `.golangci.yml` | `golangci-lint run` |

### Formatter

| File | Command |
|---|---|
| `.prettierrc` or `prettier` in package.json | `npx prettier --check .` |
| `ruff.toml` or `[tool.ruff]` in pyproject.toml | `ruff format --check .` |
| `Cargo.toml` | `cargo fmt --check` |
| `go.mod` | `gofmt -l .` |

### Other

| Check | How |
|---|---|
| Pre-commit hooks | `.pre-commit-config.yaml` exists OR `.git/hooks/pre-commit` exists |
| GitHub CLI | `which gh` returns 0 |
