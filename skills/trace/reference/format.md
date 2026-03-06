# Trace Record Format

Each trace is a markdown file in `.anvil/traces/` capturing what the agent did during a session.

## File Naming

`YYYY-MM-DD-HHMMSS.md` — timestamp of trace start.

## Sections

### Header

```markdown
# Trace: <trace_id>

- **Started:** <ISO timestamp>
- **Baseline:** <git commit hash>
- **Quest:** <sprint quest or free-form description>
- **Status:** active | completed | aborted
```

### Activity Log

Populated during the trace session. Each significant action gets an entry:

```markdown
## Activity

- [HH:MM] <action description>
- [HH:MM] Gate G1: PASS
- [HH:MM] Gate G2: FAIL — lint errors in src/foo.ts
- [HH:MM] Fix applied: src/foo.ts — unused import removed
- [HH:MM] Gate G2: PASS (retry)
```

### Results

Populated by `trace stop`:

```markdown
## Results

- **Ended:** <ISO timestamp>
- **End commit:** <git commit hash>
- **Commits:** <count>
- **Files changed:** <count>

### Diff Summary
<git diff --stat output>

### Commit Log
<git log --oneline output>
```

### Gate Summary

```markdown
## Gates

| Gate | Result | Retries | Notes |
|------|--------|---------|-------|
| G1 Surface | PASS | 0 | |
| G2 Static | PASS | 1 | lint fix applied |
| G3 Runtime | PASS | 0 | |
```
