#!/usr/bin/env bash
# generate-skill.sh - Agent Skill Generator (Bash/macOS/Linux)
#
# Usage:
#   ./generate-skill.sh --name skill-name --description "Skill description"
#   ./generate-skill.sh --name skill-name --description "Skill description" --author "Your Name"
#   ./generate-skill.sh --name skill-name --description "Skill description" --output ./custom-path
#
# Author: Dau Quang Thanh
# License: MIT

set -euo pipefail

# Default values
AUTHOR="Dau Quang Thanh"
OUTPUT_DIR=""
WITH_SCRIPTS=false
WITH_REFERENCES=false
WITH_TEMPLATES=false
FULL=false
SKILL_NAME=""
DESCRIPTION=""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print usage
usage() {
    cat << EOF
Usage: $0 --name SKILL_NAME --description DESCRIPTION [OPTIONS]

Required:
  --name NAME           Skill name (lowercase with hyphens)
  --description DESC    Skill description (what, when, keywords)

Optional:
  --author AUTHOR       Author name (default: Dau Quang Thanh)
  --output DIR          Output directory (default: current directory)
  --with-scripts        Include scripts/ directory with sample script
  --with-references     Include references/ directory with sample reference
  --with-templates      Include templates/ directory with sample template
  --full                Include all optional directories
  -h, --help            Show this help message

Examples:
  $0 --name pdf-processor --description "Processes PDF files"
  $0 --name code-review --description "Reviews code for quality" --full
EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            SKILL_NAME="$2"
            shift 2
            ;;
        --description)
            DESCRIPTION="$2"
            shift 2
            ;;
        --author)
            AUTHOR="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --with-scripts)
            WITH_SCRIPTS=true
            shift
            ;;
        --with-references)
            WITH_REFERENCES=true
            shift
            ;;
        --with-templates)
            WITH_TEMPLATES=true
            shift
            ;;
        --full)
            FULL=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Validate required arguments
if [[ -z "$SKILL_NAME" ]]; then
    echo -e "${RED}Error: --name is required${NC}"
    usage
fi

if [[ -z "$DESCRIPTION" ]]; then
    echo -e "${RED}Error: --description is required${NC}"
    usage
fi

# Validate skill name
validate_skill_name() {
    local name="$1"
    
    # Length check
    if [[ ${#name} -lt 1 || ${#name} -gt 64 ]]; then
        echo -e "${RED}Error: Skill name must be 1-64 characters (current: ${#name})${NC}"
        return 1
    fi
    
    # Only lowercase letters, numbers, and hyphens
    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        echo -e "${RED}Error: Skill name must only contain lowercase letters, numbers, and hyphens${NC}"
        return 1
    fi
    
    # Cannot start or end with hyphen
    if [[ "$name" =~ ^- || "$name" =~ -$ ]]; then
        echo -e "${RED}Error: Skill name cannot start or end with a hyphen${NC}"
        return 1
    fi
    
    # No consecutive hyphens
    if [[ "$name" =~ -- ]]; then
        echo -e "${RED}Error: Skill name cannot contain consecutive hyphens${NC}"
        return 1
    fi
    
    return 0
}

# Validate description length
validate_description() {
    local desc="$1"
    local len=${#desc}
    
    if [[ $len -lt 1 || $len -gt 1024 ]]; then
        echo -e "${RED}Error: Description must be 1-1024 characters (current: $len)${NC}"
        return 1
    fi
    
    return 0
}

# Generate SKILL.md content
generate_skill_md() {
    local name="$1"
    local desc="$2"
    local author="$3"
    local today=$(date +%Y-%m-%d)
    local title=$(echo "$name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    
    cat << EOF
---
name: $name
description: "$desc"
license: MIT
metadata:
  author: $author
  version: "1.0.0"
  last-updated: "$today"
---

# $title

## When to Use

- [Describe scenario 1 when this skill should be activated]
- [Describe scenario 2]
- [Describe scenario 3]

## Prerequisites

- [List required tools or packages]
- [Add environment requirements if any]

## Instructions

### Step 1: [First Action]

[Provide clear, step-by-step instructions for the first action]

1. Detail 1
2. Detail 2
3. Detail 3

### Step 2: [Second Action]

[Continue with sequential steps]

\`\`\`bash
# Example command if applicable
command --option value
\`\`\`

### Step 3: [Complete Task]

[Final steps to complete the task]

## Examples

### Example 1: Basic Usage

**Input:**
\`\`\`
[Show example input]
\`\`\`

**Expected Output:**
\`\`\`
[Show expected result]
\`\`\`

**Explanation:**
[Brief explanation of what happened]

## Edge Cases

### Case 1: [Unusual Situation]

**Description**: [Explain the edge case]

**Handling**: [How to handle this situation]

### Case 2: [Error Condition]

**Description**: [Explain the error condition]

**Handling**: [Steps to resolve]

## Error Handling

### Error: [Error Type]

**Symptoms**: [How to identify this error]

**Resolution**:
1. [Step to resolve]
2. [Another step]

## Guidelines

1. [Important rule to follow]
2. [Best practice to maintain]
3. [Convention to follow]

## Additional Resources

- [Add links to references if needed]
EOF
}

# Generate sample script
generate_sample_script() {
    local name="$1"
    local title=$(echo "$name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    
    cat << 'EOF'
#!/usr/bin/env bash
# SKILL_NAME.sh - TITLE Script

set -euo pipefail

usage() {
    echo "Usage: $0 --input <file> [--output <file>]"
    exit 1
}

INPUT_FILE=""
OUTPUT_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --input)
            INPUT_FILE="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: --input is required"
    usage
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File not found: $INPUT_FILE"
    exit 1
fi

echo "Processing: $INPUT_FILE"

# TODO: Add your processing logic here

if [[ -n "$OUTPUT_FILE" ]]; then
    echo "Output saved to: $OUTPUT_FILE"
else
    echo "Processing complete"
fi
EOF
}

# Generate sample reference
generate_sample_reference() {
    local name="$1"
    local title=$(echo "$name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    
    cat << EOF
# $title - Detailed Guide

## Overview

[Provide detailed background information about this skill]

## Concepts

### Concept 1

[Explain important concepts]

### Concept 2

[Continue with more details]

## Advanced Usage

[Provide advanced techniques and patterns]

## Best Practices

1. [Best practice 1]
2. [Best practice 2]
3. [Best practice 3]

## Troubleshooting

### Issue 1

**Problem**: [Describe the problem]

**Solution**: [Provide solution]

### Issue 2

**Problem**: [Another issue]

**Solution**: [Another solution]

## References

- [External resources]
- [Documentation links]
- [Related materials]
EOF
}

# Main execution
main() {
    # Validate inputs
    if ! validate_skill_name "$SKILL_NAME"; then
        exit 1
    fi
    
    if ! validate_description "$DESCRIPTION"; then
        exit 1
    fi
    
    # Determine output directory
    if [[ -z "$OUTPUT_DIR" ]]; then
        OUTPUT_DIR="$(pwd)/$SKILL_NAME"
    else
        OUTPUT_DIR="$OUTPUT_DIR/$SKILL_NAME"
    fi
    
    # Determine which directories to include
    if [[ "$FULL" == true ]]; then
        WITH_SCRIPTS=true
        WITH_REFERENCES=true
        WITH_TEMPLATES=true
    fi
    
    echo -e "\n${BLUE}Generating skill: $SKILL_NAME${NC}"
    echo -e "${BLUE}Author: $AUTHOR${NC}"
    echo -e "${BLUE}Description: ${DESCRIPTION:0:60}...${NC}"
    echo ""
    
    # Create main directory
    mkdir -p "$OUTPUT_DIR"
    echo -e "${GREEN}✓ Created directory: $OUTPUT_DIR${NC}"
    
    # Generate SKILL.md
    generate_skill_md "$SKILL_NAME" "$DESCRIPTION" "$AUTHOR" > "$OUTPUT_DIR/SKILL.md"
    echo -e "${GREEN}✓ Created SKILL.md${NC}"
    
    # Create optional directories
    if [[ "$WITH_SCRIPTS" == true ]]; then
        mkdir -p "$OUTPUT_DIR/scripts"
        local script_content=$(generate_sample_script "$SKILL_NAME")
        echo "$script_content" | sed "s/SKILL_NAME/$SKILL_NAME/g" | sed "s/TITLE/$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')/g" > "$OUTPUT_DIR/scripts/$SKILL_NAME.sh"
        chmod +x "$OUTPUT_DIR/scripts/$SKILL_NAME.sh"
        echo -e "${GREEN}✓ Created scripts/${NC}"
    fi
    
    if [[ "$WITH_REFERENCES" == true ]]; then
        mkdir -p "$OUTPUT_DIR/references"
        generate_sample_reference "$SKILL_NAME" > "$OUTPUT_DIR/references/detailed-guide.md"
        echo -e "${GREEN}✓ Created references/${NC}"
    fi
    
    if [[ "$WITH_TEMPLATES" == true ]]; then
        mkdir -p "$OUTPUT_DIR/templates"
        echo "# Output Template" > "$OUTPUT_DIR/templates/output-template.md"
        echo "" >> "$OUTPUT_DIR/templates/output-template.md"
        echo "[Template content goes here]" >> "$OUTPUT_DIR/templates/output-template.md"
        echo -e "${GREEN}✓ Created templates/${NC}"
    fi
    
    echo -e "\n${GREEN}✓ Skill generated successfully: $OUTPUT_DIR${NC}"
    echo -e "\nNext steps:"
    echo "1. Review and customize SKILL.md"
    echo "2. Add detailed instructions and examples"
    echo "3. Implement scripts if needed"
    echo "4. Validate with: ./validate-skill.sh $OUTPUT_DIR"
    echo "5. Test with your target agent"
}

main
