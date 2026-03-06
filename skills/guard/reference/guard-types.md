# Guard Types

Adaptive runtime guards that go beyond CI. These checks are unique to Anvil — they encode project-specific knowledge from past failures and decisions.

## What Makes Guards Different from CI

```
CI:    "Does it build? Do tests pass?"
Guard: "Does this change contradict a past decision? Does it repeat a known failure pattern?"
```

CI checks are generic and universal. Guards are project-specific and learned.

## Types

### 1. Complexity Guard (`complexity`)

Triggers when files are added or significantly modified.

**Check:** Does the file fit within the project's structure tier classification?
- New files must be assigned a tier
- Tier 0 (critical) files require explicit ADR for modification
- Prevents architectural entropy

**Source:** Structure skill tier rules

### 2. Dependency Guard (`dependency`)

Triggers when dependency manifest changes (package.json, go.mod, Cargo.toml, etc.).

**Check:**
- Is the package necessary? (was it discussed in ADR?)
- Known vulnerabilities? (npm audit / cargo audit)
- License compatible?
- Size impact on bundle budget?

**Source:** ADR decisions about dependencies

### 3. Convention Guard (`convention`)

Triggers on any code change.

**Check:** Does the change align with recorded ADR decisions?
- Naming conventions
- Architecture patterns (e.g., "ESM only", "no class inheritance")
- API design rules

**Source:** `.anvil/decisions/active.md`

### 4. Regression Guard (`regression`)

Triggers on any code change.

**Check:** Does the change match a known FMEA failure pattern?
- Validation removal
- Type erosion
- Test weakening
- Error swallowing

**Source:** `.anvil/failures/active.md` + promoted patterns

### 5. Validation Guard (`validation`)

Triggers when files containing guard/validation logic are modified.

**Check:** Was validation logic removed or weakened?
- Deleted if/guard/assert statements
- Loosened conditions
- Removed error handling

**Source:** Pattern P01 (validation-removal), P07 (error-swallow)

### 6. API Guard (`api`)

Triggers when public interface files are modified.

**Check:**
- Was the API signature changed?
- Is it backward compatible?
- Was an ADR recorded for the change?

**Source:** Pattern P09 (api-break)
