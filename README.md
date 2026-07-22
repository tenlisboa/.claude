# Claude Code Boillerplate

## How to use

### Linux / macOS

With curl:

```sh
curl -fsSL https://raw.githubusercontent.com/tenlisboa/.claude/main/install.sh | bash
```

With wget:

```sh
wget -qO- https://raw.githubusercontent.com/tenlisboa/.claude/main/install.sh | bash
```

Download and execute:

```sh
curl -fsSL https://raw.githubusercontent.com/tenlisboa/.claude/main/install.sh -o /tmp/install.sh

bash /tmp/install.sh
```

### Windows

Using PowerShell (5.1+ or PowerShell 7.x):

```powershell
irm https://raw.githubusercontent.com/tenlisboa/.claude/main/install.ps1 | iex
```

Or download and execute:

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/tenlisboa/.claude/main/install.ps1 -OutFile $env:TEMP\install.ps1
& $env:TEMP\install.ps1
Remove-Item $env:TEMP\install.ps1
```

Using CMD:

```cmd
curl -fsSL https://raw.githubusercontent.com/tenlisboa/.claude/main/install.ps1 -o %TEMP%\install.ps1 && powershell -ExecutionPolicy Bypass -File %TEMP%\install.ps1 && del %TEMP%\install.ps1
```
