#!/bin/bash
# focus-or-start: Focus an app if running, launch it if not
# Usage: focus-or-start.sh App Name  (multi-word names supported)
#
# macOS only — uses `open -a` which handles both cases natively:
#   - App running → brings to front
#   - App not running → launches it

APP_NAME="$*"

if [ -z "$APP_NAME" ]; then
  echo "Usage: $0 <app-name>" >&2
  exit 1
fi

open -a "$APP_NAME" 2>/dev/null
