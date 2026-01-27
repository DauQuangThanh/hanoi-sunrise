#!/usr/bin/env pwsh
# Update agent context files with architecture decisions
# This is a portable skill-local version (PowerShell)

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet('claude','gemini','copilot','cursor-agent','qwen','opencode','codex','windsurf','kilocode','auggie','roo','codebuddy','amp','shai','q','bob','jules','qoder','antigravity')]
    [string]$AgentType
)

$ErrorActionPreference = 'Stop'

function Write-Info { 
    param([string]$Message)
    Write-Host "INFO: $Message" -ForegroundColor Green
}

function Write-Warn { 
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Write-Err { 
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

# Get script directory (skill's scripts/ folder)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillDir = Split-Path -Parent $scriptDir

# Detect repository root
function Find-RepoRoot {
    $dir = Get-Location
    while ($dir.Path -ne $dir.Root) {
        if (Test-Path (Join-Path $dir.Path '.git')) {
            return $dir.Path
        }
        $dir = Split-Path -Parent $dir.Path
        if (-not $dir) { break }
    }
    return (Get-Location).Path
}

$repoRoot = Find-RepoRoot
$archDoc = Join-Path $repoRoot 'docs/architecture.md'

# Validate environment
if (-not (Test-Path $archDoc)) {
    Write-Err "Architecture document not found at $archDoc"
    Write-Info "Run setup-architect.ps1 first"
    exit 1
}

# Define agent file paths
$agentFiles = @{
    'claude' = Join-Path $repoRoot 'CLAUDE.md'
    'gemini' = Join-Path $repoRoot 'GEMINI.md'
    'copilot' = Join-Path $repoRoot '.github/agents/copilot-instructions.md'
    'cursor-agent' = Join-Path $repoRoot '.cursor/rules/phoenix-rules.mdc'
    'qwen' = Join-Path $repoRoot 'QWEN.md'
    'opencode' = Join-Path $repoRoot 'AGENTS.md'
    'codex' = Join-Path $repoRoot 'AGENTS.md'
    'windsurf' = Join-Path $repoRoot '.windsurf/rules/phoenix-rules.md'
    'kilocode' = Join-Path $repoRoot '.kilocode/rules/phoenix-rules.md'
    'auggie' = Join-Path $repoRoot '.augment/rules/phoenix-rules.md'
    'roo' = Join-Path $repoRoot '.roo/rules/phoenix-rules.md'
    'codebuddy' = Join-Path $repoRoot 'CODEBUDDY.md'
    'amp' = Join-Path $repoRoot 'AGENTS.md'
    'shai' = Join-Path $repoRoot 'SHAI.md'
    'q' = Join-Path $repoRoot 'AGENTS.md'
    'bob' = Join-Path $repoRoot 'AGENTS.md'
    'jules' = Join-Path $repoRoot 'AGENTS.md'
    'qoder' = Join-Path $repoRoot 'QODER.md'
    'antigravity' = Join-Path $repoRoot 'AGENTS.md'
}

# Extract architecture summary
function Extract-Summary {
    param([string]$FilePath)
    
    $content = Get-Content -LiteralPath $FilePath -Raw -Encoding utf8
    
    # Extract executive summary components
    $what = ''
    $tech = ''
    if ($content -match '\*\*What\*\*:.*?\n- (.+)') {
        $what = $Matches[1]
    }
    if ($content -match '\*\*Core Tech\*\*:.*?\n- (.+)') {
        $tech = $Matches[1]
    }
    
    # Extract key ADRs (first 3 rows)
    $adrs = @()
    if ($content -match '(?s)\| ADR-.*?\n((?:\| ADR-.*?\n){0,3})') {
        $adrLines = $Matches[1] -split '\n' | Where-Object { $_ -match '^\| ADR-' } | Select-Object -First 3
        foreach ($line in $adrLines) {
            if ($line -match '\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|') {
                $title = $Matches[2].Trim()
                $status = $Matches[3].Trim()
                $adrs += "  • $title ($status)"
            }
        }
    }
    
    # Extract quality targets
    $perf = ''
    $avail = ''
    if ($content -match '(?s)### 6\.1 Performance.*?- Targets: ([^\n]+)') {
        $perf = $Matches[1].Trim()
    }
    if ($content -match '(?s)### 6\.3 Availability.*?- Targets: ([^\n]+)') {
        $avail = $Matches[1].Trim()
    }
    
    $summary = @"
## Architecture Summary

**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')

"@
    
    if ($what) {
        $summary += "**System Purpose**: $what`n"
    }
    if ($tech) {
        $summary += "**Technology Stack**: $tech`n"
    }
    
    $summary += "`n"
    
    if ($adrs) {
        $summary += "**Key Architecture Decisions**:`n"
        $adrs | ForEach-Object { $summary += "$_`n" }
        $summary += "`n"
    }
    
    if ($perf -or $avail) {
        $summary += "**Quality Targets**:`n"
        if ($perf) { $summary += "  • Performance: $perf`n" }
        if ($avail) { $summary += "  • Availability: $avail`n" }
        $summary += "`n"
    }
    
    $summary += "**Full Architecture**: See ``docs/architecture.md```n`n"
    
    return $summary
}

# Update a single agent file
function Update-AgentFile {
    param(
        [string]$AgentKey,
        [string]$AgentFile
    )
    
    if (-not (Test-Path $AgentFile)) {
        Write-Warn "Agent file not found: $AgentFile (skipping $AgentKey)"
        return
    }
    
    Write-Info "Updating $AgentKey context at $AgentFile"
    
    # Extract summary
    $summary = Extract-Summary -FilePath $archDoc
    
    # Read current content
    $content = Get-Content -LiteralPath $AgentFile -Raw -Encoding utf8
    
    # Check if file has architecture marker
    if ($content -match '<!-- ARCHITECTURE_START -->') {
        # Update existing section
        $newContent = $content -replace '(?s)(<!-- ARCHITECTURE_START -->).*?(<!-- ARCHITECTURE_END -->)', "`$1`n$summary`$2"
        Set-Content -LiteralPath $AgentFile -Value $newContent -Encoding utf8 -NoNewline
        Write-Info "$([char]0x2713) Updated architecture section in $AgentKey"
    } else {
        # Append new section
        $newSection = @"


<!-- ARCHITECTURE_START -->
$summary
<!-- ARCHITECTURE_END -->
"@
        Add-Content -LiteralPath $AgentFile -Value $newSection -Encoding utf8 -NoNewline
        Write-Info "$([char]0x2713) Added architecture section to $AgentKey"
    }
}

# Main execution
if ($AgentType) {
    # Update specific agent
    $agentFile = $agentFiles[$AgentType]
    Update-AgentFile -AgentKey $AgentType -AgentFile $agentFile
} else {
    # Update all existing agent files
    $updated = 0
    foreach ($agentKey in $agentFiles.Keys) {
        $agentFile = $agentFiles[$agentKey]
        if (Test-Path $agentFile) {
            Update-AgentFile -AgentKey $agentKey -AgentFile $agentFile
            $updated++
        }
    }
    
    if ($updated -eq 0) {
        Write-Warn "No agent files found in repository"
        Write-Info "Create an agent file first, then run this script"
    } else {
        Write-Info "$([char]0x2713) Updated $updated agent file(s)"
    }
}

Write-Info "$([char]0x2713) Agent context update complete"
