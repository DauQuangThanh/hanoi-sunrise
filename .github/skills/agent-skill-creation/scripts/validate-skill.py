#!/usr/bin/env python3
"""
Validate Skill Script
Validates an agent skill against the Agent Skills specification and creation rules.

Usage:
    python3 validate-skill.py <skill-path>

Example:
    python3 validate-skill.py ./my-skill
    python3 validate-skill.py ./skills/pdf-processing

Requirements:
    - Python 3.8+
    - PyYAML (optional, falls back to manual parsing if missing)
"""

import sys
import os
import re
import argparse
from pathlib import Path
from typing import List, Dict, Tuple, Optional

# ANSI colors for terminal output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def print_result(check_name: str, passed: bool, message: str = ""):
    icon = "✅ PASS" if passed else "❌ FAIL"
    color = Colors.OKGREEN if passed else Colors.FAIL
    print(f"{color}{icon} | {check_name:<25} {message}{Colors.ENDC}")

def print_header(msg):
    print(f"\n{Colors.BOLD}{Colors.HEADER}{msg}{Colors.ENDC}")

def load_frontmatter(content: str) -> Tuple[Dict, str]:
    """Extracts and parses YAML frontmatter."""
    match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not match:
        return {}, "No frontmatter found"
    
    yaml_text = match.group(1)
    
    # Try using PyYAML if available
    try:
        import yaml
        return yaml.safe_load(yaml_text), ""
    except ImportError:
        # Simple manual parsing fallback
        data = {}
        for line in yaml_text.split('\n'):
            if ':' in line:
                key, value = line.split(':', 1)
                data[key.strip()] = value.strip().strip('"').strip("'")
        return data, ""
    except Exception as e:
        return {}, str(e)

def validate_skill(skill_path: Path) -> bool:
    """Validates a single skill directory."""
    print_header(f"Validating Skill: {skill_path.name}")
    print(f"Path: {skill_path.absolute()}")
    
    success = True
    errors = []

    # 1. Structure Validation
    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        print_result("Structure Check", False, "SKILL.md missing")
        return False
    else:
        print_result("Structure Check", True, "Structure OK")

    # Read Content
    try:
        content = skill_md.read_text(encoding='utf-8')
        lines = content.splitlines()
        line_count = len(lines)
    except Exception as e:
        return False

    # 2. Size Validation (< 500 lines)
    if line_count > 500:
        print_result("SKILL.md Size", False, f"{line_count} lines (> 500 limit). Move details to references/.")
        success = False
    else:
        print_result("SKILL.md Size", True, f"{line_count} lines")

    # 3. Frontmatter & Metadata Validation
    metadata, err = load_frontmatter(content)
    if err:
        print_result("Frontmatter", False, f"Invalid YAML: {err}")
        success = False
    else:
        print_result("Frontmatter", True, "Valid YAML found")

        # Name Validation
        name = metadata.get('name')
        if not name:
            print_result("Meta: 'name'", False, "Missing required field")
            success = False
        else:
            # Regex: lowercase, hyphens, alphanumeric start/end, no consecutive hyphens
            name_pattern = r'^[a-z0-9]+(-[a-z0-9]+)*$'
            if not re.match(name_pattern, name):
                print_result("Meta: 'name'", False, f"Invalid format '{name}'. Use lowercase, hyphens only.")
                success = False
            elif name != skill_path.name:
                print_result("Meta: 'name'", False, f"Mismatch: '{name}' != dir '{skill_path.name}'")
                success = False
            else:
                print_result("Meta: 'name'", True, f"'{name}'")

        # Description Validation
        description = metadata.get('description')
        if not description:
            print_result("Meta: 'description'", False, "Missing required field")
            success = False
        else:
            desc_len = len(description)
            if desc_len > 1024:
                print_result("Meta: 'description'", False, f"Too long ({desc_len} chars > 1024)")
                success = False
            elif desc_len < 10:
                 print_result("Meta: 'description'", False, "Too short (< 10 chars)")
                 success = False
            else:
                # Quality Checks
                quality_issues = []
                if "Use when" not in description and "Use for" not in description:
                    quality_issues.append("Missing 'Use when...' clause")
                
                if "mention" not in description.lower() and "keyword" not in description.lower():
                    quality_issues.append("Missing 'user mentions...' clause for discovery")

                vague_terms = ["helps with", "tool for", "does stuff"]
                for term in vague_terms:
                    if term in description.lower():
                        quality_issues.append(f"Contains vague term '{term}'")
            
                if quality_issues:
                   print_result("Meta: 'description'", True, f"Valid but weak: {', '.join(quality_issues)}")
                else:
                   print_result("Meta: 'description'", True, "Follows best practices")

        # License Validation (Recommended)
        license_field = metadata.get('license')
        if not license_field:
             print_result("Meta: 'license'", True, "Missing recommended field") # Soft warn
        
        # Last Updated Validation (Recommended)
        last_updated = None
        if 'metadata' in metadata and isinstance(metadata['metadata'], dict):
            last_updated = metadata['metadata'].get('last_updated')
        
        if last_updated:
            # Simple date regex YYYY-MM-DD
            if not re.match(r'^\d{4}-\d{2}-\d{2}$', str(last_updated)):
                 print_result("Meta: 'last_updated'", False, f"Invalid date {last_updated}. Use YYYY-MM-DD.")
                 success = False # Strict on format if present

    # 4. File Reference Validation
    # Regex to find links: [text](path)
    links = re.findall(r'\[.*?\]\((.*?)\)', content)
    broken_links = []
    
    for link in links:
        # Ignore external links, anchors, and absolute paths
        if link.startswith(('http', '#', '/', 'mailto:')):
            continue
            
        # Clean link (remove query params or anchors)
        clean_link = link.split('#')[0].split('?')[0]
        if not clean_link:
            continue
            
        target_path = skill_path / clean_link
        if not target_path.exists():
            # Check if it's referenced in the allowed directories
            if not (clean_link.startswith('references/') or 
                    clean_link.startswith('templates/') or 
                    clean_link.startswith('assets/') or 
                    clean_link.startswith('scripts/')):
                 pass # Still error if not found
            
            broken_links.append(clean_link)

    if broken_links:
        print_result("File References", False, f"Broken links: {', '.join(broken_links[:3])}" + ("..." if len(broken_links)>3 else ""))
        success = False # Soft fail? Rules say strict parsing.
    else:
        print_result("File References", True, "All internal links valid")

    # 5. Script Validation
    scripts_dir = skill_path / 'scripts'
    if scripts_dir.exists() and scripts_dir.is_dir():
        script_issues = []
        for script in scripts_dir.glob('*'):
            if script.name.startswith('.'): continue
            
            # Check execution permission (Unix/Linux/macOS)
            if os.name == 'posix':
                if not os.access(script, os.X_OK):
                    # Try to check if it has a shebang
                    try:
                        with open(script, 'r') as f:
                            first_line = f.readline()
                            if first_line.startswith('#!'):
                                script_issues.append(f"{script.name} has shebang but not executable")
                    except:
                        pass

            # Check for Python 3.8+ headers if .py
            if script.suffix == '.py':
                try:
                    s_content = script.read_text(encoding='utf-8')
                    if "pathlib" not in s_content and "os.path" in s_content:
                         pass # Not an error, just a recommendation
                except:
                    pass

        if script_issues:
            print_result("Scripts Check", False, f"Issues: {', '.join(script_issues)}")
            # Warn only
        else:
            print_result("Scripts Check", True, "Scripts look compatible")

    print("-" * 50)
    if success:
        print(f"{Colors.OKGREEN}{Colors.BOLD}✅ SKILL VALID{Colors.ENDC}")
    else:
        print(f"{Colors.FAIL}{Colors.BOLD}🚫 SKILL INVALID: Please fix errors used in red above.{Colors.ENDC}")
    
    return success

def main():
    parser = argparse.ArgumentParser(description="Validate Agent Skills.")
    parser.add_argument("path", help="Path to skill directory or directory containing multiple skills")
    
    args = parser.parse_args()
    target_path = Path(args.path)
    
    if not target_path.exists():
        print(f"Error: Path not found: {target_path}")
        sys.exit(1)

    # Check if target is a single skill or a collection
    if (target_path / "SKILL.md").exists():
        # Single skill mode
        if not validate_skill(target_path):
            sys.exit(1)
    else:
        # Directory mode - check subdirectories
        print(f"Scanning directory: {target_path}")
        failures = 0
        total = 0
        for item in target_path.iterdir():
            if item.is_dir() and not item.name.startswith('.'):
                if (item / "SKILL.md").exists():
                    total += 1
                    if not validate_skill(item):
                        failures += 1
        
        if total == 0:
             print("No skills found (folders with SKILL.md)")
             sys.exit(1)
             
        print("\nSummary:")
        print(f"Total Skills: {total}")
        print(f"Passed:       {total - failures}")
        print(f"Failed:       {failures}")
        
        if failures > 0:
            sys.exit(1)

if __name__ == "__main__":
    main()
