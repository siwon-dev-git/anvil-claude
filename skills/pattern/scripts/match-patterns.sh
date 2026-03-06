#!/usr/bin/env bash
# Scan FMEA entries for recurring failure patterns
# Outputs: category counts that meet the threshold (default: 3)

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
THRESHOLD="${2:-3}"
FMEA="$ROOT/.anvil/failures/active.md"

if [ ! -f "$FMEA" ]; then
  echo "No FMEA file found at $FMEA"
  exit 0
fi

echo "=== Pattern Scan ==="

# Extract category tags from FMEA entries
# Expected format: lines containing [category-tag] or **Category:** tag
# Match compound tags (type-mismatch) and simple tags (runtime, testing, dependency)
COMPOUND=$(grep -oE '\b(dep|fmt|type|logic|build|env|int)-(lockfile|missing|version|peer|style|lint|import|mismatch|null|assert|runtime|timeout|regression|compile|bundle|size|tool|config|platform|api|schema|compat)\b' "$FMEA" 2>/dev/null || true)
SIMPLE=$(grep -oE '\[(runtime|testing|dependency|build|environment|integration|formatting|typing)\]' "$FMEA" 2>/dev/null | tr -d '[]' || true)
CATEGORIES=$(printf '%s\n%s' "$COMPOUND" "$SIMPLE" | sed '/^$/d')

if [ -z "$CATEGORIES" ]; then
  echo "No categorized failures found."
  echo "Tip: Use insight skill to categorize failures with standard tags."
  exit 0
fi

# Count occurrences of each category
echo "$CATEGORIES" | sort | uniq -c | sort -rn | while read -r count category; do
  count=$(echo "$count" | tr -d ' ')
  if [ "$count" -ge "$THRESHOLD" ]; then
    echo "  PATTERN CANDIDATE: $category ($count occurrences)"
  else
    echo "  noted: $category ($count occurrences)"
  fi
done

echo ""
echo "Threshold: $THRESHOLD occurrences"
