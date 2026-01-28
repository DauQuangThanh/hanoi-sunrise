# Cross-Platform Script Development Guide

> **NOTE**: This skill (agent-command-creation) uses **Bash and PowerShell scripts only**. This guide is provided as reference documentation for understanding cross-platform development patterns, but the actual scripts in this skill follow the Bash + PowerShell approach.

Comprehensive guide for developing scripts that work across Windows, macOS, and Linux for agent commands.

## Overview

When creating agent commands that include automation scripts, you must ensure they work on all major platforms. This guide provides best practices and examples for cross-platform script development.

## Approach for This Skill

**This skill uses**: Bash (.sh) + PowerShell (.ps1) scripts

- **Bash scripts** for macOS and Linux
- **PowerShell scripts** for Windows
- Both versions must have identical functionality

See `scripts/init-agent.sh` and `scripts/init-agent.ps1` for reference implementations.

## Alternative Approaches (Reference Only)

### Python or Node.js (Not Used in This Skill)

**BEST PRACTICE**: Use Python or Node.js for cross-platform compatibility with a single file.

**Advantages**:

- ✅ Single script file works on all platforms
- ✅ Better error handling and logic
- ✅ Easier to maintain
- ✅ Rich ecosystem of libraries
- ✅ No need for platform-specific versions

**When to use**:

- Scripts with complex logic
- Scripts that need external libraries
- Scripts that manipulate data structures
- Scripts with significant error handling

**USE WHEN**: Script is very simple shell operations only.

**For This Skill**: This is the required approach.

**Requirements**:

- Must provide BOTH `.sh` (Bash) AND `.ps1` (PowerShell) versions
- Both versions must have identical functionality
- Both must be tested on their respective platforms

## Python Script Development (Reference Only)

> **Note**: The following Python documentation is provided for reference. This skill uses Bash and PowerShell scripts only.

### Basic Structure

```python
#!/usr/bin/env python3
"""
Script description goes here.

Usage:
    python script-name.py [arguments]

Platforms:
    - Windows
    - macOS
    - Linux

Requirements:
    - Python 3.8+
    - List any required packages
"""

import sys
import os
from pathlib import Path


def main():
    """Main entry point."""
    # Your logic here
    pass


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
```

### Cross-Platform Path Handling

```python
from pathlib import Path

# Always use Path for cross-platform paths
project_dir = Path.cwd()
output_dir = project_dir / "output" / "reports"
file_path = output_dir / "report.md"

# Create directories (works on all platforms)
output_dir.mkdir(parents=True, exist_ok=True)

# Read/write files
file_path.write_text("content", encoding="utf-8")
content = file_path.read_text(encoding="utf-8")

# Check if file/directory exists
if file_path.exists():
    print(f"File exists: {file_path}")

# List files in directory
for file in output_dir.glob("*.md"):
    print(f"Found: {file}")
```

### Environment Variables

```python
import os

# Get environment variable with default
home_dir = os.environ.get("HOME", os.path.expanduser("~"))
user = os.environ.get("USER", os.environ.get("USERNAME", "unknown"))

# Set environment variable
os.environ["MY_VAR"] = "value"
```

### Running External Commands

```python
import subprocess
from pathlib import Path

def run_command(cmd: list, cwd: Path = None) -> tuple:
    """
    Run external command safely.
    
    Returns: (stdout, stderr, return_code)
    """
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=False
        )
        return result.stdout, result.stderr, result.returncode
    except Exception as e:
        return "", str(e), 1

# Example usage
stdout, stderr, code = run_command(["git", "status"])
if code == 0:
    print("Success:", stdout)
else:
    print("Error:", stderr)
```

### Platform Detection

```python
import platform
import sys

# Get OS name
os_name = platform.system()  # 'Windows', 'Darwin', 'Linux'

# Check specific platform
if sys.platform == "win32":
    print("Running on Windows")
elif sys.platform == "darwin":
    print("Running on macOS")
elif sys.platform == "linux":
    print("Running on Linux")

# Get Python version
python_version = sys.version_info
if python_version < (3, 8):
    print("Error: Python 3.8 or higher required")
    sys.exit(1)
```

### Complete Example: File Processing Script

```python
#!/usr/bin/env python3
"""
Process project files and generate report.

Usage:
    python process-files.py <input-dir> [--output output.md]

Platforms: Windows, macOS, Linux
Requirements: Python 3.8+
"""

import argparse
import sys
from pathlib import Path
from typing import List


def process_file(file_path: Path) -> dict:
    """Process a single file."""
    try:
        content = file_path.read_text(encoding="utf-8")
        return {
            "path": str(file_path),
            "lines": len(content.splitlines()),
            "size": file_path.stat().st_size,
            "success": True
        }
    except Exception as e:
        return {
            "path": str(file_path),
            "error": str(e),
            "success": False
        }


def process_directory(input_dir: Path, pattern: str = "*.txt") -> List[dict]:
    """Process all matching files in directory."""
    results = []
    for file_path in input_dir.rglob(pattern):
        if file_path.is_file():
            results.append(process_file(file_path))
    return results


def generate_report(results: List[dict], output_file: Path) -> None:
    """Generate markdown report."""
    lines = ["# File Processing Report\n"]
    
    total = len(results)
    success = sum(1 for r in results if r.get("success", False))
    failed = total - success
    
    lines.append(f"## Summary\n")
    lines.append(f"- Total files: {total}\n")
    lines.append(f"- Processed successfully: {success}\n")
    lines.append(f"- Failed: {failed}\n\n")
    
    lines.append("## Details\n\n")
    for result in results:
        if result["success"]:
            lines.append(f"### {result['path']}\n")
            lines.append(f"- Lines: {result['lines']}\n")
            lines.append(f"- Size: {result['size']} bytes\n\n")
        else:
            lines.append(f"### {result['path']} ❌\n")
            lines.append(f"- Error: {result['error']}\n\n")
    
    output_file.write_text("".join(lines), encoding="utf-8")
    print(f"✓ Report written to: {output_file}")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Process project files and generate report"
    )
    parser.add_argument(
        "input_dir",
        type=Path,
        help="Input directory to process"
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("report.md"),
        help="Output report file (default: report.md)"
    )
    parser.add_argument(
        "--pattern",
        default="*.txt",
        help="File pattern to match (default: *.txt)"
    )
    
    args = parser.parse_args()
    
    # Validate input directory
    if not args.input_dir.exists():
        print(f"Error: Directory not found: {args.input_dir}", file=sys.stderr)
        sys.exit(1)
    
    if not args.input_dir.is_dir():
        print(f"Error: Not a directory: {args.input_dir}", file=sys.stderr)
        sys.exit(1)
    
    # Process files
    print(f"Processing files in: {args.input_dir}")
    results = process_directory(args.input_dir, args.pattern)
    
    if not results:
        print(f"Warning: No files found matching pattern '{args.pattern}'")
        sys.exit(0)
    
    # Generate report
    args.output.parent.mkdir(parents=True, exist_ok=True)
    generate_report(results, args.output)
    
    print(f"Processed {len(results)} files")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
```

## Shell Script Development (Bash)

### Basic Structure

```bash
#!/usr/bin/env bash
# Script name and description
# Author: Name
# License: MIT

# Exit on error, undefined variables, pipe failures
set -euo pipefail

# Script directory (cross-platform)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Display usage
usage() {
    cat << EOF
Usage: $0 [options] <arguments>

Description of what this script does.

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output

Examples:
    $0 input.txt
    $0 --verbose data/
EOF
    exit 1
}

# Main logic
main() {
    echo "Processing..."
    # Your logic here
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        *)
            break
            ;;
    esac
done

# Run main function
main "$@"
```

### Best Practices for Bash

```bash
# Always quote variables to handle spaces
FILE="my file.txt"
cat "$FILE"  # Correct
cat $FILE    # Wrong - breaks with spaces

# Check if command exists
if ! command -v git &> /dev/null; then
    echo "Error: git is required but not installed"
    exit 1
fi

# Create directories safely
mkdir -p "output/reports"

# Loop through files
for file in src/*.js; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
    fi
done

# Use [[ ]] for conditions (better than [ ])
if [[ -f "file.txt" && -r "file.txt" ]]; then
    echo "File exists and is readable"
fi

# Capture command output
OUTPUT=$(git status 2>&1)
if [ $? -eq 0 ]; then
    echo "Success: $OUTPUT"
fi
```

## Shell Script Development (PowerShell)

### Basic Structure

```powershell
# Script name and description
# Author: Name
# License: MIT

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$Verbose,
    
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputPath
)

$ErrorActionPreference = 'Stop'

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

# Display usage
function Show-Usage {
    Write-Host @"
Usage: script-name.ps1 [-Verbose] <input-path>

Description of what this script does.

Parameters:
    -Verbose      Enable verbose output
    InputPath     Path to input file or directory

Examples:
    .\script-name.ps1 input.txt
    .\script-name.ps1 -Verbose data\
"@
    exit 0
}

# Main logic
function Main {
    Write-Host "Processing: $InputPath"
    
    # Your logic here
    
    Write-Host "Done!" -ForegroundColor Green
}

# Run main function
try {
    Main
} catch {
    Write-Error "Error: $_"
    exit 1
}
```

### Best Practices for PowerShell

```powershell
# Always use $ErrorActionPreference = 'Stop'
$ErrorActionPreference = 'Stop'

# Check if command exists
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is required but not installed"
    exit 1
}

# Create directories safely
New-Item -ItemType Directory -Force -Path "output\reports" | Out-Null

# Loop through files
Get-ChildItem -Path "src" -Filter "*.js" | ForEach-Object {
    Write-Host "Processing: $($_.Name)"
}

# Use try-catch for error handling
try {
    $result = Some-Command
    Write-Host "Success: $result"
} catch {
    Write-Error "Failed: $_"
    exit 1
}

# Use proper path joining
$filePath = Join-Path $ProjectRoot "output\report.md"

# Check if file/directory exists
if (Test-Path $filePath) {
    Write-Host "File exists: $filePath"
}
```

## Documentation Requirements

### In Command Files

Always document script usage in the command file:

```markdown
## Scripts

This command includes automation scripts for cross-platform execution.

### Cross-Platform (Recommended)

Use the Python script for all platforms:

```bash
python3 scripts/process.py --input data.csv
```

**Requirements:**

- Python 3.8 or higher
- No additional dependencies

### Platform-Specific

Alternatively, use shell-specific scripts:

**macOS/Linux (Bash):**

```bash
chmod +x scripts/process.sh
./scripts/process.sh data.csv
```

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\process.ps1 data.csv
```

```

### In Script Files

Include comprehensive documentation in the script header:

```python
#!/usr/bin/env python3
"""
Script name and brief description.

Usage:
    python script-name.py [options] <arguments>

Options:
    --option1    Description of option1
    --option2    Description of option2

Arguments:
    argument1    Description of argument1

Examples:
    python script-name.py input.txt
    python script-name.py --option1 input.txt

Platforms:
    - Windows
    - macOS
    - Linux

Requirements:
    - Python 3.8+
    - package1 >= 1.0.0
    - package2 >= 2.0.0

Author: Name
License: MIT
"""
```

## Testing Cross-Platform Scripts

### Testing Checklist

```yaml
Testing Requirements:
  Windows:
    ✓ Test in PowerShell 5.1+
    ✓ Test in PowerShell Core 7.0+
    ✓ Test in Command Prompt (if applicable)
    ✓ Test with spaces in paths
    ✓ Test with different drive letters
  
  macOS:
    ✓ Test in Terminal
    ✓ Test with different shells (bash, zsh)
    ✓ Test with spaces in paths
    ✓ Test with symbolic links
  
  Linux:
    ✓ Test on Ubuntu/Debian
    ✓ Test on RHEL/CentOS (if applicable)
    ✓ Test with different shells
    ✓ Test with permissions issues

  Common Tests:
    ✓ Missing dependencies
    ✓ Invalid arguments
    ✓ Empty input
    ✓ Large input
    ✓ Special characters in paths
    ✓ Network interruption (if applicable)
    ✓ Disk full scenarios
```

### Test Script Example

```python
#!/usr/bin/env python3
"""Test script across platforms."""

import sys
import subprocess
from pathlib import Path

def test_script():
    """Run basic tests."""
    script = Path(__file__).parent / "process.py"
    
    tests = [
        # Test 1: Valid input
        {
            "name": "Valid input",
            "args": [str(script), "test-data/"],
            "should_pass": True
        },
        # Test 2: Missing argument
        {
            "name": "Missing argument",
            "args": [str(script)],
            "should_pass": False
        },
        # Test 3: Invalid path
        {
            "name": "Invalid path",
            "args": [str(script), "nonexistent/"],
            "should_pass": False
        },
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        result = subprocess.run(
            ["python3"] + test["args"],
            capture_output=True
        )
        
        success = (result.returncode == 0) == test["should_pass"]
        
        if success:
            print(f"✓ {test['name']}")
            passed += 1
        else:
            print(f"✗ {test['name']}")
            failed += 1
    
    print(f"\nResults: {passed} passed, {failed} failed")
    return failed == 0

if __name__ == "__main__":
    sys.exit(0 if test_script() else 1)
```

## Common Pitfalls to Avoid

### ❌ Platform-Specific Paths

```python
# Wrong - hardcoded Windows paths
path = "C:\\Users\\user\\file.txt"

# Right - use Path
from pathlib import Path
path = Path.home() / "file.txt"
```

### ❌ Line Endings

```python
# Wrong - platform-specific line endings
file.write("line1\n")  # Uses system line ending

# Right - explicit encoding and line endings
file.write("line1\n", encoding="utf-8", newline="\n")
```

### ❌ Shell-Specific Commands

```bash
# Wrong - only works in bash
source ~/.bashrc

# Right - use portable commands
. ~/.bashrc
```

### ❌ Assuming Command Availability

```python
# Wrong - assumes git is available
subprocess.run(["git", "status"])

# Right - check first
import shutil
if shutil.which("git"):
    subprocess.run(["git", "status"])
else:
    print("Error: git not found")
```

## Summary

### Quick Decision Tree

```
Need to create a script?
├─ Complex logic or dependencies?
│  └─ Use Python (recommended) ✓
├─ Simple file operations only?
│  └─ Provide both Bash + PowerShell
└─ Already have Python?
   └─ Always use Python ✓
```

### File Naming Convention

- Python: `script-name.py`
- Bash: `script-name.sh`
- PowerShell: `script-name.ps1`

### Required Documentation

1. **Script header**: Purpose, usage, requirements, platforms
2. **Command file**: How to run script on each platform
3. **README.md**: Overview of all scripts in skill
4. **Error messages**: Clear, actionable error messages

### Testing Requirements

- Test on Windows, macOS, and Linux
- Test with spaces in paths
- Test with missing dependencies
- Test error conditions
- Document platform-specific requirements
