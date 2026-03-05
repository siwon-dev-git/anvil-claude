---
name: constitution
description: Project trust anchor. Immutable axioms and hard constraints. Only human owner may modify.
---

# Constitution

$ARGUMENTS

## Argument Parsing

- `show` -> Read `.anvil/constitution.md` and display
- `verify` -> Bash `scripts/guard.sh` (checksum verification)
- `init` -> Read `templates/constitution.md.tpl` -> Write to `.anvil/constitution.md`

## Rules

1. Agents NEVER modify this file without explicit user confirmation
2. `/sprint` retro checks constitution compliance
3. Constitution Hard Rules override all other rules

## Priority Chain

User direct instruction > Constitution Hard Rules > Constitution Soft Rules > Project conventions > Execution logic

Details -> Read `reference/priority-chain.md`
