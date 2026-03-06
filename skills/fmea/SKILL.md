---
name: fmea
description: Failure Mode and Effects Analysis. Catalog failure patterns to prevent recurrence. Referenced by sprint scope (G0).
---

# FMEA

$ARGUMENTS

## Argument Parsing

- `show` -> Read `.anvil/failures/active.md`
- `add <name> [category]: <description>. Fix: <remedy>` -> Append to active.md
- `search <keyword>` -> Grep `.anvil/failures/active.md`
- `harden <name>` -> Move to archived.md (pattern defended)
- `init` -> Read templates -> Write to `.anvil/failures/`

## Format

`- **pattern-name** [category]: Description. Fix: remedy.`

Categories are project-defined in `.anvil/profile.yaml`.
Format details -> Read `reference/format.md`
Hardening conditions -> Read `reference/hardening.md`

## When to Use

- `/sprint` G0 scope — grep quest keywords against active.md, apply matching fixes preemptively
- `/sprint` retro (G4) — register new failure patterns
- Pattern repeated 3+ times -> harden (add CI/lint defense, then archive)

## Rules

1. Every failure MUST include a Fix
2. Hardening means "defense is installed" (CI gate, lint rule, etc.)
3. Hardened patterns move to archived.md, removed from active.md
4. After `add` or `harden`, run `self-model auto-update` to sync heritage counts
