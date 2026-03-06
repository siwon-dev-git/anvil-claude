---
name: sprint
trigger: sprint|build|maintain|heal
description: Build cycle (11 steps + 6 gates) or Heal cycle (sense-decide-execute-learn)
---

# Sprint

Two modes: **Build** (new work) and **Maintain** (heal existing).

## Build Mode — `/sprint <quest>`

Quest = one-sentence goal. 12 steps, 7 gates.

### Phase 1: Prepare (Steps 1-3)

1. **Understand** — Read quest. Load `.anvil/self-model.md`, recent decisions, active failures.
   - Run `trace start` to begin execution trace capture.
   - Read `reference/build.md` for full step details.

2. **Scan** — Map affected files. Identify blast radius.

3. **Plan** — Sequence changes. Estimate file count. Record plan in session.

### Phase 2: Execute (Steps 4-9)

4. **G0 Guard** — Run `guard check` to verify against learned rules and past failures.

5. **G1 Surface** — Run `gate-chain` G1 (deps + format + lint auto-fix).

6. **Implement** — Write code. Follow project conventions.

7. **G2 Static** — Run `gate-chain` G2 (lint + typecheck). Fix until pass.

8. **Test** — Write/update tests for changed code.

9. **G3 Runtime** — Run `gate-chain` G3 (test + build). Fix until pass. On gate failure, use `insight` skill for root cause analysis.

### Phase 3: Ship (Steps 10-12)

10. **G3+ Budget** — Run `gate-chain` G3+ (bundle/binary size check).

11. **G4 Review** — Self-review diff. Check against quest. Record ADR if architectural.
    - Run `trace stop` to finalize execution trace.
    - Run `self-model auto-update` to refresh heritage counts.
    - Run `pattern scan` to check for new failure patterns.

12. **G5 CI** — Push and watch CI (if configured).

### Output

After build, produce sprint output. See `reference/output.md`.

## Maintain Mode — `/sprint` or `/sprint N`

No quest = heal mode. Optional number N = focus area.

Read `reference/maintain.md` for the 4-step SDEL cycle:
**Sense** (scan health) -> **Decide** (prioritize) -> **Execute** (fix) -> **Learn** (record).

## Retrospective

After every sprint, run retrospective. See `reference/retro.md`.
