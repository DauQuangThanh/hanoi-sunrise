#!/usr/bin/env pwsh
# Setup script for architecture design workflow
# This is a portable skill-local version (PowerShell)

[CmdletBinding()]
param(
    [switch]$Json,
    [string]$Product = "",
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./setup-architect.ps1 [-Json] [-Product NAME] [-Help]"
    Write-Output "  -Json          Output results in JSON format"
    Write-Output "  -Product NAME  Specify product name"
    Write-Output "  -Help          Show this help message"
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

# Configuration
$docsDir = Join-Path $repoRoot 'docs'
$archDoc = Join-Path $docsDir 'architecture.md'
$adrDir = Join-Path $docsDir 'adr'
$specsDir = Join-Path $repoRoot 'specs'
$groundRules = Join-Path $repoRoot 'docs/ground-rules.md'

# Get product name
if ([string]::IsNullOrEmpty($Product)) {
    $Product = Split-Path -Leaf $repoRoot
}

# Create docs directory structure
New-Item -ItemType Directory -Path $docsDir -Force | Out-Null
New-Item -ItemType Directory -Path $adrDir -Force | Out-Null

# Copy architecture template from skill directory
$template = Join-Path $skillDir 'templates/arch-template.md'
if ((Test-Path $template) -and -not (Test-Path $archDoc)) {
    Copy-Item $template $archDoc -Force
    
    # Replace placeholders
    $content = Get-Content $archDoc -Raw
    $content = $content -replace '\[PRODUCT/PROJECT NAME\]', $Product
    $content = $content -replace '\[DATE\]', (Get-Date -Format 'yyyy-MM-dd')
    Set-Content -Path $archDoc -Value $content -NoNewline
    
    if (-not $Json) {
        Write-Host "$([char]0x2713) Created architecture document: $archDoc" -ForegroundColor Green
    }
} elseif (Test-Path $archDoc) {
    if (-not $Json) {
        Write-Host "INFO: Architecture document already exists: $archDoc"
    }
} else {
    if (-not $Json) {
        Write-Warning "Template not found at $template"
        Write-Warning "Creating empty architecture document"
    }
    New-Item -ItemType File -Path $archDoc -Force | Out-Null
}

# Count existing feature specs
$specCount = 0
$featureSpecs = @()
if (Test-Path $specsDir) {
    $featureSpecs = Get-ChildItem -Path $specsDir -Filter "spec.md" -Recurse -File | 
        ForEach-Object { $_.FullName }
    $specCount = $featureSpecs.Count
}

# Check if ground rules exist
$hasGroundRules = 'false'
if (Test-Path $groundRules) {
    $hasGroundRules = 'true'
}

# Output results
if ($Json) {
    $result = [PSCustomObject]@{
        ARCH_DOC = $archDoc
        DOCS_DIR = $docsDir
        ADR_DIR = $adrDir
        SPECS_DIR = $specsDir
        SPEC_COUNT = $specCount
        FEATURE_SPECS = $featureSpecs
        PRODUCT_NAME = $Product
        GROUND_RULES = $groundRules
        HAS_GROUND_RULES = $hasGroundRules
        REPO_ROOT = $repoRoot
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "Repository root: $repoRoot"
    Write-Output "Product name: $Product"
    Write-Output "Architecture document: $archDoc"
    Write-Output "Documentation directory: $docsDir"
    Write-Output "ADR directory: $adrDir"
    Write-Output "Feature specifications: $specCount found"
    Write-Output "Ground rules: $hasGroundRules"
    Write-Output ""
    Write-Host "$([char]0x2713) Setup complete. Architecture template is ready at:" -ForegroundColor Green
    Write-Output "  $archDoc"
    
    if ($hasGroundRules -eq 'false') {
        Write-Output ""
        Write-Warning "Ground rules not found at $groundRules"
        Write-Output "         Create project principles first for better architecture guidance"
    }
}
