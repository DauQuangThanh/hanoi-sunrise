# check-prerequisites.ps1 - Locate feature specification file
#
# Usage:
#   .\check-prerequisites.ps1 -Json -PathsOnly
#   .\check-prerequisites.ps1
#
# Parameters:
#   -Json         Output results in JSON format
#   -PathsOnly    Only return path information (no validation)
#
# Requirements:
#   - PowerShell 5.1+
#   - git (optional)

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$Json,
    
    [Parameter(Mandatory=$false)]
    [switch]$PathsOnly
)

$ErrorActionPreference = 'Stop'

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
}

function Write-WarningMessage {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "⚠ $Message" -ForegroundColor Yellow
    }
}

# Detect if we're in a git repository
$HasGit = $false
$CurrentBranch = "main"
$FeatureDir = ""
$FeatureSpec = ""
$FeatureDesign = ""
$Tasks = ""

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
                
                if (Test-Path $FeatureDir) {
                    $FeatureSpec = "$FeatureDir/spec.md"
                    $FeatureDesign = "$FeatureDir/design/design.md"
                    $Tasks = "$FeatureDir/tasks.md"
                    
                    if (-not $PathsOnly) {
                        Write-InfoMessage "Detected feature branch: $CurrentBranch"
                        Write-InfoMessage "Feature directory: $FeatureDir"
                    }
                } else {
                    if (-not $PathsOnly) {
                        Write-WarningMessage "Feature branch detected but directory not found: $FeatureDir"
                    }
                }
            } else {
                if (-not $PathsOnly) {
                    Write-WarningMessage "Not on a feature branch (expected format: N-feature-name)"
                    Write-WarningMessage "Current branch: $CurrentBranch"
                }
            }
        }
    }
} catch {
    if (-not $PathsOnly) {
        Write-WarningMessage "Not in a git repository or git not available"
    }
}

# Check if spec file exists
$SpecExists = $false
if ($FeatureSpec -and (Test-Path $FeatureSpec)) {
    $SpecExists = $true
    if (-not $PathsOnly) {
        Write-SuccessMessage "Spec file found: $FeatureSpec"
    }
} else {
    if (-not $PathsOnly) {
        Write-ErrorMessage "Spec file not found"
        if ($FeatureSpec) {
            Write-InfoMessage "Expected at: $FeatureSpec"
        }
        Write-InfoMessage "Please create a spec first using requirements-specification skill"
    }
}

# Output results
if ($Json) {
    # JSON output
    $result = @{
        has_git = $HasGit
        current_branch = $CurrentBranch
        feature_dir = $FeatureDir
        feature_spec = $FeatureSpec
        feature_design = $FeatureDesign
        tasks = $Tasks
        spec_exists = $SpecExists
    }
    Write-Output ($result | ConvertTo-Json)
} else {
    # Human-readable output
    Write-Host ""
    if ($SpecExists) {
        Write-SuccessMessage "Prerequisites check passed"
    } else {
        Write-ErrorMessage "Prerequisites check failed: Spec file not found"
    }
    Write-Host ""
    Write-Host "Git available: $HasGit"
    Write-Host "Current branch: $CurrentBranch"
    Write-Host "Feature directory: $(if ($FeatureDir) { $FeatureDir } else { 'N/A' })"
    Write-Host "Spec file: $(if ($FeatureSpec) { $FeatureSpec } else { 'N/A' })"
    Write-Host "Spec exists: $SpecExists"
    Write-Host ""
    
    if (-not $SpecExists) {
        Write-InfoMessage "To create a spec, use the requirements-specification skill"
        exit 1
    }
}

exit 0
