#!/usr/bin/env bash
# Update agent context files with architecture decisions
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
ARCH_DOC="$REPO_ROOT/docs/architecture.md"

# Validate environment
if [[ ! -f "$ARCH_DOC" ]]; then
    log_error "Architecture document not found at $ARCH_DOC"
    log_info "Run setup-architect.sh first"
    exit 1
fi

# Define agent file paths
declare -A AGENT_FILES=(
    ["claude"]="$REPO_ROOT/CLAUDE.md"
    ["gemini"]="$REPO_ROOT/GEMINI.md"
    ["copilot"]="$REPO_ROOT/.github/agents/copilot-instructions.md"
    ["cursor-agent"]="$REPO_ROOT/.cursor/rules/phoenix-rules.mdc"
    ["qwen"]="$REPO_ROOT/QWEN.md"
    ["opencode"]="$REPO_ROOT/AGENTS.md"
    ["codex"]="$REPO_ROOT/AGENTS.md"
    ["windsurf"]="$REPO_ROOT/.windsurf/rules/phoenix-rules.md"
    ["kilocode"]="$REPO_ROOT/.kilocode/rules/phoenix-rules.md"
    ["auggie"]="$REPO_ROOT/.augment/rules/phoenix-rules.md"
    ["roo"]="$REPO_ROOT/.roo/rules/phoenix-rules.md"
    ["codebuddy"]="$REPO_ROOT/CODEBUDDY.md"
    ["amp"]="$REPO_ROOT/AGENTS.md"
    ["shai"]="$REPO_ROOT/SHAI.md"
    ["q"]="$REPO_ROOT/AGENTS.md"
    ["bob"]="$REPO_ROOT/AGENTS.md"
    ["jules"]="$REPO_ROOT/AGENTS.md"
    ["qoder"]="$REPO_ROOT/QODER.md"
    ["antigravity"]="$REPO_ROOT/AGENTS.md"
)

# Extract architecture summary
extract_summary() {
    local file="$1"
    
    # Extract executive summary (What, Why, Core Tech)
    local what=$(grep -A 1 '^\*\*What\*\*:' "$file" 2>/dev/null | tail -1 | sed 's/^- //')
    local why=$(grep -A 1 '^\*\*Why\*\*:' "$file" 2>/dev/null | tail -1 | sed 's/^- //')
    local tech=$(grep -A 1 '^\*\*Core Tech\*\*:' "$file" 2>/dev/null | tail -1 | sed 's/^- //')
    
    # Extract key ADRs (first 3)
    local adrs=$(sed -n '/^| ADR-/p' "$file" 2>/dev/null | head -3 | \
        awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $3); gsub(/^[ \t]+|[ \t]+$/, "", $4); print "  • " $3 " (" $4 ")"}')
    
    # Extract quality targets
    local perf=$(sed -n '/^### 6.1 Performance/,/^###/p' "$file" 2>/dev/null | grep '^- Targets:' | sed 's/^- Targets: //')
    local avail=$(sed -n '/^### 6.3 Availability/,/^###/p' "$file" 2>/dev/null | grep '^- Targets:' | sed 's/^- Targets: //')
    
    echo "## Architecture Summary"
    echo ""
    echo "**Last Updated**: $(date '+%Y-%m-%d')"
    echo ""
    if [[ -n "$what" ]]; then
        echo "**System Purpose**: $what"
    fi
    if [[ -n "$tech" ]]; then
        echo "**Technology Stack**: $tech"
    fi
    echo ""
    if [[ -n "$adrs" ]]; then
        echo "**Key Architecture Decisions**:"
        echo "$adrs"
        echo ""
    fi
    if [[ -n "$perf" ]] || [[ -n "$avail" ]]; then
        echo "**Quality Targets**:"
        [[ -n "$perf" ]] && echo "  • Performance: $perf"
        [[ -n "$avail" ]] && echo "  • Availability: $avail"
        echo ""
    fi
    echo "**Full Architecture**: See \`docs/architecture.md\`"
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
    local summary=$(extract_summary "$ARCH_DOC")
    
    # Check if file has architecture marker
    if grep -q "<!-- ARCHITECTURE_START -->" "$agent_file" 2>/dev/null; then
        # Update existing section
        local temp_file=$(mktemp)
        awk -v summary="$summary" '
            /<!-- ARCHITECTURE_START -->/ {
                print
                print summary
                skip = 1
                next
            }
            /<!-- ARCHITECTURE_END -->/ {
                skip = 0
            }
            !skip
        ' "$agent_file" > "$temp_file"
        mv "$temp_file" "$agent_file"
        log_info "✓ Updated architecture section in $agent_key"
    else
        # Append new section
        {
            echo ""
            echo "<!-- ARCHITECTURE_START -->"
            echo "$summary"
            echo "<!-- ARCHITECTURE_END -->"
        } >> "$agent_file"
        log_info "✓ Added architecture section to $agent_key"
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
