# check-tasks-to-ado-prerequisites.ps1
# Checks for required files and configuration before running tasks-to-azure-devops skill
# Usage: .\check-tasks-to-ado-prerequisites.ps1 [-Json]

param(
    [switch]$Json
)

# Get workspace root (assuming script is in skills/tasks-to-azure-devops/scripts/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Resolve-Path (Join-Path $ScriptDir "../../..")

# Initialize variables
$TasksFile = ""
$GitRemote = ""
$AdoOrg = ""
$AdoProject = ""
$AdoRepo = ""
$IsAzureDevOps = $false
$IsGitRepo = $false
$GitAvailable = $false

# Results
$AllRequiredPresent = $true
$Errors = @()
$Warnings = @()
$Info = @()

# Check if git is available
try {
    $null = git --version 2>&1
    $GitAvailable = $true
    $Info += "Git command is available"
} catch {
    $AllRequiredPresent = $false
    $Errors += "Git command not found (required for repository operations)"
}

# Check if we're in a git repository
if ($GitAvailable) {
    try {
        Push-Location $WorkspaceRoot
        $null = git rev-parse --git-dir 2>&1
        $IsGitRepo = $true
        $Info += "Repository is a Git repository"
        Pop-Location
    } catch {
        $AllRequiredPresent = $false
        $Errors += "Not a Git repository (run 'git init' to initialize)"
        Pop-Location
    }
}

# Get Git remote if available
if ($IsGitRepo) {
    try {
        Push-Location $WorkspaceRoot
        $GitRemote = git config --get remote.origin.url 2>&1
        Pop-Location
        
        if ([string]::IsNullOrEmpty($GitRemote)) {
            $AllRequiredPresent = $false
            $Errors += "No Git remote configured (run 'git remote add origin <url>')"
        } else {
            $Info += "Git remote found: $GitRemote"
            
            # Check if remote is Azure DevOps and extract organization/project
            if ($GitRemote -match "dev\.azure\.com") {
                $IsAzureDevOps = $true
                $Info += "Remote is an Azure DevOps repository"
                
                # Parse: https://dev.azure.com/{organization}/{project}/_git/{repository}
                if ($GitRemote -match "dev\.azure\.com/([^/]+)/([^/]+)/_git/([^/]+)") {
                    $AdoOrg = $Matches[1]
                    $AdoProject = $Matches[2]
                    $AdoRepo = $Matches[3]
                    $Info += "Organization: $AdoOrg, Project: $AdoProject, Repository: $AdoRepo"
                }
                # Parse: git@ssh.dev.azure.com:v3/{organization}/{project}/{repository}
                elseif ($GitRemote -match "ssh\.dev\.azure\.com:v3/([^/]+)/([^/]+)/([^/]+)") {
                    $AdoOrg = $Matches[1]
                    $AdoProject = $Matches[2]
                    $AdoRepo = $Matches[3]
                    $Info += "Organization: $AdoOrg, Project: $AdoProject, Repository: $AdoRepo"
                } else {
                    $Warnings += "Could not parse organization/project from Azure DevOps remote URL"
                }
            }
            elseif ($GitRemote -match "visualstudio\.com") {
                $IsAzureDevOps = $true
                $Info += "Remote is an Azure DevOps repository (legacy URL)"
                
                # Parse: https://{organization}.visualstudio.com/{project}/_git/{repository}
                if ($GitRemote -match "([^/]+)\.visualstudio\.com/([^/]+)/_git/([^/]+)") {
                    $AdoOrg = $Matches[1]
                    $AdoProject = $Matches[2]
                    $AdoRepo = $Matches[3]
                    $Info += "Organization: $AdoOrg, Project: $AdoProject, Repository: $AdoRepo"
                }
                # Parse: https://{organization}.visualstudio.com/DefaultCollection/{project}/_git/{repository}
                elseif ($GitRemote -match "([^/]+)\.visualstudio\.com/DefaultCollection/([^/]+)/_git/([^/]+)") {
                    $AdoOrg = $Matches[1]
                    $AdoProject = $Matches[2]
                    $AdoRepo = $Matches[3]
                    $Info += "Organization: $AdoOrg, Project: $AdoProject, Repository: $AdoRepo"
                } else {
                    $Warnings += "Could not parse organization/project from Azure DevOps remote URL"
                }
            } else {
                $AllRequiredPresent = $false
                $Errors += "Remote is not an Azure DevOps repository (this skill only works with Azure DevOps)"
            }
        }
    } catch {
        $AllRequiredPresent = $false
        $Errors += "Failed to get Git remote: $_"
    }
}

# Search for tasks.md files
$TasksFiles = Get-ChildItem -Path $WorkspaceRoot -Filter "tasks.md" -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "node_modules|\.git" }

if ($TasksFiles.Count -eq 0) {
    $AllRequiredPresent = $false
    $Errors += "No tasks.md file found in repository"
} elseif ($TasksFiles.Count -eq 1) {
    $TasksFile = $TasksFiles[0].FullName
    $Info += "Found tasks.md at: $TasksFile"
} else {
    $TasksFile = $TasksFiles[0].FullName
    $Warnings += "Multiple tasks.md files found ($($TasksFiles.Count)), using first: $TasksFile"
}

# Check for Azure DevOps MCP server availability (optional check)
# This is informational only, not blocking
if ($IsAzureDevOps) {
    $Info += "Azure DevOps MCP server is required for work item creation"
}

# Output results
if ($Json) {
    # JSON output for programmatic parsing
    $result = @{
        success = $AllRequiredPresent
        workspace_root = $WorkspaceRoot.Path
        git = @{
            available = $GitAvailable
            is_repository = $IsGitRepo
            remote = $GitRemote
            is_azure_devops = $IsAzureDevOps
        }
        ado = @{
            organization = $AdoOrg
            project = $AdoProject
            repository = $AdoRepo
        }
        tasks_file = $TasksFile
        errors = $Errors
        warnings = $Warnings
        info = $Info
    }
    
    $result | ConvertTo-Json -Depth 10
} else {
    # Human-readable output
    Write-Host ""
    Write-Host "Tasks to Azure DevOps - Prerequisites Check" -ForegroundColor Blue
    Write-Host "================================================"
    Write-Host ""
    
    # Workspace info
    Write-Host "Workspace: " -NoNewline
    Write-Host $WorkspaceRoot.Path -ForegroundColor Blue
    Write-Host ""
    
    # Git section
    Write-Host "Git Configuration:" -ForegroundColor Blue
    if ($GitAvailable) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Git command available"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " Git command not found (REQUIRED)"
    }
    
    if ($IsGitRepo) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Git repository initialized"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " Not a Git repository (REQUIRED)"
    }
    
    if (-not [string]::IsNullOrEmpty($GitRemote)) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Git remote configured"
        Write-Host "    Remote: $GitRemote"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " No Git remote configured (REQUIRED)"
    }
    
    if ($IsAzureDevOps) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Remote is Azure DevOps"
        if (-not [string]::IsNullOrEmpty($AdoOrg) -and -not [string]::IsNullOrEmpty($AdoProject)) {
            Write-Host "    Organization: $AdoOrg"
            Write-Host "    Project: $AdoProject"
            Write-Host "    Repository: $AdoRepo"
        }
    } else {
        if (-not [string]::IsNullOrEmpty($GitRemote)) {
            Write-Host "  " -NoNewline
            Write-Host "✗" -ForegroundColor Red -NoNewline
            Write-Host " Remote is not Azure DevOps (REQUIRED - this skill only works with Azure DevOps)"
        }
    }
    Write-Host ""
    
    # Tasks file section
    Write-Host "Task File:" -ForegroundColor Blue
    if (-not [string]::IsNullOrEmpty($TasksFile)) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " tasks.md found"
        Write-Host "    Path: $TasksFile"
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " tasks.md not found (REQUIRED)"
    }
    Write-Host ""
    
    # Errors
    if ($Errors.Count -gt 0) {
        Write-Host "Errors:" -ForegroundColor Red
        foreach ($error in $Errors) {
            Write-Host "  " -NoNewline
            Write-Host "✗" -ForegroundColor Red -NoNewline
            Write-Host " $error"
        }
        Write-Host ""
    }
    
    # Warnings
    if ($Warnings.Count -gt 0) {
        Write-Host "Warnings:" -ForegroundColor Yellow
        foreach ($warning in $Warnings) {
            Write-Host "  " -NoNewline
            Write-Host "!" -ForegroundColor Yellow -NoNewline
            Write-Host " $warning"
        }
        Write-Host ""
    }
    
    # Summary
    if ($AllRequiredPresent) {
        Write-Host "✓ All prerequisites met. Ready to sync tasks to Azure DevOps work items." -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Blue
        Write-Host "  1. Ensure Azure DevOps MCP server is configured with authentication"
        Write-Host "  2. Run tasks-to-azure-devops skill to create work items"
        Write-Host "  3. Review created work items in project: https://dev.azure.com/$AdoOrg/$AdoProject/_workitems"
    } else {
        Write-Host "✗ Missing required prerequisites. Please resolve the following before proceeding:" -ForegroundColor Red
        foreach ($error in $Errors) {
            Write-Host "  - $error" -ForegroundColor Red
        }
        Write-Host ""
        Write-Host "Tips:" -ForegroundColor Yellow
        if (-not $GitAvailable) {
            Write-Host "  - Install Git: https://git-scm.com/downloads"
        }
        if (-not $IsGitRepo) {
            Write-Host "  - Initialize Git repository: git init"
        }
        if ([string]::IsNullOrEmpty($GitRemote)) {
            Write-Host "  - Add Azure DevOps remote: git remote add origin https://dev.azure.com/org/project/_git/repo"
        }
        if (-not $IsAzureDevOps -and -not [string]::IsNullOrEmpty($GitRemote)) {
            Write-Host "  - This skill only works with Azure DevOps repositories"
            Write-Host "  - Change remote to Azure DevOps or use manual work item creation"
        }
        if ([string]::IsNullOrEmpty($TasksFile)) {
            Write-Host "  - Create tasks.md with task definitions"
            Write-Host "  - Run 'taskify' command to generate tasks from specifications"
        }
    }
    Write-Host ""
}

# Exit with appropriate code
if ($AllRequiredPresent) {
    exit 0
} else {
    exit 1
}
