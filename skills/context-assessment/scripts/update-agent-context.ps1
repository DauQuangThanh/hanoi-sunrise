#!/usr/bin/env pwsh
# Update agent context files with assessment findings
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
$contextAssessment = Join-Path $repoRoot 'docs/context-assessment.md'

# Validate environment
if (-not (Test-Path $contextAssessment)) {
    Write-Err "Context assessment not found at $contextAssessment"
    Write-Info "Run setup-context-assessment.ps1 first"
    exit 1
}

# Define agent file paths
$agentFiles = @{
    'claude' = Join-Path $repoRoot 'CLAUDE.md'
    'gemini' = Join-Path $repoRoot 'GEMINI.md'
    'copilot' = Join-Path $repoRoot '.github/agents/copilot-instructions.md'
    'cursor-agent' = Join-Path $repoRoot '.cursor/rules/sunrise-rules.mdc'
    'qwen' = Join-Path $repoRoot 'QWEN.md'
    'opencode' = Join-Path $repoRoot 'AGENTS.md'
    'codex' = Join-Path $repoRoot 'AGENTS.md'
    'windsurf' = Join-Path $repoRoot '.windsurf/rules/sunrise-rules.md'
    'kilocode' = Join-Path $repoRoot '.kilocode/rules/sunrise-rules.md'
    'auggie' = Join-Path $repoRoot '.augment/rules/sunrise-rules.md'
    'roo' = Join-Path $repoRoot '.roo/rules/sunrise-rules.md'
    'codebuddy' = Join-Path $repoRoot 'CODEBUDDY.md'
    'amp' = Join-Path $repoRoot 'AGENTS.md'
    'shai' = Join-Path $repoRoot 'SHAI.md'
    'q' = Join-Path $repoRoot 'AGENTS.md'
    'bob' = Join-Path $repoRoot 'AGENTS.md'
    'jules' = Join-Path $repoRoot 'AGENTS.md'
    'qoder' = Join-Path $repoRoot 'QODER.md'
    'antigravity' = Join-Path $repoRoot 'AGENTS.md'
}

# Extract key findings from assessment
function Extract-Summary {
    param([string]$FilePath)
    
    $content = Get-Content -LiteralPath $FilePath -Raw -Encoding utf8
    
    # Extract technical health score
    $score = ''
    if ($content -match '\*\*Technical Health Score\*\*: (\d+/100)') {
        $score = $Matches[1]
    }
    
    # Extract key findings (first 3 bullets under Key Findings)
    $findings = @()
    if ($content -match '(?s)\*\*Key Findings\*\*:(.*?)\n\n') {
        $findingsText = $Matches[1]
        $findings = ($findingsText -split '\n' | Where-Object { $_ -match '^- ' } | Select-Object -First 3) -replace '^- ', '  • '
    }
    
    $summary = @"
## Context Assessment Summary

**Assessment Date**: $(Get-Date -Format 'yyyy-MM-dd')
"@
    
    if ($score) {
        $summary += "`n**Technical Health Score**: $score"
    }
    
    $summary += "`n"
    
    if ($findings) {
        $summary += "`n**Key Findings**:"
        $findings | ForEach-Object { $summary += "`n$_" }
    }
    
    $summary += @"


**Full Assessment**: See ``docs/context-assessment.md``

"@
    
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
    $summary = Extract-Summary -FilePath $contextAssessment
    
    # Read current content
    $content = Get-Content -LiteralPath $AgentFile -Raw -Encoding utf8
    
    # Check if file has context assessment marker
    if ($content -match '<!-- CONTEXT_ASSESSMENT_START -->') {
        # Update existing section
        $newContent = $content -replace '(?s)(<!-- CONTEXT_ASSESSMENT_START -->).*?(<!-- CONTEXT_ASSESSMENT_END -->)', "`$1`n$summary`$2"
        Set-Content -LiteralPath $AgentFile -Value $newContent -Encoding utf8 -NoNewline
        Write-Info "$([char]0x2713) Updated context assessment section in $AgentKey"
    } else {
        # Append new section
        $newSection = @"


<!-- CONTEXT_ASSESSMENT_START -->
$summary
<!-- CONTEXT_ASSESSMENT_END -->
"@
        Add-Content -LiteralPath $AgentFile -Value $newSection -Encoding utf8 -NoNewline
        Write-Info "$([char]0x2713) Added context assessment section to $AgentKey"
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
