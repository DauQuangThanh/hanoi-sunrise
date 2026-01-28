# init-agent.ps1 - Initialize agent command structure for various platforms
# Author: Dau Quang Thanh
# License: MIT

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Platform,
    
    [Parameter(Mandatory=$true, Position=1)]
    [string]$CommandName,
    
    [Parameter(Mandatory=$false, Position=2)]
    [string]$ProjectName = ""
)

# Platform configurations
$PlatformFolders = @{
    "claude" = ".claude/commands"
    "copilot-agent" = ".github/agents"
    "copilot-prompt" = ".github/prompts"
    "cursor" = ".cursor/commands"
    "windsurf" = ".windsurf/workflows"
    "gemini" = ".gemini/commands"
    "qwen" = ".qwen/commands"
    "antigravity" = ".agent/rules"
    "amazonq" = ".amazonq/prompts"
    "kilo" = ".kilocode/rules"
    "roo" = ".roo/rules"
    "bob" = ".bob/commands"
    "jules" = ".agent"
    "amp" = ".agents/commands"
    "auggie" = ".augment/rules"
    "qoder" = ".qoder/commands"
    "codebuddy" = ".codebuddy/commands"
    "codex" = ".codex/commands"
    "shai" = ".shai/commands"
    "opencode" = ".opencode/command"
}

$PlatformExtensions = @{
    "claude" = "md"
    "copilot-agent" = "agent.md"
    "copilot-prompt" = "prompt.md"
    "cursor" = "md"
    "windsurf" = "md"
    "gemini" = "toml"
    "qwen" = "toml"
    "antigravity" = "md"
    "amazonq" = "md"
    "kilo" = "md"
    "roo" = "md"
    "bob" = "md"
    "jules" = "md"
    "amp" = "md"
    "auggie" = "md"
    "qoder" = "md"
    "codebuddy" = "md"
    "codex" = "md"
    "shai" = "md"
    "opencode" = "md"
}

# Display usage
function Show-Usage {
    Write-Host @"
Usage: init-agent.ps1 <platform> <command-name> [project-name]

Initialize agent command structure for various AI platforms.

Platforms:
  claude              - Claude Code (.claude/commands/)
  copilot-agent       - GitHub Copilot Agent (.github/agents/)
  copilot-prompt      - GitHub Copilot Prompt (.github/prompts/)
  cursor              - Cursor (.cursor/commands/)
  windsurf            - Windsurf (.windsurf/workflows/)
  gemini              - Gemini CLI (.gemini/commands/)
  qwen                - Qwen Code (.qwen/commands/)
  antigravity         - Google Antigravity (.agent/rules/)
  amazonq             - Amazon Q CLI (.amazonq/prompts/)
  kilo                - Kilo Code (.kilocode/rules/)
  roo                 - Roo Code (.roo/rules/)
  bob                 - IBM Bob (.bob/commands/)
  jules               - Jules (.agent/)
  amp                 - Amp (.agents/commands/)
  auggie              - Auggie CLI (.augment/rules/)
  qoder               - Qoder CLI (.qoder/commands/)
  codebuddy           - CodeBuddy CLI (.codebuddy/commands/)
  codex               - Codex CLI (.codex/commands/)
  shai                - SHAI (.shai/commands/)
  opencode            - opencode (.opencode/command/)

Arguments:
  command-name        - Name of the command (e.g., analyze-security)
  project-name        - Project name for mode field (GitHub Copilot only)

Examples:
  .\init-agent.ps1 claude review-pr
  .\init-agent.ps1 copilot-prompt security vinh
  .\init-agent.ps1 gemini generate-tests
  .\init-agent.ps1 cursor validate-code
"@
    exit 1
}

# Validate platform
if (-not $PlatformFolders.ContainsKey($Platform)) {
    Write-Host "Error: Unknown platform '$Platform'" -ForegroundColor Red
    Show-Usage
}

# Get platform configuration
$Folder = $PlatformFolders[$Platform]
$Extension = $PlatformExtensions[$Platform]

# Validate command name format
if ($CommandName -notmatch '^[a-z]+(-[a-z]+)*$') {
    Write-Host "Error: Command name must be lowercase with hyphens (e.g., analyze-security)" -ForegroundColor Red
    exit 1
}

# Create folder structure
New-Item -ItemType Directory -Path $Folder -Force | Out-Null
Write-Host "✓ Created folder: $Folder" -ForegroundColor Green

# Generate file path
$FilePath = Join-Path $Folder "$CommandName.$Extension"

# Check if file already exists
if (Test-Path $FilePath) {
    Write-Host "Warning: File already exists: $FilePath" -ForegroundColor Yellow
    $response = Read-Host "Overwrite? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "Aborted."
        exit 0
    }
}

# Generate content based on format
if ($Extension -eq "toml") {
    # TOML format (Gemini CLI, Qwen Code)
    $content = @'
description = "TODO: Add description"

prompt = """
# Command Name

## Purpose
TODO: Explain the command's purpose and when to use it

## Context
TODO: Describe what context/information is needed

## Instructions
TODO: Provide step-by-step instructions for the AI agent

1. First step
2. Second step
3. Third step

## Output Format
TODO: Specify the expected output structure

## Examples
TODO: Provide concrete examples if applicable

Arguments: {{args}}
"""
'@
} else {
    # Markdown format
    $content = @'
---
description: "TODO: Add description"
---

# Command Name

## Purpose
TODO: Explain the command's purpose and when to use it

## Context
TODO: Describe what context/information is needed

## Instructions
TODO: Provide step-by-step instructions for the AI agent

1. First step
2. Second step
3. Third step

## Output Format
TODO: Specify the expected output structure

## Examples
TODO: Provide concrete examples if applicable

Arguments: $ARGUMENTS
'@

    # Add mode field for GitHub Copilot prompts
    if ($Platform -eq "copilot-prompt") {
        if ([string]::IsNullOrEmpty($ProjectName)) {
            Write-Host "Error: Project name required for GitHub Copilot prompts" -ForegroundColor Red
            Write-Host "Usage: init-agent.ps1 copilot-prompt <command-name> <project-name>"
            exit 1
        }
        
        $content = $content -replace '---\n', "---`nmode: $ProjectName.$CommandName`n"
    }
}

# Write content to file
Set-Content -Path $FilePath -Value $content -Encoding UTF8

Write-Host "✓ Created file: $FilePath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Edit $FilePath"
Write-Host "2. Replace TODO placeholders with actual content"
Write-Host "3. Test the command with your AI agent"
Write-Host ""
Write-Host "Usage example:"
if ($Extension -eq "toml") {
    Write-Host "  <agent> $CommandName <arguments>"
} else {
    Write-Host "  /$CommandName <arguments>"
}
