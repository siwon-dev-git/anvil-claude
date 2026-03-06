#!/usr/bin/env bash
set -euo pipefail

# Start a new execution trace
ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ANVIL="$ROOT/.anvil"
TRACES="$ANVIL/traces"

mkdir -p "$TRACES"

# Check for already-active trace
if [ -f "$TRACES/.active" ]; then
  EXISTING=$(basename "$(cat "$TRACES/.active")" .md)
  echo "Trace already active: $EXISTING"
  echo "Run 'trace stop' first."
  exit 1
fi

# Generate trace ID and baseline
TRACE_ID=$(date +%Y-%m-%d-%H%M%S)
BASELINE=$(git rev-parse HEAD 2>/dev/null || echo "no-git")
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Create trace file
TRACE_FILE="$TRACES/$TRACE_ID.md"
cat > "$TRACE_FILE" <<EOF
# Trace: $TRACE_ID

- **Started:** $TIMESTAMP
- **Baseline:** $BASELINE
- **Quest:** <!-- fill in quest or task description -->
- **Status:** active

## Activity

<!-- Log significant actions here -->

## Results

<!-- Populated by trace stop -->

## Gates

| Gate | Result | Retries | Notes |
|------|--------|---------|-------|
EOF

# Mark as active
echo "$TRACE_FILE" > "$TRACES/.active"

echo "Trace started: $TRACE_ID (baseline: ${BASELINE:0:8})"
