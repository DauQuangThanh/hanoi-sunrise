#!/usr/bin/env python3
"""
Validate agent command files for correctness and compliance.

Usage: python3 validate-command.py <path-to-command-file>
Platforms: Windows, macOS, Linux
Requirements: Python 3.8+
"""

import sys
import re
from pathlib import Path
from typing import List, Optional, Tuple

# Validation Constants
MAX_DESCRIPTION_LENGTH = 80
MIN_DESCRIPTION_LENGTH = 10

class ValidationError:
    """Represents a validation error with severity."""
    
    def __init__(self, severity: str, message: str, line: Optional[int] = None):
        self.severity = severity
        self.message = message
        self.line = line
    
    def __str__(self) -> str:
        location = f" (line {self.line})" if self.line else ""
        return f"[{self.severity.upper()}]{location}: {self.message}"

def check_file_name(possible_path: str) -> List[ValidationError]:
    path = Path(possible_path)
    errors = []
    
    # Check extension
    if path.suffix not in ['.md', '.toml']:
        errors.append(ValidationError("error", f"Invalid file extension '{path.suffix}'. Must be .md or .toml"))
    
    # Check naming convention (lowercase, hyphens, dots for modes)
    name = path.stem
    if not re.match(r'^[a-z0-9]+([-.][a-z0-9]+)*$', name):
        errors.append(ValidationError("warning", f"Filename '{name}' should be lowercase with hyphens/dots"))
        
    return errors

def validate_markdown(content: str) -> List[ValidationError]:
    errors = []
    lines = content.splitlines()
    
    # 1. Frontmatter Check
    if not lines or lines[0].strip() != "---":
        errors.append(ValidationError("error", "Missing YAML frontmatter (must start with ---)", 1))
        return errors # Critical failure
        
    # Find end of frontmatter
    try:
        end_fm_idx = lines.index("---", 1)
    except ValueError:
        errors.append(ValidationError("error", "Unclosed YAML frontmatter", 1))
        return errors

    frontmatter = lines[1:end_fm_idx]
    
    # Check description
    desc_found = False
    mode_found = False
    
    for i, line in enumerate(frontmatter):
        if line.strip().startswith("description:"):
            desc_found = True
            try:
                val = line.split(":", 1)[1].strip().strip('"').strip("'")
                if len(val) < MIN_DESCRIPTION_LENGTH:
                    errors.append(ValidationError("warning", "Description is too short (< 10 chars)", i + 2))
                if len(val) > MAX_DESCRIPTION_LENGTH:
                    errors.append(ValidationError("warning", f"Description is too long ({len(val)} > 80 chars)", i + 2))
            except IndexError:
                 errors.append(ValidationError("error", "Invalid description format", i + 2))
                
        if line.strip().startswith("mode:"):
            mode_found = True
            
    if not desc_found:
        errors.append(ValidationError("error", "Missing required field: description", 1))
        
    # 2. Content Checks
    body = "\\n".join(lines[end_fm_idx+1:])
    
    # Check for arguments placeholder if not in Copilot mode (Copilot might use it differently, but usually $ARGUMENTS is good practice)
    # Actually rules say $ARGUMENTS for markdown.
    if "$ARGUMENTS" not in body:
        errors.append(ValidationError("info", "Missing '$ARGUMENTS' placeholder. Ensure you handle inputs if needed.", end_fm_idx + 2))
        
    return errors

def validate_toml(content: str) -> List[ValidationError]:
    errors = []
    
    # Basic TOML syntax check (regex based since we can't rely on toml lib being installed)
    # Check for description
    desc_match = re.search(r'^description\s*=\s*(.*)$', content, re.MULTILINE)
    if not desc_match:
        errors.append(ValidationError("error", "Missing required key: description"))
    else:
        val = desc_match.group(1).strip().strip('"').strip("'")
        if len(val) < MIN_DESCRIPTION_LENGTH:
            errors.append(ValidationError("warning", "Description is too short"))
    
    # Check for prompt
    if 'prompt' not in content:
        errors.append(ValidationError("error", "Missing required key: prompt"))
        
    # Check for argument placeholder
    if "{{args}}" not in content:
        errors.append(ValidationError("info", "Missing '{{args}}' placeholder in TOML content"))
        
    return errors

def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: python3 validate-command.py <path-to-command-file>", file=sys.stderr)
        return 1
    
    file_path = Path(sys.argv[1])
    
    if not file_path.exists():
        print(f"Error: File not found: {file_path}", file=sys.stderr)
        return 1
        
    print(f"Validating {file_path.name}...")
    
    all_errors = []
    
    # Name checks
    all_errors.extend(check_file_name(str(file_path)))
    
    # Content Checks
    try:
        content = file_path.read_text(encoding="utf-8")
        if file_path.suffix == '.md':
            all_errors.extend(validate_markdown(content))
        elif file_path.suffix == '.toml':
            all_errors.extend(validate_toml(content))
            
    except Exception as e:
        all_errors.append(ValidationError("error", f"Could not read file: {e}"))
        
    # Report
    if not all_errors:
        print("✓ Validation passed! No issues found.")
        return 0
        
    error_count = sum(1 for e in all_errors if e.severity == "error")
    warning_count = sum(1 for e in all_errors if e.severity == "warning")
    
    print(f"\nFound {error_count} errors, {warning_count} warnings:")
    
    for err in all_errors:
        symbol = "✗" if err.severity == "error" else "!" if err.severity == "warning" else "i"
        print(f"{symbol} {err}")
        
    return 1 if error_count > 0 else 0

if __name__ == "__main__":
    sys.exit(main())
