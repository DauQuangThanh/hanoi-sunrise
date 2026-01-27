# check-e2e-prerequisites.ps1
# Checks for required files before running e2e-test-design skill
# Usage: .\check-e2e-prerequisites.ps1 [-Json]

param(
    [switch]$Json
)

# Get workspace root (assuming script is in skills/e2e-test-design/scripts/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Resolve-Path (Join-Path $ScriptDir "../../..")

# Required files
$ArchitectureFile = Join-Path $WorkspaceRoot "docs/architecture.md"
$GroundRulesFile = Join-Path $WorkspaceRoot "docs/ground-rules.md"

# Optional files
$StandardsFile = Join-Path $WorkspaceRoot "docs/standards.md"
$ExistingE2EPlan = Join-Path $WorkspaceRoot "docs/e2e-test-plan.md"
$SpecsDir = Join-Path $WorkspaceRoot "specs"

# Results
$AllRequiredPresent = $true
$Errors = @()
$Warnings = @()
$Info = @()
$SpecCount = 0

# Check required files
if (-not (Test-Path $ArchitectureFile)) {
    $AllRequiredPresent = $false
    $Errors += "architecture.md not found"
} else {
    $Info += "Found architecture.md"
}

if (-not (Test-Path $GroundRulesFile)) {
    $AllRequiredPresent = $false
    $Errors += "ground-rules.md not found"
} else {
    $Info += "Found ground-rules.md"
}

# Check optional files
if (-not (Test-Path $StandardsFile)) {
    $Warnings += "standards.md not found (optional but recommended for test code standards)"
} else {
    $Info += "Found standards.md"
}

if (Test-Path $ExistingE2EPlan) {
    $Info += "Found existing e2e-test-plan.md (will be updated)"
}

# Count feature specifications
if (Test-Path $SpecsDir) {
    $SpecFiles = Get-ChildItem -Path $SpecsDir -Filter "spec.md" -Recurse -File
    $SpecCount = $SpecFiles.Count
    if ($SpecCount -gt 0) {
        $Info += "Found $SpecCount feature specification(s)"
    } else {
        $Warnings += "No feature specifications found in specs/ (recommended for user journey extraction)"
    }
} else {
    $Warnings += "specs/ directory not found (recommended for user journey extraction)"
}

# Output results
if ($Json) {
    # JSON output for programmatic parsing
    $result = @{
        success = $AllRequiredPresent
        workspace_root = $WorkspaceRoot.Path
        required_files = @{
            architecture = @{
                path = $ArchitectureFile
                exists = Test-Path $ArchitectureFile
            }
            ground_rules = @{
                path = $GroundRulesFile
                exists = Test-Path $GroundRulesFile
            }
        }
        optional_files = @{
            standards = @{
                path = $StandardsFile
                exists = Test-Path $StandardsFile
            }
            existing_e2e_plan = @{
                path = $ExistingE2EPlan
                exists = Test-Path $ExistingE2EPlan
            }
        }
        feature_specs = @{
            directory = $SpecsDir
            count = $SpecCount
        }
        errors = $Errors
        warnings = $Warnings
        info = $Info
    }
    
    $result | ConvertTo-Json -Depth 10
} else {
    # Human-readable output
    Write-Host ""
    Write-Host "E2E Test Design Skill - Prerequisites Check" -ForegroundColor Blue
    Write-Host "=============================================="
    Write-Host ""
    
    # Workspace info
    Write-Host "Workspace: " -NoNewline
    Write-Host $WorkspaceRoot.Path -ForegroundColor Blue
    Write-Host ""
    
    # Required files section
    Write-Host "Required Files:" -ForegroundColor Blue
    if (Test-Path $ArchitectureFile) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " architecture.md"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " architecture.md (MISSING - REQUIRED)"
    }
    
    if (Test-Path $GroundRulesFile) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " ground-rules.md"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " ground-rules.md (MISSING - REQUIRED)"
    }
    Write-Host ""
    
    # Optional files section
    Write-Host "Optional Files:" -ForegroundColor Blue
    if (Test-Path $StandardsFile) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " standards.md (recommended for test code standards)"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "○" -ForegroundColor Yellow -NoNewline
        Write-Host " standards.md (optional but recommended for test code standards)"
    }
    
    if (Test-Path $ExistingE2EPlan) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " e2e-test-plan.md (will be updated)"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "○" -ForegroundColor Yellow -NoNewline
        Write-Host " e2e-test-plan.md (will be created)"
    }
    Write-Host ""
    
    # Feature specifications section
    Write-Host "Feature Specifications:" -ForegroundColor Blue
    if ($SpecCount -gt 0) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Found $SpecCount specification(s) in specs/"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "○" -ForegroundColor Yellow -NoNewline
        Write-Host " No specifications found (recommended for user journey extraction)"
    }
    Write-Host ""
    
    # Errors
    if ($Errors.Count -gt 0) {
        Write-Host "Errors:" -ForegroundColor Red
        foreach ($error in $Errors) {
            Write-Host "  " -NoNewline
            Write-Host "✗" -ForegroundColor Red -NoNewline
            Write-Host " $error"
        }
        Write-Host ""
    }
    
    # Warnings
    if ($Warnings.Count -gt 0) {
        Write-Host "Warnings:" -ForegroundColor Yellow
        foreach ($warning in $Warnings) {
            Write-Host "  " -NoNewline
            Write-Host "!" -ForegroundColor Yellow -NoNewline
            Write-Host " $warning"
        }
        Write-Host ""
    }
    
    # Summary
    if ($AllRequiredPresent) {
        Write-Host "✓ All required files present. Ready to run e2e-test-design skill." -ForegroundColor Green
        
        if ($SpecCount -eq 0) {
            Write-Host "Note: Consider adding feature specifications in specs/ for better user journey extraction." -ForegroundColor Yellow
        }
        
        if (-not (Test-Path $StandardsFile)) {
            Write-Host "Note: Consider creating standards.md for test code standards guidance." -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ Missing required files. Please create the following before running e2e-test-design skill:" -ForegroundColor Red
        foreach ($error in $Errors) {
            Write-Host "  - $error" -ForegroundColor Red
        }
        Write-Host ""
        Write-Host "Tip: Run 'architect' skill to create architecture.md if needed." -ForegroundColor Yellow
        Write-Host "Tip: Create docs/ground-rules.md with project principles and constraints." -ForegroundColor Yellow
    }
    Write-Host ""
}

# Exit with appropriate code
if ($AllRequiredPresent) {
    exit 0
} else {
    exit 1
}
