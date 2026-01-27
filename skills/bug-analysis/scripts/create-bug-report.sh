#!/bin/bash
# Create Bug Report Script
# Author: Dau Quang Thanh
# License: MIT
# Description: Creates a new structured bug report from template

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$SKILL_DIR/templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to get next bug ID
get_next_bug_id() {
    local bugs_dir="$1"
    
    if [ ! -d "$bugs_dir" ]; then
        echo "001"
        return
    fi
    
    # Find all BUG-*.md files and extract numbers
    local max_num=0
    for file in "$bugs_dir"/BUG-*.md; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local num=$(echo "$filename" | sed -n 's/BUG-\([0-9]*\)-.*/\1/p')
            if [ -n "$num" ]; then
                num=$((10#$num))  # Convert to decimal
                if [ $num -gt $max_num ]; then
                    max_num=$num
                fi
            fi
        fi
    done
    
    # Increment and format with leading zeros
    local next_num=$((max_num + 1))
    printf "%03d" $next_num
}

# Function to sanitize title for filename
sanitize_filename() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//' | cut -c1-50
}

# Main function
main() {
    echo ""
    print_info "Bug Report Creator"
    echo ""
    
    # Check if template exists
    if [ ! -f "$TEMPLATE_DIR/bug-report-template.md" ]; then
        print_error "Template not found: $TEMPLATE_DIR/bug-report-template.md"
        exit 1
    fi
    
    # Determine bugs directory
    local bugs_dir
    if [ -d ".github" ]; then
        bugs_dir=".github/bugs"
    elif [ -d ".claude" ]; then
        bugs_dir=".claude/bugs"
    elif [ -d ".copilot" ]; then
        bugs_dir=".copilot/bugs"
    elif [ -d ".cursor" ]; then
        bugs_dir=".cursor/bugs"
    else
        bugs_dir="bugs"
    fi
    
    print_info "Bugs will be saved to: $bugs_dir"
    
    # Create bugs directory if it doesn't exist
    mkdir -p "$bugs_dir"
    
    # Get bug information
    echo ""
    read -p "Bug title: " bug_title
    
    if [ -z "$bug_title" ]; then
        print_error "Bug title is required"
        exit 1
    fi
    
    read -p "Severity (Critical/High/Medium/Low) [Medium]: " severity
    severity=${severity:-Medium}
    
    read -p "Priority (P0/P1/P2/P3) [P2]: " priority
    priority=${priority:-P2}
    
    read -p "Reporter name [$(git config user.name)]: " reporter
    reporter=${reporter:-$(git config user.name)}
    
    # Get next bug ID
    local bug_id=$(get_next_bug_id "$bugs_dir")
    
    # Create filename
    local sanitized_title=$(sanitize_filename "$bug_title")
    local filename="BUG-${bug_id}-${sanitized_title}.md"
    local filepath="$bugs_dir/$filename"
    
    # Check if file already exists
    if [ -f "$filepath" ]; then
        print_error "File already exists: $filepath"
        exit 1
    fi
    
    # Copy template and replace placeholders
    cp "$TEMPLATE_DIR/bug-report-template.md" "$filepath"
    
    # Get current date
    local current_date=$(date +%Y-%m-%d)
    
    # Replace placeholders using sed (portable version)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\[Issue Title\]/$bug_title/g" "$filepath"
        sed -i '' "s/\[BUG-ID\]/BUG-$bug_id/g" "$filepath"
        sed -i '' "s/Critical | High | Medium | Low/$severity/g" "$filepath"
        sed -i '' "s/P0 | P1 | P2 | P3/$priority/g" "$filepath"
        sed -i '' "s/YYYY-MM-DD/$current_date/g" "$filepath"
        sed -i '' "s/\[Reporter Name\]/$reporter/g" "$filepath"
    else
        # Linux
        sed -i "s/\[Issue Title\]/$bug_title/g" "$filepath"
        sed -i "s/\[BUG-ID\]/BUG-$bug_id/g" "$filepath"
        sed -i "s/Critical | High | Medium | Low/$severity/g" "$filepath"
        sed -i "s/P0 | P1 | P2 | P3/$priority/g" "$filepath"
        sed -i "s/YYYY-MM-DD/$current_date/g" "$filepath"
        sed -i "s/\[Reporter Name\]/$reporter/g" "$filepath"
    fi
    
    echo ""
    print_success "Bug report created: $filepath"
    print_info "Bug ID: BUG-$bug_id"
    print_info "Title: $bug_title"
    print_info "Severity: $severity"
    print_info "Priority: $priority"
    
    # Open in editor if available
    if command -v code &> /dev/null; then
        echo ""
        read -p "Open in VS Code? (y/n) [y]: " open_editor
        open_editor=${open_editor:-y}
        
        if [ "$open_editor" = "y" ] || [ "$open_editor" = "Y" ]; then
            code "$filepath"
            print_success "Opened in VS Code"
        fi
    fi
    
    echo ""
    print_info "Next steps:"
    echo "  1. Fill in the bug report details"
    echo "  2. Reproduce the issue"
    echo "  3. Attach screenshots/logs if applicable"
    echo "  4. Analyze the root cause"
    echo "  5. Propose solutions"
    echo ""
}

# Run main function
main "$@"
