#!/usr/bin/env python3
"""
Update agent context files with information from design.md

This script maintains AI agent context files by parsing feature specifications
and updating agent-specific configuration files with project information.

Usage: python update-agent-context.py [agent_type]
Agent types: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|codebuddy|amp|shai|q|bob|jules|qoder|antigravity
Leave empty to update all existing agent files
"""

import argparse
import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional

# Import common functions
sys.path.insert(0, os.path.dirname(__file__))
from common import *

# Agent file paths
AGENT_FILES = {
    'claude': 'CLAUDE.md',
    'gemini': 'GEMINI.md',
    'copilot': '.github/agents/copilot-instructions.md',
    'cursor-agent': '.cursor/rules/sunrise-rules.mdc',
    'qwen': 'QWEN.md',
    'opencode': 'AGENTS.md',
    'codex': 'AGENTS.md',
    'windsurf': '.windsurf/rules/sunrise-rules.md',
    'kilocode': '.kilocode/rules/sunrise-rules.md',
    'auggie': '.augment/rules/sunrise-rules.md',
    'roo': '.roo/rules/sunrise-rules.md',
    'codebuddy': 'CODEBUDDY.md',
    'amp': 'AGENTS.md',
    'shai': 'SHAI.md',
    'q': 'AGENTS.md',
    'bob': 'AGENTS.md',
    'jules': 'AGENTS.md',
    'qoder': 'QODER.md',
    'antigravity': 'AGENTS.md'
}

TEMPLATE_FILE = '.sunrise/templates/templates-for-commands/agent-file-template.md'

# Global variables
NEW_LANG = ''
NEW_FRAMEWORK = ''
NEW_DB = ''
NEW_PROJECT_TYPE = ''

def extract_plan_field(field_pattern: str, plan_file: str) -> str:
    """Extract field from plan file"""
    if not Path(plan_file).exists():
        return ''
    with open(plan_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    pattern = rf"^\*\*{re.escape(field_pattern)}\*\*: (.+)$"
    match = re.search(pattern, content, re.MULTILINE)
    if match:
        val = match.group(1).strip()
        if val not in ['NEEDS CLARIFICATION', 'N/A']:
            return val
    return ''

def parse_plan_data(plan_file: str) -> bool:
    """Parse plan data from design.md"""
    global NEW_LANG, NEW_FRAMEWORK, NEW_DB, NEW_PROJECT_TYPE
    
    if not Path(plan_file).exists():
        print_error(f"Plan file not found: {plan_file}")
        return False
    
    print_info(f"Parsing plan data from {plan_file}")
    
    NEW_LANG = extract_plan_field("Language/Version", plan_file)
    NEW_FRAMEWORK = extract_plan_field("Primary Dependencies", plan_file)
    NEW_DB = extract_plan_field("Storage", plan_file)
    NEW_PROJECT_TYPE = extract_plan_field("Project Type", plan_file)
    
    if NEW_LANG:
        print_info(f"Found language: {NEW_LANG}")
    if NEW_FRAMEWORK:
        print_info(f"Found framework: {NEW_FRAMEWORK}")
    if NEW_DB and NEW_DB != 'N/A':
        print_info(f"Found database: {NEW_DB}")
    if NEW_PROJECT_TYPE:
        print_info(f"Found project type: {NEW_PROJECT_TYPE}")
    
    return True

def format_technology_stack(lang: str, framework: str) -> str:
    """Format technology stack string"""
    parts = []
    if lang and lang != 'NEEDS CLARIFICATION':
        parts.append(lang)
    if framework and framework not in ['NEEDS CLARIFICATION', 'N/A']:
        parts.append(framework)
    
    if not parts:
        return ''
    return ' + '.join(parts)

def get_project_structure(project_type: str) -> str:
    """Get project structure based on type"""
    if project_type and 'web' in project_type.lower():
        return "backend/\nfrontend/\ntests/"
    return "src/\ntests/"

def get_commands_for_language(lang: str) -> str:
    """Get commands for language"""
    if 'Python' in lang:
        return "cd src && pytest && ruff check ."
    elif 'Rust' in lang:
        return "cargo test && cargo clippy"
    elif 'JavaScript' in lang or 'TypeScript' in lang:
        return "npm test && npm run lint"
    return f"# Add commands for {lang}"

def get_language_conventions(lang: str) -> str:
    """Get language conventions"""
    return f"{lang}: Follow standard conventions" if lang else "General: Follow standard conventions"

def create_new_agent_file(target_file: str, project_name: str, current_date: str) -> bool:
    """Create new agent file from template"""
    if not Path(TEMPLATE_FILE).exists():
        print_error(f"Template not found at {TEMPLATE_FILE}")
        return False
    
    temp_file = Path(target_file).with_suffix('.tmp')
    
    project_structure = get_project_structure(NEW_PROJECT_TYPE)
    commands = get_commands_for_language(NEW_LANG)
    language_conventions = get_language_conventions(NEW_LANG)
    
    tech_stack = format_technology_stack(NEW_LANG, NEW_FRAMEWORK)
    if NEW_LANG and NEW_FRAMEWORK:
        tech_stack_template = f"- {NEW_LANG} + {NEW_FRAMEWORK} ({CURRENT_BRANCH})"
    elif NEW_LANG:
        tech_stack_template = f"- {NEW_LANG} ({CURRENT_BRANCH})"
    elif NEW_FRAMEWORK:
        tech_stack_template = f"- {NEW_FRAMEWORK} ({CURRENT_BRANCH})"
    else:
        tech_stack_template = f"- ({CURRENT_BRANCH})"
    
    if NEW_LANG and NEW_FRAMEWORK:
        recent_change = f"- {CURRENT_BRANCH}: Added {NEW_LANG} + {NEW_FRAMEWORK}"
    elif NEW_LANG:
        recent_change = f"- {CURRENT_BRANCH}: Added {NEW_LANG}"
    elif NEW_FRAMEWORK:
        recent_change = f"- {CURRENT_BRANCH}: Added {NEW_FRAMEWORK}"
    else:
        recent_change = f"- {CURRENT_BRANCH}: Added"
    
    # Read template and replace
    with open(TEMPLATE_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = content.replace('[PROJECT NAME]', project_name)
    content = content.replace('[DATE]', current_date)
    content = content.replace('[EXTRACTED FROM ALL DESIGN.MD FILES]', tech_stack_template)
    content = content.replace('[ACTUAL STRUCTURE FROM PLANS]', project_structure)
    content = content.replace('[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES]', commands)
    content = content.replace('[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE]', language_conventions)
    content = content.replace('[LAST 3 FEATURES AND WHAT THEY ADDED]', recent_change)
    content = content.replace('\\n', '\n')  # Convert escaped newlines
    
    with open(temp_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    # Move to target
    temp_file.replace(target_file)
    return True

def update_existing_agent_file(target_file: str, current_date: str) -> bool:
    """Update existing agent file"""
    tech_stack = format_technology_stack(NEW_LANG, NEW_FRAMEWORK)
    new_tech_entries = []
    if tech_stack:
        escaped_tech = re.escape(tech_stack)
        if not re.search(escaped_tech, Path(target_file).read_text(encoding='utf-8')):
            new_tech_entries.append(f"- {tech_stack} ({CURRENT_BRANCH})")
    
    if NEW_DB and NEW_DB not in ['N/A', 'NEEDS CLARIFICATION']:
        escaped_db = re.escape(NEW_DB)
        if not re.search(escaped_db, Path(target_file).read_text(encoding='utf-8')):
            new_tech_entries.append(f"- {NEW_DB} ({CURRENT_BRANCH})")
    
    new_change_entry = ''
    if tech_stack:
        new_change_entry = f"- {CURRENT_BRANCH}: Added {tech_stack}"
    elif NEW_DB and NEW_DB not in ['N/A', 'NEEDS CLARIFICATION']:
        new_change_entry = f"- {CURRENT_BRANCH}: Added {NEW_DB}"
    
    with open(target_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    output = []
    in_tech = False
    in_changes = False
    tech_added = False
    change_added = False
    existing_changes = 0
    
    for line in lines:
        if line.strip() == '## Active Technologies':
            output.append(line)
            in_tech = True
            continue
        if in_tech and line.strip().startswith('## '):
            if not tech_added and new_tech_entries:
                output.extend(f"{entry}\n" for entry in new_tech_entries)
                tech_added = True
            output.append(line)
            in_tech = False
            continue
        if in_tech and not line.strip():
            if not tech_added and new_tech_entries:
                output.extend(f"{entry}\n" for entry in new_tech_entries)
                tech_added = True
            output.append(line)
            continue
        
        if line.strip() == '## Recent Changes':
            output.append(line)
            if new_change_entry:
                output.append(f"{new_change_entry}\n")
            in_changes = True
            change_added = True
            continue
        if in_changes and line.strip().startswith('## '):
            output.append(line)
            in_changes = False
            continue
        if in_changes and line.startswith('- '):
            if existing_changes < 2:
                output.append(line)
                existing_changes += 1
            continue
        
        # Update timestamp
        if re.search(r'\*\*Last updated\*\*: .*\d{4}-\d{2}-\d{2}', line):
            line = re.sub(r'\d{4}-\d{2}-\d{2}', current_date, line)
        output.append(line)
    
    # Post-loop
    if in_tech and not tech_added and new_tech_entries:
        output.extend(f"{entry}\n" for entry in new_tech_entries)
    
    with open(target_file, 'w', encoding='utf-8') as f:
        f.writelines(output)
    
    return True

def update_agent_file(target_file: str, agent_name: str) -> bool:
    """Update agent file"""
    print_info(f"Updating {agent_name} context file: {target_file}")
    
    repo_root = get_repo_root()
    current_branch = get_current_branch()
    current_date = datetime.now().strftime('%Y-%m-%d')
    
    # Create dir if needed
    Path(target_file).parent.mkdir(parents=True, exist_ok=True)
    
    if not Path(target_file).exists():
        # Create new
        project_name = Path(repo_root).name
        if create_new_agent_file(target_file, project_name, current_date):
            print_success(f"Created new {agent_name} context file")
        else:
            print_error(f"Failed to create new agent file")
            return False
    else:
        # Update existing
        if update_existing_agent_file(target_file, current_date):
            print_success(f"Updated existing {agent_name} context file")
        else:
            print_error("Failed to update existing agent file")
            return False
    
    return True

def update_specific_agent(agent_type: str) -> bool:
    """Update specific agent"""
    if agent_type not in AGENT_FILES:
        print_error(f"Unknown agent type '{agent_type}'")
        print_error("Expected: " + '|'.join(AGENT_FILES.keys()))
        return False
    
    repo_root = get_repo_root()
    target_file = str(Path(repo_root) / AGENT_FILES[agent_type])
    
    agent_names = {
        'claude': 'Claude Code',
        'gemini': 'Gemini CLI',
        'copilot': 'GitHub Copilot',
        'cursor-agent': 'Cursor IDE',
        'qwen': 'Qwen Code',
        'opencode': 'opencode',
        'codex': 'Codex CLI',
        'windsurf': 'Windsurf',
        'kilocode': 'Kilo Code',
        'auggie': 'Auggie CLI',
        'roo': 'Roo Code',
        'codebuddy': 'CodeBuddy CLI',
        'amp': 'Amp',
        'shai': 'SHAI',
        'q': 'Amazon Q Developer CLI',
        'bob': 'IBM Bob',
        'jules': 'Jules',
        'qoder': 'Qoder CLI',
        'antigravity': 'Google Antigravity'
    }
    
    agent_name = agent_names.get(agent_type, agent_type)
    return update_agent_file(target_file, agent_name)

def update_all_existing_agents() -> bool:
    """Update all existing agents"""
    repo_root = get_repo_root()
    found = False
    success = True
    
    for agent_type, file_path in AGENT_FILES.items():
        full_path = Path(repo_root) / file_path
        if full_path.exists():
            agent_names = {
                'claude': 'Claude Code',
                'gemini': 'Gemini CLI',
                'copilot': 'GitHub Copilot',
                'cursor-agent': 'Cursor IDE',
                'qwen': 'Qwen Code',
                'opencode': 'Codex/opencode',
                'codex': 'Codex/opencode',
                'windsurf': 'Windsurf',
                'kilocode': 'Kilo Code',
                'auggie': 'Auggie CLI',
                'roo': 'Roo Code',
                'codebuddy': 'CodeBuddy CLI',
                'shai': 'SHAI',
                'q': 'Amazon Q Developer CLI',
                'bob': 'IBM Bob',
                'jules': 'Jules',
                'qoder': 'Qoder CLI',
                'antigravity': 'Google Antigravity',
                'amp': 'Amp'
            }
            agent_name = agent_names.get(agent_type, agent_type)
            if not update_agent_file(str(full_path), agent_name):
                success = False
            found = True
    
    if not found:
        print_info("No existing agent files found, creating default Claude file...")
        if not update_specific_agent('claude'):
            success = False
    
    return success

def print_summary():
    """Print summary"""
    print()
    print_info("Summary of changes:")
    if NEW_LANG:
        print(f"  - Added language: {NEW_LANG}")
    if NEW_FRAMEWORK:
        print(f"  - Added framework: {NEW_FRAMEWORK}")
    if NEW_DB and NEW_DB != 'N/A':
        print(f"  - Added database: {NEW_DB}")
    print()
    print_info("Usage: python update-agent-context.py [agent_type]")
    print_info("Agent types: " + '|'.join(AGENT_FILES.keys()))

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="Update agent context files")
    parser.add_argument('agent_type', nargs='?', help='Agent type to update')
    args = parser.parse_args()
    
    # Get paths
    paths = get_feature_paths()
    global CURRENT_BRANCH
    CURRENT_BRANCH = paths['CURRENT_BRANCH']
    NEW_PLAN = paths['FEATURE_DESIGN']
    
    # Validate
    if not check_feature_branch(CURRENT_BRANCH, paths['HAS_GIT'] == 'true'):
        sys.exit(1)
    
    if not Path(NEW_PLAN).exists():
        print_error(f"No design.md found at {NEW_PLAN}")
        print_info("Make sure you're working on a feature with a corresponding spec directory")
        sys.exit(1)
    
    if not Path(TEMPLATE_FILE).exists():
        print_error(f"Template file not found at {TEMPLATE_FILE}")
        sys.exit(1)
    
    print_info(f"=== Updating agent context files for feature {CURRENT_BRANCH} ===")
    
    # Parse plan
    if not parse_plan_data(NEW_PLAN):
        print_error("Failed to parse plan data")
        sys.exit(1)
    
    success = True
    
    if args.agent_type:
        print_info(f"Updating specific agent: {args.agent_type}")
        if not update_specific_agent(args.agent_type):
            success = False
    else:
        print_info("No agent specified, updating all existing agent files...")
        if not update_all_existing_agents():
            success = False
    
    print_summary()
    
    if success:
        print_success("Agent context update completed successfully")
        sys.exit(0)
    else:
        print_error("Agent context update completed with errors")
        sys.exit(1)

if __name__ == '__main__':
    main()