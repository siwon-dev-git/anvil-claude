---
name: pattern
trigger: pattern|learn|cluster
description: Detect recurring failure patterns and compress them into rules
---

# Pattern

Detect recurring failure patterns from FMEA entries and trace data, compress them into actionable rules.

$ARGUMENTS

## Argument Parsing

- `scan` -> Scan FMEA entries for recurring patterns
- `suggest` -> Generate rule suggestions from detected patterns
- `promote <pattern_id>` -> Promote a pattern to a guard rule
- `show` -> Display all detected patterns and their status

## Flow

### `pattern scan`

1. Read `.anvil/failures/active.md` — extract all FMEA entries
2. Read recent traces from `.anvil/traces/` (last 10)
3. Run `scripts/match-patterns.sh` to find category clusters
4. Group failures by category tag (from `reference/compression.md`)
5. For each group with 3+ entries → flag as **candidate pattern**
6. Report: pattern ID, category, occurrence count, affected files

### `pattern suggest`

1. Run `pattern scan` if not already done
2. For each candidate pattern:
   - Analyze the common structure across failures
   - Generate a rule description (what to check, when to trigger)
   - Classify rule type: `lint` | `gate` | `convention` | `guard`
   - Estimate confidence: `high` (5+ occurrences) | `medium` (3-4) | `low` (2)
3. Output suggestions using `templates/pattern-entry.md` format
4. Ask user which patterns to promote

### `pattern promote <pattern_id>`

1. Read the pattern entry
2. Based on rule type:
   - `lint` → suggest ESLint/Ruff rule or custom lint script
   - `gate` → create gate script in `.anvil/checks/`
   - `convention` → add to `.anvil/constitution.md` (with user confirmation)
   - `guard` → create guard rule via `/anvil-claude:guard`
3. Move FMEA entries from `active.md` to `archived.md` (pattern is now defended)
4. Update heritage counts

## Pattern Compression Pipeline

See `reference/compression.md` for the 3-step approach:
1. Rule-based (hardcoded common patterns)
2. LLM-based (AI analysis + tagging)
3. AST-diff-based (structural analysis — future)

## Threshold

- **2 occurrences** → noted, no action
- **3 occurrences** → candidate pattern, suggest rule
- **5+ occurrences** → strong pattern, recommend immediate promotion
