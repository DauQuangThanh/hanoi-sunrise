# create-feature.ps1 - Create a new feature branch and spec structure
#
# Usage:
#   .\create-feature.ps1 -Number 5 -ShortName "user-auth" -Description "Add user authentication"
#   .\create-feature.ps1 -Json -Number 5 -ShortName "user-auth" -Description "Add user authentication"
#
# Parameters:
#   -Number          Feature number (required)
#   -ShortName       Short name for the feature (required)
#   -Description     Feature description (required)
#   -Json            Output results as JSON
#
# Requirements:
#   - git
#   - PowerShell 5.1+

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [int]$Number,
    
    [Parameter(Mandatory=$true)]
    [string]$ShortName,
    
    [Parameter(Mandatory=$true)]
    [string]$Description,
    
    [Parameter(Mandatory=$false)]
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = Split-Path -Parent $ScriptDir
$TemplatesDir = Join-Path $SkillDir "templates"

# Functions for colored output
function Write-InfoMessage {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "ℹ $Message" -ForegroundColor Blue
    }
}

function Write-SuccessMessage {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "✓ $Message" -ForegroundColor Green
    }
}

function Write-ErrorMessage {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "✗ $Message" -ForegroundColor Red
    } else {
        $errorObj = @{
            error = $Message
        }
        Write-Output ($errorObj | ConvertTo-Json)
    }
    throw $Message
}

function Write-WarningMessage {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "⚠ $Message" -ForegroundColor Yellow
    }
}

# Function to validate short name format
function Test-ShortName {
    param([string]$Name)
    
    # Check length
    if ($Name.Length -lt 1 -or $Name.Length -gt 64) {
        Write-ErrorMessage "Short name must be 1-64 characters"
        return $false
    }
    
    # Check format: lowercase, numbers, hyphens only
    if ($Name -notmatch '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$') {
        Write-ErrorMessage "Short name must use lowercase letters, numbers, and hyphens only"
        Write-ErrorMessage "Cannot start/end with hyphen or have consecutive hyphens"
        return $false
    }
    
    # Check for consecutive hyphens
    if ($Name -match '--') {
        Write-ErrorMessage "Short name cannot contain consecutive hyphens"
        return $false
    }
    
    return $true
}

# Validate short name format
if (-not (Test-ShortName -Name $ShortName)) {
    exit 1
}

# Construct branch name and paths
$BranchName = "$Number-$ShortName"
$SpecsDir = "specs/$BranchName"
$SpecFile = "$SpecsDir/spec.md"
$ChecklistDir = "$SpecsDir/checklists"
$ChecklistFile = "$ChecklistDir/requirements.md"

Write-InfoMessage "Creating feature: $BranchName"
Write-InfoMessage "Description: $Description"

# Check if git is available
try {
    $null = git --version 2>&1
} catch {
    Write-ErrorMessage "git is not installed or not in PATH"
    exit 1
}

# Check if we're in a git repository
try {
    $null = git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMessage "Not in a git repository"
        exit 1
    }
} catch {
    Write-ErrorMessage "Not in a git repository"
    exit 1
}

# Check if branch already exists
$branchExists = git show-ref --verify --quiet "refs/heads/$BranchName" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-ErrorMessage "Branch '$BranchName' already exists"
    exit 1
}

# Create and checkout new branch
Write-InfoMessage "Creating branch: $BranchName"
try {
    git checkout -b $BranchName 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMessage "Failed to create branch '$BranchName'"
        exit 1
    }
    Write-SuccessMessage "Branch created and checked out"
} catch {
    Write-ErrorMessage "Failed to create branch '$BranchName'"
    exit 1
}

# Create directory structure
Write-InfoMessage "Creating directory structure"
New-Item -ItemType Directory -Path $SpecsDir -Force | Out-Null
New-Item -ItemType Directory -Path $ChecklistDir -Force | Out-Null
Write-SuccessMessage "Directories created"

# Copy spec template
$SpecTemplatePath = Join-Path $TemplatesDir "spec-template.md"
if (Test-Path $SpecTemplatePath) {
    Write-InfoMessage "Copying spec template"
    Copy-Item $SpecTemplatePath $SpecFile
    
    # Replace placeholders
    $CurrentDate = Get-Date -Format "yyyy-MM-dd"
    $content = Get-Content $SpecFile -Raw
    $content = $content -replace '\[Feature Name\]', $ShortName
    $content = $content -replace '\[Number-ShortName\]', $BranchName
    $content = $content -replace '\[Date\]', $CurrentDate
    Set-Content -Path $SpecFile -Value $content -NoNewline
    
    Write-SuccessMessage "Spec template created"
} else {
    Write-WarningMessage "Spec template not found, creating basic spec file"
    $CurrentDate = Get-Date -Format "yyyy-MM-dd"
    $basicSpec = @"
# $ShortName

**Feature ID**: $BranchName
**Status**: Draft
**Created**: $CurrentDate

## Overview

$Description

## User Scenarios & Testing

[To be filled]

## Functional Requirements

[To be filled]

## Success Criteria

[To be filled]

## Assumptions

[To be filled]

## Out of Scope

[To be filled]
"@
    Set-Content -Path $SpecFile -Value $basicSpec
    Write-SuccessMessage "Basic spec file created"
}

# Copy checklist template
$ChecklistTemplatePath = Join-Path $TemplatesDir "checklist-template.md"
if (Test-Path $ChecklistTemplatePath) {
    Write-InfoMessage "Copying checklist template"
    Copy-Item $ChecklistTemplatePath $ChecklistFile
    
    # Replace placeholders
    $CurrentDate = Get-Date -Format "yyyy-MM-dd"
    $content = Get-Content $ChecklistFile -Raw
    $content = $content -replace '\[FEATURE NAME\]', $ShortName
    $content = $content -replace '\[DATE\]', $CurrentDate
    $content = $content -replace '\[Link to spec\.md\]', '[spec.md](../spec.md)'
    Set-Content -Path $ChecklistFile -Value $content -NoNewline
    
    Write-SuccessMessage "Checklist template created"
} else {
    Write-WarningMessage "Checklist template not found, creating basic checklist file"
    $CurrentDate = Get-Date -Format "yyyy-MM-dd"
    $basicChecklist = @"
# Specification Quality Checklist: $ShortName

**Feature**: [spec.md](../spec.md)
**Created**: $CurrentDate

## Content Quality
- [ ] No implementation details
- [ ] Focused on user value
- [ ] All mandatory sections completed

## Requirement Completeness
- [ ] Requirements are testable
- [ ] Success criteria are measurable
- [ ] Edge cases identified

## Feature Readiness
- [ ] Ready for next phase
"@
    Set-Content -Path $ChecklistFile -Value $basicChecklist
    Write-SuccessMessage "Basic checklist file created"
}

# Output results
if ($Json) {
    # JSON output
    $result = @{
        success = $true
        branch_name = $BranchName
        feature_number = $Number
        short_name = $ShortName
        description = $Description
        spec_file = $SpecFile
        checklist_file = $ChecklistFile
        specs_dir = $SpecsDir
    }
    Write-Output ($result | ConvertTo-Json)
} else {
    # Human-readable output
    Write-Host ""
    Write-SuccessMessage "Feature created successfully!"
    Write-Host ""
    Write-Host "Branch: $BranchName"
    Write-Host "Spec file: $SpecFile"
    Write-Host "Checklist: $ChecklistFile"
    Write-Host ""
    Write-InfoMessage "Next steps:"
    Write-Host "  1. Fill in the specification: $SpecFile"
    Write-Host "  2. Validate using checklist: $ChecklistFile"
    Write-Host "  3. Commit your changes: git add . && git commit -m 'docs: add specification for $ShortName'"
}

exit 0
