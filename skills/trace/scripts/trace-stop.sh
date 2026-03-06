#!/usr/bin/env bash
set -euo pipefail

# Stop active execution trace and record results
ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ANVIL="$ROOT/.anvil"
TRACES="$ANVIL/traces"

if [ ! -f "$TRACES/.active" ]; then
  echo "No active trace."
  exit 1
fi

TRACE_FILE=$(cat "$TRACES/.active")
TRACE_ID=$(basename "$TRACE_FILE" .md)

# Extract baseline commit from trace file
BASELINE=$(grep '^\- \*\*Baseline:\*\*' "$TRACE_FILE" | sed 's/.*\*\* //')
END_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "no-git")
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Gather results
if [ "$BASELINE" != "no-git" ] && [ "$END_COMMIT" != "no-git" ]; then
  DIFF_STAT=$(git diff "$BASELINE".."$END_COMMIT" --stat 2>/dev/null || echo "(no changes)")
  COMMIT_LOG=$(git log "$BASELINE".."$END_COMMIT" --oneline 2>/dev/null || echo "(no commits)")
  COMMIT_COUNT=$(git rev-list "$BASELINE".."$END_COMMIT" --count 2>/dev/null || echo "0")
  FILES_CHANGED=$(git diff "$BASELINE".."$END_COMMIT" --name-only 2>/dev/null | wc -l | tr -d ' ')
else
  DIFF_STAT="(git not available)"
  COMMIT_LOG="(git not available)"
  COMMIT_COUNT="0"
  FILES_CHANGED="0"
fi

# Update trace file — replace Results section
RESULTS_BLOCK="## Results

- **Ended:** $TIMESTAMP
- **End commit:** $END_COMMIT
- **Commits:** $COMMIT_COUNT
- **Files changed:** $FILES_CHANGED

### Diff Summary
\`\`\`
$DIFF_STAT
\`\`\`

### Commit Log
\`\`\`
$COMMIT_LOG
\`\`\`"

# Replace the placeholder Results section
sed -i.bak '/^## Results$/,/^## /{ /^## Gates$/!{ /^## Results$/!d; }; /^## Results$/c\
'"$(echo "$RESULTS_BLOCK" | sed 's/$/\\/' | sed '$ s/\\$//')"'
}' "$TRACE_FILE" 2>/dev/null || true
rm -f "$TRACE_FILE.bak"

# Update status
sed -i.bak 's/\*\*Status:\*\* active/**Status:** completed/' "$TRACE_FILE"
rm -f "$TRACE_FILE.bak"

# Remove active marker
rm -f "$TRACES/.active"

echo "Trace stopped: $TRACE_ID — $FILES_CHANGED files changed, $COMMIT_COUNT commits"
