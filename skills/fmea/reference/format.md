# FMEA Format

## Entry Format

```
- **pattern-name** [category]: Description of failure mode. Fix: specific remedy.
```

## Categorization

Group under `## Category` headers.

Example categories:
- Build, Logic, Integration, UX, Performance, Tooling, Security

## Merged Patterns

When multiple related patterns share root cause:
```
- **merged-name**: Combined description. (Merged: original-a + original-b)
```

## Counting

Derive from source: `grep -c '^\- \*\*' .anvil/failures/active.md`
