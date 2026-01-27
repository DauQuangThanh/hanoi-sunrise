# check-design.ps1 - Check for technical design documentation and prerequisites
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File check-design.ps1
#   powershell -ExecutionPolicy Bypass -File check-design.ps1 -Json
#
# Parameters:
#   -Json    Output results in JSON format
#
# Requirements:
#   - PowerShell 5.1+ (Windows PowerShell) or PowerShell 7+ (PowerShell Core)
#   - git (optional - will work without git)

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Color codes for output
function Write-Info {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "ℹ " -ForegroundColor Blue -NoNewline
        Write-Host $Message
    }
}

function Write-Success {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "✓ " -ForegroundColor Green -NoNewline
        Write-Host $Message
    }
}

function Write-Error-Message {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "✗ " -ForegroundColor Red -NoNewline
        Write-Host $Message
    } else {
        Write-Error (@{ error = $Message } | ConvertTo-Json -Compress)
    }
}

function Write-Warning-Message {
    param([string]$Message)
    if (-not $Json) {
        Write-Host "⚠ " -ForegroundColor Yellow -NoNewline
        Write-Host $Message
    }
}

# Show help
if ($Help) {
    Write-Host "Usage: check-design.ps1 [-Json] [-Help]"
    Write-Host "  -Json    Output results in JSON format"
    Write-Host "  -Help    Show this help message"
    exit 0
}

# Get repository root
$RepoRoot = Get-Location

# Detect if we're in a git repository
$HasGit = $false
$CurrentBranch = ""
try {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $null = git rev-parse --git-dir 2>&1
        if ($LASTEXITCODE -eq 0) {
            $HasGit = $true
            $CurrentBranch = git branch --show-current 2>$null
            if (-not $CurrentBranch) {
                $CurrentBranch = ""
            }
        }
    }
} catch {
    $HasGit = $false
}

# Determine design directory location
$DesignDir = ""
if ($HasGit -and $CurrentBranch -match '^\d+-.+$') {
    # Feature branch pattern (e.g., 123-feature-name)
    if ($CurrentBranch -match '^(\d+)-') {
        $FeatureNum = $Matches[1]
        $SpecsPattern = Join-Path $RepoRoot "specs\$FeatureNum-*\design"
        $SpecsDirs = Get-Item $SpecsPattern -ErrorAction SilentlyContinue
        if ($SpecsDirs) {
            $DesignDir = $SpecsDirs[0].FullName
        }
    }
}

if (-not $DesignDir) {
    # Default location
    $DesignDir = Join-Path $RepoRoot "design"
}

# Check for design documentation
$DesignFile = ""
$ResearchFile = ""
$DataModelFile = ""
$ContractsDir = ""
$QuickstartFile = ""
$FeatureSpec = ""
$GroundRulesFile = ""
$ArchitectureFile = ""

$MissingFiles = @()
$FoundFiles = @()

# Check main design file
$DesignFilePath = Join-Path $DesignDir "design.md"
if (Test-Path $DesignFilePath) {
    $DesignFile = $DesignFilePath
    $FoundFiles += "design.md"
    Write-Success "Found design.md: $DesignFile"
} else {
    $MissingFiles += "design.md"
    Write-Error-Message "Missing design.md in $DesignDir"
}

# Check research file
$ResearchFilePath = Join-Path $DesignDir "research\research.md"
if (Test-Path $ResearchFilePath) {
    $ResearchFile = $ResearchFilePath
    $FoundFiles += "research.md"
    Write-Success "Found research.md: $ResearchFile"
} else {
    $MissingFiles += "research/research.md"
    Write-Error-Message "Missing research/research.md in $DesignDir"
}

# Check data model file
$DataModelFilePath = Join-Path $DesignDir "data-model.md"
if (Test-Path $DataModelFilePath) {
    $DataModelFile = $DataModelFilePath
    $FoundFiles += "data-model.md"
    Write-Success "Found data-model.md: $DataModelFile"
} else {
    $MissingFiles += "data-model.md"
    Write-Error-Message "Missing data-model.md in $DesignDir"
}

# Check contracts directory
$ContractsDirPath = Join-Path $DesignDir "contracts"
if (Test-Path $ContractsDirPath -PathType Container) {
    $ContractsDir = $ContractsDirPath
    $ContractCount = (Get-ChildItem -Path $ContractsDir -Filter "*.md" -File | Measure-Object).Count
    $FoundFiles += "contracts/ ($ContractCount files)"
    Write-Success "Found contracts directory: $ContractsDir ($ContractCount files)"
} else {
    $MissingFiles += "contracts/"
    Write-Error-Message "Missing contracts directory in $DesignDir"
}

# Check quickstart file (optional)
$QuickstartFilePath = Join-Path $DesignDir "quickstart.md"
if (Test-Path $QuickstartFilePath) {
    $QuickstartFile = $QuickstartFilePath
    $FoundFiles += "quickstart.md"
    Write-Success "Found quickstart.md: $QuickstartFile"
} else {
    Write-Warning-Message "Optional quickstart.md not found"
}

# Check for feature specification
if ($HasGit -and $CurrentBranch -match '^\d+-.+$') {
    if ($CurrentBranch -match '^(\d+)-') {
        $FeatureNum = $Matches[1]
        $SpecPattern = Join-Path $RepoRoot "specs\$FeatureNum-*\spec.md"
        $SpecFiles = Get-Item $SpecPattern -ErrorAction SilentlyContinue
        if ($SpecFiles) {
            $FeatureSpec = $SpecFiles[0].FullName
            $FoundFiles += "spec.md"
            Write-Success "Found feature spec: $FeatureSpec"
        } else {
            Write-Warning-Message "Feature specification not found (expected in specs/$FeatureNum-*/spec.md)"
        }
    }
} elseif (Test-Path (Join-Path $RepoRoot "specs\spec.md")) {
    $FeatureSpec = Join-Path $RepoRoot "specs\spec.md"
    $FoundFiles += "spec.md"
    Write-Success "Found spec.md: $FeatureSpec"
} else {
    Write-Warning-Message "Feature specification not found"
}

# Check for ground rules (optional)
$GroundRulesPath = Join-Path $RepoRoot "docs\ground-rules.md"
if (Test-Path $GroundRulesPath) {
    $GroundRulesFile = $GroundRulesPath
    $FoundFiles += "ground-rules.md"
    Write-Success "Found ground-rules.md: $GroundRulesFile"
} else {
    Write-Warning-Message "Optional ground-rules.md not found"
}

# Check for architecture (optional)
$ArchitecturePath = Join-Path $RepoRoot "docs\architecture.md"
if (Test-Path $ArchitecturePath) {
    $ArchitectureFile = $ArchitecturePath
    $FoundFiles += "architecture.md"
    Write-Success "Found architecture.md: $ArchitectureFile"
} else {
    Write-Warning-Message "Optional architecture.md not found"
}

# Output results
if ($Json) {
    # Build JSON output
    $result = @{
        design_file = $DesignFile
        research_file = $ResearchFile
        data_model_file = $DataModelFile
        contracts_dir = $ContractsDir
        quickstart_file = $QuickstartFile
        feature_spec = $FeatureSpec
        ground_rules_file = $GroundRulesFile
        architecture_file = $ArchitectureFile
        design_dir = $DesignDir
        current_branch = $CurrentBranch
        has_git = $HasGit
        found_files = $FoundFiles
        missing_files = $MissingFiles
        status = if ($MissingFiles.Count -eq 0) { "complete" } else { "incomplete" }
    }
    
    Write-Output ($result | ConvertTo-Json -Depth 10)
} else {
    # Human-readable output
    Write-Host ""
    Write-Host "=================================="
    Write-Host "Technical Design Prerequisites"
    Write-Host "=================================="
    Write-Host ""
    Write-Host "Repository: $RepoRoot"
    Write-Host "Design Directory: $DesignDir"
    if ($HasGit) {
        Write-Host "Current Branch: $CurrentBranch"
    }
    Write-Host ""
    Write-Host "Found Files ($($FoundFiles.Count)):"
    foreach ($file in $FoundFiles) {
        Write-Host "  ✓ $file"
    }
    Write-Host ""
    if ($MissingFiles.Count -gt 0) {
        Write-Host "Missing Files ($($MissingFiles.Count)):"
        foreach ($file in $MissingFiles) {
            Write-Host "  ✗ $file"
        }
        Write-Host ""
    }
    
    if ($MissingFiles.Count -eq 0) {
        Write-Host "Status: " -NoNewline
        Write-Host "All required files found" -ForegroundColor Green
        Write-Host ""
        Write-Host "Ready for technical design review!"
        exit 0
    } else {
        Write-Host "Status: " -NoNewline
        Write-Host "Missing required files" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please ensure all design documents are complete before review."
        Write-Host "Run the technical-design skill to generate missing files."
        exit 1
    }
}
