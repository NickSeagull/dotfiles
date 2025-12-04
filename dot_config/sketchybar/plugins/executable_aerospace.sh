#!/bin/sh

# FOCUSED_WORKSPACE is passed as an environment variable from aerospace
# via: sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE

if [ -z "$FOCUSED_WORKSPACE" ]; then
  # Fallback to querying aerospace if env var not set
  if command -v aerospace >/dev/null 2>&1; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
  else
    exit 0
  fi
fi

# Update all workspace items
for i in 1 2 3 4 5 6 7 8 9 0; do
  if [ "$i" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set space.$i background.drawing=on
  else
    sketchybar --set space.$i background.drawing=off
  fi
done
