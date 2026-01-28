# validate-skill.ps1 - Agent Skill Validator (PowerShell/Windows)
#
# Usage:
#   .\validate-skill.ps1 -Path <skill-directory>
#   .\validate-skill.ps1 -Path .\skills\my-skill
#   .\validate-skill.ps1 -Path . (from within skill directory)
#
# Author: Dau Quang Thanh
# License: MIT

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

$ErrorActionPreference = 'Continue'

# Counters
$script:ErrorCount = 0
$script:WarningCount = 0
$script:InfoCount = 0

# Print functions
function Write-ValidationError {
    param([string]$Message)
    Write-Host "✗ ERROR: $Message" -ForegroundColor Red
    $script:ErrorCount++
}

function Write-ValidationWarning {
    param([string]$Message)
    Write-Host "⚠ WARNING: $Message" -ForegroundColor Yellow
    $script:WarningCount++
}

function Write-ValidationInfo {
    param([string]$Message)
    Write-Host "ℹ INFO: $Message" -ForegroundColor Blue
    $script:InfoCount++
}

function Write-ValidationSuccess {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

# Validate skill name
function Test-SkillName {
    param(
        [string]$Name,
        [string]$DirectoryName
    )
    
    # Length check
    if ($Name.Length -lt 1 -or $Name.Length -gt 64) {
        Write-ValidationError "Skill name must be 1-64 characters (current: $($Name.Length))"
    }
    
    # Only lowercase letters, numbers, and hyphens
    if ($Name -notmatch '^[a-z0-9-]+$') {
        Write-ValidationError "Skill name must only contain lowercase letters, numbers, and hyphens"
    }
    
    # Cannot start or end with hyphen
    if ($Name -match '^-') {
        Write-ValidationError "Skill name cannot start with a hyphen"
    }
    
    if ($Name -match '-$') {
        Write-ValidationError "Skill name cannot end with a hyphen"
    }
    
    # No consecutive hyphens
    if ($Name -match '--') {
        Write-ValidationError "Skill name cannot contain consecutive hyphens"
    }
    
    # Must match directory name
    if ($Name -ne $DirectoryName) {
        Write-ValidationError "Skill name '$Name' must match directory name '$DirectoryName'"
    }
}

# Validate description
function Test-Description {
    param([string]$Description)
    
    $len = $Description.Length
    
    # Length check
    if ([string]::IsNullOrEmpty($Description)) {
        Write-ValidationError "Description is required"
        return
    }
    
    if ($len -lt 1 -or $len -gt 1024) {
        Write-ValidationError "Description must be 1-1024 characters (current: $len)"
    }
    
    # Quality checks
    if ($len -lt 50) {
        Write-ValidationWarning "Description is very short. Consider adding more details about what, when, and keywords."
    }
    
    if ($len -lt 100) {
        Write-ValidationInfo "Optimal description length is 150-300 characters for better skill discovery"
    }
    
    # Check for formula components
    $descLower = $Description.ToLower()
    
    if ($descLower -notmatch '(extract|analyze|generate|create|process|transform|convert)') {
        Write-ValidationWarning "Description should include specific actions (extract, analyze, generate, etc.)"
    }
    
    if ($descLower -notmatch '(use when|when)') {
        Write-ValidationWarning "Description should include 'Use when' to clarify activation scenarios"
    }
    
    if ($descLower -notmatch 'mention') {
        $wordCount = ($Description -split '\s+').Count
        if ($wordCount -le 15) {
            Write-ValidationWarning "Description should mention keywords users might say"
        }
    }
}

# Extract frontmatter field
function Get-FrontmatterField {
    param(
        [string]$FilePath,
        [string]$FieldName
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Extract YAML frontmatter
    if ($content -match '(?ms)^---\r?\n(.*?)\r?\n---') {
        $frontmatter = $matches[1]
        
        # Look for the field
        if ($frontmatter -match "(?m)^$FieldName:\s*(.+)$") {
            $value = $matches[1].Trim()
            # Remove quotes if present
            $value = $value -replace '^["'']|["'']$', ''
            return $value
        }
    }
    
    return $null
}

# Validate file structure
function Test-FileStructure {
    param([string]$SkillDir)
    
    # Check SKILL.md exists
    $skillMdPath = Join-Path $SkillDir "SKILL.md"
    if (-not (Test-Path $skillMdPath)) {
        Write-ValidationError "SKILL.md not found. This file is required."
        return $false
    }
    
    Write-ValidationSuccess "✓ Found SKILL.md"
    
    # Check for optional directories
    $scriptsDir = Join-Path $SkillDir "scripts"
    if (Test-Path $scriptsDir) {
        Write-ValidationInfo "Found scripts/ directory"
        
        # Check for cross-platform scripts
        $hasPython = (Get-ChildItem -Path $scriptsDir -Filter "*.py" -ErrorAction SilentlyContinue).Count -gt 0
        $hasBash = (Get-ChildItem -Path $scriptsDir -Filter "*.sh" -ErrorAction SilentlyContinue).Count -gt 0
        $hasPowerShell = (Get-ChildItem -Path $scriptsDir -Filter "*.ps1" -ErrorAction SilentlyContinue).Count -gt 0
        
        if ($hasPython) {
            Write-ValidationInfo "Found Python scripts (cross-platform)"
        }
        
        if (-not $hasPython) {
            if ($hasBash -and -not $hasPowerShell) {
                Write-ValidationWarning "Found Bash scripts but no PowerShell scripts. Consider adding .ps1 versions for Windows users."
            } elseif ($hasPowerShell -and -not $hasBash) {
                Write-ValidationWarning "Found PowerShell scripts but no Bash scripts. Consider adding .sh versions for Unix users."
            }
        }
    }
    
    $referencesDir = Join-Path $SkillDir "references"
    if (Test-Path $referencesDir) {
        Write-ValidationInfo "Found references/ directory"
    }
    
    $templatesDir = Join-Path $SkillDir "templates"
    if (Test-Path $templatesDir) {
        Write-ValidationInfo "Found templates/ directory"
    }
    
    $assetsDir = Join-Path $SkillDir "assets"
    if (Test-Path $assetsDir) {
        Write-ValidationInfo "Found assets/ directory"
    }
    
    return $true
}

# Validate SKILL.md size
function Test-FileSize {
    param([string]$FilePath)
    
    $lineCount = (Get-Content -Path $FilePath).Count
    
    if ($lineCount -gt 500) {
        Write-ValidationWarning "SKILL.md has $lineCount lines. Recommendation: Keep under 500 lines and move detailed content to references/"
    } elseif ($lineCount -gt 400) {
        Write-ValidationInfo "SKILL.md has $lineCount lines. Consider moving detailed content to references/ if it grows more."
    }
}

# Check frontmatter exists
function Test-Frontmatter {
    param([string]$FilePath)
    
    $content = Get-Content -Path $FilePath -Raw
    
    if ($content -notmatch '^---\r?\n') {
        Write-ValidationError "SKILL.md must have valid YAML frontmatter delimited by ---"
        return $false
    }
    
    if ($content -notmatch '(?ms)^---\r?\n.*?\r?\n---') {
        Write-ValidationError "SKILL.md must have valid YAML frontmatter delimited by ---"
        return $false
    }
    
    return $true
}

# Main validation
try {
    # Validate path
    if (-not (Test-Path $Path)) {
        Write-Error "Path does not exist: $Path"
        exit 1
    }
    
    # Get absolute path and directory name
    $skillPath = (Resolve-Path $Path).Path
    $skillName = Split-Path $skillPath -Leaf
    
    Write-Host ""
    Write-Host "Validating skill: $skillName"
    Write-Host "Location: $skillPath"
    Write-Host "------------------------------------------------------------"
    Write-Host ""
    
    # Validate file structure
    $hasSkillMd = Test-FileStructure -SkillDir $skillPath
    
    # If SKILL.md doesn't exist, stop here
    if (-not $hasSkillMd) {
        Write-Host ""
        if ($script:ErrorCount -gt 0) {
            Write-Host "❌ VALIDATION FAILED" -ForegroundColor Red
            Write-Host "Found $($script:ErrorCount) error(s)" -ForegroundColor Red
        }
        exit 1
    }
    
    $skillMdPath = Join-Path $skillPath "SKILL.md"
    
    # Check frontmatter
    if (-not (Test-Frontmatter -FilePath $skillMdPath)) {
        Write-Host ""
        Write-Host "❌ VALIDATION FAILED" -ForegroundColor Red
        Write-Host "Found $($script:ErrorCount) error(s)" -ForegroundColor Red
        exit 1
    }
    
    # Validate SKILL.md size
    Test-FileSize -FilePath $skillMdPath
    
    # Extract and validate name
    Write-Host ""
    Write-Host "Checking frontmatter fields..."
    
    $name = Get-FrontmatterField -FilePath $skillMdPath -FieldName "name"
    if ($name) {
        Write-ValidationSuccess "✓ Found name: $name"
        Test-SkillName -Name $name -DirectoryName $skillName
    } else {
        Write-ValidationError "Missing required field: 'name'"
    }
    
    # Extract and validate description
    $description = Get-FrontmatterField -FilePath $skillMdPath -FieldName "description"
    if ($description) {
        Write-ValidationSuccess "✓ Found description ($($description.Length) chars)"
        Test-Description -Description $description
    } else {
        Write-ValidationError "Missing required field: 'description'"
    }
    
    # Check optional fields
    $license = Get-FrontmatterField -FilePath $skillMdPath -FieldName "license"
    if ($license) {
        Write-ValidationSuccess "✓ Found license"
    }
    
    $metadata = Get-FrontmatterField -FilePath $skillMdPath -FieldName "metadata"
    if ($metadata) {
        Write-ValidationSuccess "✓ Found metadata"
    }
    
    # Print summary
    Write-Host ""
    Write-Host "------------------------------------------------------------"
    
    if ($script:ErrorCount -eq 0) {
        Write-Host "✅ VALIDATION PASSED" -ForegroundColor Green
        Write-Host "Skill structure is valid and follows the specification."
        
        if ($script:WarningCount -gt 0) {
            Write-Host ""
            Write-Host "Found $($script:WarningCount) warning(s) - consider addressing these." -ForegroundColor Yellow
        }
        
        if ($script:InfoCount -gt 0) {
            Write-Host "Found $($script:InfoCount) informational message(s)." -ForegroundColor Blue
        }
        
        exit 0
    } else {
        Write-Host "❌ VALIDATION FAILED" -ForegroundColor Red
        Write-Host "Found $($script:ErrorCount) error(s)" -ForegroundColor Red
        
        if ($script:WarningCount -gt 0) {
            Write-Host "Found $($script:WarningCount) warning(s)" -ForegroundColor Yellow
        }
        
        exit 1
    }
    
} catch {
    Write-Error "Error during validation: $_"
    exit 1
}
