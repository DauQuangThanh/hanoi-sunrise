#!/usr/bin/env bash

# check-tasks-to-issues-prerequisites.sh
# Checks for required files and configuration before running tasks-to-github-issues skill
# Usage: ./check-tasks-to-issues-prerequisites.sh [--json]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flags
JSON_OUTPUT=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --json)
            JSON_OUTPUT=true
            shift
            ;;
    esac
done

# Get workspace root (assuming script is in skills/tasks-to-github-issues/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Initialize variables
TASKS_FILE=""
GIT_REMOTE=""
REPO_OWNER=""
REPO_NAME=""
IS_GITHUB=false
IS_GIT_REPO=false
GIT_AVAILABLE=false

# Results
ALL_REQUIRED_PRESENT=true
ERRORS=()
WARNINGS=()
INFO=()

# Check if git is available
if command -v git &> /dev/null; then
    GIT_AVAILABLE=true
    INFO+=("Git command is available")
else
    ALL_REQUIRED_PRESENT=false
    ERRORS+=("Git command not found (required for repository operations)")
fi

# Check if we're in a git repository
if [ "$GIT_AVAILABLE" = true ]; then
    if git -C "$WORKSPACE_ROOT" rev-parse --git-dir &> /dev/null; then
        IS_GIT_REPO=true
        INFO+=("Repository is a Git repository")
    else
        ALL_REQUIRED_PRESENT=false
        ERRORS+=("Not a Git repository (run 'git init' to initialize)")
    fi
fi

# Get Git remote if available
if [ "$IS_GIT_REPO" = true ]; then
    GIT_REMOTE=$(git -C "$WORKSPACE_ROOT" config --get remote.origin.url 2>/dev/null || echo "")
    
    if [ -z "$GIT_REMOTE" ]; then
        ALL_REQUIRED_PRESENT=false
        ERRORS+=("No Git remote configured (run 'git remote add origin <url>')")
    else
        INFO+=("Git remote found: $GIT_REMOTE")
        
        # Check if remote is GitHub
        if [[ "$GIT_REMOTE" =~ github\.com ]]; then
            IS_GITHUB=true
            INFO+=("Remote is a GitHub repository")
            
            # Extract owner and repo name
            if [[ "$GIT_REMOTE" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
                REPO_OWNER="${BASH_REMATCH[1]}"
                REPO_NAME="${BASH_REMATCH[2]}"
                INFO+=("Repository: $REPO_OWNER/$REPO_NAME")
            else
                WARNINGS+=("Could not parse repository owner/name from remote URL")
            fi
        else
            ALL_REQUIRED_PRESENT=false
            ERRORS+=("Remote is not a GitHub repository (this skill only works with GitHub)")
        fi
    fi
fi

# Search for tasks.md files
TASKS_FILES=$(find "$WORKSPACE_ROOT" -name "tasks.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -type f 2>/dev/null || echo "")

if [ -z "$TASKS_FILES" ]; then
    ALL_REQUIRED_PRESENT=false
    ERRORS+=("No tasks.md file found in repository")
else
    TASKS_FILE_COUNT=$(echo "$TASKS_FILES" | wc -l | tr -d ' ')
    if [ "$TASKS_FILE_COUNT" -eq 1 ]; then
        TASKS_FILE="$TASKS_FILES"
        INFO+=("Found tasks.md at: $TASKS_FILE")
    else
        TASKS_FILE=$(echo "$TASKS_FILES" | head -n 1)
        WARNINGS+=("Multiple tasks.md files found ($TASKS_FILE_COUNT), using first: $TASKS_FILE")
    fi
fi

# Check for GitHub MCP server availability (optional check)
# This is informational only, not blocking
if [ "$IS_GITHUB" = true ]; then
    INFO+=("GitHub MCP server is required for issue creation")
fi

# Output results
if [ "$JSON_OUTPUT" = true ]; then
    # JSON output for programmatic parsing
    echo "{"
    echo "  \"success\": $([[ $ALL_REQUIRED_PRESENT == true ]] && echo "true" || echo "false"),"
    echo "  \"workspace_root\": \"$WORKSPACE_ROOT\","
    echo "  \"git\": {"
    echo "    \"available\": $([[ $GIT_AVAILABLE == true ]] && echo "true" || echo "false"),"
    echo "    \"is_repository\": $([[ $IS_GIT_REPO == true ]] && echo "true" || echo "false"),"
    echo "    \"remote\": \"$GIT_REMOTE\","
    echo "    \"is_github\": $([[ $IS_GITHUB == true ]] && echo "true" || echo "false")"
    echo "  },"
    echo "  \"repository\": {"
    echo "    \"owner\": \"$REPO_OWNER\","
    echo "    \"name\": \"$REPO_NAME\""
    echo "  },"
    echo "  \"tasks_file\": \"$TASKS_FILE\","
    echo "  \"errors\": ["
    for i in "${!ERRORS[@]}"; do
        echo -n "    \"${ERRORS[$i]}\""
        if [ $i -lt $((${#ERRORS[@]} - 1)) ]; then
            echo ","
        else
            echo ""
        fi
    done
    echo "  ],"
    echo "  \"warnings\": ["
    for i in "${!WARNINGS[@]}"; do
        echo -n "    \"${WARNINGS[$i]}\""
        if [ $i -lt $((${#WARNINGS[@]} - 1)) ]; then
            echo ","
        else
            echo ""
        fi
    done
    echo "  ],"
    echo "  \"info\": ["
    for i in "${!INFO[@]}"; do
        echo -n "    \"${INFO[$i]}\""
        if [ $i -lt $((${#INFO[@]} - 1)) ]; then
            echo ","
        else
            echo ""
        fi
    done
    echo "  ]"
    echo "}"
else
    # Human-readable output
    echo ""
    echo -e "${BLUE}Tasks to GitHub Issues - Prerequisites Check${NC}"
    echo "================================================"
    echo ""
    
    # Workspace info
    echo -e "${BLUE}Workspace:${NC} $WORKSPACE_ROOT"
    echo ""
    
    # Git section
    echo -e "${BLUE}Git Configuration:${NC}"
    if [ "$GIT_AVAILABLE" = true ]; then
        echo -e "  ${GREEN}✓${NC} Git command available"
    else
        echo -e "  ${RED}✗${NC} Git command not found (REQUIRED)"
    fi
    
    if [ "$IS_GIT_REPO" = true ]; then
        echo -e "  ${GREEN}✓${NC} Git repository initialized"
    else
        echo -e "  ${RED}✗${NC} Not a Git repository (REQUIRED)"
    fi
    
    if [ -n "$GIT_REMOTE" ]; then
        echo -e "  ${GREEN}✓${NC} Git remote configured"
        echo -e "    Remote: $GIT_REMOTE"
    else
        echo -e "  ${RED}✗${NC} No Git remote configured (REQUIRED)"
    fi
    
    if [ "$IS_GITHUB" = true ]; then
        echo -e "  ${GREEN}✓${NC} Remote is GitHub"
        echo -e "    Repository: $REPO_OWNER/$REPO_NAME"
    else
        if [ -n "$GIT_REMOTE" ]; then
            echo -e "  ${RED}✗${NC} Remote is not GitHub (REQUIRED - this skill only works with GitHub)"
        fi
    fi
    echo ""
    
    # Tasks file section
    echo -e "${BLUE}Task File:${NC}"
    if [ -n "$TASKS_FILE" ]; then
        echo -e "  ${GREEN}✓${NC} tasks.md found"
        echo -e "    Path: $TASKS_FILE"
    else
        echo -e "  ${RED}✗${NC} tasks.md not found (REQUIRED)"
    fi
    echo ""
    
    # Errors
    if [ ${#ERRORS[@]} -gt 0 ]; then
        echo -e "${RED}Errors:${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "  ${RED}✗${NC} $error"
        done
        echo ""
    fi
    
    # Warnings
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo -e "${YELLOW}Warnings:${NC}"
        for warning in "${WARNINGS[@]}"; do
            echo -e "  ${YELLOW}!${NC} $warning"
        done
        echo ""
    fi
    
    # Summary
    if [ "$ALL_REQUIRED_PRESENT" = true ]; then
        echo -e "${GREEN}✓ All prerequisites met. Ready to sync tasks to GitHub issues.${NC}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Ensure GitHub MCP server is configured with authentication"
        echo "  2. Run tasks-to-github-issues skill to create issues"
        echo "  3. Review created issues in repository: https://github.com/$REPO_OWNER/$REPO_NAME/issues"
    else
        echo -e "${RED}✗ Missing required prerequisites. Please resolve the following before proceeding:${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "  ${RED}-${NC} $error"
        done
        echo ""
        echo -e "${YELLOW}Tips:${NC}"
        if [ "$GIT_AVAILABLE" = false ]; then
            echo "  - Install Git: https://git-scm.com/downloads"
        fi
        if [ "$IS_GIT_REPO" = false ]; then
            echo "  - Initialize Git repository: git init"
        fi
        if [ -z "$GIT_REMOTE" ]; then
            echo "  - Add GitHub remote: git remote add origin https://github.com/owner/repo.git"
        fi
        if [ "$IS_GITHUB" = false ] && [ -n "$GIT_REMOTE" ]; then
            echo "  - This skill only works with GitHub repositories"
            echo "  - Change remote to GitHub or use manual issue creation"
        fi
        if [ -z "$TASKS_FILE" ]; then
            echo "  - Create tasks.md with task definitions"
            echo "  - Run 'taskify' command to generate tasks from specifications"
        fi
    fi
    echo ""
fi

# Exit with appropriate code
if [ "$ALL_REQUIRED_PRESENT" = true ]; then
    exit 0
else
    exit 1
fi
