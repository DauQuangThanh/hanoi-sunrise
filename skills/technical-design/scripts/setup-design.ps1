# setup-design.ps1 - Set up design directory structure and templates
#
# Usage:
#   .\setup-design.ps1
#   .\setup-design.ps1 -Json
#
# Parameters:
#   -Json    Output results in JSON format
#
# Requirements:
#   - PowerShell 5.1+
#   - git (optional - will work without git)

[CmdletBinding()]
param(
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

# Detect if we're in a git repository and on a feature branch
$HasGit = $false
$CurrentBranch = "main"
$FeatureDir = ""
$FeatureSpec = ""

try {
    $null = git --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        $null = git rev-parse --git-dir 2>&1
        if ($LASTEXITCODE -eq 0) {
            $HasGit = $true
            $CurrentBranch = git rev-parse --abbrev-ref HEAD 2>$null
            if (-not $CurrentBranch) {
                $CurrentBranch = "main"
            }
            
            # Check if we're on a feature branch (format: N-feature-name)
            if ($CurrentBranch -match '^[0-9]+-(.+)$') {
                $FeatureDir = "specs/$CurrentBranch"
                $FeatureSpec = "$FeatureDir/spec.md"
                Write-InfoMessage "Detected feature branch: $CurrentBranch"
            } else {
                Write-ErrorMessage "Not on a feature branch. Technical design requires a feature branch (format: N-feature-name)"
                Write-ErrorMessage "Please create and checkout a feature branch first"
                exit 1
            }
        } else {
            Write-ErrorMessage "Git repository required for technical design workflow"
            Write-ErrorMessage "Please initialize git repository and create a feature branch (format: N-feature-name)"
            exit 1
        }
    } else {
        Write-ErrorMessage "Git is not installed or not available"
        Write-ErrorMessage "Technical design requires git and a feature branch (format: N-feature-name)"
        exit 1
    }
} catch {
    Write-ErrorMessage "Git repository required for technical design workflow"
    Write-ErrorMessage "Please initialize git repository and create a feature branch (format: N-feature-name)"
    exit 1
}

# Design directory location - always feature-specific
if ($FeatureDir -and (Test-Path $FeatureDir)) {
    $DesignDir = "$FeatureDir/design"
    Write-InfoMessage "Using feature-specific design directory: $DesignDir"
} else {
    Write-ErrorMessage "Feature directory not found: $FeatureDir"
    Write-ErrorMessage "Please ensure specs/$CurrentBranch directory exists"
    exit 1
}

$FeatureDesign = "$DesignDir/design.md"
$ResearchFile = "$DesignDir/research/research.md"
$DataModelFile = "$DesignDir/data-model.md"
$QuickstartFile = "$DesignDir/quickstart.md"
$ContractsDir = "$DesignDir/contracts"

# Create directory structure
Write-InfoMessage "Creating design directory structure"
New-Item -ItemType Directory -Path $DesignDir -Force | Out-Null
New-Item -ItemType Directory -Path "$DesignDir/research" -Force | Out-Null
New-Item -ItemType Directory -Path $ContractsDir -Force | Out-Null
Write-SuccessMessage "Directories created"

# Copy design template
$DesignTemplatePath = Join-Path $TemplatesDir "design-template.md"
if (Test-Path $DesignTemplatePath) {
    Write-InfoMessage "Copying design template"
    Copy-Item $DesignTemplatePath $FeatureDesign
    Write-SuccessMessage "Design template copied to $FeatureDesign"
} else {
    Write-ErrorMessage "Design template not found at $DesignTemplatePath"
    exit 1
}

# Copy research template
$ResearchTemplatePath = Join-Path $TemplatesDir "research-template.md"
if (Test-Path $ResearchTemplatePath) {
    Write-InfoMessage "Copying research template"
    Copy-Item $ResearchTemplatePath $ResearchFile
    Write-SuccessMessage "Research template copied to $ResearchFile"
} else {
    Write-WarningMessage "Research template not found, skipping"
}

# Copy data model template
$DataModelTemplatePath = Join-Path $TemplatesDir "data-model-template.md"
if (Test-Path $DataModelTemplatePath) {
    Write-InfoMessage "Copying data model template"
    Copy-Item $DataModelTemplatePath $DataModelFile
    Write-SuccessMessage "Data model template copied to $DataModelFile"
} else {
    Write-WarningMessage "Data model template not found, skipping"
}

# Create placeholder API contract
$ContractTemplatePath = Join-Path $TemplatesDir "api-contract-template.md"
if (Test-Path $ContractTemplatePath) {
    Write-InfoMessage "Copying API contract template"
    Copy-Item $ContractTemplatePath "$ContractsDir/example-contract.md"
    Write-SuccessMessage "API contract template copied to $ContractsDir/"
} else {
    Write-WarningMessage "API contract template not found, skipping"
}

# Output results
if ($Json) {
    # JSON output
    $result = @{
        success = $true
        has_git = $HasGit
        current_branch = $CurrentBranch
        feature_spec = $FeatureSpec
        feature_design = $FeatureDesign
        research_file = $ResearchFile
        data_model_file = $DataModelFile
        quickstart_file = $QuickstartFile
        contracts_dir = $ContractsDir
        design_dir = $DesignDir
    }
    Write-Output ($result | ConvertTo-Json)
} else {
    # Human-readable output
    Write-Host ""
    Write-SuccessMessage "Design workspace created successfully!"
    Write-Host ""
    Write-Host "Design directory: $DesignDir"
    Write-Host "Design document: $FeatureDesign"
    Write-Host "Research document: $ResearchFile"
    Write-Host "Data model: $DataModelFile"
    Write-Host "Contracts directory: $ContractsDir"
    if ($FeatureSpec) {
        Write-Host "Feature spec: $FeatureSpec"
    }
    Write-Host ""
    Write-InfoMessage "Next steps:"
    Write-Host "  1. Review and fill in $FeatureDesign"
    Write-Host "  2. Conduct research and document in $ResearchFile"
    Write-Host "  3. Design data models in $DataModelFile"
    Write-Host "  4. Create API contracts in $ContractsDir/"
}

exit 0
