---
name: guard
trigger: guard|enforce|protect
description: Adaptive runtime guardrails — learned rules applied to future execution
---

# Guard

Apply learned rules from pattern detection to prevent recurring failures.

$ARGUMENTS

## Argument Parsing

- `list` -> Show all active guard rules
- `add <type> <description>` -> Add a new guard rule
- `remove <guard_id>` -> Remove a guard rule
- `check` -> Run all guard checks against current state
- `report` -> Show guard hit statistics

## Guard Types

See `reference/guard-types.md` for full descriptions.

| Type | Trigger | Action |
|------|---------|--------|
| `complexity` | File added/modified | Check structure tier classification |
| `dependency` | package.json/go.mod changed | Verify security, license, size |
| `convention` | Any code change | Check against ADR decisions |
| `regression` | Any code change | Check against FMEA patterns |
| `validation` | Guard/check code modified | Warn if validation logic removed |
| `api` | Public interface changed | Require backward compatibility check |

## Flow

### `guard check`

Pre-execution verification. Run before or during sprint execution.

1. Load guard rules from `.anvil/checks/guards.md`
2. Load current diff: `git diff --cached` or `git diff HEAD`
3. For each guard rule:
   - Run `scripts/pre-check.sh` with rule type and diff
   - Collect results: `pass` | `warn` | `block`
4. Report results
5. If any `block` results → halt and explain why

### `guard add <type> <description>`

1. Validate type against known guard types
2. Generate guard ID: `G-<type>-<NNN>`
3. Append to `.anvil/checks/guards.md` using `templates/guard-rule.md`
4. Report: "Guard added: <guard_id>"

### `guard report`

1. Read `.anvil/checks/guard-hits.log`
2. Summarize: total checks, passes, warnings, blocks
3. Show top triggered guards
4. Identify guards that never trigger (candidates for removal)

## Integration

- **Sprint:** Guard check runs automatically at G0 Scope and G4 Review
- **Pattern:** When a pattern is promoted, guard rule is auto-created
- **Hooks:** `scripts/pre-check.sh` can be added as a PreToolUse hook

## Guard Rules File

Stored in `.anvil/checks/guards.md`:

```markdown
# Guard Rules

## G-regression-001
- **Type:** regression
- **Pattern:** P01 (validation-removal)
- **Check:** Warn if guard/validation code is deleted
- **Action:** warn
- **Created:** 2026-03-06
- **Hits:** 0
```
