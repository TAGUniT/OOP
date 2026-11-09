#!/usr/bin/env bash
set -euo pipefail

# Launches Story.Editor.WinForms under Wine with the dedicated .NET prefix.
# Usage: scripts/run-editor.sh [--rebuild] [extra args passed to the exe]

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$REPO_ROOT/OOP/Story.Editor.WinForms/Story.Editor.WinForms.csproj"
PUBLISH_DIR="$REPO_ROOT/OOP/Story.Editor.WinForms/bin/Release/net10.0-windows/win-x64/publish"
EXE="$PUBLISH_DIR/Story.Editor.WinForms.exe"
WINEPREFIX="$HOME/.wine-dotnet"

if [[ "${1:-}" == "--rebuild" ]]; then
  shift
  if ! command -v dotnet >/dev/null 2>&1; then
    export PATH="$HOME/.dotnet:$PATH"
  fi
  (cd "$REPO_ROOT" && dotnet publish "$PROJECT" -c Release -r win-x64 --self-contained true)
fi

if [[ ! -f "$EXE" ]]; then
  echo "error: $EXE not found — run '$0 --rebuild' first." >&2
  exit 1
fi

exec env WINEPREFIX="$WINEPREFIX" wine "$EXE" "$@"
