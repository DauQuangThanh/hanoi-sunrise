#!/usr/bin/env bash
# Update agent context files with assessment findings
# This is a portable skill-local version

set -e

AGENT_TYPE="${1:-}"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}INFO:${NC} $1"; }
log_warn() { echo -e "${YELLOW}WARNING:${NC} $1"; }
log_error() { echo -e "${RED}ERROR:${NC} $1" >&2; }

# Get script directory (skill's scripts/ folder)
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Detect repository root
find_repo_root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "$PWD"
}

REPO_ROOT=$(find_repo_root)
CONTEXT_ASSESSMENT="$REPO_ROOT/docs/context-assessment.md"

# Validate environment
if [[ ! -f "$CONTEXT_ASSESSMENT" ]]; then
    log_error "Context assessment not found at $CONTEXT_ASSESSMENT"
    log_info "Run setup-context-assessment.sh first"
    exit 1
fi

# Define agent file paths
declare -A AGENT_FILES=(
    ["claude"]="$REPO_ROOT/CLAUDE.md"
    ["gemini"]="$REPO_ROOT/GEMINI.md"
    ["copilot"]="$REPO_ROOT/.github/agents/copilot-instructions.md"
    ["cursor-agent"]="$REPO_ROOT/.cursor/rules/sunrise-rules.mdc"
    ["qwen"]="$REPO_ROOT/QWEN.md"
    ["opencode"]="$REPO_ROOT/AGENTS.md"
    ["codex"]="$REPO_ROOT/AGENTS.md"
    ["windsurf"]="$REPO_ROOT/.windsurf/rules/sunrise-rules.md"
    ["kilocode"]="$REPO_ROOT/.kilocode/rules/sunrise-rules.md"
    ["auggie"]="$REPO_ROOT/.augment/rules/sunrise-rules.md"
    ["roo"]="$REPO_ROOT/.roo/rules/sunrise-rules.md"
    ["codebuddy"]="$REPO_ROOT/CODEBUDDY.md"
    ["amp"]="$REPO_ROOT/AGENTS.md"
    ["shai"]="$REPO_ROOT/SHAI.md"
    ["q"]="$REPO_ROOT/AGENTS.md"
    ["bob"]="$REPO_ROOT/AGENTS.md"
    ["jules"]="$REPO_ROOT/AGENTS.md"
    ["qoder"]="$REPO_ROOT/QODER.md"
    ["antigravity"]="$REPO_ROOT/AGENTS.md"
)

# Extract key findings from assessment
extract_summary() {
    local file="$1"
    
    # Extract technical health score
    local score=$(grep -E "^\*\*Technical Health Score\*\*: [0-9]+/100" "$file" 2>/dev/null | \
        sed 's/\*\*Technical Health Score\*\*: //' | head -1)
    
    # Extract key findings (first 3 bullet points under Key Findings)
    local findings=$(sed -n '/^\*\*Key Findings\*\*:/,/^\*\*/p' "$file" 2>/dev/null | \
        grep '^- ' | head -3 | sed 's/^- /  • /')
    
    echo "## Context Assessment Summary"
    echo ""
    echo "**Assessment Date**: $(date '+%Y-%m-%d')"
    if [[ -n "$score" ]]; then
        echo "**Technical Health Score**: $score"
    fi
    echo ""
    if [[ -n "$findings" ]]; then
        echo "**Key Findings**:"
        echo "$findings"
    fi
    echo ""
    echo "**Full Assessment**: See \`docs/context-assessment.md\`"
    echo ""
}

# Update a single agent file
update_agent_file() {
    local agent_key="$1"
    local agent_file="${AGENT_FILES[$agent_key]}"
    
    if [[ ! -f "$agent_file" ]]; then
        log_warn "Agent file not found: $agent_file (skipping $agent_key)"
        return 0
    fi
    
    log_info "Updating $agent_key context at $agent_file"
    
    # Extract summary
    local summary=$(extract_summary "$CONTEXT_ASSESSMENT")
    
    # Check if file has context assessment marker
    if grep -q "<!-- CONTEXT_ASSESSMENT_START -->" "$agent_file" 2>/dev/null; then
        # Update existing section
        local temp_file=$(mktemp)
        awk -v summary="$summary" '
            /<!-- CONTEXT_ASSESSMENT_START -->/ {
                print
                print summary
                skip = 1
                next
            }
            /<!-- CONTEXT_ASSESSMENT_END -->/ {
                skip = 0
            }
            !skip
        ' "$agent_file" > "$temp_file"
        mv "$temp_file" "$agent_file"
        log_info "✓ Updated context assessment section in $agent_key"
    else
        # Append new section
        {
            echo ""
            echo "<!-- CONTEXT_ASSESSMENT_START -->"
            echo "$summary"
            echo "<!-- CONTEXT_ASSESSMENT_END -->"
        } >> "$agent_file"
        log_info "✓ Added context assessment section to $agent_key"
    fi
}

# Main execution
if [[ -n "$AGENT_TYPE" ]]; then
    # Update specific agent
    if [[ -z "${AGENT_FILES[$AGENT_TYPE]}" ]]; then
        log_error "Unknown agent type: $AGENT_TYPE"
        log_info "Supported agents: ${!AGENT_FILES[*]}"
        exit 1
    fi
    update_agent_file "$AGENT_TYPE"
else
    # Update all existing agent files
    local updated=0
    for agent_key in "${!AGENT_FILES[@]}"; do
        local agent_file="${AGENT_FILES[$agent_key]}"
        if [[ -f "$agent_file" ]]; then
            update_agent_file "$agent_key"
            ((updated++))
        fi
    done
    
    if [[ $updated -eq 0 ]]; then
        log_warn "No agent files found in repository"
        log_info "Create an agent file first, then run this script"
    else
        log_info "✓ Updated $updated agent file(s)"
    fi
fi

log_info "✓ Agent context update complete"
