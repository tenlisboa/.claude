# Shell Integration

## The `cl` Command

Defined in `utils/shell-alias-setup.sh`, the `cl` function provides quick terminal assistance.

### Installation

Add to your shell profile (`.bashrc`, `.zshrc`):
```bash
source ~/.claude/utils/shell-alias-setup.sh
```

### Usage
```bash
cl "your question or command"
```

### Example
```bash
cl "How to disconnect from openvpn3 network"
```

### Features

- Automatically adds strategic directories to context:
  - `~/.config` (user configuration)
  - `/etc` (system configuration)
  - `/usr/local/bin` (custom scripts)
  - Current working directory

- Limited tool access for security:
  - Bash
  - Read
  - WebSearch

- System context injection:
  - OS information (via `lsb_release`)
  - Terminal perspective awareness

### Behavior

The helper:
1. Validates Claude Code installation
2. Requires a query argument
3. Builds context from strategic directories
4. Appends OS information
5. Executes with constrained tool access
