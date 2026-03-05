#!/usr/bin/env bash
# PreToolUse:Edit/Write hook — warn on constitution.md modification

INPUT="${CLAUDE_TOOL_INPUT:-{}}"

case "$INPUT" in
  *".anvil/constitution.md"*)
    echo "constitution.md is a trust anchor. Confirm this modification with the user before proceeding."
    ;;
  *)
    echo "Success"
    ;;
esac
