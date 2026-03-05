# Gate Definitions

## Default Chain

| Gate | Name | Type | What | Auto-fix | Retry |
|------|------|------|------|----------|-------|
| G0 | Scope | manual | Scope declaration + FMEA cross-reference | no | 1 |
| G1 | Surface | script | format + lint (auto-fixable) | yes | 1 |
| G2 | Static | script | lint + typecheck | no | 3 |
| G3 | Runtime | script | test + build | no | 3 |
| G3+ | Budget | script | bundle/binary size limit | no | 0 |
| G4 | Retro | manual | Heritage update if 3+ commits | no | 1 |
| G5 | CI | script | Remote CI green | no | 3 |

## Gate Types

### script
Executed via `bash .anvil/checks/{name}.sh`.
Exit code 0 = PASS, 1 = FAIL. No interpretation.

### manual
Agent makes judgment based on description.
Cannot be automated — requires contextual reasoning.
