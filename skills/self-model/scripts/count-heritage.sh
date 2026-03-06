#!/usr/bin/env bash
# Count ADR + FMEA heritage entries
ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ADR=$(grep -c '^- \*\*' "$ROOT/.anvil/decisions/active.md" 2>/dev/null || true)
ADR=${ADR:-0}
FMEA=$(grep -c '^- \*\*' "$ROOT/.anvil/failures/active.md" 2>/dev/null || true)
FMEA=${FMEA:-0}
echo "ADR $ADR + FMEA $FMEA"
