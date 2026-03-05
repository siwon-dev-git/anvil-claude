#!/usr/bin/env bash
set -euo pipefail

# G2 Static: lint + typecheck
# exit 0 = PASS, exit 1 = FAIL

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_detect.sh"
cd "$ROOT"

echo "=== G2 Static ==="
FAIL=0

echo "[1/2] Lint..."
if eval "$LINT" 2>&1 | tail -20; then
  echo "  lint clean"
else
  echo "  lint errors"
  FAIL=1
fi

echo "[2/2] Typecheck..."
if eval "$TYPECHECK" 2>&1 | tail -20; then
  echo "  types clean"
else
  echo "  type errors"
  FAIL=1
fi

if [ $FAIL -ne 0 ]; then
  echo "=== G2 FAIL ==="
  exit 1
fi

echo "=== G2 PASS ==="
exit 0
