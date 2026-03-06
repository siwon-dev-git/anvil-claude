#!/usr/bin/env bash
set -euo pipefail

# Detect project stack and output profile.yaml content
# Usage: detect-stack.sh [project_root]

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$ROOT"

echo "=== Stack Detection ==="

# Package manager
PKG="unknown"
if [ -f "pnpm-lock.yaml" ]; then PKG="pnpm"
elif [ -f "bun.lockb" ] || [ -f "bun.lock" ]; then PKG="bun"
elif [ -f "yarn.lock" ]; then PKG="yarn"
elif [ -f "package-lock.json" ]; then PKG="npm"
elif [ -f "go.mod" ]; then PKG="go"
elif [ -f "Cargo.toml" ]; then PKG="cargo"
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then PKG="uv"
fi

# Language
LANG="unknown"
if [ -f "tsconfig.json" ]; then LANG="typescript"
elif [ -f "jsconfig.json" ] || [ -f "package.json" ]; then LANG="javascript"
elif [ -f "go.mod" ]; then LANG="go"
elif [ -f "Cargo.toml" ]; then LANG="rust"
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then LANG="python"
fi

# Framework (JS/TS ecosystem)
FRAMEWORK="none"
if [ -f "package.json" ]; then
  if grep -q '"next"' package.json 2>/dev/null; then FRAMEWORK="next"
  elif grep -q '"react"' package.json 2>/dev/null; then FRAMEWORK="react"
  elif grep -q '"vue"' package.json 2>/dev/null; then FRAMEWORK="vue"
  elif grep -q '"svelte"' package.json 2>/dev/null; then FRAMEWORK="svelte"
  elif grep -q '"express"' package.json 2>/dev/null; then FRAMEWORK="express"
  elif grep -q '"fastify"' package.json 2>/dev/null; then FRAMEWORK="fastify"
  fi
fi

# Test runner (config files first, then devDependencies)
TEST_RUNNER="none"
if [ -f "vitest.config.ts" ] || [ -f "vitest.config.js" ] || [ -f "vitest.config.mts" ]; then TEST_RUNNER="vitest"
elif [ -f "jest.config.ts" ] || [ -f "jest.config.js" ] || [ -f "jest.config.mjs" ]; then TEST_RUNNER="jest"
elif [ -f "playwright.config.ts" ] || [ -f "playwright.config.js" ]; then TEST_RUNNER="playwright"
elif grep -q '"mocha"' package.json 2>/dev/null; then TEST_RUNNER="mocha"
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then TEST_RUNNER="pytest"
fi
# Fallback: check devDependencies if no config file found
if [ "$TEST_RUNNER" = "none" ] && [ -f "package.json" ]; then
  if grep -q '"vitest"' package.json 2>/dev/null; then TEST_RUNNER="vitest"
  elif grep -q '"jest"' package.json 2>/dev/null; then TEST_RUNNER="jest"
  elif grep -q '"playwright"' package.json 2>/dev/null; then TEST_RUNNER="playwright"
  elif grep -q '"mocha"' package.json 2>/dev/null; then TEST_RUNNER="mocha"
  fi
fi

# Linter
LINTER="none"
if [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]; then LINTER="eslint"
elif [ -f "biome.json" ] || [ -f "biome.jsonc" ] || grep -q '"@biomejs/biome"' package.json 2>/dev/null; then LINTER="biome"
elif [ -f ".golangci.yml" ]; then LINTER="golangci-lint"
elif [ -f "clippy.toml" ] || [ -f ".clippy.toml" ]; then LINTER="clippy"
elif [ -f "ruff.toml" ] || grep -q "ruff" pyproject.toml 2>/dev/null; then LINTER="ruff"
fi

echo "  pkg: $PKG"
echo "  lang: $LANG"
echo "  framework: $FRAMEWORK"
echo "  test: $TEST_RUNNER"
echo "  lint: $LINTER"

# Default commands by package manager
CMD_LINT=""
CMD_FORMAT_CHECK=""
CMD_FORMAT=""
CMD_TYPECHECK=""
CMD_TEST=""
CMD_BUILD=""

case "$PKG" in
  pnpm|npm|yarn|bun)
    CMD_LINT="$PKG run lint"
    CMD_FORMAT_CHECK="$PKG run format:check"
    CMD_FORMAT="$PKG run format"
    CMD_TYPECHECK="$PKG run typecheck"
    CMD_TEST="$PKG run test:ci"
    CMD_BUILD="$PKG run build"
    ;;
  go)
    CMD_LINT="golangci-lint run"
    CMD_FORMAT_CHECK="gofmt -l ."
    CMD_FORMAT="gofmt -w ."
    CMD_TYPECHECK="go vet ./..."
    CMD_TEST="go test ./..."
    CMD_BUILD="go build ./..."
    ;;
  uv)
    CMD_LINT="uv run ruff check ."
    CMD_FORMAT_CHECK="uv run ruff format --check ."
    CMD_FORMAT="uv run ruff format ."
    CMD_TYPECHECK="uv run mypy ."
    CMD_TEST="uv run pytest"
    CMD_BUILD="uv run python -m build"
    ;;
  cargo)
    CMD_LINT="cargo clippy"
    CMD_FORMAT_CHECK="cargo fmt --check"
    CMD_FORMAT="cargo fmt"
    CMD_TYPECHECK="cargo check"
    CMD_TEST="cargo test"
    CMD_BUILD="cargo build --release"
    ;;
esac

# Output YAML
cat << EOF
---
# anvil profile (auto-detected)
stack: $PKG
pkg: $PKG
language: $LANG
framework: $FRAMEWORK
test_runner: $TEST_RUNNER
linter: $LINTER
bundle_budget_kb: 512
EOF

if [ -n "$CMD_LINT" ]; then
cat << EOF
commands:
  lint: $CMD_LINT
  format_check: $CMD_FORMAT_CHECK
  format: $CMD_FORMAT
  typecheck: $CMD_TYPECHECK
  test: $CMD_TEST
  build: $CMD_BUILD
EOF
fi
