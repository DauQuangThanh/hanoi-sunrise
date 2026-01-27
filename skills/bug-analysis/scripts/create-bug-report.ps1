# Create Bug Report Script
# Author: Dau Quang Thanh
# License: MIT
# Description: Creates a new structured bug report from template

# Enable strict error handling
$ErrorActionPreference = "Stop"

# Get the directory where this script is located
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = Split-Path -Parent $ScriptDir
$TemplateDir = Join-Path $SkillDir "templates"

# Function to print colored output
function Write-Info {
    param([string]$Message)
    Write-Host "ℹ " -ForegroundColor Blue -NoNewline
    Write-Host $Message
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

# Function to get next bug ID
function Get-NextBugId {
    param([string]$BugsDir)
    
    if (-not (Test-Path $BugsDir)) {
        return "001"
    }
    
    # Find all BUG-*.md files and extract numbers
    $maxNum = 0
    Get-ChildItem -Path $BugsDir -Filter "BUG-*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -match 'BUG-(\d+)-') {
            $num = [int]$matches[1]
            if ($num -gt $maxNum) {
                $maxNum = $num
            }
        }
    }
    
    # Increment and format with leading zeros
    $nextNum = $maxNum + 1
    return $nextNum.ToString("000")
}

# Function to sanitize title for filename
function Get-SanitizedFilename {
    param([string]$Title)
    
    $sanitized = $Title.ToLower() -replace '[^a-z0-9]', '-'
    $sanitized = $sanitized -replace '--+', '-'
    $sanitized = $sanitized -replace '^-', ''
    $sanitized = $sanitized -replace '-$', ''
    
    if ($sanitized.Length -gt 50) {
        $sanitized = $sanitized.Substring(0, 50)
    }
    
    return $sanitized
}

# Main function
function Main {
    Write-Host ""
    Write-Info "Bug Report Creator"
    Write-Host ""
    
    # Check if template exists
    $templatePath = Join-Path $TemplateDir "bug-report-template.md"
    if (-not (Test-Path $templatePath)) {
        Write-Error-Custom "Template not found: $templatePath"
        exit 1
    }
    
    # Determine bugs directory
    $bugsDir = if (Test-Path ".github") {
        ".github/bugs"
    } elseif (Test-Path ".claude") {
        ".claude/bugs"
    } elseif (Test-Path ".copilot") {
        ".copilot/bugs"
    } elseif (Test-Path ".cursor") {
        ".cursor/bugs"
    } else {
        "bugs"
    }
    
    Write-Info "Bugs will be saved to: $bugsDir"
    
    # Create bugs directory if it doesn't exist
    New-Item -ItemType Directory -Path $bugsDir -Force | Out-Null
    
    # Get bug information
    Write-Host ""
    $bugTitle = Read-Host "Bug title"
    
    if ([string]::IsNullOrWhiteSpace($bugTitle)) {
        Write-Error-Custom "Bug title is required"
        exit 1
    }
    
    $severityInput = Read-Host "Severity (Critical/High/Medium/Low) [Medium]"
    $severity = if ([string]::IsNullOrWhiteSpace($severityInput)) { "Medium" } else { $severityInput }
    
    $priorityInput = Read-Host "Priority (P0/P1/P2/P3) [P2]"
    $priority = if ([string]::IsNullOrWhiteSpace($priorityInput)) { "P2" } else { $priorityInput }
    
    # Get git user name, fallback to environment username
    try {
        $gitUser = & git config user.name 2>$null
        if ([string]::IsNullOrWhiteSpace($gitUser)) {
            $gitUser = $env:USERNAME
        }
    } catch {
        $gitUser = $env:USERNAME
    }
    
    $reporterInput = Read-Host "Reporter name [$gitUser]"
    $reporter = if ([string]::IsNullOrWhiteSpace($reporterInput)) { $gitUser } else { $reporterInput }
    
    # Get next bug ID
    $bugId = Get-NextBugId -BugsDir $bugsDir
    
    # Create filename
    $sanitizedTitle = Get-SanitizedFilename -Title $bugTitle
    $filename = "BUG-$bugId-$sanitizedTitle.md"
    $filepath = Join-Path $bugsDir $filename
    
    # Check if file already exists
    if (Test-Path $filepath) {
        Write-Error-Custom "File already exists: $filepath"
        exit 1
    }
    
    # Copy template and replace placeholders
    $content = Get-Content -Path $templatePath -Raw
    
    # Get current date
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    # Replace placeholders
    $content = $content -replace '\[Issue Title\]', $bugTitle
    $content = $content -replace '\[BUG-ID\]', "BUG-$bugId"
    $content = $content -replace 'Critical \| High \| Medium \| Low', $severity
    $content = $content -replace 'P0 \| P1 \| P2 \| P3', $priority
    $content = $content -replace 'YYYY-MM-DD', $currentDate
    $content = $content -replace '\[Reporter Name\]', $reporter
    
    # Save the file
    Set-Content -Path $filepath -Value $content -Encoding UTF8
    
    Write-Host ""
    Write-Success "Bug report created: $filepath"
    Write-Info "Bug ID: BUG-$bugId"
    Write-Info "Title: $bugTitle"
    Write-Info "Severity: $severity"
    Write-Info "Priority: $priority"
    
    # Open in editor if available
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Write-Host ""
        $openEditorInput = Read-Host "Open in VS Code? (y/n) [y]"
        $openEditor = if ([string]::IsNullOrWhiteSpace($openEditorInput)) { "y" } else { $openEditorInput }
        
        if ($openEditor -eq "y" -or $openEditor -eq "Y") {
            & code $filepath
            Write-Success "Opened in VS Code"
        }
    }
    
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "  1. Fill in the bug report details"
    Write-Host "  2. Reproduce the issue"
    Write-Host "  3. Attach screenshots/logs if applicable"
    Write-Host "  4. Analyze the root cause"
    Write-Host "  5. Propose solutions"
    Write-Host ""
}

# Run main function
try {
    Main
} catch {
    Write-Error-Custom "An error occurred: $_"
    exit 1
}
