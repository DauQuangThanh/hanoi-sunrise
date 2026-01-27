#!/usr/bin/env bash
# Setup script for architecture design workflow
# This is a portable skill-local version

set -e

# Parse command line arguments
JSON_MODE=false
PRODUCT_NAME=""

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --product)
            shift
            PRODUCT_NAME="$1"
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--product NAME]"
            echo "  --json          Output results in JSON format"
            echo "  --product NAME  Specify product name"
            echo "  --help          Show this help message"
            exit 0
            ;;
    esac
    shift || true
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

# Configuration
DOCS_DIR="$REPO_ROOT/docs"
ARCH_DOC="$DOCS_DIR/architecture.md"
ADR_DIR="$DOCS_DIR/adr"
SPECS_DIR="$REPO_ROOT/specs"
GROUND_RULES="$REPO_ROOT/docs/ground-rules.md"

# Get product name
if [[ -z "$PRODUCT_NAME" ]]; then
    PRODUCT_NAME=$(basename "$REPO_ROOT")
fi

# Create docs directory structure
mkdir -p "$DOCS_DIR"
mkdir -p "$ADR_DIR"

# Copy architecture template from skill directory
TEMPLATE="$SKILL_DIR/templates/arch-template.md"
if [[ -f "$TEMPLATE" ]] && [[ ! -f "$ARCH_DOC" ]]; then
    cp "$TEMPLATE" "$ARCH_DOC"
    
    # Replace placeholders
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\[PRODUCT\/PROJECT NAME\]/$PRODUCT_NAME/g" "$ARCH_DOC"
        sed -i '' "s/\[DATE\]/$(date +%Y-%m-%d)/g" "$ARCH_DOC"
    else
        # Linux
        sed -i "s/\[PRODUCT\/PROJECT NAME\]/$PRODUCT_NAME/g" "$ARCH_DOC"
        sed -i "s/\[DATE\]/$(date +%Y-%m-%d)/g" "$ARCH_DOC"
    fi
    
    if [[ "$JSON_MODE" != "true" ]]; then
        echo "✓ Created architecture document: $ARCH_DOC"
    fi
elif [[ -f "$ARCH_DOC" ]]; then
    if [[ "$JSON_MODE" != "true" ]]; then
        echo "INFO: Architecture document already exists: $ARCH_DOC"
    fi
else
    if [[ "$JSON_MODE" != "true" ]]; then
        echo "WARNING: Template not found at $TEMPLATE" >&2
        echo "Creating empty architecture document" >&2
    fi
    touch "$ARCH_DOC"
fi

# Count existing feature specs
SPEC_COUNT=0
FEATURE_SPECS=()
if [[ -d "$SPECS_DIR" ]]; then
    while IFS= read -r spec_file; do
        FEATURE_SPECS+=("$spec_file")
        ((SPEC_COUNT++))
    done < <(find "$SPECS_DIR" -name "spec.md" 2>/dev/null)
fi

# Check if ground rules exist
HAS_GROUND_RULES="false"
if [[ -f "$GROUND_RULES" ]]; then
    HAS_GROUND_RULES="true"
fi

# Output results
if $JSON_MODE; then
    printf '{"ARCH_DOC":"%s","DOCS_DIR":"%s","ADR_DIR":"%s","SPECS_DIR":"%s","SPEC_COUNT":%d,"FEATURE_SPECS":[' \
        "$ARCH_DOC" "$DOCS_DIR" "$ADR_DIR" "$SPECS_DIR" "$SPEC_COUNT"
    
    for i in "${!FEATURE_SPECS[@]}"; do
        if [[ $i -eq $((${#FEATURE_SPECS[@]} - 1)) ]]; then
            printf '"%s"' "${FEATURE_SPECS[$i]}"
        else
            printf '"%s",' "${FEATURE_SPECS[$i]}"
        fi
    done
    
    printf '],"PRODUCT_NAME":"%s","GROUND_RULES":"%s","HAS_GROUND_RULES":"%s","REPO_ROOT":"%s"}\n' \
        "$PRODUCT_NAME" "$GROUND_RULES" "$HAS_GROUND_RULES" "$REPO_ROOT"
else
    echo "Repository root: $REPO_ROOT"
    echo "Product name: $PRODUCT_NAME"
    echo "Architecture document: $ARCH_DOC"
    echo "Documentation directory: $DOCS_DIR"
    echo "ADR directory: $ADR_DIR"
    echo "Feature specifications: $SPEC_COUNT found"
    echo "Ground rules: $HAS_GROUND_RULES"
    echo ""
    echo "✓ Setup complete. Architecture template is ready at:"
    echo "  $ARCH_DOC"
    
    if [[ "$HAS_GROUND_RULES" == "false" ]]; then
        echo ""
        echo "WARNING: Ground rules not found at $GROUND_RULES"
        echo "         Create project principles first for better architecture guidance"
    fi
fi
