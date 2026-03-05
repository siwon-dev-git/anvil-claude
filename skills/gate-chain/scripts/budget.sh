#!/usr/bin/env bash
set -euo pipefail

# G3+ Budget: bundle/binary size check
# exit 0 = PASS, exit 1 = FAIL

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_detect.sh"
cd "$ROOT"

echo "=== G3+ Budget ==="

# Read budget from profile.yaml (default 512KB)
BUDGET_KB=$(grep 'bundle_budget_kb:' "$ROOT/.anvil/profile.yaml" 2>/dev/null | grep -oE '[0-9]+' | head -1 || true)
BUDGET_KB=${BUDGET_KB:-512}

# Measure build output size
TOTAL=0
case "$PKG" in
  pnpm|npm|yarn|bun)
    for f in dist/assets/*.js dist/assets/*.css; do
      [ -f "$f" ] && TOTAL=$((TOTAL + $(wc -c < "$f")))
    done
    ;;
  go|cargo)
    BIN=$(find . -maxdepth 2 -type f -perm /111 ! -path './node_modules/*' | head -1)
    [ -f "$BIN" ] && TOTAL=$(wc -c < "$BIN")
    ;;
  *)
    echo "  budget check not configured for $PKG"
    exit 0
    ;;
esac

SIZE_KB=$((TOTAL / 1024))
echo "  size: ${SIZE_KB}KB / budget: ${BUDGET_KB}KB"

if [ "$SIZE_KB" -le "$BUDGET_KB" ]; then
  echo "=== G3+ PASS ==="
  exit 0
else
  echo "=== G3+ FAIL (${SIZE_KB}KB > ${BUDGET_KB}KB) ==="
  exit 1
fi
