#!/usr/bin/env bash
set -euo pipefail

# G1 Surface: auto-fixable checks
# exit 0 = PASS, exit 1 = FAIL

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_detect.sh"
cd "$ROOT"

echo "=== G1 Surface ==="

echo "[1/3] Dependencies..."
$PKG install --frozen-lockfile 2>/dev/null || {
  echo "  lockfile out of sync, regenerating..."
  $PKG install
}

echo "[2/3] Format..."
if $FORMAT_CHECK 2>/dev/null; then
  echo "  format clean"
else
  echo "  fixing format..."
  $FORMAT_WRITE
  $FORMAT_CHECK || { echo "  format still failing"; exit 1; }
  echo "  format fixed"
fi

echo "[3/3] Lint auto-fix..."
$LINT --fix 2>/dev/null || true

echo "=== G1 PASS ==="
exit 0
