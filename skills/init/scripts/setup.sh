#!/usr/bin/env bash
set -euo pipefail

# Setup .anvil/ directory from templates
# Usage: setup.sh [project_root]

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_DIR="$(cd "$SKILL_DIR/../.." && pwd)"
ANVIL="$ROOT/.anvil"

echo "=== Anvil Init ==="

if [ -d "$ANVIL" ]; then
  echo "  .anvil/ already exists — skipping"
  exit 0
fi

# Create directories
mkdir -p "$ANVIL/decisions" "$ANVIL/failures" "$ANVIL/structure" "$ANVIL/checks" "$ANVIL/traces"

# Detect stack and write profile
echo "[1/8] Detecting stack..."
bash "$SCRIPT_DIR/detect-stack.sh" "$ROOT" | grep -A 100 '^---' > "$ANVIL/profile.yaml"

# Copy templates
echo "[2/8] Constitution..."
cp "$PLUGIN_DIR/skills/constitution/templates/constitution.md" "$ANVIL/constitution.md"

echo "[3/8] Self-model..."
cp "$PLUGIN_DIR/skills/self-model/templates/self-model.md" "$ANVIL/self-model.md"

echo "[4/8] Decisions..."
cp "$PLUGIN_DIR/skills/adr/templates/decisions.md" "$ANVIL/decisions/active.md"
echo "# Archived Decisions" > "$ANVIL/decisions/archived.md"

echo "[5/8] Failures..."
cp "$PLUGIN_DIR/skills/fmea/templates/failures.md" "$ANVIL/failures/active.md"
cp "$PLUGIN_DIR/skills/fmea/templates/archived.md" "$ANVIL/failures/archived.md"

echo "[6/8] Structure..."
cp "$PLUGIN_DIR/skills/structure/templates/tiers.md" "$ANVIL/structure/tiers.md"

echo "[7/8] Gates..."
cp "$PLUGIN_DIR/skills/gate-chain/templates/gates.yaml" "$ANVIL/checks/gates.yaml"

echo "[8/8] Traces..."
mkdir -p "$ANVIL/traces"

CREATED=$(find "$ANVIL" -type f | wc -l | tr -d ' ')
echo ""
echo "=== Anvil Init Complete: $CREATED files created ==="
echo ""
echo "Next steps:"
echo "  1. Edit .anvil/constitution.md — set your Terminal Goal and Hard Constraints"
echo "  2. Run /anvil-claude:health to verify gate chain works"
echo "  3. Start building with /anvil-claude:sprint <quest>"
exit 0
