# Tier Definitions

## Tier 0 — Leaf
- No imports from project (only stdlib/external)
- Pure functions, constants, types
- Zero side effects

## Tier 1 — Composite
- Imports only Tier 0
- Combines utilities into higher abstractions
- Still no side effects

## Tier 2 — Connected
- Imports Tier 0-1
- Has side effects: network, filesystem, DOM, state
- Should be testable with mocks

## Tier 3 — Orchestrator
- Imports any tier
- Coordinates flow between units
- Entry points, route handlers, CLI commands

## Rules
- Lower tiers MUST NOT import higher tiers
- Each file belongs to exactly one tier
- Tier violations indicate architectural debt
