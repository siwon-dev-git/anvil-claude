#!/usr/bin/env bash
# Pre-execution guard check
# Scans current diff against guard rules
# exit 0 = all clear, exit 1 = block triggered

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ANVIL="$ROOT/.anvil"
GUARDS="$ANVIL/checks/guards.md"
LOG="$ANVIL/checks/guard-hits.log"

if [ ! -f "$GUARDS" ]; then
  echo "No guard rules defined."
  exit 0
fi

echo "=== Guard Pre-Check ==="

# Get current diff
DIFF=$(git diff --cached --name-only 2>/dev/null || git diff HEAD --name-only 2>/dev/null || true)

if [ -z "$DIFF" ]; then
  echo "  No changes to check."
  exit 0
fi

WARNINGS=0
BLOCKS=0
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Check for dependency changes
DEP_FILES=$(echo "$DIFF" | grep -E '(package\.json|go\.mod|Cargo\.toml|pyproject\.toml|requirements\.txt)' || true)
if [ -n "$DEP_FILES" ]; then
  if grep -q 'Type.*dependency' "$GUARDS" 2>/dev/null; then
    echo "  [WARN] Dependency files changed: $DEP_FILES"
    echo "  → Check: ADR recorded? License compatible? Size impact?"
    WARNINGS=$((WARNINGS + 1))
    echo "$TIMESTAMP WARN dependency $DEP_FILES" >> "$LOG" 2>/dev/null || true
  fi
fi

# Check for validation/guard code removal
if [ -n "$DIFF" ]; then
  DELETED_GUARDS=$(git diff --cached -U0 2>/dev/null | grep -E '^\-.*\b(if|guard|assert|throw|validate|check)\b' | head -5 || true)
  if [ -n "$DELETED_GUARDS" ] && grep -q 'Type.*regression\|Type.*validation' "$GUARDS" 2>/dev/null; then
    echo "  [WARN] Possible validation/guard code removed:"
    echo "$DELETED_GUARDS" | head -3 | sed 's/^/    /'
    WARNINGS=$((WARNINGS + 1))
    echo "$TIMESTAMP WARN validation-removal" >> "$LOG" 2>/dev/null || true
  fi
fi

# Check for test file changes (potential test weakening)
TEST_FILES=$(echo "$DIFF" | grep -E '\.(test|spec)\.(ts|js|tsx|jsx|py|go|rs)$' || true)
if [ -n "$TEST_FILES" ]; then
  DELETED_ASSERTS=$(git diff --cached -U0 2>/dev/null | grep -E '^\-.*\b(expect|assert|should|must)\b' | head -5 || true)
  if [ -n "$DELETED_ASSERTS" ] && grep -q 'Type.*regression' "$GUARDS" 2>/dev/null; then
    echo "  [WARN] Test assertions may have been weakened:"
    echo "$DELETED_ASSERTS" | head -3 | sed 's/^/    /'
    WARNINGS=$((WARNINGS + 1))
    echo "$TIMESTAMP WARN test-weakening $TEST_FILES" >> "$LOG" 2>/dev/null || true
  fi
fi

# Summary
echo ""
if [ "$BLOCKS" -gt 0 ]; then
  echo "=== Guard BLOCK: $BLOCKS blocking issues ==="
  exit 1
elif [ "$WARNINGS" -gt 0 ]; then
  echo "=== Guard WARN: $WARNINGS warnings (non-blocking) ==="
  exit 0
else
  echo "=== Guard PASS ==="
  exit 0
fi
