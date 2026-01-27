#!/usr/bin/env bash
# check-nuxt-prerequisites.sh
# Checks for required tools and configuration before running nuxtjs-mockup skill
# Usage: ./check-nuxt-prerequisites.sh [--json]

set -euo pipefail

# Get workspace root (assuming script is in skills/nuxtjs-mockup/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize variables
NODE_VERSION=""
NODE_AVAILABLE=false
PACKAGE_MANAGER=""
PACKAGE_MANAGER_VERSION=""
NPM_VERSION=""
PNPM_VERSION=""
YARN_VERSION=""

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

# Check if Node.js is available
if command -v node &> /dev/null; then
    NODE_AVAILABLE=true
    NODE_VERSION=$(node --version | sed 's/v//')
    INFO+=("Node.js is available: v$NODE_VERSION")
    
    # Parse major version
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
    
    # Check if version meets minimum requirement (18+)
    if [ "$NODE_MAJOR" -lt 18 ]; then
        ALL_REQUIRED_PRESENT=false
        ERRORS+=("Node.js version $NODE_VERSION is too old. Nuxt 4 requires Node.js 18.0.0 or higher")
    else
        INFO+=("Node.js version meets requirements (18+)")
    fi
else
    ALL_REQUIRED_PRESENT=false
    NODE_AVAILABLE=false
    ERRORS+=("Node.js not found. Install from https://nodejs.org/ (v20+ recommended)")
fi

# Check for package managers
if [ "$NODE_AVAILABLE" = true ]; then
    # Check for pnpm (preferred)
    if command -v pnpm &> /dev/null; then
        PNPM_VERSION=$(pnpm --version)
        PACKAGE_MANAGER="pnpm"
        PACKAGE_MANAGER_VERSION="$PNPM_VERSION"
        INFO+=("pnpm is available: v$PNPM_VERSION (recommended)")
    fi
    
    # Check for yarn
    if command -v yarn &> /dev/null; then
        YARN_VERSION=$(yarn --version)
        if [ -z "$PACKAGE_MANAGER" ]; then
            PACKAGE_MANAGER="yarn"
            PACKAGE_MANAGER_VERSION="$YARN_VERSION"
            INFO+=("yarn is available: v$YARN_VERSION")
        else
            INFO+=("yarn is also available: v$YARN_VERSION")
        fi
    fi
    
    # Check for npm (fallback)
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        if [ -z "$PACKAGE_MANAGER" ]; then
            PACKAGE_MANAGER="npm"
            PACKAGE_MANAGER_VERSION="$NPM_VERSION"
            INFO+=("npm is available: v$NPM_VERSION")
        else
            INFO+=("npm is also available: v$NPM_VERSION")
        fi
    fi
    
    # If no package manager found
    if [ -z "$PACKAGE_MANAGER" ]; then
        ALL_REQUIRED_PRESENT=false
        ERRORS+=("No package manager found. npm should be bundled with Node.js")
    else
        INFO+=("Using package manager: $PACKAGE_MANAGER v$PACKAGE_MANAGER_VERSION")
    fi
fi

# Check if in a Nuxt project (optional check)
NUXT_PROJECT=false
if [ -f "$WORKSPACE_ROOT/package.json" ]; then
    if grep -q '"nuxt"' "$WORKSPACE_ROOT/package.json" 2>/dev/null; then
        NUXT_PROJECT=true
        INFO+=("Detected existing Nuxt project in workspace")
    fi
fi

# Check for common project files
if [ -f "$WORKSPACE_ROOT/nuxt.config.ts" ] || [ -f "$WORKSPACE_ROOT/nuxt.config.js" ]; then
    INFO+=("Found Nuxt configuration file")
fi

if [ -f "$WORKSPACE_ROOT/tailwind.config.js" ] || [ -f "$WORKSPACE_ROOT/tailwind.config.ts" ]; then
    INFO+=("Found Tailwind CSS configuration")
fi

# Output results
if [ "$JSON_OUTPUT" = true ]; then
    # JSON output for programmatic parsing
    cat << EOF
{
  "success": $ALL_REQUIRED_PRESENT,
  "workspace_root": "$WORKSPACE_ROOT",
  "node": {
    "available": $NODE_AVAILABLE,
    "version": "$NODE_VERSION",
    "major_version": ${NODE_MAJOR:-0}
  },
  "package_manager": {
    "name": "$PACKAGE_MANAGER",
    "version": "$PACKAGE_MANAGER_VERSION",
    "npm_version": "$NPM_VERSION",
    "pnpm_version": "$PNPM_VERSION",
    "yarn_version": "$YARN_VERSION"
  },
  "project": {
    "is_nuxt": $NUXT_PROJECT
  },
  "errors": [$(printf '"%s",' "${ERRORS[@]}" | sed 's/,$//') ],
  "warnings": [$(printf '"%s",' "${WARNINGS[@]}" | sed 's/,$//') ],
  "info": [$(printf '"%s",' "${INFO[@]}" | sed 's/,$//') ]
}
EOF
else
    # Human-readable output
    echo ""
    echo -e "${BLUE}Nuxt.js Mockup - Prerequisites Check${NC}"
    echo "================================================"
    echo ""
    
    # Workspace info
    echo -n "Workspace: "
    echo -e "${BLUE}$WORKSPACE_ROOT${NC}"
    echo ""
    
    # Node.js section
    echo -e "${BLUE}Node.js:${NC}"
    if [ "$NODE_AVAILABLE" = true ]; then
        echo -e "  ${GREEN}✓${NC} Node.js installed"
        echo "    Version: v$NODE_VERSION"
        
        if [ "$NODE_MAJOR" -ge 18 ]; then
            echo -e "  ${GREEN}✓${NC} Version meets requirements (18+)"
        else
            echo -e "  ${RED}✗${NC} Version too old (need 18+, have $NODE_MAJOR)"
        fi
    else
        echo -e "  ${RED}✗${NC} Node.js not found (REQUIRED)"
    fi
    echo ""
    
    # Package Manager section
    echo -e "${BLUE}Package Manager:${NC}"
    if [ -n "$PACKAGE_MANAGER" ]; then
        echo -e "  ${GREEN}✓${NC} $PACKAGE_MANAGER v$PACKAGE_MANAGER_VERSION detected"
        
        if [ -n "$PNPM_VERSION" ]; then
            echo -e "  ${GREEN}✓${NC} pnpm available (recommended)"
        fi
        
        if [ -n "$YARN_VERSION" ]; then
            echo "    yarn v$YARN_VERSION also available"
        fi
        
        if [ -n "$NPM_VERSION" ]; then
            echo "    npm v$NPM_VERSION also available"
        fi
    else
        echo -e "  ${RED}✗${NC} No package manager found (REQUIRED)"
    fi
    echo ""
    
    # Project status
    echo -e "${BLUE}Project Status:${NC}"
    if [ "$NUXT_PROJECT" = true ]; then
        echo -e "  ${GREEN}✓${NC} Existing Nuxt project detected"
    else
        echo "    No Nuxt project detected (will initialize new project)"
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
        echo -e "${GREEN}✓ All prerequisites met. Ready to create Nuxt mockups!${NC}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Run skill to create mockup project"
        echo "  2. Or manually initialize: ${PACKAGE_MANAGER} create nuxt@latest mockup"
        echo "  3. Install dependencies: cd mockup && $PACKAGE_MANAGER install"
        echo "  4. Start dev server: $PACKAGE_MANAGER dev"
        echo ""
        echo -e "${BLUE}Latest versions:${NC}"
        echo "  - Nuxt: 4.3.x"
        echo "  - Vue: 3.5.x"
        echo "  - Tailwind CSS: 4.x"
        echo "  - Vite: 5.x (built into Nuxt)"
    else
        echo -e "${RED}✗ Missing required prerequisites. Please resolve the following:${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "  ${RED}-${NC} $error"
        done
        echo ""
        echo -e "${YELLOW}Installation Tips:${NC}"
        if [ "$NODE_AVAILABLE" = false ]; then
            echo "  - Install Node.js v20 LTS: https://nodejs.org/"
            echo "  - Or use version manager: nvm install 20"
        fi
        if [ "$NODE_AVAILABLE" = true ] && [ "$NODE_MAJOR" -lt 18 ]; then
            echo "  - Upgrade Node.js: nvm install 20 && nvm use 20"
            echo "  - Or download from: https://nodejs.org/"
        fi
        if [ -z "$PNPM_VERSION" ]; then
            echo "  - Install pnpm (recommended): npm install -g pnpm"
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
