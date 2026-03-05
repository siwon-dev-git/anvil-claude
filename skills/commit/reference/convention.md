# Commit Convention

## Format

```text
type(scope): subject

body (optional)

Co-Authored-By: ...
```

## Types

| Type | When |
| ---- | ---- |
| feat | New feature |
| fix | Bug fix |
| refactor | Code restructure, no behavior change |
| test | Test additions/changes |
| docs | Documentation only |
| chore | Tooling, deps, config |
| perf | Performance improvement |
| style | Formatting, whitespace |
| ci | CI/CD changes |

## Rules

- Subject: imperative mood, lowercase, no period, < 72 chars
- Scope: affected module/component name
- Body: explain "why", not "what"
- Breaking changes: add `!` after type — `feat!: remove legacy API`
