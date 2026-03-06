#!/usr/bin/env bash
set -euo pipefail

# ╔═══════════════════════════════════════════════╗
# ║  Anvil Monitor — forge state at a glance      ║
# ║  The hammer (agent) strikes. The anvil holds.  ║
# ╚═══════════════════════════════════════════════╝

VERSION="0.0.12-alpha"

# ── Help ──
usage() {
  cat << 'HELP'

  ⚒  Anvil Monitor

  The hammer strikes, the anvil holds.
  See what's on the anvil right now.

  USAGE
    bash monitor.sh [options] [project_root]

  OPTIONS
    -h, --help      Show this help
    -v, --version   Show version
    --no-color      Disable color output
    --json          Output as JSON (for scripting)

  EXAMPLES
    bash monitor.sh                 # current project
    bash monitor.sh /path/to/repo   # specific project
    bash monitor.sh --json | jq .   # pipe to jq

  DASHBOARD SECTIONS
    Trace         Active execution recording (start/stop via /trace)
    Gate          Current quality gate in gate-chain sequence
    Heritage      Accumulated decisions (ADR) and failure patterns (FMEA)
    Guards        Learned runtime rules from past failures
    Constitution  Trust anchor integrity (checksum verification)
    Stack         Detected language, package manager, framework
    Git           Branch, commit, uncommitted file count

  WHEN TO USE
    - Sprint start   : check state before building
    - Gate failure    : see what's active, what's accumulated
    - Session start   : quick orientation on project health
    - Debugging       : verify trace is running, constitution intact

  SKILL INTEGRATION
    /health monitor         Run from health skill
    Sprint Step 1           Auto-runs at build cycle start
    session-context.sh      Lighter version injected on SessionStart

HELP
  exit 0
}

# ── Args ──
NO_COLOR=false
JSON_MODE=false
ROOT=""

for arg in "$@"; do
  case "$arg" in
    -h|--help) usage ;;
    -v|--version) echo "anvil-monitor $VERSION"; exit 0 ;;
    --no-color) NO_COLOR=true ;;
    --json) JSON_MODE=true ;;
    -*) echo "Unknown option: $arg"; usage ;;
    *) ROOT="$arg" ;;
  esac
done

ROOT="${ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ANVIL="$ROOT/.anvil"

# Load locale
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/locale/_load.sh" "$ROOT"

if [ ! -d "$ANVIL" ]; then
  if [ "$JSON_MODE" = true ]; then
    echo '{"error":"no .anvil/ directory"}'
  else
    echo "No .anvil/ directory found. Run /anvil-claude:init first."
  fi
  exit 1
fi

# ── Colors ──
if [ "$NO_COLOR" = true ] || [ ! -t 1 ]; then
  BOLD="" DIM="" GREEN="" YELLOW="" RED="" CYAN="" RESET=""
else
  BOLD="\033[1m" DIM="\033[2m" GREEN="\033[32m"
  YELLOW="\033[33m" RED="\033[31m" CYAN="\033[36m" RESET="\033[0m"
fi

divider() { printf "${DIM}%-52s${RESET}\n" "" | tr ' ' '-'; }

# ── Collect Data ──

# Trace
TRACE_STATUS="inactive"
TRACE_ID=""
TRACE_BASELINE=""
TRACE_STARTED=""
TRACE_PAST=0
if [ -f "$ANVIL/traces/.active" ]; then
  TRACE_STATUS="active"
  TRACE_FILE=$(cat "$ANVIL/traces/.active")
  TRACE_ID=$(basename "$TRACE_FILE" .md)
  TRACE_BASELINE=$(grep '^\- \*\*Baseline:\*\*' "$TRACE_FILE" 2>/dev/null | sed 's/.*\*\* //' || echo "?")
  TRACE_STARTED=$(grep '^\- \*\*Started:\*\*' "$TRACE_FILE" 2>/dev/null | sed 's/.*\*\* //' || echo "?")
fi
TRACE_PAST=$(find "$ANVIL/traces" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

# Gate
GATE_CURRENT=""
[ -f "$ANVIL/checks/.current-gate" ] && GATE_CURRENT=$(cat "$ANVIL/checks/.current-gate" | tr -d '[:space:]')

# Heritage
ADR_COUNT=0
FMEA_COUNT=0
[ -f "$ANVIL/decisions/active.md" ] && ADR_COUNT=$(grep -c '^\- \*\*' "$ANVIL/decisions/active.md" 2>/dev/null || echo 0)
[ -f "$ANVIL/failures/active.md" ] && FMEA_COUNT=$(grep -c '^\- \*\*' "$ANVIL/failures/active.md" 2>/dev/null || echo 0)
ADR_COUNT=$(echo "$ADR_COUNT" | tr -d '[:space:]')
FMEA_COUNT=$(echo "$FMEA_COUNT" | tr -d '[:space:]')

# Guards
GUARD_COUNT=0
if [ -f "$ANVIL/checks/guards.md" ]; then
  GUARD_COUNT=$(grep -c '^## G-' "$ANVIL/checks/guards.md" 2>/dev/null || echo 0)
  GUARD_COUNT=$(echo "$GUARD_COUNT" | tr -d '[:space:]')
fi

# Constitution
CONST_STATUS="missing"
if [ -f "$ANVIL/constitution.md" ]; then
  CONST_STATUS="present"
  if [ -f "$ANVIL/.constitution.sha256" ]; then
    EXPECTED=$(cat "$ANVIL/.constitution.sha256" | awk '{print $1}')
    ACTUAL=$(shasum -a 256 "$ANVIL/constitution.md" | awk '{print $1}')
    if [ "$EXPECTED" = "$ACTUAL" ]; then
      CONST_STATUS="intact"
    else
      CONST_STATUS="modified"
    fi
  fi
fi

# Stack
STACK_PKG=""
STACK_LANG=""
STACK_FW=""
if [ -f "$ANVIL/profile.yaml" ]; then
  STACK_PKG=$(grep '^pkg:' "$ANVIL/profile.yaml" 2>/dev/null | sed 's/^pkg: *//' || echo "")
  STACK_LANG=$(grep '^language:' "$ANVIL/profile.yaml" 2>/dev/null | sed 's/^language: *//' || echo "")
  STACK_FW=$(grep '^framework:' "$ANVIL/profile.yaml" 2>/dev/null | sed 's/^framework: *//' || echo "none")
fi

# Git
GIT_BRANCH=""
GIT_COMMIT=""
GIT_DIRTY=0
if git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_BRANCH=$(git -C "$ROOT" branch --show-current 2>/dev/null || echo "detached")
  GIT_COMMIT=$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo "?")
  GIT_DIRTY=$(git -C "$ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
fi

# ── JSON Output ──
if [ "$JSON_MODE" = true ]; then
  cat << EOF
{
  "trace": {"status":"$TRACE_STATUS","id":"$TRACE_ID","baseline":"$TRACE_BASELINE","started":"$TRACE_STARTED","past_count":$TRACE_PAST},
  "gate": {"current":"${GATE_CURRENT:-null}"},
  "heritage": {"adr":$ADR_COUNT,"fmea":$FMEA_COUNT},
  "guards": {"count":$GUARD_COUNT},
  "constitution": {"status":"$CONST_STATUS"},
  "stack": {"pkg":"$STACK_PKG","language":"$STACK_LANG","framework":"$STACK_FW"},
  "git": {"branch":"$GIT_BRANCH","commit":"$GIT_COMMIT","dirty":$GIT_DIRTY}
}
EOF
  exit 0
fi

# ── Display ──
echo ""
printf "${BOLD}${CYAN}  $L_MONITOR_TITLE${RESET}  ${DIM}v$VERSION${RESET}\n"
divider

# Trace
printf "  ${BOLD}%-13s${RESET} " "$L_TRACE"
if [ "$TRACE_STATUS" = "active" ]; then
  printf "${GREEN}$L_TRACE_ACTIVE${RESET} %s\n" "$TRACE_ID"
  printf "                 baseline: %s  started: %s\n" "$TRACE_BASELINE" "$TRACE_STARTED"
else
  printf "${DIM}$L_TRACE_INACTIVE${RESET} (%s $L_TRACE_PAST)\n" "$TRACE_PAST"
fi

# Gate
printf "  ${BOLD}%-13s${RESET} " "$L_GATE"
if [ -n "$GATE_CURRENT" ]; then
  printf "${YELLOW}%s${RESET}\n" "$GATE_CURRENT"
else
  printf "%s\n" "${DIM}$L_GATE_NONE${RESET}"
fi

# Heritage
printf "  ${BOLD}%-13s${RESET} ADR ${BOLD}%s${RESET} | FMEA ${BOLD}%s${RESET}\n" "$L_HERITAGE" "$ADR_COUNT" "$FMEA_COUNT"

# Guards
printf "  ${BOLD}%-13s${RESET} " "$L_GUARDS"
if [ "$GUARD_COUNT" -gt 0 ]; then
  printf "%s $L_GUARDS_RULES\n" "$GUARD_COUNT"
else
  printf "%s\n" "${DIM}$L_GUARDS_NONE${RESET}"
fi

# Constitution
printf "  ${BOLD}%-13s${RESET} " "$L_CONSTITUTION"
case "$CONST_STATUS" in
  intact)   printf "${GREEN}$L_CONST_INTACT${RESET}\n" ;;
  modified) printf "${RED}$L_CONST_MODIFIED${RESET}\n" ;;
  present)  printf "${YELLOW}$L_CONST_PRESENT${RESET}\n" ;;
  missing)  printf "${DIM}$L_CONST_MISSING${RESET}\n" ;;
esac

# Stack
printf "  ${BOLD}%-13s${RESET} " "$L_STACK"
if [ -n "$STACK_LANG" ]; then
  printf "%s/%s" "$STACK_LANG" "$STACK_PKG"
  [ "$STACK_FW" != "none" ] && [ -n "$STACK_FW" ] && printf " + %s" "$STACK_FW"
  printf "\n"
else
  printf "${DIM}$L_STACK_NONE${RESET}\n"
fi

# Git
printf "  ${BOLD}%-13s${RESET} " "$L_GIT"
if [ -n "$GIT_BRANCH" ]; then
  printf "%s @ %s" "$GIT_BRANCH" "$GIT_COMMIT"
  [ "$GIT_DIRTY" -gt 0 ] && printf " ${YELLOW}(%s $L_GIT_UNCOMMITTED)${RESET}" "$GIT_DIRTY"
  printf "\n"
else
  printf "${DIM}$L_GIT_NONE${RESET}\n"
fi

divider
printf "  ${DIM}$L_HELP_HINT${RESET}\n"
echo ""
