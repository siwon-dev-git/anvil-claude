#!/usr/bin/env bash
# Stack auto-detection. Sourced by all gate scripts.

# Source guard: prevent double execution
[ -n "${_DETECT_LOADED:-}" ] && return 0 2>/dev/null || true
_DETECT_LOADED=1

# Find project root: git root first, then walk up from cwd
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
[ -d "$ROOT/.anvil" ] || ROOT="$(pwd)"

# Package manager: prefer profile.yaml, fallback to lock-file detection
PKG=""
if [ -f "$ROOT/.anvil/profile.yaml" ]; then
  PKG=$(grep "^pkg:" "$ROOT/.anvil/profile.yaml" 2>/dev/null | sed 's/^pkg: *//' || true)
fi
if [ -z "$PKG" ]; then
  if [ -f "$ROOT/pnpm-lock.yaml" ]; then PKG="pnpm"
  elif [ -f "$ROOT/bun.lockb" ] || [ -f "$ROOT/bun.lock" ]; then PKG="bun"
  elif [ -f "$ROOT/yarn.lock" ]; then PKG="yarn"
  elif [ -f "$ROOT/package-lock.json" ]; then PKG="npm"
  elif [ -f "$ROOT/go.mod" ]; then PKG="go"
  elif [ -f "$ROOT/pyproject.toml" ]; then PKG="uv"
  elif [ -f "$ROOT/Cargo.toml" ]; then PKG="cargo"
  else PKG="unknown"; fi
fi

# Default commands by package manager
case "$PKG" in
  pnpm)
    INSTALL="pnpm install --frozen-lockfile"
    LINT="$PKG run lint"
    FORMAT_CHECK="$PKG run format:check"
    FORMAT_WRITE="$PKG run format"
    TYPECHECK="$PKG run typecheck"
    TEST="$PKG run test:ci"
    BUILD="$PKG run build"
    ;;
  npm)
    INSTALL="npm ci"
    LINT="$PKG run lint"
    FORMAT_CHECK="$PKG run format:check"
    FORMAT_WRITE="$PKG run format"
    TYPECHECK="$PKG run typecheck"
    TEST="$PKG run test:ci"
    BUILD="$PKG run build"
    ;;
  yarn)
    INSTALL="yarn install --frozen-lockfile"
    LINT="$PKG run lint"
    FORMAT_CHECK="$PKG run format:check"
    FORMAT_WRITE="$PKG run format"
    TYPECHECK="$PKG run typecheck"
    TEST="$PKG run test:ci"
    BUILD="$PKG run build"
    ;;
  bun)
    INSTALL="bun install --frozen"
    LINT="$PKG run lint"
    FORMAT_CHECK="$PKG run format:check"
    FORMAT_WRITE="$PKG run format"
    TYPECHECK="$PKG run typecheck"
    TEST="$PKG run test:ci"
    BUILD="$PKG run build"
    ;;
  go)
    INSTALL="go mod download"
    LINT="golangci-lint run"
    FORMAT_CHECK="gofmt -l ."
    FORMAT_WRITE="gofmt -w ."
    TYPECHECK="go vet ./..."
    TEST="go test ./..."
    BUILD="go build ./..."
    ;;
  uv)
    INSTALL="uv sync --frozen"
    LINT="uv run ruff check ."
    FORMAT_CHECK="uv run ruff format --check ."
    FORMAT_WRITE="uv run ruff format ."
    TYPECHECK="uv run mypy ."
    TEST="uv run pytest"
    BUILD="uv run python -m build"
    ;;
  cargo)
    INSTALL=""
    LINT="cargo clippy"
    FORMAT_CHECK="cargo fmt --check"
    FORMAT_WRITE="cargo fmt"
    TYPECHECK="cargo check"
    TEST="cargo test"
    BUILD="cargo build --release"
    ;;
  *)
    INSTALL=""
    LINT="true"
    FORMAT_CHECK="true"
    FORMAT_WRITE="true"
    TYPECHECK="true"
    TEST="true"
    BUILD="true"
    ;;
esac

# Markdown lint (optional, runs if available)
MDLINT=""
if command -v markdownlint-cli2 &>/dev/null; then
  MDLINT="markdownlint-cli2"
elif command -v markdownlint &>/dev/null; then
  MDLINT="markdownlint"
elif [ -f "$ROOT/node_modules/.bin/markdownlint-cli2" ]; then
  MDLINT="$ROOT/node_modules/.bin/markdownlint-cli2"
elif [ -f "$ROOT/node_modules/.bin/markdownlint" ]; then
  MDLINT="$ROOT/node_modules/.bin/markdownlint"
fi

# Profile overrides (if profile.yaml exists)
if [ -f "$ROOT/.anvil/profile.yaml" ]; then
  _ov() {
    local val
    val=$(grep "^  $1:" "$ROOT/.anvil/profile.yaml" 2>/dev/null | sed 's/^[^:]*: *//' || true)
    [ -n "$val" ] && printf -v "$2" '%s' "$val" || true
  }
  _ov "lint" LINT
  _ov "format_check" FORMAT_CHECK
  _ov "format" FORMAT_WRITE
  _ov "typecheck" TYPECHECK
  _ov "test" TEST
  _ov "build" BUILD
  _ov "mdlint" MDLINT
fi

export ROOT PKG INSTALL LINT FORMAT_CHECK FORMAT_WRITE TYPECHECK TEST BUILD MDLINT
