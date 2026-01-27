#!/usr/bin/env bash
# setup-design.sh - Set up design directory structure and templates
#
# Usage:
#   ./setup-design.sh
#   ./setup-design.sh --json
#
# Arguments:
#   --json    Output results in JSON format
#
# Requirements:
#   - bash 4.0+
#   - git (optional - will work without git)

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SKILL_DIR/templates"

# Default values
OUTPUT_JSON=false

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
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
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

if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null 2>&1; then
    HAS_GIT="true"
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    
    # Check if we're on a feature branch (format: N-feature-name)
    if [[ "$CURRENT_BRANCH" =~ ^[0-9]+-(.+)$ ]]; then
        FEATURE_DIR="specs/$CURRENT_BRANCH"
        FEATURE_SPEC="$FEATURE_DIR/spec.md"
        print_info "Detected feature branch: $CURRENT_BRANCH"
    else
        print_warning "Not on a feature branch (expected format: N-feature-name)"
        print_warning "Design artifacts will be created in design/ directory"
    fi
else
    print_warning "Not in a git repository or git not available"
fi

# Determine design directory location
if [[ -n "$FEATURE_DIR" && -d "$FEATURE_DIR" ]]; then
    # We're on a feature branch, use feature-specific design directory
    DESIGN_DIR="$FEATURE_DIR/design"
    print_info "Using feature-specific design directory: $DESIGN_DIR"
else
    # Use project-level design directory
    DESIGN_DIR="design"
    print_info "Using project-level design directory: $DESIGN_DIR"
fi

FEATURE_DESIGN="$DESIGN_DIR/design.md"
RESEARCH_FILE="$DESIGN_DIR/research/research.md"
DATA_MODEL_FILE="$DESIGN_DIR/data-model.md"
QUICKSTART_FILE="$DESIGN_DIR/quickstart.md"
CONTRACTS_DIR="$DESIGN_DIR/contracts"

# Create directory structure
print_info "Creating design directory structure"
mkdir -p "$DESIGN_DIR"
mkdir -p "$DESIGN_DIR/research"
mkdir -p "$CONTRACTS_DIR"
print_success "Directories created"

# Copy design template
if [[ -f "$TEMPLATES_DIR/design-template.md" ]]; then
    print_info "Copying design template"
    cp "$TEMPLATES_DIR/design-template.md" "$FEATURE_DESIGN"
    print_success "Design template copied to $FEATURE_DESIGN"
else
    print_error "Design template not found at $TEMPLATES_DIR/design-template.md"
    exit 1
fi

# Copy research template
if [[ -f "$TEMPLATES_DIR/research-template.md" ]]; then
    print_info "Copying research template"
    cp "$TEMPLATES_DIR/research-template.md" "$RESEARCH_FILE"
    print_success "Research template copied to $RESEARCH_FILE"
else
    print_warning "Research template not found, skipping"
fi

# Copy data model template
if [[ -f "$TEMPLATES_DIR/data-model-template.md" ]]; then
    print_info "Copying data model template"
    cp "$TEMPLATES_DIR/data-model-template.md" "$DATA_MODEL_FILE"
    print_success "Data model template copied to $DATA_MODEL_FILE"
else
    print_warning "Data model template not found, skipping"
fi

# Create placeholder API contract
if [[ -f "$TEMPLATES_DIR/api-contract-template.md" ]]; then
    print_info "Copying API contract template"
    cp "$TEMPLATES_DIR/api-contract-template.md" "$CONTRACTS_DIR/example-contract.md"
    print_success "API contract template copied to $CONTRACTS_DIR/"
else
    print_warning "API contract template not found, skipping"
fi

# Output results
if [[ "$OUTPUT_JSON" == "true" ]]; then
    # JSON output
    cat <<EOF
{
  "success": true,
  "has_git": "$HAS_GIT",
  "current_branch": "$CURRENT_BRANCH",
  "feature_spec": "$FEATURE_SPEC",
  "feature_design": "$FEATURE_DESIGN",
  "research_file": "$RESEARCH_FILE",
  "data_model_file": "$DATA_MODEL_FILE",
  "quickstart_file": "$QUICKSTART_FILE",
  "contracts_dir": "$CONTRACTS_DIR",
  "design_dir": "$DESIGN_DIR"
}
EOF
else
    # Human-readable output
    echo ""
    print_success "Design workspace created successfully!"
    echo ""
    echo "Design directory: $DESIGN_DIR"
    echo "Design document: $FEATURE_DESIGN"
    echo "Research document: $RESEARCH_FILE"
    echo "Data model: $DATA_MODEL_FILE"
    echo "Contracts directory: $CONTRACTS_DIR"
    if [[ -n "$FEATURE_SPEC" ]]; then
        echo "Feature spec: $FEATURE_SPEC"
    fi
    echo ""
    print_info "Next steps:"
    echo "  1. Review and fill in $FEATURE_DESIGN"
    echo "  2. Conduct research and document in $RESEARCH_FILE"
    echo "  3. Design data models in $DATA_MODEL_FILE"
    echo "  4. Create API contracts in $CONTRACTS_DIR/"
fi

exit 0
