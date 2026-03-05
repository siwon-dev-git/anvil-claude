#!/usr/bin/env bash
set -euo pipefail

# G5 CI: remote CI check
# exit 0 = PASS, exit 1 = FAIL

echo "=== G5 CI ==="

if ! command -v gh &>/dev/null; then
  echo "  gh CLI not found — skip CI check"
  exit 0
fi

echo "  watching CI..."
if gh run watch --exit-status 2>&1 | tail -10; then
  echo "=== G5 PASS ==="
  exit 0
else
  echo "=== G5 FAIL ==="
  exit 1
fi
