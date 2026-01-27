#!/usr/bin/env bash

# check-e2e-prerequisites.sh
# Checks for required files before running e2e-test-design skill
# Usage: ./check-e2e-prerequisites.sh [--json]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flags
JSON_OUTPUT=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --json)
            JSON_OUTPUT=true
            shift
            ;;
    esac
done

# Get workspace root (assuming script is in skills/e2e-test-design/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Required files
ARCHITECTURE_FILE="$WORKSPACE_ROOT/docs/architecture.md"
GROUND_RULES_FILE="$WORKSPACE_ROOT/docs/ground-rules.md"

# Optional files
STANDARDS_FILE="$WORKSPACE_ROOT/docs/standards.md"
EXISTING_E2E_PLAN="$WORKSPACE_ROOT/docs/e2e-test-plan.md"
SPECS_DIR="$WORKSPACE_ROOT/specs"

# Results
ALL_REQUIRED_PRESENT=true
ERRORS=()
WARNINGS=()
INFO=()
SPEC_COUNT=0

# Check required files
if [ ! -f "$ARCHITECTURE_FILE" ]; then
    ALL_REQUIRED_PRESENT=false
    ERRORS+=("architecture.md not found")
else
    INFO+=("Found architecture.md")
fi

if [ ! -f "$GROUND_RULES_FILE" ]; then
    ALL_REQUIRED_PRESENT=false
    ERRORS+=("ground-rules.md not found")
else
    INFO+=("Found ground-rules.md")
fi

# Check optional files
if [ ! -f "$STANDARDS_FILE" ]; then
    WARNINGS+=("standards.md not found (optional but recommended for test code standards)")
else
    INFO+=("Found standards.md")
fi

if [ -f "$EXISTING_E2E_PLAN" ]; then
    INFO+=("Found existing e2e-test-plan.md (will be updated)")
fi

# Count feature specifications
if [ -d "$SPECS_DIR" ]; then
    SPEC_COUNT=$(find "$SPECS_DIR" -type f -name "spec.md" | wc -l)
    if [ $SPEC_COUNT -gt 0 ]; then
        INFO+=("Found $SPEC_COUNT feature specification(s)")
    else
        WARNINGS+=("No feature specifications found in specs/ (recommended for user journey extraction)")
    fi
else
    WARNINGS+=("specs/ directory not found (recommended for user journey extraction)")
fi

# Output results
if [ "$JSON_OUTPUT" = true ]; then
    # JSON output for programmatic parsing
    echo "{"
    echo "  \"success\": $([[ $ALL_REQUIRED_PRESENT == true ]] && echo "true" || echo "false"),"
    echo "  \"workspace_root\": \"$WORKSPACE_ROOT\","
    echo "  \"required_files\": {"
    echo "    \"architecture\": {"
    echo "      \"path\": \"$ARCHITECTURE_FILE\","
    echo "      \"exists\": $([[ -f "$ARCHITECTURE_FILE" ]] && echo "true" || echo "false")"
    echo "    },"
    echo "    \"ground_rules\": {"
    echo "      \"path\": \"$GROUND_RULES_FILE\","
    echo "      \"exists\": $([[ -f "$GROUND_RULES_FILE" ]] && echo "true" || echo "false")"
    echo "    }"
    echo "  },"
    echo "  \"optional_files\": {"
    echo "    \"standards\": {"
    echo "      \"path\": \"$STANDARDS_FILE\","
    echo "      \"exists\": $([[ -f "$STANDARDS_FILE" ]] && echo "true" || echo "false")"
    echo "    },"
    echo "    \"existing_e2e_plan\": {"
    echo "      \"path\": \"$EXISTING_E2E_PLAN\","
    echo "      \"exists\": $([[ -f "$EXISTING_E2E_PLAN" ]] && echo "true" || echo "false")"
    echo "    }"
    echo "  },"
    echo "  \"feature_specs\": {"
    echo "    \"directory\": \"$SPECS_DIR\","
    echo "    \"count\": $SPEC_COUNT"
    echo "  },"
    echo "  \"errors\": ["
    for i in "${!ERRORS[@]}"; do
        echo -n "    \"${ERRORS[$i]}\""
        if [ $i -lt $((${#ERRORS[@]} - 1)) ]; then
            echo ","
        else
            echo ""
        fi
    done
    echo "  ],"
    echo "  \"warnings\": ["
    for i in "${!WARNINGS[@]}"; do
        echo -n "    \"${WARNINGS[$i]}\""
        if [ $i -lt $((${#WARNINGS[@]} - 1)) ]; then
            echo ","
        else
            echo ""
        fi
    done
    echo "  ],"
    echo "  \"info\": ["
    for i in "${!INFO[@]}"; do
        echo -n "    \"${INFO[$i]}\""
        if [ $i -lt $((${#INFO[@]} - 1)) ]; then
            echo ","
        else
            echo ""
        fi
    done
    echo "  ]"
    echo "}"
else
    # Human-readable output
    echo ""
    echo -e "${BLUE}E2E Test Design Skill - Prerequisites Check${NC}"
    echo "=============================================="
    echo ""
    
    # Workspace info
    echo -e "${BLUE}Workspace:${NC} $WORKSPACE_ROOT"
    echo ""
    
    # Required files section
    echo -e "${BLUE}Required Files:${NC}"
    if [ -f "$ARCHITECTURE_FILE" ]; then
        echo -e "  ${GREEN}✓${NC} architecture.md"
    else
        echo -e "  ${RED}✗${NC} architecture.md (MISSING - REQUIRED)"
    fi
    
    if [ -f "$GROUND_RULES_FILE" ]; then
        echo -e "  ${GREEN}✓${NC} ground-rules.md"
    else
        echo -e "  ${RED}✗${NC} ground-rules.md (MISSING - REQUIRED)"
    fi
    echo ""
    
    # Optional files section
    echo -e "${BLUE}Optional Files:${NC}"
    if [ -f "$STANDARDS_FILE" ]; then
        echo -e "  ${GREEN}✓${NC} standards.md (recommended for test code standards)"
    else
        echo -e "  ${YELLOW}○${NC} standards.md (optional but recommended for test code standards)"
    fi
    
    if [ -f "$EXISTING_E2E_PLAN" ]; then
        echo -e "  ${GREEN}✓${NC} e2e-test-plan.md (will be updated)"
    else
        echo -e "  ${YELLOW}○${NC} e2e-test-plan.md (will be created)"
    fi
    echo ""
    
    # Feature specifications section
    echo -e "${BLUE}Feature Specifications:${NC}"
    if [ $SPEC_COUNT -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} Found $SPEC_COUNT specification(s) in specs/"
    else
        echo -e "  ${YELLOW}○${NC} No specifications found (recommended for user journey extraction)"
    fi
    echo ""
    
    # Errors
    if [ ${#ERRORS[@]} -gt 0 ]; then
        echo -e "${RED}Errors:${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "  ${RED}✗${NC} $error"
        done
        echo ""
    fi
    
    # Warnings
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo -e "${YELLOW}Warnings:${NC}"
        for warning in "${WARNINGS[@]}"; do
            echo -e "  ${YELLOW}!${NC} $warning"
        done
        echo ""
    fi
    
    # Summary
    if [ "$ALL_REQUIRED_PRESENT" = true ]; then
        echo -e "${GREEN}✓ All required files present. Ready to run e2e-test-design skill.${NC}"
        
        if [ $SPEC_COUNT -eq 0 ]; then
            echo -e "${YELLOW}Note: Consider adding feature specifications in specs/ for better user journey extraction.${NC}"
        fi
        
        if [ ! -f "$STANDARDS_FILE" ]; then
            echo -e "${YELLOW}Note: Consider creating standards.md for test code standards guidance.${NC}"
        fi
    else
        echo -e "${RED}✗ Missing required files. Please create the following before running e2e-test-design skill:${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "  ${RED}-${NC} $error"
        done
        echo ""
        echo -e "${YELLOW}Tip: Run 'architect' skill to create architecture.md if needed.${NC}"
        echo -e "${YELLOW}Tip: Create docs/ground-rules.md with project principles and constraints.${NC}"
    fi
    echo ""
fi

# Exit with appropriate code
if [ "$ALL_REQUIRED_PRESENT" = true ]; then
    exit 0
else
    exit 1
fi
