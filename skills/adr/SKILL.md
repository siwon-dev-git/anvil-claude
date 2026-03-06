---
name: adr
description: Architecture Decision Records. Track design decisions with rationale. Referenced by sprint retro.
---

# ADR

$ARGUMENTS

## Argument Parsing

- `show` -> Read `.anvil/decisions/active.md`
- `add <name> [tags] -> <decision>` -> Append to `.anvil/decisions/active.md`
- `search <keyword>` -> Grep `.anvil/decisions/active.md`
- `archive <name>` -> Move entry from active.md to archived.md
- `init` -> Read `templates/decisions.md` -> Write to `.anvil/decisions/`

## Format

One-line: `- **name** [tag1, tag2]: Decision description`

Tags are project-defined in `.anvil/profile.yaml` under `decisions.tags`.
Format details -> Read `reference/format.md`
Tag conventions -> Read `reference/tags.md`

## When to Add

- `/sprint` retro phase (G4) — automatic
- Architecture decision made
- Existing decision overturned (archive old, add new)

## Rules

1. Every decision MUST include rationale
2. Duplicate name -> archive existing -> add new
3. Use only tags defined in project profile
4. After `add` or `archive`, run `self-model auto-update` to sync heritage counts
