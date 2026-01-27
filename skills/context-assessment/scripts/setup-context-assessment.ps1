#!/usr/bin/env pwsh
# Setup context assessment for brownfield project
# This is a portable skill-local version (PowerShell)

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./setup-context-assessment.ps1 [-Json] [-Help]"
    Write-Output "  -Json     Output results in JSON format"
    Write-Output "  -Help     Show this help message"
    exit 0
}

# Get script directory (skill's scripts/ folder)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillDir = Split-Path -Parent $scriptDir

# Detect repository root (search upward for .git or go to parent until root)
function Find-RepoRoot {
    $dir = Get-Location
    while ($dir.Path -ne $dir.Root) {
        if (Test-Path (Join-Path $dir.Path '.git')) {
            return $dir.Path
        }
        $dir = Split-Path -Parent $dir.Path
        if (-not $dir) { break }
    }
    # If no .git found, use current directory
    return (Get-Location).Path
}

$repoRoot = Find-RepoRoot

# Ensure the docs directory exists
$docsDir = Join-Path $repoRoot 'docs'
New-Item -ItemType Directory -Path $docsDir -Force | Out-Null

# Set the context assessment file path (project-level, not feature-specific)
$contextAssessment = Join-Path $docsDir 'context-assessment.md'

# Copy template from skill directory
$template = Join-Path $skillDir 'templates/context-assessment-template.md'
if (Test-Path $template) {
    Copy-Item $template $contextAssessment -Force
    if (-not $Json) {
        Write-Host "$([char]0x2713) Copied context assessment template to $contextAssessment" -ForegroundColor Green
    }
} else {
    if (-not $Json) {
        Write-Warning "Context assessment template not found at $template"
        Write-Warning "Creating empty assessment file"
    }
    New-Item -ItemType File -Path $contextAssessment -Force | Out-Null
}

# Check if we're in a git repo
$hasGit = 'false'
if (Test-Path (Join-Path $repoRoot '.git')) {
    $hasGit = 'true'
}

# Output results
if ($Json) {
    $result = [PSCustomObject]@{
        CONTEXT_ASSESSMENT = $contextAssessment
        DOCS_DIR = $docsDir
        REPO_ROOT = $repoRoot
        HAS_GIT = $hasGit
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "Repository root: $repoRoot"
    Write-Output "Documentation directory: $docsDir"
    Write-Output "Assessment file: $contextAssessment"
    Write-Output "Git repository: $hasGit"
    Write-Output ""
    Write-Host "$([char]0x2713) Setup complete. Context assessment template is ready at:" -ForegroundColor Green
    Write-Output "  $contextAssessment"
}
