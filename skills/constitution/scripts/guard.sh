#!/usr/bin/env bash
set -euo pipefail

# Constitution tamper detection via checksum
# Usage: guard.sh [project_root]
ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
CONST="$ROOT/.anvil/constitution.md"
CHECKSUM_FILE="$ROOT/.anvil/.constitution.sha256"

if [ ! -f "$CONST" ]; then
  echo "constitution.md not found"
  exit 1
fi

CURRENT=$(shasum -a 256 "$CONST" | awk '{print $1}')

if [ ! -f "$CHECKSUM_FILE" ]; then
  echo "$CURRENT" > "$CHECKSUM_FILE"
  echo "checksum initialized: $CURRENT"
  exit 0
fi

STORED=$(cat "$CHECKSUM_FILE")

if [ "$CURRENT" = "$STORED" ]; then
  echo "constitution: INTACT"
  exit 0
else
  echo "constitution: MODIFIED (expected $STORED, got $CURRENT)"
  echo "only human owner may modify this file"
  exit 1
fi
