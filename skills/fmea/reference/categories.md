# FMEA Categories

## Default Categories (override in profile.yaml)

```yaml
failures:
  categories: [Build, Logic, Integration, UX, Performance, Tooling]
```

## Category Semantics

| Category | Scope |
|----------|-------|
| Build | Compilation, bundling, CI failures |
| Logic | Incorrect behavior, wrong output |
| Integration | API mismatch, dependency conflicts |
| UX | Visual bugs, accessibility issues |
| Performance | Slow builds, large bundles, memory leaks |
| Tooling | Package manager, editor, dev server issues |
| Security | Vulnerability, secret exposure |
