# check-review-prerequisites.ps1 - Check code review prerequisites and discover implementation artifacts
# Usage: powershell -ExecutionPolicy Bypass -File check-review-prerequisites.ps1 [-Json]

[CmdletBinding()]
param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

# Determine script and project root directories
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..") | Select-Object -ExpandProperty Path

# Feature discovery logic
function Find-FeatureDir {
    $searchPaths = @("specs", "features", "requirements", "docs\specs")
    
    foreach ($basePath in $searchPaths) {
        $fullPath = Join-Path $RepoRoot $basePath
        if (Test-Path $fullPath) {
            # Find directories containing spec.md or design.md
            $specFiles = Get-ChildItem -Path $fullPath -Filter "spec.md" -Recurse -File -ErrorAction SilentlyContinue |
                         Select-Object -First 1
            
            if ($null -eq $specFiles) {
                $specFiles = Get-ChildItem -Path $fullPath -Filter "design.md" -Recurse -File -ErrorAction SilentlyContinue |
                             Select-Object -First 1
            }
            
            if ($specFiles) {
                $featureDir = Split-Path -Parent $specFiles.FullName
                return $featureDir
            }
        }
    }
    
    return $null
}

# Discover implementation files (exclude tests, specs, docs)
function Find-ImplementationFiles {
    $implFiles = @()
    
    # Common source directories
    $srcDirs = @("src", "lib", "app", "components", "services", "controllers", "models")
    
    foreach ($srcDir in $srcDirs) {
        $srcPath = Join-Path $RepoRoot $srcDir
        if (Test-Path $srcPath) {
            $files = Get-ChildItem -Path $srcPath -Recurse -File -ErrorAction SilentlyContinue |
                     Where-Object { 
                         $_.Extension -match '\.(ts|js|tsx|jsx|py|java|go|rs|cpp|c)$' -and
                         $_.FullName -notmatch '(test|spec|node_modules|coverage|dist|build)'
                     }
            
            $implFiles += $files | Select-Object -ExpandProperty FullName
        }
    }
    
    return $implFiles
}

# Discover test files
function Find-TestFiles {
    $testFiles = @()
    
    # Common test directories
    $testDirs = @("tests", "test", "__tests__", "spec")
    
    foreach ($testDir in $testDirs) {
        $testPath = Join-Path $RepoRoot $testDir
        if (Test-Path $testPath) {
            $files = Get-ChildItem -Path $testPath -Recurse -File -ErrorAction SilentlyContinue |
                     Where-Object { $_.Name -match '\.(test|spec)\.' }
            
            $testFiles += $files | Select-Object -ExpandProperty FullName
        }
    }
    
    # Also check for test files in src directories
    $srcPath = Join-Path $RepoRoot "src"
    if (Test-Path $srcPath) {
        $files = Get-ChildItem -Path $srcPath -Recurse -File -ErrorAction SilentlyContinue |
                 Where-Object { $_.Name -match '\.(test|spec)\.' }
        
        $testFiles += $files | Select-Object -ExpandProperty FullName
    }
    
    return $testFiles
}

# Check for available documentation
function Get-AvailableDocs {
    param([string]$FeatureDir)
    
    $docs = @()
    
    if (Test-Path (Join-Path $FeatureDir "spec.md")) { $docs += "spec.md" }
    if (Test-Path (Join-Path $FeatureDir "design.md")) { $docs += "design.md" }
    if (Test-Path (Join-Path $FeatureDir "tasks.md")) { $docs += "tasks.md" }
    if (Test-Path (Join-Path $FeatureDir "data-model.md")) { $docs += "data-model.md" }
    if (Test-Path (Join-Path $FeatureDir "research.md")) { $docs += "research.md" }
    if (Test-Path (Join-Path $FeatureDir "contracts")) { $docs += "contracts/" }
    if (Test-Path (Join-Path $FeatureDir "checklists")) { $docs += "checklists/" }
    
    # Product-level docs
    if (Test-Path (Join-Path $RepoRoot "docs\architecture.md")) { $docs += "docs/architecture.md" }
    if (Test-Path (Join-Path $RepoRoot "docs\standards.md")) { $docs += "docs/standards.md" }
    
    return $docs
}

# Check checklist status
function Get-ChecklistStatus {
    param([string]$FeatureDir)
    
    $checklistsDir = Join-Path $FeatureDir "checklists"
    
    if (-not (Test-Path $checklistsDir)) {
        return @{
            Status = "no_checklists"
            Details = @()
        }
    }
    
    $allPassed = $true
    $checklistDetails = @()
    
    $checklistFiles = Get-ChildItem -Path $checklistsDir -Filter "*.md" -File -ErrorAction SilentlyContinue
    
    foreach ($checklistFile in $checklistFiles) {
        $filename = $checklistFile.Name
        $content = Get-Content $checklistFile.FullName -ErrorAction SilentlyContinue
        
        # Count total, completed, and incomplete items
        $totalPattern = '^\s*-\s+\[([ Xx])\]'
        $completedPattern = '^\s*-\s+\[([Xx])\]'
        
        $totalItems = ($content | Where-Object { $_ -match $totalPattern }).Count
        $completedItems = ($content | Where-Object { $_ -match $completedPattern }).Count
        $incompleteItems = $totalItems - $completedItems
        
        if ($incompleteItems -gt 0) {
            $allPassed = $false
        }
        
        $status = if ($incompleteItems -eq 0) { "PASS" } else { "FAIL" }
        
        $checklistDetails += @{
            name = $filename
            total = $totalItems
            completed = $completedItems
            incomplete = $incompleteItems
            status = $status
        }
    }
    
    if ($checklistDetails.Count -eq 0) {
        return @{
            Status = "no_checklists"
            Details = @()
        }
    }
    
    $overallStatus = if ($allPassed) { "all_passed" } else { "some_incomplete" }
    
    return @{
        Status = $overallStatus
        Details = $checklistDetails
    }
}

# Main execution
function Main {
    # Find feature directory
    $featureDir = Find-FeatureDir
    
    if (-not $featureDir) {
        if ($Json) {
            $result = @{
                success = $false
                error = "No feature directory with spec.md or design.md found. Expected in: specs/, features/, requirements/, docs/specs/"
            }
            $result | ConvertTo-Json -Depth 10
        } else {
            Write-Host "❌ Error: No feature directory with spec.md or design.md found." -ForegroundColor Red
            Write-Host "Expected locations: specs/, features/, requirements/, docs/specs/"
        }
        exit 1
    }
    
    # Check for required documents
    $hasSpec = Test-Path (Join-Path $featureDir "spec.md")
    $hasDesign = Test-Path (Join-Path $featureDir "design.md")
    
    if (-not $hasSpec -or -not $hasDesign) {
        if ($Json) {
            $result = @{
                success = $false
                error = "Missing required documents. spec.md and design.md are required for code review."
            }
            $result | ConvertTo-Json -Depth 10
        } else {
            Write-Host "❌ Error: Missing required documents in: $featureDir" -ForegroundColor Red
            Write-Host "Required: spec.md and design.md"
        }
        exit 1
    }
    
    # Discover implementation files
    $implementationFiles = Find-ImplementationFiles
    
    # Discover test files
    $testFiles = Find-TestFiles
    
    # Check available documentation
    $availableDocs = Get-AvailableDocs -FeatureDir $featureDir
    
    # Check checklists
    $checklistResult = Get-ChecklistStatus -FeatureDir $featureDir
    
    # Check for architecture and standards
    $architectureAvailable = Test-Path (Join-Path $RepoRoot "docs\architecture.md")
    $standardsAvailable = Test-Path (Join-Path $RepoRoot "docs\standards.md")
    
    # Output results
    if ($Json) {
        $result = @{
            success = $true
            feature_dir = $featureDir
            available_docs = $availableDocs
            implementation_files = $implementationFiles
            test_files = $testFiles
            checklist_status = $checklistResult.Status
            checklist_details = $checklistResult.Details
            architecture_available = $architectureAvailable
            standards_available = $standardsAvailable
        }
        $result | ConvertTo-Json -Depth 10
    } else {
        Write-Host "✅ Code Review Prerequisites Check" -ForegroundColor Green
        Write-Host ""
        Write-Host "Feature Directory: $featureDir"
        Write-Host ""
        Write-Host "Available Documentation:"
        foreach ($doc in $availableDocs) {
            Write-Host "  - $doc"
        }
        Write-Host ""
        Write-Host "Implementation Files Found: $($implementationFiles.Count)"
        Write-Host "Test Files Found: $($testFiles.Count)"
        Write-Host ""
        Write-Host "Checklist Status: $($checklistResult.Status)"
        Write-Host "Architecture Available: $architectureAvailable"
        Write-Host "Standards Available: $standardsAvailable"
    }
}

Main
