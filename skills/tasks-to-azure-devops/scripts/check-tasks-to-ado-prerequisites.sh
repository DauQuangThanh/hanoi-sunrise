#!/usr/bin/env bash
# check-tasks-to-ado-prerequisites.sh
# Checks for required files and configuration before running tasks-to-azure-devops skill
# Usage: ./check-tasks-to-ado-prerequisites.sh [--json]

set -euo pipefail

# Get workspace root (assuming script is in skills/tasks-to-azure-devops/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize variables
TASKS_FILE=""
GIT_REMOTE=""
ADO_ORG=""
ADO_PROJECT=""
ADO_REPO=""
IS_AZURE_DEVOPS=false
IS_GIT_REPO=false
GIT_AVAILABLE=false

# Results
ALL_REQUIRED_PRESENT=true
ERRORS=()
WARNINGS=()
INFO=()

# Check if --json flag is provided
JSON_OUTPUT=false
if [[ "${1:-}" == "--json" ]]; then
    JSON_OUTPUT=true
fi

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
    if GIT_REMOTE=$(git -C "$WORKSPACE_ROOT" config --get remote.origin.url 2>/dev/null); then
        if [ -z "$GIT_REMOTE" ]; then
            ALL_REQUIRED_PRESENT=false
            ERRORS+=("No Git remote configured (run 'git remote add origin <url>')")
        else
            INFO+=("Git remote found: $GIT_REMOTE")
            
            # Check if remote is Azure DevOps and extract organization/project
            if [[ "$GIT_REMOTE" =~ dev\.azure\.com ]]; then
                IS_AZURE_DEVOPS=true
                INFO+=("Remote is an Azure DevOps repository")
                
                # Parse: https://dev.azure.com/{organization}/{project}/_git/{repository}
                if [[ "$GIT_REMOTE" =~ dev\.azure\.com/([^/]+)/([^/]+)/_git/([^/]+) ]]; then
                    ADO_ORG="${BASH_REMATCH[1]}"
                    ADO_PROJECT="${BASH_REMATCH[2]}"
                    ADO_REPO="${BASH_REMATCH[3]}"
                    INFO+=("Organization: $ADO_ORG, Project: $ADO_PROJECT, Repository: $ADO_REPO")
                # Parse: git@ssh.dev.azure.com:v3/{organization}/{project}/{repository}
                elif [[ "$GIT_REMOTE" =~ ssh\.dev\.azure\.com:v3/([^/]+)/([^/]+)/([^/]+) ]]; then
                    ADO_ORG="${BASH_REMATCH[1]}"
                    ADO_PROJECT="${BASH_REMATCH[2]}"
                    ADO_REPO="${BASH_REMATCH[3]}"
                    INFO+=("Organization: $ADO_ORG, Project: $ADO_PROJECT, Repository: $ADO_REPO")
                else
                    WARNINGS+=("Could not parse organization/project from Azure DevOps remote URL")
                fi
            elif [[ "$GIT_REMOTE" =~ visualstudio\.com ]]; then
                IS_AZURE_DEVOPS=true
                INFO+=("Remote is an Azure DevOps repository (legacy URL)")
                
                # Parse: https://{organization}.visualstudio.com/{project}/_git/{repository}
                if [[ "$GIT_REMOTE" =~ ([^/]+)\.visualstudio\.com/([^/]+)/_git/([^/]+) ]]; then
                    ADO_ORG="${BASH_REMATCH[1]}"
                    ADO_PROJECT="${BASH_REMATCH[2]}"
                    ADO_REPO="${BASH_REMATCH[3]}"
                    INFO+=("Organization: $ADO_ORG, Project: $ADO_PROJECT, Repository: $ADO_REPO")
                # Parse: https://{organization}.visualstudio.com/DefaultCollection/{project}/_git/{repository}
                elif [[ "$GIT_REMOTE" =~ ([^/]+)\.visualstudio\.com/DefaultCollection/([^/]+)/_git/([^/]+) ]]; then
                    ADO_ORG="${BASH_REMATCH[1]}"
                    ADO_PROJECT="${BASH_REMATCH[2]}"
                    ADO_REPO="${BASH_REMATCH[3]}"
                    INFO+=("Organization: $ADO_ORG, Project: $ADO_PROJECT, Repository: $ADO_REPO")
                else
                    WARNINGS+=("Could not parse organization/project from Azure DevOps remote URL")
                fi
            else
                ALL_REQUIRED_PRESENT=false
                ERRORS+=("Remote is not an Azure DevOps repository (this skill only works with Azure DevOps)")
            fi
        fi
    else
        ALL_REQUIRED_PRESENT=false
        ERRORS+=("Failed to get Git remote configuration")
    fi
fi

# Search for tasks.md files
TASKS_FILES=()
while IFS= read -r -d '' file; do
    TASKS_FILES+=("$file")
done < <(find "$WORKSPACE_ROOT" -type f -name "tasks.md" ! -path "*/node_modules/*" ! -path "*/.git/*" -print0 2>/dev/null)

if [ ${#TASKS_FILES[@]} -eq 0 ]; then
    ALL_REQUIRED_PRESENT=false
    ERRORS+=("No tasks.md file found in repository")
elif [ ${#TASKS_FILES[@]} -eq 1 ]; then
    TASKS_FILE="${TASKS_FILES[0]}"
    INFO+=("Found tasks.md at: $TASKS_FILE")
else
    TASKS_FILE="${TASKS_FILES[0]}"
    WARNINGS+=("Multiple tasks.md files found (${#TASKS_FILES[@]}), using first: $TASKS_FILE")
fi

# Check for Azure DevOps MCP server availability (informational)
if [ "$IS_AZURE_DEVOPS" = true ]; then
    INFO+=("Azure DevOps MCP server is required for work item creation")
fi

# Output results
if [ "$JSON_OUTPUT" = true ]; then
    # JSON output for programmatic parsing
    cat << EOF
{
  "success": $ALL_REQUIRED_PRESENT,
  "workspace_root": "$WORKSPACE_ROOT",
  "git": {
    "available": $GIT_AVAILABLE,
    "is_repository": $IS_GIT_REPO,
    "remote": "$GIT_REMOTE",
    "is_azure_devops": $IS_AZURE_DEVOPS
  },
  "ado": {
    "organization": "$ADO_ORG",
    "project": "$ADO_PROJECT",
    "repository": "$ADO_REPO"
  },
  "tasks_file": "$TASKS_FILE",
  "errors": [$(printf '"%s",' "${ERRORS[@]}" | sed 's/,$//') ],
  "warnings": [$(printf '"%s",' "${WARNINGS[@]}" | sed 's/,$//') ],
  "info": [$(printf '"%s",' "${INFO[@]}" | sed 's/,$//') ]
}
EOF
else
    # Human-readable output
    echo ""
    echo -e "${BLUE}Tasks to Azure DevOps - Prerequisites Check${NC}"
    echo "================================================"
    echo ""
    
    # Workspace info
    echo -n "Workspace: "
    echo -e "${BLUE}$WORKSPACE_ROOT${NC}"
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
        echo "    Remote: $GIT_REMOTE"
    else
        echo -e "  ${RED}✗${NC} No Git remote configured (REQUIRED)"
    fi
    
    if [ "$IS_AZURE_DEVOPS" = true ]; then
        echo -e "  ${GREEN}✓${NC} Remote is Azure DevOps"
        if [ -n "$ADO_ORG" ] && [ -n "$ADO_PROJECT" ]; then
            echo "    Organization: $ADO_ORG"
            echo "    Project: $ADO_PROJECT"
            echo "    Repository: $ADO_REPO"
        fi
    else
        if [ -n "$GIT_REMOTE" ]; then
            echo -e "  ${RED}✗${NC} Remote is not Azure DevOps (REQUIRED - this skill only works with Azure DevOps)"
        fi
    fi
    echo ""
    
    # Tasks file section
    echo -e "${BLUE}Task File:${NC}"
    if [ -n "$TASKS_FILE" ]; then
        echo -e "  ${GREEN}✓${NC} tasks.md found"
        echo "    Path: $TASKS_FILE"
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
        echo -e "${GREEN}✓ All prerequisites met. Ready to sync tasks to Azure DevOps work items.${NC}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Ensure Azure DevOps MCP server is configured with authentication"
        echo "  2. Run tasks-to-azure-devops skill to create work items"
        echo "  3. Review created work items in project: https://dev.azure.com/$ADO_ORG/$ADO_PROJECT/_workitems"
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
            echo "  - Add Azure DevOps remote: git remote add origin https://dev.azure.com/org/project/_git/repo"
        fi
        if [ "$IS_AZURE_DEVOPS" = false ] && [ -n "$GIT_REMOTE" ]; then
            echo "  - This skill only works with Azure DevOps repositories"
            echo "  - Change remote to Azure DevOps or use manual work item creation"
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
