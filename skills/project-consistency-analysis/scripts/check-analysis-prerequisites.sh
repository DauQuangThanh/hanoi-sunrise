#!/usr/bin/env bash
# check-analysis-prerequisites.sh
# Detects required artifacts for project consistency analysis
# Usage: ./check-analysis-prerequisites.sh [feature-directory]
# Output: JSON with artifact paths and status

set -euo pipefail

# Default to current directory if no argument provided
FEATURE_DIR="${1:-.}"

# Initialize result structure
declare -A artifacts
artifacts[spec]=""
artifacts[design]=""
artifacts[tasks]=""
artifacts[groundRules]=""
artifacts[architecture]=""
artifacts[standards]=""

# Check if directory exists
if [[ ! -d "$FEATURE_DIR" ]]; then
    cat << EOF
{
  "success": false,
  "error": "Directory not found: $FEATURE_DIR",
  "featureDirectory": "$FEATURE_DIR"
}
EOF
    exit 1
fi

# Convert to absolute path
FEATURE_DIR=$(cd "$FEATURE_DIR" && pwd)

# Function to find file (case-insensitive)
find_file() {
    local dir="$1"
    local pattern="$2"
    local result=$(find "$dir" -maxdepth 1 -type f -iname "$pattern" 2>/dev/null | head -n 1)
    echo "$result"
}

# Required artifacts
artifacts[spec]=$(find_file "$FEATURE_DIR" "spec.md")
artifacts[design]=$(find_file "$FEATURE_DIR" "design.md")
artifacts[tasks]=$(find_file "$FEATURE_DIR" "tasks.md")

# Optional artifacts
artifacts[groundRules]=$(find_file "$FEATURE_DIR/memory" "ground-rules.md" || find_file "$FEATURE_DIR/../memory" "ground-rules.md" || echo "")
artifacts[architecture]=$(find_file "$FEATURE_DIR/docs" "architecture.md" || find_file "$FEATURE_DIR/../docs" "architecture.md" || echo "")
artifacts[standards]=$(find_file "$FEATURE_DIR/docs" "standards.md" || find_file "$FEATURE_DIR/../docs" "standards.md" || echo "")

# Check required artifacts
missing_required=()
if [[ -z "${artifacts[spec]}" ]]; then
    missing_required+=("spec.md")
fi
if [[ -z "${artifacts[design]}" ]]; then
    missing_required+=("design.md")
fi
if [[ -z "${artifacts[tasks]}" ]]; then
    missing_required+=("tasks.md")
fi

# Determine overall status
if [[ ${#missing_required[@]} -gt 0 ]]; then
    success=false
    message="Missing required artifacts: ${missing_required[*]}"
else
    success=true
    message="All required artifacts found"
fi

# Count artifacts
total_found=0
required_found=0
optional_found=0

for key in "${!artifacts[@]}"; do
    if [[ -n "${artifacts[$key]}" ]]; then
        total_found=$((total_found + 1))
        if [[ "$key" == "spec" || "$key" == "design" || "$key" == "tasks" ]]; then
            required_found=$((required_found + 1))
        else
            optional_found=$((optional_found + 1))
        fi
    fi
done

# Output JSON
cat << EOF
{
  "success": $success,
  "message": "$message",
  "featureDirectory": "$FEATURE_DIR",
  "artifacts": {
    "required": {
      "spec": "${artifacts[spec]:-}",
      "design": "${artifacts[design]:-}",
      "tasks": "${artifacts[tasks]:-}"
    },
    "optional": {
      "groundRules": "${artifacts[groundRules]:-}",
      "architecture": "${artifacts[architecture]:-}",
      "standards": "${artifacts[standards]:-}"
    }
  },
  "summary": {
    "totalFound": $total_found,
    "requiredFound": $required_found,
    "optionalFound": $optional_found,
    "missingRequired": [$(printf '"%s",' "${missing_required[@]}" | sed 's/,$//')]
  }
}
EOF

exit 0
