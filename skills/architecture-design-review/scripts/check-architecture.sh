#!/usr/bin/env bash
# check-architecture.sh - Check architecture documentation and supporting files (Unix-like systems)
#
# Usage:
#   bash check-architecture.sh [--json]
#   bash check-architecture.sh --arch-file /path/to/architecture.md
#
# Options:
#   --json          Output results as JSON
#   --arch-file     Specify architecture file explicitly
#
# Author: Dau Quang Thanh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
OUTPUT_JSON=false
ARCH_FILE=""
AVAILABLE_DOCS=()
ADR_COUNT=0
SPECS_COUNT=0
GROUND_RULES_FOUND=false
DIAGRAMS_FOUND=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --arch-file)
            ARCH_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to find repository root
find_repo_root() {
    local dir="$(pwd)"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Function to find architecture file
find_architecture_file() {
    local current_dir
    current_dir="$(pwd)"
    
    # Check docs/architecture.md first (standard location)
    if [[ -f "$current_dir/docs/architecture.md" ]]; then
        echo "$current_dir/docs/architecture.md"
        return 0
    fi
    
    # Check current directory
    if [[ -f "$current_dir/architecture.md" ]]; then
        echo "$current_dir/architecture.md"
        return 0
    fi
    
    # Check .phoenix/docs/ (alternative location)
    if [[ -f "$current_dir/.phoenix/docs/architecture.md" ]]; then
        echo "$current_dir/.phoenix/docs/architecture.md"
        return 0
    fi
    
    return 1
}

# Function to count Mermaid diagrams
count_mermaid_diagrams() {
    local file="$1"
    local count
    count=$(grep -c "^```mermaid" "$file" 2>/dev/null || echo "0")
    echo "$count"
}

# Function to scan supporting documents
scan_supporting_docs() {
    local repo_root="$1"
    
    AVAILABLE_DOCS=()
    ADR_COUNT=0
    SPECS_COUNT=0
    GROUND_RULES_FOUND=false
    
    # Check for architecture.md (already confirmed to exist)
    AVAILABLE_DOCS+=("architecture.md")
    
    # Check for ADR files
    if [[ -d "$repo_root/docs/adr" ]]; then
        local adr_files
        adr_files=$(find "$repo_root/docs/adr" -name "*.md" -type f | wc -l | tr -d ' ')
        ADR_COUNT=$adr_files
        if [[ $adr_files -gt 0 ]]; then
            AVAILABLE_DOCS+=("docs/adr/ ($adr_files ADRs)")
        fi
    fi
    
    # Check for ground-rules.md
    if [[ -f "$repo_root/docs/ground-rules.md" ]]; then
        GROUND_RULES_FOUND=true
        AVAILABLE_DOCS+=("docs/ground-rules.md")
    fi
    
    # Check for feature specifications
    if [[ -d "$repo_root/specs" ]]; then
        local spec_files
        spec_files=$(find "$repo_root/specs" -name "spec.md" -type f | wc -l | tr -d ' ')
        SPECS_COUNT=$spec_files
        if [[ $spec_files -gt 0 ]]; then
            AVAILABLE_DOCS+=("specs/ ($spec_files specifications)")
        fi
    fi
    
    # Check for architecture-overview.md
    if [[ -f "$repo_root/docs/architecture-overview.md" ]]; then
        AVAILABLE_DOCS+=("architecture-overview.md")
    fi
    
    # Check for deployment-guide.md
    if [[ -f "$repo_root/docs/deployment-guide.md" ]]; then
        AVAILABLE_DOCS+=("deployment-guide.md")
    fi
}

# Function to output JSON
output_json() {
    local success="$1"
    local arch_file="$2"
    
    if [[ "$success" == "true" ]]; then
        echo "{"
        echo "  \"success\": true,"
        echo "  \"architecture_file\": \"$arch_file\","
        echo "  \"available_docs\": ["
        
        local first=true
        for doc in "${AVAILABLE_DOCS[@]}"; do
            if [[ "$first" == "true" ]]; then
                first=false
            else
                echo ","
            fi
            echo -n "    \"$doc\""
        done
        echo ""
        echo "  ],"
        
        echo "  \"adr_count\": $ADR_COUNT,"
        echo "  \"specs_count\": $SPECS_COUNT,"
        echo "  \"ground_rules_found\": $GROUND_RULES_FOUND,"
        echo "  \"diagrams_found\": $DIAGRAMS_FOUND"
        echo "}"
    else
        local current_dir
        current_dir="$(pwd)"
        echo "{"
        echo "  \"success\": false,"
        echo "  \"error\": \"No architecture.md found\","
        echo "  \"message\": \"Could not find architecture.md in standard locations\","
        echo "  \"searched_paths\": ["
        echo "    \"$current_dir/docs/architecture.md\","
        echo "    \"$current_dir/architecture.md\","
        echo "    \"$current_dir/.phoenix/docs/architecture.md\""
        echo "  ]"
        echo "}"
    fi
}

# Function to output human-readable format
output_human() {
    local success="$1"
    local arch_file="$2"
    
    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}✓${NC} Architecture file: $arch_file"
        echo ""
        echo -e "${GREEN}✓${NC} Supporting documents found (${#AVAILABLE_DOCS[@]}):"
        for doc in "${AVAILABLE_DOCS[@]}"; do
            echo "  • $doc"
        done
        
        echo ""
        echo -e "${GREEN}✓${NC} Architecture statistics:"
        echo "  • ADR files: $ADR_COUNT"
        echo "  • Feature specifications: $SPECS_COUNT"
        echo "  • Ground rules: $([ "$GROUND_RULES_FOUND" = true ] && echo "Yes" || echo "No")"
        echo "  • Mermaid diagrams: $DIAGRAMS_FOUND"
        
        if [[ $ADR_COUNT -lt 3 ]]; then
            echo ""
            echo -e "${YELLOW}⚠${NC} Warning: Only $ADR_COUNT ADR(s) found. Recommended minimum: 3-5 ADRs"
        fi
        
        if [[ "$GROUND_RULES_FOUND" == "false" ]]; then
            echo ""
            echo -e "${YELLOW}⚠${NC} Warning: Ground rules not found. Alignment check will be skipped."
        fi
    else
        local current_dir
        current_dir="$(pwd)"
        echo -e "${RED}✗${NC} Error: No architecture.md found"
        echo ""
        echo "Could not find architecture.md in standard locations"
        echo ""
        echo "Searched paths:"
        echo "  • $current_dir/docs/architecture.md"
        echo "  • $current_dir/architecture.md"
        echo "  • $current_dir/.phoenix/docs/architecture.md"
    fi
}

# Main execution
main() {
    local found_file
    local repo_root
    
    # Find repository root
    if repo_root=$(find_repo_root); then
        cd "$repo_root"
    else
        repo_root="$(pwd)"
    fi
    
    # Find or use specified architecture file
    if [[ -n "$ARCH_FILE" ]]; then
        if [[ -f "$ARCH_FILE" ]]; then
            found_file="$ARCH_FILE"
        else
            if [[ "$OUTPUT_JSON" == "true" ]]; then
                output_json "false" ""
            else
                output_human "false" ""
            fi
            exit 1
        fi
    else
        if found_file=$(find_architecture_file); then
            :
        else
            if [[ "$OUTPUT_JSON" == "true" ]]; then
                output_json "false" ""
            else
                output_human "false" ""
            fi
            exit 1
        fi
    fi
    
    # Count Mermaid diagrams
    DIAGRAMS_FOUND=$(count_mermaid_diagrams "$found_file")
    
    # Scan supporting documents
    scan_supporting_docs "$repo_root"
    
    # Output results
    if [[ "$OUTPUT_JSON" == "true" ]]; then
        output_json "true" "$found_file"
    else
        output_human "true" "$found_file"
    fi
    
    # Exit with warning if ADR count is low
    if [[ $ADR_COUNT -lt 3 ]]; then
        exit 2
    fi
    
    exit 0
}

main
