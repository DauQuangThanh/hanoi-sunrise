#!/usr/bin/env bash
# validate-skill.sh - Agent Skill Validator (Bash/macOS/Linux)
#
# Usage:
#   ./validate-skill.sh <skill-directory>
#   ./validate-skill.sh ./skills/my-skill
#   ./validate-skill.sh . (from within skill directory)
#
# Author: Dau Quang Thanh
# License: MIT

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ERRORS=0
WARNINGS=0
INFO=0

# Print functions
print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    ((ERRORS++))
}

print_warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
    ((WARNINGS++))
}

print_info() {
    echo -e "${BLUE}ℹ INFO: $1${NC}"
    ((INFO++))
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Validate skill name
validate_skill_name() {
    local name="$1"
    local dir_name="$2"
    
    # Length check
    if [[ ${#name} -lt 1 || ${#name} -gt 64 ]]; then
        print_error "Skill name must be 1-64 characters (current: ${#name})"
    fi
    
    # Only lowercase letters, numbers, and hyphens
    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        print_error "Skill name must only contain lowercase letters, numbers, and hyphens"
    fi
    
    # Cannot start or end with hyphen
    if [[ "$name" =~ ^- ]]; then
        print_error "Skill name cannot start with a hyphen"
    fi
    
    if [[ "$name" =~ -$ ]]; then
        print_error "Skill name cannot end with a hyphen"
    fi
    
    # No consecutive hyphens
    if [[ "$name" =~ -- ]]; then
        print_error "Skill name cannot contain consecutive hyphens"
    fi
    
    # Must match directory name
    if [[ "$name" != "$dir_name" ]]; then
        print_error "Skill name '$name' must match directory name '$dir_name'"
    fi
}

# Validate description
validate_description() {
    local desc="$1"
    local len=${#desc}
    
    # Length check
    if [[ -z "$desc" ]]; then
        print_error "Description is required"
        return
    fi
    
    if [[ $len -lt 1 || $len -gt 1024 ]]; then
        print_error "Description must be 1-1024 characters (current: $len)"
    fi
    
    # Quality checks
    if [[ $len -lt 50 ]]; then
        print_warning "Description is very short. Consider adding more details about what, when, and keywords."
    fi
    
    if [[ $len -lt 100 ]]; then
        print_info "Optimal description length is 150-300 characters for better skill discovery"
    fi
    
    # Check for formula components
    local desc_lower=$(echo "$desc" | tr '[:upper:]' '[:lower:]')
    
    if [[ ! "$desc_lower" =~ (extract|analyze|generate|create|process|transform|convert) ]]; then
        print_warning "Description should include specific actions (extract, analyze, generate, etc.)"
    fi
    
    if [[ ! "$desc_lower" =~ (use when|when) ]]; then
        print_warning "Description should include 'Use when' to clarify activation scenarios"
    fi
    
    if [[ ! "$desc_lower" =~ mention ]]; then
        local word_count=$(echo "$desc" | wc -w | tr -d ' ')
        if [[ $word_count -le 15 ]]; then
            print_warning "Description should mention keywords users might say"
        fi
    fi
}

# Extract frontmatter field
extract_field() {
    local file="$1"
    local field="$2"
    
    # Extract YAML frontmatter
    local in_frontmatter=false
    local value=""
    
    while IFS= read -r line; do
        if [[ "$line" == "---" ]]; then
            if [[ "$in_frontmatter" == false ]]; then
                in_frontmatter=true
            else
                break
            fi
        elif [[ "$in_frontmatter" == true ]]; then
            if [[ "$line" =~ ^${field}:\ * ]]; then
                value="${line#*: }"
                # Remove quotes if present
                value="${value#\"}"
                value="${value%\"}"
                echo "$value"
                return 0
            fi
        fi
    done < "$file"
    
    return 1
}

# Validate file structure
validate_file_structure() {
    local skill_dir="$1"
    
    # Check SKILL.md exists
    if [[ ! -f "$skill_dir/SKILL.md" ]]; then
        print_error "SKILL.md not found. This file is required."
        return
    fi
    
    print_success "✓ Found SKILL.md"
    
    # Check for optional directories
    if [[ -d "$skill_dir/scripts" ]]; then
        print_info "Found scripts/ directory"
        
        # Check for cross-platform scripts
        local has_python=false
        local has_bash=false
        local has_powershell=false
        
        if compgen -G "$skill_dir/scripts/*.py" > /dev/null; then
            has_python=true
            print_info "Found Python scripts (cross-platform)"
        fi
        
        if compgen -G "$skill_dir/scripts/*.sh" > /dev/null; then
            has_bash=true
        fi
        
        if compgen -G "$skill_dir/scripts/*.ps1" > /dev/null; then
            has_powershell=true
        fi
        
        if [[ "$has_python" == false ]]; then
            if [[ "$has_bash" == true && "$has_powershell" == false ]]; then
                print_warning "Found Bash scripts but no PowerShell scripts. Consider adding .ps1 versions for Windows users."
            elif [[ "$has_powershell" == true && "$has_bash" == false ]]; then
                print_warning "Found PowerShell scripts but no Bash scripts. Consider adding .sh versions for Unix users."
            fi
        fi
    fi
    
    if [[ -d "$skill_dir/references" ]]; then
        print_info "Found references/ directory"
    fi
    
    if [[ -d "$skill_dir/templates" ]]; then
        print_info "Found templates/ directory"
    fi
    
    if [[ -d "$skill_dir/assets" ]]; then
        print_info "Found assets/ directory"
    fi
}

# Validate SKILL.md size
validate_size() {
    local file="$1"
    local line_count=$(wc -l < "$file" | tr -d ' ')
    
    if [[ $line_count -gt 500 ]]; then
        print_warning "SKILL.md has $line_count lines. Recommendation: Keep under 500 lines and move detailed content to references/"
    elif [[ $line_count -gt 400 ]]; then
        print_info "SKILL.md has $line_count lines. Consider moving detailed content to references/ if it grows more."
    fi
}

# Check frontmatter exists
check_frontmatter() {
    local file="$1"
    
    # Check if file starts with ---
    if ! head -n 1 "$file" | grep -q "^---$"; then
        print_error "SKILL.md must have valid YAML frontmatter delimited by ---"
        return 1
    fi
    
    # Check if there's a closing ---
    if ! tail -n +2 "$file" | grep -q "^---$"; then
        print_error "SKILL.md must have valid YAML frontmatter delimited by ---"
        return 1
    fi
    
    return 0
}

# Main validation
main() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <skill-directory>"
        echo ""
        echo "Examples:"
        echo "  $0 ./skills/my-skill"
        echo "  $0 . (from within skill directory)"
        exit 1
    fi
    
    local skill_path="$1"
    
    if [[ ! -d "$skill_path" ]]; then
        echo -e "${RED}Error: Path does not exist: $skill_path${NC}"
        exit 1
    fi
    
    # Get absolute path and directory name
    skill_path=$(cd "$skill_path" && pwd)
    local skill_name=$(basename "$skill_path")
    
    echo ""
    echo "Validating skill: $skill_name"
    echo "Location: $skill_path"
    echo "------------------------------------------------------------"
    echo ""
    
    # Validate file structure
    validate_file_structure "$skill_path"
    
    # If SKILL.md doesn't exist, stop here
    if [[ ! -f "$skill_path/SKILL.md" ]]; then
        echo ""
        if [[ $ERRORS -gt 0 ]]; then
            echo -e "${RED}❌ VALIDATION FAILED${NC}"
            echo -e "${RED}Found $ERRORS error(s)${NC}"
        fi
        exit 1
    fi
    
    # Check frontmatter
    if ! check_frontmatter "$skill_path/SKILL.md"; then
        echo ""
        echo -e "${RED}❌ VALIDATION FAILED${NC}"
        echo -e "${RED}Found $ERRORS error(s)${NC}"
        exit 1
    fi
    
    # Validate SKILL.md size
    validate_size "$skill_path/SKILL.md"
    
    # Extract and validate name
    echo ""
    echo "Checking frontmatter fields..."
    
    local name=""
    if name=$(extract_field "$skill_path/SKILL.md" "name"); then
        echo -e "${GREEN}✓ Found name: $name${NC}"
        validate_skill_name "$name" "$skill_name"
    else
        print_error "Missing required field: 'name'"
    fi
    
    # Extract and validate description
    local description=""
    if description=$(extract_field "$skill_path/SKILL.md" "description"); then
        echo -e "${GREEN}✓ Found description (${#description} chars)${NC}"
        validate_description "$description"
    else
        print_error "Missing required field: 'description'"
    fi
    
    # Check optional fields
    if extract_field "$skill_path/SKILL.md" "license" > /dev/null; then
        echo -e "${GREEN}✓ Found license${NC}"
    fi
    
    if extract_field "$skill_path/SKILL.md" "metadata" > /dev/null; then
        echo -e "${GREEN}✓ Found metadata${NC}"
    fi
    
    # Print summary
    echo ""
    echo "------------------------------------------------------------"
    
    if [[ $ERRORS -eq 0 ]]; then
        echo -e "${GREEN}✅ VALIDATION PASSED${NC}"
        echo "Skill structure is valid and follows the specification."
        
        if [[ $WARNINGS -gt 0 ]]; then
            echo ""
            echo -e "${YELLOW}Found $WARNINGS warning(s) - consider addressing these.${NC}"
        fi
        
        if [[ $INFO -gt 0 ]]; then
            echo -e "${BLUE}Found $INFO informational message(s).${NC}"
        fi
        
        exit 0
    else
        echo -e "${RED}❌ VALIDATION FAILED${NC}"
        echo -e "${RED}Found $ERRORS error(s)${NC}"
        
        if [[ $WARNINGS -gt 0 ]]; then
            echo -e "${YELLOW}Found $WARNINGS warning(s)${NC}"
        fi
        
        exit 1
    fi
}

main "$@"
