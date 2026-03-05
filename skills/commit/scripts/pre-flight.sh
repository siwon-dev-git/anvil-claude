#!/usr/bin/env bash
set -euo pipefail

# Pre-flight: lint + typecheck on staged files before commit
# exit 0 = ready to commit, exit 1 = fix needed

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GATE_DIR="$(cd "$(dirname "$0")/../../gate-chain/scripts" && pwd)"
source "$GATE_DIR/_detect.sh"
cd "$ROOT"

echo "=== Pre-flight Check ==="

STAGED=$(git diff --cached --name-only --diff-filter=ACMR)
if [ -z "$STAGED" ]; then
  echo "  nothing staged"
  exit 1
fi

echo "  staged: $(echo "$STAGED" | wc -l | tr -d ' ') file(s)"

FAIL=0

echo "[1/2] Lint staged..."
if $LINT 2>&1 | tail -10; then
  echo "  lint: clean"
else
  echo "  lint: issues"
  FAIL=1
fi

echo "[2/2] Typecheck..."
if $TYPECHECK 2>&1 | tail -10; then
  echo "  types: clean"
else
  echo "  types: issues"
  FAIL=1
fi

if [ $FAIL -ne 0 ]; then
  echo "=== Pre-flight FAIL ==="
  exit 1
fi

echo "=== Pre-flight PASS ==="
exit 0
