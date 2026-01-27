# check-architecture.ps1 - Check architecture documentation and supporting files (Windows)
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File check-architecture.ps1 [-Json]
#   powershell -ExecutionPolicy Bypass -File check-architecture.ps1 -ArchFile C:\path\to\architecture.md
#
# Options:
#   -Json          Output results as JSON
#   -ArchFile      Specify architecture file explicitly
#
# Author: Dau Quang Thanh

[CmdletBinding()]
param(
    [switch]$Json,
    [string]$ArchFile = ""
)

$ErrorActionPreference = 'Stop'

# Variables
$AvailableDocs = @()
$AdrCount = 0
$SpecsCount = 0
$GroundRulesFound = $false
$DiagramsFound = 0

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

# Function to find architecture file
function Find-ArchitectureFile {
    $currentDir = Get-Location
    
    # Check docs\architecture.md first (standard location)
    $docsArch = Join-Path $currentDir "docs\architecture.md"
    if (Test-Path $docsArch) {
        return $docsArch
    }
    
    # Check current directory
    $currentArch = Join-Path $currentDir "architecture.md"
    if (Test-Path $currentArch) {
        return $currentArch
    }
    
    # Check .phoenix\docs\ (alternative location)
    $phoenixArch = Join-Path $currentDir ".phoenix\docs\architecture.md"
    if (Test-Path $phoenixArch) {
        return $phoenixArch
    }
    
    return $null
}

# Function to count Mermaid diagrams
function Count-MermaidDiagrams {
    param([string]$FilePath)
    
    try {
        $content = Get-Content -Path $FilePath -Raw
        $matches = [regex]::Matches($content, '(?m)^```mermaid')
        return $matches.Count
    }
    catch {
        return 0
    }
}

# Function to scan supporting documents
function Scan-SupportingDocs {
    param([string]$RepoRoot)
    
    $script:AvailableDocs = @()
    $script:AdrCount = 0
    $script:SpecsCount = 0
    $script:GroundRulesFound = $false
    
    # Add architecture.md (already confirmed to exist)
    $script:AvailableDocs += "architecture.md"
    
    # Check for ADR files
    $adrDir = Join-Path $RepoRoot "docs\adr"
    if (Test-Path $adrDir) {
        $adrFiles = Get-ChildItem -Path $adrDir -Filter "*.md" -File
        $script:AdrCount = $adrFiles.Count
        if ($adrFiles.Count -gt 0) {
            $script:AvailableDocs += "docs/adr/ ($($adrFiles.Count) ADRs)"
        }
    }
    
    # Check for ground-rules.md
    $groundRulesPath = Join-Path $RepoRoot "memory\ground-rules.md"
    if (Test-Path $groundRulesPath) {
        $script:GroundRulesFound = $true
        $script:AvailableDocs += "docs/ground-rules.md"
    }
    
    # Check for feature specifications
    $specsDir = Join-Path $RepoRoot "specs"
    if (Test-Path $specsDir) {
        $specFiles = Get-ChildItem -Path $specsDir -Filter "spec.md" -File -Recurse
        $script:SpecsCount = $specFiles.Count
        if ($specFiles.Count -gt 0) {
            $script:AvailableDocs += "specs/ ($($specFiles.Count) specifications)"
        }
    }
    
    # Check for architecture-overview.md
    $overviewPath = Join-Path $RepoRoot "docs\architecture-overview.md"
    if (Test-Path $overviewPath) {
        $script:AvailableDocs += "architecture-overview.md"
    }
    
    # Check for deployment-guide.md
    $deploymentPath = Join-Path $RepoRoot "docs\deployment-guide.md"
    if (Test-Path $deploymentPath) {
        $script:AvailableDocs += "deployment-guide.md"
    }
}

# Function to output JSON
function Write-JsonOutput {
    param(
        [bool]$Success,
        [string]$ArchFile
    )
    
    if ($Success) {
        $result = @{
            success = $true
            architecture_file = $ArchFile
            available_docs = $AvailableDocs
            adr_count = $AdrCount
            specs_count = $SpecsCount
            ground_rules_found = $GroundRulesFound
            diagrams_found = $DiagramsFound
        }
        
        $result | ConvertTo-Json -Depth 10
    } else {
        $currentDir = Get-Location
        $result = @{
            success = $false
            error = "No architecture.md found"
            message = "Could not find architecture.md in standard locations"
            searched_paths = @(
                (Join-Path $currentDir "docs\architecture.md"),
                (Join-Path $currentDir "architecture.md"),
                (Join-Path $currentDir ".phoenix\docs\architecture.md")
            )
        }
        
        $result | ConvertTo-Json -Depth 10
    }
}

# Function to output human-readable format
function Write-HumanOutput {
    param(
        [bool]$Success,
        [string]$ArchFile
    )
    
    if ($Success) {
        Write-Host "✓ Architecture file: $ArchFile" -ForegroundColor Green
        Write-Host ""
        Write-Host "✓ Supporting documents found ($($AvailableDocs.Count)):" -ForegroundColor Green
        foreach ($doc in $AvailableDocs) {
            Write-Host "  • $doc"
        }
        
        Write-Host ""
        Write-Host "✓ Architecture statistics:" -ForegroundColor Green
        Write-Host "  • ADR files: $AdrCount"
        Write-Host "  • Feature specifications: $SpecsCount"
        Write-Host "  • Ground rules: $(if ($GroundRulesFound) { 'Yes' } else { 'No' })"
        Write-Host "  • Mermaid diagrams: $DiagramsFound"
        
        if ($AdrCount -lt 3) {
            Write-Host ""
            Write-Host "⚠ Warning: Only $AdrCount ADR(s) found. Recommended minimum: 3-5 ADRs" -ForegroundColor Yellow
        }
        
        if (-not $GroundRulesFound) {
            Write-Host ""
            Write-Host "⚠ Warning: Ground rules not found. Alignment check will be skipped." -ForegroundColor Yellow
        }
    } else {
        $currentDir = Get-Location
        Write-Host "✗ Error: No architecture.md found" -ForegroundColor Red
        Write-Host ""
        Write-Host "Could not find architecture.md in standard locations"
        Write-Host ""
        Write-Host "Searched paths:"
        Write-Host "  • $(Join-Path $currentDir 'docs\architecture.md')"
        Write-Host "  • $(Join-Path $currentDir 'architecture.md')"
        Write-Host "  • $(Join-Path $currentDir '.phoenix\docs\architecture.md')"
    }
}

# Main execution
try {
    # Find repository root
    $repoRoot = Find-RepoRoot (Get-Location).Path
    if ($repoRoot) {
        Set-Location $repoRoot
    } else {
        $repoRoot = (Get-Location).Path
    }
    
    # Find or use specified architecture file
    if ($ArchFile) {
        if (Test-Path $ArchFile) {
            $foundFile = $ArchFile
        } else {
            if ($Json) {
                Write-JsonOutput -Success $false -ArchFile ""
            } else {
                Write-HumanOutput -Success $false -ArchFile ""
            }
            exit 1
        }
    } else {
        $foundFile = Find-ArchitectureFile
        if (-not $foundFile) {
            if ($Json) {
                Write-JsonOutput -Success $false -ArchFile ""
            } else {
                Write-HumanOutput -Success $false -ArchFile ""
            }
            exit 1
        }
    }
    
    # Count Mermaid diagrams
    $DiagramsFound = Count-MermaidDiagrams -FilePath $foundFile
    
    # Scan supporting documents
    Scan-SupportingDocs -RepoRoot $repoRoot
    
    # Output results
    if ($Json) {
        Write-JsonOutput -Success $true -ArchFile $foundFile
    } else {
        Write-HumanOutput -Success $true -ArchFile $foundFile
    }
    
    # Exit with warning if ADR count is low
    if ($AdrCount -lt 3) {
        exit 2
    }
    
    exit 0
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
