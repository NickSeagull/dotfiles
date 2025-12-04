#!/bin/sh

# Get the current aerospace workspace
if command -v aerospace >/dev/null 2>&1; then
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
else
  exit 0
fi

# Extract the workspace number from the item name (e.g., "space.1" -> "1")
WORKSPACE_ID="${NAME#*.}"

# Check if this workspace is the currently focused one
if [ "$WORKSPACE_ID" = "$CURRENT_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.drawing=on
else
  sketchybar --set "$NAME" background.drawing=off
fi
