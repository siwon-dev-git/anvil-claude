# Gate FAIL Procedure

## By Gate

| Gate | auto_fix | Procedure |
|------|----------|-----------|
| G1 surface | yes | Script auto-fixes. exit 1 = auto-fix failed -> manual fix -> rerun |
| G2 static | no | Read output tail -30 -> fix code -> rerun |
| G3 runtime | no | Read output tail -30 -> fix code -> rerun |
| G3+ budget | no | Optimize bundle/binary -> rerun |
| G5 ci | no | Analyze CI logs -> fix locally -> re-enter at G1 -> push |

## Retry Rules

- Each gate has a retry count in gates.yaml
- Each fix attempt = 1 retry consumed
- Retry exhausted -> BLOCKED (sprint halts)

## Context Budget

- Prefer delegating gate execution to Agent tool (isolates output from main context)
- When running directly, pipe through `2>&1 | tail -30`
- Do not re-read files already read in same session

## G5 FAIL Recovery

G5 (CI) failure requires full re-validation:
1. Fix issue locally
2. Re-enter at G1 (full gate chain from start)
3. Push again
4. Re-watch CI
