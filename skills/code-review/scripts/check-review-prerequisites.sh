#!/usr/bin/env bash
# check-review-prerequisites.sh - Check code review prerequisites and discover implementation artifacts
# Usage: bash check-review-prerequisites.sh [--json]

set -euo pipefail

# Determine script and project root directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Command-line arguments
JSON_OUTPUT=false
if [[ "${1:-}" == "--json" ]]; then
    JSON_OUTPUT=true
fi

# Feature discovery logic
find_feature_dir() {
    local search_paths=("specs" "features" "requirements" "docs/specs")
    
    for base_path in "${search_paths[@]}"; do
        local full_path="$REPO_ROOT/$base_path"
        if [[ -d "$full_path" ]]; then
            # Find directories containing spec.md or design.md
            while IFS= read -r -d '' spec_file; do
                local feature_dir
                feature_dir="$(dirname "$spec_file")"
                echo "$feature_dir"
                return 0
            done < <(find "$full_path" -name "spec.md" -o -name "design.md" -type f -print0 2>/dev/null | head -z -1)
        fi
    done
    
    return 1
}

# Discover implementation files (exclude tests, specs, docs)
find_implementation_files() {
    local feature_dir="$1"
    local impl_files=()
    
    # Common source directories
    local src_dirs=("src" "lib" "app" "components" "services" "controllers" "models")
    
    for src_dir in "${src_dirs[@]}"; do
        if [[ -d "$REPO_ROOT/$src_dir" ]]; then
            while IFS= read -r -d '' file; do
                # Exclude test files and node_modules
                if [[ ! "$file" =~ (test|spec|node_modules|coverage|dist|build) ]]; then
                    impl_files+=("$file")
                fi
            done < <(find "$REPO_ROOT/$src_dir" -type f \( -name "*.ts" -o -name "*.js" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.py" -o -name "*.java" -o -name "*.go" -o -name "*.rs" -o -name "*.cpp" -o -name "*.c" \) -print0 2>/dev/null)
        fi
    done
    
    printf '%s\n' "${impl_files[@]}"
}

# Discover test files
find_test_files() {
    local test_files=()
    
    # Common test directories and patterns
    local test_dirs=("tests" "test" "__tests__" "spec")
    
    for test_dir in "${test_dirs[@]}"; do
        if [[ -d "$REPO_ROOT/$test_dir" ]]; then
            while IFS= read -r -d '' file; do
                test_files+=("$file")
            done < <(find "$REPO_ROOT/$test_dir" -type f \( -name "*.test.*" -o -name "*.spec.*" \) -print0 2>/dev/null)
        fi
    done
    
    # Also check for test files in src directories
    while IFS= read -r -d '' file; do
        if [[ "$file" =~ \.(test|spec)\. ]]; then
            test_files+=("$file")
        fi
    done < <(find "$REPO_ROOT/src" -type f 2>/dev/null -print0 || true)
    
    printf '%s\n' "${test_files[@]}"
}

# Check for available documentation
check_available_docs() {
    local feature_dir="$1"
    local docs=()
    
    [[ -f "$feature_dir/spec.md" ]] && docs+=("spec.md")
    [[ -f "$feature_dir/design.md" ]] && docs+=("design.md")
    [[ -f "$feature_dir/tasks.md" ]] && docs+=("tasks.md")
    [[ -f "$feature_dir/data-model.md" ]] && docs+=("data-model.md")
    [[ -f "$feature_dir/research.md" ]] && docs+=("research.md")
    [[ -d "$feature_dir/contracts" ]] && docs+=("contracts/")
    [[ -d "$feature_dir/checklists" ]] && docs+=("checklists/")
    
    # Product-level docs
    [[ -f "$REPO_ROOT/docs/architecture.md" ]] && docs+=("docs/architecture.md")
    [[ -f "$REPO_ROOT/docs/standards.md" ]] && docs+=("docs/standards.md")
    
    printf '%s\n' "${docs[@]}"
}

# Check checklist status
check_checklists() {
    local feature_dir="$1"
    local checklists_dir="$feature_dir/checklists"
    
    if [[ ! -d "$checklists_dir" ]]; then
        echo "no_checklists"
        return
    fi
    
    local all_passed=true
    local checklist_details=()
    
    while IFS= read -r -d '' checklist_file; do
        local filename
        filename="$(basename "$checklist_file")"
        
        # Count total, completed, and incomplete items
        local total
        local completed
        local incomplete
        total=$(grep -cE '^\s*-\s+\[([ Xx])\]' "$checklist_file" 2>/dev/null || echo "0")
        completed=$(grep -cE '^\s*-\s+\[([Xx])\]' "$checklist_file" 2>/dev/null || echo "0")
        incomplete=$((total - completed))
        
        if [[ $incomplete -gt 0 ]]; then
            all_passed=false
        fi
        
        local status
        if [[ $incomplete -eq 0 ]]; then
            status="PASS"
        else
            status="FAIL"
        fi
        
        checklist_details+=("{\"name\":\"$filename\",\"total\":$total,\"completed\":$completed,\"incomplete\":$incomplete,\"status\":\"$status\"}")
    done < <(find "$checklists_dir" -name "*.md" -type f -print0 2>/dev/null)
    
    if [[ ${#checklist_details[@]} -eq 0 ]]; then
        echo "no_checklists"
        return
    fi
    
    if $all_passed; then
        echo "all_passed"
    else
        echo "some_incomplete"
    fi
    
    # Store details for JSON output (global variable)
    CHECKLIST_DETAILS=$(printf '%s\n' "${checklist_details[@]}" | paste -sd ',' -)
}

# Main execution
main() {
    # Find feature directory
    local feature_dir
    if ! feature_dir=$(find_feature_dir); then
        if $JSON_OUTPUT; then
            cat <<EOF
{
  "success": false,
  "error": "No feature directory with spec.md or design.md found. Expected in: specs/, features/, requirements/, docs/specs/"
}
EOF
        else
            echo "❌ Error: No feature directory with spec.md or design.md found."
            echo "Expected locations: specs/, features/, requirements/, docs/specs/"
        fi
        exit 1
    fi
    
    # Check for required documents
    local has_spec=false
    local has_design=false
    [[ -f "$feature_dir/spec.md" ]] && has_spec=true
    [[ -f "$feature_dir/design.md" ]] && has_design=true
    
    if [[ "$has_spec" == "false" ]] || [[ "$has_design" == "false" ]]; then
        if $JSON_OUTPUT; then
            cat <<EOF
{
  "success": false,
  "error": "Missing required documents. spec.md and design.md are required for code review."
}
EOF
        else
            echo "❌ Error: Missing required documents in: $feature_dir"
            echo "Required: spec.md and design.md"
        fi
        exit 1
    fi
    
    # Discover implementation files
    local implementation_files
    mapfile -t implementation_files < <(find_implementation_files "$feature_dir")
    
    # Discover test files
    local test_files
    mapfile -t test_files < <(find_test_files)
    
    # Check available documentation
    local available_docs
    mapfile -t available_docs < <(check_available_docs "$feature_dir")
    
    # Check checklists
    CHECKLIST_DETAILS=""
    local checklist_status
    checklist_status=$(check_checklists "$feature_dir")
    
    # Check for architecture and standards
    local architecture_available=false
    local standards_available=false
    [[ -f "$REPO_ROOT/docs/architecture.md" ]] && architecture_available=true
    [[ -f "$REPO_ROOT/docs/standards.md" ]] && standards_available=true
    
    # Output results
    if $JSON_OUTPUT; then
        # Build arrays
        local impl_json="["
        for i in "${!implementation_files[@]}"; do
            if [[ $i -gt 0 ]]; then
                impl_json+=","
            fi
            impl_json+="\"${implementation_files[$i]}\""
        done
        impl_json+="]"
        
        local test_json="["
        for i in "${!test_files[@]}"; do
            if [[ $i -gt 0 ]]; then
                test_json+=","
            fi
            test_json+="\"${test_files[$i]}\""
        done
        test_json+="]"
        
        local docs_json="["
        for i in "${!available_docs[@]}"; do
            if [[ $i -gt 0 ]]; then
                docs_json+=","
            fi
            docs_json+="\"${available_docs[$i]}\""
        done
        docs_json+="]"
        
        local checklists_json="[]"
        if [[ -n "$CHECKLIST_DETAILS" ]]; then
            checklists_json="[$CHECKLIST_DETAILS]"
        fi
        
        cat <<EOF
{
  "success": true,
  "feature_dir": "$feature_dir",
  "available_docs": $docs_json,
  "implementation_files": $impl_json,
  "test_files": $test_json,
  "checklist_status": "$checklist_status",
  "checklist_details": $checklists_json,
  "architecture_available": $architecture_available,
  "standards_available": $standards_available
}
EOF
    else
        echo "✅ Code Review Prerequisites Check"
        echo ""
        echo "Feature Directory: $feature_dir"
        echo ""
        echo "Available Documentation:"
        printf '  - %s\n' "${available_docs[@]}"
        echo ""
        echo "Implementation Files Found: ${#implementation_files[@]}"
        echo "Test Files Found: ${#test_files[@]}"
        echo ""
        echo "Checklist Status: $checklist_status"
        echo "Architecture Available: $architecture_available"
        echo "Standards Available: $standards_available"
    fi
}

main "$@"
