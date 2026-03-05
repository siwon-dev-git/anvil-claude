# FMEA Hardening

## When to Harden

A pattern is hardened when ALL of these are true:
1. Pattern has recurred 3+ times
2. A defense mechanism is installed (CI check, lint rule, gate script, etc.)
3. The defense is verified to catch the pattern

## Hardening Procedure

1. Identify the defense: what CI gate, lint rule, or code change prevents recurrence?
2. Verify the defense works: trigger the failure mode, confirm it's caught
3. Move entry from `active.md` to `archived.md`
4. Add note: `(Hardened: defense description)`

## Archived Entry Format

```
- **pattern-name** [category]: Description. Fix: remedy. (Hardened: CI gate-static.sh catches this)
```

## Never Delete

Archived patterns are historical records. They document what went wrong and how it was defended. Never delete — only archive.
