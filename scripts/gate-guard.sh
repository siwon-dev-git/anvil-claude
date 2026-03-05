#!/usr/bin/env bash
# PreToolUse:Bash hook — block dangerous patterns

INPUT="${CLAUDE_TOOL_INPUT:-{}}"

check() {
  case "$INPUT" in
    *"$1"*) echo "$2"; exit 0 ;;
  esac
}

check "--no-verify"     "Anvil: --no-verify is prohibited. Fix the issue instead."
check "--force"         "Anvil: --force is prohibited. Use safe alternatives."
check "git push -f"     "Anvil: force push is prohibited."
check "git reset --hard" "Anvil: hard reset is prohibited. Investigate first."

echo "Success"
