#!/usr/bin/env bash
# check-prerequisites.sh - Check prerequisites and identify feature directory (Unix-like systems)
#
# Usage:
#   bash check-prerequisites.sh [--json]
#   bash check-prerequisites.sh --feature-dir /path/to/feature
#
# Options:
#   --json          Output results as JSON
#   --feature-dir   Specify feature directory explicitly
#
# Author: Dau Quang Thanh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REQUIRED_DOCS=("design.md" "spec.md")
OPTIONAL_DOCS=("data-model.md" "research.md" "quickstart.md" "architecture.md")
OPTIONAL_DIRS=("contracts")

# Variables
OUTPUT_JSON=false
FEATURE_DIR=""
AVAILABLE_DOCS=()
MISSING_REQUIRED=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --feature-dir)
            FEATURE_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to check if directory is a feature directory
is_feature_dir() {
    local dir="$1"
    [[ -f "$dir/design.md" ]] || [[ -f "$dir/spec.md" ]]
}

# Function to find feature directory
find_feature_dir() {
    local current_dir
    current_dir="$(pwd)"
    
    # Check current directory first
    if is_feature_dir "$current_dir"; then
        echo "$current_dir"
        return 0
    fi
    
    # Check .phoenix/features/* subdirectories
    if [[ -d "$current_dir/.phoenix/features" ]]; then
        for subdir in "$current_dir/.phoenix/features"/*; do
            if [[ -d "$subdir" ]] && is_feature_dir "$subdir"; then
                echo "$subdir"
                return 0
            fi
        done
    fi
    
    # Check features/* subdirectories
    if [[ -d "$current_dir/features" ]]; then
        for subdir in "$current_dir/features"/*; do
            if [[ -d "$subdir" ]] && is_feature_dir "$subdir"; then
                echo "$subdir"
                return 0
            fi
        done
    fi
    
    # Check docs/features/* subdirectories
    if [[ -d "$current_dir/docs/features" ]]; then
        for subdir in "$current_dir/docs/features"/*; do
            if [[ -d "$subdir" ]] && is_feature_dir "$subdir"; then
                echo "$subdir"
                return 0
            fi
        done
    fi
    
    return 1
}

# Function to find repository root
find_repo_root() {
    local dir="$1"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Function to scan documents
scan_documents() {
    local feature_dir="$1"
    
    AVAILABLE_DOCS=()
    MISSING_REQUIRED=()
    
    # Check required documents
    for doc in "${REQUIRED_DOCS[@]}"; do
        if [[ -f "$feature_dir/$doc" ]]; then
            AVAILABLE_DOCS+=("$doc")
        else
            MISSING_REQUIRED+=("$doc")
        fi
    done
    
    # Check optional documents
    for doc in "${OPTIONAL_DOCS[@]}"; do
        if [[ -f "$feature_dir/$doc" ]]; then
            AVAILABLE_DOCS+=("$doc")
        fi
    done
    
    # Check optional directories
    for dir_name in "${OPTIONAL_DIRS[@]}"; do
        if [[ -d "$feature_dir/$dir_name" ]]; then
            local file_count
            file_count=$(find "$feature_dir/$dir_name" -name "*.md" -type f | wc -l | tr -d ' ')
            if [[ $file_count -gt 0 ]]; then
                AVAILABLE_DOCS+=("$dir_name/ ($file_count files)")
            fi
        fi
    done
    
    # Check product-level architecture.md
    local repo_root
    if repo_root=$(find_repo_root "$feature_dir"); then
        if [[ -f "$repo_root/docs/architecture.md" ]]; then
            AVAILABLE_DOCS+=("docs/architecture.md")
        fi
    fi
}

# Function to output JSON
output_json() {
    local success="$1"
    local feature_dir="$2"
    
    if [[ "$success" == "true" ]]; then
        echo "{"
        echo "  \"success\": true,"
        echo "  \"feature_dir\": \"$feature_dir\","
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
        
        echo "  \"missing_required\": ["
        first=true
        for doc in "${MISSING_REQUIRED[@]}"; do
            if [[ "$first" == "true" ]]; then
                first=false
            else
                echo ","
            fi
            echo -n "    \"$doc\""
        done
        echo ""
        echo "  ]"
        
        if [[ ${#MISSING_REQUIRED[@]} -gt 0 ]]; then
            echo ","
            echo "  \"warning\": \"Missing required documents: ${MISSING_REQUIRED[*]}\""
        fi
        
        echo "}"
    else
        local current_dir
        current_dir="$(pwd)"
        echo "{"
        echo "  \"success\": false,"
        echo "  \"error\": \"No feature directory found\","
        echo "  \"message\": \"Could not find feature directory. Looking for directory containing design.md or spec.md\","
        echo "  \"searched_paths\": ["
        echo "    \"$current_dir\","
        echo "    \"$current_dir/.phoenix/features\","
        echo "    \"$current_dir/features\","
        echo "    \"$current_dir/docs/features\""
        echo "  ]"
        echo "}"
    fi
}

# Function to output human-readable format
output_human() {
    local success="$1"
    local feature_dir="$2"
    
    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}✓${NC} Feature directory: $feature_dir"
        echo ""
        echo -e "${GREEN}✓${NC} Available documents (${#AVAILABLE_DOCS[@]}):"
        for doc in "${AVAILABLE_DOCS[@]}"; do
            echo "  • $doc"
        done
        
        if [[ ${#MISSING_REQUIRED[@]} -gt 0 ]]; then
            echo ""
            echo -e "${YELLOW}⚠${NC} Missing required documents:"
            for doc in "${MISSING_REQUIRED[@]}"; do
                echo "  • $doc"
            done
        fi
    else
        local current_dir
        current_dir="$(pwd)"
        echo -e "${RED}✗${NC} Error: No feature directory found"
        echo ""
        echo "Could not find feature directory. Looking for directory containing design.md or spec.md"
        echo ""
        echo "Searched paths:"
        echo "  • $current_dir"
        echo "  • $current_dir/.phoenix/features"
        echo "  • $current_dir/features"
        echo "  • $current_dir/docs/features"
    fi
}

# Main execution
main() {
    local found_dir
    
    # Find or use specified feature directory
    if [[ -n "$FEATURE_DIR" ]]; then
        found_dir="$FEATURE_DIR"
    else
        if found_dir=$(find_feature_dir); then
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
    
    # Scan documents
    scan_documents "$found_dir"
    
    # Output results
    if [[ "$OUTPUT_JSON" == "true" ]]; then
        output_json "true" "$found_dir"
    else
        output_human "true" "$found_dir"
    fi
    
    # Exit with error if missing required documents
    if [[ ${#MISSING_REQUIRED[@]} -gt 0 ]]; then
        exit 1
    fi
    
    exit 0
}

main
