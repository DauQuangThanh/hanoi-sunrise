#!/usr/bin/env python3
"""
setup-standardize.py
Sets up the standardize command workflow for Spec-Driven Development
This script creates the standards document from template and prepares the environment
"""

import argparse
import sys
from pathlib import Path

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def setup_standardize(json_mode: bool = False):
    repo_root = get_repo_root()

    # Define paths
    docs_dir = Path(repo_root) / 'docs'
    standards_file = docs_dir / 'standards.md'
    template_file = Path(repo_root) / '.sunrise/templates/templates-for-commands/standards-template.md'
    ground_rules_file = Path(repo_root) / 'docs/ground-rules.md'
    architecture_file = docs_dir / 'architecture.md'
    specs_dir = Path(repo_root) / 'specs'

    # Ensure required directories exist
    docs_dir.mkdir(parents=True, exist_ok=True)

    # Check for required files
    if not template_file.exists():
        print_error(f"Standards template not found at: {template_file}")
        sys.exit(1)

    if not ground_rules_file.exists():
        print_error(f"Ground-rules file not found at: {ground_rules_file}")
        print_info("Please run the set-ground-rules command first.")
        sys.exit(1)

    # Create standards document if it doesn't exist
    if not standards_file.exists():
        print_info("Creating standards document from template...")
        standards_file.write_text(template_file.read_text(encoding='utf-8'))
        print_success(f"Created: {standards_file}")

    # Output results
    if json_mode:
        import json
        print(json.dumps({
            'standards_doc': str(standards_file),
            'docs_dir': str(docs_dir),
            'architecture': str(architecture_file),
            'ground_rules': str(ground_rules_file),
            'specs_dir': str(specs_dir),
            'repo_root': repo_root,
            'has_git': has_git()
        }))
    else:
        print(f"Standardize setup complete. File: {standards_file}")

def main():
    parser = argparse.ArgumentParser(description="Setup standardize workflow")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')

    args = parser.parse_args()

    setup_standardize(args.json)

if __name__ == '__main__':
    main()
