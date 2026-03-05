#!/usr/bin/env bash
# SessionStart hook — inject anvil project context

ROOT="$(pwd)"
ANVIL="$ROOT/.anvil"
[ -d "$ANVIL" ] || { echo "Success"; exit 0; }

PARTS=""

# Project status from self-model
if [ -f "$ANVIL/self-model.md" ]; then
  STATE=$(sed -n '/^## Current State/,/^## /{ /^## Current State/d; /^## /d; p; }' "$ANVIL/self-model.md" | head -5 | sed '/^$/d')
  [ -n "$STATE" ] && PARTS="[Anvil] $STATE"
fi

# Active failure pattern count
if [ -f "$ANVIL/failures/active.md" ]; then
  COUNT=$(grep -c '^- \*\*' "$ANVIL/failures/active.md" 2>/dev/null || echo 0)
  [ "$COUNT" -gt 0 ] && PARTS="${PARTS:+$PARTS
}Active failure patterns: $COUNT"
fi

# Active decision count
if [ -f "$ANVIL/decisions/active.md" ]; then
  COUNT=$(grep -c '^- \*\*' "$ANVIL/decisions/active.md" 2>/dev/null || echo 0)
  [ "$COUNT" -gt 0 ] && PARTS="${PARTS:+$PARTS
}Active decisions: $COUNT"
fi

# Current gate state
if [ -f "$ANVIL/checks/.current-gate" ]; then
  GATE=$(cat "$ANVIL/checks/.current-gate" | tr -d '[:space:]')
  [ -n "$GATE" ] && PARTS="${PARTS:+$PARTS
}Current gate: $GATE"
fi

if [ -n "$PARTS" ]; then
  echo "$PARTS"
else
  echo "Success"
fi
