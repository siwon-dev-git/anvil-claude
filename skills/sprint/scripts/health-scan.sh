#!/usr/bin/env bash
set -euo pipefail

# Health scan for maintain mode
# Reports lint/type/test status without fixing

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GATE_DIR="$SCRIPT_DIR/../../gate-chain/scripts"
source "$GATE_DIR/_detect.sh"
cd "$ROOT"

echo "=== Health Scan ==="
ISSUES=0

echo "[1/3] Lint..."
if eval "$LINT" 2>&1 | tail -5; then
  echo "  lint: clean"
else
  echo "  lint: issues found"
  ISSUES=$((ISSUES + 1))
fi

echo "[2/3] Types..."
if eval "$TYPECHECK" 2>&1 | tail -5; then
  echo "  types: clean"
else
  echo "  types: issues found"
  ISSUES=$((ISSUES + 1))
fi

echo "[3/3] Tests..."
if eval "$TEST" 2>&1 | tail -5; then
  echo "  tests: passing"
else
  echo "  tests: failures"
  ISSUES=$((ISSUES + 1))
fi

echo ""
echo "=== Scan Complete: $ISSUES area(s) need attention ==="
exit $ISSUES
