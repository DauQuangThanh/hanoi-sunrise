#!/usr/bin/env python3
"""
setup-design-e2e-test.py
Sets up the design-e2e-test command workflow for Spec-Driven Development
"""

import argparse
import sys
from pathlib import Path
from shutil import copy2

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def setup_design_e2e_test(json_mode: bool = False):
    # Get paths
    paths = get_feature_paths()
    
    # Check branch
    if not check_feature_branch(paths['CURRENT_BRANCH'], paths['HAS_GIT'] == 'true'):
        sys.exit(1)
    
    # Ensure feature dir
    Path(paths['FEATURE_DIR']).mkdir(parents=True, exist_ok=True)
    
    # Copy design e2e test template
    template = Path(paths['REPO_ROOT']) / '.sunrise/templates/templates-for-commands/design-e2e-test-template.md'
    design_e2e_file = Path(paths['FEATURE_DIR']) / 'design-e2e-test.md'
    if template.exists():
        copy2(template, design_e2e_file)
        print(f"Copied design e2e test template to {design_e2e_file}")
    else:
        print(f"Warning: Design e2e test template not found at {template}")
        design_e2e_file.touch()
    
    # Output results
    if json_mode:
        import json
        print(json.dumps({
            'design_e2e_test': str(design_e2e_file),
            'repo_root': paths['REPO_ROOT'],
            'has_git': paths['HAS_GIT'] == 'true'
        }))
    else:
        print(f"Design e2e test setup complete. File: {design_e2e_file}")

def main():
    parser = argparse.ArgumentParser(description="Setup design e2e test workflow")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')
    
    args = parser.parse_args()
    
    setup_design_e2e_test(args.json)

if __name__ == '__main__':
    main()