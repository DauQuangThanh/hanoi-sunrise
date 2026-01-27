#!/bin/bash
# Analyze Git History Script
# Author: Dau Quang Thanh
# License: MIT
# Description: Analyzes git history to find when and how bugs were introduced

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_header() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository"
        exit 1
    fi
}

# Function to show recent changes to a file
analyze_file_history() {
    local file="$1"
    local limit="${2:-10}"
    
    if [ ! -f "$file" ]; then
        print_error "File not found: $file"
        return 1
    fi
    
    print_header "Recent changes to: $file"
    echo ""
    
    git log -n "$limit" --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset%n  %s%n" --date=short -- "$file"
    
    echo ""
}

# Function to show who last modified specific lines
analyze_file_blame() {
    local file="$1"
    local start_line="${2:-1}"
    local end_line="${3:-}"
    
    if [ ! -f "$file" ]; then
        print_error "File not found: $file"
        return 1
    fi
    
    print_header "Blame for: $file"
    echo ""
    
    if [ -n "$end_line" ]; then
        git blame -L "$start_line,$end_line" "$file"
    else
        git blame "$file" | head -n 50
        local total_lines=$(wc -l < "$file")
        if [ "$total_lines" -gt 50 ]; then
            echo ""
            print_info "Showing first 50 lines. Total lines: $total_lines"
            echo "To see specific lines, run: git blame -L <start>,<end> $file"
        fi
    fi
    
    echo ""
}

# Function to find when a string was introduced or changed
search_git_history() {
    local search_term="$1"
    local file="${2:-}"
    
    print_header "Searching for: $search_term"
    echo ""
    
    if [ -n "$file" ]; then
        print_info "Searching in file: $file"
        echo ""
        git log -S "$search_term" --source --all --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset%n  %s%n" --date=short -- "$file"
    else
        print_info "Searching in all files"
        echo ""
        git log -S "$search_term" --source --all --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset%n  %s%n" --date=short
    fi
    
    echo ""
}

# Function to analyze changes between two commits
compare_commits() {
    local commit1="$1"
    local commit2="${2:-HEAD}"
    local file="${3:-}"
    
    print_header "Comparing commits: $commit1 ... $commit2"
    echo ""
    
    if ! git rev-parse "$commit1" > /dev/null 2>&1; then
        print_error "Invalid commit: $commit1"
        return 1
    fi
    
    if ! git rev-parse "$commit2" > /dev/null 2>&1; then
        print_error "Invalid commit: $commit2"
        return 1
    fi
    
    if [ -n "$file" ]; then
        print_info "Changes in file: $file"
        echo ""
        git diff "$commit1".."$commit2" -- "$file"
    else
        print_info "Files changed:"
        echo ""
        git diff --name-status "$commit1".."$commit2"
    fi
    
    echo ""
}

# Function to find commits that changed a specific function
find_function_changes() {
    local function_name="$1"
    local file="${2:-}"
    
    print_header "Finding changes to function: $function_name"
    echo ""
    
    if [ -n "$file" ]; then
        git log -L :"$function_name":"$file" --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset%n  %s%n" --date=short
    else
        print_warning "For best results, specify the file containing the function"
        search_git_history "$function_name"
    fi
    
    echo ""
}

# Function to show commits in a date range
analyze_date_range() {
    local since="$1"
    local until="${2:-now}"
    local file="${3:-}"
    
    print_header "Commits between $since and $until"
    echo ""
    
    if [ -n "$file" ]; then
        git log --since="$since" --until="$until" --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset%n  %s%n" --date=short -- "$file"
    else
        git log --since="$since" --until="$until" --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset%n  %s%n" --date=short --stat
    fi
    
    echo ""
}

# Function to start git bisect interactively
start_bisect() {
    local good_commit="$1"
    local bad_commit="${2:-HEAD}"
    
    print_header "Starting Git Bisect"
    echo ""
    
    print_info "This will help you find the commit that introduced a bug"
    print_info "Good commit (working): $good_commit"
    print_info "Bad commit (broken): $bad_commit"
    echo ""
    
    print_warning "You will need to test each commit and mark it as 'good' or 'bad'"
    echo ""
    
    read -p "Start bisect? (y/n): " confirm
    
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        print_info "Bisect cancelled"
        return 0
    fi
    
    git bisect start
    git bisect bad "$bad_commit"
    git bisect good "$good_commit"
    
    echo ""
    print_success "Bisect started. Test the current commit and run:"
    echo "  git bisect good  - if the commit works"
    echo "  git bisect bad   - if the commit is broken"
    echo "  git bisect reset - to exit bisect mode"
    echo ""
}

# Function to show help
show_help() {
    cat << EOF

Git History Analysis Tool

Usage: $0 <command> [options]

Commands:
  file-history <file> [limit]              Show recent changes to a file
  blame <file> [start-line] [end-line]     Show who last modified each line
  search <term> [file]                      Find when a string was added/changed
  compare <commit1> [commit2] [file]        Compare two commits
  function <name> [file]                    Find changes to a specific function
  date-range <since> [until] [file]         Show commits in a date range
  bisect <good-commit> [bad-commit]         Start interactive bisect session

Examples:
  # Show last 10 changes to a file
  $0 file-history src/app.js

  # Show who wrote lines 10-20 in a file
  $0 blame src/app.js 10 20

  # Find when "processPayment" was added or changed
  $0 search "processPayment" src/payment.js

  # Compare two commits
  $0 compare abc123 def456

  # Find changes to a function
  $0 function calculateTotal src/cart.js

  # Show commits from last week
  $0 date-range "1 week ago"

  # Start bisect to find when bug was introduced
  $0 bisect v1.0.0 HEAD

EOF
}

# Main function
main() {
    # Check if we're in a git repository
    check_git_repo
    
    # Parse command
    local command="${1:-help}"
    
    case "$command" in
        file-history)
            if [ -z "$2" ]; then
                print_error "File path required"
                echo "Usage: $0 file-history <file> [limit]"
                exit 1
            fi
            analyze_file_history "$2" "${3:-10}"
            ;;
        
        blame)
            if [ -z "$2" ]; then
                print_error "File path required"
                echo "Usage: $0 blame <file> [start-line] [end-line]"
                exit 1
            fi
            analyze_file_blame "$2" "$3" "$4"
            ;;
        
        search)
            if [ -z "$2" ]; then
                print_error "Search term required"
                echo "Usage: $0 search <term> [file]"
                exit 1
            fi
            search_git_history "$2" "$3"
            ;;
        
        compare)
            if [ -z "$2" ]; then
                print_error "Commit required"
                echo "Usage: $0 compare <commit1> [commit2] [file]"
                exit 1
            fi
            compare_commits "$2" "$3" "$4"
            ;;
        
        function)
            if [ -z "$2" ]; then
                print_error "Function name required"
                echo "Usage: $0 function <name> [file]"
                exit 1
            fi
            find_function_changes "$2" "$3"
            ;;
        
        date-range)
            if [ -z "$2" ]; then
                print_error "Start date required"
                echo "Usage: $0 date-range <since> [until] [file]"
                exit 1
            fi
            analyze_date_range "$2" "$3" "$4"
            ;;
        
        bisect)
            if [ -z "$2" ]; then
                print_error "Good commit required"
                echo "Usage: $0 bisect <good-commit> [bad-commit]"
                exit 1
            fi
            start_bisect "$2" "$3"
            ;;
        
        help|--help|-h)
            show_help
            ;;
        
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
