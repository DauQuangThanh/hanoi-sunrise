#!/usr/bin/env python3
"""
Generate a new agent command file from templates.

Usage: python3 generate-command.py <command-name> --agent <agent-type>
Platforms: Windows, macOS, Linux
Requirements: Python 3.8+
"""

import sys
import argparse
import shutil
from pathlib import Path

# Agent Configuration Map
AGENT_CONFIG = {
    # Markdown-based Agents
    "claude": {
        "directory": ".claude/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "cursor": {
        "directory": ".cursor/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "windsurf": {
        "directory": ".windsurf/workflows", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "kilocode": {
        "directory": ".kilocode/rules", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "roo": {
        "directory": ".roo/rules", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "bob": {
        "directory": ".bob/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "jules": {
        "directory": ".agent", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "antigravity": {
        "directory": ".agent/rules", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "amazonq": {
        "directory": ".amazonq/prompts", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "qoder": {
        "directory": ".qoder/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "auggie": {
        "directory": ".augment/rules", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "codebuddy": {
        "directory": ".codebuddy/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "codex": {
        "directory": ".codex/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "shai": {
        "directory": ".shai/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "opencode": {
        "directory": ".opencode/command", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    "amp": {
        "directory": ".agents/commands", 
        "extension": ".md",
        "template": "markdown-command-template.md"
    },
    
    # Special Markdown Agent
    "copilot": {
        "directory": ".github/prompts", 
        "extension": ".prompt.md",
        "template": "copilot-command-template.md"
    },
    
    # TOML-based Agents
    "gemini": {
        "directory": ".gemini/commands", 
        "extension": ".toml",
        "template": "toml-command-template.toml"
    },
    "qwen": {
        "directory": ".qwen/commands", 
        "extension": ".toml",
        "template": "toml-command-template.toml"
    }
}

def resolve_root_dir() -> Path:
    """Resolve the project root directory."""
    script_path = Path(__file__).resolve()
    # Handle symbolic links or weird execution paths by verifying relative location
    if "scripts" in script_path.parts:
         # Standard deployment
         # If in .github/skills/agent-command-creation/scripts, root is 4 levels up
         return script_path.parents[4]
    else:
         # Fallback to CWD
         return Path.cwd()

def resolve_template_dir() -> Path:
    """Resolve the template directory."""
    script_path = Path(__file__).resolve()
    # If standard structure: .../agent-command-creation/scripts/script.py
    # Templates are in .../agent-command-creation/templates
    return script_path.parent.parent / "templates"

def main() -> int:
    parser = argparse.ArgumentParser(description="Generate a new agent command file")
    parser.add_argument("name", help="Command name (use lowercase and hyphens, e.g., analyze-code)")
    parser.add_argument("--agent", required=True, choices=list(AGENT_CONFIG.keys()), help="Target agent platform")
    parser.add_argument("--project", default="project", help="Project name (for Copilot mode)")
    
    args = parser.parse_args()
    
    # Validation: Name format
    if not all(c.islower() or c == '-' or c.isdigit() for c in args.name):
        print(f"Error: Command name '{args.name}' must contain only lowercase letters, numbers, and hyphens.")
        return 1
        
    config = AGENT_CONFIG[args.agent]
    project_root = resolve_root_dir()
    template_dir = resolve_template_dir()
    
    # Setup paths
    target_dir = project_root / config["directory"]
    target_file = target_dir / f"{args.name}{config['extension']}"
    template_file = template_dir / config["template"]
    
    # Ensure template exists
    if not template_file.exists():
        # Fallback to checking relative to CWD if standard resolution fails
        cwd_template = Path.cwd() / ".github/skills/agent-command-creation/templates" / config["template"]
        if cwd_template.exists():
            template_file = cwd_template
        else:
            print(f"Error: Template file not found at {template_file}")
            return 1
            
    # Create target directory
    try:
        target_dir.mkdir(parents=True, exist_ok=True)
    except Exception as e:
        print(f"Error creating directory {target_dir}: {e}")
        return 1
        
    # Check if file exists
    if target_file.exists():
        print(f"Error: File already exists at {target_file}")
        return 1
        
    # Read template and process
    try:
        content = template_file.read_text(encoding="utf-8")
        
        # Simple replacements
        if args.agent == "copilot":
            content = content.replace("project.command-name", f"{args.project}.{args.name}")
        
        # Replace headers if generic
        content = content.replace("# Command Name", f"# {args.name.replace('-', ' ').title()}")
        
        # Write file
        target_file.write_text(content, encoding="utf-8")
        
        print(f"✓ Successfully created command: {target_file}")
        print(f"  Agent: {args.agent}")
        print(f"  Format: {config['extension']}")
        
    except Exception as e:
        print(f"Error writing file: {e}")
        return 1
        
    return 0

if __name__ == "__main__":
    sys.exit(main())
