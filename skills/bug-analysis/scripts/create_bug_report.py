#!/usr/bin/env python3
import argparse
import datetime
import os
import re
import sys
from pathlib import Path

def slugify(text):
    """Convert text to a filename-friendly slug."""
    text = text.lower()
    text = re.sub(r'[^\w\s-]', '', text)
    text = re.sub(r'[-\s]+', '-', text)
    return text.strip('-')

def main():
    parser = argparse.ArgumentParser(description="Create a new bug report from template.")
    parser.add_argument("bug_id", help="The bug ID (e.g., 001, BUG-123)")
    parser.add_argument("title", help="The title of the bug report")
    parser.add_argument("--output-dir", default="specs/bugs", help="Directory to save the bug report (default: specs/bugs)")
    
    args = parser.parse_args()
    
    # Define paths
    script_dir = Path(__file__).parent.resolve()
    # Handle being in root vs scripts dir
    if script_dir.name == "scripts":
         skill_dir = script_dir.parent
    else:
         # Fallback if moved or run from elsewhere, assuming standard structure relative to script
         # But since we move it to scripts/, this should be fine.
         # Actually, we need to be careful. When we run this, it will be in scripts/.
         skill_dir = script_dir.parent

    template_path = skill_dir / "templates" / "bug-report-template.md"
    
    # Check if template exists
    if not template_path.exists():
        print(f"Error: Template not found at {template_path}")
        sys.exit(1)
        
    # Create output directory if it doesn't exist
    output_dir = Path(args.output_dir)
    try:
        output_dir.mkdir(parents=True, exist_ok=True)
    except OSError as e:
        print(f"Error creating directory {output_dir}: {e}")
        sys.exit(1)
        
    # Generate filename
    slug = slugify(args.title)
    filename = f"{args.bug_id}-{slug}.md"
    output_path = output_dir / filename
    
    if output_path.exists():
        print(f"Warning: File {output_path} already exists. Creating with timestamp to avoid overwrite.")
        timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        filename = f"{args.bug_id}-{slug}-{timestamp}.md"
        output_path = output_dir / filename

    # Read template
    try:
        with open(template_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except IOError as e:
        print(f"Error reading template: {e}")
        sys.exit(1)
        
    # Replace placeholders
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    content = content.replace("[BUG-ID]", args.bug_id)
    content = content.replace("[Short Title]", args.title)
    content = content.replace("YYYY-MM-DD", current_date)
    
    # Write new file
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Successfully created bug report at: {output_path}")
    except IOError as e:
        print(f"Error writing file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
