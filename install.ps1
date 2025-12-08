#Requires -Version 5.1

$ErrorActionPreference = "Stop"

Write-Host "Installing .claude configurations..." -ForegroundColor Cyan

$Repo = "https://github.com/tenlisboa/.claude.git"
$TempDir = Join-Path $env:TEMP ".claude-temp"
$DestDir = Join-Path $env:USERPROFILE ".claude"

if (Test-Path $TempDir) {
    Remove-Item -Recurse -Force $TempDir
}

git clone $Repo $TempDir

if (-not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir | Out-Null
}

Copy-Item -Path "$TempDir\*" -Destination $DestDir -Recurse -Force

Remove-Item -Recurse -Force $TempDir

Write-Host "Successfully installed .claude configurations to $DestDir" -ForegroundColor Green
