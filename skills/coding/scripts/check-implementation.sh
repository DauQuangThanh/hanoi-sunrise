#!/usr/bin/env bash
# check-implementation.sh - Check implementation prerequisites and analyze tasks.md
# Usage: bash check-implementation.sh [--json]

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
            # Find directories containing tasks.md
            while IFS= read -r -d '' tasks_file; do
                local feature_dir
                feature_dir="$(dirname "$tasks_file")"
                echo "$feature_dir"
                return 0
            done < <(find "$full_path" -name "tasks.md" -type f -print0 2>/dev/null)
        fi
    done
    
    return 1
}

# Count tasks in tasks.md
count_tasks() {
    local tasks_file="$1"
    if [[ ! -f "$tasks_file" ]]; then
        echo "0"
        return
    fi
    
    # Count lines that match task pattern: - [ ] or - [X] or - [x]
    grep -cE '^\s*-\s+\[([ Xx])\]' "$tasks_file" 2>/dev/null || echo "0"
}

# Check for available documentation
check_available_docs() {
    local feature_dir="$1"
    local docs=()
    
    [[ -f "$feature_dir/tasks.md" ]] && docs+=("tasks.md")
    [[ -f "$feature_dir/design.md" ]] && docs+=("design.md")
    [[ -f "$feature_dir/spec.md" ]] && docs+=("spec.md")
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
  "error": "No feature directory with tasks.md found. Expected in: specs/, features/, requirements/, docs/specs/"
}
EOF
        else
            echo "❌ Error: No feature directory with tasks.md found."
            echo "Expected locations: specs/, features/, requirements/, docs/specs/"
        fi
        exit 1
    fi
    
    local tasks_file="$feature_dir/tasks.md"
    
    # Verify tasks.md exists
    if [[ ! -f "$tasks_file" ]]; then
        if $JSON_OUTPUT; then
            cat <<EOF
{
  "success": false,
  "error": "tasks.md not found in feature directory: $feature_dir"
}
EOF
        else
            echo "❌ Error: tasks.md not found in: $feature_dir"
        fi
        exit 1
    fi
    
    # Count tasks
    local task_count
    task_count=$(count_tasks "$tasks_file")
    
    # Check available documentation
    local available_docs
    mapfile -t available_docs < <(check_available_docs "$feature_dir")
    
    # Check checklists
    CHECKLIST_DETAILS=""
    local checklist_status
    checklist_status=$(check_checklists "$feature_dir")
    
    # Output results
    if $JSON_OUTPUT; then
        # Build available_docs array
        local docs_json="["
        for i in "${!available_docs[@]}"; do
            if [[ $i -gt 0 ]]; then
                docs_json+=","
            fi
            docs_json+="\"${available_docs[$i]}\""
        done
        docs_json+="]"
        
        # Build checklist_details array
        local checklists_json="[]"
        if [[ -n "$CHECKLIST_DETAILS" ]]; then
            checklists_json="[$CHECKLIST_DETAILS]"
        fi
        
        cat <<EOF
{
  "success": true,
  "feature_dir": "$feature_dir",
  "tasks_file": "$tasks_file",
  "available_docs": $docs_json,
  "task_count": $task_count,
  "checklist_status": "$checklist_status",
  "checklist_details": $checklists_json
}
EOF
    else
        echo "✅ Implementation Prerequisites Check"
        echo ""
        echo "Feature Directory: $feature_dir"
        echo "Tasks File: $tasks_file"
        echo "Task Count: $task_count"
        echo ""
        echo "Available Documentation:"
        printf '  - %s\n' "${available_docs[@]}"
        echo ""
        echo "Checklist Status: $checklist_status"
        
        if [[ "$checklist_status" == "some_incomplete" ]]; then
            echo ""
            echo "⚠️  Some checklists have incomplete items. Review before proceeding."
        elif [[ "$checklist_status" == "all_passed" ]]; then
            echo ""
            echo "✅ All checklists passed."
        fi
    fi
}

main "$@"
