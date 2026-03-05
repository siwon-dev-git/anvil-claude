---
name: gate-chain
description: Sequential quality gates. Script exit codes decide PASS/FAIL. Called by sprint review phase.
---

# Gate Chain

$ARGUMENTS

## Argument Parsing

- `run <G1|G2|G3|G3+|G5>` -> Execute single gate script
- `run all` -> Execute G1->G2->G3->G3+ sequentially (stop on FAIL)
- `status` -> Read `.anvil/checks/.current-gate`
- `show` -> Read `.anvil/checks/gates.yaml`
- `init` -> Copy scripts + templates to `.anvil/checks/`

## Execution

```bash
bash .anvil/checks/{gate}.sh
```

- exit 0 -> PASS
- exit 1 -> FAIL

## Gate Chain Order

G0(manual) -> G1(surface) -> G2(static) -> G3(runtime) -> G3+(budget) -> G4(manual) -> G5(ci)

G(N) FAIL -> do NOT run G(N+1).

FAIL procedure -> Read `reference/fail-procedure.md`
Gate definitions -> Read `reference/gates.md`

## Rules

1. Exit code is final. Do not reinterpret
2. --no-verify prohibited
3. Retry count defined in gates.yaml
4. Retry exhausted -> BLOCKED

## Init

Copies scripts/ .sh files to `.anvil/checks/`.
After copy, project owns the scripts — customize freely.
