---
name: insight
trigger: insight|explain|why
description: Failure analysis — explain why things broke and how to prevent recurrence
---

# Insight

Analyze gate failures and unexpected behaviors using trace data.

$ARGUMENTS

## Argument Parsing

- (no args) -> Analyze the most recent gate failure from active trace
- `<gate_name>` -> Analyze a specific gate's failure
- `<run_id>` -> Analyze failures from a specific trace

## Flow

1. **Gather evidence**
   - Read active trace (`.anvil/traces/.active`) or specified trace
   - Collect: git diff, error output, gate exit codes
   - If no trace data available, ask user to describe the failure

2. **Classify failure**
   - Match against categories in `reference/categories.md`
   - Identify root cause vs. symptoms

3. **Analyze**
   - What changed? (diff analysis)
   - What broke? (error output parsing)
   - Why did it break? (root cause)
   - Has this happened before? (check `.anvil/failures/active.md`)

4. **Recommend**
   - Provide specific fix instructions
   - If pattern is recurring, suggest FMEA entry
   - If architectural, suggest ADR entry

5. **Auto-record**
   - Write insight to trace activity log
   - **Auto-FMEA:** If failure matches a category, automatically add to `.anvil/failures/active.md` with category tag. Ask user for confirmation only if uncertain.
   - **Auto-ADR:** If the fix involves an architectural change (new package, pattern change, API redesign), automatically record in `.anvil/decisions/active.md`.
   - Update heritage counts via `self-model auto-update`

## Output Format

```
## Insight: <short title>

**Category:** <category from reference/categories.md>
**Gate:** <which gate failed>
**Root Cause:** <one-sentence explanation>

### Evidence
<relevant diff/error snippets>

### Fix
<specific steps to resolve>

### Prevention
<how to prevent recurrence — FMEA candidate?>
```
