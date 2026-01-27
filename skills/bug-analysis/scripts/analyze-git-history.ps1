# Analyze Git History Script
# Author: Dau Quang Thanh
# License: MIT
# Description: Analyzes git history to find when and how bugs were introduced

# Enable strict error handling
$ErrorActionPreference = "Stop"

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

function Write-Header {
    param([string]$Message)
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
}

# Function to check if we're in a git repository
function Test-GitRepository {
    try {
        git rev-parse --git-dir 2>&1 | Out-Null
        return $true
    } catch {
        Write-Error-Custom "Not a git repository"
        return $false
    }
}

# Function to show recent changes to a file
function Get-FileHistory {
    param(
        [string]$FilePath,
        [int]$Limit = 10
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Error-Custom "File not found: $FilePath"
        return
    }
    
    Write-Header "Recent changes to: $FilePath"
    Write-Host ""
    
    $commits = git log -n $Limit --pretty=format:"%h|%ad|%an|%s" --date=short -- $FilePath
    
    foreach ($commit in $commits) {
        $parts = $commit -split '\|'
        Write-Host $parts[0] -ForegroundColor Yellow -NoNewline
        Write-Host " " -NoNewline
        Write-Host $parts[1] -ForegroundColor Blue -NoNewline
        Write-Host " " -NoNewline
        Write-Host $parts[2] -ForegroundColor Green
        Write-Host "  $($parts[3])"
        Write-Host ""
    }
}

# Function to show who last modified specific lines
function Get-FileBlame {
    param(
        [string]$FilePath,
        [int]$StartLine = 1,
        [int]$EndLine = 0
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Error-Custom "File not found: $FilePath"
        return
    }
    
    Write-Header "Blame for: $FilePath"
    Write-Host ""
    
    if ($EndLine -gt 0) {
        git blame -L "$StartLine,$EndLine" $FilePath
    } else {
        $blame = git blame $FilePath | Select-Object -First 50
        $blame
        
        $totalLines = (Get-Content $FilePath).Count
        if ($totalLines -gt 50) {
            Write-Host ""
            Write-Info "Showing first 50 lines. Total lines: $totalLines"
            Write-Host "To see specific lines, run: git blame -L <start>,<end> $FilePath"
        }
    }
    
    Write-Host ""
}

# Function to find when a string was introduced or changed
function Search-GitHistory {
    param(
        [string]$SearchTerm,
        [string]$FilePath = ""
    )
    
    Write-Header "Searching for: $SearchTerm"
    Write-Host ""
    
    if ($FilePath) {
        Write-Info "Searching in file: $FilePath"
        Write-Host ""
        $commits = git log -S $SearchTerm --source --all --pretty=format:"%h|%ad|%an|%s" --date=short -- $FilePath
    } else {
        Write-Info "Searching in all files"
        Write-Host ""
        $commits = git log -S $SearchTerm --source --all --pretty=format:"%h|%ad|%an|%s" --date=short
    }
    
    foreach ($commit in $commits) {
        $parts = $commit -split '\|'
        Write-Host $parts[0] -ForegroundColor Yellow -NoNewline
        Write-Host " " -NoNewline
        Write-Host $parts[1] -ForegroundColor Blue -NoNewline
        Write-Host " " -NoNewline
        Write-Host $parts[2] -ForegroundColor Green
        Write-Host "  $($parts[3])"
        Write-Host ""
    }
}

# Function to analyze changes between two commits
function Compare-Commits {
    param(
        [string]$Commit1,
        [string]$Commit2 = "HEAD",
        [string]$FilePath = ""
    )
    
    Write-Header "Comparing commits: $Commit1 ... $Commit2"
    Write-Host ""
    
    try {
        git rev-parse $Commit1 2>&1 | Out-Null
    } catch {
        Write-Error-Custom "Invalid commit: $Commit1"
        return
    }
    
    try {
        git rev-parse $Commit2 2>&1 | Out-Null
    } catch {
        Write-Error-Custom "Invalid commit: $Commit2"
        return
    }
    
    if ($FilePath) {
        Write-Info "Changes in file: $FilePath"
        Write-Host ""
        git diff "$Commit1..$Commit2" -- $FilePath
    } else {
        Write-Info "Files changed:"
        Write-Host ""
        git diff --name-status "$Commit1..$Commit2"
    }
    
    Write-Host ""
}

# Function to find commits that changed a specific function
function Find-FunctionChanges {
    param(
        [string]$FunctionName,
        [string]$FilePath = ""
    )
    
    Write-Header "Finding changes to function: $FunctionName"
    Write-Host ""
    
    if ($FilePath) {
        try {
            $commits = git log -L ":$FunctionName:$FilePath" --pretty=format:"%h|%ad|%an|%s" --date=short
            foreach ($commit in $commits) {
                $parts = $commit -split '\|'
                if ($parts.Count -ge 4) {
                    Write-Host $parts[0] -ForegroundColor Yellow -NoNewline
                    Write-Host " " -NoNewline
                    Write-Host $parts[1] -ForegroundColor Blue -NoNewline
                    Write-Host " " -NoNewline
                    Write-Host $parts[2] -ForegroundColor Green
                    Write-Host "  $($parts[3])"
                    Write-Host ""
                }
            }
        } catch {
            Write-Warning "Could not find function. Falling back to text search."
            Search-GitHistory -SearchTerm $FunctionName -FilePath $FilePath
        }
    } else {
        Write-Warning "For best results, specify the file containing the function"
        Search-GitHistory -SearchTerm $FunctionName
    }
    
    Write-Host ""
}

# Function to show commits in a date range
function Get-DateRangeCommits {
    param(
        [string]$Since,
        [string]$Until = "now",
        [string]$FilePath = ""
    )
    
    Write-Header "Commits between $Since and $Until"
    Write-Host ""
    
    if ($FilePath) {
        $commits = git log --since=$Since --until=$Until --pretty=format:"%h|%ad|%an|%s" --date=short -- $FilePath
    } else {
        $commits = git log --since=$Since --until=$Until --pretty=format:"%h|%ad|%an|%s" --date=short --stat
    }
    
    foreach ($commit in $commits) {
        if ($commit -match '\|') {
            $parts = $commit -split '\|'
            Write-Host $parts[0] -ForegroundColor Yellow -NoNewline
            Write-Host " " -NoNewline
            Write-Host $parts[1] -ForegroundColor Blue -NoNewline
            Write-Host " " -NoNewline
            Write-Host $parts[2] -ForegroundColor Green
            Write-Host "  $($parts[3])"
            Write-Host ""
        } else {
            Write-Host $commit
        }
    }
    
    Write-Host ""
}

# Function to start git bisect interactively
function Start-GitBisect {
    param(
        [string]$GoodCommit,
        [string]$BadCommit = "HEAD"
    )
    
    Write-Header "Starting Git Bisect"
    Write-Host ""
    
    Write-Info "This will help you find the commit that introduced a bug"
    Write-Info "Good commit (working): $GoodCommit"
    Write-Info "Bad commit (broken): $BadCommit"
    Write-Host ""
    
    Write-Warning "You will need to test each commit and mark it as 'good' or 'bad'"
    Write-Host ""
    
    $confirm = Read-Host "Start bisect? (y/n)"
    
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Info "Bisect cancelled"
        return
    }
    
    git bisect start
    git bisect bad $BadCommit
    git bisect good $GoodCommit
    
    Write-Host ""
    Write-Success "Bisect started. Test the current commit and run:"
    Write-Host "  git bisect good  - if the commit works"
    Write-Host "  git bisect bad   - if the commit is broken"
    Write-Host "  git bisect reset - to exit bisect mode"
    Write-Host ""
}

# Function to show help
function Show-Help {
    @"

Git History Analysis Tool

Usage: .\analyze-git-history.ps1 <command> [options]

Commands:
  file-history <file> [limit]              Show recent changes to a file
  blame <file> [start-line] [end-line]     Show who last modified each line
  search <term> [file]                      Find when a string was added/changed
  compare <commit1> [commit2] [file]        Compare two commits
  function <name> [file]                    Find changes to a specific function
  date-range <since> [until] [file]         Show commits in a date range
  bisect <good-commit> [bad-commit]         Start interactive bisect session

Examples:
  # Show last 10 changes to a file
  .\analyze-git-history.ps1 file-history src\app.js

  # Show who wrote lines 10-20 in a file
  .\analyze-git-history.ps1 blame src\app.js 10 20

  # Find when "processPayment" was added or changed
  .\analyze-git-history.ps1 search "processPayment" src\payment.js

  # Compare two commits
  .\analyze-git-history.ps1 compare abc123 def456

  # Find changes to a function
  .\analyze-git-history.ps1 function calculateTotal src\cart.js

  # Show commits from last week
  .\analyze-git-history.ps1 date-range "1 week ago"

  # Start bisect to find when bug was introduced
  .\analyze-git-history.ps1 bisect v1.0.0 HEAD

"@
}

# Main function
function Main {
    param([string[]]$Args)
    
    # Check if we're in a git repository
    if (-not (Test-GitRepository)) {
        exit 1
    }
    
    # Parse command
    $command = if ($Args.Count -gt 0) { $Args[0] } else { "help" }
    
    switch ($command) {
        "file-history" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "File path required"
                Write-Host "Usage: .\analyze-git-history.ps1 file-history <file> [limit]"
                exit 1
            }
            $limit = if ($Args.Count -gt 2) { [int]$Args[2] } else { 10 }
            Get-FileHistory -FilePath $Args[1] -Limit $limit
        }
        
        "blame" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "File path required"
                Write-Host "Usage: .\analyze-git-history.ps1 blame <file> [start-line] [end-line]"
                exit 1
            }
            $startLine = if ($Args.Count -gt 2) { [int]$Args[2] } else { 1 }
            $endLine = if ($Args.Count -gt 3) { [int]$Args[3] } else { 0 }
            Get-FileBlame -FilePath $Args[1] -StartLine $startLine -EndLine $endLine
        }
        
        "search" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "Search term required"
                Write-Host "Usage: .\analyze-git-history.ps1 search <term> [file]"
                exit 1
            }
            $file = if ($Args.Count -gt 2) { $Args[2] } else { "" }
            Search-GitHistory -SearchTerm $Args[1] -FilePath $file
        }
        
        "compare" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "Commit required"
                Write-Host "Usage: .\analyze-git-history.ps1 compare <commit1> [commit2] [file]"
                exit 1
            }
            $commit2 = if ($Args.Count -gt 2) { $Args[2] } else { "HEAD" }
            $file = if ($Args.Count -gt 3) { $Args[3] } else { "" }
            Compare-Commits -Commit1 $Args[1] -Commit2 $commit2 -FilePath $file
        }
        
        "function" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "Function name required"
                Write-Host "Usage: .\analyze-git-history.ps1 function <name> [file]"
                exit 1
            }
            $file = if ($Args.Count -gt 2) { $Args[2] } else { "" }
            Find-FunctionChanges -FunctionName $Args[1] -FilePath $file
        }
        
        "date-range" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "Start date required"
                Write-Host "Usage: .\analyze-git-history.ps1 date-range <since> [until] [file]"
                exit 1
            }
            $until = if ($Args.Count -gt 2) { $Args[2] } else { "now" }
            $file = if ($Args.Count -gt 3) { $Args[3] } else { "" }
            Get-DateRangeCommits -Since $Args[1] -Until $until -FilePath $file
        }
        
        "bisect" {
            if ($Args.Count -lt 2) {
                Write-Error-Custom "Good commit required"
                Write-Host "Usage: .\analyze-git-history.ps1 bisect <good-commit> [bad-commit]"
                exit 1
            }
            $badCommit = if ($Args.Count -gt 2) { $Args[2] } else { "HEAD" }
            Start-GitBisect -GoodCommit $Args[1] -BadCommit $badCommit
        }
        
        default {
            if ($command -ne "help" -and $command -ne "--help" -and $command -ne "-h") {
                Write-Error-Custom "Unknown command: $command"
            }
            Show-Help
            if ($command -ne "help" -and $command -ne "--help" -and $command -ne "-h") {
                exit 1
            }
        }
    }
}

# Run main function
try {
    Main -Args $args
} catch {
    Write-Error-Custom "An error occurred: $_"
    exit 1
}
