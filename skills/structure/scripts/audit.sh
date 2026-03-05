#!/usr/bin/env bash
set -euo pipefail

# Structure audit: classify files by tier
# Heuristic: count import depth and side-effect markers

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

echo "=== Structure Audit ==="

# Detect source directory
SRC=""
for d in src lib app pkg cmd; do
  [ -d "$d" ] && SRC="$d" && break
done

if [ -z "$SRC" ]; then
  echo "  no src directory found"
  exit 0
fi

T0=0 T1=0 T2=0 T3=0

classify() {
  local file="$1"
  local imports=0 side_effects=0

  # Count project-internal imports (relative paths)
  set +e
  imports=$(grep -cE "^(import|from)\s+['\"]\.\.?/" "$file" 2>/dev/null)
  [ $? -ne 0 ] && imports=0

  # Check for side-effect markers
  side_effects=$(grep -cE "(fetch|axios|fs\.|process\.|console\.|document\.|window\.|setState|dispatch|emit|write|send|exec)" "$file" 2>/dev/null)
  [ $? -ne 0 ] && side_effects=0
  set -e

  if [ "$imports" -eq 0 ] && [ "$side_effects" -eq 0 ]; then
    echo "  T0  $file"
    T0=$((T0 + 1))
  elif [ "$side_effects" -eq 0 ]; then
    echo "  T1  $file"
    T1=$((T1 + 1))
  elif [ "$imports" -le 3 ]; then
    echo "  T2  $file"
    T2=$((T2 + 1))
  else
    echo "  T3  $file"
    T3=$((T3 + 1))
  fi
}

# Scan source files
while IFS= read -r -d '' file; do
  classify "$file"
done < <(find "$SRC" -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.go" -o -name "*.rs" -o -name "*.py" \) -not -path "*/node_modules/*" -not -name "*.test.*" -not -name "*.spec.*" -print0)

echo ""
echo "--- Summary ---"
echo "  T0 Leaf:         $T0"
echo "  T1 Composite:    $T1"
echo "  T2 Connected:    $T2"
echo "  T3 Orchestrator: $T3"
echo "  Total:           $((T0 + T1 + T2 + T3))"
exit 0
