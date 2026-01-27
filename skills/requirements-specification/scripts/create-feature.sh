#!/usr/bin/env bash
# create-feature.sh - Create a new feature branch and spec structure
#
# Usage:
#   ./create-feature.sh --number 5 --short-name "user-auth" "Add user authentication"
#   ./create-feature.sh --json --number 5 --short-name "user-auth" "Add user authentication"
#
# Arguments:
#   --number N           Feature number (required)
#   --short-name NAME    Short name for the feature (required)
#   --json               Output results as JSON
#   description          Feature description (all remaining arguments)
#
# Requirements:
#   - git
#   - bash 4.0+

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
FEATURE_NUMBER=""
SHORT_NAME=""
DESCRIPTION=""

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

# Function to validate short name format
validate_short_name() {
    local name="$1"
    
    # Check length
    if [[ ${#name} -lt 1 || ${#name} -gt 64 ]]; then
        print_error "Short name must be 1-64 characters"
        return 1
    fi
    
    # Check format: lowercase, numbers, hyphens only
    if ! [[ "$name" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
        print_error "Short name must use lowercase letters, numbers, and hyphens only"
        print_error "Cannot start/end with hyphen or have consecutive hyphens"
        return 1
    fi
    
    # Check for consecutive hyphens
    if [[ "$name" =~ -- ]]; then
        print_error "Short name cannot contain consecutive hyphens"
        return 1
    fi
    
    return 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --number)
            FEATURE_NUMBER="$2"
            shift 2
            ;;
        --short-name)
            SHORT_NAME="$2"
            shift 2
            ;;
        *)
            DESCRIPTION="$DESCRIPTION $1"
            shift
            ;;
    esac
done

# Trim description
DESCRIPTION="${DESCRIPTION# }"

# Validate required arguments
if [[ -z "$FEATURE_NUMBER" ]]; then
    print_error "Feature number is required (--number N)"
    exit 1
fi

if [[ -z "$SHORT_NAME" ]]; then
    print_error "Short name is required (--short-name NAME)"
    exit 1
fi

if [[ -z "$DESCRIPTION" ]]; then
    print_error "Feature description is required"
    exit 1
fi

# Validate short name format
if ! validate_short_name "$SHORT_NAME"; then
    exit 1
fi

# Construct branch name and paths
BRANCH_NAME="${FEATURE_NUMBER}-${SHORT_NAME}"
SPECS_DIR="specs/${BRANCH_NAME}"
SPEC_FILE="${SPECS_DIR}/spec.md"
CHECKLIST_DIR="${SPECS_DIR}/checklists"
CHECKLIST_FILE="${CHECKLIST_DIR}/requirements.md"

print_info "Creating feature: $BRANCH_NAME"
print_info "Description: $DESCRIPTION"

# Check if git is available
if ! command -v git &> /dev/null; then
    print_error "git is not installed or not in PATH"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir &> /dev/null; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    print_error "Branch '$BRANCH_NAME' already exists"
    exit 1
fi

# Create and checkout new branch
print_info "Creating branch: $BRANCH_NAME"
if ! git checkout -b "$BRANCH_NAME" 2>/dev/null; then
    print_error "Failed to create branch '$BRANCH_NAME'"
    exit 1
fi
print_success "Branch created and checked out"

# Create directory structure
print_info "Creating directory structure"
mkdir -p "$SPECS_DIR"
mkdir -p "$CHECKLIST_DIR"
print_success "Directories created"

# Copy spec template
if [[ -f "$TEMPLATES_DIR/spec-template.md" ]]; then
    print_info "Copying spec template"
    cp "$TEMPLATES_DIR/spec-template.md" "$SPEC_FILE"
    
    # Replace placeholders
    CURRENT_DATE=$(date +%Y-%m-%d)
    sed -i.bak "s/\[Feature Name\]/${SHORT_NAME}/g" "$SPEC_FILE"
    sed -i.bak "s/\[Number-ShortName\]/${BRANCH_NAME}/g" "$SPEC_FILE"
    sed -i.bak "s/\[Date\]/${CURRENT_DATE}/g" "$SPEC_FILE"
    rm -f "${SPEC_FILE}.bak"
    
    print_success "Spec template created"
else
    print_warning "Spec template not found, creating basic spec file"
    cat > "$SPEC_FILE" <<EOF
# ${SHORT_NAME}

**Feature ID**: ${BRANCH_NAME}
**Status**: Draft
**Created**: $(date +%Y-%m-%d)

## Overview

${DESCRIPTION}

## User Scenarios & Testing

[To be filled]

## Functional Requirements

[To be filled]

## Success Criteria

[To be filled]

## Assumptions

[To be filled]

## Out of Scope

[To be filled]
EOF
    print_success "Basic spec file created"
fi

# Copy checklist template
if [[ -f "$TEMPLATES_DIR/checklist-template.md" ]]; then
    print_info "Copying checklist template"
    cp "$TEMPLATES_DIR/checklist-template.md" "$CHECKLIST_FILE"
    
    # Replace placeholders
    CURRENT_DATE=$(date +%Y-%m-%d)
    sed -i.bak "s/\[FEATURE NAME\]/${SHORT_NAME}/g" "$CHECKLIST_FILE"
    sed -i.bak "s/\[DATE\]/${CURRENT_DATE}/g" "$CHECKLIST_FILE"
    sed -i.bak "s|\[Link to spec.md\]|[spec.md](../spec.md)|g" "$CHECKLIST_FILE"
    rm -f "${CHECKLIST_FILE}.bak"
    
    print_success "Checklist template created"
else
    print_warning "Checklist template not found, creating basic checklist file"
    cat > "$CHECKLIST_FILE" <<EOF
# Specification Quality Checklist: ${SHORT_NAME}

**Feature**: [spec.md](../spec.md)
**Created**: $(date +%Y-%m-%d)

## Content Quality
- [ ] No implementation details
- [ ] Focused on user value
- [ ] All mandatory sections completed

## Requirement Completeness
- [ ] Requirements are testable
- [ ] Success criteria are measurable
- [ ] Edge cases identified

## Feature Readiness
- [ ] Ready for next phase
EOF
    print_success "Basic checklist file created"
fi

# Output results
if [[ "$OUTPUT_JSON" == "true" ]]; then
    # JSON output
    cat <<EOF
{
  "success": true,
  "branch_name": "$BRANCH_NAME",
  "feature_number": $FEATURE_NUMBER,
  "short_name": "$SHORT_NAME",
  "description": "$DESCRIPTION",
  "spec_file": "$SPEC_FILE",
  "checklist_file": "$CHECKLIST_FILE",
  "specs_dir": "$SPECS_DIR"
}
EOF
else
    # Human-readable output
    echo ""
    print_success "Feature created successfully!"
    echo ""
    echo "Branch: $BRANCH_NAME"
    echo "Spec file: $SPEC_FILE"
    echo "Checklist: $CHECKLIST_FILE"
    echo ""
    print_info "Next steps:"
    echo "  1. Fill in the specification: $SPEC_FILE"
    echo "  2. Validate using checklist: $CHECKLIST_FILE"
    echo "  3. Commit your changes: git add . && git commit -m 'docs: add specification for $SHORT_NAME'"
fi

exit 0
