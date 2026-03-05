#!/usr/bin/env bash
set -euo pipefail

# Run gate chain sequentially: G1 → G2 → G3 → G3+ → G5
# Usage: run-gates.sh [start_gate]
# start_gate: 1-5 (default: 1)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GATE_DIR="$SCRIPT_DIR/../../gate-chain/scripts"

START=${1:-1}
RESULTS=()

run_gate() {
  local num="$1" name="$2" script="$3"
  if [ "$num" -lt "$START" ]; then
    RESULTS+=("G${num} ⏭")
    return 0
  fi
  echo ""
  if bash "$GATE_DIR/$script"; then
    RESULTS+=("G${num} ✓")
  else
    RESULTS+=("G${num} ✗")
    echo ""
    echo "=== GATE CHAIN STOPPED at G${num} ${name} ==="
    print_summary
    exit 1
  fi
}

print_summary() {
  echo ""
  echo "--- Gate Summary ---"
  for r in "${RESULTS[@]}"; do
    echo "  $r"
  done
}

run_gate 1 "Surface"  "surface.sh"
run_gate 2 "Static"   "static.sh"
run_gate 3 "Runtime"  "runtime.sh"
run_gate 3 "Budget"   "budget.sh"    # G3+
run_gate 5 "CI"       "ci.sh"

print_summary
echo ""
echo "=== ALL GATES PASS ==="
exit 0
