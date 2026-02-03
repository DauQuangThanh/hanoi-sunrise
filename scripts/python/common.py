import os
import subprocess
import re
import sys
from pathlib import Path
from typing import Dict, List

def get_repo_root() -> str:
    try:
        result = subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        # Fallback to script location
        script_dir = Path(__file__).parent
        return str(script_dir / '../../..')

def get_current_branch() -> str:
    # Check SPECIFY_FEATURE
    specify = os.getenv('SPECIFY_FEATURE')
    if specify:
        return specify

    # Check git
    try:
        result = subprocess.run(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        pass

    # Find latest feature dir
    repo_root = get_repo_root()
    specs_dir = Path(repo_root) / 'specs'
    if specs_dir.exists():
        highest = 0
        latest_feature = ''
        for d in specs_dir.iterdir():
            if d.is_dir():
                m = re.match(r'^(\d{3})-', d.name)
                if m:
                    num = int(m.group(1))
                    if num > highest:
                        highest = num
                        latest_feature = d.name
        if latest_feature:
            return latest_feature
    return 'main'

def has_git() -> bool:
    try:
        subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def check_feature_branch(branch: str, has_git: bool) -> bool:
    if not has_git:
        print("[sunrise] Warning: Git repository not detected; skipped branch validation")
        return True
    if not re.match(r'^\d{3}-', branch):
        print(f"ERROR: Not on a feature branch. Current branch: {branch}")
        print("Feature branches should be named like: 001-feature-name")
        return False
    return True

def get_feature_dir(repo_root: str, branch: str) -> str:
    return str(Path(repo_root) / 'specs' / branch)

def find_feature_dir_by_prefix(repo_root: str, branch_name: str) -> str:
    specs_dir = Path(repo_root) / 'specs'
    m = re.match(r'^(\d{3})-', branch_name)
    if not m:
        return str(specs_dir / branch_name)
    prefix = m.group(1)
    matching = [d for d in specs_dir.iterdir() if d.is_dir() and d.name.startswith(f'{prefix}-')]
    if not matching:
        return str(specs_dir / branch_name)
    elif len(matching) == 1:
        return str(matching[0])
    else:
        print(f"ERROR: Multiple spec directories found with prefix '{prefix}': {[d.name for d in matching]}")
        print("Please ensure only one spec directory exists per numeric prefix.")
        return str(specs_dir / branch_name)

def get_feature_paths() -> Dict[str, str]:
    repo_root = get_repo_root()
    current_branch = get_current_branch()
    has_git_bool = has_git()
    feature_dir = find_feature_dir_by_prefix(repo_root, current_branch)
    return {
        'REPO_ROOT': repo_root,
        'CURRENT_BRANCH': current_branch,
        'HAS_GIT': str(has_git_bool).lower(),
        'FEATURE_DIR': feature_dir,
        'FEATURE_SPEC': str(Path(feature_dir) / 'spec.md'),
        'FEATURE_DESIGN': str(Path(feature_dir) / 'design.md'),
        'TASKS': str(Path(feature_dir) / 'tasks.md'),
        'RESEARCH': str(Path(feature_dir) / 'research.md'),
        'DATA_MODEL': str(Path(feature_dir) / 'data-model.md'),
        'QUICKSTART': str(Path(feature_dir) / 'quickstart.md'),
        'CONTRACTS_DIR': str(Path(feature_dir) / 'contracts'),
    }

def check_file(path: str, description: str) -> None:
    if Path(path).is_file():
        print(f"  ✓ {description}")
    else:
        print(f"  ✗ {description}")

def check_dir(path: str, description: str) -> None:
    p = Path(path)
    if p.is_dir() and any(p.iterdir()):
        print(f"  ✓ {description}")
    else:
        print(f"  ✗ {description}")

def print_success(message: str) -> None:
    print(f"\033[0;32m{message}\033[0m")

def print_info(message: str) -> None:
    print(f"\033[0;36m{message}\033[0m")

def print_warning(message: str) -> None:
    print(f"\033[0;33m{message}\033[0m")

def print_error(message: str) -> None:
    print(f"\033[0;31m{message}\033[0m", file=sys.stderr)

def detect_ai_agent(repo_root: str) -> str:
    checks = [
        ('.claude/commands', 'claude'),
        ('.github/agents', 'copilot'),
        ('.cursor/commands', 'cursor'),
        ('.windsurf/workflows', 'windsurf'),
        ('.windsurf/rules', 'windsurf'),
        ('.gemini/commands', 'gemini'),
        ('.qwen/commands', 'qwen'),
        ('.opencode/command', 'opencode'),
        ('.codex/commands', 'codex'),
        ('.kilocode/rules', 'kilocode'),
        ('.augment/rules', 'auggie'),
        ('.roo/rules', 'roo'),
        ('.codebuddy/commands', 'codebuddy'),
        ('.amazonq/prompts', 'q'),
        ('.agents/commands', 'amp'),
        ('.shai/commands', 'shai'),
        ('.bob/commands', 'bob'),
        ('.qoder/commands', 'qoder'),
    ]
    for check_path, agent in checks:
        if Path(repo_root, check_path).exists():
            return agent

    # Special checks
    if Path(repo_root, '.agent').exists() and Path(repo_root, 'AGENTS.md').is_file():
        return 'jules'
    if Path(repo_root, '.agent/rules').exists() or Path(repo_root, '.agent/skills').exists():
        return 'antigravity'
    return 'unknown'

def detect_all_ai_agents(repo_root: str) -> List[str]:
    agents = []
    checks = [
        ('.claude/commands', 'claude'),
        ('.github/agents', 'copilot'),
        ('.cursor/commands', 'cursor'),
        ('.windsurf/workflows', 'windsurf'),
        ('.windsurf/rules', 'windsurf'),
        ('.gemini/commands', 'gemini'),
        ('.qwen/commands', 'qwen'),
        ('.opencode/command', 'opencode'),
        ('.codex/commands', 'codex'),
        ('.kilocode/rules', 'kilocode'),
        ('.augment/rules', 'auggie'),
        ('.roo/rules', 'roo'),
        ('.codebuddy/commands', 'codebuddy'),
        ('.amazonq/prompts', 'q'),
        ('.agents/commands', 'amp'),
        ('.shai/commands', 'shai'),
        ('.bob/commands', 'bob'),
        ('.qoder/commands', 'qoder'),
    ]
    for check_path, agent in checks:
        if Path(repo_root, check_path).exists():
            agents.append(agent)

    # Special
    if Path(repo_root, '.agent').exists() and Path(repo_root, 'AGENTS.md').is_file():
        if 'jules' not in agents:
            agents.append('jules')
    if (Path(repo_root, '.agent/rules').exists() or Path(repo_root, '.agent/skills').exists()) and 'antigravity' not in agents:
        agents.append('antigravity')

    return agents if agents else ['unknown']

def get_skills_folder(agent: str) -> str:
    mapping = {
        'copilot': '.github/skills',
        'claude': '.claude/skills',
        'gemini': '.gemini/extensions',
        'cursor': '.cursor/rules',
        'qwen': '.qwen/skills',
        'opencode': '.opencode/skill',
        'codex': '.codex/skills',
        'windsurf': '.windsurf/skills',
        'kilocode': '.kilocode/skills',
        'auggie': '.augment/rules',
        'codebuddy': '.codebuddy/skills',
        'roo': '.roo/skills',
        'q': '.amazonq/cli-agents',
        'amp': '.agents/skills',
        'shai': '.shai/commands',
        'bob': '.bob/skills',
        'jules': 'skills',
        'qoder': '.qoder/skills',
        'antigravity': '.agent/skills',
    }
    return mapping.get(agent, '')