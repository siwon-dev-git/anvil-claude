# Structure Tiers

<!-- Project-specific tier classification rules -->

## Tier 0 — Leaf
- Pure utilities, constants, types
- No project imports, no side effects

## Tier 1 — Composite
- Combines Tier 0 units
- No side effects

## Tier 2 — Connected
- Has side effects (I/O, state, DOM)
- Imports Tier 0-1

## Tier 3 — Orchestrator
- Coordinates flow
- Entry points, handlers

## Custom Rules

<!-- Add project-specific rules below -->
