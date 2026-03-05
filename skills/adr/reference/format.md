# ADR Format

## Entry Format

```
- **decision-name** [tag1, tag2]: Decision description with rationale
```

## Categorization

Group decisions under `## Category` headers. Categories emerge from project domain.

Example categories:
- Architecture, Build, Testing, DX, Security, API, Data, Infra

## Archival

When a decision is superseded:
1. Remove from `active.md`
2. Add to `archived.md` with `(superseded by: new-decision-name)` suffix
3. Add the new decision to `active.md`

## Counting

When updating self-model heritage counts:
- Count via grep: `grep -c '^\- \*\*' .anvil/decisions/active.md`
- Do not manually track counts — always derive from source
