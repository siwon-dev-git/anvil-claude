---
name: self-model
description: Project self-awareness. Mutable identity reflecting current capabilities, state, and evolution stage.
---

# Self-Model

$ARGUMENTS

## Argument Parsing

- `show` -> Read `.anvil/self-model.md` and display
- `update` -> Analyze current project state -> Edit `.anvil/self-model.md`
- `init` -> Read `templates/self-model.md.tpl` -> Write to `.anvil/self-model.md`

## When to Update

- `/sprint` retro phase (G4) — automatic
- Major milestone achieved
- Self-sufficiency stage transition

## What It Tracks

- Self-sufficiency stage: A(dependent) -> B(assisted) -> C(balanced) -> D(growing)
- Heritage counts: ADR N + FMEA N
- Experience base: key project metrics
- Evolution mechanism: current quality loop description
- Known paradoxes: active trade-offs

Maturation model -> Read `reference/maturation.md`
Trade-offs -> Read `reference/paradoxes.md`
