#!/usr/bin/env bash
# Load locale strings from profile.yaml
# Usage: source locale/_load.sh [project_root]
# Sets: ANVIL_LOCALE (en|ko), sources the matching locale file

_LOCALE_ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
_LOCALE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ANVIL_LOCALE="en"
if [ -f "$_LOCALE_ROOT/.anvil/profile.yaml" ]; then
  _DETECTED=$(grep '^locale:' "$_LOCALE_ROOT/.anvil/profile.yaml" 2>/dev/null | sed 's/^locale: *//' | tr -d '[:space:]')
  [ -n "$_DETECTED" ] && ANVIL_LOCALE="$_DETECTED"
fi

# Fallback to en if locale file doesn't exist
# shellcheck source=en.sh
if [ -f "$_LOCALE_DIR/$ANVIL_LOCALE.sh" ]; then
  # shellcheck disable=SC1090
  source "$_LOCALE_DIR/$ANVIL_LOCALE.sh"
else
  source "$_LOCALE_DIR/en.sh"
fi
