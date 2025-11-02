# Pre-commit Hook Setup

This project uses a git pre-commit hook to ensure code quality before commits. The hook **automatically runs** validation checks before allowing a commit to proceed.

## How Git Hooks Work

Git hooks are executable scripts in `.git/hooks/` that run automatically at specific git events. The `pre-commit` hook runs **automatically** every time you run `git commit` - there's no way to miss it (unless you use `--no-verify`).

**This is a standard git feature**: When you have an executable file at `.git/hooks/pre-commit`, git will run it automatically before every commit.

## What Happens When You Commit

When you try to commit code with `git commit`, the pre-commit hook **automatically** runs:

1. **YAML Syntax Validation** - Checks that `config.yaml` is valid YAML
2. **Shell Script Syntax Check** - Validates all shell scripts in `scripts/` directory
3. **Systemd Service File Validation** - Validates service files in `servicefiles/` directory (if systemd-analyze is available)

If any of these checks fail, the commit will be blocked until the issues are fixed.

## Scripts Available

- `./scripts/pre-commit-check.sh` - Manually run the pre-commit checks
- `./scripts/fix-pre-commit-issues.sh` - Show all errors clearly for fixing
- `./scripts/install-pre-commit-hook.sh` - Install/reinstall the git hook

## For LLM Agents

**IMPORTANT**: The pre-commit hook runs **automatically** on every `git commit`. You cannot forget about it - git will run it automatically.

**When committing code:**
1. Run `git commit` as normal
2. Git **automatically** runs `.git/hooks/pre-commit` before the commit
3. Hook runs validation checks
4. If all pass, commit proceeds
5. If any fail, commit is **blocked** and you see error messages

**When pre-commit hook fails:**

1. The hook outputs clear error messages showing what failed (you'll see this automatically)
2. Run `./scripts/fix-pre-commit-issues.sh` to see all errors clearly in one place
3. Fix the issues in the code using your editing tools
4. Run `./scripts/pre-commit-check.sh` manually to verify fixes before committing again
5. Once all checks pass, run `git commit` again (hook runs automatically and should pass)

**Remember**: You don't need to manually run the hook - it runs automatically. But you can test it with `./scripts/pre-commit-check.sh` before committing.

## Common Issues and Fixes

### YAML Syntax Errors
- Check indentation (use 2 spaces, not tabs)
- Ensure all strings are properly quoted if they contain special characters
- Verify all keys are properly formatted
- Use `yamllint` or Python's `yaml` module to validate

### Shell Script Syntax Errors
- Check for missing shebang (`#!/bin/bash`)
- Verify all quotes are properly closed
- Check for proper variable syntax
- Use `bash -n script.sh` to validate syntax

### Service File Errors
- Ensure proper systemd unit file format
- Check that all required sections ([Unit], [Service], [Install]) are present
- Verify ExecStart paths are correct
- Use `systemd-analyze verify servicefile.service` to validate

## Disabling the Hook (Not Recommended)

If you absolutely need to bypass the hook (e.g., for emergency hotfixes):

```bash
git commit --no-verify -m "your message"
```

**Warning**: Only use `--no-verify` when absolutely necessary. It bypasses all quality checks and can lead to broken configurations.

## Manual Installation

If you need to manually install or reinstall the hook:

```bash
./scripts/install-pre-commit-hook.sh
```

Or if you have a package.json with a postinstall script, it will run automatically.
