#!/usr/bin/env bash
# Setup context assessment for brownfield project
# This is a portable skill-local version

set -e

# Parse command line arguments
JSON_MODE=false

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
            exit 0
            ;;
    esac
done

# Get script directory (skill's scripts/ folder)
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Detect repository root (search upward for .git or go to parent until root)
find_repo_root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    # If no .git found, use current directory
    echo "$PWD"
}

REPO_ROOT=$(find_repo_root)

# Ensure the docs directory exists
DOCS_DIR="$REPO_ROOT/docs"
mkdir -p "$DOCS_DIR"

# Set the context assessment file path (project-level, not feature-specific)
CONTEXT_ASSESSMENT="$DOCS_DIR/context-assessment.md"

# Copy template from skill directory
TEMPLATE="$SKILL_DIR/templates/context-assessment-template.md"
if [[ -f "$TEMPLATE" ]]; then
    cp "$TEMPLATE" "$CONTEXT_ASSESSMENT"
    if [[ "$JSON_MODE" != "true" ]]; then
        echo "✓ Copied context assessment template to $CONTEXT_ASSESSMENT"
    fi
else
    if [[ "$JSON_MODE" != "true" ]]; then
        echo "WARNING: Context assessment template not found at $TEMPLATE" >&2
        echo "Creating empty assessment file" >&2
    fi
    touch "$CONTEXT_ASSESSMENT"
fi

# Check if we're in a git repo
HAS_GIT="false"
if [[ -d "$REPO_ROOT/.git" ]]; then
    HAS_GIT="true"
fi

# Output results
if $JSON_MODE; then
    printf '{"CONTEXT_ASSESSMENT":"%s","DOCS_DIR":"%s","REPO_ROOT":"%s","HAS_GIT":"%s"}\n' \
        "$CONTEXT_ASSESSMENT" "$DOCS_DIR" "$REPO_ROOT" "$HAS_GIT"
else
    echo "Repository root: $REPO_ROOT"
    echo "Documentation directory: $DOCS_DIR"
    echo "Assessment file: $CONTEXT_ASSESSMENT"
    echo "Git repository: $HAS_GIT"
    echo ""
    echo "✓ Setup complete. Context assessment template is ready at:"
    echo "  $CONTEXT_ASSESSMENT"
fi
