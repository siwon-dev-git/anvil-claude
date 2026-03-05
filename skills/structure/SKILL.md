---
name: structure
trigger: structure|tier|classify|audit
description: Code structure classification and audit (Tier 0-3)
---

# Structure

Classify and audit code complexity using a 4-tier system.

## Commands

- `/structure` — show current tier rules from `.anvil/structure/tiers.md`
- `/structure audit` — run `scripts/audit.sh` to scan and classify project files
- `/structure init` — create `.anvil/structure/tiers.md` from template

## Tiers

| Tier | Complexity | Example |
|------|-----------|---------|
| 0 | Leaf | Pure utility, no dependencies |
| 1 | Composite | Combines Tier 0 units |
| 2 | Connected | Has side effects, external I/O |
| 3 | Orchestrator | Coordinates Tier 0-2 units |

## Reference

- `reference/tiers.md` — detailed tier definitions and rules
