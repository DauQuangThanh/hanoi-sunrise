#!/usr/bin/env bash
# check-standards-prerequisites.sh
# Detects required files for coding standards generation
# Usage: ./check-standards-prerequisites.sh [--json]
# Output: JSON with file paths and status

set -euo pipefail

# Parse arguments
JSON_OUTPUT=false
if [[ "${1:-}" == "--json" ]]; then
    JSON_OUTPUT=true
fi

# Get repository root (assumes script is in skills/coding-standards/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Initialize result structure
declare -A files
files[groundRules]=""
files[architecture]=""
files[existingStandards]=""
declare -a featureSpecs=()

# Function to find file (case-insensitive)
find_file() {
    local search_dir="$1"
    local pattern="$2"
    
    if [[ ! -d "$search_dir" ]]; then
        echo ""
        return
    fi
    
    local result=$(find "$search_dir" -maxdepth 1 -type f -iname "$pattern" 2>/dev/null | head -n 1)
    echo "$result"
}

# Check for ground-rules.md (required)
files[groundRules]=$(find_file "$REPO_ROOT/memory" "ground-rules.md")

# Check for architecture.md (recommended)
files[architecture]=$(find_file "$REPO_ROOT/docs" "architecture.md")

# Check for existing standards.md (for updates)
files[existingStandards]=$(find_file "$REPO_ROOT/docs" "standards.md")

# Find feature specifications
if [[ -d "$REPO_ROOT/specs" ]]; then
    while IFS= read -r -d '' spec_file; do
        featureSpecs+=("$spec_file")
    done < <(find "$REPO_ROOT/specs" -type f -iname "spec.md" -print0 2>/dev/null)
fi

# Check required files
missing_required=()
if [[ -z "${files[groundRules]}" ]]; then
    missing_required+=("docs/ground-rules.md")
fi

# Determine overall status
if [[ ${#missing_required[@]} -gt 0 ]]; then
    success=false
    message="Missing required file: ${missing_required[*]}"
else
    success=true
    message="All required files found"
fi

# Count found files
required_found=0
recommended_found=0
optional_found=0

if [[ -n "${files[groundRules]}" ]]; then
    required_found=$((required_found + 1))
fi

if [[ -n "${files[architecture]}" ]]; then
    recommended_found=$((recommended_found + 1))
fi

if [[ -n "${files[existingStandards]}" ]]; then
    optional_found=$((optional_found + 1))
fi

if [[ ${#featureSpecs[@]} -gt 0 ]]; then
    optional_found=$((optional_found + ${#featureSpecs[@]}))
fi

total_found=$((required_found + recommended_found + optional_found))

# Output JSON
if [[ "$JSON_OUTPUT" == "true" ]]; then
    # Build featureSpecs JSON array
    spec_array="["
    for i in "${!featureSpecs[@]}"; do
        spec_array+="\"${featureSpecs[$i]}\""
        if [[ $i -lt $((${#featureSpecs[@]} - 1)) ]]; then
            spec_array+=","
        fi
    done
    spec_array+="]"
    
    cat << EOF
{
  "success": $success,
  "message": "$message",
  "repositoryRoot": "$REPO_ROOT",
  "files": {
    "required": {
      "groundRules": "${files[groundRules]:-}"
    },
    "recommended": {
      "architecture": "${files[architecture]:-}"
    },
    "optional": {
      "existingStandards": "${files[existingStandards]:-}",
      "featureSpecs": $spec_array
    }
  },
  "summary": {
    "totalFound": $total_found,
    "requiredFound": $required_found,
    "recommendedFound": $recommended_found,
    "optionalFound": $optional_found,
    "featureSpecsCount": ${#featureSpecs[@]},
    "missingRequired": [$(printf '"%s",' "${missing_required[@]}" | sed 's/,$//')]
  }
}
EOF
else
    # Human-readable output
    echo ""
    echo "Coding Standards - Prerequisite Check"
    echo "======================================"
    echo ""
    echo "Repository Root: $REPO_ROOT"
    echo ""
    
    if [[ "$success" == "true" ]]; then
        echo "Status: SUCCESS"
    else
        echo "Status: INCOMPLETE"
    fi
    
    echo "Message: $message"
    echo ""
    
    echo "Required Files:"
    echo "  ground-rules.md  : $(if [[ -n "${files[groundRules]}" ]]; then echo "FOUND"; else echo "MISSING"; fi)"
    if [[ -n "${files[groundRules]}" ]]; then
        echo "                     ${files[groundRules]}"
    fi
    echo ""
    
    echo "Recommended Files:"
    echo "  architecture.md  : $(if [[ -n "${files[architecture]}" ]]; then echo "FOUND"; else echo "NOT FOUND"; fi)"
    if [[ -n "${files[architecture]}" ]]; then
        echo "                     ${files[architecture]}"
    fi
    echo ""
    
    echo "Optional Files:"
    echo "  standards.md     : $(if [[ -n "${files[existingStandards]}" ]]; then echo "FOUND (for updates)"; else echo "NOT FOUND (will create new)"; fi)"
    if [[ -n "${files[existingStandards]}" ]]; then
        echo "                     ${files[existingStandards]}"
    fi
    
    echo "  feature specs    : ${#featureSpecs[@]} found"
    if [[ ${#featureSpecs[@]} -gt 0 ]]; then
        for spec in "${featureSpecs[@]}"; do
            echo "                     $spec"
        done
    fi
    echo ""
    
    echo "Summary:"
    echo "  Total Found         : $total_found"
    echo "  Required Found      : $required_found / 1"
    echo "  Recommended Found   : $recommended_found / 1"
    echo "  Optional Found      : $optional_found"
    
    if [[ ${#missing_required[@]} -gt 0 ]]; then
        echo ""
        echo "Missing Required: ${missing_required[*]}"
    fi
    
    echo ""
fi

exit 0
