#!/usr/bin/env bash
# check-prerequisites.sh - Locate feature specification file
#
# Usage:
#   ./check-prerequisites.sh --json --paths-only
#   ./check-prerequisites.sh
#
# Arguments:
#   --json         Output results in JSON format
#   --paths-only   Only return path information (no validation)
#
# Requirements:
#   - bash 4.0+
#   - git (optional)

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
OUTPUT_JSON=false
PATHS_ONLY=false

# Function to print colored messages
print_info() {
    if [[ "$OUTPUT_JSON" == "false" ]]; then
        echo -e "${BLUE}ℹ ${NC}$1"
    fi
}

print_success() {
    if [[ "$OUTPUT_JSON" == "false" ]]; then
        echo -e "${GREEN}✓${NC} $1"
    fi
}

print_error() {
    if [[ "$OUTPUT_JSON" == "false" ]]; then
        echo -e "${RED}✗${NC} $1" >&2
    else
        echo "{\"error\": \"$1\"}" >&2
    fi
}

print_warning() {
    if [[ "$OUTPUT_JSON" == "false" ]]; then
        echo -e "${YELLOW}⚠${NC} $1" >&2
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --paths-only)
            PATHS_ONLY=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--paths-only]"
            echo "  --json         Output results in JSON format"
            echo "  --paths-only   Only return path information"
            echo "  --help         Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Detect if we're in a git repository
HAS_GIT="false"
CURRENT_BRANCH="main"
FEATURE_DIR=""
FEATURE_SPEC=""
FEATURE_DESIGN=""
TASKS=""

if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null 2>&1; then
    HAS_GIT="true"
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    
    # Check if we're on a feature branch (format: N-feature-name)
    if [[ "$CURRENT_BRANCH" =~ ^[0-9]+-(.+)$ ]]; then
        FEATURE_DIR="specs/$CURRENT_BRANCH"
        
        if [[ -d "$FEATURE_DIR" ]]; then
            FEATURE_SPEC="$FEATURE_DIR/spec.md"
            FEATURE_DESIGN="$FEATURE_DIR/design/design.md"
            TASKS="$FEATURE_DIR/tasks.md"
            
            if [[ "$PATHS_ONLY" == "false" ]]; then
                print_info "Detected feature branch: $CURRENT_BRANCH"
                print_info "Feature directory: $FEATURE_DIR"
            fi
        else
            if [[ "$PATHS_ONLY" == "false" ]]; then
                print_warning "Feature branch detected but directory not found: $FEATURE_DIR"
            fi
        fi
    else
        if [[ "$PATHS_ONLY" == "false" ]]; then
            print_warning "Not on a feature branch (expected format: N-feature-name)"
            print_warning "Current branch: $CURRENT_BRANCH"
        fi
    fi
else
    if [[ "$PATHS_ONLY" == "false" ]]; then
        print_warning "Not in a git repository or git not available"
    fi
fi

# Check if spec file exists
SPEC_EXISTS="false"
if [[ -n "$FEATURE_SPEC" && -f "$FEATURE_SPEC" ]]; then
    SPEC_EXISTS="true"
    if [[ "$PATHS_ONLY" == "false" ]]; then
        print_success "Spec file found: $FEATURE_SPEC"
    fi
else
    if [[ "$PATHS_ONLY" == "false" ]]; then
        print_error "Spec file not found"
        if [[ -n "$FEATURE_SPEC" ]]; then
            print_info "Expected at: $FEATURE_SPEC"
        fi
        print_info "Please create a spec first using requirements-specification skill"
    fi
fi

# Output results
if [[ "$OUTPUT_JSON" == "true" ]]; then
    # JSON output
    cat <<EOF
{
  "has_git": "$HAS_GIT",
  "current_branch": "$CURRENT_BRANCH",
  "feature_dir": "$FEATURE_DIR",
  "feature_spec": "$FEATURE_SPEC",
  "feature_design": "$FEATURE_DESIGN",
  "tasks": "$TASKS",
  "spec_exists": "$SPEC_EXISTS"
}
EOF
else
    # Human-readable output
    echo ""
    if [[ "$SPEC_EXISTS" == "true" ]]; then
        print_success "Prerequisites check passed"
    else
        print_error "Prerequisites check failed: Spec file not found"
    fi
    echo ""
    echo "Git available: $HAS_GIT"
    echo "Current branch: $CURRENT_BRANCH"
    echo "Feature directory: ${FEATURE_DIR:-N/A}"
    echo "Spec file: ${FEATURE_SPEC:-N/A}"
    echo "Spec exists: $SPEC_EXISTS"
    echo ""
    
    if [[ "$SPEC_EXISTS" == "false" ]]; then
        print_info "To create a spec, use the requirements-specification skill"
        exit 1
    fi
fi

exit 0
