#!/usr/bin/env bash
# SessionStart hook — inject anvil project context

ROOT="$(pwd)"
ANVIL="$ROOT/.anvil"
[ -d "$ANVIL" ] || { echo "Success"; exit 0; }

# Load locale
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/locale/_load.sh" "$ROOT"

PARTS=""

# Preferred language
PARTS="$L_SESSION_LANG"

# Project status from self-model
if [ -f "$ANVIL/self-model.md" ]; then
  STATE=$(sed -n '/^## Current State/,/^## /{ /^## Current State/d; /^## /d; p; }' "$ANVIL/self-model.md" | head -5 | sed '/^$/d')
  [ -n "$STATE" ] && PARTS="${PARTS:+$PARTS
}[Anvil] $STATE"
fi

# Active failure pattern count
if [ -f "$ANVIL/failures/active.md" ]; then
  COUNT=$(grep -c '^- \*\*' "$ANVIL/failures/active.md" 2>/dev/null || true)
  COUNT=${COUNT:-0}
  COUNT=$(echo "$COUNT" | tr -d '[:space:]')
  [ "$COUNT" -gt 0 ] && PARTS="${PARTS:+$PARTS
}$L_SESSION_FAILURES: $COUNT"
fi

# Active decision count
if [ -f "$ANVIL/decisions/active.md" ]; then
  COUNT=$(grep -c '^- \*\*' "$ANVIL/decisions/active.md" 2>/dev/null || true)
  COUNT=${COUNT:-0}
  COUNT=$(echo "$COUNT" | tr -d '[:space:]')
  [ "$COUNT" -gt 0 ] && PARTS="${PARTS:+$PARTS
}$L_SESSION_DECISIONS: $COUNT"
fi

# Active guard rules
if [ -f "$ANVIL/checks/guards.md" ]; then
  GUARD_COUNT=$(grep -c '^## G-' "$ANVIL/checks/guards.md" 2>/dev/null || true)
  GUARD_COUNT=${GUARD_COUNT:-0}
  GUARD_COUNT=$(echo "$GUARD_COUNT" | tr -d '[:space:]')
  [ "$GUARD_COUNT" -gt 0 ] && PARTS="${PARTS:+$PARTS
}$L_SESSION_GUARDS: $GUARD_COUNT"
fi

# Active trace
if [ -f "$ANVIL/traces/.active" ]; then
  TRACE_ID=$(basename "$(cat "$ANVIL/traces/.active")" .md)
  PARTS="${PARTS:+$PARTS
}$L_SESSION_TRACE: $TRACE_ID"
fi

# Current gate state
if [ -f "$ANVIL/checks/.current-gate" ]; then
  GATE=$(cat "$ANVIL/checks/.current-gate" | tr -d '[:space:]')
  [ -n "$GATE" ] && PARTS="${PARTS:+$PARTS
}$L_SESSION_GATE: $GATE"
fi

if [ -n "$PARTS" ]; then
  echo "$PARTS"
else
  echo "Success"
fi
