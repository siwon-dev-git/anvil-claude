---
name: commit
trigger: commit|push|pr
description: Commit convention enforcement and PR workflow
---

# Commit

Enforces commit convention and optional PR workflow.

## Commands

- `/commit` — stage, lint-check via `scripts/pre-flight.sh`, then commit
- `/commit pr` — commit + create PR

## Convention

Format: `type(scope): subject`

Types: feat, fix, refactor, test, docs, chore, perf, style, ci

## Flow

1. Run `scripts/pre-flight.sh` (lint + type check on staged files)
2. Generate commit message from diff
3. Commit (never `--no-verify`)
4. If `pr` flag: push + `gh pr create`

## Reference

- `reference/convention.md` — full commit message rules
