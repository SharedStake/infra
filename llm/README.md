# SharedStake Infrastructure Documentation

This directory contains documentation for AI agents and developers working on the SharedStake infrastructure repository.

## ?? Table of Contents

- [Pre-Commit Hook System](./PRE_COMMIT_HOOK.md) - Information about the git pre-commit hook system

## ?? Pre-Commit Hook System

**CRITICAL FOR AGENTS**: This project has a git pre-commit hook that runs automatically on every `git commit`. The hook will:
1. Validate YAML syntax
2. Check shell script syntax
3. Validate systemd service files (if available)

**If any check fails, the commit is blocked.** When this happens:
- The hook outputs clear error messages
- Run `./scripts/fix-pre-commit-issues.sh` to see all errors
- Fix issues, then commit again (hook runs automatically)

**See [`llm/PRE_COMMIT_HOOK.md`](./PRE_COMMIT_HOOK.md) for complete documentation.**

The hook can be installed manually by running `./scripts/install-pre-commit-hook.sh`.

---

## ??? Project Overview

This repository contains infrastructure configuration for SharedStake Prysm validators:

- **Configuration**: `config.yaml` - Prysm validator configuration
- **Services**: `servicefiles/` - Systemd service definitions for beacon chain and validator
- **Documentation**: `README.md` - Setup and usage instructions

## ?? Key Files

- `config.yaml` - Main Prysm validator configuration
- `servicefiles/beacon.service` - Systemd service for beacon chain
- `servicefiles/validator.service` - Systemd service for validator
- `scripts/pre-commit-check.sh` - Pre-commit validation script
- `scripts/install-pre-commit-hook.sh` - Hook installation script
- `.cursorrules` - Cursor IDE rules for AI agents

## ?? Development Guidelines

See `.cursorrules` for detailed development guidelines and code review processes.
