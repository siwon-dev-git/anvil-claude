# Pattern Compression

How Anvil turns individual failures into reusable rules.

## The Pipeline

```
cases (individual failures)
  → cluster (group by similarity)
  → pattern (extract common structure)
  → rule (generate enforceable check)
  → guard (apply at runtime)
```

## Step 1: Rule-Based Detection (Current)

Hardcoded pattern matchers for the most common AI agent failure modes:

### Common Patterns

| ID | Pattern | Description | Detection |
|----|---------|-------------|-----------|
| P01 | validation-removal | Agent removes validation logic during refactor | FMEA category: `logic-regression` + diff shows deleted guard/check |
| P02 | import-drift | Unused imports accumulate or required imports missing | FMEA category: `fmt-import` |
| P03 | type-erosion | Types loosened (any, unknown, type assertions) | FMEA category: `type-mismatch` + diff shows type change |
| P04 | test-weakening | Test assertions removed or weakened | FMEA category: `logic-assert` + diff shows test file change |
| P05 | dep-bloat | Unnecessary dependencies added | FMEA category: `dep-missing` + package.json change |
| P06 | null-neglect | Null/undefined checks removed or missing | FMEA category: `type-null` |
| P07 | error-swallow | Error handling removed or catch blocks emptied | FMEA category: `logic-runtime` |
| P08 | config-drift | Configuration values changed without ADR | FMEA category: `env-config` |
| P09 | api-break | Public API signature changed without versioning | FMEA category: `int-compat` |
| P10 | schema-mismatch | Data shape doesn't match expected schema | FMEA category: `int-schema` |

### Matching Logic

For each FMEA entry:
1. Extract category tag
2. Match against pattern table
3. If same pattern ID appears 3+ times → flag as candidate

## Step 2: LLM-Based Analysis (Phase 2+)

When rule-based detection is insufficient:
1. Collect 3+ FMEA entries with same category
2. Feed to LLM with prompt: "What is the common structural pattern?"
3. LLM outputs: pattern name, trigger condition, prevention rule
4. If user confirms → add to pattern table

## Step 3: AST-Diff Analysis (Future)

For precise structural matching:
1. Parse diffs into AST changes
2. Cluster by AST change type (deletion, modification, addition)
3. Extract structural patterns (e.g., "guard clause removal")
4. Generate lint rules from AST patterns
