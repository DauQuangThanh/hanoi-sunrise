#!/usr/bin/env python3
"""
setup-architect.py
Sets up the architect command workflow for Spec-Driven Development
"""

import argparse
import sys
from pathlib import Path
from shutil import copy2

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def setup_architect(json_mode: bool = False):
    # Get paths
    paths = get_feature_paths()
    
    # Check branch
    if not check_feature_branch(paths['CURRENT_BRANCH'], paths['HAS_GIT'] == 'true'):
        sys.exit(1)
    
    # Ensure feature dir
    Path(paths['FEATURE_DIR']).mkdir(parents=True, exist_ok=True)
    
    # Copy architect template
    template = Path(paths['REPO_ROOT']) / '.sunrise/templates/templates-for-commands/architect-template.md'
    architect_file = Path(paths['FEATURE_DIR']) / 'architect.md'
    if template.exists():
        copy2(template, architect_file)
        print(f"Copied architect template to {architect_file}")
    else:
        print(f"Warning: Architect template not found at {template}")
        architect_file.touch()
    
    # Output results
    if json_mode:
        import json
        print(json.dumps({
            'architect': str(architect_file),
            'repo_root': paths['REPO_ROOT'],
            'has_git': paths['HAS_GIT'] == 'true'
        }))
    else:
        print(f"Architect setup complete. File: {architect_file}")

def main():
    parser = argparse.ArgumentParser(description="Setup architect workflow")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')
    parser.add_argument('--help', '-h', action='store_true', help='Show help')
    
    args = parser.parse_args()
    
    if args.help:
        parser.print_help()
        sys.exit(0)
    
    setup_architect(args.json)

if __name__ == '__main__':
    main()