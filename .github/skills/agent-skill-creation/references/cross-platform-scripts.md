# Cross-Platform Script Development Guide

## Overview

When creating scripts for agent commands, you must provide both Bash (.sh) and PowerShell (.ps1) versions to ensure compatibility across Windows, macOS, and Linux platforms.

## Platform-Specific Scripts

### Bash Script (macOS/Linux)

**Template:**

```bash
#!/usr/bin/env bash
# process.sh - Process files (Unix-like systems)
#
# Usage: ./process.sh <input-file> [output-file]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print error and exit
error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Print success
success() {
    echo -e "${GREEN}$1${NC}"
}

# Print info
info() {
    echo -e "${YELLOW}$1${NC}"
}

# Main logic
main() {
    # Check arguments
    if [ $# -lt 1 ]; then
        error "Usage: $0 <input-file> [output-file]"
    fi
    
    INPUT_FILE="$1"
    OUTPUT_FILE="${2:-}"
    
    # Validate input
    if [ ! -f "$INPUT_FILE" ]; then
        error "File not found: $INPUT_FILE"
    fi
    
    info "Processing: $INPUT_FILE"
    
    # Process file (your logic here)
    RESULT=$(cat "$INPUT_FILE" | tr '[:lower:]' '[:upper:]')
    
    # Output
    if [ -n "$OUTPUT_FILE" ]; then
        echo "$RESULT" > "$OUTPUT_FILE"
        success "Output written to: $OUTPUT_FILE"
    else
        echo "$RESULT"
    fi
}

# Run main with all arguments
main "$@"
```

**Make executable:**

```bash
chmod +x process.sh
```

**Usage:**

```bash
./process.sh input.txt
./process.sh input.txt output.txt
```

### PowerShell Script (Windows)

**Template:**

```powershell
# process.ps1 - Process files (Windows)
#
# Usage: .\process.ps1 -InputFile <file> [-OutputFile <file>]

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false, Position=1)]
    [string]$OutputFile
)

$ErrorActionPreference = 'Stop'

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host "Error: $Message" -ForegroundColor Red
}

function Write-SuccessMessage {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-InfoMessage {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

try {
    # Validate input
    if (-not (Test-Path $InputFile)) {
        Write-ErrorMessage "File not found: $InputFile"
        exit 1
    }
    
    if (-not (Test-Path $InputFile -PathType Leaf)) {
        Write-ErrorMessage "Not a file: $InputFile"
        exit 1
    }
    
    Write-InfoMessage "Processing: $InputFile"
    
    # Read and process (your logic here)
    $content = Get-Content $InputFile -Raw
    $result = $content.ToUpper()
    
    # Output
    if ($OutputFile) {
        $result | Set-Content $OutputFile
        Write-SuccessMessage "Output written to: $OutputFile"
    }
    else {
        Write-Output $result
    }
    
    exit 0
}
catch {
    Write-ErrorMessage "Processing failed: $_"
    exit 1
}
```

**Usage:**

```powershell
.\process.ps1 -InputFile input.txt
.\process.ps1 -InputFile input.txt -OutputFile output.txt

# Short form
.\process.ps1 input.txt
.\process.ps1 input.txt output.txt
```

## Best Practices

### Path Handling

**Bash:**

```bash
# Get absolute path
ABSOLUTE_PATH=$(realpath "$FILE")

# Get directory
DIR=$(dirname "$FILE")
```

**PowerShell:**

```powershell
# Get absolute path
$AbsolutePath = (Resolve-Path $File).Path

# Get directory
$Dir = Split-Path $File -Parent
```

### Error Handling

**Python:**

```python
try:
    # Your code
    pass
except FileNotFoundError as e:
    print(f"File not found: {e}", file=sys.stderr)
    sys.exit(1)
except PermissionError as e:
    print(f"Permission denied: {e}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Unexpected error: {e}", file=sys.stderr)
    sys.exit(1)
```

**Bash:**

```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

#   exit 1
}
catch {
    Write-Error "Unexpected error: $_"
    exit 1
}
```

### Exit Codes

Use standard exit codes:

- `0` - Success
- `1` - General error
- `2` - Misuse of command (invalid arguments)
- `130` - Interrupted by user (Ctrl+C)

**Python:**

```python
sys.exit(0)  # Success
sys.exit(1)  # Error
```

**Bash:**

```bash
exit 0  # Success
exit 1  # Error
```

**PowerShell:**

```powershell
exit 0  # Success
exit 1  # Error
```

## Testing Cross-Platform Scripts

### Test Matrix

Test on all target platforms:

- [ ] Windows 10/11 (PowerShell 5.1+)
- [ ] macOS (Bash/Zsh)
- [ ] Linux (Ubuntu/Debian with Bash)

### Test Cases

1. **Normal execution** - Script completes successfully
2. **Missing file** - Proper error message
3. **Invalid arguments** - Usage message displayed
4. **Paths with spaces** - `"My File.txt"` handled correctly
5. **Special characters** - Unicode, symbols handled
6. **Large files** - Performance acceptable
7.cker run -v $(pwd):/workspace -w /workspace python:3.11 \
    python3 scripts/process.py input.txt

### Test Node.js script

docker run -v $(pwd):/workspace -w /workspace node:18 \
    node scripts/process.js input.txt

```

### WSL Testing (Windows → Linux)

```bash
# Test Bash script on Windows via WSL
wsl bash scripts/process.sh input.txt
```

## Documentation Template

In your SKILL.md, document scripts like this:

````markdown
## Scripts

### Cross-Platform Script (Recommended)

**Python:**
```bash
python3 scripts/process.py input.txt --output result.txt
```

**Requirements:**
- Python 3.8 or higher
- No external dependencies

**Supported Platforms:**
- ✅ Windows
- ✅ macOS
- ✅ Linux

### 

## Common Pitfalls

### 1. Line Endings

**Problem:** Scripts fail with `\r` errors on Unix

**Solution:** Configure `.gitattributes`:
```
*.sh text eol=lf
*.ps1 text eol=crlf
*.py text eol=lf
*.js text eol=lf
```

### 2. Executable Permissions

**Problem:** `Permission denied` on Unix

**Solution:**
```bashcommand files, document scripts like this:

````markdown
## Scripts

**macOS/Linux (Bash):**
```bash
chmod +x scripts/process.sh
./scripts/process.sh input.txt result.txt
```

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File scripts/process.ps1 -InputFile input.txt -OutputFile result.txt
```

**Requirements:**
- Bash 4.0+ (macOS/Linux)
- PowerShell 5.1+ (Windows) 4. Path Separators

**Problem:** Hardcoded `\` or `/`

**Solution:** Use path libraries:
- Python: `pathlib.Path`
- Node.js: `path.join()`
- Bash: `$()` with commands
- PowerShell: `Join-Path`
roper path handling:
- Bash: Use `$()` with commands like `dirname`, `basename`, `realpath`
- PowerShell: Use `Join-Path`, `Split-Path`, `Resolve
