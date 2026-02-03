#!/usr/bin/env python3
"""
setup-assess-context.py
Sets up the assess-context command workflow for Spec-Driven Development
"""

import argparse
import sys
from pathlib import Path
from shutil import copy2

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def setup_assess_context(json_mode: bool = False):
    # Get paths
    paths = get_feature_paths()
    
    # Check branch
    if not check_feature_branch(paths['CURRENT_BRANCH'], paths['HAS_GIT'] == 'true'):
        sys.exit(1)
    
    # Ensure docs dir
    docs_dir = Path(paths['REPO_ROOT']) / 'docs'
    docs_dir.mkdir(parents=True, exist_ok=True)
    
    # Copy context assessment template
    template = Path(paths['REPO_ROOT']) / '.sunrise/templates/templates-for-commands/context-assessment-template.md'
    assessment_file = docs_dir / 'context-assessment.md'
    if template.exists():
        copy2(template, assessment_file)
        print(f"Copied context assessment template to {assessment_file}")
    else:
        print(f"Warning: Context assessment template not found at {template}")
        assessment_file.touch()
    
    # Output results
    if json_mode:
        import json
        print(json.dumps({
            'context_assessment': str(assessment_file),
            'docs_dir': str(docs_dir),
            'repo_root': paths['REPO_ROOT'],
            'has_git': paths['HAS_GIT'] == 'true'
        }))
    else:
        print(f"Context assessment setup complete. File: {assessment_file}")

def main():
    parser = argparse.ArgumentParser(description="Setup assess-context workflow")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')
    
    args = parser.parse_args()
    
    setup_assess_context(args.json)

if __name__ == '__main__':
    main()