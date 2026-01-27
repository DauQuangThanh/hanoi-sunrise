# check-implementation.ps1 - Check implementation prerequisites and analyze tasks.md
# Usage: powershell -ExecutionPolicy Bypass -File check-implementation.ps1 [-Json]

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
            # Find directories containing tasks.md
            $tasksFiles = Get-ChildItem -Path $fullPath -Filter "tasks.md" -Recurse -File -ErrorAction SilentlyContinue
            
            foreach ($tasksFile in $tasksFiles) {
                $featureDir = Split-Path -Parent $tasksFile.FullName
                return $featureDir
            }
        }
    }
    
    return $null
}

# Count tasks in tasks.md
function Count-Tasks {
    param([string]$TasksFile)
    
    if (-not (Test-Path $TasksFile)) {
        return 0
    }
    
    # Count lines that match task pattern: - [ ] or - [X] or - [x]
    $content = Get-Content $TasksFile -ErrorAction SilentlyContinue
    $taskPattern = '^\s*-\s+\[([ Xx])\]'
    $tasks = $content | Where-Object { $_ -match $taskPattern }
    
    return $tasks.Count
}

# Check for available documentation
function Get-AvailableDocs {
    param([string]$FeatureDir)
    
    $docs = @()
    
    if (Test-Path (Join-Path $FeatureDir "tasks.md")) { $docs += "tasks.md" }
    if (Test-Path (Join-Path $FeatureDir "design.md")) { $docs += "design.md" }
    if (Test-Path (Join-Path $FeatureDir "spec.md")) { $docs += "spec.md" }
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
                error = "No feature directory with tasks.md found. Expected in: specs/, features/, requirements/, docs/specs/"
            }
            $result | ConvertTo-Json -Depth 10
        } else {
            Write-Host "❌ Error: No feature directory with tasks.md found." -ForegroundColor Red
            Write-Host "Expected locations: specs/, features/, requirements/, docs/specs/"
        }
        exit 1
    }
    
    $tasksFile = Join-Path $featureDir "tasks.md"
    
    # Verify tasks.md exists
    if (-not (Test-Path $tasksFile)) {
        if ($Json) {
            $result = @{
                success = $false
                error = "tasks.md not found in feature directory: $featureDir"
            }
            $result | ConvertTo-Json -Depth 10
        } else {
            Write-Host "❌ Error: tasks.md not found in: $featureDir" -ForegroundColor Red
        }
        exit 1
    }
    
    # Count tasks
    $taskCount = Count-Tasks -TasksFile $tasksFile
    
    # Check available documentation
    $availableDocs = Get-AvailableDocs -FeatureDir $featureDir
    
    # Check checklists
    $checklistResult = Get-ChecklistStatus -FeatureDir $featureDir
    
    # Output results
    if ($Json) {
        $result = @{
            success = $true
            feature_dir = $featureDir
            tasks_file = $tasksFile
            available_docs = $availableDocs
            task_count = $taskCount
            checklist_status = $checklistResult.Status
            checklist_details = $checklistResult.Details
        }
        $result | ConvertTo-Json -Depth 10
    } else {
        Write-Host "✅ Implementation Prerequisites Check" -ForegroundColor Green
        Write-Host ""
        Write-Host "Feature Directory: $featureDir"
        Write-Host "Tasks File: $tasksFile"
        Write-Host "Task Count: $taskCount"
        Write-Host ""
        Write-Host "Available Documentation:"
        foreach ($doc in $availableDocs) {
            Write-Host "  - $doc"
        }
        Write-Host ""
        Write-Host "Checklist Status: $($checklistResult.Status)"
        
        if ($checklistResult.Status -eq "some_incomplete") {
            Write-Host ""
            Write-Host "⚠️  Some checklists have incomplete items. Review before proceeding." -ForegroundColor Yellow
        } elseif ($checklistResult.Status -eq "all_passed") {
            Write-Host ""
            Write-Host "✅ All checklists passed." -ForegroundColor Green
        }
    }
}

Main
