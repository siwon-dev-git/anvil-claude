# Constraint Priority Chain

When rules conflict, resolve by this strict ordering:

```
1. Owner's direct instruction     (highest)
2. Constitution Hard Constraints
3. Constitution Soft Constraints
4. Project conventions (ADR, structure tiers)
5. Execution logic (sprint, gate-chain)
                                  (lowest)
```

## Examples

- User says "skip tests" -> User instruction overrides gate-chain
- Constitution says "no hardcoded colors" but sprint wants speed -> Constitution wins
- ADR says "use REST" but user says "switch to GraphQL" -> User wins, ADR gets updated
- Gate script returns exit 1 but output looks fine -> exit 1 = FAIL, no reinterpretation
