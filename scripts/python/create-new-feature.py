#!/usr/bin/env python3
"""
create-new-feature.py
Create a new feature branch and set up the feature directory structure
"""

import argparse
import sys
import subprocess
from pathlib import Path
import re

# Import common functions
sys.path.insert(0, str(Path(__file__).parent))
from common import *

def create_new_feature(json_mode: bool = False, short_name: str = '', branch_number: str = '', feature_description: str = ''):
    repo_root = get_repo_root()
    has_git_repo = has_git()
    
    if not feature_description:
        print_error("Feature description is required")
        sys.exit(1)
    
    # Generate branch name
    if has_git:
        if branch_number:
            number = branch_number
        else:
            # Find next number
            specs_dir = Path(repo_root) / 'specs'
            if specs_dir.exists():
                existing = []
                for d in specs_dir.iterdir():
                    if d.is_dir():
                        m = re.match(r'^(\d{3})-', d.name)
                        if m:
                            existing.append(int(m.group(1)))
                number = max(existing) + 1 if existing else 1
            else:
                number = 1
        
        if short_name:
            branch_name = f"{number:03d}-{short_name.replace(' ', '-')}"
        else:
            # Generate from description
            words = feature_description.split()[:4]
            short = '-'.join(words).lower()
            branch_name = f"{number:03d}-{short}"
        
        # Create and checkout branch
        subprocess.run(['git', 'checkout', '-b', branch_name], check=True)
        print(f"Created and switched to branch: {branch_name}")
    else:
        # For non-git, use description as branch
        branch_name = feature_description.replace(' ', '-').lower()
        print(f"Using feature name: {branch_name}")
    
    # Create feature dir
    feature_dir = Path(repo_root) / 'specs' / branch_name
    feature_dir.mkdir(parents=True, exist_ok=True)
    
    # Create basic files
    spec_file = feature_dir / 'spec.md'
    spec_file.write_text(f"# Feature Specification\n\n## Description\n{feature_description}\n")
    
    # Output
    if json_mode:
        import json
        print(json.dumps({
            'branch_name': branch_name,
            'feature_dir': str(feature_dir),
            'spec_file': str(spec_file),
            'repo_root': repo_root,
            'has_git': has_git_repo
        }))
    else:
        print(f"New feature created: {branch_name}")
        print(f"Feature directory: {feature_dir}")
        print(f"Spec file: {spec_file}")

def main():
    parser = argparse.ArgumentParser(description="Create a new feature")
    parser.add_argument('--json', action='store_true', help='Output in JSON format')
    parser.add_argument('--short-name', help='Custom short name for branch')
    parser.add_argument('--number', help='Manual branch number')
    parser.add_argument('--help', '-h', action='store_true', help='Show help')
    parser.add_argument('feature_description', nargs='?', help='Feature description')
    
    args = parser.parse_args()
    
    if args.help or not args.feature_description:
        parser.print_help()
        sys.exit(0)
    
    create_new_feature(args.json, args.short_name or '', args.number or '', args.feature_description)

if __name__ == '__main__':
    main()