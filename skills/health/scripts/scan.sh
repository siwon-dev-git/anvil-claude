#!/usr/bin/env bash
set -euo pipefail

# Quick health scan: lint + types + tests + budget + git
# Reports status per category, does NOT fix anything

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GATE_DIR="$SCRIPT_DIR/../../gate-chain/scripts"
source "$GATE_DIR/_detect.sh"
cd "$ROOT"

echo "=== Health Scan ==="
SCORE=0
TOTAL=5

check() {
  local name="$1" cmd="$2"
  if eval "$cmd" >/dev/null 2>&1; then
    echo "  ✓ $name"
    SCORE=$((SCORE + 1))
  else
    echo "  ✗ $name"
  fi
}

check "Lint"      "$LINT"
check "Types"     "$TYPECHECK"
check "Tests"     "$TEST"
check "Build"     "$BUILD"

# Git status
if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
  echo "  ✓ Git (clean)"
  SCORE=$((SCORE + 1))
else
  DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "  ✗ Git ($DIRTY uncommitted)"
fi

echo ""
echo "=== Health: $SCORE/$TOTAL ==="

if [ "$SCORE" -eq "$TOTAL" ]; then
  exit 0
else
  exit 1
fi
