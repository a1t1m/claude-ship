#!/usr/bin/env bash
# Install the `ship` skill for Claude Code.
set -euo pipefail

DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -d "$HERE/ship" ]; then
  echo "install.sh: no ship/ directory next to this script" >&2
  exit 1
fi

mkdir -p "$DEST"
if [ -e "$DEST/ship" ]; then
  echo "→ existing $DEST/ship backed up to ship.bak.$(date +%s)"
  mv "$DEST/ship" "$DEST/ship.bak.$(date +%s)"
fi

cp -r "$HERE/ship" "$DEST/ship"
chmod +x "$DEST"/ship/bin/*
echo "→ installed to $DEST/ship"
echo
"$DEST/ship/bin/ship-preflight" || true
echo
echo "Restart Claude Code, then run:  /ship \"your task\""
