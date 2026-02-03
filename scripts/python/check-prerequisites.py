#!/usr/bin/env python3
"""
check-prerequisites.py
Consolidated prerequisite checking script for Spec-Driven Development workflow.
"""

import argparse
import json
import sys
from pathlib import Path

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def check_prerequisites(json_mode: bool = False, require_tasks: bool = False, include_tasks: bool = False, paths_only: bool = False):
    # Get paths
    paths = get_feature_paths()
    
    if paths_only:
        for key, value in paths.items():
            print(f"{key}: {value}")
        return
    
    # Check branch
    if not check_feature_branch(paths['CURRENT_BRANCH'], paths['HAS_GIT'] == 'true'):
        sys.exit(1)
    
    # Ensure feature dir exists
    Path(paths['FEATURE_DIR']).mkdir(parents=True, exist_ok=True)
    
    # Check required files
    required_files = [
        ('FEATURE_SPEC', paths['FEATURE_SPEC']),
        ('FEATURE_DESIGN', paths['FEATURE_DESIGN']),
        ('RESEARCH', paths['RESEARCH']),
        ('DATA_MODEL', paths['DATA_MODEL']),
        ('QUICKSTART', paths['QUICKSTART']),
    ]
    
    if include_tasks:
        required_files.append(('TASKS', paths['TASKS']))
    
    if require_tasks:
        # Check if tasks exist
        if not Path(paths['TASKS']).exists():
            print_error(f"Tasks file required but not found: {paths['TASKS']}")
            sys.exit(1)
    
    available_docs = []
    for name, path in required_files:
        if Path(path).exists():
            available_docs.append(path)
            check_file(path, Path(path).name)
        else:
            print(f"  ✗ {Path(path).name}")
    
    # Output
    if json_mode:
        output = {
            'FEATURE_DIR': paths['FEATURE_DIR'],
            'AVAILABLE_DOCS': available_docs,
            'REPO_ROOT': paths['REPO_ROOT'],
            'CURRENT_BRANCH': paths['CURRENT_BRANCH'],
            'HAS_GIT': paths['HAS_GIT'] == 'true'
        }
        print(json.dumps(output))
    else:
        print(f"FEATURE_DIR: {paths['FEATURE_DIR']}")
        print("AVAILABLE_DOCS:")
        for doc in available_docs:
            print(f"  ✓ {Path(doc).name}")

def main():
    parser = argparse.ArgumentParser(description="Check prerequisites for Spec-Driven Development")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')
    parser.add_argument('--require-tasks', action='store_true', help='Require tasks.md to exist')
    parser.add_argument('--include-tasks', action='store_true', help='Include tasks.md in available docs')
    parser.add_argument('--paths-only', action='store_true', help='Only output path variables')
    
    args = parser.parse_args()
    
    check_prerequisites(args.json, args.require_tasks, args.include_tasks, args.paths_only)

if __name__ == '__main__':
    main()