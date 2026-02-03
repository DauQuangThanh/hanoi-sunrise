#!/usr/bin/env python3
"""
setup-design.py
Execute the implementation planning workflow using the plan template to generate design artifacts.
"""

import argparse
import sys
from pathlib import Path
from shutil import copy2

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def setup_design(json_mode: bool = False):
    # Get paths
    paths = get_feature_paths()
    
    # Check branch
    if not check_feature_branch(paths['CURRENT_BRANCH'], paths['HAS_GIT'] == 'true'):
        sys.exit(1)
    
    # Ensure feature dir
    Path(paths['FEATURE_DIR']).mkdir(parents=True, exist_ok=True)
    
    # Copy template
    template = Path(paths['REPO_ROOT']) / '.sunrise/templates/templates-for-commands/design-template.md'
    design_file = Path(paths['FEATURE_DESIGN'])
    if template.exists():
        copy2(template, design_file)
        print(f"Copied design template to {design_file}")
    else:
        print(f"Warning: Design template not found at {template}")
        design_file.touch()
    
    # Output results
    if json_mode:
        import json
        print(json.dumps({
            'feature_design': str(design_file),
            'repo_root': paths['REPO_ROOT'],
            'has_git': paths['HAS_GIT'] == 'true'
        }))
    else:
        print(f"Design setup complete. File: {design_file}")

def main():
    parser = argparse.ArgumentParser(description="Setup design workflow")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')
    
    args = parser.parse_args()
    
    setup_design(args.json)

if __name__ == '__main__':
    main()