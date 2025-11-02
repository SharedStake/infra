#!/bin/bash

# Auto-fix script for pre-commit issues
# This script attempts to automatically fix common issues that cause pre-commit failures
# The agent should run this when pre-commit checks fail
# This script will show all errors clearly so the agent can fix them

set +e  # Don't exit on error - we want to see all errors

echo "?? Attempting to fix pre-commit issues..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track which checks are failing
YAML_FAILED=false
SHELL_FAILED=false
SERVICE_FAILED=false

# Step 1: Check YAML syntax
echo ""
echo -e "${YELLOW}?? Step 1: Checking YAML syntax...${NC}"
if command -v yamllint &> /dev/null; then
    if yamllint config.yaml 2>&1; then
        echo -e "${GREEN}? YAML syntax valid${NC}"
        YAML_FAILED=false
    else
        echo -e "${RED}? YAML syntax errors found${NC}"
        YAML_FAILED=true
    fi
elif command -v python3 &> /dev/null; then
    if python3 -c "import yaml; yaml.safe_load(open('config.yaml'))" 2>/dev/null; then
        echo -e "${GREEN}? YAML syntax valid${NC}"
        YAML_FAILED=false
    else
        echo -e "${RED}? YAML syntax errors found${NC}"
        YAML_FAILED=true
    fi
else
    echo -e "${YELLOW}? No YAML validator found${NC}"
fi

# Step 2: Check shell script syntax
echo ""
echo -e "${YELLOW}?? Step 2: Checking shell script syntax...${NC}"
SH_SCRIPTS=$(find scripts -name "*.sh" 2>/dev/null || true)
if [ -n "$SH_SCRIPTS" ]; then
    for script in $SH_SCRIPTS; do
        if bash -n "$script" 2>&1; then
            echo -e "${GREEN}? $script syntax valid${NC}"
        else
            echo -e "${RED}? $script has syntax errors${NC}"
            SHELL_FAILED=true
        fi
    done
else
    echo -e "${GREEN}? No shell scripts to check${NC}"
fi

# Step 3: Validate systemd service files
echo ""
echo -e "${YELLOW}?? Step 3: Validating systemd service files...${NC}"
if command -v systemd-analyze &> /dev/null; then
    SERVICE_FILES=$(find servicefiles -name "*.service" 2>/dev/null || true)
    if [ -n "$SERVICE_FILES" ]; then
        for service in $SERVICE_FILES; do
            if systemd-analyze verify "$service" 2>&1; then
                echo -e "${GREEN}? $service is valid${NC}"
            else
                echo -e "${RED}? $service has errors${NC}"
                SERVICE_FAILED=true
            fi
        done
    else
        echo -e "${GREEN}? No service files to check${NC}"
    fi
else
    echo -e "${YELLOW}? systemd-analyze not available${NC}"
fi

# Show summary
echo ""
echo -e "${BLUE}????????????????????????????????????????${NC}"
echo -e "${BLUE}Summary of failures:${NC}"
[ "$YAML_FAILED" = true ] && echo -e "${RED}  ? YAML validation${NC}" || echo -e "${GREEN}  ? YAML validation${NC}"
[ "$SHELL_FAILED" = true ] && echo -e "${RED}  ? Shell script syntax${NC}" || echo -e "${GREEN}  ? Shell script syntax${NC}"
[ "$SERVICE_FAILED" = true ] && echo -e "${RED}  ? Service file validation${NC}" || echo -e "${GREEN}  ? Service file validation${NC}"
echo -e "${BLUE}????????????????????????????????????????${NC}"

# Check if all checks passed
if [ "$YAML_FAILED" = false ] && [ "$SHELL_FAILED" = false ] && [ "$SERVICE_FAILED" = false ]; then
    echo ""
    echo -e "${GREEN}??? All checks passed! ???${NC}"
    exit 0
fi

# If we get here, there are still issues
echo ""
echo -e "${YELLOW}?? Please review the errors above and fix them.${NC}"
echo -e "${YELLOW}   After fixing, run './scripts/pre-commit-check.sh' to verify.${NC}"
exit 1
