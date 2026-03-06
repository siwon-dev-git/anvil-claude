#!/usr/bin/env bash
# UserPromptSubmit hook — detect skill triggers and emit MAGIC KEYWORD

ROOT="$(pwd)"
[ -d "$ROOT/.anvil" ] || { echo "Success"; exit 0; }

INPUT="${CLAUDE_USER_PROMPT:-}"
LOWER="$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//')"

match() {
  local prefix="$1" skill="$2"
  case "$LOWER" in
    "$prefix"*) echo "[MAGIC KEYWORD: $skill]"; exit 0 ;;
  esac
}

match "/anvil init"         "anvil-claude:init"
match "anvil init"          "anvil-claude:init"
match "/constitution"       "anvil-claude:constitution"
match "constitution verify" "anvil-claude:constitution"
match "/self-model"         "anvil-claude:self-model"
match "/adr"                "anvil-claude:adr"
match "/fmea"               "anvil-claude:fmea"
match "/gate-chain"         "anvil-claude:gate-chain"
match "/gate chain"         "anvil-claude:gate-chain"
match "/sprint"             "anvil-claude:sprint"
match "/structure"          "anvil-claude:structure"
match "/commit"             "anvil-claude:commit"
match "/research"           "anvil-claude:research"
match "/health"             "anvil-claude:health"
match "/trace"              "anvil-claude:trace"
match "/insight"            "anvil-claude:insight"

echo "Success"
