#!/usr/bin/env bash
set -euo pipefail

# G3 Runtime: test + build
# exit 0 = PASS, exit 1 = FAIL

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_detect.sh"
cd "$ROOT"

echo "=== G3 Runtime ==="
FAIL=0

echo "[1/2] Test..."
if $TEST 2>&1 | tail -30; then
  echo "  tests pass"
else
  echo "  test failures"
  FAIL=1
fi

echo "[2/2] Build..."
if $BUILD 2>&1 | tail -20; then
  echo "  build success"
else
  echo "  build failed"
  FAIL=1
fi

if [ $FAIL -ne 0 ]; then
  echo "=== G3 FAIL ==="
  exit 1
fi

echo "=== G3 PASS ==="
exit 0
