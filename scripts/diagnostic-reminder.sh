#!/usr/bin/env bash
# PostToolUse:Edit/Write hook — remind agent to check IDE diagnostics

ROOT="$(pwd)"
[ -d "$ROOT/.anvil" ] || { echo "Success"; exit 0; }

echo "After modifying files, check IDE diagnostics with mcp__ide__getDiagnostics and fix any issues before proceeding."
