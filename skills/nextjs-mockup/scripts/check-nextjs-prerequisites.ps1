# check-nextjs-prerequisites.ps1
# Checks for required tools and configuration before running nextjs-mockup skill
# Usage: .\check-nextjs-prerequisites.ps1 [-Json]

param(
    [switch]$Json
)

# Get workspace root (assuming script is in skills/nextjs-mockup/scripts/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspaceRoot = Resolve-Path (Join-Path $ScriptDir "../../..")

# Initialize variables
$NodeVersion = ""
$NodeAvailable = $false
$NodeMajor = 0
$PackageManager = ""
$PackageManagerVersion = ""
$NpmVersion = ""
$PnpmVersion = ""
$NextJsProject = $false

# Results
$AllRequiredPresent = $true
$Errors = @()
$Warnings = @()
$Info = @()

# Check if Node.js is available
try {
    $NodeVersionOutput = node --version 2>&1
    $NodeVersion = $NodeVersionOutput -replace 'v', ''
    $NodeAvailable = $true
    $Info += "Node.js is available: v$NodeVersion"
    
    # Parse major version
    $NodeMajor = [int]($NodeVersion -split '\.')[0]
    
    # Check if version meets minimum requirement (18+)
    if ($NodeMajor -lt 18) {
        $AllRequiredPresent = $false
        $Errors += "Node.js version $NodeVersion is too old. Next.js 16 requires Node.js 18.18.0 or higher"
    } else {
        $Info += "Node.js version meets requirements (18+)"
    }
} catch {
    $AllRequiredPresent = $false
    $NodeAvailable = $false
    $Errors += "Node.js not found. Install from https://nodejs.org/ (v20+ recommended)"
}

# Check for package managers
if ($NodeAvailable) {
    # Check for pnpm (preferred)
    try {
        $PnpmVersion = pnpm --version 2>&1
        $PackageManager = "pnpm"
        $PackageManagerVersion = $PnpmVersion
        $Info += "pnpm is available: v$PnpmVersion (recommended)"
    } catch {
        # pnpm not found
    }
    
    # Check for npm (fallback)
    try {
        $NpmVersion = npm --version 2>&1
        if ([string]::IsNullOrEmpty($PackageManager)) {
            $PackageManager = "npm"
            $PackageManagerVersion = $NpmVersion
            $Info += "npm is available: v$NpmVersion"
        } else {
            $Info += "npm is also available: v$NpmVersion"
        }
    } catch {
        # npm not found
    }
    
    # If no package manager found
    if ([string]::IsNullOrEmpty($PackageManager)) {
        $AllRequiredPresent = $false
        $Errors += "No package manager found. npm should be bundled with Node.js"
    } else {
        $Info += "Using package manager: $PackageManager v$PackageManagerVersion"
    }
}

# Check if in a Next.js project (optional check)
$PackageJsonPath = Join-Path $WorkspaceRoot "package.json"
if (Test-Path $PackageJsonPath) {
    $PackageJson = Get-Content $PackageJsonPath -Raw
    if ($PackageJson -match '"next"') {
        $NextJsProject = $true
        $Info += "Detected existing Next.js project in workspace"
    }
}

# Check for common project files
$NextConfigFiles = @("next.config.js", "next.config.mjs", "next.config.ts")
foreach ($file in $NextConfigFiles) {
    if (Test-Path (Join-Path $WorkspaceRoot $file)) {
        $Info += "Found Next.js configuration file: $file"
        break
    }
}

$TailwindConfigFiles = @("tailwind.config.js", "tailwind.config.ts")
foreach ($file in $TailwindConfigFiles) {
    if (Test-Path (Join-Path $WorkspaceRoot $file)) {
        $Info += "Found Tailwind CSS configuration"
        break
    }
}

# Output results
if ($Json) {
    # JSON output for programmatic parsing
    $result = @{
        success = $AllRequiredPresent
        workspace_root = $WorkspaceRoot.Path
        node = @{
            available = $NodeAvailable
            version = $NodeVersion
            major_version = $NodeMajor
        }
        package_manager = @{
            name = $PackageManager
            version = $PackageManagerVersion
            npm_version = $NpmVersion
            pnpm_version = $PnpmVersion
        }
        project = @{
            is_nextjs = $NextJsProject
        }
        errors = $Errors
        warnings = $Warnings
        info = $Info
    }
    
    $result | ConvertTo-Json -Depth 10
} else {
    # Human-readable output
    Write-Host ""
    Write-Host "Next.js Mockup - Prerequisites Check" -ForegroundColor Blue
    Write-Host "================================================"
    Write-Host ""
    
    # Workspace info
    Write-Host "Workspace: " -NoNewline
    Write-Host $WorkspaceRoot.Path -ForegroundColor Blue
    Write-Host ""
    
    # Node.js section
    Write-Host "Node.js:" -ForegroundColor Blue
    if ($NodeAvailable) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Node.js installed"
        Write-Host "    Version: v$NodeVersion"
        
        if ($NodeMajor -ge 18) {
            Write-Host "  " -NoNewline
            Write-Host "✓" -ForegroundColor Green -NoNewline
            Write-Host " Version meets requirements (18+)"
        } else {
            Write-Host "  " -NoNewline
            Write-Host "✗" -ForegroundColor Red -NoNewline
            Write-Host " Version too old (need 18+, have $NodeMajor)"
        }
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " Node.js not found (REQUIRED)"
    }
    Write-Host ""
    
    # Package Manager section
    Write-Host "Package Manager:" -ForegroundColor Blue
    if (-not [string]::IsNullOrEmpty($PackageManager)) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " $PackageManager v$PackageManagerVersion detected"
        
        if (-not [string]::IsNullOrEmpty($PnpmVersion)) {
            Write-Host "  " -NoNewline
            Write-Host "✓" -ForegroundColor Green -NoNewline
            Write-Host " pnpm available (recommended)"
        }
        
        if (-not [string]::IsNullOrEmpty($NpmVersion)) {
            Write-Host "    npm v$NpmVersion also available"
        }
    } else {
        Write-Host "  " -NoNewline
        Write-Host "✗" -ForegroundColor Red -NoNewline
        Write-Host " No package manager found (REQUIRED)"
    }
    Write-Host ""
    
    # Project status
    Write-Host "Project Status:" -ForegroundColor Blue
    if ($NextJsProject) {
        Write-Host "  " -NoNewline
        Write-Host "✓" -ForegroundColor Green -NoNewline
        Write-Host " Existing Next.js project detected"
    } else {
        Write-Host "    No Next.js project detected (will initialize new project)"
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
        Write-Host "✓ All prerequisites met. Ready to create Next.js mockups!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Blue
        Write-Host "  1. Run skill to create mockup project"
        Write-Host "  2. Or manually initialize: $PackageManager create next-app@latest"
        Write-Host "  3. Install dependencies: cd mockup; $PackageManager install"
        Write-Host "  4. Start dev server: $PackageManager dev"
        Write-Host ""
        Write-Host "Latest versions:" -ForegroundColor Blue
        Write-Host "  - Next.js: 16.1.x"
        Write-Host "  - React: 19.x"
        Write-Host "  - Tailwind CSS: 4.x"
    } else {
        Write-Host "✗ Missing required prerequisites. Please resolve the following:" -ForegroundColor Red
        foreach ($error in $Errors) {
            Write-Host "  - $error" -ForegroundColor Red
        }
        Write-Host ""
        Write-Host "Installation Tips:" -ForegroundColor Yellow
        if (-not $NodeAvailable) {
            Write-Host "  - Install Node.js v20 LTS: https://nodejs.org/"
            Write-Host "  - Or use version manager: nvm install 20"
        }
        if ($NodeAvailable -and $NodeMajor -lt 18) {
            Write-Host "  - Upgrade Node.js: nvm install 20; nvm use 20"
            Write-Host "  - Or download from: https://nodejs.org/"
        }
        if ([string]::IsNullOrEmpty($PnpmVersion)) {
            Write-Host "  - Install pnpm (recommended): npm install -g pnpm"
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
