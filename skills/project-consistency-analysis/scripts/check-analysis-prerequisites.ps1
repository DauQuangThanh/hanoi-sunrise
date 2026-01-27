# check-analysis-prerequisites.ps1
# Detects required artifacts for project consistency analysis
# Usage: .\check-analysis-prerequisites.ps1 [-FeatureDirectory <path>] [-Json]
# Output: JSON with artifact paths and status

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$FeatureDirectory = ".",
    
    [Parameter()]
    [switch]$Json
)

# Initialize result structure
$artifacts = @{
    spec         = ""
    design       = ""
    tasks        = ""
    groundRules  = ""
    architecture = ""
    standards    = ""
}

# Check if directory exists
if (-not (Test-Path -Path $FeatureDirectory -PathType Container)) {
    $result = @{
        success          = $false
        error            = "Directory not found: $FeatureDirectory"
        featureDirectory = $FeatureDirectory
    }
    
    if ($Json) {
        $result | ConvertTo-Json -Depth 10
    } else {
        Write-Error $result.error
    }
    exit 1
}

# Convert to absolute path
$FeatureDirectory = (Resolve-Path -Path $FeatureDirectory).Path

# Function to find file (case-insensitive)
function Find-File {
    param(
        [string]$Directory,
        [string]$Pattern
    )
    
    $file = Get-ChildItem -Path $Directory -Filter $Pattern -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($file) {
        return $file.FullName
    }
    return ""
}

# Required artifacts
$artifacts.spec = Find-File -Directory $FeatureDirectory -Pattern "spec.md"
$artifacts.design = Find-File -Directory $FeatureDirectory -Pattern "design.md"
$artifacts.tasks = Find-File -Directory $FeatureDirectory -Pattern "tasks.md"

# Optional artifacts (check memory and docs subdirectories, also parent)
$memoryDir = Join-Path -Path $FeatureDirectory -ChildPath "memory"
$parentMemoryDir = Join-Path -Path (Split-Path -Parent $FeatureDirectory) -ChildPath "memory"
$docsDir = Join-Path -Path $FeatureDirectory -ChildPath "docs"
$parentDocsDir = Join-Path -Path (Split-Path -Parent $FeatureDirectory) -ChildPath "docs"

if (Test-Path -Path $memoryDir) {
    $artifacts.groundRules = Find-File -Directory $memoryDir -Pattern "ground-rules.md"
} elseif (Test-Path -Path $parentMemoryDir) {
    $artifacts.groundRules = Find-File -Directory $parentMemoryDir -Pattern "ground-rules.md"
}

if (Test-Path -Path $docsDir) {
    $artifacts.architecture = Find-File -Directory $docsDir -Pattern "architecture.md"
    $artifacts.standards = Find-File -Directory $docsDir -Pattern "standards.md"
} elseif (Test-Path -Path $parentDocsDir) {
    $artifacts.architecture = Find-File -Directory $parentDocsDir -Pattern "architecture.md"
    $artifacts.standards = Find-File -Directory $parentDocsDir -Pattern "standards.md"
}

# Check required artifacts
$missingRequired = @()
if ([string]::IsNullOrEmpty($artifacts.spec)) {
    $missingRequired += "spec.md"
}
if ([string]::IsNullOrEmpty($artifacts.design)) {
    $missingRequired += "design.md"
}
if ([string]::IsNullOrEmpty($artifacts.tasks)) {
    $missingRequired += "tasks.md"
}

# Determine overall status
$success = $missingRequired.Count -eq 0
if ($success) {
    $message = "All required artifacts found"
} else {
    $message = "Missing required artifacts: $($missingRequired -join ', ')"
}

# Count artifacts
$totalFound = 0
$requiredFound = 0
$optionalFound = 0

foreach ($key in $artifacts.Keys) {
    if (-not [string]::IsNullOrEmpty($artifacts[$key])) {
        $totalFound++
        if ($key -in @('spec', 'design', 'tasks')) {
            $requiredFound++
        } else {
            $optionalFound++
        }
    }
}

# Build result object
$result = @{
    success          = $success
    message          = $message
    featureDirectory = $FeatureDirectory
    artifacts        = @{
        required = @{
            spec   = $artifacts.spec
            design = $artifacts.design
            tasks  = $artifacts.tasks
        }
        optional = @{
            groundRules  = $artifacts.groundRules
            architecture = $artifacts.architecture
            standards    = $artifacts.standards
        }
    }
    summary          = @{
        totalFound      = $totalFound
        requiredFound   = $requiredFound
        optionalFound   = $optionalFound
        missingRequired = $missingRequired
    }
}

# Output result
if ($Json) {
    $result | ConvertTo-Json -Depth 10
} else {
    Write-Host "`nProject Consistency Analysis - Prerequisite Check" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host "`nFeature Directory: $FeatureDirectory" -ForegroundColor White
    Write-Host "`nStatus: " -NoNewline
    if ($success) {
        Write-Host "SUCCESS" -ForegroundColor Green
    } else {
        Write-Host "INCOMPLETE" -ForegroundColor Yellow
    }
    Write-Host "Message: $message`n" -ForegroundColor White
    
    Write-Host "Required Artifacts:" -ForegroundColor Yellow
    Write-Host "  spec.md       : " -NoNewline
    if ($artifacts.spec) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                  $($artifacts.spec)" -ForegroundColor Gray
    } else {
        Write-Host "MISSING" -ForegroundColor Red
    }
    
    Write-Host "  design.md     : " -NoNewline
    if ($artifacts.design) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                  $($artifacts.design)" -ForegroundColor Gray
    } else {
        Write-Host "MISSING" -ForegroundColor Red
    }
    
    Write-Host "  tasks.md      : " -NoNewline
    if ($artifacts.tasks) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                  $($artifacts.tasks)" -ForegroundColor Gray
    } else {
        Write-Host "MISSING" -ForegroundColor Red
    }
    
    Write-Host "`nOptional Artifacts:" -ForegroundColor Yellow
    Write-Host "  ground-rules.md : " -NoNewline
    if ($artifacts.groundRules) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                    $($artifacts.groundRules)" -ForegroundColor Gray
    } else {
        Write-Host "NOT FOUND" -ForegroundColor Gray
    }
    
    Write-Host "  architecture.md : " -NoNewline
    if ($artifacts.architecture) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                    $($artifacts.architecture)" -ForegroundColor Gray
    } else {
        Write-Host "NOT FOUND" -ForegroundColor Gray
    }
    
    Write-Host "  standards.md    : " -NoNewline
    if ($artifacts.standards) {
        Write-Host "FOUND" -ForegroundColor Green
        Write-Host "                    $($artifacts.standards)" -ForegroundColor Gray
    } else {
        Write-Host "NOT FOUND" -ForegroundColor Gray
    }
    
    Write-Host "`nSummary:" -ForegroundColor Cyan
    Write-Host "  Total Found     : $totalFound" -ForegroundColor White
    Write-Host "  Required Found  : $requiredFound / 3" -ForegroundColor White
    Write-Host "  Optional Found  : $optionalFound / 3" -ForegroundColor White
    
    if ($missingRequired.Count -gt 0) {
        Write-Host "`nMissing Required: $($missingRequired -join ', ')" -ForegroundColor Red
    }
    
    Write-Host "`n" -NoNewline
}

exit 0
