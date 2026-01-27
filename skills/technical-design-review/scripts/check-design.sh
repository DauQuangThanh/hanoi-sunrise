#!/usr/bin/env bash
# check-design.sh - Check for technical design documentation and prerequisites
#
# Usage:
#   ./check-design.sh
#   ./check-design.sh --json
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

# Default values
OUTPUT_JSON=false
REPO_ROOT="$(pwd)"

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
CURRENT_BRANCH=""
if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null 2>&1; then
    HAS_GIT="true"
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
fi

# Determine design directory location
DESIGN_DIR=""
if [[ "$HAS_GIT" == "true" ]] && [[ "$CURRENT_BRANCH" =~ ^[0-9]+-.*$ ]]; then
    # Feature branch pattern (e.g., 123-feature-name)
    FEATURE_NUM=$(echo "$CURRENT_BRANCH" | grep -oE '^[0-9]+')
    DESIGN_DIR="$REPO_ROOT/specs/$FEATURE_NUM-*/design"
    # Find actual directory (handle wildcard)
    if compgen -G "$DESIGN_DIR" > /dev/null; then
        DESIGN_DIR=$(compgen -G "$DESIGN_DIR" | head -n 1)
    else
        DESIGN_DIR=""
    fi
else
    # Default location
    DESIGN_DIR="$REPO_ROOT/design"
fi

# Check for design documentation
DESIGN_FILE=""
RESEARCH_FILE=""
DATA_MODEL_FILE=""
CONTRACTS_DIR=""
QUICKSTART_FILE=""
FEATURE_SPEC=""
GROUND_RULES_FILE=""
ARCHITECTURE_FILE=""

MISSING_FILES=()
FOUND_FILES=()

# Check main design file
if [[ -n "$DESIGN_DIR" ]] && [[ -f "$DESIGN_DIR/design.md" ]]; then
    DESIGN_FILE="$DESIGN_DIR/design.md"
    FOUND_FILES+=("design.md")
    print_success "Found design.md: $DESIGN_FILE"
else
    MISSING_FILES+=("design.md")
    print_error "Missing design.md in $DESIGN_DIR"
fi

# Check research file
if [[ -n "$DESIGN_DIR" ]] && [[ -f "$DESIGN_DIR/research/research.md" ]]; then
    RESEARCH_FILE="$DESIGN_DIR/research/research.md"
    FOUND_FILES+=("research.md")
    print_success "Found research.md: $RESEARCH_FILE"
else
    MISSING_FILES+=("research/research.md")
    print_error "Missing research/research.md in $DESIGN_DIR"
fi

# Check data model file
if [[ -n "$DESIGN_DIR" ]] && [[ -f "$DESIGN_DIR/data-model.md" ]]; then
    DATA_MODEL_FILE="$DESIGN_DIR/data-model.md"
    FOUND_FILES+=("data-model.md")
    print_success "Found data-model.md: $DATA_MODEL_FILE"
else
    MISSING_FILES+=("data-model.md")
    print_error "Missing data-model.md in $DESIGN_DIR"
fi

# Check contracts directory
if [[ -n "$DESIGN_DIR" ]] && [[ -d "$DESIGN_DIR/contracts" ]]; then
    CONTRACTS_DIR="$DESIGN_DIR/contracts"
    CONTRACT_COUNT=$(find "$CONTRACTS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
    FOUND_FILES+=("contracts/ ($CONTRACT_COUNT files)")
    print_success "Found contracts directory: $CONTRACTS_DIR ($CONTRACT_COUNT files)"
else
    MISSING_FILES+=("contracts/")
    print_error "Missing contracts directory in $DESIGN_DIR"
fi

# Check quickstart file (optional)
if [[ -n "$DESIGN_DIR" ]] && [[ -f "$DESIGN_DIR/quickstart.md" ]]; then
    QUICKSTART_FILE="$DESIGN_DIR/quickstart.md"
    FOUND_FILES+=("quickstart.md")
    print_success "Found quickstart.md: $QUICKSTART_FILE"
else
    print_warning "Optional quickstart.md not found"
fi

# Check for feature specification
if [[ "$HAS_GIT" == "true" ]] && [[ "$CURRENT_BRANCH" =~ ^[0-9]+-.*$ ]]; then
    FEATURE_NUM=$(echo "$CURRENT_BRANCH" | grep -oE '^[0-9]+')
    SPEC_PATTERN="$REPO_ROOT/specs/$FEATURE_NUM-*/spec.md"
    if compgen -G "$SPEC_PATTERN" > /dev/null; then
        FEATURE_SPEC=$(compgen -G "$SPEC_PATTERN" | head -n 1)
        FOUND_FILES+=("spec.md")
        print_success "Found feature spec: $FEATURE_SPEC"
    else
        print_warning "Feature specification not found (expected in specs/$FEATURE_NUM-*/spec.md)"
    fi
elif [[ -f "$REPO_ROOT/specs/spec.md" ]]; then
    FEATURE_SPEC="$REPO_ROOT/specs/spec.md"
    FOUND_FILES+=("spec.md")
    print_success "Found spec.md: $FEATURE_SPEC"
else
    print_warning "Feature specification not found"
fi

# Check for ground rules (optional)
if [[ -f "$REPO_ROOT/docs/ground-rules.md" ]]; then
    GROUND_RULES_FILE="$REPO_ROOT/docs/ground-rules.md"
    FOUND_FILES+=("ground-rules.md")
    print_success "Found ground-rules.md: $GROUND_RULES_FILE"
else
    print_warning "Optional ground-rules.md not found"
fi

# Check for architecture (optional)
if [[ -f "$REPO_ROOT/docs/architecture.md" ]]; then
    ARCHITECTURE_FILE="$REPO_ROOT/docs/architecture.md"
    FOUND_FILES+=("architecture.md")
    print_success "Found architecture.md: $ARCHITECTURE_FILE"
else
    print_warning "Optional architecture.md not found"
fi

# Output results
if [[ "$OUTPUT_JSON" == "true" ]]; then
    # Build JSON output
    cat << EOF
{
  "design_file": "$DESIGN_FILE",
  "research_file": "$RESEARCH_FILE",
  "data_model_file": "$DATA_MODEL_FILE",
  "contracts_dir": "$CONTRACTS_DIR",
  "quickstart_file": "$QUICKSTART_FILE",
  "feature_spec": "$FEATURE_SPEC",
  "ground_rules_file": "$GROUND_RULES_FILE",
  "architecture_file": "$ARCHITECTURE_FILE",
  "design_dir": "$DESIGN_DIR",
  "current_branch": "$CURRENT_BRANCH",
  "has_git": $HAS_GIT,
  "found_files": $(printf '%s\n' "${FOUND_FILES[@]}" | jq -R . | jq -s .),
  "missing_files": $(printf '%s\n' "${MISSING_FILES[@]}" | jq -R . | jq -s .),
  "status": "$([ ${#MISSING_FILES[@]} -eq 0 ] && echo "complete" || echo "incomplete")"
}
EOF
else
    # Human-readable output
    echo ""
    echo "=================================="
    echo "Technical Design Prerequisites"
    echo "=================================="
    echo ""
    echo "Repository: $REPO_ROOT"
    echo "Design Directory: $DESIGN_DIR"
    if [[ "$HAS_GIT" == "true" ]]; then
        echo "Current Branch: $CURRENT_BRANCH"
    fi
    echo ""
    echo "Found Files (${#FOUND_FILES[@]}):"
    for file in "${FOUND_FILES[@]}"; do
        echo "  ✓ $file"
    done
    echo ""
    if [[ ${#MISSING_FILES[@]} -gt 0 ]]; then
        echo "Missing Files (${#MISSING_FILES[@]}):"
        for file in "${MISSING_FILES[@]}"; do
            echo "  ✗ $file"
        done
        echo ""
    fi
    
    if [[ ${#MISSING_FILES[@]} -eq 0 ]]; then
        echo "Status: ${GREEN}All required files found${NC}"
        echo ""
        echo "Ready for technical design review!"
    else
        echo "Status: ${RED}Missing required files${NC}"
        echo ""
        echo "Please ensure all design documents are complete before review."
        echo "Run the technical-design skill to generate missing files."
        exit 1
    fi
fi

exit 0
