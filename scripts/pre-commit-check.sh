#!/bin/bash

# Pre-commit hook that ensures configuration files are valid
# This script runs before every commit and will fail if checks don't pass
#
# The hook automatically runs:
# 1. YAML syntax validation
# 2. Shell script syntax checking
# 3. Systemd service file validation (if systemd-analyze is available)

set -e  # Exit on any error

echo "?? Running pre-commit checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if any checks failed
FAILED=false

# Step 1: Check YAML syntax
echo -e "${YELLOW}?? Step 1/3: Validating YAML syntax...${NC}"
if command -v yamllint &> /dev/null; then
    if yamllint config.yaml 2>&1; then
        echo -e "${GREEN}? YAML syntax valid${NC}"
    else
        echo -e "${RED}? YAML syntax errors found${NC}"
        FAILED=true
    fi
elif command -v python3 &> /dev/null; then
    # Fallback: Use Python's yaml module
    if python3 -c "import yaml; yaml.safe_load(open('config.yaml'))" 2>/dev/null; then
        echo -e "${GREEN}? YAML syntax valid${NC}"
    else
        echo -e "${RED}? YAML syntax errors found${NC}"
        echo -e "${YELLOW}?? Tip: Install yamllint for better validation: pip install yamllint${NC}"
        FAILED=true
    fi
else
    echo -e "${YELLOW}? No YAML validator found, skipping YAML check${NC}"
fi

# Step 2: Check shell script syntax
echo -e "${YELLOW}?? Step 2/3: Checking shell script syntax...${NC}"
SH_SCRIPTS=$(find scripts -name "*.sh" 2>/dev/null || true)
if [ -n "$SH_SCRIPTS" ]; then
    for script in $SH_SCRIPTS; do
        if bash -n "$script" 2>&1; then
            echo -e "${GREEN}? $script syntax valid${NC}"
        else
            echo -e "${RED}? $script has syntax errors${NC}"
            FAILED=true
        fi
    done
else
    echo -e "${GREEN}? No shell scripts to check${NC}"
fi

# Step 3: Validate systemd service files
echo -e "${YELLOW}?? Step 3/3: Validating systemd service files...${NC}"
if command -v systemd-analyze &> /dev/null; then
    SERVICE_FILES=$(find servicefiles -name "*.service" 2>/dev/null || true)
    if [ -n "$SERVICE_FILES" ]; then
        for service in $SERVICE_FILES; do
            if systemd-analyze verify "$service" 2>&1; then
                echo -e "${GREEN}? $service is valid${NC}"
            else
                echo -e "${RED}? $service has errors${NC}"
                FAILED=true
            fi
        done
    else
        echo -e "${GREEN}? No service files to check${NC}"
    fi
else
    echo -e "${YELLOW}? systemd-analyze not available, skipping service file validation${NC}"
    echo -e "${YELLOW}?? Tip: Service files will be validated on the target system${NC}"
fi

# Final check
if [ "$FAILED" = true ]; then
    echo ""
    echo -e "${RED}? Pre-commit checks failed. Please fix the errors above.${NC}"
    echo -e "${YELLOW}?? Tip: Run './scripts/pre-commit-check.sh' to see detailed errors${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}? All pre-commit checks passed!${NC}"
exit 0
