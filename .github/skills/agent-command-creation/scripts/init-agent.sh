#!/usr/bin/env bash
# init-agent.sh - Initialize agent command structure for various platforms
# Author: Dau Quang Thanh
# License: MIT

set -eo pipefail

# Get platform folder
get_platform_folder() {
    case "$1" in
        claude) echo ".claude/commands" ;;
        copilot-agent) echo ".github/agents" ;;
        copilot-prompt) echo ".github/prompts" ;;
        cursor) echo ".cursor/commands" ;;
        windsurf) echo ".windsurf/workflows" ;;
        gemini) echo ".gemini/commands" ;;
        qwen) echo ".qwen/commands" ;;
        antigravity) echo ".agent/rules" ;;
        amazonq) echo ".amazonq/prompts" ;;
        kilo) echo ".kilocode/rules" ;;
        roo) echo ".roo/rules" ;;
        bob) echo ".bob/commands" ;;
        jules) echo ".agent" ;;
        amp) echo ".agents/commands" ;;
        auggie) echo ".augment/rules" ;;
        qoder) echo ".qoder/commands" ;;
        codebuddy) echo ".codebuddy/commands" ;;
        codex) echo ".codex/commands" ;;
        shai) echo ".shai/commands" ;;
        opencode) echo ".opencode/command" ;;
        *) echo "" ;;
    esac
}

# Get platform extension
get_platform_extension() {
    case "$1" in
        claude) echo "md" ;;
        copilot-agent) echo "agent.md" ;;
        copilot-prompt) echo "prompt.md" ;;
        cursor) echo "md" ;;
        windsurf) echo "md" ;;
        gemini) echo "toml" ;;
        qwen) echo "toml" ;;
        antigravity) echo "md" ;;
        amazonq) echo "md" ;;
        kilo) echo "md" ;;
        roo) echo "md" ;;
        bob) echo "md" ;;
        jules) echo "md" ;;
        amp) echo "md" ;;
        auggie) echo "md" ;;
        qoder) echo "md" ;;
        codebuddy) echo "md" ;;
        codex) echo "md" ;;
        shai) echo "md" ;;
        opencode) echo "md" ;;
        *) echo "" ;;
    esac
}

# Display usage
usage() {
    cat << EOF
Usage: $0 <platform> <command-name> [project-name]

Initialize agent command structure for various AI platforms.

Platforms:
  claude              - Claude Code (.claude/commands/)
  copilot-agent       - GitHub Copilot Agent (.github/agents/)
  copilot-prompt      - GitHub Copilot Prompt (.github/prompts/)
  cursor              - Cursor (.cursor/commands/)
  windsurf            - Windsurf (.windsurf/workflows/)
  gemini              - Gemini CLI (.gemini/commands/)
  qwen                - Qwen Code (.qwen/commands/)
  antigravity         - Google Antigravity (.agent/rules/)
  amazonq             - Amazon Q CLI (.amazonq/prompts/)
  kilo                - Kilo Code (.kilocode/rules/)
  roo                 - Roo Code (.roo/rules/)
  bob                 - IBM Bob (.bob/commands/)
  jules               - Jules (.agent/)
  amp                 - Amp (.agents/commands/)
  auggie              - Auggie CLI (.augment/rules/)
  qoder               - Qoder CLI (.qoder/commands/)
  codebuddy           - CodeBuddy CLI (.codebuddy/commands/)
  codex               - Codex CLI (.codex/commands/)
  shai                - SHAI (.shai/commands/)
  opencode            - opencode (.opencode/command/)

Arguments:
  command-name        - Name of the command (e.g., analyze-security)
  project-name        - Project name for mode field (GitHub Copilot only)

Examples:
  $0 claude review-pr
  $0 copilot-prompt security vinh
  $0 gemini generate-tests
  $0 cursor validate-code

EOF
    exit 1
}

# Validate inputs
if [[ $# -lt 2 ]]; then
    echo "Error: Missing required arguments"
    usage
fi

PLATFORM="$1"
COMMAND_NAME="$2"
PROJECT_NAME="${3:-}"

# Get platform configuration
FOLDER=$(get_platform_folder "$PLATFORM")
EXTENSION=$(get_platform_extension "$PLATFORM")

# Validate platform
if [[ -z "$FOLDER" ]]; then
    echo "Error: Unknown platform '$PLATFORM'"
    usage
fi

# Validate command name format
if [[ ! "$COMMAND_NAME" =~ ^[a-z]+(-[a-z]+)*$ ]]; then
    echo "Error: Command name must be lowercase with hyphens (e.g., analyze-security)"
    exit 1
fi

# Create folder structure
mkdir -p "$FOLDER"
echo "✓ Created folder: $FOLDER"

# Generate file path
if [[ "$EXTENSION" == "agent.md" ]] || [[ "$EXTENSION" == "prompt.md" ]]; then
    FILE_PATH="$FOLDER/$COMMAND_NAME.$EXTENSION"
else
    FILE_PATH="$FOLDER/$COMMAND_NAME.$EXTENSION"
fi

# Check if file already exists
if [[ -f "$FILE_PATH" ]]; then
    echo "Warning: File already exists: $FILE_PATH"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Generate content based on format
if [[ "$EXTENSION" == "toml" ]]; then
    # TOML format (Gemini CLI, Qwen Code)
    cat > "$FILE_PATH" << 'EOF'
description = "TODO: Add description"

prompt = """
# Command Name

## Purpose
TODO: Explain the command's purpose and when to use it

## Context
TODO: Describe what context/information is needed

## Instructions
TODO: Provide step-by-step instructions for the AI agent

1. First step
2. Second step
3. Third step

## Output Format
TODO: Specify the expected output structure

## Examples
TODO: Provide concrete examples if applicable

Arguments: {{args}}
"""
EOF
else
    # Markdown format
    cat > "$FILE_PATH" << 'EOF'
---
description: "TODO: Add description"
---

# Command Name

## Purpose
TODO: Explain the command's purpose and when to use it

## Context
TODO: Describe what context/information is needed

## Instructions
TODO: Provide step-by-step instructions for the AI agent

1. First step
2. Second step
3. Third step

## Output Format
TODO: Specify the expected output structure

## Examples
TODO: Provide concrete examples if applicable

Arguments: $ARGUMENTS
EOF

    # Add mode field for GitHub Copilot prompts
    if [[ "$PLATFORM" == "copilot-prompt" ]]; then
        if [[ -z "$PROJECT_NAME" ]]; then
            echo "Error: Project name required for GitHub Copilot prompts"
            echo "Usage: $0 copilot-prompt <command-name> <project-name>"
            rm "$FILE_PATH"
            exit 1
        fi
        
        # Insert mode field after description
        sed -i.bak "2i\\
mode: $PROJECT_NAME.$COMMAND_NAME
" "$FILE_PATH" && rm "$FILE_PATH.bak"
    fi
fi

echo "✓ Created file: $FILE_PATH"
echo ""
echo "Next steps:"
echo "1. Edit $FILE_PATH"
echo "2. Replace TODO placeholders with actual content"
echo "3. Test the command with your AI agent"
echo ""
echo "Usage example:"
if [[ "$EXTENSION" == "toml" ]]; then
    echo "  <agent> $COMMAND_NAME <arguments>"
else
    echo "  /$COMMAND_NAME <arguments>"
fi
