#!/usr/bin/env python3
"""
Generate Skill Script
Generates a new agent skill structure following the Agent Skills specification.

Usage:
    python3 generate-skill.py <skill-name> [output_dir]

Example:
    python3 generate-skill.py my-new-skill
    python3 generate-skill.py pdf-processing ./skills/

Requirements:
    - Python 3.8+
"""

import sys
import os
import argparse
import re
import datetime
from pathlib import Path

# ANSI colors for terminal output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def print_success(msg):
    print(f"{Colors.OKGREEN}✓ {msg}{Colors.ENDC}")

def print_error(msg):
    print(f"{Colors.FAIL}✗ {msg}{Colors.ENDC}")

def print_info(msg):
    print(f"{Colors.OKBLUE}ℹ {msg}{Colors.ENDC}")

def print_warning(msg):
    print(f"{Colors.WARNING}⚠ {msg}{Colors.ENDC}")

def validate_skill_name(name):
    """
    Validates the skill name against the specification:
    - Lowercase only
    - Hyphens only (no underscores/spaces)
    - Alphanumeric start/end
    - No consecutive hyphens
    - 1-64 chars
    """
    if not name:
        return False, "Name cannot be empty"
    
    if len(name) > 64:
        return False, "Name too long (max 64 chars)"
        
    if not re.match(r'^[a-z0-9]+(-[a-z0-9]+)*$', name):
        return False, "Name must be lowercase, alphanumeric, hyphens only, no consecutive hyphens, no start/end hyphens"
        
    return True, ""

def get_template_content(template_name):
    """Retrieves content from the sibling templates directory."""
    # This script is in scripts/
    # Templates are in templates/
    # Path is ../templates/
    
    script_dir = Path(__file__).parent.resolve()
    template_path = script_dir.parent / 'templates' / template_name
    
    if not template_path.exists():
        # Fallback 1: Look in current directory/templates (if run from repo root or skill root)
        cwd_template = Path.cwd() / 'templates' / template_name
        if cwd_template.exists():
            return cwd_template.read_text(encoding='utf-8')

        # Fallback 2: Look in relative path from repo root if we can guess it
        # Try .github/skills/agent-skill-creation/templates/
        repo_template = Path.cwd() / '.github' / 'skills' / 'agent-skill-creation' / 'templates' / template_name
        if repo_template.exists():
            return repo_template.read_text(encoding='utf-8')
        
        print_warning(f"Template not found at {template_path} or fallbacks. Using internal default.")
        return None
        
    return template_path.read_text(encoding='utf-8')

def create_skill(name, output_dir):
    """Creates the skill directory structure and files."""
    
    root_path = Path(output_dir) / name
    
    if root_path.exists():
        print_error(f"Directory already exists: {root_path}")
        return False
        
    try:
        # 1. Create directory structure
        (root_path / 'scripts').mkdir(parents=True, exist_ok=True)
        (root_path / 'references').mkdir(exist_ok=True)
        (root_path / 'templates').mkdir(exist_ok=True)
        (root_path / 'assets').mkdir(exist_ok=True)
        print_success(f"Created directory structure at {root_path}")
        
        # 2. Create SKILL.md
        skill_template_content = get_template_content('skill-template.md')
        
        if skill_template_content:
            # Replace placeholders
            today = datetime.date.today().isoformat()
            
            # Simple replacements
            content = skill_template_content.replace('name: skill-name', f'name: {name}')
            content = content.replace('# Skill Name', f'# {name.replace("-", " ").title()}')
            content = content.replace('last_updated: "YYYY-MM-DD"', f'last_updated: "{today}"')
            
            # Write file
            (root_path / 'SKILL.md').write_text(content, encoding='utf-8')
            print_success("Created SKILL.md from template")
        else:
            # Fallback content if template missing
            today = datetime.date.today().isoformat()
            content = f"""---
name: {name}
description: "[ACTION 1], [ACTION 2], and [ACTION 3]. Use when [SCENARIO 1], [SCENARIO 2], or when user mentions [KEYWORD 1], [KEYWORD 2], or [KEYWORD 3]."
license: MIT
metadata:
  author: Your Name
  version: "1.0"
  last_updated: "{today}"
---

# {name.replace("-", " ").title()}

## Overview

[Brief 2-3 sentence explanation of what this skill does and its primary purpose]

## When to Use

- [Specific scenario 1]
- [Specific scenario 2]
- [Specific scenario 3]

## Prerequisites

**Required:**
- None

## Instructions

### Step 1: [Action Name]

[Instructions]

## Examples

### Example 1: [Use Case]

**Input:**
```
[Input]
```

**Output:**
```
[Output]
```
"""
            (root_path / 'SKILL.md').write_text(content, encoding='utf-8')
            print_info("Created SKILL.md (default content)")

        # 3. Create .gitkeep files to preserve structure (optional, but good for empty dirs)
        (root_path / 'references' / '.gitkeep').touch()
        (root_path / 'templates' / '.gitkeep').touch()
        (root_path / 'assets' / '.gitkeep').touch()
        
        # 4. Create a sample script
        script_template_content = get_template_content('script-template.py')
        if script_template_content:
            script_content = script_template_content.replace('[Script Name]', f'{name}-script')
            (root_path / 'scripts' / f'{name}.py').write_text(script_content, encoding='utf-8')
            # Make executable
            try:
                os.chmod(root_path / 'scripts' / f'{name}.py', 0o755)
            except Exception:
                pass
            print_success(f"Created sample script at scripts/{name}.py")

        print(f"\n{Colors.BOLD}Skill '{name}' created successfully!{Colors.ENDC}")
        print("\nNext steps:")
        print(f"1. Edit {root_path}/SKILL.md to add description and instructions")
        print(f"2. Add your scripts to {root_path}/scripts/")
        print(f"3. Validate using: python3 .github/skills/agent-skill-creation/scripts/validate-skill.py {root_path}")
        
        return True

    except Exception as e:
        print_error(f"Failed to create skill: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description="Generate a new agent skill structure.")
    parser.add_argument("name", help="Name of the skill (lowercase, hyphens only)")
    parser.add_argument("output_dir", nargs="?", default=".", help="Directory to create skill in (default: current)")
    
    args = parser.parse_args()
    
    # Validate name
    valid, msg = validate_skill_name(args.name)
    if not valid:
        print_error(f"Invalid skill name: {msg}")
        sys.exit(1)
        
    # Create skill
    if not create_skill(args.name, args.output_dir):
        sys.exit(1)

if __name__ == "__main__":
    main()
