# Build Cycle — Full Step Reference

## Step 1: Understand

- Read the quest (one-sentence goal from user)
- Load context:
  - `.anvil/self-model.md` — current maturity, known boundaries
  - `.anvil/decisions/active.md` — recent architectural decisions
  - `.anvil/failures/active.md` — active failure patterns to avoid
- If quest is ambiguous, clarify with user before proceeding

## Step 2: Scan

- Map files that will be affected
- Identify dependencies and blast radius
- Check if any active FMEA patterns relate to the affected area
- Note files that need tests

## Step 3: Plan

- Sequence changes (what order to modify files)
- Estimate total file count (new + modified)
- If > 10 files, consider splitting into sub-quests
- Record plan summary in session context

## Step 4: G1 Surface Gate

- Run gate-chain G1 (surface.sh)
- Auto-fixes: dependency sync, formatting, lint auto-fix
- Must pass before implementation begins

## Step 5: Implement

- Write code following project conventions
- Respect structure tiers (if `.anvil/structure/tiers.md` exists)
- One logical change per file touch
- Keep functions small, names clear

## Step 6: G2 Static Gate

- Run gate-chain G2 (static.sh)
- Fix lint errors and type errors until clean
- Do not suppress warnings without recording in ADR

## Step 7: Test

- Write tests for new/changed behavior
- Update existing tests if behavior changed
- Aim for meaningful coverage, not 100% line coverage

## Step 8: G3 Runtime Gate

- Run gate-chain G3 (runtime.sh)
- All tests must pass, build must succeed
- If flaky test detected, record in FMEA

## Step 9: G3+ Budget Gate

- Run gate-chain G3+ (budget.sh)
- Check bundle/binary size against budget in profile.yaml
- If over budget, optimize before proceeding

## Step 10: G4 Review

- Self-review the full diff
- Check: does the diff fulfill the quest?
- If architectural decision was made, record in ADR
- If new failure pattern discovered, record in FMEA

## Step 11: G5 CI

- Push branch and watch CI (if gh CLI available)
- If CI fails, diagnose and fix (loop back to relevant step)
- If CI passes, sprint build is complete
