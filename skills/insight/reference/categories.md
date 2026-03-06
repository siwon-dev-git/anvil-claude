# Failure Categories

Classification system for gate failures and unexpected behaviors.

## Categories

### 1. Dependency

Failures caused by package/module dependency issues.

- **dep-lockfile** — Lockfile out of sync with manifest
- **dep-missing** — Required dependency not installed
- **dep-version** — Version conflict or incompatible upgrade
- **dep-peer** — Peer dependency not satisfied

### 2. Syntax & Format

Failures caught by linters and formatters.

- **fmt-style** — Code style violation (formatting)
- **fmt-lint** — Lint rule violation
- **fmt-import** — Unused or missing imports

### 3. Type

Failures from static type checking.

- **type-mismatch** — Type incompatibility
- **type-missing** — Missing type annotation or declaration
- **type-null** — Null/undefined safety violation

### 4. Logic

Failures from test execution.

- **logic-assert** — Test assertion failure
- **logic-runtime** — Runtime error during test
- **logic-timeout** — Test timeout
- **logic-regression** — Previously passing test now fails

### 5. Build

Failures from compilation/bundling.

- **build-compile** — Compilation error
- **build-bundle** — Bundler configuration issue
- **build-size** — Bundle/binary size exceeds budget

### 6. Environment

Failures from environment/tooling issues.

- **env-tool** — Required tool not installed
- **env-config** — Configuration file missing or invalid
- **env-platform** — Platform-specific incompatibility

### 7. Integration

Failures from cross-component or external interactions.

- **int-api** — API contract violation
- **int-schema** — Data schema mismatch
- **int-compat** — Backward compatibility break
