#!/usr/bin/env bash
set -euo pipefail

# G1 Surface: auto-fixable checks
# exit 0 = PASS, exit 1 = FAIL

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_detect.sh"
cd "$ROOT"

echo "=== G1 Surface ==="

echo "[1/4] Dependencies..."
if [ -z "$INSTALL" ]; then
  echo "  skipped (no install command for $PKG)"
else
  $INSTALL 2>/dev/null || {
    echo "  lockfile out of sync, regenerating..."
    $PKG install
  }
fi

echo "[2/4] Format..."
if $FORMAT_CHECK 2>/dev/null; then
  echo "  format clean"
else
  echo "  fixing format..."
  $FORMAT_WRITE
  $FORMAT_CHECK || { echo "  format still failing"; exit 1; }
  echo "  format fixed"
fi

echo "[3/4] Lint auto-fix..."
$LINT --fix 2>/dev/null || true

echo "[4/4] Markdown lint..."
if [ -n "$MDLINT" ]; then
  if $MDLINT --fix "**/*.md" 2>/dev/null; then
    echo "  markdown clean"
  else
    $MDLINT "**/*.md" 2>&1 | tail -10 || true
    echo "  markdown issues (auto-fix applied where possible)"
  fi
else
  echo "  skipped (markdownlint not found)"
fi

echo "=== G1 PASS ==="
exit 0
