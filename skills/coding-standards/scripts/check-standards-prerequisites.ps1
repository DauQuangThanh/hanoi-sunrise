# check-standards-prerequisites.ps1
# Detects required files for coding standards generation
# Usage: .\check-standards-prerequisites.ps1 [-Json]
# Output: JSON with file paths and status

[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Json
)

# Get repository root (assumes script is in skills/coding-standards/scripts/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../../..")

# Initialize result structure
$files = @{
    groundRules        = ""
    architecture       = ""
    existingStandards  = ""
}
$featureSpecs = @()

# Function to find file (case-insensitive)
function Find-File {
    param(
        [string]$SearchDir,
        [string]$Pattern
    )
    
    if (-not (Test-Path -Path $SearchDir -PathType Container)) {
        return ""
    }
    
    $file = Get-ChildItem -Path $SearchDir -Filter $Pattern -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($file) {
        return $file.FullName
    }
    return ""
}

# Check for ground-rules.md (required)
$memoryDir = Join-Path $RepoRoot "memory"
$files.groundRules = Find-File -SearchDir $memoryDir -Pattern "ground-rules.md"

# Check for architecture.md (recommended)
$docsDir = Join-Path $RepoRoot "docs"
$files.architecture = Find-File -SearchDir $docsDir -Pattern "architecture.md"

# Check for existing standards.md (for updates)
$files.existingStandards = Find-File -SearchDir $docsDir -Pattern "standards.md"

# Find feature specifications
$specsDir = Join-Path $RepoRoot "specs"
if (Test-Path -Path $specsDir -PathType Container) {
    $featureSpecs = Get-ChildItem -Path $specsDir -Filter "spec.md" -File -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
}

# Check required files
$missingRequired = @()
if ([string]::IsNullOrEmpty($files.groundRules)) {
    $missingRequired += "docs/ground-rules.md"
}

# Determine overall status
$success = $missingRequired.Count -eq 0
if ($success) {
    $message = "All required files found"
} else {
    $message = "Missing required file: $($missingRequired -join ', ')"
}

# Count found files
$requiredFound = 0
$recommendedFound = 0
$optionalFound = 0

if (-not [string]::IsNullOrEmpty($files.groundRules)) {
    $requiredFound++
}

if (-not [string]::IsNullOrEmpty($files.architecture)) {
    $recommendedFound++
}

if (-not [string]::IsNullOrEmpty($files.existingStandards)) {
    $optionalFound++
}

if ($featureSpecs.Count -gt 0) {
    $optionalFound += $featureSpecs.Count
}

$totalFound = $requiredFound + $recommendedFound + $optionalFound

# Build result object
$result = @{
    success          = $success
    message          = $message
    repositoryRoot   = $RepoRoot.Path
    files            = @{
        required = @{
            groundRules = $files.groundRules
        }
        recommended = @{
            architecture = $files.architecture
        }
        optional = @{
            existingStandards = $files.existingStandards
            featureSpecs      = $featureSpecs
        }
    }
    summary          = @{
        totalFound         = $totalFound
        requiredFound      = $requiredFound
        recommendedFound   = $recommendedFound
        optionalFound      = $optionalFound
        featureSpecsCount  = $featureSpecs.Count
        missingRequired    = $missingRequired
    }
}

# Output result
if ($Json) {
    $result | ConvertTo-Json -Depth 10
} else {
    Write-Host "`nCoding Standards - Prerequisite Check" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host "`nRepository Root: $($RepoRoot.Path)" -ForegroundColor White
    Write-Host "`nStatus: " -NoNewline
    if ($success) {
        Write-Host "SUCCESS" -ForegroundColor Green
    } else {
        Write-Host "INCOMPLETE" -ForegroundColor Yellow
    }
    Write-Host "Message: $message`n" -ForegroundColor White
    
    Write-Host "Required Files:" -ForegroundColor Yellow
    Write-Host "  ground-rules.md  : " -NoNewline
    if ($files.groundRules) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                     $($files.groundRules)" -ForegroundColor Gray
    } else {
        Write-Host "MISSING" -ForegroundColor Red
    }
    
    Write-Host "`nRecommended Files:" -ForegroundColor Yellow
    Write-Host "  architecture.md  : " -NoNewline
    if ($files.architecture) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                     $($files.architecture)" -ForegroundColor Gray
    } else {
        Write-Host "NOT FOUND" -ForegroundColor Gray
    }
    
    Write-Host "`nOptional Files:" -ForegroundColor Yellow
    Write-Host "  standards.md     : " -NoNewline
    if ($files.existingStandards) {
        Write-Host "FOUND (for updates)" -ForegroundColor Green
        Write-Host "                     $($files.existingStandards)" -ForegroundColor Gray
    } else {
        Write-Host "NOT FOUND (will create new)" -ForegroundColor Gray
    }
    
    Write-Host "  feature specs    : $($featureSpecs.Count) found" -ForegroundColor White
    if ($featureSpecs.Count -gt 0) {
        foreach ($spec in $featureSpecs) {
            Write-Host "                     $spec" -ForegroundColor Gray
        }
    }
    
    Write-Host "`nSummary:" -ForegroundColor Cyan
    Write-Host "  Total Found         : $totalFound" -ForegroundColor White
    Write-Host "  Required Found      : $requiredFound / 1" -ForegroundColor White
    Write-Host "  Recommended Found   : $recommendedFound / 1" -ForegroundColor White
    Write-Host "  Optional Found      : $optionalFound" -ForegroundColor White
    
    if ($missingRequired.Count -gt 0) {
        Write-Host "`nMissing Required: $($missingRequired -join ', ')" -ForegroundColor Red
    }
    
    Write-Host "`n" -NoNewline
}

exit 0
