# check-prerequisites.ps1 - Check prerequisites and identify feature directory (Windows)
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File check-prerequisites.ps1 [-Json]
#   powershell -ExecutionPolicy Bypass -File check-prerequisites.ps1 -FeatureDir C:\path\to\feature
#
# Options:
#   -Json          Output results as JSON
#   -FeatureDir    Specify feature directory explicitly
#
# Author: Dau Quang Thanh

[CmdletBinding()]
param(
    [switch]$Json,
    [string]$FeatureDir = ""
)

$ErrorActionPreference = 'Stop'

# Configuration
$REQUIRED_DOCS = @("design.md", "spec.md")
$OPTIONAL_DOCS = @("data-model.md", "research.md", "quickstart.md", "architecture.md")
$OPTIONAL_DIRS = @("contracts")

# Variables
$AvailableDocs = @()
$MissingRequired = @()

# Function to check if directory is a feature directory
function Test-FeatureDir {
    param([string]$Path)
    
    $hasDesign = Test-Path (Join-Path $Path "design.md")
    $hasSpec = Test-Path (Join-Path $Path "spec.md")
    
    return ($hasDesign -or $hasSpec)
}

# Function to find feature directory
function Find-FeatureDir {
    $currentDir = Get-Location
    
    # Check current directory first
    if (Test-FeatureDir $currentDir) {
        return $currentDir.Path
    }
    
    # Check .sunrise/features/* subdirectories
    $sunriseFeaturesDir = Join-Path $currentDir ".sunrise\features"
    if (Test-Path $sunriseFeaturesDir) {
        $dirs = Get-ChildItem -Path $sunriseFeaturesDir -Directory
        foreach ($dir in $dirs) {
            if (Test-FeatureDir $dir.FullName) {
                return $dir.FullName
            }
        }
    }
    
    # Check features/* subdirectories
    $featuresDir = Join-Path $currentDir "features"
    if (Test-Path $featuresDir) {
        $dirs = Get-ChildItem -Path $featuresDir -Directory
        foreach ($dir in $dirs) {
            if (Test-FeatureDir $dir.FullName) {
                return $dir.FullName
            }
        }
    }
    
    # Check docs/features/* subdirectories
    $docsFeaturesDir = Join-Path $currentDir "docs\features"
    if (Test-Path $docsFeaturesDir) {
        $dirs = Get-ChildItem -Path $docsFeaturesDir -Directory
        foreach ($dir in $dirs) {
            if (Test-FeatureDir $dir.FullName) {
                return $dir.FullName
            }
        }
    }
    
    return $null
}

# Function to find repository root
function Find-RepoRoot {
    param([string]$StartPath)
    
    $current = $StartPath
    while ($current -and $current -ne [System.IO.Path]::GetPathRoot($current)) {
        if (Test-Path (Join-Path $current ".git")) {
            return $current
        }
        $current = Split-Path $current -Parent
    }
    
    return $null
}

# Function to scan documents
function Scan-Documents {
    param([string]$FeatureDir)
    
    $script:AvailableDocs = @()
    $script:MissingRequired = @()
    
    # Check required documents
    foreach ($doc in $REQUIRED_DOCS) {
        $docPath = Join-Path $FeatureDir $doc
        if (Test-Path $docPath) {
            $script:AvailableDocs += $doc
        } else {
            $script:MissingRequired += $doc
        }
    }
    
    # Check optional documents
    foreach ($doc in $OPTIONAL_DOCS) {
        $docPath = Join-Path $FeatureDir $doc
        if (Test-Path $docPath) {
            $script:AvailableDocs += $doc
        }
    }
    
    # Check optional directories
    foreach ($dirName in $OPTIONAL_DIRS) {
        $dirPath = Join-Path $FeatureDir $dirName
        if (Test-Path $dirPath) {
            $fileCount = (Get-ChildItem -Path $dirPath -Filter "*.md" -File).Count
            if ($fileCount -gt 0) {
                $script:AvailableDocs += "$dirName/ ($fileCount files)"
            }
        }
    }
    
    # Check product-level architecture.md
    $repoRoot = Find-RepoRoot $FeatureDir
    if ($repoRoot) {
        $archPath = Join-Path $repoRoot "docs\architecture.md"
        if (Test-Path $archPath) {
            $script:AvailableDocs += "docs/architecture.md"
        }
    }
}

# Function to output JSON
function Write-JsonOutput {
    param(
        [bool]$Success,
        [string]$FeatureDir
    )
    
    if ($Success) {
        $result = @{
            success = $true
            feature_dir = $FeatureDir
            available_docs = $AvailableDocs
            missing_required = $MissingRequired
        }
        
        if ($MissingRequired.Count -gt 0) {
            $result.warning = "Missing required documents: $($MissingRequired -join ', ')"
        }
        
        $result | ConvertTo-Json -Depth 10
    } else {
        $currentDir = Get-Location
        $result = @{
            success = $false
            error = "No feature directory found"
            message = "Could not find feature directory. Looking for directory containing design.md or spec.md"
            searched_paths = @(
                $currentDir.Path,
                (Join-Path $currentDir ".sunrise\features"),
                (Join-Path $currentDir "features"),
                (Join-Path $currentDir "docs\features")
            )
        }
        
        $result | ConvertTo-Json -Depth 10
    }
}

# Function to output human-readable format
function Write-HumanOutput {
    param(
        [bool]$Success,
        [string]$FeatureDir
    )
    
    if ($Success) {
        Write-Host "✓ Feature directory: $FeatureDir" -ForegroundColor Green
        Write-Host ""
        Write-Host "✓ Available documents ($($AvailableDocs.Count)):" -ForegroundColor Green
        foreach ($doc in $AvailableDocs) {
            Write-Host "  • $doc"
        }
        
        if ($MissingRequired.Count -gt 0) {
            Write-Host ""
            Write-Host "⚠ Missing required documents:" -ForegroundColor Yellow
            foreach ($doc in $MissingRequired) {
                Write-Host "  • $doc"
            }
        }
    } else {
        $currentDir = Get-Location
        Write-Host "✗ Error: No feature directory found" -ForegroundColor Red
        Write-Host ""
        Write-Host "Could not find feature directory. Looking for directory containing design.md or spec.md"
        Write-Host ""
        Write-Host "Searched paths:"
        Write-Host "  • $($currentDir.Path)"
        Write-Host "  • $(Join-Path $currentDir '.sunrise\features')"
        Write-Host "  • $(Join-Path $currentDir 'features')"
        Write-Host "  • $(Join-Path $currentDir 'docs\features')"
    }
}

# Main execution
try {
    # Find or use specified feature directory
    if ($FeatureDir) {
        $foundDir = $FeatureDir
    } else {
        $foundDir = Find-FeatureDir
        if (-not $foundDir) {
            if ($Json) {
                Write-JsonOutput -Success $false -FeatureDir ""
            } else {
                Write-HumanOutput -Success $false -FeatureDir ""
            }
            exit 1
        }
    }
    
    # Scan documents
    Scan-Documents -FeatureDir $foundDir
    
    # Output results
    if ($Json) {
        Write-JsonOutput -Success $true -FeatureDir $foundDir
    } else {
        Write-HumanOutput -Success $true -FeatureDir $foundDir
    }
    
    # Exit with error if missing required documents
    if ($MissingRequired.Count -gt 0) {
        exit 1
    }
    
    exit 0
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
